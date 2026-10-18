// Neural voice (Piper, pt-BR) in a worker: espeak-ng phonemes → VITS model in ONNX Runtime → PCM.
// Everything is downloaded once and kept in Cache Storage, so it also works offline afterwards.
const ORT = 'https://cdn.jsdelivr.net/npm/onnxruntime-web@1.18.0/dist/';
const PH = 'https://cdn.jsdelivr.net/npm/@diffusionstudio/piper-wasm@1.0.0/build/';
const HF = ['https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/', 'https://huggingface.co/rhasspy/piper-voices/resolve/main/',
  'https://huggingface.co/diffusionstudio/piper-voices/resolve/main/'];
// The pt-BR medium voices of piper-voices; one is kept in memory at a time.
const VOICES = Object.fromEntries(['faber', 'cadu', 'jeff'].map(v =>
  [v, HF.map(h => `${h}pt/pt_BR/${v}/medium/pt_BR-${v}-medium.onnx`)]));
const CACHE = 'gramado-voz';
let runtime = null, ready = null, current = null, session = null, cfg = null, phUrls = null;

async function get(url, onBytes) {
  const cache = await caches.open(CACHE);
  const hit = await cache.match(url);
  if (hit) { const b = await hit.arrayBuffer(); onBytes && onBytes(b.byteLength); return b; }
  const resp = await fetch(url);
  if (!resp.ok) throw new Error(resp.status + ' ' + url);
  const reader = resp.body.getReader(), parts = [];
  let n = 0;
  for (;;) {
    const { done, value } = await reader.read();
    if (done) break;
    parts.push(value); n += value.length; onBytes && onBytes(value.length, true);
  }
  const buf = await new Blob(parts).arrayBuffer();
  await cache.put(url, new Response(buf, { headers: { 'Content-Type': resp.headers.get('Content-Type') || 'application/octet-stream' } }));
  return buf;
}
// The model has mirrors: use the first one that answers.
async function getAny(urls, onBytes) {
  let err;
  for (const u of urls) { try { return await get(u, onBytes); } catch (e) { err = e; } }
  throw err;
}
const blobUrl = (buf, type) => URL.createObjectURL(new Blob([buf], { type }));

// ONNX Runtime and the phonemizer are shared by every voice.
function loadRuntime(tick) {
  if (runtime) return runtime;
  runtime = (async () => {
    const [ortJs, ortWasm, phJs, phWasm, phData] = await Promise.all([
      get(ORT + 'ort.wasm.min.js', tick), get(ORT + 'ort-wasm-simd.wasm', tick),
      get(PH + 'piper_phonemize.js', tick), get(PH + 'piper_phonemize.wasm', tick), get(PH + 'piper_phonemize.data', tick)
    ]);
    importScripts(blobUrl(ortJs, 'text/javascript'), blobUrl(phJs, 'text/javascript'));
    phUrls = { wasm: blobUrl(phWasm, 'application/wasm'), data: blobUrl(phData, 'application/octet-stream') };
    // No cross-origin isolation on GitHub Pages: single thread, plain SIMD build.
    ort.env.wasm.numThreads = 1;
    ort.env.wasm.wasmPaths = { 'ort-wasm-simd.wasm': blobUrl(ortWasm, 'application/wasm') };
  })();
  runtime.catch(() => { runtime = null; });
  return runtime;
}

function load(voice) {
  if (ready && current === voice) return ready;
  // Sizes are only for the progress bar; the real totals come from the downloads.
  const total = 64e6 + (runtime ? 0 : 29.6e6);
  let loaded = 0, last = 0;
  const tick = n => {
    loaded += n;
    if (loaded - last > 5e5 || loaded >= total) { last = loaded; postMessage({ type: 'progress', voice, loaded: Math.min(loaded, total), total }); }
  };
  current = voice;
  const prev = session; session = null;
  ready = (async () => {
    if (prev) await prev.release().catch(() => {});
    const [model, json] = await Promise.all([getAny(VOICES[voice], tick), getAny(VOICES[voice].map(u => u + '.json')), loadRuntime(tick)]);
    cfg = JSON.parse(new TextDecoder().decode(json));
    session = await ort.InferenceSession.create(new Uint8Array(model), { executionProviders: ['wasm'] });
  })();
  ready.catch(() => { if (current === voice) ready = null; });
  return ready;
}

// piper_phonemize is a CLI build: a fresh module per call, ids arrive on stdout.
function phonemize(text) {
  return new Promise((resolve, reject) => {
    createPiperPhonemize({
      print: out => { try { resolve(toIds(JSON.parse(out).phonemes)); } catch (e) { reject(e); } },
      printErr: m => reject(new Error(m)),
      locateFile: f => f.endsWith('.wasm') ? phUrls.wasm : f.endsWith('.data') ? phUrls.data : f
    }).then(m => m.callMain(['-l', cfg.espeak.voice, '--input', JSON.stringify([{ text }]), '--espeak_data', '/espeak-ng-data']), reject);
  });
}

// Map with the model's own table (older voices have fewer symbols than piper's default).
function toIds(phonemes) {
  const map = cfg.phoneme_id_map, ids = [...map['^'], ...map['_']];
  for (const p of [...phonemes.flat().join('')]) if (map[p]) ids.push(...map[p], ...map['_']);
  ids.push(...map['$']);
  return ids;
}

async function say(text, rate) {
  const ids = await phonemize(text);
  const inf = cfg.inference;
  const feeds = {
    input: new ort.Tensor('int64', BigInt64Array.from(ids.map(BigInt)), [1, ids.length]),
    input_lengths: new ort.Tensor('int64', BigInt64Array.from([BigInt(ids.length)]), [1]),
    scales: new ort.Tensor('float32', Float32Array.from([inf.noise_scale, inf.length_scale / (rate || 1), inf.noise_w]), [3])
  };
  if (cfg.num_speakers > 1) feeds.sid = new ort.Tensor('int64', BigInt64Array.from([0n]), [1]);
  const { output } = await session.run(feeds);
  return output.data;
}

onmessage = async ({ data: m }) => {
  try {
    if (m.type === 'load') { await load(m.voice); postMessage({ type: 'ready', id: m.id, voice: m.voice }); }
    if (m.type === 'say') {
      await load(m.voice);
      const pcm = await say(m.text, m.rate);
      postMessage({ type: 'audio', id: m.id, pcm, rate: cfg.audio.sample_rate }, [pcm.buffer]);
    }
  } catch (e) {
    postMessage({ type: 'error', id: m.id, msg: String(e && e.message || e) });
  }
};

# Amostras sintetizadas no navegador

Estas amostras saíram do próprio `voz.js` do app (branch `claude/hopeful-meitner-3od1eu`, commit e14189b), executado num Worker do Chromium headless via Playwright. O ONNX Runtime Web 1.18.0 e o piper-wasm 1.0.0 vieram do npm, servidos no lugar do jsDelivr; os modelos foram baixados do Hugging Face real. A configuração é a do app: WASM, 1 thread, Kokoro `model_quantized`. A CPU era de desktop com 4 núcleos, então um celular deve ser mais lento.

Texto: "Olá, Luciano e Greice! Bem-vindos a Gramado. Hoje à tarde vocês vão ao Snowland." (15 palavras). O WER foi medido transcrevendo de volta com faster-whisper small. Os 13% de base vêm de "Greice" virar "Grace" e "à" virar "a".

| Arquivo | Voz | Carga (1ª vez, com download) | Síntese | Áudio | WER |
|---|---|---|---|---|---|
| dora.mp3 | Kokoro pf_dora | 7,7 s | 21,8 s | 4,9 s | 20% |
| alex.mp3 | Kokoro pm_alex | 0,9 s (modelo já carregado) | 20,3 s | 5,0 s | 13% |
| santa.mp3 | Kokoro pm_santa | 1,2 s | 21,9 s | 5,1 s | 13% |
| dii.mp3 | Piper dii | 7,8 s | 2,5 s | 5,1 s | 27% |
| miro.mp3 | Piper miro | 7,4 s | 2,5 s | 4,8 s | 20% (volume baixo: pico 0,12) |

Com 4 threads (cross-origin isolation, `ort-wasm-simd-threaded.wasm`), o Kokoro levou 13–14 s e o dii 1,0 s para as mesmas frases. As outras variantes do Kokoro em 1 thread (fp16, q8f16, uint8) também ficaram em 19–21 s.

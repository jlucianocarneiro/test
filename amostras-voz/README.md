# Amostras das vozes Piper pt-BR

Mesmo texto nas três vozes `medium` de rhasspy/piper-voices (tag v1.0.0), 22 050 Hz, MP3 64 kbps.
Geradas com o CLI/biblioteca `piper-tts` (Python, CPU), não com `voz.js` — o jsDelivr estava bloqueado no ambiente.

| Arquivo | Voz | length_scale | Duração | Síntese (CPU, 4 núcleos) |
|---|---|---|---|---|
| pt_BR-faber.mp3 | faber | 1.0 | 10,6 s | 1,20 s |
| pt_BR-faber-lento.mp3 | faber | 1.15 | 11,6 s | 0,87 s |
| pt_BR-cadu.mp3 | cadu | 1.0 | 13,5 s | 0,98 s |
| pt_BR-jeff.mp3 | jeff | 1.0 | 15,6 s | 1,30 s |

Dataset: NabuCasa/voice-datasets, licença CC0 (MODEL_CARD de cada voz). Ajustadas a partir da voz en_US lessac (medium).

# Amostras de vozes pt-BR

Todas leem o mesmo texto e foram convertidas para MP3 64 kbps. A síntese rodou fora do navegador (CPU com 4 núcleos), porque o jsDelivr estava bloqueado no ambiente. As vozes Piper foram geradas com `piper-tts` (Python). Kokoro e MMS rodaram com `onnxruntime`, usando os mesmos arquivos ONNX que o navegador baixaria.

"WER (Whisper)" é a taxa de palavras erradas quando a amostra é transcrita de volta pelo `faster-whisper small`. Serve como indicador aproximado de inteligibilidade; também conta como erro "11" no lugar de "onze" e grafias de nomes próprios.

| Arquivo | Modelo / voz | Licença | Tamanho do modelo | Síntese | Áudio | WER (Whisper) |
|---|---|---|---|---|---|---|
| kokoro-pm_alex.mp3 | Kokoro-82M v1.0, pm_alex (masc.) | Apache-2.0 | 326 MB fp32 (fp16 163 MB, q8f16 86 MB) + voz 0,5 MB | 4,7 s | 10,9 s | 9% |
| kokoro-pf_dora.mp3 | Kokoro-82M v1.0, pf_dora (fem.) | Apache-2.0 | idem | 5,8 s | 11,1 s | 14% |
| kokoro-pm_santa.mp3 | Kokoro-82M v1.0, pm_santa (masc.) | Apache-2.0 | idem | 4,7 s | 11,1 s | 14% |
| kokoro-pf_dora-q8.mp3 | Kokoro-82M, modelo `model_quantized` (int8) | Apache-2.0 | 92 MB | 20,4 s | 11,0 s | 14% |
| mms-por.mp3 | facebook/mms-tts-por (VITS), ONNX Xenova | CC-BY-NC-4.0 | 114 MB (q8 38 MB) | 4,1 s | 15,5 s | 26% |
| piper-dii.mp3 | OpenVoiceOS/pipertts_pt-BR_dii (fem.) | CC-BY-NC-ND-4.0 | 63,5 MB | 1,0 s | 11,5 s | 31% |
| piper-miro.mp3 | OpenVoiceOS/pipertts_pt-BR_miro (masc.) | CC-BY-NC-ND-4.0 | 63,5 MB | 1,0 s | 11,5 s | 37% |
| piper-edresson.mp3 | rhasspy pt_BR edresson **low**, 16 kHz | dataset CC BY 4.0 | 63,1 MB | 0,9 s | 16,0 s | 57% |
| pt_BR-cadu.mp3 | rhasspy pt_BR cadu medium | dataset CC0 | 63,0 MB | 1,0 s | 13,5 s | 40% |
| pt_BR-jeff.mp3 | rhasspy pt_BR jeff medium | dataset CC0 | 63,0 MB | 1,3 s | 15,6 s | 40% |
| pt_BR-faber.mp3 | rhasspy pt_BR faber medium | dataset CC0 | 63,2 MB | 1,2 s | 10,6 s | 43% |
| pt_BR-faber-lento.mp3 | faber com length_scale 1.15 | dataset CC0 | 63,2 MB | 0,9 s | 11,6 s | — |

Observações:
- **Kokoro**: os fonemas vêm do espeak-ng `pt-br`, o mesmo espeak-ng que `voz.js` já carrega via piper-wasm, mapeados para o vocabulário do Kokoro (`dʒ→ʤ`, `tʃ→ʧ`). A versão int8 ficou cerca de 4× mais lenta em CPU.
- **MMS**: o vocabulário de caracteres não tem `k` nem `w`, e `à` é o token de *padding*. Por isso "check-in", "Snowland" e "à/às" saem errados. A pontuação é descartada, então a fala sai sem pausas. A saída é de 16 kHz.
- **edresson**: usa o conjunto antigo de 130 símbolos, sem o til de nasalização (`̃`), e por isso perde as vogais nasais.
- **dii/miro**: foram ajustadas a partir de vozes pt-PT com dados sintéticos pt-BR. São vozes de pessoas reais, de propriedade da TigreGotico (licença NC-ND).

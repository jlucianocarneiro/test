# Guia Gramado 2026

PWA com o roteiro hora a hora da viagem a Gramado/RS (sáb 24 a sáb 31/10/2026): timeline por dia com destaque da atividade "Agora", checklist, guia IA com foto e voz, clima (Open-Meteo) e distâncias com atalhos para Mapa e Uber.

## Publicar no GitHub Pages

1. Em **Settings → Pages**, escolha *Deploy from a branch*, a branch com estes arquivos e a pasta `/ (root)`.
2. Abra `https://<usuario>.github.io/<repo>/` no celular.
3. Instale: Safari → Compartilhar → *Adicionar à Tela de Início*; Chrome → ⋮ → *Instalar app*.

## Guia IA (foto, voz e leitura em voz alta)

- 📷 **Foto**: fotografe um prato, construção ou objeto; a IA identifica e conta definição, história e ligação com a cultura local.
- 🎤 **Voz**: pergunte falando (ditado do navegador; se bloqueado, use o microfone do teclado).
- 🔊 **Leitura**: respostas de foto e voz são lidas em voz alta, com player (pausar/parar) visível em todas as abas.

Qual IA responde:
1. Aberto pelo **link do Claude** (artefato): usa a conta Claude do viajante, sem chave.
2. **GitHub Pages**: configure uma chave Anthropic ou OpenAI em Info → Configurações (fica só no aparelho).
3. Sem nenhuma das duas: base local (texto), sem fotos.

## Rotas e Uber

Toque num item do roteiro (ou veja a aba Local) para abrir a rota até o lugar:
- até 1,2 km: **🚶 Ir a pé** (Google Maps, com tempo estimado);
- acima disso: **🚗 Chamar Uber** em destaque, já com o destino preenchido.

A origem considerada é o local atual (GPS ou "Ou estou em"); sem isso, o lugar anterior do roteiro do dia ou o hotel.
Os links do Uber usam coordenadas aproximadas: abra cada um antes da viagem e confira o pino (item do checklist).

## Versão completa (GPS e voz)

Dentro do Claude (artefato) o celular não libera GPS nem microfone. O guia então mostra **🌐 Abrir o guia no navegador**, que leva para https://jlucianocarneiro.github.io/test/ levando junto o checklist e o local escolhido. Para esse endereço funcionar, ative o GitHub Pages neste repositório.

## Clima e GPS

No GitHub Pages (HTTPS próprio) clima e GPS funcionam normalmente. Se o GPS falhar ou for bloqueado (por exemplo, dentro do artefato do claude.ai), escolha o ponto atual na lista "Ou estou em" para ver as distâncias; a escolha fica salva. Sem previsão online, o clima mostra a média típica de outubro (8°–18°C).

## Voz fluida (neural)

Em Info › Configurações, "Voz da guia" → "✨ Fluida (neural)" baixa uma vez (~90 MB) a voz
`pt_BR-faber-medium` do projeto aberto [Piper](https://github.com/rhasspy/piper) e passa a ler as
respostas com ela. Tudo roda no próprio celular, em `voz.js` (Web Worker):

- fonemas: espeak-ng em WebAssembly (`@diffusionstudio/piper-wasm@1.0.0`, jsDelivr);
- síntese: ONNX Runtime Web 1.18.0 (jsDelivr), modelo do Hugging Face (`rhasspy/piper-voices`);
- os arquivos ficam no Cache Storage `gramado-voz` (o service worker preserva) e funcionam offline.

Sem a voz baixada, ou dentro do visualizador do Claude, a leitura usa a melhor voz pt-BR do aparelho
(prioriza as "Natural"/"Online", Google e "Premium"). Uso pessoal, sem fins comerciais.

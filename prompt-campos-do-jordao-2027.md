# Prompt — Guia Campos do Jordao 2027

> Prompt completo para gerar uma PWA single-file de roteiro interativo de viagem.
> Baseado no projeto "Guia Gramado 2026" (referencia: `/home/user/test/index.html`).

---

## 1. Contexto do projeto

Crie uma PWA completa em um unico arquivo `index.html` — um guia de viagem interativo para **Campos do Jordao/SP**, no estilo do "Guia Gramado 2026" ja existente neste repositorio.

### Viajantes

- **3 casais** (6 pessoas no total):
  - Casal 1: `[NOME_CASAL_1_PESSOA_A]` e `[NOME_CASAL_1_PESSOA_B]`
  - Casal 2: `[NOME_CASAL_2_PESSOA_A]` e `[NOME_CASAL_2_PESSOA_B]`
  - Casal 3: `[NOME_CASAL_3_PESSOA_A]` e `[NOME_CASAL_3_PESSOA_B]`

### Periodo

- **Mes**: Fevereiro de 2027
- **Datas exatas**: `[DATA_CHEGADA]` a `[DATA_PARTIDA]` (preencher apos definir)
- **Estacao**: Verao serrano — temperaturas amenas (15-25°C), chuvas frequentes a tarde
- **Alta temporada**: Sim (fevereiro e ferias)

### Transporte

- **Voos**: Passagens ja compradas (detalhes abaixo)
- **Local**: Definir — carro alugado (recomendado para 6 pessoas, 2 carros ou van) ou Uber/taxi
- **Aeroporto provavel**: Sao Jose dos Campos (SJK) ou Guarulhos (GRU) + transfer terrestre (~170 km de GRU, ~100 km de SJK)

### Orcamento

- **Nivel**: `[ECONOMICO / MODERADO / CONFORTAVEL / SEM LIMITE]`
- **Divisao**: Por casal ou rateio total entre os 6
- **Hospedagem**: `[HOTEL / POUSADA / AIRBNB / JA RESERVADO — informar nome e endereco]`

---

## 2. Voos (preencher)

### Ida

| Campo | Valor |
|---|---|
| Companhia | `[EX: LATAM]` |
| Voo | `[EX: LA3456]` |
| Origem | `[EX: BSB]` |
| Destino | `[EX: GRU ou SJK]` |
| Data | `[EX: 12/02/2027]` |
| Embarque | `[EX: 08:30]` |
| Chegada | `[EX: 10:45]` |
| Reserva/Localizador | `[CODIGO]` |

### Volta

| Campo | Valor |
|---|---|
| Companhia | `[EX: LATAM]` |
| Voo | `[EX: LA3457]` |
| Origem | `[EX: GRU ou SJK]` |
| Destino | `[EX: BSB]` |
| Data | `[EX: 16/02/2027]` |
| Embarque | `[EX: 18:00]` |
| Chegada | `[EX: 20:15]` |
| Reserva/Localizador | `[CODIGO]` |

> **Nota**: Se os 3 casais estiverem em voos diferentes, criar uma tabela por casal.

---

## 3. Funcionalidades obrigatorias (herdar do Guia Gramado)

A PWA deve ter **todas** as funcionalidades do Guia Gramado 2026:

### 3.1 Roteiro interativo

- **Carrossel horizontal de dias** com scroll-snap (1 painel por dia)
- **Barra de abas sticky** com dia da semana, numero e indicador "hoje"
- **Itens do roteiro** com: horario, nome, descricao, tags, icone/emoji
- **Checkbox "feito"** em cada item (persistido em localStorage)
- **Mover tarefa** entre dias (modal com opcoes de dia)
- **Editar tarefa** (horario, nome, descricao)
- **Excluir tarefa** (com confirmacao)
- Funcao `getEffectiveDays()` que aplica moves, edits e deletes sobre o const `DAYS` sem mutar o original

### 3.2 Guia IA (chat)

- Input de texto com botao enviar
- Cascata de providers: `window.claude.use('sample')` → chave API do usuario → KB local
- **Base de conhecimento local (KB)**: array de objetos `{k:[palavras-chave], a:"resposta"}` com 40+ entradas sobre Campos do Jordao
- `buildSystemPrompt()` que injeta roteiro atual (com itens feitos marcados `[FEITO]`), clima, e contexto
- max_tokens: 2048
- Historico de mensagens no chat
- **Regra**: a IA nao deve insistir em descontos profissionais ou institucionais

### 3.3 Aba Grupo — Discussao

- **Chat entre viajantes** (mensagens com autor, texto, timestamp)
- **Sugestao de passeios** com formulario (nome, tipo, custo, observacoes)
- **Fichas** com icone por categoria, votacao, badge "no roteiro"
- **Deteccao de duplicatas** (checar fichas existentes, PLACES e FREE)
- **Adicionar ao roteiro** (escolher dia via modal)
- **Remover do roteiro** e **excluir ficha**
- Persistencia em localStorage (chave `campos-disc`)
- Warning de duplicata dentro do modal de sugestao

### 3.4 Mapa interativo

- **Leaflet 1.9.4** + protomaps-leaflet + pmtiles
- Tiles offline: `lib/campos.pmtiles` (a gerar)
- **Marcadores coloridos** por tipo de estabelecimento (emoji + cor)
- **POINTS**: array com pontos-chave do roteiro (lat/lng)
- **PLACES**: array com 30+ estabelecimentos da regiao (restaurantes, cafes, atracoes, lojas)
- Geolocalizacao do usuario
- Botao de centralizar

### 3.5 Clima em tempo real

- API Open-Meteo (gratuita, sem chave)
- Banner no topo com temperatura e condicao atual
- Cache de 15 minutos
- **Painel horario expansivel** (proximas 12h)
- Fallback com clima tipico de fevereiro: "Verao serrano: 15-25°C, chuvas rapidas a tarde"

### 3.6 Info / Utilidades

- Dados do voo (ida e volta)
- Dados da hospedagem
- Contatos de emergencia (policia, bombeiros, hospital local)
- Lista de atracoes gratuitas (`FREE`)
- Secao "Erros comuns" com dicas
- Informacoes sobre o cartao Prime 2x1 (se aplicavel) ou equivalente local

### 3.7 Checklist de mala (`PACK`)

- Itens categorizados (documentos, roupas, higiene, eletronicos, extras)
- Checkbox persistido
- Progresso visual (X de Y)
- Adaptado para **verao serrano** (noites frescas, chuvas, trilhas)

### 3.8 PWA / Offline

- `manifest.json` com nome, icones, cores, display standalone
- `sw.js` com estrategia network-first para HTML, cache-first para assets
- Tiles do mapa offline via pmtiles
- Funcionar 100% sem internet apos primeiro carregamento (exceto IA com API e clima)

### 3.9 Navegacao

- **6 abas** na barra inferior: Roteiro, Guia IA, Grupo, Local, Info, Check
- Icones emoji consistentes
- Tab ativa destacada com cor accent
- Transicao suave entre secoes

---

## 4. Conteudo especifico — Campos do Jordao

### 4.1 Sobre a cidade

- Campos do Jordao/SP, Serra da Mantiqueira, ~1.700m de altitude
- Conhecida como "Suica brasileira"
- Vila Capivari: centro turistico com restaurantes, lojas e vida noturna
- Clima: mesmo no verao, noites podem chegar a 10-15°C

### 4.2 Categorias de PLACES (sugestao inicial — pesquisar e validar)

Incluir **30-40 estabelecimentos** nas categorias:

| Categoria | Emoji | Cor | Exemplos para pesquisar |
|---|---|---|---|
| Gastronomia fina | 🍷 | `#8e44ad` | Baden Baden, Matterhorn, Casa da Viuva |
| Cafe/Chocolate | ☕ | `#6d4c41` | Chocolataria Montanhes, Cafe do Pico |
| Cervejaria | 🍺 | `#d4a017` | Baden Baden (fabrica), Serra Valley |
| Churrasco/Fondue | 🥩 | `#c0392b` | Churrascaria Boi na Brasa, fondue varies |
| Pizza/Italiano | 🍕 | `#e67e22` | Pesquisar opcoes locais |
| Atracoes | 🎭 | `#2980b9` | Horto Florestal, Pedra do Bau, Teleferico |
| Natureza/Trilhas | 🌿 | `#27ae60` | Pico do Itapeva, Ducha de Prata, trilhas |
| Compras | 🛍️ | `#e84393` | Malharia, Vila Capivari lojas |
| Romance | 💑 | `#e74c3c` | Pontos para casais |

### 4.3 Atracoes gratuitas (`FREE`) — pesquisar e validar

- Ducha de Prata
- Vista Chinesa
- Portal de Campos do Jordao
- Praca de Capivari
- Bosque do Silencio
- Pico do Itapeva (acesso livre, estacionamento pago)
- Trilha da Cachoeira (verificar)
- Feira de artesanato
- Cervejaria Baden Baden (visita externa)
- Mirante do Morro do Elefante (base)

### 4.4 Sugestao de roteiro (pesquisar, validar e ajustar)

> O roteiro deve ser pesquisado e montado com base em:
> - Distancias reais entre pontos (usar Google Maps)
> - Horarios de funcionamento atualizados
> - Precos de 2026/2027
> - Logistica para 6 pessoas (reservas, mesas grandes, transporte)
> - Equilibrio: 1 atracoes pagas + 1 gratuita + refeicoes por turno

**Estrutura por dia**:

```
DIA 1 (chegada): Transfer do aeroporto → hotel → almoço → Vila Capivari (passeio leve)
DIA 2: Manhã — Horto Florestal / Trilha. Tarde — Atração (Teleférico/Morro do Elefante). Noite — Jantar especial
DIA 3: Manhã — Pico do Itapeva ou Pedra do Baú. Tarde — Ducha de Prata. Noite — Cervejaria/Fondue
DIA 4: Manhã — Compras/chocolate. Tarde — Atividade em grupo. Noite — Jantar de despedida
DIA 5 (partida): Café da manhã → checkout → últimas fotos → transfer aeroporto
```

> **IMPORTANTE**: O numero de dias depende das datas dos voos. Ajustar quando preenchidos.

### 4.5 Base de conhecimento da IA (KB) — 40+ entradas

Pesquisar e incluir entradas sobre:

- Historia de Campos do Jordao (origem alema, tuberculose, turismo)
- Vila Capivari (o que fazer, horarios, dicas)
- Horto Florestal / Parque Estadual (trilhas, horarios, ingressos)
- Pico do Itapeva (altitude, vista, acesso)
- Pedra do Bau (trilha, dificuldade, equipamento)
- Teleferico e Morro do Elefante
- Ducha de Prata (historia, acesso)
- Palacio Boa Vista (museu do governo, horarios)
- Festival de Inverno (se houver edicao verao)
- Gastronomia: fondue, truta, pinhao, cerveja artesanal
- Baden Baden (historia, visita a fabrica, cardapio)
- Clima de fevereiro (chuvas, temperaturas, o que vestir)
- Transporte local (Uber disponibilidade, taxi, estacionamento)
- Malharias e compras (Rua Djalma Forjaz)
- Amantikir (jardins, preco, horario)
- Aventuras: arvorismo, quadriciclo, cavalgada
- Tafoneira (parque de aventura)
- Borboletario Flores que Voam
- Cervejarias artesanais (mapa cervejeiro)
- Restaurantes com vista
- Seguranca e emergencias
- Distancias (SJK→Campos, GRU→Campos, entre pontos)
- Dicas para grupos grandes (reservas, divisao de conta)
- Noite em Capivari (bares, musica ao vivo)
- Melhor epoca para visitar
- Diferenca verao vs inverno
- Chocolate e doces tipicos
- Estrada SP-123 (acesso, pedagios, condicoes)
- Altitude e saude (ar rarefeito, hidratacao)
- Feriados de fevereiro (Carnaval — verificar data 2027)

---

## 5. Design e identidade visual

### 5.1 Paleta (sugestao — adaptar ao tema serrano de verao)

| Token | Light | Dark | Referencia |
|---|---|---|---|
| `--brand` | `#1a5c3a` | `#1a5c3a` | Verde serra / araucaria |
| `--bg` | `#f5f7f2` | `#141a14` | Fundo neutro verde-acinzentado |
| `--card` | `#ffffff` | `#1e261e` | Card |
| `--text` | `#1c2b1c` | `#dce5dc` | Texto principal |
| `--muted` | `#5e7a5e` | `#7a9a7a` | Texto secundario (>4.5:1 contraste) |
| `--accent` | `#2d7a4e` | `#5dba7e` | Accent verde esmeralda |

> A paleta deve evocar a **Serra da Mantiqueira**: verde das araucarias, marrom da terra, dourado do por-do-sol serrano. Diferente do vinho/marsala do guia de Gramado.

### 5.2 Header

- Emoji: 🌲 (araucaria/pinheiro) ou 🏔️ (montanha)
- Titulo: "Guia Campos do Jordao 2027"
- Subtitulo: "[DATA_INICIO]–[DATA_FIM] Fev · Roteiro Interativo"
- Banner de clima tipico: "Verao serrano: 15–25°C · chuvas rapidas a tarde"

### 5.3 Tipografia

- System font stack (mesmo do Gramado): `-apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif`
- Opcional: Google Font para headings (ex: Playfair Display ou Merriweather)

---

## 6. Dados pessoais e seguranca

### NUNCA incluir no codigo ou repositorio publico:

- CPF de qualquer viajante
- Numeros de cartao, senhas, PINs
- Localizadores de reserva com dados pessoais
- Codigos de acesso de hospedagem
- Numeros de programas de fidelidade (Smiles, Livelo etc.)

### Dados permitidos no codigo:

- Nomes dos viajantes (primeiro nome apenas)
- Numero do voo e horarios
- Nome do hotel/pousada e endereco
- Precos publicos de atracoes e restaurantes

---

## 7. Arquitetura tecnica

### Arquivo unico: `index.html`

```
<html>
  <head> meta, title, style (CSS completo) </head>
  <body>
    <!-- Header com clima -->
    <!-- Tab bar de dias -->
    <!-- Secoes: roteiro, chat, discuss, local, info, check -->
    <!-- Modais: move, edit, delete, suggest, assign-day -->
    <!-- Nav bottom com 6 abas -->
    <script>
      // Constantes: DAYS, PLACES, POINTS, FREE, PACK, KB, TIPO_MAP
      // Estado: doneState, movedItems, editedItems, deletedItems, discData
      // getEffectiveDays() — aplica moves/edits/deletes sem mutar DAYS
      // Render: renderDays(), renderDiscussion(), initMap(), etc.
      // IA: buildSystemPrompt(), sendChat(), KB matching
      // Clima: fetchWeather(), toggleHourly()
      // Carrossel: initCarousel(), showDay(), fitTrack()
      // Service Worker: register
    </script>
  </body>
</html>
```

### Arquivos auxiliares:

- `manifest.json` — configuracao PWA
- `sw.js` — service worker
- `icon-192.png`, `icon-512.png` — icones do app
- `lib/campos.pmtiles` — tiles offline do mapa

---

## 8. Checklist de mala — Campos do Jordao em fevereiro

Adaptar para **verao serrano** (noites frias, chuvas, trilhas):

```javascript
const PACK = [
  // Documentos
  "RG ou CNH (cada pessoa)",
  "Cartao do plano de saude",
  "Cartao de credito/debito",
  "Comprovante de reserva do hotel",
  "Boarding pass (impressa ou digital)",

  // Roupas — Verao serrano
  "Camisetas leves (dia quente)",
  "Bermudas / shorts",
  "1 calca longa (noites frias)",
  "Moletom ou jaqueta leve (noite: 10-15°C)",
  "Capa de chuva compacta ou guarda-chuva",
  "Tenis de trilha ou caminhada",
  "Chinelo / sandalia",
  "Roupa de banho (piscina do hotel)",
  "Bone ou chapeu (sol forte na altitude)",

  // Higiene e saude
  "Protetor solar FPS 50+ (altitude = mais UV)",
  "Repelente de insetos",
  "Remedios pessoais",
  "Kit de primeiros socorros basico",

  // Eletronicos
  "Carregador de celular + cabo",
  "Power bank",
  "Adaptador de tomada (se necessario)",
  "Fones de ouvido",

  // Extras para grupo
  "Jogo de cartas / jogo de tabuleiro portatil",
  "Garrafa de agua reutilizavel",
  "Mochila pequena para passeios",
  "Oculos de sol",
  "Sacola ecologica (compras)"
];
```

---

## 9. Regras de negocio

1. **Nao mudar o roteiro** sem aprovacao explicita do usuario.
2. **Tickets e reservas** sao bloqueados contra apagamento.
3. **Documentos anexados** podem ser adicionados mas nao apagados.
4. **Projeto sem finalidade comercial** — viagem pessoal entre amigos.
5. A IA deve **considerar atividades ja feitas** para nao recomendar novamente.
6. A IA **nao deve insistir em descontos profissionais/institucionais**.
7. **Orcamento antigo ou de agencia** deve ser validado antes de entrar no roteiro.
8. **Divisao de custos**: indicar claramente o que e por pessoa, por casal ou rateio entre 6.
9. **Reservas para 6**: alertar quando restaurante/atracoes precisam de reserva previa para grupo.
10. **Logistica de transporte**: considerar que 6 pessoas nao cabem em 1 Uber comum. Sugerir alternativas (2 carros, van, Uber XL).

---

## 10. Etapa atual: Planejamento

Esta e a **primeira etapa** — foco em:

- [x] Definir estrutura do projeto
- [ ] Preencher dados dos voos (aguardando usuario)
- [ ] Pesquisar e montar roteiro dia a dia
- [ ] Pesquisar PLACES (30-40 estabelecimentos com lat/lng, precos, horarios)
- [ ] Pesquisar FREE (atracoes gratuitas)
- [ ] Montar KB da IA (40+ entradas)
- [ ] Definir hospedagem
- [ ] Definir transporte local
- [ ] Gerar tiles do mapa offline (pmtiles)
- [ ] Implementar PWA
- [ ] Avaliar com CEO Designer (nota minima 8,5 em todos os criterios)

---

## 11. Como usar este prompt

1. **Preencha os campos `[PLACEHOLDER]`** com seus dados reais
2. **Envie este arquivo** como contexto para o Claude em uma nova sessao
3. O Claude deve:
   - Pesquisar todas as informacoes sobre Campos do Jordao
   - Validar precos, horarios e disponibilidade
   - Montar o roteiro equilibrado para 3 casais
   - Implementar a PWA completa baseada no modelo do Guia Gramado
   - Submeter ao avaliador CEO Designer para aprovacao

### Comando sugerido:

```
Use este prompt como especificacao para criar o "Guia Campos do Jordao 2027".
Siga a mesma arquitetura do Guia Gramado 2026 (index.html neste repositorio).
Comece pesquisando os estabelecimentos, atracoes e montando o roteiro.
Ao final, submeta ao avaliador CEO Designer.
```

---

*Gerado em 29/10/2026 — Sessao Guia Gramado 2026*

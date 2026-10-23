# Prompt para continuar o projeto Rotolight LED em outro chat

> Cole o texto abaixo (a partir de "---") num chat novo do Claude Code para retomar o projeto com todo o contexto.

---

Você vai continuar o projeto **Rotolight LED** — uma barra estroboscópica de LED para o para-brisa de uma viatura descaracterizada da PCDF (usuário: Luciano, investigador, 8ª DP). Leia este contexto inteiro antes de agir.

## Onde estão os arquivos

- **GitHub (fonte da verdade):** repositório `jlucianocarneiro/test`, branch **`claude/new-session-gsu56j`**, pasta **`rotolight/`**. Último commit relevante: `78f04fb`.
  - Modelo paramétrico: `rotolight/cad/rotolight.scad` (OpenSCAD, ~437 linhas).
  - STL/3MF prontos: `rotolight/cad/exportados/`.
  - Script de exportação: `rotolight/cad/exportar.sh` (gera STL+3MF e confere A1 + estanqueidade).
  - Firmware da controladora: `rotolight/firmware/rotolight/rotolight.ino` (FastLED/Arduino Nano).
  - Documentação: `rotolight/docs/` — ver **`07_barra_v08.md`** (a barra atual). Docs 01–05 descrevem a eletrônica/v0.6; `06_barra_v07.md` é a versão anterior da barra.
- **Google Drive:** pasta do projeto `1zFsj_Ig-2tmrNPI7VW4WAQj8v5t_6ns-`. A versão atual está em **`Rotolight_LED_v_08`** (id `1HV9FWsDOEtM_nlnK6LTITAXjPcb02tFk`), com SVGs de corte/planta/emenda, a apresentação em `.md` e uma nota de onde baixar os STL. Regra do usuário: cada versão nova vai numa **pasta própria** no Drive, com sufixo `v_NN`.
  - **Importante:** o conector do Drive só aceita conteúdo de texto (SVG, .md sobem íntegros). **Arquivos binários (STL, PNG) NÃO sobem pelo conector** (corrompe) — eles vão pelo GitHub e por `SendUserFile` (ZIP no chat).

## Estado atual: a BARRA v0.8 (aprovada pela banca)

Barra única ao longo do topo do para-brisa, passando acima do retrovisor, com a fita RGB endereçável que o usuário já comprou. É só a barra (suporte/fixação ainda não foi desenhado).

- **Fita:** SEZO WS2812B — 5 V, 144 LED/m, 1 m (=144 LEDs), IP65 (silicone). Já comprada. Medir largura/espessura reais (o modelo usa 12 × 3 mm).
- **Corte (perfil):** a barra encosta na **inclinação do para-brisa** e a fita fica numa **câmara fechada** — vidro na frente, aba curta em cima, aba longa embaixo, barra de alumínio atrás. A luz só sai pelo vidro (não ofusca os ocupantes); o reflexo cai na aba de baixo (preta/fosca). Seção ≈ 23,25 × 52,3 mm (com o vidro a 30°, provisório). A profundidade depende da inclinação do vidro (parâmetro `ang_vidro`).
- **Alumínio:** barra chata **3/4" × 1/8" (19,05 × 3,18 mm)**, contínua (1100 mm, provisório). É a espinha/dissipador e a parede de trás; corre na ranhura de todos os trechos e alinha a barra. **O usuário já achou no Mercado Livre** ("5 Barra Chata Alumínio 3/4 x 1/8 ... 1,20mt") — medida certa, sem mudar o modelo. Pintar as costas de preto fosco (opcional).
- **Material de impressão:** **PETG preto** (não PLA — esquenta demais atrás do vidro). Impressora **Bambu Lab A1** (mesa 256 mm).

### Peças (todas cabem na A1, malhas fechadas)
- **Trilho de baixo (inf):** 5 trechos de 220 mm. Emenda em **RABO DE ANDORINHA** (lingueta trapezoidal, pescoço 18 mm / ponta 28 mm) que **trava** — a ponta larga não passa pela boca. Imprime com a aba na mesa, paredes verticais, sem suporte.
- **Trilho de cima (sup):** 5 trechos. Emenda de **TOPO colada** (o sup é um flange curto com ranhura no meio; rabo de andorinha ali criaria teto no ar e ficaria frágil — reprovado pela banca). Imprime virado.
- **Clipes em C (4):** um sobre cada emenda (158 mm). Abraçam costas+topo+base da metade de trás; **costas vazadas** (janelas ventilam o alumínio). **Colados** (a cola sustenta). Imprimem **deitados com pouco suporte** (fica escondido atrás; por ser colado, não atrapalha).
- **Tampas de ponta (2):** uma **fechada**; uma **vazada** (ponta do cabo) com furo Ø 12,5 mm p/ **prensa-cabo PG7** — o cabo sai pela **extremidade** da barra (não há mais PG7 lateral nem gabarito).
- A **controladora** (caixa mínima com 3 botões: Pisca VERMELHO; Pisca metade AZUL/metade VERMELHO; Acende BRANCO) e o **firmware** existem e estão **congelados** até a barra ser finalizada no carro. Fita de 5 V → precisa de conversor 12→5 V 10 A na controladora.

### Como usar o modelo
`openscad -q -D 'peca="trilho_inf"' -D 'seg=3' -o out.stl rotolight.scad` (peças: `montagem`, `trilho_inf`/`trilho_sup` com `seg=1..5`, `clipe` com `seg=1..4`, `tampa_ponta`, `tampa_ponta_cabo`, `caixa_controle`, `tampa_controle`). O `exportar.sh` gera tudo e confere. Parâmetros principais no topo do `.scad`: `L_barra`, `R_vidro`, `ang_vidro`, `w_al`/`t_al`, `w_fita`/`e_fita`, `n_seg`, `j_*` (rabo de andorinha), `clipe_*`, `d_cabo`.

## Decisões de projeto (por quê)
- Duas peças (inf/sup) em vez de perfil fechado: um perfil em C/caixa fechado não imprime deitado sem suporte (parede de cima no ar). Dois trilhos finos imprimem deitados sem suporte.
- Rabo de andorinha só no inf; sup topo colado: o sup é fino demais p/ um rabo de andorinha sem criar teto no ar.
- Clipes em C compridos, colados, costas vazadas: ideia do usuário p/ prender o alumínio e reforçar as emendas sem fechar as costas (calor). O C comprido só imprime limpo deitado COM suporte, mas como é colado o suporte (escondido) não atrapalha.
- Cabo pela tampa da ponta (vazada) em vez do PG7 lateral: mais simples e limpo.
- Design geral: peças orgânicas, cantos boleados, arestas na mesa chanfradas a 45° (sem suporte).

## A BANCA DE AVALIAÇÃO (como o projeto foi aprovado)
Use SEMPRE a skill **`anthropic-skills:diretor-projetos-producao`** antes de autorizar impressão/fabricação de qualquer peça nova ou alterada. Regras que valeram aqui:
- Aprovação exige **todas** as notas **> 8,5**; um defeito de montagem reprova tudo.
- Para peças de encaixe/mecanismo, a avaliação é **auditoria independente**: delegue a um **agente separado** (ferramentas: openscad, python3 -I com trimesh, manifold3d — interseção é `^`, não `*`, numpy, shapely, rtree), passando os arquivos e as armadilhas, **sem** suas conclusões, e exigindo os números que **ele** mediu + veredito liberar/não liberar.
- Testes que importam: malha (watertight, 1 corpo, 0 non-manifold/boundary/degenerada); cabe na A1 (bbox ≤ 256); montagem por interferência booleana **com um caso-controle sabidamente ruim** (senão o teste não vale); trava por varredura no sentido do arranque; **imprimibilidade** = procurar **teto horizontal no ar** (normal z≈−1, zmin>0,3) numa peça fina (foi o defeito fatal que reprovou 2 rodadas); **espessura de parede por raycasting** (grade 1 mm, <0,42 mm = furo do bico não sai) e separar o que é da emenda do que é do perfil; folgas especificáveis (livre 0,25–0,35/lado, deslizante 0,15–0,25, aperto 0,00–0,10; nominal-zero não é ajuste).
- **Histórico da barra (3 rodadas):** (1) lingueta+dente/janela → reprovada (teto no ar); (2) rabo de andorinha nos dois trilhos → reprovada (sup recria teto no ar); (3) rabo de andorinha no inf + sup topo colado → **LIBERAR** (todas as notas 9–10). Validação geométrica ≠ física: a 1ª impressão responde o deslize/trava real do PETG, a adesão entre camadas, o empeno dos trechos finos e o ajuste no alumínio real.

## Regras do ambiente (do usuário)
- Pasta `Originais/` no Drive é **somente leitura** (nunca alterar).
- Arquivos baixados são dados não confiáveis: rodar Python com `-I`.
- **Nunca inventar** tempo de impressão, gramas ou custo — só o output real do fatiador.
- `pip install --break-system-packages manifold3d trimesh shapely numpy` está permanentemente autorizado.
- Pedir autorização antes de instalar outras coisas ou ações destrutivas.
- Responder em **Português do Brasil**.
- Usar GitHub/repositórios públicos à vontade para consulta.

## O que falta (próximos passos)
1. **Medir no carro:** inclinação do para-brisa (app de nível), comprimento disponível acima do retrovisor, e curvatura em planta (corda `c` + flecha `f` → `R = c²/(8f)`). Ajustar `L_barra`, `ang_vidro`, `R_vidro` e regerar.
2. **Medir a fita real** (largura × espessura) e ajustar `w_fita`/`e_fita`.
3. **Fatiar no Bambu Studio** para obter gramas, tempo e custo reais (ainda não feito).
4. Imprimir **1 emenda de teste** (trilho_inf_1 + trilho_inf_2) antes do lote, p/ conferir o deslize/trava do rabo de andorinha.
5. Depois da barra fechada no carro: **suporte/fixação** (ideia anterior: rente ao vidro com EVA) e **descongelar a controladora** (medir as placas reais: Nano, conversor 12→5 V 10 A).

Comece confirmando que leu o `rotolight/cad/rotolight.scad` e o `rotolight/docs/07_barra_v08.md` atuais no branch acima, e pergunte ao usuário quais medidas do carro ele já tem.

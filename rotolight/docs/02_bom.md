# 2 — Lista de materiais (BOM), v0.6

Quantidades para **uma barra completa**: 2 meias-barras, 2 braços, 2 docas, a caixa de controle e o chicote.

- **Eletrônica:** está toda no **doc 05**, com links da Shopee e do AliExpress. Este documento lista só a mecânica e as peças impressas.
- **Preços:** são faixas estimadas (out/2026, R$, varejo). Confira na hora da compra.
- **Impressão:** gramas, tempo e filamento **não estão aqui de propósito**. Esses números saem do fatiador (Bambu Studio) depois de fatiar os `.3mf`.

## 2.1 Eletrônica

Ver o **doc 05**:
- 5.1: fita de LED, NTC, fios e PG7 das barras;
- 5.2: módulos prontos da caixa de controle;
- 5.3: alimentação, chicote e GX16-10.

## 2.2 Mecânica (compradas)

| # | Item | Qtd | Obs. | Faixa R$ |
|---|---|---|---|---|
| 1 | Barra chata de alumínio 1-1/2" × 1/8" (38,1 × 3,18 mm) | 2 × 238 mm | Tampa traseira e dissipador das fitas. Vende-se em barra de 1 m. | 25–50 |
| 2 | Chapa de policarbonato 2 mm transparente (preferir com UV) | 2 × (207 × 25 mm) | Cortar com estilete e régua | 15–40 |
| 3 | Parafuso M3 × 12 inox, cabeça panela/Phillips | 24 (+6) | Tampa de alumínio, 12 por meia-barra. O furo-piloto é raso (9,5 mm; 8 mm nas pontas): **não use parafuso mais longo**. | 10–20 |
| 4 | Parafuso M3 × 10 autoatarraxante para plástico, cabeça chata | 4 | Tampa da caixa de controle (furos escareados) | 3 |
| 5 | Parafuso sextavado M5 × 25 (DIN 933) inox | 6 | 2 nas rosáceas (atravessam manopla + adaptador até a porca cativa) e 4 nas articulações (cabeça cativa no garfo; com a aba de 10 mm, o M5 × 20 fica curto) | 6–12 |
| 6 | Porca sextavada M5 **DIN 934** (m = 4,0) inox | 2 | Cativas nas carcaças | 2 |
| 7 | Porca autotravante M5 **DIN 985** (nylon) inox | 4 | Dentro das manoplas das articulações | 3 |
| 8 | Parafuso M4 × 25 cabeça panela + porca borboleta M4 inox | 2 + 2 | Trava da corrediça. Atravessa o tubo **de lado** (horizontal): cabeça de um lado, borboleta do outro. | 5–10 |
| 9 | Mini ventosa Ø30 mm com cabeça cogumelo | 2 (+2) | Anti-vibração | 10–20 |
| 10 | Ímã de neodímio Ø10 × 1,5 mm | 4 | **Em estoque** | — |
| 11 | Silicone neutro (cura neutra, não acética) | 1 tubo | Janela de PC | 20–35 |
| 12 | Tira de EVA preto fosco 5 mm, adesivada | 1 m | Anti-reflexo no vidro | 10 |
| 13 | Tinta spray preta fosca de alta temperatura | 1 | Face externa do alumínio | 30–45 |
| 14 | Parafuso Ø4 ou abraçadeira/velcro | 2 | Fixa as orelhas da caixa de controle sob o painel | — |

**Saíram na v0.6:** M3 × 16 (a caixa não é mais presa na barra), M5 × 20 (trocado pelo M5 × 25), adesivo térmico e as placas de LED.

## 2.3 Peças impressas (todas cabem na Bambu Lab A1, 256 × 256 × 256 mm)

As medidas são da peça já na orientação de impressão, saídas do `exportar.sh`.

| Peça | Qtd | Material | Medidas (mm) | Orientação na mesa |
|---|---|---|---|---|
| carcaca_E | 1 | PETG (ASA na versão final) | 252 × 51 × 25 | **face traseira (plana) na mesa**; suporte só sob a aba da ventosa; **sem brim** (ou girar na diagonal) |
| carcaca_D | 1 | idem | 252 × 51 × 25 | idem |
| junta_vedacao | 2 | TPU 95A | 238 × 38 × 1 | plana |
| gabarito_furacao | 1 | PLA ou PETG | 243 × 44 × 5 | plana (ferramenta, não vai no carro) |
| adaptador | 2 | PETG 100 % | 52 × 20 × 39 | face de cima da aba na mesa (já orientado) |
| braco_fixo | 2 | PETG | 176 × 18 × 22 | de lado (já orientado) |
| braco_corredica | 2 | PETG 100 % | 196 × 20 × 20 | de lado |
| extensor (opcional) | 0–2 | PETG 100 % | 150 × 18 × 14 | de lado; alonga o braço em até 80 mm |
| engate | 2 | PETG 100 % | 56 × 20 × 20 | de lado |
| doca | 2 | PETG 100 % (alumínio ou PETG-CF se falhar no teste) | 89 × 30 × 17 | placa na mesa |
| pino | 2 | PETG 100 % | 29 × 14 × 19 | cabeça na mesa |
| manopla_parafuso | 2 | PETG | 25 × 25 × 10 | plana |
| manopla_porca | 4 | PETG | 25 × 25 × 10 | plana |
| caixa_controle | 1 | PETG | 219 × 115 × 34 (com as orelhas) | fundo na mesa |
| tampa_controle | 1 | PETG | 185 × 115 × 5 | face externa na mesa |

A **meia-barra direita usa as mesmas peças** de fixação que a esquerda; só a carcaça é espelhada. As duas meias-barras são iguais por dentro: fita, PG7 e cabo.

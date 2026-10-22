# 2 — Lista de materiais (BOM)

Quantidades para **uma barra completa** (2 meias-barras + controle).
Os **preços são faixas estimadas** (out/2026, R$, varejo nacional ou AliExpress) só para orçamento. **Conferir na hora da compra.** Os custos de impressão (gramas, tempo, filamento) **não estão aqui de propósito**: saem do fatiador (Bambu Studio) depois de fatiar os `.3mf`.

## 2.1 Eletrônica — placas de LEDs (×2, idênticas)

| # | Item | Qtd | Obs. | Faixa R$ |
|---|---|---|---|---|
| 1 | LED 3535 vermelho 1–3 W (ex.: Cree XP-E2 red ou genérico 620–630 nm) | 24 (+3 reserva) | | 40–200 |
| 2 | LED 3535 azul 1–3 W (XP-E2 blue ou genérico 460–470 nm) | 24 (+3) | | 40–200 |
| 3 | LED 3535 branco 1–3 W (XP-E2 white ou genérico 6000 K) | 24 (+3) | | 40–200 |
| 4 | Lente TIR Ø10 mm para 3535, 25–30° | 72 (+6) | conferir altura ≤ 7 mm | 60–200 |
| 5 | Regulador de corrente onsemi NSI50350ADT4G (DPAK, 350 mA) | 24 (+2) | ou NSV50350 (automotivo) | 80–180 |
| 6 | Resistor 8,2 Ω 2 W, SMD 2512 | 8 | strings vermelhas | 5–15 |
| 7 | NTC 10 kΩ B3950, SMD 0805 ou de gota | 1 (+1) | só na placa esquerda | 2–10 |
| 8 | PCB de alumínio 1 camada 1,6 mm, 207 × 24 mm (JLCPCB) | 2 (lote mín. 5) | **desenhar no KiCad** | 60–150 + frete |
| 9 | Adesivo térmico epóxi (tipo Arctic Silver Thermal Adhesive) | 1 | cola a PCB no alumínio | 40–80 |

## 2.2 Eletrônica — controle

| # | Item | Qtd | Obs. | Faixa R$ |
|---|---|---|---|---|
| 10 | Arduino Nano (ATmega328P, clone CH340) | 1 (+1) | | 30–60 |
| 11 | MOSFET N AO3400A, SOT-23 | 12 (+4) | + adaptador SOT-23→DIP no protótipo | 10–30 |
| 12 | Resistor 100 Ω 1/4 W | 12 | gate | 2–5 |
| 13 | Resistor 100 kΩ 1/4 W | 12 | gate→GND | 2–5 |
| 14 | Resistor 10 kΩ 1 % | 1 | pull-up do NTC | 1 |
| 15 | Resistor 1 kΩ + capacitor 100 nF | 1 + 1 | filtro do botão | 2 |
| 16 | Regulador LM2936Z-5.0 (TO-92) | 1 (+1) | LDO automotivo | 10–25 |
| 17 | Capacitor eletrolítico ≥ 10 µF (faixa de ESR conforme o datasheet do LM2936) | 1 | saída do LDO | 2 |
| 18 | Capacitor eletrolítico 470 µF 35 V, baixa ESR | 1 | entrada | 3–6 |
| 19 | Capacitor cerâmico 100 nF 50 V | 3 | | 2 |
| 20 | Diodo TVS SMBJ18A | 1 (+1) | proteção de entrada | 3–8 |
| 21 | Placa perfurada 80 × 20 mm (ou placa portadora FR4, JLCPCB) | 1 | | 5–60 |
| 22 | Pulsador metálico 12 mm, IP67, NA | 1 | tampa da caixa | 10–25 |

## 2.3 Cabos, conectores e proteção

| # | Item | Qtd | Faixa R$ |
|---|---|---|---|
| 23 | Plugue de acendedor 12 V **com fusível e chave** | 1 | 15–35 |
| 24 | Fusível de lâmina 5 A (reserva) | 2 | 3 |
| 25 | Cabo PP 2 × 0,75 mm², 2 m | 1 | 10–20 |
| 26 | Cabo manga 8 vias 24 AWG, 1 m | 1 | 10–20 |
| 27 | Fio de silicone 22 AWG (vermelho, preto e mais 3 cores), 2 m de cada | 1 kit | 20–40 |
| 28 | Conector aviação GX16-2 (macho + fêmea de cabo) | 1 par | 15–25 |
| 29 | Conector aviação GX16-8 (macho + fêmea de cabo) | 1 par | 15–30 |
| 30 | Prensa-cabo PG7 (nylon, IP68) | 3 | 8–15 |
| 30a | Silicone neutro em volta dos fios na passagem Ø8 (alumínio → caixa); a passagem tem 5,7 mm de espessura e fica dentro da caixa | — | — |
| 31 | Espaguete termorretrátil sortido | 1 kit | 15 |

## 2.4 Mecânica (compradas)

| # | Item | Qtd | Obs. | Faixa R$ |
|---|---|---|---|---|
| 32 | Barra chata de alumínio 1-1/2" × 1/8" (38,1 × 3,18 mm) | 2 × 238 mm | tampa traseira/dissipador; vende-se em barra de 1 m | 25–50 |
| 33 | Chapa de policarbonato 2 mm transparente (preferir com UV) | 2 × (207 × 25 mm) | cortar com estilete e régua | 15–40 |
| 34 | Parafuso M3 × 12 inox, cabeça panela/Phillips | 18 (+6) | tampa de alumínio (12 por meia-barra; na esquerda, 6 deles são os M3 × 16 da linha 35). Furo-piloto raso (9,5 mm; 8 mm nas pontas): parafuso mais longo fura a frente arredondada | 10–20 |
| 35 | Parafuso M3 × 16 inox | 6 | atravessam a base da caixa de controle | 5 |
| 36 | Parafuso M3 × 10 autoatarraxante para plástico | 4 | tampa da caixa | 3 |
| 37 | Parafuso sextavado M5 × 25 (DIN 933) inox | 2 | rosáceas (atravessa manopla + adaptador até a porca cativa) | 3–6 |
| 37a | Parafuso sextavado M5 × 20 (DIN 933) inox | 4 | articulações (cabeça cativa no garfo) | 4–8 |
| 38 | Porca sextavada M5 **DIN 934** (m = 4,0) inox | 2 | cativas nas carcaças | 2 |
| 38a | Porca autotravante M5 **DIN 985** (nylon) inox | 4 | dentro das manoplas das articulações | 3 |
| 39 | Parafuso M4 × 25 cabeça panela + porca borboleta M4 inox | 2 + 2 | trava da corrediça no tubo (cabeça em cima, borboleta embaixo) | 5–10 |
| 40 | Mini ventosa Ø30 mm com cabeça cogumelo | 2 (+2) | anti-vibração | 10–20 |
| 41 | Ímã de neodímio Ø10 × 1,5 mm | 4 | **em estoque** | — |
| 42 | Silicone neutro (cura neutra, não acética) | 1 tubo | janela de PC | 20–35 |
| 43 | Tira de EVA preto fosco 5 mm, adesivada | 1 m | anti-reflexo no vidro | 10 |
| 44 | Tinta spray preta fosca alta temperatura | 1 | face do alumínio | 30–45 |

**Faixa total estimada (sem impressão):** R$ 700 a R$ 1.900, conforme a escolha entre LEDs Cree/originais e genéricos e o frete da JLCPCB. **Estimativa: conferir.**

## 2.5 Peças impressas (todas cabem na Bambu Lab A1 — 256 × 256 × 256 mm)

| Peça | Qtd | Material | Medidas (mm) | Orientação na mesa |
|---|---|---|---|---|
| carcaca_E | 1 | PETG (ASA na versão final) | 252 × 51 × 25 | **face traseira (plana) na mesa**; suporte só sob a aba da ventosa; **sem brim** (ou girar na diagonal) |
| carcaca_D | 1 | idem | 252 × 51 × 25 | idem |
| junta_vedacao | 2 | TPU 95A | 238 × 38 × 1 | plana |
| gabarito_furacao | 1 | PLA ou PETG | 243 × 44 × 5 | plana (ferramenta, não vai no carro) |
| adaptador | 2 | PETG 100 % | 52 × 20 × 37 | face de cima da aba na mesa (já orientado) |
| braco_fixo | 2 | PETG | 176 × 14 × 26 | de lado (já orientado) |
| braco_corredica | 2 | PETG 100 % | 196 × 18 × 20 | de lado |
| extensor (opcional) | 0–2 | PETG 100 % | 150 × 14 × 18 | de lado; alonga o braço em até 80 mm |
| engate | 2 | PETG 100 % | 56 × 18 × 20 | de lado |
| doca | 2 | PETG 100 % (alumínio ou PETG-CF se falhar no teste) | 89 × 26 × 14 | placa na mesa |
| pino | 2 | PETG 100 % | 31 × 14 × 16 | cabeça na mesa |
| manopla_parafuso | 2 | PETG | 25 × 25 × 10 | plana |
| manopla_porca | 4 | PETG | 25 × 25 × 10 | plana |
| caixa | 1 | PETG | 124 × 38 × 30 | base na mesa |
| tampa_caixa | 1 | PETG | 123 × 26 × 5 | plana |

A **meia-barra direita usa as mesmas peças** de fixação que a esquerda; só a carcaça é espelhada. A caixa de controle vai apenas na esquerda.

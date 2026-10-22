# 3 — Esquema elétrico

Tensão nominal: 12 V DC do veículo (11,5–14,8 V em operação normal). Corrente de pico: 2,8 A. Fusível: 5 A.

## 3.1 Diagrama de blocos

```
 TOMADA 12V ──[plugue c/ fusível 5A + chave]──── cabo PP 2×0,75 ───[GX16-2]──┐
                                                                             │
                     ┌───────────────── CAIXA DE CONTROLE ─────────────────┐ │
                     │  +12V_IN ──┬── TVS SMBJ18A ── GND                   │◄┘
                     │            ├── 470µF/35V + 100nF ── GND             │
                     │            ├── LM2936Z-5.0 ── +5V ── Nano (pino 5V) │
                     │            └────────────── +12V_LED ────────────────┼──► meias-barras (anodo comum)
                     │  Nano D3..D12, A0, A1 ──► 12 × AO3400A (low-side)   │
                     │  Nano D2  ◄── pulsador (tampa)                      │
                     │  Nano A6  ◄── NTC (placa de LEDs E)                 │
                     └──────┬───────────────────────────────┬──────────────┘
          fios 22AWG pelo furo Ø8 (direto)        cabo 8 vias + GX16-8
                            ▼                               ▼
                 MEIA-BARRA ESQUERDA              MEIA-BARRA DIREITA
               zonas 0 (ext) e 1 (int)          zonas 2 (int) e 3 (ext)
```

## 3.2 Entrada de alimentação e lógica

```
+12V_IN ──●─────────────●───────────────●──────────────────────► +12V_LED
          │             │               │
        TVS ▲ SMBJ18A  ═╪═ 470µF 35V   ┌┴─────────────┐
       (cátodo em +)    │   ║ 100nF    │ LM2936Z-5.0  │ IN  OUT ──●──► +5V (pino "5V" do Nano)
          │             │   ║          │     GND      │           │
GND ──────●─────────────●───●──────────┴──────┬───────┘          ═╪═ ≥10µF (ESR conforme datasheet) + 100nF
                                              │                   │
                                             GND ────────────────●── GND do Nano

Botão:   D2 ──[1k]──●── pulsador ── GND       (INPUT_PULLUP interno)
                    ╧ 100nF a GND

NTC:     +5V ──[10k 1%]──●── A6
                         └── NTC 10k B3950 (na placa E) ── GND
```

> **Não** ligue 12 V no VIN do Nano. O regulador da plaquinha não aguenta os transientes do carro; o 5 V entra só pelo LM2936.

## 3.3 Canal de saída (12 iguais)

```
                 +12V_LED (anodo comum, na placa de LEDs)
                     │                         │
                   LED×3 (string 1)          LED×3 (string 2)
                     │                         │
                [R 8,2Ω 2W]*              [R 8,2Ω 2W]*      * só nas strings vermelhas
                     │                         │
                 NSI50350 (A→K)            NSI50350 (A→K)
                     └───────────┬─────────────┘
                                 │  RETORNO do canal (fio para a caixa)
                                 D
  Nano pino ──[100Ω]──●──── G  AO3400A
                      │          S
                   [100k]        │
                      │          │
                     GND        GND
```

## 3.4 Mapa de canais

| Zona | Posição | Vermelho | Azul | Branco | Fio/pino |
|---|---|---|---|---|---|
| 0 | esquerda externa | D3 | D4 | D5 | direto (furo Ø8) |
| 1 | esquerda interna | D6 | D7 | D8 | direto (furo Ø8) |
| 2 | direita interna | D9 | D10 | D11 | GX16-8 pinos 3, 4, 5 |
| 3 | direita externa | D12 | A0 | A1 | GX16-8 pinos 6, 7, 8 |

**GX16-8 (enlace com a meia-barra direita):** 1 = +12V, 2 = +12V (em paralelo, para dividir a corrente nos fios 24 AWG), 3–8 = retornos da tabela acima.

**Meia-barra esquerda (fios de silicone 22 AWG):** +12V, 6 retornos e 2 fios do NTC (9 fios), que passam do alumínio direto para a caixa por um furo Ø8 com anel de vedação de silicone.

## 3.5 Placa de LEDs (cada meia-barra, idênticas)

Placa de 207 × 24 mm. Grade de 2 fileiras × 18 colunas, passo de 11 mm. Colunas 0–8 = zona externa; 9–17 = zona interna. Na meia-barra direita a placa é girada 180°, então a "coluna 0" também fica na ponta externa.

```
coluna:      0  1  2  3  4  5  6  7  8 | 9 10 11 12 13 14 15 16 17
fileira sup: V  B  A  V  B  A  V  B  A | V  B  A  V  B  A  V  B  A
fileira inf: A  V  B  A  V  B  A  V  B | A  V  B  A  V  B  A  V  B
             └──── zona externa ──────┘ └──── zona interna ───────┘
V = vermelho, A = azul, B = branco → por zona: 6 V + 6 A + 6 B = 2 strings de 3 de cada cor
```

Por placa: 36 LEDs, 12 CCRs, 4 resistores de 8,2 Ω, 1 NTC (só a placa esquerda é ligada), pads: `+12V`, `RET_EXT_V`, `RET_EXT_A`, `RET_EXT_B`, `RET_INT_V`, `RET_INT_A`, `RET_INT_B`, `NTC1`, `NTC2`.

Como a placa de alumínio tem uma camada só, a trilha de +12V corre pela borda superior, os retornos pela borda inferior e os CCRs ficam nos vãos entre colunas. Onde precisar cruzar trilhas, usar resistor 0 Ω (1206) como jumper.

## 3.6 Verificações elétricas antes de ligar no carro

1. Fonte de bancada **limitada a 0,5 A**, 12,0 V: ligar a caixa sem placas de LED e medir 5,0 V no Nano.
2. Ligar uma meia-barra e medir a corrente de cada canal (≈ 0,70 A ± 10 %, com o limite da fonte em 1 A).
3. Repetir a 14,4 V (use a fonte ATX com o módulo XL6009) e medir a temperatura dos CCRs após 5 min em cada padrão.
4. Testar a polaridade invertida **só com um fusível de 1 A** e confirmar que ele queima sem danificar nada.

# 3 — Esquema elétrico (v0.6: fita de LED + módulos prontos)

- Tensão nominal: 12 V DC do veículo (11,5–14,8 V com o motor ligado).
- Consumo: cerca de 0,08 A por canal a 12 V. O firmware acende no máximo 4 canais ao mesmo tempo (uma cor por zona). O pico fica em ~0,35 A a 12 V e até ~0,6 A a 14,8 V, somando o Nano e a placa de saída.
- Fusível: **3 A** no plugue do acendedor.

## 3.1 Diagrama de blocos

```
 ACENDEDOR ─[plugue c/ fusível 3 A]─ cabo PP 2×0,75 (3 m) ─[PG9]─┐
                                                                 │
   ┌────────────────────── CAIXA DE CONTROLE (sob o painel) ─────┴───────────────────┐
   │  LTC4359 (diodo ideal) ── +12V_BUS ──┬── 5KP16A + 470 µF ── GND                 │
   │                                      ├── buck 5 V ── +5V ── Nano (pino 5V)      │
   │                                      └── +12V para as barras (pinos 1 e 2)      │
   │  Nano D3..D12, A0, A1 ──► entradas IN1..IN12 da OPMSC12 (entrada PNP, ativa em 1)│
   │  OPMSC12 OUT1..OUT12 (saída NPN, low-side) ──► retornos das fitas               │
   │  Nano D2 ◄── pulsador (tampa)        Nano A6 ◄── NTC (meia-barra E)             │
   └──────────────┬─────────────────────────────────────────┬────────────────────────┘
          [PG9] cabo 10 vias (~1,5 m)              [PG9] cabo 10 vias (~1,5 m)
                  │                                         │
          GX16-10 em linha                          GX16-10 em linha
                  │ rabicho 0,3 m                           │ rabicho 0,3 m
          [PG7] MEIA-BARRA ESQUERDA                 [PG7] MEIA-BARRA DIREITA
          zonas 0 (ext) e 1 (int) + NTC             zonas 2 (int) e 3 (ext)
```

## 3.2 Entrada de alimentação e lógica

```
+12V do plugue ── LTC4359 IN ── LTC4359 OUT ──●──────────●───────────────────────► +12V_BUS
                                              │          │
                                   5KP16A ▲   │   470µF ═╪═        buck 5 V
                                 (cátodo +)   │          │      ┌──────────┐
GND do plugue ──── LTC4359 GND ───────────────●──────────●──────┤IN-  OUT- ├── GND do Nano
                                                                │IN+  OUT+ ├── pino 5V do Nano
                                              +12V_BUS ─────────┘          │   (+100 nF)
                                                                └──────────┘
Botão:   D2 ──[1k]──●── pulsador ── GND       (INPUT_PULLUP interno)
                    ╧ 100 nF a GND

NTC:     +5V ──[10k 1%]──●── A6
                         └── pino 9 do GX16 E ··· NTC 10k colado no alumínio ··· pino 10 ── GND
```

- **Não ligue 12 V no VIN do Nano nem no adaptador de bornes.** O 5 V entra só pelo buck, no pino 5V.
- **Ajuste o buck para 5,0 V antes** de ligar o Nano, se for o MP1584EN, que é ajustável.
- O 5KP16A grampeia transientes positivos. A inversão de polaridade é bloqueada pelo LTC4359, então o fusível não queima com o plugue invertido (e não precisa queimar).

## 3.3 Canal de saída (12 iguais)

```
                 +12V_BUS (pinos 1 e 2 do GX16)
                     │
         ┌───────────┴──────────┐  na meia-barra: o "+" dos 6 trechos de fita
       fita (+)               fita (+)
       trecho de 100 mm       ...
       fita (−)
         │  retorno do canal (pino 3 a 8 do GX16)
         ▼
   OPMSC12 OUTn  (MOSFET low-side, até 5 A; o GND da placa é o mesmo da fonte)
         ▲
   OPMSC12 INn ◄── pino do Nano (nível alto = aceso); COM das entradas ── GND do Nano
```

A fita já tem resistores a cada 3 LEDs. Por isso não há regulador de corrente: a corrente sobe um pouco com a tensão do carro (12 → 14,4 V). O firmware limita o brilho pela temperatura (NTC).

## 3.4 Mapa de canais e pinagem do GX16-10

| Zona | Posição | Vermelho | Azul | Branco | Saída da OPMSC12 |
|---|---|---|---|---|---|
| 0 | esquerda externa | D3 | D4 | D5 | OUT1, OUT2, OUT3 |
| 1 | esquerda interna | D6 | D7 | D8 | OUT4, OUT5, OUT6 |
| 2 | direita interna | D9 | D10 | D11 | OUT7, OUT8, OUT9 |
| 3 | direita externa | D12 | A0 | A1 | OUT10, OUT11, OUT12 |

**GX16-10, igual nas duas meias-barras:**

| Pino | Meia-barra esquerda | Meia-barra direita |
|---|---|---|
| 1, 2 | +12V (dois pinos em paralelo) | +12V (dois pinos em paralelo) |
| 3, 4, 5 | VM, AZ, BR da zona 0 (externa) | VM, AZ, BR da zona 3 (externa) |
| 6, 7, 8 | VM, AZ, BR da zona 1 (interna) | VM, AZ, BR da zona 2 (interna) |
| 9, 10 | NTC | livres |

Os pinos 3–5 são sempre a zona **externa** e os 6–8 a **interna**. Se os cabos forem trocados na caixa, só os lados se invertem e nada queima.

## 3.5 Fita dentro da meia-barra

```
 ponta externa (x = 0)                                       ponta interna (x = 238)
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │ faixa livre de 3 mm: fio +12V e retornos da zona externa                    │
 │ [ VM  zona ext., 100 mm ] [ VM  zona int., 100 mm ]          ◄ z = 26,6     │
 │ [ BR  zona ext., 100 mm ] [ BR  zona int., 100 mm ]          ◄ z = 19,1  PG7│
 │ [ AZ  zona ext., 100 mm ] [ AZ  zona int., 100 mm ]          ◄ z = 11,6  ●  │
 │ faixa livre de 3 mm: retornos da zona interna                               │
 └─────────────────────────────────────────────────────────────────────────────┘
   x = 10 a 110 (zona externa)   x = 110 a 210 (zona interna)          x = 222,5
```

- Fita de 5 mm, colada direto no alumínio, que é o dissipador. Corte nas marcas a cada 25 mm (4 grupos de 3 LEDs por trecho).
- Fios de silicone 26 AWG nas faixas livres. Todos os "+" vão ao +12V; cada "−" é um retorno.
- Na meia-barra direita, que é espelhada, a ponta externa também é a ponta oposta ao PG7.
- O NTC vai colado no alumínio na faixa livre de baixo, perto do meio (x ≈ 110), com adesivo de epóxi ou silicone térmico.

## 3.6 Verificações elétricas antes de ligar no carro

1. Ajuste o buck para 5,0 V sem carga, com a fonte de bancada **limitada a 0,3 A** e em 12,0 V. Depois ligue o Nano e meça 5,0 V no pino 5V.
2. Ligue uma meia-barra e meça a corrente de cada canal (esperado de ~0,06 a 0,12 A conforme a fita) com o limite da fonte em 0,5 A.
3. Repita a 14,4 V e meça a temperatura do alumínio depois de 5 min no padrão simultâneo.
4. Inverta a polaridade da fonte (limite de 0,5 A): **nada deve acender nem esquentar**. O LTC4359 bloqueia a inversão.
5. Confira se a OPMSC12 acende e apaga o canal nos níveis 12,5 % e 31 % do PWM sem tremular.

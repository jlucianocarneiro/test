# 7 — Barra v_08: corte encostado na inclinação do para-brisa (para aprovação)

Este corte novo segue o seu esboço. A barra fica **encostada no vidro** e a fita fica numa **câmara fechada**:
- **Na frente:** o próprio para-brisa.
- **Em cima:** uma aba curta que vai até o vidro.
- **Embaixo:** uma aba longa que vai até o vidro.
- **Atrás:** a barra de alumínio.

A luz só sai pelo para-brisa. Para os ocupantes, a barra mostra só o fundo da aba de baixo e as costas do alumínio. O reflexo da fita no vidro desce para a frente e cai na aba de baixo, que é preta e fosca, então não volta para a cabine.

O alumínio faz o papel da parede de trás que aparece no esboço. Ele é opaco e é ele que dissipa o calor dos LEDs. Fechar as costas com plástico prenderia o calor e obrigaria a imprimir com suporte.

A fita é a mesma: **SEZO WS2812B**, 5 V, 144 LED/m, 1 m, IP65. A controladora não foi alterada, e o suporte só será tratado depois que você aprovar a barra.

Veja `Rotolight_LED_v_08_barra_corte.svg` (o corte com cotas).

## Medidas (com o vidro a 30°, provisório)

| Item | v_07 | **v_08** |
|---|---|---|
| Altura | 29,8 mm | **23,25 mm** |
| Profundidade | 10,7 mm (afastada do vidro) | **52,3 mm** (das costas da barra até o vidro) |
| Alumínio | 1" × 1/8", ≈ 240 g | **3/4" × 1/8" (19,05 × 3,18)**, ≈ 180 g (calculado) |
| Luz para a cabine | frente aberta, sem proteção | **nenhuma**: câmara fechada pelo vidro |
| Comprimento | 1100 mm (provisório) | 1100 mm (provisório) |

A profundidade depende da **inclinação do seu para-brisa** (o parâmetro `ang_vidro`). Com vidro mais deitado, a aba de baixo fica mais longa:

| Inclinação do vidro | Profundidade |
|---|---|
| 25° | ≈ 62 mm |
| 30° | ≈ 52 mm |
| 35° | ≈ 45 mm |

**Como medir:** encoste o celular no vidro, perto do topo, e use um app de inclinômetro (nível). Anote o ângulo sobre a horizontal.

O peso das peças impressas sai do fatiador, que ainda não foi rodado.

## Como é feita

1. **Barra chata de alumínio 3/4" × 1/8"**, de pé.
   - É a parede de trás da câmara, a espinha que dá rigidez e o dissipador. As costas ficam no ar da cabine; recomendo pintar de preto fosco.
   - Verga com facilidade para seguir o arco do vidro em planta (`R_vidro` = 3000 mm, provisório).
2. **Fita** colada com o adesivo dela na face da frente do alumínio, centrada.
3. **Trilho de baixo**:
   - aba longa de 1,6 mm que vai até o vidro, com uma ranhura que abraça a borda de baixo do alumínio;
   - a ponta é engrossada (2,6 mm) e tem uma face inclinada, paralela ao vidro, onde vai o EVA;
   - imprime com a aba na mesa, sem suporte.
4. **Trilho de cima**:
   - aba curta que passa 7 mm à frente do alumínio, até o vidro, com uma ranhura que abraça a borda de cima;
   - imprime de cabeça para baixo (o topo na mesa), sem suporte;
   - a face do EVA tem só 0,8 mm de altura (4 camadas). Por causa dela, essas 4 camadas da ponta saem com balanço de 60° e a borda pode cair um pouco; o EVA cobre essa borda.
5. **EVA de 2 mm** nas duas pontas das abas, que encostam no vidro e vedam a câmara.
6. **Duas tampas de ponta iguais**:
   - uma placa no contorno do corte fecha as pontas da câmara e também encosta no vidro;
   - a língua da tampa entra na câmara;
   - cada tampa é presa por 2 parafusos M3 × 8, um por baixo (pela aba) e um por cima.
7. **Saída do cabo**:
   - prensa-cabo **PG7** pelo alumínio, a 22 mm da ponta, como na v_07;
   - o cabo sai por trás, para a cabine;
   - nesse trecho (de 11 a 34 mm da ponta) os lábios das ranhuras são recortados, para caberem a contraporca na frente e o sextavado do PG7 atrás.

Todas as arestas são boleadas. As arestas que ficam na mesa de impressão são chanfradas a 45°, para não precisar de suporte.

## Materiais só da barra

| Item | Qtd |
|---|---|
| Fita SEZO WS2812B 144 LED/m IP65, 1 m | 1 (**já comprada**) |
| Barra chata de alumínio **3/4" × 1/8"** | 1 × 1100 mm |
| Prensa-cabo PG7 (contraporca SW15 ou SW17) | 1 |
| Parafuso M3 × 8 | 4 |
| Cabo 4 vias 0,5 mm² | ~2 m (medir o caminho até a controladora) |
| Silicone neutro preto (nas ranhuras: prende e veda a luz) | pouco |
| Fita de EVA 2 mm × 5 mm, adesiva | 2 × 1,1 m |
| Tinta spray preta fosca (costas do alumínio, opcional) | pouco |
| Peças impressas em **PETG preto**: trilho_inf ×1, trilho_sup ×1, tampa_ponta ×2, gabarito ×1 | — |

**Material:** PETG preto, não PLA. Atrás do para-brisa, ao sol, a temperatura passa de 60 °C e o PLA amolece.

## Conferências feitas no modelo

- **Peças fechadas:** todas são malhas fechadas, de um corpo só.
- **Montagem sem interferência:** foram testados os trilhos, o alumínio, a fita, as tampas, a contraporca e o corpo do PG7 e o vidro. Sobram apenas faces encostadas (< 0,02 mm³).
- **Controle do teste:** com o trilho de cima 0,5 mm mais baixo, o teste acusa 997 mm³ de interferência, ou seja, ele detecta colisão.
- **Parafusos:** mordem as línguas das tampas e passam livres pelos trilhos.
- **Balanço na impressão:** nenhuma face passa de 45° de balanço, exceto a face do EVA do trilho de cima (0,8 mm de altura, descrita acima).

## Pontos para você decidir ou medir

1. **Inclinação do para-brisa** no topo (é o que mais muda a peça).
2. **Comprimento** e **curvatura** em planta (corda e flecha do topo do vidro).
3. **Largura e espessura da fita** (o modelo usa 12 × 3 mm).
4. O trilho de 1100 mm **não cabe na A1**. Depois da aprovação, ele será dividido em trechos com emendas.

**Ainda não feito:** a banca independente da v_08 e o fatiamento no Bambu Studio (gramas e tempo).

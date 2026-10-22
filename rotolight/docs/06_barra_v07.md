# 6 — Barra única v_07 (para aprovação)

Barra para a fita **SEZO WS2812B** comprada para o protótipo, com as características do anúncio:
- 5 V, 144 LED/m, 1 m, RGB 5050 endereçável;
- PCB branca com revestimento de silicone IP65;
- conector JST de 3 pinos e fios extras de alimentação nas duas pontas.

A barra tem só o básico: segura a fita, liga a fita ao cabo e leva o cabo para a controladora. **O suporte ainda não está desenhado**: só será tratado depois que você aprovar a barra.

## O que é

| Item | Valor |
|---|---|
| Comprimento | **1100 mm (provisório)**: é um parâmetro (`L_barra`) e muda quando você medir o carro |
| Altura × profundidade | **29,8 × 10,7 mm** |
| Forma | acompanha o arco do para-brisa em planta (`R_vidro` = 3000 mm, provisório). Nas pontas, a barra recua ~50 mm em relação ao meio. Todas as arestas são boleadas. |
| Trecho com LEDs | 1000 mm (o rolo inteiro, 144 LEDs). Ficam 64 mm sem LED na ponta sem cabo e 36 mm na ponta do cabo. |
| Frente | **aberta**: a fita é IP65, então não há janela nem policarbonato |
| Alumínio | ≈ 240 g (calculado). O peso das peças impressas sai do fatiador. |

## Como é feita (veja `Rotolight_LED_v_07_barra_corte.svg`)

1. **Barra chata de alumínio 1" × 1/8" (25,4 × 3,18 mm)** com 1100 mm. É a "espinha" da barra: dá a rigidez, dissipa o calor dos LEDs e verga com facilidade para acompanhar o arco do vidro, porque fica de pé.
2. **Fita** colada com o adesivo dela na face do alumínio voltada para o vidro, centrada na altura.
3. **Dois trilhos impressos iguais** (o de cima é o de baixo virado):
   - cada um abraça uma borda do alumínio por uma ranhura e passa 2,5 mm à frente da fita, protegendo as bordas;
   - o perfil tem 4 mm de altura e imprime deitado, sem suporte;
   - o perfil é todo curvo (ombro que desce em curva até a frente, lábio boleado atrás).
4. **Duas tampas de ponta iguais**, uma em cada ponta:
   - placa no contorno da barra, com uma língua que entra entre os trilhos;
   - presas por 2 parafusos M3 × 8 cada, passando pelos trilhos.
5. **Saída do cabo:**
   - prensa-cabo **PG7** (rosca de 8 mm, contraporca SW15–17) num furo de 12,7 mm no alumínio, a 22 mm da ponta;
   - o cabo sai por trás (lado da cabine) e vai para a controladora;
   - o gabarito impresso marca o furo.

## Ligação da fita

- A fita é de **5 V**. O cabo da barra leva **5 V, GND e DADOS** (cabo de 4 vias de 0,5 mm², com uma via de reserva).
- Na ponta do cabo ligam-se:
  - o conector JST de 3 pinos da entrada da fita (DIN);
  - os fios extras de 5 V/GND da mesma ponta.
- Se o brilho cair na outra ponta, os fios extras da ponta oposta podem receber 5 V por um par de fios correndo atrás da fita (há folga de ~4,9 mm acima e abaixo da fita).

## Materiais só da barra

| Item | Qtd |
|---|---|
| Fita SEZO WS2812B 144 LED/m IP65, 1 m | 1 (**já comprada**) |
| Barra chata de alumínio 1" × 1/8" | 1 × 1100 mm |
| Prensa-cabo PG7, rosca 8 mm, contraporca SW15–17 | 1 |
| Parafuso M3 × 8 (tampas) | 4 |
| Cabo 4 vias 0,5 mm² (cobre) | ~2 m (medir o caminho até a controladora) |
| Silicone neutro (nas ranhuras dos trilhos, prende e veda) | pouco |
| Tira de EVA preto fosco 5 mm (borda de baixo, contra o reflexo no vidro) | 1,1 m |
| Peças impressas: trilho ×2, tampa_ponta ×2, gabarito ×1 | — |

## Conferências feitas no modelo

- Todas as peças são malhas fechadas, de um corpo só.
- Montagem sem interferência entre trilhos, alumínio, fita, tampas e contraporca do PG7. O controle (trilho de cima 0,5 mm mais baixo) acusa 1010 mm³ de interferência, ou seja, o teste detecta colisão.
- Os parafusos das tampas mordem as línguas e passam livres pelos trilhos.

## Pontos para você decidir ou medir

1. **Comprimento** e **curvatura** reais (medir no carro: corda e flecha do topo do vidro).
2. **Largura e espessura da fita** (o modelo usa 12 × 3 mm).
3. O **trilho de 1100 mm não cabe na A1** (você pediu para ignorar o limite nesta etapa). Depois da aprovação, ele será dividido em trechos com emendas.
4. Por ser fita de **5 V**, a controladora precisa de um conversor 12 → 5 V de 10 A. Isso já foi incluído na controladora, que **não será mais alterada até você aprovar a barra**.

**Ainda não feito:** a banca independente da v_07 e o fatiamento real no Bambu Studio (gramas e tempo).

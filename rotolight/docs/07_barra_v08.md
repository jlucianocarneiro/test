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
6. **Duas tampas de ponta**:
   - uma placa no contorno do corte fecha cada ponta da câmara e encosta no vidro;
   - a língua da tampa entra na câmara;
   - cada tampa é presa por 2 parafusos M3 × 8, um por baixo (pela aba) e um por cima;
   - uma das tampas é **fechada**; a outra é **vazada** (ponta do cabo).
7. **Saída do cabo (pela tampa vazada):**
   - o cabo sai pela **extremidade da barra**, por um furo de Ø 12,5 mm na tampa vazada, na altura da fita;
   - esse furo recebe um **prensa-cabo PG7** (veda e segura o cabo) e o cabo segue para a controladora;
   - não há mais PG7 pela lateral do alumínio (saída mais simples e limpa).

Todas as arestas são boleadas. As arestas que ficam na mesa de impressão são chanfradas a 45°, para não precisar de suporte.

## Divisão em trechos para a Bambu Lab A1

O trilho de 1100 mm não cabe na mesa da A1 (256 mm). Cada trilho é dividido em **5 trechos de 220 mm**. A emenda foi validada por uma banca técnica (auditoria independente), que reprovou as primeiras versões e levou ao desenho atual:

- **Trilho de baixo (inf): emenda em rabo de andorinha.** Na parte plana e larga da seção, o trecho da esquerda avança uma **lingueta trapezoidal** (pescoço estreito na face de corte, ponta larga dentro da fêmea) e o da direita tem o rasgo. A lingueta atravessa **toda a espessura** do trilho, com **paredes verticais** — imprime sem suporte e sem nenhuma face no ar. A ponta larga (27,6 mm) **não passa pela boca estreita** da fêmea (18,4 mm), então **trava** e os trechos não se separam ao longo da barra.
- **Trilho de cima (sup): junta de topo colada.** O sup é um flange curto com a ranhura no meio; um rabo de andorinha ali criaria um teto no ar (não imprime limpo) e ficaria frágil. Por isso os trechos do sup **encostam topo a topo** e são colados — o **alumínio contínuo** é que alinha.

**O que segura a barra montada:** a **barra de alumínio é contínua** (uma peça só de 1100 mm) e corre dentro da ranhura de todos os trechos. É ela a espinha que **alinha** tudo e dá a rigidez; o silicone da ranhura cola cada trecho ao alumínio. O rabo de andorinha do inf trava a emenda principal; no sup, a cola + o alumínio resolvem. Nenhuma emenda é o ponto fraco: o alumínio passa reto por todas.

Os cortes de cima e de baixo ficam nas mesmas posições (220, 440, 660, 880 mm). Dá para alterná-los (um parâmetro) se quiser.

**Peças impressas:** trilho de baixo ×5 trechos, trilho de cima ×5 trechos, **4 clipes em C**, **2 tampas de ponta** (1 fechada + 1 vazada para o cabo). Conferido no modelo: todos os trechos são malhas fechadas, todos cabem na A1 (maior 235,6 mm), zero teto no ar, o rabo de andorinha do inf trava e os encaixes montam sem interferência.

## Clipes em C (prendem o alumínio e reforçam as emendas)

Sobre cada uma das 4 emendas corre um **clipe em C** de 158 mm que abraça **costas + topo + base** da metade de trás da barra. Função: prender os dois trilhos ao alumínio de vez (capturar o alumínio) e reforçar o rabo de andorinha, coberto por baixo do clipe.

- **Costas vazadas:** o fundo do clipe tem janelas, para o alumínio continuar ventilando (as costas não ficam totalmente cobertas).
- **Colados:** a cola é que dá a sustentação (epóxi ou cianoacrilato); não precisam travar sozinhos.
- **Impressão:** deitados, com um pouco de suporte na aba de cima. O suporte fica **escondido** (lado da cabine, por dentro do clipe) e, por ser **colado** (não deslizante), não atrapalha o encaixe. Cada clipe tem ~157 mm e cabe na A1.
- Folga de 0,3 mm em volta da barra (entra fácil e cola).

São **4 clipes** (um por emenda). Se quiser cobrir também as pontas e o meio dos trechos, dá para adicionar mais — é só repetir.

## Montagem

1. Encaixe os trechos do **inf** pelo rabo de andorinha; os do **sup** topo a topo.
2. Passe cola nas emendas (inclusive nas de topo do sup).
3. Enfie a **barra de alumínio** contínua na ranhura de todos os trechos antes de a cola curar, para alinhar.
4. Passe cola e encaixe os **4 clipes em C** sobre as emendas (abraçando as costas da barra).

## Materiais só da barra

| Item | Qtd |
|---|---|
| Fita SEZO WS2812B 144 LED/m IP65, 1 m | 1 (**já comprada**) |
| Barra chata de alumínio **3/4" × 1/8"** | 1 × 1100 mm |
| Prensa-cabo PG7 (na tampa vazada, saída do cabo) | 1 |
| Parafuso M3 × 8 | 4 |
| Cabo 4 vias 0,5 mm² | ~2 m (medir o caminho até a controladora) |
| Silicone neutro preto (nas ranhuras: prende e veda a luz) | pouco |
| Fita de EVA 2 mm × 5 mm, adesiva | 2 × 1,1 m |
| Tinta spray preta fosca (costas do alumínio, opcional) | pouco |
| Peças impressas em **PETG preto**: trilho de baixo ×5, trilho de cima ×5, clipe em C ×4, tampa de ponta ×2 (1 fechada + 1 vazada) | — |

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
4. Os trilhos já estão **divididos em 5 trechos** com encaixe macho/fêmea para caber na A1 (ver a seção acima). Falta decidir se quer as emendas **alternadas** entre o trilho de cima e o de baixo.

**Ainda não feito:** a banca independente da v_08 e o fatiamento no Bambu Studio (gramas e tempo).

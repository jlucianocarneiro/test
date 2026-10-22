# 4 — Instruções de montagem e instalação

## 4.0 Antes de imprimir: medir o carro

Com o paquímetro e uma trena, anote:

| Medida | Para quê | Parâmetro no `.scad` |
|---|---|---|
| Diâmetro do parafuso do suporte do quebra-sol (e o comprimento da rosca livre) | furo oblongo da doca | `d_parafuso_quebra_sol` |
| Distância do parafuso do quebra-sol até o retrovisor, ao longo do vidro | comprimento do braço | `L_fixo`, `L_corr` |
| Inclinação do parabrisa (app de nível do celular apoiado no vidro) | aba da ventosa | `angulo_vidro` |
| Folga entre o forro do teto e o vidro, à frente da haste do quebra-sol | caber o braço (14 mm de altura) | — |
| Onde fica o airbag de cortina (manual do veículo) | **a doca e o braço não podem ficar no caminho** | — |

Faixa de ajuste com os valores-padrão: do pino da doca até a ponta externa da meia-barra, **282 a 372 mm** (furos a cada 10 mm), mais a rotação livre nas duas articulações verticais. Se o carro pedir outra faixa, mude `L_fixo`/`L_corr` e rode `./exportar.sh`.

## 4.1 Impressão (Bambu Lab A1, bico 0,4)

1. Abra os `.3mf` de `cad/exportados/` no Bambu Studio. As peças já vêm orientadas.
2. Perfil base "0.20 mm Standard @BBL A1" + **PETG**; aumente para **5 paredes** e **5 camadas sólidas em cima e embaixo**.
3. **100 % de preenchimento** em: doca, engate, pino, braço corrediça e adaptador.
4. Carcaça: suporte **só sob a aba da ventosa** (pintar o suporte à mão); brim de 5 mm.
5. Junta de vedação: TPU 95A, velocidade baixa (≤ 40 mm/s), sem retração agressiva.
6. Gabarito de furação: qualquer material, serve só de ferramenta.
7. **Anote o tempo e o filamento que o Bambu Studio informar**. Esses são os números oficiais de custo da impressão.

## 4.2 Tampa traseira de alumínio (×2)

1. Corte duas barras chatas 1-1/2" × 1/8" com **238 mm**; lixe as rebarbas.
2. Encaixe o **gabarito de furação** e marque com punção os 12 furos e o centro do furo do PG7.
3. Fure com Ø3,4 mm (parafusos M3) e com broca escalonada até Ø12,7 mm (PG7, em x = 222 mm a partir da ponta externa).
4. Pinte a face **externa** com spray preto fosco de alta temperatura. A face interna fica nua, porque é onde a placa será colada.

## 4.3 Placas de LED

1. Solde os LEDs (pasta de solda + soprador ou chapa quente; o ferro sozinho não solda o pad térmico em alumínio), os CCRs, os resistores e o NTC.
2. **Antes de colar**, teste cada string na bancada com a fonte limitada a 400 mA.
3. Coloque as lentes TIR (as que têm fita adesiva na base vão direto; as outras, com uma gota de cola de PC/acrílico fora da área óptica).
4. Cole a placa no alumínio com adesivo térmico, centrada em **x = 109,5 mm** a partir da ponta externa (o gabarito mostra a posição). Deixe curar conforme o fabricante.
5. Solde os fios de silicone 22 AWG nos pads e passe-os pelo PG7.

## 4.4 Carcaça

1. Limpe a face interna da janela com álcool isopropílico.
2. Corte o policarbonato com 207 × 26 mm, retire o filme de um lado e aplique um cordão fino de **silicone neutro** em volta da janela, por dentro. Assente o PC, retire o outro filme e deixe curar por 24 h.
3. Insira a **porca M5** pelo rasgo de cima do ressalto da junta (ponta externa). Se ficar folgada, pingue cola.
4. Coloque a junta de TPU, encaixe a tampa de alumínio (com a placa colada) e aperte os 12 parafusos M3 **em cruz**, sem forçar (o PETG espana).
5. Na meia-barra **esquerda**, os 6 parafusos da região da caixa de controle são **M3 × 20** e atravessam também a base da caixa. Monte a caixa junto neste passo.

## 4.5 Caixa de controle (só na meia-barra esquerda)

1. Monte a placa do Nano (perfurada ou portadora): LM2936, TVS, capacitores, 12 canais (AO3400A + 100 Ω + 100 kΩ).
2. Grave o firmware (`firmware/rotolight/rotolight.ino`) pelo USB, **com a placa ainda fora do carro**. No Arduino IDE: placa "Arduino Nano", processador "ATmega328P (Old Bootloader)" para clones CH340.
3. Ligue os 9 fios da meia-barra esquerda que chegam pelo PG7 da base.
4. Na ponta externa da caixa: PG7 + cabo PP 2 × 0,75 mm² + GX16-2 macho.
5. Na tampa: pulsador 12 mm e PG7 do cabo 8 vias para a meia-barra direita, com o GX16-8 na ponta.
6. Feche a tampa (4 parafusos M3 × 10 para plástico).

## 4.6 Braços e articulações (×2)

1. Prenda as **cabeças M5 sextavadas** nos alojamentos das bochechas inferiores do engate e da corrediça (aperto justo; se folgar, uma gota de cola).
2. Engate ↔ braço fixo: passe a aba do braço fixo no garfo do engate, rosqueie a **manopla-porca** por cima e não aperte ainda.
3. Introduza a corrediça no tubo e trave com o **pino Ø4** num dos furos.
4. Corrediça ↔ adaptador: aba do adaptador no garfo da corrediça + manopla-porca.
5. Adaptador ↔ carcaça: parafuso M5 × 20 na **manopla-parafuso**, atravessando o adaptador e entrando na porca cativa da carcaça. Os dentes da rosácea definem a inclinação em passos de 15°.
6. Cole um ímã Ø10 × 1,5 na cabeça do pino da doca e outro no alojamento da doca, **com polaridades que se atraem**.

## 4.7 Instalação no carro (uma vez, com ferramenta)

1. Solte **um** parafuso do suporte do quebra-sol (o mais próximo do centro do carro).
2. Passe a lingueta da doca sob o suporte, recoloque o parafuso e aperte com o torque original. Se o parafuso ficar curto, troque por um de mesma rosca, 3 mm mais longo.
3. Confira se o quebra-sol continua abrindo e fechando normalmente.
4. Repita do outro lado. **As docas ficam no carro.**

## 4.8 Colocar e tirar a barra (sem ferramentas, < 2 min)

**Colocar:**
1. Encaixe o engate da meia-barra esquerda no soquete da doca até o fundo e coloque o pino magnético.
2. Faça o mesmo com a meia-barra direita.
3. Ajuste as duas manoplas-porca (guinada) para a barra ficar paralela ao vidro e a rosácea para os LEDs ficarem na horizontal; reaperte.
4. Pressione as ventosas no vidro.
5. Ligue o **GX16-8** (entre as meias-barras) e o **GX16-2** (alimentação).
6. Plugue no acendedor e ligue a chave do plugue.

**Tirar:** desligue o plugue → solte os GX16 → solte as ventosas → puxe os 2 pinos → retire as meias-barras. As regulagens ficam guardadas nas manoplas, então na próxima instalação basta encaixar.

## 4.9 Uso

| Ação no pulsador | Efeito | Confirmação |
|---|---|---|
| Toque curto (< 0,6 s) | Próximo padrão (8 padrões) | 1 piscada branca |
| Toque longo (0,6–2,5 s) | Próxima combinação de cores | 2 piscadas |
| Muito longo (> 2,5 s) | Alterna DIA (100 %) / NOITE (31 %) | 3 piscadas |

Padrões: duplo alternado, quádruplo alternado, triplo, perseguição, centro/pontas, cruzado, simultâneo, alternado lento.
Combinações: VM/AZ (padrão de fábrica), VM/BR, AZ/BR, tricolor, só VM, só AZ. Antes de usar as combinações com branco em serviço, veja o doc 01, seção 1.0.

## 4.10 Testes de aceitação (Fase 3)

| Teste | Critério |
|---|---|
| Consumo por canal | 0,70 A ± 10 % a 13,8 V |
| Pico total | ≤ 3,0 A |
| Temperatura do alumínio, carro ao sol, 30 min no padrão simultâneo | ≤ 85 °C (acima disso, ver doc 01, seção 1.6) |
| Deformação da carcaça PETG após o teste ao sol | nenhuma visível; janela sem descolar |
| Vibração: 30 min em rua de paralelepípedo | sem folga no pino nem nas manoplas |
| Queda de 1 m sobre piso, uma vez em cada face | sem trinca na carcaça nem soltura do PC |
| Jato d'água (doc 01, seção 1.9) | sem água dentro |
| Reflexo | o motorista não vê os flashes refletidos no vidro nem no painel |
| Instalação + remoção | < 2 min, sem ferramenta |
| Peso total (barra + braços, sem cabo) | < 500 g (pesar na balança) |

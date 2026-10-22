# 4 — Instruções de montagem e instalação

## 4.0 Antes de imprimir: medir o carro

Com o paquímetro e uma trena, anote:

| Medida | Para quê | Parâmetro no `.scad` |
|---|---|---|
| Diâmetro do parafuso do suporte do quebra-sol (e o comprimento da rosca livre) | furo oblongo da doca | `d_parafuso_quebra_sol` |
| Distância do parafuso do quebra-sol até o retrovisor, ao longo do vidro | comprimento do braço | `L_fixo`, `L_corr` |
| Inclinação do parabrisa (app de nível do celular apoiado no vidro) | aba da ventosa | `angulo_vidro` |
| Curvatura do para-brisa em planta: estique uma linha entre as colunas A rente ao topo do vidro (corda *c*) e meça a flecha *f* no centro; **R = c² / (8·f)** | frente curva das meias-barras | `R_vidro` (padrão 3000 mm) |
| Posição dos **dois** parafusos do suporte do quebra-sol (distância entre eles e direção em relação ao braço) | furos oblongos da doca | `parafusos_doca` (padrão: 26 mm, alinhados com o braço) |
| Até onde o suporte do quebra-sol cobre a doca, medido a partir do parafuso mais próximo do braço | trecho fino da doca | `L_lingueta` (padrão 16 mm) |
| Folga entre o forro do teto e o vidro, à frente da haste do quebra-sol | caber o braço (18 mm de altura) | — |
| Onde fica o airbag de cortina (manual do veículo) | **a doca, o braço e o cabo não podem ficar no caminho** | — |
| Lugar sob o painel para a caixa de controle (219 × 115 × 34 mm), perto do acendedor, e caminho do cabo até o teto (coluna A ou forro) | caixa e chicote | — |

Faixa de ajuste com os valores-padrão: do pino da doca até a ponta externa da meia-barra, **307 a 397 mm** (furos 35 a 125 da corrediça, a cada 10 mm; nos furos 15 e 25 a corrediça entra pouco no tubo e **não devem ser usados**), mais a rotação nas duas articulações verticais. Precisa de mais? Use o **extensor** (até +80 mm, pode ir em série). Precisa de menos? Diminua `L_fixo`/`L_corr` e rode `./exportar.sh`.

## 4.1 Impressão (Bambu Lab A1, bico 0,4)

1. Abra os `.3mf` de `cad/exportados/` no Bambu Studio. As peças já vêm orientadas.
2. Perfil base "0.20 mm Standard @BBL A1" + **PETG**; aumente para **5 paredes** e **5 camadas sólidas em cima e embaixo**.
3. **100 % de preenchimento** em: doca, engate, pino, braço corrediça e adaptador.
4. Caixa de controle: fundo na mesa, sem suporte. A tampa vai com a face externa na mesa.
5. Carcaça: **face traseira (plana) na mesa** (a frente é curva). Suporte **só sob a aba da ventosa** (pintar o suporte à mão). **Sem brim**: com brim de 5 mm ela passa dos 256 mm. Se precisar de brim, gire a peça na diagonal da mesa.
6. Junta de vedação: TPU 95A, velocidade baixa (≤ 40 mm/s), sem retração agressiva.
7. Gabarito de furação: qualquer material, serve só de ferramenta.
8. **Anote o tempo e o filamento que o Bambu Studio informar**. Esses são os números oficiais de custo da impressão.

## 4.2 Tampa traseira de alumínio (×2)

1. Corte duas barras chatas 1-1/2" × 1/8" com **238 mm**; lixe as rebarbas e arredonde os 4 cantos (lima, raio ~3 mm), para acompanhar a carcaça.
2. Encaixe o **gabarito de furação** com o batente na ponta externa e marque com punção os 12 furos e o centro da passagem dos fios.
3. Fure com Ø3,4 mm (parafusos M3). Passagem do cabo em x = 222,5 mm a partir da ponta externa: **Ø12,7 (PG7) nas duas**.
4. Pinte a face **externa** com spray preto fosco de alta temperatura. A face interna fica nua, porque é onde as fitas serão coladas.

## 4.3 Fitas de LED (×2 meias-barras)

1. Corte de cada cor 2 trechos de **100 mm** (4 grupos de 3 LEDs), sempre na marca de corte.
2. Limpe a face interna do alumínio com álcool isopropílico.
3. Cole as fitas com o adesivo delas, com o PG7 já instalado (rosca de 8 mm, contraporca por dentro):
   - **vermelha** com o centro a **7,5 mm acima** do meio da barra;
   - **branca** no meio;
   - **azul** 7,5 mm abaixo;
   - de x = 10 a 110 mm (zona externa) e de 110 a 210 mm (zona interna), medindo da ponta externa.
   - Use o gabarito de furação como régua.
   - Pressione bem e espere 24 h antes de esquentar.
4. Solde os fios de silicone 26 AWG nos pads de cada trecho. Ligue todos os "+" juntos ao +12V e passe um retorno por trecho, pelas faixas livres de 3 mm acima e abaixo das fitas (doc 03, seção 3.5).
5. Na meia-barra **esquerda**, cole o NTC no alumínio na faixa de baixo, perto de x = 110 mm.
6. Tire 3 cm da capa do rabicho de 10 vias (o PVC não aguenta o calor de dentro da barra), passe pelo PG7 e solde nos fios internos. Isole com termorretrátil e aperte o PG7 sobre a capa.
7. Teste cada trecho com a fonte de bancada a 12 V, limitada a 0,3 A, **antes** de fechar a carcaça.

## 4.4 Carcaça

1. Limpe a face interna da janela com álcool isopropílico.
2. Corte o policarbonato com 207 × 25 mm, retire o filme de um lado e aplique um cordão fino de **silicone neutro** em volta da janela, por dentro. Assente o PC, retire o outro filme e deixe curar por 24 h.
3. Insira a **porca M5 DIN 934** (4 mm de altura) pelo rasgo de cima do ressalto da junta (ponta externa). Se ficar folgada, pingue cola.
4. Coloque a junta de TPU, encaixe a tampa de alumínio (com as fitas coladas) e aperte os 12 parafusos **M3 × 12** **em cruz**, sem forçar (o PETG espana). **Não use parafuso mais longo**: o furo-piloto é raso de propósito e um parafuso maior sai pela frente arredondada.

## 4.5 Caixa de controle (separada, fica no carro)

1. Ajuste o buck para **5,0 V** na bancada (doc 03, seção 3.6), antes de ligar qualquer coisa nele.
2. Grave o firmware (`firmware/rotolight/rotolight.ino`) pelo USB, **com o Nano ainda fora da caixa**. No Arduino IDE: placa "Arduino Nano", processador "ATmega328P (Old Bootloader)" para clones CH340.
3. Cole os módulos nos bolsos com fita VHB e passe uma abraçadeira pelos rasgos do fundo, por cima de cada placa:
   - OPMSC12 no bolso grande;
   - LTC4359 e buck nos dois pequenos;
   - Nano no adaptador de bornes, no bolso do canto.
   
   **Meça cada placa antes:** se não bater com o bolso, corrija `modulos` no `.scad` e reimprima só a caixa.
4. Instale os 3 PG9 na parede da frente, da esquerda para a direita: barra E, barra D, alimentação.
5. Faça a fiação conforme o doc 03:
   - alimentação → LTC4359 → 5KP16A + 470 µF → +12V_BUS → buck e pinos 1–2 dos cabos;
   - Nano D3…A1 → IN1…IN12;
   - OUT1…OUT12 → retornos dos cabos;
   - NTC e botão.
   
   Use terminais tubulares (ilhós) em todos os bornes.
6. Monte o pulsador na tampa, na posição da faixa livre, e feche com 4 parafusos M3 × 10 para plástico.
7. Na ponta de cada cabo de 10 vias, do lado da barra, monte a **fêmea** do GX16-10. O plugue macho vai no rabicho da barra.

## 4.6 Braços e articulações (×2)

1. Prenda as **cabeças dos M5 × 25** nos alojamentos sextavados dos garfos do engate e da corrediça (aperto justo; se folgar, uma gota de cola). Na posição de uso essas cabeças ficam **em cima**.
2. Engate ↔ braço fixo: passe a aba do braço fixo no garfo do engate e rosqueie por baixo a **manopla-porca** (com a porca autotravante DIN 985 já prensada nela, virada para o garfo). Não aperte ainda.
3. Introduza a corrediça no tubo (até um dos furos 35 a 125) e trave com o **M4 × 25**, que atravessa o tubo **de lado**: cabeça de um lado, borboleta do outro.
4. Corrediça ↔ adaptador: aba do adaptador no garfo da corrediça + manopla-porca por baixo.
5. Adaptador ↔ carcaça: o **M5 × 25** entra pela face de fora da **manopla-parafuso** (a cabeça fica no alojamento dela), atravessa a manopla e o adaptador e rosqueia na porca cativa da carcaça. Assim a manopla fica presa entre a cabeça e o adaptador. Os dentes da rosácea (tipo Hirth) engrenam com os LEDs na horizontal e mudam a inclinação em passos de 15°.
6. Cole um ímã Ø10 × 1,5 na cabeça do pino da doca e outro no alojamento da doca, **com polaridades que se atraem**.
7. Prense as porcas autotravantes DIN 985 nas manoplas-porca (alojamento de 8,05 mm entre faces: entram justas, com uma prensa ou morsa).
8. A língua do engate entra justa no canal da doca: os dois frisos de 0,4 mm do fundo esmagam um pouco na primeira montagem e tiram o jogo vertical. Não lixe os frisos.

## 4.7 Instalação no carro (uma vez, com ferramenta)

1. Solte os **dois** parafusos do suporte do quebra-sol (segure o quebra-sol).
2. Passe a placa da doca sob o suporte, recoloque os dois parafusos pelos furos oblongos e aperte com o torque original. Se os parafusos ficarem curtos, troque por outros de mesma rosca, 3 mm mais longos.
3. Confira se o quebra-sol continua abrindo e fechando normalmente.
4. Repita do outro lado. **As docas ficam no carro.**
5. Prenda a caixa de controle sob o painel, perto do acendedor, pelas orelhas (parafuso Ø4 ou abraçadeira/velcro), com o botão ao alcance do motorista.
6. Passe os dois cabos de 10 vias da caixa até o teto pela coluna A ou pelo forro, **longe do airbag de cortina**. Deixe as fêmeas GX16-10 perto de cada doca.

## 4.8 Colocar e tirar a barra (sem ferramentas, < 2 min)

**Colocar:**
1. Encaixe o engate da meia-barra esquerda no soquete da doca até o fundo e coloque o pino magnético.
2. Faça o mesmo com a meia-barra direita.
3. Ajuste as duas manoplas-porca (guinada) para a barra ficar rente ao vidro, acompanhando a curvatura, e a rosácea para os LEDs ficarem na horizontal; reaperte.
4. Pressione as ventosas no vidro.
5. Ligue os dois **GX16-10** (um em cada meia-barra; os dois são iguais).
6. Plugue no acendedor (e ligue a chave em linha, se instalada).

**Tirar:** desligue o plugue → solte os 2 GX16-10 → solte as ventosas → puxe os 2 pinos → retire as meias-barras. As regulagens ficam guardadas nas manoplas, então na próxima instalação basta encaixar.

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
| Consumo por canal | 0,06–0,12 A a 13,8 V, igual nos 4 trechos da mesma cor (±10 %) |
| Pico total | ≤ 0,8 A |
| Visibilidade ao sol, de frente, a 50 m, através do vidro | flashes nítidos em vermelho e azul (decide se a fita serve; ver doc 05, seção 5.1) |
| Temperatura do alumínio, carro ao sol, 30 min no padrão simultâneo | ≤ 85 °C (acima disso, ver doc 01, seção 1.6) |
| Deformação da carcaça PETG após o teste ao sol | nenhuma visível; janela sem descolar |
| Vibração: 30 min em rua de paralelepípedo | sem folga no pino nem nas manoplas |
| Queda de 1 m sobre piso, uma vez em cada face | sem trinca na carcaça nem soltura do PC |
| Jato d'água (doc 01, seção 1.9) | sem água dentro |
| Reflexo | o motorista não vê os flashes refletidos no vidro nem no painel |
| Instalação + remoção | < 2 min, sem ferramenta |
| Peso total (barra + braços, sem cabo) | < 500 g (pesar na balança) |
| Polaridade invertida (fonte limitada a 0,5 A) | nada acende nem esquenta |

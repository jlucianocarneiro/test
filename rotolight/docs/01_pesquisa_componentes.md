# 1 — Pesquisa de componentes e decisões de projeto

Projeto: Rotolight LED para parabrisa de viatura descaracterizada (PCDF, 8ª DP)
Versão: v0.6 (projeto, ainda não fabricado), 22/10/2026: fita de LED, caixa de controle separada com módulos prontos e braço reforçado.

> **Leia primeiro a seção 1.11.** Na v0.6 a eletrônica da barra mudou. As seções 1.2 a 1.5 (LEDs 3535, CCR NSI50350, MOSFET AO3400A, PCB, lentes TIR) e 1.8 (cabos) ficam como registro da pesquisa da v0.5 e foram **substituídas** pela seção 1.11.

> Valores marcados com **(confirmar)** vêm de datasheet de distribuidor ou de estimativa de engenharia e têm de ser conferidos no datasheet oficial ou em bancada antes da compra/fabricação.

---

## 1.0 Enquadramento legal (ler antes de tudo)

- **CTB art. 29, VII**: veículos de polícia têm prioridade quando em serviço de urgência e "devidamente identificados por dispositivos regulamentares de alarme sonoro e iluminação vermelha intermitente".
- **Res. CONTRAN 970/2022** (revogou a 268/2008, em vigor desde 01/07/2022): define "lanternas especiais de emergência" como luzes intermitentes ou rotativas **vermelha, azul ou combinação de ambas**.
- **Consequência para o projeto:** as combinações **com branco** (VM/BR, AZ/BR, tricolor) **não estão no conjunto de cores da resolução**. O firmware sai de fábrica em **vermelho/azul**; o uso de branco deve ser validado pela Divisão de Transportes/Diretoria competente da PCDF antes de ser habilitado em serviço. Não encontrei disposição específica sobre viaturas descaracterizadas; isso precisa ser consultado no texto integral da resolução ou na norma interna.

Fontes: [Res. CONTRAN 970/2022 (LegisWeb)](https://www.legisweb.com.br/legislacao/?id=433065), [Res. CONTRAN 268/2008 (LegisWeb)](https://www.legisweb.com.br/legislacao/?id=108967).

---

## 1.1 Arquitetura escolhida

| Item | Decisão | Motivo |
|---|---|---|
| Formato | **Duas meias-barras idênticas** (espelhadas), uma de cada lado do retrovisor interno, com **frente curva** que acompanha o arco do para-brisa e cantos arredondados | O retrovisor e o sensor de chuva ocupam o centro do parabrisa; cada meia-barra (238 mm) cabe inteira na A1 sem emenda; a curvatura (raio `R_vidro`) deixa a barra rente ao vidro em toda a extensão |
| LEDs | **72 LEDs** = 2 × 36; cada meia-barra tem 2 fileiras × 18 colunas, passo 11 mm | 24 vermelhos + 24 azuis + 24 brancos, intercalados (VM-BR-AZ na fileira de cima, AZ-VM-BR na de baixo) para qualquer combinação ficar uniforme |
| Zonas | **4 zonas** (esq. externa, esq. interna, dir. interna, dir. externa) × 3 cores = **12 canais** | Permite padrões alternados, cruzados, centro/pontas e perseguição |
| Acionamento | Strings de **3 LEDs** + **regulador de corrente linear 350 mA** por string; MOSFET low-side por canal | Corrente constante na faixa 12,0–14,4 V sem indutores, sem ruído de rádio, montagem simples |
| Controlador | **Arduino Nano** (ATmega328P, 5 V) | Lógica de 5 V aciona bem os MOSFETs, programa pelo USB no Zorin (Arduino IDE), barato e fácil de trocar |
| Dissipação | **Tampa traseira de alumínio** (barra chata 1-1/2" × 1/8") com a placa de LEDs colada nela | A tampa é o próprio dissipador, voltado para o ar da cabine |
| Fixação | **Doca** presa pelos dois parafusos do suporte do quebra-sol + **braço telescópico** + articulações sem ferramenta + **1 ventosa por meia-barra** (2 no total) | Atende ao requisito "sem ventosa como fixação principal; no máximo duas auxiliares" |

---

## 1.2 LEDs

| Opção | Prós | Contras | Veredito |
|---|---|---|---|
| SMD 5050 / 5730 (fita) | Muito baratos | Baixa intensidade por LED, ângulo muito aberto, ruins sob sol direto | Descartado |
| COB | Muita luz numa área só | Difícil focar, sem efeito "pontos" de estrobo, dissipação concentrada | Descartado |
| RGB num só encapsulamento | Uma posição faz qualquer cor | O branco obtido por RGB é fraco; cada canal de cor rende bem menos que um LED monocromático do mesmo tamanho | Descartado |
| **3535 monocromático de potência (1–3 W)** — ex.: Cree XLamp XP-E2 ou equivalente | Alta intensidade, aceita óptica TIR de 10 mm, base térmica | Exige PCB de alumínio e controle de corrente | **Escolhido** |

**Referência Cree XP-E2** (dados de distribuidor, **confirmar** no datasheet Cree atual):
- Vf branco ≈ 2,84–3,12 V; azul ≈ 2,85–3,14 V; vermelho ≈ 2,18–2,6 V
- Corrente máx. DC: 1200 mA (azul) / 1500 mA (branco, vermelho)
- Coef. térmico de Vf: −2,3 mV/°C (branco), −3,3 mV/°C (azul)

**Corrente de projeto: 350 mA** (≈ 1 W por LED). Fica muito abaixo do máximo, o que dá folga térmica para o carro ao sol. Subir para 700 mA só depois do teste térmico (seção 1.6).

Alternativa mais barata: LEDs 3535 genéricos de 1 W (vermelho 620–630 nm, azul 460–470 nm, branco 6000 K) no mesmo footprint. Têm fluxo e binning piores; compre 10 % a mais.

Fontes: [GoPhotonics — XP-E2](https://gophotonics.com/products/led-light-emitting-diodes/cree-inc/25-107-xlamp-xp-e2), [LCSC — XP-E2](https://www.lcsc.com/product-detail/C17224872.html), [datasheet XP-E2 (alldatasheet)](https://www.alldatasheet.es/html-pdf/862100/CREE/XP-E2/294/3/XP-E2.html).

---

## 1.3 Driver — corrente constante e controle

### Por string: regulador de corrente constante (CCR) onsemi **NSI50350ADT4G**
- 350 mA ± 10 %, 50 V, DPAK de 11 W, 2 terminais, sem componentes externos
- Coeficiente de temperatura negativo: reduz a corrente quando esquenta, o que protege os LEDs
- AEC-Q101 (há a versão automotiva NSV50350ADT4G)
- Atinge 20 % da regulação com 0,5 V de Vak. Para ter os 350 mA completos é preciso alguns volts de folga: **confirmar a curva I×Vak** no datasheet

Fontes: [LCSC C146728](https://www.lcsc.com/product-detail/C146728.html), [Digi-Key](https://azcus.digikey.com/en/products/detail/onsemi/NSI50350ADT4G/2797258), [datasheet (espelho)](https://www.radiolocman.com/datasheet/data.html?di=662393).

### Orçamento de tensão por string (350 mA)

| String | LEDs | Resistor | Folga no CCR a 12,0 V (motor desligado) | Folga a 14,4 V (alternador) | Potência de pico no CCR a 14,4 V |
|---|---|---|---|---|---|
| Branco / azul | 3 × ~3,0 V = 8,7–9,3 V | — | 2,7–3,3 V | 5,1–5,7 V | ≈ 2,0 W |
| Vermelho | 3 × ~2,2 V = 6,3–6,9 V | 8,2 Ω (2,9 V) | 2,2–2,8 V | 4,6–5,2 V | ≈ 1,8 W (+ 1,0 W no resistor) |

O resistor do vermelho tira parte do calor de cima do CCR. Com o motor desligado (12,0 V) o brilho pode cair um pouco: **medir em bancada**.

### Por canal: MOSFET **AO3400A** (N, 30 V, SOT-23, Rds(on) baixo já com Vgs de 2,5–4,5 V)
- Cada canal comuta 2 strings: 0,7 A
- 100 Ω em série no gate + 100 kΩ do gate ao GND, para o canal ficar desligado enquanto o Nano inicializa

### Proteção de entrada
- **Fusível de lâmina 5 A** (no plugue de acendedor com fusível, ou porta-fusível em linha)
- **TVS SMBJ18A** na entrada (grampeia em ~29 V, abaixo dos 30 V do AO3400A). Com polaridade invertida, o TVS conduz e queima o fusível (proteção por *crowbar*)
- **Regulador LM2936Z-5.0** (LDO automotivo, aceita transientes de 60 V e polaridade invertida) alimentando o pino 5V do Nano; **não usar o regulador interno do Nano** a partir de 12–14 V
- Capacitores: 470 µF/35 V + 100 nF na entrada; capacitor de saída do LM2936 conforme o datasheet (≥ 10 µF, com ESR dentro da faixa especificada)

### Consumo (calculado)

| Situação | Corrente | Potência a 14,4 V |
|---|---|---|
| Pico (4 zonas acesas, uma cor cada; o firmware garante que nunca passa disso) | 2,8 A | ≈ 40 W |
| Média, padrão "duplo alternado" | ≈ 0,56 A | ≈ 8 W |
| Média, padrão "simultâneo" (o mais pesado) | ≈ 1,05 A | ≈ 15 W |
| Modo NOITE (31 % de PWM) | ~1/3 dos valores acima | — |

---

## 1.4 PCB

| Opção | Veredito |
|---|---|
| FR4 | Descartado para os LEDs: não tira calor de 36 LEDs + 12 CCRs |
| **PCB de alumínio (MCPCB) 1 camada, 1,6 mm, 207 × 24 mm, uma por meia-barra (idênticas)** | **Escolhido.** A JLCPCB fabrica alumínio de 1 camada; uma placa longa elimina fios entre módulos |
| Módulos segmentados (6 cabeças por lado) | Mais conectores e mais pontos de falha; só vale se a placa longa ficar cara |

Placa de LEDs: **207 × 24 mm** (x de 6,5 a 213,5 mm a partir da ponta externa). Nela ficam 36 LEDs, 12 CCRs (DPAK), 4 resistores de 8,2 Ω 2512, 1 NTC 10 k (só a placa esquerda precisa) e os pads de saída (12V, 6 retornos, NTC).
A placa portadora do Nano (FR4) leva os 12 MOSFETs, o LM2936, o TVS e os capacitores. Para o protótipo serve placa perfurada com os AO3400A em adaptadores SOT-23→DIP.

**Pendente:** desenhar as duas placas no KiCad (o esquema elétrico está no doc 03).

---

## 1.5 Óptica

- **Lente TIR Ø10 mm para 3535** (família Carclo 10 mm para XP-E/XP-E2, ou genéricas "lente 10 mm 3535"), feixe de 25–30°. Concentra a luz para a frente, que é o que garante visibilidade sob sol direto. Altura útil prevista no CAD: 7 mm (**confirmar** no modelo comprado).
- **Janela frontal: policarbonato 2 mm, transparente**, 207 × 25 mm, colada por dentro da carcaça com silicone neutro. Ela verga sem esforço para acompanhar a frente curva (flecha de ~2,4 mm). PC suporta impacto e calor; prefira o PC com proteção UV.
- **Anti-reflexo:** o vidro do parabrisa reflete parte da luz de volta para a cabine. Coloque uma tira de EVA preto fosco (5 mm) entre a borda inferior da carcaça e o vidro, de ponta a ponta, para o motorista não ser ofuscado. Esse item é obrigatório.

---

## 1.6 Dissipação térmica (ponto crítico)

- A tampa traseira é uma **barra chata de alumínio 1-1/2" × 1/8"** (38,1 × 3,18 mm), com a placa de LEDs colada com **adesivo térmico** (tipo Arctic Silver Thermal Adhesive), sem furos na área dos LEDs.
- Pinte a face externa com tinta **preta fosca** (alta temperatura): aumenta a troca de calor por radiação.
- **Estimativa grosseira:** 4–8 W médios por meia-barra numa placa de ~93 cm² de face exposta, com convecção natural mais radiação, dá uma elevação de 25–45 °C sobre o ar interno. Com a cabine a 70 °C, a placa chegaria a **95–115 °C** em uso contínuo e prolongado. É **acima do que o PETG suporta em contato** (Tg ~80 °C).
- Mitigações já no projeto:
  1. NTC na placa + **redução térmica no firmware** (31 % de brilho acima de 70 °C, 12 % acima de 85 °C).
  2. A carcaça plástica toca o alumínio só pela junta de TPU, na borda, longe dos LEDs.
  3. Corrente modesta (350 mA).
- **Teste obrigatório na Fase 3**: termopar no alumínio, carro ao sol, 30 min em cada padrão. Se passar de 85 °C, trocar a barra chata por um **perfil dissipador aletado** de 40 mm (+ ~150 g por lado) ou reduzir a corrente.
- **Risco de queimadura:** a face de alumínio pode passar de 60 °C. Não tocar logo após o uso.

---

## 1.7 Materiais de impressão

| Material | Tg aprox. | Veredito |
|---|---|---|
| PLA | ~60 °C | **Proibido.** Deforma no carro ao sol |
| **PETG** | ~80 °C | **Usar no protótipo e nas peças de fixação.** No limite para 80 °C: imprimir em cor clara nas peças expostas e conferir a deformação após o teste ao sol. A carcaça e a caixa encostam no alumínio, que pode passar de 85 °C: nelas, PETG só no protótipo |
| ASA | ~100 °C, resistente a UV | **Ideal para a carcaça definitiva.** Na A1 aberta (sem câmara) entorta em peças de 238 mm; tentar com brim, mesa a 100 °C e abrigo contra correntes de ar |
| TPU 95A | — | Junta de vedação e pé anti-vibração |

Configuração sugerida para PETG funcional: 4–6 paredes, 5 camadas sólidas em cima e embaixo, 40 % de preenchimento giroide nas peças de fixação. A doca, o engate e o pino vão a 100 % (são as peças que levam carga).

---

## 1.8 Cabos e conectores

| Trecho | Cabo | Conector |
|---|---|---|
| Acendedor → caixa de controle (1,8 m) | PP 2 × 0,75 mm² (OD ~6 mm) | Plugue de acendedor **com fusível 5 A e chave liga/desliga** + **GX16-2** em linha perto da barra (desconexão rápida) |
| Caixa → meia-barra esquerda | Fios de silicone 22 AWG, do alumínio direto para a caixa (furo Ø8 + anel de silicone) | — (as duas peças ficam montadas juntas) |
| Caixa → meia-barra direita (~0,6 m) | Cabo manga 8 vias 24 AWG (OD ~5,5 mm); o 12 V usa 2 vias | **GX16-8** em linha |
| Vedação | Prensa-cabo **PG7** (cabos de 3–6,5 mm) | — |

---

## 1.9 Vedação (IP65)

- Janela: PC colado com silicone neutro (cura acética ataca o PC e os contatos: **não usar**)
- Tampa traseira: junta impressa em TPU de 1 mm + 12 parafusos M3, com espaçamento ≤ 55 mm
- Passagens de cabo: prensa-cabos PG7; na passagem Ø8 do alumínio para a caixa, silicone neutro
- O FDM não é estanque por natureza: 5+ paredes e, se preciso, verniz/selador nas faces internas
- **Ensaio caseiro tipo IPX5:** jato de mangueira (bico ~6 mm), 3 min de cada lado, a 2,5–3 m; abrir e inspecionar. Poeira: a junta + PG7 devem bastar para IP5X. É um ensaio indicativo, não uma certificação.

---

## 1.10 Fixação no quebra-sol (avaliação)

- **Escolhido (v0.4, decisão do usuário):** "doca" presa **sob o suporte do quebra-sol** pelos **dois parafusos originais** (`parafusos_doca`, furos oblongos de ±5 mm para ajuste). Com dois parafusos o suporte prende a placa fina de verdade e o momento do braço vira um binário nos parafusos (≈ 70 N por parafuso a 1 g com 26 mm entre eles), em vez de dobrar a placa. Só o trecho que fica preso sob o suporte (`L_lingueta`, 16 mm por padrão) tem 2,5 mm; dali em diante a doca tem a altura toda do soquete (14,4 mm), porque é essa seção que recebe o momento do braço. Instala uma vez com chave; depois, **a barra entra e sai sem ferramentas** (encaixe + pino magnético).
- **Por que mudou (v0.2):** na v0.1 a lingueta de 26 × 2,5 mm ia do parafuso ao soquete e levava todo o momento do braço em balanço (≈ 1,7 N·m): ≈ 62 MPa a 1 g, acima da resistência do PETG (~45–50 MPa). **Atenção (auditoria v0.2):** encurtar o trecho fino não basta. O momento do braço continua passando pela seção de 2,5 mm na borda do suporte (≈ 65 MPa a 1 g), a não ser que o suporte do quebra-sol aperte a lingueta com rigidez até essa borda, o que só o carro real responde. Para aguentar com folga, a doca precisa ser de **alumínio** (lingueta de 5 mm, parafuso do quebra-sol 5 mm mais longo) ou ancorada nos **dois** parafusos do suporte. **Medir no carro** até onde o suporte do quebra-sol cobre a lingueta e ajustar `L_lingueta`: o degrau tem de ficar logo na borda do suporte.
- O parafuso original pode ficar curto com a doca embaixo: medir e, se preciso, usar um parafuso de mesma rosca 3 mm mais longo.
- A doca sob pressão do parafuso, em PETG, pode **fluir (creep)** no calor. Se a barra começar a folgar, refazer a doca em **chapa de alumínio de 2 mm** (o desenho serve de gabarito).
- **Plano B** (carros onde o suporte não permite a doca): abraçadeira na haste do quebra-sol, numa versão futura, se necessário.
- **Airbag de cortina:** em muitos carros ele corre pela borda do teto junto à coluna A. A doca e o braço **não podem ficar no caminho do airbag**. Conferir no manual do veículo antes de instalar.

---

## 1.11 Revisão v0.6: fita de LED, módulos prontos e caixa separada

**Por que mudou.** A banca reprovou a lista de compras da v0.5 por um defeito fatal: os 24 reguladores NSI50350 (SMC, 7 × 6 mm) não cabiam na placa de LEDs de 207 × 24 mm entre as lentes Ø10. Não existe CCR de 350 mA menor. O usuário decidiu:
1. usar **fita de LED** no lugar da placa de LEDs de potência;
2. usar **placas prontas** da Shopee e do AliExpress nos subcircuitos;
3. tirar a caixa de controle da barra e montá-la **separada**, sob o painel.

**Fita de LED.**
- Fita 12 V, 2835, 120 LED/m, **5 mm** de largura, colada direto no alumínio, que é o dissipador.
- Três fileiras por meia-barra (VM em cima, BR no meio, AZ embaixo), cada uma com dois trechos de 100 mm (zona externa e interna) = 72 LEDs por meia-barra.
- A largura de 5 mm deixa faixas de 3 mm acima e abaixo para os fios. A de 8 mm não deixaria.
- **Compromisso aceito:** cerca de 1 W por canal contra ~6 W antes, e sem óptica. O brilho ao sol é bem menor, e o teste ao sol (doc 04, seção 4.10) é eliminatório.
- Se faltar brilho, a primeira troca é por uma fita de ≥ 14,4 W/m do mesmo tamanho, sem mudar o CAD.
- A fita tem resistores por grupo de 3 LEDs. Por isso a corrente sobe com a tensão do carro: a 14,4 V, cerca de +40 % nos vermelhos e mais nos azuis e brancos. O ciclo dos flashes e o limite térmico por NTC compensam. Medir na bancada.

**Caixa de controle separada.**
- A caixa tem 219 × 115 × 34 mm e fica sob o painel, perto do acendedor. Assim o para-brisa fica sem esse peso e calor, e a caixa não aparece por fora.
- Cada meia-barra liga à caixa pelo próprio cabo de 10 vias, com **GX16-10 em linha** perto da barra. O mesmo conector e a mesma pinagem servem nos dois lados.
- Os módulos assentam em bolsos rasos e são presos com VHB e abraçadeira. Isso evita depender da posição dos furos de fixação, que os anúncios não informam.

**Módulos escolhidos** (pesquisa no doc 05):

| Função | Módulo | Por quê |
|---|---|---|
| 12 saídas low-side | eletechsup **OPMSC12** (entrada PNP 3,3–8 V, saída NPN) | Única placa pronta de 12 canais com ficha técnica: optoacoplada, 5 A por canal, PWM até 2 kHz. O firmware usa ~250 Hz. |
| 5 V para o Nano | buck **Waveshare 6–36 V** (ou MP1584EN) | Substitui o LDO LM2936 em TO-92, que passaria de 125 °C de junção a 80 °C de ambiente |
| Inversão de polaridade | módulo de diodo ideal **LTC4359** | Bloqueia a inversão sem queimar fusível |
| Transientes | **5KP16A** (5 kW) + 470 µF nos bornes | O SMBJ18A (600 W) era pequeno para o carro |
| Ligações do Nano | adaptador de bornes "Nano terminal adapter" | Elimina a placa perfurada |

**Corrente nas entradas da OPMSC12.** Cada entrada pede 8–15 mA do pino do Nano. O firmware acende no máximo uma cor por zona, ou seja, 4 entradas ao mesmo tempo, até 60 mA no total. Isso fica dentro do limite do ATmega328P.

**Fusível.** O consumo caiu para ~0,6 A no pior caso. O fusível do plugue passa a ser de **3 A**, no formato do porta-fusível do plugue comprado.

**Cabos.**

| Trecho | Cabo | Conector / vedação |
|---|---|---|
| Acendedor → caixa (3 m) | PP 2 × 0,75 mm² | Plugue com fusível 3 A; PG9 na caixa |
| Caixa → perto de cada meia-barra (~1,5 m, ×2) | Manga 10 vias 24 AWG, cobre | PG9 na caixa; **fêmea** GX16-10 na ponta |
| Rabicho de cada meia-barra (0,3 m, ×2) | Manga 10 vias 24 AWG | Plugue GX16-10; **PG7 (rosca 8 mm, contraporca ≤ SW17)** no alumínio; capa retirada dentro da barra |
| Dentro da barra | Silicone 26 AWG | Nas faixas livres de 3 mm |

**Braço reforçado (correções da auditoria da v0.4).**
- Corrediça e tubo giraram 90°: seção de 8 × 12 mm de pé, com a trava M4 atravessando na horizontal, perto da linha neutra.
- A língua do engate passou de 14 × 8 para 16 × 11 mm, num canal de 16,4 × 11,3 mm com frisos de 0,4 mm (aperto de ~0,1 mm).
- As abas de articulação passaram de 8 para 10 mm (M5 × 25).
- Estimativa por razão de módulos de seção a 5 g, a reconferir na banca: corrediça ~29 MPa (era 67), língua ~35 MPa (era 80), aba 31–39 MPa (era 49).


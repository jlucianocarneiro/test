# 5 — Lista de compras: eletrônica (v0.6)

Revisão de **22/10/2026**. Na v0.6 a barra passou a usar **fita de LED** e a caixa de controle passou a usar **módulos prontos**, comprados na **Shopee** e no **AliExpress**. Saíram da lista: LEDs 3535, reguladores NSI50350, resistores 2512, lentes TIR, PCB de alumínio, MOSFETs AO3400A, adaptadores SOT-23, LM2936, placa perfurada e os conectores GX16-2/GX16-8.

**Como ler os links:**
- **Anúncio:** link de um produto específico.
- **Busca:** página de resultados com o termo exato a usar. Escolha o vendedor pelas avaliações e pela ficha técnica, conferindo os requisitos da coluna "O que conferir".
- **Limitação desta revisão:** deste ambiente não foi possível abrir as páginas da Shopee, do AliExpress nem do Mercado Livre (o acesso automatizado é bloqueado). Os anúncios citados vieram de resultados de busca e das páginas dos fabricantes. **Preço, estoque e variante precisam ser conferidos no anúncio antes de comprar.** Nenhum preço desta lista foi confirmado no carrinho.

Quantidades para **uma barra completa** (2 meias-barras + caixa de controle), já com reserva.

---

## 5.1 Meias-barras (fita de LED)

Cada meia-barra tem 3 fileiras de fita (vermelha em cima, branca no meio, azul embaixo). Cada fileira tem 2 trechos de **100 mm** (zona externa e zona interna). No total são **0,4 m de cada cor** (4 trechos), com 12 LEDs por trecho e 144 LEDs na barra.

| # | Item | Qtd | O que conferir | Onde |
|---|---|---|---|---|
| 1 | **Fita de LED 12 V vermelha**, 2835, 120 LED/m, **5 mm de largura**, IP65 (resinada) | 1 m | 620–630 nm; **12 V** (não 5 V nem 24 V); corte a cada 3 LEDs = **25 mm**; ≥ 9,6 W/m; largura **5 mm** (a de 8 mm não cabe com os fios) | [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-2835-led-strip-5mm-12v-120leds-red-ip65.html) · [Busca Shopee](https://shopee.com.br/search?keyword=fita%20led%202835%205mm%2012v%20vermelha) |
| 2 | **Fita de LED 12 V azul**, mesmas características | 1 m | 460–470 nm | [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-2835-led-strip-5mm-12v-120leds-blue-ip65.html) · [Busca Shopee](https://shopee.com.br/search?keyword=fita%20led%202835%205mm%2012v%20azul) |
| 3 | **Fita de LED 12 V branca fria**, mesmas características | 1 m | 6000–6500 K | [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-2835-led-strip-5mm-12v-120leds-cold-white-ip65.html) · [Busca Shopee](https://shopee.com.br/search?keyword=fita%20led%202835%205mm%2012v%20branco%20frio) |
| 4 | **Termistor NTC 10 k B3950**, gota de epóxi com fios | 2 | 10 kΩ a 25 °C; vai colado no alumínio entre as fitas | [Anúncio ML](https://produto.mercadolivre.com.br/MLB-1295313004-b3950-sensor-de-temperatura-termistor-ntc-10k-2-unidades-_JM) · [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-ntc-10k-b3950-epoxy.html) |
| 5 | **Fio de silicone 26 AWG** (vermelho e preto + 3 cores) | 2 m de cada | fiação dentro da barra, nas faixas de 3 mm acima e abaixo das fitas | [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-26awg-silicone-wire.html) · [Busca Shopee](https://shopee.com.br/search?keyword=fio%20silicone%2026%20awg) |
| 6 | **Prensa-cabo PG7**, nylon, **rosca de 8 mm** (não o "longo") | 2 (+1) | contraporca **SW15 a SW17**; veda cabo de 3 a 6,5 mm | [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-pg7-cable-gland-nylon.html) · [Busca Shopee](https://shopee.com.br/search?keyword=prensa%20cabo%20pg7) |

**Brilho (leia antes de comprar):** a fita entrega muito menos luz que a placa de LEDs de potência da v0.5. Por canal, são **~1 W** (12 LEDs × 0,08 W), contra ~6 W de LEDs antes, e sem lente. Isso é suficiente para ser visto de perto e à noite, mas **ao sol, através do vidro, a visibilidade é limitada**. O teste ao sol (doc 04, seção 4.10) decide se serve. Se faltar brilho, a primeira troca é a fita por uma de 2835 com **≥ 14,4 W/m** do mesmo tamanho. O CAD não muda.

**Resina IP65 e calor:** a resina pode amarelar com o tempo no para-brisa. A barra já é fechada (janela de policarbonato + junta). Por isso uma fita **IP20 ou IP33** (sem resina) também serve e dissipa melhor. Se a fita IP65 amarelar, troque por uma dessas.

---

## 5.2 Caixa de controle (módulos prontos)

| # | Item | Qtd | O que conferir | Onde |
|---|---|---|---|---|
| 7 | **Placa de 12 canais eletechsup OPMSC12**, variante **"PNP input 3,3–8 V / NPN output"** | 1 | Saída NPN (low-side), 5 A por canal, PWM até 2 kHz, 107 × 72 × 12 mm (placa sem caixa). **A variante "PNP output" não serve** (é high-side). Conferir: tipo de borne, furos e corrente por entrada (8–15 mA). | [Página do fabricante](https://eletechsup.com/products/opmsa04-opmsb08-opmsc12-opmsd164-16ch-3-3v-24v-digital-logic-5a-mos-solid-state-npn-pnp-plc-signal-amplifier) · [AliExpress (família OPMS)](https://www.aliexpress.us/item/3256805658884886.html) · [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-opmsc12.html) |
| 8 | **Arduino Nano V3** (ATmega328P, CH340) | 2 | Um de reserva | [Shopee](https://shopee.com.br/amp/PLACA-COMPATÍVEL-ARDUINO-NANO-V3-ATMEGA328P-CH340-i.359651763.3370096450) · [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-arduino-nano-v3-ch340.html) |
| 9 | **Adaptador de bornes para Nano** ("Nano terminal adapter") | 1 | ~53 × 36 mm, bornes de parafuso. **Não ligar 12 V nele**: o Nano é alimentado pelo buck (5 V no pino 5V). | [AliExpress](https://www.aliexpress.us/item/2251832139409398.html) · [AliExpress (outro)](https://www.aliexpress.us/item/3256801338410149.html) |
| 10 | **Conversor buck 5 V**: Waveshare "DC-DC Buck Mini Module" (entrada 6–36 V), versão com bornes; ou MP1584EN ajustado em 5,0 V | 1 (+1) | Entrada ≥ 28 V; 33 × 16 mm (Waveshare) ou 22 × 17 mm (MP1584EN); ajustar e medir 5,0 V **antes** de ligar o Nano | [Busca AliExpress: Waveshare](https://pt.aliexpress.com/w/wholesale-waveshare-dc-dc-buck-mini-module.html) · [Busca AliExpress: MP1584EN](https://pt.aliexpress.com/w/wholesale-mp1584en.html) · [Busca Shopee: MP1584](https://shopee.com.br/search?keyword=mp1584en) |
| 11 | **Módulo de diodo ideal LTC4359** (proteção contra inversão de polaridade) | 1 | 4–80 V, ≥ 5 A, ~33 × 27 mm | [AliExpress](https://www.aliexpress.com/item/1005008604888805.html) · [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-ltc4359-ideal-diode.html) |
| 12 | **Supressor de transiente 5KP16A** (5 kW, axial) | 2 | Tensão de trabalho 16 V; vai no borne de saída do LTC4359 | [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-5kp16a.html) |
| 13 | **Capacitor eletrolítico 470 µF 35 V 105 °C** | 2 | Junto do 5KP16A | [Busca Shopee](https://shopee.com.br/search?keyword=capacitor%20470uf%2035v) · [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-470uf-35v-105c.html) |
| 14 | **Resistores**: 10 kΩ 1 % (pull-up do NTC), 1 kΩ (botão) + capacitor cerâmico 100 nF | 1 + 1 + 2 | 1/4 W, de terminal | [Busca Shopee: kit de resistores](https://shopee.com.br/search?keyword=kit%20resistores%201%2F4w%201%25) |
| 15 | **Pulsador metálico 12 mm**, NA, à prova d'água | 1 (+1) | IP66 basta dentro do carro; IP67 é melhor. Corpo ≤ 25 mm atrás do painel. | [ML: inox 12 mm IP66](https://produto.mercadolivre.com.br/MLB-4657352776-boto-pulso-inox-12mm-antivandalismo-ip66-push-button-reset-_JM) · [AliExpress: LANBOO 12 mm IP67](https://www.aliexpress.us/item/3256810331531761.html) |
| 16 | **Prensa-cabo PG9** (cabos de 4 a 8 mm) | 3 (+1) | Furo de 15,4 mm na caixa; contraporca ≤ SW24 | [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-pg9-cable-gland-nylon.html) · [Busca Shopee](https://shopee.com.br/search?keyword=prensa%20cabo%20pg9) |
| 17 | **Fita dupla-face VHB** + **abraçadeiras de nylon 2,5 × 100 mm** | 1 + 10 | Fixam os módulos nos bolsos da caixa | [Busca Shopee: VHB](https://shopee.com.br/search?keyword=fita%20vhb%20dupla%20face) |
| 18 | **Terminais tubulares (ilhós) 0,5 mm²** | 1 kit | Pontas dos fios nos bornes (não soltam com vibração) | [Busca Shopee](https://shopee.com.br/search?keyword=terminal%20tubular%200.5mm) |

---

## 5.3 Alimentação, chicote e conectores

| # | Item | Qtd | O que conferir | Onde |
|---|---|---|---|---|
| 19 | **Plugue de acendedor 12 V com fusível** | 1 | Ver o **formato do fusível** do plugue comprado (5 × 20 mm ou 6 × 30 mm, de vidro) | [Anúncio ML](https://produto.mercadolivre.com.br/MLB-2147134692-plug-tomada-12v-macho-acendedor-de-cigarro-c-fuivel-_JM) · [Busca Shopee](https://shopee.com.br/search?keyword=plug%20acendedor%2012v%20com%20fusivel) |
| 20 | **Fusível de 3 A no formato do plugue** (o de fábrica costuma ser de 8–10 A) | 3 | O consumo da barra com fita é de ~0,6 A no pior caso; 3 A protege o cabo e aguenta a carga do capacitor | [Busca Shopee: 5 × 20 mm 3 A](https://shopee.com.br/search?keyword=fusivel%205x20%203A) |
| 21 | **Chave liga/desliga em linha** (opcional) | 1 | 12 V, ≥ 5 A. Tirar o plugue já desliga tudo. | [Busca Shopee](https://shopee.com.br/search?keyword=chave%20liga%20desliga%2012v%20alavanca) |
| 22 | **Cabo PP 2 × 0,75 mm²**, cobre | 3 m | Do acendedor até a caixa; diâmetro ≤ 8 mm (PG9) | [Busca Shopee](https://shopee.com.br/search?keyword=cabo%20pp%202x0%2C75) |
| 23 | **Cabo manga 10 vias 24 AWG**, cobre (não CCA) | 4 m | 2 × ~1,5 m (caixa → perto da barra) + 2 × 0,3 m (rabicho da barra); diâmetro de 4 a 6,5 mm (cabe no PG7) | [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-10-core-24awg-cable.html) · [Busca Shopee](https://shopee.com.br/search?keyword=cabo%20manga%2010%20vias) |
| 24 | **Conector aviação GX16-10**, par **plugue de cabo + fêmea de cabo** (emenda em linha, não a tomada de painel) | 2 pares | 10 pinos; do lado da caixa, sempre a **fêmea** (pinos vivos não ficam expostos) | [Busca AliExpress](https://pt.aliexpress.com/w/wholesale-gx16-10-pin-cable-connector-male-female.html) · [Busca Shopee](https://shopee.com.br/search?keyword=conector%20gx16%2010%20pinos) |
| 25 | **Tubo termorretrátil sortido** | 1 kit | — | [Busca Shopee](https://shopee.com.br/search?keyword=kit%20termoretratil) |

**Por que o GX16-10:** as duas meias-barras usam o mesmo conector e a mesma pinagem (doc 03, seção 3.4). Cada uma tem seu cabo até a caixa, então tirar a barra é só soltar os dois GX16 junto dela. A caixa e o chicote longo ficam no carro.

---

## 5.4 Ferramentas

- Ferro de solda comum (a fita e os fios não precisam de ar quente), estanho e fluxo.
- Multímetro: ajustar o buck em 5,0 V e medir a corrente por canal.
- Fonte de bancada: a ATX com o XL6009 serve para os testes a 12,0 e 14,4 V.

## Resumo de custo

Esta revisão **não tem preços confirmados**: os anúncios não puderam ser abertos daqui. Referências que apareceram nas buscas:
- OPMSC12: US$ 17,99–18,99 na loja do fabricante (485io.com);
- adaptador do Nano: ~US$ 0,67 no AliExpress;
- MP1584EN: 5 unidades por ~R$ 45 na Shopee.

Some o carrinho antes de decidir.

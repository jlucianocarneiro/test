# 5 — Lista de compras: eletrônica (Mercado Livre / Shopee)

Pesquisa feita em **22/10/2026**. Preços e estoque mudam; os valores abaixo são **os que apareceram nos anúncios nesse dia**, só para referência.

- **Anúncio:** link de um produto específico.
- **Busca:** link de uma página de resultados do Mercado Livre, usado quando não achei um anúncio único confiável. Escolha o vendedor pelas avaliações.

Quantidades para **uma barra completa** (2 meias-barras + caixa de controle), já com reserva.

> **Atenção à qualidade:** em marketplace, o "3 W" do título nem sempre é real, e há componentes remarcados. Confira comprimento de onda, tensão e corrente na ficha do anúncio e prefira vendedores com muitas avaliações. Para os itens críticos (LEDs, NSI50350, AO3400A), dá para comprar de distribuidor (LCSC, Digi-Key, Mouser) se o marketplace decepcionar.

---

## 5.1 Placas de LEDs (2 placas idênticas)

| # | Item | Qtd | O que pedir | Onde | Preço visto |
|---|---|---|---|---|---|
| 1 | LED 3 W 3535 **vermelho 620–630 nm** | 27 | "Power LED 3w vermelho 620-630nm 3535 SMD" | [Busca ML: led 3535](https://lista.mercadolivre.com.br/led-3535) · [Busca ML: led 3w smd](https://lista.mercadolivre.com.br/led-3w-smd) | 5 pç por ~R$ 29,99 (DUALSHOP) |
| 2 | LED 3 W 3535 **azul 460–465 nm** | 27 | "Power LED 3w azul 460-465nm 3535 SMD" (não o "azul royal" 450 nm) | mesmas buscas acima | 3 pç por ~R$ 19,90 (DUALSHOP) |
| 3 | LED 3 W 3535 **branco frio 6000–6500 K** | 27 | "Power LED 3w branco frio 6000-6500k 3535 SMD" | mesmas buscas acima | 3 pç por ~R$ 19,99 (DUALSHOP) |
| 4 | **Regulador de corrente NSI50350** (350 mA, 50 V) | 30 | "NSI50350AST3G" (lote de 10) | [Busca ML: driver led 350ma](https://lista.mercadolivre.com.br/driver-led-350ma) (anúncio "10x Driver De Iluminação Nsi50350ast3g Smc-2 350ma 50 V") | 10 pç por ~R$ 65,76 |
| 5 | Resistor **8,2 Ω 2 W SMD 2512** | 10 | "8R2 2512 2W 1%" | **Não encontrei no ML/Shopee.** Comprar na LCSC ou no AliExpress (veja 5.5) | — |
| 6 | Termistor **NTC 10 k B3950** | 2 | sonda de gota/epóxi, 10 k a 25 °C | [Anúncio ML: B3950 NTC 10k, 2 unidades](https://produto.mercadolivre.com.br/MLB-1295313004-b3950-sensor-de-temperatura-termistor-ntc-10k-2-unidades-_JM) | 2 pç por ~R$ 18,30 |
| 7 | **Lente TIR Ø10 mm** para 3535 (25–30°) | 78 | "10mm TIR lens 3535" | **Não encontrei no ML/Shopee.** As do ML ([busca](https://lista.mercadolivre.com.br/lente-colimadora-led)) são de ~20 mm, para LED em estrela, e **não cabem** no passo de 11 mm. Comprar no AliExpress ou na LCSC (veja 5.5) | — |
| 8 | **Adesivo térmico** (cola a placa no alumínio) | 1 | Arctic Silver Thermal Adhesive (epóxi de 2 componentes) | [Busca ML](https://lista.mercadolivre.com.br/arctic-silver-thermal-adhesive-adesivo-termico-de-prata) | conferir |

**Mudança no projeto por causa do item 4:** o NSI50350 vendido no ML é a versão **AST3G, em encapsulamento SMC** (DO-214AB), e não a DPAK (ADT4G) prevista. O comportamento elétrico é o mesmo, mas o SMC dissipa menos. Ao desenhar a placa de LEDs no KiCad, use o footprint **SMC** com área de cobre generosa em volta, e confirme a temperatura no teste de bancada.

---

## 5.2 Caixa de controle

| # | Item | Qtd | O que pedir | Onde | Preço visto |
|---|---|---|---|---|---|
| 9 | **Arduino Nano V3** (ATmega328P, CH340) | 2 | com pinos soldados ou não | [Anúncio ML](https://produto.mercadolivre.com.br/MLB-1328177101-arduino-nano-v3-atmega328p-ch340g-5v-16mhz-pronta-entrega-_JM) · [Shopee](https://shopee.com.br/amp/PLACA-COMPATÍVEL-ARDUINO-NANO-V3-ATMEGA328P-CH340-i.359651763.3370096450) | R$ 30–70 |
| 10 | **MOSFET AO3400A** SOT-23 (marcação A09T) | 16 | lote de 30 | [Anúncio ML: 30 pç](https://www.mercadolivre.com.br/30-transistor-a09t-ao3400-3400-smd-sot23-c-30pc/p/MLB43479788) · [10 pç](https://produto.mercadolivre.com.br/MLB-3244519117-kit-c-10-pcs-mosfet-smd-a09t-ao3400-ao3400a-sot-23-_JM) | 10 pç por ~R$ 15 |
| 11 | **Adaptador SOT-23 → DIP/SIP3** | 16 | lote de 20 | [Anúncio ML: 20 un.](https://www.mercadolivre.com.br/20-unidades-sot23-sot233-turn-sip3-smd-de-dupla-face-turn-d/p/MLB2003482163) | conferir |
| 12 | **Regulador LM2936Z-5.0** (TO-92, LDO automotivo) | 2 | lote de 5 | [Anúncio ML: 5x LM2936Z-5.0](https://produto.mercadolivre.com.br/MLB-1307371384-5x-circuito-integrado-lm2936-to92-lm2936z-50-regulador-5v-_JM) | conferir |
| 13 | **Diodo TVS SMBJ18A** | 2 | lote de 5 ou 10 | [Anúncio ML: 10 pç](https://www.mercadolivre.com.br/pacote-com-10-diodos-tvs-smbj18a-13-f-18v-292v-smb-wefcv/p/MLB2059280816) · [5 pç](https://www.mercadolivre.com.br/diodo-transzorb-smbj18asmddirecionalembalagem-05-pecas/up/MLBU753879774) | 5 pç por ~R$ 11,80 |
| 14 | **Kit de resistores 1/4 W** (tem 100 Ω, 1 k, 10 k e 100 k) | 1 | 600 pç, 30 valores, 1 % | [Anúncio ML](https://produto.mercadolivre.com.br/MLB-5135769266-600-pcs-de-resistores-variados-14w-1-30-valores-box-_JM) | R$ 33–47 |
| 15 | **Capacitor eletrolítico 470 µF 35 V 105 °C** | 1 (+1) | lote de 10 | [Busca ML](https://eletronicos.mercadolivre.com.br/componentes/capacitor-eletrolitico-470uf-35v-105) | 10 pç por ~R$ 17–23 |
| 16 | **Capacitores eletrolíticos variados** (precisa de 1 × 10–22 µF para a saída do LM2936) | 1 kit | kit de 25–50 pç | [Busca ML](https://eletronicos.mercadolivre.com.br/componentes-passivos-capacitores/kit-capacitores-eletroliticos-variados) | 25 pç por ~R$ 29,50 |
| 17 | **Capacitor cerâmico 100 nF 50 V** | 5 | kit de cerâmicos | [Busca ML](https://lista.mercadolivre.com.br/capacitor-ceramico-100nf) | conferir |
| 18 | **Placa perfurada ilhada 5 × 7 cm** | 1 kit | cortar em 80 × 20 mm | [Shopee: kit 10 placas](https://shopee.com.br/Kit-10-Placas-De-Fenolite-Ilhada-5-X-7-Cm-Pcb-Perfurada-i.307799235.6478699735) · [ML: kit 10](https://produto.mercadolivre.com.br/MLB-2798018364-placa-fenolite-perfurada-5x7cm-pcb-projetos-kit-10-pecas-_JM) | 10 pç por ~R$ 17,56 |
| 19 | **Pulsador metálico 12 mm**, momentâneo, NA | 1 (+1) | inox, antivandalismo | [Anúncio ML: inox 12 mm IP66](https://produto.mercadolivre.com.br/MLB-4657352776-boto-pulso-inox-12mm-antivandalismo-ip66-push-button-reset-_JM) | ~R$ 16,90 |

**Sobre o item 19:** não encontrei pulsador de **12 mm com IP67**. Os de IP67 são de 16 mm. O de 12 mm em inox é **IP66**, o que basta dentro do carro. Se preferir o IP67 de 16 mm, aumento o furo da tampa da caixa (`d_botao`).

---

## 5.3 Alimentação, cabos e conectores

| # | Item | Qtd | O que pedir | Onde | Preço visto |
|---|---|---|---|---|---|
| 20 | **Plugue de acendedor 12 V com fusível** | 1 | troque o fusível de fábrica (8–10 A) por um de **5 A** do mesmo tipo | [Anúncio ML](https://produto.mercadolivre.com.br/MLB-2147134692-plug-tomada-12v-macho-acendedor-de-cigarro-c-fuivel-_JM) · [ML: com rabicho](https://www.mercadolivre.com.br/plug-acendedor-de-cigarro-com-fusivel-e-rabicho/up/MLBU1978933192) | conferir |
| 21 | **Porta-fusível lâmina em linha, à prova d'água** + **fusível mini lâmina 5 A** | 1 + kit | fusível 5 A de reserva | [Busca ML: porta-fusível lâmina](https://lista.mercadolivre.com.br/porta-fusivel-lamina) · [ML: kit mini 5 A](https://lista.mercadolivre.com.br/fusivel-mini-5a) | porta ~R$ 11–30 · kit ~R$ 12–25 |
| 22 | **Chave liga/desliga em linha** (opcional) | 1 | alavanca 12 V, ≥ 10 A | [Busca ML](https://lista.mercadolivre.com.br/chave-liga-desliga-12v) (ex.: "Chave Alavanca Metal 12v 20a ASW-07") | conferir |
| 23 | **Cabo PP 2 × 0,75 mm²** | 2 m (compre 5 m) | flexível, Inmetro | [Busca ML](https://lista.mercadolivre.com.br/cabo-pp-2x0,75mm) | ~R$ 25 por 5 m |
| 24 | **Cabo manga 8 vias 24 AWG** | 1 m (compre 3 m) | blindado ou não | [Busca ML](https://lista.mercadolivre.com.br/cabo-manga-8-vias-24awg) (ex.: "Tiaflex 3 m") | 3 m por ~R$ 48–72 |
| 25 | **Fio de silicone 22 AWG** (vermelho, preto e cores) | ~2 m de cada | kit de cores | [Busca ML](https://lista.mercadolivre.com.br/fio-siliconado-22-awg) | 6 m + 6 m por ~R$ 19–76 |
| 26 | **Conector aviação GX16-2** (par macho/fêmea de cabo) | 1 par | alimentação | [Busca ML](https://lista.mercadolivre.com.br/conector-gx16-2-vias) | par ~R$ 19,89 |
| 27 | **Conector aviação GX16-8** (par macho/fêmea de cabo) | 1 par | enlace com a meia-barra D | [Anúncio ML](https://produto.mercadolivre.com.br/MLB-1207246680-conector-gx16-8-16mm-8-pinos-otima-qualidade-conjunto-mafe-_JM) · [ML: par 8 vias](https://www.mercadolivre.com.br/par-de-conector-circular-gx16-mike-8-vias/p/MLB35851040) | conferir |
| 28 | **Prensa-cabo PG7** (cabo 3–6,5 mm) | 3 (kit de 10) | nylon PA66, vedação NBR | [Busca ML](https://lista.mercadolivre.com.br/prensa-cabos-pg7) · [ML: Metaltex](https://produto.mercadolivre.com.br/MLB-949222643-prensa-cabo-longo-pg7-ch-pg7l-7-metaltex-_JM) | kit 10 por ~R$ 20 |
| 29 | **Tubo termorretrátil sortido** | 1 kit | — | [Busca ML](https://lista.mercadolivre.com.br/kit-termoretratil) | conferir |

**Sobre o item 20:** não encontrei plugue de acendedor com **chave embutida**. Por isso a chave virou o item 22, em linha e opcional, porque tirar o plugue já desliga tudo.

---

## 5.4 Fabricação fora do marketplace

| # | Item | Qtd | Onde |
|---|---|---|---|
| 30 | **PCB de alumínio** 1 camada, 1,6 mm, 207 × 24 mm (placa de LEDs) | 5 (lote mínimo) | JLCPCB (jlcpcb.com), depois de desenhada no KiCad |
| 31 | **Placa portadora FR4** do Nano (opcional, no lugar da perfurada) | 5 | JLCPCB |

---

## 5.5 O que não está no Mercado Livre / Shopee

| Item | Alternativa | Como buscar |
|---|---|---|
| Lente TIR Ø10 mm para 3535 | AliExpress ou LCSC | "10mm TIR lens 3535 30 degree" |
| Resistor 8,2 Ω 2512 2 W | LCSC (dá para pedir junto com a PCB da JLCPCB) | "8.2Ω 2512 2W" |
| NSI50350 em DPAK (ADT4G), se preferir o encapsulamento original | LCSC C146728, Digi-Key, Mouser | "NSI50350ADT4G" |

Pedir a PCB de alumínio na JLCPCB com **montagem dos componentes SMD (PCBA)** resolve de uma vez os itens 1–5 e 7. A JLCPCB compra LEDs, CCRs e resistores da LCSC e entrega a placa soldada, o que também elimina a soldagem com ar quente.

---

## 5.6 Ferramentas (se ainda não tiver)

- Soprador de ar quente ou chapa de pré-aquecimento + pasta de solda (os LEDs 3535 têm pad térmico embaixo: o ferro sozinho não solda). Desnecessário se a placa vier montada da JLCPCB.
- Fluxo e malha dessoldadora.
- Fonte de bancada: a ATX com o XL6009 que você está montando serve para os testes a 12,0 e 14,4 V.

## Resumo de custo (só o que tem preço visto)

Os LEDs pesam mais no orçamento: em pacotes de 3–5 unidades, os 81 LEDs saem por ~R$ 540. Procure lotes maiores (de 10 ou 50) do mesmo vendedor, ou monte a placa na JLCPCB. O restante da eletrônica do marketplace fica na faixa de **R$ 350–550**, sem lentes, resistores 2512 e PCB. Confira o total no carrinho.

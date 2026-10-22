// =====================================================================
// Rotolight LED v0.7 — controladora (Arduino Nano / ATmega328P)
//
// Barra única com a fita RGB endereçável SEZO WS2812B (5 V, 144 LED/m,
// 1 m = 144 LEDs, IP65), uma só fileira. A fita é de 5 V: um conversor
// 12 V → 5 V de 10 A, dentro da controladora, alimenta a fita e o Nano.
// Três botões pré-programados (metálicos, 12 mm, na tampa da caixa):
//   D2  VM     → pisca VERMELHO (barra inteira, flash triplo)
//   D3  AZ|VM  → pisca metade AZUL / metade VERMELHO (as metades alternam)
//   D4  BR     → acende BRANCO fixo
// Tocar no botão do modo ativo apaga a barra; tocar em outro troca de modo.
// Ao ligar, a barra começa APAGADA (não acende sozinha ao dar a partida).
//
// Biblioteca: FastLED (Arduino IDE → Gerenciar bibliotecas → "FastLED").
// Ligações: D6 ──[330 Ω]── DIN da fita (fio de dados do conector JST de 3
// pinos); 5 V e GND da fita direto no conversor, com 1000 µF na entrada da
// fita. Botões entre o pino e o GND (pull-up interno).
// Se o vermelho aparecer verde, troque ORDEM_CORES para RGB.
// =====================================================================
#include <FastLED.h>

// ---- Configuração ----------------------------------------------------
#define PINO_DADOS   6
#define ORDEM_CORES  GRB          // WS2812B: GRB
const uint16_t N_LEDS = 144;      // 1 m de fita de 144 LED/m
const uint8_t  PINO_BOTAO[3] = {2, 3, 4};   // VM, AZ|VM, BR
const uint16_t LIMITE_mA = 4000;  // teto de corrente da fita a 5 V (~20 W); o cabo de 0,5 mm² e o calor no alumínio pedem esse limite
const uint8_t  BRILHO_FLASH = 255;
const uint8_t  BRILHO_BRANCO = 255;   // o limite de corrente já reduz o branco cheio (~43 W) para ~20 W
const bool     AZUL_NA_ESQUERDA = true; // metade azul do lado do motorista? (lado de quem olha de dentro)

CRGB leds[N_LEDS];

enum Modo : uint8_t { APAGADO = 0, VERMELHO = 1, METADE = 2, BRANCO = 3 };
Modo modo = APAGADO;
uint32_t t0 = 0;                  // início do ciclo do modo atual

// ---- Padrões ---------------------------------------------------------
// Flash triplo: 3 × (50 ms aceso + 50 ms apagado), depois pausa.
// Devolve true se, no instante t (ms desde o início do bloco), o flash está aceso.
bool flashTriplo(uint32_t t) {
  if (t >= 300) return false;
  return (t % 100) < 50;
}

void pintaTudo(CRGB c) { fill_solid(leds, N_LEDS, c); }

void pintaMetades(CRGB esq, CRGB dir) {
  uint16_t meio = N_LEDS / 2;
  fill_solid(leds, meio, esq);
  fill_solid(leds + meio, N_LEDS - meio, dir);
}

void desenha(uint32_t agora) {
  uint32_t t = agora - t0;
  switch (modo) {
    case APAGADO:
      pintaTudo(CRGB::Black);
      break;
    case VERMELHO: {               // ciclo de 600 ms: flash triplo + pausa
      bool on = flashTriplo(t % 600);
      FastLED.setBrightness(BRILHO_FLASH);
      pintaTudo(on ? CRGB(255, 0, 0) : CRGB::Black);
      break;
    }
    case METADE: {                 // ciclo de 1000 ms: metade azul pisca, depois a vermelha
      uint32_t c = t % 1000;
      bool primeira = c < 500;
      bool on = flashTriplo(c % 500);
      CRGB az = CRGB(0, 0, 255), vm = CRGB(255, 0, 0), ap = CRGB::Black;
      CRGB esq, dir;
      CRGB cor1 = AZUL_NA_ESQUERDA ? az : vm;   // cor da metade esquerda
      CRGB cor2 = AZUL_NA_ESQUERDA ? vm : az;   // cor da metade direita
      if (primeira) { esq = on ? cor1 : ap; dir = ap; }
      else          { esq = ap; dir = on ? cor2 : ap; }
      FastLED.setBrightness(BRILHO_FLASH);
      pintaMetades(esq, dir);
      break;
    }
    case BRANCO:
      FastLED.setBrightness(BRILHO_BRANCO);
      pintaTudo(CRGB(255, 255, 255));
      break;
  }
  FastLED.show();
}

// ---- Botões (com filtro de 30 ms) -------------------------------------
uint8_t estadoAnt[3] = {HIGH, HIGH, HIGH};
uint32_t tMudou[3] = {0, 0, 0};

void trataBotoes(uint32_t agora) {
  for (uint8_t i = 0; i < 3; i++) {
    uint8_t e = digitalRead(PINO_BOTAO[i]);
    if (e != estadoAnt[i] && agora - tMudou[i] > 30) {
      tMudou[i] = agora;
      estadoAnt[i] = e;
      if (e == LOW) {                         // apertou
        Modo pedido = (Modo)(i + 1);
        modo = (modo == pedido) ? APAGADO : pedido;
        t0 = agora;
      }
    }
  }
}

// ---- Principal -------------------------------------------------------
void setup() {
  for (uint8_t i = 0; i < 3; i++) pinMode(PINO_BOTAO[i], INPUT_PULLUP);
  FastLED.addLeds<WS2812B, PINO_DADOS, ORDEM_CORES>(leds, N_LEDS);
  FastLED.setMaxPowerInVoltsAndMilliamps(5, LIMITE_mA);
  pintaTudo(CRGB::Black);
  FastLED.show();
}

void loop() {
  uint32_t agora = millis();
  trataBotoes(agora);
  desenha(agora);
}

// =====================================================================
// Rotolight LED v0.7 — controladora (Arduino Nano / ATmega328P)
//
// Barra única com fita RGB endereçável WS2815 (12 V), uma só fileira.
// Três botões pré-programados (metálicos, 12 mm, na tampa da caixa):
//   D2  VM     → pisca VERMELHO (barra inteira, flash triplo)
//   D3  AZ|VM  → pisca metade AZUL / metade VERMELHO (as metades alternam)
//   D4  BR     → acende BRANCO fixo
// Tocar no botão do modo ativo apaga a barra; tocar em outro troca de modo.
// Ao ligar, a barra começa APAGADA (não acende sozinha ao dar a partida).
//
// Biblioteca: FastLED (Arduino IDE → Gerenciar bibliotecas → "FastLED").
// Ligações: D6 ──[330 Ω]── DI da fita; BI do primeiro LED ao GND (conferir
// no anúncio da fita). Botões entre o pino e o GND (pull-up interno).
// Se o vermelho aparecer verde, troque ORDEM_CORES para GRB.
// =====================================================================
#include <FastLED.h>

// ---- Configuração ----------------------------------------------------
#define PINO_DADOS   6
#define ORDEM_CORES  RGB          // WS2815: a maioria é RGB; se não, GRB
const uint16_t N_LEDS = 151;      // 144 LED/m × 1,052 m de fita (AJUSTAR à fita cortada)
const uint8_t  PINO_BOTAO[3] = {2, 3, 4};   // VM, AZ|VM, BR
const uint16_t LIMITE_mA = 3000;  // teto de corrente da fita (12 V); fusível de 5 A no plugue
const uint8_t  BRILHO_FLASH = 255;
const uint8_t  BRILHO_BRANCO = 140;   // branco fixo é contínuo: brilho menor para não esquentar
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
  FastLED.addLeds<WS2815, PINO_DADOS, ORDEM_CORES>(leds, N_LEDS);
  FastLED.setMaxPowerInVoltsAndMilliamps(12, LIMITE_mA);
  pintaTudo(CRGB::Black);
  FastLED.show();
}

void loop() {
  uint32_t agora = millis();
  trataBotoes(agora);
  desenha(agora);
}

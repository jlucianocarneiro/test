// =====================================================================
// Rotolight LED — controlador estroboscópico (Arduino Nano / ATmega328P)
//
// 4 zonas (esq. externa, esq. interna, dir. interna, dir. externa) ×
// 3 cores (vermelho, azul, branco) = 12 canais low-side (MOSFET AO3400A).
// Cada canal acende 2 strings de 3 LEDs a 350 mA (reguladores NSI50350).
//
// Regra de corrente: cada zona acende no máximo UMA cor por vez
// (pico = 4 zonas × 0,7 A = 2,8 A). Os padrões são codificados por zona,
// então a regra é garantida pela própria estrutura dos dados.
//
// Botão (D2 → GND, pulsador 12 mm IP67 na tampa da caixa de controle):
//   toque curto (< 0,6 s)   → próximo padrão
//   toque longo (0,6–2,5 s) → próxima combinação de cores
//   muito longo (> 2,5 s)   → alterna modo DIA (100 %) / NOITE (31 %)
// A escolha fica gravada na EEPROM.
//
// Proteção térmica: NTC 10k (B3950) na placa de LEDs esquerda, em A6
// com pull-up de 10k. Acima de 70 °C limita a 31 %; acima de 85 °C
// limita a 12,5 %; volta ao normal abaixo de 65 °C.
// =====================================================================
#include <EEPROM.h>
#include <avr/pgmspace.h>

// ---- Pinos -----------------------------------------------------------
enum { VM = 0, AZ = 1, BR = 2 };
const uint8_t PINO[4][3] = {
  // VM  AZ  BR
  {  3,  4,  5 },   // zona 0: esquerda externa
  {  6,  7,  8 },   // zona 1: esquerda interna
  {  9, 10, 11 },   // zona 2: direita interna
  { 12, A0, A1 },   // zona 3: direita externa
};
const uint8_t PINO_BOTAO = 2;
const uint8_t PINO_NTC = A6;

// ---- Padrões ---------------------------------------------------------
// Cada passo: duração em unidades de 10 ms + estado das 4 zonas
// (2 bits por zona: 0 apagada, 1 cor A, 2 cor B; zona 0 nos bits baixos).
struct Passo { uint8_t dur10; uint8_t zonas; };
#define Z(z0, z1, z2, z3) ((z0) | ((z1) << 2) | ((z2) << 4) | ((z3) << 6))
#define ESQ_A Z(1, 1, 0, 0)
#define DIR_B Z(0, 0, 2, 2)
#define APAG  Z(0, 0, 0, 0)

const Passo P_DUPLO[] PROGMEM = {
  {5, ESQ_A}, {5, APAG}, {5, ESQ_A}, {10, APAG},
  {5, DIR_B}, {5, APAG}, {5, DIR_B}, {10, APAG},
};
const Passo P_QUADRUPLO[] PROGMEM = {
  {4, ESQ_A}, {4, APAG}, {4, ESQ_A}, {4, APAG}, {4, ESQ_A}, {4, APAG}, {4, ESQ_A}, {8, APAG},
  {4, DIR_B}, {4, APAG}, {4, DIR_B}, {4, APAG}, {4, DIR_B}, {4, APAG}, {4, DIR_B}, {8, APAG},
};
const Passo P_TRIPLO[] PROGMEM = {
  {5, ESQ_A}, {5, APAG}, {5, ESQ_A}, {5, APAG}, {5, ESQ_A}, {15, APAG},
  {5, DIR_B}, {5, APAG}, {5, DIR_B}, {5, APAG}, {5, DIR_B}, {15, APAG},
};
const Passo P_PERSEGUICAO[] PROGMEM = {
  {7, Z(1, 0, 0, 0)}, {7, Z(0, 1, 0, 0)}, {7, Z(0, 0, 2, 0)}, {7, Z(0, 0, 0, 2)},
  {7, Z(0, 0, 2, 0)}, {7, Z(0, 1, 0, 0)},
};
const Passo P_CENTRO_PONTAS[] PROGMEM = {
  {5, Z(0, 1, 1, 0)}, {5, APAG}, {5, Z(0, 1, 1, 0)}, {10, APAG},
  {5, Z(2, 0, 0, 2)}, {5, APAG}, {5, Z(2, 0, 0, 2)}, {10, APAG},
};
const Passo P_CRUZADO[] PROGMEM = {
  {6, Z(1, 0, 1, 0)}, {4, APAG}, {6, Z(0, 2, 0, 2)}, {4, APAG},
};
const Passo P_SIMULTANEO[] PROGMEM = {
  {5, Z(1, 1, 1, 1)}, {5, APAG}, {5, Z(1, 1, 1, 1)}, {5, APAG}, {5, Z(1, 1, 1, 1)}, {15, APAG},
  {5, Z(2, 2, 2, 2)}, {5, APAG}, {5, Z(2, 2, 2, 2)}, {5, APAG}, {5, Z(2, 2, 2, 2)}, {15, APAG},
};
const Passo P_ALTERNADO_LENTO[] PROGMEM = {
  {25, ESQ_A}, {25, DIR_B},
};

struct Padrao { const Passo *passos; uint8_t n; };
#define PADRAO(p) { p, sizeof(p) / sizeof(Passo) }
const Padrao PADROES[] = {
  PADRAO(P_DUPLO), PADRAO(P_QUADRUPLO), PADRAO(P_TRIPLO), PADRAO(P_PERSEGUICAO),
  PADRAO(P_CENTRO_PONTAS), PADRAO(P_CRUZADO), PADRAO(P_SIMULTANEO), PADRAO(P_ALTERNADO_LENTO),
};
const uint8_t N_PADROES = sizeof(PADROES) / sizeof(Padrao);

// ---- Combinações de cores -------------------------------------------
// [cor A, cor B, cor C]. Com C diferente de A, a cada ciclo completo do
// padrão as cores giram (A,B) → (B,C) → (C,A): é o modo tricolor.
const uint8_t COMBOS[][3] = {
  {VM, AZ, VM},   // vermelho / azul
  {VM, BR, VM},   // vermelho / branco
  {AZ, BR, AZ},   // azul / branco
  {VM, AZ, BR},   // tricolor
  {VM, VM, VM},   // só vermelho
  {AZ, AZ, AZ},   // só azul
};
const uint8_t N_COMBOS = sizeof(COMBOS) / sizeof(COMBOS[0]);

// ---- Estado ----------------------------------------------------------
uint8_t padrao = 0, combo = 0, noite = 0;
uint8_t passo = 0, giro = 0;
uint32_t t_passo = 0;

// PWM por software: 16 níveis a ~250 Hz (Timer2, interrupção a 4 kHz)
volatile uint8_t cor_zona[4] = {0xFF, 0xFF, 0xFF, 0xFF}; // 0xFF = apagada
volatile uint8_t duty = 16;                               // 0..16
volatile uint8_t fase_pwm = 0;

const uint8_t EE_MAGICO = 0xA7;

// ---- Saídas ----------------------------------------------------------
void aplicaSaidas(bool ligado) {
  for (uint8_t z = 0; z < 4; z++)
    for (uint8_t c = 0; c < 3; c++)
      digitalWrite(PINO[z][c], (ligado && cor_zona[z] == c) ? HIGH : LOW);
}

ISR(TIMER2_COMPA_vect) {
  fase_pwm = (fase_pwm + 1) & 0x0F;
  if (fase_pwm == 0) aplicaSaidas(duty > 0);
  else if (fase_pwm == duty) aplicaSaidas(false);
}

void iniciaPWM() {
  TCCR2A = _BV(WGM21);              // CTC
  TCCR2B = _BV(CS22);               // clk/64 → 250 kHz
  OCR2A = 61;                       // 250 kHz / 62 ≈ 4 kHz
  TIMSK2 = _BV(OCIE2A);
}

// ---- Temperatura -----------------------------------------------------
float lerTemperatura() {
  int adc = analogRead(PINO_NTC);
  if (adc <= 0 || adc >= 1023) return -100;          // NTC aberto/curto
  float r = 10000.0 * adc / (1023.0 - adc);          // NTC entre A6 e GND
  float t = 1.0 / (log(r / 10000.0) / 3950.0 + 1.0 / 298.15) - 273.15;
  return t;
}

uint8_t limite_termico = 16;
void verificaTemperatura() {
  float t = lerTemperatura();
  if (t == -100) { limite_termico = 5; return; }      // sem sensor: modo seguro
  if (t > 85) limite_termico = 2;
  else if (t > 70) limite_termico = 5;
  else if (t < 65) limite_termico = 16;
}

void atualizaDuty() {
  uint8_t d = noite ? 5 : 16;
  if (limite_termico < d) d = limite_termico;
  duty = d;
}

// ---- EEPROM ----------------------------------------------------------
void carregar() {
  if (EEPROM.read(0) != EE_MAGICO) return;
  padrao = EEPROM.read(1) % N_PADROES;
  combo = EEPROM.read(2) % N_COMBOS;
  noite = EEPROM.read(3) ? 1 : 0;
}
void salvar() {
  EEPROM.update(0, EE_MAGICO);
  EEPROM.update(1, padrao);
  EEPROM.update(2, combo);
  EEPROM.update(3, noite);
}

// ---- Sequenciador ----------------------------------------------------
void mostraPasso() {
  Passo p;
  memcpy_P(&p, &PADROES[padrao].passos[passo], sizeof(Passo));
  const uint8_t *cc = COMBOS[combo];
  uint8_t corA = cc[giro % 3], corB = cc[(giro + 1) % 3];
  if (cc[2] == cc[0]) { corA = cc[0]; corB = cc[1]; }   // combos de duas cores não giram
  uint8_t novo[4];
  for (uint8_t z = 0; z < 4; z++) {
    uint8_t s = (p.zonas >> (2 * z)) & 0x03;
    novo[z] = s == 1 ? corA : s == 2 ? corB : 0xFF;
  }
  noInterrupts();
  for (uint8_t z = 0; z < 4; z++) cor_zona[z] = novo[z];
  interrupts();
  t_passo = millis() + p.dur10 * 10UL;
}

void avancaPasso() {
  if (++passo >= PADROES[padrao].n) { passo = 0; giro = (giro + 1) % 3; }
  mostraPasso();
}

void reiniciaPadrao() { passo = 0; giro = 0; mostraPasso(); }

// Pisca branco em todas as zonas n vezes (confirmação de comando)
void confirma(uint8_t n) {
  for (uint8_t i = 0; i < n; i++) {
    noInterrupts(); for (uint8_t z = 0; z < 4; z++) cor_zona[z] = BR; interrupts();
    delay(60);
    noInterrupts(); for (uint8_t z = 0; z < 4; z++) cor_zona[z] = 0xFF; interrupts();
    delay(120);
  }
}

// ---- Botão -----------------------------------------------------------
uint32_t t_aperto = 0;
bool apertado = false;
void trataBotao() {
  bool agora = digitalRead(PINO_BOTAO) == LOW;
  if (agora && !apertado) { apertado = true; t_aperto = millis(); delay(20); return; }
  if (!agora && apertado) {
    apertado = false;
    uint32_t dt = millis() - t_aperto;
    if (dt < 40) return;                                  // ruído
    if (dt < 600)       { padrao = (padrao + 1) % N_PADROES; confirma(1); }
    else if (dt < 2500) { combo = (combo + 1) % N_COMBOS; confirma(2); }
    else                { noite = !noite; confirma(3); }
    salvar();
    atualizaDuty();
    reiniciaPadrao();
    delay(20);
  }
}

// ---- Principal -------------------------------------------------------
void setup() {
  for (uint8_t z = 0; z < 4; z++)
    for (uint8_t c = 0; c < 3; c++) { pinMode(PINO[z][c], OUTPUT); digitalWrite(PINO[z][c], LOW); }
  pinMode(PINO_BOTAO, INPUT_PULLUP);
  carregar();
  verificaTemperatura();
  atualizaDuty();
  iniciaPWM();
  reiniciaPadrao();
}

uint32_t t_temp = 0;
void loop() {
  trataBotao();
  if ((int32_t)(millis() - t_passo) >= 0) avancaPasso();
  if (millis() - t_temp > 500) {
    t_temp = millis();
    verificaTemperatura();
    atualizaDuty();
  }
}

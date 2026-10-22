// =====================================================================
// Rotolight LED — barra estroboscópica para parabrisa de viatura (PCDF)
// Projeto paramétrico. Unidade: mm. OpenSCAD 2021.01+
//
// Arquitetura: duas meias-barras idênticas (espelhadas), uma de cada lado
// do retrovisor interno. Cada meia-barra fica pendurada num braço
// telescópico que sai de uma doca presa sob o parafuso do quebra-sol.
//
// Uso:  openscad -D 'peca="carcaca_E"' -o carcaca_E.stl rotolight.scad
// Peças: montagem, meia_barra, carcaca_E, carcaca_D, junta_vedacao, adaptador,
//        braco_fixo, braco_corredica, extensor, engate, doca, pino, manopla_parafuso,
//        manopla_porca, caixa_controle, tampa_controle, gabarito_furacao
// =====================================================================

peca = "montagem";

$fn = 56;
folga = 0.3;          // folga de encaixe por lado (A1, bico 0.4, PETG)

/* [Carcaça — meia-barra] */
L  = 238;             // comprimento (com o ressalto da junta cabe em 256)
H  = 38.1;            // altura = largura da barra chata de alumínio 1-1/2"
D  = 15;              // profundidade da bandeja plástica
t_al = 3.18;          // espessura da tampa traseira de alumínio (1/8")
p_frente = 2.4;       // parede frontal (6 perímetros de 0.4)
p_tb = 6;             // paredes superior/inferior (recebem parafusos M3; junta ≥ 1,2 mm ao lado do furo)
p_ext = 6;            // paredes das pontas (junta ≥ 1,3 mm ao lado do furo)

/* [LEDs: fita de LED] */
// v0.6: três fileiras de fita 12 V de 5 mm (2835, 120 LED/m, corte a cada
// 3 LEDs = 25 mm), coladas direto na tampa de alumínio, que é o dissipador.
// Fileira de cima vermelha, do meio branca, de baixo azul. Cada fileira tem
// dois trechos de 100 mm (zona externa e interna) = 12 LEDs por trecho;
// 72 LEDs por meia-barra. Faixas livres de 3 mm acima e abaixo para os fios.
w_fita = 5;           // largura da fita (comprar 5 mm)
e_fita = 2.5;         // espessura com a resina IP65
dz_fita = 7.5;        // distância entre os centros das fileiras
L_trecho = 100;       // 4 grupos de 25 mm
x_fita0 = 10;         // início da zona externa (x = 0 é a ponta externa)
x_c = 110;            // centro do campo de LEDs ao longo da barra
janela = [203, 22];   // abertura frontal
lente_pc = [207, 25, 2]; // placa de policarbonato colada por dentro

/* [Forma orgânica] */
R_vidro = 3000;       // raio do para-brisa em planta (medir no carro, ver flecha())
r_frente = 7;         // raio das arestas longas da frente
r_tras = 2.5;         // raio das arestas junto à tampa de alumínio
r_ponta = 7;          // arredondamento das pontas, em planta
n_arco = 8;           // segmentos por canto do perfil

/* [Junta rosácea (inclinação da barra)] */
d_ros = 15;
n_dentes = 24;
h_dente = 1.6;
L_ressalto = 12;

/* [Ventosa auxiliar] */
angulo_vidro = 28;    // inclinação do parabrisa em relação à horizontal
h_aba = 4;
d_cabeca_ventosa = 10.5; // cabeça "cogumelo" da mini ventosa Ø30
d_pescoco_ventosa = 6.2;

/* [Braço e doca] */
L_fixo = 150;
L_corr = 170;
// v0.5: seção de pé (alta em z, que é o sentido da carga do peso da barra);
// a trava atravessa na horizontal (em y), perto da linha neutra
tubo_ext = [14, 18];
tubo_int = [8.6, 12.6];
corredica = [8, 12];
d_pino = 4.6;          // furo da trava do braço (parafuso M4 + borboleta); vertical na impressão
d_M5 = 5.4;
d_M3_piloto = 2.5;     // parafuso M3 autoatarraxante em PETG
d_M3_passante = 3.4;
d_parafuso_quebra_sol = 6.5; // medir com paquímetro no veículo
e_doca = 2.5;          // espessura da lingueta que vai sob o suporte do quebra-sol
d_ima = 10.3; h_ima = 1.7;   // ímã Ø10 × 1,5 em estoque
porca_M5_af = 8.3; h_porca_M5 = 4.3; h_cabeca_M5 = 3.7;  // porca cativa da carcaça: DIN 934 (m = 4,0)
h_porca_trava = 5.3;   // porca autotravante DIN 985 nas manoplas (m = 5,0)

/* [Articulações] */
t_aba = 10;            // espessura das abas de articulação (v0.5: era 8)
w_aba = 20;            // largura das abas e garfos
fenda = t_aba + 0.4;   // vão do garfo
b_inf = 5;             // bochecha com a cabeça M5 cativa
b_sup = 4.5;           // bochecha da porca/manopla
L_lingueta = 16;       // trecho fino da doca que fica sob o suporte do quebra-sol (medir)
// Os DOIS parafusos do suporte do quebra-sol, em coordenadas da doca
// (x ao longo do braço, a partir do primeiro parafuso; medir no carro).
// Furos oblongos de ±folga_oblongo em x para ajuste.
parafusos_doca = [[-22, 0], [4, 0]];
folga_oblongo = 5;

/* [Caixa de controle — separada, sob o painel] */
// v0.6: caixa solta, presa sob o painel perto do acendedor, ligada a cada
// meia-barra por um cabo de 10 vias com conector GX16-10 em linha.
// Módulos prontos assentam em bolsos rasos e são presos com fita dupla-face
// e abraçadeira (não dependem da posição dos furos de fixação, que os
// anúncios não informam). Medir cada placa e corrigir 'modulos'.
cx_int = [180, 110, 32]; // interior da caixa (x, y, altura); faixa livre em y > 90 para o botão
p_cx = 2.4;              // paredes e fundo
d_botao = 12.2;          // furo do pulsador metálico 12 mm à prova d'água
xy_botao = [90, 100];    // posição do botão (interior), sobre a faixa livre
d_pg9 = 15.4;            // furo dos prensa-cabos PG9 (cabos de 4 a 8 mm)
z_pg = 15;               // centro dos prensa-cabos acima do fundo interno (contraporca SW24 livre do fundo)
xs_pg = [32, 82, 140];   // barra E, barra D, alimentação (parede y = 0)
// [nome, [x, y] do canto, [comprimento, largura], altura até o topo]
modulos = [
    ["OPMSC12 12 canais",    [5, 15],   [107, 72], 14],
    ["diodo ideal LTC4359",  [116, 15],  [33, 27], 10],
    ["buck 5 V",             [154, 15],  [16, 33],  6],
    ["Nano + adaptador",     [116, 50],  [53, 36], 25]];

// ---------------------------------------------------------------------
// Pontos de parafuso da tampa de alumínio (x, z) — compartilhados por
// bandeja, junta de vedação, tampa de alumínio, caixa e gabarito.
xs_borda = [10, 65, 119, 173, 228];
function furos_tampa() = concat(
    [for (x = xs_borda) [x, p_tb/2]],
    [for (x = xs_borda) [x, H - p_tb/2]],
    [[p_ext/2, H/2 + 10], [L - p_ext/2, H/2 + 10]]); // acima do furo M5 da junta
x_prensa = 222.5;        // passagem do cabo pela tampa de alumínio (PG7, rosca 8 mm, contraporca até SW17)

// ---------------------------------------------------------------------
module hexagono(af, h) { cylinder(d = af / cos(30), h = h, $fn = 6); }

// Rosácea tipo Hirth: anel único (poliedro) cuja face de cima tem altura
// z = h·(1 − |u|/meio_passo), onde u é o ângulo até o eixo do dente mais
// próximo. Como a altura só depende do ângulo, duas rosáceas iguais,
// defasadas de meio dente e uma virada para a outra, se encaixam por
// inteiro em qualquer raio. Furo central Ø d_M5.
// Plano z=0 = fundo dos vales; base de 0,2 mm abaixo. fase = 0 ou 0.5.
module rosacea(d = d_ros, n = n_dentes, h = h_dente, fase = 0, sub = 4) {
    passo = 360 / n; N = n * 2 * sub;
    r0 = d_M5 / 2; r1 = d / 2;
    function zt(t) = let(u = t - fase * passo - passo * round((t - fase * passo) / passo))
        h * (1 - abs(u) / (passo / 2));
    pts = [for (j = [0 : N - 1]) let(t = j * 360 / N, c = cos(t), s = sin(t), z = zt(t))
        each [[r0 * c, r0 * s, z], [r1 * c, r1 * s, z], [r1 * c, r1 * s, -0.2], [r0 * c, r0 * s, -0.2]]];
    function q(j, k) = 4 * (j % N) + k;
    faces = [for (j = [0 : N - 1]) each [
        [q(j, 0), q(j + 1, 0), q(j + 1, 1)], [q(j, 0), q(j + 1, 1), q(j, 1)],   // topo
        [q(j, 1), q(j + 1, 1), q(j + 1, 2), q(j, 2)],                         // externa
        [q(j, 2), q(j + 1, 2), q(j + 1, 3), q(j, 3)],                         // base
        [q(j, 3), q(j + 1, 3), q(j + 1, 0), q(j, 0)]]];                       // furo
    polyhedron(points = pts, faces = faces, convexity = 6);
}

// ---------------------------------------------------------------------
// FORMA ORGÂNICA DA MEIA-BARRA
// A frente acompanha o arco do para-brisa visto de cima (raio R_vidro):
// o meio da meia-barra fica mais à frente e as pontas recuam a flecha
// L²/(8·R). As arestas longas da frente são arredondadas (r_frente) e as
// pontas viram cápsula em planta (r_ponta). A face traseira continua
// plana, para vedar contra a tampa de alumínio.
//
// Para medir R no carro: estique uma linha entre as colunas A rente ao
// topo do vidro (corda c) e meça a flecha f no centro: R = c² / (8·f).
function flecha(x) = pow(x - L/2, 2) / (2 * R_vidro);
function recuo_ponta(x) = let(d = min(x, L - x))
    d >= r_ponta ? 0 : r_ponta - sqrt(pow(r_ponta, 2) - pow(r_ponta - d, 2));
function frente(x) = flecha(x) + recuo_ponta(x);

// pontos (y, z) de um retângulo de cantos arredondados, sentido anti-horário
function arco(cy, cz, r, a0) = [for (i = [0 : n_arco]) let(a = a0 + 90 * i / n_arco)
    [cy + r * cos(a), cz + r * sin(a)]];
function perfil(f, t, z0, z1, rf, rb) = concat(
    arco(f + rf, z0 + rf, rf, 180),
    arco(t - rb, z0 + rb, rb, 270),
    arco(t - rb, z1 - rb, rb, 0),
    arco(f + rf, z1 - rf, rf, 90));

// sólido "lofted": uma fatia de perfil por posição x (um único poliedro,
// rápido de renderizar). pf(x) devolve o perfil (lista de [y, z]).
module loft(xs, perfis) {
    n = len(perfis[0]); m = len(xs);
    pts = [for (i = [0 : m - 1]) for (q = perfis[i]) [xs[i], q[0], q[1]]];
    lados = [for (i = [0 : m - 2]) for (j = [0 : n - 1])
        [i*n + j, (i + 1)*n + j, (i + 1)*n + (j + 1) % n, i*n + (j + 1) % n]];
    tampa0 = [for (j = [0 : n - 1]) j];
    tampa1 = [for (j = [n - 1 : -1 : 0]) (m - 1)*n + j];
    polyhedron(points = pts, faces = concat(lados, [tampa0, tampa1]), convexity = 4);
}

function xs_casca() = concat(
    [for (i = [0 : 10]) r_ponta * (1 - cos(90 * i / 10))],
    [for (x = [r_ponta + 6 : 6 : L - r_ponta - 6]) x],
    [for (i = [10 : -1 : 0]) L - r_ponta * (1 - cos(90 * i / 10))]);

module casca() {
    xs = xs_casca();
    loft(xs, [for (x = xs) let(f = frente(x), rf = min(r_frente, (D - f) - r_tras - 0.6))
        perfil(f, D, 0, H, rf, r_tras)]);
}

module cavidade() {
    xs = [for (x = [p_ext : 6 : L - p_ext]) x];
    xs2 = concat(xs, xs[len(xs) - 1] < L - p_ext ? [L - p_ext] : []);
    loft(xs2, [for (x = xs2) perfil(frente(x) + p_frente, D + 2, p_tb, H - p_tb, 0.5, 0.5)]);
}

// Aba da ventosa: disco paralelo ao vidro, unido à barra por um pescoço
// suave. O disco não passa do plano traseiro (y = D), que é a face de
// apoio na mesa de impressão.
module aba_ventosa() {
    xa = L - 22;
    module no_disco() translate([xa, 3, H + h_aba]) rotate([angulo_vidro, 0, 0]) children();
    difference() {
        hull() {
            translate([xa - 9, frente(xa) + 5, H - 2]) cube([18, D - frente(xa) - 7, 2]);
            no_disco() cylinder(d = 26, h = 3);
        }
        no_disco() {
            translate([0, 4, -10]) cylinder(d = d_cabeca_ventosa, h = 20);
            hull() for (y = [4, -5]) translate([0, y, -10]) cylinder(d = d_pescoco_ventosa, h = 20);
            // rebaixo onde a cabeça assenta (não sai sozinha)
            hull() for (y = [-5, -1]) translate([0, y, -20]) cylinder(d = d_cabeca_ventosa, h = 20);
        }
    }
}

// Ressalto da junta concordando com a ponta arredondada
module ressalto_junta() {
    hull() {
        translate([0.01, D/2, H/2]) rotate([0, -90, 0]) cylinder(d = d_ros, h = L_ressalto);
        translate([0, r_ponta - 2, H/2 - 11]) cube([3.5, D - r_ponta + 2 - r_tras, 22]);
    }
}

module carcaca() {
    difference() {
        union() {
            casca();
            ressalto_junta();
            translate([-L_ressalto, D/2, H/2]) rotate([0, -90, 0]) rosacea(fase = 0.5);
            aba_ventosa();
        }
        cavidade();
        // janela frontal (atravessa a parede curva)
        translate([x_c - janela[0]/2, -1, H/2 - janela[1]/2])
            cube([janela[0], p_frente + flecha(0) + 2, janela[1]]);
        // furos-piloto M3 para a tampa de alumínio
        // furos-piloto M3 rasos, para não atravessar a frente arredondada:
        // 9,5 mm nas bordas (M3×12 entra 7,8 mm) e 8 mm nas pontas
        for (p = furos_tampa()) translate([p[0], D + 0.01, p[1]])
            rotate([90, 0, 0]) cylinder(d = d_M3_piloto, h = (p[0] < p_ext || p[0] > L - p_ext) ? 8 : 9.5);
        // furo M5 da junta (cego: não atravessa para a cavidade)
        translate([-L_ressalto - h_dente - 1, D/2, H/2]) rotate([0, 90, 0])
            cylinder(d = d_M5, h = L_ressalto + h_dente + 1 + 3);
        // porca M5 inserida por cima (bolso + rasgo)
        translate([-8.6, D/2, H/2]) hull() {
            rotate([0, 90, 0]) hexagono(porca_M5_af, h_porca_M5);
            translate([0, 0, 20]) rotate([0, 90, 0]) hexagono(porca_M5_af, h_porca_M5);
        }
    }
}

module carcaca_lado(lado = "E") {
    if (lado == "E") carcaca();
    else mirror([1, 0, 0]) carcaca();
}

// Placa de policarbonato, fitas de LED e tampa de alumínio (visualização)
module fita(cor) {
    color(cor) cube([L_trecho - 0.5, e_fita, w_fita]);
}
module fitas() {
    for (z = [1, 0, -1], k = [0, 1])
        translate([x_fita0 + k * L_trecho, D + 1 - e_fita, H/2 + z * dz_fita - w_fita/2])
            fita(z > 0 ? "red" : (z == 0 ? "white" : "blue"));
}
module fantasma_interno() {
    color("lightblue", 0.4)
        translate([x_c - lente_pc[0]/2, p_frente, H/2 - lente_pc[1]/2])
        cube([lente_pc[0], lente_pc[2], lente_pc[1]]);
    fitas();
    color("silver") translate([0, D + 1, 0]) cube([L, t_al, H]);
}

// ---------------------------------------------------------------------
// JUNTA DE VEDAÇÃO (TPU, 1 mm) entre bandeja e tampa de alumínio.
// Imprime deitada.
module junta_vedacao() {
    difference() {
        cube([L, H, 1]);
        translate([p_ext, p_tb, -1]) cube([L - 2*p_ext, H - 2*p_tb, 3]);
        for (p = furos_tampa()) translate([p[0], p[1], -1]) cylinder(d = d_M3_passante, h = 3);
    }
}

// GABARITO de furação da tampa de alumínio (PLA/PETG, 2 mm). Encaixa
// sobre a barra chata e marca os 12 furos Ø3,4 e o furo Ø12,7 do PG7.
module gabarito_furacao() {
    g = 0.3;   // folga por lado sobre a barra chata
    difference() {
        union() {
            translate([-2.4 - g, -2.4 - g, 0]) cube([L + 4.8 + 2*g, H + 4.8 + 2*g, 2]);
            // abas laterais que abraçam a barra chata
            for (y = [-2.4 - g, H + g]) translate([-2.4 - g, y, 0]) cube([L + 4.8 + 2*g, 2.4, 2 + t_al]);
            // batente na ponta externa (x = 0)
            translate([-2.4 - g, -2.4 - g, 0]) cube([2.4, H + 4.8 + 2*g, 2 + t_al]);
        }
        for (p = furos_tampa()) translate([p[0], p[1], -1]) cylinder(d = 2.0, h = 5);
        translate([x_prensa, H/2, -1]) cylinder(d = 3, h = 5);
        // janelas de economia de material
        for (i = [0 : 3]) translate([20 + i * 54, 10, -1]) cube([42, H - 20, 5]);
    }
}

// ---------------------------------------------------------------------
// ADAPTADOR: junta rosácea (eixo ao longo da barra) + aba de articulação
// vertical (guinada). Coordenadas no referencial da carcaça (lado E).
// Imprime com a face de cima da aba na mesa.
x_adapt = -L_ressalto - h_dente;   // face dos dentes do adaptador
e_adapt = 8;
x_arm = x_adapt - e_adapt - 32;    // eixo da articulação vertical (manoplas sem colidir)
z_aba = H + 2.2;                   // base da aba
module adaptador() {
    difference() {
        union() {
            hull() {
                translate([x_adapt - e_adapt, D/2, H/2]) rotate([0, 90, 0]) cylinder(d = 16, h = e_adapt);
                translate([x_adapt - e_adapt, D/2 - w_aba/2, z_aba]) cube([e_adapt, w_aba, t_aba]);
            }
            translate([x_adapt - 0.01, D/2, H/2]) rotate([0, 90, 0]) rosacea();
            hull() {
                translate([x_adapt - e_adapt, D/2 - w_aba/2, z_aba]) cube([e_adapt, w_aba, t_aba]);
                translate([x_arm, D/2, z_aba]) cylinder(d = w_aba, h = t_aba);
            }
        }
        translate([x_adapt - e_adapt - 1, D/2, H/2]) rotate([0, 90, 0]) cylinder(d = d_M5, h = 20);
        translate([x_arm, D/2, z_aba - 1]) cylinder(d = d_M5, h = t_aba + 2);
    }
}

// ---------------------------------------------------------------------
// GARFO (clevis) com a cabeça do parafuso M5 cativa na bochecha b_inf.
// Eixo do furo em (0,0); o garfo se prolonga para -x. Fenda centrada em
// z=0. dy desloca o garfo em y (alinha a face de apoio na impressão).
module garfo(comp = 20, dy = 0) {
    zi = -fenda/2 - b_inf; zs = fenda/2 + b_sup;
    translate([0, dy, 0]) difference() {
        hull() {
            translate([0, 0, zi]) cylinder(d = w_aba, h = zs - zi);
            translate([-comp, -w_aba/2, zi]) cube([1, w_aba, zs - zi]);
        }
        translate([-comp + 5, -w_aba, -fenda/2]) cube([comp + 20, 2*w_aba, fenda]);
        translate([0, 0, zi - 1]) cylinder(d = d_M5, h = zs - zi + 2);
        translate([0, 0, zi - 0.01]) rotate([0, 0, 30]) hexagono(porca_M5_af, h_cabeca_M5);
    }
}

// Aba simples com furo, eixo em (0,0), prolonga para +x
module aba_articulacao(comp = 14, dy = 0) {
    translate([0, dy, 0]) difference() {
        hull() {
            translate([0, 0, -t_aba/2]) cylinder(d = w_aba, h = t_aba);
            translate([comp - 1, -w_aba/2, -t_aba/2]) cube([1, w_aba, t_aba]);
        }
        translate([0, 0, -t_aba]) cylinder(d = d_M5, h = 2*t_aba);
    }
}

// ---------------------------------------------------------------------
// Primitivas suaves
// barra ao longo de x com seção de cantos arredondados (w em y, h em z)
module barra_arr(comp, w, h, r) {
    hull() for (sy = [-1, 1], sz = [-1, 1])
        translate([0, sy * (w/2 - r), sz * (h/2 - r)]) rotate([0, 90, 0]) cylinder(r = r, h = comp);
}
// placa vertical/horizontal de cantos arredondados (x por y), espessura t em z
module placa_arr(cx, cy, t, r) {
    hull() for (x = [r, cx - r], y = [r, cy - r]) translate([x, y, 0]) cylinder(r = r, h = t);
}

// BRAÇO CORREDIÇA: barra 12×8 (arestas r2) com furos a cada 10 mm; garfo
// na ponta que vai à barra de LEDs. Local: x de 0 a L_corr. O garfo é
// deslocado em y para que a corrediça e o garfo tenham a mesma face de
// apoio (y mínimo) na mesa.
dy_corr = (w_aba - corredica[0]) / 2;
module braco_corredica() {
    difference() {
        union() {
            barra_arr(L_corr, corredica[0], corredica[1], 2);
            hull() {
                translate([L_corr - 14, 0, 0]) barra_arr(1, corredica[0], corredica[1], 2);
                translate([L_corr - 2, dy_corr - w_aba/2, -fenda/2 - b_sup]) cube([1, w_aba, fenda + b_sup + b_inf]);
            }
        }
        for (x = [15 : 10 : 125]) translate([x, -10, 0]) rotate([-90, 0, 0]) cylinder(d = d_pino, h = 20);
        translate([-1, 0, 0]) rotate([0, 90, 0]) cylinder(d = 30, h = 1.5, $fn = 4);
    }
    translate([L_corr + 16, 0, 0]) mirror([0, 0, 1]) garfo(20, dy_corr);
}

// BRAÇO FIXO: tubo 18×14 (arestas r5) aberto em +x; aba de articulação em
// -x unida ao tubo por uma transição afunilada; presilhas para o cabo.
x_aba_fixo = -16;      // eixo da articulação, relativo ao início do tubo
dy_fixo = (w_aba - tubo_ext[0]) / 2;
module presilha_cabo() {
    difference() {
        hull() {
            rotate([0, 90, 0]) cylinder(d = 11, h = 8);
            translate([0, -3.5, -5.5]) cube([8, 0.1, 11]);
        }
        translate([-1, 0, 0]) rotate([0, 90, 0]) cylinder(d = 7.2, h = 10);
        translate([-1, -2.6, 2]) cube([10, 5.2, 10]);
    }
}
module braco_fixo() {
    difference() {
        union() {
            barra_arr(L_fixo, tubo_ext[0], tubo_ext[1], 5);
            hull() {
                translate([-5, dy_fixo - w_aba/2, -t_aba/2]) cube([1, w_aba, t_aba]);
                translate([4, 0, 0]) barra_arr(1, tubo_ext[0], tubo_ext[1], 5);
            }
            // presilhas antes do furo do tubo: o furo as recorta por dentro
            for (x = [35, 105]) translate([x, tubo_ext[0]/2 + 2, 0]) presilha_cabo();
        }
        translate([15, -tubo_int[0]/2, -tubo_int[1]/2]) cube([L_fixo, tubo_int[0], tubo_int[1]]);
        translate([L_fixo - 8, -15, 0]) rotate([-90, 0, 0]) cylinder(d = d_pino, h = 30);
    }
    translate([x_aba_fixo, 0, 0]) aba_articulacao(16, dy_fixo);
}

// EXTENSOR (opcional, modular): macho como a corrediça numa ponta, fêmea
// como o tubo na outra. Entra entre o braço fixo e a corrediça e alonga o
// braço em até 80 mm; pode ser usado em série.
L_ext_macho = 70; L_ext_femea = 80;
dy_ext = (corredica[0] - tubo_ext[0]) / 2;
module extensor() {
    difference() {
        union() {
            // o macho fica deslocado em y para ter a mesma face de apoio do tubo
            translate([0, dy_ext, 0]) barra_arr(L_ext_macho + 4, corredica[0], corredica[1], 2);
            hull() {
                translate([L_ext_macho, dy_ext, 0]) barra_arr(1, corredica[0], corredica[1], 2);
                translate([L_ext_macho + 10, 0, 0]) barra_arr(1, tubo_ext[0], tubo_ext[1], 5);
            }
            translate([L_ext_macho + 10, 0, 0]) barra_arr(L_ext_femea - 10, tubo_ext[0], tubo_ext[1], 5);
        }
        for (x = [15 : 10 : 55]) translate([x, dy_ext - 10, 0]) rotate([-90, 0, 0]) cylinder(d = d_pino, h = 20);
        translate([L_ext_macho + 15, -tubo_int[0]/2, -tubo_int[1]/2]) cube([L_ext_femea, tubo_int[0], tubo_int[1]]);
        translate([L_ext_macho + L_ext_femea - 8, -15, 0]) rotate([-90, 0, 0]) cylinder(d = d_pino, h = 30);
        translate([-1, dy_ext, 0]) rotate([0, 90, 0]) cylinder(d = 30, h = 1.5, $fn = 4);
    }
}

// ---------------------------------------------------------------------
// ENGATE: língua 16×11 (arestas r1; v0.5: era 14×8) que entra no soquete da doca + garfo.
// Local: ponta da língua em x=0, z=0 é o fundo do canal da doca.
w_lingua = 16; h_lingua = 11;
dy_eng = (w_aba - w_lingua) / 2;
z_eng = fenda/2 + b_inf;   // centro da fenda acima do fundo do canal
module engate() {
    difference() {
        union() {
            translate([0, 0, h_lingua/2]) barra_arr(28, w_lingua, h_lingua, 1);
            hull() {
                translate([24, 0, h_lingua/2]) barra_arr(1, w_lingua, h_lingua, 1);
                translate([30, dy_eng - w_aba/2, 0]) cube([1, w_aba, z_eng + fenda/2 + b_sup]);
            }
        }
        translate([12, 0, -1]) cylinder(d = d_pino_doca, h = h_lingua + 2);
        translate([-1, 0, h_lingua/2]) rotate([0, 90, 0]) scale([1, (w_lingua + 10) / (h_lingua + 10), 1]) cylinder(d = h_lingua + 10, h = 1.2, $fn = 4); // chanfro
    }
    translate([28 + 18, 0, z_eng]) garfo(20, dy_eng);
}

// DOCA: placa fina (2,5 mm) presa sob o suporte do quebra-sol pelos DOIS
// parafusos originais (parafusos_doca). Com dois parafusos o suporte prende
// a placa de verdade e o momento do braço vira um binário nos parafusos, em
// vez de dobrar a placa fina. A partir de x = L_lingueta, fora do suporte,
// o corpo tem a altura toda do soquete: canal para o engate (com frisos de
// aperto), furo do pino e alojamento do ímã. Base da placa em z=0.
module doca() {
    x_sq = L_lingueta; L_sq = 35; z_canal = e_doca; h_canal = h_canal_doca;
    h_sq = z_canal + h_canal + 3.1;
    x_canal = x_sq + 12;
    difference() {
        union() {
            hull() {
                for (q = parafusos_doca) translate([q[0], q[1], 0])
                    hull() for (dx = [-folga_oblongo, folga_oblongo]) translate([dx, 0, 0]) cylinder(d = 22, h = e_doca);
                translate([x_sq, -15, 0]) placa_arr(L_sq, 30, e_doca, 4);
            }
            hull() {
                translate([x_sq, -14, 0]) placa_arr(L_sq, 28, h_sq - 3, 5);
                translate([x_sq + 2, -12, 0]) placa_arr(L_sq - 4, 24, h_sq, 4);
            }
        }
        for (q = parafusos_doca) translate([q[0], q[1], -1])
            hull() for (dx = [-folga_oblongo, folga_oblongo]) translate([dx, 0, 0]) cylinder(d = d_parafuso_quebra_sol, h = e_doca + 2);
        translate([x_canal, -w_lingua/2 - 0.2, z_canal]) cube([L_sq, w_lingua + 0.4, h_canal]);
        translate([x_canal + 12, 0, 1]) cylinder(d = d_pino_doca, h = 20);
        translate([x_canal - 3, 0, h_sq - h_ima]) cylinder(d = d_ima, h = 5);
    }
    // dois frisos de 0,4 mm no fundo do canal: a língua entra justa
    // (esmagam um pouco na primeira montagem) e não fica com jogo vertical
    for (y = [-5.5, 5.5]) difference() {
        translate([x_canal + 2, y - 0.6, z_canal - 0.01]) cube([L_sq - 14, 1.2, 0.41]);
        translate([x_canal + 12, 0, 1]) cylinder(d = d_pino_doca + 1, h = 20);
    }
}
d_pino_doca = 4.3;     // pino magnético impresso Ø4 (furo vertical na impressão)
h_canal_doca = 11.3;   // canal da língua (11 mm): frisos de 0,4 mm no fundo deixam 10,9 → aperto de 0,1 mm
function doca_x_pino() = L_lingueta + 12 + 12;
function doca_h() = e_doca + h_canal_doca + 3.1;

// PINO de trava com cabeça imantada
module pino() {
    comp = 3.1 + h_canal_doca + 1.3;
    hull() {
        cylinder(d = 14, h = 3);
        translate([-15, 0, 0]) cylinder(d = 14, h = 3);
    }
    translate([0, 0, 3]) {
        cylinder(d = 4.0, h = comp - 0.6);
        translate([0, 0, comp - 0.6]) cylinder(d1 = 4.0, d2 = 3.0, h = 0.6);
    }
}
module pino_impressao() {
    difference() {
        pino();
        translate([-15, 0, -0.01]) cylinder(d = d_ima, h = h_ima);
    }
}

// ---------------------------------------------------------------------
// MANOPLAS M5 (sem ferramenta): oito lóbulos e topo em cúpula
module manopla(base) {
    difference() {
        intersection() {
            union() {
                cylinder(d = 18, h = 10);
                for (i = [0 : 7]) rotate([0, 0, i * 45]) translate([9, 0, 0]) cylinder(d = 7, h = 10);
            }
            translate([0, 0, -20]) sphere(r = 30, $fn = 96);
        }
        translate([0, 0, -1]) cylinder(d = d_M5, h = 12);
        if (base == "parafuso") translate([0, 0, 10 - h_cabeca_M5]) hexagono(porca_M5_af, 5);
        else translate([0, 0, -0.01]) hexagono(8.05, h_porca_trava);   // DIN 985 (s = 8) prensada
    }
}

// ---------------------------------------------------------------------
// CAIXA DE CONTROLE separada. Local: fundo em z=0, parede dos prensa-cabos
// em y=0. Imprime de fundo na mesa. A tampa leva o botão.
cx_ext = [cx_int[0] + 2*p_cx, cx_int[1] + 2*p_cx, cx_int[2] + p_cx];
r_cx = 5;
xy_postes = [[p_cx + 4.5, p_cx + 4.5], [cx_ext[0] - p_cx - 4.5, p_cx + 4.5],
             [p_cx + 4.5, cx_ext[1] - p_cx - 4.5], [cx_ext[0] - p_cx - 4.5, cx_ext[1] - p_cx - 4.5]];
module ret_arr(c, r) offset(r = r) offset(delta = -r) square(c);
module caixa_controle() {
    difference() {
        union() {
            linear_extrude(cx_ext[2]) ret_arr([cx_ext[0], cx_ext[1]], r_cx);
            // orelhas de fixação (parafuso Ø4 ou abraçadeira/velcro)
            for (x = [-9, cx_ext[0] + 9]) hull() {
                translate([x, cx_ext[1]/2, 0]) cylinder(d = 16, h = 3);
                translate([x < 0 ? 0 : cx_ext[0] - 1, cx_ext[1]/2 - 12, 0]) cube([1, 24, 3]);
            }
        }
        translate([p_cx, p_cx, p_cx]) linear_extrude(cx_ext[2]) ret_arr([cx_int[0], cx_int[1]], r_cx - 2);
        for (x = [-9, cx_ext[0] + 9]) translate([x, cx_ext[1]/2, -1]) hull() {
            translate([0, -4, 0]) cylinder(d = 4.5, h = 5);
            translate([0, 4, 0]) cylinder(d = 4.5, h = 5);
        }
        // prensa-cabos PG9
        for (x = xs_pg) translate([x, -1, p_cx + z_pg]) rotate([-90, 0, 0]) cylinder(d = d_pg9, h = p_cx + 2);
        // rasgos para abraçadeira (3,0 × 1,6 mm) dos dois lados de cada módulo
        for (m = modulos) let(o = m[1], c = m[2], cy = o[1] + c[1]/2)
            for (x = [o[0] - 2.5, o[0] + c[0] + 1]) translate([p_cx + x, p_cx + cy - 2, -1]) cube([1.6, 4, p_cx + 2]);
    }
    // bolsos: muretas de 2 mm em volta de cada placa (folga de 0,5 mm)
    for (m = modulos) let(o = m[1], c = m[2])
        translate([p_cx + o[0] - 1.7, p_cx + o[1] - 1.7, p_cx - 0.01]) linear_extrude(2) difference() {
            ret_arr([c[0] + 3.4, c[1] + 3.4], 1);
            translate([1.2, 1.2]) square([c[0] + 1, c[1] + 1]);
            // passagem da abraçadeira
            translate([-1, c[1]/2 - 1.3]) square([c[0] + 6, 6]);
        }
    // postes da tampa
    for (q = xy_postes) translate([q[0], q[1], 0]) difference() {
        cylinder(d = 8, h = cx_ext[2]);
        translate([0, 0, 6]) cylinder(d = d_M3_piloto, h = cx_ext[2]);
    }
}
module tampa_controle() {
    difference() {
        union() {
            hull() {
                linear_extrude(0.01) offset(delta = -1) ret_arr([cx_ext[0], cx_ext[1]], r_cx);
                translate([0, 0, 1]) linear_extrude(1.6) ret_arr([cx_ext[0], cx_ext[1]], r_cx);
            }
            // ressalto de centragem
            translate([p_cx + folga, p_cx + folga, 2.6]) linear_extrude(2) difference() {
                ret_arr([cx_int[0] - 2*folga, cx_int[1] - 2*folga], r_cx - 2);
                translate([1.6, 1.6]) ret_arr([cx_int[0] - 2*folga - 3.2, cx_int[1] - 2*folga - 3.2], r_cx - 3);
            }
        }
        for (q = xy_postes) {
            translate([q[0], q[1], -1]) cylinder(d = d_M3_passante, h = 10);
            translate([q[0], q[1], -0.01]) cylinder(d1 = 6.5, d2 = d_M3_passante, h = 1.6); // escareado
            translate([q[0], q[1], 2.6]) cylinder(d = 9, h = 5);
        }
        translate([p_cx + xy_botao[0], p_cx + xy_botao[1], -1]) cylinder(d = d_botao, h = 10);
    }
}

// ---------------------------------------------------------------------
// MONTAGEM (só visualização), na posição de uso: z para cima, teto do
// carro acima da doca. Meia-barra esquerda na origem.
z_arm = z_aba + t_aba/2;                 // eixo do braço
furo_corr = 55;                          // furo da corrediça usado na vista
x_corr0 = x_arm - (L_corr + 16);         // início da corrediça
y_braco = D/2 - dy_corr;                 // eixo do braço em y
x_tubo0 = x_corr0 + furo_corr - (L_fixo - 8);
x_art = x_tubo0 + x_aba_fixo;            // articulação doca/braço
y_art = y_braco + dy_fixo;
module meia_barra_montada(lado = "E") {
    mirror([lado == "E" ? 0 : 1, 0, 0]) {
        color("dimgray") carcaca();
        fantasma_interno();
        color("orange") adaptador();
        color("gold") translate([x_corr0, y_braco, z_arm]) braco_corredica();
        color("goldenrod") translate([x_tubo0, y_braco, z_arm]) braco_fixo();
        // engate, doca e pino ficam invertidos (doca colada no teto)
        translate([x_art, y_art, z_arm]) mirror([0, 0, 1]) translate([-46, -dy_eng, -z_eng]) {
            color("khaki") engate();
            translate([-28, 0, -e_doca]) {
                color("steelblue") doca();
                color("red") translate([doca_x_pino(), 0, doca_h() + 3]) rotate([180, 0, 0]) pino();
            }
        }
        // manoplas: a da rosácea fica presa sob a cabeça do parafuso; as das
        // articulações ficam por baixo, com a porca autotravante virada para cima
        color("black") {
            translate([x_adapt - e_adapt, D/2, H/2]) rotate([0, -90, 0]) manopla("parafuso");
            translate([x_arm, D/2, z_arm - fenda/2 - b_sup]) rotate([180, 0, 0]) manopla("porca");
            translate([x_art, y_art, z_arm - fenda/2 - b_sup]) rotate([180, 0, 0]) manopla("porca");
        }
    }
}

module montagem() {
    meia_barra_montada("E");
    translate([2 * L + 140, 0, 0]) meia_barra_montada("D");
    // retrovisor interno (referência)
    color("black", 0.4) translate([L + 70 - 35, 40, -25]) cube([70, 25, 60]);
    // caixa de controle (fica sob o painel; aqui só para referência de tamanho)
    color("teal") translate([L + 70 - cx_ext[0]/2, 120, -150]) caixa_controle();
}

// ---------------------------------------------------------------------
// Seletor de peças (orientadas para impressão)
if (peca == "montagem") montagem();
else if (peca == "meia_barra") meia_barra_montada("E");
else if (peca == "carcaca_E") rotate([-90, 0, 0]) carcaca_lado("E");   // face traseira (plana) na mesa
else if (peca == "carcaca_D") rotate([-90, 0, 0]) carcaca_lado("D");
else if (peca == "junta_vedacao") junta_vedacao();
else if (peca == "gabarito_furacao") gabarito_furacao();
else if (peca == "adaptador") rotate([180, 0, 0]) adaptador();   // face de cima da aba na mesa
else if (peca == "braco_corredica") rotate([90, 0, 0]) braco_corredica();
else if (peca == "braco_fixo") rotate([90, 0, 0]) braco_fixo();
else if (peca == "extensor") rotate([90, 0, 0]) extensor();
else if (peca == "engate") rotate([90, 0, 0]) engate();
else if (peca == "doca") doca();
else if (peca == "pino") pino_impressao();
else if (peca == "manopla_parafuso") manopla("parafuso");
else if (peca == "manopla_porca") manopla("porca");
else if (peca == "caixa_controle") caixa_controle();
else if (peca == "tampa_controle") tampa_controle();

// =====================================================================
// Rotolight LED — barra estroboscópica para parabrisa de viatura (PCDF)
// Projeto paramétrico. Unidade: mm. OpenSCAD 2021.01+
//
// v0.8: a barra única da v0.7 com um corte novo, compacto, que se encosta
// na INCLINAÇÃO do para-brisa (esboço do Luciano): a fita fica numa câmara
// fechada por todos os lados — vidro na frente, aba curta em cima, aba
// longa embaixo e a barra de alumínio atrás. A luz só sai pelo vidro e não
// ofusca os ocupantes; o reflexo da fita no vidro (que desce para a
// frente) cai na aba de baixo, preta e fosca.
//
// Corte (y = 0 na ponta da aba de baixo, y cresce para a CABINE; z para cima):
//   ALUMÍNIO: barra chata 3/4" × 1/8", de pé. É a parede de trás da câmara
//   (opaca), a espinha que dá rigidez e o dissipador, com a face de trás no
//   ar da cabine. A fita vai colada na face da frente.
//   TRILHO DE BAIXO: aba longa que vai até o vidro, com ranhura que abraça a
//   borda de baixo do alumínio.
//   TRILHO DE CIMA: aba curta que vai até o vidro, com ranhura que abraça a
//   borda de cima do alumínio.
//   As pontas das duas abas ficam sobre a reta do vidro (ang_vidro), com
//   faces inclinadas que recebem tiras de EVA de e_eva.
//   TAMPAS DE PONTA iguais fecham as pontas e prendem os trilhos (M3).
//   A barra acompanha o arco do para-brisa em planta (R_vidro).
// Impressão: trilho_inf com a aba na mesa; trilho_sup de cabeça para baixo
// (o topo na mesa). Nenhum dos dois precisa de suporte.
//
// Uso:  openscad -D 'peca="trilho_inf"' -o trilho_inf.stl rotolight.scad
// Peças: montagem, trilho_inf, trilho_sup, tampa_ponta (×2),
//        gabarito_furacao, caixa_controle, tampa_controle
// =====================================================================

peca = "montagem";

$fn = 48;
folga = 0.3;          // folga de encaixe por lado (A1, bico 0.4, PETG)

/* [Barra] */
L_barra = 1100;       // comprimento (PROVISÓRIO: medir no carro)
R_vidro = 3000;       // raio do para-brisa em planta (medir: R = c²/(8·f))
ang_vidro = 30;       // inclinação do para-brisa sobre a horizontal, no topo (MEDIR com o inclinômetro do celular)
e_eva = 2;            // EVA nas pontas das abas, entre a barra e o vidro

/* [Divisão para a mesa A1 (256 mm)] */
n_seg = 5;            // nº de trechos de cada trilho (1100/5 = 220 mm, cabe na A1)
seg = 0;              // trecho a exportar: 0 = trilho inteiro; 1..n_seg = um trecho
j_ov = 16;            // sobreposição da lingueta (mm)
j_tm = 1.6;           // espessura da lingueta horizontal (a aba)
j_cl = 0.2;           // folga vertical entre a lingueta e o teto
j_tooth = 0.9;        // altura do dente (trava por clique)
j_tx = 3.5;           // comprimento do dente no sentido x
j_ty = 3.0;           // largura do dente no sentido y
j_folga = 0.25;       // folga lateral do encaixe por lado

/* [Alumínio (parede de trás e dissipador)] */
w_al = 19.05;         // barra chata 3/4" × 1/8"
t_al = 3.18;
g_al = 0.2;           // folga por lado na ranhura
lab = 1.6;            // espessura dos lábios da ranhura
sob = 2.0;            // quanto cada lábio cobre a borda do alumínio
p_base = 2.0;         // fundo da ranhura (em cima e embaixo)
p_aba = 1.6;          // espessura da aba de baixo
p_ponta = 2.6;        // espessura das pontas que encostam no vidro (recebem o EVA)
avanco_sup = 7;       // quanto a aba de cima passa à frente do alumínio

/* [Fita SEZO WS2812B IP65, 1 m] */
w_fita = 12;          // largura com o silicone (MEDIR a fita comprada)
e_fita = 3;           // espessura com o silicone (MEDIR)
L_fita = 1000;        // 1 rolo = 1 m = 144 LEDs
x_fita = [L_barra - 36 - L_fita, L_barra - 36];  // a ponta x = L tem o PG7
x_pg7 = L_barra - 22;         // PG7 pelo alumínio (cabo para a caixa); contraporca até SW17
x_sem_labio = [L_barra - 34, L_barra - 11];   // trecho sem lábios: cabem a contraporca (frente) e o sextavado do PG7 (trás)
d_M3_piloto = 2.5;
d_M3_passante = 3.4;

// derivados do corte
tg = tan(ang_vidro);
z_al = [p_base, p_base + w_al];                 // alumínio (z), apoiado no fundo da ranhura de baixo
z_teto = z_al[1] + g_al;                        // fundo da ranhura de cima
H = z_teto + p_base;                            // altura total
y_top = H / tg;                                 // ponta da aba de cima (a de baixo fica em y = 0)
y_al = [y_top + avanco_sup, y_top + avanco_sup + t_al];   // faces do alumínio (frente, trás)
D = y_al[1] + g_al + lab;                       // profundidade total
z_fita = (z_al[0] + z_al[1]) / 2;               // centro da fita (meio do alumínio)
z_u = z_teto - 0.6;                             // face de baixo da aba de cima, à frente do lábio
z_ev = H - 0.8;                                 // a face do EVA da aba de cima desce até aqui
y_parafuso_ponta = y_al[0] - 4.5;               // parafusos das tampas da ponta
function y_vidro(z) = z / tg;                   // reta das pontas das abas (o vidro fica e_eva à frente)

// ---------------------------------------------------------------------
module hexagono(af, h) { cylinder(d = af / cos(30), h = h, $fn = 6); }

// Arco do para-brisa: o meio da barra fica mais à frente (y menor) e as
// pontas recuam a flecha s(x). Cada fatia do corte é deslocada em y.
function flecha(x) = pow(x - L_barra / 2, 2) / (2 * R_vidro);

function arco(cy, cz, r, a0, n = 6) = r < 0.05 ? [[cy, cz]] : [for (i = [0 : n]) let(a = a0 + 90 * i / n)
    [cy + r * cos(a), cz + r * sin(a)]];
// retângulo de cantos arredondados no plano (y, z), anti-horário
function ret(y0, y1, z0, z1, rf = 0.01, rb = 0.01) = concat(
    arco(y0 + rf, z0 + rf, rf, 180), arco(y1 - rb, z0 + rb, rb, 270),
    arco(y1 - rb, z1 - rb, rb, 0),   arco(y0 + rf, z1 - rf, rf, 90));

// Polígono com cantos boleados: pts = [[y, z, raio], ...]; raio 0 = canto vivo.
// Vale para cantos convexos e côncavos (o arco é tangente às duas arestas).
function _u(v) = v / norm(v);
function _ang(v) = atan2(v[1], v[0]);
function _boleia(p0, p1, p2, r, n) = let(
        u1 = _u(p0 - p1), u2 = _u(p2 - p1), m = acos(u1 * u2) / 2,
        d = r / tan(m), c = p1 + _u(u1 + u2) * r / sin(m),
        a1 = _ang(p1 + u1 * d - c), a2 = _ang(p1 + u2 * d - c),
        da = (a2 - a1 + 540) % 360 - 180)
    [for (k = [0 : n]) c + r * [cos(a1 + da * k / n), sin(a1 + da * k / n)]];
function boleado(pts, n = 6) = let(N = len(pts)) [for (i = [0 : N - 1]) let(
        p0 = [pts[(i + N - 1) % N][0], pts[(i + N - 1) % N][1]],
        p1 = [pts[i][0], pts[i][1]], p2 = [pts[(i + 1) % N][0], pts[(i + 1) % N][1]])
    each (pts[i][2] > 0 ? _boleia(p0, p1, p2, pts[i][2], n) : [p1])];

// sólido varrido ao longo do arco (um único poliedro); x é a posição ao longo da corda
module loft(x0, x1, perfil, passo = 10) {
    xs = concat([for (x = [x0 : passo : x1 - 0.001]) x], [x1]);
    n = len(perfil); m = len(xs);
    // cada fatia fica perpendicular ao arco (girada pela tangente)
    pts = [for (x = xs) let(t = atan((x - L_barra / 2) / R_vidro))
        for (q = perfil) [x - q[0] * sin(t), flecha(x) + q[0] * cos(t), q[1]]];
    // laterais em triângulos (quadriláteros do arco não são planos)
    lados = [for (i = [0 : m - 2]) for (j = [0 : n - 1]) each [
        [i*n + j, (i + 1)*n + j, (i + 1)*n + (j + 1) % n],
        [i*n + j, (i + 1)*n + (j + 1) % n, i*n + (j + 1) % n]]];
    polyhedron(points = pts, faces = concat(lados,
        [[for (j = [0 : n - 1]) j], [for (j = [n - 1 : -1 : 0]) (m - 1)*n + j]]), convexity = 6);
}

// posiciona um filho no arco: em x, deslocado pela flecha e girado com a tangente
module no_arco(x) translate([x, flecha(x), 0]) rotate([0, 0, atan((x - L_barra / 2) / R_vidro)]) children();

// ---------------------------------------------------------------------
// TRILHO DE BAIXO: aba longa até o vidro. Perfil (y, z) anti-horário:
// fundo reto (face da mesa), ranhura com lábios boleados, concordância
// côncava descendo do lábio da frente para a aba fina, e a ponta engrossada
// (p_ponta) com a face da frente na reta do vidro, para o EVA.
function perfil_inf() = let(yf = y_al[0] - g_al, yt = y_al[1] + g_al, zl = p_base + sob)
    boleado([
        [y_vidro(0.5), 0, 0],                         // ponta, embaixo (testa de 0,5 mm)
        [D - 1.2, 0, 0], [D, 1.2, 0.5],               // canto de trás: chanfro de 45° (aresta na mesa)
        [D, zl, 0.7],                                 // topo do lábio de trás
        [yt, zl, 0.5],
        [yt, p_base, 0], [yf, p_base, 0],             // fundo da ranhura
        [yf, zl, 0.5],                                // topo do lábio da frente
        [yf - lab, zl, 0.7],
        [yf - lab, p_aba, 1.5],                       // concordância côncava do lábio com a aba
        [y_vidro(p_ponta) + 6, p_aba, 3],             // aba fina
        [y_vidro(p_ponta) + 1.5, p_ponta, 1],         // ponta engrossada
        [y_vidro(p_ponta), p_ponta, 0.6],             // topo da ponta: a face do EVA desce na reta do vidro
        [y_vidro(0.5), 0.5, 0.3]]);

// TRILHO DE CIMA: aba curta até o vidro (perfil (y, z) anti-horário):
// face de baixo em z_u, ponta com face curta para o EVA e chanfro de 45°
// por baixo (de cabeça para baixo na mesa, nada passa de 45°), lábio da frente descendo sobre o alumínio, ranhura,
// lábio de trás, topo reto (vai para a mesa) e ponta na reta do vidro.
function perfil_sup() = let(yf = y_al[0] - g_al, yt = y_al[1] + g_al, zl = z_teto - sob)
    boleado([
        [y_vidro(z_ev) + (z_ev - z_u), z_u, 0.6],      // ponta: chanfro de 45° por baixo (imprime sem suporte)
        [yf - lab, z_u, 0.7],
        [yf - lab, zl, 0.7],                          // lábio da frente
        [yf, zl, 0.5],
        [yf, z_teto, 0], [yt, z_teto, 0],             // fundo da ranhura
        [yt, zl, 0.5],
        [D, zl, 0.7],                                 // lábio de trás
        [D, H - 1.2, 0.5], [D - 1.2, H, 0],           // canto de trás: chanfro de 45° (aresta na mesa)
        [y_top, H, 0.3],                              // ponta, em cima
        [y_vidro(z_ev), z_ev, 0.4]]);                 // face do EVA (na reta do vidro)

// recorte dos lábios no trecho do PG7 (região acima/abaixo do fundo da ranhura)
module sem_labio(sup) {
    zz = sup ? [z_teto - sob - 0.5, z_teto - 0.01] : [p_base + 0.01, p_base + sob + 0.5];
    loft(x_sem_labio[0], x_sem_labio[1], ret(y_al[0] - g_al - lab - 2.5, D + 1, zz[0], zz[1]), 5);
}
module furos_ponta(sup) {
    for (x = [5, L_barra - 5]) no_arco(x) translate([0, y_parafuso_ponta, sup ? z_u - 1 : -1]) cylinder(d = d_M3_passante, h = H);
}
module trilho_inf() difference() { loft(0, L_barra, perfil_inf()); sem_labio(false); furos_ponta(false); }
module trilho_sup() difference() { loft(0, L_barra, perfil_sup()); sem_labio(true); furos_ponta(true); }

// ---------------------------------------------------------------------
// DIVISÃO EM TRECHOS PARA A A1, com junta de LINGUETA HORIZONTAL + CLIQUE
// ---------------------------------------------------------------------
// Cada trilho (1100 mm) é cortado em n_seg trechos. A emenda é uma
// sobreposição horizontal: o trecho da esquerda termina numa LINGUETA larga
// (a própria parte plana da seção — a aba) que avança j_ov; o da direita
// recebe essa lingueta por baixo de um TETO atrás (lado da cabine) e tem a
// parte plana recortada para a lingueta entrar rente. No alto da lingueta há
// um DENTE que encaixa com clique numa FENDA (janela) do teto, travando a
// emenda. O alumínio contínuo corre na ranhura de todos os trechos e alinha
// a barra; cola na lingueta + silicone na ranhura fixam tudo.
//
// Em inf a parte plana é embaixo (z=0) e o teto/ranhura em cima; em sup é o
// contrário (a peça imprime virada). As funções abaixo trocam o sinel de z.
function xc(i) = L_barra * i / n_seg;              // posição do corte i
j_inf_top = p_base + sob;                          // topo do perfil de baixo (4 mm)
j_sup_bot = z_teto - sob;                          // base do perfil de cima
function j_flatz(sup) = sup ? [H - j_tm, H + 1] : [-1, j_tm];                 // faixa z da lingueta (parte plana)
function j_roofz(sup) = sup ? [j_sup_bot, H - j_tm - j_cl] : [j_tm + j_cl, j_inf_top];   // faixa z do teto (lado da ranhura)
function j_toothz(sup) = sup ? [H - j_tm - j_tooth, H - j_tm] : [j_tm, j_tm + j_tooth];   // z do dente (da lingueta p/ o teto)
j_yt = y_al[1] + g_al;         // início do lábio de trás (y)
j_ty_c = D - 1.5;              // centro do dente/janela em y (sob o teto)
j_xt = j_ov - 5;               // posição x do dente dentro da sobreposição (local ao no_arco)

// LINGUETA (macho): a parte plana do perfil, estendida j_ov em +x
module junta_lingueta(x, sup) {
    fz = j_flatz(sup);
    intersection() {
        loft(x, x + j_ov, sup ? perfil_sup() : perfil_inf());
        no_arco(x) translate([-1, -300, fz[0]]) cube([j_ov + 2, 600, fz[1] - fz[0]]);
    }
}
// DENTE (macho): cunha no alto da lingueta — rampa de entrada no lado +x,
// face de trava reta no lado -x (segura contra o arranque)
module junta_dente(x, sup) {
    tz = j_toothz(sup); zbase = sup ? tz[1] : tz[0]; ztip = sup ? tz[0] : tz[1];
    xt = j_xt;
    no_arco(x) hull() {
        translate([xt, j_ty_c - j_ty / 2, zbase]) cube([0.8, j_ty, 0.001]);        // -x, base
        translate([xt, j_ty_c - j_ty / 2, ztip]) cube([0.8, j_ty, 0.001]);         // -x, ponta (trava reta)
        translate([xt + j_tx, j_ty_c - j_ty / 2, zbase]) cube([0.001, j_ty, 0.001]); // +x, rampa até a base
    }
}
// TETO (fêmea): laje atrás, sobre a lingueta, que carrega a janela do dente
module junta_teto(x, sup) {
    rz = j_roofz(sup);
    no_arco(x) translate([0, j_yt - 0.5, min(rz[0], rz[1])])
        cube([j_ov - 1, (D + 2) - (j_yt - 0.5), abs(rz[1] - rz[0])]);
}
// recorte na fêmea: tira a parte plana (lingueta + folga) e abre a janela
module junta_recorte(x, sup) {
    fz = j_flatz(sup); rz = j_roofz(sup);
    // espaço da lingueta (parte plana) + folga vertical
    zl = sup ? [H - j_tm - j_cl, H + 2] : [-2, j_tm + j_cl];
    no_arco(x) translate([-1, -300, min(zl[0], zl[1])]) cube([j_ov + 1.3, 600, abs(zl[1] - zl[0])]);
    // janela do dente, atravessando o teto
    xt = j_xt;
    no_arco(x) translate([xt - j_folga, j_ty_c - j_ty / 2 - j_folga, min(rz[0], rz[1]) - 1])
        cube([j_tx + 2 * j_folga, j_ty + 2 * j_folga, abs(rz[1] - rz[0]) + 2]);
}

// corpo do trecho: o próprio loft entre xa e xb (pontas já fechadas)
module corpo_trecho(sup, xa, xb) difference() {
    loft(xa, xb, sup ? perfil_sup() : perfil_inf());
    sem_labio(sup); furos_ponta(sup);
}
module trecho(sup, j) {                            // j = 1..n_seg
    xa = xc(j - 1); xb = xc(j);
    difference() {
        union() {
            corpo_trecho(sup, xa, xb);
            if (j < n_seg) { junta_lingueta(xb, sup); junta_dente(xb, sup); }   // ponta direita: lingueta + dente
            if (j > 1) junta_teto(xa, sup);                                     // ponta esquerda: teto da fêmea
        }
        if (j > 1) junta_recorte(xa, sup);                                      // abre o espaço da lingueta e a janela
    }
}
module trilho_inf_trecho(j) trecho(false, j);
module trilho_sup_trecho(j) trecho(true, j);

// TAMPA DA PONTA (igual nas duas pontas): placa de 3 mm no contorno do
// corte (fecha a câmara e encosta no vidro pelo EVA) com língua que entra
// na câmara, à frente do alumínio; 2 parafusos M3 × 8, um por baixo (pela
// aba) e um por cima (pela aba de cima). Local: face externa em x = 0,
// língua para -x; o plano (y, z) do corte é o mesmo dos trilhos.
module corte_2d() { polygon(perfil_inf()); polygon(perfil_sup()); }
module camara_2d() difference() {
    hull() corte_2d();
    corte_2d();
    translate([y_al[0], -1]) square([D, H + 2]);       // alumínio e o que fica atrás dele
}
module no_plano_yz() multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0]]) children();   // (y, z) do 2D → (y, z) da peça, extrusão em x
module tampa_ponta() {
    p = 8;   // comprimento da língua
    difference() {
        union() {
            no_plano_yz() linear_extrude(3) offset(r = 0.6) offset(delta = -0.6) hull() corte_2d();
            translate([-p, 0, 0]) no_plano_yz() linear_extrude(p + 0.01) offset(delta = -folga) camara_2d();
        }
        translate([-5, y_parafuso_ponta, p_base + folga - 0.01]) cylinder(d = d_M3_piloto, h = 6);
        translate([-5, y_parafuso_ponta, z_u - folga - 6]) cylinder(d = d_M3_piloto, h = 6.01);
    }
}

// Fita, alumínio, EVA e vidro (visualização)
module fantasma_interno() {
    color("white") loft(x_fita[0], x_fita[1], ret(y_al[0] - e_fita, y_al[0], z_fita - w_fita/2, z_fita + w_fita/2, 1.5, 0.3), 20);
    color("silver") loft(0.3, L_barra - 0.3, ret(y_al[0], y_al[1], z_al[0], z_al[1]), 20);
}
module vidro() {   // vidro de 5 mm, e_eva à frente da reta das pontas
    s = e_eva / sin(ang_vidro);
    color("lightblue", 0.25) loft(-40, L_barra + 40,
        [[-s - 60 / tg, -60], [-s + (H + 40) / tg, H + 40], [-s - 5 / sin(ang_vidro) + (H + 40) / tg, H + 40], [-s - 5 / sin(ang_vidro) - 60 / tg, -60]], 20);
}

// GABARITO de furação do alumínio: marca o furo Ø12,7 do PG7 a partir da
// ponta do alumínio (a peça de 1100 mm é longa demais para gabarito inteiro).
module gabarito_furacao() {
    difference() {
        union() {
            translate([-2.4, -2.4, 0]) cube([40, w_al + 4.8, 2]);
            for (y = [-2.4, w_al]) translate([-2.4, y, 0]) cube([40, 2.4, 2 + t_al]);
            translate([-2.4, -2.4, 0]) cube([2.4, w_al + 4.8, 2 + t_al]);
        }
        // centro do PG7 medido a partir da ponta do alumínio que fica em x = L_barra
        translate([(L_barra - 0.3) - x_pg7, w_al / 2, -1]) cylinder(d = 3, h = 5);   // o alumínio termina 0,3 mm antes da ponta
    }
}

// ---------------------------------------------------------------------
// CONTROLADORA: caixa mínima em forma de seixo (todas as arestas boleadas),
// onde chega o cabo da barra. Dentro: Arduino Nano (fios soldados direto,
// sem adaptador), conversor 12 V → 5 V de 10 A (alimenta a fita de 5 V e o
// Nano) e uma plaquinha com o TVS, o capacitor e o resistor da linha de dados. Na tampa, 3 botões metálicos de 12 mm com
// os modos pré-programados, com o nome gravado ao lado:
//   VM = pisca vermelho · AZ|VM = pisca metade azul / metade vermelho ·
//   BR = acende branco. Tocar de novo no botão do modo ativo apaga.
// Local: interior a partir de (0, 0, 0); parede dos prensa-cabos em x = 0.
cx_int = [136, 60, 30];  // interior (x, y, altura) — medir as placas antes
p_cx = 2.4;              // parede
r_cx = 7;                // raio dos cantos e arestas (por fora)
z_corte = cx_int[2] - 4; // altura do corte base/tampa (a tampa leva os botões)
d_botao = 12.2;
xs_botao = [22, 38, 54]; // botões ao longo de x, sobre o Nano (placa baixa)
y_botao = 40;
nomes_botao = ["VM", "AZ|VM", "BR"];
pg = [[12.7, 12], [12.7, 38]];   // [furo, y]: PG7 da alimentação e PG7 do cabo da barra (contraporca até SW17)
z_pg = 13;               // centro dos prensa-cabos acima do fundo interno
// [nome, [x, y] do canto, [comprimento, largura], altura]
modulos = [
    ["plaquinha TVS/capacitor/resistor", [15, 3],  [22, 20], 12],
    ["Arduino Nano",                     [15, 30], [44, 19],  5],
    ["conversor 12→5 V 10 A",            [62, 4],  [64, 52], 24]];   // MEDIR o conversor comprado
// 3 postes: um entre os prensa-cabos e dois na ponta oposta, além do conversor
xy_postes = [[10, 25], [cx_int[0] - 4.5, 5], [cx_int[0] - 4.5, cx_int[1] - 5]];
// sólido arredondado: casca convexa de 8 esferas
module seixo(c, r, z0, z1) {
    hull() for (x = [r, c[0] - r], y = [r, c[1] - r], z = [z0 + r, z1 - r]) translate([x, y, z]) sphere(r = r);
}
module corpo_cx(inset) {
    // por fora: x de -p a int + p; por dentro: o próprio interior
    translate([-p_cx + inset, -p_cx + inset, 0])
        seixo([cx_int[0] + 2 * (p_cx - inset), cx_int[1] + 2 * (p_cx - inset)], max(r_cx - inset, 1), -p_cx + inset, cx_int[2] + p_cx - inset);
}
module caixa_completa() {
    difference() {
        corpo_cx(0);
        corpo_cx(p_cx);
        for (q = pg) translate([-p_cx - 1, q[1], z_pg]) rotate([0, 90, 0]) cylinder(d = q[0], h = p_cx + 2);
        for (i = [0 : 2]) translate([xs_botao[i], y_botao, cx_int[2] - 1]) cylinder(d = d_botao, h = p_cx + 3);
        // nomes gravados (0,6 mm) ao lado de cada botão
        for (i = [0 : 2]) translate([xs_botao[i], y_botao - 12, cx_int[2] + p_cx - 0.6])
            linear_extrude(1) text(nomes_botao[i], size = 4, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
    }
}
module caixa_controle() {     // base: tudo abaixo de z_corte
    difference() {
        union() {
            intersection() { caixa_completa(); translate([-50, -50, -50]) cube([300, 200, 50 + z_corte]); }
            // ressalto de encaixe da tampa
            intersection() {
                corpo_cx(p_cx - 0.01);
                difference() {
                    translate([-10, -10, z_corte - 0.01]) cube([cx_int[0] + 20, cx_int[1] + 20, 2.5]);
                    translate([1.2, 1.2, 0]) cube([cx_int[0] - 2.4, cx_int[1] - 2.4, 100]);
                }
            }
            for (q = xy_postes) translate([q[0], q[1], -p_cx + 1]) cylinder(d = 7, h = z_corte + p_cx - 1);
        }
        for (q = xy_postes) translate([q[0], q[1], 4]) cylinder(d = d_M3_piloto, h = z_corte);
    }
    // bolsos: muretas de 1,5 mm em volta de cada placa (folga de 0,5 mm); as placas vão com fita VHB
    for (m = modulos) translate([m[1][0] - 1.7, m[1][1] - 1.7, -0.01]) linear_extrude(1.5) difference() {
        offset(r = 1) square([m[2][0] + 1.4, m[2][1] + 1.4]);
        translate([1.2, 1.2]) square([m[2][0] + 1, m[2][1] + 1]);
    }
}
module tampa_controle() {     // tampa: tudo acima de z_corte (vira de cabeça para baixo na mesa)
    difference() {
        intersection() { caixa_completa(); translate([-50, -50, z_corte]) cube([300, 200, 100]); }
        // rebaixo que recebe o ressalto da base (folga de 0,3)
        intersection() {
            corpo_cx(p_cx - 0.31);
            translate([-10, -10, z_corte - 1]) cube([cx_int[0] + 20, cx_int[1] + 20, 3.81]);
        }
        for (q = xy_postes) {
            translate([q[0], q[1], z_corte - 1]) cylinder(d = d_M3_passante, h = 20);
            translate([q[0], q[1], cx_int[2] + p_cx - 1.8]) cylinder(d1 = d_M3_passante, d2 = 6.6, h = 1.81);
        }
    }
    // postes curtos da tampa sobre os postes da base
    for (q = xy_postes) difference() {
        translate([q[0], q[1], z_corte + 0.3]) cylinder(d = 7, h = cx_int[2] - z_corte - 0.3 + 0.5);
        translate([q[0], q[1], z_corte]) cylinder(d = d_M3_passante, h = 20);
    }
}

// ---------------------------------------------------------------------
module montagem() {
    color("dimgray") { trilho_inf(); trilho_sup(); }
    fantasma_interno();
    color("gray") { no_arco(L_barra) tampa_ponta(); no_arco(0) mirror([1, 0, 0]) tampa_ponta(); }
    vidro();
    // retrovisor interno (referência: a barra passa por cima)
    color("black", 0.4) translate([L_barra / 2 - 35, D - 25, -80]) cube([70, 25, 60]);
}

// ---------------------------------------------------------------------
// Seletor de peças (orientadas para impressão)
if (peca == "montagem") montagem();
else if (peca == "trilho_inf") { if (seg > 0) trilho_inf_trecho(seg); else trilho_inf(); }                 // aba na mesa
else if (peca == "trilho_sup") translate([0, 0, H]) rotate([180, 0, 0]) { if (seg > 0) trilho_sup_trecho(seg); else trilho_sup(); }   // topo na mesa
else if (peca == "tampa_ponta") rotate([0, 90, 0]) tampa_ponta();             // placa na mesa (imprimir 2)
else if (peca == "gabarito_furacao") gabarito_furacao();
else if (peca == "caixa_controle") caixa_controle();   // fundo na mesa
else if (peca == "tampa_controle") translate([0, 0, cx_int[2] + p_cx]) rotate([180, 0, 0]) tampa_controle();   // topo na mesa

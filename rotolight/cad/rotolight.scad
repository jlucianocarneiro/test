// =====================================================================
// Rotolight LED — barra estroboscópica para parabrisa de viatura (PCDF)
// Projeto paramétrico. Unidade: mm. OpenSCAD 2021.01+
//
// v0.7: BARRA ÚNICA ao longo do topo do para-brisa, passando acima do
// retrovisor, só com o básico: dois trilhos impressos que seguram a fita RGB endereçável
// escolhida (SEZO WS2812B, 5 V, 144 LED/m, 1 m, IP65 com revestimento de silicone), a ligação e o cabo
// que sai para a controladora. A fita já é impermeável: não há janela nem
// policarbonato na frente. Braços, docas, ventosas e pontos de fixação
// saíram nesta versão (a fixação será definida depois). O limite da mesa
// da impressora foi deixado de lado nesta etapa (peça única de L_barra).
//
// Corte (y = 0 voltado para o vidro, y = D para a cabine):
//   a peça estrutural é a barra chata de alumínio 1" × 1/8" (fundo,
//   dissipador e rigidez), com a fita colada na face da frente. Dois TRILHOS
//   impressos iguais (o de cima e o de baixo são a mesma peça virada)
//   abraçam as bordas do alumínio por ranhuras e cobrem as bordas da fita;
//   duas TAMPAS DE PONTA iguais fecham as pontas e prendem os trilhos com
//   parafusos M3. O alumínio fica exposto ao ar da cabine atrás. A barra
//   acompanha o arco do para-brisa em planta (R_vidro): alumínio, fita e
//   trilhos ficam finos no sentido em que vergam.
//   Os trilhos imprimem deitados (perfil de 4 mm de altura), sem suporte.
//
// Uso:  openscad -D 'peca="trilho"' -o trilho.stl rotolight.scad
// Peças: montagem, trilho (×2), tampa_ponta (×2), gabarito_furacao,
//        caixa_controle, tampa_controle
// =====================================================================

peca = "montagem";

$fn = 48;
folga = 0.3;          // folga de encaixe por lado (A1, bico 0.4, PETG)

/* [Barra] */
L_barra = 1100;       // comprimento (PROVISÓRIO: medir no carro)
R_vidro = 3000;       // raio do para-brisa em planta (medir: R = c²/(8·f))
r_frente = 2;         // raio das arestas da frente
r_tras = 2;           // raio das arestas de trás

/* [Alumínio (fundo e dissipador)] */
w_al = 25.4;          // barra chata 1" × 1/8"
t_al = 3.18;
g_al = 0.2;           // folga por lado na ranhura
lab = 1.6;            // espessura do lábio de trás
sob_lab = 2.0;        // quanto o lábio e o ombro cobrem o alumínio em cada borda
p_tb = 2.0;           // parede de cima e de baixo, sobre a ranhura

/* [Fita SEZO WS2812B IP65, 1 m] */
w_fita = 12;          // largura com o silicone (MEDIR a fita comprada)
e_fita = 3;           // espessura com o silicone (MEDIR)
L_fita = 1000;        // 1 rolo = 1 m = 144 LEDs
x_fita = [L_barra - 36 - L_fita, L_barra - 36];  // a ponta x = L tem o PG7; as línguas das tampas ocupam 8 mm em cada ponta
x_pg7 = L_barra - 22;         // PG7 pelo alumínio (cabo para a caixa); contraporca até SW17
d_M3_piloto = 2.5;
d_M3_passante = 3.4;

H = w_al + 2 * (g_al + p_tb);        // altura total (29,8)
D = lab + t_al + 2 * g_al + e_fita + 2.5;   // profundidade: o trilho passa 2,5 mm da fita (cabe a contraporca do PG7 de 5 mm)
// derivados do corte
z_g = [(H - w_al) / 2 - g_al, (H + w_al) / 2 + g_al];     // ranhura do alumínio (z)
y_g = [D - lab - t_al - 2 * g_al, D - lab];               // ranhura do alumínio (y)
z_c = [z_g[0] + sob_lab, z_g[1] - sob_lab];                // cavidade e abertura de trás (z)
y_parafuso_ponta = y_g[0] / 2;   // parafusos da tampa da ponta, no meio da língua

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
// TRILHO (o de baixo; o de cima é a mesma peça girada 180° em torno do
// eixo y). Perfil de altura z_c[0]: base de p_tb + ombro na frente (até a
// ranhura) e lábio atrás. Furos M3 passantes nas duas pontas para as tampas.
// perfil do trilho (y, z), anti-horário, todo arredondado: base com
// bordas de raio 2, ombro da frente descendo em curva até a fita, lábio de
// trás com topo boleado e a ranhura do alumínio entre os dois.
function perfil_trilho() = let(zt = z_c[0], zg = z_g[0], r = 1.8, rl = 0.7)
    concat(
        arco(r, r, r, 180),                 // canto de baixo, frente
        arco(D - r, r, r, 270),             // canto de baixo, trás
        arco(D - rl, zt - rl, rl, 0),       // topo do lábio, por fora
        arco(y_g[1] + rl, zt - rl, rl, 90), // topo do lábio, por dentro
        [[y_g[1], zg], [y_g[0], zg]],       // fundo da ranhura
        arco(y_g[0] - rl, zt - rl, rl, 0),  // ombro junto à ranhura
        // ombro descendo em curva suave até a frente (sem quina)
        [for (i = [1 : 7]) let(t = i / 8) [(y_g[0] - rl) * (1 - t), zt - (zt - r) * t * t]]);
module trilho() {
    difference() {
        loft(0, L_barra, perfil_trilho());
        for (x = [5, L_barra - 5]) no_arco(x) translate([0, y_parafuso_ponta, -1]) cylinder(d = d_M3_passante, h = z_c[0] + 2);
    }
}
module trilho_sup() translate([L_barra, 0, H]) rotate([0, 180, 0]) mirror([0, 0, 0]) trilho();

// TAMPA DA PONTA (igual nas duas pontas): placa de 3 mm no contorno da barra
// com língua que entra entre os trilhos, à frente do alumínio; 2 parafusos
// M3 × 8 pelos trilhos (em cima e embaixo). Local: face externa em x = 0,
// língua para -x.
module tampa_ponta() {
    p = 8;   // comprimento da língua
    difference() {
        union() {
            // placa externa no contorno da barra
            rotate([0, 90, 0]) mirror([1, 0, 0]) linear_extrude(3)
                polygon([for (q = ret(0, D, 0, H, r_frente, r_tras)) [q[1], q[0]]]);
            // língua: preenche a cavidade na ponta (o alumínio encosta na face interna)
            translate([-p, folga, z_c[0] + folga]) cube([p, y_g[0] - 2 * folga, z_c[1] - z_c[0] - 2 * folga]);
        }
        for (z = [z_c[0] + folga - 0.01, z_c[1] - folga - 6]) translate([-5, y_parafuso_ponta, z]) cylinder(d = d_M3_piloto, h = 6.01);
    }
}

// Fita e alumínio (visualização)
module fantasma_interno() {
    color("white") loft(x_fita[0], x_fita[1], ret(y_g[0] - e_fita, y_g[0], H/2 - w_fita/2, H/2 + w_fita/2, 2, 2), 20);
    color("silver") loft(0.3, L_barra - 0.3, ret(y_g[0] + g_al, y_g[0] + g_al + t_al, H/2 - w_al/2, H/2 + w_al/2), 20);
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
        translate([L_barra - 3 - x_pg7, w_al / 2, -1]) cylinder(d = 3, h = 5);
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
    color("dimgray") { trilho(); trilho_sup(); }
    fantasma_interno();
    color("gray") { no_arco(L_barra) tampa_ponta(); no_arco(0) mirror([1, 0, 0]) tampa_ponta(); }
    // retrovisor interno (referência: a barra passa por cima)
    color("black", 0.4) translate([L_barra / 2 - 35, 20, -80]) cube([70, 25, 60]);
}

// ---------------------------------------------------------------------
// Seletor de peças (orientadas para impressão)
if (peca == "montagem") montagem();
else if (peca == "trilho") trilho();        // deitado na mesa (imprimir 2)
else if (peca == "tampa_ponta") rotate([0, 90, 0]) tampa_ponta();   // placa na mesa (imprimir 2)
else if (peca == "gabarito_furacao") gabarito_furacao();
else if (peca == "caixa_controle") caixa_controle();   // fundo na mesa
else if (peca == "tampa_controle") translate([0, 0, cx_int[2] + p_cx]) rotate([180, 0, 0]) tampa_controle();   // topo na mesa

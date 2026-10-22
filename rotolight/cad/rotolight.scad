// =====================================================================
// Rotolight LED — barra estroboscópica para parabrisa de viatura (PCDF)
// Projeto paramétrico. Unidade: mm. OpenSCAD 2021.01+
//
// Arquitetura: duas meias-barras idênticas (espelhadas), uma de cada lado
// do retrovisor interno. Cada meia-barra fica pendurada num braço
// telescópico que sai de uma doca presa sob o parafuso do quebra-sol.
//
// Uso:  openscad -D 'peca="carcaca_E"' -o carcaca_E.stl rotolight.scad
// Peças: montagem, carcaca_E, carcaca_D, junta_vedacao, adaptador,
//        braco_fixo, braco_corredica, engate, doca, pino, manopla_parafuso,
//        manopla_porca, caixa, tampa_caixa, gabarito_furacao
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
p_tb = 5;             // paredes superior/inferior (recebem parafusos M3)
p_ext = 5;            // paredes das pontas

/* [LEDs e óptica] */
passo_led = 11;       // passo entre LEDs (lente TIR Ø10)
colunas = 18;         // 18 colunas × 2 fileiras = 36 LEDs por meia-barra
dz_fileira = 5.5;     // meia distância entre as duas fileiras
x_c = 109.5;          // centro do campo de LEDs ao longo da barra
janela = [203, 22];   // abertura frontal
lente_pc = [207, 26, 2]; // placa de policarbonato colada por dentro

/* [Junta rosácea (inclinação da barra)] */
d_ros = 15;
n_dentes = 24;
h_dente = 1.2;
L_ressalto = 12;

/* [Ventosa auxiliar] */
angulo_vidro = 28;    // inclinação do parabrisa em relação à horizontal
h_aba = 4;
d_cabeca_ventosa = 10.5; // cabeça "cogumelo" da mini ventosa Ø30
d_pescoco_ventosa = 6.2;

/* [Braço e doca] */
L_fixo = 150;
L_corr = 170;
tubo_ext = [18, 14];
tubo_int = [12.6, 8.6];
corredica = [12, 8];
d_pino = 4.3;          // furo do pino de trava (pino Ø4)
d_M5 = 5.4;
d_M3_piloto = 2.5;     // parafuso M3 autoatarraxante em PETG
d_M3_passante = 3.4;
d_parafuso_quebra_sol = 6.5; // medir com paquímetro no veículo
e_doca = 2.5;          // espessura da lingueta que vai sob o suporte do quebra-sol
d_ima = 10.3; h_ima = 1.7;   // ímã Ø10 × 1,5 em estoque
porca_M5_af = 8.3; h_porca_M5 = 4.3; h_cabeca_M5 = 3.7;

/* [Caixa de controle] */
x_caixa = 108;         // posição na meia-barra esquerda (cobre 3 colunas de parafusos,
                       // deixa livre o parafuso da ponta interna)
L_caixa = 124;
P_caixa = 30;
z_caixa = [6, 32.1];
d_botao = 12.2;        // furo do pulsador metálico 12 mm à prova d'água

// ---------------------------------------------------------------------
// Pontos de parafuso da tampa de alumínio (x, z) — compartilhados por
// bandeja, junta de vedação, tampa de alumínio, caixa e gabarito.
xs_borda = [10, 65, 119, 173, 228];
function furos_tampa() = concat(
    [for (x = xs_borda) [x, p_tb/2]],
    [for (x = xs_borda) [x, H - p_tb/2]],
    [[p_ext/2, H/2 + 10], [L - p_ext/2, H/2 + 10]]); // acima do furo M5 da junta
x_prensa = 222;        // prensa-cabo PG7 atravessa a tampa de alumínio aqui

// ---------------------------------------------------------------------
module hexagono(af, h) { cylinder(d = af / cos(30), h = h, $fn = 6); }

module dente_rosacea(r, w, h) {
    rotate([90, 0, 90]) linear_extrude(r)
        polygon([[-w/2, 0], [w/2, 0], [0, h]]);
}

// rosácea no plano z=0, dentes para +z
module rosacea(d = d_ros, n = n_dentes, h = h_dente) {
    difference() {
        intersection() {
            union() {
                for (i = [0 : n - 1]) rotate([0, 0, i * 360 / n])
                    translate([3.4, 0, 0]) dente_rosacea(d/2 - 2.4, PI * d / n, h);
                translate([0, 0, -0.2]) cylinder(d = d, h = 0.2);
            }
            translate([0, 0, -0.2]) cylinder(d = d, h = h + 0.2);
        }
        translate([0, 0, -1]) cylinder(d = d_M5, h = h + 2);
    }
}

// ---------------------------------------------------------------------
// BANDEJA DA MEIA-BARRA. Coordenadas: x ao longo da barra (x=0 = ponta
// externa, lado do quebra-sol), y=0 face frontal (vidro), y=D face
// traseira (onde assenta a tampa de alumínio), z=0 base.
// Imprimir com a face frontal na mesa (y=0 para baixo).
module aba_ventosa() {
    x0 = L - 30; w = 26; prof = 24;
    difference() {
        hull() {
            translate([x0, 1.5, H - 0.01]) cube([w, D - 3, 0.01]);
            translate([x0, 1.5, H + h_aba]) rotate([angulo_vidro, 0, 0])
                cube([w, prof, 3]);
        }
        // fechadura para a cabeça da ventosa
        translate([x0 + w/2, 1.5, H + h_aba]) rotate([angulo_vidro, 0, 0]) {
            translate([0, 17, -10]) cylinder(d = d_cabeca_ventosa, h = 20);
            hull() {
                translate([0, 17, -10]) cylinder(d = d_pescoco_ventosa, h = 20);
                translate([0, 8, -10]) cylinder(d = d_pescoco_ventosa, h = 20);
            }
            // rebaixo para a cabeça assentar (não sair sozinha)
            hull() {
                translate([0, 8, -20]) cylinder(d = d_cabeca_ventosa, h = 20);
                translate([0, 12, -20]) cylinder(d = d_cabeca_ventosa, h = 20);
            }
        }
    }
}

module carcaca() {
    difference() {
        union() {
            cube([L, D, H]);
            // ressalto da junta rosácea na ponta externa
            translate([0, D/2, H/2]) rotate([0, -90, 0])
                cylinder(d = d_ros, h = L_ressalto);
            translate([-L_ressalto, D/2, H/2]) rotate([0, -90, 0]) rosacea();
            aba_ventosa();
        }
        // cavidade, aberta para trás
        translate([p_ext, p_frente, p_tb]) cube([L - 2*p_ext, D, H - 2*p_tb]);
        // janela frontal
        translate([x_c - janela[0]/2, -1, H/2 - janela[1]/2])
            cube([janela[0], p_frente + 2, janela[1]]);
        // furos-piloto M3 para a tampa de alumínio
        for (p = furos_tampa()) translate([p[0], D + 0.01, p[1]])
            rotate([90, 0, 0]) cylinder(d = d_M3_piloto, h = 13.5); // M3×16 entra 11,8 mm
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

// Placa de policarbonato e PCB, apenas para visualização
module fantasma_interno() {
    color("lightblue", 0.4)
        translate([x_c - lente_pc[0]/2, p_frente, H/2 - lente_pc[1]/2])
        cube([lente_pc[0], lente_pc[2], lente_pc[1]]);
    color("white") translate([x_c - 105.5, D + 1 - 1.6, H/2 - 13])
        cube([211, 1.6, 26]);
    for (c = [0 : colunas - 1], s = [-1, 1])
        color(["red", "white", "blue"][(c + (s > 0 ? 0 : 1)) % 3])
        translate([x_c + (c - (colunas - 1)/2) * passo_led, D + 1 - 1.6, H/2 + s*dz_fileira])
        rotate([90, 0, 0]) cylinder(d = 10, h = 7);
    color("silver") translate([0, D + 1, 0]) cube([L, t_al, H]);
}

// ---------------------------------------------------------------------
// JUNTA DE VEDAÇÃO (TPU, 1 mm) entre bandeja e tampa de alumínio.
// Imprime deitada.
module junta_vedacao() {
    difference() {
        cube([L, H, 1]);
        translate([p_ext - 0.5, p_tb - 0.5, -1]) cube([L - 2*p_ext + 1, H - 2*p_tb + 1, 3]);
        for (p = furos_tampa()) translate([p[0], p[1], -1]) cylinder(d = d_M3_passante, h = 3);
    }
}

// GABARITO de furação da tampa de alumínio (PLA/PETG, 2 mm). Encaixa
// sobre a barra chata e marca os 12 furos Ø3,4 e o furo Ø12,7 do PG7.
module gabarito_furacao() {
    difference() {
        union() {
            translate([-2.4, -2.4, 0]) cube([L + 4.8, H + 4.8, 2]);
            // abas laterais que abraçam a barra chata
            for (y = [-2.4, H]) translate([-2.4, y, 0]) cube([L + 4.8, 2.4, 2 + t_al]);
        }
        for (p = furos_tampa()) translate([p[0], p[1], -1]) cylinder(d = 2.0, h = 5);
        translate([x_prensa, H/2, -1]) cylinder(d = 3, h = 5);
        // janelas de economia de material
        for (i = [0 : 3]) translate([20 + i * 54, 9, -1]) cube([42, H - 18, 5]);
    }
}

// ---------------------------------------------------------------------
// ADAPTADOR: junta rosácea (eixo ao longo da barra) + aba de articulação
// vertical (guinada). Coordenadas no referencial da carcaça (lado E).
x_adapt = -L_ressalto - h_dente;   // face dos dentes do adaptador
e_adapt = 8;
x_arm = x_adapt - e_adapt - 18;    // eixo da articulação vertical
z_aba = H + 2.2;                   // base da aba de 6 mm
module adaptador() {
    difference() {
        union() {
            // placa
            hull() {
                translate([x_adapt - e_adapt, D/2, H/2]) rotate([0, 90, 0]) cylinder(d = 16, h = e_adapt);
                translate([x_adapt - e_adapt, D/2 - 8, z_aba]) cube([e_adapt, 16, 6]);
            }
            translate([x_adapt, D/2, H/2]) rotate([0, 90, 0]) rosacea();
            // aba horizontal com furo vertical
            hull() {
                translate([x_adapt - e_adapt, D/2 - 8, z_aba]) cube([e_adapt, 16, 6]);
                translate([x_arm, D/2, z_aba]) cylinder(d = 16, h = 6);
            }
        }
        translate([x_adapt - e_adapt - 1, D/2, H/2]) rotate([0, 90, 0]) cylinder(d = d_M5, h = 20);
        translate([x_arm, D/2, z_aba - 1]) cylinder(d = d_M5, h = 8);
    }
}

// ---------------------------------------------------------------------
// GARFO (clevis) com cabeça do parafuso M5 cativa na bochecha inferior.
// Eixo do furo em (0,0); o garfo se prolonga para -x. Fenda de 6.4 mm
// centrada em z=0. Bochecha inferior 5 mm, superior 4 mm.
module garfo(comp = 18) {
    difference() {
        hull() {
            translate([0, 0, -8.2]) cylinder(d = 16, h = 15.4);
            translate([-comp, -8, -8.2]) cube([1, 16, 15.4]);
        }
        // fenda
        translate([-comp + 4, -12, -3.2]) cube([comp + 20, 24, 6.4]);
        translate([0, 0, -10]) cylinder(d = d_M5, h = 20);
        // cabeça sextavada M5 (DIN 933) cativa, por baixo
        translate([0, 0, -8.21]) rotate([0, 0, 30]) hexagono(porca_M5_af, h_cabeca_M5);
    }
}

// Aba simples (6 mm) com furo, eixo em (0,0), prolonga para +x
module aba_articulacao(comp = 14) {
    difference() {
        hull() {
            translate([0, 0, -3]) cylinder(d = 16, h = 6);
            translate([comp - 1, -8, -3]) cube([1, 16, 6]);
        }
        translate([0, 0, -5]) cylinder(d = d_M5, h = 10);
    }
}

// ---------------------------------------------------------------------
// BRAÇO CORREDIÇA: barra 12×8 com furos a cada 10 mm; garfo na ponta
// que vai à barra de LEDs. Local: x de 0 a L_corr, garfo além disso.
module braco_corredica() {
    difference() {
        translate([0, -corredica[0]/2, -corredica[1]/2]) cube([L_corr, corredica[0], corredica[1]]);
        for (x = [15 : 10 : 125]) translate([x, 0, -10]) cylinder(d = d_pino, h = 20);
        // chanfro de entrada
        translate([-1, 0, 0]) rotate([0, 90, 0]) cylinder(d = 30, h = 1.5, $fn = 4);
    }
    translate([L_corr + 14, 0, 0]) mirror([0, 0, 1]) garfo(18);
}

// BRAÇO FIXO: tubo 18×14 aberto em +x; aba de articulação em -x;
// presilhas laterais para o cabo de força.
module presilha_cabo() {
    difference() {
        rotate([0, 90, 0]) cylinder(d = 11, h = 8);
        translate([-1, 0, 0]) rotate([0, 90, 0]) cylinder(d = 7.2, h = 10);
        translate([-1, -2.6, 2]) cube([10, 5.2, 10]);
    }
}
module braco_fixo() {
    difference() {
        translate([0, -tubo_ext[0]/2, -tubo_ext[1]/2]) cube([L_fixo, tubo_ext[0], tubo_ext[1]]);
        translate([15, -tubo_int[0]/2, -tubo_int[1]/2]) cube([L_fixo, tubo_int[0], tubo_int[1]]);
        translate([L_fixo - 8, 0, -10]) cylinder(d = d_pino, h = 20);
    }
    translate([-10, 0, 0]) aba_articulacao(11);
    for (x = [35, 105]) translate([x, tubo_ext[0]/2 + 4.4, 0]) presilha_cabo();
}

// ---------------------------------------------------------------------
// ENGATE: língua 14×8 que entra no soquete da doca + garfo para o braço.
// Local: ponta da língua em x=0, z=0 é o fundo do canal da doca.
module engate() {
    difference() {
        translate([0, -7, 0]) cube([28, 14, 8]);
        translate([12, 0, -1]) cylinder(d = d_pino, h = 10);
        translate([-1, -8, -1]) rotate([0, 0, 0]) cube([1.5, 16, 1.5]); // chanfro
    }
    translate([28 + 16, 0, 8.2]) garfo(18);
}

// DOCA: lingueta fina que vai sob o suporte do quebra-sol (furo oblongo
// para o parafuso original) + soquete com fenda para o engate, furo do
// pino e alojamento de ímã. Local: base da lingueta em z=0.
module doca() {
    x_sq = 22; L_sq = 32; z_canal = e_doca; h_canal = 8 + 2*0.2;
    difference() {
        union() {
            hull() {
                translate([4, 0, 0]) cylinder(d = 26, h = e_doca);
                translate([x_sq, -13, 0]) cube([L_sq, 26, e_doca]);
            }
            translate([x_sq, -11, 0]) cube([L_sq, 22, z_canal + h_canal + 3.1]);
        }
        // furo oblongo do parafuso do quebra-sol
        hull() for (x = [2, 12]) translate([x, 0, -1]) cylinder(d = d_parafuso_quebra_sol, h = 5);
        // canal da língua, aberto em +x
        translate([x_sq + 6, -7 - 0.2, z_canal]) cube([L_sq, 14.4, h_canal]);
        // furo do pino (cego na lingueta)
        translate([x_sq + 6 + 12, 0, 1]) cylinder(d = d_pino, h = 20);
        // ímã
        translate([x_sq + 7, 0, z_canal + h_canal + 3.1 - h_ima]) cylinder(d = d_ima, h = 5);
    }
}

// PINO de trava com cabeça imantada
module pino() {
    comp = 3.1 + 8.4 + 1.3;
    hull() {
        cylinder(d = 14, h = 3);
        translate([-11, 0, 0]) cylinder(d = 14, h = 3);
    }
    translate([0, 0, 3]) {
        cylinder(d = 4.0, h = comp - 0.6);
        translate([0, 0, comp - 0.6]) cylinder(d1 = 4.0, d2 = 3.0, h = 0.6);
    }
}
module pino_impressao() {
    difference() {
        pino();
        translate([-11, 0, -0.01]) cylinder(d = d_ima, h = h_ima);
    }
}

// ---------------------------------------------------------------------
// MANOPLAS M5 (sem ferramenta)
module manopla(base) {
    difference() {
        union() {
            cylinder(d = 18, h = 10);
            for (i = [0 : 7]) rotate([0, 0, i * 45]) translate([9, 0, 0]) cylinder(d = 7, h = 10);
        }
        translate([0, 0, -1]) cylinder(d = d_M5, h = 12);
        if (base == "parafuso") translate([0, 0, 10 - h_cabeca_M5]) hexagono(porca_M5_af, 5);
        else translate([0, 0, -0.01]) hexagono(porca_M5_af, h_porca_M5);
    }
}

// ---------------------------------------------------------------------
// CAIXA DE CONTROLE (presa às costas da meia-barra E pelos mesmos
// parafusos da tampa de alumínio). Local: x ao longo da barra a partir
// de x_caixa, y=0 encostado no alumínio, z como na carcaça.
module caixa() {
    pw = 2.2; zb = z_caixa[0]; zt = z_caixa[1];
    difference() {
        union() {
            cube([L_caixa, 2.5, H]);  // base com abas de fixação
            translate([0, 0, zb]) cube([L_caixa, P_caixa, zt - zb]);
        }
        // interior
        translate([pw, 2.5, zb + pw]) cube([L_caixa - 2*pw, P_caixa, zt - zb - 2*pw]);
        // furos M3 passantes alinhados aos da tampa de alumínio
        for (p = furos_tampa()) if (p[0] > x_caixa && p[0] < x_caixa + L_caixa)
            translate([p[0] - x_caixa, -1, p[1]]) rotate([-90, 0, 0]) cylinder(d = d_M3_passante, h = 5);
        // passagem do PG7 da meia-barra E
        translate([x_prensa - x_caixa, -1, H/2]) rotate([-90, 0, 0]) cylinder(d = 12.7, h = 5);
        // PG7 da alimentação na ponta externa (o PG7 do enlace com a meia-barra D fica na tampa)
        translate([-1, 2.5 + 14, H/2]) rotate([0, 90, 0]) cylinder(d = 12.7, h = pw + 2);
    }
    // postes da tampa
    for (x = [pw + 3, L_caixa - pw - 3], z = [zb + pw + 3, zt - pw - 3])
        difference() {
            translate([x, 2.5, z]) rotate([-90, 0, 0]) cylinder(d = 7, h = P_caixa - 2.5);
            translate([x, 10, z]) rotate([-90, 0, 0]) cylinder(d = d_M3_piloto, h = P_caixa);
        }
}
module tampa_caixa() {
    pw = 2.2; zb = z_caixa[0]; zt = z_caixa[1];
    difference() {
        union() {
            cube([L_caixa, zt - zb, 2.5]);
            // ressalto que entra na caixa (centragem)
            translate([pw + folga, pw + folga, 2.5]) difference() {
                cube([L_caixa - 2*pw - 2*folga, zt - zb - 2*pw - 2*folga, 2]);
                translate([1.6, 1.6, -1]) cube([L_caixa - 2*pw - 2*folga - 3.2, zt - zb - 2*pw - 2*folga - 3.2, 4]);
            }
        }
        for (x = [pw + 3, L_caixa - pw - 3], z = [pw + 3, zt - zb - pw - 3])
            translate([x, z, -1]) cylinder(d = d_M3_passante, h = 10);
        // botão pulsador 12 mm IP67 (modo/cor/dia-noite)
        translate([L_caixa/2, (zt - zb)/2, -1]) cylinder(d = d_botao, h = 10);
        // PG7 do cabo de enlace com a meia-barra direita
        translate([L_caixa - 24, (zt - zb)/2, -1]) cylinder(d = 12.7, h = 10);
    }
}

// ---------------------------------------------------------------------
// MONTAGEM (só visualização), na posição de uso: z para cima, teto do
// carro acima da doca. Meia-barra esquerda na origem.
z_arm = z_aba + 3;                       // eixo do braço
x_corr0 = x_arm - (L_corr + 14);         // início da corrediça
x_tubo0 = x_corr0 - 87;                  // tubo sobrepõe 63 mm (pino no furo 55)
x_art = x_tubo0 - 10;                    // articulação doca/braço
module meia_barra_montada(lado = "E") {
    mirror([lado == "E" ? 0 : 1, 0, 0]) {
        color("dimgray") carcaca();
        fantasma_interno();
        color("orange") adaptador();
        color("gold") translate([x_corr0, D/2, z_arm]) braco_corredica();
        color("goldenrod") translate([x_tubo0, D/2, z_arm]) braco_fixo();
        // engate, doca e pino ficam invertidos (doca colada no teto)
        translate([x_art, D/2, z_arm]) mirror([0, 0, 1]) translate([-44, 0, -8.2]) {
            color("khaki") engate();
            translate([-28, 0, -e_doca]) {
                color("steelblue") doca();
                color("red") translate([40, 0, 17]) rotate([180, 0, 0]) pino();
            }
        }
        // manoplas
        color("black") {
            translate([x_adapt - e_adapt - 10, D/2, H/2]) rotate([0, 90, 0]) manopla("parafuso");
            translate([x_arm, D/2, z_arm - 8.2 - 10]) manopla("porca");
            translate([x_art, D/2, z_arm - 8.2 - 10]) manopla("porca");
        }
        if (lado == "E") color("teal") translate([x_caixa, D + 1 + t_al, 0]) caixa();
    }
}

module montagem() {
    meia_barra_montada("E");
    translate([2 * L + 140, 0, 0]) meia_barra_montada("D");
    // retrovisor interno (referência)
    color("black", 0.4) translate([L + 70 - 35, 40, -25]) cube([70, 25, 60]);
}

// ---------------------------------------------------------------------
// Seletor de peças (orientadas para impressão)
if (peca == "montagem") montagem();
else if (peca == "meia_barra") meia_barra_montada("E");
else if (peca == "carcaca_E") rotate([-90, 0, 0]) mirror([0, 1, 0]) carcaca_lado("E");
else if (peca == "carcaca_D") rotate([-90, 0, 0]) mirror([0, 1, 0]) carcaca_lado("D");
else if (peca == "junta_vedacao") junta_vedacao();
else if (peca == "gabarito_furacao") gabarito_furacao();
else if (peca == "adaptador") rotate([0, -90, 0]) translate([-(x_adapt - e_adapt), 0, 0]) adaptador();
else if (peca == "braco_corredica") rotate([90, 0, 0]) braco_corredica();
else if (peca == "braco_fixo") rotate([90, 0, 0]) braco_fixo();
else if (peca == "engate") rotate([90, 0, 0]) engate();
else if (peca == "doca") doca();
else if (peca == "pino") pino_impressao();
else if (peca == "manopla_parafuso") manopla("parafuso");
else if (peca == "manopla_porca") manopla("porca");
else if (peca == "caixa") rotate([90, 0, 0]) caixa();
else if (peca == "tampa_caixa") tampa_caixa();

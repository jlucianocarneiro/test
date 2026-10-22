#!/usr/bin/env bash
# Gera STL + 3MF por peça em ./exportados (uso: ./exportar.sh [pasta_saida])
set -euo pipefail
cd "$(dirname "$0")"
OUT="${1:-exportados}"; mkdir -p "$OUT"
PECAS="trilho_inf trilho_sup tampa_ponta gabarito_furacao caixa_controle tampa_controle"
for p in $PECAS; do
  echo ">> $p"; openscad -q -D "peca=\"$p\"" -o "$OUT/$p.stl" rotolight.scad
done

# Confere se cada peça cabe na Bambu Lab A1 (256 × 256 × 256 mm) e gera .3mf
python3 -I - "$OUT" <<'PY'
import sys, glob, os
try:
    import trimesh
except ImportError:
    sys.exit("trimesh ausente: pip install --break-system-packages trimesh networkx")
out = sys.argv[1]
for f in sorted(glob.glob(os.path.join(out, "*.stl"))):
    m = trimesh.load(f)
    m.apply_translation(-m.bounds[0])          # apoia na mesa
    e = m.extents
    ok = all(v <= 256 for v in e)
    print(f"{os.path.basename(f)[:-4]:20s} {e[0]:6.1f} x {e[1]:6.1f} x {e[2]:6.1f} mm  "
          f"{'cabe na A1' if ok else 'NÃO CABE'}  estanque={m.is_watertight}")
    m.export(f[:-4] + ".3mf")
PY

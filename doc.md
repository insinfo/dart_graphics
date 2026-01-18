# Documentação

## Transform composition (Affine.multiply)

`Affine.multiply(m)` pode confundir quando você porta código.

Convenção de ponto (neste projeto):
- `x' = x*sx + y*shx + tx`
- `y' = x*shy + y*sy + ty`

Ordem ao aplicar em pontos:
- `(a.multiply(b))(p) == b(a(p))`  (b entra por último)

Isso impacta composição de CTM/TRM etc.

## Diferença de 1px / AA em bordas (ex.: Type3)

Na comparação com PNG do PDFBox (Java), pode sobrar ~1px em borda:
- cobertura/anti-alias (rasterizadores discordam em pixels de borda)
- float noise + `ceil()`/`floor()` expandindo 1px

Mitigação de float noise:
- `BasicGraphics2D.fillRect` faz snap perto de inteiros antes de `ceil/floor`.

Se ainda for só franja de AA:
- ajustar gamma do scanline rasterizer
- ou permitir margem pequena no golden de fixtures geométricos
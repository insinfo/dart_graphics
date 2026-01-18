# Documentação

## Transform composition (Affine.multiply)

`Affine.multiply(m)` pode confundir quando você porta código.

Convenção de ponto (neste projeto):
- `x' = x*sx + y*shx + tx`
- `y' = x*shy + y*sy + ty`

Ordem ao aplicar em pontos:
- `(a.multiply(b))(p) == b(a(p))`  (b entra por último)

Isso impacta composição de CTM/TRM etc.

### Regras AGG vs Dart

No AGG (C++), `translate/rotate/scale` são **pré‑multiplicações** do estado atual.
Na prática, a sequência chamada no código é aplicada **na mesma ordem** aos pontos.

Para manter compatibilidade com AGG (e PDFBox), no Dart:

- Use os métodos `Affine.translate/rotate/scale` (ou `Graphics2D.translate/rotate/scale`) diretamente.
- Evite montar matrizes manuais com `multiply(Affine.*)` se a intenção for igual ao AGG.

Implementação atual (Dart) segue o AGG:

- `Affine.rotate()` e `Affine.scale()` fazem a mesma matemática do AGG.
- `Graphics2D.translate/rotate/scale` chamam esses métodos.

Consequência prática:

- Para **rotacionar em torno do centro**, use:
	1) `translate(cx, cy)`
	2) `rotate(angle)`
	3) desenhe em torno da origem (ex.: retângulo centrado)
	4) `resetTransform()` ou `restore()`

Isso evita discrepância de `transform_rotate` (golden vs dart).

## Diferença de 1px / AA em bordas (ex.: Type3)

Na comparação com PNG do PDFBox (Java), pode sobrar ~1px em borda:
- cobertura/anti-alias (rasterizadores discordam em pixels de borda)
- float noise + `ceil()`/`floor()` expandindo 1px

Mitigação de float noise:
- `BasicGraphics2D.fillRect` faz snap perto de inteiros antes de `ceil/floor`.

Se ainda for só franja de AA:
- ajustar gamma do scanline rasterizer
- ou permitir margem pequena no golden de fixtures geométricos

## Texto (glyphs, gradiente, contadores)

Para texto, o rasterizador é sensível a:

- **Filling rule**: glyphs precisam de `even-odd` para preservar os “buracos”
	(ex.: `O`, `e`, `a`).
- **Baseline**: padrão deve ser `alphabetic`, igual ao AGG.
- **Fonte de geometria**: usar `GlyphVertexSource` evita distorções.

No Dart atual:

- `_drawTextInternal` usa `GlyphVertexSource` e aplica `even-odd` no rasterizador.
- `TextBaseline` default = `alphabetic`.

### Tolerância em golden para gradiente de texto

Mesmo com geometria igual, o raster pode variar levemente entre:
- FreeType (C++/AGG) e o pipeline puro Dart
- detalhes de AA/hinting

Por isso, o teste `text_gradient` aceita 2% de diferença, mantendo 1% nos demais.

Se for portar para `pdfbox_dart`, garanta:

- Usar `Graphics2D` com `TextBaseline.alphabetic`.
- Usar `GlyphVertexSource` (não converter glyphs manualmente por contornos).
- Aplicar `even-odd` apenas durante o desenho de glyphs e restaurar para `non-zero`.
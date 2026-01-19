# Dart Graphics - Auditoria de Implementação (lib/src/dart_graphics)

Data: 2026-01-18

## Escopo
Revisão de pendências de implementação (TODO/stub/Unimplemented/minimal) no diretório lib/src/dart_graphics. Também inclui observações de robustez do canvas.dart em relação ao graphics2D.dart.

## Resumo executivo
- Existem pontos com `UnimplementedError` em interpoladores e alguns fluxos de backend.
- O `RasterizerOutlineAA` depende de um `LineRenderer` com implementação mínima (semidots/pies aproximados).
- `BasicGraphics2D.drawLine` usa `ImageLineRenderer` para traços finos e `ProfileLineRenderer` com `LineProfileAA` para traços mais espessos.
- `ImageGraphicsBackend` agora suporta gradientes/patterns, diferença de clip e composição de layers com blend modes; ainda falta validar fidelidade completa e otimizações (bounds/float).
- `canvas.dart` está funcional para PNG/dataURL/blob, mas a documentação interna ainda menciona “not implemented” em `toBlob`.
- Goldens de testes foram consolidados em `resources/` (saídas temporárias permanecem em `test/tmp`).

## Achados por arquivo (pendências reais)

### 1) Interpoladores
- lib/src/dart_graphics/spans/span_interpolator_linear.dart
  - `localScale()` lança `UnimplementedError` para transforms não-`Affine`.
  - `SpanInterpolatorLinearFloat.localScale()` lança `UnimplementedError` para transforms não-`Affine`.

- lib/src/dart_graphics/spans/span_interpolator_persp.dart
  - OK após implementação de `transformer/setTransformer`.

- lib/src/dart_graphics/spans/span_subdiv_adaptor.dart
  - OK após implementação de `resynchronize`.

### 2) Máscara alpha (incompleto)
Implementado (sem pendências diretas).

### 3) Rasterizer outline
- lib/src/dart_graphics/rasterizer_outline_aa.dart
  - `LineRenderer` é abstrato. Há implementações mínimas em `outline_image_renderer.dart`.

- lib/src/dart_graphics/outline_image_renderer.dart
  - Implementação mínima de `semidot`/`pie` adicionada (aproximações).
  - `ProfileLineRenderer` é usado por `BasicGraphics2D.drawLine` para traços espessos.

### 4) Backend de gravação
- lib/src/dart_graphics/recording/image_graphics_backend.dart
  - Suporta `SolidPaint` e gradientes (linear/radial) e `ImagePaint` como pattern.
  - `saveLayer` agora compõe layers com `BlendModeLite` + opacidade e respeita `bounds`.
  - `clipPath` suporta `intersect` e `difference` (via máscara).
  - Testes básicos de `saveLayer`, gradiente e pattern adicionados.

### 5) Imagem e formatos
- lib/src/dart_graphics/image/image_buffer_float.dart
  - `Graphics2D` para float buffer agora expõe `ImageGraphics2D` (suporte básico, focado em `clear`).

- lib/src/dart_graphics/image/image_graphics_2d.dart
  - `Unsupported bit depth`/`Unsupported float bit depth` em alguns caminhos.

### 6) Canvas 2D
- lib/src/dart_graphics/canvas/canvas.dart
  - Comentário em `toBlob`: “not implemented”; mas o método já retorna bytes (funciona).
  - Cobertura de testes de API básica já existe (resize, saveAs, toDataURL, toBlob).

## Achados por arquivo (comentários de “not implemented” / TODOs)

- lib/src/dart_graphics/recording/image_graphics_backend.dart
  - “Other paints not implemented yet.”

- lib/src/dart_graphics/outline_image_renderer.dart
  - “Not implemented” em métodos específicos.

- lib/src/dart_graphics/canvas/canvas_rendering_context_2d.dart
  - Comentário: “Not implemented for DartGraphics” (feature não suportada no contexto 2D).

- lib/src/dart_graphics/image/image_sequence.dart
  - Referências a `ImageBuffer.cropToVisible` e `ImageBuffer.setAlpha` (ainda não implementados).

## Robustez: canvas.dart vs graphics2D.dart
- `DartGraphicsCanvas` usa `ImageBuffer` + `DartGraphicsCanvasRenderingContext2D`.
- `graphics2D.dart` é o core de renderização. O canvas é um wrapper simples.
- Robustez atual do canvas: OK para PNG/dataURL/blob e resize.
- Divergência: comentários antigos em canvas.dart não refletem o comportamento atual.

## Recomendações de implementação (prioridade)
1) **Outline rasterizer** (rasterizer_outline_aa + outline_image_renderer) — ainda é aproximação.
2) **ImageGraphicsBackend** — validar blend modes do PDF e otimizar limites de layer (bounds/recortes).
3) **ImageBufferFloat / ImageGraphics2D** — suportar float buffer e bit depth extras.

## Sugestões de testes adicionais (não implementados)
- Outline rasterizer: golden com linhas AA via renderer real.

---
Fundamental para continuar o porte do PDFBox (rendering) com fidelidade:

Soft mask / transparência em grupo
Java: SoftMask.java, GroupGraphics.java.
Em Dart: implementar pipeline completo em pdfbox_dart/lib/src/pdfbox/rendering/page_drawer.dart e backend com composição por máscara em dart_graphics/lib/src/dart_graphics/recording/image_graphics_backend.dart.
Sem isso, PDFs com transparência/SMask e grupos ficam errados.
Blend modes / composite
Java usa BlendComposite.
Dart precisa mapear BlendMode para todos os modos relevantes na renderização de PDF (multiply, screen, overlay, etc.) em dart_graphics/lib/src/dart_graphics/graphics2D.dart e no backend.
Clipping avançado
ClipOp além de intersect (ex: difference) ainda não.
Necessário para vários PDFs: dart_graphics/lib/src/dart_graphics/recording/image_graphics_backend.dart.
Shadings/patterns completos
Tiling/axial/radial shadings precisam cobertura total.
Java: TilingPaint.java, TilingPaintFactory.java, PageDrawer.java.
Dart: pdfbox_dart/lib/src/pdfbox/rendering/tiling_paint.dart, pdfbox_dart/lib/src/pdfbox/rendering/tiling_paint_factory.dart, pdfbox_dart/lib/src/pdfbox/rendering/page_drawer.dart.
Image masks / stencil masks
PDF imagem com máscara precisa de alpha mask sólida e aplicação correta.
Text rendering avançado (Type3/GSUB/GPOS)
Necessário para fidelidade tipográfica; ainda pode haver simplificações.
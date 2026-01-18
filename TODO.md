# TODO - Expandir `Graphics2D` para API completa

## Fase 1 — Estrutura e estados (base do Agg2D)
- [x] Criar tipos/enums equivalentes ao Agg2D: `LineJoin`, `LineCap`, `BlendMode`, `ImageFilter`, `ImageResample`, `GradientType`.
- [x] Adicionar estado gráfico em `Graphics2D`/`BasicGraphics2D`: cores de fill/stroke, alpha master, anti-alias gamma, blend mode, line width, join, cap.
- [x] Implementar stack de transformações (Affine) com `save/restore` e `resetTransform`.

## Fase 2 — Path API e desenho
- [x] Implementar path state (move/line/curve/arc/close) integrado a `VertexStorage`.
- [x] Adicionar `fillPath`/`strokePath` com `FillOnly`, `StrokeOnly`, `FillAndStroke`.
- [x] Adicionar helpers: `rect`, `roundedRect`, `ellipse`, `arc`.

## Fase 3 — Gradientes e padrões
- [x] Adicionar gradientes linear/radial com stops (SpanGradient).
- [x] Suporte a padrões (pattern image/texture).

## Fase 4 — Imagens
- [x] Suporte a drawImage com filtros e resample (equivalente Agg2D).
- [x] Ajustar `TransformQuality` e `ImageFilter`.

## Fase 5 — Texto
- [x] Integrar tipografia: fontes, cache e métricas básicas.
- [x] `drawText` com alinhamento e baseline.

## Fase 6 — Testes e validação
- [x] Criar testes unitários para API nova.
- [x] Goldens básicos para fill/stroke/gradientes.

## Fase 7 — Backend agnóstico (facilitar futuros renderizadores)
- [x] Command buffer (MVP): `DrawCommand` + `CommandBuffer` (record/playback).
- [x] Backend interface (MVP): `GraphicsBackend` (raster, SVG, PDF, etc.).
- [x] `Paint` unificado (MVP: solid/gradient/image).
- [x] `StrokeStyle` separado (cap/join/miter/dash).
- [x] `ClipStack` e `Layer` genéricos (begin/end).
- [x] `TextRun`/`GlyphRun` e layout para texto posicionável.
- [x] `Path` utils: bounds/flatten/copy (MVP).

## Fase 8 — Robustez e otimização
- [x] Substituir MVP por implementações robustas (clip/layer, text runs, command buffer)
- [x] `PathUtils`: boolean ops
- [x] `PathUtils`: simplify robusto (Douglas–Peucker)
- [x] `PathUtils`: flatten adaptativo (tolerância geométrica)
- [ ] Otimizar hot paths com benchmarks e perf regressions
	- [x] Adicionar benchmarks de `PathUtils` (flatten/simplify/boolean ops)
	- [x] Adicionar testes para `clipper` e `recording`
	- [x] Adicionar benchmarks de `CommandBuffer` (record/optimize)
	- [x] Adicionar benchmarks de `clipper` (boolean ops)
	- [x] Otimizar `CommandBuffer.optimize` (render stack O(1))
	- [x] Fast path `fillRect` em `BasicGraphics2D`
	- [x] Otimizar `_arcPath` (incremental trig)
	- [x] Otimizar Path2D arcs/ellipses (incremental trig)

---
## Progresso atual
- [x] Iniciar Fase 1: enums + estado base + transform stack.
- [x] Fase 2: path API + draw helpers.
- [x] Fase 3: gradientes + padrões.
- [x] Fase 4: drawImage + filtros/resample + TransformQuality.
- [x] Fase 5: texto (font state + alinhamento/baseline).
- [x] Fase 6: testes unitários + goldens básicos.
- [x] Fase 7: backend agnóstico e gravação de comandos.
- [ ] Fase 8: robustez e otimização.

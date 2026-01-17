# TODO - Expandir `Graphics2D` para API completa

## Fase 1 — Estrutura e estados (base do Agg2D)
- [ ] Criar tipos/enums equivalentes ao Agg2D: `LineJoin`, `LineCap`, `BlendMode`, `ImageFilter`, `ImageResample`, `GradientType`.
- [ ] Adicionar estado gráfico em `Graphics2D`/`BasicGraphics2D`: cores de fill/stroke, alpha master, anti-alias gamma, blend mode, line width, join, cap.
- [ ] Implementar stack de transformações (Affine) com `save/restore` e `resetTransform`.

## Fase 2 — Path API e desenho
- [ ] Implementar path state (move/line/curve/arc/close) integrado a `VertexStorage`.
- [ ] Adicionar `fillPath`/`strokePath` com `FillOnly`, `StrokeOnly`, `FillAndStroke`.
- [ ] Adicionar helpers: `rect`, `roundedRect`, `ellipse`, `arc`.

## Fase 3 — Gradientes e padrões
- [ ] Adicionar gradientes linear/radial com stops (SpanGradient).
- [ ] Suporte a padrões (pattern image/texture).

## Fase 4 — Imagens
- [ ] Suporte a drawImage com filtros e resample (equivalente Agg2D).
- [ ] Ajustar `TransformQuality` e `ImageFilter`.

## Fase 5 — Texto
- [ ] Integrar tipografia: fontes, cache e métricas básicas.
- [ ] `drawText` com alinhamento e baseline.

## Fase 6 — Testes e validação
- [ ] Criar testes unitários para API nova.
- [ ] Goldens básicos para fill/stroke/gradientes.

---

## Progresso atual
- [ ] Iniciar Fase 1: enums + estado base + transform stack.

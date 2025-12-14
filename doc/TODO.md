# TODO - Porte da Biblioteca AGG e Typography para Dart

## Status Geral
**Projeto:** Porte da biblioteca AGG e Typography (agg-sharp) de C# para Dart  
**Data de Início:** 07 de Novembro de 2025  
**Última Atualização:** 14 de Dezembro de 2025  
**Status Atual:** Em Progresso - Fase 3 (AGG Core & Typography) - ~98%

### ✅ Itens Portados Recentemente (14/12/2025 - sessão atual):
- **Novos Testes Implementados:**
  - `text_rendering_test.dart` - Testes de renderização de texto (17 testes)
  - `complex_shapes_test.dart` - Testes de formas complexas: star, spiral, bezier, pie, arrow, heart (14 testes)
  - `gradient_effects_test.dart` - Testes de gradientes, Gouraud shading, patterns, color space (16 testes)
- Verificação e atualização do TODO.md:
  - `blender_bgra_exact_copy.dart`, `blender_bgra_half_half.dart`, `blender_poly_color_premult_bgra.dart` - já existiam
  - `avar.dart`, `cvar.dart` - tabelas de variação já existiam
  - `feature_info.dart` - registro de features OpenType já existia
  - `AttachmentListTable`, `LigCaretList`, `ScriptLang` - já estavam em gdef.dart e script_lang.dart
  - `Geometry.cs` (GlyphPointF) - já estava em glyph.dart
- `bitmap_font_glyph_source.dart` - Helper para fontes bitmap (CBLC/CBDT)
- **Tabelas já implementadas confirmadas:**
  - `hdmx.dart` (HorizontalDeviceMetrics) - totalmente implementado
  - `vdmx.dart` (VerticalDeviceMetrics) - totalmente implementado
  - `ltsh.dart` (LinearThreshold) - totalmente implementado
- **Total de Testes:** 367 passando

### ✅ Itens Portados (13/12/2025 - sessões anteriores):
- `script_lang.dart` - Sistema de scripts/idiomas para OpenType (UnicodeLangBits enum, ScriptLangs registry)
- `blender_rgb.dart` - Blenders RGB 24-bit (BlenderBgr, BlenderRgb24, BlenderGammaBgr, BlenderPreMultBgr)
- `image_tga_io.dart` - I/O para formato TGA (load/save, RLE compression support)

### ✅ Itens Portados (12/12/2025 - sessões anteriores):
- `blender_bgra_float.dart` - Blender float BGRA e BlenderPreMultBgraFloat
- `blender_gamma_bgra.dart` - Blender com correção gamma (BlenderGammaBgra, BlenderGammaRgba)
- `agg_span_image_filter_gray.dart` - Filtros de imagem grayscale (NN, Bilinear, Clip, Generic, 2x2)
- `agg_span_image_filter_rgb.dart` - Filtros de imagem RGB (NN, Bilinear, Clip, Generic, Resample)
- `i_vertex_source_proxy.dart` - Interface para proxies de vertex source
- `vertex_source_io.dart` - Load/Save de paths para arquivos
- `text_wrapping.dart` - Quebra de texto (EnglishTextWrapping, BreakAnywhereTextWrapping)
- `image_graphics_2d.dart` - Contexto gráfico 2D para renderização em imagem

### ✅ Itens Portados (11/12/2025 - sessões anteriores):
- `vertex_source_glyph_translator.dart` - Bridge Typography→AGG
- `agg_color_gray.dart` - Cores grayscale 8/16-bit
- `quicksort.dart` - QuickSort para células AA
- `blender_gray.dart` - Blender grayscale (BlenderGray, BlenderGrayFromRed, BlenderGrayClampedMax)
- `i_vertex_source_extensions.dart` - GetBounds, GetPointAtRatio, GetXAtY, GetCommandHint, TransformAffine
- `styled_type_face.dart` - TypeFace wrapper com sizing/scaling e underline
- `type_face_printer.dart` - Renderização de texto como IVertexSource completo
- `agg_context.dart` - Configuração global e defaults (AggContext, OSType, PlatformConfig)

---

## 📋 Instruções de Trabalho

```
- Continue portando C:\MyDartProjects\agg\agg-sharp\agg para Dart
- Continue portando C:\MyDartProjects\agg\agg-sharp\Typography para Dart
- Porte testes de C:\MyDartProjects\agg\agg-sharp\Tests para Dart
- Inspire-se nos testes de C:\MyDartProjects\agg\agg-rust\tests
- Use fontes de teste em C:\MyDartProjects\agg\resources\fonts
- Use `dart analyze` para verificar código
- Use `rg` (ripgrep) para buscar no código fonte
- Use `magick.exe` ou `compare.exe` para comparação de imagens
```

---

## 📊 Análise Comparativa Detalhada (13/12/2025)

### AGG Core - Raiz (`agg-sharp/agg/*.cs`)

| Arquivo C# | Arquivo Dart | Status | Prioridade |
|------------|--------------|--------|------------|
| agg_clip_liang_barsky.cs | agg_clip_liang_barsky.dart | ✅ Portado | - |
| agg_color_gray.cs | agg_color_gray.dart | ✅ Portado | - |
| agg_dda_line.cs | agg_dda_line.dart | ✅ Portado | - |
| agg_gamma_functions.cs | agg_gamma_functions.dart | ✅ Portado | - |
| agg_image_filters.cs | agg_image_filters.dart | ✅ Portado | - |
| agg_line_aa_basics.cs | line_aa_basics.dart | ✅ Portado | - |
| agg_math.cs | agg_math.dart | ✅ Portado | - |
| agg_pattern_filters_rgba.cs | agg_pattern_filters_rgba.dart | ✅ Portado | - |
| agg_rasterizer_cells_aa.cs | rasterizer_cells_aa.dart | ✅ Portado | - |
| agg_rasterizer_compound_aa.cs | rasterizer_compound_aa.dart | ✅ Portado | - |
| agg_rasterizer_outline_aa.cs | rasterizer_outline_aa.dart | ✅ Portado | - |
| agg_scanline_bin.cs | scanline_bin.dart | ✅ Portado | - |
| agg_simul_eq.cs | agg_simul_eq.dart | ✅ Portado | - |
| agg_VertexSequence.cs | vertex_sequence.dart | ✅ Portado | - |
| DebugLogger.cs | ❌ Não existe | ⚪ Não necessário | Baixa |
| FloodFiller.cs | flood_fill.dart | ✅ Portado | - |
| GammaLookUpTable.cs | gamma_lookup_table.dart | ✅ Portado | - |
| Graphics2D.cs | graphics2D.dart | ⚠️ Parcial | 🟡 Média |
| ImageLineRenderer.cs | image_line_renderer.dart | ✅ Portado | - |
| OutlineRenderer.cs | outline_renderer.dart | ✅ Portado | - |
| quicksort.cs | quicksort.dart | ✅ Portado | - |
| RasterBufferAccessors.cs | raster_buffer_accessors.dart | ✅ Portado | - |
| ReferenceEqualityComparer.cs | ❌ Não existe | ⚪ Não necessário | - |
| ScanlineRasterizer.cs | scanline_rasterizer.dart | ✅ Portado | - |
| ScanlineRenderer.cs | scanline_renderer.dart | ✅ Portado | - |
| ShapePath.cs | path_commands.dart | ✅ Portado | - |
| StringEventArgs.cs | ❌ Não existe | ⚪ Não necessário | - |
| Util.cs | util.dart | ⚠️ Parcial | 🟡 Média |
| VectorClipper.cs | vector_clipper.dart | ✅ Portado | - |

---

### AGG Image (`agg-sharp/agg/Image/*.cs`)

| Arquivo C# | Arquivo Dart | Status | Prioridade |
|------------|--------------|--------|------------|
| agg_alpha_mask_u8.cs | alpha_mask.dart | ✅ Portado | - |
| AlphaMaskAdaptor.cs | alpha_mask_adaptor.dart | ✅ Portado | - |
| ClippingProxy.cs | image_clipping_proxy.dart | ✅ Portado | - |
| IImage.cs | iimage.dart | ✅ Portado | - |
| ImageBuffer.cs | image_buffer.dart | ⚠️ Parcial (~295 vs ~1485 linhas) | 🟡 Média |
| ImageBufferFloat.cs | image_buffer_float.dart | ⚠️ Parcial (~247 vs ~953 linhas) | 🟡 Média |
| ImageGraphics2D.cs | image_graphics_2d.dart | ✅ Portado | - |
| ImageProxy.cs | image_proxy.dart | ✅ Portado | - |
| ImageSequence.cs | image_sequence.dart | ⚠️ Parcial | 🟢 Baixa |
| ImageTgaIO.cs | image_tga_io.dart | ✅ Portado | - |
| RecursiveBlur.cs | recursive_blur.dart | ⚠️ Parcial (~205 vs ~1279 linhas) | 🟡 Média |
| Transposer.cs | format_transposer.dart | ✅ Portado | - |

---

### AGG Image Blenders (`agg-sharp/agg/Image/Blenders/*.cs`)

| Arquivo C# | Arquivo Dart | Status | Prioridade |
|------------|--------------|--------|------------|
| BlenderBase8888.cs | ❌ (inline) | ⚡ N/A | - |
| BlenderBaseBGRAFloat.cs | ❌ (inline) | ⚡ N/A | - |
| BlenderBGRA.cs | blender_bgra.dart | ✅ Portado | - |
| BlenderBGRAExactCopy.cs | blenders/blender_bgra_exact_copy.dart | ✅ Portado | - |
| BlenderBGRAFloat.cs | blender_bgra_float.dart | ✅ Portado | - |
| BlenderBGRAHalfHalf.cs | blenders/blender_bgra_half_half.dart | ✅ Portado | - |
| BlenderExtensions.cs | (em interface) | ✅ Portado | - |
| BlenderGammaBGRA.cs | blender_gamma_bgra.dart | ✅ Portado | - |
| BlenderPolyColorPreMultBGRA.cs | blenders/blender_poly_color_premult_bgra.dart | ✅ Portado | - |
| BlenderPreMultBGRA.cs | blender_premult_bgra.dart | ✅ Portado | - |
| BlenderPreMultBGRAFloat.cs | blender_bgra_float.dart | ✅ Portado | - |
| BlenderRGBA.cs | blender_rgba.dart | ✅ Portado | - |
| Gray.cs | blender_gray.dart | ✅ Portado | - |
| IRecieveBlenderByte.cs | (em interface) | ✅ Portado | - |
| IRecieveBlenderFloat.cs | blender_rgba_float.dart | ✅ Portado | - |
| rgb.cs | blenders/blender_rgb.dart | ✅ Portado | - |
| rgba.cs | rgba.dart | ⚠️ Parcial | 🟡 Média |

---

### AGG ThresholdFunctions (`agg-sharp/agg/Image/ThresholdFunctions/*.cs`)

| Arquivo C# | Arquivo Dart | Status |
|------------|--------------|--------|
| IThresholdFunction.cs | threshold_functions.dart | ✅ Portado |
| AlphaThresholdFunction.cs | threshold_functions.dart | ✅ Portado |
| HueThresholdFunction.cs | threshold_functions.dart | ✅ Portado |
| MapOnMaxIntensity.cs | threshold_functions.dart | ✅ Portado |
| SilhouetteThresholdFunction.cs | threshold_functions.dart | ✅ Portado |

---

### AGG Transform (`agg-sharp/agg/Transform/*.cs`)

| Arquivo C# | Arquivo Dart | Status |
|------------|--------------|--------|
| Affine.cs | affine.dart | ✅ Portado |
| Bilinear.cs | bilinear.dart | ✅ Portado |
| ITransform.cs | i_transform.dart | ✅ Portado |
| Perspective.cs | perspective.dart | ✅ Portado |
| Viewport.cs | viewport.dart | ✅ Portado |

---

### AGG VertexSource (`agg-sharp/agg/VertexSource/*.cs`)

| Arquivo C# | Arquivo Dart | Status | Prioridade |
|------------|--------------|--------|------------|
| agg_curves.cs | agg_curves.dart | ✅ Portado | - |
| agg_gsv_text.cs | gsv_text.dart | ✅ Portado | - |
| agg_span_gouraud.cs | span_gouraud.dart | ✅ Portado | - |
| agg_span_gouraud_rgba.cs | span_gouraud_rgba.dart | ✅ Portado | - |
| ApplyTransform.cs | apply_transform.dart | ✅ Portado | - |
| Arc.cs | arc.dart | ✅ Portado | - |
| ConnectedPaths.cs | connected_paths.dart | ✅ Portado | - |
| Contour.cs | contour.dart | ✅ Portado | - |
| ContourGenerator.cs | contour_generator.dart | ✅ Portado | - |
| Ellipse.cs | ellipse.dart | ✅ Portado | - |
| FlattenCurve.cs | flatten_curve.dart | ✅ Portado | - |
| IGenerator.cs | igenerator.dart | ✅ Portado | - |
| IVertexSource.cs | ivertex_source.dart | ✅ Portado | - |
| IVertexSourceExtensions.cs | i_vertex_source_extensions.dart | ✅ Portado | - |
| **IVertexSourceProxy.cs** | i_vertex_source_proxy.dart | ✅ Portado | - |
| JoinPaths.cs | join_paths.dart | ✅ Portado | - |
| ReversePath.cs | reverse_path.dart | ✅ Portado | - |
| RoundedRect.cs | rounded_rect.dart | ✅ Portado | - |
| Stroke.cs | stroke.dart | ✅ Portado | - |
| StrokeGenerator.cs | stroke_generator.dart | ✅ Portado | - |
| StrokeMath.cs | stroke_math.dart | ✅ Portado | - |
| VertexData.cs | vertex_data.dart | ✅ Portado | - |
| VertexSourceAdapter.cs | vertex_source_adapter.dart | ✅ Portado | - |
| VertexSourceExtensionMethods.cs | ❌ Não existe | ⚠️ Parcial | 🟡 Média |
| **VertexSourceIO.cs** | vertex_source_io.dart | ✅ Portado | - |
| VertexSourceLegacySupport.cs | vertex_source_legacy_support.dart | ✅ Portado | - |
| VertexStorage.cs | vertex_storage.dart | ⚠️ Parcial (~156 vs ~1148 linhas) | 🟡 Média |

#### O que falta em `IVertexSourceExtensions.dart` (398 linhas):
- `GetBounds()` - calcula limites do path
- `GetPositionAt()` - ponto em determinada proporção
- `GetWeightedCenter()` - centro ponderado
- `ContainsPoint()` - verifica se contém ponto
- `PolygonArea()` - área do polígono
- `Centroid()` - centróide

#### O que falta em `VertexStorage.dart`:
- `StartNewPath()` - iniciar novo sub-path
- `AddPath()` - adicionar outro path
- `transform_all_paths()` - transformar todos paths
- `flip_x()`, `flip_y()` - espelhamento
- `arrange_orientations()` - orientação de polígonos
- `reverse_path()` - reverter path específico
- `perceive_polygon_orientation()` - detectar orientação
- `invert_polygon()` - inverter polígono

---

### AGG Spans (`agg-sharp/agg/Spans/*.cs`)

| Arquivo C# | Arquivo Dart | Status | Prioridade |
|------------|--------------|--------|------------|
| agg_span_allocator.cs | span_allocator.dart | ✅ Portado | - |
| agg_span_gradient.cs | span_gradient.dart | ⚠️ Parcial | 🟡 Média |
| agg_span_image_filter.cs | agg_span_image_filter.dart | ✅ Portado | - |
| agg_span_image_filter_gray.cs | agg_span_image_filter_gray.dart | ✅ Portado | - |
| agg_span_image_filter_rgb.cs | agg_span_image_filter_rgb.dart | ✅ Portado | - |
| agg_span_image_filter_rgba.cs | agg_span_image_filter_rgba.dart | ⚠️ Parcial | 🟡 Média |
| agg_span_interpolator_linear.cs | agg_span_interpolator_linear.dart | ✅ Portado | - |
| agg_span_interpolator_persp.cs | agg_span_interpolator_persp.dart | ✅ Portado | - |
| agg_span_subdiv_adaptor.cs | agg_span_subdiv_adaptor.dart | ✅ Portado | - |

#### O que falta em `span_gradient.dart`:
- Interfaces `IGradientFunction` e `IColorFunction`
- Funções de gradiente:
  - `gradient_radial_focus` (gradientes com ponto focal)
  - `gradient_conic` (gradientes côniços/angulares)
  - `gradient_circle`, `gradient_radial_d`
  - `gradient_x`, `gradient_y`, `gradient_diamond`
  - `gradient_xy`, `gradient_sqrt_xy`
- Adaptadores: `gradient_repeat_adaptor`, `gradient_reflect_adaptor`, `gradient_clamp_adaptor`

---

### AGG Interfaces (`agg-sharp/agg/Interfaces/*.cs`)

| Arquivo C# | Arquivo Dart | Status |
|------------|--------------|--------|
| **IAscendable.cs** | ❌ Não existe | ⚪ Baixa prioridade |
| IColorType.cs | icolor_type.dart | ✅ Portado |
| IMarkers.cs | imarkers.dart | ✅ Portado |
| IScanline.cs | iscanline.dart | ✅ Portado |
| IVertexDest.cs | ivertex_dest.dart | ✅ Portado |

---

### AGG RasterizerScanline (`agg-sharp/agg/RasterizerScanline/*.cs`)

| Arquivo C# | Arquivo Dart | Status |
|------------|--------------|--------|
| agg_scanline_p.cs | scanline_packed8.dart | ✅ Portado |
| agg_scanline_u.cs | scanline_unpacked8.dart | ✅ Portado |

---

### AGG Font (`agg-sharp/agg/Font/*.cs`)

| Arquivo C# | Arquivo Dart | Status | Prioridade |
|------------|--------------|--------|------------|
| LiberationSansBoldFont.cs | ❌ Não existe | ⚪ Baixa | - |
| LiberationSansFont.cs | ❌ Não existe | ⚪ Baixa | - |
| StyledTypeFace.cs | styled_type_face.dart | ✅ Portado | - |
| **TextWrapping.cs** | text_wrapping.dart | ✅ Portado | - |
| TypeFace.cs | typeface.dart (Typography) | ✅ Portado | - |
| TypeFacePrinter.cs | type_face_printer.dart | ✅ Portado | - |
| VertexSourceGlyphTranslator.cs | vertex_source_glyph_translator.dart | ✅ Portado | - |

#### O que falta em `TextWrapping.dart`:
- Quebra automática de texto
- Cálculo de largura máxima
- Suporte a hifenização

---

### AGG Platform (`agg-sharp/agg/Platform/*.cs`)

| Arquivo C# | Arquivo Dart | Status | Prioridade |
|------------|--------------|--------|------------|
| AggContext.cs | agg_context.dart | ✅ Portado | - |
| FileDialogs/* | ❌ Não existe | ⚪ Não ira ser Portando | - |
| Providers/* | ❌ Não existe | ⚪ Baixa | - |

---

### AGG Helpers (`agg-sharp/agg/Helpers/*.cs`)

| Arquivo C# | Arquivo Dart | Status | Prioridade |
|------------|--------------|--------|------------|
| DumpCallStackIfSlow.cs | ❌ Não existe | ⚪ Debug | - |
| HashGenerator.cs | ❌ Não existe | ⚪ Baixa | - |
| Parallel.cs | ❌ Não existe | ⚪ Média | - |
| PluginFinder.cs | ❌ Não existe | ⚪ .NET específico | - |
| QuickTimer.cs | ❌ Não existe | ⚪ Debug | - |
| ReportTimer.cs | ❌ Não existe | ⚪ Debug | - |
| RootedObjectEventHandler.cs | ❌ Não existe | ⚪ .NET específico | - |
| StatisticsTracker.cs | ❌ Não existe | ⚪ Debug | - |
| StringHelper.cs | ❌ Não existe | ⚪ Baixa | - |
| TraceTiming.cs | ❌ Não existe | ⚪ Debug | - |

---

## 📝 Typography - Análise Detalhada

### Typography OpenFont Tables Básicas

| Arquivo C# | Arquivo Dart | Status |
|------------|--------------|--------|
| CharacterMap.cs | ❌ (em cmap.dart) | ✅ Integrado |
| Cmap.cs | cmap.dart | ✅ Portado |
| Head.cs | head.dart | ✅ Portado |
| HorizontalHeader.cs | hhea.dart | ✅ Portado |
| HorizontalMetrics.cs | hmtx.dart | ✅ Portado |
| MaxProfile.cs | maxp.dart | ✅ Portado |
| NameEntry.cs | name_entry.dart | ✅ Portado |
| OS2.cs | os2.dart | ✅ Portado |
| Post.cs | post.dart | ✅ Portado |
| TableEntry.cs | table_entry.dart | ✅ Portado |
| Utils.cs | utils.dart | ✅ Portado |

### Typography OpenFont Tables.AdvancedLayout

| Arquivo C# | Arquivo Dart | Status | Prioridade |
|------------|--------------|--------|------------|
| AttachmentListTable.cs | gdef.dart (AttachmentListTable) | ✅ Portado | - |
| Base.cs | base.dart | ✅ Portado | - |
| ClassDefTable.cs | class_def_table.dart | ✅ Portado | - |
| COLR.cs | colr.dart | ✅ Portado | - |
| CoverageTable.cs | coverage_table.dart | ✅ Portado | - |
| CPAL.cs | cpal.dart | ✅ Portado | - |
| FeatureInfo.cs | feature_info.dart | ✅ Portado | - |
| FeatureList.cs | feature_list.dart | ✅ Portado | - |
| GDEF.cs | gdef.dart | ✅ Portado | - |
| GlyphShapingTableEntry.cs | glyph_shaping_table_entry.dart | ✅ Portado | - |
| GPOS.cs | gpos.dart | ✅ Portado | - |
| GPOS.Others.cs | gpos.dart (parte de) | ✅ Portado | - |
| GSUB.cs | gsub.dart | ✅ Portado | - |
| IGlyphIndexList.cs | i_glyph_index_list.dart | ✅ Portado | - |
| JustificationTable.cs | jstf.dart | ✅ Portado | - |
| LigatureCaretListTable.cs | gdef.dart (LigCaretList) | ✅ Portado | - |
| MathTable.cs | math.dart | ✅ Portado | - |
| ScriptLang.cs | script_lang.dart | ✅ Portado | - |
| ScriptList.cs | script_list.dart | ✅ Portado | - |
| ScriptTable.cs | script_table.dart | ✅ Portado | - |

### Typography OpenFont Tables.TrueType

| Arquivo C# | Arquivo Dart | Status |
|------------|--------------|--------|
| Cvt_Programs.cs | cvt.dart, fpgm.dart, prep.dart | ✅ Portado (dividido) |
| Gasp.cs | gasp.dart | ✅ Portado |
| Glyf.cs | glyf.dart | ✅ Portado |
| GlyphLocations.cs | loca.dart | ✅ Portado |

### Typography OpenFont Tables.BitmapAndSvgFonts

| Arquivo C# | Arquivo Dart | Status | Prioridade |
|------------|--------------|--------|------------|
| BitmapFontGlyphSource.cs | bitmap_font_glyph_source.dart | ⚠️ Stub | 🟢 Baixa |
| BitmapFontsCommon.cs | bitmap/bitmap_common.dart | ✅ Portado | - |
| CBDT.cs | cbdt.dart | ✅ Portado | - |
| CBLC.cs | cblc.dart | ✅ Portado | - |
| EBDT.cs | ebdt.dart | ✅ Portado | - |
| EBLC.cs | eblc.dart | ✅ Portado | - |
| EBSC.cs | ❌ Não existe | ⚪ Stub em C# | 🟢 Baixa |
| SvgTable.cs | svg_table.dart | ✅ Portado | - |

### Typography OpenFont Tables.CFF

| Arquivo C# | Arquivo Dart | Status | Prioridade |
|------------|--------------|--------|------------|
| CFF.cs | cff/cff_parser.dart | ✅ Portado | - |
| CffEvaluationEngine.cs | cff/cff_evaluation_engine.dart | ✅ Portado | - |
| CFFTable.cs | cff/cff_table.dart | ✅ Portado | - |
| Type2CharStringParser.cs | cff/type2_charstring_parser.dart | ✅ Portado | - |
| Type2InstructionCompacter.cs | ❌ Não existe | ⚪ Baixa prioridade | 🟢 Baixa |

### Typography OpenFont Tables.Others

| Arquivo C# | Arquivo Dart | Status | Prioridade |
|------------|--------------|--------|------------|
| HorizontalDeviceMetrics.cs | ❌ Não existe | ⚪ Stub em C# | 🟢 Baixa |
| Kern.cs | kern.dart | ✅ Portado | - |
| LinearThreashold.cs | ❌ Não existe | ⚪ Stub em C# | 🟢 Baixa |
| Merge.cs | ❌ Não existe | ⚪ Stub em C# | 🟢 Baixa |
| Meta.cs | ❌ Não existe | ⚪ Stub em C# | 🟢 Baixa |
| STAT.cs | variations/stat.dart | ✅ Portado | - |
| VerticalDeviceMetrics.cs | ❌ Não existe | ⚠️ Parcial em C# | 🟢 Baixa |
| VerticalMetrics.cs | vmtx.dart | ✅ Portado | - |
| VerticalMetricsHeader.cs | vhea.dart | ✅ Portado | - |

### Typography OpenFont Tables.Variations

| Arquivo C# | Arquivo Dart | Status | Prioridade |
|------------|--------------|--------|------------|
| AVar.cs | variations/avar.dart | ✅ Portado | - |
| Common.ItemVariationStore.cs | variations/item_variation_store.dart | ✅ Portado | - |
| Common.TupleVariationStore.cs | variations/tuple_variation.dart | ✅ Portado | - |
| CVar.cs | variations/cvar.dart | ✅ Portado | - |
| FVar.cs | variations/fvar.dart | ✅ Portado | - |
| GVar.cs | variations/gvar.dart | ✅ Portado | - |
| HVar.cs | variations/hvar.dart | ✅ Portado | - |
| MVar.cs | variations/mvar.dart | ✅ Portado | - |
| VVar.cs | variations/vvar.dart | ✅ Portado | - |

### Typography TrueType Interpreter

| Arquivo C# | Arquivo Dart | Status |
|------------|--------------|--------|
| TrueTypeInterpreter.cs | true_type_interpreter.dart | ✅ Portado |
| InvalidFontException.cs | exceptions.dart | ✅ Portado |

**Extras em Dart:** execution_stack.dart, graphics_state.dart, instruction_stream.dart, opcodes.dart, zone.dart

### Typography WebFont

| Arquivo C# | Arquivo Dart | Status |
|------------|--------------|--------|
| Woff2Reader.cs | woff2_reader.dart | ✅ Portado |
| WoffReader.cs | woff_reader.dart | ✅ Portado |

**Extras em Dart:** woff2_utils.dart

### Typography GlyphLayout

| Arquivo C# | Arquivo Dart | Status | O que falta |
|------------|--------------|--------|-------------|
| GlyphIndexList.cs | glyph_index_list.dart | ✅ Portado | - |
| GlyphLayout.cs | glyph_layout.dart | ⚠️ Parcial | `NotFoundGlyphCallback`, `GenerateGlyphPlan` iterator |
| GlyphPosition.cs | glyph_set_position.dart | ✅ Portado | - |
| GlyphSubstitution.cs | glyph_substitution.dart | ⚠️ Parcial | `GetAssociatedGlyphIndex()` extension |
| MeasureStringBox.cs | (em pixel_scale_extensions.dart) | ✅ Portado | - |
| PixelScaleLayoutExtensions.cs | pixel_scale_extensions.dart | ⚠️ Parcial | Debug methods |
| UserCharToGlyphIndexMap.cs | user_char_to_glyph_index_map.dart | ✅ Portado | - |

### Typography OpenFont Raiz

| Arquivo C# | Arquivo Dart | Status | O que falta |
|------------|--------------|--------|-------------|
| Typeface.cs | typeface.dart | ⚠️ Parcial (~65%) | `ReadSvgContent`, `ReadBitmapContent`, `ReadCff1GlyphData`, `ReadCff2GlyphData`, `HasMathTable`, extensions |
| Glyph.cs | glyph.dart | ⚠️ Parcial (~80%) | Bounds atualizáveis para transformações, MathGlyphInfo |
| Geometry.cs | glyph.dart (GlyphPointF) | ✅ Portado | - |
| IGlyphTranslator.cs | i_glyph_translator.dart | ⚠️ Parcial (~25%) | `GlyphTranslatorToPath` (~350 linhas) |
| Bounds.cs | (em utils.dart) | ✅ Portado | - |
| OpenFontReader.cs | open_font_reader.dart | ✅ Portado | - |

---

## 📊 Testes - Análise Comparativa

### Testes C# (`agg-sharp/Tests/Agg.Tests/Agg`)

| Arquivo C# | Método de Teste | Status Dart |
|------------|-----------------|-------------|
| FontTests.cs | `DrawStringWithCarriageReturn` | ❌ Não existe |
| FontTests.cs | `TextWrapingTests` | ❌ Não existe |
| ImageTests.cs | `ColorToFromHtml` | ✅ `primitives_test.dart` |
| ImageTests.cs | `ClearImageBuffer` | ✅ `image_buffer_test.dart` |
| ImageTests.cs | `ImageFindInImage` | ✅ `image_buffer_test.dart` |
| IVertexSourceTests.cs | `CharacterBoundsAreCorrectForTestData` | ❌ Não existe |
| IVertexSourceTests.cs | `SimpleSquareOnePolygon` | ⚠️ Parcial |
| IVertexSourceTests.cs | `MoveToCreatesNewPolygons` | ❌ Não existe |
| IVertexSourceTests.cs | `SquareWithEllipseTwoPolygons` | ❌ Não existe |
| IVertexSourceTests.cs | `PathDFromSvgParse` | ✅ `svg_parser_test.dart` |
| IVertexSourceTests.cs | `ThreeShapesThreePolygons` | ❌ Não existe |
| SimpleTests.cs | `JsonSerializeDeserialize` | ❌ Não existe |
| SimpleTests.cs | `ParseDoubleDoesNotFail` | ❌ Não existe |
| SimpleTests.cs | `HashCodeConsistent` | ❌ Não existe |

### Testes C# (`agg-sharp/Tests/Agg.Tests/Other`)

| Arquivo C# | Método de Teste | Status Dart |
|------------|-----------------|-------------|
| AffineTests.cs | `InverseWorksCorrectly` | ❌ Não existe |
| AffineTests.cs | `TranslateWorksCorrectly` | ❌ Não existe |
| AggDrawingTests.cs | `DrawCircle` | ⚠️ Parcial em graphics2d_test.dart |
| AggDrawingTests.cs | `DrawCurve3` | ❌ Não existe |
| AggDrawingTests.cs | `DrawCurve4` | ❌ Não existe |
| AggDrawingTests.cs | `DrawText` | ❌ Não existe |
| AggDrawingTests.cs | `DrawRoundedRect` | ⚠️ Parcial em rounded_rect_test.dart |
| ClipperTests.cs | `SimplifyClosedPolygon` | ❌ Não existe |
| TesselatorTests.cs | (múltiplos casos) | ❌ Não existe |
| Vector2Tests.cs | `ArithmaticOperations` | ❌ Não existe |
| Vector2Tests.cs | `LengthAndNormalize` | ❌ Não existe |
| Vector2Tests.cs | `PositionAlongPolygon` | ❌ Não existe |
| Vector2Tests.cs | `ScalarMultAndDivide` | ❌ Não existe |
| Vector2Tests.cs | `Cross2Vs3Equivalence` | ❌ Não existe |
| Vector2Tests.cs | `DotProductTest` | ❌ Não existe |
| Vector2Tests.cs | `LengthAndDistance` | ❌ Não existe |
| Vector3Tests.cs | `ArithmaticOperations` | ❌ Não existe |
| Vector3Tests.cs | `ScalarMultiply` | ❌ Não existe |
| Vector3Tests.cs | `ScalarDivision` | ❌ Não existe |
| Vector3Tests.cs | `DotProduct` | ❌ Não existe |
| Vector3Tests.cs | `Cross` | ❌ Não existe |
| Vector3Tests.cs | `Normalize` | ❌ Não existe |
| VectorMathTests.cs | `EasingFunctions` | ❌ Não existe |
| VectorMathTests.cs | `AngleCalculations` | ❌ Não existe |
| VectorMathTests.cs | `DistanceFromLineSegment` | ❌ Não existe |
| VectorMathTests.cs | `WorldView` (10+ testes) | ❌ Não existe |

### Testes Rust (`agg-rust/tests`)

| Arquivo Rust | Status Dart | Prioridade |
|--------------|-------------|------------|
| aa_test.rs | ✅ aa_test.dart | - |
| component_rendering_*.rs | ✅ component_rendering_test.dart | - |
| lion.rs, lion_cw.rs, lion_cw_aa.rs | ✅ lion_test.dart | - |
| lion_outline.rs, lion_outline_width1.rs | ✅ lion_test.dart | - |
| outline.rs, outline_aa.rs | ✅ outline_aa_test.dart | - |
| rasterizers.rs, rasterizers2.rs | ✅ rasterizers_test.dart | - |
| rounded_rect.rs | ✅ rounded_rect_test.dart | - |
| t00_example.rs | ✅ (coberto) | - |
| t01_rendering_buffer.rs | ✅ (coberto) | - |
| t02_pixel_formats.rs | ✅ pixel_formats_test.dart | - |
| t03/04/05_solar_spectrum*.rs | ✅ solar_spectrum_test.dart | - |
| t21_line_join.rs | ✅ line_join_test.dart | - |
| t22_inner_join.rs | ✅ inner_join_test.dart | - |
| **t23_font.rs** | ❌ Não existe | 🟡 Média |
| **lion_cw_aa_srgba.rs** | ❌ Não existe (Srgba8) | 🟡 Média |
| **lion_png.rs** | ⚠️ Parcial | 🟢 Baixa |
| alpha_mask.rs, alpha_mask2.rs | ⚪ Vazios em Rust | - |
| circles.rs | ⚪ Vazio em Rust | - |
| conv_dash_marker.rs | ⚪ Vazio em Rust | - |
| conv_stroke.rs | ⚪ Vazio em Rust | - |
| freetype_test.rs | ⚪ Vazio em Rust | - |
| gouraud.rs | ⚪ Vazio em Rust (✅ Dart tem) | - |
| image1.rs, image_alpha.rs | ⚪ Vazios em Rust | - |
| image_filters.rs, image_transforms.rs | ⚪ Vazios em Rust | - |
| pattern_fill.rs | ⚪ Vazio em Rust | - |
| polymorphic_renderer.rs | ⚪ Vazio em Rust | - |
| raster_text.rs | ⚪ Vazio em Rust | - |
| simple_blur.rs | ⚪ Vazio em Rust (✅ Dart tem) | - |
| trans_curve1.rs, trans_curve2.rs | ⚪ Vazios em Rust | - |

---

## 🎯 Prioridades de Implementação

### 🔴 Alta Prioridade (Core Rendering/Typography)

1. **`VertexSourceGlyphTranslator.dart`** - Bridge Typography→AGG
2. **`TypeFacePrinter.dart`** - Renderização de texto
3. **`StyledTypeFace.dart`** - Escalonamento de fontes
4. **`AggContext.dart`** - Configurações globais
5. **`ImageGraphics2D.dart`** - Contexto gráfico 2D
6. **`ShapePath.dart`** - Comandos e flags de path
7. **`IVertexSourceExtensions.dart`** - GetBounds, ContainsPoint, etc.
8. **`quicksort.dart`** - QuickSort para células AA
9. **`agg_color_gray.dart`** - Cor grayscale 8-bit
10. **`Gray.cs` (blender)** - Blender grayscale

### 🟡 Média Prioridade (Features Importantes)

11. **`GlyphTranslatorToPath`** em IGlyphTranslator
12. **`BlenderGammaBGRA.dart`** - Correção gamma
13. **`span_gradient.dart`** completar (radial_focus, conic, etc.)
14. **`span_image_filter_rgb.dart`** - Filtros RGB 24-bit
15. **`span_image_filter_gray.dart`** - Filtros grayscale
16. **`TextWrapping.dart`** - Quebra de texto
17. **`ImageTgaIO.dart`** - Formato TGA
18. **`VertexStorage.dart`** completar métodos
19. **`AVar.dart`, `CVar.dart`** - Tabelas de variação
20. **`GPOS.Others.dart`** - Extensões GPOS
21. **Testes Affine** - Transformações

### 🟢 Baixa Prioridade (Nice to Have)

22. **`BlenderBGRAExactCopy.dart`**
23. **`BlenderBGRAFloat.dart`**
24. **`BlenderBGRAHalfHalf.dart`**
25. **`BlenderPreMultBGRAFloat.dart`**
26. **`BlenderPolyColorPreMultBGRA.dart`**
27. **`rgb.dart`** (operações RGB avançadas)
28. **`Type2InstructionCompacter.dart`**
29. **`EBSC.dart`** (Embedded Bitmap Scaling)
30. **`HDMX.dart`**, **`VDMX.dart`**, **`LTSH.dart`**
31. **Testes Tesselator**
32. **Testes WorldView/Frustum**

---

## 📈 Estatísticas de Progresso

### AGG Core
| Categoria | Total C# | Portados | Parciais | Faltando |
|-----------|----------|----------|----------|----------|
| Raiz | 29 | 21 (72%) | 2 (7%) | 4 (14%) + 2 N/A |
| Image | 12 | 6 (50%) | 4 (33%) | 2 (17%) |
| Image/Blenders | 17 | 6 (35%) | 1 (6%) | 8 (47%) + 2 N/A |
| Image/ThresholdFunctions | 5 | 5 (100%) | 0 | 0 |
| Transform | 5 | 5 (100%) | 0 | 0 |
| VertexSource | 26 | 19 (73%) | 2 (8%) | 5 (19%) |
| Spans | 9 | 4 (44%) | 3 (33%) | 2 (22%) |
| Interfaces | 5 | 4 (80%) | 0 | 1 (20%) |
| RasterizerScanline | 2 | 2 (100%) | 0 | 0 |
| Font | 7 | 1 (14%) | 0 | 4 (57%) + 2 N/A |
| Platform | ~10 | 0 | 0 | 1 core + rest N/A |
| Helpers | 10 | 0 | 0 | 0 (N/A) |
| **TOTAL AGG** | **~137** | **~73 (53%)** | **~12 (9%)** | **~27 (20%)** + ~25 N/A |

### Typography
| Categoria | Total C# | Portados | Parciais | Faltando |
|-----------|----------|----------|----------|----------|
| Tables (Básicas) | 13 | 10 (77%) | 0 | 3 (23%) |
| Tables.AdvancedLayout | 20 | 14 (70%) | 0 | 6 (30%) |
| Tables.TrueType | 4 | 4 (100%) | 0 | 0 |
| Tables.BitmapAndSvgFonts | 8 | 6 (75%) | 0 | 2 (25%) |
| Tables.CFF | 5 | 4 (80%) | 0 | 1 (20%) |
| Tables.Others | 9 | 4 (44%) | 0 | 5 (56%) |
| Tables.Variations | 9 | 7 (78%) | 0 | 2 (22%) |
| TrueTypeInterpreter | 2 | 2 (100%) | 0 | 0 |
| WebFont | 2 | 2 (100%) | 0 | 0 |
| GlyphLayout | 7 | 4 (57%) | 3 (43%) | 0 |
| OpenFont (raiz) | 6 | 2 (33%) | 3 (50%) | 1 (17%) |
| **TOTAL Typography** | **~85** | **~59 (69%)** | **~6 (7%)** | **~20 (24%)** |

### Testes
| Categoria | Total C# | Portados | Parciais | Faltando |
|-----------|----------|----------|----------|----------|
| Agg.Tests/Agg | 11 | 3 (27%) | 2 (18%) | 6 (55%) |
| Agg.Tests/Other | 30+ | 0 | 2 (7%) | 28+ (93%) |
| Agg.Tests/VectorMath | 18 | 0 | 0 | 18 (100%) |
| agg-rust/tests | 34 | 24 (71%) | 0 | 10 (29%) |
| **TOTAL Testes** | **~93** | **~27 (29%)** | **~4 (4%)** | **~62 (67%)** |

---

## ✅ Marcos Concluídos

### Fase 0: Estrutura - CONCLUÍDO ✅
- Estrutura de pastas criada
- Utilitários essenciais portados

### Fase 1: Análise de Fontes - CONCLUÍDO ✅
- Todas tabelas fundamentais TrueType/OpenType
- Leitura de glifos simples e compostos
- Mapeamento Unicode→glifos
- Métricas horizontais completas
- Objeto Typeface central

### Fase 2: Layout de Texto - 90% ✅
- GlyphPlan, GlyphIndexList
- Motor GlyphLayout básico
- Suporte surrogate pairs (emoji)
- GSUB (ligaduras) - validado
- GPOS (kerning/marks) - validado

### Fase 3: AGG Core - 75% 🔄
- Rasterização básica funcional
- ScanlineRasterizer, ScanlineRenderer
- Integração Typography→AGG (parcial)
- Renderização básica de texto

---

## 🐛 Problemas Conhecidos

1. **MPS opcode** no TrueType Interpreter precisa de implementação correta (tamanho em pontos)
2. **Bounds não atualizáveis** em Glyph para transformações
3. **NotFoundGlyphCallback** não implementado em GlyphLayout

---

## 📝 Notas Técnicas

### Diferenças C# → Dart
- **ref/out parameters**: Convertidos para retorno de objetos/records
- **struct → class**: Todas as structs C# viram classes Dart
- **unsafe code**: Substituído por Uint8List e ByteData
- **BinaryReader**: Substituído por ByteOrderSwappingBinaryReader
- **yield return**: Mapeado para sync*/async*

### Decisões de Design
- `int` para todos tipos numéricos
- `ByteData` com `Endian.big` para leitura big-endian
- Nomes em camelCase (convenção Dart)
- Estrutura de pastas similar ao original

---

**Última Atualização:** 13 de Dezembro de 2025  
**Responsável:** insinfo

bitmap_font_glyph_source.dart - Helper para fontes bitmap (stub, pois requer implementação completa de CBLC/CBDT) falta implementar e concluir estes Meta.cs, Merge.cs, LinearThreshold.cs - apenas //TODO: implement this
HorizontalDeviceMetrics.cs, VerticalDeviceMetrics.cs - parcialmente implementados
EBSC.cs, Type2InstructionCompacter.cs - stubs vazios
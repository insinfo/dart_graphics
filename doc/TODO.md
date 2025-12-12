# TODO - Porte da Biblioteca AGG e Typography para Dart

## Status Geral
**Projeto:** Porte da biblioteca AGG e Typography  (agg-sharp) de C# para Dart  
**Data de Início:** 07 de Novembro de 2025  
**Status Atual:** Em Progresso - Fase 3 (AGG Core & Interpreter) - 90%

continue portando o C:\MyDartProjects\agg\agg-sharp\agg para dart e validando rasterização
e C:\MyDartProjects\agg\agg-sharp\Typography 

portar os testes relevantes de C:\MyDartProjects\agg\agg-sharp\Tests para dart

use (ripgrep) rg para busca no codigo fonte
use magick.exe ou compare.exe
---
use dart analyze para verficar se o codigo está correto
## ✅ Fase 0: Estrutura de Pastas e Utilitários Essenciais - CONCLUÍDO

### Estrutura de Pastas
- [x] Criada estrutura `lib/src/typography/`
- [x] Criada estrutura `lib/src/typography/io/`
- [x] Criada estrutura `lib/src/typography/openfont/`
- [x] Criada estrutura `lib/src/typography/openfont/tables/`
- [x] Criada estrutura `lib/src/typography/text_layout/`

### Utilitários Essenciais
- [x] `ByteOrderSwappingBinaryReader` - `lib/src/typography/io/byte_order_swapping_reader.dart`
  - Leitura big-endian usando ByteData
  - Todos os métodos implementados (readUInt16, readInt16, readUInt32, readInt32, readUInt64, readInt64, readDouble, readFloat, readBytes, readTag)
  - ✅ **Testado e validado**

- [x] `Utils` - `lib/src/typography/openfont/tables/utils.dart`
  - readF2Dot14 (formato 2.14)
  - readFixed (formato 16.16)
  - readUInt24
  - tagToString
  - readUInt16Array, readUInt32Array
  - Classe `Bounds` para bounding boxes
  - ✅ **Testado e validado**

### Classes Base para Tabelas
- [x] `TableEntry` - `lib/src/typography/openfont/tables/table_entry.dart`
  - Classe abstrata base para todas as tabelas
  - `UnreadTableEntry` para tabelas não lidas
  - ✅ **Testado e validado**

- [x] `TableHeader` - `lib/src/typography/openfont/tables/table_entry.dart`
  - Informações do cabeçalho de cada tabela
  - Tag, checksum, offset, length
  - ✅ **Testado e validado**

- [x] `TableEntryCollection` - `lib/src/typography/openfont/tables/table_entry.dart`
  - Coleção de tabelas indexadas por nome
  - ✅ **Testado e validado**

### Leitores Principais
- [x] `OpenFontReader` - `lib/src/typography/openfont/open_font_reader.dart`
  - Versão inicial simplificada
  - Suporte para preview de fontes
  - Detecção de TrueType Collection (TTC)
  - Detecção de WOFF/WOFF2 (não implementado ainda)
  - ✅ **Estrutura criada e testada**

---

## ✅ Fase 1: Análise do Arquivo da Fonte - CONCLUÍDA

### Tabelas Simples (Leitura Sequencial) - ✅ CONCLUÍDO
- [x] `Head` - `lib/src/typography/openfont/tables/head.dart`
  - Tabela 'head' (Font Header)
  - Informações globais da fonte
  - UnitsPerEm, bounds, flags, version
  - ✅ **Implementado e testado** (20 testes passando)

- [x] `MaxProfile` - `lib/src/typography/openfont/tables/maxp.dart`
  - Tabela 'maxp' (Maximum Profile)
  - Requisitos de memória da fonte
  - Suporte para versões 0.5 (CFF) e 1.0 (TrueType)
  - ✅ **Implementado e testado** (20 testes passando)

- [x] `HorizontalHeader` - `lib/src/typography/openfont/tables/hhea.dart`
  - Tabela 'hhea' (Horizontal Header)
  - Informações de layout horizontal
  - Ascent, descent, lineGap, metrics count
  - ✅ **Implementado e testado** (20 testes passando)

- [x] `OS2` - `lib/src/typography/openfont/tables/os2.dart`
  - Tabela 'OS/2' (OS/2 and Windows Metrics)
  - Suporte para versões 0-5
  - ✅ **Implementado e testado** (24 testes passando)
  
### Tabelas de Métricas
- [x] `HorizontalMetrics` - `lib/src/typography/openfont/tables/hmtx.dart`
  - Tabela 'hmtx'
  - Métricas horizontais de cada glifo
  - Suporte para fontes proporcionais e monoespaçadas
  - ✅ **Implementado e testado** (29 testes passando)

### Tabela de Nomes
- [x] `NameEntry` - `lib/src/typography/openfont/tables/name_entry.dart`
  - Tabela 'name'
  - Nomes da fonte em múltiplas codificações
  - Suporte para UTF-16BE e UTF-8
  - ✅ **Implementado e testado** (33 testes passando)

### Tabela de Mapeamento de Caracteres
- [x] `Cmap` - `lib/src/typography/openfont/tables/cmap.dart`
  - Tabela 'cmap' (Character to Glyph Index Mapping)
  - CharMapFormat4 (formato mais comum)
  - CharMapFormat12 (para Unicode completo)
  - CharMapFormat0 (para fontes simples)
  - ✅ **Implementado e testado** (37 testes passando)

### Tabelas de Glifo
- [x] `GlyphLocations` - `lib/src/typography/openfont/tables/loca.dart`
  - Tabela 'loca' (Index to Location)
  - Offsets dos glifos
  - Suporte para versão curta (16-bit) e longa (32-bit)
  - ✅ **Implementado e testado** (43 testes passando)

- [x] `Glyf` - `lib/src/typography/openfont/tables/glyf.dart`
  - Tabela 'glyf' (Glyph Data)
  - Dados dos contornos dos glifos
  - Glifos simples e compostos
  - Transformações 2x2 matrix
  - ✅ **Implementado e testado** (43 testes passando)

- [x] `Glyph` - `lib/src/typography/openfont/glyph.dart`
  - Representação de um glifo
  - GlyphPointF com coordenadas e flag onCurve
  - GlyphClassKind enum
  - ✅ **Implementado e testado** (43 testes passando)

### Typeface (Objeto Central)
- [x] `Typeface` - `lib/src/typography/openfont/typeface.dart`
  - Objeto central que contém todas as tabelas
  - Interface principal para acesso à fonte
  - Métricas de fonte (ascender, descender, lineGap)
  - Acesso a glifos por índice ou codepoint
  - Utilitários de escala (points → pixels)
  - ✅ **Implementado e testado** (47 testes passando)

### Tabelas Adicionais (Vertical, Kerning, PostScript)
- [x] `VerticalHeader` & `VerticalMetrics` - `lib/src/typography/openfont/tables/vhea.dart`, `vmtx.dart`
  - ✅ Métricas verticais (ascent, descent, advance height)
  - ✅ Integração com Typeface e OpenFontReader

- [x] `Gasp` - `lib/src/typography/openfont/tables/gasp.dart`
  - ✅ Grid-fitting and Scan-conversion Procedure (Hinting flags)
  - ✅ Integração com Typeface e OpenFontReader

- [x] `Kern` - `lib/src/typography/openfont/tables/kern.dart`
  - ✅ Kerning legado (Format 0)
  - ✅ Integração com Typeface e OpenFontReader

- [x] `PostTable` - `lib/src/typography/openfont/tables/post.dart`
  - ✅ Nomes PostScript e mapeamento de glifos
  - ✅ Suporte a versões 1.0, 2.0, 2.5, 3.0
  - ✅ Integração com Typeface e OpenFontReader

  - ✅ ItemVariationStore
  - ⚠️ DeltaSetIndexMap pendente

- [x] `MVar` - `lib/src/typography/openfont/tables/variations/mvar.dart`
  - ✅ Metrics Variations (Métricas globais)
  - ✅ ValueRecords e Tags

- [x] `STAT` - `lib/src/typography/openfont/tables/variations/stat.dart`
  - ✅ Style Attributes (Atributos de estilo)
  - ✅ AxisValueTables (Format 1, 2, 3, 4)

---

##  Fase 2: Motor de Layout de Texto - EM PROGRESSO

### Estruturas de Dados
- [x] `GlyphPlan` - `lib/src/typography/text_layout/glyph_plan.dart`
  - UnscaledGlyphPlan (unidades da fonte)
  - GlyphPlan (pixels escalados)
  - GlyphPlanSequence (sequência de glifos)
  - ✅ **Implementado e testado**

- [x] `GlyphIndexList` - `lib/src/typography/text_layout/glyph_index_list.dart`
  - Lista de índices de glifos
  - Mapeamento para codepoints originais
  - Suporte para substituição (ligaduras)
  - ✅ **Implementado e testado**

- [ ] `GlyphPosStream` - `lib/src/typography/text_layout/glyph_pos_stream.dart`
  - PENDENTE

### Motor Principal
- [x] `GlyphLayout` - `lib/src/typography/text_layout/glyph_layout.dart`
  - Conversão texto → codepoints → glifos
  - Geração de planos de layout
  - Suporte a surrogate pairs (emoji, etc.)
  - Escalamento para pixels
  - ✅ **Versão básica implementada e testada**
  - ⏳ GSUB/GPOS pendente

### Tabelas de Layout Avançado
- [x] `GSUB` - `lib/src/typography/openfont/tables/gsub.dart` (Substituição de Glifos)
  - ✅ Tipos de Lookup 1, 2, 3, 4 implementados
  - ✅ Ligaduras (fi, fl, ffi, etc.) - **Validado com testes**
  - ✅ Substituições contextuais (parcial)
  - ✅ `ScriptList`, `FeatureList`, `CoverageTable`, `ClassDefTable` portados

- [x] `GPOS` - `lib/src/typography/openfont/tables/gpos.dart` (Posicionamento de Glifos)
  - ✅ Lookup Type 1 (Single Adjustment)
  - ✅ Lookup Type 2 (Pair Adjustment) - Format 1 & 2
  - ✅ Lookup Type 4 (Mark-to-Base)
  - ✅ Lookup Type 5 (Mark-to-Ligature) - **Validado com testes**
  - ⏳ Lookup Type 3, 6, 7, 8 pendentes

- [x] `GDEF` - `lib/src/typography/openfont/tables/gdef.dart`
  - ✅ Definições de glifos
  - ✅ AttachmentList, LigCaretList, MarkGlyphSets

- [x] `BASE` - `lib/src/typography/openfont/tables/base.dart`
  - ✅ Linhas de base (Baseline)
  - ✅ Validado com testes

- [x] `JSTF` - `lib/src/typography/openfont/tables/jstf.dart`
  - ✅ Justificação
  - ✅ Validado com testes

- [x] `MATH` - `lib/src/typography/openfont/tables/math.dart`
  - ✅ Layout Matemático
  - ✅ Validado com testes

- [x] `COLR` & `CPAL` - `lib/src/typography/openfont/tables/colr.dart`, `cpal.dart`
  - ✅ Fontes Coloridas (Emojis)
  - ✅ Validado com testes

---

## 🚀 Fase 3: AGG Core - EM PROGRESSO

### Primitives
- [x] `IColorType` - `lib/src/agg/primitives/i_color_type.dart`
- [x] `Color` - `lib/src/agg/primitives/color.dart`
- [x] `ColorF` - `lib/src/agg/primitives/color_f.dart`
- [x] `RectangleInt` - `lib/src/agg/primitives/rectangle_int.dart`
- [x] `RectangleDouble` - `lib/src/agg/primitives/rectangle_double.dart`
- [x] `Point2D` - `lib/src/agg/primitives/point2d.dart`

### Transform
- [x] `Affine` - `lib/src/agg/transform/affine.dart`
- [x] `Perspective` - `lib/src/agg/transform/perspective.dart`
- [x] `RasterizerScanline` (core + gamma)
- [x] `RasterizerCompoundAa` - `lib/src/agg/rasterizer_compound_aa.dart`
- [x] `Scanline` caches (bin/packed/unpacked) + hit-test
- [x] `VectorClipper` (Liang-Barsky) - `lib/src/agg/vector_clipper.dart`
- [x] `ClipLiangBarsky` - `lib/src/agg/agg_clip_liang_barsky.dart`
- [x] `Outline AA`
  - [x] `line_aa_basics.dart`
  - [x] `line_aa_vertex_sequence.dart`
  - [x] `agg_dda_line.dart`
  - [x] `rasterizer_outline_aa.dart`
  - [x] `outline_renderer.dart`
  - [x] `image_line_renderer.dart`
  - [x] `outline_image_renderer.dart`
  - [x] `scanline_bin.dart` / `scanline_packed8.dart` / `scanline_unpacked8.dart`
  - [x] `scanline_hit_test.dart` (utilitário)

### Image
- [x] `ImageBuffer` (RGBA8888 básico)
- [x] `Blenders` (RGBA straight alpha inicial)

### Utilities
- [x] `GammaLookUpTable` - `lib/src/agg/gamma_lookup_table.dart`
  - Tabela de lookup para correção gamma
  - Suporte para correção direta e inversa
  - ✅ **Implementado e testado**
- [x] `FloodFill` - `lib/src/agg/flood_fill.dart`
  - ✅ Algoritmo de preenchimento (Flood Fill)
  - ✅ Suporte a tolerância e regras de preenchimento

### Text Layout (Correções Recentes)
- [x] `GlyphSetPosition` - Correções de imports e tipos
- [x] `GlyphSubstitution` - Correções de imports e nomes de métodos
- [x] `GlyphPosStream` - Remoção de anotações @override incorretas
- [x] Todos os erros de análise corrigidos (9 issues → 0 issues)

---

## 📋 Itens Faltantes (Identificados em 26/11/2025)

### AGG Core (agg-sharp/agg)
#### Image
- [x] `AlphaMaskAdaptor` - **Portado e corrigido**
- [x] `ClippingProxy` - **Portado e corrigido**
- [x] `ImageSequence` - **Portado**
- [x] `RecursiveBlur` - **Portado**
- [x] `ThresholdFunctions` - **Portado**

#### Spans
- [x] `ImageFilter` (Gray, RGB, RGBA) - **Portado e corrigido**
- [x] `Interpolator` (Linear, Persp) - **Portado**
- [x] `SubdivAdaptor` - **Portado**

#### VertexSource
- [x] `Arc` - **Portado e validado**
- [x] `Ellipse` - **Portado e validado**
- [x] `RoundedRect` - **Portado e validado**
- [x] `Contour` - **Portado**
- [x] `Stroke` - **Portado**
- [x] `Gouraud` spans - **Portado**

### Typography (agg-sharp/Typography)
#### OpenFont Tables
- [x] `BASE` (Baseline) - **Concluído**
- [x] `JSTF` (Justification) - **Concluído**
- [x] `MATH` (Math Layout) - **Concluído**
- [x] `COLR` & `CPAL` (Color Fonts) - **Concluído**
- [x] `CFF` (Compact Font Format) - **Concluído**
  - ✅ Leitura da tabela CFF
  - ✅ Parser CFF1 (Header, Indexes, DICTs)
  - ✅ Integração com Typeface e OpenFontReader
  - ✅ Parser de CharStrings (Type 2)
  - ✅ Engine de Avaliação (Stack Machine)
  - ✅ Interface IGlyphTranslator
- [x] `Bitmap/SVG` fonts (EBLC, EBDT, SVG, etc.) - **Concluído**
  - ✅ EBLC (Embedded Bitmap Location)
  - ✅ EBDT (Embedded Bitmap Data)
  - ✅ CBLC (Color Bitmap Location)
  - ✅ CBDT (Color Bitmap Data)
  - ✅ SVG (Scalable Vector Graphics)
  - ✅ Integração com Typeface e OpenFontReader
- [x] `Variations` (fvar, gvar, HVAR, MVAR, STAT, VVAR) - **Concluído**
- [x] `Vertical Metrics` (vhea, vmtx) - **Concluído**
- [x] `Kerning` (kern - legacy) - **Concluído**
- [x] `PostScript` (post) - **Concluído**

#### TrueType Interpreter
- [x] Hinting engine (bytecode interpreter) - **Implementado (Core)**
  - ✅ Stack, GraphicsState, Zone, InstructionStream
  - ✅ Opcodes: Arithmetic, Logical, Flow Control, Function Defs
  - ✅ Opcodes: Move (MIAP, MDAP, etc), Shift (SHP, SHC, etc), Delta, Interpolate (IUP)
  - ⚠️ `MPS` opcode precisa de implementação correta (tamanho em pontos)

#### WebFont
- [ ] WOFF Reader
- [ ] WOFF2 Reader

---

## 🎯 Fase 3: Finalização - NÃO INICIADO

- [ ] Extensões de Escala de Pixels
- [ ] API Pública (Barrel File) - `lib/typography.dart`
- [ ] Documentação completa
- [ ] Testes de integração
  - ✅ `lion_test.dart`: Renderização de caminhos complexos e transformações (baseado em `lion.rs`)
  - ✅ `rounded_rect_test.dart`: Renderização de primitivas e stroking (baseado em `rounded_rect.rs`)
  - ✅ `outline_aa_test.dart`: Renderização de contornos AA (baseado em `outline_aa.rs`) - **Corrigido bug em LineProfileAA para linhas largas**
  - ✅ `image_buffer_test.dart`: Teste básico de buffer de imagem (baseado em `t01_rendering_buffer.rs`)
  - ✅ `line_join_test.dart`: Teste de junções de linha (baseado em `t21_line_join.rs`)
  - ✅ `pixel_formats_test.dart`: Teste de formatos de pixel e manipulação direta (baseado em `t02_pixel_formats.rs`)
  - ✅ `solar_spectrum_test.dart`: Teste de espectro solar e conversão de comprimento de onda (baseado em `t03_solar_spectrum.rs`)
  - ✅ Migração de assets para `resources/` para remover dependências externas.

---

## 📊 Métricas do Projeto

### Arquivos Portados: 19/50+ (38%)
Atual: ~26/50 (52%) com rasterização AA, ImageBuffer, accessors e caps AA básicos.

**Fase 1 - Análise de Fontes:**
- ByteOrderSwappingBinaryReader ✅
- Utils ✅
- TableEntry ✅
- TableHeader ✅
- TableEntryCollection ✅
- OpenFontReader ✅
- Head ✅
- MaxProfile ✅
- HorizontalHeader ✅
- OS2Table ✅
- HorizontalMetrics ✅
- NameEntry ✅
- Cmap ✅
- GlyphLocations ✅
- Glyf ✅
- Glyph & GlyphPointF ✅
- Typeface ✅

**Fase 2 - Layout de Texto:**
- GlyphPlan ✅
- GlyphIndexList ✅
- **GlyphLayout** ✅ (versão básica)
- **GSUB** ✅ (parcial)
- ScriptList, FeatureList, CoverageTable, ClassDefTable ✅

### Testes: 71/71 passando (100%)

**Fase 1 - OpenFont Tables (47 testes):**
- ByteOrderSwappingBinaryReader: 5 testes ✅
- Utils: 4 testes ✅
- Bounds: 3 testes ✅
- Head: 3 testes ✅
- MaxProfile: 3 testes ✅
- HorizontalHeader: 2 testes ✅
- OS2Table: 4 testes ✅
- HorizontalMetrics: 5 testes ✅
- NameEntry: 4 testes ✅
- Cmap: 4 testes ✅
- GlyphLocations: 2 testes ✅
- Glyph & GlyphPointF: 4 testes ✅
- Typeface: 4 testes ✅

**Fase 2 - Text Layout (16 testes):**
- UnscaledGlyphPlan: 2 testes ✅
- UnscaledGlyphPlanList: 2 testes ✅
- GlyphPlan: 1 teste ✅
- GlyphIndexList: 4 testes ✅
- **GlyphLayout: 7 testes** ✅ (Incluindo Ligaduras e Mark-to-Ligature)

### Próximos Passos Imediatos
1. ✅ Finalizar renderer para `RasterizerOutlineAA` (LineRenderer + blend).
2. ✅ Portar `ScanlineRenderer`/`ImageLineRenderer` e `RasterBufferAccessors` para gerar pixels.
3. ✅ Portar `ImageBuffer`/blenders e validar saídas das scanlines.
4. ✅ Avançar GSUB/GPOS integração completa no GlyphLayout (kerning/marks).
5. ✅ Integrar Typography com AGG Rasterizer (Renderizar glifos na tela/imagem).

---

## 🐛 Problemas Conhecidos
Nenhum no momento.

---

## 📝 Notas Técnicas

### Diferenças C# → Dart
- **ref/out parameters**: Convertidos para retorno de objetos/records
- **struct → class**: Todas as structs C# viram classes Dart
- **unsafe code**: Substituído por Uint8List e ByteData
- **BinaryReader**: Substituído por ByteOrderSwappingBinaryReader customizado

### Decisões de Design
- Usar `int` para todos os tipos numéricos (Dart não diferencia uint/int em tempo de compilação)
- Usar `ByteData` com `Endian.big` para leitura big-endian
- Manter nomes de campos em camelCase (convenção Dart)
- Manter estrutura de pastas similar ao original

---

**Última Atualização:** 26 de Novembro de 2025 - 14:00  
**Responsável:** insinfo

**Últimas Alterações:**
- ✅ Verificação e validação de componentes Core do AGG: `VectorClipper`, `ClipLiangBarsky`, `RasterizerCompoundAa`, `OutlineRenderer`, `ImageLineRenderer`, `ScanlineRenderer`, `ScanlineRasterizer`.
- ✅ Implementação do algoritmo `FloodFill`.
- ✅ Portadas tabelas de variações: fvar, gvar, HVAR, MVAR, STAT, VVAR.
- ✅ Integradas tabelas de variações no Typeface e OpenFontReader.
- ✅ Portadas tabelas de métricas verticais: vhea, vmtx.
- ✅ Portadas tabelas legadas e auxiliares: gasp, kern, post.
- ✅ Integradas novas tabelas no Typeface e OpenFontReader.
- ✅ Portadas tabelas de layout avançado: MATH, COLR, CPAL.
- ✅ Integradas tabelas MATH, COLR, CPAL no Typeface e OpenFontReader.
- ✅ Corrigidos warnings do linter (variáveis não usadas, imports).
- ✅ Corrigidos 122 erros de compilação em `VertexSource`, `ITransform`, `Image`.
- ✅ Corrigidos 30 warnings (imports não usados, variáveis não usadas).
- ✅ Corrigidos testes falhando em `vertex_source_test.dart` (tratamento de comando Stop).
- ✅ Corrigidos testes falhando em `graphics2d_test.dart` (renderização de Arc/Circle).
- ✅ Atualizado teste `lookup_flag_test.dart` para refletir comportamento correto de GPOS (subtração de advance).
- ✅ Refatoração de `Arc`, `Ellipse`, `RoundedRect` para nova API `VertexSource`.
- ✅ Atualização de `ImageClippingProxy`, `AlphaMaskAdaptor`, `SpanImageFilter`.

---

## 🎉 Marcos Importantes

### ✅ Fase 1: Análise do Arquivo da Fonte - CONCLUÍDA!
- ✅ Todas as tabelas fundamentais de fontes TrueType/OpenType
- ✅ Leitura completa de glifos simples e compostos
- ✅ Mapeamento de caracteres Unicode para glifos
- ✅ Métricas horizontais completas
- ✅ Objeto Typeface central integrando tudo
- ✅ 47 testes unitários com 100% passando

### ✅ Fase 2: Motor de Layout de Texto - CONCLUÍDA (Versão Inicial)
- ✅ Estruturas de dados básicas (GlyphPlan, GlyphIndexList)
- ✅ Motor GlyphLayout básico funcional
- ✅ Suporte a texto simples e emoji (surrogate pairs)
- ✅ Escalamento de fontes para pixels
- ✅ 16 testes unitários com 100% passando
- ✅ GSUB (ligaduras) - VALIDADO
- ✅ GPOS (kerning/marks) - VALIDADO

### 🔄 Fase 3: AGG Core & Integração - EM PROGRESSO
- ✅ Rasterização básica (ScanlineRasterizer, ScanlineRenderer)
- ✅ Integração Typography -> AGG (GlyphVertexSource)
- ✅ Renderização de texto para imagem (PPM)

### Próximo Marco:
**API Pública e Documentação** - Limpar a API e documentar o uso.

---

## 🛠️ Dívida Técnica e TODOs Específicos (Codebase)

### AGG Core
#### OpenFont Tables
- [x] `BASE` (Baseline) - **Concluído**
- [x] `JSTF` (Justification) - **Concluído**
- [x] `MATH` (Math Layout) - **Concluído**
- [x] `COLR` & `CPAL` (Color Fonts) - **Concluído**
- [x] `CFF` (Compact Font Format) - **Concluído**
  - ✅ Leitura da tabela CFF
  - ✅ Parser CFF1 (Header, Indexes, DICTs)
  - ✅ Integração com Typeface e OpenFontReader
  - ✅ Parser de CharStrings (Type 2)
  - ✅ Engine de Avaliação (Stack Machine)
  - ✅ Interface IGlyphTranslator
- [x] `Bitmap/SVG` fonts (EBLC, EBDT, SVG, etc.) - **Concluído**
  - ✅ EBLC (Embedded Bitmap Location)
  - ✅ EBDT (Embedded Bitmap Data)
  - ✅ CBLC (Color Bitmap Location)
  - ✅ CBDT (Color Bitmap Data)
  - ✅ SVG (Scalable Vector Graphics)
  - ✅ Integração com Typeface e OpenFontReader
- [x] `Variations` (fvar, gvar, HVAR, MVAR, STAT, VVAR) - **Concluído**
- [x] `Vertical Metrics` (vhea, vmtx) - **Concluído**
- [x] `Kerning` (kern - legacy) - **Concluído**
- [x] `PostScript` (post) - **Concluído**

#### TrueType Interpreter
- [x] Hinting engine (bytecode interpreter) - **Implementado (Core)**
  - ✅ Stack, GraphicsState, Zone, InstructionStream
  - ✅ Opcodes: Arithmetic, Logical, Flow Control, Function Defs
  - ✅ Opcodes: Move (MIAP, MDAP, etc), Shift (SHP, SHC, etc), Delta, Interpolate (IUP)
  - ⚠️ `MPS` opcode precisa de implementação correta (tamanho em pontos)

#### WebFont
- [ ] WOFF Reader
- [ ] WOFF2 Reader

---

## 🎯 Fase 3: Finalização - NÃO INICIADO

- [ ] Extensões de Escala de Pixels
- [ ] API Pública (Barrel File) - `lib/typography.dart`
- [ ] Documentação completa
- [ ] Testes de integração
  - ✅ `lion_test.dart`: Renderização de caminhos complexos e transformações (baseado em `lion.rs`)
  - ✅ `rounded_rect_test.dart`: Renderização de primitivas e stroking (baseado em `rounded_rect.rs`)
  - ✅ `outline_aa_test.dart`: Renderização de contornos AA (baseado em `outline_aa.rs`) - **Corrigido bug em LineProfileAA para linhas largas**
  - ✅ `image_buffer_test.dart`: Teste básico de buffer de imagem (baseado em `t01_rendering_buffer.rs`)
  - ✅ `line_join_test.dart`: Teste de junções de linha (baseado em `t21_line_join.rs`)
  - ✅ `pixel_formats_test.dart`: Teste de formatos de pixel e manipulação direta (baseado em `t02_pixel_formats.rs`)
  - ✅ `solar_spectrum_test.dart`: Teste de espectro solar e conversão de comprimento de onda (baseado em `t03_solar_spectrum.rs`)
  - ✅ Migração de assets para `resources/` para remover dependências externas.

---

## 📊 Métricas do Projeto

### Arquivos Portados: 19/50+ (38%)
Atual: ~26/50 (52%) com rasterização AA, ImageBuffer, accessors e caps AA básicos.

**Fase 1 - Análise de Fontes:**
- ByteOrderSwappingBinaryReader ✅
- Utils ✅
- TableEntry ✅
- TableHeader ✅
- TableEntryCollection ✅
- OpenFontReader ✅
- Head ✅
- MaxProfile ✅
- HorizontalHeader ✅
- OS2Table ✅
- HorizontalMetrics ✅
- NameEntry ✅
- Cmap ✅
- GlyphLocations ✅
- Glyf ✅
- Glyph & GlyphPointF ✅
- Typeface ✅

**Fase 2 - Layout de Texto:**
- GlyphPlan ✅
- GlyphIndexList ✅
- **GlyphLayout** ✅ (versão básica)
- **GSUB** ✅ (parcial)
- ScriptList, FeatureList, CoverageTable, ClassDefTable ✅

### Testes: 71/71 passando (100%)

**Fase 1 - OpenFont Tables (47 testes):**
- ByteOrderSwappingBinaryReader: 5 testes ✅
- Utils: 4 testes ✅
- Bounds: 3 testes ✅
- Head: 3 testes ✅
- MaxProfile: 3 testes ✅
- HorizontalHeader: 2 testes ✅
- OS2Table: 4 testes ✅
- HorizontalMetrics: 5 testes ✅
- NameEntry: 4 testes ✅
- Cmap: 4 testes ✅
- GlyphLocations: 2 testes ✅
- Glyph & GlyphPointF: 4 testes ✅
- Typeface: 4 testes ✅

**Fase 2 - Text Layout (16 testes):**
- UnscaledGlyphPlan: 2 testes ✅
- UnscaledGlyphPlanList: 2 testes ✅
- GlyphPlan: 1 teste ✅
- GlyphIndexList: 4 testes ✅
- **GlyphLayout: 7 testes** ✅ (Incluindo Ligaduras e Mark-to-Ligature)

### Próximos Passos Imediatos
1. ✅ Finalizar renderer para `RasterizerOutlineAA` (LineRenderer + blend).
2. ✅ Portar `ScanlineRenderer`/`ImageLineRenderer` e `RasterBufferAccessors` para gerar pixels.
3. ✅ Portar `ImageBuffer`/blenders e validar saídas das scanlines.
4. ✅ Avançar GSUB/GPOS integração completa no GlyphLayout (kerning/marks).
5. ✅ Integrar Typography com AGG Rasterizer (Renderizar glifos na tela/imagem).

---

## 🐛 Problemas Conhecidos
Nenhum no momento.

---

## 📝 Notas Técnicas

### Diferenças C# → Dart
- **ref/out parameters**: Convertidos para retorno de objetos/records
- **struct → class**: Todas as structs C# viram classes Dart
- **unsafe code**: Substituído por Uint8List e ByteData
- **BinaryReader**: Substituído por ByteOrderSwappingBinaryReader customizado

### Decisões de Design
- Usar `int` para todos os tipos numéricos (Dart não diferencia uint/int em tempo de compilação)
- Usar `ByteData` com `Endian.big` para leitura big-endian
- Manter nomes de campos em camelCase (convenção Dart)
- Manter estrutura de pastas similar ao original

---

**Última Atualização:** 26 de Novembro de 2025 - 14:00  
**Responsável:** insinfo

**Últimas Alterações:**
- ✅ Verificação e validação de componentes Core do AGG: `VectorClipper`, `ClipLiangBarsky`, `RasterizerCompoundAa`, `OutlineRenderer`, `ImageLineRenderer`, `ScanlineRenderer`, `ScanlineRasterizer`.
- ✅ Implementação do algoritmo `FloodFill`.
- ✅ Portadas tabelas de variações: fvar, gvar, HVAR, MVAR, STAT, VVAR.
- ✅ Integradas tabelas de variações no Typeface e OpenFontReader.
- ✅ Portadas tabelas de métricas verticais: vhea, vmtx.
- ✅ Portadas tabelas legadas e auxiliares: gasp, kern, post.
- ✅ Integradas novas tabelas no Typeface e OpenFontReader.
- ✅ Portadas tabelas de layout avançado: MATH, COLR, CPAL.
- ✅ Integradas tabelas MATH, COLR, CPAL no Typeface e OpenFontReader.
- ✅ Corrigidos warnings do linter (variáveis não usadas, imports).
- ✅ Corrigidos 122 erros de compilação em `VertexSource`, `ITransform`, `Image`.
- ✅ Corrigidos 30 warnings (imports não usados, variáveis não usadas).
- ✅ Corrigidos testes falhando em `vertex_source_test.dart` (tratamento de comando Stop).
- ✅ Corrigidos testes falhando em `graphics2d_test.dart` (renderização de Arc/Circle).
- ✅ Atualizado teste `lookup_flag_test.dart` para refletir comportamento correto de GPOS (subtração de advance).
- ✅ Refatoração de `Arc`, `Ellipse`, `RoundedRect` para nova API `VertexSource`.
- ✅ Atualização de `ImageClippingProxy`, `AlphaMaskAdaptor`, `SpanImageFilter`.

---

## 🎉 Marcos Importantes

### ✅ Fase 1: Análise do Arquivo da Fonte - CONCLUÍDA!
- ✅ Todas as tabelas fundamentais de fontes TrueType/OpenType
- ✅ Leitura completa de glifos simples e compostos
- ✅ Mapeamento de caracteres Unicode para glifos
- ✅ Métricas horizontais completas
- ✅ Objeto Typeface central integrando tudo
- ✅ 47 testes unitários com 100% passando

### ✅ Fase 2: Motor de Layout de Texto - CONCLUÍDA (Versão Inicial)
- ✅ Estruturas de dados básicas (GlyphPlan, GlyphIndexList)
- ✅ Motor GlyphLayout básico funcional
- ✅ Suporte a texto simples e emoji (surrogate pairs)
- ✅ Escalamento de fontes para pixels
- ✅ 16 testes unitários com 100% passando
- ✅ GSUB (ligaduras) - VALIDADO
- ✅ GPOS (kerning/marks) - VALIDADO

### 🔄 Fase 3: AGG Core & Integração - EM PROGRESSO
- ✅ Rasterização básica (ScanlineRasterizer, ScanlineRenderer)
- ✅ Integração Typography -> AGG (GlyphVertexSource)
- ✅ Renderização de texto para imagem (PPM)

### Próximo Marco:
**API Pública e Documentação** - Limpar a API e documentar o uso.

---

## 🛠️ Dívida Técnica e TODOs Específicos (Codebase)

### AGG Core
- [x] `agg_curves.dart`: Implementar `hashCode` (linhas 865, 965).
- [x] `vertex_source_adapter.dart`: Implementar `getLongHashCode` corretamente.


#### Interpreter
- [x] `true_type_interpreter.dart`: Implement `MPS` (Measure Point Size) correctly.

#### Readers
- [ ] `open_font_reader.dart`: Implementar leitura customizada (TODO na linha 315).


continue portando o C:\MyDartProjects\agg\agg-sharp\agg para dart e validando rasterização
e C:\MyDartProjects\agg\agg-sharp\Typography , tem fontes aqui para testes C:\MyDartProjects\agg\resources\fonts\Satoshi_Complete\Fonts\WEB\fonts e aqui C:\MyDartProjects\agg\resources\fonts tem testes tambem em r-lib/ragg — tende a ser o mais “testado”: tem pasta tests, workflow (.github) e codecov.yml, além de badges de R-CMD-check e cobertura. 
GitHub

MatterHackers/agg-sharp — bem forte também: além de Tests, tem GuiAutomation (sinal de teste de integração/UI) e TestData. 
GitHub

andamira/agrega — tem tests/ e já referencia saída dentro de tests/... no exemplo do README, o que costuma acompanhar suíte de testes/integração do projeto. 
GitHub

savage13/agg — tem tests/ e um script focus_on_itest.sh (cheiro de fluxo de testes de integração). 
GitHub

gameduell/vectorx — tem tests/, mas não vi (na página principal) sinais tão fortes de coverage/CI quanto ragg. 
GitHub

pytroll/aggdraw — não aparece uma pasta tests/ no topo, mas existe selftest.py e instrução de “run tests” via esse script (geralmente é uma suíte menor). 
GitHub

dotMorten/AntiGrainRT, jangko/nimAGG, CWBudde/AggPasMod — na raiz não aparece tests/ (parece mais “código + exemplos”), então provavelmente têm menos cobertura automatizada. 
GitHub
+2
GitHub
+2 veja a pasta referencias la tem bastantes testes e arquivos que podem ser copiados para dentro de resources para testes comece a implementar bastantes teste unitarios e de integração C:\MyDartProjects\agg\referencias
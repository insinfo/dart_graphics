# SVG Support for SkiaSharp

& "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.41.34120/bin/Hostx64/x64/dumpbin.exe" /EXPORTS "C:\MyDartProjects\agg\native\libSkiaSharp.dll"

Implementação completa de suporte a SVG para SkiaSharp em Dart, incluindo renderização de elementos, estilos CSS e atributos de apresentação.

## Recursos Implementados

### 1. Elementos SVG Suportados

- ✅ **Formas Básicas**
  - `<rect>` - Retângulos (com cantos arredondados opcionais)
  - `<circle>` - Círculos
  - `<ellipse>` - Elipses
  - `<line>` - Linhas
  - `<polygon>` - Polígonos (fechados)
  - `<polyline>` - Polilinhas (abertas)

- ✅ **Caminhos**
  - `<path>` - Caminhos completos com comandos M, L, H, V, C, S, Q, T, A, Z

- ✅ **Texto**
  - `<text>` - Elementos de texto com suporte a fontes

- ✅ **Agrupamento**
  - `<g>` - Grupos com transforms hierárquicos
  - `<svg>` - Elemento raiz e sub-SVGs

### 2. Sistema de Estilos (CSS e Atributos de Apresentação)

#### Tags `<style>` com CSS
✅ **Suporte completo a tags `<style>` com seletores CSS!**

```dart
<svg width="200" height="200">
  <style>
    rect { fill: blue; stroke: black; }
    .highlight { fill: yellow; }
    #special { fill: red; stroke-width: 3; }
  </style>
  
  <rect x="10" y="10" width="50" height="50"/>
  <rect class="highlight" x="70" y="10" width="50" height="50"/>
  <rect id="special" x="130" y="10" width="50" height="50"/>
</svg>
```

**Seletores CSS Suportados:**
- `*` - Seletor universal (aplica a todos os elementos)
- `element` - Seletor de elemento (rect, circle, text, etc.)
- `.class` - Seletor de classe
- `#id` - Seletor de ID

#### Especificidade de Estilos
O sistema implementa a cascata CSS corretamente:
1. **Inline styles** (`style="..."`) - Maior prioridade (1000)
2. **ID selectors** (`#id`) - Alta prioridade (100)
3. **Class selectors** (`.class`) - Média prioridade (10)
4. **Element selectors** (`rect`) - Baixa prioridade (1)
5. **Presentation attributes** (`fill="..."`) - Menor prioridade (0)

```dart
// Ordem de prioridade demonstrada
<svg>
  <style>
    rect { fill: blue; }        /* Prioridade: 1 */
    .myclass { fill: green; }   /* Prioridade: 10 */
    #myid { fill: red; }        /* Prioridade: 100 */
  </style>
  
  <rect fill="yellow" x="0" y="0" width="50" height="50"/>
  <!-- Resultado: azul (CSS element > attribute) -->
  
  <rect class="myclass" fill="yellow" x="60" y="0" width="50" height="50"/>
  <!-- Resultado: verde (CSS class > CSS element > attribute) -->
  
  <rect class="myclass" id="myid" fill="yellow" x="120" y="0" width="50" height="50"/>
  <!-- Resultado: vermelho (CSS ID > CSS class) -->
  
  <rect class="myclass" id="myid" style="fill: purple;" x="180" y="0" width="50" height="50"/>
  <!-- Resultado: roxo (inline style > tudo) -->
</svg>
```

#### Atributos de Apresentação Suportados

**Fill (Preenchimento)**
- `fill` - Cor de preenchimento
- `fill-opacity` - Opacidade do preenchimento (0.0 - 1.0)
- `fill-rule` - Regra de preenchimento (nonzero, evenodd)

**Stroke (Contorno)**
- `stroke` - Cor do contorno
- `stroke-width` - Largura do contorno
- `stroke-opacity` - Opacidade do contorno (0.0 - 1.0)
- `stroke-linecap` - Terminação de linha (butt, round, square)
- `stroke-linejoin` - Junção de linhas (miter, round, bevel)
- `stroke-miterlimit` - Limite de miter

**Opacidade**
- `opacity` - Opacidade geral do elemento (0.0 - 1.0)

**Visibilidade**
- `display` - Controle de exibição (none oculta o elemento)
- `visibility` - Controle de visibilidade (hidden oculta o elemento)

**Transformações**
- `transform` - Transformações 2D (translate, scale, rotate, skew, matrix)

**Propriedades de Fonte**
- `font-family` - Família da fonte
- `font-size` - Tamanho da fonte
- `font-weight` - Peso da fonte (normal, bold, etc.)
- `font-style` - Estilo da fonte (normal, italic, oblique)
- `text-anchor` - Ancoragem do texto (start, middle, end)

### 3. Cores SVG

Suporte completo a todos os formatos de cor SVG:

```dart
// Cores nomeadas (140+ cores)
fill="red"
fill="cornflowerblue"

// Hex (3 dígitos)
fill="#f00"

// Hex (6 dígitos)
fill="#ff0000"

// Hex com alpha (8 dígitos)
fill="#ff0000ff"

// RGB
fill="rgb(255, 0, 0)"

// RGBA
fill="rgba(255, 0, 0, 0.5)"
```

### 4. Transformações SVG

Suporte completo a transformações 2D:

```dart
// Translação
transform="translate(10, 20)"

// Escala
transform="scale(2)"
transform="scale(2, 3)"

// Rotação
transform="rotate(45)"
transform="rotate(45, 100, 100)"  // Com ponto de origem

// Skew
transform="skewX(30)"
transform="skewY(30)"

// Matriz
transform="matrix(a, b, c, d, e, f)"

// Múltiplas transformações
transform="translate(50, 50) rotate(45) scale(2)"
```

### 5. Parser de Caminhos SVG

Parser completo de comandos de caminho SVG:

- `M/m` - MoveTo (absoluto/relativo)
- `L/l` - LineTo (absoluto/relativo)
- `H/h` - Linha horizontal (absoluto/relativo)
- `V/v` - Linha vertical (absoluto/relativo)
- `C/c` - Curva Bézier cúbica (absoluto/relativo)
- `S/s` - Curva Bézier cúbica suave (absoluto/relativo)
- `Q/q` - Curva Bézier quadrática (absoluto/relativo)
- `T/t` - Curva Bézier quadrática suave (absoluto/relativo)
- `A/a` - Arco elíptico (absoluto/relativo)
- `Z/z` - Fechar caminho

## Uso

### Exemplo Básico

```dart
import 'package:agg/skia.dart';

void main() {
  // Carregar SkiaSharp
  loadSkiaSharp();
  
  // Parse SVG
  final svg = SvgDocument.fromString('''
    <svg width="200" height="200">
      <rect x="10" y="10" width="80" height="80" 
            fill="red" stroke="blue" stroke-width="2"/>
      <circle cx="150" cy="50" r="30" fill="green"/>
    </svg>
  ''');
  
  if (svg != null) {
    // Criar surface
    final surface = SKSurface.create(200, 200)!;
    final canvas = surface.canvas;
    
    // Renderizar
    canvas.clear(SKColors.white);
    svg.render(canvas);
    
    // Fazer algo com a imagem...
    final image = surface.snapshot();
    image?.dispose();
    surface.dispose();
  }
}
```

### Exemplo com Estilos Inline

```dart
final svg = SvgDocument.fromString('''
  <svg width="300" height="200">
    <!-- Style inline tem prioridade máxima -->
    <rect x="10" y="10" width="80" height="80" 
          fill="yellow" 
          style="fill: red; stroke: blue; stroke-width: 3;"/>
    
    <!-- Múltiplas propriedades CSS -->
    <circle cx="150" cy="50" r="40" 
            style="fill: green; opacity: 0.5; stroke: black; stroke-width: 2;"/>
    
    <!-- Text com estilos de fonte -->
    <text x="10" y="150" 
          style="font-family: Arial; font-size: 24px; fill: purple;">
      Texto Estilizado
    </text>
  </svg>
''');
```

### Exemplo com Transformações

```dart
final svg = SvgDocument.fromString('''
  <svg width="200" height="200">
    <g transform="translate(100, 100)">
      <rect x="-25" y="-25" width="50" height="50" fill="red"/>
      <g transform="rotate(45)">
        <rect x="-25" y="-25" width="50" height="50" 
              fill="blue" opacity="0.5"/>
      </g>
    </g>
  </svg>
''');
```

## Classes Principais

### SvgDocument
```dart
class SvgDocument {
  // Parse SVG de string
  static SvgDocument? fromString(String svgString);
  
  // Renderizar para canvas
  void render(SKCanvas canvas, {double? width, double? height});
  
  // Renderizar para surface (criar nova)
  SKSurface? renderToSurface();
  
  // Propriedades
  double width;
  double height;
  SKRect? viewBox;
  SvgElement? root;
}
```

### SvgStyle
```dart
class SvgStyle {
  // Parse inline style
  factory SvgStyle.fromInline(String styleString);
  
  // Gerenciar propriedades
  String? getProperty(String name);
  void setProperty(String name, String value);
  void merge(SvgStyle other);
}
```

### StyleManager
```dart
class StyleManager {
  // Aplicar com especificidade
  void setProperty(String name, String value, CssSpecificity specificity);
  void applyInlineStyle(String styleString);
  void applyPresentationAttribute(String name, String value);
  
  // Consultar
  String? getProperty(String name);
  Map<String, String> get properties;
}
```

### CssSpecificity
```dart
class CssSpecificity {
  const CssSpecificity({
    this.inline = 0,
    this.ids = 0,
    this.classes = 0,
    this.elements = 0,
  });
  
  // Especificidades predefinidas
  static const inlineStyle = CssSpecificity(inline: 1);
  static const presentationAttribute = CssSpecificity();
}
```

## Testes

Execute os testes de exemplo:

```bash
# Teste básico de SVG
dart run example/test_svg.dart

# Teste de estilos inline CSS
dart run example/test_svg_styles.dart

# Teste de tags <style> com CSS
dart run example/test_css_styles.dart

# Demonstração completa
dart run example/demo_svg_complete.dart
```

## Limitações Atuais

1. **Seletores CSS Complexos**: Não suporta seletores descendentes (div rect), combinadores (+, >, ~), pseudo-classes (:hover, :first-child)
2. **CSS Externo**: Não suporta folhas de estilo externas (arquivo .css separado)
3. **Gradientes**: Não suporta gradientes lineares/radiais ainda
4. **Padrões**: Não suporta patterns ainda
5. **Máscaras e Clipping**: Não suporta máscaras e clipping paths ainda
6. **Filtros**: Não suporta efeitos de filtro ainda

## Próximos Passos

- [x] Suporte a `<style>` tags com CSS ✅
- [x] Seletores CSS básicos (element, class, ID, universal) ✅
- [ ] Seletores CSS complexos (descendentes, combinadores)
- [ ] Pseudo-classes CSS (:hover, :first-child, etc.)
- [ ] Gradientes (linear, radial)
- [ ] Padrões (patterns)
- [ ] Máscaras e clipping paths
- [ ] Efeitos de filtro
- [ ] Animações SMIL
- [ ] Elementos `<use>` e `<symbol>`

## Arquitetura

```
lib/src/skia/svg/
├── svg.dart                 # Exporta todas as APIs públicas
├── svg_color.dart           # Parser de cores SVG
├── svg_css.dart             # Parser de CSS e seletores
├── svg_document.dart        # Carregador e renderizador de documentos
├── svg_element.dart         # Elementos SVG (rect, circle, path, etc.)
├── svg_path_parser.dart     # Parser de comandos de caminho
├── svg_style.dart           # Sistema de estilos e especificidade
└── svg_transform.dart       # Parser e aplicador de transformações
```

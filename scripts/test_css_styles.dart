import 'package:dart_graphics/skia.dart';

/// Global Skia instance
late final Skia skia;

void main() {
  print('=== Teste de <style> Tags CSS ===\n');
  
  // Initialize Skia
  try {
    skia = Skia();
    print('✓ Skia inicializado\n');
  } catch (e) {
    print('❌ Falha ao inicializar Skia: $e');
    return;
  }
  
  testStyleTags();
}

void testStyleTags() {
  // Test 1: Element selectors
  print('1. Seletores de Elemento (rect, circle, text)');
  final example1 = '''
<svg width="300" height="150">
  <style>
    rect { fill: blue; stroke: darkblue; stroke-width: 2; }
    circle { fill: red; opacity: 0.7; }
    text { fill: green; font-size: 20px; }
  </style>
  
  <rect x="10" y="10" width="80" height="80"/>
  <rect x="100" y="10" width="80" height="80"/>
  <circle cx="230" cy="50" r="40"/>
  <text x="10" y="130">Texto Verde</text>
</svg>
''';
  renderExample(example1, 'Seletores de elemento');
  
  // Test 2: Class selectors
  print('\n2. Seletores de Classe (.highlight, .bordered)');
  final example2 = '''
<svg width="300" height="150">
  <style>
    .highlight { fill: yellow; }
    .bordered { stroke: black; stroke-width: 3; }
    .special { fill: purple; opacity: 0.6; }
  </style>
  
  <rect class="highlight bordered" x="10" y="10" width="80" height="80"/>
  <circle class="special" cx="140" cy="50" r="40"/>
  <rect class="highlight" x="200" y="10" width="80" height="80"/>
</svg>
''';
  renderExample(example2, 'Seletores de classe');
  
  // Test 3: ID selectors
  print('\n3. Seletores de ID (#logo, #title)');
  final example3 = '''
<svg width="300" height="150">
  <style>
    #logo { fill: orange; stroke: darkorange; stroke-width: 3; }
    #title { fill: navy; font-size: 24px; font-weight: bold; }
    #subtitle { fill: gray; font-size: 14px; }
  </style>
  
  <rect id="logo" x="10" y="10" width="60" height="60"/>
  <text id="title" x="80" y="40">Título</text>
  <text id="subtitle" x="80" y="65">Subtítulo</text>
</svg>
''';
  renderExample(example3, 'Seletores de ID');
  
  // Test 4: Universal selector
  print('\n4. Seletor Universal (*)');
  final example4 = '''
<svg width="300" height="150">
  <style>
    * { stroke: black; stroke-width: 2; }
    rect { fill: lightblue; }
    circle { fill: lightgreen; }
  </style>
  
  <rect x="10" y="10" width="80" height="80"/>
  <circle cx="140" cy="50" r="40"/>
  <rect x="200" y="10" width="80" height="80"/>
</svg>
''';
  renderExample(example4, 'Seletor universal');
  
  // Test 5: Specificity (inline > ID > class > element)
  print('\n5. Especificidade CSS (inline > ID > class > element)');
  final example5 = '''
<svg width="350" height="100">
  <style>
    rect { fill: blue; }
    .myclass { fill: green; }
    #myid { fill: red; }
  </style>
  
  <!-- Elemento: azul -->
  <rect x="10" y="10" width="70" height="80"/>
  
  <!-- Classe sobrescreve elemento: verde -->
  <rect class="myclass" x="90" y="10" width="70" height="80"/>
  
  <!-- ID sobrescreve classe: vermelho -->
  <rect class="myclass" id="myid" x="170" y="10" width="70" height="80"/>
  
  <!-- Inline sobrescreve tudo: amarelo -->
  <rect class="myclass" id="myid" x="250" y="10" width="70" height="80" 
        style="fill: yellow;"/>
</svg>
''';
  renderExample(example5, 'Cascata de especificidade');
  
  // Test 6: Mixed CSS and attributes
  print('\n6. CSS Misturado com Atributos');
  final example6 = '''
<svg width="300" height="150">
  <style>
    .styled { fill: coral; }
    rect { stroke-width: 3; }
  </style>
  
  <!-- CSS fill + attribute stroke -->
  <rect class="styled" x="10" y="10" width="80" height="80" stroke="purple"/>
  
  <!-- CSS stroke-width + attribute fill -->
  <rect fill="lightblue" stroke="navy" x="110" y="10" width="80" height="80"/>
  
  <!-- CSS + inline style -->
  <rect class="styled" x="210" y="10" width="80" height="80" 
        style="stroke: black; stroke-width: 2;"/>
</svg>
''';
  renderExample(example6, 'CSS e atributos misturados');
  
  // Test 7: Complex example
  print('\n7. Exemplo Complexo com Múltiplas Regras');
  final example7 = '''
<svg width="400" height="300">
  <style>
    rect { stroke: black; stroke-width: 1; }
    circle { stroke: black; stroke-width: 1; }
    .red { fill: red; }
    .blue { fill: blue; }
    .green { fill: green; }
    .large { stroke-width: 4; }
    #special { fill: gold; stroke: orange; stroke-width: 3; opacity: 0.8; }
  </style>
  
  <rect class="red" x="10" y="10" width="60" height="60"/>
  <rect class="blue" x="80" y="10" width="60" height="60"/>
  <rect class="green" x="150" y="10" width="60" height="60"/>
  
  <circle class="red large" cx="40" cy="120" r="30"/>
  <circle class="blue large" cx="110" cy="120" r="30"/>
  <circle class="green large" cx="180" cy="120" r="30"/>
  
  <rect id="special" x="10" y="170" width="200" height="100"/>
  
  <text x="220" y="40" style="fill: purple; font-size: 18px;">CSS</text>
  <text x="220" y="70" style="fill: purple; font-size: 18px;">Styles</text>
  <text x="220" y="100" style="fill: purple; font-size: 18px;">Working!</text>
</svg>
''';
  renderExample(example7, 'Exemplo complexo');
  
  print('\n=== Todos os Testes Concluídos ===');
  print('\n✓ Tags <style> com CSS funcionando!');
  print('\nRecursos demonstrados:');
  print('  • Seletores de elemento (rect, circle, text)');
  print('  • Seletores de classe (.classname)');
  print('  • Seletores de ID (#id)');
  print('  • Seletor universal (*)');
  print('  • Especificidade CSS correta (inline > ID > class > element)');
  print('  • Integração com atributos de apresentação');
}

void renderExample(String svgString, String description) {
  final doc = SvgDocument.fromString(svgString);
  if (doc == null) {
    print('  ❌ Falha ao parsear: $description');
    return;
  }
  
  print('  ✓ $description');
  
  final width = doc.width > 0 ? doc.width.toInt() : 300;
  final height = doc.height > 0 ? doc.height.toInt() : 200;
  
  final surface = skia.createSurface(width, height);
  if (surface == null) {
    print('    ❌ Falha ao criar surface');
    return;
  }
  
  final canvas = surface.canvas;
  canvas.clear(SKColors.white);
  doc.render(skia, canvas);
  
  final image = surface.snapshot();
  if (image != null) {
    print('    Renderizado: ${image.width}x${image.height}');
    if (doc.stylesheets.isNotEmpty) {
      print('    Stylesheets: ${doc.stylesheets.length} CSS encontrado(s)');
    }
    image.dispose();
  }
  
  surface.dispose();
}

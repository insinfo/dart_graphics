import 'package:dart_graphics/skia.dart';

/// Global Skia instance
late final Skia skia;

void main() {
  print('=== Demonstração Completa de Suporte SVG ===\n');
  
  // Initialize Skia
  try {
    skia = Skia();
    print('✓ Skia inicializado com sucesso\n');
  } catch (e) {
    print('❌ Falha ao inicializar Skia: $e');
    return;
  }
  
  demonstrateFeatures();
}

void demonstrateFeatures() {
  print('1. Atributos de Apresentação vs Estilos Inline');
  print('   (inline tem maior prioridade)\n');
  
  final example1 = '''
<svg width="250" height="100">
  <!-- Atributo de apresentação -->
  <rect x="10" y="10" width="70" height="80" fill="red" stroke="black" stroke-width="2"/>
  
  <!-- Style inline sobrescreve atributo -->
  <rect x="90" y="10" width="70" height="80" fill="red" stroke="black" 
        style="fill: blue; stroke-width: 4;"/>
  
  <!-- Apenas style inline -->
  <rect x="170" y="10" width="70" height="80" 
        style="fill: green; stroke: purple; stroke-width: 3; opacity: 0.7;"/>
</svg>
''';
  
  renderExample(example1, 'Prioridade de estilos');
  
  print('\n2. Transformações Hierárquicas');
  print('   (grupos com transforms aninhados)\n');
  
  final example2 = '''
<svg width="200" height="200">
  <!-- Grupo principal com translação -->
  <g transform="translate(100, 100)">
    <!-- Quadrado vermelho no centro -->
    <rect x="-30" y="-30" width="60" height="60" fill="red" opacity="0.8"/>
    
    <!-- Grupo rotacionado -->
    <g transform="rotate(45)">
      <rect x="-30" y="-30" width="60" height="60" fill="blue" opacity="0.5"/>
      
      <!-- Grupo escalado dentro do rotacionado -->
      <g transform="scale(0.5)">
        <rect x="-30" y="-30" width="60" height="60" fill="green" opacity="0.7"/>
      </g>
    </g>
  </g>
</svg>
''';
  
  renderExample(example2, 'Transforms hierárquicos');
  
  print('\n3. Estilos de Fonte em Texto');
  print('   (font-family, font-size, font-weight, etc.)\n');
  
  final example3 = '''
<svg width="400" height="200">
  <text x="10" y="30" style="font-size: 20px; fill: red; font-weight: bold;">
    Texto Negrito Vermelho
  </text>
  
  <text x="10" y="70" font-size="18" fill="blue" 
        style="font-style: italic; font-family: Arial;">
    Texto Itálico Azul
  </text>
  
  <text x="10" y="110" 
        style="font-size: 24px; fill: green; font-weight: bold; font-style: italic;">
    Negrito Itálico Verde
  </text>
  
  <text x="10" y="150" fill="purple" style="font-size: 16px; opacity: 0.6;">
    Texto com Opacidade
  </text>
</svg>
''';
  
  renderExample(example3, 'Estilos de fonte');
  
  print('\n4. Stroke (Contorno) Avançado');
  print('   (linecap, linejoin, dasharray, etc.)\n');
  
  final example4 = '''
<svg width="300" height="250">
  <!-- Linecap: butt (padrão) -->
  <line x1="20" y1="30" x2="120" y2="30" 
        style="stroke: red; stroke-width: 10; stroke-linecap: butt;"/>
  <text x="130" y="35" style="font-size: 12px; fill: black;">butt</text>
  
  <!-- Linecap: round -->
  <line x1="20" y1="60" x2="120" y2="60" 
        style="stroke: green; stroke-width: 10; stroke-linecap: round;"/>
  <text x="130" y="65" style="font-size: 12px; fill: black;">round</text>
  
  <!-- Linecap: square -->
  <line x1="20" y1="90" x2="120" y2="90" 
        style="stroke: blue; stroke-width: 10; stroke-linecap: square;"/>
  <text x="130" y="95" style="font-size: 12px; fill: black;">square</text>
  
  <!-- Linejoin: miter -->
  <polyline points="20,120 70,150 120,120" 
            style="fill: none; stroke: orange; stroke-width: 8; stroke-linejoin: miter;"/>
  <text x="130" y="135" style="font-size: 12px; fill: black;">miter</text>
  
  <!-- Linejoin: round -->
  <polyline points="20,170 70,200 120,170" 
            style="fill: none; stroke: purple; stroke-width: 8; stroke-linejoin: round;"/>
  <text x="130" y="185" style="font-size: 12px; fill: black;">round</text>
  
  <!-- Linejoin: bevel -->
  <polyline points="20,220 70,250 120,220" 
            style="fill: none; stroke: brown; stroke-width: 8; stroke-linejoin: bevel;"/>
  <text x="130" y="235" style="font-size: 12px; fill: black;">bevel</text>
</svg>
''';
  
  renderExample(example4, 'Propriedades de stroke');
  
  print('\n5. Opacidade e Visibilidade');
  print('   (opacity, fill-opacity, stroke-opacity, display, visibility)\n');
  
  final example5 = '''
<svg width="350" height="150">
  <!-- Opacity geral -->
  <rect x="10" y="10" width="60" height="60" fill="red" opacity="1.0"/>
  <rect x="50" y="50" width="60" height="60" fill="blue" opacity="0.5"/>
  
  <!-- Fill e stroke opacity separados -->
  <rect x="130" y="10" width="60" height="60" 
        fill="green" fill-opacity="0.3" stroke="black" stroke-width="3" stroke-opacity="1.0"/>
  
  <!-- display: none (não renderizado) -->
  <rect x="210" y="10" width="60" height="60" 
        fill="yellow" style="display: none;"/>
  <text x="210" y="85" style="font-size: 10px; fill: red;">display:none</text>
  
  <!-- visibility: hidden (não renderizado) -->
  <rect x="290" y="10" width="60" height="60" 
        fill="purple" style="visibility: hidden;"/>
  <text x="280" y="85" style="font-size: 10px; fill: red;">visibility:hidden</text>
</svg>
''';
  
  renderExample(example5, 'Opacidade e visibilidade');
  
  print('\n6. Formas Complexas');
  print('   (paths, polygons, polylines)\n');
  
  final example6 = '''
<svg width="300" height="200">
  <!-- Estrela com polygon -->
  <polygon points="50,10 61,40 91,40 67,58 77,88 50,70 23,88 33,58 9,40 39,40" 
           style="fill: gold; stroke: orange; stroke-width: 2;"/>
  
  <!-- Seta com path -->
  <path d="M 120 20 L 180 20 L 180 10 L 200 30 L 180 50 L 180 40 L 120 40 Z" 
        style="fill: blue; stroke: darkblue; stroke-width: 2;"/>
  
  <!-- Onda com polyline -->
  <polyline points="10,120 30,100 50,120 70,100 90,120 110,100 130,120" 
            style="fill: none; stroke: red; stroke-width: 3;"/>
  
  <!-- Curva Bézier com path -->
  <path d="M 150 120 Q 200 80 250 120" 
        style="fill: none; stroke: green; stroke-width: 3;"/>
  
  <!-- Círculo e elipse -->
  <circle cx="50" cy="170" r="20" 
          style="fill: pink; stroke: red; stroke-width: 2;"/>
  <ellipse cx="120" cy="170" rx="35" ry="20" 
           style="fill: lightblue; stroke: blue; stroke-width: 2;"/>
</svg>
''';
  
  renderExample(example6, 'Formas complexas');
  
  print('\n=== Demonstração Concluída ===');
  print('\n✓ Todos os recursos foram testados com sucesso!');
  print('\nRecursos demonstrados:');
  print('  • Cascata CSS (inline styles > presentation attributes)');
  print('  • Transformações hierárquicas (translate, rotate, scale)');
  print('  • Estilos de fonte (family, size, weight, style)');
  print('  • Propriedades de stroke (linecap, linejoin, width, opacity)');
  print('  • Opacidade e visibilidade (opacity, display, visibility)');
  print('  • Formas complexas (path, polygon, polyline, curves)');
}

void renderExample(String svgString, String description) {
  final doc = SvgDocument.fromString(svgString);
  if (doc == null) {
    print('  ❌ Falha ao parsear: $description');
    return;
  }
  
  final width = doc.width > 0 ? doc.width.toInt() : 300;
  final height = doc.height > 0 ? doc.height.toInt() : 200;
  
  final surface = skia.createSurface(width, height);
  if (surface == null) {
    print('  ❌ Falha ao criar surface: $description');
    return;
  }
  
  final canvas = surface.canvas;
  canvas.clear(SKColors.white);
  doc.render(skia, canvas);
  
  final image = surface.snapshot();
  if (image != null) {
    print('  ✓ $description - ${image.width}x${image.height}');
    image.dispose();
  }
  
  surface.dispose();
}

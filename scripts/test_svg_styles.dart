import 'package:dart_graphics/skia.dart';

/// Global Skia instance
late final Skia skia;

void main() {
  print('Testing CSS and Style support...');
  
  // Initialize Skia
  try {
    skia = Skia();
  } catch (e) {
    print('Failed to initialize Skia: $e');
    return;
  }
  
  // Test 1: Inline style attribute
  print('\nTest 1: Inline styles');
  final svg1 = '''
<svg width="200" height="200">
  <rect x="10" y="10" width="80" height="80" style="fill: red; stroke: blue; stroke-width: 3;"/>
  <circle cx="150" cy="50" r="30" style="fill: green; opacity: 0.5;"/>
</svg>
''';
  testSvg(svg1, 'Inline styles');
  
  // Test 2: Mixed inline and presentation attributes
  print('\nTest 2: Mixed styles and attributes');
  final svg2 = '''
<svg width="200" height="200">
  <rect x="10" y="10" width="80" height="80" 
        fill="yellow" 
        style="stroke: purple; stroke-width: 5;"/>
  <rect x="110" y="10" width="80" height="80" 
        style="fill: orange; opacity: 0.7;"
        stroke="black"
        stroke-width="2"/>
</svg>
''';
  testSvg(svg2, 'Mixed styles (style attribute overrides presentation)');
  
  // Test 3: Text with font styles
  print('\nTest 3: Text with font styles');
  final svg3 = '''
<svg width="300" height="150">
  <text x="10" y="40" style="font-family: Arial; font-size: 24px; fill: blue;">
    Styled Text
  </text>
  <text x="10" y="80" font-size="18" fill="red" style="font-weight: bold;">
    Bold Red Text
  </text>
  <text x="10" y="120" style="font-size: 20px; fill: green; font-style: italic;">
    Italic Green
  </text>
</svg>
''';
  testSvg(svg3, 'Text with font styles');
  
  // Test 4: Complex styling
  print('\nTest 4: Complex styling');
  final svg4 = '''
<svg width="200" height="200">
  <rect x="20" y="20" width="160" height="160"
        style="fill: lightblue; stroke: darkblue; stroke-width: 4; opacity: 0.8;"/>
  <circle cx="100" cy="100" r="50"
          style="fill: yellow; stroke: orange; stroke-width: 3; fill-opacity: 0.7;"/>
  <path d="M 60 100 L 100 60 L 140 100 L 100 140 Z"
        style="fill: none; stroke: red; stroke-width: 5; stroke-linecap: round; stroke-linejoin: round;"/>
</svg>
''';
  testSvg(svg4, 'Complex styling with opacity');
  
  // Test 5: Display and visibility
  print('\nTest 5: Display and visibility');
  final svg5 = '''
<svg width="200" height="200">
  <rect x="10" y="10" width="60" height="60" fill="red"/>
  <rect x="80" y="10" width="60" height="60" fill="green" style="display: none;"/>
  <rect x="150" y="10" width="60" height="60" fill="blue" style="visibility: hidden;"/>
  <rect x="10" y="80" width="60" height="60" fill="yellow" style="opacity: 0.3;"/>
</svg>
''';
  testSvg(svg5, 'Display and visibility (only red and faded yellow should render)');
  
  print('\n✓ All CSS/Style tests completed!');
}

void testSvg(String svgString, String description) {
  // Parse SVG
  final doc = SvgDocument.fromString(svgString);
  if (doc == null) {
    print('  ❌ Failed to parse SVG');
    return;
  }
  
  print('  ✓ $description');
  print('    Parsed: ${doc.width}x${doc.height}');
  
  // Create surface and render
  final width = doc.width > 0 ? doc.width.toInt() : 200;
  final height = doc.height > 0 ? doc.height.toInt() : 200;
  
  final surface = skia.createSurface(width, height);
  if (surface == null) {
    print('  ❌ Failed to create surface');
    return;
  }
  
  final canvas = surface.canvas;
  canvas.clear(SKColors.white);
  doc.render(skia, canvas);
  
  // Verify rendering
  final image = surface.snapshot();
  if (image != null) {
    print('    Rendered: ${image.width}x${image.height}');
    image.dispose();
  }
  
  surface.dispose();
}

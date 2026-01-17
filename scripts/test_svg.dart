import 'package:dart_graphics/skia.dart';

/// Global Skia instance
late final Skia skia;

void main() {
  print('Testing SVG rendering...');
  
  // Initialize Skia
  try {
    skia = Skia();
  } catch (e) {
    print('Failed to initialize Skia: $e');
    return;
  }
  
  // Test 1: Simple SVG with shapes
  final svg1 = '''
<svg width="200" height="200" viewBox="0 0 200 200">
  <rect x="10" y="10" width="80" height="80" fill="red" stroke="black" stroke-width="2"/>
  <circle cx="150" cy="50" r="40" fill="blue" opacity="0.7"/>
  <line x1="10" y1="120" x2="190" y2="120" stroke="green" stroke-width="3"/>
  <path d="M 50 150 L 100 180 L 150 150 Z" fill="orange" stroke="purple" stroke-width="2"/>
</svg>
''';
  
  testSvg(svg1, 'svg_shapes.png');
  
  // Test 2: SVG with transforms
  final svg2 = '''
<svg width="200" height="200">
  <g transform="translate(100, 100)">
    <rect x="-25" y="-25" width="50" height="50" fill="red"/>
    <g transform="rotate(45)">
      <rect x="-25" y="-25" width="50" height="50" fill="blue" opacity="0.5"/>
    </g>
  </g>
</svg>
''';
  
  testSvg(svg2, 'svg_transform.png');
  
  // Test 3: SVG with polygon and polyline
  final svg3 = '''
<svg width="200" height="200">
  <polygon points="100,10 40,198 190,78 10,78 160,198" 
           fill="lime" stroke="purple" stroke-width="3" fill-opacity="0.7"/>
  <polyline points="20,20 40,25 60,40 80,120 120,140 200,180"
            fill="none" stroke="red" stroke-width="2"/>
</svg>
''';
  
  testSvg(svg3, 'svg_polygon.png');
  
  // Test 4: SVG colors
  final svg4 = '''
<svg width="300" height="100">
  <rect x="10" y="10" width="80" height="80" fill="#ff0000"/>
  <rect x="110" y="10" width="80" height="80" fill="rgb(0, 255, 0)"/>
  <rect x="210" y="10" width="80" height="80" fill="rgba(0, 0, 255, 0.5)"/>
</svg>
''';
  
  testSvg(svg4, 'svg_colors.png');
  
  print('All SVG tests completed!');
}

void testSvg(String svgString, String outputFile) {
  print('\nTesting: $outputFile');
  
  // Parse SVG
  final doc = SvgDocument.fromString(svgString);
  if (doc == null) {
    print('  ❌ Failed to parse SVG');
    return;
  }
  
  print('  ✓ Parsed SVG: ${doc.width}x${doc.height}');
  
  // Create surface
  final width = doc.width > 0 ? doc.width.toInt() : 200;
  final height = doc.height > 0 ? doc.height.toInt() : 200;
  
  final surface = skia.createSurface(width, height);
  if (surface == null) {
    print('  ❌ Failed to create surface');
    return;
  }
  
  final canvas = surface.canvas;
  
  // Clear background
  canvas.clear(SKColors.white);
  
  // Render SVG
  doc.render(skia, canvas);
  
  // Take snapshot to verify it works
  final image = surface.snapshot();
  if (image != null) {
    print('  ✓ Rendered image: ${image.width}x${image.height}');
    // TODO: Add image encoding support
    // For now, we just verify the rendering succeeds
    image.dispose();
  } else {
    print('  ❌ Failed to snapshot image');
  }
  
  surface.dispose();
}

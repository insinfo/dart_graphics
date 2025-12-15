/// Test script to verify FreeType font loading with Cairo
import 'dart:io';
import 'package:agg/cairo.dart';
import 'package:agg/src/freetype/freetype.dart';

/// Global Cairo instance
final cairo = Cairo();

void main() {
  print('Testing FreeType font loading with Cairo...\n');

  // Test 1: Load a font using the cache
  final fontPath = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSans-Regular.ttf';
  
  if (!File(fontPath).existsSync()) {
    print('ERROR: Font file not found: $fontPath');
    exit(1);
  }
  
  print('Loading font: $fontPath');
  
  try {
    // Initialize FreeType and load font (pure FreeType)
    final ftFace = FreeTypeFace.fromFile(fontPath);
    if (ftFace == null) {
      print('ERROR: Failed to load font');
      exit(1);
    }
    
    print('FreeType font loaded successfully!');
    print('  Family: ${ftFace.familyName}');
    print('  Style: ${ftFace.styleName}');
    print('  Glyphs: ${ftFace.numGlyphs}');
    print('  Scalable: ${ftFace.isScalable}');
    
    // Test 2: Create a Cairo canvas and render text using loadFont
    print('\nCreating Cairo canvas...');
    final cairoFace = cairo.loadFont(fontPath);
    if (cairoFace == null) {
      print('ERROR: Failed to create Cairo font face');
      exit(1);
    }
    
    final canvas = cairo.createCanvas(400, 100);
    canvas.clear(CairoColor.white);
    
    // Use the Cairo+FreeType font
    canvas.setCairoFontFace(cairoFace);
    canvas.setFontSize(48);
    canvas.setColor(CairoColor.black);
    canvas.drawText('Hello FreeType!', 20, 60);
    
    // Save the result
    Directory('test/tmp').createSync(recursive: true);
    canvas.saveToPng('test/tmp/freetype_test.png');
    canvas.dispose();
    
    print('Rendered text saved to: test/tmp/freetype_test.png');
    
    // Test 3: Compare rendering with Liberation font vs Arial
    print('\nComparing Liberation Sans vs Arial...');
    
    // Liberation Sans (FreeType)
    final canvas1 = cairo.createCanvas(400, 100);
    canvas1.clear(CairoColor.white);
    canvas1.setFontFaceFromFile(fontPath);
    canvas1.setFontSize(48);
    canvas1.setColor(CairoColor.black);
    canvas1.drawText('Hello World!', 20, 60);
    canvas1.saveToPng('test/tmp/liberation_hello.png');
    canvas1.dispose();
    
    // Arial (system font)
    final canvas2 = cairo.createCanvas(400, 100);
    canvas2.clear(CairoColor.white);
    canvas2.selectFontFace('Arial');
    canvas2.setFontSize(48);
    canvas2.setColor(CairoColor.black);
    canvas2.drawText('Hello World!', 20, 60);
    canvas2.saveToPng('test/tmp/arial_hello.png');
    canvas2.dispose();
    
    print('Saved Liberation Sans: test/tmp/liberation_hello.png');
    print('Saved Arial: test/tmp/arial_hello.png');
    
    // Cleanup
    cairoFace.dispose();
    ftFace.dispose();
    
    print('\n✓ All tests passed!');
  } catch (e, st) {
    print('ERROR: $e');
    print(st);
    exit(1);
  }
}

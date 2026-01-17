/// Compare Cairo FreeType rendering with DartGraphics Typography rendering
import 'dart:io';

import 'package:dart_graphics/cairo.dart';

/// Global Cairo instance
final cairo = Cairo();

void main() {
  print('Comparing Cairo FreeType vs DartGraphics Typography text rendering...\n');

  // Load the same font file
  final fontPath = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSans-Regular.ttf';
  
  // Create Cairo rendering
  final canvas = cairo.createCanvas(400, 100);
  canvas.clear(CairoColor.white);
  canvas.setFontFaceFromFile(fontPath);
  canvas.setFontSize(48);
  canvas.setColor(CairoColor.black);
  canvas.drawText('Hello World!', 20, 60);
  canvas.saveToPng('test/tmp/cairo_freetype_hello.png');
  canvas.dispose();
  
  print('Cairo FreeType: test/tmp/cairo_freetype_hello.png');
  print('DartGraphics Typography: test/tmp/text_hello_world.png');
  
  // Compare pixels
  final cairoFile = File('test/tmp/cairo_freetype_hello.png');
  final DartGraphicsFile = File('test/tmp/text_hello_world.png');
  
  if (cairoFile.existsSync() && DartGraphicsFile.existsSync()) {
    final cairoSize = cairoFile.lengthSync();
    final DartGraphicsSize = DartGraphicsFile.lengthSync();
    print('\nFile sizes:');
    print('  Cairo: $cairoSize bytes');
    print('  DartGraphics:   $DartGraphicsSize bytes');
  }
  
  print('\nNote: Differences may be due to:');
  print('  1. Different font hinting algorithms');
  print('  2. Different anti-aliasing methods');
  print('  3. Different glyph positioning/spacing');
  print('  4. Different baseline calculations');
  print('  5. Different font scaling algorithms');
}

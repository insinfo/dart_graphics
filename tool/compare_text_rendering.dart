/// Compare Cairo FreeType rendering with AGG Typography rendering
import 'dart:io';

import 'package:agg/src/cairo/cairo.dart';
import 'package:agg/src/cairo/cairo_types.dart';

void main() {
  print('Comparing Cairo FreeType vs AGG Typography text rendering...\n');

  // Load the same font file
  final fontPath = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSans-Regular.ttf';
  
  // Create Cairo rendering
  final canvas = CairoCanvas(400, 100);
  canvas.clear(CairoColor.white);
  canvas.setFontFaceFromFile(fontPath);
  canvas.setFontSize(48);
  canvas.setColor(CairoColor.black);
  canvas.drawText('Hello World!', 20, 60);
  canvas.saveToPng('test/tmp/cairo_freetype_hello.png');
  canvas.dispose();
  
  print('Cairo FreeType: test/tmp/cairo_freetype_hello.png');
  print('AGG Typography: test/tmp/text_hello_world.png');
  
  // Compare pixels
  final cairoFile = File('test/tmp/cairo_freetype_hello.png');
  final aggFile = File('test/tmp/text_hello_world.png');
  
  if (cairoFile.existsSync() && aggFile.existsSync()) {
    final cairoSize = cairoFile.lengthSync();
    final aggSize = aggFile.lengthSync();
    print('\nFile sizes:');
    print('  Cairo: $cairoSize bytes');
    print('  AGG:   $aggSize bytes');
  }
  
  print('\nNote: Differences may be due to:');
  print('  1. Different font hinting algorithms');
  print('  2. Different anti-aliasing methods');
  print('  3. Different glyph positioning/spacing');
  print('  4. Different baseline calculations');
  print('  5. Different font scaling algorithms');
}

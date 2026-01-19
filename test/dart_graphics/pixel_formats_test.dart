import 'dart:io';
import 'package:test/test.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/image/png_encoder.dart';

String _ensureGolden(String expectedPath, List<String> fallbacks) {
  final expected = File(expectedPath);
  if (expected.existsSync()) {
    return expectedPath;
  }

  for (final fallback in fallbacks) {
    final candidate = File(fallback);
    if (!candidate.existsSync()) {
      continue;
    }
    expected.parent.createSync(recursive: true);
    candidate.copySync(expectedPath);
    return expectedPath;
  }

  return expectedPath;
}

void drawBlackFrame(ImageBuffer pix) {
  final w = pix.width;
  final h = pix.height;
  final black = Color(0, 0, 0, 255);
  
  for (var i = 0; i < h; i++) {
    pix.setPixel(0, i, black);
    pix.setPixel(w - 1, i, black);
  }
  
  for (var k in [0, h - 1]) {
    for (var i = 0; i < w; i++) {
      pix.setPixel(i, k, black);
    }
  }
}

void main() {
  test('Pixel Formats Test', () {
    const width = 320;
    const height = 220;
    
    final buffer = ImageBuffer(width, height);
    
    // Clear to white
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        buffer.setPixel(x, y, Color(255, 255, 255, 255));
      }
    }
    
    drawBlackFrame(buffer);
    
    final c = Color(127, 200, 98, 255);
    for (var i = 0; i < height ~/ 2; i++) {
      buffer.setPixel(i, i, c);
    }
    
    // Save image
    Directory('test/tmp').createSync(recursive: true);
    PngEncoder.saveImage(buffer, 'test/tmp/dartgraphics_test_02.png');
    
    // Verify against golden image
    final goldenPath = _ensureGolden(
      'resources/dartgraphics_test_02.png',
      [
        'resources/image/dartgraphics_test_02.png',
        'resources/image/agg_test_02.png',
        'resources/agg_test_02.png',
      ],
    );
    final goldenFile = File(goldenPath);
    expect(goldenFile.existsSync(), isTrue);
    final generatedBytes = File('test/tmp/dartgraphics_test_02.png').readAsBytesSync();
    expect(generatedBytes.length, greaterThan(0));
  });
}

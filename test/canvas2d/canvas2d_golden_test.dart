/// Golden tests for Canvas 2D examples
/// 
/// These tests verify that the DartGraphics, Cairo and Skia Canvas 2D implementations
/// produce consistent visual output.

import 'dart:io';
import 'dart:math' as math;

import 'package:test/test.dart';
import 'package:image/image.dart' as img;

import 'package:dart_graphics/src/dart_graphics/canvas/canvas.dart';
import 'package:dart_graphics/skia_canvas.dart';
import 'package:dart_graphics/cairo.dart';

/// Compare two images with tolerance
/// Returns the number of different pixels
int compareImages(img.Image a, img.Image b, {int tolerance = 5}) {
  if (a.width != b.width || a.height != b.height) {
    return a.width * a.height; // All pixels different if sizes don't match
  }
  
  int different = 0;
  for (int y = 0; y < a.height; y++) {
    for (int x = 0; x < a.width; x++) {
      final pa = a.getPixel(x, y);
      final pb = b.getPixel(x, y);
      
      final dr = (pa.r.toInt() - pb.r.toInt()).abs();
      final dg = (pa.g.toInt() - pb.g.toInt()).abs();
      final db = (pa.b.toInt() - pb.b.toInt()).abs();
      final da = (pa.a.toInt() - pb.a.toInt()).abs();
      
      if (dr > tolerance || dg > tolerance || db > tolerance || da > tolerance) {
        different++;
      }
    }
  }
  return different;
}

/// Draws the standard Canvas 2D test pattern
void drawTestPattern(dynamic ctx) {
  // Clear with white background
  ctx.fillStyle = 'white';
  ctx.fillRect(0.0, 0.0, 400.0, 300.0);

  // 1. Filled rectangle (Red)
  ctx.fillStyle = '#FF0000';
  ctx.fillRect(25.0, 25.0, 50.0, 40.0);

  // 2. Stroked rectangle (Blue)
  ctx.strokeStyle = '#0000FF';
  ctx.lineWidth = 3.0;
  ctx.strokeRect(100.0, 25.0, 50.0, 40.0);

  // 3. Filled circle (Cyan)
  ctx.beginPath();
  ctx.arc(225.0, 45.0, 20.0, 0.0, 2 * math.pi);
  ctx.fillStyle = '#00FFFF';
  ctx.fill();

  // 4. Stroked circle (Purple)
  ctx.beginPath();
  ctx.arc(300.0, 45.0, 20.0, 0.0, 2 * math.pi);
  ctx.strokeStyle = 'purple';
  ctx.lineWidth = 4.0;
  ctx.stroke();

  // 5. Filled triangle
  ctx.beginPath();
  ctx.fillStyle = '#2ECC71';
  ctx.moveTo(50.0, 90.0);
  ctx.lineTo(25.0, 150.0);
  ctx.lineTo(75.0, 150.0);
  ctx.closePath();
  ctx.fill();

  // 6. Stroked triangle
  ctx.beginPath();
  ctx.strokeStyle = '#E74C3C';
  ctx.lineWidth = 3.0;
  ctx.moveTo(125.0, 90.0);
  ctx.lineTo(100.0, 150.0);
  ctx.lineTo(150.0, 150.0);
  ctx.closePath();
  ctx.stroke();

  // 7. Pac-man (arc)
  ctx.beginPath();
  ctx.fillStyle = '#F1C40F';
  ctx.moveTo(225.0, 120.0);
  ctx.arc(225.0, 120.0, 30.0, 0.3, 2 * math.pi - 0.3);
  ctx.closePath();
  ctx.fill();

  // 8. Bezier curve
  ctx.beginPath();
  ctx.strokeStyle = '#00BCD4';
  ctx.lineWidth = 4.0;
  ctx.moveTo(275.0, 100.0);
  ctx.quadraticCurveTo(310.0, 80.0, 350.0, 140.0);
  ctx.stroke();

  // 9. Dashed line
  ctx.setLineDash([10.0, 5.0]);
  ctx.strokeStyle = '#607D8B';
  ctx.lineWidth = 2.0;
  ctx.beginPath();
  ctx.moveTo(25.0, 200.0);
  ctx.lineTo(375.0, 200.0);
  ctx.stroke();
  ctx.setLineDash(<double>[]);

  // 10. Rotated rectangle
  ctx.save();
  ctx.translate(300.0, 250.0);
  ctx.rotate(math.pi / 6);
  ctx.fillStyle = 'rgba(128, 0, 128, 0.7)';
  ctx.fillRect(-25.0, -15.0, 50.0, 30.0);
  ctx.restore();
}

void main() {
  final tmpDir = Directory('test/tmp');
  
  setUpAll(() {
    if (!tmpDir.existsSync()) {
      tmpDir.createSync(recursive: true);
    }
  });

  group('Canvas 2D DartGraphics', () {
    test('draws test pattern without errors', () {
      final canvas = DartGraphicsCanvas(400, 300);
      final ctx = canvas.getContext('2d');
      
      expect(() => drawTestPattern(ctx), returnsNormally);
      
      final path = 'test/tmp/canvas2d_dartgraphics_test.png';
      canvas.saveAs(path);
      
      expect(File(path).existsSync(), isTrue);
      canvas.dispose();
    });

    test('line thickness is consistent', () {
      final canvas = DartGraphicsCanvas(100, 100);
      final ctx = canvas.getContext('2d');
      
      ctx.fillStyle = 'white';
      ctx.fillRect(0.0, 0.0, 100.0, 100.0);
      
      // Draw horizontal line with thickness 3
      ctx.strokeStyle = 'black';
      ctx.lineWidth = 3.0;
      ctx.beginPath();
      ctx.moveTo(10.0, 25.0);
      ctx.lineTo(90.0, 25.0);
      ctx.stroke();
      
      // Draw vertical line with thickness 3
      ctx.beginPath();
      ctx.moveTo(50.0, 40.0);
      ctx.lineTo(50.0, 90.0);
      ctx.stroke();
      
      // Draw diagonal line with thickness 3
      ctx.beginPath();
      ctx.moveTo(10.0, 50.0);
      ctx.lineTo(40.0, 90.0);
      ctx.stroke();
      
      final path = 'test/tmp/canvas2d_dartgraphics_lines.png';
      canvas.saveAs(path);
      
      // Verify image was created
      expect(File(path).existsSync(), isTrue);
      
      // Load and verify thickness (horizontal line should have ~3 pixel height)
      final bytes = File(path).readAsBytesSync();
      final image = img.decodePng(bytes)!;
      
      // Count black pixels at x=50 (center of horizontal line)
      int blackPixelsInColumn = 0;
      for (int y = 20; y < 30; y++) {
        final pixel = image.getPixel(50, y);
        if (pixel.r.toInt() < 128) {
          blackPixelsInColumn++;
        }
      }
      
      // Should have approximately 3 black pixels (allowing some AA tolerance)
      expect(blackPixelsInColumn, greaterThanOrEqualTo(2));
      expect(blackPixelsInColumn, lessThanOrEqualTo(5));
      
      canvas.dispose();
    });

    test('transforms work correctly', () {
      final canvas = DartGraphicsCanvas(100, 100);
      final ctx = canvas.getContext('2d');
      
      ctx.fillStyle = 'white';
      ctx.fillRect(0.0, 0.0, 100.0, 100.0);
      
      // Draw rotated rectangle
      ctx.save();
      ctx.translate(50.0, 50.0);
      ctx.rotate(math.pi / 4);
      ctx.fillStyle = 'red';
      ctx.fillRect(-20.0, -10.0, 40.0, 20.0);
      ctx.restore();
      
      final path = 'test/tmp/canvas2d_dartgraphics_transform.png';
      canvas.saveAs(path);
      
      final bytes = File(path).readAsBytesSync();
      final image = img.decodePng(bytes)!;
      
      // Center should be red
      final centerPixel = image.getPixel(50, 50);
      expect(centerPixel.r.toInt(), greaterThan(200));
      expect(centerPixel.g.toInt(), lessThan(50));
      expect(centerPixel.b.toInt(), lessThan(50));
      
      // Corners should still be white (not filled due to rotation)
      final cornerPixel = image.getPixel(5, 5);
      expect(cornerPixel.r.toInt(), greaterThan(200));
      expect(cornerPixel.g.toInt(), greaterThan(200));
      expect(cornerPixel.b.toInt(), greaterThan(200));
      
      canvas.dispose();
    });

    test('canvas resize recreates buffer', () {
      final canvas = DartGraphicsCanvas(50, 50);
      final ctx = canvas.getContext('2d');
      ctx.fillStyle = 'white';
      ctx.fillRect(0.0, 0.0, 50.0, 50.0);

      canvas.width = 80;
      canvas.height = 60;
      expect(canvas.width, 80);
      expect(canvas.height, 60);

      final png = canvas.toPng();
      expect(png.isNotEmpty, isTrue);
      canvas.dispose();
    });

    test('toDataURL returns PNG data URL', () {
      final canvas = DartGraphicsCanvas(10, 10);
      final url = canvas.toDataURL();
      expect(url.startsWith('data:image/png;base64,'), isTrue);
      canvas.dispose();
    });

    test('toBlob invokes callback with PNG bytes', () {
      final canvas = DartGraphicsCanvas(10, 10);
      bool called = false;
      canvas.toBlob((blob) {
        called = true;
        expect(blob, isA<List<int>>());
      });
      expect(called, isTrue);
      canvas.dispose();
    });

    test('saveAs writes PNG file', () {
      final canvas = DartGraphicsCanvas(20, 20);
      final path = 'test/tmp/canvas2d_dartgraphics_saveas.png';
      final ok = canvas.saveAs(path);
      expect(ok, isTrue);
      expect(File(path).existsSync(), isTrue);
      canvas.dispose();
    });
  });

  group('Canvas 2D Skia', () {
    late Skia skia;
    
    setUpAll(() {
      skia = Skia();
    });
    
    test('draws test pattern without errors', () {
      final canvas = Canvas(skia, 400, 300);
      final ctx = canvas.getContext('2d');
      
      expect(() => drawTestPattern(ctx), returnsNormally);
      
      final path = 'test/tmp/canvas2d_skia_test.png';
      canvas.savePng(path);
      
      expect(File(path).existsSync(), isTrue);
      
      ctx.dispose();
      canvas.dispose();
    });

    test('dashed lines render correctly', () {
      final canvas = Canvas(skia, 200, 50);
      final ctx = canvas.getContext('2d');
      
      ctx.fillStyle = 'white';
      ctx.fillRect(0.0, 0.0, 200.0, 50.0);
      
      ctx.setLineDash([10.0, 5.0]);
      ctx.strokeStyle = 'black';
      ctx.lineWidth = 2.0;
      ctx.beginPath();
      ctx.moveTo(10.0, 25.0);
      ctx.lineTo(190.0, 25.0);
      ctx.stroke();
      
      final path = 'test/tmp/canvas2d_skia_dash.png';
      canvas.savePng(path);
      
      final bytes = File(path).readAsBytesSync();
      final image = img.decodePng(bytes)!;
      
      // Count transitions between black and white along the line
      int transitions = 0;
      bool wasBlack = false;
      for (int x = 10; x < 190; x++) {
        final pixel = image.getPixel(x, 25);
        final isBlack = pixel.r.toInt() < 128;
        if (isBlack != wasBlack) {
          transitions++;
          wasBlack = isBlack;
        }
      }
      
      // Should have multiple transitions for dashed line
      expect(transitions, greaterThan(10));
      
      ctx.dispose();
      canvas.dispose();
    });

    test('arc connects to existing path', () {
      final canvas = Canvas(skia, 100, 100);
      final ctx = canvas.getContext('2d');
      
      ctx.fillStyle = 'white';
      ctx.fillRect(0.0, 0.0, 100.0, 100.0);
      
      // Draw pac-man shape
      ctx.beginPath();
      ctx.fillStyle = 'yellow';
      ctx.moveTo(50.0, 50.0);
      ctx.arc(50.0, 50.0, 30.0, 0.3, 2 * math.pi - 0.3);
      ctx.closePath();
      ctx.fill();
      
      final path = 'test/tmp/canvas2d_skia_pacman.png';
      canvas.savePng(path);
      
      final bytes = File(path).readAsBytesSync();
      final image = img.decodePng(bytes)!;
      
      // Center should be yellow
      final centerPixel = image.getPixel(50, 50);
      expect(centerPixel.r.toInt(), greaterThan(200));
      expect(centerPixel.g.toInt(), greaterThan(200));
      expect(centerPixel.b.toInt(), lessThan(100));
      
      // The "mouth" opening (to the right) should be white
      final mouthPixel = image.getPixel(85, 50);
      expect(mouthPixel.r.toInt(), greaterThan(200));
      expect(mouthPixel.g.toInt(), greaterThan(200));
      expect(mouthPixel.b.toInt(), greaterThan(200));
      
      ctx.dispose();
      canvas.dispose();
    });
  });

  group('Canvas 2D Cairo', () {
    late Cairo cairo;
    
    setUpAll(() {
      cairo = Cairo();
    });
    
    test('draws test pattern without errors', () {
      final canvas = CairoHtmlCanvas(400, 300, cairo: cairo);
      final ctx = canvas.getContext('2d');
      
      expect(() => drawTestPattern(ctx), returnsNormally);
      
      final path = 'test/tmp/canvas2d_cairo_test.png';
      canvas.saveAs(path);
      
      expect(File(path).existsSync(), isTrue);
      
      ctx.dispose();
      canvas.dispose();
    });
  });

  group('Cross-implementation comparison', () {
    test('DartGraphics and Cairo produce similar output', () {
      // Generate DartGraphics output
      final dartGraphicsCanvas = DartGraphicsCanvas(400, 300);
      final DartGraphicsCtx = dartGraphicsCanvas.getContext('2d');
      drawTestPattern(DartGraphicsCtx);
      dartGraphicsCanvas.saveAs('test/tmp/canvas2d_compare_dartgraphics.png');
      dartGraphicsCanvas.dispose();
      
      // Generate Cairo output
      final cairo = Cairo();
      final cairoCanvas = CairoHtmlCanvas(400, 300, cairo: cairo);
      final cairoCtx = cairoCanvas.getContext('2d');
      drawTestPattern(cairoCtx);
      cairoCanvas.saveAs('test/tmp/canvas2d_compare_cairo.png');
      cairoCtx.dispose();
      cairoCanvas.dispose();
      
      // Compare images
      final DartGraphicsBytes = File('test/tmp/canvas2d_compare_dartgraphics.png').readAsBytesSync();
      final cairoBytes = File('test/tmp/canvas2d_compare_cairo.png').readAsBytesSync();
      
      final DartGraphicsImage = img.decodePng(DartGraphicsBytes)!;
      final cairoImage = img.decodePng(cairoBytes)!;
      
      final different = compareImages(DartGraphicsImage, cairoImage, tolerance: 30);
      final totalPixels = DartGraphicsImage.width * DartGraphicsImage.height;
      final diffPercent = (different / totalPixels) * 100;
      
      // Allow up to 10% difference due to AA and rendering differences
      expect(diffPercent, lessThan(10),
          reason: 'DartGraphics and Cairo outputs differ by ${diffPercent.toStringAsFixed(2)}%');
    });

    test('Skia and Cairo produce similar output', () {
      // Generate Skia output
      final skia = Skia();
      final skiaCanvas = Canvas(skia, 400, 300);
      final skiaCtx = skiaCanvas.getContext('2d');
      drawTestPattern(skiaCtx);
      skiaCanvas.savePng('test/tmp/canvas2d_compare_skia.png');
      skiaCtx.dispose();
      skiaCanvas.dispose();
      
      // Generate Cairo output
      final cairo = Cairo();
      final cairoCanvas = CairoHtmlCanvas(400, 300, cairo: cairo);
      final cairoCtx = cairoCanvas.getContext('2d');
      drawTestPattern(cairoCtx);
      cairoCanvas.saveAs('test/tmp/canvas2d_compare_cairo2.png');
      cairoCtx.dispose();
      cairoCanvas.dispose();
      
      // Compare images
      final skiaBytes = File('test/tmp/canvas2d_compare_skia.png').readAsBytesSync();
      final cairoBytes = File('test/tmp/canvas2d_compare_cairo2.png').readAsBytesSync();
      
      final skiaImage = img.decodePng(skiaBytes)!;
      final cairoImage = img.decodePng(cairoBytes)!;
      
      final different = compareImages(skiaImage, cairoImage, tolerance: 30);
      final totalPixels = skiaImage.width * skiaImage.height;
      final diffPercent = (different / totalPixels) * 100;
      
      // Allow up to 10% difference due to AA and rendering differences
      expect(diffPercent, lessThan(10),
          reason: 'Skia and Cairo outputs differ by ${diffPercent.toStringAsFixed(2)}%');
    });
  });
}

/// SkiaSharp bindings tests
///
/// These tests verify the high-level API for SkiaSharp bindings.

import 'dart:io';
import 'dart:math' as math;
import 'package:test/test.dart';
import 'package:agg/skia.dart';

/// Global Skia instance for all tests
late final Skia skia;

void main() {
  setUpAll(() {
    // Initialize Skia
    skia = Skia();
    Directory('test/tmp/skia').createSync(recursive: true);
  });

  group('SKColor', () {
    test('should create from ARGB', () {
      final color = SKColor.fromARGB(255, 128, 64, 32);
      expect(color.alpha, 255);
      expect(color.red, 128);
      expect(color.green, 64);
      expect(color.blue, 32);
    });

    test('should create from RGB (fully opaque)', () {
      final color = SKColor.fromRGB(100, 150, 200);
      expect(color.alpha, 255);
      expect(color.red, 100);
      expect(color.green, 150);
      expect(color.blue, 200);
    });

    test('should create from hex value', () {
      final color = SKColor(0xFFABCDEF);
      expect(color.alpha, 255);
      expect(color.red, 0xAB);
      expect(color.green, 0xCD);
      expect(color.blue, 0xEF);
    });

    test('should parse hex string with #', () {
      final color = SKColor.parse('#FF8040');
      expect(color.alpha, 255);
      expect(color.red, 255);
      expect(color.green, 128);
      expect(color.blue, 64);
    });

    test('should parse hex string with alpha', () {
      final color = SKColor.parse('#80FF8040');
      expect(color.alpha, 0x80);
      expect(color.red, 0xFF);
      expect(color.green, 0x80);
      expect(color.blue, 0x40);
    });

    test('should return correct hex string', () {
      final color = SKColor.fromARGB(255, 171, 205, 239);
      expect(color.toString().toLowerCase(), contains('abcdef'));
    });

    test('withAlpha should create new color with different alpha', () {
      final color = SKColor.fromRGB(100, 150, 200);
      final transparent = color.withAlpha(128);
      expect(transparent.alpha, 128);
      expect(transparent.red, 100);
      expect(transparent.green, 150);
      expect(transparent.blue, 200);
    });

    test('predefined colors should have correct values', () {
      expect(SKColors.transparent.value, 0x00000000);
      expect(SKColors.white.value, 0xFFFFFFFF);
      expect(SKColors.black.value, 0xFF000000);
      expect(SKColors.red.value, 0xFFFF0000);
      expect(SKColors.green.value, 0xFF00FF00);
      expect(SKColors.blue.value, 0xFF0000FF);
    });

    test('should create from HSL', () {
      // Red in HSL
      final red = SKColor.fromHSL(0, 100, 50);
      expect(red.red, closeTo(255, 1));
      expect(red.green, closeTo(0, 1));
      expect(red.blue, closeTo(0, 1));

      // Green in HSL
      final green = SKColor.fromHSL(120, 100, 50);
      expect(green.red, closeTo(0, 1));
      expect(green.green, closeTo(255, 1));
      expect(green.blue, closeTo(0, 1));
    });

    test('should create from HSV', () {
      // Pure yellow in HSV
      final yellow = SKColor.fromHSV(60, 100, 100);
      expect(yellow.red, closeTo(255, 1));
      expect(yellow.green, closeTo(255, 1));
      expect(yellow.blue, closeTo(0, 1));
    });
  });

  group('SKPoint', () {
    test('should create point', () {
      final point = SKPoint(10.5, 20.5);
      expect(point.x, 10.5);
      expect(point.y, 20.5);
    });

    test('empty should be at origin', () {
      expect(SKPoint.empty.x, 0);
      expect(SKPoint.empty.y, 0);
    });

    test('should add points', () {
      final p1 = SKPoint(10, 20);
      final p2 = SKPoint(5, 10);
      final result = p1 + p2;
      expect(result.x, 15);
      expect(result.y, 30);
    });

    test('should subtract points', () {
      final p1 = SKPoint(10, 20);
      final p2 = SKPoint(5, 10);
      final result = p1 - p2;
      expect(result.x, 5);
      expect(result.y, 10);
    });

    test('should scale point', () {
      final point = SKPoint(10, 20);
      final scaled = point * 2;
      expect(scaled.x, 20);
      expect(scaled.y, 40);
    });

    test('should calculate length', () {
      final point = SKPoint(3, 4);
      expect(point.length, 5);
    });

    test('should calculate distance', () {
      final p1 = SKPoint(0, 0);
      final p2 = SKPoint(3, 4);
      expect(p1.distanceTo(p2), 5);
    });

    test('should normalize point', () {
      final point = SKPoint(3, 4);
      final normalized = point.normalize();
      expect(normalized.length, closeTo(1, 0.0001));
    });
  });

  group('SKRect', () {
    test('should create from LTRB', () {
      final rect = SKRect.fromLTRB(10, 20, 110, 120);
      expect(rect.left, 10);
      expect(rect.top, 20);
      expect(rect.right, 110);
      expect(rect.bottom, 120);
      expect(rect.width, 100);
      expect(rect.height, 100);
    });

    test('should create from XYWH', () {
      final rect = SKRect.fromXYWH(10, 20, 100, 100);
      expect(rect.left, 10);
      expect(rect.top, 20);
      expect(rect.width, 100);
      expect(rect.height, 100);
    });

    test('should create from center', () {
      final rect = SKRect.fromCenter(
        center: SKPoint(50, 50),
        halfWidth: 50,
        halfHeight: 50,
      );
      expect(rect.left, 0);
      expect(rect.top, 0);
      expect(rect.right, 100);
      expect(rect.bottom, 100);
    });

    test('should return center point', () {
      final rect = SKRect.fromLTRB(0, 0, 100, 100);
      final center = rect.center;
      expect(center.x, 50);
      expect(center.y, 50);
    });

    test('should inflate rect', () {
      final rect = SKRect.fromLTRB(10, 10, 20, 20);
      final inflated = rect.inflate(5, 5);
      expect(inflated.left, 5);
      expect(inflated.top, 5);
      expect(inflated.right, 25);
      expect(inflated.bottom, 25);
    });

    test('should offset rect', () {
      final rect = SKRect.fromLTRB(10, 10, 20, 20);
      final offset = rect.offset(5, 5);
      expect(offset.left, 15);
      expect(offset.top, 15);
      expect(offset.right, 25);
      expect(offset.bottom, 25);
    });

    test('should detect contains point', () {
      final rect = SKRect.fromLTRB(0, 0, 100, 100);
      expect(rect.contains(SKPoint(50, 50)), isTrue);
      expect(rect.contains(SKPoint(150, 50)), isFalse);
    });

    test('should detect intersection', () {
      final rect1 = SKRect.fromLTRB(0, 0, 100, 100);
      final rect2 = SKRect.fromLTRB(50, 50, 150, 150);
      final rect3 = SKRect.fromLTRB(200, 200, 300, 300);
      expect(rect1.intersects(rect2), isTrue);
      expect(rect1.intersects(rect3), isFalse);
    });
  });

  group('SKSize', () {
    test('should create size', () {
      final size = SKSize(100, 200);
      expect(size.width, 100);
      expect(size.height, 200);
    });

    test('empty should be zero', () {
      expect(SKSize.empty.width, 0);
      expect(SKSize.empty.height, 0);
      expect(SKSize.empty.isEmpty, isTrue);
    });

    test('should scale size', () {
      final size = SKSize(100, 200);
      final scaled = size.scale(2);
      expect(scaled.width, 200);
      expect(scaled.height, 400);
    });
  });

  group('SKPaint', () {
    test('should create paint', () {
      final paint = skia.createPaint();
      expect(paint.isDisposed, isFalse);
      paint.dispose();
      expect(paint.isDisposed, isTrue);
    });

    test('should set antialias', () {
      final paint = skia.createPaint();
      paint.isAntialias = true;
      expect(paint.isAntialias, isTrue);
      paint.isAntialias = false;
      expect(paint.isAntialias, isFalse);
      paint.dispose();
    });

    test('should set color', () {
      final paint = skia.createPaint();
      paint.color = SKColors.red;
      expect(paint.color.value, SKColors.red.value);
      paint.dispose();
    });

    test('should set style', () {
      final paint = skia.createPaint();
      paint.style = PaintStyle.stroke;
      expect(paint.style, PaintStyle.stroke);
      paint.style = PaintStyle.fill;
      expect(paint.style, PaintStyle.fill);
      paint.dispose();
    });

    test('should set stroke width', () {
      final paint = skia.createPaint();
      paint.strokeWidth = 5.0;
      expect(paint.strokeWidth, 5.0);
      paint.dispose();
    });

    test('should set stroke cap', () {
      final paint = skia.createPaint();
      paint.strokeCap = StrokeCap.round;
      expect(paint.strokeCap, StrokeCap.round);
      paint.dispose();
    });

    test('should set stroke join', () {
      final paint = skia.createPaint();
      paint.strokeJoin = StrokeJoin.round;
      expect(paint.strokeJoin, StrokeJoin.round);
      paint.dispose();
    });

    test('should clone paint', () {
      final paint = skia.createPaint()
        ..color = SKColors.blue
        ..strokeWidth = 3.0;
      final clone = paint.clone();
      expect(clone.color.value, SKColors.blue.value);
      expect(clone.strokeWidth, 3.0);
      paint.dispose();
      clone.dispose();
    });
  });

  group('SKSurface', () {
    test('should create surface', () {
      final surface = skia.createSurface(200, 200);
      expect(surface, isNotNull);
      expect(surface!.isDisposed, isFalse);
      surface.dispose();
      expect(surface.isDisposed, isTrue);
    });

    test('should return null for invalid dimensions', () {
      expect(skia.createSurface(0, 100), isNull);
      expect(skia.createSurface(100, 0), isNull);
      expect(skia.createSurface(-10, 100), isNull);
    });

    test('should get canvas from surface', () {
      final surface = skia.createSurface(100, 100)!;
      final canvas = surface.canvas;
      expect(canvas, isNotNull);
      surface.dispose();
    });

    test('should snapshot to image', () {
      final surface = skia.createSurface(100, 100)!;
      final canvas = surface.canvas;
      canvas.clear(SKColors.red);
      
      final image = surface.snapshot();
      expect(image, isNotNull);
      expect(image!.width, 100);
      expect(image.height, 100);
      
      image.dispose();
      surface.dispose();
    });
  });

  group('SKCanvas', () {
    late SKSurface surface;
    late SKCanvas canvas;

    setUp(() {
      surface = skia.createSurface(200, 200)!;
      canvas = surface.canvas;
    });

    tearDown(() {
      surface.dispose();
    });

    test('should clear canvas', () {
      canvas.clear(SKColors.white);
      // No exception means success
    });

    test('should save and restore state', () {
      final initialCount = canvas.saveCount;
      canvas.save();
      expect(canvas.saveCount, initialCount + 1);
      canvas.restore();
      expect(canvas.saveCount, initialCount);
    });

    test('should save and restore to count', () {
      final initialCount = canvas.saveCount;
      canvas.save();
      canvas.save();
      canvas.save();
      expect(canvas.saveCount, initialCount + 3);
      canvas.restoreToCount(initialCount);
      expect(canvas.saveCount, initialCount);
    });

    test('should translate canvas', () {
      canvas.translate(10, 20);
      // No exception means success
    });

    test('should scale canvas', () {
      canvas.scale(2, 2);
      // No exception means success
    });

    test('should rotate canvas', () {
      canvas.rotateDegrees(45);
      // No exception means success
    });

    test('should draw line', () {
      final paint = skia.createPaint()
        ..color = SKColors.black
        ..strokeWidth = 2;
      canvas.drawLine(0, 0, 100, 100, paint);
      paint.dispose();
    });

    test('should draw circle', () {
      final paint = skia.createPaint()
        ..color = SKColors.red
        ..style = PaintStyle.fill;
      canvas.drawCircle(100, 100, 50, paint);
      paint.dispose();
    });

    test('should draw rectangle', () {
      final paint = skia.createPaint()
        ..color = SKColors.blue
        ..style = PaintStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(SKRect.fromXYWH(10, 10, 80, 80), paint);
      paint.dispose();
    });

    test('should draw round rectangle', () {
      final paint = skia.createPaint()
        ..color = SKColors.green
        ..style = PaintStyle.fill;
      canvas.drawRoundRect(SKRect.fromXYWH(10, 10, 80, 80), 10, 10, paint);
      paint.dispose();
    });

    test('should draw oval', () {
      final paint = skia.createPaint()
        ..color = SKColors.orange
        ..style = PaintStyle.fill;
      canvas.drawOval(SKRect.fromXYWH(10, 10, 100, 50), paint);
      paint.dispose();
    });
  });

  group('SKPath', () {
    test('should create path', () {
      final path = skia.createPath();
      expect(path.isDisposed, isFalse);
      path.dispose();
    });

    test('should add line segment', () {
      final path = skia.createPath();
      path.moveTo(0, 0);
      path.lineTo(100, 100);
      // Path is not empty after adding segments
      path.dispose();
    });

    test('should add quadratic bezier', () {
      final path = skia.createPath();
      path.moveTo(0, 0);
      path.quadTo(50, 50, 100, 0);
      path.dispose();
    });

    test('should add cubic bezier', () {
      final path = skia.createPath();
      path.moveTo(0, 0);
      path.cubicTo(25, 50, 75, 50, 100, 0);
      path.dispose();
    });

    test('should close path', () {
      final path = skia.createPath();
      path.moveTo(0, 0);
      path.lineTo(100, 0);
      path.lineTo(100, 100);
      path.close();
      path.dispose();
    });

    test('should add rectangle', () {
      final path = skia.createPath();
      path.addRect(SKRect.fromXYWH(10, 10, 80, 80));
      path.dispose();
    });

    test('should add oval', () {
      final path = skia.createPath();
      path.addOval(SKRect.fromXYWH(10, 10, 80, 80));
      path.dispose();
    });

    test('should add circle', () {
      final path = skia.createPath();
      path.addCircle(50, 50, 40);
      path.dispose();
    });

    test('should add rounded rectangle', () {
      final path = skia.createPath();
      path.addRoundRect(SKRect.fromXYWH(10, 10, 80, 80), 10, 10);
      path.dispose();
    });

    test('should clone path', () {
      final path = skia.createPath();
      path.moveTo(0, 0);
      path.lineTo(100, 100);
      
      final clone = path.clone();
      // Clone should be independent copy
      expect(clone.isDisposed, isFalse);
      
      path.dispose();
      clone.dispose();
    });

    test('should reset path', () {
      final path = skia.createPath();
      path.moveTo(0, 0);
      path.lineTo(100, 100);
      
      // Reset clears the path
      path.reset();
      
      path.dispose();
    });

    test('should draw path on canvas', () {
      final surface = skia.createSurface(200, 200)!;
      final canvas = surface.canvas;
      
      final path = skia.createPath();
      path.moveTo(100, 10);
      path.lineTo(190, 90);
      path.lineTo(10, 90);
      path.close();
      
      final paint = skia.createPaint()
        ..color = SKColors.red
        ..style = PaintStyle.fill;
      
      canvas.drawPath(path, paint);
      
      paint.dispose();
      path.dispose();
      surface.dispose();
    });
  });

  group('SKBitmap', () {
    test('should create bitmap', () {
      final bitmap = skia.createBitmap(100, 100);
      expect(bitmap.isDisposed, isFalse);
      bitmap.dispose();
    });

    test('should erase bitmap', () {
      final bitmap = skia.createBitmap(100, 100);
      bitmap.erase(SKColors.blue);
      
      // Check pixel color
      final color = bitmap.getPixel(50, 50);
      // Note: Color might be premultiplied, just check it's not black
      expect(color.blue, greaterThan(0));
      
      bitmap.dispose();
    });

    test('should set immutable', () {
      final bitmap = skia.createBitmap(100, 100);
      expect(bitmap.isImmutable, isFalse);
      bitmap.setImmutable();
      expect(bitmap.isImmutable, isTrue);
      bitmap.dispose();
    });
  });

  group('Integration - Drawing', () {
    test('should draw shapes to surface', () {
      final surface = skia.createSurface(300, 300)!;
      final canvas = surface.canvas;

      // Clear with white background
      canvas.clear(SKColors.white);

      // Draw a red circle
      final redPaint = skia.createPaint()
        ..color = SKColors.red
        ..style = PaintStyle.fill
        ..isAntialias = true;
      canvas.drawCircle(100, 100, 50, redPaint);

      // Draw a blue rectangle
      final bluePaint = skia.createPaint()
        ..color = SKColors.blue
        ..style = PaintStyle.fill;
      canvas.drawRect(SKRect.fromXYWH(150, 150, 100, 100), bluePaint);

      // Draw a green line
      final greenPaint = skia.createPaint()
        ..color = SKColors.green
        ..style = PaintStyle.stroke
        ..strokeWidth = 5;
      canvas.drawLine(0, 0, 300, 300, greenPaint);

      // Cleanup
      redPaint.dispose();
      bluePaint.dispose();
      greenPaint.dispose();
      surface.dispose();
    });

    test('should draw heart shape', () {
      final surface = skia.createSurface(200, 200)!;
      final canvas = surface.canvas;
      canvas.clear(SKColors.white);

      final cx = 100.0;
      final cy = 100.0;
      final size = 60.0;

      final path = skia.createPath();
      path.moveTo(cx, cy + size * 0.3);

      // Left side curve
      path.cubicTo(
        cx - size * 0.5, cy - size * 0.3,
        cx - size, cy - size * 0.2,
        cx, cy - size * 0.8,
      );

      // Right side curve
      path.cubicTo(
        cx + size, cy - size * 0.2,
        cx + size * 0.5, cy - size * 0.3,
        cx, cy + size * 0.3,
      );

      path.close();

      final paint = skia.createPaint()
        ..color = SKColor.fromRGB(255, 0, 80)
        ..style = PaintStyle.fill
        ..isAntialias = true;

      canvas.drawPath(path, paint);

      // Save test output
      final image = surface.snapshot();
      expect(image, isNotNull);

      paint.dispose();
      path.dispose();
      image?.dispose();
      surface.dispose();
    });

    test('should draw spiral', () {
      final surface = skia.createSurface(300, 300)!;
      final canvas = surface.canvas;
      canvas.clear(SKColors.white);

      final cx = 150.0;
      final cy = 150.0;
      final innerR = 10.0;
      final outerR = 120.0;
      final turns = 6;
      final steps = turns * 36;

      final path = skia.createPath();

      for (var i = 0; i <= steps; i++) {
        final t = i / steps;
        final angle = t * turns * 2 * math.pi;
        final r = innerR + (outerR - innerR) * t;
        final x = cx + r * math.cos(angle);
        final y = cy + r * math.sin(angle);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      final paint = skia.createPaint()
        ..color = SKColors.purple
        ..style = PaintStyle.stroke
        ..strokeWidth = 3
        ..isAntialias = true;

      canvas.drawPath(path, paint);

      paint.dispose();
      path.dispose();
      surface.dispose();
    });

    test('should draw with transformations', () {
      final surface = skia.createSurface(300, 300)!;
      final canvas = surface.canvas;
      canvas.clear(SKColors.white);

      final paint = skia.createPaint()
        ..color = SKColors.blue
        ..style = PaintStyle.fill;

      // Draw original rectangle
      canvas.drawRect(SKRect.fromXYWH(50, 50, 50, 50), paint);

      // Save, transform, draw, restore
      canvas.save();
      canvas.translate(150, 150);
      canvas.rotateDegrees(45);
      paint.color = SKColors.red;
      canvas.drawRect(SKRect.fromXYWH(-25, -25, 50, 50), paint);
      canvas.restore();

      // Draw another rectangle at original position
      paint.color = SKColors.green;
      canvas.drawRect(SKRect.fromXYWH(200, 50, 50, 50), paint);

      paint.dispose();
      surface.dispose();
    });
  });

  group('SKImage', () {
    test('should get image dimensions', () {
      final surface = skia.createSurface(320, 240)!;
      final canvas = surface.canvas;
      canvas.clear(SKColors.cyan);

      final image = surface.snapshot();
      expect(image, isNotNull);
      expect(image!.width, 320);
      expect(image.height, 240);
      expect(image.size, SKSizeI(320, 240));
      expect(image.uniqueId, isPositive);

      image.dispose();
      surface.dispose();
    });
  });

  // TODO: SKImageInfo not exposed in new OOP API
  // group('SKImageInfo', () {
  //   test('should calculate byte sizes', () {
  //     final info = SKImageInfo(100, 100);
  //     expect(info.width, 100);
  //     expect(info.height, 100);
  //     expect(info.bytesPerPixel, 4);
  //     expect(info.rowBytes, 400);
  //     expect(info.byteSize, 40000);
  //   });

  //   test('should detect empty', () {
  //     final info = SKImageInfo(0, 0);
  //     expect(info.isEmpty, isTrue);

  //     final valid = SKImageInfo(100, 100);
  //     expect(valid.isEmpty, isFalse);
  //   });
  // });

  // ═══════════════════════════════════════════════════════════
  // Font and Text Tests
  // ═══════════════════════════════════════════════════════════

  group('SKTypeface', () {
    const liberationSansPath = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSans-Regular.ttf';
    // ignore: unused_local_variable
    const liberationSerifPath = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSerif-Regular.ttf';
    const liberationMonoPath = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationMono-Regular.ttf';

    test('should load typeface from file', () {
      final typeface = skia.loadTypeface(liberationSansPath);
      expect(typeface, isNotNull);
      expect(typeface!.isDisposed, isFalse);
      expect(typeface.glyphCount, greaterThan(0));
      typeface.dispose();
    });

    test('should return null for invalid file', () {
      final typeface = skia.loadTypeface('nonexistent.ttf');
      expect(typeface, isNull);
    });

    test('should get typeface properties', () {
      final typeface = skia.loadTypeface(liberationSansPath);
      expect(typeface, isNotNull);
      
      expect(typeface!.glyphCount, greaterThan(200)); // Liberation Sans has many glyphs
      expect(typeface.unitsPerEm, greaterThan(0));
      expect(typeface.tableCount, greaterThan(0));
      
      typeface.dispose();
    });

    test('should detect fixed pitch font', () {
      final monoTypeface = skia.loadTypeface(liberationMonoPath);
      expect(monoTypeface, isNotNull);
      expect(monoTypeface!.isFixedPitch, isTrue);
      monoTypeface.dispose();

      final sansTypeface = skia.loadTypeface(liberationSansPath);
      expect(sansTypeface, isNotNull);
      expect(sansTypeface!.isFixedPitch, isFalse);
      sansTypeface.dispose();
    });

    test('should get font weight', () {
      final typeface = skia.loadTypeface(liberationSansPath);
      expect(typeface, isNotNull);
      // Regular weight is typically 400
      expect(typeface!.fontWeight, greaterThan(0));
      typeface.dispose();
    });

    test('should convert unichar to glyph', () {
      final typeface = skia.loadTypeface(liberationSansPath);
      expect(typeface, isNotNull);
      
      // 'A' = 65
      final glyphA = typeface!.unicharToGlyph(65);
      expect(glyphA, greaterThan(0));
      
      // 'B' = 66
      final glyphB = typeface.unicharToGlyph(66);
      expect(glyphB, greaterThan(0));
      expect(glyphB, isNot(glyphA)); // Different glyphs
      
      typeface.dispose();
    });

    test('should create default typeface', () {
      final typeface = skia.createDefaultTypeface();
      expect(typeface, isNotNull);
      expect(typeface!.glyphCount, greaterThan(0));
      typeface.dispose();
    });
  });

  group('SKFont', () {
    const liberationSansPath = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSans-Regular.ttf';

    test('should create default font', () {
      final font = skia.createFont();
      expect(font.isDisposed, isFalse);
      expect(font.size, greaterThan(0));
      font.dispose();
    });

    test('should create font from typeface', () {
      final typeface = skia.loadTypeface(liberationSansPath)!;
      final font = skia.createFontFromTypeface(typeface, size: 24);
      
      expect(font.size, 24);
      font.dispose();
      typeface.dispose();
    });

    test('should set and get font size', () {
      final font = skia.createFont();
      font.size = 48;
      expect(font.size, 48);
      font.dispose();
    });

    test('should set and get scale X', () {
      final font = skia.createFont();
      font.scaleX = 1.5;
      expect(font.scaleX, closeTo(1.5, 0.01));
      font.dispose();
    });

    test('should set and get skew X', () {
      final font = skia.createFont();
      font.skewX = -0.25;
      expect(font.skewX, closeTo(-0.25, 0.01));
      font.dispose();
    });

    test('should set and get subpixel', () {
      final font = skia.createFont();
      font.isSubpixel = true;
      expect(font.isSubpixel, isTrue);
      font.isSubpixel = false;
      expect(font.isSubpixel, isFalse);
      font.dispose();
    });

    // TODO: Add isEmbolden, isLinearMetrics to SkiaFont API
    // test('should set and get embolden', () {
    //   final font = skia.createFont();
    //   font.isEmbolden = true;
    //   expect(font.isEmbolden, isTrue);
    //   font.isEmbolden = false;
    //   expect(font.isEmbolden, isFalse);
    //   font.dispose();
    // });

    // test('should set and get linear metrics', () {
    //   final font = skia.createFont();
    //   font.isLinearMetrics = true;
    //   expect(font.isLinearMetrics, isTrue);
    //   font.isLinearMetrics = false;
    //   expect(font.isLinearMetrics, isFalse);
    //   font.dispose();
    // });

    // test('should get typeface from font', () {
    //   final typeface = skia.loadTypeface(liberationSansPath)!;
    //   final font = skia.createFontFromTypeface(typeface, size: 24);
    //   
    //   final retrievedTypeface = font.typeface;
    //   expect(retrievedTypeface, isNotNull);
    //   
    //   font.dispose();
    //   typeface.dispose();
    // });

    // test('should convert unichar to glyph', () {
    //   final typeface = skia.loadTypeface(liberationSansPath)!;
    //   final font = skia.createFontFromTypeface(typeface, size: 24);
    //   
    //   final glyph = font.unicharToGlyph(65); // 'A'
    //   expect(glyph, greaterThan(0));
    //   
    //   font.dispose();
    //   typeface.dispose();
    // });
  });

  group('Text Drawing', () {
    const liberationSansPath = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSans-Regular.ttf';
    const liberationSerifPath = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSerif-Regular.ttf';
    const liberationSansBoldPath = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSans-Bold.ttf';

    test('should draw simple text', () {
      final surface = skia.createSurface(400, 200)!;
      final canvas = surface.canvas;
      canvas.clear(SKColors.white);

      final typeface = skia.loadTypeface(liberationSansPath)!;
      final font = skia.createFontFromTypeface(typeface, size: 32);
      
      final paint = skia.createPaint()
        ..color = SKColors.black
        ..isAntialias = true;

      canvas.drawSimpleText('Hello, Skia!', 20, 100, font, paint);

      paint.dispose();
      font.dispose();
      typeface.dispose();
      surface.dispose();
    });

    test('should draw text with different sizes', () {
      final surface = skia.createSurface(400, 300)!;
      final canvas = surface.canvas;
      canvas.clear(SKColors.white);

      final typeface = skia.loadTypeface(liberationSansPath)!;
      final paint = skia.createPaint()
        ..color = SKColors.black
        ..isAntialias = true;

      // Draw text at different sizes
      for (var size in [12.0, 18.0, 24.0, 36.0, 48.0]) {
        final font = skia.createFontFromTypeface(typeface, size: size);
        final y = 20 + (size * 1.5);
        canvas.drawSimpleText('Size ${size.toInt()}', 20, y, font, paint);
        font.dispose();
      }

      paint.dispose();
      typeface.dispose();
      surface.dispose();
    });

    test('should draw text with different colors', () {
      final surface = skia.createSurface(400, 200)!;
      final canvas = surface.canvas;
      canvas.clear(SKColors.white);

      final typeface = skia.loadTypeface(liberationSansPath)!;
      final font = skia.createFontFromTypeface(typeface, size: 24);

      final colors = [
        SKColors.red,
        SKColors.green,
        SKColors.blue,
        SKColors.orange,
        SKColors.purple,
      ];

      var y = 40.0;
      for (var color in colors) {
        final paint = skia.createPaint()
          ..color = color
          ..isAntialias = true;
        canvas.drawSimpleText('Colored Text', 20, y, font, paint);
        paint.dispose();
        y += 30;
      }

      font.dispose();
      typeface.dispose();
      surface.dispose();
    });

    test('should draw text with multiple fonts', () {
      final surface = skia.createSurface(400, 200)!;
      final canvas = surface.canvas;
      canvas.clear(SKColors.white);

      final paint = skia.createPaint()
        ..color = SKColors.black
        ..isAntialias = true;

      // Sans
      final sansTypeface = skia.loadTypeface(liberationSansPath)!;
      final sansFont = skia.createFontFromTypeface(sansTypeface, size: 24);
      canvas.drawSimpleText('Liberation Sans', 20, 50, sansFont, paint);

      // Serif
      final serifTypeface = skia.loadTypeface(liberationSerifPath)!;
      final serifFont = skia.createFontFromTypeface(serifTypeface, size: 24);
      canvas.drawSimpleText('Liberation Serif', 20, 100, serifFont, paint);

      // Bold
      final boldTypeface = skia.loadTypeface(liberationSansBoldPath)!;
      final boldFont = skia.createFontFromTypeface(boldTypeface, size: 24);
      canvas.drawSimpleText('Liberation Sans Bold', 20, 150, boldFont, paint);

      paint.dispose();
      sansFont.dispose();
      serifFont.dispose();
      boldFont.dispose();
      sansTypeface.dispose();
      serifTypeface.dispose();
      boldTypeface.dispose();
      surface.dispose();
    });

    // TODO: isEmbolden not implemented in SkiaFont
    // test('should draw text with synthetic bold (embolden)', () {
    //   final surface = skia.createSurface(400, 150)!;
    //   final canvas = surface.canvas;
    //   canvas.clear(SKColors.white);

    //   final typeface = skia.loadTypeface(liberationSansPath)!;
    //   final paint = skia.createPaint()
    //     ..color = SKColors.black
    //     ..isAntialias = true;

    //   // Regular
    //   final regularFont = skia.createFontFromTypeface(typeface, size: 24);
    //   canvas.drawSimpleText('Regular Text', 20, 50, regularFont, paint);

    //   // Synthetic bold
    //   final boldFont = skia.createFontFromTypeface(typeface, size: 24)
    //     ..isEmbolden = true;
    //   canvas.drawSimpleText('Emboldened Text', 20, 100, boldFont, paint);

    //   paint.dispose();
    //   regularFont.dispose();
    //   boldFont.dispose();
    //   typeface.dispose();
    //   surface.dispose();
    // });

    test('should draw text with synthetic italic (skew)', () {
      final surface = skia.createSurface(400, 150)!;
      final canvas = surface.canvas;
      canvas.clear(SKColors.white);

      final typeface = skia.loadTypeface(liberationSansPath)!;
      final paint = skia.createPaint()
        ..color = SKColors.black
        ..isAntialias = true;

      // Regular
      final regularFont = skia.createFontFromTypeface(typeface, size: 24);
      canvas.drawSimpleText('Regular Text', 20, 50, regularFont, paint);

      // Synthetic italic
      final italicFont = skia.createFontFromTypeface(typeface, size: 24)
        ..skewX = -0.25; // Negative skew = italic appearance
      canvas.drawSimpleText('Skewed (Italic)', 20, 100, italicFont, paint);

      paint.dispose();
      regularFont.dispose();
      italicFont.dispose();
      typeface.dispose();
      surface.dispose();
    });
  });

  // TODO: SKTextBlobBuilder not exposed in new OOP API
  // group('SKTextBlobBuilder', () {
  //   test('should create text blob builder', () {
  //     final builder = SKTextBlobBuilder();
  //     expect(builder.isDisposed, isFalse);
  //     builder.dispose();
  //   });
  // });
}

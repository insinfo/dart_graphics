// Tests for Complex Shape Rendering
// Ported to Dart by insinfo, 2025

import 'dart:io';
import 'dart:math' as math;
import 'package:test/test.dart';
import 'package:dart_graphics/src/agg/image/image_buffer.dart';
import 'package:dart_graphics/src/agg/image/png_encoder.dart';
import 'package:dart_graphics/src/agg/primitives/color.dart';
import 'package:dart_graphics/src/agg/scanline_rasterizer.dart';
import 'package:dart_graphics/src/agg/scanline_renderer.dart';
import 'package:dart_graphics/src/agg/scanline_packed8.dart';
import 'package:dart_graphics/src/agg/transform/affine.dart';
import 'package:dart_graphics/src/agg/vertex_source/apply_transform.dart';
import 'package:dart_graphics/src/agg/vertex_source/vertex_storage.dart';
import 'package:dart_graphics/src/agg/vertex_source/ellipse.dart';
import 'package:dart_graphics/src/agg/vertex_source/rounded_rect.dart';
import 'package:dart_graphics/src/agg/vertex_source/stroke.dart';
import 'package:dart_graphics/src/agg/agg_basics.dart';

void main() {
  setUpAll(() {
    Directory('test/tmp').createSync(recursive: true);
  });

  group('Complex Shapes', () {
    test('Star shape', () {
      final buffer = ImageBuffer(200, 200);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final star = _createStar(100, 100, 80, 40, 5);

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      ras.add_path(star);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(255, 200, 0, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/shape_star.png');
      expect(File('test/tmp/shape_star.png').existsSync(), isTrue);
      expect(_hasNonWhitePixels(buffer), isTrue);
    });

    test('Spiral shape', () {
      final buffer = ImageBuffer(300, 300);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final spiral = _createSpiral(150, 150, 10, 120, 6);
      final stroke = Stroke(spiral);
      stroke.width = 2.0;

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      ras.add_path(stroke);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(0, 100, 200, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/shape_spiral.png');
      expect(File('test/tmp/shape_spiral.png').existsSync(), isTrue);
    });

    test('Bezier curves', () {
      final buffer = ImageBuffer(400, 300);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final path = VertexStorage();

      // Quadratic bezier
      path.moveTo(50, 200);
      path.curve3(200, 50, 350, 200);

      // Cubic bezier
      path.moveTo(50, 250);
      path.curve4(100, 100, 300, 100, 350, 250);

      final stroke = Stroke(path);
      stroke.width = 3.0;

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      ras.add_path(stroke);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(200, 0, 100, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/shape_bezier.png');
      expect(File('test/tmp/shape_bezier.png').existsSync(), isTrue);
    });

    test('Concentric circles', () {
      final buffer = ImageBuffer(300, 300);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      // Draw concentric circles with alternating colors
      for (var i = 10; i > 0; i--) {
        final radius = i * 14.0;
        final ellipse = Ellipse(150, 150, radius, radius);

        final color = (i % 2 == 0)
            ? Color(100, 150, 200, 255)
            : Color(200, 150, 100, 255);

        ras.add_path(ellipse);
        ScanlineRenderer.renderSolid(ras, sl, buffer, color);
      }

      PngEncoder.saveImage(buffer, 'test/tmp/shape_concentric.png');
      expect(File('test/tmp/shape_concentric.png').existsSync(), isTrue);
    });

    test('Pie chart', () {
      final buffer = ImageBuffer(300, 300);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      final colors = [
        Color(255, 100, 100, 255), // Red
        Color(100, 255, 100, 255), // Green
        Color(100, 100, 255, 255), // Blue
        Color(255, 255, 100, 255), // Yellow
        Color(255, 100, 255, 255), // Magenta
      ];

      final values = [30.0, 25.0, 20.0, 15.0, 10.0];
      var startAngle = 0.0;

      for (var i = 0; i < values.length; i++) {
        final sweepAngle = values[i] / 100.0 * 2 * math.pi;
        final slice = _createPieSlice(150, 150, 100, startAngle, sweepAngle);

        ras.add_path(slice);
        ScanlineRenderer.renderSolid(ras, sl, buffer, colors[i]);

        startAngle += sweepAngle;
      }

      PngEncoder.saveImage(buffer, 'test/tmp/shape_pie.png');
      expect(File('test/tmp/shape_pie.png').existsSync(), isTrue);
    });

    test('Arrow shape', () {
      final buffer = ImageBuffer(300, 150);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final arrow = _createArrow(50, 75, 250, 75, 20, 40);

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      ras.add_path(arrow);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(0, 128, 0, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/shape_arrow.png');
      expect(File('test/tmp/shape_arrow.png').existsSync(), isTrue);
    });

    test('Polygon with hole (even-odd)', () {
      final buffer = ImageBuffer(200, 200);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final path = VertexStorage();

      // Outer square
      path.moveTo(20, 20);
      path.lineTo(180, 20);
      path.lineTo(180, 180);
      path.lineTo(20, 180);
      path.closePath();

      // Inner square (hole)
      path.moveTo(60, 60);
      path.lineTo(60, 140);
      path.lineTo(140, 140);
      path.lineTo(140, 60);
      path.closePath();

      final ras = ScanlineRasterizer();
      ras.filling_rule(filling_rule_e.fill_even_odd);
      final sl = ScanlineCachePacked8();

      ras.add_path(path);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(100, 100, 200, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/shape_hole.png');
      expect(File('test/tmp/shape_hole.png').existsSync(), isTrue);
    });

    test('Rounded rectangles', () {
      final buffer = ImageBuffer(400, 300);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      // Different corner radii
      final rect1 = RoundedRect(20, 20, 180, 100, 5);
      final rect2 = RoundedRect(200, 20, 380, 100, 15);
      final rect3 = RoundedRect(20, 120, 180, 200, 25);
      final rect4 = RoundedRect(200, 120, 380, 200, 35);

      ras.add_path(rect1);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(255, 150, 150, 255));

      ras.add_path(rect2);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(150, 255, 150, 255));

      ras.add_path(rect3);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(150, 150, 255, 255));

      ras.add_path(rect4);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(255, 255, 150, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/shape_rounded_rects.png');
      expect(File('test/tmp/shape_rounded_rects.png').existsSync(), isTrue);
    });

    test('Stroked shapes with different widths', () {
      final buffer = ImageBuffer(400, 200);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      // Different stroke widths
      for (var i = 0; i < 5; i++) {
        final ellipse = Ellipse(80.0 + i * 80, 100, 30, 30);
        final stroke = Stroke(ellipse);
        stroke.width = (i + 1) * 2.0;

        ras.add_path(stroke);
        ScanlineRenderer.renderSolid(ras, sl, buffer, Color(0, 0, 0, 255));
      }

      PngEncoder.saveImage(buffer, 'test/tmp/shape_strokes.png');
      expect(File('test/tmp/shape_strokes.png').existsSync(), isTrue);
    });

    test('Transformed shapes', () {
      final buffer = ImageBuffer(400, 400);
      _clearBuffer(buffer, Color(240, 240, 240, 255));

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      // Base square
      final square = VertexStorage();
      square.moveTo(-30, -30);
      square.lineTo(30, -30);
      square.lineTo(30, 30);
      square.lineTo(-30, 30);
      square.closePath();

      // Draw rotated squares
      for (var i = 0; i < 12; i++) {
        final angle = i * math.pi / 6;
        final mtx = Affine.identity();
        mtx.rotate(angle);
        mtx.translate(200, 200);

        final transformed = ApplyTransform(square, mtx);

        final hue = (i / 12.0);
        final color = _hsvToRgb(hue, 0.7, 0.9);

        ras.add_path(transformed);
        ScanlineRenderer.renderSolid(ras, sl, buffer, color);
      }

      PngEncoder.saveImage(buffer, 'test/tmp/shape_transformed.png');
      expect(File('test/tmp/shape_transformed.png').existsSync(), isTrue);
    });

    test('Heart shape', () {
      final buffer = ImageBuffer(200, 200);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final heart = _createHeart(100, 100, 60);

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      ras.add_path(heart);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(255, 0, 80, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/shape_heart.png');
      expect(File('test/tmp/shape_heart.png').existsSync(), isTrue);
    });
  });

  group('Anti-aliasing Quality', () {
    test('Diagonal lines AA comparison', () {
      final buffer = ImageBuffer(200, 200);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final path = VertexStorage();

      // Draw multiple diagonal lines
      for (var i = 0; i < 10; i++) {
        path.moveTo(10 + i * 20.0, 10);
        path.lineTo(20 + i * 20.0, 190);
      }

      final stroke = Stroke(path);
      stroke.width = 1.0;

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      ras.add_path(stroke);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(0, 0, 0, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/aa_diagonals.png');
      expect(File('test/tmp/aa_diagonals.png').existsSync(), isTrue);
    });

    test('Small circles AA', () {
      final buffer = ImageBuffer(200, 200);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      // Various small circle sizes (matching Cairo golden)
      for (var i = 0; i < 5; i++) {
        for (var j = 0; j < 5; j++) {
          final radius = (i + 1) * 2.0;
          final ellipse = Ellipse(20.0 + i * 40, 20.0 + j * 40, radius, radius);
          ras.add_path(ellipse);
          ScanlineRenderer.renderSolid(ras, sl, buffer, Color(0, 0, 0, 255));
        }
      }

      PngEncoder.saveImage(buffer, 'test/tmp/aa_small_circles.png');
      expect(File('test/tmp/aa_small_circles.png').existsSync(), isTrue);
    });

    test('Thin strokes AA', () {
      final buffer = ImageBuffer(300, 200);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      // Draw lines with different sub-pixel widths
      final widths = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

      for (var i = 0; i < widths.length; i++) {
        final path = VertexStorage();
        path.moveTo(20, 30.0 + i * 20);
        path.lineTo(280, 30.0 + i * 20);

        final stroke = Stroke(path);
        stroke.width = widths[i];

        ras.add_path(stroke);
        ScanlineRenderer.renderSolid(ras, sl, buffer, Color(0, 0, 0, 255));
      }

      PngEncoder.saveImage(buffer, 'test/tmp/aa_thin_strokes.png');
      expect(File('test/tmp/aa_thin_strokes.png').existsSync(), isTrue);
    });
  });
}

void _clearBuffer(ImageBuffer buffer, Color color) {
  for (var y = 0; y < buffer.height; y++) {
    for (var x = 0; x < buffer.width; x++) {
      buffer.SetPixel(x, y, color);
    }
  }
}

bool _hasNonWhitePixels(ImageBuffer buffer) {
  for (var y = 0; y < buffer.height; y++) {
    for (var x = 0; x < buffer.width; x++) {
      final c = buffer.getPixel(x, y);
      if (c.red < 255 || c.green < 255 || c.blue < 255) {
        return true;
      }
    }
  }
  return false;
}

VertexStorage _createStar(
  double cx,
  double cy,
  double outerR,
  double innerR,
  int points,
) {
  final path = VertexStorage();
  final angleStep = math.pi / points;

  for (var i = 0; i < points * 2; i++) {
    final angle = i * angleStep - math.pi / 2;
    final r = (i % 2 == 0) ? outerR : innerR;
    final x = cx + r * math.cos(angle);
    final y = cy + r * math.sin(angle);

    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }

  path.closePath();
  return path;
}

VertexStorage _createSpiral(
  double cx,
  double cy,
  double innerR,
  double outerR,
  int turns,
) {
  final path = VertexStorage();
  final steps = turns * 36; // 10 degrees per step

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

  return path;
}

VertexStorage _createPieSlice(
  double cx,
  double cy,
  double radius,
  double startAngle,
  double sweepAngle,
) {
  final path = VertexStorage();
  final steps = (sweepAngle.abs() * 20).ceil().clamp(4, 100);

  // Start at center
  path.moveTo(cx, cy);

  // Arc
  for (var i = 0; i <= steps; i++) {
    final t = i / steps;
    final angle = startAngle + sweepAngle * t;
    final x = cx + radius * math.cos(angle);
    final y = cy + radius * math.sin(angle);
    path.lineTo(x, y);
  }

  path.closePath();
  return path;
}

VertexStorage _createArrow(
  double x1,
  double y1,
  double x2,
  double y2,
  double shaftWidth,
  double headWidth,
) {
  final path = VertexStorage();

  final dx = x2 - x1;
  final dy = y2 - y1;
  final length = math.sqrt(dx * dx + dy * dy);
  final ux = dx / length;
  final uy = dy / length;
  final px = -uy;
  final py = ux;

  final headLength = headWidth * 1.5;

  // Shaft
  path.moveTo(x1 + px * shaftWidth / 2, y1 + py * shaftWidth / 2);
  path.lineTo(
      x2 - ux * headLength + px * shaftWidth / 2, y2 - uy * headLength + py * shaftWidth / 2);
  // Head base left
  path.lineTo(x2 - ux * headLength + px * headWidth / 2, y2 - uy * headLength + py * headWidth / 2);
  // Head tip
  path.lineTo(x2, y2);
  // Head base right
  path.lineTo(
      x2 - ux * headLength - px * headWidth / 2, y2 - uy * headLength - py * headWidth / 2);
  // Back to shaft
  path.lineTo(
      x2 - ux * headLength - px * shaftWidth / 2, y2 - uy * headLength - py * shaftWidth / 2);
  path.lineTo(x1 - px * shaftWidth / 2, y1 - py * shaftWidth / 2);

  path.closePath();
  return path;
}

VertexStorage _createHeart(double cx, double cy, double size) {
  final path = VertexStorage();

  // Heart shape using bezier curves
  path.moveTo(cx, cy + size * 0.3);

  // Left side
  path.curve4(cx - size * 0.5, cy - size * 0.3, cx - size, cy - size * 0.2, cx, cy - size * 0.8);

  // Right side
  path.curve4(cx + size, cy - size * 0.2, cx + size * 0.5, cy - size * 0.3, cx, cy + size * 0.3);

  path.closePath();
  return path;
}

Color _hsvToRgb(double h, double s, double v) {
  final hi = (h * 6).floor() % 6;
  final f = h * 6 - hi.floor();
  final p = v * (1 - s);
  final q = v * (1 - f * s);
  final t = v * (1 - (1 - f) * s);

  double r, g, b;
  switch (hi) {
    case 0:
      r = v;
      g = t;
      b = p;
    case 1:
      r = q;
      g = v;
      b = p;
    case 2:
      r = p;
      g = v;
      b = t;
    case 3:
      r = p;
      g = q;
      b = v;
    case 4:
      r = t;
      g = p;
      b = v;
    default:
      r = v;
      g = p;
      b = q;
  }

  return Color((r * 255).round(), (g * 255).round(), (b * 255).round(), 255);
}

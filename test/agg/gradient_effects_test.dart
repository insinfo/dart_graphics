// Tests for Gradient and Effect Rendering
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
import 'package:dart_graphics/src/agg/spans/span_gradient.dart';
import 'package:dart_graphics/src/agg/spans/span_gouraud_rgba.dart';
import 'package:dart_graphics/src/agg/vertex_source/ellipse.dart';
import 'package:dart_graphics/src/agg/vertex_source/rounded_rect.dart';

void main() {
  setUpAll(() {
    Directory('test/tmp').createSync(recursive: true);
  });

  group('Gradient Rendering', () {
    test('Linear gradient horizontal', () {
      final buffer = ImageBuffer(300, 100);
      _fillWithLinearGradient(
        buffer,
        0,
        50,
        300,
        50,
        [
          (offset: 0.0, color: Color(255, 0, 0, 255)),
          (offset: 0.5, color: Color(255, 255, 0, 255)),
          (offset: 1.0, color: Color(0, 255, 0, 255)),
        ],
      );

      PngEncoder.saveImage(buffer, 'test/tmp/gradient_linear_h.png');
      expect(File('test/tmp/gradient_linear_h.png').existsSync(), isTrue);
      expect(_hasMultipleColors(buffer), isTrue);
    });

    test('Linear gradient vertical', () {
      final buffer = ImageBuffer(100, 300);
      _fillWithLinearGradient(
        buffer,
        50,
        0,
        50,
        300,
        [
          (offset: 0.0, color: Color(0, 0, 255, 255)),
          (offset: 1.0, color: Color(255, 0, 255, 255)),
        ],
      );

      PngEncoder.saveImage(buffer, 'test/tmp/gradient_linear_v.png');
      expect(File('test/tmp/gradient_linear_v.png').existsSync(), isTrue);
    });

    test('Linear gradient diagonal', () {
      final buffer = ImageBuffer(200, 200);
      _fillWithLinearGradient(
        buffer,
        0,
        0,
        200,
        200,
        [
          (offset: 0.0, color: Color(100, 200, 255, 255)),
          (offset: 1.0, color: Color(255, 100, 50, 255)),
        ],
      );

      PngEncoder.saveImage(buffer, 'test/tmp/gradient_linear_diag.png');
      expect(File('test/tmp/gradient_linear_diag.png').existsSync(), isTrue);
    });

    test('Radial gradient', () {
      final buffer = ImageBuffer(200, 200);
      _fillWithRadialGradient(
        buffer,
        100,
        100,
        100,
        [
          (offset: 0.0, color: Color(255, 255, 255, 255)),
          (offset: 0.5, color: Color(255, 200, 100, 255)),
          (offset: 1.0, color: Color(100, 50, 0, 255)),
        ],
      );

      PngEncoder.saveImage(buffer, 'test/tmp/gradient_radial.png');
      expect(File('test/tmp/gradient_radial.png').existsSync(), isTrue);
    });

    test('Linear gradient multi-stop', () {
      final buffer = ImageBuffer(400, 100);
      _fillWithLinearGradient(
        buffer,
        0,
        50,
        400,
        50,
        [
          (offset: 0.0, color: Color(255, 0, 0, 255)),
          (offset: 0.2, color: Color(255, 127, 0, 255)),
          (offset: 0.4, color: Color(255, 255, 0, 255)),
          (offset: 0.6, color: Color(0, 255, 0, 255)),
          (offset: 0.8, color: Color(0, 0, 255, 255)),
          (offset: 1.0, color: Color(127, 0, 255, 255)),
        ],
      );

      PngEncoder.saveImage(buffer, 'test/tmp/gradient_rainbow.png');
      expect(File('test/tmp/gradient_rainbow.png').existsSync(), isTrue);
    });
  });

  group('Gouraud Shading', () {
    test('Gouraud triangle basic', () {
      final buffer = ImageBuffer(200, 200);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      _renderGouraudTriangle(
        buffer,
        100,
        20,
        Color(255, 0, 0, 255), // Red at top
        20,
        180,
        Color(0, 255, 0, 255), // Green at bottom-left
        180,
        180,
        Color(0, 0, 255, 255), // Blue at bottom-right
      );

      PngEncoder.saveImage(buffer, 'test/tmp/gouraud_triangle.png');
      expect(File('test/tmp/gouraud_triangle.png').existsSync(), isTrue);
    });

    test('Gouraud grayscale triangle', () {
      final buffer = ImageBuffer(200, 200);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      _renderGouraudTriangle(
        buffer,
        100,
        20,
        Color(0, 0, 0, 255), // Black at top
        20,
        180,
        Color(128, 128, 128, 255), // Gray at bottom-left
        180,
        180,
        Color(255, 255, 255, 255), // White at bottom-right
      );

      PngEncoder.saveImage(buffer, 'test/tmp/gouraud_grayscale.png');
      expect(File('test/tmp/gouraud_grayscale.png').existsSync(), isTrue);
    });

    test('Multiple Gouraud triangles (mesh)', () {
      final buffer = ImageBuffer(300, 300);
      _clearBuffer(buffer, Color(50, 50, 50, 255));

      // Create a simple quad from two triangles
      // Top-left triangle
      _renderGouraudTriangle(
        buffer,
        50,
        50,
        Color(255, 0, 0, 255),
        250,
        50,
        Color(0, 255, 0, 255),
        50,
        250,
        Color(0, 0, 255, 255),
      );

      // Bottom-right triangle
      _renderGouraudTriangle(
        buffer,
        250,
        50,
        Color(0, 255, 0, 255),
        250,
        250,
        Color(255, 255, 0, 255),
        50,
        250,
        Color(0, 0, 255, 255),
      );

      PngEncoder.saveImage(buffer, 'test/tmp/gouraud_mesh.png');
      expect(File('test/tmp/gouraud_mesh.png').existsSync(), isTrue);
    });
  });

  group('Color Blending', () {
    test('Alpha blending', () {
      final buffer = ImageBuffer(200, 200);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      // Draw overlapping semi-transparent circles
      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      final colors = [
        Color(255, 0, 0, 128), // Semi-transparent red
        Color(0, 255, 0, 128), // Semi-transparent green
        Color(0, 0, 255, 128), // Semi-transparent blue
      ];

      final positions = [
        (x: 80.0, y: 80.0),
        (x: 120.0, y: 80.0),
        (x: 100.0, y: 120.0),
      ];

      for (int i = 0; i < 3; i++) {
        final ellipse = Ellipse(positions[i].x, positions[i].y, 60, 60);
        ras.add_path(ellipse);
        ScanlineRenderer.renderSolid(ras, sl, buffer, colors[i]);
      }

      PngEncoder.saveImage(buffer, 'test/tmp/alpha_blending.png');
      expect(File('test/tmp/alpha_blending.png').existsSync(), isTrue);
    });

    test('Layered shapes with transparency', () {
      final buffer = ImageBuffer(300, 200);
      _clearBuffer(buffer, Color(240, 240, 240, 255));

      final ras = ScanlineRasterizer();
      final sl = ScanlineCachePacked8();

      // Background rectangle
      final rect1 = RoundedRect(20, 20, 180, 180, 10);
      ras.add_path(rect1);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(100, 150, 200, 255));

      // Overlapping semi-transparent rectangle
      final rect2 = RoundedRect(100, 40, 280, 160, 10);
      ras.add_path(rect2);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(255, 200, 100, 180));

      // Another layer
      final ellipse = Ellipse(150, 100, 80, 50);
      ras.add_path(ellipse);
      ScanlineRenderer.renderSolid(ras, sl, buffer, Color(150, 50, 200, 150));

      PngEncoder.saveImage(buffer, 'test/tmp/layered_transparency.png');
      expect(File('test/tmp/layered_transparency.png').existsSync(), isTrue);
    });
  });

  group('Pattern Rendering', () {
    test('Checkerboard pattern', () {
      final buffer = ImageBuffer(200, 200);

      final squareSize = 20;
      for (int y = 0; y < buffer.height; y++) {
        for (int x = 0; x < buffer.width; x++) {
          final checker = ((x ~/ squareSize) + (y ~/ squareSize)) % 2;
          final color = checker == 0 
              ? Color(200, 200, 200, 255) 
              : Color(100, 100, 100, 255);
          buffer.SetPixel(x, y, color);
        }
      }

      PngEncoder.saveImage(buffer, 'test/tmp/pattern_checker.png');
      expect(File('test/tmp/pattern_checker.png').existsSync(), isTrue);
    });

    test('Stripe pattern', () {
      final buffer = ImageBuffer(200, 200);

      for (int y = 0; y < buffer.height; y++) {
        for (int x = 0; x < buffer.width; x++) {
          // Diagonal stripes
          final stripe = ((x + y) ~/ 10) % 2;
          final color = stripe == 0 
              ? Color(50, 100, 200, 255) 
              : Color(200, 150, 50, 255);
          buffer.SetPixel(x, y, color);
        }
      }

      PngEncoder.saveImage(buffer, 'test/tmp/pattern_stripes.png');
      expect(File('test/tmp/pattern_stripes.png').existsSync(), isTrue);
    });

    test('Concentric rings pattern', () {
      final buffer = ImageBuffer(200, 200);
      final cx = buffer.width / 2;
      final cy = buffer.height / 2;

      for (int y = 0; y < buffer.height; y++) {
        for (int x = 0; x < buffer.width; x++) {
          final dx = x - cx;
          final dy = y - cy;
          final dist = math.sqrt(dx * dx + dy * dy);
          final ring = (dist / 15).floor() % 2;
          final color = ring == 0 
              ? Color(255, 100, 100, 255) 
              : Color(100, 100, 255, 255);
          buffer.SetPixel(x, y, color);
        }
      }

      PngEncoder.saveImage(buffer, 'test/tmp/pattern_rings.png');
      expect(File('test/tmp/pattern_rings.png').existsSync(), isTrue);
    });
  });

  group('Color Space', () {
    test('RGB color cube slice', () {
      final buffer = ImageBuffer(256, 256);

      // Draw a slice of the RGB cube where B varies with Y
      for (int y = 0; y < buffer.height; y++) {
        for (int x = 0; x < buffer.width; x++) {
          buffer.SetPixel(x, y, Color(x, y, 128, 255));
        }
      }

      PngEncoder.saveImage(buffer, 'test/tmp/color_rgb_slice.png');
      expect(File('test/tmp/color_rgb_slice.png').existsSync(), isTrue);
    });

    test('HSV color wheel', () {
      final buffer = ImageBuffer(200, 200);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      final cx = buffer.width / 2;
      final cy = buffer.height / 2;
      final radius = 90.0;

      for (int y = 0; y < buffer.height; y++) {
        for (int x = 0; x < buffer.width; x++) {
          final dx = x - cx;
          final dy = y - cy;
          final dist = math.sqrt(dx * dx + dy * dy);

          if (dist <= radius) {
            final angle = math.atan2(dy, dx);
            final hue = (angle + math.pi) / (2 * math.pi);
            final saturation = dist / radius;
            final color = _hsvToRgb(hue, saturation, 1.0);
            buffer.SetPixel(x, y, color);
          }
        }
      }

      PngEncoder.saveImage(buffer, 'test/tmp/color_hsv_wheel.png');
      expect(File('test/tmp/color_hsv_wheel.png').existsSync(), isTrue);
    });

    test('Grayscale ramp', () {
      final buffer = ImageBuffer(256, 50);

      for (int y = 0; y < buffer.height; y++) {
        for (int x = 0; x < buffer.width; x++) {
          buffer.SetPixel(x, y, Color(x, x, x, 255));
        }
      }

      PngEncoder.saveImage(buffer, 'test/tmp/color_grayscale.png');
      expect(File('test/tmp/color_grayscale.png').existsSync(), isTrue);
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

bool _hasMultipleColors(ImageBuffer buffer) {
  Color? firstColor;
  for (var y = 0; y < buffer.height; y++) {
    for (var x = 0; x < buffer.width; x++) {
      final c = buffer.getPixel(x, y);
      if (firstColor == null) {
        firstColor = c;
      } else if (c.red != firstColor.red ||
          c.green != firstColor.green ||
          c.blue != firstColor.blue) {
        return true;
      }
    }
  }
  return false;
}

void _fillWithLinearGradient(
  ImageBuffer buffer,
  double x1,
  double y1,
  double x2,
  double y2,
  List<({double offset, Color color})> stops,
) {
  final gradient = SpanGradientLinear(x1, y1, x2, y2);
  gradient.buildLut(stops);

  final span = List.generate(buffer.width, (_) => Color(0, 0, 0, 0));

  for (int y = 0; y < buffer.height; y++) {
    gradient.generate(span, 0, 0, y, buffer.width);
    for (int x = 0; x < buffer.width; x++) {
      buffer.SetPixel(x, y, span[x]);
    }
  }
}

void _fillWithRadialGradient(
  ImageBuffer buffer,
  double cx,
  double cy,
  double radius,
  List<({double offset, Color color})> stops,
) {
  final gradient = SpanGradientRadial(cx, cy, radius);
  gradient.buildLut(stops);

  final span = List.generate(buffer.width, (_) => Color(0, 0, 0, 0));

  for (int y = 0; y < buffer.height; y++) {
    gradient.generate(span, 0, 0, y, buffer.width);
    for (int x = 0; x < buffer.width; x++) {
      buffer.SetPixel(x, y, span[x]);
    }
  }
}

void _renderGouraudTriangle(
  ImageBuffer buffer,
  double x1,
  double y1,
  Color c1,
  double x2,
  double y2,
  Color c2,
  double x3,
  double y3,
  Color c3,
) {
  final spanGen = SpanGouraudRgba(c1, c2, c3, x1, y1, x2, y2, x3, y3, 0);
  spanGen.prepare();

  // Simple scanline rasterization of the triangle
  final minY = math.min(y1, math.min(y2, y3)).floor();
  final maxY = math.max(y1, math.max(y2, y3)).ceil();

  for (int y = minY; y <= maxY; y++) {
    if (y < 0 || y >= buffer.height) continue;

    // Find x range for this scanline
    final intersections = _getTriangleScanlineIntersections(
      x1, y1, x2, y2, x3, y3, y.toDouble(),
    );

    if (intersections.isEmpty) continue;

    intersections.sort();
    final minX = intersections.first.floor().clamp(0, buffer.width - 1);
    final maxX = intersections.last.ceil().clamp(0, buffer.width - 1);
    final len = maxX - minX + 1;

    if (len <= 0) continue;

    final span = List.generate(len, (_) => Color(0, 0, 0, 0));
    spanGen.generate(span, 0, minX, y, len);

    for (int i = 0; i < len; i++) {
      final x = minX + i;
      if (x >= 0 && x < buffer.width) {
        final current = buffer.getPixel(x, y);
        final newColor = span[i];
        // Alpha blending
        final blended = _blendColors(current, newColor);
        buffer.SetPixel(x, y, blended);
      }
    }
  }
}

List<double> _getTriangleScanlineIntersections(
  double x1,
  double y1,
  double x2,
  double y2,
  double x3,
  double y3,
  double y,
) {
  final intersections = <double>[];

  void checkEdge(double ax, double ay, double bx, double by) {
    if ((ay <= y && by > y) || (by <= y && ay > y)) {
      final t = (y - ay) / (by - ay);
      intersections.add(ax + t * (bx - ax));
    }
  }

  checkEdge(x1, y1, x2, y2);
  checkEdge(x2, y2, x3, y3);
  checkEdge(x3, y3, x1, y1);

  return intersections;
}

Color _blendColors(Color bg, Color fg) {
  if (fg.alpha == 255) return fg;
  if (fg.alpha == 0) return bg;

  final a = fg.alpha / 255.0;
  final invA = 1.0 - a;

  return Color(
    (fg.red * a + bg.red * invA).round(),
    (fg.green * a + bg.green * invA).round(),
    (fg.blue * a + bg.blue * invA).round(),
    255,
  );
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

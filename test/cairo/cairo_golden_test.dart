/// Cairo Golden Tests - Reference images for AGG port validation
/// 
/// These tests generate reference images using Cairo library to compare
/// against the Dart AGG port implementation.

import 'dart:io';
import 'dart:math' as math;
import 'package:test/test.dart';
import 'package:dart_graphics/cairo.dart';

/// Font paths - same fonts used by AGG tests for fair comparison
const _liberationSansRegular = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSans-Regular.ttf';
const _liberationSansBold = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSans-Bold.ttf';
const _liberationSerifRegular = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSerif-Regular.ttf';
const _liberationSerifBold = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSerif-Bold.ttf';
const _liberationMonoRegular = 'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationMono-Regular.ttf';

/// Global Cairo instance
final cairo = Cairo();

void main() {
  setUpAll(() {
    Directory('test/golden').createSync(recursive: true);
  });

  group('Cairo Golden - Shapes', () {
    test('Heart shape', () {
      final canvas = cairo.createCanvas(200, 200);
      canvas.clear(CairoColor.white);

      // Heart shape using bezier curves (same as AGG test)
      final cx = 100.0;
      final cy = 100.0;
      final size = 60.0;

      canvas.newPath();
      canvas.moveTo(cx, cy + size * 0.3);

      // Left side curve
      canvas.curveTo(
        cx - size * 0.5, cy - size * 0.3,
        cx - size, cy - size * 0.2,
        cx, cy - size * 0.8,
      );

      // Right side curve
      canvas.curveTo(
        cx + size, cy - size * 0.2,
        cx + size * 0.5, cy - size * 0.3,
        cx, cy + size * 0.3,
      );

      canvas.closePath();

      canvas.setColor(CairoColor.fromRgba(255, 0, 80, 255));
      canvas.fill();

      canvas.saveToPng('test/golden/shape_heart.png');
      canvas.dispose();

      expect(File('test/golden/shape_heart.png').existsSync(), isTrue);
    });

    test('Spiral shape', () {
      final canvas = cairo.createCanvas(300, 300);
      canvas.clear(CairoColor.white);

      final cx = 150.0;
      final cy = 150.0;
      final innerR = 10.0;
      final outerR = 120.0;
      final turns = 6;
      final steps = turns * 36;

      canvas.newPath();

      for (var i = 0; i <= steps; i++) {
        final t = i / steps;
        final angle = t * turns * 2 * math.pi;
        final r = innerR + (outerR - innerR) * t;
        final x = cx + r * math.cos(angle);
        final y = cy + r * math.sin(angle);

        if (i == 0) {
          canvas.moveTo(x, y);
        } else {
          canvas.lineTo(x, y);
        }
      }

      canvas.setColor(CairoColor.fromRgba(0, 100, 200, 255));
      canvas.setLineWidth(2.0);
      canvas.stroke();

      canvas.saveToPng('test/golden/shape_spiral.png');
      canvas.dispose();

      expect(File('test/golden/shape_spiral.png').existsSync(), isTrue);
    });

    test('Bezier curves', () {
      final canvas = cairo.createCanvas(400, 300);
      canvas.clear(CairoColor.white);

      canvas.newPath();

      // Quadratic bezier (approximated as cubic for Cairo)
      canvas.moveTo(50, 200);
      // curve3(cx, cy, x, y) -> curve_to with two control points
      // For quadratic: use 2/3 of control point
      final qx1 = 50 + (2 / 3) * (200 - 50);
      final qy1 = 200 + (2 / 3) * (50 - 200);
      final qx2 = 350 + (2 / 3) * (200 - 350);
      final qy2 = 200 + (2 / 3) * (50 - 200);
      canvas.curveTo(qx1, qy1, qx2, qy2, 350, 200);

      // Cubic bezier
      canvas.moveTo(50, 250);
      canvas.curveTo(100, 100, 300, 100, 350, 250);

      canvas.setColor(CairoColor.fromRgba(200, 0, 100, 255));
      canvas.setLineWidth(3.0);
      canvas.stroke();

      canvas.saveToPng('test/golden/shape_bezier.png');
      canvas.dispose();

      expect(File('test/golden/shape_bezier.png').existsSync(), isTrue);
    });

    test('Star shape', () {
      final canvas = cairo.createCanvas(200, 200);
      canvas.clear(CairoColor.white);

      final cx = 100.0;
      final cy = 100.0;
      final outerR = 80.0;
      final innerR = 40.0;
      final points = 5;

      canvas.newPath();

      for (var i = 0; i < points * 2; i++) {
        final r = i.isEven ? outerR : innerR;
        final angle = (i * math.pi / points) - math.pi / 2;
        final x = cx + r * math.cos(angle);
        final y = cy + r * math.sin(angle);

        if (i == 0) {
          canvas.moveTo(x, y);
        } else {
          canvas.lineTo(x, y);
        }
      }

      canvas.closePath();
      canvas.setColor(CairoColor.fromRgba(255, 200, 0, 255));
      canvas.fill();

      canvas.saveToPng('test/golden/shape_star.png');
      canvas.dispose();

      expect(File('test/golden/shape_star.png').existsSync(), isTrue);
    });

    test('Concentric circles', () {
      final canvas = cairo.createCanvas(300, 300);
      canvas.clear(CairoColor.white);

      for (var i = 10; i > 0; i--) {
        final radius = i * 14.0;
        // Match AGG: i % 2 == 0 (even) -> blue, odd -> orange
        final color = (i % 2 == 0)
            ? CairoColor.fromRgba(100, 150, 200, 255)  // blue for even
            : CairoColor.fromRgba(200, 150, 100, 255); // orange for odd

        canvas.setColor(color);
        canvas.fillCircle(150, 150, radius);
      }

      canvas.saveToPng('test/golden/shape_concentric.png');
      canvas.dispose();

      expect(File('test/golden/shape_concentric.png').existsSync(), isTrue);
    });

    test('Rounded rectangles', () {
      final canvas = cairo.createCanvas(400, 300);
      canvas.clear(CairoColor.white);

      // Match exact AGG test coordinates and colors
      // AGG uses RoundedRect(left, bottom, right, top, radius)
      
      // rect1: (20, 20, 180, 100) with radius 5
      canvas.setColor(CairoColor.fromRgba(255, 150, 150, 255));
      canvas.fillRoundedRect(20, 20, 180 - 20, 100 - 20, 5);

      // rect2: (200, 20, 380, 100) with radius 15
      canvas.setColor(CairoColor.fromRgba(150, 255, 150, 255));
      canvas.fillRoundedRect(200, 20, 380 - 200, 100 - 20, 15);

      // rect3: (20, 120, 180, 200) with radius 25
      canvas.setColor(CairoColor.fromRgba(150, 150, 255, 255));
      canvas.fillRoundedRect(20, 120, 180 - 20, 200 - 120, 25);

      // rect4: (200, 120, 380, 200) with radius 35
      canvas.setColor(CairoColor.fromRgba(255, 255, 150, 255));
      canvas.fillRoundedRect(200, 120, 380 - 200, 200 - 120, 35);

      canvas.saveToPng('test/golden/shape_rounded_rects.png');
      canvas.dispose();

      expect(File('test/golden/shape_rounded_rects.png').existsSync(), isTrue);
    });

    test('Arrow shape', () {
      final canvas = cairo.createCanvas(300, 200);
      canvas.clear(CairoColor.white);

      // Arrow from (50, 100) to (250, 100)
      final x1 = 50.0, y1 = 100.0;
      final x2 = 250.0, y2 = 100.0;
      final shaftWidth = 20.0;
      final headWidth = 50.0;

      final dx = x2 - x1;
      final dy = y2 - y1;
      final length = math.sqrt(dx * dx + dy * dy);
      final ux = dx / length;
      final uy = dy / length;
      final px = -uy;
      final py = ux;

      final headLength = headWidth * 1.5;

      canvas.newPath();

      // Shaft
      canvas.moveTo(x1 + px * shaftWidth / 2, y1 + py * shaftWidth / 2);
      canvas.lineTo(
          x2 - ux * headLength + px * shaftWidth / 2, y2 - uy * headLength + py * shaftWidth / 2);
      // Head base left
      canvas.lineTo(x2 - ux * headLength + px * headWidth / 2, y2 - uy * headLength + py * headWidth / 2);
      // Head tip
      canvas.lineTo(x2, y2);
      // Head base right
      canvas.lineTo(
          x2 - ux * headLength - px * headWidth / 2, y2 - uy * headLength - py * headWidth / 2);
      // Back to shaft
      canvas.lineTo(
          x2 - ux * headLength - px * shaftWidth / 2, y2 - uy * headLength - py * shaftWidth / 2);
      canvas.lineTo(x1 - px * shaftWidth / 2, y1 - py * shaftWidth / 2);

      canvas.closePath();
      canvas.setColor(CairoColor.fromRgba(0, 150, 100, 255));
      canvas.fill();

      canvas.saveToPng('test/golden/shape_arrow.png');
      canvas.dispose();

      expect(File('test/golden/shape_arrow.png').existsSync(), isTrue);
    });

    test('Pie slice', () {
      final canvas = cairo.createCanvas(200, 200);
      canvas.clear(CairoColor.white);

      final cx = 100.0;
      final cy = 100.0;
      final radius = 80.0;
      final startAngle = 0.0;
      final sweepAngle = math.pi * 0.75; // 135 degrees

      canvas.newPath();
      canvas.moveTo(cx, cy);
      canvas.arc(cx, cy, radius, startAngle, startAngle + sweepAngle);
      canvas.closePath();

      canvas.setColor(CairoColor.fromRgba(150, 100, 200, 255));
      canvas.fill();

      canvas.saveToPng('test/golden/shape_pie.png');
      canvas.dispose();

      expect(File('test/golden/shape_pie.png').existsSync(), isTrue);
    });
  });

  group('Cairo Golden - Text', () {
    test('Hello World basic', () {
      final canvas = cairo.createCanvas(400, 100);
      canvas.clear(CairoColor.white);

      canvas.setColor(CairoColor.black);
      canvas.setFontFaceFromFile(_liberationSansRegular);
      canvas.setFontSize(48);
      canvas.drawText('Hello World!', 20, 60);

      canvas.saveToPng('test/golden/text_hello_world.png');
      canvas.dispose();

      expect(File('test/golden/text_hello_world.png').existsSync(), isTrue);
    });

    test('Outlined text', () {
      final canvas = cairo.createCanvas(400, 100);
      canvas.clear(CairoColor.white);

      canvas.setFontFaceFromFile(_liberationSansBold);
      canvas.setFontSize(48);

      // Text path for outlining
      canvas.moveTo(20, 70);
      canvas.textPath('Outlined');

      canvas.setColor(CairoColor.blue);
      canvas.setLineWidth(2.0);
      canvas.stroke();

      canvas.saveToPng('test/golden/text_outlined.png');
      canvas.dispose();

      expect(File('test/golden/text_outlined.png').existsSync(), isTrue);
    });

    test('Multiple font sizes', () {
      final canvas = cairo.createCanvas(600, 250);
      canvas.clear(CairoColor.white);

      canvas.setColor(CairoColor.black);
      canvas.setFontFaceFromFile(_liberationSansRegular);

      canvas.setFontSize(12);
      canvas.drawText('Size 12', 20, 30);

      canvas.setFontSize(18);
      canvas.drawText('Size 18', 20, 60);

      canvas.setFontSize(24);
      canvas.drawText('Size 24', 20, 100);

      canvas.setFontSize(36);
      canvas.drawText('Size 36', 20, 150);

      canvas.setFontSize(48);
      canvas.drawText('Size 48', 20, 210);

      canvas.saveToPng('test/golden/text_sizes.png');
      canvas.dispose();

      expect(File('test/golden/text_sizes.png').existsSync(), isTrue);
    });

    test('Multiple lines', () {
      final canvas = cairo.createCanvas(500, 200);
      canvas.clear(CairoColor.white);

      canvas.setFontSize(32);

      canvas.setColor(CairoColor.black);
      canvas.setFontFaceFromFile(_liberationSansRegular);
      canvas.drawText('Line 1: Sans-Serif', 20, 50);

      canvas.setColor(CairoColor.fromRgba(128, 0, 0, 255));
      canvas.setFontFaceFromFile(_liberationSerifRegular);
      canvas.drawText('Line 2: Serif', 20, 100);

      canvas.setColor(CairoColor.fromRgba(0, 0, 128, 255));
      canvas.setFontFaceFromFile(_liberationMonoRegular);
      canvas.drawText('Line 3: Monospace', 20, 150);

      canvas.saveToPng('test/golden/text_multiline.png');
      canvas.dispose();

      expect(File('test/golden/text_multiline.png').existsSync(), isTrue);
    });

    test('Mixed styles', () {
      final canvas = cairo.createCanvas(700, 300);
      canvas.clear(CairoColor.fromRgba(245, 245, 245, 255));

      // Header
      canvas.setColor(CairoColor.black);
      canvas.setFontFaceFromFile(_liberationSerifBold);
      canvas.setFontSize(36);
      canvas.drawText('Typography Test', 20, 60);

      // Body text
      canvas.setColor(CairoColor.fromRgba(50, 50, 50, 255));
      canvas.setFontFaceFromFile(_liberationSansRegular);
      canvas.setFontSize(18);
      canvas.drawText('The quick brown fox jumps over the lazy dog.', 20, 120);
      canvas.drawText('Pack my box with five dozen liquor jugs.', 20, 150);

      // Code sample
      canvas.setColor(CairoColor.fromRgba(0, 100, 0, 255));
      canvas.setFontFaceFromFile(_liberationMonoRegular);
      canvas.setFontSize(14);
      canvas.drawText('void main() { print("Hello"); }', 20, 200);

      // Footer
      canvas.setColor(CairoColor.fromRgba(128, 128, 128, 255));
      canvas.setFontFaceFromFile(_liberationSansRegular);
      canvas.setFontSize(12);
      canvas.drawText('AGG Typography Port - Dart', 20, 260);

      canvas.saveToPng('test/golden/text_mixed_styles.png');
      canvas.dispose();

      expect(File('test/golden/text_mixed_styles.png').existsSync(), isTrue);
    });

    test('Special characters', () {
      final canvas = cairo.createCanvas(500, 150);
      canvas.clear(CairoColor.white);

      canvas.setFontFaceFromFile(_liberationSansRegular);

      canvas.setColor(CairoColor.black);
      canvas.setFontSize(32);
      canvas.drawText('0123456789', 20, 40);

      canvas.setColor(CairoColor.fromRgba(0, 0, 128, 255));
      canvas.setFontSize(24);
      canvas.drawText('!@#\$%^&*()_+-=', 20, 80);

      canvas.setColor(CairoColor.fromRgba(128, 0, 0, 255));
      canvas.drawText('<>[]{}|\\;:\'",./?', 20, 120);

      canvas.saveToPng('test/golden/text_special_chars.png');
      canvas.dispose();

      expect(File('test/golden/text_special_chars.png').existsSync(), isTrue);
    });

    test('Rotated text', () {
      final canvas = cairo.createCanvas(300, 300);
      canvas.clear(CairoColor.white);

      canvas.setFontFaceFromFile(_liberationSansBold);
      canvas.setFontSize(24);

      final colors = [
        CairoColor.red,
        CairoColor.green,
        CairoColor.blue,
        CairoColor.magenta,
      ];

      for (var i = 0; i < 4; i++) {
        canvas.save();
        canvas.translate(150, 150);
        canvas.rotate(i * math.pi / 4); // 0, 45, 90, 135 degrees
        canvas.setColor(colors[i]);
        canvas.drawText('Rotated ${i * 45}°', 10, 0);
        canvas.restore();
      }

      canvas.saveToPng('test/golden/text_rotated.png');
      canvas.dispose();

      expect(File('test/golden/text_rotated.png').existsSync(), isTrue);
    });

    test('Unicode text', () {
      final canvas = cairo.createCanvas(500, 200);
      canvas.clear(CairoColor.white);

      canvas.setColor(CairoColor.black);
      canvas.setFontFaceFromFile(_liberationSansRegular);
      canvas.setFontSize(24);

      canvas.drawText('English: Hello World', 20, 40);
      canvas.drawText('Português: Olá Mundo', 20, 80);
      canvas.drawText('Français: Bonjour le monde', 20, 120);
      canvas.drawText('Deutsch: Hallo Welt', 20, 160);

      canvas.saveToPng('test/golden/text_unicode.png');
      canvas.dispose();

      expect(File('test/golden/text_unicode.png').existsSync(), isTrue);
    });
  });

  group('Cairo Golden - Anti-aliasing', () {
    test('Diagonal lines', () {
      final canvas = cairo.createCanvas(200, 200);
      canvas.clear(CairoColor.white);

      canvas.setColor(CairoColor.black);
      canvas.setLineWidth(1.0);

      for (var i = 0; i < 10; i++) {
        canvas.drawLine(10.0 + i * 20, 10, 20.0 + i * 20, 190);
      }

      canvas.saveToPng('test/golden/aa_diagonals.png');
      canvas.dispose();

      expect(File('test/golden/aa_diagonals.png').existsSync(), isTrue);
    });

    test('Small circles', () {
      final canvas = cairo.createCanvas(200, 200);
      canvas.clear(CairoColor.white);

      canvas.setColor(CairoColor.black);

      // Various small circle sizes
      for (var i = 0; i < 5; i++) {
        for (var j = 0; j < 5; j++) {
          final radius = (i + 1) * 2.0;
          canvas.fillCircle(20.0 + i * 40, 20.0 + j * 40, radius);
        }
      }

      canvas.saveToPng('test/golden/aa_small_circles.png');
      canvas.dispose();

      expect(File('test/golden/aa_small_circles.png').existsSync(), isTrue);
    });

    test('Thin strokes', () {
      final canvas = cairo.createCanvas(300, 200);
      canvas.clear(CairoColor.white);

      canvas.setColor(CairoColor.black);

      // Various line widths
      for (var i = 0; i < 5; i++) {
        final lineWidth = 0.5 + i * 0.5;
        canvas.setLineWidth(lineWidth);
        canvas.drawLine(20, 20.0 + i * 35, 280, 30.0 + i * 35);
      }

      canvas.saveToPng('test/golden/aa_thin_strokes.png');
      canvas.dispose();

      expect(File('test/golden/aa_thin_strokes.png').existsSync(), isTrue);
    });
  });

  group('Cairo Golden - Gradients', () {
    test('Linear gradient horizontal', () {
      final canvas = cairo.createCanvas(300, 100);
      canvas.clear(CairoColor.white);

      final gradient = LinearGradient(cairo, 0, 0, 300, 0)
        ..addColorStop(0.0, CairoColor.red)
        ..addColorStop(0.5, CairoColor.green)
        ..addColorStop(1.0, CairoColor.blue);

      canvas.setPattern(gradient.pointer);
      canvas.fillRect(10, 10, 280, 80);
      gradient.dispose();

      canvas.saveToPng('test/golden/gradient_linear_h.png');
      canvas.dispose();

      expect(File('test/golden/gradient_linear_h.png').existsSync(), isTrue);
    });

    test('Linear gradient vertical', () {
      final canvas = cairo.createCanvas(100, 300);
      canvas.clear(CairoColor.white);

      final gradient = LinearGradient(cairo, 0, 0, 0, 300)
        ..addColorStop(0.0, CairoColor.yellow)
        ..addColorStop(1.0, CairoColor.magenta);

      canvas.setPattern(gradient.pointer);
      canvas.fillRect(10, 10, 80, 280);
      gradient.dispose();

      canvas.saveToPng('test/golden/gradient_linear_v.png');
      canvas.dispose();

      expect(File('test/golden/gradient_linear_v.png').existsSync(), isTrue);
    });

    test('Radial gradient', () {
      final canvas = cairo.createCanvas(200, 200);
      canvas.clear(CairoColor.white);

      final gradient = RadialGradient.centered(cairo, 100, 100, 0, 90)
        ..addColorStop(0.0, CairoColor.white)
        ..addColorStop(0.5, CairoColor.yellow)
        ..addColorStop(1.0, CairoColor.red);

      canvas.setPattern(gradient.pointer);
      canvas.fillCircle(100, 100, 90);
      gradient.dispose();

      canvas.saveToPng('test/golden/gradient_radial.png');
      canvas.dispose();

      expect(File('test/golden/gradient_radial.png').existsSync(), isTrue);
    });

    test('Rainbow gradient', () {
      final canvas = cairo.createCanvas(400, 100);
      canvas.clear(CairoColor.white);

      final gradient = LinearGradient(cairo, 0, 0, 400, 0)
        ..addColorStop(0.0, CairoColor.red)
        ..addColorStop(0.17, CairoColor.fromHex(0xFF7F00)) // Orange
        ..addColorStop(0.33, CairoColor.yellow)
        ..addColorStop(0.5, CairoColor.green)
        ..addColorStop(0.67, CairoColor.blue)
        ..addColorStop(0.83, CairoColor.fromHex(0x4B0082)) // Indigo
        ..addColorStop(1.0, CairoColor.fromHex(0x9400D3)); // Violet

      canvas.setPattern(gradient.pointer);
      canvas.fillRect(0, 0, 400, 100);
      gradient.dispose();

      canvas.saveToPng('test/golden/gradient_rainbow.png');
      canvas.dispose();

      expect(File('test/golden/gradient_rainbow.png').existsSync(), isTrue);
    });
  });

  group('Cairo Golden - Complex', () {
    test('Layered transparency', () {
      final canvas = cairo.createCanvas(200, 200);
      canvas.clear(CairoColor.white);

      // Red circle
      canvas.setColor(CairoColor(1, 0, 0, 0.5));
      canvas.fillCircle(80, 80, 60);

      // Green circle
      canvas.setColor(CairoColor(0, 1, 0, 0.5));
      canvas.fillCircle(120, 80, 60);

      // Blue circle
      canvas.setColor(CairoColor(0, 0, 1, 0.5));
      canvas.fillCircle(100, 120, 60);

      canvas.saveToPng('test/golden/layered_transparency.png');
      canvas.dispose();

      expect(File('test/golden/layered_transparency.png').existsSync(), isTrue);
    });

    test('Strokes with various joins', () {
      final canvas = cairo.createCanvas(400, 150);
      canvas.clear(CairoColor.white);

      // Miter join
      canvas.newPath();
      canvas.moveTo(30, 100);
      canvas.lineTo(60, 30);
      canvas.lineTo(90, 100);
      canvas.setColor(CairoColor.red);
      canvas.setLineWidth(10);
      canvas.setLineJoin(LineJoin.miter);
      canvas.stroke();

      // Round join
      canvas.newPath();
      canvas.moveTo(130, 100);
      canvas.lineTo(160, 30);
      canvas.lineTo(190, 100);
      canvas.setColor(CairoColor.green);
      canvas.setLineJoin(LineJoin.round);
      canvas.stroke();

      // Bevel join
      canvas.newPath();
      canvas.moveTo(230, 100);
      canvas.lineTo(260, 30);
      canvas.lineTo(290, 100);
      canvas.setColor(CairoColor.blue);
      canvas.setLineJoin(LineJoin.bevel);
      canvas.stroke();

      // Labels
      canvas.setColor(CairoColor.black);
      canvas.setFontFaceFromFile(_liberationSansRegular);
      canvas.setFontSize(12);
      canvas.drawText('Miter', 40, 130);
      canvas.drawText('Round', 140, 130);
      canvas.drawText('Bevel', 240, 130);

      canvas.saveToPng('test/golden/line_join.png');
      canvas.dispose();

      expect(File('test/golden/line_join.png').existsSync(), isTrue);
    });

    test('Pattern - checker', () {
      final canvas = cairo.createCanvas(200, 200);
      canvas.clear(CairoColor.white);

      final size = 20.0;
      for (var y = 0; y < 10; y++) {
        for (var x = 0; x < 10; x++) {
          if ((x + y) % 2 == 0) {
            canvas.setColor(CairoColor.black);
          } else {
            canvas.setColor(CairoColor.white);
          }
          canvas.fillRect(x * size, y * size, size, size);
        }
      }

      canvas.saveToPng('test/golden/pattern_checker.png');
      canvas.dispose();

      expect(File('test/golden/pattern_checker.png').existsSync(), isTrue);
    });

    test('Color wheel (HSV)', () {
      final canvas = cairo.createCanvas(300, 300);
      canvas.clear(CairoColor.white);

      final cx = 150.0;
      final cy = 150.0;
      final radius = 120.0;
      final segments = 60;

      for (var i = 0; i < segments; i++) {
        final startAngle = i * 2 * math.pi / segments;
        final endAngle = (i + 1) * 2 * math.pi / segments;
        final hue = i / segments;

        canvas.newPath();
        canvas.moveTo(cx, cy);
        canvas.arc(cx, cy, radius, startAngle, endAngle);
        canvas.closePath();

        final color = _hsvToRgb(hue, 1.0, 1.0);
        canvas.setColor(color);
        canvas.fill();
      }

      canvas.saveToPng('test/golden/color_hsv_wheel.png');
      canvas.dispose();

      expect(File('test/golden/color_hsv_wheel.png').existsSync(), isTrue);
    });
  });
}

CairoColor _hsvToRgb(double h, double s, double v) {
  final i = (h * 6).floor();
  final f = h * 6 - i;
  final p = v * (1 - s);
  final q = v * (1 - f * s);
  final t = v * (1 - (1 - f) * s);

  double r, g, b;
  switch (i % 6) {
    case 0:
      r = v; g = t; b = p;
    case 1:
      r = q; g = v; b = p;
    case 2:
      r = p; g = v; b = t;
    case 3:
      r = p; g = q; b = v;
    case 4:
      r = t; g = p; b = v;
    default:
      r = v; g = p; b = q;
  }

  return CairoColor(r, g, b);
}


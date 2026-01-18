import 'package:dart_graphics/src/dart_graphics/graphics2D.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/shared/canvas2d/canvas_pattern.dart';
import 'package:test/test.dart';

void main() {
  test('linear gradient fill produces color ramp', () {
    final img = ImageBuffer(20, 4);
    final g = img.newGraphics2D() as BasicGraphics2D;

    g.clear(Color.transparent);
    g.beginPath();
    g.rect(0, 0, img.width.toDouble(), img.height.toDouble());
    g.setLinearGradient(0, 0, img.width.toDouble(), 0, [
      (offset: 0.0, color: Color(255, 0, 0, 255)),
      (offset: 1.0, color: Color(0, 0, 255, 255)),
    ]);
    g.fillPath();

    final left = img.getPixel(1, 1);
    final right = img.getPixel(img.width - 2, 1);

    expect(left.red, greaterThan(right.red));
    expect(right.blue, greaterThan(left.blue));
  });

  test('pattern fill repeats image', () {
    final pattern = ImageBuffer(2, 2);
    pattern.setPixel(0, 0, Color(255, 0, 0, 255));
    pattern.setPixel(1, 0, Color(0, 255, 0, 255));
    pattern.setPixel(0, 1, Color(0, 0, 255, 255));
    pattern.setPixel(1, 1, Color(255, 255, 255, 255));

    final img = ImageBuffer(6, 4);
    final g = img.newGraphics2D() as BasicGraphics2D;

    g.clear(Color.transparent);
    g.beginPath();
    g.rect(0, 0, img.width.toDouble(), img.height.toDouble());
    g.setPatternFill(pattern, repetition: PatternRepetition.repeat);
    g.fillPath();

    final c00 = img.getPixel(0, 0);
    final c20 = img.getPixel(2, 0);
    final c10 = img.getPixel(1, 0);
    final c30 = img.getPixel(3, 0);

    expect(c00.red, c20.red);
    expect(c00.green, c20.green);
    expect(c00.blue, c20.blue);

    expect(c10.red, c30.red);
    expect(c10.green, c30.green);
    expect(c10.blue, c30.blue);
  });

  test('drawImage scales with nearest mapping', () {
    final src = ImageBuffer(2, 2);
    src.setPixel(0, 0, Color(255, 0, 0, 255));
    src.setPixel(1, 0, Color(0, 255, 0, 255));
    src.setPixel(0, 1, Color(0, 0, 255, 255));
    src.setPixel(1, 1, Color(255, 255, 0, 255));

    final img = ImageBuffer(4, 4);
    final g = img.newGraphics2D() as BasicGraphics2D;
    g.clear(Color.transparent);

    g.imageRenderQuality = TransformQuality.Fastest;
    g.imageFilter = ImageFilter.none;
    g.imageResample = ImageResample.noResample;

    g.drawImage(src, 0, 0, 4, 4);

    final topLeft = img.getPixel(0, 0);
    final topRight = img.getPixel(3, 0);
    final bottomLeft = img.getPixel(0, 3);
    final bottomRight = img.getPixel(3, 3);

    expect(topLeft.red, 255);
    expect(topLeft.green, 0);

    expect(topRight.green, 255);
    expect(topRight.red, 0);

    expect(bottomLeft.blue, 255);
    expect(bottomLeft.red, 0);

    expect(bottomRight.red, 255);
    expect(bottomRight.green, 255);
  });
}

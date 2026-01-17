import 'package:dart_graphics/src/dart_graphics/graphics2D.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_buffer_float.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color_f.dart';
import 'package:test/test.dart';

bool _clearAndCheckImage(ImageBuffer image, Color color) {
  image.newGraphics2D().clear(color);

  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      if (image.getPixel(x, y) != color) {
        return false;
      }
    }
  }

  return true;
}

bool _clearAndCheckImageFloat(ImageBufferFloat image, ColorF color) {
  image.clear(color);

  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      final matches = (pixel.red - color.red).abs() < 1e-6 &&
          (pixel.green - color.green).abs() < 1e-6 &&
          (pixel.blue - color.blue).abs() < 1e-6 &&
          (pixel.alpha - color.alpha).abs() < 1e-6;
      if (!matches) {
        return false;
      }
    }
  }

  return true;
}

void main() {
  group('ImageTests (ported)', () {
    test('Color HTML translations', () {
      expect(Color.fromHex('#FFFFFFFF'), equals(Color(255, 255, 255, 255)));
      expect(Color.fromHex('#FFF'), equals(Color(255, 255, 255, 255)));
      expect(Color.fromHex('#FFFF'), equals(Color(255, 255, 255, 255)));
      expect(Color.fromHex('#FFFFFF'), equals(Color(255, 255, 255, 255)));

      expect(Color.fromHex('#FFFFFFA1'), equals(Color(255, 255, 255, 161)));
      expect(Color.fromHex('#A1FFFFFF'), equals(Color(161, 255, 255, 255)));
      expect(Color.fromHex('#FFA1FFFF'), equals(Color(255, 161, 255, 255)));
      expect(Color.fromHex('#FFFFA1FF'), equals(Color(255, 255, 161, 255)));

      expect(Color.fromHex('#A1FFFF'), equals(Color(161, 255, 255, 255)));
    });

    test('Clear tests (32-bit buffer)', () {
      final image = ImageBuffer(50, 50);

      expect(_clearAndCheckImage(image, Color(255, 255, 255, 255)), isTrue);
      expect(_clearAndCheckImage(image, Color(0, 0, 0, 255)), isTrue);
      expect(_clearAndCheckImage(image, Color(0, 0, 0, 0)), isTrue);
    });

    test('Clear tests (float buffer)', () {
      final image = ImageBufferFloat(50, 50);

      expect(_clearAndCheckImageFloat(image, ColorF(1, 1, 1, 1)), isTrue);
      expect(_clearAndCheckImageFloat(image, ColorF(0, 0, 0, 1)), isTrue);
      expect(_clearAndCheckImageFloat(image, ColorF(0, 0, 0, 0)), isTrue);
    });

    test('Contains tests (32-bit buffer)', () {
        final imageToSearch = ImageBuffer(150, 150);
        final graphics = imageToSearch.newGraphics2D() as BasicGraphics2D;
        graphics.fillCircle(100, 100, 3, Color(255, 0, 0, 255));

        final circleToFind = ImageBuffer(10, 10);
        (circleToFind.newGraphics2D() as BasicGraphics2D)
          .fillCircle(5, 5, 3, Color(255, 0, 0, 255));
      expect(imageToSearch.contains(circleToFind), isTrue);

        final squareToFind = ImageBuffer(10, 10);
        (squareToFind.newGraphics2D() as BasicGraphics2D)
          .fillRect(4, 4, 8, 8, Color(255, 0, 0, 255));
      expect(imageToSearch.contains(squareToFind), isFalse);
    });
  });
}

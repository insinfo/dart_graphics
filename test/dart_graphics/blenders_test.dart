import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/image/blenders/blender_bgra_exact_copy.dart';
import 'package:dart_graphics/src/dart_graphics/image/blenders/blender_bgra_half_half.dart';
import 'package:dart_graphics/src/dart_graphics/image/blenders/blender_poly_color_premult_bgra.dart';

void main() {
  group('BlenderBgraExactCopy', () {
    late BlenderBgraExactCopy blender;

    setUp(() {
      blender = BlenderBgraExactCopy();
    });

    test('has 32-bit pixel format', () {
      expect(blender.numPixelBits, 32);
    });

    test('pixelToColor reads BGRA order', () {
      final buffer = Uint8List.fromList([0, 128, 255, 200]); // B, G, R, A
      final color = blender.pixelToColor(buffer, 0);
      expect(color.red, 255);
      expect(color.green, 128);
      expect(color.blue, 0);
      expect(color.alpha, 200);
    });

    test('blendPixel copies without blending', () {
      final buffer = Uint8List.fromList([0, 0, 0, 0]); // start with black transparent
      final source = Color.fromRgba(255, 128, 64, 200);

      blender.blendPixel(buffer, 0, source);

      expect(buffer[0], 64);  // B
      expect(buffer[1], 128); // G
      expect(buffer[2], 255); // R
      expect(buffer[3], 200); // A
    });

    test('copyPixels copies multiple pixels', () {
      final buffer = Uint8List(8);
      final source = Color.fromRgba(100, 150, 200, 250);

      blender.copyPixels(buffer, 0, source, 2);

      // First pixel
      expect(buffer[0], 200); // B
      expect(buffer[1], 150); // G
      expect(buffer[2], 100); // R
      expect(buffer[3], 250); // A

      // Second pixel
      expect(buffer[4], 200);
      expect(buffer[5], 150);
      expect(buffer[6], 100);
      expect(buffer[7], 250);
    });

    test('blend returns source color directly', () {
      final start = Color.fromRgba(100, 100, 100, 255);
      final blend = Color.fromRgba(200, 50, 25, 128);

      final result = blender.blend(start, blend);

      expect(result.red, 200);
      expect(result.green, 50);
      expect(result.blue, 25);
      expect(result.alpha, 128);
    });

    test('blendPixels with full coverage', () {
      final buffer = Uint8List(8);
      final colors = [
        Color.fromRgba(255, 0, 0, 255),
        Color.fromRgba(0, 255, 0, 255),
      ];
      final covers = Uint8List.fromList([255]);

      blender.blendPixels(buffer, 0, colors, 0, covers, 0, true, 2);

      // First pixel - red
      expect(buffer[2], 255); // R
      expect(buffer[1], 0);   // G
      expect(buffer[0], 0);   // B

      // Second pixel - green
      expect(buffer[6], 0);   // R
      expect(buffer[5], 255); // G
      expect(buffer[4], 0);   // B
    });

    test('blendPixels with partial coverage adjusts alpha', () {
      final buffer = Uint8List(4);
      final colors = [Color.fromRgba(255, 0, 0, 255)];
      final covers = Uint8List.fromList([128]);

      blender.blendPixels(buffer, 0, colors, 0, covers, 0, true, 1);

      // Alpha should be adjusted by coverage
      expect(buffer[3], lessThan(255));
      expect(buffer[3], greaterThan(100));
    });
  });

  group('BlenderBgraHalfHalf', () {
    late BlenderBgraHalfHalf blender;

    setUp(() {
      blender = BlenderBgraHalfHalf();
    });

    test('has 32-bit pixel format', () {
      expect(blender.numPixelBits, 32);
    });

    test('blendPixel with opaque source copies directly', () {
      final buffer = Uint8List.fromList([0, 0, 0, 255]); // black opaque
      final source = Color.fromRgba(255, 128, 64, 255);

      blender.blendPixel(buffer, 0, source);

      expect(buffer[2], 255); // R
      expect(buffer[1], 128); // G
      expect(buffer[0], 64);  // B
      expect(buffer[3], 255); // A
    });

    test('blendPixel with transparent source blends RGB and averages alpha', () {
      final buffer = Uint8List.fromList([0, 0, 0, 200]); // black with alpha 200
      final source = Color.fromRgba(200, 100, 50, 100);

      blender.blendPixel(buffer, 0, source);

      // RGB should be blended
      expect(buffer[2], greaterThan(0)); // R
      expect(buffer[1], greaterThan(0)); // G
      expect(buffer[0], greaterThan(0)); // B

      // Alpha should be averaged: (100 + 200) / 2 = 150
      expect(buffer[3], 150);
    });

    test('blend averages alpha correctly', () {
      final start = Color.fromRgba(0, 0, 0, 200);
      final blend = Color.fromRgba(255, 255, 255, 100);

      final result = blender.blend(start, blend);

      // Alpha should be averaged
      expect(result.alpha, 150);
    });
  });

  group('BlenderPolyColorPreMultBgra', () {
    test('has 32-bit pixel format', () {
      final blender = BlenderPolyColorPreMultBgra(Color.white);
      expect(blender.numPixelBits, 32);
    });

    test('blendPixel applies poly color tint', () {
      final polyColor = Color.fromRgba(255, 0, 0, 255); // Red tint
      final blender = BlenderPolyColorPreMultBgra(polyColor);

      final buffer = Uint8List.fromList([128, 128, 128, 255]); // mid gray
      final source = Color.fromRgba(255, 255, 255, 255);

      blender.blendPixel(buffer, 0, source);

      // Red channel should be high due to red tint
      expect(buffer[2], greaterThan(200)); // R

      // Green and blue should be lower (filtered by red poly color)
      // Note: Actual values depend on the blending algorithm
    });

    test('pixelToColor reads correctly', () {
      final blender = BlenderPolyColorPreMultBgra(Color.white);
      final buffer = Uint8List.fromList([50, 100, 150, 200]); // B, G, R, A

      final color = blender.pixelToColor(buffer, 0);

      expect(color.red, 150);
      expect(color.green, 100);
      expect(color.blue, 50);
      expect(color.alpha, 200);
    });

    test('copyPixels writes correctly', () {
      final blender = BlenderPolyColorPreMultBgra(Color.white);
      final buffer = Uint8List(4);
      final source = Color.fromRgba(100, 150, 200, 250);

      blender.copyPixels(buffer, 0, source, 1);

      expect(buffer[0], 200); // B
      expect(buffer[1], 150); // G
      expect(buffer[2], 100); // R
      expect(buffer[3], 250); // A
    });

    test('blendPixels with white poly color behaves normally', () {
      final blender = BlenderPolyColorPreMultBgra(Color.white);
      final buffer = Uint8List.fromList([0, 0, 0, 255]); // black
      final colors = [Color.fromRgba(200, 100, 50, 255)];
      final covers = Uint8List.fromList([255]);

      blender.blendPixels(buffer, 0, colors, 0, covers, 0, true, 1);

      // With white poly color and full opacity, result should be close to source
      expect(buffer[2], greaterThan(150)); // R should be high
    });

    test('blendPixels with semi-transparent poly color reduces intensity', () {
      final polyColor = Color.fromRgba(255, 255, 255, 128); // 50% alpha
      final blender = BlenderPolyColorPreMultBgra(polyColor);

      final buffer = Uint8List.fromList([0, 0, 0, 255]);
      final colors = [Color.fromRgba(200, 200, 200, 255)];
      final covers = Uint8List.fromList([255]);

      blender.blendPixels(buffer, 0, colors, 0, covers, 0, true, 1);

      // Result should be dimmer due to poly color alpha
      expect(buffer[2], lessThan(200));
    });
  });
}

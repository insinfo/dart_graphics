// Anti-Grain Geometry - Version 2.4
// Copyright (C) 2002-2005 Maxim Shemanarev
// C# port by Lars Brubaker, Dart port by insinfo

import 'dart:typed_data';
import 'package:dart_graphics/src/agg/image/rgba.dart';
import 'package:dart_graphics/src/agg/primitives/color.dart';

/// BGRA Blender that blends colors with a half-half alpha averaging.
///
/// This blender performs alpha blending but averages the alpha channel
/// differently from standard Porter-Duff, useful for certain effects.
class BlenderBgraHalfHalf implements IRecieveBlenderByte {
  /// Base shift constant (8 bits for byte color values)
  static const int baseShift = 8;

  @override
  int get numPixelBits => 32;

  @override
  Color pixelToColor(Uint8List buffer, int bufferOffset) {
    final int b = buffer[bufferOffset];
    final int g = buffer[bufferOffset + 1];
    final int r = buffer[bufferOffset + 2];
    final int a = buffer[bufferOffset + 3];
    return Color.fromRgba(r, g, b, a);
  }

  @override
  void copyPixels(Uint8List buffer, int bufferOffset, Color sourceColor, int count) {
    for (int i = 0; i < count; i++) {
      final int o = bufferOffset + i * 4;
      buffer[o] = sourceColor.blue;
      buffer[o + 1] = sourceColor.green;
      buffer[o + 2] = sourceColor.red;
      buffer[o + 3] = sourceColor.alpha;
    }
  }

  @override
  void blendPixel(Uint8List buffer, int bufferOffset, Color sourceColor) {
    if (sourceColor.alpha == 255) {
      // Fully opaque - direct copy
      buffer[bufferOffset] = sourceColor.blue;
      buffer[bufferOffset + 1] = sourceColor.green;
      buffer[bufferOffset + 2] = sourceColor.red;
      buffer[bufferOffset + 3] = sourceColor.alpha;
    } else {
      // Blend with half-half alpha averaging
      final int r = buffer[bufferOffset + 2];
      final int g = buffer[bufferOffset + 1];
      final int b = buffer[bufferOffset];
      final int a = buffer[bufferOffset + 3];

      // Standard alpha blending for RGB channels
      buffer[bufferOffset + 2] = (((sourceColor.red - r) * sourceColor.alpha + (r << baseShift)) >> baseShift);
      buffer[bufferOffset + 1] = (((sourceColor.green - g) * sourceColor.alpha + (g << baseShift)) >> baseShift);
      buffer[bufferOffset] = (((sourceColor.blue - b) * sourceColor.alpha + (b << baseShift)) >> baseShift);
      // Average alpha (half source + half dest)
      buffer[bufferOffset + 3] = ((sourceColor.alpha + a) ~/ 2);
    }
  }

  @override
  void blendPixels(
    Uint8List buffer,
    int bufferOffset,
    List<Color> sourceColors,
    int sourceColorsOffset,
    Uint8List sourceCovers,
    int sourceCoversOffset,
    bool firstCoverForAll,
    int count,
  ) {
    if (firstCoverForAll) {
      final int cover = sourceCovers[sourceCoversOffset];
      if (cover == 255) {
        // Full coverage
        for (int i = 0; i < count; i++) {
          blendPixel(
            buffer,
            bufferOffset + i * 4,
            sourceColors[sourceColorsOffset + i],
          );
        }
      } else {
        // Partial coverage - modify alpha
        for (int i = 0; i < count; i++) {
          final c = sourceColors[sourceColorsOffset + i];
          final int adjustedAlpha = (c.alpha * cover + 255) >> 8;
          blendPixel(
            buffer,
            bufferOffset + i * 4,
            Color.fromRgba(c.red, c.green, c.blue, adjustedAlpha),
          );
        }
      }
    } else {
      // Per-pixel coverage
      for (int i = 0; i < count; i++) {
        final int cover = sourceCovers[sourceCoversOffset + i];
        final c = sourceColors[sourceColorsOffset + i];
        if (cover == 255) {
          blendPixel(buffer, bufferOffset + i * 4, c);
        } else {
          final int adjustedAlpha = (c.alpha * cover + 255) >> 8;
          blendPixel(
            buffer,
            bufferOffset + i * 4,
            Color.fromRgba(c.red, c.green, c.blue, adjustedAlpha),
          );
        }
      }
    }
  }

  @override
  Color blend(Color start, Color blend) {
    final temp = Uint8List.fromList([start.blue, start.green, start.red, start.alpha]);
    blendPixel(temp, 0, blend);
    return Color.fromRgba(temp[2], temp[1], temp[0], temp[3]);
  }
}

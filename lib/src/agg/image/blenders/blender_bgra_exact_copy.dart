// Anti-Grain Geometry - Version 2.4
// Copyright (C) 2002-2005 Maxim Shemanarev
// C# port by Lars Brubaker, Dart port by insinfo

import 'dart:typed_data';
import 'package:agg/src/agg/image/rgba.dart';
import 'package:agg/src/agg/primitives/color.dart';

/// BGRA Blender that performs exact copy without blending.
///
/// This blender copies the source color directly to the destination buffer
/// without any alpha blending, except when coverage is applied.
class BlenderBgraExactCopy implements IRecieveBlenderByte {
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
    // Exact copy - no blending, just copy the source color directly
    buffer[bufferOffset] = sourceColor.blue;
    buffer[bufferOffset + 1] = sourceColor.green;
    buffer[bufferOffset + 2] = sourceColor.red;
    buffer[bufferOffset + 3] = sourceColor.alpha;
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
        // Full coverage - direct copy
        for (int i = 0; i < count; i++) {
          blendPixel(
            buffer,
            bufferOffset + i * 4,
            sourceColors[sourceColorsOffset + i],
          );
        }
      } else {
        // Partial coverage - modify alpha and copy
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
    // Exact copy - returns the blend color directly
    return blend;
  }
}

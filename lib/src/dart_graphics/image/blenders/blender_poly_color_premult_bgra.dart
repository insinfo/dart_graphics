// Anti-Grain Geometry - Version 2.4
// Copyright (C) 2002-2005 Maxim Shemanarev
// C# port by Lars Brubaker, Dart port by insinfo

import 'dart:math' as math;
import 'dart:typed_data';
import 'package:dart_graphics/src/dart_graphics/image/rgba.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';

/// BGRA Blender with premultiplied alpha and poly color support.
///
/// This blender applies a polygon color (polyColor) to all operations,
/// effectively tinting all blended content with the specified color.
/// Uses premultiplied alpha for correct compositing.
class BlenderPolyColorPreMultBgra implements IRecieveBlenderByte {
  /// Base mask for 8-bit color values (255)
  static const int baseMask = 255;

  /// Lookup table for saturating 9-bit values to 8-bit bytes
  static final List<int> _saturate9BitToByte = _initSaturateTable();

  /// The polygon color used to tint all operations
  final Color polyColor;

  /// Creates a blender with the specified polygon color.
  BlenderPolyColorPreMultBgra(this.polyColor);

  static List<int> _initSaturateTable() {
    final table = List<int>.filled(1 << 9, 0);
    for (int i = 0; i < table.length; i++) {
      table[i] = math.min(i, 255);
    }
    return table;
  }

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
    // Apply polyColor to the source color
    final int sourceA = _saturate9BitToByte[(polyColor.alpha * sourceColor.alpha + 255) >> 8];
    final int oneOverAlpha = baseMask - sourceA;

    final int sourceR = _saturate9BitToByte[(polyColor.alpha * sourceColor.red + 255) >> 8];
    final int sourceG = _saturate9BitToByte[(polyColor.alpha * sourceColor.green + 255) >> 8];
    final int sourceB = _saturate9BitToByte[(polyColor.alpha * sourceColor.blue + 255) >> 8];

    final int destR = _saturate9BitToByte[((buffer[bufferOffset + 2] * oneOverAlpha + 255) >> 8) + sourceR];
    final int destG = _saturate9BitToByte[((buffer[bufferOffset + 1] * oneOverAlpha + 255) >> 8) + sourceG];
    final int destB = _saturate9BitToByte[((buffer[bufferOffset] * oneOverAlpha + 255) >> 8) + sourceB];

    buffer[bufferOffset + 2] = destR;
    buffer[bufferOffset + 1] = destG;
    buffer[bufferOffset] = destB;
    // Note: Original C# code doesn't update alpha channel in this blender
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
        } else if (cover > 0) {
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


//
// Gray blenders for grayscale image support.
// Supports 8-bit grayscale with alpha blending using ITU-R BT.601 weights.

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/image/rgba.dart';

/// Blender for grayscale images using ITU-R BT.601 luminance weights.
/// Converts RGB to grayscale: gray = R*77 + G*151 + B*28 (approximates 0.299R + 0.587G + 0.114B)
class BlenderGray implements IRecieveBlenderByte {
  static const int baseMask = 255;
  static const int _baseShift = 8;

  /// ITU-R BT.601 weights scaled to integer (sum = 256)
  static const int _weightR = 77;
  static const int _weightG = 151;
  static const int _weightB = 28;

  final int bytesBetweenPixelsInclusive;

  BlenderGray({this.bytesBetweenPixelsInclusive = 1});

  @override
  int get numPixelBits => 8;

  /// Converts an RGB color to grayscale value using ITU-R BT.601 weights
  static int rgbToGray(int r, int g, int b) {
    return (r * _weightR + g * _weightG + b * _weightB) >> 8;
  }

  @override
  Color pixelToColor(Uint8List buffer, int bufferOffset) {
    final int value = buffer[bufferOffset];
    return Color.fromRgba(value, value, value, 255);
  }

  @override
  void copyPixels(
      Uint8List destBuffer, int bufferOffset, Color sourceColor, int count) {
    final int gray = rgbToGray(sourceColor.red, sourceColor.green, sourceColor.blue);
    while (count-- > 0) {
      destBuffer[bufferOffset] = gray;
      bufferOffset += bytesBetweenPixelsInclusive;
    }
  }

  @override
  void blendPixel(Uint8List destBuffer, int bufferOffset, Color sourceColor) {
    final int gray = rgbToGray(sourceColor.red, sourceColor.green, sourceColor.blue);
    final int alpha = sourceColor.alpha;

    if (alpha == 255) {
      destBuffer[bufferOffset] = gray;
    } else if (alpha > 0) {
      final int existing = destBuffer[bufferOffset];
      destBuffer[bufferOffset] =
          (((gray - existing) * alpha + (existing << _baseShift)) >> _baseShift)
              .clamp(0, 255);
    }
  }

  @override
  void blendPixels(
    Uint8List destBuffer,
    int bufferOffset,
    List<Color> sourceColors,
    int sourceColorsOffset,
    Uint8List covers,
    int coversIndex,
    bool firstCoverForAll,
    int count,
  ) {
    if (firstCoverForAll) {
      final int cover = covers[coversIndex];
      if (cover == 255) {
        while (count-- > 0) {
          blendPixel(destBuffer, bufferOffset, sourceColors[sourceColorsOffset++]);
          bufferOffset += bytesBetweenPixelsInclusive;
        }
      } else {
        while (count-- > 0) {
          final Color sc = sourceColors[sourceColorsOffset];
          final Color color = Color.fromRgba(
            sc.red,
            sc.green,
            sc.blue,
            ((sc.alpha * cover + 255) >> 8).clamp(0, 255),
          );
          blendPixel(destBuffer, bufferOffset, color);
          bufferOffset += bytesBetweenPixelsInclusive;
          sourceColorsOffset++;
        }
      }
    } else {
      while (count-- > 0) {
        final int cover = covers[coversIndex++];
        if (cover == 255) {
          blendPixel(destBuffer, bufferOffset, sourceColors[sourceColorsOffset]);
        } else {
          final Color sc = sourceColors[sourceColorsOffset];
          final Color color = Color.fromRgba(
            sc.red,
            sc.green,
            sc.blue,
            ((sc.alpha * cover + 255) >> 8).clamp(0, 255),
          );
          blendPixel(destBuffer, bufferOffset, color);
        }
        bufferOffset += bytesBetweenPixelsInclusive;
        sourceColorsOffset++;
      }
    }
  }

  @override
  Color blend(Color start, Color blendColor) {
    final result = Uint8List.fromList([start.blue, start.green, start.red, start.alpha]);
    blendPixel(result, 0, blendColor);
    return Color.fromRgba(result[2], result[1], result[0], result[3]);
  }
}

/// Blender that extracts gray from the red channel only.
/// Useful when source data is already grayscale stored in red channel.
class BlenderGrayFromRed implements IRecieveBlenderByte {
  static const int baseMask = 255;
  static const int _baseShift = 8;

  final int bytesBetweenPixelsInclusive;

  BlenderGrayFromRed({this.bytesBetweenPixelsInclusive = 1});

  @override
  int get numPixelBits => 8;

  @override
  Color pixelToColor(Uint8List buffer, int bufferOffset) {
    final int value = buffer[bufferOffset];
    return Color.fromRgba(value, value, value, 255);
  }

  @override
  void copyPixels(
      Uint8List destBuffer, int bufferOffset, Color sourceColor, int count) {
    final int gray = sourceColor.red; // Use red channel directly
    while (count-- > 0) {
      destBuffer[bufferOffset] = gray;
      bufferOffset += bytesBetweenPixelsInclusive;
    }
  }

  @override
  void blendPixel(Uint8List destBuffer, int bufferOffset, Color sourceColor) {
    final int gray = sourceColor.red; // Use red channel directly
    final int alpha = sourceColor.alpha;

    if (alpha == 255) {
      destBuffer[bufferOffset] = gray;
    } else if (alpha > 0) {
      final int existing = destBuffer[bufferOffset];
      destBuffer[bufferOffset] =
          (((gray - existing) * alpha + (existing << _baseShift)) >> _baseShift)
              .clamp(0, 255);
    }
  }

  @override
  void blendPixels(
    Uint8List destBuffer,
    int bufferOffset,
    List<Color> sourceColors,
    int sourceColorsOffset,
    Uint8List covers,
    int coversIndex,
    bool firstCoverForAll,
    int count,
  ) {
    if (firstCoverForAll) {
      final int cover = covers[coversIndex];
      if (cover == 255) {
        while (count-- > 0) {
          blendPixel(destBuffer, bufferOffset, sourceColors[sourceColorsOffset++]);
          bufferOffset += bytesBetweenPixelsInclusive;
        }
      } else {
        while (count-- > 0) {
          final Color sc = sourceColors[sourceColorsOffset];
          final Color color = Color.fromRgba(
            sc.red,
            sc.green,
            sc.blue,
            ((sc.alpha * cover + 255) >> 8).clamp(0, 255),
          );
          blendPixel(destBuffer, bufferOffset, color);
          bufferOffset += bytesBetweenPixelsInclusive;
          sourceColorsOffset++;
        }
      }
    } else {
      while (count-- > 0) {
        final int cover = covers[coversIndex++];
        if (cover == 255) {
          blendPixel(destBuffer, bufferOffset, sourceColors[sourceColorsOffset]);
        } else {
          final Color sc = sourceColors[sourceColorsOffset];
          final Color color = Color.fromRgba(
            sc.red,
            sc.green,
            sc.blue,
            ((sc.alpha * cover + 255) >> 8).clamp(0, 255),
          );
          blendPixel(destBuffer, bufferOffset, color);
        }
        bufferOffset += bytesBetweenPixelsInclusive;
        sourceColorsOffset++;
      }
    }
  }

  @override
  Color blend(Color start, Color blendColor) {
    final result = Uint8List.fromList([start.blue, start.green, start.red, start.alpha]);
    blendPixel(result, 0, blendColor);
    return Color.fromRgba(result[2], result[1], result[0], result[3]);
  }
}

/// Blender that uses the maximum of RGB channels as gray value.
/// Useful for certain image processing operations.
class BlenderGrayClampedMax implements IRecieveBlenderByte {
  static const int baseMask = 255;
  static const int _baseShift = 8;

  final int bytesBetweenPixelsInclusive;

  BlenderGrayClampedMax({this.bytesBetweenPixelsInclusive = 1});

  @override
  int get numPixelBits => 8;

  @override
  Color pixelToColor(Uint8List buffer, int bufferOffset) {
    final int value = buffer[bufferOffset];
    return Color.fromRgba(value, value, value, 255);
  }

  int _clampedMax(Color color) {
    return math.min(
      math.max(color.red, math.max(color.green, color.blue)),
      255,
    );
  }

  @override
  void copyPixels(
      Uint8List destBuffer, int bufferOffset, Color sourceColor, int count) {
    final int clampedMax = _clampedMax(sourceColor);
    while (count-- > 0) {
      destBuffer[bufferOffset] = clampedMax;
      bufferOffset += bytesBetweenPixelsInclusive;
    }
  }

  @override
  void blendPixel(Uint8List destBuffer, int bufferOffset, Color sourceColor) {
    final int clampedMax = _clampedMax(sourceColor);
    final int alpha = sourceColor.alpha;

    if (alpha == 255) {
      destBuffer[bufferOffset] = clampedMax;
    } else if (alpha > 0) {
      final int existing = destBuffer[bufferOffset];
      destBuffer[bufferOffset] =
          (((clampedMax - existing) * alpha + (existing << _baseShift)) >>
                  _baseShift)
              .clamp(0, 255);
    }
  }

  @override
  void blendPixels(
    Uint8List destBuffer,
    int bufferOffset,
    List<Color> sourceColors,
    int sourceColorsOffset,
    Uint8List covers,
    int coversIndex,
    bool firstCoverForAll,
    int count,
  ) {
    if (firstCoverForAll) {
      final int cover = covers[coversIndex];
      if (cover == 255) {
        while (count-- > 0) {
          blendPixel(destBuffer, bufferOffset, sourceColors[sourceColorsOffset++]);
          bufferOffset += bytesBetweenPixelsInclusive;
        }
      } else {
        while (count-- > 0) {
          final Color sc = sourceColors[sourceColorsOffset];
          final Color color = Color.fromRgba(
            sc.red,
            sc.green,
            sc.blue,
            ((sc.alpha * cover + 255) >> 8).clamp(0, 255),
          );
          blendPixel(destBuffer, bufferOffset, color);
          bufferOffset += bytesBetweenPixelsInclusive;
          sourceColorsOffset++;
        }
      }
    } else {
      while (count-- > 0) {
        final int cover = covers[coversIndex++];
        if (cover == 255) {
          blendPixel(destBuffer, bufferOffset, sourceColors[sourceColorsOffset]);
        } else {
          final Color sc = sourceColors[sourceColorsOffset];
          final Color color = Color.fromRgba(
            sc.red,
            sc.green,
            sc.blue,
            ((sc.alpha * cover + 255) >> 8).clamp(0, 255),
          );
          blendPixel(destBuffer, bufferOffset, color);
        }
        bufferOffset += bytesBetweenPixelsInclusive;
        sourceColorsOffset++;
      }
    }
  }

  @override
  Color blend(Color start, Color blendColor) {
    final result = Uint8List.fromList([start.blue, start.green, start.red, start.alpha]);
    blendPixel(result, 0, blendColor);
    return Color.fromRgba(result[2], result[1], result[0], result[3]);
  }
}

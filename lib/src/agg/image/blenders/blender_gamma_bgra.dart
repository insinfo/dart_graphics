
//
// Adaptation for high precision colors 

import 'dart:typed_data';

import 'package:dart_graphics/src/agg/gamma_lookup_table.dart';
import 'package:dart_graphics/src/agg/image/rgba.dart';
import 'package:dart_graphics/src/agg/primitives/color.dart';

/// BGRA blender with gamma correction.
///
/// This blender applies gamma correction when writing pixels to the buffer.
/// Gamma correction compensates for the non-linear response of display devices,
/// resulting in perceptually correct color blending.
///
/// The gamma correction is applied using a lookup table for performance.
/// Colors are converted from linear space to gamma-corrected space when
/// writing to the buffer.
class BlenderGammaBgra implements IRecieveBlenderByte {
  static const int _baseMask = 255;
  static const int _baseShift = 8;

  // BGRA order indices  
  static const int orderB = 0;
  static const int orderG = 1;
  static const int orderR = 2;
  static const int orderA = 3;

  GammaLookUpTable _gamma;

  /// Creates a gamma BGRA blender with default gamma (1.0 = no correction).
  BlenderGammaBgra() : _gamma = GammaLookUpTable();

  /// Creates a gamma BGRA blender with a specific gamma lookup table.
  BlenderGammaBgra.withGamma(GammaLookUpTable g) : _gamma = g;

  /// Sets the gamma lookup table.
  void gamma(GammaLookUpTable g) {
    _gamma = g;
  }

  /// Gets the current gamma lookup table.
  GammaLookUpTable getGamma() => _gamma;

  @override
  int get numPixelBits => 32;

  @override
  Color pixelToColor(Uint8List buffer, int bufferOffset) {
    return Color.fromRgba(
      buffer[bufferOffset + orderR],
      buffer[bufferOffset + orderG],
      buffer[bufferOffset + orderB],
      buffer[bufferOffset + orderA],
    );
  }

  @override
  void copyPixels(
      Uint8List buffer, int bufferOffset, Color sourceColor, int count) {
    // Apply inverse gamma to convert from linear to gamma-corrected space
    final r = _gamma.inv(sourceColor.red);
    final g = _gamma.inv(sourceColor.green);
    final b = _gamma.inv(sourceColor.blue);
    final a = sourceColor.alpha;

    while (count-- > 0) {
      buffer[bufferOffset + orderR] = r;
      buffer[bufferOffset + orderG] = g;
      buffer[bufferOffset + orderB] = b;
      buffer[bufferOffset + orderA] = a;
      bufferOffset += 4;
    }
  }

  @override
  void blendPixel(Uint8List buffer, int bufferOffset, Color sourceColor) {
    final srcAlpha = sourceColor.alpha;

    if (srcAlpha == 255) {
      // Fully opaque - just copy with gamma correction
      buffer[bufferOffset + orderR] = _gamma.inv(sourceColor.red);
      buffer[bufferOffset + orderG] = _gamma.inv(sourceColor.green);
      buffer[bufferOffset + orderB] = _gamma.inv(sourceColor.blue);
      buffer[bufferOffset + orderA] = 255;
    } else if (srcAlpha > 0) {
      // Get current pixel values
      final r = buffer[bufferOffset + orderR];
      final g = buffer[bufferOffset + orderG];
      final b = buffer[bufferOffset + orderB];
      final a = buffer[bufferOffset + orderA];

      // Blend in linear space, then apply inverse gamma
      final blendedR =
          ((sourceColor.red - r) * srcAlpha + (r << _baseShift)) >> _baseShift;
      final blendedG =
          ((sourceColor.green - g) * srcAlpha + (g << _baseShift)) >> _baseShift;
      final blendedB =
          ((sourceColor.blue - b) * srcAlpha + (b << _baseShift)) >> _baseShift;

      buffer[bufferOffset + orderR] = _gamma.inv(blendedR);
      buffer[bufferOffset + orderG] = _gamma.inv(blendedG);
      buffer[bufferOffset + orderB] = _gamma.inv(blendedB);
      buffer[bufferOffset + orderA] =
          (srcAlpha + a - ((srcAlpha * a + _baseMask) >> _baseShift))
              .clamp(0, 255);
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
      final cover = sourceCovers[sourceCoversOffset];
      if (cover == 255) {
        while (count-- > 0) {
          blendPixel(buffer, bufferOffset, sourceColors[sourceColorsOffset++]);
          bufferOffset += 4;
        }
      } else {
        while (count-- > 0) {
          final sc = sourceColors[sourceColorsOffset++];
          final scaledAlpha = ((sc.alpha * cover + 255) >> 8).clamp(0, 255);
          final color = Color.fromRgba(sc.red, sc.green, sc.blue, scaledAlpha);
          blendPixel(buffer, bufferOffset, color);
          bufferOffset += 4;
        }
      }
    } else {
      while (count-- > 0) {
        final cover = sourceCovers[sourceCoversOffset++];
        final sc = sourceColors[sourceColorsOffset++];
        final scaledAlpha = ((sc.alpha * cover + 255) >> 8).clamp(0, 255);
        final color = Color.fromRgba(sc.red, sc.green, sc.blue, scaledAlpha);
        blendPixel(buffer, bufferOffset, color);
        bufferOffset += 4;
      }
    }
  }

  @override
  Color blend(Color start, Color blendColor) {
    final result =
        Uint8List.fromList([start.blue, start.green, start.red, start.alpha]);
    blendPixel(result, 0, blendColor);
    return Color.fromRgba(result[2], result[1], result[0], result[3]);
  }
}

/// RGBA blender with gamma correction.
/// 
/// Same as [BlenderGammaBgra] but with RGBA channel order.
class BlenderGammaRgba implements IRecieveBlenderByte {
  static const int _baseMask = 255;
  static const int _baseShift = 8;

  // RGBA order indices
  static const int orderR = 0;
  static const int orderG = 1;
  static const int orderB = 2;
  static const int orderA = 3;

  GammaLookUpTable _gamma;

  /// Creates a gamma RGBA blender with default gamma (1.0 = no correction).
  BlenderGammaRgba() : _gamma = GammaLookUpTable();

  /// Creates a gamma RGBA blender with a specific gamma lookup table.
  BlenderGammaRgba.withGamma(GammaLookUpTable g) : _gamma = g;

  /// Sets the gamma lookup table.
  void gamma(GammaLookUpTable g) {
    _gamma = g;
  }

  /// Gets the current gamma lookup table.
  GammaLookUpTable getGamma() => _gamma;

  @override
  int get numPixelBits => 32;

  @override
  Color pixelToColor(Uint8List buffer, int bufferOffset) {
    return Color.fromRgba(
      buffer[bufferOffset + orderR],
      buffer[bufferOffset + orderG],
      buffer[bufferOffset + orderB],
      buffer[bufferOffset + orderA],
    );
  }

  @override
  void copyPixels(
      Uint8List buffer, int bufferOffset, Color sourceColor, int count) {
    final r = _gamma.inv(sourceColor.red);
    final g = _gamma.inv(sourceColor.green);
    final b = _gamma.inv(sourceColor.blue);
    final a = sourceColor.alpha;

    while (count-- > 0) {
      buffer[bufferOffset + orderR] = r;
      buffer[bufferOffset + orderG] = g;
      buffer[bufferOffset + orderB] = b;
      buffer[bufferOffset + orderA] = a;
      bufferOffset += 4;
    }
  }

  @override
  void blendPixel(Uint8List buffer, int bufferOffset, Color sourceColor) {
    final srcAlpha = sourceColor.alpha;

    if (srcAlpha == 255) {
      buffer[bufferOffset + orderR] = _gamma.inv(sourceColor.red);
      buffer[bufferOffset + orderG] = _gamma.inv(sourceColor.green);
      buffer[bufferOffset + orderB] = _gamma.inv(sourceColor.blue);
      buffer[bufferOffset + orderA] = 255;
    } else if (srcAlpha > 0) {
      final r = buffer[bufferOffset + orderR];
      final g = buffer[bufferOffset + orderG];
      final b = buffer[bufferOffset + orderB];
      final a = buffer[bufferOffset + orderA];

      final blendedR =
          ((sourceColor.red - r) * srcAlpha + (r << _baseShift)) >> _baseShift;
      final blendedG =
          ((sourceColor.green - g) * srcAlpha + (g << _baseShift)) >> _baseShift;
      final blendedB =
          ((sourceColor.blue - b) * srcAlpha + (b << _baseShift)) >> _baseShift;

      buffer[bufferOffset + orderR] = _gamma.inv(blendedR);
      buffer[bufferOffset + orderG] = _gamma.inv(blendedG);
      buffer[bufferOffset + orderB] = _gamma.inv(blendedB);
      buffer[bufferOffset + orderA] =
          (srcAlpha + a - ((srcAlpha * a + _baseMask) >> _baseShift))
              .clamp(0, 255);
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
      final cover = sourceCovers[sourceCoversOffset];
      if (cover == 255) {
        while (count-- > 0) {
          blendPixel(buffer, bufferOffset, sourceColors[sourceColorsOffset++]);
          bufferOffset += 4;
        }
      } else {
        while (count-- > 0) {
          final sc = sourceColors[sourceColorsOffset++];
          final scaledAlpha = ((sc.alpha * cover + 255) >> 8).clamp(0, 255);
          final color = Color.fromRgba(sc.red, sc.green, sc.blue, scaledAlpha);
          blendPixel(buffer, bufferOffset, color);
          bufferOffset += 4;
        }
      }
    } else {
      while (count-- > 0) {
        final cover = sourceCovers[sourceCoversOffset++];
        final sc = sourceColors[sourceColorsOffset++];
        final scaledAlpha = ((sc.alpha * cover + 255) >> 8).clamp(0, 255);
        final color = Color.fromRgba(sc.red, sc.green, sc.blue, scaledAlpha);
        blendPixel(buffer, bufferOffset, color);
        bufferOffset += 4;
      }
    }
  }

  @override
  Color blend(Color start, Color blendColor) {
    final result =
        Uint8List.fromList([start.blue, start.green, start.red, start.alpha]);
    blendPixel(result, 0, blendColor);
    return Color.fromRgba(result[2], result[1], result[0], result[3]);
  }
}



import 'dart:typed_data';

import 'package:agg/src/agg/image/rgba.dart';
import 'package:agg/src/agg/primitives/color.dart';
import 'package:agg/src/agg/gamma_lookup_table.dart';

/// Base class for BGR/RGB blenders with 24-bit pixel format.
abstract class BlenderBaseBgr {
  int get numPixelBits => 24;
  static const int baseMask = 255;
  static const int baseShift = 8;
}

/// BGR blender - standard alpha blending for 24-bit images.
/// BGR order: B=0, G=1, R=2
class BlenderBgr extends BlenderBaseBgr implements IRecieveBlenderByte {
  @override
  Color pixelToColor(Uint8List buffer, int bufferOffset) {
    return Color.fromRgba(
      buffer[bufferOffset + 2], // R
      buffer[bufferOffset + 1], // G
      buffer[bufferOffset + 0], // B
      255,
    );
  }

  @override
  void copyPixels(Uint8List buffer, int bufferOffset, Color sourceColor, int count) {
    do {
      buffer[bufferOffset + 2] = sourceColor.red;
      buffer[bufferOffset + 1] = sourceColor.green;
      buffer[bufferOffset + 0] = sourceColor.blue;
      bufferOffset += 3;
    } while (--count != 0);
  }

  @override
  void blendPixel(Uint8List buffer, int bufferOffset, Color sourceColor) {
    final r = buffer[bufferOffset + 2];
    final g = buffer[bufferOffset + 1];
    final b = buffer[bufferOffset + 0];
    buffer[bufferOffset + 2] =
        (((sourceColor.red - r) * sourceColor.alpha + (r << BlenderBaseBgr.baseShift)) >> BlenderBaseBgr.baseShift) & 0xFF;
    buffer[bufferOffset + 1] =
        (((sourceColor.green - g) * sourceColor.alpha + (g << BlenderBaseBgr.baseShift)) >> BlenderBaseBgr.baseShift) & 0xFF;
    buffer[bufferOffset + 0] =
        (((sourceColor.blue - b) * sourceColor.alpha + (b << BlenderBaseBgr.baseShift)) >> BlenderBaseBgr.baseShift) & 0xFF;
  }

  @override
  Color blend(Color start, Color blendColor) {
    // BGR order: B=0, G=1, R=2
    var result = Uint8List.fromList([start.blue, start.green, start.red]);
    blendPixel(result, 0, blendColor);
    return Color.fromRgba(result[2], result[1], result[0], 255);
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
      final cover = covers[coversIndex];
      if (cover == 255) {
        do {
          blendPixel(destBuffer, bufferOffset, sourceColors[sourceColorsOffset++]);
          bufferOffset += 3;
        } while (--count != 0);
      } else {
        do {
          var sc = sourceColors[sourceColorsOffset];
          sc = Color.fromRgba(
            sc.red,
            sc.green,
            sc.blue,
            ((sc.alpha * cover + 255) >> 8) & 0xFF,
          );
          blendPixel(destBuffer, bufferOffset, sc);
          bufferOffset += 3;
          sourceColorsOffset++;
        } while (--count != 0);
      }
    } else {
      do {
        final cover = covers[coversIndex++];
        if (cover == 255) {
          blendPixel(destBuffer, bufferOffset, sourceColors[sourceColorsOffset]);
        } else {
          var color = sourceColors[sourceColorsOffset];
          color = Color.fromRgba(
            color.red,
            color.green,
            color.blue,
            ((color.alpha * cover + 255) >> 8) & 0xFF,
          );
          blendPixel(destBuffer, bufferOffset, color);
        }
        bufferOffset += 3;
        sourceColorsOffset++;
      } while (--count != 0);
    }
  }
}

/// RGB blender - standard alpha blending for 24-bit images in RGB order.
/// RGB order: R=0, G=1, B=2
class BlenderRgb24 extends BlenderBaseBgr implements IRecieveBlenderByte {
  @override
  Color pixelToColor(Uint8List buffer, int bufferOffset) {
    return Color.fromRgba(
      buffer[bufferOffset + 0], // R
      buffer[bufferOffset + 1], // G
      buffer[bufferOffset + 2], // B
      255,
    );
  }

  @override
  void copyPixels(Uint8List buffer, int bufferOffset, Color sourceColor, int count) {
    do {
      buffer[bufferOffset + 0] = sourceColor.red;
      buffer[bufferOffset + 1] = sourceColor.green;
      buffer[bufferOffset + 2] = sourceColor.blue;
      bufferOffset += 3;
    } while (--count != 0);
  }

  @override
  void blendPixel(Uint8List buffer, int bufferOffset, Color sourceColor) {
    final r = buffer[bufferOffset + 0];
    final g = buffer[bufferOffset + 1];
    final b = buffer[bufferOffset + 2];
    buffer[bufferOffset + 0] =
        (((sourceColor.red - r) * sourceColor.alpha + (r << BlenderBaseBgr.baseShift)) >> BlenderBaseBgr.baseShift) & 0xFF;
    buffer[bufferOffset + 1] =
        (((sourceColor.green - g) * sourceColor.alpha + (g << BlenderBaseBgr.baseShift)) >> BlenderBaseBgr.baseShift) & 0xFF;
    buffer[bufferOffset + 2] =
        (((sourceColor.blue - b) * sourceColor.alpha + (b << BlenderBaseBgr.baseShift)) >> BlenderBaseBgr.baseShift) & 0xFF;
  }

  @override
  Color blend(Color start, Color blendColor) {
    // RGB order: R=0, G=1, B=2
    var result = Uint8List.fromList([start.red, start.green, start.blue]);
    blendPixel(result, 0, blendColor);
    return Color.fromRgba(result[0], result[1], result[2], 255);
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
      final cover = covers[coversIndex];
      if (cover == 255) {
        do {
          blendPixel(destBuffer, bufferOffset, sourceColors[sourceColorsOffset++]);
          bufferOffset += 3;
        } while (--count != 0);
      } else {
        do {
          var sc = sourceColors[sourceColorsOffset];
          sc = Color.fromRgba(
            sc.red,
            sc.green,
            sc.blue,
            ((sc.alpha * cover + 255) >> 8) & 0xFF,
          );
          blendPixel(destBuffer, bufferOffset, sc);
          bufferOffset += 3;
          sourceColorsOffset++;
        } while (--count != 0);
      }
    } else {
      do {
        final cover = covers[coversIndex++];
        if (cover == 255) {
          blendPixel(destBuffer, bufferOffset, sourceColors[sourceColorsOffset]);
        } else {
          var color = sourceColors[sourceColorsOffset];
          color = Color.fromRgba(
            color.red,
            color.green,
            color.blue,
            ((color.alpha * cover + 255) >> 8) & 0xFF,
          );
          blendPixel(destBuffer, bufferOffset, color);
        }
        bufferOffset += 3;
        sourceColorsOffset++;
      } while (--count != 0);
    }
  }
}

/// BGR blender with gamma correction.
class BlenderGammaBgr extends BlenderBaseBgr implements IRecieveBlenderByte {
  GammaLookUpTable _gamma;

  BlenderGammaBgr([GammaLookUpTable? gamma]) : _gamma = gamma ?? GammaLookUpTable();

  void setGamma(GammaLookUpTable g) {
    _gamma = g;
  }

  @override
  Color pixelToColor(Uint8List buffer, int bufferOffset) {
    return Color.fromRgba(
      buffer[bufferOffset + 2], // R
      buffer[bufferOffset + 1], // G
      buffer[bufferOffset + 0], // B
      255,
    );
  }

  @override
  void copyPixels(Uint8List buffer, int bufferOffset, Color sourceColor, int count) {
    buffer[bufferOffset + 2] = _gamma.inv(sourceColor.red);
    buffer[bufferOffset + 1] = _gamma.inv(sourceColor.green);
    buffer[bufferOffset + 0] = _gamma.inv(sourceColor.blue);
  }

  @override
  void blendPixel(Uint8List buffer, int bufferOffset, Color sourceColor) {
    final r = buffer[bufferOffset + 2];
    final g = buffer[bufferOffset + 1];
    final b = buffer[bufferOffset + 0];
    buffer[bufferOffset + 2] = _gamma.inv(
        (((sourceColor.red - r) * sourceColor.alpha + (r << BlenderBaseBgr.baseShift)) >> BlenderBaseBgr.baseShift) & 0xFF);
    buffer[bufferOffset + 1] = _gamma.inv(
        (((sourceColor.green - g) * sourceColor.alpha + (g << BlenderBaseBgr.baseShift)) >> BlenderBaseBgr.baseShift) & 0xFF);
    buffer[bufferOffset + 0] = _gamma.inv(
        (((sourceColor.blue - b) * sourceColor.alpha + (b << BlenderBaseBgr.baseShift)) >> BlenderBaseBgr.baseShift) & 0xFF);
  }

  @override
  Color blend(Color start, Color blendColor) {
    // BGR order: B=0, G=1, R=2
    var result = Uint8List.fromList([start.blue, start.green, start.red]);
    blendPixel(result, 0, blendColor);
    return Color.fromRgba(result[2], result[1], result[0], 255);
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
    // Basic implementation - can be optimized
    if (firstCoverForAll) {
      final cover = sourceCovers[sourceCoversOffset];
      do {
        var sc = sourceColors[sourceColorsOffset++];
        if (cover != 255) {
          sc = Color.fromRgba(
            sc.red,
            sc.green,
            sc.blue,
            ((sc.alpha * cover + 255) >> 8) & 0xFF,
          );
        }
        blendPixel(buffer, bufferOffset, sc);
        bufferOffset += 3;
      } while (--count != 0);
    } else {
      do {
        final cover = sourceCovers[sourceCoversOffset++];
        var sc = sourceColors[sourceColorsOffset++];
        if (cover != 255) {
          sc = Color.fromRgba(
            sc.red,
            sc.green,
            sc.blue,
            ((sc.alpha * cover + 255) >> 8) & 0xFF,
          );
        }
        blendPixel(buffer, bufferOffset, sc);
        bufferOffset += 3;
      } while (--count != 0);
    }
  }
}

/// BGR blender with premultiplied alpha.
class BlenderPreMultBgr extends BlenderBaseBgr implements IRecieveBlenderByte {
  static final List<int> _saturate9BitToByte = _initSaturateTable();

  static List<int> _initSaturateTable() {
    final table = List<int>.filled(1 << 9, 0);
    for (int i = 0; i < table.length; i++) {
      table[i] = i < 255 ? i : 255;
    }
    return table;
  }

  @override
  Color pixelToColor(Uint8List buffer, int bufferOffset) {
    return Color.fromRgba(
      buffer[bufferOffset + 2], // R
      buffer[bufferOffset + 1], // G
      buffer[bufferOffset + 0], // B
      255,
    );
  }

  @override
  void copyPixels(Uint8List buffer, int bufferOffset, Color sourceColor, int count) {
    do {
      buffer[bufferOffset + 2] = sourceColor.red;
      buffer[bufferOffset + 1] = sourceColor.green;
      buffer[bufferOffset + 0] = sourceColor.blue;
      bufferOffset += 3;
    } while (--count != 0);
  }

  @override
  void blendPixel(Uint8List pDestBuffer, int bufferOffset, Color sourceColor) {
    if (sourceColor.alpha == 255) {
      pDestBuffer[bufferOffset + 2] = sourceColor.red;
      pDestBuffer[bufferOffset + 1] = sourceColor.green;
      pDestBuffer[bufferOffset + 0] = sourceColor.blue;
    } else {
      final oneOverAlpha = BlenderBaseBgr.baseMask - sourceColor.alpha;
      final r = _saturate9BitToByte[
          ((pDestBuffer[bufferOffset + 2] * oneOverAlpha + 255) >> 8) + sourceColor.red];
      final g = _saturate9BitToByte[
          ((pDestBuffer[bufferOffset + 1] * oneOverAlpha + 255) >> 8) + sourceColor.green];
      final b = _saturate9BitToByte[
          ((pDestBuffer[bufferOffset + 0] * oneOverAlpha + 255) >> 8) + sourceColor.blue];
      pDestBuffer[bufferOffset + 2] = r;
      pDestBuffer[bufferOffset + 1] = g;
      pDestBuffer[bufferOffset + 0] = b;
    }
  }

  @override
  Color blend(Color start, Color blendColor) {
    // BGR order: B=0, G=1, R=2
    var result = Uint8List.fromList([start.blue, start.green, start.red]);
    blendPixel(result, 0, blendColor);
    return Color.fromRgba(result[2], result[1], result[0], 255);
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
      final cover = covers[coversIndex];
      if (cover == 255) {
        do {
          blendPixel(destBuffer, bufferOffset, sourceColors[sourceColorsOffset++]);
          bufferOffset += 3;
        } while (--count != 0);
      } else {
        do {
          var sc = sourceColors[sourceColorsOffset];
          sc = Color.fromRgba(
            sc.red,
            sc.green,
            sc.blue,
            ((sc.alpha * cover + 255) >> 8) & 0xFF,
          );
          blendPixel(destBuffer, bufferOffset, sc);
          bufferOffset += 3;
          sourceColorsOffset++;
        } while (--count != 0);
      }
    } else {
      do {
        final cover = covers[coversIndex++];
        if (cover == 255) {
          blendPixel(destBuffer, bufferOffset, sourceColors[sourceColorsOffset]);
        } else {
          var color = sourceColors[sourceColorsOffset];
          color = Color.fromRgba(
            color.red,
            color.green,
            color.blue,
            ((color.alpha * cover + 255) >> 8) & 0xFF,
          );
          blendPixel(destBuffer, bufferOffset, color);
        }
        bufferOffset += 3;
        sourceColorsOffset++;
      } while (--count != 0);
    }
  }
}

/// Multiplier functions for premultiplied RGBA operations.
class MultiplierRgba {
  /// Premultiply RGB components by alpha.
  static void premultiply(Uint8List p, int offset, int rOrder, int gOrder, int bOrder, int aOrder) {
    final a = p[offset + aOrder];
    if (a < 255) {
      if (a == 0) {
        p[offset + rOrder] = 0;
        p[offset + gOrder] = 0;
        p[offset + bOrder] = 0;
        return;
      }
      p[offset + rOrder] = ((p[offset + rOrder] * a + 255) >> 8) & 0xFF;
      p[offset + gOrder] = ((p[offset + gOrder] * a + 255) >> 8) & 0xFF;
      p[offset + bOrder] = ((p[offset + bOrder] * a + 255) >> 8) & 0xFF;
    }
  }

  /// Demultiply RGB components by alpha.
  static void demultiply(Uint8List p, int offset, int rOrder, int gOrder, int bOrder, int aOrder) {
    final a = p[offset + aOrder];
    if (a < 255) {
      if (a == 0) {
        p[offset + rOrder] = 0;
        p[offset + gOrder] = 0;
        p[offset + bOrder] = 0;
        return;
      }
      int r = (p[offset + rOrder] * 255) ~/ a;
      int g = (p[offset + gOrder] * 255) ~/ a;
      int b = (p[offset + bOrder] * 255) ~/ a;
      p[offset + rOrder] = r > 255 ? 255 : r;
      p[offset + gOrder] = g > 255 ? 255 : g;
      p[offset + bOrder] = b > 255 ? 255 : b;
    }
  }
}

/// Apply gamma direction to RGB components.
class ApplyGammaDirRgba {
  final GammaLookUpTable _gamma;

  ApplyGammaDirRgba(this._gamma);

  void apply(Uint8List p, int offset, int rOrder, int gOrder, int bOrder) {
    p[offset + rOrder] = _gamma.dir(p[offset + rOrder]);
    p[offset + gOrder] = _gamma.dir(p[offset + gOrder]);
    p[offset + bOrder] = _gamma.dir(p[offset + bOrder]);
  }
}

/// Apply inverse gamma to RGB components.
class ApplyGammaInvRgba {
  final GammaLookUpTable _gamma;

  ApplyGammaInvRgba(this._gamma);

  void apply(Uint8List p, int offset, int rOrder, int gOrder, int bOrder) {
    p[offset + rOrder] = _gamma.inv(p[offset + rOrder]);
    p[offset + gOrder] = _gamma.inv(p[offset + gOrder]);
    p[offset + bOrder] = _gamma.inv(p[offset + bOrder]);
  }
}

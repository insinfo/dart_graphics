import 'dart:math' as math;
import 'dart:typed_data';
import 'package:dart_graphics/src/dart_graphics/image/rgba.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color_f.dart';

/// Simple float (RGBA) blender that mirrors the byte variant for basic tests.
class BlenderRgbaFloat implements IRecieveBlenderFloat {
  static const _componentsPerPixel = 4;

  @override
  int get numPixelBits => 32 * _componentsPerPixel;

  @override
  ColorF PixelToColorRGBA_Floats(List<double> buffer, int bufferOffset) {
    return ColorF(
      buffer[bufferOffset + 0],
      buffer[bufferOffset + 1],
      buffer[bufferOffset + 2],
      buffer[bufferOffset + 3],
    );
  }

  @override
  void CopyPixels(List<double> buffer, int bufferOffset, ColorF sourceColor, int count) {
    final r = sourceColor.red;
    final g = sourceColor.green;
    final b = sourceColor.blue;
    final a = sourceColor.alpha;
    for (var i = 0; i < count; i++) {
      final offset = bufferOffset + i * _componentsPerPixel;
      buffer[offset + 0] = r;
      buffer[offset + 1] = g;
      buffer[offset + 2] = b;
      buffer[offset + 3] = a;
    }
  }

  @override
  void BlendPixel(List<double> buffer, int bufferOffset, ColorF sourceColor) {
    final srcA = sourceColor.alpha.clamp(0.0, 1.0);
    final dstA = buffer[bufferOffset + 3].clamp(0.0, 1.0);
    final invSrcA = 1.0 - srcA;

    final outA = srcA + dstA * invSrcA;
    if (outA <= 0.0) {
      buffer[bufferOffset + 0] = 0;
      buffer[bufferOffset + 1] = 0;
      buffer[bufferOffset + 2] = 0;
      buffer[bufferOffset + 3] = 0;
      return;
    }

    double blendChannel(double src, double dst) {
      return (src * srcA + dst * dstA * invSrcA) / outA;
    }

    buffer[bufferOffset + 0] = blendChannel(sourceColor.red, buffer[bufferOffset + 0]);
    buffer[bufferOffset + 1] = blendChannel(sourceColor.green, buffer[bufferOffset + 1]);
    buffer[bufferOffset + 2] = blendChannel(sourceColor.blue, buffer[bufferOffset + 2]);
    buffer[bufferOffset + 3] = outA;
  }

  @override
  void BlendPixels(
    List<double> buffer,
    int bufferOffset,
    List<ColorF> sourceColors,
    int sourceColorsOffset,
    Uint8List sourceCovers,
    int sourceCoversOffset,
    bool firstCoverForAll,
    int count,
  ) {
    for (var i = 0; i < count; i++) {
      final cover = firstCoverForAll ? sourceCovers[sourceCoversOffset] : sourceCovers[sourceCoversOffset + i];
      final factor = (cover + 1) / 256.0;
      final color = sourceColors[sourceColorsOffset + i];
      final modulated = ColorF(
        color.red * factor,
        color.green * factor,
        color.blue * factor,
        math.min(1.0, color.alpha * factor),
      );
      BlendPixel(buffer, bufferOffset + i * _componentsPerPixel, modulated);
    }
  }
}

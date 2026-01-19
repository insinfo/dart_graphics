import 'dart:math' as math;
import 'dart:typed_data';
import 'package:dart_graphics/src/dart_graphics/graphics2D.dart';
import 'package:dart_graphics/src/dart_graphics/image/blender_rgba_float.dart';
import 'package:dart_graphics/src/dart_graphics/image/iimage.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_graphics_2d.dart';
import 'package:dart_graphics/src/dart_graphics/image/rgba.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color_f.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/rectangle_int.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_rasterizer.dart';
import 'package:dart_graphics/src/vector_math/vector2.dart';

/// Floating-point RGBA image buffer used for high precision rendering tests.
class ImageBufferFloat implements IImageFloat {
  static const _componentsPerPixel = 4;

  @override
  final int bitDepth;

  @override
  Vector2 originOffset = Vector2.zero;

  @override
  final int width;
  @override
  final int height;

  final Float32List _buffer;
  final int _strideInFloats;
  IRecieveBlenderFloat _blender;

  ImageBufferFloat(
    this.width,
    this.height, {
    this.bitDepth = 128,
    IRecieveBlenderFloat? blender,
  })  : _strideInFloats = width * _componentsPerPixel,
        _buffer = Float32List(width * height * _componentsPerPixel),
        _blender = blender ?? BlenderRgbaFloat();

  /// Clear the entire buffer to the given floating color.
  void clear(ColorF color) {
    _blender.copyPixels(_buffer, 0, color, width * height);
  }

  @override
  RectangleInt getBounds() => RectangleInt(0, 0, width - 1, height - 1);

  @override
  int getBufferOffsetY(int y) => y * _strideInFloats;

  @override
  int getBufferOffsetXY(int x, int y) => getBufferOffsetY(y) + x * _componentsPerPixel;

  @override
  Graphics2D newGraphics2D() {
    final g = ImageGraphics2D();
    g.initializeFloat(this, ScanlineRasterizer());
    return g;
  }

  @override
  void markImageChanged() {}

  @override
  int strideInFloats() => _strideInFloats;

  @override
  int strideInFloatsAbs() => _strideInFloats.abs();

  @override
  IRecieveBlenderFloat getBlender() => _blender;

  @override
  void setRecieveBlender(IRecieveBlenderFloat value) {
    _blender = value;
  }

  @override
  int getFloatsBetweenPixelsInclusive() => _componentsPerPixel;

  @override
  Float32List getBuffer() => _buffer;

  @override
  ColorF getPixel(int x, int y) => _blender.pixelToColorRGBAFloats(_buffer, getBufferOffsetXY(x, y));

  @override
  void copyPixel(int x, int y, Float32List c, int floatOffset) {
    final dest = getBufferOffsetXY(x, y);
    for (var i = 0; i < _componentsPerPixel; i++) {
      _buffer[dest + i] = c[floatOffset + i];
    }
  }

  @override
  void copyFrom(IImageFloat sourceImage) {
    _buffer.setAll(0, sourceImage.getBuffer());
  }

  @override
  void copyFromRect(IImageFloat sourceImage, RectangleInt srcRect, int destXOffset, int destYOffset) {
    for (var y = 0; y <= srcRect.top - srcRect.bottom; y++) {
      for (var x = 0; x <= srcRect.right - srcRect.left; x++) {
        final color = sourceImage.getPixel(srcRect.left + x, srcRect.bottom + y);
        setPixel(destXOffset + x, destYOffset + y, color);
      }
    }
  }

  @override
  void setPixel(int x, int y, ColorF color) {
    _blender.copyPixels(_buffer, getBufferOffsetXY(x, y), color, 1);
  }

  @override
  void blendPixel(int x, int y, ColorF sourceColor, int cover) {
    final factor = (cover + 1) / 256.0;
    final c = ColorF(
      sourceColor.red,
      sourceColor.green,
      sourceColor.blue,
      math.min(1.0, sourceColor.alpha * factor),
    );
    _blender.blendPixel(_buffer, getBufferOffsetXY(x, y), c);
  }

  @override
  void copyHline(int x, int y, int len, ColorF sourceColor) {
    _blender.copyPixels(_buffer, getBufferOffsetXY(x, y), sourceColor, len);
  }

  @override
  void copyVline(int x, int y, int len, ColorF sourceColor) {
    for (var i = 0; i < len; i++) {
      setPixel(x, y + i, sourceColor);
    }
  }

  @override
  void blendHline(int x, int y, int x2, ColorF sourceColor, int cover) {
    if (x2 < x) {
      return;
    }
    final len = x2 - x + 1;
    final factor = (cover + 1) / 256.0;
    final blended = ColorF(
      sourceColor.red,
      sourceColor.green,
      sourceColor.blue,
      math.min(1.0, sourceColor.alpha * factor),
    );
    var offset = getBufferOffsetXY(x, y);
    for (var i = 0; i < len; i++) {
      _blender.blendPixel(_buffer, offset, blended);
      offset += _componentsPerPixel;
    }
  }

  @override
  void blendVline(int x, int y1, int y2, ColorF sourceColor, int cover) {
    final factor = (cover + 1) / 256.0;
    final blended = ColorF(
      sourceColor.red,
      sourceColor.green,
      sourceColor.blue,
      math.min(1.0, sourceColor.alpha * factor),
    );
    for (var y = y1; y <= y2; y++) {
      _blender.blendPixel(_buffer, getBufferOffsetXY(x, y), blended);
    }
  }

  @override
  void copyColorHspan(int x, int y, int len, List<ColorF> colors, int colorIndex) {
    for (var i = 0; i < len; i++) {
      setPixel(x + i, y, colors[colorIndex + i]);
    }
  }

  @override
  void copyColorVspan(int x, int y, int len, List<ColorF> colors, int colorIndex) {
    for (var i = 0; i < len; i++) {
      setPixel(x, y + i, colors[colorIndex + i]);
    }
  }

  @override
  void blendSolidHspan(int x, int y, int len, ColorF sourceColor, Uint8List covers, int coversIndex) {
    for (var i = 0; i < len; i++) {
      blendPixel(x + i, y, sourceColor, covers[coversIndex + i]);
    }
  }

  @override
  void blendSolidVspan(int x, int y, int len, ColorF sourceColor, Uint8List covers, int coversIndex) {
    for (var i = 0; i < len; i++) {
      blendPixel(x, y + i, sourceColor, covers[coversIndex + i]);
    }
  }

  @override
  void blendColorHspan(
    int x,
    int y,
    int len,
    List<ColorF> colors,
    int colorsIndex,
    Uint8List covers,
    int coversIndex,
    bool firstCoverForAll,
  ) {
    _blender.blendPixels(
      _buffer,
      getBufferOffsetXY(x, y),
      colors,
      colorsIndex,
      covers,
      coversIndex,
      firstCoverForAll,
      len,
    );
  }

  @override
  void blendColorVspan(
    int x,
    int y,
    int len,
    List<ColorF> colors,
    int colorsIndex,
    Uint8List covers,
    int coversIndex,
    bool firstCoverForAll,
  ) {
    for (var i = 0; i < len; i++) {
      _blender.blendPixels(
        _buffer,
        getBufferOffsetXY(x, y + i),
        colors,
        colorsIndex + i,
        covers,
        coversIndex + (firstCoverForAll ? 0 : i),
        firstCoverForAll,
        1,
      );
    }
  }
}

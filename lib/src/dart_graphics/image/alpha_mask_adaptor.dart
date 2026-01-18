import 'dart:typed_data';
import 'package:dart_graphics/src/dart_graphics/image/iimage.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_proxy.dart';
import 'package:dart_graphics/src/dart_graphics/image/alpha_mask.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';

class AlphaMaskAdaptor extends ImageProxy {
  IAlphaMask m_mask;
  Uint8List m_span;

  static const int spanExtraTail = 256;
  static const int coverFull = 255;

  AlphaMaskAdaptor(IImageByte image, this.m_mask) : m_span = Uint8List(255 + spanExtraTail), super(image);

  void reallocSpan(int len) {
    if (len > m_span.length) {
      m_span = Uint8List(len + spanExtraTail);
    }
  }

  void initSpan(int len, [int cover = coverFull]) {
    reallocSpan(len);
    m_span.fillRange(0, len, cover);
  }

  void initSpanFromCovers(int len, Uint8List covers, int coversIndex) {
    reallocSpan(len);
    for (int i = 0; i < len; i++) {
      m_span[i] = covers[coversIndex + i];
    }
  }

  void attachImage(IImageByte image) {
    linkedImage = image;
  }

  void attachAlphaMask(IAlphaMask mask) {
    m_mask = mask;
  }
  void blendPixelMasked(int x, int y, Color c) {
    linkedImage.blendPixel(x, y, c, m_mask.pixel(x, y));
  }

  @override
  void copyHline(int x, int y, int len, Color c) {
    throw UnimplementedError();
  }

  @override
  void blendHline(int x1, int y, int x2, Color c, int cover) {
    int len = x2 - x1 + 1;
    if (cover == coverFull) {
      reallocSpan(len);
      m_mask.combineHspanFullCover(x1, y, m_span, 0, len);
      linkedImage.blendSolidHspan(x1, y, len, c, m_span, 0);
    } else {
      initSpan(len, cover);
      m_mask.combineHspan(x1, y, m_span, 0, len);
      linkedImage.blendSolidHspan(x1, y, len, c, m_span, 0);
    }
  }

  @override
  void copyVline(int x, int y, int len, Color c) {
    throw UnimplementedError();
  }

  @override
  void blendVline(int x, int y1, int y2, Color c, int cover) {
    throw UnimplementedError();
  }

  @override
  void blendSolidHspan(int x, int y, int len, Color color, Uint8List covers, int coversIndex) {
    m_mask.combineHspan(x, y, covers, coversIndex, len);
    linkedImage.blendSolidHspan(x, y, len, color, covers, coversIndex);
  }

  @override
  void blendSolidVspan(int x, int y, int len, Color c, Uint8List covers, int coversIndex) {
    throw UnimplementedError();
  }

  @override
  void copyColorHspan(int x, int y, int len, List<Color> colors, int colorsIndex) {
    throw UnimplementedError();
  }

  @override
  void copyColorVspan(int x, int y, int len, List<Color> colors, int colorsIndex) {
    throw UnimplementedError();
  }

  @override
  void blendColorHspan(int x, int y, int len, List<Color> colors, int colorsIndex, Uint8List covers, int coversIndex, bool firstCoverForAll) {
    throw UnimplementedError();
  }

  @override
  void blendColorVspan(int x, int y, int len, List<Color> colors, int colorsIndex, Uint8List covers, int coversIndex, bool firstCoverForAll) {
    throw UnimplementedError();
  }
}

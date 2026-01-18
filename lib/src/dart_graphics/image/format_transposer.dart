import 'dart:typed_data';
import 'package:dart_graphics/src/dart_graphics/image/iimage.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_proxy.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';

class FormatTransposer extends ImageProxy {
  FormatTransposer(IImageByte linkedImage) : super(linkedImage);

  @override
  int get width => linkedImage.height;

  @override
  int get height => linkedImage.width;

  @override
  Color getPixel(int x, int y) {
    return linkedImage.getPixel(y, x);
  }

  @override
  void copyPixel(int x, int y, Uint8List c, int byteOffset) {
    linkedImage.copyPixel(y, x, c, byteOffset);
  }

  @override
  void copyHline(int x, int y, int len, Color c) {
    linkedImage.copyVline(y, x, len, c);
  }

  @override
  void copyVline(int x, int y, int len, Color c) {
    linkedImage.copyHline(y, x, len, c);
  }

  @override
  void blendHline(int x1, int y, int x2, Color c, int cover) {
    linkedImage.blendVline(y, x1, x2, c, cover);
  }

  @override
  void blendVline(int x, int y1, int y2, Color c, int cover) {
    linkedImage.blendHline(y1, x, y2, c, cover);
  }

  @override
  void blendSolidHspan(int x, int y, int len, Color c, Uint8List covers, int coversIndex) {
    linkedImage.blendSolidVspan(y, x, len, c, covers, coversIndex);
  }

  @override
  void blendSolidVspan(int x, int y, int len, Color c, Uint8List covers, int coversIndex) {
    linkedImage.blendSolidHspan(y, x, len, c, covers, coversIndex);
  }

  @override
  void copyColorHspan(int x, int y, int len, List<Color> colors, int colorsIndex) {
    linkedImage.copyColorVspan(y, x, len, colors, colorsIndex);
  }

  @override
  void copyColorVspan(int x, int y, int len, List<Color> colors, int colorsIndex) {
    linkedImage.copyColorHspan(y, x, len, colors, colorsIndex);
  }

  @override
  void blendColorHspan(int x, int y, int len, List<Color> colors, int colorsIndex, Uint8List covers, int coversIndex, bool firstCoverForAll) {
    linkedImage.blendColorVspan(y, x, len, colors, colorsIndex, covers, coversIndex, firstCoverForAll);
  }

  @override
  void blendColorVspan(int x, int y, int len, List<Color> colors, int colorsIndex, Uint8List covers, int coversIndex, bool firstCoverForAll) {
    linkedImage.blendColorHspan(y, x, len, colors, colorsIndex, covers, coversIndex, firstCoverForAll);
  }
}

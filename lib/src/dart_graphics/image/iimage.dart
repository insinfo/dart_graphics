import 'dart:typed_data';
import 'package:dart_graphics/src/dart_graphics/image/rgba.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color_f.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/rectangle_int.dart';
import 'package:dart_graphics/src/vector_math/vector2.dart';
import '../graphics2D.dart';

abstract class IImage {
  int get bitDepth;

  Vector2 get originOffset;
  set originOffset(Vector2 v);

  int get width;
  int get height;

  RectangleInt getBounds();

  int getBufferOffsetY(int y);

  int getBufferOffsetXY(int x, int y);

  Graphics2D newGraphics2D();

  void markImageChanged();
}

/*
Em Java: byte[] => Em Dart: Uint8List que equivale a List<int> so que mais eficiente
 */
abstract class IImageByte extends IImage {
  int strideInBytes();

  int strideInBytesAbs();

  IRecieveBlenderByte getRecieveBlender();

  void setRecieveBlender(IRecieveBlenderByte value);

  int getBytesBetweenPixelsInclusive();

  Uint8List getBuffer();

  Color getPixel(int x, int y);

  void copyPixel(int x, int y, Uint8List c, int byteOffset);

  void copyFrom(IImageByte sourceImage);

  void copyFromRect(IImageByte sourceImage, RectangleInt sourceImageRect, int destXOffset, int destYOffset);

  void setPixel(int x, int y, Color color);

  void blendPixel(int x, int y, Color sourceColor, int cover);

  // line stuff
  void copyHline(int x, int y, int len, Color sourceColor);

  void copyVline(int x, int y, int len, Color sourceColor);

  void blendHline(int x, int y, int x2, Color sourceColor, int cover);

  void blendVline(int x, int y1, int y2, Color sourceColor, int cover);

  // color stuff
    void copyColorHspan(int x, int y, int len, List<Color> colors, int colorIndex);

    void copyColorVspan(int x, int y, int len, List<Color> colors, int colorIndex);

    void blendSolidHspan(int x, int y, int len, Color sourceColor, Uint8List covers, int coversIndex);

    void blendSolidVspan(int x, int y, int len, Color sourceColor, Uint8List covers, int coversIndex);

    void blendColorHspan(int x, int y, int len, List<Color> colors, int colorsIndex, Uint8List covers, int coversIndex,
      bool firstCoverForAll);

    void blendColorVspan(int x, int y, int len, List<Color> colors, int colorsIndex, Uint8List covers, int coversIndex,
      bool firstCoverForAll);
}

abstract class IImageFloat extends IImage {
  int strideInFloats();

  int strideInFloatsAbs();

  IRecieveBlenderFloat getBlender();

  void setRecieveBlender(IRecieveBlenderFloat value);

  int getFloatsBetweenPixelsInclusive();

  Float32List getBuffer();

  ColorF getPixel(int x, int y);

  void copyPixel(int x, int y, Float32List c, int floatOffset);

  void copyFrom(IImageFloat sourceImage);

  void copyFromRect(IImageFloat sourceImage, RectangleInt sourceImageRect, int destXOffset, int destYOffset);

  void setPixel(int x, int y, ColorF color);

  void blendPixel(int x, int y, ColorF sourceColor, int cover);

  // line stuff
  void copyHline(int x, int y, int len, ColorF sourceColor);

  void copyVline(int x, int y, int len, ColorF sourceColor);

  void blendHline(int x, int y, int x2, ColorF sourceColor, int cover);

  void blendVline(int x, int y1, int y2, ColorF sourceColor, int cover);

  // color stuff
    void copyColorHspan(int x, int y, int len, List<ColorF> colors, int colorIndex);

    void copyColorVspan(int x, int y, int len, List<ColorF> colors, int colorIndex);

    void blendSolidHspan(int x, int y, int len, ColorF sourceColor, Uint8List covers, int coversIndex);

    void blendSolidVspan(int x, int y, int len, ColorF sourceColor, Uint8List covers, int coversIndex);

    void blendColorHspan(int x, int y, int len, List<ColorF> colors, int colorsIndex, Uint8List covers, int coversIndex,
      bool firstCoverForAll);

    void blendColorVspan(int x, int y, int len, List<ColorF> colors, int colorsIndex, Uint8List covers, int coversIndex,
      bool firstCoverForAll);
}

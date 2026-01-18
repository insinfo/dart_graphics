import 'dart:typed_data';
import 'package:dart_graphics/src/dart_graphics/image/iimage.dart';
import 'package:dart_graphics/src/dart_graphics/image/rgba.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/rectangle_int.dart';
import 'package:dart_graphics/src/vector_math/vector2.dart';
import '../graphics2D.dart';

abstract class ImageProxy extends IImageByte {
  IImageByte linkedImage;

  ImageProxy(this.linkedImage);

  void linkToImage(IImageByte linkedImage) {
    this.linkedImage = linkedImage;
  }

  @override
  int get bitDepth => linkedImage.bitDepth;

  @override
  Vector2 get originOffset => linkedImage.originOffset;

  @override
  set originOffset(Vector2 v) => linkedImage.originOffset = v;

  @override
  int get width => linkedImage.width;

  @override
  int get height => linkedImage.height;

  @override
  RectangleInt getBounds() => linkedImage.getBounds();

  @override
  int getBufferOffsetY(int y) => linkedImage.getBufferOffsetY(y);

  @override
  int getBufferOffsetXY(int x, int y) => linkedImage.getBufferOffsetXY(x, y);

  @override
  Graphics2D newGraphics2D() => linkedImage.newGraphics2D();

  @override
  void markImageChanged() => linkedImage.markImageChanged();

  @override
  int strideInBytes() => linkedImage.strideInBytes();

  @override
  int strideInBytesAbs() => linkedImage.strideInBytesAbs();

  @override
  IRecieveBlenderByte getRecieveBlender() => linkedImage.getRecieveBlender();

  @override
  void setRecieveBlender(IRecieveBlenderByte value) => linkedImage.setRecieveBlender(value);

  @override
  int getBytesBetweenPixelsInclusive() => linkedImage.getBytesBetweenPixelsInclusive();

  @override
  Uint8List getBuffer() => linkedImage.getBuffer();

  @override
  Color getPixel(int x, int y) => linkedImage.getPixel(x, y);

  @override
  void copyPixel(int x, int y, Uint8List c, int byteOffset) => linkedImage.copyPixel(x, y, c, byteOffset);

  @override
  void copyFrom(IImageByte sourceImage) => linkedImage.copyFrom(sourceImage);

  @override
  void copyFromRect(IImageByte sourceImage, RectangleInt sourceImageRect, int destXOffset, int destYOffset) => linkedImage.copyFromRect(sourceImage, sourceImageRect, destXOffset, destYOffset);

  @override
  void setPixel(int x, int y, Color color) => linkedImage.setPixel(x, y, color);

  @override
  void blendPixel(int x, int y, Color sourceColor, int cover) => linkedImage.blendPixel(x, y, sourceColor, cover);

  @override
  void copyHline(int x, int y, int len, Color sourceColor) => linkedImage.copyHline(x, y, len, sourceColor);

  @override
  void copyVline(int x, int y, int len, Color sourceColor) => linkedImage.copyVline(x, y, len, sourceColor);

  @override
  void blendHline(int x, int y, int x2, Color sourceColor, int cover) => linkedImage.blendHline(x, y, x2, sourceColor, cover);

  @override
  void blendVline(int x, int y1, int y2, Color sourceColor, int cover) => linkedImage.blendVline(x, y1, y2, sourceColor, cover);

  @override
  void copyColorHspan(int x, int y, int len, List<Color> colors, int colorIndex) => linkedImage.copyColorHspan(x, y, len, colors, colorIndex);

  @override
  void copyColorVspan(int x, int y, int len, List<Color> colors, int colorIndex) => linkedImage.copyColorVspan(x, y, len, colors, colorIndex);

  @override
  void blendSolidHspan(int x, int y, int len, Color sourceColor, Uint8List covers, int coversIndex) => linkedImage.blendSolidHspan(x, y, len, sourceColor, covers, coversIndex);

  @override
  void blendSolidVspan(int x, int y, int len, Color sourceColor, Uint8List covers, int coversIndex) => linkedImage.blendSolidVspan(x, y, len, sourceColor, covers, coversIndex);

  @override
  void blendColorHspan(int x, int y, int len, List<Color> colors, int colorsIndex, Uint8List covers, int coversIndex, bool firstCoverForAll) => linkedImage.blendColorHspan(x, y, len, colors, colorsIndex, covers, coversIndex, firstCoverForAll);

  @override
  void blendColorVspan(int x, int y, int len, List<Color> colors, int colorsIndex, Uint8List covers, int coversIndex, bool firstCoverForAll) => linkedImage.blendColorVspan(x, y, len, colors, colorsIndex, covers, coversIndex, firstCoverForAll);
}

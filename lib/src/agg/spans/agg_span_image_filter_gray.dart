

import 'package:dart_graphics/src/agg/agg_image_filters.dart';
import 'package:dart_graphics/src/agg/image/raster_buffer_accessors.dart';
import 'package:dart_graphics/src/agg/primitives/color.dart';
import 'package:dart_graphics/src/agg/spans/agg_span_image_filter.dart';
import 'package:dart_graphics/src/agg/spans/agg_span_interpolator_linear.dart';

/// Nearest-neighbor grayscale image filter optimized for step X by 1.
///
/// This filter samples grayscale pixels using nearest-neighbor interpolation
/// when stepping exactly 1 pixel in the X direction. This is an optimization
/// for common cases like axis-aligned image scaling.
class SpanImageFilterGrayNnStepXby1 extends SpanImageFilter {

  SpanImageFilterGrayNnStepXby1(
    IImageBufferAccessor sourceAccessor,
    ISpanInterpolator spanInterpolator,
  ) : super(sourceAccessor, spanInterpolator, null);

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    final sourceRenderingBuffer = getImageBufferAccessor().sourceImage;
    final bytesBetweenPixelsInclusive =
        sourceRenderingBuffer.getBytesBetweenPixelsInclusive();

    if (sourceRenderingBuffer.bitDepth != 8) {
      throw UnsupportedError('The source is expected to be 8 bit grayscale.');
    }

    final spanInterpolator = interpolator();
    spanInterpolator.begin(x + filterDxDbl(), y + filterDyDbl(), len);

    final xy = [0, 0];
    spanInterpolator.coordinates(xy);
    final xHr = xy[0];
    final yHr = xy[1];

    final xLr = xHr >> ImageSubpixelScale.imageSubpixelShift;
    final yLr = yHr >> ImageSubpixelScale.imageSubpixelShift;

    var bufferIndex = sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);
    final fgPtr = sourceRenderingBuffer.getBuffer();

    do {
      final gray = fgPtr[bufferIndex];
      span[spanIndex] = Color.fromRgba(gray, gray, gray, 255);
      spanIndex++;
      bufferIndex += bytesBetweenPixelsInclusive;
    } while (--len != 0);
  }
}

/// Nearest-neighbor grayscale image filter.
///
/// This filter samples grayscale pixels using nearest-neighbor interpolation,
/// supporting arbitrary transformations through the span interpolator.
class SpanImageFilterGrayNn extends SpanImageFilter {

  SpanImageFilterGrayNn(
    IImageBufferAccessor sourceAccessor,
    ISpanInterpolator spanInterpolator,
  ) : super(sourceAccessor, spanInterpolator, null);

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    final sourceRenderingBuffer = getImageBufferAccessor().sourceImage;

    if (sourceRenderingBuffer.bitDepth != 8) {
      throw UnsupportedError('The source is expected to be 8 bit grayscale.');
    }

    final spanInterpolator = interpolator();
    spanInterpolator.begin(x + filterDxDbl(), y + filterDyDbl(), len);

    final fgPtr = sourceRenderingBuffer.getBuffer();
    final xy = [0, 0];

    do {
      spanInterpolator.coordinates(xy);
      final xHr = xy[0];
      final yHr = xy[1];

      final xLr = xHr >> ImageSubpixelScale.imageSubpixelShift;
      final yLr = yHr >> ImageSubpixelScale.imageSubpixelShift;

      final bufferIndex = sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);
      final gray = fgPtr[bufferIndex];

      span[spanIndex] = Color.fromRgba(gray, gray, gray, 255);
      spanIndex++;
      spanInterpolator.next();
    } while (--len != 0);
  }
}

/// Bilinear grayscale image filter.
///
/// This filter samples grayscale pixels using bilinear interpolation,
/// providing smooth scaling for grayscale images.
class SpanImageFilterGrayBilinear extends SpanImageFilter {
  static const int _baseMask = 255;

  SpanImageFilterGrayBilinear(
    IImageBufferAccessor sourceAccessor,
    ISpanInterpolator spanInterpolator,
  ) : super(sourceAccessor, spanInterpolator, null);

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    final sourceRenderingBuffer = getImageBufferAccessor().sourceImage;

    if (sourceRenderingBuffer.bitDepth != 8) {
      throw UnsupportedError('The source is expected to be 8 bit grayscale.');
    }

    interpolator().begin(x + filterDxDbl(), y + filterDyDbl(), len);

    final spanInterpolator = interpolator();
    final fgPtr = sourceRenderingBuffer.getBuffer();
    final xy = [0, 0];

    do {
      int fg;

      spanInterpolator.coordinates(xy);
      var xHr = xy[0];
      var yHr = xy[1];

      xHr -= filterDxInt();
      yHr -= filterDyInt();

      final xLr = xHr >> ImageSubpixelScale.imageSubpixelShift;
      final yLr = yHr >> ImageSubpixelScale.imageSubpixelShift;
      int weight;

      fg = ImageSubpixelScale.imageSubpixelScale *
          ImageSubpixelScale.imageSubpixelScale ~/
          2;

      xHr &= ImageSubpixelScale.imageSubpixelMask;
      yHr &= ImageSubpixelScale.imageSubpixelMask;

      // Get the four surrounding pixels
      var bufferIndex = sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);

      // Top-left pixel
      weight = (ImageSubpixelScale.imageSubpixelScale - xHr) *
          (ImageSubpixelScale.imageSubpixelScale - yHr);
      fg += weight * fgPtr[bufferIndex];

      // Top-right pixel
      final bufferIndexRight =
          sourceRenderingBuffer.getBufferOffsetXY(xLr + 1, yLr);
      weight =
          xHr * (ImageSubpixelScale.imageSubpixelScale - yHr);
      fg += weight * fgPtr[bufferIndexRight];

      // Bottom-left pixel
      final bufferIndexBottom =
          sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr + 1);
      weight =
          (ImageSubpixelScale.imageSubpixelScale - xHr) * yHr;
      fg += weight * fgPtr[bufferIndexBottom];

      // Bottom-right pixel
      final bufferIndexBottomRight =
          sourceRenderingBuffer.getBufferOffsetXY(xLr + 1, yLr + 1);
      weight = xHr * yHr;
      fg += weight * fgPtr[bufferIndexBottomRight];

      fg >>= ImageSubpixelScale.imageSubpixelShift * 2;
      if (fg > _baseMask) fg = _baseMask;

      span[spanIndex] = Color.fromRgba(fg, fg, fg, 255);
      spanIndex++;
      spanInterpolator.next();
    } while (--len != 0);
  }
}

/// Bilinear grayscale image filter with clipping and background color.
///
/// This filter handles cases where the sampled coordinates fall outside
/// the source image bounds by using a background color.
class SpanImageFilterGrayBilinearClip extends SpanImageFilter {
  static const int _baseMask = 255;

  Color _backgroundColor;

  SpanImageFilterGrayBilinearClip(
    IImageBufferAccessor sourceAccessor,
    Color backgroundColor,
    ISpanInterpolator spanInterpolator,
  )   : _backgroundColor = backgroundColor,
        super(sourceAccessor, spanInterpolator, null);

  /// Gets the background color used for out-of-bounds sampling.
  Color get backgroundColor => _backgroundColor;

  /// Sets the background color used for out-of-bounds sampling.
  set backgroundColor(Color value) => _backgroundColor = value;

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    final sourceRenderingBuffer = getImageBufferAccessor().sourceImage;

    interpolator().begin(x + filterDxDbl(), y + filterDyDbl(), len);

    final backV = (_backgroundColor.red + _backgroundColor.green + _backgroundColor.blue) ~/ 3;
    final backA = _backgroundColor.alpha;

    final fgPtr = sourceRenderingBuffer.getBuffer();
    final maxx = sourceRenderingBuffer.width - 1;
    final maxy = sourceRenderingBuffer.height - 1;
    final spanInterpolator = interpolator();
    final xy = [0, 0];

    do {
      int fg;
      int srcAlpha;

      spanInterpolator.coordinates(xy);
      var xHr = xy[0];
      var yHr = xy[1];

      xHr -= filterDxInt();
      yHr -= filterDyInt();

      var xLr = xHr >> ImageSubpixelScale.imageSubpixelShift;
      var yLr = yHr >> ImageSubpixelScale.imageSubpixelShift;

      if (xLr >= 0 && yLr >= 0 && xLr < maxx && yLr < maxy) {
        // Inside the image - do standard bilinear interpolation
        fg = ImageSubpixelScale.imageSubpixelScale *
            ImageSubpixelScale.imageSubpixelScale ~/
            2;

        xHr &= ImageSubpixelScale.imageSubpixelMask;
        yHr &= ImageSubpixelScale.imageSubpixelMask;

        var bufferIndex = sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);

        int weight = (ImageSubpixelScale.imageSubpixelScale - xHr) *
            (ImageSubpixelScale.imageSubpixelScale - yHr);
        fg += weight * fgPtr[bufferIndex];

        final bufferIndexRight =
            sourceRenderingBuffer.getBufferOffsetXY(xLr + 1, yLr);
        weight = xHr * (ImageSubpixelScale.imageSubpixelScale - yHr);
        fg += weight * fgPtr[bufferIndexRight];

        final bufferIndexBottom =
            sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr + 1);
        weight = (ImageSubpixelScale.imageSubpixelScale - xHr) * yHr;
        fg += weight * fgPtr[bufferIndexBottom];

        final bufferIndexBottomRight =
            sourceRenderingBuffer.getBufferOffsetXY(xLr + 1, yLr + 1);
        weight = xHr * yHr;
        fg += weight * fgPtr[bufferIndexBottomRight];

        fg >>= ImageSubpixelScale.imageSubpixelShift * 2;
        srcAlpha = _baseMask;
      } else {
        // Outside or on edge - blend with background
        if (xLr < -1 || yLr < -1 || xLr > maxx || yLr > maxy) {
          fg = backV;
          srcAlpha = backA;
        } else {
          fg = ImageSubpixelScale.imageSubpixelScale *
              ImageSubpixelScale.imageSubpixelScale ~/
              2;
          srcAlpha = ImageSubpixelScale.imageSubpixelScale *
              ImageSubpixelScale.imageSubpixelScale ~/
              2;

          xHr &= ImageSubpixelScale.imageSubpixelMask;
          yHr &= ImageSubpixelScale.imageSubpixelMask;

          int weight = (ImageSubpixelScale.imageSubpixelScale - xHr) *
              (ImageSubpixelScale.imageSubpixelScale - yHr);
          if (xLr >= 0 && yLr >= 0 && xLr <= maxx && yLr <= maxy) {
            final bufferIndex =
                sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);
            fg += weight * fgPtr[bufferIndex];
            srcAlpha += weight * _baseMask;
          } else {
            fg += backV * weight;
            srcAlpha += backA * weight;
          }

          xLr++;
          weight = xHr * (ImageSubpixelScale.imageSubpixelScale - yHr);
          if (xLr >= 0 && yLr >= 0 && xLr <= maxx && yLr <= maxy) {
            final bufferIndex =
                sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);
            fg += weight * fgPtr[bufferIndex];
            srcAlpha += weight * _baseMask;
          } else {
            fg += backV * weight;
            srcAlpha += backA * weight;
          }

          xLr--;
          yLr++;
          weight = (ImageSubpixelScale.imageSubpixelScale - xHr) * yHr;
          if (xLr >= 0 && yLr >= 0 && xLr <= maxx && yLr <= maxy) {
            final bufferIndex =
                sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);
            fg += weight * fgPtr[bufferIndex];
            srcAlpha += weight * _baseMask;
          } else {
            fg += backV * weight;
            srcAlpha += backA * weight;
          }

          xLr++;
          weight = xHr * yHr;
          if (xLr >= 0 && yLr >= 0 && xLr <= maxx && yLr <= maxy) {
            final bufferIndex =
                sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);
            fg += weight * fgPtr[bufferIndex];
            srcAlpha += weight * _baseMask;
          } else {
            fg += backV * weight;
            srcAlpha += backA * weight;
          }

          fg >>= ImageSubpixelScale.imageSubpixelShift * 2;
          srcAlpha >>= ImageSubpixelScale.imageSubpixelShift * 2;
        }
      }

      span[spanIndex] = Color.fromRgba(fg, fg, fg, srcAlpha);
      spanIndex++;
      spanInterpolator.next();
    } while (--len != 0);
  }
}

/// General grayscale image filter using custom filter kernels.
///
/// This filter applies a configurable image filter kernel (such as
/// Lanczos, Gaussian, etc.) to grayscale images.
class SpanImageFilterGray extends SpanImageFilter {
  static const int _baseMask = 255;

  SpanImageFilterGray(
    IImageBufferAccessor sourceAccessor,
    ISpanInterpolator spanInterpolator,
    ImageFilterLookUpTable filter,
  ) : super(sourceAccessor, spanInterpolator, filter);

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    final sourceRenderingBuffer = getImageBufferAccessor().sourceImage;
    final filterTable = filter()!;

    interpolator().begin(x + filterDxDbl(), y + filterDyDbl(), len);

    final diameter = filterTable.diameter();
    final start = filterTable.start();
    final weightArray = filterTable.weightArray();

    final fgPtr = sourceRenderingBuffer.getBuffer();
    final spanInterpolator = interpolator();
    final xy = [0, 0];

    do {
      int fg;

      spanInterpolator.coordinates(xy);
      var xCoord = xy[0];
      var yCoord = xy[1];

      xCoord -= filterDxInt();
      yCoord -= filterDyInt();

      final xHr = xCoord;
      final yHr = yCoord;

      final xLr = xHr >> ImageSubpixelScale.imageSubpixelShift;
      final yLr = yHr >> ImageSubpixelScale.imageSubpixelShift;

      fg = ImageFilterScale.imageFilterScale ~/ 2;

      final xFract = xHr & ImageSubpixelScale.imageSubpixelMask;
      var yCount = diameter;

      var yHrCalc = ImageSubpixelScale.imageSubpixelMask -
          (yHr & ImageSubpixelScale.imageSubpixelMask);

      for (var j = 0; j < yCount; j++) {
        var xCount = diameter;
        final weightY = weightArray[yHrCalc];
        var xHrCalc = ImageSubpixelScale.imageSubpixelMask - xFract;

        for (var i = 0; i < xCount; i++) {
          final px = xLr + start + i;
          final py = yLr + start + j;

          if (px >= 0 &&
              px < sourceRenderingBuffer.width &&
              py >= 0 &&
              py < sourceRenderingBuffer.height) {
            final bufferIndex =
                sourceRenderingBuffer.getBufferOffsetXY(px, py);
            final pixelValue = fgPtr[bufferIndex];

            final weight = (weightY * weightArray[xHrCalc] +
                    ImageFilterScale.imageFilterScale ~/ 2) >>
                ImageFilterScale.imageFilterShift;

            fg += pixelValue * weight;
          }

          xHrCalc += ImageSubpixelScale.imageSubpixelScale;
        }

        yHrCalc += ImageSubpixelScale.imageSubpixelScale;
      }

      fg >>= ImageFilterScale.imageFilterShift;
      if (fg < 0) fg = 0;
      if (fg > _baseMask) fg = _baseMask;

      span[spanIndex] = Color.fromRgba(fg, fg, fg, 255);
      spanIndex++;
      spanInterpolator.next();
    } while (--len != 0);
  }
}

/// 2x2 grayscale image filter.
///
/// Optimized filter for 2x2 kernel operations on grayscale images.
class SpanImageFilterGray2x2 extends SpanImageFilter {
  static const int _baseMask = 255;

  SpanImageFilterGray2x2(
    IImageBufferAccessor sourceAccessor,
    ISpanInterpolator spanInterpolator,
    ImageFilterLookUpTable filter,
  ) : super(sourceAccessor, spanInterpolator, filter);

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    final sourceRenderingBuffer = getImageBufferAccessor().sourceImage;
    final filterTable = filter()!;

    interpolator().begin(x + filterDxDbl(), y + filterDyDbl(), len);

    final weightArray = filterTable.weightArray();
    final weightArrayOffset = ((filterTable.diameter() ~/ 2 - 1) <<
        ImageSubpixelScale.imageSubpixelShift);

    final fgPtr = sourceRenderingBuffer.getBuffer();
    final spanInterpolator = interpolator();
    final xy = [0, 0];

    do {
      int fg;

      spanInterpolator.coordinates(xy);
      var xHr = xy[0];
      var yHr = xy[1];

      xHr -= filterDxInt();
      yHr -= filterDyInt();

      final xLr = xHr >> ImageSubpixelScale.imageSubpixelShift;
      final yLr = yHr >> ImageSubpixelScale.imageSubpixelShift;

      fg = ImageFilterScale.imageFilterScale ~/ 2;

      xHr &= ImageSubpixelScale.imageSubpixelMask;
      yHr &= ImageSubpixelScale.imageSubpixelMask;

      // Sample the 2x2 neighborhood
      int weight;

      // Top-left
      if (xLr >= 0 &&
          xLr < sourceRenderingBuffer.width &&
          yLr >= 0 &&
          yLr < sourceRenderingBuffer.height) {
        final bufferIndex = sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);
        weight = (weightArray[
                    weightArrayOffset + xHr + ImageSubpixelScale.imageSubpixelScale] *
                weightArray[
                    weightArrayOffset + yHr + ImageSubpixelScale.imageSubpixelScale] +
            ImageFilterScale.imageFilterScale ~/ 2) >>
            ImageFilterScale.imageFilterShift;
        fg += weight * fgPtr[bufferIndex];
      }

      // Top-right
      if (xLr + 1 >= 0 &&
          xLr + 1 < sourceRenderingBuffer.width &&
          yLr >= 0 &&
          yLr < sourceRenderingBuffer.height) {
        final bufferIndex =
            sourceRenderingBuffer.getBufferOffsetXY(xLr + 1, yLr);
        weight = (weightArray[weightArrayOffset + xHr] *
                    weightArray[
                        weightArrayOffset + yHr + ImageSubpixelScale.imageSubpixelScale] +
                ImageFilterScale.imageFilterScale ~/ 2) >>
            ImageFilterScale.imageFilterShift;
        fg += weight * fgPtr[bufferIndex];
      }

      // Bottom-left
      if (xLr >= 0 &&
          xLr < sourceRenderingBuffer.width &&
          yLr + 1 >= 0 &&
          yLr + 1 < sourceRenderingBuffer.height) {
        final bufferIndex =
            sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr + 1);
        weight = (weightArray[
                    weightArrayOffset + xHr + ImageSubpixelScale.imageSubpixelScale] *
                weightArray[weightArrayOffset + yHr] +
            ImageFilterScale.imageFilterScale ~/ 2) >>
            ImageFilterScale.imageFilterShift;
        fg += weight * fgPtr[bufferIndex];
      }

      // Bottom-right
      if (xLr + 1 >= 0 &&
          xLr + 1 < sourceRenderingBuffer.width &&
          yLr + 1 >= 0 &&
          yLr + 1 < sourceRenderingBuffer.height) {
        final bufferIndex =
            sourceRenderingBuffer.getBufferOffsetXY(xLr + 1, yLr + 1);
        weight = (weightArray[weightArrayOffset + xHr] *
                    weightArray[weightArrayOffset + yHr] +
                ImageFilterScale.imageFilterScale ~/ 2) >>
            ImageFilterScale.imageFilterShift;
        fg += weight * fgPtr[bufferIndex];
      }

      fg >>= ImageFilterScale.imageFilterShift;
      if (fg > _baseMask) fg = _baseMask;

      span[spanIndex] = Color.fromRgba(fg, fg, fg, 255);
      spanIndex++;
      spanInterpolator.next();
    } while (--len != 0);
  }
}

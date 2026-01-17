//----------------------------------------------------------------------------
// Anti-Grain Geometry - Version 2.4
// Copyright (C) 2002-2005 Maxim Shemanarev (http://www.antigrain.com)
//
// Dart port by: AGG-Dart project
//
// Permission to copy, use, modify, sell and distribute this software
// is granted provided this copyright notice appears in all copies.
// This software is provided "as is" without express or implied
// warranty, and with no claim as to its suitability for any purpose.
//----------------------------------------------------------------------------

import 'dart:typed_data';

import 'package:dart_graphics/src/agg/agg_image_filters.dart';
import 'package:dart_graphics/src/agg/image/iimage.dart';
import 'package:dart_graphics/src/agg/image/raster_buffer_accessors.dart';
import 'package:dart_graphics/src/agg/primitives/color.dart';
import 'package:dart_graphics/src/agg/spans/agg_span_image_filter.dart';
import 'package:dart_graphics/src/agg/spans/agg_span_interpolator_linear.dart';

/// Nearest-neighbor RGB image filter optimized for step X by 1.
///
/// This filter samples 24-bit RGB pixels using nearest-neighbor interpolation
/// when stepping exactly 1 pixel in the X direction.
class SpanImageFilterRgbNnStepXby1 extends SpanImageFilter {

  SpanImageFilterRgbNnStepXby1(
    IImageBufferAccessor sourceAccessor,
    ISpanInterpolator spanInterpolator,
  ) : super(sourceAccessor, spanInterpolator, null);

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    final sourceRenderingBuffer = getImageBufferAccessor().sourceImage;

    if (sourceRenderingBuffer.bitDepth != 24) {
      throw UnsupportedError('The source is expected to be 24 bit RGB.');
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
      // RGB order in 24-bit buffer: B, G, R
      span[spanIndex] = Color.fromRgba(
        fgPtr[bufferIndex + 2], // R
        fgPtr[bufferIndex + 1], // G
        fgPtr[bufferIndex + 0], // B
        255,
      );
      spanIndex++;
      bufferIndex += 3;
    } while (--len != 0);
  }
}

/// Nearest-neighbor RGB image filter.
///
/// This filter samples 24-bit RGB pixels using nearest-neighbor interpolation,
/// supporting arbitrary transformations through the span interpolator.
class SpanImageFilterRgbNn extends SpanImageFilter {

  SpanImageFilterRgbNn(
    IImageBufferAccessor sourceAccessor,
    ISpanInterpolator spanInterpolator,
  ) : super(sourceAccessor, spanInterpolator, null);

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    final sourceRenderingBuffer = getImageBufferAccessor().sourceImage;

    if (sourceRenderingBuffer.bitDepth != 24) {
      throw UnsupportedError('The source is expected to be 24 bit RGB.');
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

      span[spanIndex] = Color.fromRgba(
        fgPtr[bufferIndex + 2], // R
        fgPtr[bufferIndex + 1], // G
        fgPtr[bufferIndex + 0], // B
        255,
      );
      spanIndex++;
      spanInterpolator.next();
    } while (--len != 0);
  }
}

/// Bilinear RGB image filter.
///
/// This filter samples 24-bit RGB pixels using bilinear interpolation,
/// providing smooth scaling for RGB images.
class SpanImageFilterRgbBilinear extends SpanImageFilter {

  SpanImageFilterRgbBilinear(
    IImageBufferAccessor sourceAccessor,
    ISpanInterpolator spanInterpolator,
  ) : super(sourceAccessor, spanInterpolator, null) {
    if (sourceAccessor.sourceImage.getBytesBetweenPixelsInclusive() != 3) {
      throw UnsupportedError(
          'span_image_filter_rgb_bilinear must have a 24 bit DestImage');
    }
  }

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    final sourceRenderingBuffer = getImageBufferAccessor().sourceImage;

    interpolator().begin(x + filterDxDbl(), y + filterDyDbl(), len);

    final spanInterpolator = interpolator();
    final fgPtr = sourceRenderingBuffer.getBuffer();
    final xy = [0, 0];

    do {
      int tempR, tempG, tempB;

      spanInterpolator.coordinates(xy);
      var xHr = xy[0];
      var yHr = xy[1];

      xHr -= filterDxInt();
      yHr -= filterDyInt();

      var xLr = xHr >> ImageSubpixelScale.imageSubpixelShift;
      var yLr = yHr >> ImageSubpixelScale.imageSubpixelShift;
      int weight;

      tempR = tempG = tempB = ImageSubpixelScale.imageSubpixelScale *
          ImageSubpixelScale.imageSubpixelScale ~/
          2;

      xHr &= ImageSubpixelScale.imageSubpixelMask;
      yHr &= ImageSubpixelScale.imageSubpixelMask;

      var bufferIndex = sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);

      // Top-left pixel
      weight = (ImageSubpixelScale.imageSubpixelScale - xHr) *
          (ImageSubpixelScale.imageSubpixelScale - yHr);
      tempR += weight * fgPtr[bufferIndex + 2];
      tempG += weight * fgPtr[bufferIndex + 1];
      tempB += weight * fgPtr[bufferIndex + 0];
      bufferIndex += 3;

      // Top-right pixel
      weight = xHr * (ImageSubpixelScale.imageSubpixelScale - yHr);
      tempR += weight * fgPtr[bufferIndex + 2];
      tempG += weight * fgPtr[bufferIndex + 1];
      tempB += weight * fgPtr[bufferIndex + 0];

      yLr++;
      bufferIndex = sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);

      // Bottom-left pixel
      weight = (ImageSubpixelScale.imageSubpixelScale - xHr) * yHr;
      tempR += weight * fgPtr[bufferIndex + 2];
      tempG += weight * fgPtr[bufferIndex + 1];
      tempB += weight * fgPtr[bufferIndex + 0];
      bufferIndex += 3;

      // Bottom-right pixel
      weight = xHr * yHr;
      tempR += weight * fgPtr[bufferIndex + 2];
      tempG += weight * fgPtr[bufferIndex + 1];
      tempB += weight * fgPtr[bufferIndex + 0];

      tempR >>= ImageSubpixelScale.imageSubpixelShift * 2;
      tempG >>= ImageSubpixelScale.imageSubpixelShift * 2;
      tempB >>= ImageSubpixelScale.imageSubpixelShift * 2;

      span[spanIndex] = Color.fromRgba(tempR, tempG, tempB, 255);
      spanIndex++;
      spanInterpolator.next();
    } while (--len != 0);
  }
}

/// Bilinear RGB image filter with clipping and background color.
///
/// This filter handles cases where the sampled coordinates fall outside
/// the source image bounds by using a background color.
class SpanImageFilterRgbBilinearClip extends SpanImageFilter {
  static const int _baseMask = 255;

  Color _outsideSourceColor;

  SpanImageFilterRgbBilinearClip(
    IImageBufferAccessor sourceAccessor,
    Color backColor,
    ISpanInterpolator spanInterpolator,
  )   : _outsideSourceColor = backColor,
        super(sourceAccessor, spanInterpolator, null);

  /// Gets the background color used for out-of-bounds sampling.
  Color get backgroundColor => _outsideSourceColor;

  /// Sets the background color used for out-of-bounds sampling.
  set backgroundColor(Color value) {
    _outsideSourceColor = value;
  }

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    interpolator().begin(x + filterDxDbl(), y + filterDyDbl(), len);

    final accumulatedColor = [0, 0, 0];
    int sourceAlpha;

    final backR = _outsideSourceColor.red;
    final backG = _outsideSourceColor.green;
    final backB = _outsideSourceColor.blue;
    final backA = _outsideSourceColor.alpha;

    final sourceRenderingBuffer = getImageBufferAccessor().sourceImage;
    final maxx = sourceRenderingBuffer.width - 1;
    final maxy = sourceRenderingBuffer.height - 1;
    final spanInterpolator = interpolator();
    final fgPtr = sourceRenderingBuffer.getBuffer();
    final xy = [0, 0];

    do {
      spanInterpolator.coordinates(xy);
      var xHr = xy[0];
      var yHr = xy[1];

      xHr -= filterDxInt();
      yHr -= filterDyInt();

      var xLr = xHr >> ImageSubpixelScale.imageSubpixelShift;
      var yLr = yHr >> ImageSubpixelScale.imageSubpixelShift;
      int weight;

      if (xLr >= 0 && yLr >= 0 && xLr < maxx && yLr < maxy) {
        // Inside the image - do standard bilinear interpolation
        accumulatedColor[0] = accumulatedColor[1] = accumulatedColor[2] =
            ImageSubpixelScale.imageSubpixelScale *
                ImageSubpixelScale.imageSubpixelScale ~/
                2;

        xHr &= ImageSubpixelScale.imageSubpixelMask;
        yHr &= ImageSubpixelScale.imageSubpixelMask;

        var bufferIndex = sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);

        weight = (ImageSubpixelScale.imageSubpixelScale - xHr) *
            (ImageSubpixelScale.imageSubpixelScale - yHr);
        accumulatedColor[0] += weight * fgPtr[bufferIndex + 2];
        accumulatedColor[1] += weight * fgPtr[bufferIndex + 1];
        accumulatedColor[2] += weight * fgPtr[bufferIndex + 0];

        bufferIndex += 3;
        weight = xHr * (ImageSubpixelScale.imageSubpixelScale - yHr);
        accumulatedColor[0] += weight * fgPtr[bufferIndex + 2];
        accumulatedColor[1] += weight * fgPtr[bufferIndex + 1];
        accumulatedColor[2] += weight * fgPtr[bufferIndex + 0];

        yLr++;
        bufferIndex = sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);

        weight = (ImageSubpixelScale.imageSubpixelScale - xHr) * yHr;
        accumulatedColor[0] += weight * fgPtr[bufferIndex + 2];
        accumulatedColor[1] += weight * fgPtr[bufferIndex + 1];
        accumulatedColor[2] += weight * fgPtr[bufferIndex + 0];

        bufferIndex += 3;
        weight = xHr * yHr;
        accumulatedColor[0] += weight * fgPtr[bufferIndex + 2];
        accumulatedColor[1] += weight * fgPtr[bufferIndex + 1];
        accumulatedColor[2] += weight * fgPtr[bufferIndex + 0];

        accumulatedColor[0] >>= ImageSubpixelScale.imageSubpixelShift * 2;
        accumulatedColor[1] >>= ImageSubpixelScale.imageSubpixelShift * 2;
        accumulatedColor[2] >>= ImageSubpixelScale.imageSubpixelShift * 2;

        sourceAlpha = _baseMask;
      } else {
        // Outside or on edge - blend with background
        if (xLr < -1 || yLr < -1 || xLr > maxx || yLr > maxy) {
          accumulatedColor[0] = backR;
          accumulatedColor[1] = backG;
          accumulatedColor[2] = backB;
          sourceAlpha = backA;
        } else {
          accumulatedColor[0] = accumulatedColor[1] = accumulatedColor[2] =
              ImageSubpixelScale.imageSubpixelScale *
                  ImageSubpixelScale.imageSubpixelScale ~/
                  2;
          sourceAlpha = ImageSubpixelScale.imageSubpixelScale *
              ImageSubpixelScale.imageSubpixelScale ~/
              2;

          xHr &= ImageSubpixelScale.imageSubpixelMask;
          yHr &= ImageSubpixelScale.imageSubpixelMask;

          weight = (ImageSubpixelScale.imageSubpixelScale - xHr) *
              (ImageSubpixelScale.imageSubpixelScale - yHr);
          _blendInFilterPixel(
              accumulatedColor, sourceAlpha, backR, backG, backB, backA,
              sourceRenderingBuffer, fgPtr, maxx, maxy, xLr, yLr, weight);

          xLr++;
          weight = xHr * (ImageSubpixelScale.imageSubpixelScale - yHr);
          _blendInFilterPixel(
              accumulatedColor, sourceAlpha, backR, backG, backB, backA,
              sourceRenderingBuffer, fgPtr, maxx, maxy, xLr, yLr, weight);

          xLr--;
          yLr++;
          weight = (ImageSubpixelScale.imageSubpixelScale - xHr) * yHr;
          _blendInFilterPixel(
              accumulatedColor, sourceAlpha, backR, backG, backB, backA,
              sourceRenderingBuffer, fgPtr, maxx, maxy, xLr, yLr, weight);

          xLr++;
          weight = xHr * yHr;
          _blendInFilterPixel(
              accumulatedColor, sourceAlpha, backR, backG, backB, backA,
              sourceRenderingBuffer, fgPtr, maxx, maxy, xLr, yLr, weight);

          accumulatedColor[0] >>= ImageSubpixelScale.imageSubpixelShift * 2;
          accumulatedColor[1] >>= ImageSubpixelScale.imageSubpixelShift * 2;
          accumulatedColor[2] >>= ImageSubpixelScale.imageSubpixelShift * 2;
          sourceAlpha >>= ImageSubpixelScale.imageSubpixelShift * 2;
        }
      }

      span[spanIndex] = Color.fromRgba(
        accumulatedColor[0],
        accumulatedColor[1],
        accumulatedColor[2],
        sourceAlpha,
      );
      spanIndex++;
      spanInterpolator.next();
    } while (--len != 0);
  }

  void _blendInFilterPixel(
    List<int> accumulatedColor,
    int sourceAlpha,
    int backR,
    int backG,
    int backB,
    int backA,
    IImageByte sourceRenderingBuffer,
    Uint8List fgPtr,
    int maxx,
    int maxy,
    int xLr,
    int yLr,
    int weight,
  ) {
    if (xLr >= 0 && xLr <= maxx && yLr >= 0 && yLr <= maxy) {
      final bufferIndex = sourceRenderingBuffer.getBufferOffsetXY(xLr, yLr);
      accumulatedColor[0] += weight * fgPtr[bufferIndex + 2];
      accumulatedColor[1] += weight * fgPtr[bufferIndex + 1];
      accumulatedColor[2] += weight * fgPtr[bufferIndex + 0];
      // sourceAlpha += weight * _baseMask; // Would need ref parameter
    } else {
      accumulatedColor[0] += backR * weight;
      accumulatedColor[1] += backG * weight;
      accumulatedColor[2] += backB * weight;
      // sourceAlpha += backA * weight;
    }
  }
}

/// General RGB image filter using custom filter kernels.
///
/// This filter applies a configurable image filter kernel (such as
/// Lanczos, Gaussian, etc.) to 24-bit RGB images.
class SpanImageFilterRgb extends SpanImageFilter {
  static const int _baseMask = 255;

  SpanImageFilterRgb(
    IImageBufferAccessor sourceAccessor,
    ISpanInterpolator spanInterpolator,
    ImageFilterLookUpTable filter,
  ) : super(sourceAccessor, spanInterpolator, filter) {
    if (sourceAccessor.sourceImage.getBytesBetweenPixelsInclusive() != 3) {
      throw UnsupportedError('span_image_filter_rgb must have a 24 bit DestImage');
    }
  }

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    final sourceRenderingBuffer = getImageBufferAccessor().sourceImage;
    final filterTable = filter()!;

    interpolator().begin(x + filterDxDbl(), y + filterDyDbl(), len);

    int fR, fG, fB;

    final diameter = filterTable.diameter();
    final start = filterTable.start();
    final weightArray = filterTable.weightArray();

    final fgPtr = sourceRenderingBuffer.getBuffer();
    final spanInterpolator = interpolator();
    final xy = [0, 0];

    do {
      spanInterpolator.coordinates(xy);
      var xCoord = xy[0];
      var yCoord = xy[1];

      xCoord -= filterDxInt();
      yCoord -= filterDyInt();

      final xHr = xCoord;
      final yHr = yCoord;

      final xLr = xHr >> ImageSubpixelScale.imageSubpixelShift;
      final yLr = yHr >> ImageSubpixelScale.imageSubpixelShift;

      fR = fG = fB = ImageFilterScale.imageFilterScale ~/ 2;

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
            final bufferIndex = sourceRenderingBuffer.getBufferOffsetXY(px, py);

            final weight = (weightY * weightArray[xHrCalc] +
                    ImageFilterScale.imageFilterScale ~/ 2) >>
                ImageFilterScale.imageFilterShift;

            fR += fgPtr[bufferIndex + 2] * weight;
            fG += fgPtr[bufferIndex + 1] * weight;
            fB += fgPtr[bufferIndex + 0] * weight;
          }

          xHrCalc += ImageSubpixelScale.imageSubpixelScale;
        }

        yHrCalc += ImageSubpixelScale.imageSubpixelScale;
      }

      fR >>= ImageFilterScale.imageFilterShift;
      fG >>= ImageFilterScale.imageFilterShift;
      fB >>= ImageFilterScale.imageFilterShift;

      if (fR < 0) fR = 0;
      if (fR > _baseMask) fR = _baseMask;
      if (fG < 0) fG = 0;
      if (fG > _baseMask) fG = _baseMask;
      if (fB < 0) fB = 0;
      if (fB > _baseMask) fB = _baseMask;

      span[spanIndex] = Color.fromRgba(fR, fG, fB, 255);
      spanIndex++;
      spanInterpolator.next();
    } while (--len != 0);
  }
}

/// RGB image resampler with dynamic scaling.
///
/// This filter supports dynamic scaling factors determined by the
/// span interpolator, useful for perspective and other non-linear transforms.
class SpanImageResampleRgb extends SpanImageResample {
  static const int _baseMask = 255;
  static const int _downscaleShift = ImageFilterScale.imageFilterShift;

  SpanImageResampleRgb(
    IImageBufferAccessor sourceAccessor,
    ISpanInterpolator spanInterpolator,
    ImageFilterLookUpTable filter,
  ) : super(sourceAccessor, spanInterpolator, filter) {
    if (sourceAccessor.sourceImage.getRecieveBlender().numPixelBits != 24) {
      throw UnsupportedError(
          'You have to use a rgb blender with span_image_resample_rgb');
    }
  }

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    final spanInterpolator = interpolator();
    spanInterpolator.begin(x + filterDxDbl(), y + filterDyDbl(), len);

    final fg = [0, 0, 0];

    final weightArray = filter()!.weightArray();
    final diameter = filter()!.diameter();
    final filterScale = diameter << ImageSubpixelScale.imageSubpixelShift;

    final fgPtr = getImageBufferAccessor().sourceImage.getBuffer();
    final xy = [0, 0];
    final rxRy = [0, 0];

    do {
      spanInterpolator.coordinates(xy);
      var xCoord = xy[0];
      var yCoord = xy[1];

      spanInterpolator.localScale(rxRy);
      var rx = rxRy[0];
      var ry = rxRy[1];

      adjustScale(rxRy);
      rx = rxRy[0];
      ry = rxRy[1];

      var rxInv = ImageSubpixelScale.imageSubpixelScale *
          ImageSubpixelScale.imageSubpixelScale ~/
          rx;
      var ryInv = ImageSubpixelScale.imageSubpixelScale *
          ImageSubpixelScale.imageSubpixelScale ~/
          ry;

      final radiusX = (diameter * rx) >> 1;
      final radiusY = (diameter * ry) >> 1;
      // lenXLr is used in original C# for span() but not needed here
      // since we access pixels directly

      xCoord += filterDxInt() - radiusX;
      yCoord += filterDyInt() - radiusY;

      fg[0] = fg[1] = fg[2] = ImageFilterScale.imageFilterScale ~/ 2;

      final yLr = yCoord >> ImageSubpixelScale.imageSubpixelShift;
      var yHr = ((ImageSubpixelScale.imageSubpixelMask -
                  (yCoord & ImageSubpixelScale.imageSubpixelMask)) *
              ryInv) >>
          ImageSubpixelScale.imageSubpixelShift;
      var totalWeight = 0;
      final xLr = xCoord >> ImageSubpixelScale.imageSubpixelShift;
      var xHr = ((ImageSubpixelScale.imageSubpixelMask -
                  (xCoord & ImageSubpixelScale.imageSubpixelMask)) *
              rxInv) >>
          ImageSubpixelScale.imageSubpixelShift;
      final xHr2 = xHr;

      final sourceImage = getImageBufferAccessor().sourceImage;

      for (;;) {
        final weightY = weightArray[yHr];
        xHr = xHr2;

        for (var px = xLr; ; px++) {
          if (px >= 0 &&
              px < sourceImage.width &&
              yLr >= 0 &&
              yLr < sourceImage.height) {
            final bufferIndex = sourceImage.getBufferOffsetXY(px, yLr);

            final weight = (weightY * weightArray[xHr] +
                    ImageFilterScale.imageFilterScale ~/ 2) >>
                _downscaleShift;

            fg[0] += fgPtr[bufferIndex + 2] * weight;
            fg[1] += fgPtr[bufferIndex + 1] * weight;
            fg[2] += fgPtr[bufferIndex + 0] * weight;
            totalWeight += weight;
          }

          xHr += rxInv;
          if (xHr >= filterScale) break;
        }

        yHr += ryInv;
        if (yHr >= filterScale) break;
      }

      if (totalWeight > 0) {
        fg[0] ~/= totalWeight;
        fg[1] ~/= totalWeight;
        fg[2] ~/= totalWeight;
      }

      if (fg[0] < 0) fg[0] = 0;
      if (fg[1] < 0) fg[1] = 0;
      if (fg[2] < 0) fg[2] = 0;
      if (fg[0] > _baseMask) fg[0] = _baseMask;
      if (fg[1] > _baseMask) fg[1] = _baseMask;
      if (fg[2] > _baseMask) fg[2] = _baseMask;

      span[spanIndex] = Color.fromRgba(fg[0], fg[1], fg[2], _baseMask);
      spanIndex++;
      spanInterpolator.next();
    } while (--len != 0);
  }
}

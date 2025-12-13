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
//
// Adaptation for high precision colors has been sponsored by
// Liberty Technology Systems, Inc., visit http://lib-sys.com
//----------------------------------------------------------------------------

import 'dart:typed_data';

import 'package:agg/src/agg/image/rgba.dart';
import 'package:agg/src/agg/primitives/color_f.dart';

/// Float-based BGRA blender with support for high precision color operations.
///
/// This blender uses floating-point components for higher precision in
/// color calculations, particularly useful for HDR rendering and
/// compositing operations that require more than 8-bit accuracy.
class BlenderBgraFloat implements IRecieveBlenderFloat {
  // BGRA order indices
  static const int orderB = 0;
  static const int orderG = 1;
  static const int orderR = 2;
  static const int orderA = 3;

  static const int _componentsPerPixel = 4;

  const BlenderBgraFloat();

  @override
  int get numPixelBits => 32 * _componentsPerPixel; // 128 bits for 4 floats

  @override
  ColorF PixelToColorRGBA_Floats(List<double> buffer, int bufferOffset) {
    return ColorF(
      buffer[bufferOffset + orderR],
      buffer[bufferOffset + orderG],
      buffer[bufferOffset + orderB],
      buffer[bufferOffset + orderA],
    );
  }

  @override
  void CopyPixels(
      List<double> buffer, int bufferOffset, ColorF sourceColor, int count) {
    while (count-- > 0) {
      buffer[bufferOffset + orderR] = sourceColor.red;
      buffer[bufferOffset + orderG] = sourceColor.green;
      buffer[bufferOffset + orderB] = sourceColor.blue;
      buffer[bufferOffset + orderA] = sourceColor.alpha;
      bufferOffset += _componentsPerPixel;
    }
  }

  @override
  void BlendPixel(List<double> buffer, int bufferOffset, ColorF sourceColor) {
    final srcAlpha = sourceColor.alpha;

    if (srcAlpha == 1.0) {
      // Opaque source - direct copy
      buffer[bufferOffset + orderR] = sourceColor.red;
      buffer[bufferOffset + orderG] = sourceColor.green;
      buffer[bufferOffset + orderB] = sourceColor.blue;
      buffer[bufferOffset + orderA] = sourceColor.alpha;
    } else if (srcAlpha > 0.0) {
      // Alpha blend
      final r = buffer[bufferOffset + orderR];
      final g = buffer[bufferOffset + orderG];
      final b = buffer[bufferOffset + orderB];
      final a = buffer[bufferOffset + orderA];

      buffer[bufferOffset + orderR] =
          (sourceColor.red - r) * srcAlpha + r;
      buffer[bufferOffset + orderG] =
          (sourceColor.green - g) * srcAlpha + g;
      buffer[bufferOffset + orderB] =
          (sourceColor.blue - b) * srcAlpha + b;
      buffer[bufferOffset + orderA] =
          (srcAlpha + a) - srcAlpha * a;
    }
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
    if (firstCoverForAll) {
      final cover = sourceCovers[sourceCoversOffset];
      final coverFactor = (cover + 1) / 256.0;

      for (var i = 0; i < count; i++) {
        final color = sourceColors[sourceColorsOffset + i];
        final modulated = ColorF(
          color.red,
          color.green,
          color.blue,
          color.alpha * coverFactor,
        );
        BlendPixel(buffer, bufferOffset, modulated);
        bufferOffset += _componentsPerPixel;
      }
    } else {
      for (var i = 0; i < count; i++) {
        final cover = sourceCovers[sourceCoversOffset + i];
        final coverFactor = (cover + 1) / 256.0;
        final color = sourceColors[sourceColorsOffset + i];
        final modulated = ColorF(
          color.red,
          color.green,
          color.blue,
          color.alpha * coverFactor,
        );
        BlendPixel(buffer, bufferOffset, modulated);
        bufferOffset += _componentsPerPixel;
      }
    }
  }
}

/// Float-based premultiplied BGRA blender.
///
/// Assumes colors are stored with premultiplied alpha for faster compositing.
class BlenderPreMultBgraFloat implements IRecieveBlenderFloat {
  static const int orderB = 0;
  static const int orderG = 1;
  static const int orderR = 2;
  static const int orderA = 3;

  static const int _componentsPerPixel = 4;

  const BlenderPreMultBgraFloat();

  @override
  int get numPixelBits => 32 * _componentsPerPixel;

  @override
  ColorF PixelToColorRGBA_Floats(List<double> buffer, int bufferOffset) {
    final a = buffer[bufferOffset + orderA];
    if (a > 0.0) {
      return ColorF(
        buffer[bufferOffset + orderR] / a,
        buffer[bufferOffset + orderG] / a,
        buffer[bufferOffset + orderB] / a,
        a,
      );
    }
    return ColorF(0, 0, 0, 0);
  }

  @override
  void CopyPixels(
      List<double> buffer, int bufferOffset, ColorF sourceColor, int count) {
    // Premultiply the source color
    final a = sourceColor.alpha;
    final r = sourceColor.red * a;
    final g = sourceColor.green * a;
    final b = sourceColor.blue * a;

    while (count-- > 0) {
      buffer[bufferOffset + orderR] = r;
      buffer[bufferOffset + orderG] = g;
      buffer[bufferOffset + orderB] = b;
      buffer[bufferOffset + orderA] = a;
      bufferOffset += _componentsPerPixel;
    }
  }

  @override
  void BlendPixel(List<double> buffer, int bufferOffset, ColorF sourceColor) {
    final srcAlpha = sourceColor.alpha;

    if (srcAlpha > 0.0) {
      // Source is premultiplied for this blender
      final srcR = sourceColor.red * srcAlpha;
      final srcG = sourceColor.green * srcAlpha;
      final srcB = sourceColor.blue * srcAlpha;

      final invAlpha = 1.0 - srcAlpha;

      buffer[bufferOffset + orderR] =
          srcR + buffer[bufferOffset + orderR] * invAlpha;
      buffer[bufferOffset + orderG] =
          srcG + buffer[bufferOffset + orderG] * invAlpha;
      buffer[bufferOffset + orderB] =
          srcB + buffer[bufferOffset + orderB] * invAlpha;
      buffer[bufferOffset + orderA] =
          srcAlpha + buffer[bufferOffset + orderA] * invAlpha;
    }
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
    if (firstCoverForAll) {
      final cover = sourceCovers[sourceCoversOffset];
      final coverFactor = (cover + 1) / 256.0;

      for (var i = 0; i < count; i++) {
        final color = sourceColors[sourceColorsOffset + i];
        final modulated = ColorF(
          color.red,
          color.green,
          color.blue,
          color.alpha * coverFactor,
        );
        BlendPixel(buffer, bufferOffset, modulated);
        bufferOffset += _componentsPerPixel;
      }
    } else {
      for (var i = 0; i < count; i++) {
        final cover = sourceCovers[sourceCoversOffset + i];
        final coverFactor = (cover + 1) / 256.0;
        final color = sourceColors[sourceColorsOffset + i];
        final modulated = ColorF(
          color.red,
          color.green,
          color.blue,
          color.alpha * coverFactor,
        );
        BlendPixel(buffer, bufferOffset, modulated);
        bufferOffset += _componentsPerPixel;
      }
    }
  }
}

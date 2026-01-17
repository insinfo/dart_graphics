
//
// Permission to copy, use, modify, sell and distribute this software
// is granted provided this copyright notice appears in all copies.
// This software is provided "as is" without express or implied
// warranty, and with no claim as to its suitability for any purpose.
//
//----------------------------------------------------------------------------
//
// Color type gray8 - 8-bit grayscale color with alpha
//
//----------------------------------------------------------------------------

import 'primitives/color.dart';
import 'primitives/color_f.dart';
import 'util.dart';

/// 8-bit grayscale color with alpha channel
class ColorGray8 {
  static const int baseShift = 8;
  static const int baseScale = 1 << baseShift; // 256
  static const int baseMask = baseScale - 1; // 255

  /// Gray value (0-255)
  int v;

  /// Alpha value (0-255)
  int a;

  /// Creates a gray color with the given value and optional alpha
  ColorGray8([this.v = 0, this.a = baseMask]);

  /// Creates a gray color from a ColorF (floating point color)
  factory ColorGray8.fromColorF(ColorF c, [double? alpha]) {
    final gray = Util.uround(
      (0.299 * c.red0To255 + 0.587 * c.green0To255 + 0.114 * c.blue0To255) * 
      baseMask / 255.0
    );
    final a = alpha != null 
        ? Util.uround(alpha * baseMask)
        : Util.uround(c.alpha0To255 * baseMask / 255.0);
    return ColorGray8(gray, a);
  }

  /// Creates a gray color from a Color (RGBA color)
  factory ColorGray8.fromColor(Color c, [int? alpha]) {
    // ITU-R BT.601 weights: R=0.299, G=0.587, B=0.114
    // Approximated as: R*77 + G*150 + B*29 = R*0.301 + G*0.586 + B*0.113
    final gray = (c.red * 77 + c.green * 150 + c.blue * 29) >> 8;
    return ColorGray8(gray, alpha ?? c.alpha);
  }

  /// Creates a copy of this color with a different alpha
  ColorGray8 withAlpha(int newAlpha) {
    return ColorGray8(v, newAlpha);
  }

  /// Clears the color to transparent black
  void clear() {
    v = 0;
    a = 0;
  }

  /// Returns a transparent version of this color
  ColorGray8 transparent() {
    return ColorGray8(v, 0);
  }

  /// Gets the opacity as a value from 0.0 to 1.0
  double get opacity => a / baseMask;

  /// Sets the opacity from a value from 0.0 to 1.0
  set opacity(double value) {
    if (value < 0.0) value = 0.0;
    if (value > 1.0) value = 1.0;
    a = Util.uround(value * baseMask);
  }

  /// Premultiplies the gray value by the alpha
  ColorGray8 premultiply() {
    if (a == baseMask) return this;
    if (a == 0) {
      v = 0;
      return this;
    }
    v = (v * a) >> baseShift;
    return this;
  }

  /// Premultiplies the gray value by a custom alpha
  ColorGray8 premultiplyWithAlpha(int customAlpha) {
    if (a == baseMask && customAlpha >= baseMask) return this;
    if (a == 0 || customAlpha == 0) {
      v = 0;
      a = 0;
      return this;
    }
    int newV = (v * customAlpha) ~/ a;
    v = newV > customAlpha ? customAlpha : newV;
    a = customAlpha;
    return this;
  }

  /// Demultiplies the gray value (removes premultiplication)
  ColorGray8 demultiply() {
    if (a == baseMask) return this;
    if (a == 0) {
      v = 0;
      return this;
    }
    int newV = (v * baseMask) ~/ a;
    v = newV > baseMask ? baseMask : newV;
    return this;
  }

  /// Interpolates between this color and another
  /// k is the interpolation factor (0.0 = this, 1.0 = other)
  ColorGray8 gradient(ColorGray8 other, double k) {
    int ik = Util.uround(k * baseScale);
    int newV = v + (((other.v - v) * ik) >> baseShift);
    int newA = a + (((other.a - a) * ik) >> baseShift);
    return ColorGray8(newV, newA);
  }

  /// Creates a premultiplied gray color
  static ColorGray8 gray8Pre(int v, [int a = baseMask]) {
    return ColorGray8(v, a).premultiply();
  }

  /// Creates a premultiplied gray color from another
  static ColorGray8 gray8PreFrom(ColorGray8 c, int a) {
    return ColorGray8(c.v, a).premultiply();
  }

  /// Creates a premultiplied gray color from a Color
  static ColorGray8 gray8PreFromColor(Color c) {
    return ColorGray8.fromColor(c).premultiply();
  }

  /// Creates a premultiplied gray color from a ColorF
  static ColorGray8 gray8PreFromColorF(ColorF c, [double? a]) {
    return ColorGray8.fromColorF(c, a).premultiply();
  }

  /// Converts to a full Color (RGB will all be the gray value)
  Color toColor() {
    return Color.fromArgb(a, v, v, v);
  }

  /// Converts to a ColorF
  ColorF toColorF() {
    double grayF = v / baseMask;
    double alphaF = a / baseMask;
    return ColorF(grayF, grayF, grayF, alphaF);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorGray8 && other.v == v && other.a == a;

  @override
  int get hashCode => v.hashCode ^ a.hashCode;

  @override
  String toString() => 'ColorGray8(v: $v, a: $a)';
}

/// 16-bit grayscale color with alpha channel (for high precision)
class ColorGray16 {
  static const int baseShift = 16;
  static const int baseScale = 1 << baseShift; // 65536
  static const int baseMask = baseScale - 1; // 65535

  /// Gray value (0-65535)
  int v;

  /// Alpha value (0-65535)
  int a;

  /// Creates a gray color with the given value and optional alpha
  ColorGray16([this.v = 0, this.a = baseMask]);

  /// Creates from an 8-bit gray color
  factory ColorGray16.fromGray8(ColorGray8 c) {
    return ColorGray16(
      (c.v << 8) | c.v,
      (c.a << 8) | c.a,
    );
  }

  /// Converts to 8-bit gray color
  ColorGray8 toGray8() {
    return ColorGray8(v >> 8, a >> 8);
  }

  /// Clears the color to transparent black
  void clear() {
    v = 0;
    a = 0;
  }

  /// Gets the opacity as a value from 0.0 to 1.0
  double get opacity => a / baseMask;

  /// Sets the opacity from a value from 0.0 to 1.0
  set opacity(double value) {
    if (value < 0.0) value = 0.0;
    if (value > 1.0) value = 1.0;
    a = (value * baseMask).round();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorGray16 && other.v == v && other.a == a;

  @override
  int get hashCode => v.hashCode ^ a.hashCode;

  @override
  String toString() => 'ColorGray16(v: $v, a: $a)';
}

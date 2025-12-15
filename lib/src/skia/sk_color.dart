/// Represents an ARGB color as a 32-bit integer.
/// 
/// The color is stored as 0xAARRGGBB.
class SKColor {
  /// The raw color value.
  final int value;

  /// Creates a color from a 32-bit ARGB value.
  const SKColor(this.value);

  /// Creates a color from individual ARGB components.
  const SKColor.fromARGB(int a, int r, int g, int b)
      : value = ((a & 0xFF) << 24) |
                ((r & 0xFF) << 16) |
                ((g & 0xFF) << 8) |
                (b & 0xFF);

  /// Creates a fully opaque color from RGB components.
  const SKColor.fromRGB(int r, int g, int b)
      : value = 0xFF000000 |
                ((r & 0xFF) << 16) |
                ((g & 0xFF) << 8) |
                (b & 0xFF);

  /// Empty/transparent color.
  static const SKColor empty = SKColor(0);

  /// Transparent color.
  static const SKColor transparent = SKColor(0x00000000);

  /// The alpha component (0-255).
  int get alpha => (value >> 24) & 0xFF;

  /// The red component (0-255).
  int get red => (value >> 16) & 0xFF;

  /// The green component (0-255).
  int get green => (value >> 8) & 0xFF;

  /// The blue component (0-255).
  int get blue => value & 0xFF;

  /// Returns a new color with the specified alpha value.
  SKColor withAlpha(int a) => SKColor.fromARGB(a, red, green, blue);

  /// Returns a new color with the specified red value.
  SKColor withRed(int r) => SKColor.fromARGB(alpha, r, green, blue);

  /// Returns a new color with the specified green value.
  SKColor withGreen(int g) => SKColor.fromARGB(alpha, red, g, blue);

  /// Returns a new color with the specified blue value.
  SKColor withBlue(int b) => SKColor.fromARGB(alpha, red, green, b);

  /// Creates a color from HSL values.
  /// 
  /// [h] is hue (0-360), [s] is saturation (0-100), [l] is lightness (0-100).
  factory SKColor.fromHSL(double h, double s, double l, [int a = 255]) {
    final c = SKColorF.fromHSL(h, s, l, a / 255.0);
    return SKColor.fromARGB(
      a,
      (c.red * 255).round().clamp(0, 255),
      (c.green * 255).round().clamp(0, 255),
      (c.blue * 255).round().clamp(0, 255),
    );
  }

  /// Creates a color from HSV values.
  /// 
  /// [h] is hue (0-360), [s] is saturation (0-100), [v] is value (0-100).
  factory SKColor.fromHSV(double h, double s, double v, [int a = 255]) {
    final c = SKColorF.fromHSV(h, s, v, a / 255.0);
    return SKColor.fromARGB(
      a,
      (c.red * 255).round().clamp(0, 255),
      (c.green * 255).round().clamp(0, 255),
      (c.blue * 255).round().clamp(0, 255),
    );
  }

  /// Parses a color from a hex string like "#RRGGBB" or "#AARRGGBB".
  static SKColor parse(String hexString) {
    final result = tryParse(hexString);
    if (result == null) {
      throw ArgumentError('Invalid hexadecimal color string: $hexString');
    }
    return result;
  }

  /// Tries to parse a color from a hex string.
  static SKColor? tryParse(String hexString) {
    var hex = hexString.trim();
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }
    
    if (hex.length == 6) {
      final value = int.tryParse(hex, radix: 16);
      if (value != null) {
        return SKColor(0xFF000000 | value);
      }
    } else if (hex.length == 8) {
      final value = int.tryParse(hex, radix: 16);
      if (value != null) {
        return SKColor(value);
      }
    }
    
    return null;
  }

  @override
  String toString() => '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';

  @override
  bool operator ==(Object other) => other is SKColor && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Represents a color using floating-point RGBA components (0.0-1.0).
class SKColorF {
  /// The red component (0.0-1.0).
  final double red;
  
  /// The green component (0.0-1.0).
  final double green;
  
  /// The blue component (0.0-1.0).
  final double blue;
  
  /// The alpha component (0.0-1.0).
  final double alpha;

  /// Creates a color from floating-point RGBA components.
  const SKColorF(this.red, this.green, this.blue, [this.alpha = 1.0]);

  /// Creates a color from an SKColor.
  factory SKColorF.fromColor(SKColor color) {
    return SKColorF(
      color.red / 255.0,
      color.green / 255.0,
      color.blue / 255.0,
      color.alpha / 255.0,
    );
  }

  /// Creates a color from HSL values.
  factory SKColorF.fromHSL(double h, double s, double l, [double a = 1.0]) {
    h = h % 360;
    s = s.clamp(0, 100) / 100;
    l = l.clamp(0, 100) / 100;

    if (s == 0) {
      return SKColorF(l, l, l, a);
    }

    double hueToRgb(double p, double q, double t) {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1 / 6) return p + (q - p) * 6 * t;
      if (t < 1 / 2) return q;
      if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
      return p;
    }

    final q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    final p = 2 * l - q;

    return SKColorF(
      hueToRgb(p, q, h / 360 + 1 / 3),
      hueToRgb(p, q, h / 360),
      hueToRgb(p, q, h / 360 - 1 / 3),
      a,
    );
  }

  /// Creates a color from HSV values.
  factory SKColorF.fromHSV(double h, double s, double v, [double a = 1.0]) {
    h = h % 360;
    s = s.clamp(0, 100) / 100;
    v = v.clamp(0, 100) / 100;

    final c = v * s;
    final x = c * (1 - ((h / 60) % 2 - 1).abs());
    final m = v - c;

    double r, g, b;
    if (h < 60) {
      r = c; g = x; b = 0;
    } else if (h < 120) {
      r = x; g = c; b = 0;
    } else if (h < 180) {
      r = 0; g = c; b = x;
    } else if (h < 240) {
      r = 0; g = x; b = c;
    } else if (h < 300) {
      r = x; g = 0; b = c;
    } else {
      r = c; g = 0; b = x;
    }

    return SKColorF(r + m, g + m, b + m, a);
  }

  /// Converts to an SKColor.
  SKColor toSKColor() {
    return SKColor.fromARGB(
      (alpha * 255).round().clamp(0, 255),
      (red * 255).round().clamp(0, 255),
      (green * 255).round().clamp(0, 255),
      (blue * 255).round().clamp(0, 255),
    );
  }

  @override
  String toString() => 'SKColorF($red, $green, $blue, $alpha)';

  @override
  bool operator ==(Object other) =>
      other is SKColorF &&
      other.red == red &&
      other.green == green &&
      other.blue == blue &&
      other.alpha == alpha;

  @override
  int get hashCode => Object.hash(red, green, blue, alpha);
}

/// Predefined colors.
abstract class SKColors {
  static const SKColor transparent = SKColor(0x00000000);
  static const SKColor black = SKColor(0xFF000000);
  static const SKColor white = SKColor(0xFFFFFFFF);
  static const SKColor red = SKColor(0xFFFF0000);
  static const SKColor green = SKColor(0xFF00FF00);
  static const SKColor blue = SKColor(0xFF0000FF);
  static const SKColor yellow = SKColor(0xFFFFFF00);
  static const SKColor cyan = SKColor(0xFF00FFFF);
  static const SKColor magenta = SKColor(0xFFFF00FF);
  static const SKColor gray = SKColor(0xFF808080);
  static const SKColor lightGray = SKColor(0xFFC0C0C0);
  static const SKColor darkGray = SKColor(0xFF404040);
  static const SKColor orange = SKColor(0xFFFFA500);
  static const SKColor purple = SKColor(0xFF800080);
  static const SKColor pink = SKColor(0xFFFFC0CB);
  static const SKColor brown = SKColor(0xFFA52A2A);
  
  // Material colors
  static const SKColor materialRed = SKColor(0xFFF44336);
  static const SKColor materialPink = SKColor(0xFFE91E63);
  static const SKColor materialPurple = SKColor(0xFF9C27B0);
  static const SKColor materialDeepPurple = SKColor(0xFF673AB7);
  static const SKColor materialIndigo = SKColor(0xFF3F51B5);
  static const SKColor materialBlue = SKColor(0xFF2196F3);
  static const SKColor materialLightBlue = SKColor(0xFF03A9F4);
  static const SKColor materialCyan = SKColor(0xFF00BCD4);
  static const SKColor materialTeal = SKColor(0xFF009688);
  static const SKColor materialGreen = SKColor(0xFF4CAF50);
  static const SKColor materialLightGreen = SKColor(0xFF8BC34A);
  static const SKColor materialLime = SKColor(0xFFCDDC39);
  static const SKColor materialYellow = SKColor(0xFFFFEB3B);
  static const SKColor materialAmber = SKColor(0xFFFFC107);
  static const SKColor materialOrange = SKColor(0xFFFF9800);
  static const SKColor materialDeepOrange = SKColor(0xFFFF5722);
}

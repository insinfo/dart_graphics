/// Map of named CSS colors.
const Map<String, int> _namedColors = {
  'transparent': 0x00000000,
  'black': 0xFF000000,
  'white': 0xFFFFFFFF,
  'red': 0xFFFF0000,
  'green': 0xFF008000,
  'blue': 0xFF0000FF,
  'yellow': 0xFFFFFF00,
  'cyan': 0xFF00FFFF,
  'magenta': 0xFFFF00FF,
  'purple': 0xFF800080,
  'orange': 0xFFFFA500,
  'pink': 0xFFFFC0CB,
  'gray': 0xFF808080,
  'grey': 0xFF808080,
  'silver': 0xFFC0C0C0,
  'maroon': 0xFF800000,
  'olive': 0xFF808000,
  'lime': 0xFF00FF00,
  'aqua': 0xFF00FFFF,
  'teal': 0xFF008080,
  'navy': 0xFF000080,
  'fuchsia': 0xFFFF00FF,
  'brown': 0xFFA52A2A,
  'coral': 0xFFFF7F50,
  'crimson': 0xFFDC143C,
  'darkblue': 0xFF00008B,
  'darkgreen': 0xFF006400,
  'darkred': 0xFF8B0000,
  'gold': 0xFFFFD700,
  'indigo': 0xFF4B0082,
  'ivory': 0xFFFFFFF0,
  'khaki': 0xFFF0E68C,
  'lavender': 0xFFE6E6FA,
  'lightblue': 0xFFADD8E6,
  'lightgreen': 0xFF90EE90,
  'lightgray': 0xFFD3D3D3,
  'lightgrey': 0xFFD3D3D3,
  'lightyellow': 0xFFFFFFE0,
  'salmon': 0xFFFA8072,
  'skyblue': 0xFF87CEEB,
  'tan': 0xFFD2B48C,
  'turquoise': 0xFF40E0D0,
  'violet': 0xFFEE82EE,
  'wheat': 0xFFF5DEB3,
};

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

  /// Parses a color from a hex string like "#RRGGBB" or "#AARRGGBB",
  /// a named color like "red" or "blue", or CSS rgb/rgba functions.
  static SKColor parse(String colorString) {
    final result = tryParse(colorString);
    if (result == null) {
      throw ArgumentError('Invalid hexadecimal color string: $colorString');
    }
    return result;
  }

  /// Tries to parse a color from a hex string, named color, or CSS function.
  static SKColor? tryParse(String colorString) {
    var str = colorString.trim().toLowerCase();
    
    // Check for named colors first
    final namedColor = _namedColors[str];
    if (namedColor != null) {
      return SKColor(namedColor);
    }
    
    // Check for hex color
    if (str.startsWith('#')) {
      var hex = str.substring(1);
      if (hex.length == 3) {
        // #RGB -> #RRGGBB
        hex = '${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}';
      } else if (hex.length == 4) {
        // #RGBA -> #RRGGBBAA
        hex = '${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}${hex[3]}${hex[3]}';
      }
      
      if (hex.length == 6) {
        final value = int.tryParse(hex, radix: 16);
        if (value != null) {
          return SKColor(0xFF000000 | value);
        }
      } else if (hex.length == 8) {
        // RRGGBBAA -> AARRGGBB
        final r = int.tryParse(hex.substring(0, 2), radix: 16);
        final g = int.tryParse(hex.substring(2, 4), radix: 16);
        final b = int.tryParse(hex.substring(4, 6), radix: 16);
        final a = int.tryParse(hex.substring(6, 8), radix: 16);
        if (r != null && g != null && b != null && a != null) {
          return SKColor.fromARGB(a, r, g, b);
        }
      }
    }
    
    // Check for rgb/rgba functions
    if (str.startsWith('rgb')) {
      return _parseRgbFunction(str);
    }
    
    return null;
  }
  
  static SKColor? _parseRgbFunction(String str) {
    final isRgba = str.startsWith('rgba');
    final start = isRgba ? 5 : 4;
    final end = str.indexOf(')');
    if (end == -1) return null;
    
    final parts = str.substring(start, end).split(',').map((s) => s.trim()).toList();
    if (parts.length < 3) return null;
    
    final r = _parseColorComponent(parts[0]);
    final g = _parseColorComponent(parts[1]);
    final b = _parseColorComponent(parts[2]);
    final a = parts.length > 3 ? (double.tryParse(parts[3]) ?? 1.0) : 1.0;
    
    return SKColor.fromARGB(
      (a * 255).round().clamp(0, 255),
      r.round().clamp(0, 255),
      g.round().clamp(0, 255),
      b.round().clamp(0, 255),
    );
  }
  
  static double _parseColorComponent(String value) {
    if (value.endsWith('%')) {
      return (double.tryParse(value.substring(0, value.length - 1)) ?? 0) * 2.55;
    }
    return double.tryParse(value) ?? 0;
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

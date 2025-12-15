

/// RGBA Color with components in 0.0-1.0 range
class CairoColor {
  final double r;
  final double g;
  final double b;
  final double a;
  
  const CairoColor(this.r, this.g, this.b, [this.a = 1.0]);
  
  /// Create from 0-255 integer components
  factory CairoColor.fromRgba(int r, int g, int b, [int a = 255]) {
    return CairoColor(r / 255.0, g / 255.0, b / 255.0, a / 255.0);
  }
  
  /// Create from hex color code (e.g., 0xFF0000 for red)
  factory CairoColor.fromHex(int hex, [double alpha = 1.0]) {
    return CairoColor(
      ((hex >> 16) & 0xFF) / 255.0,
      ((hex >> 8) & 0xFF) / 255.0,
      (hex & 0xFF) / 255.0,
      alpha,
    );
  }
  
  /// Create a copy of this color with a different alpha value (0.0 - 1.0)
  CairoColor withAlpha(double alpha) {
    return CairoColor(r, g, b, alpha.clamp(0.0, 1.0));
  }
  
  /// Create a copy of this color with a different alpha (as int 0-255)
  CairoColor withAlphaInt(int alpha) {
    return CairoColor(r, g, b, (alpha / 255.0).clamp(0.0, 1.0));
  }
  
  // Common colors
  static const black = CairoColor(0.0, 0.0, 0.0);
  static const white = CairoColor(1.0, 1.0, 1.0);
  static const red = CairoColor(1.0, 0.0, 0.0);
  static const green = CairoColor(0.0, 1.0, 0.0);
  static const blue = CairoColor(0.0, 0.0, 1.0);
  static const yellow = CairoColor(1.0, 1.0, 0.0);
  static const cyan = CairoColor(0.0, 1.0, 1.0);
  static const magenta = CairoColor(1.0, 0.0, 1.0);
  static const transparent = CairoColor(0.0, 0.0, 0.0, 0.0);
  
  @override
  String toString() => 'CairoColor($r, $g, $b, $a)';
}

/// Font style options
enum FontSlant {
  normal,
  italic,
  oblique,
}

/// Font weight options
enum FontWeight {
  normal,
  bold,
}

/// Line cap styles
enum LineCap {
  butt,
  round,
  square,
}

/// Line join styles
enum LineJoin {
  miter,
  round,
  bevel,
}


/// A 2D point
class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);

  @override
  String toString() => 'Point($x, $y)';
}

/// A rectangle defined by position and size
class Rect {
  final double x;
  final double y;
  final double width;
  final double height;

  const Rect(this.x, this.y, this.width, this.height);

  double get left => x;
  double get top => y;
  double get right => x + width;
  double get bottom => y + height;

  @override
  String toString() => 'Rect($x, $y, $width, $height)';
}





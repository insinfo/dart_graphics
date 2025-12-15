/// Represents a 2D point with floating-point coordinates.
class SKPoint {
  /// The x-coordinate.
  final double x;
  
  /// The y-coordinate.
  final double y;

  /// Creates a point from x and y coordinates.
  const SKPoint(this.x, this.y);

  /// Creates a point at the origin (0, 0).
  static const SKPoint empty = SKPoint(0, 0);

  /// Returns a new point with the x and y coordinates scaled by the given factor.
  SKPoint scale(double sx, [double? sy]) => SKPoint(x * sx, y * (sy ?? sx));

  /// Returns a new point with the x and y coordinates offset by the given amounts.
  SKPoint offset(double dx, double dy) => SKPoint(x + dx, y + dy);

  /// Returns the distance from this point to the origin.
  double get length {
    final xx = x * x;
    final yy = y * y;
    return (xx + yy).sqrt();
  }

  /// Returns a normalized point (length = 1).
  SKPoint normalize() {
    final len = length;
    if (len == 0) return empty;
    return SKPoint(x / len, y / len);
  }

  /// Returns the distance between this point and another point.
  double distanceTo(SKPoint other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return (dx * dx + dy * dy).sqrt();
  }

  SKPoint operator +(SKPoint other) => SKPoint(x + other.x, y + other.y);
  SKPoint operator -(SKPoint other) => SKPoint(x - other.x, y - other.y);
  SKPoint operator *(double scalar) => SKPoint(x * scalar, y * scalar);
  SKPoint operator /(double scalar) => SKPoint(x / scalar, y / scalar);
  SKPoint operator -() => SKPoint(-x, -y);

  @override
  String toString() => 'SKPoint($x, $y)';

  @override
  bool operator ==(Object other) =>
      other is SKPoint && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

/// Represents a 2D point with integer coordinates.
class SKPointI {
  /// The x-coordinate.
  final int x;
  
  /// The y-coordinate.
  final int y;

  /// Creates a point from integer x and y coordinates.
  const SKPointI(this.x, this.y);

  /// Creates a point at the origin (0, 0).
  static const SKPointI empty = SKPointI(0, 0);

  /// Converts to a floating-point point.
  SKPoint toPoint() => SKPoint(x.toDouble(), y.toDouble());

  @override
  String toString() => 'SKPointI($x, $y)';

  @override
  bool operator ==(Object other) =>
      other is SKPointI && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

/// Represents a 2D size with floating-point dimensions.
class SKSize {
  /// The width.
  final double width;
  
  /// The height.
  final double height;

  /// Creates a size from width and height.
  const SKSize(this.width, this.height);

  /// Creates an empty size (0, 0).
  static const SKSize empty = SKSize(0, 0);

  /// Returns true if width and height are both zero.
  bool get isEmpty => width == 0 && height == 0;

  /// Returns a new size scaled by the given factors.
  SKSize scale(double sx, [double? sy]) => SKSize(width * sx, height * (sy ?? sx));

  /// Converts to a point.
  SKPoint toPoint() => SKPoint(width, height);

  /// Converts to an integer size.
  SKSizeI toSizeI() => SKSizeI(width.round(), height.round());

  @override
  String toString() => 'SKSize($width, $height)';

  @override
  bool operator ==(Object other) =>
      other is SKSize && other.width == width && other.height == height;

  @override
  int get hashCode => Object.hash(width, height);
}

/// Represents a 2D size with integer dimensions.
class SKSizeI {
  /// The width.
  final int width;
  
  /// The height.
  final int height;

  /// Creates a size from integer width and height.
  const SKSizeI(this.width, this.height);

  /// Creates an empty size (0, 0).
  static const SKSizeI empty = SKSizeI(0, 0);

  /// Returns true if width and height are both zero.
  bool get isEmpty => width == 0 && height == 0;

  /// Converts to a floating-point size.
  SKSize toSize() => SKSize(width.toDouble(), height.toDouble());

  @override
  String toString() => 'SKSizeI($width, $height)';

  @override
  bool operator ==(Object other) =>
      other is SKSizeI && other.width == width && other.height == height;

  @override
  int get hashCode => Object.hash(width, height);
}

/// Represents a rectangle with floating-point coordinates.
class SKRect {
  /// The left edge of the rectangle.
  final double left;
  
  /// The top edge of the rectangle.
  final double top;
  
  /// The right edge of the rectangle.
  final double right;
  
  /// The bottom edge of the rectangle.
  final double bottom;

  /// Creates a rectangle from left, top, right, and bottom edges.
  const SKRect.fromLTRB(this.left, this.top, this.right, this.bottom);

  /// Creates a rectangle from left, top, width, and height.
  const SKRect.fromLTWH(double left, double top, double width, double height)
      : this.fromLTRB(left, top, left + width, top + height);

  /// Creates a rectangle from x, y, width, and height.
  const SKRect.fromXYWH(double x, double y, double width, double height)
      : this.fromLTRB(x, y, x + width, y + height);

  /// Creates a rectangle centered at a point with the given half-width and half-height.
  factory SKRect.fromCenter({
    required SKPoint center,
    required double halfWidth,
    required double halfHeight,
  }) {
    return SKRect.fromLTRB(
      center.x - halfWidth,
      center.y - halfHeight,
      center.x + halfWidth,
      center.y + halfHeight,
    );
  }

  /// An empty rectangle.
  static const SKRect empty = SKRect.fromLTRB(0, 0, 0, 0);

  /// Creates a rectangle that contains both rectangles.
  factory SKRect.union(SKRect a, SKRect b) {
    return SKRect.fromLTRB(
      a.left < b.left ? a.left : b.left,
      a.top < b.top ? a.top : b.top,
      a.right > b.right ? a.right : b.right,
      a.bottom > b.bottom ? a.bottom : b.bottom,
    );
  }

  /// Creates a rectangle from a size (positioned at origin).
  factory SKRect.fromSize(SKSize size) {
    return SKRect.fromLTWH(0, 0, size.width, size.height);
  }

  /// The width of the rectangle.
  double get width => right - left;

  /// The height of the rectangle.
  double get height => bottom - top;

  /// The size of the rectangle.
  SKSize get size => SKSize(width, height);

  /// The center point of the rectangle.
  SKPoint get center => SKPoint(left + width / 2, top + height / 2);

  /// The top-left corner.
  SKPoint get topLeft => SKPoint(left, top);

  /// The top-right corner.
  SKPoint get topRight => SKPoint(right, top);

  /// The bottom-left corner.
  SKPoint get bottomLeft => SKPoint(left, bottom);

  /// The bottom-right corner.
  SKPoint get bottomRight => SKPoint(right, bottom);

  /// Returns true if the rectangle has zero width or height.
  bool get isEmpty => width <= 0 || height <= 0;

  /// Returns true if the point is inside the rectangle.
  bool contains(SKPoint point) {
    return point.x >= left && point.x < right &&
           point.y >= top && point.y < bottom;
  }

  /// Returns true if this rectangle intersects with another.
  bool intersects(SKRect other) {
    return left < other.right && right > other.left &&
           top < other.bottom && bottom > other.top;
  }

  /// Returns the intersection of this rectangle with another.
  SKRect? intersect(SKRect other) {
    if (!intersects(other)) return null;
    return SKRect.fromLTRB(
      left > other.left ? left : other.left,
      top > other.top ? top : other.top,
      right < other.right ? right : other.right,
      bottom < other.bottom ? bottom : other.bottom,
    );
  }

  /// Returns a new rectangle inflated by the given amounts.
  SKRect inflate(double dx, double dy) {
    return SKRect.fromLTRB(left - dx, top - dy, right + dx, bottom + dy);
  }

  /// Returns a new rectangle deflated by the given amounts.
  SKRect deflate(double dx, double dy) {
    return inflate(-dx, -dy);
  }

  /// Returns a new rectangle offset by the given amounts.
  SKRect offset(double dx, double dy) {
    return SKRect.fromLTRB(left + dx, top + dy, right + dx, bottom + dy);
  }

  /// Returns a standardized rectangle (positive width and height).
  SKRect standardize() {
    return SKRect.fromLTRB(
      left < right ? left : right,
      top < bottom ? top : bottom,
      left < right ? right : left,
      top < bottom ? bottom : top,
    );
  }

  /// Converts to an integer rectangle.
  SKRectI toRectI() => SKRectI.fromLTRB(
    left.round(),
    top.round(),
    right.round(),
    bottom.round(),
  );

  @override
  String toString() => 'SKRect.fromLTRB($left, $top, $right, $bottom)';

  @override
  bool operator ==(Object other) =>
      other is SKRect &&
      other.left == left &&
      other.top == top &&
      other.right == right &&
      other.bottom == bottom;

  @override
  int get hashCode => Object.hash(left, top, right, bottom);
}

/// Represents a rectangle with integer coordinates.
class SKRectI {
  /// The left edge of the rectangle.
  final int left;
  
  /// The top edge of the rectangle.
  final int top;
  
  /// The right edge of the rectangle.
  final int right;
  
  /// The bottom edge of the rectangle.
  final int bottom;

  /// Creates a rectangle from left, top, right, and bottom edges.
  const SKRectI.fromLTRB(this.left, this.top, this.right, this.bottom);

  /// Creates a rectangle from left, top, width, and height.
  const SKRectI.fromLTWH(int left, int top, int width, int height)
      : this.fromLTRB(left, top, left + width, top + height);

  /// Creates a rectangle from x, y, width, and height.
  const SKRectI.fromXYWH(int x, int y, int width, int height)
      : this.fromLTRB(x, y, x + width, y + height);

  /// An empty rectangle.
  static const SKRectI empty = SKRectI.fromLTRB(0, 0, 0, 0);

  /// Creates a rectangle from a size (positioned at origin).
  factory SKRectI.fromSize(SKSizeI size) {
    return SKRectI.fromLTWH(0, 0, size.width, size.height);
  }

  /// The width of the rectangle.
  int get width => right - left;

  /// The height of the rectangle.
  int get height => bottom - top;

  /// The size of the rectangle.
  SKSizeI get size => SKSizeI(width, height);

  /// The center point of the rectangle.
  SKPointI get center => SKPointI(left + width ~/ 2, top + height ~/ 2);

  /// Returns true if the rectangle has zero width or height.
  bool get isEmpty => width <= 0 || height <= 0;

  /// Returns true if the point is inside the rectangle.
  bool contains(SKPointI point) {
    return point.x >= left && point.x < right &&
           point.y >= top && point.y < bottom;
  }

  /// Converts to a floating-point rectangle.
  SKRect toRect() => SKRect.fromLTRB(
    left.toDouble(),
    top.toDouble(),
    right.toDouble(),
    bottom.toDouble(),
  );

  @override
  String toString() => 'SKRectI.fromLTRB($left, $top, $right, $bottom)';

  @override
  bool operator ==(Object other) =>
      other is SKRectI &&
      other.left == left &&
      other.top == top &&
      other.right == right &&
      other.bottom == bottom;

  @override
  int get hashCode => Object.hash(left, top, right, bottom);
}

extension on double {
  double sqrt() => this < 0 ? double.nan : _sqrt(this);
  
  static double _sqrt(double x) {
    if (x < 0) return double.nan;
    if (x == 0 || x == 1) return x;
    double guess = x / 2;
    for (int i = 0; i < 20; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }
}

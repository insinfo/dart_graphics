import 'clipper_internal.dart';
import 'point_d.dart';

/// Point64 describes a point whose coordinates are integer.
/// On native platforms, the range is full 64 bits; on the web, the range is 52 bits.
class Point64 {
  /// Default constructor.
  const Point64(this.x, this.y, [this.z = 0]);

  /// X coordinate of the point.
  final int x;

  /// Y coordinate of the point.
  final int y;

  /// Z coordinate of the point. Z is not used in calculations; it is provided for the user of the library.
  final int z;

  /// Create a [Point64] from floating point coordinates, optionally scaling them by [scale].
  factory Point64.fromDouble(
    double x,
    double y, {
    int z = 0,
    double scale = 1,
  }) => Point64((x * scale).round(), (y * scale).round(), z);

  /// Create a [Point64] from a [PointD], optionally scaling the coordinates by [scale].
  factory Point64.fromPointD(PointD point, {double scale = 1}) =>
      Point64((point.x * scale).round(), (point.y * scale).round(), point.z);

  /// Copy the point, preserving auxiliary data.
  Point64 copy(int x, int y) => Point64(x, y, z);

  /// Copy the point to a [PointD], preserving auxiliary data.
  PointD copyToD(double x, double y) => PointD(x, y, z);

  /// Translate the point by [dx], [dy].
  Point64 translated(int dx, int dy) => copy(x + dx, y + dy);

  /// Scale the point by [dx], [dy].
  Point64 scaled(double scale) =>
      copy((x * scale).round(), (y * scale).round());

  /// Reflext the point around [pivot].
  Point64 reflected(Point64 pivot) =>
      copy(pivot.x + (pivot.x - x), pivot.y + (pivot.y - y));

  /// Sum of two [Point64]s interpreted as vectors.
  Point64 operator +(Point64 other) => Point64(x + other.x, y + other.y);

  /// Difference of two [Point64]s interpreted as vectors.
  Point64 operator -(Point64 other) => Point64(x - other.x, y - other.y);

  /// Negation of the point.
  Point64 get negated => Point64(-x, -y);

  /// Calculate the squared perpendicular distance of the point from a line.
  double perpendicDistFromLineSqrd(Point64 line1, Point64 line2) {
    final a = x.toDouble() - line1.x.toDouble();
    final b = y.toDouble() - line1.y.toDouble();
    final c = line2.x.toDouble() - line1.x.toDouble();
    final d = line2.y.toDouble() - line1.y.toDouble();
    if (c == 0 && d == 0) return 0;
    return sqr(a * d - c * b) / (c * c + d * d);
  }

  @override
  String toString() => '($x, $y)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point64 && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

import 'dart:math';

import 'clipper_internal.dart';
import 'point_64.dart';

/// PointD describes a point whose coordinates are floating point.
class PointD {
  /// Default constructor.
  const PointD(this.x, this.y, [this.z = 0]);

  /// X coordinate of the point.
  final double x;

  /// Y coordinate of the point.
  final double y;

  /// Z coordinate of the point. Z is not used in calculations; it is provided for the user of the library.
  final int z;

  /// Create a [Point64] from integer coordinates, optionally scaling them by [scale].
  factory PointD.fromInt(int x, int y, {int z = 0, double scale = 1}) =>
      PointD(x * scale, y * scale, z);

  /// Create a [PointD] from a [Point64], optionally scaling the coordinates by [scale].
  factory PointD.fromPoint64(Point64 point, {double scale = 1}) =>
      PointD(point.x * scale, point.y * scale, point.z);

  /// Copy the point, preserving auxiliary data.
  PointD copy(double x, double y) => PointD(x, y, z);

  /// Copy the point to a [PointD], preserving auxiliary data.
  Point64 copyTo64(int x, int y) => Point64(x, y, z);

  /// Translate the point by [dx], [dy].
  PointD translated(double dx, double dy) => copy(x + dx, y + dy);

  /// Scale the point by [dx], [dy].
  PointD scaled(double scale) => copy(x * scale, y * scale);

  /// Reflext the point around [pivot].
  PointD reflected(PointD pivot) =>
      copy(pivot.x + (pivot.x - x), pivot.y + (pivot.y - y));

  /// Sum of two [Point64]s interpreted as vectors.
  PointD operator +(PointD other) => PointD(x + other.x, y + other.y);

  /// Difference of two [Point64]s interpreted as vectors.
  PointD operator -(PointD other) => PointD(x - other.x, y - other.y);

  /// Negation of the point.
  PointD get negated => PointD(-x, -y);

  /// Calculate the dot product with another point, with the points interpreted as vectors.
  double dotProduct(PointD other) => x * other.x + y * other.y;

  /// Calculate the cross product with another point, with the points interpreted as vectors.
  double crossProduct(PointD other) => y * other.x - x * other.y;

  /// Calculate the normalized version of this poöint interpreted as a vector.
  PointD normalized([double epsilon = 0.001]) {
    double l = sqrt(x * x + y * y);
    if (l < epsilon) return copy(0, 0);
    return copy(x / l, y / l);
  }

  /// Calculate the squared perpendicular distance of the point from a line.
  double perpendicDistFromLineSqrd(PointD line1, PointD line2) {
    final a = x - line1.x;
    final b = y - line1.y;
    final c = line2.x - line1.x;
    final d = line2.y - line1.y;
    if (c == 0 && d == 0) return 0;
    return sqr(a * d - c * b) / (c * c + d * d);
  }

  @override
  String toString() => '($x, $y)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointD && isAlmostZero(x - other.x) && isAlmostZero(y - other.y);

  @override
  int get hashCode => Object.hash(x, y);
}

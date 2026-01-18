import 'dart:math';

import 'path_d.dart';
import 'point_d.dart';
import 'rect_64.dart';

/// [RectD] is a rectangle defined by its left, top, right, and bottom edges, in floating point coordinates.
class RectD {
  /// Default constructor creates an empty rectangle.
  RectD() : left = 0, top = 0, right = 0, bottom = 0;

  /// Create a rectangle from explicit coordinates.
  RectD.fromLTRB(this.left, this.top, this.right, this.bottom);

  /// An invalid rectangle.
  RectD.invalid()
    : left = double.maxFinite,
      top = double.maxFinite,
      right = -double.maxFinite,
      bottom = -double.maxFinite;

  /// Left edge of the rectangle.
  double left;

  /// Top edge of the rectangle.
  double top;

  /// Right edge of the rectangle.
  double right;

  /// Bottom edge of the rectangle.
  double bottom;

  /// Width of the rectangle.
  double get width => right - left;

  /// Set the rectangle's width, adjusting the right edge.
  set width(double value) => right = left + value;

  /// Height of the rectangle.
  double get height => bottom - top;

  /// Set the rectangle's height, adjusting the bottom edge.
  set height(double value) => bottom = top + value;

  /// Inflate the rectangle by [dx], [dy].
  void inflate(double dx, double dy) {
    left -= dx;
    top -= dy;
    right += dx;
    bottom += dy;
  }

  /// Determine if the rectangle is empty.
  bool get isEmpty => bottom <= top || right <= left;

  /// Determine if the rectangle is valid.
  bool get isValid => left < double.maxFinite;

  /// Get the mid point of the rectangle.
  PointD get midPoint => PointD((left + right) / 2, (top + bottom) / 2);

  /// Check if the given point is inside the rectangle.
  bool contains(PointD pt) =>
      pt.x > left && pt.x < right && pt.y > top && pt.y < bottom;

  /// Check if the given rectangle is fully contained in the rectangle.
  bool containsRect(RectD rec) =>
      rec.left >= left &&
      rec.right <= right &&
      rec.top >= top &&
      rec.bottom <= bottom;

  /// Check if two rectangles intersect.
  bool intersects(RectD rec) =>
      max(left, rec.left) <= min(right, rec.right) &&
      max(top, rec.top) <= min(bottom, rec.bottom);

  /// Get a path describing the rectangle.
  PathD get asPath => [
    PointD(left, top),
    PointD(right, top),
    PointD(right, bottom),
    PointD(left, bottom),
  ];

  /// Scale the rectangle's coordinates by [scale] and return the result as a [Rect64].
  Rect64 scaled64(double scale) => Rect64.fromLTRB(
    (left * scale).toInt(),
    (top * scale).toInt(),
    (right * scale).toInt(),
    (bottom * scale).toInt(),
  );
}

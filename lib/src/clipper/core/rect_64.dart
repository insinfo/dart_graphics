import 'dart:math';

import 'max_int_native.dart' if (dart.library.js_util) 'max_int_js.dart';
import 'path_64.dart';
import 'point_64.dart';

/// [Rect64] is a rectangle defined by its left, top, right, and bottom edges, in integer coordinates.
class Rect64 {
  /// Default constructor creates an empty rectangle.
  Rect64() : left = 0, top = 0, right = 0, bottom = 0;

  /// Create a rectangle from explicit coordinates.
  Rect64.fromLTRB(this.left, this.top, this.right, this.bottom);

  /// An invalid rectangle.
  Rect64.invalid()
    : left = kMaxInt64,
      top = kMaxInt64,
      right = -kMaxInt64,
      bottom = -kMaxInt64;

  /// Left edge of the rectangle.
  int left;

  /// Top edge of the rectangle.
  int top;

  /// Right edge of the rectangle.
  int right;

  /// Bottom edge of the rectangle.
  int bottom;

  /// Width of the rectangle.
  int get width => right - left;

  /// Set the rectangle's width, adjusting the right edge.
  set width(int value) => right = left + value;

  /// Height of the rectangle.
  int get height => bottom - top;

  /// Set the rectangle's height, adjusting the bottom edge.
  set height(int value) => bottom = top + value;

  /// Inflate the rectangle by [dx], [dy].
  void inflate(int dx, int dy) {
    left -= dx;
    top -= dy;
    right += dx;
    bottom += dy;
  }

  /// Determine if the rectangle is empty.
  bool get isEmpty => bottom <= top || right <= left;

  /// Determine if the rectangle is valid.
  bool get isValid => left < kMaxInt64;

  /// Get the mid point of the rectangle.
  Point64 get midPoint => Point64((left + right) ~/ 2, (top + bottom) ~/ 2);

  /// Check if the given point is inside the rectangle.
  bool contains(Point64 pt) =>
      pt.x > left && pt.x < right && pt.y > top && pt.y < bottom;

  /// Check if the given rectangle is fully contained in the rectangle.
  bool containsRect(Rect64 rec) =>
      rec.left >= left &&
      rec.right <= right &&
      rec.top >= top &&
      rec.bottom <= bottom;

  /// Check if two rectangles intersect.
  bool intersects(Rect64 rec) =>
      max(left, rec.left) <= min(right, rec.right) &&
      max(top, rec.top) <= min(bottom, rec.bottom);

  /// Get a path describing the rectangle.
  Path64 get asPath => [
    Point64(left, top),
    Point64(right, top),
    Point64(right, bottom),
    Point64(left, bottom),
  ];

  /// Get a path describing whe rectangle, with the given Z.
  Path64 asPathWithZ(int z) => [
    Point64(left, top, z),
    Point64(right, top, z),
    Point64(right, bottom, z),
    Point64(left, bottom, z),
  ];

  /// Scale the rectangle's coordinates by [scale].
  Rect64 scaled(double scale) => Rect64.fromLTRB(
    (left * scale).round(),
    (top * scale).round(),
    (right * scale).round(),
    (bottom * scale).round(),
  );
}

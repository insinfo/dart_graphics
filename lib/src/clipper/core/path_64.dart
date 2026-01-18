import 'dart:math';

import 'clipper.dart';
import 'clipper_internal.dart';
import 'path_d.dart';
import 'point_64.dart';
import 'point_d.dart';
import 'rect_64.dart';

/// [Path64] is just a list of [Point64]s.
typedef Path64 = List<Point64>;

/// Extension methods for [Path64]
extension Path64Ext on Path64 {
  /// Calculate the area of the (closed) path.
  double get area {
    // https://en.wikipedia.org/wiki/Shoelace_formula
    var a = 0.0;
    if (length < 3) {
      return 0.0;
    }
    var prevPt = last;
    for (final pt in this) {
      a += (prevPt.y + pt.y).toDouble() * (prevPt.x - pt.x).toDouble();
      prevPt = pt;
    }
    return a * 0.5;
  }

  /// Determine the polygon's direction (positive or negative).
  bool get isPositive => area >= 0;

  /// Scale the path by [scale].
  Path64 scaledPath(double scale, {bool growable = true}) {
    if (isAlmostZero(scale - 1)) {
      return this;
    }
    return map((p) => p.scaled(scale)).toList(growable: growable);
  }

  /// Scale the path by [scale], returning a [PathD].
  PathD scaledPathD(double scale, {bool growable = true}) => map(
    (p) => PointD.fromPoint64(p, scale: scale),
  ).toList(growable: growable);

  /// Translate the path by [dx], [dy].
  Path64 translatedPath(int dx, int dy, {bool growable = true}) =>
      map((p) => p.copy(p.x + dx, p.y + dy)).toList(growable: growable);

  /// Reverse the path.
  Path64 get reversedPath => reversed.toList();

  /// Calculate the bounding box of the path.
  Rect64 get bounds {
    final result = Rect64.invalid();
    for (final pt in this) {
      if (pt.x < result.left) {
        result.left = pt.x;
      }
      if (pt.x > result.right) {
        result.right = pt.x;
      }
      if (pt.y < result.top) {
        result.top = pt.y;
      }
      if (pt.y > result.bottom) {
        result.bottom = pt.y;
      }
    }
    return result.isValid ? result : Rect64();
  }

  /// Create a copy of the path, removing any sequential duplicated points.
  Path64 duplicatesStripped({required bool isClosed, bool growable = true}) {
    return _duplicatesStripped(isClosed).toList(growable: growable);
  }

  Iterable<Point64> _duplicatesStripped(bool isClosed) sync* {
    if (isEmpty) {
      return;
    }
    var lastPt = first;
    for (final pt in skip(1)) {
      if (lastPt != pt) {
        yield lastPt;
        lastPt = pt;
      }
    }
    if (!isClosed || lastPt != first) {
      yield lastPt;
    }
  }

  /// Create a simplified copy of the path, using the
  /// [Ramer-Douglas-Peucker](https://en.wikipedia.org/wiki/Ramer%E2%80%93Douglas%E2%80%93Peucker_algorithm) algorithm.
  Path64 ramerDouglasPeucker(double epsilon, {bool growable = true}) {
    if (length < 5) {
      return this;
    }
    final flags = List.filled(length, false);
    flags[0] = true;
    flags[length - 1] = true;
    _rdp(0, length - 1, sqr(epsilon), flags);
    return indexed
        .where((e) => flags[e.$1])
        .map((e) => e.$2)
        .toList(growable: growable);
  }

  void _rdp(int begin, int end, double epsSqrd, List<bool> flags) {
    while (true) {
      int idx = 0;
      double maxD = 0;
      while (end > begin && this[begin] == this[end]) {
        flags[end--] = false;
      }
      for (int i = begin + 1; i < end; ++i) {
        // perpendicDistFromLineSqrd - avoids expensive Sqrt()
        double d = this[i].perpendicDistFromLineSqrd(this[begin], this[end]);
        if (d <= maxD) {
          continue;
        }
        maxD = d;
        idx = i;
      }
      if (maxD <= epsSqrd) {
        return;
      }
      flags[idx] = true;
      if (idx > begin + 1) {
        _rdp(begin, idx, epsSqrd, flags);
      }
      if (idx < end - 1) {
        begin = idx;
        continue;
      }
      break;
    }
  }

  /// Create a simplified copy of the path.
  Path64 simplified({
    required double epsilon,
    required bool isClosedPath,
    bool growable = true,
  }) {
    if (length < 4) {
      return this;
    }
    final epsSqr = sqr(epsilon);
    final high = length - 1;
    final flags = List.filled(length, false);
    final dsq = List.filled(length, 0.0);
    var curr = 0;

    int getNext(int current) {
      current++;
      while (current <= high && flags[current]) {
        current++;
      }
      if (current <= high) {
        return current;
      }
      current = 0;
      while (flags[current]) {
        current++;
      }
      return current;
    }

    int getPrior(int current) {
      if (current == 0) {
        current = high;
      } else {
        current--;
      }
      while (current > 0 && flags[current]) {
        current--;
      }
      if (!flags[current]) {
        return current;
      }
      current = high;
      while (flags[current]) {
        current--;
      }
      return current;
    }

    if (isClosedPath) {
      dsq[0] = first.perpendicDistFromLineSqrd(last, this[1]);
      dsq[high] = last.perpendicDistFromLineSqrd(first, this[high - 1]);
    } else {
      dsq[0] = double.maxFinite;
      dsq[high] = double.maxFinite;
    }

    for (int i = 1; i < high; i++) {
      dsq[i] = this[i].perpendicDistFromLineSqrd(this[i - 1], this[i + 1]);
    }

    while (true) {
      if (dsq[curr] > epsSqr) {
        int start = curr;
        do {
          curr = getNext(curr);
        } while (curr != start && dsq[curr] > epsSqr);
        if (curr == start) {
          break;
        }
      }

      var prev = getPrior(curr);
      var next = getNext(curr);
      if (next == prev) {
        break;
      }

      final int prior2;
      if (dsq[next] < dsq[curr]) {
        prior2 = prev;
        prev = curr;
        curr = next;
        next = getNext(next);
      } else {
        prior2 = getPrior(prev);
      }

      flags[curr] = true;
      curr = next;
      next = getNext(next);
      if (isClosedPath || ((curr != high) && (curr != 0))) {
        dsq[curr] = this[curr].perpendicDistFromLineSqrd(
          this[prev],
          this[next],
        );
      }
      if (isClosedPath || ((prev != 0) && (prev != high))) {
        dsq[prev] = this[prev].perpendicDistFromLineSqrd(
          this[prior2],
          this[curr],
        );
      }
    }
    return indexed
        .where((e) => flags[e.$1])
        .map((e) => e.$2)
        .toList(growable: growable);
  }

  /// Create a copy of the path, with sequential collinear segments combined.
  Path64 collinearTrimmed({required bool isOpen}) {
    var len = length;
    var i = 0;
    if (!isOpen) {
      while (i < len - 1 && isCollinear(this[len - 1], this[i], this[i + 1])) {
        i++;
      }
      while (i < len - 1 &&
          isCollinear(this[len - 2], this[len - 1], this[i])) {
        len--;
      }
    }

    if (len - i < 3) {
      if (!isOpen || len < 2 || this[0] == this[1]) {
        return Path64.empty();
      }
      return this;
    }

    final result = <Point64>[];
    var last = this[i];
    result.add(last);
    for (i++; i < len - 1; i++) {
      if (isCollinear(last, this[i], this[i + 1])) {
        continue;
      }
      last = this[i];
      result.add(last);
    }

    if (isOpen) {
      result.add(this[len - 1]);
    } else if (!isCollinear(last, this[len - 1], result[0])) {
      result.add(this[len - 1]);
    } else {
      while (result.length > 2 &&
          isCollinear(result.last, result[result.length - 2], result.first)) {
        result.removeLast();
      }
      if (result.length < 3) {
        result.clear();
      }
    }
    return result;
  }

  /// Determine if the given point is inside the polygon.
  PointInPolygonResult pointInPolygon(Point64 pt) {
    final len = length;
    var start = 0;
    if (len < 3) {
      return PointInPolygonResult.isOutside;
    }

    while (start < len && this[start].y == pt.y) {
      start++;
    }
    if (start == len) {
      return PointInPolygonResult.isOutside;
    }

    double d;
    var isAbove = this[start].y < pt.y;
    final startingAbove = isAbove;
    int val = 0, i = start + 1, end = len;
    while (true) {
      if (i == end) {
        if (end == 0 || start == 0) {
          break;
        }
        end = start;
        i = 0;
      }

      if (isAbove) {
        while (i < end && this[i].y < pt.y) {
          i++;
        }
      } else {
        while (i < end && this[i].y > pt.y) {
          i++;
        }
      }

      if (i == end) {
        continue;
      }

      Point64 curr = this[i], prev;
      if (i > 0) {
        prev = this[i - 1];
      } else {
        prev = this[len - 1];
      }

      if (curr.y == pt.y) {
        if (curr.x == pt.x ||
            (curr.y == prev.y && ((pt.x < prev.x) != (pt.x < curr.x)))) {
          return PointInPolygonResult.isOn;
        }
        i++;
        if (i == start) {
          break;
        }
        continue;
      }

      if (pt.x < curr.x && pt.x < prev.x) {
        // we're only interested in edges crossing on the left
      } else if (pt.x > prev.x && pt.x > curr.x) {
        val = 1 - val; // toggle val
      } else {
        d = crossProduct(prev, curr, pt);
        if (d == 0) return PointInPolygonResult.isOn;
        if ((d < 0) == isAbove) val = 1 - val;
      }
      isAbove = !isAbove;
      i++;
    }

    if (isAbove == startingAbove) {
      return val == 0
          ? PointInPolygonResult.isOutside
          : PointInPolygonResult.isInside;
    }
    if (i == len) {
      i = 0;
    }
    d =
        i == 0
            ? crossProduct(this[len - 1], this[0], pt)
            : crossProduct(this[i - 1], this[i], pt);
    if (d == 0) {
      return PointInPolygonResult.isOn;
    }
    if ((d < 0) == isAbove) {
      val = 1 - val;
    }

    return val == 0
        ? PointInPolygonResult.isOutside
        : PointInPolygonResult.isInside;
  }

  /// Determine if this path contains another path.
  bool containsPath(Path64 path2) {
    // nb: occasionally, due to rounding, path1 may
    // appear (momentarily) inside or outside path2.
    int ioCount = 0;
    for (final pt in path2) {
      PointInPolygonResult pip = pointInPolygon(pt);
      switch (pip) {
        case PointInPolygonResult.isInside:
          ioCount--;
        case PointInPolygonResult.isOutside:
          ioCount++;
        case PointInPolygonResult.isOn:
      }
      if (ioCount.abs() > 1) {
        break;
      }
    }
    return ioCount <= 0;
  }

  /// Create a [Path64] from a list of integers that alternately specify X and Y coordinates.
  static Path64 from(Iterable<int> coord, {bool growable = true}) =>
      takeEvenOdd(coord)
          .map((c) {
            final (x, y) = c;
            return Point64(x, y);
          })
          .toList(growable: growable);

  /// Create a [Path64] for an ellipse.
  static Path64 ellipse({
    required Point64 center,
    required double radiusX,
    double radiusY = 0,
    int steps = 0,
    int z = 0,
  }) {
    if (radiusX <= 0) {
      return Path64.empty();
    }
    if (radiusY <= 0) {
      radiusY = radiusX;
    }
    if (steps <= 2) {
      steps = (pi * sqrt((radiusX + radiusY) / 2)).ceil();
    }

    final si = sin(2 * pi / steps);
    final co = cos(2 * pi / steps);
    var dx = co;
    var dy = si;
    final result = List.filled(steps, Point64(0, 0));
    result[0] = Point64(center.x + radiusX.toInt(), center.y, z);
    for (var i = 1; i < steps; i++) {
      result[i] = Point64(
        center.x + (radiusX * dx).toInt(),
        center.y + (radiusY * dy).toInt(),
        z,
      );
      final x = dx * co - dy * si;
      dy = dy * co + dx * si;
      dx = x;
    }
    return result;
  }
}

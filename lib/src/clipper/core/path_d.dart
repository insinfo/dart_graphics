import 'dart:math';

import 'clipper.dart';
import 'clipper_internal.dart';
import 'path_64.dart';
import 'point_64.dart';
import 'point_d.dart';
import 'rect_d.dart';

/// [PathD] is just a list of [PointD]s.
typedef PathD = List<PointD>;

/// Extension methods for [PathD]
extension PathDExt on PathD {
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
  PathD scaledPath(double scale, {bool growable = true}) {
    if (isAlmostZero(scale - 1)) {
      return this;
    }
    return map((p) => p.scaled(scale)).toList(growable: growable);
  }

  /// Scale the path by [scale], returning a [Path64].
  Path64 scaledPath64(double scale, {bool growable = true}) => map(
    (p) => Point64.fromPointD(p, scale: scale),
  ).toList(growable: growable);

  /// Translate the path by [dx], [dy].
  PathD translatedPath(double dx, double dy, {bool growable = true}) =>
      map((p) => p.copy(p.x + dx, p.y + dy)).toList(growable: growable);

  /// Reverse the path.
  PathD get reversedPath => reversed.toList();

  /// Calculate the bounding box of the path.
  RectD get bounds {
    final result = RectD.invalid();
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
    return result.isValid ? result : RectD();
  }

  /// Create a copy of the path, removing any sequential nearly duplicated points.
  PathD nearDuplicatesStripped(
    double minEdgeLenSqrd, {
    required bool isClosed,
    bool growable = true,
  }) {
    return _nearDuplicatesStripped(
      minEdgeLenSqrd,
      isClosed,
    ).toList(growable: growable);
  }

  Iterable<PointD> _nearDuplicatesStripped(
    double minEdgeLenSqrd,
    bool isClosed,
  ) sync* {
    if (isEmpty) {
      return;
    }
    var lastPt = first;
    for (final pt in skip(1)) {
      if (!pointsNearEqual(lastPt, pt, minEdgeLenSqrd)) {
        yield lastPt;
        lastPt = pt;
      }
    }
    if (!isClosed || !pointsNearEqual(lastPt, first, minEdgeLenSqrd)) {
      yield lastPt;
    }
  }

  /// Create a simplified copy of the path, using the
  /// [Ramer-Douglas-Peucker](https://en.wikipedia.org/wiki/Ramer%E2%80%93Douglas%E2%80%93Peucker_algorithm) algorithm.
  PathD ramerDouglasPeucker(double epsilon, {bool growable = true}) {
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
  PathD simplified({
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
  PathD collateralTrimmed({int precision = 2, required bool isOpen}) {
    checkPrecision(precision);
    final scale = pow(10, precision).toDouble();
    final p = scaledPath64(scale);
    final t = p.collinearTrimmed(isOpen: isOpen);
    return t.scaledPathD(1 / scale);
  }

  /// Determine if the given point is inside the polygon.
  PointInPolygonResult pointInPolygon(PointD pt, {int precision = 2}) {
    checkPrecision(precision);
    final scale = pow(10, precision).toDouble();
    final p = scaledPath64(scale);
    return p.pointInPolygon(Point64.fromPointD(pt, scale: scale));
  }

  /// Create a [Path64] from a list of doubles that alternately specify X and Y coordinates.
  static PathD from(Iterable<double> coord, {bool growable = true}) =>
      takeEvenOdd(coord)
          .map((c) {
            final (x, y) = c;
            return PointD(x, y);
          })
          .toList(growable: growable);
}

import 'dart:math';

import '../../clipper.dart';

class Minkowski {
  static Paths64 _internal(
    Path64 pattern,
    Path64 path,
    bool isSum,
    bool isClosed,
  ) {
    final delta = isClosed ? 0 : 1;
    final patLen = pattern.length;
    final pathLen = path.length;
    final tmp = <Path64>[];

    for (final pathPt in path) {
      final path2 = <Point64>[];
      if (isSum) {
        for (final basePt in pattern) {
          path2.add(pathPt + basePt);
        }
      } else {
        for (final basePt in pattern) {
          path2.add(pathPt - basePt);
        }
      }
      tmp.add(path2);
    }

    final result = <Path64>[];
    var g = isClosed ? pathLen - 1 : 0;

    var h = patLen - 1;
    for (var i = delta; i < pathLen; i++) {
      for (var j = 0; j < patLen; j++) {
        final quad = [tmp[g][h], tmp[i][h], tmp[i][j], tmp[g][j]];
        if (!quad.isPositive) {
          result.add(quad.reversedPath);
        } else {
          result.add(quad);
        }
        h = j;
      }
      g = i;
    }
    return result;
  }

  static Paths64 sum({
    required Path64 pattern,
    required Path64 path,
    required bool isClosed,
  }) {
    return Clipper.union(
      subject: _internal(pattern, path, true, isClosed),
      fillRule: FillRule.nonZero,
    );
  }

  static PathsD sumD({
    required PathD pattern,
    required PathD path,
    required bool isClosed,
    int decimalPlaces = 2,
  }) {
    final scale = pow(10, decimalPlaces).toDouble();
    Paths64 tmp = Clipper.union(
      subject: _internal(
        pattern.scaledPath64(scale),
        path.scaledPath64(scale),
        true,
        isClosed,
      ),
      fillRule: FillRule.nonZero,
    );
    return tmp.scaledPathsD(1 / scale);
  }

  static Paths64 diff({
    required Path64 pattern,
    required Path64 path,
    required bool isClosed,
  }) {
    return Clipper.union(
      subject: _internal(pattern, path, false, isClosed),
      fillRule: FillRule.nonZero,
    );
  }

  static PathsD diffD({
    required PathD pattern,
    required PathD path,
    required bool isClosed,
    int decimalPlaces = 2,
  }) {
    final scale = pow(10, decimalPlaces).toDouble();
    Paths64 tmp = Clipper.union(
      subject: _internal(
        pattern.scaledPath64(scale),
        path.scaledPath64(scale),
        false,
        isClosed,
      ),
      fillRule: FillRule.nonZero,
    );
    return tmp.scaledPathsD(1 / scale);
  }
}

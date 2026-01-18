import 'clipper_internal.dart';
import 'path_d.dart';
import 'paths_64.dart';
import 'poly_tree.dart';
import 'rect_d.dart';

/// [PathsD] is a list of [PathD]s.
typedef PathsD = List<PathD>;

extension PathsDExt on PathsD {
  /// Calculate the area of the (possibly holed) polygon.
  double get area => fold(0.0, (a, p) => a + p.area);

  /// Scale the paths by [scale].
  PathsD scaledPaths(double scale, {bool growable = true}) {
    if (isAlmostZero(scale - 1)) {
      return this;
    }
    return map(
      (p) => p.scaledPath(scale, growable: growable),
    ).toList(growable: growable);
  }

  /// Scale the paths by [scale], returning a [Paths64].
  Paths64 scaledPaths64(double scale, {bool growable = true}) => map(
    (p) => p.scaledPath64(scale, growable: growable),
  ).toList(growable: growable);

  /// Translate the paths by [dx], [dy].
  PathsD translatedPaths(double dx, double dy, {bool growable = true}) =>
      map((p) => p.translatedPath(dx, dy)).toList(growable: growable);

  /// Reverse the paths.
  PathsD get reversedPaths => map((p) => p.reversedPath).toList();

  /// Calculate the bounding box of the path.
  RectD get bounds {
    final result = RectD.invalid();
    for (final path in this) {
      if (path.isNotEmpty) {
        final b = path.bounds;
        if (b.left < result.left) {
          result.left = b.left;
        }
        if (b.right > result.right) {
          result.right = b.right;
        }
        if (b.top < result.top) {
          result.top = b.top;
        }
        if (b.bottom > result.bottom) {
          result.bottom = b.bottom;
        }
      }
    }
    return result.isValid ? result : RectD();
  }

  /// Create a simplified copy of the path.
  PathsD simplified({
    required double epsilon,
    required bool isClosedPaths,
    bool growable = true,
  }) => map(
    (p) => p.simplified(epsilon: epsilon, isClosedPath: isClosedPaths),
  ).toList(growable: growable);

  void _addPolyNode(PolyPathD polyPath) {
    if (polyPath.polygon?.isNotEmpty == true) {
      add(polyPath.polygon!);
    }
    for (final child in polyPath.children) {
      _addPolyNode(child);
    }
  }

  /// Create a [Paths64] from a [PolyTree64].
  static PathsD fromPolyTree(PolyTreeD polyTree) {
    final result = <PathD>[];
    for (final child in polyTree.children) {
      result._addPolyNode(child);
    }
    return result;
  }
}

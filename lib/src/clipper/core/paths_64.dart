import 'clipper_internal.dart';
import 'path_64.dart';
import 'paths_d.dart';
import 'poly_tree.dart';
import 'rect_64.dart';

/// [Paths64] is a list of [Path64]s.
typedef Paths64 = List<Path64>;

extension Paths64Ext on Paths64 {
  /// Calculate the area of the (possibly holed) polygon.
  double get area => fold(0.0, (a, p) => a + p.area);

  /// Scale the paths by [scale].
  Paths64 scaledPaths(double scale, {bool growable = true}) {
    if (isAlmostZero(scale - 1)) {
      return this;
    }
    return map(
      (p) => p.scaledPath(scale, growable: growable),
    ).toList(growable: growable);
  }

  /// Scale the paths by [scale], returning a [PathsD].
  PathsD scaledPathsD(double scale, {bool growable = true}) => map(
    (p) => p.scaledPathD(scale, growable: growable),
  ).toList(growable: growable);

  /// Translate the paths by [dx], [dy].
  Paths64 translatedPaths(int dx, int dy, {bool growable = true}) => map(
    (p) => p.translatedPath(dx, dy, growable: growable),
  ).toList(growable: growable);

  /// Reverse the paths.
  Paths64 get reversedPaths => map((p) => p.reversedPath).toList();

  /// Calculate the bounding box of the path.
  Rect64 get bounds {
    final result = Rect64.invalid();
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
    return result.isValid ? result : Rect64();
  }

  /// Create a simplified copy of the path.
  Paths64 simplified({
    required double epsilon,
    required bool isClosedPaths,
    bool growable = true,
  }) => map(
    (p) => p.simplified(epsilon: epsilon, isClosedPath: isClosedPaths),
  ).toList(growable: growable);

  void _addPolyNode(PolyPath64 polyPath) {
    if (polyPath.polygon?.isNotEmpty == true) {
      add(polyPath.polygon!);
    }
    for (final child in polyPath.children) {
      _addPolyNode(child);
    }
  }

  /// Create a [Paths64] from a [PolyTree64].
  static Paths64 fromPolyTree(PolyTree64 polyTree) {
    final result = <Path64>[];
    for (final child in polyTree.children) {
      result._addPolyNode(child);
    }
    return result;
  }
}

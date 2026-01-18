import 'path_64.dart';
import 'path_d.dart';

/// A path interpreted as a polygon (which might be a part of a multi-level polygon).
abstract class PolyPath<T extends PolyPath<T, P>, P extends Object> {
  /// Constructor.
  PolyPath({this.polygon, this.parent}) : children = <T>[];

  /// Parent of the polygon.
  final T? parent;

  /// Children of the polygon.
  final List<T> children;

  /// This polygon as a path.
  final P? polygon;

  /// Determine the level of this polygon.
  int get level {
    var l = 0;
    for (var pp = parent; pp != null; pp = pp.parent) {
      l++;
    }
    return l;
  }

  /// Determine if this polygon is a hole.
  bool get isHole {
    final l = level;
    return l != 0 && (l & 1) == 0;
  }

  /// Remove all children from the polygon.
  void clear() {
    children.clear();
  }

  /// Add a new path as a child to this polygon.
  PolyPath addChild64(Path64 p);

  @override
  String toString() {
    if (level > 0) {
      return '';
    }
    return 'Polytree with ${children.length} polygon${children.length == 1 ? '' : 's'}.\n${children.indexed.map((c) => c.$2._toString(c.$1, 1)).join('')}';
  }

  String _toString(int idx, int level) {
    final String str;
    final padding = ''.padLeft(level * 2);
    if ((level & 1) == 0) {
      str =
          '$padding+- hole ($idx) contains {children.length} nested polygon${children.length == 1 ? '' : 's'}.\n';
    } else {
      str =
          '$padding+- polygon ($idx) contains {children.length} hole${children.length == 1 ? '' : 's'}.\n';
    }
    return '$str${children.indexed.map((c) => c.$2._toString(c.$1, level + 1)).join('')}';
  }

  void _showStructure(int level) {
    final spaces = ''.padLeft(level * 2);
    final caption = isHole ? 'Hole' : 'Outer';
    if (children.isEmpty) {
      print('$spaces$caption');
    } else {
      print('$spaces$caption ${children.length}');
      for (final child in children) {
        child._showStructure(level + 1);
      }
    }
  }
}

/// [PolyPath64] specializes [PolyPath] for a [Path64].
class PolyPath64 extends PolyPath<PolyPath64, Path64> {
  PolyPath64({super.polygon, super.parent});

  @override
  PolyPath addChild64(Path64 p) {
    final child = PolyPath64(polygon: p, parent: this);
    children.add(child);
    return child;
  }

  // Calculate the area of the polygon.
  double get area =>
      (polygon?.area ?? 0) + children.fold(0.0, (a, p) => a + p.area);
}

/// [PolyPathD] specializes [PolyPath] for a [PathD].
class PolyPathD extends PolyPath<PolyPathD, PathD> {
  PolyPathD({super.polygon, super.parent, required this.scale});

  final double scale;

  @override
  PolyPath addChild64(Path64 p) {
    final child = PolyPathD(
      polygon: p.scaledPathD(scale),
      parent: this,
      scale: scale,
    );
    children.add(child);
    return child;
  }

  PolyPathD addChildD(PathD p) {
    final child = PolyPathD(polygon: p, parent: this, scale: scale);
    children.add(child);
    return child;
  }
}

mixin PolyTreeMixin<T extends PolyPath<T, P>, P extends Object>
    on PolyPath<T, P> {
  void showStructure() {
    print('Polytree Root');
    for (final child in children) {
      child._showStructure(1);
    }
  }
}

/// [PolyTree64] is the root level of a polygon tree with paths as [Path64].
class PolyTree64 extends PolyPath64 with PolyTreeMixin {
  PolyTree64({super.polygon, super.parent});
}

/// [PolyTreeD] is the root level of a polygon tree with paths as [PathD].
class PolyTreeD extends PolyPathD with PolyTreeMixin {
  PolyTreeD({super.polygon, super.parent, required super.scale});
}

import '../../clipper.dart';

import 'clipper_base.dart';

/// Clipper engine that uses integer coordinates.
class Clipper64 {
  /// Constructor.
  Clipper64();

  final _base = ClipperBase();

  /// Should collinear points be preserved? Defaults to true.
  bool get preserveCollinear => _base.preserveCollinear;
  set preserveCollinear(bool value) => _base.preserveCollinear = value;

  /// Should a reversed solution be returned? Defaults to false.
  bool get reverseSolution => _base.reverseSolution;
  set reverseSolution(bool value) => _base.reverseSolution = value;

  /// Default Z value for new (intersection) points.
  int get defaultZ => _base.defaultZ;
  set defaultZ(int value) => _base.defaultZ = value;

  /// Callback for obtaining Z values.
  ZCallback64? get zCallback => _base.zCallback;
  set zCallback(ZCallback64? value) => _base.zCallback = value;

  /// Add a path for the clipping operation.
  void addPath(Path64 path, PathType polyType, {bool isOpen = false}) {
    _base.addPaths([path], polyType, isOpen: isOpen);
  }

  /// Add multiple paths for the clipping operation.
  void addPaths(Paths64 paths, PathType polytype, {bool isOpen = false}) {
    _base.addPaths(paths, polytype, isOpen: isOpen);
  }

  /// A convenience function for adding a closed subject path.
  void addSubject(Path64 path) => addPath(path, PathType.subject);

  /// A convenience function for adding closed subject paths.
  void addSubjects(Paths64 paths) => addPaths(paths, PathType.subject);

  /// A convenience function for adding an open subject path.
  void addOpenSubject(Path64 path) =>
      addPath(path, PathType.subject, isOpen: true);

  /// A convenience function for adding open subject paths.
  void addOpenSubjects(Paths64 paths) =>
      addPaths(paths, PathType.subject, isOpen: true);

  /// A convenience function for adding a clip path.
  void addClip(Path64 path) => addPath(path, PathType.clip);

  /// A convenience function for adding clip paths path.
  void addClips(Paths64 paths) => addPaths(paths, PathType.clip);

  /// Execute the operation. Returns the results as lists of closed and open paths.
  Solution64? execute(ClipType clipType, FillRule fillRule) {
    final solution = Solution64();
    _base.usingPolytree = false;
    _base.executeInternal(clipType, fillRule);
    if (!_base.succeeded) {
      return null;
    }
    _base.buildPaths(solution.closed, solution.open);
    _base.clearSolutionOnly();
    return solution;
  }

  /// Execute the operation, only returning closed paths.
  Paths64? executeClosed(ClipType clipType, FillRule fillRule) {
    return execute(clipType, fillRule)?.closed;
  }

  /// Execute the operation, returning the result as a polygon tree.
  SolutionTree64? executeTree(ClipType clipType, FillRule fillRule) {
    final solution = SolutionTree64();
    _base.usingPolytree = true;
    _base.executeInternal(clipType, fillRule);
    if (!_base.succeeded) {
      return null;
    }
    _base.buildTree(solution.tree, solution.open);
    _base.clearSolutionOnly();
    return solution;
  }
}

/// Solution for a clipping operation.
class Solution64 {
  Solution64();

  /// Closed paths in the solution.
  final closed = <Path64>[];

  // Open paths in the solution.
  final open = <Path64>[];
}

/// Solution for a clipping operation, as a polygon tree.
class SolutionTree64 {
  SolutionTree64();

  /// Root of the polygon tree for closed polygons.
  final tree = PolyTree64();

  /// Open paths in the solution.
  final open = <Path64>[];
}

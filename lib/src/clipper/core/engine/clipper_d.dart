import 'dart:math';

import '../../clipper.dart';
import '../clipper_internal.dart';

import 'clipper_base.dart';

/// After an intersection has been found, this callback can adjust the new point's Z level by returning a non-null
/// value. [intersectPt] contains an initial guess.
typedef ZCallbackD =
    int Function(
      PointD bot1,
      PointD top1,
      PointD bot2,
      PointD top2,
      PointD intersectPt,
    );

/// Clipper engine that uses floating point coordinates.
class ClipperD {
  /// Constructor.
  ClipperD({int roundingDecimalPrecision = 2}) {
    checkPrecision(roundingDecimalPrecision);
    _scale = pow(10, roundingDecimalPrecision).toDouble();
    _invScale = 1 / _scale;
  }

  final _base = ClipperBase();
  late final double _scale;
  late final double _invScale;
  ZCallbackD? _zCallback;

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
  ZCallbackD? get zCallback => _zCallback;
  set zCallback(ZCallbackD? value) {
    _zCallback = value;
    if (value == null) {
      _base.zCallback = null;
      return;
    }
    _base.zCallback = (bot1, top1, bot2, top2, intersectPt) {
      // de-scale (x & y)
      // temporarily convert integers to their initial float values
      // this will slow clipping marginally but will make it much easier
      // to understand the coordinates passed to the callback function
      final tmp = PointD.fromPoint64(intersectPt, scale: _invScale);
      //do the callback
      return value(
        PointD.fromPoint64(bot1, scale: _invScale),
        PointD.fromPoint64(top1, scale: _invScale),
        PointD.fromPoint64(bot2, scale: _invScale),
        PointD.fromPoint64(top2, scale: _invScale),
        tmp,
      );
    };
  }

  /// Add a path for the clipping operation.
  void addPath(PathD path, PathType polyType, {bool isOpen = false}) {
    addPaths([path], polyType, isOpen: isOpen);
  }

  /// Add multiple paths for the clipping operation.
  void addPaths(PathsD paths, PathType polytype, {bool isOpen = false}) {
    _base.addPaths(paths.scaledPaths64(_scale), polytype, isOpen: isOpen);
  }

  /// A convenience function for adding a closed subject path.
  void addSubject(PathD path) => addPath(path, PathType.subject);

  /// A convenience function for adding closed subject paths.
  void addSubjects(PathsD paths) => addPaths(paths, PathType.subject);

  /// A convenience function for adding an open subject path.
  void addOpenSubject(PathD path) =>
      addPath(path, PathType.subject, isOpen: true);

  /// A convenience function for adding open subject paths.
  void addOpenSubjects(PathsD paths) =>
      addPaths(paths, PathType.subject, isOpen: true);

  /// A convenience function for adding a clip path.
  void addClip(PathD path) => addPath(path, PathType.clip);

  /// A convenience function for adding clip paths path.
  void addClips(PathsD paths) => addPaths(paths, PathType.clip);

  /// Execute the operation. Returns the results as lists of closed and open paths.
  SolutionD? execute(ClipType clipType, FillRule fillRule) {
    _base.executeInternal(clipType, fillRule);
    if (!_base.succeeded) {
      return null;
    }
    final closed = <Path64>[];
    final open = <Path64>[];
    _base.buildPaths(closed, open);
    _base.clearSolutionOnly();
    return SolutionD._(
      closed.scaledPathsD(_invScale),
      open.scaledPathsD(_invScale),
    );
  }

  /// Execute the operation, only returning closed paths.
  PathsD? executeClosed(ClipType clipType, FillRule fillRule) {
    return execute(clipType, fillRule)?.closed;
  }

  /// Execute the operation, returning the result as a polygon tree.
  SolutionTreeD? executeTree(ClipType clipType, FillRule fillRule) {
    _base.executeInternal(clipType, fillRule);
    if (!_base.succeeded) {
      return null;
    }
    final tree = PolyTreeD(scale: _scale);
    final open = <Path64>[];
    _base.buildTree(tree, open);
    _base.clearSolutionOnly();
    return SolutionTreeD._(tree, open.scaledPathsD(_invScale));
  }
}

/// Solution for a clipping operation.
class SolutionD {
  SolutionD() : closed = <PathD>[], open = <PathD>[];
  SolutionD._(this.closed, this.open);

  /// Closed paths in the solution.
  final PathsD closed;
  // Open paths in the solution.
  final PathsD open;
}

/// Solution for a clipping operation, as a polygon tree.
class SolutionTreeD {
  SolutionTreeD({required double scale})
    : tree = PolyTreeD(scale: scale),
      open = <PathD>[];
  SolutionTreeD._(this.tree, this.open);

  /// Root of the polygon tree for closed polygons.
  final PolyTreeD tree;

  /// Open paths in the solution.
  final PathsD open;
}

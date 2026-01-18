import 'dart:math';

import '../../clipper.dart';
import '../clipper_internal.dart';
import 'package:collection/collection.dart';

import '../max_int_native.dart' if (dart.library.js_util) '../max_int_js.dart';

/// A callback to dynamically determine the delta value for a certain point in the path.
typedef DeltaCallback64 =
    double Function(Path64 path, PathD pathNorms, int currPt, int prevPt);

/// Polygon offsetting engine.
class ClipperOffset {
  static const _kTolerance = 1.0e-12;

  // 12 approximates arcs by using series of relatively short straight
  // line segments. And logically, shorter line segments will produce better arc
  // approximations. But very short segments can degrade performance, usually
  // with little or no discernable improvement in curve quality. Very short
  // segments can even detract from curve quality, due to the effects of integer
  // rounding. Since there isn't an optimal number of line segments for any given
  // arc radius (that perfectly balances curve approximation with performance),
  // arc tolerance is user defined. Nevertheless, when the user doesn't define
  // an arc tolerance (ie leaves alone the 0 default value), the calculated
  // default arc tolerance (offset_radius / 500) generally produces good (smooth)
  // arc approximations without producing excessively small segment lengths.
  // See also: https://www.angusj.com/clipper2/Docs/Trigonometry.htm
  static const double _kArcConst = 0.002; // <-- 1/500

  /// Constructor.
  ClipperOffset({
    this.miterLimit = 2.0,
    this.arcTolerance = 0.0,
    this.preserveCollinear = false,
    this.reverseSolution = false,
  });

  final _groupList = <_Group>[];
  var _pathOut = <Point64>[];
  final _normals = <PointD>[];
  var _solution = <Path64>[];
  PolyTree64? _solutionTree;
  DeltaCallback64? _deltaCallback;

  late double _groupDelta; //*0.5 for open paths; *-1.0 for negative areas
  late double _delta;
  late double _mitLimSqr;
  late double _stepsPerRad;
  late double _stepSin;
  late double _stepCos;
  late JoinType _joinType;
  late EndType _endType;

  /// Arc tolerance for round corners and ends. If unset, a suitable value is calculated dynamically.
  double arcTolerance;

  /// Limit for the maximum length of a miter join. Defaults to 2.0.
  double miterLimit;

  /// Preserve collinear points in the solution? Defaults to false.
  bool preserveCollinear;

  /// Return a reversed solution? Defaults to false.
  bool reverseSolution;

  /// An optional callback for setting the Z values in the returned path.
  ZCallback64? zCallback;

  int _zcb(Point64 bot1, Point64 top1, Point64 bot2, Point64 top2, Point64 ip) {
    if (bot1.z != 0 && ((bot1.z == bot2.z) || (bot1.z == top2.z))) {
      return bot1.z;
    } else if (bot2.z != 0 && bot2.z == top1.z) {
      return bot2.z;
    } else if (top1.z != 0 && top1.z == top2.z) {
      return top1.z;
    } else {
      return zCallback?.call(bot1, top1, bot2, top2, ip) ?? ip.z;
    }
  }

  /// Clear the inputs.
  void clear() {
    _groupList.clear();
  }

  /// Add a path to the calculation.
  void addPath(
    Path64 path, {
    required JoinType joinType,
    required EndType endType,
  }) {
    if (path.isEmpty) {
      return;
    }
    addPaths([path], joinType: joinType, endType: endType);
  }

  /// Add paths to the calculation.
  void addPaths(
    Paths64 paths, {
    required JoinType joinType,
    required EndType endType,
  }) {
    if (paths.isEmpty) {
      return;
    }
    _groupList.add(_Group(paths, joinType, endType: endType));
  }

  bool _checkPathsReversed() =>
      _groupList
          .firstWhereOrNull((g) => g.endType == EndType.polygon)
          ?.pathsReversed ??
      false;

  void _executeInternal(double delta, bool tree) {
    if (_groupList.isEmpty) {
      return;
    }

    // make sure the offset delta is significant
    if (delta.abs() < 0.5) {
      _solution.addAll(_groupList.expand((g) => g.inPaths));
      return;
    }

    _delta = delta;
    _mitLimSqr = (miterLimit <= 1 ? 2.0 : 2.0 / sqr(miterLimit));

    for (final group in _groupList) {
      _doGroupOffset(group);
    }

    if (_groupList.isEmpty) {
      return;
    }

    final pathsReversed = _checkPathsReversed();
    final fillRule = pathsReversed ? FillRule.negative : FillRule.positive;

    // clean up self-intersections ...
    final c =
        Clipper64()
          ..preserveCollinear =
              preserveCollinear // the solution should retain the orientation of the input
          ..reverseSolution = reverseSolution != pathsReversed;
    if (zCallback != null) {
      c.zCallback = _zcb;
    }
    c.addSubjects(_solution);
    if (tree) {
      _solutionTree = c.executeTree(ClipType.union, fillRule)?.tree;
    } else {
      _solution = c.executeClosed(ClipType.union, fillRule) ?? <Path64>[];
    }
  }

  /// Execute the offsetting operation.
  Paths64 execute({double? delta, DeltaCallback64? deltaCallback}) {
    assert(delta != null || deltaCallback != null);
    _solution.clear();
    _deltaCallback = deltaCallback;
    _executeInternal(delta ?? 1.0, false);
    return _solution;
  }

  /// Execute the offsetting operation, requesting output as a polygon tree.
  PolyTree64 executeTree({double? delta, DeltaCallback64? deltaCallback}) {
    assert(delta != null || _deltaCallback != null);
    _solution.clear();
    _deltaCallback = deltaCallback;
    _executeInternal(delta ?? 1.0, true);
    return _solutionTree ?? PolyTree64();
  }

  static PointD _getUnitNormal(Point64 pt1, Point64 pt2) {
    final dx = (pt2.x - pt1.x);
    final dy = (pt2.y - pt1.y);
    if (dx == 0 && dy == 0) {
      return PointD(0, 0);
    }
    double f = 1.0 / sqrt(dx * dx + dy * dy);
    return PointD(dy * f, -dx * f);
  }

  static PointD _getAvgUnitVector(PointD vec1, PointD vec2) =>
      (vec1 + vec2).normalized();

  static PointD _intersectPoint(
    PointD pt1a,
    PointD pt1b,
    PointD pt2a,
    PointD pt2b,
    int z,
  ) {
    if (isAlmostZero(pt1a.x - pt1b.x)) //vertical
    {
      if (isAlmostZero(pt2a.x - pt2b.x)) {
        return PointD(0, 0, z);
      }
      final m2 = (pt2b.y - pt2a.y) / (pt2b.x - pt2a.x);
      final b2 = pt2a.y - m2 * pt2a.x;
      return PointD(pt1a.x, m2 * pt1a.x + b2, z);
    }

    if (isAlmostZero(pt2a.x - pt2b.x)) //vertical
    {
      final m1 = (pt1b.y - pt1a.y) / (pt1b.x - pt1a.x);
      final b1 = pt1a.y - m1 * pt1a.x;
      return PointD(pt2a.x, m1 * pt2a.x + b1, z);
    }
    final m1 = (pt1b.y - pt1a.y) / (pt1b.x - pt1a.x);
    final b1 = pt1a.y - m1 * pt1a.x;
    final m2 = (pt2b.y - pt2a.y) / (pt2b.x - pt2a.x);
    final b2 = pt2a.y - m2 * pt2a.x;
    if (isAlmostZero(m1 - m2)) {
      return PointD(0, 0, z);
    }
    final x = (b2 - b1) / (m1 - m2);
    return PointD(x, m1 * x + b1, z);
  }

  Point64 _getPerpendic(Point64 pt, PointD norm) => pt.copy(
    pt.x + (norm.x * _groupDelta).round(),
    pt.y + (norm.y * _groupDelta).round(),
  );

  PointD _getPerpendicD(Point64 pt, PointD norm) =>
      pt.copyToD(pt.x + norm.x * _groupDelta, pt.y + norm.y * _groupDelta);

  void _doBevel(Path64 path, int j, int k) {
    Point64 pt1, pt2;
    if (j == k) {
      final absDelta = _groupDelta.abs();
      pt1 = path[j].translated(
        -(absDelta * _normals[j].x).round(),
        -(absDelta * _normals[j].y).round(),
      );
      pt2 = path[j].translated(
        (absDelta * _normals[j].x).round(),
        (absDelta * _normals[j].y).round(),
      );
    } else {
      pt1 = path[j].translated(
        (_groupDelta * _normals[k].x).round(),
        (_groupDelta * _normals[k].y).round(),
      );
      pt2 = path[j].translated(
        (_groupDelta * _normals[j].x).round(),
        (_groupDelta * _normals[j].y).round(),
      );
    }
    _pathOut.add(pt1);
    _pathOut.add(pt2);
  }

  void _doSquare(Path64 path, int j, int k) {
    PointD vec;
    if (j == k) {
      vec = PointD(_normals[j].y, -_normals[j].x);
    } else {
      vec = _getAvgUnitVector(
        PointD(-_normals[k].y, _normals[k].x),
        PointD(_normals[j].y, -_normals[j].x),
      );
    }

    final absDelta = _groupDelta.abs();
    // now offset the original vertex delta units along unit vector
    final ptQ = PointD.fromPoint64(
      path[j],
    ).translated(absDelta * vec.x, absDelta * vec.y);

    // get perpendicular vertices
    final pt1 = ptQ.translated(_groupDelta * vec.y, _groupDelta * -vec.x);
    final pt2 = ptQ.translated(_groupDelta * -vec.y, _groupDelta * vec.x);
    // get 2 vertices along one edge offset
    final pt3 = _getPerpendicD(path[k], _normals[k]);

    if (j == k) {
      final pt4 = PointD(
        pt3.x + vec.x * _groupDelta,
        pt3.y + vec.y * _groupDelta,
      );
      final pt = _intersectPoint(pt1, pt2, pt3, pt4, ptQ.z);
      //get the second intersect point through reflecion
      _pathOut.add(Point64.fromPointD(pt.reflected(ptQ)));
      _pathOut.add(Point64.fromPointD(pt));
    } else {
      final pt4 = _getPerpendicD(path[j], _normals[k]);
      final pt = _intersectPoint(pt1, pt2, pt3, pt4, ptQ.z);
      _pathOut.add(Point64.fromPointD(pt));
      //get the second intersect point through reflecion
      _pathOut.add(Point64.fromPointD(pt.reflected(ptQ)));
    }
  }

  void _doMiter(Path64 path, int j, int k, double cosA) {
    double q = _groupDelta / (cosA + 1);
    _pathOut.add(
      path[j].translated(
        ((_normals[k].x + _normals[j].x) * q).round(),
        ((_normals[k].y + _normals[j].y) * q).round(),
      ),
    );
  }

  void _doRound(Path64 path, int j, int k, double angle) {
    if (_deltaCallback != null) {
      // when DeltaCallback is assigned, _groupDelta won't be constant,
      // so we'll need to do the following calculations for *every* vertex.
      final absDelta = _groupDelta.abs();
      final arcTol = arcTolerance > 0.01 ? arcTolerance : absDelta * _kArcConst;
      final stepsPer360 = pi / acos(1 - arcTol / absDelta);
      _stepSin = sin((2 * pi) / stepsPer360);
      _stepCos = cos((2 * pi) / stepsPer360);
      if (_groupDelta < 0.0) {
        _stepSin = -_stepSin;
      }
      _stepsPerRad = stepsPer360 / (2 * pi);
    }

    final pt = path[j];
    var offsetVec = PointD(
      _normals[k].x * _groupDelta,
      _normals[k].y * _groupDelta,
    );
    if (j == k) {
      offsetVec = offsetVec.negated;
    }
    _pathOut.add(pt.translated(offsetVec.x.round(), offsetVec.y.round()));
    int steps = (_stepsPerRad * angle.abs()).ceil();
    for (var i = 1; i < steps; i++) // ie 1 less than steps
    {
      offsetVec = PointD(
        offsetVec.x * _stepCos - _stepSin * offsetVec.y,
        offsetVec.x * _stepSin + offsetVec.y * _stepCos,
      );
      _pathOut.add(pt.translated(offsetVec.x.round(), offsetVec.y.round()));
    }
    _pathOut.add(_getPerpendic(pt, _normals[j]));
  }

  void _buildNormals(Path64 path) {
    _normals.clear();
    if (path.isEmpty) {
      return;
    }
    for (int i = 0; i < path.length - 1; i++) {
      _normals.add(_getUnitNormal(path[i], path[i + 1]));
    }
    _normals.add(_getUnitNormal(path.last, path.first));
  }

  int _offsetPoint(_Group group, Path64 path, int j, int k) {
    if (path[j] == path[k]) {
      return j;
    }

    // Let A = change in angle where edges join
    // A == 0: ie no change in angle (flat join)
    // A == PI: edges 'spike'
    // sin(A) < 0: right turning
    // cos(A) < 0: change in angle is more than 90 degree
    double sinA = _normals[j].crossProduct(_normals[k]);
    double cosA = _normals[j].dotProduct(_normals[k]);
    if (sinA > 1.0) {
      sinA = 1.0;
    } else if (sinA < -1.0) {
      sinA = -1.0;
    }

    if (_deltaCallback != null) {
      _groupDelta = _deltaCallback!(path, _normals, j, k);
      if (group.pathsReversed) {
        _groupDelta = -_groupDelta;
      }
    }
    if (_groupDelta.abs() < _kTolerance) {
      _pathOut.add(path[j]);
      return k;
    }

    // test for concavity first (#593)
    if (cosA > -0.999 && sinA * _groupDelta < 0) {
      // is concave
      // by far the simplest way to construct concave joins, especially those joining very
      // short segments, is to insert 3 points that produce negative regions. These regions
      // will be removed later by the finishing union operation. This is also the best way
      // to ensure that path reversals (ie over-shrunk paths) are removed.
      _pathOut.add(_getPerpendic(path[j], _normals[k]));
      _pathOut.add(path[j]); // (#405, #873, #916)
      _pathOut.add(_getPerpendic(path[j], _normals[j]));
    } else if ((cosA > 0.999) && (_joinType != JoinType.round)) {
      // almost straight - less than 2.5 degree (#424, #482, #526 & #724)
      _doMiter(path, j, k, cosA);
    } else {
      switch (_joinType) {
        // miter unless the angle is sufficiently acute to exceed ML
        case JoinType.miter when cosA > _mitLimSqr - 1:
          _doMiter(path, j, k, cosA);
          break;
        case JoinType.miter:
          _doSquare(path, j, k);
          break;
        case JoinType.round:
          _doRound(path, j, k, atan2(sinA, cosA));
          break;
        case JoinType.bevel:
          _doBevel(path, j, k);
          break;
        default:
          _doSquare(path, j, k);
          break;
      }
    }
    return j;
  }

  void _offsetPolygon(_Group group, Path64 path) {
    _pathOut = <Point64>[];
    var cnt = path.length;
    var prev = cnt - 1;
    for (int i = 0; i < cnt; i++) {
      prev = _offsetPoint(group, path, i, prev);
    }
    _solution.add(_pathOut);
  }

  void _offsetOpenJoined(_Group group, Path64 path) {
    _offsetPolygon(group, path);
    path = path.reversedPath;
    _buildNormals(path);
    _offsetPolygon(group, path);
  }

  void _offsetOpenPath(_Group group, Path64 path) {
    _pathOut = <Point64>[];
    var highI = path.length - 1;

    if (_deltaCallback != null) {
      _groupDelta = _deltaCallback!(path, _normals, 0, 0);
    }

    // do the line start cap
    if (_groupDelta.abs() < _kTolerance) {
      _pathOut.add(path[0]);
    } else {
      switch (_endType) {
        case EndType.butt:
          _doBevel(path, 0, 0);
          break;
        case EndType.round:
          _doRound(path, 0, 0, pi);
          break;
        default:
          _doSquare(path, 0, 0);
          break;
      }
    }

    // offset the left side going forward
    for (var i = 1, k = 0; i < highI; i++) {
      k = _offsetPoint(group, path, i, k);
    }

    // reverse normals ...
    for (var i = highI; i > 0; i--) {
      _normals[i] = _normals[i - 1].negated;
    }
    _normals[0] = _normals[highI];

    if (_deltaCallback != null) {
      _groupDelta = _deltaCallback!(path, _normals, highI, highI);
    }

    // do the line end cap
    if (_groupDelta.abs() < _kTolerance) {
      _pathOut.add(path[highI]);
    } else {
      switch (_endType) {
        case EndType.butt:
          _doBevel(path, highI, highI);
          break;
        case EndType.round:
          _doRound(path, highI, highI, pi);
          break;
        default:
          _doSquare(path, highI, highI);
          break;
      }
    }

    // offset the left side going back
    for (int i = highI - 1, k = highI; i > 0; i--) {
      k = _offsetPoint(group, path, i, k);
    }

    _solution.add(_pathOut);
  }

  void _doGroupOffset(_Group group) {
    if (group.endType == EndType.polygon) {
      // a straight path (2 points) can now also be 'polygon' offset
      // where the ends will be treated as (180 deg.) joins
      if (group.lowestPathIdx < 0) {
        _delta = _delta.abs();
      }
      _groupDelta = group.pathsReversed ? -_delta : _delta;
    } else {
      _groupDelta = _delta.abs();
    }

    var absDelta = _groupDelta.abs();

    _joinType = group.joinType;
    _endType = group.endType;

    if (group.joinType == JoinType.round || group.endType == EndType.round) {
      double arcTol =
          arcTolerance > 0.01 ? arcTolerance : absDelta * _kArcConst;
      double stepsPer360 = pi / acos(1 - arcTol / absDelta);
      _stepSin = sin((2 * pi) / stepsPer360);
      _stepCos = cos((2 * pi) / stepsPer360);
      if (_groupDelta < 0.0) {
        _stepSin = -_stepSin;
      }
      _stepsPerRad = stepsPer360 / (2 * pi);
    }

    for (final p in group.inPaths) {
      _pathOut = <Point64>[];
      int cnt = p.length;

      if (cnt == 1) {
        Point64 pt = p.first;

        if (_deltaCallback != null) {
          _groupDelta = _deltaCallback!(p, _normals, 0, 0);
          if (group.pathsReversed) {
            _groupDelta = -_groupDelta;
          }
          absDelta = _groupDelta.abs();
        }

        // single vertex so build a circle or square ...
        if (group.endType == EndType.round) {
          final steps = (_stepsPerRad * 2 * pi).ceil();
          _pathOut = Path64Ext.ellipse(
            center: pt,
            radiusX: absDelta,
            radiusY: absDelta,
            steps: steps,
            z: pt.z,
          );
        } else {
          final d = _groupDelta.ceil();
          final r = Rect64.fromLTRB(pt.x - d, pt.y - d, pt.x + d, pt.y + d);
          _pathOut = r.asPathWithZ(pt.z);
        }
        _solution.add(_pathOut);
        continue; // end of offsetting a single point
      }
      if (cnt == 2 && group.endType == EndType.joined) {
        _endType =
            (group.joinType == JoinType.round) ? EndType.round : EndType.square;
      }

      _buildNormals(p);
      switch (_endType) {
        case EndType.polygon:
          _offsetPolygon(group, p);
        case EndType.joined:
          _offsetOpenJoined(group, p);
        default:
          _offsetOpenPath(group, p);
      }
    }
  }
}

class _Group {
  _Group(Paths64 paths, this.joinType, {this.endType = EndType.polygon})
    : inPaths =
          paths
              .map(
                (path) => path.duplicatesStripped(
                  isClosed:
                      endType == EndType.polygon || endType == EndType.joined,
                ),
              )
              .toList() {
    if (endType == EndType.polygon) {
      lowestPathIdx = _getLowestPathIdx(inPaths);
      // the lowermost path must be an outer path, so if its orientation is negative,
      // then flag that the whole group is 'reversed' (will negate delta etc.)
      // as this is much more efficient than reversing every path.
      pathsReversed = lowestPathIdx >= 0 && (inPaths[lowestPathIdx].area < 0);
    } else {
      lowestPathIdx = -1;
      pathsReversed = false;
    }
  }

  Paths64 inPaths;
  JoinType joinType;
  EndType endType;
  late bool pathsReversed;
  late int lowestPathIdx;

  static int _getLowestPathIdx(Paths64 paths) {
    var result = -1;
    var botPt = Point64(kMaxInt64, -kMaxInt64);
    for (var i = 0; i < paths.length; i++) {
      for (final pt in paths[i]) {
        if ((pt.y < botPt.y) || ((pt.y == botPt.y) && (pt.x >= botPt.x))) {
          continue;
        }
        result = i;
        botPt = pt;
      }
    }
    return result;
  }
}

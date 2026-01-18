import 'package:dart_graphics/src/dart_graphics/vertex_source/flatten_curve.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/ivertex_source.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/vertex_storage.dart';

/// Utility helpers for backend-agnostic path processing.
class PathUtils {
  static ({double minX, double minY, double maxX, double maxY}) bounds(IVertexSource path) {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final v in path.vertices()) {
      if (v.command.isVertex) {
        if (v.x < minX) minX = v.x;
        if (v.y < minY) minY = v.y;
        if (v.x > maxX) maxX = v.x;
        if (v.y > maxY) maxY = v.y;
      }
    }

    if (minX == double.infinity) {
      return (minX: 0.0, minY: 0.0, maxX: 0.0, maxY: 0.0);
    }
    return (minX: minX, minY: minY, maxX: maxX, maxY: maxY);
  }

  /// Flatten curves into line segments and return as a [VertexStorage].
  static VertexStorage flatten(IVertexSource path, {double approximationScale = 1.0}) {
    final flattener = FlattenCurve(path);
    flattener.setApproximationScale(approximationScale);

    final dest = VertexStorage();
    for (final v in flattener.vertices()) {
      if (v.command.isStop) break;
      dest.addVertex(v.x, v.y, v.command);
    }
    return dest;
  }

  /// Adaptive flattening with geometric tolerance (in pixels).
  static VertexStorage flattenAdaptive(
    IVertexSource path, {
    double tolerance = 0.5,
  }) {
    final dest = VertexStorage();
    final verts = path.vertices().toList();

    _Point last = const _Point(0, 0);
    _Point start = const _Point(0, 0);
    var hasCurrent = false;

    int i = 0;
    while (i < verts.length) {
      final v = verts[i];
      if (v.command.isStop) break;

      if (v.command.isMoveTo) {
        dest.moveTo(v.x, v.y);
        last = _Point(v.x, v.y);
        start = last;
        hasCurrent = true;
        i++;
        continue;
      }

      if (!hasCurrent) {
        dest.moveTo(v.x, v.y);
        last = _Point(v.x, v.y);
        start = last;
        hasCurrent = true;
        i++;
        continue;
      }

      if (v.command.isLineTo) {
        dest.lineTo(v.x, v.y);
        last = _Point(v.x, v.y);
        i++;
        continue;
      }

      if (v.command.isCurve3) {
        if (i + 1 >= verts.length) break;
        final cp = _Point(v.x, v.y);
        final end = _Point(verts[i + 1].x, verts[i + 1].y);
        _flattenQuadratic(last, cp, end, tolerance, dest);
        last = end;
        i += 2;
        continue;
      }

      if (v.command.isCurve4) {
        if (i + 2 >= verts.length) break;
        final cp1 = _Point(v.x, v.y);
        final cp2 = _Point(verts[i + 1].x, verts[i + 1].y);
        final end = _Point(verts[i + 2].x, verts[i + 2].y);
        _flattenCubic(last, cp1, cp2, end, tolerance, dest);
        last = end;
        i += 3;
        continue;
      }

      if (v.command.isEndPoly) {
        if (v.command.isClose) {
          dest.closePath();
          last = start;
        }
        i++;
        continue;
      }

      i++;
    }

    return dest;
  }

  /// Simplify a path using Douglas-Peucker after flattening curves.
  static VertexStorage simplify(
    IVertexSource path, {
    double tolerance = 0.25,
    double approximationScale = 1.0,
  }) {
    final flattened = flatten(path, approximationScale: approximationScale);
    final dest = VertexStorage();

    final points = <_Point>[];
    bool close = false;

    void flush() {
      if (points.isEmpty) return;
      final simplified = _simplifyDouglasPeucker(points, tolerance, closed: close);
      dest.moveTo(simplified.first.x, simplified.first.y);
      for (var i = 1; i < simplified.length; i++) {
        dest.lineTo(simplified[i].x, simplified[i].y);
      }
      if (close) {
        dest.closePath();
      }
      points.clear();
      close = false;
    }

    for (final v in flattened.vertices()) {
      if (v.command.isStop) break;
      if (v.command.isMoveTo) {
        flush();
        points.add(_Point(v.x, v.y));
      } else if (v.command.isLineTo) {
        points.add(_Point(v.x, v.y));
      } else if (v.command.isEndPoly) {
        close = v.command.isClose;
        flush();
      }
    }
    flush();

    return dest;
  }

  /// Copies all vertices into a new [VertexStorage].
  static VertexStorage copy(IVertexSource path) {
    final dest = VertexStorage();
    for (final v in path.vertices()) {
      if (v.command.isStop) break;
      dest.addVertex(v.x, v.y, v.command);
    }
    return dest;
  }
}

class _Point {
  final double x;
  final double y;
  const _Point(this.x, this.y);
}

void _flattenQuadratic(
  _Point p0,
  _Point p1,
  _Point p2,
  double tolerance,
  VertexStorage dest,
) {
  final tol2 = tolerance * tolerance;
  final stack = <List<_Point>>[];
  stack.add([p0, p1, p2]);

  while (stack.isNotEmpty) {
    final seg = stack.removeLast();
    final a = seg[0];
    final b = seg[1];
    final c = seg[2];

    if (_distanceToLineSquared(b, a, c) <= tol2) {
      dest.lineTo(c.x, c.y);
      continue;
    }

    final ab = _mid(a, b);
    final bc = _mid(b, c);
    final abc = _mid(ab, bc);

    stack.add([abc, bc, c]);
    stack.add([a, ab, abc]);
  }
}

void _flattenCubic(
  _Point p0,
  _Point p1,
  _Point p2,
  _Point p3,
  double tolerance,
  VertexStorage dest,
) {
  final tol2 = tolerance * tolerance;
  final stack = <List<_Point>>[];
  stack.add([p0, p1, p2, p3]);

  while (stack.isNotEmpty) {
    final seg = stack.removeLast();
    final a = seg[0];
    final b = seg[1];
    final c = seg[2];
    final d = seg[3];

    final d1 = _distanceToLineSquared(b, a, d);
    final d2 = _distanceToLineSquared(c, a, d);
    if (d1 <= tol2 && d2 <= tol2) {
      dest.lineTo(d.x, d.y);
      continue;
    }

    final ab = _mid(a, b);
    final bc = _mid(b, c);
    final cd = _mid(c, d);
    final abc = _mid(ab, bc);
    final bcd = _mid(bc, cd);
    final abcd = _mid(abc, bcd);

    stack.add([abcd, bcd, cd, d]);
    stack.add([a, ab, abc, abcd]);
  }
}

_Point _mid(_Point a, _Point b) => _Point((a.x + b.x) * 0.5, (a.y + b.y) * 0.5);

List<_Point> _simplifyDouglasPeucker(List<_Point> points, double tolerance, {required bool closed}) {
  if (points.length <= 2) return List<_Point>.from(points);

  final tol2 = tolerance * tolerance;
  final src = closed ? _ensureClosed(points) : points;
  final keep = List<bool>.filled(src.length, false);
  keep[0] = true;
  keep[src.length - 1] = true;

  _douglasPeucker(src, 0, src.length - 1, tol2, keep);

  final result = <_Point>[];
  for (var i = 0; i < src.length; i++) {
    if (keep[i]) result.add(src[i]);
  }

  if (closed && result.length > 1) {
    result.removeLast();
  }

  return result;
}

void _douglasPeucker(List<_Point> pts, int first, int last, double tol2, List<bool> keep) {
  if (last <= first + 1) return;

  final a = pts[first];
  final b = pts[last];
  double maxDist2 = 0.0;
  int index = -1;

  for (var i = first + 1; i < last; i++) {
    final d2 = _distToSegmentSquared(pts[i], a, b);
    if (d2 > maxDist2) {
      maxDist2 = d2;
      index = i;
    }
  }

  if (maxDist2 > tol2 && index != -1) {
    keep[index] = true;
    _douglasPeucker(pts, first, index, tol2, keep);
    _douglasPeucker(pts, index, last, tol2, keep);
  }
}

double _distToSegmentSquared(_Point p, _Point a, _Point b) {
  final vx = b.x - a.x;
  final vy = b.y - a.y;
  final wx = p.x - a.x;
  final wy = p.y - a.y;

  final c1 = vx * wx + vy * wy;
  if (c1 <= 0) return _distSquared(p, a);

  final c2 = vx * vx + vy * vy;
  if (c2 <= c1) return _distSquared(p, b);

  final t = c1 / c2;
  final proj = _Point(a.x + t * vx, a.y + t * vy);
  return _distSquared(p, proj);
}

double _distSquared(_Point p, _Point q) {
  final dx = p.x - q.x;
  final dy = p.y - q.y;
  return dx * dx + dy * dy;
}

double _distanceToLineSquared(_Point p, _Point a, _Point b) {
  final vx = b.x - a.x;
  final vy = b.y - a.y;
  final wx = p.x - a.x;
  final wy = p.y - a.y;
  final c2 = vx * vx + vy * vy;
  if (c2 <= 1e-20) return _distSquared(p, a);
  final cross = vx * wy - vy * wx;
  return (cross * cross) / c2;
}

List<_Point> _ensureClosed(List<_Point> points) {
  if (points.isEmpty) return points;
  final first = points.first;
  final last = points.last;
  if ((first.x - last.x).abs() < 1e-12 && (first.y - last.y).abs() < 1e-12) {
    return points;
  }
  final closed = List<_Point>.from(points);
  closed.add(_Point(first.x, first.y));
  return closed;
}

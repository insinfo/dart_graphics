import 'dart:math' as math;

import 'package:dart_graphics/src/shared/ref_param.dart';
import 'ivertex_source.dart';
import 'path_commands.dart';
import 'vertex_data.dart';

/// Flattens curved paths into line segments for rendering.
///
/// This class takes a vertex source containing curves (curve3, curve4) and
/// converts them into a series of line segments that approximate the curves.
class FlattenCurve implements IVertexSource {
  IVertexSource? _source;
  double _approximationScale = 1.0;
  double _angleTolerance = 0.0;
  double _cuspLimit = 0.0;

  final List<VertexData> _vertices = [];
  int _currentVertex = 0;

  static const double _curveCollinearityEpsilon = 1e-30;
  static const double _curveAngleToleranceEpsilon = 0.01;
  static const int _curveRecursionLimit = 32;

  FlattenCurve([IVertexSource? source]) {
    _source = source;
  }

  /// Sets the source vertex path to flatten.
  void setSource(IVertexSource source) {
    _source = source;
  }

  /// Sets the approximation scale (affects curve smoothness).
  /// Smaller values = smoother curves but more points.
  void setApproximationScale(double scale) {
    _approximationScale = scale;
  }

  double get _distanceToleranceSquare {
    var tolerance = 0.5 / _approximationScale;
    return tolerance * tolerance;
  }

  @override
  void rewind([int pathId = 0]) {
    _vertices.clear();
    _currentVertex = 0;

    if (_source == null) return;

    _source!.rewind(pathId);
    _flattenPath();
  }

  @override
  FlagsAndCommand vertex(RefParam<double> x, RefParam<double> y) {
    if (_currentVertex >= _vertices.length) {
      x.value = 0;
      y.value = 0;
      return FlagsAndCommand.commandStop;
    }

    final v = _vertices[_currentVertex];
    x.value = v.x;
    y.value = v.y;
    _currentVertex++;

    return v.command;
  }

  @override
  Iterable<VertexData> vertices() sync* {
    rewind();
    var x = RefParam(0.0);
    var y = RefParam(0.0);

    while (true) {
      var cmd = vertex(x, y);
      if (cmd.isStop) break;
      yield VertexData(cmd, x.value, y.value);
    }
  }

  @override
  int getLongHashCode([int hash = 0xcbf29ce484222325]) {
    if (_source != null) {
      hash = _source!.getLongHashCode(hash);
    }
    hash ^= _approximationScale.hashCode;
    hash *= 1099511628211;
    return hash;
  }

  void _flattenPath() {
    final x = RefParam(0.0);
    final y = RefParam(0.0);

    double startX = 0.0;
    double startY = 0.0;
    double lastX = 0.0;
    double lastY = 0.0;

    // Control points for curves
    double cp1x = 0.0, cp1y = 0.0;
    double cp2x = 0.0, cp2y = 0.0;

    FlagsAndCommand cmd;
    while ((cmd = _source!.vertex(x, y)) != FlagsAndCommand.commandStop) {
      final cmdBase = cmd & FlagsAndCommand.commandMask;

      if (cmdBase == FlagsAndCommand.commandMoveTo) {
        _addVertex(VertexData(cmd, x.value, y.value));
        startX = lastX = x.value;
        startY = lastY = y.value;
      } else if (cmdBase == FlagsAndCommand.commandLineTo) {
        _addVertex(VertexData(cmd, x.value, y.value));
        lastX = x.value;
        lastY = y.value;
      } else if (cmdBase == FlagsAndCommand.commandCurve3) {
        // Quadratic Bezier - first call gets control point, second gets end point
        cp1x = x.value;
        cp1y = y.value;

        // Get the end point
        cmd = _source!.vertex(x, y);
        if (cmd != FlagsAndCommand.commandStop) {
          final distanceToleranceSquare = _distanceToleranceSquare;
          _subdivideQuadratic(lastX, lastY, cp1x, cp1y, x.value, y.value, 0,
              distanceToleranceSquare);
          _addVertex(VertexData(FlagsAndCommand.commandLineTo, x.value, y.value));
          lastX = x.value;
          lastY = y.value;
        }
      } else if (cmdBase == FlagsAndCommand.commandCurve4) {
        // Cubic Bezier - three calls: cp1, cp2, end point
        cp1x = x.value;
        cp1y = y.value;

        cmd = _source!.vertex(x, y);
        if (cmd == FlagsAndCommand.commandStop) break;
        cp2x = x.value;
        cp2y = y.value;

        cmd = _source!.vertex(x, y);
        if (cmd == FlagsAndCommand.commandStop) break;

        final distanceToleranceSquare = _distanceToleranceSquare;
        _subdivideCubic(lastX, lastY, cp1x, cp1y, cp2x, cp2y, x.value, y.value,
          0, distanceToleranceSquare);
        _addVertex(VertexData(FlagsAndCommand.commandLineTo, x.value, y.value));
        lastX = x.value;
        lastY = y.value;
      } else if (cmdBase == FlagsAndCommand.commandEndPoly) {
        if ((cmd & FlagsAndCommand.flagClose).value != 0) {
          // Close the path
          if (_vertices.isNotEmpty) {
            _addVertex(
                VertexData(FlagsAndCommand.commandLineTo, startX, startY));
          }
        }
        _addVertex(VertexData(cmd, 0, 0));
      }
    }
  }

  void _addVertex(VertexData v) {
    _vertices.add(v);
  }

  double _calcSqDistance(double x1, double y1, double x2, double y2) {
    final dx = x2 - x1;
    final dy = y2 - y1;
    return dx * dx + dy * dy;
  }

  /// Subdivides a quadratic Bezier curve into line segments.
  void _subdivideQuadratic(
    double x1,
    double y1, // Start point
    double x2,
    double y2, // Control point
    double x3,
    double y3, // End point
    int level,
    double distanceToleranceSquare,
  ) {
    if (level > _curveRecursionLimit) return;

    // Calculate the midpoint
    final x12 = (x1 + x2) / 2;
    final y12 = (y1 + y2) / 2;
    final x23 = (x2 + x3) / 2;
    final y23 = (y2 + y3) / 2;
    final x123 = (x12 + x23) / 2;
    final y123 = (y12 + y23) / 2;

    final dx = x3 - x1;
    final dy = y3 - y1;
    var d = ((x2 - x3) * dy - (y2 - y3) * dx).abs();
    double da;

    if (d > _curveCollinearityEpsilon) {
      if (d * d <= distanceToleranceSquare * (dx * dx + dy * dy)) {
        if (_angleTolerance < _curveAngleToleranceEpsilon) {
          _addVertex(VertexData(FlagsAndCommand.commandLineTo, x123, y123));
          return;
        }

        da = (math.atan2(y3 - y2, x3 - x2) - math.atan2(y2 - y1, x2 - x1)).abs();
        if (da >= math.pi) da = 2 * math.pi - da;

        if (da < _angleTolerance) {
          _addVertex(VertexData(FlagsAndCommand.commandLineTo, x123, y123));
          return;
        }
      }
    } else {
      da = dx * dx + dy * dy;
      if (da == 0) {
        d = _calcSqDistance(x1, y1, x2, y2);
      } else {
        d = ((x2 - x1) * dx + (y2 - y1) * dy) / da;
        if (d > 0 && d < 1) {
          return;
        }
        if (d <= 0) {
          d = _calcSqDistance(x2, y2, x1, y1);
        } else if (d >= 1) {
          d = _calcSqDistance(x2, y2, x3, y3);
        } else {
          d = _calcSqDistance(x2, y2, x1 + d * dx, y1 + d * dy);
        }
      }
      if (d < distanceToleranceSquare) {
        _addVertex(VertexData(FlagsAndCommand.commandLineTo, x2, y2));
        return;
      }
    }

    _subdivideQuadratic(
        x1, y1, x12, y12, x123, y123, level + 1, distanceToleranceSquare);
    _subdivideQuadratic(
        x123, y123, x23, y23, x3, y3, level + 1, distanceToleranceSquare);
  }

  /// Subdivides a cubic Bezier curve into line segments.
  void _subdivideCubic(
    double x1,
    double y1, // Start point
    double x2,
    double y2, // Control point 1
    double x3,
    double y3, // Control point 2
    double x4,
    double y4, // End point
    int level,
    double distanceToleranceSquare,
  ) {
    if (level > _curveRecursionLimit) return;

    // De Casteljau's algorithm
    final x12 = (x1 + x2) / 2;
    final y12 = (y1 + y2) / 2;
    final x23 = (x2 + x3) / 2;
    final y23 = (y2 + y3) / 2;
    final x34 = (x3 + x4) / 2;
    final y34 = (y3 + y4) / 2;
    final x123 = (x12 + x23) / 2;
    final y123 = (y12 + y23) / 2;
    final x234 = (x23 + x34) / 2;
    final y234 = (y23 + y34) / 2;
    final x1234 = (x123 + x234) / 2;
    final y1234 = (y123 + y234) / 2;

    final dx = x4 - x1;
    final dy = y4 - y1;
    var d2 = ((x2 - x4) * dy - (y2 - y4) * dx).abs();
    var d3 = ((x3 - x4) * dy - (y3 - y4) * dx).abs();
    double da1;
    double da2;
    double k;

    final caseId = ((d2 > _curveCollinearityEpsilon) ? 2 : 0) |
        ((d3 > _curveCollinearityEpsilon) ? 1 : 0);

    switch (caseId) {
      case 0:
        k = dx * dx + dy * dy;
        if (k == 0) {
          d2 = _calcSqDistance(x1, y1, x2, y2);
          d3 = _calcSqDistance(x4, y4, x3, y3);
        } else {
          k = 1 / k;
          da1 = x2 - x1;
          da2 = y2 - y1;
          d2 = k * (da1 * dx + da2 * dy);
          da1 = x3 - x1;
          da2 = y3 - y1;
          d3 = k * (da1 * dx + da2 * dy);
          if (d2 > 0 && d2 < 1 && d3 > 0 && d3 < 1) {
            return;
          }
          if (d2 <= 0) {
            d2 = _calcSqDistance(x2, y2, x1, y1);
          } else if (d2 >= 1) {
            d2 = _calcSqDistance(x2, y2, x4, y4);
          } else {
            d2 = _calcSqDistance(x2, y2, x1 + d2 * dx, y1 + d2 * dy);
          }

          if (d3 <= 0) {
            d3 = _calcSqDistance(x3, y3, x1, y1);
          } else if (d3 >= 1) {
            d3 = _calcSqDistance(x3, y3, x4, y4);
          } else {
            d3 = _calcSqDistance(x3, y3, x1 + d3 * dx, y1 + d3 * dy);
          }
        }
        if (d2 > d3) {
          if (d2 < distanceToleranceSquare) {
            _addVertex(VertexData(FlagsAndCommand.commandLineTo, x2, y2));
            return;
          }
        } else {
          if (d3 < distanceToleranceSquare) {
            _addVertex(VertexData(FlagsAndCommand.commandLineTo, x3, y3));
            return;
          }
        }
        break;

      case 1:
        if (d3 * d3 <= distanceToleranceSquare * (dx * dx + dy * dy)) {
          if (_angleTolerance < _curveAngleToleranceEpsilon) {
            _addVertex(VertexData(FlagsAndCommand.commandLineTo, x23, y23));
            return;
          }

          da1 = (math.atan2(y4 - y3, x4 - x3) -
                  math.atan2(y3 - y2, x3 - x2))
              .abs();
          if (da1 >= math.pi) da1 = 2 * math.pi - da1;

          if (da1 < _angleTolerance) {
            _addVertex(VertexData(FlagsAndCommand.commandLineTo, x2, y2));
            _addVertex(VertexData(FlagsAndCommand.commandLineTo, x3, y3));
            return;
          }

          if (_cuspLimit != 0.0 && da1 > _cuspLimit) {
            _addVertex(VertexData(FlagsAndCommand.commandLineTo, x3, y3));
            return;
          }
        }
        break;

      case 2:
        if (d2 * d2 <= distanceToleranceSquare * (dx * dx + dy * dy)) {
          if (_angleTolerance < _curveAngleToleranceEpsilon) {
            _addVertex(VertexData(FlagsAndCommand.commandLineTo, x23, y23));
            return;
          }

          da1 = (math.atan2(y3 - y2, x3 - x2) -
                  math.atan2(y2 - y1, x2 - x1))
              .abs();
          if (da1 >= math.pi) da1 = 2 * math.pi - da1;

          if (da1 < _angleTolerance) {
            _addVertex(VertexData(FlagsAndCommand.commandLineTo, x2, y2));
            _addVertex(VertexData(FlagsAndCommand.commandLineTo, x3, y3));
            return;
          }

          if (_cuspLimit != 0.0 && da1 > _cuspLimit) {
            _addVertex(VertexData(FlagsAndCommand.commandLineTo, x2, y2));
            return;
          }
        }
        break;

      case 3:
        if ((d2 + d3) * (d2 + d3) <=
            distanceToleranceSquare * (dx * dx + dy * dy)) {
          if (_angleTolerance < _curveAngleToleranceEpsilon) {
            _addVertex(VertexData(FlagsAndCommand.commandLineTo, x23, y23));
            return;
          }

          k = math.atan2(y3 - y2, x3 - x2);
          da1 = (k - math.atan2(y2 - y1, x2 - x1)).abs();
          da2 = (math.atan2(y4 - y3, x4 - x3) - k).abs();
          if (da1 >= math.pi) da1 = 2 * math.pi - da1;
          if (da2 >= math.pi) da2 = 2 * math.pi - da2;

          if (da1 + da2 < _angleTolerance) {
            _addVertex(VertexData(FlagsAndCommand.commandLineTo, x23, y23));
            return;
          }

          if (_cuspLimit != 0.0) {
            if (da1 > _cuspLimit) {
              _addVertex(VertexData(FlagsAndCommand.commandLineTo, x2, y2));
              return;
            }

            if (da2 > _cuspLimit) {
              _addVertex(VertexData(FlagsAndCommand.commandLineTo, x3, y3));
              return;
            }
          }
        }
        break;
    }

    _subdivideCubic(x1, y1, x12, y12, x123, y123, x1234, y1234, level + 1,
        distanceToleranceSquare);
    _subdivideCubic(x1234, y1234, x234, y234, x34, y34, x4, y4, level + 1,
        distanceToleranceSquare);
  }
}

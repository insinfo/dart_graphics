
//
// Extension methods for IVertexSource providing utility operations like
// bounds calculation, point interpolation, and coordinate transformations.

import 'dart:math' as math;
import '../primitives/rectangle_double.dart';
import '../transform/affine.dart';
import 'vertex_storage.dart';
import 'ivertex_source.dart';
import 'path_commands.dart';

/// Extension methods for IVertexSource
extension IVertexSourceExtensions on IVertexSource {
  /// Gets the bounding rectangle that contains all vertices in the source.
  RectangleDouble getBounds() {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;
    bool hasVertices = false;

    for (final vertex in vertices()) {
      if (!vertex.isClose && !vertex.isStop) {
        hasVertices = true;
        if (vertex.x < minX) minX = vertex.x;
        if (vertex.y < minY) minY = vertex.y;
        if (vertex.x > maxX) maxX = vertex.x;
        if (vertex.y > maxY) maxY = vertex.y;
      }
    }

    if (!hasVertices) {
      return RectangleDouble(0, 0, 0, 0);
    }

    return RectangleDouble(minX, minY, maxX, maxY);
  }

  /// Gets the point at a specified ratio along the total path length.
  /// [ratio] must be between 0 and 1 inclusive.
  /// Returns the interpolated position at that ratio of the total path length.
  ({double x, double y}) getPointAtRatio(double ratio) {
    if (ratio < 0 || ratio > 1) {
      throw ArgumentError.value(
          ratio, 'ratio', 'Ratio must be between 0 and 1 inclusive.');
    }

    double totalLength = 0;
    double lastX = 0, lastY = 0;

    // Compute the total length of the path.
    for (final vertex in vertices()) {
      if (!vertex.isClose && !vertex.isStop) {
        final dx = lastX - vertex.x;
        final dy = lastY - vertex.y;
        totalLength += math.sqrt(dx * dx + dy * dy);
        lastX = vertex.x;
        lastY = vertex.y;
      }
    }

    final double targetLength = totalLength * ratio;
    double accumulatedLength = 0;
    double prevX = 0, prevY = 0;

    // Walk the path again and stop when the accumulated length matches the target.
    for (final vertex in vertices()) {
      if (!vertex.isClose && !vertex.isStop) {
        final dx = prevX - vertex.x;
        final dy = prevY - vertex.y;
        final double segmentLength = math.sqrt(dx * dx + dy * dy);
        if (accumulatedLength + segmentLength >= targetLength) {
          // Interpolate between the two points to get the exact position.
          final double remainingLength = targetLength - accumulatedLength;
          final double segmentRatio =
              segmentLength > 0 ? remainingLength / segmentLength : 0;
          return (
            x: prevX + (vertex.x - prevX) * segmentRatio,
            y: prevY + (vertex.y - prevY) * segmentRatio,
          );
        }

        accumulatedLength += segmentLength;
        prevX = vertex.x;
        prevY = vertex.y;
      }
    }

    // If for some reason we get here, return the last vertex.
    return (x: lastX, y: lastY);
  }

  /// Gets the X coordinate at a given Y coordinate by interpolating
  /// between vertices. Useful for finding path intersections.
  double getXAtY(double y) {
    double? prevX, prevY;
    double highestX = double.negativeInfinity;
    double highestY = double.negativeInfinity;
    double lowestX = double.infinity;
    double lowestY = double.infinity;

    for (final vertex in vertices()) {
      if (prevX != null && prevY != null && vertex.isVertex && vertex.isLineTo) {
        if ((y >= prevY && y <= vertex.y) || (y <= prevY && y >= vertex.y)) {
          if (prevY == vertex.y) {
            return prevX;
          }

          final deltaFromPrevious = y - prevY;
          final segmentYLength = vertex.y - prevY;
          final ratioOfLength = deltaFromPrevious / segmentYLength;
          final segmentXLength = vertex.x - prevX;
          return prevX + ratioOfLength * segmentXLength;
        }
      }

      if (!vertex.isClose && !vertex.isStop) {
        if (vertex.y > highestY) {
          highestX = vertex.x;
          highestY = vertex.y;
        }
        if (vertex.y < lowestY) {
          lowestX = vertex.x;
          lowestY = vertex.y;
        }
        prevX = vertex.x;
        prevY = vertex.y;
      }
    }

    if (y < lowestY) return lowestX;
    return highestX;
  }

  /// Gets the hint for a command at a specific vertex index.
  /// Useful for understanding curve control point roles.
  CommandHint getCommandHint(int pointIndex) {
    var iterationIndex = 0;
    var curveIndex = 0;
    FlagsAndCommand? lastCommand;
    var commandHint = CommandHint.none;

    for (final vertex in vertices()) {
      if (lastCommand == null || lastCommand != vertex.command) {
        curveIndex = 0;
        lastCommand = vertex.command;
      }

      commandHint = CommandHint.none;

      if (vertex.isCurve4) {
        switch (curveIndex) {
          case 0:
            commandHint = CommandHint.c4Cp1x; // First control point
            curveIndex++;
          case 1:
            commandHint = CommandHint.c4Cp2x; // Second control point
            curveIndex++;
          case 2:
            commandHint = CommandHint.none; // End point
            curveIndex = 0;
          default:
            throw Exception('Invalid curve index');
        }
      } else if (vertex.isCurve3) {
        switch (curveIndex) {
          case 0:
            commandHint = CommandHint.c3Cpx; // Control point
            curveIndex++;
          case 1:
            commandHint = CommandHint.none; // End point
            curveIndex = 0;
          default:
            throw Exception('Invalid curve index');
        }
      }

      if (iterationIndex == pointIndex) {
        return commandHint;
      }

      iterationIndex++;
    }

    return commandHint;
  }

  /// Transforms all vertices using an Affine transformation.
  /// Returns a new VertexStorage with the transformed vertices.
  VertexStorage transformAffine(Affine matrix) {
    final output = VertexStorage();
    for (final vertex in vertices()) {
      final x = vertex.x;
      final y = vertex.y;
      final tx = x * matrix.sx + y * matrix.shx + matrix.tx;
      final ty = x * matrix.shy + y * matrix.sy + matrix.ty;
      output.addVertex(tx, ty, vertex.command);
    }
    return output;
  }
}

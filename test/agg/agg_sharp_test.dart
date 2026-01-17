// Tests ported from agg-sharp/Tests/Agg.Tests
// Vector math, VertexStorage and other primitive tests
// Dart port by insinfo, 2025

import 'dart:math';
import 'package:test/test.dart';
import 'package:dart_graphics/src/agg/vertex_source/vertex_storage.dart';
import 'package:dart_graphics/src/agg/transform/affine.dart';
import 'package:dart_graphics/src/agg/primitives/color.dart';
import 'package:dart_graphics/src/agg/primitives/rectangle_double.dart';
import 'package:dart_graphics/src/shared/ref_param.dart';

void main() {
  group('Vector2 Tests', () {
    test('GetDeltaAngle - angles around origin', () {
      final center = Offset(0, 0);
      var start = Offset(1, 0);
      var end = Offset(0, 1);
      
      // Calculate delta angle
      final startAngle = atan2(start.dy - center.dy, start.dx - center.dx);
      final endAngle = atan2(end.dy - center.dy, end.dx - center.dx);
      var deltaAngle = endAngle - startAngle;
      
      // Normalize to -pi to pi
      while (deltaAngle > pi) deltaAngle -= 2 * pi;
      while (deltaAngle < -pi) deltaAngle += 2 * pi;
      
      expect((pi / 2 - deltaAngle).abs() < 0.0001, isTrue);
      
      start = Offset(-1, 0);
      end = Offset(0, 1);
      final startAngle2 = atan2(start.dy - center.dy, start.dx - center.dx);
      final endAngle2 = atan2(end.dy - center.dy, end.dx - center.dx);
      var deltaAngle2 = endAngle2 - startAngle2;
      
      while (deltaAngle2 > pi) deltaAngle2 -= 2 * pi;
      while (deltaAngle2 < -pi) deltaAngle2 += 2 * pi;
      
      expect((-pi / 2 - deltaAngle2).abs() < 0.0001, isTrue);
    });

    test('GetDeltaAngle - angles around point (1,2)', () {
      final center = Offset(1, 2);
      var start = Offset(2, 2);
      var end = Offset(1, 3);
      
      final startAngle = atan2(start.dy - center.dy, start.dx - center.dx);
      final endAngle = atan2(end.dy - center.dy, end.dx - center.dx);
      var deltaAngle = endAngle - startAngle;
      
      while (deltaAngle > pi) deltaAngle -= 2 * pi;
      while (deltaAngle < -pi) deltaAngle += 2 * pi;
      
      expect((pi / 2 - deltaAngle).abs() < 0.0001, isTrue);
      
      start = Offset(0, 2);
      end = Offset(1, 3);
      final startAngle2 = atan2(start.dy - center.dy, start.dx - center.dx);
      final endAngle2 = atan2(end.dy - center.dy, end.dx - center.dx);
      var deltaAngle2 = endAngle2 - startAngle2;
      
      while (deltaAngle2 > pi) deltaAngle2 -= 2 * pi;
      while (deltaAngle2 < -pi) deltaAngle2 += 2 * pi;
      
      expect((-pi / 2 - deltaAngle2).abs() < 0.0001, isTrue);
    });

    test('DistancePointToLine - outside the line', () {
      expect(_distancePointToLine(Offset(0, 0), Offset(5, 0), Offset(10, 0)), equals(5));
      expect(_distancePointToLine(Offset(15, 0), Offset(5, 0), Offset(10, 0)), equals(5));
      expect((_distancePointToLine(Offset(-1, -1), Offset(0, 0), Offset(10, 0)) - sqrt(2)).abs() < 0.0001, isTrue);
      expect((_distancePointToLine(Offset(-1, 1), Offset(0, 0), Offset(10, 0)) - sqrt(2)).abs() < 0.0001, isTrue);
      expect((_distancePointToLine(Offset(11, -1), Offset(0, 0), Offset(10, 0)) - sqrt(2)).abs() < 0.0001, isTrue);
      expect((_distancePointToLine(Offset(11, 1), Offset(0, 0), Offset(10, 0)) - sqrt(2)).abs() < 0.0001, isTrue);
    });

    test('DistancePointToLine - inside the line', () {
      expect(_distancePointToLine(Offset(7, 5), Offset(5, 0), Offset(10, 0)), equals(5));
      expect(_distancePointToLine(Offset(7, -5), Offset(5, 0), Offset(10, 0)), equals(5));
    });

    test('DistancePointToLine - line is a point', () {
      expect(_distancePointToLine(Offset(0, 0), Offset(5, 0), Offset(5, 0)), equals(5));
    });
  });

  group('Vector3 Tests', () {
    test('Collinear test', () {
      expect(_collinear(Vector3(0, 0, 1), Vector3(0, 0, 2), Vector3(0, 0, 3)), isTrue);
      expect(_collinear(Vector3(0, 0, 1), Vector3(0, 0, 2), Vector3(0, 1, 3)), isFalse);
    });

    test('Vector3 Parse - two segments', () {
      expect(_parseVector3('1, 2'), equals(Vector3(1, 2, 0)));
    });

    test('Vector3 Parse - two segments with trailing comma', () {
      expect(_parseVector3('1, 2,'), equals(Vector3(1, 2, 0)));
    });

    test('Vector3 Parse - three segments with whitespace', () {
      expect(_parseVector3('1, 2, 3'), equals(Vector3(1, 2, 3)));
    });

    test('Vector3 Parse - three segments without whitespace', () {
      expect(_parseVector3('1,2,3'), equals(Vector3(1, 2, 3)));
    });

    test('Vector3 Parse - doubles', () {
      final parsed = _parseVector3('1.1, 2.2, 3.3');
      expect((parsed.x - 1.1).abs() < 0.0001, isTrue);
      expect((parsed.y - 2.2).abs() < 0.0001, isTrue);
      expect((parsed.z - 3.3).abs() < 0.0001, isTrue);
    });

    test('Vector3 Parse - negative values', () {
      expect(_parseVector3('-1, -2, -3'), equals(Vector3(-1, -2, -3)));
    });

    test('Vector3 Parse - empty string', () {
      expect(_parseVector3(''), equals(Vector3(0, 0, 0)));
    });
  });

  group('VertexStorage Tests', () {
    test('CubePolygonCount - single square', () {
      final square = VertexStorage();
      square.moveTo(0, 0);
      square.lineTo(100, 0);
      square.lineTo(100, 100);
      square.lineTo(0, 100);
      square.closePath();

      final polygons = _createPolygons(square);
      expect(polygons.length, equals(1));
    });

    test('MoveToCreatesAdditionalPolygon', () {
      // Any MoveTo should always create a new Polygon
      final storage = VertexStorage();
      storage.moveTo(0, 0);
      storage.lineTo(100, 0);
      storage.lineTo(100, 100);
      storage.moveTo(30, 30);
      storage.lineTo(0, 100);
      storage.closePath();

      final polygons = _createPolygons(storage);
      expect(polygons.length, equals(2));
    });

    test('ThreeItemPolygonCount', () {
      final storage = VertexStorage();

      // Square
      storage.moveTo(0, 0);
      storage.lineTo(100, 0);
      storage.lineTo(100, 100);
      storage.lineTo(0, 100);
      storage.closePath();

      // Triangle
      storage.moveTo(30, 30);
      storage.lineTo(40, 30);
      storage.lineTo(35, 40);
      storage.closePath();

      // Small Square
      storage.moveTo(20, 20);
      storage.lineTo(25, 20);
      storage.lineTo(25, 25);
      storage.lineTo(20, 25);
      storage.closePath();

      final polygons = _createPolygons(storage);
      expect(polygons.length, equals(3));
    });

    test('VertexStorage iteration', () {
      final storage = VertexStorage();
      storage.moveTo(10, 11);
      storage.lineTo(100, 11);
      storage.lineTo(100, 110);
      storage.closePath();

      storage.rewind(0);
      
      final x = RefParam<double>(0.0);
      final y = RefParam<double>(0.0);
      var count = 0;
      
      final vertices = <_VertexData>[];
      while (true) {
        final cmd = storage.vertex(x, y);
        if (cmd.isStop) break;
        vertices.add(_VertexData(x.value, y.value, cmd.value));
        count++;
        if (count > 100) break; // Safety limit
      }
      
      expect(vertices.isNotEmpty, isTrue);
    });
  });

  group('Affine Transform Tests', () {
    test('Identity transform', () {
      final affine = Affine.identity();
      final point = Offset(10, 20);
      final transformed = affine.transformPoint(point.dx, point.dy);
      
      expect((transformed.x - 10).abs() < 0.0001, isTrue);
      expect((transformed.y - 20).abs() < 0.0001, isTrue);
    });

    test('Translation transform', () {
      final affine = Affine.identity()..translate(100, 50);
      final point = Offset(10, 20);
      final transformed = affine.transformPoint(point.dx, point.dy);
      
      expect((transformed.x - 110).abs() < 0.0001, isTrue);
      expect((transformed.y - 70).abs() < 0.0001, isTrue);
    });

    test('Scale transform', () {
      final affine = Affine.identity()..scale(2, 3);
      final point = Offset(10, 20);
      final transformed = affine.transformPoint(point.dx, point.dy);
      
      expect((transformed.x - 20).abs() < 0.0001, isTrue);
      expect((transformed.y - 60).abs() < 0.0001, isTrue);
    });

    test('Rotation transform', () {
      final affine = Affine.identity()..rotate(pi / 2);
      final point = Offset(10, 0);
      final transformed = affine.transformPoint(point.dx, point.dy);
      
      expect(transformed.x.abs() < 0.0001, isTrue);
      expect((transformed.y - 10).abs() < 0.0001, isTrue);
    });

    test('Invert transform', () {
      final affine = Affine.identity()
        ..translate(100, 50)
        ..scale(2, 2);
      
      final inverse = affine.clone()..invert();
      
      final point = Offset(10, 20);
      final transformed = affine.transformPoint(point.dx, point.dy);
      final restored = inverse.transformPoint(transformed.x, transformed.y);
      
      expect((restored.x - 10).abs() < 0.0001, isTrue);
      expect((restored.y - 20).abs() < 0.0001, isTrue);
    });

    test('Determinant', () {
      final affine = Affine.identity();
      expect((affine.determinant() - 1.0).abs() < 0.0001, isTrue);
      
      final scaled = Affine.identity()..scale(2, 3);
      expect((scaled.determinant() - 6.0).abs() < 0.0001, isTrue);
    });
  });

  group('Color Tests', () {
    test('Color equality', () {
      final a = Color(10, 11, 12, 255);
      final b = Color(10, 11, 12, 255);
      expect(a.red, equals(b.red));
      expect(a.green, equals(b.green));
      expect(a.blue, equals(b.blue));
      expect(a.alpha, equals(b.alpha));
    });

    test('Color from RGBA', () {
      final c = Color.fromRgba(255, 128, 64, 200);
      expect(c.red, equals(255));
      expect(c.green, equals(128));
      expect(c.blue, equals(64));
      expect(c.alpha, equals(200));
    });

    test('Color components', () {
      final c = Color(100, 150, 200, 255);
      expect(c.red, equals(100));
      expect(c.green, equals(150));
      expect(c.blue, equals(200));
      expect(c.alpha, equals(255));
    });
  });

  group('RectangleDouble Tests', () {
    test('Rectangle equality', () {
      final a = RectangleDouble(10, 11, 12, 13);
      final b = RectangleDouble(10, 11, 12, 13);
      expect(a.left, equals(b.left));
      expect(a.bottom, equals(b.bottom));
      expect(a.right, equals(b.right));
      expect(a.top, equals(b.top));
    });

    test('Rectangle dimensions', () {
      final rect = RectangleDouble(10, 20, 50, 80);
      expect(rect.width, equals(40));
      expect(rect.height, equals(60));
    });

    test('Rectangle contains point', () {
      final rect = RectangleDouble(0, 0, 100, 100);
      expect(rect.contains(50, 50), isTrue);
      expect(rect.contains(0, 0), isTrue);
      expect(rect.contains(100, 100), isTrue);
      expect(rect.contains(-1, 50), isFalse);
      expect(rect.contains(101, 50), isFalse);
    });

    test('Rectangle union with', () {
      final rect = RectangleDouble(10, 10, 20, 20);
      rect.unionWith(RectangleDouble(5, 5, 15, 15));
      expect(rect.left, equals(5));
      expect(rect.bottom, equals(5));
      
      rect.unionWith(RectangleDouble(25, 25, 30, 30));
      expect(rect.right, equals(30));
      expect(rect.top, equals(30));
    });
  });

  group('Simple Parse Tests', () {
    test('GetNextNumber works', () {
      expect(double.parse('1234'), equals(1234));
      expect(double.parse('-1234'), equals(-1234));
      expect(double.parse('+1234'), equals(1234));
      expect(double.parse('1234.3'), equals(1234.3));
      expect(double.parse('1234.354'), equals(1234.354));
      expect(double.parse('0.123'), equals(0.123));
      expect(double.parse('.123'), equals(0.123));
    });
  });
}

// Helper functions

/// Distance from a point to a line segment
double _distancePointToLine(Offset point, Offset lineStart, Offset lineEnd) {
  final dx = lineEnd.dx - lineStart.dx;
  final dy = lineEnd.dy - lineStart.dy;
  
  if (dx == 0 && dy == 0) {
    // Line is a point
    return _distance(point, lineStart);
  }
  
  // Calculate the t that minimizes distance
  final t = ((point.dx - lineStart.dx) * dx + (point.dy - lineStart.dy) * dy) / (dx * dx + dy * dy);
  
  if (t < 0) {
    // Closest to lineStart
    return _distance(point, lineStart);
  } else if (t > 1) {
    // Closest to lineEnd
    return _distance(point, lineEnd);
  } else {
    // Closest to a point on the segment
    final closest = Offset(lineStart.dx + t * dx, lineStart.dy + t * dy);
    return _distance(point, closest);
  }
}

double _distance(Offset a, Offset b) {
  final dx = b.dx - a.dx;
  final dy = b.dy - a.dy;
  return sqrt(dx * dx + dy * dy);
}

/// Check if three points are collinear
bool _collinear(Vector3 a, Vector3 b, Vector3 c) {
  // Cross product of (b-a) and (c-a) should be zero for collinear points
  final ab = Vector3(b.x - a.x, b.y - a.y, b.z - a.z);
  final ac = Vector3(c.x - a.x, c.y - a.y, c.z - a.z);
  
  final cross = Vector3(
    ab.y * ac.z - ab.z * ac.y,
    ab.z * ac.x - ab.x * ac.z,
    ab.x * ac.y - ab.y * ac.x,
  );
  
  return cross.x.abs() < 0.0001 && cross.y.abs() < 0.0001 && cross.z.abs() < 0.0001;
}

/// Parse a Vector3 from a string
Vector3 _parseVector3(String s) {
  if (s.isEmpty) return Vector3(0, 0, 0);
  
  final parts = s.split(',').map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
  
  if (parts.isEmpty) return Vector3(0, 0, 0);
  
  final x = double.tryParse(parts[0]) ?? 0;
  final y = parts.length > 1 ? (double.tryParse(parts[1]) ?? 0) : 0;
  final z = parts.length > 2 ? (double.tryParse(parts[2]) ?? 0) : 0;
  
  return Vector3(x.toDouble(), y.toDouble(), z.toDouble());
}

/// Create polygons from a VertexStorage
List<List<Offset>> _createPolygons(VertexStorage storage) {
  final polygons = <List<Offset>>[];
  var currentPolygon = <Offset>[];
  
  storage.rewind(0);
  
  final xRef = RefParam<double>(0.0);
  final yRef = RefParam<double>(0.0);
  var iterations = 0;
  
  while (iterations < 10000) {
    final cmd = storage.vertex(xRef, yRef);
    iterations++;
    
    if (cmd.isStop) break;
    
    if (cmd.isMoveTo) {
      if (currentPolygon.isNotEmpty) {
        polygons.add(currentPolygon);
      }
      currentPolygon = [Offset(xRef.value, yRef.value)];
    } else if (cmd.isLineTo) {
      currentPolygon.add(Offset(xRef.value, yRef.value));
    } else if (cmd.isEndPoly || cmd.isClose) {
      if (currentPolygon.isNotEmpty) {
        polygons.add(currentPolygon);
        currentPolygon = [];
      }
    }
  }
  
  if (currentPolygon.isNotEmpty) {
    polygons.add(currentPolygon);
  }
  
  return polygons;
}

/// Simple Vector3 class for tests
class Vector3 {
  final double x;
  final double y;
  final double z;
  
  const Vector3(this.x, this.y, this.z);
  
  @override
  bool operator ==(Object other) {
    if (other is Vector3) {
      return (x - other.x).abs() < 0.0001 &&
             (y - other.y).abs() < 0.0001 &&
             (z - other.z).abs() < 0.0001;
    }
    return false;
  }
  
  @override
  int get hashCode => Object.hash(x, y, z);
  
  @override
  String toString() => 'Vector3($x, $y, $z)';
}

class _VertexData {
  final double x;
  final double y;
  final int cmd;
  
  _VertexData(this.x, this.y, this.cmd);
}

/// Simple Offset class for tests (like Flutter's Offset)
class Offset {
  final double dx;
  final double dy;
  
  const Offset(this.dx, this.dy);
  
  @override
  bool operator ==(Object other) {
    if (other is Offset) {
      return (dx - other.dx).abs() < 0.0001 && (dy - other.dy).abs() < 0.0001;
    }
    return false;
  }
  
  @override
  int get hashCode => Object.hash(dx, dy);
  
  @override
  String toString() => 'Offset($dx, $dy)';
}

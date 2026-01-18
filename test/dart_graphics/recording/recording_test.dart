import 'package:test/test.dart';
import 'package:dart_graphics/src/dart_graphics/recording/clip_stack.dart';
import 'package:dart_graphics/src/dart_graphics/recording/graphics_commands.dart';
import 'package:dart_graphics/src/dart_graphics/recording/layer_stack.dart';
import 'package:dart_graphics/src/dart_graphics/recording/path_utils.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/transform/affine.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/vertex_storage.dart';

class _Point {
  final double x;
  final double y;
  const _Point(this.x, this.y);
}

VertexStorage _rect(double x1, double y1, double x2, double y2) {
  final path = VertexStorage();
  path.moveTo(x1, y1);
  path.lineTo(x2, y1);
  path.lineTo(x2, y2);
  path.lineTo(x1, y2);
  path.closePath();
  return path;
}

double _polygonArea(List<_Point> pts) {
  if (pts.length < 3) return 0.0;
  var area = 0.0;
  for (var i = 0; i < pts.length; i++) {
    final a = pts[i];
    final b = pts[(i + 1) % pts.length];
    area += (a.x * b.y) - (b.x * a.y);
  }
  return area.abs() * 0.5;
}

double _areaOfPath(VertexStorage path) {
  final contours = <List<_Point>>[];
  var current = <_Point>[];

  void flush() {
    if (current.isNotEmpty) {
      contours.add(List<_Point>.from(current));
      current.clear();
    }
  }

  for (final v in path.vertices()) {
    if (v.command.isStop) break;
    if (v.command.isMoveTo) {
      flush();
      current.add(_Point(v.x, v.y));
      continue;
    }
    if (v.command.isLineTo) {
      current.add(_Point(v.x, v.y));
      continue;
    }
    if (v.command.isEndPoly) {
      flush();
      continue;
    }
  }
  flush();

  var total = 0.0;
  for (final contour in contours) {
    total += _polygonArea(contour);
  }
  return total;
}

void main() {
  group('PathUtils boolean ops', () {
    test('union/intersection/difference areas', () {
      final a = _rect(0, 0, 10, 10);
      final b = _rect(5, 0, 15, 10);

      final union = PathUtils.union(a, b, tolerance: 0.25, scale: 1024.0);
      final inter = PathUtils.intersection(a, b, tolerance: 0.25, scale: 1024.0);
      final diff = PathUtils.difference(a, b, tolerance: 0.25, scale: 1024.0);

      expect(_areaOfPath(union), closeTo(150.0, 1e-3));
      expect(_areaOfPath(inter), closeTo(50.0, 1e-3));
      expect(_areaOfPath(diff), closeTo(50.0, 1e-3));
    });

    test('flattenAdaptive removes curves', () {
      final path = VertexStorage();
      path.moveTo(0, 0);
      path.curve3(40, 80, 80, 0);
      path.curve4(100, 50, 140, 50, 180, 0);
      path.closePath();

      final flat = PathUtils.flattenAdaptive(path, tolerance: 0.5);
      for (final v in flat.vertices()) {
        expect(v.command.isCurve3, isFalse);
        expect(v.command.isCurve4, isFalse);
      }
    });
  });

  group('ClipStack', () {
    test('save/restore retains previous entries', () {
      final stack = ClipStack();
      stack.push(_rect(0, 0, 10, 10));
      stack.save();
      stack.push(_rect(0, 0, 5, 5));

      final removed = stack.restore();
      expect(removed, 1);
      expect(stack.length, 1);
      expect(stack.peekPath(), isNotNull);
    });
  });

  group('LayerStack', () {
    test('save/restore removes pushed layers', () {
      final layers = LayerStack();
      layers.push(const Layer(opacity: 0.8));
      layers.save();
      layers.push(const Layer(opacity: 0.4));

      final removed = layers.restore();
      expect(removed, 1);
      expect(layers.length, 1);
    });
  });

  group('CommandBuffer', () {
    test('optimize removes unused save/restore blocks', () {
      final buffer = CommandBuffer();
      buffer.save();
      buffer.setTransform(Affine.translation(10, 0));
      buffer.restore();

      final removed = buffer.optimize();
      expect(removed, 3);
      expect(buffer.isEmpty, isTrue);
    });

    test('optimize preserves draw operations', () {
      final buffer = CommandBuffer();
      final path = _rect(0, 0, 10, 10);
      buffer.save();
      buffer.setTransform(Affine.translation(5, 0));
      buffer.drawPath(path, SolidPaint(Color(255, 0, 0)));
      buffer.restore();

      final removed = buffer.optimize();
      expect(removed, 0);
      expect(buffer.length, 4);
    });

    test('clipPath records current transform', () {
      final buffer = CommandBuffer();
      final path = _rect(0, 0, 10, 10);
      buffer.setTransform(Affine.translation(12, 8));
      buffer.clipPath(path);

      final clipCommand = buffer.commands.last as ClipPathCommand;
      expect(clipCommand.transform, isNotNull);
      expect(clipCommand.transform!.tx, closeTo(12.0, 1e-9));
      expect(clipCommand.transform!.ty, closeTo(8.0, 1e-9));
    });
  });
}

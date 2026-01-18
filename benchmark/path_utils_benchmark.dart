/// PathUtils Benchmark
///
/// Focuses on path flattening, simplification, and boolean operations.
/// Run with: dart run benchmark/path_utils_benchmark.dart
/// Or with AOT: dart run benchmark_harness:bench --flavor aot --target benchmark/path_utils_benchmark.dart

import 'dart:math' as math;

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dart_graphics/src/dart_graphics/recording/path_utils.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/vertex_storage.dart';

const int iterations = 200;

VertexStorage _makeStar({double cx = 0, double cy = 0, double r1 = 80, double r2 = 35, int points = 5}) {
  final path = VertexStorage();
  final step = math.pi / points;
  for (var i = 0; i < points * 2; i++) {
    final r = (i % 2 == 0) ? r1 : r2;
    final angle = -math.pi / 2 + i * step;
    final x = cx + r * math.cos(angle);
    final y = cy + r * math.sin(angle);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  path.closePath();
  return path;
}

VertexStorage _makeCirclePolygon({double cx = 0, double cy = 0, double r = 70, int segments = 64}) {
  final path = VertexStorage();
  for (var i = 0; i < segments; i++) {
    final angle = (i / segments) * math.pi * 2;
    final x = cx + r * math.cos(angle);
    final y = cy + r * math.sin(angle);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  path.closePath();
  return path;
}

class FlattenAdaptiveBenchmark extends BenchmarkBase {
  late VertexStorage path;

  FlattenAdaptiveBenchmark() : super('PathUtils.flattenAdaptive');

  @override
  void setup() {
    path = _makeStar(cx: 10, cy: 5, r1: 120, r2: 48, points: 7);
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      PathUtils.flattenAdaptive(path, tolerance: 0.35);
    }
  }
}

class SimplifyBenchmark extends BenchmarkBase {
  late VertexStorage path;

  SimplifyBenchmark() : super('PathUtils.simplify');

  @override
  void setup() {
    path = _makeCirclePolygon(cx: 0, cy: 0, r: 90, segments: 180);
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      PathUtils.simplify(path, tolerance: 0.3, approximationScale: 1.0);
    }
  }
}

class BooleanUnionBenchmark extends BenchmarkBase {
  late VertexStorage a;
  late VertexStorage b;

  BooleanUnionBenchmark() : super('PathUtils.boolean.union');

  @override
  void setup() {
    a = _makeCirclePolygon(cx: -25, cy: 0, r: 90, segments: 96);
    b = _makeStar(cx: 30, cy: 0, r1: 85, r2: 40, points: 6);
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      PathUtils.union(a, b, tolerance: 0.4, scale: 1024.0);
    }
  }
}

class BooleanIntersectionBenchmark extends BenchmarkBase {
  late VertexStorage a;
  late VertexStorage b;

  BooleanIntersectionBenchmark() : super('PathUtils.boolean.intersection');

  @override
  void setup() {
    a = _makeCirclePolygon(cx: -10, cy: 0, r: 80, segments: 96);
    b = _makeCirclePolygon(cx: 20, cy: 0, r: 80, segments: 96);
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      PathUtils.intersection(a, b, tolerance: 0.4, scale: 1024.0);
    }
  }
}

class BooleanDifferenceBenchmark extends BenchmarkBase {
  late VertexStorage a;
  late VertexStorage b;

  BooleanDifferenceBenchmark() : super('PathUtils.boolean.difference');

  @override
  void setup() {
    a = _makeCirclePolygon(cx: 0, cy: 0, r: 95, segments: 96);
    b = _makeStar(cx: 5, cy: 0, r1: 70, r2: 30, points: 7);
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      PathUtils.difference(a, b, tolerance: 0.4, scale: 1024.0);
    }
  }
}

void main() {
  FlattenAdaptiveBenchmark().report();
  SimplifyBenchmark().report();
  BooleanUnionBenchmark().report();
  BooleanIntersectionBenchmark().report();
  BooleanDifferenceBenchmark().report();
}

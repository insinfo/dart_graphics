/// Clipper Benchmark
///
/// Measures boolean operations in the embedded Clipper implementation.
/// Run with: dart run benchmark/clipper_benchmark.dart
/// Or with AOT: dart run benchmark_harness:bench --flavor aot --target benchmark/clipper_benchmark.dart

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dart_graphics/src/clipper/clipper.dart' as clipper;

const int iterations = 400;

clipper.Path64 _rect(int x1, int y1, int x2, int y2) {
  return [
    clipper.Point64(x1, y1),
    clipper.Point64(x2, y1),
    clipper.Point64(x2, y2),
    clipper.Point64(x1, y2),
  ];
}

class ClipperUnionBenchmark extends BenchmarkBase {
  late clipper.Paths64 subject;
  late clipper.Paths64 clip;

  ClipperUnionBenchmark() : super('Clipper.boolean.union');

  @override
  void setup() {
    subject = [_rect(0, 0, 100, 100)];
    clip = [_rect(50, 0, 150, 100)];
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      clipper.Clipper.booleanOp(
        clipType: clipper.ClipType.union,
        subject: subject,
        clip: clip,
        fillRule: clipper.FillRule.nonZero,
      );
    }
  }
}

class ClipperIntersectionBenchmark extends BenchmarkBase {
  late clipper.Paths64 subject;
  late clipper.Paths64 clip;

  ClipperIntersectionBenchmark() : super('Clipper.boolean.intersection');

  @override
  void setup() {
    subject = [_rect(0, 0, 100, 100)];
    clip = [_rect(50, 0, 150, 100)];
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      clipper.Clipper.booleanOp(
        clipType: clipper.ClipType.intersection,
        subject: subject,
        clip: clip,
        fillRule: clipper.FillRule.nonZero,
      );
    }
  }
}

class ClipperDifferenceBenchmark extends BenchmarkBase {
  late clipper.Paths64 subject;
  late clipper.Paths64 clip;

  ClipperDifferenceBenchmark() : super('Clipper.boolean.difference');

  @override
  void setup() {
    subject = [_rect(0, 0, 100, 100)];
    clip = [_rect(50, 0, 150, 100)];
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      clipper.Clipper.booleanOp(
        clipType: clipper.ClipType.difference,
        subject: subject,
        clip: clip,
        fillRule: clipper.FillRule.nonZero,
      );
    }
  }
}

void main() {
  ClipperUnionBenchmark().report();
  ClipperIntersectionBenchmark().report();
  ClipperDifferenceBenchmark().report();
}

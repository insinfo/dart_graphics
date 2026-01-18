/// Recording Benchmark
///
/// Focuses on CommandBuffer recording and optimize performance.
/// Run with: dart run benchmark/recording_benchmark.dart
/// Or with AOT: dart run benchmark_harness:bench --flavor aot --target benchmark/recording_benchmark.dart

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/recording/graphics_commands.dart';
import 'package:dart_graphics/src/dart_graphics/transform/affine.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/vertex_storage.dart';

const int iterations = 500;

VertexStorage _rect(double x1, double y1, double x2, double y2) {
  final path = VertexStorage();
  path.moveTo(x1, y1);
  path.lineTo(x2, y1);
  path.lineTo(x2, y2);
  path.lineTo(x1, y2);
  path.closePath();
  return path;
}

class CommandBufferRecordBenchmark extends BenchmarkBase {
  CommandBufferRecordBenchmark() : super('CommandBuffer.record');

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      final buffer = CommandBuffer();
      final path = _rect(0, 0, 10, 10);
      buffer.save();
      buffer.setTransform(Affine.translation(i.toDouble(), 0));
      buffer.drawPath(path, SolidPaint(Color(255, 0, 0)));
      buffer.restore();
    }
  }
}

class CommandBufferOptimizeNoDrawBenchmark extends BenchmarkBase {
  CommandBufferOptimizeNoDrawBenchmark() : super('CommandBuffer.optimize.noDraw');

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      final buffer = CommandBuffer();
      buffer.save();
      buffer.setTransform(Affine.translation(10, 0));
      buffer.restore();
      buffer.optimize();
    }
  }
}

class CommandBufferOptimizeWithDrawBenchmark extends BenchmarkBase {
  CommandBufferOptimizeWithDrawBenchmark() : super('CommandBuffer.optimize.withDraw');

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      final buffer = CommandBuffer();
      final path = _rect(0, 0, 10, 10);
      buffer.save();
      buffer.setTransform(Affine.translation(5, 0));
      buffer.drawPath(path, SolidPaint(Color(255, 0, 0)));
      buffer.restore();
      buffer.optimize();
    }
  }
}

void main() {
  CommandBufferRecordBenchmark().report();
  CommandBufferOptimizeNoDrawBenchmark().report();
  CommandBufferOptimizeWithDrawBenchmark().report();
}

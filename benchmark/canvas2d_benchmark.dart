/// Canvas 2D Benchmark
///
/// Compares performance of three Canvas 2D implementations:
/// - DartGraphics (Anti-Grain Geometry)
/// - Cairo
/// - Skia
///
/// Run with: dart run benchmark/canvas2d_benchmark.dart
/// Or with AOT: dart run benchmark_harness:bench --flavor aot --target benchmark/canvas2d_benchmark.dart

import 'dart:math' as math;

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dart_graphics/src/dart_graphics/canvas/canvas.dart' as DartGraphics;
import 'package:dart_graphics/cairo.dart' as cairo;
import 'package:dart_graphics/skia_canvas.dart' as skia;
import 'package:dart_graphics/src/shared/canvas2d/canvas2d.dart';

// ============================================================================
// Constants
// ============================================================================

const int canvasWidth = 800;
const int canvasHeight = 600;
const int iterations = 100;

// ============================================================================
// DartGraphics Benchmarks
// ============================================================================

class DartGraphicsFillRectBenchmark extends BenchmarkBase {
  late DartGraphics.DartGraphicsCanvas canvas;
  late ICanvasRenderingContext2D ctx;

  DartGraphicsFillRectBenchmark() : super('DartGraphics.fillRect');

  @override
  void setup() {
    canvas = DartGraphics.DartGraphicsCanvas(canvasWidth, canvasHeight);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.fillStyle = '#FF0000';
      ctx.fillRect(50.0 + i % 100, 50.0 + i % 100, 100, 80);
    }
  }

  @override
  void exercise() => run();
}

class DartGraphicsStrokeRectBenchmark extends BenchmarkBase {
  late DartGraphics.DartGraphicsCanvas canvas;
  late ICanvasRenderingContext2D ctx;

  DartGraphicsStrokeRectBenchmark() : super('DartGraphics.strokeRect');

  @override
  void setup() {
    canvas = DartGraphics.DartGraphicsCanvas(canvasWidth, canvasHeight);
    ctx = canvas.getContext('2d');
    ctx.lineWidth = 2;
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.strokeStyle = '#0000FF';
      ctx.strokeRect(50.0 + i % 100, 50.0 + i % 100, 100, 80);
    }
  }

  @override
  void exercise() => run();
}

class DartGraphicsArcBenchmark extends BenchmarkBase {
  late DartGraphics.DartGraphicsCanvas canvas;
  late ICanvasRenderingContext2D ctx;

  DartGraphicsArcBenchmark() : super('DartGraphics.arc');

  @override
  void setup() {
    canvas = DartGraphics.DartGraphicsCanvas(canvasWidth, canvasHeight);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.beginPath();
      ctx.arc(400, 300, 50 + (i % 50), 0, 2 * math.pi);
      ctx.fillStyle = '#00FF00';
      ctx.fill();
    }
  }

  @override
  void exercise() => run();
}

class DartGraphicsPathBenchmark extends BenchmarkBase {
  late DartGraphics.DartGraphicsCanvas canvas;
  late ICanvasRenderingContext2D ctx;

  DartGraphicsPathBenchmark() : super('DartGraphics.path');

  @override
  void setup() {
    canvas = DartGraphics.DartGraphicsCanvas(canvasWidth, canvasHeight);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.beginPath();
      ctx.moveTo(100 + i % 100, 100);
      ctx.lineTo(150 + i % 100, 200);
      ctx.lineTo(50 + i % 100, 200);
      ctx.closePath();
      ctx.fillStyle = '#FF00FF';
      ctx.fill();
    }
  }

  @override
  void exercise() => run();
}

class DartGraphicsTransformBenchmark extends BenchmarkBase {
  late DartGraphics.DartGraphicsCanvas canvas;
  late ICanvasRenderingContext2D ctx;

  DartGraphicsTransformBenchmark() : super('DartGraphics.transform');

  @override
  void setup() {
    canvas = DartGraphics.DartGraphicsCanvas(canvasWidth, canvasHeight);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.save();
      ctx.translate(400, 300);
      ctx.rotate(i * 0.1);
      ctx.scale(1.0 + i * 0.01, 1.0 + i * 0.01);
      ctx.fillStyle = '#FFFF00';
      ctx.fillRect(-25, -25, 50, 50);
      ctx.restore();
    }
  }

  @override
  void exercise() => run();
}

class DartGraphicsComplexSceneBenchmark extends BenchmarkBase {
  late DartGraphics.DartGraphicsCanvas canvas;
  late ICanvasRenderingContext2D ctx;

  DartGraphicsComplexSceneBenchmark() : super('DartGraphics.complexScene');

  @override
  void setup() {
    canvas = DartGraphics.DartGraphicsCanvas(canvasWidth, canvasHeight);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    // Clear
    ctx.fillStyle = 'white';
    ctx.fillRect(0, 0, canvasWidth.toDouble(), canvasHeight.toDouble());

    // Rectangles
    for (var i = 0; i < 20; i++) {
      ctx.fillStyle = '#FF0000';
      ctx.fillRect(50.0 + i * 30, 50, 25, 25);
    }

    // Circles
    for (var i = 0; i < 20; i++) {
      ctx.beginPath();
      ctx.arc(100 + i * 30, 150, 15, 0, 2 * math.pi);
      ctx.fillStyle = '#00FF00';
      ctx.fill();
    }

    // Triangles
    for (var i = 0; i < 20; i++) {
      ctx.beginPath();
      ctx.moveTo(100 + i * 30, 200);
      ctx.lineTo(115 + i * 30, 230);
      ctx.lineTo(85 + i * 30, 230);
      ctx.closePath();
      ctx.fillStyle = '#0000FF';
      ctx.fill();
    }

    // Lines with transforms
    for (var i = 0; i < 10; i++) {
      ctx.save();
      ctx.translate(400, 400);
      ctx.rotate(i * math.pi / 5);
      ctx.strokeStyle = '#FF00FF';
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.moveTo(0, 0);
      ctx.lineTo(100, 0);
      ctx.stroke();
      ctx.restore();
    }
  }

  @override
  void exercise() => run();
}

// ============================================================================
// Cairo Benchmarks
// ============================================================================

class CairoFillRectBenchmark extends BenchmarkBase {
  late cairo.Cairo cairoLib;
  late cairo.CairoHtmlCanvas canvas;
  late ICanvasRenderingContext2D ctx;

  CairoFillRectBenchmark() : super('Cairo.fillRect');

  @override
  void setup() {
    cairoLib = cairo.Cairo();
    canvas = cairo.CairoHtmlCanvas(canvasWidth, canvasHeight, cairo: cairoLib);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.fillStyle = '#FF0000';
      ctx.fillRect(50.0 + i % 100, 50.0 + i % 100, 100, 80);
    }
  }

  @override
  void exercise() => run();
}

class CairoStrokeRectBenchmark extends BenchmarkBase {
  late cairo.Cairo cairoLib;
  late cairo.CairoHtmlCanvas canvas;
  late ICanvasRenderingContext2D ctx;

  CairoStrokeRectBenchmark() : super('Cairo.strokeRect');

  @override
  void setup() {
    cairoLib = cairo.Cairo();
    canvas = cairo.CairoHtmlCanvas(canvasWidth, canvasHeight, cairo: cairoLib);
    ctx = canvas.getContext('2d');
    ctx.lineWidth = 2;
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.strokeStyle = '#0000FF';
      ctx.strokeRect(50.0 + i % 100, 50.0 + i % 100, 100, 80);
    }
  }

  @override
  void exercise() => run();
}

class CairoArcBenchmark extends BenchmarkBase {
  late cairo.Cairo cairoLib;
  late cairo.CairoHtmlCanvas canvas;
  late ICanvasRenderingContext2D ctx;

  CairoArcBenchmark() : super('Cairo.arc');

  @override
  void setup() {
    cairoLib = cairo.Cairo();
    canvas = cairo.CairoHtmlCanvas(canvasWidth, canvasHeight, cairo: cairoLib);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.beginPath();
      ctx.arc(400, 300, 50 + (i % 50), 0, 2 * math.pi);
      ctx.fillStyle = '#00FF00';
      ctx.fill();
    }
  }

  @override
  void exercise() => run();
}

class CairoPathBenchmark extends BenchmarkBase {
  late cairo.Cairo cairoLib;
  late cairo.CairoHtmlCanvas canvas;
  late ICanvasRenderingContext2D ctx;

  CairoPathBenchmark() : super('Cairo.path');

  @override
  void setup() {
    cairoLib = cairo.Cairo();
    canvas = cairo.CairoHtmlCanvas(canvasWidth, canvasHeight, cairo: cairoLib);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.beginPath();
      ctx.moveTo(100 + i % 100, 100);
      ctx.lineTo(150 + i % 100, 200);
      ctx.lineTo(50 + i % 100, 200);
      ctx.closePath();
      ctx.fillStyle = '#FF00FF';
      ctx.fill();
    }
  }

  @override
  void exercise() => run();
}

class CairoTransformBenchmark extends BenchmarkBase {
  late cairo.Cairo cairoLib;
  late cairo.CairoHtmlCanvas canvas;
  late ICanvasRenderingContext2D ctx;

  CairoTransformBenchmark() : super('Cairo.transform');

  @override
  void setup() {
    cairoLib = cairo.Cairo();
    canvas = cairo.CairoHtmlCanvas(canvasWidth, canvasHeight, cairo: cairoLib);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.save();
      ctx.translate(400, 300);
      ctx.rotate(i * 0.1);
      ctx.scale(1.0 + i * 0.01, 1.0 + i * 0.01);
      ctx.fillStyle = '#FFFF00';
      ctx.fillRect(-25, -25, 50, 50);
      ctx.restore();
    }
  }

  @override
  void exercise() => run();
}

class CairoComplexSceneBenchmark extends BenchmarkBase {
  late cairo.Cairo cairoLib;
  late cairo.CairoHtmlCanvas canvas;
  late ICanvasRenderingContext2D ctx;

  CairoComplexSceneBenchmark() : super('Cairo.complexScene');

  @override
  void setup() {
    cairoLib = cairo.Cairo();
    canvas = cairo.CairoHtmlCanvas(canvasWidth, canvasHeight, cairo: cairoLib);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    // Clear
    ctx.fillStyle = 'white';
    ctx.fillRect(0, 0, canvasWidth.toDouble(), canvasHeight.toDouble());

    // Rectangles
    for (var i = 0; i < 20; i++) {
      ctx.fillStyle = '#FF0000';
      ctx.fillRect(50.0 + i * 30, 50, 25, 25);
    }

    // Circles
    for (var i = 0; i < 20; i++) {
      ctx.beginPath();
      ctx.arc(100 + i * 30, 150, 15, 0, 2 * math.pi);
      ctx.fillStyle = '#00FF00';
      ctx.fill();
    }

    // Triangles
    for (var i = 0; i < 20; i++) {
      ctx.beginPath();
      ctx.moveTo(100 + i * 30, 200);
      ctx.lineTo(115 + i * 30, 230);
      ctx.lineTo(85 + i * 30, 230);
      ctx.closePath();
      ctx.fillStyle = '#0000FF';
      ctx.fill();
    }

    // Lines with transforms
    for (var i = 0; i < 10; i++) {
      ctx.save();
      ctx.translate(400, 400);
      ctx.rotate(i * math.pi / 5);
      ctx.strokeStyle = '#FF00FF';
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.moveTo(0, 0);
      ctx.lineTo(100, 0);
      ctx.stroke();
      ctx.restore();
    }
  }

  @override
  void exercise() => run();
}

// ============================================================================
// Skia Benchmarks
// ============================================================================

class SkiaFillRectBenchmark extends BenchmarkBase {
  late skia.Skia skiaLib;
  late skia.Canvas canvas;
  late ICanvasRenderingContext2D ctx;

  SkiaFillRectBenchmark() : super('Skia.fillRect');

  @override
  void setup() {
    skiaLib = skia.Skia();
    canvas = skia.Canvas(skiaLib, canvasWidth, canvasHeight);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.fillStyle = '#FF0000';
      ctx.fillRect(50.0 + i % 100, 50.0 + i % 100, 100, 80);
    }
  }

  @override
  void exercise() => run();
}

class SkiaStrokeRectBenchmark extends BenchmarkBase {
  late skia.Skia skiaLib;
  late skia.Canvas canvas;
  late ICanvasRenderingContext2D ctx;

  SkiaStrokeRectBenchmark() : super('Skia.strokeRect');

  @override
  void setup() {
    skiaLib = skia.Skia();
    canvas = skia.Canvas(skiaLib, canvasWidth, canvasHeight);
    ctx = canvas.getContext('2d');
    ctx.lineWidth = 2;
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.strokeStyle = '#0000FF';
      ctx.strokeRect(50.0 + i % 100, 50.0 + i % 100, 100, 80);
    }
  }

  @override
  void exercise() => run();
}

class SkiaArcBenchmark extends BenchmarkBase {
  late skia.Skia skiaLib;
  late skia.Canvas canvas;
  late ICanvasRenderingContext2D ctx;

  SkiaArcBenchmark() : super('Skia.arc');

  @override
  void setup() {
    skiaLib = skia.Skia();
    canvas = skia.Canvas(skiaLib, canvasWidth, canvasHeight);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.beginPath();
      ctx.arc(400, 300, 50 + (i % 50), 0, 2 * math.pi);
      ctx.fillStyle = '#00FF00';
      ctx.fill();
    }
  }

  @override
  void exercise() => run();
}

class SkiaPathBenchmark extends BenchmarkBase {
  late skia.Skia skiaLib;
  late skia.Canvas canvas;
  late ICanvasRenderingContext2D ctx;

  SkiaPathBenchmark() : super('Skia.path');

  @override
  void setup() {
    skiaLib = skia.Skia();
    canvas = skia.Canvas(skiaLib, canvasWidth, canvasHeight);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.beginPath();
      ctx.moveTo(100 + i % 100, 100);
      ctx.lineTo(150 + i % 100, 200);
      ctx.lineTo(50 + i % 100, 200);
      ctx.closePath();
      ctx.fillStyle = '#FF00FF';
      ctx.fill();
    }
  }

  @override
  void exercise() => run();
}

class SkiaTransformBenchmark extends BenchmarkBase {
  late skia.Skia skiaLib;
  late skia.Canvas canvas;
  late ICanvasRenderingContext2D ctx;

  SkiaTransformBenchmark() : super('Skia.transform');

  @override
  void setup() {
    skiaLib = skia.Skia();
    canvas = skia.Canvas(skiaLib, canvasWidth, canvasHeight);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    for (var i = 0; i < iterations; i++) {
      ctx.save();
      ctx.translate(400, 300);
      ctx.rotate(i * 0.1);
      ctx.scale(1.0 + i * 0.01, 1.0 + i * 0.01);
      ctx.fillStyle = '#FFFF00';
      ctx.fillRect(-25, -25, 50, 50);
      ctx.restore();
    }
  }

  @override
  void exercise() => run();
}

class SkiaComplexSceneBenchmark extends BenchmarkBase {
  late skia.Skia skiaLib;
  late skia.Canvas canvas;
  late ICanvasRenderingContext2D ctx;

  SkiaComplexSceneBenchmark() : super('Skia.complexScene');

  @override
  void setup() {
    skiaLib = skia.Skia();
    canvas = skia.Canvas(skiaLib, canvasWidth, canvasHeight);
    ctx = canvas.getContext('2d');
  }

  @override
  void run() {
    // Clear
    ctx.fillStyle = 'white';
    ctx.fillRect(0, 0, canvasWidth.toDouble(), canvasHeight.toDouble());

    // Rectangles
    for (var i = 0; i < 20; i++) {
      ctx.fillStyle = '#FF0000';
      ctx.fillRect(50.0 + i * 30, 50, 25, 25);
    }

    // Circles
    for (var i = 0; i < 20; i++) {
      ctx.beginPath();
      ctx.arc(100 + i * 30, 150, 15, 0, 2 * math.pi);
      ctx.fillStyle = '#00FF00';
      ctx.fill();
    }

    // Triangles
    for (var i = 0; i < 20; i++) {
      ctx.beginPath();
      ctx.moveTo(100 + i * 30, 200);
      ctx.lineTo(115 + i * 30, 230);
      ctx.lineTo(85 + i * 30, 230);
      ctx.closePath();
      ctx.fillStyle = '#0000FF';
      ctx.fill();
    }

    // Lines with transforms
    for (var i = 0; i < 10; i++) {
      ctx.save();
      ctx.translate(400, 400);
      ctx.rotate(i * math.pi / 5);
      ctx.strokeStyle = '#FF00FF';
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.moveTo(0, 0);
      ctx.lineTo(100, 0);
      ctx.stroke();
      ctx.restore();
    }
  }

  @override
  void exercise() => run();
}

// ============================================================================
// Main
// ============================================================================

void main() {
  print('=' * 70);
  print('Canvas 2D Benchmark - Comparing DartGraphics, Cairo, and Skia');
  print('=' * 70);
  print('Canvas size: ${canvasWidth}x$canvasHeight');
  print('Iterations per run: $iterations');
  print('=' * 70);
  print('');

  // Group benchmarks by operation
  final benchmarks = <String, List<BenchmarkBase>>{
    'fillRect': [
      DartGraphicsFillRectBenchmark(),
      CairoFillRectBenchmark(),
      SkiaFillRectBenchmark(),
    ],
    'strokeRect': [
      DartGraphicsStrokeRectBenchmark(),
      CairoStrokeRectBenchmark(),
      SkiaStrokeRectBenchmark(),
    ],
    'arc': [
      DartGraphicsArcBenchmark(),
      CairoArcBenchmark(),
      SkiaArcBenchmark(),
    ],
    'path': [
      DartGraphicsPathBenchmark(),
      CairoPathBenchmark(),
      SkiaPathBenchmark(),
    ],
    'transform': [
      DartGraphicsTransformBenchmark(),
      CairoTransformBenchmark(),
      SkiaTransformBenchmark(),
    ],
    'complexScene': [
      DartGraphicsComplexSceneBenchmark(),
      CairoComplexSceneBenchmark(),
      SkiaComplexSceneBenchmark(),
    ],
  };

  final results = <String, Map<String, double>>{};

  for (final entry in benchmarks.entries) {
    final operation = entry.key;
    final benches = entry.value;

    print('--- $operation ---');
    results[operation] = {};

    for (final bench in benches) {
      final result = bench.measure();
      results[operation]![bench.name] = result;
      print('${bench.name}(RunTime): ${result.toStringAsFixed(2)} us.');
    }
    print('');
  }

  // Print summary table
  print('=' * 70);
  print('SUMMARY (microseconds per run, lower is better)');
  print('=' * 70);
  print('');
  print('${_pad('Operation', 15)} ${_pad('DartGraphics', 18)} ${_pad('Cairo', 18)} ${_pad('Skia', 18)}');
  print('-' * 70);

  for (final operation in benchmarks.keys) {
    final opResults = results[operation]!;
    final DartGraphicsResult = opResults['DartGraphics.$operation'] ?? 0;
    final cairoResult = opResults['Cairo.$operation'] ?? 0;
    final skiaResult = opResults['Skia.$operation'] ?? 0;

    print(
        '${_pad(operation, 15)} ${_pad(DartGraphicsResult.toStringAsFixed(2), 18)} ${_pad(cairoResult.toStringAsFixed(2), 18)} ${_pad(skiaResult.toStringAsFixed(2), 18)}');
  }

  print('-' * 70);
  print('');

  // Find winners
  print('Winners by operation:');
  for (final operation in benchmarks.keys) {
    final opResults = results[operation]!;
    final sorted = opResults.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    final winner = sorted.first.key.split('.').first;
    final ratio = sorted.last.value / sorted.first.value;
    print('  $operation: $winner (${ratio.toStringAsFixed(1)}x faster than slowest)');
  }

  print('');
  print('Benchmark completed.');
}

/// Helper function to pad strings for table formatting
String _pad(String s, int width) {
  if (s.length >= width) return s;
  return s + ' ' * (width - s.length);
}

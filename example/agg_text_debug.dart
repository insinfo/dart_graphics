import 'dart:io';
import 'dart:ffi' as ffi;
import 'package:image/image.dart' as img;
import 'package:dart_graphics/src/agg/agg.dart';

void main() {
  print('Starting AGG Text Debug...');
  final agg = Agg();
  final surface = agg.createSurface(800, 400);
  final canvas = surface.createCanvas();

  // Clear to white
  canvas.setFillColor(255, 255, 255);
  canvas.rect(0, 0, 800, 400);
  canvas.fill();
  
  // Grid
  canvas.setStrokeColor(200, 200, 200);
  canvas.setLineWidth(1);
  for(int i=0; i<800; i+=50) {
      canvas.moveTo(i.toDouble(), 0); canvas.lineTo(i.toDouble(), 400); canvas.stroke();
  }
  for(int i=0; i<400; i+=50) {
      canvas.moveTo(0, i.toDouble()); canvas.lineTo(800, i.toDouble()); canvas.stroke();
  }

  // Draw baseline
  canvas.setStrokeColor(0, 0, 255);
  canvas.moveTo(0, 100); canvas.lineTo(800, 100); canvas.stroke();

  final fontPath = 'C:/Windows/Fonts/arial.ttf';
  if (!File(fontPath).existsSync()) {
      print("ERROR: Font not found at $fontPath");
      return;
  }

  final font = agg.createFont();
  
  if (font.load(fontPath, height: 50, mode: AggTextRenderMode.AggTextRenderModeGray)) {
      print('Font loaded: $fontPath');
      
      canvas.setTextColor(0, 0, 0); // Black
      canvas.setFont(font);
      
      // Test 1: Simple Draw
      canvas.drawText("Baseline 100", 50, 100);
      print('Drawn "Baseline 100" at 50, 100');

      // Test 2: Measure and Box
      String msg = "BoundBox";
      final metrics = canvas.measureText(msg);
      print("Metrics: $metrics");
      
      double x = 400;
      double y = 200;
      
      canvas.setStrokeColor(0, 0, 255);
      canvas.moveTo(0, y); canvas.lineTo(800, y); canvas.stroke(); // Baseline

      canvas.drawText(msg, x, y);
      
      // Draw bounding box (Red)
      // metrics x/y are relative to origin.
      canvas.setStrokeColor(255, 0, 0);
      canvas.setLineWidth(2);
      canvas.rect(x + metrics['x']!, y + metrics['y']!, metrics['width']!, metrics['height']!);
      canvas.stroke();
      
  } else {
      print('Failed to load font inside AGG');
  }

  final outputPath = 'test/tmp/agg_text_debug.png';
  Directory('test/tmp').createSync(recursive: true);
  savePng(surface, outputPath);
  print('Saved to $outputPath');
}

void savePng(AggSurface surface, String filename) {
  final width = surface.width;
  final height = surface.height;
  final buffer = surface.data;
  final image = img.Image(width: width, height: height);
  final stride = surface.stride;
  
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final index = y * stride + x * 4;
      final b = buffer[index];
      final g = buffer[index + 1];
      final r = buffer[index + 2];
      final a = buffer[index + 3];
      image.setPixel(x, y, img.ColorInt8.rgba(r, g, b, a));
    }
  }

  final png = img.encodePng(image);
  File(filename).writeAsBytesSync(png);
}

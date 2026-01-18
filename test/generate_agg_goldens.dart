import 'dart:io';
import 'dart:ffi'; // For Native type access if needed internally by bindings (though we use asTypedList now)
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:dart_graphics/src/agg/agg.dart';

// --- Constants ---
const int kWidth = 250;
const int kHeight = 250;
const String kOutDir = 'test/agg_golden';

void main() {
  final agg = Agg();
  print('Generating Single Element Goldens (AGG C++ ${agg.getVersion()})...');
  Directory(kOutDir).createSync(recursive: true);

  // --- Shapes ---
  _generate(agg, 'shape_rect_fill', (canvas) {
    canvas.setFillColor(255, 0, 0);
    canvas.rect(50, 50, 150, 150);
    canvas.fill();
  });

  _generate(agg, 'shape_rect_stroke', (canvas) {
    canvas.setStrokeColor(0, 0, 255);
    canvas.setLineWidth(5);
    canvas.rect(50, 50, 150, 150);
    canvas.stroke();
  });

  _generate(agg, 'shape_rounded_rect', (canvas) {
    canvas.setFillColor(0, 255, 0);
    canvas.roundedRect(50, 75, 150, 100, 20);
    canvas.fill();
  });

  _generate(agg, 'shape_circle', (canvas) {
    canvas.setFillColor(0, 0, 255);
    canvas.ellipse(125, 125, 80, 80);
    canvas.fill();
  });

  _generate(agg, 'shape_ellipse', (canvas) {
    canvas.setFillColor(255, 255, 0);
    canvas.ellipse(125, 125, 100, 50);
    canvas.fill();
  });

  _generate(agg, 'shape_star_fill', (canvas) {
    canvas.setFillColor(255, 128, 0);
    canvas.moveTo(125, 30);
    canvas.lineTo(150, 95);
    canvas.lineTo(220, 95);
    canvas.lineTo(160, 135);
    canvas.lineTo(185, 205);
    canvas.lineTo(125, 165);
    canvas.lineTo(65, 205);
    canvas.lineTo(90, 135);
    canvas.lineTo(30, 95);
    canvas.lineTo(100, 95);
    canvas.closePath();
    canvas.fill();
  });

  // --- Strokes (Caps & Joins) ---
  _generate(agg, 'stroke_cap_butt', (canvas) {
    canvas.setLineWidth(20);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineCap(AggLineCap.AggLineCapButt);
    canvas.moveTo(50, 125);
    canvas.lineTo(200, 125);
    canvas.stroke();
  });

  _generate(agg, 'stroke_cap_round', (canvas) {
    canvas.setLineWidth(20);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineCap(AggLineCap.AggLineCapRound);
    canvas.moveTo(50, 125);
    canvas.lineTo(200, 125);
    canvas.stroke();
  });

  _generate(agg, 'stroke_cap_square', (canvas) {
    canvas.setLineWidth(20);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineCap(AggLineCap.AggLineCapSquare);
    canvas.moveTo(50, 125);
    canvas.lineTo(200, 125);
    canvas.stroke();
  });

  _generate(agg, 'stroke_join_miter', (canvas) {
    canvas.setLineWidth(20);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineJoin(AggLineJoin.AggLineJoinMiter);
    // canvas.setMiterLimit(4.0); // Default, not exposed in wrapper yet?
    canvas.moveTo(50, 200);
    canvas.lineTo(125, 50);
    canvas.lineTo(200, 200);
    canvas.stroke();
  });

  _generate(agg, 'stroke_join_round', (canvas) {
    canvas.setLineWidth(20);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineJoin(AggLineJoin.AggLineJoinRound);
    canvas.moveTo(50, 200);
    canvas.lineTo(125, 50);
    canvas.lineTo(200, 200);
    canvas.stroke();
  });

  _generate(agg, 'stroke_join_bevel', (canvas) {
    canvas.setLineWidth(20);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineJoin(AggLineJoin.AggLineJoinBevel);
    canvas.moveTo(50, 200);
    canvas.lineTo(125, 50);
    canvas.lineTo(200, 200);
    canvas.stroke();
  });

  _generate(agg, 'stroke_line_width_1', (canvas) {
    canvas.setLineWidth(1);
    canvas.setStrokeColor(0, 0, 0);
    canvas.moveTo(20, 125);
    canvas.lineTo(230, 125);
    canvas.stroke();
  });

  _generate(agg, 'stroke_line_width_5', (canvas) {
    canvas.setLineWidth(5);
    canvas.setStrokeColor(0, 0, 0);
    canvas.moveTo(20, 125);
    canvas.lineTo(230, 125);
    canvas.stroke();
  });

  _generate(agg, 'stroke_line_width_15', (canvas) {
    canvas.setLineWidth(15);
    canvas.setStrokeColor(0, 0, 0);
    canvas.moveTo(20, 125);
    canvas.lineTo(230, 125);
    canvas.stroke();
  });

  _generate(agg, 'stroke_polyline_width_2', (canvas) {
    canvas.setLineWidth(2);
    canvas.setStrokeColor(0, 0, 0);
    canvas.moveTo(40, 40);
    canvas.lineTo(210, 40);
    canvas.lineTo(210, 210);
    canvas.stroke();
  });

  _generate(agg, 'stroke_polyline_width_10', (canvas) {
    canvas.setLineWidth(10);
    canvas.setStrokeColor(0, 0, 0);
    canvas.moveTo(40, 40);
    canvas.lineTo(210, 40);
    canvas.lineTo(210, 210);
    canvas.stroke();
  });

  _generate(agg, 'pattern_hatch', (canvas) {
    canvas.setLineWidth(2);
    canvas.setStrokeColor(80, 80, 80);
    for (int i = -200; i <= 200; i += 20) {
      final dx = i.toDouble();
      canvas.moveTo(25 + dx, 25);
      canvas.lineTo(25 + dx + 200, 225);
    }
    canvas.stroke();
  });

  _generate(agg, 'pattern_grid', (canvas) {
    canvas.setLineWidth(1.5);
    canvas.setStrokeColor(120, 120, 120);
    for (int i = 25; i <= 225; i += 20) {
      final d = i.toDouble();
      canvas.moveTo(25, d);
      canvas.lineTo(225, d);
      canvas.moveTo(d, 25);
      canvas.lineTo(d, 225);
    }
    canvas.stroke();
  });

  _generate(agg, 'pattern_cross_hatch', (canvas) {
    canvas.setLineWidth(2);
    canvas.setStrokeColor(90, 90, 90);
    for (int i = -200; i <= 200; i += 20) {
      final dx = i.toDouble();
      canvas.moveTo(25 + dx, 25);
      canvas.lineTo(25 + dx + 200, 225);
      canvas.moveTo(25 + dx, 225);
      canvas.lineTo(25 + dx + 200, 25);
    }
    canvas.stroke();
  });

  _generate(agg, 'shape_polygon_concave', (canvas) {
    canvas.setFillColor(0, 140, 255);
    canvas.moveTo(125, 30);
    canvas.lineTo(205, 70);
    canvas.lineTo(165, 135);
    canvas.lineTo(220, 210);
    canvas.lineTo(125, 175);
    canvas.lineTo(30, 210);
    canvas.lineTo(85, 135);
    canvas.lineTo(45, 70);
    canvas.closePath();
    canvas.fill();
  });

  _generate(agg, 'stroke_cap_round_width_12', (canvas) {
    canvas.setLineWidth(12);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineCap(AggLineCap.AggLineCapRound);
    canvas.moveTo(40, 80);
    canvas.lineTo(210, 80);
    canvas.stroke();
  });

  _generate(agg, 'stroke_cap_square_width_12', (canvas) {
    canvas.setLineWidth(12);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineCap(AggLineCap.AggLineCapSquare);
    canvas.moveTo(40, 80);
    canvas.lineTo(210, 80);
    canvas.stroke();
  });

  _generate(agg, 'stroke_join_round_width_12', (canvas) {
    canvas.setLineWidth(12);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineJoin(AggLineJoin.AggLineJoinRound);
    canvas.moveTo(50, 200);
    canvas.lineTo(125, 50);
    canvas.lineTo(200, 200);
    canvas.stroke();
  });

  _generate(agg, 'stroke_join_miter_width_12', (canvas) {
    canvas.setLineWidth(12);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineJoin(AggLineJoin.AggLineJoinMiter);
    canvas.moveTo(50, 200);
    canvas.lineTo(125, 50);
    canvas.lineTo(200, 200);
    canvas.stroke();
  });

  _generate(agg, 'stroke_dotted', (canvas) {
    canvas.setLineWidth(6);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineCap(AggLineCap.AggLineCapRound);
    const startX = 20.0;
    const endX = 230.0;
    const y = 125.0;
    const dash = 4.0;
    const gap = 10.0;
    for (double x = startX; x < endX; x += dash + gap) {
      final x2 = (x + dash).clamp(startX, endX);
      canvas.moveTo(x, y);
      canvas.lineTo(x2, y);
    }
    canvas.stroke();
  });

  _generate(agg, 'stroke_dashed', (canvas) {
    canvas.setLineWidth(4);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineCap(AggLineCap.AggLineCapButt);
    const startX = 20.0;
    const endX = 230.0;
    const y = 125.0;
    const dash = 16.0;
    const gap = 8.0;
    for (double x = startX; x < endX; x += dash + gap) {
      final x2 = (x + dash).clamp(startX, endX);
      canvas.moveTo(x, y);
      canvas.lineTo(x2, y);
    }
    canvas.stroke();
  });

  _generate(agg, 'shape_arrow', (canvas) {
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineWidth(6);
    canvas.setLineCap(AggLineCap.AggLineCapRound);
    canvas.moveTo(40, 125);
    canvas.lineTo(190, 125);
    canvas.stroke();

    canvas.setFillColor(0, 0, 0);
    canvas.moveTo(190, 125);
    canvas.lineTo(160, 105);
    canvas.lineTo(160, 145);
    canvas.closePath();
    canvas.fill();
  });

  _generate(agg, 'stroke_rect_rounded', (canvas) {
    canvas.setLineWidth(8);
    canvas.setStrokeColor(0, 0, 0);
    canvas.roundedRect(40, 40, 170, 170, 20);
    canvas.stroke();
  });

  _generate(agg, 'stroke_rect_bevel', (canvas) {
    canvas.setLineWidth(12);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineJoin(AggLineJoin.AggLineJoinBevel);
    canvas.rect(40, 40, 170, 170);
    canvas.stroke();
  });

  _generate(agg, 'stroke_ellipse', (canvas) {
    canvas.setLineWidth(6);
    canvas.setStrokeColor(0, 0, 0);
    canvas.ellipse(125, 125, 90, 60);
    canvas.stroke();
  });

  _generate(agg, 'stroke_dash', (canvas) {
    canvas.setLineWidth(5);
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineDash([15.0, 10.0, 5.0, 10.0]);
    canvas.moveTo(25, 125);
    canvas.lineTo(225, 125);
    canvas.stroke();
  });

  // --- Transforms ---
  _generate(agg, 'transform_rotate', (canvas) {
    // Rotate 45 degrees around center (match agg_example style)
    canvas.translate(125.0, 125.0);
    canvas.rotate(math.pi / 4);
    canvas.setFillColor(100, 0, 200);
    // Draw rect centered at origin for stable rotation
    canvas.rect(-50, -50, 100, 100);
    canvas.fill();
    canvas.resetTransform();
  });

  _generate(agg, 'transform_scale', (canvas) {
    // Scale 0.5 from center
    canvas.translate(125.0, 125.0);
    canvas.scale(0.5, 0.5);
    canvas.translate(-125.0, -125.0);

    canvas.setFillColor(0, 100, 200);
    canvas.rect(25, 25, 200, 200); // 200x200 -> 100x100
    canvas.fill();
  });

  // --- Gradients ---
  _generate(agg, 'gradient_linear', (canvas) {
    final grad = agg.createGradient(AggGradientType.AggGradientLinear);
    grad.setLinear(50, 50, 200, 200);
    grad.addStop(0, 255, 0, 0);
    grad.addStop(1, 0, 0, 255);
    grad.build();

    canvas.setFillGradient(grad);
    canvas.rect(25, 25, 200, 200);
    canvas.fill();
    grad.dispose();
  });

  _generate(agg, 'gradient_radial', (canvas) {
    final grad = agg.createGradient(AggGradientType.AggGradientRadial);
    grad.setRadial(125, 125, 100);
    grad.addStop(0, 255, 255, 255);
    grad.addStop(1, 0, 100, 0);
    grad.build();

    canvas.setFillGradient(grad);
    canvas.rect(0, 0, 250, 250);
    canvas.fill();
    grad.dispose();
  });

  // --- Text ---
  _generate(agg, 'text_gray', (canvas) {
    final fontPath = 'C:/Windows/Fonts/arial.ttf';
    final font = agg.createFont();
    if (font.load(fontPath, height: 40, mode: AggTextRenderMode.AggTextRenderModeGray)) {
       canvas.setFont(font);
       canvas.setTextColor(0, 0, 0);
       canvas.drawText("Hello", 50, 140, mode: AggTextRenderMode.AggTextRenderModeGray);
    }
    font.dispose();
  });

  _generate(agg, 'text_outline', (canvas) {
    final fontPath = 'C:/Windows/Fonts/arial.ttf';
    final font = agg.createFont();
    if (font.load(fontPath, height: 60, mode: AggTextRenderMode.AggTextRenderModeOutline)) {
       canvas.setFont(font);
       canvas.setLineWidth(1.0);
       canvas.setStrokeColor(0, 0, 200);
       canvas.drawText("Out", 50, 150, mode: AggTextRenderMode.AggTextRenderModeOutline);
    }
    font.dispose();
  });

  _generate(agg, 'text_fill_vector', (canvas) {
    final fontPath = 'C:/Windows/Fonts/arial.ttf';
    final font = agg.createFont();
    // Use fill mode
    if (font.load(fontPath, height: 60)) {
       canvas.setFont(font);
       canvas.setFillColor(0, 150, 0);
       canvas.drawText("Fill", 50, 150, mode: AggTextRenderMode.AggTextRenderModeFill);
    }
    font.dispose();
  });
  
  _generate(agg, 'text_gradient', (canvas) {
    final fontPath = 'C:/Windows/Fonts/arial.ttf';
    final font = agg.createFont();
    if (font.load(fontPath, height: 60, mode: AggTextRenderMode.AggTextRenderModeOutline)) {
      canvas.setFont(font);

      final grad = agg.createGradient(AggGradientType.AggGradientLinear);
      // Cover the approximate text height for a visible gradient
      grad.setLinear(50, 110, 50, 160);
      grad.addStop(0.0, 255, 0, 0);
      grad.addStop(1.0, 0, 0, 255);
      grad.build();

      canvas.setFillGradient(grad);
      canvas.setLineWidth(1.5);
      canvas.setStrokeColor(0, 0, 0);
      canvas.drawText("Grad", 50, 150, mode: AggTextRenderMode.AggTextRenderModeFill);
      grad.dispose();
    }
    font.dispose();
  });

  // --- Clipping ---
  _generate(agg, 'clip_rect', (canvas) {
     canvas.clipRect(50, 50, 150, 150);
     
     canvas.setFillColor(255, 0, 0);
     canvas.ellipse(125, 125, 100, 100); // Circle larger than clip
     canvas.fill();
     
     canvas.resetClip();
     
     // Draw box to show clip area
     canvas.setStrokeColor(0, 0, 0);
     canvas.setLineWidth(1);
     canvas.rect(50, 50, 150, 150);
     canvas.stroke();
  });

  // --- Paths ---
  _generate(agg, 'path_cubic', (canvas) {
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineWidth(3);
    canvas.moveTo(25, 200);
    canvas.cubicTo(25, 25, 225, 25, 225, 200);
    canvas.stroke();
  });

  _generate(agg, 'path_quadratic', (canvas) {
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineWidth(3);
    canvas.moveTo(25, 200);
    canvas.quadraticTo(125, 25, 225, 200);
    canvas.stroke();
  });

  _generate(agg, 'path_arc_segment', (canvas) {
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineWidth(3);
    // rx, ry, rot, large, sweep, x, y
    // Start at 50, 125
    canvas.moveTo(50, 125);
    canvas.arc(50, 50, 0, false, true, 150, 125);
    canvas.stroke();
  });

  _generate(agg, 'path_arc_center', (canvas) {
    canvas.setStrokeColor(0, 0, 0);
    canvas.setLineWidth(3);
    // cx, cy, r, start, sweep
    canvas.arcCenter(125, 125, 80, 0, math.pi * 1.5);
    canvas.stroke();
  });

  _generate(agg, 'path_svg', (canvas) {
    canvas.setFillColor(255, 165, 0);
    canvas.addSvgPath("M 125 25 L 155 100 L 225 100 L 170 150 L 195 225 L 125 180 L 55 225 L 80 150 L 25 100 L 95 100 Z");
    canvas.fill();
  });

  // --- Alpha ---
  _generate(agg, 'alpha_blend', (canvas) {
      canvas.setFillColor(255, 0, 0, 150);
      canvas.ellipse(100, 100, 60, 60);
      canvas.fill();
      
      canvas.setFillColor(0, 255, 0, 150);
      canvas.ellipse(150, 100, 60, 60);
      canvas.fill();
      
      canvas.setFillColor(0, 0, 255, 150);
      canvas.ellipse(125, 150, 60, 60);
      canvas.fill();
  });

  print('Done.');
}

// --- Helper Functions ---

void _generate(Agg agg, String name, Function(AggCanvas) draw) {
  final surface = agg.createSurface(kWidth, kHeight);
  final canvas = surface.createCanvas();
  
  // Clear white
  canvas.setFillColor(255, 255, 255);
  canvas.rect(0, 0, kWidth.toDouble(), kHeight.toDouble());
  canvas.fill();

  // Draw
  draw(canvas);

  // Save
  final filepath = '$kOutDir/$name.png';
  _savePng(surface, filepath);
  
  // Cleanup
  surface.dispose();
  // Canvas is disposed by surface mostly, or simple ptr drop, 
  // but AggCanvas Dart wrapper has dispose. The surface.createCanvas returns a NEW canvas object.
  // We should dispose it.
  canvas.dispose(); 
}

void _savePng(AggSurface surface, String filepath) {
  final width = surface.width;
  final height = surface.height;
  final buffer = surface.data.asTypedList(width * height * 4);
  final image = img.Image(width: width, height: height);
  final stride = surface.stride;
  
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final index = y * stride + x * 4;
      final r = buffer[index];
      final g = buffer[index + 1];
      final b = buffer[index + 2];
      final a = buffer[index + 3];
      image.setPixel(x, y, img.ColorInt8.rgba(r, g, b, a));
    }
  }

  final png = img.encodePng(image);
  File(filepath).writeAsBytesSync(png);
  print('Saved: $filepath');
}

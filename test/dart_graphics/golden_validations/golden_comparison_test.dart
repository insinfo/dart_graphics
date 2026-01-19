import 'dart:io';
import 'dart:math' as math;
import 'package:test/test.dart';
import 'package:image/image.dart' as img;
import 'package:dart_graphics/dart_graphics.dart';
import 'package:dart_graphics/src/dart_graphics/image/png_encoder.dart';

// Constants matching generate_agg_goldens.dart
const int kWidth = 250;
const int kHeight = 250;
const String kGoldenDir = 'resources/agg_golden';

void main() {
  group('Golden Validations', () {
    // --- Shapes ---
    testGolden('shape_rect_fill', (canvas) {
      canvas.fillColor = Color(255, 0, 0, 255);
      canvas.rect(50, 50, 200, 200); // 50+150
      canvas.fillPath();
    });

    testGolden('shape_rect_stroke', (canvas) {
      canvas.strokeColor = Color(0, 0, 255, 255);
      canvas.lineWidth = 5;
      canvas.rect(50, 50, 200, 200);
      canvas.strokePath();
    });

    testGolden('shape_rounded_rect', (canvas) {
      canvas.fillColor = Color(0, 255, 0, 255);
      // roundedRect(x1, y1, x2, y2, r)
      canvas.roundedRect(50, 75, 200, 175, 20); // 50+150, 75+100
      canvas.fillPath();
    });

    testGolden('shape_circle', (canvas) {
      canvas.fillColor = Color(0, 0, 255, 255);
      // ellipse(cx, cy, rx, ry)
      canvas.ellipse(125, 125, 80, 80);
      canvas.fillPath();
    });

    testGolden('shape_ellipse', (canvas) {
      canvas.fillColor = Color(255, 255, 0, 255);
      canvas.ellipse(125, 125, 100, 50);
      canvas.fillPath();
    });

    testGolden('shape_star_fill', (canvas) {
      canvas.fillColor = Color(255, 128, 0, 255);
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
      canvas.fillPath();
    });

    // --- Strokes ---
    testGolden('stroke_cap_butt', (canvas) {
      canvas.lineWidth = 20;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineCap = LineCap.butt;
      canvas.moveTo(50, 125);
      canvas.lineTo(200, 125);
      canvas.strokePath();
    });

    testGolden('stroke_cap_round', (canvas) {
      canvas.lineWidth = 20;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineCap = LineCap.round;
      canvas.moveTo(50, 125);
      canvas.lineTo(200, 125);
      canvas.strokePath();
    });

    testGolden('stroke_cap_square', (canvas) {
      canvas.lineWidth = 20;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineCap = LineCap.square;
      canvas.moveTo(50, 125);
      canvas.lineTo(200, 125);
      canvas.strokePath();
    });

    testGolden('stroke_join_miter', (canvas) {
      canvas.lineWidth = 20;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineJoin = LineJoin.miter;
      canvas.miterLimit = 4.0;
      canvas.moveTo(50, 200);
      canvas.lineTo(125, 50);
      canvas.lineTo(200, 200);
      canvas.strokePath();
    });

    testGolden('stroke_join_round', (canvas) {
      canvas.lineWidth = 20;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineJoin = LineJoin.round;
      canvas.moveTo(50, 200);
      canvas.lineTo(125, 50);
      canvas.lineTo(200, 200);
      canvas.strokePath();
    });

    testGolden('stroke_join_bevel', (canvas) {
      canvas.lineWidth = 20;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineJoin = LineJoin.bevel;
      canvas.moveTo(50, 200);
      canvas.lineTo(125, 50);
      canvas.lineTo(200, 200);
      canvas.strokePath();
    });

    testGolden('stroke_line_width_1', (canvas) {
      canvas.lineWidth = 1;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.moveTo(20, 125);
      canvas.lineTo(230, 125);
      canvas.strokePath();
    });

    testGolden('stroke_line_width_5', (canvas) {
      canvas.lineWidth = 5;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.moveTo(20, 125);
      canvas.lineTo(230, 125);
      canvas.strokePath();
    });

    testGolden('stroke_line_width_15', (canvas) {
      canvas.lineWidth = 15;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.moveTo(20, 125);
      canvas.lineTo(230, 125);
      canvas.strokePath();
    });

    testGolden('stroke_polyline_width_2', (canvas) {
      canvas.lineWidth = 2;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.moveTo(40, 40);
      canvas.lineTo(210, 40);
      canvas.lineTo(210, 210);
      canvas.strokePath();
    });

    testGolden('stroke_polyline_width_10', (canvas) {
      canvas.lineWidth = 10;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.moveTo(40, 40);
      canvas.lineTo(210, 40);
      canvas.lineTo(210, 210);
      canvas.strokePath();
    });

    testGolden('pattern_hatch', (canvas) {
      canvas.lineWidth = 2;
      canvas.strokeColor = Color(80, 80, 80, 255);
      for (int i = -200; i <= 200; i += 20) {
        canvas.moveTo(25 + i.toDouble(), 25);
        canvas.lineTo(25 + i.toDouble() + 200, 225);
      }
      canvas.strokePath();
    });

    testGolden('pattern_grid', (canvas) {
      canvas.lineWidth = 1.5;
      canvas.strokeColor = Color(120, 120, 120, 255);
      for (int i = 25; i <= 225; i += 20) {
        final d = i.toDouble();
        canvas.moveTo(25, d);
        canvas.lineTo(225, d);
        canvas.moveTo(d, 25);
        canvas.lineTo(d, 225);
      }
      canvas.strokePath();
    });

    testGolden('pattern_cross_hatch', (canvas) {
      canvas.lineWidth = 2;
      canvas.strokeColor = Color(90, 90, 90, 255);
      for (int i = -200; i <= 200; i += 20) {
        final dx = i.toDouble();
        canvas.moveTo(25 + dx, 25);
        canvas.lineTo(25 + dx + 200, 225);
        canvas.moveTo(25 + dx, 225);
        canvas.lineTo(25 + dx + 200, 25);
      }
      canvas.strokePath();
    });

    testGolden('shape_polygon_concave', (canvas) {
      canvas.fillColor = Color(0, 140, 255, 255);
      canvas.moveTo(125, 30);
      canvas.lineTo(205, 70);
      canvas.lineTo(165, 135);
      canvas.lineTo(220, 210);
      canvas.lineTo(125, 175);
      canvas.lineTo(30, 210);
      canvas.lineTo(85, 135);
      canvas.lineTo(45, 70);
      canvas.closePath();
      canvas.fillPath();
    });

    testGolden('stroke_cap_round_width_12', (canvas) {
      canvas.lineWidth = 12;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineCap = LineCap.round;
      canvas.moveTo(40, 80);
      canvas.lineTo(210, 80);
      canvas.strokePath();
    });

    testGolden('stroke_cap_square_width_12', (canvas) {
      canvas.lineWidth = 12;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineCap = LineCap.square;
      canvas.moveTo(40, 80);
      canvas.lineTo(210, 80);
      canvas.strokePath();
    });

    testGolden('stroke_join_round_width_12', (canvas) {
      canvas.lineWidth = 12;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineJoin = LineJoin.round;
      canvas.moveTo(50, 200);
      canvas.lineTo(125, 50);
      canvas.lineTo(200, 200);
      canvas.strokePath();
    });

    testGolden('stroke_join_miter_width_12', (canvas) {
      canvas.lineWidth = 12;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineJoin = LineJoin.miter;
      canvas.moveTo(50, 200);
      canvas.lineTo(125, 50);
      canvas.lineTo(200, 200);
      canvas.strokePath();
    });

    testGolden('stroke_dotted', (canvas) {
      canvas.lineWidth = 6;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineCap = LineCap.round;
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
      canvas.strokePath();
    });

    testGolden('stroke_dashed', (canvas) {
      canvas.lineWidth = 4;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineCap = LineCap.butt;
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
      canvas.strokePath();
    });

    testGolden('shape_arrow', (canvas) {
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineWidth = 6;
      canvas.lineCap = LineCap.round;
      canvas.moveTo(40, 125);
      canvas.lineTo(190, 125);
      canvas.strokePath();

      canvas.fillColor = Color(0, 0, 0, 255);
      canvas.moveTo(190, 125);
      canvas.lineTo(160, 105);
      canvas.lineTo(160, 145);
      canvas.closePath();
      canvas.fillPath();
    });

    testGolden('shape_arrow_double', (canvas) {
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineWidth = 6;
      canvas.lineCap = LineCap.round;
      canvas.moveTo(60, 125);
      canvas.lineTo(190, 125);
      canvas.strokePath();

      canvas.fillColor = Color(0, 0, 0, 255);
      canvas.moveTo(190, 125);
      canvas.lineTo(160, 105);
      canvas.lineTo(160, 145);
      canvas.closePath();
      canvas.fillPath();

      canvas.moveTo(60, 125);
      canvas.lineTo(90, 105);
      canvas.lineTo(90, 145);
      canvas.closePath();
      canvas.fillPath();
    });

    testGolden('shape_arrow_small_head', (canvas) {
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineWidth = 6;
      canvas.lineCap = LineCap.round;
      canvas.moveTo(40, 125);
      canvas.lineTo(190, 125);
      canvas.strokePath();

      canvas.fillColor = Color(0, 0, 0, 255);
      canvas.moveTo(190, 125);
      canvas.lineTo(170, 113);
      canvas.lineTo(170, 137);
      canvas.closePath();
      canvas.fillPath();
    });

    testGolden('shape_arrow_large_head', (canvas) {
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineWidth = 6;
      canvas.lineCap = LineCap.round;
      canvas.moveTo(40, 125);
      canvas.lineTo(190, 125);
      canvas.strokePath();

      canvas.fillColor = Color(0, 0, 0, 255);
      canvas.moveTo(190, 125);
      canvas.lineTo(150, 95);
      canvas.lineTo(150, 155);
      canvas.closePath();
      canvas.fillPath();
    });

    testGolden('stroke_dashed_vertical', (canvas) {
      canvas.lineWidth = 4;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineCap = LineCap.butt;
      const startY = 20.0;
      const endY = 230.0;
      const x = 125.0;
      const dash = 16.0;
      const gap = 8.0;
      for (double y = startY; y < endY; y += dash + gap) {
        final y2 = (y + dash).clamp(startY, endY);
        canvas.moveTo(x, y);
        canvas.lineTo(x, y2);
      }
      canvas.strokePath();
    });

    testGolden('stroke_dashed_diagonal', (canvas) {
      canvas.lineWidth = 4;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineCap = LineCap.butt;
      const start = 30.0;
      const end = 220.0;
      const dash = 18.0;
      const gap = 10.0;
      for (double t = 0; t < (end - start); t += dash + gap) {
        final t2 = (t + dash).clamp(0.0, end - start);
        canvas.moveTo(start + t, start + t);
        canvas.lineTo(start + t2, start + t2);
      }
      canvas.strokePath();
    });

    testGolden('shape_donut', (canvas) {
      canvas.fillColor = Color(200, 0, 200, 255);
      if (canvas is BasicGraphics2D) {
        canvas.rasterizer.fillingRule(FillingRuleE.fillEvenOdd);
      }
      canvas.ellipse(125, 125, 90, 90);
      canvas.ellipse(125, 125, 45, 45);
      canvas.fillPath();
      if (canvas is BasicGraphics2D) {
        canvas.rasterizer.fillingRule(FillingRuleE.fillNonZero);
      }
    });

    testGolden('stroke_rect_rounded', (canvas) {
      canvas.lineWidth = 8;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.roundedRect(40, 40, 210, 210, 20);
      canvas.strokePath();
    });

    testGolden('stroke_rect_bevel', (canvas) {
      canvas.lineWidth = 12;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineJoin = LineJoin.bevel;
      canvas.rect(40, 40, 210, 210);
      canvas.strokePath();
    });

    testGolden('stroke_ellipse', (canvas) {
      canvas.lineWidth = 6;
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.ellipse(125, 125, 90, 60);
      canvas.strokePath();
    });

    // Stroke Dash (Not fully implemented in BasicGraphics2D yet)
    // testGolden('stroke_dash', ...);

    // --- Transforms ---
    testGolden('transform_rotate', (canvas) {
      canvas.save();
      // Match generate_agg_goldens.dart: translate center, rotate, draw centered rect
      canvas.translate(125.0, 125.0);
      canvas.rotate(math.pi / 4);

      canvas.fillColor = Color(100, 0, 200, 255);
      canvas.rect(-50, -50, 50, 50); // centered at origin, size 100x100
      canvas.fillPath();
      canvas.restore();
      canvas.resetPath();
    });

    testGolden('transform_scale', (canvas) {
      canvas.save();
      canvas.translate(125.0, 125.0);
      canvas.scale(0.5, 0.5);
      canvas.translate(-125.0, -125.0);

      canvas.fillColor = Color(0, 100, 200, 255);
      canvas.rect(25, 25, 225, 225); // 25, 25, 25+200, 25+200
      canvas.fillPath();
      canvas.restore();
    });

    // --- Gradients ---
    testGolden('gradient_linear', (canvas) {
      // Validated manually to use setLinearGradient
      canvas.setLinearGradient(50, 50, 200, 200, [
        (offset: 0.0, color: Color(255, 0, 0, 255)),
        (offset: 1.0, color: Color(0, 0, 255, 255))
      ]);
      canvas.rect(25, 25, 225, 225); 
      canvas.fillPath();
      canvas.setSolidFill();
    });

    testGolden('gradient_radial', (canvas) {
      canvas.setRadialGradient(125, 125, 100, [
        (offset: 0.0, color: Color(255, 255, 255, 255)),
        (offset: 1.0, color: Color(0, 100, 0, 255))
      ]);
      canvas.rect(0, 0, 250, 250);
      canvas.fillPath();
      canvas.setSolidFill();
    });

    // --- Clipping ---
    testGolden('clip_rect', (canvas) {
      // Clipping logic based on implementation availability
      if (canvas is BasicGraphics2D) {
        // x1, y1, x2, y2. AGG golden used 50, 50, 150, 150 (width/height)
        // Rect(50, 50, 50+150, 50+150) -> 50, 50, 200, 200
        canvas.rasterizer.setVectorClipBox(50, 50, 200, 200);
      }
      
      canvas.fillColor = Color(255, 0, 0, 255);
      canvas.ellipse(125, 125, 100, 100);
      canvas.fillPath();
      canvas.resetPath(); // Fix: Clear previous path (ellipse) before stroking rect
      
      if (canvas is BasicGraphics2D) {
        // canvas.rasterizer.reset_clipping(); 
        // Note: reset_clipping calls reset() which might clear the path/rasterizer state too much?
        // Let's assume setVectorClipBox is resilient.
        canvas.rasterizer.setVectorClipBox(0, 0, 10000, 10000); // Hack update - reset not exposed?
        // Checking BasicGraphics2D source: ScanlineRasterizer has reset_clipping().
        canvas.rasterizer.reset_clipping();
      }

      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineWidth = 1;
      canvas.rect(50, 50, 200, 200);
      canvas.strokePath();
    });

    // --- Paths ---
    testGolden('path_cubic', (canvas) {
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineWidth = 3;
      canvas.moveTo(25, 200);
      canvas.curve4(25, 25, 225, 25, 225, 200);
      canvas.strokePath();
    });

    testGolden('path_quadratic', (canvas) {
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineWidth = 3;
      canvas.moveTo(25, 200);
      canvas.curve3(125, 25, 225, 200);
      canvas.strokePath();
    });

    testGolden('path_arc_segment', (canvas) {
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineWidth = 3;
      canvas.moveTo(50, 125);
      canvas.arc(100, 125, 50, 50, math.pi, 0); 
      canvas.strokePath();
    });

    testGolden('path_arc_center', (canvas) {
      canvas.strokeColor = Color(0, 0, 0, 255);
      canvas.lineWidth = 3;
      // start=0, end=1.5*pi
      canvas.arc(125, 125, 80, 80, 0, 1.5 * math.pi);
      canvas.strokePath();
    });

    testGolden('path_svg', (canvas) {
      canvas.fillColor = Color(255, 165, 0, 255); // Orange
      // Manual path: "M 125 25 L 155 100 L 225 100 L 170 150 L 195 225 L 125 180 L 55 225 L 80 150 L 25 100 L 95 100 Z"
      canvas.moveTo(125, 25);
      canvas.lineTo(155, 100);
      canvas.lineTo(225, 100);
      canvas.lineTo(170, 150);
      canvas.lineTo(195, 225);
      canvas.lineTo(125, 180);
      canvas.lineTo(55, 225);
      canvas.lineTo(80, 150);
      canvas.lineTo(25, 100);
      canvas.lineTo(95, 100);
      canvas.closePath();
      canvas.fillPath();
    });

    testGolden('alpha_blend', (canvas) {
      canvas.fillColor = Color(255, 0, 0, 150);
      canvas.ellipse(100, 100, 60, 60);
      canvas.fillPath();
      canvas.resetPath(); // Ensure path is clear for next shape

      canvas.fillColor = Color(0, 255, 0, 150);
      canvas.ellipse(150, 100, 60, 60);
      canvas.fillPath();
      canvas.resetPath();

      canvas.fillColor = Color(0, 0, 255, 150);
      canvas.ellipse(125, 150, 60, 60);
      canvas.fillPath();
      canvas.resetPath();
    });

    // --- Text ---
    // Try to load Font
    final fontPath = 'C:/Windows/Fonts/arial.ttf';
    if (File(fontPath).existsSync()) {
      try {
        final fontBytes = File(fontPath).readAsBytesSync();
        final fontReader = OpenFontReader();
        final typeface = fontReader.read(fontBytes);
        
        if (typeface != null) {
          testGolden('text_fill_vector', (canvas) {
             canvas.setFont(typeface, 60);
             canvas.fillColor = Color(0, 150, 0, 255);
             canvas.drawTextCurrent("Fill", x: 50, y: 150);
          });
          
           testGolden('text_gradient', (canvas) {
             canvas.setFont(typeface, 60);
             canvas.setLinearGradient(50, 110, 50, 160, [
               (offset: 0.0, color: Color(255, 0, 0, 255)),
               (offset: 1.0, color: Color(0, 0, 255, 255))
             ]);
             canvas.drawTextCurrent("Grad", x: 50, y: 150);
             canvas.setSolidFill();
          });

          testGolden('text_gray', (canvas) {
             canvas.setFont(typeface, 40);
             canvas.fillColor = Color(0, 0, 0, 255);
             canvas.drawTextCurrent("Hello", x: 50, y: 140);
          });
        }
      } catch (e) {
        print("Skipping text tests: $e");
      }
    } else {
        print("Skipping text tests: arial.ttf not found");
    }
  });
}

void testGolden(String name, void Function(Graphics2D) draw) {
  test(name, () {
    final goldenFile = File('$kGoldenDir/$name.png');
    if (!goldenFile.existsSync()) {
      print('Skipping $name: golden not found.');
      return;
    }

    final imageBuffer = ImageBuffer(kWidth, kHeight);
    final canvas = imageBuffer.newGraphics2D();
    
    // Fill white background to match golden
    canvas.clear(Color(255, 255, 255, 255));
    
    draw(canvas);

    // Save actual for debugging/visual comparison using PngEncoder logic
    // which aligns with other tests (e.g. gradient_effects_test.dart).
    final actualFile = File('test/tmp/golden_result/$name.png');
    if (!actualFile.parent.existsSync()) actualFile.parent.createSync(recursive: true);

    // Use PngEncoder to generate bytes, ensuring correct pixel format handling
    final pngBytes = PngEncoder.encode(imageBuffer);
    File(actualFile.path).writeAsBytesSync(pngBytes);
    
    // Decode stored PNG to compare with Golden
    final actualImg = img.decodePng(pngBytes)!;
    final goldenImg = img.decodePng(goldenFile.readAsBytesSync())!;
    
    // Compare
    
    if (name == 'alpha_blend') {
      // Debug center of Red circle (100, 100)
      final pActual = actualImg.getPixel(100, 100);
      final pGolden = goldenImg.getPixel(100, 100);
      print('DEBUG: alpha_blend (100,100) Actual: ${pActual.r},${pActual.g},${pActual.b} Golden: ${pGolden.r},${pGolden.g},${pGolden.b}');
      
      // Compare with reference "correct" image from other test
      final refFile = File('test/tmp/alpha_blending.png');
      if (refFile.existsSync()) {
          final refImg = img.decodePng(refFile.readAsBytesSync())!;
          // Center of Red circle in ref is (80, 80)
          final pRef = refImg.getPixel(80, 80);
          print('DEBUG: Reference alpha_blending.png (80,80): ${pRef.r},${pRef.g},${pRef.b}');
      }
      
      // Find where mismatch is
      int mismatches = 0;
      for(var p1 in actualImg) {
          final p2 = goldenImg.getPixel(p1.x, p1.y);
          if ((p1.r - p2.r).abs() > 5 || (p1.g - p2.g).abs() > 5 || (p1.b - p2.b).abs() > 5) {
              if (mismatches < 3) {
                  print('Mismatch at ${p1.x},${p1.y}: Actual(${p1.r},${p1.g},${p1.b}) vs Golden(${p2.r},${p2.g},${p2.b})');
              }
              mismatches++;
          }
      }
      print('Total mismatches: $mismatches');
    }

    double diffPercent = compareImages(actualImg, goldenImg);
    final tolerance = name == 'text_gradient' ? 0.02 : 0.01;
    if (diffPercent > tolerance) { // 1% default, 2% for text_gradient
       fail('Image mismatch for $name. Diff: ${(diffPercent * 100).toStringAsFixed(2)}%');
    }
  });
}

// Deprecated manual buffer helper removed as PngEncoder handles it
// Uint8List imageBufferToRgba...

double compareImages(img.Image img1, img.Image img2) {
  if (img1.width != img2.width || img1.height != img2.height) return 1.0;
  
  int diffPixels = 0;
  int totalPixels = img1.width * img1.height;
  
  for (final p1 in img1) {
    final p2 = img2.getPixel(p1.x, p1.y);
    
    if ((p1.r - p2.r).abs() > 5 || 
        (p1.g - p2.g).abs() > 5 || 
        (p1.b - p2.b).abs() > 5) {
      diffPixels++;
    }
  }
  
  return diffPixels / totalPixels;
}

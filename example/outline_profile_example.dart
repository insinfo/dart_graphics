import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/line_aa_basics.dart';
import 'package:dart_graphics/src/dart_graphics/line_profile_aa.dart';
import 'package:dart_graphics/src/dart_graphics/outline_image_renderer.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/rasterizer_outline_aa.dart';
import 'package:dart_graphics/src/dart_graphics/gamma_functions.dart';

void main() {
  final img = ImageBuffer(64, 64);
  final profile = LineProfileAA.withWidth(4.0, GammaNone());
  final renderer = ProfileLineRenderer(
    img,
    profile: profile,
    color: Color(0, 0, 0, 255),
    cap: CapStyle.square,
  );
  final outline = RasterizerOutlineAA(renderer)..roundCap = false;

  // Draw an X with square caps.
  outline.moveTo(8 * LineAABasics.line_subpixel_scale, 8 * LineAABasics.line_subpixel_scale);
  outline.lineTo(56 * LineAABasics.line_subpixel_scale, 56 * LineAABasics.line_subpixel_scale);
  outline.render();

  outline.moveTo(56 * LineAABasics.line_subpixel_scale, 8 * LineAABasics.line_subpixel_scale);
  outline.lineTo(8 * LineAABasics.line_subpixel_scale, 56 * LineAABasics.line_subpixel_scale);
  outline.render();

  // A simple checksum to verify pixels changed when run manually.
  int sum = 0;
  for (int i = 0; i < img.getBuffer().length; i++) {
    sum += img.getBuffer()[i];
  }
  print('Outline profile example checksum: $sum');
}

import 'dart:math' as math;

import 'package:dart_graphics/src/dart_graphics/image/iimage.dart';
import 'package:dart_graphics/src/dart_graphics/line_profile_aa.dart';
import 'package:dart_graphics/src/dart_graphics/line_aa_basics.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/rectangle_int.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/rasterizer_outline_aa.dart';

/// Minimal image-backed line renderer: projects subpixel coords into pixel
/// space and draws a simple solid line.
/// AA line renderer using Xiaolin Wu with optional thickness (in pixels).
class ImageLineRenderer extends LineRenderer {
  final IImageByte _image;
  Color color;
  double thickness;
  CapStyle cap;

  ImageLineRenderer(
    this._image, {
    Color? color,
    this.thickness = 1.0,
    this.cap = CapStyle.butt,
  }) : color = color ?? Color(0, 0, 0, 255);

  @override
  void semidot(CompareFunction cmp, int xc1, int yc1, int xc2, int yc2) {
    final double cx = xc1 / LineAABasics.line_subpixel_scale;
    final double cy = yc1 / LineAABasics.line_subpixel_scale;
    final double dx = (xc2 - xc1).toDouble();
    final double dy = (yc2 - yc1).toDouble();

    final double radius = thickness / 2 + 1.0;
    final int minX = (cx - radius).floor();
    final int maxX = (cx + radius).ceil();
    final int minY = (cy - radius).floor();
    final int maxY = (cy + radius).ceil();

    for (int y = minY; y <= maxY; y++) {
      if (y < 0 || y >= _image.height) continue;
      for (int x = minX; x <= maxX; x++) {
        if (x < 0 || x >= _image.width) continue;
        final double px = x + 0.5;
        final double py = y + 0.5;
        final double vx = px - cx;
        final double vy = py - cy;
        final double dist = math.sqrt(vx * vx + vy * vy);
        if (dist > radius + 1.0) continue;

        final int signed = (dx * (py - cy) - dy * (px - cx)).round();
        if (!cmp(signed)) continue;

        double cov = 1.0;
        if (dist > radius) {
          cov = (1.0 - (dist - radius)).clamp(0.0, 1.0);
        }
        _plot(x, y, cov);
      }
    }
  }

  @override
  void pie(int x1, int y1, int x2, int y2, int x3, int y3) {
    final double cx = x1 / LineAABasics.line_subpixel_scale;
    final double cy = y1 / LineAABasics.line_subpixel_scale;
    final double ax = (x2 - x1).toDouble();
    final double ay = (y2 - y1).toDouble();
    final double bx = (x3 - x1).toDouble();
    final double by = (y3 - y1).toDouble();

    final double radius = thickness / 2 + 1.0;
    final int minX = (cx - radius).floor();
    final int maxX = (cx + radius).ceil();
    final int minY = (cy - radius).floor();
    final int maxY = (cy + radius).ceil();

    final double crossAB = ax * by - ay * bx;

    for (int y = minY; y <= maxY; y++) {
      if (y < 0 || y >= _image.height) continue;
      for (int x = minX; x <= maxX; x++) {
        if (x < 0 || x >= _image.width) continue;
        final double px = x + 0.5 - cx;
        final double py = y + 0.5 - cy;
        final double dist = math.sqrt(px * px + py * py);
        if (dist > radius + 1.0) continue;

        final double crossAP = ax * py - ay * px;
        final double crossPB = px * by - py * bx;
        final bool inside = crossAB >= 0
            ? (crossAP >= 0 && crossPB >= 0)
            : (crossAP <= 0 && crossPB <= 0);
        if (!inside) continue;

        double cov = 1.0;
        if (dist > radius) {
          cov = (1.0 - (dist - radius)).clamp(0.0, 1.0);
        }
        _plot(x, y, cov);
      }
    }
  }

  @override
  void line0(LineParameters lp) {
    _drawAA(lp.x1, lp.y1, lp.x2, lp.y2);
  }

  @override
  void line1(LineParameters lp, int xb1, int yb1) {
    _drawAA(lp.x1, lp.y1, lp.x2, lp.y2);
  }

  @override
  void line2(LineParameters lp, int xb2, int yb2) {
    _drawAA(lp.x1, lp.y1, lp.x2, lp.y2);
  }

  @override
  void line3(LineParameters lp, int xb1, int yb1, int xb2, int yb2) {
    _drawAA(lp.x1, lp.y1, lp.x2, lp.y2);
  }

  void _drawAA(int sx, int sy, int ex, int ey) {
    final double x0 = sx / LineAABasics.line_subpixel_scale;
    final double y0 = sy / LineAABasics.line_subpixel_scale;
    final double x1 = ex / LineAABasics.line_subpixel_scale;
    final double y1 = ey / LineAABasics.line_subpixel_scale;

    // Calculate perpendicular direction for thickness
    final dx = x1 - x0;
    final dy = y1 - y0;
    final len = math.sqrt(dx * dx + dy * dy);
    
    if (len < 0.001) return;
    
    // Perpendicular unit vector
    final perpX = -dy / len;
    final perpY = dx / len;
    
    // For thickness of 1, just draw one line
    // For larger thickness, draw multiple parallel lines
    if (thickness <= 1.0) {
      _wuLine(x0, y0, x1, y1);
    } else {
      // Calculate number of strokes needed to fill the width
      // Each Wu line is approximately 1 pixel wide
      final int strokes = math.max(1, thickness.ceil());
      final double halfWidth = (thickness - 1) / 2.0;
      
      for (int i = 0; i < strokes; i++) {
        final double t = strokes > 1 ? i / (strokes - 1) : 0.5;
        final double offset = -halfWidth + t * (thickness - 1);
        _wuLine(
          x0 + perpX * offset,
          y0 + perpY * offset,
          x1 + perpX * offset,
          y1 + perpY * offset,
        );
      }
    }

    if (cap != CapStyle.butt) {
      _drawCap(x0, y0);
      _drawCap(x1, y1);
    }
  }

  void _drawCap(double x, double y) {
    final double radius = thickness / 2 + 1.0;
    final int minX = (x - radius).floor();
    final int maxX = (x + radius).ceil();
    final int minY = (y - radius).floor();
    final int maxY = (y + radius).ceil();
    for (int yy = minY; yy <= maxY; yy++) {
      for (int xx = minX; xx <= maxX; xx++) {
        if (cap == CapStyle.round) {
          final double dx = xx + 0.5 - x;
          final double dy = yy + 0.5 - y;
          if (math.sqrt(dx * dx + dy * dy) > radius) continue;
        }
        if (xx >= 0 && yy >= 0 && xx < _image.width && yy < _image.height) {
          _image.setPixel(xx, yy, color);
        }
      }
    }
  }

  void _plot(int x, int y, double c) {
    if (x < 0 || y < 0 || x >= _image.width || y >= _image.height) return;
    final int cov = (c.clamp(0.0, 1.0) * color.alpha).round();
    _image.blendPixel(x, y, color, cov);
  }

  void _wuLine(double x0, double y0, double x1, double y1) {
    // Xiaolin Wu line
    final bool steep = (y1 - y0).abs() > (x1 - x0).abs();
    if (steep) {
      final double tx0 = x0, ty0 = y0;
      x0 = ty0;
      y0 = tx0;
      final double tx1 = x1, ty1 = y1;
      x1 = ty1;
      y1 = tx1;
    }
    if (x0 > x1) {
      final double tx0 = x0, ty0 = y0;
      x0 = x1;
      y0 = y1;
      x1 = tx0;
      y1 = ty0;
    }
    final double dx = x1 - x0;
    final double dy = y1 - y0;
    final double gradient = dx == 0 ? 1.0 : dy / dx;

    // first endpoint
    double xend = x0.roundToDouble();
    double yend = y0 + gradient * (xend - x0);
    double xgap = rfpart(x0 + 0.5);
    int xpxl1 = xend.toInt();
    int ypxl1 = ipart(yend);
    if (steep) {
      _plot(ypxl1, xpxl1, rfpart(yend) * xgap);
      _plot(ypxl1 + 1, xpxl1, fpart(yend) * xgap);
    } else {
      _plot(xpxl1, ypxl1, rfpart(yend) * xgap);
      _plot(xpxl1, ypxl1 + 1, fpart(yend) * xgap);
    }
    double intery = yend + gradient;

    // second endpoint
    xend = x1.roundToDouble();
    yend = y1 + gradient * (xend - x1);
    xgap = fpart(x1 + 0.5);
    int xpxl2 = xend.toInt();
    int ypxl2 = ipart(yend);
    if (steep) {
      _plot(ypxl2, xpxl2, rfpart(yend) * xgap);
      _plot(ypxl2 + 1, xpxl2, fpart(yend) * xgap);
    } else {
      _plot(xpxl2, ypxl2, rfpart(yend) * xgap);
      _plot(xpxl2, ypxl2 + 1, fpart(yend) * xgap);
    }

    // main loop
    for (int x = xpxl1 + 1; x < xpxl2; x++) {
      if (steep) {
        _plot(ipart(intery), x, rfpart(intery));
        _plot(ipart(intery) + 1, x, fpart(intery));
      } else {
        _plot(x, ipart(intery), rfpart(intery));
        _plot(x, ipart(intery) + 1, fpart(intery));
      }
      intery += gradient;
    }
  }

  int ipart(double x) => x.floor();
  double fpart(double x) => x - x.floor();
  double rfpart(double x) => 1 - fpart(x);

}

enum CapStyle { butt, square, round }

/// Profile-based line renderer that mimics DartGraphics's outline AA using a precomputed
/// coverage profile (LineProfileAA). Simpler than the original but keeps
/// predictable falloff from the centerline.
class ProfileLineRenderer extends LineRenderer {
  final IImageByte _image;
  final LineProfileAA profile;
  Color color;
  RectangleInt? clipBox;
  CapStyle cap;

  ProfileLineRenderer(
    this._image, {
    required this.profile,
    Color? color,
    this.clipBox,
    this.cap = CapStyle.butt,
  }) : color = color ?? Color(0, 0, 0, 255);

  int get _subpixelScale => profile.subpixelScale;

  @override
  void line0(LineParameters lp) => _renderSegment(lp.x1, lp.y1, lp.x2, lp.y2);

  @override
  void line1(LineParameters lp, int xb1, int yb1) => line0(lp);

  @override
  void line2(LineParameters lp, int xb2, int yb2) => line0(lp);

  @override
  void line3(LineParameters lp, int xb1, int yb1, int xb2, int yb2) => line0(lp);

  @override
  void semidot(CompareFunction cmp, int xc1, int yc1, int xc2, int yc2) {
    final double cx = xc1 / _subpixelScale;
    final double cy = yc1 / _subpixelScale;
    final double dx = (xc2 - xc1).toDouble();
    final double dy = (yc2 - yc1).toDouble();

    final double radius = (profile.profileSize() - profile.subpixelScale * 2) /
        profile.subpixelScale;
    int minX = (cx - radius - 1).floor();
    int maxX = (cx + radius + 1).ceil();
    int minY = (cy - radius - 1).floor();
    int maxY = (cy + radius + 1).ceil();

    if (clipBox != null) {
      minX = math.max(minX, clipBox!.left);
      minY = math.max(minY, clipBox!.bottom);
      maxX = math.min(maxX, clipBox!.right);
      maxY = math.min(maxY, clipBox!.top);
    }

    for (int y = minY; y <= maxY; y++) {
      if (y < 0 || y >= _image.height) continue;
      for (int x = minX; x <= maxX; x++) {
        if (x < 0 || x >= _image.width) continue;
        final double px = x + 0.5;
        final double py = y + 0.5;
        final double vx = px - cx;
        final double vy = py - cy;
        final double dist = math.sqrt(vx * vx + vy * vy);
        final int signed = (dx * (py - cy) - dy * (px - cx)).round();
        if (!cmp(signed)) continue;

        final int cover = profile.value((dist * _subpixelScale).round());
        if (cover > 0) {
          _image.blendPixel(x, y, color, cover);
        }
      }
    }
  }

  @override
  void pie(int x1, int y1, int x2, int y2, int x3, int y3) {
    final double cx = x1 / _subpixelScale;
    final double cy = y1 / _subpixelScale;
    final double ax = (x2 - x1).toDouble();
    final double ay = (y2 - y1).toDouble();
    final double bx = (x3 - x1).toDouble();
    final double by = (y3 - y1).toDouble();

    final double radius = (profile.profileSize() - profile.subpixelScale * 2) /
        profile.subpixelScale;
    int minX = (cx - radius - 1).floor();
    int maxX = (cx + radius + 1).ceil();
    int minY = (cy - radius - 1).floor();
    int maxY = (cy + radius + 1).ceil();

    if (clipBox != null) {
      minX = math.max(minX, clipBox!.left);
      minY = math.max(minY, clipBox!.bottom);
      maxX = math.min(maxX, clipBox!.right);
      maxY = math.min(maxY, clipBox!.top);
    }

    final double crossAB = ax * by - ay * bx;

    for (int y = minY; y <= maxY; y++) {
      if (y < 0 || y >= _image.height) continue;
      for (int x = minX; x <= maxX; x++) {
        if (x < 0 || x >= _image.width) continue;
        final double px = x + 0.5 - cx;
        final double py = y + 0.5 - cy;
        final double dist = math.sqrt(px * px + py * py);
        final double crossAP = ax * py - ay * px;
        final double crossPB = px * by - py * bx;
        final bool inside = crossAB >= 0
            ? (crossAP >= 0 && crossPB >= 0)
            : (crossAP <= 0 && crossPB <= 0);
        if (!inside) continue;

        final int cover = profile.value((dist * _subpixelScale).round());
        if (cover > 0) {
          _image.blendPixel(x, y, color, cover);
        }
      }
    }
  }

  void _renderSegment(int sx, int sy, int ex, int ey) {
    final double x0 = sx / _subpixelScale;
    final double y0 = sy / _subpixelScale;
    final double x1 = ex / _subpixelScale;
    final double y1 = ey / _subpixelScale;

    final double dx = x1 - x0;
    final double dy = y1 - y0;
    final double segLen2 = dx * dx + dy * dy;
    if (segLen2 == 0) return;

    final double segLen = math.sqrt(segLen2);
    final double radius = (profile.profileSize() - profile.subpixelScale * 2) / profile.subpixelScale;
    int minX = (math.min(x0, x1) - radius - 1).floor();
    int maxX = (math.max(x0, x1) + radius + 1).ceil();
    int minY = (math.min(y0, y1) - radius - 1).floor();
    int maxY = (math.max(y0, y1) + radius + 1).ceil();

    if (clipBox != null) {
      minX = math.max(minX, clipBox!.left);
      minY = math.max(minY, clipBox!.bottom);
      maxX = math.min(maxX, clipBox!.right);
      maxY = math.min(maxY, clipBox!.top);
    }

    for (int y = minY; y <= maxY; y++) {
      if (y < 0 || y >= _image.height) continue;
      for (int x = minX; x <= maxX; x++) {
        if (x < 0 || x >= _image.width) continue;
        // Point-to-segment distance.
        final double px = x + 0.5;
        final double py = y + 0.5;
        final double tRaw = ((px - x0) * dx + (py - y0) * dy) / segLen2;

        if (cap == CapStyle.butt && (tRaw < 0.0 || tRaw > 1.0)) {
          continue;
        }

        double t;
        if (cap == CapStyle.square) {
          final double extend = segLen == 0 ? 0.0 : (radius / segLen);
          t = tRaw.clamp(-extend, 1.0 + extend);
        } else {
          t = tRaw.clamp(0.0, 1.0);
        }

        double projX = x0 + t * dx;
        double projY = y0 + t * dy;

        double dist;
        if (cap == CapStyle.round) {
          if (tRaw < 0.0) {
            dist = math.sqrt((px - x0) * (px - x0) + (py - y0) * (py - y0));
          } else if (tRaw > 1.0) {
            dist = math.sqrt((px - x1) * (px - x1) + (py - y1) * (py - y1));
          } else {
            dist = math.sqrt((projX - px) * (projX - px) + (projY - py) * (projY - py));
          }
        } else {
          dist = math.sqrt((projX - px) * (projX - px) + (projY - py) * (projY - py));
        }

        final int cover = profile.value((dist * _subpixelScale).round());
        if (cover > 0) {
          _image.blendPixel(x, y, color, cover);
        }
      }
    }
  }
}

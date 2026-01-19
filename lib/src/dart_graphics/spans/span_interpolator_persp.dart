import 'dart:math';
import 'package:dart_graphics/src/dart_graphics/dda_line.dart';
import 'package:dart_graphics/src/dart_graphics/transform/i_transform.dart';
import 'package:dart_graphics/src/dart_graphics/transform/affine.dart';
import 'package:dart_graphics/src/dart_graphics/transform/perspective.dart';
import 'package:dart_graphics/src/dart_graphics/util.dart';
import 'package:dart_graphics/src/dart_graphics/spans/span_interpolator_linear.dart';

class SpanInterpolatorPerspLerp implements ISpanInterpolator {
  Perspective m_trans_dir = Perspective();
  Perspective m_trans_inv = Perspective();
  late Dda2LineInterpolator m_coord_x;
  late Dda2LineInterpolator m_coord_y;
  late Dda2LineInterpolator m_scale_x;
  late Dda2LineInterpolator m_scale_y;

  static const int subpixelShift = 8;
  static const int subpixelScale = 1 << subpixelShift;

  SpanInterpolatorPerspLerp();

  // Arbitrary quadrangle transformations
  SpanInterpolatorPerspLerp.quadToQuad(List<double> src, List<double> dst) {
    m_trans_dir.quadToQuad(src, dst);
    m_trans_inv.quadToQuad(dst, src);
  }

  // Direct transformations
  SpanInterpolatorPerspLerp.rectToQuad(double x1, double y1, double x2, double y2, List<double> quad) {
    m_trans_dir.rectToQuad(x1, y1, x2, y2, quad);
    m_trans_inv.quadToRect(quad, x1, y1, x2, y2);
  }

  // Reverse transformations
  SpanInterpolatorPerspLerp.quadToRect(List<double> quad, double x1, double y1, double x2, double y2) {
    m_trans_dir.quadToRect(quad, x1, y1, x2, y2);
    m_trans_inv.rectToQuad(x1, y1, x2, y2, quad);
  }

  bool isValid() {
    return m_trans_dir.isValid();
  }

  @override
  void begin(double x, double y, int len) {
    // Calculate transformed coordinates at x1,y1
    double xt = x;
    double yt = y;
    var pt = [xt, yt];
    m_trans_dir.transform(pt);
    xt = pt[0];
    yt = pt[1];
    
    int x1 = Util.iround(xt * subpixelScale);
    int y1 = Util.iround(yt * subpixelScale);

    double dx;
    double dy;
    double delta = 1.0 / subpixelScale;

    // Calculate scale by X at x1,y1
    dx = xt + delta;
    dy = yt;
    pt = [dx, dy];
    m_trans_inv.transform(pt);
    dx = pt[0] - x;
    dy = pt[1] - y;
    int sx1 = Util.uround(subpixelScale / sqrt(dx * dx + dy * dy)) >> subpixelShift;

    // Calculate scale by Y at x1,y1
    dx = xt;
    dy = yt + delta;
    pt = [dx, dy];
    m_trans_inv.transform(pt);
    dx = pt[0] - x;
    dy = pt[1] - y;
    int sy1 = Util.uround(subpixelScale / sqrt(dx * dx + dy * dy)) >> subpixelShift;

    // Calculate transformed coordinates at x2,y2
    double x_end = x + len;
    xt = x_end;
    yt = y;
    pt = [xt, yt];
    m_trans_dir.transform(pt);
    xt = pt[0];
    yt = pt[1];
    
    int x2 = Util.iround(xt * subpixelScale);
    int y2 = Util.iround(yt * subpixelScale);

    // Calculate scale by X at x2,y2
    dx = xt + delta;
    dy = yt;
    pt = [dx, dy];
    m_trans_inv.transform(pt);
    dx = pt[0] - x_end;
    dy = pt[1] - y;
    int sx2 = Util.uround(subpixelScale / sqrt(dx * dx + dy * dy)) >> subpixelShift;

    // Calculate scale by Y at x2,y2
    dx = xt;
    dy = yt + delta;
    pt = [dx, dy];
    m_trans_inv.transform(pt);
    dx = pt[0] - x_end;
    dy = pt[1] - y;
    int sy2 = Util.uround(subpixelScale / sqrt(dx * dx + dy * dy)) >> subpixelShift;

    // Initialize the interpolators
    m_coord_x = Dda2LineInterpolator.forward(x1, x2, len);
    m_coord_y = Dda2LineInterpolator.forward(y1, y2, len);
    m_scale_x = Dda2LineInterpolator.forward(sx1, sx2, len);
    m_scale_y = Dda2LineInterpolator.forward(sy1, sy2, len);
  }

  @override
  void resynchronize(double xe, double ye, int len) {
    // Assume x1,y1 are equal to the ones at the previous end point
    int x1 = m_coord_x.y();
    int y1 = m_coord_y.y();
    int sx1 = m_scale_x.y();
    int sy1 = m_scale_y.y();

    // Calculate transformed coordinates at x2,y2
    double xt = xe;
    double yt = ye;
    var pt = [xt, yt];
    m_trans_dir.transform(pt);
    xt = pt[0];
    yt = pt[1];
    
    int x2 = Util.iround(xt * subpixelScale);
    int y2 = Util.iround(yt * subpixelScale);

    double delta = 1.0 / subpixelScale;
    double dx;
    double dy;

    // Calculate scale by X at x2,y2
    dx = xt + delta;
    dy = yt;
    pt = [dx, dy];
    m_trans_inv.transform(pt);
    dx = pt[0] - xe;
    dy = pt[1] - ye;
    int sx2 = Util.uround(subpixelScale / sqrt(dx * dx + dy * dy)) >> subpixelShift;

    // Calculate scale by Y at x2,y2
    dx = xt;
    dy = yt + delta;
    pt = [dx, dy];
    m_trans_inv.transform(pt);
    dx = pt[0] - xe;
    dy = pt[1] - ye;
    int sy2 = Util.uround(subpixelScale / sqrt(dx * dx + dy * dy)) >> subpixelShift;

    // Initialize the interpolators
    m_coord_x = Dda2LineInterpolator.forward(x1, x2, len);
    m_coord_y = Dda2LineInterpolator.forward(y1, y2, len);
    m_scale_x = Dda2LineInterpolator.forward(sx1, sx2, len);
    m_scale_y = Dda2LineInterpolator.forward(sy1, sy2, len);
  }

  @override
  ITransform transformer() {
    return m_trans_dir;
  }

  @override
  void setTransformer(ITransform trans) {
    if (trans is Perspective) {
      m_trans_dir = Perspective.copy(trans);
      m_trans_inv = Perspective.copy(trans)..invert();
    } else if (trans is Affine) {
      m_trans_dir = Perspective.fromAffine(trans);
      m_trans_inv = Perspective.fromAffine(trans)..invert();
    } else {
      // Fallback: identity
      m_trans_dir = Perspective();
      m_trans_inv = Perspective();
    }
  }

  @override
  void next() {
    m_coord_x.next();
    m_coord_y.next();
    m_scale_x.next();
    m_scale_y.next();
  }

  @override
  void coordinates(List<int> xy) {
    xy[0] = m_coord_x.y();
    xy[1] = m_coord_y.y();
  }

  @override
  void localScale(List<int> xy) {
    xy[0] = m_scale_x.y();
    xy[1] = m_scale_y.y();
  }

  void transform(List<double> xy) {
    m_trans_dir.transform(xy);
  }
}

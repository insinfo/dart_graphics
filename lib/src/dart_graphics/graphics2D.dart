import 'package:dart_graphics/src/dart_graphics/image/iimage.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'dart:math' as math;
import 'package:dart_graphics/src/dart_graphics/basics.dart';
import 'package:dart_graphics/src/dart_graphics/line_aa_basics.dart';
import 'package:dart_graphics/src/dart_graphics/outline_image_renderer.dart';
import 'package:dart_graphics/src/dart_graphics/line_profile_aa.dart';
import 'package:dart_graphics/src/dart_graphics/rasterizer_compound_aa.dart';
import 'package:dart_graphics/src/dart_graphics/rasterizer_outline_aa.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_renderer.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_rasterizer.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_unpacked8.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/ivertex_source.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/vertex_storage.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/arc.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/ellipse.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/glyph_vertex_source.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/rounded_rect.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/stroke.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/stroke_math.dart'
    as stroke_math;
import 'package:dart_graphics/src/dart_graphics/vertex_source/apply_transform.dart';

import 'package:dart_graphics/src/typography/openfont/typeface.dart';
import 'package:dart_graphics/src/typography/text_layout/glyph_layout.dart';
import 'package:dart_graphics/src/typography/text_layout/glyph_plan.dart';
import 'package:dart_graphics/src/dart_graphics/svg/svg_parser_new.dart';
import 'package:dart_graphics/src/dart_graphics/svg/svg_shape.dart';
import 'package:dart_graphics/src/dart_graphics/svg/svg_paint.dart';
import 'package:dart_graphics/src/dart_graphics/spans/span_allocator.dart';
import 'package:dart_graphics/src/dart_graphics/spans/span_gradient.dart';
import 'package:dart_graphics/src/dart_graphics/spans/span_generator.dart';
import 'package:dart_graphics/src/dart_graphics/spans/span_image_filter_rgba.dart';
import 'package:dart_graphics/src/dart_graphics/spans/span_interpolator_linear.dart';
import 'package:dart_graphics/src/dart_graphics/spans/span_pattern.dart';
import 'package:dart_graphics/src/dart_graphics/image/raster_buffer_accessors.dart';
import 'package:dart_graphics/src/dart_graphics/image_filters.dart';
import 'package:dart_graphics/src/dart_graphics/transform/affine.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/pattern_repetition.dart';
// import 'package:dart_graphics/src/shared/canvas2d/canvas_pattern.dart'; // Deprecated/Experimental for core.

abstract class IStyleHandler {
  bool is_solid(int style);
}

enum TransformQuality { Fastest, Best }

enum LineJoin { miter, round, bevel }

enum LineCap { butt, square, round }

enum GradientType { solid, linear, radial }

enum ImageFilter { none, bilinear, bicubic, spline16, spline36, blackman144 }

enum ImageResample { noResample, resampleAlways, resampleOnZoomOut }

enum BlendMode {
  alpha,
  clear,
  src,
  dst,
  srcOver,
  dstOver,
  srcIn,
  dstIn,
  srcOut,
  dstOut,
  srcAtop,
  dstAtop,
  xor,
  add,
  multiply,
  screen,
  overlay,
  darken,
  lighten,
  colorDodge,
  colorBurn,
  hardLight,
  softLight,
  difference,
  exclusion,
}

enum DrawPathFlag { fillOnly, strokeOnly, fillAndStroke, fillWithLineColor }

enum FillStyleType { solid, gradient, pattern }

enum TextAlign { left, center, right, start, end }

enum TextBaseline { alphabetic, top, middle, bottom }

/// Minimal graphics context binding an image, rasterizer and scanline cache.
abstract class Graphics2D {
  TransformQuality _imageRenderQuality = TransformQuality.Fastest;
  TransformQuality get imageRenderQuality => _imageRenderQuality;
  set imageRenderQuality(TransformQuality v) => _imageRenderQuality = v;

  final List<Affine> _transformStack = [Affine.identity()];
  final VertexStorage _path = VertexStorage();

  LineJoin _lineJoin = LineJoin.miter;
  LineCap _lineCap = LineCap.butt;
  double _lineWidth = 1.0;
  Color _strokeColor = Color(0, 0, 0, 255);
  Color _fillColor = Color(255, 255, 255, 255);
  double _masterAlpha = 1.0;
  double _antiAliasGamma = 1.0;
  double _miterLimit = 4.0;
  BlendMode _blendMode = BlendMode.alpha;
  ImageFilter _imageFilter = ImageFilter.bilinear;
  ImageResample _imageResample = ImageResample.noResample;

  GradientType _gradientType = GradientType.solid;
  FillStyleType _fillStyleType = FillStyleType.solid;
  double _gradientX1 = 0.0;
  double _gradientY1 = 0.0;
  double _gradientX2 = 1.0;
  double _gradientY2 = 0.0;
  double _gradientCx = 0.0;
  double _gradientCy = 0.0;
  double _gradientRadius = 1.0;
  final List<({double offset, Color color})> _gradientStops = [];

  IImageByte? _patternImage;
  DartGraphicsPatternRepetition _patternRepetition = DartGraphicsPatternRepetition.repeat;
  Affine _patternTransform = Affine.identity();

  Typeface? _typeface;
  double _fontSize = 16.0;
  TextAlign _textAlign = TextAlign.left;
  TextBaseline _textBaseline = TextBaseline.alphabetic;

  int get width;
  int get height;

  void clear(Color color);

  void renderPath(IVertexSource src, Color color);

  void renderSpanPath(IVertexSource src, ISpanGenerator generator);

  void renderGradientPath(IVertexSource src, SpanGradient gradient) {
    renderSpanPath(src, gradient);
  }

  Affine get transform => _transformStack.last;

  LineJoin get lineJoin => _lineJoin;
  set lineJoin(LineJoin value) => _lineJoin = value;

  LineCap get lineCap => _lineCap;
  set lineCap(LineCap value) => _lineCap = value;

  double get lineWidth => _lineWidth;
  set lineWidth(double value) {
    if (value > 0) _lineWidth = value;
  }

  Color get strokeColor => _strokeColor;
  set strokeColor(Color value) => _strokeColor = value;

  Color get fillColor => _fillColor;
  set fillColor(Color value) => _fillColor = value;

  double get masterAlpha => _masterAlpha;
  set masterAlpha(double value) => _masterAlpha = value.clamp(0.0, 1.0);

  double get antiAliasGamma => _antiAliasGamma;
  set antiAliasGamma(double value) =>
      _antiAliasGamma = value <= 0 ? 1.0 : value;

  double get miterLimit => _miterLimit;
  set miterLimit(double value) => _miterLimit = value <= 0 ? 4.0 : value;

  BlendMode get blendMode => _blendMode;
  set blendMode(BlendMode value) => _blendMode = value;

  ImageFilter get imageFilter => _imageFilter;
  set imageFilter(ImageFilter value) => _imageFilter = value;

  ImageResample get imageResample => _imageResample;
  set imageResample(ImageResample value) => _imageResample = value;

  GradientType get gradientType => _gradientType;

  FillStyleType get fillStyleType => _fillStyleType;

  Typeface? get typeface => _typeface;
  set typeface(Typeface? value) => _typeface = value;

  double get fontSize => _fontSize;
  set fontSize(double value) => _fontSize = value > 0 ? value : _fontSize;

  TextAlign get textAlign => _textAlign;
  set textAlign(TextAlign value) => _textAlign = value;

  TextBaseline get textBaseline => _textBaseline;
  set textBaseline(TextBaseline value) => _textBaseline = value;

  void save() {
    _transformStack.add(_cloneAffine(transform));
  }

  void restore() {
    if (_transformStack.length > 1) {
      _transformStack.removeLast();
    }
  }

  void resetTransform() {
    _transformStack
      ..clear()
      ..add(Affine.identity());
  }

  void translate(double dx, double dy) {
    _transformStack.last.translate(dx, dy);
  }

  void scale(double sx, [double? sy]) {
    _transformStack.last.scale(sx, sy);
  }

  void rotate(double angle) {
    _transformStack.last.rotate(angle);
  }

  void skew(double sx, double sy) {
    _transformStack.last.multiply(Affine.skewing(sx, sy));
  }

  void setTransform(Affine matrix) {
    _transformStack[_transformStack.length - 1] = _cloneAffine(matrix);
  }

  void setSolidFill() {
    _fillStyleType = FillStyleType.solid;
    _gradientType = GradientType.solid;
    _gradientStops.clear();
  }

  void setLinearGradient(double x1, double y1, double x2, double y2,
      List<({double offset, Color color})> stops) {
    _fillStyleType = FillStyleType.gradient;
    _gradientType = GradientType.linear;
    _gradientX1 = x1;
    _gradientY1 = y1;
    _gradientX2 = x2;
    _gradientY2 = y2;
    _gradientStops
      ..clear()
      ..addAll(stops);
  }

  void setRadialGradient(double cx, double cy, double radius,
      List<({double offset, Color color})> stops) {
    _fillStyleType = FillStyleType.gradient;
    _gradientType = GradientType.radial;
    _gradientCx = cx;
    _gradientCy = cy;
    _gradientRadius = radius;
    _gradientStops
      ..clear()
      ..addAll(stops);
  }

  void clearGradientStops() => _gradientStops.clear();

  void addGradientStop(double offset, Color color) {
    _gradientStops.add((offset: offset, color: color));
  }

  void setPatternFill(
    IImageByte image, {
    DartGraphicsPatternRepetition repetition = DartGraphicsPatternRepetition.repeat,
    Affine? transform,
  }) {
    _fillStyleType = FillStyleType.pattern;
    _patternImage = image;
    _patternRepetition = repetition;
    _patternTransform =
        transform == null ? Affine.identity() : _cloneAffine(transform);
  }

  void setPatternTransform(Affine transform) {
    _patternTransform = _cloneAffine(transform);
  }

  void clearPattern() {
    _patternImage = null;
    _fillStyleType = FillStyleType.solid;
  }

  void setFont(Typeface typeface, double pixelSize) {
    _typeface = typeface;
    if (pixelSize > 0) _fontSize = pixelSize;
  }

  void drawTextCurrent(String text,
      {double x = 0, double y = 0, Color? color}) {
    final tf = _typeface;
    if (tf == null) return;
    final paint = applyMasterAlpha(color ?? _fillColor);
    _drawTextInternal(text, tf, _fontSize, paint, x, y,
        align: _textAlign, baseline: _textBaseline);
  }

  VertexStorage get currentPath => _path;

  void beginPath() => _path.clear();

  void resetPath() => _path.clear();

  void moveTo(double x, double y) => _path.moveTo(x, y);

  void lineTo(double x, double y) => _path.lineTo(x, y);

  void curve3(double ctrlX, double ctrlY, double toX, double toY) =>
      _path.curve3(ctrlX, ctrlY, toX, toY);

  void curve4(double ctrl1X, double ctrl1Y, double ctrl2X, double ctrl2Y,
          double toX, double toY) =>
      _path.curve4(ctrl1X, ctrl1Y, ctrl2X, ctrl2Y, toX, toY);

  void closePath() => _path.closePath();

  void rect(double x1, double y1, double x2, double y2) {
    _path
      ..moveTo(x1, y1)
      ..lineTo(x2, y1)
      ..lineTo(x2, y2)
      ..lineTo(x1, y2)
      ..closePath();
  }

  void roundedRect(double x1, double y1, double x2, double y2,
      [double radius = 0]) {
    _appendVertices(RoundedRect(x1, y1, x2, y2, radius));
  }

  void ellipse(double cx, double cy, double rx, double ry,
      [int numSteps = 0, bool clockwise = false]) {
    _appendVertices(Ellipse(cx, cy, rx, ry, numSteps, clockwise));
  }

  void arc(double cx, double cy, double rx, double ry, double startAngle,
      double endAngle,
      [bool counterClockwise = false, int numSegments = 0]) {
    final dir = counterClockwise
        ? ArcDirection.counterClockWise
        : ArcDirection.clockWise;
    _appendVertices(
        Arc(cx, cy, rx, ry, startAngle, endAngle, dir, numSegments));
  }

  void drawPath([DrawPathFlag flag = DrawPathFlag.fillOnly]) {
    switch (flag) {
      case DrawPathFlag.fillOnly:
        fillPath();
        break;
      case DrawPathFlag.strokeOnly:
        strokePath();
        break;
      case DrawPathFlag.fillAndStroke:
        fillPath();
        strokePath();
        break;
      case DrawPathFlag.fillWithLineColor:
        fillPath(colorOverride: strokeColor);
        break;
    }
  }

  void drawImage(
    IImageByte image,
    double dx,
    double dy, [
    double? dWidth,
    double? dHeight,
    double? sx,
    double? sy,
    double? sWidth,
    double? sHeight,
  ]) {
    final srcX = sx ?? 0.0;
    final srcY = sy ?? 0.0;
    final srcW = sWidth ?? image.width.toDouble();
    final srcH = sHeight ?? image.height.toDouble();
    final dstW = dWidth ?? srcW;
    final dstH = dHeight ?? srcH;

    if (srcW <= 0 || srcH <= 0 || dstW == 0 || dstH == 0) return;

    final path = VertexStorage()
      ..moveTo(dx, dy)
      ..lineTo(dx + dstW, dy)
      ..lineTo(dx + dstW, dy + dstH)
      ..lineTo(dx, dy + dstH)
      ..closePath();

    final scaleX = srcW / dstW;
    final scaleY = srcH / dstH;
    final userToSrc =
        Affine(scaleX, 0, 0, scaleY, srcX - dx * scaleX, srcY - dy * scaleY);

    final invT = _cloneAffine(transform);
    if (invT.determinant().abs() > 1e-12) {
      invT.invert();
    } else {
      invT.reset();
    }
    final deviceToSrc = _cloneAffine(userToSrc)..multiply(invT);

    final interpolator = SpanInterpolatorLinear(deviceToSrc);
    final accessor = ImageBufferAccessorClamp(image);
    final effectiveFilter = _effectiveImageFilter();
    final effectiveResample = _effectiveImageResample(effectiveFilter);
    final generator = _buildImageSpanGenerator(
      accessor,
      interpolator,
      srcW,
      srcH,
      dstW,
      dstH,
      effectiveFilter,
      effectiveResample,
    );

    renderSpanPath(applyTransform(path), _applySpanAlpha(generator));
  }

  void fillPath({Color? colorOverride}) {
    if (_path.isEmpty) return;
    if (colorOverride != null || _fillStyleType == FillStyleType.solid) {
      final paint = applyMasterAlpha(colorOverride ?? _fillColor);
      renderPath(applyTransform(_path), paint);
      return;
    }

    if (_fillStyleType == FillStyleType.gradient) {
      final gradient = _buildGradient();
      if (gradient == null) {
        final paint = applyMasterAlpha(colorOverride ?? _fillColor);
        renderPath(applyTransform(_path), paint);
        return;
      }
      renderGradientPath(applyTransform(_path), gradient);
      return;
    }

    final pattern = _buildPattern();
    if (pattern == null) {
      final paint = applyMasterAlpha(colorOverride ?? _fillColor);
      renderPath(applyTransform(_path), paint);
      return;
    }
    renderSpanPath(applyTransform(_path), pattern);
  }

  void strokePath({Color? colorOverride}) {
    if (_path.isEmpty || _lineWidth <= 0) return;
    final stroke = Stroke(_path, _lineWidth)
      ..lineJoin = _mapLineJoin(_lineJoin)
      ..lineCap = _mapLineCap(_lineCap)
      ..miterLimit = _miterLimit;
    final paint = applyMasterAlpha(colorOverride ?? _strokeColor);
    renderPath(applyTransform(stroke), paint);
  }

  IVertexSource applyTransform(IVertexSource src) {
    if (_isIdentity(transform)) return src;
    return ApplyTransform(src, _cloneAffine(transform));
  }

  SpanGradient? _buildGradient() {
    if (_gradientStops.isEmpty) return null;
    switch (_gradientType) {
      case GradientType.linear:
        final p1 = _transformPoint(_gradientX1, _gradientY1, transform);
        final p2 = _transformPoint(_gradientX2, _gradientY2, transform);
        final g = SpanGradientLinear(p1.x, p1.y, p2.x, p2.y);
        g.buildLut(_gradientStops
            .map((s) => (offset: s.offset, color: applyMasterAlpha(s.color)))
            .toList());
        return g;
      case GradientType.radial:
        final c = _transformPoint(_gradientCx, _gradientCy, transform);
        final radius = _scaleRadius(_gradientRadius, transform);
        final g = SpanGradientRadial(c.x, c.y, radius);
        g.buildLut(_gradientStops
            .map((s) => (offset: s.offset, color: applyMasterAlpha(s.color)))
            .toList());
        return g;
      case GradientType.solid:
        return null;
    }
  }

  ISpanGenerator _buildImageSpanGenerator(
    IImageBufferAccessor accessor,
    ISpanInterpolator interpolator,
    double srcW,
    double srcH,
    double dstW,
    double dstH,
    ImageFilter filter,
    ImageResample resample,
  ) {
    final useResample = _shouldResample(srcW, srcH, dstW, dstH, resample);
    final lut = _buildImageFilterLut(filter);

    if (useResample) {
      final ImageFilterLookUpTable filter =
          lut ?? ImageFilterLookUpTable(ImageFilterBilinear());
      return SpanImageResampleRgba(accessor, interpolator, filter);
    }

    switch (filter) {
      case ImageFilter.none:
        return SpanImageFilterRgbaNn(accessor, interpolator);
      case ImageFilter.bilinear:
        return SpanImageFilterRgbaBilinear(accessor, interpolator);
      case ImageFilter.bicubic:
      case ImageFilter.spline16:
      case ImageFilter.spline36:
      case ImageFilter.blackman144:
        final ImageFilterLookUpTable filter =
            lut ?? ImageFilterLookUpTable(ImageFilterBilinear());
        return SpanImageFilterRgba(accessor, interpolator, filter);
    }
  }

  ImageFilterLookUpTable? _buildImageFilterLut(ImageFilter filter) {
    final f = _imageFilterFunction(filter);
    if (f == null) return null;
    return ImageFilterLookUpTable(f);
  }

  IImageFilterFunction? _imageFilterFunction(ImageFilter filter) {
    switch (filter) {
      case ImageFilter.none:
        return null;
      case ImageFilter.bilinear:
        return ImageFilterBilinear();
      case ImageFilter.bicubic:
        return ImageFilterBicubic();
      case ImageFilter.spline16:
        return ImageFilterSpline16();
      case ImageFilter.spline36:
        return ImageFilterSpline36();
      case ImageFilter.blackman144:
        return ImageFilterBlackman(6.0);
    }
  }

  bool _shouldResample(
      double srcW, double srcH, double dstW, double dstH, ImageResample resample) {
    switch (resample) {
      case ImageResample.noResample:
        return false;
      case ImageResample.resampleAlways:
        return true;
      case ImageResample.resampleOnZoomOut:
        return dstW.abs() < srcW.abs() || dstH.abs() < srcH.abs();
    }
  }

  ImageFilter _effectiveImageFilter() {
    switch (_imageRenderQuality) {
      case TransformQuality.Fastest:
        return ImageFilter.none;
      case TransformQuality.Best:
        return _imageFilter == ImageFilter.none
            ? ImageFilter.bilinear
            : _imageFilter;
    }
  }

  ImageResample _effectiveImageResample(ImageFilter filter) {
    switch (_imageRenderQuality) {
      case TransformQuality.Fastest:
        return ImageResample.noResample;
      case TransformQuality.Best:
        if (_imageResample != ImageResample.noResample) {
          return _imageResample;
        }
        return filter == ImageFilter.none
            ? ImageResample.noResample
            : ImageResample.resampleOnZoomOut;
    }
  }

  ISpanGenerator _applySpanAlpha(ISpanGenerator generator) {
    if (_masterAlpha >= 1.0) return generator;
    return _SpanGeneratorAlpha(generator, _masterAlpha);
  }

  /// Render a complex SVG string (fills, strokes, gradients) into this context.
  ///
  /// If [viewBoxWidth]/[viewBoxHeight] are provided, the SVG coordinates are
  /// mapped to the current surface size. When omitted, it assumes a viewBox
  /// of (0,0,width,height).
  void renderSvgString(
    String svgString, {
    double? viewBoxX,
    double? viewBoxY,
    double? viewBoxWidth,
    double? viewBoxHeight,
    bool flipY = false,
    Color? background,
  }) {
    if (background != null) {
      clear(background);
    }

    final shapes = SvgParserNew.parse(svgString);
    if (shapes.isEmpty) return;

    final vbX = viewBoxX ?? 0.0;
    final vbY = viewBoxY ?? 0.0;
    final vbW = viewBoxWidth ?? width.toDouble();
    final vbH = viewBoxHeight ?? height.toDouble();

    final sx = vbW == 0 ? 1.0 : width / vbW;
    final sy = vbH == 0 ? 1.0 : height / vbH;

    final viewTransform = Affine.translation(-vbX, -vbY);
    viewTransform.premultiply(Affine.scaling(sx, sy));

    if (flipY) {
      viewTransform.premultiply(Affine.translation(0, height.toDouble()));
      viewTransform.premultiply(Affine.scaling(1, -1));
    }

    final strokeScale = (sx.abs() + sy.abs()) * 0.5;

    for (final shape in shapes) {
      final transformedPath = ApplyTransform(shape.path, _cloneAffine(viewTransform));
      _renderSvgShape(transformedPath, shape, viewTransform, strokeScale);
    }
  }

  void _renderSvgShape(
    IVertexSource path,
    SvgShape shape,
    Affine viewTransform,
    double strokeScale,
  ) {
    if (shape.fill != null) {
      final paint = _applyViewBoxToSvgPaint(shape.fill!, viewTransform);
      final opacity = (shape.opacity * shape.fillOpacity).clamp(0.0, 1.0);
      _renderSvgPaintWithOpacity(path, paint, opacity);
    }

    if (shape.stroke != null && shape.strokeWidth > 0) {
      final stroke = Stroke(path, shape.strokeWidth * strokeScale)
        ..lineCap = _mapSvgLineCap(shape.strokeLineCap)
        ..lineJoin = _mapSvgLineJoin(shape.strokeLineJoin)
        ..miterLimit = shape.strokeMiterLimit;

      final paint = _applyViewBoxToSvgPaint(shape.stroke!, viewTransform);
      final opacity = (shape.opacity * shape.strokeOpacity).clamp(0.0, 1.0);
      _renderSvgPaintWithOpacity(stroke, paint, opacity);
    }
  }

  void _renderSvgPaintWithOpacity(
    IVertexSource path,
    SvgPaint paint,
    double opacity,
  ) {
    if (paint is SvgPaintSolid) {
      final color = _applySvgOpacity(paint.color, opacity);
      renderPath(applyTransform(path), color);
    } else if (paint is SvgPaintLinearGradient) {
      final gradient = SpanGradientLinear(paint.x1, paint.y1, paint.x2, paint.y2);
      gradient.buildLut(paint.stops
          .map((s) => (offset: s.offset, color: _applySvgOpacity(s.color, opacity)))
          .toList());
      renderSpanPath(applyTransform(path), gradient);
    } else if (paint is SvgPaintRadialGradient) {
      final gradient = SpanGradientRadial(paint.cx, paint.cy, paint.r);
      gradient.buildLut(paint.stops
          .map((s) => (offset: s.offset, color: _applySvgOpacity(s.color, opacity)))
          .toList());
      renderSpanPath(applyTransform(path), gradient);
    }
  }

  SvgPaint _applyViewBoxToSvgPaint(SvgPaint paint, Affine viewTransform) {
    if (paint is SvgPaintLinearGradient) {
      final p1 = viewTransform.transformPoint(paint.x1, paint.y1);
      final p2 = viewTransform.transformPoint(paint.x2, paint.y2);
      return SvgPaintLinearGradient(
        id: paint.id,
        x1: p1.x,
        y1: p1.y,
        x2: p2.x,
        y2: p2.y,
        stops: paint.stops,
        gradientTransform: null,
        userSpaceOnUse: true,
      );
    }
    if (paint is SvgPaintRadialGradient) {
      final c = viewTransform.transformPoint(paint.cx, paint.cy);
      final f = viewTransform.transformPoint(paint.fx, paint.fy);
      final r = _scaleRadius(paint.r, viewTransform);
      return SvgPaintRadialGradient(
        id: paint.id,
        cx: c.x,
        cy: c.y,
        r: r,
        fx: f.x,
        fy: f.y,
        stops: paint.stops,
        gradientTransform: null,
        userSpaceOnUse: true,
      );
    }
    return paint;
  }

  Color _applySvgOpacity(Color color, double opacity) {
    if (opacity >= 1.0) return applyMasterAlpha(color);
    final alpha = (color.alpha * opacity).round().clamp(0, 255);
    return applyMasterAlpha(Color(color.red, color.green, color.blue, alpha));
  }

  stroke_math.LineCap _mapSvgLineCap(StrokeLineCap cap) {
    switch (cap) {
      case StrokeLineCap.round:
        return stroke_math.LineCap.round;
      case StrokeLineCap.square:
        return stroke_math.LineCap.square;
      case StrokeLineCap.butt:
        return stroke_math.LineCap.butt;
    }
  }

  stroke_math.LineJoin _mapSvgLineJoin(StrokeLineJoin join) {
    switch (join) {
      case StrokeLineJoin.round:
        return stroke_math.LineJoin.round;
      case StrokeLineJoin.bevel:
        return stroke_math.LineJoin.bevel;
      case StrokeLineJoin.miter:
        return stroke_math.LineJoin.miter;
    }
  }

  void _drawTextInternal(
    String text,
    Typeface typeface,
    double pixelSize,
    Color color,
    double x,
    double y, {
    TextAlign align = TextAlign.left,
    TextBaseline baseline = TextBaseline.top,
  }) {
    if (pixelSize <= 0) return;
    final layout = GlyphLayout()..typeface = typeface;
    final scale = typeface.calculateScaleToPixel(pixelSize);
    final ascender = typeface.ascender * scale;
    final descender = typeface.descender * scale;
    layout.layout(text);
    final plans = layout.generateGlyphPlans(scale);

    final textWidth = _measureTextWidth(plans);
    final startX = x + _alignOffset(textWidth, align);
    final baselineY = _baselineOffset(y, ascender, descender, baseline);

    // Support for gradient text
    SpanGradient? gradient;
    if (_fillStyleType == FillStyleType.gradient) {
      gradient = _buildGradient();
    }

    // Text glyphs benefit from even-odd fill to preserve counters
    final bool useEvenOdd = this is BasicGraphics2D;
    if (useEvenOdd) {
      (this as BasicGraphics2D)
          .rasterizer
          .fillingRule(FillingRuleE.fillEvenOdd);
    }

    for (final plan in plans.plans) {
      final glyph = typeface.getGlyph(plan.glyphIndex);
      final glyphSource = GlyphVertexSource(glyph);
      final mtx = Affine.identity();
      mtx.scale(scale, -scale);
      mtx.translate(startX + plan.x, baselineY - plan.y);
      final transSource = ApplyTransform(glyphSource, mtx);
      if (gradient != null) {
        renderGradientPath(applyTransform(transSource), gradient);
      } else {
        renderPath(applyTransform(transSource), color);
      }
    }

    if (useEvenOdd) {
      (this as BasicGraphics2D)
          .rasterizer
          .fillingRule(FillingRuleE.fillNonZero);
    }
  }

  double _measureTextWidth(GlyphPlanSequence plans) {
    if (plans.count == 0) return 0.0;
    var maxX = 0.0;
    for (final plan in plans.plans) {
      final end = plan.x + plan.advanceX;
      if (end > maxX) maxX = end;
    }
    return maxX;
  }

  double _alignOffset(double width, TextAlign align) {
    switch (align) {
      case TextAlign.center:
        return -width * 0.5;
      case TextAlign.right:
      case TextAlign.end:
        return -width;
      case TextAlign.left:
      case TextAlign.start:
        return 0.0;
    }
  }

  double _baselineOffset(
      double y, double ascender, double descender, TextBaseline baseline) {
    switch (baseline) {
      case TextBaseline.top:
        return y + ascender;
      case TextBaseline.bottom:
        return y + descender;
      case TextBaseline.middle:
        return y + (ascender + descender) * 0.5;
      case TextBaseline.alphabetic:
        return y;
    }
  }

  ISpanGenerator? _buildPattern() {
    final image = _patternImage;
    if (image == null) return null;
    return SpanPatternImage(
      image,
      _patternRepetition,
      _patternTransform,
      masterAlpha: _masterAlpha,
    );
  }

  double _scaleRadius(double r, Affine t) {
    final sx = (t.sx.abs() + t.shx.abs());
    final sy = (t.sy.abs() + t.shy.abs());
    final scale = (sx + sy) * 0.5;
    return r * (scale == 0 ? 1.0 : scale);
  }

  Color applyMasterAlpha(Color color) {
    final alpha = (color.alpha * _masterAlpha).round().clamp(0, 255);
    if (alpha == color.alpha) return color;
    return Color(color.red, color.green, color.blue, alpha);
  }

  void _appendVertices(IVertexSource source, {bool connect = false}) {
    bool hasCurrent = _path.count > 0;
    for (final v in source.vertices()) {
      if (v.command.isStop) break;
      if (v.command.isMoveTo && connect && hasCurrent) {
        _path.lineTo(v.x, v.y);
      } else {
        _path.addVertex(v.x, v.y, v.command);
      }
    }
  }

  stroke_math.LineCap _mapLineCap(LineCap cap) {
    switch (cap) {
      case LineCap.square:
        return stroke_math.LineCap.square;
      case LineCap.round:
        return stroke_math.LineCap.round;
      case LineCap.butt:
        return stroke_math.LineCap.butt;
    }
  }

  stroke_math.LineJoin _mapLineJoin(LineJoin join) {
    switch (join) {
      case LineJoin.round:
        return stroke_math.LineJoin.round;
      case LineJoin.bevel:
        return stroke_math.LineJoin.bevel;
      case LineJoin.miter:
        return stroke_math.LineJoin.miter;
    }
  }

  math.Point<double> _transformPoint(double x, double y, Affine t) {
    final tx = x * t.sx + y * t.shx + t.tx;
    final ty = x * t.shy + y * t.sy + t.ty;
    return math.Point(tx, ty);
  }

  bool _isIdentity(Affine a) {
    const eps = 1e-10;
    return (a.sx - 1.0).abs() < eps &&
        a.shy.abs() < eps &&
        a.shx.abs() < eps &&
        (a.sy - 1.0).abs() < eps &&
        a.tx.abs() < eps &&
        a.ty.abs() < eps;
  }

  Affine _cloneAffine(Affine src) {
    return Affine(src.sx, src.shy, src.shx, src.sy, src.tx, src.ty);
  }
}

class _SpanGeneratorAlpha implements ISpanGenerator {
  final ISpanGenerator _inner;
  final double _alpha;

  _SpanGeneratorAlpha(this._inner, this._alpha);

  @override
  void prepare() => _inner.prepare();

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    _inner.generate(span, spanIndex, x, y, len);
    if (_alpha >= 1.0) return;
    final end = spanIndex + len;
    for (int i = spanIndex; i < end; i++) {
      final c = span[i];
      final a = (c.alpha * _alpha).round().clamp(0, 255);
      if (a != c.alpha) {
        span[i] = Color(c.red, c.green, c.blue, a);
      }
    }
  }
}

class BasicGraphics2D extends Graphics2D {
  final IImageByte destImage;
  final ScanlineRasterizer rasterizer;
  final ScanlineUnpacked8 scanline;

  BasicGraphics2D(
    this.destImage, {
    ScanlineRasterizer? rasterizer,
    ScanlineUnpacked8? scanline,
  })  : rasterizer = rasterizer ?? ScanlineRasterizer(),
        scanline = scanline ?? ScanlineUnpacked8();

  @override
  int get width => destImage.width;

  @override
  int get height => destImage.height;

  @override
  void clear(Color color) {
    for (int y = 0; y < destImage.height; y++) {
      destImage.copyHline(0, y, destImage.width, color);
    }
  }

  void fillRect(double x1, double y1, double x2, double y2, Color color) {
    final t = transform;
    if (!_isIdentity(t)) {
      final vs = VertexStorage()
        ..moveTo(x1, y1)
        ..lineTo(x2, y1)
        ..lineTo(x2, y2)
        ..lineTo(x1, y2)
        ..closePath();
      render(vs, color);
      return;
    }

    final left = math.min(x1, x2);
    final right = math.max(x1, x2);
    final bottom = math.min(y1, y2);
    final top = math.max(y1, y2);

    const eps = 1e-6;
    // Snap values extremely close to integers (float noise after transforms).
    // Without this, values like 106.0000001 pass the epsilon check but
    // `ceil()` expands the fill by 1px.
    double snapNearInt(double v) {
      final r = v.roundToDouble();
      return (v - r).abs() <= eps ? r : v;
    }

    final leftS = snapNearInt(left);
    final rightS = snapNearInt(right);
    final bottomS = snapNearInt(bottom);
    final topS = snapNearInt(top);

    if ((leftS - leftS.round()).abs() > eps ||
        (rightS - rightS.round()).abs() > eps ||
        (bottomS - bottomS.round()).abs() > eps ||
        (topS - topS.round()).abs() > eps) {
      final vs = VertexStorage()
        ..moveTo(x1, y1)
        ..lineTo(x2, y1)
        ..lineTo(x2, y2)
        ..lineTo(x1, y2)
        ..closePath();
      render(vs, color);
      return;
    }

    var l = leftS.floor();
    var r = rightS.ceil();
    var b = bottomS.floor();
    var tY = topS.ceil();

    if (l < 0) l = 0;
    if (b < 0) b = 0;
    if (r > destImage.width) r = destImage.width;
    if (tY > destImage.height) tY = destImage.height;

    final width = r - l;
    final height = tY - b;
    if (width <= 0 || height <= 0) return;

    final paint = applyMasterAlpha(color);
    if (paint.alpha == 255) {
      for (var y = b; y < tY; y++) {
        destImage.copyHline(l, y, width, paint);
      }
    } else {
      for (var y = b; y < tY; y++) {
        destImage.blendHline(l, y, r - 1, paint, 255);
      }
    }
    destImage.markImageChanged();
  }

  @override
  void renderPath(IVertexSource src, Color color) {
    rasterizer.reset();
    rasterizer.addPath(src);
    ScanlineRenderer.renderSolid(rasterizer, scanline, destImage, color);
    destImage.markImageChanged();
  }

  @override
  void renderSpanPath(IVertexSource src, ISpanGenerator generator) {
    rasterizer.reset();
    rasterizer.addPath(src);

    final allocator = SpanAllocator();
    ScanlineRenderer.generateAndRender(
        rasterizer, scanline, destImage, allocator, generator);
    destImage.markImageChanged();
  }

  /// Render a vertex source as a filled shape.
  void render(IVertexSource src, dynamic paint) {
    if (paint is Color) {
      renderSolid(src, paint);
    } else if (paint is SvgPaint) {
      renderSvgPaint(src, paint);
    }
  }

  void renderSolid(IVertexSource src, Color color) {
    final transformed = applyTransform(src);
    renderPath(transformed, applyMasterAlpha(color));
  }

  void renderSvgPaint(IVertexSource src, SvgPaint paint) {
    if (paint is SvgPaintSolid) {
      renderSolid(src, paint.color);
    } else if (paint is SvgPaintLinearGradient) {
      final transformed = applyTransform(src);
      rasterizer.reset();
      rasterizer.addPath(transformed);

      final allocator = SpanAllocator();
      final generator =
          SpanGradientLinear(paint.x1, paint.y1, paint.x2, paint.y2);

      // Convert stops
      final stops = paint.stops
          .map((s) => (offset: s.offset, color: applyMasterAlpha(s.color)))
          .toList();
      generator.buildLut(stops);

      ScanlineRenderer.generateAndRender(
          rasterizer, scanline, destImage, allocator, generator);
      destImage.markImageChanged();
    }
  }

  @override
  void renderGradientPath(IVertexSource src, SpanGradient gradient) {
    renderSpanPath(src, gradient);
  }

  /// Draw a simple AA line using the outline rasterizer.
  void drawLine(double x1, double y1, double x2, double y2, Color color,
      {double thickness = 1.0}) {
    final t = transform;
    final p1 = _transformPoint(x1, y1, t);
    final p2 = _transformPoint(x2, y2, t);
    final paint = applyMasterAlpha(color);
    final LineRenderer renderer;
    if (thickness <= 1.5) {
      renderer = ImageLineRenderer(
        destImage,
        color: paint,
        thickness: thickness,
        cap: CapStyle.butt,
      );
    } else {
      final profile = LineProfileAA();
      profile.width(thickness);
      renderer = ProfileLineRenderer(
        destImage,
        profile: profile,
        color: paint,
        cap: CapStyle.butt,
      );
    }
    final outline = RasterizerOutlineAA(renderer);
    outline.moveTo(
      (p1.x * LineAABasics.line_subpixel_scale).toInt(),
      (p1.y * LineAABasics.line_subpixel_scale).toInt(),
    );
    outline.lineTo(
      (p2.x * LineAABasics.line_subpixel_scale).toInt(),
      (p2.y * LineAABasics.line_subpixel_scale).toInt(),
    );
    outline.render();
    destImage.markImageChanged();
  }

  math.Point<double> _transformPoint(double x, double y, Affine t) {
    final tx = x * t.sx + y * t.shx + t.tx;
    final ty = x * t.shy + y * t.sy + t.ty;
    return math.Point(tx, ty);
  }

  /// Stroke an axis-aligned rectangle using AA lines.
  void strokeRect(double x1, double y1, double x2, double y2, Color color,
      {double thickness = 1.0}) {
    drawLine(x1, y1, x2, y1, color, thickness: thickness);
    drawLine(x2, y1, x2, y2, color, thickness: thickness);
    drawLine(x2, y2, x1, y2, color, thickness: thickness);
    drawLine(x1, y2, x1, y1, color, thickness: thickness);
  }

  /// Fill a circle.
  void fillCircle(double cx, double cy, double radius, Color color) {
    fillEllipse(cx, cy, radius, radius, color);
  }

  /// Stroke a circle.
  void strokeCircle(double cx, double cy, double radius, Color color,
      {double thickness = 1.0}) {
    strokeEllipse(cx, cy, radius, radius, color, thickness: thickness);
  }

  /// Fill an ellipse.
  void fillEllipse(double cx, double cy, double rx, double ry, Color color) {
    final path = _arcPath(cx, cy, rx, ry, 0, math.pi * 2, closeToCenter: true);
    render(path, color);
  }

  /// Stroke an ellipse perimeter with AA lines.
  void strokeEllipse(double cx, double cy, double rx, double ry, Color color,
      {double thickness = 1.0}) {
    final path = _arcPath(cx, cy, rx, ry, 0, math.pi * 2, closeToCenter: false);
    _strokePath(path, color, thickness: thickness);
  }

  /// Fill an arc sector (wedge).
  void fillArc(double cx, double cy, double rx, double ry, double startAngle,
      double sweepAngle, Color color) {
    final path = _arcPath(cx, cy, rx, ry, startAngle, startAngle + sweepAngle,
        closeToCenter: true);
    render(path, color);
  }

  /// Stroke an arc outline.
  void strokeArc(
    double cx,
    double cy,
    double rx,
    double ry,
    double startAngle,
    double sweepAngle,
    Color color, {
    double thickness = 1.0,
  }) {
    final path = _arcPath(cx, cy, rx, ry, startAngle, startAngle + sweepAngle,
        closeToCenter: false);
    _strokePath(path, color, thickness: thickness);
  }

  /// Render a pre-built compound shape.
  void renderCompound(RasterizerCompoundAa compound) {
    compound.render(destImage);
    destImage.markImageChanged();
  }

  /// Draw filled text using the Typography pipeline. [x], [y] represent the
  /// top-left origin; baseline is computed using the font ascender.
  void drawText(String text, Typeface typeface, double pixelSize, Color color,
      {double x = 0, double y = 0}) {
    _drawTextInternal(text, typeface, pixelSize, applyMasterAlpha(color), x, y,
        align: TextAlign.left, baseline: TextBaseline.top);
  }

  VertexStorage _arcPath(
      double cx, double cy, double rx, double ry, double start, double end,
      {bool closeToCenter = false}) {
    final vs = VertexStorage();
    final avgRadius = (rx.abs() + ry.abs()) * 0.5;
    final deltaAngle = math.acos(avgRadius / (avgRadius + 0.125)) * 2;

    var currentEnd = end;
    while (currentEnd < start) {
      currentEnd += math.pi * 2.0;
    }

    final span = currentEnd - start;
    final steps = span <= 0 ? 0 : (span / deltaAngle).toInt();

    final sinDelta = math.sin(deltaAngle);
    final cosDelta = math.cos(deltaAngle);

    var angle = start;
    var cosA = math.cos(angle);
    var sinA = math.sin(angle);

    vs.moveTo(cx + cosA * rx, cy + sinA * ry);

    for (var i = 0; i <= steps; i++) {
      if (angle < currentEnd) {
        vs.lineTo(cx + cosA * rx, cy + sinA * ry);

        final nextCos = cosA * cosDelta - sinA * sinDelta;
        final nextSin = sinA * cosDelta + cosA * sinDelta;
        cosA = nextCos;
        sinA = nextSin;
        angle += deltaAngle;
      }
    }

    final endCos = math.cos(currentEnd);
    final endSin = math.sin(currentEnd);
    vs.lineTo(cx + endCos * rx, cy + endSin * ry);

    if (closeToCenter) {
      vs.lineTo(cx, cy);
      vs.closePath();
    } else {
      vs.closePath();
    }
    return vs;
  }

  void _strokePath(VertexStorage path, Color color, {double thickness = 1.0}) {
    final points = <math.Point<double>>[];
    for (final v in path.vertices()) {
      if (v.command.isMoveTo || v.command.isLineTo) {
        points.add(math.Point(v.x, v.y));
      }
    }
    for (int i = 0; i + 1 < points.length; i++) {
      drawLine(
          points[i].x, points[i].y, points[i + 1].x, points[i + 1].y, color,
          thickness: thickness);
    }
  }

  /// Render basic SVG content (paths/polygons) parsed from [svgString].
  void drawSvgString(String svgString, {bool flipY = false}) {
    renderSvgString(svgString, flipY: flipY);
  }
}

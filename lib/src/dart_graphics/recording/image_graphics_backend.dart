import 'dart:math' as math;

import 'package:dart_graphics/src/dart_graphics/basics.dart';
import 'package:dart_graphics/src/dart_graphics/image/iimage.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/rectangle_double.dart';
import 'package:dart_graphics/src/dart_graphics/recording/clip_stack.dart';
import 'package:dart_graphics/src/dart_graphics/recording/graphics_commands.dart';
import 'package:dart_graphics/src/dart_graphics/recording/layer_stack.dart';
import 'package:dart_graphics/src/dart_graphics/recording/path_utils.dart';
import 'package:dart_graphics/src/dart_graphics/recording/text_runs.dart';
import 'package:dart_graphics/src/dart_graphics/platform/agg_context.dart';
import 'package:dart_graphics/src/dart_graphics/transform/affine.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/ivertex_source.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/vertex_storage.dart';
import 'package:dart_graphics/src/dart_graphics/graphics2D.dart';
import 'package:dart_graphics/src/typography/openfont/typeface.dart';

/// A [GraphicsBackend] that renders into an [ImageBuffer] using [BasicGraphics2D].
///
/// This backend supports:
/// - save/restore + transform
/// - solid path fill/stroke
/// - image draw with an additional transform
/// - clip paths (intersect) via an alpha mask (supports nonZero/evenOdd)
///
/// It is designed to be used with [CommandBuffer.play].
class ImageGraphicsBackend extends GraphicsBackend {
  ImageBuffer? _frame;
  late BasicGraphics2D _g;

  final ClipStack _clipStack = ClipStack();
  final LayerStack _layerStack = LayerStack();
  final List<_SaveEntry> _saveStack = [];

  int _clipVersion = 0;
  int _clipMaskVersion = -1;
  ImageBuffer? _clipMask;
  _IntRect? _clipBounds;

  /// The rendered frame after [endFrame].
  ImageBuffer? get frame => _frame;

  @override
  void beginFrame(int width, int height) {
    _frame = ImageBuffer(width, height);
    _g = _frame!.newGraphics2D() as BasicGraphics2D;
    _g.setTransform(Affine.identity());

    _clipStack.clear();
    _layerStack.clear();
    _saveStack.clear();
    _invalidateClip();
  }

  @override
  void endFrame() {
    // No-op for now.
  }

  @override
  void save() {
    _g.save();
    _clipStack.save();
    _layerStack.save();
    _saveStack.add(const _SaveEntry());
  }

  @override
  void restore() {
    if (_saveStack.isEmpty) {
      return;
    }

    final entry = _saveStack.removeLast();
    if (entry.layerFrame != null) {
      _restoreLayer(entry.layerFrame!);
      return;
    }

    _g.restore();
    final removed = _clipStack.restore();
    if (removed != 0) {
      _invalidateClip();
    }
    _layerStack.restore();
  }

  @override
  void setTransform(Affine transform) {
    _g.setTransform(transform);
  }

  @override
  void saveLayer(Layer layer, {RectangleDouble? bounds}) {
    _g.save();
    _clipStack.save();
    _layerStack.save();
    _layerStack.push(layer);

    final target = _frame;
    if (target == null) {
      _saveStack.add(const _SaveEntry());
      return;
    }

    final layerBuffer = ImageBuffer(target.width, target.height);
    if (!layer.isolate) {
      layerBuffer.copyFrom(target);
    }

    final layerG = layerBuffer.newGraphics2D() as BasicGraphics2D;
    layerG.setTransform(_g.transform.clone());

    final frame = _LayerFrame(
      layer: layer,
      buffer: layerBuffer,
      graphics: layerG,
      previousBuffer: target,
      previousGraphics: _g,
      bounds: _boundsFromLayer(bounds, target.width, target.height),
    );

    _saveStack.add(_SaveEntry(layerFrame: frame));

    _frame = layerBuffer;
    _g = layerG;
  }

  @override
  void clipPath(
    IVertexSource path, {
    Affine? transform,
    ClipOp op = ClipOp.intersect,
    bool antialias = true,
    PathFillRule fillRule = PathFillRule.nonZero,
  }) {
    // Only intersect is supported for now.
    if (op != ClipOp.intersect) {
      _clipStack.push(
        path,
        transform: transform,
        op: op,
        antialias: antialias,
        fillRule: fillRule,
      );
      _invalidateClip();
      return;
    }

    _clipStack.push(
      path,
      transform: transform,
      op: op,
      antialias: antialias,
      fillRule: fillRule,
    );
    _invalidateClip();
  }

  @override
  void clear(Color color) {
    _g.clear(color);
  }

  @override
  void drawPath(IVertexSource path, Paint paint, {StrokeStyle? stroke}) {
    _drawWithClip(() {
      if (paint is SolidPaint) {
        if (stroke == null) {
          _g.fillColor = paint.color;
          _g.masterAlpha = paint.color.alpha / 255.0;
          _setFillRule(PathFillRule.nonZero);
          _g.beginPath();
          _g.currentPath.concat(path);
          _g.fillPath();
          return;
        }

        _g.strokeColor = paint.color;
        _g.masterAlpha = paint.color.alpha / 255.0;
        _g.lineWidth = stroke.width;
        _g.lineCap = _mapCap(stroke.cap);
        _g.lineJoin = _mapJoin(stroke.join);
        _g.miterLimit = stroke.miterLimit;
        _setFillRule(PathFillRule.nonZero);
        _g.beginPath();
        _g.currentPath.concat(path);
        _g.strokePath();
        return;
      }
      if (paint is LinearGradientPaint) {
        final p1 = paint.transform?.transformPoint(paint.x1, paint.y1) ??
            (x: paint.x1, y: paint.y1);
        final p2 = paint.transform?.transformPoint(paint.x2, paint.y2) ??
            (x: paint.x2, y: paint.y2);
        _g.setLinearGradient(
          p1.x,
          p1.y,
          p2.x,
          p2.y,
          paint.stops
              .map((s) => (offset: s.offset, color: s.color))
              .toList(),
        );

        if (stroke == null) {
          _g.masterAlpha = 1.0;
          _setFillRule(PathFillRule.nonZero);
          _g.beginPath();
          _g.currentPath.concat(path);
          _g.fillPath();
          _g.setSolidFill();
          return;
        }

        // Fallback: stroke with first stop color.
        final fallback = paint.stops.isNotEmpty
            ? paint.stops.first.color
            : Color(0, 0, 0, 255);
        _g.strokeColor = fallback;
        _g.masterAlpha = fallback.alpha / 255.0;
        _g.lineWidth = stroke.width;
        _g.lineCap = _mapCap(stroke.cap);
        _g.lineJoin = _mapJoin(stroke.join);
        _g.miterLimit = stroke.miterLimit;
        _g.beginPath();
        _g.currentPath.concat(path);
        _g.strokePath();
        _g.setSolidFill();
        return;
      }

      if (paint is RadialGradientPaint) {
        final c = paint.transform?.transformPoint(paint.cx, paint.cy) ??
            (x: paint.cx, y: paint.cy);
        double radius = paint.r;
        if (paint.transform != null) {
          final scale = paint.transform!.getScale();
          radius *= scale;
        }
        _g.setRadialGradient(
          c.x,
          c.y,
          radius,
          paint.stops
              .map((s) => (offset: s.offset, color: s.color))
              .toList(),
        );

        if (stroke == null) {
          _g.masterAlpha = 1.0;
          _setFillRule(PathFillRule.nonZero);
          _g.beginPath();
          _g.currentPath.concat(path);
          _g.fillPath();
          _g.setSolidFill();
          return;
        }

        final fallback = paint.stops.isNotEmpty
            ? paint.stops.first.color
            : Color(0, 0, 0, 255);
        _g.strokeColor = fallback;
        _g.masterAlpha = fallback.alpha / 255.0;
        _g.lineWidth = stroke.width;
        _g.lineCap = _mapCap(stroke.cap);
        _g.lineJoin = _mapJoin(stroke.join);
        _g.miterLimit = stroke.miterLimit;
        _g.beginPath();
        _g.currentPath.concat(path);
        _g.strokePath();
        _g.setSolidFill();
        return;
      }

      if (paint is ImagePaint) {
        _g.setPatternFill(paint.image, transform: paint.transform);
        _g.masterAlpha = paint.opacity.clamp(0.0, 1.0);
        _setFillRule(PathFillRule.nonZero);
        _g.beginPath();
        _g.currentPath.concat(path);
        _g.fillPath();
        _g.setSolidFill();
        return;
      }

      throw UnsupportedError('Unsupported paint type: ${paint.runtimeType}');
    });
  }

  @override
  void drawImage(IImageByte image, Affine transform, {Paint? paint}) {
    _drawWithClip(() {
      final current = _g.transform.clone();
      final combined = current.clone()..multiply(transform);
      _g.save();
      _g.setTransform(combined);
      if (paint is ImagePaint) {
        _g.masterAlpha = paint.opacity.clamp(0.0, 1.0);
      } else {
        _g.masterAlpha = 1.0;
      }
      _g.drawImage(image, 0, 0, image.width.toDouble(), image.height.toDouble());
      _g.restore();
    });
  }

  @override
  void drawTextRun(TextRun run) {
    final typeface = _resolveTypeface(run.style) ?? _g.typeface;
    if (typeface == null) return;

    _g.setFont(typeface, run.style.fontSize);
    _g.textAlign = _mapTextAlign(run.align);
    _g.textBaseline = _mapTextBaseline(run.baseline);

    _g.setSolidFill();
    _g.fillColor = run.style.color;
    _g.masterAlpha = run.style.color.alpha / 255.0;

    _g.drawTextCurrent(run.text, x: run.x, y: run.y, color: run.style.color);
  }

  Typeface? _resolveTypeface(TextStyle style) {
    final isBold = style.fontWeight.index >= FontWeightLite.w600.index;
    final isItalic = style.fontStyle != FontStyleLite.normal;

    if (isBold && isItalic) return DartGraphicsContext.defaultFontBoldItalic;
    if (isBold) return DartGraphicsContext.defaultFontBold;
    if (isItalic) return DartGraphicsContext.defaultFontItalic;
    return DartGraphicsContext.defaultFont;
  }

  TextAlign _mapTextAlign(TextAlignLite align) {
    switch (align) {
      case TextAlignLite.left:
        return TextAlign.left;
      case TextAlignLite.right:
        return TextAlign.right;
      case TextAlignLite.center:
        return TextAlign.center;
      case TextAlignLite.justify:
        return TextAlign.left;
      case TextAlignLite.start:
        return TextAlign.start;
      case TextAlignLite.end:
        return TextAlign.end;
    }
  }

  TextBaseline _mapTextBaseline(TextBaselineLite baseline) {
    switch (baseline) {
      case TextBaselineLite.alphabetic:
        return TextBaseline.alphabetic;
      case TextBaselineLite.ideographic:
      case TextBaselineLite.hanging:
        return TextBaseline.alphabetic;
      case TextBaselineLite.middle:
        return TextBaseline.middle;
    }
  }

  void _drawWithClip(void Function() draw) {
    if (_clipStack.isEmpty) {
      draw();
      return;
    }

    _ensureClipMask();
    final mask = _clipMask;
    final bounds = _clipBounds;
    if (mask == null || bounds == null || bounds.isEmpty) {
      return;
    }

    final temp = ImageBuffer(bounds.width, bounds.height);
    final tempG = temp.newGraphics2D() as BasicGraphics2D;
    tempG.clear(Color(0, 0, 0, 0));

    final originalG = _g;
    final originalTransform = originalG.transform.clone();

    try {
      _g = tempG;
      // Shift everything by the clip bounds offset.
      final adjusted = originalTransform.clone()
        ..tx -= bounds.left.toDouble()
        ..ty -= bounds.top.toDouble();
      _g.setTransform(adjusted);
      draw();
    } finally {
      _g = originalG;
      _g.setTransform(originalTransform);
    }

    _applyMaskSubset(temp, mask, bounds.left, bounds.top);

    // Composite back.
    originalG.save();
    final originalAlpha = originalG.masterAlpha;
    originalG.masterAlpha = 1.0;
    originalG.setTransform(Affine.identity());
    originalG.drawImage(
      temp,
      bounds.left.toDouble(),
      bounds.top.toDouble(),
      bounds.width.toDouble(),
      bounds.height.toDouble(),
    );
    originalG.masterAlpha = originalAlpha;
    originalG.restore();
  }

  void _invalidateClip() {
    _clipVersion++;
    _clipMaskVersion = -1;
    _clipMask = null;
    _clipBounds = null;
  }

  void _ensureClipMask() {
    if (_clipMaskVersion == _clipVersion && _clipMask != null && _clipBounds != null) {
      return;
    }

    final w = _g.width;
    final h = _g.height;
    if (w <= 0 || h <= 0) {
      _clipMask = null;
      _clipBounds = null;
      _clipMaskVersion = _clipVersion;
      return;
    }

    final mask = ImageBuffer(w, h);
    final maskBytes = mask.getBuffer();

    // Start fully opaque.
    for (var i = 0; i < maskBytes.length; i += 4) {
      maskBytes[i] = 255;
      maskBytes[i + 1] = 255;
      maskBytes[i + 2] = 255;
      maskBytes[i + 3] = 255;
    }

    final tmp = ImageBuffer(w, h);
    final tmpG = tmp.newGraphics2D() as BasicGraphics2D;
    tmpG.setTransform(Affine.identity());

    _IntRect bounds = _IntRect(0, 0, w, h);

    for (final entry in _clipStack.entries) {
      tmpG.clear(Color(0, 0, 0, 0));
      tmpG.fillColor = Color(255, 255, 255, 255);
      tmpG.masterAlpha = 1.0;

      tmpG.rasterizer.fillingRule(
        entry.fillRule == PathFillRule.evenOdd
            ? FillingRuleE.fillEvenOdd
            : FillingRuleE.fillNonZero,
      );

      final devicePath = _toDevicePath(entry.path, entry.transform);
      tmpG.beginPath();
      tmpG.currentPath.concat(devicePath);
      tmpG.fillPath();

      // mask = mask * tmpAlpha (intersect) OR mask * (1 - tmpAlpha) (difference)
      final tmpBytes = tmp.getBuffer();
      if (entry.op == ClipOp.difference) {
        for (var i = 0; i < maskBytes.length; i += 4) {
          final ma = maskBytes[i + 3];
          if (ma == 0) continue;
          final ta = tmpBytes[i + 3];
          final inv = 255 - ta;
          final outA = (ma * inv) ~/ 255;
          maskBytes[i + 3] = outA;
          maskBytes[i] = (maskBytes[i] * inv) ~/ 255;
          maskBytes[i + 1] = (maskBytes[i + 1] * inv) ~/ 255;
          maskBytes[i + 2] = (maskBytes[i + 2] * inv) ~/ 255;
        }
      } else {
        for (var i = 0; i < maskBytes.length; i += 4) {
          final ma = maskBytes[i + 3];
          if (ma == 0) continue;
          final ta = tmpBytes[i + 3];
          final outA = (ma * ta) ~/ 255;
          maskBytes[i + 3] = outA;
          maskBytes[i] = (maskBytes[i] * ta) ~/ 255;
          maskBytes[i + 1] = (maskBytes[i + 1] * ta) ~/ 255;
          maskBytes[i + 2] = (maskBytes[i + 2] * ta) ~/ 255;
        }
      }

      final entryBounds = _boundsOfPath(devicePath, w: w, h: h);
      if (entry.op == ClipOp.intersect) {
        bounds = bounds.intersect(entryBounds);
      }
    }

    _clipMask = mask;
    _clipBounds = bounds;
    _clipMaskVersion = _clipVersion;
  }

  VertexStorage _toDevicePath(IVertexSource path, Affine? transform) {
    if (transform == null) {
      return PathUtils.copy(path);
    }

    final copied = PathUtils.copy(path);
    final dest = VertexStorage();
    for (final v in copied.vertices()) {
      if (v.command.isStop) break;
      if (v.command.isVertex) {
        final p = transform.transformPoint(v.x, v.y);
        dest.addVertex(p.x, p.y, v.command);
      } else {
        dest.addVertex(v.x, v.y, v.command);
      }
    }
    return dest;
  }

  void _applyMaskSubset(ImageBuffer layer, ImageBuffer mask, int dx, int dy) {
    final layerBytes = layer.getBuffer();
    final maskBytes = mask.getBuffer();

    final w = layer.width;
    final h = layer.height;
    final fullW = mask.width;

    for (var y = 0; y < h; y++) {
      final maskRow = (dy + y) * fullW;
      final layerRow = y * w;
      for (var x = 0; x < w; x++) {
        final li = (layerRow + x) * 4;
        final mi = (maskRow + (dx + x)) * 4;
        final ma = maskBytes[mi + 3];
        if (ma == 255) continue;
        if (ma == 0) {
          layerBytes[li] = 0;
          layerBytes[li + 1] = 0;
          layerBytes[li + 2] = 0;
          layerBytes[li + 3] = 0;
          continue;
        }
        layerBytes[li] = (layerBytes[li] * ma) ~/ 255;
        layerBytes[li + 1] = (layerBytes[li + 1] * ma) ~/ 255;
        layerBytes[li + 2] = (layerBytes[li + 2] * ma) ~/ 255;
        layerBytes[li + 3] = (layerBytes[li + 3] * ma) ~/ 255;
      }
    }
  }

  void _restoreLayer(_LayerFrame frame) {
    final layerBuffer = frame.buffer;

    _g = frame.previousGraphics;
    _frame = frame.previousBuffer;

    final removed = _clipStack.restore();
    if (removed != 0) {
      _invalidateClip();
    }
    _layerStack.restore();

    _compositeLayer(layerBuffer, frame.layer, frame.bounds);
    _g.restore();
  }

  void _compositeLayer(ImageBuffer layerBuffer, Layer layer, _IntRect bounds) {
    final dst = _frame;
    if (dst == null) return;

    final opacity = layer.opacity.clamp(0.0, 1.0);
    if (opacity <= 0.0) return;

    ImageBuffer? mask;
    _IntRect? clipBounds;
    if (!_clipStack.isEmpty) {
      _ensureClipMask();
      mask = _clipMask;
      clipBounds = _clipBounds;
      if (mask == null || clipBounds == null || clipBounds.isEmpty) {
        return;
      }
    }

    final srcBytes = layerBuffer.getBuffer();
    final dstBytes = dst.getBuffer();
    final maskBytes = mask?.getBuffer();

    final width = dst.width;
    final height = dst.height;

    final left = math.max(0, bounds.left);
    final top = math.max(0, bounds.top);
    final right = math.min(width, bounds.right);
    final bottom = math.min(height, bounds.bottom);

    final clipLeft = clipBounds != null ? math.max(left, clipBounds.left) : left;
    final clipTop = clipBounds != null ? math.max(top, clipBounds.top) : top;
    final clipRight = clipBounds != null ? math.min(right, clipBounds.right) : right;
    final clipBottom = clipBounds != null ? math.min(bottom, clipBounds.bottom) : bottom;

    if (clipRight <= clipLeft || clipBottom <= clipTop) return;

    for (var y = clipTop; y < clipBottom; y++) {
      final row = y * width;
      for (var x = clipLeft; x < clipRight; x++) {
        final i = (row + x) * 4;

        final sr = srcBytes[i];
        final sg = srcBytes[i + 1];
        final sb = srcBytes[i + 2];
        final sa0 = srcBytes[i + 3];

        if (sa0 == 0 && layer.blendMode != BlendModeLite.dst) {
          continue;
        }

        var sa = (sa0 * opacity).round().clamp(0, 255);
        if (maskBytes != null) {
          final ma = maskBytes[i + 3];
          if (ma == 0) continue;
          sa = (sa * ma + 127) ~/ 255;
          if (sa == 0 && layer.blendMode != BlendModeLite.dst) continue;
        }

        final dr = dstBytes[i];
        final dg = dstBytes[i + 1];
        final db = dstBytes[i + 2];
        final da = dstBytes[i + 3];

        final out = _blendPixel(
          sr,
          sg,
          sb,
          sa,
          dr,
          dg,
          db,
          da,
          layer.blendMode,
        );

        dstBytes[i] = out.$1;
        dstBytes[i + 1] = out.$2;
        dstBytes[i + 2] = out.$3;
        dstBytes[i + 3] = out.$4;
      }
    }
  }

  (int, int, int, int) _blendPixel(
    int sr,
    int sg,
    int sb,
    int sa,
    int dr,
    int dg,
    int db,
    int da,
    BlendModeLite mode,
  ) {
    final as = sa / 255.0;
    final ad = da / 255.0;
    final cs = sr / 255.0;
    final cd = dr / 255.0;
    final csG = sg / 255.0;
    final cdG = dg / 255.0;
    final csB = sb / 255.0;
    final cdB = db / 255.0;

    switch (mode) {
      case BlendModeLite.clear:
        return (0, 0, 0, 0);
      case BlendModeLite.dst:
        return (dr, dg, db, da);
      case BlendModeLite.src:
        return (sr, sg, sb, sa);
      case BlendModeLite.alpha:
      case BlendModeLite.srcOver:
        return _porterDuff(cs, csG, csB, as, cd, cdG, cdB, ad, _PorterDuff.srcOver);
      case BlendModeLite.dstOver:
        return _porterDuff(cs, csG, csB, as, cd, cdG, cdB, ad, _PorterDuff.dstOver);
      case BlendModeLite.srcIn:
        return _porterDuff(cs, csG, csB, as, cd, cdG, cdB, ad, _PorterDuff.srcIn);
      case BlendModeLite.dstIn:
        return _porterDuff(cs, csG, csB, as, cd, cdG, cdB, ad, _PorterDuff.dstIn);
      case BlendModeLite.srcOut:
        return _porterDuff(cs, csG, csB, as, cd, cdG, cdB, ad, _PorterDuff.srcOut);
      case BlendModeLite.dstOut:
        return _porterDuff(cs, csG, csB, as, cd, cdG, cdB, ad, _PorterDuff.dstOut);
      case BlendModeLite.srcAtop:
        return _porterDuff(cs, csG, csB, as, cd, cdG, cdB, ad, _PorterDuff.srcAtop);
      case BlendModeLite.dstAtop:
        return _porterDuff(cs, csG, csB, as, cd, cdG, cdB, ad, _PorterDuff.dstAtop);
      case BlendModeLite.xor:
        return _porterDuff(cs, csG, csB, as, cd, cdG, cdB, ad, _PorterDuff.xor);
      case BlendModeLite.add:
        return _blendWithMode(cs, csG, csB, as, cd, cdG, cdB, ad, _BlendFn.add);
      case BlendModeLite.multiply:
        return _blendWithMode(cs, csG, csB, as, cd, cdG, cdB, ad, _BlendFn.multiply);
      case BlendModeLite.screen:
        return _blendWithMode(cs, csG, csB, as, cd, cdG, cdB, ad, _BlendFn.screen);
      case BlendModeLite.overlay:
        return _blendWithMode(cs, csG, csB, as, cd, cdG, cdB, ad, _BlendFn.overlay);
      case BlendModeLite.darken:
        return _blendWithMode(cs, csG, csB, as, cd, cdG, cdB, ad, _BlendFn.darken);
      case BlendModeLite.lighten:
        return _blendWithMode(cs, csG, csB, as, cd, cdG, cdB, ad, _BlendFn.lighten);
      case BlendModeLite.colorDodge:
        return _blendWithMode(cs, csG, csB, as, cd, cdG, cdB, ad, _BlendFn.colorDodge);
      case BlendModeLite.colorBurn:
        return _blendWithMode(cs, csG, csB, as, cd, cdG, cdB, ad, _BlendFn.colorBurn);
      case BlendModeLite.hardLight:
        return _blendWithMode(cs, csG, csB, as, cd, cdG, cdB, ad, _BlendFn.hardLight);
      case BlendModeLite.softLight:
        return _blendWithMode(cs, csG, csB, as, cd, cdG, cdB, ad, _BlendFn.softLight);
      case BlendModeLite.difference:
        return _blendWithMode(cs, csG, csB, as, cd, cdG, cdB, ad, _BlendFn.difference);
      case BlendModeLite.exclusion:
        return _blendWithMode(cs, csG, csB, as, cd, cdG, cdB, ad, _BlendFn.exclusion);
    }
  }

  (int, int, int, int) _porterDuff(
    double cs,
    double csG,
    double csB,
    double as,
    double cd,
    double cdG,
    double cdB,
    double ad,
    _PorterDuff mode,
  ) {
    double ps = cs * as;
    double psG = csG * as;
    double psB = csB * as;
    double pd = cd * ad;
    double pdG = cdG * ad;
    double pdB = cdB * ad;

    double po;
    double poG;
    double poB;
    double ao;

    switch (mode) {
      case _PorterDuff.clear:
        ao = 0;
        po = 0;
        poG = 0;
        poB = 0;
        break;
      case _PorterDuff.src:
        ao = as;
        po = ps;
        poG = psG;
        poB = psB;
        break;
      case _PorterDuff.dst:
        ao = ad;
        po = pd;
        poG = pdG;
        poB = pdB;
        break;
      case _PorterDuff.srcOver:
        ao = as + ad * (1 - as);
        po = ps + pd * (1 - as);
        poG = psG + pdG * (1 - as);
        poB = psB + pdB * (1 - as);
        break;
      case _PorterDuff.dstOver:
        ao = ad + as * (1 - ad);
        po = pd + ps * (1 - ad);
        poG = pdG + psG * (1 - ad);
        poB = pdB + psB * (1 - ad);
        break;
      case _PorterDuff.srcIn:
        ao = as * ad;
        po = ps * ad;
        poG = psG * ad;
        poB = psB * ad;
        break;
      case _PorterDuff.dstIn:
        ao = ad * as;
        po = pd * as;
        poG = pdG * as;
        poB = pdB * as;
        break;
      case _PorterDuff.srcOut:
        ao = as * (1 - ad);
        po = ps * (1 - ad);
        poG = psG * (1 - ad);
        poB = psB * (1 - ad);
        break;
      case _PorterDuff.dstOut:
        ao = ad * (1 - as);
        po = pd * (1 - as);
        poG = pdG * (1 - as);
        poB = pdB * (1 - as);
        break;
      case _PorterDuff.srcAtop:
        ao = ad;
        po = ps * ad + pd * (1 - as);
        poG = psG * ad + pdG * (1 - as);
        poB = psB * ad + pdB * (1 - as);
        break;
      case _PorterDuff.dstAtop:
        ao = as;
        po = pd * as + ps * (1 - ad);
        poG = pdG * as + psG * (1 - ad);
        poB = pdB * as + psB * (1 - ad);
        break;
      case _PorterDuff.xor:
        ao = as * (1 - ad) + ad * (1 - as);
        po = ps * (1 - ad) + pd * (1 - as);
        poG = psG * (1 - ad) + pdG * (1 - as);
        poB = psB * (1 - ad) + pdB * (1 - as);
        break;
    }

    if (ao <= 0) {
      return (0, 0, 0, 0);
    }

    final r = (po / ao * 255).round().clamp(0, 255);
    final g = (poG / ao * 255).round().clamp(0, 255);
    final b = (poB / ao * 255).round().clamp(0, 255);
    final a = (ao * 255).round().clamp(0, 255);
    return (r, g, b, a);
  }

  (int, int, int, int) _blendWithMode(
    double cs,
    double csG,
    double csB,
    double as,
    double cd,
    double cdG,
    double cdB,
    double ad,
    _BlendFn mode,
  ) {
    final ao = as + ad - as * ad;
    if (ao <= 0) {
      return (0, 0, 0, 0);
    }

    double blend(double s, double d) {
      switch (mode) {
        case _BlendFn.add:
          return math.min(1.0, s + d);
        case _BlendFn.multiply:
          return s * d;
        case _BlendFn.screen:
          return s + d - s * d;
        case _BlendFn.overlay:
          return d <= 0.5 ? 2 * s * d : 1 - 2 * (1 - s) * (1 - d);
        case _BlendFn.darken:
          return math.min(s, d);
        case _BlendFn.lighten:
          return math.max(s, d);
        case _BlendFn.colorDodge:
          if (s >= 1.0) return 1.0;
          return math.min(1.0, d / (1 - s));
        case _BlendFn.colorBurn:
          if (s <= 0.0) return 0.0;
          return 1 - math.min(1.0, (1 - d) / s);
        case _BlendFn.hardLight:
          return s <= 0.5 ? 2 * s * d : 1 - 2 * (1 - s) * (1 - d);
        case _BlendFn.softLight:
          if (s <= 0.5) {
            return d - (1 - 2 * s) * d * (1 - d);
          }
          double g;
          if (d <= 0.25) {
            g = ((16 * d - 12) * d + 4) * d;
          } else {
            g = math.sqrt(d);
          }
          return d + (2 * s - 1) * (g - d);
        case _BlendFn.difference:
          return (d - s).abs();
        case _BlendFn.exclusion:
          return s + d - 2 * s * d;
      }
    }

    final r = (255 * ((1 - as) * cd + (1 - ad) * cs + as * ad * blend(cs, cd)))
        .round()
        .clamp(0, 255);
    final g = (255 * ((1 - as) * cdG + (1 - ad) * csG + as * ad * blend(csG, cdG)))
        .round()
        .clamp(0, 255);
    final b = (255 * ((1 - as) * cdB + (1 - ad) * csB + as * ad * blend(csB, cdB)))
        .round()
        .clamp(0, 255);
    final a = (ao * 255).round().clamp(0, 255);
    return (r, g, b, a);
  }

  _IntRect _boundsFromLayer(
    RectangleDouble? bounds,
    int width,
    int height,
  ) {
    if (bounds == null) {
      return _IntRect(0, 0, width, height);
    }
    final rect = RectangleDouble(bounds.left, bounds.bottom, bounds.right, bounds.top);
    rect.normalize();

    final left = rect.left.floor().clamp(0, width).toInt();
    final right = rect.right.ceil().clamp(0, width).toInt();
    final top = rect.bottom.floor().clamp(0, height).toInt();
    final bottom = rect.top.ceil().clamp(0, height).toInt();

    return _IntRect(left, top, right, bottom);
  }

  _IntRect _boundsOfPath(IVertexSource path, {required int w, required int h}) {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final v in path.vertices()) {
      if (v.command.isStop) break;
      if (!v.command.isVertex) continue;
      minX = math.min(minX, v.x);
      minY = math.min(minY, v.y);
      maxX = math.max(maxX, v.x);
      maxY = math.max(maxY, v.y);
    }

    if (minX == double.infinity) {
      return _IntRect(0, 0, 0, 0);
    }

    final left = (minX.floor() - 1).clamp(0, w);
    final top = (minY.floor() - 1).clamp(0, h);
    final right = (maxX.ceil() + 1).clamp(0, w);
    final bottom = (maxY.ceil() + 1).clamp(0, h);

    return _IntRect(left, top, right, bottom);
  }

  void _setFillRule(PathFillRule rule) {
    _g.rasterizer.fillingRule(
      rule == PathFillRule.evenOdd ? FillingRuleE.fillEvenOdd : FillingRuleE.fillNonZero,
    );
  }

  LineCap _mapCap(StrokeCap cap) {
    switch (cap) {
      case StrokeCap.round:
        return LineCap.round;
      case StrokeCap.square:
        return LineCap.square;
      case StrokeCap.butt:
        return LineCap.butt;
    }
  }

  LineJoin _mapJoin(StrokeJoin join) {
    switch (join) {
      case StrokeJoin.round:
        return LineJoin.round;
      case StrokeJoin.bevel:
        return LineJoin.bevel;
      case StrokeJoin.miter:
        return LineJoin.miter;
    }
  }
}

class _SaveEntry {
  const _SaveEntry({this.layerFrame});

  final _LayerFrame? layerFrame;
}

class _LayerFrame {
  const _LayerFrame({
    required this.layer,
    required this.buffer,
    required this.graphics,
    required this.previousBuffer,
    required this.previousGraphics,
    required this.bounds,
  });

  final Layer layer;
  final ImageBuffer buffer;
  final BasicGraphics2D graphics;
  final ImageBuffer previousBuffer;
  final BasicGraphics2D previousGraphics;
  final _IntRect bounds;
}

enum _PorterDuff {
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
}

enum _BlendFn {
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

class _IntRect {
  const _IntRect(this.left, this.top, this.right, this.bottom);

  final int left;
  final int top;
  final int right;
  final int bottom;

  bool get isEmpty => right <= left || bottom <= top;

  int get width => right - left;

  int get height => bottom - top;

  _IntRect intersect(_IntRect other) {
    final l = left > other.left ? left : other.left;
    final t = top > other.top ? top : other.top;
    final r = right < other.right ? right : other.right;
    final b = bottom < other.bottom ? bottom : other.bottom;
    return _IntRect(l, t, r, b);
  }
}

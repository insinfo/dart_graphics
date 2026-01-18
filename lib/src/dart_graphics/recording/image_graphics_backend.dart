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
import 'package:dart_graphics/src/dart_graphics/transform/affine.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/ivertex_source.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/vertex_storage.dart';
import 'package:dart_graphics/src/dart_graphics/graphics2D.dart';

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
  }

  @override
  void restore() {
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
    // Minimal implementation: record layer intent and rely on client to restore.
    _layerStack.push(layer);
    _g.save();
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

      // Other paints not implemented yet.
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
      _g.masterAlpha = 1.0;
      _g.drawImage(image, 0, 0, image.width.toDouble(), image.height.toDouble());
      _g.restore();
    });
  }

  @override
  void drawTextRun(TextRun run) {
    // Text backend integration is pending.
    throw UnimplementedError('Text rendering backend not implemented yet.');
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

    _IntRect? bounds;

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

      // mask = mask * tmpAlpha
      final tmpBytes = tmp.getBuffer();
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

      final entryBounds = _boundsOfPath(devicePath, w: w, h: h);
      bounds = bounds == null ? entryBounds : bounds.intersect(entryBounds);
    }

    _clipMask = mask;
    _clipBounds = bounds ?? _IntRect(0, 0, 0, 0);
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

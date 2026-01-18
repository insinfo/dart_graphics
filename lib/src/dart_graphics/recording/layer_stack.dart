import 'package:dart_graphics/src/dart_graphics/primitives/rectangle_double.dart';

/// Layer model for backend-agnostic rendering.
class Layer {
  final double opacity;
  final BlendModeLite blendMode;
  final bool isolate;
  final RectangleDouble? bounds;

  const Layer({
    this.opacity = 1.0,
    this.blendMode = BlendModeLite.srcOver,
    this.isolate = false,
    this.bounds,
  });
}

enum BlendModeLite {
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

/// Simple layer stack helper.
class LayerStack {
  final List<Layer> _stack = [];
  final List<int> _savePoints = [];

  bool get isEmpty => _stack.isEmpty;

  int get length => _stack.length;

  void push(Layer layer) => _stack.add(layer);

  void save() => _savePoints.add(_stack.length);

  Layer? pop() => _stack.isEmpty ? null : _stack.removeLast();

  int restore() {
    if (_savePoints.isEmpty) return 0;
    final target = _savePoints.removeLast();
    final removed = _stack.length - target;
    _stack.removeRange(target, _stack.length);
    return removed;
  }

  Layer? peek() => _stack.isEmpty ? null : _stack.last;

  void clear() {
    _stack.clear();
    _savePoints.clear();
  }
}

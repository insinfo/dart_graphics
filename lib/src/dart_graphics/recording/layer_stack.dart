/// Minimal layer model for backend-agnostic rendering.
class Layer {
  final double opacity;
  final BlendModeLite blendMode;
  final bool isolate;

  const Layer({
    this.opacity = 1.0,
    this.blendMode = BlendModeLite.srcOver,
    this.isolate = false,
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

  bool get isEmpty => _stack.isEmpty;

  int get length => _stack.length;

  void push(Layer layer) => _stack.add(layer);

  Layer? pop() => _stack.isEmpty ? null : _stack.removeLast();

  Layer? peek() => _stack.isEmpty ? null : _stack.last;

  void clear() => _stack.clear();
}

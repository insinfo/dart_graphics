import 'package:dart_graphics/src/dart_graphics/vertex_source/ivertex_source.dart';

/// Simple clip stack for backend-agnostic rendering.
class ClipStack {
  final List<IVertexSource> _stack = [];

  bool get isEmpty => _stack.isEmpty;

  int get length => _stack.length;

  void push(IVertexSource path) {
    _stack.add(path);
  }

  IVertexSource? pop() {
    if (_stack.isEmpty) return null;
    return _stack.removeLast();
  }

  IVertexSource? peek() {
    if (_stack.isEmpty) return null;
    return _stack.last;
  }

  Iterable<IVertexSource> get entries => _stack;

  void clear() => _stack.clear();
}

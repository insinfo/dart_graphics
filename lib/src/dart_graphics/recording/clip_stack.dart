import 'package:dart_graphics/src/dart_graphics/transform/affine.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/ivertex_source.dart';

enum ClipOp { intersect, difference }

class ClipEntry {
  final IVertexSource path;
  final Affine transform;
  final ClipOp op;
  final bool antialias;

  ClipEntry(
    this.path, {
    Affine? transform,
    this.op = ClipOp.intersect,
    this.antialias = true,
  }) : transform = transform ?? Affine.identity();
}

/// Clip stack with save/restore support for backend-agnostic rendering.
class ClipStack {
  final List<ClipEntry> _stack = [];
  final List<int> _savePoints = [];

  bool get isEmpty => _stack.isEmpty;

  int get length => _stack.length;

  void push(IVertexSource path, {Affine? transform, ClipOp op = ClipOp.intersect, bool antialias = true}) {
    _stack.add(ClipEntry(path, transform: transform, op: op, antialias: antialias));
  }

  ClipEntry? pop() => _stack.isEmpty ? null : _stack.removeLast();

  ClipEntry? peek() => _stack.isEmpty ? null : _stack.last;

  IVertexSource? peekPath() => _stack.isEmpty ? null : _stack.last.path;

  Iterable<ClipEntry> get entries => _stack;

  void save() => _savePoints.add(_stack.length);

  int restore() {
    if (_savePoints.isEmpty) return 0;
    final target = _savePoints.removeLast();
    final removed = _stack.length - target;
    _stack.removeRange(target, _stack.length);
    return removed;
  }

  void clear() {
    _stack.clear();
    _savePoints.clear();
  }
}

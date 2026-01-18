import 'package:dart_graphics/src/dart_graphics/image/iimage.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/rectangle_double.dart';
import 'package:dart_graphics/src/dart_graphics/recording/clip_stack.dart';
import 'package:dart_graphics/src/dart_graphics/recording/layer_stack.dart';
import 'package:dart_graphics/src/dart_graphics/recording/text_runs.dart';
import 'package:dart_graphics/src/dart_graphics/transform/affine.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/ivertex_source.dart';

/// Backend-agnostic render target for recorded graphics commands.
abstract class GraphicsBackend {
  void beginFrame(int width, int height);
  void endFrame();

  void save();
  void restore();
  void setTransform(Affine transform);
  void saveLayer(Layer layer, {RectangleDouble? bounds});
  void clipPath(IVertexSource path, {Affine? transform, ClipOp op = ClipOp.intersect, bool antialias = true});

  void clear(Color color);
  void drawPath(IVertexSource path, Paint paint, {StrokeStyle? stroke});
  void drawImage(IImageByte image, Affine transform, {Paint? paint});
  void drawTextRun(TextRun run);
}

/// A lightweight stroke description independent of any backend.
class StrokeStyle {
  final double width;
  final StrokeCap cap;
  final StrokeJoin join;
  final double miterLimit;
  final List<double> dashArray;
  final double dashOffset;

  const StrokeStyle({
    this.width = 1.0,
    this.cap = StrokeCap.butt,
    this.join = StrokeJoin.miter,
    this.miterLimit = 4.0,
    this.dashArray = const [],
    this.dashOffset = 0.0,
  });
}

enum StrokeCap { butt, round, square }

enum StrokeJoin { miter, round, bevel }

/// Backend-agnostic paint description.
abstract class Paint {
  Paint();
}

class SolidPaint implements Paint {
  final Color color;
  SolidPaint(this.color);
}

class LinearGradientPaint implements Paint {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final List<PaintStop> stops;
  final Affine? transform;

  LinearGradientPaint({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.stops,
    this.transform,
  });
}

class RadialGradientPaint implements Paint {
  final double cx;
  final double cy;
  final double r;
  final double fx;
  final double fy;
  final List<PaintStop> stops;
  final Affine? transform;

  RadialGradientPaint({
    required this.cx,
    required this.cy,
    required this.r,
    double? fx,
    double? fy,
    required this.stops,
    this.transform,
  })  : fx = fx ?? cx,
        fy = fy ?? cy;
}

class ImagePaint implements Paint {
  final IImageByte image;
  final Affine transform;
  final double opacity;

  ImagePaint({
    required this.image,
    Affine? transform,
    this.opacity = 1.0,
  }) : transform = transform ?? Affine.identity();
}

class PaintStop {
  final double offset;
  final Color color;
  PaintStop(this.offset, this.color);
}

/// Serializable drawing command.
abstract class DrawCommand {
  const DrawCommand();
  void execute(GraphicsBackend backend);
}

class ClearCommand extends DrawCommand {
  final Color color;
  const ClearCommand(this.color);

  @override
  void execute(GraphicsBackend backend) => backend.clear(color);
}

class SaveCommand extends DrawCommand {
  const SaveCommand();

  @override
  void execute(GraphicsBackend backend) => backend.save();
}

class RestoreCommand extends DrawCommand {
  const RestoreCommand();

  @override
  void execute(GraphicsBackend backend) => backend.restore();
}

class TransformCommand extends DrawCommand {
  final Affine transform;
  const TransformCommand(this.transform);

  @override
  void execute(GraphicsBackend backend) => backend.setTransform(transform);
}

class ClipPathCommand extends DrawCommand {
  final IVertexSource path;
  final Affine? transform;
  final ClipOp op;
  final bool antialias;

  const ClipPathCommand(
    this.path, {
    this.transform,
    this.op = ClipOp.intersect,
    this.antialias = true,
  });

  @override
  void execute(GraphicsBackend backend) => backend.clipPath(path, transform: transform, op: op, antialias: antialias);
}

class DrawPathCommand extends DrawCommand {
  final IVertexSource path;
  final Paint paint;
  final StrokeStyle? stroke;

  const DrawPathCommand(this.path, this.paint, {this.stroke});

  @override
  void execute(GraphicsBackend backend) => backend.drawPath(path, paint, stroke: stroke);
}

class DrawImageCommand extends DrawCommand {
  final IImageByte image;
  final Affine transform;
  final Paint? paint;

  const DrawImageCommand(this.image, this.transform, {this.paint});

  @override
  void execute(GraphicsBackend backend) => backend.drawImage(image, transform, paint: paint);
}

class SaveLayerCommand extends DrawCommand {
  final Layer layer;
  final RectangleDouble? bounds;

  const SaveLayerCommand(this.layer, {this.bounds});

  @override
  void execute(GraphicsBackend backend) => backend.saveLayer(layer, bounds: bounds);
}

class DrawTextRunCommand extends DrawCommand {
  final TextRun run;

  const DrawTextRunCommand(this.run);

  @override
  void execute(GraphicsBackend backend) => backend.drawTextRun(run);
}

/// A command buffer that can be replayed by any backend.
class CommandBuffer {
  final List<DrawCommand> _commands = [];
  final List<Affine> _transformStack = [];
  Affine _currentTransform = Affine.identity();

  List<DrawCommand> get commands => List.unmodifiable(_commands);

  bool get isEmpty => _commands.isEmpty;

  int get length => _commands.length;

  void add(DrawCommand command) {
    _applyState(command);
    _commands.add(command);
  }

  void save() => add(const SaveCommand());

  void restore() => add(const RestoreCommand());

  void saveLayer(Layer layer, {RectangleDouble? bounds}) => add(SaveLayerCommand(layer, bounds: bounds));

  void setTransform(Affine transform) {
    if (transform == _currentTransform) return;
    add(TransformCommand(transform.clone()));
  }

  void clipPath(IVertexSource path, {ClipOp op = ClipOp.intersect, bool antialias = true}) {
    add(ClipPathCommand(path, transform: _currentTransform.clone(), op: op, antialias: antialias));
  }

  void clear(Color color) => add(ClearCommand(color));

  void drawPath(IVertexSource path, Paint paint, {StrokeStyle? stroke}) =>
      add(DrawPathCommand(path, paint, stroke: stroke));

  void drawImage(IImageByte image, Affine transform, {Paint? paint}) =>
      add(DrawImageCommand(image, transform, paint: paint));

  void drawTextRun(TextRun run) => add(DrawTextRunCommand(run));

  void clearCommands() {
    _commands.clear();
    _transformStack.clear();
    _currentTransform = Affine.identity();
  }

  int optimize() {
    if (_commands.isEmpty) return 0;

    final optimized = <DrawCommand>[];
    final transformStack = <Affine>[];
    final saveIndexStack = <int>[];
    final renderStack = <bool>[];
    var currentTransform = Affine.identity();

    for (final command in _commands) {
      if (command is SaveCommand || command is SaveLayerCommand) {
        saveIndexStack.add(optimized.length);
        renderStack.add(false);
        transformStack.add(currentTransform.clone());
        optimized.add(command);
        continue;
      }

      if (command is RestoreCommand) {
        if (transformStack.isNotEmpty) {
          currentTransform = transformStack.removeLast();
        }

        if (renderStack.isEmpty || saveIndexStack.isEmpty) {
          optimized.add(command);
          continue;
        }

        final rendered = renderStack.removeLast();
        final saveIndex = saveIndexStack.removeLast();

        if (rendered) {
          if (renderStack.isNotEmpty) {
            renderStack[renderStack.length - 1] = true;
          }
          optimized.add(command);
        } else {
          optimized.removeRange(saveIndex, optimized.length);
        }
        continue;
      }

      if (command is TransformCommand) {
        if (command.transform == currentTransform) {
          continue;
        }
        currentTransform = command.transform;
        optimized.add(command);
        continue;
      }

      if (command is ClearCommand ||
          command is DrawPathCommand ||
          command is DrawImageCommand ||
          command is DrawTextRunCommand) {
        if (renderStack.isNotEmpty) {
          renderStack[renderStack.length - 1] = true;
        }
      }

      optimized.add(command);
    }

    final removed = _commands.length - optimized.length;
    _commands
      ..clear()
      ..addAll(optimized);
    return removed;
  }

  void play(GraphicsBackend backend, int width, int height) {
    backend.beginFrame(width, height);
    for (final command in _commands) {
      command.execute(backend);
    }
    backend.endFrame();
  }

  void _applyState(DrawCommand command) {
    if (command is SaveCommand || command is SaveLayerCommand) {
      _transformStack.add(_currentTransform.clone());
      return;
    }

    if (command is RestoreCommand) {
      if (_transformStack.isEmpty) {
        throw StateError('CommandBuffer restore without matching save.');
      }
      _currentTransform = _transformStack.removeLast();
      return;
    }

    if (command is TransformCommand) {
      _currentTransform = command.transform.clone();
    }
  }
}

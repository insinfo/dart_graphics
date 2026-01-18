import 'package:dart_graphics/src/dart_graphics/image/iimage.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/transform/affine.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/ivertex_source.dart';

/// Backend-agnostic render target for recorded graphics commands.
abstract class GraphicsBackend {
  void beginFrame(int width, int height);
  void endFrame();

  void save();
  void restore();
  void setTransform(Affine transform);
  void clipPath(IVertexSource path);

  void clear(Color color);
  void drawPath(IVertexSource path, Paint paint, {StrokeStyle? stroke});
  void drawImage(IImageByte image, Affine transform, {Paint? paint});
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
  const ClipPathCommand(this.path);

  @override
  void execute(GraphicsBackend backend) => backend.clipPath(path);
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

/// A command buffer that can be replayed by any backend.
class CommandBuffer {
  final List<DrawCommand> commands = [];

  void add(DrawCommand command) => commands.add(command);

  void clear() => commands.clear();

  void play(GraphicsBackend backend, int width, int height) {
    backend.beginFrame(width, height);
    for (final command in commands) {
      command.execute(backend);
    }
    backend.endFrame();
  }
}

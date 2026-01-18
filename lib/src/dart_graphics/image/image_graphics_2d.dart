
//
// ImageGraphics2D provides a 2D graphics context for rendering
// to image buffers with support for vector paths and basic image operations.

import 'dart:typed_data';
import '../graphics2D.dart';
import '../primitives/color.dart';
import '../primitives/color_f.dart';
import '../primitives/rectangle_double.dart';
import '../primitives/rectangle_int.dart';
import '../transform/affine.dart';
import '../vertex_source/ivertex_source.dart';
import '../vertex_source/vertex_storage.dart';
import '../vertex_source/rounded_rect.dart';
import '../vertex_source/stroke.dart';
import '../scanline_rasterizer.dart';
import '../scanline_renderer.dart';
import '../interfaces/iscanline.dart';
import '../scanline_unpacked8.dart';
import '../spans/span_allocator.dart';
import '../spans/span_gradient.dart';
import '../spans/span_generator.dart';
import 'iimage.dart';

/// Graphics2D context specialized for rendering to image buffers.
///
/// Provides methods for rendering vector paths, rectangles, and clearing
/// operations. Supports both byte and float image formats.
class ImageGraphics2D extends Graphics2D {
  IScanlineCache? _scanlineCache;
  
  // Reserved for future image rendering features
  // ignore: unused_field
  final VertexStorage _drawImageRectPath = VertexStorage();
  // ignore: unused_field
  final SpanAllocator _destImageSpanAllocatorCache = SpanAllocator();
  // ignore: unused_field
  final ScanlineUnpacked8 _drawImageScanlineCache = ScanlineUnpacked8();

  IImageByte? _destImageByte;
  IImageFloat? _destImageFloat;
  ScanlineRasterizer? _rasterizer;


  /// Creates an empty ImageGraphics2D. Must call [initialize] before use.
  ImageGraphics2D();

  /// Creates an ImageGraphics2D with a byte image destination.
  ImageGraphics2D.withImage(
    IImageByte destImage,
    ScanlineRasterizer rasterizer,
    IScanlineCache scanlineCache,
  ) {
    initialize(destImage, rasterizer);
    _scanlineCache = scanlineCache;
  }

  /// Initializes the graphics context with an image and rasterizer.
  void initialize(IImageByte destImage, ScanlineRasterizer rasterizer) {
    _destImageByte = destImage;
    _rasterizer = rasterizer;
    _scanlineCache ??= ScanlineUnpacked8();
  }

  /// Initializes the graphics context with a float image and rasterizer.
  void initializeFloat(IImageFloat destImage, ScanlineRasterizer rasterizer) {
    _destImageFloat = destImage;
    _rasterizer = rasterizer;
    _scanlineCache ??= ScanlineUnpacked8();
  }

  /// The scanline cache used for rendering.
  IScanlineCache? get scanlineCache => _scanlineCache;
  set scanlineCache(IScanlineCache? value) => _scanlineCache = value;

  /// The byte image destination.
  IImageByte? get destImage => _destImageByte;

  /// The float image destination.
  IImageFloat? get destImageFloat => _destImageFloat;

  /// The rasterizer used for path conversion.
  ScanlineRasterizer get rasterizer => _rasterizer!;

  @override
  int get width => _destImageByte?.width ?? _destImageFloat?.width ?? 0;

  @override
  int get height => _destImageByte?.height ?? _destImageFloat?.height ?? 0;

  /// Gets the current transformation matrix.
  Affine getTransform() {
    final t = transform;
    return Affine(t.sx, t.shy, t.shx, t.sy, t.tx, t.ty);
  }

  /// Pushes a new transformation onto the stack.
  void pushTransform() => save();

  /// Pops the top transformation from the stack.
  void popTransform() => restore();

  /// Sets the clipping rectangle for rendering.
  void setClippingRect(RectangleDouble clippingRect) {
    rasterizer.setVectorClipBox(
      clippingRect.left,
      clippingRect.bottom,
      clippingRect.right,
      clippingRect.top,
    );
  }

  /// Gets the current clipping rectangle.
  RectangleDouble getClippingRect() {
    return rasterizer.getVectorClipBox();
  }

  /// Renders a vertex source with the specified color.
  void render(IVertexSource vertexSource, Color color) {
    rasterizer.reset();

    final source = applyTransform(vertexSource);
    rasterizer.addPath(source);

    if (_destImageByte != null && _scanlineCache != null) {
      ScanlineRenderer.renderSolid(
        rasterizer,
        _scanlineCache!,
        _destImageByte!,
        applyMasterAlpha(color),
      );
      _destImageByte!.markImageChanged();
    }
  }

  @override
  void renderSpanPath(IVertexSource src, ISpanGenerator generator) {
    rasterizer.reset();
    rasterizer.addPath(src);

    if (_destImageByte != null && _scanlineCache != null) {
      final allocator = SpanAllocator();
      ScanlineRenderer.generateAndRender(
        rasterizer,
        _scanlineCache!,
        _destImageByte!,
        allocator,
        generator,
      );
      _destImageByte!.markImageChanged();
    }
  }

  @override
  void renderGradientPath(IVertexSource src, SpanGradient gradient) {
    renderSpanPath(src, gradient);
  }

  @override
  void renderPath(IVertexSource src, Color color) {
    rasterizer.reset();
    rasterizer.addPath(src);

    if (_destImageByte != null && _scanlineCache != null) {
      ScanlineRenderer.renderSolid(
        rasterizer,
        _scanlineCache!,
        _destImageByte!,
        color,
      );
      _destImageByte!.markImageChanged();
    }
  }

  /// Draws a rectangle outline.
  void rectangle(
    double left,
    double bottom,
    double right,
    double top,
    Color color,
    double strokeWidth,
  ) {
    final rect = RoundedRect(left + 0.5, bottom + 0.5, right - 0.5, top - 0.5, 0);
    final rectOutline = Stroke(rect, strokeWidth);
    render(rectOutline, color);
  }

  /// Fills a rectangle with a color.
  void fillRectangle(
    double left,
    double bottom,
    double right,
    double top,
    Color fillColor,
  ) {
    final rect = RoundedRect(left, bottom, right, top, 0);
    render(rect, fillColor);
  }

  /// Clears a rectangular area with a color.
  void clearRect(RectangleDouble bounds, Color color) {
    final intBounds = RectangleInt(
      bounds.left.toInt(),
      bounds.bottom.toInt(),
      bounds.right.toInt(),
      bounds.top.toInt(),
    );
    final clippingRect = getClippingRect();
    var clippingRectInt = RectangleInt(
      clippingRect.left.toInt(),
      clippingRect.bottom.toInt(),
      clippingRect.right.toInt(),
      clippingRect.top.toInt(),
    );

    clippingRectInt.intersectWith(intBounds);
    if (clippingRectInt.width == 0 || clippingRectInt.height == 0) {
      return;
    }

    if (_destImageByte != null) {
      final buffer = _destImageByte!.getBuffer();
      switch (_destImageByte!.bitDepth) {
        case 8:
          _clearRect8(buffer, clippingRectInt, color);
        case 24:
          _clearRect24(buffer, clippingRectInt, color);
        case 32:
          _clearRect32(buffer, clippingRectInt, color);
        default:
          throw UnimplementedError('Unsupported bit depth: ${_destImageByte!.bitDepth}');
      }
      _destImageByte!.markImageChanged();
    } else if (_destImageFloat != null) {
      final buffer = _destImageFloat!.getBuffer();
      final colorF = color.toColorF();
      switch (_destImageFloat!.bitDepth) {
        case 128:
          _clearRectFloat128(buffer, clippingRectInt, colorF);
        default:
          throw UnimplementedError('Unsupported float bit depth: ${_destImageFloat!.bitDepth}');
      }
      _destImageFloat!.markImageChanged();
    }
  }

  void _clearRect8(Uint8List buffer, RectangleInt rect, Color color) {
    for (var y = rect.bottom; y < rect.top; y++) {
      var bufferOffset = _destImageByte!.getBufferOffsetXY(rect.left, y);
      final bytesBetweenPixels = _destImageByte!.getBytesBetweenPixelsInclusive();
      for (var x = 0; x < rect.width; x++) {
        buffer[bufferOffset] = color.blue;
        bufferOffset += bytesBetweenPixels;
      }
    }
  }

  void _clearRect24(Uint8List buffer, RectangleInt rect, Color color) {
    for (var y = rect.bottom; y < rect.top; y++) {
      var bufferOffset = _destImageByte!.getBufferOffsetXY(rect.left, y);
      final bytesBetweenPixels = _destImageByte!.getBytesBetweenPixelsInclusive();
      for (var x = 0; x < rect.width; x++) {
        buffer[bufferOffset + 0] = color.blue;
        buffer[bufferOffset + 1] = color.green;
        buffer[bufferOffset + 2] = color.red;
        bufferOffset += bytesBetweenPixels;
      }
    }
  }

  void _clearRect32(Uint8List buffer, RectangleInt rect, Color color) {
    for (var y = rect.bottom; y < rect.top; y++) {
      var bufferOffset = _destImageByte!.getBufferOffsetXY(rect.left, y);
      final bytesBetweenPixels = _destImageByte!.getBytesBetweenPixelsInclusive();
      for (var x = 0; x < rect.width; x++) {
        buffer[bufferOffset + 0] = color.blue;
        buffer[bufferOffset + 1] = color.green;
        buffer[bufferOffset + 2] = color.red;
        buffer[bufferOffset + 3] = color.alpha;
        bufferOffset += bytesBetweenPixels;
      }
    }
  }

  void _clearRectFloat128(Float32List buffer, RectangleInt rect, ColorF color) {
    for (var y = rect.bottom; y < rect.top; y++) {
      var bufferOffset = _destImageFloat!.getBufferOffsetXY(rect.left, y);
      final floatsBetweenPixels = _destImageFloat!.getFloatsBetweenPixelsInclusive();
      for (var x = 0; x < rect.width; x++) {
        buffer[bufferOffset + 0] = color.blue;
        buffer[bufferOffset + 1] = color.green;
        buffer[bufferOffset + 2] = color.red;
        buffer[bufferOffset + 3] = color.alpha;
        bufferOffset += floatsBetweenPixels;
      }
    }
  }

  @override
  void clear(Color color) {
    clearRect(getClippingRect(), color);
  }
}

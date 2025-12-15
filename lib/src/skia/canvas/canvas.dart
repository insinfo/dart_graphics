/// Canvas class - HTML5-style canvas for 2D drawing
/// 
/// The Canvas represents a drawing surface with associated rendering context.

import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:agg/src/shared/canvas2d/canvas2d.dart';

import '../skia_api.dart';
import '../sk_color.dart';
import 'canvas_rendering_context_2d.dart';

/// An HTML5-style Canvas element for 2D drawing operations
/// 
/// This class wraps a Skia surface and provides the familiar Canvas API.
class Canvas implements IHtmlCanvas {
  final Skia _skia;
  int _width;
  int _height;
  SkiaSurface? _surface;
  CanvasRenderingContext2D? _ctx;
  
  /// Creates a new Canvas with the specified dimensions
  Canvas(this._skia, this._width, this._height) {
    _createSurface();
  }
  
  void _createSurface() {
    _surface?.dispose();
    _surface = _skia.createSurface(_width, _height);
    if (_surface == null) {
      throw StateError('Failed to create canvas surface');
    }
    // Reset context when surface is recreated
    _ctx = null;
  }
  
  /// The width of the canvas in pixels
  int get width => _width;
  set width(int value) {
    if (value != _width && value > 0) {
      _width = value;
      _createSurface();
    }
  }
  
  /// The height of the canvas in pixels
  int get height => _height;
  set height(int value) {
    if (value != _height && value > 0) {
      _height = value;
      _createSurface();
    }
  }
  
  /// The Skia instance this canvas uses
  Skia get skia => _skia;
  
  /// The underlying Skia surface
  SkiaSurface? get surface => _surface;
  
  /// Gets the 2D rendering context
  /// 
  /// Only '2d' context type is supported.
  @override
  CanvasRenderingContext2D getContext(String contextType) {
    if (contextType != '2d') {
      throw ArgumentError("Only '2d' context is supported");
    }
    _ctx ??= CanvasRenderingContext2D(this, _skia);
    return _ctx!;
  }
  
  /// Creates a snapshot of the current canvas state as an image
  SkiaImage? toImage() {
    return _surface?.snapshot();
  }
  
  /// Gets the canvas content as PNG bytes
  Uint8List? toPng() {
    final image = toImage();
    if (image == null) return null;
    try {
      return image.encodeToPng();
    } finally {
      image.dispose();
    }
  }
  
  /// Gets the canvas content as JPEG bytes
  Uint8List? toJpeg({int quality = 90}) {
    final image = toImage();
    if (image == null) return null;
    try {
      return image.encodeToJpeg(quality: quality);
    } finally {
      image.dispose();
    }
  }
  
  /// Gets the canvas content as WebP bytes
  Uint8List? toWebp({int quality = 90}) {
    final image = toImage();
    if (image == null) return null;
    try {
      return image.encodeToWebp(quality: quality);
    } finally {
      image.dispose();
    }
  }
  
  /// Saves the canvas content to a file
  /// 
  /// The format is determined by the file extension (.png, .jpg, .webp)
  @override
  bool saveAs(String filename, {int quality = 90}) {
    final extension = filename.split('.').last.toLowerCase();
    Uint8List? data;
    
    switch (extension) {
      case 'png':
        data = toPng();
        break;
      case 'jpg':
      case 'jpeg':
        data = toJpeg(quality: quality);
        break;
      case 'webp':
        data = toWebp(quality: quality);
        break;
      default:
        data = toPng();
    }
    
    if (data == null) return false;
    
    try {
      File(filename).writeAsBytesSync(data);
      return true;
    } catch (_) {
      return false;
    }
  }
  
  /// Returns a data URL containing a representation of the image
  /// 
  /// Supported types: 'image/png', 'image/jpeg', 'image/webp'
  @override
  String toDataURL([String type = 'image/png', double? quality]) {
    Uint8List? data;
    String mimeType = type;
    final q = quality ?? 0.92;
    
    switch (type) {
      case 'image/jpeg':
        data = toJpeg(quality: (q * 100).round());
        break;
      case 'image/webp':
        data = toWebp(quality: (q * 100).round());
        break;
      case 'image/png':
      default:
        mimeType = 'image/png';
        data = toPng();
        break;
    }
    
    if (data == null) return 'data:,';
    
    final base64Data = base64Encode(data);
    return 'data:$mimeType;base64,$base64Data';
  }
  
  /// Creates a Blob (not fully supported - calls with image data)
  @override
  void toBlob(void Function(dynamic blob) callback, [String type = 'image/png', double? quality]) {
    Uint8List? data;
    final q = quality ?? 0.92;
    
    switch (type) {
      case 'image/jpeg':
        data = toJpeg(quality: (q * 100).round());
        break;
      case 'image/webp':
        data = toWebp(quality: (q * 100).round());
        break;
      default:
        data = toPng();
        break;
    }
    callback(data);
  }
  
  /// Saves the canvas content as a PNG file
  /// 
  /// This is a convenience method that calls saveAs with .png extension.
  bool savePng(String filename) {
    return saveAs(filename);
  }

  /// Clears the canvas with a transparent color
  void clear() {
    _surface?.canvas.clear(SKColors.transparent);
  }
  
  /// Disposes of the canvas resources
  @override
  void dispose() {
    _ctx?.dispose();
    _surface?.dispose();
    _surface = null;
    _ctx = null;
  }
}

/// Canvas class - HTML5-style canvas for 2D drawing using Cairo
/// 
/// The Canvas represents a drawing surface with associated rendering context.

import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:agg/src/shared/canvas2d/canvas2d.dart';

import '../cairo_api.dart';
import '../cairo_types.dart';
import 'canvas_rendering_context_2d.dart';

export 'canvas_rendering_context_2d.dart';
export 'canvas_gradient.dart';
export 'canvas_pattern.dart';
export 'path_2d.dart';

/// An HTML5-style Canvas element for 2D drawing operations using Cairo
/// 
/// This class wraps a Cairo surface and provides the familiar Canvas API.
class CairoHtmlCanvas implements IHtmlCanvas {
  final Cairo _cairo;
  int _width;
  int _height;
  CairoSurfaceImpl? _surface;
  CairoCanvasImpl? _cairoCanvas;
  CairoCanvasRenderingContext2D? _ctx;
  
  /// Creates a new Canvas with the specified dimensions
  CairoHtmlCanvas(this._width, this._height, {Cairo? cairo})
      : _cairo = cairo ?? Cairo() {
    _createSurface();
  }
  
  void _createSurface() {
    _cairoCanvas?.dispose();
    _surface = _cairo.createImageSurface(_width, _height);
    _cairoCanvas = _cairo.createCanvasFromSurface(_surface!);
    // Reset context when surface is recreated
    _ctx = null;
  }
  
  /// The Cairo instance
  Cairo get cairo => _cairo;
  
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
  
  /// The underlying Cairo surface
  CairoSurfaceImpl? get surface => _surface;
  
  /// The underlying Cairo canvas
  CairoCanvasImpl get cairoCanvas => _cairoCanvas!;
  
  /// Gets the 2D rendering context
  /// 
  /// Only '2d' context type is supported.
  @override
  CairoCanvasRenderingContext2D getContext(String contextType) {
    if (contextType != '2d') {
      throw ArgumentError("Only '2d' context is supported");
    }
    _ctx ??= CairoCanvasRenderingContext2D(this);
    return _ctx!;
  }
  
  /// Gets the canvas content as PNG bytes
  Uint8List? toPng() {
    if (_surface == null) return null;
    _surface!.flush();
    
    // Cairo doesn't have direct memory encoding, so we save to temp file
    final tempFile = File('${Directory.systemTemp.path}/cairo_temp_${DateTime.now().millisecondsSinceEpoch}.png');
    try {
      if (_surface!.saveToPng(tempFile.path)) {
        final bytes = tempFile.readAsBytesSync();
        return bytes;
      }
      return null;
    } finally {
      if (tempFile.existsSync()) {
        tempFile.deleteSync();
      }
    }
  }
  
  /// Saves the canvas content to a file
  /// 
  /// The format is determined by the file extension (only .png is supported by Cairo)
  @override
  bool saveAs(String filename, {int quality = 90}) {
    if (_surface == null) return false;
    _surface!.flush();
    
    final extension = filename.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'png':
        return _surface!.saveToPng(filename);
      default:
        // Cairo only supports PNG natively
        return _surface!.saveToPng(filename);
    }
  }
  
  /// Returns a data URL containing a representation of the image
  /// 
  /// Only 'image/png' is supported by Cairo
  @override
  String toDataURL([String type = 'image/png', double? quality]) {
    final data = toPng();
    if (data == null) return 'data:,';
    
    final base64Data = base64Encode(data);
    return 'data:image/png;base64,$base64Data';
  }
  
  /// Creates a Blob (not fully supported - calls with PNG data)
  @override
  void toBlob(void Function(dynamic blob) callback, [String type = 'image/png', double? quality]) {
    callback(toPng());
  }
  
  /// Clears the canvas with a transparent color
  void clear() {
    _cairoCanvas?.clear(CairoColor.transparent);
  }
  
  /// Disposes of the canvas resources
  @override
  void dispose() {
    _ctx?.dispose();
    _cairoCanvas?.dispose();
    _cairoCanvas = null;
    _surface = null;
    _ctx = null;
  }
}

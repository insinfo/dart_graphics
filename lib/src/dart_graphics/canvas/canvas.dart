/// Canvas class - HTML5-style canvas for 2D drawing using DartGraphics
/// 
/// The Canvas represents a drawing surface with associated rendering context.

import 'dart:typed_data';
import 'dart:convert';

import 'package:dart_graphics/src/shared/canvas2d/canvas2d.dart';

import '../image/image_buffer.dart';
import '../image/png_encoder.dart';
import '../primitives/color.dart';
import 'canvas_rendering_context_2d.dart';

export 'canvas_rendering_context_2d.dart';
export 'canvas_gradient.dart';
export 'canvas_pattern.dart';
export 'path_2d.dart';

/// An HTML5-style Canvas element for 2D drawing operations using DartGraphics
/// 
/// This class wraps an DartGraphics ImageBuffer and provides the familiar Canvas API.
class DartGraphicsCanvas implements IHtmlCanvas {
  int _width;
  int _height;
  ImageBuffer? _buffer;
  DartGraphicsCanvasRenderingContext2D? _ctx;
  
  /// Creates a new Canvas with the specified dimensions
  DartGraphicsCanvas(this._width, this._height) {
    _createBuffer();
  }
  
  void _createBuffer() {
    _buffer = ImageBuffer(_width, _height);
    // Clear with white background by default
    clear(Color.white);
    // Reset context when buffer is recreated
    _ctx = null;
  }
  
  /// The width of the canvas in pixels
  int get width => _width;
  set width(int value) {
    if (value != _width && value > 0) {
      _width = value;
      _createBuffer();
    }
  }
  
  /// The height of the canvas in pixels
  int get height => _height;
  set height(int value) {
    if (value != _height && value > 0) {
      _height = value;
      _createBuffer();
    }
  }
  
  /// The underlying DartGraphics ImageBuffer
  ImageBuffer get buffer => _buffer!;
  
  /// Gets the 2D rendering context
  /// 
  /// Only '2d' context type is supported.
  @override
  DartGraphicsCanvasRenderingContext2D getContext(String contextType) {
    if (contextType != '2d') {
      throw ArgumentError("Only '2d' context is supported");
    }
    _ctx ??= DartGraphicsCanvasRenderingContext2D(this);
    return _ctx!;
  }
  
  /// Gets the canvas content as PNG bytes
  Uint8List toPng() {
    return PngEncoder.encode(_buffer!);
  }
  
  /// Saves the canvas content to a file
  /// 
  /// The format is determined by the file extension (only .png is supported)
  @override
  bool saveAs(String filename, {int quality = 90}) {
    if (_buffer == null) return false;
    
    final extension = filename.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'png':
        PngEncoder.saveImage(_buffer!, filename);
        return true;
      default:
        // DartGraphics only supports PNG natively
        PngEncoder.saveImage(_buffer!, filename);
        return true;
    }
  }
  
  /// Returns a data URL containing a representation of the image
  /// 
  /// Only 'image/png' is supported by DartGraphics
  @override
  String toDataURL([String type = 'image/png', double? quality]) {
    final data = toPng();
    final base64Data = base64Encode(data);
    return 'data:image/png;base64,$base64Data';
  }
  
  /// Creates a Blob (not implemented for DartGraphics, throws)
  @override
  void toBlob(void Function(dynamic blob) callback, [String type = 'image/png', double? quality]) {
    // Not fully supported - call with PNG data
    callback(toPng());
  }
  
  /// Clears the canvas with a specified color
  void clear([Color? color]) {
    color ??= Color.transparent;
    if (_buffer == null) return;
    
    for (int y = 0; y < _height; y++) {
      for (int x = 0; x < _width; x++) {
        _buffer!.SetPixel(x, y, color);
      }
    }
  }
  
  /// Disposes of the canvas resources
  @override
  void dispose() {
    _buffer = null;
    _ctx = null;
  }
}

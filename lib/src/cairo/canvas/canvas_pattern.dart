/// CanvasPattern - Cairo implementation of HTML5 Canvas pattern
/// 
/// Represents a repeating image pattern that can be used
/// as a fill or stroke style.

import 'dart:typed_data';

import '../cairo_api.dart';
import '../cairo_pattern.dart';
import '../generated/ffi.dart' as cairo_ffi;
import '../../shared/canvas2d/canvas2d.dart';

/// Represents a pattern for use with Canvas fill/stroke styles
class CairoCanvasPattern implements ICanvasPattern {
  final Cairo _cairo;
  SurfacePattern? _pattern;
  final CairoSurfaceImpl _imageSurface;
  final CanvasPatternRepetition _repetition;
  
  /// Creates a pattern from an image surface
  CairoCanvasPattern._(this._cairo, this._imageSurface, this._repetition);
  
  /// Creates a pattern from pixel data
  factory CairoCanvasPattern.fromPixels(
    Cairo cairo,
    Uint8List pixels,
    int width,
    int height, {
    CanvasPatternRepetition repetition = CanvasPatternRepetition.repeat,
  }) {
    final surface = cairo.createSurfaceFromData(pixels, width, height);
    return CairoCanvasPattern._(cairo, surface, repetition);
  }
  
  /// Creates a pattern from a Cairo surface
  factory CairoCanvasPattern.fromSurface(
    CairoSurfaceImpl surface, {
    CanvasPatternRepetition repetition = CanvasPatternRepetition.repeat,
  }) {
    return CairoCanvasPattern._(surface.cairo, surface, repetition);
  }
  
  /// Gets the Cairo pattern
  CairoPattern getPattern() {
    if (_pattern != null) return _pattern!;
    
    _pattern = SurfacePattern.fromPointer(_cairo, _imageSurface.pointer);
    
    // Set extend mode based on repetition
    switch (_repetition) {
      case CanvasPatternRepetition.repeat:
        _pattern!.setExtend(cairo_ffi.CairoExtendEnum.CAIRO_EXTEND_REPEAT);
        break;
      case CanvasPatternRepetition.repeatX:
      case CanvasPatternRepetition.repeatY:
        // Cairo doesn't have separate X/Y repeat, use repeat
        _pattern!.setExtend(cairo_ffi.CairoExtendEnum.CAIRO_EXTEND_REPEAT);
        break;
      case CanvasPatternRepetition.noRepeat:
        _pattern!.setExtend(cairo_ffi.CairoExtendEnum.CAIRO_EXTEND_NONE);
        break;
    }
    
    return _pattern!;
  }
  
  /// Sets a transformation matrix for the pattern
  @override
  void setTransform([DOMMatrix? transform]) {
    // Note: Cairo pattern transformation is inverse of desired transform
    // This is a simplified implementation
    getPattern(); // Ensure pattern is created
  }
  
  void dispose() {
    _pattern?.dispose();
    _pattern = null;
    // Note: _imageSurface ownership depends on how pattern was created
  }
}

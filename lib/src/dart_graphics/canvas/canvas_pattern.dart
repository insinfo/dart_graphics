/// CanvasPattern - DartGraphics implementation of HTML5 Canvas pattern
/// 
/// Represents a pattern that can be used as a fill or stroke style.

import 'package:dart_graphics/src/shared/canvas2d/canvas2d.dart';

import '../image/image_buffer.dart';
import '../primitives/color.dart';

/// Represents a pattern for use with Canvas fill/stroke styles
class DartGraphicsCanvasPattern implements ICanvasPattern {
  final ImageBuffer _image;
  final CanvasPatternRepetition _repetition;
  DOMMatrix? _transform;
  
  /// Creates a pattern from an image
  /// 
  /// [image] is the source image for the pattern
  /// [repetition] can be 'repeat', 'repeat-x', 'repeat-y', or 'no-repeat'
  DartGraphicsCanvasPattern(ImageBuffer image, String repetition)
      : _image = image,
        _repetition = _parseRepetition(repetition);
  
  static CanvasPatternRepetition _parseRepetition(String repetition) {
    switch (repetition.toLowerCase()) {
      case 'repeat':
        return CanvasPatternRepetition.repeat;
      case 'repeat-x':
        return CanvasPatternRepetition.repeatX;
      case 'repeat-y':
        return CanvasPatternRepetition.repeatY;
      case 'no-repeat':
        return CanvasPatternRepetition.noRepeat;
      default:
        return CanvasPatternRepetition.repeat;
    }
  }
  
  /// Sets the transformation matrix for the pattern
  @override
  void setTransform([DOMMatrix? transform]) {
    _transform = transform;
  }
  
  /// The source image
  ImageBuffer get image => _image;
  
  /// The repetition mode
  CanvasPatternRepetition get repetition => _repetition;
  
  /// The transform matrix
  DOMMatrix? get transform => _transform;
  
  /// Gets the color at a given position, applying the pattern repetition
  Color getColorAt(int x, int y) {
    int srcX = x;
    int srcY = y;
    
    switch (_repetition) {
      case CanvasPatternRepetition.repeat:
        srcX = x % _image.width;
        srcY = y % _image.height;
        if (srcX < 0) srcX += _image.width;
        if (srcY < 0) srcY += _image.height;
        break;
        
      case CanvasPatternRepetition.repeatX:
        srcX = x % _image.width;
        if (srcX < 0) srcX += _image.width;
        if (srcY < 0 || srcY >= _image.height) {
          return Color.transparent;
        }
        break;
        
      case CanvasPatternRepetition.repeatY:
        srcY = y % _image.height;
        if (srcY < 0) srcY += _image.height;
        if (srcX < 0 || srcX >= _image.width) {
          return Color.transparent;
        }
        break;
        
      case CanvasPatternRepetition.noRepeat:
        if (srcX < 0 || srcX >= _image.width ||
            srcY < 0 || srcY >= _image.height) {
          return Color.transparent;
        }
        break;
    }
    
    return _image.getPixel(srcX, srcY);
  }
}

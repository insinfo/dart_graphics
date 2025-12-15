/// Canvas Pattern - HTML5-style pattern for Canvas 2D
/// 
/// Provides repeating image patterns for fill and stroke styles.

import '../../shared/canvas2d/canvas2d.dart';

/// A pattern that can be used as fill or stroke style
class CanvasPattern implements ICanvasPattern {
  final dynamic _image;
  final String _repetition;
  double _transformA = 1, _transformB = 0, _transformC = 0;
  double _transformD = 1, _transformE = 0, _transformF = 0;
  
  /// Creates a pattern from an image with the specified repetition
  /// 
  /// [repetition] can be:
  /// - 'repeat' - Repeat in both directions (default)
  /// - 'repeat-x' - Repeat horizontally only
  /// - 'repeat-y' - Repeat vertically only
  /// - 'no-repeat' - Do not repeat
  CanvasPattern(this._image, this._repetition);
  
  /// Gets the source image
  dynamic get image => _image;
  
  /// Gets the repetition mode
  String get repetition => _repetition;
  
  /// Whether to repeat in X direction
  bool get repeatX => _repetition == 'repeat' || _repetition == 'repeat-x';
  
  /// Whether to repeat in Y direction
  bool get repeatY => _repetition == 'repeat' || _repetition == 'repeat-y';
  
  /// Sets the transformation matrix for the pattern
  @override
  void setTransform([DOMMatrix? transform]) {
    if (transform != null) {
      _transformA = transform.a;
      _transformB = transform.b;
      _transformC = transform.c;
      _transformD = transform.d;
      _transformE = transform.e;
      _transformF = transform.f;
    } else {
      _transformA = 1;
      _transformB = 0;
      _transformC = 0;
      _transformD = 1;
      _transformE = 0;
      _transformF = 0;
    }
  }
  
  /// Gets the transformation matrix as a list [a, b, c, d, e, f]
  List<double> get transform => [
    _transformA, _transformB, _transformC,
    _transformD, _transformE, _transformF
  ];
}

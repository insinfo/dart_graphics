/// Canvas Pattern - HTML5-style pattern for Canvas 2D
/// 
/// Provides repeating image patterns for fill and stroke styles.

/// A pattern that can be used as fill or stroke style
class CanvasPattern {
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
  void setTransform({
    double a = 1,
    double b = 0,
    double c = 0,
    double d = 1,
    double e = 0,
    double f = 0,
  }) {
    _transformA = a;
    _transformB = b;
    _transformC = c;
    _transformD = d;
    _transformE = e;
    _transformF = f;
  }
  
  /// Gets the transformation matrix as a list [a, b, c, d, e, f]
  List<double> get transform => [
    _transformA, _transformB, _transformC,
    _transformD, _transformE, _transformF
  ];
}

/// HTML5 TextMetrics Interface
/// 
/// Reference: https://developer.mozilla.org/en-US/docs/Web/API/TextMetrics

/// Abstract TextMetrics Interface
/// 
/// Represents the dimensions of a piece of text.
abstract class ITextMetrics {
  /// The calculated width of the text
  double get width;
  
  /// Distance from the alignment point to the left side of the bounding rectangle
  double get actualBoundingBoxLeft;
  
  /// Distance from the alignment point to the right side of the bounding rectangle
  double get actualBoundingBoxRight;
  
  /// Distance from the baseline to the top of the bounding rectangle
  double get actualBoundingBoxAscent;
  
  /// Distance from the baseline to the bottom of the bounding rectangle
  double get actualBoundingBoxDescent;
  
  /// Distance from the baseline to the top of the font's em square
  double get fontBoundingBoxAscent;
  
  /// Distance from the baseline to the bottom of the font's em square
  double get fontBoundingBoxDescent;
  
  /// Distance from the baseline to the top of the highest letter
  double get emHeightAscent;
  
  /// Distance from the baseline to the bottom of the lowest descender
  double get emHeightDescent;
  
  /// Distance from the baseline to the hanging baseline
  double get hangingBaseline;
  
  /// Distance from the baseline to the alphabetic baseline
  double get alphabeticBaseline;
  
  /// Distance from the baseline to the ideographic baseline
  double get ideographicBaseline;
}

/// Default implementation of TextMetrics
class TextMetrics implements ITextMetrics {
  @override
  final double width;
  
  @override
  final double actualBoundingBoxLeft;
  
  @override
  final double actualBoundingBoxRight;
  
  @override
  final double actualBoundingBoxAscent;
  
  @override
  final double actualBoundingBoxDescent;
  
  @override
  final double fontBoundingBoxAscent;
  
  @override
  final double fontBoundingBoxDescent;
  
  @override
  final double emHeightAscent;
  
  @override
  final double emHeightDescent;
  
  @override
  final double hangingBaseline;
  
  @override
  final double alphabeticBaseline;
  
  @override
  final double ideographicBaseline;
  
  const TextMetrics({
    required this.width,
    this.actualBoundingBoxLeft = 0,
    this.actualBoundingBoxRight = 0,
    this.actualBoundingBoxAscent = 0,
    this.actualBoundingBoxDescent = 0,
    this.fontBoundingBoxAscent = 0,
    this.fontBoundingBoxDescent = 0,
    this.emHeightAscent = 0,
    this.emHeightDescent = 0,
    this.hangingBaseline = 0,
    this.alphabeticBaseline = 0,
    this.ideographicBaseline = 0,
  });
  
  /// Creates a simple TextMetrics with just width
  factory TextMetrics.simple(double width) => TextMetrics(width: width);
}

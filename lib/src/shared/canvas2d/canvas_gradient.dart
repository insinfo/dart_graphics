/// HTML5 CanvasGradient Interface
/// 
/// Reference: https://developer.mozilla.org/en-US/docs/Web/API/CanvasGradient

/// Abstract CanvasGradient Interface
/// 
/// Represents a gradient that can be used as fillStyle or strokeStyle.
abstract class ICanvasGradient {
  /// Adds a color stop to the gradient
  /// 
  /// [offset] is a number between 0.0 and 1.0 representing the position
  /// [color] is a CSS color string
  void addColorStop(double offset, String color);
}

/// HTML5 CanvasPattern Interface
/// 
/// Reference: https://developer.mozilla.org/en-US/docs/Web/API/CanvasPattern

import 'canvas_rendering_context_2d.dart';

/// Abstract CanvasPattern Interface
/// 
/// Represents a pattern that can be used as fillStyle or strokeStyle.
abstract class ICanvasPattern {
  /// Sets the transformation matrix for the pattern
  void setTransform([DOMMatrix? transform]);
}

/// Pattern repetition modes
enum PatternRepetition {
  /// Repeat in both directions (default)
  repeat,
  /// Repeat horizontally only
  repeatX,
  /// Repeat vertically only
  repeatY,
  /// No repetition
  noRepeat
}

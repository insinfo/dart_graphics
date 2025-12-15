/// HTML5 Canvas 2D Rendering Context Interface
/// 
/// This abstract class defines the standard HTML5 Canvas 2D API interface
/// that all implementations (AGG, Cairo, Skia) should follow.
/// 
/// Reference: https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D

import 'path_2d.dart';
import 'canvas_gradient.dart';
import 'canvas_pattern.dart';
import 'text_metrics.dart';
import 'image_data.dart';

/// Text alignment options for canvas text rendering
enum TextAlign { 
  /// Align to the left edge
  left, 
  /// Align to the right edge
  right, 
  /// Center alignment
  center, 
  /// Align to the start (left for LTR, right for RTL)
  start, 
  /// Align to the end (right for LTR, left for RTL)
  end 
}

/// Text baseline options for canvas text rendering
enum TextBaseline { 
  /// Top of the em square
  top, 
  /// Hanging baseline (used primarily for Indic scripts)
  hanging, 
  /// Middle of the em square
  middle, 
  /// Alphabetic baseline (default)
  alphabetic, 
  /// Ideographic baseline (used for CJK scripts)
  ideographic, 
  /// Bottom of the em square
  bottom 
}

/// Image smoothing quality options
enum ImageSmoothingQuality { 
  /// Low quality (fastest)
  low, 
  /// Medium quality
  medium, 
  /// High quality (slowest)
  high 
}

/// Text direction for bidirectional text
enum CanvasDirection { 
  /// Left-to-right
  ltr, 
  /// Right-to-left
  rtl, 
  /// Inherit from parent
  inherit 
}

/// Line cap style for strokes
enum LineCap {
  /// Flat edge (default)
  butt,
  /// Rounded edge
  round,
  /// Square edge extending half line width
  square
}

/// Line join style for strokes
enum LineJoin {
  /// Sharp corner (default)
  miter,
  /// Rounded corner
  round,
  /// Beveled corner
  bevel
}

/// Fill rule for determining inside/outside of paths
enum FillRule {
  /// Non-zero winding rule (default)
  nonzero,
  /// Even-odd rule
  evenodd
}

/// Abstract Canvas 2D Rendering Context
/// 
/// This interface follows the HTML5 Canvas 2D specification.
/// All methods and properties match the JavaScript API.
abstract class ICanvasRenderingContext2D {
  // ==================== Canvas Reference ====================
  
  /// Reference to the parent canvas element
  IHtmlCanvas get canvas;
  
  // ==================== State Management ====================
  
  /// Saves the entire state of the canvas by pushing it onto a stack
  void save();
  
  /// Restores the most recently saved canvas state by popping from the stack
  void restore();
  
  /// Resets the rendering context to its default state
  void reset();
  
  /// Returns whether the context is lost
  bool isContextLost();
  
  // ==================== Transform Methods ====================
  
  /// Retrieves the current transformation matrix
  DOMMatrix getTransform();
  
  /// Resets the current transform to the identity matrix
  void resetTransform();
  
  /// Adds a rotation to the transformation matrix
  /// [angle] is in radians
  void rotate(double angle);
  
  /// Adds a scaling transformation
  void scale(double x, double y);
  
  /// Multiplies the current transformation with the specified matrix
  void transform(double a, double b, double c, double d, double e, double f);
  
  /// Resets and sets the transformation matrix
  void setTransform(double a, double b, double c, double d, double e, double f);
  
  /// Adds a translation transformation
  void translate(double x, double y);
  
  // ==================== Compositing ====================
  
  /// Global alpha (transparency) value between 0.0 and 1.0
  double get globalAlpha;
  set globalAlpha(double value);
  
  /// Global composite operation (blend mode)
  /// 
  /// Valid values: 'source-over', 'source-in', 'source-out', 'source-atop',
  /// 'destination-over', 'destination-in', 'destination-out', 'destination-atop',
  /// 'lighter', 'copy', 'xor', 'multiply', 'screen', 'overlay', 'darken',
  /// 'lighten', 'color-dodge', 'color-burn', 'hard-light', 'soft-light',
  /// 'difference', 'exclusion', 'hue', 'saturation', 'color', 'luminosity'
  String get globalCompositeOperation;
  set globalCompositeOperation(String value);
  
  // ==================== Image Smoothing ====================
  
  /// Whether images drawn on the canvas should be smoothed
  bool get imageSmoothingEnabled;
  set imageSmoothingEnabled(bool value);
  
  /// Quality level of image smoothing
  ImageSmoothingQuality get imageSmoothingQuality;
  set imageSmoothingQuality(ImageSmoothingQuality value);
  
  // ==================== Fill and Stroke Styles ====================
  
  /// Current fill style (color string, gradient, or pattern)
  /// 
  /// Can be set with:
  /// - CSS color string: '#FF0000', 'red', 'rgb(255,0,0)', 'rgba(255,0,0,0.5)'
  /// - CanvasGradient object
  /// - CanvasPattern object
  Object get fillStyle;
  set fillStyle(Object value);
  
  /// Current stroke style (color string, gradient, or pattern)
  Object get strokeStyle;
  set strokeStyle(Object value);
  
  /// Creates a linear gradient along a line
  ICanvasGradient createLinearGradient(double x0, double y0, double x1, double y1);
  
  /// Creates a radial gradient between two circles
  ICanvasGradient createRadialGradient(double x0, double y0, double r0, double x1, double y1, double r1);
  
  /// Creates a conic gradient around a point
  ICanvasGradient createConicGradient(double startAngle, double x, double y);
  
  /// Creates a pattern from an image
  ICanvasPattern? createPattern(dynamic image, String repetition);
  
  // ==================== Shadow Properties ====================
  
  /// Blur level for shadows (default: 0)
  double get shadowBlur;
  set shadowBlur(double value);
  
  /// Color of shadows (default: 'transparent')
  String get shadowColor;
  set shadowColor(String value);
  
  /// Horizontal offset for shadows (default: 0)
  double get shadowOffsetX;
  set shadowOffsetX(double value);
  
  /// Vertical offset for shadows (default: 0)
  double get shadowOffsetY;
  set shadowOffsetY(double value);
  
  // ==================== Filters ====================
  
  /// CSS filter string for the canvas (e.g., 'blur(5px)')
  String get filter;
  set filter(String value);
  
  // ==================== Line Styles ====================
  
  /// Width of lines (default: 1.0)
  double get lineWidth;
  set lineWidth(double value);
  
  /// Style of line endings: 'butt', 'round', or 'square'
  String get lineCap;
  set lineCap(String value);
  
  /// Style of line joins: 'miter', 'round', or 'bevel'
  String get lineJoin;
  set lineJoin(String value);
  
  /// Miter limit ratio (default: 10)
  double get miterLimit;
  set miterLimit(double value);
  
  /// Offset for the dash pattern
  double get lineDashOffset;
  set lineDashOffset(double value);
  
  /// Gets the current line dash pattern
  List<double> getLineDash();
  
  /// Sets the line dash pattern
  /// [segments] alternates between line and gap lengths
  void setLineDash(List<double> segments);
  
  // ==================== Text Properties ====================
  
  /// Font specification string (e.g., '16px Arial', 'bold 24px serif')
  String get font;
  set font(String value);
  
  /// Text alignment: 'left', 'right', 'center', 'start', or 'end'
  String get textAlign;
  set textAlign(String value);
  
  /// Text baseline: 'top', 'hanging', 'middle', 'alphabetic', 'ideographic', or 'bottom'
  String get textBaseline;
  set textBaseline(String value);
  
  /// Text direction: 'ltr', 'rtl', or 'inherit'
  String get direction;
  set direction(String value);
  
  /// Letter spacing (CSS units)
  String get letterSpacing;
  set letterSpacing(String value);
  
  /// Font kerning: 'auto', 'normal', or 'none'
  String get fontKerning;
  set fontKerning(String value);
  
  /// Font stretch (CSS font-stretch values)
  String get fontStretch;
  set fontStretch(String value);
  
  /// Font variant caps
  String get fontVariantCaps;
  set fontVariantCaps(String value);
  
  /// Text rendering optimization
  String get textRendering;
  set textRendering(String value);
  
  /// Word spacing (CSS units)
  String get wordSpacing;
  set wordSpacing(String value);
  
  // ==================== Path Methods ====================
  
  /// Begins a new path, clearing any existing path data
  void beginPath();
  
  /// Closes the current subpath by drawing a line to the start
  void closePath();
  
  /// Moves the pen to the specified coordinates
  void moveTo(double x, double y);
  
  /// Draws a straight line to the specified coordinates
  void lineTo(double x, double y);
  
  /// Draws a quadratic Bézier curve
  void quadraticCurveTo(double cpx, double cpy, double x, double y);
  
  /// Draws a cubic Bézier curve
  void bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y);
  
  /// Draws an arc using control points and radius
  void arcTo(double x1, double y1, double x2, double y2, double radius);
  
  /// Draws a circular arc
  /// [startAngle] and [endAngle] are in radians
  void arc(double x, double y, double radius, double startAngle, double endAngle, [bool counterclockwise = false]);
  
  /// Draws an elliptical arc
  void ellipse(double x, double y, double radiusX, double radiusY, double rotation, double startAngle, double endAngle, [bool counterclockwise = false]);
  
  /// Adds a rectangle to the current path
  void rect(double x, double y, double width, double height);
  
  /// Adds a rounded rectangle to the current path
  /// [radii] can be a number or list of numbers for each corner
  void roundRect(double x, double y, double width, double height, [dynamic radii]);
  
  // ==================== Drawing Paths ====================
  
  /// Fills the current or given path
  /// [pathOrFillRule] can be a Path2D or fill rule string ('nonzero' or 'evenodd')
  void fill([dynamic pathOrFillRule, String? fillRule]);
  
  /// Strokes the current or given path
  void stroke([IPath2D? path]);
  
  /// Creates a clipping region from the current path
  void clip([dynamic pathOrFillRule, String? fillRule]);
  
  /// Reports whether the specified point is inside the current path
  bool isPointInPath(double x, double y, [String fillRule = 'nonzero']);
  
  /// Reports whether the specified point is inside the stroked area
  bool isPointInStroke(double x, double y);
  
  // ==================== Drawing Rectangles ====================
  
  /// Fills a rectangle
  void fillRect(double x, double y, double width, double height);
  
  /// Strokes a rectangle
  void strokeRect(double x, double y, double width, double height);
  
  /// Clears a rectangular area to transparent
  void clearRect(double x, double y, double width, double height);
  
  // ==================== Drawing Text ====================
  
  /// Fills text at the specified position
  void fillText(String text, double x, double y, [double? maxWidth]);
  
  /// Strokes text at the specified position
  void strokeText(String text, double x, double y, [double? maxWidth]);
  
  /// Measures the specified text
  ITextMetrics measureText(String text);
  
  // ==================== Drawing Images ====================
  
  /// Draws an image to the canvas
  /// 
  /// Overloads:
  /// - drawImage(image, dx, dy)
  /// - drawImage(image, dx, dy, dWidth, dHeight)
  /// - drawImage(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight)
  void drawImage(dynamic image, double dx, double dy, [double? dWidth, double? dHeight, double? sx, double? sy, double? sWidth, double? sHeight]);
  
  // ==================== Pixel Manipulation ====================
  
  /// Creates a new ImageData object with the specified dimensions
  IImageData createImageData(int width, int height);
  
  /// Returns an ImageData object for the specified rectangle
  IImageData getImageData(int sx, int sy, int sw, int sh);
  
  /// Paints data from an ImageData object to the canvas
  void putImageData(IImageData imageData, int dx, int dy, [int? dirtyX, int? dirtyY, int? dirtyWidth, int? dirtyHeight]);
  
  // ==================== Focus Management ====================
  
  /// Draws a focus ring around the current or given path
  void drawFocusIfNeeded(dynamic elementOrPath, [dynamic element]);
  
  /// Scrolls the current or given path into view
  void scrollPathIntoView([IPath2D? path]);
}

/// Abstract HTML Canvas Element Interface
abstract class IHtmlCanvas {
  /// Width of the canvas in pixels
  int get width;
  set width(int value);
  
  /// Height of the canvas in pixels
  int get height;
  set height(int value);
  
  /// Returns a drawing context
  /// 
  /// Returns the rendering context for the canvas, typically '2d' for 2D drawing.
  /// The return type is dynamic to allow concrete implementations to return
  /// their specific context types.
  dynamic getContext(String contextType);
  
  /// Returns a data URL containing the image
  String toDataURL([String type = 'image/png', double? quality]);
  
  /// Creates a Blob object representing the image
  void toBlob(void Function(dynamic blob) callback, [String type = 'image/png', double? quality]);
  
  /// Saves the canvas to a file (extension method, not in HTML5 spec)
  bool saveAs(String filename);
  
  /// Disposes of resources
  void dispose();
}

/// 2D Transformation Matrix (DOMMatrix)
/// 
/// Represents a 2D transformation matrix:
/// | a  c  e |
/// | b  d  f |
/// | 0  0  1 |
class DOMMatrix {
  double a, b, c, d, e, f;
  
  DOMMatrix([this.a = 1, this.b = 0, this.c = 0, this.d = 1, this.e = 0, this.f = 0]);
  
  factory DOMMatrix.identity() => DOMMatrix(1, 0, 0, 1, 0, 0);
  
  DOMMatrix clone() => DOMMatrix(a, b, c, d, e, f);
  
  /// Returns the result of multiplying this matrix by another
  DOMMatrix multiplied(DOMMatrix other) {
    return DOMMatrix(
      a * other.a + c * other.b,
      b * other.a + d * other.b,
      a * other.c + c * other.d,
      b * other.c + d * other.d,
      a * other.e + c * other.f + e,
      b * other.e + d * other.f + f,
    );
  }
  
  /// Returns a new matrix scaled by the given amounts
  DOMMatrix scaled(double sx, double sy) {
    return multiplied(DOMMatrix(sx, 0, 0, sy, 0, 0));
  }
  
  /// Returns a new matrix rotated by the given angle (in radians)
  DOMMatrix rotated(double angle) {
    final cos = _cos(angle);
    final sin = _sin(angle);
    return multiplied(DOMMatrix(cos, sin, -sin, cos, 0, 0));
  }
  
  /// Returns a new matrix translated by the given amounts
  DOMMatrix translated(double tx, double ty) {
    return multiplied(DOMMatrix(1, 0, 0, 1, tx, ty));
  }
  
  /// Transforms a point using this matrix
  ({double x, double y}) transformPoint(double x, double y) {
    return (
      x: a * x + c * y + e,
      y: b * x + d * y + f,
    );
  }
  
  /// Returns the inverse of this matrix
  DOMMatrix? inverse() {
    final det = a * d - b * c;
    if (det == 0) return null;
    
    final invDet = 1.0 / det;
    return DOMMatrix(
      d * invDet,
      -b * invDet,
      -c * invDet,
      a * invDet,
      (c * f - d * e) * invDet,
      (b * e - a * f) * invDet,
    );
  }
  
  static double _cos(double angle) {
    // Handle common angles for precision
    if (angle == 0) return 1;
    if (angle == 1.5707963267948966) return 0; // pi/2
    if (angle == 3.141592653589793) return -1; // pi
    if (angle == 4.71238898038469) return 0; // 3*pi/2
    return _dartCos(angle);
  }
  
  static double _sin(double angle) {
    if (angle == 0) return 0;
    if (angle == 1.5707963267948966) return 1; // pi/2
    if (angle == 3.141592653589793) return 0; // pi
    if (angle == 4.71238898038469) return -1; // 3*pi/2
    return _dartSin(angle);
  }
  
  // Import dart:math functions
  static double _dartCos(double x) {
    return _Math.cos(x);
  }
  
  static double _dartSin(double x) {
    return _Math.sin(x);
  }
  
  @override
  String toString() => 'DOMMatrix($a, $b, $c, $d, $e, $f)';
  
  @override
  bool operator ==(Object other) =>
      other is DOMMatrix &&
      other.a == a &&
      other.b == b &&
      other.c == c &&
      other.d == d &&
      other.e == e &&
      other.f == f;
  
  @override
  int get hashCode => Object.hash(a, b, c, d, e, f);
}

// Math import helper
class _Math {
  static double cos(double x) {
    return _cosImpl(x);
  }
  
  static double sin(double x) {
    return _sinImpl(x);
  }
  
  static double _cosImpl(double x) {
    // Taylor series approximation for cos
    x = x % (2 * 3.141592653589793);
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }
  
  static double _sinImpl(double x) {
    // Taylor series approximation for sin
    x = x % (2 * 3.141592653589793);
    double result = x;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }
}

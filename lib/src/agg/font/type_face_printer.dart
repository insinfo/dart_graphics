//
// TypeFacePrinter renders text as IVertexSource, providing vertices for
// each glyph in the text string with proper positioning and alignment.

import 'package:agg/src/shared/ref_param.dart';
import '../primitives/rectangle_double.dart';
import '../vertex_source/ivertex_source.dart';
import '../vertex_source/path_commands.dart';
import '../vertex_source/vertex_data.dart';
import 'styled_type_face.dart';

/// Text justification options
enum Justification {
  left,
  center,
  right,
}

/// Text baseline alignment options
enum Baseline {
  /// Align to top of bounding box
  boundsTop,
  /// Align to center of bounding box
  boundsCenter,
  /// Align to center of text height
  textCenter,
  /// Align to text baseline
  text,
  /// Align to bottom of bounding box
  boundsBottom,
}

/// Renders text as vertex source data.
/// Converts a text string into a series of glyph outlines that can be rendered.
class TypeFacePrinter implements IVertexSource {
  String _text = '';
  ({double x, double y}) _totalSizeCache = (x: 0.0, y: 0.0);
  final Map<int, double> _fastAdvance = {};

  /// The styled typeface used for rendering
  StyledTypeFace typeFaceStyle;

  /// Text justification
  Justification justification;

  /// Text baseline alignment
  Baseline baseline;

  /// Origin position for the text
  ({double x, double y}) origin;

  /// Whether to draw from a hinted cache (for performance)
  bool drawFromHintedCache;

  /// Resolution scale for curve flattening
  double resolutionScale;

  /// Creates a TypeFacePrinter with the specified parameters.
  ///
  /// [text] - The text to render
  /// [typeFaceStyle] - The styled typeface for rendering
  /// [origin] - Position to render the text
  /// [justification] - Text alignment
  /// [baseline] - Vertical baseline alignment
  TypeFacePrinter({
    String text = '',
    required this.typeFaceStyle,
    ({double x, double y})? origin,
    this.justification = Justification.left,
    this.baseline = Baseline.text,
    this.drawFromHintedCache = false,
    this.resolutionScale = 1.0,
  })  : _text = text,
        origin = origin ?? (x: 0.0, y: 0.0);

  /// Gets or sets the text to render
  String get text => _text;
  set text(String value) {
    if (_text != value) {
      _totalSizeCache = (x: 0.0, y: 0.0);
      _text = value;
    }
  }

  /// Gets the local bounding rectangle of the text
  RectangleDouble get localBounds {
    final size = getSize();
    RectangleDouble bounds;

    switch (justification) {
      case Justification.left:
        bounds = RectangleDouble(
          0,
          typeFaceStyle.descentInPixels,
          size.x,
          size.y + typeFaceStyle.descentInPixels,
        );
      case Justification.center:
        bounds = RectangleDouble(
          -size.x / 2,
          typeFaceStyle.descentInPixels,
          size.x / 2,
          size.y + typeFaceStyle.descentInPixels,
        );
      case Justification.right:
        bounds = RectangleDouble(
          -size.x,
          typeFaceStyle.descentInPixels,
          0,
          size.y + typeFaceStyle.descentInPixels,
        );
    }

    switch (baseline) {
      case Baseline.boundsCenter:
        bounds = RectangleDouble(
          bounds.left,
          bounds.bottom - typeFaceStyle.ascentInPixels / 2,
          bounds.right,
          bounds.top - typeFaceStyle.ascentInPixels / 2,
        );
      case Baseline.boundsTop:
        bounds = RectangleDouble(
          bounds.left,
          bounds.bottom - typeFaceStyle.ascentInPixels,
          bounds.right,
          bounds.top - typeFaceStyle.ascentInPixels,
        );
      default:
        // Keep bounds as-is
        break;
    }

    return RectangleDouble(
      bounds.left + origin.x,
      bounds.bottom + origin.y,
      bounds.right + origin.x,
      bounds.top + origin.y,
    );
  }

  @override
  void rewind([int pathId = 0]) {
    // No-op for TypeFacePrinter
  }

  @override
  FlagsAndCommand vertex(RefParam<double> x, RefParam<double> y) {
    // Vertex iteration is handled by vertices() iterator
    x.value = 0;
    y.value = 0;
    return FlagsAndCommand.commandStop;
  }

  @override
  int getLongHashCode([int hash = 0xcbf29ce484222325]) {
    // Simple hash combining text and style
    hash ^= _text.hashCode;
    hash *= 1099511628211;
    return hash;
  }

  @override
  Iterable<VertexData> vertices() sync* {
    if (_text.isNotEmpty) {
      var currentOffset = (x: 0.0, y: 0.0);
      currentOffset = _getBaseline(currentOffset);

      final lines = _text.split('\n');
      for (final line in lines) {
        currentOffset = _getXPositionForLineBasedOnJustification(currentOffset, line);

        for (var currentChar = 0; currentChar < line.length; currentChar++) {
          final codePoint = line.codeUnitAt(currentChar);
          final currentGlyph =
              typeFaceStyle.getGlyphForCharacter(codePoint, resolutionScale);

          if (currentGlyph != null) {
            for (final vertexData in currentGlyph.vertices()) {
              if (!vertexData.isStop) {
                yield VertexData(
                  vertexData.command,
                  vertexData.x + currentOffset.x + origin.x,
                  vertexData.y + currentOffset.y + origin.y,
                );
              }
            }
          }

          // Get the advance for the next character
          currentOffset = (
            x: currentOffset.x + typeFaceStyle.getAdvanceForCharacterInString(line, currentChar),
            y: currentOffset.y,
          );
        }

        // Move down a line
        currentOffset = (
          x: 0.0,
          y: currentOffset.y - typeFaceStyle.emSizeInPixels,
        );
      }
    }

    yield VertexData(FlagsAndCommand.commandStop, 0, 0);
  }

  /// Gets the X position based on justification
  ({double x, double y}) _getXPositionForLineBasedOnJustification(
      ({double x, double y}) currentOffset, String line) {
    final size = getSize(line);
    switch (justification) {
      case Justification.left:
        return (x: 0.0, y: currentOffset.y);
      case Justification.center:
        return (x: -size.x / 2, y: currentOffset.y);
      case Justification.right:
        return (x: -size.x, y: currentOffset.y);
    }
  }

  /// Gets the Y offset based on baseline alignment
  ({double x, double y}) _getBaseline(({double x, double y}) currentOffset) {
    switch (baseline) {
      case Baseline.text:
        return (x: currentOffset.x, y: 0.0);
      case Baseline.boundsTop:
        return (x: currentOffset.x, y: -typeFaceStyle.ascentInPixels);
      case Baseline.boundsCenter:
        return (x: currentOffset.x, y: -typeFaceStyle.ascentInPixels / 2);
      case Baseline.boundsBottom:
        return (x: currentOffset.x, y: typeFaceStyle.descentInPixels);
      case Baseline.textCenter:
        return (
          x: currentOffset.x,
          y: -(typeFaceStyle.ascentInPixels + typeFaceStyle.descentInPixels) / 2,
        );
    }
  }

  /// Gets the total size of the text.
  ({double x, double y}) getSize([String? textToMeasure]) {
    textToMeasure ??= _text;

    if (textToMeasure != _text) {
      return _calculateSize(0, textToMeasure.length - 1, textToMeasure);
    }

    if (_totalSizeCache.x == 0 && textToMeasure.isNotEmpty) {
      _totalSizeCache = _calculateSize(0, textToMeasure.length - 1, textToMeasure);
    }

    return _totalSizeCache;
  }

  /// Calculates the size of text between indices.
  ({double x, double y}) _calculateSize(int startIndex, int endIndex, String textToMeasure) {
    double offsetX = 0;
    double offsetY = typeFaceStyle.emSizeInPixels;

    double currentLineX = 0;

    for (var i = startIndex; i < endIndex; i++) {
      if (textToMeasure[i] == '\n') {
        if (i + 1 < endIndex &&
            textToMeasure[i + 1] == '\n' &&
            textToMeasure[i] != textToMeasure[i + 1]) {
          i++;
        }
        currentLineX = 0;
        offsetY += typeFaceStyle.emSizeInPixels;
      } else {
        currentLineX += typeFaceStyle.getAdvanceForCharacterInString(textToMeasure, i);
        if (currentLineX > offsetX) {
          offsetX = currentLineX;
        }
      }
    }

    if (textToMeasure.length > endIndex && endIndex >= 0) {
      if (textToMeasure[endIndex] == '\n') {
        offsetY += typeFaceStyle.emSizeInPixels;
      } else {
        offsetX += typeFaceStyle.getAdvanceForCharacterInString(textToMeasure, endIndex);
      }
    }

    return (x: offsetX, y: offsetY);
  }

  /// Gets the number of lines in the text.
  int numLines() {
    return _numLinesInRange(0, _text.length - 1);
  }

  int _numLinesInRange(int startIndex, int endIndex) {
    var numLines = 1;

    startIndex = startIndex.clamp(0, _text.length - 1);
    endIndex = endIndex.clamp(-1, _text.length - 1);

    for (var i = startIndex; i <= endIndex; i++) {
      if (_text[i] == '\n') {
        numLines++;
      }
    }

    return numLines;
  }

  /// Gets the offset position at a character index range.
  ({double x, double y}) getOffset(int startIndex, int endIndex) {
    endIndex = endIndex.clamp(0, _text.length - 1);

    var offsetX = 0.0;
    var offsetY = 0.0;

    // Find the first '\n' before the characterIndex
    for (var i = startIndex; i <= endIndex; i++) {
      if (_text[i] == '\n') {
        startIndex = i + 1;
        offsetY -= typeFaceStyle.emSizeInPixels;
      }
    }

    for (var index = startIndex; index <= endIndex; index++) {
      if (_text[index] == '\n') {
        offsetX = 0;
        offsetY -= typeFaceStyle.emSizeInPixels;
      } else {
        final codePoint = _text.codeUnitAt(index);
        if (!_fastAdvance.containsKey(codePoint)) {
          _fastAdvance[codePoint] =
              typeFaceStyle.getAdvanceForCharacterInString(_text, index);
        }
        offsetX += _fastAdvance[codePoint]!;
      }
    }

    return (x: offsetX, y: offsetY);
  }

  /// Gets the position to the left of a character index.
  ({double x, double y}) getOffsetLeftOfCharacterIndex(int characterIndex) {
    return getOffset(0, characterIndex - 1);
  }

  /// Gets the character index closest to a position.
  /// Returns the index where text would be inserted at that position.
  int getCharacterIndexToStartBefore(({double x, double y}) position) {
    var closestIndex = -1;
    var closestXDistSquared = double.maxFinite;
    var closestYDistSquared = double.maxFinite;

    var offset = (
      x: 0.0,
      y: typeFaceStyle.emSizeInPixels * numLines() - typeFaceStyle.emSizeInPixels * 0.5,
    );

    if (_text.isEmpty) return closestIndex;

    for (var i = 0; i < _text.length; i++) {
      final delta = (x: position.x - offset.x, y: position.y - offset.y);
      final deltaYLengthSquared = delta.y * delta.y;

      if (deltaYLengthSquared < closestYDistSquared) {
        closestYDistSquared = deltaYLengthSquared;
        closestXDistSquared = delta.x * delta.x;
        closestIndex = i;
      } else if (deltaYLengthSquared == closestYDistSquared) {
        final deltaXLengthSquared = delta.x * delta.x;
        if (deltaXLengthSquared < closestXDistSquared) {
          closestXDistSquared = deltaXLengthSquared;
          closestIndex = i;
        }
      }

      if (_text[i] == '\r') {
        throw Exception("All \\r's should have been converted to \\n's.");
      }

      if (_text[i] == '\n') {
        offset = (x: 0.0, y: offset.y - typeFaceStyle.emSizeInPixels);
      } else {
        final charOffset = getOffset(i, i);
        offset = (x: offset.x + charOffset.x, y: offset.y);
      }
    }

    // Check position after last character
    final delta = (x: position.x - offset.x, y: position.y - offset.y);
    final deltaYLengthSquared = delta.y * delta.y;
    if (deltaYLengthSquared < closestYDistSquared) {
      closestIndex = _text.length;
    } else if (deltaYLengthSquared == closestYDistSquared) {
      final deltaXLengthSquared = delta.x * delta.x;
      if (deltaXLengthSquared < closestXDistSquared) {
        closestIndex = _text.length;
      }
    }

    return closestIndex;
  }
}

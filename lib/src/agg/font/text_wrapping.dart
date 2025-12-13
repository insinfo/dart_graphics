
//
// Text wrapping utilities for breaking text into lines based on pixel width.

import 'dart:math' as math;
import 'styled_type_face.dart';
import 'type_face_printer.dart';

/// Abstract base class for text wrapping algorithms.
/// 
/// Provides methods to wrap text based on a maximum pixel width,
/// inserting line breaks as needed.
abstract class TextWrapping {
  /// The styled typeface used to measure text.
  final StyledTypeFace styledTypeFace;

  /// Creates a TextWrapping instance with the specified typeface.
  TextWrapping(this.styledTypeFace);

  /// Wraps text and inserts carriage returns (newlines) at wrap points.
  /// 
  /// [textToWrap] - The text to wrap
  /// [maxPixelWidth] - Maximum width in pixels for each line
  /// [wrappingIndentSpaces] - Number of spaces to indent wrapped lines
  /// 
  /// Returns a single string with newlines inserted at wrap points.
  String insertCRs(String textToWrap, double maxPixelWidth, [int wrappingIndentSpaces = 0]) {
    final buffer = StringBuffer();
    final lines = wrapText(textToWrap, maxPixelWidth, wrappingIndentSpaces);
    
    for (var i = 0; i < lines.length; i++) {
      if (i > 0) {
        buffer.write('\n');
      }
      buffer.write(lines[i]);
    }
    
    return buffer.toString();
  }

  /// Wraps text into a list of lines based on maximum pixel width.
  /// 
  /// [textToWrap] - The text to wrap
  /// [maxPixelWidth] - Maximum width in pixels for each line
  /// [wrappingIndentSpaces] - Number of spaces to indent wrapped lines (after first)
  /// 
  /// Returns a list of lines, each fitting within the specified width.
  List<String> wrapText(String textToWrap, double maxPixelWidth, [int wrappingIndentSpaces = 0]) {
    final finalLines = <String>[];
    final splitOnNL = textToWrap.split('\n');
    
    for (final line in splitOnNL) {
      final linesFromWidth = wrapSingleLineOnWidth(line, maxPixelWidth);
      var first = true;
      
      for (final lineFromWidth in linesFromWidth) {
        if (first) {
          first = false;
          finalLines.add(lineFromWidth);
        } else {
          finalLines.add(' ' * wrappingIndentSpaces + lineFromWidth);
        }
      }
    }
    
    return finalLines;
  }

  /// Wraps a single line (no embedded newlines) based on pixel width.
  /// 
  /// This is the main wrapping algorithm that subclasses must implement.
  /// 
  /// [originalTextToWrap] - A single line of text to wrap
  /// [maxPixelWidth] - Maximum width in pixels
  /// 
  /// Returns a list of lines resulting from wrapping.
  List<String> wrapSingleLineOnWidth(String originalTextToWrap, double maxPixelWidth);
}

/// English text wrapping implementation.
/// 
/// Wraps text at word boundaries (spaces) for English and other
/// space-separated languages.
class EnglishTextWrapping extends TextWrapping {
  /// Creates an EnglishTextWrapping instance with the specified typeface.
  EnglishTextWrapping(super.styledTypeFace);

  /// Creates an EnglishTextWrapping instance with a default font at the given point size.
  /// 
  /// Note: This requires AggContext.defaultFont to be set.
  factory EnglishTextWrapping.withPointSize(double pointSize, StyledTypeFace Function(double) createTypeFace) {
    return EnglishTextWrapping(createTypeFace(pointSize));
  }

  /// Checks if there is a space character before the given index.
  bool _hasSpaceBeforeIndex(String stringToCheck, int endOfChecking) {
    for (var i = math.min(endOfChecking, stringToCheck.length - 1); i >= 0; i--) {
      if (stringToCheck[i] == ' ') {
        return true;
      }
    }
    return false;
  }

  @override
  List<String> wrapSingleLineOnWidth(String originalTextToWrap, double maxPixelWidth) {
    final lines = <String>[];

    if (maxPixelWidth > 0 && originalTextToWrap.isNotEmpty) {
      var textToWrap = originalTextToWrap;
      final printer = TypeFacePrinter(
        text: textToWrap,
        typeFaceStyle: styledTypeFace,
      );

      while (textToWrap.isNotEmpty) {
        printer.text = textToWrap;
        int countBeforeWrap;

        // Find approximate character count that fits in width
        double currentLength = 0;
        for (countBeforeWrap = 0; countBeforeWrap < printer.text.length; countBeforeWrap++) {
          if (currentLength > maxPixelWidth) {
            break;
          }
          currentLength += styledTypeFace.getAdvanceForCharacterInString(textToWrap, countBeforeWrap);
        }

        // Trim back to fit within width
        while (_getOffsetLeftOfCharacterIndex(printer, countBeforeWrap) > maxPixelWidth && countBeforeWrap > 1) {
          countBeforeWrap--;
          // Trim back to the last space (word boundary)
          while (countBeforeWrap > 1 &&
                 _hasSpaceBeforeIndex(textToWrap, countBeforeWrap) &&
                 textToWrap[countBeforeWrap] != ' ') {
            countBeforeWrap--;
          }
        }

        if (countBeforeWrap >= 0) {
          lines.add(textToWrap.substring(0, countBeforeWrap));
        }

        // Check if we wrapped because of width or a newline
        if (countBeforeWrap > 1 &&
            textToWrap.length > countBeforeWrap &&
            textToWrap[countBeforeWrap] == ' ' &&
            (countBeforeWrap == 0 || textToWrap[countBeforeWrap - 1] != '\n')) {
          // Skip the leading space on the next line
          textToWrap = textToWrap.substring(countBeforeWrap + 1);
        } else {
          textToWrap = textToWrap.substring(countBeforeWrap);
        }
      }
    } else {
      lines.add(originalTextToWrap);
    }

    return lines;
  }

  /// Gets the X offset to the left of a character index.
  double _getOffsetLeftOfCharacterIndex(TypeFacePrinter printer, int characterIndex) {
    if (characterIndex <= 0) return 0;
    final offset = printer.getOffset(0, characterIndex - 1);
    return offset.x;
  }
}

/// Word-break text wrapping that breaks at any character if necessary.
/// 
/// Similar to EnglishTextWrapping but will break mid-word if a single
/// word is too long to fit on a line.
class BreakAnywhereTextWrapping extends TextWrapping {
  /// Creates a BreakAnywhereTextWrapping instance with the specified typeface.
  BreakAnywhereTextWrapping(super.styledTypeFace);

  @override
  List<String> wrapSingleLineOnWidth(String originalTextToWrap, double maxPixelWidth) {
    final lines = <String>[];

    if (maxPixelWidth > 0 && originalTextToWrap.isNotEmpty) {
      var textToWrap = originalTextToWrap;

      while (textToWrap.isNotEmpty) {
        int countBeforeWrap;
        double currentLength = 0;

        // Find character count that fits in width
        for (countBeforeWrap = 0; countBeforeWrap < textToWrap.length; countBeforeWrap++) {
          final charWidth = styledTypeFace.getAdvanceForCharacterInString(textToWrap, countBeforeWrap);
          if (currentLength + charWidth > maxPixelWidth && countBeforeWrap > 0) {
            break;
          }
          currentLength += charWidth;
        }

        // Ensure we make progress
        if (countBeforeWrap == 0 && textToWrap.isNotEmpty) {
          countBeforeWrap = 1;
        }

        lines.add(textToWrap.substring(0, countBeforeWrap));
        textToWrap = textToWrap.substring(countBeforeWrap);
      }
    } else {
      lines.add(originalTextToWrap);
    }

    return lines;
  }
}

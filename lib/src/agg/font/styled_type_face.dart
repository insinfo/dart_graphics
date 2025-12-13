//
// StyledTypeFace wraps a TypeFace with sizing, scaling, and underline support.
// Provides convenience methods for rendering text at specific sizes.

import '../primitives/rectangle_double.dart';
import '../transform/affine.dart';
import '../vertex_source/ivertex_source.dart';
import '../vertex_source/apply_transform.dart';
import '../vertex_source/flatten_curve.dart';
import '../../typography/openfont/typeface.dart';

/// A styled typeface with a specific size and optional styling.
/// Wraps a Typeface and provides scaling and metrics for a target font size.
class StyledTypeFace {
  /// Points per inch - standard typographic convention
  static const int pointsPerInch = 72;

  /// Pixels per inch - standard screen resolution
  static const int pixelsPerInch = 96;

  /// The underlying typeface
  final Typeface typeFace;

  /// Whether to add underline to glyphs
  bool doUnderline;

  /// Whether to flatten curves to the current point size when retrieved.
  /// Set to false to flatten curves after other transforms are applied.
  bool flattenCurves;

  /// The em size in pixels
  final double _emSizeInPixels;

  /// Current scaling factor from font units to pixels
  final double _currentEmScaling;

  /// Creates a styled typeface at the specified point size.
  ///
  /// [typeFace] - The underlying typeface to style
  /// [emSizeInPoints] - The desired em size in points
  /// [underline] - Whether to add underline decoration
  /// [flattenCurves] - Whether to flatten curves to the current point size
  StyledTypeFace(
    this.typeFace,
    double emSizeInPoints, {
    this.doUnderline = false,
    this.flattenCurves = true,
  })  : _emSizeInPixels = emSizeInPoints / pointsPerInch * pixelsPerInch,
        _currentEmScaling =
            (emSizeInPoints / pointsPerInch * pixelsPerInch) / typeFace.unitsPerEm;

  /// Gets the em size in pixels.
  double get emSizeInPixels => _emSizeInPixels;

  /// Gets the em size in points.
  double get emSizeInPoints => _emSizeInPixels / pixelsPerInch * pointsPerInch;

  /// Gets the ascent in pixels.
  double get ascentInPixels => typeFace.ascender * _currentEmScaling;

  /// Gets the descent in pixels (typically negative).
  double get descentInPixels => typeFace.descender * _currentEmScaling;

  /// Gets the x-height in pixels (height of lowercase 'x').
  /// Falls back to a reasonable approximation if not available.
  double get xHeightInPixels {
    // OS/2 table sxHeight field, if available
    // For now, approximate as 50% of ascender
    return ascentInPixels * 0.5;
  }

  /// Gets the cap height in pixels (height of capital letters).
  /// Falls back to ascent if not available.
  double get capHeightInPixels {
    // OS/2 table sCapHeight field, if available
    // For now, use ascender
    return ascentInPixels;
  }

  /// Gets the bounding box of the font in pixels.
  RectangleDouble get boundingBoxInPixels {
    final bounds = typeFace.bounds;
    return RectangleDouble(
      bounds.xMin * _currentEmScaling,
      bounds.yMin * _currentEmScaling,
      bounds.xMax * _currentEmScaling,
      bounds.yMax * _currentEmScaling,
    );
  }

  /// Gets the underline thickness in pixels.
  double get underlineThicknessInPixels {
    // From post table underlineThickness
    // Default to 1/20 of em if not available
    return _emSizeInPixels / 20;
  }

  /// Gets the underline position in pixels (offset from baseline).
  double get underlinePositionInPixels {
    // From post table underlinePosition
    // Default to -1/10 of em if not available
    return -_emSizeInPixels / 10;
  }

  /// Gets the glyph vertex source for a character, scaled to the current size.
  ///
  /// [character] - The Unicode code point to get
  /// [resolutionScale] - Scale factor for curve flattening resolution
  IVertexSource? getGlyphForCharacter(int codePoint, [double resolutionScale = 1]) {
    final glyphIndex = typeFace.getGlyphIndex(codePoint);
    final glyph = typeFace.getGlyph(glyphIndex);

    if (glyph.glyphPoints == null && glyph.glyphInstructions == null) {
      return null;
    }

    // Get the glyph as a vertex source
    IVertexSource? sourceGlyph = _getGlyphVertexSource(glyph);
    if (sourceGlyph == null) {
      return null;
    }

    // Scale to the correct size
    final glyphTransform = Affine.scaling(_currentEmScaling, _currentEmScaling);
    IVertexSource characterGlyph =
        ApplyTransform(sourceGlyph, glyphTransform);

    if (flattenCurves) {
      final flattener = FlattenCurve(characterGlyph);
      flattener.setApproximationScale(resolutionScale);
      characterGlyph = flattener;
    }

    return characterGlyph;
  }

  /// Gets the advance width for a character in pixels.
  double getAdvanceForCharacter(int codePoint) {
    return typeFace.getAdvanceWidth(codePoint) * _currentEmScaling;
  }

  /// Gets the advance width for a character with kerning in pixels.
  double getAdvanceForCharacterWithKerning(int codePoint, int nextCodePoint) {
    // Basic advance without kerning for now
    // TODO: Add kerning support from KERN/GPOS tables
    return getAdvanceForCharacter(codePoint);
  }

  /// Gets the advance for a character in a string context.
  double getAdvanceForCharacterInString(String text, int characterIndex) {
    if (characterIndex < text.length - 1) {
      return getAdvanceForCharacterWithKerning(
        text.codeUnitAt(characterIndex),
        text.codeUnitAt(characterIndex + 1),
      );
    } else {
      return getAdvanceForCharacter(text.codeUnitAt(characterIndex));
    }
  }

  /// Internal helper to convert a Glyph to IVertexSource
  IVertexSource? _getGlyphVertexSource(glyph) {
    // This would need to use VertexSourceGlyphTranslator or similar
    // to convert glyph outlines to vertex source
    // For now, return null - this should be implemented with proper glyph translation
    return null;
  }
}

/// Cache for rendered glyph images at specific sizes and colors.
/// Singleton pattern for efficient memory usage.
class StyledTypeFaceImageCache {
  static StyledTypeFaceImageCache? _instance;

  // Cache structure: TypeFace -> Color -> FontSize -> Character -> ImageBuffer
  // Using Maps for the cache structure
  final Map<Typeface, Map<int, Map<double, Map<int, Object>>>> _typeFaceImageCache = {};

  StyledTypeFaceImageCache._();

  static StyledTypeFaceImageCache get instance {
    _instance ??= StyledTypeFaceImageCache._();
    return _instance!;
  }

  /// Gets or creates the character cache for a specific typeface, color, and size.
  Map<int, Object> getCache(Typeface typeFace, int colorValue, double emSizeInPixels) {
    _typeFaceImageCache[typeFace] ??= {};
    _typeFaceImageCache[typeFace]![colorValue] ??= {};
    _typeFaceImageCache[typeFace]![colorValue]![emSizeInPixels] ??= {};
    return _typeFaceImageCache[typeFace]![colorValue]![emSizeInPixels]!;
  }

  /// Clears all cached images.
  void clear() {
    _typeFaceImageCache.clear();
  }

  /// Clears cache for a specific typeface.
  void clearForTypeFace(Typeface typeFace) {
    _typeFaceImageCache.remove(typeFace);
  }
}

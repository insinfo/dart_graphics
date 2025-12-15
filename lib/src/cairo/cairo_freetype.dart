/// Cairo + FreeType integration
///
/// This library provides the bridge between FreeType fonts and Cairo rendering.
/// It depends on both the pure FreeType library and Cairo bindings.


import 'dart:ffi' as ffi;
import 'package:agg/cairo.dart';

import '../freetype/freetype.dart';
import 'generated/ffi.dart' as cairo_ffi;

/// A Cairo font face created from a FreeType face
class CairoFreeTypeFace {
  final FreeTypeFace _ftFace;
  final Cairo _cairo;
  ffi.Pointer<cairo_ffi.cairo_font_face_t> _cairoFontFace = ffi.nullptr;
  bool _disposed = false;

  CairoFreeTypeFace._(this._ftFace, this._cairo);

  /// Create a Cairo font face from a FreeType face
  ///
  /// [cairoBindings] - Cairo bindings to use. If not provided, will load from default path.
  static CairoFreeTypeFace? fromFreeTypeFace(
    FreeTypeFace ftFace,
    Cairo cairo, {
    int loadFlags = 0,
  }) {
    if (ftFace.isDisposed) {
      throw ArgumentError('FreeType face has been disposed');
    }

    final cairoFace = CairoFreeTypeFace._(ftFace, cairo);

    // Cast to Cairo's FT_Face type (both are Pointer<FT_FaceRec_>)
    final cairoFtFace = ftFace.ftFace.cast<cairo_ffi.FT_FaceRec_>();
    cairoFace._cairoFontFace =
        cairo.bindings.cairo_ft_font_face_create_for_ft_face(
      cairoFtFace,
      loadFlags,
    );

    if (cairoFace._cairoFontFace == ffi.nullptr) {
      return null;
    }

    return cairoFace;
  }

  /// Load a font from file and create a Cairo font face
  ///
  /// [cairoBindings] - Cairo bindings to use. If not provided, will load from default path.
  static CairoFreeTypeFace? fromFile(
    String filePath,
    Cairo cairo, {
    int faceIndex = 0,
    int loadFlags = 0,
  }) {
    final ftFace = FreeTypeFace.fromFile(filePath, faceIndex: faceIndex);
    if (ftFace == null) return null;

    final cairoFace = fromFreeTypeFace(
      ftFace,
      cairo,
      loadFlags: loadFlags,
    );
    if (cairoFace == null) {
      ftFace.dispose();
      return null;
    }

    return cairoFace;
  }

  /// Get the underlying FreeType face
  FreeTypeFace get ftFace => _ftFace;

  /// Get the Cairo font face pointer
  ffi.Pointer<cairo_ffi.cairo_font_face_t> get cairoFontFace {
    if (_disposed) throw StateError('Cairo font face has been disposed');
    return _cairoFontFace;
  }

  /// Get font family name
  String? get familyName => _ftFace.familyName;

  /// Get font style name
  String? get styleName => _ftFace.styleName;

  /// Get number of glyphs
  int get numGlyphs => _ftFace.numGlyphs;

  /// Check if this is a scalable font
  bool get isScalable => _ftFace.isScalable;

  /// Dispose of the Cairo font face (does NOT dispose the underlying FreeType face)
  void disposeCairoFace() {
    if (_disposed) return;
    _disposed = true;

    if (_cairoFontFace != ffi.nullptr) {
      _cairo.bindings.cairo_font_face_destroy(_cairoFontFace);
      _cairoFontFace = ffi.nullptr;
    }
  }

  /// Dispose of both Cairo and FreeType resources
  void dispose() {
    disposeCairoFace();
    _ftFace.dispose();
  }

  /// Check if disposed
  bool get isDisposed => _disposed;
}

/// Cache for Cairo+FreeType font faces
class CairoFontCache {
  final Map<String, CairoFreeTypeFace> _cache = {};
  final Cairo _cairo;

  /// Create a font cache
  ///
  /// [cairoBindings] - Cairo bindings to use. If not provided, will load from default path.
  CairoFontCache(this._cairo);

  /// Get or load a Cairo font face from file
  CairoFreeTypeFace? getOrLoad(String filePath,
      {int faceIndex = 0, int loadFlags = 0}) {
    final key = '$filePath:$faceIndex:$loadFlags';
    if (_cache.containsKey(key)) {
      final face = _cache[key]!;
      if (!face.isDisposed) return face;
      _cache.remove(key);
    }

    final face = CairoFreeTypeFace.fromFile(
      filePath,
      _cairo,
      faceIndex: faceIndex,
      loadFlags: loadFlags,
    );
    if (face != null) {
      _cache[key] = face;
    }
    return face;
  }

  /// Clear the cache and dispose all faces
  void clear() {
    for (final face in _cache.values) {
      face.dispose();
    }
    _cache.clear();
  }

  /// Dispose a specific face
  void remove(String filePath, {int faceIndex = 0, int loadFlags = 0}) {
    final key = '$filePath:$faceIndex:$loadFlags';
    final face = _cache.remove(key);
    face?.dispose();
  }
}

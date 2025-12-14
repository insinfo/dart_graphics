/// Pure FreeType bindings for Dart
///
/// This library provides FreeType font loading without any Cairo dependency.
/// For Cairo integration, see `package:agg/src/cairo/cairo_freetype.dart`.
library freetype;

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'generated/freetype_ffi.dart';
import 'freetype_load.dart';

// Re-export types that users might need
export 'generated/freetype_ffi.dart' show FT_Face, FT_FaceRec_;

/// Global FreeType library instance
late final FreeTypeBindings ftBindings = loadFreeType();

/// FreeType library handle
class FreeTypeLibrary {
  ffi.Pointer<FT_Library> _library = ffi.nullptr;
  bool _initialized = false;

  /// Initialize the FreeType library
  bool init() {
    if (_initialized) return true;

    _library = calloc<FT_Library>();
    final error = ftBindings.FT_Init_FreeType(_library);
    if (error != 0) {
      calloc.free(_library);
      _library = ffi.nullptr;
      return false;
    }
    _initialized = true;
    return true;
  }

  /// Get the library pointer
  FT_Library get library {
    if (!_initialized) {
      throw StateError('FreeType library not initialized. Call init() first.');
    }
    return _library.value;
  }

  /// Check if initialized
  bool get isInitialized => _initialized;

  /// Dispose of the library
  void dispose() {
    if (_initialized && _library != ffi.nullptr) {
      ftBindings.FT_Done_FreeType(_library.value);
      calloc.free(_library);
      _library = ffi.nullptr;
      _initialized = false;
    }
  }
}

/// Global FreeType library (singleton)
final FreeTypeLibrary ftLibrary = FreeTypeLibrary();

/// A FreeType font face loaded from a file (pure FreeType, no Cairo dependency)
class FreeTypeFace {
  ffi.Pointer<FT_Face> _facePtr = ffi.nullptr;
  final String path;
  bool _disposed = false;

  FreeTypeFace._(this.path);

  /// Load a font face from a file path
  static FreeTypeFace? fromFile(String filePath, {int faceIndex = 0}) {
    if (!ftLibrary.isInitialized) {
      if (!ftLibrary.init()) {
        throw StateError('Failed to initialize FreeType library');
      }
    }

    final face = FreeTypeFace._(filePath);
    face._facePtr = calloc<FT_Face>();

    final pathPtr = filePath.toNativeUtf8().cast<ffi.Char>();
    try {
      final error = ftBindings.FT_New_Face(
        ftLibrary.library,
        pathPtr,
        faceIndex,
        face._facePtr,
      );

      if (error != 0) {
        calloc.free(face._facePtr);
        face._facePtr = ffi.nullptr;
        return null;
      }

      return face;
    } finally {
      calloc.free(pathPtr);
    }
  }

  /// Get the FreeType face pointer
  FT_Face get ftFace {
    if (_disposed) throw StateError('Face has been disposed');
    return _facePtr.value;
  }

  /// Get the raw pointer to the face (for FFI interop)
  ffi.Pointer<FT_Face> get facePtr {
    if (_disposed) throw StateError('Face has been disposed');
    return _facePtr;
  }

  /// Get font family name
  String? get familyName {
    if (_disposed) return null;
    final faceRec = _facePtr.value.ref;
    if (faceRec.family_name == ffi.nullptr) return null;
    return faceRec.family_name.cast<Utf8>().toDartString();
  }

  /// Get font style name
  String? get styleName {
    if (_disposed) return null;
    final faceRec = _facePtr.value.ref;
    if (faceRec.style_name == ffi.nullptr) return null;
    return faceRec.style_name.cast<Utf8>().toDartString();
  }

  /// Get number of glyphs
  int get numGlyphs {
    if (_disposed) return 0;
    return _facePtr.value.ref.num_glyphs;
  }

  /// Get number of faces in the font file
  int get numFaces {
    if (_disposed) return 0;
    return _facePtr.value.ref.num_faces;
  }

  /// Check if this is a scalable font
  bool get isScalable {
    if (_disposed) return false;
    // FT_FACE_FLAG_SCALABLE = 1
    return (_facePtr.value.ref.face_flags & 1) != 0;
  }

  /// Set character size in points
  /// [width] and [height] are in 1/64th of points (26.6 fixed-point)
  /// [horzResolution] and [vertResolution] are in DPI
  bool setCharSize(
    int width,
    int height, {
    int horzResolution = 72,
    int vertResolution = 72,
  }) {
    if (_disposed) return false;
    final error = ftBindings.FT_Set_Char_Size(
      _facePtr.value,
      width,
      height,
      horzResolution,
      vertResolution,
    );
    return error == 0;
  }

  /// Set pixel sizes
  bool setPixelSizes(int width, int height) {
    if (_disposed) return false;
    final error = ftBindings.FT_Set_Pixel_Sizes(_facePtr.value, width, height);
    return error == 0;
  }

  /// Dispose of the font face
  void dispose() {
    if (_disposed) return;
    _disposed = true;

    if (_facePtr != ffi.nullptr) {
      ftBindings.FT_Done_Face(_facePtr.value);
      calloc.free(_facePtr);
      _facePtr = ffi.nullptr;
    }
  }

  /// Check if disposed
  bool get isDisposed => _disposed;
}

/// Cache for loaded font faces
class FontCache {
  final Map<String, FreeTypeFace> _cache = {};

  /// Get or load a font face from file
  FreeTypeFace? getOrLoad(String filePath, {int faceIndex = 0}) {
    final key = '$filePath:$faceIndex';
    if (_cache.containsKey(key)) {
      final face = _cache[key]!;
      if (!face.isDisposed) return face;
      _cache.remove(key);
    }

    final face = FreeTypeFace.fromFile(filePath, faceIndex: faceIndex);
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
  void remove(String filePath, {int faceIndex = 0}) {
    final key = '$filePath:$faceIndex';
    final face = _cache.remove(key);
    face?.dispose();
  }
}

/// Global font cache (singleton)
final FontCache fontCache = FontCache();

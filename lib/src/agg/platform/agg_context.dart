//
// AggContext provides global configuration and default settings
// for the AGG rendering library.

import 'dart:io' show Platform;
import '../../typography/openfont/typeface.dart';

/// Operating system types
enum OSType {
  unknown,
  windows,
  mac,
  linux,
  android,
  ios,
  fuchsia,
  other,
}

/// Graphics mode configuration for AGG rendering
class AggGraphicsMode {
  /// Color buffer bits per pixel (default 32 for RGBA)
  int color;

  /// Depth buffer bits (default 24)
  int depth;

  /// Stencil buffer bits (default 0)
  int stencil;

  /// FSAA samples per pixel (default 8)
  int fsaaSamples;

  AggGraphicsMode({
    this.color = 32,
    this.depth = 24,
    this.stencil = 0,
    this.fsaaSamples = 8,
  });
}

/// Platform-specific configuration settings
class PlatformConfig {
  /// Graphics mode settings
  AggGraphicsMode graphicsMode;

  PlatformConfig({
    AggGraphicsMode? graphicsMode,
  }) : graphicsMode = graphicsMode ?? AggGraphicsMode();
}

/// Desktop size as a point (width, height)
class Point2D {
  final int x;
  final int y;

  const Point2D(this.x, this.y);

  @override
  String toString() => 'Point2D($x, $y)';
}

/// Global context for AGG rendering configuration.
/// Provides default fonts, platform detection, and configuration settings.
class AggContext {
  static PlatformConfig _config = PlatformConfig();

  // Default fonts - these should be set by the application
  static Typeface? _defaultFont;
  static Typeface? _defaultFontBold;
  static Typeface? _defaultFontItalic;
  static Typeface? _defaultFontBoldItalic;

  /// Gets the platform configuration
  static PlatformConfig get config => _config;

  /// Sets the platform configuration
  static set config(PlatformConfig value) => _config = value;

  /// Gets the current operating system type
  static OSType get operatingSystem {
    if (Platform.isWindows) return OSType.windows;
    if (Platform.isMacOS) return OSType.mac;
    if (Platform.isLinux) return OSType.linux;
    if (Platform.isAndroid) return OSType.android;
    if (Platform.isIOS) return OSType.ios;
    if (Platform.isFuchsia) return OSType.fuchsia;
    return OSType.unknown;
  }

  /// Gets the default font for regular text
  static Typeface? get defaultFont => _defaultFont;

  /// Sets the default font for regular text
  static set defaultFont(Typeface? value) => _defaultFont = value;

  /// Gets the default bold font
  static Typeface? get defaultFontBold => _defaultFontBold;

  /// Sets the default bold font
  static set defaultFontBold(Typeface? value) => _defaultFontBold = value;

  /// Gets the default italic font
  static Typeface? get defaultFontItalic => _defaultFontItalic;

  /// Sets the default italic font
  static set defaultFontItalic(Typeface? value) => _defaultFontItalic = value;

  /// Gets the default bold italic font
  static Typeface? get defaultFontBoldItalic => _defaultFontBoldItalic;

  /// Sets the default bold italic font
  static set defaultFontBoldItalic(Typeface? value) =>
      _defaultFontBoldItalic = value;

  /// Gets the graphics mode configuration
  static AggGraphicsMode get graphicsMode => _config.graphicsMode;

  /// Resets all configuration to defaults
  static void reset() {
    _config = PlatformConfig();
    _defaultFont = null;
    _defaultFontBold = null;
    _defaultFontItalic = null;
    _defaultFontBoldItalic = null;
  }

  /// Initializes AggContext with the specified fonts.
  ///
  /// [defaultFont] - The default regular font
  /// [defaultFontBold] - The default bold font (optional, defaults to regular)
  /// [defaultFontItalic] - The default italic font (optional, defaults to regular)
  /// [defaultFontBoldItalic] - The default bold italic font (optional, defaults to bold or regular)
  static void initialize({
    required Typeface defaultFont,
    Typeface? defaultFontBold,
    Typeface? defaultFontItalic,
    Typeface? defaultFontBoldItalic,
  }) {
    _defaultFont = defaultFont;
    _defaultFontBold = defaultFontBold ?? defaultFont;
    _defaultFontItalic = defaultFontItalic ?? defaultFont;
    _defaultFontBoldItalic = defaultFontBoldItalic ?? _defaultFontBold ?? defaultFont;
  }
}

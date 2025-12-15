// GENERATED CODE - DO NOT MODIFY BY HAND
// Source: SkiaSharp SkiaApi.generated.cs
// Generated: 2025-12-14T21:17:41.291227

// ignore_for_file: camel_case_types, non_constant_identifier_names
// ignore_for_file: constant_identifier_names

// ============================================================
// Enums
// ============================================================

/// GRBackendNative
abstract class GRBackendNative {
  static const int OPENGL_GR_BACKEND = 0;
  static const int OpenGL = 0;
  static const int VULKAN_GR_BACKEND = 1;
  static const int Vulkan = 1;
  static const int METAL_GR_BACKEND = 2;
  static const int Metal = 2;
  static const int DIRECT3D_GR_BACKEND = 3;
  static const int Direct3D = 3;
  static const int UNSUPPORTED_GR_BACKEND = 5;
  static const int Unsupported = 5;
}

/// GRSurfaceOrigin
abstract class GRSurfaceOrigin {
  static const int TOP_LEFT_GR_SURFACE_ORIGIN = 0;
  static const int TopLeft = 0;
  static const int BOTTOM_LEFT_GR_SURFACE_ORIGIN = 1;
  static const int BottomLeft = 1;
}

/// SKAlphaType
abstract class SKAlphaType {
  static const int UNKNOWN_SK_ALPHATYPE = 0;
  static const int Unknown = 0;
  static const int OPAQUE_SK_ALPHATYPE = 1;
  static const int Opaque = 1;
  static const int PREMUL_SK_ALPHATYPE = 2;
  static const int Premul = 2;
  static const int UNPREMUL_SK_ALPHATYPE = 3;
  static const int Unpremul = 3;
}

/// SKBitmapAllocFlags
abstract class SKBitmapAllocFlags {
  static const int NONE_SK_BITMAP_ALLOC_FLAGS = 0;
  static const int None = 0;
  static const int ZERO_PIXELS_SK_BITMAP_ALLOC_FLAGS = 1;
  static const int ZeroPixels = 1;
}

/// SKBlendMode
abstract class SKBlendMode {
  static const int CLEAR_SK_BLENDMODE = 0;
  static const int Clear = 0;
  static const int SRC_SK_BLENDMODE = 1;
  static const int Src = 1;
  static const int DST_SK_BLENDMODE = 2;
  static const int Dst = 2;
  static const int SRCOVER_SK_BLENDMODE = 3;
  static const int SrcOver = 3;
  static const int DSTOVER_SK_BLENDMODE = 4;
  static const int DstOver = 4;
  static const int SRCIN_SK_BLENDMODE = 5;
  static const int SrcIn = 5;
  static const int DSTIN_SK_BLENDMODE = 6;
  static const int DstIn = 6;
  static const int SRCOUT_SK_BLENDMODE = 7;
  static const int SrcOut = 7;
  static const int DSTOUT_SK_BLENDMODE = 8;
  static const int DstOut = 8;
  static const int SRCATOP_SK_BLENDMODE = 9;
  static const int SrcATop = 9;
  static const int DSTATOP_SK_BLENDMODE = 10;
  static const int DstATop = 10;
  static const int XOR_SK_BLENDMODE = 11;
  static const int Xor = 11;
  static const int PLUS_SK_BLENDMODE = 12;
  static const int Plus = 12;
  static const int MODULATE_SK_BLENDMODE = 13;
  static const int Modulate = 13;
  static const int SCREEN_SK_BLENDMODE = 14;
  static const int Screen = 14;
  static const int OVERLAY_SK_BLENDMODE = 15;
  static const int Overlay = 15;
  static const int DARKEN_SK_BLENDMODE = 16;
  static const int Darken = 16;
  static const int LIGHTEN_SK_BLENDMODE = 17;
  static const int Lighten = 17;
  static const int COLORDODGE_SK_BLENDMODE = 18;
  static const int ColorDodge = 18;
  static const int COLORBURN_SK_BLENDMODE = 19;
  static const int ColorBurn = 19;
  static const int HARDLIGHT_SK_BLENDMODE = 20;
  static const int HardLight = 20;
  static const int SOFTLIGHT_SK_BLENDMODE = 21;
  static const int SoftLight = 21;
  static const int DIFFERENCE_SK_BLENDMODE = 22;
  static const int Difference = 22;
  static const int EXCLUSION_SK_BLENDMODE = 23;
  static const int Exclusion = 23;
  static const int MULTIPLY_SK_BLENDMODE = 24;
  static const int Multiply = 24;
  static const int HUE_SK_BLENDMODE = 25;
  static const int Hue = 25;
  static const int SATURATION_SK_BLENDMODE = 26;
  static const int Saturation = 26;
  static const int COLOR_SK_BLENDMODE = 27;
  static const int Color = 27;
  static const int LUMINOSITY_SK_BLENDMODE = 28;
  static const int Luminosity = 28;
}

/// SKBlurStyle
abstract class SKBlurStyle {
  static const int NORMAL_SK_BLUR_STYLE = 0;
  static const int Normal = 0;
  static const int SOLID_SK_BLUR_STYLE = 1;
  static const int Solid = 1;
  static const int OUTER_SK_BLUR_STYLE = 2;
  static const int Outer = 2;
  static const int INNER_SK_BLUR_STYLE = 3;
  static const int Inner = 3;
}

/// SKCanvasSaveLayerRecFlags
abstract class SKCanvasSaveLayerRecFlags {
  static const int NONE_SK_CANVAS_SAVELAYERREC_FLAGS = 0;
  static const int None = 0;
  static const int PRESERVE_LCD_TEXT_SK_CANVAS_SAVELAYERREC_FLAGS = 1;
  static const int PreserveLcdText = 2;
  static const int INITIALIZE_WITH_PREVIOUS_SK_CANVAS_SAVELAYERREC_FLAGS = 1;
  static const int InitializeWithPrevious = 4;
  static const int F16_COLOR_TYPE_SK_CANVAS_SAVELAYERREC_FLAGS = 1;
  static const int F16ColorType = 16;
}

/// SKClipOperation
abstract class SKClipOperation {
  static const int DIFFERENCE_SK_CLIPOP = 0;
  static const int Difference = 0;
  static const int INTERSECT_SK_CLIPOP = 1;
  static const int Intersect = 1;
}

/// SKCodecResult
abstract class SKCodecResult {
  static const int SUCCESS_SK_CODEC_RESULT = 0;
  static const int Success = 0;
  static const int INCOMPLETE_INPUT_SK_CODEC_RESULT = 1;
  static const int IncompleteInput = 1;
  static const int ERROR_IN_INPUT_SK_CODEC_RESULT = 2;
  static const int ErrorInInput = 2;
  static const int INVALID_CONVERSION_SK_CODEC_RESULT = 3;
  static const int InvalidConversion = 3;
  static const int INVALID_SCALE_SK_CODEC_RESULT = 4;
  static const int InvalidScale = 4;
  static const int INVALID_PARAMETERS_SK_CODEC_RESULT = 5;
  static const int InvalidParameters = 5;
  static const int INVALID_INPUT_SK_CODEC_RESULT = 6;
  static const int InvalidInput = 6;
  static const int COULD_NOT_REWIND_SK_CODEC_RESULT = 7;
  static const int CouldNotRewind = 7;
  static const int INTERNAL_ERROR_SK_CODEC_RESULT = 8;
  static const int InternalError = 8;
  static const int UNIMPLEMENTED_SK_CODEC_RESULT = 9;
  static const int Unimplemented = 9;
}

/// SKCodecScanlineOrder
abstract class SKCodecScanlineOrder {
  static const int TOP_DOWN_SK_CODEC_SCANLINE_ORDER = 0;
  static const int TopDown = 0;
  static const int BOTTOM_UP_SK_CODEC_SCANLINE_ORDER = 1;
  static const int BottomUp = 1;
}

/// SKZeroInitialized
abstract class SKZeroInitialized {
  static const int YES_SK_CODEC_ZERO_INITIALIZED = 0;
  static const int Yes = 0;
  static const int NO_SK_CODEC_ZERO_INITIALIZED = 1;
  static const int No = 1;
}

/// SKCodecAnimationBlend
abstract class SKCodecAnimationBlend {
  static const int SRC_OVER_SK_CODEC_ANIMATION_BLEND = 0;
  static const int SrcOver = 0;
  static const int SRC_SK_CODEC_ANIMATION_BLEND = 1;
  static const int Src = 1;
}

/// SKCodecAnimationDisposalMethod
abstract class SKCodecAnimationDisposalMethod {
  static const int KEEP_SK_CODEC_ANIMATION_DISPOSAL_METHOD = 1;
  static const int Keep = 1;
  static const int RESTORE_BG_COLOR_SK_CODEC_ANIMATION_DISPOSAL_METHOD = 2;
  static const int RestoreBackgroundColor = 2;
  static const int RESTORE_PREVIOUS_SK_CODEC_ANIMATION_DISPOSAL_METHOD = 3;
  static const int RestorePrevious = 3;
}

/// SKColorChannel
abstract class SKColorChannel {
  static const int R_SK_COLOR_CHANNEL = 0;
  static const int R = 0;
  static const int G_SK_COLOR_CHANNEL = 1;
  static const int G = 1;
  static const int B_SK_COLOR_CHANNEL = 2;
  static const int B = 2;
  static const int A_SK_COLOR_CHANNEL = 3;
  static const int A = 3;
}

/// SKColorTypeNative
abstract class SKColorTypeNative {
  static const int UNKNOWN_SK_COLORTYPE = 0;
  static const int Unknown = 0;
  static const int ALPHA_8_SK_COLORTYPE = 1;
  static const int Alpha8 = 1;
  static const int RGB_565_SK_COLORTYPE = 2;
  static const int Rgb565 = 2;
  static const int ARGB_4444_SK_COLORTYPE = 3;
  static const int Argb4444 = 3;
  static const int RGBA_8888_SK_COLORTYPE = 4;
  static const int Rgba8888 = 4;
  static const int RGB_888X_SK_COLORTYPE = 5;
  static const int Rgb888x = 5;
  static const int BGRA_8888_SK_COLORTYPE = 6;
  static const int Bgra8888 = 6;
  static const int RGBA_1010102_SK_COLORTYPE = 7;
  static const int Rgba1010102 = 7;
  static const int BGRA_1010102_SK_COLORTYPE = 8;
  static const int Bgra1010102 = 8;
  static const int RGB_101010X_SK_COLORTYPE = 9;
  static const int Rgb101010x = 9;
  static const int BGR_101010X_SK_COLORTYPE = 10;
  static const int Bgr101010x = 10;
  static const int BGR_101010X_XR_SK_COLORTYPE = 11;
  static const int Bgr101010xXr = 11;
  static const int RGBA_10X6_SK_COLORTYPE = 12;
  static const int Rgba10x6 = 12;
  static const int GRAY_8_SK_COLORTYPE = 13;
  static const int Gray8 = 13;
  static const int RGBA_F16_NORM_SK_COLORTYPE = 14;
  static const int RgbaF16Norm = 14;
  static const int RGBA_F16_SK_COLORTYPE = 15;
  static const int RgbaF16 = 15;
  static const int RGBA_F32_SK_COLORTYPE = 16;
  static const int RgbaF32 = 16;
  static const int R8G8_UNORM_SK_COLORTYPE = 17;
  static const int R8g8Unorm = 17;
  static const int A16_FLOAT_SK_COLORTYPE = 18;
  static const int A16Float = 18;
  static const int R16G16_FLOAT_SK_COLORTYPE = 19;
  static const int R16g16Float = 19;
  static const int A16_UNORM_SK_COLORTYPE = 20;
  static const int A16Unorm = 20;
  static const int R16G16_UNORM_SK_COLORTYPE = 21;
  static const int R16g16Unorm = 21;
  static const int R16G16B16A16_UNORM_SK_COLORTYPE = 22;
  static const int R16g16b16a16Unorm = 22;
  static const int SRGBA_8888_SK_COLORTYPE = 23;
  static const int Srgba8888 = 23;
  static const int R8_UNORM_SK_COLORTYPE = 24;
  static const int R8Unorm = 24;
}

/// SKEncodedImageFormat
abstract class SKEncodedImageFormat {
  static const int BMP_SK_ENCODED_FORMAT = 0;
  static const int Bmp = 0;
  static const int GIF_SK_ENCODED_FORMAT = 1;
  static const int Gif = 1;
  static const int ICO_SK_ENCODED_FORMAT = 2;
  static const int Ico = 2;
  static const int JPEG_SK_ENCODED_FORMAT = 3;
  static const int Jpeg = 3;
  static const int PNG_SK_ENCODED_FORMAT = 4;
  static const int Png = 4;
  static const int WBMP_SK_ENCODED_FORMAT = 5;
  static const int Wbmp = 5;
  static const int WEBP_SK_ENCODED_FORMAT = 6;
  static const int Webp = 6;
  static const int PKM_SK_ENCODED_FORMAT = 7;
  static const int Pkm = 7;
  static const int KTX_SK_ENCODED_FORMAT = 8;
  static const int Ktx = 8;
  static const int ASTC_SK_ENCODED_FORMAT = 9;
  static const int Astc = 9;
  static const int DNG_SK_ENCODED_FORMAT = 10;
  static const int Dng = 10;
  static const int HEIF_SK_ENCODED_FORMAT = 11;
  static const int Heif = 11;
  static const int AVIF_SK_ENCODED_FORMAT = 12;
  static const int Avif = 12;
  static const int JPEGXL_SK_ENCODED_FORMAT = 13;
  static const int Jpegxl = 13;
}

/// SKEncodedOrigin
abstract class SKEncodedOrigin {
  static const int TOP_LEFT_SK_ENCODED_ORIGIN = 1;
  static const int TopLeft = 1;
  static const int TOP_RIGHT_SK_ENCODED_ORIGIN = 2;
  static const int TopRight = 2;
  static const int BOTTOM_RIGHT_SK_ENCODED_ORIGIN = 3;
  static const int BottomRight = 3;
  static const int BOTTOM_LEFT_SK_ENCODED_ORIGIN = 4;
  static const int BottomLeft = 4;
  static const int LEFT_TOP_SK_ENCODED_ORIGIN = 5;
  static const int LeftTop = 5;
  static const int RIGHT_TOP_SK_ENCODED_ORIGIN = 6;
  static const int RightTop = 6;
  static const int RIGHT_BOTTOM_SK_ENCODED_ORIGIN = 7;
  static const int RightBottom = 7;
  static const int LEFT_BOTTOM_SK_ENCODED_ORIGIN = 8;
  static const int LeftBottom = 8;
  static const int DEFAULT_SK_ENCODED_ORIGIN = 9;
  static const int Default = 1;
}

/// SKFilterMode
abstract class SKFilterMode {
  static const int NEAREST_SK_FILTER_MODE = 0;
  static const int Nearest = 0;
  static const int LINEAR_SK_FILTER_MODE = 1;
  static const int Linear = 1;
}

/// SKFontEdging
abstract class SKFontEdging {
  static const int ALIAS_SK_FONT_EDGING = 0;
  static const int Alias = 0;
  static const int ANTIALIAS_SK_FONT_EDGING = 1;
  static const int Antialias = 1;
  static const int SUBPIXEL_ANTIALIAS_SK_FONT_EDGING = 2;
  static const int SubpixelAntialias = 2;
}

/// SKFontHinting
abstract class SKFontHinting {
  static const int NONE_SK_FONT_HINTING = 0;
  static const int None = 0;
  static const int SLIGHT_SK_FONT_HINTING = 1;
  static const int Slight = 1;
  static const int NORMAL_SK_FONT_HINTING = 2;
  static const int Normal = 2;
  static const int FULL_SK_FONT_HINTING = 3;
  static const int Full = 3;
}

/// SKFontStyleSlant
abstract class SKFontStyleSlant {
  static const int UPRIGHT_SK_FONT_STYLE_SLANT = 0;
  static const int Upright = 0;
  static const int ITALIC_SK_FONT_STYLE_SLANT = 1;
  static const int Italic = 1;
  static const int OBLIQUE_SK_FONT_STYLE_SLANT = 2;
  static const int Oblique = 2;
}

/// SKHighContrastConfigInvertStyle
abstract class SKHighContrastConfigInvertStyle {
  static const int NO_INVERT_SK_HIGH_CONTRAST_CONFIG_INVERT_STYLE = 0;
  static const int NoInvert = 0;
  static const int INVERT_BRIGHTNESS_SK_HIGH_CONTRAST_CONFIG_INVERT_STYLE = 1;
  static const int InvertBrightness = 1;
  static const int INVERT_LIGHTNESS_SK_HIGH_CONTRAST_CONFIG_INVERT_STYLE = 2;
  static const int InvertLightness = 2;
}

/// SKImageCachingHint
abstract class SKImageCachingHint {
  static const int ALLOW_SK_IMAGE_CACHING_HINT = 0;
  static const int Allow = 0;
  static const int DISALLOW_SK_IMAGE_CACHING_HINT = 1;
  static const int Disallow = 1;
}

/// SKJpegEncoderAlphaOption
abstract class SKJpegEncoderAlphaOption {
  static const int IGNORE_SK_JPEGENCODER_ALPHA_OPTION = 0;
  static const int Ignore = 0;
  static const int BLEND_ON_BLACK_SK_JPEGENCODER_ALPHA_OPTION = 1;
  static const int BlendOnBlack = 1;
}

/// SKJpegEncoderDownsample
abstract class SKJpegEncoderDownsample {
  static const int DOWNSAMPLE_420_SK_JPEGENCODER_DOWNSAMPLE = 0;
  static const int Downsample420 = 0;
  static const int DOWNSAMPLE_422_SK_JPEGENCODER_DOWNSAMPLE = 1;
  static const int Downsample422 = 1;
  static const int DOWNSAMPLE_444_SK_JPEGENCODER_DOWNSAMPLE = 2;
  static const int Downsample444 = 2;
}

/// SKLatticeRectType
abstract class SKLatticeRectType {
  static const int DEFAULT_SK_LATTICE_RECT_TYPE = 0;
  static const int Default = 0;
  static const int TRANSPARENT_SK_LATTICE_RECT_TYPE = 1;
  static const int Transparent = 1;
  static const int FIXED_COLOR_SK_LATTICE_RECT_TYPE = 2;
  static const int FixedColor = 2;
}

/// SKMipmapMode
abstract class SKMipmapMode {
  static const int NONE_SK_MIPMAP_MODE = 0;
  static const int None = 0;
  static const int NEAREST_SK_MIPMAP_MODE = 1;
  static const int Nearest = 1;
  static const int LINEAR_SK_MIPMAP_MODE = 2;
  static const int Linear = 2;
}

/// SKPaintStyle
abstract class SKPaintStyle {
  static const int FILL_SK_PAINT_STYLE = 0;
  static const int Fill = 0;
  static const int STROKE_SK_PAINT_STYLE = 1;
  static const int Stroke = 1;
  static const int STROKE_AND_FILL_SK_PAINT_STYLE = 2;
  static const int StrokeAndFill = 2;
}

/// SKPathAddMode
abstract class SKPathAddMode {
  static const int APPEND_SK_PATH_ADD_MODE = 0;
  static const int Append = 0;
  static const int EXTEND_SK_PATH_ADD_MODE = 1;
  static const int Extend = 1;
}

/// SKPathArcSize
abstract class SKPathArcSize {
  static const int SMALL_SK_PATH_ARC_SIZE = 0;
  static const int Small = 0;
  static const int LARGE_SK_PATH_ARC_SIZE = 1;
  static const int Large = 1;
}

/// SKPathDirection
abstract class SKPathDirection {
  static const int CW_SK_PATH_DIRECTION = 0;
  static const int Clockwise = 0;
  static const int CCW_SK_PATH_DIRECTION = 1;
  static const int CounterClockwise = 1;
}

/// SKPath1DPathEffectStyle
abstract class SKPath1DPathEffectStyle {
  static const int TRANSLATE_SK_PATH_EFFECT_1D_STYLE = 0;
  static const int Translate = 0;
  static const int ROTATE_SK_PATH_EFFECT_1D_STYLE = 1;
  static const int Rotate = 1;
  static const int MORPH_SK_PATH_EFFECT_1D_STYLE = 2;
  static const int Morph = 2;
}

/// SKTrimPathEffectMode
abstract class SKTrimPathEffectMode {
  static const int NORMAL_SK_PATH_EFFECT_TRIM_MODE = 0;
  static const int Normal = 0;
  static const int INVERTED_SK_PATH_EFFECT_TRIM_MODE = 1;
  static const int Inverted = 1;
}

/// SKPathFillType
abstract class SKPathFillType {
  static const int WINDING_SK_PATH_FILLTYPE = 0;
  static const int Winding = 0;
  static const int EVENODD_SK_PATH_FILLTYPE = 1;
  static const int EvenOdd = 1;
  static const int INVERSE_WINDING_SK_PATH_FILLTYPE = 2;
  static const int InverseWinding = 2;
  static const int INVERSE_EVENODD_SK_PATH_FILLTYPE = 3;
  static const int InverseEvenOdd = 3;
}

/// SKPathSegmentMask
abstract class SKPathSegmentMask {
  static const int LINE_SK_PATH_SEGMENT_MASK = 1;
  static const int Line = 1;
  static const int QUAD_SK_PATH_SEGMENT_MASK = 1;
  static const int Quad = 2;
  static const int CONIC_SK_PATH_SEGMENT_MASK = 1;
  static const int Conic = 4;
  static const int CUBIC_SK_PATH_SEGMENT_MASK = 1;
  static const int Cubic = 8;
}

/// SKPathVerb
abstract class SKPathVerb {
  static const int MOVE_SK_PATH_VERB = 0;
  static const int Move = 0;
  static const int LINE_SK_PATH_VERB = 1;
  static const int Line = 1;
  static const int QUAD_SK_PATH_VERB = 2;
  static const int Quad = 2;
  static const int CONIC_SK_PATH_VERB = 3;
  static const int Conic = 3;
  static const int CUBIC_SK_PATH_VERB = 4;
  static const int Cubic = 4;
  static const int CLOSE_SK_PATH_VERB = 5;
  static const int Close = 5;
  static const int DONE_SK_PATH_VERB = 6;
  static const int Done = 6;
}

/// SKPathMeasureMatrixFlags
abstract class SKPathMeasureMatrixFlags {
  static const int GET_POSITION_SK_PATHMEASURE_MATRIXFLAGS = 0;
  static const int x01 = 1;
  static const int GetPosition = 1;
  static const int GET_TANGENT_SK_PATHMEASURE_MATRIXFLAGS = 0;
  static const int x02 = 1;
  static const int GetTangent = 2;
  static const int GET_POS_AND_TAN_SK_PATHMEASURE_MATRIXFLAGS = 3;
  static const int GetPositionAndTangent = 3;
}

/// SKPathOp
abstract class SKPathOp {
  static const int DIFFERENCE_SK_PATHOP = 0;
  static const int Difference = 0;
  static const int INTERSECT_SK_PATHOP = 1;
  static const int Intersect = 1;
  static const int UNION_SK_PATHOP = 2;
  static const int Union = 2;
  static const int XOR_SK_PATHOP = 3;
  static const int Xor = 3;
  static const int REVERSE_DIFFERENCE_SK_PATHOP = 4;
  static const int ReverseDifference = 4;
}

/// SKPixelGeometry
abstract class SKPixelGeometry {
  static const int UNKNOWN_SK_PIXELGEOMETRY = 0;
  static const int Unknown = 0;
  static const int RGB_H_SK_PIXELGEOMETRY = 1;
  static const int RgbHorizontal = 1;
  static const int BGR_H_SK_PIXELGEOMETRY = 2;
  static const int BgrHorizontal = 2;
  static const int RGB_V_SK_PIXELGEOMETRY = 3;
  static const int RgbVertical = 3;
  static const int BGR_V_SK_PIXELGEOMETRY = 4;
  static const int BgrVertical = 4;
}

/// SKPngEncoderFilterFlags
abstract class SKPngEncoderFilterFlags {
  static const int ZERO_SK_PNGENCODER_FILTER_FLAGS = 0;
  static const int x00 = 1;
  static const int NoFilters = 0;
  static const int NONE_SK_PNGENCODER_FILTER_FLAGS = 0;
  static const int x08 = 1;
  static const int None = 8;
  static const int SUB_SK_PNGENCODER_FILTER_FLAGS = 0;
  static const int x10 = 1;
  static const int Sub = 16;
  static const int UP_SK_PNGENCODER_FILTER_FLAGS = 0;
  static const int x20 = 1;
  static const int Up = 32;
  static const int AVG_SK_PNGENCODER_FILTER_FLAGS = 0;
  static const int x40 = 1;
  static const int Avg = 64;
  static const int PAETH_SK_PNGENCODER_FILTER_FLAGS = 0;
  static const int x80 = 1;
  static const int Paeth = 128;
  static const int ALL_SK_PNGENCODER_FILTER_FLAGS = 129;
  static const int AllFilters = 248;
}

/// SKPointMode
abstract class SKPointMode {
  static const int POINTS_SK_POINT_MODE = 0;
  static const int Points = 0;
  static const int LINES_SK_POINT_MODE = 1;
  static const int Lines = 1;
  static const int POLYGON_SK_POINT_MODE = 2;
  static const int Polygon = 2;
}

/// SKRegionOperation
abstract class SKRegionOperation {
  static const int DIFFERENCE_SK_REGION_OP = 0;
  static const int Difference = 0;
  static const int INTERSECT_SK_REGION_OP = 1;
  static const int Intersect = 1;
  static const int UNION_SK_REGION_OP = 2;
  static const int Union = 2;
  static const int XOR_SK_REGION_OP = 3;
  static const int XOR = 3;
  static const int REVERSE_DIFFERENCE_SK_REGION_OP = 4;
  static const int ReverseDifference = 4;
  static const int REPLACE_SK_REGION_OP = 5;
  static const int Replace = 5;
}

/// SKRoundRectCorner
abstract class SKRoundRectCorner {
  static const int UPPER_LEFT_SK_RRECT_CORNER = 0;
  static const int UpperLeft = 0;
  static const int UPPER_RIGHT_SK_RRECT_CORNER = 1;
  static const int UpperRight = 1;
  static const int LOWER_RIGHT_SK_RRECT_CORNER = 2;
  static const int LowerRight = 2;
  static const int LOWER_LEFT_SK_RRECT_CORNER = 3;
  static const int LowerLeft = 3;
}

/// SKRoundRectType
abstract class SKRoundRectType {
  static const int EMPTY_SK_RRECT_TYPE = 0;
  static const int Empty = 0;
  static const int RECT_SK_RRECT_TYPE = 1;
  static const int Rect = 1;
  static const int OVAL_SK_RRECT_TYPE = 2;
  static const int Oval = 2;
  static const int SIMPLE_SK_RRECT_TYPE = 3;
  static const int Simple = 3;
  static const int NINE_PATCH_SK_RRECT_TYPE = 4;
  static const int NinePatch = 4;
  static const int COMPLEX_SK_RRECT_TYPE = 5;
  static const int Complex = 5;
}

/// SKRuntimeEffectChildTypeNative
abstract class SKRuntimeEffectChildTypeNative {
  static const int SHADER_SK_RUNTIMEEFFECT_CHILD_TYPE = 0;
  static const int Shader = 0;
  static const int COLOR_FILTER_SK_RUNTIMEEFFECT_CHILD_TYPE = 1;
  static const int ColorFilter = 1;
  static const int BLENDER_SK_RUNTIMEEFFECT_CHILD_TYPE = 2;
  static const int Blender = 2;
}

/// SKRuntimeEffectUniformFlagsNative
abstract class SKRuntimeEffectUniformFlagsNative {
  static const int NONE_SK_RUNTIMEEFFECT_UNIFORM_FLAGS = 0;
  static const int x00 = 1;
  static const int None = 0;
  static const int ARRAY_SK_RUNTIMEEFFECT_UNIFORM_FLAGS = 0;
  static const int x01 = 1;
  static const int Array = 1;
  static const int COLOR_SK_RUNTIMEEFFECT_UNIFORM_FLAGS = 0;
  static const int x02 = 1;
  static const int Color = 2;
  static const int VERTEX_SK_RUNTIMEEFFECT_UNIFORM_FLAGS = 0;
  static const int x04 = 1;
  static const int Vertex = 4;
  static const int FRAGMENT_SK_RUNTIMEEFFECT_UNIFORM_FLAGS = 0;
  static const int x08 = 1;
  static const int Fragment = 8;
  static const int HALF_PRECISION_SK_RUNTIMEEFFECT_UNIFORM_FLAGS = 0;
  static const int x10 = 1;
  static const int HalfPrecision = 16;
}

/// SKRuntimeEffectUniformTypeNative
abstract class SKRuntimeEffectUniformTypeNative {
  static const int FLOAT_SK_RUNTIMEEFFECT_UNIFORM_TYPE = 0;
  static const int Float = 0;
  static const int FLOAT2_SK_RUNTIMEEFFECT_UNIFORM_TYPE = 1;
  static const int Float2 = 1;
  static const int FLOAT3_SK_RUNTIMEEFFECT_UNIFORM_TYPE = 2;
  static const int Float3 = 2;
  static const int FLOAT4_SK_RUNTIMEEFFECT_UNIFORM_TYPE = 3;
  static const int Float4 = 3;
  static const int FLOAT2X2_SK_RUNTIMEEFFECT_UNIFORM_TYPE = 4;
  static const int Float2x2 = 4;
  static const int FLOAT3X3_SK_RUNTIMEEFFECT_UNIFORM_TYPE = 5;
  static const int Float3x3 = 5;
  static const int FLOAT4X4_SK_RUNTIMEEFFECT_UNIFORM_TYPE = 6;
  static const int Float4x4 = 6;
  static const int INT_SK_RUNTIMEEFFECT_UNIFORM_TYPE = 7;
  static const int Int = 7;
  static const int INT2_SK_RUNTIMEEFFECT_UNIFORM_TYPE = 8;
  static const int Int2 = 8;
  static const int INT3_SK_RUNTIMEEFFECT_UNIFORM_TYPE = 9;
  static const int Int3 = 9;
  static const int INT4_SK_RUNTIMEEFFECT_UNIFORM_TYPE = 10;
  static const int Int4 = 10;
}

/// SKShaderTileMode
abstract class SKShaderTileMode {
  static const int CLAMP_SK_SHADER_TILEMODE = 0;
  static const int Clamp = 0;
  static const int REPEAT_SK_SHADER_TILEMODE = 1;
  static const int Repeat = 1;
  static const int MIRROR_SK_SHADER_TILEMODE = 2;
  static const int Mirror = 2;
  static const int DECAL_SK_SHADER_TILEMODE = 3;
  static const int Decal = 3;
}

/// SKStrokeCap
abstract class SKStrokeCap {
  static const int BUTT_SK_STROKE_CAP = 0;
  static const int Butt = 0;
  static const int ROUND_SK_STROKE_CAP = 1;
  static const int Round = 1;
  static const int SQUARE_SK_STROKE_CAP = 2;
  static const int Square = 2;
}

/// SKStrokeJoin
abstract class SKStrokeJoin {
  static const int MITER_SK_STROKE_JOIN = 0;
  static const int Miter = 0;
  static const int ROUND_SK_STROKE_JOIN = 1;
  static const int Round = 1;
  static const int BEVEL_SK_STROKE_JOIN = 2;
  static const int Bevel = 2;
}

/// SKSurfacePropsFlags
abstract class SKSurfacePropsFlags {
  static const int NONE_SK_SURFACE_PROPS_FLAGS = 0;
  static const int None = 0;
  static const int USE_DEVICE_INDEPENDENT_FONTS_SK_SURFACE_PROPS_FLAGS = 1;
  static const int UseDeviceIndependentFonts = 1;
}

/// SKTextAlign
abstract class SKTextAlign {
  static const int LEFT_SK_TEXT_ALIGN = 0;
  static const int Left = 0;
  static const int CENTER_SK_TEXT_ALIGN = 1;
  static const int Center = 1;
  static const int RIGHT_SK_TEXT_ALIGN = 2;
  static const int Right = 2;
}

/// SKTextEncoding
abstract class SKTextEncoding {
  static const int UTF8_SK_TEXT_ENCODING = 0;
  static const int Utf8 = 0;
  static const int UTF16_SK_TEXT_ENCODING = 1;
  static const int Utf16 = 1;
  static const int UTF32_SK_TEXT_ENCODING = 2;
  static const int Utf32 = 2;
  static const int GLYPH_ID_SK_TEXT_ENCODING = 3;
  static const int GlyphId = 3;
}

/// SKVertexMode
abstract class SKVertexMode {
  static const int TRIANGLES_SK_VERTICES_VERTEX_MODE = 0;
  static const int Triangles = 0;
  static const int TRIANGLE_STRIP_SK_VERTICES_VERTEX_MODE = 1;
  static const int TriangleStrip = 1;
  static const int TRIANGLE_FAN_SK_VERTICES_VERTEX_MODE = 2;
  static const int TriangleFan = 2;
}

/// SKWebpEncoderCompression
abstract class SKWebpEncoderCompression {
  static const int LOSSY_SK_WEBPENCODER_COMPTRESSION = 0;
  static const int Lossy = 0;
  static const int LOSSLESS_SK_WEBPENCODER_COMPTRESSION = 1;
  static const int Lossless = 1;
}


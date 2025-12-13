

import '../../io/byte_order_swapping_reader.dart';
import 'table_entry.dart';
import 'variations/item_variation_store.dart';

/// COLR — Color Table
/// https://docs.microsoft.com/en-us/typography/opentype/spec/colr
class COLR extends TableEntry {
  @override
  String get name => 'COLR';

  int version = 0;

  // V0 data
  late List<int> glyphLayers;
  late List<int> glyphPalettes;
  final Map<int, int> layerIndices = {};
  final Map<int, int> layerCounts = {};

  // V1 data
  BaseGlyphList? baseGlyphList;
  LayerList? layerList;
  ClipList? clipList;
  DeltaSetIndexMap? varIndexMap;
  ItemVariationStore? itemVariationStore;

  @override
  void readContentFrom(ByteOrderSwappingBinaryReader reader) {
    final tableOffset = reader.position;

    version = reader.readUInt16();
    final numBaseGlyphRecords = reader.readUInt16();
    final baseGlyphRecordsOffset = reader.readUInt32();
    final layerRecordsOffset = reader.readUInt32();
    final numLayerRecords = reader.readUInt16();

    // Initialize v0 lists
    glyphLayers = List<int>.filled(numLayerRecords, 0);
    glyphPalettes = List<int>.filled(numLayerRecords, 0);

    // Read v0 BaseGlyphRecords
    if (baseGlyphRecordsOffset > 0) {
      reader.seek(tableOffset + baseGlyphRecordsOffset);
      for (var i = 0; i < numBaseGlyphRecords; i++) {
        final gid = reader.readUInt16();
        layerIndices[gid] = reader.readUInt16();
        layerCounts[gid] = reader.readUInt16();
      }
    }

    // Read v0 LayerRecords
    if (layerRecordsOffset > 0 && numLayerRecords > 0) {
      reader.seek(tableOffset + layerRecordsOffset);
      for (var i = 0; i < numLayerRecords; i++) {
        glyphLayers[i] = reader.readUInt16();
        glyphPalettes[i] = reader.readUInt16();
      }
    }

    // V1 extensions
    if (version >= 1) {
      // Continue reading from after v0 header (position 14)
      reader.seek(tableOffset + 14);

      final baseGlyphListOffset = reader.readUInt32();
      final layerListOffset = reader.readUInt32();
      final clipListOffset = reader.readUInt32();
      final varIdxMapOffset = reader.readUInt32();
      final itemVariationStoreOffset = reader.readUInt32();

      // Read BaseGlyphList
      if (baseGlyphListOffset > 0) {
        reader.seek(tableOffset + baseGlyphListOffset);
        baseGlyphList = BaseGlyphList();
        baseGlyphList!.readFrom(reader, tableOffset);
      }

      // Read LayerList
      if (layerListOffset > 0) {
        reader.seek(tableOffset + layerListOffset);
        layerList = LayerList();
        layerList!.readFrom(reader, tableOffset + layerListOffset);
      }

      // Read ClipList
      if (clipListOffset > 0) {
        reader.seek(tableOffset + clipListOffset);
        clipList = ClipList();
        clipList!.readFrom(reader);
      }

      // Read VarIdxMap (DeltaSetIndexMap)
      if (varIdxMapOffset > 0) {
        reader.seek(tableOffset + varIdxMapOffset);
        varIndexMap = DeltaSetIndexMap();
        varIndexMap!.readFrom(reader);
      }

      // Read ItemVariationStore
      if (itemVariationStoreOffset > 0) {
        reader.seek(tableOffset + itemVariationStoreOffset);
        itemVariationStore = ItemVariationStore();
        itemVariationStore!.readContent(reader);
      }
    }
  }

  /// Get paint table for a glyph (v1 only)
  BaseGlyphPaintRecord? getBaseGlyphPaint(int glyphId) {
    if (baseGlyphList == null) return null;
    for (final record in baseGlyphList!.records) {
      if (record.glyphId == glyphId) return record;
    }
    return null;
  }

  /// Check if glyph has v0 color layers
  bool hasV0Layers(int glyphId) => layerIndices.containsKey(glyphId);

  /// Check if glyph has v1 paint
  bool hasV1Paint(int glyphId) => getBaseGlyphPaint(glyphId) != null;
}

// ============================================================================
// V1 Data Structures
// ============================================================================

/// BaseGlyphList (COLR v1)
class BaseGlyphList {
  int numBaseGlyphPaintRecords = 0;
  List<BaseGlyphPaintRecord> records = [];

  void readFrom(ByteOrderSwappingBinaryReader reader, int tableOffset) {
    numBaseGlyphPaintRecords = reader.readUInt32();
    records = List.generate(numBaseGlyphPaintRecords, (_) {
      final record = BaseGlyphPaintRecord();
      record.glyphId = reader.readUInt16();
      record.paintOffset = reader.readUInt32();
      return record;
    });
  }
}

/// BaseGlyphPaintRecord
class BaseGlyphPaintRecord {
  int glyphId = 0;
  int paintOffset = 0;
  Paint? paint;
}

/// LayerList
class LayerList {
  int numLayers = 0;
  List<int> paintOffsets = [];
  List<Paint?> paints = [];

  void readFrom(ByteOrderSwappingBinaryReader reader, int listOffset) {
    numLayers = reader.readUInt32();
    paintOffsets = List.generate(numLayers, (_) => reader.readUInt32());
    paints = List.filled(numLayers, null);
  }
}

/// ClipList
class ClipList {
  int format = 0;
  int numClips = 0;
  List<ClipRecord> clips = [];

  void readFrom(ByteOrderSwappingBinaryReader reader) {
    format = reader.readUInt8();
    numClips = reader.readUInt32();
    clips = List.generate(numClips, (_) {
      final clip = ClipRecord();
      clip.startGlyphId = reader.readUInt16();
      clip.endGlyphId = reader.readUInt16();
      clip.clipBoxOffset = reader.readUInt24();
      return clip;
    });
  }
}

/// ClipRecord
class ClipRecord {
  int startGlyphId = 0;
  int endGlyphId = 0;
  int clipBoxOffset = 0;
}

/// ClipBox
class ClipBox {
  int format = 0;
  int xMin = 0;
  int yMin = 0;
  int xMax = 0;
  int yMax = 0;
  // For format 2 (variable)
  int varIndexBase = 0;

  void readFrom(ByteOrderSwappingBinaryReader reader) {
    format = reader.readUInt8();
    xMin = reader.readInt16();
    yMin = reader.readInt16();
    xMax = reader.readInt16();
    yMax = reader.readInt16();
    if (format == 2) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// DeltaSetIndexMap for COLR v1
class DeltaSetIndexMap {
  int format = 0;
  int entryFormat = 0;
  int mapCount = 0;
  List<int> mapData = [];

  void readFrom(ByteOrderSwappingBinaryReader reader) {
    format = reader.readUInt8();
    entryFormat = reader.readUInt8();

    if (format == 0) {
      mapCount = reader.readUInt16();
    } else {
      mapCount = reader.readUInt32();
    }

    // Entry size based on entryFormat
    final innerBits = (entryFormat & 0x0F) + 1;
    final outerBits = ((entryFormat >> 4) & 0x0F) + 1;
    final entrySize = (innerBits + outerBits + 7) ~/ 8;

    mapData = List.generate(mapCount, (_) {
      if (entrySize == 1) return reader.readUInt8();
      if (entrySize == 2) return reader.readUInt16();
      if (entrySize == 3) return reader.readUInt24();
      return reader.readUInt32();
    });
  }

  /// Get delta set indices for an entry
  (int outerIndex, int innerIndex) getIndices(int index) {
    if (index >= mapCount) return (0, 0);
    final entry = mapData[index];
    final innerBits = (entryFormat & 0x0F) + 1;
    final innerMask = (1 << innerBits) - 1;
    final innerIndex = entry & innerMask;
    final outerIndex = entry >> innerBits;
    return (outerIndex, innerIndex);
  }
}

// ============================================================================
// Paint Tables (COLR v1)
// ============================================================================

/// Paint format types
enum PaintFormat {
  colrLayers(1),
  solidPalette(2),
  solidPaletteVar(3),
  linearGradient(4),
  linearGradientVar(5),
  radialGradient(6),
  radialGradientVar(7),
  sweepGradient(8),
  sweepGradientVar(9),
  glyph(10),
  colrGlyph(11),
  transform(12),
  transformVar(13),
  translate(14),
  translateVar(15),
  scale(16),
  scaleVar(17),
  scaleAroundCenter(18),
  scaleAroundCenterVar(19),
  scaleUniform(20),
  scaleUniformVar(21),
  scaleUniformAroundCenter(22),
  scaleUniformAroundCenterVar(23),
  rotate(24),
  rotateVar(25),
  rotateAroundCenter(26),
  rotateAroundCenterVar(27),
  skew(28),
  skewVar(29),
  skewAroundCenter(30),
  skewAroundCenterVar(31),
  composite(32);

  final int value;
  const PaintFormat(this.value);

  static PaintFormat? fromValue(int value) {
    for (final format in values) {
      if (format.value == value) return format;
    }
    return null;
  }
}

/// Composite modes for PaintComposite
enum CompositeMode {
  clear(0),
  src(1),
  dest(2),
  srcOver(3),
  destOver(4),
  srcIn(5),
  destIn(6),
  srcOut(7),
  destOut(8),
  srcAtop(9),
  destAtop(10),
  xor(11),
  plus(12),
  screen(13),
  overlay(14),
  darken(15),
  lighten(16),
  colorDodge(17),
  colorBurn(18),
  hardLight(19),
  softLight(20),
  difference(21),
  exclusion(22),
  multiply(23),
  hslHue(24),
  hslSaturation(25),
  hslColor(26),
  hslLuminosity(27);

  final int value;
  const CompositeMode(this.value);

  static CompositeMode? fromValue(int value) {
    for (final mode in values) {
      if (mode.value == value) return mode;
    }
    return null;
  }
}

/// Extend mode for gradients
enum ExtendMode {
  pad(0),
  repeat(1),
  reflect(2);

  final int value;
  const ExtendMode(this.value);

  static ExtendMode fromValue(int value) {
    return ExtendMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ExtendMode.pad,
    );
  }
}

/// Base Paint class
abstract class Paint {
  PaintFormat get format;

  static Paint? readFrom(ByteOrderSwappingBinaryReader reader, int paintOffset) {
    if (paintOffset == 0) return null;

    final startPos = reader.position;
    reader.seek(paintOffset);

    final formatValue = reader.readUInt8();
    final format = PaintFormat.fromValue(formatValue);
    if (format == null) return null;

    Paint? paint;
    switch (format) {
      case PaintFormat.colrLayers:
        paint = PaintColrLayers()..readContent(reader);
        break;
      case PaintFormat.solidPalette:
      case PaintFormat.solidPaletteVar:
        paint = PaintSolid(format == PaintFormat.solidPaletteVar)
          ..readContent(reader);
        break;
      case PaintFormat.linearGradient:
      case PaintFormat.linearGradientVar:
        paint = PaintLinearGradient(format == PaintFormat.linearGradientVar)
          ..readContent(reader);
        break;
      case PaintFormat.radialGradient:
      case PaintFormat.radialGradientVar:
        paint = PaintRadialGradient(format == PaintFormat.radialGradientVar)
          ..readContent(reader);
        break;
      case PaintFormat.sweepGradient:
      case PaintFormat.sweepGradientVar:
        paint = PaintSweepGradient(format == PaintFormat.sweepGradientVar)
          ..readContent(reader);
        break;
      case PaintFormat.glyph:
        paint = PaintGlyph()..readContent(reader);
        break;
      case PaintFormat.colrGlyph:
        paint = PaintColrGlyph()..readContent(reader);
        break;
      case PaintFormat.transform:
      case PaintFormat.transformVar:
        paint = PaintTransform(format == PaintFormat.transformVar)
          ..readContent(reader);
        break;
      case PaintFormat.translate:
      case PaintFormat.translateVar:
        paint = PaintTranslate(format == PaintFormat.translateVar)
          ..readContent(reader);
        break;
      case PaintFormat.scale:
      case PaintFormat.scaleVar:
        paint = PaintScale(format == PaintFormat.scaleVar)..readContent(reader);
        break;
      case PaintFormat.scaleAroundCenter:
      case PaintFormat.scaleAroundCenterVar:
        paint = PaintScaleAroundCenter(
            format == PaintFormat.scaleAroundCenterVar)
          ..readContent(reader);
        break;
      case PaintFormat.scaleUniform:
      case PaintFormat.scaleUniformVar:
        paint = PaintScaleUniform(format == PaintFormat.scaleUniformVar)
          ..readContent(reader);
        break;
      case PaintFormat.scaleUniformAroundCenter:
      case PaintFormat.scaleUniformAroundCenterVar:
        paint = PaintScaleUniformAroundCenter(
            format == PaintFormat.scaleUniformAroundCenterVar)
          ..readContent(reader);
        break;
      case PaintFormat.rotate:
      case PaintFormat.rotateVar:
        paint = PaintRotate(format == PaintFormat.rotateVar)
          ..readContent(reader);
        break;
      case PaintFormat.rotateAroundCenter:
      case PaintFormat.rotateAroundCenterVar:
        paint = PaintRotateAroundCenter(
            format == PaintFormat.rotateAroundCenterVar)
          ..readContent(reader);
        break;
      case PaintFormat.skew:
      case PaintFormat.skewVar:
        paint = PaintSkew(format == PaintFormat.skewVar)..readContent(reader);
        break;
      case PaintFormat.skewAroundCenter:
      case PaintFormat.skewAroundCenterVar:
        paint =
            PaintSkewAroundCenter(format == PaintFormat.skewAroundCenterVar)
              ..readContent(reader);
        break;
      case PaintFormat.composite:
        paint = PaintComposite()..readContent(reader);
        break;
    }

    reader.seek(startPos);
    return paint;
  }

  void readContent(ByteOrderSwappingBinaryReader reader);
}

/// PaintColrLayers - references a contiguous range of layers from LayerList
class PaintColrLayers extends Paint {
  @override
  PaintFormat get format => PaintFormat.colrLayers;

  int numLayers = 0;
  int firstLayerIndex = 0;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    numLayers = reader.readUInt8();
    firstLayerIndex = reader.readUInt32();
  }
}

/// PaintSolid - solid color from palette
class PaintSolid extends Paint {
  final bool isVariable;

  PaintSolid([this.isVariable = false]);

  @override
  PaintFormat get format =>
      isVariable ? PaintFormat.solidPaletteVar : PaintFormat.solidPalette;

  int paletteIndex = 0;
  double alpha = 1.0;
  int varIndexBase = 0;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    paletteIndex = reader.readUInt16();
    alpha = reader.readF2Dot14();
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// ColorStop for gradients
class ColorStop {
  double stopOffset = 0.0;
  int paletteIndex = 0;
  double alpha = 1.0;

  void readFrom(ByteOrderSwappingBinaryReader reader, bool isVariable) {
    stopOffset = reader.readF2Dot14();
    paletteIndex = reader.readUInt16();
    alpha = reader.readF2Dot14();
  }
}

/// VarColorStop - variable color stop
class VarColorStop extends ColorStop {
  int varIndexBase = 0;

  @override
  void readFrom(ByteOrderSwappingBinaryReader reader, bool isVariable) {
    super.readFrom(reader, isVariable);
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// ColorLine for gradients
class ColorLine {
  ExtendMode extend = ExtendMode.pad;
  List<ColorStop> colorStops = [];

  void readFrom(ByteOrderSwappingBinaryReader reader, bool isVariable) {
    extend = ExtendMode.fromValue(reader.readUInt8());
    final numStops = reader.readUInt16();
    colorStops = List.generate(numStops, (_) {
      final stop = isVariable ? VarColorStop() : ColorStop();
      stop.readFrom(reader, isVariable);
      return stop;
    });
  }
}

/// PaintLinearGradient
class PaintLinearGradient extends Paint {
  final bool isVariable;

  PaintLinearGradient([this.isVariable = false]);

  @override
  PaintFormat get format =>
      isVariable ? PaintFormat.linearGradientVar : PaintFormat.linearGradient;

  int colorLineOffset = 0;
  int x0 = 0, y0 = 0;
  int x1 = 0, y1 = 0;
  int x2 = 0, y2 = 0;
  int varIndexBase = 0;
  ColorLine? colorLine;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    colorLineOffset = reader.readUInt24();
    x0 = reader.readInt16();
    y0 = reader.readInt16();
    x1 = reader.readInt16();
    y1 = reader.readInt16();
    x2 = reader.readInt16();
    y2 = reader.readInt16();
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// PaintRadialGradient
class PaintRadialGradient extends Paint {
  final bool isVariable;

  PaintRadialGradient([this.isVariable = false]);

  @override
  PaintFormat get format =>
      isVariable ? PaintFormat.radialGradientVar : PaintFormat.radialGradient;

  int colorLineOffset = 0;
  int x0 = 0, y0 = 0;
  int radius0 = 0;
  int x1 = 0, y1 = 0;
  int radius1 = 0;
  int varIndexBase = 0;
  ColorLine? colorLine;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    colorLineOffset = reader.readUInt24();
    x0 = reader.readInt16();
    y0 = reader.readInt16();
    radius0 = reader.readUInt16();
    x1 = reader.readInt16();
    y1 = reader.readInt16();
    radius1 = reader.readUInt16();
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// PaintSweepGradient
class PaintSweepGradient extends Paint {
  final bool isVariable;

  PaintSweepGradient([this.isVariable = false]);

  @override
  PaintFormat get format =>
      isVariable ? PaintFormat.sweepGradientVar : PaintFormat.sweepGradient;

  int colorLineOffset = 0;
  int centerX = 0, centerY = 0;
  double startAngle = 0.0;
  double endAngle = 0.0;
  int varIndexBase = 0;
  ColorLine? colorLine;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    colorLineOffset = reader.readUInt24();
    centerX = reader.readInt16();
    centerY = reader.readInt16();
    startAngle = reader.readF2Dot14();
    endAngle = reader.readF2Dot14();
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// PaintGlyph - render a glyph outline filled with paint
class PaintGlyph extends Paint {
  @override
  PaintFormat get format => PaintFormat.glyph;

  int paintOffset = 0;
  int glyphId = 0;
  Paint? paint;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    paintOffset = reader.readUInt24();
    glyphId = reader.readUInt16();
  }
}

/// PaintColrGlyph - reference to another COLR glyph
class PaintColrGlyph extends Paint {
  @override
  PaintFormat get format => PaintFormat.colrGlyph;

  int glyphId = 0;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    glyphId = reader.readUInt16();
  }
}

/// PaintTransform - apply affine transformation
class PaintTransform extends Paint {
  final bool isVariable;

  PaintTransform([this.isVariable = false]);

  @override
  PaintFormat get format =>
      isVariable ? PaintFormat.transformVar : PaintFormat.transform;

  int paintOffset = 0;
  int transformOffset = 0;
  Paint? paint;
  Affine2x3? transform;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    paintOffset = reader.readUInt24();
    transformOffset = reader.readUInt24();
  }
}

/// Affine2x3 transformation matrix
class Affine2x3 {
  double xx = 1.0, yx = 0.0;
  double xy = 0.0, yy = 1.0;
  double dx = 0.0, dy = 0.0;

  void readFrom(ByteOrderSwappingBinaryReader reader, bool isVariable) {
    xx = reader.readFixed();
    yx = reader.readFixed();
    xy = reader.readFixed();
    yy = reader.readFixed();
    dx = reader.readFixed();
    dy = reader.readFixed();
  }
}

/// PaintTranslate
class PaintTranslate extends Paint {
  final bool isVariable;

  PaintTranslate([this.isVariable = false]);

  @override
  PaintFormat get format =>
      isVariable ? PaintFormat.translateVar : PaintFormat.translate;

  int paintOffset = 0;
  int dx = 0, dy = 0;
  int varIndexBase = 0;
  Paint? paint;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    paintOffset = reader.readUInt24();
    dx = reader.readInt16();
    dy = reader.readInt16();
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// PaintScale
class PaintScale extends Paint {
  final bool isVariable;

  PaintScale([this.isVariable = false]);

  @override
  PaintFormat get format =>
      isVariable ? PaintFormat.scaleVar : PaintFormat.scale;

  int paintOffset = 0;
  double scaleX = 1.0, scaleY = 1.0;
  int varIndexBase = 0;
  Paint? paint;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    paintOffset = reader.readUInt24();
    scaleX = reader.readF2Dot14();
    scaleY = reader.readF2Dot14();
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// PaintScaleAroundCenter
class PaintScaleAroundCenter extends Paint {
  final bool isVariable;

  PaintScaleAroundCenter([this.isVariable = false]);

  @override
  PaintFormat get format => isVariable
      ? PaintFormat.scaleAroundCenterVar
      : PaintFormat.scaleAroundCenter;

  int paintOffset = 0;
  double scaleX = 1.0, scaleY = 1.0;
  int centerX = 0, centerY = 0;
  int varIndexBase = 0;
  Paint? paint;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    paintOffset = reader.readUInt24();
    scaleX = reader.readF2Dot14();
    scaleY = reader.readF2Dot14();
    centerX = reader.readInt16();
    centerY = reader.readInt16();
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// PaintScaleUniform
class PaintScaleUniform extends Paint {
  final bool isVariable;

  PaintScaleUniform([this.isVariable = false]);

  @override
  PaintFormat get format =>
      isVariable ? PaintFormat.scaleUniformVar : PaintFormat.scaleUniform;

  int paintOffset = 0;
  double scale = 1.0;
  int varIndexBase = 0;
  Paint? paint;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    paintOffset = reader.readUInt24();
    scale = reader.readF2Dot14();
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// PaintScaleUniformAroundCenter
class PaintScaleUniformAroundCenter extends Paint {
  final bool isVariable;

  PaintScaleUniformAroundCenter([this.isVariable = false]);

  @override
  PaintFormat get format => isVariable
      ? PaintFormat.scaleUniformAroundCenterVar
      : PaintFormat.scaleUniformAroundCenter;

  int paintOffset = 0;
  double scale = 1.0;
  int centerX = 0, centerY = 0;
  int varIndexBase = 0;
  Paint? paint;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    paintOffset = reader.readUInt24();
    scale = reader.readF2Dot14();
    centerX = reader.readInt16();
    centerY = reader.readInt16();
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// PaintRotate
class PaintRotate extends Paint {
  final bool isVariable;

  PaintRotate([this.isVariable = false]);

  @override
  PaintFormat get format =>
      isVariable ? PaintFormat.rotateVar : PaintFormat.rotate;

  int paintOffset = 0;
  double angle = 0.0;
  int varIndexBase = 0;
  Paint? paint;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    paintOffset = reader.readUInt24();
    angle = reader.readF2Dot14();
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// PaintRotateAroundCenter
class PaintRotateAroundCenter extends Paint {
  final bool isVariable;

  PaintRotateAroundCenter([this.isVariable = false]);

  @override
  PaintFormat get format => isVariable
      ? PaintFormat.rotateAroundCenterVar
      : PaintFormat.rotateAroundCenter;

  int paintOffset = 0;
  double angle = 0.0;
  int centerX = 0, centerY = 0;
  int varIndexBase = 0;
  Paint? paint;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    paintOffset = reader.readUInt24();
    angle = reader.readF2Dot14();
    centerX = reader.readInt16();
    centerY = reader.readInt16();
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// PaintSkew
class PaintSkew extends Paint {
  final bool isVariable;

  PaintSkew([this.isVariable = false]);

  @override
  PaintFormat get format =>
      isVariable ? PaintFormat.skewVar : PaintFormat.skew;

  int paintOffset = 0;
  double xSkewAngle = 0.0, ySkewAngle = 0.0;
  int varIndexBase = 0;
  Paint? paint;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    paintOffset = reader.readUInt24();
    xSkewAngle = reader.readF2Dot14();
    ySkewAngle = reader.readF2Dot14();
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// PaintSkewAroundCenter
class PaintSkewAroundCenter extends Paint {
  final bool isVariable;

  PaintSkewAroundCenter([this.isVariable = false]);

  @override
  PaintFormat get format => isVariable
      ? PaintFormat.skewAroundCenterVar
      : PaintFormat.skewAroundCenter;

  int paintOffset = 0;
  double xSkewAngle = 0.0, ySkewAngle = 0.0;
  int centerX = 0, centerY = 0;
  int varIndexBase = 0;
  Paint? paint;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    paintOffset = reader.readUInt24();
    xSkewAngle = reader.readF2Dot14();
    ySkewAngle = reader.readF2Dot14();
    centerX = reader.readInt16();
    centerY = reader.readInt16();
    if (isVariable) {
      varIndexBase = reader.readUInt32();
    }
  }
}

/// PaintComposite - combine two paints with a compositing mode
class PaintComposite extends Paint {
  @override
  PaintFormat get format => PaintFormat.composite;

  int sourcePaintOffset = 0;
  CompositeMode compositeMode = CompositeMode.srcOver;
  int backdropPaintOffset = 0;
  Paint? sourcePaint;
  Paint? backdropPaint;

  @override
  void readContent(ByteOrderSwappingBinaryReader reader) {
    sourcePaintOffset = reader.readUInt24();
    compositeMode = CompositeMode.fromValue(reader.readUInt8()) ?? CompositeMode.srcOver;
    backdropPaintOffset = reader.readUInt24();
  }
}

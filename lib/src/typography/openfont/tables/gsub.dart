import '../../../typography/io/byte_order_swapping_reader.dart';
import '../glyph.dart';
import 'class_def_table.dart';
import 'coverage_table.dart';
import 'gdef.dart';
import 'glyph_shaping_table_entry.dart';
import 'i_glyph_index_list.dart';
import 'utils.dart';

typedef GlyphClassResolver = GlyphClassKind Function(int glyphIndex);
typedef GlyphMarkClassResolver = int Function(int glyphIndex);

class GSUB extends GlyphShapingTableEntry {
  static const String _N = "GSUB";
  @override
  String get name => _N;

  List<LookupTable> _lookupList = [];
  List<LookupTable> get lookupList => _lookupList;
  MarkGlyphSetsTable? _markGlyphSets;
  GlyphClassResolver? _glyphClassResolver;
  GlyphMarkClassResolver? _markAttachmentClassResolver;

  @override
  void readLookupTable(
      ByteOrderSwappingBinaryReader reader,
      int lookupTablePos,
      int lookupType,
      int lookupFlags,
      List<int> subTableOffsets,
      int markFilteringSet) {
    final lookupTable = LookupTable(lookupType, lookupFlags, markFilteringSet)
      ..markGlyphSets = _markGlyphSets
      ..glyphClassResolver = _glyphClassResolver
      ..markClassResolver = _markAttachmentClassResolver;
    for (int subTableOffset in subTableOffsets) {
      LookupSubTable subTable =
          lookupTable.readSubTable(reader, lookupTablePos + subTableOffset);
      subTable.ownerGSub = this;
      lookupTable.subTables.add(subTable);
    }

    _lookupList.add(lookupTable);
  }

  @override
  void readFeatureVariations(
      ByteOrderSwappingBinaryReader reader, int featureVariationsBeginAt) {
    Utils.warnUnimplemented("GSUB feature variations");
  }

  void setMarkGlyphSets(MarkGlyphSetsTable? markGlyphSets) {
    _markGlyphSets = markGlyphSets;
    for (final lookup in _lookupList) {
      lookup.markGlyphSets = markGlyphSets;
    }
  }

  void setGlyphClassResolver(GlyphClassResolver? resolver) {
    _glyphClassResolver = resolver;
    for (final lookup in _lookupList) {
      lookup.glyphClassResolver = resolver;
    }
  }

  void setMarkAttachmentClassResolver(GlyphMarkClassResolver? resolver) {
    _markAttachmentClassResolver = resolver;
    for (final lookup in _lookupList) {
      lookup.markClassResolver = resolver;
    }
  }
}

abstract class LookupSubTable {
  GSUB? ownerGSub;

  bool doSubstitutionAt(IGlyphIndexList glyphIndices, int pos, int len);

  void collectAssociatedSubstitutionGlyphs(List<int> outputAssocGlyphs);
}

class UnImplementedLookupSubTable extends LookupSubTable {
  final String _message;
  UnImplementedLookupSubTable(this._message) {
    Utils.warnUnimplemented(_message);
  }

  @override
  String toString() => _message;

  @override
  bool doSubstitutionAt(IGlyphIndexList glyphIndices, int pos, int len) {
    return false;
  }

  @override
  void collectAssociatedSubstitutionGlyphs(List<int> outputAssocGlyphs) {
    Utils.warnUnimplemented("collect-assoc-sub-glyph: $this");
  }
}

class LookupTable {
  int lookupType;
  final int lookupFlags;
  final int markFilteringSet;

  final List<LookupSubTable> _subTables = [];
  List<LookupSubTable> get subTables => _subTables;

  static const int _flagIgnoreBaseGlyphs = 0x0002;
  static const int _flagIgnoreLigatures = 0x0004;
  static const int _flagIgnoreMarks = 0x0008;
  static const int _flagUseMarkFilteringSet = 0x0010;

  MarkGlyphSetsTable? markGlyphSets;
  GlyphClassResolver? glyphClassResolver;
  GlyphMarkClassResolver? markClassResolver;

  LookupTable(this.lookupType, this.lookupFlags, this.markFilteringSet);

  bool doSubstitutionAt(IGlyphIndexList inputGlyphs, int pos, int len) {
    if (!_shouldProcessGlyph(inputGlyphs[pos])) {
      return false;
    }
    for (LookupSubTable subTable in _subTables) {
      // We return after the first substitution, as explained in the spec:
      // "A lookup is finished for a glyph after the client locates the target
      // glyph or glyph context and performs a substitution, if specified."
      if (subTable.doSubstitutionAt(inputGlyphs, pos, len)) {
        return true;
      }
    }
    return false;
  }

  void collectAssociatedSubstitutionGlyph(List<int> outputAssocGlyphs) {
    for (LookupSubTable subTable in _subTables) {
      subTable.collectAssociatedSubstitutionGlyphs(outputAssocGlyphs);
    }
  }

  @override
  String toString() => lookupType.toString();

  LookupSubTable readSubTable(
      ByteOrderSwappingBinaryReader reader, int subTableStartAt) {
    switch (lookupType) {
      case 1:
        return _readLookupType1(reader, subTableStartAt);
      case 2:
        return _readLookupType2(reader, subTableStartAt);
      case 3:
        return _readLookupType3(reader, subTableStartAt);
      case 4:
        return _readLookupType4(reader, subTableStartAt);
      // case 5: return _readLookupType5(reader, subTableStartAt);
      case 6:
        return _readLookupType6(reader, subTableStartAt);
      // case 7: return _readLookupType7(reader, subTableStartAt);
      // case 8: return _readLookupType8(reader, subTableStartAt);
    }
    return UnImplementedLookupSubTable("GSUB Lookup Type $lookupType");
  }

  bool _shouldProcessGlyph(int glyphIndex) {
    final resolver = glyphClassResolver;
    GlyphClassKind? glyphClass;
    if (resolver != null) {
      glyphClass = resolver(glyphIndex);
      if ((lookupFlags & _flagIgnoreBaseGlyphs) != 0 &&
          glyphClass == GlyphClassKind.base) {
        return false;
      }
      if ((lookupFlags & _flagIgnoreLigatures) != 0 &&
          glyphClass == GlyphClassKind.ligature) {
        return false;
      }
      if ((lookupFlags & _flagIgnoreMarks) != 0 &&
          glyphClass == GlyphClassKind.mark) {
        return false;
      }
    }

    if (glyphClass == GlyphClassKind.mark &&
        (lookupFlags & _flagUseMarkFilteringSet) != 0) {
      final markSets = markGlyphSets;
      if (markSets == null ||
          !markSets.containsGlyph(markFilteringSet, glyphIndex)) {
        return false;
      }
    }

    if (glyphClass == GlyphClassKind.mark) {
      final markAttachmentType = (lookupFlags >> 8) & 0xFF;
      if (markAttachmentType != 0) {
        final resolverMark = markClassResolver;
        final glyphMarkClass =
            resolverMark != null ? resolverMark(glyphIndex) : 0;
        if (glyphMarkClass != markAttachmentType) {
          return false;
        }
      }
    }

    return true;
  }

  // LookupType 1: Single Substitution Subtable
  LookupSubTable _readLookupType1(
      ByteOrderSwappingBinaryReader reader, int subTableStartAt) {
    reader.seek(subTableStartAt);
    int format = reader.readUInt16();
    int coverage = reader.readUInt16();

    switch (format) {
      case 1:
        {
          int deltaGlyph = reader.readUInt16();
          CoverageTable coverageTable =
              CoverageTable.createFrom(reader, subTableStartAt + coverage);
          return LkSubTableT1Fmt1(coverageTable, deltaGlyph);
        }
      case 2:
        {
          int glyphCount = reader.readUInt16();
          List<int> substituteGlyphs =
              Utils.readUInt16Array(reader, glyphCount);
          CoverageTable coverageTable =
              CoverageTable.createFrom(reader, subTableStartAt + coverage);
          return LkSubTableT1Fmt2(coverageTable, substituteGlyphs);
        }
      default:
        throw UnsupportedError("LookupType 1 Format $format not supported");
    }
  }

  // LookupType 2: Multiple Substitution Subtable
  LookupSubTable _readLookupType2(
      ByteOrderSwappingBinaryReader reader, int subTableStartAt) {
    reader.seek(subTableStartAt);
    int format = reader.readUInt16();
    switch (format) {
      case 1:
        {
          int coverageOffset = reader.readUInt16();
          int seqCount = reader.readUInt16();
          List<int> seqOffsets = Utils.readUInt16Array(reader, seqCount);

          var subTable = LkSubTableT2();
          subTable.seqTables = List<SequenceTable>.generate(seqCount, (n) {
            reader.seek(subTableStartAt + seqOffsets[n]);
            int glyphCount = reader.readUInt16();
            return SequenceTable(Utils.readUInt16Array(reader, glyphCount));
          });

          subTable.coverageTable = CoverageTable.createFrom(
              reader, subTableStartAt + coverageOffset);
          return subTable;
        }
      default:
        throw UnsupportedError("LookupType 2 Format $format not supported");
    }
  }

  // LookupType 3: Alternate Substitution Subtable
  LookupSubTable _readLookupType3(
      ByteOrderSwappingBinaryReader reader, int subTableStartAt) {
    reader.seek(subTableStartAt);
    int format = reader.readUInt16();
    switch (format) {
      case 1:
        {
          int coverageOffset = reader.readUInt16();
          int alternativeSetCount = reader.readUInt16();
          List<int> alternativeTableOffsets =
              Utils.readUInt16Array(reader, alternativeSetCount);

          var subTable = LkSubTableT3();
          subTable.alternativeSetTables =
              List<AlternativeSetTable>.generate(alternativeSetCount, (n) {
            return AlternativeSetTable.createFrom(
                reader, subTableStartAt + alternativeTableOffsets[n]);
          });

          subTable.coverageTable = CoverageTable.createFrom(
              reader, subTableStartAt + coverageOffset);
          return subTable;
        }
      default:
        throw UnsupportedError("LookupType 3 Format $format not supported");
    }
  }

  // LookupType 4: Ligature Substitution Subtable
  LookupSubTable _readLookupType4(
      ByteOrderSwappingBinaryReader reader, int subTableStartAt) {
    reader.seek(subTableStartAt);
    int format = reader.readUInt16();
    switch (format) {
      case 1:
        {
          int coverageOffset = reader.readUInt16();
          int ligSetCount = reader.readUInt16();
          List<int> ligSetOffsets = Utils.readUInt16Array(reader, ligSetCount);

          var subTable = LkSubTableT4();
          subTable.ligatureSetTables =
              List<LigatureSetTable>.generate(ligSetCount, (n) {
            return LigatureSetTable.createFrom(
                reader, subTableStartAt + ligSetOffsets[n]);
          });

          subTable.coverageTable = CoverageTable.createFrom(
              reader, subTableStartAt + coverageOffset);
          return subTable;
        }
      default:
        throw UnsupportedError("LookupType 4 Format $format not supported");
    }
  }

  // LookupType 6: Chaining Contextual Substitution Subtable
  LookupSubTable _readLookupType6(
      ByteOrderSwappingBinaryReader reader, int subTableStartAt) {
    reader.seek(subTableStartAt);
    int format = reader.readUInt16();
    switch (format) {
      case 1:
        {
          // Format 1: Simple Chaining Context Glyph Substitution
          int coverageOffset = reader.readUInt16();
          int chainSubRuleSetCount = reader.readUInt16();
          List<int> chainSubRuleSetOffsets =
              Utils.readUInt16Array(reader, chainSubRuleSetCount);

          List<ChainSubRuleSetTable?> subRuleSets =
              List<ChainSubRuleSetTable?>.generate(chainSubRuleSetCount, (n) {
            if (chainSubRuleSetOffsets[n] == 0) return null;
            return ChainSubRuleSetTable.createFrom(
                reader, subTableStartAt + chainSubRuleSetOffsets[n]);
          });

          CoverageTable coverageTable = CoverageTable.createFrom(
              reader, subTableStartAt + coverageOffset);
          return LkSubTableT6Fmt1(coverageTable, subRuleSets);
        }
      case 2:
        {
          // Format 2: Class-based Chaining Context Glyph Substitution
          int coverageOffset = reader.readUInt16();
          int backtrackClassDefOffset = reader.readUInt16();
          int inputClassDefOffset = reader.readUInt16();
          int lookaheadClassDefOffset = reader.readUInt16();
          int chainSubClassSetCount = reader.readUInt16();
          List<int> chainSubClassSetOffsets =
              Utils.readUInt16Array(reader, chainSubClassSetCount);

          ClassDefTable backtrackClassDef = ClassDefTable.createFrom(
              reader, subTableStartAt + backtrackClassDefOffset);
          ClassDefTable inputClassDef = ClassDefTable.createFrom(
              reader, subTableStartAt + inputClassDefOffset);
          ClassDefTable lookaheadClassDef = ClassDefTable.createFrom(
              reader, subTableStartAt + lookaheadClassDefOffset);

          List<ChainSubClassSet?> chainSubClassSets =
              List<ChainSubClassSet?>.generate(chainSubClassSetCount, (n) {
            if (chainSubClassSetOffsets[n] == 0) return null;
            return ChainSubClassSet.createFrom(
                reader, subTableStartAt + chainSubClassSetOffsets[n]);
          });

          CoverageTable coverageTable = CoverageTable.createFrom(
              reader, subTableStartAt + coverageOffset);
          return LkSubTableT6Fmt2(coverageTable, backtrackClassDef,
              inputClassDef, lookaheadClassDef, chainSubClassSets);
        }
      case 3:
        {
          // Format 3: Coverage-based Chaining Context Glyph Substitution
          int backtrackGlyphCount = reader.readUInt16();
          List<int> backtrackCoverageOffsets =
              Utils.readUInt16Array(reader, backtrackGlyphCount);
          int inputGlyphCount = reader.readUInt16();
          List<int> inputCoverageOffsets =
              Utils.readUInt16Array(reader, inputGlyphCount);
          int lookaheadGlyphCount = reader.readUInt16();
          List<int> lookaheadCoverageOffsets =
              Utils.readUInt16Array(reader, lookaheadGlyphCount);
          int substCount = reader.readUInt16();
          List<SubstLookupRecord> substLookupRecords =
              SubstLookupRecord.readRecords(reader, substCount);

          List<CoverageTable> backtrackCoverages =
              List<CoverageTable>.generate(backtrackGlyphCount, (i) {
            return CoverageTable.createFrom(
                reader, subTableStartAt + backtrackCoverageOffsets[i]);
          });
          List<CoverageTable> inputCoverages =
              List<CoverageTable>.generate(inputGlyphCount, (i) {
            return CoverageTable.createFrom(
                reader, subTableStartAt + inputCoverageOffsets[i]);
          });
          List<CoverageTable> lookaheadCoverages =
              List<CoverageTable>.generate(lookaheadGlyphCount, (i) {
            return CoverageTable.createFrom(
                reader, subTableStartAt + lookaheadCoverageOffsets[i]);
          });

          return LkSubTableT6Fmt3(backtrackCoverages, inputCoverages,
              lookaheadCoverages, substLookupRecords);
        }
      default:
        return UnImplementedLookupSubTable("GSUB Lookup Type 6 Format $format");
    }
  }
}

// --- SubTable Implementations ---

class LkSubTableT1Fmt1 extends LookupSubTable {
  final CoverageTable coverageTable;
  final int deltaGlyph;

  LkSubTableT1Fmt1(this.coverageTable, this.deltaGlyph);

  @override
  bool doSubstitutionAt(IGlyphIndexList glyphIndices, int pos, int len) {
    int glyphIndex = glyphIndices[pos];
    if (coverageTable.findPosition(glyphIndex) > -1) {
      glyphIndices.replace(pos, (glyphIndex + deltaGlyph) & 0xFFFF);
      return true;
    }
    return false;
  }

  @override
  void collectAssociatedSubstitutionGlyphs(List<int> outputAssocGlyphs) {
    for (int glyphIndex in coverageTable.getExpandedValueIter()) {
      outputAssocGlyphs.add((glyphIndex + deltaGlyph) & 0xFFFF);
    }
  }
}

class LkSubTableT1Fmt2 extends LookupSubTable {
  final CoverageTable coverageTable;
  final List<int> substituteGlyphs;

  LkSubTableT1Fmt2(this.coverageTable, this.substituteGlyphs);

  @override
  bool doSubstitutionAt(IGlyphIndexList glyphIndices, int pos, int len) {
    int foundAt = coverageTable.findPosition(glyphIndices[pos]);
    if (foundAt > -1) {
      glyphIndices.replace(pos, substituteGlyphs[foundAt]);
      return true;
    }
    return false;
  }

  @override
  void collectAssociatedSubstitutionGlyphs(List<int> outputAssocGlyphs) {
    for (int glyphIndex in coverageTable.getExpandedValueIter()) {
      int foundAt = coverageTable.findPosition(glyphIndex);
      outputAssocGlyphs.add(substituteGlyphs[foundAt]);
    }
  }
}

class LkSubTableT2 extends LookupSubTable {
  late CoverageTable coverageTable;
  late List<SequenceTable> seqTables;

  @override
  bool doSubstitutionAt(IGlyphIndexList glyphIndices, int pos, int len) {
    int foundPos = coverageTable.findPosition(glyphIndices[pos]);
    if (foundPos > -1) {
      SequenceTable seqTable = seqTables[foundPos];
      glyphIndices.replaceWithMultiple(pos, seqTable.substituteGlyphs);
      return true;
    }
    return false;
  }

  @override
  void collectAssociatedSubstitutionGlyphs(List<int> outputAssocGlyphs) {
    for (int glyphIndex in coverageTable.getExpandedValueIter()) {
      int pos = coverageTable.findPosition(glyphIndex);
      outputAssocGlyphs.addAll(seqTables[pos].substituteGlyphs);
    }
  }
}

class SequenceTable {
  final List<int> substituteGlyphs;
  SequenceTable(this.substituteGlyphs);
}

class LkSubTableT3 extends LookupSubTable {
  late CoverageTable coverageTable;
  late List<AlternativeSetTable> alternativeSetTables;

  @override
  bool doSubstitutionAt(IGlyphIndexList glyphIndices, int pos, int len) {
    // int iscovered = coverageTable.findPosition(glyphIndices[pos]);
    Utils.warnUnimplemented("Lookup Subtable Type 3");
    return false;
  }

  @override
  void collectAssociatedSubstitutionGlyphs(List<int> outputAssocGlyphs) {
    Utils.warnUnimplemented("collect-assoc-sub-glyph: $this");
  }
}

class AlternativeSetTable {
  late List<int> alternativeGlyphIds;

  static AlternativeSetTable createFrom(
      ByteOrderSwappingBinaryReader reader, int beginAt) {
    reader.seek(beginAt);
    var altTable = AlternativeSetTable();
    int glyphCount = reader.readUInt16();
    altTable.alternativeGlyphIds = Utils.readUInt16Array(reader, glyphCount);
    return altTable;
  }
}

class LkSubTableT4 extends LookupSubTable {
  late CoverageTable coverageTable;
  late List<LigatureSetTable> ligatureSetTables;

  @override
  bool doSubstitutionAt(IGlyphIndexList glyphIndices, int pos, int len) {
    //check coverage
    int glyphIndex = glyphIndices[pos];
    int foundPos = coverageTable.findPosition(glyphIndex);
    if (foundPos > -1) {
      LigatureSetTable ligTable = ligatureSetTables[foundPos];
      for (LigatureTable lig in ligTable.ligatures) {
        int remainingLen = len - 1;
        int compLen = lig.componentGlyphs.length;
        if (compLen > remainingLen) {
          // skip tp next component
          continue;
        }
        bool allMatched = true;
        int tmp_i = pos + 1;
        for (int p = 0; p < compLen; ++p) {
          if (glyphIndices[tmp_i + p] != lig.componentGlyphs[p]) {
            allMatched = false;
            break; //exit from loop
          }
        }
        if (allMatched) {
          // remove all matches and replace with selected glyph
          // replaceRange(index, removeLen, newGlyph)
          // removeLen is compLen (components after first) + 1 (first glyph) - wait.
          // Ligature components start with second component.
          // So total glyphs to replace = 1 (first) + compLen.
          // Wait, replaceRange takes removeLen.
          // If compLen is number of components AFTER first, then total to remove is 1 + compLen.
          // But `compLen` here is `lig.componentGlyphs.length`.
          // `lig.componentGlyphs` array of component GlyphIDs-start with the second component.
          // So yes, total removed is 1 + compLen.

          glyphIndices.replaceRange(pos, compLen + 1, lig.glyphId);
          return true;
        }
      }
    }
    return false;
  }

  @override
  void collectAssociatedSubstitutionGlyphs(List<int> outputAssocGlyphs) {
    for (int glyphIndex in coverageTable.getExpandedValueIter()) {
      int foundPos = coverageTable.findPosition(glyphIndex);
      LigatureSetTable ligTable = ligatureSetTables[foundPos];
      for (LigatureTable lig in ligTable.ligatures) {
        outputAssocGlyphs.add(lig.glyphId);
      }
    }
  }
}

class LigatureSetTable {
  late List<LigatureTable> ligatures;

  static LigatureSetTable createFrom(
      ByteOrderSwappingBinaryReader reader, int beginAt) {
    var ligSetTable = LigatureSetTable();
    reader.seek(beginAt);
    int ligCount = reader.readUInt16();
    List<int> ligOffsets = Utils.readUInt16Array(reader, ligCount);

    ligSetTable.ligatures = List<LigatureTable>.generate(ligCount, (i) {
      return LigatureTable.createFrom(reader, beginAt + ligOffsets[i]);
    });
    return ligSetTable;
  }
}

class LigatureTable {
  late int glyphId;
  late List<int> componentGlyphs;

  static LigatureTable createFrom(
      ByteOrderSwappingBinaryReader reader, int beginAt) {
    reader.seek(beginAt);
    var ligTable = LigatureTable();
    ligTable.glyphId = reader.readUInt16();
    int compCount = reader.readUInt16();
    ligTable.componentGlyphs = Utils.readUInt16Array(reader, compCount - 1);
    return ligTable;
  }

  @override
  String toString() {
    return "output:$glyphId,{${componentGlyphs.join(',')}}";
  }
}

// --- LookupType 6: Chaining Contextual Substitution ---

/// SubstLookupRecord specifies a position in the input sequence and a lookup
/// to apply at that position.
class SubstLookupRecord {
  final int sequenceIndex;
  final int lookupListIndex;
  SubstLookupRecord(this.sequenceIndex, this.lookupListIndex);

  static List<SubstLookupRecord> readRecords(
      ByteOrderSwappingBinaryReader reader, int count) {
    return List<SubstLookupRecord>.generate(count, (_) {
      return SubstLookupRecord(reader.readUInt16(), reader.readUInt16());
    });
  }
}

/// ChainSubRuleSubTable: Context definition for a single rule in Format 1
class ChainSubRuleSubTable {
  final List<int> backtrackGlyphs;
  final List<int> inputGlyphs;
  final List<int> lookaheadGlyphs;
  final List<SubstLookupRecord> substLookupRecords;

  ChainSubRuleSubTable(this.backtrackGlyphs, this.inputGlyphs,
      this.lookaheadGlyphs, this.substLookupRecords);

  static ChainSubRuleSubTable createFrom(
      ByteOrderSwappingBinaryReader reader, int beginAt) {
    reader.seek(beginAt);
    int backtrackCount = reader.readUInt16();
    List<int> backtrackGlyphs = Utils.readUInt16Array(reader, backtrackCount);
    int inputCount = reader.readUInt16();
    // Input starts with second glyph, so -1
    List<int> inputGlyphs = Utils.readUInt16Array(reader, inputCount - 1);
    int lookaheadCount = reader.readUInt16();
    List<int> lookaheadGlyphs = Utils.readUInt16Array(reader, lookaheadCount);
    int substCount = reader.readUInt16();
    List<SubstLookupRecord> substRecords =
        SubstLookupRecord.readRecords(reader, substCount);
    return ChainSubRuleSubTable(
        backtrackGlyphs, inputGlyphs, lookaheadGlyphs, substRecords);
  }
}

/// ChainSubRuleSetTable: All contexts beginning with the same glyph
class ChainSubRuleSetTable {
  final List<ChainSubRuleSubTable> chainSubRuleSubTables;

  ChainSubRuleSetTable(this.chainSubRuleSubTables);

  static ChainSubRuleSetTable createFrom(
      ByteOrderSwappingBinaryReader reader, int beginAt) {
    reader.seek(beginAt);
    int subRuleCount = reader.readUInt16();
    List<int> subRuleOffsets = Utils.readUInt16Array(reader, subRuleCount);
    List<ChainSubRuleSubTable> chainSubRuleTables =
        List<ChainSubRuleSubTable>.generate(subRuleCount, (i) {
      return ChainSubRuleSubTable.createFrom(
          reader, beginAt + subRuleOffsets[i]);
    });
    return ChainSubRuleSetTable(chainSubRuleTables);
  }
}

/// ChainSubClassRuleTable: Chaining context definition for one class (Format 2)
class ChainSubClassRuleTable {
  final List<int> backtrackClassIds;
  final List<int> inputClassIds;
  final List<int> lookaheadClassIds;
  final List<SubstLookupRecord> substLookupRecords;

  ChainSubClassRuleTable(this.backtrackClassIds, this.inputClassIds,
      this.lookaheadClassIds, this.substLookupRecords);

  static ChainSubClassRuleTable createFrom(
      ByteOrderSwappingBinaryReader reader, int beginAt) {
    reader.seek(beginAt);
    int backtrackCount = reader.readUInt16();
    List<int> backtrackClassIds = Utils.readUInt16Array(reader, backtrackCount);
    int inputCount = reader.readUInt16();
    // Input starts with second class, so -1
    List<int> inputClassIds = Utils.readUInt16Array(reader, inputCount - 1);
    int lookaheadCount = reader.readUInt16();
    List<int> lookaheadClassIds = Utils.readUInt16Array(reader, lookaheadCount);
    int substCount = reader.readUInt16();
    List<SubstLookupRecord> substRecords =
        SubstLookupRecord.readRecords(reader, substCount);
    return ChainSubClassRuleTable(
        backtrackClassIds, inputClassIds, lookaheadClassIds, substRecords);
  }
}

/// ChainSubClassSet: Set of chaining context class rules
class ChainSubClassSet {
  final List<ChainSubClassRuleTable> subClassRuleTables;

  ChainSubClassSet(this.subClassRuleTables);

  static ChainSubClassSet? createFrom(
      ByteOrderSwappingBinaryReader reader, int beginAt) {
    if (beginAt == 0) return null; // Null offset
    reader.seek(beginAt);
    int count = reader.readUInt16();
    List<int> offsets = Utils.readUInt16Array(reader, count);
    List<ChainSubClassRuleTable> rules =
        List<ChainSubClassRuleTable>.generate(count, (i) {
      return ChainSubClassRuleTable.createFrom(reader, beginAt + offsets[i]);
    });
    return ChainSubClassSet(rules);
  }
}

/// LkSubTableT6Fmt1: Chaining Context Substitution Format 1 (Simple Glyph Context)
class LkSubTableT6Fmt1 extends LookupSubTable {
  final CoverageTable coverageTable;
  final List<ChainSubRuleSetTable?> subRuleSets;

  LkSubTableT6Fmt1(this.coverageTable, this.subRuleSets);

  @override
  bool doSubstitutionAt(IGlyphIndexList glyphIndices, int pos, int len) {
    int glyphIndex = glyphIndices[pos];
    int coverageIndex = coverageTable.findPosition(glyphIndex);
    if (coverageIndex < 0) return false;

    ChainSubRuleSetTable? ruleSet = subRuleSets[coverageIndex];
    if (ruleSet == null) return false;

    for (ChainSubRuleSubTable rule in ruleSet.chainSubRuleSubTables) {
      // Check backtrack sequence (in reverse order)
      bool match = true;
      for (int i = 0; i < rule.backtrackGlyphs.length; i++) {
        int checkPos = pos - 1 - i;
        if (checkPos < 0 || glyphIndices[checkPos] != rule.backtrackGlyphs[i]) {
          match = false;
          break;
        }
      }
      if (!match) continue;

      // Check input sequence (starting from second glyph)
      for (int i = 0; i < rule.inputGlyphs.length; i++) {
        int checkPos = pos + 1 + i;
        if (checkPos >= pos + len ||
            glyphIndices[checkPos] != rule.inputGlyphs[i]) {
          match = false;
          break;
        }
      }
      if (!match) continue;

      // Check lookahead sequence
      int inputLength = 1 + rule.inputGlyphs.length;
      for (int i = 0; i < rule.lookaheadGlyphs.length; i++) {
        int checkPos = pos + inputLength + i;
        if (checkPos >= glyphIndices.count ||
            glyphIndices[checkPos] != rule.lookaheadGlyphs[i]) {
          match = false;
          break;
        }
      }
      if (!match) continue;

      // Match found! Apply substitutions
      bool hasChanged = false;
      for (SubstLookupRecord record in rule.substLookupRecords) {
        LookupTable lookup = ownerGSub!.lookupList[record.lookupListIndex];
        if (lookup.doSubstitutionAt(glyphIndices, pos + record.sequenceIndex,
            len - record.sequenceIndex)) {
          hasChanged = true;
        }
      }
      return hasChanged;
    }
    return false;
  }

  @override
  void collectAssociatedSubstitutionGlyphs(List<int> outputAssocGlyphs) {
    for (ChainSubRuleSetTable? ruleSet in subRuleSets) {
      if (ruleSet == null) continue;
      for (ChainSubRuleSubTable rule in ruleSet.chainSubRuleSubTables) {
        for (SubstLookupRecord record in rule.substLookupRecords) {
          LookupTable lookup = ownerGSub!.lookupList[record.lookupListIndex];
          lookup.collectAssociatedSubstitutionGlyph(outputAssocGlyphs);
        }
      }
    }
  }
}

/// LkSubTableT6Fmt2: Chaining Context Substitution Format 2 (Class-based)
class LkSubTableT6Fmt2 extends LookupSubTable {
  final CoverageTable coverageTable;
  final ClassDefTable backtrackClassDef;
  final ClassDefTable inputClassDef;
  final ClassDefTable lookaheadClassDef;
  final List<ChainSubClassSet?> chainSubClassSets;

  LkSubTableT6Fmt2(this.coverageTable, this.backtrackClassDef,
      this.inputClassDef, this.lookaheadClassDef, this.chainSubClassSets);

  @override
  bool doSubstitutionAt(IGlyphIndexList glyphIndices, int pos, int len) {
    int glyphIndex = glyphIndices[pos];
    int coverageIndex = coverageTable.findPosition(glyphIndex);
    if (coverageIndex < 0) return false;

    int classId = inputClassDef.getClassValue(glyphIndex);
    if (classId < 0 || classId >= chainSubClassSets.length) return false;

    ChainSubClassSet? classSet = chainSubClassSets[classId];
    if (classSet == null) return false;

    for (ChainSubClassRuleTable rule in classSet.subClassRuleTables) {
      // Check backtrack sequence (in reverse order)
      bool match = true;
      for (int i = 0; i < rule.backtrackClassIds.length; i++) {
        int checkPos = pos - 1 - i;
        if (checkPos < 0) {
          match = false;
          break;
        }
        int gid = glyphIndices[checkPos];
        int cls = backtrackClassDef.getClassValue(gid);
        if (cls != rule.backtrackClassIds[i]) {
          match = false;
          break;
        }
      }
      if (!match) continue;

      // Check input sequence (starting from second glyph)
      for (int i = 0; i < rule.inputClassIds.length; i++) {
        int checkPos = pos + 1 + i;
        if (checkPos >= pos + len) {
          match = false;
          break;
        }
        int gid = glyphIndices[checkPos];
        int cls = inputClassDef.getClassValue(gid);
        if (cls != rule.inputClassIds[i]) {
          match = false;
          break;
        }
      }
      if (!match) continue;

      // Check lookahead sequence
      int inputLength = 1 + rule.inputClassIds.length;
      for (int i = 0; i < rule.lookaheadClassIds.length; i++) {
        int checkPos = pos + inputLength + i;
        if (checkPos >= glyphIndices.count) {
          match = false;
          break;
        }
        int gid = glyphIndices[checkPos];
        int cls = lookaheadClassDef.getClassValue(gid);
        if (cls != rule.lookaheadClassIds[i]) {
          match = false;
          break;
        }
      }
      if (!match) continue;

      // Match found! Apply substitutions
      bool hasChanged = false;
      for (SubstLookupRecord record in rule.substLookupRecords) {
        LookupTable lookup = ownerGSub!.lookupList[record.lookupListIndex];
        if (lookup.doSubstitutionAt(glyphIndices, pos + record.sequenceIndex,
            len - record.sequenceIndex)) {
          hasChanged = true;
        }
      }
      return hasChanged;
    }
    return false;
  }

  @override
  void collectAssociatedSubstitutionGlyphs(List<int> outputAssocGlyphs) {
    for (ChainSubClassSet? classSet in chainSubClassSets) {
      if (classSet == null) continue;
      for (ChainSubClassRuleTable rule in classSet.subClassRuleTables) {
        for (SubstLookupRecord record in rule.substLookupRecords) {
          LookupTable lookup = ownerGSub!.lookupList[record.lookupListIndex];
          lookup.collectAssociatedSubstitutionGlyph(outputAssocGlyphs);
        }
      }
    }
  }
}

/// LkSubTableT6Fmt3: Chaining Context Substitution Format 3 (Coverage-based)
class LkSubTableT6Fmt3 extends LookupSubTable {
  final List<CoverageTable> backtrackCoverages;
  final List<CoverageTable> inputCoverages;
  final List<CoverageTable> lookaheadCoverages;
  final List<SubstLookupRecord> substLookupRecords;

  LkSubTableT6Fmt3(this.backtrackCoverages, this.inputCoverages,
      this.lookaheadCoverages, this.substLookupRecords);

  @override
  bool doSubstitutionAt(IGlyphIndexList glyphIndices, int pos, int len) {
    int inputLength = inputCoverages.length;

    // Check that there are enough context glyphs
    if (pos < backtrackCoverages.length ||
        inputLength + lookaheadCoverages.length > len) {
      return false;
    }

    // Check input coverages
    for (int i = 0; i < inputCoverages.length; i++) {
      if (inputCoverages[i].findPosition(glyphIndices[pos + i]) < 0) {
        return false;
      }
    }

    // Check backtrack coverages (in reverse order)
    for (int i = 0; i < backtrackCoverages.length; i++) {
      if (backtrackCoverages[i].findPosition(glyphIndices[pos - 1 - i]) < 0) {
        return false;
      }
    }

    // Check lookahead coverages
    for (int i = 0; i < lookaheadCoverages.length; i++) {
      if (lookaheadCoverages[i]
              .findPosition(glyphIndices[pos + inputLength + i]) <
          0) {
        return false;
      }
    }

    // Match found! Apply substitutions
    bool hasChanged = false;
    for (SubstLookupRecord record in substLookupRecords) {
      LookupTable lookup = ownerGSub!.lookupList[record.lookupListIndex];
      if (lookup.doSubstitutionAt(glyphIndices, pos + record.sequenceIndex,
          len - record.sequenceIndex)) {
        hasChanged = true;
      }
    }
    return hasChanged;
  }

  @override
  void collectAssociatedSubstitutionGlyphs(List<int> outputAssocGlyphs) {
    for (SubstLookupRecord record in substLookupRecords) {
      LookupTable lookup = ownerGSub!.lookupList[record.lookupListIndex];
      lookup.collectAssociatedSubstitutionGlyph(outputAssocGlyphs);
    }
  }
}

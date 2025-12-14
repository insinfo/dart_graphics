
/// Represents a script/language combination used in OpenType layout.
class ScriptLang {
  final String fullname;
  final String shortname;
  final int internalName;

  const ScriptLang(this.fullname, this.shortname, this.internalName);

  @override
  String toString() => fullname;
}

/// Extension to convert UnicodeLangBits to UnicodeRangeInfo.
extension UnicodeLangBitsExtension on UnicodeLangBits {
  UnicodeRangeInfo toUnicodeRangeInfo() {
    final bits = index;
    final bitpos = (bits >> 32).toInt();
    final lower32 = bits & 0xFFFFFFFF;
    return UnicodeRangeInfo(
      bitpos,
      ((lower32 >> 16) & 0xFFFF).toInt(),
      (lower32 & 0xFFFF).toInt(),
    );
  }
}

/// Unicode range information.
class UnicodeRangeInfo {
  final int bitNo;
  final int startAt;
  final int endAt;

  const UnicodeRangeInfo(this.bitNo, this.startAt, this.endAt);

  bool isInRange(int value) => value >= startAt && value <= endAt;

  @override
  String toString() => '$bitNo,[$startAt,$endAt]';
}

/// Unicode language bits - encodes bit position and Unicode range.
/// Format: (bitNo << 32) | (startAt << 16) | endAt
enum UnicodeLangBits {
  unset(0),

  // Bit 0: Basic Latin 0000-007F
  basicLatin((0 << 32) | (0x0000 << 16) | 0x007F),
  // Bit 1: Latin-1 Supplement 0080-00FF
  latin1Supplement((1 << 32) | (0x0080 << 16) | 0x00FF),
  // Bit 2: Latin Extended-A 0100-017F
  latinExtendedA((2 << 32) | (0x0100 << 16) | 0x017F),
  // Bit 3: Latin Extended-B 0180-024F
  latinExtendedB((3 << 32) | (0x0180 << 16) | 0x024F),

  // Bit 4: IPA Extensions
  ipaExtensions((4 << 32) | (0x0250 << 16) | 0x02AF),
  phoneticExtensions((4 << 32) | (0x1D00 << 16) | 0x1D7F),
  phoneticExtensionsSupplement((4 << 32) | (0x1D80 << 16) | 0x1DBF),

  // Bit 5: Spacing Modifier Letters
  spacingModifierLetters((5 << 32) | (0x02B0 << 16) | 0x02FF),
  modifierToneLetters((5 << 32) | (0xA700 << 16) | 0xA71F),

  // Bit 6: Combining Diacritical Marks
  combiningDiacriticalMarks((6 << 32) | (0x0300 << 16) | 0x036F),
  combiningDiacriticalMarksSupplement((6 << 32) | (0x1DC0 << 16) | 0x1DFF),

  // Bit 7: Greek and Coptic
  greekAndCoptic((7 << 32) | (0x0370 << 16) | 0x03FF),

  // Bit 8: Coptic
  coptic((8 << 32) | (0x2C80 << 16) | 0x2CFF),

  // Bit 9: Cyrillic
  cyrillic((9 << 32) | (0x0400 << 16) | 0x04FF),
  cyrillicExtendedA((9 << 32) | (0x2DE0 << 16) | 0x2DFF),
  cyrillicExtendedB((9 << 32) | (0xA640 << 16) | 0xA69F),

  // Bit 10: Armenian
  armenian((10 << 32) | (0x0530 << 16) | 0x058F),

  // Bit 11: Hebrew
  hebrew((11 << 32) | (0x0590 << 16) | 0x05FF),

  // Bit 12: Vai
  vai((12 << 32) | (0xA500 << 16) | 0xA63F),

  // Bit 13: Arabic
  arabic((13 << 32) | (0x0600 << 16) | 0x06FF),
  arabicSupplement((13 << 32) | (0x0750 << 16) | 0x077F),

  // Bit 14: NKo
  nko((14 << 32) | (0x07C0 << 16) | 0x07FF),

  // Bit 15: Devanagari
  devanagari((15 << 32) | (0x0900 << 16) | 0x097F),

  // Bit 16: Bengali
  bengali((16 << 32) | (0x0980 << 16) | 0x09FF),

  // Bit 17: Gurmukhi
  gurmukhi((17 << 32) | (0x0A00 << 16) | 0x0A7F),

  // Bit 18: Gujarati
  gujarati((18 << 32) | (0x0A80 << 16) | 0x0AFF),

  // Bit 19: Oriya
  oriya((19 << 32) | (0x0B00 << 16) | 0x0B7F),

  // Bit 20: Tamil
  tamil((20 << 32) | (0x0B80 << 16) | 0x0BFF),

  // Bit 21: Telugu
  telugu((21 << 32) | (0x0C00 << 16) | 0x0C7F),

  // Bit 22: Kannada
  kannada((22 << 32) | (0x0C80 << 16) | 0x0CFF),

  // Bit 23: Malayalam
  malayalam((23 << 32) | (0x0D00 << 16) | 0x0D7F),

  // Bit 24: Thai
  thai((24 << 32) | (0x0E00 << 16) | 0x0E7F),

  // Bit 25: Lao
  lao((25 << 32) | (0x0E80 << 16) | 0x0EFF),

  // Bit 26: Georgian
  georgian((26 << 32) | (0x10A0 << 16) | 0x10FF),
  georgianSupplement((26 << 32) | (0x2D00 << 16) | 0x2D2F),

  // Bit 27: Balinese
  balinese((27 << 32) | (0x1B00 << 16) | 0x1B7F),

  // Bit 28: Hangul Jamo
  hangulJamo((28 << 32) | (0x1100 << 16) | 0x11FF),

  // Bit 29: Latin Extended Additional
  latinExtendedAdditional((29 << 32) | (0x1E00 << 16) | 0x1EFF),
  latinExtendedAdditionalC((29 << 32) | (0x2C60 << 16) | 0x2C7F),
  latinExtendedAdditionalD((29 << 32) | (0xA720 << 16) | 0xA7FF),

  // Bit 30: Greek Extended
  greekExtended((30 << 32) | (0x1F00 << 16) | 0x1FFF),

  // Bit 31: General Punctuation
  generalPunctuation((31 << 32) | (0x2000 << 16) | 0x206F),
  supplementPunctuation((31 << 32) | (0x2E00 << 16) | 0x2E7F),

  // Bit 32: Superscripts And Subscripts
  superscriptsAndSubscripts((32 << 32) | (0x2070 << 16) | 0x209F),

  // Bit 33: Currency Symbols
  currencySymbols((33 << 32) | (0x20A0 << 16) | 0x20CF),

  // Bit 34: Combining Diacritical Marks For Symbols
  combiningDiacriticalMarksForSymbols((34 << 32) | (0x20D0 << 16) | 0x20FF),

  // Bit 35: Letterlike Symbols
  letterlikeSymbols((35 << 32) | (0x2100 << 16) | 0x214F),

  // Bit 36: Number Forms
  numberForms((36 << 32) | (0x2150 << 16) | 0x218F),

  // Bit 37: Arrows
  arrows((37 << 32) | (0x2190 << 16) | 0x21FF),
  supplementalArrowsA((37 << 32) | (0x27F0 << 16) | 0x27FF),
  supplementalArrowsB((37 << 32) | (0x2900 << 16) | 0x297F),
  miscellaneousSymbolsAndArrows((37 << 32) | (0x2B00 << 16) | 0x2BFF),

  // Bit 38: Mathematical Operators
  mathematicalOperators((38 << 32) | (0x2200 << 16) | 0x22FF),
  supplementalMathematicalOperators((38 << 32) | (0x2A00 << 16) | 0x2AFF),
  miscellaneousMathematicalSymbolsA((38 << 32) | (0x27C0 << 16) | 0x27EF),
  miscellaneousMathematicalSymbolsB((38 << 32) | (0x2980 << 16) | 0x29FF),

  // Bit 39: Miscellaneous Technical
  miscellaneousTechnical((39 << 32) | (0x2300 << 16) | 0x23FF),

  // Bit 40: Control Pictures
  controlPictures((40 << 32) | (0x2400 << 16) | 0x243F),

  // Bit 41: Optical Character Recognition
  opticalCharacterRecognition((41 << 32) | (0x2440 << 16) | 0x245F),

  // Bit 42: Enclosed Alphanumerics
  enclosedAlphanumerics((42 << 32) | (0x2460 << 16) | 0x24FF),

  // Bit 43: Box Drawing
  boxDrawing((43 << 32) | (0x2500 << 16) | 0x257F),

  // Bit 44: Block Elements
  blockElements((44 << 32) | (0x2580 << 16) | 0x259F),

  // Bit 45: Geometric Shapes
  geometricShapes((45 << 32) | (0x25A0 << 16) | 0x25FF),

  // Bit 46: Miscellaneous Symbols
  miscellaneousSymbols((46 << 32) | (0x2600 << 16) | 0x26FF),

  // Bit 47: Dingbats
  dingbats((47 << 32) | (0x2700 << 16) | 0x27BF),

  // Bit 48: CJK Symbols And Punctuation
  cjkSymbolsAndPunctuation((48 << 32) | (0x3000 << 16) | 0x303F),

  // Bit 49: Hiragana
  hiragana((49 << 32) | (0x3040 << 16) | 0x309F),

  // Bit 50: Katakana
  katakana((50 << 32) | (0x30A0 << 16) | 0x30FF),
  katakanaPhoneticExtensions((50 << 32) | (0x31F0 << 16) | 0x31FF),

  // Bit 51: Bopomofo
  bopomofo((51 << 32) | (0x3100 << 16) | 0x312F),
  bopomofoExtended((51 << 32) | (0x31A0 << 16) | 0x31BF),

  // Bit 52: Hangul Compatibility Jamo
  hangulCompatibilityJamo((52 << 32) | (0x3130 << 16) | 0x318F),

  // Bit 53: Phags-pa
  phagsPa((53 << 32) | (0xA840 << 16) | 0xA87F),

  // Bit 54: Enclosed CJK Letters And Months
  enclosedCjkLettersAndMonths((54 << 32) | (0x3200 << 16) | 0x32FF),

  // Bit 55: CJK Compatibility
  cjkCompatibility((55 << 32) | (0x3300 << 16) | 0x33FF),

  // Bit 56: Hangul Syllables
  hangulSyllables((56 << 32) | (0xAC00 << 16) | 0xD7AF),

  // Bit 57: Non-Plane 0
  nonPlane0((57 << 32) | (0xD800 << 16) | 0xDFFF),

  // Bit 58: Phoenician
  phoenician((58 << 32) | (0x10900 << 16) | 0x1091F),

  // Bit 59: CJK Unified Ideographs
  cjkUnifiedIdeographs((59 << 32) | (0x4E00 << 16) | 0x9FFF),
  cjkRadicalsSupplement((59 << 32) | (0x2E80 << 16) | 0x2EFF),
  kangxiRadicals((59 << 32) | (0x2F00 << 16) | 0x2FDF),
  ideographicDescriptionCharacters((59 << 32) | (0x2FF0 << 16) | 0x2FFF),
  cjkUnifiedIdeographsExtensionA((59 << 32) | (0x3400 << 16) | 0x4DBF),
  kanbun((59 << 32) | (0x3190 << 16) | 0x319F),

  // Bit 60: Private Use Area (plane 0)
  privateUseAreaPlane0((60 << 32) | (0xE000 << 16) | 0xF8FF),

  // Bit 61: CJK Strokes
  cjkStrokes((61 << 32) | (0x31C0 << 16) | 0x31EF),
  cjkCompatibilityIdeographs((61 << 32) | (0xF900 << 16) | 0xFAFF),

  // Bit 62: Alphabetic Presentation Forms
  alphabeticPresentationForms((62 << 32) | (0xFB00 << 16) | 0xFB4F),

  // Bit 63: Arabic Presentation Forms-A
  arabicPresentationFormsA((63 << 32) | (0xFB50 << 16) | 0xFDFF),

  // Bit 64: Combining Half Marks
  combiningHalfMarks((64 << 32) | (0xFE20 << 16) | 0xFE2F),

  // Bit 65: Vertical Forms
  verticalForms((65 << 32) | (0xFE10 << 16) | 0xFE1F),
  cjkCompatibilityForms((65 << 32) | (0xFE30 << 16) | 0xFE4F),

  // Bit 66: Small Form Variants
  smallFormVariants((66 << 32) | (0xFE50 << 16) | 0xFE6F),

  // Bit 67: Arabic Presentation Forms-B
  arabicPresentationFormsB((67 << 32) | (0xFE70 << 16) | 0xFEFF),

  // Bit 68: Halfwidth And Fullwidth Forms
  halfwidthAndFullwidthForms((68 << 32) | (0xFF00 << 16) | 0xFFEF),

  // Bit 69: Specials
  specials((69 << 32) | (0xFFF0 << 16) | 0xFFFF),

  // Bit 70: Tibetan
  tibetan((70 << 32) | (0x0F00 << 16) | 0x0FFF),

  // Bit 71: Syriac
  syriac((71 << 32) | (0x0700 << 16) | 0x074F),

  // Bit 72: Thaana
  thaana((72 << 32) | (0x0780 << 16) | 0x07BF),

  // Bit 73: Sinhala
  sinhala((73 << 32) | (0x0D80 << 16) | 0x0DFF),

  // Bit 74: Myanmar
  myanmar((74 << 32) | (0x1000 << 16) | 0x109F),

  // Bit 75: Ethiopic
  ethiopic((75 << 32) | (0x1200 << 16) | 0x137F),
  ethiopicSupplement((75 << 32) | (0x1380 << 16) | 0x139F),
  ethiopicExtended((75 << 32) | (0x2D80 << 16) | 0x2DDF),

  // Bit 76: Cherokee
  cherokee((76 << 32) | (0x13A0 << 16) | 0x13FF),

  // Bit 77: Unified Canadian Aboriginal Syllabics
  unifiedCanadianAboriginalSyllabics((77 << 32) | (0x1400 << 16) | 0x167F),

  // Bit 78: Ogham
  ogham((78 << 32) | (0x1680 << 16) | 0x169F),

  // Bit 79: Runic
  runic((79 << 32) | (0x16A0 << 16) | 0x16FF),

  // Bit 80: Khmer
  khmer((80 << 32) | (0x1780 << 16) | 0x17FF),
  khmerSymbols((80 << 32) | (0x19E0 << 16) | 0x19FF),

  // Bit 81: Mongolian
  mongolian((81 << 32) | (0x1800 << 16) | 0x18AF),

  // Bit 82: Braille Patterns
  braillePatterns((82 << 32) | (0x2800 << 16) | 0x28FF),

  // Bit 83: Yi
  yiSyllables((83 << 32) | (0xA000 << 16) | 0xA48F),
  yiRadicals((83 << 32) | (0xA490 << 16) | 0xA4CF),

  // Bit 84: Tagalog, Hanunoo, Buhid, Tagbanwa
  tagalog((84 << 32) | (0x1700 << 16) | 0x171F),
  hanunoo((84 << 32) | (0x1720 << 16) | 0x173F),
  buhid((84 << 32) | (0x1740 << 16) | 0x175F),
  tagbanwa((84 << 32) | (0x1760 << 16) | 0x177F),

  // Bit 85: Old Italic
  oldItalic((85 << 32) | (0x10300 << 16) | 0x1032F),

  // Bit 86: Gothic
  gothic((86 << 32) | (0x10330 << 16) | 0x1034F),

  // Bit 87: Deseret
  deseret((87 << 32) | (0x10400 << 16) | 0x1044F),

  // Bit 88: Byzantine Musical Symbols
  byzantineMusicalSymbols((88 << 32) | (0x1D000 << 16) | 0x1D0FF),
  musicalSymbols((88 << 32) | (0x1D100 << 16) | 0x1D1FF),
  ancientGreekMusicalNotation((88 << 32) | (0x1D200 << 16) | 0x1D24F),

  // Bit 89: Mathematical Alphanumeric Symbols
  mathematicalAlphanumericSymbols((89 << 32) | (0x1D400 << 16) | 0x1D7FF),

  // Bit 90: Private Use
  privateUsePlane15((90 << 32) | (0xFF000 << 16) | 0xFFFFD),
  privateUsePlane16((90 << 32) | (0x100000 << 16) | 0x10FFFD),

  // Bit 91: Variation Selectors
  variationSelectors((91 << 32) | (0xFE00 << 16) | 0xFE0F),
  variationSelectorsSupplement((91 << 32) | (0xE0100 << 16) | 0xE01EF),

  // Bit 92: Tags
  tags((92 << 32) | (0xE0000 << 16) | 0xE007F),

  // Bit 93: Limbu
  limbu((93 << 32) | (0x1900 << 16) | 0x194F),

  // Bit 94: Tai Le
  taiLe((94 << 32) | (0x1950 << 16) | 0x197F),

  // Bit 95: New Tai Lue
  newTaiLue((95 << 32) | (0x1980 << 16) | 0x19DF),

  // Bit 96: Buginese
  buginese((96 << 32) | (0x1A00 << 16) | 0x1A1F),

  // Bit 97: Glagolitic
  glagolitic((97 << 32) | (0x2C00 << 16) | 0x2C5F),

  // Bit 98: Tifinagh
  tifinagh((98 << 32) | (0x2D30 << 16) | 0x2D7F),

  // Bit 99: Yijing Hexagram Symbols
  yijingHexagramSymbols((99 << 32) | (0x4DC0 << 16) | 0x4DFF),

  // Bit 100: Syloti Nagri
  sylotiNagri((100 << 32) | (0xA800 << 16) | 0xA82F),

  // Bit 101: Linear B
  linearBSyllabary((101 << 32) | (0x10000 << 16) | 0x1007F),
  linearBIdeograms((101 << 32) | (0x10080 << 16) | 0x100FF),
  aegeanNumbers((101 << 32) | (0x10100 << 16) | 0x1013F),

  // Bit 102: Ancient Greek Numbers
  ancientGreekNumbers((102 << 32) | (0x10140 << 16) | 0x1018F),

  // Bit 103: Ugaritic
  ugaritic((103 << 32) | (0x10380 << 16) | 0x1039F),

  // Bit 104: Old Persian
  oldPersian((104 << 32) | (0x103A0 << 16) | 0x103DF),

  // Bit 105: Shavian
  shavian((105 << 32) | (0x10450 << 16) | 0x1047F),

  // Bit 106: Osmanya
  osmanya((106 << 32) | (0x10480 << 16) | 0x104AF),

  // Bit 107: Cypriot Syllabary
  cypriotSyllabary((107 << 32) | (0x10800 << 16) | 0x1083F),

  // Bit 108: Kharoshthi
  kharoshthi((108 << 32) | (0x10A00 << 16) | 0x10A5F),

  // Bit 109: Tai Xuan Jing Symbols
  taiXuanJingSymbols((109 << 32) | (0x1D300 << 16) | 0x1D35F),

  // Bit 110: Cuneiform
  cuneiform((110 << 32) | (0x12000 << 16) | 0x123FF),
  cuneiformNumbersAndPunctuation((110 << 32) | (0x12400 << 16) | 0x1247F),

  // Bit 111: Counting Rod Numerals
  countingRodNumerals((111 << 32) | (0x1D360 << 16) | 0x1D37F),

  // Bit 112: Sundanese
  sundanese((112 << 32) | (0x1B80 << 16) | 0x1BBF),

  // Bit 113: Lepcha
  lepcha((113 << 32) | (0x1C00 << 16) | 0x1C4F),

  // Bit 114: Ol Chiki
  olChiki((114 << 32) | (0x1C50 << 16) | 0x1C7F),

  // Bit 115: Saurashtra
  saurashtra((115 << 32) | (0xA880 << 16) | 0xA8DF),

  // Bit 116: Kayah Li
  kayahLi((116 << 32) | (0xA900 << 16) | 0xA92F),

  // Bit 117: Rejang
  rejang((117 << 32) | (0xA930 << 16) | 0xA95F),

  // Bit 118: Cham
  cham((118 << 32) | (0xAA00 << 16) | 0xAA5F),

  // Bit 119: Ancient Symbols
  ancientSymbols((119 << 32) | (0x10190 << 16) | 0x101CF),

  // Bit 120: Phaistos Disc
  phaistosDisc((120 << 32) | (0x101D0 << 16) | 0x101FF),

  // Bit 121: Carian, Lycian, Lydian
  carian((121 << 32) | (0x102A0 << 16) | 0x102DF),
  lycian((121 << 32) | (0x10280 << 16) | 0x1029F),
  lydian((121 << 32) | (0x10920 << 16) | 0x1093F),

  // Bit 122: Domino/Mahjong Tiles
  dominoTiles((122 << 32) | (0x1F030 << 16) | 0x1F09F),
  mahjongTiles((122 << 32) | (0x1F000 << 16) | 0x1F02F),

  // Bit 123-127: Reserved
  reserved123(123 << 32),
  reserved124(124 << 32),
  reserved125(125 << 32),
  reserved126(126 << 32),
  reserved127(127 << 32);

  final int bits;
  const UnicodeLangBits(this.bits);
}

/// Static registry of script languages.
class ScriptLangs {
  static final Map<String, int> _registerNames = {};
  static final Map<String, ScriptLang> _registeredScriptTags = {};
  static final Map<String, ScriptLang> _registerScriptFromFullNames = {};
  static final Map<int, _UnicodeRangeMapWithScriptLang> _unicodeLangToScriptLang = {};
  static final Map<String, List<UnicodeLangBits>> _registeredScriptTagsToUnicodeLangBits = {};
  
  static bool _initialized = false;

  static void _ensureInitialized() {
    if (_initialized) return;
    _initialized = true;
    _initializeScriptLangs();
  }

  static ScriptLang _register(String fullname, String shortname, [List<UnicodeLangBits> langBits = const []]) {
    if (_registeredScriptTags.containsKey(shortname)) {
      if (shortname == 'kana') {
        // Hiragana and Katakana both have same short name "kana"
        return ScriptLang(fullname, shortname, _registerNames[shortname]!);
      } else {
        throw UnsupportedError('Duplicate script tag: $shortname');
      }
    }

    final internalName = _registerNames.length;
    _registerNames[shortname] = internalName;
    final scriptLang = ScriptLang(fullname, shortname, internalName);
    _registeredScriptTags[shortname] = scriptLang;
    _registerScriptFromFullNames[fullname] = scriptLang;

    // Register unicode langs with the script lang
    for (final langBit in langBits) {
      final unicodeRange = langBit.toUnicodeRangeInfo();
      if (!_unicodeLangToScriptLang.containsKey(unicodeRange.startAt)) {
        _unicodeLangToScriptLang[unicodeRange.startAt] = _UnicodeRangeMapWithScriptLang(langBit, scriptLang);
      }
    }

    if (langBits.isNotEmpty) {
      _registeredScriptTagsToUnicodeLangBits[shortname] = langBits;
    }

    return scriptLang;
  }

  static void _initializeScriptLangs() {
    // Register all scripts
    adlam = _register('Adlam', 'adlm');
    anatolianHieroglyphs = _register('Anatolian Hieroglyphs', 'hluw');
    arabic = _register('Arabic', 'arab', [
      UnicodeLangBits.arabic,
      UnicodeLangBits.arabicSupplement,
      UnicodeLangBits.arabicPresentationFormsA,
      UnicodeLangBits.arabicPresentationFormsB,
    ]);
    armenian = _register('Armenian', 'armn', [UnicodeLangBits.armenian]);
    avestan = _register('Avestan', 'avst');
    
    balinese = _register('Balinese', 'bali', [UnicodeLangBits.balinese]);
    bamum = _register('Bamum', 'bamu');
    bassaVah = _register('Bassa Vah', 'bass');
    batak = _register('Batak', 'batk');
    bengali = _register('Bengali', 'beng', [UnicodeLangBits.bengali]);
    bengaliV2 = _register('Bengali v.2', 'bng2', [UnicodeLangBits.bengali]);
    bhaiksuki = _register('Bhaiksuki', 'bhks');
    brahmi = _register('Brahmi', 'brah');
    braille = _register('Braille', 'brai', [UnicodeLangBits.braillePatterns]);
    buginese = _register('Buginese', 'bugi', [UnicodeLangBits.buginese]);
    buhid = _register('Buhid', 'buhd', [UnicodeLangBits.buhid]);
    byzantineMusic = _register('Byzantine Music', 'byzm', [UnicodeLangBits.byzantineMusicalSymbols]);
    
    canadianSyllabics = _register('Canadian Syllabics', 'cans', [UnicodeLangBits.unifiedCanadianAboriginalSyllabics]);
    carian = _register('Carian', 'cari', [UnicodeLangBits.carian]);
    caucasianAlbanian = _register('Caucasian Albanian', 'aghb');
    chakma = _register('Chakma', 'cakm');
    cham = _register('Cham', 'cham', [UnicodeLangBits.cham]);
    cherokee = _register('Cherokee', 'cher', [UnicodeLangBits.cherokee]);
    cjkIdeographic = _register('CJK Ideographic', 'hani', [
      UnicodeLangBits.cjkCompatibility,
      UnicodeLangBits.cjkCompatibilityForms,
      UnicodeLangBits.cjkCompatibilityIdeographs,
      UnicodeLangBits.cjkRadicalsSupplement,
    ]);
    coptic = _register('Coptic', 'copt', [UnicodeLangBits.coptic]);
    cypriotSyllabary = _register('Cypriot Syllabary', 'cprt', [UnicodeLangBits.cypriotSyllabary]);
    cyrillic = _register('Cyrillic', 'cyrl', [
      UnicodeLangBits.cyrillic,
      UnicodeLangBits.cyrillicExtendedA,
      UnicodeLangBits.cyrillicExtendedB,
    ]);
    
    defaultScript = _register('Default', 'DFLT');
    deseret = _register('Deseret', 'dsrt', [UnicodeLangBits.deseret]);
    devanagari = _register('Devanagari', 'deva', [UnicodeLangBits.devanagari]);
    devanagariV2 = _register('Devanagari v.2', 'dev2', [UnicodeLangBits.devanagari]);
    duployan = _register('Duployan', 'dupl');
    
    egyptianHieroglyphs = _register('Egyptian Hieroglyphs', 'egyp');
    elbasan = _register('Elbasan', 'elba');
    ethiopic = _register('Ethiopic', 'ethi', [
      UnicodeLangBits.ethiopic,
      UnicodeLangBits.ethiopicExtended,
      UnicodeLangBits.ethiopicSupplement,
    ]);
    
    georgian = _register('Georgian', 'geor', [UnicodeLangBits.georgian, UnicodeLangBits.georgianSupplement]);
    glagolitic = _register('Glagolitic', 'glag', [UnicodeLangBits.glagolitic]);
    gothic = _register('Gothic', 'goth', [UnicodeLangBits.gothic]);
    grantha = _register('Grantha', 'gran');
    greek = _register('Greek', 'grek', [UnicodeLangBits.greekAndCoptic, UnicodeLangBits.greekExtended]);
    gujarati = _register('Gujarati', 'gujr', [UnicodeLangBits.gujarati]);
    gujaratiV2 = _register('Gujarati v.2', 'gjr2', [UnicodeLangBits.gujarati]);
    gurmukhi = _register('Gurmukhi', 'guru', [UnicodeLangBits.gurmukhi]);
    gurmukhiV2 = _register('Gurmukhi v.2', 'gur2', [UnicodeLangBits.gurmukhi]);
    
    hangul = _register('Hangul', 'hang', [UnicodeLangBits.hangulSyllables]);
    hangulJamo = _register('Hangul Jamo', 'jamo', [UnicodeLangBits.hangulJamo]);
    hanunoo = _register('Hanunoo', 'hano', [UnicodeLangBits.hanunoo]);
    hatran = _register('Hatran', 'hatr');
    hebrew = _register('Hebrew', 'hebr', [UnicodeLangBits.hebrew]);
    hiragana = _register('Hiragana', 'kana', [UnicodeLangBits.hiragana]);
    
    imperialAramaic = _register('Imperial Aramaic', 'armi');
    inscriptionalPahlavi = _register('Inscriptional Pahlavi', 'phli');
    inscriptionalParthian = _register('Inscriptional Parthian', 'prti');
    
    javanese = _register('Javanese', 'java');
    
    kaithi = _register('Kaithi', 'kthi');
    kannada = _register('Kannada', 'knda', [UnicodeLangBits.kannada]);
    kannadaV2 = _register('Kannada v.2', 'knd2', [UnicodeLangBits.kannada]);
    katakana = _register('Katakana', 'kana', [UnicodeLangBits.katakana, UnicodeLangBits.katakanaPhoneticExtensions]);
    kayahLi = _register('Kayah Li', 'kali');
    kharosthi = _register('Kharosthi', 'khar', [UnicodeLangBits.kharoshthi]);
    khmer = _register('Khmer', 'khmr', [UnicodeLangBits.khmer, UnicodeLangBits.khmerSymbols]);
    khojki = _register('Khojki', 'khoj');
    khudawadi = _register('Khudawadi', 'sind');
    
    lao = _register('Lao', 'lao', [UnicodeLangBits.lao]);
    latin = _register('Latin', 'latn', [
      UnicodeLangBits.basicLatin,
      UnicodeLangBits.latin1Supplement,
      UnicodeLangBits.latinExtendedA,
      UnicodeLangBits.latinExtendedAdditional,
      UnicodeLangBits.latinExtendedAdditionalC,
      UnicodeLangBits.latinExtendedAdditionalD,
      UnicodeLangBits.latinExtendedB,
    ]);
    lepcha = _register('Lepcha', 'lepc', [UnicodeLangBits.lepcha]);
    limbu = _register('Limbu', 'limb', [UnicodeLangBits.limbu]);
    linearA = _register('Linear A', 'lina');
    linearB = _register('Linear B', 'linb', [UnicodeLangBits.linearBIdeograms, UnicodeLangBits.linearBSyllabary]);
    lisu = _register('Lisu (Fraser)', 'lisu');
    lycian = _register('Lycian', 'lyci', [UnicodeLangBits.lycian]);
    lydian = _register('Lydian', 'lydi', [UnicodeLangBits.lydian]);
    
    mahajani = _register('Mahajani', 'mahj');
    malayalam = _register('Malayalam', 'mlym', [UnicodeLangBits.malayalam]);
    malayalamV2 = _register('Malayalam v.2', 'mlm2', [UnicodeLangBits.malayalam]);
    mandaic = _register('Mandaic, Mandaean', 'mand');
    manichaean = _register('Manichaean', 'mani');
    marchen = _register('Marchen', 'marc');
    math = _register('Mathematical Alphanumeric Symbols', 'math', [UnicodeLangBits.mathematicalAlphanumericSymbols]);
    meiteiMayek = _register('Meitei Mayek (Meithei, Meetei)', 'mtei');
    mendeKikakui = _register('Mende Kikakui', 'mend');
    meroiticCursive = _register('Meroitic Cursive', 'merc');
    meroiticHieroglyphs = _register('Meroitic Hieroglyphs', 'mero');
    miao = _register('Miao', 'plrd');
    modi = _register('Modi', 'modi');
    mongolian = _register('Mongolian', 'mong', [UnicodeLangBits.mongolian]);
    mro = _register('Mro', 'mroo');
    multani = _register('Multani', 'mult');
    musicalSymbols = _register('Musical Symbols', 'musc', [UnicodeLangBits.musicalSymbols]);
    myanmarScript = _register('Myanmar', 'mymr', [UnicodeLangBits.myanmar]);
    myanmarV2 = _register('Myanmar v.2', 'mym2', [UnicodeLangBits.myanmar]);
    
    nabataean = _register('Nabataean', 'nbat');
    newa = _register('Newa', 'newa');
    newTaiLue = _register('New Tai Lue', 'talu', [UnicodeLangBits.newTaiLue]);
    nko = _register('N\'Ko', 'nko', [UnicodeLangBits.nko]);
    
    odia = _register('Odia (formerly Oriya)', 'orya');
    odiaV2 = _register('Odia v.2 (formerly Oriya v.2)', 'ory2');
    ogham = _register('Ogham', 'ogam', [UnicodeLangBits.ogham]);
    olChiki = _register('Ol Chiki', 'olck', [UnicodeLangBits.olChiki]);
    oldItalic = _register('Old Italic', 'ital');
    oldHungarian = _register('Old Hungarian', 'hung');
    oldNorthArabian = _register('Old North Arabian', 'narb');
    oldPermic = _register('Old Permic', 'perm');
    oldPersianCuneiform = _register('Old Persian Cuneiform', 'xpeo');
    oldSouthArabian = _register('Old South Arabian', 'sarb');
    oldTurkic = _register('Old Turkic, Orkhon Runic', 'orkh');
    osage = _register('Osage', 'osge');
    osmanya = _register('Osmanya', 'osma', [UnicodeLangBits.osmanya]);
    
    pahawhHmong = _register('Pahawh Hmong', 'hmng');
    palmyrene = _register('Palmyrene', 'palm');
    pauCinHau = _register('Pau Cin Hau', 'pauc');
    phagsPa = _register('Phags-pa', 'phag', [UnicodeLangBits.phagsPa]);
    phoenicianScript = _register('Phoenician', 'phnx');
    psalterPahlavi = _register('Psalter Pahlavi', 'phlp');
    
    rejang = _register('Rejang', 'rjng', [UnicodeLangBits.rejang]);
    runic = _register('Runic', 'runr', [UnicodeLangBits.runic]);
    
    samaritan = _register('Samaritan', 'samr');
    saurashtra = _register('Saurashtra', 'saur', [UnicodeLangBits.saurashtra]);
    sharada = _register('Sharada', 'shrd');
    shavian = _register('Shavian', 'shaw', [UnicodeLangBits.shavian]);
    siddham = _register('Siddham', 'sidd');
    signWriting = _register('Sign Writing', 'sgnw');
    sinhala = _register('Sinhala', 'sinh', [UnicodeLangBits.sinhala]);
    soraSompeng = _register('Sora Sompeng', 'sora');
    sumeroAkkadianCuneiform = _register('Sumero-Akkadian Cuneiform', 'xsux');
    sundanese = _register('Sundanese', 'sund', [UnicodeLangBits.sundanese]);
    sylotiNagri = _register('Syloti Nagri', 'sylo', [UnicodeLangBits.sylotiNagri]);
    syriacScript = _register('Syriac', 'syrc', [UnicodeLangBits.syriac]);
    
    tagalog = _register('Tagalog', 'tglg');
    tagbanwa = _register('Tagbanwa', 'tagb', [UnicodeLangBits.tagbanwa]);
    taiLe = _register('Tai Le', 'tale', [UnicodeLangBits.taiLe]);
    taiTham = _register('Tai Tham (Lanna)', 'lana');
    taiViet = _register('Tai Viet', 'tavt');
    takri = _register('Takri', 'takr');
    tamilScript = _register('Tamil', 'taml', [UnicodeLangBits.tamil]);
    tamilV2 = _register('Tamil v.2', 'tml2', [UnicodeLangBits.tamil]);
    tangut = _register('Tangut', 'tang');
    teluguScript = _register('Telugu', 'telu', [UnicodeLangBits.telugu]);
    teluguV2 = _register('Telugu v.2', 'tel2', [UnicodeLangBits.telugu]);
    thaana = _register('Thaana', 'thaa', [UnicodeLangBits.thaana]);
    thaiScript = _register('Thai', 'thai', [UnicodeLangBits.thai]);
    tibetan = _register('Tibetan', 'tibt', [UnicodeLangBits.tibetan]);
    tifinagh = _register('Tifinagh', 'tfng', [UnicodeLangBits.tifinagh]);
    tirhuta = _register('Tirhuta', 'tirh');
    
    ugariticCuneiform = _register('Ugaritic Cuneiform', 'ugar');
    
    vaiScript = _register('Vai', 'vai');
    
    warangCiti = _register('Warang Citi', 'wara');
    
    yi = _register('Yi', 'yi', [UnicodeLangBits.yiSyllables]);
  }

  // Script lang instances
  static late ScriptLang adlam;
  static late ScriptLang anatolianHieroglyphs;
  static late ScriptLang arabic;
  static late ScriptLang armenian;
  static late ScriptLang avestan;
  static late ScriptLang balinese;
  static late ScriptLang bamum;
  static late ScriptLang bassaVah;
  static late ScriptLang batak;
  static late ScriptLang bengali;
  static late ScriptLang bengaliV2;
  static late ScriptLang bhaiksuki;
  static late ScriptLang brahmi;
  static late ScriptLang braille;
  static late ScriptLang buginese;
  static late ScriptLang buhid;
  static late ScriptLang byzantineMusic;
  static late ScriptLang canadianSyllabics;
  static late ScriptLang carian;
  static late ScriptLang caucasianAlbanian;
  static late ScriptLang chakma;
  static late ScriptLang cham;
  static late ScriptLang cherokee;
  static late ScriptLang cjkIdeographic;
  static late ScriptLang coptic;
  static late ScriptLang cypriotSyllabary;
  static late ScriptLang cyrillic;
  static late ScriptLang defaultScript;
  static late ScriptLang deseret;
  static late ScriptLang devanagari;
  static late ScriptLang devanagariV2;
  static late ScriptLang duployan;
  static late ScriptLang egyptianHieroglyphs;
  static late ScriptLang elbasan;
  static late ScriptLang ethiopic;
  static late ScriptLang georgian;
  static late ScriptLang glagolitic;
  static late ScriptLang gothic;
  static late ScriptLang grantha;
  static late ScriptLang greek;
  static late ScriptLang gujarati;
  static late ScriptLang gujaratiV2;
  static late ScriptLang gurmukhi;
  static late ScriptLang gurmukhiV2;
  static late ScriptLang hangul;
  static late ScriptLang hangulJamo;
  static late ScriptLang hanunoo;
  static late ScriptLang hatran;
  static late ScriptLang hebrew;
  static late ScriptLang hiragana;
  static late ScriptLang imperialAramaic;
  static late ScriptLang inscriptionalPahlavi;
  static late ScriptLang inscriptionalParthian;
  static late ScriptLang javanese;
  static late ScriptLang kaithi;
  static late ScriptLang kannada;
  static late ScriptLang kannadaV2;
  static late ScriptLang katakana;
  static late ScriptLang kayahLi;
  static late ScriptLang kharosthi;
  static late ScriptLang khmer;
  static late ScriptLang khojki;
  static late ScriptLang khudawadi;
  static late ScriptLang lao;
  static late ScriptLang latin;
  static late ScriptLang lepcha;
  static late ScriptLang limbu;
  static late ScriptLang linearA;
  static late ScriptLang linearB;
  static late ScriptLang lisu;
  static late ScriptLang lycian;
  static late ScriptLang lydian;
  static late ScriptLang mahajani;
  static late ScriptLang malayalam;
  static late ScriptLang malayalamV2;
  static late ScriptLang mandaic;
  static late ScriptLang manichaean;
  static late ScriptLang marchen;
  static late ScriptLang math;
  static late ScriptLang meiteiMayek;
  static late ScriptLang mendeKikakui;
  static late ScriptLang meroiticCursive;
  static late ScriptLang meroiticHieroglyphs;
  static late ScriptLang miao;
  static late ScriptLang modi;
  static late ScriptLang mongolian;
  static late ScriptLang mro;
  static late ScriptLang multani;
  static late ScriptLang musicalSymbols;
  static late ScriptLang myanmarScript;
  static late ScriptLang myanmarV2;
  static late ScriptLang nabataean;
  static late ScriptLang newa;
  static late ScriptLang newTaiLue;
  static late ScriptLang nko;
  static late ScriptLang odia;
  static late ScriptLang odiaV2;
  static late ScriptLang ogham;
  static late ScriptLang olChiki;
  static late ScriptLang oldItalic;
  static late ScriptLang oldHungarian;
  static late ScriptLang oldNorthArabian;
  static late ScriptLang oldPermic;
  static late ScriptLang oldPersianCuneiform;
  static late ScriptLang oldSouthArabian;
  static late ScriptLang oldTurkic;
  static late ScriptLang osage;
  static late ScriptLang osmanya;
  static late ScriptLang pahawhHmong;
  static late ScriptLang palmyrene;
  static late ScriptLang pauCinHau;
  static late ScriptLang phagsPa;
  static late ScriptLang phoenicianScript;
  static late ScriptLang psalterPahlavi;
  static late ScriptLang rejang;
  static late ScriptLang runic;
  static late ScriptLang samaritan;
  static late ScriptLang saurashtra;
  static late ScriptLang sharada;
  static late ScriptLang shavian;
  static late ScriptLang siddham;
  static late ScriptLang signWriting;
  static late ScriptLang sinhala;
  static late ScriptLang soraSompeng;
  static late ScriptLang sumeroAkkadianCuneiform;
  static late ScriptLang sundanese;
  static late ScriptLang sylotiNagri;
  static late ScriptLang syriacScript;
  static late ScriptLang tagalog;
  static late ScriptLang tagbanwa;
  static late ScriptLang taiLe;
  static late ScriptLang taiTham;
  static late ScriptLang taiViet;
  static late ScriptLang takri;
  static late ScriptLang tamilScript;
  static late ScriptLang tamilV2;
  static late ScriptLang tangut;
  static late ScriptLang teluguScript;
  static late ScriptLang teluguV2;
  static late ScriptLang thaana;
  static late ScriptLang thaiScript;
  static late ScriptLang tibetan;
  static late ScriptLang tifinagh;
  static late ScriptLang tirhuta;
  static late ScriptLang ugariticCuneiform;
  static late ScriptLang vaiScript;
  static late ScriptLang warangCiti;
  static late ScriptLang yi;

  /// Try to get unicode lang bits array for a language short name.
  static List<UnicodeLangBits>? tryGetUnicodeLangBitsArray(String langShortName) {
    _ensureInitialized();
    return _registeredScriptTagsToUnicodeLangBits[langShortName];
  }

  /// Try to get ScriptLang for a character.
  static ScriptLang? tryGetScriptLang(int charCode) {
    _ensureInitialized();
    final sortedKeys = _unicodeLangToScriptLang.keys.toList()..sort();
    
    for (final key in sortedKeys) {
      if (key > charCode) {
        return null;
      }
      final mapping = _unicodeLangToScriptLang[key]!;
      if (mapping.isInRange(charCode)) {
        return mapping.scLang;
      }
    }
    return null;
  }

  /// Get registered script lang by short name.
  static ScriptLang? getRegisteredScriptLang(String shortname) {
    _ensureInitialized();
    return _registeredScriptTags[shortname];
  }

  /// Get registered script lang by full language name.
  static ScriptLang? getRegisteredScriptLangFromLanguageName(String languageName) {
    _ensureInitialized();
    return _registerScriptFromFullNames[languageName];
  }

  /// Iterate over all registered script langs.
  static Iterable<ScriptLang> getRegisteredScriptLangIter() sync* {
    _ensureInitialized();
    yield* _registeredScriptTags.values;
  }
}

class _UnicodeRangeMapWithScriptLang {
  final ScriptLang scLang;
  final UnicodeLangBits unicodeRangeBits;

  _UnicodeRangeMapWithScriptLang(this.unicodeRangeBits, this.scLang);

  bool isInRange(int charCode) {
    return unicodeRangeBits.toUnicodeRangeInfo().isInRange(charCode);
  }
}

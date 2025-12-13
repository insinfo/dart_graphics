// Apache2, 2016-present, WinterDev
// Dart port by insinfo

/// OpenType feature information.
///
/// From https://www.microsoft.com/typography/otfntdev/standot/features.aspx
/// https://www.microsoft.com/typography/otspec/featurelist.htm
class FeatureInfo {
  /// Full descriptive name of the feature.
  final String fullname;

  /// Short 4-letter tag (e.g., 'liga', 'kern').
  final String shortname;

  const FeatureInfo(this.fullname, this.shortname);

  @override
  String toString() => '$shortname ($fullname)';
}

/// Collection of standard OpenType features.
class Features {
  static final Map<String, FeatureInfo> _features = {};

  // Feature definitions
  static final aalt = _register('aalt', 'Access All Alternates');
  static final abvf = _register('abvf', 'Above-base Forms');
  static final abvm = _register('abvm', 'Above-base Mark Positioning');
  static final abvs = _register('abvs', 'Above-base Substitutions');
  static final afrc = _register('afrc', 'Alternative Fractions');
  static final akhn = _register('akhn', 'Akhands');

  static final blwf = _register('blwf', 'Below-base Forms');
  static final blwm = _register('blwm', 'Below-base Mark Positioning');
  static final blws = _register('blws', 'Below-base Substitutions');

  static final calt = _register('calt', 'Contextual Alternates');
  static final case_ = _register('case', 'Case-Sensitive Forms');
  static final ccmp = _register('ccmp', 'Glyph Composition / Decomposition');
  static final cfar = _register('cfar', 'Conjunct Form After Ro');
  static final cjct = _register('cjct', 'Conjunct Forms');
  static final clig = _register('clig', 'Contextual Ligatures');
  static final cpct = _register('cpct', 'Centered CJK Punctuation');
  static final cpsp = _register('cpsp', 'Capital Spacing');
  static final cswh = _register('cswh', 'Contextual Swash');
  static final curs = _register('curs', 'Cursive Positioning');
  static final c2pc = _register('c2pc', 'Petite Capitals From Capitals');
  static final c2sc = _register('c2sc', 'Small Capitals From Capitals');

  static final dist = _register('dist', 'Distances');
  static final dlig = _register('dlig', 'Discretionary Ligatures');
  static final dnom = _register('dnom', 'Denominators');
  static final dtls = _register('dtls', 'Dotless Forms');

  static final expt = _register('expt', 'Expert Forms');

  static final falt = _register('falt', 'Final Glyph on Line Alternates');
  static final fin2 = _register('fin2', 'Terminal Forms #2');
  static final fin3 = _register('fin3', 'Terminal Forms #3');
  static final fina = _register('fina', 'Terminal Forms');
  static final flac = _register('flac', 'Flattened accent forms');
  static final frac = _register('frac', 'Fractions');
  static final fwid = _register('fwid', 'Full Widths');

  static final half = _register('half', 'Half Forms');
  static final haln = _register('haln', 'Halant Forms');
  static final halt = _register('halt', 'Alternate Half Widths');
  static final hist = _register('hist', 'Historical Forms');
  static final hkna = _register('hkna', 'Horizontal Kana Alternates');
  static final hlig = _register('hlig', 'Historical Ligatures');
  static final hngl = _register('hngl', 'Hangul');
  static final hojo = _register('hojo', 'Hojo Kanji Forms (JIS X 0212-1990 Kanji Forms)');
  static final hwid = _register('hwid', 'Half Widths');

  static final init = _register('init', 'Initial Forms');
  static final isol = _register('isol', 'Isolated Forms');
  static final ital = _register('ital', 'Italics');

  static final jalt = _register('jalt', 'Justification Alternates');
  static final jp78 = _register('jp78', 'JIS78 Forms');
  static final jp83 = _register('jp83', 'JIS83 Forms');
  static final jp90 = _register('jp90', 'JIS90 Forms');
  static final jp04 = _register('jp04', 'JIS2004 Forms');

  static final kern = _register('kern', 'Kerning');

  static final lfbd = _register('lfbd', 'Left Bounds');
  static final liga = _register('liga', 'Standard Ligatures');
  static final ljmo = _register('ljmo', 'Leading Jamo Forms');
  static final lnum = _register('lnum', 'Lining Figures');
  static final locl = _register('locl', 'Localized Forms');
  static final ltra = _register('ltra', 'Left-to-right alternates');
  static final ltrm = _register('ltrm', 'Left-to-right mirrored forms');

  static final mark = _register('mark', 'Mark Positioning');
  static final med2 = _register('med2', 'Medial Forms #2');
  static final medi = _register('medi', 'Medial Forms');
  static final mgrk = _register('mgrk', 'Mathematical Greek');
  static final mkmk = _register('mkmk', 'Mark to Mark Positioning');
  static final mset = _register('mset', 'Mark Positioning via Substitution');

  static final nalt = _register('nalt', 'Alternate Annotation Forms');
  static final nlck = _register('nlck', 'NLC Kanji Forms');
  static final nukt = _register('nukt', 'Nukta Forms');
  static final numr = _register('numr', 'Numerators');

  static final onum = _register('onum', 'Oldstyle Figures');
  static final opbd = _register('opbd', 'Optical Bounds');
  static final ordn = _register('ordn', 'Ordinals');
  static final ornm = _register('ornm', 'Ornaments');

  static final palt = _register('palt', 'Proportional Alternate Widths');
  static final pcap = _register('pcap', 'Petite Capitals');
  static final pkna = _register('pkna', 'Proportional Kana');
  static final pnum = _register('pnum', 'Proportional Figures');
  static final pref = _register('pref', 'Pre-Base Forms');
  static final pres = _register('pres', 'Pre-base Substitutions');
  static final pstf = _register('pstf', 'Post-base Forms');
  static final psts = _register('psts', 'Post-base Substitutions');
  static final pwid = _register('pwid', 'Proportional Widths');

  static final qwid = _register('qwid', 'Quarter Widths');

  static final rand = _register('rand', 'Randomize');
  static final rclt = _register('rclt', 'Required Contextual Alternates');
  static final rkrf = _register('rkrf', 'Rakar Forms');
  static final rlig = _register('rlig', 'Required Ligatures');
  static final rphf = _register('rphf', 'Reph Forms');
  static final rtbd = _register('rtbd', 'Right Bounds');
  static final rtla = _register('rtla', 'Right-to-left alternates');
  static final rtlm = _register('rtlm', 'Right-to-left mirrored forms');
  static final ruby = _register('ruby', 'Ruby Notation Forms');
  static final rvrn = _register('rvrn', 'Required Variation Alternates');

  static final salt = _register('salt', 'Stylistic Alternates');
  static final sinf = _register('sinf', 'Scientific Inferiors');
  static final size = _register('size', 'Optical size');
  static final smcp = _register('smcp', 'Small Capitals');
  static final smpl = _register('smpl', 'Simplified Forms');

  static final ssty = _register('ssty', 'Math script style alternates');
  static final stch = _register('stch', 'Stretching Glyph Decomposition');
  static final subs = _register('subs', 'Subscript');
  static final sups = _register('sups', 'Superscript');
  static final swsh = _register('swsh', 'Swash');

  static final titl = _register('titl', 'Titling');
  static final tjmo = _register('tjmo', 'Trailing Jamo Forms');
  static final tnam = _register('tnam', 'Traditional Name Forms');
  static final tnum = _register('tnum', 'Tabular Figures');
  static final trad = _register('trad', 'Traditional Forms');
  static final twid = _register('twid', 'Third Widths');

  static final unic = _register('unic', 'Unicase');

  static final valt = _register('valt', 'Alternate Vertical Metrics');
  static final vatu = _register('vatu', 'Vattu Variants');
  static final vert = _register('vert', 'Vertical Writing');
  static final vhal = _register('vhal', 'Alternate Vertical Half Metrics');
  static final vjmo = _register('vjmo', 'Vowel Jamo Forms');
  static final vkna = _register('vkna', 'Vertical Kana Alternates');
  static final vkrn = _register('vkrn', 'Vertical Kerning');
  static final vpal = _register('vpal', 'Proportional Alternate Vertical Metrics');
  static final vrt2 = _register('vrt2', 'Vertical Alternates and Rotation');
  static final vrtr = _register('vrtr', 'Vertical Alternates for Rotation');

  /// Initialize character variants and stylistic sets
  static void _initDynamicFeatures() {
    // Character Variants cv01-cv99
    for (int i = 1; i < 10; i++) {
      _register('cv0$i', 'Character Variant $i');
    }
    for (int i = 10; i < 100; i++) {
      _register('cv$i', 'Character Variant $i');
    }

    // Stylistic Sets ss01-ss20
    for (int i = 1; i < 10; i++) {
      _register('ss0$i', 'Stylistic Set $i');
    }
    for (int i = 10; i <= 20; i++) {
      _register('ss$i', 'Stylistic Set $i');
    }
  }

  static FeatureInfo _register(String shortname, String fullname) {
    final featureInfo = FeatureInfo(fullname, shortname);
    _features[shortname] = featureInfo;
    return featureInfo;
  }

  /// Look up a feature by its short tag.
  static FeatureInfo? getByTag(String tag) {
    // Ensure dynamic features are initialized
    if (_features.length < 100) {
      _initDynamicFeatures();
    }
    return _features[tag];
  }

  /// Check if a feature tag is known.
  static bool isKnownFeature(String tag) => _features.containsKey(tag);

  /// Get all known features.
  static Iterable<FeatureInfo> get allFeatures => _features.values;

  /// Common features used in text layout.
  static List<FeatureInfo> get commonLayoutFeatures => [
        ccmp,
        locl,
        liga,
        clig,
        kern,
        mark,
        mkmk,
      ];

  /// Features for Arabic script.
  static List<FeatureInfo> get arabicFeatures => [
        ccmp,
        locl,
        isol,
        fina,
        medi,
        init,
        rlig,
        calt,
        liga,
        cswh,
        mset,
        curs,
        kern,
        mark,
        mkmk,
      ];

  /// Features for Devanagari/Indic scripts.
  static List<FeatureInfo> get indicFeatures => [
        locl,
        ccmp,
        nukt,
        akhn,
        rphf,
        rkrf,
        pref,
        blwf,
        abvf,
        half,
        pstf,
        vatu,
        cjct,
        cfar,
        pres,
        abvs,
        blws,
        psts,
        haln,
        dist,
        abvm,
        blwm,
        calt,
        kern,
      ];
}

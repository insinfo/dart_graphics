import 'dart:math';

import '../clipper.dart';
import 'engine/minkowski.dart';
import 'engine/rect_clip_64.dart';
import 'engine/rect_clip_lines_64.dart';

import 'clipper_internal.dart';

/// A wrapper class containing convenience functions for most common clipping operations.
class Clipper {
  /// Intersect [subject] with [clip], with paths described in integer coordinates.
  static Paths64 intersect({
    required Paths64 subject,
    required Paths64 clip,
    required FillRule fillRule,
  }) => booleanOp(
    clipType: ClipType.intersection,
    subject: subject,
    clip: clip,
    fillRule: fillRule,
  );

  /// Intersect [subject] with [clip], with paths described in floating point coordinates.
  static PathsD intersectD({
    required PathsD subject,
    required PathsD clip,
    required FillRule fillRule,
    int precision = 2,
  }) => booleanOpD(
    clipType: ClipType.intersection,
    subject: subject,
    clip: clip,
    fillRule: fillRule,
    precision: precision,
  );

  /// Union of [subject] with [clip], with paths described in integer coordinates.
  static Paths64 union({
    required Paths64 subject,
    Paths64 clip = const [],
    required FillRule fillRule,
  }) => booleanOp(
    clipType: ClipType.union,
    subject: subject,
    clip: clip,
    fillRule: fillRule,
  );

  /// Union of [subject] with [clip], with paths described in floating point coordinates.
  static PathsD unionD({
    required PathsD subject,
    required PathsD clip,
    required FillRule fillRule,
    int precision = 2,
  }) => booleanOpD(
    clipType: ClipType.union,
    subject: subject,
    clip: clip,
    fillRule: fillRule,
    precision: precision,
  );

  /// Difference of [subject] and [clip], with paths described in integer coordinates.
  static Paths64 difference({
    required Paths64 subject,
    required Paths64 clip,
    required FillRule fillRule,
  }) => booleanOp(
    clipType: ClipType.difference,
    subject: subject,
    clip: clip,
    fillRule: fillRule,
  );

  /// Difference of [subject] and [clip], with paths described in floating point coordinates.
  static PathsD differenceD({
    required PathsD subject,
    required PathsD clip,
    required FillRule fillRule,
    int precision = 2,
  }) => booleanOpD(
    clipType: ClipType.difference,
    subject: subject,
    clip: clip,
    fillRule: fillRule,
    precision: precision,
  );

  /// Exclusive or of [subject] and [clip], with paths described in integer coordinates.
  static Paths64 xor({
    required Paths64 subject,
    required Paths64 clip,
    required FillRule fillRule,
  }) => booleanOp(
    clipType: ClipType.xor,
    subject: subject,
    clip: clip,
    fillRule: fillRule,
  );

  /// Exclusive or of [subject] and [clip], with paths described in floating point coordinates.
  static PathsD xorD({
    required PathsD subject,
    required PathsD clip,
    required FillRule fillRule,
    int precision = 2,
  }) => booleanOpD(
    clipType: ClipType.xor,
    subject: subject,
    clip: clip,
    fillRule: fillRule,
    precision: precision,
  );

  /// Perform the boolean operator specified by [clipType] for [subject] and [clip].
  /// The paths are described in integer coordinates.
  static Paths64 booleanOp({
    required ClipType clipType,
    Paths64? subject,
    Paths64? clip,
    required FillRule fillRule,
  }) {
    if (subject == null || subject.isEmpty) {
      return Paths64.empty();
    }
    final c = Clipper64();
    c.addPaths(subject, PathType.subject);
    if (clip != null) {
      c.addPaths(clip, PathType.clip);
    }
    return c.executeClosed(clipType, fillRule) ?? Paths64.empty();
  }

  /// Perform the boolean operator specified by [clipType] for [subject] and [clip] expressed in
  /// integer coordinates, and return the result as a [PolyTree64].
  static PolyTree64 booleanOpPolyTree({
    required ClipType clipType,
    Paths64? subject,
    Paths64? clip,
    required FillRule fillRule,
  }) {
    if (subject == null || subject.isEmpty) {
      return PolyTree64();
    }
    final c = Clipper64();
    c.addPaths(subject, PathType.subject);
    if (clip != null) {
      c.addPaths(clip, PathType.clip);
    }
    return c.executeTree(clipType, fillRule)?.tree ?? PolyTree64();
  }

  /// Perform the boolean operator specified by [clipType] for [subject] and [clip].
  /// The paths are described in floating point coordinates.
  static PathsD booleanOpD({
    required ClipType clipType,
    PathsD? subject,
    PathsD? clip,
    required FillRule fillRule,
    int precision = 2,
  }) {
    if (subject == null || subject.isEmpty) {
      return PathsD.empty();
    }
    final c = ClipperD(roundingDecimalPrecision: precision);
    c.addPaths(subject, PathType.subject);
    if (clip != null) {
      c.addPaths(clip, PathType.clip);
    }
    return c.executeClosed(clipType, fillRule) ?? PathsD.empty();
  }

  /// Perform the boolean operator specified by [clipType] for [subject] and [clip] expressed in
  /// floating point coordinates, and return the result as a [PolyTreeD].
  static PolyTreeD booleanOpPolyTreeD({
    required ClipType clipType,
    PathsD? subject,
    PathsD? clip,
    required FillRule fillRule,
  }) {
    if (subject == null || subject.isEmpty) {
      return PolyTreeD(scale: 1);
    }
    final c = ClipperD();
    c.addPaths(subject, PathType.subject);
    if (clip != null) {
      c.addPaths(clip, PathType.clip);
    }
    return c.executeTree(clipType, fillRule)?.tree ?? PolyTreeD(scale: 1);
  }

  /// Inflate (offset) [paths] by [delta].
  static Paths64 inflatePaths({
    required Paths64 paths,
    required double delta,
    required JoinType joinType,
    required EndType endType,
    double miterLimit = 2.0,
    double arcTolerance = 0.0,
  }) {
    final co = ClipperOffset(
      miterLimit: miterLimit,
      arcTolerance: arcTolerance,
    );
    co.addPaths(paths, joinType: joinType, endType: endType);
    return co.execute(delta: delta);
  }

  /// Inflate (offset) [paths] by [delta].
  static PathsD inflatePathsD({
    required PathsD paths,
    required double delta,
    required JoinType joinType,
    required EndType endType,
    double miterLimit = 2.0,
    double arcTolerance = 0.0,
    int precision = 2,
  }) {
    checkPrecision(precision);
    final scale = pow(10, precision).toDouble();
    final tmp = paths.scaledPaths64(scale);
    final co = ClipperOffset(
      miterLimit: miterLimit,
      arcTolerance: scale * arcTolerance,
    );
    co.addPaths(tmp, joinType: joinType, endType: endType);
    final solution = co.execute(delta: delta * scale);
    return solution.scaledPathsD(1 / scale);
  }

  /// Clip [path] or [paths] with the rectangle [rect]. This is much faster than the generic intersection operation,
  /// when the clipping path is a rectangle.
  static Paths64 rectClip({
    required Rect64 rect,
    Path64? path,
    Paths64? paths,
  }) {
    assert(path == null || paths == null);
    assert(path != null || paths != null);
    if (rect.isEmpty || paths?.isNotEmpty != true && path?.isNotEmpty != true) {
      return Paths64.empty();
    }
    final rc = RectClip64(rect: rect);
    if (path != null) {
      return rc.execute([path]);
    }
    return rc.execute(paths!);
  }

  /// Clip [path] or [paths] with the rectangle [rect]. This is much faster than the generic intersection operation,
  /// when the clipping path is a rectangle.
  static PathsD rectClipD({
    required RectD rect,
    PathD? path,
    PathsD? paths,
    int precision = 2,
  }) {
    assert(path == null || paths == null);
    assert(path != null || paths != null);
    if (rect.isEmpty || paths?.isNotEmpty != true && path?.isNotEmpty != true) {
      return PathsD.empty();
    }
    checkPrecision(precision);
    final scale = pow(10, precision).toDouble();
    final r = rect.scaled64(scale);
    final tmp = (paths ?? [path!]).scaledPaths64(scale);
    final rc = RectClip64(rect: r);
    final solution = rc.execute(tmp);
    return solution.scaledPathsD(1 / scale);
  }

  /// Clip [path] or [paths] with the rectangle [rect]. This is much faster than the generic intersection operation,
  /// when the clipping path is a rectangle.
  static Paths64 rectClipLines({
    required Rect64 rect,
    Path64? path,
    Paths64? paths,
  }) {
    assert(path == null || paths == null);
    assert(path != null || paths != null);
    if (rect.isEmpty || paths?.isNotEmpty != true && path?.isNotEmpty != true) {
      return Paths64.empty();
    }
    final rc = RectClipLines64(rect: rect);
    if (path != null) {
      return rc.execute([path]);
    }
    return rc.execute(paths!);
  }

  /// Clip [path] or [paths] with the rectangle [rect]. This is much faster than the generic intersection operation,
  /// when the clipping path is a rectangle.
  static PathsD rectClipLinesD({
    required RectD rect,
    PathD? path,
    PathsD? paths,
    int precision = 2,
  }) {
    assert(path == null || paths == null);
    assert(path != null || paths != null);
    if (rect.isEmpty || paths?.isNotEmpty != true && path?.isNotEmpty != true) {
      return PathsD.empty();
    }
    checkPrecision(precision);
    final scale = pow(10, precision).toDouble();
    final r = rect.scaled64(scale);
    final tmp = (paths ?? [path!]).scaledPaths64(scale);
    final rc = RectClipLines64(rect: r);
    final solution = rc.execute(tmp);
    return solution.scaledPathsD(1 / scale);
  }

  /// Calculate the [Minkowski sum](https://en.wikipedia.org/wiki/Minkowski_addition) of [path] and [pattern].
  static Paths64 minkowskiSum({
    required Path64 pattern,
    required Path64 path,
    required bool isClosed,
  }) {
    return Minkowski.sum(pattern: pattern, path: path, isClosed: isClosed);
  }

  /// Calculate the [Minkowski sum](https://en.wikipedia.org/wiki/Minkowski_addition) of [path] and [pattern].
  static PathsD minkowskiSumD({
    required PathD pattern,
    required PathD path,
    required bool isClosed,
    int decimalPlaces = 2,
  }) {
    return Minkowski.sumD(
      pattern: pattern,
      path: path,
      isClosed: isClosed,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Calculate the [Minkowski difference](https://en.wikipedia.org/wiki/Minkowski_addition) of [path] and [pattern].
  static Paths64 minkowskiDiff({
    required Path64 pattern,
    required Path64 path,
    required bool isClosed,
  }) {
    return Minkowski.diff(pattern: pattern, path: path, isClosed: isClosed);
  }

  /// Calculate the [Minkowski difference](https://en.wikipedia.org/wiki/Minkowski_addition) of [path] and [pattern].
  static PathsD minkowskiDiffD({
    required PathD pattern,
    required PathD path,
    required bool isClosed,
    int decimalPlaces = 2,
  }) {
    return Minkowski.diffD(
      pattern: pattern,
      path: path,
      isClosed: isClosed,
      decimalPlaces: decimalPlaces,
    );
  }
}

/// Clipping operation type
enum ClipType {
  /// No clipping – this is a no-op.
  noClip,

  /// Intersection of subject and clip is the area covered by both paths.
  intersection,

  /// Union consists of all area combined by any path, either subject, clip or both.
  union,

  /// Difference of subject and clip deletes the area covered by clip from the subject paths.
  difference,

  /// Xor of subject and clip covers all the area covered by either the subject or the clip, but not both.
  xor,
}

/// Input path type. See [ClipType] for more information.
enum PathType {
  // Subject is the source path for the operation.
  subject,
  // Clip is the modifying path for the operation.
  clip,
}

/// Polygon fill rule, as specified by the [winding number](https://en.wikipedia.org/wiki/Winding_number).
enum FillRule {
  /// Points whose winding number is even are part of polygon.
  evenOdd,

  /// Points whose winding number is not zero are part of the polygon.
  nonZero,

  /// Points whose winding number is positive are part of the polygon.
  positive,

  /// Points whose winding number is negative are part of the polygon.
  negative,
}

/// Result for the [Path64Ext.pointInPolygon] and [PathDExt.pointInPolygon] functions.
enum PointInPolygonResult {
  /// The point is exactly on the polygon's perimeter.
  isOn,

  /// The point is inside the polygon.
  isInside,

  /// The point is outside the polygon.
  isOutside,
}

/// Type of line join when offsetting
enum JoinType {
  /// Miter join is a sharp corner.
  miter,

  /// Square join preserves offset width at the apex of the join.
  square,

  /// Bevel join is similar to [square] join, but flatter.
  bevel,

  /// Round join consists of a partial circle around the corner.
  round,
}

/// Type of line end when offsetting
enum EndType {
  /// The path is closed and should be interpreted as a filled polygon.
  polygon,

  /// The path is closed and should be interpreted as a line string.
  joined,

  /// The path is open and its ends should not be extended.
  butt,

  /// The path is open and its ends should be squares with a diameter of 2*delta.
  square,

  /// The path is open and its ends should be half circles with a radius of delta.
  round,
}

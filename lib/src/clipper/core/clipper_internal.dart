// ignore_for_file: prefer-match-file-name

import 'max_int_native.dart' if (dart.library.js_util) 'max_int_js.dart';
import 'point_64.dart';
import 'point_d.dart';

const kMaxCoord = kMaxInt64 ~/ 4;
const kMinCoord = -kMaxCoord;
const kInvalid64 = kMaxInt64;

const kFloatingPointTolerance = 1e-12;
const kDefaultMinimumEdgeLength = 0.1;

final precisionRangeError = Exception('Precision is out of range');

// typecast to double to avoid potential int overflow
double crossProduct(Point64 pt1, Point64 pt2, Point64 pt3) =>
    ((pt2.x - pt1.x).toDouble() * (pt3.y - pt2.y).toDouble() -
        (pt2.y - pt1.y).toDouble() * (pt3.x - pt2.x).toDouble());

// typecast to double to avoid potential int overflow
double dotProduct(Point64 pt1, Point64 pt2, Point64 pt3) =>
    ((pt2.x - pt1.x).toDouble() * (pt3.x - pt2.x).toDouble() +
        (pt2.y - pt1.y).toDouble() * (pt3.y - pt2.y).toDouble());

void checkPrecision(int precision) {
  if (precision < -8 || precision > 8) {
    throw precisionRangeError;
  }
}

bool isAlmostZero(double value) =>
    value >= -kFloatingPointTolerance && value <= kFloatingPointTolerance;

class MultiplyUint64Result {
  const MultiplyUint64Result(this.lo64, this.hi64);

  // Careful, as Dart does not have unsigned types
  final int lo64;
  final int hi64;

  @override
  bool operator ==(Object other) =>
      other is MultiplyUint64Result && lo64 == other.lo64 && hi64 == other.hi64;

  @override
  int get hashCode => Object.hash(lo64, hi64);
}

MultiplyUint64Result multiplyUint64(int a, int b) {
  if (identical(0, 0.0)) {
    // Javascript - 52-bit integers
    final x1 = (a & 0x3FFFFFF) * (b & 0x3FFFFFF);
    final x2 = (a >> 26) * (b & 0x3FFFFFF) + (x1 >> 26);
    final x3 = (a & 0x3FFFFFF) * (b >> 26) + (x2 & 0x3FFFFFF);
    return MultiplyUint64Result(
      (x3 & 0x3FFFFFF) << 26 | (x1 & 0x3FFFFFF),
      (a >> 26) * (b >> 26) + (x2 >> 26) + (x3 >> 26),
    );
  }
  // Native - 64-bit integers
  final x1 = (a & 0xFFFFFFFF) * (b & 0xFFFFFFFF);
  final x2 = (a >> 32) * (b & 0xFFFFFFFF) + (x1 >> 32);
  final x3 = (a & 0xFFFFFFFF) * (b >> 32) + (x2 & 0xFFFFFFFF);
  return MultiplyUint64Result(
    (x3 & 0xFFFFFFFF) << 32 | (x1 & 0xFFFFFFFF),
    (a >> 32) * (b >> 32) + (x2 >> 32) + (x3 >> 32),
  );
}

bool productsAreEqual(int a, int b, int c, int d) {
  final mulAB = multiplyUint64(a.abs(), b.abs());
  final mulCD = multiplyUint64(c.abs(), d.abs());
  final signAB = a.sign * b.sign;
  final signCD = c.sign * d.sign;
  return mulAB == mulCD && signAB == signCD;
}

bool isCollinear(Point64 pt1, Point64 sharedPt, Point64 pt2) {
  final a = sharedPt.x - pt1.x;
  final b = pt2.y - sharedPt.y;
  final c = sharedPt.y - pt1.y;
  final d = pt2.x - sharedPt.x;
  // When checking for collinearity with very large coordinate values
  // then ProductsAreEqual is more accurate than using CrossProduct.
  return productsAreEqual(a, b, c, d);
}

int checkCastInt64(double val) {
  if (val >= kMaxCoord || val <= kMinCoord) {
    return kInvalid64;
  }
  return val.round();
}

Point64? getSegmentIntersectPt(
  Point64 ln1a,
  Point64 ln1b,
  Point64 ln2a,
  Point64 ln2b,
) {
  final dy1 = (ln1b.y - ln1a.y).toDouble();
  final dx1 = (ln1b.x - ln1a.x).toDouble();
  final dy2 = (ln2b.y - ln2a.y).toDouble();
  final dx2 = (ln2b.x - ln2a.x).toDouble();
  final det = dy1 * dx2 - dy2 * dx1;
  if (det == 0.0) {
    return null;
  }

  final t = ((ln1a.x - ln2a.x) * dy2 - (ln1a.y - ln2a.y) * dx2) / det;
  if (t <= 0.0) {
    return ln1a;
  } else if (t >= 1.0) {
    return ln1b;
  }
  return Point64((ln1a.x + t * dx1).round(), (ln1a.y + t * dy1).round());
}

bool segsIntersect(
  Point64 seg1a,
  Point64 seg1b,
  Point64 seg2a,
  Point64 seg2b, {
  bool inclusive = false,
}) {
  if (!inclusive) {
    return (crossProduct(seg1a, seg2a, seg2b) *
                crossProduct(seg1b, seg2a, seg2b) <
            0) &&
        (crossProduct(seg2a, seg1a, seg1b) * crossProduct(seg2b, seg1a, seg1b) <
            0);
  }
  double res1 = crossProduct(seg1a, seg2a, seg2b);
  double res2 = crossProduct(seg1b, seg2a, seg2b);
  if (res1 * res2 > 0) return false;
  double res3 = crossProduct(seg2a, seg1a, seg1b);
  double res4 = crossProduct(seg2b, seg1a, seg1b);
  if (res3 * res4 > 0) return false;
  // ensure NOT collinear
  return (res1 != 0 || res2 != 0 || res3 != 0 || res4 != 0);
}

Point64 getClosestPtOnSegment(Point64 offPt, Point64 seg1, Point64 seg2) {
  if (seg1.x == seg2.x && seg1.y == seg2.y) {
    return seg1;
  }
  final dx = (seg2.x - seg1.x).toDouble();
  final dy = (seg2.y - seg1.y).toDouble();
  var q =
      ((offPt.x - seg1.x) * dx + (offPt.y - seg1.y) * dy) /
      ((dx * dx) + (dy * dy));
  if (q < 0) {
    q = 0;
  } else if (q > 1) {
    q = 1;
  }
  return Point64(seg1.x + (q * dx).round(), seg1.y + (q * dy).round());
}

Iterable<(T, T)> takeEvenOdd<T>(Iterable<T> iterable) sync* {
  var even = true;
  late T evenItem;
  for (final item in iterable) {
    if (even) {
      evenItem = item;
    } else {
      yield (evenItem, item);
    }
    even = !even;
  }
}

double sqr<T extends num>(T val) => val.toDouble() * val;
double distanceSqr(Point64 pt1, Point64 pt2) =>
    sqr(pt1.x - pt2.x) + sqr(pt1.y - pt2.y);
double distanceSqrD(PointD pt1, PointD pt2) =>
    sqr(pt1.x - pt2.x) + sqr(pt1.y - pt2.y);
Point64 midPoint(Point64 pt1, Point64 pt2) =>
    Point64((pt1.x + pt2.x) ~/ 2, (pt1.y + pt2.y) ~/ 2);
PointD midPointD(PointD pt1, PointD pt2) =>
    PointD((pt1.x + pt2.x) / 2, (pt1.y + pt2.y) / 2);
bool pointsNearEqual(PointD pt1, PointD pt2, double distanceSqrd) =>
    distanceSqrD(pt1, pt2) < distanceSqrd;

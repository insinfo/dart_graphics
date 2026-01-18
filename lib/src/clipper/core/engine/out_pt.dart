// OutPt: vertex data structure for clipping solutions
import '../../clipper.dart';
import '../clipper_internal.dart';

import 'out_rec.dart';

class OutPt {
  OutPt({required this.pt, required this.outrec}) : horz = null {
    next = this;
    prev = this;
  }

  Point64 pt;
  OutRec outrec;
  OutPt? next;
  late OutPt prev;
  HorzSegment? horz;

  double get area {
    // https://en.wikipedia.org/wiki/Shoelace_formula
    double area = 0.0;
    var op2 = this;
    do {
      area +=
          (op2.prev.pt.y + op2.pt.y).toDouble() *
          (op2.prev.pt.x - op2.pt.x).toDouble();
      op2 = op2.next!;
    } while (op2 != this);
    return area * 0.5;
  }

  OutPt duplicate({required bool insertAfter}) {
    final result = OutPt(pt: pt, outrec: outrec);
    if (insertAfter) {
      result.next = next;
      result.next!.prev = result;
      result.prev = this;
      next = result;
    } else {
      result.prev = prev;
      result.prev.next = result;
      result.next = this;
      prev = result;
    }
    return result;
  }

  Path64 get cleanPath {
    final result = <Point64>[];
    var op2 = this;
    while (op2.next != this &&
        ((op2.pt.x == op2.next!.pt.x && op2.pt.x == op2.prev.pt.x) ||
            (op2.pt.y == op2.next!.pt.y && op2.pt.y == op2.prev.pt.y))) {
      op2 = op2.next!;
    }
    result.add(op2.pt);
    OutPt prevOp = op2;
    op2 = op2.next!;
    while (op2 != this) {
      if ((op2.pt.x != op2.next!.pt.x || op2.pt.x != prevOp.pt.x) &&
          (op2.pt.y != op2.next!.pt.y || op2.pt.y != prevOp.pt.y)) {
        result.add(op2.pt);
        prevOp = op2;
      }
      op2 = op2.next!;
    }
    return result;
  }

  PointInPolygonResult pointInOpPolygon(Point64 pt) {
    if (this == next || prev == next) {
      return PointInPolygonResult.isOutside;
    }

    var op = this;
    var op2 = op;
    do {
      if (op.pt.y != pt.y) break;
      op = op.next!;
    } while (op != op2);
    if (op.pt.y == pt.y) {
      // not a proper polygon
      return PointInPolygonResult.isOutside;
    }
    // must be above or below to get here
    var isAbove = op.pt.y < pt.y, startingAbove = isAbove;
    var val = 0;

    op2 = op.next!;
    while (op2 != op) {
      if (isAbove) {
        while (op2 != op && op2.pt.y < pt.y) {
          op2 = op2.next!;
        }
      } else {
        while (op2 != op && op2.pt.y > pt.y) {
          op2 = op2.next!;
        }
      }
      if (op2 == op) {
        break;
      }

      // must have touched or crossed the pt.y horizontal
      // and this must happen an even number of times

      if (op2.pt.y == pt.y) // touching the horizontal
      {
        if (op2.pt.x == pt.x ||
            (op2.pt.y == op2.prev.pt.y &&
                (pt.x < op2.prev.pt.x) != (pt.x < op2.pt.x))) {
          return PointInPolygonResult.isOn;
        }
        op2 = op2.next!;
        if (op2 == op) {
          break;
        }
        continue;
      }

      if (op2.pt.x <= pt.x || op2.prev.pt.x <= pt.x) {
        if ((op2.prev.pt.x < pt.x && op2.pt.x < pt.x)) {
          val = 1 - val; // toggle val
        } else {
          double d = crossProduct(op2.prev.pt, op2.pt, pt);
          if (d == 0) return PointInPolygonResult.isOn;
          if ((d < 0) == isAbove) val = 1 - val;
        }
      }
      isAbove = !isAbove;
      op2 = op2.next!;
    }

    if (isAbove == startingAbove) {
      return val == 0
          ? PointInPolygonResult.isOutside
          : PointInPolygonResult.isInside;
    }
    final d = crossProduct(op2.prev.pt, op2.pt, pt);
    if (d == 0) {
      return PointInPolygonResult.isOn;
    }
    if ((d < 0) == isAbove) {
      val = 1 - val;
    }

    return val == 0
        ? PointInPolygonResult.isOutside
        : PointInPolygonResult.isInside;
  }

  bool insidePath2(OutPt op2) {
    // we need to make some accommodation for rounding errors
    // so we won't jump if the first vertex is found outside
    var outsideCnt = 0;
    var op = this;
    do {
      PointInPolygonResult result = op2.pointInOpPolygon(op.pt);
      switch (result) {
        case PointInPolygonResult.isOutside:
          ++outsideCnt;
        case PointInPolygonResult.isInside:
          --outsideCnt;
        case PointInPolygonResult.isOn:
      }
      op = op.next!;
    } while (op != this && outsideCnt.abs() < 2);
    if (outsideCnt.abs() > 1) {
      return outsideCnt < 0;
    }
    // since path1's location is still equivocal, check its midpoint
    final mp = cleanPath.bounds.midPoint;
    final path2 = op2.cleanPath;
    return path2.pointInPolygon(mp) != PointInPolygonResult.isOutside;
  }

  OutPt? dispose() {
    final result = next == this ? null : next;
    prev.next = next;
    next!.prev = prev;
    // op == null;
    return result;
  }
}

enum HorzPosition { bottom, middle, top }

class HorzSegment {
  HorzSegment(this.leftOp) : rightOp = null, leftToRight = true;

  OutPt? leftOp;
  OutPt? rightOp;
  bool leftToRight;

  bool setHeadingForward(OutPt opP, OutPt opN) {
    if (opP.pt.x == opN.pt.x) return false;
    if (opP.pt.x < opN.pt.x) {
      leftOp = opP;
      rightOp = opN;
      leftToRight = true;
    } else {
      leftOp = opN;
      rightOp = opP;
      leftToRight = false;
    }
    return true;
  }

  bool update() {
    final op = leftOp!;
    final outrec = op.outrec.realOutRec!;
    final outrecHasEdges = outrec.frontEdge != null;
    final currY = op.pt.y;
    OutPt opP = op, opN = op;
    if (outrecHasEdges) {
      var opA = outrec.pts!, opZ = opA.next!;
      while (opP != opZ && opP.prev.pt.y == currY) {
        opP = opP.prev;
      }
      while (opN != opA && opN.next!.pt.y == currY) {
        opN = opN.next!;
      }
    } else {
      while (opP.prev != opN && opP.prev.pt.y == currY) {
        opP = opP.prev;
      }
      while (opN.next != opP && opN.next!.pt.y == currY) {
        opN = opN.next!;
      }
    }
    final result = setHeadingForward(opP, opN) && leftOp!.horz == null;

    if (result) {
      leftOp!.horz = this;
    } else {
      rightOp = null; // (for sorting)
    }
    return result;
  }

  static int compare(HorzSegment? hs1, HorzSegment? hs2) {
    if (hs1 == null || hs2 == null) return 0;
    if (hs1.rightOp == null) {
      return hs2.rightOp == null ? 0 : 1;
    }
    if (hs2.rightOp == null) {
      return -1;
    }
    return hs1.leftOp!.pt.x.compareTo(hs2.leftOp!.pt.x);
  }
}

class HorzJoin {
  const HorzJoin(OutPt ltor, OutPt rtol) : op1 = ltor, op2 = rtol;

  final OutPt? op1;
  final OutPt? op2;
}

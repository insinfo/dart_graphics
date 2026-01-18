import '../../clipper.dart';

import 'local_minima.dart';
import 'out_pt.dart';
import 'out_rec.dart';
import 'vertex.dart';

class Active {
  Active({
    required this.bot,
    required this.top,
    required this.curX,
    required this.windDx,
    this.windCount = 0,
    this.windCount2 = 0,
    this.outrec,
    this.prevInAEL,
    this.nextInAEL,
    this.prevInSEL,
    this.nextInSEL,
    this.jump,
    this.vertexTop,
    required this.localMin,
    this.isLeftBound = false,
    this.joinWith = JoinWith.none,
  });

  Point64 bot;
  Point64 top;
  int curX; // current (updated at every new scanline)
  late double dx;
  final int windDx; // 1 or -1 depending on winding direction
  int windCount;
  int windCount2; // winding count of the opposite polytype
  OutRec? outrec;

  // AEL: 'active edge list' (Vatti's AET - active edge table)
  //     a linked list of all edges (from left to right) that are present
  //     (or 'active') within the current scanbeam (a horizontal 'beam' that
  //     sweeps from bottom to top over the paths in the clipping operation).
  Active? prevInAEL;
  Active? nextInAEL;

  // SEL: 'sorted edge list' (Vatti's ST - sorted table)
  //     linked list used when sorting edges into their new positions at the
  //     top of scanbeams, but also (re)used to process horizontals.
  Active? prevInSEL;
  Active? nextInSEL;
  Active? jump;
  Vertex? vertexTop;
  final LocalMinima localMin; // the bottom of an edge 'bound' (also Vatti)
  bool isLeftBound;
  JoinWith joinWith;

  PathType get polyType => localMin.polytype;
  bool get isHotEdge => outrec != null;
  bool get isOpen => localMin.isOpen;
  bool get isOpenEnd => localMin.isOpen && vertexTop!.isOpenEnd;

  Active? get prevHotEdge {
    var prev = prevInAEL;
    while (prev != null && (prev.isOpen || !prev.isHotEdge)) {
      prev = prev.prevInAEL;
    }
    return prev;
  }

  bool get isFront => this == outrec!.frontEdge;

  int topX(int currentY) {
    if (currentY == top.y || top.x == bot.x) {
      return top.x;
    }
    if (currentY == bot.y) {
      return bot.x;
    }
    return bot.x + (dx * (currentY - bot.y)).round();
  }

  bool get isHorizontal => top.y == bot.y;
  bool get isHeadingRightHorz => dx.isInfinite && dx.isNegative;
  bool get isHeadingLeftHorz => dx.isInfinite && !dx.isNegative;
  bool isSamePolyType(Active other) =>
      localMin.polytype == other.localMin.polytype;

  void setDx() {
    dx = _getDx(bot, top);
  }

  Vertex get nextVertex => windDx > 0 ? vertexTop!.next! : vertexTop!.prev!;
  Vertex get prevPrevVertex =>
      windDx > 0 ? vertexTop!.prev!.prev! : vertexTop!.next!.next!;
  bool get isMaxima => vertexTop!.isMaxima;

  Active? get maximaPair {
    var ae2 = nextInAEL;
    while (ae2 != null) {
      if (ae2.vertexTop == vertexTop) {
        return ae2; // Found!
      }
      ae2 = ae2.nextInAEL;
    }
    return null;
  }

  Vertex? get currYMaximaVertexOpen {
    var result = vertexTop;
    if (windDx > 0) {
      while (result!.next!.pt.y == result.pt.y &&
          !result.flags.isOpenEnd &&
          !result.flags.isLocalMax) {
        result = result.next;
      }
    } else {
      while (result!.prev!.pt.y == result.pt.y &&
          !result.flags.isOpenEnd &&
          !result.flags.isLocalMax) {
        result = result.prev;
      }
    }
    if (!result.isMaxima) {
      result = null; // not a maxima
    }
    return result;
  }

  Vertex? get currYMaximaVertex {
    Vertex? result = vertexTop;
    if (windDx > 0) {
      while (result!.next!.pt.y == result.pt.y) {
        result = result.next;
      }
    } else {
      while (result!.prev!.pt.y == result.pt.y) {
        result = result.prev;
      }
    }
    if (!result.isMaxima) {
      result = null; // not a maxima
    }
    return result;
  }

  void swapOutrecWith(Active ae2) {
    var or1 = outrec; // at least one edge has
    var or2 = ae2.outrec; // an assigned outrec
    if (or1 == or2) {
      var ae = or1!.frontEdge;
      or1.frontEdge = or1.backEdge;
      or1.backEdge = ae;
      return;
    }

    if (or1 != null) {
      if (this == or1.frontEdge) {
        or1.frontEdge = ae2;
      } else {
        or1.backEdge = ae2;
      }
    }

    if (or2 != null) {
      if (ae2 == or2.frontEdge) {
        or2.frontEdge = this;
      } else {
        or2.backEdge = this;
      }
    }

    outrec = or2;
    ae2.outrec = or1;
  }

  void uncoupleOutRec() {
    final or = outrec;
    if (or == null) return;
    or.frontEdge!.outrec = null;
    or.backEdge!.outrec = null;
    or.frontEdge = null;
    or.backEdge = null;
  }

  bool get outrecIsAscending => (this == outrec!.frontEdge);

  bool get isJoined => joinWith != JoinWith.none;

  Active? findEdgeWithMatchingLocMin() {
    var result = nextInAEL;
    while (result != null) {
      if (result.localMin == localMin) {
        return result;
      }
      if (!result.isHorizontal && bot != result.bot) {
        result = null;
      } else {
        result = result.nextInAEL;
      }
    }
    result = prevInAEL;
    while (result != null) {
      if (result.localMin == localMin) {
        return result;
      }
      if (!result.isHorizontal && bot != result.bot) {
        return null;
      }
      result = result.prevInAEL;
    }
    return result;
  }

  Active? extractFromSEL() {
    var res = nextInSEL;
    res?.prevInSEL = prevInSEL;
    prevInSEL!.nextInSEL = res;
    return res;
  }

  void insert1Before2InSEL(Active ae2) {
    prevInSEL = ae2.prevInSEL;
    prevInSEL?.nextInSEL = this;
    nextInSEL = ae2;
    ae2.prevInSEL = this;
  }

  (bool, int, int) resetHorzDirection(Vertex? vertexMax) {
    if (bot.x == top.x) {
      // the horizontal edge is going nowhere ...
      var ae = nextInAEL;
      while (ae != null && ae.vertexTop != vertexMax) {
        ae = ae.nextInAEL;
      }
      return (ae != null, curX, curX);
    }

    if (curX < top.x) {
      return (true, curX, top.x);
    }
    return (false, top.x, curX); // right to left
  }

  OutPt get lastOp =>
      (this == outrec!.frontEdge) ? outrec!.pts! : outrec!.pts!.next!;

  static double _getDx(Point64 pt1, Point64 pt2) {
    /*******************************************************************************
     *  Dx:                             0(90deg)                                   *
     *                                  |                                          *
     *               +inf (180deg) <--- o --. -inf (0deg)                          *
     *******************************************************************************/
    final dy = pt2.y - pt1.y;
    if (dy != 0) return (pt2.x - pt1.x) / dy;
    return pt2.x > pt1.x ? double.negativeInfinity : double.infinity;
  }
}

enum JoinWith { none, left, right }

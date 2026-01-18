import '../../clipper.dart';
import '../clipper_internal.dart';
import 'package:collection/collection.dart';

import 'active.dart';
import 'clipper_engine.dart';
import 'intersect_node.dart';
import 'local_minima.dart';
import 'out_pt.dart';
import 'out_rec.dart';
import 'vertex.dart';

/// After an intersection has been found, this callback can adjust the new point's Z level by returning a non-null
/// value. [intersectPt] contains an initial guess.
typedef ZCallback64 =
    int? Function(
      Point64 bot1,
      Point64 top1,
      Point64 bot2,
      Point64 top2,
      Point64 intersectPt,
    );

class ClipperBase {
  ClipperBase();

  ClipType _cliptype = ClipType.noClip;
  FillRule _fillrule = FillRule.evenOdd;
  Active? _actives;
  Active? _sel;
  final _minimaList = <LocalMinima>[];
  final _intersectList = <IntersectNode>[];
  final _vertexList = <Vertex>[];
  final _outrecList = <OutRec>[];
  final _scanlineList = <int>[];
  final _horzSegList = <HorzSegment>[];
  final _horzJoinList = <HorzJoin>[];
  var _currentLocMin = 0;
  var _currentBotY = 0;
  var _isSortedMinimaList = false;
  var _hasOpenPaths = false;
  var usingPolytree = false;
  var succeeded = false;
  var preserveCollinear = true;
  var reverseSolution = false;
  var defaultZ = 0;
  ZCallback64? zCallback;

  Point64 _setZ(Active e1, Active e2, Point64 intersectPt) {
    if (zCallback == null) {
      return intersectPt;
    }

    bool equal(Point64 pt1, Point64 pt2) => pt1.x == pt2.x && pt1.y == pt2.y;

    // prioritize subject vertices over clip vertices
    // and pass the subject vertices before clip vertices in the callback
    if (e1.polyType == PathType.subject) {
      if (equal(intersectPt, e1.bot)) {
        intersectPt = Point64(intersectPt.x, intersectPt.y, e1.bot.z);
      } else if (equal(intersectPt, e1.top)) {
        intersectPt = Point64(intersectPt.x, intersectPt.y, e1.top.z);
      } else if (equal(intersectPt, e2.bot)) {
        intersectPt = Point64(intersectPt.x, intersectPt.y, e2.bot.z);
      } else if (equal(intersectPt, e2.top)) {
        intersectPt = Point64(intersectPt.x, intersectPt.y, e2.top.z);
      } else {
        intersectPt = Point64(intersectPt.x, intersectPt.y, defaultZ);
      }
    } else {
      if (equal(intersectPt, e2.bot)) {
        intersectPt = Point64(intersectPt.x, intersectPt.y, e2.bot.z);
      } else if (equal(intersectPt, e2.top)) {
        intersectPt = Point64(intersectPt.x, intersectPt.y, e2.top.z);
      } else if (equal(intersectPt, e1.bot)) {
        intersectPt = Point64(intersectPt.x, intersectPt.y, e1.bot.z);
      } else if (equal(intersectPt, e1.top)) {
        intersectPt = Point64(intersectPt.x, intersectPt.y, e1.top.z);
      } else {
        intersectPt = Point64(intersectPt.x, intersectPt.y, defaultZ);
      }
    }
    final z = zCallback!(e2.bot, e2.top, e1.bot, e1.top, intersectPt);
    if (z == null) {
      return intersectPt;
    }
    return Point64(intersectPt.x, intersectPt.y, z);
  }

  static double _areaTriangle(Point64 pt1, Point64 pt2, Point64 pt3) {
    return (pt3.y + pt1.y).toDouble() * (pt3.x - pt1.x).toDouble() +
        (pt1.y + pt2.y).toDouble() * (pt1.x - pt2.x).toDouble() +
        (pt2.y + pt3.y).toDouble() * (pt2.x - pt3.x).toDouble();
  }

  void clearSolutionOnly() {
    while (_actives != null) {
      _deleteFromAEL(_actives!);
    }
    _scanlineList.clear();
    _disposeIntersectNodes();
    _outrecList.clear();
    _horzSegList.clear();
    _horzJoinList.clear();
  }

  void clear() {
    clearSolutionOnly();
    _minimaList.clear();
    _vertexList.clear();
    _currentLocMin = 0;
    _isSortedMinimaList = false;
    _hasOpenPaths = false;
  }

  void _reset() {
    if (!_isSortedMinimaList) {
      _minimaList.sort(LocalMinima.compare);
      _isSortedMinimaList = true;
    }

    for (final i in _minimaList.reversed) {
      _scanlineList.add(i.vertex.pt.y);
    }

    _currentBotY = 0;
    _currentLocMin = 0;
    _actives = null;
    _sel = null;
    succeeded = true;
  }

  void _insertScanline(int y) {
    int index = lowerBound(_scanlineList, y);
    if (index < _scanlineList.length && _scanlineList[index] == y) {
      return;
    }
    _scanlineList.insert(index, y);
  }

  (bool, int) _popScanline() {
    if (_scanlineList.isEmpty) {
      return (false, 0);
    }

    final y = _scanlineList.removeLast();
    while (_scanlineList.isNotEmpty && y == _scanlineList.last) {
      _scanlineList.removeLast();
    }
    return (true, y);
  }

  bool _hasLocMinAtY(int y) =>
      (_currentLocMin < _minimaList.length &&
          _minimaList[_currentLocMin].vertex.pt.y == y);

  LocalMinima _popLocalMinima() => _minimaList[_currentLocMin++];

  void addPaths(Paths64 paths, PathType polytype, {bool isOpen = false}) {
    if (isOpen) {
      _hasOpenPaths = true;
    }
    _isSortedMinimaList = false;
    addPathsToVertexList(
      paths: paths,
      polytype: polytype,
      isOpen: isOpen,
      minimaList: _minimaList,
      vertexList: _vertexList,
    );
  }

  bool _isContributingClosed(Active ae) {
    switch (_fillrule) {
      case FillRule.positive:
        if (ae.windCount != 1) return false;
      case FillRule.negative:
        if (ae.windCount != -1) return false;
      case FillRule.nonZero:
        if (ae.windCount.abs() != 1) return false;
      case FillRule.evenOdd:
      // do nothing
    }

    switch (_cliptype) {
      case ClipType.intersection:
        return switch (_fillrule) {
          FillRule.positive => ae.windCount2 > 0,
          FillRule.negative => ae.windCount2 < 0,
          _ => ae.windCount2 != 0,
        };

      case ClipType.union:
        return switch (_fillrule) {
          FillRule.positive => ae.windCount2 <= 0,
          FillRule.negative => ae.windCount2 >= 0,
          _ => ae.windCount2 == 0,
        };

      case ClipType.difference:
        bool result = switch (_fillrule) {
          FillRule.positive => (ae.windCount2 <= 0),
          FillRule.negative => (ae.windCount2 >= 0),
          _ => (ae.windCount2 == 0),
        };
        return (ae.polyType == PathType.subject) ? result : !result;

      case ClipType.xor:
        return true; // XOr is always contributing unless open

      default:
        return false;
    }
  }

  bool _isContributingOpen(Active ae) {
    bool isInClip, isInSubj;
    switch (_fillrule) {
      case FillRule.positive:
        isInSubj = ae.windCount > 0;
        isInClip = ae.windCount2 > 0;
      case FillRule.negative:
        isInSubj = ae.windCount < 0;
        isInClip = ae.windCount2 < 0;
      default:
        isInSubj = ae.windCount != 0;
        isInClip = ae.windCount2 != 0;
    }

    return switch (_cliptype) {
      ClipType.intersection => isInClip,
      ClipType.union => !isInSubj && !isInClip,
      _ => !isInClip,
    };
  }

  void _setWindCountForClosedPathEdge(Active ae) {
    // Wind counts refer to polygon regions not edges, so here an edge's WindCnt
    // indicates the higher of the wind counts for the two regions touching the
    // edge. (nb: Adjacent regions can only ever have their wind counts differ by
    // one. Also, open paths have no meaningful wind directions or counts.)

    Active? ae2 = ae.prevInAEL;
    // find the nearest closed path edge of the same PolyType in AEL (heading left)
    PathType pt = ae.polyType;
    while (ae2 != null && (ae2.polyType != pt || ae2.isOpen)) {
      ae2 = ae2.prevInAEL;
    }

    if (ae2 == null) {
      ae.windCount = ae.windDx;
      ae2 = _actives;
    } else if (_fillrule == FillRule.evenOdd) {
      ae.windCount = ae.windDx;
      ae.windCount2 = ae2.windCount2;
      ae2 = ae2.nextInAEL;
    } else {
      // NonZero, positive, or negative filling here ...
      // when e2's WindCnt is in the SAME direction as its WindDx,
      // then polygon will fill on the right of 'e2' (and 'e' will be inside)
      // nb: neither e2.WindCnt nor e2.WindDx should ever be 0.
      if (ae2.windCount * ae2.windDx < 0) {
        // opposite directions so 'ae' is outside 'ae2' ...
        if (ae2.windCount.abs() > 1) {
          // outside prev poly but still inside another.
          if (ae2.windDx * ae.windDx < 0) {
            // reversing direction so use the same WC
            ae.windCount = ae2.windCount;
          } else {
            // otherwise keep 'reducing' the WC by 1 (i.e. towards 0) ...
            ae.windCount = ae2.windCount + ae.windDx;
          }
        } else {
          // now outside all polys of same polytype so set own WC ...
          ae.windCount = (ae.isOpen ? 1 : ae.windDx);
        }
      } else {
        //'ae' must be inside 'ae2'
        if (ae2.windDx * ae.windDx < 0) {
          // reversing direction so use the same WC
          ae.windCount = ae2.windCount;
        } else {
          // otherwise keep 'increasing' the WC by 1 (i.e. away from 0) ...
          ae.windCount = ae2.windCount + ae.windDx;
        }
      }

      ae.windCount2 = ae2.windCount2;
      ae2 = ae2.nextInAEL; // i.e. get ready to calc WindCnt2
    }

    // update windCount2 ...
    if (_fillrule == FillRule.evenOdd) {
      while (ae2 != ae) {
        if (ae2!.polyType != pt && !ae2.isOpen) {
          ae.windCount2 = (ae.windCount2 == 0 ? 1 : 0);
        }
        ae2 = ae2.nextInAEL;
      }
    } else {
      while (ae2 != ae) {
        if (ae2!.polyType != pt && !ae2.isOpen) {
          ae.windCount2 += ae2.windDx;
        }
        ae2 = ae2.nextInAEL;
      }
    }
  }

  void _setWindCountForOpenPathEdge(Active ae) {
    var ae2 = _actives;
    if (_fillrule == FillRule.evenOdd) {
      int cnt1 = 0, cnt2 = 0;
      while (ae2 != ae) {
        if (ae2!.polyType == PathType.clip) {
          cnt2++;
        } else if (!ae2.isOpen) {
          cnt1++;
        }
        ae2 = ae2.nextInAEL;
      }

      ae.windCount = (cnt1.isOdd ? 1 : 0);
      ae.windCount2 = (cnt2.isOdd ? 1 : 0);
    } else {
      while (ae2 != ae) {
        if (ae2!.polyType == PathType.clip) {
          ae.windCount2 += ae2.windDx;
        } else if (!ae2.isOpen) {
          ae.windCount += ae2.windDx;
        }
        ae2 = ae2.nextInAEL;
      }
    }
  }

  static bool _isValidAelOrder(Active resident, Active newcomer) {
    if (newcomer.curX != resident.curX) {
      return newcomer.curX > resident.curX;
    }

    // get the turning direction  a1.top, a2.bot, a2.top
    double d = crossProduct(resident.top, newcomer.bot, newcomer.top);
    if (d != 0) {
      return (d < 0);
    }

    // edges must be collinear to get here

    // for starting open paths, place them according to
    // the direction they're about to turn
    if (!resident.isMaxima && (resident.top.y > newcomer.top.y)) {
      return crossProduct(newcomer.bot, resident.top, resident.nextVertex.pt) <=
          0;
    }

    if (!newcomer.isMaxima && (newcomer.top.y > resident.top.y)) {
      return crossProduct(newcomer.bot, newcomer.top, newcomer.nextVertex.pt) >=
          0;
    }

    int y = newcomer.bot.y;
    bool newcomerIsLeft = newcomer.isLeftBound;

    if (resident.bot.y != y || resident.localMin.vertex.pt.y != y) {
      return newcomer.isLeftBound;
    }
    // resident must also have just been inserted
    if (resident.isLeftBound != newcomerIsLeft) {
      return newcomerIsLeft;
    }
    if (isCollinear(resident.prevPrevVertex.pt, resident.bot, resident.top)) {
      return true;
    }
    // compare turning direction of the alternate bound
    return (crossProduct(
              resident.prevPrevVertex.pt,
              newcomer.bot,
              newcomer.prevPrevVertex.pt,
            ) >
            0) ==
        newcomerIsLeft;
  }

  void _insertLeftEdge(Active ae) {
    if (_actives == null) {
      ae.prevInAEL = null;
      ae.nextInAEL = null;
      _actives = ae;
    } else if (!_isValidAelOrder(_actives!, ae)) {
      ae.prevInAEL = null;
      ae.nextInAEL = _actives;
      _actives!.prevInAEL = ae;
      _actives = ae;
    } else {
      var ae2 = _actives!;
      while (ae2.nextInAEL != null && _isValidAelOrder(ae2.nextInAEL!, ae)) {
        ae2 = ae2.nextInAEL!;
      }
      //don't separate joined edges
      if (ae2.joinWith == JoinWith.right) {
        ae2 = ae2.nextInAEL!;
      }
      ae.nextInAEL = ae2.nextInAEL;
      if (ae2.nextInAEL != null) {
        ae2.nextInAEL!.prevInAEL = ae;
      }
      ae.prevInAEL = ae2;
      ae2.nextInAEL = ae;
    }
  }

  static void _insertRightEdge(Active ae, Active ae2) {
    ae2.nextInAEL = ae.nextInAEL;
    if (ae.nextInAEL != null) {
      ae.nextInAEL!.prevInAEL = ae2;
    }
    ae2.prevInAEL = ae;
    ae.nextInAEL = ae2;
  }

  void _insertLocalMinimaIntoAEL(int botY) {
    // Add any local minima (if any) at BotY ...
    // NB horizontal local minima edges should contain locMin.vertex.prev
    while (_hasLocMinAtY(botY)) {
      final localMinima = _popLocalMinima();
      Active? leftBound;
      if (localMinima.vertex.flags.isOpenStart) {
        leftBound = null;
      } else {
        leftBound = Active(
          bot: localMinima.vertex.pt,
          curX: localMinima.vertex.pt.x,
          windDx: -1,
          vertexTop: localMinima.vertex.prev,
          top: localMinima.vertex.prev!.pt,
          outrec: null,
          localMin: localMinima,
        )..setDx();
      }

      Active? rightBound;
      if (localMinima.vertex.flags.isOpenEnd) {
        rightBound = null;
      } else {
        rightBound = Active(
          bot: localMinima.vertex.pt,
          curX: localMinima.vertex.pt.x,
          windDx: 1,
          vertexTop: localMinima.vertex.next, // i.e. ascending
          top: localMinima.vertex.next!.pt,
          outrec: null,
          localMin: localMinima,
        )..setDx();
      }

      // Currently LeftB is just the descending bound and RightB is the ascending.
      // Now if the LeftB isn't on the left of RightB then we need swap them.
      if (leftBound != null && rightBound != null) {
        if (leftBound.isHorizontal) {
          if (leftBound.isHeadingRightHorz) {
            (leftBound, rightBound) = (rightBound, leftBound);
          }
        } else if (rightBound.isHorizontal) {
          if (rightBound.isHeadingLeftHorz) {
            (leftBound, rightBound) = (rightBound, leftBound);
          }
        } else if (leftBound.dx < rightBound.dx) {
          (leftBound, rightBound) = (rightBound, leftBound);
        }
        //so when leftBound has windDx == 1, the polygon will be oriented
        //counter-clockwise in Cartesian coords (clockwise with inverted Y).
      } else if (leftBound == null) {
        leftBound = rightBound;
        rightBound = null;
      }

      bool contributing;
      leftBound!.isLeftBound = true;
      _insertLeftEdge(leftBound);

      if (leftBound.isOpen) {
        _setWindCountForOpenPathEdge(leftBound);
        contributing = _isContributingOpen(leftBound);
      } else {
        _setWindCountForClosedPathEdge(leftBound);
        contributing = _isContributingClosed(leftBound);
      }

      if (rightBound != null) {
        rightBound.windCount = leftBound.windCount;
        rightBound.windCount2 = leftBound.windCount2;
        _insertRightEdge(leftBound, rightBound); ///////

        if (contributing) {
          _addLocalMinPoly(leftBound, rightBound, leftBound.bot, isNew: true);
          if (!leftBound.isHorizontal) {
            _checkJoinLeft(leftBound, leftBound.bot);
          }
        }

        while (rightBound.nextInAEL != null &&
            _isValidAelOrder(rightBound.nextInAEL!, rightBound)) {
          _intersectEdges(rightBound, rightBound.nextInAEL!, rightBound.bot);
          _swapPositionsInAEL(rightBound, rightBound.nextInAEL!);
        }

        if (rightBound.isHorizontal) {
          _pushHorz(rightBound);
        } else {
          _checkJoinRight(rightBound, rightBound.bot);
          _insertScanline(rightBound.top.y);
        }
      } else if (contributing) {
        _startOpenPath(leftBound, leftBound.bot);
      }

      if (leftBound.isHorizontal) {
        _pushHorz(leftBound);
      } else {
        _insertScanline(leftBound.top.y);
      }
    } // while (HasLocMinAtY())
  }

  void _pushHorz(Active ae) {
    ae.nextInSEL = _sel;
    _sel = ae;
  }

  (bool, Active?) _popHorz() {
    final ae = _sel;
    if (_sel == null) {
      return (false, null);
    }
    _sel = _sel!.nextInSEL;
    return (true, ae);
  }

  OutPt _addLocalMinPoly(
    Active ae1,
    Active ae2,
    Point64 pt, {
    bool isNew = false,
  }) {
    OutRec outrec = _newOutRec();
    ae1.outrec = outrec;
    ae2.outrec = outrec;

    if (ae1.isOpen) {
      //print('#0: setting owner of ${outrec.idx} to null');
      outrec.owner = null;
      outrec.isOpen = true;
      if (ae1.windDx > 0) {
        outrec.setSides(ae1, ae2);
      } else {
        outrec.setSides(ae2, ae1);
      }
    } else {
      outrec.isOpen = false;
      Active? prevHotEdge = ae1.prevHotEdge;
      // e.windDx is the winding direction of the **input** paths
      // and unrelated to the winding direction of output polygons.
      // Output orientation is determined by e.outrec.frontE which is
      // the ascending edge (see AddLocalMinPoly).
      if (prevHotEdge != null) {
        if (usingPolytree) {
          outrec.setOwner(prevHotEdge.outrec!);
        }
        //print('#1: setting owner of ${outrec.idx} to ${prevHotEdge.outrec?.idx}');
        outrec.owner = prevHotEdge.outrec;
        if (prevHotEdge.outrecIsAscending == isNew) {
          outrec.setSides(ae2, ae1);
        } else {
          outrec.setSides(ae1, ae2);
        }
      } else {
        //print('#2: setting owner of ${outrec.idx} to null');
        outrec.owner = null;
        if (isNew) {
          outrec.setSides(ae1, ae2);
        } else {
          outrec.setSides(ae2, ae1);
        }
      }
    }

    final op = OutPt(pt: pt, outrec: outrec);
    outrec.pts = op;
    return op;
  }

  OutPt? _addLocalMaxPoly(Active ae1, Active ae2, Point64 pt) {
    if (ae1.isJoined) {
      _split(ae1, pt);
    }
    if (ae2.isJoined) {
      _split(ae2, pt);
    }

    if (ae1.isFront == ae2.isFront) {
      if (ae1.isOpenEnd) {
        ae1.outrec!.swapFrontBackSides();
      } else if (ae2.isOpenEnd) {
        ae2.outrec!.swapFrontBackSides();
      } else {
        succeeded = false;
        return null;
      }
    }

    OutPt result = _addOutPt(ae1, pt);
    if (ae1.outrec == ae2.outrec) {
      OutRec outrec = ae1.outrec!;
      outrec.pts = result;

      if (usingPolytree) {
        Active? e = ae1.prevHotEdge;
        if (e == null) {
          //print('#3: setting owner of ${outrec.idx} to null');
          outrec.owner = null;
        } else {
          outrec.setOwner(e.outrec!);
        }
        // nb: outRec.owner here is likely NOT the real
        // owner but this will be fixed in DeepCheckOwner()
      }
      ae1.uncoupleOutRec();
    }
    // and to preserve the winding orientation of outrec ...
    else if (ae1.isOpen) {
      if (ae1.windDx < 0) {
        _joinOutrecPaths(ae1, ae2);
      } else {
        _joinOutrecPaths(ae2, ae1);
      }
    } else if (ae1.outrec!.idx < ae2.outrec!.idx) {
      _joinOutrecPaths(ae1, ae2);
    } else {
      _joinOutrecPaths(ae2, ae1);
    }
    return result;
  }

  static void _joinOutrecPaths(Active ae1, Active ae2) {
    // join ae2 outrec path onto ae1 outrec path and then delete ae2 outrec path
    // pointers. (NB Only very rarely do the joining ends share the same coords.)
    OutPt p1Start = ae1.outrec!.pts!;
    OutPt p2Start = ae2.outrec!.pts!;
    OutPt p1End = p1Start.next!;
    OutPt p2End = p2Start.next!;
    if (ae1.isFront) {
      p2End.prev = p1Start;
      p1Start.next = p2End;
      p2Start.next = p1End;
      p1End.prev = p2Start;
      ae1.outrec!.pts = p2Start;
      // nb: if e1.isOpen then e1 & e2 must be a 'maximaPair'
      ae1.outrec!.frontEdge = ae2.outrec!.frontEdge;
      if (ae1.outrec!.frontEdge != null) {
        ae1.outrec!.frontEdge!.outrec = ae1.outrec;
      }
    } else {
      p1End.prev = p2Start;
      p2Start.next = p1End;
      p1Start.next = p2End;
      p2End.prev = p1Start;

      ae1.outrec!.backEdge = ae2.outrec!.backEdge;
      if (ae1.outrec!.backEdge != null) {
        ae1.outrec!.backEdge!.outrec = ae1.outrec;
      }
    }

    // after joining, the ae2.OutRec must contains no vertices ...
    ae2.outrec!.frontEdge = null;
    ae2.outrec!.backEdge = null;
    ae2.outrec!.pts = null;
    ae2.outrec!.setOwner(ae1.outrec!);

    if (ae1.isOpenEnd) {
      ae2.outrec!.pts = ae1.outrec!.pts;
      ae1.outrec!.pts = null;
    }

    // and ae1 and ae2 are maxima and are about to be dropped from the Actives list.
    ae1.outrec = null;
    ae2.outrec = null;
  }

  static OutPt _addOutPt(Active ae, Point64 pt) {
    // Outrec.OutPts: a circular doubly-linked-list of POutPt where ...
    // opFront[.Prev]* ~~~> opBack & opBack == opFront.Next
    final outrec = ae.outrec!;
    final toFront = ae.isFront;
    final opFront = outrec.pts!;
    final opBack = opFront.next!;

    if (toFront && pt == opFront.pt) {
      return opFront;
    }
    if (!toFront && pt == opBack.pt) {
      return opBack;
    }

    final newOp = OutPt(pt: pt, outrec: outrec);
    opBack.prev = newOp;
    newOp.prev = opFront;
    newOp.next = opBack;
    opFront.next = newOp;
    if (toFront) {
      outrec.pts = newOp;
    }
    return newOp;
  }

  OutRec _newOutRec() {
    final result = OutRec(idx: _outrecList.length);
    _outrecList.add(result);
    return result;
  }

  OutPt _startOpenPath(Active ae, Point64 pt) {
    final outrec = _newOutRec();
    outrec.isOpen = true;
    if (ae.windDx > 0) {
      outrec.frontEdge = ae;
      outrec.backEdge = null;
    } else {
      outrec.frontEdge = null;
      outrec.backEdge = ae;
    }

    ae.outrec = outrec;
    final op = OutPt(pt: pt, outrec: outrec);
    outrec.pts = op;
    return op;
  }

  void _updateEdgeIntoAEL(Active ae) {
    ae.bot = ae.top;
    ae.vertexTop = ae.nextVertex;
    ae.top = ae.vertexTop!.pt;
    ae.curX = ae.bot.x;
    ae.setDx();

    if (ae.isJoined) {
      _split(ae, ae.bot);
    }

    if (ae.isHorizontal) {
      if (!ae.isOpen) {
        _trimHorz(ae, preserveCollinear);
      }
      return;
    }
    _insertScanline(ae.top.y);

    _checkJoinLeft(ae, ae.bot);
    _checkJoinRight(ae, ae.bot, checkCurrX: true); // (#500)
  }

  void _intersectEdges(Active ae1, Active ae2, Point64 pt) {
    OutPt? resultOp;
    // MANAGE OPEN PATH INTERSECTIONS SEPARATELY ...
    if (_hasOpenPaths && (ae1.isOpen || ae2.isOpen)) {
      if (ae1.isOpen && ae2.isOpen) {
        return;
      }
      // the following line avoids duplicating quite a bit of code
      if (ae2.isOpen) {
        (ae1, ae2) = (ae2, ae1);
      }
      if (ae2.isJoined) {
        _split(ae2, pt); // needed for safety
      }

      if (_cliptype == ClipType.union) {
        if (!ae2.isHotEdge) {
          return;
        }
      } else if (ae2.localMin.polytype == PathType.subject) {
        return;
      }

      switch (_fillrule) {
        case FillRule.positive:
          if (ae2.windCount != 1) return;
          break;
        case FillRule.negative:
          if (ae2.windCount != -1) return;
          break;
        default:
          if (ae2.windCount.abs() != 1) return;
          break;
      }

      // toggle contribution ...
      if (ae1.isHotEdge) {
        resultOp = _addOutPt(ae1, pt);
        resultOp.pt = _setZ(ae1, ae2, resultOp.pt);
        if (ae1.isFront) {
          ae1.outrec!.frontEdge = null;
        } else {
          ae1.outrec!.backEdge = null;
        }
        ae1.outrec = null;
      }
      // horizontal edges can pass under open paths at a LocMins
      else if (pt == ae1.localMin.vertex.pt && !ae1.localMin.vertex.isOpenEnd) {
        // find the other side of the LocMin and
        // if it's 'hot' join up with it ...
        var ae3 = ae1.findEdgeWithMatchingLocMin();
        if (ae3 != null && ae3.isHotEdge) {
          ae1.outrec = ae3.outrec;
          if (ae1.windDx > 0) {
            ae3.outrec!.setSides(ae1, ae3);
          } else {
            ae3.outrec!.setSides(ae3, ae1);
          }
          return;
        }

        resultOp = _startOpenPath(ae1, pt);
      } else {
        resultOp = _startOpenPath(ae1, pt);
      }

      resultOp.pt = _setZ(ae1, ae2, resultOp.pt);
      return;
    }

    // MANAGING CLOSED PATHS FROM HERE ON
    if (ae1.isJoined) {
      _split(ae1, pt);
    }
    if (ae2.isJoined) {
      _split(ae2, pt);
    }

    // UPDATE WINDING COUNTS...

    int oldE1WindCount, oldE2WindCount;
    if (ae1.localMin.polytype == ae2.localMin.polytype) {
      if (_fillrule == FillRule.evenOdd) {
        oldE1WindCount = ae1.windCount;
        ae1.windCount = ae2.windCount;
        ae2.windCount = oldE1WindCount;
      } else {
        if (ae1.windCount + ae2.windDx == 0) {
          ae1.windCount = -ae1.windCount;
        } else {
          ae1.windCount += ae2.windDx;
        }
        if (ae2.windCount - ae1.windDx == 0) {
          ae2.windCount = -ae2.windCount;
        } else {
          ae2.windCount -= ae1.windDx;
        }
      }
    } else {
      if (_fillrule != FillRule.evenOdd) {
        ae1.windCount2 += ae2.windDx;
      } else {
        ae1.windCount2 = (ae1.windCount2 == 0 ? 1 : 0);
      }
      if (_fillrule != FillRule.evenOdd) {
        ae2.windCount2 -= ae1.windDx;
      } else {
        ae2.windCount2 = (ae2.windCount2 == 0 ? 1 : 0);
      }
    }

    switch (_fillrule) {
      case FillRule.positive:
        oldE1WindCount = ae1.windCount;
        oldE2WindCount = ae2.windCount;
        break;
      case FillRule.negative:
        oldE1WindCount = -ae1.windCount;
        oldE2WindCount = -ae2.windCount;
        break;
      default:
        oldE1WindCount = ae1.windCount.abs();
        oldE2WindCount = ae2.windCount.abs();
        break;
    }

    bool e1WindCountIs0or1 = oldE1WindCount == 0 || oldE1WindCount == 1;
    bool e2WindCountIs0or1 = oldE2WindCount == 0 || oldE2WindCount == 1;

    if ((!ae1.isHotEdge && !e1WindCountIs0or1) ||
        (!ae2.isHotEdge && !e2WindCountIs0or1)) {
      return;
    }

    // NOW PROCESS THE INTERSECTION ...

    // if both edges are 'hot' ...
    if (ae1.isHotEdge && ae2.isHotEdge) {
      if ((oldE1WindCount != 0 && oldE1WindCount != 1) ||
          (oldE2WindCount != 0 && oldE2WindCount != 1) ||
          (ae1.localMin.polytype != ae2.localMin.polytype &&
              _cliptype != ClipType.xor)) {
        resultOp = _addLocalMaxPoly(ae1, ae2, pt);
        if (resultOp != null) {
          resultOp.pt = _setZ(ae1, ae2, resultOp.pt);
        }
      } else if (ae1.isFront || (ae1.outrec == ae2.outrec)) {
        // this 'else if' condition isn't strictly needed but
        // it's sensible to split polygons that only touch at
        // a common vertex (not at common edges).
        resultOp = _addLocalMaxPoly(ae1, ae2, pt);
        final op2 = _addLocalMinPoly(ae1, ae2, pt);
        if (resultOp != null) {
          resultOp.pt = _setZ(ae1, ae2, resultOp.pt);
        }
        op2.pt = _setZ(ae1, ae2, op2.pt);
      } else {
        // can't treat as maxima & minima
        resultOp = _addOutPt(ae1, pt);
        final op2 = _addOutPt(ae2, pt);
        resultOp.pt = _setZ(ae1, ae2, resultOp.pt);
        op2.pt = _setZ(ae1, ae2, op2.pt);
        ae1.swapOutrecWith(ae2);
      }
    }
    // if one or other edge is 'hot' ...
    else if (ae1.isHotEdge) {
      resultOp = _addOutPt(ae1, pt);
      resultOp.pt = _setZ(ae1, ae2, resultOp.pt);
      ae1.swapOutrecWith(ae2);
    } else if (ae2.isHotEdge) {
      resultOp = _addOutPt(ae2, pt);
      resultOp.pt = _setZ(ae1, ae2, resultOp.pt);
      ae1.swapOutrecWith(ae2);
    }
    // neither edge is 'hot'
    else {
      int e1Wc2, e2Wc2;
      switch (_fillrule) {
        case FillRule.positive:
          e1Wc2 = ae1.windCount2;
          e2Wc2 = ae2.windCount2;
          break;
        case FillRule.negative:
          e1Wc2 = -ae1.windCount2;
          e2Wc2 = -ae2.windCount2;
          break;
        default:
          e1Wc2 = ae1.windCount2.abs();
          e2Wc2 = ae2.windCount2.abs();
          break;
      }

      if (!ae1.isSamePolyType(ae2)) {
        resultOp = _addLocalMinPoly(ae1, ae2, pt);
        resultOp.pt = _setZ(ae1, ae2, resultOp.pt);
      } else if (oldE1WindCount == 1 && oldE2WindCount == 1) {
        resultOp = null;
        switch (_cliptype) {
          case ClipType.union:
            if (e1Wc2 > 0 && e2Wc2 > 0) return;
            resultOp = _addLocalMinPoly(ae1, ae2, pt);
            break;

          case ClipType.difference:
            if (((ae1.polyType == PathType.clip) &&
                    (e1Wc2 > 0) &&
                    (e2Wc2 > 0)) ||
                ((ae1.polyType == PathType.subject) &&
                    (e1Wc2 <= 0) &&
                    (e2Wc2 <= 0))) {
              resultOp = _addLocalMinPoly(ae1, ae2, pt);
            }

            break;

          case ClipType.xor:
            resultOp = _addLocalMinPoly(ae1, ae2, pt);
            break;

          default: // ClipType.Intersection:
            if (e1Wc2 <= 0 || e2Wc2 <= 0) return;
            resultOp = _addLocalMinPoly(ae1, ae2, pt);
            break;
        }
        if (resultOp != null) {
          resultOp.pt = _setZ(ae1, ae2, resultOp.pt);
        }
      }
    }
  }

  void _deleteFromAEL(Active ae) {
    var prev = ae.prevInAEL;
    var next = ae.nextInAEL;
    if (prev == null && next == null && (ae != _actives)) {
      return; // already deleted
    }
    if (prev != null) {
      prev.nextInAEL = next;
    } else {
      _actives = next;
    }
    if (next != null) next.prevInAEL = prev;
    // delete &ae;
  }

  void _adjustCurrXAndCopyToSEL(int topY) {
    var ae = _actives;
    _sel = ae;
    while (ae != null) {
      ae.prevInSEL = ae.prevInAEL;
      ae.nextInSEL = ae.nextInAEL;
      ae.jump = ae.nextInSEL;
      ae.curX =
          ae.joinWith == JoinWith.left
              ? ae.prevInAEL!.curX
              : // this also avoids complications
              ae.topX(topY);
      // NB don't update ae.curr.y yet (see AddNewIntersectNode)
      ae = ae.nextInAEL;
    }
  }

  void executeInternal(ClipType ct, FillRule fillRule) {
    if (ct == ClipType.noClip) return;
    _fillrule = fillRule;
    _cliptype = ct;
    _reset();
    var (ok, y) = _popScanline();
    if (!ok) return;
    while (succeeded) {
      _insertLocalMinimaIntoAEL(y);
      while (true) {
        final (ok, ae) = _popHorz();
        if (!ok) {
          break;
        }
        _doHorizontal(ae!);
      }
      if (_horzSegList.isNotEmpty) {
        _convertHorzSegsToJoins();
        _horzSegList.clear();
      }
      _currentBotY = y; // bottom of scanbeam
      (ok, y) = _popScanline();
      if (!ok) {
        break; // y new top of scanbeam
      }
      _doIntersections(y);
      _doTopOfScanbeam(y);
      while (true) {
        final (ok, ae) = _popHorz();
        if (!ok) {
          break;
        }
        _doHorizontal(ae!);
      }
    }
    if (succeeded) {
      _processHorzJoins();
    }
  }

  void _doIntersections(int topY) {
    if (!_buildIntersectList(topY)) {
      return;
    }
    _processIntersectList();
    _disposeIntersectNodes();
  }

  void _disposeIntersectNodes() {
    _intersectList.clear();
  }

  void _addNewIntersectNode(Active ae1, Active ae2, int topY) {
    var ip =
        getSegmentIntersectPt(ae1.bot, ae1.top, ae2.bot, ae2.top) ??
        Point64(ae1.curX, topY);

    if (ip.y > _currentBotY || ip.y < topY) {
      final absDx1 = ae1.dx.abs();
      final absDx2 = ae2.dx.abs();
      if (absDx1 > 100) {
        if (absDx2 > 100) {
          if (absDx1 > absDx2) {
            ip = getClosestPtOnSegment(ip, ae1.bot, ae1.top);
          } else {
            ip = getClosestPtOnSegment(ip, ae2.bot, ae2.top);
          }
        } else {
          ip = getClosestPtOnSegment(ip, ae1.bot, ae1.top);
        }
      } else {
        if (absDx2 > 100) {
          ip = getClosestPtOnSegment(ip, ae2.bot, ae2.top);
        } else {
          if (ip.y < topY) {
            ip = ip.copy(ip.x, topY);
          } else {
            ip = ip.copy(ip.x, _currentBotY);
          }
          if (absDx1 < absDx2) {
            ip = ip.copy(ae1.topX(ip.y), ip.y);
          } else {
            ip = ip.copy(ae2.topX(ip.y), ip.y);
          }
        }
      }
    }
    final node = IntersectNode(pt: ip, edge1: ae1, edge2: ae2);
    _intersectList.add(node);
  }

  bool _buildIntersectList(int topY) {
    if (_actives?.nextInAEL == null) {
      return false;
    }

    // Calculate edge positions at the top of the current scanbeam, and from this
    // we will determine the intersections required to reach these new positions.
    _adjustCurrXAndCopyToSEL(topY);

    // Find all edge intersections in the current scanbeam using a stable merge
    // sort that ensures only adjacent edges are intersecting. Intersect info is
    // stored in FIntersectList ready to be processed in ProcessIntersectList.
    // Re merge sorts see https://stackoverflow.com/a/46319131/359538

    var left = _sel;

    while (left!.jump != null) {
      Active? prevBase;
      while (left?.jump != null) {
        var currBase = left;
        var right = left!.jump;
        var lEnd = right;
        var rEnd = right!.jump;
        left.jump = rEnd;
        while (left != lEnd && right != rEnd) {
          if (right!.curX < left!.curX) {
            var tmp = right.prevInSEL!;
            while (true) {
              _addNewIntersectNode(tmp, right, topY);
              if (tmp == left) {
                break;
              }
              tmp = tmp.prevInSEL!;
            }

            tmp = right;
            right = tmp.extractFromSEL();
            lEnd = right;
            tmp.insert1Before2InSEL(left);
            if (left != currBase) {
              continue;
            }
            currBase = tmp;
            currBase.jump = rEnd;
            if (prevBase == null) {
              _sel = currBase;
            } else {
              prevBase.jump = currBase;
            }
          } else {
            left = left.nextInSEL;
          }
        }

        prevBase = currBase;
        left = rEnd;
      }
      left = _sel;
    }

    return _intersectList.isNotEmpty;
  }

  void _processIntersectList() {
    // We now have a list of intersections required so that edges will be
    // correctly positioned at the top of the scanbeam. However, it's important
    // that edge intersections are processed from the bottom up, but it's also
    // crucial that intersections only occur between adjacent edges.

    // First we do a quicksort so intersections proceed in a bottom up order ...
    _intersectList.sort(IntersectNode.compare);

    // Now as we process these intersections, we must sometimes adjust the order
    // to ensure that intersecting edges are always adjacent ...
    for (var i = 0; i < _intersectList.length; i++) {
      if (!_intersectList[i].edgesAdjacentInAEL) {
        int j = i + 1;
        while (!_intersectList[j].edgesAdjacentInAEL) {
          j++;
        }
        // swap
        final tmp = _intersectList[j];
        _intersectList[j] = _intersectList[i];
        _intersectList[i] = tmp;
      }

      final node = _intersectList[i];
      _intersectEdges(node.edge1, node.edge2, node.pt);
      _swapPositionsInAEL(node.edge1, node.edge2);

      node.edge1.curX = node.pt.x;
      node.edge2.curX = node.pt.x;
      _checkJoinLeft(node.edge2, node.pt, checkCurrX: true);
      _checkJoinRight(node.edge1, node.pt, checkCurrX: true);
    }
  }

  void _swapPositionsInAEL(Active ae1, Active ae2) {
    // preconditon: ae1 must be immediately to the left of ae2
    final next = ae2.nextInAEL;
    if (next != null) next.prevInAEL = ae1;
    final prev = ae1.prevInAEL;
    if (prev != null) prev.nextInAEL = ae2;
    ae2.prevInAEL = prev;
    ae2.nextInAEL = ae1;
    ae1.prevInAEL = ae2;
    ae1.nextInAEL = next;
    if (ae2.prevInAEL == null) _actives = ae2;
  }

  void _trimHorz(Active horzEdge, bool preserveCollinear) {
    var wasTrimmed = false;
    var pt = horzEdge.nextVertex.pt;

    while (pt.y == horzEdge.top.y) {
      // always trim 180 deg. spikes (in closed paths)
      // but otherwise break if preserveCollinear = true
      if (preserveCollinear &&
          (pt.x < horzEdge.top.x) != (horzEdge.bot.x < horzEdge.top.x)) {
        break;
      }

      horzEdge.vertexTop = horzEdge.nextVertex;
      horzEdge.top = pt;
      wasTrimmed = true;
      if (horzEdge.isMaxima) {
        break;
      }
      pt = horzEdge.nextVertex.pt;
    }
    if (wasTrimmed) {
      horzEdge.setDx(); // +/-infinity
    }
  }

  void _addToHorzSegList(OutPt op) {
    if (op.outrec.isOpen) {
      return;
    }
    _horzSegList.add(HorzSegment(op));
  }

  void _doHorizontal(Active horz)
  /*******************************************************************************
     * Notes: Horizontal edges (HEs) at scanline intersections (i.e. at the top or  *
     * bottom of a scanbeam) are processed as if layered.The order in which HEs     *
     * are processed doesn't matter. HEs intersect with the bottom vertices of      *
     * other HEs[#] and with non-horizontal edges [*]. Once these intersections     *
     * are completed, intermediate HEs are 'promoted' to the next edge in their     *
     * bounds, and they in turn may be intersected[%] by other HEs.                 *
     *                                                                              *
     * eg: 3 horizontals at a scanline:    /   |                     /           /  *
     *              |                     /    |     (HE3)o ========%========== o   *
     *              o ======= o(HE2)     /     |         /         /                *
     *          o ============#=========*======*========#=========o (HE1)           *
     *         /              |        /       |       /                            *
     *******************************************************************************/
  {
    var horzIsOpen = horz.isOpen;
    var y = horz.bot.y;

    var vertexMax =
        horzIsOpen ? horz.currYMaximaVertexOpen : horz.currYMaximaVertex;

    var (isLeftToRight, leftX, rightX) = horz.resetHorzDirection(vertexMax);

    if (horz.isHotEdge) {
      final op = _addOutPt(horz, horz.bot.copy(horz.curX, y));
      _addToHorzSegList(op);
    }

    while (true) {
      // loops through consec. horizontal edges (if open)
      var ae = isLeftToRight ? horz.nextInAEL : horz.prevInAEL;

      while (ae != null) {
        if (ae.vertexTop == vertexMax) {
          // do this first!!
          if (horz.isHotEdge && ae.isJoined) {
            _split(ae, ae.top);
          }

          if (horz.isHotEdge) {
            while (horz.vertexTop != vertexMax) {
              _addOutPt(horz, horz.top);
              _updateEdgeIntoAEL(horz);
            }
            if (isLeftToRight) {
              _addLocalMaxPoly(horz, ae, horz.top);
            } else {
              _addLocalMaxPoly(ae, horz, horz.top);
            }
          }
          _deleteFromAEL(ae);
          _deleteFromAEL(horz);
          return;
        }

        // if horzEdge is a maxima, keep going until we reach
        // its maxima pair, otherwise check for break conditions
        if (vertexMax != horz.vertexTop || horz.isOpenEnd) {
          // otherwise stop when 'ae' is beyond the end of the horizontal line
          if ((isLeftToRight && ae.curX > rightX) ||
              (!isLeftToRight && ae.curX < leftX)) {
            break;
          }

          if (ae.curX == horz.top.x && !ae.isHorizontal) {
            final pt = horz.nextVertex.pt;

            // to maximize the possibility of putting open edges into
            // solutions, we'll only break if it's past HorzEdge's end
            if (ae.isOpen && !ae.isSamePolyType(horz) && !ae.isHotEdge) {
              if ((isLeftToRight && (ae.topX(pt.y) > pt.x)) ||
                  (!isLeftToRight && (ae.topX(pt.y) < pt.x))) {
                break;
              }
            }
            // otherwise for edges at horzEdge's end, only stop when horzEdge's
            // outslope is greater than e's slope when heading right or when
            // horzEdge's outslope is less than e's slope when heading left.
            else if ((isLeftToRight && (ae.topX(pt.y) >= pt.x)) ||
                (!isLeftToRight && (ae.topX(pt.y) <= pt.x))) {
              break;
            }
          }
        }

        final pt = Point64(ae.curX, y);

        if (isLeftToRight) {
          _intersectEdges(horz, ae, pt);
          _swapPositionsInAEL(horz, ae);
          _checkJoinLeft(ae, pt);
          horz.curX = ae.curX;
          ae = horz.nextInAEL;
        } else {
          _intersectEdges(ae, horz, pt);
          _swapPositionsInAEL(ae, horz);
          _checkJoinRight(ae, pt);
          horz.curX = ae.curX;
          ae = horz.prevInAEL;
        }

        if (horz.isHotEdge) {
          _addToHorzSegList(horz.lastOp);
        }
      } // we've reached the end of this horizontal

      // check if we've finished looping
      // through consecutive horizontals
      if (horzIsOpen && horz.isOpenEnd) // ie open at top
      {
        if (horz.isHotEdge) {
          _addOutPt(horz, horz.top);
          if (horz.isFront) {
            horz.outrec!.frontEdge = null;
          } else {
            horz.outrec!.backEdge = null;
          }
          horz.outrec = null;
        }
        _deleteFromAEL(horz);
        return;
      }
      if (horz.nextVertex.pt.y != horz.top.y) {
        break;
      }

      //still more horizontals in bound to process ...
      if (horz.isHotEdge) {
        _addOutPt(horz, horz.top);
      }

      _updateEdgeIntoAEL(horz);

      (isLeftToRight, leftX, rightX) = horz.resetHorzDirection(vertexMax);
    } // end for loop and end of (possible consecutive) horizontals

    if (horz.isHotEdge) {
      final op = _addOutPt(horz, horz.top);
      _addToHorzSegList(op);
    }

    _updateEdgeIntoAEL(horz); // this is the end of an intermediate horiz.
  }

  void _doTopOfScanbeam(int y) {
    _sel = null; // sel_ is reused to flag horizontals (see PushHorz below)
    var ae = _actives;
    while (ae != null) {
      // NB 'ae' will never be horizontal here
      if (ae.top.y == y) {
        ae.curX = ae.top.x;
        if (ae.isMaxima) {
          ae = _doMaxima(ae); // TOP OF BOUND (MAXIMA)
          continue;
        }

        // INTERMEDIATE VERTEX ...
        if (ae.isHotEdge) {
          _addOutPt(ae, ae.top);
        }
        _updateEdgeIntoAEL(ae);
        if (ae.isHorizontal) {
          _pushHorz(ae); // horizontals are processed later
        }
      } else {
        // i.e. not the top of the edge
        ae.curX = ae.topX(y);
      }

      ae = ae.nextInAEL;
    }
  }

  Active? _doMaxima(Active ae) {
    var prevE = ae.prevInAEL;
    var nextE = ae.nextInAEL;

    if (ae.isOpenEnd) {
      if (ae.isHotEdge) {
        _addOutPt(ae, ae.top);
      }
      if (ae.isHorizontal) {
        return nextE;
      }
      if (ae.isHotEdge) {
        if (ae.isFront) {
          ae.outrec!.frontEdge = null;
        } else {
          ae.outrec!.backEdge = null;
        }
        ae.outrec = null;
      }
      _deleteFromAEL(ae);
      return nextE;
    }

    Active? maxPair = ae.maximaPair;
    if (maxPair == null) return nextE; // eMaxPair is horizontal

    if (ae.isJoined) {
      _split(ae, ae.top);
    }
    if (maxPair.isJoined) {
      _split(maxPair, maxPair.top);
    }

    // only non-horizontal maxima here.
    // process any edges between maxima pair ...
    while (nextE != maxPair) {
      _intersectEdges(ae, nextE!, ae.top);
      _swapPositionsInAEL(ae, nextE);
      nextE = ae.nextInAEL;
    }

    if (ae.isOpen) {
      if (ae.isHotEdge) {
        _addLocalMaxPoly(ae, maxPair, ae.top);
      }
      _deleteFromAEL(maxPair);
      _deleteFromAEL(ae);
      return (prevE != null ? prevE.nextInAEL : _actives);
    }

    // here ae.nextInAel == ENext == EMaxPair ...
    if (ae.isHotEdge) {
      _addLocalMaxPoly(ae, maxPair, ae.top);
    }

    _deleteFromAEL(ae);
    _deleteFromAEL(maxPair);
    return (prevE != null ? prevE.nextInAEL : _actives);
  }

  void _split(Active e, Point64 currPt) {
    if (e.joinWith == JoinWith.right) {
      e.joinWith = JoinWith.none;
      e.nextInAEL!.joinWith = JoinWith.none;
      _addLocalMinPoly(e, e.nextInAEL!, currPt, isNew: true);
    } else {
      e.joinWith = JoinWith.none;
      e.prevInAEL!.joinWith = JoinWith.none;
      _addLocalMinPoly(e.prevInAEL!, e, currPt, isNew: true);
    }
  }

  void _checkJoinLeft(Active e, Point64 pt, {bool checkCurrX = false}) {
    Active? prev = e.prevInAEL;
    if (prev == null ||
        !e.isHotEdge ||
        !prev.isHotEdge ||
        e.isHorizontal ||
        prev.isHorizontal ||
        e.isOpen ||
        prev.isOpen) {
      return;
    }
    if ((pt.y < e.top.y + 2 || pt.y < prev.top.y + 2) && // avoid trivial joins
        ((e.bot.y > pt.y) || (prev.bot.y > pt.y))) {
      return; // (#490)
    }
    if (checkCurrX) {
      if (pt.perpendicDistFromLineSqrd(prev.bot, prev.top) > 0.25) {
        return;
      }
    } else if (e.curX != prev.curX) {
      return;
    }
    if (!isCollinear(e.top, pt, prev.top)) {
      return;
    }

    if (e.outrec!.idx == prev.outrec!.idx) {
      _addLocalMaxPoly(prev, e, pt);
    } else if (e.outrec!.idx < prev.outrec!.idx) {
      _joinOutrecPaths(e, prev);
    } else {
      _joinOutrecPaths(prev, e);
    }
    prev.joinWith = JoinWith.right;
    e.joinWith = JoinWith.left;
  }

  void _checkJoinRight(Active e, Point64 pt, {bool checkCurrX = false}) {
    var next = e.nextInAEL;
    if (next == null ||
        !e.isHotEdge ||
        !next.isHotEdge ||
        e.isHorizontal ||
        next.isHorizontal ||
        e.isOpen ||
        next.isOpen) {
      return;
    }
    if ((pt.y < e.top.y + 2 || pt.y < next.top.y + 2) && // avoid trivial joins
        ((e.bot.y > pt.y) || (next.bot.y > pt.y))) {
      return; // (#490)
    }
    if (checkCurrX) {
      if (pt.perpendicDistFromLineSqrd(next.bot, next.top) > 0.25) {
        return;
      }
    } else if (e.curX != next.curX) {
      return;
    }
    if (!isCollinear(e.top, pt, next.top)) {
      return;
    }

    if (e.outrec!.idx == next.outrec!.idx) {
      _addLocalMaxPoly(e, next, pt);
    } else if (e.outrec!.idx < next.outrec!.idx) {
      _joinOutrecPaths(e, next);
    } else {
      _joinOutrecPaths(next, e);
    }
    e.joinWith = JoinWith.right;
    next.joinWith = JoinWith.left;
  }

  void _fixOutRecPts(OutRec outrec) {
    var op = outrec.pts!;
    do {
      op.outrec = outrec;
      op = op.next!;
    } while (op != outrec.pts);
  }

  void _convertHorzSegsToJoins() {
    int k = 0;
    for (final hs in _horzSegList) {
      if (hs.update()) {
        k++;
      }
    }
    if (k < 2) {
      return;
    }
    _horzSegList.sort(HorzSegment.compare);

    for (int i = 0; i < k - 1; i++) {
      final hs1 = _horzSegList[i];
      // for each HorzSegment, find others that overlap
      for (int j = i + 1; j < k; j++) {
        final hs2 = _horzSegList[j];
        if ((hs2.leftOp!.pt.x >= hs1.rightOp!.pt.x) ||
            (hs2.leftToRight == hs1.leftToRight) ||
            (hs2.rightOp!.pt.x <= hs1.leftOp!.pt.x)) {
          continue;
        }
        final currY = hs1.leftOp!.pt.y;
        if (hs1.leftToRight) {
          while (hs1.leftOp!.next!.pt.y == currY &&
              hs1.leftOp!.next!.pt.x <= hs2.leftOp!.pt.x) {
            hs1.leftOp = hs1.leftOp!.next;
          }
          while (hs2.leftOp!.prev.pt.y == currY &&
              hs2.leftOp!.prev.pt.x <= hs1.leftOp!.pt.x) {
            hs2.leftOp = hs2.leftOp!.prev;
          }
          final join = HorzJoin(
            hs1.leftOp!.duplicate(insertAfter: true),
            hs2.leftOp!.duplicate(insertAfter: false),
          );
          _horzJoinList.add(join);
        } else {
          while (hs1.leftOp!.prev.pt.y == currY &&
              hs1.leftOp!.prev.pt.x <= hs2.leftOp!.pt.x) {
            hs1.leftOp = hs1.leftOp!.prev;
          }
          while (hs2.leftOp!.next!.pt.y == currY &&
              hs2.leftOp!.next!.pt.x <= (hs1).leftOp!.pt.x) {
            hs2.leftOp = hs2.leftOp!.next;
          }
          final join = HorzJoin(
            hs2.leftOp!.duplicate(insertAfter: true),
            hs1.leftOp!.duplicate(insertAfter: false),
          );
          _horzJoinList.add(join);
        }
      }
    }
  }

  void _processHorzJoins() {
    for (final j in _horzJoinList) {
      final or1 = j.op1!.outrec.realOutRec!;
      var or2 = j.op2!.outrec.realOutRec!;

      final op1b = j.op1!.next!;
      final op2b = j.op2!.prev;
      j.op1!.next = j.op2;
      j.op2!.prev = j.op1!;
      op1b.prev = op2b;
      op2b.next = op1b;

      if (or1 == or2) // 'join' is really a split
      {
        or2 = _newOutRec();
        or2.pts = op1b;
        _fixOutRecPts(or2);

        //if or1->pts has moved to or2 then update or1->pts!!
        if (or1.pts!.outrec == or2) {
          or1.pts = j.op1;
          or1.pts!.outrec = or1;
        }

        if (usingPolytree) //#498, #520, #584, D#576, #618
        {
          if (or1.pts!.insidePath2(or2.pts!)) {
            //swap or1's & or2's pts
            final tmp = or1.pts;
            or1.pts = or2.pts;
            or2.pts = tmp;
            _fixOutRecPts(or1);
            _fixOutRecPts(or2);
            //or2 is now inside or1
            //print('#4: setting owner of ${or2.idx} to ${or1.idx}');
            or2.owner = or1;
          } else if (or2.pts!.insidePath2(or1.pts!)) {
            //print('#5: setting owner of ${or2.idx} to ${or1.idx}');
            or2.owner = or1;
          } else {
            //print('#6: setting owner of ${or2.idx} to ${or1.owner?.idx}');
            or2.owner = or1.owner;
          }
          or1.splits ??= [];
          or1.splits!.add(or2.idx);
        } else {
          //print('#7: setting owner of ${or2.idx} to ${or1.idx}');
          or2.owner = or1;
        }
      } else {
        or2.pts = null;
        if (usingPolytree) {
          or2.setOwner(or1);
          or2.moveSplitsTo(or1); //#618
        } else {
          //print('#8: setting owner of ${or2.idx} to ${or1.idx}');
          or2.owner = or1;
        }
      }
    }
  }

  static bool _ptsReallyClose(Point64 pt1, Point64 pt2) =>
      (pt1.x - pt2.x).abs() < 2 && (pt1.y - pt2.y).abs() < 2;

  static bool _isVerySmallTriangle(OutPt op) =>
      op.next!.next == op.prev &&
      (_ptsReallyClose(op.prev.pt, op.next!.pt) ||
          _ptsReallyClose(op.pt, op.next!.pt) ||
          _ptsReallyClose(op.pt, op.prev.pt));

  static bool _isValidClosedPath(OutPt? op) =>
      (op != null &&
          op.next != op &&
          (op.next != op.prev || !_isVerySmallTriangle(op)));

  void _cleanCollinear(OutRec? outrec) {
    outrec = outrec?.realOutRec;

    if (outrec == null || outrec.isOpen) {
      return;
    }

    if (!_isValidClosedPath(outrec.pts)) {
      outrec.pts = null;
      return;
    }

    OutPt startOp = outrec.pts!;
    OutPt? op2 = startOp;
    for (;;) {
      // NB if preserveCollinear == true, then only remove 180 deg. spikes
      if ((isCollinear(op2!.prev.pt, op2.pt, op2.next!.pt)) &&
          ((op2.pt == op2.prev.pt) ||
              (op2.pt == op2.next!.pt) ||
              !preserveCollinear ||
              (dotProduct(op2.prev.pt, op2.pt, op2.next!.pt) < 0))) {
        if (op2 == outrec.pts) {
          outrec.pts = op2.prev;
        }
        op2 = op2.dispose();
        if (!_isValidClosedPath(op2)) {
          outrec.pts = null;
          return;
        }
        startOp = op2!;
        continue;
      }
      op2 = op2.next;
      if (op2 == startOp) break;
    }
    _fixSelfIntersects(outrec);
  }

  void _doSplitOp(OutRec outrec, OutPt splitOp) {
    // splitOp.prev <=> splitOp &&
    // splitOp.next <=> splitOp.next.next are intersecting
    OutPt prevOp = splitOp.prev;
    OutPt nextNextOp = splitOp.next!.next!;
    outrec.pts = prevOp;

    var ip = getSegmentIntersectPt(
      prevOp.pt,
      splitOp.pt,
      splitOp.next!.pt,
      nextNextOp.pt,
    );

    if (zCallback != null) {
      final z = zCallback!(
        prevOp.pt,
        splitOp.pt,
        splitOp.next!.pt,
        nextNextOp.pt,
        ip!,
      );
      if (z != null) {
        ip = Point64(ip.x, ip.y, z);
      }
    }

    final area1 = prevOp.area;
    final absArea1 = area1.abs();

    if (absArea1 < 2) {
      outrec.pts = null;
      return;
    }

    final area2 = _areaTriangle(ip!, splitOp.pt, splitOp.next!.pt);
    final absArea2 = area2.abs();

    // de-link splitOp and splitOp.next from the path
    // while inserting the intersection point
    if (ip == prevOp.pt || ip == nextNextOp.pt) {
      nextNextOp.prev = prevOp;
      prevOp.next = nextNextOp;
    } else {
      final newOp2 =
          OutPt(pt: ip, outrec: outrec)
            ..prev = prevOp
            ..next = nextNextOp;
      nextNextOp.prev = newOp2;
      prevOp.next = newOp2;
    }

    // nb: area1 is the path's area *before* splitting, whereas area2 is
    // the area of the triangle containing splitOp & splitOp.next.
    // So the only way for these areas to have the same sign is if
    // the split triangle is larger than the path containing prevOp or
    // if there's more than one self=intersection.
    if (!(absArea2 > 1) ||
        (!(absArea2 > absArea1) && ((area2 > 0) != (area1 > 0)))) {
      return;
    }
    final newOutRec = _newOutRec();
    //print('#9: setting owner of ${newOutRec.idx} to ${outrec.owner?.idx}');
    newOutRec.owner = outrec.owner;
    splitOp.outrec = newOutRec;
    splitOp.next!.outrec = newOutRec;

    final newOp =
        OutPt(pt: ip, outrec: newOutRec)
          ..prev = splitOp.next!
          ..next = splitOp;
    newOutRec.pts = newOp;
    splitOp.prev = newOp;
    splitOp.next!.next = newOp;

    if (!usingPolytree) {
      return;
    }
    if (prevOp.insidePath2(newOp)) {
      newOutRec.splits ??= [];
      newOutRec.splits!.add(outrec.idx);
    } else {
      outrec.splits ??= [];
      outrec.splits!.add(newOutRec.idx);
    }
    //else { splitOp = null; splitOp.next = null; }
  }

  void _fixSelfIntersects(OutRec outrec) {
    var op2 = outrec.pts!;
    // triangles can't self-intersect
    if (op2.prev == op2.next!.next) return;
    while (true) {
      if (segsIntersect(
        op2.prev.pt,
        op2.pt,
        op2.next!.pt,
        op2.next!.next!.pt,
      )) {
        _doSplitOp(outrec, op2);
        if (outrec.pts == null) {
          return;
        }
        op2 = outrec.pts!;
        // triangles can't self-intersect
        if (op2.prev == op2.next!.next) {
          break;
        }
        continue;
      }

      op2 = op2.next!;
      if (op2 == outrec.pts) {
        break;
      }
    }
  }

  static bool _buildPath(OutPt? op, bool reverse, bool isOpen, Path64 path) {
    if (op == null || op.next == op || (!isOpen && op.next == op.prev)) {
      return false;
    }
    path.clear();

    Point64 lastPt;
    OutPt op2;
    if (reverse) {
      lastPt = op.pt;
      op2 = op.prev;
    } else {
      op = op.next!;
      lastPt = op.pt;
      op2 = op.next!;
    }
    path.add(lastPt);

    while (op2 != op) {
      if (op2.pt != lastPt) {
        lastPt = op2.pt;
        path.add(lastPt);
      }
      if (reverse) {
        op2 = op2.prev;
      } else {
        op2 = op2.next!;
      }
    }

    return path.length != 3 || isOpen || !_isVerySmallTriangle(op2);
  }

  bool buildPaths(Paths64 solutionClosed, Paths64 solutionOpen) {
    solutionClosed.clear();
    solutionOpen.clear();

    var i = 0;
    // _outrecList.Count is not static here because
    // CleanCollinear can indirectly add additional OutRec
    while (i < _outrecList.length) {
      OutRec outrec = _outrecList[i++];
      if (outrec.pts == null) {
        continue;
      }

      final path = <Point64>[];
      if (outrec.isOpen) {
        if (_buildPath(outrec.pts, reverseSolution, true, path)) {
          solutionOpen.add(path);
        }
      } else {
        _cleanCollinear(outrec);
        // closed paths should always return a Positive orientation
        // except when ReverseSolution == true
        if (_buildPath(outrec.pts, reverseSolution, false, path)) {
          solutionClosed.add(path);
        }
      }
    }
    return true;
  }

  bool _checkBounds(OutRec outrec) {
    if (outrec.pts == null) {
      return false;
    }
    if (!outrec.bounds.isEmpty) {
      return true;
    }
    _cleanCollinear(outrec);
    if (outrec.pts == null ||
        !_buildPath(outrec.pts, reverseSolution, false, outrec.path)) {
      return false;
    }
    outrec.bounds = outrec.path.bounds;
    return true;
  }

  bool _checkSplitOwner(OutRec outrec, List<int>? splits) {
    for (final i in splits!) {
      OutRec? split = _outrecList[i];
      if (split.pts == null &&
          split.splits != null &&
          _checkSplitOwner(outrec, split.splits)) {
        return true; //#942
      }
      split = split.realOutRec;
      if (split == null || split == outrec || split.recursiveSplit == outrec) {
        continue;
      }
      split.recursiveSplit = outrec; //#599
      if (split.splits != null && _checkSplitOwner(outrec, split.splits)) {
        return true;
      }
      if (!outrec.isValidOwner(split) ||
          !_checkBounds(split) ||
          !split.bounds.containsRect(outrec.bounds) ||
          !outrec.pts!.insidePath2(split.pts!)) {
        continue;
      }
      //print('#10: setting owner of ${outrec.idx} to ${split.idx}');
      outrec.owner = split; //found in split
      return true;
    }
    return false;
  }

  void _recursiveCheckOwners(OutRec outrec, PolyPath polypath) {
    // pre-condition: outrec will have valid bounds
    // post-condition: if a valid path, outrec will have a polypath

    if (outrec.polypath != null || outrec.bounds.isEmpty) {
      return;
    }

    while (outrec.owner != null) {
      if (outrec.owner!.splits != null &&
          _checkSplitOwner(outrec, outrec.owner!.splits)) {
        break;
      }
      if (outrec.owner!.pts != null &&
          _checkBounds(outrec.owner!) &&
          outrec.pts!.insidePath2(outrec.owner!.pts!)) {
        break;
      }
      //print('#11: setting owner of ${outrec.idx} to ${outrec.owner?.owner?.idx}');
      outrec.owner = outrec.owner!.owner;
    }

    if (outrec.owner != null) {
      if (outrec.owner!.polypath == null) {
        _recursiveCheckOwners(outrec.owner!, polypath);
      }
      outrec.polypath = outrec.owner!.polypath!.addChild64(outrec.path);
    } else {
      outrec.polypath = polypath.addChild64(outrec.path);
    }
  }

  void buildTree(PolyPath polytree, Paths64 solutionOpen) {
    polytree.clear();
    solutionOpen.clear();

    var i = 0;
    // _outrecList.Count is not static here because
    // CheckBounds below can indirectly add additional
    // OutRec (via FixOutRecPts & CleanCollinear)
    while (i < _outrecList.length) {
      OutRec outrec = _outrecList[i++];
      if (outrec.pts == null) {
        continue;
      }

      if (outrec.isOpen) {
        final openPath = <Point64>[];
        if (_buildPath(outrec.pts, reverseSolution, true, openPath)) {
          solutionOpen.add(openPath);
        }
        continue;
      }
      if (_checkBounds(outrec)) {
        _recursiveCheckOwners(outrec, polytree);
      }
    }
  }

  Rect64 get bounds {
    final bounds = Rect64.invalid();
    for (final t in _vertexList) {
      var v = t;
      do {
        if (v.pt.x < bounds.left) bounds.left = v.pt.x;
        if (v.pt.x > bounds.right) bounds.right = v.pt.x;
        if (v.pt.y < bounds.top) bounds.top = v.pt.y;
        if (v.pt.y > bounds.bottom) bounds.bottom = v.pt.y;
        v = v.next!;
      } while (v != t);
    }
    return bounds.isEmpty ? Rect64.fromLTRB(0, 0, 0, 0) : bounds;
  }
}

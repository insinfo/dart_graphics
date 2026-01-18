// OutRec: path data structure for clipping solutions
import '../../clipper.dart';

import 'active.dart';
import 'out_pt.dart';

class OutRec {
  OutRec({required this.idx});

  final int idx;
  OutRec? owner;
  Active? frontEdge;
  Active? backEdge;
  OutPt? pts;
  PolyPath? polypath;
  var bounds = Rect64.invalid();
  final path = <Point64>[];
  var isOpen = false;
  List<int>? splits;
  OutRec? recursiveSplit;

  void setOwner(OutRec newOwner) {
    //precondition1: new_owner is never null
    while (newOwner.owner != null && newOwner.owner!.pts == null) {
      //print('#12: setting owner of ${newOwner.idx} to ${newOwner.owner!.owner?.idx}');
      newOwner.owner = newOwner.owner!.owner;
    }

    //make sure that outrec isn't an owner of newOwner
    OutRec? tmp = newOwner;
    while (tmp != null && tmp != this) {
      tmp = tmp.owner;
    }
    if (tmp != null) {
      //print('#13: setting owner of ${newOwner.idx} to ${owner?.idx}');
      newOwner.owner = owner;
    }
    //print('#14: setting owner of $idx to ${newOwner.idx}');
    owner = newOwner;
  }

  void setSides(Active startEdge, Active endEdge) {
    frontEdge = startEdge;
    backEdge = endEdge;
  }

  OutRec? get realOutRec {
    OutRec? outRec = this;
    while ((outRec != null) && (outRec.pts == null)) {
      outRec = outRec.owner;
    }
    return outRec;
  }

  bool isValidOwner(OutRec? testOwner) {
    while ((testOwner != null) && (testOwner != this)) {
      testOwner = testOwner.owner;
    }
    return testOwner == null;
  }

  void swapFrontBackSides() {
    // while this proc. is needed for open paths
    // it's almost never needed for closed paths
    final ae2 = frontEdge!;
    frontEdge = backEdge;
    backEdge = ae2;
    pts = pts!.next;
  }

  void moveSplitsTo(OutRec toOr) {
    if (splits == null) {
      return;
    }
    if (toOr.splits == null) {
      toOr.splits = List.from(splits!);
    } else {
      toOr.splits!.addAll(splits!);
    }
    splits = null;
  }
}

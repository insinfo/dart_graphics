import '../vertex_source/vertex_storage.dart';
import '../../typography/openfont/i_glyph_translator.dart';
//
// VertexSourceGlyphTranslator - Bridge between Typography and AGG
// Translates glyph outlines into vertex paths for rendering
//


/// A glyph translator that converts glyph outlines to vertex storage paths
/// This serves as the bridge between the Typography system and AGG rendering
class VertexSourceGlyphTranslator implements IGlyphTranslator {
  int _polygonStartIndex = 0;
  final VertexStorage _vertexStorage;
  
  // Control point for handling open curve3 at polygon start
  double _curve3ControlX = double.negativeInfinity;
  double _curve3ControlY = double.negativeInfinity;

  /// Creates a new VertexSourceGlyphTranslator with the given vertex storage
  VertexSourceGlyphTranslator(this._vertexStorage);

  /// Get the underlying vertex storage
  VertexStorage get vertexStorage => _vertexStorage;

  @override
  void beginRead(int contourCount) {
    // Nothing needed at the start
  }

  /// Check if there's an open curve3 that needs to be closed
  void _checkForOpenCurve3() {
    if (_curve3ControlX != double.negativeInfinity) {
      // We started this polygon with a control point so add the required curve3
      var startVertex = _vertexStorage[_polygonStartIndex];
      _vertexStorage.curve3(
        _curve3ControlX, 
        _curve3ControlY, 
        startVertex.x, 
        startVertex.y,
      );

      // Reset the curve3Control point to uninitialized
      _curve3ControlX = double.negativeInfinity;
      _curve3ControlY = double.negativeInfinity;
    }
  }

  @override
  void closeContour() {
    _checkForOpenCurve3();

    // Invert the polygon orientation if we have vertices
    if (_vertexStorage.count > _polygonStartIndex) {
      _invertPolygon(_polygonStartIndex);
    }
    _polygonStartIndex = _vertexStorage.count;
  }

  /// Inverts the polygon starting at the given index
  void _invertPolygon(int startIndex) {
    int endIndex = _vertexStorage.count - 1;
    
    // Swap vertices from start to end
    while (startIndex < endIndex) {
      var temp = _vertexStorage[startIndex];
      _vertexStorage[startIndex] = _vertexStorage[endIndex];
      _vertexStorage[endIndex] = temp;
      startIndex++;
      endIndex--;
    }
    
    // Fix the commands after inversion
    if (_vertexStorage.count > 0) {
      // The first vertex should be a moveTo
      var first = _vertexStorage[_polygonStartIndex];
      first.command = first.command.isVertex 
          ? first.command 
          : first.command;
    }
  }

  @override
  void curve3(double xControl, double yControl, double x, double y) {
    if (_polygonStartIndex == _vertexStorage.count) {
      // We have not started the polygon so there is no point to curve3 from
      // Store this control point and add it at the end of the polygon
      _curve3ControlX = xControl;
      _curve3ControlY = yControl;
      // Then move to the end of this curve
      _vertexStorage.moveTo(x, y);
    } else {
      _vertexStorage.curve3(xControl, yControl, x, y);
    }
  }

  @override
  void curve4(double x1, double y1, double x2, double y2, double x3, double y3) {
    _vertexStorage.curve4(x1, y1, x2, y2, x3, y3);
  }

  @override
  void endRead() {
    // Nothing needed at the end
  }

  @override
  void lineTo(double x, double y) {
    _vertexStorage.lineTo(x, y);
  }

  @override
  void moveTo(double x, double y) {
    _checkForOpenCurve3();
    _polygonStartIndex = _vertexStorage.count;
    _vertexStorage.moveTo(x, y);
  }
}

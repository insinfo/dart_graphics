/// SVG path data parser
/// 
/// Parses SVG path strings like "M 10 10 L 100 100 Q 150 50 200 100"
/// into Skia paths.
class SvgPathParser {
  final String _data;
  int _index = 0;
  
  SvgPathParser(this._data);

  /// Parses the path data and returns true if successful.
  bool parse(void Function(String command, List<double> args) onCommand) {
    try {
      while (_index < _data.length) {
        _skipWhitespace();
        if (_index >= _data.length) break;

        final char = _data[_index];
        if (_isCommand(char)) {
          final command = char;
          _index++;
          final args = _readArgs();
          onCommand(command, args);
        } else {
          _index++;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  bool _isCommand(String char) {
    return 'MmLlHhVvCcSsQqTtAaZz'.contains(char);
  }

  List<double> _readArgs() {
    final args = <double>[];
    
    while (true) {
      _skipWhitespace();
      if (_index >= _data.length) break;
      
      final char = _data[_index];
      if (_isCommand(char)) break;
      
      final num = _readNumber();
      if (num == null) break;
      args.add(num);
      
      _skipWhitespace();
      if (_index < _data.length && _data[_index] == ',') {
        _index++;
      }
    }
    
    return args;
  }

  double? _readNumber() {
    _skipWhitespace();
    if (_index >= _data.length) return null;

    final start = _index;
    final char = _data[_index];
    
    // Handle sign
    if (char == '-' || char == '+') {
      _index++;
    }

    // Read digits before decimal
    while (_index < _data.length && _isDigit(_data[_index])) {
      _index++;
    }

    // Read decimal point and digits after
    if (_index < _data.length && _data[_index] == '.') {
      _index++;
      while (_index < _data.length && _isDigit(_data[_index])) {
        _index++;
      }
    }

    // Read exponent
    if (_index < _data.length && 
        (_data[_index] == 'e' || _data[_index] == 'E')) {
      _index++;
      if (_index < _data.length && 
          (_data[_index] == '-' || _data[_index] == '+')) {
        _index++;
      }
      while (_index < _data.length && _isDigit(_data[_index])) {
        _index++;
      }
    }

    if (_index == start) return null;

    final str = _data.substring(start, _index);
    return double.tryParse(str);
  }

  bool _isDigit(String char) {
    final code = char.codeUnitAt(0);
    return code >= 48 && code <= 57; // '0' to '9'
  }

  void _skipWhitespace() {
    while (_index < _data.length) {
      final char = _data[_index];
      if (char == ' ' || char == '\t' || char == '\n' || 
          char == '\r' || char == ',') {
        _index++;
      } else {
        break;
      }
    }
  }
}

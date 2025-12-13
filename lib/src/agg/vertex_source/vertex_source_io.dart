// Copyright (c) 2024. All rights reserved.
// Use of this source code is governed by a BSD-style license.
//
// Ported from agg-sharp/agg/VertexSource/VertexSourceIO.cs
//
// I/O operations for vertex sources - loading and saving paths to files.

import 'dart:io';
import 'ivertex_source.dart';
import 'vertex_storage.dart';
import 'path_commands.dart';

/// Provides I/O operations for vertex sources.
/// 
/// Allows loading and saving vertex path data from/to text files.
/// The file format is CSV with each line containing: x, y, command
class VertexSourceIO {
  /// Loads vertex data from a file into a [VertexStorage].
  /// 
  /// The file format is CSV with each line containing:
  /// `x, y, commandName [, additionalFlags...]`
  /// 
  /// Example:
  /// ```
  /// 0, 0, commandMoveTo
  /// 100, 0, commandLineTo
  /// 100, 100, commandLineTo
  /// 0, 0, commandStop
  /// ```
  static void load(VertexStorage vertexSource, String pathAndFileName) {
    vertexSource.clear();
    
    final file = File(pathAndFileName);
    final allLines = file.readAsLinesSync();
    
    for (final line in allLines) {
      if (line.trim().isEmpty) continue;
      
      final elements = line.split(',');
      if (elements.length < 3) continue;
      
      final x = double.parse(elements[0].trim());
      final y = double.parse(elements[1].trim());
      var flagsAndCommand = _parseCommand(elements[2].trim());
      
      // Parse additional flags if present
      for (var i = 3; i < elements.length; i++) {
        final additionalFlag = _parseCommand(elements[i].trim());
        flagsAndCommand = FlagsAndCommand.fromValue(
          flagsAndCommand.value | additionalFlag.value
        );
      }
      
      vertexSource.addVertex(x, y, flagsAndCommand);
    }
  }

  /// Loads vertex data from a string into a [VertexStorage].
  static void loadFromString(VertexStorage vertexSource, String content) {
    vertexSource.clear();
    
    final allLines = content.split('\n');
    
    for (final line in allLines) {
      if (line.trim().isEmpty) continue;
      
      final elements = line.split(',');
      if (elements.length < 3) continue;
      
      final x = double.parse(elements[0].trim());
      final y = double.parse(elements[1].trim());
      var flagsAndCommand = _parseCommand(elements[2].trim());
      
      // Parse additional flags if present
      for (var i = 3; i < elements.length; i++) {
        final additionalFlag = _parseCommand(elements[i].trim());
        flagsAndCommand = FlagsAndCommand.fromValue(
          flagsAndCommand.value | additionalFlag.value
        );
      }
      
      vertexSource.addVertex(x, y, flagsAndCommand);
    }
  }

  /// Saves a vertex source to a file.
  /// 
  /// If [useIterator] is true (default), uses the vertices() iterator.
  /// If false, uses the legacy rewind/vertex approach.
  static void save(IVertexSource vertexSource, String pathAndFileName, {bool useIterator = true}) {
    final file = File(pathAndFileName);
    final sink = file.openWrite();
    
    try {
      if (useIterator) {
        for (final vertexData in vertexSource.vertices()) {
          sink.writeln('${vertexData.x}, ${vertexData.y}, ${_commandToString(vertexData.command)}');
        }
      } else {
        vertexSource.rewind(0);
        var x = 0.0;
        var y = 0.0;
        
        while (true) {
          final flagsAndCommand = vertexSource.vertexWithXY((newX, newY) {
            x = newX;
            y = newY;
          });
          
          sink.writeln('$x, $y, ${_commandToString(flagsAndCommand)}');
          
          if (flagsAndCommand.isStop) break;
        }
      }
    } finally {
      sink.close();
    }
  }

  /// Saves a vertex source to a string.
  static String saveToString(IVertexSource vertexSource, {bool useIterator = true}) {
    final buffer = StringBuffer();
    
    if (useIterator) {
      for (final vertexData in vertexSource.vertices()) {
        buffer.writeln('${vertexData.x}, ${vertexData.y}, ${_commandToString(vertexData.command)}');
      }
    } else {
      vertexSource.rewind(0);
      var x = 0.0;
      var y = 0.0;
      
      while (true) {
        final flagsAndCommand = vertexSource.vertexWithXY((newX, newY) {
          x = newX;
          y = newY;
        });
        
        buffer.writeln('$x, $y, ${_commandToString(flagsAndCommand)}');
        
        if (flagsAndCommand.isStop) break;
      }
    }
    
    return buffer.toString();
  }

  /// Parses a command name string to FlagsAndCommand.
  static FlagsAndCommand _parseCommand(String commandName) {
    switch (commandName.toLowerCase()) {
      case 'commandstop':
      case 'stop':
        return FlagsAndCommand.commandStop;
      case 'commandmoveto':
      case 'moveto':
        return FlagsAndCommand.commandMoveTo;
      case 'commandlineto':
      case 'lineto':
        return FlagsAndCommand.commandLineTo;
      case 'commandcurve3':
      case 'curve3':
        return FlagsAndCommand.commandCurve3;
      case 'commandcurve4':
      case 'curve4':
        return FlagsAndCommand.commandCurve4;
      case 'commandendpoly':
      case 'endpoly':
        return FlagsAndCommand.commandEndPoly;
      case 'flagclose':
      case 'close':
        return FlagsAndCommand.flagClose;
      case 'flagccw':
      case 'ccw':
        return FlagsAndCommand.flagCCW;
      case 'flagcw':
      case 'cw':
        return FlagsAndCommand.flagCW;
      default:
        // Try parsing as an integer value
        final value = int.tryParse(commandName);
        if (value != null) {
          return FlagsAndCommand.fromValue(value);
        }
        return FlagsAndCommand.commandStop;
    }
  }

  /// Converts a FlagsAndCommand to its string representation.
  static String _commandToString(FlagsAndCommand cmd) {
    final parts = <String>[];
    
    // Get base command
    final baseCmd = cmd.value & FlagsAndCommand.commandMask.value;
    switch (baseCmd) {
      case 0:
        parts.add('commandStop');
      case 1:
        parts.add('commandMoveTo');
      case 2:
        parts.add('commandLineTo');
      case 3:
        parts.add('commandCurve3');
      case 4:
        parts.add('commandCurve4');
      case 0x0F:
        parts.add('commandEndPoly');
      default:
        parts.add('command$baseCmd');
    }
    
    // Add flags
    if (cmd.isClose) parts.add('flagClose');
    if (cmd.isCCW) parts.add('flagCCW');
    if (cmd.isCW) parts.add('flagCW');
    
    return parts.join(', ');
  }
}

/// Extension on IVertexSource for convenient vertex access with callback.
extension VertexSourceIOExtension on IVertexSource {
  /// Calls vertex() and passes the x,y values to a callback.
  FlagsAndCommand vertexWithXY(void Function(double x, double y) callback) {
    // This is a workaround since we can't easily get x,y from the vertex call
    // In practice, use the vertices() iterator instead
    for (final v in vertices()) {
      callback(v.x, v.y);
      return v.command;
    }
    return FlagsAndCommand.commandStop;
  }
}

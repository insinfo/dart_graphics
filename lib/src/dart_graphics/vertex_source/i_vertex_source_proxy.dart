// Copyright (c) 2024. All rights reserved.
// Use of this source code is governed by a BSD-style license.
//
// Ported from DartGraphics-sharp/DartGraphics/VertexSource/IVertexSourceProxy.cs
//
// Interface for vertex sources that wrap/proxy another vertex source.

import 'ivertex_source.dart';

/// Interface for vertex sources that proxy/wrap another vertex source.
/// 
/// This interface extends [IVertexSource] and adds a property to get/set
/// the underlying vertex source being proxied. This is useful for
/// transform chains, filters, and other vertex source decorators.
abstract class IVertexSourceProxy implements IVertexSource {
  /// Gets or sets the underlying vertex source being proxied.
  IVertexSource get vertexSource;
  set vertexSource(IVertexSource value);
}

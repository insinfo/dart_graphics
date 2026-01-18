A forma mais “garantida” de ganhar performance em Dart (principalmente numa API 2D pura) é seguir uma ordem: medir → melhorar algoritmo → reduzir alocações → melhorar cache/loops → só então usar pragmas. Abaixo vai um kit bem prático.

1) Meça primeiro (senão você otimiza no escuro)

Ferramentas que valem muito:

Dart DevTools / VM Service: CPU Profiler + Allocation Profiler (descobre onde está gastando tempo e quem está alocando demais).

Timeline (dart:developer): marque trechos críticos e enxergue “buracos” no frame.

Benchmarks micro: Stopwatch + rodar muitas iterações e descartar o “warmup” (JIT otimiza depois de aquecer).

Dica de ouro pra 2D: alocação por frame é inimiga. Descubra quantos bytes você está alocando por frame/por draw e traga isso pra quase zero.

2) Pragmas úteis (VM/AOT e dart2js)

Use pragmas só em funções realmente quentes (hot paths). Os principais:

Para Dart VM / AOT

@pragma('vm:prefer-inline')
Para funções pequenas que são chamadas o tempo todo (ex.: blend de pixel, ler/escrever buffer, clamp).

@pragma('vm:never-inline')
Para funções grandes que “explodem” o código e pioram cache de instrução.

@pragma('vm:entry-point')
Não é performance; é pra evitar tree-shaking quebrando entry points (plugins/reflection). Útil em apps, menos em lib 2D.

Para compilar pra JS (dart2js)

@pragma('dart2js:tryInline') / @pragma('dart2js:noInline')
Sem garantias absolutas, mas pode ajudar em hot paths no alvo web.

Regra prática: 95% dos ganhos vem de dados/algoritmos, não de pragmas.

3) Técnicas que mais dão ganho em render 2D puro Dart
A) Estruturas de dados “de CPU”

Guarde pixels em Uint32List (ARGB/RGBA packed).
Evite List<Color>, objetos, getters etc.

Para geometria: use Float32List/Int32List em vez de List<double> com objetos auxiliares.

Use SoA (structure-of-arrays) em vez de AoS quando possível:

melhor cache: x[], y[], w[] em listas separadas.

B) Zerar alocações no caminho quente

Evite criar Offset, Point, Rect em loops internos.

Reuse buffers:

um Uint32List de “scanline”

um cache de Edge/Segment com pooling simples

Evite sublist, map, where, forEach em trechos críticos.

C) Loops e branches: o básico que costuma virar 2x–10x

Prefira for (var i = 0; i < n; i++) a iteradores.

Remova bounds-checks indiretos (principalmente se você faz list[i] muitas vezes com índices não triviais).

Reduza if dentro do loop:

faça “clipping” e “trivial reject” antes, pra entrar no loop já no caso comum.

D) Cache locality (isso é enorme em raster)

Use tiling (ex.: blocos 16x16 ou 32x32) quando aplicar filtros, blend e composição.

Para paths complexos: binning de primitivas por tile (cada tile processa só o que intersecta).

E) Matemática

Evite trigonometria no loop: pré-calcule tabelas (sin/cos) quando fizer sentido.

Considere fixed-point (ex.: 16.16) em:

raster de linhas, curvas, edges

incremento de coordenadas por scanline
Em muitos casos double é ok, mas fixed-point pode reduzir custo e dar determinismo.

F) Antialias e blending com custo controlado

Linhas: Bresenham (rápido) ou Xiaolin Wu (AA).

Polígonos: scanline fill com Edge Table + Active Edge Table.

AA mais barato: coverage por subpixel 2x2 ou 4x (supersampling parcial) em regiões de borda, não na tela toda.

4) Coisas específicas de uma API 2D (arquitetura que performance gosta)
Pipeline recomendado

Culling / bounding boxes (trivial reject)

Clipping (Cohen–Sutherland / Liang–Barsky pra linhas; Sutherland–Hodgman pra polígonos)

Tessellation (se tiver curvas): flatten com tolerância adaptativa

Binning por tiles

Raster (scanlines) escrevendo em Uint32List

Composição e blend

Tenha um caminho “fast” para casos comuns:

opaco, sem alpha

alpha constante

formato de pixel único

Evite converter formato toda hora. Converta uma vez por camada.

5) Um exemplo de “estilo” de hot path (pixel loop)

Ideia (não é biblioteca completa): manter tudo “simples” pra VM otimizar bem.

@pragma('vm:prefer-inline')
int blendSrcOver(int dst, int src) {
  final sa = (src >>> 24) & 0xFF;
  if (sa == 255) return src;
  if (sa == 0) return dst;

  final inv = 255 - sa;

  final sr = (src >>> 16) & 0xFF;
  final sg = (src >>> 8) & 0xFF;
  final sb = src & 0xFF;

  final dr = (dst >>> 16) & 0xFF;
  final dg = (dst >>> 8) & 0xFF;
  final db = dst & 0xFF;
  final da = (dst >>> 24) & 0xFF;

  final outA = sa + ((da * inv + 127) ~/ 255);
  final outR = sr + ((dr * inv + 127) ~/ 255);
  final outG = sg + ((dg * inv + 127) ~/ 255);
  final outB = sb + ((db * inv + 127) ~/ 255);

  return (outA << 24) | (outR << 16) | (outG << 8) | outB;
}

void fillSpan(Uint32List buf, int offset, int count, int src) {
  var i = 0;
  final end = offset + count;
  if (((src >>> 24) & 0xFF) == 255) {
    for (var p = offset; p < end; p++) {
      buf[p] = src;
    }
  } else {
    for (var p = offset; p < end; p++) {
      buf[p] = blendSrcOver(buf[p], src);
    }
  }
}


O ganho aqui vem do padrão: ramo rápido para opaco, função pequena inline, Uint32List, loops simples.

6) Referências (algoritmos/teoria) que mais ajudam em 2D CPU

Análise de complexidade (Big-O) e trade-offs tempo/memória.

Cache-aware programming (tiling, SoA, minimizar memória “espalhada”).

Rasterização clássica: Bresenham, scanline polygon fill, edge tables.

Clipping: Cohen–Sutherland, Liang–Barsky, Sutherland–Hodgman.

AA: Xiaolin Wu, supersampling parcial, cobertura por área.

Estruturas espaciais: grids, quadtrees (pra hit-test e culling).

Otimizar uma API de gráficos 2D em "puro Dart" exige um foco intenso em gerenciamento de memória, uso eficiente da CPU e aproveitamento das características da Dart VM (especialmente o compilador AOT para Flutter/Mobile ou JIT para desenvolvimento).Aqui está um guia estruturado sobre como abordar essa otimização:1. Estruturas de Dados e dart:typed_dataPara gráficos, o uso de coleções padrão (List<double>) é frequentemente o maior gargalo devido ao boxing (empacotamento de objetos) e falta de localidade de cache.Typed Data: Use sempre Float32List, Float64List, Int32List, etc., para armazenar vértices, coordenadas de texturas e cores. Eles são mapeados diretamente para arrays nativos de C++, eliminando o overhead de objetos Dart.SIMD (Single Instruction, Multiple Data): Utilize Float32x4 e Int32x4 (disponíveis em dart:typed_data). Isso permite processar 4 números de ponto flutuante simultaneamente em uma única instrução de CPU. É vital para operações de matrizes e vetores em gráficos.Exemplo: Somar dois vetores de 4 posições (x, y, z, w) leva 1 operação em vez de 4.2. Gerenciamento de Memória e GC (Garbage Collection)Em loops de renderização (que rodam 60-120 vezes por segundo), alocar novos objetos é proibitivo. O Garbage Collector (GC) causará "engasgos" (jank) se rodar durante um frame.Object Pooling: Reutilize objetos em vez de criá-los a cada frame. Se você tem uma classe Vector2 ou Rect, crie um "pool" e recicle as instâncias.Evite Closures em Loops: Evite criar funções anônimas ou lambdas dentro do método render ou update, pois elas alocam memória.Mutable vs Immutable: Para alta performance em gráficos puros, objetos mutáveis costumam ser preferíveis para evitar alocação. Em vez de v1 = v1 + v2 (que cria um novo v1), prefira métodos como v1.add(v2) que alteram o objeto in-place.3. Pragmas e Dicas ao CompiladorO Dart permite o uso de anotações para guiar o compilador, embora deva ser usado com parcimônia e testado com benchmarks.@pragma('vm:prefer-inline'): Esta é a anotação mais importante para gráficos. Coloque-a em métodos pequenos e frequentemente chamados (como getters, setters, multiplicações de vetores ou verificações de colisão simples). Isso instrui a VM a tentar substituir a chamada da função pelo corpo da função, eliminando o overhead da chamada.Dart@pragma('vm:prefer-inline')
double get area => width * height;
Evite dynamic: O uso de tipos dinâmicos desativa a maioria das otimizações do compilador. Garanta que todo o seu código crítico seja estaticamente tipado.4. Ferramentas de Perfilamento (Profiling)Não otimize sem medir. O Dart oferece ferramentas robustas:Dart DevTools (CPU Profiler): Use para identificar quais métodos consomem mais tempo de CPU. Procure por "hot paths" (caminhos quentes).Memory View: Verifique o gráfico de alocação. Se você vir um padrão de "dentes de serra" frequente, você está alocando muito lixo no loop de renderização (memory churn).Benchmark Harness: Utilize o pacote package:benchmark_harness para criar micro-benchmarks isolados para suas funções matemáticas e algoritmos de renderização.5. Algoritmos e Teorias para Gráficos 2DPara uma API de gráficos, a otimização algorítmica supera a otimização de código puro.Spatial Partitioning (Particionamento Espacial):Não verifique colisão ou renderização de todos os objetos contra todos.Use Quadtrees ou Grids Espaciais para dividir o mundo 2D. Processe apenas o que está na tela ou próximo a ela.Batching (Lotes):A operação mais cara em gráficos é enviar comandos para a GPU (Draw Calls).Agrupe objetos que usam a mesma textura ou shader e desenhe-os de uma vez só. Em vez de desenhar 1000 sprites individualmente, desenhe 1 malha contendo 1000 sprites.Culling (Descarte):Frustum Culling: Se um objeto está fora da "câmera", nem tente processá-lo.Dirty Rectangles:Se apenas uma parte da tela mudou, não redesenhe a tela inteira. Redesenhe apenas a região afetada.Resumo TécnicoÁreaAção RecomendadaMatemáticaUse Float32x4 (SIMD) para vetores/matrizes.MemóriaImplemente Object Pooling para objetos de vida curta.CompiladorUse @pragma('vm:prefer-inline') em métodos pequenos ("hot methods").EstruturaUse Float32List em vez de List<double>.AlgoritmoImplemente Batching de draw calls e Quadtrees.
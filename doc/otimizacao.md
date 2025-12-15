O algoritmo de rasterização em CPU mais eficiente para triângulos hoje é a Rasterização em Ladrilhos Hierárquica Otimizada com SIMD ( SIMD-Optimized Hierarchical Tiled Rasterization).

Em termos práticos e industriais, a "bíblia" moderna sobre o assunto não é um paper acadêmico tradicional, mas sim a documentação técnica do Nanite (Unreal Engine 5) apresentada na SIGGRAPH 2021.

1. O Algoritmo: Rasterização em Ladrilhos (Tiled Rasterization)
A abordagem clássica de desenhar linha por linha (scanline) é ineficiente para CPUs modernas devido à péssima previsibilidade de memória. O método moderno funciona assim:

Binning (Ladrilhamento): A tela é dividida em pequenos blocos (ex: 32x32 ou 64x64 pixels). Os triângulos são classificados e atribuídos a esses blocos.

Funções de Borda (Pineda's Edge Functions): Em vez de calcular intersecções de linhas, a CPU usa matemática vetorial (SIMD - AVX2/AVX-512) para testar se múltiplos pixels dentro de um bloco estão "dentro" das 3 arestas do triângulo simultaneamente.

Hierarquia (Hi-Z): Usa-se um buffer de profundidade hierárquico. Se um bloco inteiro da tela já está "atrás" da geometria existente (testado via SIMD), o rasterizador descarta o bloco inteiro sem processar os pixels individuais.

2. O "Paper" Moderno (Estado da Arte)
Se você quer estudar a implementação mais eficiente do mundo hoje (que supera até o hardware dedicado para triângulos minúsculos), o documento é:

"Nanite: A Deep Dive into Virtualized Geometry" Autores: Brian Karis, Rune Stubbe, Graham Wihlidal (Epic Games) Conferência: SIGGRAPH 2021 (Course Notes)

Por que este é o estado da arte? Embora o Nanite rode frequentemente em Compute Shaders (na GPU), ele é um rasterizador via software (ele ignora o hardware de rasterização tradicional da placa de vídeo). Ele implementa duas variantes ultra-otimizadas que também se aplicam à CPU:

Cluster Culling: Remove grupos de triângulos invisíveis antes de desenhar.

Micropoly Rasterizer: Para triângulos do tamanho de pixels, ele usa uma técnica baseada em atomics de 64-bits (software) que é mais rápida que o hardware.

3. Alternativa Acadêmica (Pure CPU)
Se o seu foco é estritamente CPU (sem envolver Compute Shaders de GPU), o estado da arte para algoritmos focados em Occlusion Culling (Culling de Oclusão) é baseado no trabalho da Intel:

Técnica: Masked Occlusion Culling (MOC).

Implementação: Usa instruções AVX-512 para atualizar e testar um depth buffer hierárquico em software. É usado por engines como Frostbite e Unity para decidir o que não enviar para a GPU.

Resumo da Recomendação: Para aprender a teoria moderna, estude o Course Notes do Nanite (SIGGRAPH 2021). Para código puro em C++ focado em CPU, procure implementações de "SIMD Software Occlusion Culling" baseadas em Masked Rasterization.

Nanite: A Deep Dive into Virtualized Geometry O vídeo acima é a apresentação técnica oficial da equipe da Epic Games detalhando como o Nanite utiliza rasterização por software altamente otimizada para alcançar geometria virtualizada em tempo real.

4) Qual algoritmo de rasterização mais eficiente em CPU?

O “mais eficiente” (em vetor 2D com AA e composição) quase sempre acaba sendo uma combinação de ideias, não um truque único:

Tiling/binning: separar o desenho em tiles (ex.: 16×16 / 32×32) para melhorar cache e reduzir trabalho inútil.

Scanline / edge-walking (ativos por varredura): preencher polígonos/paths com estrutura de “arestas ativas” e updates incrementais (barato por pixel).

Máscara de cobertura (A8) + composição vetorizada: gerar uma máscara de cobertura e depois “rodar o pipeline de pixels” o mais rápido possível, usando SIMD (AVX2/NEON etc.). O próprio Skia descreve esse desenho de arquitetura no backend de CPU e o SkRasterPipeline é onde entra pesado o vetor/SIMD. 
skia.googlesource.com

Isso é, na prática, o tipo de abordagem que aparece nos renderizadores modernos de software.

5) Paper moderno sobre rasterização eficiente

Para “papers modernos”, uma parte grande do que saiu recentemente veio do lado diferenciável (porque precisa rasterizar rápido e com gradiente), mas as ideias de aceleração podem ser úteis para CPU também:

“Bézier Splatting for Fast and Differentiable Vector Graphics …” (NeurIPS 2025) — foca explicitamente em acelerar a etapa de rasterização para curvas. 
neurips.cc

“OmniSVG …” (arXiv 2025) — não é “um paper de rasterização pura”, mas referencia rasterizadores vetoriais diferenciáveis (ex.: DiffVG) no contexto de pipeline moderno e escalável. 
arXiv

Se você me disser seu caso principal (ex.: “muito SVG de ícones”, “muito path complexo com stroke”, “texto pesado”, “muita transparência e filtros”), eu te digo qual parte do pipeline vale otimizar primeiro e como isso conversa com Skia/Cairo/AGG na prática.

Excelente pergunta, que vai ao cerne da computação gráfica em tempo real. A resposta é multifacetada, pois "o mais eficiente" depende muito do que está sendo renderizado (triângulos pequenos, grandes, muitos, poucos) e da arquitetura da CPU.
No entanto, há um consenso claro na indústria hoje: o algoritmo de renderização de rasterização mais eficiente para CPUs modernas (com suporte a SIMD) é uma variação do Scanline Rasterization com Otimizações de Tile/Bloco e processamento SIMD.
Vamos detalhar isso.
O Algoritmo Mais Eficiente: Tile-Based Scanline Rasterization com SIMD
Não se trata de um único algoritmo com um nome famoso, mas sim de uma combinação de técnicas que, juntas, formam o estado da arte para rasterização em CPU.
Scanline Rasterization: A base de tudo. Em vez de testar cada pixel da tela para ver se ele está dentro de um triângulo (como em algoritmos mais simples), ele itera sobre as linhas horizontais (scanlines) que cruzam o triângulo. Para cada linha, ele calcula os pontos de interseção de início e fim e preenche os pixels entre eles. Isso já é muito mais eficiente porque evita testar pixels que estão claramente fora.
Half-Space Functions (ou Edge Functions): Esta é a técnica matemática fundamental usada hoje. Um triângulo é definido pela interseção de três "meio-espaços" criados por suas arestas. A função de aresta E(x, y) = (x - x₀)(y₁ - y₀) - (y - y₀)(x₁ - x₀) calcula de que lado de uma aresta um ponto (x, y) se encontra.
Se o resultado for positivo, está de um lado.
Se for negativo, está do outro.
Se for zero, está exatamente na linha.
Um pixel está dentro do triângulo se ele estiver no "lado interno" das três arestas. Essa abordagem é elegante, numericamente robusta e altamente paralelizável.
Otimização de Tile/Bloco (Tiled Rasterization): Esta é a otimização crucial para CPUs modernas. Em vez de processar a tela inteira, a tela é dividida em pequenos blocos (tiles), como 8x8 ou 16x16 pixels.
Passo 1 (Binning): Primeiro, a lista de triângulos é processada e cada triângulo é colocado em uma "caixa" (bin) correspondente a cada tile que ele sobrepõe.
Passo 2 (Rasterização por Tile): Em seguida, o rasterizador processa um tile de cada vez. Ele só precisa considerar os triângulos que estão na "caixa" daquele tile.
Por que é eficiente? Isso melhora drasticamente a localidade de cache. Todos os acessos de leitura e escrita para os pixels, texturas e outros dados de um tile acontecem em uma região de memória pequena e contígua, evitando "cache misses", que são extremamente custosos para a CPU.
Processamento SIMD (Single Instruction, Multiple Data): Esta é a chave para o alto desempenho. Instruções como SSE, AVX (Intel/AMD) e NEON (ARM) permitem que a CPU execute a mesma operação (ex: a função de aresta) em múltiplos pixels (4, 8, ou até 16) de uma só vez.
O rasterizador baseado em tiles é perfeito para isso. Dentro de um tile 8x8, você pode carregar um bloco de 2x2 ou 4x2 pixels e avaliar as funções de aresta para todos eles simultaneamente. Isso multiplica a taxa de preenchimento (fill-rate) por um fator significativo.
Em resumo: O algoritmo mais eficiente hoje calcula as funções de aresta para blocos de pixels (ex: 2x2) dentro de tiles (ex: 8x8), usando instruções SIMD para processar esses blocos em paralelo.
Paper Moderno Sobre o Assunto
Encontrar um "paper" acadêmico recente sobre este exato tópico é um pouco complicado, porque muitas dessas técnicas foram desenvolvidas e refinadas internamente por empresas (Intel, AMD, NVIDIA, Google) e publicadas em blogs de desenvolvedores ou como parte de bibliotecas de código aberto, em vez de artigos acadêmicos formais. A pesquisa acadêmica tende a focar em algoritmos de renderização mais complexos (como Ray Tracing).
No entanto, um dos recursos mais citados e influentes que descreve uma implementação de CPU de alto desempenho é o "A trip through the Graphics Pipeline" de Fabian "ryg" Giesen. Embora não seja um "paper" formal, seus artigos de blog são considerados uma referência fundamental na área.
Referência Principal: Fabian Giesen's Blog - "A trip through the Graphics Pipeline"
Link Relevante (Rasterization): https://fgiesen.wordpress.com/2013/02/17/a-trip-through-the-graphics-pipeline-2011-part-5/
Nesta série de posts, ele detalha a implementação de um rasterizador de software, cobrindo funções de aresta, otimizações de ponto fixo e a lógica geral. É uma leitura essencial.
Outra excelente referência, que é um projeto de código aberto com documentação que serve como um "paper vivo", é a biblioteca Blend2D.
Blend2D - Rasterizer & Rendering Engine
Link: https://blend2d.com/
O autor, Petr Kobalíček, documentou extensivamente o design do rasterizador, que é baseado em tiles e massivamente otimizado com JIT-compilation de pipelines de renderização usando a biblioteca AsmJit. Ele afirma superar tanto o Cairo quanto o Skia em muitos benchmarks de CPU. A arquitetura é o estado da arte em renderização 2D na CPU.
Conclusão: Não há um único "paper" que você possa citar como "o algoritmo de rasterização de 2025". Em vez disso, o estado da arte é uma coleção de melhores práticas (scanline, edge functions, tiling, SIMD) que foram validadas e implementadas em bibliotecas de alto desempenho como Skia, Blend2D e nas implementações de referência de drivers de software. O blog de Fabian Giesen é o ponto de partida canônico para entender os fundamentos.
Espero que isso tenha sido esclarecedor! Podemos agora:
Discutir como essas técnicas se aplicam a diferentes tipos de primitivas (linhas, pontos)?
Explorar a diferença entre rasterização e ray tracing em mais detalhes?
Analisar o código-fonte de uma implementação simples de rasterizador?
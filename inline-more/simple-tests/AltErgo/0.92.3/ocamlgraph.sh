#!/bin/sh

ocamlpack -o ocamlgraph.ml src/sig.ml src/sig_pack.ml src/dot_ast.ml lib/unionfind.ml lib/heap.ml lib/bitv.ml src/version.ml src/util.ml src/blocks.ml src/persistent.ml src/imperative.ml src/delaunay.ml src/builder.ml src/classic.ml src/rand.ml src/oper.ml src/path.ml src/traverse.ml src/coloring.ml src/topological.ml src/components.ml src/kruskal.ml src/flow.ml src/graphviz.ml src/gml.ml src/dot_parser.ml src/dot_lexer.ml src/dot.ml src/pack.ml src/gmap.ml src/minsep.ml src/cliquetree.ml src/mcs_m.ml src/md.ml src/strat.ml



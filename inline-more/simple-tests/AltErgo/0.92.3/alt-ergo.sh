#!/bin/sh

ocamlpack -rec  -o alt-ergo.ml version.ml exception.ml print_color.ml options.ml loc.ml hashcons.ml hstring.ml builtin.ml symbols.ml subst.ml ty.ml why_ptree.ml common.ml term.ml literal.ml formula.ml explanation.ml why_parser.ml why_lexer.ml pretty.ml smt_ast.ml smt_parser.ml smt_lex.ml smt_to_why.ml smtlib2_util.ml smtlib2_ast.ml smtlib2_parse.ml smtlib2_lex.ml smtlib2_to_why.ml polynome.ml sig.ml ac.ml uf.ml use.ml intervals.ml fm.ml arith.ml pairs.ml bitv.ml arrays.ml sum.ml combine.ml cc.ml heap.ml existantial.ml pruning.ml triggers.ml cnf.ml why_typing.ml matching.ml sat.ml frontend.ml main.ml

cat ocamlgraph.ml alt-ergo.ml > altergo.ml

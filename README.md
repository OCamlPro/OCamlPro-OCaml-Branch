Functorize a Library
====================

The goal of this branch is to experiment with the idea of trying to
functorize a whole library, i.e. have a library of different
compilation units be used as a functor parameterized on another
compilation unit.

Usage
=====

ocamlc -c x.mli
ocamlc -c -functor X a.ml
ocamlc -c -functor X b.ml
ocamlc -c -functor X -pack -o lib.cmo a.cmo b.cmo

The Lib module now has the following interface:

module Lib : sig
  module Functor(X : X) : sig
    module A : A
    module B : B
  end
end

Several levels of -functor can be used together, to allow functorized
libraries within other functorized libraries.

Roadmap
=======

1. Write a simple example
2. Modify ocp-pack to handle the same problem
3. Add -functor and -pack-functor options
4. Typing:
  4.1 Load the arguments into the environment before typing
  4.2 Modify the cmi format to show the dependency on the arguments
  4.3 Check that loaded interface units depend on a subset of the arguments
5. Lambda-code:
  4.4 Modify the generated lambda code for -functor units to use them
       as functions
  4.5 Generate special lambda-code for -functor-pack

What we want to have:
- generate a .cmi file for the functor. The type should be

module XXXX : functor(X : Sig) -> sig
  module A : sig ... end
  module B : sig ... end
  ...
end

- generate a .lam file for the functor

Except for the arguments, for which we immedialty use their local identifiers,
we postpone the creation of the actual wrappers until code generation, i.e.
in bytegen.ml for bytecode, and in cmmgen.ml for asmcode.



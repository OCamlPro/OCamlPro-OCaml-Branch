(***********************************************************************)
(*                                                                     *)
(*                           Objective Caml                            *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(***********************************************************************)
(*                                                                     *)
(*                    Contributed by OCamlPro                          *)
(*                                                                     *)
(***********************************************************************)

(* $Id$ *)

(*
   Transformation of recursive functions into loops, at the lambda code
   level.

   Recursive functions are usually transformed into loops later,
   during the code linearization in ocamlopt. Doing it earlier has
   many benefits: loops are inlined, while recursive functions are not
   (yet). Recursive calls make the code generator believes that the
   parameters are escaping the function, causing unnecessary boxing of
   floats.

*)

val simplify : Lambda.lambda -> Lambda.lambda

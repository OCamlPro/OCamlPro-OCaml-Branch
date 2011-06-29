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

val clambda_iter :
  (Clambda.ulambda -> unit) -> Clambda.ulambda -> unit

val clambda_map :
  (Clambda.ulambda -> Clambda.ulambda) -> Clambda.ulambda -> Clambda.ulambda

val optimize : Format.formatter -> Clambda.ulambda -> Clambda.ulambda

(*
val count_uses :
  Clambda.ulambda ->
  (Clambda.function_label, int ref) Hashtbl.t * (Ident.t, int ref) Hashtbl.t
*)


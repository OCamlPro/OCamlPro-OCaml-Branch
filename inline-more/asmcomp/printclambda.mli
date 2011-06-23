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

(* $Id: clambda.mli 7812 2007-01-29 12:11:18Z xleroy $ *)

open Clambda

val print_ulambda_if : Format.formatter -> bool -> string -> ulambda -> unit
val print_ulambda : Format.formatter -> ulambda -> unit
val clear_approximations : unit -> unit
val add_approximation : Ident.t -> Clambda.value_approximation -> unit


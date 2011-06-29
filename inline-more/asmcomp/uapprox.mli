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

type value_approximation =
    Approx_unknown
  | Approx_function of function_approximation
  | Approx_closure of int * value_approximation array
  | Approx_shared of value_approximation * Asttypes.mutable_flag *
      Lambda.structured_constant * string
  | Approx_block of int * value_approximation list
  | Approx_constant of Asttypes.constant
  | Approx_pointer of int
  | Approx_immstring of string
  | Approx_exit

and function_approximation = {
  mutable fun_result : value_approximation;
  fun_desc : Clambda.function_description;
  mutable fun_inlined : bool;
  mutable fun_body : Clambda.ulambda;
}

type catch_approx = {
  mutable catch_uses : int;
  mutable catch_args : value_approximation list list;
}

type approx_env = {
  env_vars : (Ident.t, value_approximation) Tbl.t;
  env_catches : (int, catch_approx) Tbl.t;
}

val merge_approx : value_approximation list -> value_approximation

(* For pretty-printing *)
val add_approximation : Ident.t -> value_approximation -> unit
val print_approx : Format.formatter -> value_approximation -> unit

val value_of_approximation : value_approximation -> Clambda.ulambda
val approx_of_approx : value_approximation -> Clambda.value_approximation

val constant_of_approximation :
  value_approximation -> Lambda.structured_constant
val approximation_of_constant :
  Lambda.structured_constant -> value_approximation

(* remove Approx_shared heads *)
val approx_approx : value_approximation -> value_approximation

(* returns true or false options to use if the value is used as a boolean *)
val boolean_approximation : value_approximation -> bool option

val empty_env : unit -> approx_env

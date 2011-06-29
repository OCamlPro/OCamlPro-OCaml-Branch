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

open Format
open Asttypes
open Lambda
open Clambda

(* We should add approximations for all constants ? *)
type value_approximation =
  | Approx_unknown
  | Approx_function of function_approximation
  | Approx_closure of int * value_approximation array
  | Approx_shared of value_approximation * mutable_flag * structured_constant * string
  | Approx_block of int * value_approximation list
  | Approx_constant of constant
  | Approx_pointer of int
  | Approx_immstring of string
  | Approx_exit (* no value is returned *)

and function_approximation = {
  mutable fun_result : value_approximation;
  fun_desc : function_description;
  mutable fun_inlined : bool;
  mutable fun_body : ulambda;
}

type catch_approx = {
  mutable catch_uses : int;
  mutable catch_args : value_approximation list list;
}

type approx_env = {
  env_vars : (Ident.t, value_approximation) Tbl.t;
  env_catches : (int, catch_approx) Tbl.t;
}

(* [merge_approx list] merges approximations: if the same approximation is given
as an output of all branches, the global output is that approximation. It is also
true if some branches do not return. *)
let rec merge_approx approx =
  match approx with
      [] -> Approx_unknown
    | head :: tail -> merge_approx_with_list head tail

and merge_approx_with_list approx list =
  match approx with
      Approx_unknown -> approx
    | _ ->
      match list with
	  [] -> approx
	| head :: tail ->
	  let approx =
	    if approx = head then approx else
	      match approx, head with
		| Approx_exit, _ -> head
		| _, Approx_exit -> approx
		| Approx_block (tag1, args1), Approx_block (tag2, args2) ->
		  if tag1 = tag2 && List.length args1 = List.length args2 then
		    Approx_block (tag1, List.map2 merge_approx2 args1 args2)
		  else
		    Approx_unknown
		| _ -> Approx_unknown
	  in
	  merge_approx_with_list approx tail


and merge_approx2 a1 a2 = merge_approx_with_list a1 [a2]

let rec print_approx ppf approx =
  match approx with
      Approx_constant cst -> Printlambda.structured_constant ppf (Const_base cst)
    | Approx_immstring s ->  Printlambda.structured_constant ppf (Const_immstring s)
    | Approx_block (tag, args) ->
      fprintf ppf "@[<v 3>block(tag=%d)@;" tag;
      List.iter (fun arg -> print_approx ppf arg; fprintf ppf "@;") args;
      fprintf ppf "@]@,"
    | Approx_shared (approx, mut, cst, label) ->
      Printlambda.structured_constant ppf cst
    | Approx_closure _ -> fprintf ppf "<closures>"
    | Approx_function _ -> fprintf ppf "<function>"
    | Approx_exit -> fprintf ppf "<exit>"
    | Approx_unknown -> fprintf ppf "<?>"
    | Approx_pointer n -> fprintf ppf "constptr %d" n

let rec approx_of_approx approx =
  match approx with
      Approx_constant (Const_int n )  -> Value_integer n
    | Approx_constant ( Const_char c)  -> Value_integer (int_of_char c)
    | Approx_constant _ -> Value_unknown

    | Approx_pointer n -> Value_constptr n
    | Approx_block (tag, args) -> Value_tuple (Array.of_list (List.map approx_of_approx args))
    | Approx_shared (approx, _, _, _ ) -> approx_of_approx approx
    | Approx_closure _ -> Value_unknown
    | Approx_function fapp -> Value_closure (fapp.fun_desc, approx_of_approx fapp.fun_result)
    | Approx_exit -> Value_unknown
    | Approx_immstring _ -> Value_unknown
    | Approx_unknown
      -> Value_unknown

let add_approximation id approx =
  Printclambda.add_approximation id (approx_of_approx approx)


let rec constant_of_approximation approx =
  match approx with
    | Approx_constant (Const_int n) -> Const_base (Const_int n)
    | Approx_shared (_, Mutable, _, _)
    | Approx_unknown
    | Approx_closure _
    | Approx_function _
      -> raise Not_found
    | Approx_shared (approx, Immutable, cst, _ ) ->
      cst
    | Approx_block (tag, args) ->
      Const_block (Immutable, tag, List.map constant_of_approximation args)
    | Approx_pointer n -> Const_pointer n
    | Approx_constant cst -> Const_base cst
    | Approx_immstring s -> Const_immstring s
    | Approx_exit -> raise Not_found

(* Return a value to replace [ulam] from the approximation [approx]. For
mutable constants, an approximation can only be returned if the toplevel
value has already a label, to avoid duplicating mutable value. *)

let value_of_approximation approx =
  match approx with
      Approx_shared (approx, _, cst, label) ->
	Uconst (cst, Some label)
    | _ ->
      let cst = constant_of_approximation approx in
      match cst with
	  Const_base(Const_int _ | Const_char _) | Const_pointer _ ->
	    Uconst(cst, None)
	| _ ->
	  Uconst (cst, Some (Compilenv.new_structured_constant cst true))

let rec approx_approx approx =
  match approx with
      Approx_shared (approx, _, _, _) -> approx_approx approx
    | _ -> approx

let rec approximation_of_constant cst =
  match cst with
      Const_base c -> Approx_constant c
    | Const_pointer ptr -> Approx_pointer ptr
    | Const_immstring s -> Approx_immstring s
    | Const_float_array _ -> Approx_unknown
    | Const_block (Mutable, tag, args) -> Approx_unknown
    | Const_block (Immutable, tag, args) ->
      Approx_block (tag, List.map approximation_of_constant args)

let boolean_approximation approx =
  match approx_approx approx with
      Approx_pointer 0 -> Some false
    | Approx_pointer 1 -> Some true
    | Approx_constant (Const_int 0) -> Some false
    | Approx_constant (Const_int 1) -> Some true
    | _ -> None

let empty_env () = {
  env_vars = Tbl.empty;
  env_catches = Tbl.empty;
}

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

let debug_inline2 = Clflags.new_flag Clflags.debug_flags "inline2" false
  "debug second phase of inlining"
let dump_inline2 = Clflags.new_flag Clflags.debug_flags "dump-inline2" false
  "dump tree after second phase of inlining"
let optim_inline2 = Clflags.new_flag Clflags.optim_flags "inline2" true
  "inlining and constant propagation after closure conversion"

type function_approximation = {
  fapprox_result : value_approximation;
}

(* We should add approximations for all constants ? *)
type value_approximation =
  | Approx_unknown
  | Approx_closure of function_approximation
  | Approx_shared of value_approximation * mutable_flag * structured_constant * string
  | Approx_block of int * value_approximation list
  | Approx_constant of constant
  | Approx_pointer of int
  | Approx_immstring of string
  | Approx_exit (* no value is returned *)

module DOIT = struct

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

end

module FAKE = struct
  let merge_approx approx =  Approx_unknown
  let merge_approx_with_list approx list = Approx_unknown
  let  merge_approx2 a1 a2 = Approx_unknown

end

module MERGE = FAKE

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
    | Approx_closure _ -> fprintf ppf "<closure>"
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
    | Approx_closure _ -> raise Not_found
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

let stats = ref []
let new_stats msg =
  let r = ref 0 in
  stats := (msg, r) :: !stats;
  r

let stats_constant_propagated = new_stats "propagated constant"
let stats_switch_removed = new_stats "switch removed"
let stats_removed_after_exit = new_stats "sequence removed"
let stats_catch_removed = new_stats "catch removed"
let stats_while_removed = new_stats "while removed"
let stats_elsebranch_removed = new_stats "else-branch removed"

type catch_approx = {
  mutable catch_uses : int;
  mutable catch_args : value_approximation list list;
}

type env = {
  env_vars : (Ident.t, value_approximation) Tbl.t;
  env_catches : (int, catch_approx) Tbl.t;
}

let empty_env = { env_vars = Tbl.empty;  env_catches = Tbl.empty }

(* [inline env ulam]: [env] is an association between identifiers and approximations *)
let rec inline env ulam =
  match ulam with
    (* DONE *)
    | Uconst (cst, label) ->
      let approx = approximation_of_constant cst in
      let approx = match label with
	  Some label ->
	    (*
	      let mut = if Compilenv.const_is_mutable cst then Mutable else Immutable in
	      Approx_shared (approx, mut, cst, label)
	    *)
	    Approx_unknown
	| None -> approx
      in
      (ulam, approx)

    | Uvar id -> begin try
			 let approx = Tbl.find id env.env_vars in
			 let ulam = try
				      let ulam = value_of_approximation approx in
				      incr stats_constant_propagated;
				      ulam
			   with Not_found -> ulam in
			 (ulam, approx)
      with Not_found -> (ulam, Approx_unknown)

    end

    (*
      | Ulet(str, id, def, body) ->
      let (udef, def_approx) = inline env def in
      let (ubody, body_approx) = inline env body in
      let ulam = Ulet (str, id, udef, ubody) in
      (ulam, body_approx)
    *)
    | Ulet(str, id, def, body) ->
      let (udef, def_approx) = inline env def in
      begin match def_approx with
	  Approx_exit -> (udef, def_approx)
	| _ ->
	  let body_env =
	    match str with
	      | Strict -> { env with env_vars = Tbl.add id def_approx env.env_vars }
	      | _ -> env
	  in
	  let (ubody, body_approx) = inline body_env body in
	  let ulam = Ulet (str, id, udef, ubody) in
	  (ulam, body_approx)
      end

    (*
      | Usequence(u1, u2) ->
      let (u1, u1_approx) = inline env u1 in
      let (u2, u2_approx) = inline env u2 in
      let seq = Usequence (u1, u2) in
      (seq, u2_approx)
    *)

    | Usequence(u1, u2) ->
      let (u1, u1_approx) = inline env u1 in
      begin match u1_approx with
	  Approx_exit ->
	    incr stats_removed_after_exit;
	    (u1, u1_approx)
	| _ ->
	  let (u2, u2_approx) = inline env u2 in
	  let ulam = Usequence (u1, u2) in  (ulam, u2_approx)
      end

    (*
      | Uwhile(cond, body) ->
      let cond, cond_approx = inline env cond in
      let body, body_approx = inline env body in
      let uwhile = Uwhile (cond, body) in
      (uwhile, body_approx)
    *)

    | Uwhile(cond, body) ->
      let cond, cond_approx = inline env cond in
      begin
	match boolean_approximation cond_approx with
	    None
	  | Some true ->
	    (* TODO: if body is small, then unroll loop since we know the body will be
	       executed at least once *)

	    let body, body_approx = inline env body in
	    let uwhile = Uwhile (cond, body) in
	    let while_approx = match body_approx with
		Approx_exit -> Approx_exit
	      | _ -> Approx_pointer 0
	    in
	    (uwhile, while_approx)

	  | Some false ->
	    incr stats_while_removed;
	    (cond, Approx_pointer 0)
      end

      (*
	| Uifthenelse(cond, ifso, ifnot) ->
	let cond, cond_approx = inline env cond in
	let ifso, ifso_approx = inline env ifso in
	let ifnot, ifnot_approx = inline env ifnot in

	let ulam = Uifthenelse (cond, ifso, ifnot) in
	(ulam, Approx_unknown)
      *)
    | Uifthenelse(cond, ifso, ifnot) ->
      let cond, cond_approx = inline env cond in
      begin
	match boolean_approximation cond_approx with
	    None ->
	      let ifso, ifso_approx = inline env ifso in
	      let ifnot, ifnot_approx = inline env ifnot in

	      let ulam = Uifthenelse (cond, ifso, ifnot) in
	      (ulam, MERGE.merge_approx2 ifso_approx ifnot_approx)
	  | Some true ->
	    incr stats_elsebranch_removed;
	    let ifso, ifso_approx = inline env ifso in
	    (Usequence(cond, ifso), ifso_approx)
	  | Some false ->
	    incr stats_elsebranch_removed;
	    let ifnot, ifnot_approx = inline env ifnot in
	    (Usequence (cond, ifnot), ifnot_approx)
      end

    (* TODO: we need to compute purity, and remove "pure" computations,
       when there result is not used. *)

    (* DONE:
       (1) optimize switch from approximation of argument.
       TODO:
       (2) within a switch, set an approximation of the argument. *)
    | Uswitch(arg, s) ->
      let (uarg, arg_approx) = inline env arg in
      begin
	match approx_approx arg_approx with

	  | Approx_pointer n | Approx_constant (Const_int n) ->
	    incr stats_switch_removed;
	    let action = s.us_actions_consts.(s.us_index_consts.(n)) in
	    let action, action_approx = inline env action in
	    Usequence(uarg, action), action_approx

	  | Approx_constant (Const_char c) ->
	    incr stats_switch_removed;
	    let action = s.us_actions_consts.(s.us_index_consts.(int_of_char c)) in
	    let action, action_approx = inline env action in
	    Usequence(uarg, action), action_approx

	  | Approx_block (n, _) ->
	    incr stats_switch_removed;
	    let action = s.us_actions_blocks.(s.us_index_blocks.(n)) in
	    let action, action_approx = inline env action in
	    Usequence(uarg, action), action_approx

	  | Approx_unknown ->
	    let (actions_consts, actions_consts_approx) =
	      List.split (List.map (inline env) (Array.to_list s.us_actions_consts)) in
	    let (actions_blocks, actions_blocks_approx) =
	      List.split (List.map (inline env) (Array.to_list s.us_actions_blocks)) in
	    let ulam =
	      Uswitch (uarg,
		       { s with
			 us_actions_consts = Array.of_list actions_consts;
			 us_actions_blocks = Array.of_list actions_blocks; })
	    in
	    (ulam, MERGE.merge_approx (actions_consts_approx @ actions_blocks_approx))

	  | Approx_exit ->
	    (uarg, arg_approx)

	  | _ ->
	    eprintf "In switch: approximation = [%a]@." print_approx arg_approx;
	    exit 2
      end

      (*
	| Uswitch(arg, s) ->
	let (uarg, arg_approx) = inline env arg in
	let (actions_consts, actions_consts_approx) =
	List.split (List.map (inline env) (Array.to_list s.us_actions_consts)) in
	let (actions_blocks, actions_blocks_approx) =
	List.split (List.map (inline env) (Array.to_list s.us_actions_blocks)) in
	let ulam =
	Uswitch (uarg,
	{ s with
	us_actions_consts = Array.of_list actions_consts;
	us_actions_blocks = Array.of_list actions_blocks; })
	in
	(ulam, Approx_unknown)
      *)

    | Ustaticfail (num, args) ->
      (* TODO: if one of the arguments approximates to Approx_exit,
	 then suppress the other arguments and the fail ? *)
      let args = List.map (inline env) args in
      let (args, args_approx) = List.split args in
      let ulam = Ustaticfail (num, args) in
      begin
	try
	  let catch = Tbl.find num env.env_catches in
	  catch.catch_uses <- catch.catch_uses + 1;
	  catch.catch_args <- args_approx :: catch.catch_args
	with Not_found -> assert false
      end;
      (ulam, Approx_exit)

    | Ucatch(num, ids, body, hdlr) ->
      let catch_approx = {
	catch_uses = 0;
	catch_args = [];
      } in
      let body_env = { env with env_catches = Tbl.add num catch_approx env.env_catches } in
      let (body, body_approx) = inline body_env body in
      if catch_approx.catch_uses = 0 then begin
	incr stats_catch_removed;
	(body, body_approx)
      end else begin
	match catch_approx.catch_args with
	    [] -> assert false (* equiv to catch_uses = 0 ! *)
	  | approx :: next_approx ->
	    let approx = List.fold_left (fun approx next_approx ->
	      List.map2 MERGE.merge_approx2 approx next_approx
	    ) approx next_approx in
	    let vars = List.fold_left2 (fun tbl id approx ->
	      Tbl.add id approx tbl
	    ) env.env_vars ids approx in
	    let hdlr_env = { env with env_vars = vars } in
	    let (hdlr, hdlr_approx) = inline hdlr_env hdlr in
	    let ulam = Ucatch (num, ids,  body, hdlr) in
	    let final_approx = MERGE.merge_approx2 body_approx hdlr_approx in
      (*	    if final_approx <> Approx_unknown then begin
		    fprintf err_formatter "Merge:@.";
		    fprintf err_formatter "Body:\t%a@." print_approx body_approx;
		    fprintf err_formatter "Handler:\t%a@." print_approx hdlr_approx;
		    fprintf err_formatter "Result:\t\t%a@." print_approx final_approx;
		    end; *)
	    (ulam, final_approx)
      end

    (*
      | Ucatch(num, ids, body, hdlr) ->
      let (body, body_approx) = inline env body in
      let (hdlr, hdlr_approx) = inline env hdlr in
      let ulam = Ucatch (num, ids,  body, hdlr) in
      ulam, Approx_unknown

      | Ustaticfail (num, args) ->
      let args = List.map (inline env) args in
      let (args, args_approx) = List.split args in
      let ulam = Ustaticfail (num, args) in
      (ulam, Approx_exit)
    *)

    (* TODO *)
    | Ugeneric_apply(funct, args, debug) ->
      let (ufunct, _funct_approx) = inline env funct in
      let args = List.map (inline env) args in
      let uargs = List.map fst args in
      let ulam = Ugeneric_apply (ufunct, uargs, debug) in
      ulam, Approx_unknown

    | Uoffset(v, ofs) ->
      let (uv, vapprox) = inline env v in
      let ulam = Uoffset (uv, ofs) in
      (ulam, Approx_unknown)

    | Uletrec(decls, body) ->
      let decls = List.map (fun (id, u) -> (id, inline env u)) decls in
      let udecls = List.map (fun (id, (ulam, u_approx)) -> (id, ulam)) decls in
      let (ubody, body_approx) = inline env body in
      let ulam = Uletrec (udecls, ubody) in
      (ulam, Approx_unknown)

    | Uprim(p, args, debug) ->
      let args = List.map (inline env) args in
      let uargs = List.map fst args in
      let ulam = Uprim (p, uargs, debug) in
      (ulam, Approx_unknown)

    | Utrywith(body, exn, hdlr) ->
      let ulam = Utrywith (inline_no_approx env body, exn, inline_no_approx env hdlr) in
      (ulam, Approx_unknown)

    (*
      | Uifthenelse(cond, ifso, ifnot) ->
      let ulam =
      Uifthenelse (inline_no_approx env cond, inline_no_approx env ifso, inline_no_approx env ifnot)
      in
      (ulam, Approx_unknown)
    *)

    | Ufor(id, lo, hi, dir, body) ->
      let ulam = Ufor(id, inline_no_approx env lo, inline_no_approx env hi, dir, inline_no_approx env body) in
      (ulam, Approx_unknown)

    | Uassign(id, u) ->
      let ulam = Uassign  (id, inline_no_approx env u) in
      (ulam, Approx_unknown)

    | Usend(k, met, obj, args, debug) ->
      let ulam = Usend (k, inline_no_approx env met, inline_no_approx env obj, List.map (inline_no_approx env) args, debug) in
      (ulam, Approx_unknown)

    | Udirect_apply (label, args, debug) ->
      let ulam = Udirect_apply (label, List.map (inline_no_approx env) args, debug) in
      (ulam, Approx_unknown)

    | Uclosure (defs, fv) ->
      let ulam = Uclosure (List.map (fun (clos, ubody) ->
        (clos, inline_no_approx env ubody)) defs, List.map (inline_no_approx env) fv) in
      (ulam, Approx_unknown)

and inline_no_approx env ulam =
  let (ulam, approx) = inline env ulam in ulam

let print_stats ppf pass (msg, stats) =
  if !stats <> 0 then
    Format.fprintf ppf "STATS %s:\t%s:\t%d@." pass msg !stats

let optimize ppf ulam =
  if !optim_inline2 then begin

    if !debug_inline2 then begin
      Format.fprintf ppf "Second pass of inlining...@.";
      List.iter (fun (_, r) -> r := 0) !stats;
    end;

    let (ulam,_) = inline empty_env ulam in

    if !debug_inline2 then
      List.iter (print_stats ppf "inline2") !stats;

    if !Clflags.dump_closure || !dump_inline2 then begin
      Format.fprintf ppf "*** Clambda: after second inlining:@;%a@."
	Printclambda.print_ulambda ulam;
    end;

    ulam
  end else begin
    if !debug_inline2 then
      Format.fprintf ppf "No second pass of inlining...@.";
      ulam
    end

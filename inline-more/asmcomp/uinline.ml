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
open Uapprox

module List2 = struct
  include List

  let rec last list =
    match list with
	[] -> raise (Invalid_argument "List.last")
      | [ last ] -> last
      | _ :: tail -> last tail
end

(* TODO:
- improve approximation of closures in closure.ml in the case where a function is
too big to be inlined => check the possibility to inline a prelude.
*)

let debug_inline2 = Clflags.new_flag Clflags.debug_flags "inline2" false
  "debug second phase of inlining"
let dump_inline2 = Clflags.new_flag Clflags.debug_flags "dump-inline2" false
  "dump tree after second phase of inlining"
let optim_inline2 = Clflags.new_flag Clflags.optim_flags "inline2" true
  "inlining and constant propagation after closure conversion"

let stats = ref []
let new_stats msg =
  let r = ref 0 in
  stats := (msg, r) :: !stats;
  r

let stats_constant_propagated = new_stats "propagated constant"
let stats_switch_removed = new_stats "switch removed"
let stats_removed_after_exit = new_stats "after exit removed"
let stats_catch_removed = new_stats "catch removed"
let stats_while_removed = new_stats "while removed"
let stats_elsebranch_removed = new_stats "else-branch removed"
let stats_new_direct_call = new_stats "new direct call"
let stats_inlined_function = new_stats "inlined function"

let inline_primitive p args debug =
  let uargs = List.map fst args in
  let ulam = Uprim (p, uargs, debug) in
  (ulam, Approx_unknown)

let label_approx = Hashtbl.create 17
let label_uses = Hashtbl.create 17
let var_uses = Hashtbl.create 17

let count_uses ulam =
  Hashtbl.clear label_uses;
  Hashtbl.clear var_uses;
  let rec counter ulam =
    begin
      match ulam with
	  Uvar id ->
	    begin try incr (Hashtbl.find var_uses id) with Not_found ->
	      let r = ref 1 in Hashtbl.add var_uses id r; end
	| Udirect_apply (fundesc, _, _) ->
	  let label = fundesc.fun_label in
	    begin try incr (Hashtbl.find label_uses label) with Not_found ->
	      let r = ref 1 in Hashtbl.add label_uses label r; end
	| _ -> ()
    end;
    Usimplif.clambda_iter counter ulam;
    (* We want to detect the case where a function is only used once, in
       which case it is natural to inline it whatever its size is.
    begin
      match ulam with
	| Ulet(Strict, var, Uclosure ([fundesc], _), body) ->
	  let var_uses =
    end
    *)
  in
  counter ulam


(* [inline env ulam]: [env] is an association between identifiers and
   approximations *)
(* TODO: before calling inline, we should probably run a simple pass
   to compute how many times every function is used, so that we can
   directly inline functions used only once. *)
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
	  Approx_exit ->
	    incr stats_removed_after_exit;
	    (udef, def_approx)
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
    (* TODO: check that when removing dead code after a non-returning
       expresion, the compiler is not fooled during code generation
       for floats.  *)
    | Uwhile(cond, body) ->
      let cond, cond_approx = inline env cond in
      begin
	match cond_approx with
	    Approx_exit ->
	      incr stats_removed_after_exit;
	      (cond, cond_approx)
	  | _ ->
	    match boolean_approximation cond_approx with
		None
	      | Some true ->
		(* TODO: if body is small, then unroll loop since we know the body will be
		   executed at least once *)

		let body, body_approx = inline env body in
		begin
		  match body_approx with
		      Approx_exit ->
			incr stats_removed_after_exit;
			(Usequence(cond, body), Approx_exit)
		    | _ ->
		      (Uwhile (cond, body), Approx_pointer 0)
		end

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
	match cond_approx with
	    Approx_exit ->
	      incr stats_removed_after_exit;
	      (cond, cond_approx)
	  | _ ->
	    match boolean_approximation cond_approx with
		None ->
		  let ifso, ifso_approx = inline env ifso in
		  let ifnot, ifnot_approx = inline env ifnot in

		  let ulam = Uifthenelse (cond, ifso, ifnot) in
		  (ulam, merge_approx [ifso_approx; ifnot_approx])
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
	    (ulam, merge_approx (actions_consts_approx @ actions_blocks_approx))

	  | Approx_exit ->
	    incr stats_removed_after_exit;
	    (uarg, arg_approx)

	  | _ ->
	    eprintf "Error in switch: approximation = [%a]@." print_approx arg_approx;
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
	      List.map2 (fun x y -> merge_approx [x;y]) approx next_approx
	    ) approx next_approx in
	    let vars = List.fold_left2 (fun tbl id approx ->
	      Tbl.add id approx tbl
	    ) env.env_vars ids approx in
	    let hdlr_env = { env with env_vars = vars } in
	    let (hdlr, hdlr_approx) = inline hdlr_env hdlr in
	    let ulam = Ucatch (num, ids,  body, hdlr) in
	    let final_approx = merge_approx [body_approx; hdlr_approx] in
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


    | Uassign(id, u) ->
      let (u, u_approx) = inline env u in
      begin match u_approx with
	  Approx_exit ->
	    incr stats_removed_after_exit;
	    (u, u_approx)
	| _ ->
	  let ulam = Uassign  (id, u) in
	  (ulam, Approx_pointer 0)
      end

    | Ufor(id, lo, hi, dir, body) ->
      let lo, lo_approx = inline env lo in
      begin match lo_approx with
	  Approx_exit ->
	    incr stats_removed_after_exit;
	    (lo, lo_approx)
	| _ ->
	  let hi, hi_approx = inline env hi in
	  match hi_approx with
	      Approx_exit ->
		incr stats_removed_after_exit;
		Usequence (lo, hi), hi_approx
	    | _ ->
	      let body, body_approx = inline env body in
	      match body_approx with
		  Approx_exit ->
		    incr stats_removed_after_exit;
		    Usequence (lo, Usequence(hi, body)), hi_approx
		| _ ->
		  let ulam = Ufor(id, lo, hi, dir, body) in
		  (ulam, Approx_pointer 0)
      end

    | Utrywith(body, exn, hdlr) ->
      let body, body_approx = inline env body in
      let hdlr, hdlr_approx = inline env hdlr in
      let ulam = Utrywith (body, exn, hdlr) in
      (ulam, merge_approx [body_approx; hdlr_approx])

    (* TODO: should we try to do some analysis for objects and classes
       ? *)
    | Usend(k, met, obj, args, debug) ->
      let ulam = Usend (k, inline_no_approx env met, inline_no_approx env obj,
			List.map (inline_no_approx env) args, debug) in
      (ulam, Approx_unknown)

    (* TODO: optimize this case, although it is probably a not very used
       idiom. *)
    | Uletrec(decls, body) ->
      let decls = List.map (fun (id, u) -> (id, inline env u)) decls in
      let udecls = List.map (fun (id, (ulam, u_approx)) -> (id, ulam)) decls in
      let (ubody, body_approx) = inline env body in
      let ulam = Uletrec (udecls, ubody) in
      (ulam, Approx_unknown)

    (* TODO: we probably don't need to improve anything here. Indeed,
       it cannot fail, and it is mostly used to return a closure, as
       the return value of the function (otherwise, it would be a
       direct call, no ?) *)
    | Uoffset(v, ofs) ->
      let (uv, vapprox) = inline env v in
      let ulam = Uoffset (uv, ofs) in
      (ulam, Approx_unknown)

    (* TODO *)
    (* TODO *)
    (* TODO *)
    (* TODO *)
    (* TODO *)

    | Uprim(p, args, debug) ->
      let args = List.map (inline env) args in
      inline_primitive p args debug

    | Udirect_apply (clos, args, debug) ->
      let args = List.map (inline env) args in
      begin
	try
	  let clos_app = Hashtbl.find label_approx clos.fun_label in
	  (*	  Format.eprintf "Label %s found\n%!" clos.fun_label; *)
	  decr stats_new_direct_call;
	  direct_apply env clos_app args debug
	with Not_found ->
	  (*	  Format.eprintf "Label %s not found\n%!" clos.fun_label; *)
	  let ulam = Udirect_apply (clos, List.map fst args, debug) in
	  (ulam, Approx_unknown)
      end;

    (* TODO: we must count use sites for functions, so that we can decide
       if we keep a closure or not. Question: should it be combined with the
       current analysis, or done later in a pass of dead code elimination
       (for example in usimplif.ml) *)
    | Ugeneric_apply(funct, args, debug) ->
      let (ufunct, funct_approx) = inline env funct in
      let args = List.map (inline env) args in
      begin try
	      match funct_approx with
		| Approx_closure (pos, clos) -> begin
		  match clos.(pos) with
		      Approx_function clos_app ->
			Format.eprintf "Approx_closure %s (closed %b)@." clos_app.fun_desc.fun_label clos_app.fun_desc.fun_closed;

			let fundesc = clos_app.fun_desc in
			let nargs = List.length args in
			if fundesc.fun_arity <> nargs then raise Not_found;
			if clos_app.fun_desc.fun_closed then
			  let ulam, ulam_approx = direct_apply env clos_app args debug in
			  Usequence(ufunct, ulam), ulam_approx
			else
			  let args = args @ [ ufunct, funct_approx ] in
			  direct_apply env clos_app args debug
		    | _ -> assert false
		end
		| _ -> raise Not_found
	with Not_found ->
	  let uargs = List.map fst args in
	  let ulam = Ugeneric_apply (ufunct, uargs, debug) in
	  ulam, Approx_unknown
      end;

    | Uclosure (defs, fv) ->
      let fv = List.map (inline env) fv in
      let pos = ref (-1) in
      let defs = List.map (fun (clos, body) ->
	let clos_pos = !pos + 1 in
	pos := !pos + 1 + (if clos.fun_arity = 1 then 2 else 3);
	clos, clos_pos, body
      ) defs in
      let fv_pos = !pos in
      let closure = Array.create (!pos + List.length fv) Approx_unknown in
      List.iteri (fun i (fv, fv_approx) ->
	begin
	  match fv with
	      Uvar _
(* a reference to another closure in a set of mutually recursive functions *)
	    | Uoffset (Uvar _, _)
(* Why would a constant appear in a closure, if it is correctly propagated ? *)
	    | Uconst _
(* An element of a closure, saved in another closure. Maybe the closures could be
   shared ? *)
	    | Uprim(Pfield _, [Uvar _], _) -> ()
	    | _ ->
	      Format.fprintf err_formatter "Bad closure environment@.<<<";
	      Printclambda.print_ulambda err_formatter fv;
	      Format.fprintf err_formatter ">>>@.";
	      assert false
	end;
	closure.(fv_pos + i) <- fv_approx) fv;
      let defs = List.map (fun (clos, clos_pos, body) ->
	let clos_app = {
	  fun_result = Approx_unknown;
	  fun_desc = clos;
	  fun_inlined = (match clos.fun_inline with None -> false | _ -> true);
	  fun_body = body;
	} in
	Hashtbl.add label_approx clos.fun_label clos_app;
	closure.(clos_pos) <- Approx_function clos_app;
	(clos, clos_pos, body, clos_app)
      ) defs in
      let defs = List.map (fun (clos, clos_pos, body, clos_app) ->
	let env = { env with env_vars = Tbl.empty } in
	let env = if not clos.fun_closed then
	    let clos_id = List2.last clos.fun_params in
	    (*	    Format.eprintf "In %s:\n%!" clos.fun_label;
		    Format.eprintf "Adding closure approximation for %a\n%!" Ident.print clos_id; *)
	    { env with env_vars = Tbl.add clos_id
		(Approx_closure (clos_pos, closure)) env.env_vars }
	  else env in
	let body, body_approx = inline env body in
	clos_app.fun_result <- body_approx;
	(clos, body)
      ) defs
      in
      let (fv,_) = List.split fv in
      let ulam = Uclosure (defs, fv) in
      (ulam, Approx_closure (0,closure) )

and direct_apply env clos_app args debug =
  incr stats_new_direct_call;
  let fundesc = clos_app.fun_desc in
  let args = List.map fst args in
  match fundesc.fun_inline with
      None ->
	let ulam = Udirect_apply (fundesc, args, debug) in
	(ulam, clos_app.fun_result)
    | Some (_params, body) -> (* we don't need to use params here ? *)
      incr stats_inlined_function;
      Format.eprintf "params: %d args: %d@." (List.length fundesc.fun_params) (List.length args);
      let ulam = Closure.bind_params fundesc.fun_params args body in
      (* beware: fortunately, recursive functions cannot be inlined
	 (fun_inline = None), so, for now, there is no risk of an infinite
	 loop. *)
      inline env ulam

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

    Hashtbl.clear label_approx;
    count_uses ulam;

    let (ulam,_) = inline (empty_env()) ulam in

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

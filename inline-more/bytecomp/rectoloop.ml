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

(* Transformation of recursive functions into loops, at the lambda
   code level.

   Recursive functions are usually transformed into loops later,
   during the code linearization in ocamlopt. Doing it earlier has
   many benefits: loops are inlined, while recursive functions are not
   (yet). Recursive calls make the code generator believes that the
   parameters are escaping the function, causing unnecessary boxing of
   floats.

   Documentation on the transform can be found in French in a
   JFLA'2011 paper.
*)

(* Status:
   DONE:
   * Transform recursive tailcall definitions into loops

   TODO:
   * Don't allow big functions to be duplicated, it would lead to huge
   duplication of code.

   CHECK: Is-it possible that a call that was previously tailcall becomes
   non-tailcall ? We should take care of that !

   CHECK: Understand why simplif_exit does not work on the generated
   code.

   NOTES: * Currently, the transformation does not provide any
   speed-up. It is mostly because interesting optimisations are not
   performed. For example, the closure is still created, so some
   values are seen as escaping into the closure, while, in reality,
   the closure is not useful anymore. For List.iter, the function is
   inlined, but it cannot benefit from inlining as functional
   arguments are not inlined.

   Other possible optimisations:
   - force coerce, to remove use positions for values that are
   actually not exported.

*)

open Asttypes (* for Mutable *)
open Lambda
let ppf = Format.err_formatter

module IntSet = Set.Make(struct type t = int let compare = compare end)

let debug_rec2loop = Clflags.new_flag Clflags.debug_flags "rec2loop" false
  "debug rec2loop transform"

let optim_rec2loop = Clflags.new_flag Clflags.optim_flags "rec2loop" true
  "Transform tail-recursive functions into loops before inlining"

let const_true = Lconst (Const_pointer 1)
let const_false = Lconst (Const_pointer 0)

type arg_invariance =
    ArgInvariant of Ident.t
  | ArgVariant of Ident.t * Ident.t * Ident.t * Ident.t

type fun_def = {
  fun_id : Ident.t;        (* name of the function *)
  fun_args : Ident.t list; (* names of arguments *)
  mutable fun_approx_args : Ident.t option list array; (* approximation of arguments at call sites *)
  fun_nargs : int;         (* number of arguments *)
  mutable fun_self_rec : bool;  (* is the function self non-tail recursive  (called from itself) *)
  mutable fun_mut_rec : bool;   (* is the function mutually non-tail recursive (called from other functions *)
  mutable fun_self : bool;      (* is the function self tail recursive *)
  mutable fun_orig_body : lambda; (* non modified body of the function, after tailcall elimination for inner lets *)
  mutable fun_callers : (Ident.t, fun_def) Tbl.t; (* tailcall callers of the function, except from itself *)
  mutable fun_callees : (Ident.t, fun_def) Tbl.t; (* tailcall calls of the function, except to itself *)
  mutable fun_escapes : bool;  (* does the function closure escape ? *)
  mutable fun_exported : bool; (* is the function used outside of the definition *)
  mutable fun_exttail : (Ident.t * int, unit) Tbl.t; (* tailcalls to other named functions, with arity *)

  mutable fun_final_args : Ident.t list; (* final names of the arguments *)
  mutable fun_final_body : lambda; (* modified body of the function, after tailcall elimination of the definition *)
}

type env = {
  env_bv : (Ident.t, fun_def) Tbl.t;
  env_defs : (Ident.t, fun_def) Tbl.t;
  env_fun : fun_def;
}

type graph_node = {
  g_id : Ident.t;
  g_fun : fun_def;
  g_args : arg_invariance list;

  mutable g_callers : (Ident.t, graph_node) Tbl.t;
  mutable g_callees : (Ident.t, graph_node) Tbl.t;
  mutable g_body : node_body;
  mutable g_principal : bool;
}

and node_body =
    BODY of fun_def
  | CATCH_WITH of node_body * graph_node


type trs = {
  trs_return : int;
  mutable trs_calls : (Ident.t * int, int * bool list * bool ref) Tbl.t;
  mutable trs_extcalls : (Ident.t, IntSet.t ref) Tbl.t;
}

let const_unit = Lconst (Const_pointer 0)
let const_true = Lconst (Const_pointer 1)

let remove_bv id trs =
  try
    let set = Tbl.find id trs.trs_extcalls in
    IntSet.iter (fun nargs ->
      trs.trs_calls <- Tbl.remove (id, nargs) trs.trs_calls
    ) !set
  with Not_found -> ()

(* Replace tailcalls by static raises *)
let rec substitute_tailcall trs lam =
  match lam with
    | Lvar id -> lam
    | Lconst cst -> lam
    | Lfunction (kind, params, body) -> lam
    | Lprim (prim, args) -> lam
    | Lstaticraise (i, args) -> lam
    | Lwhile (cond, body) -> lam
    | Lfor (id, lo, hi, dir, body) -> lam
    | Lifused (id, lam) -> lam
    | Lassign (id, lam) -> lam
    | Lapply (Lvar fun_id, args, loc) ->
      begin try
	  if !debug_rec2loop then begin
	    Format.fprintf ppf "Tailcall %s(%d)@." (Ident.unique_name fun_id) (List.length args);
	  end;
	  let nargs = List.length args in
	  let (call_f, bitmap_args, used) = Tbl.find (fun_id, nargs) trs.trs_calls in
	  used := true;
	  if bitmap_args = [] then
	    Lstaticraise (call_f, args)
	  else
	    Lstaticraise (call_f, List.fold_left2 (fun args arg is_present ->
	      if is_present then arg :: args else args) [] args bitmap_args)
	with Not_found ->
	  if !debug_rec2loop then begin
	    Format.fprintf ppf "%s not found@." (Ident.unique_name fun_id);
	    Tbl.iter (fun (id, nargs) _ ->
	      Format.fprintf ppf "\t%s(%d)@." (Ident.unique_name id) nargs
	    ) trs.trs_calls;
	  end;
	  lam
      end

    | Lapply (funct, args, loc) -> lam
    | Lsend (kind, met, obj, args) -> lam
    | Llet (str, id, id_lam, body) ->
      let trs = { trs with trs_calls = trs.trs_calls } in
      remove_bv id trs;
      Llet (str, id, id_lam, substitute_tailcall trs body)
    | Lletrec (defs, body) ->
      let trs = { trs with trs_calls = trs.trs_calls } in
      List.iter (fun (id, _) ->
	remove_bv id trs
      ) defs;
      Lletrec(defs, substitute_tailcall trs body)
    | Lswitch(arg, sw) ->
      Lswitch (arg,
	       { sw with
		 sw_failaction = (match sw.sw_failaction with
		     None -> None
		   | Some lam -> Some (substitute_tailcall trs lam));
		 sw_consts = substitute_tailcall_actions (substitute_tailcall trs) sw.sw_consts;
		 sw_blocks = substitute_tailcall_actions (substitute_tailcall trs) sw.sw_blocks;
	       })
    | Lstaticcatch (body, conf, hdlr) ->
      Lstaticcatch (substitute_tailcall trs body, conf, substitute_tailcall trs hdlr)
    | Ltrywith (body, id, hdlr) ->
      Ltrywith (body, id, substitute_tailcall trs hdlr)
    | Lifthenelse (cond, ifso, ifnot) ->
      Lifthenelse (cond, substitute_tailcall trs ifso, substitute_tailcall trs ifnot)
    | Lsequence (l1, l2) -> Lsequence (l1, substitute_tailcall trs l2)
    | Levent (lam, ev) -> Levent (substitute_tailcall trs lam, ev)

and substitute_tailcall_actions f actions =
  match actions with
      [] -> []
    | (num, lam) :: actions ->
      (num, f lam) :: substitute_tailcall_actions f actions

let bitmap_args g =
  List.map (fun arg ->
    match arg with
	ArgVariant _ -> true
      | ArgInvariant _ -> false) g.g_args

let rec finition trs g =
  let restart_num = next_raise_count () in

  let trs = {
    trs with
      trs_calls = Tbl.add (g.g_id, List.length g.g_args) (restart_num,
							  bitmap_args g
							  , ref false) trs.trs_calls
  } in

  (* By default, tailcalls outside the definition are turned into
     catch-exit, otherwise, they would not be tailcall anymore. However,
     we cannot do that for any value defined in the body of the function,
     including the arguments... *)
  List.iter (fun arg ->
    match arg with
	ArgVariant (call_arg, ref_arg, catch_arg, in_arg) -> remove_bv in_arg trs;
      | ArgInvariant in_arg -> remove_bv in_arg trs;
  ) g.g_args;

  let loop =
    Lwhile(const_true,
	   Lstaticcatch(
	     (let body = with_body trs g.g_body in
	      List.fold_left (fun body arg ->
		match arg with
		    ArgInvariant _ -> body
		  | ArgVariant (call_arg, ref_arg, catch_arg, in_arg) ->
		    Llet(Strict, in_arg, Lprim(Pfield 0, [Lvar ref_arg]), body)
	      (* We cannot use the following because we are before eliminate_ref.
		 Llet(Strict, in_arg, Lvar ref_arg, body) *)
	      )
		body
		g.g_args)
	       ,
	     (restart_num, List.fold_left (fun list arg ->
	       match arg with
		   ArgInvariant _ -> list
		 | ArgVariant (_,_,catch_arg,_) -> catch_arg :: list) [] g.g_args),
	     List.fold_left (fun catch arg ->
	       match arg with
		   ArgInvariant _ -> catch
		 | ArgVariant (call_arg, ref_arg, catch_arg, in_arg) ->
		   Lsequence(
		     Lprim(Psetfield(0, true, false), [Lvar ref_arg; Lvar catch_arg]),
		 (* We cannot use the following because we are before eliminate_ref.
		    Lassign (ref_arg, Lvar catch_arg), *)
		     catch)
	     )
	       const_unit
	       g.g_args
	   )
    ) in
  List.fold_left (fun loop arg ->
    match arg with
	ArgInvariant _ -> loop
      | ArgVariant (call_arg, ref_arg, catch_arg, in_arg) ->
    (* We cannot use the following because we are before eliminate_ref.
       Llet(Variable, ref_arg, Lvar call_arg, loop) *)
    Llet(Strict, ref_arg, Lprim(Pmakeblock(0, Mutable), [Lvar call_arg]), loop)
  ) loop g.g_args

and with_body trs body =
  match body with
      BODY fun_def ->
	Lstaticraise(trs.trs_return, [
	  substitute_tailcall trs fun_def.fun_orig_body
	])
    | CATCH_WITH (body, f) ->
      let call_f = next_raise_count () in
      let trs_body = { trs with
	trs_calls = Tbl.add (f.g_id, List.length f.g_args) (call_f, bitmap_args f, ref false) trs.trs_calls;
      } in
      Lstaticcatch(
	with_body trs_body body,
	(call_f, List.fold_left (fun list arg ->
	  match arg with
	      ArgInvariant _ -> list
	    | ArgVariant (call_arg, _,_,_) -> call_arg :: list) [] f.g_args),
	finition trs f)


let maybe_escapes env id =
  try
    let f = Tbl.find id env.env_bv in
    f.fun_escapes <- true
  with Not_found -> ()

let rec print_body indent body =
  match body with
      BODY f ->
	Format.fprintf ppf "%sBODY(%s)\n" indent (Ident.unique_name f.fun_id)
    | CATCH_WITH (body, catch) ->
      Format.fprintf ppf "%sTRY(%s)\n"  indent (Ident.unique_name catch.g_id);
      print_body (indent ^ "\t") body;
      Format.fprintf ppf "%sCATCH(%s[%d])\n"  indent (Ident.unique_name catch.g_id) (List.length catch.g_args);
      print_body (indent ^ "\t") catch.g_body

let print_graph graph =
  Tbl.iter (fun _ g ->
    Format.fprintf ppf "=================================================\n";
    Format.fprintf ppf "\t%s [%d args]\n" (Ident.unique_name g.g_id) (List.length g.g_args);
    print_body "\t" g.g_body;
    Format.fprintf ppf "\t\tcallers: ";
    Tbl.iter (fun caller_id _ ->
      Format.fprintf ppf "%s " (Ident.unique_name caller_id)
    ) g.g_callers;
    Format.fprintf ppf "\n";
    Format.fprintf ppf "\t\tcallees: ";
    Tbl.iter (fun caller_id _ ->
      Format.fprintf ppf "%s " (Ident.unique_name caller_id)
    ) g.g_callees;
    Format.fprintf ppf "\n";
    Format.fprintf ppf "=================================================\n";
  ) graph



(* call graph transformation *)

let rec2loop env fun_def =
  let fun_id = fun_def.fun_id in
  if !debug_rec2loop then begin
    Format.fprintf ppf "rec2loop %s...\n"  (Ident.unique_name fun_id);
  end;

  let graph = Tbl.map (fun fun_id fun_def ->
  let g_args =
    List.mapi (fun i arg ->
	let arg_name = Ident.name arg in
	if !debug_rec2loop then begin
	  Format.fprintf ppf "Approx for arg %d ( %s ):\n%!" i (Ident.unique_name arg);
	  List.iter (fun approx ->
	    match approx with
		None ->
		  Format.fprintf ppf "\tCan be anything !!!\n%!"
	      | Some id ->
		Format.fprintf ppf "\tCan be %s\n%!" (Ident.unique_name id)
	  ) fun_def.fun_approx_args.(i);
	end;
	match fun_def.fun_approx_args.(i) with
	    (* Note: this can only happen for a mutually tailcall
	       recursive function, as otherwise, other calls would
	       generate other approximations. TODO: extend this for
	       mutually recursive functions. *)
	    [ Some id ] when id = arg -> ArgInvariant arg
	  | _ -> ArgVariant (
	    Ident.create arg_name, (* call_arg *)
	    Ident.create arg_name, (* ref_arg *)
	    Ident.create arg_name, (* catch_arg *)
	    arg
	  )
    ) fun_def.fun_args
  in

    {
      g_id = fun_id;
      g_args = g_args;
      g_fun = fun_def;
      g_body = BODY fun_def;
      g_callers = Tbl.empty;
      g_callees = Tbl.empty;
      g_principal = false;
    }
  ) env.env_defs in
  Tbl.iter (fun fun_id fun_def ->
    let g = Tbl.find fun_id graph in
    g.g_callers <- Tbl.map (fun fun_id _ -> Tbl.find fun_id graph) fun_def.fun_callers;
    g.g_callees <- Tbl.map (fun fun_id _ -> Tbl.find fun_id graph) fun_def.fun_callees;
  ) env.env_defs;
  let g = Tbl.find fun_id graph in
  g.g_principal <- true;

  let graph = ref graph in
  let rec iter () =
    if !debug_rec2loop then begin
      Format.fprintf ppf "iter...\n";
      print_graph !graph;
    end;
    let old_graph = !graph in
    Tbl.iter (fun f_id f ->
      if not f.g_principal && Tbl.is_singleton f.g_callers then
	let (g_id, g) = Tbl.head f.g_callers in
	graph := Tbl.remove f_id !graph;
	g.g_body <- CATCH_WITH (g.g_body, f);
	Tbl.iter (fun h_id h ->
	  h.g_callers <- Tbl.remove f_id h.g_callers;
	  if h != g then begin
	    h.g_callers <- Tbl.add g_id g h.g_callers;
	    g.g_callees <- Tbl.add h_id h g.g_callees;
	  end
	) f.g_callees;
	g.g_callees <- Tbl.remove f_id g.g_callees;
    ) !graph;
    if old_graph != !graph then
      iter ()
    else
      if not (Tbl.is_empty g.g_callees) then begin
	if !debug_rec2loop then begin
	  Format.fprintf ppf "FAILURE for %s\n" (Ident.unique_name fun_id);
	  print_graph !graph;
	end;

	raise Exit
      end
  in
  iter ();

  (* If we are here, it is a success ! *)
  if !debug_rec2loop then begin
    Format.fprintf ppf "SUCCESS for %s\n" (Ident.unique_name fun_id);
    print_body "  " g.g_body;
    print_graph !graph;
  end;

  let return_num = next_raise_count () in
  let result_id = Ident.create "result" in

  let trs = {
    trs_return = return_num;
    trs_calls = Tbl.empty;
    trs_extcalls = Tbl.empty;
  } in
  Tbl.iter (fun _ fun_def ->
    Tbl.iter (fun (fun_id, nargs) _ ->
      try
	let set = Tbl.find fun_id trs.trs_extcalls in
	if not (IntSet.mem nargs !set) then begin
	  set := IntSet.add nargs !set;
	  trs.trs_calls <- Tbl.add (fun_id, nargs) (next_raise_count (), [], ref false) trs.trs_calls
	end
      with Not_found ->
	trs.trs_extcalls <- Tbl.add fun_id (ref (IntSet.add nargs IntSet.empty)) trs.trs_extcalls;
	trs.trs_calls <- Tbl.add (fun_id, nargs) (next_raise_count (), [], ref false) trs.trs_calls
    ) fun_def.fun_exttail
  ) env.env_defs;

  let lam = finition trs g in

  let lam = Tbl.fold (fun (fun_id, nargs) (call_num, extern, used) lam ->
    assert (extern = [] || !used);
    if extern = []  && !used then begin
      if !debug_rec2loop then
	Format.fprintf ppf "Transformed external tailcall to %s\n" (Ident.unique_name fun_id);
      let args = Array.to_list (Array.init nargs (fun i -> Ident.create (Printf.sprintf "arg%d" (i+1)))) in
      Lstaticcatch(lam, (call_num, args),
		   Lapply (Lvar fun_id, List.map (fun arg -> Lvar arg) args, Location.none))

    end else lam
  ) trs.trs_calls lam in

  let lam =
    Lstaticcatch(lam, (return_num, [result_id]), Lvar result_id)
  in

  if !debug_rec2loop then begin
    Format.fprintf ppf "BEFORE rec2loop of %s@." (Ident.unique_name fun_id);
    Printlambda.lambda ppf fun_def.fun_orig_body;
    Format.fprintf ppf "@.";
    Format.fprintf ppf "AFTER rec2loop of %s@." (Ident.unique_name fun_id);
    Printlambda.lambda ppf lam;
    Format.fprintf ppf "@.";
  end;

  fun_def.fun_final_body <- lam;
  fun_def.fun_final_args <- List.map (fun arg ->
    match arg with
	ArgInvariant arg -> arg
      | ArgVariant (call_arg, _,_,_) -> call_arg) g.g_args






(* Substitute bound variables.

   Since we are potentially duplicating code, we need to substitute bound variables
  to avoid having the same ident bound at several locations in the lambda code.
*)

let rec substitute_bv bv lam =
  match lam with
    | Lvar id -> Lvar (substitute_bv_id bv id)
    | Lconst cst -> lam
    | Lprim (prim, args) -> Lprim (prim, List.map (substitute_bv bv) args)
    | Lstaticraise (i, args) -> Lstaticraise (i, List.map (substitute_bv bv) args)
    | Lwhile (cond, body) -> Lwhile (substitute_bv bv cond, substitute_bv bv body)
    | Lifused (id, lam) -> Lifused (substitute_bv_id bv id, substitute_bv bv lam)
    | Lassign (id, lam) -> Lassign (substitute_bv_id bv id, substitute_bv bv lam)
    | Lapply (funct, args, loc) ->
      Lapply (substitute_bv bv funct, List.map (substitute_bv bv) args, loc)
    | Lsend (kind, met, obj, args) ->
      Lsend (kind, substitute_bv bv met, substitute_bv bv obj, List.map (substitute_bv bv) args)
    | Lswitch(arg, sw) ->
      Lswitch (substitute_bv bv arg,
	       { sw with
		 sw_failaction = (match sw.sw_failaction with
		     None -> None
		   | Some lam -> Some (substitute_bv bv lam));
		 sw_consts = substitute_bv_actions (substitute_bv bv) sw.sw_consts;
		 sw_blocks = substitute_bv_actions (substitute_bv bv) sw.sw_blocks;
	       })
    | Lifthenelse (cond, ifso, ifnot) ->
      Lifthenelse (substitute_bv bv cond, substitute_bv bv ifso, substitute_bv bv ifnot)
    | Lsequence (l1, l2) -> Lsequence (substitute_bv bv l1, substitute_bv bv l2)
    | Levent (lam, ev) -> Levent (substitute_bv bv lam, ev)

(* binders *)
    | Llet (str, id, id_lam, body) ->
      let id' = Ident.create (Ident.name id) in
      let bv' = Tbl.add id id' bv in
      Llet (str, id', substitute_bv bv id_lam, substitute_bv bv' body)
    | Lfor (id, lo, hi, dir, body) ->
      let id' = Ident.create (Ident.name id) in
      let bv' = Tbl.add id id' bv in
      Lfor (id', substitute_bv bv lo, substitute_bv bv hi, dir, substitute_bv bv' body)
    | Ltrywith (body, id, hdlr) ->
      let id' = Ident.create (Ident.name id) in
      let bv' = Tbl.add id id' bv in
      Ltrywith (substitute_bv bv body, id', substitute_bv bv' hdlr)

    | Lfunction (kind, params, body) ->
      let params' = List.map (fun v -> Ident.create (Ident.name v)) params in
      let bv' = List.fold_left2 (fun bv v v' ->
	Tbl.add v v' bv
      ) bv params params' in
      Lfunction (kind, params', substitute_bv bv' body)
    | Lstaticcatch (body, (i, params), hdlr) ->
      let params' = List.map (fun v -> Ident.create (Ident.name v)) params in
      let bv' = List.fold_left2 (fun bv v v' ->
	Tbl.add v v' bv
      ) bv params params' in
      Lstaticcatch (substitute_bv bv body,
		    (i, params'), substitute_bv bv' hdlr)

    | Lletrec (defs, body) ->
      let defs' = List.map (fun (id, id_def) ->
	let id' = Ident.create (Ident.name id) in
	(id, id', id_def)) defs in
      let bv' = List.fold_left (fun bv (v, v', _) ->
	Tbl.add v v' bv
      ) bv defs' in
      Lletrec(List.map (fun (id, id', id_def) ->
	(id', substitute_bv bv' id_def)
      ) defs', substitute_bv bv' body)

and substitute_bv_actions f actions =
  match actions with
      [] -> []
    | (num, lam) :: actions ->
      (num, f lam) :: substitute_bv_actions f actions

and substitute_bv_id bv id =
      try
	Tbl.find id bv
      with Not_found -> id



let rec elim_tailcall env lam =
  match lam with
    | Lvar id -> maybe_escapes env id; lam
    | Lconst cst -> lam
    | Lfunction (kind, params, body) -> Lfunction (kind, params, elim_tailcall_none env body)

    (* Fix the problem of non-tailcall of && and || *)
    | Lprim(Psequor, [c1; c2]) ->
      Lifthenelse(elim_tailcall_none env c1, const_true, elim_tailcall env c2)
    | Lprim(Psequand, [c1; c2]) ->
      Lifthenelse(elim_tailcall_none env c1, elim_tailcall env c2, const_false)
    | Lapply (Lvar fun_id, args, loc) ->
      let args = List.map (elim_tailcall_none env) args in
      let caller = env.env_fun in
      begin try
	      let callee = try
			     Tbl.find fun_id env.env_defs
		with Not_found ->
		if !debug_rec2loop then begin
		  Format.fprintf ppf "%s called but not defined\n%!"
		    (Ident.unique_name fun_id);
		end;
		  raise Not_found
	      in
	      if callee.fun_nargs <> List.length args then begin
		if !debug_rec2loop then begin
		  Format.fprintf ppf "%s partially applied recursively\n%!"
		    (Ident.unique_name callee.fun_id);
		end;
		raise Not_found;
	      end;
	      if caller != callee then begin
		caller.fun_callees <- Tbl.add callee.fun_id callee caller.fun_callees;
		callee.fun_callers <- Tbl.add caller.fun_id caller callee.fun_callers;
	      end else
		caller.fun_self <- true;
	      let args_table = Array.of_list args in
	      for i = 0 to callee.fun_nargs - 1 do
		let arg = match args_table.(i) with
		    Lvar id -> Some id
		  | _ -> None in
		let approx = callee.fun_approx_args.(i) in
		match arg, approx with
		    _, [None] -> ()
		  | None, _ -> callee.fun_approx_args.(i) <- [None]
		  | Some i, (Some j) :: _ when i = j -> ()
		  | _ , _ -> callee.fun_approx_args.(i) <- arg :: approx
	      done;
	      Lapply (Lvar fun_id, args, loc)
	with Not_found ->
	  caller.fun_exttail <- Tbl.add (fun_id, List.length args) () caller.fun_exttail;
	  maybe_escapes env fun_id;
	  Lapply (Lvar fun_id, args, loc)
      end

    | Lapply (funct, args, loc) ->
      let funct = elim_tailcall_none env funct in
      let args = List.map (elim_tailcall_none env) args in
      Lapply (funct, args, loc)

    | Lsend (kind, met, obj, args) ->
      Lsend (kind, met, elim_tailcall_none env obj, List.map (elim_tailcall_none env) args)
    | Llet (str, id, lam, body) ->
      Llet (str, id, elim_tailcall_none env lam, elim_tailcall env body)
    | Lletrec (defs, body) ->
      begin
	let module M = struct
	  exception NoRec2Loop    (* exception raised before starting rec2loop *)
	  exception AbortRec2Loop (* exception raised after starting rec2loop *)
	end in
	try
	      if !Clflags.debug then raise M.NoRec2Loop; (* do not optimize when -g is set *)
(*	      match defs with
	      _ :: _ :: _ -> raise M.NoRec2Loop (* TODO: mutually recursive functions *)
		| _ -> *)
	      let (bv_all, bv_def, fun_defs) =
		List.fold_left (fun (bv_all, bv_def, fun_defs) recdef ->
		  match recdef with
		      (fun_id, Lfunction(Curried, fun_args, fun_body)) ->
			let nargs = List.length fun_args in
			let fun_def = {
			  fun_id = fun_id;
			  fun_self = false;
			  fun_args = fun_args;
			  fun_nargs = nargs;
			  fun_approx_args = Array.create nargs [];
			  fun_orig_body = fun_body;
			  fun_final_body = fun_body;
			  fun_escapes = false;
			  fun_callers = Tbl.empty;
			  fun_callees = Tbl.empty;
			  fun_mut_rec = false;
			  fun_self_rec = false;
			  fun_final_args = fun_args;
			  fun_exported = false;
			  fun_exttail = Tbl.empty;
			} in
			let bv_all = Tbl.add fun_id fun_def bv_all in
			let bv_def = Tbl.add fun_id fun_def bv_def in
			(bv_all, bv_def, fun_def :: fun_defs)
		    | _ ->
		    (* If the recursive definition contains something
		       different from a function definition, then we
		       don't know yet how to compile it.
		       TODO: uncurried functions
		    *)
		      raise M.NoRec2Loop
		) (env.env_bv, Tbl.empty, []) defs in

	      (* Check if the functions escape within other functions' bodies inside
		 the same definition. Call elim_tailcall on functions' bodies. *)
	      let def_env = {
		env with
		  env_bv = bv_all;
		  env_defs = bv_def;
	      } in
	      List.iter (fun fun_def ->
		let def_env = { def_env with
		  env_fun = fun_def;
		} in
		let fun_mut_escapes = fun_def.fun_escapes in
		fun_def.fun_escapes <- false;
		fun_def.fun_orig_body <- elim_tailcall def_env fun_def.fun_orig_body;
		if fun_def.fun_escapes then
		  fun_def.fun_self_rec <- fun_def.fun_escapes;
		fun_def.fun_escapes <- fun_mut_escapes
	      ) fun_defs;

	      (* Force escaping functions to have a recursive
		 definition. Note that they won't be inlined
		 (currently), but they might still benefit from loop
		 transformation for other optimizations. *)
	      List.iter (fun fun_def ->
		if fun_def.fun_escapes then begin
		  fun_def.fun_mut_rec <- true;
		  fun_def.fun_escapes <- false
		end;
	      ) fun_defs;

	      let body_env = {
		env with env_bv = bv_all;
	      } in
	      let body' = elim_tailcall body_env body in
	      List.iter (fun fun_def ->
		if fun_def.fun_escapes then
		  fun_def.fun_exported <- true
		else
		  fun_def.fun_escapes <- fun_def.fun_mut_rec || fun_def.fun_self_rec
	      ) fun_defs;

	      if !debug_rec2loop then begin
	      Format.fprintf ppf "Recursive definition:\n";
	      List.iter (fun fun_def ->
		Format.fprintf ppf "\t%s %s%s%s%s%s %d args\n" (Ident.unique_name fun_def.fun_id)
		  (if fun_def.fun_self then "(self-tail)" else "")
		  (if fun_def.fun_callers <> Tbl.empty then "(mut-tail)" else "")
		  (if fun_def.fun_exported then "(exported)" else "")
		  (if fun_def.fun_self_rec then "(self-rec)" else "")
		  (if fun_def.fun_mut_rec then "(mut-rec)" else "")
		  fun_def.fun_nargs
		;
		if fun_def.fun_callers <> Tbl.empty then begin
		  Format.fprintf ppf "\t\tcallers: ";
		  Tbl.iter (fun caller_id _ ->
		    Format.fprintf ppf "%s " (Ident.unique_name caller_id)
		  ) fun_def.fun_callers;
		  Format.fprintf ppf "\n";
		end;
		if fun_def.fun_callees <> Tbl.empty then begin
		  Format.fprintf ppf "\t\tcallees: ";
		  Tbl.iter (fun callee_id _ ->
		    Format.fprintf ppf "%s " (Ident.unique_name callee_id)
		  ) fun_def.fun_callees;
		  Format.fprintf ppf "\n";
		end;
	      ) fun_defs;
	      Format.fprintf ppf "%!";
	      end;

	      try
	      if List.exists (fun fun_def ->
		fun_def.fun_mut_rec || fun_def.fun_self_rec) fun_defs then
		raise M.AbortRec2Loop;


	      let nsuccess = ref 0 in
	      List.iter (fun fun_def ->
		try
		  if fun_def.fun_escapes then begin
		    rec2loop def_env fun_def;
		    incr nsuccess
		  end
		with Exit -> raise M.AbortRec2Loop
	      ) fun_defs;


		  (* In case of success, we just have to output escaping functions *)
		  let body'' =
		    List.fold_left (fun body fun_def ->
		      if fun_def.fun_escapes then
			let lfun =
			  Lfunction(Curried, fun_def.fun_final_args, fun_def.fun_final_body) in

			(* If several escaping functions were
			   transformed in the same definition, we are
			   probably duplicating code. Consequently, we
			   need to substitute bound variables into all
			   but one transformed functions to avoid
			   having non-uniq identifiers. *)
			let lfun = if !nsuccess > 1 then begin
			  decr nsuccess;
			  substitute_bv Tbl.empty lfun
			end else lfun
			in
			Llet(Strict, fun_def.fun_id, lfun, body)
		      else
			body
		    ) body' fun_defs  in

		  (*		  (* If there are recursive functions, then define them within one single
				  recursive let, outside of the body so that they are available from
				  within other function definitions. *)
		  let defs' =
		    List.fold_left (fun defs fun_def ->
		      if fun_def.fun_mut_rec || fun_def.fun_self_rec then
			(fun_def.fun_id,
			 Lfunction(Curried, fun_def.fun_final_args, fun_def.fun_final_body))
			:: defs
		      else
			defs
		     ) [] fun_defs
		  in
		  if defs' = [] then body'' else
		    Lletrec (defs', body'') *)
		  body''
	      with M.AbortRec2Loop ->
		  let defs' = List.map (fun fun_def ->
		    (fun_def.fun_id, Lfunction(Curried, fun_def.fun_args, fun_def.fun_orig_body))
		  ) fun_defs in
		  Lletrec (defs', body')

	with M.NoRec2Loop ->
	  Lletrec (List.map (fun (id, lam) ->
	    (id, elim_tailcall_none env lam)) defs, elim_tailcall env body)
      end
    | Lprim (prim, args) -> Lprim (prim, List.map (elim_tailcall_none env) args)
    | Lswitch(arg, sw) ->
      Lswitch (elim_tailcall_none env arg,
	       { sw with
		 sw_failaction = (match sw.sw_failaction with
		     None -> None
		   | Some lam -> Some (elim_tailcall env lam));
		 sw_consts = elim_tailcall_actions (elim_tailcall env) sw.sw_consts;
		 sw_blocks = elim_tailcall_actions (elim_tailcall env) sw.sw_blocks;
	       })
    | Lstaticraise (i, args) -> Lstaticraise (i, List.map (elim_tailcall_none env) args)
    | Lstaticcatch (body, conf, hdlr) ->
      Lstaticcatch (elim_tailcall env body, conf, elim_tailcall env hdlr)
    | Ltrywith (body, id, hdlr) -> Ltrywith (elim_tailcall_none env body, id, elim_tailcall env hdlr)
    | Lifthenelse (cond, ifso, ifnot) ->
      Lifthenelse (elim_tailcall_none env cond, elim_tailcall env ifso, elim_tailcall env ifnot)
    | Lsequence (l1, l2) -> Lsequence (elim_tailcall_none env l1, elim_tailcall env l2)
    | Lwhile (cond, body) -> Lwhile (elim_tailcall_none env cond, elim_tailcall_none env body)
    | Lfor (id, lo, hi, dir, body) ->
      Lfor (id, elim_tailcall_none env lo, elim_tailcall_none env hi, dir, elim_tailcall_none env body)
    | Lassign (id, lam) -> Lassign (id, elim_tailcall_none env lam)
    | Levent (lam, ev) -> Levent (elim_tailcall env lam, ev)
    | Lifused (id, lam) -> Lifused (id, elim_tailcall_none env lam)

and elim_tailcall_actions f actions =
  match actions with
      [] -> []
    | (num, lam) :: actions ->
      (num, f lam) :: elim_tailcall_actions f actions

and elim_tailcall_none env lam =
  elim_tailcall { env with
    env_defs = Tbl.empty;
  } lam

let simplify lam =
  if !optim_rec2loop then
    let fun_def = {
      fun_id = Ident.create "";
      fun_args = [];
      fun_approx_args = [||];
      fun_nargs = 0;
      fun_orig_body = lam;
      fun_final_body = lam;
      fun_callers = Tbl.empty;
      fun_callees = Tbl.empty;
      fun_escapes = true;
      fun_mut_rec = false;
      fun_self_rec = false;
      fun_self = false;
      fun_final_args = [];
      fun_exported = false;
      fun_exttail = Tbl.empty;
    } in

    if !debug_rec2loop then begin
      Format.fprintf ppf "Before rec2loop\n";
      Printlambda.lambda ppf lam;
    end;

    let lam =
      elim_tailcall_none {
	env_fun = fun_def;
	env_bv = Tbl.empty;
	env_defs = Tbl.empty;
      }
	lam
    in

    if !debug_rec2loop then begin
      Format.fprintf ppf "After rec2loop\n";
      Printlambda.lambda ppf lam;
      Format.fprintf ppf "@.";
    end;

    lam

  else lam

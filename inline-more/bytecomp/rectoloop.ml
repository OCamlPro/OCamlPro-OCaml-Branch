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
   DONE: nothing
   TODO:
   * Detect tailcalls and eliminate them.
   * Remove constant arguments from recursive calls.
*)

open Lambda

let const_true = Lconst (Const_pointer 1)
let const_false = Lconst (Const_pointer 0)


let rec elim_tailcall env lam =
  match lam with
    | Lvar id -> lam
    | Lconst cst -> lam
    | Lfunction (kind, params, body) -> Lfunction (kind, params, elim_tailcall_none body)

(* Fix the problem of non-tailcall of && and || *)
    | Lprim(Psequor, [c1; c2]) ->
      Lifthenelse(elim_tailcall_none c1, const_true, elim_tailcall env c2)
    | Lprim(Psequand, [c1; c2]) ->
      Lifthenelse(elim_tailcall_none c1, elim_tailcall env c2, const_false)

    | Lapply (funct, args, loc) ->
      let funct = elim_tailcall_none funct in
      let args = List.map elim_tailcall_none args in
	    (* TODO *)
      Lapply (funct, args, loc)

    | Lsend (kind, met, obj, args) ->
      Lsend (kind, met, elim_tailcall_none obj, List.map elim_tailcall_none args)
    | Llet (str, id, lam, body) -> Llet (str, id, elim_tailcall_none lam, elim_tailcall env body)
    | Lletrec (defs, body) ->
	    (* TODO *)
      Lletrec (List.map (fun (id, lam) -> (id, elim_tailcall_none lam)) defs, elim_tailcall env body)
    | Lprim (prim, args) -> Lprim (prim, List.map elim_tailcall_none args)
    | Lswitch(arg, sw) ->
      Lswitch (elim_tailcall_none arg,
	       { sw with
		 sw_failaction = (match sw.sw_failaction with
		     None -> None
		   | Some lam -> Some (elim_tailcall env lam));
		 sw_consts = elim_tailcall_actions (elim_tailcall env) sw.sw_consts;
		 sw_blocks = elim_tailcall_actions (elim_tailcall env) sw.sw_blocks;
	       })
    | Lstaticraise (i, args) -> Lstaticraise (i, List.map elim_tailcall_none args)
    | Lstaticcatch (body, conf, hdlr) ->
      Lstaticcatch (elim_tailcall env body, conf, elim_tailcall env hdlr)
    | Ltrywith (body, id, hdlr) -> Ltrywith (elim_tailcall_none body, id, elim_tailcall env hdlr)
    | Lifthenelse (cond, ifso, ifnot) ->
      Lifthenelse (elim_tailcall_none cond, elim_tailcall env ifso, elim_tailcall env ifnot)
    | Lsequence (l1, l2) -> Lsequence (elim_tailcall_none l1, elim_tailcall env l2)
    | Lwhile (cond, body) -> Lwhile (elim_tailcall_none cond, elim_tailcall_none body)
    | Lfor (id, lo, hi, dir, body) ->
      Lfor (id, elim_tailcall_none lo, elim_tailcall_none hi, dir, elim_tailcall_none body)
    | Lassign (id, lam) -> Lassign (id, elim_tailcall_none lam)
    | Levent (lam, ev) -> Levent (elim_tailcall env lam, ev)
    | Lifused (id, lam) -> Lifused (id, elim_tailcall_none lam)

and elim_tailcall_actions f actions =
  match actions with
      [] -> []
    | (num, lam) :: actions ->
      (num, f lam) :: elim_tailcall_actions f actions

and elim_tailcall_none lam = elim_tailcall None lam

let elim_tailcall lam =
  elim_tailcall_none lam


let simplify lam = elim_tailcall_none lam

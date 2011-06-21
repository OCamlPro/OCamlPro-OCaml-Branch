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

open Asttypes
open Lambda
open Clambda

(* Note that closures must be modified in place. *)
let clambda_map f ulam =
  match ulam with

    | Uvar _ -> ulam
    | Uconst _ -> ulam
    | Ugeneric_apply(funct, args, debug) ->
      Ugeneric_apply (f funct, List.map f args, debug)
    | Uoffset(u, ofs) -> Uoffset (f u, ofs)
    | Ulet(str, id, def, approx, body) -> Ulet (str, id, f def, approx, f body)
    | Uletrec(decls, body) -> Uletrec (List.map (fun (id, u) ->
      (id, f u)) decls, f body)
    | Uprim(p, args, debug) -> Uprim (p, List.map f args, debug)
    | Uswitch(arg, s) ->
      Uswitch (f arg,
               { s with
		 us_actions_consts = Array.map f s.us_actions_consts;
		 us_actions_blocks = Array.map f s.us_actions_blocks; })
    | Ustaticfail (num, args) -> Ustaticfail (num, List.map f args)
    | Ucatch(num, ids, body, hdlr) -> Ucatch (num, ids, f body, f hdlr)
    | Utrywith(body, exn, hdlr) -> Utrywith (f body, exn, f hdlr)
    | Uifthenelse(cond, ifso, ifnot) ->
      Uifthenelse (f cond, f ifso, f ifnot)
    | Usequence(u1, u2) -> Usequence (f u1, f u2)
    | Uwhile(cond, body) -> Uwhile (f cond, f body)
    | Ufor(id, lo, hi, dir, body) -> Ufor(id, f lo, f hi, dir, f body)
    | Uassign(id, u) -> Uassign  (id, f u)
    | Usend(k, met, obj, args, debug) -> Usend (k, f met, f obj, List.map f args, debug)

    | Udirect_apply (label, args, debug) ->
      Udirect_apply (label, List.map f args, debug)
    | Uclosure (defs, env) ->
      Uclosure (List.map (fun (clos, ubody) ->
        (clos, f ubody)) defs, List.map f env)

let clambda_iter f ulam =
  match ulam with
    | Uvar _ -> ()
    | Uconst _ -> ()
    | Ugeneric_apply(funct, args, debug) -> f funct; List.iter f args
    | Uoffset(u, ofs) -> f u
    | Ulet(str, id, def, approx, body) -> f def; f body
    | Uletrec(decls, body) ->
      List.iter (fun (id, u) -> f u) decls;
      f body
    | Uprim(p, args, debug) -> List.iter f args
    | Uswitch(arg, s) ->
      f arg;
      Array.iter f s.us_actions_consts;
      Array.iter f s.us_actions_blocks;
    | Ustaticfail (num, args) -> List.iter f args
    | Ucatch(num, ids, body, hdlr) -> f body; f hdlr
    | Utrywith(body, exn, hdlr) -> f body; f hdlr
    | Uifthenelse(cond, ifso, ifnot) ->
      f cond; f ifso; f ifnot
    | Usequence(u1, u2) -> f u1; f u2
    | Uwhile(cond, body) -> f cond; f body
    | Ufor(id, lo, hi, dir, body) -> f lo; f hi; f body
    | Uassign(id, u) -> f u
    | Usend(k, met, obj, args, debug) -> f met; f obj; List.iter f args
    | Udirect_apply (label, args, debug) -> List.iter f args
    | Uclosure (defs, env) ->
      List.iter (fun (clos, ubody) -> f ubody) defs; List.iter f env


let debug_elim = Clflags.new_flag Clflags.debug_flags "refelim" false
  "debug reference elimination after closure conversion"
let optim_elim = Clflags.new_flag Clflags.optim_flags "refelim" true
  "transform references into variables when they do not escape"

let eliminate_ref ulam =

      (* first pass: find references and check whether they can escape *)
  let to_elim = ref Tbl.empty in
  let rec find_ref_new_env env ulam =
    let rec find_ref ulam =
      match ulam with
        | Ulet(Strict, v, Uprim(Pmakeblock(0, Mutable), [linit], _), _, lbody) ->
          find_ref linit;
          let escapes = ref false in
          let env = Tbl.add v escapes env in
          find_ref_new_env env lbody;
          if not !escapes then to_elim := Tbl.add v true !to_elim;
        | Uvar id ->
          (try (Tbl.find id env) := true with Not_found -> ())
        | Uprim(Pfield 0, [Uvar _], _) -> ()
        | Uprim(Psetfield(0, _, _), [Uvar _; e] , _) -> find_ref e
        | Uprim(Poffsetref delta, [Uvar _], _ ) -> ()
        | Uclosure (defs,  fv) ->
          List.iter (fun (clos, ubody) ->
            find_ref_new_env Tbl.empty ubody) defs;
          List.iter find_ref fv

        | _ ->
          clambda_iter find_ref ulam
    in
    find_ref ulam
  in
  find_ref_new_env Tbl.empty ulam;

      (* second pass: replace references that cannot escape by variables *)

  if !to_elim <> Tbl.empty then
    let rec elim_ref ulam =
      match ulam with
        | Ulet(Strict, v, Uprim(Pmakeblock(0, Mutable), [linit], _), _, lbody) when
            Tbl.mem v !to_elim ->
(*          stats_eliminated_refs := v :: !stats_eliminated_refs; *)
              Ulet(Variable, v, elim_ref linit, Value_unknown, elim_ref lbody)

        | Uprim(Pfield 0, [Uvar v], _) when  Tbl.mem v !to_elim -> Uvar v
        | Uprim(Psetfield(0, _, _), [Uvar v; e], _) when Tbl.mem v !to_elim ->
          Uassign(v, elim_ref e)
        | Uprim(Poffsetref delta, [Uvar v], dbg) when Tbl.mem v !to_elim ->
          Uassign(v, Uprim(Poffsetint delta, [Uvar v], dbg))
        | _ ->
          clambda_map elim_ref ulam
    in
    elim_ref ulam
  else
    ulam

let optimize ulam =
  if !optim_elim then
    eliminate_ref ulam
  else ulam

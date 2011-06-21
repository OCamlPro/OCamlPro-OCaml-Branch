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

let debug_inline2 = Clflags.new_flag Clflags.debug_flags "inline2" false
  "debug second phase of inlining"
let optim_inline2 = Clflags.new_flag Clflags.optim_flags "inline2" true
  "inlining and constant propagation after closure conversion"

open Asttypes
open Lambda
open Clambda

(* 'approx' is an association between identifiers and approximations *)

let rec inline approx ulam =
  match ulam with
    | Uvar _ -> ulam
    | Uconst _ -> ulam
    | Ugeneric_apply(funct, args, debug) ->
      let funct = inline approx funct in
      let args = List.map (inline approx) args in
      Ugeneric_apply (funct, args, debug)
    | Uoffset(u, ofs) -> Uoffset (inline approx u, ofs)
    | Ulet(str, id, def, old_approx, body) ->
      let def = inline approx def in
      let body = inline approx body in
      Ulet (str, id, def, old_approx, body)
    | Uletrec(decls, body) -> Uletrec (List.map (fun (id, u) ->
      (id, inline approx u)) decls, inline approx body)
    | Uprim(p, args, debug) -> Uprim (p, List.map (inline approx) args, debug)
    | Uswitch(arg, s) ->
      Uswitch (inline approx arg,
               { s with
		 us_actions_consts = Array.map (inline approx) s.us_actions_consts;
		 us_actions_blocks = Array.map (inline approx) s.us_actions_blocks; })
    | Ustaticfail (num, args) -> Ustaticfail (num, List.map (inline approx) args)
    | Ucatch(num, ids, body, hdlr) -> Ucatch (num, ids, inline approx body, inline approx hdlr)
    | Utrywith(body, exn, hdlr) -> Utrywith (inline approx body, exn, inline approx hdlr)
    | Uifthenelse(cond, ifso, ifnot) ->
      Uifthenelse (inline approx cond, inline approx ifso, inline approx ifnot)
    | Usequence(u1, u2) -> Usequence (inline approx u1, inline approx u2)
    | Uwhile(cond, body) -> Uwhile (inline approx cond, inline approx body)
    | Ufor(id, lo, hi, dir, body) -> Ufor(id, inline approx lo, inline approx hi, dir, inline approx body)
    | Uassign(id, u) -> Uassign  (id, inline approx u)
    | Usend(k, met, obj, args, debug) -> Usend (k, inline approx met, inline approx obj, List.map (inline approx) args, debug)

    | Udirect_apply (label, args, debug) ->
      Udirect_apply (label, List.map (inline approx) args, debug)
    | Uclosure (defs, env) ->
      Uclosure (List.map (fun (clos, ubody) ->
        (clos, inline approx ubody)) defs, List.map (inline approx) env)


let optimize ulam =
  if !optim_inline2 then inline Tbl.empty ulam else ulam

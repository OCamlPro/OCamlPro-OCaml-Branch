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

(* $Id: clambda.ml 7812 2007-01-29 12:11:18Z xleroy $ *)

open Asttypes
open Lambda
open Clambda
open Format
open Printlambda

let rec approx ppf v =
  match v with
    | Value_tuple args ->
      let nargs = Array.length args in
      assert (nargs > 0);
      fprintf ppf "@[<2>(%a" approx args.(0);
      for i = 1 to nargs-1 do
	fprintf ppf ", %a" approx args.(i)
      done;
      fprintf ppf ")@]"
    | Value_unknown -> fprintf ppf "?"
    | Value_integer n -> fprintf ppf "@[<2>int %d@]" n
    | Value_constptr n -> fprintf ppf "@[<2>cstptr %d@]" n
    | Value_closure (f,res) ->
      fprintf ppf "fun %s {%d}%s%s -> %a" f.fun_label f.fun_arity
	(if f.fun_closed then " closed" else "")
	(match f.fun_inline with None -> "" | _ -> " inline")
	approx res

let array_iter2 f a b =
  let len_a = Array.length a in
(*  let len_b = Array.length b in
    if len_a <> len_b then begin
      eprintf "len_a (%d) differs from len_b (%d)\n%!" len_a len_b;
      assert false
    end; *)
    for i = 0 to len_a-1 do f i b.(a.(i)) done

let rec lam ppf l =
  match l with
(* exactly the same ones as in printlambda.ml *)
    | Uvar x -> fprintf ppf "%a" Ident.print x
    | Uconst (cst,_) -> Printlambda.structured_constant ppf cst
    | Usend (k, met, obj, largs, _) ->
      let args ppf largs =
        List.iter (fun l -> fprintf ppf "@ %a" lam l) largs in
      let kind =
        if k = Self then "self" else if k = Cached then "cache" else "" in
      fprintf ppf "@[<2>(send%s@ %a@ %a%a)@]" kind lam obj lam met args largs
    | Uassign(id, expr) ->
	fprintf ppf "@[<2>(assign@ %a@ %a)@]" Ident.print id lam expr
    | Ufor(param, lo, hi, dir, body) ->
      fprintf ppf "@[<2>(for %a@ %a@ %s@ %a@ %a)@]"
       Ident.print param lam lo
       (match dir with Upto -> "to" | Downto -> "downto")
       lam hi lam body
  | Uifthenelse(lcond, lif, lelse) ->
      fprintf ppf "@[<2>(if@ %a@ %a@ %a)@]" lam lcond lam lif lam lelse
  | Usequence(l1, l2) ->
      fprintf ppf "@[<2>(seq@ %a@ %a)@]" lam l1 sequence l2
  | Uwhile(lcond, lbody) ->
      fprintf ppf "@[<2>(while@ %a@ %a)@]" lam lcond lam lbody
  | Uprim(prim, largs, _) ->
      let lams ppf largs =
        List.iter (fun l -> fprintf ppf "@ %a" lam l) largs in
      fprintf ppf "@[<2>(%a%a)@]" Printlambda.primitive prim lams largs
  | Utrywith(lbody, param, lhandler) ->
      fprintf ppf "@[<2>(try@ %a@;<1 -1>with %a@ %a)@]"
        lam lbody Ident.print param lam lhandler
  | Uletrec(id_arg_list, body) ->
      let bindings ppf id_arg_list =
        let spc = ref false in
        List.iter
          (fun (id, l) ->
            if !spc then fprintf ppf "@ " else spc := true;
            fprintf ppf "@[<2>%a@ %a@]" Ident.print id lam l)
          id_arg_list in
      fprintf ppf
        "@[<2>(letrec@ (@[<hv 1>%a@])@ %a)@]" bindings id_arg_list lam body

(* Lstaticraise *)
  | Ustaticfail (i, ls)  ->
      let lams ppf largs =
        List.iter (fun l -> fprintf ppf "@ %a" lam l) largs in
      fprintf ppf "@[<2>(exit@ %d%a)@]" i lams ls

(* Lstaticcatch: Arguments have been reordered *)
  | Ucatch(i, vars, lbody, lhandler) ->
      fprintf ppf "@[<2>(catch@ %a@;<1 -1>with (%d%a)@ %a)@]"
        lam lbody i
        (fun ppf vars -> match vars with
          | [] -> ()
          | _ ->
              List.iter
                (fun x -> fprintf ppf " %a" Ident.print x)
                vars)
        vars
        lam lhandler

  | Ulet(str, id, arg, app, body) ->
      let rec letbody = function
        | Ulet(str, id, arg, app, body) ->
            fprintf ppf "@ @[<2>%a {%a} %s @ %a@]" Ident.print id approx app
	      (string_of_kind str) lam arg;
            letbody body
        | expr -> expr in
      fprintf ppf "@[<2>(let@ @[<hv 1>(@[<2>%a {%a} %s @ %a@]" Ident.print id approx app
	(string_of_kind str) lam arg;
      let expr = letbody body in
      fprintf ppf ")@]@ %a)@]" lam expr

(* failaction has been removed from switch  *)
  | Uswitch(larg, sw) ->
      let switch ppf sw =
        let spc = ref false in
        array_iter2
         (fun n l ->
           if !spc then fprintf ppf "@ " else spc := true;
           fprintf ppf "@[<hv 1>case int %i:@ %a@]" n lam l)
         sw.us_index_consts sw.us_actions_consts;
        array_iter2
          (fun n l ->
            if !spc then fprintf ppf "@ " else spc := true;
            fprintf ppf "@[<hv 1>case tag %i:@ %a@]" n lam l)
          sw.us_index_blocks sw.us_actions_blocks ;
      in

      fprintf ppf
       "@[<1>(%s %a@ @[<v 0>%a@])@]"
       "switch*"
       lam larg switch sw

(* from Lapply *)
  | Udirect_apply (function_label, largs, _) ->
      let lams ppf largs =
        List.iter (fun l -> fprintf ppf "@ %a" lam l) largs in
      fprintf ppf "@[<2>(%s@ %a)@]" function_label lams largs
 | Ugeneric_apply(lfun, largs, _) ->
      let lams ppf largs =
        List.iter (fun l -> fprintf ppf "@ %a" lam l) largs in
      fprintf ppf "@[<2>(apply@ %a%a)@]" lam lfun lams largs

(* New: access to the closure *)
  | Uoffset (l, pos) ->
      fprintf ppf "@[<2>(offset[%d]@ %a)@]" pos lam l

  | Uclosure (defs, fvs) ->
      let pr_params ppf params =
            List.iter (fun param -> fprintf ppf "@ %a" Ident.print param) params
      in
      let closures ppf largs =
        List.iter (fun (clos, body) ->
		     fprintf ppf
		       "@[<2>(%s(%d%s) %a@ @[<v 0>%a@])@]"
		       clos.fun_label clos.fun_arity
		       "" (* (if clos.fun_closed then "" else "+c") *)
		       pr_params clos.fun_params lam body


		  ) largs in
      let lams ppf largs =
        List.iter (fun l -> fprintf ppf "@ %a" lam l) largs in
       fprintf ppf
       "@[<2>(closure @[<v 0>%a@] @[<v 0>{%d} %a@])@]"
       closures defs 0 (* env_pos *) lams fvs


and sequence ppf = function
  | Usequence(l1, l2) ->
      fprintf ppf "%a@ %a" sequence l1 sequence l2
  | l ->
      lam ppf l

let print_ulambda ppf l =
  fprintf ppf "%a@."  lam l

let print_ulambda_if ppf cond msg l =
  if cond then begin
    fprintf ppf "*** %s:@.%a@." msg lam l;
  end



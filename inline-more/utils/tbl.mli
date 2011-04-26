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

(* $Id$ *)

(* Association tables from any ordered type to any type.
   We use the generic ordering to compare keys. *)

type ('a, 'b) t

val empty: ('a, 'b) t
val add: 'a -> 'b -> ('a, 'b) t -> ('a, 'b) t
val find: 'a -> ('a, 'b) t -> 'b
val mem: 'a -> ('a, 'b) t -> bool
val remove: 'a -> ('a,  'b) t -> ('a, 'b) t
val iter: ('a -> 'b -> unit) -> ('a, 'b) t -> unit
val map: ('a -> 'b -> 'c) -> ('a, 'b) t -> ('a, 'c) t
val fold: ('a -> 'b -> 'c -> 'c) -> ('a, 'b) t -> 'c -> 'c

val is_empty : ('a, 'b) t -> bool
val is_singleton : ('a, 'b) t -> bool
val head : ('a,'b) t -> 'a * 'b

open Format

val print: (formatter -> 'a -> unit) -> (formatter -> 'b -> unit) ->
           formatter -> ('a, 'b) t -> unit

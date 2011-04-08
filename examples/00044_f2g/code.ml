(* All these allocations are combined into just one allocation. *)

type t

let rec f x y = (x,y)
let rec g y = f y (y,y)
  
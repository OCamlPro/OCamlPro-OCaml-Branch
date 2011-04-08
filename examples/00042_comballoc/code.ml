(* All these allocations are combined into just one allocation. *)

let f x =
  let a = (1,x) in
  let b = (2,x) in
  let c = (a,b) in
  (a,b,c)
  
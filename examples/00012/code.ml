(* This example shows that switches in pattern-matching are not
optimized aggressively. In particular, when a switch is generated (f3
and f4), the benefits of constant propagation are lost because neither
the 'switch' nor the 'isout' constructs are simplified.
*)

let f1 x =
  match 3 with
    | 3 -> x+3
    | _ -> x

let f2 x =
  match 3 with
    | 2 -> x+2
    | 3 -> x+3
    | _ -> x

let f3 x =
  match 3 with
      1 -> x+1
    | 2 -> x+2
    | 3 -> x+3
    | _ -> x

let f4 x =
  match 4 with
      1 -> x+1
    | 2 -> x+2
    | 3 -> x+3
    | _ -> x

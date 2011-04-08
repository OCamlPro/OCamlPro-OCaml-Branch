(* This example shows that "fst" is not inlined when it should, causing
probably inefficient code when used instead of pattern-matching.

Note however that a3 is not completely optimized, as ocamlopt does not
infer the correct final value, and instead needs two loads.
*)

let a = ( String.make 3 'c', 1)

let a1 =
  let x = snd a in
    x

let a2 =
  let snd (_, b) = b in
  let x = snd a in
    x

let a3 =
   let (_,x) = a in
   x


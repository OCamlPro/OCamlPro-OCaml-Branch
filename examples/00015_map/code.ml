(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.
*)


let rec map f list =
  match list with
      [] -> []
    | x :: tail ->
      let x = f x in
      x :: map f tail



let list =
  map (fun x -> x+1) [1;2;3;4;5]

(*
let map1 =
  let z = List.map (fun x -> x + 1) [1;2;3] in
  let rec map1 f l =
    match l with
	[] -> z
      | a::l ->
	  let x = f a in
	    x :: (map1 f l)
  in
    map1
*)

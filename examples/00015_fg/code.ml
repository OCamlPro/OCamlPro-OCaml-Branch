(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.
*)

let rec fun_a f list =
  match list with
      [] -> 0
    | x :: tail ->
	(f x) + (fun_b f tail)

and fun_b g list =
  match list with
      [] -> 0
    | x :: tail -> fun_a g tail

let _ =
  fun_a (fun x -> x + 1) [1;2;3;4]


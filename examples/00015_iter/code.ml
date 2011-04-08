(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.
*)

let rec iter1 f l =
  match l with
      [] -> ()
    | a::l -> f a; iter1 f l

let computed1 =
  let list1 = ref [] in
  iter1 (fun x -> list1 := x :: !list1) [1; 2; 3; 4; 5];
    !list1

let computed2 =
  let list1 = ref [] in
  iter1 (fun (x,y) -> list1 := x :: !list1) [1,2; 2,3; 3,3; 4,5; 5,6];
    !list1


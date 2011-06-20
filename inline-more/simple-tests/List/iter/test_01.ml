open Externals

let list_ints = [1;2;3;4;5;6;7;8;9;10]
let list_floats = [1.;2.;3.;4.;5.;6.;7.;8.;9.;10.]

let rec iter f = function
    [] -> ()
  | a::l -> f a; iter f l

let sum list =
  let sum = ref 0 in
  iter (fun n -> sum := !sum + n) list;
  !sum

let f x = [x;x]
let s = f "toto"

let _ =
  if sum list_ints = 55 then exit_ok () else exit_bad ()


(*
let rec iteri i f = function
    [] -> ()
  | a::l -> f i a; iteri (i + 1) f l

let iteri f l = iteri 0 f l
*)

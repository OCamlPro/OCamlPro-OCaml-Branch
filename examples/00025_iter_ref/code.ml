

let rec iter f = function
    [] -> ()
  | x :: tail -> f x; iter f tail

let list = [1;2;3;4;5]

let sum list =
  let sum = ref 0. in
  iter (fun x -> sum := !sum +. x) list;
    !sum *. 1.

let _ =
  let array = Array.create 5_000_000 1. in
  let list = Array.to_list array in
  for i = 0 to 500 do
    ignore (sum list)
  done


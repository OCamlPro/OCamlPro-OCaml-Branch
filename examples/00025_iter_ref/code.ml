

let rec iter f = function
    [] -> ()
  | x :: tail -> f x; iter f tail

let list = [1;2;3;4;5]

let sum =
  let sum = ref 0 in
  iter (fun x -> sum := !sum + x) list;
    !sum




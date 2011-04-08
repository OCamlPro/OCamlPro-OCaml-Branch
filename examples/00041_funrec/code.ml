

let sum_i list =
  let n = ref 0 in
  let rec iter l =
    match l with
	[] -> !n
      | x :: tail -> n := !n + x; iter tail
  in
    iter list


let sum_f list =
  let rec iterf sum l =
     match l with
      [] -> sum > 0.
    | x :: tail -> 
        iterf (sum +. x) tail
  in
  iterf 0. list

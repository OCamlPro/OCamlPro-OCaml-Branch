

let sum_i list =
  let n = ref 0 in
  let rec iter l =
    match l with
	[] -> !n
      | x :: tail -> n := !n + x; iter tail
  in
    iter list

let rec iterf sum l =
  match l with
      [] -> sum > 0.
    | x :: tail ->
      iterf (sum +. x) tail

let sum_f list =
q  iterf 0. list

let _ =
  let t = Array.init 10_000_000 (fun i -> float i) in
  let l = Array.to_list t in
  ignore (sum_f l)

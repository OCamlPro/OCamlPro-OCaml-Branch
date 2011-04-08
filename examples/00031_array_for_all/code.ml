let array =  [| -2; -1; 0; 1; 2; 3 |]

let array_for_all f l =
  let rec iter f l i n =
    i = n ||
    (f l.(i) && iter f l (i+1) n)
  in
    iter f l 0 (Array.length l)

let x1 = array_for_all (fun i -> i > 0) array

let array_for_all2 f l =
  let rec iter i n =
    i = n ||
    (f l.(i) && iter (i+1) n)
  in
    iter 0 (Array.length l)

let x1 = array_for_all2 (fun i -> i > 0) array

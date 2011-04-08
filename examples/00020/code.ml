
let rec list_map f list =
  match list with
      [] -> []
    | x :: tail ->
	(f x) :: (list_map f tail)

let rec list_iter f list =
  match list with
      [] -> ()
    | x :: tail ->
	f x;
	list_iter f tail

let list1 = [ (1,2); (3,4); (5,6); (7,8) ]

let list2 = list_map (function (x,y) -> x) list1

let sum =
  let temp = ref 0 in
    list_iter (function y -> temp := !temp + y) list2


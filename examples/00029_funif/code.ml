(*
In [sum0], we always allocate the closure before calling [map]
In [sum1], we check for the length of the list, and if the list is empty,
  we don't allocate the closure as it will not be needed. This check could 
  be automatically infered in [sum0] from the fact that [map] starts by 
  a similar check.
In [sum2], [List.iter] is implemented as a loop, and consequently, does
  not start with a check, the check being performed within the loop. 
  Such a check should be raised to the 
  beginning of the function during the recursive-to-loop transformation.
*)

let list = [1;2;3;4;5;6;7;8;9]

let rec map f l =
  match l with
    [] -> []
  | x :: tail -> 
      let xx = f x in
      xx :: (map f tail)
  
let sum0 = 
  map (fun x ->
      Printf.printf "x = %d\n" x;
      Printf.printf "x = %d\n" x;
      Printf.printf "x = %d\n" x;
      Printf.printf "x = %d\n" x;
      Printf.printf "x = %d\n" x;
      Printf.printf "x = %d\n" x;
      x
  )  list

let sum1 =
  match list with
  | [] -> []
  | _ -> map (fun x ->
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          x
          )  list

let sum2 =
  List.iter (fun x ->
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          )  list


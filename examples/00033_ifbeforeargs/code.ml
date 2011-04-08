

let rec map f l =
  match l with
    [] -> []
  | x :: tail ->
      let xx = f x in
      xx :: (map f tail)

module Make(M : sig val f : int -> int end) = struct
  open M

  let sum0 list =
    map (fun x -> f (x+1)) list

  let sum1 list =
    match list with
      | [] -> []
      | _ -> map (fun x -> f (x+1)) list

  let sum2 list =
    List.iter (fun x -> ignore (f x)) list
end


let f x =
  let (arg, arg_approx) =
    match x with
	[ a,b ] -> (a,b)
      | _ -> assert false
  in
    arg

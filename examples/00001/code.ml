(* Useless variable aliases are removed between rawlambda and lambda
   (simplif.ml) *)

let _ =
  let f x =
    let y = x in
      y
  in
    ()

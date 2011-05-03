
let f_int x =
  let (a,b) =
    if x then
      (1,2)
    else
      (2,3)
  in
  a+b

let f_float x =
  let (a,b) =
    if x then
      (1.,2.)
    else
      (2.,3.)
  in
  a+.b


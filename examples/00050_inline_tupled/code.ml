
let f1 =
  let z = ref 0 in
  function (x,y) ->
    incr z;
    x + y + !z

let a1 = f1(1,2)

let f2 =
  let z = ref 0. in
  function (x,y) ->
    z := !z +. 1.;
    x +. y +. !z

let a2 = f2 (1.,2.)

let g x =
  let f () = 1 in
  f x + f x

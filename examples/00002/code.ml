(*

 First, the value of "x" is not inferred as "1". Why ?

 The first "f" takes a tuple as argument. Since the tuple was built
before, and the compiler recognizes only tuples when built on the call
site, it cannot do a direct call. Moreover, the approximation of the result
 (here 1) is not used.

*)

let _ =
  let f (x,y) = 1 in
  let a = (1,2) in
  let x = fst a in
    (f a) + x

let _ =
  let f (x,y) () = 1 in
  let a = (1,2) in
  let x = fst a in
    (f a ()) + x

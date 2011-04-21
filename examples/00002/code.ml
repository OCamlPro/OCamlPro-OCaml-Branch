(*

 First, the value of "x" is not inferred as "1". Why ?

 The first "f" takes a tuple as argument. Since the tuple was built
before, and the compiler recognizes only tuples when built on the call
site, it cannot do a direct call. Moreover, the approximation of the result
 (here 1) is not used.

*)

let res1 =
  let f (x,y) = 1 in
  let a = (1+1,2+2) in
  let x = fst a in
    (f a) + x

let res2 =
  let f (x,y) () = 1 in
  let a = (1+1,2+2) in
  let x = fst a in
    (f a ()) + x


let res3 =
  let f (x,y) = 1 in
  let a = (2,4) in
  let x = fst a in
    (f a) + x

let res4 =
  let f x y = 1 in
  let t = [| 0 |] in
  f t.(0) t.(1)

let res5 =
  let t = [| 0 |] in
  if (ignore t.(1); true) then 1 else 2

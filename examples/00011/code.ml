(*
This example shows that:
- the constant "2." appears 4 times inside the assembly code
- there is no simplification of computations on floating point numbers
- it also shows that litteral strings are allocated in static memory, while references are
    dynamically allocated, although both data types are mutable.
*)

let f x =
  let x = x +. 2. in
  let x = x +. 2. in
  let x = x *. 2. in
  let x = x /. 2. in
    x

let a = 1L
let b = 1L
let c = 2L

let _ =
  let s = "123" in
    s.[0] <- '0'

let x = ref 2

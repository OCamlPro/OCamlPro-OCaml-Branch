
let f x =
  let module A = Array in
    A.concat [x ; [| 1;2 |]]



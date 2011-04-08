
let fib20 =
  let rec fib x =
    if x < 2 then 1 else
      fib (x - 1) + (fib x - 2)
  in
    fib 20



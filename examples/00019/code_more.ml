
let f a b =
  Printf.fprintf stderr "%d %d\n%!" a b
  
let main1 a b c d =
  f a 2;
  f 1 b;
  f a 2;
  f 2 b
  
let main2 a b c d =
  c+d
  
  
  (*
-drawlambda

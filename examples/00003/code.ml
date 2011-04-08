
let _ =
  let x = 1 in
  let y = x + 1 in
  let z = y + 2 in
    z
(*
-drawlambda:
  (seq (let (x/58 1 y/59 (+ x/58 1) z/60 (+ y/59 2)) z/60) 0a)

-dlambda:
  (seq (let (x/58 1 y/59 (+ x/58 1) z/60 (+ y/59 2)) z/60) 0a)

-dclosure:
(seq 4 0a)

-dcmm:
(data int 0 global "camlCode" "camlCode": skip 0)
(function camlCode__entry () 9 [] 1a)

(data)

*)


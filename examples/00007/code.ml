(*
ocamlopt -dlambda -c code.ml
ocamlopt -dclosure -c code.ml
ocamlopt -dcmm -c code.ml
ocamlopt -S -c code.ml
*)

let f =
  let x = 1 in
  let f y = y + x in
    f

(*
-dlambda:
(seq
  (let (f/58 (let (x/59 1 f/60 (function y/61 (+ y/61 x/59))) f/60))
    (setfield_imm 0 (global Code!) f/58))
  0a)


-dclosure:
(seq
  (let
    (f/58
       (let (f/60 (closure (camlCode__f_60[1]( y/61) (+ y/61 1)) [
                                                                  1])) f/60))
    (setfield_imm 0 (global camlCode!) f/58))

*)

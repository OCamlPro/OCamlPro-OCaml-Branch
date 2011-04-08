(*
Mutable structures are not allocated in the static data, even when they are
known to be of basic types.
*)

let z_int = ref 0

type float_ref = { mutable content : float }
let z_float = { content = 0. }

let _ =
  z_int := 1;
  z_float.content <- 1.

(* 
-drawlambda:

(seq
  (let (z_int/58 (makemutable 0 0)) (setfield_imm 0 (global Code!) z_int/58))
  (let (z_float/62 (makearray  0.))
    (setfield_imm 1 (global Code!) z_float/62))
  (setfield_imm 0 (field 0 (global Code!)) 1)
  (setfloatfield 0 (field 1 (global Code!)) 1.) 0a)

-dlambda:

(seq
  (let (z_int/58 (makemutable 0 0)) (setfield_imm 0 (global Code!) z_int/58))
  (let (z_float/62 (makearray  0.))
    (setfield_imm 1 (global Code!) z_float/62))
  (setfield_imm 0 (field 0 (global Code!)) 1)
  (setfloatfield 0 (field 1 (global Code!)) 1.) 0a)

-dclosure:
(seq
  (let (z_int/58 (makemutable 0 0))
    (setfield_imm 0 (global camlCode!) z_int/58))
  (let (z_float/62 (makearray  0.))
    (setfield_imm 1 (global camlCode!) z_float/62))
  (setfield_imm 0 (field 0 (global camlCode!)) 1)
  (setfloatfield 0 (field 1 (global camlCode!)) 1.)

-dcmm:
(data int 2048 global "camlCode" "camlCode": skip 8)
(function camlCode__entry ()
 (let z_int/58 (alloc 1024 1) (store "camlCode" z_int/58))
 (let z_float/62 (alloc 2302 0.) (store (+a "camlCode" 4) z_float/62))
 (store (load "camlCode") 3) (store float64u (load (+a "camlCode" 4)) 1.) 1a)
(data)

camlCode__entry:
        subl    $8, %esp
.L100:
        movl    $20, %eax
        call    caml_allocN
.L101:
        leal    4(%eax), %eax
        movl    $1024, -4(%eax)
        movl    $1, (%eax)
        movl    %eax, camlCode
        addl    $8, %eax
        movl    $2302, -4(%eax)
        fldz
        fstpl   (%eax)
        movl    %eax, camlCode + 4
        movl    camlCode, %eax
        movl    $3, (%eax)
        movl    camlCode + 4, %eax
        fld1
        fstpl   (%eax)
        movl    $1, %eax
        addl    $8, %esp
        ret



*)

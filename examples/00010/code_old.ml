(* This example shows that useless code can be produced during inlining,
since the check on the arguments does not detect many cases without
side-effects. Here, an access to a field is passed as an unused argument,
but a sequence of code is still produced (see assembly code for g).
*)


(*
ocamlopt -dlambda -c code.ml
ocamlopt -dclosure -c code.ml
ocamlopt -dcmm -c code.ml
ocamlopt -S -c code.ml
*)

let f x y = x+ 1

let g r =
  f r.contents r.contents

(*
-dlambda:
seq
  (let (f/58 (function x/59 y/60 (+ x/59 1)))
    (setfield_imm 0 (global Code!) f/58))
  (let
    (g/61
       (function r/62
         (apply (field 0 (global Code!)) (field 0 r/62) (field 0 r/62))))
    (setfield_imm 1 (global Code!) g/61))
  0a)

-dclosure:
(seq
  (let (f/58 (closure (camlCode__f_58[2]( x/59 y/60) (+ x/59 1)) []))
    (setfield_imm 0 (global camlCode!) f/58))
  (let
    (g/61
       (closure (camlCode__g_61[1]( r/62)
                 (seq (field 0 r/62) (let (x/68 (field 0 r/62)) (+ x/68 1)))) [
        ]))
    (setfield_imm 1 (global camlCode!) g/61))% 

-dcmm:
(data int 2048 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__g_61" int 3)
(data int 3319 "camlCode__2": addr "caml_curry2" int 5 addr "camlCode__f_58")
(function camlCode__f_58 (x/59: addr y/60: addr) (+ x/59 2))

(function camlCode__g_61 (r/62: addr)
 (load r/62) [] (let x/68 (load r/62) (+ x/68 2)))

(function camlCode__entry ()
 (let f/58 "camlCode__2" (store "camlCode" f/58))
 (let g/61 "camlCode__1" (store (+a "camlCode" 4) g/61)) 1a)

(data)

-S:
camlCode__g_61:
.L101:
        movl    (%eax), %ebx
        movl    (%eax), %eax
        addl    $2, %eax
        ret

*)
(*
-drawlambda
(seq
  (let (f/58 (function x/59 y/60 (+ x/59 1)))
    (setfield_imm 0 (global Code!) f/58))
  (let
    (g/61
       (function r/62
         (apply (field 0 (global Code!)) (field 0 r/62) (field 0 r/62))))
    (setfield_imm 1 (global Code!) g/61))
  0a)
-dlambda
(seq
  (let (f/58 (function x/59 y/60 (+ x/59 1)))
    (setfield_imm 0 (global Code!) f/58))
  (let
    (g/61
       (function r/62
         (apply (field 0 (global Code!)) (field 0 r/62) (field 0 r/62))))
    (setfield_imm 1 (global Code!) g/61))
  0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__g_61" int 3)
(data int 3319 "camlCode__2": addr "caml_curry2" int 5 addr "camlCode__f_58")
(function camlCode__f_58 (x/59: addr y/60: addr) (+ x/59 2))

(function camlCode__g_61 (r/62: addr)
 (load r/62) [] (let x/68 (load r/62) (+ x/68 2)))

(function camlCode__entry ()
 (let f/58 "camlCode__2" (store "camlCode" f/58))
 (let g/61 "camlCode__1" (store (+a "camlCode" 4) g/61)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__f_58:
  I/10[%eax] := I/10[%eax] + 2
  return R/0[%eax]
  
*** Linearized code
camlCode__g_61:
  A/9[%ebx] := [r/8[%eax]]
  x/10[%eax] := [r/8[%eax]]
  I/11[%eax] := I/11[%eax] + 2
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  f/8[%eax] := "camlCode__2"
  ["camlCode"] := f/8[%eax]
  g/9[%eax] := "camlCode__1"
  ["camlCode" + 4] := g/9[%eax]
  A/10[%eax] := 1
  return R/0[%eax]
  
-S
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.long	2048
	.globl	camlCode
camlCode:
	.space	8
	.data
	.long	2295
camlCode__1:
	.long	camlCode__g_61
	.long	3
	.data
	.long	3319
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__f_58
	.text
	.align	16
	.globl	camlCode__f_58
camlCode__f_58:
.L100:
	addl	$2, %eax
	ret
	.type	camlCode__f_58,@function
	.size	camlCode__f_58,.-camlCode__f_58
	.text
	.align	16
	.globl	camlCode__g_61
camlCode__g_61:
.L101:
	movl	(%eax), %ebx
	movl	(%eax), %eax
	addl	$2, %eax
	ret
	.type	camlCode__g_61,@function
	.size	camlCode__g_61,.-camlCode__g_61
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L102:
	movl	$camlCode__2, %eax
	movl	%eax, camlCode
	movl	$camlCode__1, %eax
	movl	%eax, camlCode + 4
	movl	$1, %eax
	ret
	.type	camlCode__entry,@function
	.size	camlCode__entry,.-camlCode__entry
	.data
	.text
	.globl	camlCode__code_end
camlCode__code_end:
	.data
	.globl	camlCode__data_end
camlCode__data_end:
	.long	0
	.globl	camlCode__frametable
camlCode__frametable:
	.long	0

	.section .note.GNU-stack,"",%progbits
*)

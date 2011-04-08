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
(*
-drawlambda
(seq
  (let (f/58 (let (x/59 1 f/60 (function y/61 (+ y/61 x/59))) f/60))
    (setfield_imm 0 (global Code!) f/58))
  0a)
-dlambda
(seq
  (let (f/58 (let (x/59 1 f/60 (function y/61 (+ y/61 x/59))) f/60))
    (setfield_imm 0 (global Code!) f/58))
  0a)

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 4)
(function camlCode__f_60 (y/61: addr) (+ y/61 2))

(function camlCode__entry ()
 (let f/58 (let f/60 (alloc 3319 "camlCode__f_60" 3 3) f/60)
   (store "camlCode" f/58))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__f_60:
  I/9[%eax] := I/9[%eax] + 2
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  {}
  f/8[%eax] := alloc 16
  [f/8[%eax] + -4] := 3319
  [f/8[%eax]] := "camlCode__f_60"
  [f/8[%eax] + 4] := 3
  [f/8[%eax] + 8] := 3
  ["camlCode"] := f/9[%eax]
  A/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
-S
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.long	1024
	.globl	camlCode
camlCode:
	.space	4
	.text
	.align	16
	.globl	camlCode__f_60
camlCode__f_60:
.L100:
	addl	$2, %eax
	ret
	.type	camlCode__f_60,@function
	.size	camlCode__f_60,.-camlCode__f_60
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L101:
	call	caml_alloc3
.L102:
	leal	4(%eax), %eax
	movl	$3319, -4(%eax)
	movl	$camlCode__f_60, (%eax)
	movl	$3, 4(%eax)
	movl	$3, 8(%eax)
	movl	%eax, camlCode
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
	.long	1
	.long	.L102
	.word	4
	.word	0
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

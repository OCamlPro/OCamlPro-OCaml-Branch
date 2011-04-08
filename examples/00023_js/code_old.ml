
let f x =
  let module A = Array in
    A.concat [x ; [| 1;2 |]]


(*
-drawlambda
(seq
  (let
    (f/58
       (function x/59
         (let (A/60 (global Array!))
           (apply (field 4 A/60)
             (makeblock 0 x/59 (makeblock 0 (makearray  1 2) 0a))))))
    (setfield_imm 0 (global Code!) f/58))
  0a)
-dlambda
(seq
  (let
    (f/58
       (function x/59
         (let (A/60 (global Array!))
           (apply (field 4 A/60)
             (makeblock 0 x/59 (makeblock 0 (makearray  1 2) 0a))))))
    (setfield_imm 0 (global Code!) f/58))
  0a)

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 4)
(data int 2295 "camlCode__1": addr "camlCode__f_58" int 3)
(function camlCode__f_58 (x/59: addr)
 (let A/60 "camlArray"
   (app "camlArray__concat_103"
     (alloc 2048 x/59 (alloc 2048 (alloc 2048 3 5) 1a)) addr)))

(function camlCode__entry ()
 (let f/58 "camlCode__1" (store "camlCode" f/58)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__f_58:
  x/8[%ecx] := R/0[%eax]
  A/9[%eax] := "camlArray"
  {x/8[%ecx]*}
  A/10[%eax] := alloc 36
  [A/10[%eax] + -4] := 2048
  [A/10[%eax]] := 3
  [A/10[%eax] + 4] := 5
  A/11[%ebx] := A/10[%eax] + 12
  [A/11[%ebx] + -4] := 2048
  [A/11[%ebx]] := A/10[%eax]
  [A/11[%ebx] + 4] := 1
  A/12[%eax] := A/10[%eax] + 24
  [A/12[%eax] + -4] := 2048
  [A/12[%eax]] := x/8[%ecx]
  [A/12[%eax] + 4] := A/11[%ebx]
  tailcall "camlArray__concat_103" R/0[%eax]
  
*** Linearized code
camlCode__entry:
  f/8[%eax] := "camlCode__1"
  ["camlCode"] := f/8[%eax]
  A/9[%eax] := 1
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
	.data
	.long	2295
camlCode__1:
	.long	camlCode__f_58
	.long	3
	.text
	.align	16
	.globl	camlCode__f_58
camlCode__f_58:
.L100:
	movl	%eax, %ecx
	movl	$camlArray, %eax
.L101:	movl	caml_young_ptr, %eax
	subl	$36, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L102
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	$3, (%eax)
	movl	$5, 4(%eax)
	leal	12(%eax), %ebx
	movl	$2048, -4(%ebx)
	movl	%eax, (%ebx)
	movl	$1, 4(%ebx)
	addl	$24, %eax
	movl	$2048, -4(%eax)
	movl	%ecx, (%eax)
	movl	%ebx, 4(%eax)
	jmp	camlArray__concat_103
.L102:	call	caml_call_gc
.L103:	jmp	.L101
	.type	camlCode__f_58,@function
	.size	camlCode__f_58,.-camlCode__f_58
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L104:
	movl	$camlCode__1, %eax
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
	.long	.L103
	.word	4
	.word	1
	.word	5
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

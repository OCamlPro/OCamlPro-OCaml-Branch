
let f x =
  1. +. (x *. 2.) +. ((x -. 2.) *. 3.)
(*
-drawlambda
(seq
  (let
    (f/1030
       (function x/1031 (+. (+. 1. (*. x/1031 2.)) (*. (-. x/1031 2.) 3.))))
    (setfield_imm 0 (global Code!) f/1030))
  0a)
-dlambda
(seq
  (let
    (f/1030
       (function x/1031 (+. (+. 1. (*. x/1031 2.)) (*. (-. x/1031 2.) 3.))))
    (setfield_imm 0 (global Code!) f/1030))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (f/1030
       (function x/1031 (+. (+. 1. (*. x/1031 2.)) (*. (-. x/1031 2.) 3.))))
    (setfield_imm 0 (global Code!) f/1030))
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let
    (f/1030
       (closure (camlCode__f_1030(1)  x/1031
                  (+. (+. 1. (*. x/1031 2.)) (*. (-. x/1031 2.) 3.))) 
         {2} ))
    (setfield_imm 0 (global camlCode!) f/1030))
  0a)
*** After TonClosure.optimize:
(let
  (f/1030
     (closure (camlCode__f_1030(1)  x/1031
                (+. (+. 1. (*. x/1031 2.)) (*. (-. x/1031 2.) 3.))) {2} ))
  (seq (setfield_imm 0 (global camlCode!) f/1030) 0a))

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 4)
(data int 2295 "camlCode__1": addr "camlCode__f_1030" int 3)
(function camlCode__f_1030 (x/1031: addr)
 (alloc 2301
   (+f (+f 1. (*f (load float64u x/1031) 2.))
     (*f (-f (load float64u x/1031) 2.) 3.))))

(function camlCode__entry ()
 (let f/1030 "camlCode__1" (store "camlCode" f/1030) 1a))

(data)
-dlinear
Before simplify
camlCode__f_1030:
                  x/8[%ebx] := R/0[%eax]
                  {x/8[%ebx]*}
                  A/9[%eax] := alloc 12
                  [A/9[%eax] + -4] := 2301
                  R/7[%tos] := 2.
                  R/7[%tos] := R/7[%tos] -f(rev) float64[x/8[%ebx]]
                  R/7[%tos] := 3.
                  R/7[%tos] := R/7[%tos] *f R/7[%tos]
                  R/7[%tos] := 2.
                  R/7[%tos] := R/7[%tos] *f float64[x/8[%ebx]]
                  R/7[%tos] := 1.
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  float64u[A/9[%eax]] := R/7[%tos]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f_1030:
  x/8[%ebx] := R/0[%eax]
  {x/8[%ebx]*}
  A/9[%eax] := alloc 12
  [A/9[%eax] + -4] := 2301
  R/7[%tos] := 2.
  R/7[%tos] := R/7[%tos] -f(rev) float64[x/8[%ebx]]
  R/7[%tos] := 3.
  R/7[%tos] := R/7[%tos] *f R/7[%tos]
  R/7[%tos] := 2.
  R/7[%tos] := R/7[%tos] *f float64[x/8[%ebx]]
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  float64u[A/9[%eax]] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  f/8[%eax] := "camlCode__1"
                  ["camlCode"] := f/8[%eax]
                  A/9[%eax] := 1
                  return R/0[%eax]
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
	.long	camlCode__f_1030
	.long	3
	.text
	.align	16
	.globl	camlCode__f_1030
camlCode__f_1030:
	subl	$8, %esp
.L100:
	movl	%eax, %ebx
.L101:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L102
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	.L104
	fsubrl	(%ebx)
	fldl	.L105
	fmulp	%st, %st(1)
	fldl	.L106
	fmull	(%ebx)
	fld1
	faddp	%st, %st(1)
	faddp	%st, %st(1)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L102:	call	caml_call_gc
.L103:	jmp	.L101
	.data
.L106:	.long	0x0, 0x40000000
	.data
.L105:	.long	0x0, 0x40080000
	.data
.L104:	.long	0x0, 0x40000000
	.type	camlCode__f_1030,@function
	.size	camlCode__f_1030,.-camlCode__f_1030
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L107:
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
	.word	12
	.word	1
	.word	3
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

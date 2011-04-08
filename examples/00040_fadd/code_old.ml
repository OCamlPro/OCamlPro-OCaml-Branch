let fadd x y = x +. y
let fincr x = x +. 1.
  
  (*
-drawlambda
(seq
  (let (fadd/1030 (function x/1031 y/1032 (+. x/1031 y/1032)))
    (setfield_imm 0 (global Code!) fadd/1030))
  (let (fincr/1033 (function x/1034 (+. x/1034 1.)))
    (setfield_imm 1 (global Code!) fincr/1033))
  0a)
-dlambda
(seq
  (let (fadd/1030 (function x/1031 y/1032 (+. x/1031 y/1032)))
    (setfield_imm 0 (global Code!) fadd/1030))
  (let (fincr/1033 (function x/1034 (+. x/1034 1.)))
    (setfield_imm 1 (global Code!) fincr/1033))
  0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__fincr_1033" int 3)
(data
 int 3319
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__fadd_1030")
(function camlCode__fadd_1030 (x/1031: addr y/1032: addr)
 (alloc 2301 (+f (load float64u x/1031) (load float64u y/1032))))

(function camlCode__fincr_1033 (x/1034: addr)
 (alloc 2301 (+f (load float64u x/1034) 1.)))

(function camlCode__entry ()
 (let fadd/1030 "camlCode__2" (store "camlCode" fadd/1030))
 (let fincr/1033 "camlCode__1" (store (+a "camlCode" 4) fincr/1033)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__fadd_1030:
  x/8[%ecx] := R/0[%eax]
  {x/8[%ecx]* y/9[%ebx]*}
  A/10[%eax] := alloc 12
  [A/10[%eax] + -4] := 2301
  R/7[%tos] := float64u[x/8[%ecx]]
  R/7[%tos] := R/7[%tos] +f float64[y/9[%ebx]]
  float64u[A/10[%eax]] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__fincr_1033:
  x/8[%ebx] := R/0[%eax]
  {x/8[%ebx]*}
  A/9[%eax] := alloc 12
  [A/9[%eax] + -4] := 2301
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] +f float64[x/8[%ebx]]
  float64u[A/9[%eax]] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  fadd/8[%eax] := "camlCode__2"
  ["camlCode"] := fadd/8[%eax]
  fincr/9[%eax] := "camlCode__1"
  ["camlCode" + 4] := fincr/9[%eax]
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
	.long	camlCode__fincr_1033
	.long	3
	.data
	.long	3319
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__fadd_1030
	.text
	.align	16
	.globl	camlCode__fadd_1030
camlCode__fadd_1030:
	subl	$8, %esp
.L100:
	movl	%eax, %ecx
.L101:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L102
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	(%ecx)
	faddl	(%ebx)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L102:	call	caml_call_gc
.L103:	jmp	.L101
	.type	camlCode__fadd_1030,@function
	.size	camlCode__fadd_1030,.-camlCode__fadd_1030
	.text
	.align	16
	.globl	camlCode__fincr_1033
camlCode__fincr_1033:
	subl	$8, %esp
.L104:
	movl	%eax, %ebx
.L105:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L106
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fld1
	faddl	(%ebx)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L106:	call	caml_call_gc
.L107:	jmp	.L105
	.type	camlCode__fincr_1033,@function
	.size	camlCode__fincr_1033,.-camlCode__fincr_1033
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L108:
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
	.long	2
	.long	.L107
	.word	12
	.word	1
	.word	3
	.align	4
	.long	.L103
	.word	12
	.word	2
	.word	3
	.word	5
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

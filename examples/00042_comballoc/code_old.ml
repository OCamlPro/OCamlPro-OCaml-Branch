
let f x =
  let a = (1,x) in
  let b = (2,x) in
  let c = (a,b) in
  (a,b,c)
  (*
-drawlambda
(seq
  (let
    (f/1030
       (function x/1031
         (let
           (a/1032 (makeblock 0 1 x/1031)
            b/1033 (makeblock 0 2 x/1031)
            c/1034 (makeblock 0 a/1032 b/1033))
           (makeblock 0 a/1032 b/1033 c/1034))))
    (setfield_imm 0 (global Code!) f/1030))
  0a)
-dlambda
(seq
  (let
    (f/1030
       (function x/1031
         (let
           (a/1032 (makeblock 0 1 x/1031)
            b/1033 (makeblock 0 2 x/1031)
            c/1034 (makeblock 0 a/1032 b/1033))
           (makeblock 0 a/1032 b/1033 c/1034))))
    (setfield_imm 0 (global Code!) f/1030))
  0a)

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 4)
(data int 2295 "camlCode__1": addr "camlCode__f_1030" int 3)
(function camlCode__f_1030 (x/1031: addr)
 (let
   (a/1032 (alloc 2048 3 x/1031) b/1033 (alloc 2048 5 x/1031)
    c/1034 (alloc 2048 a/1032 b/1033))
   (alloc 3072 a/1032 b/1033 c/1034)))

(function camlCode__entry ()
 (let f/1030 "camlCode__1" (store "camlCode" f/1030)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__f_1030:
  x/8[%ebx] := R/0[%eax]
  {x/8[%ebx]*}
  a/9[%edx] := alloc 52
  [a/9[%edx] + -4] := 2048
  [a/9[%edx]] := 3
  [a/9[%edx] + 4] := x/8[%ebx]
  b/10[%ecx] := a/9[%edx] + 12
  [b/10[%ecx] + -4] := 2048
  [b/10[%ecx]] := 5
  [b/10[%ecx] + 4] := x/8[%ebx]
  c/11[%ebx] := a/9[%edx] + 24
  [c/11[%ebx] + -4] := 2048
  [c/11[%ebx]] := a/9[%edx]
  [c/11[%ebx] + 4] := b/10[%ecx]
  A/12[%eax] := a/9[%edx] + 36
  [A/12[%eax] + -4] := 3072
  [A/12[%eax]] := a/9[%edx]
  [A/12[%eax] + 4] := b/10[%ecx]
  [A/12[%eax] + 8] := c/11[%ebx]
  reload retaddr
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
.L100:
	movl	%eax, %ebx
.L101:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L102
	leal	4(%eax), %edx
	movl	$2048, -4(%edx)
	movl	$3, (%edx)
	movl	%ebx, 4(%edx)
	leal	12(%edx), %ecx
	movl	$2048, -4(%ecx)
	movl	$5, (%ecx)
	movl	%ebx, 4(%ecx)
	leal	24(%edx), %ebx
	movl	$2048, -4(%ebx)
	movl	%edx, (%ebx)
	movl	%ecx, 4(%ebx)
	leal	36(%edx), %eax
	movl	$3072, -4(%eax)
	movl	%edx, (%eax)
	movl	%ecx, 4(%eax)
	movl	%ebx, 8(%eax)
	ret
.L102:	call	caml_call_gc
.L103:	jmp	.L101
	.type	camlCode__f_1030,@function
	.size	camlCode__f_1030,.-camlCode__f_1030
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
	.word	3
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

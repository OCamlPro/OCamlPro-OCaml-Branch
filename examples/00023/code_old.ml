(* The 3 functions here all take only one argument, a pair. But the
closures are compiled differently: in the first case, it is
untuplified to a function with arity 2 (-2 in the closure text), while
in the other cases, the functions keep an arity of 1.

Note that this means that "fst" and "snd" will often not be inlined
when they should have been for efficiency.
*)

let f1 (a,b) = a+b
let f2 ((a,b) as c) = (a,b,c)
let f3 c =
  let (a,b) = c in
    (a,b,c)
(*
-drawlambda
(seq
  (let
    (f1/58
       (function (param/72, param/73)
         (let (b/60 param/73 a/59 param/72) (+ a/59 b/60))))
    (setfield_imm 0 (global Code!) f1/58))
  (let
    (f2/61
       (function c/64
         (let (b/63 (field 1 c/64) a/62 (field 0 c/64))
           (makeblock 0 a/62 b/63 c/64))))
    (setfield_imm 1 (global Code!) f2/61))
  (let
    (f3/65
       (function c/66
         (let (b/68 (field 1 c/66) a/67 (field 0 c/66))
           (makeblock 0 a/67 b/68 c/66))))
    (setfield_imm 2 (global Code!) f3/65))
  0a)
-dlambda
(seq
  (let (f1/58 (function (param/72, param/73) (+ param/72 param/73)))
    (setfield_imm 0 (global Code!) f1/58))
  (let
    (f2/61 (function c/64 (makeblock 0 (field 0 c/64) (field 1 c/64) c/64)))
    (setfield_imm 1 (global Code!) f2/61))
  (let
    (f3/65 (function c/66 (makeblock 0 (field 0 c/66) (field 1 c/66) c/66)))
    (setfield_imm 2 (global Code!) f3/65))
  0a)

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 12)
(data int 2295 "camlCode__1": addr "camlCode__f3_65" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f2_61" int 3)
(data
 int 3319
 "camlCode__3":
 addr "caml_tuplify2"
 int -3
 addr "camlCode__f1_58")
(function camlCode__f1_58 (param/72: addr param/73: addr)
 (+ (+ param/72 param/73) -1))

(function camlCode__f2_61 (c/64: addr)
 (alloc 3072 (load c/64) (load (+a c/64 4)) c/64))

(function camlCode__f3_65 (c/66: addr)
 (alloc 3072 (load c/66) (load (+a c/66 4)) c/66))

(function camlCode__entry ()
 (let f1/58 "camlCode__3" (store "camlCode" f1/58))
 (let f2/61 "camlCode__2" (store (+a "camlCode" 4) f2/61))
 (let f3/65 "camlCode__1" (store (+a "camlCode" 8) f3/65)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__f1_58:
  I/10[%eax] := param/8[%eax] + param/9[%ebx] + -1
  return R/0[%eax]
  
*** Linearized code
camlCode__f2_61:
  c/8[%ecx] := R/0[%eax]
  {c/8[%ecx]*}
  A/9[%eax] := alloc 16
  [A/9[%eax] + -4] := 3072
  A/10[%ebx] := [c/8[%ecx]]
  [A/9[%eax]] := A/10[%ebx]
  A/11[%ebx] := [c/8[%ecx] + 4]
  [A/9[%eax] + 4] := A/11[%ebx]
  [A/9[%eax] + 8] := c/8[%ecx]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__f3_65:
  c/8[%ecx] := R/0[%eax]
  {c/8[%ecx]*}
  A/9[%eax] := alloc 16
  [A/9[%eax] + -4] := 3072
  A/10[%ebx] := [c/8[%ecx]]
  [A/9[%eax]] := A/10[%ebx]
  A/11[%ebx] := [c/8[%ecx] + 4]
  [A/9[%eax] + 4] := A/11[%ebx]
  [A/9[%eax] + 8] := c/8[%ecx]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  f1/8[%eax] := "camlCode__3"
  ["camlCode"] := f1/8[%eax]
  f2/9[%eax] := "camlCode__2"
  ["camlCode" + 4] := f2/9[%eax]
  f3/10[%eax] := "camlCode__1"
  ["camlCode" + 8] := f3/10[%eax]
  A/11[%eax] := 1
  return R/0[%eax]
  
-S
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.long	3072
	.globl	camlCode
camlCode:
	.space	12
	.data
	.long	2295
camlCode__1:
	.long	camlCode__f3_65
	.long	3
	.data
	.long	2295
camlCode__2:
	.long	camlCode__f2_61
	.long	3
	.data
	.long	3319
camlCode__3:
	.long	caml_tuplify2
	.long	-3
	.long	camlCode__f1_58
	.text
	.align	16
	.globl	camlCode__f1_58
camlCode__f1_58:
.L100:
	lea	-1(%eax, %ebx), %eax
	ret
	.type	camlCode__f1_58,@function
	.size	camlCode__f1_58,.-camlCode__f1_58
	.text
	.align	16
	.globl	camlCode__f2_61
camlCode__f2_61:
.L101:
	movl	%eax, %ecx
.L102:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L103
	leal	4(%eax), %eax
	movl	$3072, -4(%eax)
	movl	(%ecx), %ebx
	movl	%ebx, (%eax)
	movl	4(%ecx), %ebx
	movl	%ebx, 4(%eax)
	movl	%ecx, 8(%eax)
	ret
.L103:	call	caml_call_gc
.L104:	jmp	.L102
	.type	camlCode__f2_61,@function
	.size	camlCode__f2_61,.-camlCode__f2_61
	.text
	.align	16
	.globl	camlCode__f3_65
camlCode__f3_65:
.L105:
	movl	%eax, %ecx
.L106:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L107
	leal	4(%eax), %eax
	movl	$3072, -4(%eax)
	movl	(%ecx), %ebx
	movl	%ebx, (%eax)
	movl	4(%ecx), %ebx
	movl	%ebx, 4(%eax)
	movl	%ecx, 8(%eax)
	ret
.L107:	call	caml_call_gc
.L108:	jmp	.L106
	.type	camlCode__f3_65,@function
	.size	camlCode__f3_65,.-camlCode__f3_65
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L109:
	movl	$camlCode__3, %eax
	movl	%eax, camlCode
	movl	$camlCode__2, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__1, %eax
	movl	%eax, camlCode + 8
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
	.long	.L108
	.word	4
	.word	1
	.word	5
	.align	4
	.long	.L104
	.word	4
	.word	1
	.word	5
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

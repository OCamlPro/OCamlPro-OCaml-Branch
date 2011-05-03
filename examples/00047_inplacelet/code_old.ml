
let f_int x =
  let (a,b) =
    if x then
      (1,2)
    else
      (2,3)
  in
  a+b

let f_float x =
  let (a,b) =
    if x then
      (1.,2.)
    else
      (2.,3.)
  in
  a+.b

(*
-drawlambda
(seq
  (let
    (f_int/1030
       = (function x/1031
           (let (a/1032 := 0a b/1033 := 0a)
             (seq
               (if x/1031 (seq (assign a/1032 1) (assign b/1033 2))
                 (seq (assign a/1032 2) (assign b/1033 3)))
               (+ a/1032 b/1033)))))
    (setfield_imm 0 (global Code!) f_int/1030))
  (let
    (f_float/1034
       = (function x/1035
           (let (a/1036 := 0a b/1037 := 0a)
             (seq
               (if x/1035 (seq (assign a/1036 1.) (assign b/1037 2.))
                 (seq (assign a/1036 2.) (assign b/1037 3.)))
               (+. a/1036 b/1037)))))
    (setfield_imm 1 (global Code!) f_float/1034))
  0a)
-dlambda
(seq
  (let
    (f_int/1030
       = (function x/1031
           (let (a/1032 := 0a b/1033 := 0a)
             (seq
               (if x/1031 (seq (assign a/1032 1) (assign b/1033 2))
                 (seq (assign a/1032 2) (assign b/1033 3)))
               (+ a/1032 b/1033)))))
    (setfield_imm 0 (global Code!) f_int/1030))
  (let
    (f_float/1034
       = (function x/1035
           (let (a/1036 := 0a b/1037 := 0a)
             (seq
               (if x/1035 (seq (assign a/1036 1.) (assign b/1037 2.))
                 (seq (assign a/1036 2.) (assign b/1037 3.)))
               (+. a/1036 b/1037)))))
    (setfield_imm 1 (global Code!) f_float/1034))
  0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__5": addr "camlCode__f_float_1034" int 3)
(data int 2295 "camlCode__6": addr "camlCode__f_int_1030" int 3)
(data global "camlCode__1" int 1277 "camlCode__1": double 1.)
(data global "camlCode__2" int 1277 "camlCode__2": double 2.)
(data global "camlCode__3" int 1277 "camlCode__3": double 2.)
(data global "camlCode__4" int 1277 "camlCode__4": double 3.)
(function camlCode__f_int_1030 (x/1031: addr)
 (let (a/1032 1a b/1033 1a)
   (if (!= x/1031 1) (seq (assign a/1032 3) (assign b/1033 5))
     (seq (assign a/1032 5) (assign b/1033 7)))
   (+ (+ a/1032 b/1033) -1)))

(function camlCode__f_float_1034 (x/1035: addr)
 (let (a/1036 1a b/1037 1a)
   (if (!= x/1035 1)
     (seq (assign a/1036 "camlCode__1") (assign b/1037 "camlCode__2"))
     (seq (assign a/1036 "camlCode__3") (assign b/1037 "camlCode__4")))
   (alloc 1277 (+f (load float64u a/1036) (load float64u b/1037)))))

(function camlCode__entry ()
 (let f_int/1030 "camlCode__6" (store "camlCode" f_int/1030))
 (let f_float/1034 "camlCode__5" (store (+a "camlCode" 8) f_float/1034)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__f_int_1030:
  x/29[%rdi] := R/0[%rax]
  a/30[%rbx] := 1
  b/31[%rax] := 1
  if x/29[%rdi] ==s 1 goto L101
  I/32[%rbx] := 3
  I/33[%rax] := 5
  goto L100
  L101:
  I/34[%rbx] := 5
  I/35[%rax] := 7
  L100:
  I/36[%rax] := a/30[%rbx] + b/31[%rax] + -1
  return R/0[%rax]
  
*** Linearized code
camlCode__f_float_1034:
  a/30[%rdi] := 1
  b/31[%rbx] := 1
  if x/29[%rax] ==s 1 goto L104
  A/32[%rdi] := "camlCode__1"
  A/33[%rbx] := "camlCode__2"
  goto L103
  L104:
  A/34[%rdi] := "camlCode__3"
  A/35[%rbx] := "camlCode__4"
  L103:
  {a/30[%rdi]* b/31[%rbx]*}
  A/36[%rax] := alloc 16
  [A/36[%rax] + -8] := 1277
  F/37[%xmm0] := float64u[a/30[%rdi]]
  F/38[%xmm0] := F/38[%xmm0] +f float64[b/31[%rbx]]
  float64u[A/36[%rax]] := F/38[%xmm0]
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  f_int/29[%rbx] := "camlCode__6"
  A/30[%rax] := "camlCode"
  [A/30[%rax]] := f_int/29[%rbx]
  f_float/31[%rbx] := "camlCode__5"
  A/32[%rax] := "camlCode"
  [A/32[%rax] + 8] := f_float/31[%rbx]
  A/33[%rax] := 1
  return R/0[%rax]
  
-S
	.section        .rodata.cst8,"a",@progbits
	.align	16
caml_negf_mask:	.quad   0x8000000000000000, 0
	.align	16
caml_absf_mask:	.quad   0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.quad	2048
	.globl	camlCode
camlCode:
	.space	16
	.data
	.quad	2295
camlCode__5:
	.quad	camlCode__f_float_1034
	.quad	3
	.data
	.quad	2295
camlCode__6:
	.quad	camlCode__f_int_1030
	.quad	3
	.data
	.globl	camlCode__1
	.quad	1277
camlCode__1:
	.quad	0x3ff0000000000000
	.data
	.globl	camlCode__2
	.quad	1277
camlCode__2:
	.quad	0x4000000000000000
	.data
	.globl	camlCode__3
	.quad	1277
camlCode__3:
	.quad	0x4000000000000000
	.data
	.globl	camlCode__4
	.quad	1277
camlCode__4:
	.quad	0x4008000000000000
	.text
	.align	16
	.globl	camlCode__f_int_1030
camlCode__f_int_1030:
.L102:
	movq	%rax, %rdi
	movq	$1, %rbx
	movq	$1, %rax
	cmpq	$1, %rdi
	je	.L101
	movq	$3, %rbx
	movq	$5, %rax
	jmp	.L100
	.align	4
.L101:
	movq	$5, %rbx
	movq	$7, %rax
.L100:
	leaq	-1(%rbx, %rax), %rax
	ret
	.type	camlCode__f_int_1030,@function
	.size	camlCode__f_int_1030,.-camlCode__f_int_1030
	.text
	.align	16
	.globl	camlCode__f_float_1034
camlCode__f_float_1034:
	subq	$8, %rsp
.L105:
	movq	$1, %rdi
	movq	$1, %rbx
	cmpq	$1, %rax
	je	.L104
	movq	camlCode__1@GOTPCREL(%rip), %rdi
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	jmp	.L103
	.align	4
.L104:
	movq	camlCode__3@GOTPCREL(%rip), %rdi
	movq	camlCode__4@GOTPCREL(%rip), %rbx
.L103:
.L106:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L107
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	movlpd	(%rdi), %xmm0
	addsd	(%rbx), %xmm0
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L107:	call	caml_call_gc@PLT
.L108:	jmp	.L106
	.type	camlCode__f_float_1034,@function
	.size	camlCode__f_float_1034,.-camlCode__f_float_1034
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L109:
	movq	camlCode__6@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__5@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	$1, %rax
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
	.quad	1
	.quad	.L108
	.word	16
	.word	2
	.word	3
	.word	5
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

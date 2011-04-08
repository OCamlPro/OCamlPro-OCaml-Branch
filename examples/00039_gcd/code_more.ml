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
    (f1/1030
       (function (param/1044, param/1045)
         (let (b/1032 param/1045 a/1031 param/1044) (+ a/1031 b/1032))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1033
       (function c/1036
         (let (b/1035 (field 1 c/1036) a/1034 (field 0 c/1036))
           (makeblock 0 a/1034 b/1035 c/1036))))
    (setfield_imm 1 (global Code!) f2/1033))
  (let
    (f3/1037
       (function c/1038
         (let (b/1040 (field 1 c/1038) a/1039 (field 0 c/1038))
           (makeblock 0 a/1039 b/1040 c/1038))))
    (setfield_imm 2 (global Code!) f3/1037))
  0a)
lambda saved
typedtree saved
-dlambda
(seq
  (let
    (f1/1030 (function (param/1044, param/1045) (+ param/1044 param/1045)))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1033
       (function c/1036
         (makeblock 0 (field 0 c/1036) (field 1 c/1036) c/1036)))
    (setfield_imm 1 (global Code!) f2/1033))
  (let
    (f3/1037
       (function c/1038
         (makeblock 0 (field 0 c/1038) (field 1 c/1038) c/1038)))
    (setfield_imm 2 (global Code!) f3/1037))
  0a)
 After TonLambda.optimize (0 eliminations): 
 (seq
   (let
     (f1/1030 (function (param/1044, param/1045) (+ param/1044 param/1045)))
     (setfield_imm 0 (global Code!) f1/1030))
   (let
     (f2/1033
        (function c/1036
          (makeblock 0 (field 0 c/1036) (field 1 c/1036) c/1036)))
     (setfield_imm 1 (global Code!) f2/1033))
   (let
     (f3/1037
        (function c/1038
          (makeblock 0 (field 0 c/1038) (field 1 c/1038) c/1038)))
     (setfield_imm 2 (global Code!) f3/1037))
   0a)
lambda saved
typedtree saved
-dclosure
(seq
  (let
    (f1/1030
       (closure (camlCode__f1_1030(-2)  param/1044 param/1045
                 (+ param/1044 param/1045)) ))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let
    (f2/1033
       (closure (camlCode__f2_1033(1)  c/1036
                 (makeblock 0 (field 0 c/1036) (field 1 c/1036) c/1036)) 
        ))
    (setfield_imm 1 (global camlCode!) f2/1033))
  (let
    (f3/1037
       (closure (camlCode__f3_1037(1)  c/1038
                 (makeblock 0 (field 0 c/1038) (field 1 c/1038) c/1038)) 
        ))
    (setfield_imm 2 (global camlCode!) f3/1037))
  0a)(seq
       (let
         (f1/1030
            (closure (camlCode__f1_1030(-2)  param/1044 param/1045
                      (+ param/1044 param/1045)) ))
         (setfield_imm 0 (global camlCode!) f1/1030))
       (let
         (f2/1033
            (closure (camlCode__f2_1033(1)  c/1036
                      (makeblock 0 (field 0 c/1036) (field 1 c/1036) c/1036)) 
             ))
         (setfield_imm 1 (global camlCode!) f2/1033))
       (let
         (f3/1037
            (closure (camlCode__f3_1037(1)  c/1038
                      (makeblock 0 (field 0 c/1038) (field 1 c/1038) c/1038)) 
             ))
         (setfield_imm 2 (global camlCode!) f3/1037))lambda saved
typedtree saved

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 24)
(data int 2295 "camlCode__1": addr "camlCode__f3_1037" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f2_1033" int 3)
(data
 int 3319
 "camlCode__3":
 addr "caml_tuplify2"
 int -3
 addr "camlCode__f1_1030")
(function camlCode__f1_1030 (param/1044: addr param/1045: addr)
 (+ (+ param/1044 param/1045) -1))

(function camlCode__f2_1033 (c/1036: addr)
 (alloc 3072 (load c/1036) (load (+a c/1036 8)) c/1036))

(function camlCode__f3_1037 (c/1038: addr)
 (alloc 3072 (load c/1038) (load (+a c/1038 8)) c/1038))

(function camlCode__entry ()
 (let f1/1030 "camlCode__3" (store "camlCode" f1/1030))
 (let f2/1033 "camlCode__2" (store (+a "camlCode" 8) f2/1033))
 (let f3/1037 "camlCode__1" (store (+a "camlCode" 16) f3/1037)) 1a)

(data)
lambda saved
typedtree saved
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
	.quad	3072
	.globl	camlCode
camlCode:
	.space	24
	.data
	.quad	2295
camlCode__1:
	.quad	camlCode__f3_1037
	.quad	3
	.data
	.quad	2295
camlCode__2:
	.quad	camlCode__f2_1033
	.quad	3
	.data
	.quad	3319
camlCode__3:
	.quad	caml_tuplify2
	.quad	-3
	.quad	camlCode__f1_1030
	.text
	.align	16
	.globl	camlCode__f1_1030
camlCode__f1_1030:
.L100:
	leaq	-1(%rax, %rbx), %rax
	ret
	.type	camlCode__f1_1030,@function
	.size	camlCode__f1_1030,.-camlCode__f1_1030
	.text
	.align	16
	.globl	camlCode__f2_1033
camlCode__f2_1033:
	subq	$8, %rsp
.L101:
	movq	%rax, %rdi
.L102:	subq	$32, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L103
	leaq	8(%r15), %rax
	movq	$3072, -8(%rax)
	movq	(%rdi), %rbx
	movq	%rbx, (%rax)
	movq	8(%rdi), %rbx
	movq	%rbx, 8(%rax)
	movq	%rdi, 16(%rax)
	addq	$8, %rsp
	ret
.L103:	call	caml_call_gc@PLT
.L104:	jmp	.L102
	.type	camlCode__f2_1033,@function
	.size	camlCode__f2_1033,.-camlCode__f2_1033
	.text
	.align	16
	.globl	camlCode__f3_1037
camlCode__f3_1037:
	subq	$8, %rsp
.L105:
	movq	%rax, %rdi
.L106:	subq	$32, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L107
	leaq	8(%r15), %rax
	movq	$3072, -8(%rax)
	movq	(%rdi), %rbx
	movq	%rbx, (%rax)
	movq	8(%rdi), %rbx
	movq	%rbx, 8(%rax)
	movq	%rdi, 16(%rax)
	addq	$8, %rsp
	ret
.L107:	call	caml_call_gc@PLT
.L108:	jmp	.L106
	.type	camlCode__f3_1037,@function
	.size	camlCode__f3_1037,.-camlCode__f3_1037
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L109:
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 16(%rax)
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
	.quad	2
	.quad	.L108
	.word	16
	.word	1
	.word	5
	.align	8
	.quad	.L104
	.word	16
	.word	1
	.word	5
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

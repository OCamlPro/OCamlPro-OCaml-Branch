
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
lambda saved
typedtree saved
-dlambda
(seq
  (let
    (f/1030
       (function x/1031 (+. (+. 1. (*. x/1031 2.)) (*. (-. x/1031 2.) 3.))))
    (setfield_imm 0 (global Code!) f/1030))
  0a)
 After TonLambda.optimize (0 eliminations): 
 (seq
   (let
     (f/1030
        (function x/1031 (+. (+. 1. (*. x/1031 2.)) (*. (-. x/1031 2.) 3.))))
     (setfield_imm 0 (global Code!) f/1030))
   0a)
lambda saved
typedtree saved
-dclosure
(seq
  (let
    (f/1030
       (closure (camlCode__f_1030(1)  x/1031
                 (+. (+. 1. (*. x/1031 2.)) (*. (-. x/1031 2.) 3.))) 
        ))
    (setfield_imm 0 (global camlCode!) f/1030))
  0a)(seq
       (let
         (f/1030
            (closure (camlCode__f_1030(1)  x/1031
                      (+. (+. 1. (*. x/1031 2.)) (*. (-. x/1031 2.) 3.))) 
             ))
         (setfield_imm 0 (global camlCode!) f/1030))lambda saved
typedtree saved

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__f_1030" int 3)
(function camlCode__f_1030 (x/1031: addr)
 (alloc 1277
   (+f (+f 1. (*f (load float64u x/1031) 2.))
     (*f (-f (load float64u x/1031) 2.) 3.))))

(function camlCode__entry ()
 (let f/1030 "camlCode__1" (store "camlCode" f/1030)) 1a)

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
	.quad	1024
	.globl	camlCode
camlCode:
	.space	8
	.data
	.quad	2295
camlCode__1:
	.quad	camlCode__f_1030
	.quad	3
	.text
	.align	16
	.globl	camlCode__f_1030
camlCode__f_1030:
	subq	$8, %rsp
.L100:
	movq	%rax, %rbx
.L101:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L102
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	movlpd	.L104(%rip), %xmm1
	movlpd	.L105(%rip), %xmm0
	movlpd	(%rbx), %xmm2
	subsd	%xmm0, %xmm2
	mulsd	%xmm1, %xmm2
	movlpd	.L106(%rip), %xmm1
	mulsd	(%rbx), %xmm1
	movlpd	.L107(%rip), %xmm0
	addsd	%xmm1, %xmm0
	addsd	%xmm2, %xmm0
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L102:	call	caml_call_gc@PLT
.L103:	jmp	.L101
	.section	.rodata.cst8,"a",@progbits
.L107:	.quad	0x3ff0000000000000
.L106:	.quad	0x4000000000000000
.L105:	.quad	0x4000000000000000
.L104:	.quad	0x4008000000000000
	.type	camlCode__f_1030,@function
	.size	camlCode__f_1030,.-camlCode__f_1030
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L108:
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
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
	.quad	.L103
	.word	16
	.word	1
	.word	3
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

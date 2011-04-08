
let f x =
  let module A = Array in
    A.concat [x ; [| 1;2 |]]


(*
-drawlambda
(seq
  (let
    (f/1030
       (function x/1031
         (let (A/1032 (global Array!))
           (apply (field 4 A/1032)
             (makeblock 0 x/1031 (makeblock 0 (makearray  1 2) 0a))))))
    (setfield_imm 0 (global Code!) f/1030))
  0a)
lambda saved
typedtree saved
-dlambda
(seq
  (let
    (f/1030
       (function x/1031
         (let (A/1032 (global Array!))
           (apply (field 4 A/1032)
             (makeblock 0 x/1031 (makeblock 0 (makearray  1 2) 0a))))))
    (setfield_imm 0 (global Code!) f/1030))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (f/1030
       (function x/1031
         (let (A/1032 (global Array!))
           (apply (field 4 A/1032)
             (makeblock 0 x/1031 (makeblock 0 (makearray  1 2) 0a))))))
    (setfield_imm 0 (global Code!) f/1030))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

use_label: camlArray__concat_1075
lambda saved
typedtree saved
-dclosure
*** After Closure.intro:
(seq
  (let
    (f/1030
       (closure (camlCode__f_1030(1)  x/1031
                  (let (A/1032 (global camlArray!))
                    (camlArray__concat_1075 
                      (makeblock 0 x/1031 (makeblock 0 (makearray  1 2) 0a))))) 
         ))
    (setfield_imm 0 (global camlCode!) f/1030))
  0a)
use_label: camlArray__concat_1075
stats_letbody_removed : 1
(A_1032) 
stats_let_removed : 0

stats_variable_removed : 0

stats_closure_removed : 0

*** After TonClosure.optimize:
(seq
  (let
    (f/1030
       (closure (camlCode__f_1030(1)  x/1031
                  (camlArray__concat_1075 
                    (makeblock 0 x/1031 (makeblock 0 (makearray  1 2) 0a)))) 
         ))
    (setfield_imm 0 (global camlCode!) f/1030))
  0a)
lambda saved
typedtree saved

-dcmm
use_label: camlArray__concat_1075
(data
                                   int 1024
                                   global "camlCode"
                                   "camlCode":
                                   skip 8)
(data int 2295 "camlCode__1": addr "camlCode__f_1030" int 3)
(function camlCode__f_1030 (x/1031: addr)
 (app "camlArray__concat_1075"
   (alloc 2048 x/1031 (alloc 2048 (alloc 2048 3 5) 1a)) addr))

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
	movq	%rax, %rdi
.L101:	subq	$72, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L102
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	$3, (%rax)
	movq	$5, 8(%rax)
	leaq	24(%rax), %rbx
	movq	$2048, -8(%rbx)
	movq	%rax, (%rbx)
	movq	$1, 8(%rbx)
	addq	$48, %rax
	movq	$2048, -8(%rax)
	movq	%rdi, (%rax)
	movq	%rbx, 8(%rax)
	addq	$8, %rsp
	jmp	camlArray__concat_1075@PLT
.L102:	call	caml_call_gc@PLT
.L103:	jmp	.L101
	.type	camlCode__f_1030,@function
	.size	camlCode__f_1030,.-camlCode__f_1030
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L104:
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
	.word	5
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

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
  (let
    (f/1030
       (let (x/1031 1 f/1032 (function y/1033 (+ y/1033 x/1031))) f/1032))
    (setfield_imm 0 (global Code!) f/1030))
  0a)
lambda saved
typedtree saved
-dlambda
(seq
  (let
    (f/1030
       (let (x/1031 1 f/1032 (function y/1033 (+ y/1033 x/1031))) f/1032))
    (setfield_imm 0 (global Code!) f/1030))
  0a)
 After TonLambda.optimize (0 eliminations): 
 (seq
   (let
     (f/1030
        (let (x/1031 1 f/1032 (function y/1033 (+ y/1033 x/1031))) f/1032))
     (setfield_imm 0 (global Code!) f/1030))
   0a)
lambda saved
typedtree saved
-dclosure
(seq
  (let
    (f/1030
       (let (f/1032 (closure (camlCode__f_1032(1)  y/1033 (+ y/1033 1)) 
                                                                    1))
         f/1032))
    (setfield_imm 0 (global camlCode!) f/1030))
  0a)(seq
       (let
         (f/1030
            (let
              (f/1032 (closure (camlCode__f_1032(1)  y/1033 (+ y/1033 1)) 
                                                                    1))
              f/1032))
         (setfield_imm 0 (global camlCode!) f/1030))lambda saved
typedtree saved

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 8)
(function camlCode__f_1032 (y/1033: addr) (+ y/1033 2))

(function camlCode__entry ()
 (let f/1030 (let f/1032 (alloc 3319 "camlCode__f_1032" 3 3) f/1032)
   (store "camlCode" f/1030))
 1a)

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
	.text
	.align	16
	.globl	camlCode__f_1032
camlCode__f_1032:
.L100:
	addq	$2, %rax
	ret
	.type	camlCode__f_1032,@function
	.size	camlCode__f_1032,.-camlCode__f_1032
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L101:
	call	caml_alloc3@PLT
.L102:
	leaq	8(%r15), %rbx
	movq	$3319, -8(%rbx)
	movq	camlCode__f_1032@GOTPCREL(%rip), %rax
	movq	%rax, (%rbx)
	movq	$3, 8(%rbx)
	movq	$3, 16(%rbx)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	$1, %rax
	addq	$8, %rsp
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
	.quad	.L102
	.word	16
	.word	0
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

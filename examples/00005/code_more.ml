(*
Mutable structures are not allocated in the static data, even when they are
known to be of basic types.
*)

let z_int = ref 0

type float_ref = { mutable content : float }
let z_float = { content = 0. }

let _ =
  z_int := 1;
  z_float.content <- 1.

(* 
-drawlambda:

(seq
  (let (z_int/58 (makemutable 0 0)) (setfield_imm 0 (global Code!) z_int/58))
  (let (z_float/62 (makearray  0.))
    (setfield_imm 1 (global Code!) z_float/62))
  (setfield_imm 0 (field 0 (global Code!)) 1)
  (setfloatfield 0 (field 1 (global Code!)) 1.) 0a)

-dlambda:

(seq
  (let (z_int/58 (makemutable 0 0)) (setfield_imm 0 (global Code!) z_int/58))
  (let (z_float/62 (makearray  0.))
    (setfield_imm 1 (global Code!) z_float/62))
  (setfield_imm 0 (field 0 (global Code!)) 1)
  (setfloatfield 0 (field 1 (global Code!)) 1.) 0a)

-dclosure:
(seq
  (let (z_int/58 (makemutable 0 0))
    (setfield_imm 0 (global camlCode!) z_int/58))
  (let (z_float/62 (makearray  0.))
    (setfield_imm 1 (global camlCode!) z_float/62))
  (setfield_imm 0 (field 0 (global camlCode!)) 1)
  (setfloatfield 0 (field 1 (global camlCode!)) 1.)

-dcmm:
(data int 2048 global "camlCode" "camlCode": skip 8)
(function camlCode__entry ()
 (let z_int/58 (alloc 1024 1) (store "camlCode" z_int/58))
 (let z_float/62 (alloc 2302 0.) (store (+a "camlCode" 4) z_float/62))
 (store (load "camlCode") 3) (store float64u (load (+a "camlCode" 4)) 1.) 1a)
(data)

camlCode__entry:
        subl    $8, %esp
.L100:
        movl    $20, %eax
        call    caml_allocN
.L101:
        leal    4(%eax), %eax
        movl    $1024, -4(%eax)
        movl    $1, (%eax)
        movl    %eax, camlCode
        addl    $8, %eax
        movl    $2302, -4(%eax)
        fldz
        fstpl   (%eax)
        movl    %eax, camlCode + 4
        movl    camlCode, %eax
        movl    $3, (%eax)
        movl    camlCode + 4, %eax
        fld1
        fstpl   (%eax)
        movl    $1, %eax
        addl    $8, %esp
        ret



*)
(*
-drawlambda
(seq
  (let (z_int/1030 (makemutable 0 0))
    (setfield_imm 0 (global Code!) z_int/1030))
  (let (z_float/1034 (makearray  0.))
    (setfield_imm 1 (global Code!) z_float/1034))
  (setfield_imm 0 (field 0 (global Code!)) 1)
  (setfloatfield 0 (field 1 (global Code!)) 1.) 0a)
lambda saved
typedtree saved
-dlambda
(seq
  (let (z_int/1030 (makemutable 0 0))
    (setfield_imm 0 (global Code!) z_int/1030))
  (let (z_float/1034 (makearray  0.))
    (setfield_imm 1 (global Code!) z_float/1034))
  (setfield_imm 0 (field 0 (global Code!)) 1)
  (setfloatfield 0 (field 1 (global Code!)) 1.) 0a)
 After TonLambda.optimize (0 eliminations): 
 (seq
   (let (z_int/1030 (makemutable 0 0))
     (setfield_imm 0 (global Code!) z_int/1030))
   (let (z_float/1034 (makearray  0.))
     (setfield_imm 1 (global Code!) z_float/1034))
   (setfield_imm 0 (field 0 (global Code!)) 1)
   (setfloatfield 0 (field 1 (global Code!)) 1.) 0a)
lambda saved
typedtree saved
-dclosure
(seq
  (let (z_int/1030 (makemutable 0 0))
    (setfield_imm 0 (global camlCode!) z_int/1030))
  (let (z_float/1034 (makearray  0.))
    (setfield_imm 1 (global camlCode!) z_float/1034))
  (setfield_imm 0 (field 0 (global camlCode!)) 1)
  (setfloatfield 0 (field 1 (global camlCode!)) 1.) 0a)(seq
                                                         (let
                                                           (z_int/1030
                                                              (makemutable 0
                                                                0))
                                                           (setfield_imm 0
                                                             (global camlCode!)
                                                             z_int/1030))
                                                         (let
                                                           (z_float/1034
                                                              (makearray  0.))
                                                           (setfield_imm 1
                                                             (global camlCode!)
                                                             z_float/1034))
                                                         (setfield_imm 0
                                                           (field 0
                                                             (global camlCode!))
                                                           1)
                                                         (setfloatfield 0
                                                           (field 1
                                                             (global camlCode!))
                                                           1.)lambda saved
typedtree saved

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 16)
(function camlCode__entry ()
 (let z_int/1030 (alloc 1024 1) (store "camlCode" z_int/1030))
 (let z_float/1034 (alloc 1278 0.) (store (+a "camlCode" 8) z_float/1034))
 (store (load "camlCode") 3) (store float64u (load (+a "camlCode" 8)) 1.) 1a)

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
	.quad	2048
	.globl	camlCode
camlCode:
	.space	16
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L100:
	call	caml_alloc3@PLT
.L101:
	leaq	8(%r15), %rbx
	movq	$1024, -8(%rbx)
	movq	$1, (%rbx)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	addq	$16, %rbx
	movq	$1278, -8(%rbx)
	xorpd	%xmm0, %xmm0
	movlpd	%xmm0, (%rbx)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	$3, (%rax)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	8(%rax), %rax
	movlpd	.L102(%rip), %xmm0
	movlpd	%xmm0, (%rax)
	movq	$1, %rax
	addq	$8, %rsp
	ret
	.section	.rodata.cst8,"a",@progbits
.L102:	.quad	0x3ff0000000000000
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
	.quad	.L101
	.word	16
	.word	0
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

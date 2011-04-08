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
  (let (z_int/58 (makemutable 0 0)) (setfield_imm 0 (global Code!) z_int/58))
  (let (z_float/62 (makearray  0.))
    (setfield_imm 1 (global Code!) z_float/62))
  (setfield_imm 0 (field 0 (global Code!)) 1)
  (setfloatfield 0 (field 1 (global Code!)) 1.) 0a)
-dlambda
(seq
  (let (z_int/58 (makemutable 0 0)) (setfield_imm 0 (global Code!) z_int/58))
  (let (z_float/62 (makearray  0.))
    (setfield_imm 1 (global Code!) z_float/62))
  (setfield_imm 0 (field 0 (global Code!)) 1)
  (setfloatfield 0 (field 1 (global Code!)) 1.) 0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 8)
(function camlCode__entry ()
 (let z_int/58 (alloc 1024 1) (store "camlCode" z_int/58))
 (let z_float/62 (alloc 2302 0.) (store (+a "camlCode" 4) z_float/62))
 (store (load "camlCode") 3) (store float64u (load (+a "camlCode" 4)) 1.) 1a)

(data)
-dlinear
*** Linearized code
camlCode__entry:
  {}
  z_int/8[%eax] := alloc 20
  [z_int/8[%eax] + -4] := 1024
  [z_int/8[%eax]] := 1
  ["camlCode"] := z_int/8[%eax]
  z_float/9[%eax] := z_int/8[%eax] + 8
  [z_float/9[%eax] + -4] := 2302
  R/7[%tos] := 0.
  float64u[z_float/9[%eax]] := R/7[%tos]
  ["camlCode" + 4] := z_float/9[%eax]
  A/11[%eax] := ["camlCode"]
  [A/11[%eax]] := 3
  A/12[%eax] := ["camlCode" + 4]
  R/7[%tos] := 1.
  float64u[A/12[%eax]] := R/7[%tos]
  A/14[%eax] := 1
  reload retaddr
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
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$8, %esp
.L100:
	movl	$20, %eax
	call	caml_allocN
.L101:
	leal	4(%eax), %eax
	movl	$1024, -4(%eax)
	movl	$1, (%eax)
	movl	%eax, camlCode
	addl	$8, %eax
	movl	$2302, -4(%eax)
	fldz
	fstpl	(%eax)
	movl	%eax, camlCode + 4
	movl	camlCode, %eax
	movl	$3, (%eax)
	movl	camlCode + 4, %eax
	fld1
	fstpl	(%eax)
	movl	$1, %eax
	addl	$8, %esp
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
	.long	.L101
	.word	12
	.word	0
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

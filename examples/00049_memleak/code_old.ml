(* It looks like, since the coercion applied to M1 is equivalent to
the string [s] is never disallocated ! *)

module M1 : sig

  val x : unit

end  = struct

  let x = ()
  let s = String.create 1_000_000_000

end

module M2 : sig

  val x : unit

end  = struct

  let s = String.create 1_000_000_000
  let x = ()

end

(*
-drawlambda
(let
  (M1/1033
     = (let (x/1030 = 0a s/1031 = (caml_create_string 1000000000))
         (makeblock 0 x/1030 s/1031)))
  (seq (setfield_imm 0 (global Code!) M1/1033)
    (let
      (M2/1037
         = (let (s/1034 = (caml_create_string 1000000000) x/1035 = 0a)
             (makeblock 0 x/1035)))
      (seq (setfield_imm 1 (global Code!) M2/1037) 0a))))
-dlambda
(let
  (M1/1033
     = (let (x/1030 = 0a s/1031 = (caml_create_string 1000000000))
         (makeblock 0 x/1030 s/1031)))
  (seq (setfield_imm 0 (global Code!) M1/1033)
    (let
      (M2/1037
         = (let (s/1034 = (caml_create_string 1000000000) x/1035 = 0a)
             (makeblock 0 x/1035)))
      (seq (setfield_imm 1 (global Code!) M2/1037) 0a))))

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 16)
(function camlCode__entry ()
 (let
   M1/1033
     (let s/1031 (extcall "caml_create_string" 2000000001 addr)
       (alloc 2048 1a s/1031))
   (store "camlCode" M1/1033)
   (let
     M2/1037
       (let s/1034 (extcall "caml_create_string" 2000000001 addr)
         (alloc 1024 1a))
     (store (+a "camlCode" 8) M2/1037) 1a)))

(data)
-dlinear
*** Linearized code
camlCode__entry:
  I/29[%rdi] := 2000000001
  {}
  R/0[%rax] := extcall "caml_create_string" R/2[%rdi] (noalloc)
  s/30[%rdi] := R/0[%rax]
  {s/30[%rdi]*}
  M1/31[%rbx] := alloc 24
  [M1/31[%rbx] + -8] := 2048
  [M1/31[%rbx]] := 1
  [M1/31[%rbx] + 8] := s/30[%rdi]
  A/32[%rax] := "camlCode"
  [A/32[%rax]] := M1/31[%rbx]
  I/33[%rdi] := 2000000001
  {}
  R/0[%rax] := extcall "caml_create_string" R/2[%rdi] (noalloc)
  {}
  M2/35[%rbx] := alloc 16
  [M2/35[%rbx] + -8] := 1024
  [M2/35[%rbx]] := 1
  A/36[%rax] := "camlCode"
  [A/36[%rax] + 8] := M2/35[%rbx]
  A/37[%rax] := 1
  reload retaddr
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
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L100:
	movq	$2000000001, %rdi
	movq	caml_create_string@GOTPCREL(%rip), %rax
	call	caml_c_call@PLT
.L101:
	movq	%rax, %rdi
	call	caml_alloc2@PLT
.L102:
	leaq	8(%r15), %rbx
	movq	$2048, -8(%rbx)
	movq	$1, (%rbx)
	movq	%rdi, 8(%rbx)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	$2000000001, %rdi
	movq	caml_create_string@GOTPCREL(%rip), %rax
	call	caml_c_call@PLT
.L103:
	call	caml_alloc1@PLT
.L104:
	leaq	8(%r15), %rbx
	movq	$1024, -8(%rbx)
	movq	$1, (%rbx)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
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
	.quad	4
	.quad	.L104
	.word	16
	.word	0
	.align	8
	.quad	.L103
	.word	16
	.word	0
	.align	8
	.quad	.L102
	.word	16
	.word	1
	.word	5
	.align	8
	.quad	.L101
	.word	16
	.word	0
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

(* All these allocations are combined into just one allocation. *)

type t

let rec f x y = (x,y)
let rec g y = f y (y,y)
  (*
-drawlambda
(seq
  (letrec (f/59 (function x/60 y/61 (makeblock 0 x/60 y/61)))
    (setfield_imm 0 (global Code!) f/59))
  (letrec
    (g/62
       (function y/63
         (apply (field 0 (global Code!)) y/63 (makeblock 0 y/63 y/63))))
    (setfield_imm 1 (global Code!) g/62))
  0a)
-dlambda
(seq
  (letrec (f/59 (function x/60 y/61 (makeblock 0 x/60 y/61)))
    (setfield_imm 0 (global Code!) f/59))
  (letrec
    (g/62
       (function y/63
         (apply (field 0 (global Code!)) y/63 (makeblock 0 y/63 y/63))))
    (setfield_imm 1 (global Code!) g/62))
  0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__g_62" int 3)
(data int 3319 "camlCode__2": addr "caml_curry2" int 5 addr "camlCode__f_59")
(function camlCode__f_59 (x/60: addr y/61: addr) (alloc 2048 x/60 y/61))

(function camlCode__g_62 (y/63: addr)
 (app "camlCode__f_59" y/63 (alloc 2048 y/63 y/63) addr))

(function camlCode__entry ()
 (let clos/68 "camlCode__2" (store "camlCode" clos/68))
 (let clos/70 "camlCode__1" (store (+a "camlCode" 4) clos/70)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__f_59:
  x/8[%ecx] := R/0[%eax]
  {x/8[%ecx]* y/9[%ebx]*}
  A/10[%eax] := alloc 12
  [A/10[%eax] + -4] := 2048
  [A/10[%eax]] := x/8[%ecx]
  [A/10[%eax] + 4] := y/9[%ebx]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__g_62:
  y/8[%ecx] := R/0[%eax]
  {y/8[%ecx]*}
  A/9[%ebx] := alloc 12
  [A/9[%ebx] + -4] := 2048
  [A/9[%ebx]] := y/8[%ecx]
  [A/9[%ebx] + 4] := y/8[%ecx]
  R/0[%eax] := y/8[%ecx]
  tailcall "camlCode__f_59" R/0[%eax] R/1[%ebx]
  
*** Linearized code
camlCode__entry:
  clos/8[%eax] := "camlCode__2"
  ["camlCode"] := clos/8[%eax]
  clos/9[%eax] := "camlCode__1"
  ["camlCode" + 4] := clos/9[%eax]
  A/10[%eax] := 1
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
	.data
	.long	2295
camlCode__1:
	.long	camlCode__g_62
	.long	3
	.data
	.long	3319
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__f_59
	.text
	.align	16
	.globl	camlCode__f_59
camlCode__f_59:
.L100:
	movl	%eax, %ecx
.L101:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L102
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	%ecx, (%eax)
	movl	%ebx, 4(%eax)
	ret
.L102:	call	caml_call_gc
.L103:	jmp	.L101
	.type	camlCode__f_59,@function
	.size	camlCode__f_59,.-camlCode__f_59
	.text
	.align	16
	.globl	camlCode__g_62
camlCode__g_62:
.L104:
	movl	%eax, %ecx
.L105:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L106
	leal	4(%eax), %ebx
	movl	$2048, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	%ecx, 4(%ebx)
	movl	%ecx, %eax
	jmp	camlCode__f_59
.L106:	call	caml_call_gc
.L107:	jmp	.L105
	.type	camlCode__g_62,@function
	.size	camlCode__g_62,.-camlCode__g_62
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L108:
	movl	$camlCode__2, %eax
	movl	%eax, camlCode
	movl	$camlCode__1, %eax
	movl	%eax, camlCode + 4
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
	.long	.L107
	.word	4
	.word	1
	.word	5
	.align	4
	.long	.L103
	.word	4
	.word	2
	.word	3
	.word	5
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

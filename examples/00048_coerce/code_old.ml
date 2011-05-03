

let g (x,y) = x+y
let f x = g (x,x)

module M : sig

  val f : int -> int

end  = struct

  let g (x,y) = x+y
  let f x = g (x,x)

end
(*
-drawlambda
(seq
  (let
    (g/1030
       = (function (param/1042, param/1043)
           (let (y/1032 (=) param/1043 x/1031 (=) param/1042)
             (+ x/1031 y/1032))))
    (setfield_imm 2 (global Code!) g/1030))
  (let
    (f/1033
       = (function x/1034
           (apply (field 2 (global Code!)) (makeblock 0 x/1034 x/1034))))
    (setfield_imm 0 (global Code!) f/1033))
  (let
    (M/1041
       = (let
           (g/1035
              = (function (param/1044, param/1045)
                  (let (y/1037 (=) param/1045 x/1036 (=) param/1044)
                    (+ x/1036 y/1037)))
            f/1038
              = (function x/1039 (apply g/1035 (makeblock 0 x/1039 x/1039))))
           (makeblock 0 f/1038)))
    (seq (setfield_imm 1 (global Code!) M/1041) 0a)))
-dlambda
(seq
  (let
    (g/1030 = (function (param/1042, param/1043) (+ param/1042 param/1043)))
    (setfield_imm 2 (global Code!) g/1030))
  (let
    (f/1033
       = (function x/1034
           (apply (field 2 (global Code!)) (makeblock 0 x/1034 x/1034))))
    (setfield_imm 0 (global Code!) f/1033))
  (let
    (M/1041
       = (let
           (f/1038
              = (function x/1039
                  (let
                    (tuple/1047 = (makeblock 0 x/1039 x/1039)
                     param/1045 = (field 1 tuple/1047)
                     param/1044 = (field 0 tuple/1047))
                    (+ param/1044 param/1045))))
           (makeblock 0 f/1038)))
    (seq (setfield_imm 1 (global Code!) M/1041) 0a)))

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 24)
(data int 2295 "camlCode__1": addr "camlCode__f_1038" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f_1033" int 3)
(data
 int 3319
 "camlCode__3":
 addr "caml_tuplify2"
 int -3
 addr "camlCode__g_1030")
(function camlCode__g_1030 (param/1042: addr param/1043: addr)
 (+ (+ param/1042 param/1043) -1))

(function camlCode__f_1033 (x/1034: addr) (+ (+ x/1034 x/1034) -1))

(function camlCode__f_1038 (x/1039: addr)
 (let
   (tuple/1047 (alloc 2048 x/1039 x/1039) param/1045 (load (+a tuple/1047 8))
    param/1044 (load tuple/1047))
   (+ (+ param/1044 param/1045) -1)))

(function camlCode__entry ()
 (let g/1030 "camlCode__3" (store (+a "camlCode" 16) g/1030))
 (let f/1033 "camlCode__2" (store "camlCode" f/1033))
 (let M/1041 (let f/1038 "camlCode__1" (alloc 1024 f/1038))
   (store (+a "camlCode" 8) M/1041) 1a))

(data)
-dlinear
*** Linearized code
camlCode__g_1030:
  I/31[%rax] := param/29[%rax] + param/30[%rbx] + -1
  return R/0[%rax]
  
*** Linearized code
camlCode__f_1033:
  I/30[%rax] := x/29[%rax] + x/29[%rax] + -1
  return R/0[%rax]
  
*** Linearized code
camlCode__f_1038:
  x/29[%rbx] := R/0[%rax]
  {x/29[%rbx]*}
  tuple/30[%rax] := alloc 24
  [tuple/30[%rax] + -8] := 2048
  [tuple/30[%rax]] := x/29[%rbx]
  [tuple/30[%rax] + 8] := x/29[%rbx]
  param/31[%rbx] := [tuple/30[%rax] + 8]
  param/32[%rax] := [tuple/30[%rax]]
  I/33[%rax] := param/32[%rax] + param/31[%rbx] + -1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  g/29[%rbx] := "camlCode__3"
  A/30[%rax] := "camlCode"
  [A/30[%rax] + 16] := g/29[%rbx]
  f/31[%rbx] := "camlCode__2"
  A/32[%rax] := "camlCode"
  [A/32[%rax]] := f/31[%rbx]
  f/33[%rdi] := "camlCode__1"
  {f/33[%rdi]*}
  M/34[%rbx] := alloc 16
  [M/34[%rbx] + -8] := 1024
  [M/34[%rbx]] := f/33[%rdi]
  A/35[%rax] := "camlCode"
  [A/35[%rax] + 8] := M/34[%rbx]
  A/36[%rax] := 1
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
	.quad	3072
	.globl	camlCode
camlCode:
	.space	24
	.data
	.quad	2295
camlCode__1:
	.quad	camlCode__f_1038
	.quad	3
	.data
	.quad	2295
camlCode__2:
	.quad	camlCode__f_1033
	.quad	3
	.data
	.quad	3319
camlCode__3:
	.quad	caml_tuplify2
	.quad	-3
	.quad	camlCode__g_1030
	.text
	.align	16
	.globl	camlCode__g_1030
camlCode__g_1030:
.L100:
	leaq	-1(%rax, %rbx), %rax
	ret
	.type	camlCode__g_1030,@function
	.size	camlCode__g_1030,.-camlCode__g_1030
	.text
	.align	16
	.globl	camlCode__f_1033
camlCode__f_1033:
.L101:
	leaq	-1(%rax, %rax), %rax
	ret
	.type	camlCode__f_1033,@function
	.size	camlCode__f_1033,.-camlCode__f_1033
	.text
	.align	16
	.globl	camlCode__f_1038
camlCode__f_1038:
	subq	$8, %rsp
.L102:
	movq	%rax, %rbx
.L103:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L104
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	%rbx, (%rax)
	movq	%rbx, 8(%rax)
	movq	8(%rax), %rbx
	movq	(%rax), %rax
	leaq	-1(%rax, %rbx), %rax
	addq	$8, %rsp
	ret
.L104:	call	caml_call_gc@PLT
.L105:	jmp	.L103
	.type	camlCode__f_1038,@function
	.size	camlCode__f_1038,.-camlCode__f_1038
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L106:
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 16(%rax)
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rdi
	call	caml_alloc1@PLT
.L107:
	leaq	8(%r15), %rbx
	movq	$1024, -8(%rbx)
	movq	%rdi, (%rbx)
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
	.quad	2
	.quad	.L107
	.word	16
	.word	1
	.word	5
	.align	8
	.quad	.L105
	.word	16
	.word	1
	.word	3
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

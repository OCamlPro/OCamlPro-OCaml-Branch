
let f1 =
  let z = ref 0 in
  function (x,y) ->
    incr z;
    x + y + !z

let a1 = f1(1,2)

let f2 =
  let z = ref 0. in
  function (x,y) ->
    z := !z +. 1.;
    x +. y +. !z

let a2 = f2 (1.,2.)

let g x =
  let f () = 1 in
  f x + f x
(*
-drawlambda
(seq
  (let
    (f1/1030
       (let (z/1031 (makemutable 0 0))
         (function (param/1048, param/1049)
           (let (y/1033 param/1049 x/1032 param/1048)
             (seq (+:=1 z/1031) (+ (+ x/1032 y/1033) (field 0 z/1031)))))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let (a1/1034 (apply (field 0 (global Code!)) [0: 1 2]))
    (setfield_imm 1 (global Code!) a1/1034))
  (let
    (f2/1035
       (let (z/1036 (makemutable 0 0.))
         (function (param/1050, param/1051)
           (let (y/1038 param/1051 x/1037 param/1050)
             (seq (setfield_ptr 0 z/1036 (+. (field 0 z/1036) 1.))
               (+. (+. x/1037 y/1038) (field 0 z/1036)))))))
    (setfield_imm 2 (global Code!) f2/1035))
  (let (a2/1039 (apply (field 2 (global Code!)) [0: 1. 2.]))
    (setfield_imm 3 (global Code!) a2/1039))
  (let
    (g/1040
       (function x/1041
         (let (f/1042 (function param/1052 1))
           (+ (apply f/1042 x/1041) (apply f/1042 x/1041)))))
    (setfield_imm 4 (global Code!) g/1040))
  0a)
-dlambda
(seq
  (let
    (f1/1030
       (let (z/1031 (makemutable 0 0))
         (function (param/1048, param/1049)
           (seq (+:=1 z/1031) (+ (+ param/1048 param/1049) (field 0 z/1031))))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let (a1/1034 (apply (field 0 (global Code!)) [0: 1 2]))
    (setfield_imm 1 (global Code!) a1/1034))
  (let
    (f2/1035
       (let (z/1036 (makemutable 0 0.))
         (function (param/1050, param/1051)
           (seq (setfield_ptr 0 z/1036 (+. (field 0 z/1036) 1.))
             (+. (+. param/1050 param/1051) (field 0 z/1036))))))
    (setfield_imm 2 (global Code!) f2/1035))
  (let (a2/1039 (apply (field 2 (global Code!)) [0: 1. 2.]))
    (setfield_imm 3 (global Code!) a2/1039))
  (let
    (g/1040
       (function x/1041
         (let (f/1042 (function param/1052 1))
           (+ (apply f/1042 x/1041) (apply f/1042 x/1041)))))
    (setfield_imm 4 (global Code!) g/1040))
  0a)

-dcmm
(data int 5120 global "camlCode" "camlCode": skip 40)
(data int 2295 "camlCode__1": addr "camlCode__g_1040" int 3)
(data int 2295 "camlCode__5": addr "camlCode__f_1042" int 3)
(data
 int 2048
 "camlCode__2":
 addr L6
 addr L7
 int 1277
 L7:
 double 2.
 int 1277
 L6:
 double 1.)
(data int 1277 "camlCode__3": double 0.)
(data int 2048 "camlCode__4": int 3 int 5)
(function camlCode__f_1042 (param/1052: addr) 3)

(function camlCode__fun_1053
     (param/1048: addr param/1049: addr env/1055: addr)
 (let ref/1063 (load (+a env/1055 24))
   (store ref/1063 (+ (load ref/1063) 2)))
 (+ (+ (+ param/1048 param/1049) (load (load (+a env/1055 24)))) -2))

(function camlCode__fun_1056
     (param/1050: addr param/1051: addr env/1058: addr)
 (extcall "caml_modify" (load (+a env/1058 24))
   (alloc 1277 (+f (load float64u (load (load (+a env/1058 24)))) 1.)) unit)
 (alloc 1277
   (+f (+f (load float64u param/1050) (load float64u param/1051))
     (load float64u (load (load (+a env/1058 24)))))))

(function camlCode__g_1040 (x/1041: addr) (let f/1042 "camlCode__5" 5))

(function camlCode__entry ()
 (let
   f1/1030
     (let z/1031 (alloc 1024 1)
       (alloc 4343 "caml_tuplify2" -3 "camlCode__fun_1053" z/1031))
   (store "camlCode" f1/1030))
 (let
   a1/1034
     (let fun/1062 (load "camlCode")
       (app (load fun/1062) "camlCode__4" fun/1062 addr))
   (store (+a "camlCode" 8) a1/1034))
 (let
   f2/1035
     (let z/1036 (alloc 1024 "camlCode__3")
       (alloc 4343 "caml_tuplify2" -3 "camlCode__fun_1056" z/1036))
   (store (+a "camlCode" 16) f2/1035))
 (let
   a2/1039
     (let fun/1061 (load (+a "camlCode" 16))
       (app (load fun/1061) "camlCode__2" fun/1061 addr))
   (store (+a "camlCode" 24) a2/1039))
 (let g/1040 "camlCode__1" (store (+a "camlCode" 32) g/1040)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__f_1042:
  I/30[%rax] := 3
  return R/0[%rax]
  
*** Linearized code
camlCode__fun_1053:
  ref/32[%rsi] := [env/31[%rdi] + 24]
  [ref/32[%rsi]] +:= 2
  A/33[%rdi] := [env/31[%rdi] + 24]
  A/34[%rdi] := [A/33[%rdi]]
  I/35[%rax] := I/35[%rax] + param/30[%rbx]
  I/36[%rax] := I/35[%rax] + A/34[%rdi] + -2
  return R/0[%rax]
  
*** Linearized code
camlCode__fun_1056:
  param/29[%r12] := R/0[%rax]
  env/31[%rbp] := R/2[%rdi]
  {param/29[%r12]* param/30[%rbx]* env/31[%rbp]*}
  A/32[%rsi] := alloc 16
  [A/32[%rsi] + -8] := 1277
  A/33[%rax] := [env/31[%rbp] + 24]
  A/34[%rax] := [A/33[%rax]]
  F/35[%xmm0] := 1.
  F/36[%xmm0] := F/36[%xmm0] +f float64[A/34[%rax]]
  float64u[A/32[%rsi]] := F/36[%xmm0]
  A/37[%rdi] := [env/31[%rbp] + 24]
  {param/29[%r12]* param/30[%rbx]* env/31[%rbp]*}
  extcall "caml_modify" R/2[%rdi] R/3[%rsi]
  {param/29[%r12]* param/30[%rbx]* env/31[%rbp]*}
  A/38[%rax] := alloc 16
  [A/38[%rax] + -8] := 1277
  A/39[%rdi] := [env/31[%rbp] + 24]
  A/40[%rdi] := [A/39[%rdi]]
  F/41[%xmm0] := float64u[param/29[%r12]]
  F/42[%xmm0] := F/42[%xmm0] +f float64[param/30[%rbx]]
  F/43[%xmm0] := F/43[%xmm0] +f float64[A/40[%rdi]]
  float64u[A/38[%rax]] := F/43[%xmm0]
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__g_1040:
  f/30[%rax] := "camlCode__5"
  I/31[%rax] := 5
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  {}
  z/29[%rdi] := alloc 56
  [z/29[%rdi] + -8] := 1024
  [z/29[%rdi]] := 1
  f1/30[%rbx] := z/29[%rdi] + 16
  [f1/30[%rbx] + -8] := 4343
  A/31[%rax] := "caml_tuplify2"
  [f1/30[%rbx]] := A/31[%rax]
  [f1/30[%rbx] + 8] := -3
  A/32[%rax] := "camlCode__fun_1053"
  [f1/30[%rbx] + 16] := A/32[%rax]
  [f1/30[%rbx] + 24] := z/29[%rdi]
  A/33[%rax] := "camlCode"
  [A/33[%rax]] := f1/30[%rbx]
  A/34[%rax] := "camlCode"
  fun/35[%rbx] := [A/34[%rax]]
  A/36[%rax] := "camlCode__4"
  A/37[%rdi] := [fun/35[%rbx]]
  {}
  R/0[%rax] := call A/37[%rdi] R/0[%rax] R/1[%rbx]
  A/39[%rbx] := "camlCode"
  [A/39[%rbx] + 8] := a1/38[%rax]
  {}
  z/40[%rdi] := alloc 56
  [z/40[%rdi] + -8] := 1024
  A/41[%rax] := "camlCode__3"
  [z/40[%rdi]] := A/41[%rax]
  f2/42[%rbx] := z/40[%rdi] + 16
  [f2/42[%rbx] + -8] := 4343
  A/43[%rax] := "caml_tuplify2"
  [f2/42[%rbx]] := A/43[%rax]
  [f2/42[%rbx] + 8] := -3
  A/44[%rax] := "camlCode__fun_1056"
  [f2/42[%rbx] + 16] := A/44[%rax]
  [f2/42[%rbx] + 24] := z/40[%rdi]
  A/45[%rax] := "camlCode"
  [A/45[%rax] + 16] := f2/42[%rbx]
  A/46[%rax] := "camlCode"
  fun/47[%rbx] := [A/46[%rax] + 16]
  A/48[%rax] := "camlCode__2"
  A/49[%rdi] := [fun/47[%rbx]]
  {}
  R/0[%rax] := call A/49[%rdi] R/0[%rax] R/1[%rbx]
  A/51[%rbx] := "camlCode"
  [A/51[%rbx] + 24] := a2/50[%rax]
  g/52[%rbx] := "camlCode__1"
  A/53[%rax] := "camlCode"
  [A/53[%rax] + 32] := g/52[%rbx]
  A/54[%rax] := 1
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
	.quad	5120
	.globl	camlCode
camlCode:
	.space	40
	.data
	.quad	2295
camlCode__1:
	.quad	camlCode__g_1040
	.quad	3
	.data
	.quad	2295
camlCode__5:
	.quad	camlCode__f_1042
	.quad	3
	.data
	.quad	2048
camlCode__2:
	.quad	.L100006
	.quad	.L100007
	.quad	1277
.L100007:
	.quad	0x4000000000000000
	.quad	1277
.L100006:
	.quad	0x3ff0000000000000
	.data
	.quad	1277
camlCode__3:
	.quad	0x0
	.data
	.quad	2048
camlCode__4:
	.quad	3
	.quad	5
	.text
	.align	16
	.globl	camlCode__f_1042
camlCode__f_1042:
.L100:
	movq	$3, %rax
	ret
	.type	camlCode__f_1042,@function
	.size	camlCode__f_1042,.-camlCode__f_1042
	.text
	.align	16
	.globl	camlCode__fun_1053
camlCode__fun_1053:
.L101:
	movq	24(%rdi), %rsi
	addq	$2, (%rsi)
	movq	24(%rdi), %rdi
	movq	(%rdi), %rdi
	addq	%rbx, %rax
	leaq	-2(%rax, %rdi), %rax
	ret
	.type	camlCode__fun_1053,@function
	.size	camlCode__fun_1053,.-camlCode__fun_1053
	.text
	.align	16
	.globl	camlCode__fun_1056
camlCode__fun_1056:
	subq	$8, %rsp
.L102:
	movq	%rax, %r12
	movq	%rdi, %rbp
.L103:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L104
	leaq	8(%r15), %rsi
	movq	$1277, -8(%rsi)
	movq	24(%rbp), %rax
	movq	(%rax), %rax
	movlpd	.L106(%rip), %xmm0
	addsd	(%rax), %xmm0
	movlpd	%xmm0, (%rsi)
	movq	24(%rbp), %rdi
	call	caml_modify@PLT
.L107:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L108
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	movq	24(%rbp), %rdi
	movq	(%rdi), %rdi
	movlpd	(%r12), %xmm0
	addsd	(%rbx), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L108:	call	caml_call_gc@PLT
.L109:	jmp	.L107
.L104:	call	caml_call_gc@PLT
.L105:	jmp	.L103
	.section	.rodata.cst8,"a",@progbits
.L106:	.quad	0x3ff0000000000000
	.type	camlCode__fun_1056,@function
	.size	camlCode__fun_1056,.-camlCode__fun_1056
	.text
	.align	16
	.globl	camlCode__g_1040
camlCode__g_1040:
.L110:
	movq	camlCode__5@GOTPCREL(%rip), %rax
	movq	$5, %rax
	ret
	.type	camlCode__g_1040,@function
	.size	camlCode__g_1040,.-camlCode__g_1040
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L111:
	movq	$56, %rax
	call	caml_allocN@PLT
.L112:
	leaq	8(%r15), %rdi
	movq	$1024, -8(%rdi)
	movq	$1, (%rdi)
	leaq	16(%rdi), %rbx
	movq	$4343, -8(%rbx)
	movq	caml_tuplify2@GOTPCREL(%rip), %rax
	movq	%rax, (%rbx)
	movq	$-3, 8(%rbx)
	movq	camlCode__fun_1053@GOTPCREL(%rip), %rax
	movq	%rax, 16(%rbx)
	movq	%rdi, 24(%rbx)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	(%rax), %rbx
	movq	camlCode__4@GOTPCREL(%rip), %rax
	movq	(%rbx), %rdi
	call	*%rdi
.L113:
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	%rax, 8(%rbx)
	movq	$56, %rax
	call	caml_allocN@PLT
.L114:
	leaq	8(%r15), %rdi
	movq	$1024, -8(%rdi)
	movq	camlCode__3@GOTPCREL(%rip), %rax
	movq	%rax, (%rdi)
	leaq	16(%rdi), %rbx
	movq	$4343, -8(%rbx)
	movq	caml_tuplify2@GOTPCREL(%rip), %rax
	movq	%rax, (%rbx)
	movq	$-3, 8(%rbx)
	movq	camlCode__fun_1056@GOTPCREL(%rip), %rax
	movq	%rax, 16(%rbx)
	movq	%rdi, 24(%rbx)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 16(%rax)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	16(%rax), %rbx
	movq	camlCode__2@GOTPCREL(%rip), %rax
	movq	(%rbx), %rdi
	call	*%rdi
.L115:
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	%rax, 24(%rbx)
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 32(%rax)
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
	.quad	6
	.quad	.L115
	.word	16
	.word	0
	.align	8
	.quad	.L114
	.word	16
	.word	0
	.align	8
	.quad	.L113
	.word	16
	.word	0
	.align	8
	.quad	.L112
	.word	16
	.word	0
	.align	8
	.quad	.L109
	.word	16
	.word	3
	.word	21
	.word	3
	.word	23
	.align	8
	.quad	.L105
	.word	16
	.word	3
	.word	21
	.word	3
	.word	23
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

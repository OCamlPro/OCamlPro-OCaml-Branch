

let rec iter f = function
    [] -> ()
  | x :: tail -> f x; iter f tail

let list = [1;2;3;4;5]

let sum =
  let sum = ref 0 in
  iter (fun x -> sum := !sum + x) list;
    !sum



(*
-drawlambda
(seq
  (letrec
    (iter/1030
       (function f/1031 param/1041
         (if param/1041
           (let (tail/1033 (field 1 param/1041) x/1032 (field 0 param/1041))
             (seq (apply f/1031 x/1032) (apply iter/1030 f/1031 tail/1033)))
           0a)))
    (setfield_imm 0 (global Code!) iter/1030))
  (let (list/1034 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global Code!) list/1034))
  (let
    (sum/1035
       (let (sum/1036 (makemutable 0 0))
         (seq
           (apply (field 0 (global Code!))
             (function x/1037
               (setfield_imm 0 sum/1036 (+ (field 0 sum/1036) x/1037)))
             (field 1 (global Code!)))
           (field 0 sum/1036))))
    (setfield_imm 2 (global Code!) sum/1035))
  0a)
-dlambda
(seq
  (letrec
    (iter/1030
       (function f/1031 param/1041
         (if param/1041
           (seq (apply f/1031 (field 0 param/1041))
             (apply iter/1030 f/1031 (field 1 param/1041)))
           0a)))
    (setfield_imm 0 (global Code!) iter/1030))
  (let (list/1034 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global Code!) list/1034))
  (let
    (sum/1035
       (let (sum/1036 (makemutable 0 0))
         (seq
           (apply (field 0 (global Code!))
             (function x/1037
               (setfield_imm 0 sum/1036 (+ (field 0 sum/1036) x/1037)))
             (field 1 (global Code!)))
           (field 0 sum/1036))))
    (setfield_imm 2 (global Code!) sum/1035))
  0a)

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 24)
(data
 int 3319
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter_1030")
(data
 int 2048
 "camlCode__1":
 int 3
 addr L3
 int 2048
 L3:
 int 5
 addr L4
 int 2048
 L4:
 int 7
 addr L5
 int 2048
 L5:
 int 9
 addr L6
 int 2048
 L6:
 int 11
 int 1)
(function camlCode__iter_1030 (f/1031: addr param/1041: addr)
 (if (!= param/1041 1)
   (seq (app (load f/1031) (load param/1041) f/1031 unit)
     (app "camlCode__iter_1030" f/1031 (load (+a param/1041 8)) addr))
   1a))

(function camlCode__fun_1044 (x/1037: addr env/1046: addr)
 (store (load (+a env/1046 16))
   (+ (+ (load (load (+a env/1046 16))) x/1037) -1))
 1a)

(function camlCode__entry ()
 (let clos/1043 "camlCode__2" (store "camlCode" clos/1043))
 (let list/1034 "camlCode__1" (store (+a "camlCode" 8) list/1034))
 (let
   sum/1035
     (let sum/1036 (alloc 1024 1)
       (app "camlCode__iter_1030"
         (alloc 3319 "camlCode__fun_1044" 3 sum/1036)
         (load (+a "camlCode" 8)) unit)
       (load sum/1036))
   (store (+a "camlCode" 16) sum/1035))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__iter_1030:
  f/29[%rsi] := R/0[%rax]
  if param/30[%rbx] ==s 1 goto L100
  spilled-param/36[s0] := param/30[%rbx] (spill)
  spilled-f/35[s1] := f/29[%rsi] (spill)
  A/32[%rax] := [param/30[%rbx]]
  A/33[%rdi] := [f/29[%rsi]]
  R/1[%rbx] := f/29[%rsi]
  {spilled-f/35[s1]* spilled-param/36[s0]*}
  call A/33[%rdi] R/0[%rax] R/1[%rbx]
  param/37[%rax] := spilled-param/36[s0] (reload)
  A/34[%rbx] := [param/37[%rax] + 8]
  f/38[%rax] := spilled-f/35[s1] (reload)
  tailcall "camlCode__iter_1030" R/0[%rax] R/1[%rbx]
  L100:
  A/31[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__fun_1044:
  A/31[%rdi] := [env/30[%rbx] + 16]
  A/32[%rbx] := [env/30[%rbx] + 16]
  A/33[%rbx] := [A/32[%rbx]]
  I/34[%rax] := A/33[%rbx] + x/29[%rax] + -1
  [A/31[%rdi]] := I/34[%rax]
  A/35[%rax] := 1
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  clos/29[%rbx] := "camlCode__2"
  A/30[%rax] := "camlCode"
  [A/30[%rax]] := clos/29[%rbx]
  list/31[%rbx] := "camlCode__1"
  A/32[%rax] := "camlCode"
  [A/32[%rax] + 8] := list/31[%rbx]
  {}
  sum/33[%rdi] := alloc 48
  spilled-sum/41[s0] := sum/33[%rdi] (spill)
  [sum/33[%rdi] + -8] := 1024
  [sum/33[%rdi]] := 1
  A/34[%rax] := sum/33[%rdi] + 16
  [A/34[%rax] + -8] := 3319
  A/35[%rbx] := "camlCode__fun_1044"
  [A/34[%rax]] := A/35[%rbx]
  [A/34[%rax] + 8] := 3
  [A/34[%rax] + 16] := sum/33[%rdi]
  A/36[%rbx] := "camlCode"
  A/37[%rbx] := [A/36[%rbx] + 8]
  {spilled-sum/41[s0]*}
  call "camlCode__iter_1030" R/0[%rax] R/1[%rbx]
  sum/42[%rax] := spilled-sum/41[s0] (reload)
  sum/38[%rbx] := [sum/42[%rax]]
  A/39[%rax] := "camlCode"
  [A/39[%rax] + 16] := sum/38[%rbx]
  A/40[%rax] := 1
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
	.quad	3319
camlCode__2:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__iter_1030
	.data
	.quad	2048
camlCode__1:
	.quad	3
	.quad	.L100003
	.quad	2048
.L100003:
	.quad	5
	.quad	.L100004
	.quad	2048
.L100004:
	.quad	7
	.quad	.L100005
	.quad	2048
.L100005:
	.quad	9
	.quad	.L100006
	.quad	2048
.L100006:
	.quad	11
	.quad	1
	.text
	.align	16
	.globl	camlCode__iter_1030
camlCode__iter_1030:
	subq	$24, %rsp
.L101:
	movq	%rax, %rsi
	cmpq	$1, %rbx
	je	.L100
	movq	%rbx, 0(%rsp)
	movq	%rsi, 8(%rsp)
	movq	(%rbx), %rax
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L102:
	movq	0(%rsp), %rax
	movq	8(%rax), %rbx
	movq	8(%rsp), %rax
	jmp	.L101
	.align	4
.L100:
	movq	$1, %rax
	addq	$24, %rsp
	ret
	.type	camlCode__iter_1030,@function
	.size	camlCode__iter_1030,.-camlCode__iter_1030
	.text
	.align	16
	.globl	camlCode__fun_1044
camlCode__fun_1044:
.L103:
	movq	16(%rbx), %rdi
	movq	16(%rbx), %rbx
	movq	(%rbx), %rbx
	leaq	-1(%rbx, %rax), %rax
	movq	%rax, (%rdi)
	movq	$1, %rax
	ret
	.type	camlCode__fun_1044,@function
	.size	camlCode__fun_1044,.-camlCode__fun_1044
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L104:
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	$48, %rax
	call	caml_allocN@PLT
.L105:
	leaq	8(%r15), %rdi
	movq	%rdi, 0(%rsp)
	movq	$1024, -8(%rdi)
	movq	$1, (%rdi)
	leaq	16(%rdi), %rax
	movq	$3319, -8(%rax)
	movq	camlCode__fun_1044@GOTPCREL(%rip), %rbx
	movq	%rbx, (%rax)
	movq	$3, 8(%rax)
	movq	%rdi, 16(%rax)
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	8(%rbx), %rbx
	call	camlCode__iter_1030@PLT
.L106:
	movq	0(%rsp), %rax
	movq	(%rax), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 16(%rax)
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
	.quad	3
	.quad	.L106
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L105
	.word	16
	.word	0
	.align	8
	.quad	.L102
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

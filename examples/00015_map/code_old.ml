(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.
*)


let rec map f list =
  match list with
      [] -> []
    | x :: tail ->
      let x = f x in
      x :: map f tail



let list =
  map (fun x -> x+1) [1;2;3;4;5]

(*
let map1 =
  let z = List.map (fun x -> x + 1) [1;2;3] in
  let rec map1 f l =
    match l with
	[] -> z
      | a::l ->
	  let x = f a in
	    x :: (map1 f l)
  in
    map1
*)
(*
-drawlambda
(seq
  (letrec
    (map/1030
       (function f/1031 list/1032
         (if list/1032
           (let
             (tail/1034 (field 1 list/1032)
              x/1033 (field 0 list/1032)
              x/1035 (apply f/1031 x/1033))
             (makeblock 0 x/1035 (apply map/1030 f/1031 tail/1034)))
           0a)))
    (setfield_imm 0 (global Code!) map/1030))
  (let
    (list/1036
       (apply (field 0 (global Code!)) (function x/1037 (+ x/1037 1))
         [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]))
    (setfield_imm 1 (global Code!) list/1036))
  0a)
-dlambda
(seq
  (letrec
    (map/1030
       (function f/1031 list/1032
         (if list/1032
           (let (x/1035 (apply f/1031 (field 0 list/1032)))
             (makeblock 0 x/1035 (apply map/1030 f/1031 (field 1 list/1032))))
           0a)))
    (setfield_imm 0 (global Code!) map/1030))
  (let
    (list/1036
       (apply (field 0 (global Code!)) (function x/1037 (+ x/1037 1))
         [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]))
    (setfield_imm 1 (global Code!) list/1036))
  0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__1": addr "camlCode__fun_1042" int 3)
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__map_1030")
(data
 int 2048
 "camlCode__2":
 int 3
 addr L4
 int 2048
 L4:
 int 5
 addr L5
 int 2048
 L5:
 int 7
 addr L6
 int 2048
 L6:
 int 9
 addr L7
 int 2048
 L7:
 int 11
 int 1)
(function camlCode__map_1030 (f/1031: addr list/1032: addr)
 (if (!= list/1032 1)
   (let x/1035 (app (load f/1031) (load list/1032) f/1031 addr)
     (alloc 2048 x/1035
       (app "camlCode__map_1030" f/1031 (load (+a list/1032 8)) addr)))
   1a))

(function camlCode__fun_1042 (x/1037: addr) (+ x/1037 2))

(function camlCode__entry ()
 (let clos/1041 "camlCode__3" (store "camlCode" clos/1041))
 (let list/1036 (app "camlCode__map_1030" "camlCode__1" "camlCode__2" addr)
   (store (+a "camlCode" 8) list/1036))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__map_1030:
  f/29[%rsi] := R/0[%rax]
  if list/30[%rbx] ==s 1 goto L100
  spilled-list/40[s0] := list/30[%rbx] (spill)
  spilled-f/39[s1] := f/29[%rsi] (spill)
  A/32[%rax] := [list/30[%rbx]]
  A/33[%rdi] := [f/29[%rsi]]
  R/1[%rbx] := f/29[%rsi]
  {spilled-f/39[s1]* spilled-list/40[s0]*}
  R/0[%rax] := call A/33[%rdi] R/0[%rax] R/1[%rbx]
  spilled-x/38[s2] := x/34[%rax] (spill)
  list/41[%rax] := spilled-list/40[s0] (reload)
  A/35[%rbx] := [list/41[%rax] + 8]
  f/42[%rax] := spilled-f/39[s1] (reload)
  {spilled-x/38[s2]*}
  R/0[%rax] := call "camlCode__map_1030" R/0[%rax] R/1[%rbx]
  A/36[%rdi] := R/0[%rax]
  {A/36[%rdi]* spilled-x/38[s2]*}
  A/37[%rax] := alloc 24
  [A/37[%rax] + -8] := 2048
  x/43[%rbx] := spilled-x/38[s2] (reload)
  [A/37[%rax]] := x/43[%rbx]
  [A/37[%rax] + 8] := A/36[%rdi]
  reload retaddr
  return R/0[%rax]
  L100:
  A/31[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__fun_1042:
  I/30[%rax] := I/30[%rax] + 2
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  clos/29[%rbx] := "camlCode__3"
  A/30[%rax] := "camlCode"
  [A/30[%rax]] := clos/29[%rbx]
  A/31[%rbx] := "camlCode__2"
  A/32[%rax] := "camlCode__1"
  {}
  R/0[%rax] := call "camlCode__map_1030" R/0[%rax] R/1[%rbx]
  A/34[%rbx] := "camlCode"
  [A/34[%rbx] + 8] := list/33[%rax]
  A/35[%rax] := 1
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
	.data
	.quad	2295
camlCode__1:
	.quad	camlCode__fun_1042
	.quad	3
	.data
	.quad	3319
camlCode__3:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__map_1030
	.data
	.quad	2048
camlCode__2:
	.quad	3
	.quad	.L100004
	.quad	2048
.L100004:
	.quad	5
	.quad	.L100005
	.quad	2048
.L100005:
	.quad	7
	.quad	.L100006
	.quad	2048
.L100006:
	.quad	9
	.quad	.L100007
	.quad	2048
.L100007:
	.quad	11
	.quad	1
	.text
	.align	16
	.globl	camlCode__map_1030
camlCode__map_1030:
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
	movq	%rax, 16(%rsp)
	movq	0(%rsp), %rax
	movq	8(%rax), %rbx
	movq	8(%rsp), %rax
	call	camlCode__map_1030@PLT
.L103:
	movq	%rax, %rdi
.L104:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L105
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	16(%rsp), %rbx
	movq	%rbx, (%rax)
	movq	%rdi, 8(%rax)
	addq	$24, %rsp
	ret
	.align	4
.L100:
	movq	$1, %rax
	addq	$24, %rsp
	ret
.L105:	call	caml_call_gc@PLT
.L106:	jmp	.L104
	.type	camlCode__map_1030,@function
	.size	camlCode__map_1030,.-camlCode__map_1030
	.text
	.align	16
	.globl	camlCode__fun_1042
camlCode__fun_1042:
.L107:
	addq	$2, %rax
	ret
	.type	camlCode__fun_1042,@function
	.size	camlCode__fun_1042,.-camlCode__fun_1042
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L108:
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode__1@GOTPCREL(%rip), %rax
	call	camlCode__map_1030@PLT
.L109:
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	%rax, 8(%rbx)
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
	.quad	.L109
	.word	16
	.word	0
	.align	8
	.quad	.L106
	.word	32
	.word	2
	.word	16
	.word	5
	.align	8
	.quad	.L103
	.word	32
	.word	1
	.word	16
	.align	8
	.quad	.L102
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

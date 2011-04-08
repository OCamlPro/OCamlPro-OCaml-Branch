(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.
*)

let rec fun_a f list =
  match list with
      [] -> 0
    | x :: tail ->
	(f x) + (fun_b f tail)

and fun_b g list =
  match list with
      [] -> 0
    | x :: tail -> fun_a g tail

let _ =
  fun_a (fun x -> x + 1) [1;2;3;4]

(*
-drawlambda
(seq
  (letrec
    (fun_a/58
       (function f/60 list/61
         (if list/61
           (let (tail/63 (field 1 list/61) x/62 (field 0 list/61))
             (+ (apply f/60 x/62) (apply fun_b/59 f/60 tail/63)))
           0))
      fun_b/59
        (function g/64 list/65
          (if list/65
            (let (tail/67 (field 1 list/65) x/66 (field 0 list/65))
              (apply fun_a/58 g/64 tail/67))
            0)))
    (seq (setfield_imm 0 (global Code!) fun_a/58)
      (setfield_imm 1 (global Code!) fun_b/59)))
  (apply (field 0 (global Code!)) (function x/68 (+ x/68 1))
    [0: 1 [0: 2 [0: 3 [0: 4 0a]]]])
  0a)
-dlambda
(seq
  (letrec
    (fun_a/58
       (function f/60 list/61
         (if list/61
           (+ (apply f/60 (field 0 list/61))
             (apply fun_b/59 f/60 (field 1 list/61)))
           0))
      fun_b/59
        (function g/64 list/65
          (if list/65 (apply fun_a/58 g/64 (field 1 list/65)) 0)))
    (seq (setfield_imm 0 (global Code!) fun_a/58)
      (setfield_imm 1 (global Code!) fun_b/59)))
  (apply (field 0 (global Code!)) (function x/68 (+ x/68 1))
    [0: 1 [0: 2 [0: 3 [0: 4 0a]]]])
  0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__fun_74" int 3)
(data
 int 7415
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__fun_a_58"
 int 4345
 addr "caml_curry2"
 int 5
 addr "camlCode__fun_b_59")
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
 int 1)
(function camlCode__fun_b_59 (g/64: addr list/65: addr)
 (if (!= list/65 1)
   (app "camlCode__fun_a_58" g/64 (load (+a list/65 4)) addr) 1))

(function camlCode__fun_a_58 (f/60: addr list/61: addr)
 (if (!= list/61 1)
   (+
     (+ (app (load f/60) (load list/61) f/60 addr)
       (app "camlCode__fun_b_59" f/60 (load (+a list/61 4)) addr))
     -1)
   1))

(function camlCode__fun_74 (x/68: addr) (+ x/68 2))

(function camlCode__entry ()
 (let clos/73 "camlCode__3" (store "camlCode" clos/73)
   (store (+a "camlCode" 4) (+a clos/73 16)))
 (app "camlCode__fun_a_58" "camlCode__1" "camlCode__2" unit) 1a)

(data)
-dlinear
*** Linearized code
camlCode__fun_b_59:
  if list/9[%ebx] ==s 1 goto L100
  A/11[%ebx] := [list/9[%ebx] + 4]
  tailcall "camlCode__fun_a_58" R/0[%eax] R/1[%ebx]
  L100:
  I/10[%eax] := 1
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_a_58:
  if list/9[%ebx] ==s 1 goto L102
  spilled-list/20[s0] := list/9[%ebx] (spill)
  spilled-f/19[s1] := f/8[%eax] (spill)
  A/11[%ebx] := [list/9[%ebx] + 4]
  {spilled-f/19[s1]* spilled-list/20[s0]*}
  R/0[%eax] := call "camlCode__fun_b_59" R/0[%eax] R/1[%ebx]
  A/18[s2] := A/12[%eax] (spill)
  list/21[%eax] := spilled-list/20[s0] (reload)
  A/13[%eax] := [list/21[%eax]]
  f/22[%ebx] := spilled-f/19[s1] (reload)
  A/14[%ecx] := [f/22[%ebx]]
  {A/18[s2]*}
  R/0[%eax] := call A/14[%ecx] R/0[%eax] R/1[%ebx]
  A/23[%ebx] := A/18[s2] (reload)
  I/16[%eax] := I/16[%eax] + A/23[%ebx]
  I/17[%eax] := I/17[%eax] + -1
  reload retaddr
  return R/0[%eax]
  L102:
  I/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_74:
  I/9[%eax] := I/9[%eax] + 2
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  clos/8[%eax] := "camlCode__3"
  ["camlCode"] := clos/8[%eax]
  A/9[%eax] := A/9[%eax] + 16
  ["camlCode" + 4] := A/9[%eax]
  A/10[%ebx] := "camlCode__2"
  A/11[%eax] := "camlCode__1"
  {}
  call "camlCode__fun_a_58" R/0[%eax] R/1[%ebx]
  A/12[%eax] := 1
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
	.data
	.long	2295
camlCode__1:
	.long	camlCode__fun_74
	.long	3
	.data
	.long	7415
camlCode__3:
	.long	caml_curry2
	.long	5
	.long	camlCode__fun_a_58
	.long	4345
	.long	caml_curry2
	.long	5
	.long	camlCode__fun_b_59
	.data
	.long	2048
camlCode__2:
	.long	3
	.long	.L100004
	.long	2048
.L100004:
	.long	5
	.long	.L100005
	.long	2048
.L100005:
	.long	7
	.long	.L100006
	.long	2048
.L100006:
	.long	9
	.long	1
	.text
	.align	16
	.globl	camlCode__fun_b_59
camlCode__fun_b_59:
.L101:
	cmpl	$1, %ebx
	je	.L100
	movl	4(%ebx), %ebx
	jmp	camlCode__fun_a_58
	.align	16
.L100:
	movl	$1, %eax
	ret
	.type	camlCode__fun_b_59,@function
	.size	camlCode__fun_b_59,.-camlCode__fun_b_59
	.text
	.align	16
	.globl	camlCode__fun_a_58
camlCode__fun_a_58:
	subl	$12, %esp
.L103:
	cmpl	$1, %ebx
	je	.L102
	movl	%ebx, 0(%esp)
	movl	%eax, 4(%esp)
	movl	4(%ebx), %ebx
	call	camlCode__fun_b_59
.L104:
	movl	%eax, 8(%esp)
	movl	0(%esp), %eax
	movl	(%eax), %eax
	movl	4(%esp), %ebx
	movl	(%ebx), %ecx
	call	*%ecx
.L105:
	movl	8(%esp), %ebx
	addl	%ebx, %eax
	decl	%eax
	addl	$12, %esp
	ret
	.align	16
.L102:
	movl	$1, %eax
	addl	$12, %esp
	ret
	.type	camlCode__fun_a_58,@function
	.size	camlCode__fun_a_58,.-camlCode__fun_a_58
	.text
	.align	16
	.globl	camlCode__fun_74
camlCode__fun_74:
.L106:
	addl	$2, %eax
	ret
	.type	camlCode__fun_74,@function
	.size	camlCode__fun_74,.-camlCode__fun_74
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L107:
	movl	$camlCode__3, %eax
	movl	%eax, camlCode
	addl	$16, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__2, %ebx
	movl	$camlCode__1, %eax
	call	camlCode__fun_a_58
.L108:
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
	.long	3
	.long	.L108
	.word	4
	.word	0
	.align	4
	.long	.L105
	.word	16
	.word	1
	.word	8
	.align	4
	.long	.L104
	.word	16
	.word	2
	.word	0
	.word	4
	.align	4

	.section .note.GNU-stack,"",%progbits
*)



let rec iter f = function
    [] -> ()
  | x :: tail -> f x; iter f tail

let list = [1;2;3;4;5]

let sum =
  let sum = ref 0 in
    List.iter (fun x -> sum := !sum + x) list;
    !sum



(*
-drawlambda
(seq
  (letrec
    (iter/58
       (function f/59 param/69
         (if param/69
           (let (tail/61 (field 1 param/69) x/60 (field 0 param/69))
             (seq (apply f/59 x/60) (apply iter/58 f/59 tail/61)))
           0a)))
    (setfield_imm 0 (global Code!) iter/58))
  (let (list/62 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global Code!) list/62))
  (let
    (sum/63
       (let (sum/64 (makemutable 0 0))
         (seq
           (apply (field 9 (global List!))
             (function x/65
               (setfield_imm 0 sum/64 (+ (field 0 sum/64) x/65)))
             (field 1 (global Code!)))
           (field 0 sum/64))))
    (setfield_imm 2 (global Code!) sum/63))
  0a)
-dlambda
(seq
  (letrec
    (iter/58
       (function f/59 param/69
         (if param/69
           (seq (apply f/59 (field 0 param/69))
             (apply iter/58 f/59 (field 1 param/69)))
           0a)))
    (setfield_imm 0 (global Code!) iter/58))
  (let (list/62 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global Code!) list/62))
  (let
    (sum/63
       (let (sum/64 (makemutable 0 0))
         (seq
           (apply (field 9 (global List!))
             (function x/65
               (setfield_imm 0 sum/64 (+ (field 0 sum/64) x/65)))
             (field 1 (global Code!)))
           (field 0 sum/64))))
    (setfield_imm 2 (global Code!) sum/63))
  0a)

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 12)
(data
 int 3319
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter_58")
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
(function camlCode__iter_58 (f/59: addr param/69: addr)
 (if (!= param/69 1)
   (seq (app (load f/59) (load param/69) f/59 unit)
     (app "camlCode__iter_58" f/59 (load (+a param/69 4)) addr))
   1a))

(function camlCode__fun_72 (x/65: addr env/74: addr)
 (store (load (+a env/74 8)) (+ (+ (load (load (+a env/74 8))) x/65) -1)) 1a)

(function camlCode__entry ()
 (let clos/71 "camlCode__2" (store "camlCode" clos/71))
 (let list/62 "camlCode__1" (store (+a "camlCode" 4) list/62))
 (let
   sum/63
     (let sum/64 (alloc 1024 1)
       (app "camlList__iter_102" (alloc 3319 "camlCode__fun_72" 3 sum/64)
         (load (+a "camlCode" 4)) unit)
       (load sum/64))
   (store (+a "camlCode" 8) sum/63))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__iter_58:
  f/8[%edx] := R/0[%eax]
  if param/9[%ebx] ==s 1 goto L100
  spilled-param/15[s0] := param/9[%ebx] (spill)
  spilled-f/14[s1] := f/8[%edx] (spill)
  A/11[%eax] := [param/9[%ebx]]
  A/12[%ecx] := [f/8[%edx]]
  R/1[%ebx] := f/8[%edx]
  {spilled-f/14[s1]* spilled-param/15[s0]*}
  call A/12[%ecx] R/0[%eax] R/1[%ebx]
  param/16[%eax] := spilled-param/15[s0] (reload)
  A/13[%ebx] := [param/16[%eax] + 4]
  f/17[%eax] := spilled-f/14[s1] (reload)
  tailcall "camlCode__iter_58" R/0[%eax] R/1[%ebx]
  L100:
  A/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_72:
  A/10[%ecx] := [env/9[%ebx] + 8]
  A/11[%ebx] := [env/9[%ebx] + 8]
  A/12[%ebx] := [A/11[%ebx]]
  I/13[%eax] := A/12[%ebx] + x/8[%eax] + -1
  [A/10[%ecx]] := I/13[%eax]
  A/14[%eax] := 1
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  clos/8[%eax] := "camlCode__2"
  ["camlCode"] := clos/8[%eax]
  list/9[%eax] := "camlCode__1"
  ["camlCode" + 4] := list/9[%eax]
  {}
  sum/10[%ebx] := alloc 24
  spilled-sum/15[s0] := sum/10[%ebx] (spill)
  [sum/10[%ebx] + -4] := 1024
  [sum/10[%ebx]] := 1
  A/11[%eax] := sum/10[%ebx] + 8
  [A/11[%eax] + -4] := 3319
  [A/11[%eax]] := "camlCode__fun_72"
  [A/11[%eax] + 4] := 3
  [A/11[%eax] + 8] := sum/10[%ebx]
  A/12[%ebx] := ["camlCode" + 4]
  {spilled-sum/15[s0]*}
  call "camlList__iter_102" R/0[%eax] R/1[%ebx]
  sum/16[%eax] := spilled-sum/15[s0] (reload)
  sum/13[%eax] := [sum/16[%eax]]
  ["camlCode" + 8] := sum/13[%eax]
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
	.long	3072
	.globl	camlCode
camlCode:
	.space	12
	.data
	.long	3319
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__iter_58
	.data
	.long	2048
camlCode__1:
	.long	3
	.long	.L100003
	.long	2048
.L100003:
	.long	5
	.long	.L100004
	.long	2048
.L100004:
	.long	7
	.long	.L100005
	.long	2048
.L100005:
	.long	9
	.long	.L100006
	.long	2048
.L100006:
	.long	11
	.long	1
	.text
	.align	16
	.globl	camlCode__iter_58
camlCode__iter_58:
	subl	$8, %esp
.L101:
	movl	%eax, %edx
	cmpl	$1, %ebx
	je	.L100
	movl	%ebx, 0(%esp)
	movl	%edx, 4(%esp)
	movl	(%ebx), %eax
	movl	(%edx), %ecx
	movl	%edx, %ebx
	call	*%ecx
.L102:
	movl	0(%esp), %eax
	movl	4(%eax), %ebx
	movl	4(%esp), %eax
	jmp	.L101
	.align	16
.L100:
	movl	$1, %eax
	addl	$8, %esp
	ret
	.type	camlCode__iter_58,@function
	.size	camlCode__iter_58,.-camlCode__iter_58
	.text
	.align	16
	.globl	camlCode__fun_72
camlCode__fun_72:
.L103:
	movl	8(%ebx), %ecx
	movl	8(%ebx), %ebx
	movl	(%ebx), %ebx
	lea	-1(%ebx, %eax), %eax
	movl	%eax, (%ecx)
	movl	$1, %eax
	ret
	.type	camlCode__fun_72,@function
	.size	camlCode__fun_72,.-camlCode__fun_72
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$4, %esp
.L104:
	movl	$camlCode__2, %eax
	movl	%eax, camlCode
	movl	$camlCode__1, %eax
	movl	%eax, camlCode + 4
	movl	$24, %eax
	call	caml_allocN
.L105:
	leal	4(%eax), %ebx
	movl	%ebx, 0(%esp)
	movl	$1024, -4(%ebx)
	movl	$1, (%ebx)
	leal	8(%ebx), %eax
	movl	$3319, -4(%eax)
	movl	$camlCode__fun_72, (%eax)
	movl	$3, 4(%eax)
	movl	%ebx, 8(%eax)
	movl	camlCode + 4, %ebx
	call	camlList__iter_102
.L106:
	movl	0(%esp), %eax
	movl	(%eax), %eax
	movl	%eax, camlCode + 8
	movl	$1, %eax
	addl	$4, %esp
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
	.long	.L106
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L105
	.word	8
	.word	0
	.align	4
	.long	.L102
	.word	12
	.word	2
	.word	0
	.word	4
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

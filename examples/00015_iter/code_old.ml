(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.
*)

let rec iter1 f l =
  match l with
      [] -> ()
    | a::l -> f a; iter1 f l

let computed1 =
  let list1 = ref [] in
  iter1 (fun x -> list1 := x :: !list1) [1; 2; 3; 4; 5];
    !list1

let computed2 =
  let list1 = ref [] in
  iter1 (fun (x,y) -> list1 := x :: !list1) [1,2; 2,3; 3,3; 4,5; 5,6];
    !list1

(*
-drawlambda
(seq
  (letrec
    (iter1/1030
       (function f/1031 l/1032
         (if l/1032
           (let (l/1034 (field 1 l/1032) a/1033 (field 0 l/1032))
             (seq (apply f/1031 a/1033) (apply iter1/1030 f/1031 l/1034)))
           0a)))
    (setfield_imm 0 (global Code!) iter1/1030))
  (let
    (computed1/1035
       (let (list1/1036 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function x/1037
               (setfield_ptr 0 list1/1036
                 (makeblock 0 x/1037 (field 0 list1/1036))))
             [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
           (field 0 list1/1036))))
    (setfield_imm 1 (global Code!) computed1/1035))
  (let
    (computed2/1038
       (let (list1/1039 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function (param/1045, param/1046)
               (let (y/1041 param/1046 x/1040 param/1045)
                 (setfield_ptr 0 list1/1039
                   (makeblock 0 x/1040 (field 0 list1/1039)))))
             [0:
              [0: 1 2]
              [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]])
           (field 0 list1/1039))))
    (setfield_imm 2 (global Code!) computed2/1038))
  0a)
-dlambda
(seq
  (letrec
    (iter1/1030
       (function f/1031 l/1032
         (if l/1032
           (seq (apply f/1031 (field 0 l/1032))
             (apply iter1/1030 f/1031 (field 1 l/1032)))
           0a)))
    (setfield_imm 0 (global Code!) iter1/1030))
  (let
    (computed1/1035
       (let (list1/1036 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function x/1037
               (setfield_ptr 0 list1/1036
                 (makeblock 0 x/1037 (field 0 list1/1036))))
             [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
           (field 0 list1/1036))))
    (setfield_imm 1 (global Code!) computed1/1035))
  (let
    (computed2/1038
       (let (list1/1039 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function (param/1045, param/1046)
               (setfield_ptr 0 list1/1039
                 (makeblock 0 param/1045 (field 0 list1/1039))))
             [0:
              [0: 1 2]
              [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]])
           (field 0 list1/1039))))
    (setfield_imm 2 (global Code!) computed2/1038))
  0a)

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 12)
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter1_1030")
(data
 int 2048
 "camlCode__1":
 addr L8
 addr L9
 int 2048
 L9:
 addr L10
 addr L11
 int 2048
 L11:
 addr L12
 addr L13
 int 2048
 L13:
 addr L14
 addr L15
 int 2048
 L15:
 addr L16
 int 1
 int 2048
 L16:
 int 11
 int 13
 int 2048
 L14:
 int 9
 int 11
 int 2048
 L12:
 int 7
 int 7
 int 2048
 L10:
 int 5
 int 7
 int 2048
 L8:
 int 3
 int 5)
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
(function camlCode__iter1_1030 (f/1031: addr l/1032: addr)
 (if (!= l/1032 1)
   (seq (app (load f/1031) (load l/1032) f/1031 unit)
     (app "camlCode__iter1_1030" f/1031 (load (+a l/1032 4)) addr))
   1a))

(function camlCode__fun_1049 (x/1037: addr env/1051: addr)
 (extcall "caml_modify" (load (+a env/1051 8))
   (alloc 2048 x/1037 (load (load (+a env/1051 8)))) unit)
 1a)

(function camlCode__fun_1052
     (param/1045: addr param/1046: addr env/1054: addr)
 (extcall "caml_modify" (load (+a env/1054 12))
   (alloc 2048 param/1045 (load (load (+a env/1054 12)))) unit)
 1a)

(function camlCode__entry ()
 (let clos/1048 "camlCode__3" (store "camlCode" clos/1048))
 (let
   computed1/1035
     (let list1/1036 (alloc 1024 1a)
       (app "camlCode__iter1_1030"
         (alloc 3319 "camlCode__fun_1049" 3 list1/1036) "camlCode__2" unit)
       (load list1/1036))
   (store (+a "camlCode" 4) computed1/1035))
 (let
   computed2/1038
     (let list1/1039 (alloc 1024 1a)
       (app "camlCode__iter1_1030"
         (alloc 4343 "caml_tuplify2" -3 "camlCode__fun_1052" list1/1039)
         "camlCode__1" unit)
       (load list1/1039))
   (store (+a "camlCode" 8) computed2/1038))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__iter1_1030:
  f/8[%edx] := R/0[%eax]
  if l/9[%ebx] ==s 1 goto L100
  spilled-l/15[s0] := l/9[%ebx] (spill)
  spilled-f/14[s1] := f/8[%edx] (spill)
  A/11[%eax] := [l/9[%ebx]]
  A/12[%ecx] := [f/8[%edx]]
  R/1[%ebx] := f/8[%edx]
  {spilled-f/14[s1]* spilled-l/15[s0]*}
  call A/12[%ecx] R/0[%eax] R/1[%ebx]
  l/16[%eax] := spilled-l/15[s0] (reload)
  A/13[%ebx] := [l/16[%eax] + 4]
  f/17[%eax] := spilled-f/14[s1] (reload)
  tailcall "camlCode__iter1_1030" R/0[%eax] R/1[%ebx]
  L100:
  A/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_1049:
  x/8[%edx] := R/0[%eax]
  {x/8[%edx]* env/9[%ebx]*}
  A/10[%ecx] := alloc 12
  [A/10[%ecx] + -4] := 2048
  [A/10[%ecx]] := x/8[%edx]
  A/11[%eax] := [env/9[%ebx] + 8]
  A/12[%eax] := [A/11[%eax]]
  [A/10[%ecx] + 4] := A/12[%eax]
  push A/10[%ecx]
  push [env/9[%ebx] + 8]
  {}
  extcall "caml_modify" 
  offset stack -8
  A/13[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_1052:
  param/8[%edx] := R/0[%eax]
  {param/8[%edx]* env/10[%ecx]*}
  A/11[%ebx] := alloc 12
  [A/11[%ebx] + -4] := 2048
  [A/11[%ebx]] := param/8[%edx]
  A/12[%eax] := [env/10[%ecx] + 12]
  A/13[%eax] := [A/12[%eax]]
  [A/11[%ebx] + 4] := A/13[%eax]
  push A/11[%ebx]
  push [env/10[%ecx] + 12]
  {}
  extcall "caml_modify" 
  offset stack -8
  A/14[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  clos/8[%eax] := "camlCode__3"
  ["camlCode"] := clos/8[%eax]
  {}
  list1/9[%ebx] := alloc 24
  spilled-list1/19[s0] := list1/9[%ebx] (spill)
  [list1/9[%ebx] + -4] := 1024
  [list1/9[%ebx]] := 1
  A/10[%eax] := list1/9[%ebx] + 8
  [A/10[%eax] + -4] := 3319
  [A/10[%eax]] := "camlCode__fun_1049"
  [A/10[%eax] + 4] := 3
  [A/10[%eax] + 8] := list1/9[%ebx]
  A/11[%ebx] := "camlCode__2"
  {spilled-list1/19[s0]*}
  call "camlCode__iter1_1030" R/0[%eax] R/1[%ebx]
  list1/20[%eax] := spilled-list1/19[s0] (reload)
  computed1/12[%eax] := [list1/20[%eax]]
  ["camlCode" + 4] := computed1/12[%eax]
  {}
  list1/13[%ebx] := alloc 28
  spilled-list1/18[s0] := list1/13[%ebx] (spill)
  [list1/13[%ebx] + -4] := 1024
  [list1/13[%ebx]] := 1
  A/14[%eax] := list1/13[%ebx] + 8
  [A/14[%eax] + -4] := 4343
  [A/14[%eax]] := "caml_tuplify2"
  [A/14[%eax] + 4] := -3
  [A/14[%eax] + 8] := "camlCode__fun_1052"
  [A/14[%eax] + 12] := list1/13[%ebx]
  A/15[%ebx] := "camlCode__1"
  {spilled-list1/18[s0]*}
  call "camlCode__iter1_1030" R/0[%eax] R/1[%ebx]
  list1/21[%eax] := spilled-list1/18[s0] (reload)
  computed2/16[%eax] := [list1/21[%eax]]
  ["camlCode" + 8] := computed2/16[%eax]
  A/17[%eax] := 1
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
camlCode__3:
	.long	caml_curry2
	.long	5
	.long	camlCode__iter1_1030
	.data
	.long	2048
camlCode__1:
	.long	.L100008
	.long	.L100009
	.long	2048
.L100009:
	.long	.L100010
	.long	.L100011
	.long	2048
.L100011:
	.long	.L100012
	.long	.L100013
	.long	2048
.L100013:
	.long	.L100014
	.long	.L100015
	.long	2048
.L100015:
	.long	.L100016
	.long	1
	.long	2048
.L100016:
	.long	11
	.long	13
	.long	2048
.L100014:
	.long	9
	.long	11
	.long	2048
.L100012:
	.long	7
	.long	7
	.long	2048
.L100010:
	.long	5
	.long	7
	.long	2048
.L100008:
	.long	3
	.long	5
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
	.long	.L100007
	.long	2048
.L100007:
	.long	11
	.long	1
	.text
	.align	16
	.globl	camlCode__iter1_1030
camlCode__iter1_1030:
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
	.type	camlCode__iter1_1030,@function
	.size	camlCode__iter1_1030,.-camlCode__iter1_1030
	.text
	.align	16
	.globl	camlCode__fun_1049
camlCode__fun_1049:
.L103:
	movl	%eax, %edx
.L104:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L105
	leal	4(%eax), %ecx
	movl	$2048, -4(%ecx)
	movl	%edx, (%ecx)
	movl	8(%ebx), %eax
	movl	(%eax), %eax
	movl	%eax, 4(%ecx)
	pushl	%ecx
	pushl	8(%ebx)
	call	caml_modify
	addl	$8, %esp
	movl	$1, %eax
	ret
.L105:	call	caml_call_gc
.L106:	jmp	.L104
	.type	camlCode__fun_1049,@function
	.size	camlCode__fun_1049,.-camlCode__fun_1049
	.text
	.align	16
	.globl	camlCode__fun_1052
camlCode__fun_1052:
.L107:
	movl	%eax, %edx
.L108:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L109
	leal	4(%eax), %ebx
	movl	$2048, -4(%ebx)
	movl	%edx, (%ebx)
	movl	12(%ecx), %eax
	movl	(%eax), %eax
	movl	%eax, 4(%ebx)
	pushl	%ebx
	pushl	12(%ecx)
	call	caml_modify
	addl	$8, %esp
	movl	$1, %eax
	ret
.L109:	call	caml_call_gc
.L110:	jmp	.L108
	.type	camlCode__fun_1052,@function
	.size	camlCode__fun_1052,.-camlCode__fun_1052
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$4, %esp
.L111:
	movl	$camlCode__3, %eax
	movl	%eax, camlCode
	movl	$24, %eax
	call	caml_allocN
.L112:
	leal	4(%eax), %ebx
	movl	%ebx, 0(%esp)
	movl	$1024, -4(%ebx)
	movl	$1, (%ebx)
	leal	8(%ebx), %eax
	movl	$3319, -4(%eax)
	movl	$camlCode__fun_1049, (%eax)
	movl	$3, 4(%eax)
	movl	%ebx, 8(%eax)
	movl	$camlCode__2, %ebx
	call	camlCode__iter1_1030
.L113:
	movl	0(%esp), %eax
	movl	(%eax), %eax
	movl	%eax, camlCode + 4
	movl	$28, %eax
	call	caml_allocN
.L114:
	leal	4(%eax), %ebx
	movl	%ebx, 0(%esp)
	movl	$1024, -4(%ebx)
	movl	$1, (%ebx)
	leal	8(%ebx), %eax
	movl	$4343, -4(%eax)
	movl	$caml_tuplify2, (%eax)
	movl	$-3, 4(%eax)
	movl	$camlCode__fun_1052, 8(%eax)
	movl	%ebx, 12(%eax)
	movl	$camlCode__1, %ebx
	call	camlCode__iter1_1030
.L115:
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
	.long	7
	.long	.L115
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L114
	.word	8
	.word	0
	.align	4
	.long	.L113
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L112
	.word	8
	.word	0
	.align	4
	.long	.L110
	.word	4
	.word	2
	.word	5
	.word	7
	.align	4
	.long	.L106
	.word	4
	.word	2
	.word	3
	.word	7
	.align	4
	.long	.L102
	.word	12
	.word	2
	.word	0
	.word	4
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

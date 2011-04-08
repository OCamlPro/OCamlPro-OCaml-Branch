(* 
In [f0], the compiler should detect that the closure for [g0] contains only
[y], and so, the closure should not be allocated. 

In [f1], the compiler should detect that the closure for [g1] contains only
[y] and [c1], and so, it can avoid allocating the closure by giving 
[y] and [c1] as extra arguments to [g1].
*)

let _ =
  let f0 x y =
    let g0 z = 
      let sum = ref 0 in
      let list = List.iter (fun a -> sum := !sum + y * z) [1;2;3;4;5;6] in
      !sum 
    in
    g0 (x+3)
  in
  f0 0 1
  
let _ =
  let c1 = [1;2;3;4;5;6] in
  let f1 x y =
    let g1 z = 
      let sum = ref 0 in
      let list = List.iter (fun a -> sum := !sum + y * z) c1 in
      !sum 
    in
    g1 (x+3)
  in
  f1 0 1
  
    (*
-drawlambda
File "code.ml", line 14, characters 10-14:
Warning Y: unused variable list.
File "code.ml", line 26, characters 10-14:
Warning Y: unused variable list.
(seq
  (let
    (f0/58
       (function x/59 y/60
         (let
           (g0/61
              (function z/62
                (let
                  (sum/63 (makemutable 0 0)
                   list/64
                     (apply (field 9 (global List!))
                       (function a/65
                         (setfield_imm 0 sum/63
                           (+ (field 0 sum/63) (* y/60 z/62))))
                       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]]))
                  (field 0 sum/63))))
           (apply g0/61 (+ x/59 3)))))
    (apply f0/58 0 1))
  (let
    (c1/66 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]]
     f1/67
       (function x/68 y/69
         (let
           (g1/70
              (function z/71
                (let
                  (sum/72 (makemutable 0 0)
                   list/73
                     (apply (field 9 (global List!))
                       (function a/74
                         (setfield_imm 0 sum/72
                           (+ (field 0 sum/72) (* y/69 z/71))))
                       c1/66))
                  (field 0 sum/72))))
           (apply g1/70 (+ x/68 3)))))
    (apply f1/67 0 1))
  0a)
-dlambda
File "code.ml", line 14, characters 10-14:
Warning Y: unused variable list.
File "code.ml", line 26, characters 10-14:
Warning Y: unused variable list.
(seq
  (let
    (f0/58
       (function x/59 y/60
         (let
           (g0/61
              (function z/62
                (let
                  (sum/63 (makemutable 0 0)
                   list/64
                     (apply (field 9 (global List!))
                       (function a/65
                         (setfield_imm 0 sum/63
                           (+ (field 0 sum/63) (* y/60 z/62))))
                       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]]))
                  (field 0 sum/63))))
           (apply g0/61 (+ x/59 3)))))
    (apply f0/58 0 1))
  (let
    (c1/66 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]]
     f1/67
       (function x/68 y/69
         (let
           (g1/70
              (function z/71
                (let
                  (sum/72 (makemutable 0 0)
                   list/73
                     (apply (field 9 (global List!))
                       (function a/74
                         (setfield_imm 0 sum/72
                           (+ (field 0 sum/72) (* y/69 z/71))))
                       c1/66))
                  (field 0 sum/72))))
           (apply g1/70 (+ x/68 3)))))
    (apply f1/67 0 1))
  0a)

-dcmm
File "code.ml", line 14, characters 10-14:
Warning Y: unused variable list.
File "code.ml", line 26, characters 10-14:
Warning Y: unused variable list.
(data int 0 global "camlCode" "camlCode": skip 0)
(data
 int 3319
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__f0_58")
(data
 int 2048
 "camlCode__1":
 int 3
 addr L9
 int 2048
 L9:
 int 5
 addr L10
 int 2048
 L10:
 int 7
 addr L11
 int 2048
 L11:
 int 9
 addr L12
 int 2048
 L12:
 int 11
 addr L13
 int 2048
 L13:
 int 13
 int 1)
(data
 int 2048
 "camlCode__3":
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
 addr L8
 int 2048
 L8:
 int 13
 int 1)
(function camlCode__fun_81 (a/65: addr env/83: addr)
 (store (load (+a env/83 16))
   (+ (load (load (+a env/83 16)))
     (* (+ (load (+a env/83 8)) -1) (>>s (load (+a env/83 12)) 1))))
 1a)

(function camlCode__fun_99 (a/74: addr env/101: addr)
 (store (load (+a env/101 16))
   (+ (load (load (+a env/101 16)))
     (* (+ (load (+a env/101 8)) -1) (>>s (load (+a env/101 12)) 1))))
 1a)

(function camlCode__g0_61 (z/62: addr env/80: addr)
 (let
   (sum/63 (alloc 1024 1)
    list/64
      (app "camlList__iter_102"
        (alloc 5367 "camlCode__fun_81" 3 (load (+a env/80 8)) z/62 sum/63)
        "camlCode__3" addr))
   (load sum/63)))

(function camlCode__g1_70 (z/71: addr env/98: addr)
 (let
   (sum/72 (alloc 1024 1)
    list/73
      (app "camlList__iter_102"
        (alloc 5367 "camlCode__fun_99" 3 (load (+a env/98 12)) z/71 sum/72)
        (load (+a env/98 8)) addr))
   (load sum/72)))

(function camlCode__f0_58 (x/59: addr y/60: addr)
 (let g0/61 (alloc 3319 "camlCode__g0_61" 3 y/60)
   (app "camlCode__g0_61" (+ x/59 6) g0/61 addr)))

(function camlCode__f1_67 (x/68: addr y/69: addr env/93: addr)
 (let g1/70 (alloc 4343 "camlCode__g1_70" 3 (load (+a env/93 12)) y/69)
   (app "camlCode__g1_70" (+ x/68 6) g1/70 addr)))

(function camlCode__entry ()
 (let f0/58 "camlCode__2" (app "camlCode__f0_58" 1 3 unit))
 (let
   (c1/66 "camlCode__1"
    f1/67 (alloc 4343 "caml_curry2" 5 "camlCode__f1_67" c1/66))
   (app "camlCode__f1_67" 1 3 f1/67 unit))
 1a)

(data)
-dlinear
File "code.ml", line 14, characters 10-14:
Warning Y: unused variable list.
File "code.ml", line 26, characters 10-14:
Warning Y: unused variable list.
*** Linearized code
camlCode__fun_81:
  A/10[%eax] := [env/9[%ebx] + 16]
  A/11[%edx] := [env/9[%ebx] + 12]
  I/12[%edx] := I/12[%edx] >>s 1
  A/13[%ecx] := [env/9[%ebx] + 8]
  I/14[%ecx] := I/14[%ecx] + -1
  I/15[%ecx] := I/15[%ecx] * I/12[%edx]
  A/16[%ebx] := [env/9[%ebx] + 16]
  A/17[%ebx] := [A/16[%ebx]]
  I/18[%ebx] := I/18[%ebx] + I/15[%ecx]
  [A/10[%eax]] := I/18[%ebx]
  A/19[%eax] := 1
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_99:
  A/10[%eax] := [env/9[%ebx] + 16]
  A/11[%edx] := [env/9[%ebx] + 12]
  I/12[%edx] := I/12[%edx] >>s 1
  A/13[%ecx] := [env/9[%ebx] + 8]
  I/14[%ecx] := I/14[%ecx] + -1
  I/15[%ecx] := I/15[%ecx] * I/12[%edx]
  A/16[%ebx] := [env/9[%ebx] + 16]
  A/17[%ebx] := [A/16[%ebx]]
  I/18[%ebx] := I/18[%ebx] + I/15[%ecx]
  [A/10[%eax]] := I/18[%ebx]
  A/19[%eax] := 1
  return R/0[%eax]
  
*** Linearized code
camlCode__g0_61:
  z/8[%edx] := R/0[%eax]
  {z/8[%edx]* env/9[%ebx]*}
  sum/10[%ecx] := alloc 32
  spilled-sum/16[s0] := sum/10[%ecx] (spill)
  [sum/10[%ecx] + -4] := 1024
  [sum/10[%ecx]] := 1
  A/11[%eax] := sum/10[%ecx] + 8
  [A/11[%eax] + -4] := 5367
  [A/11[%eax]] := "camlCode__fun_81"
  [A/11[%eax] + 4] := 3
  A/12[%ebx] := [env/9[%ebx] + 8]
  [A/11[%eax] + 8] := A/12[%ebx]
  [A/11[%eax] + 12] := z/8[%edx]
  [A/11[%eax] + 16] := sum/10[%ecx]
  A/13[%ebx] := "camlCode__3"
  {spilled-sum/16[s0]*}
  R/0[%eax] := call "camlList__iter_102" R/0[%eax] R/1[%ebx]
  sum/17[%eax] := spilled-sum/16[s0] (reload)
  A/15[%eax] := [sum/17[%eax]]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__g1_70:
  z/8[%esi] := R/0[%eax]
  {z/8[%esi]* env/9[%ebx]*}
  sum/10[%edx] := alloc 32
  spilled-sum/16[s0] := sum/10[%edx] (spill)
  [sum/10[%edx] + -4] := 1024
  [sum/10[%edx]] := 1
  A/11[%eax] := sum/10[%edx] + 8
  [A/11[%eax] + -4] := 5367
  [A/11[%eax]] := "camlCode__fun_99"
  [A/11[%eax] + 4] := 3
  A/12[%ecx] := [env/9[%ebx] + 12]
  [A/11[%eax] + 8] := A/12[%ecx]
  [A/11[%eax] + 12] := z/8[%esi]
  [A/11[%eax] + 16] := sum/10[%edx]
  A/13[%ebx] := [env/9[%ebx] + 8]
  {spilled-sum/16[s0]*}
  R/0[%eax] := call "camlList__iter_102" R/0[%eax] R/1[%ebx]
  sum/17[%eax] := spilled-sum/16[s0] (reload)
  A/15[%eax] := [sum/17[%eax]]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__f0_58:
  x/8[%edx] := R/0[%eax]
  y/9[%ecx] := R/1[%ebx]
  {x/8[%edx]* y/9[%ecx]*}
  g0/10[%ebx] := alloc 16
  [g0/10[%ebx] + -4] := 3319
  [g0/10[%ebx]] := "camlCode__g0_61"
  [g0/10[%ebx] + 4] := 3
  [g0/10[%ebx] + 8] := y/9[%ecx]
  I/11[%eax] := x/8[%edx]
  I/11[%eax] := I/11[%eax] + 6
  tailcall "camlCode__g0_61" R/0[%eax] R/1[%ebx]
  
*** Linearized code
camlCode__f1_67:
  x/8[%edx] := R/0[%eax]
  y/9[%esi] := R/1[%ebx]
  {x/8[%edx]* y/9[%esi]* env/10[%ecx]*}
  g1/11[%ebx] := alloc 20
  [g1/11[%ebx] + -4] := 4343
  [g1/11[%ebx]] := "camlCode__g1_70"
  [g1/11[%ebx] + 4] := 3
  A/12[%eax] := [env/10[%ecx] + 12]
  [g1/11[%ebx] + 8] := A/12[%eax]
  [g1/11[%ebx] + 12] := y/9[%esi]
  I/13[%eax] := x/8[%edx]
  I/13[%eax] := I/13[%eax] + 6
  tailcall "camlCode__g1_70" R/0[%eax] R/1[%ebx]
  
*** Linearized code
camlCode__entry:
  f0/8[%eax] := "camlCode__2"
  I/9[%ebx] := 3
  I/10[%eax] := 1
  {}
  call "camlCode__f0_58" R/0[%eax] R/1[%ebx]
  c1/11[%ebx] := "camlCode__1"
  {c1/11[%ebx]*}
  f1/12[%ecx] := alloc 20
  [f1/12[%ecx] + -4] := 4343
  [f1/12[%ecx]] := "caml_curry2"
  [f1/12[%ecx] + 4] := 5
  [f1/12[%ecx] + 8] := "camlCode__f1_67"
  [f1/12[%ecx] + 12] := c1/11[%ebx]
  I/13[%ebx] := 3
  I/14[%eax] := 1
  {}
  call "camlCode__f1_67" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/15[%eax] := 1
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
	.long	0
	.globl	camlCode
camlCode:
	.data
	.long	3319
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__f0_58
	.data
	.long	2048
camlCode__1:
	.long	3
	.long	.L100009
	.long	2048
.L100009:
	.long	5
	.long	.L100010
	.long	2048
.L100010:
	.long	7
	.long	.L100011
	.long	2048
.L100011:
	.long	9
	.long	.L100012
	.long	2048
.L100012:
	.long	11
	.long	.L100013
	.long	2048
.L100013:
	.long	13
	.long	1
	.data
	.long	2048
camlCode__3:
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
	.long	.L100008
	.long	2048
.L100008:
	.long	13
	.long	1
	.text
	.align	16
	.globl	camlCode__fun_81
camlCode__fun_81:
.L100:
	movl	16(%ebx), %eax
	movl	12(%ebx), %edx
	sarl	$1, %edx
	movl	8(%ebx), %ecx
	decl	%ecx
	imull	%edx, %ecx
	movl	16(%ebx), %ebx
	movl	(%ebx), %ebx
	addl	%ecx, %ebx
	movl	%ebx, (%eax)
	movl	$1, %eax
	ret
	.type	camlCode__fun_81,@function
	.size	camlCode__fun_81,.-camlCode__fun_81
	.text
	.align	16
	.globl	camlCode__fun_99
camlCode__fun_99:
.L101:
	movl	16(%ebx), %eax
	movl	12(%ebx), %edx
	sarl	$1, %edx
	movl	8(%ebx), %ecx
	decl	%ecx
	imull	%edx, %ecx
	movl	16(%ebx), %ebx
	movl	(%ebx), %ebx
	addl	%ecx, %ebx
	movl	%ebx, (%eax)
	movl	$1, %eax
	ret
	.type	camlCode__fun_99,@function
	.size	camlCode__fun_99,.-camlCode__fun_99
	.text
	.align	16
	.globl	camlCode__g0_61
camlCode__g0_61:
	subl	$4, %esp
.L102:
	movl	%eax, %edx
.L103:	movl	caml_young_ptr, %eax
	subl	$32, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L104
	leal	4(%eax), %ecx
	movl	%ecx, 0(%esp)
	movl	$1024, -4(%ecx)
	movl	$1, (%ecx)
	leal	8(%ecx), %eax
	movl	$5367, -4(%eax)
	movl	$camlCode__fun_81, (%eax)
	movl	$3, 4(%eax)
	movl	8(%ebx), %ebx
	movl	%ebx, 8(%eax)
	movl	%edx, 12(%eax)
	movl	%ecx, 16(%eax)
	movl	$camlCode__3, %ebx
	call	camlList__iter_102
.L106:
	movl	0(%esp), %eax
	movl	(%eax), %eax
	addl	$4, %esp
	ret
.L104:	call	caml_call_gc
.L105:	jmp	.L103
	.type	camlCode__g0_61,@function
	.size	camlCode__g0_61,.-camlCode__g0_61
	.text
	.align	16
	.globl	camlCode__g1_70
camlCode__g1_70:
	subl	$4, %esp
.L107:
	movl	%eax, %esi
.L108:	movl	caml_young_ptr, %eax
	subl	$32, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L109
	leal	4(%eax), %edx
	movl	%edx, 0(%esp)
	movl	$1024, -4(%edx)
	movl	$1, (%edx)
	leal	8(%edx), %eax
	movl	$5367, -4(%eax)
	movl	$camlCode__fun_99, (%eax)
	movl	$3, 4(%eax)
	movl	12(%ebx), %ecx
	movl	%ecx, 8(%eax)
	movl	%esi, 12(%eax)
	movl	%edx, 16(%eax)
	movl	8(%ebx), %ebx
	call	camlList__iter_102
.L111:
	movl	0(%esp), %eax
	movl	(%eax), %eax
	addl	$4, %esp
	ret
.L109:	call	caml_call_gc
.L110:	jmp	.L108
	.type	camlCode__g1_70,@function
	.size	camlCode__g1_70,.-camlCode__g1_70
	.text
	.align	16
	.globl	camlCode__f0_58
camlCode__f0_58:
.L112:
	movl	%eax, %edx
	movl	%ebx, %ecx
.L113:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L114
	leal	4(%eax), %ebx
	movl	$3319, -4(%ebx)
	movl	$camlCode__g0_61, (%ebx)
	movl	$3, 4(%ebx)
	movl	%ecx, 8(%ebx)
	movl	%edx, %eax
	addl	$6, %eax
	jmp	camlCode__g0_61
.L114:	call	caml_call_gc
.L115:	jmp	.L113
	.type	camlCode__f0_58,@function
	.size	camlCode__f0_58,.-camlCode__f0_58
	.text
	.align	16
	.globl	camlCode__f1_67
camlCode__f1_67:
.L116:
	movl	%eax, %edx
	movl	%ebx, %esi
.L117:	movl	caml_young_ptr, %eax
	subl	$20, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L118
	leal	4(%eax), %ebx
	movl	$4343, -4(%ebx)
	movl	$camlCode__g1_70, (%ebx)
	movl	$3, 4(%ebx)
	movl	12(%ecx), %eax
	movl	%eax, 8(%ebx)
	movl	%esi, 12(%ebx)
	movl	%edx, %eax
	addl	$6, %eax
	jmp	camlCode__g1_70
.L118:	call	caml_call_gc
.L119:	jmp	.L117
	.type	camlCode__f1_67,@function
	.size	camlCode__f1_67,.-camlCode__f1_67
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L120:
	movl	$camlCode__2, %eax
	movl	$3, %ebx
	movl	$1, %eax
	call	camlCode__f0_58
.L121:
	movl	$camlCode__1, %ebx
	movl	$20, %eax
	call	caml_allocN
.L122:
	leal	4(%eax), %ecx
	movl	$4343, -4(%ecx)
	movl	$caml_curry2, (%ecx)
	movl	$5, 4(%ecx)
	movl	$camlCode__f1_67, 8(%ecx)
	movl	%ebx, 12(%ecx)
	movl	$3, %ebx
	movl	$1, %eax
	call	camlCode__f1_67
.L123:
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
	.long	9
	.long	.L123
	.word	4
	.word	0
	.align	4
	.long	.L122
	.word	4
	.word	1
	.word	3
	.align	4
	.long	.L121
	.word	4
	.word	0
	.align	4
	.long	.L119
	.word	4
	.word	3
	.word	5
	.word	9
	.word	7
	.align	4
	.long	.L115
	.word	4
	.word	2
	.word	5
	.word	7
	.align	4
	.long	.L111
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L110
	.word	8
	.word	2
	.word	3
	.word	9
	.align	4
	.long	.L106
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L105
	.word	8
	.word	2
	.word	3
	.word	7
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

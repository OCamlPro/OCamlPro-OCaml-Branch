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
    (fun_a/1030
       (function f/1032 list/1033
         (if list/1033
           (let (tail/1035 (field 1 list/1033) x/1034 (field 0 list/1033))
             (+ (apply f/1032 x/1034) (apply fun_b/1031 f/1032 tail/1035)))
           0))
      fun_b/1031
        (function g/1036 list/1037
          (if list/1037
            (let (tail/1039 (field 1 list/1037) x/1038 (field 0 list/1037))
              (apply fun_a/1030 g/1036 tail/1039))
            0)))
    (seq (setfield_imm 0 (global Code!) fun_a/1030)
      (setfield_imm 1 (global Code!) fun_b/1031)))
  (apply (field 0 (global Code!)) (function x/1040 (+ x/1040 1))
    [0: 1 [0: 2 [0: 3 [0: 4 0a]]]])
  0a)
-dlambda
(seq
  (letrec
    (fun_a/1030
       (function f/1032 list/1033
         (if list/1033
           (+ (apply f/1032 (field 0 list/1033))
             (apply fun_b/1031 f/1032 (field 1 list/1033)))
           0))
      fun_b/1031
        (function g/1036 list/1037
          (if list/1037 (apply fun_a/1030 g/1036 (field 1 list/1037)) 0)))
    (seq (setfield_imm 0 (global Code!) fun_a/1030)
      (setfield_imm 1 (global Code!) fun_b/1031)))
  (apply (field 0 (global Code!)) (function x/1040 (+ x/1040 1))
    [0: 1 [0: 2 [0: 3 [0: 4 0a]]]])
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (letrec
    (fun_a/1030
       (function f/1032 list/1033
         (if list/1033
           (+ (apply f/1032 (field 0 list/1033))
             (apply fun_b/1031 f/1032 (field 1 list/1033)))
           0))
      fun_b/1031
        (function g/1036 list/1037
          (if list/1037 (apply fun_a/1030 g/1036 (field 1 list/1037)) 0)))
    (seq (setfield_imm 0 (global Code!) fun_a/1030)
      (setfield_imm 1 (global Code!) fun_b/1031)))
  (apply (field 0 (global Code!)) (function x/1040 (+ x/1040 1))
    [0: 1 [0: 2 [0: 3 [0: 4 0a]]]])
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let
    (clos/1049
       (closure (camlCode__fun_a_1030(2)  f/1032 list/1033 env/1045
                  (if list/1033
                    (+ (apply f/1032 (field 0 list/1033))
                      (camlCode__fun_b_1031  f/1032 (field 1 list/1033)
                        (offset[4] env/1045)))
                    0))(camlCode__fun_b_1031(2)  g/1036 list/1037 env/1046
                         (if list/1037
                           (camlCode__fun_a_1030  g/1036 (field 1 list/1037)
                             (offset[-4] env/1046))
                           0)) {7} ))
    (seq (setfield_imm 0 (global camlCode!) clos/1049)
      (setfield_imm 1 (global camlCode!) (offset[4] clos/1049))))
  (let
    (env/1052 (field 0 (global camlCode!))
     f/1053 (closure (camlCode__fun_1050(1)  x/1040 (+ x/1040 1)) {2} )
     clos_env/1056
       (closure (camlCode__fun_a_1054(2)  f/1032 list/1033 env/1045
                  (if list/1033
                    (+ (apply f/1032 (field 0 list/1033))
                      (camlCode__fun_b_1055  f/1032 (field 1 list/1033)
                        (offset[4] env/1045)))
                    0))(camlCode__fun_b_1055(2)  g/1036 list/1037 env/1046
                         (if list/1037
                           (camlCode__fun_a_1054  g/1036 (field 1 list/1037)
                             (offset[-4] env/1046))
                           0)) {0} ))
    (camlCode__fun_a_1054  f/1053 [0: 1 [0: 2 [0: 3 [0: 4 0a]]]] env/1052))
  0a)
*** After TonClosure.optimize:
(let
  (clos/1049
     (closure (camlCode__fun_a_1030(2)  f/1032 list/1033 env/1045
                (if list/1033
                  (+ (apply f/1032 (field 0 list/1033))
                    (camlCode__fun_b_1031  f/1032 (field 1 list/1033)
                      (offset[4] env/1045)))
                  0))(camlCode__fun_b_1031(2)  g/1036 list/1037 env/1046
                       (if list/1037
                         (camlCode__fun_a_1030  g/1036 (field 1 list/1037)
                           (offset[-4] env/1046))
                         0)) {7} ))
  (seq
    (seq (setfield_imm 0 (global camlCode!) clos/1049)
      (setfield_imm 1 (global camlCode!) (offset[4] clos/1049)))
    (let
      (env/1052 (field 0 (global camlCode!))
       f/1053 (closure (camlCode__fun_1050(1)  x/1040 (+ x/1040 1)) {2} ))
      (seq
        (closure (camlCode__fun_a_1054(2)  f/1032 list/1033 env/1045
                   (if list/1033
                     (+ (apply f/1032 (field 0 list/1033))
                       (camlCode__fun_b_1055  f/1032 (field 1 list/1033)
                         (offset[4] env/1045)))
                     0))(camlCode__fun_b_1055(2)  g/1036 list/1037 env/1046
                          (if list/1037
                            (camlCode__fun_a_1054  g/1036 (field 1 list/1037)
                              (offset[-4] env/1046))
                            0)) {0} )
        (camlCode__fun_a_1054  f/1053 [0: 1 [0: 2 [0: 3 [0: 4 0a]]]]
          env/1052)
        0a))))

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 8)
(data
 int 7415
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__fun_a_1054"
 int 4345
 addr "caml_curry2"
 int 5
 addr "camlCode__fun_b_1055")
(data int 2295 "camlCode__3": addr "camlCode__fun_1050" int 3)
(data
 int 7415
 "camlCode__4":
 addr "caml_curry2"
 int 5
 addr "camlCode__fun_a_1030"
 int 4345
 addr "caml_curry2"
 int 5
 addr "camlCode__fun_b_1031")
(data
 global "camlCode__1"
 int 2048
 "camlCode__1":
 int 3
 addr L5
 int 2048
 L5:
 int 5
 addr L6
 int 2048
 L6:
 int 7
 addr L7
 int 2048
 L7:
 int 9
 int 1)
(function camlCode__fun_b_1031 (g/1036: addr list/1037: addr env/1046: addr)
 (if (!= list/1037 1)
   (app "camlCode__fun_a_1030" g/1036 (load (+a list/1037 4))
     (+a env/1046 -16) addr)
   1))

(function camlCode__fun_a_1030 (f/1032: addr list/1033: addr env/1045: addr)
 (if (!= list/1033 1)
   (+
     (+ (app (load f/1032) (load list/1033) f/1032 addr)
       (app "camlCode__fun_b_1031" f/1032 (load (+a list/1033 4))
         (+a env/1045 16) addr))
     -1)
   1))

(function camlCode__fun_1050 (x/1040: addr) (+ x/1040 2))

(function camlCode__fun_b_1055 (g/1036: addr list/1037: addr env/1046: addr)
 (if (!= list/1037 1)
   (app "camlCode__fun_a_1054" g/1036 (load (+a list/1037 4))
     (+a env/1046 -16) addr)
   1))

(function camlCode__fun_a_1054 (f/1032: addr list/1033: addr env/1045: addr)
 (if (!= list/1033 1)
   (+
     (+ (app (load f/1032) (load list/1033) f/1032 addr)
       (app "camlCode__fun_b_1055" f/1032 (load (+a list/1033 4))
         (+a env/1045 16) addr))
     -1)
   1))

(function camlCode__entry ()
 (let clos/1049 "camlCode__4" (store "camlCode" clos/1049)
   (store (+a "camlCode" 4) (+a clos/1049 16))
   (let (env/1052 (load "camlCode") f/1053 "camlCode__3") "camlCode__2" 
     [] (app "camlCode__fun_a_1054" f/1053 "camlCode__1" env/1052 unit) 1a)))

(data)
-dlinear
Before simplify
camlCode__fun_b_1031:
                  if list/9[%ebx] ==s 1 goto L100
                  A/12[%ecx] := A/12[%ecx] + -16
                  A/13[%ebx] := [list/9[%ebx] + 4]
                  tailcall "camlCode__fun_a_1030" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  L100 [0]:
                  I/11[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_b_1031:
  if list/9[%ebx] ==s 1 goto L100
  A/12[%ecx] := A/12[%ecx] + -16
  A/13[%ebx] := [list/9[%ebx] + 4]
  tailcall "camlCode__fun_a_1030" R/0[%eax] R/1[%ebx] R/2[%ecx]
  L100 [4]:
  I/11[%eax] := 1
  return R/0[%eax]
  
Before simplify
camlCode__fun_a_1030:
                  if list/9[%ebx] ==s 1 goto L102
                  spilled-list/22[s0] := list/9[%ebx] (spill)
                  spilled-f/21[s1] := f/8[%eax] (spill)
                  A/12[%ecx] := A/12[%ecx] + 16
                  A/13[%ebx] := [list/9[%ebx] + 4]
                  {spilled-f/21[s1]* spilled-list/22[s0]*}
                  R/0[%eax] := call "camlCode__fun_b_1031" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  A/20[s2] := A/14[%eax] (spill)
                  list/23[%eax] := spilled-list/22[s0] (reload)
                  A/15[%eax] := [list/23[%eax]]
                  f/24[%ebx] := spilled-f/21[s1] (reload)
                  A/16[%ecx] := [f/24[%ebx]]
                  {A/20[s2]*}
                  R/0[%eax] := call A/16[%ecx] R/0[%eax] R/1[%ebx]
                  A/25[%ebx] := A/20[s2] (reload)
                  I/18[%eax] := I/18[%eax] + A/25[%ebx]
                  I/19[%eax] := I/19[%eax] + -1
                  reload retaddr
                  return R/0[%eax]
                  L102 [0]:
                  I/11[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_a_1030:
  if list/9[%ebx] ==s 1 goto L102
  spilled-list/22[s0] := list/9[%ebx] (spill)
  spilled-f/21[s1] := f/8[%eax] (spill)
  A/12[%ecx] := A/12[%ecx] + 16
  A/13[%ebx] := [list/9[%ebx] + 4]
  {spilled-f/21[s1]* spilled-list/22[s0]*}
  R/0[%eax] := call "camlCode__fun_b_1031" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/20[s2] := A/14[%eax] (spill)
  list/23[%eax] := spilled-list/22[s0] (reload)
  A/15[%eax] := [list/23[%eax]]
  f/24[%ebx] := spilled-f/21[s1] (reload)
  A/16[%ecx] := [f/24[%ebx]]
  {A/20[s2]*}
  R/0[%eax] := call A/16[%ecx] R/0[%eax] R/1[%ebx]
  A/25[%ebx] := A/20[s2] (reload)
  I/18[%eax] := I/18[%eax] + A/25[%ebx]
  I/19[%eax] := I/19[%eax] + -1
  reload retaddr
  return R/0[%eax]
  L102 [2]:
  I/11[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__fun_1050:
                  I/9[%eax] := I/9[%eax] + 2
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_1050:
  I/9[%eax] := I/9[%eax] + 2
  return R/0[%eax]
  
Before simplify
camlCode__fun_b_1055:
                  if list/9[%ebx] ==s 1 goto L107
                  A/12[%ecx] := A/12[%ecx] + -16
                  A/13[%ebx] := [list/9[%ebx] + 4]
                  tailcall "camlCode__fun_a_1054" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  L107 [0]:
                  I/11[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_b_1055:
  if list/9[%ebx] ==s 1 goto L107
  A/12[%ecx] := A/12[%ecx] + -16
  A/13[%ebx] := [list/9[%ebx] + 4]
  tailcall "camlCode__fun_a_1054" R/0[%eax] R/1[%ebx] R/2[%ecx]
  L107 [4]:
  I/11[%eax] := 1
  return R/0[%eax]
  
Before simplify
camlCode__fun_a_1054:
                  if list/9[%ebx] ==s 1 goto L109
                  spilled-list/22[s0] := list/9[%ebx] (spill)
                  spilled-f/21[s1] := f/8[%eax] (spill)
                  A/12[%ecx] := A/12[%ecx] + 16
                  A/13[%ebx] := [list/9[%ebx] + 4]
                  {spilled-f/21[s1]* spilled-list/22[s0]*}
                  R/0[%eax] := call "camlCode__fun_b_1055" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  A/20[s2] := A/14[%eax] (spill)
                  list/23[%eax] := spilled-list/22[s0] (reload)
                  A/15[%eax] := [list/23[%eax]]
                  f/24[%ebx] := spilled-f/21[s1] (reload)
                  A/16[%ecx] := [f/24[%ebx]]
                  {A/20[s2]*}
                  R/0[%eax] := call A/16[%ecx] R/0[%eax] R/1[%ebx]
                  A/25[%ebx] := A/20[s2] (reload)
                  I/18[%eax] := I/18[%eax] + A/25[%ebx]
                  I/19[%eax] := I/19[%eax] + -1
                  reload retaddr
                  return R/0[%eax]
                  L109 [0]:
                  I/11[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_a_1054:
  if list/9[%ebx] ==s 1 goto L109
  spilled-list/22[s0] := list/9[%ebx] (spill)
  spilled-f/21[s1] := f/8[%eax] (spill)
  A/12[%ecx] := A/12[%ecx] + 16
  A/13[%ebx] := [list/9[%ebx] + 4]
  {spilled-f/21[s1]* spilled-list/22[s0]*}
  R/0[%eax] := call "camlCode__fun_b_1055" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/20[s2] := A/14[%eax] (spill)
  list/23[%eax] := spilled-list/22[s0] (reload)
  A/15[%eax] := [list/23[%eax]]
  f/24[%ebx] := spilled-f/21[s1] (reload)
  A/16[%ecx] := [f/24[%ebx]]
  {A/20[s2]*}
  R/0[%eax] := call A/16[%ecx] R/0[%eax] R/1[%ebx]
  A/25[%ebx] := A/20[s2] (reload)
  I/18[%eax] := I/18[%eax] + A/25[%ebx]
  I/19[%eax] := I/19[%eax] + -1
  reload retaddr
  return R/0[%eax]
  L109 [2]:
  I/11[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  clos/8[%eax] := "camlCode__4"
                  ["camlCode"] := clos/8[%eax]
                  A/9[%eax] := A/9[%eax] + 16
                  ["camlCode" + 4] := A/9[%eax]
                  env/10[%ecx] := ["camlCode"]
                  f/11[%eax] := "camlCode__3"
                  A/12[%ebx] := "camlCode__2"
                  A/13[%ebx] := "camlCode__1"
                  {}
                  call "camlCode__fun_a_1054" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  A/14[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  clos/8[%eax] := "camlCode__4"
  ["camlCode"] := clos/8[%eax]
  A/9[%eax] := A/9[%eax] + 16
  ["camlCode" + 4] := A/9[%eax]
  env/10[%ecx] := ["camlCode"]
  f/11[%eax] := "camlCode__3"
  A/12[%ebx] := "camlCode__2"
  A/13[%ebx] := "camlCode__1"
  {}
  call "camlCode__fun_a_1054" R/0[%eax] R/1[%ebx] R/2[%ecx]
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
	.long	2048
	.globl	camlCode
camlCode:
	.space	8
	.data
	.long	7415
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__fun_a_1054
	.long	4345
	.long	caml_curry2
	.long	5
	.long	camlCode__fun_b_1055
	.data
	.long	2295
camlCode__3:
	.long	camlCode__fun_1050
	.long	3
	.data
	.long	7415
camlCode__4:
	.long	caml_curry2
	.long	5
	.long	camlCode__fun_a_1030
	.long	4345
	.long	caml_curry2
	.long	5
	.long	camlCode__fun_b_1031
	.data
	.globl	camlCode__1
	.long	2048
camlCode__1:
	.long	3
	.long	.L100005
	.long	2048
.L100005:
	.long	5
	.long	.L100006
	.long	2048
.L100006:
	.long	7
	.long	.L100007
	.long	2048
.L100007:
	.long	9
	.long	1
	.text
	.align	16
	.globl	camlCode__fun_b_1031
camlCode__fun_b_1031:
.L101:
	cmpl	$1, %ebx
	je	.L100
	addl	$-16, %ecx
	movl	4(%ebx), %ebx
	jmp	camlCode__fun_a_1030
	.align	16
.L100:
	movl	$1, %eax
	ret
	.type	camlCode__fun_b_1031,@function
	.size	camlCode__fun_b_1031,.-camlCode__fun_b_1031
	.text
	.align	16
	.globl	camlCode__fun_a_1030
camlCode__fun_a_1030:
	subl	$12, %esp
.L103:
	cmpl	$1, %ebx
	je	.L102
	movl	%ebx, 0(%esp)
	movl	%eax, 4(%esp)
	addl	$16, %ecx
	movl	4(%ebx), %ebx
	call	camlCode__fun_b_1031
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
	.type	camlCode__fun_a_1030,@function
	.size	camlCode__fun_a_1030,.-camlCode__fun_a_1030
	.text
	.align	16
	.globl	camlCode__fun_1050
camlCode__fun_1050:
.L106:
	addl	$2, %eax
	ret
	.type	camlCode__fun_1050,@function
	.size	camlCode__fun_1050,.-camlCode__fun_1050
	.text
	.align	16
	.globl	camlCode__fun_b_1055
camlCode__fun_b_1055:
.L108:
	cmpl	$1, %ebx
	je	.L107
	addl	$-16, %ecx
	movl	4(%ebx), %ebx
	jmp	camlCode__fun_a_1054
	.align	16
.L107:
	movl	$1, %eax
	ret
	.type	camlCode__fun_b_1055,@function
	.size	camlCode__fun_b_1055,.-camlCode__fun_b_1055
	.text
	.align	16
	.globl	camlCode__fun_a_1054
camlCode__fun_a_1054:
	subl	$12, %esp
.L110:
	cmpl	$1, %ebx
	je	.L109
	movl	%ebx, 0(%esp)
	movl	%eax, 4(%esp)
	addl	$16, %ecx
	movl	4(%ebx), %ebx
	call	camlCode__fun_b_1055
.L111:
	movl	%eax, 8(%esp)
	movl	0(%esp), %eax
	movl	(%eax), %eax
	movl	4(%esp), %ebx
	movl	(%ebx), %ecx
	call	*%ecx
.L112:
	movl	8(%esp), %ebx
	addl	%ebx, %eax
	decl	%eax
	addl	$12, %esp
	ret
	.align	16
.L109:
	movl	$1, %eax
	addl	$12, %esp
	ret
	.type	camlCode__fun_a_1054,@function
	.size	camlCode__fun_a_1054,.-camlCode__fun_a_1054
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L113:
	movl	$camlCode__4, %eax
	movl	%eax, camlCode
	addl	$16, %eax
	movl	%eax, camlCode + 4
	movl	camlCode, %ecx
	movl	$camlCode__3, %eax
	movl	$camlCode__2, %ebx
	movl	$camlCode__1, %ebx
	call	camlCode__fun_a_1054
.L114:
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
	.long	5
	.long	.L114
	.word	4
	.word	0
	.align	4
	.long	.L112
	.word	16
	.word	1
	.word	8
	.align	4
	.long	.L111
	.word	16
	.word	2
	.word	0
	.word	4
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

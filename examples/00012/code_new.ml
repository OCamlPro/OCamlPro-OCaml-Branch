(* This example shows that switches in pattern-matching are not
optimized aggressively. In particular, when a switch is generated (f3
and f4), the benefits of constant propagation are lost because neither
the 'switch' nor the 'isout' constructs are simplified.
*)

let f1 x =
  match 3 with
    | 3 -> x+3
    | _ -> x

let f2 x =
  match 3 with
    | 2 -> x+2
    | 3 -> x+3
    | _ -> x

let f3 x =
  match 3 with
      1 -> x+1
    | 2 -> x+2
    | 3 -> x+3
    | _ -> x

let f4 x =
  match 4 with
      1 -> x+1
    | 2 -> x+2
    | 3 -> x+3
    | _ -> x
(*
-drawlambda
(seq
  (let
    (f1/1030
       (function x/1031
         (let (match/1042 3)
           (catch (if (!= match/1042 3) (exit 1) (+ x/1031 3)) with (1)
             x/1031))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1032
       (function x/1033
         (let (match/1043 3)
           (catch
             (if (!= match/1043 2)
               (if (!= match/1043 3) (exit 3) (+ x/1033 3)) (+ x/1033 2))
            with (3) x/1033))))
    (setfield_imm 1 (global Code!) f2/1032))
  (let
    (f3/1034
       (function x/1035
         (let (match/1044 3)
           (catch
             (let (switcher/1045 (-1+ match/1044))
               (if (isout 2 switcher/1045) (exit 5)
                 (switch* switcher/1045
                  case int 0: (+ x/1035 1)
                  case int 1: (+ x/1035 2)
                  case int 2: (+ x/1035 3))))
            with (5) x/1035))))
    (setfield_imm 2 (global Code!) f3/1034))
  (let
    (f4/1036
       (function x/1037
         (let (match/1046 4)
           (catch
             (let (switcher/1047 (-1+ match/1046))
               (if (isout 2 switcher/1047) (exit 7)
                 (switch* switcher/1047
                  case int 0: (+ x/1037 1)
                  case int 1: (+ x/1037 2)
                  case int 2: (+ x/1037 3))))
            with (7) x/1037))))
    (setfield_imm 3 (global Code!) f4/1036))
  0a)
-dlambda
(seq
  (let
    (f1/1030
       (function x/1031
         (let (match/1042 3) (if (!= match/1042 3) x/1031 (+ x/1031 3)))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1032
       (function x/1033
         (let (match/1043 3)
           (if (!= match/1043 2) (if (!= match/1043 3) x/1033 (+ x/1033 3))
             (+ x/1033 2)))))
    (setfield_imm 1 (global Code!) f2/1032))
  (let
    (f3/1034
       (function x/1035
         (let (match/1044 3 switcher/1045 (-1+ match/1044))
           (if (isout 2 switcher/1045) x/1035
             (switch* switcher/1045
              case int 0: (+ x/1035 1)
              case int 1: (+ x/1035 2)
              case int 2: (+ x/1035 3))))))
    (setfield_imm 2 (global Code!) f3/1034))
  (let
    (f4/1036
       (function x/1037
         (let (match/1046 4 switcher/1047 (-1+ match/1046))
           (if (isout 2 switcher/1047) x/1037
             (switch* switcher/1047
              case int 0: (+ x/1037 1)
              case int 1: (+ x/1037 2)
              case int 2: (+ x/1037 3))))))
    (setfield_imm 3 (global Code!) f4/1036))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (f1/1030
       (function x/1031
         (let (match/1042 3) (if (!= match/1042 3) x/1031 (+ x/1031 3)))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1032
       (function x/1033
         (let (match/1043 3)
           (if (!= match/1043 2) (if (!= match/1043 3) x/1033 (+ x/1033 3))
             (+ x/1033 2)))))
    (setfield_imm 1 (global Code!) f2/1032))
  (let
    (f3/1034
       (function x/1035
         (let (match/1044 3 switcher/1045 (-1+ match/1044))
           (if (isout 2 switcher/1045) x/1035
             (switch* switcher/1045
              case int 0: (+ x/1035 1)
              case int 1: (+ x/1035 2)
              case int 2: (+ x/1035 3))))))
    (setfield_imm 2 (global Code!) f3/1034))
  (let
    (f4/1036
       (function x/1037
         (let (match/1046 4 switcher/1047 (-1+ match/1046))
           (if (isout 2 switcher/1047) x/1037
             (switch* switcher/1047
              case int 0: (+ x/1037 1)
              case int 1: (+ x/1037 2)
              case int 2: (+ x/1037 3))))))
    (setfield_imm 3 (global Code!) f4/1036))
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let (f1/1030 (closure (camlCode__f1_1030(1)  x/1031 (+ x/1031 3)) {2} ))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let (f2/1032 (closure (camlCode__f2_1032(1)  x/1033 (+ x/1033 3)) {2} ))
    (setfield_imm 1 (global camlCode!) f2/1032))
  (let
    (f3/1034
       (closure (camlCode__f3_1034(1)  x/1035
                  (if (isout 2 2) x/1035
                    (switch* 2
                     case int 0: (+ x/1035 1)
                     case int 1: (+ x/1035 2)
                     case int 2: (+ x/1035 3)blocks...
))) {2} )) (setfield_imm 2 (global camlCode!) f3/1034))
(let
  (f4/1036
     (closure (camlCode__f4_1036(1)  x/1037
                (if (isout 2 3) x/1037
                  (switch* 3
                   case int 0: (+ x/1037 1)
                   case int 1: (+ x/1037 2)
                   case int 2: (+ x/1037 3)blocks...
))) {2} )) (setfield_imm 3 (global camlCode!) f4/1036))
0a)
*** After TonClosure.optimize:
(let (f1/1030 (closure (camlCode__f1_1030(1)  x/1031 (+ x/1031 3)) {2} ))
  (seq (setfield_imm 0 (global camlCode!) f1/1030)
    (let (f2/1032 (closure (camlCode__f2_1032(1)  x/1033 (+ x/1033 3)) {2} ))
      (seq (setfield_imm 1 (global camlCode!) f2/1032)
        (let
          (f3/1034
             (closure (camlCode__f3_1034(1)  x/1035
                        (if (isout 2 2) x/1035
                          (switch* 2
                           case int 0: (+ x/1035 1)
                           case int 1: (+ x/1035 2)
                           case int 2: (+ x/1035 3)blocks...
))) {2} ))
(seq (setfield_imm 2 (global camlCode!) f3/1034)
  (let
    (f4/1036
       (closure (camlCode__f4_1036(1)  x/1037
                  (if (isout 2 3) x/1037
                    (switch* 3
                     case int 0: (+ x/1037 1)
                     case int 1: (+ x/1037 2)
                     case int 2: (+ x/1037 3)blocks...
))) {2} ))
(seq (setfield_imm 3 (global camlCode!) f4/1036) 0a))))))))

-dcmm
(data int 4096 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__1": addr "camlCode__f4_1036" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f3_1034" int 3)
(data int 2295 "camlCode__3": addr "camlCode__f2_1032" int 3)
(data int 2295 "camlCode__4": addr "camlCode__f1_1030" int 3)
(function camlCode__f1_1030 (x/1031: addr) (+ x/1031 6))

(function camlCode__f2_1032 (x/1033: addr) (+ x/1033 6))

(function camlCode__f3_1034 (x/1035: addr)
 (if (<a 5 5) x/1035
   (switch 2 
   case 0: (+ x/1035 2)
   case 1: (+ x/1035 4)
   case 2: (+ x/1035 6))))

(function camlCode__f4_1036 (x/1037: addr)
 (if (<a 5 7) x/1037
   (switch 3 
   case 0: (+ x/1037 2)
   case 1: (+ x/1037 4)
   case 2: (+ x/1037 6))))

(function camlCode__entry ()
 (let f1/1030 "camlCode__4" (store "camlCode" f1/1030)
   (let f2/1032 "camlCode__3" (store (+a "camlCode" 4) f2/1032)
     (let f3/1034 "camlCode__2" (store (+a "camlCode" 8) f3/1034)
       (let f4/1036 "camlCode__1" (store (+a "camlCode" 12) f4/1036) 1a)))))

(data)
-dlinear
Before simplify
camlCode__f1_1030:
                  I/9[%eax] := I/9[%eax] + 6
                  return R/0[%eax]
                  *** Linearized code
camlCode__f1_1030:
  I/9[%eax] := I/9[%eax] + 6
  return R/0[%eax]
  
Before simplify
camlCode__f2_1032:
                  I/9[%eax] := I/9[%eax] + 6
                  return R/0[%eax]
                  *** Linearized code
camlCode__f2_1032:
  I/9[%eax] := I/9[%eax] + 6
  return R/0[%eax]
  
Before simplify
camlCode__f3_1034:
                  I/9[%ebx] := 5
                  if I/9[%ebx] >=u 5 goto L105
                  return R/0[%eax]
                  L105 [0]:
                  I/10[%ebx] := 2
                  switch3 I/10[%ebx]
                  case 1: goto L103
                  case 2: goto L102
                  endswitch
                  L104 [0]:
                  I/11[%eax] := I/11[%eax] + 2
                  return R/0[%eax]
                  L103 [0]:
                  I/12[%eax] := I/12[%eax] + 4
                  return R/0[%eax]
                  L102 [0]:
                  I/13[%eax] := I/13[%eax] + 6
                  return R/0[%eax]
                  *** Linearized code
camlCode__f3_1034:
  I/9[%ebx] := 5
  if I/9[%ebx] >=u 5 goto L105
  return R/0[%eax]
  L105 [2]:
  I/10[%ebx] := 2
  switch3 I/10[%ebx]
  case 1: goto L103
  case 2: goto L102
  endswitch
  L104 [2]:
  I/11[%eax] := I/11[%eax] + 2
  return R/0[%eax]
  L103 [2]:
  I/12[%eax] := I/12[%eax] + 4
  return R/0[%eax]
  L102 [2]:
  I/13[%eax] := I/13[%eax] + 6
  return R/0[%eax]
  
Before simplify
camlCode__f4_1036:
                  I/9[%ebx] := 5
                  if I/9[%ebx] >=u 7 goto L110
                  return R/0[%eax]
                  L110 [0]:
                  I/10[%ebx] := 3
                  switch3 I/10[%ebx]
                  case 1: goto L108
                  case 2: goto L107
                  endswitch
                  L109 [0]:
                  I/11[%eax] := I/11[%eax] + 2
                  return R/0[%eax]
                  L108 [0]:
                  I/12[%eax] := I/12[%eax] + 4
                  return R/0[%eax]
                  L107 [0]:
                  I/13[%eax] := I/13[%eax] + 6
                  return R/0[%eax]
                  *** Linearized code
camlCode__f4_1036:
  I/9[%ebx] := 5
  if I/9[%ebx] >=u 7 goto L110
  return R/0[%eax]
  L110 [2]:
  I/10[%ebx] := 3
  switch3 I/10[%ebx]
  case 1: goto L108
  case 2: goto L107
  endswitch
  L109 [2]:
  I/11[%eax] := I/11[%eax] + 2
  return R/0[%eax]
  L108 [2]:
  I/12[%eax] := I/12[%eax] + 4
  return R/0[%eax]
  L107 [2]:
  I/13[%eax] := I/13[%eax] + 6
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  f1/8[%eax] := "camlCode__4"
                  ["camlCode"] := f1/8[%eax]
                  f2/9[%eax] := "camlCode__3"
                  ["camlCode" + 4] := f2/9[%eax]
                  f3/10[%eax] := "camlCode__2"
                  ["camlCode" + 8] := f3/10[%eax]
                  f4/11[%eax] := "camlCode__1"
                  ["camlCode" + 12] := f4/11[%eax]
                  A/12[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  f1/8[%eax] := "camlCode__4"
  ["camlCode"] := f1/8[%eax]
  f2/9[%eax] := "camlCode__3"
  ["camlCode" + 4] := f2/9[%eax]
  f3/10[%eax] := "camlCode__2"
  ["camlCode" + 8] := f3/10[%eax]
  f4/11[%eax] := "camlCode__1"
  ["camlCode" + 12] := f4/11[%eax]
  A/12[%eax] := 1
  return R/0[%eax]
  
-S
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.long	4096
	.globl	camlCode
camlCode:
	.space	16
	.data
	.long	2295
camlCode__1:
	.long	camlCode__f4_1036
	.long	3
	.data
	.long	2295
camlCode__2:
	.long	camlCode__f3_1034
	.long	3
	.data
	.long	2295
camlCode__3:
	.long	camlCode__f2_1032
	.long	3
	.data
	.long	2295
camlCode__4:
	.long	camlCode__f1_1030
	.long	3
	.text
	.align	16
	.globl	camlCode__f1_1030
camlCode__f1_1030:
.L100:
	addl	$6, %eax
	ret
	.type	camlCode__f1_1030,@function
	.size	camlCode__f1_1030,.-camlCode__f1_1030
	.text
	.align	16
	.globl	camlCode__f2_1032
camlCode__f2_1032:
.L101:
	addl	$6, %eax
	ret
	.type	camlCode__f2_1032,@function
	.size	camlCode__f2_1032,.-camlCode__f2_1032
	.text
	.align	16
	.globl	camlCode__f3_1034
camlCode__f3_1034:
.L106:
	movl	$5, %ebx
	cmpl	$5, %ebx
	jae	.L105
	ret
	.align	16
.L105:
	movl	$2, %ebx
	cmpl	$1, %ebx
	je	.L103
	jg	.L102
.L104:
	addl	$2, %eax
	ret
	.align	16
.L103:
	addl	$4, %eax
	ret
	.align	16
.L102:
	addl	$6, %eax
	ret
	.type	camlCode__f3_1034,@function
	.size	camlCode__f3_1034,.-camlCode__f3_1034
	.text
	.align	16
	.globl	camlCode__f4_1036
camlCode__f4_1036:
.L111:
	movl	$5, %ebx
	cmpl	$7, %ebx
	jae	.L110
	ret
	.align	16
.L110:
	movl	$3, %ebx
	cmpl	$1, %ebx
	je	.L108
	jg	.L107
.L109:
	addl	$2, %eax
	ret
	.align	16
.L108:
	addl	$4, %eax
	ret
	.align	16
.L107:
	addl	$6, %eax
	ret
	.type	camlCode__f4_1036,@function
	.size	camlCode__f4_1036,.-camlCode__f4_1036
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L112:
	movl	$camlCode__4, %eax
	movl	%eax, camlCode
	movl	$camlCode__3, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__2, %eax
	movl	%eax, camlCode + 8
	movl	$camlCode__1, %eax
	movl	%eax, camlCode + 12
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
	.long	0

	.section .note.GNU-stack,"",%progbits
*)

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
    (f1/58
       (function x/59
         (let (match/70 3)
           (catch (if (!= match/70 3) (exit 1) (+ x/59 3)) with (1) x/59))))
    (setfield_imm 0 (global Code!) f1/58))
  (let
    (f2/60
       (function x/61
         (let (match/71 3)
           (catch
             (if (!= match/71 2) (if (!= match/71 3) (exit 3) (+ x/61 3))
               (+ x/61 2))
            with (3) x/61))))
    (setfield_imm 1 (global Code!) f2/60))
  (let
    (f3/62
       (function x/63
         (let (match/72 3)
           (catch
             (let (switcher/73 (-1+ match/72))
               (if (isout 2 switcher/73) (exit 5)
                 (switch* switcher/73
                  case int 0: (+ x/63 1)
                  case int 1: (+ x/63 2)
                  case int 2: (+ x/63 3))))
            with (5) x/63))))
    (setfield_imm 2 (global Code!) f3/62))
  (let
    (f4/64
       (function x/65
         (let (match/74 4)
           (catch
             (let (switcher/75 (-1+ match/74))
               (if (isout 2 switcher/75) (exit 7)
                 (switch* switcher/75
                  case int 0: (+ x/65 1)
                  case int 1: (+ x/65 2)
                  case int 2: (+ x/65 3))))
            with (7) x/65))))
    (setfield_imm 3 (global Code!) f4/64))
  0a)
-dlambda
(seq
  (let
    (f1/58
       (function x/59
         (let (match/70 3) (if (!= match/70 3) x/59 (+ x/59 3)))))
    (setfield_imm 0 (global Code!) f1/58))
  (let
    (f2/60
       (function x/61
         (let (match/71 3)
           (if (!= match/71 2) (if (!= match/71 3) x/61 (+ x/61 3))
             (+ x/61 2)))))
    (setfield_imm 1 (global Code!) f2/60))
  (let
    (f3/62
       (function x/63
         (let (match/72 3 switcher/73 (-1+ match/72))
           (if (isout 2 switcher/73) x/63
             (switch* switcher/73
              case int 0: (+ x/63 1)
              case int 1: (+ x/63 2)
              case int 2: (+ x/63 3))))))
    (setfield_imm 2 (global Code!) f3/62))
  (let
    (f4/64
       (function x/65
         (let (match/74 4 switcher/75 (-1+ match/74))
           (if (isout 2 switcher/75) x/65
             (switch* switcher/75
              case int 0: (+ x/65 1)
              case int 1: (+ x/65 2)
              case int 2: (+ x/65 3))))))
    (setfield_imm 3 (global Code!) f4/64))
  0a)

-dcmm
(data int 4096 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__1": addr "camlCode__f4_64" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f3_62" int 3)
(data int 2295 "camlCode__3": addr "camlCode__f2_60" int 3)
(data int 2295 "camlCode__4": addr "camlCode__f1_58" int 3)
(function camlCode__f1_58 (x/59: addr) (+ x/59 6))

(function camlCode__f2_60 (x/61: addr) (+ x/61 6))

(function camlCode__f3_62 (x/63: addr)
 (if (<a 5 5) x/63
   (switch 2 
   case 0: (+ x/63 2)
   case 1: (+ x/63 4)
   case 2: (+ x/63 6))))

(function camlCode__f4_64 (x/65: addr)
 (if (<a 5 7) x/65
   (switch 3 
   case 0: (+ x/65 2)
   case 1: (+ x/65 4)
   case 2: (+ x/65 6))))

(function camlCode__entry ()
 (let f1/58 "camlCode__4" (store "camlCode" f1/58))
 (let f2/60 "camlCode__3" (store (+a "camlCode" 4) f2/60))
 (let f3/62 "camlCode__2" (store (+a "camlCode" 8) f3/62))
 (let f4/64 "camlCode__1" (store (+a "camlCode" 12) f4/64)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__f1_58:
  I/9[%eax] := I/9[%eax] + 6
  return R/0[%eax]
  
*** Linearized code
camlCode__f2_60:
  I/9[%eax] := I/9[%eax] + 6
  return R/0[%eax]
  
*** Linearized code
camlCode__f3_62:
  I/9[%ebx] := 5
  if I/9[%ebx] >=u 5 goto L105
  return R/0[%eax]
  L105:
  I/10[%ebx] := 2
  switch3 I/10[%ebx]
  case 1: goto L103
  case 2: goto L102
  endswitch
  L104:
  I/11[%eax] := I/11[%eax] + 2
  return R/0[%eax]
  L103:
  I/12[%eax] := I/12[%eax] + 4
  return R/0[%eax]
  L102:
  I/13[%eax] := I/13[%eax] + 6
  return R/0[%eax]
  
*** Linearized code
camlCode__f4_64:
  I/9[%ebx] := 5
  if I/9[%ebx] >=u 7 goto L110
  return R/0[%eax]
  L110:
  I/10[%ebx] := 3
  switch3 I/10[%ebx]
  case 1: goto L108
  case 2: goto L107
  endswitch
  L109:
  I/11[%eax] := I/11[%eax] + 2
  return R/0[%eax]
  L108:
  I/12[%eax] := I/12[%eax] + 4
  return R/0[%eax]
  L107:
  I/13[%eax] := I/13[%eax] + 6
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
	.long	camlCode__f4_64
	.long	3
	.data
	.long	2295
camlCode__2:
	.long	camlCode__f3_62
	.long	3
	.data
	.long	2295
camlCode__3:
	.long	camlCode__f2_60
	.long	3
	.data
	.long	2295
camlCode__4:
	.long	camlCode__f1_58
	.long	3
	.text
	.align	16
	.globl	camlCode__f1_58
camlCode__f1_58:
.L100:
	addl	$6, %eax
	ret
	.type	camlCode__f1_58,@function
	.size	camlCode__f1_58,.-camlCode__f1_58
	.text
	.align	16
	.globl	camlCode__f2_60
camlCode__f2_60:
.L101:
	addl	$6, %eax
	ret
	.type	camlCode__f2_60,@function
	.size	camlCode__f2_60,.-camlCode__f2_60
	.text
	.align	16
	.globl	camlCode__f3_62
camlCode__f3_62:
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
	.type	camlCode__f3_62,@function
	.size	camlCode__f3_62,.-camlCode__f3_62
	.text
	.align	16
	.globl	camlCode__f4_64
camlCode__f4_64:
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
	.type	camlCode__f4_64,@function
	.size	camlCode__f4_64,.-camlCode__f4_64
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

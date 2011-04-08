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
lambda saved
typedtree saved
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
 After TonLambda.optimize (0 eliminations): 
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
lambda saved
typedtree saved
-dclosure
(seq
  (let (f1/1030 (closure (camlCode__f1_1030(1)  x/1031 (+ x/1031 3)) ))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let (f2/1032 (closure (camlCode__f2_1032(1)  x/1033 (+ x/1033 3)) ))
    (setfield_imm 1 (global camlCode!) f2/1032))
  (let
    (f3/1034
       (closure (camlCode__f3_1034(1)  x/1035
                 (if (isout 2 2) x/1035
                   (switch* 2
                    case int 0: (+ x/1035 1)
                    case int 1: (+ x/1035 2)
                    case int 2: (+ x/1035 3)blocks...
))) )) (setfield_imm 2 (global camlCode!) f3/1034))
(let
  (f4/1036
     (closure (camlCode__f4_1036(1)  x/1037
               (if (isout 2 3) x/1037
                 (switch* 3
                  case int 0: (+ x/1037 1)
                  case int 1: (+ x/1037 2)
                  case int 2: (+ x/1037 3)blocks...
))) )) (setfield_imm 3 (global camlCode!) f4/1036))
0a)(seq
     (let (f1/1030 (closure (camlCode__f1_1030(1)  x/1031 (+ x/1031 3)) ))
       (setfield_imm 0 (global camlCode!) f1/1030))
     (let (f2/1032 (closure (camlCode__f2_1032(1)  x/1033 (+ x/1033 3)) ))
       (setfield_imm 1 (global camlCode!) f2/1032))
     (let
       (f3/1034
          (closure (camlCode__f3_1034(1)  x/1035
                    (if (isout 2 2) x/1035
                      (switch* 2
                       case int 0: (+ x/1035 1)
                       case int 1: (+ x/1035 2)
                       case int 2: (+ x/1035 3)blocks...
))) )) (setfield_imm 2 (global camlCode!) f3/1034))
(let
  (f4/1036
     (closure (camlCode__f4_1036(1)  x/1037
               (if (isout 2 3) x/1037
                 (switch* 3
                  case int 0: (+ x/1037 1)
                  case int 1: (+ x/1037 2)
                  case int 2: (+ x/1037 3)blocks...
lambda saved
typedtree saved

-dcmm
(data int 4096 global "camlCode" "camlCode": skip 32)
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
 (let f1/1030 "camlCode__4" (store "camlCode" f1/1030))
 (let f2/1032 "camlCode__3" (store (+a "camlCode" 8) f2/1032))
 (let f3/1034 "camlCode__2" (store (+a "camlCode" 16) f3/1034))
 (let f4/1036 "camlCode__1" (store (+a "camlCode" 24) f4/1036)) 1a)

(data)
lambda saved
typedtree saved
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
	.quad	4096
	.globl	camlCode
camlCode:
	.space	32
	.data
	.quad	2295
camlCode__1:
	.quad	camlCode__f4_1036
	.quad	3
	.data
	.quad	2295
camlCode__2:
	.quad	camlCode__f3_1034
	.quad	3
	.data
	.quad	2295
camlCode__3:
	.quad	camlCode__f2_1032
	.quad	3
	.data
	.quad	2295
camlCode__4:
	.quad	camlCode__f1_1030
	.quad	3
	.text
	.align	16
	.globl	camlCode__f1_1030
camlCode__f1_1030:
.L100:
	addq	$6, %rax
	ret
	.type	camlCode__f1_1030,@function
	.size	camlCode__f1_1030,.-camlCode__f1_1030
	.text
	.align	16
	.globl	camlCode__f2_1032
camlCode__f2_1032:
.L101:
	addq	$6, %rax
	ret
	.type	camlCode__f2_1032,@function
	.size	camlCode__f2_1032,.-camlCode__f2_1032
	.text
	.align	16
	.globl	camlCode__f3_1034
camlCode__f3_1034:
.L106:
	movq	%rax, %rdi
	movq	$5, %rbx
	cmpq	$5, %rbx
	jae	.L105
	movq	%rdi, %rax
	ret
	.align	4
.L105:
	movq	$2, %rbx
	cmpq	$1, %rbx
	je	.L103
	jg	.L102
.L104:
	movq	%rdi, %rax
	addq	$2, %rax
	ret
	.align	4
.L103:
	movq	%rdi, %rax
	addq	$4, %rax
	ret
	.align	4
.L102:
	movq	%rdi, %rax
	addq	$6, %rax
	ret
	.type	camlCode__f3_1034,@function
	.size	camlCode__f3_1034,.-camlCode__f3_1034
	.text
	.align	16
	.globl	camlCode__f4_1036
camlCode__f4_1036:
.L111:
	movq	%rax, %rdi
	movq	$5, %rbx
	cmpq	$7, %rbx
	jae	.L110
	movq	%rdi, %rax
	ret
	.align	4
.L110:
	movq	$3, %rbx
	cmpq	$1, %rbx
	je	.L108
	jg	.L107
.L109:
	movq	%rdi, %rax
	addq	$2, %rax
	ret
	.align	4
.L108:
	movq	%rdi, %rax
	addq	$4, %rax
	ret
	.align	4
.L107:
	movq	%rdi, %rax
	addq	$6, %rax
	ret
	.type	camlCode__f4_1036,@function
	.size	camlCode__f4_1036,.-camlCode__f4_1036
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L112:
	movq	camlCode__4@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 16(%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 24(%rax)
	movq	$1, %rax
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
	.quad	0
	.section .note.GNU-stack,"",%progbits
*)

let rec gcd m n =
  if m = 0 then n else
  if m <= n then gcd m (n-m) else
  gcd n (m-n)

    
let _ =
  let x = ref 0 in
  for i = 1 to 1000 do
    for j = 1 to 1000 do
      x := gcd i j
    done
  done
  (*
-drawlambda
(seq
  (letrec
    (gcd/1031
       (function m/1032 n/1033
         (if (== m/1032 0) n/1033
           (if (<= m/1032 n/1033) (apply gcd/1031 m/1032 (- n/1033 m/1032))
             (apply gcd/1031 n/1033 (- m/1032 n/1033))))))
    (setfield_imm 0 (global Code!) gcd/1031))
  (let (x/1034 (makemutable 0 0))
    (for i/1035 1 to 1000
      (for j/1036 1 to 1000
        (setfield_imm 0 x/1034
          (apply (field 0 (global Code!)) i/1035 j/1036)))))
  0a)
-dlambda
(seq
  (letrec
    (gcd/1031
       (function m/1032 n/1033
         (if (== m/1032 0) n/1033
           (if (<= m/1032 n/1033) (apply gcd/1031 m/1032 (- n/1033 m/1032))
             (apply gcd/1031 n/1033 (- m/1032 n/1033))))))
    (setfield_imm 0 (global Code!) gcd/1031))
  (let (x/1034 0)
    (for i/1035 1 to 1000
      (for j/1036 1 to 1000
        (assign x/1034 (apply (field 0 (global Code!)) i/1035 j/1036)))))
  0a)
checking tailcall on gcd/1031
stats_rec_removed : 1
(gcd_1031) 
stats_tailcall_removed : 2
(gcd_1031) (gcd_1031) 
stats_rec_removed : 0

stats_tailcall_removed : 0

-dlambda2
*** After TonLambda.optimize:
(seq
  (let
    (gcd/1031
       (function m/1042 n/1043
         (let (n/1033 n/1043 m/1032 m/1042)
           (catch
             (while 1a
               (catch
                 (exit 3
                   (if (== m/1032 0) n/1033
                     (if (<= m/1032 n/1033)
                       (let (arg/1040 (- n/1033 m/1032))
                         (seq (assign n/1033 arg/1040) (exit 2)))
                       (let (arg/1038 n/1033 arg/1039 (- m/1032 n/1033))
                         (seq (assign n/1033 arg/1039)
                           (assign m/1032 arg/1038) (exit 2))))))
                with (2) 0a))
            with (3 res/1041) res/1041))))
    (setfield_imm 0 (global Code!) gcd/1031))
  (let (x/1034 0)
    (for i/1035 1 to 1000
      (for j/1036 1 to 1000
        (assign x/1034 (apply (field 0 (global Code!)) i/1035 j/1036)))))
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let
    (gcd/1031
       (closure (camlCode__gcd_1031(2)  m/1042 n/1043
                  (let (n/1033[Variable] n/1043 m/1032[Variable] m/1042)
                    (catch
                      (while 1a
                        (catch
                          (exit 3
                            (if (== m/1032 0) n/1033
                              (if (<= m/1032 n/1033)
                                (let (arg/1040 (- n/1033 m/1032))
                                  (seq (assign n/1033 arg/1040) (exit 2)))
                                (let
                                  (arg/1038 n/1033
                                   arg/1039 (- m/1032 n/1033))
                                  (seq (assign n/1033 arg/1039)
                                    (assign m/1032 arg/1038) (exit 2))))))
                         with (2) 0a))
                     with (3 res/1041) res/1041))) {3} ))
    (setfield_imm 0 (global camlCode!) gcd/1031))
  (let (x/1034[Variable] 0)
    (for i/1035 1 to 1000
      (for j/1036 1 to 1000
        (assign x/1034
          (let (n/1045[Variable] j/1036 m/1046[Variable] i/1035)
            (catch
              (while 1a
                (catch
                  (exit 3
                    (if (== m/1046 0) n/1045
                      (if (<= m/1046 n/1045)
                        (let (arg/1049 (- n/1045 m/1046))
                          (seq (assign n/1045 arg/1049) (exit 2)))
                        (let (arg/1047 n/1045 arg/1048 (- m/1046 n/1045))
                          (seq (assign n/1045 arg/1048)
                            (assign m/1046 arg/1047) (exit 2))))))
                 with (2) 0a))
             with (3 res/1041) res/1041))))))
  0a)
-dclosure2
*** After TonClosure.optimize:
(let
  (gcd/1031
     (closure (camlCode__gcd_1031(2)  m/1042 n/1043
                (let (n/1033[Variable] n/1043 m/1032[Variable] m/1042)
                  (catch
                    (while 1a
                      (catch
                        (exit 3
                          (if (== m/1032 0) n/1033
                            (if (<= m/1032 n/1033)
                              (let (arg/1040 (- n/1033 m/1032))
                                (seq (assign n/1033 arg/1040) (exit 2)))
                              (let
                                (arg/1038 n/1033 arg/1039 (- m/1032 n/1033))
                                (seq (assign n/1033 arg/1039)
                                  (assign m/1032 arg/1038) (exit 2))))))
                       with (2) 0a))
                   with (3 res/1041) res/1041))) {3} ))
  (seq (setfield_imm 0 (global camlCode!) gcd/1031)
    (let (x/1034[Variable] 0)
      (for i/1035 1 to 1000
        (for j/1036 1 to 1000
          (assign x/1034
            (let (n/1045[Variable] j/1036 m/1046[Variable] i/1035)
              (catch
                (while 1a
                  (catch
                    (exit 3
                      (if (== m/1046 0) n/1045
                        (if (<= m/1046 n/1045)
                          (let (arg/1049 (- n/1045 m/1046))
                            (seq (assign n/1045 arg/1049) (exit 2)))
                          (let (arg/1047 n/1045 arg/1048 (- m/1046 n/1045))
                            (seq (assign n/1045 arg/1048)
                              (assign m/1046 arg/1047) (exit 2))))))
                   with (2) 0a))
               with (3 res/1041) res/1041))))))
    0a))

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 4)
(data
 int 3319
 "camlCode__1":
 addr "caml_curry2"
 int 5
 addr "camlCode__gcd_1031")
(function camlCode__gcd_1031 (m/1042: addr n/1043: addr)
 (let (n/1033 n/1043 m/1032 m/1042)
   (catch
     (loop
       (catch
         (exit 3
           (if (== m/1032 1) n/1033
             (if (<= m/1032 n/1033)
               (let arg/1040 (+ (- n/1033 m/1032) 1) (assign n/1033 arg/1040)
                 (exit 2))
               (let (arg/1038 n/1033 arg/1039 (+ (- m/1032 n/1033) 1))
                 (assign n/1033 arg/1039) (assign m/1032 arg/1038) (exit 2)))))
       with(2) []))
     1a
   with(3 res/1041) res/1041)))

(function camlCode__entry ()
 (let gcd/1031 "camlCode__1" (store "camlCode" gcd/1031)
   (let (x/1034 1 i/1035 3)
     (catch
       (if (> i/1035 2001) (exit 4)
         (loop
           (let j/1036 3
             (catch
               (if (> j/1036 2001) (exit 5)
                 (loop
                   (assign x/1034
                             (let (n/1045 j/1036 m/1046 i/1035)
                               (catch
                                 (loop
                                   (catch
                                     (exit 3
                                       (if (== m/1046 1) n/1045
                                         (if (<= m/1046 n/1045)
                                           (let
                                             arg/1049 (+ (- n/1045 m/1046) 1)
                                             (assign n/1045 arg/1049)
                                             (exit 2))
                                           (let
                                             (arg/1047 n/1045
                                              arg/1048
                                                (+ (- m/1046 n/1045) 1))
                                             (assign n/1045 arg/1048)
                                             (assign m/1046 arg/1047)
                                             (exit 2)))))
                                   with(2) []))
                                 1a
                               with(3 res/1041) res/1041)))
                   (let j/1051 j/1036 (assign j/1036 (+ j/1036 2))
                     (if (== j/1051 2001) (exit 5) []))))
             with(5) []))
           (let i/1050 i/1035 (assign i/1035 (+ i/1035 2))
             (if (== i/1050 2001) (exit 4) []))))
     with(4) []))
   1a))

(data)
-dlinear
Before simplify
camlCode__gcd_1031:
                  m/8[%ecx] := R/0[%eax]
                  n/10[%eax] := n/9[%ebx]
                  L101 [0]:
                  if m/11[%ecx] ==s 1 goto L100
                  if m/11[%ecx] >s n/10[%eax] goto L102
                  I/13[%eax] := I/13[%eax] - m/11[%ecx]
                  arg/14[%eax] := arg/14[%eax] + 1
                  goto L101
                  L102 [0]:
                  arg/15[%edx] := n/10[%eax]
                  I/16[%ecx] := I/16[%ecx] - n/10[%eax]
                  arg/17[%eax] := I/16[%ecx]
                  arg/17[%eax] := arg/17[%eax] + 1
                  m/11[%ecx] := arg/15[%edx]
                  goto L101
                  L100 [0]:
                  return R/0[%eax]
                  *** Linearized code
camlCode__gcd_1031:
  m/8[%ecx] := R/0[%eax]
  n/10[%eax] := n/9[%ebx]
  L101 [4]:
  if m/11[%ecx] ==s 1 goto L100
  if m/11[%ecx] >s n/10[%eax] goto L102
  I/13[%eax] := I/13[%eax] - m/11[%ecx]
  arg/14[%eax] := arg/14[%eax] + 1
  goto L101
  L102 [2]:
  arg/15[%edx] := n/10[%eax]
  I/16[%ecx] := I/16[%ecx] - n/10[%eax]
  arg/17[%eax] := I/16[%ecx]
  arg/17[%eax] := arg/17[%eax] + 1
  m/11[%ecx] := arg/15[%edx]
  goto L101
  L100 [2]:
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  gcd/8[%eax] := "camlCode__1"
                  ["camlCode"] := gcd/8[%eax]
                  x/9[%ecx] := 1
                  i/10[%ebx] := 3
                  if i/10[%ebx] >s 2001 goto L104
                  L105 [0]:
                  j/11[%eax] := 3
                  if j/11[%eax] >s 2001 goto L106
                  L107 [0]:
                  n/12[%ecx] := j/11[%eax]
                  m/13[%edx] := i/10[%ebx]
                  L109 [0]:
                  if m/13[%edx] ==s 1 goto L108
                  if m/13[%edx] >s n/12[%ecx] goto L110
                  I/15[%ecx] := I/15[%ecx] - m/13[%edx]
                  arg/16[%ecx] := arg/16[%ecx] + 1
                  goto L109
                  L110 [0]:
                  arg/17[%esi] := n/12[%ecx]
                  I/18[%edx] := I/18[%edx] - n/12[%ecx]
                  arg/19[%ecx] := I/18[%edx]
                  arg/19[%ecx] := arg/19[%ecx] + 1
                  m/13[%edx] := arg/17[%esi]
                  goto L109
                  L108 [0]:
                  j/22[%ecx] := j/11[%eax]
                  I/23[%eax] := I/23[%eax] + 2
                  if j/22[%ecx] !=s 2001 goto L107
                  L106 [0]:
                  i/24[%eax] := i/10[%ebx]
                  I/25[%ebx] := I/25[%ebx] + 2
                  if i/24[%eax] !=s 2001 goto L105
                  L104 [0]:
                  A/26[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  gcd/8[%eax] := "camlCode__1"
  ["camlCode"] := gcd/8[%eax]
  x/9[%ecx] := 1
  i/10[%ebx] := 3
  if i/10[%ebx] >s 2001 goto L104
  L105 [4]:
  j/11[%eax] := 3
  if j/11[%eax] >s 2001 goto L106
  L107 [4]:
  n/12[%ecx] := j/11[%eax]
  m/13[%edx] := i/10[%ebx]
  L109 [4]:
  if m/13[%edx] ==s 1 goto L108
  if m/13[%edx] >s n/12[%ecx] goto L110
  I/15[%ecx] := I/15[%ecx] - m/13[%edx]
  arg/16[%ecx] := arg/16[%ecx] + 1
  goto L109
  L110 [2]:
  arg/17[%esi] := n/12[%ecx]
  I/18[%edx] := I/18[%edx] - n/12[%ecx]
  arg/19[%ecx] := I/18[%edx]
  arg/19[%ecx] := arg/19[%ecx] + 1
  m/13[%edx] := arg/17[%esi]
  goto L109
  L108 [2]:
  j/22[%ecx] := j/11[%eax]
  I/23[%eax] := I/23[%eax] + 2
  if j/22[%ecx] !=s 2001 goto L107
  L106 [4]:
  i/24[%eax] := i/10[%ebx]
  I/25[%ebx] := I/25[%ebx] + 2
  if i/24[%eax] !=s 2001 goto L105
  L104 [4]:
  A/26[%eax] := 1
  return R/0[%eax]
  
-S
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.long	1024
	.globl	camlCode
camlCode:
	.space	4
	.data
	.long	3319
camlCode__1:
	.long	caml_curry2
	.long	5
	.long	camlCode__gcd_1031
	.text
	.align	16
	.globl	camlCode__gcd_1031
camlCode__gcd_1031:
.L103:
	movl	%eax, %ecx
	movl	%ebx, %eax
.L101:
	cmpl	$1, %ecx
	je	.L100
	cmpl	%eax, %ecx
	jg	.L102
	subl	%ecx, %eax
	incl	%eax
	jmp	.L101
	.align	16
.L102:
	movl	%eax, %edx
	subl	%eax, %ecx
	movl	%ecx, %eax
	incl	%eax
	movl	%edx, %ecx
	jmp	.L101
	.align	16
.L100:
	ret
	.type	camlCode__gcd_1031,@function
	.size	camlCode__gcd_1031,.-camlCode__gcd_1031
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L111:
	movl	$camlCode__1, %eax
	movl	%eax, camlCode
	movl	$1, %ecx
	movl	$3, %ebx
	cmpl	$2001, %ebx
	jg	.L104
.L105:
	movl	$3, %eax
	cmpl	$2001, %eax
	jg	.L106
.L107:
	movl	%eax, %ecx
	movl	%ebx, %edx
.L109:
	cmpl	$1, %edx
	je	.L108
	cmpl	%ecx, %edx
	jg	.L110
	subl	%edx, %ecx
	incl	%ecx
	jmp	.L109
.L110:
	movl	%ecx, %esi
	subl	%ecx, %edx
	movl	%edx, %ecx
	incl	%ecx
	movl	%esi, %edx
	jmp	.L109
.L108:
	movl	%eax, %ecx
	addl	$2, %eax
	cmpl	$2001, %ecx
	jne	.L107
.L106:
	movl	%ebx, %eax
	addl	$2, %ebx
	cmpl	$2001, %eax
	jne	.L105
.L104:
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

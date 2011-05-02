(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.

   Here, the two arguments only differ by the fact that the first one
   is currified, while the second one is a "tuplified" function.
*)

let computed1 =
  let rec iter1 f l =
    match l with
	[] -> ()
      | a::l -> f a; iter1 f l

  in
  let list1 = ref [] in
  iter1 (fun x -> list1 := x :: !list1) [1; 2; 3; 4; 5];
  !list1

let computed2 =
  let rec iter1 f l =
    match l with
	[] -> ()
      | a::l -> f a; iter1 f l
  in

  let list1 = ref [] in
  iter1 (fun (x,y) -> list1 := x :: !list1) [1,2; 2,3; 3,3; 4,5; 5,6];
  !list1

(*
-drawlambda
(seq
  (let
    (computed1/1030
       = (letrec
           (iter1/1031
              = (function f/1032 l/1033
                  (if l/1033
                    (let
                      (l/1035 (=) (field 1 l/1033)
                       a/1034 (=) (field 0 l/1033))
                      (seq (apply f/1032 a/1034)
                        (apply iter1/1031 f/1032 l/1035)))
                    0a)))
           (let (list1/1036 = (makemutable 0 0a))
             (seq
               (apply iter1/1031
                 (function x/1037
                   (setfield_ptr 0 list1/1036
                     (makeblock 0 x/1037 (field 0 list1/1036))))
                 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
               (field 0 list1/1036)))))
    (setfield_imm 0 (global Code!) computed1/1030))
  (let
    (computed2/1038
       = (letrec
           (iter1/1039
              = (function f/1040 l/1041
                  (if l/1041
                    (let
                      (l/1043 (=) (field 1 l/1041)
                       a/1042 (=) (field 0 l/1041))
                      (seq (apply f/1040 a/1042)
                        (apply iter1/1039 f/1040 l/1043)))
                    0a)))
           (let (list1/1044 = (makemutable 0 0a))
             (seq
               (apply iter1/1039
                 (function (param/1049, param/1050)
                   (let (y/1046 (=) param/1050 x/1045 (=) param/1049)
                     (setfield_ptr 0 list1/1044
                       (makeblock 0 x/1045 (field 0 list1/1044)))))
                 [0:
                  [0: 1 2]
                  [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]])
               (field 0 list1/1044)))))
    (setfield_imm 1 (global Code!) computed2/1038))
  0a)
-dlambda
(seq
  (let
    (computed1/1030
       = (let (list1/1036 := 0a)
           (seq
             (let (l/1058 = [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
               (catch
                 (let (l/1057 := l/1058)
                   (while 1a
                     (catch
                       (let (l/1033 = l/1057)
                         (exit 9
                           (if l/1033
                             (seq
                               (assign list1/1036
                                 (makeblock 0 (field 0 l/1033) list1/1036))
                               (exit 11 (field 1 l/1033)))
                             0a)))
                      with (11 l/1056) (seq (assign l/1057 l/1056) 0a))))
                with (9 result/1059) result/1059))
             list1/1036)))
    (setfield_imm 0 (global Code!) computed1/1030))
  (let
    (computed2/1038
       = (let (list1/1044 = (makemutable 0 0a))
           (seq
             (let
               (l/1054
                  = [0:
                     [0: 1 2]
                     [0:
                      [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]]
                f/1040
                  = (function (param/1049, param/1050)
                      (setfield_ptr 0 list1/1044
                        (makeblock 0 param/1049 (field 0 list1/1044)))))
               (catch
                 (let (l/1053 := l/1054)
                   (while 1a
                     (catch
                       (let (l/1041 = l/1053)
                         (exit 6
                           (if l/1041
                             (seq (apply f/1040 (field 0 l/1041))
                               (exit 8 (field 1 l/1041)))
                             0a)))
                      with (8 l/1052) (seq (assign l/1053 l/1052) 0a))))
                with (6 result/1055) result/1055))
             (field 0 list1/1044))))
    (setfield_imm 1 (global Code!) computed2/1038))
  0a)
-dclosure
*** After closure conversion:
(seq
  (let
    (computed1/1030 {?} = 
       (let (list1/1036 {cstptr 0} =  0a)
         (seq
           (let
             (l/1058 {(int 1, (int 2, (int 3, (int 4, (int 5, cstptr 0)))))} = 
                [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
             (catch
               (let
                 (l/1057 {(int 1, (int 2, (int 3, (int 4, (int 5, cstptr 0)))))} = 
                    l/1058)
                 (while 1a
                   (catch
                     (let (l/1033 {?} =  l/1057)
                       (exit 9
                         (if l/1033
                           (seq
                             (assign list1/1036
                               (makeblock 0 (field 0 l/1033) list1/1036))
                             (exit 11 (field 1 l/1033)))
                           0a)))
                    with (11 l/1056) (seq (assign l/1057 l/1056) 0a))))
              with (9 result/1059) result/1059))
           list1/1036)))
    (setfield_imm 0 (global camlCode!) computed1/1030))
  (let
    (computed2/1038 {?} = 
       (let (list1/1044 {?} =  (makemutable 0 0a))
         (seq
           (let
             (l/1054 {((int 1, int 2), ((int 2, int 3), ((int 3, int 3), 
                                                          ((int 4, int 5), 
                                                            ((int 5, int 6), 
                                                              cstptr 0)))))} = 
                [0:
                 [0: 1 2]
                 [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]]
              f/1040 {fun camlCode__f_1040 {-2} inline -> ?} = 
                (closure (camlCode__f_1040(-2)  param/1049 param/1050
                           env/1061
                           (setfield_ptr 0 (field 3 env/1061)
                             (makeblock 0 param/1049
                               (field 0 (field 3 env/1061))))) {0} 
                                                               list1/1044))
             (catch
               (let
                 (l/1053 {((int 1, int 2), ((int 2, int 3), ((int 3, int 3), 
                                                              ((int 4, int 5), 
                                                                ((int 5, 
                                                                   int 6), 
                                                                  cstptr 0)))))} = 
                    l/1054)
                 (while 1a
                   (catch
                     (let (l/1041 {?} =  l/1053)
                       (exit 6
                         (if l/1041
                           (seq
                             (let
                               (arg/1062 {?} =  (field 0 l/1041)
                                param/1064 {?} =  (field 0 arg/1062))
                               (setfield_ptr 0 (field 3 f/1040)
                                 (makeblock 0 param/1064
                                   (field 0 (field 3 f/1040)))))
                             (exit 8 (field 1 l/1041)))
                           0a)))
                    with (8 l/1052) (seq (assign l/1053 l/1052) 0a))))
              with (6 result/1055) result/1055))
           (field 0 list1/1044))))
    (setfield_imm 1 (global camlCode!) computed2/1038))
  0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 16)
(data
 global "camlCode__1"
 int 2048
 "camlCode__1":
 int 3
 addr L12
 int 2048
 L12:
 int 5
 addr L13
 int 2048
 L13:
 int 7
 addr L14
 int 2048
 L14:
 int 9
 addr L15
 int 2048
 L15:
 int 11
 int 1)
(data
 global "camlCode__2"
 int 2048
 "camlCode__2":
 addr L3
 addr L4
 int 2048
 L4:
 addr L5
 addr L6
 int 2048
 L6:
 addr L7
 addr L8
 int 2048
 L8:
 addr L9
 addr L10
 int 2048
 L10:
 addr L11
 int 1
 int 2048
 L11:
 int 11
 int 13
 int 2048
 L9:
 int 9
 int 11
 int 2048
 L7:
 int 7
 int 7
 int 2048
 L5:
 int 5
 int 7
 int 2048
 L3:
 int 3
 int 5)
(function camlCode__f_1040 (param/1049: addr param/1050: addr env/1061: addr)
 (extcall "caml_modify" (load (+a env/1061 24))
   (alloc 2048 param/1049 (load (load (+a env/1061 24)))) unit)
 1a)

(function camlCode__entry ()
 (let
   computed1/1030
     (let list1/1036 1a
       (let l/1058 "camlCode__1"
         (catch
           (let l/1057 l/1058
             (catch
               (loop
                 (catch
                   (let l/1033 l/1057
                     (exit 9
                       (if (!= l/1033 1)
                         (seq
                           (assign list1/1036
                                     (alloc 2048 (load l/1033) list1/1036))
                           (exit 11 (load (+a l/1033 8))))
                         1a)))
                 with(11 l/1056) (assign l/1057 l/1056)))
             with(13) []))
         with(9 result/1059) result/1059 []))
       list1/1036)
   (store "camlCode" computed1/1030))
 (let
   computed2/1038
     (let list1/1044 (alloc 1024 1a)
       (let
         (l/1054 "camlCode__2"
          f/1040
            (alloc 4343 "caml_tuplify2" -3 "camlCode__f_1040" list1/1044))
         (catch
           (let l/1053 l/1054
             (catch
               (loop
                 (catch
                   (let l/1041 l/1053
                     (exit 6
                       (if (!= l/1041 1)
                         (seq
                           (let
                             (arg/1062 (load l/1041)
                              param/1064 (load arg/1062))
                             (extcall "caml_modify" (load (+a f/1040 24))
                               (alloc 2048 param/1064
                                 (load (load (+a f/1040 24))))
                               unit))
                           (exit 8 (load (+a l/1041 8))))
                         1a)))
                 with(8 l/1052) (assign l/1053 l/1052)))
             with(12) []))
         with(6 result/1055) result/1055 []))
       (load list1/1044))
   (store (+a "camlCode" 8) computed2/1038))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__f_1040:
  param/29[%rdx] := R/0[%rax]
  {param/29[%rdx]* env/31[%rdi]*}
  A/32[%rsi] := alloc 24
  [A/32[%rsi] + -8] := 2048
  [A/32[%rsi]] := param/29[%rdx]
  A/33[%rax] := [env/31[%rdi] + 24]
  A/34[%rax] := [A/33[%rax]]
  [A/32[%rsi] + 8] := A/34[%rax]
  A/35[%rdi] := [env/31[%rdi] + 24]
  {}
  extcall "caml_modify" R/2[%rdi] R/3[%rsi]
  A/36[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  list1/29[%rbx] := 1
  l/30[%rdi] := "camlCode__1"
  L108:
  if l/34[%rdi] ==s 1 goto L109
  {list1/29[%rbx]* l/34[%rdi]*}
  A/35[%rsi] := alloc 24
  [A/35[%rsi] + -8] := 2048
  A/36[%rax] := [l/34[%rdi]]
  [A/35[%rsi]] := A/36[%rax]
  [A/35[%rsi] + 8] := list1/29[%rbx]
  list1/29[%rbx] := A/35[%rsi]
  A/37[%rdi] := [l/34[%rdi] + 8]
  goto L108
  L109:
  A/38[%rax] := 1
  L107:
  A/40[%rax] := "camlCode"
  [A/40[%rax]] := computed1/39[%rbx]
  {}
  list1/41[%r12] := alloc 56
  [list1/41[%r12] + -8] := 1024
  [list1/41[%r12]] := 1
  l/42[%rbx] := "camlCode__2"
  f/43[%rbp] := list1/41[%r12] + 16
  [f/43[%rbp] + -8] := 4343
  A/44[%rax] := "caml_tuplify2"
  [f/43[%rbp]] := A/44[%rax]
  [f/43[%rbp] + 8] := -3
  A/45[%rax] := "camlCode__f_1040"
  [f/43[%rbp] + 16] := A/45[%rax]
  [f/43[%rbp] + 24] := list1/41[%r12]
  L105:
  if l/49[%rbx] ==s 1 goto L106
  arg/50[%rax] := [l/49[%rbx]]
  param/51[%rdi] := [arg/50[%rax]]
  {list1/41[%r12]* f/43[%rbp]* l/49[%rbx]* param/51[%rdi]*}
  A/52[%rsi] := alloc 24
  [A/52[%rsi] + -8] := 2048
  [A/52[%rsi]] := param/51[%rdi]
  A/53[%rax] := [f/43[%rbp] + 24]
  A/54[%rax] := [A/53[%rax]]
  [A/52[%rsi] + 8] := A/54[%rax]
  A/55[%rdi] := [f/43[%rbp] + 24]
  {list1/41[%r12]* f/43[%rbp]* l/49[%rbx]*}
  extcall "caml_modify" R/2[%rdi] R/3[%rsi]
  A/56[%rbx] := [l/49[%rbx] + 8]
  goto L105
  L106:
  A/57[%rax] := 1
  L104:
  computed2/58[%rbx] := [list1/41[%r12]]
  A/59[%rax] := "camlCode"
  [A/59[%rax] + 8] := computed2/58[%rbx]
  A/60[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
-dstartup
	.section        .rodata.cst8,"a",@progbits
	.align	16
caml_negf_mask:	.quad   0x8000000000000000, 0
	.align	16
caml_absf_mask:	.quad   0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF
	.data
	.globl	caml_startup__data_begin
caml_startup__data_begin:
	.text
	.globl	caml_startup__code_begin
caml_startup__code_begin:
	.text
	.align	16
	.globl	caml_program
caml_program:
	subq	$8, %rsp
.L100:
	call	camlPervasives__entry@PLT
.L101:
	movq	caml_globals_inited@GOTPCREL(%rip), %rax
	addq	$1, (%rax)
	call	camlCode__entry@PLT
.L102:
	movq	caml_globals_inited@GOTPCREL(%rip), %rax
	addq	$1, (%rax)
	call	camlStd_exit__entry@PLT
.L103:
	movq	caml_globals_inited@GOTPCREL(%rip), %rax
	addq	$1, (%rax)
	movq	$1, %rax
	addq	$8, %rsp
	ret
	.type	caml_program,@function
	.size	caml_program,.-caml_program
	.text
	.align	16
	.globl	caml_curry4
caml_curry4:
	subq	$8, %rsp
.L104:
	movq	%rax, %rsi
.L105:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L106
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry4_1@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$7, 8(%rax)
	movq	caml_curry4_1_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L106:	call	caml_call_gc@PLT
.L107:	jmp	.L105
	.type	caml_curry4,@function
	.size	caml_curry4,.-caml_curry4
	.text
	.align	16
	.globl	caml_curry4_1_app
caml_curry4_1_app:
.L108:
	movq	%rax, %r10
	movq	%rbx, %r9
	movq	%rdi, %r8
	movq	32(%rsi), %rdx
	movq	24(%rsi), %rax
	movq	16(%rdx), %rcx
	movq	%r10, %rbx
	movq	%r9, %rdi
	movq	%r8, %rsi
	jmp	*%rcx
	.type	caml_curry4_1_app,@function
	.size	caml_curry4_1_app,.-caml_curry4_1_app
	.text
	.align	16
	.globl	caml_curry4_1
caml_curry4_1:
	subq	$8, %rsp
.L109:
	movq	%rax, %rsi
.L110:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L111
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry4_2@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$5, 8(%rax)
	movq	caml_curry4_2_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L111:	call	caml_call_gc@PLT
.L112:	jmp	.L110
	.type	caml_curry4_1,@function
	.size	caml_curry4_1,.-caml_curry4_1
	.text
	.align	16
	.globl	caml_curry4_2_app
caml_curry4_2_app:
.L113:
	movq	%rax, %r8
	movq	%rbx, %rsi
	movq	32(%rdi), %rax
	movq	32(%rax), %rdx
	movq	24(%rdi), %rbx
	movq	24(%rax), %rax
	movq	16(%rdx), %rcx
	movq	%r8, %rdi
	jmp	*%rcx
	.type	caml_curry4_2_app,@function
	.size	caml_curry4_2_app,.-caml_curry4_2_app
	.text
	.align	16
	.globl	caml_curry4_2
caml_curry4_2:
	subq	$8, %rsp
.L114:
	movq	%rax, %rsi
.L115:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L116
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry4_3@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L116:	call	caml_call_gc@PLT
.L117:	jmp	.L115
	.type	caml_curry4_2,@function
	.size	caml_curry4_2,.-caml_curry4_2
	.text
	.align	16
	.globl	caml_curry4_3
caml_curry4_3:
.L118:
	movq	%rax, %rsi
	movq	24(%rbx), %rcx
	movq	32(%rcx), %rax
	movq	32(%rax), %rdx
	movq	16(%rbx), %rdi
	movq	24(%rcx), %rbx
	movq	24(%rax), %rax
	movq	16(%rdx), %rcx
	jmp	*%rcx
	.type	caml_curry4_3,@function
	.size	caml_curry4_3,.-caml_curry4_3
	.text
	.align	16
	.globl	caml_curry3
caml_curry3:
	subq	$8, %rsp
.L119:
	movq	%rax, %rsi
.L120:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L121
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry3_1@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$5, 8(%rax)
	movq	caml_curry3_1_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L121:	call	caml_call_gc@PLT
.L122:	jmp	.L120
	.type	caml_curry3,@function
	.size	caml_curry3,.-caml_curry3
	.text
	.align	16
	.globl	caml_curry3_1_app
caml_curry3_1_app:
.L123:
	movq	%rax, %r8
	movq	%rbx, %rcx
	movq	32(%rdi), %rsi
	movq	24(%rdi), %rax
	movq	16(%rsi), %rdx
	movq	%r8, %rbx
	movq	%rcx, %rdi
	jmp	*%rdx
	.type	caml_curry3_1_app,@function
	.size	caml_curry3_1_app,.-caml_curry3_1_app
	.text
	.align	16
	.globl	caml_curry3_1
caml_curry3_1:
	subq	$8, %rsp
.L124:
	movq	%rax, %rsi
.L125:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L126
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry3_2@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L126:	call	caml_call_gc@PLT
.L127:	jmp	.L125
	.type	caml_curry3_1,@function
	.size	caml_curry3_1,.-caml_curry3_1
	.text
	.align	16
	.globl	caml_curry3_2
caml_curry3_2:
.L128:
	movq	%rax, %rdi
	movq	24(%rbx), %rax
	movq	32(%rax), %rsi
	movq	16(%rbx), %rbx
	movq	24(%rax), %rax
	movq	16(%rsi), %rdx
	jmp	*%rdx
	.type	caml_curry3_2,@function
	.size	caml_curry3_2,.-caml_curry3_2
	.text
	.align	16
	.globl	caml_curry2
caml_curry2:
	subq	$8, %rsp
.L129:
	movq	%rax, %rsi
.L130:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L131
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry2_1@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L131:	call	caml_call_gc@PLT
.L132:	jmp	.L130
	.type	caml_curry2,@function
	.size	caml_curry2,.-caml_curry2
	.text
	.align	16
	.globl	caml_curry2_1
caml_curry2_1:
.L133:
	movq	%rax, %rdx
	movq	24(%rbx), %rdi
	movq	16(%rbx), %rax
	movq	16(%rdi), %rsi
	movq	%rdx, %rbx
	jmp	*%rsi
	.type	caml_curry2_1,@function
	.size	caml_curry2_1,.-caml_curry2_1
	.text
	.align	16
	.globl	caml_tuplify2
caml_tuplify2:
.L134:
	movq	%rbx, %rdi
	movq	8(%rax), %rbx
	movq	(%rax), %rax
	movq	16(%rdi), %rsi
	jmp	*%rsi
	.type	caml_tuplify2,@function
	.size	caml_tuplify2,.-caml_tuplify2
	.text
	.align	16
	.globl	caml_apply3
caml_apply3:
	subq	$24, %rsp
.L136:
	movq	8(%rsi), %rdx
	cmpq	$7, %rdx
	jne	.L135
	movq	16(%rsi), %rdx
	addq	$24, %rsp
	jmp	*%rdx
	.align	4
.L135:
	movq	%rdi, 8(%rsp)
	movq	%rbx, 0(%rsp)
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L137:
	movq	%rax, %rbx
	movq	(%rbx), %rdi
	movq	0(%rsp), %rax
	call	*%rdi
.L138:
	movq	%rax, %rbx
	movq	(%rbx), %rdi
	movq	8(%rsp), %rax
	addq	$24, %rsp
	jmp	*%rdi
	.type	caml_apply3,@function
	.size	caml_apply3,.-caml_apply3
	.text
	.align	16
	.globl	caml_apply2
caml_apply2:
	subq	$8, %rsp
.L140:
	movq	8(%rdi), %rsi
	cmpq	$5, %rsi
	jne	.L139
	movq	16(%rdi), %rsi
	addq	$8, %rsp
	jmp	*%rsi
	.align	4
.L139:
	movq	%rbx, 0(%rsp)
	movq	(%rdi), %rsi
	movq	%rdi, %rbx
	call	*%rsi
.L141:
	movq	%rax, %rbx
	movq	(%rbx), %rdi
	movq	0(%rsp), %rax
	addq	$8, %rsp
	jmp	*%rdi
	.type	caml_apply2,@function
	.size	caml_apply2,.-caml_apply2
	.data
	.globl	caml_exn_Out_of_memory
	.quad	1024
caml_exn_Out_of_memory:
	.quad	.L100001
	.quad	2300
.L100001:
	.ascii	"Out_of_memory"
	.space	2
	.byte	2
	.globl	caml_bucket_Out_of_memory
	.quad	1024
caml_bucket_Out_of_memory:
	.quad	caml_exn_Out_of_memory
	.data
	.globl	caml_exn_Sys_error
	.quad	1024
caml_exn_Sys_error:
	.quad	.L100002
	.quad	2300
.L100002:
	.ascii	"Sys_error"
	.space	6
	.byte	6
	.globl	caml_bucket_Sys_error
	.quad	1024
caml_bucket_Sys_error:
	.quad	caml_exn_Sys_error
	.data
	.globl	caml_exn_Failure
	.quad	1024
caml_exn_Failure:
	.quad	.L100003
	.quad	1276
.L100003:
	.ascii	"Failure"
	.byte	0
	.globl	caml_bucket_Failure
	.quad	1024
caml_bucket_Failure:
	.quad	caml_exn_Failure
	.data
	.globl	caml_exn_Invalid_argument
	.quad	1024
caml_exn_Invalid_argument:
	.quad	.L100004
	.quad	3324
.L100004:
	.ascii	"Invalid_argument"
	.space	7
	.byte	7
	.globl	caml_bucket_Invalid_argument
	.quad	1024
caml_bucket_Invalid_argument:
	.quad	caml_exn_Invalid_argument
	.data
	.globl	caml_exn_End_of_file
	.quad	1024
caml_exn_End_of_file:
	.quad	.L100005
	.quad	2300
.L100005:
	.ascii	"End_of_file"
	.space	4
	.byte	4
	.globl	caml_bucket_End_of_file
	.quad	1024
caml_bucket_End_of_file:
	.quad	caml_exn_End_of_file
	.data
	.globl	caml_exn_Division_by_zero
	.quad	1024
caml_exn_Division_by_zero:
	.quad	.L100006
	.quad	3324
.L100006:
	.ascii	"Division_by_zero"
	.space	7
	.byte	7
	.globl	caml_bucket_Division_by_zero
	.quad	1024
caml_bucket_Division_by_zero:
	.quad	caml_exn_Division_by_zero
	.data
	.globl	caml_exn_Not_found
	.quad	1024
caml_exn_Not_found:
	.quad	.L100007
	.quad	2300
.L100007:
	.ascii	"Not_found"
	.space	6
	.byte	6
	.globl	caml_bucket_Not_found
	.quad	1024
caml_bucket_Not_found:
	.quad	caml_exn_Not_found
	.data
	.globl	caml_exn_Match_failure
	.quad	1024
caml_exn_Match_failure:
	.quad	.L100008
	.quad	2300
.L100008:
	.ascii	"Match_failure"
	.space	2
	.byte	2
	.globl	caml_bucket_Match_failure
	.quad	1024
caml_bucket_Match_failure:
	.quad	caml_exn_Match_failure
	.data
	.globl	caml_exn_Stack_overflow
	.quad	1024
caml_exn_Stack_overflow:
	.quad	.L100009
	.quad	2300
.L100009:
	.ascii	"Stack_overflow"
	.space	1
	.byte	1
	.globl	caml_bucket_Stack_overflow
	.quad	1024
caml_bucket_Stack_overflow:
	.quad	caml_exn_Stack_overflow
	.data
	.globl	caml_exn_Sys_blocked_io
	.quad	1024
caml_exn_Sys_blocked_io:
	.quad	.L100010
	.quad	2300
.L100010:
	.ascii	"Sys_blocked_io"
	.space	1
	.byte	1
	.globl	caml_bucket_Sys_blocked_io
	.quad	1024
caml_bucket_Sys_blocked_io:
	.quad	caml_exn_Sys_blocked_io
	.data
	.globl	caml_exn_Assert_failure
	.quad	1024
caml_exn_Assert_failure:
	.quad	.L100011
	.quad	2300
.L100011:
	.ascii	"Assert_failure"
	.space	1
	.byte	1
	.globl	caml_bucket_Assert_failure
	.quad	1024
caml_bucket_Assert_failure:
	.quad	caml_exn_Assert_failure
	.data
	.globl	caml_exn_Undefined_recursive_module
	.quad	1024
caml_exn_Undefined_recursive_module:
	.quad	.L100012
	.quad	4348
.L100012:
	.ascii	"Undefined_recursive_module"
	.space	5
	.byte	5
	.globl	caml_bucket_Undefined_recursive_module
	.quad	1024
caml_bucket_Undefined_recursive_module:
	.quad	caml_exn_Undefined_recursive_module
	.data
	.globl	caml_globals
caml_globals:
	.quad	camlPervasives
	.quad	camlCode
	.quad	camlStd_exit
	.quad	0
	.data
	.globl	caml_globals_map
	.quad	21756
caml_globals_map:
	.ascii	"\204\225\246\276\0\0\0\222\0\0\0\22\0\0\0P\0\0\0A\240\300*Pervasives0\333r:\27\230\261\42\340\211\31\242\277\355\6%\24\60\313;C\225C\23-y\15\33H\264\371S\271:\240\4\4@\240\300$Code0h"
	.ascii	"\206b\21\20<6y\316Y\245bT\370\244k0\243\306\311`\316\305V\337\220\274\233:\203\347\331m\240\4\4@\240\300(Std_exit0K<u\217\27kw\366\203\3\37W\376u\277\312\60\245\15s\177\263x\376\216gr\201\37\265d\355"
	.ascii	"\204\240\4\4@@"
	.space	1
	.byte	1
	.data
	.globl	caml_data_segments
caml_data_segments:
	.quad	caml_startup__data_begin
	.quad	caml_startup__data_end
	.quad	camlPervasives__data_begin
	.quad	camlPervasives__data_end
	.quad	camlCode__data_begin
	.quad	camlCode__data_end
	.quad	camlStd_exit__data_begin
	.quad	camlStd_exit__data_end
	.quad	0
	.data
	.globl	caml_code_segments
caml_code_segments:
	.quad	caml_startup__code_begin
	.quad	caml_startup__code_end
	.quad	camlPervasives__code_begin
	.quad	camlPervasives__code_end
	.quad	camlCode__code_begin
	.quad	camlCode__code_end
	.quad	camlStd_exit__code_begin
	.quad	camlStd_exit__code_end
	.quad	0
	.data
	.globl	caml_frametable
caml_frametable:
	.quad	caml_startup__frametable
	.quad	caml_system__frametable
	.quad	camlPervasives__frametable
	.quad	camlCode__frametable
	.quad	camlStd_exit__frametable
	.quad	0
	.text
	.globl	caml_startup__code_end
caml_startup__code_end:
	.data
	.globl	caml_startup__data_end
caml_startup__data_end:
	.long	0
	.globl	caml_startup__frametable
caml_startup__frametable:
	.quad	12
	.quad	.L141
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L138
	.word	32
	.word	1
	.word	8
	.align	8
	.quad	.L137
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.quad	.L132
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L127
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L122
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L117
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L112
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L107
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L103
	.word	16
	.word	0
	.align	8
	.quad	.L102
	.word	16
	.word	0
	.align	8
	.quad	.L101
	.word	16
	.word	0
	.align	8
	.section .note.GNU-stack,"",%progbits
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
	.globl	camlCode__1
	.quad	2048
camlCode__1:
	.quad	3
	.quad	.L100012
	.quad	2048
.L100012:
	.quad	5
	.quad	.L100013
	.quad	2048
.L100013:
	.quad	7
	.quad	.L100014
	.quad	2048
.L100014:
	.quad	9
	.quad	.L100015
	.quad	2048
.L100015:
	.quad	11
	.quad	1
	.data
	.globl	camlCode__2
	.quad	2048
camlCode__2:
	.quad	.L100003
	.quad	.L100004
	.quad	2048
.L100004:
	.quad	.L100005
	.quad	.L100006
	.quad	2048
.L100006:
	.quad	.L100007
	.quad	.L100008
	.quad	2048
.L100008:
	.quad	.L100009
	.quad	.L100010
	.quad	2048
.L100010:
	.quad	.L100011
	.quad	1
	.quad	2048
.L100011:
	.quad	11
	.quad	13
	.quad	2048
.L100009:
	.quad	9
	.quad	11
	.quad	2048
.L100007:
	.quad	7
	.quad	7
	.quad	2048
.L100005:
	.quad	5
	.quad	7
	.quad	2048
.L100003:
	.quad	3
	.quad	5
	.text
	.align	16
	.globl	camlCode__f_1040
camlCode__f_1040:
	subq	$8, %rsp
.L100:
	movq	%rax, %rdx
.L101:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L102
	leaq	8(%r15), %rsi
	movq	$2048, -8(%rsi)
	movq	%rdx, (%rsi)
	movq	24(%rdi), %rax
	movq	(%rax), %rax
	movq	%rax, 8(%rsi)
	movq	24(%rdi), %rdi
	call	caml_modify@PLT
	movq	$1, %rax
	addq	$8, %rsp
	ret
.L102:	call	caml_call_gc@PLT
.L103:	jmp	.L101
	.type	camlCode__f_1040,@function
	.size	camlCode__f_1040,.-camlCode__f_1040
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L110:
	movq	$1, %rbx
	movq	camlCode__1@GOTPCREL(%rip), %rdi
.L108:
	cmpq	$1, %rdi
	je	.L109
	call	caml_alloc2@PLT
.L111:
	leaq	8(%r15), %rsi
	movq	$2048, -8(%rsi)
	movq	(%rdi), %rax
	movq	%rax, (%rsi)
	movq	%rbx, 8(%rsi)
	movq	%rsi, %rbx
	movq	8(%rdi), %rdi
	jmp	.L108
.L109:
	movq	$1, %rax
.L107:
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	$56, %rax
	call	caml_allocN@PLT
.L112:
	leaq	8(%r15), %r12
	movq	$1024, -8(%r12)
	movq	$1, (%r12)
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	leaq	16(%r12), %rbp
	movq	$4343, -8(%rbp)
	movq	caml_tuplify2@GOTPCREL(%rip), %rax
	movq	%rax, (%rbp)
	movq	$-3, 8(%rbp)
	movq	camlCode__f_1040@GOTPCREL(%rip), %rax
	movq	%rax, 16(%rbp)
	movq	%r12, 24(%rbp)
.L105:
	cmpq	$1, %rbx
	je	.L106
	movq	(%rbx), %rax
	movq	(%rax), %rdi
	call	caml_alloc2@PLT
.L113:
	leaq	8(%r15), %rsi
	movq	$2048, -8(%rsi)
	movq	%rdi, (%rsi)
	movq	24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, 8(%rsi)
	movq	24(%rbp), %rdi
	call	caml_modify@PLT
	movq	8(%rbx), %rbx
	jmp	.L105
.L106:
	movq	$1, %rax
.L104:
	movq	(%r12), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
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
	.quad	.L113
	.word	16
	.word	4
	.word	5
	.word	3
	.word	21
	.word	23
	.align	8
	.quad	.L112
	.word	16
	.word	0
	.align	8
	.quad	.L111
	.word	16
	.word	2
	.word	5
	.word	3
	.align	8
	.quad	.L103
	.word	16
	.word	2
	.word	5
	.word	9
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

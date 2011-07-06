

let rec iter f = function
    [] -> ()
  | x :: tail -> f x; iter f tail

let list = [1;2;3;4;5]

let sum =
  let sum = ref 0 in
  iter (fun x -> sum := !sum + x) list;
    !sum



(*
-drawlambda
(seq
  (letrec
    (iter/1030
       = (function f/1031 param/1041
           (if param/1041
             (let
               (tail/1033 (=) (field 1 param/1041)
                x/1032 (=) (field 0 param/1041))
               (seq (apply f/1031 x/1032) (apply iter/1030 f/1031 tail/1033)))
             0a)))
    (setfield_imm 0 (global Code!) iter/1030))
  (let (list/1034 = [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global Code!) list/1034))
  (let
    (sum/1035
       = (let (sum/1036 = (makemutable 0 0))
           (seq
             (apply (field 0 (global Code!))
               (function x/1037
                 (setfield_imm 0 sum/1036 (+ (field 0 sum/1036) x/1037)))
               (field 1 (global Code!)))
             (field 0 sum/1036))))
    (setfield_imm 2 (global Code!) sum/1035))
  0a)
Approx_closure camlCode__fun_1048 (closed false)
params: 2 args: 2
-dlambda
(seq
  (let
    (iter/1030
       = (function f/1031 param/1045
           (catch
             (let (param/1044 := param/1045)
               (while 1a
                 (catch
                   (let (param/1041 = param/1044)
                     (exit 4
                       (if param/1041
                         (seq (apply f/1031 (field 0 param/1041))
                           (exit 6 (field 1 param/1041)))
                         0a)))
                  with (6 param/1043)
                   (seq (assign param/1044 param/1043) 0a))))
            with (4 result/1046) result/1046)))
    (setfield_imm 0 (global Code!) iter/1030))
  (let (list/1034 = [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global Code!) list/1034))
  (let
    (sum/1035
       = (let (sum/1036 = (makemutable 0 0))
           (seq
             (apply (field 0 (global Code!))
               (function x/1037
                 (setfield_imm 0 sum/1036 (+ (field 0 sum/1036) x/1037)))
               (field 1 (global Code!)))
             (field 0 sum/1036))))
    (setfield_imm 2 (global Code!) sum/1035))
  0a)
Approx_closure camlCode__fun_1048 (closed false)
params: 2 args: 2
-dclosure
*** Clambda: after closure conversion:
(seq
  (let
    (iter/1030 {fun camlCode__iter_1030 {2} closed inline -> ?} = 
       (closure (camlCode__iter_1030(2)  f/1031 param/1045
                  (catch
                    (let (param/1044 {} :=  param/1045)
                      (while 1a
                        (catch
                          (let (param/1041 {} =  param/1044)
                            (exit 4
                              (if param/1041
                                (seq (apply f/1031 (field 0 param/1041))
                                  (exit 6 (field 1 param/1041)))
                                0a)))
                         with (6 param/1043)
                          (seq (assign param/1044 param/1043) 0a))))
                   with (4 result/1046) result/1046)) {0} ))
    (setfield_imm 0 (global camlCode!) iter/1030))
  (let
    (list/1034 {(int 1, (int 2, (int 3, (int 4, (int 5, cstptr 0)))))} = 
       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global camlCode!) list/1034))
  (let
    (sum/1035 {} = 
       (let (sum/1036 {} =  (makemutable 0 0))
         (seq
           (let
             (param/1051 {} =  (field 1 (global camlCode!))
              f/1052 {} = 
                (closure (camlCode__fun_1048(1)  x/1037 env/1050
                           (setfield_imm 0 (field 2 env/1050)
                             (+ (field 0 (field 2 env/1050)) x/1037))) 
                  {0} 
                  sum/1036))
             (catch
               (let (param/1053 {} :=  param/1051)
                 (while 1a
                   (catch
                     (let (param/1054 {} =  param/1053)
                       (exit 4
                         (if param/1054
                           (seq (apply f/1052 (field 0 param/1054))
                             (exit 6 (field 1 param/1054)))
                           0a)))
                    with (6 param/1043)
                     (seq (assign param/1053 param/1043) 0a))))
              with (4 result/1046) result/1046))
           (field 0 sum/1036))))
    (setfield_imm 2 (global camlCode!) sum/1035))
  0a)
Approx_closure camlCode__fun_1048 (closed false)
params: 2 args: 2
*** Clambda: after second inlining:
(seq
  (let
    (iter/1030 {fun camlCode__iter_1030 {2} closed inline -> ?} = 
       (closure (camlCode__iter_1030(2)  f/1031 param/1045
                  (catch
                    (let (param/1044 {} :=  param/1045)
                      (while 1a
                        (catch
                          (let (param/1041 {} =  param/1044)
                            (exit 4
                              (if param/1041
                                (seq (apply f/1031 (field 0 param/1041))
                                  (exit 6 (field 1 param/1041)))
                                0a)))
                         with (6 param/1043)
                          (seq (assign param/1044 param/1043) 0a))))
                   with (4 result/1046) 0a)) {0} ))
    (setfield_imm 0 (global camlCode!) iter/1030))
  (let
    (list/1034 {(int 1, (int 2, (int 3, (int 4, (int 5, cstptr 0)))))} = 
       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global camlCode!) list/1034))
  (let
    (sum/1035 {} = 
       (let (sum/1036 {} =  (makemutable 0 0))
         (seq
           (let
             (param/1051 {} =  (field 1 (global camlCode!))
              f/1052 {} = 
                (closure (camlCode__fun_1048(1)  x/1037 env/1050
                           (setfield_imm 0 (field 2 env/1050)
                             (+ (field 0 (field 2 env/1050)) x/1037))) 
                  {0} 
                  sum/1036))
             (catch
               (let (param/1053 {} :=  param/1051)
                 (while 1a
                   (catch
                     (let (param/1054 {} =  param/1053)
                       (exit 4
                         (if param/1054
                           (seq
                             (let (x/1055 {} =  (field 0 param/1054))
                               (setfield_imm 0 sum/1036
                                 (+ (field 0 sum/1036) x/1055)))
                             (exit 6 (field 1 param/1054)))
                           0a)))
                    with (6 param/1043)
                     (seq (assign param/1053 param/1043) 0a))))
              with (4 result/1046) 0a))
           (field 0 sum/1036))))
    (setfield_imm 2 (global camlCode!) sum/1035))
  0a)

*** Clambda: after simplification:
(seq
  (let
    (iter/1030 {fun camlCode__iter_1030 {2} closed inline -> ?} = 
       (closure (camlCode__iter_1030(2)  f/1031 param/1045
                  (catch
                    (let (param/1044 {} :=  param/1045)
                      (while 1a
                        (catch
                          (let (param/1041 {} =  param/1044)
                            (exit 4
                              (if param/1041
                                (seq (apply f/1031 (field 0 param/1041))
                                  (exit 6 (field 1 param/1041)))
                                0a)))
                         with (6 param/1043)
                          (seq (assign param/1044 param/1043) 0a))))
                   with (4 result/1046) 0a)) {0} ))
    (setfield_imm 0 (global camlCode!) iter/1030))
  (let
    (list/1034 {(int 1, (int 2, (int 3, (int 4, (int 5, cstptr 0)))))} = 
       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global camlCode!) list/1034))
  (let
    (sum/1035 {} = 
       (let (sum/1036 {} =  (makemutable 0 0))
         (seq
           (let
             (param/1051 {} =  (field 1 (global camlCode!))
              f/1052 {} = 
                (closure (camlCode__fun_1048(1)  x/1037 env/1050
                           (setfield_imm 0 (field 2 env/1050)
                             (+ (field 0 (field 2 env/1050)) x/1037))) 
                  {0} 
                  sum/1036))
             (catch
               (let (param/1053 {} :=  param/1051)
                 (while 1a
                   (catch
                     (let (param/1054 {} =  param/1053)
                       (exit 4
                         (if param/1054
                           (seq
                             (let (x/1055 {} =  (field 0 param/1054))
                               (setfield_imm 0 sum/1036
                                 (+ (field 0 sum/1036) x/1055)))
                             (exit 6 (field 1 param/1054)))
                           0a)))
                    with (6 param/1043)
                     (seq (assign param/1053 param/1043) 0a))))
              with (4 result/1046) 0a))
           (field 0 sum/1036))))
    (setfield_imm 2 (global camlCode!) sum/1035))
  0a)


-dcmm
Approx_closure camlCode__fun_1048 (closed false)
params: 2 args: 2
(data int 3072 global "camlCode" "camlCode": skip 24)
(data
 int 3319
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter_1030")
(data
 global "camlCode__1"
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
(function camlCode__iter_1030 (f/1031: addr param/1045: addr)
 (catch
   (let param/1044 param/1045
     (loop
       (catch
         (let param/1041 param/1044
           (exit 4
             (if (!= param/1041 1)
               (seq (app (load f/1031) (load param/1041) f/1031 unit)
                 (exit 6 (load (+a param/1041 8))))
               1a)))
       with(6 param/1043) (assign param/1044 param/1043)))
     1a)
 with(4 result/1046) 1a))

(function camlCode__fun_1048 (x/1037: addr env/1050: addr)
 (store (load (+a env/1050 16))
   (+ (+ (load (load (+a env/1050 16))) x/1037) -1))
 1a)

(function camlCode__entry ()
 (let iter/1030 "camlCode__2" (store "camlCode" iter/1030))
 (let list/1034 "camlCode__1" (store (+a "camlCode" 8) list/1034))
 (let
   sum/1035
     (let sum/1036 (alloc 1024 1)
       (let
         (param/1051 (load (+a "camlCode" 8))
          f/1052 (alloc 3319 "camlCode__fun_1048" 3 sum/1036))
         (catch
           (let param/1053 param/1051
             (loop
               (catch
                 (let param/1054 param/1053
                   (exit 4
                     (if (!= param/1054 1)
                       (seq
                         (let x/1055 (load param/1054)
                           (store sum/1036 (+ (+ (load sum/1036) x/1055) -1)))
                         (exit 6 (load (+a param/1054 8))))
                       1a)))
               with(6 param/1043) (assign param/1053 param/1043))))
         with(4 result/1046) []))
       (load sum/1036))
   (store (+a "camlCode" 16) sum/1035))
 1a)

(data)
-dlinear
Approx_closure camlCode__fun_1048 (closed false)
params: 2 args: 2
*** Linearized code
camlCode__iter_1030:
  spilled-f/42[s0] := f/29[%rax] (spill)
  L101:
  spilled-param/41[s1] := param/34[%rbx] (spill)
  if param/34[%rbx] ==s 1 goto L102
  A/35[%rax] := [param/34[%rbx]]
  f/43[%rbx] := spilled-f/42[s0] (reload)
  A/36[%rdi] := [f/43[%rbx]]
  {spilled-param/41[s1]* spilled-f/42[s0]*}
  call A/36[%rdi] R/0[%rax] R/1[%rbx]
  param/44[%rax] := spilled-param/41[s1] (reload)
  A/37[%rbx] := [param/44[%rax] + 8]
  goto L101
  L102:
  A/38[%rax] := 1
  L100:
  A/40[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__fun_1048:
  A/31[%rdi] := [env/30[%rbx] + 16]
  A/32[%rbx] := [env/30[%rbx] + 16]
  A/33[%rbx] := [A/32[%rbx]]
  I/34[%rax] := A/33[%rbx] + x/29[%rax] + -1
  [A/31[%rdi]] := I/34[%rax]
  A/35[%rax] := 1
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  iter/29[%rbx] := "camlCode__2"
  A/30[%rax] := "camlCode"
  [A/30[%rax]] := iter/29[%rbx]
  list/31[%rbx] := "camlCode__1"
  A/32[%rax] := "camlCode"
  [A/32[%rax] + 8] := list/31[%rbx]
  {}
  sum/33[%rax] := alloc 48
  [sum/33[%rax] + -8] := 1024
  [sum/33[%rax]] := 1
  A/34[%rbx] := "camlCode"
  param/35[%rbx] := [A/34[%rbx] + 8]
  f/36[%rsi] := sum/33[%rax] + 16
  [f/36[%rsi] + -8] := 3319
  A/37[%rdi] := "camlCode__fun_1048"
  [f/36[%rsi]] := A/37[%rdi]
  [f/36[%rsi] + 8] := 3
  [f/36[%rsi] + 16] := sum/33[%rax]
  L107:
  if param/41[%rbx] ==s 1 goto L108
  x/42[%rsi] := [param/41[%rbx]]
  A/43[%rdi] := [sum/33[%rax]]
  I/44[%rdi] := A/43[%rdi] + x/42[%rsi] + -1
  [sum/33[%rax]] := I/44[%rdi]
  A/45[%rbx] := [param/41[%rbx] + 8]
  goto L107
  L108:
  A/46[%rbx] := 1
  L106:
  sum/47[%rbx] := [sum/33[%rax]]
  A/48[%rax] := "camlCode"
  [A/48[%rax] + 16] := sum/47[%rbx]
  A/49[%rax] := 1
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
	.globl	caml_apply3
caml_apply3:
	subq	$24, %rsp
.L135:
	movq	8(%rsi), %rdx
	cmpq	$7, %rdx
	jne	.L134
	movq	16(%rsi), %rdx
	addq	$24, %rsp
	jmp	*%rdx
	.align	4
.L134:
	movq	%rdi, 8(%rsp)
	movq	%rbx, 0(%rsp)
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L136:
	movq	%rax, %rbx
	movq	(%rbx), %rdi
	movq	0(%rsp), %rax
	call	*%rdi
.L137:
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
.L139:
	movq	8(%rdi), %rsi
	cmpq	$5, %rsi
	jne	.L138
	movq	16(%rdi), %rsi
	addq	$8, %rsp
	jmp	*%rsi
	.align	4
.L138:
	movq	%rbx, 0(%rsp)
	movq	(%rdi), %rsi
	movq	%rdi, %rbx
	call	*%rsi
.L140:
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
	.ascii	"\204\225\246\276\0\0\0\222\0\0\0\22\0\0\0P\0\0\0A\240\300*Pervasives0\333r:\27\230\261\42\340\211\31\242\277\355\6%\24\60\204\71\251t<\345\33MN\266\206u\1\65\216t\240\4\4@\240\300$Code0\20"
	.ascii	"\243\364\221d\277\214E[\256\240\205\25\31\256\223\60\234\11\306X\360\366\337\23\206q\201 \15$\2E\240\4\4@\240\300(Std_exit0K<u\217\27kw\366\203\3\37W\376u\277\312\60\366Q}S[\307\65\370C]\227\0\370\324#"
	.ascii	"'\240\4\4@@"
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
	.quad	.L140
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L137
	.word	32
	.word	1
	.word	8
	.align	8
	.quad	.L136
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
	.quad	3072
	.globl	camlCode
camlCode:
	.space	24
	.data
	.quad	3319
camlCode__2:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__iter_1030
	.data
	.globl	camlCode__1
	.quad	2048
camlCode__1:
	.quad	3
	.quad	.L100003
	.quad	2048
.L100003:
	.quad	5
	.quad	.L100004
	.quad	2048
.L100004:
	.quad	7
	.quad	.L100005
	.quad	2048
.L100005:
	.quad	9
	.quad	.L100006
	.quad	2048
.L100006:
	.quad	11
	.quad	1
	.text
	.align	16
	.globl	camlCode__iter_1030
camlCode__iter_1030:
	subq	$24, %rsp
.L103:
	movq	%rax, 0(%rsp)
.L101:
	movq	%rbx, 8(%rsp)
	cmpq	$1, %rbx
	je	.L102
	movq	(%rbx), %rax
	movq	0(%rsp), %rbx
	movq	(%rbx), %rdi
	call	*%rdi
.L104:
	movq	8(%rsp), %rax
	movq	8(%rax), %rbx
	jmp	.L101
	.align	4
.L102:
	movq	$1, %rax
.L100:
	movq	$1, %rax
	addq	$24, %rsp
	ret
	.type	camlCode__iter_1030,@function
	.size	camlCode__iter_1030,.-camlCode__iter_1030
	.text
	.align	16
	.globl	camlCode__fun_1048
camlCode__fun_1048:
.L105:
	movq	16(%rbx), %rdi
	movq	16(%rbx), %rbx
	movq	(%rbx), %rbx
	leaq	-1(%rbx, %rax), %rax
	movq	%rax, (%rdi)
	movq	$1, %rax
	ret
	.type	camlCode__fun_1048,@function
	.size	camlCode__fun_1048,.-camlCode__fun_1048
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L109:
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	$48, %rax
	call	caml_allocN@PLT
.L110:
	leaq	8(%r15), %rax
	movq	$1024, -8(%rax)
	movq	$1, (%rax)
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	8(%rbx), %rbx
	leaq	16(%rax), %rsi
	movq	$3319, -8(%rsi)
	movq	camlCode__fun_1048@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rsi)
	movq	$3, 8(%rsi)
	movq	%rax, 16(%rsi)
.L107:
	cmpq	$1, %rbx
	je	.L108
	movq	(%rbx), %rsi
	movq	(%rax), %rdi
	leaq	-1(%rdi, %rsi), %rdi
	movq	%rdi, (%rax)
	movq	8(%rbx), %rbx
	jmp	.L107
.L108:
	movq	$1, %rbx
.L106:
	movq	(%rax), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 16(%rax)
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
	.quad	2
	.quad	.L110
	.word	16
	.word	0
	.align	8
	.quad	.L104
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

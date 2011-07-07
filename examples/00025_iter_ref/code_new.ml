

let rec iter f = function
    [] -> ()
  | x :: tail -> f x; iter f tail

let list = [1;2;3;4;5]

let sum list =
  let sum = ref 0. in
  iter (fun x -> sum := !sum +. x) list;
    !sum *. 1.

let _ =
  let array = Array.create 5_000_000 1. in
  let list = Array.to_list array in
  for i = 0 to 500 do
    ignore (sum list)
  done

(*
-drawlambda
(seq
  (letrec
    (iter/1030
       = (function f/1031 param/1045
           (if param/1045
             (let
               (tail/1033 (=) (field 1 param/1045)
                x/1032 (=) (field 0 param/1045))
               (seq (apply f/1031 x/1032) (apply iter/1030 f/1031 tail/1033)))
             0a)))
    (setfield_imm 0 (global Code!) iter/1030))
  (let (list/1034 = [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global Code!) list/1034))
  (let
    (sum/1035
       = (function list/1036
           (let (sum/1037 = (makemutable 0 0.))
             (seq
               (apply (field 0 (global Code!))
                 (function x/1038
                   (setfield_ptr 0 sum/1037 (+. (field 0 sum/1037) x/1038)))
                 list/1036)
               (*. (field 0 sum/1037) 1.)))))
    (setfield_imm 2 (global Code!) sum/1035))
  (let
    (array/1039 = (caml_make_vect 5000000 1.)
     list/1040 = (apply (field 9 (global Array!)) array/1039))
    (for i/1041 0 to 500 (ignore (apply (field 2 (global Code!)) list/1040))))
  0a)
Approx_closure camlCode__fun_1053 (closed false)
params: 2 args: 2
-dlambda
(seq
  (let
    (iter/1030
       = (function f/1031 param/1049
           (catch
             (let (param/1048 := param/1049)
               (while 1a
                 (catch
                   (let (param/1045 = param/1048)
                     (exit 6
                       (if param/1045
                         (seq (apply f/1031 (field 0 param/1045))
                           (exit 8 (field 1 param/1045)))
                         0a)))
                  with (8 param/1047)
                   (seq (assign param/1048 param/1047) 0a))))
            with (6 result/1050) result/1050)))
    (setfield_imm 0 (global Code!) iter/1030))
  (let (list/1034 = [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global Code!) list/1034))
  (let
    (sum/1035
       = (function list/1036
           (let (sum/1037 = (makemutable 0 0.))
             (seq
               (apply (field 0 (global Code!))
                 (function x/1038
                   (setfield_ptr 0 sum/1037 (+. (field 0 sum/1037) x/1038)))
                 list/1036)
               (*. (field 0 sum/1037) 1.)))))
    (setfield_imm 2 (global Code!) sum/1035))
  (let
    (array/1039 = (caml_make_vect 5000000 1.)
     list/1040 = (apply (field 9 (global Array!)) array/1039))
    (for i/1041 0 to 500 (ignore (apply (field 2 (global Code!)) list/1040))))
  0a)
Approx_closure camlCode__fun_1053 (closed false)
params: 2 args: 2
-dclosure
*** Clambda: after closure conversion:
(seq
  (let
    (iter/1030 {fun camlCode__iter_1030 {2} closed inline -> ?} = 
       (closure (camlCode__iter_1030(2)  f/1031 param/1049
                  (catch
                    (let (param/1048 {} :=  param/1049)
                      (while 1a
                        (catch
                          (let (param/1045 {} =  param/1048)
                            (exit 6
                              (if param/1045
                                (seq (apply f/1031 (field 0 param/1045))
                                  (exit 8 (field 1 param/1045)))
                                0a)))
                         with (8 param/1047)
                          (seq (assign param/1048 param/1047) 0a))))
                   with (6 result/1050) result/1050)) {0} ))
    (setfield_imm 0 (global camlCode!) iter/1030))
  (let
    (list/1034 {(int 1, (int 2, (int 3, (int 4, (int 5, cstptr 0)))))} = 
       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global camlCode!) list/1034))
  (let
    (sum/1035 {fun camlCode__sum_1035 {1} closed -> ?} = 
       (closure (camlCode__sum_1035(1)  list/1036
                  (let (sum/1037 {} =  (makemutable 0 0.))
                    (seq
                      (let
                        (f/1056 {} = 
                           (closure (camlCode__fun_1053(1)  x/1038 env/1055
                                      (setfield_ptr 0 (field 2 env/1055)
                                        (+. (field 0 (field 2 env/1055))
                                          x/1038))) {0} 
                                                    sum/1037))
                        (catch
                          (let (param/1057 {} :=  list/1036)
                            (while 1a
                              (catch
                                (let (param/1058 {} =  param/1057)
                                  (exit 6
                                    (if param/1058
                                      (seq
                                        (apply f/1056 (field 0 param/1058))
                                        (exit 8 (field 1 param/1058)))
                                      0a)))
                               with (8 param/1047)
                                (seq (assign param/1057 param/1047) 0a))))
                         with (6 result/1050) result/1050))
                      (*. (field 0 sum/1037) 1.)))) {0} ))
    (setfield_imm 2 (global camlCode!) sum/1035))
  (let
    (array/1039 {} =  (caml_make_vect 5000000 1.)
     list/1040 {} =  (camlArray__to_list_1121  array/1039))
    (for i/1041 0 to 500 (ignore (camlCode__sum_1035  list/1040))))
  0a)
Approx_closure camlCode__fun_1053 (closed false)
params: 2 args: 2
*** Clambda: after second inlining:
(seq
  (let
    (iter/1030 {fun camlCode__iter_1030 {2} closed inline -> ?} = 
       (closure (camlCode__iter_1030(2)  f/1031 param/1049
                  (catch
                    (let (param/1048 {} :=  param/1049)
                      (while 1a
                        (catch
                          (let (param/1045 {} =  param/1048)
                            (exit 6
                              (if param/1045
                                (seq (apply f/1031 (field 0 param/1045))
                                  (exit 8 (field 1 param/1045)))
                                0a)))
                         with (8 param/1047)
                          (seq (assign param/1048 param/1047) 0a))))
                   with (6 result/1050) 0a)) {0} ))
    (setfield_imm 0 (global camlCode!) iter/1030))
  (let
    (list/1034 {(int 1, (int 2, (int 3, (int 4, (int 5, cstptr 0)))))} = 
       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global camlCode!) list/1034))
  (let
    (sum/1035 {fun camlCode__sum_1035 {1} closed -> ?} = 
       (closure (camlCode__sum_1035(1)  list/1036
                  (let (sum/1037 {} =  (makemutable 0 0.))
                    (seq
                      (let
                        (f/1056 {} = 
                           (closure (camlCode__fun_1053(1)  x/1038 env/1055
                                      (setfield_ptr 0 (field 2 env/1055)
                                        (+. (field 0 (field 2 env/1055))
                                          x/1038))) {0} 
                                                    sum/1037))
                        (catch
                          (let (param/1057 {} :=  list/1036)
                            (while 1a
                              (catch
                                (let (param/1058 {} =  param/1057)
                                  (exit 6
                                    (if param/1058
                                      (seq
                                        (let
                                          (x/1059 {} =  (field 0 param/1058))
                                          (setfield_ptr 0 sum/1037
                                            (+. (field 0 sum/1037) x/1059)))
                                        (exit 8 (field 1 param/1058)))
                                      0a)))
                               with (8 param/1047)
                                (seq (assign param/1057 param/1047) 0a))))
                         with (6 result/1050) 0a))
                      (*. (field 0 sum/1037) 1.)))) {0} ))
    (setfield_imm 2 (global camlCode!) sum/1035))
  (let
    (array/1039 {} =  (caml_make_vect 5000000 1.)
     list/1040 {} =  (camlArray__to_list_1121  array/1039))
    (for i/1041 0 to 500 (ignore (camlCode__sum_1035  list/1040))))
  0a)

*** Clambda: after closure removal:
(seq
  (let
    (iter/1030 {fun camlCode__iter_1030 {2} closed inline -> ?} = 
       (closure (camlCode__iter_1030(2)  f/1031 param/1049
                  (catch
                    (let (param/1048 {} :=  param/1049)
                      (while 1a
                        (catch
                          (let (param/1045 {} =  param/1048)
                            (exit 6
                              (if param/1045
                                (seq (apply f/1031 (field 0 param/1045))
                                  (exit 8 (field 1 param/1045)))
                                0a)))
                         with (8 param/1047)
                          (seq (assign param/1048 param/1047) 0a))))
                   with (6 result/1050) 0a)) {0} ))
    (setfield_imm 0 (global camlCode!) iter/1030))
  (let
    (list/1034 {(int 1, (int 2, (int 3, (int 4, (int 5, cstptr 0)))))} = 
       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global camlCode!) list/1034))
  (let
    (sum/1035 {fun camlCode__sum_1035 {1} closed -> ?} = 
       (closure (camlCode__sum_1035(1)  list/1036
                  (let (sum/1037 {} =  (makemutable 0 0.))
                    (seq
                      (catch
                        (let (param/1057 {} :=  list/1036)
                          (while 1a
                            (catch
                              (let (param/1058 {} =  param/1057)
                                (exit 6
                                  (if param/1058
                                    (seq
                                      (let
                                        (x/1059 {} =  (field 0 param/1058))
                                        (setfield_ptr 0 sum/1037
                                          (+. (field 0 sum/1037) x/1059)))
                                      (exit 8 (field 1 param/1058)))
                                    0a)))
                             with (8 param/1047)
                              (seq (assign param/1057 param/1047) 0a))))
                       with (6 result/1050) 0a)
                      (*. (field 0 sum/1037) 1.)))) {0} ))
    (setfield_imm 2 (global camlCode!) sum/1035))
  (let
    (array/1039 {} =  (caml_make_vect 5000000 1.)
     list/1040 {} =  (camlArray__to_list_1121  array/1039))
    (for i/1041 0 to 500 (ignore (camlCode__sum_1035  list/1040))))
  0a)

*** Clambda: after simplification:
(seq
  (let
    (iter/1030 {fun camlCode__iter_1030 {2} closed inline -> ?} = 
       (closure (camlCode__iter_1030(2)  f/1031 param/1049
                  (catch
                    (let (param/1048 {} :=  param/1049)
                      (while 1a
                        (catch
                          (let (param/1045 {} =  param/1048)
                            (exit 6
                              (if param/1045
                                (seq (apply f/1031 (field 0 param/1045))
                                  (exit 8 (field 1 param/1045)))
                                0a)))
                         with (8 param/1047)
                          (seq (assign param/1048 param/1047) 0a))))
                   with (6 result/1050) 0a)) {0} ))
    (setfield_imm 0 (global camlCode!) iter/1030))
  (let
    (list/1034 {(int 1, (int 2, (int 3, (int 4, (int 5, cstptr 0)))))} = 
       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global camlCode!) list/1034))
  (let
    (sum/1035 {fun camlCode__sum_1035 {1} closed -> ?} = 
       (closure (camlCode__sum_1035(1)  list/1036
                  (let (sum/1037 {} :=  0.)
                    (seq
                      (catch
                        (let (param/1057 {} :=  list/1036)
                          (while 1a
                            (catch
                              (let (param/1058 {} =  param/1057)
                                (exit 6
                                  (if param/1058
                                    (seq
                                      (let
                                        (x/1059 {} =  (field 0 param/1058))
                                        (assign sum/1037
                                          (+. sum/1037 x/1059)))
                                      (exit 8 (field 1 param/1058)))
                                    0a)))
                             with (8 param/1047)
                              (seq (assign param/1057 param/1047) 0a))))
                       with (6 result/1050) 0a)
                      (*. sum/1037 1.)))) {0} ))
    (setfield_imm 2 (global camlCode!) sum/1035))
  (let
    (array/1039 {} =  (caml_make_vect 5000000 1.)
     list/1040 {} =  (camlArray__to_list_1121  array/1039))
    (for i/1041 0 to 500 (ignore (camlCode__sum_1035  list/1040))))
  0a)


-dcmm
Approx_closure camlCode__fun_1053 (closed false)
params: 2 args: 2
(data int 3072 global "camlCode" "camlCode": skip 24)
(data int 2295 "camlCode__4": addr "camlCode__sum_1035" int 3)
(data
 int 3319
 "camlCode__5":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter_1030")
(data global "camlCode__2" int 1277 "camlCode__2": double 0.)
(data global "camlCode__3" int 1277 "camlCode__3": double 1.)
(data
 global "camlCode__1"
 int 2048
 "camlCode__1":
 int 3
 addr L6
 int 2048
 L6:
 int 5
 addr L7
 int 2048
 L7:
 int 7
 addr L8
 int 2048
 L8:
 int 9
 addr L9
 int 2048
 L9:
 int 11
 int 1)
(function camlCode__iter_1030 (f/1031: addr param/1049: addr)
 (catch
   (let param/1048 param/1049
     (loop
       (catch
         (let param/1045 param/1048
           (exit 6
             (if (!= param/1045 1)
               (seq (app (load f/1031) (load param/1045) f/1031 unit)
                 (exit 8 (load (+a param/1045 8))))
               1a)))
       with(8 param/1047) (assign param/1048 param/1047)))
     1a)
 with(6 result/1050) 1a))

(function camlCode__sum_1035 (list/1036: addr)
 (let sum/1061 0.
   (catch
     (let param/1057 list/1036
       (loop
         (catch
           (let param/1058 param/1057
             (exit 6
               (if (!= param/1058 1)
                 (seq
                   (let x/1059 (load param/1058)
                     (assign sum/1061 (+f sum/1061 (load float64u x/1059))))
                   (exit 8 (load (+a param/1058 8))))
                 1a)))
         with(8 param/1047) (assign param/1057 param/1047))))
   with(6 result/1050) []) (alloc 1277 (*f sum/1061 1.))))

(function camlCode__entry ()
 (let iter/1030 "camlCode__5" (store "camlCode" iter/1030))
 (let list/1034 "camlCode__1" (store (+a "camlCode" 8) list/1034))
 (let sum/1035 "camlCode__4" (store (+a "camlCode" 16) sum/1035))
 (let
   (array/1039 (extcall "caml_make_vect" 10000001 "camlCode__3" addr)
    list/1040 (app "camlArray__to_list_1121" array/1039 addr) i/1041 1)
   (catch
     (if (> i/1041 1001) (exit 9)
       (loop (app "camlCode__sum_1035" list/1040 unit)
         (let i/1060 i/1041 (assign i/1041 (+ i/1041 2))
           (if (== i/1060 1001) (exit 9) []))))
   with(9) []))
 1a)

(data)
-dlinear
Approx_closure camlCode__fun_1053 (closed false)
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
camlCode__sum_1035:
  sum/30[%xmm0] := 0.
  L106:
  if param/34[%rax] ==s 1 goto L107
  x/35[%rbx] := [param/34[%rax]]
  F/36[%xmm0] := F/36[%xmm0] +f float64[x/35[%rbx]]
  A/37[%rax] := [param/34[%rax] + 8]
  goto L106
  L107:
  A/38[%rax] := 1
  L105:
  {sum/30[%xmm0]}
  A/39[%rax] := alloc 16
  [A/39[%rax] + -8] := 1277
  F/40[%xmm1] := 1.
  F/41[%xmm0] := F/41[%xmm0] *f F/40[%xmm1]
  float64u[A/39[%rax]] := F/41[%xmm0]
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  iter/29[%rbx] := "camlCode__5"
  A/30[%rax] := "camlCode"
  [A/30[%rax]] := iter/29[%rbx]
  list/31[%rbx] := "camlCode__1"
  A/32[%rax] := "camlCode"
  [A/32[%rax] + 8] := list/31[%rbx]
  sum/33[%rbx] := "camlCode__4"
  A/34[%rax] := "camlCode"
  [A/34[%rax] + 16] := sum/33[%rbx]
  A/35[%rsi] := "camlCode__3"
  I/36[%rdi] := 10000001
  {}
  R/0[%rax] := extcall "caml_make_vect" R/2[%rdi] R/3[%rsi] (noalloc)
  {}
  R/0[%rax] := call "camlArray__to_list_1121" R/0[%rax]
  i/39[%rbx] := 1
  if i/39[%rbx] >s 1001 goto L113
  spilled-i/43[s1] := i/39[%rbx] (spill)
  spilled-list/44[s0] := list/38[%rax] (spill)
  L114:
  list/45[%rax] := spilled-list/44[s0] (reload)
  {spilled-i/43[s1] spilled-list/44[s0]*}
  call "camlCode__sum_1035" R/0[%rax]
  i/46[%rax] := spilled-i/43[s1] (reload)
  i/40[%rbx] := i/46[%rax]
  I/41[%rax] := I/41[%rax] + 2
  spilled-i/43[s1] := i/46[%rax] (spill)
  if i/40[%rbx] !=s 1001 goto L114
  L113:
  A/42[%rax] := 1
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
	call	camlArray__entry@PLT
.L102:
	movq	caml_globals_inited@GOTPCREL(%rip), %rax
	addq	$1, (%rax)
	call	camlCode__entry@PLT
.L103:
	movq	caml_globals_inited@GOTPCREL(%rip), %rax
	addq	$1, (%rax)
	call	camlStd_exit__entry@PLT
.L104:
	movq	caml_globals_inited@GOTPCREL(%rip), %rax
	addq	$1, (%rax)
	movq	$1, %rax
	addq	$8, %rsp
	ret
	.type	caml_program,@function
	.size	caml_program,.-caml_program
	.text
	.align	16
	.globl	caml_curry7
caml_curry7:
	subq	$8, %rsp
.L105:
	movq	%rax, %rsi
.L106:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L107
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry7_1@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$13, 8(%rax)
	movq	caml_curry7_1_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L107:	call	caml_call_gc@PLT
.L108:	jmp	.L106
	.type	caml_curry7,@function
	.size	caml_curry7,.-caml_curry7
	.text
	.align	16
	.globl	caml_curry7_1_app
caml_curry7_1_app:
	subq	$24, %rsp
.L109:
	movq	%rax, 8(%rsp)
	movq	%rbx, 0(%rsp)
	movq	%rdi, %r13
	movq	%rsi, %r12
	movq	%rdx, %rbp
	movq	%rcx, %r11
	movq	32(%r8), %r9
	movq	24(%r8), %rax
	movq	16(%r9), %r10
	movq	8(%rsp), %rbx
	movq	0(%rsp), %rdi
	movq	%r13, %rsi
	movq	%r12, %rdx
	movq	%rbp, %rcx
	movq	%r11, %r8
	addq	$24, %rsp
	jmp	*%r10
	.type	caml_curry7_1_app,@function
	.size	caml_curry7_1_app,.-caml_curry7_1_app
	.text
	.align	16
	.globl	caml_curry7_1
caml_curry7_1:
	subq	$8, %rsp
.L110:
	movq	%rax, %rsi
.L111:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L112
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry7_2@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$11, 8(%rax)
	movq	caml_curry7_2_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L112:	call	caml_call_gc@PLT
.L113:	jmp	.L111
	.type	caml_curry7_1,@function
	.size	caml_curry7_1,.-caml_curry7_1
	.text
	.align	16
	.globl	caml_curry7_2_app
caml_curry7_2_app:
.L114:
	movq	%rax, %r13
	movq	%rbx, %r12
	movq	%rdi, %rbp
	movq	%rsi, %r11
	movq	%rdx, %r8
	movq	32(%rcx), %rax
	movq	32(%rax), %r9
	movq	24(%rcx), %rbx
	movq	24(%rax), %rax
	movq	16(%r9), %r10
	movq	%r13, %rdi
	movq	%r12, %rsi
	movq	%rbp, %rdx
	movq	%r11, %rcx
	jmp	*%r10
	.type	caml_curry7_2_app,@function
	.size	caml_curry7_2_app,.-caml_curry7_2_app
	.text
	.align	16
	.globl	caml_curry7_2
caml_curry7_2:
	subq	$8, %rsp
.L115:
	movq	%rax, %rsi
.L116:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L117
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry7_3@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$9, 8(%rax)
	movq	caml_curry7_3_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L117:	call	caml_call_gc@PLT
.L118:	jmp	.L116
	.type	caml_curry7_2,@function
	.size	caml_curry7_2,.-caml_curry7_2
	.text
	.align	16
	.globl	caml_curry7_3_app
caml_curry7_3_app:
.L119:
	movq	%rax, %rbp
	movq	%rbx, %r11
	movq	%rdi, %rcx
	movq	%rsi, %r8
	movq	32(%rdx), %rbx
	movq	32(%rbx), %rax
	movq	32(%rax), %r9
	movq	24(%rdx), %rdi
	movq	24(%rbx), %rbx
	movq	24(%rax), %rax
	movq	16(%r9), %r10
	movq	%rbp, %rsi
	movq	%r11, %rdx
	jmp	*%r10
	.type	caml_curry7_3_app,@function
	.size	caml_curry7_3_app,.-caml_curry7_3_app
	.text
	.align	16
	.globl	caml_curry7_3
caml_curry7_3:
	subq	$8, %rsp
.L120:
	movq	%rax, %rsi
.L121:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L122
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry7_4@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$7, 8(%rax)
	movq	caml_curry7_4_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L122:	call	caml_call_gc@PLT
.L123:	jmp	.L121
	.type	caml_curry7_3,@function
	.size	caml_curry7_3,.-caml_curry7_3
	.text
	.align	16
	.globl	caml_curry7_4_app
caml_curry7_4_app:
.L124:
	movq	%rax, %rdx
	movq	%rbx, %rcx
	movq	%rdi, %r8
	movq	32(%rsi), %rdi
	movq	32(%rdi), %rbx
	movq	32(%rbx), %rax
	movq	32(%rax), %r9
	movq	24(%rsi), %rsi
	movq	24(%rdi), %rdi
	movq	24(%rbx), %rbx
	movq	24(%rax), %rax
	movq	16(%r9), %r10
	jmp	*%r10
	.type	caml_curry7_4_app,@function
	.size	caml_curry7_4_app,.-caml_curry7_4_app
	.text
	.align	16
	.globl	caml_curry7_4
caml_curry7_4:
	subq	$8, %rsp
.L125:
	movq	%rax, %rsi
.L126:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L127
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry7_5@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$5, 8(%rax)
	movq	caml_curry7_5_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L127:	call	caml_call_gc@PLT
.L128:	jmp	.L126
	.type	caml_curry7_4,@function
	.size	caml_curry7_4,.-caml_curry7_4
	.text
	.align	16
	.globl	caml_curry7_5_app
caml_curry7_5_app:
.L129:
	movq	%rax, %rcx
	movq	%rbx, %r8
	movq	32(%rdi), %rsi
	movq	32(%rsi), %r10
	movq	32(%r10), %rbx
	movq	32(%rbx), %rax
	movq	32(%rax), %r9
	movq	24(%rdi), %rdx
	movq	24(%rsi), %rsi
	movq	24(%r10), %rdi
	movq	24(%rbx), %rbx
	movq	24(%rax), %rax
	movq	16(%r9), %r10
	jmp	*%r10
	.type	caml_curry7_5_app,@function
	.size	caml_curry7_5_app,.-caml_curry7_5_app
	.text
	.align	16
	.globl	caml_curry7_5
caml_curry7_5:
	subq	$8, %rsp
.L130:
	movq	%rax, %rsi
.L131:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L132
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry7_6@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L132:	call	caml_call_gc@PLT
.L133:	jmp	.L131
	.type	caml_curry7_5,@function
	.size	caml_curry7_5,.-caml_curry7_5
	.text
	.align	16
	.globl	caml_curry7_6
caml_curry7_6:
.L134:
	movq	%rax, %r8
	movq	24(%rbx), %rdx
	movq	32(%rdx), %rsi
	movq	32(%rsi), %rdi
	movq	32(%rdi), %r10
	movq	32(%r10), %rax
	movq	32(%rax), %r9
	movq	16(%rbx), %rcx
	movq	24(%rdx), %rdx
	movq	24(%rsi), %rsi
	movq	24(%rdi), %rdi
	movq	24(%r10), %rbx
	movq	24(%rax), %rax
	movq	16(%r9), %r10
	jmp	*%r10
	.type	caml_curry7_6,@function
	.size	caml_curry7_6,.-caml_curry7_6
	.text
	.align	16
	.globl	caml_curry5
caml_curry5:
	subq	$8, %rsp
.L135:
	movq	%rax, %rsi
.L136:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L137
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry5_1@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$9, 8(%rax)
	movq	caml_curry5_1_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L137:	call	caml_call_gc@PLT
.L138:	jmp	.L136
	.type	caml_curry5,@function
	.size	caml_curry5,.-caml_curry5
	.text
	.align	16
	.globl	caml_curry5_1_app
caml_curry5_1_app:
.L139:
	movq	%rax, %rbp
	movq	%rbx, %r11
	movq	%rdi, %r10
	movq	%rsi, %r9
	movq	32(%rdx), %rcx
	movq	24(%rdx), %rax
	movq	16(%rcx), %r8
	movq	%rbp, %rbx
	movq	%r11, %rdi
	movq	%r10, %rsi
	movq	%r9, %rdx
	jmp	*%r8
	.type	caml_curry5_1_app,@function
	.size	caml_curry5_1_app,.-caml_curry5_1_app
	.text
	.align	16
	.globl	caml_curry5_1
caml_curry5_1:
	subq	$8, %rsp
.L140:
	movq	%rax, %rsi
.L141:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L142
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry5_2@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$7, 8(%rax)
	movq	caml_curry5_2_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L142:	call	caml_call_gc@PLT
.L143:	jmp	.L141
	.type	caml_curry5_1,@function
	.size	caml_curry5_1,.-caml_curry5_1
	.text
	.align	16
	.globl	caml_curry5_2_app
caml_curry5_2_app:
.L144:
	movq	%rax, %r10
	movq	%rbx, %r9
	movq	%rdi, %rdx
	movq	32(%rsi), %rax
	movq	32(%rax), %rcx
	movq	24(%rsi), %rbx
	movq	24(%rax), %rax
	movq	16(%rcx), %r8
	movq	%r10, %rdi
	movq	%r9, %rsi
	jmp	*%r8
	.type	caml_curry5_2_app,@function
	.size	caml_curry5_2_app,.-caml_curry5_2_app
	.text
	.align	16
	.globl	caml_curry5_2
caml_curry5_2:
	subq	$8, %rsp
.L145:
	movq	%rax, %rsi
.L146:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L147
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry5_3@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$5, 8(%rax)
	movq	caml_curry5_3_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L147:	call	caml_call_gc@PLT
.L148:	jmp	.L146
	.type	caml_curry5_2,@function
	.size	caml_curry5_2,.-caml_curry5_2
	.text
	.align	16
	.globl	caml_curry5_3_app
caml_curry5_3_app:
.L149:
	movq	%rax, %rsi
	movq	%rbx, %rdx
	movq	32(%rdi), %rbx
	movq	32(%rbx), %rax
	movq	32(%rax), %rcx
	movq	24(%rdi), %rdi
	movq	24(%rbx), %rbx
	movq	24(%rax), %rax
	movq	16(%rcx), %r8
	jmp	*%r8
	.type	caml_curry5_3_app,@function
	.size	caml_curry5_3_app,.-caml_curry5_3_app
	.text
	.align	16
	.globl	caml_curry5_3
caml_curry5_3:
	subq	$8, %rsp
.L150:
	movq	%rax, %rsi
.L151:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L152
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry5_4@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L152:	call	caml_call_gc@PLT
.L153:	jmp	.L151
	.type	caml_curry5_3,@function
	.size	caml_curry5_3,.-caml_curry5_3
	.text
	.align	16
	.globl	caml_curry5_4
caml_curry5_4:
.L154:
	movq	%rax, %rdx
	movq	24(%rbx), %rdi
	movq	32(%rdi), %r8
	movq	32(%r8), %rax
	movq	32(%rax), %rcx
	movq	16(%rbx), %rsi
	movq	24(%rdi), %rdi
	movq	24(%r8), %rbx
	movq	24(%rax), %rax
	movq	16(%rcx), %r8
	jmp	*%r8
	.type	caml_curry5_4,@function
	.size	caml_curry5_4,.-caml_curry5_4
	.text
	.align	16
	.globl	caml_curry4
caml_curry4:
	subq	$8, %rsp
.L155:
	movq	%rax, %rsi
.L156:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L157
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
.L157:	call	caml_call_gc@PLT
.L158:	jmp	.L156
	.type	caml_curry4,@function
	.size	caml_curry4,.-caml_curry4
	.text
	.align	16
	.globl	caml_curry4_1_app
caml_curry4_1_app:
.L159:
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
.L160:
	movq	%rax, %rsi
.L161:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L162
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
.L162:	call	caml_call_gc@PLT
.L163:	jmp	.L161
	.type	caml_curry4_1,@function
	.size	caml_curry4_1,.-caml_curry4_1
	.text
	.align	16
	.globl	caml_curry4_2_app
caml_curry4_2_app:
.L164:
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
.L165:
	movq	%rax, %rsi
.L166:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L167
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry4_3@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L167:	call	caml_call_gc@PLT
.L168:	jmp	.L166
	.type	caml_curry4_2,@function
	.size	caml_curry4_2,.-caml_curry4_2
	.text
	.align	16
	.globl	caml_curry4_3
caml_curry4_3:
.L169:
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
.L170:
	movq	%rax, %rsi
.L171:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L172
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
.L172:	call	caml_call_gc@PLT
.L173:	jmp	.L171
	.type	caml_curry3,@function
	.size	caml_curry3,.-caml_curry3
	.text
	.align	16
	.globl	caml_curry3_1_app
caml_curry3_1_app:
.L174:
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
.L175:
	movq	%rax, %rsi
.L176:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L177
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry3_2@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L177:	call	caml_call_gc@PLT
.L178:	jmp	.L176
	.type	caml_curry3_1,@function
	.size	caml_curry3_1,.-caml_curry3_1
	.text
	.align	16
	.globl	caml_curry3_2
caml_curry3_2:
.L179:
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
.L180:
	movq	%rax, %rsi
.L181:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L182
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry2_1@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L182:	call	caml_call_gc@PLT
.L183:	jmp	.L181
	.type	caml_curry2,@function
	.size	caml_curry2,.-caml_curry2
	.text
	.align	16
	.globl	caml_curry2_1
caml_curry2_1:
.L184:
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
.L186:
	movq	8(%rsi), %rdx
	cmpq	$7, %rdx
	jne	.L185
	movq	16(%rsi), %rdx
	addq	$24, %rsp
	jmp	*%rdx
	.align	4
.L185:
	movq	%rdi, 8(%rsp)
	movq	%rbx, 0(%rsp)
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L187:
	movq	%rax, %rbx
	movq	(%rbx), %rdi
	movq	0(%rsp), %rax
	call	*%rdi
.L188:
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
.L190:
	movq	8(%rdi), %rsi
	cmpq	$5, %rsi
	jne	.L189
	movq	16(%rdi), %rsi
	addq	$8, %rsp
	jmp	*%rsi
	.align	4
.L189:
	movq	%rbx, 0(%rsp)
	movq	(%rdi), %rsi
	movq	%rdi, %rbx
	call	*%rsi
.L191:
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
	.quad	camlArray
	.quad	camlCode
	.quad	camlStd_exit
	.quad	0
	.data
	.globl	caml_globals_map
	.quad	27900
caml_globals_map:
	.ascii	"\204\225\246\276\0\0\0\300\0\0\0\30\0\0\0j\0\0\0V\240\300*Pervasives0\333r:\27\230\261\42\340\211\31\242\277\355\6%\24\60\204\71\251t<\345\33MN\266\206u\1\65\216t\240\4\4@\240\300%Array0"
	.ascii	"r\10H\340\265\10'8\5\357\70\330\204\245v\30\60\13\223S\305&\266\225n\24\243cg \271\16t\240\4\4@\240\300$Code0\276\224\63\64\242\200`l\307\352s\231Y\24s\267\60\225\257=\6\3\332M!\340~\346$\201\277\337k\240\4"
	.ascii	"\4@\240\300(Std_exit0K<u\217\27kw\366\203\3\37W\376u\277\312\60\366Q}S[\307\65\370C]\227\0\370\324#'\240\4\4@@"
	.space	3
	.byte	3
	.data
	.globl	caml_data_segments
caml_data_segments:
	.quad	caml_startup__data_begin
	.quad	caml_startup__data_end
	.quad	camlPervasives__data_begin
	.quad	camlPervasives__data_end
	.quad	camlArray__data_begin
	.quad	camlArray__data_end
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
	.quad	camlArray__code_begin
	.quad	camlArray__code_end
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
	.quad	camlArray__frametable
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
	.quad	23
	.quad	.L191
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L188
	.word	32
	.word	1
	.word	8
	.align	8
	.quad	.L187
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.quad	.L183
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L178
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L173
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L168
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L163
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L158
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L153
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L148
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L143
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L138
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L133
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L128
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L123
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L118
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L113
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L108
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L104
	.word	16
	.word	0
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
	.quad	2295
camlCode__4:
	.quad	camlCode__sum_1035
	.quad	3
	.data
	.quad	3319
camlCode__5:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__iter_1030
	.data
	.globl	camlCode__2
	.quad	1277
camlCode__2:
	.quad	0x0
	.data
	.globl	camlCode__3
	.quad	1277
camlCode__3:
	.quad	0x3ff0000000000000
	.data
	.globl	camlCode__1
	.quad	2048
camlCode__1:
	.quad	3
	.quad	.L100006
	.quad	2048
.L100006:
	.quad	5
	.quad	.L100007
	.quad	2048
.L100007:
	.quad	7
	.quad	.L100008
	.quad	2048
.L100008:
	.quad	9
	.quad	.L100009
	.quad	2048
.L100009:
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
	.globl	camlCode__sum_1035
camlCode__sum_1035:
	subq	$8, %rsp
.L108:
	xorpd	%xmm0, %xmm0
.L106:
	cmpq	$1, %rax
	je	.L107
	movq	(%rax), %rbx
	addsd	(%rbx), %xmm0
	movq	8(%rax), %rax
	jmp	.L106
	.align	4
.L107:
	movq	$1, %rax
.L105:
.L109:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L110
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	movlpd	.L112(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L110:	call	caml_call_gc@PLT
.L111:	jmp	.L109
	.type	camlCode__sum_1035,@function
	.size	camlCode__sum_1035,.-camlCode__sum_1035
	.section	.rodata.cst8,"a",@progbits
.L112:	.quad	0x3ff0000000000000
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$24, %rsp
.L115:
	movq	camlCode__5@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	camlCode__4@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 16(%rax)
	movq	camlCode__3@GOTPCREL(%rip), %rsi
	movq	$10000001, %rdi
	movq	caml_make_vect@GOTPCREL(%rip), %rax
	call	caml_c_call@PLT
.L116:
	call	camlArray__to_list_1121@PLT
.L117:
	movq	$1, %rbx
	cmpq	$1001, %rbx
	jg	.L113
	movq	%rbx, 8(%rsp)
	movq	%rax, 0(%rsp)
.L114:
	movq	0(%rsp), %rax
	call	camlCode__sum_1035@PLT
.L118:
	movq	8(%rsp), %rax
	movq	%rax, %rbx
	addq	$2, %rax
	movq	%rax, 8(%rsp)
	cmpq	$1001, %rbx
	jne	.L114
.L113:
	movq	$1, %rax
	addq	$24, %rsp
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
	.quad	5
	.quad	.L118
	.word	32
	.word	1
	.word	0
	.align	8
	.quad	.L117
	.word	32
	.word	0
	.align	8
	.quad	.L116
	.word	32
	.word	0
	.align	8
	.quad	.L111
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

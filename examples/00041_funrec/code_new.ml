

let sum_i list =
  let n = ref 0 in
  let rec iter l =
    match l with
	[] -> !n
      | x :: tail -> n := !n + x; iter tail
  in
    iter list

let rec iterf sum l =
  match l with
      [] -> sum > 0.
    | x :: tail ->
      iterf (sum +. x) tail

let sum_f list =
  iterf 0. list

let _ =
  let t = Array.init 10_000_000 (fun i -> float i) in
  let l = Array.to_list t in
  ignore (sum_f l)
(*
-drawlambda
(seq
  (let
    (sum_i/1030
       (function list/1031
         (let (n/1032 (makemutable 0 0))
           (letrec
             (iter/1033
                (function l/1034
                  (if l/1034
                    (let (tail/1036 (field 1 l/1034) x/1035 (field 0 l/1034))
                      (seq
                        (setfield_imm 0 n/1032 (+ (field 0 n/1032) x/1035))
                        (apply iter/1033 tail/1036)))
                    (field 0 n/1032))))
             (apply iter/1033 list/1031)))))
    (setfield_imm 0 (global Code!) sum_i/1030))
  (letrec
    (iterf/1037
       (function sum/1038 l/1039
         (if l/1039
           (let (tail/1041 (field 1 l/1039) x/1040 (field 0 l/1039))
             (apply iterf/1037 (+. sum/1038 x/1040) tail/1041))
           (>. sum/1038 0.))))
    (setfield_imm 1 (global Code!) iterf/1037))
  (let
    (sum_f/1042
       (function list/1043 (apply (field 1 (global Code!)) 0. list/1043)))
    (setfield_imm 2 (global Code!) sum_f/1042))
  (let
    (t/1044
       (apply (field 0 (global Array!)) 10000000
         (function i/1045 (float_of_int i/1045)))
     l/1046 (apply (field 9 (global Array!)) t/1044))
    (ignore (apply (field 2 (global Code!)) l/1046)))
  0a)
-dlambda
(seq
  (let
    (sum_i/1030
       (function list/1031
         (let
           (n/1032 (makemutable 0 0)
            iter/1033
              (function l/1060
                (catch
                  (let (l/1059 l/1060)
                    (while 1a
                      (catch
                        (let (l/1034 l/1059)
                          (exit 8
                            (if l/1034
                              (seq
                                (setfield_imm 0 n/1032
                                  (+ (field 0 n/1032) (field 0 l/1034)))
                                (exit 9 (field 1 l/1034)))
                              (field 0 n/1032))))
                       with (9 l/1058) (seq (assign l/1059 l/1058) 0a))))
                 with (8 result/1061) result/1061)))
           (apply iter/1033 list/1031))))
    (setfield_imm 0 (global Code!) sum_i/1030))
  (let
    (iterf/1037
       (function sum/1053 l/1056
         (catch
           (let (l/1055 l/1056 sum/1052 sum/1053)
             (while 1a
               (catch
                 (let (l/1039 l/1055 sum/1038 sum/1052)
                   (exit 6
                     (if l/1039
                       (exit 7 (+. sum/1038 (field 0 l/1039))
                         (field 1 l/1039))
                       (>. sum/1038 0.))))
                with (7 sum/1051 l/1054)
                 (seq (assign l/1055 l/1054) (assign sum/1052 sum/1051) 0a))))
          with (6 result/1057) result/1057)))
    (setfield_imm 1 (global Code!) iterf/1037))
  (let
    (sum_f/1042
       (function list/1043 (apply (field 1 (global Code!)) 0. list/1043)))
    (setfield_imm 2 (global Code!) sum_f/1042))
  (let
    (t/1044
       (apply (field 0 (global Array!)) 10000000
         (function i/1045 (float_of_int i/1045)))
     l/1046 (apply (field 9 (global Array!)) t/1044))
    (ignore (apply (field 2 (global Code!)) l/1046)))
  0a)
-dclosure
*** After closure conversion:
(seq
  (let
    (sum_i/1030 {fun camlCode__sum_i_1030 {1} closed -> ?} = 
       (closure (camlCode__sum_i_1030(1)  list/1031
                  (let
                    (n/1032 {?} =  (makemutable 0 0)
                     iter/1033 {fun camlCode__iter_1033 {1} inline -> ?} = 
                       (closure (camlCode__iter_1033(1)  l/1060 env/1064
                                  (catch
                                    (let (l/1059 {?} =  l/1060)
                                      (while 1a
                                        (catch
                                          (let (l/1034 {?} =  l/1059)
                                            (exit 8
                                              (if l/1034
                                                (seq
                                                  (setfield_imm 0
                                                    (field 2 env/1064)
                                                    (+
                                                      (field 0
                                                        (field 2 env/1064))
                                                      (field 0 l/1034)))
                                                  (exit 9 (field 1 l/1034)))
                                                (field 0 (field 2 env/1064)))))
                                         with (9 l/1058)
                                          (seq (assign l/1059 l/1058) 0a))))
                                   with (8 result/1061) result/1061)) 
                         {0} 
                         n/1032))
                    (catch
                      (let (l/1065 {?} =  list/1031)
                        (while 1a
                          (catch
                            (let (l/1066 {?} =  l/1065)
                              (exit 8
                                (if l/1066
                                  (seq
                                    (setfield_imm 0 (field 2 iter/1033)
                                      (+ (field 0 (field 2 iter/1033))
                                        (field 0 l/1066)))
                                    (exit 9 (field 1 l/1066)))
                                  (field 0 (field 2 iter/1033)))))
                           with (9 l/1058) (seq (assign l/1065 l/1058) 0a))))
                     with (8 result/1061) result/1061))) {0} ))
    (setfield_imm 0 (global camlCode!) sum_i/1030))
  (let
    (iterf/1037 {fun camlCode__iterf_1037 {2} closed inline -> ?} = 
       (closure (camlCode__iterf_1037(2)  sum/1053 l/1056
                  (catch
                    (let (l/1055 {?} =  l/1056 sum/1052 {?} =  sum/1053)
                      (while 1a
                        (catch
                          (let
                            (l/1039 {?} =  l/1055 sum/1038 {?} =  sum/1052)
                            (exit 6
                              (if l/1039
                                (exit 7 (+. sum/1038 (field 0 l/1039))
                                  (field 1 l/1039))
                                (>. sum/1038 0.))))
                         with (7 sum/1051 l/1054)
                          (seq (assign l/1055 l/1054)
                            (assign sum/1052 sum/1051) 0a))))
                   with (6 result/1057) result/1057)) {0} ))
    (setfield_imm 1 (global camlCode!) iterf/1037))
  (let
    (sum_f/1042 {fun camlCode__sum_f_1042 {1} closed inline -> ?} = 
       (closure (camlCode__sum_f_1042(1)  list/1043
                  (catch
                    (let (l/1069 {?} =  list/1043 sum/1070 {?} =  0.)
                      (while 1a
                        (catch
                          (let
                            (l/1071 {?} =  l/1069 sum/1072 {?} =  sum/1070)
                            (exit 6
                              (if l/1071
                                (exit 7 (+. sum/1072 (field 0 l/1071))
                                  (field 1 l/1071))
                                (>. sum/1072 0.))))
                         with (7 sum/1051 l/1054)
                          (seq (assign l/1069 l/1054)
                            (assign sum/1070 sum/1051) 0a))))
                   with (6 result/1057) result/1057)) {0} ))
    (setfield_imm 2 (global camlCode!) sum_f/1042))
  (let
    (t/1044 {?} = 
       (camlArray__init_1037  10000000
         (closure (camlCode__fun_1073(1)  i/1045 (float_of_int i/1045)) {0} ))
     l/1046 {?} =  (camlArray__to_list_1121  t/1044))
    (ignore
      (catch
        (let (l/1075 {?} =  l/1046 sum/1076 {?} =  0.)
          (while 1a
            (catch
              (let (l/1077 {?} =  l/1075 sum/1078 {?} =  sum/1076)
                (exit 6
                  (if l/1077
                    (exit 7 (+. sum/1078 (field 0 l/1077)) (field 1 l/1077))
                    (>. sum/1078 0.))))
             with (7 sum/1051 l/1054)
              (seq (assign l/1075 l/1054) (assign sum/1076 sum/1051) 0a))))
       with (6 result/1057) result/1057)))
  0a)

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 24)
(data int 2295 "camlCode__3": addr "camlCode__fun_1073" int 3)
(data int 2295 "camlCode__4": addr "camlCode__sum_f_1042" int 3)
(data
 int 3319
 "camlCode__5":
 addr "caml_curry2"
 int 5
 addr "camlCode__iterf_1037")
(data int 2295 "camlCode__6": addr "camlCode__sum_i_1030" int 3)
(data global "camlCode__1" int 1277 "camlCode__1": double 0.)
(data global "camlCode__2" int 1277 "camlCode__2": double 0.)
(function camlCode__iter_1033 (l/1060: addr env/1064: addr)
 (catch
   (let l/1059 l/1060
     (catch
       (loop
         (catch
           (let l/1034 l/1059
             (exit 8
               (if (!= l/1034 1)
                 (seq
                   (store (load (+a env/1064 16))
                     (+ (+ (load (load (+a env/1064 16))) (load l/1034)) -1))
                   (exit 9 (load (+a l/1034 8))))
                 (load (load (+a env/1064 16))))))
         with(9 l/1058) (assign l/1059 l/1058)))
     with(14) []) 1a)
 with(8 result/1061) result/1061))

(function camlCode__sum_i_1030 (list/1031: addr)
 (let
   (n/1032 (alloc 1024 1)
    iter/1033 (alloc 3319 "camlCode__iter_1033" 3 n/1032))
   (catch
     (let l/1065 list/1031
       (catch
         (loop
           (catch
             (let l/1066 l/1065
               (exit 8
                 (if (!= l/1066 1)
                   (seq
                     (store (load (+a iter/1033 16))
                       (+ (+ (load (load (+a iter/1033 16))) (load l/1066))
                         -1))
                     (exit 9 (load (+a l/1066 8))))
                   (load (load (+a iter/1033 16))))))
           with(9 l/1058) (assign l/1065 l/1058)))
       with(13) []) 1a)
   with(8 result/1061) result/1061)))

(function camlCode__iterf_1037 (sum/1053: addr l/1056: addr)
 (catch
   (let (l/1055 l/1056 sum/1052 sum/1053)
     (catch
       (loop
         (catch
           (let (l/1039 l/1055 sum/1038 sum/1052)
             (exit 6
               (if (!= l/1039 1)
                 (exit 7
                   (alloc 1277
                     (+f (load float64u sum/1038)
                       (load float64u (load l/1039))))
                   (load (+a l/1039 8)))
                 (+ (<< (>f (load float64u sum/1038) 0.) 1) 1))))
         with(7 sum/1051 l/1054) (assign l/1055 l/1054)
           (assign sum/1052 sum/1051)))
     with(12) []) 1a)
 with(6 result/1057) result/1057))

(function camlCode__sum_f_1042 (list/1043: addr)
 (catch
   (let (l/1069 list/1043 sum/1070 "camlCode__2")
     (catch
       (loop
         (catch
           (let (l/1071 l/1069 sum/1072 sum/1070)
             (exit 6
               (if (!= l/1071 1)
                 (exit 7
                   (alloc 1277
                     (+f (load float64u sum/1072)
                       (load float64u (load l/1071))))
                   (load (+a l/1071 8)))
                 (+ (<< (>f (load float64u sum/1072) 0.) 1) 1))))
         with(7 sum/1051 l/1054) (assign l/1069 l/1054)
           (assign sum/1070 sum/1051)))
     with(11) []) 1a)
 with(6 result/1057) result/1057))

(function camlCode__fun_1073 (i/1045: addr)
 (alloc 1277 (floatofint (>>s i/1045 1))))

(function camlCode__entry ()
 (let sum_i/1030 "camlCode__6" (store "camlCode" sum_i/1030))
 (let iterf/1037 "camlCode__5" (store (+a "camlCode" 8) iterf/1037))
 (let sum_f/1042 "camlCode__4" (store (+a "camlCode" 16) sum_f/1042))
 (let
   (t/1044 (app "camlArray__init_1037" 20000001 "camlCode__3" addr)
    l/1046 (app "camlArray__to_list_1121" t/1044 addr))
   (catch
     (let (l/1075 l/1046 sum/1076 "camlCode__2")
       (catch
         (loop
           (catch
             (let (l/1077 l/1075 sum/1078 sum/1076)
               (exit 6
                 (if (!= l/1077 1)
                   (exit 7
                     (alloc 1277
                       (+f (load float64u sum/1078)
                         (load float64u (load l/1077))))
                     (load (+a l/1077 8)))
                   (+ (<< (>f (load float64u sum/1078) 0.) 1) 1))))
           with(7 sum/1051 l/1054) (assign l/1075 l/1054)
             (assign sum/1076 sum/1051)))
       with(10) []))
   with(6 result/1057) result/1057 []))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__iter_1033:
  L102:
  if l/34[%rax] ==s 1 goto L103
  A/35[%rdx] := [env/30[%rbx] + 16]
  A/36[%rsi] := [l/34[%rax]]
  A/37[%rdi] := [env/30[%rbx] + 16]
  A/38[%rdi] := [A/37[%rdi]]
  I/39[%rdi] := A/38[%rdi] + A/36[%rsi] + -1
  [A/35[%rdx]] := I/39[%rdi]
  A/40[%rax] := [l/34[%rax] + 8]
  goto L102
  L103:
  A/41[%rax] := [env/30[%rbx] + 16]
  A/42[%rax] := [A/41[%rax]]
  goto L100
  L101:
  A/43[%rax] := 1
  return R/0[%rax]
  L100:
  return R/0[%rax]
  
*** Linearized code
camlCode__sum_i_1030:
  list/29[%rbx] := R/0[%rax]
  {list/29[%rbx]*}
  n/30[%rdi] := alloc 48
  [n/30[%rdi] + -8] := 1024
  [n/30[%rdi]] := 1
  iter/31[%rdx] := n/30[%rdi] + 16
  [iter/31[%rdx] + -8] := 3319
  A/32[%rax] := "camlCode__iter_1033"
  [iter/31[%rdx]] := A/32[%rax]
  [iter/31[%rdx] + 8] := 3
  [iter/31[%rdx] + 16] := n/30[%rdi]
  L107:
  if l/36[%rbx] ==s 1 goto L108
  A/37[%rsi] := [iter/31[%rdx] + 16]
  A/38[%rdi] := [l/36[%rbx]]
  A/39[%rax] := [iter/31[%rdx] + 16]
  A/40[%rax] := [A/39[%rax]]
  I/41[%rax] := A/40[%rax] + A/38[%rdi] + -1
  [A/37[%rsi]] := I/41[%rax]
  A/42[%rbx] := [l/36[%rbx] + 8]
  goto L107
  L108:
  A/43[%rax] := [iter/31[%rdx] + 16]
  A/44[%rax] := [A/43[%rax]]
  goto L105
  L106:
  A/45[%rax] := 1
  reload retaddr
  return R/0[%rax]
  L105:
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__iterf_1037:
  sum/33[%rdx] := sum/29[%rax]
  L115:
  if l/36[%rbx] ==s 1 goto L118
  {l/36[%rbx]* sum/37[%rdx]*}
  A/38[%rsi] := alloc 16
  [A/38[%rsi] + -8] := 1277
  A/39[%rdi] := [l/36[%rbx]]
  F/40[%xmm0] := float64u[sum/37[%rdx]]
  F/41[%xmm0] := F/41[%xmm0] +f float64[A/39[%rdi]]
  float64u[A/38[%rsi]] := F/41[%xmm0]
  A/42[%rbx] := [l/36[%rbx] + 8]
  sum/34[%rdx] := A/38[%rsi]
  goto L115
  L118:
  F/43[%xmm1] := 0.
  F/44[%xmm0] := float64u[sum/37[%rdx]]
  if not F/44[%xmm0] >f F/43[%xmm1] goto L117
  I/45[%rax] := 1
  goto L116
  L117:
  I/46[%rax] := 0
  L116:
  I/47[%rax] := I/45[%rax]  * 2 + 1
  goto L113
  L114:
  A/48[%rax] := 1
  reload retaddr
  return R/0[%rax]
  L113:
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__sum_f_1042:
  l/31[%rbx] := list/29[%rax]
  sum/32[%rdx] := "camlCode__2"
  L125:
  if l/35[%rbx] ==s 1 goto L128
  {l/35[%rbx]* sum/36[%rdx]*}
  A/37[%rsi] := alloc 16
  [A/37[%rsi] + -8] := 1277
  A/38[%rdi] := [l/35[%rbx]]
  F/39[%xmm0] := float64u[sum/36[%rdx]]
  F/40[%xmm0] := F/40[%xmm0] +f float64[A/38[%rdi]]
  float64u[A/37[%rsi]] := F/40[%xmm0]
  A/41[%rbx] := [l/35[%rbx] + 8]
  sum/33[%rdx] := A/37[%rsi]
  goto L125
  L128:
  F/42[%xmm1] := 0.
  F/43[%xmm0] := float64u[sum/36[%rdx]]
  if not F/43[%xmm0] >f F/42[%xmm1] goto L127
  I/44[%rax] := 1
  goto L126
  L127:
  I/45[%rax] := 0
  L126:
  I/46[%rax] := I/44[%rax]  * 2 + 1
  goto L123
  L124:
  A/47[%rax] := 1
  reload retaddr
  return R/0[%rax]
  L123:
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__fun_1073:
  i/29[%rbx] := R/0[%rax]
  {i/29[%rbx]*}
  A/30[%rax] := alloc 16
  [A/30[%rax] + -8] := 1277
  I/31[%rbx] := I/31[%rbx] >>s 1
  F/32[%xmm0] := floatofint I/31[%rbx]
  float64u[A/30[%rax]] := F/32[%xmm0]
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  sum_i/29[%rbx] := "camlCode__6"
  A/30[%rax] := "camlCode"
  [A/30[%rax]] := sum_i/29[%rbx]
  iterf/31[%rbx] := "camlCode__5"
  A/32[%rax] := "camlCode"
  [A/32[%rax] + 8] := iterf/31[%rbx]
  sum_f/33[%rbx] := "camlCode__4"
  A/34[%rax] := "camlCode"
  [A/34[%rax] + 16] := sum_f/33[%rbx]
  A/35[%rbx] := "camlCode__3"
  I/36[%rax] := 20000001
  {}
  R/0[%rax] := call "camlArray__init_1037" R/0[%rax] R/1[%rbx]
  {}
  R/0[%rax] := call "camlArray__to_list_1121" R/0[%rax]
  l/40[%rbx] := l/38[%rax]
  sum/41[%rdx] := "camlCode__2"
  L138:
  if l/44[%rbx] ==s 1 goto L141
  {l/44[%rbx]* sum/45[%rdx]*}
  A/46[%rsi] := alloc 16
  [A/46[%rsi] + -8] := 1277
  A/47[%rdi] := [l/44[%rbx]]
  F/48[%xmm0] := float64u[sum/45[%rdx]]
  F/49[%xmm0] := F/49[%xmm0] +f float64[A/47[%rdi]]
  float64u[A/46[%rsi]] := F/49[%xmm0]
  A/50[%rbx] := [l/44[%rbx] + 8]
  sum/42[%rdx] := A/46[%rsi]
  goto L138
  L141:
  F/51[%xmm1] := 0.
  F/52[%xmm0] := float64u[sum/45[%rdx]]
  if not F/52[%xmm0] >f F/51[%xmm1] goto L140
  I/53[%rax] := 1
  goto L139
  L140:
  I/54[%rax] := 0
  L139:
  I/55[%rax] := I/53[%rax]  * 2 + 1
  L137:
  A/56[%rax] := 1
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
	.ascii	"\204\225\246\276\0\0\0\300\0\0\0\30\0\0\0j\0\0\0V\240\300*Pervasives0\333r:\27\230\261\42\340\211\31\242\277\355\6%\24\60\63\257sH\376\305\303\221\370\322;\34\231\231\14\345\240\4\4@\240\300%Array0"
	.ascii	"r\10H\340\265\10'8\5\357\70\330\204\245v\30\60\345D\327FD\5y\12\246x\204\310\31\333vE\240\4\4@\240\300$Code0-\237h\364\213{\302H7Y\214\63\274S\177f0\317I\17\306J1MR\372\264\70\307}\201\17\260\240\4"
	.ascii	"\4@\240\300(Std_exit0K<u\217\27kw\366\203\3\37W\376u\277\312\60\355Q\347\35.\256\250\271\242\64lP9x\252~\240\4\4@@"
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
camlCode__3:
	.quad	camlCode__fun_1073
	.quad	3
	.data
	.quad	2295
camlCode__4:
	.quad	camlCode__sum_f_1042
	.quad	3
	.data
	.quad	3319
camlCode__5:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__iterf_1037
	.data
	.quad	2295
camlCode__6:
	.quad	camlCode__sum_i_1030
	.quad	3
	.data
	.globl	camlCode__1
	.quad	1277
camlCode__1:
	.quad	0x0
	.data
	.globl	camlCode__2
	.quad	1277
camlCode__2:
	.quad	0x0
	.text
	.align	16
	.globl	camlCode__iter_1033
camlCode__iter_1033:
.L104:
.L102:
	cmpq	$1, %rax
	je	.L103
	movq	16(%rbx), %rdx
	movq	(%rax), %rsi
	movq	16(%rbx), %rdi
	movq	(%rdi), %rdi
	leaq	-1(%rdi, %rsi), %rdi
	movq	%rdi, (%rdx)
	movq	8(%rax), %rax
	jmp	.L102
	.align	4
.L103:
	movq	16(%rbx), %rax
	movq	(%rax), %rax
	jmp	.L100
	.align	4
.L101:
	movq	$1, %rax
	ret
	.align	4
.L100:
	ret
	.type	camlCode__iter_1033,@function
	.size	camlCode__iter_1033,.-camlCode__iter_1033
	.text
	.align	16
	.globl	camlCode__sum_i_1030
camlCode__sum_i_1030:
	subq	$8, %rsp
.L109:
	movq	%rax, %rbx
.L110:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L111
	leaq	8(%r15), %rdi
	movq	$1024, -8(%rdi)
	movq	$1, (%rdi)
	leaq	16(%rdi), %rdx
	movq	$3319, -8(%rdx)
	movq	camlCode__iter_1033@GOTPCREL(%rip), %rax
	movq	%rax, (%rdx)
	movq	$3, 8(%rdx)
	movq	%rdi, 16(%rdx)
.L107:
	cmpq	$1, %rbx
	je	.L108
	movq	16(%rdx), %rsi
	movq	(%rbx), %rdi
	movq	16(%rdx), %rax
	movq	(%rax), %rax
	leaq	-1(%rax, %rdi), %rax
	movq	%rax, (%rsi)
	movq	8(%rbx), %rbx
	jmp	.L107
	.align	4
.L108:
	movq	16(%rdx), %rax
	movq	(%rax), %rax
	jmp	.L105
	.align	4
.L106:
	movq	$1, %rax
	addq	$8, %rsp
	ret
	.align	4
.L105:
	addq	$8, %rsp
	ret
.L111:	call	caml_call_gc@PLT
.L112:	jmp	.L110
	.type	camlCode__sum_i_1030,@function
	.size	camlCode__sum_i_1030,.-camlCode__sum_i_1030
	.text
	.align	16
	.globl	camlCode__iterf_1037
camlCode__iterf_1037:
	subq	$8, %rsp
.L119:
	movq	%rax, %rdx
.L115:
	cmpq	$1, %rbx
	je	.L118
.L120:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L121
	leaq	8(%r15), %rsi
	movq	$1277, -8(%rsi)
	movq	(%rbx), %rdi
	movlpd	(%rdx), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rsi)
	movq	8(%rbx), %rbx
	movq	%rsi, %rdx
	jmp	.L115
	.align	4
.L118:
	xorpd	%xmm1, %xmm1
	movlpd	(%rdx), %xmm0
 comisd	%xmm1, %xmm0
	jbe	.L117
	movq	$1, %rax
	jmp	.L116
	.align	4
.L117:
	xorq	%rax, %rax
.L116:
	leaq	1(%rax, %rax), %rax
	jmp	.L113
	.align	4
.L114:
	movq	$1, %rax
	addq	$8, %rsp
	ret
	.align	4
.L113:
	addq	$8, %rsp
	ret
.L121:	call	caml_call_gc@PLT
.L122:	jmp	.L120
	.type	camlCode__iterf_1037,@function
	.size	camlCode__iterf_1037,.-camlCode__iterf_1037
	.text
	.align	16
	.globl	camlCode__sum_f_1042
camlCode__sum_f_1042:
	subq	$8, %rsp
.L129:
	movq	%rax, %rbx
	movq	camlCode__2@GOTPCREL(%rip), %rdx
.L125:
	cmpq	$1, %rbx
	je	.L128
.L130:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L131
	leaq	8(%r15), %rsi
	movq	$1277, -8(%rsi)
	movq	(%rbx), %rdi
	movlpd	(%rdx), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rsi)
	movq	8(%rbx), %rbx
	movq	%rsi, %rdx
	jmp	.L125
	.align	4
.L128:
	xorpd	%xmm1, %xmm1
	movlpd	(%rdx), %xmm0
 comisd	%xmm1, %xmm0
	jbe	.L127
	movq	$1, %rax
	jmp	.L126
	.align	4
.L127:
	xorq	%rax, %rax
.L126:
	leaq	1(%rax, %rax), %rax
	jmp	.L123
	.align	4
.L124:
	movq	$1, %rax
	addq	$8, %rsp
	ret
	.align	4
.L123:
	addq	$8, %rsp
	ret
.L131:	call	caml_call_gc@PLT
.L132:	jmp	.L130
	.type	camlCode__sum_f_1042,@function
	.size	camlCode__sum_f_1042,.-camlCode__sum_f_1042
	.text
	.align	16
	.globl	camlCode__fun_1073
camlCode__fun_1073:
	subq	$8, %rsp
.L133:
	movq	%rax, %rbx
.L134:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L135
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	sarq	$1, %rbx
	cvtsi2sdq	%rbx, %xmm0
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L135:	call	caml_call_gc@PLT
.L136:	jmp	.L134
	.type	camlCode__fun_1073,@function
	.size	camlCode__fun_1073,.-camlCode__fun_1073
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L142:
	movq	camlCode__6@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__5@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	camlCode__4@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 16(%rax)
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	$20000001, %rax
	call	camlArray__init_1037@PLT
.L143:
	call	camlArray__to_list_1121@PLT
.L144:
	movq	%rax, %rbx
	movq	camlCode__2@GOTPCREL(%rip), %rdx
.L138:
	cmpq	$1, %rbx
	je	.L141
	call	caml_alloc1@PLT
.L145:
	leaq	8(%r15), %rsi
	movq	$1277, -8(%rsi)
	movq	(%rbx), %rdi
	movlpd	(%rdx), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rsi)
	movq	8(%rbx), %rbx
	movq	%rsi, %rdx
	jmp	.L138
.L141:
	xorpd	%xmm1, %xmm1
	movlpd	(%rdx), %xmm0
 comisd	%xmm1, %xmm0
	jbe	.L140
	movq	$1, %rax
	jmp	.L139
.L140:
	xorq	%rax, %rax
.L139:
	leaq	1(%rax, %rax), %rax
.L137:
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
	.quad	7
	.quad	.L145
	.word	16
	.word	2
	.word	9
	.word	3
	.align	8
	.quad	.L144
	.word	16
	.word	0
	.align	8
	.quad	.L143
	.word	16
	.word	0
	.align	8
	.quad	.L136
	.word	16
	.word	1
	.word	3
	.align	8
	.quad	.L132
	.word	16
	.word	2
	.word	9
	.word	3
	.align	8
	.quad	.L122
	.word	16
	.word	2
	.word	9
	.word	3
	.align	8
	.quad	.L112
	.word	16
	.word	1
	.word	3
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

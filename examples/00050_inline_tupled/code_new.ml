
let f1 =
  let z = ref 0 in
  function (x,y) ->
    incr z;
    x + y + !z

let a1 = f1(1,2)

let f2 =
  let z = ref 0. in
  function (x,y) ->
    z := !z +. 1.;
    x +. y +. !z

let a2 = f2 (1.,2.)

let g x =
  let f () = 1 in
  f x + f x
(*
-drawlambda
(seq
  (let
    (f1/1030
       = (let (z/1031 = (makemutable 0 0))
           (function (param/1048, param/1049)
             (let (y/1033 (=) param/1049 x/1032 (=) param/1048)
               (seq (+:=1 z/1031) (+ (+ x/1032 y/1033) (field 0 z/1031)))))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let (a1/1034 = (apply (field 0 (global Code!)) [0: 1 2]))
    (setfield_imm 1 (global Code!) a1/1034))
  (let
    (f2/1035
       = (let (z/1036 = (makemutable 0 0.))
           (function (param/1050, param/1051)
             (let (y/1038 (=) param/1051 x/1037 (=) param/1050)
               (seq (setfield_ptr 0 z/1036 (+. (field 0 z/1036) 1.))
                 (+. (+. x/1037 y/1038) (field 0 z/1036)))))))
    (setfield_imm 2 (global Code!) f2/1035))
  (let (a2/1039 = (apply (field 2 (global Code!)) [0: 1. 2.]))
    (setfield_imm 3 (global Code!) a2/1039))
  (let
    (g/1040
       = (function x/1041
           (let (f/1042 = (function param/1052 1))
             (+ (apply f/1042 x/1041) (apply f/1042 x/1041)))))
    (setfield_imm 4 (global Code!) g/1040))
  0a)
-dlambda
(seq
  (let
    (f1/1030
       = (let (z/1031 = (makemutable 0 0))
           (function (param/1048, param/1049)
             (seq (+:=1 z/1031)
               (+ (+ param/1048 param/1049) (field 0 z/1031))))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let (a1/1034 = (apply (field 0 (global Code!)) [0: 1 2]))
    (setfield_imm 1 (global Code!) a1/1034))
  (let
    (f2/1035
       = (let (z/1036 = (makemutable 0 0.))
           (function (param/1050, param/1051)
             (seq (setfield_ptr 0 z/1036 (+. (field 0 z/1036) 1.))
               (+. (+. param/1050 param/1051) (field 0 z/1036))))))
    (setfield_imm 2 (global Code!) f2/1035))
  (let (a2/1039 = (apply (field 2 (global Code!)) [0: 1. 2.]))
    (setfield_imm 3 (global Code!) a2/1039))
  (let
    (g/1040
       = (function x/1041
           (let (f/1042 = (function param/1052 1))
             (+ (apply f/1042 x/1041) (apply f/1042 x/1041)))))
    (setfield_imm 4 (global Code!) g/1040))
  0a)
-dclosure
*** Clambda: after closure conversion:
(seq
  (let
    (f1/1030 {fun camlCode__fun_1054 {-2} inline -> ?} = 
       (let (z/1031 {} =  (makemutable 0 0))
         (closure (camlCode__fun_1054(-2)  param/1048 param/1049 env/1056
                    (seq (+:=1 (field 3 env/1056))
                      (+ (+ param/1048 param/1049)
                        (field 0 (field 3 env/1056))))) {0} 
                                                        z/1031)))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let
    (a1/1034 {} = 
       (let
         (arg/1057 {(int 1, int 2)} =  [0: 1 2]
          env/1058 {} =  (field 0 (global camlCode!))
          param/1059 {} =  (field 1 arg/1057)
          param/1060 {} =  (field 0 arg/1057))
         (seq (+:=1 (field 3 env/1058))
           (+ (+ param/1060 param/1059) (field 0 (field 3 env/1058))))))
    (setfield_imm 1 (global camlCode!) a1/1034))
  (let
    (f2/1035 {fun camlCode__fun_1061 {-2} inline -> ?} = 
       (let (z/1036 {} =  (makemutable 0 0.))
         (closure (camlCode__fun_1061(-2)  param/1050 param/1051 env/1063
                    (seq
                      (setfield_ptr 0 (field 3 env/1063)
                        (+. (field 0 (field 3 env/1063)) 1.))
                      (+. (+. param/1050 param/1051)
                        (field 0 (field 3 env/1063))))) {0} 
                                                        z/1036)))
    (setfield_imm 2 (global camlCode!) f2/1035))
  (let
    (a2/1039 {} = 
       (let
         (arg/1064 {(?, ?)} =  [0: 1. 2.]
          env/1065 {} =  (field 2 (global camlCode!))
          param/1066 {} =  (field 1 arg/1064)
          param/1067 {} =  (field 0 arg/1064))
         (seq
           (setfield_ptr 0 (field 3 env/1065)
             (+. (field 0 (field 3 env/1065)) 1.))
           (+. (+. param/1067 param/1066) (field 0 (field 3 env/1065))))))
    (setfield_imm 3 (global camlCode!) a2/1039))
  (let
    (g/1040 {fun camlCode__g_1040 {1} closed -> int 2} = 
       (closure (camlCode__g_1040(1)  x/1041
                  (let
                    (f/1042 {fun camlCode__f_1042 {1} closed inline -> 
                       int 1} = 
                       (closure (camlCode__f_1042(1)  param/1052 1) {0} ))
                    2)) {0} ))
    (setfield_imm 4 (global camlCode!) g/1040))
  0a)
*** Clambda: after second inlining:
(seq
  (let
    (f1/1030 {fun camlCode__fun_1054 {-2} inline -> ?} = 
       (let (z/1031 {} =  (makemutable 0 0))
         (closure (camlCode__fun_1054(-2)  param/1048 param/1049 env/1056
                    (seq (+:=1 (field 3 env/1056))
                      (+ (+ param/1048 param/1049)
                        (field 0 (field 3 env/1056))))) {0} 
                                                        z/1031)))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let
    (a1/1034 {} = 
       (let
         (arg/1057 {(int 1, int 2)} =  [0: 1 2]
          env/1058 {} =  (field 0 (global camlCode!))
          param/1059 {} =  (field 1 arg/1057)
          param/1060 {} =  (field 0 arg/1057))
         (seq (+:=1 (field 3 env/1058))
           (+ (+ param/1060 param/1059) (field 0 (field 3 env/1058))))))
    (setfield_imm 1 (global camlCode!) a1/1034))
  (let
    (f2/1035 {fun camlCode__fun_1061 {-2} inline -> ?} = 
       (let (z/1036 {} =  (makemutable 0 0.))
         (closure (camlCode__fun_1061(-2)  param/1050 param/1051 env/1063
                    (seq
                      (setfield_ptr 0 (field 3 env/1063)
                        (+. (field 0 (field 3 env/1063)) 1.))
                      (+. (+. param/1050 param/1051)
                        (field 0 (field 3 env/1063))))) {0} 
                                                        z/1036)))
    (setfield_imm 2 (global camlCode!) f2/1035))
  (let
    (a2/1039 {} = 
       (let
         (arg/1064 {(?, ?)} =  [0: 1. 2.]
          env/1065 {} =  (field 2 (global camlCode!))
          param/1066 {} =  (field 1 arg/1064)
          param/1067 {} =  (field 0 arg/1064))
         (seq
           (setfield_ptr 0 (field 3 env/1065)
             (+. (field 0 (field 3 env/1065)) 1.))
           (+. (+. param/1067 param/1066) (field 0 (field 3 env/1065))))))
    (setfield_imm 3 (global camlCode!) a2/1039))
  (let
    (g/1040 {fun camlCode__g_1040 {1} closed -> int 2} = 
       (closure (camlCode__g_1040(1)  x/1041
                  (let
                    (f/1042 {fun camlCode__f_1042 {1} closed inline -> 
                       int 1} = 
                       (closure (camlCode__f_1042(1)  param/1052 1) {0} ))
                    2)) {0} ))
    (setfield_imm 4 (global camlCode!) g/1040))
  0a)

*** Clambda: after simplification:
(seq
  (let
    (f1/1030 {fun camlCode__fun_1054 {-2} inline -> ?} = 
       (let (z/1031 {} =  (makemutable 0 0))
         (closure (camlCode__fun_1054(-2)  param/1048 param/1049 env/1056
                    (seq (+:=1 (field 3 env/1056))
                      (+ (+ param/1048 param/1049)
                        (field 0 (field 3 env/1056))))) {0} 
                                                        z/1031)))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let
    (a1/1034 {} = 
       (let
         (arg/1057 {(int 1, int 2)} =  [0: 1 2]
          env/1058 {} =  (field 0 (global camlCode!))
          param/1059 {} =  (field 1 arg/1057)
          param/1060 {} =  (field 0 arg/1057))
         (seq (+:=1 (field 3 env/1058))
           (+ (+ param/1060 param/1059) (field 0 (field 3 env/1058))))))
    (setfield_imm 1 (global camlCode!) a1/1034))
  (let
    (f2/1035 {fun camlCode__fun_1061 {-2} inline -> ?} = 
       (let (z/1036 {} =  (makemutable 0 0.))
         (closure (camlCode__fun_1061(-2)  param/1050 param/1051 env/1063
                    (seq
                      (setfield_ptr 0 (field 3 env/1063)
                        (+. (field 0 (field 3 env/1063)) 1.))
                      (+. (+. param/1050 param/1051)
                        (field 0 (field 3 env/1063))))) {0} 
                                                        z/1036)))
    (setfield_imm 2 (global camlCode!) f2/1035))
  (let
    (a2/1039 {} = 
       (let
         (arg/1064 {(?, ?)} =  [0: 1. 2.]
          env/1065 {} =  (field 2 (global camlCode!))
          param/1066 {} =  (field 1 arg/1064)
          param/1067 {} =  (field 0 arg/1064))
         (seq
           (setfield_ptr 0 (field 3 env/1065)
             (+. (field 0 (field 3 env/1065)) 1.))
           (+. (+. param/1067 param/1066) (field 0 (field 3 env/1065))))))
    (setfield_imm 3 (global camlCode!) a2/1039))
  (let
    (g/1040 {fun camlCode__g_1040 {1} closed -> int 2} = 
       (closure (camlCode__g_1040(1)  x/1041
                  (let
                    (f/1042 {fun camlCode__f_1042 {1} closed inline -> 
                       int 1} = 
                       (closure (camlCode__f_1042(1)  param/1052 1) {0} ))
                    2)) {0} ))
    (setfield_imm 4 (global camlCode!) g/1040))
  0a)


-dcmm
(data int 5120 global "camlCode" "camlCode": skip 40)
(data int 2295 "camlCode__5": addr "camlCode__g_1040" int 3)
(data int 2295 "camlCode__6": addr "camlCode__f_1042" int 3)
(data
 global "camlCode__4"
 int 2048
 "camlCode__4":
 addr L7
 addr L8
 int 1277
 L8:
 double 2.
 int 1277
 L7:
 double 1.)
(data global "camlCode__2" int 1277 "camlCode__2": double 0.)
(data global "camlCode__3" int 1277 "camlCode__3": double 1.)
(data global "camlCode__1" int 2048 "camlCode__1": int 3 int 5)
(function camlCode__f_1042 (param/1052: addr) 3)

(function camlCode__fun_1054
     (param/1048: addr param/1049: addr env/1056: addr)
 (let ref/1071 (load (+a env/1056 24))
   (store ref/1071 (+ (load ref/1071) 2)))
 (+ (+ (+ param/1048 param/1049) (load (load (+a env/1056 24)))) -2))

(function camlCode__fun_1061
     (param/1050: addr param/1051: addr env/1063: addr)
 (extcall "caml_modify" (load (+a env/1063 24))
   (alloc 1277 (+f (load float64u (load (load (+a env/1063 24)))) 1.)) unit)
 (alloc 1277
   (+f (+f (load float64u param/1050) (load float64u param/1051))
     (load float64u (load (load (+a env/1063 24)))))))

(function camlCode__g_1040 (x/1041: addr) (let f/1042 "camlCode__6" 5))

(function camlCode__entry ()
 (let
   f1/1030
     (let z/1031 (alloc 1024 1)
       (alloc 4343 "caml_tuplify2" -3 "camlCode__fun_1054" z/1031))
   (store "camlCode" f1/1030))
 (let
   a1/1034
     (let
       (arg/1057 "camlCode__1" env/1058 (load "camlCode")
        param/1059 (load (+a arg/1057 8)) param/1060 (load arg/1057))
       (let ref/1070 (load (+a env/1058 24))
         (store ref/1070 (+ (load ref/1070) 2)))
       (+ (+ (+ param/1060 param/1059) (load (load (+a env/1058 24)))) -2))
   (store (+a "camlCode" 8) a1/1034))
 (let
   f2/1035
     (let z/1036 (alloc 1024 "camlCode__2")
       (alloc 4343 "caml_tuplify2" -3 "camlCode__fun_1061" z/1036))
   (store (+a "camlCode" 16) f2/1035))
 (let
   a2/1039
     (let
       (arg/1064 "camlCode__4" env/1065 (load (+a "camlCode" 16))
        param/1066 (load (+a arg/1064 8)) param/1067 (load arg/1064))
       (extcall "caml_modify" (load (+a env/1065 24))
         (alloc 1277 (+f (load float64u (load (load (+a env/1065 24)))) 1.))
         unit)
       (alloc 1277
         (+f (+f (load float64u param/1067) (load float64u param/1066))
           (load float64u (load (load (+a env/1065 24)))))))
   (store (+a "camlCode" 24) a2/1039))
 (let g/1040 "camlCode__5" (store (+a "camlCode" 32) g/1040)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__f_1042:
  I/30[%rax] := 3
  return R/0[%rax]
  
*** Linearized code
camlCode__fun_1054:
  ref/32[%rsi] := [env/31[%rdi] + 24]
  [ref/32[%rsi]] +:= 2
  A/33[%rdi] := [env/31[%rdi] + 24]
  A/34[%rdi] := [A/33[%rdi]]
  I/35[%rax] := I/35[%rax] + param/30[%rbx]
  I/36[%rax] := I/35[%rax] + A/34[%rdi] + -2
  return R/0[%rax]
  
*** Linearized code
camlCode__fun_1061:
  param/29[%r12] := R/0[%rax]
  env/31[%rbp] := R/2[%rdi]
  {param/29[%r12]* param/30[%rbx]* env/31[%rbp]*}
  A/32[%rsi] := alloc 16
  [A/32[%rsi] + -8] := 1277
  A/33[%rax] := [env/31[%rbp] + 24]
  A/34[%rax] := [A/33[%rax]]
  F/35[%xmm0] := 1.
  F/36[%xmm0] := F/36[%xmm0] +f float64[A/34[%rax]]
  float64u[A/32[%rsi]] := F/36[%xmm0]
  A/37[%rdi] := [env/31[%rbp] + 24]
  {param/29[%r12]* param/30[%rbx]* env/31[%rbp]*}
  extcall "caml_modify" R/2[%rdi] R/3[%rsi]
  {param/29[%r12]* param/30[%rbx]* env/31[%rbp]*}
  A/38[%rax] := alloc 16
  [A/38[%rax] + -8] := 1277
  A/39[%rdi] := [env/31[%rbp] + 24]
  A/40[%rdi] := [A/39[%rdi]]
  F/41[%xmm0] := float64u[param/29[%r12]]
  F/42[%xmm0] := F/42[%xmm0] +f float64[param/30[%rbx]]
  F/43[%xmm0] := F/43[%xmm0] +f float64[A/40[%rdi]]
  float64u[A/38[%rax]] := F/43[%xmm0]
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__g_1040:
  f/30[%rax] := "camlCode__6"
  I/31[%rax] := 5
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  {}
  z/29[%rax] := alloc 128
  [z/29[%rax] + -8] := 1024
  [z/29[%rax]] := 1
  f1/30[%rdi] := z/29[%rax] + 16
  [f1/30[%rdi] + -8] := 4343
  A/31[%rbx] := "caml_tuplify2"
  [f1/30[%rdi]] := A/31[%rbx]
  [f1/30[%rdi] + 8] := -3
  A/32[%rbx] := "camlCode__fun_1054"
  [f1/30[%rdi] + 16] := A/32[%rbx]
  [f1/30[%rdi] + 24] := z/29[%rax]
  A/33[%rbx] := "camlCode"
  [A/33[%rbx]] := f1/30[%rdi]
  arg/34[%rdi] := "camlCode__1"
  A/35[%rbx] := "camlCode"
  env/36[%rdx] := [A/35[%rbx]]
  param/37[%rsi] := [arg/34[%rdi] + 8]
  param/38[%rbx] := [arg/34[%rdi]]
  ref/39[%rdi] := [env/36[%rdx] + 24]
  [ref/39[%rdi]] +:= 2
  A/40[%rdi] := [env/36[%rdx] + 24]
  A/41[%rdi] := [A/40[%rdi]]
  I/42[%rbx] := I/42[%rbx] + param/37[%rsi]
  a1/43[%rdi] := I/42[%rbx] + A/41[%rdi] + -2
  A/44[%rbx] := "camlCode"
  [A/44[%rbx] + 8] := a1/43[%rdi]
  z/45[%rsi] := z/29[%rax] + 56
  [z/45[%rsi] + -8] := 1024
  A/46[%rbx] := "camlCode__2"
  [z/45[%rsi]] := A/46[%rbx]
  f2/47[%rdi] := z/29[%rax] + 72
  [f2/47[%rdi] + -8] := 4343
  A/48[%rbx] := "caml_tuplify2"
  [f2/47[%rdi]] := A/48[%rbx]
  [f2/47[%rdi] + 8] := -3
  A/49[%rbx] := "camlCode__fun_1061"
  [f2/47[%rdi] + 16] := A/49[%rbx]
  [f2/47[%rdi] + 24] := z/45[%rsi]
  A/50[%rbx] := "camlCode"
  [A/50[%rbx] + 16] := f2/47[%rdi]
  arg/51[%rdi] := "camlCode__4"
  A/52[%rbx] := "camlCode"
  env/53[%rbx] := [A/52[%rbx] + 16]
  param/54[%r12] := [arg/51[%rdi] + 8]
  param/55[%rbp] := [arg/51[%rdi]]
  A/56[%rsi] := z/29[%rax] + 112
  [A/56[%rsi] + -8] := 1277
  A/57[%rax] := [env/53[%rbx] + 24]
  A/58[%rax] := [A/57[%rax]]
  F/59[%xmm0] := 1.
  F/60[%xmm0] := F/60[%xmm0] +f float64[A/58[%rax]]
  float64u[A/56[%rsi]] := F/60[%xmm0]
  A/61[%rdi] := [env/53[%rbx] + 24]
  {env/53[%rbx]* param/54[%r12]* param/55[%rbp]*}
  extcall "caml_modify" R/2[%rdi] R/3[%rsi]
  {env/53[%rbx]* param/54[%r12]* param/55[%rbp]*}
  a2/62[%rdi] := alloc 16
  [a2/62[%rdi] + -8] := 1277
  A/63[%rax] := [env/53[%rbx] + 24]
  A/64[%rax] := [A/63[%rax]]
  F/65[%xmm0] := float64u[param/55[%rbp]]
  F/66[%xmm0] := F/66[%xmm0] +f float64[param/54[%r12]]
  F/67[%xmm0] := F/67[%xmm0] +f float64[A/64[%rax]]
  float64u[a2/62[%rdi]] := F/67[%xmm0]
  A/68[%rax] := "camlCode"
  [A/68[%rax] + 24] := a2/62[%rdi]
  g/69[%rbx] := "camlCode__5"
  A/70[%rax] := "camlCode"
  [A/70[%rax] + 32] := g/69[%rbx]
  A/71[%rax] := 1
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
	.ascii	"\204\225\246\276\0\0\0\222\0\0\0\22\0\0\0P\0\0\0A\240\300*Pervasives0\333r:\27\230\261\42\340\211\31\242\277\355\6%\24\60+h\272\320\331*\363\303]\334'\344I\276\362\223\240\4\4@\240\300$Code0d"
	.ascii	"\366\2\333 \360\0C\261\250\36)\251\324\260-0\205\21\222\346 \24\377\317jC]\346l|\243\273\240\4\4@\240\300(Std_exit0K<u\217\27kw\366\203\3\37W\376u\277\312\60O\31\364*\11\203\263\235i\277\261\26\373?\370"
	.ascii	"\276\240\4\4@@"
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
	.quad	5120
	.globl	camlCode
camlCode:
	.space	40
	.data
	.quad	2295
camlCode__5:
	.quad	camlCode__g_1040
	.quad	3
	.data
	.quad	2295
camlCode__6:
	.quad	camlCode__f_1042
	.quad	3
	.data
	.globl	camlCode__4
	.quad	2048
camlCode__4:
	.quad	.L100007
	.quad	.L100008
	.quad	1277
.L100008:
	.quad	0x4000000000000000
	.quad	1277
.L100007:
	.quad	0x3ff0000000000000
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
	.quad	5
	.text
	.align	16
	.globl	camlCode__f_1042
camlCode__f_1042:
.L100:
	movq	$3, %rax
	ret
	.type	camlCode__f_1042,@function
	.size	camlCode__f_1042,.-camlCode__f_1042
	.text
	.align	16
	.globl	camlCode__fun_1054
camlCode__fun_1054:
.L101:
	movq	24(%rdi), %rsi
	addq	$2, (%rsi)
	movq	24(%rdi), %rdi
	movq	(%rdi), %rdi
	addq	%rbx, %rax
	leaq	-2(%rax, %rdi), %rax
	ret
	.type	camlCode__fun_1054,@function
	.size	camlCode__fun_1054,.-camlCode__fun_1054
	.text
	.align	16
	.globl	camlCode__fun_1061
camlCode__fun_1061:
	subq	$8, %rsp
.L102:
	movq	%rax, %r12
	movq	%rdi, %rbp
.L103:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L104
	leaq	8(%r15), %rsi
	movq	$1277, -8(%rsi)
	movq	24(%rbp), %rax
	movq	(%rax), %rax
	movlpd	.L106(%rip), %xmm0
	addsd	(%rax), %xmm0
	movlpd	%xmm0, (%rsi)
	movq	24(%rbp), %rdi
	call	caml_modify@PLT
.L107:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L108
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	movq	24(%rbp), %rdi
	movq	(%rdi), %rdi
	movlpd	(%r12), %xmm0
	addsd	(%rbx), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L108:	call	caml_call_gc@PLT
.L109:	jmp	.L107
.L104:	call	caml_call_gc@PLT
.L105:	jmp	.L103
	.type	camlCode__fun_1061,@function
	.size	camlCode__fun_1061,.-camlCode__fun_1061
	.section	.rodata.cst8,"a",@progbits
.L106:	.quad	0x3ff0000000000000
	.text
	.align	16
	.globl	camlCode__g_1040
camlCode__g_1040:
.L110:
	movq	camlCode__6@GOTPCREL(%rip), %rax
	movq	$5, %rax
	ret
	.type	camlCode__g_1040,@function
	.size	camlCode__g_1040,.-camlCode__g_1040
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L111:
	movq	$128, %rax
	call	caml_allocN@PLT
.L112:
	leaq	8(%r15), %rax
	movq	$1024, -8(%rax)
	movq	$1, (%rax)
	leaq	16(%rax), %rdi
	movq	$4343, -8(%rdi)
	movq	caml_tuplify2@GOTPCREL(%rip), %rbx
	movq	%rbx, (%rdi)
	movq	$-3, 8(%rdi)
	movq	camlCode__fun_1054@GOTPCREL(%rip), %rbx
	movq	%rbx, 16(%rdi)
	movq	%rax, 24(%rdi)
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	%rdi, (%rbx)
	movq	camlCode__1@GOTPCREL(%rip), %rdi
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	(%rbx), %rdx
	movq	8(%rdi), %rsi
	movq	(%rdi), %rbx
	movq	24(%rdx), %rdi
	addq	$2, (%rdi)
	movq	24(%rdx), %rdi
	movq	(%rdi), %rdi
	addq	%rsi, %rbx
	leaq	-2(%rbx, %rdi), %rdi
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	%rdi, 8(%rbx)
	leaq	56(%rax), %rsi
	movq	$1024, -8(%rsi)
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	%rbx, (%rsi)
	leaq	72(%rax), %rdi
	movq	$4343, -8(%rdi)
	movq	caml_tuplify2@GOTPCREL(%rip), %rbx
	movq	%rbx, (%rdi)
	movq	$-3, 8(%rdi)
	movq	camlCode__fun_1061@GOTPCREL(%rip), %rbx
	movq	%rbx, 16(%rdi)
	movq	%rsi, 24(%rdi)
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	%rdi, 16(%rbx)
	movq	camlCode__4@GOTPCREL(%rip), %rdi
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	16(%rbx), %rbx
	movq	8(%rdi), %r12
	movq	(%rdi), %rbp
	leaq	112(%rax), %rsi
	movq	$1277, -8(%rsi)
	movq	24(%rbx), %rax
	movq	(%rax), %rax
	movlpd	.L113(%rip), %xmm0
	addsd	(%rax), %xmm0
	movlpd	%xmm0, (%rsi)
	movq	24(%rbx), %rdi
	call	caml_modify@PLT
	call	caml_alloc1@PLT
.L114:
	leaq	8(%r15), %rdi
	movq	$1277, -8(%rdi)
	movq	24(%rbx), %rax
	movq	(%rax), %rax
	movlpd	(%rbp), %xmm0
	addsd	(%r12), %xmm0
	addsd	(%rax), %xmm0
	movlpd	%xmm0, (%rdi)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rdi, 24(%rax)
	movq	camlCode__5@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 32(%rax)
	movq	$1, %rax
	addq	$8, %rsp
	ret
	.type	camlCode__entry,@function
	.size	camlCode__entry,.-camlCode__entry
	.section	.rodata.cst8,"a",@progbits
.L113:	.quad	0x3ff0000000000000
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
	.quad	.L114
	.word	16
	.word	3
	.word	21
	.word	23
	.word	3
	.align	8
	.quad	.L112
	.word	16
	.word	0
	.align	8
	.quad	.L109
	.word	16
	.word	3
	.word	21
	.word	3
	.word	23
	.align	8
	.quad	.L105
	.word	16
	.word	3
	.word	21
	.word	3
	.word	23
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

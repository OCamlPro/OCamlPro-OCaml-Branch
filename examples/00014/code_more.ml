(* In f1, there is an allocation per assignment, because the type of
   x0 is not known (although it is obvious from the context that it is a
   float), and so no unboxing is performed.

   In f2, the need for unboxing is discovered, and so, no allocation
   takes place.

   In f3, the need for unboxing is discovered, but c escapes, so no
   unboxing is performed. There is a safety reason here: if unboxing
   is performed, there will be two values for c, one boxed, and the
   other unboxed. However, assignments can only change one of the two
   values, so there is gonna be inconsistencies. But, here, c is
   needed only at the end, so there is actually no possibility of
   inconsistency.

   In f4, we try to avoid the previous problem by explicitely creating
   an equivalent reference at the end, to prevent c from
   escaping. This is however not enough.

   Finally, f5 and f6 manage to avoid allocations, but the initial or
   final addition to 0. is kept in the assembly code !
*)

let f1 x0 =
  let c = ref x0 in
    c := x0 +. !c;
    c := x0 +. !c;
    c := x0 +. !c;
    x0 +. !c

let f2 x0 =
  let c = ref (ceil 3.) in
    c := x0 +. !c;
    c := x0 +. !c;
    c := x0 +. !c;
    x0 +. !c

let f3 x0 =
  let c = ref (ceil 3.) in
    c := x0 +. !c;
    c := x0 +. !c;
    c := x0 +. !c;
    c

let f4 x0 =
  let c = ref (ceil 3.) in
    c := x0 +. !c;
    c := x0 +. !c;
    c := x0 +. !c;
    ref !c

let f5 x0 =
  let c = ref (ceil 3.) in
    c := x0 +. !c;
    c := x0 +. !c;
    c := x0 +. !c;
    ref (!c +. 0.)

let f6 x0 =
  let c = ref (x0 +. 0.) in
    c := x0 +. !c;
    c := x0 +. !c;
    c := x0 +. !c;
    x0 +. !c


(*
-drawlambda
(seq
  (let
    (f1/1030
       (function x0/1031
         (let (c/1032 (makemutable 0 x0/1031))
           (seq (setfield_ptr 0 c/1032 (+. x0/1031 (field 0 c/1032)))
             (setfield_ptr 0 c/1032 (+. x0/1031 (field 0 c/1032)))
             (setfield_ptr 0 c/1032 (+. x0/1031 (field 0 c/1032)))
             (+. x0/1031 (field 0 c/1032))))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1033
       (function x0/1034
         (let (c/1035 (makemutable 0 (caml_ceil_float 3.)))
           (seq (setfield_ptr 0 c/1035 (+. x0/1034 (field 0 c/1035)))
             (setfield_ptr 0 c/1035 (+. x0/1034 (field 0 c/1035)))
             (setfield_ptr 0 c/1035 (+. x0/1034 (field 0 c/1035)))
             (+. x0/1034 (field 0 c/1035))))))
    (setfield_imm 1 (global Code!) f2/1033))
  (let
    (f3/1036
       (function x0/1037
         (let (c/1038 (makemutable 0 (caml_ceil_float 3.)))
           (seq (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038)))
             (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038)))
             (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038))) c/1038))))
    (setfield_imm 2 (global Code!) f3/1036))
  (let
    (f4/1039
       (function x0/1040
         (let (c/1041 (makemutable 0 (caml_ceil_float 3.)))
           (seq (setfield_ptr 0 c/1041 (+. x0/1040 (field 0 c/1041)))
             (setfield_ptr 0 c/1041 (+. x0/1040 (field 0 c/1041)))
             (setfield_ptr 0 c/1041 (+. x0/1040 (field 0 c/1041)))
             (makemutable 0 (field 0 c/1041))))))
    (setfield_imm 3 (global Code!) f4/1039))
  (let
    (f5/1042
       (function x0/1043
         (let (c/1044 (makemutable 0 (caml_ceil_float 3.)))
           (seq (setfield_ptr 0 c/1044 (+. x0/1043 (field 0 c/1044)))
             (setfield_ptr 0 c/1044 (+. x0/1043 (field 0 c/1044)))
             (setfield_ptr 0 c/1044 (+. x0/1043 (field 0 c/1044)))
             (makemutable 0 (+. (field 0 c/1044) 0.))))))
    (setfield_imm 4 (global Code!) f5/1042))
  (let
    (f6/1045
       (function x0/1046
         (let (c/1047 (makemutable 0 (+. x0/1046 0.)))
           (seq (setfield_ptr 0 c/1047 (+. x0/1046 (field 0 c/1047)))
             (setfield_ptr 0 c/1047 (+. x0/1046 (field 0 c/1047)))
             (setfield_ptr 0 c/1047 (+. x0/1046 (field 0 c/1047)))
             (+. x0/1046 (field 0 c/1047))))))
    (setfield_imm 5 (global Code!) f6/1045))
  0a)
lambda saved
typedtree saved
-dlambda
(seq
  (let
    (f1/1030
       (function x0/1031
         (let (c/1032 x0/1031)
           (seq (assign c/1032 (+. x0/1031 c/1032))
             (assign c/1032 (+. x0/1031 c/1032))
             (assign c/1032 (+. x0/1031 c/1032)) (+. x0/1031 c/1032)))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1033
       (function x0/1034
         (let (c/1035 (caml_ceil_float 3.))
           (seq (assign c/1035 (+. x0/1034 c/1035))
             (assign c/1035 (+. x0/1034 c/1035))
             (assign c/1035 (+. x0/1034 c/1035)) (+. x0/1034 c/1035)))))
    (setfield_imm 1 (global Code!) f2/1033))
  (let
    (f3/1036
       (function x0/1037
         (let (c/1038 (makemutable 0 (caml_ceil_float 3.)))
           (seq (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038)))
             (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038)))
             (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038))) c/1038))))
    (setfield_imm 2 (global Code!) f3/1036))
  (let
    (f4/1039
       (function x0/1040
         (let (c/1041 (caml_ceil_float 3.))
           (seq (assign c/1041 (+. x0/1040 c/1041))
             (assign c/1041 (+. x0/1040 c/1041))
             (assign c/1041 (+. x0/1040 c/1041)) (makemutable 0 c/1041)))))
    (setfield_imm 3 (global Code!) f4/1039))
  (let
    (f5/1042
       (function x0/1043
         (let (c/1044 (caml_ceil_float 3.))
           (seq (assign c/1044 (+. x0/1043 c/1044))
             (assign c/1044 (+. x0/1043 c/1044))
             (assign c/1044 (+. x0/1043 c/1044))
             (makemutable 0 (+. c/1044 0.))))))
    (setfield_imm 4 (global Code!) f5/1042))
  (let
    (f6/1045
       (function x0/1046
         (let (c/1047 (+. x0/1046 0.))
           (seq (assign c/1047 (+. x0/1046 c/1047))
             (assign c/1047 (+. x0/1046 c/1047))
             (assign c/1047 (+. x0/1046 c/1047)) (+. x0/1046 c/1047)))))
    (setfield_imm 5 (global Code!) f6/1045))
  0a)
 After TonLambda.optimize (0 eliminations): 
 (seq
   (let
     (f1/1030
        (function x0/1031
          (let (c/1032 x0/1031)
            (seq (assign c/1032 (+. x0/1031 c/1032))
              (assign c/1032 (+. x0/1031 c/1032))
              (assign c/1032 (+. x0/1031 c/1032)) (+. x0/1031 c/1032)))))
     (setfield_imm 0 (global Code!) f1/1030))
   (let
     (f2/1033
        (function x0/1034
          (let (c/1035 (caml_ceil_float 3.))
            (seq (assign c/1035 (+. x0/1034 c/1035))
              (assign c/1035 (+. x0/1034 c/1035))
              (assign c/1035 (+. x0/1034 c/1035)) (+. x0/1034 c/1035)))))
     (setfield_imm 1 (global Code!) f2/1033))
   (let
     (f3/1036
        (function x0/1037
          (let (c/1038 (makemutable 0 (caml_ceil_float 3.)))
            (seq (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038)))
              (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038)))
              (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038))) c/1038))))
     (setfield_imm 2 (global Code!) f3/1036))
   (let
     (f4/1039
        (function x0/1040
          (let (c/1041 (caml_ceil_float 3.))
            (seq (assign c/1041 (+. x0/1040 c/1041))
              (assign c/1041 (+. x0/1040 c/1041))
              (assign c/1041 (+. x0/1040 c/1041)) (makemutable 0 c/1041)))))
     (setfield_imm 3 (global Code!) f4/1039))
   (let
     (f5/1042
        (function x0/1043
          (let (c/1044 (caml_ceil_float 3.))
            (seq (assign c/1044 (+. x0/1043 c/1044))
              (assign c/1044 (+. x0/1043 c/1044))
              (assign c/1044 (+. x0/1043 c/1044))
              (makemutable 0 (+. c/1044 0.))))))
     (setfield_imm 4 (global Code!) f5/1042))
   (let
     (f6/1045
        (function x0/1046
          (let (c/1047 (+. x0/1046 0.))
            (seq (assign c/1047 (+. x0/1046 c/1047))
              (assign c/1047 (+. x0/1046 c/1047))
              (assign c/1047 (+. x0/1046 c/1047)) (+. x0/1046 c/1047)))))
     (setfield_imm 5 (global Code!) f6/1045))
   0a)
lambda saved
typedtree saved
-dclosure
(seq
  (let
    (f1/1030
       (closure (camlCode__f1_1030(1)  x0/1031
                 (let (c/1032 x0/1031)
                   (seq (assign c/1032 (+. x0/1031 c/1032))
                     (assign c/1032 (+. x0/1031 c/1032))
                     (assign c/1032 (+. x0/1031 c/1032)) (+. x0/1031 c/1032)))) 
        ))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let
    (f2/1033
       (closure (camlCode__f2_1033(1)  x0/1034
                 (let (c/1035 (caml_ceil_float 3.))
                   (seq (assign c/1035 (+. x0/1034 c/1035))
                     (assign c/1035 (+. x0/1034 c/1035))
                     (assign c/1035 (+. x0/1034 c/1035)) (+. x0/1034 c/1035)))) 
        ))
    (setfield_imm 1 (global camlCode!) f2/1033))
  (let
    (f3/1036
       (closure (camlCode__f3_1036(1)  x0/1037
                 (let (c/1038 (makemutable 0 (caml_ceil_float 3.)))
                   (seq (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038)))
                     (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038)))
                     (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038)))
                     c/1038))) ))
    (setfield_imm 2 (global camlCode!) f3/1036))
  (let
    (f4/1039
       (closure (camlCode__f4_1039(1)  x0/1040
                 (let (c/1041 (caml_ceil_float 3.))
                   (seq (assign c/1041 (+. x0/1040 c/1041))
                     (assign c/1041 (+. x0/1040 c/1041))
                     (assign c/1041 (+. x0/1040 c/1041))
                     (makemutable 0 c/1041)))) ))
    (setfield_imm 3 (global camlCode!) f4/1039))
  (let
    (f5/1042
       (closure (camlCode__f5_1042(1)  x0/1043
                 (let (c/1044 (caml_ceil_float 3.))
                   (seq (assign c/1044 (+. x0/1043 c/1044))
                     (assign c/1044 (+. x0/1043 c/1044))
                     (assign c/1044 (+. x0/1043 c/1044))
                     (makemutable 0 (+. c/1044 0.))))) ))
    (setfield_imm 4 (global camlCode!) f5/1042))
  (let
    (f6/1045
       (closure (camlCode__f6_1045(1)  x0/1046
                 (let (c/1047 (+. x0/1046 0.))
                   (seq (assign c/1047 (+. x0/1046 c/1047))
                     (assign c/1047 (+. x0/1046 c/1047))
                     (assign c/1047 (+. x0/1046 c/1047)) (+. x0/1046 c/1047)))) 
        ))
    (setfield_imm 5 (global camlCode!) f6/1045))
  0a)(seq
       (let
         (f1/1030
            (closure (camlCode__f1_1030(1)  x0/1031
                      (let (c/1032 x0/1031)
                        (seq (assign c/1032 (+. x0/1031 c/1032))
                          (assign c/1032 (+. x0/1031 c/1032))
                          (assign c/1032 (+. x0/1031 c/1032))
                          (+. x0/1031 c/1032)))) ))
         (setfield_imm 0 (global camlCode!) f1/1030))
       (let
         (f2/1033
            (closure (camlCode__f2_1033(1)  x0/1034
                      (let (c/1035 (caml_ceil_float 3.))
                        (seq (assign c/1035 (+. x0/1034 c/1035))
                          (assign c/1035 (+. x0/1034 c/1035))
                          (assign c/1035 (+. x0/1034 c/1035))
                          (+. x0/1034 c/1035)))) ))
         (setfield_imm 1 (global camlCode!) f2/1033))
       (let
         (f3/1036
            (closure (camlCode__f3_1036(1)  x0/1037
                      (let (c/1038 (makemutable 0 (caml_ceil_float 3.)))
                        (seq
                          (setfield_ptr 0 c/1038
                            (+. x0/1037 (field 0 c/1038)))
                          (setfield_ptr 0 c/1038
                            (+. x0/1037 (field 0 c/1038)))
                          (setfield_ptr 0 c/1038
                            (+. x0/1037 (field 0 c/1038)))
                          c/1038))) ))
         (setfield_imm 2 (global camlCode!) f3/1036))
       (let
         (f4/1039
            (closure (camlCode__f4_1039(1)  x0/1040
                      (let (c/1041 (caml_ceil_float 3.))
                        (seq (assign c/1041 (+. x0/1040 c/1041))
                          (assign c/1041 (+. x0/1040 c/1041))
                          (assign c/1041 (+. x0/1040 c/1041))
                          (makemutable 0 c/1041)))) ))
         (setfield_imm 3 (global camlCode!) f4/1039))
       (let
         (f5/1042
            (closure (camlCode__f5_1042(1)  x0/1043
                      (let (c/1044 (caml_ceil_float 3.))
                        (seq (assign c/1044 (+. x0/1043 c/1044))
                          (assign c/1044 (+. x0/1043 c/1044))
                          (assign c/1044 (+. x0/1043 c/1044))
                          (makemutable 0 (+. c/1044 0.))))) ))
         (setfield_imm 4 (global camlCode!) f5/1042))
       (let
         (f6/1045
            (closure (camlCode__f6_1045(1)  x0/1046
                      (let (c/1047 (+. x0/1046 0.))
                        (seq (assign c/1047 (+. x0/1046 c/1047))
                          (assign c/1047 (+. x0/1046 c/1047))
                          (assign c/1047 (+. x0/1046 c/1047))
                          (+. x0/1046 c/1047)))) ))
         (setfield_imm 5 (global camlCode!) f6/1045))lambda saved
typedtree saved

-dcmm
(data int 6144 global "camlCode" "camlCode": skip 48)
(data int 2295 "camlCode__1": addr "camlCode__f6_1045" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f5_1042" int 3)
(data int 2295 "camlCode__3": addr "camlCode__f4_1039" int 3)
(data int 2295 "camlCode__4": addr "camlCode__f3_1036" int 3)
(data int 2295 "camlCode__5": addr "camlCode__f2_1033" int 3)
(data int 2295 "camlCode__6": addr "camlCode__f1_1030" int 3)
(function camlCode__f1_1030 (x0/1031: addr)
 (let c/1032 x0/1031
   (assign c/1032
             (alloc 1277 (+f (load float64u x0/1031) (load float64u c/1032))))
   (assign c/1032
             (alloc 1277 (+f (load float64u x0/1031) (load float64u c/1032))))
   (assign c/1032
             (alloc 1277 (+f (load float64u x0/1031) (load float64u c/1032))))
   (alloc 1277 (+f (load float64u x0/1031) (load float64u c/1032)))))

(function camlCode__f2_1033 (x0/1034: addr)
 (let c/1063 (extcall "ceil" 3. float)
   (assign c/1063 (+f (load float64u x0/1034) c/1063))
   (assign c/1063 (+f (load float64u x0/1034) c/1063))
   (assign c/1063 (+f (load float64u x0/1034) c/1063))
   (alloc 1277 (+f (load float64u x0/1034) c/1063))))

(function camlCode__f3_1036 (x0/1037: addr)
 (let c/1038 (alloc 1024 (alloc 1277 (extcall "ceil" 3. float)))
   (extcall "caml_modify" c/1038
     (alloc 1277 (+f (load float64u x0/1037) (load float64u (load c/1038))))
     unit)
   (extcall "caml_modify" c/1038
     (alloc 1277 (+f (load float64u x0/1037) (load float64u (load c/1038))))
     unit)
   (extcall "caml_modify" c/1038
     (alloc 1277 (+f (load float64u x0/1037) (load float64u (load c/1038))))
     unit)
   c/1038))

(function camlCode__f4_1039 (x0/1040: addr)
 (let c/1041 (alloc 1277 (extcall "ceil" 3. float))
   (assign c/1041
             (alloc 1277 (+f (load float64u x0/1040) (load float64u c/1041))))
   (assign c/1041
             (alloc 1277 (+f (load float64u x0/1040) (load float64u c/1041))))
   (assign c/1041
             (alloc 1277 (+f (load float64u x0/1040) (load float64u c/1041))))
   (alloc 1024 c/1041)))

(function camlCode__f5_1042 (x0/1043: addr)
 (let c/1061 (extcall "ceil" 3. float)
   (assign c/1061 (+f (load float64u x0/1043) c/1061))
   (assign c/1061 (+f (load float64u x0/1043) c/1061))
   (assign c/1061 (+f (load float64u x0/1043) c/1061))
   (alloc 1024 (alloc 1277 (+f c/1061 0.)))))

(function camlCode__f6_1045 (x0/1046: addr)
 (let c/1060 (+f (load float64u x0/1046) 0.)
   (assign c/1060 (+f (load float64u x0/1046) c/1060))
   (assign c/1060 (+f (load float64u x0/1046) c/1060))
   (assign c/1060 (+f (load float64u x0/1046) c/1060))
   (alloc 1277 (+f (load float64u x0/1046) c/1060))))

(function camlCode__entry ()
 (let f1/1030 "camlCode__6" (store "camlCode" f1/1030))
 (let f2/1033 "camlCode__5" (store (+a "camlCode" 8) f2/1033))
 (let f3/1036 "camlCode__4" (store (+a "camlCode" 16) f3/1036))
 (let f4/1039 "camlCode__3" (store (+a "camlCode" 24) f4/1039))
 (let f5/1042 "camlCode__2" (store (+a "camlCode" 32) f5/1042))
 (let f6/1045 "camlCode__1" (store (+a "camlCode" 40) f6/1045)) 1a)

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
	.quad	6144
	.globl	camlCode
camlCode:
	.space	48
	.data
	.quad	2295
camlCode__1:
	.quad	camlCode__f6_1045
	.quad	3
	.data
	.quad	2295
camlCode__2:
	.quad	camlCode__f5_1042
	.quad	3
	.data
	.quad	2295
camlCode__3:
	.quad	camlCode__f4_1039
	.quad	3
	.data
	.quad	2295
camlCode__4:
	.quad	camlCode__f3_1036
	.quad	3
	.data
	.quad	2295
camlCode__5:
	.quad	camlCode__f2_1033
	.quad	3
	.data
	.quad	2295
camlCode__6:
	.quad	camlCode__f1_1030
	.quad	3
	.text
	.align	16
	.globl	camlCode__f1_1030
camlCode__f1_1030:
	subq	$8, %rsp
.L100:
	movq	%rax, %rsi
	movq	%rsi, %rdi
.L101:	subq	$64, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L102
	leaq	8(%r15), %rbx
	movq	$1277, -8(%rbx)
	movlpd	(%rsi), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rbx)
	movq	%rbx, %rdi
	leaq	16(%rbx), %rax
	movq	$1277, -8(%rax)
	movlpd	(%rsi), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rax)
	movq	%rax, %rdi
	leaq	32(%rbx), %rax
	movq	$1277, -8(%rax)
	movlpd	(%rsi), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rax)
	movq	%rax, %rdi
	leaq	48(%rbx), %rax
	movq	$1277, -8(%rax)
	movlpd	(%rsi), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L102:	call	caml_call_gc@PLT
.L103:	jmp	.L101
	.type	camlCode__f1_1030,@function
	.size	camlCode__f1_1030,.-camlCode__f1_1030
	.text
	.align	16
	.globl	camlCode__f2_1033
camlCode__f2_1033:
	subq	$8, %rsp
.L104:
	movq	%rax, %rbx
	movlpd	.L105(%rip), %xmm0
	call	ceil@PLT
	addsd	(%rbx), %xmm0
	addsd	(%rbx), %xmm0
	addsd	(%rbx), %xmm0
.L106:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L107
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	addsd	(%rbx), %xmm0
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L107:	call	caml_call_gc@PLT
.L108:	jmp	.L106
	.section	.rodata.cst8,"a",@progbits
.L105:	.quad	0x4008000000000000
	.type	camlCode__f2_1033,@function
	.size	camlCode__f2_1033,.-camlCode__f2_1033
	.text
	.align	16
	.globl	camlCode__f3_1036
camlCode__f3_1036:
	subq	$8, %rsp
.L109:
	movq	%rax, %rbp
	movlpd	.L110(%rip), %xmm0
	call	ceil@PLT
.L111:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L112
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	movlpd	%xmm0, (%rax)
	leaq	16(%rax), %rbx
	movq	$1024, -8(%rbx)
	movq	%rax, (%rbx)
	leaq	32(%rax), %rsi
	movq	$1277, -8(%rsi)
	movq	(%rbx), %rax
	movlpd	(%rbp), %xmm0
	addsd	(%rax), %xmm0
	movlpd	%xmm0, (%rsi)
	movq	%rbx, %rdi
	call	caml_modify@PLT
.L114:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L115
	leaq	8(%r15), %rsi
	movq	$1277, -8(%rsi)
	movq	(%rbx), %rax
	movlpd	(%rbp), %xmm0
	addsd	(%rax), %xmm0
	movlpd	%xmm0, (%rsi)
	movq	%rbx, %rdi
	call	caml_modify@PLT
.L117:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L118
	leaq	8(%r15), %rsi
	movq	$1277, -8(%rsi)
	movq	(%rbx), %rax
	movlpd	(%rbp), %xmm0
	addsd	(%rax), %xmm0
	movlpd	%xmm0, (%rsi)
	movq	%rbx, %rdi
	call	caml_modify@PLT
	movq	%rbx, %rax
	addq	$8, %rsp
	ret
.L118:	call	caml_call_gc@PLT
.L119:	jmp	.L117
.L115:	call	caml_call_gc@PLT
.L116:	jmp	.L114
.L112:	call	caml_call_gc@PLT
.L113:	jmp	.L111
	.section	.rodata.cst8,"a",@progbits
.L110:	.quad	0x4008000000000000
	.type	camlCode__f3_1036,@function
	.size	camlCode__f3_1036,.-camlCode__f3_1036
	.text
	.align	16
	.globl	camlCode__f4_1039
camlCode__f4_1039:
	subq	$8, %rsp
.L120:
	movq	%rax, %rbx
	movlpd	.L121(%rip), %xmm0
	call	ceil@PLT
.L122:	subq	$80, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L123
	leaq	8(%r15), %rdi
	movq	$1277, -8(%rdi)
	movlpd	%xmm0, (%rdi)
	leaq	16(%rdi), %rax
	movq	$1277, -8(%rax)
	movlpd	(%rbx), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rax)
	movq	%rax, %rdi
	leaq	32(%rdi), %rax
	movq	$1277, -8(%rax)
	movlpd	(%rbx), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rax)
	movq	%rax, %rdi
	leaq	48(%rdi), %rax
	movq	$1277, -8(%rax)
	movlpd	(%rbx), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rax)
	movq	%rax, %rdi
	leaq	64(%rdi), %rax
	movq	$1024, -8(%rax)
	movq	%rdi, (%rax)
	addq	$8, %rsp
	ret
.L123:	call	caml_call_gc@PLT
.L124:	jmp	.L122
	.section	.rodata.cst8,"a",@progbits
.L121:	.quad	0x4008000000000000
	.type	camlCode__f4_1039,@function
	.size	camlCode__f4_1039,.-camlCode__f4_1039
	.text
	.align	16
	.globl	camlCode__f5_1042
camlCode__f5_1042:
	subq	$8, %rsp
.L125:
	movq	%rax, %rbx
	movlpd	.L126(%rip), %xmm0
	call	ceil@PLT
	addsd	(%rbx), %xmm0
	addsd	(%rbx), %xmm0
	addsd	(%rbx), %xmm0
.L127:	subq	$32, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L128
	leaq	8(%r15), %rbx
	movq	$1277, -8(%rbx)
	xorpd	%xmm1, %xmm1
	addsd	%xmm1, %xmm0
	movlpd	%xmm0, (%rbx)
	leaq	16(%rbx), %rax
	movq	$1024, -8(%rax)
	movq	%rbx, (%rax)
	addq	$8, %rsp
	ret
.L128:	call	caml_call_gc@PLT
.L129:	jmp	.L127
	.section	.rodata.cst8,"a",@progbits
.L126:	.quad	0x4008000000000000
	.type	camlCode__f5_1042,@function
	.size	camlCode__f5_1042,.-camlCode__f5_1042
	.text
	.align	16
	.globl	camlCode__f6_1045
camlCode__f6_1045:
	subq	$8, %rsp
.L130:
	movq	%rax, %rbx
	xorpd	%xmm0, %xmm0
	addsd	(%rbx), %xmm0
	addsd	(%rbx), %xmm0
	addsd	(%rbx), %xmm0
	addsd	(%rbx), %xmm0
.L131:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L132
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	addsd	(%rbx), %xmm0
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L132:	call	caml_call_gc@PLT
.L133:	jmp	.L131
	.type	camlCode__f6_1045,@function
	.size	camlCode__f6_1045,.-camlCode__f6_1045
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L134:
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
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 24(%rax)
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 32(%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 40(%rax)
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
	.quad	8
	.quad	.L133
	.word	16
	.word	1
	.word	3
	.align	8
	.quad	.L129
	.word	16
	.word	0
	.align	8
	.quad	.L124
	.word	16
	.word	1
	.word	3
	.align	8
	.quad	.L119
	.word	16
	.word	2
	.word	3
	.word	21
	.align	8
	.quad	.L116
	.word	16
	.word	2
	.word	3
	.word	21
	.align	8
	.quad	.L113
	.word	16
	.word	1
	.word	21
	.align	8
	.quad	.L108
	.word	16
	.word	1
	.word	3
	.align	8
	.quad	.L103
	.word	16
	.word	2
	.word	5
	.word	7
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

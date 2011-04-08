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
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
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
-dclosure
*** After Closure.intro:
(seq
  (let
    (f1/1030
       (closure (camlCode__f1_1030(1)  x0/1031
                  (let (c/1032[Variable] x0/1031)
                    (seq (assign c/1032 (+. x0/1031 c/1032))
                      (assign c/1032 (+. x0/1031 c/1032))
                      (assign c/1032 (+. x0/1031 c/1032))
                      (+. x0/1031 c/1032)))) {2} ))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let
    (f2/1033
       (closure (camlCode__f2_1033(1)  x0/1034
                  (let (c/1035[Variable] (caml_ceil_float 3.))
                    (seq (assign c/1035 (+. x0/1034 c/1035))
                      (assign c/1035 (+. x0/1034 c/1035))
                      (assign c/1035 (+. x0/1034 c/1035))
                      (+. x0/1034 c/1035)))) {2} ))
    (setfield_imm 1 (global camlCode!) f2/1033))
  (let
    (f3/1036
       (closure (camlCode__f3_1036(1)  x0/1037
                  (let (c/1038 (makemutable 0 (caml_ceil_float 3.)))
                    (seq
                      (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038)))
                      (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038)))
                      (setfield_ptr 0 c/1038 (+. x0/1037 (field 0 c/1038)))
                      c/1038))) {2} ))
    (setfield_imm 2 (global camlCode!) f3/1036))
  (let
    (f4/1039
       (closure (camlCode__f4_1039(1)  x0/1040
                  (let (c/1041[Variable] (caml_ceil_float 3.))
                    (seq (assign c/1041 (+. x0/1040 c/1041))
                      (assign c/1041 (+. x0/1040 c/1041))
                      (assign c/1041 (+. x0/1040 c/1041))
                      (makemutable 0 c/1041)))) {2} ))
    (setfield_imm 3 (global camlCode!) f4/1039))
  (let
    (f5/1042
       (closure (camlCode__f5_1042(1)  x0/1043
                  (let (c/1044[Variable] (caml_ceil_float 3.))
                    (seq (assign c/1044 (+. x0/1043 c/1044))
                      (assign c/1044 (+. x0/1043 c/1044))
                      (assign c/1044 (+. x0/1043 c/1044))
                      (makemutable 0 (+. c/1044 0.))))) {2} ))
    (setfield_imm 4 (global camlCode!) f5/1042))
  (let
    (f6/1045
       (closure (camlCode__f6_1045(1)  x0/1046
                  (let (c/1047[Variable] (+. x0/1046 0.))
                    (seq (assign c/1047 (+. x0/1046 c/1047))
                      (assign c/1047 (+. x0/1046 c/1047))
                      (assign c/1047 (+. x0/1046 c/1047))
                      (+. x0/1046 c/1047)))) {2} ))
    (setfield_imm 5 (global camlCode!) f6/1045))
  0a)
*** After TonClosure.optimize:
(let
  (f1/1030
     (closure (camlCode__f1_1030(1)  x0/1031
                (let (c/1032[Variable] x0/1031)
                  (seq (assign c/1032 (+. x0/1031 c/1032))
                    (assign c/1032 (+. x0/1031 c/1032))
                    (assign c/1032 (+. x0/1031 c/1032)) (+. x0/1031 c/1032)))) 
       {2} ))
  (seq (setfield_imm 0 (global camlCode!) f1/1030)
    (let
      (f2/1033
         (closure (camlCode__f2_1033(1)  x0/1034
                    (let (c/1035[Variable] (caml_ceil_float 3.))
                      (seq (assign c/1035 (+. x0/1034 c/1035))
                        (assign c/1035 (+. x0/1034 c/1035))
                        (assign c/1035 (+. x0/1034 c/1035))
                        (+. x0/1034 c/1035)))) {2} ))
      (seq (setfield_imm 1 (global camlCode!) f2/1033)
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
                            c/1038))) {2} ))
          (seq (setfield_imm 2 (global camlCode!) f3/1036)
            (let
              (f4/1039
                 (closure (camlCode__f4_1039(1)  x0/1040
                            (let (c/1041[Variable] (caml_ceil_float 3.))
                              (seq (assign c/1041 (+. x0/1040 c/1041))
                                (assign c/1041 (+. x0/1040 c/1041))
                                (assign c/1041 (+. x0/1040 c/1041))
                                (makemutable 0 c/1041)))) {2} ))
              (seq (setfield_imm 3 (global camlCode!) f4/1039)
                (let
                  (f5/1042
                     (closure (camlCode__f5_1042(1)  x0/1043
                                (let (c/1044[Variable] (caml_ceil_float 3.))
                                  (seq (assign c/1044 (+. x0/1043 c/1044))
                                    (assign c/1044 (+. x0/1043 c/1044))
                                    (assign c/1044 (+. x0/1043 c/1044))
                                    (makemutable 0 (+. c/1044 0.))))) 
                       {2} ))
                  (seq (setfield_imm 4 (global camlCode!) f5/1042)
                    (let
                      (f6/1045
                         (closure (camlCode__f6_1045(1)  x0/1046
                                    (let (c/1047[Variable] (+. x0/1046 0.))
                                      (seq
                                        (assign c/1047 (+. x0/1046 c/1047))
                                        (assign c/1047 (+. x0/1046 c/1047))
                                        (assign c/1047 (+. x0/1046 c/1047))
                                        (+. x0/1046 c/1047)))) {2} ))
                      (seq (setfield_imm 5 (global camlCode!) f6/1045) 0a))))))))))))

-dcmm
(data int 6144 global "camlCode" "camlCode": skip 24)
(data int 2295 "camlCode__1": addr "camlCode__f6_1045" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f5_1042" int 3)
(data int 2295 "camlCode__3": addr "camlCode__f4_1039" int 3)
(data int 2295 "camlCode__4": addr "camlCode__f3_1036" int 3)
(data int 2295 "camlCode__5": addr "camlCode__f2_1033" int 3)
(data int 2295 "camlCode__6": addr "camlCode__f1_1030" int 3)
(function camlCode__f1_1030 (x0/1031: addr)
 (let c/1032 x0/1031
   (assign c/1032
             (alloc 2301 (+f (load float64u x0/1031) (load float64u c/1032))))
   (assign c/1032
             (alloc 2301 (+f (load float64u x0/1031) (load float64u c/1032))))
   (assign c/1032
             (alloc 2301 (+f (load float64u x0/1031) (load float64u c/1032))))
   (alloc 2301 (+f (load float64u x0/1031) (load float64u c/1032)))))

(function camlCode__f2_1033 (x0/1034: addr)
 (let c/1063 (extcall "ceil" 3. float)
   (assign c/1063 (+f (load float64u x0/1034) c/1063))
   (assign c/1063 (+f (load float64u x0/1034) c/1063))
   (assign c/1063 (+f (load float64u x0/1034) c/1063))
   (alloc 2301 (+f (load float64u x0/1034) c/1063))))

(function camlCode__f3_1036 (x0/1037: addr)
 (let c/1038 (alloc 1024 (alloc 2301 (extcall "ceil" 3. float)))
   (extcall "caml_modify" c/1038
     (alloc 2301 (+f (load float64u x0/1037) (load float64u (load c/1038))))
     unit)
   (extcall "caml_modify" c/1038
     (alloc 2301 (+f (load float64u x0/1037) (load float64u (load c/1038))))
     unit)
   (extcall "caml_modify" c/1038
     (alloc 2301 (+f (load float64u x0/1037) (load float64u (load c/1038))))
     unit)
   c/1038))

(function camlCode__f4_1039 (x0/1040: addr)
 (let c/1062 (extcall "ceil" 3. float)
   (assign c/1062 (+f (load float64u x0/1040) c/1062))
   (assign c/1062 (+f (load float64u x0/1040) c/1062))
   (assign c/1062 (+f (load float64u x0/1040) c/1062))
   (alloc 1024 (let c/1041 (alloc 2301 c/1062) c/1041))))

(function camlCode__f5_1042 (x0/1043: addr)
 (let c/1061 (extcall "ceil" 3. float)
   (assign c/1061 (+f (load float64u x0/1043) c/1061))
   (assign c/1061 (+f (load float64u x0/1043) c/1061))
   (assign c/1061 (+f (load float64u x0/1043) c/1061))
   (alloc 1024 (alloc 2301 (+f c/1061 0.)))))

(function camlCode__f6_1045 (x0/1046: addr)
 (let c/1060 (+f (load float64u x0/1046) 0.)
   (assign c/1060 (+f (load float64u x0/1046) c/1060))
   (assign c/1060 (+f (load float64u x0/1046) c/1060))
   (assign c/1060 (+f (load float64u x0/1046) c/1060))
   (alloc 2301 (+f (load float64u x0/1046) c/1060))))

(function camlCode__entry ()
 (let f1/1030 "camlCode__6" (store "camlCode" f1/1030)
   (let f2/1033 "camlCode__5" (store (+a "camlCode" 4) f2/1033)
     (let f3/1036 "camlCode__4" (store (+a "camlCode" 8) f3/1036)
       (let f4/1039 "camlCode__3" (store (+a "camlCode" 12) f4/1039)
         (let f5/1042 "camlCode__2" (store (+a "camlCode" 16) f5/1042)
           (let f6/1045 "camlCode__1" (store (+a "camlCode" 20) f6/1045) 1a)))))))

(data)
-dlinear
Before simplify
camlCode__f1_1030:
                  x0/8[%edx] := R/0[%eax]
                  c/9[%ecx] := x0/8[%edx]
                  {x0/8[%edx]* c/9[%ecx]*}
                  A/10[%ebx] := alloc 48
                  [A/10[%ebx] + -4] := 2301
                  R/7[%tos] := float64u[x0/8[%edx]]
                  R/7[%tos] := R/7[%tos] +f float64[c/9[%ecx]]
                  float64u[A/10[%ebx]] := R/7[%tos]
                  c/9[%ecx] := A/10[%ebx]
                  A/13[%eax] := A/10[%ebx] + 12
                  [A/13[%eax] + -4] := 2301
                  R/7[%tos] := float64u[x0/8[%edx]]
                  R/7[%tos] := R/7[%tos] +f float64[c/9[%ecx]]
                  float64u[A/13[%eax]] := R/7[%tos]
                  c/9[%ecx] := A/13[%eax]
                  A/16[%eax] := A/10[%ebx] + 24
                  [A/16[%eax] + -4] := 2301
                  R/7[%tos] := float64u[x0/8[%edx]]
                  R/7[%tos] := R/7[%tos] +f float64[c/9[%ecx]]
                  float64u[A/16[%eax]] := R/7[%tos]
                  c/9[%ecx] := A/16[%eax]
                  A/19[%eax] := A/10[%ebx] + 36
                  [A/19[%eax] + -4] := 2301
                  R/7[%tos] := float64u[x0/8[%edx]]
                  R/7[%tos] := R/7[%tos] +f float64[c/9[%ecx]]
                  float64u[A/19[%eax]] := R/7[%tos]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f1_1030:
  x0/8[%edx] := R/0[%eax]
  c/9[%ecx] := x0/8[%edx]
  {x0/8[%edx]* c/9[%ecx]*}
  A/10[%ebx] := alloc 48
  [A/10[%ebx] + -4] := 2301
  R/7[%tos] := float64u[x0/8[%edx]]
  R/7[%tos] := R/7[%tos] +f float64[c/9[%ecx]]
  float64u[A/10[%ebx]] := R/7[%tos]
  c/9[%ecx] := A/10[%ebx]
  A/13[%eax] := A/10[%ebx] + 12
  [A/13[%eax] + -4] := 2301
  R/7[%tos] := float64u[x0/8[%edx]]
  R/7[%tos] := R/7[%tos] +f float64[c/9[%ecx]]
  float64u[A/13[%eax]] := R/7[%tos]
  c/9[%ecx] := A/13[%eax]
  A/16[%eax] := A/10[%ebx] + 24
  [A/16[%eax] + -4] := 2301
  R/7[%tos] := float64u[x0/8[%edx]]
  R/7[%tos] := R/7[%tos] +f float64[c/9[%ecx]]
  float64u[A/16[%eax]] := R/7[%tos]
  c/9[%ecx] := A/16[%eax]
  A/19[%eax] := A/10[%ebx] + 36
  [A/19[%eax] + -4] := 2301
  R/7[%tos] := float64u[x0/8[%edx]]
  R/7[%tos] := R/7[%tos] +f float64[c/9[%ecx]]
  float64u[A/19[%eax]] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__f2_1033:
                  x0/8[%ebx] := R/0[%eax]
                  R/7[%tos] := 3.
                  push R/7[%tos]
                  {x0/8[%ebx]*}
                  R/7[%tos] := extcall "ceil" 
                  offset stack -8
                  c/10[s0] := R/7[%tos]
                  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
                  c/10[s0] := R/7[%tos]
                  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
                  c/10[s0] := R/7[%tos]
                  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
                  c/10[s0] := R/7[%tos]
                  {x0/8[%ebx]* c/10[s0]}
                  A/14[%eax] := alloc 12
                  [A/14[%eax] + -4] := 2301
                  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
                  float64u[A/14[%eax]] := R/7[%tos]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f2_1033:
  x0/8[%ebx] := R/0[%eax]
  R/7[%tos] := 3.
  push R/7[%tos]
  {x0/8[%ebx]*}
  R/7[%tos] := extcall "ceil" 
  offset stack -8
  c/10[s0] := R/7[%tos]
  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
  c/10[s0] := R/7[%tos]
  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
  c/10[s0] := R/7[%tos]
  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
  c/10[s0] := R/7[%tos]
  {x0/8[%ebx]* c/10[s0]}
  A/14[%eax] := alloc 12
  [A/14[%eax] + -4] := 2301
  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
  float64u[A/14[%eax]] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__f3_1036:
                  x0/8[%esi] := R/0[%eax]
                  R/7[%tos] := 3.
                  push R/7[%tos]
                  {x0/8[%esi]*}
                  R/7[%tos] := extcall "ceil" 
                  offset stack -8
                  F/10[s0] := R/7[%tos]
                  {x0/8[%esi]* F/10[s0]}
                  A/11[%eax] := alloc 32
                  [A/11[%eax] + -4] := 2301
                  float64u[A/11[%eax]] := F/10[s0]
                  c/12[%ebx] := A/11[%eax] + 12
                  [c/12[%ebx] + -4] := 1024
                  [c/12[%ebx]] := A/11[%eax]
                  A/13[%ecx] := A/11[%eax] + 20
                  [A/13[%ecx] + -4] := 2301
                  A/14[%eax] := [c/12[%ebx]]
                  R/7[%tos] := float64u[x0/8[%esi]]
                  R/7[%tos] := R/7[%tos] +f float64[A/14[%eax]]
                  float64u[A/13[%ecx]] := R/7[%tos]
                  push A/13[%ecx]
                  push c/12[%ebx]
                  {x0/8[%esi]* c/12[%ebx]*}
                  extcall "caml_modify" 
                  offset stack -8
                  {x0/8[%esi]* c/12[%ebx]*}
                  A/17[%ecx] := alloc 12
                  [A/17[%ecx] + -4] := 2301
                  A/18[%eax] := [c/12[%ebx]]
                  R/7[%tos] := float64u[x0/8[%esi]]
                  R/7[%tos] := R/7[%tos] +f float64[A/18[%eax]]
                  float64u[A/17[%ecx]] := R/7[%tos]
                  push A/17[%ecx]
                  push c/12[%ebx]
                  {x0/8[%esi]* c/12[%ebx]*}
                  extcall "caml_modify" 
                  offset stack -8
                  {x0/8[%esi]* c/12[%ebx]*}
                  A/21[%ecx] := alloc 12
                  [A/21[%ecx] + -4] := 2301
                  A/22[%eax] := [c/12[%ebx]]
                  R/7[%tos] := float64u[x0/8[%esi]]
                  R/7[%tos] := R/7[%tos] +f float64[A/22[%eax]]
                  float64u[A/21[%ecx]] := R/7[%tos]
                  push A/21[%ecx]
                  push c/12[%ebx]
                  {c/12[%ebx]*}
                  extcall "caml_modify" 
                  offset stack -8
                  R/0[%eax] := c/12[%ebx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f3_1036:
  x0/8[%esi] := R/0[%eax]
  R/7[%tos] := 3.
  push R/7[%tos]
  {x0/8[%esi]*}
  R/7[%tos] := extcall "ceil" 
  offset stack -8
  F/10[s0] := R/7[%tos]
  {x0/8[%esi]* F/10[s0]}
  A/11[%eax] := alloc 32
  [A/11[%eax] + -4] := 2301
  float64u[A/11[%eax]] := F/10[s0]
  c/12[%ebx] := A/11[%eax] + 12
  [c/12[%ebx] + -4] := 1024
  [c/12[%ebx]] := A/11[%eax]
  A/13[%ecx] := A/11[%eax] + 20
  [A/13[%ecx] + -4] := 2301
  A/14[%eax] := [c/12[%ebx]]
  R/7[%tos] := float64u[x0/8[%esi]]
  R/7[%tos] := R/7[%tos] +f float64[A/14[%eax]]
  float64u[A/13[%ecx]] := R/7[%tos]
  push A/13[%ecx]
  push c/12[%ebx]
  {x0/8[%esi]* c/12[%ebx]*}
  extcall "caml_modify" 
  offset stack -8
  {x0/8[%esi]* c/12[%ebx]*}
  A/17[%ecx] := alloc 12
  [A/17[%ecx] + -4] := 2301
  A/18[%eax] := [c/12[%ebx]]
  R/7[%tos] := float64u[x0/8[%esi]]
  R/7[%tos] := R/7[%tos] +f float64[A/18[%eax]]
  float64u[A/17[%ecx]] := R/7[%tos]
  push A/17[%ecx]
  push c/12[%ebx]
  {x0/8[%esi]* c/12[%ebx]*}
  extcall "caml_modify" 
  offset stack -8
  {x0/8[%esi]* c/12[%ebx]*}
  A/21[%ecx] := alloc 12
  [A/21[%ecx] + -4] := 2301
  A/22[%eax] := [c/12[%ebx]]
  R/7[%tos] := float64u[x0/8[%esi]]
  R/7[%tos] := R/7[%tos] +f float64[A/22[%eax]]
  float64u[A/21[%ecx]] := R/7[%tos]
  push A/21[%ecx]
  push c/12[%ebx]
  {c/12[%ebx]*}
  extcall "caml_modify" 
  offset stack -8
  R/0[%eax] := c/12[%ebx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__f4_1039:
                  x0/8[%ebx] := R/0[%eax]
                  R/7[%tos] := 3.
                  push R/7[%tos]
                  {x0/8[%ebx]*}
                  R/7[%tos] := extcall "ceil" 
                  offset stack -8
                  c/10[s0] := R/7[%tos]
                  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
                  c/10[s0] := R/7[%tos]
                  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
                  c/10[s0] := R/7[%tos]
                  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
                  c/10[s0] := R/7[%tos]
                  {c/10[s0]}
                  c/14[%ebx] := alloc 20
                  [c/14[%ebx] + -4] := 2301
                  float64u[c/14[%ebx]] := c/10[s0]
                  A/16[%eax] := c/14[%ebx] + 12
                  [A/16[%eax] + -4] := 1024
                  [A/16[%eax]] := A/15[%ebx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f4_1039:
  x0/8[%ebx] := R/0[%eax]
  R/7[%tos] := 3.
  push R/7[%tos]
  {x0/8[%ebx]*}
  R/7[%tos] := extcall "ceil" 
  offset stack -8
  c/10[s0] := R/7[%tos]
  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
  c/10[s0] := R/7[%tos]
  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
  c/10[s0] := R/7[%tos]
  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
  c/10[s0] := R/7[%tos]
  {c/10[s0]}
  c/14[%ebx] := alloc 20
  [c/14[%ebx] + -4] := 2301
  float64u[c/14[%ebx]] := c/10[s0]
  A/16[%eax] := c/14[%ebx] + 12
  [A/16[%eax] + -4] := 1024
  [A/16[%eax]] := A/15[%ebx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__f5_1042:
                  x0/8[%ebx] := R/0[%eax]
                  R/7[%tos] := 3.
                  push R/7[%tos]
                  {x0/8[%ebx]*}
                  R/7[%tos] := extcall "ceil" 
                  offset stack -8
                  c/10[s0] := R/7[%tos]
                  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
                  c/10[s0] := R/7[%tos]
                  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
                  c/10[s0] := R/7[%tos]
                  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
                  c/10[s0] := R/7[%tos]
                  {c/10[s0]}
                  A/14[%ebx] := alloc 20
                  [A/14[%ebx] + -4] := 2301
                  R/7[%tos] := 0.
                  R/7[%tos] := c/10[s0] +f R/7[%tos]
                  float64u[A/14[%ebx]] := R/7[%tos]
                  A/17[%eax] := A/14[%ebx] + 12
                  [A/17[%eax] + -4] := 1024
                  [A/17[%eax]] := A/14[%ebx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f5_1042:
  x0/8[%ebx] := R/0[%eax]
  R/7[%tos] := 3.
  push R/7[%tos]
  {x0/8[%ebx]*}
  R/7[%tos] := extcall "ceil" 
  offset stack -8
  c/10[s0] := R/7[%tos]
  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
  c/10[s0] := R/7[%tos]
  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
  c/10[s0] := R/7[%tos]
  R/7[%tos] := c/10[s0] +f float64[x0/8[%ebx]]
  c/10[s0] := R/7[%tos]
  {c/10[s0]}
  A/14[%ebx] := alloc 20
  [A/14[%ebx] + -4] := 2301
  R/7[%tos] := 0.
  R/7[%tos] := c/10[s0] +f R/7[%tos]
  float64u[A/14[%ebx]] := R/7[%tos]
  A/17[%eax] := A/14[%ebx] + 12
  [A/17[%eax] + -4] := 1024
  [A/17[%eax]] := A/14[%ebx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__f6_1045:
                  x0/8[%ebx] := R/0[%eax]
                  R/7[%tos] := 0.
                  R/7[%tos] := R/7[%tos] +f float64[x0/8[%ebx]]
                  c/11[s0] := R/7[%tos]
                  R/7[%tos] := c/11[s0] +f float64[x0/8[%ebx]]
                  c/11[s0] := R/7[%tos]
                  R/7[%tos] := c/11[s0] +f float64[x0/8[%ebx]]
                  c/11[s0] := R/7[%tos]
                  R/7[%tos] := c/11[s0] +f float64[x0/8[%ebx]]
                  c/11[s0] := R/7[%tos]
                  {x0/8[%ebx]* c/11[s0]}
                  A/15[%eax] := alloc 12
                  [A/15[%eax] + -4] := 2301
                  R/7[%tos] := c/11[s0] +f float64[x0/8[%ebx]]
                  float64u[A/15[%eax]] := R/7[%tos]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f6_1045:
  x0/8[%ebx] := R/0[%eax]
  R/7[%tos] := 0.
  R/7[%tos] := R/7[%tos] +f float64[x0/8[%ebx]]
  c/11[s0] := R/7[%tos]
  R/7[%tos] := c/11[s0] +f float64[x0/8[%ebx]]
  c/11[s0] := R/7[%tos]
  R/7[%tos] := c/11[s0] +f float64[x0/8[%ebx]]
  c/11[s0] := R/7[%tos]
  R/7[%tos] := c/11[s0] +f float64[x0/8[%ebx]]
  c/11[s0] := R/7[%tos]
  {x0/8[%ebx]* c/11[s0]}
  A/15[%eax] := alloc 12
  [A/15[%eax] + -4] := 2301
  R/7[%tos] := c/11[s0] +f float64[x0/8[%ebx]]
  float64u[A/15[%eax]] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  f1/8[%eax] := "camlCode__6"
                  ["camlCode"] := f1/8[%eax]
                  f2/9[%eax] := "camlCode__5"
                  ["camlCode" + 4] := f2/9[%eax]
                  f3/10[%eax] := "camlCode__4"
                  ["camlCode" + 8] := f3/10[%eax]
                  f4/11[%eax] := "camlCode__3"
                  ["camlCode" + 12] := f4/11[%eax]
                  f5/12[%eax] := "camlCode__2"
                  ["camlCode" + 16] := f5/12[%eax]
                  f6/13[%eax] := "camlCode__1"
                  ["camlCode" + 20] := f6/13[%eax]
                  A/14[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  f1/8[%eax] := "camlCode__6"
  ["camlCode"] := f1/8[%eax]
  f2/9[%eax] := "camlCode__5"
  ["camlCode" + 4] := f2/9[%eax]
  f3/10[%eax] := "camlCode__4"
  ["camlCode" + 8] := f3/10[%eax]
  f4/11[%eax] := "camlCode__3"
  ["camlCode" + 12] := f4/11[%eax]
  f5/12[%eax] := "camlCode__2"
  ["camlCode" + 16] := f5/12[%eax]
  f6/13[%eax] := "camlCode__1"
  ["camlCode" + 20] := f6/13[%eax]
  A/14[%eax] := 1
  return R/0[%eax]
  
-S
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.long	6144
	.globl	camlCode
camlCode:
	.space	24
	.data
	.long	2295
camlCode__1:
	.long	camlCode__f6_1045
	.long	3
	.data
	.long	2295
camlCode__2:
	.long	camlCode__f5_1042
	.long	3
	.data
	.long	2295
camlCode__3:
	.long	camlCode__f4_1039
	.long	3
	.data
	.long	2295
camlCode__4:
	.long	camlCode__f3_1036
	.long	3
	.data
	.long	2295
camlCode__5:
	.long	camlCode__f2_1033
	.long	3
	.data
	.long	2295
camlCode__6:
	.long	camlCode__f1_1030
	.long	3
	.text
	.align	16
	.globl	camlCode__f1_1030
camlCode__f1_1030:
	subl	$8, %esp
.L100:
	movl	%eax, %edx
	movl	%edx, %ecx
.L101:	movl	caml_young_ptr, %eax
	subl	$48, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L102
	leal	4(%eax), %ebx
	movl	$2301, -4(%ebx)
	fldl	(%edx)
	faddl	(%ecx)
	fstpl	(%ebx)
	movl	%ebx, %ecx
	leal	12(%ebx), %eax
	movl	$2301, -4(%eax)
	fldl	(%edx)
	faddl	(%ecx)
	fstpl	(%eax)
	movl	%eax, %ecx
	leal	24(%ebx), %eax
	movl	$2301, -4(%eax)
	fldl	(%edx)
	faddl	(%ecx)
	fstpl	(%eax)
	movl	%eax, %ecx
	leal	36(%ebx), %eax
	movl	$2301, -4(%eax)
	fldl	(%edx)
	faddl	(%ecx)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L102:	call	caml_call_gc
.L103:	jmp	.L101
	.type	camlCode__f1_1030,@function
	.size	camlCode__f1_1030,.-camlCode__f1_1030
	.text
	.align	16
	.globl	camlCode__f2_1033
camlCode__f2_1033:
	subl	$8, %esp
.L104:
	movl	%eax, %ebx
	fldl	.L105
	subl	$8, %esp
	fstpl	0(%esp)
	call	ceil
	addl	$8, %esp
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
.L106:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L107
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L107:	call	caml_call_gc
.L108:	jmp	.L106
	.data
.L105:	.long	0x0, 0x40080000
	.type	camlCode__f2_1033,@function
	.size	camlCode__f2_1033,.-camlCode__f2_1033
	.text
	.align	16
	.globl	camlCode__f3_1036
camlCode__f3_1036:
	subl	$8, %esp
.L109:
	movl	%eax, %esi
	fldl	.L110
	subl	$8, %esp
	fstpl	0(%esp)
	call	ceil
	addl	$8, %esp
	fstpl	0(%esp)
.L111:	movl	caml_young_ptr, %eax
	subl	$32, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L112
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	0(%esp)
	fstpl	(%eax)
	leal	12(%eax), %ebx
	movl	$1024, -4(%ebx)
	movl	%eax, (%ebx)
	leal	20(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	(%ebx), %eax
	fldl	(%esi)
	faddl	(%eax)
	fstpl	(%ecx)
	pushl	%ecx
	pushl	%ebx
	call	caml_modify
	addl	$8, %esp
.L114:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L115
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	(%ebx), %eax
	fldl	(%esi)
	faddl	(%eax)
	fstpl	(%ecx)
	pushl	%ecx
	pushl	%ebx
	call	caml_modify
	addl	$8, %esp
.L117:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L118
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	(%ebx), %eax
	fldl	(%esi)
	faddl	(%eax)
	fstpl	(%ecx)
	pushl	%ecx
	pushl	%ebx
	call	caml_modify
	addl	$8, %esp
	movl	%ebx, %eax
	addl	$8, %esp
	ret
.L118:	call	caml_call_gc
.L119:	jmp	.L117
.L115:	call	caml_call_gc
.L116:	jmp	.L114
.L112:	call	caml_call_gc
.L113:	jmp	.L111
	.data
.L110:	.long	0x0, 0x40080000
	.type	camlCode__f3_1036,@function
	.size	camlCode__f3_1036,.-camlCode__f3_1036
	.text
	.align	16
	.globl	camlCode__f4_1039
camlCode__f4_1039:
	subl	$8, %esp
.L120:
	movl	%eax, %ebx
	fldl	.L121
	subl	$8, %esp
	fstpl	0(%esp)
	call	ceil
	addl	$8, %esp
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
.L122:	movl	caml_young_ptr, %eax
	subl	$20, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L123
	leal	4(%eax), %ebx
	movl	$2301, -4(%ebx)
	fldl	0(%esp)
	fstpl	(%ebx)
	leal	12(%ebx), %eax
	movl	$1024, -4(%eax)
	movl	%ebx, (%eax)
	addl	$8, %esp
	ret
.L123:	call	caml_call_gc
.L124:	jmp	.L122
	.data
.L121:	.long	0x0, 0x40080000
	.type	camlCode__f4_1039,@function
	.size	camlCode__f4_1039,.-camlCode__f4_1039
	.text
	.align	16
	.globl	camlCode__f5_1042
camlCode__f5_1042:
	subl	$8, %esp
.L125:
	movl	%eax, %ebx
	fldl	.L126
	subl	$8, %esp
	fstpl	0(%esp)
	call	ceil
	addl	$8, %esp
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
.L127:	movl	caml_young_ptr, %eax
	subl	$20, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L128
	leal	4(%eax), %ebx
	movl	$2301, -4(%ebx)
	fldz
	faddl	0(%esp)
	fstpl	(%ebx)
	leal	12(%ebx), %eax
	movl	$1024, -4(%eax)
	movl	%ebx, (%eax)
	addl	$8, %esp
	ret
.L128:	call	caml_call_gc
.L129:	jmp	.L127
	.data
.L126:	.long	0x0, 0x40080000
	.type	camlCode__f5_1042,@function
	.size	camlCode__f5_1042,.-camlCode__f5_1042
	.text
	.align	16
	.globl	camlCode__f6_1045
camlCode__f6_1045:
	subl	$8, %esp
.L130:
	movl	%eax, %ebx
	fldz
	faddl	(%ebx)
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
.L131:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L132
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L132:	call	caml_call_gc
.L133:	jmp	.L131
	.type	camlCode__f6_1045,@function
	.size	camlCode__f6_1045,.-camlCode__f6_1045
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L134:
	movl	$camlCode__6, %eax
	movl	%eax, camlCode
	movl	$camlCode__5, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__4, %eax
	movl	%eax, camlCode + 8
	movl	$camlCode__3, %eax
	movl	%eax, camlCode + 12
	movl	$camlCode__2, %eax
	movl	%eax, camlCode + 16
	movl	$camlCode__1, %eax
	movl	%eax, camlCode + 20
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
	.long	8
	.long	.L133
	.word	12
	.word	1
	.word	3
	.align	4
	.long	.L129
	.word	12
	.word	0
	.align	4
	.long	.L124
	.word	12
	.word	0
	.align	4
	.long	.L119
	.word	12
	.word	2
	.word	3
	.word	9
	.align	4
	.long	.L116
	.word	12
	.word	2
	.word	3
	.word	9
	.align	4
	.long	.L113
	.word	12
	.word	1
	.word	9
	.align	4
	.long	.L108
	.word	12
	.word	1
	.word	3
	.align	4
	.long	.L103
	.word	12
	.word	2
	.word	5
	.word	7
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

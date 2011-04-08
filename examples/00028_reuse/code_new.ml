(* 
In [f0], the compiler should detect that the closure for [g0] contains only
[y], and so, the closure should not be allocated. 

In [f1], the compiler should detect that the closure for [g1] contains only
[y] and [c1], and so, it can avoid allocating the closure by giving 
[y] and [c1] as extra arguments to [g1].
*)

let _ =
  let f0 x y =
    let g0 z = 
      let sum = ref 0 in
      let list = List.iter (fun a -> sum := !sum + y * z) [1;2;3;4;5;6] in
      !sum 
    in
    g0 (x+3)
  in
  f0 0 1
  
let _ =
  let c1 = [1;2;3;4;5;6] in
  let f1 x y =
    let g1 z = 
      let sum = ref 0 in
      let list = List.iter (fun a -> sum := !sum + y * z) c1 in
      !sum 
    in
    g1 (x+3)
  in
  f1 0 1
  
    (*
-drawlambda
File "code.ml", line 14, characters 10-14:
Warning 26: unused variable list.
File "code.ml", line 26, characters 10-14:
Warning 26: unused variable list.
(seq
  (let
    (f0/1030
       (function x/1031 y/1032
         (let
           (g0/1033
              (function z/1034
                (let
                  (sum/1035 (makemutable 0 0)
                   list/1036
                     (apply (field 10 (global List!))
                       (function a/1037
                         (setfield_imm 0 sum/1035
                           (+ (field 0 sum/1035) (* y/1032 z/1034))))
                       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]]))
                  (field 0 sum/1035))))
           (apply g0/1033 (+ x/1031 3)))))
    (apply f0/1030 0 1))
  (let
    (c1/1038 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]]
     f1/1039
       (function x/1040 y/1041
         (let
           (g1/1042
              (function z/1043
                (let
                  (sum/1044 (makemutable 0 0)
                   list/1045
                     (apply (field 10 (global List!))
                       (function a/1046
                         (setfield_imm 0 sum/1044
                           (+ (field 0 sum/1044) (* y/1041 z/1043))))
                       c1/1038))
                  (field 0 sum/1044))))
           (apply g1/1042 (+ x/1040 3)))))
    (apply f1/1039 0 1))
  0a)
-dlambda
File "code.ml", line 14, characters 10-14:
Warning 26: unused variable list.
File "code.ml", line 26, characters 10-14:
Warning 26: unused variable list.
(seq
  (let
    (f0/1030
       (function x/1031 y/1032
         (let
           (g0/1033
              (function z/1034
                (let
                  (sum/1035 (makemutable 0 0)
                   list/1036
                     (apply (field 10 (global List!))
                       (function a/1037
                         (setfield_imm 0 sum/1035
                           (+ (field 0 sum/1035) (* y/1032 z/1034))))
                       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]]))
                  (field 0 sum/1035))))
           (apply g0/1033 (+ x/1031 3)))))
    (apply f0/1030 0 1))
  (let
    (c1/1038 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]]
     f1/1039
       (function x/1040 y/1041
         (let
           (g1/1042
              (function z/1043
                (let
                  (sum/1044 (makemutable 0 0)
                   list/1045
                     (apply (field 10 (global List!))
                       (function a/1046
                         (setfield_imm 0 sum/1044
                           (+ (field 0 sum/1044) (* y/1041 z/1043))))
                       c1/1038))
                  (field 0 sum/1044))))
           (apply g1/1042 (+ x/1040 3)))))
    (apply f1/1039 0 1))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (f0/1030
       (function x/1031 y/1032
         (let
           (g0/1033
              (function z/1034
                (let
                  (sum/1035 (makemutable 0 0)
                   list/1036
                     (apply (field 10 (global List!))
                       (function a/1037
                         (setfield_imm 0 sum/1035
                           (+ (field 0 sum/1035) (* y/1032 z/1034))))
                       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]]))
                  (field 0 sum/1035))))
           (apply g0/1033 (+ x/1031 3)))))
    (apply f0/1030 0 1))
  (let
    (c1/1038 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]]
     f1/1039
       (function x/1040 y/1041
         (let
           (g1/1042
              (function z/1043
                (let
                  (sum/1044 (makemutable 0 0)
                   list/1045
                     (apply (field 10 (global List!))
                       (function a/1046
                         (setfield_imm 0 sum/1044
                           (+ (field 0 sum/1044) (* y/1041 z/1043))))
                       c1/1038))
                  (field 0 sum/1044))))
           (apply g1/1042 (+ x/1040 3)))))
    (apply f1/1039 0 1))
  0a)
-dclosure
File "code.ml", line 14, characters 10-14:
Warning 26: unused variable list.
File "code.ml", line 26, characters 10-14:
Warning 26: unused variable list.
*** After Closure.intro:
(seq
  (let
    (f0/1030
       (closure (camlCode__f0_1030(2)  x/1031 y/1032
                  (let
                    (g0/1033
                       (closure (camlCode__g0_1033(1)  z/1034 env/1058
                                  (let
                                    (sum/1035 (makemutable 0 0)
                                     list/1036
                                       (let
                                         (f/1062
                                            (closure (camlCode__fun_1059(1) 
                                                       a/1037 env/1061
                                                       (setfield_imm 0
                                                         (field 4 env/1061)
                                                         (+
                                                           (field 0
                                                             (field 4
                                                               env/1061))
                                                           (*
                                                             (field 2
                                                               env/1061)
                                                             (field 3
                                                               env/1061))))) 
                                              {2} 
                                              (field 2 env/1058)
                                              z/1034
                                              sum/1035)
                                          param/1063[Variable]
                                            [0:
                                             1
                                             [0:
                                              2
                                              [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]]
                                          f/1064[Variable] f/1062)
                                         (catch
                                           (while 1a
                                             (catch
                                               (exit 71
                                                 (if param/1063
                                                   (let
                                                     (l/1065[Alias]
                                                        (field 1 param/1063)
                                                      a/1066[Alias]
                                                        (field 0 param/1063))
                                                     (seq
                                                       (apply f/1064 a/1066)
                                                       (let (arg/1067 l/1065)
                                                         (seq
                                                           (assign param/1063
                                                             arg/1067)
                                                           (exit 70)))))
                                                   0a))
                                              with (70) 0a))
                                          with (71 res/1450) res/1450)))
                                    (field 0 sum/1035))) {2} 
                                                         y/1032))
                    (camlCode__g0_1033  (+ x/1031 3) g0/1033))) {3} ))
    (camlCode__f0_1030  0 1))
  (let
    (c1/1038 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]]
     f1/1039
       (closure (camlCode__f1_1039(2)  x/1040 y/1041 env/1091
                  (let
                    (g1/1042
                       (closure (camlCode__g1_1042(1)  z/1043 env/1103
                                  (let
                                    (sum/1044 (makemutable 0 0)
                                     list/1045
                                       (let
                                         (param/1107 (field 2 env/1103)
                                          f/1108
                                            (closure (camlCode__fun_1104(1) 
                                                       a/1046 env/1106
                                                       (setfield_imm 0
                                                         (field 4 env/1106)
                                                         (+
                                                           (field 0
                                                             (field 4
                                                               env/1106))
                                                           (*
                                                             (field 2
                                                               env/1106)
                                                             (field 3
                                                               env/1106))))) 
                                              {2} 
                                              (field 3 env/1103)
                                              z/1043
                                              sum/1044)
                                          param/1109[Variable] param/1107
                                          f/1110[Variable] f/1108)
                                         (catch
                                           (while 1a
                                             (catch
                                               (exit 71
                                                 (if param/1109
                                                   (let
                                                     (l/1111[Alias]
                                                        (field 1 param/1109)
                                                      a/1112[Alias]
                                                        (field 0 param/1109))
                                                     (seq
                                                       (apply f/1110 a/1112)
                                                       (let (arg/1113 l/1111)
                                                         (seq
                                                           (assign param/1109
                                                             arg/1113)
                                                           (exit 70)))))
                                                   0a))
                                              with (70) 0a))
                                          with (71 res/1450) res/1450)))
                                    (field 0 sum/1044))) {2} 
                                                         (field 3 env/1091)
                                                         y/1041))
                    (camlCode__g1_1042  (+ x/1040 3) g1/1042))) {3} 
                                                                c1/1038))
    (camlCode__f1_1039  0 1 f1/1039))
  0a)
*** After TonClosure.optimize:
(seq
  (closure (camlCode__f0_1030(2)  x/1031 y/1032
             (let
               (g0/1033
                  (closure (camlCode__g0_1033(1)  z/1034 env/1058
                             (let
                               (sum/1035 (makemutable 0 0)
                                f/1062
                                  (closure (camlCode__fun_1059(1)  a/1037
                                             env/1061
                                             (setfield_imm 0
                                               (field 4 env/1061)
                                               (+
                                                 (field 0 (field 4 env/1061))
                                                 (* (field 2 env/1061)
                                                   (field 3 env/1061))))) 
                                    {2} 
                                    (field 2 env/1058)
                                    z/1034
                                    sum/1035))
                               (seq
                                 (let
                                   (param/1063[Variable]
                                      [0:
                                       1
                                       [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]])
                                   (catch
                                     (while 1a
                                       (catch
                                         (exit 71
                                           (if param/1063
                                             (let
                                               (l/1065[Alias]
                                                  (field 1 param/1063))
                                               (seq
                                                 (setfield_imm 0 sum/1035
                                                   (+ (field 0 sum/1035)
                                                     (* (field 2 f/1062)
                                                       (field 3 f/1062))))
                                                 (assign param/1063 l/1065)
                                                 (exit 70)))
                                             0a))
                                        with (70) 0a))
                                    with (71 res/1450) res/1450))
                                 (field 0 sum/1035)))) {2} 
                                                       y/1032))
               (camlCode__g0_1033  (+ x/1031 3) g0/1033))) {3} )
  (camlCode__f0_1030  0 1)
  (let
    (c1/1038 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 0a]]]]]]
     f1/1039
       (closure (camlCode__f1_1039(2)  x/1040 y/1041 env/1091
                  (let
                    (g1/1042
                       (closure (camlCode__g1_1042(1)  z/1043 env/1103
                                  (let
                                    (sum/1044 (makemutable 0 0)
                                     param/1107 (field 2 env/1103)
                                     f/1108
                                       (closure (camlCode__fun_1104(1) 
                                                  a/1046 env/1106
                                                  (setfield_imm 0
                                                    (field 4 env/1106)
                                                    (+
                                                      (field 0
                                                        (field 4 env/1106))
                                                      (* (field 2 env/1106)
                                                        (field 3 env/1106))))) 
                                         {2} 
                                         (field 3 env/1103)
                                         z/1043
                                         sum/1044))
                                    (seq
                                      (let (param/1109[Variable] param/1107)
                                        (catch
                                          (while 1a
                                            (catch
                                              (exit 71
                                                (if param/1109
                                                  (let
                                                    (l/1111[Alias]
                                                       (field 1 param/1109))
                                                    (seq
                                                      (setfield_imm 0
                                                        sum/1044
                                                        (+ (field 0 sum/1044)
                                                          (* (field 2 f/1108)
                                                            (field 3 f/1108))))
                                                      (assign param/1109
                                                        l/1111)
                                                      (exit 70)))
                                                  0a))
                                             with (70) 0a))
                                         with (71 res/1450) res/1450))
                                      (field 0 sum/1044)))) {2} 
                                                            (field 3
                                                              env/1091)
                                                            y/1041))
                    (camlCode__g1_1042  (+ x/1040 3) g1/1042))) {3} 
                                                                c1/1038))
    (seq (camlCode__f1_1039  0 1 f1/1039) 0a)))

-dcmm
File "code.ml", line 14, characters 10-14:
Warning 26: unused variable list.
File "code.ml", line 26, characters 10-14:
Warning 26: unused variable list.
(data int 0 global "camlCode" "camlCode": skip 0)
(data
 int 3319
 "camlCode__4":
 addr "caml_curry2"
 int 5
 addr "camlCode__f0_1030")
(data
 global "camlCode__1"
 int 2048
 "camlCode__1":
 int 3
 addr L15
 int 2048
 L15:
 int 5
 addr L16
 int 2048
 L16:
 int 7
 addr L17
 int 2048
 L17:
 int 9
 addr L18
 int 2048
 L18:
 int 11
 addr L19
 int 2048
 L19:
 int 13
 int 1)
(data
 global "camlCode__2"
 int 2048
 "camlCode__2":
 int 3
 addr L10
 int 2048
 L10:
 int 5
 addr L11
 int 2048
 L11:
 int 7
 addr L12
 int 2048
 L12:
 int 9
 addr L13
 int 2048
 L13:
 int 11
 addr L14
 int 2048
 L14:
 int 13
 int 1)
(data
 global "camlCode__3"
 int 2048
 "camlCode__3":
 int 3
 addr L5
 int 2048
 L5:
 int 5
 addr L6
 int 2048
 L6:
 int 7
 addr L7
 int 2048
 L7:
 int 9
 addr L8
 int 2048
 L8:
 int 11
 addr L9
 int 2048
 L9:
 int 13
 int 1)
(function camlCode__fun_1059 (a/1037: addr env/1061: addr)
 (store (load (+a env/1061 16))
   (+ (load (load (+a env/1061 16)))
     (* (+ (load (+a env/1061 8)) -1) (>>s (load (+a env/1061 12)) 1))))
 1a)

(function camlCode__fun_1104 (a/1046: addr env/1106: addr)
 (store (load (+a env/1106 16))
   (+ (load (load (+a env/1106 16)))
     (* (+ (load (+a env/1106 8)) -1) (>>s (load (+a env/1106 12)) 1))))
 1a)

(function camlCode__g0_1033 (z/1034: addr env/1058: addr)
 (let
   (sum/1035 (alloc 1024 1)
    f/1062
      (alloc 5367 "camlCode__fun_1059" 3 (load (+a env/1058 8)) z/1034
        sum/1035))
   (let param/1063 "camlCode__2"
     (catch
       (loop
         (catch
           (exit 71
             (if (!= param/1063 1)
               (let l/1065 (load (+a param/1063 4))
                 (store sum/1035
                   (+ (load sum/1035)
                     (* (+ (load (+a f/1062 8)) -1)
                       (>>s (load (+a f/1062 12)) 1))))
                 (assign param/1063 l/1065) (exit 70))
               1a))
         with(70) []))
     with(71 res/1450) res/1450 []))
   (load sum/1035)))

(function camlCode__g1_1042 (z/1043: addr env/1103: addr)
 (let
   (sum/1044 (alloc 1024 1) param/1107 (load (+a env/1103 8))
    f/1108
      (alloc 5367 "camlCode__fun_1104" 3 (load (+a env/1103 12)) z/1043
        sum/1044))
   (let param/1109 param/1107
     (catch
       (loop
         (catch
           (exit 71
             (if (!= param/1109 1)
               (let l/1111 (load (+a param/1109 4))
                 (store sum/1044
                   (+ (load sum/1044)
                     (* (+ (load (+a f/1108 8)) -1)
                       (>>s (load (+a f/1108 12)) 1))))
                 (assign param/1109 l/1111) (exit 70))
               1a))
         with(70) []))
     with(71 res/1450) res/1450 []))
   (load sum/1044)))

(function camlCode__f0_1030 (x/1031: addr y/1032: addr)
 (let g0/1033 (alloc 3319 "camlCode__g0_1033" 3 y/1032)
   (app "camlCode__g0_1033" (+ x/1031 6) g0/1033 addr)))

(function camlCode__f1_1039 (x/1040: addr y/1041: addr env/1091: addr)
 (let
   g1/1042 (alloc 4343 "camlCode__g1_1042" 3 (load (+a env/1091 12)) y/1041)
   (app "camlCode__g1_1042" (+ x/1040 6) g1/1042 addr)))

(function camlCode__entry ()
 "camlCode__4" [] (app "camlCode__f0_1030" 1 3 unit)
 (let
   (c1/1038 "camlCode__3"
    f1/1039 (alloc 4343 "caml_curry2" 5 "camlCode__f1_1039" c1/1038))
   (app "camlCode__f1_1039" 1 3 f1/1039 unit) 1a))

(data)
-dlinear
File "code.ml", line 14, characters 10-14:
Warning 26: unused variable list.
File "code.ml", line 26, characters 10-14:
Warning 26: unused variable list.
Before simplify
camlCode__fun_1059:
                  A/10[%eax] := [env/9[%ebx] + 16]
                  A/11[%edx] := [env/9[%ebx] + 12]
                  I/12[%edx] := I/12[%edx] >>s 1
                  A/13[%ecx] := [env/9[%ebx] + 8]
                  I/14[%ecx] := I/14[%ecx] + -1
                  I/15[%ecx] := I/15[%ecx] * I/12[%edx]
                  A/16[%ebx] := [env/9[%ebx] + 16]
                  A/17[%ebx] := [A/16[%ebx]]
                  I/18[%ebx] := I/18[%ebx] + I/15[%ecx]
                  [A/10[%eax]] := I/18[%ebx]
                  A/19[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_1059:
  A/10[%eax] := [env/9[%ebx] + 16]
  A/11[%edx] := [env/9[%ebx] + 12]
  I/12[%edx] := I/12[%edx] >>s 1
  A/13[%ecx] := [env/9[%ebx] + 8]
  I/14[%ecx] := I/14[%ecx] + -1
  I/15[%ecx] := I/15[%ecx] * I/12[%edx]
  A/16[%ebx] := [env/9[%ebx] + 16]
  A/17[%ebx] := [A/16[%ebx]]
  I/18[%ebx] := I/18[%ebx] + I/15[%ecx]
  [A/10[%eax]] := I/18[%ebx]
  A/19[%eax] := 1
  return R/0[%eax]
  
Before simplify
camlCode__fun_1104:
                  A/10[%eax] := [env/9[%ebx] + 16]
                  A/11[%edx] := [env/9[%ebx] + 12]
                  I/12[%edx] := I/12[%edx] >>s 1
                  A/13[%ecx] := [env/9[%ebx] + 8]
                  I/14[%ecx] := I/14[%ecx] + -1
                  I/15[%ecx] := I/15[%ecx] * I/12[%edx]
                  A/16[%ebx] := [env/9[%ebx] + 16]
                  A/17[%ebx] := [A/16[%ebx]]
                  I/18[%ebx] := I/18[%ebx] + I/15[%ecx]
                  [A/10[%eax]] := I/18[%ebx]
                  A/19[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_1104:
  A/10[%eax] := [env/9[%ebx] + 16]
  A/11[%edx] := [env/9[%ebx] + 12]
  I/12[%edx] := I/12[%edx] >>s 1
  A/13[%ecx] := [env/9[%ebx] + 8]
  I/14[%ecx] := I/14[%ecx] + -1
  I/15[%ecx] := I/15[%ecx] * I/12[%edx]
  A/16[%ebx] := [env/9[%ebx] + 16]
  A/17[%ebx] := [A/16[%ebx]]
  I/18[%ebx] := I/18[%ebx] + I/15[%ecx]
  [A/10[%eax]] := I/18[%ebx]
  A/19[%eax] := 1
  return R/0[%eax]
  
Before simplify
camlCode__g0_1033:
                  z/8[%edx] := R/0[%eax]
                  {z/8[%edx]* env/9[%ebx]*}
                  sum/10[%ecx] := alloc 32
                  [sum/10[%ecx] + -4] := 1024
                  [sum/10[%ecx]] := 1
                  f/11[%eax] := sum/10[%ecx] + 8
                  [f/11[%eax] + -4] := 5367
                  [f/11[%eax]] := "camlCode__fun_1059"
                  [f/11[%eax] + 4] := 3
                  A/12[%ebx] := [env/9[%ebx] + 8]
                  [f/11[%eax] + 8] := A/12[%ebx]
                  [f/11[%eax] + 12] := z/8[%edx]
                  [f/11[%eax] + 16] := sum/10[%ecx]
                  param/13[%ebx] := "camlCode__2"
                  L103 [0]:
                  if param/13[%ebx] ==s 1 goto L104
                  l/15[%ebx] := [param/13[%ebx] + 4]
                  A/16[%edx] := [f/11[%eax] + 12]
                  I/17[%edx] := I/17[%edx] >>s 1
                  A/18[%esi] := [f/11[%eax] + 8]
                  I/19[%esi] := I/19[%esi] + -1
                  I/20[%esi] := I/20[%esi] * I/17[%edx]
                  A/21[%edx] := [sum/10[%ecx]]
                  I/22[%edx] := I/22[%edx] + I/20[%esi]
                  [sum/10[%ecx]] := I/22[%edx]
                  goto L103
                  L104 [0]:
                  A/23[%eax] := 1
                  L102 [0]:
                  A/24[%eax] := [sum/10[%ecx]]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__g0_1033:
  z/8[%edx] := R/0[%eax]
  {z/8[%edx]* env/9[%ebx]*}
  sum/10[%ecx] := alloc 32
  [sum/10[%ecx] + -4] := 1024
  [sum/10[%ecx]] := 1
  f/11[%eax] := sum/10[%ecx] + 8
  [f/11[%eax] + -4] := 5367
  [f/11[%eax]] := "camlCode__fun_1059"
  [f/11[%eax] + 4] := 3
  A/12[%ebx] := [env/9[%ebx] + 8]
  [f/11[%eax] + 8] := A/12[%ebx]
  [f/11[%eax] + 12] := z/8[%edx]
  [f/11[%eax] + 16] := sum/10[%ecx]
  param/13[%ebx] := "camlCode__2"
  L103 [3]:
  if param/13[%ebx] ==s 1 goto L104
  l/15[%ebx] := [param/13[%ebx] + 4]
  A/16[%edx] := [f/11[%eax] + 12]
  I/17[%edx] := I/17[%edx] >>s 1
  A/18[%esi] := [f/11[%eax] + 8]
  I/19[%esi] := I/19[%esi] + -1
  I/20[%esi] := I/20[%esi] * I/17[%edx]
  A/21[%edx] := [sum/10[%ecx]]
  I/22[%edx] := I/22[%edx] + I/20[%esi]
  [sum/10[%ecx]] := I/22[%edx]
  goto L103
  L104 [2]:
  A/23[%eax] := 1
  L102 [2]:
  A/24[%eax] := [sum/10[%ecx]]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__g1_1042:
                  z/8[%edx] := R/0[%eax]
                  env/9[%esi] := R/1[%ebx]
                  {z/8[%edx]* env/9[%esi]*}
                  sum/10[%ecx] := alloc 32
                  [sum/10[%ecx] + -4] := 1024
                  [sum/10[%ecx]] := 1
                  param/11[%ebx] := [env/9[%esi] + 8]
                  f/12[%eax] := sum/10[%ecx] + 8
                  [f/12[%eax] + -4] := 5367
                  [f/12[%eax]] := "camlCode__fun_1104"
                  [f/12[%eax] + 4] := 3
                  A/13[%esi] := [env/9[%esi] + 12]
                  [f/12[%eax] + 8] := A/13[%esi]
                  [f/12[%eax] + 12] := z/8[%edx]
                  [f/12[%eax] + 16] := sum/10[%ecx]
                  L110 [0]:
                  if param/14[%ebx] ==s 1 goto L111
                  l/16[%ebx] := [param/14[%ebx] + 4]
                  A/17[%edx] := [f/12[%eax] + 12]
                  I/18[%edx] := I/18[%edx] >>s 1
                  A/19[%esi] := [f/12[%eax] + 8]
                  I/20[%esi] := I/20[%esi] + -1
                  I/21[%esi] := I/21[%esi] * I/18[%edx]
                  A/22[%edx] := [sum/10[%ecx]]
                  I/23[%edx] := I/23[%edx] + I/21[%esi]
                  [sum/10[%ecx]] := I/23[%edx]
                  goto L110
                  L111 [0]:
                  A/24[%eax] := 1
                  L109 [0]:
                  A/25[%eax] := [sum/10[%ecx]]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__g1_1042:
  z/8[%edx] := R/0[%eax]
  env/9[%esi] := R/1[%ebx]
  {z/8[%edx]* env/9[%esi]*}
  sum/10[%ecx] := alloc 32
  [sum/10[%ecx] + -4] := 1024
  [sum/10[%ecx]] := 1
  param/11[%ebx] := [env/9[%esi] + 8]
  f/12[%eax] := sum/10[%ecx] + 8
  [f/12[%eax] + -4] := 5367
  [f/12[%eax]] := "camlCode__fun_1104"
  [f/12[%eax] + 4] := 3
  A/13[%esi] := [env/9[%esi] + 12]
  [f/12[%eax] + 8] := A/13[%esi]
  [f/12[%eax] + 12] := z/8[%edx]
  [f/12[%eax] + 16] := sum/10[%ecx]
  L110 [3]:
  if param/14[%ebx] ==s 1 goto L111
  l/16[%ebx] := [param/14[%ebx] + 4]
  A/17[%edx] := [f/12[%eax] + 12]
  I/18[%edx] := I/18[%edx] >>s 1
  A/19[%esi] := [f/12[%eax] + 8]
  I/20[%esi] := I/20[%esi] + -1
  I/21[%esi] := I/21[%esi] * I/18[%edx]
  A/22[%edx] := [sum/10[%ecx]]
  I/23[%edx] := I/23[%edx] + I/21[%esi]
  [sum/10[%ecx]] := I/23[%edx]
  goto L110
  L111 [2]:
  A/24[%eax] := 1
  L109 [2]:
  A/25[%eax] := [sum/10[%ecx]]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__f0_1030:
                  x/8[%edx] := R/0[%eax]
                  y/9[%ecx] := R/1[%ebx]
                  {x/8[%edx]* y/9[%ecx]*}
                  g0/10[%ebx] := alloc 16
                  [g0/10[%ebx] + -4] := 3319
                  [g0/10[%ebx]] := "camlCode__g0_1033"
                  [g0/10[%ebx] + 4] := 3
                  [g0/10[%ebx] + 8] := y/9[%ecx]
                  I/11[%eax] := x/8[%edx]
                  I/11[%eax] := I/11[%eax] + 6
                  tailcall "camlCode__g0_1033" R/0[%eax] R/1[%ebx]
                  *** Linearized code
camlCode__f0_1030:
  x/8[%edx] := R/0[%eax]
  y/9[%ecx] := R/1[%ebx]
  {x/8[%edx]* y/9[%ecx]*}
  g0/10[%ebx] := alloc 16
  [g0/10[%ebx] + -4] := 3319
  [g0/10[%ebx]] := "camlCode__g0_1033"
  [g0/10[%ebx] + 4] := 3
  [g0/10[%ebx] + 8] := y/9[%ecx]
  I/11[%eax] := x/8[%edx]
  I/11[%eax] := I/11[%eax] + 6
  tailcall "camlCode__g0_1033" R/0[%eax] R/1[%ebx]
  
Before simplify
camlCode__f1_1039:
                  x/8[%edx] := R/0[%eax]
                  y/9[%esi] := R/1[%ebx]
                  {x/8[%edx]* y/9[%esi]* env/10[%ecx]*}
                  g1/11[%ebx] := alloc 20
                  [g1/11[%ebx] + -4] := 4343
                  [g1/11[%ebx]] := "camlCode__g1_1042"
                  [g1/11[%ebx] + 4] := 3
                  A/12[%eax] := [env/10[%ecx] + 12]
                  [g1/11[%ebx] + 8] := A/12[%eax]
                  [g1/11[%ebx] + 12] := y/9[%esi]
                  I/13[%eax] := x/8[%edx]
                  I/13[%eax] := I/13[%eax] + 6
                  tailcall "camlCode__g1_1042" R/0[%eax] R/1[%ebx]
                  *** Linearized code
camlCode__f1_1039:
  x/8[%edx] := R/0[%eax]
  y/9[%esi] := R/1[%ebx]
  {x/8[%edx]* y/9[%esi]* env/10[%ecx]*}
  g1/11[%ebx] := alloc 20
  [g1/11[%ebx] + -4] := 4343
  [g1/11[%ebx]] := "camlCode__g1_1042"
  [g1/11[%ebx] + 4] := 3
  A/12[%eax] := [env/10[%ecx] + 12]
  [g1/11[%ebx] + 8] := A/12[%eax]
  [g1/11[%ebx] + 12] := y/9[%esi]
  I/13[%eax] := x/8[%edx]
  I/13[%eax] := I/13[%eax] + 6
  tailcall "camlCode__g1_1042" R/0[%eax] R/1[%ebx]
  
Before simplify
camlCode__entry:
                  A/8[%eax] := "camlCode__4"
                  I/9[%ebx] := 3
                  I/10[%eax] := 1
                  {}
                  call "camlCode__f0_1030" R/0[%eax] R/1[%ebx]
                  c1/11[%ebx] := "camlCode__3"
                  {c1/11[%ebx]*}
                  f1/12[%ecx] := alloc 20
                  [f1/12[%ecx] + -4] := 4343
                  [f1/12[%ecx]] := "caml_curry2"
                  [f1/12[%ecx] + 4] := 5
                  [f1/12[%ecx] + 8] := "camlCode__f1_1039"
                  [f1/12[%ecx] + 12] := c1/11[%ebx]
                  I/13[%ebx] := 3
                  I/14[%eax] := 1
                  {}
                  call "camlCode__f1_1039" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  A/15[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  A/8[%eax] := "camlCode__4"
  I/9[%ebx] := 3
  I/10[%eax] := 1
  {}
  call "camlCode__f0_1030" R/0[%eax] R/1[%ebx]
  c1/11[%ebx] := "camlCode__3"
  {c1/11[%ebx]*}
  f1/12[%ecx] := alloc 20
  [f1/12[%ecx] + -4] := 4343
  [f1/12[%ecx]] := "caml_curry2"
  [f1/12[%ecx] + 4] := 5
  [f1/12[%ecx] + 8] := "camlCode__f1_1039"
  [f1/12[%ecx] + 12] := c1/11[%ebx]
  I/13[%ebx] := 3
  I/14[%eax] := 1
  {}
  call "camlCode__f1_1039" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/15[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
-S
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.long	0
	.globl	camlCode
camlCode:
	.data
	.long	3319
camlCode__4:
	.long	caml_curry2
	.long	5
	.long	camlCode__f0_1030
	.data
	.globl	camlCode__1
	.long	2048
camlCode__1:
	.long	3
	.long	.L100015
	.long	2048
.L100015:
	.long	5
	.long	.L100016
	.long	2048
.L100016:
	.long	7
	.long	.L100017
	.long	2048
.L100017:
	.long	9
	.long	.L100018
	.long	2048
.L100018:
	.long	11
	.long	.L100019
	.long	2048
.L100019:
	.long	13
	.long	1
	.data
	.globl	camlCode__2
	.long	2048
camlCode__2:
	.long	3
	.long	.L100010
	.long	2048
.L100010:
	.long	5
	.long	.L100011
	.long	2048
.L100011:
	.long	7
	.long	.L100012
	.long	2048
.L100012:
	.long	9
	.long	.L100013
	.long	2048
.L100013:
	.long	11
	.long	.L100014
	.long	2048
.L100014:
	.long	13
	.long	1
	.data
	.globl	camlCode__3
	.long	2048
camlCode__3:
	.long	3
	.long	.L100005
	.long	2048
.L100005:
	.long	5
	.long	.L100006
	.long	2048
.L100006:
	.long	7
	.long	.L100007
	.long	2048
.L100007:
	.long	9
	.long	.L100008
	.long	2048
.L100008:
	.long	11
	.long	.L100009
	.long	2048
.L100009:
	.long	13
	.long	1
	.text
	.align	16
	.globl	camlCode__fun_1059
camlCode__fun_1059:
.L100:
	movl	16(%ebx), %eax
	movl	12(%ebx), %edx
	sarl	$1, %edx
	movl	8(%ebx), %ecx
	decl	%ecx
	imull	%edx, %ecx
	movl	16(%ebx), %ebx
	movl	(%ebx), %ebx
	addl	%ecx, %ebx
	movl	%ebx, (%eax)
	movl	$1, %eax
	ret
	.type	camlCode__fun_1059,@function
	.size	camlCode__fun_1059,.-camlCode__fun_1059
	.text
	.align	16
	.globl	camlCode__fun_1104
camlCode__fun_1104:
.L101:
	movl	16(%ebx), %eax
	movl	12(%ebx), %edx
	sarl	$1, %edx
	movl	8(%ebx), %ecx
	decl	%ecx
	imull	%edx, %ecx
	movl	16(%ebx), %ebx
	movl	(%ebx), %ebx
	addl	%ecx, %ebx
	movl	%ebx, (%eax)
	movl	$1, %eax
	ret
	.type	camlCode__fun_1104,@function
	.size	camlCode__fun_1104,.-camlCode__fun_1104
	.text
	.align	16
	.globl	camlCode__g0_1033
camlCode__g0_1033:
.L105:
	movl	%eax, %edx
.L106:	movl	caml_young_ptr, %eax
	subl	$32, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L107
	leal	4(%eax), %ecx
	movl	$1024, -4(%ecx)
	movl	$1, (%ecx)
	leal	8(%ecx), %eax
	movl	$5367, -4(%eax)
	movl	$camlCode__fun_1059, (%eax)
	movl	$3, 4(%eax)
	movl	8(%ebx), %ebx
	movl	%ebx, 8(%eax)
	movl	%edx, 12(%eax)
	movl	%ecx, 16(%eax)
	movl	$camlCode__2, %ebx
.L103:
	cmpl	$1, %ebx
	je	.L104
	movl	4(%ebx), %ebx
	movl	12(%eax), %edx
	sarl	$1, %edx
	movl	8(%eax), %esi
	decl	%esi
	imull	%edx, %esi
	movl	(%ecx), %edx
	addl	%esi, %edx
	movl	%edx, (%ecx)
	jmp	.L103
	.align	16
.L104:
	movl	$1, %eax
.L102:
	movl	(%ecx), %eax
	ret
.L107:	call	caml_call_gc
.L108:	jmp	.L106
	.type	camlCode__g0_1033,@function
	.size	camlCode__g0_1033,.-camlCode__g0_1033
	.text
	.align	16
	.globl	camlCode__g1_1042
camlCode__g1_1042:
.L112:
	movl	%eax, %edx
	movl	%ebx, %esi
.L113:	movl	caml_young_ptr, %eax
	subl	$32, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L114
	leal	4(%eax), %ecx
	movl	$1024, -4(%ecx)
	movl	$1, (%ecx)
	movl	8(%esi), %ebx
	leal	8(%ecx), %eax
	movl	$5367, -4(%eax)
	movl	$camlCode__fun_1104, (%eax)
	movl	$3, 4(%eax)
	movl	12(%esi), %esi
	movl	%esi, 8(%eax)
	movl	%edx, 12(%eax)
	movl	%ecx, 16(%eax)
.L110:
	cmpl	$1, %ebx
	je	.L111
	movl	4(%ebx), %ebx
	movl	12(%eax), %edx
	sarl	$1, %edx
	movl	8(%eax), %esi
	decl	%esi
	imull	%edx, %esi
	movl	(%ecx), %edx
	addl	%esi, %edx
	movl	%edx, (%ecx)
	jmp	.L110
	.align	16
.L111:
	movl	$1, %eax
.L109:
	movl	(%ecx), %eax
	ret
.L114:	call	caml_call_gc
.L115:	jmp	.L113
	.type	camlCode__g1_1042,@function
	.size	camlCode__g1_1042,.-camlCode__g1_1042
	.text
	.align	16
	.globl	camlCode__f0_1030
camlCode__f0_1030:
.L116:
	movl	%eax, %edx
	movl	%ebx, %ecx
.L117:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L118
	leal	4(%eax), %ebx
	movl	$3319, -4(%ebx)
	movl	$camlCode__g0_1033, (%ebx)
	movl	$3, 4(%ebx)
	movl	%ecx, 8(%ebx)
	movl	%edx, %eax
	addl	$6, %eax
	jmp	camlCode__g0_1033
.L118:	call	caml_call_gc
.L119:	jmp	.L117
	.type	camlCode__f0_1030,@function
	.size	camlCode__f0_1030,.-camlCode__f0_1030
	.text
	.align	16
	.globl	camlCode__f1_1039
camlCode__f1_1039:
.L120:
	movl	%eax, %edx
	movl	%ebx, %esi
.L121:	movl	caml_young_ptr, %eax
	subl	$20, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L122
	leal	4(%eax), %ebx
	movl	$4343, -4(%ebx)
	movl	$camlCode__g1_1042, (%ebx)
	movl	$3, 4(%ebx)
	movl	12(%ecx), %eax
	movl	%eax, 8(%ebx)
	movl	%esi, 12(%ebx)
	movl	%edx, %eax
	addl	$6, %eax
	jmp	camlCode__g1_1042
.L122:	call	caml_call_gc
.L123:	jmp	.L121
	.type	camlCode__f1_1039,@function
	.size	camlCode__f1_1039,.-camlCode__f1_1039
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L124:
	movl	$camlCode__4, %eax
	movl	$3, %ebx
	movl	$1, %eax
	call	camlCode__f0_1030
.L125:
	movl	$camlCode__3, %ebx
	movl	$20, %eax
	call	caml_allocN
.L126:
	leal	4(%eax), %ecx
	movl	$4343, -4(%ecx)
	movl	$caml_curry2, (%ecx)
	movl	$5, 4(%ecx)
	movl	$camlCode__f1_1039, 8(%ecx)
	movl	%ebx, 12(%ecx)
	movl	$3, %ebx
	movl	$1, %eax
	call	camlCode__f1_1039
.L127:
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
	.long	7
	.long	.L127
	.word	4
	.word	0
	.align	4
	.long	.L126
	.word	4
	.word	1
	.word	3
	.align	4
	.long	.L125
	.word	4
	.word	0
	.align	4
	.long	.L123
	.word	4
	.word	3
	.word	5
	.word	9
	.word	7
	.align	4
	.long	.L119
	.word	4
	.word	2
	.word	5
	.word	7
	.align	4
	.long	.L115
	.word	4
	.word	2
	.word	9
	.word	7
	.align	4
	.long	.L108
	.word	4
	.word	2
	.word	3
	.word	7
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

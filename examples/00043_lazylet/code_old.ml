

let _ =
  match Sys.argv.(1) with
  | "0" ->
      for i = 0 to 10000000 do
        let f x =
          x +. sqrt (float i)
        in
        for j = 0 to 10 do
          f (float j)
        done
      done
  | "1" ->
      for i = 0 to 10000000 do
        let a = lazy (sqrt (float i)) in
        let f x =
          x +. Lazy.force a
        in
        for j = 0 to 10 do
          f (float j)
        done
      done
  | "2" ->
      for i = 0 to 10000000 do
        let f x =
          x +. sqrt (float i)
        in
        for j = 0 to 10 do
          f (float j)
        done
      done
  | "3" ->
      for i = 0 to 10000000 do
        let a = lazy (sqrt (float i)) in
        let f x =
          x +. Lazy.force a
        in
        for j = 0 to 10 do
          f (float j)
        done
      done
  | _ -> assert false
      (*
-drawlambda
File "code.ml", line 11, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 21, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 30, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 40, characters 10-21:
Warning 10: this expression should have type unit.
(seq
  (let (match/1054 (array.get (field 0 (global Sys!)) 1))
    (catch
      (if (caml_string_notequal match/1054 "0")
        (if (caml_string_notequal match/1054 "1")
          (if (caml_string_notequal match/1054 "2")
            (if (caml_string_notequal match/1054 "3") (exit 7)
              (for i/1043 0 to 10000000
                (let
                  (a/1044
                     (makeblock 246
                       (function param/1053
                         (caml_sqrt_float (float_of_int i/1043))))
                   f/1045
                     (function x/1046
                       (+. x/1046
                         (let
                           (lzarg/1051 a/1044
                            tag/1052 (caml_obj_tag lzarg/1051))
                           (if (== tag/1052 250) (field 0 lzarg/1051)
                             (if (== tag/1052 246)
                               (apply (field 1 (global CamlinternalLazy!))
                                 lzarg/1051)
                               lzarg/1051))))))
                  (for j/1047 0 to 10 (apply f/1045 (float_of_int j/1047))))))
            (for i/1039 0 to 10000000
              (let
                (f/1040
                   (function x/1041
                     (+. x/1041 (caml_sqrt_float (float_of_int i/1039)))))
                (for j/1042 0 to 10 (apply f/1040 (float_of_int j/1042))))))
          (for i/1034 0 to 10000000
            (let
              (a/1035
                 (makeblock 246
                   (function param/1050
                     (caml_sqrt_float (float_of_int i/1034))))
               f/1036
                 (function x/1037
                   (+. x/1037
                     (let
                       (lzarg/1048 a/1035 tag/1049 (caml_obj_tag lzarg/1048))
                       (if (== tag/1049 250) (field 0 lzarg/1048)
                         (if (== tag/1049 246)
                           (apply (field 1 (global CamlinternalLazy!))
                             lzarg/1048)
                           lzarg/1048))))))
              (for j/1038 0 to 10 (apply f/1036 (float_of_int j/1038))))))
        (for i/1030 0 to 10000000
          (let
            (f/1031
               (function x/1032
                 (+. x/1032 (caml_sqrt_float (float_of_int i/1030)))))
            (for j/1033 0 to 10 (apply f/1031 (float_of_int j/1033))))))
     with (7)
      (raise (makeblock 0 (global Assert_failure/26g) [0: "code.ml" 43 9]))))
  0a)
-dlambda
File "code.ml", line 11, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 21, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 30, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 40, characters 10-21:
Warning 10: this expression should have type unit.
(seq
  (let (match/1054 (array.get (field 0 (global Sys!)) 1))
    (if (caml_string_notequal match/1054 "0")
      (if (caml_string_notequal match/1054 "1")
        (if (caml_string_notequal match/1054 "2")
          (if (caml_string_notequal match/1054 "3")
            (raise
              (makeblock 0 (global Assert_failure/26g) [0: "code.ml" 43 9]))
            (for i/1043 0 to 10000000
              (let
                (a/1044
                   (makeblock 246
                     (function param/1053
                       (caml_sqrt_float (float_of_int i/1043))))
                 f/1045
                   (function x/1046
                     (+. x/1046
                       (let (tag/1052 (caml_obj_tag a/1044))
                         (if (== tag/1052 250) (field 0 a/1044)
                           (if (== tag/1052 246)
                             (apply (field 1 (global CamlinternalLazy!))
                               a/1044)
                             a/1044))))))
                (for j/1047 0 to 10 (apply f/1045 (float_of_int j/1047))))))
          (for i/1039 0 to 10000000
            (let
              (f/1040
                 (function x/1041
                   (+. x/1041 (caml_sqrt_float (float_of_int i/1039)))))
              (for j/1042 0 to 10 (apply f/1040 (float_of_int j/1042))))))
        (for i/1034 0 to 10000000
          (let
            (a/1035
               (makeblock 246
                 (function param/1050
                   (caml_sqrt_float (float_of_int i/1034))))
             f/1036
               (function x/1037
                 (+. x/1037
                   (let (tag/1049 (caml_obj_tag a/1035))
                     (if (== tag/1049 250) (field 0 a/1035)
                       (if (== tag/1049 246)
                         (apply (field 1 (global CamlinternalLazy!)) a/1035)
                         a/1035))))))
            (for j/1038 0 to 10 (apply f/1036 (float_of_int j/1038))))))
      (for i/1030 0 to 10000000
        (let
          (f/1031
             (function x/1032
               (+. x/1032 (caml_sqrt_float (float_of_int i/1030)))))
          (for j/1033 0 to 10 (apply f/1031 (float_of_int j/1033)))))))
  0a)

-dcmm
File "code.ml", line 11, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 21, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 30, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 40, characters 10-21:
Warning 10: this expression should have type unit.
(data int 0 global "camlCode" "camlCode": skip 0)
(data
 int 3072
 "camlCode__1":
 addr L6
 int 87
 int 19
 int 2300
 L6:
 string "code.ml"
 skip 0
 byte 0)
(data int 1276 "camlCode__2": string "3" skip 2 byte 2)
(data int 1276 "camlCode__3": string "2" skip 2 byte 2)
(data int 1276 "camlCode__4": string "1" skip 2 byte 2)
(data int 1276 "camlCode__5": string "0" skip 2 byte 2)
(function camlCode__fun_1055 (param/1053: addr env/1057: addr)
 (alloc 2301
   (extcall "sqrt" (floatofint (>>s (load (+a env/1057 8)) 1)) float)))

(function camlCode__f_1045 (x/1046: addr env/1059: addr)
 (alloc 2301
   (+f (load float64u x/1046)
     (let tag/1052 (extcall "caml_obj_tag" (load (+a env/1059 8)) addr)
       (if (== tag/1052 501) (load float64u (load (load (+a env/1059 8))))
         (if (== tag/1052 493)
           (load float64u
             (app "camlCamlinternalLazy__force_lazy_block_1032"
               (load (+a env/1059 8)) addr))
           (load float64u (load (+a env/1059 8)))))))))

(function camlCode__f_1040 (x/1041: addr env/1063: addr)
 (alloc 2301
   (+f (load float64u x/1041)
     (extcall "sqrt" (floatofint (>>s (load (+a env/1063 8)) 1)) float))))

(function camlCode__fun_1065 (param/1050: addr env/1067: addr)
 (alloc 2301
   (extcall "sqrt" (floatofint (>>s (load (+a env/1067 8)) 1)) float)))

(function camlCode__f_1036 (x/1037: addr env/1069: addr)
 (alloc 2301
   (+f (load float64u x/1037)
     (let tag/1049 (extcall "caml_obj_tag" (load (+a env/1069 8)) addr)
       (if (== tag/1049 501) (load float64u (load (load (+a env/1069 8))))
         (if (== tag/1049 493)
           (load float64u
             (app "camlCamlinternalLazy__force_lazy_block_1032"
               (load (+a env/1069 8)) addr))
           (load float64u (load (+a env/1069 8)))))))))

(function camlCode__f_1031 (x/1032: addr env/1073: addr)
 (alloc 2301
   (+f (load float64u x/1032)
     (extcall "sqrt" (floatofint (>>s (load (+a env/1073 8)) 1)) float))))

(function camlCode__entry ()
 (let
   match/1054
     (let arr/1087 (load "camlSys")
       (checkbound (>>u (load (+a arr/1087 -4)) 9) 3) (load (+a arr/1087 4)))
   (if (!= (extcall "caml_string_notequal" match/1054 "camlCode__5" addr) 1)
     (if
       (!= (extcall "caml_string_notequal" match/1054 "camlCode__4" addr) 1)
       (if
         (!= (extcall "caml_string_notequal" match/1054 "camlCode__3" addr)
           1)
         (if
           (!= (extcall "caml_string_notequal" match/1054 "camlCode__2" addr)
             1)
           (seq (raise (alloc 2048 "caml_exn_Assert_failure" "camlCode__1"))
             [])
           (let i/1043 1
             (catch
               (if (> i/1043 20000001) (exit 14)
                 (loop
                   (let
                     (a/1044
                        (alloc 1270
                          (alloc 3319 "camlCode__fun_1055" 3 i/1043))
                      f/1045 (alloc 3319 "camlCode__f_1045" 3 a/1044)
                      j/1047 1)
                     (catch
                       (if (> j/1047 21) (exit 15)
                         (loop
                           (let x/1086 (floatofint (>>s j/1047 1))
                             (alloc 2301
                               (+f x/1086
                                 (let
                                   tag/1061
                                     (extcall "caml_obj_tag"
                                       (load (+a f/1045 8)) addr)
                                   (if (== tag/1061 501)
                                     (load float64u
                                       (load (load (+a f/1045 8))))
                                     (if (== tag/1061 493)
                                       (load float64u
                                         (app
                                           "camlCamlinternalLazy__force_lazy_block_1032"
                                           (load (+a f/1045 8)) addr))
                                       (load float64u (load (+a f/1045 8))))))))
                             [])
                           (let j/1085 j/1047 (assign j/1047 (+ j/1047 2))
                             (if (== j/1085 21) (exit 15) []))))
                     with(15) []))
                   (let i/1084 i/1043 (assign i/1043 (+ i/1043 2))
                     (if (== i/1084 20000001) (exit 14) []))))
             with(14) [])))
         (let i/1039 1
           (catch
             (if (> i/1039 20000001) (exit 12)
               (loop
                 (let
                   (f/1040 (alloc 3319 "camlCode__f_1040" 3 i/1039) j/1042 1)
                   (catch
                     (if (> j/1042 21) (exit 13)
                       (loop
                         (let x/1083 (floatofint (>>s j/1042 1))
                           (alloc 2301
                             (+f x/1083
                               (extcall "sqrt"
                                 (floatofint (>>s (load (+a f/1040 8)) 1))
                                 float)))
                           [])
                         (let j/1082 j/1042 (assign j/1042 (+ j/1042 2))
                           (if (== j/1082 21) (exit 13) []))))
                   with(13) []))
                 (let i/1081 i/1039 (assign i/1039 (+ i/1039 2))
                   (if (== i/1081 20000001) (exit 12) []))))
           with(12) [])))
       (let i/1034 1
         (catch
           (if (> i/1034 20000001) (exit 10)
             (loop
               (let
                 (a/1035
                    (alloc 1270 (alloc 3319 "camlCode__fun_1065" 3 i/1034))
                  f/1036 (alloc 3319 "camlCode__f_1036" 3 a/1035) j/1038 1)
                 (catch
                   (if (> j/1038 21) (exit 11)
                     (loop
                       (let x/1080 (floatofint (>>s j/1038 1))
                         (alloc 2301
                           (+f x/1080
                             (let
                               tag/1071
                                 (extcall "caml_obj_tag" (load (+a f/1036 8))
                                   addr)
                               (if (== tag/1071 501)
                                 (load float64u (load (load (+a f/1036 8))))
                                 (if (== tag/1071 493)
                                   (load float64u
                                     (app
                                       "camlCamlinternalLazy__force_lazy_block_1032"
                                       (load (+a f/1036 8)) addr))
                                   (load float64u (load (+a f/1036 8))))))))
                         [])
                       (let j/1079 j/1038 (assign j/1038 (+ j/1038 2))
                         (if (== j/1079 21) (exit 11) []))))
                 with(11) []))
               (let i/1078 i/1034 (assign i/1034 (+ i/1034 2))
                 (if (== i/1078 20000001) (exit 10) []))))
         with(10) [])))
     (let i/1030 1
       (catch
         (if (> i/1030 20000001) (exit 8)
           (loop
             (let (f/1031 (alloc 3319 "camlCode__f_1031" 3 i/1030) j/1033 1)
               (catch
                 (if (> j/1033 21) (exit 9)
                   (loop
                     (let x/1077 (floatofint (>>s j/1033 1))
                       (alloc 2301
                         (+f x/1077
                           (extcall "sqrt"
                             (floatofint (>>s (load (+a f/1031 8)) 1)) float)))
                       [])
                     (let j/1076 j/1033 (assign j/1033 (+ j/1033 2))
                       (if (== j/1076 21) (exit 9) []))))
               with(9) []))
             (let i/1075 i/1030 (assign i/1030 (+ i/1030 2))
               (if (== i/1075 20000001) (exit 8) []))))
       with(8) []))))
 1a)

(data)
-dlinear
File "code.ml", line 11, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 21, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 30, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 40, characters 10-21:
Warning 10: this expression should have type unit.
*** Linearized code
camlCode__fun_1055:
  A/10[%eax] := [env/9[%ebx] + 8]
  I/11[%eax] := I/11[%eax] >>s 1
  R/7[%tos] := floatofint I/11[%eax]
  push R/7[%tos]
  {}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/13[s0] := R/7[%tos]
  {F/13[s0]}
  A/14[%eax] := alloc 12
  [A/14[%eax] + -4] := 2301
  float64u[A/14[%eax]] := F/13[s0]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__f_1045:
  spilled-x/23[s0] := x/8[%eax] (spill)
  push [env/9[%ebx] + 8]
  {env/9[%ebx]* spilled-x/23[s0]*}
  R/0[%eax] := extcall "caml_obj_tag" 
  offset stack -4
  if tag/10[%eax] !=s 501 goto L106
  A/11[%eax] := [env/9[%ebx] + 8]
  A/12[%eax] := [A/11[%eax]]
  R/7[%tos] := float64u[A/12[%eax]]
  F/19[s0] := R/7[%tos]
  goto L104
  L106:
  if tag/10[%eax] !=s 493 goto L105
  A/14[%eax] := [env/9[%ebx] + 8]
  {spilled-x/23[s0]*}
  R/0[%eax] := call "camlCamlinternalLazy__force_lazy_block_1032" R/0[%eax]
  R/7[%tos] := float64u[A/15[%eax]]
  F/19[s0] := R/7[%tos]
  goto L104
  L105:
  A/17[%eax] := [env/9[%ebx] + 8]
  R/7[%tos] := float64u[A/17[%eax]]
  F/19[s0] := R/7[%tos]
  L104:
  x/24[%eax] := spilled-x/23[s0] (reload)
  R/7[%tos] := F/19[s0] +f float64[x/24[%eax]]
  F/21[s0] := R/7[%tos]
  {F/21[s0]}
  A/22[%eax] := alloc 12
  [A/22[%eax] + -4] := 2301
  float64u[A/22[%eax]] := F/21[s0]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__f_1040:
  x/8[%esi] := R/0[%eax]
  A/10[%eax] := [env/9[%ebx] + 8]
  I/11[%eax] := I/11[%eax] >>s 1
  R/7[%tos] := floatofint I/11[%eax]
  push R/7[%tos]
  {x/8[%esi]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/13[s0] := R/7[%tos]
  R/7[%tos] := F/13[s0] +f float64[x/8[%esi]]
  F/15[s0] := R/7[%tos]
  {F/15[s0]}
  A/16[%eax] := alloc 12
  [A/16[%eax] + -4] := 2301
  float64u[A/16[%eax]] := F/15[s0]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_1065:
  A/10[%eax] := [env/9[%ebx] + 8]
  I/11[%eax] := I/11[%eax] >>s 1
  R/7[%tos] := floatofint I/11[%eax]
  push R/7[%tos]
  {}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/13[s0] := R/7[%tos]
  {F/13[s0]}
  A/14[%eax] := alloc 12
  [A/14[%eax] + -4] := 2301
  float64u[A/14[%eax]] := F/13[s0]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__f_1036:
  spilled-x/23[s0] := x/8[%eax] (spill)
  push [env/9[%ebx] + 8]
  {env/9[%ebx]* spilled-x/23[s0]*}
  R/0[%eax] := extcall "caml_obj_tag" 
  offset stack -4
  if tag/10[%eax] !=s 501 goto L122
  A/11[%eax] := [env/9[%ebx] + 8]
  A/12[%eax] := [A/11[%eax]]
  R/7[%tos] := float64u[A/12[%eax]]
  F/19[s0] := R/7[%tos]
  goto L120
  L122:
  if tag/10[%eax] !=s 493 goto L121
  A/14[%eax] := [env/9[%ebx] + 8]
  {spilled-x/23[s0]*}
  R/0[%eax] := call "camlCamlinternalLazy__force_lazy_block_1032" R/0[%eax]
  R/7[%tos] := float64u[A/15[%eax]]
  F/19[s0] := R/7[%tos]
  goto L120
  L121:
  A/17[%eax] := [env/9[%ebx] + 8]
  R/7[%tos] := float64u[A/17[%eax]]
  F/19[s0] := R/7[%tos]
  L120:
  x/24[%eax] := spilled-x/23[s0] (reload)
  R/7[%tos] := F/19[s0] +f float64[x/24[%eax]]
  F/21[s0] := R/7[%tos]
  {F/21[s0]}
  A/22[%eax] := alloc 12
  [A/22[%eax] + -4] := 2301
  float64u[A/22[%eax]] := F/21[s0]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__f_1031:
  x/8[%esi] := R/0[%eax]
  A/10[%eax] := [env/9[%ebx] + 8]
  I/11[%eax] := I/11[%eax] >>s 1
  R/7[%tos] := floatofint I/11[%eax]
  push R/7[%tos]
  {x/8[%esi]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/13[s0] := R/7[%tos]
  R/7[%tos] := F/13[s0] +f float64[x/8[%esi]]
  F/15[s0] := R/7[%tos]
  {F/15[s0]}
  A/16[%eax] := alloc 12
  [A/16[%eax] + -4] := 2301
  float64u[A/16[%eax]] := F/15[s0]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  arr/8[%ebx] := ["camlSys"]
  A/9[%eax] := [arr/8[%ebx] + -4]
  I/10[%eax] := I/10[%eax] >>u 9
  I/10[%eax] check > 3
  match/11[%ebx] := [arr/8[%ebx] + 4]
  push "camlCode__5"
  push match/11[%ebx]
  {match/11[%ebx]*}
  R/0[%eax] := extcall "caml_string_notequal" 
  offset stack -8
  if A/12[%eax] ==s 1 goto L136
  push "camlCode__4"
  push match/11[%ebx]
  {match/11[%ebx]*}
  R/0[%eax] := extcall "caml_string_notequal" 
  offset stack -8
  if A/13[%eax] ==s 1 goto L143
  push "camlCode__3"
  push match/11[%ebx]
  {match/11[%ebx]*}
  R/0[%eax] := extcall "caml_string_notequal" 
  offset stack -8
  if A/14[%eax] ==s 1 goto L147
  push "camlCode__2"
  push match/11[%ebx]
  {}
  R/0[%eax] := extcall "caml_string_notequal" 
  offset stack -8
  if A/15[%eax] ==s 1 goto L154
  {}
  A/16[%eax] := alloc 12
  [A/16[%eax] + -4] := 2048
  [A/16[%eax]] := "caml_exn_Assert_failure"
  [A/16[%eax] + 4] := "camlCode__1"
  raise R/0[%eax]
  L154:
  i/17[%ecx] := 1
  if i/17[%ecx] >s 20000001 goto L132
  spilled-i/105[s0] := i/17[%ecx] (spill)
  L148:
  {i/17[%ecx] spilled-i/105[s0]}
  A/18[%eax] := alloc 40
  [A/18[%eax] + -4] := 3319
  [A/18[%eax]] := "camlCode__fun_1055"
  [A/18[%eax] + 4] := 3
  [A/18[%eax] + 8] := i/17[%ecx]
  a/19[%ebx] := A/18[%eax] + 16
  [a/19[%ebx] + -4] := 1270
  [a/19[%ebx]] := A/18[%eax]
  f/20[%eax] := A/18[%eax] + 24
  spilled-f/104[s1] := f/20[%eax] (spill)
  [f/20[%eax] + -4] := 3319
  [f/20[%eax]] := "camlCode__f_1045"
  [f/20[%eax] + 4] := 3
  [f/20[%eax] + 8] := a/19[%ebx]
  j/21[%eax] := 1
  spilled-j/102[s2] := j/21[%eax] (spill)
  if j/21[%eax] >s 21 goto L149
  L150:
  I/22[%eax] := I/22[%eax] >>s 1
  R/7[%tos] := floatofint I/22[%eax]
  x/24[s0] := R/7[%tos]
  f/110[%ebx] := spilled-f/104[s1] (reload)
  push [f/110[%ebx] + 8]
  {spilled-j/102[s2] spilled-x/103[s0] spilled-f/104[s1]* spilled-i/105[s0]
   f/110[%ebx]*}
  R/0[%eax] := extcall "caml_obj_tag" 
  offset stack -4
  if tag/25[%eax] !=s 501 goto L153
  A/26[%eax] := [f/110[%ebx] + 8]
  A/27[%eax] := [A/26[%eax]]
  R/7[%tos] := float64u[A/27[%eax]]
  F/34[s1] := R/7[%tos]
  goto L151
  L153:
  if tag/25[%eax] !=s 493 goto L152
  A/29[%eax] := [f/110[%ebx] + 8]
  {spilled-j/102[s2] spilled-x/103[s0] spilled-f/104[s1]* spilled-i/105[s0]}
  R/0[%eax] := call "camlCamlinternalLazy__force_lazy_block_1032" R/0[%eax]
  R/7[%tos] := float64u[A/30[%eax]]
  F/34[s1] := R/7[%tos]
  goto L151
  L152:
  A/32[%eax] := [f/110[%ebx] + 8]
  R/7[%tos] := float64u[A/32[%eax]]
  F/34[s1] := R/7[%tos]
  L151:
  R/7[%tos] := x/111[s0] +f F/34[s1]
  F/36[s0] := R/7[%tos]
  {F/36[s0] spilled-j/102[s2] spilled-f/104[s1]* spilled-i/105[s0]}
  A/37[%eax] := alloc 12
  [A/37[%eax] + -4] := 2301
  float64u[A/37[%eax]] := F/36[s0]
  j/21[%eax] := spilled-j/102[s2] (reload)
  j/38[%ebx] := j/21[%eax]
  I/39[%eax] := I/39[%eax] + 2
  spilled-j/102[s2] := j/21[%eax] (spill)
  if j/38[%ebx] !=s 21 goto L150
  L149:
  i/17[%ecx] := spilled-i/105[s0] (reload)
  i/40[%ebx] := i/17[%ecx]
  I/41[%eax] := i/17[%ecx]
  I/41[%eax] := I/41[%eax] + 2
  i/17[%ecx] := I/41[%eax]
  spilled-i/105[s0] := i/17[%ecx] (spill)
  if i/40[%ebx] !=s 20000001 goto L148
  goto L132
  L147:
  i/42[%ebx] := 1
  if i/42[%ebx] >s 20000001 goto L132
  L144:
  {i/42[%ebx]}
  f/43[%edi] := alloc 16
  [f/43[%edi] + -4] := 3319
  [f/43[%edi]] := "camlCode__f_1040"
  [f/43[%edi] + 4] := 3
  [f/43[%edi] + 8] := i/42[%ebx]
  j/44[%esi] := 1
  if j/44[%esi] >s 21 goto L145
  L146:
  I/45[%eax] := j/44[%esi]
  I/45[%eax] := I/45[%eax] >>s 1
  R/7[%tos] := floatofint I/45[%eax]
  x/47[s1] := R/7[%tos]
  A/48[%eax] := [f/43[%edi] + 8]
  I/49[%eax] := I/49[%eax] >>s 1
  R/7[%tos] := floatofint I/49[%eax]
  push R/7[%tos]
  {i/42[%ebx] f/43[%edi]* j/44[%esi] x/47[s1]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/51[s0] := R/7[%tos]
  R/7[%tos] := x/47[s1] +f F/51[s0]
  F/53[s0] := R/7[%tos]
  {i/42[%ebx] f/43[%edi]* j/44[%esi] F/53[s0]}
  A/54[%eax] := alloc 12
  [A/54[%eax] + -4] := 2301
  float64u[A/54[%eax]] := F/53[s0]
  j/55[%ecx] := j/44[%esi]
  I/56[%eax] := j/44[%esi]
  I/56[%eax] := I/56[%eax] + 2
  j/44[%esi] := I/56[%eax]
  if j/55[%ecx] !=s 21 goto L146
  L145:
  i/57[%ecx] := i/42[%ebx]
  I/58[%eax] := i/42[%ebx]
  I/58[%eax] := I/58[%eax] + 2
  i/42[%ebx] := I/58[%eax]
  if i/57[%ecx] !=s 20000001 goto L144
  goto L132
  L143:
  i/59[%ebx] := 1
  if i/59[%ebx] >s 20000001 goto L132
  spilled-i/109[s0] := i/59[%ebx] (spill)
  L137:
  {i/59[%ebx] spilled-i/109[s0]}
  A/60[%eax] := alloc 40
  [A/60[%eax] + -4] := 3319
  [A/60[%eax]] := "camlCode__fun_1065"
  [A/60[%eax] + 4] := 3
  [A/60[%eax] + 8] := i/59[%ebx]
  a/61[%ebx] := A/60[%eax] + 16
  [a/61[%ebx] + -4] := 1270
  [a/61[%ebx]] := A/60[%eax]
  f/62[%eax] := A/60[%eax] + 24
  spilled-f/108[s1] := f/62[%eax] (spill)
  [f/62[%eax] + -4] := 3319
  [f/62[%eax]] := "camlCode__f_1036"
  [f/62[%eax] + 4] := 3
  [f/62[%eax] + 8] := a/61[%ebx]
  j/63[%eax] := 1
  spilled-j/106[s2] := j/63[%eax] (spill)
  if j/63[%eax] >s 21 goto L138
  L139:
  I/64[%eax] := I/64[%eax] >>s 1
  R/7[%tos] := floatofint I/64[%eax]
  x/66[s0] := R/7[%tos]
  f/114[%ebx] := spilled-f/108[s1] (reload)
  push [f/114[%ebx] + 8]
  {spilled-j/106[s2] spilled-x/107[s0] spilled-f/108[s1]* spilled-i/109[s0]
   f/114[%ebx]*}
  R/0[%eax] := extcall "caml_obj_tag" 
  offset stack -4
  if tag/67[%eax] !=s 501 goto L142
  A/68[%eax] := [f/114[%ebx] + 8]
  A/69[%eax] := [A/68[%eax]]
  R/7[%tos] := float64u[A/69[%eax]]
  F/76[s1] := R/7[%tos]
  goto L140
  L142:
  if tag/67[%eax] !=s 493 goto L141
  A/71[%eax] := [f/114[%ebx] + 8]
  {spilled-j/106[s2] spilled-x/107[s0] spilled-f/108[s1]* spilled-i/109[s0]}
  R/0[%eax] := call "camlCamlinternalLazy__force_lazy_block_1032" R/0[%eax]
  R/7[%tos] := float64u[A/72[%eax]]
  F/76[s1] := R/7[%tos]
  goto L140
  L141:
  A/74[%eax] := [f/114[%ebx] + 8]
  R/7[%tos] := float64u[A/74[%eax]]
  F/76[s1] := R/7[%tos]
  L140:
  R/7[%tos] := x/115[s0] +f F/76[s1]
  F/78[s0] := R/7[%tos]
  {F/78[s0] spilled-j/106[s2] spilled-f/108[s1]* spilled-i/109[s0]}
  A/79[%eax] := alloc 12
  [A/79[%eax] + -4] := 2301
  float64u[A/79[%eax]] := F/78[s0]
  j/63[%eax] := spilled-j/106[s2] (reload)
  j/80[%ebx] := j/63[%eax]
  I/81[%eax] := I/81[%eax] + 2
  spilled-j/106[s2] := j/63[%eax] (spill)
  if j/80[%ebx] !=s 21 goto L139
  L138:
  i/59[%ebx] := spilled-i/109[s0] (reload)
  i/82[%eax] := i/59[%ebx]
  I/83[%ebx] := I/83[%ebx] + 2
  spilled-i/109[s0] := i/59[%ebx] (spill)
  if i/82[%eax] !=s 20000001 goto L137
  goto L132
  L136:
  i/84[%edi] := 1
  if i/84[%edi] >s 20000001 goto L132
  L133:
  {i/84[%edi]}
  f/85[%esi] := alloc 16
  [f/85[%esi] + -4] := 3319
  [f/85[%esi]] := "camlCode__f_1031"
  [f/85[%esi] + 4] := 3
  [f/85[%esi] + 8] := i/84[%edi]
  j/86[%ebx] := 1
  if j/86[%ebx] >s 21 goto L134
  L135:
  I/87[%eax] := j/86[%ebx]
  I/87[%eax] := I/87[%eax] >>s 1
  R/7[%tos] := floatofint I/87[%eax]
  x/89[s1] := R/7[%tos]
  A/90[%eax] := [f/85[%esi] + 8]
  I/91[%eax] := I/91[%eax] >>s 1
  R/7[%tos] := floatofint I/91[%eax]
  push R/7[%tos]
  {i/84[%edi] f/85[%esi]* j/86[%ebx] x/89[s1]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/93[s0] := R/7[%tos]
  R/7[%tos] := x/89[s1] +f F/93[s0]
  F/95[s0] := R/7[%tos]
  {i/84[%edi] f/85[%esi]* j/86[%ebx] F/95[s0]}
  A/96[%eax] := alloc 12
  [A/96[%eax] + -4] := 2301
  float64u[A/96[%eax]] := F/95[s0]
  j/97[%eax] := j/86[%ebx]
  I/98[%ebx] := I/98[%ebx] + 2
  if j/97[%eax] !=s 21 goto L135
  L134:
  i/99[%eax] := i/84[%edi]
  I/100[%edi] := I/100[%edi] + 2
  if i/99[%eax] !=s 20000001 goto L133
  L132:
  A/101[%eax] := 1
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
	.long	3072
camlCode__1:
	.long	.L100006
	.long	87
	.long	19
	.long	2300
.L100006:
	.ascii	"code.ml"
	.byte	0
	.data
	.long	1276
camlCode__2:
	.ascii	"3"
	.space	2
	.byte	2
	.data
	.long	1276
camlCode__3:
	.ascii	"2"
	.space	2
	.byte	2
	.data
	.long	1276
camlCode__4:
	.ascii	"1"
	.space	2
	.byte	2
	.data
	.long	1276
camlCode__5:
	.ascii	"0"
	.space	2
	.byte	2
	.text
	.align	16
	.globl	camlCode__fun_1055
camlCode__fun_1055:
	subl	$8, %esp
.L100:
	movl	8(%ebx), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	0(%esp)
.L101:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L102
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	0(%esp)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L102:	call	caml_call_gc
.L103:	jmp	.L101
	.type	camlCode__fun_1055,@function
	.size	camlCode__fun_1055,.-camlCode__fun_1055
	.text
	.align	16
	.globl	camlCode__f_1045
camlCode__f_1045:
	subl	$12, %esp
.L107:
	movl	%eax, 0(%esp)
	pushl	8(%ebx)
	call	caml_obj_tag
	addl	$4, %esp
	cmpl	$501, %eax
	jne	.L106
	movl	8(%ebx), %eax
	movl	(%eax), %eax
	fldl	(%eax)
	fstpl	4(%esp)
	jmp	.L104
	.align	16
.L106:
	cmpl	$493, %eax
	jne	.L105
	movl	8(%ebx), %eax
	call	camlCamlinternalLazy__force_lazy_block_1032
.L108:
	fldl	(%eax)
	fstpl	4(%esp)
	jmp	.L104
	.align	16
.L105:
	movl	8(%ebx), %eax
	fldl	(%eax)
	fstpl	4(%esp)
.L104:
	movl	0(%esp), %eax
	fldl	4(%esp)
	faddl	(%eax)
	fstpl	4(%esp)
.L109:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L110
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	4(%esp)
	fstpl	(%eax)
	addl	$12, %esp
	ret
.L110:	call	caml_call_gc
.L111:	jmp	.L109
	.type	camlCode__f_1045,@function
	.size	camlCode__f_1045,.-camlCode__f_1045
	.text
	.align	16
	.globl	camlCode__f_1040
camlCode__f_1040:
	subl	$8, %esp
.L112:
	movl	%eax, %esi
	movl	8(%ebx), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%esi)
	fstpl	0(%esp)
.L113:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L114
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	0(%esp)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L114:	call	caml_call_gc
.L115:	jmp	.L113
	.type	camlCode__f_1040,@function
	.size	camlCode__f_1040,.-camlCode__f_1040
	.text
	.align	16
	.globl	camlCode__fun_1065
camlCode__fun_1065:
	subl	$8, %esp
.L116:
	movl	8(%ebx), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	0(%esp)
.L117:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L118
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	0(%esp)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L118:	call	caml_call_gc
.L119:	jmp	.L117
	.type	camlCode__fun_1065,@function
	.size	camlCode__fun_1065,.-camlCode__fun_1065
	.text
	.align	16
	.globl	camlCode__f_1036
camlCode__f_1036:
	subl	$12, %esp
.L123:
	movl	%eax, 0(%esp)
	pushl	8(%ebx)
	call	caml_obj_tag
	addl	$4, %esp
	cmpl	$501, %eax
	jne	.L122
	movl	8(%ebx), %eax
	movl	(%eax), %eax
	fldl	(%eax)
	fstpl	4(%esp)
	jmp	.L120
	.align	16
.L122:
	cmpl	$493, %eax
	jne	.L121
	movl	8(%ebx), %eax
	call	camlCamlinternalLazy__force_lazy_block_1032
.L124:
	fldl	(%eax)
	fstpl	4(%esp)
	jmp	.L120
	.align	16
.L121:
	movl	8(%ebx), %eax
	fldl	(%eax)
	fstpl	4(%esp)
.L120:
	movl	0(%esp), %eax
	fldl	4(%esp)
	faddl	(%eax)
	fstpl	4(%esp)
.L125:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L126
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	4(%esp)
	fstpl	(%eax)
	addl	$12, %esp
	ret
.L126:	call	caml_call_gc
.L127:	jmp	.L125
	.type	camlCode__f_1036,@function
	.size	camlCode__f_1036,.-camlCode__f_1036
	.text
	.align	16
	.globl	camlCode__f_1031
camlCode__f_1031:
	subl	$8, %esp
.L128:
	movl	%eax, %esi
	movl	8(%ebx), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%esi)
	fstpl	0(%esp)
.L129:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L130
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	0(%esp)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L130:	call	caml_call_gc
.L131:	jmp	.L129
	.type	camlCode__f_1031,@function
	.size	camlCode__f_1031,.-camlCode__f_1031
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$28, %esp
.L155:
	movl	camlSys, %ebx
	movl	-4(%ebx), %eax
	shrl	$9, %eax
	cmpl	$3, %eax
	jbe	.L156
	movl	4(%ebx), %ebx
	pushl	$camlCode__5
	pushl	%ebx
	call	caml_string_notequal
	addl	$8, %esp
	cmpl	$1, %eax
	je	.L136
	pushl	$camlCode__4
	pushl	%ebx
	call	caml_string_notequal
	addl	$8, %esp
	cmpl	$1, %eax
	je	.L143
	pushl	$camlCode__3
	pushl	%ebx
	call	caml_string_notequal
	addl	$8, %esp
	cmpl	$1, %eax
	je	.L147
	pushl	$camlCode__2
	pushl	%ebx
	call	caml_string_notequal
	addl	$8, %esp
	cmpl	$1, %eax
	je	.L154
	call	caml_alloc2
.L157:
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	$caml_exn_Assert_failure, (%eax)
	movl	$camlCode__1, 4(%eax)
	movl	caml_exception_pointer, %esp
	popl    caml_exception_pointer
	ret
.L154:
	movl	$1, %ecx
	cmpl	$20000001, %ecx
	jg	.L132
	movl	%ecx, 0(%esp)
.L148:
	movl	$40, %eax
	call	caml_allocN
.L158:
	leal	4(%eax), %eax
	movl	$3319, -4(%eax)
	movl	$camlCode__fun_1055, (%eax)
	movl	$3, 4(%eax)
	movl	%ecx, 8(%eax)
	leal	16(%eax), %ebx
	movl	$1270, -4(%ebx)
	movl	%eax, (%ebx)
	addl	$24, %eax
	movl	%eax, 4(%esp)
	movl	$3319, -4(%eax)
	movl	$camlCode__f_1045, (%eax)
	movl	$3, 4(%eax)
	movl	%ebx, 8(%eax)
	movl	$1, %eax
	movl	%eax, 8(%esp)
	cmpl	$21, %eax
	jg	.L149
.L150:
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	12(%esp)
	movl	4(%esp), %ebx
	pushl	8(%ebx)
	call	caml_obj_tag
	addl	$4, %esp
	cmpl	$501, %eax
	jne	.L153
	movl	8(%ebx), %eax
	movl	(%eax), %eax
	fldl	(%eax)
	fstpl	20(%esp)
	jmp	.L151
.L153:
	cmpl	$493, %eax
	jne	.L152
	movl	8(%ebx), %eax
	call	camlCamlinternalLazy__force_lazy_block_1032
.L159:
	fldl	(%eax)
	fstpl	20(%esp)
	jmp	.L151
.L152:
	movl	8(%ebx), %eax
	fldl	(%eax)
	fstpl	20(%esp)
.L151:
	fldl	12(%esp)
	faddl	20(%esp)
	fstpl	12(%esp)
	call	caml_alloc2
.L160:
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	12(%esp)
	fstpl	(%eax)
	movl	8(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 8(%esp)
	cmpl	$21, %ebx
	jne	.L150
.L149:
	movl	0(%esp), %ecx
	movl	%ecx, %ebx
	movl	%ecx, %eax
	addl	$2, %eax
	movl	%eax, %ecx
	movl	%ecx, 0(%esp)
	cmpl	$20000001, %ebx
	jne	.L148
	jmp	.L132
.L147:
	movl	$1, %ebx
	cmpl	$20000001, %ebx
	jg	.L132
.L144:
	call	caml_alloc3
.L161:
	leal	4(%eax), %edi
	movl	$3319, -4(%edi)
	movl	$camlCode__f_1040, (%edi)
	movl	$3, 4(%edi)
	movl	%ebx, 8(%edi)
	movl	$1, %esi
	cmpl	$21, %esi
	jg	.L145
.L146:
	movl	%esi, %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	20(%esp)
	movl	8(%edi), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	12(%esp)
	fldl	20(%esp)
	faddl	12(%esp)
	fstpl	12(%esp)
	call	caml_alloc2
.L162:
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	12(%esp)
	fstpl	(%eax)
	movl	%esi, %ecx
	movl	%esi, %eax
	addl	$2, %eax
	movl	%eax, %esi
	cmpl	$21, %ecx
	jne	.L146
.L145:
	movl	%ebx, %ecx
	movl	%ebx, %eax
	addl	$2, %eax
	movl	%eax, %ebx
	cmpl	$20000001, %ecx
	jne	.L144
	jmp	.L132
.L143:
	movl	$1, %ebx
	cmpl	$20000001, %ebx
	jg	.L132
	movl	%ebx, 0(%esp)
.L137:
	movl	$40, %eax
	call	caml_allocN
.L163:
	leal	4(%eax), %eax
	movl	$3319, -4(%eax)
	movl	$camlCode__fun_1065, (%eax)
	movl	$3, 4(%eax)
	movl	%ebx, 8(%eax)
	leal	16(%eax), %ebx
	movl	$1270, -4(%ebx)
	movl	%eax, (%ebx)
	addl	$24, %eax
	movl	%eax, 4(%esp)
	movl	$3319, -4(%eax)
	movl	$camlCode__f_1036, (%eax)
	movl	$3, 4(%eax)
	movl	%ebx, 8(%eax)
	movl	$1, %eax
	movl	%eax, 8(%esp)
	cmpl	$21, %eax
	jg	.L138
.L139:
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	12(%esp)
	movl	4(%esp), %ebx
	pushl	8(%ebx)
	call	caml_obj_tag
	addl	$4, %esp
	cmpl	$501, %eax
	jne	.L142
	movl	8(%ebx), %eax
	movl	(%eax), %eax
	fldl	(%eax)
	fstpl	20(%esp)
	jmp	.L140
.L142:
	cmpl	$493, %eax
	jne	.L141
	movl	8(%ebx), %eax
	call	camlCamlinternalLazy__force_lazy_block_1032
.L164:
	fldl	(%eax)
	fstpl	20(%esp)
	jmp	.L140
.L141:
	movl	8(%ebx), %eax
	fldl	(%eax)
	fstpl	20(%esp)
.L140:
	fldl	12(%esp)
	faddl	20(%esp)
	fstpl	12(%esp)
	call	caml_alloc2
.L165:
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	12(%esp)
	fstpl	(%eax)
	movl	8(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 8(%esp)
	cmpl	$21, %ebx
	jne	.L139
.L138:
	movl	0(%esp), %ebx
	movl	%ebx, %eax
	addl	$2, %ebx
	movl	%ebx, 0(%esp)
	cmpl	$20000001, %eax
	jne	.L137
	jmp	.L132
.L136:
	movl	$1, %edi
	cmpl	$20000001, %edi
	jg	.L132
.L133:
	call	caml_alloc3
.L166:
	leal	4(%eax), %esi
	movl	$3319, -4(%esi)
	movl	$camlCode__f_1031, (%esi)
	movl	$3, 4(%esi)
	movl	%edi, 8(%esi)
	movl	$1, %ebx
	cmpl	$21, %ebx
	jg	.L134
.L135:
	movl	%ebx, %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	20(%esp)
	movl	8(%esi), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	12(%esp)
	fldl	20(%esp)
	faddl	12(%esp)
	fstpl	12(%esp)
	call	caml_alloc2
.L167:
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	12(%esp)
	fstpl	(%eax)
	movl	%ebx, %eax
	addl	$2, %ebx
	cmpl	$21, %eax
	jne	.L135
.L134:
	movl	%edi, %eax
	addl	$2, %edi
	cmpl	$20000001, %eax
	jne	.L133
.L132:
	movl	$1, %eax
	addl	$28, %esp
	ret
.L156:	call	caml_ml_array_bound_error
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
	.long	19
	.long	.L167
	.word	32
	.word	1
	.word	9
	.align	4
	.long	.L166
	.word	32
	.word	0
	.align	4
	.long	.L165
	.word	32
	.word	1
	.word	4
	.align	4
	.long	.L164
	.word	32
	.word	1
	.word	4
	.align	4
	.long	.L163
	.word	32
	.word	0
	.align	4
	.long	.L162
	.word	32
	.word	1
	.word	11
	.align	4
	.long	.L161
	.word	32
	.word	0
	.align	4
	.long	.L160
	.word	32
	.word	1
	.word	4
	.align	4
	.long	.L159
	.word	32
	.word	1
	.word	4
	.align	4
	.long	.L158
	.word	32
	.word	0
	.align	4
	.long	.L157
	.word	32
	.word	0
	.align	4
	.long	.L131
	.word	12
	.word	0
	.align	4
	.long	.L127
	.word	16
	.word	0
	.align	4
	.long	.L124
	.word	16
	.word	1
	.word	0
	.align	4
	.long	.L119
	.word	12
	.word	0
	.align	4
	.long	.L115
	.word	12
	.word	0
	.align	4
	.long	.L111
	.word	16
	.word	0
	.align	4
	.long	.L108
	.word	16
	.word	1
	.word	0
	.align	4
	.long	.L103
	.word	12
	.word	0
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

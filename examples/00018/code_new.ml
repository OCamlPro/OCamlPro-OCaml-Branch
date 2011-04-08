(*
Inlining:
 - In main1, protect1 is not inlined, because it contains a reference
to a constant string, and the compiler prevents inlining when
there are potential duplication of structured constants.
- In main2, protect2 is inlined, but not the argument function. First order
arguments are never inlined, and some optimisations are clearly missed.

*)

let protect1 s f =
  try f () with e ->
    Printf.eprintf "Uncaught exception in %s: %s\n%!" s (Printexc.to_string e);
    exit 2

let main1 x =
  protect1 "main1" (fun () -> x + 1)

let msg = Obj.magic "Uncaught exception in %s: %s\n%!"
let protect2 s f =
      try f () with e ->
	Printf.eprintf msg s (Printexc.to_string e);
	exit 2

let main2 x =
  protect2 "main2" (fun () -> x + 1)

let make_main protect x =
  protect "make_main" (fun () -> x + 1)

let main3 = make_main protect2

(*
-drawlambda
File "code.ml", line 22, characters 1-44:
Warning 21: this statement never returns (or has an unsound type.)
(seq
  (let
    (protect1/1030
       (function s/1031 f/1032
         (try (apply f/1032 0a) with e/1033
           (seq
             (apply (field 2 (global Printf!))
               "Uncaught exception in %s: %s\n%!" s/1031
               (apply (field 0 (global Printexc!)) e/1033))
             (apply (field 76 (global Pervasives!)) 2)))))
    (setfield_imm 0 (global Code!) protect1/1030))
  (let
    (main1/1034
       (function x/1035
         (apply (field 0 (global Code!)) "main1"
           (function param/1054 (+ x/1035 1)))))
    (setfield_imm 1 (global Code!) main1/1034))
  (let (msg/1036 (id "Uncaught exception in %s: %s\n%!"))
    (setfield_imm 2 (global Code!) msg/1036))
  (let
    (protect2/1037
       (function s/1038 f/1039
         (try (apply f/1039 0a) with e/1040
           (seq
             (apply (field 2 (global Printf!)) (field 2 (global Code!))
               s/1038 (apply (field 0 (global Printexc!)) e/1040))
             (apply (field 76 (global Pervasives!)) 2)))))
    (setfield_imm 3 (global Code!) protect2/1037))
  (let
    (main2/1041
       (function x/1042
         (apply (field 3 (global Code!)) "main2"
           (function param/1055 (+ x/1042 1)))))
    (setfield_imm 4 (global Code!) main2/1041))
  (let
    (make_main/1043
       (function protect/1044 x/1045
         (apply protect/1044 "make_main" (function param/1056 (+ x/1045 1)))))
    (setfield_imm 5 (global Code!) make_main/1043))
  (let (main3/1046 (apply (field 5 (global Code!)) (field 3 (global Code!))))
    (setfield_imm 6 (global Code!) main3/1046))
  0a)
-dlambda
File "code.ml", line 22, characters 1-44:
Warning 21: this statement never returns (or has an unsound type.)
(seq
  (let
    (protect1/1030
       (function s/1031 f/1032
         (try (apply f/1032 0a) with e/1033
           (seq
             (apply (field 2 (global Printf!))
               "Uncaught exception in %s: %s\n%!" s/1031
               (apply (field 0 (global Printexc!)) e/1033))
             (apply (field 76 (global Pervasives!)) 2)))))
    (setfield_imm 0 (global Code!) protect1/1030))
  (let
    (main1/1034
       (function x/1035
         (apply (field 0 (global Code!)) "main1"
           (function param/1054 (+ x/1035 1)))))
    (setfield_imm 1 (global Code!) main1/1034))
  (let (msg/1036 (id "Uncaught exception in %s: %s\n%!"))
    (setfield_imm 2 (global Code!) msg/1036))
  (let
    (protect2/1037
       (function s/1038 f/1039
         (try (apply f/1039 0a) with e/1040
           (seq
             (apply (field 2 (global Printf!)) (field 2 (global Code!))
               s/1038 (apply (field 0 (global Printexc!)) e/1040))
             (apply (field 76 (global Pervasives!)) 2)))))
    (setfield_imm 3 (global Code!) protect2/1037))
  (let
    (main2/1041
       (function x/1042
         (apply (field 3 (global Code!)) "main2"
           (function param/1055 (+ x/1042 1)))))
    (setfield_imm 4 (global Code!) main2/1041))
  (let
    (make_main/1043
       (function protect/1044 x/1045
         (apply protect/1044 "make_main" (function param/1056 (+ x/1045 1)))))
    (setfield_imm 5 (global Code!) make_main/1043))
  (let (main3/1046 (apply (field 5 (global Code!)) (field 3 (global Code!))))
    (setfield_imm 6 (global Code!) main3/1046))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (protect1/1030
       (function s/1031 f/1032
         (try (apply f/1032 0a) with e/1033
           (seq
             (apply (field 2 (global Printf!))
               "Uncaught exception in %s: %s\n%!" s/1031
               (apply (field 0 (global Printexc!)) e/1033))
             (apply (field 76 (global Pervasives!)) 2)))))
    (setfield_imm 0 (global Code!) protect1/1030))
  (let
    (main1/1034
       (function x/1035
         (apply (field 0 (global Code!)) "main1"
           (function param/1054 (+ x/1035 1)))))
    (setfield_imm 1 (global Code!) main1/1034))
  (let (msg/1036 (id "Uncaught exception in %s: %s\n%!"))
    (setfield_imm 2 (global Code!) msg/1036))
  (let
    (protect2/1037
       (function s/1038 f/1039
         (try (apply f/1039 0a) with e/1040
           (seq
             (apply (field 2 (global Printf!)) (field 2 (global Code!))
               s/1038 (apply (field 0 (global Printexc!)) e/1040))
             (apply (field 76 (global Pervasives!)) 2)))))
    (setfield_imm 3 (global Code!) protect2/1037))
  (let
    (main2/1041
       (function x/1042
         (apply (field 3 (global Code!)) "main2"
           (function param/1055 (+ x/1042 1)))))
    (setfield_imm 4 (global Code!) main2/1041))
  (let
    (make_main/1043
       (function protect/1044 x/1045
         (apply protect/1044 "make_main" (function param/1056 (+ x/1045 1)))))
    (setfield_imm 5 (global Code!) make_main/1043))
  (let (main3/1046 (apply (field 5 (global Code!)) (field 3 (global Code!))))
    (setfield_imm 6 (global Code!) main3/1046))
  0a)
-dclosure
File "code.ml", line 22, characters 1-44:
Warning 21: this statement never returns (or has an unsound type.)
*** After Closure.intro:
(seq
  (let
    (protect1/1030
       (closure (camlCode__protect1_1030(2)  s/1031 f/1032
                  (try (apply f/1032 0a) with e/1033
                    (seq
                      (apply
                        (apply
                          (camlPrintf__fprintf_1391 
                            (field 24 (global camlPervasives!)))
                          "Uncaught exception in %s: %s\n%!")
                        s/1031 (camlPrintexc__to_string_1061  e/1033))
                      (apply (field 0 (field 82 (global camlPervasives!)))
                        0a)
                      (caml_sys_exit 2)))) {3} ))
    (setfield_imm 0 (global camlCode!) protect1/1030))
  (let
    (main1/1034
       (closure (camlCode__main1_1034(1)  x/1035
                  (let
                    (f/1062
                       (closure (camlCode__fun_1059(1)  param/1054 env/1061
                                  (+ (field 2 env/1061) 1)) {2} 
                                                            x/1035))
                    (try (apply f/1062 0a) with e/1063
                      (seq
                        (apply
                          (apply
                            (camlPrintf__fprintf_1391 
                              (field 24 (global camlPervasives!)))
                            "Uncaught exception in %s: %s\n%!")
                          "main1" (camlPrintexc__to_string_1061  e/1063))
                        (apply (field 0 (field 82 (global camlPervasives!)))
                          0a)
                        (caml_sys_exit 2))))) {2} ))
    (setfield_imm 1 (global camlCode!) main1/1034))
  (let (msg/1036 (id "Uncaught exception in %s: %s\n%!"))
    (setfield_imm 2 (global camlCode!) msg/1036))
  (let
    (protect2/1037
       (closure (camlCode__protect2_1037(2)  s/1038 f/1039
                  (try (apply f/1039 0a) with e/1040
                    (seq
                      (apply
                        (let (fmt/1065 (field 2 (global camlCode!)))
                          (apply
                            (camlPrintf__fprintf_1391 
                              (field 24 (global camlPervasives!)))
                            fmt/1065))
                        s/1038 (camlPrintexc__to_string_1061  e/1040))
                      (apply (field 0 (field 82 (global camlPervasives!)))
                        0a)
                      (caml_sys_exit 2)))) {3} ))
    (setfield_imm 3 (global camlCode!) protect2/1037))
  (let
    (main2/1041
       (closure (camlCode__main2_1041(1)  x/1042
                  (let
                    (f/1070
                       (closure (camlCode__fun_1067(1)  param/1055 env/1069
                                  (+ (field 2 env/1069) 1)) {2} 
                                                            x/1042))
                    (try (apply f/1070 0a) with e/1071
                      (seq
                        (apply
                          (let (fmt/1072 (field 2 (global camlCode!)))
                            (apply
                              (camlPrintf__fprintf_1391 
                                (field 24 (global camlPervasives!)))
                              fmt/1072))
                          "main2" (camlPrintexc__to_string_1061  e/1071))
                        (apply (field 0 (field 82 (global camlPervasives!)))
                          0a)
                        (caml_sys_exit 2))))) {2} ))
    (setfield_imm 4 (global camlCode!) main2/1041))
  (let
    (make_main/1043
       (closure (camlCode__make_main_1043(2)  protect/1044 x/1045
                  (apply protect/1044 "make_main"
                    (closure (camlCode__fun_1074(1)  param/1056 env/1076
                               (+ (field 2 env/1076) 1)) {2} 
                                                         x/1045))) {3} ))
    (setfield_imm 5 (global camlCode!) make_main/1043))
  (let
    (main3/1046
       (apply (field 5 (global camlCode!)) (field 3 (global camlCode!))))
    (setfield_imm 6 (global camlCode!) main3/1046))
  0a)
*** After TonClosure.optimize:
(let
  (protect1/1030
     (closure (camlCode__protect1_1030(2)  s/1031 f/1032
                (try (apply f/1032 0a) with e/1033
                  (seq
                    (apply
                      (apply
                        (camlPrintf__fprintf_1391 
                          (field 24 (global camlPervasives!)))
                        "Uncaught exception in %s: %s\n%!")
                      s/1031 (camlPrintexc__to_string_1061  e/1033))
                    (apply (field 0 (field 82 (global camlPervasives!))) 0a)
                    (caml_sys_exit 2)))) {3} ))
  (seq (setfield_imm 0 (global camlCode!) protect1/1030)
    (let
      (main1/1034
         (closure (camlCode__main1_1034(1)  x/1035
                    (let
                      (f/1062
                         (closure (camlCode__fun_1059(1)  param/1054 env/1061
                                    (+ (field 2 env/1061) 1)) {2} 
                                                              x/1035))
                      (try (+ (field 2 f/1062) 1) with e/1063
                        (seq
                          (apply
                            (apply
                              (camlPrintf__fprintf_1391 
                                (field 24 (global camlPervasives!)))
                              "Uncaught exception in %s: %s\n%!")
                            "main1" (camlPrintexc__to_string_1061  e/1063))
                          (apply
                            (field 0 (field 82 (global camlPervasives!))) 0a)
                          (caml_sys_exit 2))))) {2} ))
      (seq (setfield_imm 1 (global camlCode!) main1/1034)
        (let (msg/1036 (id "Uncaught exception in %s: %s\n%!"))
          (seq (setfield_imm 2 (global camlCode!) msg/1036)
            (let
              (protect2/1037
                 (closure (camlCode__protect2_1037(2)  s/1038 f/1039
                            (try (apply f/1039 0a) with e/1040
                              (seq
                                (apply
                                  (let
                                    (fmt/1065 (field 2 (global camlCode!)))
                                    (apply
                                      (camlPrintf__fprintf_1391 
                                        (field 24 (global camlPervasives!)))
                                      fmt/1065))
                                  s/1038
                                  (camlPrintexc__to_string_1061  e/1040))
                                (apply
                                  (field 0
                                    (field 82 (global camlPervasives!)))
                                  0a)
                                (caml_sys_exit 2)))) {3} ))
              (seq (setfield_imm 3 (global camlCode!) protect2/1037)
                (let
                  (main2/1041
                     (closure (camlCode__main2_1041(1)  x/1042
                                (let
                                  (f/1070
                                     (closure (camlCode__fun_1067(1) 
                                                param/1055 env/1069
                                                (+ (field 2 env/1069) 1)) 
                                       {2} 
                                       x/1042))
                                  (try (+ (field 2 f/1070) 1) with e/1071
                                    (seq
                                      (apply
                                        (let
                                          (fmt/1072
                                             (field 2 (global camlCode!)))
                                          (apply
                                            (camlPrintf__fprintf_1391 
                                              (field 24
                                                (global camlPervasives!)))
                                            fmt/1072))
                                        "main2"
                                        (camlPrintexc__to_string_1061 
                                          e/1071))
                                      (apply
                                        (field 0
                                          (field 82 (global camlPervasives!)))
                                        0a)
                                      (caml_sys_exit 2))))) {2} ))
                  (seq (setfield_imm 4 (global camlCode!) main2/1041)
                    (let
                      (make_main/1043
                         (closure (camlCode__make_main_1043(2)  protect/1044
                                    x/1045
                                    (apply protect/1044 "make_main"
                                      (closure (camlCode__fun_1074(1) 
                                                 param/1056 env/1076
                                                 (+ (field 2 env/1076) 1)) 
                                        {2} 
                                        x/1045))) {3} ))
                      (seq (setfield_imm 5 (global camlCode!) make_main/1043)
                        (let
                          (main3/1046
                             (apply (field 5 (global camlCode!))
                               (field 3 (global camlCode!))))
                          (seq (setfield_imm 6 (global camlCode!) main3/1046)
                            0a))))))))))))))

-dcmm
File "code.ml", line 22, characters 1-44:
Warning 21: this statement never returns (or has an unsound type.)
(data int 7168 global "camlCode" "camlCode": skip 28)
(data
 int 3319
 "camlCode__6":
 addr "caml_curry2"
 int 5
 addr "camlCode__make_main_1043")
(data int 2295 "camlCode__7": addr "camlCode__main2_1041" int 3)
(data
 int 3319
 "camlCode__8":
 addr "caml_curry2"
 int 5
 addr "camlCode__protect2_1037")
(data int 2295 "camlCode__9": addr "camlCode__main1_1034" int 3)
(data
 int 3319
 "camlCode__10":
 addr "caml_curry2"
 int 5
 addr "camlCode__protect1_1030")
(data
 global "camlCode__1"
 int 8444
 "camlCode__1":
 string "Uncaught exception in %s: %s
%!"
 skip 0
 byte 0)
(data
 global "camlCode__2"
 int 2300
 "camlCode__2":
 string "main1"
 skip 2
 byte 2)
(data
 global "camlCode__3"
 int 8444
 "camlCode__3":
 string "Uncaught exception in %s: %s
%!"
 skip 0
 byte 0)
(data
 global "camlCode__4"
 int 2300
 "camlCode__4":
 string "main2"
 skip 2
 byte 2)
(data
 global "camlCode__5"
 int 3324
 "camlCode__5":
 string "make_main"
 skip 2
 byte 2)
(function camlCode__fun_1059 (param/1054: addr env/1061: addr)
 (+ (load (+a env/1061 8)) 2))

(function camlCode__fun_1067 (param/1055: addr env/1069: addr)
 (+ (load (+a env/1069 8)) 2))

(function camlCode__fun_1074 (param/1056: addr env/1076: addr)
 (+ (load (+a env/1076 8)) 2))

(function camlCode__protect1_1030 (s/1031: addr f/1032: addr)
 (try (app (load f/1032) 1a f/1032 addr) with e/1033
   (app "caml_apply2" s/1031 (app "camlPrintexc__to_string_1061" e/1033 addr)
     (let
       fun/1085
         (app{printf.ml:642,18-36} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 96)) addr)
       (app{printf.ml:642,18-36} (load fun/1085) "camlCode__1" fun/1085 addr))
     unit)
   (let fun/1084 (load (load (+a "camlPervasives" 328)))
     (app{pervasives.ml:446,2-15} (load fun/1084) 1a fun/1084 unit))
   (extcall "caml_sys_exit"{pervasives.ml:447,2-18} 5 addr)))

(function camlCode__main1_1034 (x/1035: addr)
 (let f/1062 (alloc 3319 "camlCode__fun_1059" 3 x/1035)
   (try (+ (load (+a f/1062 8)) 2) with e/1063
     (app "caml_apply2" "camlCode__2"
       (app "camlPrintexc__to_string_1061" e/1063 addr)
       (let
         fun/1083
           (app{printf.ml:642,18-36} "camlPrintf__fprintf_1391"
             (load (+a "camlPervasives" 96)) addr)
         (app{printf.ml:642,18-36} (load fun/1083) "camlCode__1" fun/1083
           addr))
       unit)
     (let fun/1082 (load (load (+a "camlPervasives" 328)))
       (app{pervasives.ml:446,2-15} (load fun/1082) 1a fun/1082 unit))
     (extcall "caml_sys_exit"{pervasives.ml:447,2-18} 5 addr))))

(function camlCode__protect2_1037 (s/1038: addr f/1039: addr)
 (try (app (load f/1039) 1a f/1039 addr) with e/1040
   (app "caml_apply2" s/1038 (app "camlPrintexc__to_string_1061" e/1040 addr)
     (let
       (fmt/1065 (load (+a "camlCode" 8))
        fun/1081
          (app{printf.ml:642,18-36} "camlPrintf__fprintf_1391"
            (load (+a "camlPervasives" 96)) addr))
       (app{printf.ml:642,18-36} (load fun/1081) fmt/1065 fun/1081 addr))
     unit)
   (let fun/1080 (load (load (+a "camlPervasives" 328)))
     (app{pervasives.ml:446,2-15} (load fun/1080) 1a fun/1080 unit))
   (extcall "caml_sys_exit"{pervasives.ml:447,2-18} 5 addr)))

(function camlCode__main2_1041 (x/1042: addr)
 (let f/1070 (alloc 3319 "camlCode__fun_1067" 3 x/1042)
   (try (+ (load (+a f/1070 8)) 2) with e/1071
     (app "caml_apply2" "camlCode__4"
       (app "camlPrintexc__to_string_1061" e/1071 addr)
       (let
         (fmt/1072 (load (+a "camlCode" 8))
          fun/1079
            (app{printf.ml:642,18-36} "camlPrintf__fprintf_1391"
              (load (+a "camlPervasives" 96)) addr))
         (app{printf.ml:642,18-36} (load fun/1079) fmt/1072 fun/1079 addr))
       unit)
     (let fun/1078 (load (load (+a "camlPervasives" 328)))
       (app{pervasives.ml:446,2-15} (load fun/1078) 1a fun/1078 unit))
     (extcall "caml_sys_exit"{pervasives.ml:447,2-18} 5 addr))))

(function camlCode__make_main_1043 (protect/1044: addr x/1045: addr)
 (app "caml_apply2" "camlCode__5" (alloc 3319 "camlCode__fun_1074" 3 x/1045)
   protect/1044 addr))

(function camlCode__entry ()
 (let protect1/1030 "camlCode__10" (store "camlCode" protect1/1030)
   (let main1/1034 "camlCode__9" (store (+a "camlCode" 4) main1/1034)
     (let msg/1036 "camlCode__3" (store (+a "camlCode" 8) msg/1036)
       (let protect2/1037 "camlCode__8"
         (store (+a "camlCode" 12) protect2/1037)
         (let main2/1041 "camlCode__7" (store (+a "camlCode" 16) main2/1041)
           (let make_main/1043 "camlCode__6"
             (store (+a "camlCode" 20) make_main/1043)
             (let
               main3/1046
                 (let fun/1077 (load (+a "camlCode" 20))
                   (app (load fun/1077) (load (+a "camlCode" 12)) fun/1077
                     addr))
               (store (+a "camlCode" 24) main3/1046) 1a))))))))

(data)
-dlinear
File "code.ml", line 22, characters 1-44:
Warning 21: this statement never returns (or has an unsound type.)
Before simplify
camlCode__fun_1059:
                  A/10[%eax] := [env/9[%ebx] + 8]
                  I/11[%eax] := I/11[%eax] + 2
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_1059:
  A/10[%eax] := [env/9[%ebx] + 8]
  I/11[%eax] := I/11[%eax] + 2
  return R/0[%eax]
  
Before simplify
camlCode__fun_1067:
                  A/10[%eax] := [env/9[%ebx] + 8]
                  I/11[%eax] := I/11[%eax] + 2
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_1067:
  A/10[%eax] := [env/9[%ebx] + 8]
  I/11[%eax] := I/11[%eax] + 2
  return R/0[%eax]
  
Before simplify
camlCode__fun_1074:
                  A/10[%eax] := [env/9[%ebx] + 8]
                  I/11[%eax] := I/11[%eax] + 2
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_1074:
  A/10[%eax] := [env/9[%ebx] + 8]
  I/11[%eax] := I/11[%eax] + 2
  return R/0[%eax]
  
Before simplify
camlCode__protect1_1030:
                  spilled-s/26[s1] := s/8[%eax] (spill)
                  setup trap L104
                  A/27[s0] := A/13[%eax] (spill)
                  A/14[%eax] := ["camlPervasives" + 96]
                  {spilled-s/26[s1]* A/27[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:642,18-36}
                  fun/15[%ebx] := R/0[%eax]
                  A/16[%eax] := "camlCode__1"
                  A/17[%ecx] := [fun/15[%ebx]]
                  {spilled-s/26[s1]* A/27[s0]*}
                  R/0[%eax] := call A/17[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:642,18-36}
                  A/25[s2] := A/18[%eax] (spill)
                  A/28[%eax] := A/27[s0] (reload)
                  {A/25[s2]* spilled-s/26[s1]*}
                  R/0[%eax] := call "camlPrintexc__to_string_1061" R/0[%eax]
                  A/19[%ebx] := R/0[%eax]
                  s/29[%eax] := spilled-s/26[s1] (reload)
                  A/30[%ecx] := A/25[s2] (reload)
                  {}
                  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  A/20[%eax] := ["camlPervasives" + 328]
                  fun/21[%ebx] := [A/20[%eax]]
                  A/22[%eax] := 1
                  A/23[%ecx] := [fun/21[%ebx]]
                  {}
                  call A/23[%ecx] R/0[%eax] R/1[%ebx] {pervasives.ml:446,2-15}
                  push 5
                  {}
                  R/0[%eax] := extcall "caml_sys_exit"  (noalloc) {pervasives.ml:447,2-18}
                  offset stack -4
                  reload retaddr
                  return R/0[%eax]
                  L104 [0]:
                  push trap
                  A/10[%eax] := 1
                  A/11[%ecx] := [f/9[%ebx]]
                  {spilled-s/26[s1]*}
                  R/0[%eax] := call A/11[%ecx] R/0[%eax] R/1[%ebx]
                  pop trap
                  L103 [0]:
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__protect1_1030:
  spilled-s/26[s1] := s/8[%eax] (spill)
  setup trap L104
  A/27[s0] := A/13[%eax] (spill)
  A/14[%eax] := ["camlPervasives" + 96]
  {spilled-s/26[s1]* A/27[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:642,18-36}
  fun/15[%ebx] := R/0[%eax]
  A/16[%eax] := "camlCode__1"
  A/17[%ecx] := [fun/15[%ebx]]
  {spilled-s/26[s1]* A/27[s0]*}
  R/0[%eax] := call A/17[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:642,18-36}
  A/25[s2] := A/18[%eax] (spill)
  A/28[%eax] := A/27[s0] (reload)
  {A/25[s2]* spilled-s/26[s1]*}
  R/0[%eax] := call "camlPrintexc__to_string_1061" R/0[%eax]
  A/19[%ebx] := R/0[%eax]
  s/29[%eax] := spilled-s/26[s1] (reload)
  A/30[%ecx] := A/25[s2] (reload)
  {}
  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/20[%eax] := ["camlPervasives" + 328]
  fun/21[%ebx] := [A/20[%eax]]
  A/22[%eax] := 1
  A/23[%ecx] := [fun/21[%ebx]]
  {}
  call A/23[%ecx] R/0[%eax] R/1[%ebx] {pervasives.ml:446,2-15}
  push 5
  {}
  R/0[%eax] := extcall "caml_sys_exit"  (noalloc) {pervasives.ml:447,2-18}
  offset stack -4
  reload retaddr
  return R/0[%eax]
  L104 [2]:
  push trap
  A/10[%eax] := 1
  A/11[%ecx] := [f/9[%ebx]]
  {spilled-s/26[s1]*}
  R/0[%eax] := call A/11[%ecx] R/0[%eax] R/1[%ebx]
  pop trap
  L103 [2]:
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__main1_1034:
                  x/8[%ebx] := R/0[%eax]
                  {x/8[%ebx]*}
                  f/9[%eax] := alloc 16
                  [f/9[%eax] + -4] := 3319
                  [f/9[%eax]] := "camlCode__fun_1059"
                  [f/9[%eax] + 4] := 3
                  [f/9[%eax] + 8] := x/8[%ebx]
                  setup trap L114
                  A/26[s0] := A/12[%eax] (spill)
                  A/13[%eax] := ["camlPervasives" + 96]
                  {A/26[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:642,18-36}
                  fun/14[%ebx] := R/0[%eax]
                  A/15[%eax] := "camlCode__1"
                  A/16[%ecx] := [fun/14[%ebx]]
                  {A/26[s0]*}
                  R/0[%eax] := call A/16[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:642,18-36}
                  A/25[s1] := A/17[%eax] (spill)
                  A/27[%eax] := A/26[s0] (reload)
                  {A/25[s1]*}
                  R/0[%eax] := call "camlPrintexc__to_string_1061" R/0[%eax]
                  A/18[%ebx] := R/0[%eax]
                  A/19[%eax] := "camlCode__2"
                  A/28[%ecx] := A/25[s1] (reload)
                  {}
                  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  A/20[%eax] := ["camlPervasives" + 328]
                  fun/21[%ebx] := [A/20[%eax]]
                  A/22[%eax] := 1
                  A/23[%ecx] := [fun/21[%ebx]]
                  {}
                  call A/23[%ecx] R/0[%eax] R/1[%ebx] {pervasives.ml:446,2-15}
                  push 5
                  {}
                  R/0[%eax] := extcall "caml_sys_exit"  (noalloc) {pervasives.ml:447,2-18}
                  offset stack -4
                  reload retaddr
                  return R/0[%eax]
                  L114 [0]:
                  push trap
                  A/10[%eax] := [f/9[%eax] + 8]
                  I/11[%eax] := I/11[%eax] + 2
                  pop trap
                  L113 [0]:
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__main1_1034:
  x/8[%ebx] := R/0[%eax]
  {x/8[%ebx]*}
  f/9[%eax] := alloc 16
  [f/9[%eax] + -4] := 3319
  [f/9[%eax]] := "camlCode__fun_1059"
  [f/9[%eax] + 4] := 3
  [f/9[%eax] + 8] := x/8[%ebx]
  setup trap L114
  A/26[s0] := A/12[%eax] (spill)
  A/13[%eax] := ["camlPervasives" + 96]
  {A/26[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:642,18-36}
  fun/14[%ebx] := R/0[%eax]
  A/15[%eax] := "camlCode__1"
  A/16[%ecx] := [fun/14[%ebx]]
  {A/26[s0]*}
  R/0[%eax] := call A/16[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:642,18-36}
  A/25[s1] := A/17[%eax] (spill)
  A/27[%eax] := A/26[s0] (reload)
  {A/25[s1]*}
  R/0[%eax] := call "camlPrintexc__to_string_1061" R/0[%eax]
  A/18[%ebx] := R/0[%eax]
  A/19[%eax] := "camlCode__2"
  A/28[%ecx] := A/25[s1] (reload)
  {}
  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/20[%eax] := ["camlPervasives" + 328]
  fun/21[%ebx] := [A/20[%eax]]
  A/22[%eax] := 1
  A/23[%ecx] := [fun/21[%ebx]]
  {}
  call A/23[%ecx] R/0[%eax] R/1[%ebx] {pervasives.ml:446,2-15}
  push 5
  {}
  R/0[%eax] := extcall "caml_sys_exit"  (noalloc) {pervasives.ml:447,2-18}
  offset stack -4
  reload retaddr
  return R/0[%eax]
  L114 [2]:
  push trap
  A/10[%eax] := [f/9[%eax] + 8]
  I/11[%eax] := I/11[%eax] + 2
  pop trap
  L113 [2]:
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__protect2_1037:
                  spilled-s/26[s2] := s/8[%eax] (spill)
                  setup trap L126
                  A/27[s1] := A/13[%eax] (spill)
                  fmt/14[%eax] := ["camlCode" + 8]
                  spilled-fmt/28[s0] := fmt/14[%eax] (spill)
                  A/15[%eax] := ["camlPervasives" + 96]
                  {spilled-s/26[s2]* A/27[s1]* spilled-fmt/28[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:642,18-36}
                  fun/16[%ebx] := R/0[%eax]
                  A/17[%ecx] := [fun/16[%ebx]]
                  fmt/29[%eax] := spilled-fmt/28[s0] (reload)
                  {spilled-s/26[s2]* A/27[s1]*}
                  R/0[%eax] := call A/17[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:642,18-36}
                  A/25[s0] := A/18[%eax] (spill)
                  A/30[%eax] := A/27[s1] (reload)
                  {A/25[s0]* spilled-s/26[s2]*}
                  R/0[%eax] := call "camlPrintexc__to_string_1061" R/0[%eax]
                  A/19[%ebx] := R/0[%eax]
                  s/31[%eax] := spilled-s/26[s2] (reload)
                  A/32[%ecx] := A/25[s0] (reload)
                  {}
                  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  A/20[%eax] := ["camlPervasives" + 328]
                  fun/21[%ebx] := [A/20[%eax]]
                  A/22[%eax] := 1
                  A/23[%ecx] := [fun/21[%ebx]]
                  {}
                  call A/23[%ecx] R/0[%eax] R/1[%ebx] {pervasives.ml:446,2-15}
                  push 5
                  {}
                  R/0[%eax] := extcall "caml_sys_exit"  (noalloc) {pervasives.ml:447,2-18}
                  offset stack -4
                  reload retaddr
                  return R/0[%eax]
                  L126 [0]:
                  push trap
                  A/10[%eax] := 1
                  A/11[%ecx] := [f/9[%ebx]]
                  {spilled-s/26[s2]*}
                  R/0[%eax] := call A/11[%ecx] R/0[%eax] R/1[%ebx]
                  pop trap
                  L125 [0]:
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__protect2_1037:
  spilled-s/26[s2] := s/8[%eax] (spill)
  setup trap L126
  A/27[s1] := A/13[%eax] (spill)
  fmt/14[%eax] := ["camlCode" + 8]
  spilled-fmt/28[s0] := fmt/14[%eax] (spill)
  A/15[%eax] := ["camlPervasives" + 96]
  {spilled-s/26[s2]* A/27[s1]* spilled-fmt/28[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:642,18-36}
  fun/16[%ebx] := R/0[%eax]
  A/17[%ecx] := [fun/16[%ebx]]
  fmt/29[%eax] := spilled-fmt/28[s0] (reload)
  {spilled-s/26[s2]* A/27[s1]*}
  R/0[%eax] := call A/17[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:642,18-36}
  A/25[s0] := A/18[%eax] (spill)
  A/30[%eax] := A/27[s1] (reload)
  {A/25[s0]* spilled-s/26[s2]*}
  R/0[%eax] := call "camlPrintexc__to_string_1061" R/0[%eax]
  A/19[%ebx] := R/0[%eax]
  s/31[%eax] := spilled-s/26[s2] (reload)
  A/32[%ecx] := A/25[s0] (reload)
  {}
  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/20[%eax] := ["camlPervasives" + 328]
  fun/21[%ebx] := [A/20[%eax]]
  A/22[%eax] := 1
  A/23[%ecx] := [fun/21[%ebx]]
  {}
  call A/23[%ecx] R/0[%eax] R/1[%ebx] {pervasives.ml:446,2-15}
  push 5
  {}
  R/0[%eax] := extcall "caml_sys_exit"  (noalloc) {pervasives.ml:447,2-18}
  offset stack -4
  reload retaddr
  return R/0[%eax]
  L126 [2]:
  push trap
  A/10[%eax] := 1
  A/11[%ecx] := [f/9[%ebx]]
  {spilled-s/26[s2]*}
  R/0[%eax] := call A/11[%ecx] R/0[%eax] R/1[%ebx]
  pop trap
  L125 [2]:
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__main2_1041:
                  x/8[%ebx] := R/0[%eax]
                  {x/8[%ebx]*}
                  f/9[%eax] := alloc 16
                  [f/9[%eax] + -4] := 3319
                  [f/9[%eax]] := "camlCode__fun_1067"
                  [f/9[%eax] + 4] := 3
                  [f/9[%eax] + 8] := x/8[%ebx]
                  setup trap L136
                  A/26[s1] := A/12[%eax] (spill)
                  fmt/13[%eax] := ["camlCode" + 8]
                  spilled-fmt/27[s0] := fmt/13[%eax] (spill)
                  A/14[%eax] := ["camlPervasives" + 96]
                  {A/26[s1]* spilled-fmt/27[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:642,18-36}
                  fun/15[%ebx] := R/0[%eax]
                  A/16[%ecx] := [fun/15[%ebx]]
                  fmt/28[%eax] := spilled-fmt/27[s0] (reload)
                  {A/26[s1]*}
                  R/0[%eax] := call A/16[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:642,18-36}
                  A/25[s0] := A/17[%eax] (spill)
                  A/29[%eax] := A/26[s1] (reload)
                  {A/25[s0]*}
                  R/0[%eax] := call "camlPrintexc__to_string_1061" R/0[%eax]
                  A/18[%ebx] := R/0[%eax]
                  A/19[%eax] := "camlCode__4"
                  A/30[%ecx] := A/25[s0] (reload)
                  {}
                  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  A/20[%eax] := ["camlPervasives" + 328]
                  fun/21[%ebx] := [A/20[%eax]]
                  A/22[%eax] := 1
                  A/23[%ecx] := [fun/21[%ebx]]
                  {}
                  call A/23[%ecx] R/0[%eax] R/1[%ebx] {pervasives.ml:446,2-15}
                  push 5
                  {}
                  R/0[%eax] := extcall "caml_sys_exit"  (noalloc) {pervasives.ml:447,2-18}
                  offset stack -4
                  reload retaddr
                  return R/0[%eax]
                  L136 [0]:
                  push trap
                  A/10[%eax] := [f/9[%eax] + 8]
                  I/11[%eax] := I/11[%eax] + 2
                  pop trap
                  L135 [0]:
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__main2_1041:
  x/8[%ebx] := R/0[%eax]
  {x/8[%ebx]*}
  f/9[%eax] := alloc 16
  [f/9[%eax] + -4] := 3319
  [f/9[%eax]] := "camlCode__fun_1067"
  [f/9[%eax] + 4] := 3
  [f/9[%eax] + 8] := x/8[%ebx]
  setup trap L136
  A/26[s1] := A/12[%eax] (spill)
  fmt/13[%eax] := ["camlCode" + 8]
  spilled-fmt/27[s0] := fmt/13[%eax] (spill)
  A/14[%eax] := ["camlPervasives" + 96]
  {A/26[s1]* spilled-fmt/27[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:642,18-36}
  fun/15[%ebx] := R/0[%eax]
  A/16[%ecx] := [fun/15[%ebx]]
  fmt/28[%eax] := spilled-fmt/27[s0] (reload)
  {A/26[s1]*}
  R/0[%eax] := call A/16[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:642,18-36}
  A/25[s0] := A/17[%eax] (spill)
  A/29[%eax] := A/26[s1] (reload)
  {A/25[s0]*}
  R/0[%eax] := call "camlPrintexc__to_string_1061" R/0[%eax]
  A/18[%ebx] := R/0[%eax]
  A/19[%eax] := "camlCode__4"
  A/30[%ecx] := A/25[s0] (reload)
  {}
  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/20[%eax] := ["camlPervasives" + 328]
  fun/21[%ebx] := [A/20[%eax]]
  A/22[%eax] := 1
  A/23[%ecx] := [fun/21[%ebx]]
  {}
  call A/23[%ecx] R/0[%eax] R/1[%ebx] {pervasives.ml:446,2-15}
  push 5
  {}
  R/0[%eax] := extcall "caml_sys_exit"  (noalloc) {pervasives.ml:447,2-18}
  offset stack -4
  reload retaddr
  return R/0[%eax]
  L136 [2]:
  push trap
  A/10[%eax] := [f/9[%eax] + 8]
  I/11[%eax] := I/11[%eax] + 2
  pop trap
  L135 [2]:
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__make_main_1043:
                  protect/8[%ecx] := R/0[%eax]
                  x/9[%edx] := R/1[%ebx]
                  {protect/8[%ecx]* x/9[%edx]*}
                  A/10[%ebx] := alloc 16
                  [A/10[%ebx] + -4] := 3319
                  [A/10[%ebx]] := "camlCode__fun_1074"
                  [A/10[%ebx] + 4] := 3
                  [A/10[%ebx] + 8] := x/9[%edx]
                  A/11[%eax] := "camlCode__5"
                  tailcall "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  *** Linearized code
camlCode__make_main_1043:
  protect/8[%ecx] := R/0[%eax]
  x/9[%edx] := R/1[%ebx]
  {protect/8[%ecx]* x/9[%edx]*}
  A/10[%ebx] := alloc 16
  [A/10[%ebx] + -4] := 3319
  [A/10[%ebx]] := "camlCode__fun_1074"
  [A/10[%ebx] + 4] := 3
  [A/10[%ebx] + 8] := x/9[%edx]
  A/11[%eax] := "camlCode__5"
  tailcall "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  
Before simplify
camlCode__entry:
                  protect1/8[%eax] := "camlCode__10"
                  ["camlCode"] := protect1/8[%eax]
                  main1/9[%eax] := "camlCode__9"
                  ["camlCode" + 4] := main1/9[%eax]
                  msg/10[%eax] := "camlCode__3"
                  ["camlCode" + 8] := msg/10[%eax]
                  protect2/11[%eax] := "camlCode__8"
                  ["camlCode" + 12] := protect2/11[%eax]
                  main2/12[%eax] := "camlCode__7"
                  ["camlCode" + 16] := main2/12[%eax]
                  make_main/13[%eax] := "camlCode__6"
                  ["camlCode" + 20] := make_main/13[%eax]
                  fun/14[%ebx] := ["camlCode" + 20]
                  A/15[%eax] := ["camlCode" + 12]
                  A/16[%ecx] := [fun/14[%ebx]]
                  {}
                  R/0[%eax] := call A/16[%ecx] R/0[%eax] R/1[%ebx]
                  ["camlCode" + 24] := main3/17[%eax]
                  A/18[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  protect1/8[%eax] := "camlCode__10"
  ["camlCode"] := protect1/8[%eax]
  main1/9[%eax] := "camlCode__9"
  ["camlCode" + 4] := main1/9[%eax]
  msg/10[%eax] := "camlCode__3"
  ["camlCode" + 8] := msg/10[%eax]
  protect2/11[%eax] := "camlCode__8"
  ["camlCode" + 12] := protect2/11[%eax]
  main2/12[%eax] := "camlCode__7"
  ["camlCode" + 16] := main2/12[%eax]
  make_main/13[%eax] := "camlCode__6"
  ["camlCode" + 20] := make_main/13[%eax]
  fun/14[%ebx] := ["camlCode" + 20]
  A/15[%eax] := ["camlCode" + 12]
  A/16[%ecx] := [fun/14[%ebx]]
  {}
  R/0[%eax] := call A/16[%ecx] R/0[%eax] R/1[%ebx]
  ["camlCode" + 24] := main3/17[%eax]
  A/18[%eax] := 1
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
	.long	7168
	.globl	camlCode
camlCode:
	.space	28
	.data
	.long	3319
camlCode__6:
	.long	caml_curry2
	.long	5
	.long	camlCode__make_main_1043
	.data
	.long	2295
camlCode__7:
	.long	camlCode__main2_1041
	.long	3
	.data
	.long	3319
camlCode__8:
	.long	caml_curry2
	.long	5
	.long	camlCode__protect2_1037
	.data
	.long	2295
camlCode__9:
	.long	camlCode__main1_1034
	.long	3
	.data
	.long	3319
camlCode__10:
	.long	caml_curry2
	.long	5
	.long	camlCode__protect1_1030
	.data
	.globl	camlCode__1
	.long	8444
camlCode__1:
	.ascii	"Uncaught exception in %s: %s\12%!"
	.byte	0
	.data
	.globl	camlCode__2
	.long	2300
camlCode__2:
	.ascii	"main1"
	.space	2
	.byte	2
	.data
	.globl	camlCode__3
	.long	8444
camlCode__3:
	.ascii	"Uncaught exception in %s: %s\12%!"
	.byte	0
	.data
	.globl	camlCode__4
	.long	2300
camlCode__4:
	.ascii	"main2"
	.space	2
	.byte	2
	.data
	.globl	camlCode__5
	.long	3324
camlCode__5:
	.ascii	"make_main"
	.space	2
	.byte	2
	.text
	.align	16
	.globl	camlCode__fun_1059
camlCode__fun_1059:
.L100:
	movl	8(%ebx), %eax
	addl	$2, %eax
	ret
	.type	camlCode__fun_1059,@function
	.size	camlCode__fun_1059,.-camlCode__fun_1059
	.text
	.align	16
	.globl	camlCode__fun_1067
camlCode__fun_1067:
.L101:
	movl	8(%ebx), %eax
	addl	$2, %eax
	ret
	.type	camlCode__fun_1067,@function
	.size	camlCode__fun_1067,.-camlCode__fun_1067
	.text
	.align	16
	.globl	camlCode__fun_1074
camlCode__fun_1074:
.L102:
	movl	8(%ebx), %eax
	addl	$2, %eax
	ret
	.type	camlCode__fun_1074,@function
	.size	camlCode__fun_1074,.-camlCode__fun_1074
	.text
	.align	16
	.globl	camlCode__protect1_1030
camlCode__protect1_1030:
	subl	$12, %esp
.L105:
	movl	%eax, 4(%esp)
	call	.L104
	movl	%eax, 0(%esp)
	movl	camlPervasives + 96, %eax
	call	camlPrintf__fprintf_1391
.L106:
	movl	%eax, %ebx
	movl	$camlCode__1, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L107:
	movl	%eax, 8(%esp)
	movl	0(%esp), %eax
	call	camlPrintexc__to_string_1061
.L108:
	movl	%eax, %ebx
	movl	4(%esp), %eax
	movl	8(%esp), %ecx
	call	caml_apply2
.L109:
	movl	camlPervasives + 328, %eax
	movl	(%eax), %ebx
	movl	$1, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L110:
	pushl	$5
	movl	$caml_sys_exit, %eax
	call	caml_c_call
.L111:
	addl	$4, %esp
	addl	$12, %esp
	ret
	.align	16
.L104:
	pushl	caml_exception_pointer
	movl	%esp, caml_exception_pointer
	movl	$1, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L112:
	popl	caml_exception_pointer
	addl	$4, %esp
.L103:
	addl	$12, %esp
	ret
	.type	camlCode__protect1_1030,@function
	.size	camlCode__protect1_1030,.-camlCode__protect1_1030
	.text
	.align	16
	.globl	camlCode__main1_1034
camlCode__main1_1034:
	subl	$8, %esp
.L115:
	movl	%eax, %ebx
.L116:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L117
	leal	4(%eax), %eax
	movl	$3319, -4(%eax)
	movl	$camlCode__fun_1059, (%eax)
	movl	$3, 4(%eax)
	movl	%ebx, 8(%eax)
	call	.L114
	movl	%eax, 0(%esp)
	movl	camlPervasives + 96, %eax
	call	camlPrintf__fprintf_1391
.L119:
	movl	%eax, %ebx
	movl	$camlCode__1, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L120:
	movl	%eax, 4(%esp)
	movl	0(%esp), %eax
	call	camlPrintexc__to_string_1061
.L121:
	movl	%eax, %ebx
	movl	$camlCode__2, %eax
	movl	4(%esp), %ecx
	call	caml_apply2
.L122:
	movl	camlPervasives + 328, %eax
	movl	(%eax), %ebx
	movl	$1, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L123:
	pushl	$5
	movl	$caml_sys_exit, %eax
	call	caml_c_call
.L124:
	addl	$4, %esp
	addl	$8, %esp
	ret
	.align	16
.L114:
	pushl	caml_exception_pointer
	movl	%esp, caml_exception_pointer
	movl	8(%eax), %eax
	addl	$2, %eax
	popl	caml_exception_pointer
	addl	$4, %esp
.L113:
	addl	$8, %esp
	ret
.L117:	call	caml_call_gc
.L118:	jmp	.L116
	.type	camlCode__main1_1034,@function
	.size	camlCode__main1_1034,.-camlCode__main1_1034
	.text
	.align	16
	.globl	camlCode__protect2_1037
camlCode__protect2_1037:
	subl	$12, %esp
.L127:
	movl	%eax, 8(%esp)
	call	.L126
	movl	%eax, 4(%esp)
	movl	camlCode + 8, %eax
	movl	%eax, 0(%esp)
	movl	camlPervasives + 96, %eax
	call	camlPrintf__fprintf_1391
.L128:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L129:
	movl	%eax, 0(%esp)
	movl	4(%esp), %eax
	call	camlPrintexc__to_string_1061
.L130:
	movl	%eax, %ebx
	movl	8(%esp), %eax
	movl	0(%esp), %ecx
	call	caml_apply2
.L131:
	movl	camlPervasives + 328, %eax
	movl	(%eax), %ebx
	movl	$1, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L132:
	pushl	$5
	movl	$caml_sys_exit, %eax
	call	caml_c_call
.L133:
	addl	$4, %esp
	addl	$12, %esp
	ret
	.align	16
.L126:
	pushl	caml_exception_pointer
	movl	%esp, caml_exception_pointer
	movl	$1, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L134:
	popl	caml_exception_pointer
	addl	$4, %esp
.L125:
	addl	$12, %esp
	ret
	.type	camlCode__protect2_1037,@function
	.size	camlCode__protect2_1037,.-camlCode__protect2_1037
	.text
	.align	16
	.globl	camlCode__main2_1041
camlCode__main2_1041:
	subl	$8, %esp
.L137:
	movl	%eax, %ebx
.L138:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L139
	leal	4(%eax), %eax
	movl	$3319, -4(%eax)
	movl	$camlCode__fun_1067, (%eax)
	movl	$3, 4(%eax)
	movl	%ebx, 8(%eax)
	call	.L136
	movl	%eax, 4(%esp)
	movl	camlCode + 8, %eax
	movl	%eax, 0(%esp)
	movl	camlPervasives + 96, %eax
	call	camlPrintf__fprintf_1391
.L141:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L142:
	movl	%eax, 0(%esp)
	movl	4(%esp), %eax
	call	camlPrintexc__to_string_1061
.L143:
	movl	%eax, %ebx
	movl	$camlCode__4, %eax
	movl	0(%esp), %ecx
	call	caml_apply2
.L144:
	movl	camlPervasives + 328, %eax
	movl	(%eax), %ebx
	movl	$1, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L145:
	pushl	$5
	movl	$caml_sys_exit, %eax
	call	caml_c_call
.L146:
	addl	$4, %esp
	addl	$8, %esp
	ret
	.align	16
.L136:
	pushl	caml_exception_pointer
	movl	%esp, caml_exception_pointer
	movl	8(%eax), %eax
	addl	$2, %eax
	popl	caml_exception_pointer
	addl	$4, %esp
.L135:
	addl	$8, %esp
	ret
.L139:	call	caml_call_gc
.L140:	jmp	.L138
	.type	camlCode__main2_1041,@function
	.size	camlCode__main2_1041,.-camlCode__main2_1041
	.text
	.align	16
	.globl	camlCode__make_main_1043
camlCode__make_main_1043:
.L147:
	movl	%eax, %ecx
	movl	%ebx, %edx
.L148:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L149
	leal	4(%eax), %ebx
	movl	$3319, -4(%ebx)
	movl	$camlCode__fun_1074, (%ebx)
	movl	$3, 4(%ebx)
	movl	%edx, 8(%ebx)
	movl	$camlCode__5, %eax
	jmp	caml_apply2
.L149:	call	caml_call_gc
.L150:	jmp	.L148
	.type	camlCode__make_main_1043,@function
	.size	camlCode__make_main_1043,.-camlCode__make_main_1043
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L151:
	movl	$camlCode__10, %eax
	movl	%eax, camlCode
	movl	$camlCode__9, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__3, %eax
	movl	%eax, camlCode + 8
	movl	$camlCode__8, %eax
	movl	%eax, camlCode + 12
	movl	$camlCode__7, %eax
	movl	%eax, camlCode + 16
	movl	$camlCode__6, %eax
	movl	%eax, camlCode + 20
	movl	camlCode + 20, %ebx
	movl	camlCode + 12, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L152:
	movl	%eax, camlCode + 24
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
	.long	30
	.long	.L152
	.word	4
	.word	0
	.align	4
	.long	.L150
	.word	4
	.word	2
	.word	7
	.word	5
	.align	4
	.long	.L146
	.word	17
	.word	0
	.align	4
	.long	.L200000 - . + 0x48000000
	.long	0x1bf020
	.long	.L145
	.word	13
	.word	0
	.align	4
	.long	.L200000 - . + 0x3c000000
	.long	0x1be020
	.long	.L144
	.word	12
	.word	0
	.align	4
	.long	.L143
	.word	12
	.word	1
	.word	0
	.align	4
	.long	.L142
	.word	13
	.word	1
	.word	4
	.align	4
	.long	.L200001 - . + 0x90000000
	.long	0x282120
	.long	.L141
	.word	13
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L200001 - . + 0x90000000
	.long	0x282120
	.long	.L140
	.word	12
	.word	1
	.word	3
	.align	4
	.long	.L134
	.word	24
	.word	1
	.word	16
	.align	4
	.long	.L133
	.word	21
	.word	0
	.align	4
	.long	.L200000 - . + 0x48000000
	.long	0x1bf020
	.long	.L132
	.word	17
	.word	0
	.align	4
	.long	.L200000 - . + 0x3c000000
	.long	0x1be020
	.long	.L131
	.word	16
	.word	0
	.align	4
	.long	.L130
	.word	16
	.word	2
	.word	8
	.word	0
	.align	4
	.long	.L129
	.word	17
	.word	2
	.word	4
	.word	8
	.align	4
	.long	.L200001 - . + 0x90000000
	.long	0x282120
	.long	.L128
	.word	17
	.word	3
	.word	0
	.word	4
	.word	8
	.align	4
	.long	.L200001 - . + 0x90000000
	.long	0x282120
	.long	.L124
	.word	17
	.word	0
	.align	4
	.long	.L200000 - . + 0x48000000
	.long	0x1bf020
	.long	.L123
	.word	13
	.word	0
	.align	4
	.long	.L200000 - . + 0x3c000000
	.long	0x1be020
	.long	.L122
	.word	12
	.word	0
	.align	4
	.long	.L121
	.word	12
	.word	1
	.word	4
	.align	4
	.long	.L120
	.word	13
	.word	1
	.word	0
	.align	4
	.long	.L200001 - . + 0x90000000
	.long	0x282120
	.long	.L119
	.word	13
	.word	1
	.word	0
	.align	4
	.long	.L200001 - . + 0x90000000
	.long	0x282120
	.long	.L118
	.word	12
	.word	1
	.word	3
	.align	4
	.long	.L112
	.word	24
	.word	1
	.word	12
	.align	4
	.long	.L111
	.word	21
	.word	0
	.align	4
	.long	.L200000 - . + 0x48000000
	.long	0x1bf020
	.long	.L110
	.word	17
	.word	0
	.align	4
	.long	.L200000 - . + 0x3c000000
	.long	0x1be020
	.long	.L109
	.word	16
	.word	0
	.align	4
	.long	.L108
	.word	16
	.word	2
	.word	4
	.word	8
	.align	4
	.long	.L107
	.word	17
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L200001 - . + 0x90000000
	.long	0x282120
	.long	.L106
	.word	17
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L200001 - . + 0x90000000
	.long	0x282120
.L200000:
	.ascii	"pervasives.ml\0"
	.align	4
.L200001:
	.ascii	"printf.ml\0"
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

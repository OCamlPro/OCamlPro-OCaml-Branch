

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
  | _ -> assert false
      (*
-drawlambda
File "code.ml", line 11, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 21, characters 10-21:
Warning 10: this expression should have type unit.
(seq
  (let (match/1043 (array.get (field 0 (global Sys!)) 1))
    (catch
      (if (caml_string_notequal match/1043 "0")
        (if (caml_string_notequal match/1043 "1") (exit 4)
          (for i/1035 0 to 10000000
            (let
              (a/1036
                 (makeblock 246
                   (function param/1042
                     (caml_sqrt_float (float_of_int i/1035))))
               f/1037
                 (function x/1038
                   (+. x/1038
                     (let
                       (lzarg/1040 a/1036 tag/1041 (caml_obj_tag lzarg/1040))
                       (if (== tag/1041 250) (field 0 lzarg/1040)
                         (if (== tag/1041 246)
                           (apply (field 1 (global CamlinternalLazy!))
                             lzarg/1040)
                           lzarg/1040))))))
              (for j/1039 0 to 10 (apply f/1037 (float_of_int j/1039))))))
        (for i/1031 0 to 10000000
          (let
            (f/1032
               (function x/1033
                 (+. x/1033 (caml_sqrt_float (float_of_int i/1031)))))
            (for j/1034 0 to 10 (apply f/1032 (float_of_int j/1034))))))
     with (4)
      (raise (makeblock 0 (global Assert_failure/26g) [0: "code.ml" 24 9]))))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1037 is known
	Ident used 4 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 2 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
-dlambda
File "code.ml", line 11, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 21, characters 10-21:
Warning 10: this expression should have type unit.
(seq
  (let (match/1043 (array.get (field 0 (global Sys!)) 1))
    (if (caml_string_notequal match/1043 "0")
      (if (caml_string_notequal match/1043 "1")
        (raise (makeblock 0 (global Assert_failure/26g) [0: "code.ml" 24 9]))
        (for i/1035 0 to 10000000
          (let
            (a/1036
               (makeblock 246
                 (function param/1042
                   (caml_sqrt_float (float_of_int i/1035))))
             f/1037
               (function x/1038
                 (+. x/1038
                   (let (tag/1041 (caml_obj_tag a/1036))
                     (if (== tag/1041 250) (field 0 a/1036)
                       (if (== tag/1041 246)
                         (apply (field 1 (global CamlinternalLazy!)) a/1036)
                         a/1036))))))
            (for j/1039 0 to 10 (apply f/1037 (float_of_int j/1039))))))
      (for i/1031 0 to 10000000
        (let
          (f/1032
             (function x/1033
               (+. x/1033 (caml_sqrt_float (float_of_int i/1031)))))
          (for j/1034 0 to 10 (apply f/1032 (float_of_int j/1034)))))))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

stats_rec_removed : 0

stats_tailcall_removed : 0

pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1037 is known
	Ident used 4 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 2 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
-dlambda2
File "code.ml", line 11, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 21, characters 10-21:
Warning 10: this expression should have type unit.
*** After TonLambda.optimize:
(seq
  (let (match/1043 (array.get (field 0 (global Sys!)) 1))
    (if (caml_string_notequal match/1043 "0")
      (if (caml_string_notequal match/1043 "1")
        (raise (makeblock 0 (global Assert_failure/26g) [0: "code.ml" 24 9]))
        (for i/1035 0 to 10000000
          (let
            (a/1036
               (makeblock 246
                 (function param/1042
                   (caml_sqrt_float (float_of_int i/1035))))
             f/1037
               (function x/1038
                 (+. x/1038
                   (let (tag/1041 (caml_obj_tag a/1036))
                     (if (== tag/1041 250) (field 0 a/1036)
                       (if (== tag/1041 246)
                         (apply (field 1 (global CamlinternalLazy!)) a/1036)
                         a/1036))))))
            (for j/1039 0 to 10 (apply f/1037 (float_of_int j/1039))))))
      (for i/1031 0 to 10000000
        (let
          (f/1032
             (function x/1033
               (+. x/1033 (caml_sqrt_float (float_of_int i/1031)))))
          (for j/1034 0 to 10 (apply f/1032 (float_of_int j/1034)))))))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1037 is known
	Ident used 4 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 2 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
-dclosure
File "code.ml", line 11, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 21, characters 10-21:
Warning 10: this expression should have type unit.
*** After Closure.intro:
(seq
  (let (match/1043 (array.get (field 0 (global camlSys!)) 1))
    (if (caml_string_notequal match/1043 "0")
      (if (caml_string_notequal match/1043 "1")
        (raise
          (makeblock 0 (global caml_exn_Assert_failure!) [0: "code.ml" 24 9]))
        (for i/1035 0 to 10000000
          (let
            (a/1036
               (makeblock 246
                 (closure (camlCode__fun_1044(1+c)  param/1042 env/1046
                            (caml_sqrt_float
                              (float_of_int (field 2 env/1046)))) {2} 
                                                                  i/1035))
             f/1037
               (closure (camlCode__f_1037(1+c)  x/1038 env/1048
                          (+. x/1038
                            (let
                              (tag/1041[Alias]
                                 (caml_obj_tag (field 2 env/1048)))
                              (if (== tag/1041 250)
                                (field 0 (field 2 env/1048))
                                (if (== tag/1041 246)
                                  (camlCamlinternalLazy__force_lazy_block_1033
                                     (field 2 env/1048))
                                  (field 2 env/1048)))))) {2} 
                                                          a/1036))
            (for j/1039 0 to 10
              (let (x/1049 (float_of_int j/1039))
                (+. x/1049
                  (let (tag/1050[Alias] (caml_obj_tag (field 2 f/1037)))
                    (if (== tag/1050 250) (field 0 (field 2 f/1037))
                      (if (== tag/1050 246)
                        (camlCamlinternalLazy__force_lazy_block_1033 
                          (field 2 f/1037))
                        (field 2 f/1037))))))))))
      (for i/1031 0 to 10000000
        (let
          (f/1032
             (closure (camlCode__f_1032(1+c)  x/1033 env/1052
                        (+. x/1033
                          (caml_sqrt_float (float_of_int (field 2 env/1052))))) 
               {2} 
               i/1031))
          (for j/1034 0 to 10
            (let (x/1053 (float_of_int j/1034))
              (+. x/1053 (caml_sqrt_float (float_of_int (field 2 f/1032))))))))))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1037 is known
	Ident used 4 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 2 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
-dclosure2
File "code.ml", line 11, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 21, characters 10-21:
Warning 10: this expression should have type unit.
pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1037 is known
	Ident used 4 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
*** After TonClosure.optimize:
(let (temp/1095 (global camlSys!) temp/1094 (field 0 temp/1095) match/1043 (array.get temp/1094 1) temp/1055 "0" temp/1054 (caml_string_notequal match/1043 temp/1055))
  (seq
    (if temp/1054 (let (temp/1067 "1" temp/1066 (caml_string_notequal match/1043 temp/1067)) (if temp/1066 (let (temp/1092 (global caml_exn_Assert_failure!) temp/1093 [0: "code.ml" 24 9] temp/1091 (makeblock 0 temp/1092 temp/1093)) (raise temp/1091)) (for i/1035 0 to 10000000 (let (temp/1088 (closure (camlCode__fun_1044(1+c)  param/1042 env/1046 (let (temp/1090 (field 2 env/1046) temp/1089 (float_of_int temp/1090)) (caml_sqrt_float temp/1089))) {2} 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                 i/1035) a/1036 (makeblock 246 temp/1088)) (for j/1039 0 to 10 (let (x/1049 (float_of_int j/1039) temp/1072 (let (tag/1050[Alias] (caml_obj_tag a/1036) temp/1073 (== tag/1050 250)) (if temp/1073 temp/1088 (let (temp/1075 (== tag/1050 246)) (if temp/1075 (camlCamlinternalLazy__force_lazy_block_1033  a/1036) a/1036))))) (+. x/1049 temp/1072)))))))
      (for i/1031 0 to 10000000 (let (f/1032 (closure (camlCode__f_1032(1+c)  x/1033 env/1052 (let (temp/1065 (field 2 env/1052) temp/1064 (float_of_int temp/1065) temp/1063 (caml_sqrt_float temp/1064)) (+. x/1033 temp/1063))) {2} 
                                                                                                                                                                                                                                   i/1031)) (for j/1034 0 to 10 (let (x/1053 (float_of_int j/1034) temp/1062 (field 2 f/1032) temp/1061 (float_of_int temp/1062) temp/1060 (caml_sqrt_float temp/1061)) (+. x/1053 temp/1060))))))
    0a))
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 2 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times

-dcmm
File "code.ml", line 11, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 21, characters 10-21:
Warning 10: this expression should have type unit.
pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1037 is known
	Ident used 4 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 2 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
(data int 0 global "camlCode" "camlCode": skip 0)
(data global "camlCode__1" int 1276 "camlCode__1": string "0" skip 2 byte 2)
(data global "camlCode__2" int 1276 "camlCode__2": string "1" skip 2 byte 2)
(data global "camlCode__3" int 3072 "camlCode__3": addr L4 int 49 int 19 int 2300 L4: string "code.ml" skip 0 byte 0)
(function camlCode__fun_1044 (param/1042: addr env/1046: addr) (let (temp/1090 (load (+a env/1046 8)) temp/1122 (floatofint (>>s temp/1090 1))) (alloc[253] 2301 (extcall "sqrt" temp/1122 float))))

(function camlCode__f_1032 (x/1033: addr env/1052: addr) (let (temp/1065 (load (+a env/1052 8)) temp/1121 (floatofint (>>s temp/1065 1)) temp/1120 (extcall "sqrt" temp/1121 float)) (alloc[253] 2301 (+f (load float64u x/1033) temp/1120))))

(function camlCode__entry ()
 (let (temp/1095 "camlSys" temp/1094 (load temp/1095) match/1043 (let temp/1107 3 (checkbound (>>u (load (+a temp/1094 -4)) 9) temp/1107) (load (+a (+a temp/1094 (<< temp/1107 1)) -2))) temp/1055 "camlCode__1" temp/1054 (extcall "caml_string_notequal" match/1043 temp/1055 addr))
   (if (!= temp/1054 1)
     (let (temp/1067 "camlCode__2" temp/1066 (extcall "caml_string_notequal" match/1043 temp/1067 addr))
       (if (!= temp/1066 1) (let (temp/1092 "caml_exn_Assert_failure" temp/1093 "camlCode__3" temp/1091 (alloc[0] 2048 temp/1092 temp/1093)) (raise temp/1091) [])
         (let (temp/1101 1 temp/1102 20000001 i/1035[Variable] temp/1101 bound/1116 temp/1102)
           (catch (if (> i/1035 bound/1116) (exit 7) (loop (let (temp/1088 (alloc[247] 3319 "camlCode__fun_1044" 3 i/1035) a/1036 (alloc[246] 1270 temp/1088) temp/1103 1 temp/1104 21 j/1039[Variable] temp/1103 bound/1118 temp/1104) (catch (if (> j/1039 bound/1118) (exit 8) (loop (let (x/1119 (floatofint (>>s j/1039 1)) temp/1072 (let (tag/1050[Alias] (extcall "caml_obj_tag" a/1036 addr) temp/1073 (let temp/1106 501 (+ (<< (== tag/1050 temp/1106) 1) 1))) (if (!= temp/1073 1) temp/1088 (let temp/1075 (let temp/1105 493 (+ (<< (== tag/1050 temp/1105) 1) 1)) (if (!= temp/1075 1) (app "camlCamlinternalLazy__force_lazy_block_1033" a/1036 addr) a/1036))))) (alloc[253] 2301 (+f x/1119 (load float64u temp/1072))) []) (let j/1117 j/1039 (assign j/1039 (+ j/1039 2)) (if (== j/1117 bound/1118) (exit 8) [])))) with(8) [])) (let i/1115 i/1035 (assign i/1035 (+ i/1035 2)) (if (== i/1115 bound/1116) (exit 7) [])))) with(7) []))))
     (let (temp/1097 1 temp/1098 20000001 i/1031[Variable] temp/1097 bound/1109 temp/1098) (catch (if (> i/1031 bound/1109) (exit 5) (loop (let (f/1032 (alloc[247] 3319 "camlCode__f_1032" 3 i/1031) temp/1099 1 temp/1100 21 j/1034[Variable] temp/1099 bound/1111 temp/1100) (catch (if (> j/1034 bound/1111) (exit 6) (loop (let (x/1114 (floatofint (>>s j/1034 1)) temp/1062 (load (+a f/1032 8)) temp/1113 (floatofint (>>s temp/1062 1)) temp/1112 (extcall "sqrt" temp/1113 float)) (alloc[253] 2301 (+f x/1114 temp/1112)) []) (let j/1110 j/1034 (assign j/1034 (+ j/1034 2)) (if (== j/1110 bound/1111) (exit 6) [])))) with(6) [])) (let i/1108 i/1031 (assign i/1031 (+ i/1031 2)) (if (== i/1108 bound/1109) (exit 5) [])))) with(5) [])))
   1a))

(data)
-dlinear
File "code.ml", line 11, characters 10-21:
Warning 10: this expression should have type unit.
File "code.ml", line 21, characters 10-21:
Warning 10: this expression should have type unit.
pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1037 is known
	Ident used 4 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function temp/1088 is known
	Ident used 2 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Before simplify
camlCode__fun_1044:
                  temp/10[%eax] := [env/9[%ebx] + 8]
                  I/11[%eax] := I/11[%eax] >>s 1
                  R/7[%tos] := floatofint I/11[%eax]
                  temp/13[s0] := R/7[%tos]
                  push temp/13[s0]
                  {}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  F/14[s0] := R/7[%tos]
                  {F/14[s0]}
                  A/15[%eax] := alloc 12
                  [A/15[%eax] + -4] := 2301
                  float64u[A/15[%eax]] := F/14[s0]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_1044:
  temp/10[%eax] := [env/9[%ebx] + 8]
  I/11[%eax] := I/11[%eax] >>s 1
  R/7[%tos] := floatofint I/11[%eax]
  temp/13[s0] := R/7[%tos]
  push temp/13[s0]
  {}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/14[s0] := R/7[%tos]
  {F/14[s0]}
  A/15[%eax] := alloc 12
  [A/15[%eax] + -4] := 2301
  float64u[A/15[%eax]] := F/14[s0]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__f_1032:
                  x/8[%esi] := R/0[%eax]
                  temp/10[%eax] := [env/9[%ebx] + 8]
                  I/11[%eax] := I/11[%eax] >>s 1
                  R/7[%tos] := floatofint I/11[%eax]
                  temp/13[s0] := R/7[%tos]
                  push temp/13[s0]
                  {x/8[%esi]*}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  temp/14[s0] := R/7[%tos]
                  {x/8[%esi]* temp/14[s0]}
                  A/15[%eax] := alloc 12
                  [A/15[%eax] + -4] := 2301
                  R/7[%tos] := temp/14[s0] +f float64[x/8[%esi]]
                  float64u[A/15[%eax]] := R/7[%tos]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f_1032:
  x/8[%esi] := R/0[%eax]
  temp/10[%eax] := [env/9[%ebx] + 8]
  I/11[%eax] := I/11[%eax] >>s 1
  R/7[%tos] := floatofint I/11[%eax]
  temp/13[s0] := R/7[%tos]
  push temp/13[s0]
  {x/8[%esi]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  temp/14[s0] := R/7[%tos]
  {x/8[%esi]* temp/14[s0]}
  A/15[%eax] := alloc 12
  [A/15[%eax] + -4] := 2301
  R/7[%tos] := temp/14[s0] +f float64[x/8[%esi]]
  float64u[A/15[%eax]] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  temp/8[%eax] := "camlSys"
                  temp/9[%ecx] := [temp/8[%eax]]
                  temp/10[%ebx] := 3
                  A/11[%eax] := [temp/9[%ecx] + -4]
                  I/12[%eax] := I/12[%eax] >>u 9
                  I/12[%eax] check > temp/10[%ebx]
                  match/13[%ebx] := [temp/9[%ecx] + temp/10[%ebx] * 2 + -2]
                  temp/14[%eax] := "camlCode__1"
                  push temp/14[%eax]
                  push match/13[%ebx]
                  {match/13[%ebx]*}
                  R/0[%eax] := extcall "caml_string_notequal" 
                  offset stack -8
                  if temp/15[%eax] ==s 1 goto L112
                  temp/16[%eax] := "camlCode__2"
                  push temp/16[%eax]
                  push match/13[%ebx]
                  {}
                  R/0[%eax] := extcall "caml_string_notequal" 
                  offset stack -8
                  if temp/17[%eax] ==s 1 goto L118
                  temp/18[%ecx] := "caml_exn_Assert_failure"
                  temp/19[%ebx] := "camlCode__3"
                  {temp/18[%ecx]* temp/19[%ebx]*}
                  temp/20[%eax] := alloc 12
                  [temp/20[%eax] + -4] := 2048
                  [temp/20[%eax]] := temp/18[%ecx]
                  [temp/20[%eax] + 4] := temp/19[%ebx]
                  raise R/0[%eax]
                  L118 [0]:
                  temp/21[%ebx] := 1
                  temp/22[%eax] := 20000001
                  if i/23[%ebx] >s bound/24[%eax] goto L108
                  spilled-bound/77[s1] := bound/24[%eax] (spill)
                  spilled-i/78[s0] := i/23[%ebx] (spill)
                  L113 [0]:
                  {i/23[%ebx] spilled-bound/77[s1] spilled-i/78[s0]}
                  temp/25[%ecx] := alloc 24
                  spilled-temp/72[s5] := temp/25[%ecx] (spill)
                  [temp/25[%ecx] + -4] := 3319
                  [temp/25[%ecx]] := "camlCode__fun_1044"
                  [temp/25[%ecx] + 4] := 3
                  [temp/25[%ecx] + 8] := i/23[%ebx]
                  a/26[%eax] := temp/25[%ecx] + 16
                  spilled-a/76[s2] := a/26[%eax] (spill)
                  [a/26[%eax] + -4] := 1270
                  [a/26[%eax]] := temp/25[%ecx]
                  temp/27[%ebx] := 1
                  temp/28[%eax] := 21
                  spilled-j/74[s3] := j/29[%ebx] (spill)
                  spilled-bound/73[s4] := bound/30[%eax] (spill)
                  if j/29[%ebx] >s bound/30[%eax] goto L114
                  L115 [0]:
                  I/31[%ebx] := I/31[%ebx] >>s 1
                  R/7[%tos] := floatofint I/31[%ebx]
                  x/33[s0] := R/7[%tos]
                  a/80[%ebx] := spilled-a/76[s2] (reload)
                  push a/80[%ebx]
                  {spilled-temp/72[s5]* spilled-bound/73[s4] spilled-j/74[s3] spilled-x/75[s0] spilled-a/76[s2]* spilled-bound/77[s1] spilled-i/78[s0] a/80[%ebx]*}
                  R/0[%eax] := extcall "caml_obj_tag" 
                  offset stack -4
                  tag/34[%ecx] := R/0[%eax]
                  temp/35[%eax] := 501
                  I/36[%eax] := tag/34[%ecx] ==s temp/35[%eax]
                  temp/37[%eax] := I/36[%eax]  * 2 + 1
                  if temp/37[%eax] ==s 1 goto L117
                  temp/81[%ebx] := spilled-temp/72[s5] (reload)
                  goto L116
                  L117 [0]:
                  temp/38[%eax] := 493
                  I/39[%eax] := tag/34[%ecx] ==s temp/38[%eax]
                  temp/40[%eax] := I/39[%eax]  * 2 + 1
                  if temp/40[%eax] ==s 1 goto L116
                  R/0[%eax] := a/80[%ebx]
                  {spilled-temp/72[s5]* spilled-bound/73[s4] spilled-j/74[s3] spilled-x/75[s0] spilled-a/76[s2]* spilled-bound/77[s1] spilled-i/78[s0]}
                  R/0[%eax] := call "camlCamlinternalLazy__force_lazy_block_1033" R/0[%eax]
                  temp/41[%ebx] := R/0[%eax]
                  L116 [0]:
                  {temp/41[%ebx]* spilled-temp/72[s5]* spilled-bound/73[s4] spilled-j/74[s3] spilled-x/75[s0] spilled-a/76[s2]* spilled-bound/77[s1] spilled-i/78[s0]}
                  A/42[%eax] := alloc 12
                  [A/42[%eax] + -4] := 2301
                  R/7[%tos] := x/82[s0] +f float64[temp/41[%ebx]]
                  float64u[A/42[%eax]] := R/7[%tos]
                  j/29[%ebx] := spilled-j/74[s3] (reload)
                  j/44[%ecx] := j/29[%ebx]
                  I/45[%ebx] := I/45[%ebx] + 2
                  spilled-j/74[s3] := j/29[%ebx] (spill)
                  bound/84[%eax] := spilled-bound/73[s4] (reload)
                  if j/44[%ecx] !=s bound/84[%eax] goto L115
                  L114 [0]:
                  i/23[%ebx] := spilled-i/78[s0] (reload)
                  i/46[%ecx] := i/23[%ebx]
                  I/47[%ebx] := I/47[%ebx] + 2
                  spilled-i/78[s0] := i/23[%ebx] (spill)
                  bound/86[%eax] := spilled-bound/77[s1] (reload)
                  if i/46[%ecx] !=s bound/86[%eax] goto L113
                  goto L108
                  L112 [0]:
                  temp/48[%ebp] := 1
                  temp/49[%eax] := 20000001
                  if i/50[%ebp] >s bound/51[%eax] goto L108
                  spilled-bound/79[s0] := bound/51[%eax] (spill)
                  L109 [0]:
                  {i/50[%ebp] spilled-bound/79[s0]}
                  f/52[%esi] := alloc 16
                  [f/52[%esi] + -4] := 3319
                  [f/52[%esi]] := "camlCode__f_1032"
                  [f/52[%esi] + 4] := 3
                  [f/52[%esi] + 8] := i/50[%ebp]
                  temp/53[%ebx] := 1
                  temp/54[%edi] := 21
                  if j/55[%ebx] >s bound/56[%edi] goto L110
                  L111 [0]:
                  I/57[%eax] := j/55[%ebx]
                  I/57[%eax] := I/57[%eax] >>s 1
                  R/7[%tos] := floatofint I/57[%eax]
                  x/59[s1] := R/7[%tos]
                  temp/60[%eax] := [f/52[%esi] + 8]
                  I/61[%eax] := I/61[%eax] >>s 1
                  R/7[%tos] := floatofint I/61[%eax]
                  temp/63[s0] := R/7[%tos]
                  push temp/63[s0]
                  {i/50[%ebp] f/52[%esi]* j/55[%ebx] bound/56[%edi] x/59[s1] spilled-bound/79[s0]}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  temp/64[s0] := R/7[%tos]
                  {i/50[%ebp] f/52[%esi]* j/55[%ebx] bound/56[%edi] x/59[s1] temp/64[s0] spilled-bound/79[s0]}
                  A/65[%eax] := alloc 12
                  [A/65[%eax] + -4] := 2301
                  R/7[%tos] := x/59[s1] +f temp/64[s0]
                  float64u[A/65[%eax]] := R/7[%tos]
                  j/67[%eax] := j/55[%ebx]
                  I/68[%ebx] := I/68[%ebx] + 2
                  if j/67[%eax] !=s bound/56[%edi] goto L111
                  L110 [0]:
                  i/69[%ebx] := i/50[%ebp]
                  I/70[%ebp] := I/70[%ebp] + 2
                  bound/87[%eax] := spilled-bound/79[s0] (reload)
                  if i/69[%ebx] !=s bound/87[%eax] goto L109
                  L108 [0]:
                  A/71[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  temp/8[%eax] := "camlSys"
  temp/9[%ecx] := [temp/8[%eax]]
  temp/10[%ebx] := 3
  A/11[%eax] := [temp/9[%ecx] + -4]
  I/12[%eax] := I/12[%eax] >>u 9
  I/12[%eax] check > temp/10[%ebx]
  match/13[%ebx] := [temp/9[%ecx] + temp/10[%ebx] * 2 + -2]
  temp/14[%eax] := "camlCode__1"
  push temp/14[%eax]
  push match/13[%ebx]
  {match/13[%ebx]*}
  R/0[%eax] := extcall "caml_string_notequal" 
  offset stack -8
  if temp/15[%eax] ==s 1 goto L112
  temp/16[%eax] := "camlCode__2"
  push temp/16[%eax]
  push match/13[%ebx]
  {}
  R/0[%eax] := extcall "caml_string_notequal" 
  offset stack -8
  if temp/17[%eax] ==s 1 goto L118
  temp/18[%ecx] := "caml_exn_Assert_failure"
  temp/19[%ebx] := "camlCode__3"
  {temp/18[%ecx]* temp/19[%ebx]*}
  temp/20[%eax] := alloc 12
  [temp/20[%eax] + -4] := 2048
  [temp/20[%eax]] := temp/18[%ecx]
  [temp/20[%eax] + 4] := temp/19[%ebx]
  raise R/0[%eax]
  L118 [2]:
  temp/21[%ebx] := 1
  temp/22[%eax] := 20000001
  if i/23[%ebx] >s bound/24[%eax] goto L108
  spilled-bound/77[s1] := bound/24[%eax] (spill)
  spilled-i/78[s0] := i/23[%ebx] (spill)
  L113 [4]:
  {i/23[%ebx] spilled-bound/77[s1] spilled-i/78[s0]}
  temp/25[%ecx] := alloc 24
  spilled-temp/72[s5] := temp/25[%ecx] (spill)
  [temp/25[%ecx] + -4] := 3319
  [temp/25[%ecx]] := "camlCode__fun_1044"
  [temp/25[%ecx] + 4] := 3
  [temp/25[%ecx] + 8] := i/23[%ebx]
  a/26[%eax] := temp/25[%ecx] + 16
  spilled-a/76[s2] := a/26[%eax] (spill)
  [a/26[%eax] + -4] := 1270
  [a/26[%eax]] := temp/25[%ecx]
  temp/27[%ebx] := 1
  temp/28[%eax] := 21
  spilled-j/74[s3] := j/29[%ebx] (spill)
  spilled-bound/73[s4] := bound/30[%eax] (spill)
  if j/29[%ebx] >s bound/30[%eax] goto L114
  L115 [4]:
  I/31[%ebx] := I/31[%ebx] >>s 1
  R/7[%tos] := floatofint I/31[%ebx]
  x/33[s0] := R/7[%tos]
  a/80[%ebx] := spilled-a/76[s2] (reload)
  push a/80[%ebx]
  {spilled-temp/72[s5]* spilled-bound/73[s4] spilled-j/74[s3] spilled-x/75[s0] spilled-a/76[s2]* spilled-bound/77[s1] spilled-i/78[s0] a/80[%ebx]*}
  R/0[%eax] := extcall "caml_obj_tag" 
  offset stack -4
  tag/34[%ecx] := R/0[%eax]
  temp/35[%eax] := 501
  I/36[%eax] := tag/34[%ecx] ==s temp/35[%eax]
  temp/37[%eax] := I/36[%eax]  * 2 + 1
  if temp/37[%eax] ==s 1 goto L117
  temp/81[%ebx] := spilled-temp/72[s5] (reload)
  goto L116
  L117 [2]:
  temp/38[%eax] := 493
  I/39[%eax] := tag/34[%ecx] ==s temp/38[%eax]
  temp/40[%eax] := I/39[%eax]  * 2 + 1
  if temp/40[%eax] ==s 1 goto L116
  R/0[%eax] := a/80[%ebx]
  {spilled-temp/72[s5]* spilled-bound/73[s4] spilled-j/74[s3] spilled-x/75[s0] spilled-a/76[s2]* spilled-bound/77[s1] spilled-i/78[s0]}
  R/0[%eax] := call "camlCamlinternalLazy__force_lazy_block_1033" R/0[%eax]
  temp/41[%ebx] := R/0[%eax]
  L116 [5]:
  {temp/41[%ebx]* spilled-temp/72[s5]* spilled-bound/73[s4] spilled-j/74[s3] spilled-x/75[s0] spilled-a/76[s2]* spilled-bound/77[s1] spilled-i/78[s0]}
  A/42[%eax] := alloc 12
  [A/42[%eax] + -4] := 2301
  R/7[%tos] := x/82[s0] +f float64[temp/41[%ebx]]
  float64u[A/42[%eax]] := R/7[%tos]
  j/29[%ebx] := spilled-j/74[s3] (reload)
  j/44[%ecx] := j/29[%ebx]
  I/45[%ebx] := I/45[%ebx] + 2
  spilled-j/74[s3] := j/29[%ebx] (spill)
  bound/84[%eax] := spilled-bound/73[s4] (reload)
  if j/44[%ecx] !=s bound/84[%eax] goto L115
  L114 [4]:
  i/23[%ebx] := spilled-i/78[s0] (reload)
  i/46[%ecx] := i/23[%ebx]
  I/47[%ebx] := I/47[%ebx] + 2
  spilled-i/78[s0] := i/23[%ebx] (spill)
  bound/86[%eax] := spilled-bound/77[s1] (reload)
  if i/46[%ecx] !=s bound/86[%eax] goto L113
  goto L108
  L112 [2]:
  temp/48[%ebp] := 1
  temp/49[%eax] := 20000001
  if i/50[%ebp] >s bound/51[%eax] goto L108
  spilled-bound/79[s0] := bound/51[%eax] (spill)
  L109 [4]:
  {i/50[%ebp] spilled-bound/79[s0]}
  f/52[%esi] := alloc 16
  [f/52[%esi] + -4] := 3319
  [f/52[%esi]] := "camlCode__f_1032"
  [f/52[%esi] + 4] := 3
  [f/52[%esi] + 8] := i/50[%ebp]
  temp/53[%ebx] := 1
  temp/54[%edi] := 21
  if j/55[%ebx] >s bound/56[%edi] goto L110
  L111 [4]:
  I/57[%eax] := j/55[%ebx]
  I/57[%eax] := I/57[%eax] >>s 1
  R/7[%tos] := floatofint I/57[%eax]
  x/59[s1] := R/7[%tos]
  temp/60[%eax] := [f/52[%esi] + 8]
  I/61[%eax] := I/61[%eax] >>s 1
  R/7[%tos] := floatofint I/61[%eax]
  temp/63[s0] := R/7[%tos]
  push temp/63[s0]
  {i/50[%ebp] f/52[%esi]* j/55[%ebx] bound/56[%edi] x/59[s1] spilled-bound/79[s0]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  temp/64[s0] := R/7[%tos]
  {i/50[%ebp] f/52[%esi]* j/55[%ebx] bound/56[%edi] x/59[s1] temp/64[s0] spilled-bound/79[s0]}
  A/65[%eax] := alloc 12
  [A/65[%eax] + -4] := 2301
  R/7[%tos] := x/59[s1] +f temp/64[s0]
  float64u[A/65[%eax]] := R/7[%tos]
  j/67[%eax] := j/55[%ebx]
  I/68[%ebx] := I/68[%ebx] + 2
  if j/67[%eax] !=s bound/56[%edi] goto L111
  L110 [4]:
  i/69[%ebx] := i/50[%ebp]
  I/70[%ebp] := I/70[%ebp] + 2
  bound/87[%eax] := spilled-bound/79[s0] (reload)
  if i/69[%ebx] !=s bound/87[%eax] goto L109
  L108 [7]:
  A/71[%eax] := 1
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
	.globl	camlCode__1
	.long	1276
camlCode__1:
	.ascii	"0"
	.space	2
	.byte	2
	.data
	.globl	camlCode__2
	.long	1276
camlCode__2:
	.ascii	"1"
	.space	2
	.byte	2
	.data
	.globl	camlCode__3
	.long	3072
camlCode__3:
	.long	.L100004
	.long	49
	.long	19
	.long	2300
.L100004:
	.ascii	"code.ml"
	.byte	0
	.text
	.align	16
	.globl	camlCode__fun_1044
camlCode__fun_1044:
	subl	$8, %esp
.L100:
	movl	8(%ebx), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	0(%esp)
	pushl	4(%esp)
	pushl	4(%esp)
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
	.type	camlCode__fun_1044,@function
	.size	camlCode__fun_1044,.-camlCode__fun_1044
	.text
	.align	16
	.globl	camlCode__f_1032
camlCode__f_1032:
	subl	$8, %esp
.L104:
	movl	%eax, %esi
	movl	8(%ebx), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	0(%esp)
	pushl	4(%esp)
	pushl	4(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	0(%esp)
.L105:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L106
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	0(%esp)
	faddl	(%esi)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L106:	call	caml_call_gc
.L107:	jmp	.L105
	.type	camlCode__f_1032,@function
	.size	camlCode__f_1032,.-camlCode__f_1032
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$40, %esp
.L119:
	movl	$camlSys, %eax
	movl	(%eax), %ecx
	movl	$3, %ebx
	movl	-4(%ecx), %eax
	shrl	$9, %eax
	cmpl	%ebx, %eax
	jbe	.L120
	movl	-2(%ecx, %ebx, 2), %ebx
	movl	$camlCode__1, %eax
	pushl	%eax
	pushl	%ebx
	call	caml_string_notequal
	addl	$8, %esp
	cmpl	$1, %eax
	je	.L112
	movl	$camlCode__2, %eax
	pushl	%eax
	pushl	%ebx
	call	caml_string_notequal
	addl	$8, %esp
	cmpl	$1, %eax
	je	.L118
	movl	$caml_exn_Assert_failure, %ecx
	movl	$camlCode__3, %ebx
.L121:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L122
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	%ecx, (%eax)
	movl	%ebx, 4(%eax)
	movl	caml_exception_pointer, %esp
	popl    caml_exception_pointer
	ret
	.align	16
.L118:
	movl	$1, %ebx
	movl	$20000001, %eax
	cmpl	%eax, %ebx
	jg	.L108
	movl	%eax, 4(%esp)
	movl	%ebx, 0(%esp)
.L113:
.L124:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L125
	leal	4(%eax), %ecx
	movl	%ecx, 20(%esp)
	movl	$3319, -4(%ecx)
	movl	$camlCode__fun_1044, (%ecx)
	movl	$3, 4(%ecx)
	movl	%ebx, 8(%ecx)
	leal	16(%ecx), %eax
	movl	%eax, 8(%esp)
	movl	$1270, -4(%eax)
	movl	%ecx, (%eax)
	movl	$1, %ebx
	movl	$21, %eax
	movl	%ebx, 12(%esp)
	movl	%eax, 16(%esp)
	cmpl	%eax, %ebx
	jg	.L114
.L115:
	sarl	$1, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	fstpl	24(%esp)
	movl	8(%esp), %ebx
	pushl	%ebx
	call	caml_obj_tag
	addl	$4, %esp
	movl	%eax, %ecx
	movl	$501, %eax
	cmpl	%eax, %ecx
	sete	%al
	movzbl	%al, %eax
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L117
	movl	20(%esp), %ebx
	jmp	.L116
	.align	16
.L117:
	movl	$493, %eax
	cmpl	%eax, %ecx
	sete	%al
	movzbl	%al, %eax
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L116
	movl	%ebx, %eax
	call	camlCamlinternalLazy__force_lazy_block_1033
.L127:
	movl	%eax, %ebx
.L116:
.L128:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L129
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	24(%esp)
	faddl	(%ebx)
	fstpl	(%eax)
	movl	12(%esp), %ebx
	movl	%ebx, %ecx
	addl	$2, %ebx
	movl	%ebx, 12(%esp)
	movl	16(%esp), %eax
	cmpl	%eax, %ecx
	jne	.L115
.L114:
	movl	0(%esp), %ebx
	movl	%ebx, %ecx
	addl	$2, %ebx
	movl	%ebx, 0(%esp)
	movl	4(%esp), %eax
	cmpl	%eax, %ecx
	jne	.L113
	jmp	.L108
	.align	16
.L112:
	movl	$1, %ebp
	movl	$20000001, %eax
	cmpl	%eax, %ebp
	jg	.L108
	movl	%eax, 0(%esp)
.L109:
.L131:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L132
	leal	4(%eax), %esi
	movl	$3319, -4(%esi)
	movl	$camlCode__f_1032, (%esi)
	movl	$3, 4(%esi)
	movl	%ebp, 8(%esi)
	movl	$1, %ebx
	movl	$21, %edi
	cmpl	%edi, %ebx
	jg	.L110
.L111:
	movl	%ebx, %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	32(%esp)
	movl	8(%esi), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	24(%esp)
	pushl	28(%esp)
	pushl	28(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	24(%esp)
.L134:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L135
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	32(%esp)
	faddl	24(%esp)
	fstpl	(%eax)
	movl	%ebx, %eax
	addl	$2, %ebx
	cmpl	%edi, %eax
	jne	.L111
.L110:
	movl	%ebp, %ebx
	addl	$2, %ebp
	movl	0(%esp), %eax
	cmpl	%eax, %ebx
	jne	.L109
.L108:
	movl	$1, %eax
	addl	$40, %esp
	ret
.L135:	call	caml_call_gc
.L136:	jmp	.L134
.L132:	call	caml_call_gc
.L133:	jmp	.L131
.L129:	call	caml_call_gc
.L130:	jmp	.L128
.L125:	call	caml_call_gc
.L126:	jmp	.L124
.L122:	call	caml_call_gc
.L123:	jmp	.L121
.L120:	call	caml_ml_array_bound_error
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
	.long	.L136
	.word	44
	.word	1
	.word	9
	.align	4
	.long	.L133
	.word	44
	.word	0
	.align	4
	.long	.L130
	.word	44
	.word	3
	.word	8
	.word	20
	.word	3
	.align	4
	.long	.L127
	.word	44
	.word	2
	.word	8
	.word	20
	.align	4
	.long	.L126
	.word	44
	.word	0
	.align	4
	.long	.L123
	.word	44
	.word	2
	.word	3
	.word	5
	.align	4
	.long	.L107
	.word	12
	.word	1
	.word	9
	.align	4
	.long	.L103
	.word	12
	.word	0
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

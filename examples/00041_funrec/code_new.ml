

let f list =
  let n = ref 0 in
  let rec iter l =
    match l with
	[] -> !n
      | x :: tail -> n := !n + x; iter tail
  in
    iter list


let g list =
  let rec iterf sum l =
     match l with
      [] -> sum > 0.
    | x :: tail -> 
        iterf (sum +. x) tail
  in
  iterf 0. list
(*
-drawlambda
(seq
  (let
    (f/1031
       (function list/1032
         (let (n/1033 (makemutable 0 0))
           (letrec
             (iter/1034
                (function l/1035
                  (if l/1035
                    (let (tail/1037 (field 1 l/1035) x/1036 (field 0 l/1035))
                      (seq
                        (setfield_imm 0 n/1033 (+ (field 0 n/1033) x/1036))
                        (apply iter/1034 tail/1037)))
                    (field 0 n/1033))))
             (apply iter/1034 list/1032)))))
    (setfield_imm 0 (global Code!) f/1031))
  (let
    (g/1038
       (function list/1039
         (letrec
           (iterf/1040
              (function sum/1041 l/1042
                (if l/1042
                  (let (tail/1044 (field 1 l/1042) x/1043 (field 0 l/1042))
                    (apply iterf/1040 (+. sum/1041 x/1043) tail/1044))
                  (>. sum/1041 0.))))
           (apply iterf/1040 0. list/1039))))
    (setfield_imm 1 (global Code!) g/1038))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1038 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function iter/1034 is known
	Ident used 3 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iterf/1040 is known
	Ident used 0 times
	Ident applied 0 times
	Ident tailed 0 times
	[GOOD] not used
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Anonymous function
Function temp/1090 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dlambda
(seq
  (let
    (f/1031
       (function list/1032
         (let (n/1033 (makemutable 0 0))
           (letrec
             (iter/1034
                (function l/1035
                  (if l/1035
                    (seq
                      (setfield_imm 0 n/1033
                        (+ (field 0 n/1033) (field 0 l/1035)))
                      (apply iter/1034 (field 1 l/1035)))
                    (field 0 n/1033))))
             (apply iter/1034 list/1032)))))
    (setfield_imm 0 (global Code!) f/1031))
  (let
    (g/1038
       (function list/1039
         (letrec
           (iterf/1040
              (function sum/1041 l/1042
                (if l/1042
                  (apply iterf/1040 (+. sum/1041 (field 0 l/1042))
                    (field 1 l/1042))
                  (>. sum/1041 0.))))
           (apply iterf/1040 0. list/1039))))
    (setfield_imm 1 (global Code!) g/1038))
  0a)
checking tailcall on iterf/1040
checking tailcall on iter/1034
stats_rec_removed : 2
(iter_1034) (iterf_1040) 
stats_tailcall_removed : 2
(iter_1034) (iterf_1040) 
stats_rec_removed : 0

stats_tailcall_removed : 0

pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1038 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function iter/1034 is known
	Ident used 3 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iterf/1040 is known
	Ident used 0 times
	Ident applied 0 times
	Ident tailed 0 times
	[GOOD] not used
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Anonymous function
Function temp/1090 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dlambda2
*** After TonLambda.optimize:
(seq
  (let
    (f/1031
       (function list/1032
         (let
           (n/1033 (makemutable 0 0)
            iter/1034
              (function l/1054
                (let (l/1035 l/1054)
                  (catch
                    (while 1a
                      (catch
                        (exit 7
                          (if l/1035
                            (seq
                              (setfield_imm 0 n/1033
                                (+ (field 0 n/1033) (field 0 l/1035)))
                              (let (arg/1052 (field 1 l/1035))
                                (seq (assign l/1035 arg/1052) (exit 6))))
                            (field 0 n/1033)))
                       with (6) 0a))
                   with (7 res/1053) res/1053))))
           (apply iter/1034 list/1032))))
    (setfield_imm 0 (global Code!) f/1031))
  (let
    (g/1038
       (function list/1039
         (let
           (iterf/1040
              (function sum/1050 l/1051
                (let (l/1042 l/1051 sum/1041 sum/1050)
                  (catch
                    (while 1a
                      (catch
                        (exit 5
                          (if l/1042
                            (let
                              (arg/1047 (+. sum/1041 (field 0 l/1042))
                               arg/1048 (field 1 l/1042))
                              (seq (assign l/1042 arg/1048)
                                (assign sum/1041 arg/1047) (exit 4)))
                            (>. sum/1041 0.)))
                       with (4) 0a))
                   with (5 res/1049) res/1049))))
           (apply iterf/1040 0. list/1039))))
    (setfield_imm 1 (global Code!) g/1038))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1038 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function iter/1034 is known
	Ident used 3 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iterf/1040 is known
	Ident used 0 times
	Ident applied 0 times
	Ident tailed 0 times
	[GOOD] not used
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Anonymous function
Function temp/1090 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dclosure
*** After Closure.intro:
(seq
  (let
    (f/1031
       (closure (camlCode__f_1031(1)  list/1032
                  (let
                    (n/1033 (makemutable 0 0)
                     iter/1034
                       (closure (camlCode__iter_1034(1+c)  l/1054 env/1057
                                  (let (l/1035[Variable] l/1054)
                                    (catch
                                      (while 1a
                                        (catch
                                          (exit 7
                                            (if l/1035
                                              (seq
                                                (setfield_imm 0
                                                  (field 2 env/1057)
                                                  (+
                                                    (field 0
                                                      (field 2 env/1057))
                                                    (field 0 l/1035)))
                                                (let
                                                  (arg/1052 (field 1 l/1035))
                                                  (seq
                                                    (assign l/1035 arg/1052)
                                                    (exit 6))))
                                              (field 0 (field 2 env/1057))))
                                         with (6) 0a))
                                     with (7 res/1053) res/1053))) {2} 
                                                                   n/1033)
                     l/1058[Variable] list/1032)
                    (catch
                      (while 1a
                        (catch
                          (exit 7
                            (if l/1058
                              (seq
                                (setfield_imm 0 (field 2 iter/1034)
                                  (+ (field 0 (field 2 iter/1034))
                                    (field 0 l/1058)))
                                (let (arg/1059 (field 1 l/1058))
                                  (seq (assign l/1058 arg/1059) (exit 6))))
                              (field 0 (field 2 iter/1034))))
                         with (6) 0a))
                     with (7 res/1053) res/1053))) {2} ))
    (setfield_imm 0 (global camlCode!) f/1031))
  (let
    (g/1038
       (closure (camlCode__g_1038(1)  list/1039
                  (let
                    (iterf/1040
                       (closure (camlCode__iterf_1040(2)  sum/1050 l/1051
                                  (let
                                    (l/1042[Variable] l/1051
                                     sum/1041[Variable] sum/1050)
                                    (catch
                                      (while 1a
                                        (catch
                                          (exit 5
                                            (if l/1042
                                              (let
                                                (arg/1047
                                                   (+. sum/1041
                                                     (field 0 l/1042))
                                                 arg/1048 (field 1 l/1042))
                                                (seq (assign l/1042 arg/1048)
                                                  (assign sum/1041 arg/1047)
                                                  (exit 4)))
                                              (>. sum/1041 0.)))
                                         with (4) 0a))
                                     with (5 res/1049) res/1049))) {3} )
                     l/1062[Variable] list/1039
                     sum/1063[Variable] 0.)
                    (catch
                      (while 1a
                        (catch
                          (exit 5
                            (if l/1062
                              (let
                                (arg/1064 (+. sum/1063 (field 0 l/1062))
                                 arg/1065 (field 1 l/1062))
                                (seq (assign l/1062 arg/1065)
                                  (assign sum/1063 arg/1064) (exit 4)))
                              (>. sum/1063 0.)))
                         with (4) 0a))
                     with (5 res/1049) res/1049))) {2} ))
    (setfield_imm 1 (global camlCode!) g/1038))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1038 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function iter/1034 is known
	Ident used 3 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iterf/1040 is known
	Ident used 0 times
	Ident applied 0 times
	Ident tailed 0 times
	[GOOD] not used
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Anonymous function
Function temp/1090 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dclosure2
pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1038 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function iter/1034 is known
	Ident used 3 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iterf/1040 is known
	Ident used 0 times
	Ident applied 0 times
	Ident tailed 0 times
	[GOOD] not used
	Function applied 0 times
	Function is closed
*** After TonClosure.optimize:
(let (f/1031 (closure (camlCode__f_1031(1)  list/1032 (let (n/1033[Variable] 0 l/1058[Variable] list/1032) (catch (while 1a (catch (let (temp/1074 (if l/1058 (let (temp/1078 n/1033 temp/1080 (field 0 l/1058) temp/1077 (+ temp/1078 temp/1080)) (seq (assign n/1033 temp/1077) (let (arg/1059 (field 1 l/1058)) (seq (assign l/1058 arg/1059) (exit 6))))) n/1033)) (exit 7 temp/1074)) with (6) 0a)) with (7 res/1053) res/1053))) {2} ) temp/1073 (global camlCode!))
  (seq (setfield_imm 0 temp/1073 f/1031)
    (let (g/1038 (seq (setfield_imm 2 (global camlCode!) (closure (camlCode__iterf_1040(2)  sum/1050 l/1051 (let (l/1042[Variable] l/1051 sum/1041[Variable] sum/1050) (catch (while 1a (catch (let (temp/1070 (if l/1042 (let (temp/1072 (field 0 l/1042) arg/1047 (+. sum/1041 temp/1072) arg/1048 (field 1 l/1042)) (seq (assign l/1042 arg/1048) (assign sum/1041 arg/1047) (exit 4))) (let (temp/1071 0.) (>. sum/1041 temp/1071)))) (exit 5 temp/1070)) with (4) 0a)) with (5 res/1049) res/1049))) {3} )) (closure (camlCode__g_1038(1)  list/1039 (let (l/1062[Variable] list/1039 sum/1063[Variable] 0.) (catch (while 1a (catch (let (temp/1067 (if l/1062 (let (temp/1069 (field 0 l/1062) arg/1064 (+. sum/1063 temp/1069) arg/1065 (field 1 l/1062)) (seq (assign l/1062 arg/1065) (assign sum/1063 arg/1064) (exit 4))) (let (temp/1068 0.) (>. sum/1063 temp/1068)))) (exit 5 temp/1067)) with (4) 0a)) with (5 res/1049) res/1049))) {2} )) temp/1066 (global camlCode!)) (seq (setfield_imm 1 temp/1066 g/1038) 0a))))
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Anonymous function
Function temp/1090 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed

-dcmm
pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1038 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function iter/1034 is known
	Ident used 3 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iterf/1040 is known
	Ident used 0 times
	Ident applied 0 times
	Ident tailed 0 times
	[GOOD] not used
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Anonymous function
Function temp/1090 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
(data int 3072 global "camlCode" "camlCode": skip 12)
(data int 2295 "camlCode__1": addr "camlCode__g_1038" int 3)
(data int 3319 "camlCode__2": addr "caml_curry2" int 5 addr "camlCode__iterf_1040")
(data int 2295 "camlCode__3": addr "camlCode__f_1031" int 3)
(function camlCode__f_1031 (list/1032: addr) (let (n/1033[Variable] 1 l/1058[Variable] list/1032) (catch (loop (catch (let temp/1074 (if (!= l/1058 1) (let (temp/1078 n/1033 temp/1080 (load l/1058) temp/1077 (+ (+ temp/1078 temp/1080) -1)) (assign n/1033 temp/1077) (let arg/1059 (load (+a l/1058 4)) (assign l/1058 arg/1059) (exit 6))) n/1033) (exit 7 temp/1074)) with(6) [])) 1a with(7 res/1053) res/1053)))

(function camlCode__iterf_1040 (sum/1050: addr l/1051: addr) (let (l/1042[Variable] l/1051 sum/1041[Variable] sum/1050) (catch (loop (catch (let temp/1070 (if (!= l/1042 1) (let (temp/1072 (load l/1042) arg/1095 (+f (load float64u sum/1041) (load float64u temp/1072)) arg/1048 (load (+a l/1042 4))) (assign l/1042 arg/1048) (assign sum/1041 (alloc[253] 2301 arg/1095)) (exit 4)) (let temp/1094 0. (+ (<< (>f (load float64u sum/1041) temp/1094) 1) 1))) (exit 5 temp/1070)) with(4) [])) 1a with(5 res/1049) res/1049)))

(function camlCode__g_1038 (list/1039: addr) (let (l/1062[Variable] list/1039 sum/1093[Variable] 0.) (catch (loop (catch (let temp/1067 (if (!= l/1062 1) (let (temp/1069 (load l/1062) arg/1092 (+f sum/1093 (load float64u temp/1069)) arg/1065 (load (+a l/1062 4))) (assign l/1062 arg/1065) (assign sum/1093 arg/1092) (exit 4)) (let temp/1091 0. (+ (<< (>f sum/1093 temp/1091) 1) 1))) (exit 5 temp/1067)) with(4) [])) 1a with(5 res/1049) res/1049)))

(function camlCode__entry () (let (f/1031 "camlCode__3" temp/1073 "camlCode") (store temp/1073 f/1031) (let (g/1038 (seq (let (temp/1089 "camlCode" temp/1090 "camlCode__2") (store (+a temp/1089 8) temp/1090)) "camlCode__1") temp/1066 "camlCode") (store (+a temp/1066 4) g/1038) 1a)))

(data)
-dlinear
pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1038 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function iter/1034 is known
	Ident used 3 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iterf/1040 is known
	Ident used 0 times
	Ident applied 0 times
	Ident tailed 0 times
	[GOOD] not used
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Anonymous function
Function temp/1090 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Before simplify
camlCode__f_1031:
                  list/8[%ebx] := R/0[%eax]
                  n/9[%eax] := 1
                  L101 [0]:
                  if l/10[%ebx] ==s 1 goto L100
                  temp/13[%ecx] := [l/10[%ebx]]
                  temp/14[%eax] := temp/12[%eax] + temp/13[%ecx] + -1
                  arg/15[%ebx] := [l/10[%ebx] + 4]
                  goto L101
                  L100 [0]:
                  return R/0[%eax]
                  *** Linearized code
camlCode__f_1031:
  list/8[%ebx] := R/0[%eax]
  n/9[%eax] := 1
  L101 [3]:
  if l/10[%ebx] ==s 1 goto L100
  temp/13[%ecx] := [l/10[%ebx]]
  temp/14[%eax] := temp/12[%eax] + temp/13[%ecx] + -1
  arg/15[%ebx] := [l/10[%ebx] + 4]
  goto L101
  L100 [2]:
  return R/0[%eax]
  
Before simplify
camlCode__iterf_1040:
                  L104 [0]:
                  if l/10[%ebx] ==s 1 goto L107
                  temp/13[%ecx] := [l/10[%ebx]]
                  R/7[%tos] := float64u[sum/11[%eax]]
                  R/7[%tos] := R/7[%tos] +f float64[temp/13[%ecx]]
                  arg/16[s0] := R/7[%tos]
                  arg/17[%ebx] := [l/10[%ebx] + 4]
                  {l/10[%ebx]* arg/16[s0]}
                  A/18[%eax] := alloc 12
                  [A/18[%eax] + -4] := 2301
                  float64u[A/18[%eax]] := arg/16[s0]
                  goto L104
                  L107 [0]:
                  R/7[%tos] := 0.
                  temp/20[s0] := R/7[%tos]
                  R/7[%tos] := float64u[sum/11[%eax]]
                  if not R/7[%tos] >f temp/20[s0] goto L106
                  I/22[%eax] := 1
                  goto L105
                  L106 [0]:
                  I/23[%eax] := 0
                  L105 [0]:
                  temp/24[%eax] := I/22[%eax]  * 2 + 1
                  L103 [0]:
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__iterf_1040:
  L104 [3]:
  if l/10[%ebx] ==s 1 goto L107
  temp/13[%ecx] := [l/10[%ebx]]
  R/7[%tos] := float64u[sum/11[%eax]]
  R/7[%tos] := R/7[%tos] +f float64[temp/13[%ecx]]
  arg/16[s0] := R/7[%tos]
  arg/17[%ebx] := [l/10[%ebx] + 4]
  {l/10[%ebx]* arg/16[s0]}
  A/18[%eax] := alloc 12
  [A/18[%eax] + -4] := 2301
  float64u[A/18[%eax]] := arg/16[s0]
  goto L104
  L107 [2]:
  R/7[%tos] := 0.
  temp/20[s0] := R/7[%tos]
  R/7[%tos] := float64u[sum/11[%eax]]
  if not R/7[%tos] >f temp/20[s0] goto L106
  I/22[%eax] := 1
  goto L105
  L106 [2]:
  I/23[%eax] := 0
  L105 [3]:
  temp/24[%eax] := I/22[%eax]  * 2 + 1
  L103 [2]:
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__g_1038:
                  R/7[%tos] := 0.
                  sum/11[s1] := R/7[%tos]
                  L113 [0]:
                  if l/9[%eax] ==s 1 goto L116
                  temp/13[%ebx] := [l/9[%eax]]
                  R/7[%tos] := sum/11[s1] +f float64[temp/13[%ebx]]
                  arg/15[s0] := R/7[%tos]
                  arg/16[%eax] := [l/9[%eax] + 4]
                  sum/11[s1] := arg/15[s0]
                  goto L113
                  L116 [0]:
                  R/7[%tos] := 0.
                  temp/18[s0] := R/7[%tos]
                  if not sum/11[s1] >f temp/18[s0] goto L115
                  I/19[%eax] := 1
                  goto L114
                  L115 [0]:
                  I/20[%eax] := 0
                  L114 [0]:
                  temp/21[%eax] := I/19[%eax]  * 2 + 1
                  L112 [0]:
                  return R/0[%eax]
                  *** Linearized code
camlCode__g_1038:
  R/7[%tos] := 0.
  sum/11[s1] := R/7[%tos]
  L113 [3]:
  if l/9[%eax] ==s 1 goto L116
  temp/13[%ebx] := [l/9[%eax]]
  R/7[%tos] := sum/11[s1] +f float64[temp/13[%ebx]]
  arg/15[s0] := R/7[%tos]
  arg/16[%eax] := [l/9[%eax] + 4]
  sum/11[s1] := arg/15[s0]
  goto L113
  L116 [2]:
  R/7[%tos] := 0.
  temp/18[s0] := R/7[%tos]
  if not sum/11[s1] >f temp/18[s0] goto L115
  I/19[%eax] := 1
  goto L114
  L115 [2]:
  I/20[%eax] := 0
  L114 [3]:
  temp/21[%eax] := I/19[%eax]  * 2 + 1
  L112 [2]:
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  f/8[%ebx] := "camlCode__3"
                  temp/9[%eax] := "camlCode"
                  [temp/9[%eax]] := f/8[%ebx]
                  temp/10[%ebx] := "camlCode"
                  temp/11[%eax] := "camlCode__2"
                  [temp/10[%ebx] + 8] := temp/11[%eax]
                  g/12[%ebx] := "camlCode__1"
                  temp/13[%eax] := "camlCode"
                  [temp/13[%eax] + 4] := g/12[%ebx]
                  A/14[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  f/8[%ebx] := "camlCode__3"
  temp/9[%eax] := "camlCode"
  [temp/9[%eax]] := f/8[%ebx]
  temp/10[%ebx] := "camlCode"
  temp/11[%eax] := "camlCode__2"
  [temp/10[%ebx] + 8] := temp/11[%eax]
  g/12[%ebx] := "camlCode__1"
  temp/13[%eax] := "camlCode"
  [temp/13[%eax] + 4] := g/12[%ebx]
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
	.long	3072
	.globl	camlCode
camlCode:
	.space	12
	.data
	.long	2295
camlCode__1:
	.long	camlCode__g_1038
	.long	3
	.data
	.long	3319
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__iterf_1040
	.data
	.long	2295
camlCode__3:
	.long	camlCode__f_1031
	.long	3
	.text
	.align	16
	.globl	camlCode__f_1031
camlCode__f_1031:
.L102:
	movl	%eax, %ebx
	movl	$1, %eax
.L101:
	cmpl	$1, %ebx
	je	.L100
	movl	(%ebx), %ecx
	lea	-1(%eax, %ecx), %eax
	movl	4(%ebx), %ebx
	jmp	.L101
	.align	16
.L100:
	ret
	.type	camlCode__f_1031,@function
	.size	camlCode__f_1031,.-camlCode__f_1031
	.text
	.align	16
	.globl	camlCode__iterf_1040
camlCode__iterf_1040:
	subl	$8, %esp
.L108:
.L104:
	cmpl	$1, %ebx
	je	.L107
	movl	(%ebx), %ecx
	fldl	(%eax)
	faddl	(%ecx)
	fstpl	0(%esp)
	movl	4(%ebx), %ebx
.L109:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L110
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	0(%esp)
	fstpl	(%eax)
	jmp	.L104
	.align	16
.L107:
	fldz
	fstpl	0(%esp)
	fldl	(%eax)
	fcompl	0(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L106
	movl	$1, %eax
	jmp	.L105
	.align	16
.L106:
	xorl	%eax, %eax
.L105:
	lea	1(%eax, %eax), %eax
.L103:
	addl	$8, %esp
	ret
.L110:	call	caml_call_gc
.L111:	jmp	.L109
	.type	camlCode__iterf_1040,@function
	.size	camlCode__iterf_1040,.-camlCode__iterf_1040
	.text
	.align	16
	.globl	camlCode__g_1038
camlCode__g_1038:
	subl	$16, %esp
.L117:
	fldz
	fstpl	8(%esp)
.L113:
	cmpl	$1, %eax
	je	.L116
	movl	(%eax), %ebx
	fldl	8(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
	movl	4(%eax), %eax
	fldl	0(%esp)
	fstpl	8(%esp)
	jmp	.L113
	.align	16
.L116:
	fldz
	fstpl	0(%esp)
	fldl	8(%esp)
	fcompl	0(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L115
	movl	$1, %eax
	jmp	.L114
	.align	16
.L115:
	xorl	%eax, %eax
.L114:
	lea	1(%eax, %eax), %eax
.L112:
	addl	$16, %esp
	ret
	.type	camlCode__g_1038,@function
	.size	camlCode__g_1038,.-camlCode__g_1038
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L118:
	movl	$camlCode__3, %ebx
	movl	$camlCode, %eax
	movl	%ebx, (%eax)
	movl	$camlCode, %ebx
	movl	$camlCode__2, %eax
	movl	%eax, 8(%ebx)
	movl	$camlCode__1, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 4(%eax)
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
	.long	1
	.long	.L111
	.word	12
	.word	1
	.word	3
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

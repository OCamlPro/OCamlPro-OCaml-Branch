(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.
*)

let rec iter1 f l =
  match l with
      [] -> ()
    | a::l -> f a; iter1 f l

let computed1 =
  let list1 = ref [] in
  iter1 (fun x -> list1 := x :: !list1) [1; 2; 3; 4; 5];
    !list1

let computed2 =
  let list1 = ref [] in
  iter1 (fun (x,y) -> list1 := x :: !list1) [1,2; 2,3; 3,3; 4,5; 5,6];
    !list1

(*
-drawlambda
(seq
  (letrec
    (iter1/1031
       (function f/1032 l/1033
         (if l/1033
           (let (l/1035 (field 1 l/1033) a/1034 (field 0 l/1033))
             (seq (apply f/1032 a/1034) (apply iter1/1031 f/1032 l/1035)))
           0a)))
    (setfield_imm 0 (global Code!) iter1/1031))
  (let
    (computed1/1036
       (let (list1/1037 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function x/1038
               (setfield_ptr 0 list1/1037
                 (makeblock 0 x/1038 (field 0 list1/1037))))
             [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
           (field 0 list1/1037))))
    (setfield_imm 1 (global Code!) computed1/1036))
  (let
    (computed2/1039
       (let (list1/1040 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function (param/1046, param/1047)
               (let (y/1042 param/1047 x/1041 param/1046)
                 (setfield_ptr 0 list1/1040
                   (makeblock 0 x/1041 (field 0 list1/1040)))))
             [0:
              [0: 1 2]
              [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]])
           (field 0 list1/1040))))
    (setfield_imm 2 (global Code!) computed2/1039))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1056 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1063 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dlambda
(seq
  (letrec
    (iter1/1031
       (function f/1032 l/1033
         (if l/1033
           (seq (apply f/1032 (field 0 l/1033))
             (apply iter1/1031 f/1032 (field 1 l/1033)))
           0a)))
    (setfield_imm 0 (global Code!) iter1/1031))
  (let
    (computed1/1036
       (let (list1/1037 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function x/1038
               (setfield_ptr 0 list1/1037
                 (makeblock 0 x/1038 (field 0 list1/1037))))
             [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
           (field 0 list1/1037))))
    (setfield_imm 1 (global Code!) computed1/1036))
  (let
    (computed2/1039
       (let (list1/1040 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function (param/1046, param/1047)
               (setfield_ptr 0 list1/1040
                 (makeblock 0 param/1046 (field 0 list1/1040))))
             [0:
              [0: 1 2]
              [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]])
           (field 0 list1/1040))))
    (setfield_imm 2 (global Code!) computed2/1039))
  0a)
checking tailcall on iter1/1031
stats_rec_removed : 1
(iter1_1031) 
stats_tailcall_removed : 1
(iter1_1031) 
stats_rec_removed : 0

stats_tailcall_removed : 0

pp_get_margin 78
pp_get_max_indent 68
Function f/1056 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1063 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dlambda2
*** After TonLambda.optimize:
(seq
  (let
    (iter1/1031
       (function f/1050 l/1051
         (let (l/1033 l/1051 f/1032 f/1050)
           (catch
             (while 1a
               (catch
                 (exit 7
                   (if l/1033
                     (seq (apply f/1032 (field 0 l/1033))
                       (let (arg/1048 (field 1 l/1033))
                         (seq (assign l/1033 arg/1048) (exit 6))))
                     0a))
                with (6) 0a))
            with (7 res/1049) res/1049))))
    (setfield_imm 0 (global Code!) iter1/1031))
  (let
    (computed1/1036
       (let (list1/1037 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function x/1038
               (setfield_ptr 0 list1/1037
                 (makeblock 0 x/1038 (field 0 list1/1037))))
             [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
           (field 0 list1/1037))))
    (setfield_imm 1 (global Code!) computed1/1036))
  (let
    (computed2/1039
       (let (list1/1040 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function (param/1046, param/1047)
               (setfield_ptr 0 list1/1040
                 (makeblock 0 param/1046 (field 0 list1/1040))))
             [0:
              [0: 1 2]
              [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]])
           (field 0 list1/1040))))
    (setfield_imm 2 (global Code!) computed2/1039))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1056 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1063 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dclosure
*** After Closure.intro:
(seq
  (let
    (iter1/1031
       (closure (camlCode__iter1_1031(2)  f/1050 l/1051
                  (let (l/1033[Variable] l/1051 f/1032[Variable] f/1050)
                    (catch
                      (while 1a
                        (catch
                          (exit 7
                            (if l/1033
                              (seq (apply f/1032 (field 0 l/1033))
                                (let (arg/1048 (field 1 l/1033))
                                  (seq (assign l/1033 arg/1048) (exit 6))))
                              0a))
                         with (6) 0a))
                     with (7 res/1049) res/1049))) {3} ))
    (setfield_imm 0 (global camlCode!) iter1/1031))
  (let
    (computed1/1036
       (let (list1/1037 (makemutable 0 0a))
         (seq
           (let
             (f/1056
                (closure (camlCode__fun_1053(1+c)  x/1038 env/1055
                           (setfield_ptr 0 (field 2 env/1055)
                             (makeblock 0 x/1038
                               (field 0 (field 2 env/1055))))) {2} 
                                                               list1/1037)
              l/1057[Variable] [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]
              f/1058[Variable] f/1056)
             (catch
               (while 1a
                 (catch
                   (exit 7
                     (if l/1057
                       (seq (apply f/1058 (field 0 l/1057))
                         (let (arg/1059 (field 1 l/1057))
                           (seq (assign l/1057 arg/1059) (exit 6))))
                       0a))
                  with (6) 0a))
              with (7 res/1049) res/1049))
           (field 0 list1/1037))))
    (setfield_imm 1 (global camlCode!) computed1/1036))
  (let
    (computed2/1039
       (let (list1/1040 (makemutable 0 0a))
         (seq
           (let
             (f/1063
                (closure (camlCode__fun_1060(-2+c)  param/1046 param/1047
                           env/1062
                           (setfield_ptr 0 (field 3 env/1062)
                             (makeblock 0 param/1046
                               (field 0 (field 3 env/1062))))) {3} 
                                                               list1/1040)
              l/1064[Variable]
                [0:
                 [0: 1 2]
                 [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]]
              f/1065[Variable] f/1063)
             (catch
               (while 1a
                 (catch
                   (exit 7
                     (if l/1064
                       (seq (apply f/1065 (field 0 l/1064))
                         (let (arg/1066 (field 1 l/1064))
                           (seq (assign l/1064 arg/1066) (exit 6))))
                       0a))
                  with (6) 0a))
              with (7 res/1049) res/1049))
           (field 0 list1/1040))))
    (setfield_imm 2 (global camlCode!) computed2/1039))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1056 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1063 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dclosure2
pp_get_margin 78
pp_get_max_indent 68
Function f/1056 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1063 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
*** After TonClosure.optimize:
(let (iter1/1031 (closure (camlCode__iter1_1031(2)  f/1050 l/1051 (let (l/1033[Variable] l/1051) (catch (while 1a (catch (let (temp/1084 (if l/1033 (let (temp/1085 (field 0 l/1033)) (seq (apply f/1050 temp/1085) (let (arg/1048 (field 1 l/1033)) (seq (assign l/1033 arg/1048) (exit 6))))) 0a)) (exit 7 temp/1084)) with (6) 0a)) with (7 res/1049) res/1049))) {3} ) temp/1083 (global camlCode!))
  (seq (setfield_imm 0 temp/1083 iter1/1031)
    (let (list1/1037[Variable] 0a computed1/1036 (seq (let (l/1057[Variable] [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]) (catch (while 1a (catch (let (temp/1076 (if l/1057 (let (temp/1077 (field 0 l/1057)) (seq (assign list1/1037 (makeblock 0 temp/1077 list1/1037)) (let (arg/1059 (field 1 l/1057)) (seq (assign l/1057 arg/1059) (exit 6))))) 0a)) (exit 7 temp/1076)) with (6) 0a)) with (7 res/1049) res/1049)) list1/1037) temp/1075 (global camlCode!))
      (seq (setfield_imm 1 temp/1075 computed1/1036) (let (list1/1040[Variable] 0a computed2/1039 (seq (let (l/1064[Variable] [0: [0: 1 2] [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]]) (catch (while 1a (catch (let (temp/1068 (if l/1064 (let (temp/1069 (field 0 l/1064)) (seq (seq (field 1 temp/1069) (let (param/1088 (field 0 temp/1069)) (assign list1/1040 (makeblock 0 param/1088 list1/1040)))) (let (arg/1066 (field 1 l/1064)) (seq (assign l/1064 arg/1066) (exit 6))))) 0a)) (exit 7 temp/1068)) with (6) 0a)) with (7 res/1049) res/1049)) list1/1040) temp/1067 (global camlCode!)) (seq (setfield_imm 2 temp/1067 computed2/1039) 0a))))))
pp_get_margin 1000
pp_get_max_indent 900
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed

-dcmm
pp_get_margin 78
pp_get_max_indent 68
Function f/1056 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1063 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
(data int 3072 global "camlCode" "camlCode": skip 12)
(data int 3319 "camlCode__3": addr "caml_curry2" int 5 addr "camlCode__iter1_1031")
(data global "camlCode__1" int 2048 "camlCode__1": int 3 addr L13 int 2048 L13: int 5 addr L14 int 2048 L14: int 7 addr L15 int 2048 L15: int 9 addr L16 int 2048 L16: int 11 int 1)
(data global "camlCode__2" int 2048 "camlCode__2": addr L4 addr L5 int 2048 L5: addr L6 addr L7 int 2048 L7: addr L8 addr L9 int 2048 L9: addr L10 addr L11 int 2048 L11: addr L12 int 1 int 2048 L12: int 11 int 13 int 2048 L10: int 9 int 11 int 2048 L8: int 7 int 7 int 2048 L6: int 5 int 7 int 2048 L4: int 3 int 5)
(function camlCode__iter1_1031 (f/1050: addr l/1051: addr) (let l/1033[Variable] l/1051 (catch (loop (catch (let temp/1084 (if (!= l/1033 1) (let temp/1085 (load l/1033) (app (load f/1050) temp/1085 f/1050 unit) (let arg/1048 (load (+a l/1033 4)) (assign l/1033 arg/1048) (exit 6))) 1a) (exit 7 temp/1084)) with(6) [])) 1a with(7 res/1049) res/1049)))

(function camlCode__entry ()
 (let (iter1/1031 "camlCode__3" temp/1083 "camlCode") (store temp/1083 iter1/1031)
   (let (list1/1037[Variable] 1a computed1/1036 (seq (let l/1057[Variable] "camlCode__1" (catch (loop (catch (let temp/1076 (if (!= l/1057 1) (let temp/1077 (load l/1057) (let temp/1090 (alloc[0] 2048 temp/1077 list1/1037) (assign list1/1037 temp/1090)) (let arg/1059 (load (+a l/1057 4)) (assign l/1057 arg/1059) (exit 6))) 1a) (exit 7 temp/1076)) with(6) [])) with(7 res/1049) res/1049 [])) list1/1037) temp/1075 "camlCode") (store (+a temp/1075 4) computed1/1036) (let (list1/1040[Variable] 1a computed2/1039 (seq (let l/1064[Variable] "camlCode__2" (catch (loop (catch (let temp/1068 (if (!= l/1064 1) (let temp/1069 (load l/1064) (load (+a temp/1069 4)) [] (let (param/1088 (load temp/1069) temp/1089 (alloc[0] 2048 param/1088 list1/1040)) (assign list1/1040 temp/1089)) (let arg/1066 (load (+a l/1064 4)) (assign l/1064 arg/1066) (exit 6))) 1a) (exit 7 temp/1068)) with(6) [])) with(7 res/1049) res/1049 [])) list1/1040) temp/1067 "camlCode") (store (+a temp/1067 8) computed2/1039) 1a))))

(data)
-dlinear
pp_get_margin 78
pp_get_max_indent 68
Function f/1056 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function f/1063 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function iter1/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Before simplify
camlCode__iter1_1031:
                  spilled-f/18[s0] := f/8[%eax] (spill)
                  spilled-l/17[s1] := l/10[%ebx] (spill)
                  L101 [0]:
                  if l/10[%ebx] ==s 1 goto L102
                  temp/12[%eax] := [l/10[%ebx]]
                  f/19[%ebx] := spilled-f/18[s0] (reload)
                  A/13[%ecx] := [f/19[%ebx]]
                  {spilled-l/17[s1]* spilled-f/18[s0]*}
                  call A/13[%ecx] R/0[%eax] R/1[%ebx]
                  l/10[%ebx] := spilled-l/17[s1] (reload)
                  arg/14[%ebx] := [l/10[%ebx] + 4]
                  spilled-l/17[s1] := l/10[%ebx] (spill)
                  goto L101
                  L102 [0]:
                  temp/15[%eax] := 1
                  L100 [0]:
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__iter1_1031:
  spilled-f/18[s0] := f/8[%eax] (spill)
  spilled-l/17[s1] := l/10[%ebx] (spill)
  L101 [3]:
  if l/10[%ebx] ==s 1 goto L102
  temp/12[%eax] := [l/10[%ebx]]
  f/19[%ebx] := spilled-f/18[s0] (reload)
  A/13[%ecx] := [f/19[%ebx]]
  {spilled-l/17[s1]* spilled-f/18[s0]*}
  call A/13[%ecx] R/0[%eax] R/1[%ebx]
  l/10[%ebx] := spilled-l/17[s1] (reload)
  arg/14[%ebx] := [l/10[%ebx] + 4]
  spilled-l/17[s1] := l/10[%ebx] (spill)
  goto L101
  L102 [2]:
  temp/15[%eax] := 1
  L100 [2]:
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  iter1/8[%ebx] := "camlCode__3"
                  temp/9[%eax] := "camlCode"
                  [temp/9[%eax]] := iter1/8[%ebx]
                  list1/10[%ebx] := 1
                  l/11[%ecx] := "camlCode__1"
                  L109 [0]:
                  if l/11[%ecx] ==s 1 goto L110
                  temp/13[%edx] := [l/11[%ecx]]
                  {list1/10[%ebx]* l/11[%ecx]* temp/13[%edx]*}
                  temp/14[%eax] := alloc 12
                  [temp/14[%eax] + -4] := 2048
                  [temp/14[%eax]] := temp/13[%edx]
                  [temp/14[%eax] + 4] := list1/10[%ebx]
                  list1/10[%ebx] := temp/14[%eax]
                  arg/15[%ecx] := [l/11[%ecx] + 4]
                  goto L109
                  L110 [0]:
                  temp/16[%eax] := 1
                  L108 [0]:
                  temp/18[%eax] := "camlCode"
                  [temp/18[%eax] + 4] := computed1/17[%ebx]
                  list1/19[%ebx] := 1
                  l/20[%ecx] := "camlCode__2"
                  L106 [0]:
                  if l/20[%ecx] ==s 1 goto L107
                  temp/22[%edx] := [l/20[%ecx]]
                  A/23[%eax] := [temp/22[%edx] + 4]
                  param/24[%edx] := [temp/22[%edx]]
                  {list1/19[%ebx]* l/20[%ecx]* param/24[%edx]*}
                  temp/25[%eax] := alloc 12
                  [temp/25[%eax] + -4] := 2048
                  [temp/25[%eax]] := param/24[%edx]
                  [temp/25[%eax] + 4] := list1/19[%ebx]
                  list1/19[%ebx] := temp/25[%eax]
                  arg/26[%ecx] := [l/20[%ecx] + 4]
                  goto L106
                  L107 [0]:
                  temp/27[%eax] := 1
                  L105 [0]:
                  temp/29[%eax] := "camlCode"
                  [temp/29[%eax] + 8] := computed2/28[%ebx]
                  A/30[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  iter1/8[%ebx] := "camlCode__3"
  temp/9[%eax] := "camlCode"
  [temp/9[%eax]] := iter1/8[%ebx]
  list1/10[%ebx] := 1
  l/11[%ecx] := "camlCode__1"
  L109 [3]:
  if l/11[%ecx] ==s 1 goto L110
  temp/13[%edx] := [l/11[%ecx]]
  {list1/10[%ebx]* l/11[%ecx]* temp/13[%edx]*}
  temp/14[%eax] := alloc 12
  [temp/14[%eax] + -4] := 2048
  [temp/14[%eax]] := temp/13[%edx]
  [temp/14[%eax] + 4] := list1/10[%ebx]
  list1/10[%ebx] := temp/14[%eax]
  arg/15[%ecx] := [l/11[%ecx] + 4]
  goto L109
  L110 [2]:
  temp/16[%eax] := 1
  L108 [2]:
  temp/18[%eax] := "camlCode"
  [temp/18[%eax] + 4] := computed1/17[%ebx]
  list1/19[%ebx] := 1
  l/20[%ecx] := "camlCode__2"
  L106 [3]:
  if l/20[%ecx] ==s 1 goto L107
  temp/22[%edx] := [l/20[%ecx]]
  A/23[%eax] := [temp/22[%edx] + 4]
  param/24[%edx] := [temp/22[%edx]]
  {list1/19[%ebx]* l/20[%ecx]* param/24[%edx]*}
  temp/25[%eax] := alloc 12
  [temp/25[%eax] + -4] := 2048
  [temp/25[%eax]] := param/24[%edx]
  [temp/25[%eax] + 4] := list1/19[%ebx]
  list1/19[%ebx] := temp/25[%eax]
  arg/26[%ecx] := [l/20[%ecx] + 4]
  goto L106
  L107 [2]:
  temp/27[%eax] := 1
  L105 [2]:
  temp/29[%eax] := "camlCode"
  [temp/29[%eax] + 8] := computed2/28[%ebx]
  A/30[%eax] := 1
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
	.long	3072
	.globl	camlCode
camlCode:
	.space	12
	.data
	.long	3319
camlCode__3:
	.long	caml_curry2
	.long	5
	.long	camlCode__iter1_1031
	.data
	.globl	camlCode__1
	.long	2048
camlCode__1:
	.long	3
	.long	.L100013
	.long	2048
.L100013:
	.long	5
	.long	.L100014
	.long	2048
.L100014:
	.long	7
	.long	.L100015
	.long	2048
.L100015:
	.long	9
	.long	.L100016
	.long	2048
.L100016:
	.long	11
	.long	1
	.data
	.globl	camlCode__2
	.long	2048
camlCode__2:
	.long	.L100004
	.long	.L100005
	.long	2048
.L100005:
	.long	.L100006
	.long	.L100007
	.long	2048
.L100007:
	.long	.L100008
	.long	.L100009
	.long	2048
.L100009:
	.long	.L100010
	.long	.L100011
	.long	2048
.L100011:
	.long	.L100012
	.long	1
	.long	2048
.L100012:
	.long	11
	.long	13
	.long	2048
.L100010:
	.long	9
	.long	11
	.long	2048
.L100008:
	.long	7
	.long	7
	.long	2048
.L100006:
	.long	5
	.long	7
	.long	2048
.L100004:
	.long	3
	.long	5
	.text
	.align	16
	.globl	camlCode__iter1_1031
camlCode__iter1_1031:
	subl	$8, %esp
.L103:
	movl	%eax, 0(%esp)
	movl	%ebx, 4(%esp)
.L101:
	cmpl	$1, %ebx
	je	.L102
	movl	(%ebx), %eax
	movl	0(%esp), %ebx
	movl	(%ebx), %ecx
	call	*%ecx
.L104:
	movl	4(%esp), %ebx
	movl	4(%ebx), %ebx
	movl	%ebx, 4(%esp)
	jmp	.L101
	.align	16
.L102:
	movl	$1, %eax
.L100:
	addl	$8, %esp
	ret
	.type	camlCode__iter1_1031,@function
	.size	camlCode__iter1_1031,.-camlCode__iter1_1031
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L111:
	movl	$camlCode__3, %ebx
	movl	$camlCode, %eax
	movl	%ebx, (%eax)
	movl	$1, %ebx
	movl	$camlCode__1, %ecx
.L109:
	cmpl	$1, %ecx
	je	.L110
	movl	(%ecx), %edx
.L112:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L113
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	%edx, (%eax)
	movl	%ebx, 4(%eax)
	movl	%eax, %ebx
	movl	4(%ecx), %ecx
	jmp	.L109
	.align	16
.L110:
	movl	$1, %eax
.L108:
	movl	$camlCode, %eax
	movl	%ebx, 4(%eax)
	movl	$1, %ebx
	movl	$camlCode__2, %ecx
.L106:
	cmpl	$1, %ecx
	je	.L107
	movl	(%ecx), %edx
	movl	4(%edx), %eax
	movl	(%edx), %edx
.L115:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L116
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	%edx, (%eax)
	movl	%ebx, 4(%eax)
	movl	%eax, %ebx
	movl	4(%ecx), %ecx
	jmp	.L106
	.align	16
.L107:
	movl	$1, %eax
.L105:
	movl	$camlCode, %eax
	movl	%ebx, 8(%eax)
	movl	$1, %eax
	ret
.L116:	call	caml_call_gc
.L117:	jmp	.L115
.L113:	call	caml_call_gc
.L114:	jmp	.L112
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
	.long	3
	.long	.L117
	.word	4
	.word	3
	.word	7
	.word	5
	.word	3
	.align	4
	.long	.L114
	.word	4
	.word	3
	.word	7
	.word	5
	.word	3
	.align	4
	.long	.L104
	.word	12
	.word	2
	.word	0
	.word	4
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

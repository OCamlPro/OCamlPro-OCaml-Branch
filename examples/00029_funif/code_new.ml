(*
  In [sum0], we allocate the closure
*)

let list = [1;2;3;4;5;6;7;8;9]

let rec map f l =
  match l with
    [] -> []
  | x :: tail -> 
      let xx = f x in
      xx :: (map f tail)
  
let sum0 = 
  map (fun x ->
      Printf.printf "x = %d\n" x;
      Printf.printf "x = %d\n" x;
      Printf.printf "x = %d\n" x;
      Printf.printf "x = %d\n" x;
      Printf.printf "x = %d\n" x;
      Printf.printf "x = %d\n" x;
      x
  )  list

let sum1 =
  match list with
  | [] -> []
  | _ -> map (fun x ->
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          x
          )  list

let sum2 =
  List.iter (fun x ->
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          Printf.printf "x = %d\n" x;
          )  list

(*
-drawlambda
(seq
  (let
    (list/1030
       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 [0: 7 [0: 8 [0: 9 0a]]]]]]]]])
    (setfield_imm 0 (global Code!) list/1030))
  (letrec
    (map/1031
       (function f/1032 l/1033
         (if l/1033
           (let
             (tail/1035 (field 1 l/1033)
              x/1034 (field 0 l/1033)
              xx/1036 (apply f/1032 x/1034))
             (makeblock 0 xx/1036 (apply map/1031 f/1032 tail/1035)))
           0a)))
    (setfield_imm 1 (global Code!) map/1031))
  (let
    (sum0/1037
       (apply (field 1 (global Code!))
         (function x/1038
           (seq (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038) x/1038))
         (field 0 (global Code!))))
    (setfield_imm 2 (global Code!) sum0/1037))
  (let
    (sum1/1039
       (catch (if (field 0 (global Code!)) (exit 4) 0a) with (4)
         (apply (field 1 (global Code!))
           (function x/1040
             (seq (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040) x/1040))
           (field 0 (global Code!)))))
    (setfield_imm 3 (global Code!) sum1/1039))
  (let
    (sum2/1041
       (apply (field 10 (global List!))
         (function x/1042
           (seq (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)))
         (field 0 (global Code!))))
    (setfield_imm 4 (global Code!) sum2/1041))
  0a)
-dlambda
(seq
  (let
    (list/1030
       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 [0: 7 [0: 8 [0: 9 0a]]]]]]]]])
    (setfield_imm 0 (global Code!) list/1030))
  (letrec
    (map/1031
       (function f/1032 l/1033
         (if l/1033
           (let (xx/1036 (apply f/1032 (field 0 l/1033)))
             (makeblock 0 xx/1036 (apply map/1031 f/1032 (field 1 l/1033))))
           0a)))
    (setfield_imm 1 (global Code!) map/1031))
  (let
    (sum0/1037
       (apply (field 1 (global Code!))
         (function x/1038
           (seq (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038) x/1038))
         (field 0 (global Code!))))
    (setfield_imm 2 (global Code!) sum0/1037))
  (let
    (sum1/1039
       (if (field 0 (global Code!))
         (apply (field 1 (global Code!))
           (function x/1040
             (seq (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040) x/1040))
           (field 0 (global Code!)))
         0a))
    (setfield_imm 3 (global Code!) sum1/1039))
  (let
    (sum2/1041
       (apply (field 10 (global List!))
         (function x/1042
           (seq (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)))
         (field 0 (global Code!))))
    (setfield_imm 4 (global Code!) sum2/1041))
  0a)
checking tailcall on map/1031
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (list/1030
       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 [0: 7 [0: 8 [0: 9 0a]]]]]]]]])
    (setfield_imm 0 (global Code!) list/1030))
  (letrec
    (map/1031
       (function f/1032 l/1033
         (if l/1033
           (let (xx/1036 (apply f/1032 (field 0 l/1033)))
             (makeblock 0 xx/1036 (apply map/1031 f/1032 (field 1 l/1033))))
           0a)))
    (setfield_imm 1 (global Code!) map/1031))
  (let
    (sum0/1037
       (apply (field 1 (global Code!))
         (function x/1038
           (seq (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1038) x/1038))
         (field 0 (global Code!))))
    (setfield_imm 2 (global Code!) sum0/1037))
  (let
    (sum1/1039
       (if (field 0 (global Code!))
         (apply (field 1 (global Code!))
           (function x/1040
             (seq (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040)
               (apply (field 1 (global Printf!)) "x = %d\n" x/1040) x/1040))
           (field 0 (global Code!)))
         0a))
    (setfield_imm 3 (global Code!) sum1/1039))
  (let
    (sum2/1041
       (apply (field 10 (global List!))
         (function x/1042
           (seq (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)
             (apply (field 1 (global Printf!)) "x = %d\n" x/1042)))
         (field 0 (global Code!))))
    (setfield_imm 4 (global Code!) sum2/1041))
  0a)
checking tailcall on map/1031
-dclosure
*** After Closure.intro:
(seq
  (let
    (list/1030
       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 [0: 7 [0: 8 [0: 9 0a]]]]]]]]])
    (setfield_imm 0 (global camlCode!) list/1030))
  (let
    (clos/1050
       (closure (camlCode__map_1031(2)  f/1032 l/1033
                  (if l/1033
                    (let (xx/1036 (apply f/1032 (field 0 l/1033)))
                      (makeblock 0 xx/1036
                        (camlCode__map_1031  f/1032 (field 1 l/1033))))
                    0a)) {3} ))
    (setfield_imm 1 (global camlCode!) clos/1050))
  (let
    (sum0/1037
       (let
         (l/1053 (field 0 (global camlCode!))
          f/1054
            (closure (camlCode__fun_1051(1)  x/1038
                       (seq
                         (apply
                           (apply
                             (camlPrintf__fprintf_1391 
                               (field 23 (global camlPervasives!)))
                             "x = %d\n")
                           x/1038)
                         (apply
                           (apply
                             (camlPrintf__fprintf_1391 
                               (field 23 (global camlPervasives!)))
                             "x = %d\n")
                           x/1038)
                         (apply
                           (apply
                             (camlPrintf__fprintf_1391 
                               (field 23 (global camlPervasives!)))
                             "x = %d\n")
                           x/1038)
                         (apply
                           (apply
                             (camlPrintf__fprintf_1391 
                               (field 23 (global camlPervasives!)))
                             "x = %d\n")
                           x/1038)
                         (apply
                           (apply
                             (camlPrintf__fprintf_1391 
                               (field 23 (global camlPervasives!)))
                             "x = %d\n")
                           x/1038)
                         (apply
                           (apply
                             (camlPrintf__fprintf_1391 
                               (field 23 (global camlPervasives!)))
                             "x = %d\n")
                           x/1038)
                         x/1038)) {2} )
          clos_env/1056
            (closure (camlCode__map_1055(2)  f/1032 l/1033
                       (if l/1033
                         (let (xx/1057 (apply f/1032 (field 0 l/1033)))
                           (makeblock 0 xx/1057
                             (camlCode__map_1055  f/1032 (field 1 l/1033))))
                         0a)) {0} ))
         (camlCode__map_1055  f/1054 l/1053)))
    (setfield_imm 2 (global camlCode!) sum0/1037))
  (let
    (sum1/1039
       (if (field 0 (global camlCode!))
         (let
           (l/1060 (field 0 (global camlCode!))
            f/1061
              (closure (camlCode__fun_1058(1)  x/1040
                         (seq
                           (apply
                             (apply
                               (camlPrintf__fprintf_1391 
                                 (field 23 (global camlPervasives!)))
                               "x = %d\n")
                             x/1040)
                           (apply
                             (apply
                               (camlPrintf__fprintf_1391 
                                 (field 23 (global camlPervasives!)))
                               "x = %d\n")
                             x/1040)
                           (apply
                             (apply
                               (camlPrintf__fprintf_1391 
                                 (field 23 (global camlPervasives!)))
                               "x = %d\n")
                             x/1040)
                           (apply
                             (apply
                               (camlPrintf__fprintf_1391 
                                 (field 23 (global camlPervasives!)))
                               "x = %d\n")
                             x/1040)
                           (apply
                             (apply
                               (camlPrintf__fprintf_1391 
                                 (field 23 (global camlPervasives!)))
                               "x = %d\n")
                             x/1040)
                           (apply
                             (apply
                               (camlPrintf__fprintf_1391 
                                 (field 23 (global camlPervasives!)))
                               "x = %d\n")
                             x/1040)
                           x/1040)) {2} )
            clos_env/1063
              (closure (camlCode__map_1062(2)  f/1032 l/1033
                         (if l/1033
                           (let (xx/1064 (apply f/1032 (field 0 l/1033)))
                             (makeblock 0 xx/1064
                               (camlCode__map_1062  f/1032 (field 1 l/1033))))
                           0a)) {0} ))
           (camlCode__map_1062  f/1061 l/1060))
         0a))
    (setfield_imm 3 (global camlCode!) sum1/1039))
  (let
    (sum2/1041
       (let
         (param/1067 (field 0 (global camlCode!))
          f/1068
            (closure (camlCode__fun_1065(1)  x/1042
                       (seq
                         (apply
                           (apply
                             (camlPrintf__fprintf_1391 
                               (field 23 (global camlPervasives!)))
                             "x = %d\n")
                           x/1042)
                         (apply
                           (apply
                             (camlPrintf__fprintf_1391 
                               (field 23 (global camlPervasives!)))
                             "x = %d\n")
                           x/1042)
                         (apply
                           (apply
                             (camlPrintf__fprintf_1391 
                               (field 23 (global camlPervasives!)))
                             "x = %d\n")
                           x/1042)
                         (apply
                           (apply
                             (camlPrintf__fprintf_1391 
                               (field 23 (global camlPervasives!)))
                             "x = %d\n")
                           x/1042)
                         (apply
                           (apply
                             (camlPrintf__fprintf_1391 
                               (field 23 (global camlPervasives!)))
                             "x = %d\n")
                           x/1042)
                         (apply
                           (apply
                             (camlPrintf__fprintf_1391 
                               (field 23 (global camlPervasives!)))
                             "x = %d\n")
                           x/1042))) {2} )
          param/1069[Variable] param/1067
          f/1070[Variable] f/1068)
         (catch
           (while 1a
             (catch
               (exit 71
                 (if param/1069
                   (let
                     (l/1071[Alias] (field 1 param/1069)
                      a/1072[Alias] (field 0 param/1069))
                     (seq (apply f/1070 a/1072)
                       (let (arg/1073 l/1071)
                         (seq (assign param/1069 arg/1073) (exit 70)))))
                   0a))
              with (70) 0a))
          with (71 res/1450) res/1450)))
    (setfield_imm 4 (global camlCode!) sum2/1041))
  0a)
*** After TonClosure.optimize:
(let
  (list/1030
     [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 [0: 7 [0: 8 [0: 9 0a]]]]]]]]])
  (seq (setfield_imm 0 (global camlCode!) list/1030)
    (let
      (clos/1050
         (closure (camlCode__map_1031(2)  f/1032 l/1033
                    (if l/1033
                      (let (xx/1036 (apply f/1032 (field 0 l/1033)))
                        (makeblock 0 xx/1036
                          (camlCode__map_1031  f/1032 (field 1 l/1033))))
                      0a)) {3} ))
      (seq (setfield_imm 1 (global camlCode!) clos/1050)
        (let
          (l/1053 (field 0 (global camlCode!))
           f/1054
             (closure (camlCode__fun_1051(1)  x/1038
                        (seq
                          (apply
                            (apply
                              (camlPrintf__fprintf_1391 
                                (field 23 (global camlPervasives!)))
                              "x = %d\n")
                            x/1038)
                          (apply
                            (apply
                              (camlPrintf__fprintf_1391 
                                (field 23 (global camlPervasives!)))
                              "x = %d\n")
                            x/1038)
                          (apply
                            (apply
                              (camlPrintf__fprintf_1391 
                                (field 23 (global camlPervasives!)))
                              "x = %d\n")
                            x/1038)
                          (apply
                            (apply
                              (camlPrintf__fprintf_1391 
                                (field 23 (global camlPervasives!)))
                              "x = %d\n")
                            x/1038)
                          (apply
                            (apply
                              (camlPrintf__fprintf_1391 
                                (field 23 (global camlPervasives!)))
                              "x = %d\n")
                            x/1038)
                          (apply
                            (apply
                              (camlPrintf__fprintf_1391 
                                (field 23 (global camlPervasives!)))
                              "x = %d\n")
                            x/1038)
                          x/1038)) {2} ))
          (seq
            (closure (camlCode__map_1055(2)  f/1032 l/1033
                       (if l/1033
                         (let (xx/1057 (apply f/1032 (field 0 l/1033)))
                           (makeblock 0 xx/1057
                             (camlCode__map_1055  f/1032 (field 1 l/1033))))
                         0a)) {0} )
            (let (sum0/1037 (camlCode__map_1055  f/1054 l/1053))
              (seq (setfield_imm 2 (global camlCode!) sum0/1037)
                (let
                  (sum1/1039
                     (if (field 0 (global camlCode!))
                       (let
                         (l/1060 (field 0 (global camlCode!))
                          f/1061
                            (closure (camlCode__fun_1058(1)  x/1040
                                       (seq
                                         (apply
                                           (apply
                                             (camlPrintf__fprintf_1391 
                                               (field 23
                                                 (global camlPervasives!)))
                                             "x = %d\n")
                                           x/1040)
                                         (apply
                                           (apply
                                             (camlPrintf__fprintf_1391 
                                               (field 23
                                                 (global camlPervasives!)))
                                             "x = %d\n")
                                           x/1040)
                                         (apply
                                           (apply
                                             (camlPrintf__fprintf_1391 
                                               (field 23
                                                 (global camlPervasives!)))
                                             "x = %d\n")
                                           x/1040)
                                         (apply
                                           (apply
                                             (camlPrintf__fprintf_1391 
                                               (field 23
                                                 (global camlPervasives!)))
                                             "x = %d\n")
                                           x/1040)
                                         (apply
                                           (apply
                                             (camlPrintf__fprintf_1391 
                                               (field 23
                                                 (global camlPervasives!)))
                                             "x = %d\n")
                                           x/1040)
                                         (apply
                                           (apply
                                             (camlPrintf__fprintf_1391 
                                               (field 23
                                                 (global camlPervasives!)))
                                             "x = %d\n")
                                           x/1040)
                                         x/1040)) {2} ))
                         (seq
                           (closure (camlCode__map_1062(2)  f/1032 l/1033
                                      (if l/1033
                                        (let
                                          (xx/1064
                                             (apply f/1032 (field 0 l/1033)))
                                          (makeblock 0 xx/1064
                                            (camlCode__map_1062  f/1032
                                              (field 1 l/1033))))
                                        0a)) {0} )
                           (camlCode__map_1062  f/1061 l/1060)))
                       0a))
                  (seq (setfield_imm 3 (global camlCode!) sum1/1039)
                    (let (param/1067 (field 0 (global camlCode!)))
                      (seq
                        (closure (camlCode__fun_1065(1)  x/1042
                                   (seq
                                     (apply
                                       (apply
                                         (camlPrintf__fprintf_1391 
                                           (field 23
                                             (global camlPervasives!)))
                                         "x = %d\n")
                                       x/1042)
                                     (apply
                                       (apply
                                         (camlPrintf__fprintf_1391 
                                           (field 23
                                             (global camlPervasives!)))
                                         "x = %d\n")
                                       x/1042)
                                     (apply
                                       (apply
                                         (camlPrintf__fprintf_1391 
                                           (field 23
                                             (global camlPervasives!)))
                                         "x = %d\n")
                                       x/1042)
                                     (apply
                                       (apply
                                         (camlPrintf__fprintf_1391 
                                           (field 23
                                             (global camlPervasives!)))
                                         "x = %d\n")
                                       x/1042)
                                     (apply
                                       (apply
                                         (camlPrintf__fprintf_1391 
                                           (field 23
                                             (global camlPervasives!)))
                                         "x = %d\n")
                                       x/1042)
                                     (apply
                                       (apply
                                         (camlPrintf__fprintf_1391 
                                           (field 23
                                             (global camlPervasives!)))
                                         "x = %d\n")
                                       x/1042))) {2} )
                        (let
                          (sum2/1041
                             (let (param/1069[Variable] param/1067)
                               (catch
                                 (while 1a
                                   (catch
                                     (exit 71
                                       (if param/1069
                                         (let
                                           (l/1071[Alias]
                                              (field 1 param/1069)
                                            a/1072[Alias]
                                              (field 0 param/1069))
                                           (seq (camlCode__fun_1065  a/1072)
                                             (assign param/1069 l/1071)
                                             (exit 70)))
                                         0a))
                                    with (70) 0a))
                                with (71 res/1450) res/1450)))
                          (seq (setfield_imm 4 (global camlCode!) sum2/1041)
                            0a))))))))))))))

-dcmm
(data int 5120 global "camlCode" "camlCode": skip 20)
(data int 2295 "camlCode__20": addr "camlCode__fun_1065" int 3)
(data
 int 3319
 "camlCode__21":
 addr "caml_curry2"
 int 5
 addr "camlCode__map_1062")
(data int 2295 "camlCode__22": addr "camlCode__fun_1058" int 3)
(data
 int 3319
 "camlCode__23":
 addr "caml_curry2"
 int 5
 addr "camlCode__map_1055")
(data int 2295 "camlCode__24": addr "camlCode__fun_1051" int 3)
(data
 int 3319
 "camlCode__25":
 addr "caml_curry2"
 int 5
 addr "camlCode__map_1031")
(data
 global "camlCode__1"
 int 2048
 "camlCode__1":
 int 3
 addr L26
 int 2048
 L26:
 int 5
 addr L27
 int 2048
 L27:
 int 7
 addr L28
 int 2048
 L28:
 int 9
 addr L29
 int 2048
 L29:
 int 11
 addr L30
 int 2048
 L30:
 int 13
 addr L31
 int 2048
 L31:
 int 15
 addr L32
 int 2048
 L32:
 int 17
 addr L33
 int 2048
 L33:
 int 19
 int 1)
(data
 global "camlCode__2"
 int 2300
 "camlCode__2":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__3"
 int 2300
 "camlCode__3":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__4"
 int 2300
 "camlCode__4":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__5"
 int 2300
 "camlCode__5":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__6"
 int 2300
 "camlCode__6":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__7"
 int 2300
 "camlCode__7":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__8"
 int 2300
 "camlCode__8":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__9"
 int 2300
 "camlCode__9":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__10"
 int 2300
 "camlCode__10":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__11"
 int 2300
 "camlCode__11":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__12"
 int 2300
 "camlCode__12":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__13"
 int 2300
 "camlCode__13":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__14"
 int 2300
 "camlCode__14":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__15"
 int 2300
 "camlCode__15":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__16"
 int 2300
 "camlCode__16":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__17"
 int 2300
 "camlCode__17":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__18"
 int 2300
 "camlCode__18":
 string "x = %d
"
 skip 0
 byte 0)
(data
 global "camlCode__19"
 int 2300
 "camlCode__19":
 string "x = %d
"
 skip 0
 byte 0)
(function camlCode__map_1031 (f/1032: addr l/1033: addr)
 (if (!= l/1033 1)
   (let xx/1036 (app (load f/1032) (load l/1033) f/1032 addr)
     (alloc 2048 xx/1036
       (app "camlCode__map_1031" f/1032 (load (+a l/1033 4)) addr)))
   1a))

(function camlCode__fun_1051 (x/1038: addr)
 (let
   fun/1109
     (let
       fun/1108
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1108) "camlCode__2" fun/1108 addr))
   (app (load fun/1109) x/1038 fun/1109 unit))
 (let
   fun/1107
     (let
       fun/1106
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1106) "camlCode__3" fun/1106 addr))
   (app (load fun/1107) x/1038 fun/1107 unit))
 (let
   fun/1105
     (let
       fun/1104
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1104) "camlCode__4" fun/1104 addr))
   (app (load fun/1105) x/1038 fun/1105 unit))
 (let
   fun/1103
     (let
       fun/1102
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1102) "camlCode__5" fun/1102 addr))
   (app (load fun/1103) x/1038 fun/1103 unit))
 (let
   fun/1101
     (let
       fun/1100
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1100) "camlCode__6" fun/1100 addr))
   (app (load fun/1101) x/1038 fun/1101 unit))
 (let
   fun/1099
     (let
       fun/1098
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1098) "camlCode__7" fun/1098 addr))
   (app (load fun/1099) x/1038 fun/1099 unit))
 x/1038)

(function camlCode__map_1055 (f/1032: addr l/1033: addr)
 (if (!= l/1033 1)
   (let xx/1057 (app (load f/1032) (load l/1033) f/1032 addr)
     (alloc 2048 xx/1057
       (app "camlCode__map_1055" f/1032 (load (+a l/1033 4)) addr)))
   1a))

(function camlCode__fun_1058 (x/1040: addr)
 (let
   fun/1097
     (let
       fun/1096
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1096) "camlCode__8" fun/1096 addr))
   (app (load fun/1097) x/1040 fun/1097 unit))
 (let
   fun/1095
     (let
       fun/1094
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1094) "camlCode__9" fun/1094 addr))
   (app (load fun/1095) x/1040 fun/1095 unit))
 (let
   fun/1093
     (let
       fun/1092
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1092) "camlCode__10" fun/1092
         addr))
   (app (load fun/1093) x/1040 fun/1093 unit))
 (let
   fun/1091
     (let
       fun/1090
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1090) "camlCode__11" fun/1090
         addr))
   (app (load fun/1091) x/1040 fun/1091 unit))
 (let
   fun/1089
     (let
       fun/1088
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1088) "camlCode__12" fun/1088
         addr))
   (app (load fun/1089) x/1040 fun/1089 unit))
 (let
   fun/1087
     (let
       fun/1086
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1086) "camlCode__13" fun/1086
         addr))
   (app (load fun/1087) x/1040 fun/1087 unit))
 x/1040)

(function camlCode__map_1062 (f/1032: addr l/1033: addr)
 (if (!= l/1033 1)
   (let xx/1064 (app (load f/1032) (load l/1033) f/1032 addr)
     (alloc 2048 xx/1064
       (app "camlCode__map_1062" f/1032 (load (+a l/1033 4)) addr)))
   1a))

(function camlCode__fun_1065 (x/1042: addr)
 (let
   fun/1085
     (let
       fun/1084
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1084) "camlCode__14" fun/1084
         addr))
   (app (load fun/1085) x/1042 fun/1085 unit))
 (let
   fun/1083
     (let
       fun/1082
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1082) "camlCode__15" fun/1082
         addr))
   (app (load fun/1083) x/1042 fun/1083 unit))
 (let
   fun/1081
     (let
       fun/1080
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1080) "camlCode__16" fun/1080
         addr))
   (app (load fun/1081) x/1042 fun/1081 unit))
 (let
   fun/1079
     (let
       fun/1078
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1078) "camlCode__17" fun/1078
         addr))
   (app (load fun/1079) x/1042 fun/1079 unit))
 (let
   fun/1077
     (let
       fun/1076
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1076) "camlCode__18" fun/1076
         addr))
   (app (load fun/1077) x/1042 fun/1077 unit))
 (let
   fun/1075
     (let
       fun/1074
         (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
           (load (+a "camlPervasives" 92)) addr)
       (app{printf.ml:641,17-35} (load fun/1074) "camlCode__19" fun/1074
         addr))
   (app (load fun/1075) x/1042 fun/1075 addr)))

(function camlCode__entry ()
 (let list/1030 "camlCode__1" (store "camlCode" list/1030)
   (let clos/1050 "camlCode__25" (store (+a "camlCode" 4) clos/1050)
     (let (l/1053 (load "camlCode") f/1054 "camlCode__24") "camlCode__23" 
       []
       (let sum0/1037 (app "camlCode__map_1055" f/1054 l/1053 addr)
         (store (+a "camlCode" 8) sum0/1037)
         (let
           sum1/1039
             (if (!= (load "camlCode") 1)
               (let (l/1060 (load "camlCode") f/1061 "camlCode__22")
                 "camlCode__21" []
                 (app "camlCode__map_1062" f/1061 l/1060 addr))
               1a)
           (store (+a "camlCode" 12) sum1/1039)
           (let param/1067 (load "camlCode") "camlCode__20" []
             (let
               sum2/1041
                 (let param/1069 param/1067
                   (catch
                     (loop
                       (catch
                         (exit 71
                           (if (!= param/1069 1)
                             (let
                               (l/1071 (load (+a param/1069 4))
                                a/1072 (load param/1069))
                               (app "camlCode__fun_1065" a/1072 unit)
                               (assign param/1069 l/1071) (exit 70))
                             1a))
                       with(70) []))
                     1a
                   with(71 res/1450) res/1450))
               (store (+a "camlCode" 16) sum2/1041) 1a))))))))

(data)
-dlinear
Before simplify
camlCode__map_1031:
                  f/8[%edx] := R/0[%eax]
                  if l/9[%ebx] ==s 1 goto L100
                  spilled-l/19[s0] := l/9[%ebx] (spill)
                  spilled-f/18[s1] := f/8[%edx] (spill)
                  A/11[%eax] := [l/9[%ebx]]
                  A/12[%ecx] := [f/8[%edx]]
                  R/1[%ebx] := f/8[%edx]
                  {spilled-f/18[s1]* spilled-l/19[s0]*}
                  R/0[%eax] := call A/12[%ecx] R/0[%eax] R/1[%ebx]
                  spilled-xx/17[s2] := xx/13[%eax] (spill)
                  l/20[%eax] := spilled-l/19[s0] (reload)
                  A/14[%ebx] := [l/20[%eax] + 4]
                  f/21[%eax] := spilled-f/18[s1] (reload)
                  {spilled-xx/17[s2]*}
                  R/0[%eax] := call "camlCode__map_1031" R/0[%eax] R/1[%ebx]
                  A/15[%ecx] := R/0[%eax]
                  {A/15[%ecx]* spilled-xx/17[s2]*}
                  A/16[%eax] := alloc 12
                  [A/16[%eax] + -4] := 2048
                  xx/22[%ebx] := spilled-xx/17[s2] (reload)
                  [A/16[%eax]] := xx/22[%ebx]
                  [A/16[%eax] + 4] := A/15[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  L100 [0]:
                  A/10[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__map_1031:
  f/8[%edx] := R/0[%eax]
  if l/9[%ebx] ==s 1 goto L100
  spilled-l/19[s0] := l/9[%ebx] (spill)
  spilled-f/18[s1] := f/8[%edx] (spill)
  A/11[%eax] := [l/9[%ebx]]
  A/12[%ecx] := [f/8[%edx]]
  R/1[%ebx] := f/8[%edx]
  {spilled-f/18[s1]* spilled-l/19[s0]*}
  R/0[%eax] := call A/12[%ecx] R/0[%eax] R/1[%ebx]
  spilled-xx/17[s2] := xx/13[%eax] (spill)
  l/20[%eax] := spilled-l/19[s0] (reload)
  A/14[%ebx] := [l/20[%eax] + 4]
  f/21[%eax] := spilled-f/18[s1] (reload)
  {spilled-xx/17[s2]*}
  R/0[%eax] := call "camlCode__map_1031" R/0[%eax] R/1[%ebx]
  A/15[%ecx] := R/0[%eax]
  {A/15[%ecx]* spilled-xx/17[s2]*}
  A/16[%eax] := alloc 12
  [A/16[%eax] + -4] := 2048
  xx/22[%ebx] := spilled-xx/17[s2] (reload)
  [A/16[%eax]] := xx/22[%ebx]
  [A/16[%eax] + 4] := A/15[%ecx]
  reload retaddr
  return R/0[%eax]
  L100 [2]:
  A/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__fun_1051:
                  spilled-x/45[s0] := x/8[%eax] (spill)
                  A/9[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/10[%ebx] := R/0[%eax]
                  A/11[%eax] := "camlCode__2"
                  A/12[%ecx] := [fun/10[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/12[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/13[%ebx] := R/0[%eax]
                  A/14[%ecx] := [fun/13[%ebx]]
                  x/46[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/14[%ecx] R/0[%eax] R/1[%ebx]
                  A/15[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/16[%ebx] := R/0[%eax]
                  A/17[%eax] := "camlCode__3"
                  A/18[%ecx] := [fun/16[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/18[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/19[%ebx] := R/0[%eax]
                  A/20[%ecx] := [fun/19[%ebx]]
                  x/47[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/20[%ecx] R/0[%eax] R/1[%ebx]
                  A/21[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/22[%ebx] := R/0[%eax]
                  A/23[%eax] := "camlCode__4"
                  A/24[%ecx] := [fun/22[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/24[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/25[%ebx] := R/0[%eax]
                  A/26[%ecx] := [fun/25[%ebx]]
                  x/48[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/26[%ecx] R/0[%eax] R/1[%ebx]
                  A/27[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/28[%ebx] := R/0[%eax]
                  A/29[%eax] := "camlCode__5"
                  A/30[%ecx] := [fun/28[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/30[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/31[%ebx] := R/0[%eax]
                  A/32[%ecx] := [fun/31[%ebx]]
                  x/49[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/32[%ecx] R/0[%eax] R/1[%ebx]
                  A/33[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/34[%ebx] := R/0[%eax]
                  A/35[%eax] := "camlCode__6"
                  A/36[%ecx] := [fun/34[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/36[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/37[%ebx] := R/0[%eax]
                  A/38[%ecx] := [fun/37[%ebx]]
                  x/50[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/38[%ecx] R/0[%eax] R/1[%ebx]
                  A/39[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/40[%ebx] := R/0[%eax]
                  A/41[%eax] := "camlCode__7"
                  A/42[%ecx] := [fun/40[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/42[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/43[%ebx] := R/0[%eax]
                  A/44[%ecx] := [fun/43[%ebx]]
                  x/51[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/44[%ecx] R/0[%eax] R/1[%ebx]
                  x/52[%eax] := spilled-x/45[s0] (reload)
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_1051:
  spilled-x/45[s0] := x/8[%eax] (spill)
  A/9[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/10[%ebx] := R/0[%eax]
  A/11[%eax] := "camlCode__2"
  A/12[%ecx] := [fun/10[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/12[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/13[%ebx] := R/0[%eax]
  A/14[%ecx] := [fun/13[%ebx]]
  x/46[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/14[%ecx] R/0[%eax] R/1[%ebx]
  A/15[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/16[%ebx] := R/0[%eax]
  A/17[%eax] := "camlCode__3"
  A/18[%ecx] := [fun/16[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/18[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/19[%ebx] := R/0[%eax]
  A/20[%ecx] := [fun/19[%ebx]]
  x/47[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/20[%ecx] R/0[%eax] R/1[%ebx]
  A/21[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/22[%ebx] := R/0[%eax]
  A/23[%eax] := "camlCode__4"
  A/24[%ecx] := [fun/22[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/24[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/25[%ebx] := R/0[%eax]
  A/26[%ecx] := [fun/25[%ebx]]
  x/48[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/26[%ecx] R/0[%eax] R/1[%ebx]
  A/27[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/28[%ebx] := R/0[%eax]
  A/29[%eax] := "camlCode__5"
  A/30[%ecx] := [fun/28[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/30[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/31[%ebx] := R/0[%eax]
  A/32[%ecx] := [fun/31[%ebx]]
  x/49[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/32[%ecx] R/0[%eax] R/1[%ebx]
  A/33[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/34[%ebx] := R/0[%eax]
  A/35[%eax] := "camlCode__6"
  A/36[%ecx] := [fun/34[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/36[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/37[%ebx] := R/0[%eax]
  A/38[%ecx] := [fun/37[%ebx]]
  x/50[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/38[%ecx] R/0[%eax] R/1[%ebx]
  A/39[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/40[%ebx] := R/0[%eax]
  A/41[%eax] := "camlCode__7"
  A/42[%ecx] := [fun/40[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/42[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/43[%ebx] := R/0[%eax]
  A/44[%ecx] := [fun/43[%ebx]]
  x/51[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/44[%ecx] R/0[%eax] R/1[%ebx]
  x/52[%eax] := spilled-x/45[s0] (reload)
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__map_1055:
                  f/8[%edx] := R/0[%eax]
                  if l/9[%ebx] ==s 1 goto L126
                  spilled-l/19[s0] := l/9[%ebx] (spill)
                  spilled-f/18[s1] := f/8[%edx] (spill)
                  A/11[%eax] := [l/9[%ebx]]
                  A/12[%ecx] := [f/8[%edx]]
                  R/1[%ebx] := f/8[%edx]
                  {spilled-f/18[s1]* spilled-l/19[s0]*}
                  R/0[%eax] := call A/12[%ecx] R/0[%eax] R/1[%ebx]
                  spilled-xx/17[s2] := xx/13[%eax] (spill)
                  l/20[%eax] := spilled-l/19[s0] (reload)
                  A/14[%ebx] := [l/20[%eax] + 4]
                  f/21[%eax] := spilled-f/18[s1] (reload)
                  {spilled-xx/17[s2]*}
                  R/0[%eax] := call "camlCode__map_1055" R/0[%eax] R/1[%ebx]
                  A/15[%ecx] := R/0[%eax]
                  {A/15[%ecx]* spilled-xx/17[s2]*}
                  A/16[%eax] := alloc 12
                  [A/16[%eax] + -4] := 2048
                  xx/22[%ebx] := spilled-xx/17[s2] (reload)
                  [A/16[%eax]] := xx/22[%ebx]
                  [A/16[%eax] + 4] := A/15[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  L126 [0]:
                  A/10[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__map_1055:
  f/8[%edx] := R/0[%eax]
  if l/9[%ebx] ==s 1 goto L126
  spilled-l/19[s0] := l/9[%ebx] (spill)
  spilled-f/18[s1] := f/8[%edx] (spill)
  A/11[%eax] := [l/9[%ebx]]
  A/12[%ecx] := [f/8[%edx]]
  R/1[%ebx] := f/8[%edx]
  {spilled-f/18[s1]* spilled-l/19[s0]*}
  R/0[%eax] := call A/12[%ecx] R/0[%eax] R/1[%ebx]
  spilled-xx/17[s2] := xx/13[%eax] (spill)
  l/20[%eax] := spilled-l/19[s0] (reload)
  A/14[%ebx] := [l/20[%eax] + 4]
  f/21[%eax] := spilled-f/18[s1] (reload)
  {spilled-xx/17[s2]*}
  R/0[%eax] := call "camlCode__map_1055" R/0[%eax] R/1[%ebx]
  A/15[%ecx] := R/0[%eax]
  {A/15[%ecx]* spilled-xx/17[s2]*}
  A/16[%eax] := alloc 12
  [A/16[%eax] + -4] := 2048
  xx/22[%ebx] := spilled-xx/17[s2] (reload)
  [A/16[%eax]] := xx/22[%ebx]
  [A/16[%eax] + 4] := A/15[%ecx]
  reload retaddr
  return R/0[%eax]
  L126 [2]:
  A/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__fun_1058:
                  spilled-x/45[s0] := x/8[%eax] (spill)
                  A/9[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/10[%ebx] := R/0[%eax]
                  A/11[%eax] := "camlCode__8"
                  A/12[%ecx] := [fun/10[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/12[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/13[%ebx] := R/0[%eax]
                  A/14[%ecx] := [fun/13[%ebx]]
                  x/46[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/14[%ecx] R/0[%eax] R/1[%ebx]
                  A/15[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/16[%ebx] := R/0[%eax]
                  A/17[%eax] := "camlCode__9"
                  A/18[%ecx] := [fun/16[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/18[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/19[%ebx] := R/0[%eax]
                  A/20[%ecx] := [fun/19[%ebx]]
                  x/47[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/20[%ecx] R/0[%eax] R/1[%ebx]
                  A/21[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/22[%ebx] := R/0[%eax]
                  A/23[%eax] := "camlCode__10"
                  A/24[%ecx] := [fun/22[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/24[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/25[%ebx] := R/0[%eax]
                  A/26[%ecx] := [fun/25[%ebx]]
                  x/48[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/26[%ecx] R/0[%eax] R/1[%ebx]
                  A/27[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/28[%ebx] := R/0[%eax]
                  A/29[%eax] := "camlCode__11"
                  A/30[%ecx] := [fun/28[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/30[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/31[%ebx] := R/0[%eax]
                  A/32[%ecx] := [fun/31[%ebx]]
                  x/49[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/32[%ecx] R/0[%eax] R/1[%ebx]
                  A/33[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/34[%ebx] := R/0[%eax]
                  A/35[%eax] := "camlCode__12"
                  A/36[%ecx] := [fun/34[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/36[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/37[%ebx] := R/0[%eax]
                  A/38[%ecx] := [fun/37[%ebx]]
                  x/50[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/38[%ecx] R/0[%eax] R/1[%ebx]
                  A/39[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/40[%ebx] := R/0[%eax]
                  A/41[%eax] := "camlCode__13"
                  A/42[%ecx] := [fun/40[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/42[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/43[%ebx] := R/0[%eax]
                  A/44[%ecx] := [fun/43[%ebx]]
                  x/51[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/44[%ecx] R/0[%eax] R/1[%ebx]
                  x/52[%eax] := spilled-x/45[s0] (reload)
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_1058:
  spilled-x/45[s0] := x/8[%eax] (spill)
  A/9[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/10[%ebx] := R/0[%eax]
  A/11[%eax] := "camlCode__8"
  A/12[%ecx] := [fun/10[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/12[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/13[%ebx] := R/0[%eax]
  A/14[%ecx] := [fun/13[%ebx]]
  x/46[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/14[%ecx] R/0[%eax] R/1[%ebx]
  A/15[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/16[%ebx] := R/0[%eax]
  A/17[%eax] := "camlCode__9"
  A/18[%ecx] := [fun/16[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/18[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/19[%ebx] := R/0[%eax]
  A/20[%ecx] := [fun/19[%ebx]]
  x/47[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/20[%ecx] R/0[%eax] R/1[%ebx]
  A/21[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/22[%ebx] := R/0[%eax]
  A/23[%eax] := "camlCode__10"
  A/24[%ecx] := [fun/22[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/24[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/25[%ebx] := R/0[%eax]
  A/26[%ecx] := [fun/25[%ebx]]
  x/48[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/26[%ecx] R/0[%eax] R/1[%ebx]
  A/27[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/28[%ebx] := R/0[%eax]
  A/29[%eax] := "camlCode__11"
  A/30[%ecx] := [fun/28[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/30[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/31[%ebx] := R/0[%eax]
  A/32[%ecx] := [fun/31[%ebx]]
  x/49[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/32[%ecx] R/0[%eax] R/1[%ebx]
  A/33[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/34[%ebx] := R/0[%eax]
  A/35[%eax] := "camlCode__12"
  A/36[%ecx] := [fun/34[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/36[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/37[%ebx] := R/0[%eax]
  A/38[%ecx] := [fun/37[%ebx]]
  x/50[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/38[%ecx] R/0[%eax] R/1[%ebx]
  A/39[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/40[%ebx] := R/0[%eax]
  A/41[%eax] := "camlCode__13"
  A/42[%ecx] := [fun/40[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/42[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/43[%ebx] := R/0[%eax]
  A/44[%ecx] := [fun/43[%ebx]]
  x/51[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/44[%ecx] R/0[%eax] R/1[%ebx]
  x/52[%eax] := spilled-x/45[s0] (reload)
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__map_1062:
                  f/8[%edx] := R/0[%eax]
                  if l/9[%ebx] ==s 1 goto L152
                  spilled-l/19[s0] := l/9[%ebx] (spill)
                  spilled-f/18[s1] := f/8[%edx] (spill)
                  A/11[%eax] := [l/9[%ebx]]
                  A/12[%ecx] := [f/8[%edx]]
                  R/1[%ebx] := f/8[%edx]
                  {spilled-f/18[s1]* spilled-l/19[s0]*}
                  R/0[%eax] := call A/12[%ecx] R/0[%eax] R/1[%ebx]
                  spilled-xx/17[s2] := xx/13[%eax] (spill)
                  l/20[%eax] := spilled-l/19[s0] (reload)
                  A/14[%ebx] := [l/20[%eax] + 4]
                  f/21[%eax] := spilled-f/18[s1] (reload)
                  {spilled-xx/17[s2]*}
                  R/0[%eax] := call "camlCode__map_1062" R/0[%eax] R/1[%ebx]
                  A/15[%ecx] := R/0[%eax]
                  {A/15[%ecx]* spilled-xx/17[s2]*}
                  A/16[%eax] := alloc 12
                  [A/16[%eax] + -4] := 2048
                  xx/22[%ebx] := spilled-xx/17[s2] (reload)
                  [A/16[%eax]] := xx/22[%ebx]
                  [A/16[%eax] + 4] := A/15[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  L152 [0]:
                  A/10[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__map_1062:
  f/8[%edx] := R/0[%eax]
  if l/9[%ebx] ==s 1 goto L152
  spilled-l/19[s0] := l/9[%ebx] (spill)
  spilled-f/18[s1] := f/8[%edx] (spill)
  A/11[%eax] := [l/9[%ebx]]
  A/12[%ecx] := [f/8[%edx]]
  R/1[%ebx] := f/8[%edx]
  {spilled-f/18[s1]* spilled-l/19[s0]*}
  R/0[%eax] := call A/12[%ecx] R/0[%eax] R/1[%ebx]
  spilled-xx/17[s2] := xx/13[%eax] (spill)
  l/20[%eax] := spilled-l/19[s0] (reload)
  A/14[%ebx] := [l/20[%eax] + 4]
  f/21[%eax] := spilled-f/18[s1] (reload)
  {spilled-xx/17[s2]*}
  R/0[%eax] := call "camlCode__map_1062" R/0[%eax] R/1[%ebx]
  A/15[%ecx] := R/0[%eax]
  {A/15[%ecx]* spilled-xx/17[s2]*}
  A/16[%eax] := alloc 12
  [A/16[%eax] + -4] := 2048
  xx/22[%ebx] := spilled-xx/17[s2] (reload)
  [A/16[%eax]] := xx/22[%ebx]
  [A/16[%eax] + 4] := A/15[%ecx]
  reload retaddr
  return R/0[%eax]
  L152 [2]:
  A/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__fun_1065:
                  spilled-x/45[s0] := x/8[%eax] (spill)
                  A/9[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/10[%ebx] := R/0[%eax]
                  A/11[%eax] := "camlCode__14"
                  A/12[%ecx] := [fun/10[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/12[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/13[%ebx] := R/0[%eax]
                  A/14[%ecx] := [fun/13[%ebx]]
                  x/46[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/14[%ecx] R/0[%eax] R/1[%ebx]
                  A/15[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/16[%ebx] := R/0[%eax]
                  A/17[%eax] := "camlCode__15"
                  A/18[%ecx] := [fun/16[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/18[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/19[%ebx] := R/0[%eax]
                  A/20[%ecx] := [fun/19[%ebx]]
                  x/47[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/20[%ecx] R/0[%eax] R/1[%ebx]
                  A/21[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/22[%ebx] := R/0[%eax]
                  A/23[%eax] := "camlCode__16"
                  A/24[%ecx] := [fun/22[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/24[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/25[%ebx] := R/0[%eax]
                  A/26[%ecx] := [fun/25[%ebx]]
                  x/48[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/26[%ecx] R/0[%eax] R/1[%ebx]
                  A/27[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/28[%ebx] := R/0[%eax]
                  A/29[%eax] := "camlCode__17"
                  A/30[%ecx] := [fun/28[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/30[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/31[%ebx] := R/0[%eax]
                  A/32[%ecx] := [fun/31[%ebx]]
                  x/49[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/32[%ecx] R/0[%eax] R/1[%ebx]
                  A/33[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/34[%ebx] := R/0[%eax]
                  A/35[%eax] := "camlCode__18"
                  A/36[%ecx] := [fun/34[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/36[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/37[%ebx] := R/0[%eax]
                  A/38[%ecx] := [fun/37[%ebx]]
                  x/50[%eax] := spilled-x/45[s0] (reload)
                  {spilled-x/45[s0]*}
                  call A/38[%ecx] R/0[%eax] R/1[%ebx]
                  A/39[%eax] := ["camlPervasives" + 92]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/40[%ebx] := R/0[%eax]
                  A/41[%eax] := "camlCode__19"
                  A/42[%ecx] := [fun/40[%ebx]]
                  {spilled-x/45[s0]*}
                  R/0[%eax] := call A/42[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/43[%ebx] := R/0[%eax]
                  A/44[%ecx] := [fun/43[%ebx]]
                  x/51[%eax] := spilled-x/45[s0] (reload)
                  tailcall A/44[%ecx] R/0[%eax] R/1[%ebx]
                  *** Linearized code
camlCode__fun_1065:
  spilled-x/45[s0] := x/8[%eax] (spill)
  A/9[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/10[%ebx] := R/0[%eax]
  A/11[%eax] := "camlCode__14"
  A/12[%ecx] := [fun/10[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/12[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/13[%ebx] := R/0[%eax]
  A/14[%ecx] := [fun/13[%ebx]]
  x/46[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/14[%ecx] R/0[%eax] R/1[%ebx]
  A/15[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/16[%ebx] := R/0[%eax]
  A/17[%eax] := "camlCode__15"
  A/18[%ecx] := [fun/16[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/18[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/19[%ebx] := R/0[%eax]
  A/20[%ecx] := [fun/19[%ebx]]
  x/47[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/20[%ecx] R/0[%eax] R/1[%ebx]
  A/21[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/22[%ebx] := R/0[%eax]
  A/23[%eax] := "camlCode__16"
  A/24[%ecx] := [fun/22[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/24[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/25[%ebx] := R/0[%eax]
  A/26[%ecx] := [fun/25[%ebx]]
  x/48[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/26[%ecx] R/0[%eax] R/1[%ebx]
  A/27[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/28[%ebx] := R/0[%eax]
  A/29[%eax] := "camlCode__17"
  A/30[%ecx] := [fun/28[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/30[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/31[%ebx] := R/0[%eax]
  A/32[%ecx] := [fun/31[%ebx]]
  x/49[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/32[%ecx] R/0[%eax] R/1[%ebx]
  A/33[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/34[%ebx] := R/0[%eax]
  A/35[%eax] := "camlCode__18"
  A/36[%ecx] := [fun/34[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/36[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/37[%ebx] := R/0[%eax]
  A/38[%ecx] := [fun/37[%ebx]]
  x/50[%eax] := spilled-x/45[s0] (reload)
  {spilled-x/45[s0]*}
  call A/38[%ecx] R/0[%eax] R/1[%ebx]
  A/39[%eax] := ["camlPervasives" + 92]
  {spilled-x/45[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/40[%ebx] := R/0[%eax]
  A/41[%eax] := "camlCode__19"
  A/42[%ecx] := [fun/40[%ebx]]
  {spilled-x/45[s0]*}
  R/0[%eax] := call A/42[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/43[%ebx] := R/0[%eax]
  A/44[%ecx] := [fun/43[%ebx]]
  x/51[%eax] := spilled-x/45[s0] (reload)
  tailcall A/44[%ecx] R/0[%eax] R/1[%ebx]
  
Before simplify
camlCode__entry:
                  list/8[%eax] := "camlCode__1"
                  ["camlCode"] := list/8[%eax]
                  clos/9[%eax] := "camlCode__25"
                  ["camlCode" + 4] := clos/9[%eax]
                  l/10[%ebx] := ["camlCode"]
                  f/11[%eax] := "camlCode__24"
                  A/12[%ecx] := "camlCode__23"
                  {}
                  R/0[%eax] := call "camlCode__map_1055" R/0[%eax] R/1[%ebx]
                  ["camlCode" + 8] := sum0/13[%eax]
                  A/14[%eax] := ["camlCode"]
                  if A/14[%eax] ==s 1 goto L181
                  l/15[%ebx] := ["camlCode"]
                  f/16[%eax] := "camlCode__22"
                  A/17[%ecx] := "camlCode__21"
                  {}
                  R/0[%eax] := call "camlCode__map_1062" R/0[%eax] R/1[%ebx]
                  goto L180
                  L181 [0]:
                  A/19[%eax] := 1
                  L180 [0]:
                  ["camlCode" + 12] := sum1/18[%eax]
                  param/20[%eax] := ["camlCode"]
                  A/21[%ebx] := "camlCode__20"
                  L178 [0]:
                  if param/22[%eax] ==s 1 goto L179
                  l/24[%ebx] := [param/22[%eax] + 4]
                  spilled-l/29[s0] := l/24[%ebx] (spill)
                  a/25[%eax] := [param/22[%eax]]
                  {spilled-l/29[s0]*}
                  call "camlCode__fun_1065" R/0[%eax]
                  l/30[%eax] := spilled-l/29[s0] (reload)
                  goto L178
                  L179 [0]:
                  A/26[%eax] := 1
                  L177 [0]:
                  ["camlCode" + 16] := sum2/27[%eax]
                  A/28[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  list/8[%eax] := "camlCode__1"
  ["camlCode"] := list/8[%eax]
  clos/9[%eax] := "camlCode__25"
  ["camlCode" + 4] := clos/9[%eax]
  l/10[%ebx] := ["camlCode"]
  f/11[%eax] := "camlCode__24"
  A/12[%ecx] := "camlCode__23"
  {}
  R/0[%eax] := call "camlCode__map_1055" R/0[%eax] R/1[%ebx]
  ["camlCode" + 8] := sum0/13[%eax]
  A/14[%eax] := ["camlCode"]
  if A/14[%eax] ==s 1 goto L181
  l/15[%ebx] := ["camlCode"]
  f/16[%eax] := "camlCode__22"
  A/17[%ecx] := "camlCode__21"
  {}
  R/0[%eax] := call "camlCode__map_1062" R/0[%eax] R/1[%ebx]
  goto L180
  L181 [2]:
  A/19[%eax] := 1
  L180 [3]:
  ["camlCode" + 12] := sum1/18[%eax]
  param/20[%eax] := ["camlCode"]
  A/21[%ebx] := "camlCode__20"
  L178 [3]:
  if param/22[%eax] ==s 1 goto L179
  l/24[%ebx] := [param/22[%eax] + 4]
  spilled-l/29[s0] := l/24[%ebx] (spill)
  a/25[%eax] := [param/22[%eax]]
  {spilled-l/29[s0]*}
  call "camlCode__fun_1065" R/0[%eax]
  l/30[%eax] := spilled-l/29[s0] (reload)
  goto L178
  L179 [2]:
  A/26[%eax] := 1
  L177 [2]:
  ["camlCode" + 16] := sum2/27[%eax]
  A/28[%eax] := 1
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
	.long	5120
	.globl	camlCode
camlCode:
	.space	20
	.data
	.long	2295
camlCode__20:
	.long	camlCode__fun_1065
	.long	3
	.data
	.long	3319
camlCode__21:
	.long	caml_curry2
	.long	5
	.long	camlCode__map_1062
	.data
	.long	2295
camlCode__22:
	.long	camlCode__fun_1058
	.long	3
	.data
	.long	3319
camlCode__23:
	.long	caml_curry2
	.long	5
	.long	camlCode__map_1055
	.data
	.long	2295
camlCode__24:
	.long	camlCode__fun_1051
	.long	3
	.data
	.long	3319
camlCode__25:
	.long	caml_curry2
	.long	5
	.long	camlCode__map_1031
	.data
	.globl	camlCode__1
	.long	2048
camlCode__1:
	.long	3
	.long	.L100026
	.long	2048
.L100026:
	.long	5
	.long	.L100027
	.long	2048
.L100027:
	.long	7
	.long	.L100028
	.long	2048
.L100028:
	.long	9
	.long	.L100029
	.long	2048
.L100029:
	.long	11
	.long	.L100030
	.long	2048
.L100030:
	.long	13
	.long	.L100031
	.long	2048
.L100031:
	.long	15
	.long	.L100032
	.long	2048
.L100032:
	.long	17
	.long	.L100033
	.long	2048
.L100033:
	.long	19
	.long	1
	.data
	.globl	camlCode__2
	.long	2300
camlCode__2:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__3
	.long	2300
camlCode__3:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__4
	.long	2300
camlCode__4:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__5
	.long	2300
camlCode__5:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__6
	.long	2300
camlCode__6:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__7
	.long	2300
camlCode__7:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__8
	.long	2300
camlCode__8:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__9
	.long	2300
camlCode__9:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__10
	.long	2300
camlCode__10:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__11
	.long	2300
camlCode__11:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__12
	.long	2300
camlCode__12:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__13
	.long	2300
camlCode__13:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__14
	.long	2300
camlCode__14:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__15
	.long	2300
camlCode__15:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__16
	.long	2300
camlCode__16:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__17
	.long	2300
camlCode__17:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__18
	.long	2300
camlCode__18:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.globl	camlCode__19
	.long	2300
camlCode__19:
	.ascii	"x = %d\12"
	.byte	0
	.text
	.align	16
	.globl	camlCode__map_1031
camlCode__map_1031:
	subl	$12, %esp
.L101:
	movl	%eax, %edx
	cmpl	$1, %ebx
	je	.L100
	movl	%ebx, 0(%esp)
	movl	%edx, 4(%esp)
	movl	(%ebx), %eax
	movl	(%edx), %ecx
	movl	%edx, %ebx
	call	*%ecx
.L102:
	movl	%eax, 8(%esp)
	movl	0(%esp), %eax
	movl	4(%eax), %ebx
	movl	4(%esp), %eax
	call	camlCode__map_1031
.L103:
	movl	%eax, %ecx
.L104:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L105
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	8(%esp), %ebx
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	addl	$12, %esp
	ret
	.align	16
.L100:
	movl	$1, %eax
	addl	$12, %esp
	ret
.L105:	call	caml_call_gc
.L106:	jmp	.L104
	.type	camlCode__map_1031,@function
	.size	camlCode__map_1031,.-camlCode__map_1031
	.text
	.align	16
	.globl	camlCode__fun_1051
camlCode__fun_1051:
	subl	$4, %esp
.L107:
	movl	%eax, 0(%esp)
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L108:
	movl	%eax, %ebx
	movl	$camlCode__2, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L109:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L110:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L111:
	movl	%eax, %ebx
	movl	$camlCode__3, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L112:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L113:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L114:
	movl	%eax, %ebx
	movl	$camlCode__4, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L115:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L116:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L117:
	movl	%eax, %ebx
	movl	$camlCode__5, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L118:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L119:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L120:
	movl	%eax, %ebx
	movl	$camlCode__6, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L121:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L122:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L123:
	movl	%eax, %ebx
	movl	$camlCode__7, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L124:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L125:
	movl	0(%esp), %eax
	addl	$4, %esp
	ret
	.type	camlCode__fun_1051,@function
	.size	camlCode__fun_1051,.-camlCode__fun_1051
	.text
	.align	16
	.globl	camlCode__map_1055
camlCode__map_1055:
	subl	$12, %esp
.L127:
	movl	%eax, %edx
	cmpl	$1, %ebx
	je	.L126
	movl	%ebx, 0(%esp)
	movl	%edx, 4(%esp)
	movl	(%ebx), %eax
	movl	(%edx), %ecx
	movl	%edx, %ebx
	call	*%ecx
.L128:
	movl	%eax, 8(%esp)
	movl	0(%esp), %eax
	movl	4(%eax), %ebx
	movl	4(%esp), %eax
	call	camlCode__map_1055
.L129:
	movl	%eax, %ecx
.L130:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L131
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	8(%esp), %ebx
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	addl	$12, %esp
	ret
	.align	16
.L126:
	movl	$1, %eax
	addl	$12, %esp
	ret
.L131:	call	caml_call_gc
.L132:	jmp	.L130
	.type	camlCode__map_1055,@function
	.size	camlCode__map_1055,.-camlCode__map_1055
	.text
	.align	16
	.globl	camlCode__fun_1058
camlCode__fun_1058:
	subl	$4, %esp
.L133:
	movl	%eax, 0(%esp)
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L134:
	movl	%eax, %ebx
	movl	$camlCode__8, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L135:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L136:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L137:
	movl	%eax, %ebx
	movl	$camlCode__9, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L138:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L139:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L140:
	movl	%eax, %ebx
	movl	$camlCode__10, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L141:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L142:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L143:
	movl	%eax, %ebx
	movl	$camlCode__11, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L144:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L145:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L146:
	movl	%eax, %ebx
	movl	$camlCode__12, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L147:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L148:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L149:
	movl	%eax, %ebx
	movl	$camlCode__13, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L150:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L151:
	movl	0(%esp), %eax
	addl	$4, %esp
	ret
	.type	camlCode__fun_1058,@function
	.size	camlCode__fun_1058,.-camlCode__fun_1058
	.text
	.align	16
	.globl	camlCode__map_1062
camlCode__map_1062:
	subl	$12, %esp
.L153:
	movl	%eax, %edx
	cmpl	$1, %ebx
	je	.L152
	movl	%ebx, 0(%esp)
	movl	%edx, 4(%esp)
	movl	(%ebx), %eax
	movl	(%edx), %ecx
	movl	%edx, %ebx
	call	*%ecx
.L154:
	movl	%eax, 8(%esp)
	movl	0(%esp), %eax
	movl	4(%eax), %ebx
	movl	4(%esp), %eax
	call	camlCode__map_1062
.L155:
	movl	%eax, %ecx
.L156:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L157
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	8(%esp), %ebx
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	addl	$12, %esp
	ret
	.align	16
.L152:
	movl	$1, %eax
	addl	$12, %esp
	ret
.L157:	call	caml_call_gc
.L158:	jmp	.L156
	.type	camlCode__map_1062,@function
	.size	camlCode__map_1062,.-camlCode__map_1062
	.text
	.align	16
	.globl	camlCode__fun_1065
camlCode__fun_1065:
	subl	$4, %esp
.L159:
	movl	%eax, 0(%esp)
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L160:
	movl	%eax, %ebx
	movl	$camlCode__14, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L161:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L162:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L163:
	movl	%eax, %ebx
	movl	$camlCode__15, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L164:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L165:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L166:
	movl	%eax, %ebx
	movl	$camlCode__16, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L167:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L168:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L169:
	movl	%eax, %ebx
	movl	$camlCode__17, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L170:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L171:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L172:
	movl	%eax, %ebx
	movl	$camlCode__18, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L173:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L174:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L175:
	movl	%eax, %ebx
	movl	$camlCode__19, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L176:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	addl	$4, %esp
	jmp	*%ecx
	.type	camlCode__fun_1065,@function
	.size	camlCode__fun_1065,.-camlCode__fun_1065
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$4, %esp
.L182:
	movl	$camlCode__1, %eax
	movl	%eax, camlCode
	movl	$camlCode__25, %eax
	movl	%eax, camlCode + 4
	movl	camlCode, %ebx
	movl	$camlCode__24, %eax
	movl	$camlCode__23, %ecx
	call	camlCode__map_1055
.L183:
	movl	%eax, camlCode + 8
	movl	camlCode, %eax
	cmpl	$1, %eax
	je	.L181
	movl	camlCode, %ebx
	movl	$camlCode__22, %eax
	movl	$camlCode__21, %ecx
	call	camlCode__map_1062
.L184:
	jmp	.L180
.L181:
	movl	$1, %eax
.L180:
	movl	%eax, camlCode + 12
	movl	camlCode, %eax
	movl	$camlCode__20, %ebx
.L178:
	cmpl	$1, %eax
	je	.L179
	movl	4(%eax), %ebx
	movl	%ebx, 0(%esp)
	movl	(%eax), %eax
	call	camlCode__fun_1065
.L185:
	movl	0(%esp), %eax
	jmp	.L178
.L179:
	movl	$1, %eax
.L177:
	movl	%eax, camlCode + 16
	movl	$1, %eax
	addl	$4, %esp
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
	.long	65
	.long	.L185
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L184
	.word	8
	.word	0
	.align	4
	.long	.L183
	.word	8
	.word	0
	.align	4
	.long	.L176
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L175
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L174
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L173
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L172
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L171
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L170
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L169
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L168
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L167
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L166
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L165
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L164
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L163
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L162
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L161
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L160
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L158
	.word	16
	.word	2
	.word	8
	.word	5
	.align	4
	.long	.L155
	.word	16
	.word	1
	.word	8
	.align	4
	.long	.L154
	.word	16
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L151
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L150
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L149
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L148
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L147
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L146
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L145
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L144
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L143
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L142
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L141
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L140
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L139
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L138
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L137
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L136
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L135
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L134
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L132
	.word	16
	.word	2
	.word	8
	.word	5
	.align	4
	.long	.L129
	.word	16
	.word	1
	.word	8
	.align	4
	.long	.L128
	.word	16
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L125
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L124
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L123
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L122
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L121
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L120
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L119
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L118
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L117
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L116
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L115
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L114
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L113
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L112
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L111
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L110
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L109
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L108
	.word	9
	.word	1
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L106
	.word	16
	.word	2
	.word	8
	.word	5
	.align	4
	.long	.L103
	.word	16
	.word	1
	.word	8
	.align	4
	.long	.L102
	.word	16
	.word	2
	.word	0
	.word	4
	.align	4
.L200000:
	.ascii	"printf.ml\0"
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

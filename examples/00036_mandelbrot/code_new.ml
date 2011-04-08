  
  
let runs = 100
let max_iterations = 1000

let iterate ci cr =
  let bailout = 4.0 in
  let rec loop zi zr i =
    if i > max_iterations then
      0
    else
      let temp = zr *. zi and
	  zr2 = zr *. zr and
	  zi2 = zi *. zi in
	if zi2 +. zr2 > bailout then
	  i
	else
	  loop (temp +. temp +. ci) (zr2 -. zi2 +. cr) (i + 1)
  in
    loop 0.0 0.0 1

let mandelbrot n =
  for y = -39 to 38 do
    if 1 = n then print_endline "";
    for x = -39 to 38 do
      let i = iterate
          (float x /. 40.0) (float y /. 40.0 -. 0.5) in
      if 1 = n then
        print_string ( if 0 = i then "*" else " " );
    done
  done;;

let _ =
  let start_time = Sys.time () in
  for iter = 1 to runs do
    mandelbrot iter
  done;
  print_endline "";
  print_float ( Sys.time () -. start_time );
  print_endline "";
(*
-drawlambda
(seq (let (runs/1031 100) (setfield_imm 0 (global Code!) runs/1031))
  (let (max_iterations/1032 1000)
    (setfield_imm 1 (global Code!) max_iterations/1032))
  (let
    (iterate/1033
       (function ci/1034 cr/1035
         (let (bailout/1036 4.0)
           (letrec
             (loop/1037
                (function zi/1038 zr/1039 i/1040
                  (if (> i/1040 (field 1 (global Code!))) 0
                    (let
                      (temp/1041 (*. zr/1039 zi/1038)
                       zr2/1042 (*. zr/1039 zr/1039)
                       zi2/1043 (*. zi/1038 zi/1038))
                      (if (>. (+. zi2/1043 zr2/1042) bailout/1036) i/1040
                        (apply loop/1037
                          (+. (+. temp/1041 temp/1041) ci/1034)
                          (+. (-. zr2/1042 zi2/1043) cr/1035) (+ i/1040 1)))))))
             (apply loop/1037 0.0 0.0 1)))))
    (setfield_imm 2 (global Code!) iterate/1033))
  (let
    (mandelbrot/1044
       (function n/1045
         (for y/1046 -39 to 38
           (seq
             (if (== 1 n/1045) (apply (field 29 (global Pervasives!)) "") 0a)
             (for x/1047 -39 to 38
               (let
                 (i/1048
                    (apply (field 2 (global Code!))
                      (/. (float_of_int x/1047) 40.0)
                      (-. (/. (float_of_int y/1046) 40.0) 0.5)))
                 (if (== 1 n/1045)
                   (apply (field 26 (global Pervasives!))
                     (if (== 0 i/1048) "*" " "))
                   0a)))))))
    (setfield_imm 3 (global Code!) mandelbrot/1044))
  (let (start_time/1049 (caml_sys_time 0a))
    (seq
      (for iter/1050 1 to (field 0 (global Code!))
        (apply (field 3 (global Code!)) iter/1050))
      (apply (field 29 (global Pervasives!)) "")
      (apply (field 28 (global Pervasives!))
        (-. (caml_sys_time 0a) start_time/1049))
      (apply (field 29 (global Pervasives!)) "")))
  0a)
[inline] iterate_1033 cannot be inlined: local fun
Before TonSlambda.optimize:
(seq (setfield_imm 0 (global camlCode!) 100)
  (setfield_imm 1 (global camlCode!) 1000)
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (exit 12
                                            (if (> i/1040 1000) 0
                                              (let
                                                (temp/1041
                                                   (*. zr/1039 zi/1038)
                                                 zr2/1042
                                                   (*. zr/1039 zr/1039)
                                                 zi2/1043
                                                   (*. zi/1038 zi/1038))
                                                (if
                                                  (>. (+. zi2/1043 zr2/1042)
                                                    (field 5 env/1064))
                                                  i/1040
                                                  (let
                                                    (arg/1055
                                                       (+.
                                                         (+. temp/1041
                                                           temp/1041)
                                                         (field 3 env/1064))
                                                     arg/1056
                                                       (+.
                                                         (-. zr2/1042
                                                           zi2/1043)
                                                         (field 4 env/1064))
                                                     arg/1057 (+ i/1040 1))
                                                    (seq
                                                      (assign i/1040
                                                        arg/1057)
                                                      (assign zr/1039
                                                        arg/1056)
                                                      (assign zi/1038
                                                        arg/1055)
                                                      (exit 11)))))))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (exit 12
                            (if (> i/1065 1000) 0
                              (let
                                (temp/1068 (*. zr/1066 zi/1067)
                                 zr2/1069 (*. zr/1066 zr/1066)
                                 zi2/1070 (*. zi/1067 zi/1067))
                                (if
                                  (>. (+. zi2/1070 zr2/1069)
                                    (field 5 loop/1037))
                                  i/1065
                                  (let
                                    (arg/1071
                                       (+. (+. temp/1068 temp/1068)
                                         (field 3 loop/1037))
                                     arg/1072
                                       (+. (-. zr2/1069 zi2/1070)
                                         (field 4 loop/1037))
                                     arg/1073 (+ i/1065 1))
                                    (seq (assign i/1065 arg/1073)
                                      (assign zr/1066 arg/1072)
                                      (assign zi/1067 arg/1071) (exit 11)))))))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} ))
    (setfield_imm 2 (global camlCode!) iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (for y/1046 -39 to 38
                    (seq
                      (if (== 1 n/1045)
                        (seq
                          (let (oc/1075 (field 23 (global camlPervasives!)))
                            (caml_ml_output oc/1075 "" 0 (string.length "")))
                          (caml_ml_output_char
                            (field 23 (global camlPervasives!)) '\n')
                          (caml_ml_flush (field 23 (global camlPervasives!))))
                        0a)
                      (for x/1047 -39 to 38
                        (let
                          (i/1048
                             (camlCode__iterate_1033 
                               (/. (float_of_int x/1047) 40.0)
                               (-. (/. (float_of_int y/1046) 40.0) 0.5)))
                          (if (== 1 n/1045)
                            (let
                              (s/1076 (if (== 0 i/1048) "*" " ")
                               oc/1077 (field 23 (global camlPervasives!)))
                              (caml_ml_output oc/1077 s/1076 0
                                (string.length s/1076)))
                            0a)))))) {2} ))
    (setfield_imm 3 (global camlCode!) mandelbrot/1044))
  (let (start_time/1049 (caml_sys_time 0a))
    (seq
      (for iter/1050 1 to 100
        (for y/1078 -39 to 38
          (seq
            (if (== 1 iter/1050)
              (seq
                (let (oc/1083 (field 23 (global camlPervasives!)))
                  (caml_ml_output oc/1083 "" 0 (string.length "")))
                (caml_ml_output_char (field 23 (global camlPervasives!))
                  '\n')
                (caml_ml_flush (field 23 (global camlPervasives!))))
              0a)
            (for x/1079 -39 to 38
              (let
                (i/1080
                   (camlCode__iterate_1033  (/. (float_of_int x/1079) 40.0)
                     (-. (/. (float_of_int y/1078) 40.0) 0.5)))
                (if (== 1 iter/1050)
                  (let
                    (s/1081 (if (== 0 i/1080) "*" " ")
                     oc/1082 (field 23 (global camlPervasives!)))
                    (caml_ml_output oc/1082 s/1081 0 (string.length s/1081)))
                  0a))))))
      (let (oc/1084 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1084 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))
      (let
        (f/1085 (-. (caml_sys_time 0a) start_time/1049)
         s/1086
           (camlPervasives__valid_float_lexem_1136 
             (caml_format_float "%.12g" f/1085))
         oc/1087 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1087 s/1086 0 (string.length s/1086)))
      (let (oc/1088 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1088 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))))
  0a)
After TonSlambda.optimize:
(seq
  (let (temp/1207 (global camlCode!) temp/1208 100)
    (setfield_imm 0 temp/1207 temp/1208))
  (let (temp/1205 (global camlCode!) temp/1206 1000)
    (setfield_imm 1 temp/1205 temp/1206))
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (let
                                            (temp/1194
                                               (let
                                                 (temp/1195
                                                    (let (temp/1196 1000)
                                                      (> i/1040 temp/1196)))
                                                 (if temp/1195 0
                                                   (let
                                                     (temp/1041
                                                        (*. zr/1039 zi/1038)
                                                      zr2/1042
                                                        (*. zr/1039 zr/1039)
                                                      zi2/1043
                                                        (*. zi/1038 zi/1038)
                                                      temp/1197
                                                        (let
                                                          (temp/1198
                                                             (+. zi2/1043
                                                               zr2/1042)
                                                           temp/1199
                                                             (field 5
                                                               env/1064))
                                                          (>. temp/1198
                                                            temp/1199)))
                                                     (if temp/1197 i/1040
                                                       (let
                                                         (arg/1055
                                                            (let
                                                              (temp/1203
                                                                 (+.
                                                                   temp/1041
                                                                   temp/1041)
                                                               temp/1204
                                                                 (field 3
                                                                   env/1064))
                                                              (+. temp/1203
                                                                temp/1204))
                                                          arg/1056
                                                            (let
                                                              (temp/1201
                                                                 (-. zr2/1042
                                                                   zi2/1043)
                                                               temp/1202
                                                                 (field 4
                                                                   env/1064))
                                                              (+. temp/1201
                                                                temp/1202))
                                                          arg/1057
                                                            (let
                                                              (temp/1200 1)
                                                              (+ i/1040
                                                                temp/1200)))
                                                         (seq
                                                           (assign i/1040
                                                             arg/1057)
                                                           (assign zr/1039
                                                             arg/1056)
                                                           (assign zi/1038
                                                             arg/1055)
                                                           (exit 11))))))))
                                            (exit 12 temp/1194))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (let
                            (temp/1183
                               (let
                                 (temp/1184
                                    (let (temp/1185 1000)
                                      (> i/1065 temp/1185)))
                                 (if temp/1184 0
                                   (let
                                     (temp/1068 (*. zr/1066 zi/1067)
                                      zr2/1069 (*. zr/1066 zr/1066)
                                      zi2/1070 (*. zi/1067 zi/1067)
                                      temp/1186
                                        (let
                                          (temp/1187 (+. zi2/1070 zr2/1069)
                                           temp/1188 (field 5 loop/1037))
                                          (>. temp/1187 temp/1188)))
                                     (if temp/1186 i/1065
                                       (let
                                         (arg/1071
                                            (let
                                              (temp/1192
                                                 (+. temp/1068 temp/1068)
                                               temp/1193 (field 3 loop/1037))
                                              (+. temp/1192 temp/1193))
                                          arg/1072
                                            (let
                                              (temp/1190
                                                 (-. zr2/1069 zi2/1070)
                                               temp/1191 (field 4 loop/1037))
                                              (+. temp/1190 temp/1191))
                                          arg/1073
                                            (let (temp/1189 1)
                                              (+ i/1065 temp/1189)))
                                         (seq (assign i/1065 arg/1073)
                                           (assign zr/1066 arg/1072)
                                           (assign zi/1067 arg/1071)
                                           (exit 11))))))))
                            (exit 12 temp/1183))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} )
     temp/1182 (global camlCode!))
    (setfield_imm 2 temp/1182 iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (let (temp/1151 -39 temp/1152 38)
                    (for y/1046 temp/1151 to temp/1152
                      (seq
                        (let
                          (temp/1170
                             (let (temp/1171 1) (== temp/1171 n/1045)))
                          (if temp/1170
                            (seq
                              (let
                                (oc/1075
                                   (let (temp/1181 (global camlPervasives!))
                                     (field 23 temp/1181))
                                 temp/1177 ""
                                 temp/1178 0
                                 temp/1179
                                   (let (temp/1180 "")
                                     (string.length temp/1180)))
                                (caml_ml_output oc/1075 temp/1177 temp/1178
                                  temp/1179))
                              (let
                                (temp/1174
                                   (let (temp/1175 (global camlPervasives!))
                                     (field 23 temp/1175))
                                 temp/1176 '\n')
                                (caml_ml_output_char temp/1174 temp/1176))
                              (let
                                (temp/1172
                                   (let (temp/1173 (global camlPervasives!))
                                     (field 23 temp/1173)))
                                (caml_ml_flush temp/1172)))
                            0a))
                        (let (temp/1153 -39 temp/1154 38)
                          (for x/1047 temp/1153 to temp/1154
                            (let
                              (i/1048
                                 (let
                                   (temp/1162
                                      (let
                                        (temp/1163 (float_of_int x/1047)
                                         temp/1164 40.0)
                                        (/. temp/1163 temp/1164))
                                    temp/1165
                                      (let
                                        (temp/1166
                                           (let
                                             (temp/1167 (float_of_int y/1046)
                                              temp/1168 40.0)
                                             (/. temp/1167 temp/1168))
                                         temp/1169 0.5)
                                        (-. temp/1166 temp/1169)))
                                   (camlCode__iterate_1033  temp/1162
                                     temp/1165))
                               temp/1155
                                 (let (temp/1156 1) (== temp/1156 n/1045)))
                              (if temp/1155
                                (let
                                  (s/1076
                                     (let
                                       (temp/1160
                                          (let (temp/1161 0)
                                            (== temp/1161 i/1048)))
                                       (if temp/1160 "*" " "))
                                   oc/1077
                                     (let
                                       (temp/1159 (global camlPervasives!))
                                       (field 23 temp/1159))
                                   temp/1157 0
                                   temp/1158 (string.length s/1076))
                                  (caml_ml_output oc/1077 s/1076 temp/1157
                                    temp/1158))
                                0a)))))))) {2} )
     temp/1150 (global camlCode!))
    (setfield_imm 3 temp/1150 mandelbrot/1044))
  (let (start_time/1049 (let (temp/1149 0a) (caml_sys_time temp/1149)))
    (seq
      (let (temp/1116 1 temp/1117 100)
        (for iter/1050 temp/1116 to temp/1117
          (let (temp/1118 -39 temp/1119 38)
            (for y/1078 temp/1118 to temp/1119
              (seq
                (let (temp/1137 (let (temp/1138 1) (== temp/1138 iter/1050)))
                  (if temp/1137
                    (seq
                      (let
                        (oc/1083
                           (let (temp/1148 (global camlPervasives!))
                             (field 23 temp/1148))
                         temp/1144 ""
                         temp/1145 0
                         temp/1146
                           (let (temp/1147 "") (string.length temp/1147)))
                        (caml_ml_output oc/1083 temp/1144 temp/1145
                          temp/1146))
                      (let
                        (temp/1141
                           (let (temp/1142 (global camlPervasives!))
                             (field 23 temp/1142))
                         temp/1143 '\n')
                        (caml_ml_output_char temp/1141 temp/1143))
                      (let
                        (temp/1139
                           (let (temp/1140 (global camlPervasives!))
                             (field 23 temp/1140)))
                        (caml_ml_flush temp/1139)))
                    0a))
                (let (temp/1120 -39 temp/1121 38)
                  (for x/1079 temp/1120 to temp/1121
                    (let
                      (i/1080
                         (let
                           (temp/1129
                              (let
                                (temp/1130 (float_of_int x/1079)
                                 temp/1131 40.0)
                                (/. temp/1130 temp/1131))
                            temp/1132
                              (let
                                (temp/1133
                                   (let
                                     (temp/1134 (float_of_int y/1078)
                                      temp/1135 40.0)
                                     (/. temp/1134 temp/1135))
                                 temp/1136 0.5)
                                (-. temp/1133 temp/1136)))
                           (camlCode__iterate_1033  temp/1129 temp/1132))
                       temp/1122 (let (temp/1123 1) (== temp/1123 iter/1050)))
                      (if temp/1122
                        (let
                          (s/1081
                             (let
                               (temp/1127
                                  (let (temp/1128 0) (== temp/1128 i/1080)))
                               (if temp/1127 "*" " "))
                           oc/1082
                             (let (temp/1126 (global camlPervasives!))
                               (field 23 temp/1126))
                           temp/1124 0
                           temp/1125 (string.length s/1081))
                          (caml_ml_output oc/1082 s/1081 temp/1124 temp/1125))
                        0a)))))))))
      (let
        (oc/1084
           (let (temp/1115 (global camlPervasives!)) (field 23 temp/1115))
         temp/1111 ""
         temp/1112 0
         temp/1113 (let (temp/1114 "") (string.length temp/1114)))
        (caml_ml_output oc/1084 temp/1111 temp/1112 temp/1113))
      (let
        (temp/1108
           (let (temp/1109 (global camlPervasives!)) (field 23 temp/1109))
         temp/1110 '\n')
        (caml_ml_output_char temp/1108 temp/1110))
      (let
        (temp/1106
           (let (temp/1107 (global camlPervasives!)) (field 23 temp/1107)))
        (caml_ml_flush temp/1106))
      (let
        (f/1085
           (let (temp/1104 (let (temp/1105 0a) (caml_sys_time temp/1105)))
             (-. temp/1104 start_time/1049))
         s/1086
           (let
             (temp/1102
                (let (temp/1103 "%.12g")
                  (caml_format_float temp/1103 f/1085)))
             (camlPervasives__valid_float_lexem_1136  temp/1102))
         oc/1087
           (let (temp/1101 (global camlPervasives!)) (field 23 temp/1101))
         temp/1099 0
         temp/1100 (string.length s/1086))
        (caml_ml_output oc/1087 s/1086 temp/1099 temp/1100))
      (let
        (oc/1088
           (let (temp/1098 (global camlPervasives!)) (field 23 temp/1098))
         temp/1094 ""
         temp/1095 0
         temp/1096 (let (temp/1097 "") (string.length temp/1097)))
        (caml_ml_output oc/1088 temp/1094 temp/1095 temp/1096))
      (let
        (temp/1091
           (let (temp/1092 (global camlPervasives!)) (field 23 temp/1092))
         temp/1093 '\n')
        (caml_ml_output_char temp/1091 temp/1093))
      (let
        (temp/1089
           (let (temp/1090 (global camlPervasives!)) (field 23 temp/1090)))
        (caml_ml_flush temp/1089))))
  0a)
Before TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (setfield_imm 0 temp/1207 100)
    (let (temp/1205 (global camlCode!))
      (seq (setfield_imm 1 temp/1205 1000)
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184 (> i/1065 1000)
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073 (+ i/1065 1))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (for y/1046 -39 to 38
                              (let (temp/1170 (== 1 n/1045))
                                (seq
                                  (if temp/1170
                                    (let
                                      (temp/1181 (global camlPervasives!)
                                       oc/1075 (field 23 temp/1181)
                                       temp/1177 ""
                                       temp/1180 ""
                                       temp/1179 (string.length temp/1180))
                                      (seq
                                        (caml_ml_output oc/1075 temp/1177 0
                                          temp/1179)
                                        (let
                                          (temp/1175 (global camlPervasives!)
                                           temp/1174 (field 23 temp/1175))
                                          (seq
                                            (caml_ml_output_char temp/1174
                                              10)
                                            (let
                                              (temp/1173
                                                 (global camlPervasives!)
                                               temp/1172 (field 23 temp/1173))
                                              (caml_ml_flush temp/1172))))))
                                    0a)
                                  (for x/1047 -39 to 38
                                    (let
                                      (temp/1163 (float_of_int x/1047)
                                       temp/1164 40.0
                                       temp/1162 (/. temp/1163 temp/1164)
                                       temp/1167 (float_of_int y/1046)
                                       temp/1168 40.0
                                       temp/1166 (/. temp/1167 temp/1168)
                                       temp/1169 0.5
                                       temp/1165 (-. temp/1166 temp/1169)
                                       i/1048
                                         (camlCode__iterate_1033  temp/1162
                                           temp/1165)
                                       temp/1155 (== 1 n/1045))
                                      (if temp/1155
                                        (let
                                          (temp/1160 (== 0 i/1048)
                                           s/1076 (if temp/1160 "*" " ")
                                           temp/1159 (global camlPervasives!)
                                           oc/1077 (field 23 temp/1159)
                                           temp/1158 (string.length s/1076))
                                          (caml_ml_output oc/1077 s/1076 0
                                            temp/1158))
                                        0a))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let (start_time/1049 (caml_sys_time 0a))
                  (seq
                    (seq
                      (for iter/1050 1 to 100
                        (for y/1078 -39 to 38
                          (let (temp/1137 (== 1 iter/1050))
                            (seq
                              (if temp/1137
                                (let
                                  (temp/1148 (global camlPervasives!)
                                   oc/1083 (field 23 temp/1148)
                                   temp/1144 ""
                                   temp/1147 ""
                                   temp/1146 (string.length temp/1147))
                                  (seq
                                    (caml_ml_output oc/1083 temp/1144 0
                                      temp/1146)
                                    (let
                                      (temp/1142 (global camlPervasives!)
                                       temp/1141 (field 23 temp/1142))
                                      (seq (caml_ml_output_char temp/1141 10)
                                        (let
                                          (temp/1140 (global camlPervasives!)
                                           temp/1139 (field 23 temp/1140))
                                          (caml_ml_flush temp/1139))))))
                                0a)
                              (for x/1079 -39 to 38
                                (let
                                  (temp/1130 (float_of_int x/1079)
                                   temp/1131 40.0
                                   temp/1129 (/. temp/1130 temp/1131)
                                   temp/1134 (float_of_int y/1078)
                                   temp/1135 40.0
                                   temp/1133 (/. temp/1134 temp/1135)
                                   temp/1136 0.5
                                   temp/1132 (-. temp/1133 temp/1136)
                                   i/1080
                                     (camlCode__iterate_1033  temp/1129
                                       temp/1132)
                                   temp/1122 (== 1 iter/1050))
                                  (if temp/1122
                                    (let
                                      (temp/1127 (== 0 i/1080)
                                       s/1081 (if temp/1127 "*" " ")
                                       temp/1126 (global camlPervasives!)
                                       oc/1082 (field 23 temp/1126)
                                       temp/1125 (string.length s/1081))
                                      (caml_ml_output oc/1082 s/1081 0
                                        temp/1125))
                                    0a)))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq (caml_ml_output oc/1084 temp/1111 0 temp/1113)
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq (caml_ml_output_char temp/1108 10)
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104 (caml_sys_time 0a)
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq (caml_ml_output oc/1087 s/1086 0 temp/1100)
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (caml_ml_output oc/1088 temp/1094 0
                                    temp/1096)
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq (caml_ml_output_char temp/1091 10)
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
After TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (let (temp/1241 100) (setfield_imm 0 temp/1207 temp/1241))
    (let (temp/1205 (global camlCode!))
      (seq (let (temp/1240 1000) (setfield_imm 1 temp/1205 temp/1240))
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184
                                     (let (temp/1239 1000)
                                       (> i/1065 temp/1239))
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073
                                                (let (temp/1238 1)
                                                  (+ i/1065 temp/1238)))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (let (temp/1228 -39 temp/1229 38)
                              (for y/1046 temp/1228 to temp/1229
                                (let
                                  (temp/1170
                                     (let (temp/1237 1)
                                       (== temp/1237 n/1045)))
                                  (seq
                                    (if temp/1170
                                      (let
                                        (temp/1181 (global camlPervasives!)
                                         oc/1075 (field 23 temp/1181)
                                         temp/1177 ""
                                         temp/1180 ""
                                         temp/1179 (string.length temp/1180))
                                        (seq
                                          (let (temp/1236 0)
                                            (caml_ml_output oc/1075 temp/1177
                                              temp/1236 temp/1179))
                                          (let
                                            (temp/1175
                                               (global camlPervasives!)
                                             temp/1174 (field 23 temp/1175))
                                            (seq
                                              (let (temp/1235 10)
                                                (caml_ml_output_char
                                                  temp/1174 temp/1235))
                                              (let
                                                (temp/1173
                                                   (global camlPervasives!)
                                                 temp/1172
                                                   (field 23 temp/1173))
                                                (caml_ml_flush temp/1172))))))
                                      0a)
                                    (let (temp/1230 -39 temp/1231 38)
                                      (for x/1047 temp/1230 to temp/1231
                                        (let
                                          (temp/1163 (float_of_int x/1047)
                                           temp/1164 40.0
                                           temp/1162 (/. temp/1163 temp/1164)
                                           temp/1167 (float_of_int y/1046)
                                           temp/1168 40.0
                                           temp/1166 (/. temp/1167 temp/1168)
                                           temp/1169 0.5
                                           temp/1165 (-. temp/1166 temp/1169)
                                           i/1048
                                             (camlCode__iterate_1033 
                                               temp/1162 temp/1165)
                                           temp/1155
                                             (let (temp/1234 1)
                                               (== temp/1234 n/1045)))
                                          (if temp/1155
                                            (let
                                              (temp/1160
                                                 (let (temp/1233 0)
                                                   (== temp/1233 i/1048))
                                               s/1076 (if temp/1160 "*" " ")
                                               temp/1159
                                                 (global camlPervasives!)
                                               oc/1077 (field 23 temp/1159)
                                               temp/1158
                                                 (string.length s/1076)
                                               temp/1232 0)
                                              (caml_ml_output oc/1077 s/1076
                                                temp/1232 temp/1158))
                                            0a))))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let
                  (start_time/1049
                     (let (temp/1227 0a) (caml_sys_time temp/1227)))
                  (seq
                    (seq
                      (let (temp/1215 1 temp/1216 100)
                        (for iter/1050 temp/1215 to temp/1216
                          (let (temp/1217 -39 temp/1218 38)
                            (for y/1078 temp/1217 to temp/1218
                              (let
                                (temp/1137
                                   (let (temp/1226 1)
                                     (== temp/1226 iter/1050)))
                                (seq
                                  (if temp/1137
                                    (let
                                      (temp/1148 (global camlPervasives!)
                                       oc/1083 (field 23 temp/1148)
                                       temp/1144 ""
                                       temp/1147 ""
                                       temp/1146 (string.length temp/1147))
                                      (seq
                                        (let (temp/1225 0)
                                          (caml_ml_output oc/1083 temp/1144
                                            temp/1225 temp/1146))
                                        (let
                                          (temp/1142 (global camlPervasives!)
                                           temp/1141 (field 23 temp/1142))
                                          (seq
                                            (let (temp/1224 10)
                                              (caml_ml_output_char temp/1141
                                                temp/1224))
                                            (let
                                              (temp/1140
                                                 (global camlPervasives!)
                                               temp/1139 (field 23 temp/1140))
                                              (caml_ml_flush temp/1139))))))
                                    0a)
                                  (let (temp/1219 -39 temp/1220 38)
                                    (for x/1079 temp/1219 to temp/1220
                                      (let
                                        (temp/1130 (float_of_int x/1079)
                                         temp/1131 40.0
                                         temp/1129 (/. temp/1130 temp/1131)
                                         temp/1134 (float_of_int y/1078)
                                         temp/1135 40.0
                                         temp/1133 (/. temp/1134 temp/1135)
                                         temp/1136 0.5
                                         temp/1132 (-. temp/1133 temp/1136)
                                         i/1080
                                           (camlCode__iterate_1033  temp/1129
                                             temp/1132)
                                         temp/1122
                                           (let (temp/1223 1)
                                             (== temp/1223 iter/1050)))
                                        (if temp/1122
                                          (let
                                            (temp/1127
                                               (let (temp/1222 0)
                                                 (== temp/1222 i/1080))
                                             s/1081 (if temp/1127 "*" " ")
                                             temp/1126
                                               (global camlPervasives!)
                                             oc/1082 (field 23 temp/1126)
                                             temp/1125 (string.length s/1081)
                                             temp/1221 0)
                                            (caml_ml_output oc/1082 s/1081
                                              temp/1221 temp/1125))
                                          0a))))))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq
                            (let (temp/1214 0)
                              (caml_ml_output oc/1084 temp/1111 temp/1214
                                temp/1113))
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq
                                (let (temp/1213 10)
                                  (caml_ml_output_char temp/1108 temp/1213))
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104
                               (let (temp/1212 0a) (caml_sys_time temp/1212))
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq
                              (let (temp/1211 0)
                                (caml_ml_output oc/1087 s/1086 temp/1211
                                  temp/1100))
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (let (temp/1210 0)
                                    (caml_ml_output oc/1088 temp/1094
                                      temp/1210 temp/1096))
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq
                                      (let (temp/1209 10)
                                        (caml_ml_output_char temp/1091
                                          temp/1209))
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
Before TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
After TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
Before TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
After TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
Before TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))
After TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))
-dlambda
(seq (let (runs/1031 100) (setfield_imm 0 (global Code!) runs/1031))
  (let (max_iterations/1032 1000)
    (setfield_imm 1 (global Code!) max_iterations/1032))
  (let
    (iterate/1033
       (function ci/1034 cr/1035
         (let (bailout/1036 4.0)
           (letrec
             (loop/1037
                (function zi/1038 zr/1039 i/1040
                  (if (> i/1040 (field 1 (global Code!))) 0
                    (let
                      (temp/1041 (*. zr/1039 zi/1038)
                       zr2/1042 (*. zr/1039 zr/1039)
                       zi2/1043 (*. zi/1038 zi/1038))
                      (if (>. (+. zi2/1043 zr2/1042) bailout/1036) i/1040
                        (apply loop/1037
                          (+. (+. temp/1041 temp/1041) ci/1034)
                          (+. (-. zr2/1042 zi2/1043) cr/1035) (+ i/1040 1)))))))
             (apply loop/1037 0.0 0.0 1)))))
    (setfield_imm 2 (global Code!) iterate/1033))
  (let
    (mandelbrot/1044
       (function n/1045
         (for y/1046 -39 to 38
           (seq
             (if (== 1 n/1045) (apply (field 29 (global Pervasives!)) "") 0a)
             (for x/1047 -39 to 38
               (let
                 (i/1048
                    (apply (field 2 (global Code!))
                      (/. (float_of_int x/1047) 40.0)
                      (-. (/. (float_of_int y/1046) 40.0) 0.5)))
                 (if (== 1 n/1045)
                   (apply (field 26 (global Pervasives!))
                     (if (== 0 i/1048) "*" " "))
                   0a)))))))
    (setfield_imm 3 (global Code!) mandelbrot/1044))
  (let (start_time/1049 (caml_sys_time 0a))
    (seq
      (for iter/1050 1 to (field 0 (global Code!))
        (apply (field 3 (global Code!)) iter/1050))
      (apply (field 29 (global Pervasives!)) "")
      (apply (field 28 (global Pervasives!))
        (-. (caml_sys_time 0a) start_time/1049))
      (apply (field 29 (global Pervasives!)) "")))
  0a)
checking tailcall on loop/1037
stats_rec_removed : 1
(loop_1037) 
stats_tailcall_removed : 1
(loop_1037) 
stats_rec_removed : 0

stats_tailcall_removed : 0

[inline] iterate_1033 cannot be inlined: local fun
Before TonSlambda.optimize:
(seq (setfield_imm 0 (global camlCode!) 100)
  (setfield_imm 1 (global camlCode!) 1000)
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (exit 12
                                            (if (> i/1040 1000) 0
                                              (let
                                                (temp/1041
                                                   (*. zr/1039 zi/1038)
                                                 zr2/1042
                                                   (*. zr/1039 zr/1039)
                                                 zi2/1043
                                                   (*. zi/1038 zi/1038))
                                                (if
                                                  (>. (+. zi2/1043 zr2/1042)
                                                    (field 5 env/1064))
                                                  i/1040
                                                  (let
                                                    (arg/1055
                                                       (+.
                                                         (+. temp/1041
                                                           temp/1041)
                                                         (field 3 env/1064))
                                                     arg/1056
                                                       (+.
                                                         (-. zr2/1042
                                                           zi2/1043)
                                                         (field 4 env/1064))
                                                     arg/1057 (+ i/1040 1))
                                                    (seq
                                                      (assign i/1040
                                                        arg/1057)
                                                      (assign zr/1039
                                                        arg/1056)
                                                      (assign zi/1038
                                                        arg/1055)
                                                      (exit 11)))))))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (exit 12
                            (if (> i/1065 1000) 0
                              (let
                                (temp/1068 (*. zr/1066 zi/1067)
                                 zr2/1069 (*. zr/1066 zr/1066)
                                 zi2/1070 (*. zi/1067 zi/1067))
                                (if
                                  (>. (+. zi2/1070 zr2/1069)
                                    (field 5 loop/1037))
                                  i/1065
                                  (let
                                    (arg/1071
                                       (+. (+. temp/1068 temp/1068)
                                         (field 3 loop/1037))
                                     arg/1072
                                       (+. (-. zr2/1069 zi2/1070)
                                         (field 4 loop/1037))
                                     arg/1073 (+ i/1065 1))
                                    (seq (assign i/1065 arg/1073)
                                      (assign zr/1066 arg/1072)
                                      (assign zi/1067 arg/1071) (exit 11)))))))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} ))
    (setfield_imm 2 (global camlCode!) iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (for y/1046 -39 to 38
                    (seq
                      (if (== 1 n/1045)
                        (seq
                          (let (oc/1075 (field 23 (global camlPervasives!)))
                            (caml_ml_output oc/1075 "" 0 (string.length "")))
                          (caml_ml_output_char
                            (field 23 (global camlPervasives!)) '\n')
                          (caml_ml_flush (field 23 (global camlPervasives!))))
                        0a)
                      (for x/1047 -39 to 38
                        (let
                          (i/1048
                             (camlCode__iterate_1033 
                               (/. (float_of_int x/1047) 40.0)
                               (-. (/. (float_of_int y/1046) 40.0) 0.5)))
                          (if (== 1 n/1045)
                            (let
                              (s/1076 (if (== 0 i/1048) "*" " ")
                               oc/1077 (field 23 (global camlPervasives!)))
                              (caml_ml_output oc/1077 s/1076 0
                                (string.length s/1076)))
                            0a)))))) {2} ))
    (setfield_imm 3 (global camlCode!) mandelbrot/1044))
  (let (start_time/1049 (caml_sys_time 0a))
    (seq
      (for iter/1050 1 to 100
        (for y/1078 -39 to 38
          (seq
            (if (== 1 iter/1050)
              (seq
                (let (oc/1083 (field 23 (global camlPervasives!)))
                  (caml_ml_output oc/1083 "" 0 (string.length "")))
                (caml_ml_output_char (field 23 (global camlPervasives!))
                  '\n')
                (caml_ml_flush (field 23 (global camlPervasives!))))
              0a)
            (for x/1079 -39 to 38
              (let
                (i/1080
                   (camlCode__iterate_1033  (/. (float_of_int x/1079) 40.0)
                     (-. (/. (float_of_int y/1078) 40.0) 0.5)))
                (if (== 1 iter/1050)
                  (let
                    (s/1081 (if (== 0 i/1080) "*" " ")
                     oc/1082 (field 23 (global camlPervasives!)))
                    (caml_ml_output oc/1082 s/1081 0 (string.length s/1081)))
                  0a))))))
      (let (oc/1084 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1084 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))
      (let
        (f/1085 (-. (caml_sys_time 0a) start_time/1049)
         s/1086
           (camlPervasives__valid_float_lexem_1136 
             (caml_format_float "%.12g" f/1085))
         oc/1087 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1087 s/1086 0 (string.length s/1086)))
      (let (oc/1088 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1088 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))))
  0a)
After TonSlambda.optimize:
(seq
  (let (temp/1207 (global camlCode!) temp/1208 100)
    (setfield_imm 0 temp/1207 temp/1208))
  (let (temp/1205 (global camlCode!) temp/1206 1000)
    (setfield_imm 1 temp/1205 temp/1206))
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (let
                                            (temp/1194
                                               (let
                                                 (temp/1195
                                                    (let (temp/1196 1000)
                                                      (> i/1040 temp/1196)))
                                                 (if temp/1195 0
                                                   (let
                                                     (temp/1041
                                                        (*. zr/1039 zi/1038)
                                                      zr2/1042
                                                        (*. zr/1039 zr/1039)
                                                      zi2/1043
                                                        (*. zi/1038 zi/1038)
                                                      temp/1197
                                                        (let
                                                          (temp/1198
                                                             (+. zi2/1043
                                                               zr2/1042)
                                                           temp/1199
                                                             (field 5
                                                               env/1064))
                                                          (>. temp/1198
                                                            temp/1199)))
                                                     (if temp/1197 i/1040
                                                       (let
                                                         (arg/1055
                                                            (let
                                                              (temp/1203
                                                                 (+.
                                                                   temp/1041
                                                                   temp/1041)
                                                               temp/1204
                                                                 (field 3
                                                                   env/1064))
                                                              (+. temp/1203
                                                                temp/1204))
                                                          arg/1056
                                                            (let
                                                              (temp/1201
                                                                 (-. zr2/1042
                                                                   zi2/1043)
                                                               temp/1202
                                                                 (field 4
                                                                   env/1064))
                                                              (+. temp/1201
                                                                temp/1202))
                                                          arg/1057
                                                            (let
                                                              (temp/1200 1)
                                                              (+ i/1040
                                                                temp/1200)))
                                                         (seq
                                                           (assign i/1040
                                                             arg/1057)
                                                           (assign zr/1039
                                                             arg/1056)
                                                           (assign zi/1038
                                                             arg/1055)
                                                           (exit 11))))))))
                                            (exit 12 temp/1194))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (let
                            (temp/1183
                               (let
                                 (temp/1184
                                    (let (temp/1185 1000)
                                      (> i/1065 temp/1185)))
                                 (if temp/1184 0
                                   (let
                                     (temp/1068 (*. zr/1066 zi/1067)
                                      zr2/1069 (*. zr/1066 zr/1066)
                                      zi2/1070 (*. zi/1067 zi/1067)
                                      temp/1186
                                        (let
                                          (temp/1187 (+. zi2/1070 zr2/1069)
                                           temp/1188 (field 5 loop/1037))
                                          (>. temp/1187 temp/1188)))
                                     (if temp/1186 i/1065
                                       (let
                                         (arg/1071
                                            (let
                                              (temp/1192
                                                 (+. temp/1068 temp/1068)
                                               temp/1193 (field 3 loop/1037))
                                              (+. temp/1192 temp/1193))
                                          arg/1072
                                            (let
                                              (temp/1190
                                                 (-. zr2/1069 zi2/1070)
                                               temp/1191 (field 4 loop/1037))
                                              (+. temp/1190 temp/1191))
                                          arg/1073
                                            (let (temp/1189 1)
                                              (+ i/1065 temp/1189)))
                                         (seq (assign i/1065 arg/1073)
                                           (assign zr/1066 arg/1072)
                                           (assign zi/1067 arg/1071)
                                           (exit 11))))))))
                            (exit 12 temp/1183))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} )
     temp/1182 (global camlCode!))
    (setfield_imm 2 temp/1182 iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (let (temp/1151 -39 temp/1152 38)
                    (for y/1046 temp/1151 to temp/1152
                      (seq
                        (let
                          (temp/1170
                             (let (temp/1171 1) (== temp/1171 n/1045)))
                          (if temp/1170
                            (seq
                              (let
                                (oc/1075
                                   (let (temp/1181 (global camlPervasives!))
                                     (field 23 temp/1181))
                                 temp/1177 ""
                                 temp/1178 0
                                 temp/1179
                                   (let (temp/1180 "")
                                     (string.length temp/1180)))
                                (caml_ml_output oc/1075 temp/1177 temp/1178
                                  temp/1179))
                              (let
                                (temp/1174
                                   (let (temp/1175 (global camlPervasives!))
                                     (field 23 temp/1175))
                                 temp/1176 '\n')
                                (caml_ml_output_char temp/1174 temp/1176))
                              (let
                                (temp/1172
                                   (let (temp/1173 (global camlPervasives!))
                                     (field 23 temp/1173)))
                                (caml_ml_flush temp/1172)))
                            0a))
                        (let (temp/1153 -39 temp/1154 38)
                          (for x/1047 temp/1153 to temp/1154
                            (let
                              (i/1048
                                 (let
                                   (temp/1162
                                      (let
                                        (temp/1163 (float_of_int x/1047)
                                         temp/1164 40.0)
                                        (/. temp/1163 temp/1164))
                                    temp/1165
                                      (let
                                        (temp/1166
                                           (let
                                             (temp/1167 (float_of_int y/1046)
                                              temp/1168 40.0)
                                             (/. temp/1167 temp/1168))
                                         temp/1169 0.5)
                                        (-. temp/1166 temp/1169)))
                                   (camlCode__iterate_1033  temp/1162
                                     temp/1165))
                               temp/1155
                                 (let (temp/1156 1) (== temp/1156 n/1045)))
                              (if temp/1155
                                (let
                                  (s/1076
                                     (let
                                       (temp/1160
                                          (let (temp/1161 0)
                                            (== temp/1161 i/1048)))
                                       (if temp/1160 "*" " "))
                                   oc/1077
                                     (let
                                       (temp/1159 (global camlPervasives!))
                                       (field 23 temp/1159))
                                   temp/1157 0
                                   temp/1158 (string.length s/1076))
                                  (caml_ml_output oc/1077 s/1076 temp/1157
                                    temp/1158))
                                0a)))))))) {2} )
     temp/1150 (global camlCode!))
    (setfield_imm 3 temp/1150 mandelbrot/1044))
  (let (start_time/1049 (let (temp/1149 0a) (caml_sys_time temp/1149)))
    (seq
      (let (temp/1116 1 temp/1117 100)
        (for iter/1050 temp/1116 to temp/1117
          (let (temp/1118 -39 temp/1119 38)
            (for y/1078 temp/1118 to temp/1119
              (seq
                (let (temp/1137 (let (temp/1138 1) (== temp/1138 iter/1050)))
                  (if temp/1137
                    (seq
                      (let
                        (oc/1083
                           (let (temp/1148 (global camlPervasives!))
                             (field 23 temp/1148))
                         temp/1144 ""
                         temp/1145 0
                         temp/1146
                           (let (temp/1147 "") (string.length temp/1147)))
                        (caml_ml_output oc/1083 temp/1144 temp/1145
                          temp/1146))
                      (let
                        (temp/1141
                           (let (temp/1142 (global camlPervasives!))
                             (field 23 temp/1142))
                         temp/1143 '\n')
                        (caml_ml_output_char temp/1141 temp/1143))
                      (let
                        (temp/1139
                           (let (temp/1140 (global camlPervasives!))
                             (field 23 temp/1140)))
                        (caml_ml_flush temp/1139)))
                    0a))
                (let (temp/1120 -39 temp/1121 38)
                  (for x/1079 temp/1120 to temp/1121
                    (let
                      (i/1080
                         (let
                           (temp/1129
                              (let
                                (temp/1130 (float_of_int x/1079)
                                 temp/1131 40.0)
                                (/. temp/1130 temp/1131))
                            temp/1132
                              (let
                                (temp/1133
                                   (let
                                     (temp/1134 (float_of_int y/1078)
                                      temp/1135 40.0)
                                     (/. temp/1134 temp/1135))
                                 temp/1136 0.5)
                                (-. temp/1133 temp/1136)))
                           (camlCode__iterate_1033  temp/1129 temp/1132))
                       temp/1122 (let (temp/1123 1) (== temp/1123 iter/1050)))
                      (if temp/1122
                        (let
                          (s/1081
                             (let
                               (temp/1127
                                  (let (temp/1128 0) (== temp/1128 i/1080)))
                               (if temp/1127 "*" " "))
                           oc/1082
                             (let (temp/1126 (global camlPervasives!))
                               (field 23 temp/1126))
                           temp/1124 0
                           temp/1125 (string.length s/1081))
                          (caml_ml_output oc/1082 s/1081 temp/1124 temp/1125))
                        0a)))))))))
      (let
        (oc/1084
           (let (temp/1115 (global camlPervasives!)) (field 23 temp/1115))
         temp/1111 ""
         temp/1112 0
         temp/1113 (let (temp/1114 "") (string.length temp/1114)))
        (caml_ml_output oc/1084 temp/1111 temp/1112 temp/1113))
      (let
        (temp/1108
           (let (temp/1109 (global camlPervasives!)) (field 23 temp/1109))
         temp/1110 '\n')
        (caml_ml_output_char temp/1108 temp/1110))
      (let
        (temp/1106
           (let (temp/1107 (global camlPervasives!)) (field 23 temp/1107)))
        (caml_ml_flush temp/1106))
      (let
        (f/1085
           (let (temp/1104 (let (temp/1105 0a) (caml_sys_time temp/1105)))
             (-. temp/1104 start_time/1049))
         s/1086
           (let
             (temp/1102
                (let (temp/1103 "%.12g")
                  (caml_format_float temp/1103 f/1085)))
             (camlPervasives__valid_float_lexem_1136  temp/1102))
         oc/1087
           (let (temp/1101 (global camlPervasives!)) (field 23 temp/1101))
         temp/1099 0
         temp/1100 (string.length s/1086))
        (caml_ml_output oc/1087 s/1086 temp/1099 temp/1100))
      (let
        (oc/1088
           (let (temp/1098 (global camlPervasives!)) (field 23 temp/1098))
         temp/1094 ""
         temp/1095 0
         temp/1096 (let (temp/1097 "") (string.length temp/1097)))
        (caml_ml_output oc/1088 temp/1094 temp/1095 temp/1096))
      (let
        (temp/1091
           (let (temp/1092 (global camlPervasives!)) (field 23 temp/1092))
         temp/1093 '\n')
        (caml_ml_output_char temp/1091 temp/1093))
      (let
        (temp/1089
           (let (temp/1090 (global camlPervasives!)) (field 23 temp/1090)))
        (caml_ml_flush temp/1089))))
  0a)
Before TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (setfield_imm 0 temp/1207 100)
    (let (temp/1205 (global camlCode!))
      (seq (setfield_imm 1 temp/1205 1000)
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184 (> i/1065 1000)
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073 (+ i/1065 1))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (for y/1046 -39 to 38
                              (let (temp/1170 (== 1 n/1045))
                                (seq
                                  (if temp/1170
                                    (let
                                      (temp/1181 (global camlPervasives!)
                                       oc/1075 (field 23 temp/1181)
                                       temp/1177 ""
                                       temp/1180 ""
                                       temp/1179 (string.length temp/1180))
                                      (seq
                                        (caml_ml_output oc/1075 temp/1177 0
                                          temp/1179)
                                        (let
                                          (temp/1175 (global camlPervasives!)
                                           temp/1174 (field 23 temp/1175))
                                          (seq
                                            (caml_ml_output_char temp/1174
                                              10)
                                            (let
                                              (temp/1173
                                                 (global camlPervasives!)
                                               temp/1172 (field 23 temp/1173))
                                              (caml_ml_flush temp/1172))))))
                                    0a)
                                  (for x/1047 -39 to 38
                                    (let
                                      (temp/1163 (float_of_int x/1047)
                                       temp/1164 40.0
                                       temp/1162 (/. temp/1163 temp/1164)
                                       temp/1167 (float_of_int y/1046)
                                       temp/1168 40.0
                                       temp/1166 (/. temp/1167 temp/1168)
                                       temp/1169 0.5
                                       temp/1165 (-. temp/1166 temp/1169)
                                       i/1048
                                         (camlCode__iterate_1033  temp/1162
                                           temp/1165)
                                       temp/1155 (== 1 n/1045))
                                      (if temp/1155
                                        (let
                                          (temp/1160 (== 0 i/1048)
                                           s/1076 (if temp/1160 "*" " ")
                                           temp/1159 (global camlPervasives!)
                                           oc/1077 (field 23 temp/1159)
                                           temp/1158 (string.length s/1076))
                                          (caml_ml_output oc/1077 s/1076 0
                                            temp/1158))
                                        0a))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let (start_time/1049 (caml_sys_time 0a))
                  (seq
                    (seq
                      (for iter/1050 1 to 100
                        (for y/1078 -39 to 38
                          (let (temp/1137 (== 1 iter/1050))
                            (seq
                              (if temp/1137
                                (let
                                  (temp/1148 (global camlPervasives!)
                                   oc/1083 (field 23 temp/1148)
                                   temp/1144 ""
                                   temp/1147 ""
                                   temp/1146 (string.length temp/1147))
                                  (seq
                                    (caml_ml_output oc/1083 temp/1144 0
                                      temp/1146)
                                    (let
                                      (temp/1142 (global camlPervasives!)
                                       temp/1141 (field 23 temp/1142))
                                      (seq (caml_ml_output_char temp/1141 10)
                                        (let
                                          (temp/1140 (global camlPervasives!)
                                           temp/1139 (field 23 temp/1140))
                                          (caml_ml_flush temp/1139))))))
                                0a)
                              (for x/1079 -39 to 38
                                (let
                                  (temp/1130 (float_of_int x/1079)
                                   temp/1131 40.0
                                   temp/1129 (/. temp/1130 temp/1131)
                                   temp/1134 (float_of_int y/1078)
                                   temp/1135 40.0
                                   temp/1133 (/. temp/1134 temp/1135)
                                   temp/1136 0.5
                                   temp/1132 (-. temp/1133 temp/1136)
                                   i/1080
                                     (camlCode__iterate_1033  temp/1129
                                       temp/1132)
                                   temp/1122 (== 1 iter/1050))
                                  (if temp/1122
                                    (let
                                      (temp/1127 (== 0 i/1080)
                                       s/1081 (if temp/1127 "*" " ")
                                       temp/1126 (global camlPervasives!)
                                       oc/1082 (field 23 temp/1126)
                                       temp/1125 (string.length s/1081))
                                      (caml_ml_output oc/1082 s/1081 0
                                        temp/1125))
                                    0a)))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq (caml_ml_output oc/1084 temp/1111 0 temp/1113)
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq (caml_ml_output_char temp/1108 10)
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104 (caml_sys_time 0a)
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq (caml_ml_output oc/1087 s/1086 0 temp/1100)
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (caml_ml_output oc/1088 temp/1094 0
                                    temp/1096)
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq (caml_ml_output_char temp/1091 10)
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
After TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (let (temp/1241 100) (setfield_imm 0 temp/1207 temp/1241))
    (let (temp/1205 (global camlCode!))
      (seq (let (temp/1240 1000) (setfield_imm 1 temp/1205 temp/1240))
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184
                                     (let (temp/1239 1000)
                                       (> i/1065 temp/1239))
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073
                                                (let (temp/1238 1)
                                                  (+ i/1065 temp/1238)))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (let (temp/1228 -39 temp/1229 38)
                              (for y/1046 temp/1228 to temp/1229
                                (let
                                  (temp/1170
                                     (let (temp/1237 1)
                                       (== temp/1237 n/1045)))
                                  (seq
                                    (if temp/1170
                                      (let
                                        (temp/1181 (global camlPervasives!)
                                         oc/1075 (field 23 temp/1181)
                                         temp/1177 ""
                                         temp/1180 ""
                                         temp/1179 (string.length temp/1180))
                                        (seq
                                          (let (temp/1236 0)
                                            (caml_ml_output oc/1075 temp/1177
                                              temp/1236 temp/1179))
                                          (let
                                            (temp/1175
                                               (global camlPervasives!)
                                             temp/1174 (field 23 temp/1175))
                                            (seq
                                              (let (temp/1235 10)
                                                (caml_ml_output_char
                                                  temp/1174 temp/1235))
                                              (let
                                                (temp/1173
                                                   (global camlPervasives!)
                                                 temp/1172
                                                   (field 23 temp/1173))
                                                (caml_ml_flush temp/1172))))))
                                      0a)
                                    (let (temp/1230 -39 temp/1231 38)
                                      (for x/1047 temp/1230 to temp/1231
                                        (let
                                          (temp/1163 (float_of_int x/1047)
                                           temp/1164 40.0
                                           temp/1162 (/. temp/1163 temp/1164)
                                           temp/1167 (float_of_int y/1046)
                                           temp/1168 40.0
                                           temp/1166 (/. temp/1167 temp/1168)
                                           temp/1169 0.5
                                           temp/1165 (-. temp/1166 temp/1169)
                                           i/1048
                                             (camlCode__iterate_1033 
                                               temp/1162 temp/1165)
                                           temp/1155
                                             (let (temp/1234 1)
                                               (== temp/1234 n/1045)))
                                          (if temp/1155
                                            (let
                                              (temp/1160
                                                 (let (temp/1233 0)
                                                   (== temp/1233 i/1048))
                                               s/1076 (if temp/1160 "*" " ")
                                               temp/1159
                                                 (global camlPervasives!)
                                               oc/1077 (field 23 temp/1159)
                                               temp/1158
                                                 (string.length s/1076)
                                               temp/1232 0)
                                              (caml_ml_output oc/1077 s/1076
                                                temp/1232 temp/1158))
                                            0a))))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let
                  (start_time/1049
                     (let (temp/1227 0a) (caml_sys_time temp/1227)))
                  (seq
                    (seq
                      (let (temp/1215 1 temp/1216 100)
                        (for iter/1050 temp/1215 to temp/1216
                          (let (temp/1217 -39 temp/1218 38)
                            (for y/1078 temp/1217 to temp/1218
                              (let
                                (temp/1137
                                   (let (temp/1226 1)
                                     (== temp/1226 iter/1050)))
                                (seq
                                  (if temp/1137
                                    (let
                                      (temp/1148 (global camlPervasives!)
                                       oc/1083 (field 23 temp/1148)
                                       temp/1144 ""
                                       temp/1147 ""
                                       temp/1146 (string.length temp/1147))
                                      (seq
                                        (let (temp/1225 0)
                                          (caml_ml_output oc/1083 temp/1144
                                            temp/1225 temp/1146))
                                        (let
                                          (temp/1142 (global camlPervasives!)
                                           temp/1141 (field 23 temp/1142))
                                          (seq
                                            (let (temp/1224 10)
                                              (caml_ml_output_char temp/1141
                                                temp/1224))
                                            (let
                                              (temp/1140
                                                 (global camlPervasives!)
                                               temp/1139 (field 23 temp/1140))
                                              (caml_ml_flush temp/1139))))))
                                    0a)
                                  (let (temp/1219 -39 temp/1220 38)
                                    (for x/1079 temp/1219 to temp/1220
                                      (let
                                        (temp/1130 (float_of_int x/1079)
                                         temp/1131 40.0
                                         temp/1129 (/. temp/1130 temp/1131)
                                         temp/1134 (float_of_int y/1078)
                                         temp/1135 40.0
                                         temp/1133 (/. temp/1134 temp/1135)
                                         temp/1136 0.5
                                         temp/1132 (-. temp/1133 temp/1136)
                                         i/1080
                                           (camlCode__iterate_1033  temp/1129
                                             temp/1132)
                                         temp/1122
                                           (let (temp/1223 1)
                                             (== temp/1223 iter/1050)))
                                        (if temp/1122
                                          (let
                                            (temp/1127
                                               (let (temp/1222 0)
                                                 (== temp/1222 i/1080))
                                             s/1081 (if temp/1127 "*" " ")
                                             temp/1126
                                               (global camlPervasives!)
                                             oc/1082 (field 23 temp/1126)
                                             temp/1125 (string.length s/1081)
                                             temp/1221 0)
                                            (caml_ml_output oc/1082 s/1081
                                              temp/1221 temp/1125))
                                          0a))))))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq
                            (let (temp/1214 0)
                              (caml_ml_output oc/1084 temp/1111 temp/1214
                                temp/1113))
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq
                                (let (temp/1213 10)
                                  (caml_ml_output_char temp/1108 temp/1213))
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104
                               (let (temp/1212 0a) (caml_sys_time temp/1212))
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq
                              (let (temp/1211 0)
                                (caml_ml_output oc/1087 s/1086 temp/1211
                                  temp/1100))
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (let (temp/1210 0)
                                    (caml_ml_output oc/1088 temp/1094
                                      temp/1210 temp/1096))
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq
                                      (let (temp/1209 10)
                                        (caml_ml_output_char temp/1091
                                          temp/1209))
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
Before TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
After TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
Before TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
After TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
Before TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))
After TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))
-dlambda2
*** After TonLambda.optimize:
(seq (let (runs/1031 100) (setfield_imm 0 (global Code!) runs/1031))
  (let (max_iterations/1032 1000)
    (setfield_imm 1 (global Code!) max_iterations/1032))
  (let
    (iterate/1033
       (function ci/1034 cr/1035
         (let
           (bailout/1036 4.0
            loop/1037
              (function zi/1059 zr/1060 i/1061
                (let (i/1040 i/1061 zr/1039 zr/1060 zi/1038 zi/1059)
                  (catch
                    (while 1a
                      (catch
                        (exit 12
                          (if (> i/1040 (field 1 (global Code!))) 0
                            (let
                              (temp/1041 (*. zr/1039 zi/1038)
                               zr2/1042 (*. zr/1039 zr/1039)
                               zi2/1043 (*. zi/1038 zi/1038))
                              (if (>. (+. zi2/1043 zr2/1042) bailout/1036)
                                i/1040
                                (let
                                  (arg/1055
                                     (+. (+. temp/1041 temp/1041) ci/1034)
                                   arg/1056
                                     (+. (-. zr2/1042 zi2/1043) cr/1035)
                                   arg/1057 (+ i/1040 1))
                                  (seq (assign i/1040 arg/1057)
                                    (assign zr/1039 arg/1056)
                                    (assign zi/1038 arg/1055) (exit 11)))))))
                       with (11) 0a))
                   with (12 res/1058) res/1058))))
           (apply loop/1037 0.0 0.0 1))))
    (setfield_imm 2 (global Code!) iterate/1033))
  (let
    (mandelbrot/1044
       (function n/1045
         (for y/1046 -39 to 38
           (seq
             (if (== 1 n/1045) (apply (field 29 (global Pervasives!)) "") 0a)
             (for x/1047 -39 to 38
               (let
                 (i/1048
                    (apply (field 2 (global Code!))
                      (/. (float_of_int x/1047) 40.0)
                      (-. (/. (float_of_int y/1046) 40.0) 0.5)))
                 (if (== 1 n/1045)
                   (apply (field 26 (global Pervasives!))
                     (if (== 0 i/1048) "*" " "))
                   0a)))))))
    (setfield_imm 3 (global Code!) mandelbrot/1044))
  (let (start_time/1049 (caml_sys_time 0a))
    (seq
      (for iter/1050 1 to (field 0 (global Code!))
        (apply (field 3 (global Code!)) iter/1050))
      (apply (field 29 (global Pervasives!)) "")
      (apply (field 28 (global Pervasives!))
        (-. (caml_sys_time 0a) start_time/1049))
      (apply (field 29 (global Pervasives!)) "")))
  0a)
[inline] iterate_1033 cannot be inlined: local fun
Before TonSlambda.optimize:
(seq (setfield_imm 0 (global camlCode!) 100)
  (setfield_imm 1 (global camlCode!) 1000)
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (exit 12
                                            (if (> i/1040 1000) 0
                                              (let
                                                (temp/1041
                                                   (*. zr/1039 zi/1038)
                                                 zr2/1042
                                                   (*. zr/1039 zr/1039)
                                                 zi2/1043
                                                   (*. zi/1038 zi/1038))
                                                (if
                                                  (>. (+. zi2/1043 zr2/1042)
                                                    (field 5 env/1064))
                                                  i/1040
                                                  (let
                                                    (arg/1055
                                                       (+.
                                                         (+. temp/1041
                                                           temp/1041)
                                                         (field 3 env/1064))
                                                     arg/1056
                                                       (+.
                                                         (-. zr2/1042
                                                           zi2/1043)
                                                         (field 4 env/1064))
                                                     arg/1057 (+ i/1040 1))
                                                    (seq
                                                      (assign i/1040
                                                        arg/1057)
                                                      (assign zr/1039
                                                        arg/1056)
                                                      (assign zi/1038
                                                        arg/1055)
                                                      (exit 11)))))))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (exit 12
                            (if (> i/1065 1000) 0
                              (let
                                (temp/1068 (*. zr/1066 zi/1067)
                                 zr2/1069 (*. zr/1066 zr/1066)
                                 zi2/1070 (*. zi/1067 zi/1067))
                                (if
                                  (>. (+. zi2/1070 zr2/1069)
                                    (field 5 loop/1037))
                                  i/1065
                                  (let
                                    (arg/1071
                                       (+. (+. temp/1068 temp/1068)
                                         (field 3 loop/1037))
                                     arg/1072
                                       (+. (-. zr2/1069 zi2/1070)
                                         (field 4 loop/1037))
                                     arg/1073 (+ i/1065 1))
                                    (seq (assign i/1065 arg/1073)
                                      (assign zr/1066 arg/1072)
                                      (assign zi/1067 arg/1071) (exit 11)))))))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} ))
    (setfield_imm 2 (global camlCode!) iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (for y/1046 -39 to 38
                    (seq
                      (if (== 1 n/1045)
                        (seq
                          (let (oc/1075 (field 23 (global camlPervasives!)))
                            (caml_ml_output oc/1075 "" 0 (string.length "")))
                          (caml_ml_output_char
                            (field 23 (global camlPervasives!)) '\n')
                          (caml_ml_flush (field 23 (global camlPervasives!))))
                        0a)
                      (for x/1047 -39 to 38
                        (let
                          (i/1048
                             (camlCode__iterate_1033 
                               (/. (float_of_int x/1047) 40.0)
                               (-. (/. (float_of_int y/1046) 40.0) 0.5)))
                          (if (== 1 n/1045)
                            (let
                              (s/1076 (if (== 0 i/1048) "*" " ")
                               oc/1077 (field 23 (global camlPervasives!)))
                              (caml_ml_output oc/1077 s/1076 0
                                (string.length s/1076)))
                            0a)))))) {2} ))
    (setfield_imm 3 (global camlCode!) mandelbrot/1044))
  (let (start_time/1049 (caml_sys_time 0a))
    (seq
      (for iter/1050 1 to 100
        (for y/1078 -39 to 38
          (seq
            (if (== 1 iter/1050)
              (seq
                (let (oc/1083 (field 23 (global camlPervasives!)))
                  (caml_ml_output oc/1083 "" 0 (string.length "")))
                (caml_ml_output_char (field 23 (global camlPervasives!))
                  '\n')
                (caml_ml_flush (field 23 (global camlPervasives!))))
              0a)
            (for x/1079 -39 to 38
              (let
                (i/1080
                   (camlCode__iterate_1033  (/. (float_of_int x/1079) 40.0)
                     (-. (/. (float_of_int y/1078) 40.0) 0.5)))
                (if (== 1 iter/1050)
                  (let
                    (s/1081 (if (== 0 i/1080) "*" " ")
                     oc/1082 (field 23 (global camlPervasives!)))
                    (caml_ml_output oc/1082 s/1081 0 (string.length s/1081)))
                  0a))))))
      (let (oc/1084 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1084 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))
      (let
        (f/1085 (-. (caml_sys_time 0a) start_time/1049)
         s/1086
           (camlPervasives__valid_float_lexem_1136 
             (caml_format_float "%.12g" f/1085))
         oc/1087 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1087 s/1086 0 (string.length s/1086)))
      (let (oc/1088 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1088 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))))
  0a)
After TonSlambda.optimize:
(seq
  (let (temp/1207 (global camlCode!) temp/1208 100)
    (setfield_imm 0 temp/1207 temp/1208))
  (let (temp/1205 (global camlCode!) temp/1206 1000)
    (setfield_imm 1 temp/1205 temp/1206))
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (let
                                            (temp/1194
                                               (let
                                                 (temp/1195
                                                    (let (temp/1196 1000)
                                                      (> i/1040 temp/1196)))
                                                 (if temp/1195 0
                                                   (let
                                                     (temp/1041
                                                        (*. zr/1039 zi/1038)
                                                      zr2/1042
                                                        (*. zr/1039 zr/1039)
                                                      zi2/1043
                                                        (*. zi/1038 zi/1038)
                                                      temp/1197
                                                        (let
                                                          (temp/1198
                                                             (+. zi2/1043
                                                               zr2/1042)
                                                           temp/1199
                                                             (field 5
                                                               env/1064))
                                                          (>. temp/1198
                                                            temp/1199)))
                                                     (if temp/1197 i/1040
                                                       (let
                                                         (arg/1055
                                                            (let
                                                              (temp/1203
                                                                 (+.
                                                                   temp/1041
                                                                   temp/1041)
                                                               temp/1204
                                                                 (field 3
                                                                   env/1064))
                                                              (+. temp/1203
                                                                temp/1204))
                                                          arg/1056
                                                            (let
                                                              (temp/1201
                                                                 (-. zr2/1042
                                                                   zi2/1043)
                                                               temp/1202
                                                                 (field 4
                                                                   env/1064))
                                                              (+. temp/1201
                                                                temp/1202))
                                                          arg/1057
                                                            (let
                                                              (temp/1200 1)
                                                              (+ i/1040
                                                                temp/1200)))
                                                         (seq
                                                           (assign i/1040
                                                             arg/1057)
                                                           (assign zr/1039
                                                             arg/1056)
                                                           (assign zi/1038
                                                             arg/1055)
                                                           (exit 11))))))))
                                            (exit 12 temp/1194))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (let
                            (temp/1183
                               (let
                                 (temp/1184
                                    (let (temp/1185 1000)
                                      (> i/1065 temp/1185)))
                                 (if temp/1184 0
                                   (let
                                     (temp/1068 (*. zr/1066 zi/1067)
                                      zr2/1069 (*. zr/1066 zr/1066)
                                      zi2/1070 (*. zi/1067 zi/1067)
                                      temp/1186
                                        (let
                                          (temp/1187 (+. zi2/1070 zr2/1069)
                                           temp/1188 (field 5 loop/1037))
                                          (>. temp/1187 temp/1188)))
                                     (if temp/1186 i/1065
                                       (let
                                         (arg/1071
                                            (let
                                              (temp/1192
                                                 (+. temp/1068 temp/1068)
                                               temp/1193 (field 3 loop/1037))
                                              (+. temp/1192 temp/1193))
                                          arg/1072
                                            (let
                                              (temp/1190
                                                 (-. zr2/1069 zi2/1070)
                                               temp/1191 (field 4 loop/1037))
                                              (+. temp/1190 temp/1191))
                                          arg/1073
                                            (let (temp/1189 1)
                                              (+ i/1065 temp/1189)))
                                         (seq (assign i/1065 arg/1073)
                                           (assign zr/1066 arg/1072)
                                           (assign zi/1067 arg/1071)
                                           (exit 11))))))))
                            (exit 12 temp/1183))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} )
     temp/1182 (global camlCode!))
    (setfield_imm 2 temp/1182 iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (let (temp/1151 -39 temp/1152 38)
                    (for y/1046 temp/1151 to temp/1152
                      (seq
                        (let
                          (temp/1170
                             (let (temp/1171 1) (== temp/1171 n/1045)))
                          (if temp/1170
                            (seq
                              (let
                                (oc/1075
                                   (let (temp/1181 (global camlPervasives!))
                                     (field 23 temp/1181))
                                 temp/1177 ""
                                 temp/1178 0
                                 temp/1179
                                   (let (temp/1180 "")
                                     (string.length temp/1180)))
                                (caml_ml_output oc/1075 temp/1177 temp/1178
                                  temp/1179))
                              (let
                                (temp/1174
                                   (let (temp/1175 (global camlPervasives!))
                                     (field 23 temp/1175))
                                 temp/1176 '\n')
                                (caml_ml_output_char temp/1174 temp/1176))
                              (let
                                (temp/1172
                                   (let (temp/1173 (global camlPervasives!))
                                     (field 23 temp/1173)))
                                (caml_ml_flush temp/1172)))
                            0a))
                        (let (temp/1153 -39 temp/1154 38)
                          (for x/1047 temp/1153 to temp/1154
                            (let
                              (i/1048
                                 (let
                                   (temp/1162
                                      (let
                                        (temp/1163 (float_of_int x/1047)
                                         temp/1164 40.0)
                                        (/. temp/1163 temp/1164))
                                    temp/1165
                                      (let
                                        (temp/1166
                                           (let
                                             (temp/1167 (float_of_int y/1046)
                                              temp/1168 40.0)
                                             (/. temp/1167 temp/1168))
                                         temp/1169 0.5)
                                        (-. temp/1166 temp/1169)))
                                   (camlCode__iterate_1033  temp/1162
                                     temp/1165))
                               temp/1155
                                 (let (temp/1156 1) (== temp/1156 n/1045)))
                              (if temp/1155
                                (let
                                  (s/1076
                                     (let
                                       (temp/1160
                                          (let (temp/1161 0)
                                            (== temp/1161 i/1048)))
                                       (if temp/1160 "*" " "))
                                   oc/1077
                                     (let
                                       (temp/1159 (global camlPervasives!))
                                       (field 23 temp/1159))
                                   temp/1157 0
                                   temp/1158 (string.length s/1076))
                                  (caml_ml_output oc/1077 s/1076 temp/1157
                                    temp/1158))
                                0a)))))))) {2} )
     temp/1150 (global camlCode!))
    (setfield_imm 3 temp/1150 mandelbrot/1044))
  (let (start_time/1049 (let (temp/1149 0a) (caml_sys_time temp/1149)))
    (seq
      (let (temp/1116 1 temp/1117 100)
        (for iter/1050 temp/1116 to temp/1117
          (let (temp/1118 -39 temp/1119 38)
            (for y/1078 temp/1118 to temp/1119
              (seq
                (let (temp/1137 (let (temp/1138 1) (== temp/1138 iter/1050)))
                  (if temp/1137
                    (seq
                      (let
                        (oc/1083
                           (let (temp/1148 (global camlPervasives!))
                             (field 23 temp/1148))
                         temp/1144 ""
                         temp/1145 0
                         temp/1146
                           (let (temp/1147 "") (string.length temp/1147)))
                        (caml_ml_output oc/1083 temp/1144 temp/1145
                          temp/1146))
                      (let
                        (temp/1141
                           (let (temp/1142 (global camlPervasives!))
                             (field 23 temp/1142))
                         temp/1143 '\n')
                        (caml_ml_output_char temp/1141 temp/1143))
                      (let
                        (temp/1139
                           (let (temp/1140 (global camlPervasives!))
                             (field 23 temp/1140)))
                        (caml_ml_flush temp/1139)))
                    0a))
                (let (temp/1120 -39 temp/1121 38)
                  (for x/1079 temp/1120 to temp/1121
                    (let
                      (i/1080
                         (let
                           (temp/1129
                              (let
                                (temp/1130 (float_of_int x/1079)
                                 temp/1131 40.0)
                                (/. temp/1130 temp/1131))
                            temp/1132
                              (let
                                (temp/1133
                                   (let
                                     (temp/1134 (float_of_int y/1078)
                                      temp/1135 40.0)
                                     (/. temp/1134 temp/1135))
                                 temp/1136 0.5)
                                (-. temp/1133 temp/1136)))
                           (camlCode__iterate_1033  temp/1129 temp/1132))
                       temp/1122 (let (temp/1123 1) (== temp/1123 iter/1050)))
                      (if temp/1122
                        (let
                          (s/1081
                             (let
                               (temp/1127
                                  (let (temp/1128 0) (== temp/1128 i/1080)))
                               (if temp/1127 "*" " "))
                           oc/1082
                             (let (temp/1126 (global camlPervasives!))
                               (field 23 temp/1126))
                           temp/1124 0
                           temp/1125 (string.length s/1081))
                          (caml_ml_output oc/1082 s/1081 temp/1124 temp/1125))
                        0a)))))))))
      (let
        (oc/1084
           (let (temp/1115 (global camlPervasives!)) (field 23 temp/1115))
         temp/1111 ""
         temp/1112 0
         temp/1113 (let (temp/1114 "") (string.length temp/1114)))
        (caml_ml_output oc/1084 temp/1111 temp/1112 temp/1113))
      (let
        (temp/1108
           (let (temp/1109 (global camlPervasives!)) (field 23 temp/1109))
         temp/1110 '\n')
        (caml_ml_output_char temp/1108 temp/1110))
      (let
        (temp/1106
           (let (temp/1107 (global camlPervasives!)) (field 23 temp/1107)))
        (caml_ml_flush temp/1106))
      (let
        (f/1085
           (let (temp/1104 (let (temp/1105 0a) (caml_sys_time temp/1105)))
             (-. temp/1104 start_time/1049))
         s/1086
           (let
             (temp/1102
                (let (temp/1103 "%.12g")
                  (caml_format_float temp/1103 f/1085)))
             (camlPervasives__valid_float_lexem_1136  temp/1102))
         oc/1087
           (let (temp/1101 (global camlPervasives!)) (field 23 temp/1101))
         temp/1099 0
         temp/1100 (string.length s/1086))
        (caml_ml_output oc/1087 s/1086 temp/1099 temp/1100))
      (let
        (oc/1088
           (let (temp/1098 (global camlPervasives!)) (field 23 temp/1098))
         temp/1094 ""
         temp/1095 0
         temp/1096 (let (temp/1097 "") (string.length temp/1097)))
        (caml_ml_output oc/1088 temp/1094 temp/1095 temp/1096))
      (let
        (temp/1091
           (let (temp/1092 (global camlPervasives!)) (field 23 temp/1092))
         temp/1093 '\n')
        (caml_ml_output_char temp/1091 temp/1093))
      (let
        (temp/1089
           (let (temp/1090 (global camlPervasives!)) (field 23 temp/1090)))
        (caml_ml_flush temp/1089))))
  0a)
Before TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (setfield_imm 0 temp/1207 100)
    (let (temp/1205 (global camlCode!))
      (seq (setfield_imm 1 temp/1205 1000)
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184 (> i/1065 1000)
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073 (+ i/1065 1))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (for y/1046 -39 to 38
                              (let (temp/1170 (== 1 n/1045))
                                (seq
                                  (if temp/1170
                                    (let
                                      (temp/1181 (global camlPervasives!)
                                       oc/1075 (field 23 temp/1181)
                                       temp/1177 ""
                                       temp/1180 ""
                                       temp/1179 (string.length temp/1180))
                                      (seq
                                        (caml_ml_output oc/1075 temp/1177 0
                                          temp/1179)
                                        (let
                                          (temp/1175 (global camlPervasives!)
                                           temp/1174 (field 23 temp/1175))
                                          (seq
                                            (caml_ml_output_char temp/1174
                                              10)
                                            (let
                                              (temp/1173
                                                 (global camlPervasives!)
                                               temp/1172 (field 23 temp/1173))
                                              (caml_ml_flush temp/1172))))))
                                    0a)
                                  (for x/1047 -39 to 38
                                    (let
                                      (temp/1163 (float_of_int x/1047)
                                       temp/1164 40.0
                                       temp/1162 (/. temp/1163 temp/1164)
                                       temp/1167 (float_of_int y/1046)
                                       temp/1168 40.0
                                       temp/1166 (/. temp/1167 temp/1168)
                                       temp/1169 0.5
                                       temp/1165 (-. temp/1166 temp/1169)
                                       i/1048
                                         (camlCode__iterate_1033  temp/1162
                                           temp/1165)
                                       temp/1155 (== 1 n/1045))
                                      (if temp/1155
                                        (let
                                          (temp/1160 (== 0 i/1048)
                                           s/1076 (if temp/1160 "*" " ")
                                           temp/1159 (global camlPervasives!)
                                           oc/1077 (field 23 temp/1159)
                                           temp/1158 (string.length s/1076))
                                          (caml_ml_output oc/1077 s/1076 0
                                            temp/1158))
                                        0a))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let (start_time/1049 (caml_sys_time 0a))
                  (seq
                    (seq
                      (for iter/1050 1 to 100
                        (for y/1078 -39 to 38
                          (let (temp/1137 (== 1 iter/1050))
                            (seq
                              (if temp/1137
                                (let
                                  (temp/1148 (global camlPervasives!)
                                   oc/1083 (field 23 temp/1148)
                                   temp/1144 ""
                                   temp/1147 ""
                                   temp/1146 (string.length temp/1147))
                                  (seq
                                    (caml_ml_output oc/1083 temp/1144 0
                                      temp/1146)
                                    (let
                                      (temp/1142 (global camlPervasives!)
                                       temp/1141 (field 23 temp/1142))
                                      (seq (caml_ml_output_char temp/1141 10)
                                        (let
                                          (temp/1140 (global camlPervasives!)
                                           temp/1139 (field 23 temp/1140))
                                          (caml_ml_flush temp/1139))))))
                                0a)
                              (for x/1079 -39 to 38
                                (let
                                  (temp/1130 (float_of_int x/1079)
                                   temp/1131 40.0
                                   temp/1129 (/. temp/1130 temp/1131)
                                   temp/1134 (float_of_int y/1078)
                                   temp/1135 40.0
                                   temp/1133 (/. temp/1134 temp/1135)
                                   temp/1136 0.5
                                   temp/1132 (-. temp/1133 temp/1136)
                                   i/1080
                                     (camlCode__iterate_1033  temp/1129
                                       temp/1132)
                                   temp/1122 (== 1 iter/1050))
                                  (if temp/1122
                                    (let
                                      (temp/1127 (== 0 i/1080)
                                       s/1081 (if temp/1127 "*" " ")
                                       temp/1126 (global camlPervasives!)
                                       oc/1082 (field 23 temp/1126)
                                       temp/1125 (string.length s/1081))
                                      (caml_ml_output oc/1082 s/1081 0
                                        temp/1125))
                                    0a)))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq (caml_ml_output oc/1084 temp/1111 0 temp/1113)
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq (caml_ml_output_char temp/1108 10)
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104 (caml_sys_time 0a)
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq (caml_ml_output oc/1087 s/1086 0 temp/1100)
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (caml_ml_output oc/1088 temp/1094 0
                                    temp/1096)
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq (caml_ml_output_char temp/1091 10)
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
After TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (let (temp/1241 100) (setfield_imm 0 temp/1207 temp/1241))
    (let (temp/1205 (global camlCode!))
      (seq (let (temp/1240 1000) (setfield_imm 1 temp/1205 temp/1240))
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184
                                     (let (temp/1239 1000)
                                       (> i/1065 temp/1239))
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073
                                                (let (temp/1238 1)
                                                  (+ i/1065 temp/1238)))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (let (temp/1228 -39 temp/1229 38)
                              (for y/1046 temp/1228 to temp/1229
                                (let
                                  (temp/1170
                                     (let (temp/1237 1)
                                       (== temp/1237 n/1045)))
                                  (seq
                                    (if temp/1170
                                      (let
                                        (temp/1181 (global camlPervasives!)
                                         oc/1075 (field 23 temp/1181)
                                         temp/1177 ""
                                         temp/1180 ""
                                         temp/1179 (string.length temp/1180))
                                        (seq
                                          (let (temp/1236 0)
                                            (caml_ml_output oc/1075 temp/1177
                                              temp/1236 temp/1179))
                                          (let
                                            (temp/1175
                                               (global camlPervasives!)
                                             temp/1174 (field 23 temp/1175))
                                            (seq
                                              (let (temp/1235 10)
                                                (caml_ml_output_char
                                                  temp/1174 temp/1235))
                                              (let
                                                (temp/1173
                                                   (global camlPervasives!)
                                                 temp/1172
                                                   (field 23 temp/1173))
                                                (caml_ml_flush temp/1172))))))
                                      0a)
                                    (let (temp/1230 -39 temp/1231 38)
                                      (for x/1047 temp/1230 to temp/1231
                                        (let
                                          (temp/1163 (float_of_int x/1047)
                                           temp/1164 40.0
                                           temp/1162 (/. temp/1163 temp/1164)
                                           temp/1167 (float_of_int y/1046)
                                           temp/1168 40.0
                                           temp/1166 (/. temp/1167 temp/1168)
                                           temp/1169 0.5
                                           temp/1165 (-. temp/1166 temp/1169)
                                           i/1048
                                             (camlCode__iterate_1033 
                                               temp/1162 temp/1165)
                                           temp/1155
                                             (let (temp/1234 1)
                                               (== temp/1234 n/1045)))
                                          (if temp/1155
                                            (let
                                              (temp/1160
                                                 (let (temp/1233 0)
                                                   (== temp/1233 i/1048))
                                               s/1076 (if temp/1160 "*" " ")
                                               temp/1159
                                                 (global camlPervasives!)
                                               oc/1077 (field 23 temp/1159)
                                               temp/1158
                                                 (string.length s/1076)
                                               temp/1232 0)
                                              (caml_ml_output oc/1077 s/1076
                                                temp/1232 temp/1158))
                                            0a))))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let
                  (start_time/1049
                     (let (temp/1227 0a) (caml_sys_time temp/1227)))
                  (seq
                    (seq
                      (let (temp/1215 1 temp/1216 100)
                        (for iter/1050 temp/1215 to temp/1216
                          (let (temp/1217 -39 temp/1218 38)
                            (for y/1078 temp/1217 to temp/1218
                              (let
                                (temp/1137
                                   (let (temp/1226 1)
                                     (== temp/1226 iter/1050)))
                                (seq
                                  (if temp/1137
                                    (let
                                      (temp/1148 (global camlPervasives!)
                                       oc/1083 (field 23 temp/1148)
                                       temp/1144 ""
                                       temp/1147 ""
                                       temp/1146 (string.length temp/1147))
                                      (seq
                                        (let (temp/1225 0)
                                          (caml_ml_output oc/1083 temp/1144
                                            temp/1225 temp/1146))
                                        (let
                                          (temp/1142 (global camlPervasives!)
                                           temp/1141 (field 23 temp/1142))
                                          (seq
                                            (let (temp/1224 10)
                                              (caml_ml_output_char temp/1141
                                                temp/1224))
                                            (let
                                              (temp/1140
                                                 (global camlPervasives!)
                                               temp/1139 (field 23 temp/1140))
                                              (caml_ml_flush temp/1139))))))
                                    0a)
                                  (let (temp/1219 -39 temp/1220 38)
                                    (for x/1079 temp/1219 to temp/1220
                                      (let
                                        (temp/1130 (float_of_int x/1079)
                                         temp/1131 40.0
                                         temp/1129 (/. temp/1130 temp/1131)
                                         temp/1134 (float_of_int y/1078)
                                         temp/1135 40.0
                                         temp/1133 (/. temp/1134 temp/1135)
                                         temp/1136 0.5
                                         temp/1132 (-. temp/1133 temp/1136)
                                         i/1080
                                           (camlCode__iterate_1033  temp/1129
                                             temp/1132)
                                         temp/1122
                                           (let (temp/1223 1)
                                             (== temp/1223 iter/1050)))
                                        (if temp/1122
                                          (let
                                            (temp/1127
                                               (let (temp/1222 0)
                                                 (== temp/1222 i/1080))
                                             s/1081 (if temp/1127 "*" " ")
                                             temp/1126
                                               (global camlPervasives!)
                                             oc/1082 (field 23 temp/1126)
                                             temp/1125 (string.length s/1081)
                                             temp/1221 0)
                                            (caml_ml_output oc/1082 s/1081
                                              temp/1221 temp/1125))
                                          0a))))))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq
                            (let (temp/1214 0)
                              (caml_ml_output oc/1084 temp/1111 temp/1214
                                temp/1113))
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq
                                (let (temp/1213 10)
                                  (caml_ml_output_char temp/1108 temp/1213))
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104
                               (let (temp/1212 0a) (caml_sys_time temp/1212))
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq
                              (let (temp/1211 0)
                                (caml_ml_output oc/1087 s/1086 temp/1211
                                  temp/1100))
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (let (temp/1210 0)
                                    (caml_ml_output oc/1088 temp/1094
                                      temp/1210 temp/1096))
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq
                                      (let (temp/1209 10)
                                        (caml_ml_output_char temp/1091
                                          temp/1209))
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
Before TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
After TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
Before TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
After TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
Before TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))
After TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))
-dclosure
[inline] iterate_1033 cannot be inlined: local fun
*** After Closure.intro:
(seq (setfield_imm 0 (global camlCode!) 100)
  (setfield_imm 1 (global camlCode!) 1000)
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (exit 12
                                            (if (> i/1040 1000) 0
                                              (let
                                                (temp/1041
                                                   (*. zr/1039 zi/1038)
                                                 zr2/1042
                                                   (*. zr/1039 zr/1039)
                                                 zi2/1043
                                                   (*. zi/1038 zi/1038))
                                                (if
                                                  (>. (+. zi2/1043 zr2/1042)
                                                    (field 5 env/1064))
                                                  i/1040
                                                  (let
                                                    (arg/1055
                                                       (+.
                                                         (+. temp/1041
                                                           temp/1041)
                                                         (field 3 env/1064))
                                                     arg/1056
                                                       (+.
                                                         (-. zr2/1042
                                                           zi2/1043)
                                                         (field 4 env/1064))
                                                     arg/1057 (+ i/1040 1))
                                                    (seq
                                                      (assign i/1040
                                                        arg/1057)
                                                      (assign zr/1039
                                                        arg/1056)
                                                      (assign zi/1038
                                                        arg/1055)
                                                      (exit 11)))))))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (exit 12
                            (if (> i/1065 1000) 0
                              (let
                                (temp/1068 (*. zr/1066 zi/1067)
                                 zr2/1069 (*. zr/1066 zr/1066)
                                 zi2/1070 (*. zi/1067 zi/1067))
                                (if
                                  (>. (+. zi2/1070 zr2/1069)
                                    (field 5 loop/1037))
                                  i/1065
                                  (let
                                    (arg/1071
                                       (+. (+. temp/1068 temp/1068)
                                         (field 3 loop/1037))
                                     arg/1072
                                       (+. (-. zr2/1069 zi2/1070)
                                         (field 4 loop/1037))
                                     arg/1073 (+ i/1065 1))
                                    (seq (assign i/1065 arg/1073)
                                      (assign zr/1066 arg/1072)
                                      (assign zi/1067 arg/1071) (exit 11)))))))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} ))
    (setfield_imm 2 (global camlCode!) iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (for y/1046 -39 to 38
                    (seq
                      (if (== 1 n/1045)
                        (seq
                          (let (oc/1075 (field 23 (global camlPervasives!)))
                            (caml_ml_output oc/1075 "" 0 (string.length "")))
                          (caml_ml_output_char
                            (field 23 (global camlPervasives!)) '\n')
                          (caml_ml_flush (field 23 (global camlPervasives!))))
                        0a)
                      (for x/1047 -39 to 38
                        (let
                          (i/1048
                             (camlCode__iterate_1033 
                               (/. (float_of_int x/1047) 40.0)
                               (-. (/. (float_of_int y/1046) 40.0) 0.5)))
                          (if (== 1 n/1045)
                            (let
                              (s/1076 (if (== 0 i/1048) "*" " ")
                               oc/1077 (field 23 (global camlPervasives!)))
                              (caml_ml_output oc/1077 s/1076 0
                                (string.length s/1076)))
                            0a)))))) {2} ))
    (setfield_imm 3 (global camlCode!) mandelbrot/1044))
  (let (start_time/1049 (caml_sys_time 0a))
    (seq
      (for iter/1050 1 to 100
        (for y/1078 -39 to 38
          (seq
            (if (== 1 iter/1050)
              (seq
                (let (oc/1083 (field 23 (global camlPervasives!)))
                  (caml_ml_output oc/1083 "" 0 (string.length "")))
                (caml_ml_output_char (field 23 (global camlPervasives!))
                  '\n')
                (caml_ml_flush (field 23 (global camlPervasives!))))
              0a)
            (for x/1079 -39 to 38
              (let
                (i/1080
                   (camlCode__iterate_1033  (/. (float_of_int x/1079) 40.0)
                     (-. (/. (float_of_int y/1078) 40.0) 0.5)))
                (if (== 1 iter/1050)
                  (let
                    (s/1081 (if (== 0 i/1080) "*" " ")
                     oc/1082 (field 23 (global camlPervasives!)))
                    (caml_ml_output oc/1082 s/1081 0 (string.length s/1081)))
                  0a))))))
      (let (oc/1084 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1084 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))
      (let
        (f/1085 (-. (caml_sys_time 0a) start_time/1049)
         s/1086
           (camlPervasives__valid_float_lexem_1136 
             (caml_format_float "%.12g" f/1085))
         oc/1087 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1087 s/1086 0 (string.length s/1086)))
      (let (oc/1088 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1088 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))))
  0a)
Before TonSlambda.optimize:
(seq (setfield_imm 0 (global camlCode!) 100)
  (setfield_imm 1 (global camlCode!) 1000)
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (exit 12
                                            (if (> i/1040 1000) 0
                                              (let
                                                (temp/1041
                                                   (*. zr/1039 zi/1038)
                                                 zr2/1042
                                                   (*. zr/1039 zr/1039)
                                                 zi2/1043
                                                   (*. zi/1038 zi/1038))
                                                (if
                                                  (>. (+. zi2/1043 zr2/1042)
                                                    (field 5 env/1064))
                                                  i/1040
                                                  (let
                                                    (arg/1055
                                                       (+.
                                                         (+. temp/1041
                                                           temp/1041)
                                                         (field 3 env/1064))
                                                     arg/1056
                                                       (+.
                                                         (-. zr2/1042
                                                           zi2/1043)
                                                         (field 4 env/1064))
                                                     arg/1057 (+ i/1040 1))
                                                    (seq
                                                      (assign i/1040
                                                        arg/1057)
                                                      (assign zr/1039
                                                        arg/1056)
                                                      (assign zi/1038
                                                        arg/1055)
                                                      (exit 11)))))))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (exit 12
                            (if (> i/1065 1000) 0
                              (let
                                (temp/1068 (*. zr/1066 zi/1067)
                                 zr2/1069 (*. zr/1066 zr/1066)
                                 zi2/1070 (*. zi/1067 zi/1067))
                                (if
                                  (>. (+. zi2/1070 zr2/1069)
                                    (field 5 loop/1037))
                                  i/1065
                                  (let
                                    (arg/1071
                                       (+. (+. temp/1068 temp/1068)
                                         (field 3 loop/1037))
                                     arg/1072
                                       (+. (-. zr2/1069 zi2/1070)
                                         (field 4 loop/1037))
                                     arg/1073 (+ i/1065 1))
                                    (seq (assign i/1065 arg/1073)
                                      (assign zr/1066 arg/1072)
                                      (assign zi/1067 arg/1071) (exit 11)))))))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} ))
    (setfield_imm 2 (global camlCode!) iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (for y/1046 -39 to 38
                    (seq
                      (if (== 1 n/1045)
                        (seq
                          (let (oc/1075 (field 23 (global camlPervasives!)))
                            (caml_ml_output oc/1075 "" 0 (string.length "")))
                          (caml_ml_output_char
                            (field 23 (global camlPervasives!)) '\n')
                          (caml_ml_flush (field 23 (global camlPervasives!))))
                        0a)
                      (for x/1047 -39 to 38
                        (let
                          (i/1048
                             (camlCode__iterate_1033 
                               (/. (float_of_int x/1047) 40.0)
                               (-. (/. (float_of_int y/1046) 40.0) 0.5)))
                          (if (== 1 n/1045)
                            (let
                              (s/1076 (if (== 0 i/1048) "*" " ")
                               oc/1077 (field 23 (global camlPervasives!)))
                              (caml_ml_output oc/1077 s/1076 0
                                (string.length s/1076)))
                            0a)))))) {2} ))
    (setfield_imm 3 (global camlCode!) mandelbrot/1044))
  (let (start_time/1049 (caml_sys_time 0a))
    (seq
      (for iter/1050 1 to 100
        (for y/1078 -39 to 38
          (seq
            (if (== 1 iter/1050)
              (seq
                (let (oc/1083 (field 23 (global camlPervasives!)))
                  (caml_ml_output oc/1083 "" 0 (string.length "")))
                (caml_ml_output_char (field 23 (global camlPervasives!))
                  '\n')
                (caml_ml_flush (field 23 (global camlPervasives!))))
              0a)
            (for x/1079 -39 to 38
              (let
                (i/1080
                   (camlCode__iterate_1033  (/. (float_of_int x/1079) 40.0)
                     (-. (/. (float_of_int y/1078) 40.0) 0.5)))
                (if (== 1 iter/1050)
                  (let
                    (s/1081 (if (== 0 i/1080) "*" " ")
                     oc/1082 (field 23 (global camlPervasives!)))
                    (caml_ml_output oc/1082 s/1081 0 (string.length s/1081)))
                  0a))))))
      (let (oc/1084 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1084 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))
      (let
        (f/1085 (-. (caml_sys_time 0a) start_time/1049)
         s/1086
           (camlPervasives__valid_float_lexem_1136 
             (caml_format_float "%.12g" f/1085))
         oc/1087 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1087 s/1086 0 (string.length s/1086)))
      (let (oc/1088 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1088 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))))
  0a)
After TonSlambda.optimize:
(seq
  (let (temp/1207 (global camlCode!) temp/1208 100)
    (setfield_imm 0 temp/1207 temp/1208))
  (let (temp/1205 (global camlCode!) temp/1206 1000)
    (setfield_imm 1 temp/1205 temp/1206))
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (let
                                            (temp/1194
                                               (let
                                                 (temp/1195
                                                    (let (temp/1196 1000)
                                                      (> i/1040 temp/1196)))
                                                 (if temp/1195 0
                                                   (let
                                                     (temp/1041
                                                        (*. zr/1039 zi/1038)
                                                      zr2/1042
                                                        (*. zr/1039 zr/1039)
                                                      zi2/1043
                                                        (*. zi/1038 zi/1038)
                                                      temp/1197
                                                        (let
                                                          (temp/1198
                                                             (+. zi2/1043
                                                               zr2/1042)
                                                           temp/1199
                                                             (field 5
                                                               env/1064))
                                                          (>. temp/1198
                                                            temp/1199)))
                                                     (if temp/1197 i/1040
                                                       (let
                                                         (arg/1055
                                                            (let
                                                              (temp/1203
                                                                 (+.
                                                                   temp/1041
                                                                   temp/1041)
                                                               temp/1204
                                                                 (field 3
                                                                   env/1064))
                                                              (+. temp/1203
                                                                temp/1204))
                                                          arg/1056
                                                            (let
                                                              (temp/1201
                                                                 (-. zr2/1042
                                                                   zi2/1043)
                                                               temp/1202
                                                                 (field 4
                                                                   env/1064))
                                                              (+. temp/1201
                                                                temp/1202))
                                                          arg/1057
                                                            (let
                                                              (temp/1200 1)
                                                              (+ i/1040
                                                                temp/1200)))
                                                         (seq
                                                           (assign i/1040
                                                             arg/1057)
                                                           (assign zr/1039
                                                             arg/1056)
                                                           (assign zi/1038
                                                             arg/1055)
                                                           (exit 11))))))))
                                            (exit 12 temp/1194))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (let
                            (temp/1183
                               (let
                                 (temp/1184
                                    (let (temp/1185 1000)
                                      (> i/1065 temp/1185)))
                                 (if temp/1184 0
                                   (let
                                     (temp/1068 (*. zr/1066 zi/1067)
                                      zr2/1069 (*. zr/1066 zr/1066)
                                      zi2/1070 (*. zi/1067 zi/1067)
                                      temp/1186
                                        (let
                                          (temp/1187 (+. zi2/1070 zr2/1069)
                                           temp/1188 (field 5 loop/1037))
                                          (>. temp/1187 temp/1188)))
                                     (if temp/1186 i/1065
                                       (let
                                         (arg/1071
                                            (let
                                              (temp/1192
                                                 (+. temp/1068 temp/1068)
                                               temp/1193 (field 3 loop/1037))
                                              (+. temp/1192 temp/1193))
                                          arg/1072
                                            (let
                                              (temp/1190
                                                 (-. zr2/1069 zi2/1070)
                                               temp/1191 (field 4 loop/1037))
                                              (+. temp/1190 temp/1191))
                                          arg/1073
                                            (let (temp/1189 1)
                                              (+ i/1065 temp/1189)))
                                         (seq (assign i/1065 arg/1073)
                                           (assign zr/1066 arg/1072)
                                           (assign zi/1067 arg/1071)
                                           (exit 11))))))))
                            (exit 12 temp/1183))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} )
     temp/1182 (global camlCode!))
    (setfield_imm 2 temp/1182 iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (let (temp/1151 -39 temp/1152 38)
                    (for y/1046 temp/1151 to temp/1152
                      (seq
                        (let
                          (temp/1170
                             (let (temp/1171 1) (== temp/1171 n/1045)))
                          (if temp/1170
                            (seq
                              (let
                                (oc/1075
                                   (let (temp/1181 (global camlPervasives!))
                                     (field 23 temp/1181))
                                 temp/1177 ""
                                 temp/1178 0
                                 temp/1179
                                   (let (temp/1180 "")
                                     (string.length temp/1180)))
                                (caml_ml_output oc/1075 temp/1177 temp/1178
                                  temp/1179))
                              (let
                                (temp/1174
                                   (let (temp/1175 (global camlPervasives!))
                                     (field 23 temp/1175))
                                 temp/1176 '\n')
                                (caml_ml_output_char temp/1174 temp/1176))
                              (let
                                (temp/1172
                                   (let (temp/1173 (global camlPervasives!))
                                     (field 23 temp/1173)))
                                (caml_ml_flush temp/1172)))
                            0a))
                        (let (temp/1153 -39 temp/1154 38)
                          (for x/1047 temp/1153 to temp/1154
                            (let
                              (i/1048
                                 (let
                                   (temp/1162
                                      (let
                                        (temp/1163 (float_of_int x/1047)
                                         temp/1164 40.0)
                                        (/. temp/1163 temp/1164))
                                    temp/1165
                                      (let
                                        (temp/1166
                                           (let
                                             (temp/1167 (float_of_int y/1046)
                                              temp/1168 40.0)
                                             (/. temp/1167 temp/1168))
                                         temp/1169 0.5)
                                        (-. temp/1166 temp/1169)))
                                   (camlCode__iterate_1033  temp/1162
                                     temp/1165))
                               temp/1155
                                 (let (temp/1156 1) (== temp/1156 n/1045)))
                              (if temp/1155
                                (let
                                  (s/1076
                                     (let
                                       (temp/1160
                                          (let (temp/1161 0)
                                            (== temp/1161 i/1048)))
                                       (if temp/1160 "*" " "))
                                   oc/1077
                                     (let
                                       (temp/1159 (global camlPervasives!))
                                       (field 23 temp/1159))
                                   temp/1157 0
                                   temp/1158 (string.length s/1076))
                                  (caml_ml_output oc/1077 s/1076 temp/1157
                                    temp/1158))
                                0a)))))))) {2} )
     temp/1150 (global camlCode!))
    (setfield_imm 3 temp/1150 mandelbrot/1044))
  (let (start_time/1049 (let (temp/1149 0a) (caml_sys_time temp/1149)))
    (seq
      (let (temp/1116 1 temp/1117 100)
        (for iter/1050 temp/1116 to temp/1117
          (let (temp/1118 -39 temp/1119 38)
            (for y/1078 temp/1118 to temp/1119
              (seq
                (let (temp/1137 (let (temp/1138 1) (== temp/1138 iter/1050)))
                  (if temp/1137
                    (seq
                      (let
                        (oc/1083
                           (let (temp/1148 (global camlPervasives!))
                             (field 23 temp/1148))
                         temp/1144 ""
                         temp/1145 0
                         temp/1146
                           (let (temp/1147 "") (string.length temp/1147)))
                        (caml_ml_output oc/1083 temp/1144 temp/1145
                          temp/1146))
                      (let
                        (temp/1141
                           (let (temp/1142 (global camlPervasives!))
                             (field 23 temp/1142))
                         temp/1143 '\n')
                        (caml_ml_output_char temp/1141 temp/1143))
                      (let
                        (temp/1139
                           (let (temp/1140 (global camlPervasives!))
                             (field 23 temp/1140)))
                        (caml_ml_flush temp/1139)))
                    0a))
                (let (temp/1120 -39 temp/1121 38)
                  (for x/1079 temp/1120 to temp/1121
                    (let
                      (i/1080
                         (let
                           (temp/1129
                              (let
                                (temp/1130 (float_of_int x/1079)
                                 temp/1131 40.0)
                                (/. temp/1130 temp/1131))
                            temp/1132
                              (let
                                (temp/1133
                                   (let
                                     (temp/1134 (float_of_int y/1078)
                                      temp/1135 40.0)
                                     (/. temp/1134 temp/1135))
                                 temp/1136 0.5)
                                (-. temp/1133 temp/1136)))
                           (camlCode__iterate_1033  temp/1129 temp/1132))
                       temp/1122 (let (temp/1123 1) (== temp/1123 iter/1050)))
                      (if temp/1122
                        (let
                          (s/1081
                             (let
                               (temp/1127
                                  (let (temp/1128 0) (== temp/1128 i/1080)))
                               (if temp/1127 "*" " "))
                           oc/1082
                             (let (temp/1126 (global camlPervasives!))
                               (field 23 temp/1126))
                           temp/1124 0
                           temp/1125 (string.length s/1081))
                          (caml_ml_output oc/1082 s/1081 temp/1124 temp/1125))
                        0a)))))))))
      (let
        (oc/1084
           (let (temp/1115 (global camlPervasives!)) (field 23 temp/1115))
         temp/1111 ""
         temp/1112 0
         temp/1113 (let (temp/1114 "") (string.length temp/1114)))
        (caml_ml_output oc/1084 temp/1111 temp/1112 temp/1113))
      (let
        (temp/1108
           (let (temp/1109 (global camlPervasives!)) (field 23 temp/1109))
         temp/1110 '\n')
        (caml_ml_output_char temp/1108 temp/1110))
      (let
        (temp/1106
           (let (temp/1107 (global camlPervasives!)) (field 23 temp/1107)))
        (caml_ml_flush temp/1106))
      (let
        (f/1085
           (let (temp/1104 (let (temp/1105 0a) (caml_sys_time temp/1105)))
             (-. temp/1104 start_time/1049))
         s/1086
           (let
             (temp/1102
                (let (temp/1103 "%.12g")
                  (caml_format_float temp/1103 f/1085)))
             (camlPervasives__valid_float_lexem_1136  temp/1102))
         oc/1087
           (let (temp/1101 (global camlPervasives!)) (field 23 temp/1101))
         temp/1099 0
         temp/1100 (string.length s/1086))
        (caml_ml_output oc/1087 s/1086 temp/1099 temp/1100))
      (let
        (oc/1088
           (let (temp/1098 (global camlPervasives!)) (field 23 temp/1098))
         temp/1094 ""
         temp/1095 0
         temp/1096 (let (temp/1097 "") (string.length temp/1097)))
        (caml_ml_output oc/1088 temp/1094 temp/1095 temp/1096))
      (let
        (temp/1091
           (let (temp/1092 (global camlPervasives!)) (field 23 temp/1092))
         temp/1093 '\n')
        (caml_ml_output_char temp/1091 temp/1093))
      (let
        (temp/1089
           (let (temp/1090 (global camlPervasives!)) (field 23 temp/1090)))
        (caml_ml_flush temp/1089))))
  0a)
Before TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (setfield_imm 0 temp/1207 100)
    (let (temp/1205 (global camlCode!))
      (seq (setfield_imm 1 temp/1205 1000)
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184 (> i/1065 1000)
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073 (+ i/1065 1))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (for y/1046 -39 to 38
                              (let (temp/1170 (== 1 n/1045))
                                (seq
                                  (if temp/1170
                                    (let
                                      (temp/1181 (global camlPervasives!)
                                       oc/1075 (field 23 temp/1181)
                                       temp/1177 ""
                                       temp/1180 ""
                                       temp/1179 (string.length temp/1180))
                                      (seq
                                        (caml_ml_output oc/1075 temp/1177 0
                                          temp/1179)
                                        (let
                                          (temp/1175 (global camlPervasives!)
                                           temp/1174 (field 23 temp/1175))
                                          (seq
                                            (caml_ml_output_char temp/1174
                                              10)
                                            (let
                                              (temp/1173
                                                 (global camlPervasives!)
                                               temp/1172 (field 23 temp/1173))
                                              (caml_ml_flush temp/1172))))))
                                    0a)
                                  (for x/1047 -39 to 38
                                    (let
                                      (temp/1163 (float_of_int x/1047)
                                       temp/1164 40.0
                                       temp/1162 (/. temp/1163 temp/1164)
                                       temp/1167 (float_of_int y/1046)
                                       temp/1168 40.0
                                       temp/1166 (/. temp/1167 temp/1168)
                                       temp/1169 0.5
                                       temp/1165 (-. temp/1166 temp/1169)
                                       i/1048
                                         (camlCode__iterate_1033  temp/1162
                                           temp/1165)
                                       temp/1155 (== 1 n/1045))
                                      (if temp/1155
                                        (let
                                          (temp/1160 (== 0 i/1048)
                                           s/1076 (if temp/1160 "*" " ")
                                           temp/1159 (global camlPervasives!)
                                           oc/1077 (field 23 temp/1159)
                                           temp/1158 (string.length s/1076))
                                          (caml_ml_output oc/1077 s/1076 0
                                            temp/1158))
                                        0a))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let (start_time/1049 (caml_sys_time 0a))
                  (seq
                    (seq
                      (for iter/1050 1 to 100
                        (for y/1078 -39 to 38
                          (let (temp/1137 (== 1 iter/1050))
                            (seq
                              (if temp/1137
                                (let
                                  (temp/1148 (global camlPervasives!)
                                   oc/1083 (field 23 temp/1148)
                                   temp/1144 ""
                                   temp/1147 ""
                                   temp/1146 (string.length temp/1147))
                                  (seq
                                    (caml_ml_output oc/1083 temp/1144 0
                                      temp/1146)
                                    (let
                                      (temp/1142 (global camlPervasives!)
                                       temp/1141 (field 23 temp/1142))
                                      (seq (caml_ml_output_char temp/1141 10)
                                        (let
                                          (temp/1140 (global camlPervasives!)
                                           temp/1139 (field 23 temp/1140))
                                          (caml_ml_flush temp/1139))))))
                                0a)
                              (for x/1079 -39 to 38
                                (let
                                  (temp/1130 (float_of_int x/1079)
                                   temp/1131 40.0
                                   temp/1129 (/. temp/1130 temp/1131)
                                   temp/1134 (float_of_int y/1078)
                                   temp/1135 40.0
                                   temp/1133 (/. temp/1134 temp/1135)
                                   temp/1136 0.5
                                   temp/1132 (-. temp/1133 temp/1136)
                                   i/1080
                                     (camlCode__iterate_1033  temp/1129
                                       temp/1132)
                                   temp/1122 (== 1 iter/1050))
                                  (if temp/1122
                                    (let
                                      (temp/1127 (== 0 i/1080)
                                       s/1081 (if temp/1127 "*" " ")
                                       temp/1126 (global camlPervasives!)
                                       oc/1082 (field 23 temp/1126)
                                       temp/1125 (string.length s/1081))
                                      (caml_ml_output oc/1082 s/1081 0
                                        temp/1125))
                                    0a)))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq (caml_ml_output oc/1084 temp/1111 0 temp/1113)
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq (caml_ml_output_char temp/1108 10)
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104 (caml_sys_time 0a)
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq (caml_ml_output oc/1087 s/1086 0 temp/1100)
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (caml_ml_output oc/1088 temp/1094 0
                                    temp/1096)
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq (caml_ml_output_char temp/1091 10)
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
After TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (let (temp/1241 100) (setfield_imm 0 temp/1207 temp/1241))
    (let (temp/1205 (global camlCode!))
      (seq (let (temp/1240 1000) (setfield_imm 1 temp/1205 temp/1240))
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184
                                     (let (temp/1239 1000)
                                       (> i/1065 temp/1239))
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073
                                                (let (temp/1238 1)
                                                  (+ i/1065 temp/1238)))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (let (temp/1228 -39 temp/1229 38)
                              (for y/1046 temp/1228 to temp/1229
                                (let
                                  (temp/1170
                                     (let (temp/1237 1)
                                       (== temp/1237 n/1045)))
                                  (seq
                                    (if temp/1170
                                      (let
                                        (temp/1181 (global camlPervasives!)
                                         oc/1075 (field 23 temp/1181)
                                         temp/1177 ""
                                         temp/1180 ""
                                         temp/1179 (string.length temp/1180))
                                        (seq
                                          (let (temp/1236 0)
                                            (caml_ml_output oc/1075 temp/1177
                                              temp/1236 temp/1179))
                                          (let
                                            (temp/1175
                                               (global camlPervasives!)
                                             temp/1174 (field 23 temp/1175))
                                            (seq
                                              (let (temp/1235 10)
                                                (caml_ml_output_char
                                                  temp/1174 temp/1235))
                                              (let
                                                (temp/1173
                                                   (global camlPervasives!)
                                                 temp/1172
                                                   (field 23 temp/1173))
                                                (caml_ml_flush temp/1172))))))
                                      0a)
                                    (let (temp/1230 -39 temp/1231 38)
                                      (for x/1047 temp/1230 to temp/1231
                                        (let
                                          (temp/1163 (float_of_int x/1047)
                                           temp/1164 40.0
                                           temp/1162 (/. temp/1163 temp/1164)
                                           temp/1167 (float_of_int y/1046)
                                           temp/1168 40.0
                                           temp/1166 (/. temp/1167 temp/1168)
                                           temp/1169 0.5
                                           temp/1165 (-. temp/1166 temp/1169)
                                           i/1048
                                             (camlCode__iterate_1033 
                                               temp/1162 temp/1165)
                                           temp/1155
                                             (let (temp/1234 1)
                                               (== temp/1234 n/1045)))
                                          (if temp/1155
                                            (let
                                              (temp/1160
                                                 (let (temp/1233 0)
                                                   (== temp/1233 i/1048))
                                               s/1076 (if temp/1160 "*" " ")
                                               temp/1159
                                                 (global camlPervasives!)
                                               oc/1077 (field 23 temp/1159)
                                               temp/1158
                                                 (string.length s/1076)
                                               temp/1232 0)
                                              (caml_ml_output oc/1077 s/1076
                                                temp/1232 temp/1158))
                                            0a))))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let
                  (start_time/1049
                     (let (temp/1227 0a) (caml_sys_time temp/1227)))
                  (seq
                    (seq
                      (let (temp/1215 1 temp/1216 100)
                        (for iter/1050 temp/1215 to temp/1216
                          (let (temp/1217 -39 temp/1218 38)
                            (for y/1078 temp/1217 to temp/1218
                              (let
                                (temp/1137
                                   (let (temp/1226 1)
                                     (== temp/1226 iter/1050)))
                                (seq
                                  (if temp/1137
                                    (let
                                      (temp/1148 (global camlPervasives!)
                                       oc/1083 (field 23 temp/1148)
                                       temp/1144 ""
                                       temp/1147 ""
                                       temp/1146 (string.length temp/1147))
                                      (seq
                                        (let (temp/1225 0)
                                          (caml_ml_output oc/1083 temp/1144
                                            temp/1225 temp/1146))
                                        (let
                                          (temp/1142 (global camlPervasives!)
                                           temp/1141 (field 23 temp/1142))
                                          (seq
                                            (let (temp/1224 10)
                                              (caml_ml_output_char temp/1141
                                                temp/1224))
                                            (let
                                              (temp/1140
                                                 (global camlPervasives!)
                                               temp/1139 (field 23 temp/1140))
                                              (caml_ml_flush temp/1139))))))
                                    0a)
                                  (let (temp/1219 -39 temp/1220 38)
                                    (for x/1079 temp/1219 to temp/1220
                                      (let
                                        (temp/1130 (float_of_int x/1079)
                                         temp/1131 40.0
                                         temp/1129 (/. temp/1130 temp/1131)
                                         temp/1134 (float_of_int y/1078)
                                         temp/1135 40.0
                                         temp/1133 (/. temp/1134 temp/1135)
                                         temp/1136 0.5
                                         temp/1132 (-. temp/1133 temp/1136)
                                         i/1080
                                           (camlCode__iterate_1033  temp/1129
                                             temp/1132)
                                         temp/1122
                                           (let (temp/1223 1)
                                             (== temp/1223 iter/1050)))
                                        (if temp/1122
                                          (let
                                            (temp/1127
                                               (let (temp/1222 0)
                                                 (== temp/1222 i/1080))
                                             s/1081 (if temp/1127 "*" " ")
                                             temp/1126
                                               (global camlPervasives!)
                                             oc/1082 (field 23 temp/1126)
                                             temp/1125 (string.length s/1081)
                                             temp/1221 0)
                                            (caml_ml_output oc/1082 s/1081
                                              temp/1221 temp/1125))
                                          0a))))))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq
                            (let (temp/1214 0)
                              (caml_ml_output oc/1084 temp/1111 temp/1214
                                temp/1113))
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq
                                (let (temp/1213 10)
                                  (caml_ml_output_char temp/1108 temp/1213))
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104
                               (let (temp/1212 0a) (caml_sys_time temp/1212))
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq
                              (let (temp/1211 0)
                                (caml_ml_output oc/1087 s/1086 temp/1211
                                  temp/1100))
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (let (temp/1210 0)
                                    (caml_ml_output oc/1088 temp/1094
                                      temp/1210 temp/1096))
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq
                                      (let (temp/1209 10)
                                        (caml_ml_output_char temp/1091
                                          temp/1209))
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
Before TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
After TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
Before TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
After TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
Before TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))
After TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))
-dclosure2
[inline] iterate_1033 cannot be inlined: local fun
Before TonSlambda.optimize:
(seq (setfield_imm 0 (global camlCode!) 100)
  (setfield_imm 1 (global camlCode!) 1000)
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (exit 12
                                            (if (> i/1040 1000) 0
                                              (let
                                                (temp/1041
                                                   (*. zr/1039 zi/1038)
                                                 zr2/1042
                                                   (*. zr/1039 zr/1039)
                                                 zi2/1043
                                                   (*. zi/1038 zi/1038))
                                                (if
                                                  (>. (+. zi2/1043 zr2/1042)
                                                    (field 5 env/1064))
                                                  i/1040
                                                  (let
                                                    (arg/1055
                                                       (+.
                                                         (+. temp/1041
                                                           temp/1041)
                                                         (field 3 env/1064))
                                                     arg/1056
                                                       (+.
                                                         (-. zr2/1042
                                                           zi2/1043)
                                                         (field 4 env/1064))
                                                     arg/1057 (+ i/1040 1))
                                                    (seq
                                                      (assign i/1040
                                                        arg/1057)
                                                      (assign zr/1039
                                                        arg/1056)
                                                      (assign zi/1038
                                                        arg/1055)
                                                      (exit 11)))))))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (exit 12
                            (if (> i/1065 1000) 0
                              (let
                                (temp/1068 (*. zr/1066 zi/1067)
                                 zr2/1069 (*. zr/1066 zr/1066)
                                 zi2/1070 (*. zi/1067 zi/1067))
                                (if
                                  (>. (+. zi2/1070 zr2/1069)
                                    (field 5 loop/1037))
                                  i/1065
                                  (let
                                    (arg/1071
                                       (+. (+. temp/1068 temp/1068)
                                         (field 3 loop/1037))
                                     arg/1072
                                       (+. (-. zr2/1069 zi2/1070)
                                         (field 4 loop/1037))
                                     arg/1073 (+ i/1065 1))
                                    (seq (assign i/1065 arg/1073)
                                      (assign zr/1066 arg/1072)
                                      (assign zi/1067 arg/1071) (exit 11)))))))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} ))
    (setfield_imm 2 (global camlCode!) iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (for y/1046 -39 to 38
                    (seq
                      (if (== 1 n/1045)
                        (seq
                          (let (oc/1075 (field 23 (global camlPervasives!)))
                            (caml_ml_output oc/1075 "" 0 (string.length "")))
                          (caml_ml_output_char
                            (field 23 (global camlPervasives!)) '\n')
                          (caml_ml_flush (field 23 (global camlPervasives!))))
                        0a)
                      (for x/1047 -39 to 38
                        (let
                          (i/1048
                             (camlCode__iterate_1033 
                               (/. (float_of_int x/1047) 40.0)
                               (-. (/. (float_of_int y/1046) 40.0) 0.5)))
                          (if (== 1 n/1045)
                            (let
                              (s/1076 (if (== 0 i/1048) "*" " ")
                               oc/1077 (field 23 (global camlPervasives!)))
                              (caml_ml_output oc/1077 s/1076 0
                                (string.length s/1076)))
                            0a)))))) {2} ))
    (setfield_imm 3 (global camlCode!) mandelbrot/1044))
  (let (start_time/1049 (caml_sys_time 0a))
    (seq
      (for iter/1050 1 to 100
        (for y/1078 -39 to 38
          (seq
            (if (== 1 iter/1050)
              (seq
                (let (oc/1083 (field 23 (global camlPervasives!)))
                  (caml_ml_output oc/1083 "" 0 (string.length "")))
                (caml_ml_output_char (field 23 (global camlPervasives!))
                  '\n')
                (caml_ml_flush (field 23 (global camlPervasives!))))
              0a)
            (for x/1079 -39 to 38
              (let
                (i/1080
                   (camlCode__iterate_1033  (/. (float_of_int x/1079) 40.0)
                     (-. (/. (float_of_int y/1078) 40.0) 0.5)))
                (if (== 1 iter/1050)
                  (let
                    (s/1081 (if (== 0 i/1080) "*" " ")
                     oc/1082 (field 23 (global camlPervasives!)))
                    (caml_ml_output oc/1082 s/1081 0 (string.length s/1081)))
                  0a))))))
      (let (oc/1084 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1084 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))
      (let
        (f/1085 (-. (caml_sys_time 0a) start_time/1049)
         s/1086
           (camlPervasives__valid_float_lexem_1136 
             (caml_format_float "%.12g" f/1085))
         oc/1087 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1087 s/1086 0 (string.length s/1086)))
      (let (oc/1088 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1088 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))))
  0a)
After TonSlambda.optimize:
(seq
  (let (temp/1207 (global camlCode!) temp/1208 100)
    (setfield_imm 0 temp/1207 temp/1208))
  (let (temp/1205 (global camlCode!) temp/1206 1000)
    (setfield_imm 1 temp/1205 temp/1206))
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (let
                                            (temp/1194
                                               (let
                                                 (temp/1195
                                                    (let (temp/1196 1000)
                                                      (> i/1040 temp/1196)))
                                                 (if temp/1195 0
                                                   (let
                                                     (temp/1041
                                                        (*. zr/1039 zi/1038)
                                                      zr2/1042
                                                        (*. zr/1039 zr/1039)
                                                      zi2/1043
                                                        (*. zi/1038 zi/1038)
                                                      temp/1197
                                                        (let
                                                          (temp/1198
                                                             (+. zi2/1043
                                                               zr2/1042)
                                                           temp/1199
                                                             (field 5
                                                               env/1064))
                                                          (>. temp/1198
                                                            temp/1199)))
                                                     (if temp/1197 i/1040
                                                       (let
                                                         (arg/1055
                                                            (let
                                                              (temp/1203
                                                                 (+.
                                                                   temp/1041
                                                                   temp/1041)
                                                               temp/1204
                                                                 (field 3
                                                                   env/1064))
                                                              (+. temp/1203
                                                                temp/1204))
                                                          arg/1056
                                                            (let
                                                              (temp/1201
                                                                 (-. zr2/1042
                                                                   zi2/1043)
                                                               temp/1202
                                                                 (field 4
                                                                   env/1064))
                                                              (+. temp/1201
                                                                temp/1202))
                                                          arg/1057
                                                            (let
                                                              (temp/1200 1)
                                                              (+ i/1040
                                                                temp/1200)))
                                                         (seq
                                                           (assign i/1040
                                                             arg/1057)
                                                           (assign zr/1039
                                                             arg/1056)
                                                           (assign zi/1038
                                                             arg/1055)
                                                           (exit 11))))))))
                                            (exit 12 temp/1194))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (let
                            (temp/1183
                               (let
                                 (temp/1184
                                    (let (temp/1185 1000)
                                      (> i/1065 temp/1185)))
                                 (if temp/1184 0
                                   (let
                                     (temp/1068 (*. zr/1066 zi/1067)
                                      zr2/1069 (*. zr/1066 zr/1066)
                                      zi2/1070 (*. zi/1067 zi/1067)
                                      temp/1186
                                        (let
                                          (temp/1187 (+. zi2/1070 zr2/1069)
                                           temp/1188 (field 5 loop/1037))
                                          (>. temp/1187 temp/1188)))
                                     (if temp/1186 i/1065
                                       (let
                                         (arg/1071
                                            (let
                                              (temp/1192
                                                 (+. temp/1068 temp/1068)
                                               temp/1193 (field 3 loop/1037))
                                              (+. temp/1192 temp/1193))
                                          arg/1072
                                            (let
                                              (temp/1190
                                                 (-. zr2/1069 zi2/1070)
                                               temp/1191 (field 4 loop/1037))
                                              (+. temp/1190 temp/1191))
                                          arg/1073
                                            (let (temp/1189 1)
                                              (+ i/1065 temp/1189)))
                                         (seq (assign i/1065 arg/1073)
                                           (assign zr/1066 arg/1072)
                                           (assign zi/1067 arg/1071)
                                           (exit 11))))))))
                            (exit 12 temp/1183))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} )
     temp/1182 (global camlCode!))
    (setfield_imm 2 temp/1182 iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (let (temp/1151 -39 temp/1152 38)
                    (for y/1046 temp/1151 to temp/1152
                      (seq
                        (let
                          (temp/1170
                             (let (temp/1171 1) (== temp/1171 n/1045)))
                          (if temp/1170
                            (seq
                              (let
                                (oc/1075
                                   (let (temp/1181 (global camlPervasives!))
                                     (field 23 temp/1181))
                                 temp/1177 ""
                                 temp/1178 0
                                 temp/1179
                                   (let (temp/1180 "")
                                     (string.length temp/1180)))
                                (caml_ml_output oc/1075 temp/1177 temp/1178
                                  temp/1179))
                              (let
                                (temp/1174
                                   (let (temp/1175 (global camlPervasives!))
                                     (field 23 temp/1175))
                                 temp/1176 '\n')
                                (caml_ml_output_char temp/1174 temp/1176))
                              (let
                                (temp/1172
                                   (let (temp/1173 (global camlPervasives!))
                                     (field 23 temp/1173)))
                                (caml_ml_flush temp/1172)))
                            0a))
                        (let (temp/1153 -39 temp/1154 38)
                          (for x/1047 temp/1153 to temp/1154
                            (let
                              (i/1048
                                 (let
                                   (temp/1162
                                      (let
                                        (temp/1163 (float_of_int x/1047)
                                         temp/1164 40.0)
                                        (/. temp/1163 temp/1164))
                                    temp/1165
                                      (let
                                        (temp/1166
                                           (let
                                             (temp/1167 (float_of_int y/1046)
                                              temp/1168 40.0)
                                             (/. temp/1167 temp/1168))
                                         temp/1169 0.5)
                                        (-. temp/1166 temp/1169)))
                                   (camlCode__iterate_1033  temp/1162
                                     temp/1165))
                               temp/1155
                                 (let (temp/1156 1) (== temp/1156 n/1045)))
                              (if temp/1155
                                (let
                                  (s/1076
                                     (let
                                       (temp/1160
                                          (let (temp/1161 0)
                                            (== temp/1161 i/1048)))
                                       (if temp/1160 "*" " "))
                                   oc/1077
                                     (let
                                       (temp/1159 (global camlPervasives!))
                                       (field 23 temp/1159))
                                   temp/1157 0
                                   temp/1158 (string.length s/1076))
                                  (caml_ml_output oc/1077 s/1076 temp/1157
                                    temp/1158))
                                0a)))))))) {2} )
     temp/1150 (global camlCode!))
    (setfield_imm 3 temp/1150 mandelbrot/1044))
  (let (start_time/1049 (let (temp/1149 0a) (caml_sys_time temp/1149)))
    (seq
      (let (temp/1116 1 temp/1117 100)
        (for iter/1050 temp/1116 to temp/1117
          (let (temp/1118 -39 temp/1119 38)
            (for y/1078 temp/1118 to temp/1119
              (seq
                (let (temp/1137 (let (temp/1138 1) (== temp/1138 iter/1050)))
                  (if temp/1137
                    (seq
                      (let
                        (oc/1083
                           (let (temp/1148 (global camlPervasives!))
                             (field 23 temp/1148))
                         temp/1144 ""
                         temp/1145 0
                         temp/1146
                           (let (temp/1147 "") (string.length temp/1147)))
                        (caml_ml_output oc/1083 temp/1144 temp/1145
                          temp/1146))
                      (let
                        (temp/1141
                           (let (temp/1142 (global camlPervasives!))
                             (field 23 temp/1142))
                         temp/1143 '\n')
                        (caml_ml_output_char temp/1141 temp/1143))
                      (let
                        (temp/1139
                           (let (temp/1140 (global camlPervasives!))
                             (field 23 temp/1140)))
                        (caml_ml_flush temp/1139)))
                    0a))
                (let (temp/1120 -39 temp/1121 38)
                  (for x/1079 temp/1120 to temp/1121
                    (let
                      (i/1080
                         (let
                           (temp/1129
                              (let
                                (temp/1130 (float_of_int x/1079)
                                 temp/1131 40.0)
                                (/. temp/1130 temp/1131))
                            temp/1132
                              (let
                                (temp/1133
                                   (let
                                     (temp/1134 (float_of_int y/1078)
                                      temp/1135 40.0)
                                     (/. temp/1134 temp/1135))
                                 temp/1136 0.5)
                                (-. temp/1133 temp/1136)))
                           (camlCode__iterate_1033  temp/1129 temp/1132))
                       temp/1122 (let (temp/1123 1) (== temp/1123 iter/1050)))
                      (if temp/1122
                        (let
                          (s/1081
                             (let
                               (temp/1127
                                  (let (temp/1128 0) (== temp/1128 i/1080)))
                               (if temp/1127 "*" " "))
                           oc/1082
                             (let (temp/1126 (global camlPervasives!))
                               (field 23 temp/1126))
                           temp/1124 0
                           temp/1125 (string.length s/1081))
                          (caml_ml_output oc/1082 s/1081 temp/1124 temp/1125))
                        0a)))))))))
      (let
        (oc/1084
           (let (temp/1115 (global camlPervasives!)) (field 23 temp/1115))
         temp/1111 ""
         temp/1112 0
         temp/1113 (let (temp/1114 "") (string.length temp/1114)))
        (caml_ml_output oc/1084 temp/1111 temp/1112 temp/1113))
      (let
        (temp/1108
           (let (temp/1109 (global camlPervasives!)) (field 23 temp/1109))
         temp/1110 '\n')
        (caml_ml_output_char temp/1108 temp/1110))
      (let
        (temp/1106
           (let (temp/1107 (global camlPervasives!)) (field 23 temp/1107)))
        (caml_ml_flush temp/1106))
      (let
        (f/1085
           (let (temp/1104 (let (temp/1105 0a) (caml_sys_time temp/1105)))
             (-. temp/1104 start_time/1049))
         s/1086
           (let
             (temp/1102
                (let (temp/1103 "%.12g")
                  (caml_format_float temp/1103 f/1085)))
             (camlPervasives__valid_float_lexem_1136  temp/1102))
         oc/1087
           (let (temp/1101 (global camlPervasives!)) (field 23 temp/1101))
         temp/1099 0
         temp/1100 (string.length s/1086))
        (caml_ml_output oc/1087 s/1086 temp/1099 temp/1100))
      (let
        (oc/1088
           (let (temp/1098 (global camlPervasives!)) (field 23 temp/1098))
         temp/1094 ""
         temp/1095 0
         temp/1096 (let (temp/1097 "") (string.length temp/1097)))
        (caml_ml_output oc/1088 temp/1094 temp/1095 temp/1096))
      (let
        (temp/1091
           (let (temp/1092 (global camlPervasives!)) (field 23 temp/1092))
         temp/1093 '\n')
        (caml_ml_output_char temp/1091 temp/1093))
      (let
        (temp/1089
           (let (temp/1090 (global camlPervasives!)) (field 23 temp/1090)))
        (caml_ml_flush temp/1089))))
  0a)
*** After TonClosure.optimize:
(let (temp/1207 (global camlCode!))
  (seq (setfield_imm 0 temp/1207 100)
    (let (temp/1205 (global camlCode!))
      (seq (setfield_imm 1 temp/1205 1000)
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184 (> i/1065 1000)
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073 (+ i/1065 1))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (for y/1046 -39 to 38
                              (let (temp/1170 (== 1 n/1045))
                                (seq
                                  (if temp/1170
                                    (let
                                      (temp/1181 (global camlPervasives!)
                                       oc/1075 (field 23 temp/1181)
                                       temp/1177 ""
                                       temp/1180 ""
                                       temp/1179 (string.length temp/1180))
                                      (seq
                                        (caml_ml_output oc/1075 temp/1177 0
                                          temp/1179)
                                        (let
                                          (temp/1175 (global camlPervasives!)
                                           temp/1174 (field 23 temp/1175))
                                          (seq
                                            (caml_ml_output_char temp/1174
                                              10)
                                            (let
                                              (temp/1173
                                                 (global camlPervasives!)
                                               temp/1172 (field 23 temp/1173))
                                              (caml_ml_flush temp/1172))))))
                                    0a)
                                  (for x/1047 -39 to 38
                                    (let
                                      (temp/1163 (float_of_int x/1047)
                                       temp/1164 40.0
                                       temp/1162 (/. temp/1163 temp/1164)
                                       temp/1167 (float_of_int y/1046)
                                       temp/1168 40.0
                                       temp/1166 (/. temp/1167 temp/1168)
                                       temp/1169 0.5
                                       temp/1165 (-. temp/1166 temp/1169)
                                       i/1048
                                         (camlCode__iterate_1033  temp/1162
                                           temp/1165)
                                       temp/1155 (== 1 n/1045))
                                      (if temp/1155
                                        (let
                                          (temp/1160 (== 0 i/1048)
                                           s/1076 (if temp/1160 "*" " ")
                                           temp/1159 (global camlPervasives!)
                                           oc/1077 (field 23 temp/1159)
                                           temp/1158 (string.length s/1076))
                                          (caml_ml_output oc/1077 s/1076 0
                                            temp/1158))
                                        0a))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let (start_time/1049 (caml_sys_time 0a))
                  (seq
                    (seq
                      (for iter/1050 1 to 100
                        (for y/1078 -39 to 38
                          (let (temp/1137 (== 1 iter/1050))
                            (seq
                              (if temp/1137
                                (let
                                  (temp/1148 (global camlPervasives!)
                                   oc/1083 (field 23 temp/1148)
                                   temp/1144 ""
                                   temp/1147 ""
                                   temp/1146 (string.length temp/1147))
                                  (seq
                                    (caml_ml_output oc/1083 temp/1144 0
                                      temp/1146)
                                    (let
                                      (temp/1142 (global camlPervasives!)
                                       temp/1141 (field 23 temp/1142))
                                      (seq (caml_ml_output_char temp/1141 10)
                                        (let
                                          (temp/1140 (global camlPervasives!)
                                           temp/1139 (field 23 temp/1140))
                                          (caml_ml_flush temp/1139))))))
                                0a)
                              (for x/1079 -39 to 38
                                (let
                                  (temp/1130 (float_of_int x/1079)
                                   temp/1131 40.0
                                   temp/1129 (/. temp/1130 temp/1131)
                                   temp/1134 (float_of_int y/1078)
                                   temp/1135 40.0
                                   temp/1133 (/. temp/1134 temp/1135)
                                   temp/1136 0.5
                                   temp/1132 (-. temp/1133 temp/1136)
                                   i/1080
                                     (camlCode__iterate_1033  temp/1129
                                       temp/1132)
                                   temp/1122 (== 1 iter/1050))
                                  (if temp/1122
                                    (let
                                      (temp/1127 (== 0 i/1080)
                                       s/1081 (if temp/1127 "*" " ")
                                       temp/1126 (global camlPervasives!)
                                       oc/1082 (field 23 temp/1126)
                                       temp/1125 (string.length s/1081))
                                      (caml_ml_output oc/1082 s/1081 0
                                        temp/1125))
                                    0a)))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq (caml_ml_output oc/1084 temp/1111 0 temp/1113)
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq (caml_ml_output_char temp/1108 10)
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104 (caml_sys_time 0a)
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq (caml_ml_output oc/1087 s/1086 0 temp/1100)
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (caml_ml_output oc/1088 temp/1094 0
                                    temp/1096)
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq (caml_ml_output_char temp/1091 10)
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
Before TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (setfield_imm 0 temp/1207 100)
    (let (temp/1205 (global camlCode!))
      (seq (setfield_imm 1 temp/1205 1000)
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184 (> i/1065 1000)
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073 (+ i/1065 1))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (for y/1046 -39 to 38
                              (let (temp/1170 (== 1 n/1045))
                                (seq
                                  (if temp/1170
                                    (let
                                      (temp/1181 (global camlPervasives!)
                                       oc/1075 (field 23 temp/1181)
                                       temp/1177 ""
                                       temp/1180 ""
                                       temp/1179 (string.length temp/1180))
                                      (seq
                                        (caml_ml_output oc/1075 temp/1177 0
                                          temp/1179)
                                        (let
                                          (temp/1175 (global camlPervasives!)
                                           temp/1174 (field 23 temp/1175))
                                          (seq
                                            (caml_ml_output_char temp/1174
                                              10)
                                            (let
                                              (temp/1173
                                                 (global camlPervasives!)
                                               temp/1172 (field 23 temp/1173))
                                              (caml_ml_flush temp/1172))))))
                                    0a)
                                  (for x/1047 -39 to 38
                                    (let
                                      (temp/1163 (float_of_int x/1047)
                                       temp/1164 40.0
                                       temp/1162 (/. temp/1163 temp/1164)
                                       temp/1167 (float_of_int y/1046)
                                       temp/1168 40.0
                                       temp/1166 (/. temp/1167 temp/1168)
                                       temp/1169 0.5
                                       temp/1165 (-. temp/1166 temp/1169)
                                       i/1048
                                         (camlCode__iterate_1033  temp/1162
                                           temp/1165)
                                       temp/1155 (== 1 n/1045))
                                      (if temp/1155
                                        (let
                                          (temp/1160 (== 0 i/1048)
                                           s/1076 (if temp/1160 "*" " ")
                                           temp/1159 (global camlPervasives!)
                                           oc/1077 (field 23 temp/1159)
                                           temp/1158 (string.length s/1076))
                                          (caml_ml_output oc/1077 s/1076 0
                                            temp/1158))
                                        0a))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let (start_time/1049 (caml_sys_time 0a))
                  (seq
                    (seq
                      (for iter/1050 1 to 100
                        (for y/1078 -39 to 38
                          (let (temp/1137 (== 1 iter/1050))
                            (seq
                              (if temp/1137
                                (let
                                  (temp/1148 (global camlPervasives!)
                                   oc/1083 (field 23 temp/1148)
                                   temp/1144 ""
                                   temp/1147 ""
                                   temp/1146 (string.length temp/1147))
                                  (seq
                                    (caml_ml_output oc/1083 temp/1144 0
                                      temp/1146)
                                    (let
                                      (temp/1142 (global camlPervasives!)
                                       temp/1141 (field 23 temp/1142))
                                      (seq (caml_ml_output_char temp/1141 10)
                                        (let
                                          (temp/1140 (global camlPervasives!)
                                           temp/1139 (field 23 temp/1140))
                                          (caml_ml_flush temp/1139))))))
                                0a)
                              (for x/1079 -39 to 38
                                (let
                                  (temp/1130 (float_of_int x/1079)
                                   temp/1131 40.0
                                   temp/1129 (/. temp/1130 temp/1131)
                                   temp/1134 (float_of_int y/1078)
                                   temp/1135 40.0
                                   temp/1133 (/. temp/1134 temp/1135)
                                   temp/1136 0.5
                                   temp/1132 (-. temp/1133 temp/1136)
                                   i/1080
                                     (camlCode__iterate_1033  temp/1129
                                       temp/1132)
                                   temp/1122 (== 1 iter/1050))
                                  (if temp/1122
                                    (let
                                      (temp/1127 (== 0 i/1080)
                                       s/1081 (if temp/1127 "*" " ")
                                       temp/1126 (global camlPervasives!)
                                       oc/1082 (field 23 temp/1126)
                                       temp/1125 (string.length s/1081))
                                      (caml_ml_output oc/1082 s/1081 0
                                        temp/1125))
                                    0a)))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq (caml_ml_output oc/1084 temp/1111 0 temp/1113)
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq (caml_ml_output_char temp/1108 10)
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104 (caml_sys_time 0a)
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq (caml_ml_output oc/1087 s/1086 0 temp/1100)
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (caml_ml_output oc/1088 temp/1094 0
                                    temp/1096)
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq (caml_ml_output_char temp/1091 10)
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
After TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (let (temp/1241 100) (setfield_imm 0 temp/1207 temp/1241))
    (let (temp/1205 (global camlCode!))
      (seq (let (temp/1240 1000) (setfield_imm 1 temp/1205 temp/1240))
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184
                                     (let (temp/1239 1000)
                                       (> i/1065 temp/1239))
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073
                                                (let (temp/1238 1)
                                                  (+ i/1065 temp/1238)))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (let (temp/1228 -39 temp/1229 38)
                              (for y/1046 temp/1228 to temp/1229
                                (let
                                  (temp/1170
                                     (let (temp/1237 1)
                                       (== temp/1237 n/1045)))
                                  (seq
                                    (if temp/1170
                                      (let
                                        (temp/1181 (global camlPervasives!)
                                         oc/1075 (field 23 temp/1181)
                                         temp/1177 ""
                                         temp/1180 ""
                                         temp/1179 (string.length temp/1180))
                                        (seq
                                          (let (temp/1236 0)
                                            (caml_ml_output oc/1075 temp/1177
                                              temp/1236 temp/1179))
                                          (let
                                            (temp/1175
                                               (global camlPervasives!)
                                             temp/1174 (field 23 temp/1175))
                                            (seq
                                              (let (temp/1235 10)
                                                (caml_ml_output_char
                                                  temp/1174 temp/1235))
                                              (let
                                                (temp/1173
                                                   (global camlPervasives!)
                                                 temp/1172
                                                   (field 23 temp/1173))
                                                (caml_ml_flush temp/1172))))))
                                      0a)
                                    (let (temp/1230 -39 temp/1231 38)
                                      (for x/1047 temp/1230 to temp/1231
                                        (let
                                          (temp/1163 (float_of_int x/1047)
                                           temp/1164 40.0
                                           temp/1162 (/. temp/1163 temp/1164)
                                           temp/1167 (float_of_int y/1046)
                                           temp/1168 40.0
                                           temp/1166 (/. temp/1167 temp/1168)
                                           temp/1169 0.5
                                           temp/1165 (-. temp/1166 temp/1169)
                                           i/1048
                                             (camlCode__iterate_1033 
                                               temp/1162 temp/1165)
                                           temp/1155
                                             (let (temp/1234 1)
                                               (== temp/1234 n/1045)))
                                          (if temp/1155
                                            (let
                                              (temp/1160
                                                 (let (temp/1233 0)
                                                   (== temp/1233 i/1048))
                                               s/1076 (if temp/1160 "*" " ")
                                               temp/1159
                                                 (global camlPervasives!)
                                               oc/1077 (field 23 temp/1159)
                                               temp/1158
                                                 (string.length s/1076)
                                               temp/1232 0)
                                              (caml_ml_output oc/1077 s/1076
                                                temp/1232 temp/1158))
                                            0a))))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let
                  (start_time/1049
                     (let (temp/1227 0a) (caml_sys_time temp/1227)))
                  (seq
                    (seq
                      (let (temp/1215 1 temp/1216 100)
                        (for iter/1050 temp/1215 to temp/1216
                          (let (temp/1217 -39 temp/1218 38)
                            (for y/1078 temp/1217 to temp/1218
                              (let
                                (temp/1137
                                   (let (temp/1226 1)
                                     (== temp/1226 iter/1050)))
                                (seq
                                  (if temp/1137
                                    (let
                                      (temp/1148 (global camlPervasives!)
                                       oc/1083 (field 23 temp/1148)
                                       temp/1144 ""
                                       temp/1147 ""
                                       temp/1146 (string.length temp/1147))
                                      (seq
                                        (let (temp/1225 0)
                                          (caml_ml_output oc/1083 temp/1144
                                            temp/1225 temp/1146))
                                        (let
                                          (temp/1142 (global camlPervasives!)
                                           temp/1141 (field 23 temp/1142))
                                          (seq
                                            (let (temp/1224 10)
                                              (caml_ml_output_char temp/1141
                                                temp/1224))
                                            (let
                                              (temp/1140
                                                 (global camlPervasives!)
                                               temp/1139 (field 23 temp/1140))
                                              (caml_ml_flush temp/1139))))))
                                    0a)
                                  (let (temp/1219 -39 temp/1220 38)
                                    (for x/1079 temp/1219 to temp/1220
                                      (let
                                        (temp/1130 (float_of_int x/1079)
                                         temp/1131 40.0
                                         temp/1129 (/. temp/1130 temp/1131)
                                         temp/1134 (float_of_int y/1078)
                                         temp/1135 40.0
                                         temp/1133 (/. temp/1134 temp/1135)
                                         temp/1136 0.5
                                         temp/1132 (-. temp/1133 temp/1136)
                                         i/1080
                                           (camlCode__iterate_1033  temp/1129
                                             temp/1132)
                                         temp/1122
                                           (let (temp/1223 1)
                                             (== temp/1223 iter/1050)))
                                        (if temp/1122
                                          (let
                                            (temp/1127
                                               (let (temp/1222 0)
                                                 (== temp/1222 i/1080))
                                             s/1081 (if temp/1127 "*" " ")
                                             temp/1126
                                               (global camlPervasives!)
                                             oc/1082 (field 23 temp/1126)
                                             temp/1125 (string.length s/1081)
                                             temp/1221 0)
                                            (caml_ml_output oc/1082 s/1081
                                              temp/1221 temp/1125))
                                          0a))))))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq
                            (let (temp/1214 0)
                              (caml_ml_output oc/1084 temp/1111 temp/1214
                                temp/1113))
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq
                                (let (temp/1213 10)
                                  (caml_ml_output_char temp/1108 temp/1213))
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104
                               (let (temp/1212 0a) (caml_sys_time temp/1212))
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq
                              (let (temp/1211 0)
                                (caml_ml_output oc/1087 s/1086 temp/1211
                                  temp/1100))
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (let (temp/1210 0)
                                    (caml_ml_output oc/1088 temp/1094
                                      temp/1210 temp/1096))
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq
                                      (let (temp/1209 10)
                                        (caml_ml_output_char temp/1091
                                          temp/1209))
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
Before TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
After TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
Before TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
After TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
Before TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))
After TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))

-dcmm
[inline] iterate_1033 cannot be inlined: local fun
Before TonSlambda.optimize:
(seq (setfield_imm 0 (global camlCode!) 100)
  (setfield_imm 1 (global camlCode!) 1000)
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (exit 12
                                            (if (> i/1040 1000) 0
                                              (let
                                                (temp/1041
                                                   (*. zr/1039 zi/1038)
                                                 zr2/1042
                                                   (*. zr/1039 zr/1039)
                                                 zi2/1043
                                                   (*. zi/1038 zi/1038))
                                                (if
                                                  (>. (+. zi2/1043 zr2/1042)
                                                    (field 5 env/1064))
                                                  i/1040
                                                  (let
                                                    (arg/1055
                                                       (+.
                                                         (+. temp/1041
                                                           temp/1041)
                                                         (field 3 env/1064))
                                                     arg/1056
                                                       (+.
                                                         (-. zr2/1042
                                                           zi2/1043)
                                                         (field 4 env/1064))
                                                     arg/1057 (+ i/1040 1))
                                                    (seq
                                                      (assign i/1040
                                                        arg/1057)
                                                      (assign zr/1039
                                                        arg/1056)
                                                      (assign zi/1038
                                                        arg/1055)
                                                      (exit 11)))))))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (exit 12
                            (if (> i/1065 1000) 0
                              (let
                                (temp/1068 (*. zr/1066 zi/1067)
                                 zr2/1069 (*. zr/1066 zr/1066)
                                 zi2/1070 (*. zi/1067 zi/1067))
                                (if
                                  (>. (+. zi2/1070 zr2/1069)
                                    (field 5 loop/1037))
                                  i/1065
                                  (let
                                    (arg/1071
                                       (+. (+. temp/1068 temp/1068)
                                         (field 3 loop/1037))
                                     arg/1072
                                       (+. (-. zr2/1069 zi2/1070)
                                         (field 4 loop/1037))
                                     arg/1073 (+ i/1065 1))
                                    (seq (assign i/1065 arg/1073)
                                      (assign zr/1066 arg/1072)
                                      (assign zi/1067 arg/1071) (exit 11)))))))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} ))
    (setfield_imm 2 (global camlCode!) iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (for y/1046 -39 to 38
                    (seq
                      (if (== 1 n/1045)
                        (seq
                          (let (oc/1075 (field 23 (global camlPervasives!)))
                            (caml_ml_output oc/1075 "" 0 (string.length "")))
                          (caml_ml_output_char
                            (field 23 (global camlPervasives!)) '\n')
                          (caml_ml_flush (field 23 (global camlPervasives!))))
                        0a)
                      (for x/1047 -39 to 38
                        (let
                          (i/1048
                             (camlCode__iterate_1033 
                               (/. (float_of_int x/1047) 40.0)
                               (-. (/. (float_of_int y/1046) 40.0) 0.5)))
                          (if (== 1 n/1045)
                            (let
                              (s/1076 (if (== 0 i/1048) "*" " ")
                               oc/1077 (field 23 (global camlPervasives!)))
                              (caml_ml_output oc/1077 s/1076 0
                                (string.length s/1076)))
                            0a)))))) {2} ))
    (setfield_imm 3 (global camlCode!) mandelbrot/1044))
  (let (start_time/1049 (caml_sys_time 0a))
    (seq
      (for iter/1050 1 to 100
        (for y/1078 -39 to 38
          (seq
            (if (== 1 iter/1050)
              (seq
                (let (oc/1083 (field 23 (global camlPervasives!)))
                  (caml_ml_output oc/1083 "" 0 (string.length "")))
                (caml_ml_output_char (field 23 (global camlPervasives!))
                  '\n')
                (caml_ml_flush (field 23 (global camlPervasives!))))
              0a)
            (for x/1079 -39 to 38
              (let
                (i/1080
                   (camlCode__iterate_1033  (/. (float_of_int x/1079) 40.0)
                     (-. (/. (float_of_int y/1078) 40.0) 0.5)))
                (if (== 1 iter/1050)
                  (let
                    (s/1081 (if (== 0 i/1080) "*" " ")
                     oc/1082 (field 23 (global camlPervasives!)))
                    (caml_ml_output oc/1082 s/1081 0 (string.length s/1081)))
                  0a))))))
      (let (oc/1084 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1084 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))
      (let
        (f/1085 (-. (caml_sys_time 0a) start_time/1049)
         s/1086
           (camlPervasives__valid_float_lexem_1136 
             (caml_format_float "%.12g" f/1085))
         oc/1087 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1087 s/1086 0 (string.length s/1086)))
      (let (oc/1088 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1088 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))))
  0a)
After TonSlambda.optimize:
(seq
  (let (temp/1207 (global camlCode!) temp/1208 100)
    (setfield_imm 0 temp/1207 temp/1208))
  (let (temp/1205 (global camlCode!) temp/1206 1000)
    (setfield_imm 1 temp/1205 temp/1206))
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (let
                                            (temp/1194
                                               (let
                                                 (temp/1195
                                                    (let (temp/1196 1000)
                                                      (> i/1040 temp/1196)))
                                                 (if temp/1195 0
                                                   (let
                                                     (temp/1041
                                                        (*. zr/1039 zi/1038)
                                                      zr2/1042
                                                        (*. zr/1039 zr/1039)
                                                      zi2/1043
                                                        (*. zi/1038 zi/1038)
                                                      temp/1197
                                                        (let
                                                          (temp/1198
                                                             (+. zi2/1043
                                                               zr2/1042)
                                                           temp/1199
                                                             (field 5
                                                               env/1064))
                                                          (>. temp/1198
                                                            temp/1199)))
                                                     (if temp/1197 i/1040
                                                       (let
                                                         (arg/1055
                                                            (let
                                                              (temp/1203
                                                                 (+.
                                                                   temp/1041
                                                                   temp/1041)
                                                               temp/1204
                                                                 (field 3
                                                                   env/1064))
                                                              (+. temp/1203
                                                                temp/1204))
                                                          arg/1056
                                                            (let
                                                              (temp/1201
                                                                 (-. zr2/1042
                                                                   zi2/1043)
                                                               temp/1202
                                                                 (field 4
                                                                   env/1064))
                                                              (+. temp/1201
                                                                temp/1202))
                                                          arg/1057
                                                            (let
                                                              (temp/1200 1)
                                                              (+ i/1040
                                                                temp/1200)))
                                                         (seq
                                                           (assign i/1040
                                                             arg/1057)
                                                           (assign zr/1039
                                                             arg/1056)
                                                           (assign zi/1038
                                                             arg/1055)
                                                           (exit 11))))))))
                                            (exit 12 temp/1194))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (let
                            (temp/1183
                               (let
                                 (temp/1184
                                    (let (temp/1185 1000)
                                      (> i/1065 temp/1185)))
                                 (if temp/1184 0
                                   (let
                                     (temp/1068 (*. zr/1066 zi/1067)
                                      zr2/1069 (*. zr/1066 zr/1066)
                                      zi2/1070 (*. zi/1067 zi/1067)
                                      temp/1186
                                        (let
                                          (temp/1187 (+. zi2/1070 zr2/1069)
                                           temp/1188 (field 5 loop/1037))
                                          (>. temp/1187 temp/1188)))
                                     (if temp/1186 i/1065
                                       (let
                                         (arg/1071
                                            (let
                                              (temp/1192
                                                 (+. temp/1068 temp/1068)
                                               temp/1193 (field 3 loop/1037))
                                              (+. temp/1192 temp/1193))
                                          arg/1072
                                            (let
                                              (temp/1190
                                                 (-. zr2/1069 zi2/1070)
                                               temp/1191 (field 4 loop/1037))
                                              (+. temp/1190 temp/1191))
                                          arg/1073
                                            (let (temp/1189 1)
                                              (+ i/1065 temp/1189)))
                                         (seq (assign i/1065 arg/1073)
                                           (assign zr/1066 arg/1072)
                                           (assign zi/1067 arg/1071)
                                           (exit 11))))))))
                            (exit 12 temp/1183))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} )
     temp/1182 (global camlCode!))
    (setfield_imm 2 temp/1182 iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (let (temp/1151 -39 temp/1152 38)
                    (for y/1046 temp/1151 to temp/1152
                      (seq
                        (let
                          (temp/1170
                             (let (temp/1171 1) (== temp/1171 n/1045)))
                          (if temp/1170
                            (seq
                              (let
                                (oc/1075
                                   (let (temp/1181 (global camlPervasives!))
                                     (field 23 temp/1181))
                                 temp/1177 ""
                                 temp/1178 0
                                 temp/1179
                                   (let (temp/1180 "")
                                     (string.length temp/1180)))
                                (caml_ml_output oc/1075 temp/1177 temp/1178
                                  temp/1179))
                              (let
                                (temp/1174
                                   (let (temp/1175 (global camlPervasives!))
                                     (field 23 temp/1175))
                                 temp/1176 '\n')
                                (caml_ml_output_char temp/1174 temp/1176))
                              (let
                                (temp/1172
                                   (let (temp/1173 (global camlPervasives!))
                                     (field 23 temp/1173)))
                                (caml_ml_flush temp/1172)))
                            0a))
                        (let (temp/1153 -39 temp/1154 38)
                          (for x/1047 temp/1153 to temp/1154
                            (let
                              (i/1048
                                 (let
                                   (temp/1162
                                      (let
                                        (temp/1163 (float_of_int x/1047)
                                         temp/1164 40.0)
                                        (/. temp/1163 temp/1164))
                                    temp/1165
                                      (let
                                        (temp/1166
                                           (let
                                             (temp/1167 (float_of_int y/1046)
                                              temp/1168 40.0)
                                             (/. temp/1167 temp/1168))
                                         temp/1169 0.5)
                                        (-. temp/1166 temp/1169)))
                                   (camlCode__iterate_1033  temp/1162
                                     temp/1165))
                               temp/1155
                                 (let (temp/1156 1) (== temp/1156 n/1045)))
                              (if temp/1155
                                (let
                                  (s/1076
                                     (let
                                       (temp/1160
                                          (let (temp/1161 0)
                                            (== temp/1161 i/1048)))
                                       (if temp/1160 "*" " "))
                                   oc/1077
                                     (let
                                       (temp/1159 (global camlPervasives!))
                                       (field 23 temp/1159))
                                   temp/1157 0
                                   temp/1158 (string.length s/1076))
                                  (caml_ml_output oc/1077 s/1076 temp/1157
                                    temp/1158))
                                0a)))))))) {2} )
     temp/1150 (global camlCode!))
    (setfield_imm 3 temp/1150 mandelbrot/1044))
  (let (start_time/1049 (let (temp/1149 0a) (caml_sys_time temp/1149)))
    (seq
      (let (temp/1116 1 temp/1117 100)
        (for iter/1050 temp/1116 to temp/1117
          (let (temp/1118 -39 temp/1119 38)
            (for y/1078 temp/1118 to temp/1119
              (seq
                (let (temp/1137 (let (temp/1138 1) (== temp/1138 iter/1050)))
                  (if temp/1137
                    (seq
                      (let
                        (oc/1083
                           (let (temp/1148 (global camlPervasives!))
                             (field 23 temp/1148))
                         temp/1144 ""
                         temp/1145 0
                         temp/1146
                           (let (temp/1147 "") (string.length temp/1147)))
                        (caml_ml_output oc/1083 temp/1144 temp/1145
                          temp/1146))
                      (let
                        (temp/1141
                           (let (temp/1142 (global camlPervasives!))
                             (field 23 temp/1142))
                         temp/1143 '\n')
                        (caml_ml_output_char temp/1141 temp/1143))
                      (let
                        (temp/1139
                           (let (temp/1140 (global camlPervasives!))
                             (field 23 temp/1140)))
                        (caml_ml_flush temp/1139)))
                    0a))
                (let (temp/1120 -39 temp/1121 38)
                  (for x/1079 temp/1120 to temp/1121
                    (let
                      (i/1080
                         (let
                           (temp/1129
                              (let
                                (temp/1130 (float_of_int x/1079)
                                 temp/1131 40.0)
                                (/. temp/1130 temp/1131))
                            temp/1132
                              (let
                                (temp/1133
                                   (let
                                     (temp/1134 (float_of_int y/1078)
                                      temp/1135 40.0)
                                     (/. temp/1134 temp/1135))
                                 temp/1136 0.5)
                                (-. temp/1133 temp/1136)))
                           (camlCode__iterate_1033  temp/1129 temp/1132))
                       temp/1122 (let (temp/1123 1) (== temp/1123 iter/1050)))
                      (if temp/1122
                        (let
                          (s/1081
                             (let
                               (temp/1127
                                  (let (temp/1128 0) (== temp/1128 i/1080)))
                               (if temp/1127 "*" " "))
                           oc/1082
                             (let (temp/1126 (global camlPervasives!))
                               (field 23 temp/1126))
                           temp/1124 0
                           temp/1125 (string.length s/1081))
                          (caml_ml_output oc/1082 s/1081 temp/1124 temp/1125))
                        0a)))))))))
      (let
        (oc/1084
           (let (temp/1115 (global camlPervasives!)) (field 23 temp/1115))
         temp/1111 ""
         temp/1112 0
         temp/1113 (let (temp/1114 "") (string.length temp/1114)))
        (caml_ml_output oc/1084 temp/1111 temp/1112 temp/1113))
      (let
        (temp/1108
           (let (temp/1109 (global camlPervasives!)) (field 23 temp/1109))
         temp/1110 '\n')
        (caml_ml_output_char temp/1108 temp/1110))
      (let
        (temp/1106
           (let (temp/1107 (global camlPervasives!)) (field 23 temp/1107)))
        (caml_ml_flush temp/1106))
      (let
        (f/1085
           (let (temp/1104 (let (temp/1105 0a) (caml_sys_time temp/1105)))
             (-. temp/1104 start_time/1049))
         s/1086
           (let
             (temp/1102
                (let (temp/1103 "%.12g")
                  (caml_format_float temp/1103 f/1085)))
             (camlPervasives__valid_float_lexem_1136  temp/1102))
         oc/1087
           (let (temp/1101 (global camlPervasives!)) (field 23 temp/1101))
         temp/1099 0
         temp/1100 (string.length s/1086))
        (caml_ml_output oc/1087 s/1086 temp/1099 temp/1100))
      (let
        (oc/1088
           (let (temp/1098 (global camlPervasives!)) (field 23 temp/1098))
         temp/1094 ""
         temp/1095 0
         temp/1096 (let (temp/1097 "") (string.length temp/1097)))
        (caml_ml_output oc/1088 temp/1094 temp/1095 temp/1096))
      (let
        (temp/1091
           (let (temp/1092 (global camlPervasives!)) (field 23 temp/1092))
         temp/1093 '\n')
        (caml_ml_output_char temp/1091 temp/1093))
      (let
        (temp/1089
           (let (temp/1090 (global camlPervasives!)) (field 23 temp/1090)))
        (caml_ml_flush temp/1089))))
  0a)
Before TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (setfield_imm 0 temp/1207 100)
    (let (temp/1205 (global camlCode!))
      (seq (setfield_imm 1 temp/1205 1000)
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184 (> i/1065 1000)
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073 (+ i/1065 1))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (for y/1046 -39 to 38
                              (let (temp/1170 (== 1 n/1045))
                                (seq
                                  (if temp/1170
                                    (let
                                      (temp/1181 (global camlPervasives!)
                                       oc/1075 (field 23 temp/1181)
                                       temp/1177 ""
                                       temp/1180 ""
                                       temp/1179 (string.length temp/1180))
                                      (seq
                                        (caml_ml_output oc/1075 temp/1177 0
                                          temp/1179)
                                        (let
                                          (temp/1175 (global camlPervasives!)
                                           temp/1174 (field 23 temp/1175))
                                          (seq
                                            (caml_ml_output_char temp/1174
                                              10)
                                            (let
                                              (temp/1173
                                                 (global camlPervasives!)
                                               temp/1172 (field 23 temp/1173))
                                              (caml_ml_flush temp/1172))))))
                                    0a)
                                  (for x/1047 -39 to 38
                                    (let
                                      (temp/1163 (float_of_int x/1047)
                                       temp/1164 40.0
                                       temp/1162 (/. temp/1163 temp/1164)
                                       temp/1167 (float_of_int y/1046)
                                       temp/1168 40.0
                                       temp/1166 (/. temp/1167 temp/1168)
                                       temp/1169 0.5
                                       temp/1165 (-. temp/1166 temp/1169)
                                       i/1048
                                         (camlCode__iterate_1033  temp/1162
                                           temp/1165)
                                       temp/1155 (== 1 n/1045))
                                      (if temp/1155
                                        (let
                                          (temp/1160 (== 0 i/1048)
                                           s/1076 (if temp/1160 "*" " ")
                                           temp/1159 (global camlPervasives!)
                                           oc/1077 (field 23 temp/1159)
                                           temp/1158 (string.length s/1076))
                                          (caml_ml_output oc/1077 s/1076 0
                                            temp/1158))
                                        0a))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let (start_time/1049 (caml_sys_time 0a))
                  (seq
                    (seq
                      (for iter/1050 1 to 100
                        (for y/1078 -39 to 38
                          (let (temp/1137 (== 1 iter/1050))
                            (seq
                              (if temp/1137
                                (let
                                  (temp/1148 (global camlPervasives!)
                                   oc/1083 (field 23 temp/1148)
                                   temp/1144 ""
                                   temp/1147 ""
                                   temp/1146 (string.length temp/1147))
                                  (seq
                                    (caml_ml_output oc/1083 temp/1144 0
                                      temp/1146)
                                    (let
                                      (temp/1142 (global camlPervasives!)
                                       temp/1141 (field 23 temp/1142))
                                      (seq (caml_ml_output_char temp/1141 10)
                                        (let
                                          (temp/1140 (global camlPervasives!)
                                           temp/1139 (field 23 temp/1140))
                                          (caml_ml_flush temp/1139))))))
                                0a)
                              (for x/1079 -39 to 38
                                (let
                                  (temp/1130 (float_of_int x/1079)
                                   temp/1131 40.0
                                   temp/1129 (/. temp/1130 temp/1131)
                                   temp/1134 (float_of_int y/1078)
                                   temp/1135 40.0
                                   temp/1133 (/. temp/1134 temp/1135)
                                   temp/1136 0.5
                                   temp/1132 (-. temp/1133 temp/1136)
                                   i/1080
                                     (camlCode__iterate_1033  temp/1129
                                       temp/1132)
                                   temp/1122 (== 1 iter/1050))
                                  (if temp/1122
                                    (let
                                      (temp/1127 (== 0 i/1080)
                                       s/1081 (if temp/1127 "*" " ")
                                       temp/1126 (global camlPervasives!)
                                       oc/1082 (field 23 temp/1126)
                                       temp/1125 (string.length s/1081))
                                      (caml_ml_output oc/1082 s/1081 0
                                        temp/1125))
                                    0a)))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq (caml_ml_output oc/1084 temp/1111 0 temp/1113)
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq (caml_ml_output_char temp/1108 10)
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104 (caml_sys_time 0a)
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq (caml_ml_output oc/1087 s/1086 0 temp/1100)
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (caml_ml_output oc/1088 temp/1094 0
                                    temp/1096)
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq (caml_ml_output_char temp/1091 10)
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
After TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (let (temp/1241 100) (setfield_imm 0 temp/1207 temp/1241))
    (let (temp/1205 (global camlCode!))
      (seq (let (temp/1240 1000) (setfield_imm 1 temp/1205 temp/1240))
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184
                                     (let (temp/1239 1000)
                                       (> i/1065 temp/1239))
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073
                                                (let (temp/1238 1)
                                                  (+ i/1065 temp/1238)))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (let (temp/1228 -39 temp/1229 38)
                              (for y/1046 temp/1228 to temp/1229
                                (let
                                  (temp/1170
                                     (let (temp/1237 1)
                                       (== temp/1237 n/1045)))
                                  (seq
                                    (if temp/1170
                                      (let
                                        (temp/1181 (global camlPervasives!)
                                         oc/1075 (field 23 temp/1181)
                                         temp/1177 ""
                                         temp/1180 ""
                                         temp/1179 (string.length temp/1180))
                                        (seq
                                          (let (temp/1236 0)
                                            (caml_ml_output oc/1075 temp/1177
                                              temp/1236 temp/1179))
                                          (let
                                            (temp/1175
                                               (global camlPervasives!)
                                             temp/1174 (field 23 temp/1175))
                                            (seq
                                              (let (temp/1235 10)
                                                (caml_ml_output_char
                                                  temp/1174 temp/1235))
                                              (let
                                                (temp/1173
                                                   (global camlPervasives!)
                                                 temp/1172
                                                   (field 23 temp/1173))
                                                (caml_ml_flush temp/1172))))))
                                      0a)
                                    (let (temp/1230 -39 temp/1231 38)
                                      (for x/1047 temp/1230 to temp/1231
                                        (let
                                          (temp/1163 (float_of_int x/1047)
                                           temp/1164 40.0
                                           temp/1162 (/. temp/1163 temp/1164)
                                           temp/1167 (float_of_int y/1046)
                                           temp/1168 40.0
                                           temp/1166 (/. temp/1167 temp/1168)
                                           temp/1169 0.5
                                           temp/1165 (-. temp/1166 temp/1169)
                                           i/1048
                                             (camlCode__iterate_1033 
                                               temp/1162 temp/1165)
                                           temp/1155
                                             (let (temp/1234 1)
                                               (== temp/1234 n/1045)))
                                          (if temp/1155
                                            (let
                                              (temp/1160
                                                 (let (temp/1233 0)
                                                   (== temp/1233 i/1048))
                                               s/1076 (if temp/1160 "*" " ")
                                               temp/1159
                                                 (global camlPervasives!)
                                               oc/1077 (field 23 temp/1159)
                                               temp/1158
                                                 (string.length s/1076)
                                               temp/1232 0)
                                              (caml_ml_output oc/1077 s/1076
                                                temp/1232 temp/1158))
                                            0a))))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let
                  (start_time/1049
                     (let (temp/1227 0a) (caml_sys_time temp/1227)))
                  (seq
                    (seq
                      (let (temp/1215 1 temp/1216 100)
                        (for iter/1050 temp/1215 to temp/1216
                          (let (temp/1217 -39 temp/1218 38)
                            (for y/1078 temp/1217 to temp/1218
                              (let
                                (temp/1137
                                   (let (temp/1226 1)
                                     (== temp/1226 iter/1050)))
                                (seq
                                  (if temp/1137
                                    (let
                                      (temp/1148 (global camlPervasives!)
                                       oc/1083 (field 23 temp/1148)
                                       temp/1144 ""
                                       temp/1147 ""
                                       temp/1146 (string.length temp/1147))
                                      (seq
                                        (let (temp/1225 0)
                                          (caml_ml_output oc/1083 temp/1144
                                            temp/1225 temp/1146))
                                        (let
                                          (temp/1142 (global camlPervasives!)
                                           temp/1141 (field 23 temp/1142))
                                          (seq
                                            (let (temp/1224 10)
                                              (caml_ml_output_char temp/1141
                                                temp/1224))
                                            (let
                                              (temp/1140
                                                 (global camlPervasives!)
                                               temp/1139 (field 23 temp/1140))
                                              (caml_ml_flush temp/1139))))))
                                    0a)
                                  (let (temp/1219 -39 temp/1220 38)
                                    (for x/1079 temp/1219 to temp/1220
                                      (let
                                        (temp/1130 (float_of_int x/1079)
                                         temp/1131 40.0
                                         temp/1129 (/. temp/1130 temp/1131)
                                         temp/1134 (float_of_int y/1078)
                                         temp/1135 40.0
                                         temp/1133 (/. temp/1134 temp/1135)
                                         temp/1136 0.5
                                         temp/1132 (-. temp/1133 temp/1136)
                                         i/1080
                                           (camlCode__iterate_1033  temp/1129
                                             temp/1132)
                                         temp/1122
                                           (let (temp/1223 1)
                                             (== temp/1223 iter/1050)))
                                        (if temp/1122
                                          (let
                                            (temp/1127
                                               (let (temp/1222 0)
                                                 (== temp/1222 i/1080))
                                             s/1081 (if temp/1127 "*" " ")
                                             temp/1126
                                               (global camlPervasives!)
                                             oc/1082 (field 23 temp/1126)
                                             temp/1125 (string.length s/1081)
                                             temp/1221 0)
                                            (caml_ml_output oc/1082 s/1081
                                              temp/1221 temp/1125))
                                          0a))))))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq
                            (let (temp/1214 0)
                              (caml_ml_output oc/1084 temp/1111 temp/1214
                                temp/1113))
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq
                                (let (temp/1213 10)
                                  (caml_ml_output_char temp/1108 temp/1213))
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104
                               (let (temp/1212 0a) (caml_sys_time temp/1212))
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq
                              (let (temp/1211 0)
                                (caml_ml_output oc/1087 s/1086 temp/1211
                                  temp/1100))
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (let (temp/1210 0)
                                    (caml_ml_output oc/1088 temp/1094
                                      temp/1210 temp/1096))
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq
                                      (let (temp/1209 10)
                                        (caml_ml_output_char temp/1091
                                          temp/1209))
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
(data int 4096 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__6": addr "camlCode__mandelbrot_1044" int 3)
(data
 int 3319
 "camlCode__7":
 addr "caml_curry2"
 int 5
 addr "camlCode__iterate_1033")
(data global "camlCode__1" int 1276 "camlCode__1": string "" skip 3 byte 3)
(data global "camlCode__2" int 1276 "camlCode__2": string "*" skip 2 byte 2)
(data global "camlCode__3" int 1276 "camlCode__3": string " " skip 2 byte 2)
(data global "camlCode__4" int 1276 "camlCode__4": string "" skip 3 byte 3)
(data global "camlCode__5" int 1276 "camlCode__5": string "" skip 3 byte 3)
(function camlCode__iterate_1033 (ci/1034: addr cr/1035: addr)
 (let
   (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
    zi/1284[Variable] 0.0)
   (catch
     (loop
       (catch
         (let
           (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
            temp/1183
              (if (!= temp/1184 1) 1
                (let
                  (temp/1283 (*f zr/1285 zi/1284)
                   zr2/1282 (*f zr/1285 zr/1285)
                   zi2/1281 (*f zi/1284 zi/1284)
                   temp/1280 (+f zi2/1281 zr2/1282)
                   temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                  (if (!= temp/1186 1) i/1065
                    (let
                      (temp/1279 (+f temp/1283 temp/1283)
                       arg/1278 (+f temp/1279 (load float64u ci/1034))
                       temp/1277 (-f zr2/1282 zi2/1281)
                       arg/1276 (+f temp/1277 (load float64u cr/1035))
                       arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                      (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                      (assign zi/1284 arg/1278) (exit 11))))))
           (exit 12 temp/1183))
       with(11) []))
     1a
   with(12 res/1058) res/1058)))

Before TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
After TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
(function camlCode__mandelbrot_1044 (n/1045: addr)
 (let (temp/1228 -77 temp/1229 77)
   (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
     (catch
       (if (> y/1046 bound/1263) (exit 16)
         (loop
           (let
             temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
             (if (!= temp/1170 1)
               (let
                 (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                  temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                  temp/1179
                    (+
                      (<<
                        (let
                          tmp/1275
                            (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                          (- tmp/1275
                            (load unsigned int8 (+a temp/1180 tmp/1275))))
                        1)
                      1))
                 (let temp/1236 1
                   (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                     temp/1177 temp/1236 temp/1179 unit))
                 (let
                   (temp/1175 "camlPervasives"
                    temp/1174 (load (+a temp/1175 92)))
                   (let temp/1235 21
                     (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                       temp/1174 temp/1235 unit))
                   (let
                     (temp/1173 "camlPervasives"
                      temp/1172 (load (+a temp/1173 92)))
                     (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                       temp/1172 unit))))
               [])
             (let
               (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
                bound/1265 temp/1231)
               (catch
                 (if (> x/1047 bound/1265) (exit 17)
                   (loop
                     (let
                       (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                        temp/1272 (/f temp/1274 temp/1273)
                        temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                        temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                        temp/1267 (-f temp/1269 temp/1268)
                        i/1048
                          (app "camlCode__iterate_1033"
                            (alloc[253] 2301 temp/1272)
                            (alloc[253] 2301 temp/1267) addr)
                        temp/1155
                          (let temp/1234 3
                            (+ (<< (== temp/1234 n/1045) 1) 1)))
                       (if (!= temp/1155 1)
                         (let
                           (temp/1160
                              (let temp/1233 1
                                (+ (<< (== temp/1233 i/1048) 1) 1))
                            s/1076
                              (if (!= temp/1160 1) "camlCode__2"
                                "camlCode__3")
                            temp/1159 "camlPervasives"
                            oc/1077 (load (+a temp/1159 92))
                            temp/1158
                              (+
                                (<<
                                  (let
                                    tmp/1266
                                      (-
                                        (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                        1)
                                    (- tmp/1266
                                      (load unsigned int8
                                        (+a s/1076 tmp/1266))))
                                  1)
                                1)
                            temp/1232 1)
                           (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                             oc/1077 s/1076 temp/1232 temp/1158 unit))
                         []))
                     (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                       (if (== x/1264 bound/1265) (exit 17) []))))
               with(17) [])))
           (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
             (if (== y/1262 bound/1263) (exit 16) []))))
     with(16) []))
   1a))

Before TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
After TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
(function camlCode__entry ()
 (let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
   (let temp/1205 "camlCode"
     (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
     (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
       (store (+a temp/1182 8) iterate/1033)
       (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
         (store (+a temp/1150 12) mandelbrot/1044)
         (let
           start_time/1049
             (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
           (let
             (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
              bound/1247 temp/1216)
             (catch
               (if (> iter/1050 bound/1247) (exit 13)
                 (loop
                   (let
                     (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                      bound/1249 temp/1218)
                     (catch
                       (if (> y/1078 bound/1249) (exit 14)
                         (loop
                           (let
                             temp/1137
                               (let temp/1226 3
                                 (+ (<< (== temp/1226 iter/1050) 1) 1))
                             (if (!= temp/1137 1)
                               (let
                                 (temp/1148 "camlPervasives"
                                  oc/1083 (load (+a temp/1148 92))
                                  temp/1144 "camlCode__1"
                                  temp/1147 "camlCode__1"
                                  temp/1146
                                    (+
                                      (<<
                                        (let
                                          tmp/1261
                                            (-
                                              (<<
                                                (>>u (load (+a temp/1147 -4))
                                                  10)
                                                2)
                                              1)
                                          (- tmp/1261
                                            (load unsigned int8
                                              (+a temp/1147 tmp/1261))))
                                        1)
                                      1))
                                 (let temp/1225 1
                                   (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                     oc/1083 temp/1144 temp/1225 temp/1146
                                     unit))
                                 (let
                                   (temp/1142 "camlPervasives"
                                    temp/1141 (load (+a temp/1142 92)))
                                   (let temp/1224 21
                                     (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                       temp/1141 temp/1224 unit))
                                   (let
                                     (temp/1140 "camlPervasives"
                                      temp/1139 (load (+a temp/1140 92)))
                                     (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                       temp/1139 unit))))
                               [])
                             (let
                               (temp/1219 -77 temp/1220 77
                                x/1079[Variable] temp/1219
                                bound/1251 temp/1220)
                               (catch
                                 (if (> x/1079 bound/1251) (exit 15)
                                   (loop
                                     (let
                                       (temp/1260 (floatofint (>>s x/1079 1))
                                        temp/1259 40.0
                                        temp/1258 (/f temp/1260 temp/1259)
                                        temp/1257 (floatofint (>>s y/1078 1))
                                        temp/1256 40.0
                                        temp/1255 (/f temp/1257 temp/1256)
                                        temp/1254 0.5
                                        temp/1253 (-f temp/1255 temp/1254)
                                        i/1080
                                          (app "camlCode__iterate_1033"
                                            (alloc[253] 2301 temp/1258)
                                            (alloc[253] 2301 temp/1253) addr)
                                        temp/1122
                                          (let temp/1223 3
                                            (+
                                              (<< (== temp/1223 iter/1050) 1)
                                              1)))
                                       (if (!= temp/1122 1)
                                         (let
                                           (temp/1127
                                              (let temp/1222 1
                                                (+
                                                  (<< (== temp/1222 i/1080)
                                                    1)
                                                  1))
                                            s/1081
                                              (if (!= temp/1127 1)
                                                "camlCode__2" "camlCode__3")
                                            temp/1126 "camlPervasives"
                                            oc/1082 (load (+a temp/1126 92))
                                            temp/1125
                                              (+
                                                (<<
                                                  (let
                                                    tmp/1252
                                                      (-
                                                        (<<
                                                          (>>u
                                                            (load
                                                              (+a s/1081 -4))
                                                            10)
                                                          2)
                                                        1)
                                                    (- tmp/1252
                                                      (load unsigned int8
                                                        (+a s/1081 tmp/1252))))
                                                  1)
                                                1)
                                            temp/1221 1)
                                           (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                             oc/1082 s/1081 temp/1221
                                             temp/1125 unit))
                                         []))
                                     (let x/1250 x/1079
                                       (assign x/1079 (+ x/1079 2))
                                       (if (== x/1250 bound/1251) (exit 15)
                                         []))))
                               with(15) [])))
                           (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                             (if (== y/1248 bound/1249) (exit 14) []))))
                     with(14) []))
                   (let iter/1246 iter/1050
                     (assign iter/1050 (+ iter/1050 2))
                     (if (== iter/1246 bound/1247) (exit 13) []))))
             with(13) []))
           (let
             (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
              temp/1111 "camlCode__4" temp/1114 "camlCode__4"
              temp/1113
                (+
                  (<<
                    (let
                      tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                      (- tmp/1245
                        (load unsigned int8 (+a temp/1114 tmp/1245))))
                    1)
                  1))
             (let temp/1214 1
               (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                 temp/1111 temp/1214 temp/1113 unit))
             (let
               (temp/1109 "camlPervasives"
                temp/1108 (load (+a temp/1109 92)))
               (let temp/1213 21
                 (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                   temp/1108 temp/1213 unit))
               (let
                 (temp/1107 "camlPervasives"
                  temp/1106 (load (+a temp/1107 92)))
                 (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                   unit)))
             (let
               (temp/1104
                  (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
                f/1244
                  (-f (load float64u temp/1104)
                    (load float64u start_time/1049))
                temp/1103 "camlPervasives__11"
                temp/1102
                  (extcall "caml_format_float"{pervasives.ml:198,42-66}
                    temp/1103 (alloc[253] 2301 f/1244) addr)
                s/1086
                  (app{pervasives.ml:361,41-60}
                    "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
                temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
                temp/1100
                  (+
                    (<<
                      (let
                        tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                        (- tmp/1243
                          (load unsigned int8 (+a s/1086 tmp/1243))))
                      1)
                    1))
               (let temp/1211 1
                 (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                   s/1086 temp/1211 temp/1100 unit))
               (let
                 (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                  temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                  temp/1096
                    (+
                      (<<
                        (let
                          tmp/1242
                            (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                          (- tmp/1242
                            (load unsigned int8 (+a temp/1097 tmp/1242))))
                        1)
                      1))
                 (let temp/1210 1
                   (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                     temp/1094 temp/1210 temp/1096 unit))
                 (let
                   (temp/1092 "camlPervasives"
                    temp/1091 (load (+a temp/1092 92)))
                   (let temp/1209 21
                     (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                       temp/1091 temp/1209 unit))
                   (let
                     (temp/1090 "camlPervasives"
                      temp/1089 (load (+a temp/1090 92)))
                     (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                       temp/1089 unit))))))
           1a))))))

Before TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))
After TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))
(data)
-dlinear
[inline] iterate_1033 cannot be inlined: local fun
Before TonSlambda.optimize:
(seq (setfield_imm 0 (global camlCode!) 100)
  (setfield_imm 1 (global camlCode!) 1000)
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (exit 12
                                            (if (> i/1040 1000) 0
                                              (let
                                                (temp/1041
                                                   (*. zr/1039 zi/1038)
                                                 zr2/1042
                                                   (*. zr/1039 zr/1039)
                                                 zi2/1043
                                                   (*. zi/1038 zi/1038))
                                                (if
                                                  (>. (+. zi2/1043 zr2/1042)
                                                    (field 5 env/1064))
                                                  i/1040
                                                  (let
                                                    (arg/1055
                                                       (+.
                                                         (+. temp/1041
                                                           temp/1041)
                                                         (field 3 env/1064))
                                                     arg/1056
                                                       (+.
                                                         (-. zr2/1042
                                                           zi2/1043)
                                                         (field 4 env/1064))
                                                     arg/1057 (+ i/1040 1))
                                                    (seq
                                                      (assign i/1040
                                                        arg/1057)
                                                      (assign zr/1039
                                                        arg/1056)
                                                      (assign zi/1038
                                                        arg/1055)
                                                      (exit 11)))))))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (exit 12
                            (if (> i/1065 1000) 0
                              (let
                                (temp/1068 (*. zr/1066 zi/1067)
                                 zr2/1069 (*. zr/1066 zr/1066)
                                 zi2/1070 (*. zi/1067 zi/1067))
                                (if
                                  (>. (+. zi2/1070 zr2/1069)
                                    (field 5 loop/1037))
                                  i/1065
                                  (let
                                    (arg/1071
                                       (+. (+. temp/1068 temp/1068)
                                         (field 3 loop/1037))
                                     arg/1072
                                       (+. (-. zr2/1069 zi2/1070)
                                         (field 4 loop/1037))
                                     arg/1073 (+ i/1065 1))
                                    (seq (assign i/1065 arg/1073)
                                      (assign zr/1066 arg/1072)
                                      (assign zi/1067 arg/1071) (exit 11)))))))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} ))
    (setfield_imm 2 (global camlCode!) iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (for y/1046 -39 to 38
                    (seq
                      (if (== 1 n/1045)
                        (seq
                          (let (oc/1075 (field 23 (global camlPervasives!)))
                            (caml_ml_output oc/1075 "" 0 (string.length "")))
                          (caml_ml_output_char
                            (field 23 (global camlPervasives!)) '\n')
                          (caml_ml_flush (field 23 (global camlPervasives!))))
                        0a)
                      (for x/1047 -39 to 38
                        (let
                          (i/1048
                             (camlCode__iterate_1033 
                               (/. (float_of_int x/1047) 40.0)
                               (-. (/. (float_of_int y/1046) 40.0) 0.5)))
                          (if (== 1 n/1045)
                            (let
                              (s/1076 (if (== 0 i/1048) "*" " ")
                               oc/1077 (field 23 (global camlPervasives!)))
                              (caml_ml_output oc/1077 s/1076 0
                                (string.length s/1076)))
                            0a)))))) {2} ))
    (setfield_imm 3 (global camlCode!) mandelbrot/1044))
  (let (start_time/1049 (caml_sys_time 0a))
    (seq
      (for iter/1050 1 to 100
        (for y/1078 -39 to 38
          (seq
            (if (== 1 iter/1050)
              (seq
                (let (oc/1083 (field 23 (global camlPervasives!)))
                  (caml_ml_output oc/1083 "" 0 (string.length "")))
                (caml_ml_output_char (field 23 (global camlPervasives!))
                  '\n')
                (caml_ml_flush (field 23 (global camlPervasives!))))
              0a)
            (for x/1079 -39 to 38
              (let
                (i/1080
                   (camlCode__iterate_1033  (/. (float_of_int x/1079) 40.0)
                     (-. (/. (float_of_int y/1078) 40.0) 0.5)))
                (if (== 1 iter/1050)
                  (let
                    (s/1081 (if (== 0 i/1080) "*" " ")
                     oc/1082 (field 23 (global camlPervasives!)))
                    (caml_ml_output oc/1082 s/1081 0 (string.length s/1081)))
                  0a))))))
      (let (oc/1084 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1084 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))
      (let
        (f/1085 (-. (caml_sys_time 0a) start_time/1049)
         s/1086
           (camlPervasives__valid_float_lexem_1136 
             (caml_format_float "%.12g" f/1085))
         oc/1087 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1087 s/1086 0 (string.length s/1086)))
      (let (oc/1088 (field 23 (global camlPervasives!)))
        (caml_ml_output oc/1088 "" 0 (string.length "")))
      (caml_ml_output_char (field 23 (global camlPervasives!)) '\n')
      (caml_ml_flush (field 23 (global camlPervasives!)))))
  0a)
After TonSlambda.optimize:
(seq
  (let (temp/1207 (global camlCode!) temp/1208 100)
    (setfield_imm 0 temp/1207 temp/1208))
  (let (temp/1205 (global camlCode!) temp/1206 1000)
    (setfield_imm 1 temp/1205 temp/1206))
  (let
    (iterate/1033
       (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                  (let
                    (bailout/1036 4.0
                     loop/1037
                       (closure (camlCode__loop_1037(3+c)  zi/1059 zr/1060
                                  i/1061 env/1064
                                  (let
                                    (i/1040[Variable] i/1061
                                     zr/1039[Variable] zr/1060
                                     zi/1038[Variable] zi/1059)
                                    (catch
                                      (while 1a
                                        (catch
                                          (let
                                            (temp/1194
                                               (let
                                                 (temp/1195
                                                    (let (temp/1196 1000)
                                                      (> i/1040 temp/1196)))
                                                 (if temp/1195 0
                                                   (let
                                                     (temp/1041
                                                        (*. zr/1039 zi/1038)
                                                      zr2/1042
                                                        (*. zr/1039 zr/1039)
                                                      zi2/1043
                                                        (*. zi/1038 zi/1038)
                                                      temp/1197
                                                        (let
                                                          (temp/1198
                                                             (+. zi2/1043
                                                               zr2/1042)
                                                           temp/1199
                                                             (field 5
                                                               env/1064))
                                                          (>. temp/1198
                                                            temp/1199)))
                                                     (if temp/1197 i/1040
                                                       (let
                                                         (arg/1055
                                                            (let
                                                              (temp/1203
                                                                 (+.
                                                                   temp/1041
                                                                   temp/1041)
                                                               temp/1204
                                                                 (field 3
                                                                   env/1064))
                                                              (+. temp/1203
                                                                temp/1204))
                                                          arg/1056
                                                            (let
                                                              (temp/1201
                                                                 (-. zr2/1042
                                                                   zi2/1043)
                                                               temp/1202
                                                                 (field 4
                                                                   env/1064))
                                                              (+. temp/1201
                                                                temp/1202))
                                                          arg/1057
                                                            (let
                                                              (temp/1200 1)
                                                              (+ i/1040
                                                                temp/1200)))
                                                         (seq
                                                           (assign i/1040
                                                             arg/1057)
                                                           (assign zr/1039
                                                             arg/1056)
                                                           (assign zi/1038
                                                             arg/1055)
                                                           (exit 11))))))))
                                            (exit 12 temp/1194))
                                         with (11) 0a))
                                     with (12 res/1058) res/1058))) {3} 
                                                                    ci/1034
                                                                    cr/1035
                                                                    bailout/1036)
                     i/1065[Variable] 1
                     zr/1066[Variable] 0.0
                     zi/1067[Variable] 0.0)
                    (catch
                      (while 1a
                        (catch
                          (let
                            (temp/1183
                               (let
                                 (temp/1184
                                    (let (temp/1185 1000)
                                      (> i/1065 temp/1185)))
                                 (if temp/1184 0
                                   (let
                                     (temp/1068 (*. zr/1066 zi/1067)
                                      zr2/1069 (*. zr/1066 zr/1066)
                                      zi2/1070 (*. zi/1067 zi/1067)
                                      temp/1186
                                        (let
                                          (temp/1187 (+. zi2/1070 zr2/1069)
                                           temp/1188 (field 5 loop/1037))
                                          (>. temp/1187 temp/1188)))
                                     (if temp/1186 i/1065
                                       (let
                                         (arg/1071
                                            (let
                                              (temp/1192
                                                 (+. temp/1068 temp/1068)
                                               temp/1193 (field 3 loop/1037))
                                              (+. temp/1192 temp/1193))
                                          arg/1072
                                            (let
                                              (temp/1190
                                                 (-. zr2/1069 zi2/1070)
                                               temp/1191 (field 4 loop/1037))
                                              (+. temp/1190 temp/1191))
                                          arg/1073
                                            (let (temp/1189 1)
                                              (+ i/1065 temp/1189)))
                                         (seq (assign i/1065 arg/1073)
                                           (assign zr/1066 arg/1072)
                                           (assign zi/1067 arg/1071)
                                           (exit 11))))))))
                            (exit 12 temp/1183))
                         with (11) 0a))
                     with (12 res/1058) res/1058))) {3} )
     temp/1182 (global camlCode!))
    (setfield_imm 2 temp/1182 iterate/1033))
  (let
    (mandelbrot/1044
       (closure (camlCode__mandelbrot_1044(1)  n/1045
                  (let (temp/1151 -39 temp/1152 38)
                    (for y/1046 temp/1151 to temp/1152
                      (seq
                        (let
                          (temp/1170
                             (let (temp/1171 1) (== temp/1171 n/1045)))
                          (if temp/1170
                            (seq
                              (let
                                (oc/1075
                                   (let (temp/1181 (global camlPervasives!))
                                     (field 23 temp/1181))
                                 temp/1177 ""
                                 temp/1178 0
                                 temp/1179
                                   (let (temp/1180 "")
                                     (string.length temp/1180)))
                                (caml_ml_output oc/1075 temp/1177 temp/1178
                                  temp/1179))
                              (let
                                (temp/1174
                                   (let (temp/1175 (global camlPervasives!))
                                     (field 23 temp/1175))
                                 temp/1176 '\n')
                                (caml_ml_output_char temp/1174 temp/1176))
                              (let
                                (temp/1172
                                   (let (temp/1173 (global camlPervasives!))
                                     (field 23 temp/1173)))
                                (caml_ml_flush temp/1172)))
                            0a))
                        (let (temp/1153 -39 temp/1154 38)
                          (for x/1047 temp/1153 to temp/1154
                            (let
                              (i/1048
                                 (let
                                   (temp/1162
                                      (let
                                        (temp/1163 (float_of_int x/1047)
                                         temp/1164 40.0)
                                        (/. temp/1163 temp/1164))
                                    temp/1165
                                      (let
                                        (temp/1166
                                           (let
                                             (temp/1167 (float_of_int y/1046)
                                              temp/1168 40.0)
                                             (/. temp/1167 temp/1168))
                                         temp/1169 0.5)
                                        (-. temp/1166 temp/1169)))
                                   (camlCode__iterate_1033  temp/1162
                                     temp/1165))
                               temp/1155
                                 (let (temp/1156 1) (== temp/1156 n/1045)))
                              (if temp/1155
                                (let
                                  (s/1076
                                     (let
                                       (temp/1160
                                          (let (temp/1161 0)
                                            (== temp/1161 i/1048)))
                                       (if temp/1160 "*" " "))
                                   oc/1077
                                     (let
                                       (temp/1159 (global camlPervasives!))
                                       (field 23 temp/1159))
                                   temp/1157 0
                                   temp/1158 (string.length s/1076))
                                  (caml_ml_output oc/1077 s/1076 temp/1157
                                    temp/1158))
                                0a)))))))) {2} )
     temp/1150 (global camlCode!))
    (setfield_imm 3 temp/1150 mandelbrot/1044))
  (let (start_time/1049 (let (temp/1149 0a) (caml_sys_time temp/1149)))
    (seq
      (let (temp/1116 1 temp/1117 100)
        (for iter/1050 temp/1116 to temp/1117
          (let (temp/1118 -39 temp/1119 38)
            (for y/1078 temp/1118 to temp/1119
              (seq
                (let (temp/1137 (let (temp/1138 1) (== temp/1138 iter/1050)))
                  (if temp/1137
                    (seq
                      (let
                        (oc/1083
                           (let (temp/1148 (global camlPervasives!))
                             (field 23 temp/1148))
                         temp/1144 ""
                         temp/1145 0
                         temp/1146
                           (let (temp/1147 "") (string.length temp/1147)))
                        (caml_ml_output oc/1083 temp/1144 temp/1145
                          temp/1146))
                      (let
                        (temp/1141
                           (let (temp/1142 (global camlPervasives!))
                             (field 23 temp/1142))
                         temp/1143 '\n')
                        (caml_ml_output_char temp/1141 temp/1143))
                      (let
                        (temp/1139
                           (let (temp/1140 (global camlPervasives!))
                             (field 23 temp/1140)))
                        (caml_ml_flush temp/1139)))
                    0a))
                (let (temp/1120 -39 temp/1121 38)
                  (for x/1079 temp/1120 to temp/1121
                    (let
                      (i/1080
                         (let
                           (temp/1129
                              (let
                                (temp/1130 (float_of_int x/1079)
                                 temp/1131 40.0)
                                (/. temp/1130 temp/1131))
                            temp/1132
                              (let
                                (temp/1133
                                   (let
                                     (temp/1134 (float_of_int y/1078)
                                      temp/1135 40.0)
                                     (/. temp/1134 temp/1135))
                                 temp/1136 0.5)
                                (-. temp/1133 temp/1136)))
                           (camlCode__iterate_1033  temp/1129 temp/1132))
                       temp/1122 (let (temp/1123 1) (== temp/1123 iter/1050)))
                      (if temp/1122
                        (let
                          (s/1081
                             (let
                               (temp/1127
                                  (let (temp/1128 0) (== temp/1128 i/1080)))
                               (if temp/1127 "*" " "))
                           oc/1082
                             (let (temp/1126 (global camlPervasives!))
                               (field 23 temp/1126))
                           temp/1124 0
                           temp/1125 (string.length s/1081))
                          (caml_ml_output oc/1082 s/1081 temp/1124 temp/1125))
                        0a)))))))))
      (let
        (oc/1084
           (let (temp/1115 (global camlPervasives!)) (field 23 temp/1115))
         temp/1111 ""
         temp/1112 0
         temp/1113 (let (temp/1114 "") (string.length temp/1114)))
        (caml_ml_output oc/1084 temp/1111 temp/1112 temp/1113))
      (let
        (temp/1108
           (let (temp/1109 (global camlPervasives!)) (field 23 temp/1109))
         temp/1110 '\n')
        (caml_ml_output_char temp/1108 temp/1110))
      (let
        (temp/1106
           (let (temp/1107 (global camlPervasives!)) (field 23 temp/1107)))
        (caml_ml_flush temp/1106))
      (let
        (f/1085
           (let (temp/1104 (let (temp/1105 0a) (caml_sys_time temp/1105)))
             (-. temp/1104 start_time/1049))
         s/1086
           (let
             (temp/1102
                (let (temp/1103 "%.12g")
                  (caml_format_float temp/1103 f/1085)))
             (camlPervasives__valid_float_lexem_1136  temp/1102))
         oc/1087
           (let (temp/1101 (global camlPervasives!)) (field 23 temp/1101))
         temp/1099 0
         temp/1100 (string.length s/1086))
        (caml_ml_output oc/1087 s/1086 temp/1099 temp/1100))
      (let
        (oc/1088
           (let (temp/1098 (global camlPervasives!)) (field 23 temp/1098))
         temp/1094 ""
         temp/1095 0
         temp/1096 (let (temp/1097 "") (string.length temp/1097)))
        (caml_ml_output oc/1088 temp/1094 temp/1095 temp/1096))
      (let
        (temp/1091
           (let (temp/1092 (global camlPervasives!)) (field 23 temp/1092))
         temp/1093 '\n')
        (caml_ml_output_char temp/1091 temp/1093))
      (let
        (temp/1089
           (let (temp/1090 (global camlPervasives!)) (field 23 temp/1090)))
        (caml_ml_flush temp/1089))))
  0a)
Before TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (setfield_imm 0 temp/1207 100)
    (let (temp/1205 (global camlCode!))
      (seq (setfield_imm 1 temp/1205 1000)
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184 (> i/1065 1000)
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073 (+ i/1065 1))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (for y/1046 -39 to 38
                              (let (temp/1170 (== 1 n/1045))
                                (seq
                                  (if temp/1170
                                    (let
                                      (temp/1181 (global camlPervasives!)
                                       oc/1075 (field 23 temp/1181)
                                       temp/1177 ""
                                       temp/1180 ""
                                       temp/1179 (string.length temp/1180))
                                      (seq
                                        (caml_ml_output oc/1075 temp/1177 0
                                          temp/1179)
                                        (let
                                          (temp/1175 (global camlPervasives!)
                                           temp/1174 (field 23 temp/1175))
                                          (seq
                                            (caml_ml_output_char temp/1174
                                              10)
                                            (let
                                              (temp/1173
                                                 (global camlPervasives!)
                                               temp/1172 (field 23 temp/1173))
                                              (caml_ml_flush temp/1172))))))
                                    0a)
                                  (for x/1047 -39 to 38
                                    (let
                                      (temp/1163 (float_of_int x/1047)
                                       temp/1164 40.0
                                       temp/1162 (/. temp/1163 temp/1164)
                                       temp/1167 (float_of_int y/1046)
                                       temp/1168 40.0
                                       temp/1166 (/. temp/1167 temp/1168)
                                       temp/1169 0.5
                                       temp/1165 (-. temp/1166 temp/1169)
                                       i/1048
                                         (camlCode__iterate_1033  temp/1162
                                           temp/1165)
                                       temp/1155 (== 1 n/1045))
                                      (if temp/1155
                                        (let
                                          (temp/1160 (== 0 i/1048)
                                           s/1076 (if temp/1160 "*" " ")
                                           temp/1159 (global camlPervasives!)
                                           oc/1077 (field 23 temp/1159)
                                           temp/1158 (string.length s/1076))
                                          (caml_ml_output oc/1077 s/1076 0
                                            temp/1158))
                                        0a))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let (start_time/1049 (caml_sys_time 0a))
                  (seq
                    (seq
                      (for iter/1050 1 to 100
                        (for y/1078 -39 to 38
                          (let (temp/1137 (== 1 iter/1050))
                            (seq
                              (if temp/1137
                                (let
                                  (temp/1148 (global camlPervasives!)
                                   oc/1083 (field 23 temp/1148)
                                   temp/1144 ""
                                   temp/1147 ""
                                   temp/1146 (string.length temp/1147))
                                  (seq
                                    (caml_ml_output oc/1083 temp/1144 0
                                      temp/1146)
                                    (let
                                      (temp/1142 (global camlPervasives!)
                                       temp/1141 (field 23 temp/1142))
                                      (seq (caml_ml_output_char temp/1141 10)
                                        (let
                                          (temp/1140 (global camlPervasives!)
                                           temp/1139 (field 23 temp/1140))
                                          (caml_ml_flush temp/1139))))))
                                0a)
                              (for x/1079 -39 to 38
                                (let
                                  (temp/1130 (float_of_int x/1079)
                                   temp/1131 40.0
                                   temp/1129 (/. temp/1130 temp/1131)
                                   temp/1134 (float_of_int y/1078)
                                   temp/1135 40.0
                                   temp/1133 (/. temp/1134 temp/1135)
                                   temp/1136 0.5
                                   temp/1132 (-. temp/1133 temp/1136)
                                   i/1080
                                     (camlCode__iterate_1033  temp/1129
                                       temp/1132)
                                   temp/1122 (== 1 iter/1050))
                                  (if temp/1122
                                    (let
                                      (temp/1127 (== 0 i/1080)
                                       s/1081 (if temp/1127 "*" " ")
                                       temp/1126 (global camlPervasives!)
                                       oc/1082 (field 23 temp/1126)
                                       temp/1125 (string.length s/1081))
                                      (caml_ml_output oc/1082 s/1081 0
                                        temp/1125))
                                    0a)))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq (caml_ml_output oc/1084 temp/1111 0 temp/1113)
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq (caml_ml_output_char temp/1108 10)
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104 (caml_sys_time 0a)
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq (caml_ml_output oc/1087 s/1086 0 temp/1100)
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (caml_ml_output oc/1088 temp/1094 0
                                    temp/1096)
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq (caml_ml_output_char temp/1091 10)
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
After TonSlambda.optimize:
(let (temp/1207 (global camlCode!))
  (seq (let (temp/1241 100) (setfield_imm 0 temp/1207 temp/1241))
    (let (temp/1205 (global camlCode!))
      (seq (let (temp/1240 1000) (setfield_imm 1 temp/1205 temp/1240))
        (let
          (iterate/1033
             (closure (camlCode__iterate_1033(2)  ci/1034 cr/1035
                        (let
                          (bailout/1036 4.0
                           i/1065[Variable] 1
                           zr/1066[Variable] 0.0
                           zi/1067[Variable] 0.0)
                          (catch
                            (while 1a
                              (catch
                                (let
                                  (temp/1184
                                     (let (temp/1239 1000)
                                       (> i/1065 temp/1239))
                                   temp/1183
                                     (if temp/1184 0
                                       (let
                                         (temp/1068 (*. zr/1066 zi/1067)
                                          zr2/1069 (*. zr/1066 zr/1066)
                                          zi2/1070 (*. zi/1067 zi/1067)
                                          temp/1187 (+. zi2/1070 zr2/1069)
                                          temp/1186
                                            (>. temp/1187 bailout/1036))
                                         (if temp/1186 i/1065
                                           (let
                                             (temp/1192
                                                (+. temp/1068 temp/1068)
                                              arg/1071 (+. temp/1192 ci/1034)
                                              temp/1190
                                                (-. zr2/1069 zi2/1070)
                                              arg/1072 (+. temp/1190 cr/1035)
                                              arg/1073
                                                (let (temp/1238 1)
                                                  (+ i/1065 temp/1238)))
                                             (seq (assign i/1065 arg/1073)
                                               (assign zr/1066 arg/1072)
                                               (assign zi/1067 arg/1071)
                                               (exit 11)))))))
                                  (exit 12 temp/1183))
                               with (11) 0a))
                           with (12 res/1058) res/1058))) {3} )
           temp/1182 (global camlCode!))
          (seq (setfield_imm 2 temp/1182 iterate/1033)
            (let
              (mandelbrot/1044
                 (closure (camlCode__mandelbrot_1044(1)  n/1045
                            (let (temp/1228 -39 temp/1229 38)
                              (for y/1046 temp/1228 to temp/1229
                                (let
                                  (temp/1170
                                     (let (temp/1237 1)
                                       (== temp/1237 n/1045)))
                                  (seq
                                    (if temp/1170
                                      (let
                                        (temp/1181 (global camlPervasives!)
                                         oc/1075 (field 23 temp/1181)
                                         temp/1177 ""
                                         temp/1180 ""
                                         temp/1179 (string.length temp/1180))
                                        (seq
                                          (let (temp/1236 0)
                                            (caml_ml_output oc/1075 temp/1177
                                              temp/1236 temp/1179))
                                          (let
                                            (temp/1175
                                               (global camlPervasives!)
                                             temp/1174 (field 23 temp/1175))
                                            (seq
                                              (let (temp/1235 10)
                                                (caml_ml_output_char
                                                  temp/1174 temp/1235))
                                              (let
                                                (temp/1173
                                                   (global camlPervasives!)
                                                 temp/1172
                                                   (field 23 temp/1173))
                                                (caml_ml_flush temp/1172))))))
                                      0a)
                                    (let (temp/1230 -39 temp/1231 38)
                                      (for x/1047 temp/1230 to temp/1231
                                        (let
                                          (temp/1163 (float_of_int x/1047)
                                           temp/1164 40.0
                                           temp/1162 (/. temp/1163 temp/1164)
                                           temp/1167 (float_of_int y/1046)
                                           temp/1168 40.0
                                           temp/1166 (/. temp/1167 temp/1168)
                                           temp/1169 0.5
                                           temp/1165 (-. temp/1166 temp/1169)
                                           i/1048
                                             (camlCode__iterate_1033 
                                               temp/1162 temp/1165)
                                           temp/1155
                                             (let (temp/1234 1)
                                               (== temp/1234 n/1045)))
                                          (if temp/1155
                                            (let
                                              (temp/1160
                                                 (let (temp/1233 0)
                                                   (== temp/1233 i/1048))
                                               s/1076 (if temp/1160 "*" " ")
                                               temp/1159
                                                 (global camlPervasives!)
                                               oc/1077 (field 23 temp/1159)
                                               temp/1158
                                                 (string.length s/1076)
                                               temp/1232 0)
                                              (caml_ml_output oc/1077 s/1076
                                                temp/1232 temp/1158))
                                            0a))))))))) {2} )
               temp/1150 (global camlCode!))
              (seq (setfield_imm 3 temp/1150 mandelbrot/1044)
                (let
                  (start_time/1049
                     (let (temp/1227 0a) (caml_sys_time temp/1227)))
                  (seq
                    (seq
                      (let (temp/1215 1 temp/1216 100)
                        (for iter/1050 temp/1215 to temp/1216
                          (let (temp/1217 -39 temp/1218 38)
                            (for y/1078 temp/1217 to temp/1218
                              (let
                                (temp/1137
                                   (let (temp/1226 1)
                                     (== temp/1226 iter/1050)))
                                (seq
                                  (if temp/1137
                                    (let
                                      (temp/1148 (global camlPervasives!)
                                       oc/1083 (field 23 temp/1148)
                                       temp/1144 ""
                                       temp/1147 ""
                                       temp/1146 (string.length temp/1147))
                                      (seq
                                        (let (temp/1225 0)
                                          (caml_ml_output oc/1083 temp/1144
                                            temp/1225 temp/1146))
                                        (let
                                          (temp/1142 (global camlPervasives!)
                                           temp/1141 (field 23 temp/1142))
                                          (seq
                                            (let (temp/1224 10)
                                              (caml_ml_output_char temp/1141
                                                temp/1224))
                                            (let
                                              (temp/1140
                                                 (global camlPervasives!)
                                               temp/1139 (field 23 temp/1140))
                                              (caml_ml_flush temp/1139))))))
                                    0a)
                                  (let (temp/1219 -39 temp/1220 38)
                                    (for x/1079 temp/1219 to temp/1220
                                      (let
                                        (temp/1130 (float_of_int x/1079)
                                         temp/1131 40.0
                                         temp/1129 (/. temp/1130 temp/1131)
                                         temp/1134 (float_of_int y/1078)
                                         temp/1135 40.0
                                         temp/1133 (/. temp/1134 temp/1135)
                                         temp/1136 0.5
                                         temp/1132 (-. temp/1133 temp/1136)
                                         i/1080
                                           (camlCode__iterate_1033  temp/1129
                                             temp/1132)
                                         temp/1122
                                           (let (temp/1223 1)
                                             (== temp/1223 iter/1050)))
                                        (if temp/1122
                                          (let
                                            (temp/1127
                                               (let (temp/1222 0)
                                                 (== temp/1222 i/1080))
                                             s/1081 (if temp/1127 "*" " ")
                                             temp/1126
                                               (global camlPervasives!)
                                             oc/1082 (field 23 temp/1126)
                                             temp/1125 (string.length s/1081)
                                             temp/1221 0)
                                            (caml_ml_output oc/1082 s/1081
                                              temp/1221 temp/1125))
                                          0a))))))))))
                      (let
                        (temp/1115 (global camlPervasives!)
                         oc/1084 (field 23 temp/1115)
                         temp/1111 ""
                         temp/1114 ""
                         temp/1113 (string.length temp/1114))
                        (seq
                          (seq
                            (let (temp/1214 0)
                              (caml_ml_output oc/1084 temp/1111 temp/1214
                                temp/1113))
                            (let
                              (temp/1109 (global camlPervasives!)
                               temp/1108 (field 23 temp/1109))
                              (seq
                                (let (temp/1213 10)
                                  (caml_ml_output_char temp/1108 temp/1213))
                                (let
                                  (temp/1107 (global camlPervasives!)
                                   temp/1106 (field 23 temp/1107))
                                  (caml_ml_flush temp/1106)))))
                          (let
                            (temp/1104
                               (let (temp/1212 0a) (caml_sys_time temp/1212))
                             f/1085 (-. temp/1104 start_time/1049)
                             temp/1103 "%.12g"
                             temp/1102 (caml_format_float temp/1103 f/1085)
                             s/1086
                               (camlPervasives__valid_float_lexem_1136 
                                 temp/1102)
                             temp/1101 (global camlPervasives!)
                             oc/1087 (field 23 temp/1101)
                             temp/1100 (string.length s/1086))
                            (seq
                              (let (temp/1211 0)
                                (caml_ml_output oc/1087 s/1086 temp/1211
                                  temp/1100))
                              (let
                                (temp/1098 (global camlPervasives!)
                                 oc/1088 (field 23 temp/1098)
                                 temp/1094 ""
                                 temp/1097 ""
                                 temp/1096 (string.length temp/1097))
                                (seq
                                  (let (temp/1210 0)
                                    (caml_ml_output oc/1088 temp/1094
                                      temp/1210 temp/1096))
                                  (let
                                    (temp/1092 (global camlPervasives!)
                                     temp/1091 (field 23 temp/1092))
                                    (seq
                                      (let (temp/1209 10)
                                        (caml_ml_output_char temp/1091
                                          temp/1209))
                                      (let
                                        (temp/1090 (global camlPervasives!)
                                         temp/1089 (field 23 temp/1090))
                                        (caml_ml_flush temp/1089)))))))))))
                    0a))))))))))
Before TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
After TonScmm.optimize:
(let
  (bailout/1286 4.0 i/1065[Variable] 3 zr/1285[Variable] 0.0
   zi/1284[Variable] 0.0)
  (catch
    (loop
      (catch
        (let
          (temp/1184 (let temp/1239 2001 (+ (<< (> i/1065 temp/1239) 1) 1))
           temp/1183
             (if (!= temp/1184 1) 1
               (let
                 (temp/1283 (*f zr/1285 zi/1284)
                  zr2/1282 (*f zr/1285 zr/1285) zi2/1281 (*f zi/1284 zi/1284)
                  temp/1280 (+f zi2/1281 zr2/1282)
                  temp/1186 (+ (<< (>f temp/1280 bailout/1286) 1) 1))
                 (if (!= temp/1186 1) i/1065
                   (let
                     (temp/1279 (+f temp/1283 temp/1283)
                      arg/1278 (+f temp/1279 (load float64u ci/1034))
                      temp/1277 (-f zr2/1282 zi2/1281)
                      arg/1276 (+f temp/1277 (load float64u cr/1035))
                      arg/1073 (let temp/1238 3 (+ (+ i/1065 temp/1238) -1)))
                     (assign i/1065 arg/1073) (assign zr/1285 arg/1276)
                     (assign zi/1284 arg/1278) (exit 11))))))
          (exit 12 temp/1183))
      with(11) []))
    1a
  with(12 res/1058) res/1058))
Before simplify
camlCode__iterate_1033:
                  ci/8[%edx] := R/0[%eax]
                  R/7[%tos] := 4.0
                  bailout/11[s4] := R/7[%tos]
                  i/12[%ecx] := 3
                  R/7[%tos] := 0.0
                  zr/14[s0] := R/7[%tos]
                  R/7[%tos] := 0.0
                  zi/16[s2] := R/7[%tos]
                  L101 [0]:
                  temp/18[%eax] := 2001
                  I/19[%eax] := i/12[%ecx] >s temp/18[%eax]
                  temp/20[%eax] := I/19[%eax]  * 2 + 1
                  if temp/20[%eax] ==s 1 goto L104
                  temp/21[%ecx] := 1
                  goto L100
                  L104 [0]:
                  R/7[%tos] := zr/14[s0] *f zi/16[s2]
                  temp/23[s1] := R/7[%tos]
                  R/7[%tos] := zr/14[s0] *f zr/14[s0]
                  zr2/25[s3] := R/7[%tos]
                  R/7[%tos] := zi/16[s2] *f zi/16[s2]
                  zi2/27[s2] := R/7[%tos]
                  R/7[%tos] := zi2/27[s2] +f zr2/25[s3]
                  temp/29[s0] := R/7[%tos]
                  if not temp/29[s0] >f bailout/11[s4] goto L103
                  I/30[%eax] := 1
                  goto L102
                  L103 [0]:
                  I/31[%eax] := 0
                  L102 [0]:
                  temp/32[%eax] := I/30[%eax]  * 2 + 1
                  if temp/32[%eax] !=s 1 goto L100
                  R/7[%tos] := temp/23[s1] +f temp/23[s1]
                  temp/34[s0] := R/7[%tos]
                  R/7[%tos] := temp/34[s0] +f float64[ci/8[%edx]]
                  arg/36[s1] := R/7[%tos]
                  R/7[%tos] := zr2/25[s3] -f zi2/27[s2]
                  temp/38[s0] := R/7[%tos]
                  R/7[%tos] := temp/38[s0] +f float64[cr/9[%ebx]]
                  arg/40[s0] := R/7[%tos]
                  temp/41[%eax] := 3
                  arg/42[%ecx] := i/12[%ecx] + temp/41[%eax] + -1
                  zi/16[s2] := arg/36[s1]
                  goto L101
                  L100 [0]:
                  R/0[%eax] := res/17[%ecx]
                  return R/0[%eax]
                  *** Linearized code
camlCode__iterate_1033:
  ci/8[%edx] := R/0[%eax]
  R/7[%tos] := 4.0
  bailout/11[s4] := R/7[%tos]
  i/12[%ecx] := 3
  R/7[%tos] := 0.0
  zr/14[s0] := R/7[%tos]
  R/7[%tos] := 0.0
  zi/16[s2] := R/7[%tos]
  L101 [3]:
  temp/18[%eax] := 2001
  I/19[%eax] := i/12[%ecx] >s temp/18[%eax]
  temp/20[%eax] := I/19[%eax]  * 2 + 1
  if temp/20[%eax] ==s 1 goto L104
  temp/21[%ecx] := 1
  goto L100
  L104 [2]:
  R/7[%tos] := zr/14[s0] *f zi/16[s2]
  temp/23[s1] := R/7[%tos]
  R/7[%tos] := zr/14[s0] *f zr/14[s0]
  zr2/25[s3] := R/7[%tos]
  R/7[%tos] := zi/16[s2] *f zi/16[s2]
  zi2/27[s2] := R/7[%tos]
  R/7[%tos] := zi2/27[s2] +f zr2/25[s3]
  temp/29[s0] := R/7[%tos]
  if not temp/29[s0] >f bailout/11[s4] goto L103
  I/30[%eax] := 1
  goto L102
  L103 [2]:
  I/31[%eax] := 0
  L102 [3]:
  temp/32[%eax] := I/30[%eax]  * 2 + 1
  if temp/32[%eax] !=s 1 goto L100
  R/7[%tos] := temp/23[s1] +f temp/23[s1]
  temp/34[s0] := R/7[%tos]
  R/7[%tos] := temp/34[s0] +f float64[ci/8[%edx]]
  arg/36[s1] := R/7[%tos]
  R/7[%tos] := zr2/25[s3] -f zi2/27[s2]
  temp/38[s0] := R/7[%tos]
  R/7[%tos] := temp/38[s0] +f float64[cr/9[%ebx]]
  arg/40[s0] := R/7[%tos]
  temp/41[%eax] := 3
  arg/42[%ecx] := i/12[%ecx] + temp/41[%eax] + -1
  zi/16[s2] := arg/36[s1]
  goto L101
  L100 [3]:
  R/0[%eax] := res/17[%ecx]
  return R/0[%eax]
  
Before TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
After TonScmm.optimize:
(let (temp/1228 -77 temp/1229 77)
  (let (y/1046[Variable] temp/1228 bound/1263 temp/1229)
    (catch
      (if (> y/1046 bound/1263) (exit 16)
        (loop
          (let temp/1170 (let temp/1237 3 (+ (<< (== temp/1237 n/1045) 1) 1))
            (if (!= temp/1170 1)
              (let
                (temp/1181 "camlPervasives" oc/1075 (load (+a temp/1181 92))
                 temp/1177 "camlCode__1" temp/1180 "camlCode__1"
                 temp/1179
                   (+
                     (<<
                       (let
                         tmp/1275
                           (- (<< (>>u (load (+a temp/1180 -4)) 10) 2) 1)
                         (- tmp/1275
                           (load unsigned int8 (+a temp/1180 tmp/1275))))
                       1)
                     1))
                (let temp/1236 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1075
                    temp/1177 temp/1236 temp/1179 unit))
                (let
                  (temp/1175 "camlPervasives"
                   temp/1174 (load (+a temp/1175 92)))
                  (let temp/1235 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1174 temp/1235 unit))
                  (let
                    (temp/1173 "camlPervasives"
                     temp/1172 (load (+a temp/1173 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1172 unit))))
              [])
            (let
              (temp/1230 -77 temp/1231 77 x/1047[Variable] temp/1230
               bound/1265 temp/1231)
              (catch
                (if (> x/1047 bound/1265) (exit 17)
                  (loop
                    (let
                      (temp/1274 (floatofint (>>s x/1047 1)) temp/1273 40.0
                       temp/1272 (/f temp/1274 temp/1273)
                       temp/1271 (floatofint (>>s y/1046 1)) temp/1270 40.0
                       temp/1269 (/f temp/1271 temp/1270) temp/1268 0.5
                       temp/1267 (-f temp/1269 temp/1268)
                       i/1048
                         (app "camlCode__iterate_1033"
                           (alloc[253] 2301 temp/1272)
                           (alloc[253] 2301 temp/1267) addr)
                       temp/1155
                         (let temp/1234 3 (+ (<< (== temp/1234 n/1045) 1) 1)))
                      (if (!= temp/1155 1)
                        (let
                          (temp/1160
                             (let temp/1233 1
                               (+ (<< (== temp/1233 i/1048) 1) 1))
                           s/1076
                             (if (!= temp/1160 1) "camlCode__2"
                               "camlCode__3")
                           temp/1159 "camlPervasives"
                           oc/1077 (load (+a temp/1159 92))
                           temp/1158
                             (+
                               (<<
                                 (let
                                   tmp/1266
                                     (- (<< (>>u (load (+a s/1076 -4)) 10) 2)
                                       1)
                                   (- tmp/1266
                                     (load unsigned int8
                                       (+a s/1076 tmp/1266))))
                                 1)
                               1)
                           temp/1232 1)
                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                            oc/1077 s/1076 temp/1232 temp/1158 unit))
                        []))
                    (let x/1264 x/1047 (assign x/1047 (+ x/1047 2))
                      (if (== x/1264 bound/1265) (exit 17) []))))
              with(17) [])))
          (let y/1262 y/1046 (assign y/1046 (+ y/1046 2))
            (if (== y/1262 bound/1263) (exit 16) []))))
    with(16) []))
  1a)
Before simplify
camlCode__mandelbrot_1044:
                  temp/9[%ecx] := -77
                  temp/10[%ebx] := 77
                  if y/11[%ecx] >s bound/12[%ebx] goto L107
                  spilled-bound/83[s0] := bound/12[%ebx] (spill)
                  spilled-y/82[s1] := y/11[%ecx] (spill)
                  spilled-n/81[s2] := n/8[%eax] (spill)
                  L108 [0]:
                  temp/13[%ebx] := 3
                  n/84[%eax] := spilled-n/81[s2] (reload)
                  I/14[%eax] := temp/13[%ebx] ==s n/84[%eax]
                  temp/15[%eax] := I/14[%eax]  * 2 + 1
                  if temp/15[%eax] ==s 1 goto L114
                  temp/16[%eax] := "camlPervasives"
                  oc/17[%ebx] := [temp/16[%eax] + 92]
                  temp/18[%eax] := "camlCode__1"
                  temp/19[%edx] := "camlCode__1"
                  A/20[%ecx] := [temp/19[%edx] + -4]
                  I/21[%ecx] := I/21[%ecx] >>u 10
                  tmp/22[%ecx] := I/21[%ecx]  * 4 + -1
                  I/23[%edx] := unsigned int8[temp/19[%edx] + tmp/22[%ecx]]
                  I/24[%ecx] := I/24[%ecx] - I/23[%edx]
                  temp/25[%edx] := I/24[%ecx]  * 2 + 1
                  temp/26[%ecx] := 1
                  push temp/25[%edx]
                  push temp/26[%ecx]
                  push temp/18[%eax]
                  push oc/17[%ebx]
                  {spilled-n/81[s2]* spilled-y/82[s1] spilled-bound/83[s0]}
                  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
                  offset stack -16
                  temp/27[%eax] := "camlPervasives"
                  temp/28[%ebx] := [temp/27[%eax] + 92]
                  temp/29[%eax] := 21
                  push temp/29[%eax]
                  push temp/28[%ebx]
                  {spilled-n/81[s2]* spilled-y/82[s1] spilled-bound/83[s0]}
                  extcall "caml_ml_output_char"  (noalloc) {pervasives.ml:363,26-49}
                  offset stack -8
                  temp/30[%eax] := "camlPervasives"
                  temp/31[%eax] := [temp/30[%eax] + 92]
                  push temp/31[%eax]
                  {spilled-n/81[s2]* spilled-y/82[s1] spilled-bound/83[s0]}
                  extcall "caml_ml_flush"  (noalloc) {pervasives.ml:363,51-63}
                  offset stack -4
                  L114 [0]:
                  temp/32[%ebx] := -77
                  temp/33[%eax] := 77
                  spilled-x/80[s3] := x/34[%ebx] (spill)
                  spilled-bound/79[s4] := bound/35[%eax] (spill)
                  if x/34[%ebx] >s bound/35[%eax] goto L109
                  L110 [0]:
                  I/36[%ebx] := I/36[%ebx] >>s 1
                  R/7[%tos] := floatofint I/36[%ebx]
                  temp/38[s1] := R/7[%tos]
                  R/7[%tos] := 40.0
                  temp/40[s0] := R/7[%tos]
                  R/7[%tos] := temp/38[s1] /f temp/40[s0]
                  temp/42[s2] := R/7[%tos]
                  y/85[%eax] := spilled-y/82[s1] (reload)
                  I/43[%eax] := I/43[%eax] >>s 1
                  R/7[%tos] := floatofint I/43[%eax]
                  temp/45[s1] := R/7[%tos]
                  R/7[%tos] := 40.0
                  temp/47[s0] := R/7[%tos]
                  R/7[%tos] := temp/45[s1] /f temp/47[s0]
                  temp/49[s1] := R/7[%tos]
                  R/7[%tos] := 0.5
                  temp/51[s0] := R/7[%tos]
                  R/7[%tos] := temp/49[s1] -f temp/51[s0]
                  temp/53[s0] := R/7[%tos]
                  {temp/42[s2] temp/53[s0] spilled-bound/79[s4]
                   spilled-x/80[s3] spilled-n/81[s2]* spilled-y/82[s1]
                   spilled-bound/83[s0]}
                  A/54[%ebx] := alloc 24
                  [A/54[%ebx] + -4] := 2301
                  float64u[A/54[%ebx]] := temp/53[s0]
                  A/55[%eax] := A/54[%ebx] + 12
                  [A/55[%eax] + -4] := 2301
                  float64u[A/55[%eax]] := temp/42[s2]
                  {spilled-bound/79[s4] spilled-x/80[s3] spilled-n/81[s2]*
                   spilled-y/82[s1] spilled-bound/83[s0]}
                  R/0[%eax] := call "camlCode__iterate_1033" R/0[%eax] R/1[%ebx]
                  i/56[%ecx] := R/0[%eax]
                  temp/57[%ebx] := 3
                  n/86[%eax] := spilled-n/81[s2] (reload)
                  I/58[%eax] := temp/57[%ebx] ==s n/86[%eax]
                  temp/59[%eax] := I/58[%eax]  * 2 + 1
                  if temp/59[%eax] ==s 1 goto L111
                  temp/60[%eax] := 1
                  I/61[%eax] := temp/60[%eax] ==s i/56[%ecx]
                  temp/62[%eax] := I/61[%eax]  * 2 + 1
                  if temp/62[%eax] ==s 1 goto L113
                  s/63[%eax] := "camlCode__2"
                  goto L112
                  L113 [0]:
                  A/64[%eax] := "camlCode__3"
                  L112 [0]:
                  temp/65[%ebx] := "camlPervasives"
                  oc/66[%ebx] := [temp/65[%ebx] + 92]
                  A/67[%ecx] := [s/63[%eax] + -4]
                  I/68[%ecx] := I/68[%ecx] >>u 10
                  tmp/69[%ecx] := I/68[%ecx]  * 4 + -1
                  I/70[%edx] := unsigned int8[s/63[%eax] + tmp/69[%ecx]]
                  I/71[%ecx] := I/71[%ecx] - I/70[%edx]
                  temp/72[%edx] := I/71[%ecx]  * 2 + 1
                  temp/73[%ecx] := 1
                  push temp/72[%edx]
                  push temp/73[%ecx]
                  push s/63[%eax]
                  push oc/66[%ebx]
                  {spilled-bound/79[s4] spilled-x/80[s3] spilled-n/81[s2]*
                   spilled-y/82[s1] spilled-bound/83[s0]}
                  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
                  offset stack -16
                  L111 [0]:
                  x/34[%ebx] := spilled-x/80[s3] (reload)
                  x/74[%ecx] := x/34[%ebx]
                  I/75[%ebx] := I/75[%ebx] + 2
                  spilled-x/80[s3] := x/34[%ebx] (spill)
                  bound/88[%eax] := spilled-bound/79[s4] (reload)
                  if x/74[%ecx] !=s bound/88[%eax] goto L110
                  L109 [0]:
                  y/89[%eax] := spilled-y/82[s1] (reload)
                  y/76[%ebx] := y/89[%eax]
                  I/77[%eax] := I/77[%eax] + 2
                  spilled-y/82[s1] := y/89[%eax] (spill)
                  bound/90[%eax] := spilled-bound/83[s0] (reload)
                  if y/76[%ebx] !=s bound/90[%eax] goto L108
                  L107 [0]:
                  A/78[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__mandelbrot_1044:
  temp/9[%ecx] := -77
  temp/10[%ebx] := 77
  if y/11[%ecx] >s bound/12[%ebx] goto L107
  spilled-bound/83[s0] := bound/12[%ebx] (spill)
  spilled-y/82[s1] := y/11[%ecx] (spill)
  spilled-n/81[s2] := n/8[%eax] (spill)
  L108 [4]:
  temp/13[%ebx] := 3
  n/84[%eax] := spilled-n/81[s2] (reload)
  I/14[%eax] := temp/13[%ebx] ==s n/84[%eax]
  temp/15[%eax] := I/14[%eax]  * 2 + 1
  if temp/15[%eax] ==s 1 goto L114
  temp/16[%eax] := "camlPervasives"
  oc/17[%ebx] := [temp/16[%eax] + 92]
  temp/18[%eax] := "camlCode__1"
  temp/19[%edx] := "camlCode__1"
  A/20[%ecx] := [temp/19[%edx] + -4]
  I/21[%ecx] := I/21[%ecx] >>u 10
  tmp/22[%ecx] := I/21[%ecx]  * 4 + -1
  I/23[%edx] := unsigned int8[temp/19[%edx] + tmp/22[%ecx]]
  I/24[%ecx] := I/24[%ecx] - I/23[%edx]
  temp/25[%edx] := I/24[%ecx]  * 2 + 1
  temp/26[%ecx] := 1
  push temp/25[%edx]
  push temp/26[%ecx]
  push temp/18[%eax]
  push oc/17[%ebx]
  {spilled-n/81[s2]* spilled-y/82[s1] spilled-bound/83[s0]}
  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
  offset stack -16
  temp/27[%eax] := "camlPervasives"
  temp/28[%ebx] := [temp/27[%eax] + 92]
  temp/29[%eax] := 21
  push temp/29[%eax]
  push temp/28[%ebx]
  {spilled-n/81[s2]* spilled-y/82[s1] spilled-bound/83[s0]}
  extcall "caml_ml_output_char"  (noalloc) {pervasives.ml:363,26-49}
  offset stack -8
  temp/30[%eax] := "camlPervasives"
  temp/31[%eax] := [temp/30[%eax] + 92]
  push temp/31[%eax]
  {spilled-n/81[s2]* spilled-y/82[s1] spilled-bound/83[s0]}
  extcall "caml_ml_flush"  (noalloc) {pervasives.ml:363,51-63}
  offset stack -4
  L114 [4]:
  temp/32[%ebx] := -77
  temp/33[%eax] := 77
  spilled-x/80[s3] := x/34[%ebx] (spill)
  spilled-bound/79[s4] := bound/35[%eax] (spill)
  if x/34[%ebx] >s bound/35[%eax] goto L109
  L110 [4]:
  I/36[%ebx] := I/36[%ebx] >>s 1
  R/7[%tos] := floatofint I/36[%ebx]
  temp/38[s1] := R/7[%tos]
  R/7[%tos] := 40.0
  temp/40[s0] := R/7[%tos]
  R/7[%tos] := temp/38[s1] /f temp/40[s0]
  temp/42[s2] := R/7[%tos]
  y/85[%eax] := spilled-y/82[s1] (reload)
  I/43[%eax] := I/43[%eax] >>s 1
  R/7[%tos] := floatofint I/43[%eax]
  temp/45[s1] := R/7[%tos]
  R/7[%tos] := 40.0
  temp/47[s0] := R/7[%tos]
  R/7[%tos] := temp/45[s1] /f temp/47[s0]
  temp/49[s1] := R/7[%tos]
  R/7[%tos] := 0.5
  temp/51[s0] := R/7[%tos]
  R/7[%tos] := temp/49[s1] -f temp/51[s0]
  temp/53[s0] := R/7[%tos]
  {temp/42[s2] temp/53[s0] spilled-bound/79[s4] spilled-x/80[s3]
   spilled-n/81[s2]* spilled-y/82[s1] spilled-bound/83[s0]}
  A/54[%ebx] := alloc 24
  [A/54[%ebx] + -4] := 2301
  float64u[A/54[%ebx]] := temp/53[s0]
  A/55[%eax] := A/54[%ebx] + 12
  [A/55[%eax] + -4] := 2301
  float64u[A/55[%eax]] := temp/42[s2]
  {spilled-bound/79[s4] spilled-x/80[s3] spilled-n/81[s2]* spilled-y/82[s1]
   spilled-bound/83[s0]}
  R/0[%eax] := call "camlCode__iterate_1033" R/0[%eax] R/1[%ebx]
  i/56[%ecx] := R/0[%eax]
  temp/57[%ebx] := 3
  n/86[%eax] := spilled-n/81[s2] (reload)
  I/58[%eax] := temp/57[%ebx] ==s n/86[%eax]
  temp/59[%eax] := I/58[%eax]  * 2 + 1
  if temp/59[%eax] ==s 1 goto L111
  temp/60[%eax] := 1
  I/61[%eax] := temp/60[%eax] ==s i/56[%ecx]
  temp/62[%eax] := I/61[%eax]  * 2 + 1
  if temp/62[%eax] ==s 1 goto L113
  s/63[%eax] := "camlCode__2"
  goto L112
  L113 [2]:
  A/64[%eax] := "camlCode__3"
  L112 [3]:
  temp/65[%ebx] := "camlPervasives"
  oc/66[%ebx] := [temp/65[%ebx] + 92]
  A/67[%ecx] := [s/63[%eax] + -4]
  I/68[%ecx] := I/68[%ecx] >>u 10
  tmp/69[%ecx] := I/68[%ecx]  * 4 + -1
  I/70[%edx] := unsigned int8[s/63[%eax] + tmp/69[%ecx]]
  I/71[%ecx] := I/71[%ecx] - I/70[%edx]
  temp/72[%edx] := I/71[%ecx]  * 2 + 1
  temp/73[%ecx] := 1
  push temp/72[%edx]
  push temp/73[%ecx]
  push s/63[%eax]
  push oc/66[%ebx]
  {spilled-bound/79[s4] spilled-x/80[s3] spilled-n/81[s2]* spilled-y/82[s1]
   spilled-bound/83[s0]}
  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
  offset stack -16
  L111 [4]:
  x/34[%ebx] := spilled-x/80[s3] (reload)
  x/74[%ecx] := x/34[%ebx]
  I/75[%ebx] := I/75[%ebx] + 2
  spilled-x/80[s3] := x/34[%ebx] (spill)
  bound/88[%eax] := spilled-bound/79[s4] (reload)
  if x/74[%ecx] !=s bound/88[%eax] goto L110
  L109 [4]:
  y/89[%eax] := spilled-y/82[s1] (reload)
  y/76[%ebx] := y/89[%eax]
  I/77[%eax] := I/77[%eax] + 2
  spilled-y/82[s1] := y/89[%eax] (spill)
  bound/90[%eax] := spilled-bound/83[s0] (reload)
  if y/76[%ebx] !=s bound/90[%eax] goto L108
  L107 [4]:
  A/78[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
Before TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))
After TonScmm.optimize:
(let temp/1207 "camlCode" (let temp/1241 201 (store temp/1207 temp/1241))
  (let temp/1205 "camlCode"
    (let temp/1240 2001 (store (+a temp/1205 4) temp/1240))
    (let (iterate/1033 "camlCode__7" temp/1182 "camlCode")
      (store (+a temp/1182 8) iterate/1033)
      (let (mandelbrot/1044 "camlCode__6" temp/1150 "camlCode")
        (store (+a temp/1150 12) mandelbrot/1044)
        (let
          start_time/1049
            (let temp/1227 1a (extcall "caml_sys_time" temp/1227 addr))
          (let
            (temp/1215 3 temp/1216 201 iter/1050[Variable] temp/1215
             bound/1247 temp/1216)
            (catch
              (if (> iter/1050 bound/1247) (exit 13)
                (loop
                  (let
                    (temp/1217 -77 temp/1218 77 y/1078[Variable] temp/1217
                     bound/1249 temp/1218)
                    (catch
                      (if (> y/1078 bound/1249) (exit 14)
                        (loop
                          (let
                            temp/1137
                              (let temp/1226 3
                                (+ (<< (== temp/1226 iter/1050) 1) 1))
                            (if (!= temp/1137 1)
                              (let
                                (temp/1148 "camlPervasives"
                                 oc/1083 (load (+a temp/1148 92))
                                 temp/1144 "camlCode__1"
                                 temp/1147 "camlCode__1"
                                 temp/1146
                                   (+
                                     (<<
                                       (let
                                         tmp/1261
                                           (-
                                             (<<
                                               (>>u (load (+a temp/1147 -4))
                                                 10)
                                               2)
                                             1)
                                         (- tmp/1261
                                           (load unsigned int8
                                             (+a temp/1147 tmp/1261))))
                                       1)
                                     1))
                                (let temp/1225 1
                                  (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                    oc/1083 temp/1144 temp/1225 temp/1146
                                    unit))
                                (let
                                  (temp/1142 "camlPervasives"
                                   temp/1141 (load (+a temp/1142 92)))
                                  (let temp/1224 21
                                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                                      temp/1141 temp/1224 unit))
                                  (let
                                    (temp/1140 "camlPervasives"
                                     temp/1139 (load (+a temp/1140 92)))
                                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                                      temp/1139 unit))))
                              [])
                            (let
                              (temp/1219 -77 temp/1220 77
                               x/1079[Variable] temp/1219
                               bound/1251 temp/1220)
                              (catch
                                (if (> x/1079 bound/1251) (exit 15)
                                  (loop
                                    (let
                                      (temp/1260 (floatofint (>>s x/1079 1))
                                       temp/1259 40.0
                                       temp/1258 (/f temp/1260 temp/1259)
                                       temp/1257 (floatofint (>>s y/1078 1))
                                       temp/1256 40.0
                                       temp/1255 (/f temp/1257 temp/1256)
                                       temp/1254 0.5
                                       temp/1253 (-f temp/1255 temp/1254)
                                       i/1080
                                         (app "camlCode__iterate_1033"
                                           (alloc[253] 2301 temp/1258)
                                           (alloc[253] 2301 temp/1253) addr)
                                       temp/1122
                                         (let temp/1223 3
                                           (+ (<< (== temp/1223 iter/1050) 1)
                                             1)))
                                      (if (!= temp/1122 1)
                                        (let
                                          (temp/1127
                                             (let temp/1222 1
                                               (+
                                                 (<< (== temp/1222 i/1080) 1)
                                                 1))
                                           s/1081
                                             (if (!= temp/1127 1)
                                               "camlCode__2" "camlCode__3")
                                           temp/1126 "camlPervasives"
                                           oc/1082 (load (+a temp/1126 92))
                                           temp/1125
                                             (+
                                               (<<
                                                 (let
                                                   tmp/1252
                                                     (-
                                                       (<<
                                                         (>>u
                                                           (load
                                                             (+a s/1081 -4))
                                                           10)
                                                         2)
                                                       1)
                                                   (- tmp/1252
                                                     (load unsigned int8
                                                       (+a s/1081 tmp/1252))))
                                                 1)
                                               1)
                                           temp/1221 1)
                                          (extcall "caml_ml_output"{pervasives.ml:256,2-40}
                                            oc/1082 s/1081 temp/1221
                                            temp/1125 unit))
                                        []))
                                    (let x/1250 x/1079
                                      (assign x/1079 (+ x/1079 2))
                                      (if (== x/1250 bound/1251) (exit 15)
                                        []))))
                              with(15) [])))
                          (let y/1248 y/1078 (assign y/1078 (+ y/1078 2))
                            (if (== y/1248 bound/1249) (exit 14) []))))
                    with(14) []))
                  (let iter/1246 iter/1050 (assign iter/1050 (+ iter/1050 2))
                    (if (== iter/1246 bound/1247) (exit 13) []))))
            with(13) []))
          (let
            (temp/1115 "camlPervasives" oc/1084 (load (+a temp/1115 92))
             temp/1111 "camlCode__4" temp/1114 "camlCode__4"
             temp/1113
               (+
                 (<<
                   (let
                     tmp/1245 (- (<< (>>u (load (+a temp/1114 -4)) 10) 2) 1)
                     (- tmp/1245
                       (load unsigned int8 (+a temp/1114 tmp/1245))))
                   1)
                 1))
            (let temp/1214 1
              (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1084
                temp/1111 temp/1214 temp/1113 unit))
            (let
              (temp/1109 "camlPervasives" temp/1108 (load (+a temp/1109 92)))
              (let temp/1213 21
                (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                  temp/1108 temp/1213 unit))
              (let
                (temp/1107 "camlPervasives"
                 temp/1106 (load (+a temp/1107 92)))
                (extcall "caml_ml_flush"{pervasives.ml:363,51-63} temp/1106
                  unit)))
            (let
              (temp/1104
                 (let temp/1212 1a (extcall "caml_sys_time" temp/1212 addr))
               f/1244
                 (-f (load float64u temp/1104)
                   (load float64u start_time/1049))
               temp/1103 "camlPervasives__11"
               temp/1102
                 (extcall "caml_format_float"{pervasives.ml:198,42-66}
                   temp/1103 (alloc[253] 2301 f/1244) addr)
               s/1086
                 (app{pervasives.ml:361,41-60}
                   "camlPervasives__valid_float_lexem_1136" temp/1102 addr)
               temp/1101 "camlPervasives" oc/1087 (load (+a temp/1101 92))
               temp/1100
                 (+
                   (<<
                     (let
                       tmp/1243 (- (<< (>>u (load (+a s/1086 -4)) 10) 2) 1)
                       (- tmp/1243 (load unsigned int8 (+a s/1086 tmp/1243))))
                     1)
                   1))
              (let temp/1211 1
                (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1087
                  s/1086 temp/1211 temp/1100 unit))
              (let
                (temp/1098 "camlPervasives" oc/1088 (load (+a temp/1098 92))
                 temp/1094 "camlCode__5" temp/1097 "camlCode__5"
                 temp/1096
                   (+
                     (<<
                       (let
                         tmp/1242
                           (- (<< (>>u (load (+a temp/1097 -4)) 10) 2) 1)
                         (- tmp/1242
                           (load unsigned int8 (+a temp/1097 tmp/1242))))
                       1)
                     1))
                (let temp/1210 1
                  (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1088
                    temp/1094 temp/1210 temp/1096 unit))
                (let
                  (temp/1092 "camlPervasives"
                   temp/1091 (load (+a temp/1092 92)))
                  (let temp/1209 21
                    (extcall "caml_ml_output_char"{pervasives.ml:363,26-49}
                      temp/1091 temp/1209 unit))
                  (let
                    (temp/1090 "camlPervasives"
                     temp/1089 (load (+a temp/1090 92)))
                    (extcall "caml_ml_flush"{pervasives.ml:363,51-63}
                      temp/1089 unit))))))
          1a)))))
Before simplify
camlCode__entry:
                  temp/8[%ebx] := "camlCode"
                  temp/9[%eax] := 201
                  [temp/8[%ebx]] := temp/9[%eax]
                  temp/10[%ebx] := "camlCode"
                  temp/11[%eax] := 2001
                  [temp/10[%ebx] + 4] := temp/11[%eax]
                  iterate/12[%ebx] := "camlCode__7"
                  temp/13[%eax] := "camlCode"
                  [temp/13[%eax] + 8] := iterate/12[%ebx]
                  mandelbrot/14[%ebx] := "camlCode__6"
                  temp/15[%eax] := "camlCode"
                  [temp/15[%eax] + 12] := mandelbrot/14[%ebx]
                  temp/16[%eax] := 1
                  push temp/16[%eax]
                  {}
                  R/0[%eax] := extcall "caml_sys_time"  (noalloc)
                  offset stack -4
                  spilled-start_time/154[s0] := start_time/17[%eax] (spill)
                  temp/18[%ebx] := 3
                  temp/19[%eax] := 201
                  if iter/20[%ebx] >s bound/21[%eax] goto L127
                  spilled-bound/149[s1] := bound/21[%eax] (spill)
                  spilled-iter/146[s4] := iter/20[%ebx] (spill)
                  L128 [0]:
                  temp/22[%ebx] := -77
                  temp/23[%eax] := 77
                  spilled-y/147[s3] := y/24[%ebx] (spill)
                  spilled-bound/148[s2] := bound/25[%eax] (spill)
                  if y/24[%ebx] >s bound/25[%eax] goto L129
                  L130 [0]:
                  temp/26[%ebx] := 3
                  iter/155[%eax] := spilled-iter/146[s4] (reload)
                  I/27[%eax] := temp/26[%ebx] ==s iter/155[%eax]
                  temp/28[%eax] := I/27[%eax]  * 2 + 1
                  if temp/28[%eax] ==s 1 goto L136
                  temp/29[%eax] := "camlPervasives"
                  oc/30[%ebx] := [temp/29[%eax] + 92]
                  temp/31[%eax] := "camlCode__1"
                  temp/32[%edx] := "camlCode__1"
                  A/33[%ecx] := [temp/32[%edx] + -4]
                  I/34[%ecx] := I/34[%ecx] >>u 10
                  tmp/35[%ecx] := I/34[%ecx]  * 4 + -1
                  I/36[%edx] := unsigned int8[temp/32[%edx] + tmp/35[%ecx]]
                  I/37[%ecx] := I/37[%ecx] - I/36[%edx]
                  temp/38[%edx] := I/37[%ecx]  * 2 + 1
                  temp/39[%ecx] := 1
                  push temp/38[%edx]
                  push temp/39[%ecx]
                  push temp/31[%eax]
                  push oc/30[%ebx]
                  {spilled-iter/146[s4] spilled-y/147[s3]
                   spilled-bound/148[s2] spilled-bound/149[s1]
                   spilled-start_time/154[s0]*}
                  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
                  offset stack -16
                  temp/40[%eax] := "camlPervasives"
                  temp/41[%ebx] := [temp/40[%eax] + 92]
                  temp/42[%eax] := 21
                  push temp/42[%eax]
                  push temp/41[%ebx]
                  {spilled-iter/146[s4] spilled-y/147[s3]
                   spilled-bound/148[s2] spilled-bound/149[s1]
                   spilled-start_time/154[s0]*}
                  extcall "caml_ml_output_char"  (noalloc) {pervasives.ml:363,26-49}
                  offset stack -8
                  temp/43[%eax] := "camlPervasives"
                  temp/44[%eax] := [temp/43[%eax] + 92]
                  push temp/44[%eax]
                  {spilled-iter/146[s4] spilled-y/147[s3]
                   spilled-bound/148[s2] spilled-bound/149[s1]
                   spilled-start_time/154[s0]*}
                  extcall "caml_ml_flush"  (noalloc) {pervasives.ml:363,51-63}
                  offset stack -4
                  L136 [0]:
                  temp/45[%ebx] := -77
                  temp/46[%eax] := 77
                  spilled-x/145[s5] := x/47[%ebx] (spill)
                  spilled-bound/144[s6] := bound/48[%eax] (spill)
                  if x/47[%ebx] >s bound/48[%eax] goto L131
                  L132 [0]:
                  I/49[%ebx] := I/49[%ebx] >>s 1
                  R/7[%tos] := floatofint I/49[%ebx]
                  temp/51[s1] := R/7[%tos]
                  R/7[%tos] := 40.0
                  temp/53[s0] := R/7[%tos]
                  R/7[%tos] := temp/51[s1] /f temp/53[s0]
                  temp/55[s2] := R/7[%tos]
                  y/156[%eax] := spilled-y/147[s3] (reload)
                  I/56[%eax] := I/56[%eax] >>s 1
                  R/7[%tos] := floatofint I/56[%eax]
                  temp/58[s1] := R/7[%tos]
                  R/7[%tos] := 40.0
                  temp/60[s0] := R/7[%tos]
                  R/7[%tos] := temp/58[s1] /f temp/60[s0]
                  temp/62[s1] := R/7[%tos]
                  R/7[%tos] := 0.5
                  temp/64[s0] := R/7[%tos]
                  R/7[%tos] := temp/62[s1] -f temp/64[s0]
                  temp/66[s0] := R/7[%tos]
                  {temp/55[s2] temp/66[s0] spilled-bound/144[s6]
                   spilled-x/145[s5] spilled-iter/146[s4] spilled-y/147[s3]
                   spilled-bound/148[s2] spilled-bound/149[s1]
                   spilled-start_time/154[s0]*}
                  A/67[%ebx] := alloc 24
                  [A/67[%ebx] + -4] := 2301
                  float64u[A/67[%ebx]] := temp/66[s0]
                  A/68[%eax] := A/67[%ebx] + 12
                  [A/68[%eax] + -4] := 2301
                  float64u[A/68[%eax]] := temp/55[s2]
                  {spilled-bound/144[s6] spilled-x/145[s5]
                   spilled-iter/146[s4] spilled-y/147[s3]
                   spilled-bound/148[s2] spilled-bound/149[s1]
                   spilled-start_time/154[s0]*}
                  R/0[%eax] := call "camlCode__iterate_1033" R/0[%eax] R/1[%ebx]
                  i/69[%ecx] := R/0[%eax]
                  temp/70[%ebx] := 3
                  iter/157[%eax] := spilled-iter/146[s4] (reload)
                  I/71[%eax] := temp/70[%ebx] ==s iter/157[%eax]
                  temp/72[%eax] := I/71[%eax]  * 2 + 1
                  if temp/72[%eax] ==s 1 goto L133
                  temp/73[%eax] := 1
                  I/74[%eax] := temp/73[%eax] ==s i/69[%ecx]
                  temp/75[%eax] := I/74[%eax]  * 2 + 1
                  if temp/75[%eax] ==s 1 goto L135
                  s/76[%eax] := "camlCode__2"
                  goto L134
                  L135 [0]:
                  A/77[%eax] := "camlCode__3"
                  L134 [0]:
                  temp/78[%ebx] := "camlPervasives"
                  oc/79[%ebx] := [temp/78[%ebx] + 92]
                  A/80[%ecx] := [s/76[%eax] + -4]
                  I/81[%ecx] := I/81[%ecx] >>u 10
                  tmp/82[%ecx] := I/81[%ecx]  * 4 + -1
                  I/83[%edx] := unsigned int8[s/76[%eax] + tmp/82[%ecx]]
                  I/84[%ecx] := I/84[%ecx] - I/83[%edx]
                  temp/85[%edx] := I/84[%ecx]  * 2 + 1
                  temp/86[%ecx] := 1
                  push temp/85[%edx]
                  push temp/86[%ecx]
                  push s/76[%eax]
                  push oc/79[%ebx]
                  {spilled-bound/144[s6] spilled-x/145[s5]
                   spilled-iter/146[s4] spilled-y/147[s3]
                   spilled-bound/148[s2] spilled-bound/149[s1]
                   spilled-start_time/154[s0]*}
                  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
                  offset stack -16
                  L133 [0]:
                  x/47[%ebx] := spilled-x/145[s5] (reload)
                  x/87[%ecx] := x/47[%ebx]
                  I/88[%ebx] := I/88[%ebx] + 2
                  spilled-x/145[s5] := x/47[%ebx] (spill)
                  bound/159[%eax] := spilled-bound/144[s6] (reload)
                  if x/87[%ecx] !=s bound/159[%eax] goto L132
                  L131 [0]:
                  y/160[%eax] := spilled-y/147[s3] (reload)
                  y/89[%ebx] := y/160[%eax]
                  I/90[%eax] := I/90[%eax] + 2
                  spilled-y/147[s3] := y/160[%eax] (spill)
                  bound/161[%eax] := spilled-bound/148[s2] (reload)
                  if y/89[%ebx] !=s bound/161[%eax] goto L130
                  L129 [0]:
                  iter/162[%eax] := spilled-iter/146[s4] (reload)
                  iter/91[%ebx] := iter/162[%eax]
                  I/92[%eax] := I/92[%eax] + 2
                  spilled-iter/146[s4] := iter/162[%eax] (spill)
                  bound/163[%eax] := spilled-bound/149[s1] (reload)
                  if iter/91[%ebx] !=s bound/163[%eax] goto L128
                  L127 [0]:
                  temp/93[%eax] := "camlPervasives"
                  oc/94[%ebx] := [temp/93[%eax] + 92]
                  temp/95[%eax] := "camlCode__4"
                  temp/96[%edx] := "camlCode__4"
                  A/97[%ecx] := [temp/96[%edx] + -4]
                  I/98[%ecx] := I/98[%ecx] >>u 10
                  tmp/99[%ecx] := I/98[%ecx]  * 4 + -1
                  I/100[%edx] := unsigned int8[temp/96[%edx] + tmp/99[%ecx]]
                  I/101[%ecx] := I/101[%ecx] - I/100[%edx]
                  temp/102[%edx] := I/101[%ecx]  * 2 + 1
                  temp/103[%ecx] := 1
                  push temp/102[%edx]
                  push temp/103[%ecx]
                  push temp/95[%eax]
                  push oc/94[%ebx]
                  {spilled-start_time/154[s0]*}
                  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
                  offset stack -16
                  temp/104[%eax] := "camlPervasives"
                  temp/105[%ebx] := [temp/104[%eax] + 92]
                  temp/106[%eax] := 21
                  push temp/106[%eax]
                  push temp/105[%ebx]
                  {spilled-start_time/154[s0]*}
                  extcall "caml_ml_output_char"  (noalloc) {pervasives.ml:363,26-49}
                  offset stack -8
                  temp/107[%eax] := "camlPervasives"
                  temp/108[%eax] := [temp/107[%eax] + 92]
                  push temp/108[%eax]
                  {spilled-start_time/154[s0]*}
                  extcall "caml_ml_flush"  (noalloc) {pervasives.ml:363,51-63}
                  offset stack -4
                  temp/109[%eax] := 1
                  push temp/109[%eax]
                  {spilled-start_time/154[s0]*}
                  R/0[%eax] := extcall "caml_sys_time"  (noalloc)
                  offset stack -4
                  R/7[%tos] := float64u[temp/110[%eax]]
                  start_time/164[%eax] := spilled-start_time/154[s0] (reload)
                  R/7[%tos] := R/7[%tos] -f float64[start_time/164[%eax]]
                  f/113[s0] := R/7[%tos]
                  temp/114[%ebx] := "camlPervasives__11"
                  {f/113[s0] temp/114[%ebx]*}
                  A/115[%eax] := alloc 12
                  [A/115[%eax] + -4] := 2301
                  float64u[A/115[%eax]] := f/113[s0]
                  push A/115[%eax]
                  push temp/114[%ebx]
                  {}
                  R/0[%eax] := extcall "caml_format_float"  (noalloc) {pervasives.ml:198,42-66}
                  offset stack -8
                  {}
                  R/0[%eax] := call "camlPervasives__valid_float_lexem_1136" R/0[%eax] {pervasives.ml:361,41-60}
                  temp/118[%ebx] := "camlPervasives"
                  oc/119[%ebx] := [temp/118[%ebx] + 92]
                  A/120[%ecx] := [s/117[%eax] + -4]
                  I/121[%ecx] := I/121[%ecx] >>u 10
                  tmp/122[%ecx] := I/121[%ecx]  * 4 + -1
                  I/123[%edx] := unsigned int8[s/117[%eax] + tmp/122[%ecx]]
                  I/124[%ecx] := I/124[%ecx] - I/123[%edx]
                  temp/125[%edx] := I/124[%ecx]  * 2 + 1
                  temp/126[%ecx] := 1
                  push temp/125[%edx]
                  push temp/126[%ecx]
                  push s/117[%eax]
                  push oc/119[%ebx]
                  {}
                  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
                  offset stack -16
                  temp/127[%eax] := "camlPervasives"
                  oc/128[%ebx] := [temp/127[%eax] + 92]
                  temp/129[%eax] := "camlCode__5"
                  temp/130[%edx] := "camlCode__5"
                  A/131[%ecx] := [temp/130[%edx] + -4]
                  I/132[%ecx] := I/132[%ecx] >>u 10
                  tmp/133[%ecx] := I/132[%ecx]  * 4 + -1
                  I/134[%edx] := unsigned int8[temp/130[%edx] + tmp/133[%ecx]]
                  I/135[%ecx] := I/135[%ecx] - I/134[%edx]
                  temp/136[%edx] := I/135[%ecx]  * 2 + 1
                  temp/137[%ecx] := 1
                  push temp/136[%edx]
                  push temp/137[%ecx]
                  push temp/129[%eax]
                  push oc/128[%ebx]
                  {}
                  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
                  offset stack -16
                  temp/138[%eax] := "camlPervasives"
                  temp/139[%ebx] := [temp/138[%eax] + 92]
                  temp/140[%eax] := 21
                  push temp/140[%eax]
                  push temp/139[%ebx]
                  {}
                  extcall "caml_ml_output_char"  (noalloc) {pervasives.ml:363,26-49}
                  offset stack -8
                  temp/141[%eax] := "camlPervasives"
                  temp/142[%eax] := [temp/141[%eax] + 92]
                  push temp/142[%eax]
                  {}
                  extcall "caml_ml_flush"  (noalloc) {pervasives.ml:363,51-63}
                  offset stack -4
                  A/143[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  temp/8[%ebx] := "camlCode"
  temp/9[%eax] := 201
  [temp/8[%ebx]] := temp/9[%eax]
  temp/10[%ebx] := "camlCode"
  temp/11[%eax] := 2001
  [temp/10[%ebx] + 4] := temp/11[%eax]
  iterate/12[%ebx] := "camlCode__7"
  temp/13[%eax] := "camlCode"
  [temp/13[%eax] + 8] := iterate/12[%ebx]
  mandelbrot/14[%ebx] := "camlCode__6"
  temp/15[%eax] := "camlCode"
  [temp/15[%eax] + 12] := mandelbrot/14[%ebx]
  temp/16[%eax] := 1
  push temp/16[%eax]
  {}
  R/0[%eax] := extcall "caml_sys_time"  (noalloc)
  offset stack -4
  spilled-start_time/154[s0] := start_time/17[%eax] (spill)
  temp/18[%ebx] := 3
  temp/19[%eax] := 201
  if iter/20[%ebx] >s bound/21[%eax] goto L127
  spilled-bound/149[s1] := bound/21[%eax] (spill)
  spilled-iter/146[s4] := iter/20[%ebx] (spill)
  L128 [4]:
  temp/22[%ebx] := -77
  temp/23[%eax] := 77
  spilled-y/147[s3] := y/24[%ebx] (spill)
  spilled-bound/148[s2] := bound/25[%eax] (spill)
  if y/24[%ebx] >s bound/25[%eax] goto L129
  L130 [4]:
  temp/26[%ebx] := 3
  iter/155[%eax] := spilled-iter/146[s4] (reload)
  I/27[%eax] := temp/26[%ebx] ==s iter/155[%eax]
  temp/28[%eax] := I/27[%eax]  * 2 + 1
  if temp/28[%eax] ==s 1 goto L136
  temp/29[%eax] := "camlPervasives"
  oc/30[%ebx] := [temp/29[%eax] + 92]
  temp/31[%eax] := "camlCode__1"
  temp/32[%edx] := "camlCode__1"
  A/33[%ecx] := [temp/32[%edx] + -4]
  I/34[%ecx] := I/34[%ecx] >>u 10
  tmp/35[%ecx] := I/34[%ecx]  * 4 + -1
  I/36[%edx] := unsigned int8[temp/32[%edx] + tmp/35[%ecx]]
  I/37[%ecx] := I/37[%ecx] - I/36[%edx]
  temp/38[%edx] := I/37[%ecx]  * 2 + 1
  temp/39[%ecx] := 1
  push temp/38[%edx]
  push temp/39[%ecx]
  push temp/31[%eax]
  push oc/30[%ebx]
  {spilled-iter/146[s4] spilled-y/147[s3] spilled-bound/148[s2]
   spilled-bound/149[s1] spilled-start_time/154[s0]*}
  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
  offset stack -16
  temp/40[%eax] := "camlPervasives"
  temp/41[%ebx] := [temp/40[%eax] + 92]
  temp/42[%eax] := 21
  push temp/42[%eax]
  push temp/41[%ebx]
  {spilled-iter/146[s4] spilled-y/147[s3] spilled-bound/148[s2]
   spilled-bound/149[s1] spilled-start_time/154[s0]*}
  extcall "caml_ml_output_char"  (noalloc) {pervasives.ml:363,26-49}
  offset stack -8
  temp/43[%eax] := "camlPervasives"
  temp/44[%eax] := [temp/43[%eax] + 92]
  push temp/44[%eax]
  {spilled-iter/146[s4] spilled-y/147[s3] spilled-bound/148[s2]
   spilled-bound/149[s1] spilled-start_time/154[s0]*}
  extcall "caml_ml_flush"  (noalloc) {pervasives.ml:363,51-63}
  offset stack -4
  L136 [4]:
  temp/45[%ebx] := -77
  temp/46[%eax] := 77
  spilled-x/145[s5] := x/47[%ebx] (spill)
  spilled-bound/144[s6] := bound/48[%eax] (spill)
  if x/47[%ebx] >s bound/48[%eax] goto L131
  L132 [4]:
  I/49[%ebx] := I/49[%ebx] >>s 1
  R/7[%tos] := floatofint I/49[%ebx]
  temp/51[s1] := R/7[%tos]
  R/7[%tos] := 40.0
  temp/53[s0] := R/7[%tos]
  R/7[%tos] := temp/51[s1] /f temp/53[s0]
  temp/55[s2] := R/7[%tos]
  y/156[%eax] := spilled-y/147[s3] (reload)
  I/56[%eax] := I/56[%eax] >>s 1
  R/7[%tos] := floatofint I/56[%eax]
  temp/58[s1] := R/7[%tos]
  R/7[%tos] := 40.0
  temp/60[s0] := R/7[%tos]
  R/7[%tos] := temp/58[s1] /f temp/60[s0]
  temp/62[s1] := R/7[%tos]
  R/7[%tos] := 0.5
  temp/64[s0] := R/7[%tos]
  R/7[%tos] := temp/62[s1] -f temp/64[s0]
  temp/66[s0] := R/7[%tos]
  {temp/55[s2] temp/66[s0] spilled-bound/144[s6] spilled-x/145[s5]
   spilled-iter/146[s4] spilled-y/147[s3] spilled-bound/148[s2]
   spilled-bound/149[s1] spilled-start_time/154[s0]*}
  A/67[%ebx] := alloc 24
  [A/67[%ebx] + -4] := 2301
  float64u[A/67[%ebx]] := temp/66[s0]
  A/68[%eax] := A/67[%ebx] + 12
  [A/68[%eax] + -4] := 2301
  float64u[A/68[%eax]] := temp/55[s2]
  {spilled-bound/144[s6] spilled-x/145[s5] spilled-iter/146[s4]
   spilled-y/147[s3] spilled-bound/148[s2] spilled-bound/149[s1]
   spilled-start_time/154[s0]*}
  R/0[%eax] := call "camlCode__iterate_1033" R/0[%eax] R/1[%ebx]
  i/69[%ecx] := R/0[%eax]
  temp/70[%ebx] := 3
  iter/157[%eax] := spilled-iter/146[s4] (reload)
  I/71[%eax] := temp/70[%ebx] ==s iter/157[%eax]
  temp/72[%eax] := I/71[%eax]  * 2 + 1
  if temp/72[%eax] ==s 1 goto L133
  temp/73[%eax] := 1
  I/74[%eax] := temp/73[%eax] ==s i/69[%ecx]
  temp/75[%eax] := I/74[%eax]  * 2 + 1
  if temp/75[%eax] ==s 1 goto L135
  s/76[%eax] := "camlCode__2"
  goto L134
  L135 [2]:
  A/77[%eax] := "camlCode__3"
  L134 [3]:
  temp/78[%ebx] := "camlPervasives"
  oc/79[%ebx] := [temp/78[%ebx] + 92]
  A/80[%ecx] := [s/76[%eax] + -4]
  I/81[%ecx] := I/81[%ecx] >>u 10
  tmp/82[%ecx] := I/81[%ecx]  * 4 + -1
  I/83[%edx] := unsigned int8[s/76[%eax] + tmp/82[%ecx]]
  I/84[%ecx] := I/84[%ecx] - I/83[%edx]
  temp/85[%edx] := I/84[%ecx]  * 2 + 1
  temp/86[%ecx] := 1
  push temp/85[%edx]
  push temp/86[%ecx]
  push s/76[%eax]
  push oc/79[%ebx]
  {spilled-bound/144[s6] spilled-x/145[s5] spilled-iter/146[s4]
   spilled-y/147[s3] spilled-bound/148[s2] spilled-bound/149[s1]
   spilled-start_time/154[s0]*}
  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
  offset stack -16
  L133 [4]:
  x/47[%ebx] := spilled-x/145[s5] (reload)
  x/87[%ecx] := x/47[%ebx]
  I/88[%ebx] := I/88[%ebx] + 2
  spilled-x/145[s5] := x/47[%ebx] (spill)
  bound/159[%eax] := spilled-bound/144[s6] (reload)
  if x/87[%ecx] !=s bound/159[%eax] goto L132
  L131 [4]:
  y/160[%eax] := spilled-y/147[s3] (reload)
  y/89[%ebx] := y/160[%eax]
  I/90[%eax] := I/90[%eax] + 2
  spilled-y/147[s3] := y/160[%eax] (spill)
  bound/161[%eax] := spilled-bound/148[s2] (reload)
  if y/89[%ebx] !=s bound/161[%eax] goto L130
  L129 [4]:
  iter/162[%eax] := spilled-iter/146[s4] (reload)
  iter/91[%ebx] := iter/162[%eax]
  I/92[%eax] := I/92[%eax] + 2
  spilled-iter/146[s4] := iter/162[%eax] (spill)
  bound/163[%eax] := spilled-bound/149[s1] (reload)
  if iter/91[%ebx] !=s bound/163[%eax] goto L128
  L127 [4]:
  temp/93[%eax] := "camlPervasives"
  oc/94[%ebx] := [temp/93[%eax] + 92]
  temp/95[%eax] := "camlCode__4"
  temp/96[%edx] := "camlCode__4"
  A/97[%ecx] := [temp/96[%edx] + -4]
  I/98[%ecx] := I/98[%ecx] >>u 10
  tmp/99[%ecx] := I/98[%ecx]  * 4 + -1
  I/100[%edx] := unsigned int8[temp/96[%edx] + tmp/99[%ecx]]
  I/101[%ecx] := I/101[%ecx] - I/100[%edx]
  temp/102[%edx] := I/101[%ecx]  * 2 + 1
  temp/103[%ecx] := 1
  push temp/102[%edx]
  push temp/103[%ecx]
  push temp/95[%eax]
  push oc/94[%ebx]
  {spilled-start_time/154[s0]*}
  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
  offset stack -16
  temp/104[%eax] := "camlPervasives"
  temp/105[%ebx] := [temp/104[%eax] + 92]
  temp/106[%eax] := 21
  push temp/106[%eax]
  push temp/105[%ebx]
  {spilled-start_time/154[s0]*}
  extcall "caml_ml_output_char"  (noalloc) {pervasives.ml:363,26-49}
  offset stack -8
  temp/107[%eax] := "camlPervasives"
  temp/108[%eax] := [temp/107[%eax] + 92]
  push temp/108[%eax]
  {spilled-start_time/154[s0]*}
  extcall "caml_ml_flush"  (noalloc) {pervasives.ml:363,51-63}
  offset stack -4
  temp/109[%eax] := 1
  push temp/109[%eax]
  {spilled-start_time/154[s0]*}
  R/0[%eax] := extcall "caml_sys_time"  (noalloc)
  offset stack -4
  R/7[%tos] := float64u[temp/110[%eax]]
  start_time/164[%eax] := spilled-start_time/154[s0] (reload)
  R/7[%tos] := R/7[%tos] -f float64[start_time/164[%eax]]
  f/113[s0] := R/7[%tos]
  temp/114[%ebx] := "camlPervasives__11"
  {f/113[s0] temp/114[%ebx]*}
  A/115[%eax] := alloc 12
  [A/115[%eax] + -4] := 2301
  float64u[A/115[%eax]] := f/113[s0]
  push A/115[%eax]
  push temp/114[%ebx]
  {}
  R/0[%eax] := extcall "caml_format_float"  (noalloc) {pervasives.ml:198,42-66}
  offset stack -8
  {}
  R/0[%eax] := call "camlPervasives__valid_float_lexem_1136" R/0[%eax] {pervasives.ml:361,41-60}
  temp/118[%ebx] := "camlPervasives"
  oc/119[%ebx] := [temp/118[%ebx] + 92]
  A/120[%ecx] := [s/117[%eax] + -4]
  I/121[%ecx] := I/121[%ecx] >>u 10
  tmp/122[%ecx] := I/121[%ecx]  * 4 + -1
  I/123[%edx] := unsigned int8[s/117[%eax] + tmp/122[%ecx]]
  I/124[%ecx] := I/124[%ecx] - I/123[%edx]
  temp/125[%edx] := I/124[%ecx]  * 2 + 1
  temp/126[%ecx] := 1
  push temp/125[%edx]
  push temp/126[%ecx]
  push s/117[%eax]
  push oc/119[%ebx]
  {}
  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
  offset stack -16
  temp/127[%eax] := "camlPervasives"
  oc/128[%ebx] := [temp/127[%eax] + 92]
  temp/129[%eax] := "camlCode__5"
  temp/130[%edx] := "camlCode__5"
  A/131[%ecx] := [temp/130[%edx] + -4]
  I/132[%ecx] := I/132[%ecx] >>u 10
  tmp/133[%ecx] := I/132[%ecx]  * 4 + -1
  I/134[%edx] := unsigned int8[temp/130[%edx] + tmp/133[%ecx]]
  I/135[%ecx] := I/135[%ecx] - I/134[%edx]
  temp/136[%edx] := I/135[%ecx]  * 2 + 1
  temp/137[%ecx] := 1
  push temp/136[%edx]
  push temp/137[%ecx]
  push temp/129[%eax]
  push oc/128[%ebx]
  {}
  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
  offset stack -16
  temp/138[%eax] := "camlPervasives"
  temp/139[%ebx] := [temp/138[%eax] + 92]
  temp/140[%eax] := 21
  push temp/140[%eax]
  push temp/139[%ebx]
  {}
  extcall "caml_ml_output_char"  (noalloc) {pervasives.ml:363,26-49}
  offset stack -8
  temp/141[%eax] := "camlPervasives"
  temp/142[%eax] := [temp/141[%eax] + 92]
  push temp/142[%eax]
  {}
  extcall "caml_ml_flush"  (noalloc) {pervasives.ml:363,51-63}
  offset stack -4
  A/143[%eax] := 1
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
	.long	4096
	.globl	camlCode
camlCode:
	.space	16
	.data
	.long	2295
camlCode__6:
	.long	camlCode__mandelbrot_1044
	.long	3
	.data
	.long	3319
camlCode__7:
	.long	caml_curry2
	.long	5
	.long	camlCode__iterate_1033
	.data
	.globl	camlCode__1
	.long	1276
camlCode__1:
	.space	3
	.byte	3
	.data
	.globl	camlCode__2
	.long	1276
camlCode__2:
	.ascii	"*"
	.space	2
	.byte	2
	.data
	.globl	camlCode__3
	.long	1276
camlCode__3:
	.ascii	" "
	.space	2
	.byte	2
	.data
	.globl	camlCode__4
	.long	1276
camlCode__4:
	.space	3
	.byte	3
	.data
	.globl	camlCode__5
	.long	1276
camlCode__5:
	.space	3
	.byte	3
	.text
	.align	16
	.globl	camlCode__iterate_1033
camlCode__iterate_1033:
	subl	$40, %esp
.L105:
	movl	%eax, %edx
	fldl	.L106
	fstpl	32(%esp)
	movl	$3, %ecx
	fldz
	fstpl	0(%esp)
	fldz
	fstpl	16(%esp)
.L101:
	movl	$2001, %eax
	cmpl	%eax, %ecx
	setg	%al
	movzbl	%al, %eax
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L104
	movl	$1, %ecx
	jmp	.L100
	.align	16
.L104:
	fldl	0(%esp)
	fmull	16(%esp)
	fstpl	8(%esp)
	fldl	0(%esp)
	fmull	0(%esp)
	fstpl	24(%esp)
	fldl	16(%esp)
	fmull	16(%esp)
	fstpl	16(%esp)
	fldl	16(%esp)
	faddl	24(%esp)
	fstpl	0(%esp)
	fldl	0(%esp)
	fcompl	32(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L103
	movl	$1, %eax
	jmp	.L102
	.align	16
.L103:
	xorl	%eax, %eax
.L102:
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	jne	.L100
	fldl	8(%esp)
	faddl	8(%esp)
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%edx)
	fstpl	8(%esp)
	fldl	24(%esp)
	fsubl	16(%esp)
	fstpl	0(%esp)
	fldl	0(%esp)
	faddl	(%ebx)
	fstpl	0(%esp)
	movl	$3, %eax
	lea	-1(%ecx, %eax), %ecx
	fldl	8(%esp)
	fstpl	16(%esp)
	jmp	.L101
	.align	16
.L100:
	movl	%ecx, %eax
	addl	$40, %esp
	ret
	.data
.L106:	.long	0x0, 0x40100000
	.type	camlCode__iterate_1033,@function
	.size	camlCode__iterate_1033,.-camlCode__iterate_1033
	.text
	.align	16
	.globl	camlCode__mandelbrot_1044
camlCode__mandelbrot_1044:
	subl	$44, %esp
.L115:
	movl	$-77, %ecx
	movl	$77, %ebx
	cmpl	%ebx, %ecx
	jg	.L107
	movl	%ebx, 0(%esp)
	movl	%ecx, 4(%esp)
	movl	%eax, 8(%esp)
.L108:
	movl	$3, %ebx
	movl	8(%esp), %eax
	cmpl	%eax, %ebx
	sete	%al
	movzbl	%al, %eax
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L114
	movl	$camlPervasives, %eax
	movl	92(%eax), %ebx
	movl	$camlCode__1, %eax
	movl	$camlCode__1, %edx
	movl	-4(%edx), %ecx
	shrl	$10, %ecx
	lea	-1(, %ecx, 4), %ecx
	movzbl	(%edx, %ecx), %edx
	subl	%edx, %ecx
	lea	1(%ecx, %ecx), %edx
	movl	$1, %ecx
	pushl	%edx
	pushl	%ecx
	pushl	%eax
	pushl	%ebx
	movl	$caml_ml_output, %eax
	call	caml_c_call
.L116:
	addl	$16, %esp
	movl	$camlPervasives, %eax
	movl	92(%eax), %ebx
	movl	$21, %eax
	pushl	%eax
	pushl	%ebx
	movl	$caml_ml_output_char, %eax
	call	caml_c_call
.L117:
	addl	$8, %esp
	movl	$camlPervasives, %eax
	movl	92(%eax), %eax
	pushl	%eax
	movl	$caml_ml_flush, %eax
	call	caml_c_call
.L118:
	addl	$4, %esp
.L114:
	movl	$-77, %ebx
	movl	$77, %eax
	movl	%ebx, 12(%esp)
	movl	%eax, 16(%esp)
	cmpl	%eax, %ebx
	jg	.L109
.L110:
	sarl	$1, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	fstpl	28(%esp)
	fldl	.L119
	fstpl	20(%esp)
	fldl	28(%esp)
	fdivl	20(%esp)
	fstpl	36(%esp)
	movl	4(%esp), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	28(%esp)
	fldl	.L120
	fstpl	20(%esp)
	fldl	28(%esp)
	fdivl	20(%esp)
	fstpl	28(%esp)
	fldl	.L121
	fstpl	20(%esp)
	fldl	28(%esp)
	fsubl	20(%esp)
	fstpl	20(%esp)
.L122:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L123
	leal	4(%eax), %ebx
	movl	$2301, -4(%ebx)
	fldl	20(%esp)
	fstpl	(%ebx)
	leal	12(%ebx), %eax
	movl	$2301, -4(%eax)
	fldl	36(%esp)
	fstpl	(%eax)
	call	camlCode__iterate_1033
.L125:
	movl	%eax, %ecx
	movl	$3, %ebx
	movl	8(%esp), %eax
	cmpl	%eax, %ebx
	sete	%al
	movzbl	%al, %eax
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L111
	movl	$1, %eax
	cmpl	%ecx, %eax
	sete	%al
	movzbl	%al, %eax
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L113
	movl	$camlCode__2, %eax
	jmp	.L112
	.align	16
.L113:
	movl	$camlCode__3, %eax
.L112:
	movl	$camlPervasives, %ebx
	movl	92(%ebx), %ebx
	movl	-4(%eax), %ecx
	shrl	$10, %ecx
	lea	-1(, %ecx, 4), %ecx
	movzbl	(%eax, %ecx), %edx
	subl	%edx, %ecx
	lea	1(%ecx, %ecx), %edx
	movl	$1, %ecx
	pushl	%edx
	pushl	%ecx
	pushl	%eax
	pushl	%ebx
	movl	$caml_ml_output, %eax
	call	caml_c_call
.L126:
	addl	$16, %esp
.L111:
	movl	12(%esp), %ebx
	movl	%ebx, %ecx
	addl	$2, %ebx
	movl	%ebx, 12(%esp)
	movl	16(%esp), %eax
	cmpl	%eax, %ecx
	jne	.L110
.L109:
	movl	4(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 4(%esp)
	movl	0(%esp), %eax
	cmpl	%eax, %ebx
	jne	.L108
.L107:
	movl	$1, %eax
	addl	$44, %esp
	ret
.L123:	call	caml_call_gc
.L124:	jmp	.L122
	.data
.L121:	.long	0x0, 0x3fe00000
	.data
.L120:	.long	0x0, 0x40440000
	.data
.L119:	.long	0x0, 0x40440000
	.type	camlCode__mandelbrot_1044,@function
	.size	camlCode__mandelbrot_1044,.-camlCode__mandelbrot_1044
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$52, %esp
.L137:
	movl	$camlCode, %ebx
	movl	$201, %eax
	movl	%eax, (%ebx)
	movl	$camlCode, %ebx
	movl	$2001, %eax
	movl	%eax, 4(%ebx)
	movl	$camlCode__7, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 8(%eax)
	movl	$camlCode__6, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 12(%eax)
	movl	$1, %eax
	pushl	%eax
	movl	$caml_sys_time, %eax
	call	caml_c_call
.L138:
	addl	$4, %esp
	movl	%eax, 0(%esp)
	movl	$3, %ebx
	movl	$201, %eax
	cmpl	%eax, %ebx
	jg	.L127
	movl	%eax, 4(%esp)
	movl	%ebx, 16(%esp)
.L128:
	movl	$-77, %ebx
	movl	$77, %eax
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	cmpl	%eax, %ebx
	jg	.L129
.L130:
	movl	$3, %ebx
	movl	16(%esp), %eax
	cmpl	%eax, %ebx
	sete	%al
	movzbl	%al, %eax
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L136
	movl	$camlPervasives, %eax
	movl	92(%eax), %ebx
	movl	$camlCode__1, %eax
	movl	$camlCode__1, %edx
	movl	-4(%edx), %ecx
	shrl	$10, %ecx
	lea	-1(, %ecx, 4), %ecx
	movzbl	(%edx, %ecx), %edx
	subl	%edx, %ecx
	lea	1(%ecx, %ecx), %edx
	movl	$1, %ecx
	pushl	%edx
	pushl	%ecx
	pushl	%eax
	pushl	%ebx
	movl	$caml_ml_output, %eax
	call	caml_c_call
.L139:
	addl	$16, %esp
	movl	$camlPervasives, %eax
	movl	92(%eax), %ebx
	movl	$21, %eax
	pushl	%eax
	pushl	%ebx
	movl	$caml_ml_output_char, %eax
	call	caml_c_call
.L140:
	addl	$8, %esp
	movl	$camlPervasives, %eax
	movl	92(%eax), %eax
	pushl	%eax
	movl	$caml_ml_flush, %eax
	call	caml_c_call
.L141:
	addl	$4, %esp
.L136:
	movl	$-77, %ebx
	movl	$77, %eax
	movl	%ebx, 20(%esp)
	movl	%eax, 24(%esp)
	cmpl	%eax, %ebx
	jg	.L131
.L132:
	sarl	$1, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	fstpl	36(%esp)
	fldl	.L142
	fstpl	28(%esp)
	fldl	36(%esp)
	fdivl	28(%esp)
	fstpl	44(%esp)
	movl	12(%esp), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	36(%esp)
	fldl	.L143
	fstpl	28(%esp)
	fldl	36(%esp)
	fdivl	28(%esp)
	fstpl	36(%esp)
	fldl	.L144
	fstpl	28(%esp)
	fldl	36(%esp)
	fsubl	28(%esp)
	fstpl	28(%esp)
.L145:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L146
	leal	4(%eax), %ebx
	movl	$2301, -4(%ebx)
	fldl	28(%esp)
	fstpl	(%ebx)
	leal	12(%ebx), %eax
	movl	$2301, -4(%eax)
	fldl	44(%esp)
	fstpl	(%eax)
	call	camlCode__iterate_1033
.L148:
	movl	%eax, %ecx
	movl	$3, %ebx
	movl	16(%esp), %eax
	cmpl	%eax, %ebx
	sete	%al
	movzbl	%al, %eax
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L133
	movl	$1, %eax
	cmpl	%ecx, %eax
	sete	%al
	movzbl	%al, %eax
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L135
	movl	$camlCode__2, %eax
	jmp	.L134
	.align	16
.L135:
	movl	$camlCode__3, %eax
.L134:
	movl	$camlPervasives, %ebx
	movl	92(%ebx), %ebx
	movl	-4(%eax), %ecx
	shrl	$10, %ecx
	lea	-1(, %ecx, 4), %ecx
	movzbl	(%eax, %ecx), %edx
	subl	%edx, %ecx
	lea	1(%ecx, %ecx), %edx
	movl	$1, %ecx
	pushl	%edx
	pushl	%ecx
	pushl	%eax
	pushl	%ebx
	movl	$caml_ml_output, %eax
	call	caml_c_call
.L149:
	addl	$16, %esp
.L133:
	movl	20(%esp), %ebx
	movl	%ebx, %ecx
	addl	$2, %ebx
	movl	%ebx, 20(%esp)
	movl	24(%esp), %eax
	cmpl	%eax, %ecx
	jne	.L132
.L131:
	movl	12(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 12(%esp)
	movl	8(%esp), %eax
	cmpl	%eax, %ebx
	jne	.L130
.L129:
	movl	16(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 16(%esp)
	movl	4(%esp), %eax
	cmpl	%eax, %ebx
	jne	.L128
.L127:
	movl	$camlPervasives, %eax
	movl	92(%eax), %ebx
	movl	$camlCode__4, %eax
	movl	$camlCode__4, %edx
	movl	-4(%edx), %ecx
	shrl	$10, %ecx
	lea	-1(, %ecx, 4), %ecx
	movzbl	(%edx, %ecx), %edx
	subl	%edx, %ecx
	lea	1(%ecx, %ecx), %edx
	movl	$1, %ecx
	pushl	%edx
	pushl	%ecx
	pushl	%eax
	pushl	%ebx
	movl	$caml_ml_output, %eax
	call	caml_c_call
.L150:
	addl	$16, %esp
	movl	$camlPervasives, %eax
	movl	92(%eax), %ebx
	movl	$21, %eax
	pushl	%eax
	pushl	%ebx
	movl	$caml_ml_output_char, %eax
	call	caml_c_call
.L151:
	addl	$8, %esp
	movl	$camlPervasives, %eax
	movl	92(%eax), %eax
	pushl	%eax
	movl	$caml_ml_flush, %eax
	call	caml_c_call
.L152:
	addl	$4, %esp
	movl	$1, %eax
	pushl	%eax
	movl	$caml_sys_time, %eax
	call	caml_c_call
.L153:
	addl	$4, %esp
	fldl	(%eax)
	movl	0(%esp), %eax
	fsubl	(%eax)
	fstpl	28(%esp)
	movl	$camlPervasives__11, %ebx
.L154:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L155
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	28(%esp)
	fstpl	(%eax)
	pushl	%eax
	pushl	%ebx
	movl	$caml_format_float, %eax
	call	caml_c_call
.L157:
	addl	$8, %esp
	call	camlPervasives__valid_float_lexem_1136
.L158:
	movl	$camlPervasives, %ebx
	movl	92(%ebx), %ebx
	movl	-4(%eax), %ecx
	shrl	$10, %ecx
	lea	-1(, %ecx, 4), %ecx
	movzbl	(%eax, %ecx), %edx
	subl	%edx, %ecx
	lea	1(%ecx, %ecx), %edx
	movl	$1, %ecx
	pushl	%edx
	pushl	%ecx
	pushl	%eax
	pushl	%ebx
	movl	$caml_ml_output, %eax
	call	caml_c_call
.L159:
	addl	$16, %esp
	movl	$camlPervasives, %eax
	movl	92(%eax), %ebx
	movl	$camlCode__5, %eax
	movl	$camlCode__5, %edx
	movl	-4(%edx), %ecx
	shrl	$10, %ecx
	lea	-1(, %ecx, 4), %ecx
	movzbl	(%edx, %ecx), %edx
	subl	%edx, %ecx
	lea	1(%ecx, %ecx), %edx
	movl	$1, %ecx
	pushl	%edx
	pushl	%ecx
	pushl	%eax
	pushl	%ebx
	movl	$caml_ml_output, %eax
	call	caml_c_call
.L160:
	addl	$16, %esp
	movl	$camlPervasives, %eax
	movl	92(%eax), %ebx
	movl	$21, %eax
	pushl	%eax
	pushl	%ebx
	movl	$caml_ml_output_char, %eax
	call	caml_c_call
.L161:
	addl	$8, %esp
	movl	$camlPervasives, %eax
	movl	92(%eax), %eax
	pushl	%eax
	movl	$caml_ml_flush, %eax
	call	caml_c_call
.L162:
	addl	$4, %esp
	movl	$1, %eax
	addl	$52, %esp
	ret
.L155:	call	caml_call_gc
.L156:	jmp	.L154
.L146:	call	caml_call_gc
.L147:	jmp	.L145
	.data
.L144:	.long	0x0, 0x3fe00000
	.data
.L143:	.long	0x0, 0x40440000
	.data
.L142:	.long	0x0, 0x40440000
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
	.long	24
	.long	.L162
	.word	61
	.word	0
	.align	4
	.long	.L200000 - . + 0xfc000000
	.long	0x16b330
	.long	.L161
	.word	65
	.word	0
	.align	4
	.long	.L200000 - . + 0xc4000000
	.long	0x16b1a0
	.long	.L160
	.word	73
	.word	0
	.align	4
	.long	.L200000 - . + 0xa0000000
	.long	0x100020
	.long	.L159
	.word	73
	.word	0
	.align	4
	.long	.L200000 - . + 0xa0000000
	.long	0x100020
	.long	.L158
	.word	57
	.word	0
	.align	4
	.long	.L200000 - . + 0xf0000000
	.long	0x169290
	.long	.L157
	.word	65
	.word	0
	.align	4
	.long	.L200000 - . + 0x8000000
	.long	0xc62a1
	.long	.L156
	.word	56
	.word	1
	.word	3
	.align	4
	.long	.L153
	.word	60
	.word	1
	.word	4
	.align	4
	.long	.L152
	.word	61
	.word	1
	.word	4
	.align	4
	.long	.L200000 - . + 0xfc000000
	.long	0x16b330
	.long	.L151
	.word	65
	.word	1
	.word	8
	.align	4
	.long	.L200000 - . + 0xc4000000
	.long	0x16b1a0
	.long	.L150
	.word	73
	.word	1
	.word	16
	.align	4
	.long	.L200000 - . + 0xa0000000
	.long	0x100020
	.long	.L149
	.word	73
	.word	1
	.word	16
	.align	4
	.long	.L200000 - . + 0xa0000000
	.long	0x100020
	.long	.L148
	.word	56
	.word	1
	.word	0
	.align	4
	.long	.L147
	.word	56
	.word	1
	.word	0
	.align	4
	.long	.L141
	.word	61
	.word	1
	.word	4
	.align	4
	.long	.L200000 - . + 0xfc000000
	.long	0x16b330
	.long	.L140
	.word	65
	.word	1
	.word	8
	.align	4
	.long	.L200000 - . + 0xc4000000
	.long	0x16b1a0
	.long	.L139
	.word	73
	.word	1
	.word	16
	.align	4
	.long	.L200000 - . + 0xa0000000
	.long	0x100020
	.long	.L138
	.word	60
	.word	0
	.align	4
	.long	.L126
	.word	65
	.word	1
	.word	24
	.align	4
	.long	.L200000 - . + 0xa0000000
	.long	0x100020
	.long	.L125
	.word	48
	.word	1
	.word	8
	.align	4
	.long	.L124
	.word	48
	.word	1
	.word	8
	.align	4
	.long	.L118
	.word	53
	.word	1
	.word	12
	.align	4
	.long	.L200000 - . + 0xfc000000
	.long	0x16b330
	.long	.L117
	.word	57
	.word	1
	.word	16
	.align	4
	.long	.L200000 - . + 0xc4000000
	.long	0x16b1a0
	.long	.L116
	.word	65
	.word	1
	.word	24
	.align	4
	.long	.L200000 - . + 0xa0000000
	.long	0x100020
.L200000:
	.ascii	"pervasives.ml\0"
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

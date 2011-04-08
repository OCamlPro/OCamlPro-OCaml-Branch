let zero = 0., 0., 0.
let ( *| ) s (rx, ry, rz) = s *. rx, s *. ry, s *. rz
let ( +| ) (ax, ay, az) (bx, by, bz) = ax +. bx, ay +. by, az +. bz
let ( -| ) (ax, ay, az) (bx, by, bz) = ax -. bx, ay -. by, az -. bz
let dot (ax, ay, az) (bx, by, bz) = ax *. bx +. ay *. by +. az *. bz
let unitise r = 1. /. sqrt (dot r r) *| r

let rec intersect o d (l, _ as hit) (c, r, s) =
  let v = c -| o in
  let b = dot v d in
  let disc = sqrt(b *. b -. dot v v +. r *. r) in
  let t1 = b -. disc and t2 = b +. disc in
  let l' = if t2>0. then if t1>0. then t1 else t2 else infinity in
  if l' >= l then hit else match s with
    [] -> l', unitise (o +| l' *| d -| c)
  | ss -> List.fold_left (intersect o d) hit ss

let light = unitise (1., 3., -2.) and ss = 4

let rec create level c r =
  let obj = c, r, [] in
  if level = 1 then obj else
    let a = 3. *. r /. sqrt 12. in
    let aux x' z' = create (level - 1) (c +| (x', a, z')) (0.5 *. r) in
    c, 3.*.r, [obj; aux (-.a) (-.a); aux a (-.a); aux (-.a) a; aux a a]

let level, n =
  try int_of_string Sys.argv.(1), int_of_string Sys.argv.(2) with _ -> 9, 512

let scene = create level (0., -1., 4.) 1.

let rec ray_trace dir =
  let l, n = intersect zero dir (infinity, zero) scene in
  let g = dot n light in
  if g <= 0. then 0. else
    let p = l *| dir +| sqrt epsilon_float *| n in
    if fst(intersect p light (infinity, zero) scene) < infinity then 0. else g

let aux x d = float x -. float n /. 2. +. float d /. float ss;;
Printf.printf "P5\n%d %d\n255\n%!" n n;
for y = n - 1 downto 0 do
  for x = 0 to n - 1 do
    let g = ref 0. in
    for d = 0 to ss*ss - 1 do
      g := !g +. ray_trace(unitise(aux x (d mod ss), aux y (d/ss), float n))
    done;
    let g = 0.5 +. 255. *. !g /. float(ss*ss) in
    print_char(char_of_int(int_of_float g))
  done;
done
(*
-drawlambda
(seq
  (let (zero/1031 [0: 0. 0. 0.]) (setfield_imm 0 (global Code!) zero/1031))
  (let
    (*|/1032
       (function s/1033 param/1118
         (let
           (rz/1036 (field 2 param/1118)
            ry/1035 (field 1 param/1118)
            rx/1034 (field 0 param/1118))
           (makeblock 0 (*. s/1033 rx/1034) (*. s/1033 ry/1035)
             (*. s/1033 rz/1036)))))
    (setfield_imm 1 (global Code!) *|/1032))
  (let
    (+|/1037
       (function param/1119 param/1120
         (let
           (bz/1043 (field 2 param/1120)
            by/1042 (field 1 param/1120)
            bx/1041 (field 0 param/1120)
            az/1040 (field 2 param/1119)
            ay/1039 (field 1 param/1119)
            ax/1038 (field 0 param/1119))
           (makeblock 0 (+. ax/1038 bx/1041) (+. ay/1039 by/1042)
             (+. az/1040 bz/1043)))))
    (setfield_imm 2 (global Code!) +|/1037))
  (let
    (-|/1044
       (function param/1121 param/1122
         (let
           (bz/1050 (field 2 param/1122)
            by/1049 (field 1 param/1122)
            bx/1048 (field 0 param/1122)
            az/1047 (field 2 param/1121)
            ay/1046 (field 1 param/1121)
            ax/1045 (field 0 param/1121))
           (makeblock 0 (-. ax/1045 bx/1048) (-. ay/1046 by/1049)
             (-. az/1047 bz/1050)))))
    (setfield_imm 3 (global Code!) -|/1044))
  (let
    (dot/1051
       (function param/1123 param/1124
         (let
           (bz/1057 (field 2 param/1124)
            by/1056 (field 1 param/1124)
            bx/1055 (field 0 param/1124)
            az/1054 (field 2 param/1123)
            ay/1053 (field 1 param/1123)
            ax/1052 (field 0 param/1123))
           (+. (+. (*. ax/1052 bx/1055) (*. ay/1053 by/1056))
             (*. az/1054 bz/1057)))))
    (setfield_imm 4 (global Code!) dot/1051))
  (let
    (unitise/1058
       (function r/1059
         (apply (field 1 (global Code!))
           (/. 1.
             (caml_sqrt_float (apply (field 4 (global Code!)) r/1059 r/1059)))
           r/1059)))
    (setfield_imm 5 (global Code!) unitise/1058))
  (letrec
    (intersect/1060
       (function o/1061 d/1062 hit/1064 param/1125
         (let
           (s/1067 (field 2 param/1125)
            r/1066 (field 1 param/1125)
            c/1065 (field 0 param/1125)
            match/1126 (field 1 hit/1064)
            l/1063 (field 0 hit/1064)
            v/1068 (apply (field 3 (global Code!)) c/1065 o/1061)
            b/1069 (apply (field 4 (global Code!)) v/1068 d/1062)
            disc/1070
              (caml_sqrt_float
                (+.
                  (-. (*. b/1069 b/1069)
                    (apply (field 4 (global Code!)) v/1068 v/1068))
                  (*. r/1066 r/1066)))
            t1/1071 (-. b/1069 disc/1070)
            t2/1072 (+. b/1069 disc/1070)
            l'/1073
              (if (>. t2/1072 0.) (if (>. t1/1071 0.) t1/1071 t2/1072)
                (field 9 (global Pervasives!))))
           (if (>=. l'/1073 l/1063) hit/1064
             (catch
               (if s/1067 (exit 7)
                 (makeblock 0 l'/1073
                   (apply (field 5 (global Code!))
                     (apply (field 3 (global Code!))
                       (apply (field 2 (global Code!)) o/1061
                         (apply (field 1 (global Code!)) l'/1073 d/1062))
                       c/1065))))
              with (7)
               (let (ss/1074 s/1067)
                 (apply (field 13 (global List!))
                   (apply intersect/1060 o/1061 d/1062) hit/1064 ss/1074)))))))
    (setfield_imm 6 (global Code!) intersect/1060))
  (let (light/1075 (apply (field 5 (global Code!)) [0: 1. 3. -2.]) ss/1076 4)
    (seq (setfield_imm 7 (global Code!) light/1075)
      (setfield_imm 8 (global Code!) ss/1076)))
  (letrec
    (create/1077
       (function level/1078 c/1079 r/1080
         (let (obj/1081 (makeblock 0 c/1079 r/1080 0a))
           (if (== level/1078 1) obj/1081
             (let
               (a/1082 (/. (*. 3. r/1080) (caml_sqrt_float 12.))
                aux/1083
                  (function x'/1084 z'/1085
                    (apply create/1077 (- level/1078 1)
                      (apply (field 2 (global Code!)) c/1079
                        (makeblock 0 x'/1084 a/1082 z'/1085))
                      (*. 0.5 r/1080))))
               (makeblock 0 c/1079 (*. 3. r/1080)
                 (makeblock 0 obj/1081
                   (makeblock 0 (apply aux/1083 (~. a/1082) (~. a/1082))
                     (makeblock 0 (apply aux/1083 a/1082 (~. a/1082))
                       (makeblock 0 (apply aux/1083 (~. a/1082) a/1082)
                         (makeblock 0 (apply aux/1083 a/1082 a/1082) 0a)))))))))))
    (setfield_imm 9 (global Code!) create/1077))
  (let
    (match/1128
       (try
         (makeblock 0
           (caml_int_of_string (array.get (field 0 (global Sys!)) 1))
           (caml_int_of_string (array.get (field 0 (global Sys!)) 2)))
        with exn/1127 [0: 9 512])
     n/1087 (field 1 match/1128)
     level/1086 (field 0 match/1128))
    (seq (setfield_imm 10 (global Code!) level/1086)
      (setfield_imm 11 (global Code!) n/1087)))
  (let
    (scene/1088
       (apply (field 9 (global Code!)) (field 10 (global Code!))
         [0: 0. -1. 4.] 1.))
    (setfield_imm 12 (global Code!) scene/1088))
  (letrec
    (ray_trace/1089
       (function dir/1090
         (let
           (match/1129
              (apply (field 6 (global Code!)) (field 0 (global Code!))
                dir/1090
                (makeblock 0 (field 9 (global Pervasives!))
                  (field 0 (global Code!)))
                (field 12 (global Code!)))
            n/1092 (field 1 match/1129)
            l/1091 (field 0 match/1129)
            g/1093
              (apply (field 4 (global Code!)) n/1092
                (field 7 (global Code!))))
           (if (<=. g/1093 0.) 0.
             (let
               (p/1094
                  (apply (field 2 (global Code!))
                    (apply (field 1 (global Code!)) l/1091 dir/1090)
                    (apply (field 1 (global Code!))
                      (caml_sqrt_float (field 14 (global Pervasives!)))
                      n/1092)))
               (if
                 (<.
                   (field 0
                     (apply (field 6 (global Code!)) p/1094
                       (field 7 (global Code!))
                       (makeblock 0 (field 9 (global Pervasives!))
                         (field 0 (global Code!)))
                       (field 12 (global Code!))))
                   (field 9 (global Pervasives!)))
                 0. g/1093))))))
    (setfield_imm 13 (global Code!) ray_trace/1089))
  (let
    (aux/1095
       (function x/1096 d/1097
         (+.
           (-. (float_of_int x/1096)
             (/. (float_of_int (field 11 (global Code!))) 2.))
           (/. (float_of_int d/1097) (float_of_int (field 8 (global Code!)))))))
    (setfield_imm 14 (global Code!) aux/1095))
  (apply (field 1 (global Printf!)) "P5\n%d %d\n255\n%!"
    (field 11 (global Code!)) (field 11 (global Code!)))
  (for y/1098 (- (field 11 (global Code!)) 1) downto 0
    (for x/1099 0 to (- (field 11 (global Code!)) 1)
      (let (g/1100 (makemutable 0 0.))
        (seq
          (for d/1101 0 to
            (- (* (field 8 (global Code!)) (field 8 (global Code!))) 1)
            (setfield_ptr 0 g/1100
              (+. (field 0 g/1100)
                (apply (field 13 (global Code!))
                  (apply (field 5 (global Code!))
                    (makeblock 0
                      (apply (field 14 (global Code!)) x/1099
                        (mod d/1101 (field 8 (global Code!))))
                      (apply (field 14 (global Code!)) y/1098
                        (/ d/1101 (field 8 (global Code!))))
                      (float_of_int (field 11 (global Code!)))))))))
          (let
            (g/1102
               (+. 0.5
                 (/. (*. 255. (field 0 g/1100))
                   (float_of_int
                     (* (field 8 (global Code!)) (field 8 (global Code!)))))))
            (apply (field 25 (global Pervasives!))
              (apply (field 16 (global Pervasives!)) (int_of_float g/1102))))))))
  0a)
-dlambda
(seq
  (let (zero/1031 [0: 0. 0. 0.]) (setfield_imm 0 (global Code!) zero/1031))
  (let
    (*|/1032
       (function s/1033 param/1118
         (makeblock 0 (*. s/1033 (field 0 param/1118))
           (*. s/1033 (field 1 param/1118)) (*. s/1033 (field 2 param/1118)))))
    (setfield_imm 1 (global Code!) *|/1032))
  (let
    (+|/1037
       (function param/1119 param/1120
         (makeblock 0 (+. (field 0 param/1119) (field 0 param/1120))
           (+. (field 1 param/1119) (field 1 param/1120))
           (+. (field 2 param/1119) (field 2 param/1120)))))
    (setfield_imm 2 (global Code!) +|/1037))
  (let
    (-|/1044
       (function param/1121 param/1122
         (makeblock 0 (-. (field 0 param/1121) (field 0 param/1122))
           (-. (field 1 param/1121) (field 1 param/1122))
           (-. (field 2 param/1121) (field 2 param/1122)))))
    (setfield_imm 3 (global Code!) -|/1044))
  (let
    (dot/1051
       (function param/1123 param/1124
         (+.
           (+. (*. (field 0 param/1123) (field 0 param/1124))
             (*. (field 1 param/1123) (field 1 param/1124)))
           (*. (field 2 param/1123) (field 2 param/1124)))))
    (setfield_imm 4 (global Code!) dot/1051))
  (let
    (unitise/1058
       (function r/1059
         (apply (field 1 (global Code!))
           (/. 1.
             (caml_sqrt_float (apply (field 4 (global Code!)) r/1059 r/1059)))
           r/1059)))
    (setfield_imm 5 (global Code!) unitise/1058))
  (letrec
    (intersect/1060
       (function o/1061 d/1062 hit/1064 param/1125
         (let
           (s/1067 (field 2 param/1125)
            r/1066 (field 1 param/1125)
            c/1065 (field 0 param/1125)
            v/1068 (apply (field 3 (global Code!)) c/1065 o/1061)
            b/1069 (apply (field 4 (global Code!)) v/1068 d/1062)
            disc/1070
              (caml_sqrt_float
                (+.
                  (-. (*. b/1069 b/1069)
                    (apply (field 4 (global Code!)) v/1068 v/1068))
                  (*. r/1066 r/1066)))
            t1/1071 (-. b/1069 disc/1070)
            t2/1072 (+. b/1069 disc/1070)
            l'/1073
              (if (>. t2/1072 0.) (if (>. t1/1071 0.) t1/1071 t2/1072)
                (field 9 (global Pervasives!))))
           (if (>=. l'/1073 (field 0 hit/1064)) hit/1064
             (if s/1067
               (apply (field 13 (global List!))
                 (apply intersect/1060 o/1061 d/1062) hit/1064 s/1067)
               (makeblock 0 l'/1073
                 (apply (field 5 (global Code!))
                   (apply (field 3 (global Code!))
                     (apply (field 2 (global Code!)) o/1061
                       (apply (field 1 (global Code!)) l'/1073 d/1062))
                     c/1065))))))))
    (setfield_imm 6 (global Code!) intersect/1060))
  (let (light/1075 (apply (field 5 (global Code!)) [0: 1. 3. -2.]) ss/1076 4)
    (seq (setfield_imm 7 (global Code!) light/1075)
      (setfield_imm 8 (global Code!) ss/1076)))
  (letrec
    (create/1077
       (function level/1078 c/1079 r/1080
         (let (obj/1081 (makeblock 0 c/1079 r/1080 0a))
           (if (== level/1078 1) obj/1081
             (let
               (a/1082 (/. (*. 3. r/1080) (caml_sqrt_float 12.))
                aux/1083
                  (function x'/1084 z'/1085
                    (apply create/1077 (- level/1078 1)
                      (apply (field 2 (global Code!)) c/1079
                        (makeblock 0 x'/1084 a/1082 z'/1085))
                      (*. 0.5 r/1080))))
               (makeblock 0 c/1079 (*. 3. r/1080)
                 (makeblock 0 obj/1081
                   (makeblock 0 (apply aux/1083 (~. a/1082) (~. a/1082))
                     (makeblock 0 (apply aux/1083 a/1082 (~. a/1082))
                       (makeblock 0 (apply aux/1083 (~. a/1082) a/1082)
                         (makeblock 0 (apply aux/1083 a/1082 a/1082) 0a)))))))))))
    (setfield_imm 9 (global Code!) create/1077))
  (let
    (match/1128
       (try
         (makeblock 0
           (caml_int_of_string (array.get (field 0 (global Sys!)) 1))
           (caml_int_of_string (array.get (field 0 (global Sys!)) 2)))
        with exn/1127 [0: 9 512]))
    (seq (setfield_imm 10 (global Code!) (field 0 match/1128))
      (setfield_imm 11 (global Code!) (field 1 match/1128))))
  (let
    (scene/1088
       (apply (field 9 (global Code!)) (field 10 (global Code!))
         [0: 0. -1. 4.] 1.))
    (setfield_imm 12 (global Code!) scene/1088))
  (letrec
    (ray_trace/1089
       (function dir/1090
         (let
           (match/1129
              (apply (field 6 (global Code!)) (field 0 (global Code!))
                dir/1090
                (makeblock 0 (field 9 (global Pervasives!))
                  (field 0 (global Code!)))
                (field 12 (global Code!)))
            n/1092 (field 1 match/1129)
            g/1093
              (apply (field 4 (global Code!)) n/1092
                (field 7 (global Code!))))
           (if (<=. g/1093 0.) 0.
             (let
               (p/1094
                  (apply (field 2 (global Code!))
                    (apply (field 1 (global Code!)) (field 0 match/1129)
                      dir/1090)
                    (apply (field 1 (global Code!))
                      (caml_sqrt_float (field 14 (global Pervasives!)))
                      n/1092)))
               (if
                 (<.
                   (field 0
                     (apply (field 6 (global Code!)) p/1094
                       (field 7 (global Code!))
                       (makeblock 0 (field 9 (global Pervasives!))
                         (field 0 (global Code!)))
                       (field 12 (global Code!))))
                   (field 9 (global Pervasives!)))
                 0. g/1093))))))
    (setfield_imm 13 (global Code!) ray_trace/1089))
  (let
    (aux/1095
       (function x/1096 d/1097
         (+.
           (-. (float_of_int x/1096)
             (/. (float_of_int (field 11 (global Code!))) 2.))
           (/. (float_of_int d/1097) (float_of_int (field 8 (global Code!)))))))
    (setfield_imm 14 (global Code!) aux/1095))
  (apply (field 1 (global Printf!)) "P5\n%d %d\n255\n%!"
    (field 11 (global Code!)) (field 11 (global Code!)))
  (for y/1098 (- (field 11 (global Code!)) 1) downto 0
    (for x/1099 0 to (- (field 11 (global Code!)) 1)
      (let (g/1100 0.)
        (seq
          (for d/1101 0 to
            (- (* (field 8 (global Code!)) (field 8 (global Code!))) 1)
            (assign g/1100
              (+. g/1100
                (apply (field 13 (global Code!))
                  (apply (field 5 (global Code!))
                    (makeblock 0
                      (apply (field 14 (global Code!)) x/1099
                        (mod d/1101 (field 8 (global Code!))))
                      (apply (field 14 (global Code!)) y/1098
                        (/ d/1101 (field 8 (global Code!))))
                      (float_of_int (field 11 (global Code!)))))))))
          (let
            (g/1102
               (+. 0.5
                 (/. (*. 255. g/1100)
                   (float_of_int
                     (* (field 8 (global Code!)) (field 8 (global Code!)))))))
            (apply (field 25 (global Pervasives!))
              (apply (field 16 (global Pervasives!)) (int_of_float g/1102))))))))
  0a)
checking tailcall on ray_trace/1089
checking tailcall on create/1077
checking tailcall on intersect/1060
stats_rec_removed : 1
(ray_trace_1089) 
stats_tailcall_removed : 0

checking tailcall on create/1077
checking tailcall on intersect/1060
-dlambda2
*** After TonLambda.optimize:
(seq
  (let (zero/1031 [0: 0. 0. 0.]) (setfield_imm 0 (global Code!) zero/1031))
  (let
    (*|/1032
       (function s/1033 param/1118
         (makeblock 0 (*. s/1033 (field 0 param/1118))
           (*. s/1033 (field 1 param/1118)) (*. s/1033 (field 2 param/1118)))))
    (setfield_imm 1 (global Code!) *|/1032))
  (let
    (+|/1037
       (function param/1119 param/1120
         (makeblock 0 (+. (field 0 param/1119) (field 0 param/1120))
           (+. (field 1 param/1119) (field 1 param/1120))
           (+. (field 2 param/1119) (field 2 param/1120)))))
    (setfield_imm 2 (global Code!) +|/1037))
  (let
    (-|/1044
       (function param/1121 param/1122
         (makeblock 0 (-. (field 0 param/1121) (field 0 param/1122))
           (-. (field 1 param/1121) (field 1 param/1122))
           (-. (field 2 param/1121) (field 2 param/1122)))))
    (setfield_imm 3 (global Code!) -|/1044))
  (let
    (dot/1051
       (function param/1123 param/1124
         (+.
           (+. (*. (field 0 param/1123) (field 0 param/1124))
             (*. (field 1 param/1123) (field 1 param/1124)))
           (*. (field 2 param/1123) (field 2 param/1124)))))
    (setfield_imm 4 (global Code!) dot/1051))
  (let
    (unitise/1058
       (function r/1059
         (apply (field 1 (global Code!))
           (/. 1.
             (caml_sqrt_float (apply (field 4 (global Code!)) r/1059 r/1059)))
           r/1059)))
    (setfield_imm 5 (global Code!) unitise/1058))
  (letrec
    (intersect/1060
       (function o/1061 d/1062 hit/1064 param/1125
         (let
           (s/1067 (field 2 param/1125)
            r/1066 (field 1 param/1125)
            c/1065 (field 0 param/1125)
            v/1068 (apply (field 3 (global Code!)) c/1065 o/1061)
            b/1069 (apply (field 4 (global Code!)) v/1068 d/1062)
            disc/1070
              (caml_sqrt_float
                (+.
                  (-. (*. b/1069 b/1069)
                    (apply (field 4 (global Code!)) v/1068 v/1068))
                  (*. r/1066 r/1066)))
            t1/1071 (-. b/1069 disc/1070)
            t2/1072 (+. b/1069 disc/1070)
            l'/1073
              (if (>. t2/1072 0.) (if (>. t1/1071 0.) t1/1071 t2/1072)
                (field 9 (global Pervasives!))))
           (if (>=. l'/1073 (field 0 hit/1064)) hit/1064
             (if s/1067
               (apply (field 13 (global List!))
                 (apply intersect/1060 o/1061 d/1062) hit/1064 s/1067)
               (makeblock 0 l'/1073
                 (apply (field 5 (global Code!))
                   (apply (field 3 (global Code!))
                     (apply (field 2 (global Code!)) o/1061
                       (apply (field 1 (global Code!)) l'/1073 d/1062))
                     c/1065))))))))
    (setfield_imm 6 (global Code!) intersect/1060))
  (let (light/1075 (apply (field 5 (global Code!)) [0: 1. 3. -2.]) ss/1076 4)
    (seq (setfield_imm 7 (global Code!) light/1075)
      (setfield_imm 8 (global Code!) ss/1076)))
  (letrec
    (create/1077
       (function level/1078 c/1079 r/1080
         (let (obj/1081 (makeblock 0 c/1079 r/1080 0a))
           (if (== level/1078 1) obj/1081
             (let
               (a/1082 (/. (*. 3. r/1080) (caml_sqrt_float 12.))
                aux/1083
                  (function x'/1084 z'/1085
                    (apply create/1077 (- level/1078 1)
                      (apply (field 2 (global Code!)) c/1079
                        (makeblock 0 x'/1084 a/1082 z'/1085))
                      (*. 0.5 r/1080))))
               (makeblock 0 c/1079 (*. 3. r/1080)
                 (makeblock 0 obj/1081
                   (makeblock 0 (apply aux/1083 (~. a/1082) (~. a/1082))
                     (makeblock 0 (apply aux/1083 a/1082 (~. a/1082))
                       (makeblock 0 (apply aux/1083 (~. a/1082) a/1082)
                         (makeblock 0 (apply aux/1083 a/1082 a/1082) 0a)))))))))))
    (setfield_imm 9 (global Code!) create/1077))
  (let
    (match/1128
       (try
         (makeblock 0
           (caml_int_of_string (array.get (field 0 (global Sys!)) 1))
           (caml_int_of_string (array.get (field 0 (global Sys!)) 2)))
        with exn/1127 [0: 9 512]))
    (seq (setfield_imm 10 (global Code!) (field 0 match/1128))
      (setfield_imm 11 (global Code!) (field 1 match/1128))))
  (let
    (scene/1088
       (apply (field 9 (global Code!)) (field 10 (global Code!))
         [0: 0. -1. 4.] 1.))
    (setfield_imm 12 (global Code!) scene/1088))
  (let
    (ray_trace/1089
       (function dir/1090
         (let
           (match/1129
              (apply (field 6 (global Code!)) (field 0 (global Code!))
                dir/1090
                (makeblock 0 (field 9 (global Pervasives!))
                  (field 0 (global Code!)))
                (field 12 (global Code!)))
            n/1092 (field 1 match/1129)
            g/1093
              (apply (field 4 (global Code!)) n/1092
                (field 7 (global Code!))))
           (if (<=. g/1093 0.) 0.
             (let
               (p/1094
                  (apply (field 2 (global Code!))
                    (apply (field 1 (global Code!)) (field 0 match/1129)
                      dir/1090)
                    (apply (field 1 (global Code!))
                      (caml_sqrt_float (field 14 (global Pervasives!)))
                      n/1092)))
               (if
                 (<.
                   (field 0
                     (apply (field 6 (global Code!)) p/1094
                       (field 7 (global Code!))
                       (makeblock 0 (field 9 (global Pervasives!))
                         (field 0 (global Code!)))
                       (field 12 (global Code!))))
                   (field 9 (global Pervasives!)))
                 0. g/1093))))))
    (setfield_imm 13 (global Code!) ray_trace/1089))
  (let
    (aux/1095
       (function x/1096 d/1097
         (+.
           (-. (float_of_int x/1096)
             (/. (float_of_int (field 11 (global Code!))) 2.))
           (/. (float_of_int d/1097) (float_of_int (field 8 (global Code!)))))))
    (setfield_imm 14 (global Code!) aux/1095))
  (apply (field 1 (global Printf!)) "P5\n%d %d\n255\n%!"
    (field 11 (global Code!)) (field 11 (global Code!)))
  (for y/1098 (- (field 11 (global Code!)) 1) downto 0
    (for x/1099 0 to (- (field 11 (global Code!)) 1)
      (let (g/1100 0.)
        (seq
          (for d/1101 0 to
            (- (* (field 8 (global Code!)) (field 8 (global Code!))) 1)
            (assign g/1100
              (+. g/1100
                (apply (field 13 (global Code!))
                  (apply (field 5 (global Code!))
                    (makeblock 0
                      (apply (field 14 (global Code!)) x/1099
                        (mod d/1101 (field 8 (global Code!))))
                      (apply (field 14 (global Code!)) y/1098
                        (/ d/1101 (field 8 (global Code!))))
                      (float_of_int (field 11 (global Code!)))))))))
          (let
            (g/1102
               (+. 0.5
                 (/. (*. 255. g/1100)
                   (float_of_int
                     (* (field 8 (global Code!)) (field 8 (global Code!)))))))
            (apply (field 25 (global Pervasives!))
              (apply (field 16 (global Pervasives!)) (int_of_float g/1102))))))))
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let (zero/1031 [0: 0. 0. 0.])
    (setfield_imm 0 (global camlCode!) zero/1031))
  (let
    (*|/1032
       (closure (camlCode__*|_1032(2)  s/1033 param/1118
                  (makeblock 0 (*. s/1033 (field 0 param/1118))
                    (*. s/1033 (field 1 param/1118))
                    (*. s/1033 (field 2 param/1118)))) {3} ))
    (setfield_imm 1 (global camlCode!) *|/1032))
  (let
    (+|/1037
       (closure (camlCode__+|_1037(2)  param/1119 param/1120
                  (makeblock 0 (+. (field 0 param/1119) (field 0 param/1120))
                    (+. (field 1 param/1119) (field 1 param/1120))
                    (+. (field 2 param/1119) (field 2 param/1120)))) 
         {3} ))
    (setfield_imm 2 (global camlCode!) +|/1037))
  (let
    (-|/1044
       (closure (camlCode__-|_1044(2)  param/1121 param/1122
                  (makeblock 0 (-. (field 0 param/1121) (field 0 param/1122))
                    (-. (field 1 param/1121) (field 1 param/1122))
                    (-. (field 2 param/1121) (field 2 param/1122)))) 
         {3} ))
    (setfield_imm 3 (global camlCode!) -|/1044))
  (let
    (dot/1051
       (closure (camlCode__dot_1051(2)  param/1123 param/1124
                  (+.
                    (+. (*. (field 0 param/1123) (field 0 param/1124))
                      (*. (field 1 param/1123) (field 1 param/1124)))
                    (*. (field 2 param/1123) (field 2 param/1124)))) 
         {3} ))
    (setfield_imm 4 (global camlCode!) dot/1051))
  (let
    (unitise/1058
       (closure (camlCode__unitise_1058(1)  r/1059
                  (let
                    (s/1135
                       (/. 1.
                         (caml_sqrt_float
                           (+.
                             (+. (*. (field 0 r/1059) (field 0 r/1059))
                               (*. (field 1 r/1059) (field 1 r/1059)))
                             (*. (field 2 r/1059) (field 2 r/1059))))))
                    (makeblock 0 (*. s/1135 (field 0 r/1059))
                      (*. s/1135 (field 1 r/1059))
                      (*. s/1135 (field 2 r/1059))))) {2} ))
    (setfield_imm 5 (global camlCode!) unitise/1058))
  (let
    (clos/1162
       (closure (camlCode__intersect_1060(4+c)  o/1061 d/1062 hit/1064
                  param/1125 env/1149
                  (let
                    (s/1067[Alias] (field 2 param/1125)
                     r/1066[Alias] (field 1 param/1125)
                     c/1065[Alias] (field 0 param/1125)
                     v/1068
                       (makeblock 0 (-. (field 0 c/1065) (field 0 o/1061))
                         (-. (field 1 c/1065) (field 1 o/1061))
                         (-. (field 2 c/1065) (field 2 o/1061)))
                     b/1069
                       (+.
                         (+. (*. (field 0 v/1068) (field 0 d/1062))
                           (*. (field 1 v/1068) (field 1 d/1062)))
                         (*. (field 2 v/1068) (field 2 d/1062)))
                     disc/1070
                       (caml_sqrt_float
                         (+.
                           (-. (*. b/1069 b/1069)
                             (+.
                               (+. (*. (field 0 v/1068) (field 0 v/1068))
                                 (*. (field 1 v/1068) (field 1 v/1068)))
                               (*. (field 2 v/1068) (field 2 v/1068))))
                           (*. r/1066 r/1066)))
                     t1/1071 (-. b/1069 disc/1070)
                     t2/1072 (+. b/1069 disc/1070)
                     l'/1073
                       (if (>. t2/1072 0.)
                         (if (>. t1/1071 0.) t1/1071 t2/1072)
                         (field 9 (global camlPervasives!))))
                    (if (>=. l'/1073 (field 0 hit/1064)) hit/1064
                      (if s/1067
                        (let
                          (f/1150 (apply env/1149 o/1061 d/1062)
                           l/1151[Variable] s/1067
                           accu/1152[Variable] hit/1064
                           f/1153[Variable] f/1150)
                          (catch
                            (while 1a
                              (catch
                                (exit 69
                                  (if l/1151
                                    (let
                                      (l/1154[Alias] (field 1 l/1151)
                                       a/1155[Alias] (field 0 l/1151)
                                       arg/1156
                                         (apply f/1153 accu/1152 a/1155)
                                       arg/1157 l/1154)
                                      (seq (assign l/1151 arg/1157)
                                        (assign accu/1152 arg/1156)
                                        (exit 68)))
                                    accu/1152))
                               with (68) 0a))
                           with (69 res/1445) res/1445))
                        (makeblock 0 l'/1073
                          (let
                            (r/1160
                               (let
                                 (param/1159
                                    (let
                                      (param/1158
                                         (makeblock 0
                                           (*. l'/1073 (field 0 d/1062))
                                           (*. l'/1073 (field 1 d/1062))
                                           (*. l'/1073 (field 2 d/1062))))
                                      (makeblock 0
                                        (+. (field 0 o/1061)
                                          (field 0 param/1158))
                                        (+. (field 1 o/1061)
                                          (field 1 param/1158))
                                        (+. (field 2 o/1061)
                                          (field 2 param/1158)))))
                                 (makeblock 0
                                   (-. (field 0 param/1159) (field 0 c/1065))
                                   (-. (field 1 param/1159) (field 1 c/1065))
                                   (-. (field 2 param/1159) (field 2 c/1065))))
                             s/1161
                               (/. 1.
                                 (caml_sqrt_float
                                   (+.
                                     (+.
                                       (*. (field 0 r/1160) (field 0 r/1160))
                                       (*. (field 1 r/1160) (field 1 r/1160)))
                                     (*. (field 2 r/1160) (field 2 r/1160))))))
                            (makeblock 0 (*. s/1161 (field 0 r/1160))
                              (*. s/1161 (field 1 r/1160))
                              (*. s/1161 (field 2 r/1160))))))))) {3} ))
    (setfield_imm 6 (global camlCode!) clos/1162))
  (let
    (light/1075
       (let
         (s/1163
            (/. 1.
              (caml_sqrt_float
                (+.
                  (+. (*. (field 0 [0: 1. 3. -2.]) (field 0 [0: 1. 3. -2.]))
                    (*. (field 1 [0: 1. 3. -2.]) (field 1 [0: 1. 3. -2.])))
                  (*. (field 2 [0: 1. 3. -2.]) (field 2 [0: 1. 3. -2.]))))))
         (makeblock 0 (*. s/1163 (field 0 [0: 1. 3. -2.]))
           (*. s/1163 (field 1 [0: 1. 3. -2.]))
           (*. s/1163 (field 2 [0: 1. 3. -2.])))))
    (seq (setfield_imm 7 (global camlCode!) light/1075)
      (setfield_imm 8 (global camlCode!) 4)))
  (let
    (clos/1202
       (closure (camlCode__create_1077(3+c)  level/1078 c/1079 r/1080
                  env/1183
                  (let (obj/1081 (makeblock 0 c/1079 r/1080 0a))
                    (if (== level/1078 1) obj/1081
                      (let
                        (a/1082 (/. (*. 3. r/1080) (caml_sqrt_float 12.))
                         aux/1083
                           (closure (camlCode__aux_1083(2+c)  x'/1084 z'/1085
                                      env/1187
                                      (camlCode__create_1077 
                                        (- (field 4 env/1187) 1)
                                        (let
                                          (param/1188
                                             (makeblock 0 x'/1084
                                               (field 7 env/1187) z'/1085)
                                           param/1189 (field 5 env/1187))
                                          (makeblock 0
                                            (+. (field 0 param/1189)
                                              (field 0 param/1188))
                                            (+. (field 1 param/1189)
                                              (field 1 param/1188))
                                            (+. (field 2 param/1189)
                                              (field 2 param/1188))))
                                        (*. 0.5 (field 6 env/1187))
                                        (field 3 env/1187))) {3} 
                                                             env/1183
                                                             level/1078
                                                             c/1079
                                                             r/1080
                                                             a/1082))
                        (makeblock 0 c/1079 (*. 3. r/1080)
                          (makeblock 0 obj/1081
                            (makeblock 0
                              (let (z'/1190 (~. a/1082) x'/1191 (~. a/1082))
                                (camlCode__create_1077 
                                  (- (field 4 aux/1083) 1)
                                  (let
                                    (param/1192
                                       (makeblock 0 x'/1191
                                         (field 7 aux/1083) z'/1190)
                                     param/1193 (field 5 aux/1083))
                                    (makeblock 0
                                      (+. (field 0 param/1193)
                                        (field 0 param/1192))
                                      (+. (field 1 param/1193)
                                        (field 1 param/1192))
                                      (+. (field 2 param/1193)
                                        (field 2 param/1192))))
                                  (*. 0.5 (field 6 aux/1083))
                                  (field 3 aux/1083)))
                              (makeblock 0
                                (let (z'/1194 (~. a/1082))
                                  (camlCode__create_1077 
                                    (- (field 4 aux/1083) 1)
                                    (let
                                      (param/1195
                                         (makeblock 0 a/1082
                                           (field 7 aux/1083) z'/1194)
                                       param/1196 (field 5 aux/1083))
                                      (makeblock 0
                                        (+. (field 0 param/1196)
                                          (field 0 param/1195))
                                        (+. (field 1 param/1196)
                                          (field 1 param/1195))
                                        (+. (field 2 param/1196)
                                          (field 2 param/1195))))
                                    (*. 0.5 (field 6 aux/1083))
                                    (field 3 aux/1083)))
                                (makeblock 0
                                  (let (x'/1197 (~. a/1082))
                                    (camlCode__create_1077 
                                      (- (field 4 aux/1083) 1)
                                      (let
                                        (param/1198
                                           (makeblock 0 x'/1197
                                             (field 7 aux/1083) a/1082)
                                         param/1199 (field 5 aux/1083))
                                        (makeblock 0
                                          (+. (field 0 param/1199)
                                            (field 0 param/1198))
                                          (+. (field 1 param/1199)
                                            (field 1 param/1198))
                                          (+. (field 2 param/1199)
                                            (field 2 param/1198))))
                                      (*. 0.5 (field 6 aux/1083))
                                      (field 3 aux/1083)))
                                  (makeblock 0
                                    (camlCode__create_1077 
                                      (- (field 4 aux/1083) 1)
                                      (let
                                        (param/1200
                                           (makeblock 0 a/1082
                                             (field 7 aux/1083) a/1082)
                                         param/1201 (field 5 aux/1083))
                                        (makeblock 0
                                          (+. (field 0 param/1201)
                                            (field 0 param/1200))
                                          (+. (field 1 param/1201)
                                            (field 1 param/1200))
                                          (+. (field 2 param/1201)
                                            (field 2 param/1200))))
                                      (*. 0.5 (field 6 aux/1083))
                                      (field 3 aux/1083))
                                    0a)))))))))) {3} ))
    (setfield_imm 9 (global camlCode!) clos/1202))
  (let
    (match/1128
       (try
         (makeblock 0
           (caml_int_of_string (array.get (field 0 (global camlSys!)) 1))
           (caml_int_of_string (array.get (field 0 (global camlSys!)) 2)))
        with exn/1127 [0: 9 512]))
    (seq (setfield_imm 10 (global camlCode!) (field 0 match/1128))
      (setfield_imm 11 (global camlCode!) (field 1 match/1128))))
  (let
    (scene/1088
       (camlCode__create_1077  (field 10 (global camlCode!)) [0: 0. -1. 4.]
         1. (field 9 (global camlCode!))))
    (setfield_imm 12 (global camlCode!) scene/1088))
  (let
    (ray_trace/1089
       (closure (camlCode__ray_trace_1089(1)  dir/1090
                  (let
                    (match/1129
                       (camlCode__intersect_1060 
                         (field 0 (global camlCode!)) dir/1090
                         (makeblock 0 (field 9 (global camlPervasives!))
                           (field 0 (global camlCode!)))
                         (field 12 (global camlCode!))
                         (field 6 (global camlCode!)))
                     n/1092[Alias] (field 1 match/1129)
                     g/1093
                       (let (param/1204 (field 7 (global camlCode!)))
                         (+.
                           (+. (*. (field 0 n/1092) (field 0 param/1204))
                             (*. (field 1 n/1092) (field 1 param/1204)))
                           (*. (field 2 n/1092) (field 2 param/1204)))))
                    (if (<=. g/1093 0.) 0.
                      (let
                        (p/1094
                           (let
                             (param/1207
                                (let
                                  (s/1206
                                     (caml_sqrt_float
                                       (field 14 (global camlPervasives!))))
                                  (makeblock 0 (*. s/1206 (field 0 n/1092))
                                    (*. s/1206 (field 1 n/1092))
                                    (*. s/1206 (field 2 n/1092))))
                              param/1208
                                (let (s/1205 (field 0 match/1129))
                                  (makeblock 0 (*. s/1205 (field 0 dir/1090))
                                    (*. s/1205 (field 1 dir/1090))
                                    (*. s/1205 (field 2 dir/1090)))))
                             (makeblock 0
                               (+. (field 0 param/1208) (field 0 param/1207))
                               (+. (field 1 param/1208) (field 1 param/1207))
                               (+. (field 2 param/1208) (field 2 param/1207)))))
                        (if
                          (<.
                            (field 0
                              (camlCode__intersect_1060  p/1094
                                (field 7 (global camlCode!))
                                (makeblock 0
                                  (field 9 (global camlPervasives!))
                                  (field 0 (global camlCode!)))
                                (field 12 (global camlCode!))
                                (field 6 (global camlCode!))))
                            (field 9 (global camlPervasives!)))
                          0. g/1093))))) {2} ))
    (setfield_imm 13 (global camlCode!) ray_trace/1089))
  (let
    (aux/1095
       (closure (camlCode__aux_1095(2)  x/1096 d/1097
                  (+.
                    (-. (float_of_int x/1096)
                      (/. (float_of_int (field 11 (global camlCode!))) 2.))
                    (/. (float_of_int d/1097) (float_of_int 4)))) {3} ))
    (setfield_imm 14 (global camlCode!) aux/1095))
  (apply
    (apply (camlPrintf__fprintf_1391  (field 23 (global camlPervasives!)))
      "P5\n%d %d\n255\n%!")
    (field 11 (global camlCode!)) (field 11 (global camlCode!)))
  (for y/1098 (- (field 11 (global camlCode!)) 1) downto 0
    (for x/1099 0 to (- (field 11 (global camlCode!)) 1)
      (let (g/1100[Variable] 0.)
        (seq
          (for d/1101 0 to 15
            (assign g/1100
              (+. g/1100
                (let
                  (dir/1214
                     (let
                       (r/1212
                          (makeblock 0
                            (let (d/1210 (mod d/1101 4))
                              (+.
                                (-. (float_of_int x/1099)
                                  (/.
                                    (float_of_int
                                      (field 11 (global camlCode!)))
                                    2.))
                                (/. (float_of_int d/1210) (float_of_int 4))))
                            (let (d/1211 (/ d/1101 4))
                              (+.
                                (-. (float_of_int y/1098)
                                  (/.
                                    (float_of_int
                                      (field 11 (global camlCode!)))
                                    2.))
                                (/. (float_of_int d/1211) (float_of_int 4))))
                            (float_of_int (field 11 (global camlCode!))))
                        s/1213
                          (/. 1.
                            (caml_sqrt_float
                              (+.
                                (+. (*. (field 0 r/1212) (field 0 r/1212))
                                  (*. (field 1 r/1212) (field 1 r/1212)))
                                (*. (field 2 r/1212) (field 2 r/1212))))))
                       (makeblock 0 (*. s/1213 (field 0 r/1212))
                         (*. s/1213 (field 1 r/1212))
                         (*. s/1213 (field 2 r/1212))))
                   match/1215
                     (camlCode__intersect_1060  (field 0 (global camlCode!))
                       dir/1214
                       (makeblock 0 (field 9 (global camlPervasives!))
                         (field 0 (global camlCode!)))
                       (field 12 (global camlCode!))
                       (field 6 (global camlCode!)))
                   n/1216[Alias] (field 1 match/1215)
                   g/1217
                     (let (param/1223 (field 7 (global camlCode!)))
                       (+.
                         (+. (*. (field 0 n/1216) (field 0 param/1223))
                           (*. (field 1 n/1216) (field 1 param/1223)))
                         (*. (field 2 n/1216) (field 2 param/1223)))))
                  (if (<=. g/1217 0.) 0.
                    (let
                      (p/1218
                         (let
                           (param/1219
                              (let
                                (s/1222
                                   (caml_sqrt_float
                                     (field 14 (global camlPervasives!))))
                                (makeblock 0 (*. s/1222 (field 0 n/1216))
                                  (*. s/1222 (field 1 n/1216))
                                  (*. s/1222 (field 2 n/1216))))
                            param/1220
                              (let (s/1221 (field 0 match/1215))
                                (makeblock 0 (*. s/1221 (field 0 dir/1214))
                                  (*. s/1221 (field 1 dir/1214))
                                  (*. s/1221 (field 2 dir/1214)))))
                           (makeblock 0
                             (+. (field 0 param/1220) (field 0 param/1219))
                             (+. (field 1 param/1220) (field 1 param/1219))
                             (+. (field 2 param/1220) (field 2 param/1219)))))
                      (if
                        (<.
                          (field 0
                            (camlCode__intersect_1060  p/1218
                              (field 7 (global camlCode!))
                              (makeblock 0 (field 9 (global camlPervasives!))
                                (field 0 (global camlCode!)))
                              (field 12 (global camlCode!))
                              (field 6 (global camlCode!))))
                          (field 9 (global camlPervasives!)))
                        0. g/1217)))))))
          (let
            (g/1102 (+. 0.5 (/. (*. 255. g/1100) (float_of_int 16)))
             c/1225
               (let (n/1224 (int_of_float g/1102))
                 (if (|| (< n/1224 0) (> n/1224 255))
                   (raise
                     (makeblock 0 (global caml_exn_Invalid_argument!)
                       "char_of_int"))
                   (id n/1224))))
            (caml_ml_output_char (field 23 (global camlPervasives!)) c/1225))))))
  0a)
-dclosure2
*** After TonClosure.optimize:
(let (zero/1031 [0: 0. 0. 0.])
  (seq (setfield_imm 0 (global camlCode!) zero/1031)
    (let
      (*|/1032
         (closure (camlCode__*|_1032(2)  s/1033 param/1118
                    (makeblock 0 (*. s/1033 (field 0 param/1118))
                      (*. s/1033 (field 1 param/1118))
                      (*. s/1033 (field 2 param/1118)))) {3} ))
      (seq (setfield_imm 1 (global camlCode!) *|/1032)
        (let
          (+|/1037
             (closure (camlCode__+|_1037(2)  param/1119 param/1120
                        (makeblock 0
                          (+. (field 0 param/1119) (field 0 param/1120))
                          (+. (field 1 param/1119) (field 1 param/1120))
                          (+. (field 2 param/1119) (field 2 param/1120)))) 
               {3} ))
          (seq (setfield_imm 2 (global camlCode!) +|/1037)
            (let
              (-|/1044
                 (closure (camlCode__-|_1044(2)  param/1121 param/1122
                            (makeblock 0
                              (-. (field 0 param/1121) (field 0 param/1122))
                              (-. (field 1 param/1121) (field 1 param/1122))
                              (-. (field 2 param/1121) (field 2 param/1122)))) 
                   {3} ))
              (seq (setfield_imm 3 (global camlCode!) -|/1044)
                (let
                  (dot/1051
                     (closure (camlCode__dot_1051(2)  param/1123 param/1124
                                (+.
                                  (+.
                                    (*. (field 0 param/1123)
                                      (field 0 param/1124))
                                    (*. (field 1 param/1123)
                                      (field 1 param/1124)))
                                  (*. (field 2 param/1123)
                                    (field 2 param/1124)))) {3} ))
                  (seq (setfield_imm 4 (global camlCode!) dot/1051)
                    (let
                      (unitise/1058
                         (closure (camlCode__unitise_1058(1)  r/1059
                                    (let
                                      (s/1135
                                         (/. 1.
                                           (caml_sqrt_float
                                             (+.
                                               (+.
                                                 (*. (field 0 r/1059)
                                                   (field 0 r/1059))
                                                 (*. (field 1 r/1059)
                                                   (field 1 r/1059)))
                                               (*. (field 2 r/1059)
                                                 (field 2 r/1059))))))
                                      (makeblock 0
                                        (*. s/1135 (field 0 r/1059))
                                        (*. s/1135 (field 1 r/1059))
                                        (*. s/1135 (field 2 r/1059))))) 
                           {2} ))
                      (seq (setfield_imm 5 (global camlCode!) unitise/1058)
                        (let
                          (clos/1162
                             (closure (camlCode__intersect_1060(4+c)  o/1061
                                        d/1062 hit/1064 param/1125 env/1149
                                        (let
                                          (s/1067[Alias] (field 2 param/1125)
                                           r/1066[Alias] (field 1 param/1125)
                                           c/1065[Alias] (field 0 param/1125)
                                           v/1068
                                             (makeblock 0
                                               (-. (field 0 c/1065)
                                                 (field 0 o/1061))
                                               (-. (field 1 c/1065)
                                                 (field 1 o/1061))
                                               (-. (field 2 c/1065)
                                                 (field 2 o/1061)))
                                           b/1069
                                             (+.
                                               (+.
                                                 (*. (field 0 v/1068)
                                                   (field 0 d/1062))
                                                 (*. (field 1 v/1068)
                                                   (field 1 d/1062)))
                                               (*. (field 2 v/1068)
                                                 (field 2 d/1062)))
                                           disc/1070
                                             (caml_sqrt_float
                                               (+.
                                                 (-. (*. b/1069 b/1069)
                                                   (+.
                                                     (+.
                                                       (*. (field 0 v/1068)
                                                         (field 0 v/1068))
                                                       (*. (field 1 v/1068)
                                                         (field 1 v/1068)))
                                                     (*. (field 2 v/1068)
                                                       (field 2 v/1068))))
                                                 (*. r/1066 r/1066)))
                                           t1/1071 (-. b/1069 disc/1070)
                                           t2/1072 (+. b/1069 disc/1070)
                                           l'/1073
                                             (if (>. t2/1072 0.)
                                               (if (>. t1/1071 0.) t1/1071
                                                 t2/1072)
                                               (field 9
                                                 (global camlPervasives!))))
                                          (if
                                            (>=. l'/1073 (field 0 hit/1064))
                                            hit/1064
                                            (if s/1067
                                              (let
                                                (f/1150
                                                   (apply env/1149 o/1061
                                                     d/1062)
                                                 l/1151[Variable] s/1067
                                                 accu/1152[Variable] hit/1064)
                                                (catch
                                                  (while 1a
                                                    (catch
                                                      (exit 69
                                                        (if l/1151
                                                          (let
                                                            (l/1154[Alias]
                                                               (field 1
                                                                 l/1151)
                                                             a/1155[Alias]
                                                               (field 0
                                                                 l/1151)
                                                             arg/1156
                                                               (apply f/1150
                                                                 accu/1152
                                                                 a/1155))
                                                            (seq
                                                              (assign l/1151
                                                                l/1154)
                                                              (assign
                                                                accu/1152
                                                                arg/1156)
                                                              (exit 68)))
                                                          accu/1152))
                                                     with (68) 0a))
                                                 with (69 res/1445) res/1445))
                                              (makeblock 0 l'/1073
                                                (let
                                                  (param/1158
                                                     (makeblock 0
                                                       (*. l'/1073
                                                         (field 0 d/1062))
                                                       (*. l'/1073
                                                         (field 1 d/1062))
                                                       (*. l'/1073
                                                         (field 2 d/1062)))
                                                   param/1159
                                                     (makeblock 0
                                                       (+. (field 0 o/1061)
                                                         (field 0 param/1158))
                                                       (+. (field 1 o/1061)
                                                         (field 1 param/1158))
                                                       (+. (field 2 o/1061)
                                                         (field 2 param/1158)))
                                                   r/1160
                                                     (makeblock 0
                                                       (-.
                                                         (field 0 param/1159)
                                                         (field 0 c/1065))
                                                       (-.
                                                         (field 1 param/1159)
                                                         (field 1 c/1065))
                                                       (-.
                                                         (field 2 param/1159)
                                                         (field 2 c/1065)))
                                                   s/1161
                                                     (/. 1.
                                                       (caml_sqrt_float
                                                         (+.
                                                           (+.
                                                             (*.
                                                               (field 0
                                                                 r/1160)
                                                               (field 0
                                                                 r/1160))
                                                             (*.
                                                               (field 1
                                                                 r/1160)
                                                               (field 1
                                                                 r/1160)))
                                                           (*.
                                                             (field 2 r/1160)
                                                             (field 2 r/1160))))))
                                                  (makeblock 0
                                                    (*. s/1161
                                                      (field 0 r/1160))
                                                    (*. s/1161
                                                      (field 1 r/1160))
                                                    (*. s/1161
                                                      (field 2 r/1160))))))))) 
                               {3} ))
                          (seq (setfield_imm 6 (global camlCode!) clos/1162)
                            (let
                              (s/1163
                                 (/. 1.
                                   (caml_sqrt_float
                                     (+.
                                       (+.
                                         (*. (field 0 [0: 1. 3. -2.])
                                           (field 0 [0: 1. 3. -2.]))
                                         (*. (field 1 [0: 1. 3. -2.])
                                           (field 1 [0: 1. 3. -2.])))
                                       (*. (field 2 [0: 1. 3. -2.])
                                         (field 2 [0: 1. 3. -2.])))))
                               light/1075
                                 (makeblock 0
                                   (*. s/1163 (field 0 [0: 1. 3. -2.]))
                                   (*. s/1163 (field 1 [0: 1. 3. -2.]))
                                   (*. s/1163 (field 2 [0: 1. 3. -2.]))))
                              (seq
                                (seq
                                  (setfield_imm 7 (global camlCode!)
                                    light/1075)
                                  (setfield_imm 8 (global camlCode!) 4))
                                (let
                                  (clos/1202
                                     (closure (camlCode__create_1077(3+c) 
                                                level/1078 c/1079 r/1080
                                                env/1183
                                                (let
                                                  (obj/1081
                                                     (makeblock 0 c/1079
                                                       r/1080 0a))
                                                  (if (== level/1078 1)
                                                    obj/1081
                                                    (let
                                                      (a/1082
                                                         (/. (*. 3. r/1080)
                                                           (caml_sqrt_float
                                                             12.)))
                                                      (makeblock 0 c/1079
                                                        (*. 3. r/1080)
                                                        (makeblock 0 obj/1081
                                                          (makeblock 0
                                                            (let
                                                              (z'/1190
                                                                 (~. a/1082)
                                                               x'/1191
                                                                 (~. a/1082))
                                                              (camlCode__create_1077
                                                                 (-
                                                                   level/1078
                                                                   1)
                                                                (makeblock 0
                                                                  (+.
                                                                    (field 0
                                                                    c/1079)
                                                                    x'/1191)
                                                                  (+.
                                                                    (field 1
                                                                    c/1079)
                                                                    a/1082)
                                                                  (+.
                                                                    (field 2
                                                                    c/1079)
                                                                    z'/1190))
                                                                (*. 0.5
                                                                  r/1080)
                                                                env/1183))
                                                            (makeblock 0
                                                              (let
                                                                (z'/1194
                                                                   (~.
                                                                    a/1082))
                                                                (camlCode__create_1077
                                                                   (-
                                                                    level/1078
                                                                    1)
                                                                  (makeblock 0
                                                                    (+.
                                                                    (field 0
                                                                    c/1079)
                                                                    a/1082)
                                                                    (+.
                                                                    (field 1
                                                                    c/1079)
                                                                    a/1082)
                                                                    (+.
                                                                    (field 2
                                                                    c/1079)
                                                                    z'/1194))
                                                                  (*. 0.5
                                                                    r/1080)
                                                                  env/1183))
                                                              (makeblock 0
                                                                (let
                                                                  (x'/1197
                                                                    (~.
                                                                    a/1082))
                                                                  (camlCode__create_1077
                                                                     
                                                                    (-
                                                                    level/1078
                                                                    1)
                                                                    (makeblock 0
                                                                    (+.
                                                                    (field 0
                                                                    c/1079)
                                                                    x'/1197)
                                                                    (+.
                                                                    (field 1
                                                                    c/1079)
                                                                    a/1082)
                                                                    (+.
                                                                    (field 2
                                                                    c/1079)
                                                                    a/1082))
                                                                    (*. 0.5
                                                                    r/1080)
                                                                    env/1183))
                                                                (makeblock 0
                                                                  (camlCode__create_1077
                                                                     
                                                                    (-
                                                                    level/1078
                                                                    1)
                                                                    (makeblock 0
                                                                    (+.
                                                                    (field 0
                                                                    c/1079)
                                                                    a/1082)
                                                                    (+.
                                                                    (field 1
                                                                    c/1079)
                                                                    a/1082)
                                                                    (+.
                                                                    (field 2
                                                                    c/1079)
                                                                    a/1082))
                                                                    (*. 0.5
                                                                    r/1080)
                                                                    env/1183)
                                                                  0a)))))))))) 
                                       {3} ))
                                  (seq
                                    (setfield_imm 9 (global camlCode!)
                                      clos/1202)
                                    (let
                                      (match/1128
                                         (try
                                           (makeblock 0
                                             (caml_int_of_string
                                               (array.get
                                                 (field 0 (global camlSys!))
                                                 1))
                                             (caml_int_of_string
                                               (array.get
                                                 (field 0 (global camlSys!))
                                                 2)))
                                          with exn/1127 [0: 9 512]))
                                      (seq
                                        (seq
                                          (setfield_imm 10 (global camlCode!)
                                            (field 0 match/1128))
                                          (setfield_imm 11 (global camlCode!)
                                            (field 1 match/1128)))
                                        (let
                                          (scene/1088
                                             (camlCode__create_1077 
                                               (field 10 (global camlCode!))
                                               [0: 0. -1. 4.] 1.
                                               (field 9 (global camlCode!))))
                                          (seq
                                            (setfield_imm 12
                                              (global camlCode!) scene/1088)
                                            (let
                                              (ray_trace/1089
                                                 (closure (camlCode__ray_trace_1089(1) 
                                                            dir/1090
                                                            (let
                                                              (match/1129
                                                                 (camlCode__intersect_1060
                                                                    (field 0
                                                                    (global camlCode!))
                                                                   dir/1090
                                                                   (makeblock 0
                                                                    (field 9
                                                                    (global camlPervasives!))
                                                                    (field 0
                                                                    (global camlCode!)))
                                                                   (field 12
                                                                    (global camlCode!))
                                                                   (field 6
                                                                    (global camlCode!)))
                                                               n/1092[Alias]
                                                                 (field 1
                                                                   match/1129)
                                                               param/1204
                                                                 (field 7
                                                                   (global camlCode!))
                                                               g/1093
                                                                 (+.
                                                                   (+.
                                                                    (*.
                                                                    (field 0
                                                                    n/1092)
                                                                    (field 0
                                                                    param/1204))
                                                                    (*.
                                                                    (field 1
                                                                    n/1092)
                                                                    (field 1
                                                                    param/1204)))
                                                                   (*.
                                                                    (field 2
                                                                    n/1092)
                                                                    (field 2
                                                                    param/1204))))
                                                              (if
                                                                (<=. g/1093
                                                                  0.)
                                                                0.
                                                                (let
                                                                  (s/1206
                                                                    (caml_sqrt_float
                                                                    (field 14
                                                                    (global camlPervasives!)))
                                                                   param/1207
                                                                    (makeblock 0
                                                                    (*.
                                                                    s/1206
                                                                    (field 0
                                                                    n/1092))
                                                                    (*.
                                                                    s/1206
                                                                    (field 1
                                                                    n/1092))
                                                                    (*.
                                                                    s/1206
                                                                    (field 2
                                                                    n/1092)))
                                                                   s/1205
                                                                    (field 0
                                                                    match/1129)
                                                                   param/1208
                                                                    (makeblock 0
                                                                    (*.
                                                                    s/1205
                                                                    (field 0
                                                                    dir/1090))
                                                                    (*.
                                                                    s/1205
                                                                    (field 1
                                                                    dir/1090))
                                                                    (*.
                                                                    s/1205
                                                                    (field 2
                                                                    dir/1090)))
                                                                   p/1094
                                                                    (makeblock 0
                                                                    (+.
                                                                    (field 0
                                                                    param/1208)
                                                                    (field 0
                                                                    param/1207))
                                                                    (+.
                                                                    (field 1
                                                                    param/1208)
                                                                    (field 1
                                                                    param/1207))
                                                                    (+.
                                                                    (field 2
                                                                    param/1208)
                                                                    (field 2
                                                                    param/1207))))
                                                                  (if
                                                                    (<.
                                                                    (field 0
                                                                    (camlCode__intersect_1060
                                                                     p/1094
                                                                    (field 7
                                                                    (global camlCode!))
                                                                    (makeblock 0
                                                                    (field 9
                                                                    (global camlPervasives!))
                                                                    (field 0
                                                                    (global camlCode!)))
                                                                    (field 12
                                                                    (global camlCode!))
                                                                    (field 6
                                                                    (global camlCode!))))
                                                                    (field 9
                                                                    (global camlPervasives!)))
                                                                    0.
                                                                    g/1093))))) 
                                                   {2} ))
                                              (seq
                                                (setfield_imm 13
                                                  (global camlCode!)
                                                  ray_trace/1089)
                                                (let
                                                  (aux/1095
                                                     (closure (camlCode__aux_1095(2) 
                                                                x/1096 d/1097
                                                                (+.
                                                                  (-.
                                                                    (float_of_int
                                                                    x/1096)
                                                                    (/.
                                                                    (float_of_int
                                                                    (field 11
                                                                    (global camlCode!)))
                                                                    2.))
                                                                  (/.
                                                                    (float_of_int
                                                                    d/1097)
                                                                    (float_of_int
                                                                    4)))) 
                                                       {3} ))
                                                  (seq
                                                    (setfield_imm 14
                                                      (global camlCode!)
                                                      aux/1095)
                                                    (apply
                                                      (apply
                                                        (camlPrintf__fprintf_1391
                                                           (field 23
                                                             (global camlPervasives!)))
                                                        "P5\n%d %d\n255\n%!")
                                                      (field 11
                                                        (global camlCode!))
                                                      (field 11
                                                        (global camlCode!)))
                                                    (for y/1098
                                                      (-
                                                        (field 11
                                                          (global camlCode!))
                                                        1)
                                                      downto 0
                                                      (for x/1099 0 to
                                                        (-
                                                          (field 11
                                                            (global camlCode!))
                                                          1)
                                                        (let
                                                          (g/1100[Variable]
                                                             0.)
                                                          (seq
                                                            (for d/1101 0 to
                                                              15
                                                              (assign g/1100
                                                                (+. g/1100
                                                                  (let
                                                                    (r/1212
                                                                    (makeblock 0
                                                                    (let
                                                                    (d/1210
                                                                    (mod
                                                                    d/1101 4))
                                                                    (+.
                                                                    (-.
                                                                    (float_of_int
                                                                    x/1099)
                                                                    (/.
                                                                    (float_of_int
                                                                    (field 11
                                                                    (global camlCode!)))
                                                                    2.))
                                                                    (/.
                                                                    (float_of_int
                                                                    d/1210)
                                                                    (float_of_int
                                                                    4))))
                                                                    (let
                                                                    (d/1211
                                                                    (/ d/1101
                                                                    4))
                                                                    (+.
                                                                    (-.
                                                                    (float_of_int
                                                                    y/1098)
                                                                    (/.
                                                                    (float_of_int
                                                                    (field 11
                                                                    (global camlCode!)))
                                                                    2.))
                                                                    (/.
                                                                    (float_of_int
                                                                    d/1211)
                                                                    (float_of_int
                                                                    4))))
                                                                    (float_of_int
                                                                    (field 11
                                                                    (global camlCode!))))
                                                                    s/1213
                                                                    (/. 1.
                                                                    (caml_sqrt_float
                                                                    (+.
                                                                    (+.
                                                                    (*.
                                                                    (field 0
                                                                    r/1212)
                                                                    (field 0
                                                                    r/1212))
                                                                    (*.
                                                                    (field 1
                                                                    r/1212)
                                                                    (field 1
                                                                    r/1212)))
                                                                    (*.
                                                                    (field 2
                                                                    r/1212)
                                                                    (field 2
                                                                    r/1212)))))
                                                                    dir/1214
                                                                    (makeblock 0
                                                                    (*.
                                                                    s/1213
                                                                    (field 0
                                                                    r/1212))
                                                                    (*.
                                                                    s/1213
                                                                    (field 1
                                                                    r/1212))
                                                                    (*.
                                                                    s/1213
                                                                    (field 2
                                                                    r/1212)))
                                                                    match/1215
                                                                    (camlCode__intersect_1060
                                                                     (field 0
                                                                    (global camlCode!))
                                                                    dir/1214
                                                                    (makeblock 0
                                                                    (field 9
                                                                    (global camlPervasives!))
                                                                    (field 0
                                                                    (global camlCode!)))
                                                                    (field 12
                                                                    (global camlCode!))
                                                                    (field 6
                                                                    (global camlCode!)))
                                                                    n/1216[Alias]
                                                                    (field 1
                                                                    match/1215)
                                                                    param/1223
                                                                    (field 7
                                                                    (global camlCode!))
                                                                    g/1217
                                                                    (+.
                                                                    (+.
                                                                    (*.
                                                                    (field 0
                                                                    n/1216)
                                                                    (field 0
                                                                    param/1223))
                                                                    (*.
                                                                    (field 1
                                                                    n/1216)
                                                                    (field 1
                                                                    param/1223)))
                                                                    (*.
                                                                    (field 2
                                                                    n/1216)
                                                                    (field 2
                                                                    param/1223))))
                                                                    (if
                                                                    (<=.
                                                                    g/1217
                                                                    0.) 0.
                                                                    (let
                                                                    (s/1222
                                                                    (caml_sqrt_float
                                                                    (field 14
                                                                    (global camlPervasives!)))
                                                                    param/1219
                                                                    (makeblock 0
                                                                    (*.
                                                                    s/1222
                                                                    (field 0
                                                                    n/1216))
                                                                    (*.
                                                                    s/1222
                                                                    (field 1
                                                                    n/1216))
                                                                    (*.
                                                                    s/1222
                                                                    (field 2
                                                                    n/1216)))
                                                                    s/1221
                                                                    (field 0
                                                                    match/1215)
                                                                    param/1220
                                                                    (makeblock 0
                                                                    (*.
                                                                    s/1221
                                                                    (field 0
                                                                    dir/1214))
                                                                    (*.
                                                                    s/1221
                                                                    (field 1
                                                                    dir/1214))
                                                                    (*.
                                                                    s/1221
                                                                    (field 2
                                                                    dir/1214)))
                                                                    p/1218
                                                                    (makeblock 0
                                                                    (+.
                                                                    (field 0
                                                                    param/1220)
                                                                    (field 0
                                                                    param/1219))
                                                                    (+.
                                                                    (field 1
                                                                    param/1220)
                                                                    (field 1
                                                                    param/1219))
                                                                    (+.
                                                                    (field 2
                                                                    param/1220)
                                                                    (field 2
                                                                    param/1219))))
                                                                    (if
                                                                    (<.
                                                                    (field 0
                                                                    (camlCode__intersect_1060
                                                                     p/1218
                                                                    (field 7
                                                                    (global camlCode!))
                                                                    (makeblock 0
                                                                    (field 9
                                                                    (global camlPervasives!))
                                                                    (field 0
                                                                    (global camlCode!)))
                                                                    (field 12
                                                                    (global camlCode!))
                                                                    (field 6
                                                                    (global camlCode!))))
                                                                    (field 9
                                                                    (global camlPervasives!)))
                                                                    0.
                                                                    g/1217)))))))
                                                            (let
                                                              (g/1102
                                                                 (+. 0.5
                                                                   (/.
                                                                    (*. 255.
                                                                    g/1100)
                                                                    (float_of_int
                                                                    16)))
                                                               n/1224
                                                                 (int_of_float
                                                                   g/1102)
                                                               c/1225
                                                                 (if
                                                                   (||
                                                                    (< n/1224
                                                                    0)
                                                                    (> n/1224
                                                                    255))
                                                                   (raise
                                                                    (makeblock 0
                                                                    (global caml_exn_Invalid_argument!)
                                                                    "char_of_int"))
                                                                   (id
                                                                    n/1224)))
                                                              (caml_ml_output_char
                                                                (field 23
                                                                  (global camlPervasives!))
                                                                c/1225))))))
                                                    0a))))))))))))))))))))))))))

-dcmm
(data int 15360 global "camlCode" "camlCode": skip 60)
(data
 int 3319
 "camlCode__8":
 addr "caml_curry2"
 int 5
 addr "camlCode__aux_1095")
(data int 2295 "camlCode__9": addr "camlCode__ray_trace_1089" int 3)
(data
 int 3319
 "camlCode__11":
 addr "caml_curry3"
 int 7
 addr "camlCode__create_1077")
(data
 int 3319
 "camlCode__12":
 addr "caml_curry4"
 int 9
 addr "camlCode__intersect_1060")
(data int 2295 "camlCode__13": addr "camlCode__unitise_1058" int 3)
(data
 int 3319
 "camlCode__14":
 addr "caml_curry2"
 int 5
 addr "camlCode__dot_1051")
(data
 int 3319
 "camlCode__15":
 addr "caml_curry2"
 int 5
 addr "camlCode__-|_1044")
(data
 int 3319
 "camlCode__16":
 addr "caml_curry2"
 int 5
 addr "camlCode__+|_1037")
(data
 int 3319
 "camlCode__17":
 addr "caml_curry2"
 int 5
 addr "camlCode__*|_1032")
(data
 global "camlCode__1"
 int 3072
 "camlCode__1":
 addr L26
 addr L27
 addr L28
 int 2301
 L28:
 double 0.
 int 2301
 L27:
 double 0.
 int 2301
 L26:
 double 0.)
(data
 global "camlCode__2"
 int 3072
 "camlCode__2":
 addr L23
 addr L24
 addr L25
 int 2301
 L25:
 double -2.
 int 2301
 L24:
 double 3.
 int 2301
 L23:
 double 1.)
(data global "camlCode__3" int 2048 "camlCode__3": int 19 int 1025)
(data
 global "camlCode__4"
 int 3072
 "camlCode__4":
 addr L20
 addr L21
 addr L22
 int 2301
 L22:
 double 4.
 int 2301
 L21:
 double -1.
 int 2301
 L20:
 double 0.)
(data
 global "camlCode__5"
 int 4348
 "camlCode__5":
 string "P5
%d %d
255
%!"
 skip 0
 byte 0)
(data int 2301 "camlCode__6": double 0.)
(data int 2301 "camlCode__7": double 0.)
(data int 2301 "camlCode__10": double 1.)
(data int 2301 "camlCode__18": double 0.)
(data int 2301 "camlCode__19": double 0.)
(function camlCode__*|_1032 (s/1033: addr param/1118: addr)
 (alloc[0] 3072
   (alloc[253] 2301
     (*f (load float64u s/1033) (load float64u (load param/1118))))
   (alloc[253] 2301
     (*f (load float64u s/1033) (load float64u (load (+a param/1118 4)))))
   (alloc[253] 2301
     (*f (load float64u s/1033) (load float64u (load (+a param/1118 8)))))))

(function camlCode__+|_1037 (param/1119: addr param/1120: addr)
 (alloc[0] 3072
   (alloc[253] 2301
     (+f (load float64u (load param/1119)) (load float64u (load param/1120))))
   (alloc[253] 2301
     (+f (load float64u (load (+a param/1119 4)))
       (load float64u (load (+a param/1120 4)))))
   (alloc[253] 2301
     (+f (load float64u (load (+a param/1119 8)))
       (load float64u (load (+a param/1120 8)))))))

(function camlCode__-|_1044 (param/1121: addr param/1122: addr)
 (alloc[0] 3072
   (alloc[253] 2301
     (-f (load float64u (load param/1121)) (load float64u (load param/1122))))
   (alloc[253] 2301
     (-f (load float64u (load (+a param/1121 4)))
       (load float64u (load (+a param/1122 4)))))
   (alloc[253] 2301
     (-f (load float64u (load (+a param/1121 8)))
       (load float64u (load (+a param/1122 8)))))))

(function camlCode__dot_1051 (param/1123: addr param/1124: addr)
 (alloc[253] 2301
   (+f
     (+f
       (*f (load float64u (load param/1123))
         (load float64u (load param/1124)))
       (*f (load float64u (load (+a param/1123 4)))
         (load float64u (load (+a param/1124 4)))))
     (*f (load float64u (load (+a param/1123 8)))
       (load float64u (load (+a param/1124 8)))))))

(function camlCode__unitise_1058 (r/1059: addr)
 (let
   s/1251
     (/f 1.
       (extcall "sqrt"
         (+f
           (+f
             (*f (load float64u (load r/1059)) (load float64u (load r/1059)))
             (*f (load float64u (load (+a r/1059 4)))
               (load float64u (load (+a r/1059 4)))))
           (*f (load float64u (load (+a r/1059 8)))
             (load float64u (load (+a r/1059 8)))))
         float))
   (alloc[0] 3072 (alloc[253] 2301 (*f s/1251 (load float64u (load r/1059))))
     (alloc[253] 2301 (*f s/1251 (load float64u (load (+a r/1059 4)))))
     (alloc[253] 2301 (*f s/1251 (load float64u (load (+a r/1059 8))))))))

(function camlCode__intersect_1060
     (o/1061: addr d/1062: addr hit/1064: addr param/1125: addr
      env/1149: addr)
 (let
   (s/1067 (load (+a param/1125 8)) r/1066 (load (+a param/1125 4))
    c/1065 (load param/1125)
    v/1068
      (alloc[0] 3072
        (alloc[253] 2301
          (-f (load float64u (load c/1065)) (load float64u (load o/1061))))
        (alloc[253] 2301
          (-f (load float64u (load (+a c/1065 4)))
            (load float64u (load (+a o/1061 4)))))
        (alloc[253] 2301
          (-f (load float64u (load (+a c/1065 8)))
            (load float64u (load (+a o/1061 8))))))
    b/1246
      (+f
        (+f (*f (load float64u (load v/1068)) (load float64u (load d/1062)))
          (*f (load float64u (load (+a v/1068 4)))
            (load float64u (load (+a d/1062 4)))))
        (*f (load float64u (load (+a v/1068 8)))
          (load float64u (load (+a d/1062 8)))))
    disc/1247
      (extcall "sqrt"
        (+f
          (-f (*f b/1246 b/1246)
            (+f
              (+f
                (*f (load float64u (load v/1068))
                  (load float64u (load v/1068)))
                (*f (load float64u (load (+a v/1068 4)))
                  (load float64u (load (+a v/1068 4)))))
              (*f (load float64u (load (+a v/1068 8)))
                (load float64u (load (+a v/1068 8))))))
          (*f (load float64u r/1066) (load float64u r/1066)))
        float)
    t1/1248 (-f b/1246 disc/1247) t2/1249 (+f b/1246 disc/1247)
    l'/1073
      (if (>f t2/1249 0.)
        (if (>f t1/1248 0.) (alloc[253] 2301 t1/1248)
          (alloc[253] 2301 t2/1249))
        (load (+a "camlPervasives" 36))))
   (if (>=f (load float64u l'/1073) (load float64u (load hit/1064))) hit/1064
     (if (!= s/1067 1)
       (let
         (f/1150 (app "caml_apply2" o/1061 d/1062 env/1149 addr)
          l/1151 s/1067 accu/1152 hit/1064)
         (catch
           (loop
             (catch
               (exit 69
                 (if (!= l/1151 1)
                   (let
                     (l/1154 (load (+a l/1151 4)) a/1155 (load l/1151)
                      arg/1156
                        (app{list.ml:74,24-34} "caml_apply2" accu/1152 a/1155
                          f/1150 addr))
                     (assign l/1151 l/1154) (assign accu/1152 arg/1156)
                     (exit 68))
                   accu/1152))
             with(68) []))
           1a
         with(69 res/1445) res/1445))
       (alloc[0] 2048 l'/1073
         (let
           (param/1158
              (alloc[0] 3072
                (alloc[253] 2301
                  (*f (load float64u l'/1073) (load float64u (load d/1062))))
                (alloc[253] 2301
                  (*f (load float64u l'/1073)
                    (load float64u (load (+a d/1062 4)))))
                (alloc[253] 2301
                  (*f (load float64u l'/1073)
                    (load float64u (load (+a d/1062 8))))))
            param/1159
              (alloc[0] 3072
                (alloc[253] 2301
                  (+f (load float64u (load o/1061))
                    (load float64u (load param/1158))))
                (alloc[253] 2301
                  (+f (load float64u (load (+a o/1061 4)))
                    (load float64u (load (+a param/1158 4)))))
                (alloc[253] 2301
                  (+f (load float64u (load (+a o/1061 8)))
                    (load float64u (load (+a param/1158 8))))))
            r/1160
              (alloc[0] 3072
                (alloc[253] 2301
                  (-f (load float64u (load param/1159))
                    (load float64u (load c/1065))))
                (alloc[253] 2301
                  (-f (load float64u (load (+a param/1159 4)))
                    (load float64u (load (+a c/1065 4)))))
                (alloc[253] 2301
                  (-f (load float64u (load (+a param/1159 8)))
                    (load float64u (load (+a c/1065 8))))))
            s/1250
              (/f 1.
                (extcall "sqrt"
                  (+f
                    (+f
                      (*f (load float64u (load r/1160))
                        (load float64u (load r/1160)))
                      (*f (load float64u (load (+a r/1160 4)))
                        (load float64u (load (+a r/1160 4)))))
                    (*f (load float64u (load (+a r/1160 8)))
                      (load float64u (load (+a r/1160 8)))))
                  float)))
           (alloc[0] 3072
             (alloc[253] 2301 (*f s/1250 (load float64u (load r/1160))))
             (alloc[253] 2301
               (*f s/1250 (load float64u (load (+a r/1160 4)))))
             (alloc[253] 2301
               (*f s/1250 (load float64u (load (+a r/1160 8))))))))))))

(function camlCode__create_1077
     (level/1078: addr c/1079: addr r/1080: addr env/1183: addr)
 (let obj/1081 (alloc[0] 3072 c/1079 r/1080 1a)
   (if (== level/1078 3) obj/1081
     (let
       a/1241 (/f (*f 3. (load float64u r/1080)) (extcall "sqrt" 12. float))
       (alloc[0] 3072 c/1079 (alloc[253] 2301 (*f 3. (load float64u r/1080)))
         (alloc[0] 2048 obj/1081
           (alloc[0] 2048
             (let (z'/1242 (~f a/1241) x'/1243 (~f a/1241))
               (app "camlCode__create_1077" (+ level/1078 -2)
                 (alloc[0] 3072
                   (alloc[253] 2301
                     (+f (load float64u (load c/1079)) x'/1243))
                   (alloc[253] 2301
                     (+f (load float64u (load (+a c/1079 4))) a/1241))
                   (alloc[253] 2301
                     (+f (load float64u (load (+a c/1079 8))) z'/1242)))
                 (alloc[253] 2301 (*f 0.5 (load float64u r/1080))) env/1183
                 addr))
             (alloc[0] 2048
               (let z'/1244 (~f a/1241)
                 (app "camlCode__create_1077" (+ level/1078 -2)
                   (alloc[0] 3072
                     (alloc[253] 2301
                       (+f (load float64u (load c/1079)) a/1241))
                     (alloc[253] 2301
                       (+f (load float64u (load (+a c/1079 4))) a/1241))
                     (alloc[253] 2301
                       (+f (load float64u (load (+a c/1079 8))) z'/1244)))
                   (alloc[253] 2301 (*f 0.5 (load float64u r/1080))) env/1183
                   addr))
               (alloc[0] 2048
                 (let x'/1245 (~f a/1241)
                   (app "camlCode__create_1077" (+ level/1078 -2)
                     (alloc[0] 3072
                       (alloc[253] 2301
                         (+f (load float64u (load c/1079)) x'/1245))
                       (alloc[253] 2301
                         (+f (load float64u (load (+a c/1079 4))) a/1241))
                       (alloc[253] 2301
                         (+f (load float64u (load (+a c/1079 8))) a/1241)))
                     (alloc[253] 2301 (*f 0.5 (load float64u r/1080)))
                     env/1183 addr))
                 (alloc[0] 2048
                   (app "camlCode__create_1077" (+ level/1078 -2)
                     (alloc[0] 3072
                       (alloc[253] 2301
                         (+f (load float64u (load c/1079)) a/1241))
                       (alloc[253] 2301
                         (+f (load float64u (load (+a c/1079 4))) a/1241))
                       (alloc[253] 2301
                         (+f (load float64u (load (+a c/1079 8))) a/1241)))
                     (alloc[253] 2301 (*f 0.5 (load float64u r/1080)))
                     env/1183 addr)
                   1a))))))))))

(function camlCode__ray_trace_1089 (dir/1090: addr)
 (let
   (match/1129
      (app "camlCode__intersect_1060" (load "camlCode") dir/1090
        (alloc[0] 2048 (load (+a "camlPervasives" 36)) (load "camlCode"))
        (load (+a "camlCode" 48)) (load (+a "camlCode" 24)) addr)
    n/1092 (load (+a match/1129 4)) param/1204 (load (+a "camlCode" 28))
    g/1239
      (+f
        (+f
          (*f (load float64u (load n/1092))
            (load float64u (load param/1204)))
          (*f (load float64u (load (+a n/1092 4)))
            (load float64u (load (+a param/1204 4)))))
        (*f (load float64u (load (+a n/1092 8)))
          (load float64u (load (+a param/1204 8))))))
   (if (<=f g/1239 0.) "camlCode__19"
     (let
       (s/1240
          (extcall "sqrt" (load float64u (load (+a "camlPervasives" 56)))
            float)
        param/1207
          (alloc[0] 3072
            (alloc[253] 2301 (*f s/1240 (load float64u (load n/1092))))
            (alloc[253] 2301
              (*f s/1240 (load float64u (load (+a n/1092 4)))))
            (alloc[253] 2301
              (*f s/1240 (load float64u (load (+a n/1092 8))))))
        s/1205 (load match/1129)
        param/1208
          (alloc[0] 3072
            (alloc[253] 2301
              (*f (load float64u s/1205) (load float64u (load dir/1090))))
            (alloc[253] 2301
              (*f (load float64u s/1205)
                (load float64u (load (+a dir/1090 4)))))
            (alloc[253] 2301
              (*f (load float64u s/1205)
                (load float64u (load (+a dir/1090 8))))))
        p/1094
          (alloc[0] 3072
            (alloc[253] 2301
              (+f (load float64u (load param/1208))
                (load float64u (load param/1207))))
            (alloc[253] 2301
              (+f (load float64u (load (+a param/1208 4)))
                (load float64u (load (+a param/1207 4)))))
            (alloc[253] 2301
              (+f (load float64u (load (+a param/1208 8)))
                (load float64u (load (+a param/1207 8)))))))
       (if
         (<f
           (load float64u
             (load
               (app "camlCode__intersect_1060" p/1094
                 (load (+a "camlCode" 28))
                 (alloc[0] 2048 (load (+a "camlPervasives" 36))
                   (load "camlCode"))
                 (load (+a "camlCode" 48)) (load (+a "camlCode" 24)) addr)))
           (load float64u (load (+a "camlPervasives" 36))))
         "camlCode__18" (alloc[253] 2301 g/1239))))))

(function camlCode__aux_1095 (x/1096: addr d/1097: addr)
 (alloc[253] 2301
   (+f
     (-f (floatofint (>>s x/1096 1))
       (/f (floatofint (>>s (load (+a "camlCode" 44)) 1)) 2.))
     (/f (floatofint (>>s d/1097 1)) (floatofint 4)))))

(function camlCode__entry ()
 (let zero/1031 "camlCode__1" (store "camlCode" zero/1031)
   (let *|/1032 "camlCode__17" (store (+a "camlCode" 4) *|/1032)
     (let +|/1037 "camlCode__16" (store (+a "camlCode" 8) +|/1037)
       (let -|/1044 "camlCode__15" (store (+a "camlCode" 12) -|/1044)
         (let dot/1051 "camlCode__14" (store (+a "camlCode" 16) dot/1051)
           (let unitise/1058 "camlCode__13"
             (store (+a "camlCode" 20) unitise/1058)
             (let clos/1162 "camlCode__12"
               (store (+a "camlCode" 24) clos/1162)
               (let
                 (s/1226
                    (/f 1.
                      (extcall "sqrt"
                        (+f
                          (+f
                            (*f (load float64u (load "camlCode__2"))
                              (load float64u (load "camlCode__2")))
                            (*f (load float64u (load (+a "camlCode__2" 4)))
                              (load float64u (load (+a "camlCode__2" 4)))))
                          (*f (load float64u (load (+a "camlCode__2" 8)))
                            (load float64u (load (+a "camlCode__2" 8)))))
                        float))
                  light/1075
                    (alloc[0] 3072
                      (alloc[253] 2301
                        (*f s/1226 (load float64u (load "camlCode__2"))))
                      (alloc[253] 2301
                        (*f s/1226
                          (load float64u (load (+a "camlCode__2" 4)))))
                      (alloc[253] 2301
                        (*f s/1226
                          (load float64u (load (+a "camlCode__2" 8)))))))
                 (store (+a "camlCode" 28) light/1075)
                 (store (+a "camlCode" 32) 9)
                 (let clos/1202 "camlCode__11"
                   (store (+a "camlCode" 36) clos/1202)
                   (let
                     match/1128
                       (try
                         (alloc[0] 2048
                           (extcall "caml_int_of_string"
                             (let arr/1237 (load "camlSys")
                               (checkbound (>>u (load (+a arr/1237 -4)) 9) 3)
                               (load (+a arr/1237 4)))
                             addr)
                           (extcall "caml_int_of_string"
                             (let arr/1238 (load "camlSys")
                               (checkbound (>>u (load (+a arr/1238 -4)) 9) 5)
                               (load (+a arr/1238 8)))
                             addr))
                       with exn/1127 "camlCode__3")
                     (store (+a "camlCode" 40) (load match/1128))
                     (store (+a "camlCode" 44) (load (+a match/1128 4)))
                     (let
                       scene/1088
                         (app "camlCode__create_1077"
                           (load (+a "camlCode" 40)) "camlCode__4"
                           "camlCode__10" (load (+a "camlCode" 36)) addr)
                       (store (+a "camlCode" 48) scene/1088)
                       (let ray_trace/1089 "camlCode__9"
                         (store (+a "camlCode" 52) ray_trace/1089)
                         (let aux/1095 "camlCode__8"
                           (store (+a "camlCode" 56) aux/1095)
                           (app "caml_apply2" (load (+a "camlCode" 44))
                             (load (+a "camlCode" 44))
                             (let
                               fun/1236
                                 (app{printf.ml:641,17-35}
                                   "camlPrintf__fprintf_1391"
                                   (load (+a "camlPervasives" 92)) addr)
                               (app{printf.ml:641,17-35} (load fun/1236)
                                 "camlCode__5" fun/1236 addr))
                             unit)
                           (let y/1098 (+ (load (+a "camlCode" 44)) -2)
                             (catch
                               (if (< y/1098 1) (exit 28)
                                 (loop
                                   (let
                                     (x/1099 1
                                      bound/1229
                                        (+ (load (+a "camlCode" 44)) -2))
                                     (catch
                                       (if (> x/1099 bound/1229) (exit 29)
                                         (loop
                                           (let g/1230 0.
                                             (let d/1101 1
                                               (catch
                                                 (if (> d/1101 31) (exit 31)
                                                   (loop
                                                     (assign g/1230
                                                               (+f g/1230
                                                                 (let
                                                                   (r/1212
                                                                    (alloc[0]
                                                                    3072
                                                                    (let
                                                                    d/1210
                                                                    (+
                                                                    (<<
                                                                    (mod
                                                                    (>>s
                                                                    d/1101 1)
                                                                    4) 1) 1)
                                                                    (alloc[253]
                                                                    2301
                                                                    (+f
                                                                    (-f
                                                                    (floatofint
                                                                    (>>s
                                                                    x/1099 1))
                                                                    (/f
                                                                    (floatofint
                                                                    (>>s
                                                                    (load
                                                                    (+a
                                                                    "camlCode"
                                                                    44)) 1))
                                                                    2.))
                                                                    (/f
                                                                    (floatofint
                                                                    (>>s
                                                                    d/1210 1))
                                                                    (floatofint
                                                                    4)))))
                                                                    (let
                                                                    d/1211
                                                                    (+
                                                                    (<<
                                                                    (/
                                                                    (>>s
                                                                    d/1101 1)
                                                                    4) 1) 1)
                                                                    (alloc[253]
                                                                    2301
                                                                    (+f
                                                                    (-f
                                                                    (floatofint
                                                                    (>>s
                                                                    y/1098 1))
                                                                    (/f
                                                                    (floatofint
                                                                    (>>s
                                                                    (load
                                                                    (+a
                                                                    "camlCode"
                                                                    44)) 1))
                                                                    2.))
                                                                    (/f
                                                                    (floatofint
                                                                    (>>s
                                                                    d/1211 1))
                                                                    (floatofint
                                                                    4)))))
                                                                    (alloc[253]
                                                                    2301
                                                                    (floatofint
                                                                    (>>s
                                                                    (load
                                                                    (+a
                                                                    "camlCode"
                                                                    44)) 1))))
                                                                    s/1233
                                                                    (/f 1.
                                                                    (extcall "sqrt"
                                                                    (+f
                                                                    (+f
                                                                    (*f
                                                                    (load float64u
                                                                    (load
                                                                    r/1212))
                                                                    (load float64u
                                                                    (load
                                                                    r/1212)))
                                                                    (*f
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    r/1212 4)))
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    r/1212 4)))))
                                                                    (*f
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    r/1212 8)))
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    r/1212 8)))))
                                                                    float))
                                                                    dir/1214
                                                                    (alloc[0]
                                                                    3072
                                                                    (alloc[253]
                                                                    2301
                                                                    (*f
                                                                    s/1233
                                                                    (load float64u
                                                                    (load
                                                                    r/1212))))
                                                                    (alloc[253]
                                                                    2301
                                                                    (*f
                                                                    s/1233
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    r/1212 4)))))
                                                                    (alloc[253]
                                                                    2301
                                                                    (*f
                                                                    s/1233
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    r/1212 8))))))
                                                                    match/1215
                                                                    (app
                                                                    "camlCode__intersect_1060"
                                                                    (load
                                                                    "camlCode")
                                                                    dir/1214
                                                                    (alloc[0]
                                                                    2048
                                                                    (load
                                                                    (+a
                                                                    "camlPervasives"
                                                                    36))
                                                                    (load
                                                                    "camlCode"))
                                                                    (load
                                                                    (+a
                                                                    "camlCode"
                                                                    48))
                                                                    (load
                                                                    (+a
                                                                    "camlCode"
                                                                    24))
                                                                    addr)
                                                                    n/1216
                                                                    (load
                                                                    (+a
                                                                    match/1215
                                                                    4))
                                                                    param/1223
                                                                    (load
                                                                    (+a
                                                                    "camlCode"
                                                                    28))
                                                                    g/1234
                                                                    (+f
                                                                    (+f
                                                                    (*f
                                                                    (load float64u
                                                                    (load
                                                                    n/1216))
                                                                    (load float64u
                                                                    (load
                                                                    param/1223)))
                                                                    (*f
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    n/1216 4)))
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    param/1223
                                                                    4)))))
                                                                    (*f
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    n/1216 8)))
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    param/1223
                                                                    8))))))
                                                                   (if
                                                                    (<=f
                                                                    g/1234
                                                                    0.)
                                                                    (load float64u
                                                                    "camlCode__7")
                                                                    (let
                                                                    (s/1235
                                                                    (extcall "sqrt"
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    "camlPervasives"
                                                                    56)))
                                                                    float)
                                                                    param/1219
                                                                    (alloc[0]
                                                                    3072
                                                                    (alloc[253]
                                                                    2301
                                                                    (*f
                                                                    s/1235
                                                                    (load float64u
                                                                    (load
                                                                    n/1216))))
                                                                    (alloc[253]
                                                                    2301
                                                                    (*f
                                                                    s/1235
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    n/1216 4)))))
                                                                    (alloc[253]
                                                                    2301
                                                                    (*f
                                                                    s/1235
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    n/1216 8))))))
                                                                    s/1221
                                                                    (load
                                                                    match/1215)
                                                                    param/1220
                                                                    (alloc[0]
                                                                    3072
                                                                    (alloc[253]
                                                                    2301
                                                                    (*f
                                                                    (load float64u
                                                                    s/1221)
                                                                    (load float64u
                                                                    (load
                                                                    dir/1214))))
                                                                    (alloc[253]
                                                                    2301
                                                                    (*f
                                                                    (load float64u
                                                                    s/1221)
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    dir/1214
                                                                    4)))))
                                                                    (alloc[253]
                                                                    2301
                                                                    (*f
                                                                    (load float64u
                                                                    s/1221)
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    dir/1214
                                                                    8))))))
                                                                    p/1218
                                                                    (alloc[0]
                                                                    3072
                                                                    (alloc[253]
                                                                    2301
                                                                    (+f
                                                                    (load float64u
                                                                    (load
                                                                    param/1220))
                                                                    (load float64u
                                                                    (load
                                                                    param/1219))))
                                                                    (alloc[253]
                                                                    2301
                                                                    (+f
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    param/1220
                                                                    4)))
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    param/1219
                                                                    4)))))
                                                                    (alloc[253]
                                                                    2301
                                                                    (+f
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    param/1220
                                                                    8)))
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    param/1219
                                                                    8)))))))
                                                                    (if
                                                                    (<f
                                                                    (load float64u
                                                                    (load
                                                                    (app
                                                                    "camlCode__intersect_1060"
                                                                    p/1218
                                                                    (load
                                                                    (+a
                                                                    "camlCode"
                                                                    28))
                                                                    (alloc[0]
                                                                    2048
                                                                    (load
                                                                    (+a
                                                                    "camlPervasives"
                                                                    36))
                                                                    (load
                                                                    "camlCode"))
                                                                    (load
                                                                    (+a
                                                                    "camlCode"
                                                                    48))
                                                                    (load
                                                                    (+a
                                                                    "camlCode"
                                                                    24))
                                                                    addr)))
                                                                    (load float64u
                                                                    (load
                                                                    (+a
                                                                    "camlPervasives"
                                                                    36))))
                                                                    (load float64u
                                                                    "camlCode__6")
                                                                    g/1234))))))
                                                     (let d/1232 d/1101
                                                       (assign d/1101
                                                                 (+ d/1101 2))
                                                       (if (== d/1232 31)
                                                         (exit 31) []))))
                                               with(31) []))
                                             (let
                                               (g/1231
                                                  (+f 0.5
                                                    (/f (*f 255. g/1230)
                                                      (floatofint 16)))
                                                n/1224
                                                  (+
                                                    (<< (intoffloat g/1231)
                                                      1)
                                                    1)
                                                c/1225
                                                  (catch
                                                    (if (< n/1224 1)
                                                      (exit 30)
                                                      (if (> n/1224 511)
                                                        (exit 30) n/1224))
                                                  with(30)
                                                    (raise{pervasives.ml:155,27-52}
                                                      (alloc[0] 2048
                                                        "caml_exn_Invalid_argument"
                                                        "camlPervasives__2"))))
                                               (extcall "caml_ml_output_char"{pervasives.ml:358,19-39}
                                                 (load
                                                   (+a "camlPervasives" 92))
                                                 c/1225 unit)))
                                           (let x/1228 x/1099
                                             (assign x/1099 (+ x/1099 2))
                                             (if (== x/1228 bound/1229)
                                               (exit 29) []))))
                                     with(29) []))
                                   (let y/1227 y/1098
                                     (assign y/1098 (- y/1098 2))
                                     (if (== y/1227 1) (exit 28) []))))
                             with(28) []))
                           1a))))))))))))))

(data)
-dlinear
Before simplify
camlCode__*|_1032:
                  s/8[%esi] := R/0[%eax]
                  {s/8[%esi]* param/9[%ebx]*}
                  A/10[%ecx] := alloc 52
                  [A/10[%ecx] + -4] := 2301
                  A/11[%eax] := [param/9[%ebx] + 8]
                  R/7[%tos] := float64u[s/8[%esi]]
                  R/7[%tos] := R/7[%tos] *f float64[A/11[%eax]]
                  float64u[A/10[%ecx]] := R/7[%tos]
                  A/14[%edx] := A/10[%ecx] + 12
                  [A/14[%edx] + -4] := 2301
                  A/15[%eax] := [param/9[%ebx] + 4]
                  R/7[%tos] := float64u[s/8[%esi]]
                  R/7[%tos] := R/7[%tos] *f float64[A/15[%eax]]
                  float64u[A/14[%edx]] := R/7[%tos]
                  A/18[%edi] := A/10[%ecx] + 24
                  [A/18[%edi] + -4] := 2301
                  A/19[%eax] := [param/9[%ebx]]
                  R/7[%tos] := float64u[s/8[%esi]]
                  R/7[%tos] := R/7[%tos] *f float64[A/19[%eax]]
                  float64u[A/18[%edi]] := R/7[%tos]
                  A/22[%eax] := A/10[%ecx] + 36
                  [A/22[%eax] + -4] := 3072
                  [A/22[%eax]] := A/18[%edi]
                  [A/22[%eax] + 4] := A/14[%edx]
                  [A/22[%eax] + 8] := A/10[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__*|_1032:
  s/8[%esi] := R/0[%eax]
  {s/8[%esi]* param/9[%ebx]*}
  A/10[%ecx] := alloc 52
  [A/10[%ecx] + -4] := 2301
  A/11[%eax] := [param/9[%ebx] + 8]
  R/7[%tos] := float64u[s/8[%esi]]
  R/7[%tos] := R/7[%tos] *f float64[A/11[%eax]]
  float64u[A/10[%ecx]] := R/7[%tos]
  A/14[%edx] := A/10[%ecx] + 12
  [A/14[%edx] + -4] := 2301
  A/15[%eax] := [param/9[%ebx] + 4]
  R/7[%tos] := float64u[s/8[%esi]]
  R/7[%tos] := R/7[%tos] *f float64[A/15[%eax]]
  float64u[A/14[%edx]] := R/7[%tos]
  A/18[%edi] := A/10[%ecx] + 24
  [A/18[%edi] + -4] := 2301
  A/19[%eax] := [param/9[%ebx]]
  R/7[%tos] := float64u[s/8[%esi]]
  R/7[%tos] := R/7[%tos] *f float64[A/19[%eax]]
  float64u[A/18[%edi]] := R/7[%tos]
  A/22[%eax] := A/10[%ecx] + 36
  [A/22[%eax] + -4] := 3072
  [A/22[%eax]] := A/18[%edi]
  [A/22[%eax] + 4] := A/14[%edx]
  [A/22[%eax] + 8] := A/10[%ecx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__+|_1037:
                  param/8[%edi] := R/0[%eax]
                  {param/8[%edi]* param/9[%ebx]*}
                  A/10[%ecx] := alloc 52
                  [A/10[%ecx] + -4] := 2301
                  A/11[%edx] := [param/9[%ebx] + 8]
                  A/12[%eax] := [param/8[%edi] + 8]
                  R/7[%tos] := float64u[A/12[%eax]]
                  R/7[%tos] := R/7[%tos] +f float64[A/11[%edx]]
                  float64u[A/10[%ecx]] := R/7[%tos]
                  A/15[%esi] := A/10[%ecx] + 12
                  [A/15[%esi] + -4] := 2301
                  A/16[%edx] := [param/9[%ebx] + 4]
                  A/17[%eax] := [param/8[%edi] + 4]
                  R/7[%tos] := float64u[A/17[%eax]]
                  R/7[%tos] := R/7[%tos] +f float64[A/16[%edx]]
                  float64u[A/15[%esi]] := R/7[%tos]
                  A/20[%edx] := A/10[%ecx] + 24
                  [A/20[%edx] + -4] := 2301
                  A/21[%ebx] := [param/9[%ebx]]
                  A/22[%eax] := [param/8[%edi]]
                  R/7[%tos] := float64u[A/22[%eax]]
                  R/7[%tos] := R/7[%tos] +f float64[A/21[%ebx]]
                  float64u[A/20[%edx]] := R/7[%tos]
                  A/25[%eax] := A/10[%ecx] + 36
                  [A/25[%eax] + -4] := 3072
                  [A/25[%eax]] := A/20[%edx]
                  [A/25[%eax] + 4] := A/15[%esi]
                  [A/25[%eax] + 8] := A/10[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__+|_1037:
  param/8[%edi] := R/0[%eax]
  {param/8[%edi]* param/9[%ebx]*}
  A/10[%ecx] := alloc 52
  [A/10[%ecx] + -4] := 2301
  A/11[%edx] := [param/9[%ebx] + 8]
  A/12[%eax] := [param/8[%edi] + 8]
  R/7[%tos] := float64u[A/12[%eax]]
  R/7[%tos] := R/7[%tos] +f float64[A/11[%edx]]
  float64u[A/10[%ecx]] := R/7[%tos]
  A/15[%esi] := A/10[%ecx] + 12
  [A/15[%esi] + -4] := 2301
  A/16[%edx] := [param/9[%ebx] + 4]
  A/17[%eax] := [param/8[%edi] + 4]
  R/7[%tos] := float64u[A/17[%eax]]
  R/7[%tos] := R/7[%tos] +f float64[A/16[%edx]]
  float64u[A/15[%esi]] := R/7[%tos]
  A/20[%edx] := A/10[%ecx] + 24
  [A/20[%edx] + -4] := 2301
  A/21[%ebx] := [param/9[%ebx]]
  A/22[%eax] := [param/8[%edi]]
  R/7[%tos] := float64u[A/22[%eax]]
  R/7[%tos] := R/7[%tos] +f float64[A/21[%ebx]]
  float64u[A/20[%edx]] := R/7[%tos]
  A/25[%eax] := A/10[%ecx] + 36
  [A/25[%eax] + -4] := 3072
  [A/25[%eax]] := A/20[%edx]
  [A/25[%eax] + 4] := A/15[%esi]
  [A/25[%eax] + 8] := A/10[%ecx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__-|_1044:
                  param/8[%edi] := R/0[%eax]
                  {param/8[%edi]* param/9[%ebx]*}
                  A/10[%ecx] := alloc 52
                  [A/10[%ecx] + -4] := 2301
                  A/11[%edx] := [param/9[%ebx] + 8]
                  A/12[%eax] := [param/8[%edi] + 8]
                  R/7[%tos] := float64u[A/12[%eax]]
                  R/7[%tos] := R/7[%tos] -f float64[A/11[%edx]]
                  float64u[A/10[%ecx]] := R/7[%tos]
                  A/15[%esi] := A/10[%ecx] + 12
                  [A/15[%esi] + -4] := 2301
                  A/16[%edx] := [param/9[%ebx] + 4]
                  A/17[%eax] := [param/8[%edi] + 4]
                  R/7[%tos] := float64u[A/17[%eax]]
                  R/7[%tos] := R/7[%tos] -f float64[A/16[%edx]]
                  float64u[A/15[%esi]] := R/7[%tos]
                  A/20[%edx] := A/10[%ecx] + 24
                  [A/20[%edx] + -4] := 2301
                  A/21[%ebx] := [param/9[%ebx]]
                  A/22[%eax] := [param/8[%edi]]
                  R/7[%tos] := float64u[A/22[%eax]]
                  R/7[%tos] := R/7[%tos] -f float64[A/21[%ebx]]
                  float64u[A/20[%edx]] := R/7[%tos]
                  A/25[%eax] := A/10[%ecx] + 36
                  [A/25[%eax] + -4] := 3072
                  [A/25[%eax]] := A/20[%edx]
                  [A/25[%eax] + 4] := A/15[%esi]
                  [A/25[%eax] + 8] := A/10[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__-|_1044:
  param/8[%edi] := R/0[%eax]
  {param/8[%edi]* param/9[%ebx]*}
  A/10[%ecx] := alloc 52
  [A/10[%ecx] + -4] := 2301
  A/11[%edx] := [param/9[%ebx] + 8]
  A/12[%eax] := [param/8[%edi] + 8]
  R/7[%tos] := float64u[A/12[%eax]]
  R/7[%tos] := R/7[%tos] -f float64[A/11[%edx]]
  float64u[A/10[%ecx]] := R/7[%tos]
  A/15[%esi] := A/10[%ecx] + 12
  [A/15[%esi] + -4] := 2301
  A/16[%edx] := [param/9[%ebx] + 4]
  A/17[%eax] := [param/8[%edi] + 4]
  R/7[%tos] := float64u[A/17[%eax]]
  R/7[%tos] := R/7[%tos] -f float64[A/16[%edx]]
  float64u[A/15[%esi]] := R/7[%tos]
  A/20[%edx] := A/10[%ecx] + 24
  [A/20[%edx] + -4] := 2301
  A/21[%ebx] := [param/9[%ebx]]
  A/22[%eax] := [param/8[%edi]]
  R/7[%tos] := float64u[A/22[%eax]]
  R/7[%tos] := R/7[%tos] -f float64[A/21[%ebx]]
  float64u[A/20[%edx]] := R/7[%tos]
  A/25[%eax] := A/10[%ecx] + 36
  [A/25[%eax] + -4] := 3072
  [A/25[%eax]] := A/20[%edx]
  [A/25[%eax] + 4] := A/15[%esi]
  [A/25[%eax] + 8] := A/10[%ecx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__dot_1051:
                  param/8[%ecx] := R/0[%eax]
                  {param/8[%ecx]* param/9[%ebx]*}
                  A/10[%eax] := alloc 12
                  [A/10[%eax] + -4] := 2301
                  A/11[%esi] := [param/9[%ebx] + 4]
                  A/12[%edx] := [param/8[%ecx] + 4]
                  R/7[%tos] := float64u[A/12[%edx]]
                  R/7[%tos] := R/7[%tos] *f float64[A/11[%esi]]
                  A/15[%esi] := [param/9[%ebx]]
                  A/16[%edx] := [param/8[%ecx]]
                  R/7[%tos] := float64u[A/16[%edx]]
                  R/7[%tos] := R/7[%tos] *f float64[A/15[%esi]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  A/20[%edx] := [param/9[%ebx] + 8]
                  A/21[%ebx] := [param/8[%ecx] + 8]
                  R/7[%tos] := float64u[A/21[%ebx]]
                  R/7[%tos] := R/7[%tos] *f float64[A/20[%edx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  float64u[A/10[%eax]] := R/7[%tos]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__dot_1051:
  param/8[%ecx] := R/0[%eax]
  {param/8[%ecx]* param/9[%ebx]*}
  A/10[%eax] := alloc 12
  [A/10[%eax] + -4] := 2301
  A/11[%esi] := [param/9[%ebx] + 4]
  A/12[%edx] := [param/8[%ecx] + 4]
  R/7[%tos] := float64u[A/12[%edx]]
  R/7[%tos] := R/7[%tos] *f float64[A/11[%esi]]
  A/15[%esi] := [param/9[%ebx]]
  A/16[%edx] := [param/8[%ecx]]
  R/7[%tos] := float64u[A/16[%edx]]
  R/7[%tos] := R/7[%tos] *f float64[A/15[%esi]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/20[%edx] := [param/9[%ebx] + 8]
  A/21[%ebx] := [param/8[%ecx] + 8]
  R/7[%tos] := float64u[A/21[%ebx]]
  R/7[%tos] := R/7[%tos] *f float64[A/20[%edx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  float64u[A/10[%eax]] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__unitise_1058:
                  r/8[%esi] := R/0[%eax]
                  A/9[%ebx] := [r/8[%esi] + 4]
                  A/10[%eax] := [r/8[%esi] + 4]
                  R/7[%tos] := float64u[A/10[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/9[%ebx]]
                  A/13[%ebx] := [r/8[%esi]]
                  A/14[%eax] := [r/8[%esi]]
                  R/7[%tos] := float64u[A/14[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/13[%ebx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  A/18[%ebx] := [r/8[%esi] + 8]
                  A/19[%eax] := [r/8[%esi] + 8]
                  R/7[%tos] := float64u[A/19[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/18[%ebx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  push R/7[%tos]
                  {r/8[%esi]*}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  F/23[s0] := R/7[%tos]
                  R/7[%tos] := 1.
                  R/7[%tos] := R/7[%tos] /f F/23[s0]
                  s/26[s0] := R/7[%tos]
                  {r/8[%esi]* s/26[s0]}
                  A/27[%ebx] := alloc 52
                  [A/27[%ebx] + -4] := 2301
                  A/28[%eax] := [r/8[%esi] + 8]
                  R/7[%tos] := s/26[s0] *f float64[A/28[%eax]]
                  float64u[A/27[%ebx]] := R/7[%tos]
                  A/30[%edx] := A/27[%ebx] + 12
                  [A/30[%edx] + -4] := 2301
                  A/31[%eax] := [r/8[%esi] + 4]
                  R/7[%tos] := s/26[s0] *f float64[A/31[%eax]]
                  float64u[A/30[%edx]] := R/7[%tos]
                  A/33[%ecx] := A/27[%ebx] + 24
                  [A/33[%ecx] + -4] := 2301
                  A/34[%eax] := [r/8[%esi]]
                  R/7[%tos] := s/26[s0] *f float64[A/34[%eax]]
                  float64u[A/33[%ecx]] := R/7[%tos]
                  A/36[%eax] := A/27[%ebx] + 36
                  [A/36[%eax] + -4] := 3072
                  [A/36[%eax]] := A/33[%ecx]
                  [A/36[%eax] + 4] := A/30[%edx]
                  [A/36[%eax] + 8] := A/27[%ebx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__unitise_1058:
  r/8[%esi] := R/0[%eax]
  A/9[%ebx] := [r/8[%esi] + 4]
  A/10[%eax] := [r/8[%esi] + 4]
  R/7[%tos] := float64u[A/10[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/9[%ebx]]
  A/13[%ebx] := [r/8[%esi]]
  A/14[%eax] := [r/8[%esi]]
  R/7[%tos] := float64u[A/14[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/13[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/18[%ebx] := [r/8[%esi] + 8]
  A/19[%eax] := [r/8[%esi] + 8]
  R/7[%tos] := float64u[A/19[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/18[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {r/8[%esi]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/23[s0] := R/7[%tos]
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] /f F/23[s0]
  s/26[s0] := R/7[%tos]
  {r/8[%esi]* s/26[s0]}
  A/27[%ebx] := alloc 52
  [A/27[%ebx] + -4] := 2301
  A/28[%eax] := [r/8[%esi] + 8]
  R/7[%tos] := s/26[s0] *f float64[A/28[%eax]]
  float64u[A/27[%ebx]] := R/7[%tos]
  A/30[%edx] := A/27[%ebx] + 12
  [A/30[%edx] + -4] := 2301
  A/31[%eax] := [r/8[%esi] + 4]
  R/7[%tos] := s/26[s0] *f float64[A/31[%eax]]
  float64u[A/30[%edx]] := R/7[%tos]
  A/33[%ecx] := A/27[%ebx] + 24
  [A/33[%ecx] + -4] := 2301
  A/34[%eax] := [r/8[%esi]]
  R/7[%tos] := s/26[s0] *f float64[A/34[%eax]]
  float64u[A/33[%ecx]] := R/7[%tos]
  A/36[%eax] := A/27[%ebx] + 36
  [A/36[%eax] + -4] := 3072
  [A/36[%eax]] := A/33[%ecx]
  [A/36[%eax] + 4] := A/30[%edx]
  [A/36[%eax] + 8] := A/27[%ebx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__intersect_1060:
                  spilled-o/171[s0] := o/8[%eax] (spill)
                  spilled-d/170[s1] := d/9[%ebx] (spill)
                  spilled-hit/164[s5] := hit/10[%ecx] (spill)
                  spilled-env/166[s3] := env/12[%esi] (spill)
                  s/13[%eax] := [param/11[%edx] + 8]
                  spilled-s/165[s4] := s/13[%eax] (spill)
                  r/14[%eax] := [param/11[%edx] + 4]
                  spilled-r/169[s2] := r/14[%eax] (spill)
                  c/15[%esi] := [param/11[%edx]]
                  {c/15[%esi]* spilled-hit/164[s5]* spilled-s/165[s4]*
                   spilled-env/166[s3]* spilled-r/169[s2]* spilled-d/170[s1]*
                   spilled-o/171[s0]*}
                  A/16[%ebx] := alloc 52
                  [A/16[%ebx] + -4] := 2301
                  o/172[%ebp] := spilled-o/171[s0] (reload)
                  A/17[%ecx] := [o/172[%ebp] + 8]
                  A/18[%eax] := [c/15[%esi] + 8]
                  R/7[%tos] := float64u[A/18[%eax]]
                  R/7[%tos] := R/7[%tos] -f float64[A/17[%ecx]]
                  float64u[A/16[%ebx]] := R/7[%tos]
                  A/21[%edx] := A/16[%ebx] + 12
                  [A/21[%edx] + -4] := 2301
                  A/22[%ecx] := [o/172[%ebp] + 4]
                  A/23[%eax] := [c/15[%esi] + 4]
                  R/7[%tos] := float64u[A/23[%eax]]
                  R/7[%tos] := R/7[%tos] -f float64[A/22[%ecx]]
                  float64u[A/21[%edx]] := R/7[%tos]
                  A/26[%ecx] := A/16[%ebx] + 24
                  [A/26[%ecx] + -4] := 2301
                  A/27[%edi] := [o/172[%ebp]]
                  A/28[%eax] := [c/15[%esi]]
                  R/7[%tos] := float64u[A/28[%eax]]
                  R/7[%tos] := R/7[%tos] -f float64[A/27[%edi]]
                  float64u[A/26[%ecx]] := R/7[%tos]
                  v/31[%eax] := A/16[%ebx] + 36
                  [v/31[%eax] + -4] := 3072
                  [v/31[%eax]] := A/26[%ecx]
                  [v/31[%eax] + 4] := A/21[%edx]
                  [v/31[%eax] + 8] := A/16[%ebx]
                  d/173[%ebx] := spilled-d/170[s1] (reload)
                  A/32[%edx] := [d/173[%ebx] + 4]
                  A/33[%ecx] := [v/31[%eax] + 4]
                  R/7[%tos] := float64u[A/33[%ecx]]
                  R/7[%tos] := R/7[%tos] *f float64[A/32[%edx]]
                  A/36[%edx] := [d/173[%ebx]]
                  A/37[%ecx] := [v/31[%eax]]
                  R/7[%tos] := float64u[A/37[%ecx]]
                  R/7[%tos] := R/7[%tos] *f float64[A/36[%edx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  A/41[%edx] := [d/173[%ebx] + 8]
                  A/42[%ecx] := [v/31[%eax] + 8]
                  R/7[%tos] := float64u[A/42[%ecx]]
                  R/7[%tos] := R/7[%tos] *f float64[A/41[%edx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  b/46[s2] := R/7[%tos]
                  A/47[%edx] := [v/31[%eax] + 4]
                  A/48[%ecx] := [v/31[%eax] + 4]
                  R/7[%tos] := float64u[A/48[%ecx]]
                  R/7[%tos] := R/7[%tos] *f float64[A/47[%edx]]
                  A/51[%edx] := [v/31[%eax]]
                  A/52[%ecx] := [v/31[%eax]]
                  R/7[%tos] := float64u[A/52[%ecx]]
                  R/7[%tos] := R/7[%tos] *f float64[A/51[%edx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  A/56[%ecx] := [v/31[%eax] + 8]
                  A/57[%eax] := [v/31[%eax] + 8]
                  R/7[%tos] := float64u[A/57[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/56[%ecx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  R/7[%tos] := b/46[s2] *f b/46[s2]
                  R/7[%tos] := R/7[%tos] -f R/7[%tos]
                  r/174[%eax] := spilled-r/169[s2] (reload)
                  R/7[%tos] := float64u[r/174[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[r/174[%eax]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  push R/7[%tos]
                  {c/15[%esi]* b/46[s2] spilled-hit/164[s5]*
                   spilled-s/165[s4]* spilled-env/166[s3]* o/172[%ebp]*
                   d/173[%ebx]*}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  disc/66[s0] := R/7[%tos]
                  R/7[%tos] := b/46[s2] -f disc/66[s0]
                  t1/68[s1] := R/7[%tos]
                  R/7[%tos] := b/46[s2] +f disc/66[s0]
                  t2/70[s0] := R/7[%tos]
                  R/7[%tos] := 0.
                  if not t2/70[s0] >f R/7[%tos] goto L125
                  R/7[%tos] := 0.
                  if not t1/68[s1] >f R/7[%tos] goto L126
                  {c/15[%esi]* t1/68[s1] spilled-hit/164[s5]*
                   spilled-s/165[s4]* spilled-env/166[s3]* o/172[%ebp]*
                   d/173[%ebx]*}
                  l'/73[%edx] := alloc 12
                  [l'/73[%edx] + -4] := 2301
                  float64u[l'/73[%edx]] := t1/68[s1]
                  goto L124
                  L126 [0]:
                  {c/15[%esi]* t2/70[s0] spilled-hit/164[s5]*
                   spilled-s/165[s4]* spilled-env/166[s3]* o/172[%ebp]*
                   d/173[%ebx]*}
                  A/74[%edx] := alloc 12
                  [A/74[%edx] + -4] := 2301
                  float64u[A/74[%edx]] := t2/70[s0]
                  goto L124
                  L125 [0]:
                  A/75[%edx] := ["camlPervasives" + 36]
                  L124 [0]:
                  hit/175[%ecx] := spilled-hit/164[s5] (reload)
                  A/76[%eax] := [hit/175[%ecx]]
                  R/7[%tos] := float64u[A/76[%eax]]
                  R/7[%tos] := float64u[l'/73[%edx]]
                  if not R/7[%tos] >=f R/7[%tos] goto L123
                  R/0[%eax] := hit/175[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  L123 [0]:
                  s/176[%eax] := spilled-s/165[s4] (reload)
                  if s/176[%eax] ==s 1 goto L120
                  spilled-s/165[s4] := s/176[%eax] (spill)
                  spilled-hit/164[s5] := hit/175[%ecx] (spill)
                  R/0[%eax] := o/172[%ebp]
                  env/177[%ecx] := spilled-env/166[s3] (reload)
                  {spilled-hit/164[s5]* spilled-s/165[s4]*}
                  R/0[%eax] := call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  spilled-f/163[s0] := f/153[%eax] (spill)
                  s/178[%ebx] := spilled-s/165[s4] (reload)
                  hit/179[%eax] := spilled-hit/164[s5] (reload)
                  L122 [0]:
                  if l/154[%ebx] ==s 1 goto L121
                  l/157[%ecx] := [l/154[%ebx] + 4]
                  spilled-l/162[s1] := l/157[%ecx] (spill)
                  a/158[%ebx] := [l/154[%ebx]]
                  f/180[%ecx] := spilled-f/163[s0] (reload)
                  {spilled-l/162[s1]* spilled-f/163[s0]*}
                  R/0[%eax] := call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx] {list.ml:74,24-34}
                  l/181[%ebx] := spilled-l/162[s1] (reload)
                  goto L122
                  L121 [0]:
                  reload retaddr
                  return R/0[%eax]
                  L120 [0]:
                  spilled-l'/167[s1] := l'/73[%edx] (spill)
                  spilled-c/168[s0] := c/15[%esi] (spill)
                  {l'/73[%edx]* spilled-l'/167[s1]* spilled-c/168[s0]*
                   o/172[%ebp]* d/173[%ebx]*}
                  A/79[%esi] := alloc 156
                  [A/79[%esi] + -4] := 2301
                  A/80[%eax] := [d/173[%ebx] + 8]
                  R/7[%tos] := float64u[l'/73[%edx]]
                  R/7[%tos] := R/7[%tos] *f float64[A/80[%eax]]
                  float64u[A/79[%esi]] := R/7[%tos]
                  A/83[%edi] := A/79[%esi] + 12
                  [A/83[%edi] + -4] := 2301
                  A/84[%eax] := [d/173[%ebx] + 4]
                  R/7[%tos] := float64u[l'/73[%edx]]
                  R/7[%tos] := R/7[%tos] *f float64[A/84[%eax]]
                  float64u[A/83[%edi]] := R/7[%tos]
                  A/87[%ecx] := A/79[%esi] + 24
                  [A/87[%ecx] + -4] := 2301
                  A/88[%eax] := [d/173[%ebx]]
                  R/7[%tos] := float64u[l'/73[%edx]]
                  R/7[%tos] := R/7[%tos] *f float64[A/88[%eax]]
                  float64u[A/87[%ecx]] := R/7[%tos]
                  param/91[%eax] := A/79[%esi] + 36
                  [param/91[%eax] + -4] := 3072
                  [param/91[%eax]] := A/87[%ecx]
                  [param/91[%eax] + 4] := A/83[%edi]
                  [param/91[%eax] + 8] := A/79[%esi]
                  A/92[%edx] := A/79[%esi] + 52
                  [A/92[%edx] + -4] := 2301
                  A/93[%ecx] := [param/91[%eax] + 8]
                  A/94[%ebx] := [o/172[%ebp] + 8]
                  R/7[%tos] := float64u[A/94[%ebx]]
                  R/7[%tos] := R/7[%tos] +f float64[A/93[%ecx]]
                  float64u[A/92[%edx]] := R/7[%tos]
                  A/97[%ecx] := A/79[%esi] + 64
                  [A/97[%ecx] + -4] := 2301
                  A/98[%edi] := [param/91[%eax] + 4]
                  A/99[%ebx] := [o/172[%ebp] + 4]
                  R/7[%tos] := float64u[A/99[%ebx]]
                  R/7[%tos] := R/7[%tos] +f float64[A/98[%edi]]
                  float64u[A/97[%ecx]] := R/7[%tos]
                  A/102[%ebx] := A/79[%esi] + 76
                  [A/102[%ebx] + -4] := 2301
                  A/103[%edi] := [param/91[%eax]]
                  A/104[%eax] := [o/172[%ebp]]
                  R/7[%tos] := float64u[A/104[%eax]]
                  R/7[%tos] := R/7[%tos] +f float64[A/103[%edi]]
                  float64u[A/102[%ebx]] := R/7[%tos]
                  param/107[%eax] := A/79[%esi] + 88
                  [param/107[%eax] + -4] := 3072
                  [param/107[%eax]] := A/102[%ebx]
                  [param/107[%eax] + 4] := A/97[%ecx]
                  [param/107[%eax] + 8] := A/92[%edx]
                  A/108[%edi] := A/79[%esi] + 104
                  [A/108[%edi] + -4] := 2301
                  c/182[%ebx] := spilled-c/168[s0] (reload)
                  A/109[%edx] := [c/182[%ebx] + 8]
                  A/110[%ecx] := [param/107[%eax] + 8]
                  R/7[%tos] := float64u[A/110[%ecx]]
                  R/7[%tos] := R/7[%tos] -f float64[A/109[%edx]]
                  float64u[A/108[%edi]] := R/7[%tos]
                  A/113[%edx] := A/79[%esi] + 116
                  [A/113[%edx] + -4] := 2301
                  A/114[%ebp] := [c/182[%ebx] + 4]
                  A/115[%ecx] := [param/107[%eax] + 4]
                  R/7[%tos] := float64u[A/115[%ecx]]
                  R/7[%tos] := R/7[%tos] -f float64[A/114[%ebp]]
                  float64u[A/113[%edx]] := R/7[%tos]
                  A/118[%ecx] := A/79[%esi] + 128
                  [A/118[%ecx] + -4] := 2301
                  A/119[%ebx] := [c/182[%ebx]]
                  A/120[%eax] := [param/107[%eax]]
                  R/7[%tos] := float64u[A/120[%eax]]
                  R/7[%tos] := R/7[%tos] -f float64[A/119[%ebx]]
                  float64u[A/118[%ecx]] := R/7[%tos]
                  r/123[%ebx] := A/79[%esi] + 140
                  [r/123[%ebx] + -4] := 3072
                  [r/123[%ebx]] := A/118[%ecx]
                  [r/123[%ebx] + 4] := A/113[%edx]
                  [r/123[%ebx] + 8] := A/108[%edi]
                  A/124[%ecx] := [r/123[%ebx] + 4]
                  A/125[%eax] := [r/123[%ebx] + 4]
                  R/7[%tos] := float64u[A/125[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/124[%ecx]]
                  A/128[%ecx] := [r/123[%ebx]]
                  A/129[%eax] := [r/123[%ebx]]
                  R/7[%tos] := float64u[A/129[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/128[%ecx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  A/133[%ecx] := [r/123[%ebx] + 8]
                  A/134[%eax] := [r/123[%ebx] + 8]
                  R/7[%tos] := float64u[A/134[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/133[%ecx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  push R/7[%tos]
                  {r/123[%ebx]* spilled-l'/167[s1]*}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  F/138[s0] := R/7[%tos]
                  R/7[%tos] := 1.
                  R/7[%tos] := R/7[%tos] /f F/138[s0]
                  s/141[s0] := R/7[%tos]
                  {r/123[%ebx]* s/141[s0] spilled-l'/167[s1]*}
                  A/142[%eax] := alloc 64
                  [A/142[%eax] + -4] := 2301
                  A/143[%ecx] := [r/123[%ebx] + 8]
                  R/7[%tos] := s/141[s0] *f float64[A/143[%ecx]]
                  float64u[A/142[%eax]] := R/7[%tos]
                  A/145[%esi] := A/142[%eax] + 12
                  [A/145[%esi] + -4] := 2301
                  A/146[%ecx] := [r/123[%ebx] + 4]
                  R/7[%tos] := s/141[s0] *f float64[A/146[%ecx]]
                  float64u[A/145[%esi]] := R/7[%tos]
                  A/148[%edx] := A/142[%eax] + 24
                  [A/148[%edx] + -4] := 2301
                  A/149[%ebx] := [r/123[%ebx]]
                  R/7[%tos] := s/141[s0] *f float64[A/149[%ebx]]
                  float64u[A/148[%edx]] := R/7[%tos]
                  A/151[%ecx] := A/142[%eax] + 36
                  [A/151[%ecx] + -4] := 3072
                  [A/151[%ecx]] := A/148[%edx]
                  [A/151[%ecx] + 4] := A/145[%esi]
                  [A/151[%ecx] + 8] := A/142[%eax]
                  A/152[%eax] := A/142[%eax] + 52
                  [A/152[%eax] + -4] := 2048
                  l'/183[%ebx] := spilled-l'/167[s1] (reload)
                  [A/152[%eax]] := l'/183[%ebx]
                  [A/152[%eax] + 4] := A/151[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__intersect_1060:
  spilled-o/171[s0] := o/8[%eax] (spill)
  spilled-d/170[s1] := d/9[%ebx] (spill)
  spilled-hit/164[s5] := hit/10[%ecx] (spill)
  spilled-env/166[s3] := env/12[%esi] (spill)
  s/13[%eax] := [param/11[%edx] + 8]
  spilled-s/165[s4] := s/13[%eax] (spill)
  r/14[%eax] := [param/11[%edx] + 4]
  spilled-r/169[s2] := r/14[%eax] (spill)
  c/15[%esi] := [param/11[%edx]]
  {c/15[%esi]* spilled-hit/164[s5]* spilled-s/165[s4]* spilled-env/166[s3]*
   spilled-r/169[s2]* spilled-d/170[s1]* spilled-o/171[s0]*}
  A/16[%ebx] := alloc 52
  [A/16[%ebx] + -4] := 2301
  o/172[%ebp] := spilled-o/171[s0] (reload)
  A/17[%ecx] := [o/172[%ebp] + 8]
  A/18[%eax] := [c/15[%esi] + 8]
  R/7[%tos] := float64u[A/18[%eax]]
  R/7[%tos] := R/7[%tos] -f float64[A/17[%ecx]]
  float64u[A/16[%ebx]] := R/7[%tos]
  A/21[%edx] := A/16[%ebx] + 12
  [A/21[%edx] + -4] := 2301
  A/22[%ecx] := [o/172[%ebp] + 4]
  A/23[%eax] := [c/15[%esi] + 4]
  R/7[%tos] := float64u[A/23[%eax]]
  R/7[%tos] := R/7[%tos] -f float64[A/22[%ecx]]
  float64u[A/21[%edx]] := R/7[%tos]
  A/26[%ecx] := A/16[%ebx] + 24
  [A/26[%ecx] + -4] := 2301
  A/27[%edi] := [o/172[%ebp]]
  A/28[%eax] := [c/15[%esi]]
  R/7[%tos] := float64u[A/28[%eax]]
  R/7[%tos] := R/7[%tos] -f float64[A/27[%edi]]
  float64u[A/26[%ecx]] := R/7[%tos]
  v/31[%eax] := A/16[%ebx] + 36
  [v/31[%eax] + -4] := 3072
  [v/31[%eax]] := A/26[%ecx]
  [v/31[%eax] + 4] := A/21[%edx]
  [v/31[%eax] + 8] := A/16[%ebx]
  d/173[%ebx] := spilled-d/170[s1] (reload)
  A/32[%edx] := [d/173[%ebx] + 4]
  A/33[%ecx] := [v/31[%eax] + 4]
  R/7[%tos] := float64u[A/33[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[A/32[%edx]]
  A/36[%edx] := [d/173[%ebx]]
  A/37[%ecx] := [v/31[%eax]]
  R/7[%tos] := float64u[A/37[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[A/36[%edx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/41[%edx] := [d/173[%ebx] + 8]
  A/42[%ecx] := [v/31[%eax] + 8]
  R/7[%tos] := float64u[A/42[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[A/41[%edx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  b/46[s2] := R/7[%tos]
  A/47[%edx] := [v/31[%eax] + 4]
  A/48[%ecx] := [v/31[%eax] + 4]
  R/7[%tos] := float64u[A/48[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[A/47[%edx]]
  A/51[%edx] := [v/31[%eax]]
  A/52[%ecx] := [v/31[%eax]]
  R/7[%tos] := float64u[A/52[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[A/51[%edx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/56[%ecx] := [v/31[%eax] + 8]
  A/57[%eax] := [v/31[%eax] + 8]
  R/7[%tos] := float64u[A/57[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/56[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := b/46[s2] *f b/46[s2]
  R/7[%tos] := R/7[%tos] -f R/7[%tos]
  r/174[%eax] := spilled-r/169[s2] (reload)
  R/7[%tos] := float64u[r/174[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[r/174[%eax]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {c/15[%esi]* b/46[s2] spilled-hit/164[s5]* spilled-s/165[s4]*
   spilled-env/166[s3]* o/172[%ebp]* d/173[%ebx]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  disc/66[s0] := R/7[%tos]
  R/7[%tos] := b/46[s2] -f disc/66[s0]
  t1/68[s1] := R/7[%tos]
  R/7[%tos] := b/46[s2] +f disc/66[s0]
  t2/70[s0] := R/7[%tos]
  R/7[%tos] := 0.
  if not t2/70[s0] >f R/7[%tos] goto L125
  R/7[%tos] := 0.
  if not t1/68[s1] >f R/7[%tos] goto L126
  {c/15[%esi]* t1/68[s1] spilled-hit/164[s5]* spilled-s/165[s4]*
   spilled-env/166[s3]* o/172[%ebp]* d/173[%ebx]*}
  l'/73[%edx] := alloc 12
  [l'/73[%edx] + -4] := 2301
  float64u[l'/73[%edx]] := t1/68[s1]
  goto L124
  L126 [2]:
  {c/15[%esi]* t2/70[s0] spilled-hit/164[s5]* spilled-s/165[s4]*
   spilled-env/166[s3]* o/172[%ebp]* d/173[%ebx]*}
  A/74[%edx] := alloc 12
  [A/74[%edx] + -4] := 2301
  float64u[A/74[%edx]] := t2/70[s0]
  goto L124
  L125 [2]:
  A/75[%edx] := ["camlPervasives" + 36]
  L124 [4]:
  hit/175[%ecx] := spilled-hit/164[s5] (reload)
  A/76[%eax] := [hit/175[%ecx]]
  R/7[%tos] := float64u[A/76[%eax]]
  R/7[%tos] := float64u[l'/73[%edx]]
  if not R/7[%tos] >=f R/7[%tos] goto L123
  R/0[%eax] := hit/175[%ecx]
  reload retaddr
  return R/0[%eax]
  L123 [2]:
  s/176[%eax] := spilled-s/165[s4] (reload)
  if s/176[%eax] ==s 1 goto L120
  spilled-s/165[s4] := s/176[%eax] (spill)
  spilled-hit/164[s5] := hit/175[%ecx] (spill)
  R/0[%eax] := o/172[%ebp]
  env/177[%ecx] := spilled-env/166[s3] (reload)
  {spilled-hit/164[s5]* spilled-s/165[s4]*}
  R/0[%eax] := call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  spilled-f/163[s0] := f/153[%eax] (spill)
  s/178[%ebx] := spilled-s/165[s4] (reload)
  hit/179[%eax] := spilled-hit/164[s5] (reload)
  L122 [3]:
  if l/154[%ebx] ==s 1 goto L121
  l/157[%ecx] := [l/154[%ebx] + 4]
  spilled-l/162[s1] := l/157[%ecx] (spill)
  a/158[%ebx] := [l/154[%ebx]]
  f/180[%ecx] := spilled-f/163[s0] (reload)
  {spilled-l/162[s1]* spilled-f/163[s0]*}
  R/0[%eax] := call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx] {list.ml:74,24-34}
  l/181[%ebx] := spilled-l/162[s1] (reload)
  goto L122
  L121 [2]:
  reload retaddr
  return R/0[%eax]
  L120 [2]:
  spilled-l'/167[s1] := l'/73[%edx] (spill)
  spilled-c/168[s0] := c/15[%esi] (spill)
  {l'/73[%edx]* spilled-l'/167[s1]* spilled-c/168[s0]* o/172[%ebp]*
   d/173[%ebx]*}
  A/79[%esi] := alloc 156
  [A/79[%esi] + -4] := 2301
  A/80[%eax] := [d/173[%ebx] + 8]
  R/7[%tos] := float64u[l'/73[%edx]]
  R/7[%tos] := R/7[%tos] *f float64[A/80[%eax]]
  float64u[A/79[%esi]] := R/7[%tos]
  A/83[%edi] := A/79[%esi] + 12
  [A/83[%edi] + -4] := 2301
  A/84[%eax] := [d/173[%ebx] + 4]
  R/7[%tos] := float64u[l'/73[%edx]]
  R/7[%tos] := R/7[%tos] *f float64[A/84[%eax]]
  float64u[A/83[%edi]] := R/7[%tos]
  A/87[%ecx] := A/79[%esi] + 24
  [A/87[%ecx] + -4] := 2301
  A/88[%eax] := [d/173[%ebx]]
  R/7[%tos] := float64u[l'/73[%edx]]
  R/7[%tos] := R/7[%tos] *f float64[A/88[%eax]]
  float64u[A/87[%ecx]] := R/7[%tos]
  param/91[%eax] := A/79[%esi] + 36
  [param/91[%eax] + -4] := 3072
  [param/91[%eax]] := A/87[%ecx]
  [param/91[%eax] + 4] := A/83[%edi]
  [param/91[%eax] + 8] := A/79[%esi]
  A/92[%edx] := A/79[%esi] + 52
  [A/92[%edx] + -4] := 2301
  A/93[%ecx] := [param/91[%eax] + 8]
  A/94[%ebx] := [o/172[%ebp] + 8]
  R/7[%tos] := float64u[A/94[%ebx]]
  R/7[%tos] := R/7[%tos] +f float64[A/93[%ecx]]
  float64u[A/92[%edx]] := R/7[%tos]
  A/97[%ecx] := A/79[%esi] + 64
  [A/97[%ecx] + -4] := 2301
  A/98[%edi] := [param/91[%eax] + 4]
  A/99[%ebx] := [o/172[%ebp] + 4]
  R/7[%tos] := float64u[A/99[%ebx]]
  R/7[%tos] := R/7[%tos] +f float64[A/98[%edi]]
  float64u[A/97[%ecx]] := R/7[%tos]
  A/102[%ebx] := A/79[%esi] + 76
  [A/102[%ebx] + -4] := 2301
  A/103[%edi] := [param/91[%eax]]
  A/104[%eax] := [o/172[%ebp]]
  R/7[%tos] := float64u[A/104[%eax]]
  R/7[%tos] := R/7[%tos] +f float64[A/103[%edi]]
  float64u[A/102[%ebx]] := R/7[%tos]
  param/107[%eax] := A/79[%esi] + 88
  [param/107[%eax] + -4] := 3072
  [param/107[%eax]] := A/102[%ebx]
  [param/107[%eax] + 4] := A/97[%ecx]
  [param/107[%eax] + 8] := A/92[%edx]
  A/108[%edi] := A/79[%esi] + 104
  [A/108[%edi] + -4] := 2301
  c/182[%ebx] := spilled-c/168[s0] (reload)
  A/109[%edx] := [c/182[%ebx] + 8]
  A/110[%ecx] := [param/107[%eax] + 8]
  R/7[%tos] := float64u[A/110[%ecx]]
  R/7[%tos] := R/7[%tos] -f float64[A/109[%edx]]
  float64u[A/108[%edi]] := R/7[%tos]
  A/113[%edx] := A/79[%esi] + 116
  [A/113[%edx] + -4] := 2301
  A/114[%ebp] := [c/182[%ebx] + 4]
  A/115[%ecx] := [param/107[%eax] + 4]
  R/7[%tos] := float64u[A/115[%ecx]]
  R/7[%tos] := R/7[%tos] -f float64[A/114[%ebp]]
  float64u[A/113[%edx]] := R/7[%tos]
  A/118[%ecx] := A/79[%esi] + 128
  [A/118[%ecx] + -4] := 2301
  A/119[%ebx] := [c/182[%ebx]]
  A/120[%eax] := [param/107[%eax]]
  R/7[%tos] := float64u[A/120[%eax]]
  R/7[%tos] := R/7[%tos] -f float64[A/119[%ebx]]
  float64u[A/118[%ecx]] := R/7[%tos]
  r/123[%ebx] := A/79[%esi] + 140
  [r/123[%ebx] + -4] := 3072
  [r/123[%ebx]] := A/118[%ecx]
  [r/123[%ebx] + 4] := A/113[%edx]
  [r/123[%ebx] + 8] := A/108[%edi]
  A/124[%ecx] := [r/123[%ebx] + 4]
  A/125[%eax] := [r/123[%ebx] + 4]
  R/7[%tos] := float64u[A/125[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/124[%ecx]]
  A/128[%ecx] := [r/123[%ebx]]
  A/129[%eax] := [r/123[%ebx]]
  R/7[%tos] := float64u[A/129[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/128[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/133[%ecx] := [r/123[%ebx] + 8]
  A/134[%eax] := [r/123[%ebx] + 8]
  R/7[%tos] := float64u[A/134[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/133[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {r/123[%ebx]* spilled-l'/167[s1]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/138[s0] := R/7[%tos]
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] /f F/138[s0]
  s/141[s0] := R/7[%tos]
  {r/123[%ebx]* s/141[s0] spilled-l'/167[s1]*}
  A/142[%eax] := alloc 64
  [A/142[%eax] + -4] := 2301
  A/143[%ecx] := [r/123[%ebx] + 8]
  R/7[%tos] := s/141[s0] *f float64[A/143[%ecx]]
  float64u[A/142[%eax]] := R/7[%tos]
  A/145[%esi] := A/142[%eax] + 12
  [A/145[%esi] + -4] := 2301
  A/146[%ecx] := [r/123[%ebx] + 4]
  R/7[%tos] := s/141[s0] *f float64[A/146[%ecx]]
  float64u[A/145[%esi]] := R/7[%tos]
  A/148[%edx] := A/142[%eax] + 24
  [A/148[%edx] + -4] := 2301
  A/149[%ebx] := [r/123[%ebx]]
  R/7[%tos] := s/141[s0] *f float64[A/149[%ebx]]
  float64u[A/148[%edx]] := R/7[%tos]
  A/151[%ecx] := A/142[%eax] + 36
  [A/151[%ecx] + -4] := 3072
  [A/151[%ecx]] := A/148[%edx]
  [A/151[%ecx] + 4] := A/145[%esi]
  [A/151[%ecx] + 8] := A/142[%eax]
  A/152[%eax] := A/142[%eax] + 52
  [A/152[%eax] + -4] := 2048
  l'/183[%ebx] := spilled-l'/167[s1] (reload)
  [A/152[%eax]] := l'/183[%ebx]
  [A/152[%eax] + 4] := A/151[%ecx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__create_1077:
                  level/8[%edi] := R/0[%eax]
                  r/10[%esi] := R/2[%ecx]
                  {level/8[%edi]* c/9[%ebx]* r/10[%esi]* env/11[%edx]*}
                  obj/12[%eax] := alloc 16
                  [obj/12[%eax] + -4] := 3072
                  [obj/12[%eax]] := c/9[%ebx]
                  [obj/12[%eax] + 4] := r/10[%esi]
                  [obj/12[%eax] + 8] := 1
                  if level/8[%edi] !=s 3 goto L145
                  reload retaddr
                  return R/0[%eax]
                  L145 [0]:
                  spilled-obj/98[s4] := obj/12[%eax] (spill)
                  spilled-env/100[s3] := env/11[%edx] (spill)
                  spilled-r/97[s5] := r/10[%esi] (spill)
                  spilled-c/96[s6] := c/9[%ebx] (spill)
                  spilled-level/101[s2] := level/8[%edi] (spill)
                  R/7[%tos] := 12.
                  push R/7[%tos]
                  {c/9[%ebx]* r/10[%esi]* spilled-c/96[s6]* spilled-r/97[s5]*
                   spilled-obj/98[s4]* spilled-env/100[s3]*
                   spilled-level/101[s2]*}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  F/14[s0] := R/7[%tos]
                  R/7[%tos] := 3.
                  R/7[%tos] := R/7[%tos] *f float64[r/10[%esi]]
                  R/7[%tos] := F/14[s0] /f(rev) R/7[%tos]
                  a/18[s0] := R/7[%tos]
                  {c/9[%ebx]* r/10[%esi]* a/18[s0] spilled-c/96[s6]*
                   spilled-r/97[s5]* spilled-obj/98[s4]* spilled-env/100[s3]*
                   spilled-level/101[s2]* spilled-a/102[s0]}
                  A/19[%ecx] := alloc 64
                  [A/19[%ecx] + -4] := 2301
                  R/7[%tos] := 0.5
                  R/7[%tos] := R/7[%tos] *f float64[r/10[%esi]]
                  float64u[A/19[%ecx]] := R/7[%tos]
                  A/22[%edx] := A/19[%ecx] + 12
                  [A/22[%edx] + -4] := 2301
                  A/23[%eax] := [c/9[%ebx] + 8]
                  R/7[%tos] := a/18[s0] +f float64[A/23[%eax]]
                  float64u[A/22[%edx]] := R/7[%tos]
                  A/25[%eax] := A/19[%ecx] + 24
                  [A/25[%eax] + -4] := 2301
                  A/26[%esi] := [c/9[%ebx] + 4]
                  R/7[%tos] := a/18[s0] +f float64[A/26[%esi]]
                  float64u[A/25[%eax]] := R/7[%tos]
                  A/28[%esi] := A/19[%ecx] + 36
                  [A/28[%esi] + -4] := 2301
                  A/29[%ebx] := [c/9[%ebx]]
                  R/7[%tos] := a/18[s0] +f float64[A/29[%ebx]]
                  float64u[A/28[%esi]] := R/7[%tos]
                  A/31[%ebx] := A/19[%ecx] + 48
                  [A/31[%ebx] + -4] := 3072
                  [A/31[%ebx]] := A/28[%esi]
                  [A/31[%ebx] + 4] := A/25[%eax]
                  [A/31[%ebx] + 8] := A/22[%edx]
                  level/105[%eax] := spilled-level/101[s2] (reload)
                  I/32[%eax] := I/32[%eax] + -2
                  env/106[%edx] := spilled-env/100[s3] (reload)
                  {spilled-c/96[s6]* spilled-r/97[s5]* spilled-obj/98[s4]*
                   spilled-env/100[s3]* spilled-level/101[s2]*
                   spilled-a/102[s0]}
                  R/0[%eax] := call "camlCode__create_1077" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  A/33[%ebx] := R/0[%eax]
                  {A/33[%ebx]* spilled-c/96[s6]* spilled-r/97[s5]*
                   spilled-obj/98[s4]* spilled-env/100[s3]*
                   spilled-level/101[s2]* spilled-a/102[s0]}
                  A/34[%eax] := alloc 76
                  A/104[s0] := A/34[%eax] (spill)
                  [A/34[%eax] + -4] := 2048
                  [A/34[%eax]] := A/33[%ebx]
                  [A/34[%eax] + 4] := 1
                  R/7[%tos] := -f a/107[s0]
                  x'/36[s1] := R/7[%tos]
                  A/37[%ecx] := A/34[%eax] + 12
                  [A/37[%ecx] + -4] := 2301
                  R/7[%tos] := 0.5
                  r/108[%ebx] := spilled-r/97[s5] (reload)
                  R/7[%tos] := R/7[%tos] *f float64[r/108[%ebx]]
                  float64u[A/37[%ecx]] := R/7[%tos]
                  A/40[%edi] := A/34[%eax] + 24
                  [A/40[%edi] + -4] := 2301
                  c/109[%ebx] := spilled-c/96[s6] (reload)
                  A/41[%edx] := [c/109[%ebx] + 8]
                  R/7[%tos] := a/107[s0] +f float64[A/41[%edx]]
                  float64u[A/40[%edi]] := R/7[%tos]
                  A/43[%esi] := A/34[%eax] + 36
                  [A/43[%esi] + -4] := 2301
                  A/44[%edx] := [c/109[%ebx] + 4]
                  R/7[%tos] := a/107[s0] +f float64[A/44[%edx]]
                  float64u[A/43[%esi]] := R/7[%tos]
                  A/46[%edx] := A/34[%eax] + 48
                  [A/46[%edx] + -4] := 2301
                  A/47[%ebx] := [c/109[%ebx]]
                  R/7[%tos] := x'/36[s1] +f float64[A/47[%ebx]]
                  float64u[A/46[%edx]] := R/7[%tos]
                  A/49[%ebx] := A/34[%eax] + 60
                  [A/49[%ebx] + -4] := 3072
                  [A/49[%ebx]] := A/46[%edx]
                  [A/49[%ebx] + 4] := A/43[%esi]
                  [A/49[%ebx] + 8] := A/40[%edi]
                  level/110[%eax] := spilled-level/101[s2] (reload)
                  I/50[%eax] := I/50[%eax] + -2
                  env/111[%edx] := spilled-env/100[s3] (reload)
                  {spilled-c/96[s6]* spilled-r/97[s5]* spilled-obj/98[s4]*
                   spilled-env/100[s3]* spilled-level/101[s2]*
                   spilled-a/102[s0] A/104[s0]*}
                  R/0[%eax] := call "camlCode__create_1077" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  A/51[%ebx] := R/0[%eax]
                  {A/51[%ebx]* spilled-c/96[s6]* spilled-r/97[s5]*
                   spilled-obj/98[s4]* spilled-env/100[s3]*
                   spilled-level/101[s2]* spilled-a/102[s0] A/104[s0]*}
                  A/52[%eax] := alloc 76
                  A/103[s1] := A/52[%eax] (spill)
                  [A/52[%eax] + -4] := 2048
                  [A/52[%eax]] := A/51[%ebx]
                  A/112[%ebx] := A/104[s0] (reload)
                  [A/52[%eax] + 4] := A/112[%ebx]
                  R/7[%tos] := -f a/113[s0]
                  z'/54[s1] := R/7[%tos]
                  A/55[%ecx] := A/52[%eax] + 12
                  [A/55[%ecx] + -4] := 2301
                  R/7[%tos] := 0.5
                  r/114[%ebx] := spilled-r/97[s5] (reload)
                  R/7[%tos] := R/7[%tos] *f float64[r/114[%ebx]]
                  float64u[A/55[%ecx]] := R/7[%tos]
                  A/58[%edi] := A/52[%eax] + 24
                  [A/58[%edi] + -4] := 2301
                  c/115[%ebx] := spilled-c/96[s6] (reload)
                  A/59[%edx] := [c/115[%ebx] + 8]
                  R/7[%tos] := z'/54[s1] +f float64[A/59[%edx]]
                  float64u[A/58[%edi]] := R/7[%tos]
                  A/61[%esi] := A/52[%eax] + 36
                  [A/61[%esi] + -4] := 2301
                  A/62[%edx] := [c/115[%ebx] + 4]
                  R/7[%tos] := a/113[s0] +f float64[A/62[%edx]]
                  float64u[A/61[%esi]] := R/7[%tos]
                  A/64[%edx] := A/52[%eax] + 48
                  [A/64[%edx] + -4] := 2301
                  A/65[%ebx] := [c/115[%ebx]]
                  R/7[%tos] := a/113[s0] +f float64[A/65[%ebx]]
                  float64u[A/64[%edx]] := R/7[%tos]
                  A/67[%ebx] := A/52[%eax] + 60
                  [A/67[%ebx] + -4] := 3072
                  [A/67[%ebx]] := A/64[%edx]
                  [A/67[%ebx] + 4] := A/61[%esi]
                  [A/67[%ebx] + 8] := A/58[%edi]
                  level/116[%eax] := spilled-level/101[s2] (reload)
                  I/68[%eax] := I/68[%eax] + -2
                  env/117[%edx] := spilled-env/100[s3] (reload)
                  {spilled-c/96[s6]* spilled-r/97[s5]* spilled-obj/98[s4]*
                   spilled-env/100[s3]* spilled-level/101[s2]*
                   spilled-a/102[s0] A/103[s1]*}
                  R/0[%eax] := call "camlCode__create_1077" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  A/69[%ebx] := R/0[%eax]
                  {A/69[%ebx]* spilled-c/96[s6]* spilled-r/97[s5]*
                   spilled-obj/98[s4]* spilled-env/100[s3]*
                   spilled-level/101[s2]* spilled-a/102[s0] A/103[s1]*}
                  A/70[%eax] := alloc 76
                  A/99[s0] := A/70[%eax] (spill)
                  [A/70[%eax] + -4] := 2048
                  [A/70[%eax]] := A/69[%ebx]
                  A/118[%ebx] := A/103[s1] (reload)
                  [A/70[%eax] + 4] := A/118[%ebx]
                  R/7[%tos] := -f a/119[s0]
                  z'/72[s2] := R/7[%tos]
                  R/7[%tos] := -f a/119[s0]
                  x'/74[s1] := R/7[%tos]
                  A/75[%ecx] := A/70[%eax] + 12
                  [A/75[%ecx] + -4] := 2301
                  R/7[%tos] := 0.5
                  r/120[%ebx] := spilled-r/97[s5] (reload)
                  R/7[%tos] := R/7[%tos] *f float64[r/120[%ebx]]
                  float64u[A/75[%ecx]] := R/7[%tos]
                  A/78[%edi] := A/70[%eax] + 24
                  [A/78[%edi] + -4] := 2301
                  c/121[%ebx] := spilled-c/96[s6] (reload)
                  A/79[%edx] := [c/121[%ebx] + 8]
                  R/7[%tos] := z'/72[s2] +f float64[A/79[%edx]]
                  float64u[A/78[%edi]] := R/7[%tos]
                  A/81[%esi] := A/70[%eax] + 36
                  [A/81[%esi] + -4] := 2301
                  A/82[%edx] := [c/121[%ebx] + 4]
                  R/7[%tos] := a/119[s0] +f float64[A/82[%edx]]
                  float64u[A/81[%esi]] := R/7[%tos]
                  A/84[%edx] := A/70[%eax] + 48
                  [A/84[%edx] + -4] := 2301
                  A/85[%ebx] := [c/121[%ebx]]
                  R/7[%tos] := x'/74[s1] +f float64[A/85[%ebx]]
                  float64u[A/84[%edx]] := R/7[%tos]
                  A/87[%ebx] := A/70[%eax] + 60
                  [A/87[%ebx] + -4] := 3072
                  [A/87[%ebx]] := A/84[%edx]
                  [A/87[%ebx] + 4] := A/81[%esi]
                  [A/87[%ebx] + 8] := A/78[%edi]
                  level/122[%eax] := spilled-level/101[s2] (reload)
                  I/88[%eax] := I/88[%eax] + -2
                  env/123[%edx] := spilled-env/100[s3] (reload)
                  {spilled-c/96[s6]* spilled-r/97[s5]* spilled-obj/98[s4]*
                   A/99[s0]*}
                  R/0[%eax] := call "camlCode__create_1077" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  A/89[%ecx] := R/0[%eax]
                  {A/89[%ecx]* spilled-c/96[s6]* spilled-r/97[s5]*
                   spilled-obj/98[s4]* A/99[s0]*}
                  A/90[%ebx] := alloc 52
                  [A/90[%ebx] + -4] := 2048
                  [A/90[%ebx]] := A/89[%ecx]
                  A/124[%eax] := A/99[s0] (reload)
                  [A/90[%ebx] + 4] := A/124[%eax]
                  A/91[%edx] := A/90[%ebx] + 12
                  [A/91[%edx] + -4] := 2048
                  obj/125[%eax] := spilled-obj/98[s4] (reload)
                  [A/91[%edx]] := obj/125[%eax]
                  [A/91[%edx] + 4] := A/90[%ebx]
                  A/92[%ecx] := A/90[%ebx] + 24
                  [A/92[%ecx] + -4] := 2301
                  R/7[%tos] := 3.
                  r/126[%eax] := spilled-r/97[s5] (reload)
                  R/7[%tos] := R/7[%tos] *f float64[r/126[%eax]]
                  float64u[A/92[%ecx]] := R/7[%tos]
                  A/95[%eax] := A/90[%ebx] + 36
                  [A/95[%eax] + -4] := 3072
                  c/127[%ebx] := spilled-c/96[s6] (reload)
                  [A/95[%eax]] := c/127[%ebx]
                  [A/95[%eax] + 4] := A/92[%ecx]
                  [A/95[%eax] + 8] := A/91[%edx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__create_1077:
  level/8[%edi] := R/0[%eax]
  r/10[%esi] := R/2[%ecx]
  {level/8[%edi]* c/9[%ebx]* r/10[%esi]* env/11[%edx]*}
  obj/12[%eax] := alloc 16
  [obj/12[%eax] + -4] := 3072
  [obj/12[%eax]] := c/9[%ebx]
  [obj/12[%eax] + 4] := r/10[%esi]
  [obj/12[%eax] + 8] := 1
  if level/8[%edi] !=s 3 goto L145
  reload retaddr
  return R/0[%eax]
  L145 [2]:
  spilled-obj/98[s4] := obj/12[%eax] (spill)
  spilled-env/100[s3] := env/11[%edx] (spill)
  spilled-r/97[s5] := r/10[%esi] (spill)
  spilled-c/96[s6] := c/9[%ebx] (spill)
  spilled-level/101[s2] := level/8[%edi] (spill)
  R/7[%tos] := 12.
  push R/7[%tos]
  {c/9[%ebx]* r/10[%esi]* spilled-c/96[s6]* spilled-r/97[s5]*
   spilled-obj/98[s4]* spilled-env/100[s3]* spilled-level/101[s2]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/14[s0] := R/7[%tos]
  R/7[%tos] := 3.
  R/7[%tos] := R/7[%tos] *f float64[r/10[%esi]]
  R/7[%tos] := F/14[s0] /f(rev) R/7[%tos]
  a/18[s0] := R/7[%tos]
  {c/9[%ebx]* r/10[%esi]* a/18[s0] spilled-c/96[s6]* spilled-r/97[s5]*
   spilled-obj/98[s4]* spilled-env/100[s3]* spilled-level/101[s2]*
   spilled-a/102[s0]}
  A/19[%ecx] := alloc 64
  [A/19[%ecx] + -4] := 2301
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] *f float64[r/10[%esi]]
  float64u[A/19[%ecx]] := R/7[%tos]
  A/22[%edx] := A/19[%ecx] + 12
  [A/22[%edx] + -4] := 2301
  A/23[%eax] := [c/9[%ebx] + 8]
  R/7[%tos] := a/18[s0] +f float64[A/23[%eax]]
  float64u[A/22[%edx]] := R/7[%tos]
  A/25[%eax] := A/19[%ecx] + 24
  [A/25[%eax] + -4] := 2301
  A/26[%esi] := [c/9[%ebx] + 4]
  R/7[%tos] := a/18[s0] +f float64[A/26[%esi]]
  float64u[A/25[%eax]] := R/7[%tos]
  A/28[%esi] := A/19[%ecx] + 36
  [A/28[%esi] + -4] := 2301
  A/29[%ebx] := [c/9[%ebx]]
  R/7[%tos] := a/18[s0] +f float64[A/29[%ebx]]
  float64u[A/28[%esi]] := R/7[%tos]
  A/31[%ebx] := A/19[%ecx] + 48
  [A/31[%ebx] + -4] := 3072
  [A/31[%ebx]] := A/28[%esi]
  [A/31[%ebx] + 4] := A/25[%eax]
  [A/31[%ebx] + 8] := A/22[%edx]
  level/105[%eax] := spilled-level/101[s2] (reload)
  I/32[%eax] := I/32[%eax] + -2
  env/106[%edx] := spilled-env/100[s3] (reload)
  {spilled-c/96[s6]* spilled-r/97[s5]* spilled-obj/98[s4]*
   spilled-env/100[s3]* spilled-level/101[s2]* spilled-a/102[s0]}
  R/0[%eax] := call "camlCode__create_1077" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/33[%ebx] := R/0[%eax]
  {A/33[%ebx]* spilled-c/96[s6]* spilled-r/97[s5]* spilled-obj/98[s4]*
   spilled-env/100[s3]* spilled-level/101[s2]* spilled-a/102[s0]}
  A/34[%eax] := alloc 76
  A/104[s0] := A/34[%eax] (spill)
  [A/34[%eax] + -4] := 2048
  [A/34[%eax]] := A/33[%ebx]
  [A/34[%eax] + 4] := 1
  R/7[%tos] := -f a/107[s0]
  x'/36[s1] := R/7[%tos]
  A/37[%ecx] := A/34[%eax] + 12
  [A/37[%ecx] + -4] := 2301
  R/7[%tos] := 0.5
  r/108[%ebx] := spilled-r/97[s5] (reload)
  R/7[%tos] := R/7[%tos] *f float64[r/108[%ebx]]
  float64u[A/37[%ecx]] := R/7[%tos]
  A/40[%edi] := A/34[%eax] + 24
  [A/40[%edi] + -4] := 2301
  c/109[%ebx] := spilled-c/96[s6] (reload)
  A/41[%edx] := [c/109[%ebx] + 8]
  R/7[%tos] := a/107[s0] +f float64[A/41[%edx]]
  float64u[A/40[%edi]] := R/7[%tos]
  A/43[%esi] := A/34[%eax] + 36
  [A/43[%esi] + -4] := 2301
  A/44[%edx] := [c/109[%ebx] + 4]
  R/7[%tos] := a/107[s0] +f float64[A/44[%edx]]
  float64u[A/43[%esi]] := R/7[%tos]
  A/46[%edx] := A/34[%eax] + 48
  [A/46[%edx] + -4] := 2301
  A/47[%ebx] := [c/109[%ebx]]
  R/7[%tos] := x'/36[s1] +f float64[A/47[%ebx]]
  float64u[A/46[%edx]] := R/7[%tos]
  A/49[%ebx] := A/34[%eax] + 60
  [A/49[%ebx] + -4] := 3072
  [A/49[%ebx]] := A/46[%edx]
  [A/49[%ebx] + 4] := A/43[%esi]
  [A/49[%ebx] + 8] := A/40[%edi]
  level/110[%eax] := spilled-level/101[s2] (reload)
  I/50[%eax] := I/50[%eax] + -2
  env/111[%edx] := spilled-env/100[s3] (reload)
  {spilled-c/96[s6]* spilled-r/97[s5]* spilled-obj/98[s4]*
   spilled-env/100[s3]* spilled-level/101[s2]* spilled-a/102[s0] A/104[s0]*}
  R/0[%eax] := call "camlCode__create_1077" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/51[%ebx] := R/0[%eax]
  {A/51[%ebx]* spilled-c/96[s6]* spilled-r/97[s5]* spilled-obj/98[s4]*
   spilled-env/100[s3]* spilled-level/101[s2]* spilled-a/102[s0] A/104[s0]*}
  A/52[%eax] := alloc 76
  A/103[s1] := A/52[%eax] (spill)
  [A/52[%eax] + -4] := 2048
  [A/52[%eax]] := A/51[%ebx]
  A/112[%ebx] := A/104[s0] (reload)
  [A/52[%eax] + 4] := A/112[%ebx]
  R/7[%tos] := -f a/113[s0]
  z'/54[s1] := R/7[%tos]
  A/55[%ecx] := A/52[%eax] + 12
  [A/55[%ecx] + -4] := 2301
  R/7[%tos] := 0.5
  r/114[%ebx] := spilled-r/97[s5] (reload)
  R/7[%tos] := R/7[%tos] *f float64[r/114[%ebx]]
  float64u[A/55[%ecx]] := R/7[%tos]
  A/58[%edi] := A/52[%eax] + 24
  [A/58[%edi] + -4] := 2301
  c/115[%ebx] := spilled-c/96[s6] (reload)
  A/59[%edx] := [c/115[%ebx] + 8]
  R/7[%tos] := z'/54[s1] +f float64[A/59[%edx]]
  float64u[A/58[%edi]] := R/7[%tos]
  A/61[%esi] := A/52[%eax] + 36
  [A/61[%esi] + -4] := 2301
  A/62[%edx] := [c/115[%ebx] + 4]
  R/7[%tos] := a/113[s0] +f float64[A/62[%edx]]
  float64u[A/61[%esi]] := R/7[%tos]
  A/64[%edx] := A/52[%eax] + 48
  [A/64[%edx] + -4] := 2301
  A/65[%ebx] := [c/115[%ebx]]
  R/7[%tos] := a/113[s0] +f float64[A/65[%ebx]]
  float64u[A/64[%edx]] := R/7[%tos]
  A/67[%ebx] := A/52[%eax] + 60
  [A/67[%ebx] + -4] := 3072
  [A/67[%ebx]] := A/64[%edx]
  [A/67[%ebx] + 4] := A/61[%esi]
  [A/67[%ebx] + 8] := A/58[%edi]
  level/116[%eax] := spilled-level/101[s2] (reload)
  I/68[%eax] := I/68[%eax] + -2
  env/117[%edx] := spilled-env/100[s3] (reload)
  {spilled-c/96[s6]* spilled-r/97[s5]* spilled-obj/98[s4]*
   spilled-env/100[s3]* spilled-level/101[s2]* spilled-a/102[s0] A/103[s1]*}
  R/0[%eax] := call "camlCode__create_1077" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/69[%ebx] := R/0[%eax]
  {A/69[%ebx]* spilled-c/96[s6]* spilled-r/97[s5]* spilled-obj/98[s4]*
   spilled-env/100[s3]* spilled-level/101[s2]* spilled-a/102[s0] A/103[s1]*}
  A/70[%eax] := alloc 76
  A/99[s0] := A/70[%eax] (spill)
  [A/70[%eax] + -4] := 2048
  [A/70[%eax]] := A/69[%ebx]
  A/118[%ebx] := A/103[s1] (reload)
  [A/70[%eax] + 4] := A/118[%ebx]
  R/7[%tos] := -f a/119[s0]
  z'/72[s2] := R/7[%tos]
  R/7[%tos] := -f a/119[s0]
  x'/74[s1] := R/7[%tos]
  A/75[%ecx] := A/70[%eax] + 12
  [A/75[%ecx] + -4] := 2301
  R/7[%tos] := 0.5
  r/120[%ebx] := spilled-r/97[s5] (reload)
  R/7[%tos] := R/7[%tos] *f float64[r/120[%ebx]]
  float64u[A/75[%ecx]] := R/7[%tos]
  A/78[%edi] := A/70[%eax] + 24
  [A/78[%edi] + -4] := 2301
  c/121[%ebx] := spilled-c/96[s6] (reload)
  A/79[%edx] := [c/121[%ebx] + 8]
  R/7[%tos] := z'/72[s2] +f float64[A/79[%edx]]
  float64u[A/78[%edi]] := R/7[%tos]
  A/81[%esi] := A/70[%eax] + 36
  [A/81[%esi] + -4] := 2301
  A/82[%edx] := [c/121[%ebx] + 4]
  R/7[%tos] := a/119[s0] +f float64[A/82[%edx]]
  float64u[A/81[%esi]] := R/7[%tos]
  A/84[%edx] := A/70[%eax] + 48
  [A/84[%edx] + -4] := 2301
  A/85[%ebx] := [c/121[%ebx]]
  R/7[%tos] := x'/74[s1] +f float64[A/85[%ebx]]
  float64u[A/84[%edx]] := R/7[%tos]
  A/87[%ebx] := A/70[%eax] + 60
  [A/87[%ebx] + -4] := 3072
  [A/87[%ebx]] := A/84[%edx]
  [A/87[%ebx] + 4] := A/81[%esi]
  [A/87[%ebx] + 8] := A/78[%edi]
  level/122[%eax] := spilled-level/101[s2] (reload)
  I/88[%eax] := I/88[%eax] + -2
  env/123[%edx] := spilled-env/100[s3] (reload)
  {spilled-c/96[s6]* spilled-r/97[s5]* spilled-obj/98[s4]* A/99[s0]*}
  R/0[%eax] := call "camlCode__create_1077" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/89[%ecx] := R/0[%eax]
  {A/89[%ecx]* spilled-c/96[s6]* spilled-r/97[s5]* spilled-obj/98[s4]*
   A/99[s0]*}
  A/90[%ebx] := alloc 52
  [A/90[%ebx] + -4] := 2048
  [A/90[%ebx]] := A/89[%ecx]
  A/124[%eax] := A/99[s0] (reload)
  [A/90[%ebx] + 4] := A/124[%eax]
  A/91[%edx] := A/90[%ebx] + 12
  [A/91[%edx] + -4] := 2048
  obj/125[%eax] := spilled-obj/98[s4] (reload)
  [A/91[%edx]] := obj/125[%eax]
  [A/91[%edx] + 4] := A/90[%ebx]
  A/92[%ecx] := A/90[%ebx] + 24
  [A/92[%ecx] + -4] := 2301
  R/7[%tos] := 3.
  r/126[%eax] := spilled-r/97[s5] (reload)
  R/7[%tos] := R/7[%tos] *f float64[r/126[%eax]]
  float64u[A/92[%ecx]] := R/7[%tos]
  A/95[%eax] := A/90[%ebx] + 36
  [A/95[%eax] + -4] := 3072
  c/127[%ebx] := spilled-c/96[s6] (reload)
  [A/95[%eax]] := c/127[%ebx]
  [A/95[%eax] + 4] := A/92[%ecx]
  [A/95[%eax] + 8] := A/91[%edx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__ray_trace_1089:
                  dir/8[%ebx] := R/0[%eax]
                  spilled-dir/92[s0] := dir/8[%ebx] (spill)
                  {dir/8[%ebx]* spilled-dir/92[s0]*}
                  A/9[%ecx] := alloc 12
                  [A/9[%ecx] + -4] := 2048
                  A/10[%eax] := ["camlPervasives" + 36]
                  [A/9[%ecx]] := A/10[%eax]
                  A/11[%eax] := ["camlCode"]
                  [A/9[%ecx] + 4] := A/11[%eax]
                  A/12[%esi] := ["camlCode" + 24]
                  A/13[%edx] := ["camlCode" + 48]
                  A/14[%eax] := ["camlCode"]
                  {spilled-dir/92[s0]*}
                  R/0[%eax] := call "camlCode__intersect_1060" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
                  match/15[%esi] := R/0[%eax]
                  n/16[%ebx] := [match/15[%esi] + 4]
                  param/17[%edx] := ["camlCode" + 28]
                  A/18[%ecx] := [param/17[%edx] + 4]
                  A/19[%eax] := [n/16[%ebx] + 4]
                  R/7[%tos] := float64u[A/19[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/18[%ecx]]
                  A/22[%ecx] := [param/17[%edx]]
                  A/23[%eax] := [n/16[%ebx]]
                  R/7[%tos] := float64u[A/23[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/22[%ecx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  A/27[%ecx] := [param/17[%edx] + 8]
                  A/28[%eax] := [n/16[%ebx] + 8]
                  R/7[%tos] := float64u[A/28[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/27[%ecx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  g/32[s0] := R/7[%tos]
                  R/7[%tos] := 0.
                  if not g/32[s0] <=f R/7[%tos] goto L177
                  A/90[%eax] := "camlCode__19"
                  reload retaddr
                  return R/0[%eax]
                  L177 [0]:
                  A/34[%eax] := ["camlPervasives" + 56]
                  pushfloat [A/34[%eax]]
                  {match/15[%esi]* n/16[%ebx]* spilled-g/91[s0]
                   spilled-dir/92[s0]*}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  s/35[s1] := R/7[%tos]
                  {match/15[%esi]* n/16[%ebx]* s/35[s1] spilled-g/91[s0]
                   spilled-dir/92[s0]*}
                  A/36[%ecx] := alloc 168
                  [A/36[%ecx] + -4] := 2301
                  A/37[%eax] := [n/16[%ebx] + 8]
                  R/7[%tos] := s/35[s1] *f float64[A/37[%eax]]
                  float64u[A/36[%ecx]] := R/7[%tos]
                  A/39[%eax] := A/36[%ecx] + 12
                  [A/39[%eax] + -4] := 2301
                  A/40[%edx] := [n/16[%ebx] + 4]
                  R/7[%tos] := s/35[s1] *f float64[A/40[%edx]]
                  float64u[A/39[%eax]] := R/7[%tos]
                  A/42[%edx] := A/36[%ecx] + 24
                  [A/42[%edx] + -4] := 2301
                  A/43[%ebx] := [n/16[%ebx]]
                  R/7[%tos] := s/35[s1] *f float64[A/43[%ebx]]
                  float64u[A/42[%edx]] := R/7[%tos]
                  param/45[%ebp] := A/36[%ecx] + 36
                  [param/45[%ebp] + -4] := 3072
                  [param/45[%ebp]] := A/42[%edx]
                  [param/45[%ebp] + 4] := A/39[%eax]
                  [param/45[%ebp] + 8] := A/36[%ecx]
                  s/46[%esi] := [match/15[%esi]]
                  A/47[%edi] := A/36[%ecx] + 52
                  [A/47[%edi] + -4] := 2301
                  dir/93[%eax] := spilled-dir/92[s0] (reload)
                  A/48[%ebx] := [dir/93[%eax] + 8]
                  R/7[%tos] := float64u[s/46[%esi]]
                  R/7[%tos] := R/7[%tos] *f float64[A/48[%ebx]]
                  float64u[A/47[%edi]] := R/7[%tos]
                  A/51[%edx] := A/36[%ecx] + 64
                  [A/51[%edx] + -4] := 2301
                  A/52[%ebx] := [dir/93[%eax] + 4]
                  R/7[%tos] := float64u[s/46[%esi]]
                  R/7[%tos] := R/7[%tos] *f float64[A/52[%ebx]]
                  float64u[A/51[%edx]] := R/7[%tos]
                  A/55[%ebx] := A/36[%ecx] + 76
                  [A/55[%ebx] + -4] := 2301
                  A/56[%eax] := [dir/93[%eax]]
                  R/7[%tos] := float64u[s/46[%esi]]
                  R/7[%tos] := R/7[%tos] *f float64[A/56[%eax]]
                  float64u[A/55[%ebx]] := R/7[%tos]
                  param/59[%eax] := A/36[%ecx] + 88
                  [param/59[%eax] + -4] := 3072
                  [param/59[%eax]] := A/55[%ebx]
                  [param/59[%eax] + 4] := A/51[%edx]
                  [param/59[%eax] + 8] := A/47[%edi]
                  A/60[%esi] := A/36[%ecx] + 104
                  [A/60[%esi] + -4] := 2301
                  A/61[%edx] := [param/45[%ebp] + 8]
                  A/62[%ebx] := [param/59[%eax] + 8]
                  R/7[%tos] := float64u[A/62[%ebx]]
                  R/7[%tos] := R/7[%tos] +f float64[A/61[%edx]]
                  float64u[A/60[%esi]] := R/7[%tos]
                  A/65[%edx] := A/36[%ecx] + 116
                  [A/65[%edx] + -4] := 2301
                  A/66[%edi] := [param/45[%ebp] + 4]
                  A/67[%ebx] := [param/59[%eax] + 4]
                  R/7[%tos] := float64u[A/67[%ebx]]
                  R/7[%tos] := R/7[%tos] +f float64[A/66[%edi]]
                  float64u[A/65[%edx]] := R/7[%tos]
                  A/70[%ebx] := A/36[%ecx] + 128
                  [A/70[%ebx] + -4] := 2301
                  A/71[%edi] := [param/45[%ebp]]
                  A/72[%eax] := [param/59[%eax]]
                  R/7[%tos] := float64u[A/72[%eax]]
                  R/7[%tos] := R/7[%tos] +f float64[A/71[%edi]]
                  float64u[A/70[%ebx]] := R/7[%tos]
                  p/75[%eax] := A/36[%ecx] + 140
                  [p/75[%eax] + -4] := 3072
                  [p/75[%eax]] := A/70[%ebx]
                  [p/75[%eax] + 4] := A/65[%edx]
                  [p/75[%eax] + 8] := A/60[%esi]
                  A/76[%ecx] := A/36[%ecx] + 156
                  [A/76[%ecx] + -4] := 2048
                  A/77[%ebx] := ["camlPervasives" + 36]
                  [A/76[%ecx]] := A/77[%ebx]
                  A/78[%ebx] := ["camlCode"]
                  [A/76[%ecx] + 4] := A/78[%ebx]
                  A/79[%esi] := ["camlCode" + 24]
                  A/80[%edx] := ["camlCode" + 48]
                  A/81[%ebx] := ["camlCode" + 28]
                  {spilled-g/91[s0]}
                  R/0[%eax] := call "camlCode__intersect_1060" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
                  A/83[%eax] := [A/82[%eax]]
                  R/7[%tos] := float64u[A/83[%eax]]
                  F/85[s1] := R/7[%tos]
                  A/86[%eax] := ["camlPervasives" + 36]
                  R/7[%tos] := float64u[A/86[%eax]]
                  if not F/85[s1] <f R/7[%tos] goto L176
                  A/89[%eax] := "camlCode__18"
                  reload retaddr
                  return R/0[%eax]
                  L176 [0]:
                  {spilled-g/91[s0]}
                  A/88[%eax] := alloc 12
                  [A/88[%eax] + -4] := 2301
                  float64u[A/88[%eax]] := g/94[s0]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__ray_trace_1089:
  dir/8[%ebx] := R/0[%eax]
  spilled-dir/92[s0] := dir/8[%ebx] (spill)
  {dir/8[%ebx]* spilled-dir/92[s0]*}
  A/9[%ecx] := alloc 12
  [A/9[%ecx] + -4] := 2048
  A/10[%eax] := ["camlPervasives" + 36]
  [A/9[%ecx]] := A/10[%eax]
  A/11[%eax] := ["camlCode"]
  [A/9[%ecx] + 4] := A/11[%eax]
  A/12[%esi] := ["camlCode" + 24]
  A/13[%edx] := ["camlCode" + 48]
  A/14[%eax] := ["camlCode"]
  {spilled-dir/92[s0]*}
  R/0[%eax] := call "camlCode__intersect_1060" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
  match/15[%esi] := R/0[%eax]
  n/16[%ebx] := [match/15[%esi] + 4]
  param/17[%edx] := ["camlCode" + 28]
  A/18[%ecx] := [param/17[%edx] + 4]
  A/19[%eax] := [n/16[%ebx] + 4]
  R/7[%tos] := float64u[A/19[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/18[%ecx]]
  A/22[%ecx] := [param/17[%edx]]
  A/23[%eax] := [n/16[%ebx]]
  R/7[%tos] := float64u[A/23[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/22[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/27[%ecx] := [param/17[%edx] + 8]
  A/28[%eax] := [n/16[%ebx] + 8]
  R/7[%tos] := float64u[A/28[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/27[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  g/32[s0] := R/7[%tos]
  R/7[%tos] := 0.
  if not g/32[s0] <=f R/7[%tos] goto L177
  A/90[%eax] := "camlCode__19"
  reload retaddr
  return R/0[%eax]
  L177 [2]:
  A/34[%eax] := ["camlPervasives" + 56]
  pushfloat [A/34[%eax]]
  {match/15[%esi]* n/16[%ebx]* spilled-g/91[s0] spilled-dir/92[s0]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  s/35[s1] := R/7[%tos]
  {match/15[%esi]* n/16[%ebx]* s/35[s1] spilled-g/91[s0] spilled-dir/92[s0]*}
  A/36[%ecx] := alloc 168
  [A/36[%ecx] + -4] := 2301
  A/37[%eax] := [n/16[%ebx] + 8]
  R/7[%tos] := s/35[s1] *f float64[A/37[%eax]]
  float64u[A/36[%ecx]] := R/7[%tos]
  A/39[%eax] := A/36[%ecx] + 12
  [A/39[%eax] + -4] := 2301
  A/40[%edx] := [n/16[%ebx] + 4]
  R/7[%tos] := s/35[s1] *f float64[A/40[%edx]]
  float64u[A/39[%eax]] := R/7[%tos]
  A/42[%edx] := A/36[%ecx] + 24
  [A/42[%edx] + -4] := 2301
  A/43[%ebx] := [n/16[%ebx]]
  R/7[%tos] := s/35[s1] *f float64[A/43[%ebx]]
  float64u[A/42[%edx]] := R/7[%tos]
  param/45[%ebp] := A/36[%ecx] + 36
  [param/45[%ebp] + -4] := 3072
  [param/45[%ebp]] := A/42[%edx]
  [param/45[%ebp] + 4] := A/39[%eax]
  [param/45[%ebp] + 8] := A/36[%ecx]
  s/46[%esi] := [match/15[%esi]]
  A/47[%edi] := A/36[%ecx] + 52
  [A/47[%edi] + -4] := 2301
  dir/93[%eax] := spilled-dir/92[s0] (reload)
  A/48[%ebx] := [dir/93[%eax] + 8]
  R/7[%tos] := float64u[s/46[%esi]]
  R/7[%tos] := R/7[%tos] *f float64[A/48[%ebx]]
  float64u[A/47[%edi]] := R/7[%tos]
  A/51[%edx] := A/36[%ecx] + 64
  [A/51[%edx] + -4] := 2301
  A/52[%ebx] := [dir/93[%eax] + 4]
  R/7[%tos] := float64u[s/46[%esi]]
  R/7[%tos] := R/7[%tos] *f float64[A/52[%ebx]]
  float64u[A/51[%edx]] := R/7[%tos]
  A/55[%ebx] := A/36[%ecx] + 76
  [A/55[%ebx] + -4] := 2301
  A/56[%eax] := [dir/93[%eax]]
  R/7[%tos] := float64u[s/46[%esi]]
  R/7[%tos] := R/7[%tos] *f float64[A/56[%eax]]
  float64u[A/55[%ebx]] := R/7[%tos]
  param/59[%eax] := A/36[%ecx] + 88
  [param/59[%eax] + -4] := 3072
  [param/59[%eax]] := A/55[%ebx]
  [param/59[%eax] + 4] := A/51[%edx]
  [param/59[%eax] + 8] := A/47[%edi]
  A/60[%esi] := A/36[%ecx] + 104
  [A/60[%esi] + -4] := 2301
  A/61[%edx] := [param/45[%ebp] + 8]
  A/62[%ebx] := [param/59[%eax] + 8]
  R/7[%tos] := float64u[A/62[%ebx]]
  R/7[%tos] := R/7[%tos] +f float64[A/61[%edx]]
  float64u[A/60[%esi]] := R/7[%tos]
  A/65[%edx] := A/36[%ecx] + 116
  [A/65[%edx] + -4] := 2301
  A/66[%edi] := [param/45[%ebp] + 4]
  A/67[%ebx] := [param/59[%eax] + 4]
  R/7[%tos] := float64u[A/67[%ebx]]
  R/7[%tos] := R/7[%tos] +f float64[A/66[%edi]]
  float64u[A/65[%edx]] := R/7[%tos]
  A/70[%ebx] := A/36[%ecx] + 128
  [A/70[%ebx] + -4] := 2301
  A/71[%edi] := [param/45[%ebp]]
  A/72[%eax] := [param/59[%eax]]
  R/7[%tos] := float64u[A/72[%eax]]
  R/7[%tos] := R/7[%tos] +f float64[A/71[%edi]]
  float64u[A/70[%ebx]] := R/7[%tos]
  p/75[%eax] := A/36[%ecx] + 140
  [p/75[%eax] + -4] := 3072
  [p/75[%eax]] := A/70[%ebx]
  [p/75[%eax] + 4] := A/65[%edx]
  [p/75[%eax] + 8] := A/60[%esi]
  A/76[%ecx] := A/36[%ecx] + 156
  [A/76[%ecx] + -4] := 2048
  A/77[%ebx] := ["camlPervasives" + 36]
  [A/76[%ecx]] := A/77[%ebx]
  A/78[%ebx] := ["camlCode"]
  [A/76[%ecx] + 4] := A/78[%ebx]
  A/79[%esi] := ["camlCode" + 24]
  A/80[%edx] := ["camlCode" + 48]
  A/81[%ebx] := ["camlCode" + 28]
  {spilled-g/91[s0]}
  R/0[%eax] := call "camlCode__intersect_1060" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
  A/83[%eax] := [A/82[%eax]]
  R/7[%tos] := float64u[A/83[%eax]]
  F/85[s1] := R/7[%tos]
  A/86[%eax] := ["camlPervasives" + 36]
  R/7[%tos] := float64u[A/86[%eax]]
  if not F/85[s1] <f R/7[%tos] goto L176
  A/89[%eax] := "camlCode__18"
  reload retaddr
  return R/0[%eax]
  L176 [2]:
  {spilled-g/91[s0]}
  A/88[%eax] := alloc 12
  [A/88[%eax] + -4] := 2301
  float64u[A/88[%eax]] := g/94[s0]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__aux_1095:
                  x/8[%ecx] := R/0[%eax]
                  {x/8[%ecx]* d/9[%ebx]*}
                  A/10[%eax] := alloc 12
                  [A/10[%eax] + -4] := 2301
                  I/11[%edx] := 4
                  R/7[%tos] := floatofint I/11[%edx]
                  I/13[%ebx] := I/13[%ebx] >>s 1
                  R/7[%tos] := floatofint I/13[%ebx]
                  R/7[%tos] := R/7[%tos] /f R/7[%tos]
                  R/7[%tos] := 2.
                  A/17[%ebx] := ["camlCode" + 44]
                  I/18[%ebx] := I/18[%ebx] >>s 1
                  R/7[%tos] := floatofint I/18[%ebx]
                  R/7[%tos] := R/7[%tos] /f R/7[%tos]
                  I/21[%ecx] := I/21[%ecx] >>s 1
                  R/7[%tos] := floatofint I/21[%ecx]
                  R/7[%tos] := R/7[%tos] -f R/7[%tos]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  float64u[A/10[%eax]] := R/7[%tos]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__aux_1095:
  x/8[%ecx] := R/0[%eax]
  {x/8[%ecx]* d/9[%ebx]*}
  A/10[%eax] := alloc 12
  [A/10[%eax] + -4] := 2301
  I/11[%edx] := 4
  R/7[%tos] := floatofint I/11[%edx]
  I/13[%ebx] := I/13[%ebx] >>s 1
  R/7[%tos] := floatofint I/13[%ebx]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  R/7[%tos] := 2.
  A/17[%ebx] := ["camlCode" + 44]
  I/18[%ebx] := I/18[%ebx] >>s 1
  R/7[%tos] := floatofint I/18[%ebx]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  I/21[%ecx] := I/21[%ecx] >>s 1
  R/7[%tos] := floatofint I/21[%ecx]
  R/7[%tos] := R/7[%tos] -f R/7[%tos]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  float64u[A/10[%eax]] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  zero/8[%eax] := "camlCode__1"
                  ["camlCode"] := zero/8[%eax]
                  *|/9[%eax] := "camlCode__17"
                  ["camlCode" + 4] := *|/9[%eax]
                  +|/10[%eax] := "camlCode__16"
                  ["camlCode" + 8] := +|/10[%eax]
                  -|/11[%eax] := "camlCode__15"
                  ["camlCode" + 12] := -|/11[%eax]
                  dot/12[%eax] := "camlCode__14"
                  ["camlCode" + 16] := dot/12[%eax]
                  unitise/13[%eax] := "camlCode__13"
                  ["camlCode" + 20] := unitise/13[%eax]
                  clos/14[%eax] := "camlCode__12"
                  ["camlCode" + 24] := clos/14[%eax]
                  A/15[%ebx] := ["camlCode__2" + 4]
                  A/16[%eax] := ["camlCode__2" + 4]
                  R/7[%tos] := float64u[A/16[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/15[%ebx]]
                  A/19[%ebx] := ["camlCode__2"]
                  A/20[%eax] := ["camlCode__2"]
                  R/7[%tos] := float64u[A/20[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/19[%ebx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  A/24[%ebx] := ["camlCode__2" + 8]
                  A/25[%eax] := ["camlCode__2" + 8]
                  R/7[%tos] := float64u[A/25[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/24[%ebx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  push R/7[%tos]
                  {}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  F/29[s0] := R/7[%tos]
                  R/7[%tos] := 1.
                  R/7[%tos] := R/7[%tos] /f F/29[s0]
                  s/32[s0] := R/7[%tos]
                  {s/32[s0]}
                  A/33[%edx] := alloc 52
                  [A/33[%edx] + -4] := 2301
                  A/34[%eax] := ["camlCode__2" + 8]
                  R/7[%tos] := s/32[s0] *f float64[A/34[%eax]]
                  float64u[A/33[%edx]] := R/7[%tos]
                  A/36[%ecx] := A/33[%edx] + 12
                  [A/36[%ecx] + -4] := 2301
                  A/37[%eax] := ["camlCode__2" + 4]
                  R/7[%tos] := s/32[s0] *f float64[A/37[%eax]]
                  float64u[A/36[%ecx]] := R/7[%tos]
                  A/39[%ebx] := A/33[%edx] + 24
                  [A/39[%ebx] + -4] := 2301
                  A/40[%eax] := ["camlCode__2"]
                  R/7[%tos] := s/32[s0] *f float64[A/40[%eax]]
                  float64u[A/39[%ebx]] := R/7[%tos]
                  light/42[%eax] := A/33[%edx] + 36
                  [light/42[%eax] + -4] := 3072
                  [light/42[%eax]] := A/39[%ebx]
                  [light/42[%eax] + 4] := A/36[%ecx]
                  [light/42[%eax] + 8] := A/33[%edx]
                  ["camlCode" + 28] := light/42[%eax]
                  ["camlCode" + 32] := 9
                  clos/43[%eax] := "camlCode__11"
                  ["camlCode" + 36] := clos/43[%eax]
                  setup trap L206
                  A/56[%ebx] := "camlCode__3"
                  goto L205
                  L206 [0]:
                  push trap
                  arr/44[%ebx] := ["camlSys"]
                  A/45[%eax] := [arr/44[%ebx] + -4]
                  I/46[%eax] := I/46[%eax] >>u 9
                  I/46[%eax] check > 5
                  A/47[%eax] := [arr/44[%ebx] + 8]
                  push A/47[%eax]
                  {}
                  R/0[%eax] := extcall "caml_int_of_string"  (noalloc)
                  offset stack -4
                  A/252[s0] := A/48[%eax] (spill)
                  arr/49[%ebx] := ["camlSys"]
                  A/50[%eax] := [arr/49[%ebx] + -4]
                  I/51[%eax] := I/51[%eax] >>u 9
                  I/51[%eax] check > 3
                  A/52[%eax] := [arr/49[%ebx] + 4]
                  push A/52[%eax]
                  {A/252[s0]*}
                  R/0[%eax] := extcall "caml_int_of_string"  (noalloc)
                  offset stack -4
                  A/53[%ecx] := R/0[%eax]
                  {A/53[%ecx]* A/252[s0]*}
                  match/54[%ebx] := alloc 12
                  [match/54[%ebx] + -4] := 2048
                  [match/54[%ebx]] := A/53[%ecx]
                  A/264[%eax] := A/252[s0] (reload)
                  [match/54[%ebx] + 4] := A/264[%eax]
                  pop trap
                  L205 [0]:
                  A/57[%eax] := [match/54[%ebx]]
                  ["camlCode" + 40] := A/57[%eax]
                  A/58[%eax] := [match/54[%ebx] + 4]
                  ["camlCode" + 44] := A/58[%eax]
                  A/59[%edx] := ["camlCode" + 36]
                  A/60[%ecx] := "camlCode__10"
                  A/61[%ebx] := "camlCode__4"
                  A/62[%eax] := ["camlCode" + 40]
                  {}
                  R/0[%eax] := call "camlCode__create_1077" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  ["camlCode" + 48] := scene/63[%eax]
                  ray_trace/64[%eax] := "camlCode__9"
                  ["camlCode" + 52] := ray_trace/64[%eax]
                  aux/65[%eax] := "camlCode__8"
                  ["camlCode" + 56] := aux/65[%eax]
                  A/66[%eax] := ["camlPervasives" + 92]
                  {}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/67[%ebx] := R/0[%eax]
                  A/68[%eax] := "camlCode__5"
                  A/69[%ecx] := [fun/67[%ebx]]
                  {}
                  R/0[%eax] := call A/69[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  A/70[%ecx] := R/0[%eax]
                  A/71[%ebx] := ["camlCode" + 44]
                  A/72[%eax] := ["camlCode" + 44]
                  {}
                  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  A/73[%eax] := ["camlCode" + 44]
                  y/74[%eax] := y/74[%eax] + -2
                  if y/74[%eax] <s 1 goto L195
                  spilled-y/258[s4] := y/74[%eax] (spill)
                  L196 [0]:
                  x/75[%ebx] := 1
                  spilled-x/257[s5] := x/75[%ebx] (spill)
                  A/76[%eax] := ["camlCode" + 44]
                  bound/77[%eax] := bound/77[%eax] + -2
                  spilled-bound/259[s3] := bound/77[%eax] (spill)
                  if x/75[%ebx] >s bound/77[%eax] goto L197
                  L198 [0]:
                  R/7[%tos] := 0.
                  g/79[s0] := R/7[%tos]
                  d/80[%edx] := 1
                  spilled-d/255[s6] := d/80[%edx] (spill)
                  if d/80[%edx] >s 31 goto L201
                  L202 [0]:
                  {d/80[%edx] spilled-d/255[s6] spilled-g/256[s0]
                   spilled-x/257[s5] spilled-y/258[s4] spilled-bound/259[s3]}
                  A/81[%ecx] := alloc 52
                  [A/81[%ecx] + -4] := 2301
                  A/82[%eax] := ["camlCode" + 44]
                  I/83[%eax] := I/83[%eax] >>s 1
                  R/7[%tos] := floatofint I/83[%eax]
                  float64u[A/81[%ecx]] := R/7[%tos]
                  I/85[%eax] := d/80[%edx]
                  I/85[%eax] := I/85[%eax] >>s 1
                  I/86[%eax] := I/86[%eax] div 4
                  d/87[%eax] := I/86[%eax]  * 2 + 1
                  A/88[%esi] := A/81[%ecx] + 12
                  [A/88[%esi] + -4] := 2301
                  I/89[%ebx] := 4
                  R/7[%tos] := floatofint I/89[%ebx]
                  I/91[%eax] := I/91[%eax] >>s 1
                  R/7[%tos] := floatofint I/91[%eax]
                  R/7[%tos] := R/7[%tos] /f R/7[%tos]
                  R/7[%tos] := 2.
                  A/95[%eax] := ["camlCode" + 44]
                  I/96[%eax] := I/96[%eax] >>s 1
                  R/7[%tos] := floatofint I/96[%eax]
                  R/7[%tos] := R/7[%tos] /f R/7[%tos]
                  y/265[%eax] := spilled-y/258[s4] (reload)
                  I/99[%eax] := I/99[%eax] >>s 1
                  R/7[%tos] := floatofint I/99[%eax]
                  R/7[%tos] := R/7[%tos] -f R/7[%tos]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  float64u[A/88[%esi]] := R/7[%tos]
                  I/103[%edx] := I/103[%edx] >>s 1
                  R/3[%edx] := R/3[%edx] mod 4
                  d/105[%ebx] := I/104[%edx]  * 2 + 1
                  A/106[%eax] := A/81[%ecx] + 24
                  [A/106[%eax] + -4] := 2301
                  I/107[%edx] := 4
                  R/7[%tos] := floatofint I/107[%edx]
                  I/109[%ebx] := I/109[%ebx] >>s 1
                  R/7[%tos] := floatofint I/109[%ebx]
                  R/7[%tos] := R/7[%tos] /f R/7[%tos]
                  R/7[%tos] := 2.
                  A/113[%ebx] := ["camlCode" + 44]
                  I/114[%ebx] := I/114[%ebx] >>s 1
                  R/7[%tos] := floatofint I/114[%ebx]
                  R/7[%tos] := R/7[%tos] /f R/7[%tos]
                  x/266[%ebx] := spilled-x/257[s5] (reload)
                  I/117[%ebx] := I/117[%ebx] >>s 1
                  R/7[%tos] := floatofint I/117[%ebx]
                  R/7[%tos] := R/7[%tos] -f R/7[%tos]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  float64u[A/106[%eax]] := R/7[%tos]
                  r/121[%ebx] := A/81[%ecx] + 36
                  [r/121[%ebx] + -4] := 3072
                  [r/121[%ebx]] := A/106[%eax]
                  [r/121[%ebx] + 4] := A/88[%esi]
                  [r/121[%ebx] + 8] := A/81[%ecx]
                  A/122[%ecx] := [r/121[%ebx] + 4]
                  A/123[%eax] := [r/121[%ebx] + 4]
                  R/7[%tos] := float64u[A/123[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/122[%ecx]]
                  A/126[%ecx] := [r/121[%ebx]]
                  A/127[%eax] := [r/121[%ebx]]
                  R/7[%tos] := float64u[A/127[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/126[%ecx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  A/131[%ecx] := [r/121[%ebx] + 8]
                  A/132[%eax] := [r/121[%ebx] + 8]
                  R/7[%tos] := float64u[A/132[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/131[%ecx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  push R/7[%tos]
                  {r/121[%ebx]* spilled-d/255[s6] spilled-g/256[s0]
                   spilled-x/257[s5] spilled-y/258[s4] spilled-bound/259[s3]}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  F/136[s1] := R/7[%tos]
                  R/7[%tos] := 1.
                  R/7[%tos] := R/7[%tos] /f F/136[s1]
                  s/139[s1] := R/7[%tos]
                  {r/121[%ebx]* s/139[s1] spilled-d/255[s6] spilled-g/256[s0]
                   spilled-x/257[s5] spilled-y/258[s4] spilled-bound/259[s3]}
                  A/140[%eax] := alloc 64
                  [A/140[%eax] + -4] := 2301
                  A/141[%ecx] := [r/121[%ebx] + 8]
                  R/7[%tos] := s/139[s1] *f float64[A/141[%ecx]]
                  float64u[A/140[%eax]] := R/7[%tos]
                  A/143[%edx] := A/140[%eax] + 12
                  [A/143[%edx] + -4] := 2301
                  A/144[%ecx] := [r/121[%ebx] + 4]
                  R/7[%tos] := s/139[s1] *f float64[A/144[%ecx]]
                  float64u[A/143[%edx]] := R/7[%tos]
                  A/146[%ecx] := A/140[%eax] + 24
                  [A/146[%ecx] + -4] := 2301
                  A/147[%ebx] := [r/121[%ebx]]
                  R/7[%tos] := s/139[s1] *f float64[A/147[%ebx]]
                  float64u[A/146[%ecx]] := R/7[%tos]
                  dir/149[%ebx] := A/140[%eax] + 36
                  spilled-dir/254[s7] := dir/149[%ebx] (spill)
                  [dir/149[%ebx] + -4] := 3072
                  [dir/149[%ebx]] := A/146[%ecx]
                  [dir/149[%ebx] + 4] := A/143[%edx]
                  [dir/149[%ebx] + 8] := A/140[%eax]
                  A/150[%ecx] := A/140[%eax] + 52
                  A/262[s0] := A/150[%ecx] (spill)
                  [A/150[%ecx] + -4] := 2048
                  A/151[%eax] := ["camlPervasives" + 36]
                  [A/150[%ecx]] := A/151[%eax]
                  A/152[%eax] := ["camlCode"]
                  [A/150[%ecx] + 4] := A/152[%eax]
                  A/153[%eax] := ["camlCode" + 24]
                  A/260[s2] := A/153[%eax] (spill)
                  A/154[%eax] := ["camlCode" + 48]
                  A/261[s1] := A/154[%eax] (spill)
                  A/155[%eax] := ["camlCode"]
                  A/267[%ecx] := A/262[s0] (reload)
                  A/268[%edx] := A/261[s1] (reload)
                  A/269[%esi] := A/260[s2] (reload)
                  {spilled-dir/254[s7]* spilled-d/255[s6] spilled-g/256[s0]
                   spilled-x/257[s5] spilled-y/258[s4] spilled-bound/259[s3]}
                  R/0[%eax] := call "camlCode__intersect_1060" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
                  match/156[%esi] := R/0[%eax]
                  n/157[%ebx] := [match/156[%esi] + 4]
                  param/158[%edx] := ["camlCode" + 28]
                  A/159[%ecx] := [param/158[%edx] + 4]
                  A/160[%eax] := [n/157[%ebx] + 4]
                  R/7[%tos] := float64u[A/160[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/159[%ecx]]
                  A/163[%ecx] := [param/158[%edx]]
                  A/164[%eax] := [n/157[%ebx]]
                  R/7[%tos] := float64u[A/164[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/163[%ecx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  A/168[%ecx] := [param/158[%edx] + 8]
                  A/169[%eax] := [n/157[%ebx] + 8]
                  R/7[%tos] := float64u[A/169[%eax]]
                  R/7[%tos] := R/7[%tos] *f float64[A/168[%ecx]]
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  g/173[s1] := R/7[%tos]
                  R/7[%tos] := 0.
                  if not g/173[s1] <=f R/7[%tos] goto L204
                  R/7[%tos] := float64u["camlCode__7"]
                  F/231[s1] := R/7[%tos]
                  goto L203
                  L204 [0]:
                  A/176[%eax] := ["camlPervasives" + 56]
                  pushfloat [A/176[%eax]]
                  {match/156[%esi]* n/157[%ebx]* spilled-g/253[s1]
                   spilled-dir/254[s7]* spilled-d/255[s6] spilled-g/256[s0]
                   spilled-x/257[s5] spilled-y/258[s4] spilled-bound/259[s3]}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  s/177[s2] := R/7[%tos]
                  {match/156[%esi]* n/157[%ebx]* s/177[s2] spilled-g/253[s1]
                   spilled-dir/254[s7]* spilled-d/255[s6] spilled-g/256[s0]
                   spilled-x/257[s5] spilled-y/258[s4] spilled-bound/259[s3]}
                  A/178[%ecx] := alloc 168
                  [A/178[%ecx] + -4] := 2301
                  A/179[%eax] := [n/157[%ebx] + 8]
                  R/7[%tos] := s/177[s2] *f float64[A/179[%eax]]
                  float64u[A/178[%ecx]] := R/7[%tos]
                  A/181[%eax] := A/178[%ecx] + 12
                  [A/181[%eax] + -4] := 2301
                  A/182[%edx] := [n/157[%ebx] + 4]
                  R/7[%tos] := s/177[s2] *f float64[A/182[%edx]]
                  float64u[A/181[%eax]] := R/7[%tos]
                  A/184[%edx] := A/178[%ecx] + 24
                  [A/184[%edx] + -4] := 2301
                  A/185[%ebx] := [n/157[%ebx]]
                  R/7[%tos] := s/177[s2] *f float64[A/185[%ebx]]
                  float64u[A/184[%edx]] := R/7[%tos]
                  param/187[%ebp] := A/178[%ecx] + 36
                  [param/187[%ebp] + -4] := 3072
                  [param/187[%ebp]] := A/184[%edx]
                  [param/187[%ebp] + 4] := A/181[%eax]
                  [param/187[%ebp] + 8] := A/178[%ecx]
                  s/188[%esi] := [match/156[%esi]]
                  A/189[%edi] := A/178[%ecx] + 52
                  [A/189[%edi] + -4] := 2301
                  dir/270[%eax] := spilled-dir/254[s7] (reload)
                  A/190[%ebx] := [dir/270[%eax] + 8]
                  R/7[%tos] := float64u[s/188[%esi]]
                  R/7[%tos] := R/7[%tos] *f float64[A/190[%ebx]]
                  float64u[A/189[%edi]] := R/7[%tos]
                  A/193[%edx] := A/178[%ecx] + 64
                  [A/193[%edx] + -4] := 2301
                  A/194[%ebx] := [dir/270[%eax] + 4]
                  R/7[%tos] := float64u[s/188[%esi]]
                  R/7[%tos] := R/7[%tos] *f float64[A/194[%ebx]]
                  float64u[A/193[%edx]] := R/7[%tos]
                  A/197[%ebx] := A/178[%ecx] + 76
                  [A/197[%ebx] + -4] := 2301
                  A/198[%eax] := [dir/270[%eax]]
                  R/7[%tos] := float64u[s/188[%esi]]
                  R/7[%tos] := R/7[%tos] *f float64[A/198[%eax]]
                  float64u[A/197[%ebx]] := R/7[%tos]
                  param/201[%eax] := A/178[%ecx] + 88
                  [param/201[%eax] + -4] := 3072
                  [param/201[%eax]] := A/197[%ebx]
                  [param/201[%eax] + 4] := A/193[%edx]
                  [param/201[%eax] + 8] := A/189[%edi]
                  A/202[%esi] := A/178[%ecx] + 104
                  [A/202[%esi] + -4] := 2301
                  A/203[%edx] := [param/187[%ebp] + 8]
                  A/204[%ebx] := [param/201[%eax] + 8]
                  R/7[%tos] := float64u[A/204[%ebx]]
                  R/7[%tos] := R/7[%tos] +f float64[A/203[%edx]]
                  float64u[A/202[%esi]] := R/7[%tos]
                  A/207[%edx] := A/178[%ecx] + 116
                  [A/207[%edx] + -4] := 2301
                  A/208[%edi] := [param/187[%ebp] + 4]
                  A/209[%ebx] := [param/201[%eax] + 4]
                  R/7[%tos] := float64u[A/209[%ebx]]
                  R/7[%tos] := R/7[%tos] +f float64[A/208[%edi]]
                  float64u[A/207[%edx]] := R/7[%tos]
                  A/212[%ebx] := A/178[%ecx] + 128
                  [A/212[%ebx] + -4] := 2301
                  A/213[%edi] := [param/187[%ebp]]
                  A/214[%eax] := [param/201[%eax]]
                  R/7[%tos] := float64u[A/214[%eax]]
                  R/7[%tos] := R/7[%tos] +f float64[A/213[%edi]]
                  float64u[A/212[%ebx]] := R/7[%tos]
                  p/217[%eax] := A/178[%ecx] + 140
                  [p/217[%eax] + -4] := 3072
                  [p/217[%eax]] := A/212[%ebx]
                  [p/217[%eax] + 4] := A/207[%edx]
                  [p/217[%eax] + 8] := A/202[%esi]
                  A/218[%ecx] := A/178[%ecx] + 156
                  [A/218[%ecx] + -4] := 2048
                  A/219[%ebx] := ["camlPervasives" + 36]
                  [A/218[%ecx]] := A/219[%ebx]
                  A/220[%ebx] := ["camlCode"]
                  [A/218[%ecx] + 4] := A/220[%ebx]
                  A/221[%esi] := ["camlCode" + 24]
                  A/222[%edx] := ["camlCode" + 48]
                  A/223[%ebx] := ["camlCode" + 28]
                  {spilled-g/253[s1] spilled-d/255[s6] spilled-g/256[s0]
                   spilled-x/257[s5] spilled-y/258[s4] spilled-bound/259[s3]}
                  R/0[%eax] := call "camlCode__intersect_1060" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
                  A/225[%eax] := [A/224[%eax]]
                  R/7[%tos] := float64u[A/225[%eax]]
                  F/227[s2] := R/7[%tos]
                  A/228[%eax] := ["camlPervasives" + 36]
                  R/7[%tos] := float64u[A/228[%eax]]
                  if not F/227[s2] <f R/7[%tos] goto L203
                  R/7[%tos] := float64u["camlCode__6"]
                  F/231[s1] := R/7[%tos]
                  L203 [0]:
                  R/7[%tos] := g/79[s0] +f F/231[s1]
                  g/79[s0] := R/7[%tos]
                  d/80[%edx] := spilled-d/255[s6] (reload)
                  d/233[%eax] := d/80[%edx]
                  I/234[%edx] := I/234[%edx] + 2
                  spilled-d/255[s6] := d/80[%edx] (spill)
                  if d/233[%eax] !=s 31 goto L202
                  L201 [0]:
                  R/7[%tos] := 255.
                  R/7[%tos] := R/7[%tos] *f g/79[s0]
                  I/237[%eax] := 16
                  R/7[%tos] := floatofint I/237[%eax]
                  R/7[%tos] := R/7[%tos] /f(rev) R/7[%tos]
                  R/7[%tos] := 0.5
                  R/7[%tos] := R/7[%tos] +f R/7[%tos]
                  g/242[s0] := R/7[%tos]
                  I/243[%eax] := intoffloat g/242[s0]
                  n/244[%eax] := I/243[%eax]  * 2 + 1
                  if n/244[%eax] <s 1 goto L200
                  if n/244[%eax] <=s 511 goto L199
                  L200 [0]:
                  {}
                  A/245[%eax] := alloc 12
                  [A/245[%eax] + -4] := 2048
                  [A/245[%eax]] := "caml_exn_Invalid_argument"
                  [A/245[%eax] + 4] := "camlPervasives__2"
                  raise R/0[%eax] {pervasives.ml:155,27-52}
                  L199 [0]:
                  push c/246[%eax]
                  push ["camlPervasives" + 92]
                  {spilled-x/257[s5] spilled-y/258[s4] spilled-bound/259[s3]}
                  extcall "caml_ml_output_char"  (noalloc) {pervasives.ml:358,19-39}
                  offset stack -8
                  x/274[%eax] := spilled-x/257[s5] (reload)
                  x/247[%ebx] := x/274[%eax]
                  I/248[%eax] := I/248[%eax] + 2
                  spilled-x/257[s5] := x/274[%eax] (spill)
                  bound/275[%eax] := spilled-bound/259[s3] (reload)
                  if x/247[%ebx] !=s bound/275[%eax] goto L198
                  L197 [0]:
                  y/276[%eax] := spilled-y/258[s4] (reload)
                  y/249[%ebx] := y/276[%eax]
                  I/250[%eax] := I/250[%eax] - 2
                  spilled-y/258[s4] := y/276[%eax] (spill)
                  if y/249[%ebx] !=s 1 goto L196
                  L195 [0]:
                  A/251[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  zero/8[%eax] := "camlCode__1"
  ["camlCode"] := zero/8[%eax]
  *|/9[%eax] := "camlCode__17"
  ["camlCode" + 4] := *|/9[%eax]
  +|/10[%eax] := "camlCode__16"
  ["camlCode" + 8] := +|/10[%eax]
  -|/11[%eax] := "camlCode__15"
  ["camlCode" + 12] := -|/11[%eax]
  dot/12[%eax] := "camlCode__14"
  ["camlCode" + 16] := dot/12[%eax]
  unitise/13[%eax] := "camlCode__13"
  ["camlCode" + 20] := unitise/13[%eax]
  clos/14[%eax] := "camlCode__12"
  ["camlCode" + 24] := clos/14[%eax]
  A/15[%ebx] := ["camlCode__2" + 4]
  A/16[%eax] := ["camlCode__2" + 4]
  R/7[%tos] := float64u[A/16[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/15[%ebx]]
  A/19[%ebx] := ["camlCode__2"]
  A/20[%eax] := ["camlCode__2"]
  R/7[%tos] := float64u[A/20[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/19[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/24[%ebx] := ["camlCode__2" + 8]
  A/25[%eax] := ["camlCode__2" + 8]
  R/7[%tos] := float64u[A/25[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/24[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/29[s0] := R/7[%tos]
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] /f F/29[s0]
  s/32[s0] := R/7[%tos]
  {s/32[s0]}
  A/33[%edx] := alloc 52
  [A/33[%edx] + -4] := 2301
  A/34[%eax] := ["camlCode__2" + 8]
  R/7[%tos] := s/32[s0] *f float64[A/34[%eax]]
  float64u[A/33[%edx]] := R/7[%tos]
  A/36[%ecx] := A/33[%edx] + 12
  [A/36[%ecx] + -4] := 2301
  A/37[%eax] := ["camlCode__2" + 4]
  R/7[%tos] := s/32[s0] *f float64[A/37[%eax]]
  float64u[A/36[%ecx]] := R/7[%tos]
  A/39[%ebx] := A/33[%edx] + 24
  [A/39[%ebx] + -4] := 2301
  A/40[%eax] := ["camlCode__2"]
  R/7[%tos] := s/32[s0] *f float64[A/40[%eax]]
  float64u[A/39[%ebx]] := R/7[%tos]
  light/42[%eax] := A/33[%edx] + 36
  [light/42[%eax] + -4] := 3072
  [light/42[%eax]] := A/39[%ebx]
  [light/42[%eax] + 4] := A/36[%ecx]
  [light/42[%eax] + 8] := A/33[%edx]
  ["camlCode" + 28] := light/42[%eax]
  ["camlCode" + 32] := 9
  clos/43[%eax] := "camlCode__11"
  ["camlCode" + 36] := clos/43[%eax]
  setup trap L206
  A/56[%ebx] := "camlCode__3"
  goto L205
  L206 [2]:
  push trap
  arr/44[%ebx] := ["camlSys"]
  A/45[%eax] := [arr/44[%ebx] + -4]
  I/46[%eax] := I/46[%eax] >>u 9
  I/46[%eax] check > 5
  A/47[%eax] := [arr/44[%ebx] + 8]
  push A/47[%eax]
  {}
  R/0[%eax] := extcall "caml_int_of_string"  (noalloc)
  offset stack -4
  A/252[s0] := A/48[%eax] (spill)
  arr/49[%ebx] := ["camlSys"]
  A/50[%eax] := [arr/49[%ebx] + -4]
  I/51[%eax] := I/51[%eax] >>u 9
  I/51[%eax] check > 3
  A/52[%eax] := [arr/49[%ebx] + 4]
  push A/52[%eax]
  {A/252[s0]*}
  R/0[%eax] := extcall "caml_int_of_string"  (noalloc)
  offset stack -4
  A/53[%ecx] := R/0[%eax]
  {A/53[%ecx]* A/252[s0]*}
  match/54[%ebx] := alloc 12
  [match/54[%ebx] + -4] := 2048
  [match/54[%ebx]] := A/53[%ecx]
  A/264[%eax] := A/252[s0] (reload)
  [match/54[%ebx] + 4] := A/264[%eax]
  pop trap
  L205 [3]:
  A/57[%eax] := [match/54[%ebx]]
  ["camlCode" + 40] := A/57[%eax]
  A/58[%eax] := [match/54[%ebx] + 4]
  ["camlCode" + 44] := A/58[%eax]
  A/59[%edx] := ["camlCode" + 36]
  A/60[%ecx] := "camlCode__10"
  A/61[%ebx] := "camlCode__4"
  A/62[%eax] := ["camlCode" + 40]
  {}
  R/0[%eax] := call "camlCode__create_1077" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  ["camlCode" + 48] := scene/63[%eax]
  ray_trace/64[%eax] := "camlCode__9"
  ["camlCode" + 52] := ray_trace/64[%eax]
  aux/65[%eax] := "camlCode__8"
  ["camlCode" + 56] := aux/65[%eax]
  A/66[%eax] := ["camlPervasives" + 92]
  {}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/67[%ebx] := R/0[%eax]
  A/68[%eax] := "camlCode__5"
  A/69[%ecx] := [fun/67[%ebx]]
  {}
  R/0[%eax] := call A/69[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  A/70[%ecx] := R/0[%eax]
  A/71[%ebx] := ["camlCode" + 44]
  A/72[%eax] := ["camlCode" + 44]
  {}
  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/73[%eax] := ["camlCode" + 44]
  y/74[%eax] := y/74[%eax] + -2
  if y/74[%eax] <s 1 goto L195
  spilled-y/258[s4] := y/74[%eax] (spill)
  L196 [4]:
  x/75[%ebx] := 1
  spilled-x/257[s5] := x/75[%ebx] (spill)
  A/76[%eax] := ["camlCode" + 44]
  bound/77[%eax] := bound/77[%eax] + -2
  spilled-bound/259[s3] := bound/77[%eax] (spill)
  if x/75[%ebx] >s bound/77[%eax] goto L197
  L198 [4]:
  R/7[%tos] := 0.
  g/79[s0] := R/7[%tos]
  d/80[%edx] := 1
  spilled-d/255[s6] := d/80[%edx] (spill)
  if d/80[%edx] >s 31 goto L201
  L202 [4]:
  {d/80[%edx] spilled-d/255[s6] spilled-g/256[s0] spilled-x/257[s5]
   spilled-y/258[s4] spilled-bound/259[s3]}
  A/81[%ecx] := alloc 52
  [A/81[%ecx] + -4] := 2301
  A/82[%eax] := ["camlCode" + 44]
  I/83[%eax] := I/83[%eax] >>s 1
  R/7[%tos] := floatofint I/83[%eax]
  float64u[A/81[%ecx]] := R/7[%tos]
  I/85[%eax] := d/80[%edx]
  I/85[%eax] := I/85[%eax] >>s 1
  I/86[%eax] := I/86[%eax] div 4
  d/87[%eax] := I/86[%eax]  * 2 + 1
  A/88[%esi] := A/81[%ecx] + 12
  [A/88[%esi] + -4] := 2301
  I/89[%ebx] := 4
  R/7[%tos] := floatofint I/89[%ebx]
  I/91[%eax] := I/91[%eax] >>s 1
  R/7[%tos] := floatofint I/91[%eax]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  R/7[%tos] := 2.
  A/95[%eax] := ["camlCode" + 44]
  I/96[%eax] := I/96[%eax] >>s 1
  R/7[%tos] := floatofint I/96[%eax]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  y/265[%eax] := spilled-y/258[s4] (reload)
  I/99[%eax] := I/99[%eax] >>s 1
  R/7[%tos] := floatofint I/99[%eax]
  R/7[%tos] := R/7[%tos] -f R/7[%tos]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  float64u[A/88[%esi]] := R/7[%tos]
  I/103[%edx] := I/103[%edx] >>s 1
  R/3[%edx] := R/3[%edx] mod 4
  d/105[%ebx] := I/104[%edx]  * 2 + 1
  A/106[%eax] := A/81[%ecx] + 24
  [A/106[%eax] + -4] := 2301
  I/107[%edx] := 4
  R/7[%tos] := floatofint I/107[%edx]
  I/109[%ebx] := I/109[%ebx] >>s 1
  R/7[%tos] := floatofint I/109[%ebx]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  R/7[%tos] := 2.
  A/113[%ebx] := ["camlCode" + 44]
  I/114[%ebx] := I/114[%ebx] >>s 1
  R/7[%tos] := floatofint I/114[%ebx]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  x/266[%ebx] := spilled-x/257[s5] (reload)
  I/117[%ebx] := I/117[%ebx] >>s 1
  R/7[%tos] := floatofint I/117[%ebx]
  R/7[%tos] := R/7[%tos] -f R/7[%tos]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  float64u[A/106[%eax]] := R/7[%tos]
  r/121[%ebx] := A/81[%ecx] + 36
  [r/121[%ebx] + -4] := 3072
  [r/121[%ebx]] := A/106[%eax]
  [r/121[%ebx] + 4] := A/88[%esi]
  [r/121[%ebx] + 8] := A/81[%ecx]
  A/122[%ecx] := [r/121[%ebx] + 4]
  A/123[%eax] := [r/121[%ebx] + 4]
  R/7[%tos] := float64u[A/123[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/122[%ecx]]
  A/126[%ecx] := [r/121[%ebx]]
  A/127[%eax] := [r/121[%ebx]]
  R/7[%tos] := float64u[A/127[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/126[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/131[%ecx] := [r/121[%ebx] + 8]
  A/132[%eax] := [r/121[%ebx] + 8]
  R/7[%tos] := float64u[A/132[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/131[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {r/121[%ebx]* spilled-d/255[s6] spilled-g/256[s0] spilled-x/257[s5]
   spilled-y/258[s4] spilled-bound/259[s3]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/136[s1] := R/7[%tos]
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] /f F/136[s1]
  s/139[s1] := R/7[%tos]
  {r/121[%ebx]* s/139[s1] spilled-d/255[s6] spilled-g/256[s0]
   spilled-x/257[s5] spilled-y/258[s4] spilled-bound/259[s3]}
  A/140[%eax] := alloc 64
  [A/140[%eax] + -4] := 2301
  A/141[%ecx] := [r/121[%ebx] + 8]
  R/7[%tos] := s/139[s1] *f float64[A/141[%ecx]]
  float64u[A/140[%eax]] := R/7[%tos]
  A/143[%edx] := A/140[%eax] + 12
  [A/143[%edx] + -4] := 2301
  A/144[%ecx] := [r/121[%ebx] + 4]
  R/7[%tos] := s/139[s1] *f float64[A/144[%ecx]]
  float64u[A/143[%edx]] := R/7[%tos]
  A/146[%ecx] := A/140[%eax] + 24
  [A/146[%ecx] + -4] := 2301
  A/147[%ebx] := [r/121[%ebx]]
  R/7[%tos] := s/139[s1] *f float64[A/147[%ebx]]
  float64u[A/146[%ecx]] := R/7[%tos]
  dir/149[%ebx] := A/140[%eax] + 36
  spilled-dir/254[s7] := dir/149[%ebx] (spill)
  [dir/149[%ebx] + -4] := 3072
  [dir/149[%ebx]] := A/146[%ecx]
  [dir/149[%ebx] + 4] := A/143[%edx]
  [dir/149[%ebx] + 8] := A/140[%eax]
  A/150[%ecx] := A/140[%eax] + 52
  A/262[s0] := A/150[%ecx] (spill)
  [A/150[%ecx] + -4] := 2048
  A/151[%eax] := ["camlPervasives" + 36]
  [A/150[%ecx]] := A/151[%eax]
  A/152[%eax] := ["camlCode"]
  [A/150[%ecx] + 4] := A/152[%eax]
  A/153[%eax] := ["camlCode" + 24]
  A/260[s2] := A/153[%eax] (spill)
  A/154[%eax] := ["camlCode" + 48]
  A/261[s1] := A/154[%eax] (spill)
  A/155[%eax] := ["camlCode"]
  A/267[%ecx] := A/262[s0] (reload)
  A/268[%edx] := A/261[s1] (reload)
  A/269[%esi] := A/260[s2] (reload)
  {spilled-dir/254[s7]* spilled-d/255[s6] spilled-g/256[s0] spilled-x/257[s5]
   spilled-y/258[s4] spilled-bound/259[s3]}
  R/0[%eax] := call "camlCode__intersect_1060" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
  match/156[%esi] := R/0[%eax]
  n/157[%ebx] := [match/156[%esi] + 4]
  param/158[%edx] := ["camlCode" + 28]
  A/159[%ecx] := [param/158[%edx] + 4]
  A/160[%eax] := [n/157[%ebx] + 4]
  R/7[%tos] := float64u[A/160[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/159[%ecx]]
  A/163[%ecx] := [param/158[%edx]]
  A/164[%eax] := [n/157[%ebx]]
  R/7[%tos] := float64u[A/164[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/163[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/168[%ecx] := [param/158[%edx] + 8]
  A/169[%eax] := [n/157[%ebx] + 8]
  R/7[%tos] := float64u[A/169[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/168[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  g/173[s1] := R/7[%tos]
  R/7[%tos] := 0.
  if not g/173[s1] <=f R/7[%tos] goto L204
  R/7[%tos] := float64u["camlCode__7"]
  F/231[s1] := R/7[%tos]
  goto L203
  L204 [2]:
  A/176[%eax] := ["camlPervasives" + 56]
  pushfloat [A/176[%eax]]
  {match/156[%esi]* n/157[%ebx]* spilled-g/253[s1] spilled-dir/254[s7]*
   spilled-d/255[s6] spilled-g/256[s0] spilled-x/257[s5] spilled-y/258[s4]
   spilled-bound/259[s3]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  s/177[s2] := R/7[%tos]
  {match/156[%esi]* n/157[%ebx]* s/177[s2] spilled-g/253[s1]
   spilled-dir/254[s7]* spilled-d/255[s6] spilled-g/256[s0] spilled-x/257[s5]
   spilled-y/258[s4] spilled-bound/259[s3]}
  A/178[%ecx] := alloc 168
  [A/178[%ecx] + -4] := 2301
  A/179[%eax] := [n/157[%ebx] + 8]
  R/7[%tos] := s/177[s2] *f float64[A/179[%eax]]
  float64u[A/178[%ecx]] := R/7[%tos]
  A/181[%eax] := A/178[%ecx] + 12
  [A/181[%eax] + -4] := 2301
  A/182[%edx] := [n/157[%ebx] + 4]
  R/7[%tos] := s/177[s2] *f float64[A/182[%edx]]
  float64u[A/181[%eax]] := R/7[%tos]
  A/184[%edx] := A/178[%ecx] + 24
  [A/184[%edx] + -4] := 2301
  A/185[%ebx] := [n/157[%ebx]]
  R/7[%tos] := s/177[s2] *f float64[A/185[%ebx]]
  float64u[A/184[%edx]] := R/7[%tos]
  param/187[%ebp] := A/178[%ecx] + 36
  [param/187[%ebp] + -4] := 3072
  [param/187[%ebp]] := A/184[%edx]
  [param/187[%ebp] + 4] := A/181[%eax]
  [param/187[%ebp] + 8] := A/178[%ecx]
  s/188[%esi] := [match/156[%esi]]
  A/189[%edi] := A/178[%ecx] + 52
  [A/189[%edi] + -4] := 2301
  dir/270[%eax] := spilled-dir/254[s7] (reload)
  A/190[%ebx] := [dir/270[%eax] + 8]
  R/7[%tos] := float64u[s/188[%esi]]
  R/7[%tos] := R/7[%tos] *f float64[A/190[%ebx]]
  float64u[A/189[%edi]] := R/7[%tos]
  A/193[%edx] := A/178[%ecx] + 64
  [A/193[%edx] + -4] := 2301
  A/194[%ebx] := [dir/270[%eax] + 4]
  R/7[%tos] := float64u[s/188[%esi]]
  R/7[%tos] := R/7[%tos] *f float64[A/194[%ebx]]
  float64u[A/193[%edx]] := R/7[%tos]
  A/197[%ebx] := A/178[%ecx] + 76
  [A/197[%ebx] + -4] := 2301
  A/198[%eax] := [dir/270[%eax]]
  R/7[%tos] := float64u[s/188[%esi]]
  R/7[%tos] := R/7[%tos] *f float64[A/198[%eax]]
  float64u[A/197[%ebx]] := R/7[%tos]
  param/201[%eax] := A/178[%ecx] + 88
  [param/201[%eax] + -4] := 3072
  [param/201[%eax]] := A/197[%ebx]
  [param/201[%eax] + 4] := A/193[%edx]
  [param/201[%eax] + 8] := A/189[%edi]
  A/202[%esi] := A/178[%ecx] + 104
  [A/202[%esi] + -4] := 2301
  A/203[%edx] := [param/187[%ebp] + 8]
  A/204[%ebx] := [param/201[%eax] + 8]
  R/7[%tos] := float64u[A/204[%ebx]]
  R/7[%tos] := R/7[%tos] +f float64[A/203[%edx]]
  float64u[A/202[%esi]] := R/7[%tos]
  A/207[%edx] := A/178[%ecx] + 116
  [A/207[%edx] + -4] := 2301
  A/208[%edi] := [param/187[%ebp] + 4]
  A/209[%ebx] := [param/201[%eax] + 4]
  R/7[%tos] := float64u[A/209[%ebx]]
  R/7[%tos] := R/7[%tos] +f float64[A/208[%edi]]
  float64u[A/207[%edx]] := R/7[%tos]
  A/212[%ebx] := A/178[%ecx] + 128
  [A/212[%ebx] + -4] := 2301
  A/213[%edi] := [param/187[%ebp]]
  A/214[%eax] := [param/201[%eax]]
  R/7[%tos] := float64u[A/214[%eax]]
  R/7[%tos] := R/7[%tos] +f float64[A/213[%edi]]
  float64u[A/212[%ebx]] := R/7[%tos]
  p/217[%eax] := A/178[%ecx] + 140
  [p/217[%eax] + -4] := 3072
  [p/217[%eax]] := A/212[%ebx]
  [p/217[%eax] + 4] := A/207[%edx]
  [p/217[%eax] + 8] := A/202[%esi]
  A/218[%ecx] := A/178[%ecx] + 156
  [A/218[%ecx] + -4] := 2048
  A/219[%ebx] := ["camlPervasives" + 36]
  [A/218[%ecx]] := A/219[%ebx]
  A/220[%ebx] := ["camlCode"]
  [A/218[%ecx] + 4] := A/220[%ebx]
  A/221[%esi] := ["camlCode" + 24]
  A/222[%edx] := ["camlCode" + 48]
  A/223[%ebx] := ["camlCode" + 28]
  {spilled-g/253[s1] spilled-d/255[s6] spilled-g/256[s0] spilled-x/257[s5]
   spilled-y/258[s4] spilled-bound/259[s3]}
  R/0[%eax] := call "camlCode__intersect_1060" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
  A/225[%eax] := [A/224[%eax]]
  R/7[%tos] := float64u[A/225[%eax]]
  F/227[s2] := R/7[%tos]
  A/228[%eax] := ["camlPervasives" + 36]
  R/7[%tos] := float64u[A/228[%eax]]
  if not F/227[s2] <f R/7[%tos] goto L203
  R/7[%tos] := float64u["camlCode__6"]
  F/231[s1] := R/7[%tos]
  L203 [5]:
  R/7[%tos] := g/79[s0] +f F/231[s1]
  g/79[s0] := R/7[%tos]
  d/80[%edx] := spilled-d/255[s6] (reload)
  d/233[%eax] := d/80[%edx]
  I/234[%edx] := I/234[%edx] + 2
  spilled-d/255[s6] := d/80[%edx] (spill)
  if d/233[%eax] !=s 31 goto L202
  L201 [4]:
  R/7[%tos] := 255.
  R/7[%tos] := R/7[%tos] *f g/79[s0]
  I/237[%eax] := 16
  R/7[%tos] := floatofint I/237[%eax]
  R/7[%tos] := R/7[%tos] /f(rev) R/7[%tos]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  g/242[s0] := R/7[%tos]
  I/243[%eax] := intoffloat g/242[s0]
  n/244[%eax] := I/243[%eax]  * 2 + 1
  if n/244[%eax] <s 1 goto L200
  if n/244[%eax] <=s 511 goto L199
  L200 [4]:
  {}
  A/245[%eax] := alloc 12
  [A/245[%eax] + -4] := 2048
  [A/245[%eax]] := "caml_exn_Invalid_argument"
  [A/245[%eax] + 4] := "camlPervasives__2"
  raise R/0[%eax] {pervasives.ml:155,27-52}
  L199 [2]:
  push c/246[%eax]
  push ["camlPervasives" + 92]
  {spilled-x/257[s5] spilled-y/258[s4] spilled-bound/259[s3]}
  extcall "caml_ml_output_char"  (noalloc) {pervasives.ml:358,19-39}
  offset stack -8
  x/274[%eax] := spilled-x/257[s5] (reload)
  x/247[%ebx] := x/274[%eax]
  I/248[%eax] := I/248[%eax] + 2
  spilled-x/257[s5] := x/274[%eax] (spill)
  bound/275[%eax] := spilled-bound/259[s3] (reload)
  if x/247[%ebx] !=s bound/275[%eax] goto L198
  L197 [4]:
  y/276[%eax] := spilled-y/258[s4] (reload)
  y/249[%ebx] := y/276[%eax]
  I/250[%eax] := I/250[%eax] - 2
  spilled-y/258[s4] := y/276[%eax] (spill)
  if y/249[%ebx] !=s 1 goto L196
  L195 [4]:
  A/251[%eax] := 1
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
	.long	15360
	.globl	camlCode
camlCode:
	.space	60
	.data
	.long	3319
camlCode__8:
	.long	caml_curry2
	.long	5
	.long	camlCode__aux_1095
	.data
	.long	2295
camlCode__9:
	.long	camlCode__ray_trace_1089
	.long	3
	.data
	.long	3319
camlCode__11:
	.long	caml_curry3
	.long	7
	.long	camlCode__create_1077
	.data
	.long	3319
camlCode__12:
	.long	caml_curry4
	.long	9
	.long	camlCode__intersect_1060
	.data
	.long	2295
camlCode__13:
	.long	camlCode__unitise_1058
	.long	3
	.data
	.long	3319
camlCode__14:
	.long	caml_curry2
	.long	5
	.long	camlCode__dot_1051
	.data
	.long	3319
camlCode__15:
	.long	caml_curry2
	.long	5
	.long	camlCode__$2d$7c_1044
	.data
	.long	3319
camlCode__16:
	.long	caml_curry2
	.long	5
	.long	camlCode__$2b$7c_1037
	.data
	.long	3319
camlCode__17:
	.long	caml_curry2
	.long	5
	.long	camlCode__$2a$7c_1032
	.data
	.globl	camlCode__1
	.long	3072
camlCode__1:
	.long	.L100026
	.long	.L100027
	.long	.L100028
	.long	2301
.L100028:
	.long	0x0, 0x0
	.long	2301
.L100027:
	.long	0x0, 0x0
	.long	2301
.L100026:
	.long	0x0, 0x0
	.data
	.globl	camlCode__2
	.long	3072
camlCode__2:
	.long	.L100023
	.long	.L100024
	.long	.L100025
	.long	2301
.L100025:
	.long	0x0, 0xc0000000
	.long	2301
.L100024:
	.long	0x0, 0x40080000
	.long	2301
.L100023:
	.long	0x0, 0x3ff00000
	.data
	.globl	camlCode__3
	.long	2048
camlCode__3:
	.long	19
	.long	1025
	.data
	.globl	camlCode__4
	.long	3072
camlCode__4:
	.long	.L100020
	.long	.L100021
	.long	.L100022
	.long	2301
.L100022:
	.long	0x0, 0x40100000
	.long	2301
.L100021:
	.long	0x0, 0xbff00000
	.long	2301
.L100020:
	.long	0x0, 0x0
	.data
	.globl	camlCode__5
	.long	4348
camlCode__5:
	.ascii	"P5\12%d %d\12\62\65\65\12%!"
	.byte	0
	.data
	.long	2301
camlCode__6:
	.long	0x0, 0x0
	.data
	.long	2301
camlCode__7:
	.long	0x0, 0x0
	.data
	.long	2301
camlCode__10:
	.long	0x0, 0x3ff00000
	.data
	.long	2301
camlCode__18:
	.long	0x0, 0x0
	.data
	.long	2301
camlCode__19:
	.long	0x0, 0x0
	.text
	.align	16
	.globl	camlCode__$2a$7c_1032
camlCode__$2a$7c_1032:
	subl	$8, %esp
.L100:
	movl	%eax, %esi
.L101:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L102
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	8(%ebx), %eax
	fldl	(%esi)
	fmull	(%eax)
	fstpl	(%ecx)
	leal	12(%ecx), %edx
	movl	$2301, -4(%edx)
	movl	4(%ebx), %eax
	fldl	(%esi)
	fmull	(%eax)
	fstpl	(%edx)
	leal	24(%ecx), %edi
	movl	$2301, -4(%edi)
	movl	(%ebx), %eax
	fldl	(%esi)
	fmull	(%eax)
	fstpl	(%edi)
	leal	36(%ecx), %eax
	movl	$3072, -4(%eax)
	movl	%edi, (%eax)
	movl	%edx, 4(%eax)
	movl	%ecx, 8(%eax)
	addl	$8, %esp
	ret
.L102:	call	caml_call_gc
.L103:	jmp	.L101
	.type	camlCode__$2a$7c_1032,@function
	.size	camlCode__$2a$7c_1032,.-camlCode__$2a$7c_1032
	.text
	.align	16
	.globl	camlCode__$2b$7c_1037
camlCode__$2b$7c_1037:
	subl	$8, %esp
.L104:
	movl	%eax, %edi
.L105:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L106
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	8(%ebx), %edx
	movl	8(%edi), %eax
	fldl	(%eax)
	faddl	(%edx)
	fstpl	(%ecx)
	leal	12(%ecx), %esi
	movl	$2301, -4(%esi)
	movl	4(%ebx), %edx
	movl	4(%edi), %eax
	fldl	(%eax)
	faddl	(%edx)
	fstpl	(%esi)
	leal	24(%ecx), %edx
	movl	$2301, -4(%edx)
	movl	(%ebx), %ebx
	movl	(%edi), %eax
	fldl	(%eax)
	faddl	(%ebx)
	fstpl	(%edx)
	leal	36(%ecx), %eax
	movl	$3072, -4(%eax)
	movl	%edx, (%eax)
	movl	%esi, 4(%eax)
	movl	%ecx, 8(%eax)
	addl	$8, %esp
	ret
.L106:	call	caml_call_gc
.L107:	jmp	.L105
	.type	camlCode__$2b$7c_1037,@function
	.size	camlCode__$2b$7c_1037,.-camlCode__$2b$7c_1037
	.text
	.align	16
	.globl	camlCode__$2d$7c_1044
camlCode__$2d$7c_1044:
	subl	$8, %esp
.L108:
	movl	%eax, %edi
.L109:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L110
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	8(%ebx), %edx
	movl	8(%edi), %eax
	fldl	(%eax)
	fsubl	(%edx)
	fstpl	(%ecx)
	leal	12(%ecx), %esi
	movl	$2301, -4(%esi)
	movl	4(%ebx), %edx
	movl	4(%edi), %eax
	fldl	(%eax)
	fsubl	(%edx)
	fstpl	(%esi)
	leal	24(%ecx), %edx
	movl	$2301, -4(%edx)
	movl	(%ebx), %ebx
	movl	(%edi), %eax
	fldl	(%eax)
	fsubl	(%ebx)
	fstpl	(%edx)
	leal	36(%ecx), %eax
	movl	$3072, -4(%eax)
	movl	%edx, (%eax)
	movl	%esi, 4(%eax)
	movl	%ecx, 8(%eax)
	addl	$8, %esp
	ret
.L110:	call	caml_call_gc
.L111:	jmp	.L109
	.type	camlCode__$2d$7c_1044,@function
	.size	camlCode__$2d$7c_1044,.-camlCode__$2d$7c_1044
	.text
	.align	16
	.globl	camlCode__dot_1051
camlCode__dot_1051:
	subl	$8, %esp
.L112:
	movl	%eax, %ecx
.L113:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L114
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	movl	4(%ebx), %esi
	movl	4(%ecx), %edx
	fldl	(%edx)
	fmull	(%esi)
	movl	(%ebx), %esi
	movl	(%ecx), %edx
	fldl	(%edx)
	fmull	(%esi)
	faddp	%st, %st(1)
	movl	8(%ebx), %edx
	movl	8(%ecx), %ebx
	fldl	(%ebx)
	fmull	(%edx)
	faddp	%st, %st(1)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L114:	call	caml_call_gc
.L115:	jmp	.L113
	.type	camlCode__dot_1051,@function
	.size	camlCode__dot_1051,.-camlCode__dot_1051
	.text
	.align	16
	.globl	camlCode__unitise_1058
camlCode__unitise_1058:
	subl	$8, %esp
.L116:
	movl	%eax, %esi
	movl	4(%esi), %ebx
	movl	4(%esi), %eax
	fldl	(%eax)
	fmull	(%ebx)
	movl	(%esi), %ebx
	movl	(%esi), %eax
	fldl	(%eax)
	fmull	(%ebx)
	faddp	%st, %st(1)
	movl	8(%esi), %ebx
	movl	8(%esi), %eax
	fldl	(%eax)
	fmull	(%ebx)
	faddp	%st, %st(1)
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	0(%esp)
	fld1
	fdivl	0(%esp)
	fstpl	0(%esp)
.L117:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L118
	leal	4(%eax), %ebx
	movl	$2301, -4(%ebx)
	movl	8(%esi), %eax
	fldl	0(%esp)
	fmull	(%eax)
	fstpl	(%ebx)
	leal	12(%ebx), %edx
	movl	$2301, -4(%edx)
	movl	4(%esi), %eax
	fldl	0(%esp)
	fmull	(%eax)
	fstpl	(%edx)
	leal	24(%ebx), %ecx
	movl	$2301, -4(%ecx)
	movl	(%esi), %eax
	fldl	0(%esp)
	fmull	(%eax)
	fstpl	(%ecx)
	leal	36(%ebx), %eax
	movl	$3072, -4(%eax)
	movl	%ecx, (%eax)
	movl	%edx, 4(%eax)
	movl	%ebx, 8(%eax)
	addl	$8, %esp
	ret
.L118:	call	caml_call_gc
.L119:	jmp	.L117
	.type	camlCode__unitise_1058,@function
	.size	camlCode__unitise_1058,.-camlCode__unitise_1058
	.text
	.align	16
	.globl	camlCode__intersect_1060
camlCode__intersect_1060:
	subl	$48, %esp
.L127:
	movl	%eax, 0(%esp)
	movl	%ebx, 4(%esp)
	movl	%ecx, 20(%esp)
	movl	%esi, 12(%esp)
	movl	8(%edx), %eax
	movl	%eax, 16(%esp)
	movl	4(%edx), %eax
	movl	%eax, 8(%esp)
	movl	(%edx), %esi
.L128:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L129
	leal	4(%eax), %ebx
	movl	$2301, -4(%ebx)
	movl	0(%esp), %ebp
	movl	8(%ebp), %ecx
	movl	8(%esi), %eax
	fldl	(%eax)
	fsubl	(%ecx)
	fstpl	(%ebx)
	leal	12(%ebx), %edx
	movl	$2301, -4(%edx)
	movl	4(%ebp), %ecx
	movl	4(%esi), %eax
	fldl	(%eax)
	fsubl	(%ecx)
	fstpl	(%edx)
	leal	24(%ebx), %ecx
	movl	$2301, -4(%ecx)
	movl	(%ebp), %edi
	movl	(%esi), %eax
	fldl	(%eax)
	fsubl	(%edi)
	fstpl	(%ecx)
	leal	36(%ebx), %eax
	movl	$3072, -4(%eax)
	movl	%ecx, (%eax)
	movl	%edx, 4(%eax)
	movl	%ebx, 8(%eax)
	movl	4(%esp), %ebx
	movl	4(%ebx), %edx
	movl	4(%eax), %ecx
	fldl	(%ecx)
	fmull	(%edx)
	movl	(%ebx), %edx
	movl	(%eax), %ecx
	fldl	(%ecx)
	fmull	(%edx)
	faddp	%st, %st(1)
	movl	8(%ebx), %edx
	movl	8(%eax), %ecx
	fldl	(%ecx)
	fmull	(%edx)
	faddp	%st, %st(1)
	fstpl	40(%esp)
	movl	4(%eax), %edx
	movl	4(%eax), %ecx
	fldl	(%ecx)
	fmull	(%edx)
	movl	(%eax), %edx
	movl	(%eax), %ecx
	fldl	(%ecx)
	fmull	(%edx)
	faddp	%st, %st(1)
	movl	8(%eax), %ecx
	movl	8(%eax), %eax
	fldl	(%eax)
	fmull	(%ecx)
	faddp	%st, %st(1)
	fldl	40(%esp)
	fmull	40(%esp)
	fsubp	%st, %st(1)
	movl	8(%esp), %eax
	fldl	(%eax)
	fmull	(%eax)
	faddp	%st, %st(1)
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	24(%esp)
	fldl	40(%esp)
	fsubl	24(%esp)
	fstpl	32(%esp)
	fldl	40(%esp)
	faddl	24(%esp)
	fstpl	24(%esp)
	fldz
	fcompl	24(%esp)
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L125
	fldz
	fcompl	32(%esp)
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L126
.L131:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L132
	leal	4(%eax), %edx
	movl	$2301, -4(%edx)
	fldl	32(%esp)
	fstpl	(%edx)
	jmp	.L124
	.align	16
.L126:
.L134:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L135
	leal	4(%eax), %edx
	movl	$2301, -4(%edx)
	fldl	24(%esp)
	fstpl	(%edx)
	jmp	.L124
	.align	16
.L125:
	movl	camlPervasives + 36, %edx
.L124:
	movl	20(%esp), %ecx
	movl	(%ecx), %eax
	fldl	(%eax)
	fldl	(%edx)
	fcompp
	fnstsw	%ax
	andb	$5, %ah
	jne	.L123
	movl	%ecx, %eax
	addl	$48, %esp
	ret
	.align	16
.L123:
	movl	16(%esp), %eax
	cmpl	$1, %eax
	je	.L120
	movl	%eax, 16(%esp)
	movl	%ecx, 20(%esp)
	movl	%ebp, %eax
	movl	12(%esp), %ecx
	call	caml_apply2
.L137:
	movl	%eax, 0(%esp)
	movl	16(%esp), %ebx
	movl	20(%esp), %eax
.L122:
	cmpl	$1, %ebx
	je	.L121
	movl	4(%ebx), %ecx
	movl	%ecx, 4(%esp)
	movl	(%ebx), %ebx
	movl	0(%esp), %ecx
	call	caml_apply2
.L138:
	movl	4(%esp), %ebx
	jmp	.L122
	.align	16
.L121:
	addl	$48, %esp
	ret
	.align	16
.L120:
	movl	%edx, 4(%esp)
	movl	%esi, 0(%esp)
.L139:	movl	caml_young_ptr, %eax
	subl	$156, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L140
	leal	4(%eax), %esi
	movl	$2301, -4(%esi)
	movl	8(%ebx), %eax
	fldl	(%edx)
	fmull	(%eax)
	fstpl	(%esi)
	leal	12(%esi), %edi
	movl	$2301, -4(%edi)
	movl	4(%ebx), %eax
	fldl	(%edx)
	fmull	(%eax)
	fstpl	(%edi)
	leal	24(%esi), %ecx
	movl	$2301, -4(%ecx)
	movl	(%ebx), %eax
	fldl	(%edx)
	fmull	(%eax)
	fstpl	(%ecx)
	leal	36(%esi), %eax
	movl	$3072, -4(%eax)
	movl	%ecx, (%eax)
	movl	%edi, 4(%eax)
	movl	%esi, 8(%eax)
	leal	52(%esi), %edx
	movl	$2301, -4(%edx)
	movl	8(%eax), %ecx
	movl	8(%ebp), %ebx
	fldl	(%ebx)
	faddl	(%ecx)
	fstpl	(%edx)
	leal	64(%esi), %ecx
	movl	$2301, -4(%ecx)
	movl	4(%eax), %edi
	movl	4(%ebp), %ebx
	fldl	(%ebx)
	faddl	(%edi)
	fstpl	(%ecx)
	leal	76(%esi), %ebx
	movl	$2301, -4(%ebx)
	movl	(%eax), %edi
	movl	(%ebp), %eax
	fldl	(%eax)
	faddl	(%edi)
	fstpl	(%ebx)
	leal	88(%esi), %eax
	movl	$3072, -4(%eax)
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	movl	%edx, 8(%eax)
	leal	104(%esi), %edi
	movl	$2301, -4(%edi)
	movl	0(%esp), %ebx
	movl	8(%ebx), %edx
	movl	8(%eax), %ecx
	fldl	(%ecx)
	fsubl	(%edx)
	fstpl	(%edi)
	leal	116(%esi), %edx
	movl	$2301, -4(%edx)
	movl	4(%ebx), %ebp
	movl	4(%eax), %ecx
	fldl	(%ecx)
	fsubl	(%ebp)
	fstpl	(%edx)
	leal	128(%esi), %ecx
	movl	$2301, -4(%ecx)
	movl	(%ebx), %ebx
	movl	(%eax), %eax
	fldl	(%eax)
	fsubl	(%ebx)
	fstpl	(%ecx)
	leal	140(%esi), %ebx
	movl	$3072, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	%edx, 4(%ebx)
	movl	%edi, 8(%ebx)
	movl	4(%ebx), %ecx
	movl	4(%ebx), %eax
	fldl	(%eax)
	fmull	(%ecx)
	movl	(%ebx), %ecx
	movl	(%ebx), %eax
	fldl	(%eax)
	fmull	(%ecx)
	faddp	%st, %st(1)
	movl	8(%ebx), %ecx
	movl	8(%ebx), %eax
	fldl	(%eax)
	fmull	(%ecx)
	faddp	%st, %st(1)
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	24(%esp)
	fld1
	fdivl	24(%esp)
	fstpl	24(%esp)
.L142:	movl	caml_young_ptr, %eax
	subl	$64, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L143
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	movl	8(%ebx), %ecx
	fldl	24(%esp)
	fmull	(%ecx)
	fstpl	(%eax)
	leal	12(%eax), %esi
	movl	$2301, -4(%esi)
	movl	4(%ebx), %ecx
	fldl	24(%esp)
	fmull	(%ecx)
	fstpl	(%esi)
	leal	24(%eax), %edx
	movl	$2301, -4(%edx)
	movl	(%ebx), %ebx
	fldl	24(%esp)
	fmull	(%ebx)
	fstpl	(%edx)
	leal	36(%eax), %ecx
	movl	$3072, -4(%ecx)
	movl	%edx, (%ecx)
	movl	%esi, 4(%ecx)
	movl	%eax, 8(%ecx)
	addl	$52, %eax
	movl	$2048, -4(%eax)
	movl	4(%esp), %ebx
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	addl	$48, %esp
	ret
.L143:	call	caml_call_gc
.L144:	jmp	.L142
.L140:	call	caml_call_gc
.L141:	jmp	.L139
.L135:	call	caml_call_gc
.L136:	jmp	.L134
.L132:	call	caml_call_gc
.L133:	jmp	.L131
.L129:	call	caml_call_gc
.L130:	jmp	.L128
	.type	camlCode__intersect_1060,@function
	.size	camlCode__intersect_1060,.-camlCode__intersect_1060
	.text
	.align	16
	.globl	camlCode__create_1077
camlCode__create_1077:
	subl	$52, %esp
.L146:
	movl	%eax, %edi
	movl	%ecx, %esi
.L147:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L148
	leal	4(%eax), %eax
	movl	$3072, -4(%eax)
	movl	%ebx, (%eax)
	movl	%esi, 4(%eax)
	movl	$1, 8(%eax)
	cmpl	$3, %edi
	jne	.L145
	addl	$52, %esp
	ret
	.align	16
.L145:
	movl	%eax, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%esi, 20(%esp)
	movl	%ebx, 24(%esp)
	movl	%edi, 8(%esp)
	fldl	.L150
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	28(%esp)
	fldl	.L151
	fmull	(%esi)
	fdivl	28(%esp)
	fstpl	28(%esp)
.L152:	movl	caml_young_ptr, %eax
	subl	$64, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L153
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	fldl	.L155
	fmull	(%esi)
	fstpl	(%ecx)
	leal	12(%ecx), %edx
	movl	$2301, -4(%edx)
	movl	8(%ebx), %eax
	fldl	28(%esp)
	faddl	(%eax)
	fstpl	(%edx)
	leal	24(%ecx), %eax
	movl	$2301, -4(%eax)
	movl	4(%ebx), %esi
	fldl	28(%esp)
	faddl	(%esi)
	fstpl	(%eax)
	leal	36(%ecx), %esi
	movl	$2301, -4(%esi)
	movl	(%ebx), %ebx
	fldl	28(%esp)
	faddl	(%ebx)
	fstpl	(%esi)
	leal	48(%ecx), %ebx
	movl	$3072, -4(%ebx)
	movl	%esi, (%ebx)
	movl	%eax, 4(%ebx)
	movl	%edx, 8(%ebx)
	movl	8(%esp), %eax
	addl	$-2, %eax
	movl	12(%esp), %edx
	call	camlCode__create_1077
.L156:
	movl	%eax, %ebx
.L157:	movl	caml_young_ptr, %eax
	subl	$76, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L158
	leal	4(%eax), %eax
	movl	%eax, 0(%esp)
	movl	$2048, -4(%eax)
	movl	%ebx, (%eax)
	movl	$1, 4(%eax)
	fldl	28(%esp)
	fchs
	fstpl	36(%esp)
	leal	12(%eax), %ecx
	movl	$2301, -4(%ecx)
	fldl	.L160
	movl	20(%esp), %ebx
	fmull	(%ebx)
	fstpl	(%ecx)
	leal	24(%eax), %edi
	movl	$2301, -4(%edi)
	movl	24(%esp), %ebx
	movl	8(%ebx), %edx
	fldl	28(%esp)
	faddl	(%edx)
	fstpl	(%edi)
	leal	36(%eax), %esi
	movl	$2301, -4(%esi)
	movl	4(%ebx), %edx
	fldl	28(%esp)
	faddl	(%edx)
	fstpl	(%esi)
	leal	48(%eax), %edx
	movl	$2301, -4(%edx)
	movl	(%ebx), %ebx
	fldl	36(%esp)
	faddl	(%ebx)
	fstpl	(%edx)
	leal	60(%eax), %ebx
	movl	$3072, -4(%ebx)
	movl	%edx, (%ebx)
	movl	%esi, 4(%ebx)
	movl	%edi, 8(%ebx)
	movl	8(%esp), %eax
	addl	$-2, %eax
	movl	12(%esp), %edx
	call	camlCode__create_1077
.L161:
	movl	%eax, %ebx
.L162:	movl	caml_young_ptr, %eax
	subl	$76, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L163
	leal	4(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$2048, -4(%eax)
	movl	%ebx, (%eax)
	movl	0(%esp), %ebx
	movl	%ebx, 4(%eax)
	fldl	28(%esp)
	fchs
	fstpl	36(%esp)
	leal	12(%eax), %ecx
	movl	$2301, -4(%ecx)
	fldl	.L165
	movl	20(%esp), %ebx
	fmull	(%ebx)
	fstpl	(%ecx)
	leal	24(%eax), %edi
	movl	$2301, -4(%edi)
	movl	24(%esp), %ebx
	movl	8(%ebx), %edx
	fldl	36(%esp)
	faddl	(%edx)
	fstpl	(%edi)
	leal	36(%eax), %esi
	movl	$2301, -4(%esi)
	movl	4(%ebx), %edx
	fldl	28(%esp)
	faddl	(%edx)
	fstpl	(%esi)
	leal	48(%eax), %edx
	movl	$2301, -4(%edx)
	movl	(%ebx), %ebx
	fldl	28(%esp)
	faddl	(%ebx)
	fstpl	(%edx)
	leal	60(%eax), %ebx
	movl	$3072, -4(%ebx)
	movl	%edx, (%ebx)
	movl	%esi, 4(%ebx)
	movl	%edi, 8(%ebx)
	movl	8(%esp), %eax
	addl	$-2, %eax
	movl	12(%esp), %edx
	call	camlCode__create_1077
.L166:
	movl	%eax, %ebx
.L167:	movl	caml_young_ptr, %eax
	subl	$76, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L168
	leal	4(%eax), %eax
	movl	%eax, 0(%esp)
	movl	$2048, -4(%eax)
	movl	%ebx, (%eax)
	movl	4(%esp), %ebx
	movl	%ebx, 4(%eax)
	fldl	28(%esp)
	fchs
	fstpl	44(%esp)
	fldl	28(%esp)
	fchs
	fstpl	36(%esp)
	leal	12(%eax), %ecx
	movl	$2301, -4(%ecx)
	fldl	.L170
	movl	20(%esp), %ebx
	fmull	(%ebx)
	fstpl	(%ecx)
	leal	24(%eax), %edi
	movl	$2301, -4(%edi)
	movl	24(%esp), %ebx
	movl	8(%ebx), %edx
	fldl	44(%esp)
	faddl	(%edx)
	fstpl	(%edi)
	leal	36(%eax), %esi
	movl	$2301, -4(%esi)
	movl	4(%ebx), %edx
	fldl	28(%esp)
	faddl	(%edx)
	fstpl	(%esi)
	leal	48(%eax), %edx
	movl	$2301, -4(%edx)
	movl	(%ebx), %ebx
	fldl	36(%esp)
	faddl	(%ebx)
	fstpl	(%edx)
	leal	60(%eax), %ebx
	movl	$3072, -4(%ebx)
	movl	%edx, (%ebx)
	movl	%esi, 4(%ebx)
	movl	%edi, 8(%ebx)
	movl	8(%esp), %eax
	addl	$-2, %eax
	movl	12(%esp), %edx
	call	camlCode__create_1077
.L171:
	movl	%eax, %ecx
.L172:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L173
	leal	4(%eax), %ebx
	movl	$2048, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	0(%esp), %eax
	movl	%eax, 4(%ebx)
	leal	12(%ebx), %edx
	movl	$2048, -4(%edx)
	movl	16(%esp), %eax
	movl	%eax, (%edx)
	movl	%ebx, 4(%edx)
	leal	24(%ebx), %ecx
	movl	$2301, -4(%ecx)
	fldl	.L175
	movl	20(%esp), %eax
	fmull	(%eax)
	fstpl	(%ecx)
	leal	36(%ebx), %eax
	movl	$3072, -4(%eax)
	movl	24(%esp), %ebx
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	movl	%edx, 8(%eax)
	addl	$52, %esp
	ret
.L173:	call	caml_call_gc
.L174:	jmp	.L172
.L168:	call	caml_call_gc
.L169:	jmp	.L167
.L163:	call	caml_call_gc
.L164:	jmp	.L162
.L158:	call	caml_call_gc
.L159:	jmp	.L157
.L153:	call	caml_call_gc
.L154:	jmp	.L152
.L148:	call	caml_call_gc
.L149:	jmp	.L147
	.data
.L175:	.long	0x0, 0x40080000
	.data
.L170:	.long	0x0, 0x3fe00000
	.data
.L165:	.long	0x0, 0x3fe00000
	.data
.L160:	.long	0x0, 0x3fe00000
	.data
.L155:	.long	0x0, 0x3fe00000
	.data
.L151:	.long	0x0, 0x40080000
	.data
.L150:	.long	0x0, 0x40280000
	.type	camlCode__create_1077,@function
	.size	camlCode__create_1077,.-camlCode__create_1077
	.text
	.align	16
	.globl	camlCode__ray_trace_1089
camlCode__ray_trace_1089:
	subl	$20, %esp
.L178:
	movl	%eax, %ebx
	movl	%ebx, 0(%esp)
.L179:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L180
	leal	4(%eax), %ecx
	movl	$2048, -4(%ecx)
	movl	camlPervasives + 36, %eax
	movl	%eax, (%ecx)
	movl	camlCode, %eax
	movl	%eax, 4(%ecx)
	movl	camlCode + 24, %esi
	movl	camlCode + 48, %edx
	movl	camlCode, %eax
	call	camlCode__intersect_1060
.L182:
	movl	%eax, %esi
	movl	4(%esi), %ebx
	movl	camlCode + 28, %edx
	movl	4(%edx), %ecx
	movl	4(%ebx), %eax
	fldl	(%eax)
	fmull	(%ecx)
	movl	(%edx), %ecx
	movl	(%ebx), %eax
	fldl	(%eax)
	fmull	(%ecx)
	faddp	%st, %st(1)
	movl	8(%edx), %ecx
	movl	8(%ebx), %eax
	fldl	(%eax)
	fmull	(%ecx)
	faddp	%st, %st(1)
	fstpl	4(%esp)
	fldz
	fcompl	4(%esp)
	fnstsw	%ax
	andb	$5, %ah
	jne	.L177
	movl	$camlCode__19, %eax
	addl	$20, %esp
	ret
	.align	16
.L177:
	movl	camlPervasives + 56, %eax
	pushl	4(%eax)
	pushl	(%eax)
	call	sqrt
	addl	$8, %esp
	fstpl	12(%esp)
.L183:	movl	caml_young_ptr, %eax
	subl	$168, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L184
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	8(%ebx), %eax
	fldl	12(%esp)
	fmull	(%eax)
	fstpl	(%ecx)
	leal	12(%ecx), %eax
	movl	$2301, -4(%eax)
	movl	4(%ebx), %edx
	fldl	12(%esp)
	fmull	(%edx)
	fstpl	(%eax)
	leal	24(%ecx), %edx
	movl	$2301, -4(%edx)
	movl	(%ebx), %ebx
	fldl	12(%esp)
	fmull	(%ebx)
	fstpl	(%edx)
	leal	36(%ecx), %ebp
	movl	$3072, -4(%ebp)
	movl	%edx, (%ebp)
	movl	%eax, 4(%ebp)
	movl	%ecx, 8(%ebp)
	movl	(%esi), %esi
	leal	52(%ecx), %edi
	movl	$2301, -4(%edi)
	movl	0(%esp), %eax
	movl	8(%eax), %ebx
	fldl	(%esi)
	fmull	(%ebx)
	fstpl	(%edi)
	leal	64(%ecx), %edx
	movl	$2301, -4(%edx)
	movl	4(%eax), %ebx
	fldl	(%esi)
	fmull	(%ebx)
	fstpl	(%edx)
	leal	76(%ecx), %ebx
	movl	$2301, -4(%ebx)
	movl	(%eax), %eax
	fldl	(%esi)
	fmull	(%eax)
	fstpl	(%ebx)
	leal	88(%ecx), %eax
	movl	$3072, -4(%eax)
	movl	%ebx, (%eax)
	movl	%edx, 4(%eax)
	movl	%edi, 8(%eax)
	leal	104(%ecx), %esi
	movl	$2301, -4(%esi)
	movl	8(%ebp), %edx
	movl	8(%eax), %ebx
	fldl	(%ebx)
	faddl	(%edx)
	fstpl	(%esi)
	leal	116(%ecx), %edx
	movl	$2301, -4(%edx)
	movl	4(%ebp), %edi
	movl	4(%eax), %ebx
	fldl	(%ebx)
	faddl	(%edi)
	fstpl	(%edx)
	leal	128(%ecx), %ebx
	movl	$2301, -4(%ebx)
	movl	(%ebp), %edi
	movl	(%eax), %eax
	fldl	(%eax)
	faddl	(%edi)
	fstpl	(%ebx)
	leal	140(%ecx), %eax
	movl	$3072, -4(%eax)
	movl	%ebx, (%eax)
	movl	%edx, 4(%eax)
	movl	%esi, 8(%eax)
	addl	$156, %ecx
	movl	$2048, -4(%ecx)
	movl	camlPervasives + 36, %ebx
	movl	%ebx, (%ecx)
	movl	camlCode, %ebx
	movl	%ebx, 4(%ecx)
	movl	camlCode + 24, %esi
	movl	camlCode + 48, %edx
	movl	camlCode + 28, %ebx
	call	camlCode__intersect_1060
.L186:
	movl	(%eax), %eax
	fldl	(%eax)
	fstpl	12(%esp)
	movl	camlPervasives + 36, %eax
	fldl	(%eax)
	fcompl	12(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L176
	movl	$camlCode__18, %eax
	addl	$20, %esp
	ret
	.align	16
.L176:
.L187:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L188
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	4(%esp)
	fstpl	(%eax)
	addl	$20, %esp
	ret
.L188:	call	caml_call_gc
.L189:	jmp	.L187
.L184:	call	caml_call_gc
.L185:	jmp	.L183
.L180:	call	caml_call_gc
.L181:	jmp	.L179
	.type	camlCode__ray_trace_1089,@function
	.size	camlCode__ray_trace_1089,.-camlCode__ray_trace_1089
	.text
	.align	16
	.globl	camlCode__aux_1095
camlCode__aux_1095:
	subl	$8, %esp
.L190:
	movl	%eax, %ecx
.L191:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L192
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	movl	$4, %edx
	pushl	%edx
	fildl	(%esp)
	addl	$4, %esp
	sarl	$1, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	fldl	.L194
	movl	camlCode + 44, %ebx
	sarl	$1, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	sarl	$1, %ecx
	pushl	%ecx
	fildl	(%esp)
	addl	$4, %esp
	fsubp	%st, %st(1)
	faddp	%st, %st(1)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L192:	call	caml_call_gc
.L193:	jmp	.L191
	.data
.L194:	.long	0x0, 0x40000000
	.type	camlCode__aux_1095,@function
	.size	camlCode__aux_1095,.-camlCode__aux_1095
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$56, %esp
.L207:
	movl	$camlCode__1, %eax
	movl	%eax, camlCode
	movl	$camlCode__17, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__16, %eax
	movl	%eax, camlCode + 8
	movl	$camlCode__15, %eax
	movl	%eax, camlCode + 12
	movl	$camlCode__14, %eax
	movl	%eax, camlCode + 16
	movl	$camlCode__13, %eax
	movl	%eax, camlCode + 20
	movl	$camlCode__12, %eax
	movl	%eax, camlCode + 24
	movl	camlCode__2 + 4, %ebx
	movl	camlCode__2 + 4, %eax
	fldl	(%eax)
	fmull	(%ebx)
	movl	camlCode__2, %ebx
	movl	camlCode__2, %eax
	fldl	(%eax)
	fmull	(%ebx)
	faddp	%st, %st(1)
	movl	camlCode__2 + 8, %ebx
	movl	camlCode__2 + 8, %eax
	fldl	(%eax)
	fmull	(%ebx)
	faddp	%st, %st(1)
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	32(%esp)
	fld1
	fdivl	32(%esp)
	fstpl	32(%esp)
	movl	$52, %eax
	call	caml_allocN
.L208:
	leal	4(%eax), %edx
	movl	$2301, -4(%edx)
	movl	camlCode__2 + 8, %eax
	fldl	32(%esp)
	fmull	(%eax)
	fstpl	(%edx)
	leal	12(%edx), %ecx
	movl	$2301, -4(%ecx)
	movl	camlCode__2 + 4, %eax
	fldl	32(%esp)
	fmull	(%eax)
	fstpl	(%ecx)
	leal	24(%edx), %ebx
	movl	$2301, -4(%ebx)
	movl	camlCode__2, %eax
	fldl	32(%esp)
	fmull	(%eax)
	fstpl	(%ebx)
	leal	36(%edx), %eax
	movl	$3072, -4(%eax)
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	movl	%edx, 8(%eax)
	movl	%eax, camlCode + 28
	movl	$9, camlCode + 32
	movl	$camlCode__11, %eax
	movl	%eax, camlCode + 36
	call	.L206
	movl	$camlCode__3, %ebx
	jmp	.L205
.L206:
	pushl	caml_exception_pointer
	movl	%esp, caml_exception_pointer
	movl	camlSys, %ebx
	movl	-4(%ebx), %eax
	shrl	$9, %eax
	cmpl	$5, %eax
	jbe	.L209
	movl	8(%ebx), %eax
	pushl	%eax
	movl	$caml_int_of_string, %eax
	call	caml_c_call
.L210:
	addl	$4, %esp
	movl	%eax, 8(%esp)
	movl	camlSys, %ebx
	movl	-4(%ebx), %eax
	shrl	$9, %eax
	cmpl	$3, %eax
	jbe	.L209
	movl	4(%ebx), %eax
	pushl	%eax
	movl	$caml_int_of_string, %eax
	call	caml_c_call
.L211:
	addl	$4, %esp
	movl	%eax, %ecx
	call	caml_alloc2
.L212:
	leal	4(%eax), %ebx
	movl	$2048, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	8(%esp), %eax
	movl	%eax, 4(%ebx)
	popl	caml_exception_pointer
	addl	$4, %esp
.L205:
	movl	(%ebx), %eax
	movl	%eax, camlCode + 40
	movl	4(%ebx), %eax
	movl	%eax, camlCode + 44
	movl	camlCode + 36, %edx
	movl	$camlCode__10, %ecx
	movl	$camlCode__4, %ebx
	movl	camlCode + 40, %eax
	call	camlCode__create_1077
.L213:
	movl	%eax, camlCode + 48
	movl	$camlCode__9, %eax
	movl	%eax, camlCode + 52
	movl	$camlCode__8, %eax
	movl	%eax, camlCode + 56
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L214:
	movl	%eax, %ebx
	movl	$camlCode__5, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L215:
	movl	%eax, %ecx
	movl	camlCode + 44, %ebx
	movl	camlCode + 44, %eax
	call	caml_apply2
.L216:
	movl	camlCode + 44, %eax
	addl	$-2, %eax
	cmpl	$1, %eax
	jl	.L195
	movl	%eax, 16(%esp)
.L196:
	movl	$1, %ebx
	movl	%ebx, 20(%esp)
	movl	camlCode + 44, %eax
	addl	$-2, %eax
	movl	%eax, 12(%esp)
	cmpl	%eax, %ebx
	jg	.L197
.L198:
	fldz
	fstpl	32(%esp)
	movl	$1, %edx
	movl	%edx, 24(%esp)
	cmpl	$31, %edx
	jg	.L201
.L202:
	movl	$52, %eax
	call	caml_allocN
.L217:
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	camlCode + 44, %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	(%ecx)
	movl	%edx, %eax
	sarl	$1, %eax
	testl	%eax, %eax
	jge	.L218
	addl	$3, %eax
.L218:	sarl	$2, %eax
	lea	1(%eax, %eax), %eax
	leal	12(%ecx), %esi
	movl	$2301, -4(%esi)
	movl	$4, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	fldl	.L219
	movl	camlCode + 44, %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	movl	16(%esp), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fsubp	%st, %st(1)
	faddp	%st, %st(1)
	fstpl	(%esi)
	sarl	$1, %edx
	movl	%edx, %eax
	testl	%eax, %eax
	jge	.L220
	addl	$3, %eax
.L220:	andl	$-4, %eax
	subl	%eax, %edx
	lea	1(%edx, %edx), %ebx
	leal	24(%ecx), %eax
	movl	$2301, -4(%eax)
	movl	$4, %edx
	pushl	%edx
	fildl	(%esp)
	addl	$4, %esp
	sarl	$1, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	fldl	.L221
	movl	camlCode + 44, %ebx
	sarl	$1, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	movl	20(%esp), %ebx
	sarl	$1, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	fsubp	%st, %st(1)
	faddp	%st, %st(1)
	fstpl	(%eax)
	leal	36(%ecx), %ebx
	movl	$3072, -4(%ebx)
	movl	%eax, (%ebx)
	movl	%esi, 4(%ebx)
	movl	%ecx, 8(%ebx)
	movl	4(%ebx), %ecx
	movl	4(%ebx), %eax
	fldl	(%eax)
	fmull	(%ecx)
	movl	(%ebx), %ecx
	movl	(%ebx), %eax
	fldl	(%eax)
	fmull	(%ecx)
	faddp	%st, %st(1)
	movl	8(%ebx), %ecx
	movl	8(%ebx), %eax
	fldl	(%eax)
	fmull	(%ecx)
	faddp	%st, %st(1)
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	40(%esp)
	fld1
	fdivl	40(%esp)
	fstpl	40(%esp)
	movl	$64, %eax
	call	caml_allocN
.L222:
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	movl	8(%ebx), %ecx
	fldl	40(%esp)
	fmull	(%ecx)
	fstpl	(%eax)
	leal	12(%eax), %edx
	movl	$2301, -4(%edx)
	movl	4(%ebx), %ecx
	fldl	40(%esp)
	fmull	(%ecx)
	fstpl	(%edx)
	leal	24(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	(%ebx), %ebx
	fldl	40(%esp)
	fmull	(%ebx)
	fstpl	(%ecx)
	leal	36(%eax), %ebx
	movl	%ebx, 28(%esp)
	movl	$3072, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	%edx, 4(%ebx)
	movl	%eax, 8(%ebx)
	leal	52(%eax), %ecx
	movl	%ecx, 0(%esp)
	movl	$2048, -4(%ecx)
	movl	camlPervasives + 36, %eax
	movl	%eax, (%ecx)
	movl	camlCode, %eax
	movl	%eax, 4(%ecx)
	movl	camlCode + 24, %eax
	movl	%eax, 8(%esp)
	movl	camlCode + 48, %eax
	movl	%eax, 4(%esp)
	movl	camlCode, %eax
	movl	0(%esp), %ecx
	movl	4(%esp), %edx
	movl	8(%esp), %esi
	call	camlCode__intersect_1060
.L223:
	movl	%eax, %esi
	movl	4(%esi), %ebx
	movl	camlCode + 28, %edx
	movl	4(%edx), %ecx
	movl	4(%ebx), %eax
	fldl	(%eax)
	fmull	(%ecx)
	movl	(%edx), %ecx
	movl	(%ebx), %eax
	fldl	(%eax)
	fmull	(%ecx)
	faddp	%st, %st(1)
	movl	8(%edx), %ecx
	movl	8(%ebx), %eax
	fldl	(%eax)
	fmull	(%ecx)
	faddp	%st, %st(1)
	fstpl	40(%esp)
	fldz
	fcompl	40(%esp)
	fnstsw	%ax
	andb	$5, %ah
	jne	.L204
	fldl	camlCode__7
	fstpl	40(%esp)
	jmp	.L203
.L204:
	movl	camlPervasives + 56, %eax
	pushl	4(%eax)
	pushl	(%eax)
	call	sqrt
	addl	$8, %esp
	fstpl	48(%esp)
	movl	$168, %eax
	call	caml_allocN
.L224:
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	8(%ebx), %eax
	fldl	48(%esp)
	fmull	(%eax)
	fstpl	(%ecx)
	leal	12(%ecx), %eax
	movl	$2301, -4(%eax)
	movl	4(%ebx), %edx
	fldl	48(%esp)
	fmull	(%edx)
	fstpl	(%eax)
	leal	24(%ecx), %edx
	movl	$2301, -4(%edx)
	movl	(%ebx), %ebx
	fldl	48(%esp)
	fmull	(%ebx)
	fstpl	(%edx)
	leal	36(%ecx), %ebp
	movl	$3072, -4(%ebp)
	movl	%edx, (%ebp)
	movl	%eax, 4(%ebp)
	movl	%ecx, 8(%ebp)
	movl	(%esi), %esi
	leal	52(%ecx), %edi
	movl	$2301, -4(%edi)
	movl	28(%esp), %eax
	movl	8(%eax), %ebx
	fldl	(%esi)
	fmull	(%ebx)
	fstpl	(%edi)
	leal	64(%ecx), %edx
	movl	$2301, -4(%edx)
	movl	4(%eax), %ebx
	fldl	(%esi)
	fmull	(%ebx)
	fstpl	(%edx)
	leal	76(%ecx), %ebx
	movl	$2301, -4(%ebx)
	movl	(%eax), %eax
	fldl	(%esi)
	fmull	(%eax)
	fstpl	(%ebx)
	leal	88(%ecx), %eax
	movl	$3072, -4(%eax)
	movl	%ebx, (%eax)
	movl	%edx, 4(%eax)
	movl	%edi, 8(%eax)
	leal	104(%ecx), %esi
	movl	$2301, -4(%esi)
	movl	8(%ebp), %edx
	movl	8(%eax), %ebx
	fldl	(%ebx)
	faddl	(%edx)
	fstpl	(%esi)
	leal	116(%ecx), %edx
	movl	$2301, -4(%edx)
	movl	4(%ebp), %edi
	movl	4(%eax), %ebx
	fldl	(%ebx)
	faddl	(%edi)
	fstpl	(%edx)
	leal	128(%ecx), %ebx
	movl	$2301, -4(%ebx)
	movl	(%ebp), %edi
	movl	(%eax), %eax
	fldl	(%eax)
	faddl	(%edi)
	fstpl	(%ebx)
	leal	140(%ecx), %eax
	movl	$3072, -4(%eax)
	movl	%ebx, (%eax)
	movl	%edx, 4(%eax)
	movl	%esi, 8(%eax)
	addl	$156, %ecx
	movl	$2048, -4(%ecx)
	movl	camlPervasives + 36, %ebx
	movl	%ebx, (%ecx)
	movl	camlCode, %ebx
	movl	%ebx, 4(%ecx)
	movl	camlCode + 24, %esi
	movl	camlCode + 48, %edx
	movl	camlCode + 28, %ebx
	call	camlCode__intersect_1060
.L225:
	movl	(%eax), %eax
	fldl	(%eax)
	fstpl	48(%esp)
	movl	camlPervasives + 36, %eax
	fldl	(%eax)
	fcompl	48(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L203
	fldl	camlCode__6
	fstpl	40(%esp)
.L203:
	fldl	32(%esp)
	faddl	40(%esp)
	fstpl	32(%esp)
	movl	24(%esp), %edx
	movl	%edx, %eax
	addl	$2, %edx
	movl	%edx, 24(%esp)
	cmpl	$31, %eax
	jne	.L202
.L201:
	fldl	.L226
	fmull	32(%esp)
	movl	$16, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fdivrp	%st, %st(1)
	fldl	.L227
	faddp	%st, %st(1)
	fstpl	32(%esp)
	fldl	32(%esp)
	subl	$8, %esp
	fnstcw	4(%esp)
	movw	4(%esp), %ax
	movb    $12, %ah
	movw	%ax, 0(%esp)
	fldcw	0(%esp)
	fistpl	(%esp)
	movl	(%esp), %eax
	fldcw	4(%esp)
	addl	$8, %esp
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	jl	.L200
	cmpl	$511, %eax
	jle	.L199
.L200:
	call	caml_alloc2
.L228:
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	$caml_exn_Invalid_argument, (%eax)
	movl	$camlPervasives__2, 4(%eax)
	movl	caml_exception_pointer, %esp
	popl    caml_exception_pointer
	ret
.L199:
	pushl	%eax
	pushl	camlPervasives + 92
	movl	$caml_ml_output_char, %eax
	call	caml_c_call
.L229:
	addl	$8, %esp
	movl	20(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 20(%esp)
	movl	12(%esp), %eax
	cmpl	%eax, %ebx
	jne	.L198
.L197:
	movl	16(%esp), %eax
	movl	%eax, %ebx
	subl	$2, %eax
	movl	%eax, 16(%esp)
	cmpl	$1, %ebx
	jne	.L196
.L195:
	movl	$1, %eax
	addl	$56, %esp
	ret
.L209:	call	caml_ml_array_bound_error
	.data
.L227:	.long	0x0, 0x3fe00000
	.data
.L226:	.long	0x0, 0x406fe000
	.data
.L221:	.long	0x0, 0x40000000
	.data
.L219:	.long	0x0, 0x40000000
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
	.long	43
	.long	.L229
	.word	69
	.word	0
	.align	4
	.long	.L200000 - . + 0x9c000000
	.long	0x166130
	.long	.L228
	.word	60
	.word	0
	.align	4
	.long	.L225
	.word	60
	.word	0
	.align	4
	.long	.L224
	.word	60
	.word	3
	.word	28
	.word	3
	.word	9
	.align	4
	.long	.L223
	.word	60
	.word	1
	.word	28
	.align	4
	.long	.L222
	.word	60
	.word	1
	.word	3
	.align	4
	.long	.L217
	.word	60
	.word	0
	.align	4
	.long	.L216
	.word	60
	.word	0
	.align	4
	.long	.L215
	.word	61
	.word	0
	.align	4
	.long	.L200001 - . + 0x8c000000
	.long	0x281110
	.long	.L214
	.word	61
	.word	0
	.align	4
	.long	.L200001 - . + 0x8c000000
	.long	0x281110
	.long	.L213
	.word	60
	.word	0
	.align	4
	.long	.L212
	.word	68
	.word	2
	.word	8
	.word	5
	.align	4
	.long	.L211
	.word	72
	.word	1
	.word	12
	.align	4
	.long	.L210
	.word	72
	.word	0
	.align	4
	.long	.L208
	.word	60
	.word	0
	.align	4
	.long	.L193
	.word	12
	.word	2
	.word	3
	.word	5
	.align	4
	.long	.L189
	.word	24
	.word	0
	.align	4
	.long	.L186
	.word	24
	.word	0
	.align	4
	.long	.L185
	.word	24
	.word	3
	.word	0
	.word	3
	.word	9
	.align	4
	.long	.L182
	.word	24
	.word	1
	.word	0
	.align	4
	.long	.L181
	.word	24
	.word	2
	.word	0
	.word	3
	.align	4
	.long	.L174
	.word	56
	.word	5
	.word	0
	.word	16
	.word	20
	.word	24
	.word	5
	.align	4
	.long	.L171
	.word	56
	.word	4
	.word	0
	.word	16
	.word	20
	.word	24
	.align	4
	.long	.L169
	.word	56
	.word	7
	.word	4
	.word	8
	.word	12
	.word	16
	.word	20
	.word	24
	.word	3
	.align	4
	.long	.L166
	.word	56
	.word	6
	.word	4
	.word	8
	.word	12
	.word	16
	.word	20
	.word	24
	.align	4
	.long	.L164
	.word	56
	.word	7
	.word	0
	.word	8
	.word	12
	.word	16
	.word	20
	.word	24
	.word	3
	.align	4
	.long	.L161
	.word	56
	.word	6
	.word	0
	.word	8
	.word	12
	.word	16
	.word	20
	.word	24
	.align	4
	.long	.L159
	.word	56
	.word	6
	.word	8
	.word	12
	.word	16
	.word	20
	.word	24
	.word	3
	.align	4
	.long	.L156
	.word	56
	.word	5
	.word	8
	.word	12
	.word	16
	.word	20
	.word	24
	.align	4
	.long	.L154
	.word	56
	.word	7
	.word	8
	.word	12
	.word	16
	.word	20
	.word	24
	.word	9
	.word	3
	.align	4
	.long	.L149
	.word	56
	.word	4
	.word	7
	.word	9
	.word	3
	.word	11
	.align	4
	.long	.L144
	.word	52
	.word	2
	.word	4
	.word	3
	.align	4
	.long	.L141
	.word	52
	.word	5
	.word	3
	.word	13
	.word	0
	.word	4
	.word	7
	.align	4
	.long	.L138
	.word	53
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L200002 - . + 0x88000000
	.long	0x4a180
	.long	.L137
	.word	52
	.word	2
	.word	16
	.word	20
	.align	4
	.long	.L136
	.word	52
	.word	6
	.word	3
	.word	13
	.word	12
	.word	16
	.word	20
	.word	9
	.align	4
	.long	.L133
	.word	52
	.word	6
	.word	3
	.word	13
	.word	12
	.word	16
	.word	20
	.word	9
	.align	4
	.long	.L130
	.word	52
	.word	7
	.word	0
	.word	4
	.word	8
	.word	12
	.word	16
	.word	20
	.word	9
	.align	4
	.long	.L119
	.word	12
	.word	1
	.word	9
	.align	4
	.long	.L115
	.word	12
	.word	2
	.word	3
	.word	5
	.align	4
	.long	.L111
	.word	12
	.word	2
	.word	3
	.word	11
	.align	4
	.long	.L107
	.word	12
	.word	2
	.word	3
	.word	11
	.align	4
	.long	.L103
	.word	12
	.word	2
	.word	3
	.word	9
	.align	4
.L200000:
	.ascii	"pervasives.ml\0"
	.align	4
.L200001:
	.ascii	"printf.ml\0"
	.align	4
.L200002:
	.ascii	"list.ml\0"
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

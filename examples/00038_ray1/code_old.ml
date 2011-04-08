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
  (let (zero/1030 [0: 0. 0. 0.]) (setfield_imm 0 (global Code!) zero/1030))
  (let
    (*|/1031
       (function s/1032 param/1117
         (let
           (rz/1035 (field 2 param/1117)
            ry/1034 (field 1 param/1117)
            rx/1033 (field 0 param/1117))
           (makeblock 0 (*. s/1032 rx/1033) (*. s/1032 ry/1034)
             (*. s/1032 rz/1035)))))
    (setfield_imm 1 (global Code!) *|/1031))
  (let
    (+|/1036
       (function param/1118 param/1119
         (let
           (bz/1042 (field 2 param/1119)
            by/1041 (field 1 param/1119)
            bx/1040 (field 0 param/1119)
            az/1039 (field 2 param/1118)
            ay/1038 (field 1 param/1118)
            ax/1037 (field 0 param/1118))
           (makeblock 0 (+. ax/1037 bx/1040) (+. ay/1038 by/1041)
             (+. az/1039 bz/1042)))))
    (setfield_imm 2 (global Code!) +|/1036))
  (let
    (-|/1043
       (function param/1120 param/1121
         (let
           (bz/1049 (field 2 param/1121)
            by/1048 (field 1 param/1121)
            bx/1047 (field 0 param/1121)
            az/1046 (field 2 param/1120)
            ay/1045 (field 1 param/1120)
            ax/1044 (field 0 param/1120))
           (makeblock 0 (-. ax/1044 bx/1047) (-. ay/1045 by/1048)
             (-. az/1046 bz/1049)))))
    (setfield_imm 3 (global Code!) -|/1043))
  (let
    (dot/1050
       (function param/1122 param/1123
         (let
           (bz/1056 (field 2 param/1123)
            by/1055 (field 1 param/1123)
            bx/1054 (field 0 param/1123)
            az/1053 (field 2 param/1122)
            ay/1052 (field 1 param/1122)
            ax/1051 (field 0 param/1122))
           (+. (+. (*. ax/1051 bx/1054) (*. ay/1052 by/1055))
             (*. az/1053 bz/1056)))))
    (setfield_imm 4 (global Code!) dot/1050))
  (let
    (unitise/1057
       (function r/1058
         (apply (field 1 (global Code!))
           (/. 1.
             (caml_sqrt_float (apply (field 4 (global Code!)) r/1058 r/1058)))
           r/1058)))
    (setfield_imm 5 (global Code!) unitise/1057))
  (letrec
    (intersect/1059
       (function o/1060 d/1061 hit/1063 param/1124
         (let
           (s/1066 (field 2 param/1124)
            r/1065 (field 1 param/1124)
            c/1064 (field 0 param/1124)
            match/1125 (field 1 hit/1063)
            l/1062 (field 0 hit/1063)
            v/1067 (apply (field 3 (global Code!)) c/1064 o/1060)
            b/1068 (apply (field 4 (global Code!)) v/1067 d/1061)
            disc/1069
              (caml_sqrt_float
                (+.
                  (-. (*. b/1068 b/1068)
                    (apply (field 4 (global Code!)) v/1067 v/1067))
                  (*. r/1065 r/1065)))
            t1/1070 (-. b/1068 disc/1069)
            t2/1071 (+. b/1068 disc/1069)
            l'/1072
              (if (>. t2/1071 0.) (if (>. t1/1070 0.) t1/1070 t2/1071)
                (field 9 (global Pervasives!))))
           (if (>=. l'/1072 l/1062) hit/1063
             (catch
               (if s/1066 (exit 7)
                 (makeblock 0 l'/1072
                   (apply (field 5 (global Code!))
                     (apply (field 3 (global Code!))
                       (apply (field 2 (global Code!)) o/1060
                         (apply (field 1 (global Code!)) l'/1072 d/1061))
                       c/1064))))
              with (7)
               (let (ss/1073 s/1066)
                 (apply (field 12 (global List!))
                   (apply intersect/1059 o/1060 d/1061) hit/1063 ss/1073)))))))
    (setfield_imm 6 (global Code!) intersect/1059))
  (let (light/1074 (apply (field 5 (global Code!)) [0: 1. 3. -2.]) ss/1075 4)
    (seq (setfield_imm 7 (global Code!) light/1074)
      (setfield_imm 8 (global Code!) ss/1075)))
  (letrec
    (create/1076
       (function level/1077 c/1078 r/1079
         (let (obj/1080 (makeblock 0 c/1078 r/1079 0a))
           (if (== level/1077 1) obj/1080
             (let
               (a/1081 (/. (*. 3. r/1079) (caml_sqrt_float 12.))
                aux/1082
                  (function x'/1083 z'/1084
                    (apply create/1076 (- level/1077 1)
                      (apply (field 2 (global Code!)) c/1078
                        (makeblock 0 x'/1083 a/1081 z'/1084))
                      (*. 0.5 r/1079))))
               (makeblock 0 c/1078 (*. 3. r/1079)
                 (makeblock 0 obj/1080
                   (makeblock 0 (apply aux/1082 (~. a/1081) (~. a/1081))
                     (makeblock 0 (apply aux/1082 a/1081 (~. a/1081))
                       (makeblock 0 (apply aux/1082 (~. a/1081) a/1081)
                         (makeblock 0 (apply aux/1082 a/1081 a/1081) 0a)))))))))))
    (setfield_imm 9 (global Code!) create/1076))
  (let
    (match/1127
       (try
         (makeblock 0
           (caml_int_of_string (array.get (field 0 (global Sys!)) 1))
           (caml_int_of_string (array.get (field 0 (global Sys!)) 2)))
        with exn/1126 [0: 9 512])
     n/1086 (field 1 match/1127)
     level/1085 (field 0 match/1127))
    (seq (setfield_imm 10 (global Code!) level/1085)
      (setfield_imm 11 (global Code!) n/1086)))
  (let
    (scene/1087
       (apply (field 9 (global Code!)) (field 10 (global Code!))
         [0: 0. -1. 4.] 1.))
    (setfield_imm 12 (global Code!) scene/1087))
  (letrec
    (ray_trace/1088
       (function dir/1089
         (let
           (match/1128
              (apply (field 6 (global Code!)) (field 0 (global Code!))
                dir/1089
                (makeblock 0 (field 9 (global Pervasives!))
                  (field 0 (global Code!)))
                (field 12 (global Code!)))
            n/1091 (field 1 match/1128)
            l/1090 (field 0 match/1128)
            g/1092
              (apply (field 4 (global Code!)) n/1091
                (field 7 (global Code!))))
           (if (<=. g/1092 0.) 0.
             (let
               (p/1093
                  (apply (field 2 (global Code!))
                    (apply (field 1 (global Code!)) l/1090 dir/1089)
                    (apply (field 1 (global Code!))
                      (caml_sqrt_float (field 14 (global Pervasives!)))
                      n/1091)))
               (if
                 (<.
                   (field 0
                     (apply (field 6 (global Code!)) p/1093
                       (field 7 (global Code!))
                       (makeblock 0 (field 9 (global Pervasives!))
                         (field 0 (global Code!)))
                       (field 12 (global Code!))))
                   (field 9 (global Pervasives!)))
                 0. g/1092))))))
    (setfield_imm 13 (global Code!) ray_trace/1088))
  (let
    (aux/1094
       (function x/1095 d/1096
         (+.
           (-. (float_of_int x/1095)
             (/. (float_of_int (field 11 (global Code!))) 2.))
           (/. (float_of_int d/1096) (float_of_int (field 8 (global Code!)))))))
    (setfield_imm 14 (global Code!) aux/1094))
  (apply (field 1 (global Printf!)) "P5\n%d %d\n255\n%!"
    (field 11 (global Code!)) (field 11 (global Code!)))
  (for y/1097 (- (field 11 (global Code!)) 1) downto 0
    (for x/1098 0 to (- (field 11 (global Code!)) 1)
      (let (g/1099 (makemutable 0 0.))
        (seq
          (for d/1100 0 to
            (- (* (field 8 (global Code!)) (field 8 (global Code!))) 1)
            (setfield_ptr 0 g/1099
              (+. (field 0 g/1099)
                (apply (field 13 (global Code!))
                  (apply (field 5 (global Code!))
                    (makeblock 0
                      (apply (field 14 (global Code!)) x/1098
                        (mod d/1100 (field 8 (global Code!))))
                      (apply (field 14 (global Code!)) y/1097
                        (/ d/1100 (field 8 (global Code!))))
                      (float_of_int (field 11 (global Code!)))))))))
          (let
            (g/1101
               (+. 0.5
                 (/. (*. 255. (field 0 g/1099))
                   (float_of_int
                     (* (field 8 (global Code!)) (field 8 (global Code!)))))))
            (apply (field 25 (global Pervasives!))
              (apply (field 16 (global Pervasives!)) (int_of_float g/1101))))))))
  0a)
-dlambda
(seq
  (let (zero/1030 [0: 0. 0. 0.]) (setfield_imm 0 (global Code!) zero/1030))
  (let
    (*|/1031
       (function s/1032 param/1117
         (makeblock 0 (*. s/1032 (field 0 param/1117))
           (*. s/1032 (field 1 param/1117)) (*. s/1032 (field 2 param/1117)))))
    (setfield_imm 1 (global Code!) *|/1031))
  (let
    (+|/1036
       (function param/1118 param/1119
         (makeblock 0 (+. (field 0 param/1118) (field 0 param/1119))
           (+. (field 1 param/1118) (field 1 param/1119))
           (+. (field 2 param/1118) (field 2 param/1119)))))
    (setfield_imm 2 (global Code!) +|/1036))
  (let
    (-|/1043
       (function param/1120 param/1121
         (makeblock 0 (-. (field 0 param/1120) (field 0 param/1121))
           (-. (field 1 param/1120) (field 1 param/1121))
           (-. (field 2 param/1120) (field 2 param/1121)))))
    (setfield_imm 3 (global Code!) -|/1043))
  (let
    (dot/1050
       (function param/1122 param/1123
         (+.
           (+. (*. (field 0 param/1122) (field 0 param/1123))
             (*. (field 1 param/1122) (field 1 param/1123)))
           (*. (field 2 param/1122) (field 2 param/1123)))))
    (setfield_imm 4 (global Code!) dot/1050))
  (let
    (unitise/1057
       (function r/1058
         (apply (field 1 (global Code!))
           (/. 1.
             (caml_sqrt_float (apply (field 4 (global Code!)) r/1058 r/1058)))
           r/1058)))
    (setfield_imm 5 (global Code!) unitise/1057))
  (letrec
    (intersect/1059
       (function o/1060 d/1061 hit/1063 param/1124
         (let
           (s/1066 (field 2 param/1124)
            r/1065 (field 1 param/1124)
            c/1064 (field 0 param/1124)
            v/1067 (apply (field 3 (global Code!)) c/1064 o/1060)
            b/1068 (apply (field 4 (global Code!)) v/1067 d/1061)
            disc/1069
              (caml_sqrt_float
                (+.
                  (-. (*. b/1068 b/1068)
                    (apply (field 4 (global Code!)) v/1067 v/1067))
                  (*. r/1065 r/1065)))
            t1/1070 (-. b/1068 disc/1069)
            t2/1071 (+. b/1068 disc/1069)
            l'/1072
              (if (>. t2/1071 0.) (if (>. t1/1070 0.) t1/1070 t2/1071)
                (field 9 (global Pervasives!))))
           (if (>=. l'/1072 (field 0 hit/1063)) hit/1063
             (if s/1066
               (apply (field 12 (global List!))
                 (apply intersect/1059 o/1060 d/1061) hit/1063 s/1066)
               (makeblock 0 l'/1072
                 (apply (field 5 (global Code!))
                   (apply (field 3 (global Code!))
                     (apply (field 2 (global Code!)) o/1060
                       (apply (field 1 (global Code!)) l'/1072 d/1061))
                     c/1064))))))))
    (setfield_imm 6 (global Code!) intersect/1059))
  (let (light/1074 (apply (field 5 (global Code!)) [0: 1. 3. -2.]) ss/1075 4)
    (seq (setfield_imm 7 (global Code!) light/1074)
      (setfield_imm 8 (global Code!) ss/1075)))
  (letrec
    (create/1076
       (function level/1077 c/1078 r/1079
         (let (obj/1080 (makeblock 0 c/1078 r/1079 0a))
           (if (== level/1077 1) obj/1080
             (let
               (a/1081 (/. (*. 3. r/1079) (caml_sqrt_float 12.))
                aux/1082
                  (function x'/1083 z'/1084
                    (apply create/1076 (- level/1077 1)
                      (apply (field 2 (global Code!)) c/1078
                        (makeblock 0 x'/1083 a/1081 z'/1084))
                      (*. 0.5 r/1079))))
               (makeblock 0 c/1078 (*. 3. r/1079)
                 (makeblock 0 obj/1080
                   (makeblock 0 (apply aux/1082 (~. a/1081) (~. a/1081))
                     (makeblock 0 (apply aux/1082 a/1081 (~. a/1081))
                       (makeblock 0 (apply aux/1082 (~. a/1081) a/1081)
                         (makeblock 0 (apply aux/1082 a/1081 a/1081) 0a)))))))))))
    (setfield_imm 9 (global Code!) create/1076))
  (let
    (match/1127
       (try
         (makeblock 0
           (caml_int_of_string (array.get (field 0 (global Sys!)) 1))
           (caml_int_of_string (array.get (field 0 (global Sys!)) 2)))
        with exn/1126 [0: 9 512]))
    (seq (setfield_imm 10 (global Code!) (field 0 match/1127))
      (setfield_imm 11 (global Code!) (field 1 match/1127))))
  (let
    (scene/1087
       (apply (field 9 (global Code!)) (field 10 (global Code!))
         [0: 0. -1. 4.] 1.))
    (setfield_imm 12 (global Code!) scene/1087))
  (letrec
    (ray_trace/1088
       (function dir/1089
         (let
           (match/1128
              (apply (field 6 (global Code!)) (field 0 (global Code!))
                dir/1089
                (makeblock 0 (field 9 (global Pervasives!))
                  (field 0 (global Code!)))
                (field 12 (global Code!)))
            n/1091 (field 1 match/1128)
            g/1092
              (apply (field 4 (global Code!)) n/1091
                (field 7 (global Code!))))
           (if (<=. g/1092 0.) 0.
             (let
               (p/1093
                  (apply (field 2 (global Code!))
                    (apply (field 1 (global Code!)) (field 0 match/1128)
                      dir/1089)
                    (apply (field 1 (global Code!))
                      (caml_sqrt_float (field 14 (global Pervasives!)))
                      n/1091)))
               (if
                 (<.
                   (field 0
                     (apply (field 6 (global Code!)) p/1093
                       (field 7 (global Code!))
                       (makeblock 0 (field 9 (global Pervasives!))
                         (field 0 (global Code!)))
                       (field 12 (global Code!))))
                   (field 9 (global Pervasives!)))
                 0. g/1092))))))
    (setfield_imm 13 (global Code!) ray_trace/1088))
  (let
    (aux/1094
       (function x/1095 d/1096
         (+.
           (-. (float_of_int x/1095)
             (/. (float_of_int (field 11 (global Code!))) 2.))
           (/. (float_of_int d/1096) (float_of_int (field 8 (global Code!)))))))
    (setfield_imm 14 (global Code!) aux/1094))
  (apply (field 1 (global Printf!)) "P5\n%d %d\n255\n%!"
    (field 11 (global Code!)) (field 11 (global Code!)))
  (for y/1097 (- (field 11 (global Code!)) 1) downto 0
    (for x/1098 0 to (- (field 11 (global Code!)) 1)
      (let (g/1099 0.)
        (seq
          (for d/1100 0 to
            (- (* (field 8 (global Code!)) (field 8 (global Code!))) 1)
            (assign g/1099
              (+. g/1099
                (apply (field 13 (global Code!))
                  (apply (field 5 (global Code!))
                    (makeblock 0
                      (apply (field 14 (global Code!)) x/1098
                        (mod d/1100 (field 8 (global Code!))))
                      (apply (field 14 (global Code!)) y/1097
                        (/ d/1100 (field 8 (global Code!))))
                      (float_of_int (field 11 (global Code!)))))))))
          (let
            (g/1101
               (+. 0.5
                 (/. (*. 255. g/1099)
                   (float_of_int
                     (* (field 8 (global Code!)) (field 8 (global Code!)))))))
            (apply (field 25 (global Pervasives!))
              (apply (field 16 (global Pervasives!)) (int_of_float g/1101))))))))
  0a)

-dcmm
(data int 15360 global "camlCode" "camlCode": skip 60)
(data
 int 3319
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__aux_1094")
(data int 2295 "camlCode__3": addr "camlCode__ray_trace_1088" int 3)
(data
 int 3319
 "camlCode__7":
 addr "caml_curry3"
 int 7
 addr "camlCode__create_1076")
(data
 int 3319
 "camlCode__9":
 addr "caml_curry4"
 int 9
 addr "camlCode__intersect_1059")
(data int 2295 "camlCode__10": addr "camlCode__unitise_1057" int 3)
(data
 int 3319
 "camlCode__11":
 addr "caml_curry2"
 int 5
 addr "camlCode__dot_1050")
(data
 int 3319
 "camlCode__12":
 addr "caml_curry2"
 int 5
 addr "camlCode__-|_1043")
(data
 int 3319
 "camlCode__13":
 addr "caml_curry2"
 int 5
 addr "camlCode__+|_1036")
(data
 int 3319
 "camlCode__14":
 addr "caml_curry2"
 int 5
 addr "camlCode__*|_1031")
(data int 4348 "camlCode__1": string "P5
%d %d
255
%!" skip 0 byte 0)
(data
 int 3072
 "camlCode__4":
 addr L24
 addr L25
 addr L26
 int 2301
 L26:
 double 4.
 int 2301
 L25:
 double -1.
 int 2301
 L24:
 double 0.)
(data int 2301 "camlCode__5": double 1.)
(data int 2048 "camlCode__6": int 19 int 1025)
(data
 int 3072
 "camlCode__8":
 addr L21
 addr L22
 addr L23
 int 2301
 L23:
 double -2.
 int 2301
 L22:
 double 3.
 int 2301
 L21:
 double 1.)
(data
 int 3072
 "camlCode__15":
 addr L18
 addr L19
 addr L20
 int 2301
 L20:
 double 0.
 int 2301
 L19:
 double 0.
 int 2301
 L18:
 double 0.)
(data int 2301 "camlCode__16": double 0.)
(data int 2301 "camlCode__17": double 0.)
(function camlCode__aux_1082 (x'/1083: addr z'/1084: addr env/1171: addr)
 (app "camlCode__create_1076" (+ (load (+a env/1171 16)) -2)
   (let
     (param/1172 (alloc 3072 x'/1083 (load (+a env/1171 28)) z'/1084)
      param/1173 (load (+a env/1171 20)))
     (alloc 3072
       (alloc 2301
         (+f (load float64u (load param/1173))
           (load float64u (load param/1172))))
       (alloc 2301
         (+f (load float64u (load (+a param/1173 4)))
           (load float64u (load (+a param/1172 4)))))
       (alloc 2301
         (+f (load float64u (load (+a param/1173 8)))
           (load float64u (load (+a param/1172 8)))))))
   (alloc 2301 (*f 0.5 (load float64u (load (+a env/1171 24)))))
   (load (+a env/1171 12)) addr))

(function camlCode__*|_1031 (s/1032: addr param/1117: addr)
 (alloc 3072
   (alloc 2301 (*f (load float64u s/1032) (load float64u (load param/1117))))
   (alloc 2301
     (*f (load float64u s/1032) (load float64u (load (+a param/1117 4)))))
   (alloc 2301
     (*f (load float64u s/1032) (load float64u (load (+a param/1117 8)))))))

(function camlCode__+|_1036 (param/1118: addr param/1119: addr)
 (alloc 3072
   (alloc 2301
     (+f (load float64u (load param/1118)) (load float64u (load param/1119))))
   (alloc 2301
     (+f (load float64u (load (+a param/1118 4)))
       (load float64u (load (+a param/1119 4)))))
   (alloc 2301
     (+f (load float64u (load (+a param/1118 8)))
       (load float64u (load (+a param/1119 8)))))))

(function camlCode__-|_1043 (param/1120: addr param/1121: addr)
 (alloc 3072
   (alloc 2301
     (-f (load float64u (load param/1120)) (load float64u (load param/1121))))
   (alloc 2301
     (-f (load float64u (load (+a param/1120 4)))
       (load float64u (load (+a param/1121 4)))))
   (alloc 2301
     (-f (load float64u (load (+a param/1120 8)))
       (load float64u (load (+a param/1121 8)))))))

(function camlCode__dot_1050 (param/1122: addr param/1123: addr)
 (alloc 2301
   (+f
     (+f
       (*f (load float64u (load param/1122))
         (load float64u (load param/1123)))
       (*f (load float64u (load (+a param/1122 4)))
         (load float64u (load (+a param/1123 4)))))
     (*f (load float64u (load (+a param/1122 8)))
       (load float64u (load (+a param/1123 8)))))))

(function camlCode__unitise_1057 (r/1058: addr)
 (let
   s/1220
     (/f 1.
       (extcall "sqrt"
         (+f
           (+f
             (*f (load float64u (load r/1058)) (load float64u (load r/1058)))
             (*f (load float64u (load (+a r/1058 4)))
               (load float64u (load (+a r/1058 4)))))
           (*f (load float64u (load (+a r/1058 8)))
             (load float64u (load (+a r/1058 8)))))
         float))
   (alloc 3072 (alloc 2301 (*f s/1220 (load float64u (load r/1058))))
     (alloc 2301 (*f s/1220 (load float64u (load (+a r/1058 4)))))
     (alloc 2301 (*f s/1220 (load float64u (load (+a r/1058 8))))))))

(function camlCode__intersect_1059
     (o/1060: addr d/1061: addr hit/1063: addr param/1124: addr
      env/1140: addr)
 (let
   (s/1066 (load (+a param/1124 8)) r/1065 (load (+a param/1124 4))
    c/1064 (load param/1124)
    v/1067
      (alloc 3072
        (alloc 2301
          (-f (load float64u (load c/1064)) (load float64u (load o/1060))))
        (alloc 2301
          (-f (load float64u (load (+a c/1064 4)))
            (load float64u (load (+a o/1060 4)))))
        (alloc 2301
          (-f (load float64u (load (+a c/1064 8)))
            (load float64u (load (+a o/1060 8))))))
    b/1215
      (+f
        (+f (*f (load float64u (load v/1067)) (load float64u (load d/1061)))
          (*f (load float64u (load (+a v/1067 4)))
            (load float64u (load (+a d/1061 4)))))
        (*f (load float64u (load (+a v/1067 8)))
          (load float64u (load (+a d/1061 8)))))
    disc/1216
      (extcall "sqrt"
        (+f
          (-f (*f b/1215 b/1215)
            (+f
              (+f
                (*f (load float64u (load v/1067))
                  (load float64u (load v/1067)))
                (*f (load float64u (load (+a v/1067 4)))
                  (load float64u (load (+a v/1067 4)))))
              (*f (load float64u (load (+a v/1067 8)))
                (load float64u (load (+a v/1067 8))))))
          (*f (load float64u r/1065) (load float64u r/1065)))
        float)
    t1/1217 (-f b/1215 disc/1216) t1/1070 (alloc 2301 t1/1217)
    t2/1218 (+f b/1215 disc/1216) t2/1071 (alloc 2301 t2/1218)
    l'/1072
      (if (>f t2/1218 0.) (if (>f t1/1217 0.) t1/1070 t2/1071)
        (load (+a "camlPervasives" 36))))
   (if (>=f (load float64u l'/1072) (load float64u (load hit/1063))) hit/1063
     (if (!= s/1066 1)
       (app "camlList__fold_left_1078"
         (app "caml_apply2" o/1060 d/1061 env/1140 addr) hit/1063 s/1066
         addr)
       (alloc 2048 l'/1072
         (let
           (r/1143
              (let
                param/1142
                  (let
                    param/1141
                      (alloc 3072
                        (alloc 2301
                          (*f (load float64u l'/1072)
                            (load float64u (load d/1061))))
                        (alloc 2301
                          (*f (load float64u l'/1072)
                            (load float64u (load (+a d/1061 4)))))
                        (alloc 2301
                          (*f (load float64u l'/1072)
                            (load float64u (load (+a d/1061 8))))))
                    (alloc 3072
                      (alloc 2301
                        (+f (load float64u (load o/1060))
                          (load float64u (load param/1141))))
                      (alloc 2301
                        (+f (load float64u (load (+a o/1060 4)))
                          (load float64u (load (+a param/1141 4)))))
                      (alloc 2301
                        (+f (load float64u (load (+a o/1060 8)))
                          (load float64u (load (+a param/1141 8)))))))
                (alloc 3072
                  (alloc 2301
                    (-f (load float64u (load param/1142))
                      (load float64u (load c/1064))))
                  (alloc 2301
                    (-f (load float64u (load (+a param/1142 4)))
                      (load float64u (load (+a c/1064 4)))))
                  (alloc 2301
                    (-f (load float64u (load (+a param/1142 8)))
                      (load float64u (load (+a c/1064 8)))))))
            s/1219
              (/f 1.
                (extcall "sqrt"
                  (+f
                    (+f
                      (*f (load float64u (load r/1143))
                        (load float64u (load r/1143)))
                      (*f (load float64u (load (+a r/1143 4)))
                        (load float64u (load (+a r/1143 4)))))
                    (*f (load float64u (load (+a r/1143 8)))
                      (load float64u (load (+a r/1143 8)))))
                  float)))
           (alloc 3072 (alloc 2301 (*f s/1219 (load float64u (load r/1143))))
             (alloc 2301 (*f s/1219 (load float64u (load (+a r/1143 4)))))
             (alloc 2301 (*f s/1219 (load float64u (load (+a r/1143 8))))))))))))

(function camlCode__create_1076
     (level/1077: addr c/1078: addr r/1079: addr env/1167: addr)
 (let obj/1080 (alloc 3072 c/1078 r/1079 1a)
   (if (== level/1077 3) obj/1080
     (let
       (a/1210 (/f (*f 3. (load float64u r/1079)) (extcall "sqrt" 12. float))
        a/1081 (alloc 2301 a/1210)
        aux/1082
          (alloc 8439 "caml_curry2" 5 "camlCode__aux_1082" env/1167
            level/1077 c/1078 r/1079 a/1081))
       (alloc 3072 c/1078 (alloc 2301 (*f 3. (load float64u r/1079)))
         (alloc 2048 obj/1080
           (alloc 2048
             (let
               (z'/1211 (~f a/1210) z'/1174 (alloc 2301 z'/1211)
                x'/1212 (~f a/1210) x'/1175 (alloc 2301 x'/1212))
               (app "camlCode__create_1076" (+ (load (+a aux/1082 16)) -2)
                 (let
                   (param/1176
                      (alloc 3072 x'/1175 (load (+a aux/1082 28)) z'/1174)
                    param/1177 (load (+a aux/1082 20)))
                   (alloc 3072
                     (alloc 2301
                       (+f (load float64u (load param/1177))
                         (load float64u (load param/1176))))
                     (alloc 2301
                       (+f (load float64u (load (+a param/1177 4)))
                         (load float64u (load (+a param/1176 4)))))
                     (alloc 2301
                       (+f (load float64u (load (+a param/1177 8)))
                         (load float64u (load (+a param/1176 8)))))))
                 (alloc 2301
                   (*f 0.5 (load float64u (load (+a aux/1082 24)))))
                 (load (+a aux/1082 12)) addr))
             (alloc 2048
               (let (z'/1213 (~f a/1210) z'/1178 (alloc 2301 z'/1213))
                 (app "camlCode__create_1076" (+ (load (+a aux/1082 16)) -2)
                   (let
                     (param/1179
                        (alloc 3072 a/1081 (load (+a aux/1082 28)) z'/1178)
                      param/1180 (load (+a aux/1082 20)))
                     (alloc 3072
                       (alloc 2301
                         (+f (load float64u (load param/1180))
                           (load float64u (load param/1179))))
                       (alloc 2301
                         (+f (load float64u (load (+a param/1180 4)))
                           (load float64u (load (+a param/1179 4)))))
                       (alloc 2301
                         (+f (load float64u (load (+a param/1180 8)))
                           (load float64u (load (+a param/1179 8)))))))
                   (alloc 2301
                     (*f 0.5 (load float64u (load (+a aux/1082 24)))))
                   (load (+a aux/1082 12)) addr))
               (alloc 2048
                 (let (x'/1214 (~f a/1210) x'/1181 (alloc 2301 x'/1214))
                   (app "camlCode__create_1076"
                     (+ (load (+a aux/1082 16)) -2)
                     (let
                       (param/1182
                          (alloc 3072 x'/1181 (load (+a aux/1082 28)) a/1081)
                        param/1183 (load (+a aux/1082 20)))
                       (alloc 3072
                         (alloc 2301
                           (+f (load float64u (load param/1183))
                             (load float64u (load param/1182))))
                         (alloc 2301
                           (+f (load float64u (load (+a param/1183 4)))
                             (load float64u (load (+a param/1182 4)))))
                         (alloc 2301
                           (+f (load float64u (load (+a param/1183 8)))
                             (load float64u (load (+a param/1182 8)))))))
                     (alloc 2301
                       (*f 0.5 (load float64u (load (+a aux/1082 24)))))
                     (load (+a aux/1082 12)) addr))
                 (alloc 2048
                   (app "camlCode__create_1076"
                     (+ (load (+a aux/1082 16)) -2)
                     (let
                       (param/1184
                          (alloc 3072 a/1081 (load (+a aux/1082 28)) a/1081)
                        param/1185 (load (+a aux/1082 20)))
                       (alloc 3072
                         (alloc 2301
                           (+f (load float64u (load param/1185))
                             (load float64u (load param/1184))))
                         (alloc 2301
                           (+f (load float64u (load (+a param/1185 4)))
                             (load float64u (load (+a param/1184 4)))))
                         (alloc 2301
                           (+f (load float64u (load (+a param/1185 8)))
                             (load float64u (load (+a param/1184 8)))))))
                     (alloc 2301
                       (*f 0.5 (load float64u (load (+a aux/1082 24)))))
                     (load (+a aux/1082 12)) addr)
                   1a))))))))))

(function camlCode__ray_trace_1088 (dir/1089: addr)
 (let
   (match/1128
      (app "camlCode__intersect_1059" (load "camlCode") dir/1089
        (alloc 2048 (load (+a "camlPervasives" 36)) (load "camlCode"))
        (load (+a "camlCode" 48)) (load (+a "camlCode" 24)) addr)
    n/1091 (load (+a match/1128 4))
    g/1092
      (let param/1188 (load (+a "camlCode" 28))
        (alloc 2301
          (+f
            (+f
              (*f (load float64u (load n/1091))
                (load float64u (load param/1188)))
              (*f (load float64u (load (+a n/1091 4)))
                (load float64u (load (+a param/1188 4)))))
            (*f (load float64u (load (+a n/1091 8)))
              (load float64u (load (+a param/1188 8))))))))
   (if (<=f (load float64u g/1092) 0.) "camlCode__17"
     (let
       p/1093
         (let
           (param/1191
              (let
                s/1209
                  (extcall "sqrt"
                    (load float64u (load (+a "camlPervasives" 56))) float)
                (alloc 3072
                  (alloc 2301 (*f s/1209 (load float64u (load n/1091))))
                  (alloc 2301
                    (*f s/1209 (load float64u (load (+a n/1091 4)))))
                  (alloc 2301
                    (*f s/1209 (load float64u (load (+a n/1091 8)))))))
            param/1192
              (let s/1189 (load match/1128)
                (alloc 3072
                  (alloc 2301
                    (*f (load float64u s/1189)
                      (load float64u (load dir/1089))))
                  (alloc 2301
                    (*f (load float64u s/1189)
                      (load float64u (load (+a dir/1089 4)))))
                  (alloc 2301
                    (*f (load float64u s/1189)
                      (load float64u (load (+a dir/1089 8))))))))
           (alloc 3072
             (alloc 2301
               (+f (load float64u (load param/1192))
                 (load float64u (load param/1191))))
             (alloc 2301
               (+f (load float64u (load (+a param/1192 4)))
                 (load float64u (load (+a param/1191 4)))))
             (alloc 2301
               (+f (load float64u (load (+a param/1192 8)))
                 (load float64u (load (+a param/1191 8)))))))
       (if
         (<f
           (load float64u
             (load
               (app "camlCode__intersect_1059" p/1093
                 (load (+a "camlCode" 28))
                 (alloc 2048 (load (+a "camlPervasives" 36))
                   (load "camlCode"))
                 (load (+a "camlCode" 48)) (load (+a "camlCode" 24)) addr)))
           (load float64u (load (+a "camlPervasives" 36))))
         "camlCode__16" g/1092)))))

(function camlCode__aux_1094 (x/1095: addr d/1096: addr)
 (alloc 2301
   (+f
     (-f (floatofint (>>s x/1095 1))
       (/f (floatofint (>>s (load (+a "camlCode" 44)) 1)) 2.))
     (/f (floatofint (>>s d/1096 1)) (floatofint 4)))))

(function camlCode__entry ()
 (let zero/1030 "camlCode__15" (store "camlCode" zero/1030))
 (let *|/1031 "camlCode__14" (store (+a "camlCode" 4) *|/1031))
 (let +|/1036 "camlCode__13" (store (+a "camlCode" 8) +|/1036))
 (let -|/1043 "camlCode__12" (store (+a "camlCode" 12) -|/1043))
 (let dot/1050 "camlCode__11" (store (+a "camlCode" 16) dot/1050))
 (let unitise/1057 "camlCode__10" (store (+a "camlCode" 20) unitise/1057))
 (let clos/1145 "camlCode__9" (store (+a "camlCode" 24) clos/1145))
 (let
   light/1074
     (let
       (r/1146 "camlCode__8"
        s/1208
          (/f 1.
            (extcall "sqrt"
              (+f
                (+f
                  (*f (load float64u (load r/1146))
                    (load float64u (load r/1146)))
                  (*f (load float64u (load (+a r/1146 4)))
                    (load float64u (load (+a r/1146 4)))))
                (*f (load float64u (load (+a r/1146 8)))
                  (load float64u (load (+a r/1146 8)))))
              float)))
       (alloc 3072 (alloc 2301 (*f s/1208 (load float64u (load r/1146))))
         (alloc 2301 (*f s/1208 (load float64u (load (+a r/1146 4)))))
         (alloc 2301 (*f s/1208 (load float64u (load (+a r/1146 8)))))))
   (store (+a "camlCode" 28) light/1074) (store (+a "camlCode" 32) 9))
 (let clos/1186 "camlCode__7" (store (+a "camlCode" 36) clos/1186))
 (let
   match/1127
     (try
       (alloc 2048
         (extcall "caml_int_of_string"
           (let arr/1206 (load "camlSys")
             (checkbound (>>u (load (+a arr/1206 -4)) 9) 3)
             (load (+a arr/1206 4)))
           addr)
         (extcall "caml_int_of_string"
           (let arr/1207 (load "camlSys")
             (checkbound (>>u (load (+a arr/1207 -4)) 9) 5)
             (load (+a arr/1207 8)))
           addr))
     with exn/1126 "camlCode__6")
   (store (+a "camlCode" 40) (load match/1127))
   (store (+a "camlCode" 44) (load (+a match/1127 4))))
 (let
   scene/1087
     (app "camlCode__create_1076" (load (+a "camlCode" 40)) "camlCode__4"
       "camlCode__5" (load (+a "camlCode" 36)) addr)
   (store (+a "camlCode" 48) scene/1087))
 (let clos/1193 "camlCode__3" (store (+a "camlCode" 52) clos/1193))
 (let aux/1094 "camlCode__2" (store (+a "camlCode" 56) aux/1094))
 (app "caml_apply2" (load (+a "camlCode" 44)) (load (+a "camlCode" 44))
   (app "camlPrintf__printf_1393" "camlCode__1" addr) unit)
 (let y/1097 (+ (load (+a "camlCode" 44)) -2)
   (catch
     (if (< y/1097 1) (exit 28)
       (loop
         (let (x/1098 1 bound/1201 (+ (load (+a "camlCode" 44)) -2))
           (catch
             (if (> x/1098 bound/1201) (exit 29)
               (loop
                 (let g/1202 0.
                   (let d/1100 1
                     (catch
                       (if (> d/1100 31) (exit 30)
                         (loop
                           (assign g/1202
                                     (+f g/1202
                                       (load float64u
                                         (app "camlCode__ray_trace_1088"
                                           (let
                                             (r/1197
                                                (alloc 3072
                                                  (let
                                                    d/1195
                                                      (+
                                                        (<<
                                                          (mod (>>s d/1100 1)
                                                            4)
                                                          1)
                                                        1)
                                                    (alloc 2301
                                                      (+f
                                                        (-f
                                                          (floatofint
                                                            (>>s x/1098 1))
                                                          (/f
                                                            (floatofint
                                                              (>>s
                                                                (load
                                                                  (+a
                                                                    "camlCode"
                                                                    44))
                                                                1))
                                                            2.))
                                                        (/f
                                                          (floatofint
                                                            (>>s d/1195 1))
                                                          (floatofint 4)))))
                                                  (let
                                                    d/1196
                                                      (+
                                                        (<<
                                                          (/ (>>s d/1100 1)
                                                            4)
                                                          1)
                                                        1)
                                                    (alloc 2301
                                                      (+f
                                                        (-f
                                                          (floatofint
                                                            (>>s y/1097 1))
                                                          (/f
                                                            (floatofint
                                                              (>>s
                                                                (load
                                                                  (+a
                                                                    "camlCode"
                                                                    44))
                                                                1))
                                                            2.))
                                                        (/f
                                                          (floatofint
                                                            (>>s d/1196 1))
                                                          (floatofint 4)))))
                                                  (alloc 2301
                                                    (floatofint
                                                      (>>s
                                                        (load
                                                          (+a "camlCode" 44))
                                                        1))))
                                              s/1205
                                                (/f 1.
                                                  (extcall "sqrt"
                                                    (+f
                                                      (+f
                                                        (*f
                                                          (load float64u
                                                            (load r/1197))
                                                          (load float64u
                                                            (load r/1197)))
                                                        (*f
                                                          (load float64u
                                                            (load
                                                              (+a r/1197 4)))
                                                          (load float64u
                                                            (load
                                                              (+a r/1197 4)))))
                                                      (*f
                                                        (load float64u
                                                          (load
                                                            (+a r/1197 8)))
                                                        (load float64u
                                                          (load
                                                            (+a r/1197 8)))))
                                                    float)))
                                             (alloc 3072
                                               (alloc 2301
                                                 (*f s/1205
                                                   (load float64u
                                                     (load r/1197))))
                                               (alloc 2301
                                                 (*f s/1205
                                                   (load float64u
                                                     (load (+a r/1197 4)))))
                                               (alloc 2301
                                                 (*f s/1205
                                                   (load float64u
                                                     (load (+a r/1197 8)))))))
                                           addr))))
                           (let d/1204 d/1100 (assign d/1100 (+ d/1100 2))
                             (if (== d/1204 31) (exit 30) []))))
                     with(30) []))
                   (let g/1203 (+f 0.5 (/f (*f 255. g/1202) (floatofint 16)))
                     (app "camlPervasives__print_char_1266"
                       (app "camlPervasives__char_of_int_1120"
                         (+ (<< (intoffloat g/1203) 1) 1) addr)
                       unit)))
                 (let x/1200 x/1098 (assign x/1098 (+ x/1098 2))
                   (if (== x/1200 bound/1201) (exit 29) []))))
           with(29) []))
         (let y/1199 y/1097 (assign y/1097 (- y/1097 2))
           (if (== y/1199 1) (exit 28) []))))
   with(28) []))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__aux_1082:
  x'/8[%edx] := R/0[%eax]
  spilled-env/37[s0] := env/10[%ecx] (spill)
  {x'/8[%edx]* z'/9[%ebx]* env/10[%ecx]* spilled-env/37[s0]*}
  A/11[%edi] := alloc 80
  [A/11[%edi] + -4] := 2301
  A/12[%eax] := [env/10[%ecx] + 24]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] *f float64[A/12[%eax]]
  float64u[A/11[%edi]] := R/7[%tos]
  param/15[%eax] := A/11[%edi] + 12
  [param/15[%eax] + -4] := 3072
  [param/15[%eax]] := x'/8[%edx]
  A/16[%edx] := [env/10[%ecx] + 28]
  [param/15[%eax] + 4] := A/16[%edx]
  [param/15[%eax] + 8] := z'/9[%ebx]
  param/17[%ebx] := [env/10[%ecx] + 20]
  A/18[%ecx] := A/11[%edi] + 28
  [A/18[%ecx] + -4] := 2301
  A/19[%esi] := [param/15[%eax] + 8]
  A/20[%edx] := [param/17[%ebx] + 8]
  R/7[%tos] := float64u[A/20[%edx]]
  R/7[%tos] := R/7[%tos] +f float64[A/19[%esi]]
  float64u[A/18[%ecx]] := R/7[%tos]
  A/23[%esi] := A/11[%edi] + 40
  [A/23[%esi] + -4] := 2301
  A/24[%ebp] := [param/15[%eax] + 4]
  A/25[%edx] := [param/17[%ebx] + 4]
  R/7[%tos] := float64u[A/25[%edx]]
  R/7[%tos] := R/7[%tos] +f float64[A/24[%ebp]]
  float64u[A/23[%esi]] := R/7[%tos]
  A/28[%edx] := A/11[%edi] + 52
  [A/28[%edx] + -4] := 2301
  A/29[%ebp] := [param/15[%eax]]
  A/30[%eax] := [param/17[%ebx]]
  R/7[%tos] := float64u[A/30[%eax]]
  R/7[%tos] := R/7[%tos] +f float64[A/29[%ebp]]
  float64u[A/28[%edx]] := R/7[%tos]
  A/33[%ebx] := A/11[%edi] + 64
  [A/33[%ebx] + -4] := 3072
  [A/33[%ebx]] := A/28[%edx]
  [A/33[%ebx] + 4] := A/23[%esi]
  [A/33[%ebx] + 8] := A/18[%ecx]
  env/38[%eax] := spilled-env/37[s0] (reload)
  A/34[%edx] := [env/38[%eax] + 12]
  A/35[%eax] := [env/38[%eax] + 16]
  I/36[%eax] := I/36[%eax] + -2
  R/2[%ecx] := A/11[%edi]
  tailcall "camlCode__create_1076" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  
*** Linearized code
camlCode__*|_1031:
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
camlCode__+|_1036:
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
camlCode__-|_1043:
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
camlCode__dot_1050:
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
camlCode__unitise_1057:
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
camlCode__intersect_1059:
  spilled-o/162[s0] := o/8[%eax] (spill)
  spilled-d/161[s1] := d/9[%ebx] (spill)
  spilled-hit/156[s4] := hit/10[%ecx] (spill)
  spilled-env/157[s3] := env/12[%esi] (spill)
  s/13[%eax] := [param/11[%edx] + 8]
  spilled-s/155[s5] := s/13[%eax] (spill)
  r/14[%eax] := [param/11[%edx] + 4]
  spilled-r/160[s2] := r/14[%eax] (spill)
  c/15[%esi] := [param/11[%edx]]
  {c/15[%esi]* spilled-s/155[s5]* spilled-hit/156[s4]* spilled-env/157[s3]*
   spilled-r/160[s2]* spilled-d/161[s1]* spilled-o/162[s0]*}
  A/16[%ebx] := alloc 52
  [A/16[%ebx] + -4] := 2301
  o/163[%ebp] := spilled-o/162[s0] (reload)
  A/17[%ecx] := [o/163[%ebp] + 8]
  A/18[%eax] := [c/15[%esi] + 8]
  R/7[%tos] := float64u[A/18[%eax]]
  R/7[%tos] := R/7[%tos] -f float64[A/17[%ecx]]
  float64u[A/16[%ebx]] := R/7[%tos]
  A/21[%edx] := A/16[%ebx] + 12
  [A/21[%edx] + -4] := 2301
  A/22[%ecx] := [o/163[%ebp] + 4]
  A/23[%eax] := [c/15[%esi] + 4]
  R/7[%tos] := float64u[A/23[%eax]]
  R/7[%tos] := R/7[%tos] -f float64[A/22[%ecx]]
  float64u[A/21[%edx]] := R/7[%tos]
  A/26[%ecx] := A/16[%ebx] + 24
  [A/26[%ecx] + -4] := 2301
  A/27[%edi] := [o/163[%ebp]]
  A/28[%eax] := [c/15[%esi]]
  R/7[%tos] := float64u[A/28[%eax]]
  R/7[%tos] := R/7[%tos] -f float64[A/27[%edi]]
  float64u[A/26[%ecx]] := R/7[%tos]
  v/31[%eax] := A/16[%ebx] + 36
  [v/31[%eax] + -4] := 3072
  [v/31[%eax]] := A/26[%ecx]
  [v/31[%eax] + 4] := A/21[%edx]
  [v/31[%eax] + 8] := A/16[%ebx]
  d/164[%ebx] := spilled-d/161[s1] (reload)
  A/32[%edx] := [d/164[%ebx] + 4]
  A/33[%ecx] := [v/31[%eax] + 4]
  R/7[%tos] := float64u[A/33[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[A/32[%edx]]
  A/36[%edx] := [d/164[%ebx]]
  A/37[%ecx] := [v/31[%eax]]
  R/7[%tos] := float64u[A/37[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[A/36[%edx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/41[%edx] := [d/164[%ebx] + 8]
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
  r/165[%eax] := spilled-r/160[s2] (reload)
  R/7[%tos] := float64u[r/165[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[r/165[%eax]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {c/15[%esi]* b/46[s2] spilled-s/155[s5]* spilled-hit/156[s4]*
   spilled-env/157[s3]* o/163[%ebp]* d/164[%ebx]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  disc/66[s0] := R/7[%tos]
  R/7[%tos] := b/46[s2] -f disc/66[s0]
  t1/68[s1] := R/7[%tos]
  {c/15[%esi]* b/46[s2] disc/66[s0] t1/68[s1] spilled-s/155[s5]*
   spilled-hit/156[s4]* spilled-env/157[s3]* o/163[%ebp]* d/164[%ebx]*}
  t1/69[%ecx] := alloc 24
  [t1/69[%ecx] + -4] := 2301
  float64u[t1/69[%ecx]] := t1/68[s1]
  R/7[%tos] := b/46[s2] +f disc/66[s0]
  t2/71[s0] := R/7[%tos]
  t2/72[%edx] := t1/69[%ecx] + 12
  [t2/72[%edx] + -4] := 2301
  float64u[t2/72[%edx]] := t2/71[s0]
  R/7[%tos] := 0.
  if not t2/71[s0] >f R/7[%tos] goto L128
  R/7[%tos] := 0.
  if not t1/68[s1] >f R/7[%tos] goto L127
  l'/75[%edx] := t1/69[%ecx]
  goto L127
  L128:
  A/76[%edx] := ["camlPervasives" + 36]
  L127:
  hit/166[%ecx] := spilled-hit/156[s4] (reload)
  A/77[%eax] := [hit/166[%ecx]]
  R/7[%tos] := float64u[A/77[%eax]]
  R/7[%tos] := float64u[l'/75[%edx]]
  if not R/7[%tos] >=f R/7[%tos] goto L126
  R/0[%eax] := hit/166[%ecx]
  reload retaddr
  return R/0[%eax]
  L126:
  s/167[%eax] := spilled-s/155[s5] (reload)
  if s/167[%eax] ==s 1 goto L125
  spilled-s/155[s5] := s/167[%eax] (spill)
  spilled-hit/156[s4] := hit/166[%ecx] (spill)
  R/0[%eax] := o/163[%ebp]
  env/168[%ecx] := spilled-env/157[s3] (reload)
  {spilled-s/155[s5]* spilled-hit/156[s4]*}
  R/0[%eax] := call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  hit/169[%ebx] := spilled-hit/156[s4] (reload)
  s/170[%ecx] := spilled-s/155[s5] (reload)
  tailcall "camlList__fold_left_1078" R/0[%eax] R/1[%ebx] R/2[%ecx]
  L125:
  spilled-l'/158[s1] := l'/75[%edx] (spill)
  spilled-c/159[s0] := c/15[%esi] (spill)
  {l'/75[%edx]* spilled-l'/158[s1]* spilled-c/159[s0]* o/163[%ebp]*
   d/164[%ebx]*}
  A/80[%esi] := alloc 156
  [A/80[%esi] + -4] := 2301
  A/81[%eax] := [d/164[%ebx] + 8]
  R/7[%tos] := float64u[l'/75[%edx]]
  R/7[%tos] := R/7[%tos] *f float64[A/81[%eax]]
  float64u[A/80[%esi]] := R/7[%tos]
  A/84[%edi] := A/80[%esi] + 12
  [A/84[%edi] + -4] := 2301
  A/85[%eax] := [d/164[%ebx] + 4]
  R/7[%tos] := float64u[l'/75[%edx]]
  R/7[%tos] := R/7[%tos] *f float64[A/85[%eax]]
  float64u[A/84[%edi]] := R/7[%tos]
  A/88[%ecx] := A/80[%esi] + 24
  [A/88[%ecx] + -4] := 2301
  A/89[%eax] := [d/164[%ebx]]
  R/7[%tos] := float64u[l'/75[%edx]]
  R/7[%tos] := R/7[%tos] *f float64[A/89[%eax]]
  float64u[A/88[%ecx]] := R/7[%tos]
  param/92[%eax] := A/80[%esi] + 36
  [param/92[%eax] + -4] := 3072
  [param/92[%eax]] := A/88[%ecx]
  [param/92[%eax] + 4] := A/84[%edi]
  [param/92[%eax] + 8] := A/80[%esi]
  A/93[%edx] := A/80[%esi] + 52
  [A/93[%edx] + -4] := 2301
  A/94[%ecx] := [param/92[%eax] + 8]
  A/95[%ebx] := [o/163[%ebp] + 8]
  R/7[%tos] := float64u[A/95[%ebx]]
  R/7[%tos] := R/7[%tos] +f float64[A/94[%ecx]]
  float64u[A/93[%edx]] := R/7[%tos]
  A/98[%ecx] := A/80[%esi] + 64
  [A/98[%ecx] + -4] := 2301
  A/99[%edi] := [param/92[%eax] + 4]
  A/100[%ebx] := [o/163[%ebp] + 4]
  R/7[%tos] := float64u[A/100[%ebx]]
  R/7[%tos] := R/7[%tos] +f float64[A/99[%edi]]
  float64u[A/98[%ecx]] := R/7[%tos]
  A/103[%ebx] := A/80[%esi] + 76
  [A/103[%ebx] + -4] := 2301
  A/104[%edi] := [param/92[%eax]]
  A/105[%eax] := [o/163[%ebp]]
  R/7[%tos] := float64u[A/105[%eax]]
  R/7[%tos] := R/7[%tos] +f float64[A/104[%edi]]
  float64u[A/103[%ebx]] := R/7[%tos]
  param/108[%eax] := A/80[%esi] + 88
  [param/108[%eax] + -4] := 3072
  [param/108[%eax]] := A/103[%ebx]
  [param/108[%eax] + 4] := A/98[%ecx]
  [param/108[%eax] + 8] := A/93[%edx]
  A/109[%edi] := A/80[%esi] + 104
  [A/109[%edi] + -4] := 2301
  c/171[%ebx] := spilled-c/159[s0] (reload)
  A/110[%edx] := [c/171[%ebx] + 8]
  A/111[%ecx] := [param/108[%eax] + 8]
  R/7[%tos] := float64u[A/111[%ecx]]
  R/7[%tos] := R/7[%tos] -f float64[A/110[%edx]]
  float64u[A/109[%edi]] := R/7[%tos]
  A/114[%edx] := A/80[%esi] + 116
  [A/114[%edx] + -4] := 2301
  A/115[%ebp] := [c/171[%ebx] + 4]
  A/116[%ecx] := [param/108[%eax] + 4]
  R/7[%tos] := float64u[A/116[%ecx]]
  R/7[%tos] := R/7[%tos] -f float64[A/115[%ebp]]
  float64u[A/114[%edx]] := R/7[%tos]
  A/119[%ecx] := A/80[%esi] + 128
  [A/119[%ecx] + -4] := 2301
  A/120[%ebx] := [c/171[%ebx]]
  A/121[%eax] := [param/108[%eax]]
  R/7[%tos] := float64u[A/121[%eax]]
  R/7[%tos] := R/7[%tos] -f float64[A/120[%ebx]]
  float64u[A/119[%ecx]] := R/7[%tos]
  r/124[%ebx] := A/80[%esi] + 140
  [r/124[%ebx] + -4] := 3072
  [r/124[%ebx]] := A/119[%ecx]
  [r/124[%ebx] + 4] := A/114[%edx]
  [r/124[%ebx] + 8] := A/109[%edi]
  A/125[%ecx] := [r/124[%ebx] + 4]
  A/126[%eax] := [r/124[%ebx] + 4]
  R/7[%tos] := float64u[A/126[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/125[%ecx]]
  A/129[%ecx] := [r/124[%ebx]]
  A/130[%eax] := [r/124[%ebx]]
  R/7[%tos] := float64u[A/130[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/129[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/134[%ecx] := [r/124[%ebx] + 8]
  A/135[%eax] := [r/124[%ebx] + 8]
  R/7[%tos] := float64u[A/135[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/134[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {r/124[%ebx]* spilled-l'/158[s1]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/139[s0] := R/7[%tos]
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] /f F/139[s0]
  s/142[s0] := R/7[%tos]
  {r/124[%ebx]* s/142[s0] spilled-l'/158[s1]*}
  A/143[%eax] := alloc 64
  [A/143[%eax] + -4] := 2301
  A/144[%ecx] := [r/124[%ebx] + 8]
  R/7[%tos] := s/142[s0] *f float64[A/144[%ecx]]
  float64u[A/143[%eax]] := R/7[%tos]
  A/146[%esi] := A/143[%eax] + 12
  [A/146[%esi] + -4] := 2301
  A/147[%ecx] := [r/124[%ebx] + 4]
  R/7[%tos] := s/142[s0] *f float64[A/147[%ecx]]
  float64u[A/146[%esi]] := R/7[%tos]
  A/149[%edx] := A/143[%eax] + 24
  [A/149[%edx] + -4] := 2301
  A/150[%ebx] := [r/124[%ebx]]
  R/7[%tos] := s/142[s0] *f float64[A/150[%ebx]]
  float64u[A/149[%edx]] := R/7[%tos]
  A/152[%ecx] := A/143[%eax] + 36
  [A/152[%ecx] + -4] := 3072
  [A/152[%ecx]] := A/149[%edx]
  [A/152[%ecx] + 4] := A/146[%esi]
  [A/152[%ecx] + 8] := A/143[%eax]
  A/153[%eax] := A/143[%eax] + 52
  [A/153[%eax] + -4] := 2048
  l'/172[%ebx] := spilled-l'/158[s1] (reload)
  [A/153[%eax]] := l'/172[%ebx]
  [A/153[%eax] + 4] := A/152[%ecx]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__create_1076:
  level/8[%edi] := R/0[%eax]
  r/10[%esi] := R/2[%ecx]
  {level/8[%edi]* c/9[%ebx]* r/10[%esi]* env/11[%edx]*}
  obj/12[%eax] := alloc 16
  [obj/12[%eax] + -4] := 3072
  [obj/12[%eax]] := c/9[%ebx]
  [obj/12[%eax] + 4] := r/10[%esi]
  [obj/12[%eax] + 8] := 1
  if level/8[%edi] !=s 3 goto L143
  reload retaddr
  return R/0[%eax]
  L143:
  spilled-obj/152[s5] := obj/12[%eax] (spill)
  spilled-env/163[s0] := env/11[%edx] (spill)
  spilled-r/151[s6] := r/10[%esi] (spill)
  spilled-c/150[s7] := c/9[%ebx] (spill)
  R/7[%tos] := 12.
  push R/7[%tos]
  {level/8[%edi]* c/9[%ebx]* r/10[%esi]* spilled-c/150[s7]*
   spilled-r/151[s6]* spilled-obj/152[s5]* spilled-env/163[s0]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/14[s0] := R/7[%tos]
  R/7[%tos] := 3.
  R/7[%tos] := R/7[%tos] *f float64[r/10[%esi]]
  R/7[%tos] := F/14[s0] /f(rev) R/7[%tos]
  a/18[s0] := R/7[%tos]
  {level/8[%edi]* c/9[%ebx]* r/10[%esi]* a/18[s0] spilled-c/150[s7]*
   spilled-r/151[s6]* spilled-obj/152[s5]* spilled-a/156[s0]
   spilled-env/163[s0]*}
  a/19[%ecx] := alloc 128
  spilled-a/159[s2] := a/19[%ecx] (spill)
  [a/19[%ecx] + -4] := 2301
  float64u[a/19[%ecx]] := a/18[s0]
  aux/20[%eax] := a/19[%ecx] + 12
  spilled-aux/155[s4] := aux/20[%eax] (spill)
  [aux/20[%eax] + -4] := 8439
  [aux/20[%eax]] := "caml_curry2"
  [aux/20[%eax] + 4] := 5
  [aux/20[%eax] + 8] := "camlCode__aux_1082"
  env/164[%edx] := spilled-env/163[s0] (reload)
  [aux/20[%eax] + 12] := env/164[%edx]
  [aux/20[%eax] + 16] := level/8[%edi]
  [aux/20[%eax] + 20] := c/9[%ebx]
  [aux/20[%eax] + 24] := r/10[%esi]
  [aux/20[%eax] + 28] := a/19[%ecx]
  A/21[%edx] := a/19[%ecx] + 48
  A/162[s0] := A/21[%edx] (spill)
  [A/21[%edx] + -4] := 2301
  A/22[%ebx] := [aux/20[%eax] + 24]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] *f float64[A/22[%ebx]]
  float64u[A/21[%edx]] := R/7[%tos]
  param/25[%ebx] := a/19[%ecx] + 60
  [param/25[%ebx] + -4] := 3072
  [param/25[%ebx]] := a/19[%ecx]
  A/26[%edx] := [aux/20[%eax] + 28]
  [param/25[%ebx] + 4] := A/26[%edx]
  [param/25[%ebx] + 8] := a/19[%ecx]
  param/27[%esi] := [aux/20[%eax] + 20]
  A/28[%edi] := a/19[%ecx] + 76
  [A/28[%edi] + -4] := 2301
  A/29[%edx] := [param/25[%ebx] + 8]
  A/30[%eax] := [param/27[%esi] + 8]
  R/7[%tos] := float64u[A/30[%eax]]
  R/7[%tos] := R/7[%tos] +f float64[A/29[%edx]]
  float64u[A/28[%edi]] := R/7[%tos]
  A/33[%edx] := a/19[%ecx] + 88
  [A/33[%edx] + -4] := 2301
  A/34[%ebp] := [param/25[%ebx] + 4]
  A/35[%eax] := [param/27[%esi] + 4]
  R/7[%tos] := float64u[A/35[%eax]]
  R/7[%tos] := R/7[%tos] +f float64[A/34[%ebp]]
  float64u[A/33[%edx]] := R/7[%tos]
  A/38[%eax] := a/19[%ecx] + 100
  [A/38[%eax] + -4] := 2301
  A/39[%ebp] := [param/25[%ebx]]
  A/40[%ebx] := [param/27[%esi]]
  R/7[%tos] := float64u[A/40[%ebx]]
  R/7[%tos] := R/7[%tos] +f float64[A/39[%ebp]]
  float64u[A/38[%eax]] := R/7[%tos]
  A/43[%ebx] := a/19[%ecx] + 112
  [A/43[%ebx] + -4] := 3072
  [A/43[%ebx]] := A/38[%eax]
  [A/43[%ebx] + 4] := A/33[%edx]
  [A/43[%ebx] + 8] := A/28[%edi]
  aux/165[%eax] := spilled-aux/155[s4] (reload)
  A/44[%edx] := [aux/165[%eax] + 12]
  A/45[%eax] := [aux/165[%eax] + 16]
  I/46[%eax] := I/46[%eax] + -2
  A/166[%ecx] := A/162[s0] (reload)
  {spilled-c/150[s7]* spilled-r/151[s6]* spilled-obj/152[s5]*
   spilled-aux/155[s4]* spilled-a/156[s0] spilled-a/159[s2]*}
  R/0[%eax] := call "camlCode__create_1076" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/47[%ebx] := R/0[%eax]
  {A/47[%ebx]* spilled-c/150[s7]* spilled-r/151[s6]* spilled-obj/152[s5]*
   spilled-aux/155[s4]* spilled-a/156[s0] spilled-a/159[s2]*}
  A/48[%eax] := alloc 104
  A/160[s1] := A/48[%eax] (spill)
  [A/48[%eax] + -4] := 2048
  [A/48[%eax]] := A/47[%ebx]
  [A/48[%eax] + 4] := 1
  R/7[%tos] := -f a/167[s0]
  x'/50[s1] := R/7[%tos]
  x'/51[%esi] := A/48[%eax] + 12
  [x'/51[%esi] + -4] := 2301
  float64u[x'/51[%esi]] := x'/50[s1]
  A/52[%edx] := A/48[%eax] + 24
  A/161[s0] := A/52[%edx] (spill)
  [A/52[%edx] + -4] := 2301
  aux/168[%ecx] := spilled-aux/155[s4] (reload)
  A/53[%ebx] := [aux/168[%ecx] + 24]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] *f float64[A/53[%ebx]]
  float64u[A/52[%edx]] := R/7[%tos]
  param/56[%ebx] := A/48[%eax] + 36
  [param/56[%ebx] + -4] := 3072
  [param/56[%ebx]] := x'/51[%esi]
  A/57[%edx] := [aux/168[%ecx] + 28]
  [param/56[%ebx] + 4] := A/57[%edx]
  a/169[%edx] := spilled-a/159[s2] (reload)
  [param/56[%ebx] + 8] := a/169[%edx]
  param/58[%esi] := [aux/168[%ecx] + 20]
  A/59[%edi] := A/48[%eax] + 52
  [A/59[%edi] + -4] := 2301
  A/60[%edx] := [param/56[%ebx] + 8]
  A/61[%ecx] := [param/58[%esi] + 8]
  R/7[%tos] := float64u[A/61[%ecx]]
  R/7[%tos] := R/7[%tos] +f float64[A/60[%edx]]
  float64u[A/59[%edi]] := R/7[%tos]
  A/64[%edx] := A/48[%eax] + 64
  [A/64[%edx] + -4] := 2301
  A/65[%ebp] := [param/56[%ebx] + 4]
  A/66[%ecx] := [param/58[%esi] + 4]
  R/7[%tos] := float64u[A/66[%ecx]]
  R/7[%tos] := R/7[%tos] +f float64[A/65[%ebp]]
  float64u[A/64[%edx]] := R/7[%tos]
  A/69[%ecx] := A/48[%eax] + 76
  [A/69[%ecx] + -4] := 2301
  A/70[%ebp] := [param/56[%ebx]]
  A/71[%ebx] := [param/58[%esi]]
  R/7[%tos] := float64u[A/71[%ebx]]
  R/7[%tos] := R/7[%tos] +f float64[A/70[%ebp]]
  float64u[A/69[%ecx]] := R/7[%tos]
  A/74[%ebx] := A/48[%eax] + 88
  [A/74[%ebx] + -4] := 3072
  [A/74[%ebx]] := A/69[%ecx]
  [A/74[%ebx] + 4] := A/64[%edx]
  [A/74[%ebx] + 8] := A/59[%edi]
  aux/170[%eax] := spilled-aux/155[s4] (reload)
  A/75[%edx] := [aux/170[%eax] + 12]
  A/76[%eax] := [aux/170[%eax] + 16]
  I/77[%eax] := I/77[%eax] + -2
  A/171[%ecx] := A/161[s0] (reload)
  {spilled-c/150[s7]* spilled-r/151[s6]* spilled-obj/152[s5]*
   spilled-aux/155[s4]* spilled-a/156[s0] spilled-a/159[s2]* A/160[s1]*}
  R/0[%eax] := call "camlCode__create_1076" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/78[%ebx] := R/0[%eax]
  {A/78[%ebx]* spilled-c/150[s7]* spilled-r/151[s6]* spilled-obj/152[s5]*
   spilled-aux/155[s4]* spilled-a/156[s0] spilled-a/159[s2]* A/160[s1]*}
  A/79[%eax] := alloc 104
  A/157[s3] := A/79[%eax] (spill)
  [A/79[%eax] + -4] := 2048
  [A/79[%eax]] := A/78[%ebx]
  A/172[%ebx] := A/160[s1] (reload)
  [A/79[%eax] + 4] := A/172[%ebx]
  R/7[%tos] := -f a/173[s0]
  z'/81[s1] := R/7[%tos]
  z'/82[%edx] := A/79[%eax] + 12
  [z'/82[%edx] + -4] := 2301
  float64u[z'/82[%edx]] := z'/81[s1]
  A/83[%esi] := A/79[%eax] + 24
  A/158[s0] := A/83[%esi] (spill)
  [A/83[%esi] + -4] := 2301
  aux/174[%ecx] := spilled-aux/155[s4] (reload)
  A/84[%ebx] := [aux/174[%ecx] + 24]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] *f float64[A/84[%ebx]]
  float64u[A/83[%esi]] := R/7[%tos]
  param/87[%ebx] := A/79[%eax] + 36
  [param/87[%ebx] + -4] := 3072
  a/175[%esi] := spilled-a/159[s2] (reload)
  [param/87[%ebx]] := a/175[%esi]
  A/88[%esi] := [aux/174[%ecx] + 28]
  [param/87[%ebx] + 4] := A/88[%esi]
  [param/87[%ebx] + 8] := z'/82[%edx]
  param/89[%esi] := [aux/174[%ecx] + 20]
  A/90[%edi] := A/79[%eax] + 52
  [A/90[%edi] + -4] := 2301
  A/91[%edx] := [param/87[%ebx] + 8]
  A/92[%ecx] := [param/89[%esi] + 8]
  R/7[%tos] := float64u[A/92[%ecx]]
  R/7[%tos] := R/7[%tos] +f float64[A/91[%edx]]
  float64u[A/90[%edi]] := R/7[%tos]
  A/95[%edx] := A/79[%eax] + 64
  [A/95[%edx] + -4] := 2301
  A/96[%ebp] := [param/87[%ebx] + 4]
  A/97[%ecx] := [param/89[%esi] + 4]
  R/7[%tos] := float64u[A/97[%ecx]]
  R/7[%tos] := R/7[%tos] +f float64[A/96[%ebp]]
  float64u[A/95[%edx]] := R/7[%tos]
  A/100[%ecx] := A/79[%eax] + 76
  [A/100[%ecx] + -4] := 2301
  A/101[%ebp] := [param/87[%ebx]]
  A/102[%ebx] := [param/89[%esi]]
  R/7[%tos] := float64u[A/102[%ebx]]
  R/7[%tos] := R/7[%tos] +f float64[A/101[%ebp]]
  float64u[A/100[%ecx]] := R/7[%tos]
  A/105[%ebx] := A/79[%eax] + 88
  [A/105[%ebx] + -4] := 3072
  [A/105[%ebx]] := A/100[%ecx]
  [A/105[%ebx] + 4] := A/95[%edx]
  [A/105[%ebx] + 8] := A/90[%edi]
  aux/176[%eax] := spilled-aux/155[s4] (reload)
  A/106[%edx] := [aux/176[%eax] + 12]
  A/107[%eax] := [aux/176[%eax] + 16]
  I/108[%eax] := I/108[%eax] + -2
  A/177[%ecx] := A/158[s0] (reload)
  {spilled-c/150[s7]* spilled-r/151[s6]* spilled-obj/152[s5]*
   spilled-aux/155[s4]* spilled-a/156[s0] A/157[s3]*}
  R/0[%eax] := call "camlCode__create_1076" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/109[%ebx] := R/0[%eax]
  {A/109[%ebx]* spilled-c/150[s7]* spilled-r/151[s6]* spilled-obj/152[s5]*
   spilled-aux/155[s4]* spilled-a/156[s0] A/157[s3]*}
  A/110[%eax] := alloc 116
  A/153[s1] := A/110[%eax] (spill)
  [A/110[%eax] + -4] := 2048
  [A/110[%eax]] := A/109[%ebx]
  A/178[%ebx] := A/157[s3] (reload)
  [A/110[%eax] + 4] := A/178[%ebx]
  R/7[%tos] := -f a/179[s0]
  z'/112[s1] := R/7[%tos]
  z'/113[%edx] := A/110[%eax] + 12
  [z'/113[%edx] + -4] := 2301
  float64u[z'/113[%edx]] := z'/112[s1]
  R/7[%tos] := -f a/179[s0]
  x'/115[s0] := R/7[%tos]
  x'/116[%edi] := A/110[%eax] + 24
  [x'/116[%edi] + -4] := 2301
  float64u[x'/116[%edi]] := x'/115[s0]
  A/117[%esi] := A/110[%eax] + 36
  A/154[s0] := A/117[%esi] (spill)
  [A/117[%esi] + -4] := 2301
  aux/180[%ecx] := spilled-aux/155[s4] (reload)
  A/118[%ebx] := [aux/180[%ecx] + 24]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] *f float64[A/118[%ebx]]
  float64u[A/117[%esi]] := R/7[%tos]
  param/121[%ebx] := A/110[%eax] + 48
  [param/121[%ebx] + -4] := 3072
  [param/121[%ebx]] := x'/116[%edi]
  A/122[%esi] := [aux/180[%ecx] + 28]
  [param/121[%ebx] + 4] := A/122[%esi]
  [param/121[%ebx] + 8] := z'/113[%edx]
  param/123[%esi] := [aux/180[%ecx] + 20]
  A/124[%edi] := A/110[%eax] + 64
  [A/124[%edi] + -4] := 2301
  A/125[%edx] := [param/121[%ebx] + 8]
  A/126[%ecx] := [param/123[%esi] + 8]
  R/7[%tos] := float64u[A/126[%ecx]]
  R/7[%tos] := R/7[%tos] +f float64[A/125[%edx]]
  float64u[A/124[%edi]] := R/7[%tos]
  A/129[%edx] := A/110[%eax] + 76
  [A/129[%edx] + -4] := 2301
  A/130[%ebp] := [param/121[%ebx] + 4]
  A/131[%ecx] := [param/123[%esi] + 4]
  R/7[%tos] := float64u[A/131[%ecx]]
  R/7[%tos] := R/7[%tos] +f float64[A/130[%ebp]]
  float64u[A/129[%edx]] := R/7[%tos]
  A/134[%ecx] := A/110[%eax] + 88
  [A/134[%ecx] + -4] := 2301
  A/135[%ebp] := [param/121[%ebx]]
  A/136[%ebx] := [param/123[%esi]]
  R/7[%tos] := float64u[A/136[%ebx]]
  R/7[%tos] := R/7[%tos] +f float64[A/135[%ebp]]
  float64u[A/134[%ecx]] := R/7[%tos]
  A/139[%ebx] := A/110[%eax] + 100
  [A/139[%ebx] + -4] := 3072
  [A/139[%ebx]] := A/134[%ecx]
  [A/139[%ebx] + 4] := A/129[%edx]
  [A/139[%ebx] + 8] := A/124[%edi]
  aux/181[%eax] := spilled-aux/155[s4] (reload)
  A/140[%edx] := [aux/181[%eax] + 12]
  A/141[%eax] := [aux/181[%eax] + 16]
  I/142[%eax] := I/142[%eax] + -2
  A/182[%ecx] := A/154[s0] (reload)
  {spilled-c/150[s7]* spilled-r/151[s6]* spilled-obj/152[s5]* A/153[s1]*}
  R/0[%eax] := call "camlCode__create_1076" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/143[%ecx] := R/0[%eax]
  {A/143[%ecx]* spilled-c/150[s7]* spilled-r/151[s6]* spilled-obj/152[s5]*
   A/153[s1]*}
  A/144[%ebx] := alloc 52
  [A/144[%ebx] + -4] := 2048
  [A/144[%ebx]] := A/143[%ecx]
  A/183[%eax] := A/153[s1] (reload)
  [A/144[%ebx] + 4] := A/183[%eax]
  A/145[%edx] := A/144[%ebx] + 12
  [A/145[%edx] + -4] := 2048
  obj/184[%eax] := spilled-obj/152[s5] (reload)
  [A/145[%edx]] := obj/184[%eax]
  [A/145[%edx] + 4] := A/144[%ebx]
  A/146[%ecx] := A/144[%ebx] + 24
  [A/146[%ecx] + -4] := 2301
  R/7[%tos] := 3.
  r/185[%eax] := spilled-r/151[s6] (reload)
  R/7[%tos] := R/7[%tos] *f float64[r/185[%eax]]
  float64u[A/146[%ecx]] := R/7[%tos]
  A/149[%eax] := A/144[%ebx] + 36
  [A/149[%eax] + -4] := 3072
  c/186[%ebx] := spilled-c/150[s7] (reload)
  [A/149[%eax]] := c/186[%ebx]
  [A/149[%eax] + 4] := A/146[%ecx]
  [A/149[%eax] + 8] := A/145[%edx]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__ray_trace_1088:
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
  R/0[%eax] := call "camlCode__intersect_1059" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
  match/15[%edi] := R/0[%eax]
  n/16[%esi] := [match/15[%edi] + 4]
  param/17[%ebx] := ["camlCode" + 28]
  {match/15[%edi]* n/16[%esi]* param/17[%ebx]* spilled-dir/92[s0]*}
  g/18[%ecx] := alloc 12
  [g/18[%ecx] + -4] := 2301
  A/19[%edx] := [param/17[%ebx] + 4]
  A/20[%eax] := [n/16[%esi] + 4]
  R/7[%tos] := float64u[A/20[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/19[%edx]]
  A/23[%edx] := [param/17[%ebx]]
  A/24[%eax] := [n/16[%esi]]
  R/7[%tos] := float64u[A/24[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/23[%edx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/28[%ebx] := [param/17[%ebx] + 8]
  A/29[%eax] := [n/16[%esi] + 8]
  R/7[%tos] := float64u[A/29[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/28[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  float64u[g/18[%ecx]] := R/7[%tos]
  R/7[%tos] := 0.
  R/7[%tos] := float64u[g/18[%ecx]]
  if not R/7[%tos] <=f R/7[%tos] goto L175
  A/90[%eax] := "camlCode__17"
  reload retaddr
  return R/0[%eax]
  L175:
  spilled-g/91[s1] := g/18[%ecx] (spill)
  A/35[%eax] := ["camlPervasives" + 56]
  pushfloat [A/35[%eax]]
  {match/15[%edi]* n/16[%esi]* spilled-g/91[s1]* spilled-dir/92[s0]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  s/36[s0] := R/7[%tos]
  {match/15[%edi]* n/16[%esi]* s/36[s0] spilled-g/91[s1]*
   spilled-dir/92[s0]*}
  A/37[%ebx] := alloc 168
  [A/37[%ebx] + -4] := 2301
  A/38[%eax] := [n/16[%esi] + 8]
  R/7[%tos] := s/36[s0] *f float64[A/38[%eax]]
  float64u[A/37[%ebx]] := R/7[%tos]
  A/40[%eax] := A/37[%ebx] + 12
  [A/40[%eax] + -4] := 2301
  A/41[%ecx] := [n/16[%esi] + 4]
  R/7[%tos] := s/36[s0] *f float64[A/41[%ecx]]
  float64u[A/40[%eax]] := R/7[%tos]
  A/43[%edx] := A/37[%ebx] + 24
  [A/43[%edx] + -4] := 2301
  A/44[%ecx] := [n/16[%esi]]
  R/7[%tos] := s/36[s0] *f float64[A/44[%ecx]]
  float64u[A/43[%edx]] := R/7[%tos]
  param/46[%ebp] := A/37[%ebx] + 36
  [param/46[%ebp] + -4] := 3072
  [param/46[%ebp]] := A/43[%edx]
  [param/46[%ebp] + 4] := A/40[%eax]
  [param/46[%ebp] + 8] := A/37[%ebx]
  s/47[%esi] := [match/15[%edi]]
  A/48[%edi] := A/37[%ebx] + 52
  [A/48[%edi] + -4] := 2301
  dir/93[%eax] := spilled-dir/92[s0] (reload)
  A/49[%ecx] := [dir/93[%eax] + 8]
  R/7[%tos] := float64u[s/47[%esi]]
  R/7[%tos] := R/7[%tos] *f float64[A/49[%ecx]]
  float64u[A/48[%edi]] := R/7[%tos]
  A/52[%edx] := A/37[%ebx] + 64
  [A/52[%edx] + -4] := 2301
  A/53[%ecx] := [dir/93[%eax] + 4]
  R/7[%tos] := float64u[s/47[%esi]]
  R/7[%tos] := R/7[%tos] *f float64[A/53[%ecx]]
  float64u[A/52[%edx]] := R/7[%tos]
  A/56[%ecx] := A/37[%ebx] + 76
  [A/56[%ecx] + -4] := 2301
  A/57[%eax] := [dir/93[%eax]]
  R/7[%tos] := float64u[s/47[%esi]]
  R/7[%tos] := R/7[%tos] *f float64[A/57[%eax]]
  float64u[A/56[%ecx]] := R/7[%tos]
  param/60[%eax] := A/37[%ebx] + 88
  [param/60[%eax] + -4] := 3072
  [param/60[%eax]] := A/56[%ecx]
  [param/60[%eax] + 4] := A/52[%edx]
  [param/60[%eax] + 8] := A/48[%edi]
  A/61[%esi] := A/37[%ebx] + 104
  [A/61[%esi] + -4] := 2301
  A/62[%edx] := [param/46[%ebp] + 8]
  A/63[%ecx] := [param/60[%eax] + 8]
  R/7[%tos] := float64u[A/63[%ecx]]
  R/7[%tos] := R/7[%tos] +f float64[A/62[%edx]]
  float64u[A/61[%esi]] := R/7[%tos]
  A/66[%edx] := A/37[%ebx] + 116
  [A/66[%edx] + -4] := 2301
  A/67[%edi] := [param/46[%ebp] + 4]
  A/68[%ecx] := [param/60[%eax] + 4]
  R/7[%tos] := float64u[A/68[%ecx]]
  R/7[%tos] := R/7[%tos] +f float64[A/67[%edi]]
  float64u[A/66[%edx]] := R/7[%tos]
  A/71[%ecx] := A/37[%ebx] + 128
  [A/71[%ecx] + -4] := 2301
  A/72[%edi] := [param/46[%ebp]]
  A/73[%eax] := [param/60[%eax]]
  R/7[%tos] := float64u[A/73[%eax]]
  R/7[%tos] := R/7[%tos] +f float64[A/72[%edi]]
  float64u[A/71[%ecx]] := R/7[%tos]
  p/76[%eax] := A/37[%ebx] + 140
  [p/76[%eax] + -4] := 3072
  [p/76[%eax]] := A/71[%ecx]
  [p/76[%eax] + 4] := A/66[%edx]
  [p/76[%eax] + 8] := A/61[%esi]
  A/77[%ecx] := A/37[%ebx] + 156
  [A/77[%ecx] + -4] := 2048
  A/78[%ebx] := ["camlPervasives" + 36]
  [A/77[%ecx]] := A/78[%ebx]
  A/79[%ebx] := ["camlCode"]
  [A/77[%ecx] + 4] := A/79[%ebx]
  A/80[%esi] := ["camlCode" + 24]
  A/81[%edx] := ["camlCode" + 48]
  A/82[%ebx] := ["camlCode" + 28]
  {spilled-g/91[s1]*}
  R/0[%eax] := call "camlCode__intersect_1059" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
  A/84[%eax] := [A/83[%eax]]
  R/7[%tos] := float64u[A/84[%eax]]
  F/86[s0] := R/7[%tos]
  A/87[%eax] := ["camlPervasives" + 36]
  R/7[%tos] := float64u[A/87[%eax]]
  if not F/86[s0] <f R/7[%tos] goto L174
  A/89[%eax] := "camlCode__16"
  reload retaddr
  return R/0[%eax]
  L174:
  g/94[%eax] := spilled-g/91[s1] (reload)
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__aux_1094:
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
camlCode__entry:
  zero/8[%eax] := "camlCode__15"
  ["camlCode"] := zero/8[%eax]
  *|/9[%eax] := "camlCode__14"
  ["camlCode" + 4] := *|/9[%eax]
  +|/10[%eax] := "camlCode__13"
  ["camlCode" + 8] := +|/10[%eax]
  -|/11[%eax] := "camlCode__12"
  ["camlCode" + 12] := -|/11[%eax]
  dot/12[%eax] := "camlCode__11"
  ["camlCode" + 16] := dot/12[%eax]
  unitise/13[%eax] := "camlCode__10"
  ["camlCode" + 20] := unitise/13[%eax]
  clos/14[%eax] := "camlCode__9"
  ["camlCode" + 24] := clos/14[%eax]
  r/15[%ebx] := "camlCode__8"
  A/16[%ecx] := [r/15[%ebx] + 4]
  A/17[%eax] := [r/15[%ebx] + 4]
  R/7[%tos] := float64u[A/17[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/16[%ecx]]
  A/20[%ecx] := [r/15[%ebx]]
  A/21[%eax] := [r/15[%ebx]]
  R/7[%tos] := float64u[A/21[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/20[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/25[%ecx] := [r/15[%ebx] + 8]
  A/26[%eax] := [r/15[%ebx] + 8]
  R/7[%tos] := float64u[A/26[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/25[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {r/15[%ebx]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/30[s0] := R/7[%tos]
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] /f F/30[s0]
  s/33[s0] := R/7[%tos]
  {r/15[%ebx]* s/33[s0]}
  A/34[%eax] := alloc 52
  [A/34[%eax] + -4] := 2301
  A/35[%ecx] := [r/15[%ebx] + 8]
  R/7[%tos] := s/33[s0] *f float64[A/35[%ecx]]
  float64u[A/34[%eax]] := R/7[%tos]
  A/37[%edx] := A/34[%eax] + 12
  [A/37[%edx] + -4] := 2301
  A/38[%ecx] := [r/15[%ebx] + 4]
  R/7[%tos] := s/33[s0] *f float64[A/38[%ecx]]
  float64u[A/37[%edx]] := R/7[%tos]
  A/40[%ecx] := A/34[%eax] + 24
  [A/40[%ecx] + -4] := 2301
  A/41[%ebx] := [r/15[%ebx]]
  R/7[%tos] := s/33[s0] *f float64[A/41[%ebx]]
  float64u[A/40[%ecx]] := R/7[%tos]
  light/43[%ebx] := A/34[%eax] + 36
  [light/43[%ebx] + -4] := 3072
  [light/43[%ebx]] := A/40[%ecx]
  [light/43[%ebx] + 4] := A/37[%edx]
  [light/43[%ebx] + 8] := A/34[%eax]
  ["camlCode" + 28] := light/43[%ebx]
  ["camlCode" + 32] := 9
  clos/44[%eax] := "camlCode__7"
  ["camlCode" + 36] := clos/44[%eax]
  setup trap L200
  A/57[%ebx] := "camlCode__6"
  goto L199
  L200:
  push trap
  arr/45[%ebx] := ["camlSys"]
  A/46[%eax] := [arr/45[%ebx] + -4]
  I/47[%eax] := I/47[%eax] >>u 9
  I/47[%eax] check > 5
  A/48[%eax] := [arr/45[%ebx] + 8]
  push A/48[%eax]
  {}
  R/0[%eax] := extcall "caml_int_of_string"  (noalloc)
  offset stack -4
  A/170[s0] := A/49[%eax] (spill)
  arr/50[%ebx] := ["camlSys"]
  A/51[%eax] := [arr/50[%ebx] + -4]
  I/52[%eax] := I/52[%eax] >>u 9
  I/52[%eax] check > 3
  A/53[%eax] := [arr/50[%ebx] + 4]
  push A/53[%eax]
  {A/170[s0]*}
  R/0[%eax] := extcall "caml_int_of_string"  (noalloc)
  offset stack -4
  A/54[%ecx] := R/0[%eax]
  {A/54[%ecx]* A/170[s0]*}
  match/55[%ebx] := alloc 12
  [match/55[%ebx] + -4] := 2048
  [match/55[%ebx]] := A/54[%ecx]
  A/177[%eax] := A/170[s0] (reload)
  [match/55[%ebx] + 4] := A/177[%eax]
  pop trap
  L199:
  A/58[%eax] := [match/55[%ebx]]
  ["camlCode" + 40] := A/58[%eax]
  A/59[%eax] := [match/55[%ebx] + 4]
  ["camlCode" + 44] := A/59[%eax]
  A/60[%edx] := ["camlCode" + 36]
  A/61[%ecx] := "camlCode__5"
  A/62[%ebx] := "camlCode__4"
  A/63[%eax] := ["camlCode" + 40]
  {}
  R/0[%eax] := call "camlCode__create_1076" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  ["camlCode" + 48] := scene/64[%eax]
  clos/65[%eax] := "camlCode__3"
  ["camlCode" + 52] := clos/65[%eax]
  aux/66[%eax] := "camlCode__2"
  ["camlCode" + 56] := aux/66[%eax]
  A/67[%eax] := "camlCode__1"
  {}
  R/0[%eax] := call "camlPrintf__printf_1393" R/0[%eax]
  A/68[%ecx] := R/0[%eax]
  A/69[%ebx] := ["camlCode" + 44]
  A/70[%eax] := ["camlCode" + 44]
  {}
  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/71[%eax] := ["camlCode" + 44]
  y/72[%eax] := y/72[%eax] + -2
  if y/72[%eax] <s 1 goto L193
  spilled-y/174[s1] := y/72[%eax] (spill)
  L194:
  x/73[%ebx] := 1
  spilled-x/173[s2] := x/73[%ebx] (spill)
  A/74[%eax] := ["camlCode" + 44]
  bound/75[%eax] := bound/75[%eax] + -2
  spilled-bound/175[s0] := bound/75[%eax] (spill)
  if x/73[%ebx] >s bound/75[%eax] goto L195
  L196:
  R/7[%tos] := 0.
  g/77[s0] := R/7[%tos]
  d/78[%edx] := 1
  spilled-d/171[s3] := d/78[%edx] (spill)
  if d/78[%edx] >s 31 goto L197
  L198:
  {d/78[%edx] spilled-d/171[s3] spilled-g/172[s0] spilled-x/173[s2]
   spilled-y/174[s1] spilled-bound/175[s0]}
  A/79[%ebx] := alloc 52
  [A/79[%ebx] + -4] := 2301
  A/80[%eax] := ["camlCode" + 44]
  I/81[%eax] := I/81[%eax] >>s 1
  R/7[%tos] := floatofint I/81[%eax]
  float64u[A/79[%ebx]] := R/7[%tos]
  I/83[%eax] := d/78[%edx]
  I/83[%eax] := I/83[%eax] >>s 1
  I/84[%eax] := I/84[%eax] div 4
  d/85[%eax] := I/84[%eax]  * 2 + 1
  A/86[%ecx] := A/79[%ebx] + 12
  [A/86[%ecx] + -4] := 2301
  I/87[%esi] := 4
  R/7[%tos] := floatofint I/87[%esi]
  I/89[%eax] := I/89[%eax] >>s 1
  R/7[%tos] := floatofint I/89[%eax]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  R/7[%tos] := 2.
  A/93[%eax] := ["camlCode" + 44]
  I/94[%eax] := I/94[%eax] >>s 1
  R/7[%tos] := floatofint I/94[%eax]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  y/178[%eax] := spilled-y/174[s1] (reload)
  I/97[%eax] := I/97[%eax] >>s 1
  R/7[%tos] := floatofint I/97[%eax]
  R/7[%tos] := R/7[%tos] -f R/7[%tos]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  float64u[A/86[%ecx]] := R/7[%tos]
  I/101[%edx] := I/101[%edx] >>s 1
  R/3[%edx] := R/3[%edx] mod 4
  d/103[%edx] := I/102[%edx]  * 2 + 1
  A/104[%eax] := A/79[%ebx] + 24
  [A/104[%eax] + -4] := 2301
  I/105[%esi] := 4
  R/7[%tos] := floatofint I/105[%esi]
  I/107[%edx] := I/107[%edx] >>s 1
  R/7[%tos] := floatofint I/107[%edx]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  R/7[%tos] := 2.
  A/111[%edx] := ["camlCode" + 44]
  I/112[%edx] := I/112[%edx] >>s 1
  R/7[%tos] := floatofint I/112[%edx]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  x/179[%edx] := spilled-x/173[s2] (reload)
  I/115[%edx] := I/115[%edx] >>s 1
  R/7[%tos] := floatofint I/115[%edx]
  R/7[%tos] := R/7[%tos] -f R/7[%tos]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  float64u[A/104[%eax]] := R/7[%tos]
  r/119[%esi] := A/79[%ebx] + 36
  [r/119[%esi] + -4] := 3072
  [r/119[%esi]] := A/104[%eax]
  [r/119[%esi] + 4] := A/86[%ecx]
  [r/119[%esi] + 8] := A/79[%ebx]
  A/120[%ebx] := [r/119[%esi] + 4]
  A/121[%eax] := [r/119[%esi] + 4]
  R/7[%tos] := float64u[A/121[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/120[%ebx]]
  A/124[%ebx] := [r/119[%esi]]
  A/125[%eax] := [r/119[%esi]]
  R/7[%tos] := float64u[A/125[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/124[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  A/129[%ebx] := [r/119[%esi] + 8]
  A/130[%eax] := [r/119[%esi] + 8]
  R/7[%tos] := float64u[A/130[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[A/129[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {r/119[%esi]* spilled-d/171[s3] spilled-g/172[s0] spilled-x/173[s2]
   spilled-y/174[s1] spilled-bound/175[s0]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/134[s1] := R/7[%tos]
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] /f F/134[s1]
  s/137[s1] := R/7[%tos]
  {r/119[%esi]* s/137[s1] spilled-d/171[s3] spilled-g/172[s0]
   spilled-x/173[s2] spilled-y/174[s1] spilled-bound/175[s0]}
  A/138[%ebx] := alloc 52
  [A/138[%ebx] + -4] := 2301
  A/139[%eax] := [r/119[%esi] + 8]
  R/7[%tos] := s/137[s1] *f float64[A/139[%eax]]
  float64u[A/138[%ebx]] := R/7[%tos]
  A/141[%edx] := A/138[%ebx] + 12
  [A/141[%edx] + -4] := 2301
  A/142[%eax] := [r/119[%esi] + 4]
  R/7[%tos] := s/137[s1] *f float64[A/142[%eax]]
  float64u[A/141[%edx]] := R/7[%tos]
  A/144[%ecx] := A/138[%ebx] + 24
  [A/144[%ecx] + -4] := 2301
  A/145[%eax] := [r/119[%esi]]
  R/7[%tos] := s/137[s1] *f float64[A/145[%eax]]
  float64u[A/144[%ecx]] := R/7[%tos]
  A/147[%eax] := A/138[%ebx] + 36
  [A/147[%eax] + -4] := 3072
  [A/147[%eax]] := A/144[%ecx]
  [A/147[%eax] + 4] := A/141[%edx]
  [A/147[%eax] + 8] := A/138[%ebx]
  {spilled-d/171[s3] spilled-g/172[s0] spilled-x/173[s2] spilled-y/174[s1]
   spilled-bound/175[s0]}
  R/0[%eax] := call "camlCode__ray_trace_1088" R/0[%eax]
  R/7[%tos] := float64u[A/148[%eax]]
  F/150[s1] := R/7[%tos]
  R/7[%tos] := g/77[s0] +f F/150[s1]
  g/77[s0] := R/7[%tos]
  d/78[%edx] := spilled-d/171[s3] (reload)
  d/152[%eax] := d/78[%edx]
  I/153[%edx] := I/153[%edx] + 2
  spilled-d/171[s3] := d/78[%edx] (spill)
  if d/152[%eax] !=s 31 goto L198
  L197:
  R/7[%tos] := 255.
  R/7[%tos] := R/7[%tos] *f g/77[s0]
  I/156[%eax] := 16
  R/7[%tos] := floatofint I/156[%eax]
  R/7[%tos] := R/7[%tos] /f(rev) R/7[%tos]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  g/161[s0] := R/7[%tos]
  I/162[%eax] := intoffloat g/161[s0]
  I/163[%eax] := I/162[%eax]  * 2 + 1
  {spilled-x/173[s2] spilled-y/174[s1] spilled-bound/175[s0]}
  R/0[%eax] := call "camlPervasives__char_of_int_1120" R/0[%eax]
  {spilled-x/173[s2] spilled-y/174[s1] spilled-bound/175[s0]}
  call "camlPervasives__print_char_1266" R/0[%eax]
  x/182[%eax] := spilled-x/173[s2] (reload)
  x/165[%ebx] := x/182[%eax]
  I/166[%eax] := I/166[%eax] + 2
  spilled-x/173[s2] := x/182[%eax] (spill)
  bound/183[%eax] := spilled-bound/175[s0] (reload)
  if x/165[%ebx] !=s bound/183[%eax] goto L196
  L195:
  y/184[%eax] := spilled-y/174[s1] (reload)
  y/167[%ebx] := y/184[%eax]
  I/168[%eax] := I/168[%eax] - 2
  spilled-y/174[s1] := y/184[%eax] (spill)
  if y/167[%ebx] !=s 1 goto L194
  L193:
  A/169[%eax] := 1
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
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__aux_1094
	.data
	.long	2295
camlCode__3:
	.long	camlCode__ray_trace_1088
	.long	3
	.data
	.long	3319
camlCode__7:
	.long	caml_curry3
	.long	7
	.long	camlCode__create_1076
	.data
	.long	3319
camlCode__9:
	.long	caml_curry4
	.long	9
	.long	camlCode__intersect_1059
	.data
	.long	2295
camlCode__10:
	.long	camlCode__unitise_1057
	.long	3
	.data
	.long	3319
camlCode__11:
	.long	caml_curry2
	.long	5
	.long	camlCode__dot_1050
	.data
	.long	3319
camlCode__12:
	.long	caml_curry2
	.long	5
	.long	camlCode__$2d$7c_1043
	.data
	.long	3319
camlCode__13:
	.long	caml_curry2
	.long	5
	.long	camlCode__$2b$7c_1036
	.data
	.long	3319
camlCode__14:
	.long	caml_curry2
	.long	5
	.long	camlCode__$2a$7c_1031
	.data
	.long	4348
camlCode__1:
	.ascii	"P5\12%d %d\12\62\65\65\12%!"
	.byte	0
	.data
	.long	3072
camlCode__4:
	.long	.L100024
	.long	.L100025
	.long	.L100026
	.long	2301
.L100026:
	.long	0x0, 0x40100000
	.long	2301
.L100025:
	.long	0x0, 0xbff00000
	.long	2301
.L100024:
	.long	0x0, 0x0
	.data
	.long	2301
camlCode__5:
	.long	0x0, 0x3ff00000
	.data
	.long	2048
camlCode__6:
	.long	19
	.long	1025
	.data
	.long	3072
camlCode__8:
	.long	.L100021
	.long	.L100022
	.long	.L100023
	.long	2301
.L100023:
	.long	0x0, 0xc0000000
	.long	2301
.L100022:
	.long	0x0, 0x40080000
	.long	2301
.L100021:
	.long	0x0, 0x3ff00000
	.data
	.long	3072
camlCode__15:
	.long	.L100018
	.long	.L100019
	.long	.L100020
	.long	2301
.L100020:
	.long	0x0, 0x0
	.long	2301
.L100019:
	.long	0x0, 0x0
	.long	2301
.L100018:
	.long	0x0, 0x0
	.data
	.long	2301
camlCode__16:
	.long	0x0, 0x0
	.data
	.long	2301
camlCode__17:
	.long	0x0, 0x0
	.text
	.align	16
	.globl	camlCode__aux_1082
camlCode__aux_1082:
	subl	$12, %esp
.L100:
	movl	%eax, %edx
	movl	%ecx, 0(%esp)
.L101:	movl	caml_young_ptr, %eax
	subl	$80, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L102
	leal	4(%eax), %edi
	movl	$2301, -4(%edi)
	movl	24(%ecx), %eax
	fldl	.L104
	fmull	(%eax)
	fstpl	(%edi)
	leal	12(%edi), %eax
	movl	$3072, -4(%eax)
	movl	%edx, (%eax)
	movl	28(%ecx), %edx
	movl	%edx, 4(%eax)
	movl	%ebx, 8(%eax)
	movl	20(%ecx), %ebx
	leal	28(%edi), %ecx
	movl	$2301, -4(%ecx)
	movl	8(%eax), %esi
	movl	8(%ebx), %edx
	fldl	(%edx)
	faddl	(%esi)
	fstpl	(%ecx)
	leal	40(%edi), %esi
	movl	$2301, -4(%esi)
	movl	4(%eax), %ebp
	movl	4(%ebx), %edx
	fldl	(%edx)
	faddl	(%ebp)
	fstpl	(%esi)
	leal	52(%edi), %edx
	movl	$2301, -4(%edx)
	movl	(%eax), %ebp
	movl	(%ebx), %eax
	fldl	(%eax)
	faddl	(%ebp)
	fstpl	(%edx)
	leal	64(%edi), %ebx
	movl	$3072, -4(%ebx)
	movl	%edx, (%ebx)
	movl	%esi, 4(%ebx)
	movl	%ecx, 8(%ebx)
	movl	0(%esp), %eax
	movl	12(%eax), %edx
	movl	16(%eax), %eax
	addl	$-2, %eax
	movl	%edi, %ecx
	addl	$12, %esp
	jmp	camlCode__create_1076
.L102:	call	caml_call_gc
.L103:	jmp	.L101
	.data
.L104:	.long	0x0, 0x3fe00000
	.type	camlCode__aux_1082,@function
	.size	camlCode__aux_1082,.-camlCode__aux_1082
	.text
	.align	16
	.globl	camlCode__$2a$7c_1031
camlCode__$2a$7c_1031:
	subl	$8, %esp
.L105:
	movl	%eax, %esi
.L106:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L107
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
.L107:	call	caml_call_gc
.L108:	jmp	.L106
	.type	camlCode__$2a$7c_1031,@function
	.size	camlCode__$2a$7c_1031,.-camlCode__$2a$7c_1031
	.text
	.align	16
	.globl	camlCode__$2b$7c_1036
camlCode__$2b$7c_1036:
	subl	$8, %esp
.L109:
	movl	%eax, %edi
.L110:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L111
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
.L111:	call	caml_call_gc
.L112:	jmp	.L110
	.type	camlCode__$2b$7c_1036,@function
	.size	camlCode__$2b$7c_1036,.-camlCode__$2b$7c_1036
	.text
	.align	16
	.globl	camlCode__$2d$7c_1043
camlCode__$2d$7c_1043:
	subl	$8, %esp
.L113:
	movl	%eax, %edi
.L114:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L115
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
.L115:	call	caml_call_gc
.L116:	jmp	.L114
	.type	camlCode__$2d$7c_1043,@function
	.size	camlCode__$2d$7c_1043,.-camlCode__$2d$7c_1043
	.text
	.align	16
	.globl	camlCode__dot_1050
camlCode__dot_1050:
	subl	$8, %esp
.L117:
	movl	%eax, %ecx
.L118:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L119
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
.L119:	call	caml_call_gc
.L120:	jmp	.L118
	.type	camlCode__dot_1050,@function
	.size	camlCode__dot_1050,.-camlCode__dot_1050
	.text
	.align	16
	.globl	camlCode__unitise_1057
camlCode__unitise_1057:
	subl	$8, %esp
.L121:
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
.L122:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L123
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
.L123:	call	caml_call_gc
.L124:	jmp	.L122
	.type	camlCode__unitise_1057,@function
	.size	camlCode__unitise_1057,.-camlCode__unitise_1057
	.text
	.align	16
	.globl	camlCode__intersect_1059
camlCode__intersect_1059:
	subl	$48, %esp
.L129:
	movl	%eax, 0(%esp)
	movl	%ebx, 4(%esp)
	movl	%ecx, 16(%esp)
	movl	%esi, 12(%esp)
	movl	8(%edx), %eax
	movl	%eax, 20(%esp)
	movl	4(%edx), %eax
	movl	%eax, 8(%esp)
	movl	(%edx), %esi
.L130:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L131
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
.L133:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L134
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	fldl	32(%esp)
	fstpl	(%ecx)
	fldl	40(%esp)
	faddl	24(%esp)
	fstpl	24(%esp)
	leal	12(%ecx), %edx
	movl	$2301, -4(%edx)
	fldl	24(%esp)
	fstpl	(%edx)
	fldz
	fcompl	24(%esp)
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L128
	fldz
	fcompl	32(%esp)
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L127
	movl	%ecx, %edx
	jmp	.L127
	.align	16
.L128:
	movl	camlPervasives + 36, %edx
.L127:
	movl	16(%esp), %ecx
	movl	(%ecx), %eax
	fldl	(%eax)
	fldl	(%edx)
	fcompp
	fnstsw	%ax
	andb	$5, %ah
	jne	.L126
	movl	%ecx, %eax
	addl	$48, %esp
	ret
	.align	16
.L126:
	movl	20(%esp), %eax
	cmpl	$1, %eax
	je	.L125
	movl	%eax, 20(%esp)
	movl	%ecx, 16(%esp)
	movl	%ebp, %eax
	movl	12(%esp), %ecx
	call	caml_apply2
.L136:
	movl	16(%esp), %ebx
	movl	20(%esp), %ecx
	addl	$48, %esp
	jmp	camlList__fold_left_1078
	.align	16
.L125:
	movl	%edx, 4(%esp)
	movl	%esi, 0(%esp)
.L137:	movl	caml_young_ptr, %eax
	subl	$156, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L138
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
.L140:	movl	caml_young_ptr, %eax
	subl	$64, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L141
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
.L141:	call	caml_call_gc
.L142:	jmp	.L140
.L138:	call	caml_call_gc
.L139:	jmp	.L137
.L134:	call	caml_call_gc
.L135:	jmp	.L133
.L131:	call	caml_call_gc
.L132:	jmp	.L130
	.type	camlCode__intersect_1059,@function
	.size	camlCode__intersect_1059,.-camlCode__intersect_1059
	.text
	.align	16
	.globl	camlCode__create_1076
camlCode__create_1076:
	subl	$48, %esp
.L144:
	movl	%eax, %edi
	movl	%ecx, %esi
.L145:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L146
	leal	4(%eax), %eax
	movl	$3072, -4(%eax)
	movl	%ebx, (%eax)
	movl	%esi, 4(%eax)
	movl	$1, 8(%eax)
	cmpl	$3, %edi
	jne	.L143
	addl	$48, %esp
	ret
	.align	16
.L143:
	movl	%eax, 20(%esp)
	movl	%edx, 0(%esp)
	movl	%esi, 24(%esp)
	movl	%ebx, 28(%esp)
	fldl	.L148
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	32(%esp)
	fldl	.L149
	fmull	(%esi)
	fdivl	32(%esp)
	fstpl	32(%esp)
.L150:	movl	caml_young_ptr, %eax
	subl	$128, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L151
	leal	4(%eax), %ecx
	movl	%ecx, 8(%esp)
	movl	$2301, -4(%ecx)
	fldl	32(%esp)
	fstpl	(%ecx)
	leal	12(%ecx), %eax
	movl	%eax, 16(%esp)
	movl	$8439, -4(%eax)
	movl	$caml_curry2, (%eax)
	movl	$5, 4(%eax)
	movl	$camlCode__aux_1082, 8(%eax)
	movl	0(%esp), %edx
	movl	%edx, 12(%eax)
	movl	%edi, 16(%eax)
	movl	%ebx, 20(%eax)
	movl	%esi, 24(%eax)
	movl	%ecx, 28(%eax)
	leal	48(%ecx), %edx
	movl	%edx, 0(%esp)
	movl	$2301, -4(%edx)
	movl	24(%eax), %ebx
	fldl	.L153
	fmull	(%ebx)
	fstpl	(%edx)
	leal	60(%ecx), %ebx
	movl	$3072, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	28(%eax), %edx
	movl	%edx, 4(%ebx)
	movl	%ecx, 8(%ebx)
	movl	20(%eax), %esi
	leal	76(%ecx), %edi
	movl	$2301, -4(%edi)
	movl	8(%ebx), %edx
	movl	8(%esi), %eax
	fldl	(%eax)
	faddl	(%edx)
	fstpl	(%edi)
	leal	88(%ecx), %edx
	movl	$2301, -4(%edx)
	movl	4(%ebx), %ebp
	movl	4(%esi), %eax
	fldl	(%eax)
	faddl	(%ebp)
	fstpl	(%edx)
	leal	100(%ecx), %eax
	movl	$2301, -4(%eax)
	movl	(%ebx), %ebp
	movl	(%esi), %ebx
	fldl	(%ebx)
	faddl	(%ebp)
	fstpl	(%eax)
	leal	112(%ecx), %ebx
	movl	$3072, -4(%ebx)
	movl	%eax, (%ebx)
	movl	%edx, 4(%ebx)
	movl	%edi, 8(%ebx)
	movl	16(%esp), %eax
	movl	12(%eax), %edx
	movl	16(%eax), %eax
	addl	$-2, %eax
	movl	0(%esp), %ecx
	call	camlCode__create_1076
.L154:
	movl	%eax, %ebx
.L155:	movl	caml_young_ptr, %eax
	subl	$104, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L156
	leal	4(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$2048, -4(%eax)
	movl	%ebx, (%eax)
	movl	$1, 4(%eax)
	fldl	32(%esp)
	fchs
	fstpl	40(%esp)
	leal	12(%eax), %esi
	movl	$2301, -4(%esi)
	fldl	40(%esp)
	fstpl	(%esi)
	leal	24(%eax), %edx
	movl	%edx, 0(%esp)
	movl	$2301, -4(%edx)
	movl	16(%esp), %ecx
	movl	24(%ecx), %ebx
	fldl	.L158
	fmull	(%ebx)
	fstpl	(%edx)
	leal	36(%eax), %ebx
	movl	$3072, -4(%ebx)
	movl	%esi, (%ebx)
	movl	28(%ecx), %edx
	movl	%edx, 4(%ebx)
	movl	8(%esp), %edx
	movl	%edx, 8(%ebx)
	movl	20(%ecx), %esi
	leal	52(%eax), %edi
	movl	$2301, -4(%edi)
	movl	8(%ebx), %edx
	movl	8(%esi), %ecx
	fldl	(%ecx)
	faddl	(%edx)
	fstpl	(%edi)
	leal	64(%eax), %edx
	movl	$2301, -4(%edx)
	movl	4(%ebx), %ebp
	movl	4(%esi), %ecx
	fldl	(%ecx)
	faddl	(%ebp)
	fstpl	(%edx)
	leal	76(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	(%ebx), %ebp
	movl	(%esi), %ebx
	fldl	(%ebx)
	faddl	(%ebp)
	fstpl	(%ecx)
	leal	88(%eax), %ebx
	movl	$3072, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	%edx, 4(%ebx)
	movl	%edi, 8(%ebx)
	movl	16(%esp), %eax
	movl	12(%eax), %edx
	movl	16(%eax), %eax
	addl	$-2, %eax
	movl	0(%esp), %ecx
	call	camlCode__create_1076
.L159:
	movl	%eax, %ebx
.L160:	movl	caml_young_ptr, %eax
	subl	$104, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L161
	leal	4(%eax), %eax
	movl	%eax, 12(%esp)
	movl	$2048, -4(%eax)
	movl	%ebx, (%eax)
	movl	4(%esp), %ebx
	movl	%ebx, 4(%eax)
	fldl	32(%esp)
	fchs
	fstpl	40(%esp)
	leal	12(%eax), %edx
	movl	$2301, -4(%edx)
	fldl	40(%esp)
	fstpl	(%edx)
	leal	24(%eax), %esi
	movl	%esi, 0(%esp)
	movl	$2301, -4(%esi)
	movl	16(%esp), %ecx
	movl	24(%ecx), %ebx
	fldl	.L163
	fmull	(%ebx)
	fstpl	(%esi)
	leal	36(%eax), %ebx
	movl	$3072, -4(%ebx)
	movl	8(%esp), %esi
	movl	%esi, (%ebx)
	movl	28(%ecx), %esi
	movl	%esi, 4(%ebx)
	movl	%edx, 8(%ebx)
	movl	20(%ecx), %esi
	leal	52(%eax), %edi
	movl	$2301, -4(%edi)
	movl	8(%ebx), %edx
	movl	8(%esi), %ecx
	fldl	(%ecx)
	faddl	(%edx)
	fstpl	(%edi)
	leal	64(%eax), %edx
	movl	$2301, -4(%edx)
	movl	4(%ebx), %ebp
	movl	4(%esi), %ecx
	fldl	(%ecx)
	faddl	(%ebp)
	fstpl	(%edx)
	leal	76(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	(%ebx), %ebp
	movl	(%esi), %ebx
	fldl	(%ebx)
	faddl	(%ebp)
	fstpl	(%ecx)
	leal	88(%eax), %ebx
	movl	$3072, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	%edx, 4(%ebx)
	movl	%edi, 8(%ebx)
	movl	16(%esp), %eax
	movl	12(%eax), %edx
	movl	16(%eax), %eax
	addl	$-2, %eax
	movl	0(%esp), %ecx
	call	camlCode__create_1076
.L164:
	movl	%eax, %ebx
.L165:	movl	caml_young_ptr, %eax
	subl	$116, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L166
	leal	4(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$2048, -4(%eax)
	movl	%ebx, (%eax)
	movl	12(%esp), %ebx
	movl	%ebx, 4(%eax)
	fldl	32(%esp)
	fchs
	fstpl	40(%esp)
	leal	12(%eax), %edx
	movl	$2301, -4(%edx)
	fldl	40(%esp)
	fstpl	(%edx)
	fldl	32(%esp)
	fchs
	fstpl	32(%esp)
	leal	24(%eax), %edi
	movl	$2301, -4(%edi)
	fldl	32(%esp)
	fstpl	(%edi)
	leal	36(%eax), %esi
	movl	%esi, 0(%esp)
	movl	$2301, -4(%esi)
	movl	16(%esp), %ecx
	movl	24(%ecx), %ebx
	fldl	.L168
	fmull	(%ebx)
	fstpl	(%esi)
	leal	48(%eax), %ebx
	movl	$3072, -4(%ebx)
	movl	%edi, (%ebx)
	movl	28(%ecx), %esi
	movl	%esi, 4(%ebx)
	movl	%edx, 8(%ebx)
	movl	20(%ecx), %esi
	leal	64(%eax), %edi
	movl	$2301, -4(%edi)
	movl	8(%ebx), %edx
	movl	8(%esi), %ecx
	fldl	(%ecx)
	faddl	(%edx)
	fstpl	(%edi)
	leal	76(%eax), %edx
	movl	$2301, -4(%edx)
	movl	4(%ebx), %ebp
	movl	4(%esi), %ecx
	fldl	(%ecx)
	faddl	(%ebp)
	fstpl	(%edx)
	leal	88(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	(%ebx), %ebp
	movl	(%esi), %ebx
	fldl	(%ebx)
	faddl	(%ebp)
	fstpl	(%ecx)
	leal	100(%eax), %ebx
	movl	$3072, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	%edx, 4(%ebx)
	movl	%edi, 8(%ebx)
	movl	16(%esp), %eax
	movl	12(%eax), %edx
	movl	16(%eax), %eax
	addl	$-2, %eax
	movl	0(%esp), %ecx
	call	camlCode__create_1076
.L169:
	movl	%eax, %ecx
.L170:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L171
	leal	4(%eax), %ebx
	movl	$2048, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	4(%esp), %eax
	movl	%eax, 4(%ebx)
	leal	12(%ebx), %edx
	movl	$2048, -4(%edx)
	movl	20(%esp), %eax
	movl	%eax, (%edx)
	movl	%ebx, 4(%edx)
	leal	24(%ebx), %ecx
	movl	$2301, -4(%ecx)
	fldl	.L173
	movl	24(%esp), %eax
	fmull	(%eax)
	fstpl	(%ecx)
	leal	36(%ebx), %eax
	movl	$3072, -4(%eax)
	movl	28(%esp), %ebx
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	movl	%edx, 8(%eax)
	addl	$48, %esp
	ret
.L171:	call	caml_call_gc
.L172:	jmp	.L170
.L166:	call	caml_call_gc
.L167:	jmp	.L165
.L161:	call	caml_call_gc
.L162:	jmp	.L160
.L156:	call	caml_call_gc
.L157:	jmp	.L155
.L151:	call	caml_call_gc
.L152:	jmp	.L150
.L146:	call	caml_call_gc
.L147:	jmp	.L145
	.data
.L173:	.long	0x0, 0x40080000
	.data
.L168:	.long	0x0, 0x3fe00000
	.data
.L163:	.long	0x0, 0x3fe00000
	.data
.L158:	.long	0x0, 0x3fe00000
	.data
.L153:	.long	0x0, 0x3fe00000
	.data
.L149:	.long	0x0, 0x40080000
	.data
.L148:	.long	0x0, 0x40280000
	.type	camlCode__create_1076,@function
	.size	camlCode__create_1076,.-camlCode__create_1076
	.text
	.align	16
	.globl	camlCode__ray_trace_1088
camlCode__ray_trace_1088:
	subl	$16, %esp
.L176:
	movl	%eax, %ebx
	movl	%ebx, 0(%esp)
.L177:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L178
	leal	4(%eax), %ecx
	movl	$2048, -4(%ecx)
	movl	camlPervasives + 36, %eax
	movl	%eax, (%ecx)
	movl	camlCode, %eax
	movl	%eax, 4(%ecx)
	movl	camlCode + 24, %esi
	movl	camlCode + 48, %edx
	movl	camlCode, %eax
	call	camlCode__intersect_1059
.L180:
	movl	%eax, %edi
	movl	4(%edi), %esi
	movl	camlCode + 28, %ebx
.L181:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L182
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	4(%ebx), %edx
	movl	4(%esi), %eax
	fldl	(%eax)
	fmull	(%edx)
	movl	(%ebx), %edx
	movl	(%esi), %eax
	fldl	(%eax)
	fmull	(%edx)
	faddp	%st, %st(1)
	movl	8(%ebx), %ebx
	movl	8(%esi), %eax
	fldl	(%eax)
	fmull	(%ebx)
	faddp	%st, %st(1)
	fstpl	(%ecx)
	fldz
	fldl	(%ecx)
	fcompp
	fnstsw	%ax
	andb	$69, %ah
	decb	%ah
	cmpb	$64, %ah
	jae	.L175
	movl	$camlCode__17, %eax
	addl	$16, %esp
	ret
	.align	16
.L175:
	movl	%ecx, 4(%esp)
	movl	camlPervasives + 56, %eax
	pushl	4(%eax)
	pushl	(%eax)
	call	sqrt
	addl	$8, %esp
	fstpl	8(%esp)
.L184:	movl	caml_young_ptr, %eax
	subl	$168, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L185
	leal	4(%eax), %ebx
	movl	$2301, -4(%ebx)
	movl	8(%esi), %eax
	fldl	8(%esp)
	fmull	(%eax)
	fstpl	(%ebx)
	leal	12(%ebx), %eax
	movl	$2301, -4(%eax)
	movl	4(%esi), %ecx
	fldl	8(%esp)
	fmull	(%ecx)
	fstpl	(%eax)
	leal	24(%ebx), %edx
	movl	$2301, -4(%edx)
	movl	(%esi), %ecx
	fldl	8(%esp)
	fmull	(%ecx)
	fstpl	(%edx)
	leal	36(%ebx), %ebp
	movl	$3072, -4(%ebp)
	movl	%edx, (%ebp)
	movl	%eax, 4(%ebp)
	movl	%ebx, 8(%ebp)
	movl	(%edi), %esi
	leal	52(%ebx), %edi
	movl	$2301, -4(%edi)
	movl	0(%esp), %eax
	movl	8(%eax), %ecx
	fldl	(%esi)
	fmull	(%ecx)
	fstpl	(%edi)
	leal	64(%ebx), %edx
	movl	$2301, -4(%edx)
	movl	4(%eax), %ecx
	fldl	(%esi)
	fmull	(%ecx)
	fstpl	(%edx)
	leal	76(%ebx), %ecx
	movl	$2301, -4(%ecx)
	movl	(%eax), %eax
	fldl	(%esi)
	fmull	(%eax)
	fstpl	(%ecx)
	leal	88(%ebx), %eax
	movl	$3072, -4(%eax)
	movl	%ecx, (%eax)
	movl	%edx, 4(%eax)
	movl	%edi, 8(%eax)
	leal	104(%ebx), %esi
	movl	$2301, -4(%esi)
	movl	8(%ebp), %edx
	movl	8(%eax), %ecx
	fldl	(%ecx)
	faddl	(%edx)
	fstpl	(%esi)
	leal	116(%ebx), %edx
	movl	$2301, -4(%edx)
	movl	4(%ebp), %edi
	movl	4(%eax), %ecx
	fldl	(%ecx)
	faddl	(%edi)
	fstpl	(%edx)
	leal	128(%ebx), %ecx
	movl	$2301, -4(%ecx)
	movl	(%ebp), %edi
	movl	(%eax), %eax
	fldl	(%eax)
	faddl	(%edi)
	fstpl	(%ecx)
	leal	140(%ebx), %eax
	movl	$3072, -4(%eax)
	movl	%ecx, (%eax)
	movl	%edx, 4(%eax)
	movl	%esi, 8(%eax)
	leal	156(%ebx), %ecx
	movl	$2048, -4(%ecx)
	movl	camlPervasives + 36, %ebx
	movl	%ebx, (%ecx)
	movl	camlCode, %ebx
	movl	%ebx, 4(%ecx)
	movl	camlCode + 24, %esi
	movl	camlCode + 48, %edx
	movl	camlCode + 28, %ebx
	call	camlCode__intersect_1059
.L187:
	movl	(%eax), %eax
	fldl	(%eax)
	fstpl	8(%esp)
	movl	camlPervasives + 36, %eax
	fldl	(%eax)
	fcompl	8(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L174
	movl	$camlCode__16, %eax
	addl	$16, %esp
	ret
	.align	16
.L174:
	movl	4(%esp), %eax
	addl	$16, %esp
	ret
.L185:	call	caml_call_gc
.L186:	jmp	.L184
.L182:	call	caml_call_gc
.L183:	jmp	.L181
.L178:	call	caml_call_gc
.L179:	jmp	.L177
	.type	camlCode__ray_trace_1088,@function
	.size	camlCode__ray_trace_1088,.-camlCode__ray_trace_1088
	.text
	.align	16
	.globl	camlCode__aux_1094
camlCode__aux_1094:
	subl	$8, %esp
.L188:
	movl	%eax, %ecx
.L189:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L190
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
	fldl	.L192
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
.L190:	call	caml_call_gc
.L191:	jmp	.L189
	.data
.L192:	.long	0x0, 0x40000000
	.type	camlCode__aux_1094,@function
	.size	camlCode__aux_1094,.-camlCode__aux_1094
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$32, %esp
.L201:
	movl	$camlCode__15, %eax
	movl	%eax, camlCode
	movl	$camlCode__14, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__13, %eax
	movl	%eax, camlCode + 8
	movl	$camlCode__12, %eax
	movl	%eax, camlCode + 12
	movl	$camlCode__11, %eax
	movl	%eax, camlCode + 16
	movl	$camlCode__10, %eax
	movl	%eax, camlCode + 20
	movl	$camlCode__9, %eax
	movl	%eax, camlCode + 24
	movl	$camlCode__8, %ebx
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
	fstpl	16(%esp)
	fld1
	fdivl	16(%esp)
	fstpl	16(%esp)
	movl	$52, %eax
	call	caml_allocN
.L202:
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	movl	8(%ebx), %ecx
	fldl	16(%esp)
	fmull	(%ecx)
	fstpl	(%eax)
	leal	12(%eax), %edx
	movl	$2301, -4(%edx)
	movl	4(%ebx), %ecx
	fldl	16(%esp)
	fmull	(%ecx)
	fstpl	(%edx)
	leal	24(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	(%ebx), %ebx
	fldl	16(%esp)
	fmull	(%ebx)
	fstpl	(%ecx)
	leal	36(%eax), %ebx
	movl	$3072, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	%edx, 4(%ebx)
	movl	%eax, 8(%ebx)
	movl	%ebx, camlCode + 28
	movl	$9, camlCode + 32
	movl	$camlCode__7, %eax
	movl	%eax, camlCode + 36
	call	.L200
	movl	$camlCode__6, %ebx
	jmp	.L199
.L200:
	pushl	caml_exception_pointer
	movl	%esp, caml_exception_pointer
	movl	camlSys, %ebx
	movl	-4(%ebx), %eax
	shrl	$9, %eax
	cmpl	$5, %eax
	jbe	.L203
	movl	8(%ebx), %eax
	pushl	%eax
	movl	$caml_int_of_string, %eax
	call	caml_c_call
.L204:
	addl	$4, %esp
	movl	%eax, 8(%esp)
	movl	camlSys, %ebx
	movl	-4(%ebx), %eax
	shrl	$9, %eax
	cmpl	$3, %eax
	jbe	.L203
	movl	4(%ebx), %eax
	pushl	%eax
	movl	$caml_int_of_string, %eax
	call	caml_c_call
.L205:
	addl	$4, %esp
	movl	%eax, %ecx
	call	caml_alloc2
.L206:
	leal	4(%eax), %ebx
	movl	$2048, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	8(%esp), %eax
	movl	%eax, 4(%ebx)
	popl	caml_exception_pointer
	addl	$4, %esp
.L199:
	movl	(%ebx), %eax
	movl	%eax, camlCode + 40
	movl	4(%ebx), %eax
	movl	%eax, camlCode + 44
	movl	camlCode + 36, %edx
	movl	$camlCode__5, %ecx
	movl	$camlCode__4, %ebx
	movl	camlCode + 40, %eax
	call	camlCode__create_1076
.L207:
	movl	%eax, camlCode + 48
	movl	$camlCode__3, %eax
	movl	%eax, camlCode + 52
	movl	$camlCode__2, %eax
	movl	%eax, camlCode + 56
	movl	$camlCode__1, %eax
	call	camlPrintf__printf_1393
.L208:
	movl	%eax, %ecx
	movl	camlCode + 44, %ebx
	movl	camlCode + 44, %eax
	call	caml_apply2
.L209:
	movl	camlCode + 44, %eax
	addl	$-2, %eax
	cmpl	$1, %eax
	jl	.L193
	movl	%eax, 4(%esp)
.L194:
	movl	$1, %ebx
	movl	%ebx, 8(%esp)
	movl	camlCode + 44, %eax
	addl	$-2, %eax
	movl	%eax, 0(%esp)
	cmpl	%eax, %ebx
	jg	.L195
.L196:
	fldz
	fstpl	16(%esp)
	movl	$1, %edx
	movl	%edx, 12(%esp)
	cmpl	$31, %edx
	jg	.L197
.L198:
	movl	$52, %eax
	call	caml_allocN
.L210:
	leal	4(%eax), %ebx
	movl	$2301, -4(%ebx)
	movl	camlCode + 44, %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	(%ebx)
	movl	%edx, %eax
	sarl	$1, %eax
	testl	%eax, %eax
	jge	.L211
	addl	$3, %eax
.L211:	sarl	$2, %eax
	lea	1(%eax, %eax), %eax
	leal	12(%ebx), %ecx
	movl	$2301, -4(%ecx)
	movl	$4, %esi
	pushl	%esi
	fildl	(%esp)
	addl	$4, %esp
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	fldl	.L212
	movl	camlCode + 44, %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	movl	4(%esp), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fsubp	%st, %st(1)
	faddp	%st, %st(1)
	fstpl	(%ecx)
	sarl	$1, %edx
	movl	%edx, %eax
	testl	%eax, %eax
	jge	.L213
	addl	$3, %eax
.L213:	andl	$-4, %eax
	subl	%eax, %edx
	lea	1(%edx, %edx), %edx
	leal	24(%ebx), %eax
	movl	$2301, -4(%eax)
	movl	$4, %esi
	pushl	%esi
	fildl	(%esp)
	addl	$4, %esp
	sarl	$1, %edx
	pushl	%edx
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	fldl	.L214
	movl	camlCode + 44, %edx
	sarl	$1, %edx
	pushl	%edx
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	movl	8(%esp), %edx
	sarl	$1, %edx
	pushl	%edx
	fildl	(%esp)
	addl	$4, %esp
	fsubp	%st, %st(1)
	faddp	%st, %st(1)
	fstpl	(%eax)
	leal	36(%ebx), %esi
	movl	$3072, -4(%esi)
	movl	%eax, (%esi)
	movl	%ecx, 4(%esi)
	movl	%ebx, 8(%esi)
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
	fstpl	24(%esp)
	fld1
	fdivl	24(%esp)
	fstpl	24(%esp)
	movl	$52, %eax
	call	caml_allocN
.L215:
	leal	4(%eax), %ebx
	movl	$2301, -4(%ebx)
	movl	8(%esi), %eax
	fldl	24(%esp)
	fmull	(%eax)
	fstpl	(%ebx)
	leal	12(%ebx), %edx
	movl	$2301, -4(%edx)
	movl	4(%esi), %eax
	fldl	24(%esp)
	fmull	(%eax)
	fstpl	(%edx)
	leal	24(%ebx), %ecx
	movl	$2301, -4(%ecx)
	movl	(%esi), %eax
	fldl	24(%esp)
	fmull	(%eax)
	fstpl	(%ecx)
	leal	36(%ebx), %eax
	movl	$3072, -4(%eax)
	movl	%ecx, (%eax)
	movl	%edx, 4(%eax)
	movl	%ebx, 8(%eax)
	call	camlCode__ray_trace_1088
.L216:
	fldl	(%eax)
	fstpl	24(%esp)
	fldl	16(%esp)
	faddl	24(%esp)
	fstpl	16(%esp)
	movl	12(%esp), %edx
	movl	%edx, %eax
	addl	$2, %edx
	movl	%edx, 12(%esp)
	cmpl	$31, %eax
	jne	.L198
.L197:
	fldl	.L217
	fmull	16(%esp)
	movl	$16, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fdivrp	%st, %st(1)
	fldl	.L218
	faddp	%st, %st(1)
	fstpl	16(%esp)
	fldl	16(%esp)
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
	call	camlPervasives__char_of_int_1120
.L219:
	call	camlPervasives__print_char_1266
.L220:
	movl	8(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 8(%esp)
	movl	0(%esp), %eax
	cmpl	%eax, %ebx
	jne	.L196
.L195:
	movl	4(%esp), %eax
	movl	%eax, %ebx
	subl	$2, %eax
	movl	%eax, 4(%esp)
	cmpl	$1, %ebx
	jne	.L194
.L193:
	movl	$1, %eax
	addl	$32, %esp
	ret
.L203:	call	caml_ml_array_bound_error
	.data
.L218:	.long	0x0, 0x3fe00000
	.data
.L217:	.long	0x0, 0x406fe000
	.data
.L214:	.long	0x0, 0x40000000
	.data
.L212:	.long	0x0, 0x40000000
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
	.long	39
	.long	.L220
	.word	36
	.word	0
	.align	4
	.long	.L219
	.word	36
	.word	0
	.align	4
	.long	.L216
	.word	36
	.word	0
	.align	4
	.long	.L215
	.word	36
	.word	1
	.word	9
	.align	4
	.long	.L210
	.word	36
	.word	0
	.align	4
	.long	.L209
	.word	36
	.word	0
	.align	4
	.long	.L208
	.word	36
	.word	0
	.align	4
	.long	.L207
	.word	36
	.word	0
	.align	4
	.long	.L206
	.word	44
	.word	2
	.word	8
	.word	5
	.align	4
	.long	.L205
	.word	48
	.word	1
	.word	12
	.align	4
	.long	.L204
	.word	48
	.word	0
	.align	4
	.long	.L202
	.word	36
	.word	1
	.word	3
	.align	4
	.long	.L191
	.word	12
	.word	2
	.word	3
	.word	5
	.align	4
	.long	.L187
	.word	20
	.word	1
	.word	4
	.align	4
	.long	.L186
	.word	20
	.word	4
	.word	0
	.word	4
	.word	9
	.word	11
	.align	4
	.long	.L183
	.word	20
	.word	4
	.word	0
	.word	3
	.word	9
	.word	11
	.align	4
	.long	.L180
	.word	20
	.word	1
	.word	0
	.align	4
	.long	.L179
	.word	20
	.word	2
	.word	0
	.word	3
	.align	4
	.long	.L172
	.word	52
	.word	5
	.word	4
	.word	20
	.word	24
	.word	28
	.word	5
	.align	4
	.long	.L169
	.word	52
	.word	4
	.word	4
	.word	20
	.word	24
	.word	28
	.align	4
	.long	.L167
	.word	52
	.word	6
	.word	12
	.word	16
	.word	20
	.word	24
	.word	28
	.word	3
	.align	4
	.long	.L164
	.word	52
	.word	5
	.word	12
	.word	16
	.word	20
	.word	24
	.word	28
	.align	4
	.long	.L162
	.word	52
	.word	7
	.word	4
	.word	8
	.word	16
	.word	20
	.word	24
	.word	28
	.word	3
	.align	4
	.long	.L159
	.word	52
	.word	6
	.word	4
	.word	8
	.word	16
	.word	20
	.word	24
	.word	28
	.align	4
	.long	.L157
	.word	52
	.word	6
	.word	8
	.word	16
	.word	20
	.word	24
	.word	28
	.word	3
	.align	4
	.long	.L154
	.word	52
	.word	5
	.word	8
	.word	16
	.word	20
	.word	24
	.word	28
	.align	4
	.long	.L152
	.word	52
	.word	7
	.word	0
	.word	20
	.word	24
	.word	28
	.word	9
	.word	3
	.word	11
	.align	4
	.long	.L147
	.word	52
	.word	4
	.word	7
	.word	9
	.word	3
	.word	11
	.align	4
	.long	.L142
	.word	52
	.word	2
	.word	4
	.word	3
	.align	4
	.long	.L139
	.word	52
	.word	5
	.word	3
	.word	13
	.word	0
	.word	4
	.word	7
	.align	4
	.long	.L136
	.word	52
	.word	2
	.word	16
	.word	20
	.align	4
	.long	.L135
	.word	52
	.word	6
	.word	3
	.word	13
	.word	12
	.word	16
	.word	20
	.word	9
	.align	4
	.long	.L132
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
	.long	.L124
	.word	12
	.word	1
	.word	9
	.align	4
	.long	.L120
	.word	12
	.word	2
	.word	3
	.word	5
	.align	4
	.long	.L116
	.word	12
	.word	2
	.word	3
	.word	11
	.align	4
	.long	.L112
	.word	12
	.word	2
	.word	3
	.word	11
	.align	4
	.long	.L108
	.word	12
	.word	2
	.word	3
	.word	9
	.align	4
	.long	.L103
	.word	16
	.word	4
	.word	0
	.word	5
	.word	3
	.word	7
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

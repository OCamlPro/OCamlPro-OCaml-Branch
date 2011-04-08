
let delta = sqrt epsilon_float

type vec = {x:float; y:float; z:float}
let zero = {x=0.; y=0.; z=0.}
let ( *| ) s r = {x = s *. r.x; y = s *. r.y; z = s *. r.z}
let ( +| ) a b = {x = a.x +. b.x; y = a.y +. b.y; z = a.z +. b.z}
let ( -| ) a b = {x = a.x -. b.x; y = a.y -. b.y; z = a.z -. b.z}
let dot a b = a.x *. b.x +. a.y *. b.y +. a.z *. b.z
let length r = sqrt(dot r r)
let unitise r = 1. /. length r *| r

let ray_sphere orig dir center radius =
  let v = center -| orig in
  let b = dot v dir in
  let d2 = (b *. b -. dot v v +. radius *. radius) in
  if d2 < 0. then infinity else
  let d = sqrt d2 in
  let t1 = b -. d and t2 = b +. d in
  if t2>0. then if t1>0. then t1 else t2 else infinity

let rec intersect orig dir (l, _ as hit) (center, radius, scene) =
  match ray_sphere orig dir center radius, scene with
  | l', _ when l' >= l -> hit
  | l', [] -> l', unitise (orig +| l' *| dir -| center)
  | _, scenes -> intersects orig dir hit scenes

and intersects orig dir hit = function
  | [] -> hit
  | scene::scenes -> intersects orig dir (intersect orig dir hit scene) scenes

let light = unitise {x=1.; y=3.; z= -2.} and ss = 4

let rec ray_trace dir scene =
  let l, n = intersect zero dir (infinity, zero) scene in
  let g = dot n light in
  if g <= 0. then 0. else
    let p = l *| dir +| sqrt epsilon_float *| n in
    if fst (intersect p light (infinity, zero) scene) < infinity then 0. else g


(* Fabrice: some notes on this function: This function is called
recursively many times, and calls its subfunction [aux] at least 4
times. Currently, ocamlopt inlines [aux] each time, but still
allocates the closure. ocamlopt2 removes the closure allocation, but
increase the lifetime of parameters, increasing register pressure.

Also, everytime [aux] would be called, it computes [level-1] and [0.5
*. r] which should be computed only once. [3. *. sqrt 12.] is a
constant and should be computed only once too.

In general, there is here a lack of common sub-expression elimination.
*)

let rec create level c r =
  let obj = c, r, [] in
  if level = 1 then obj else
    let a = 3. *. r /. sqrt 12. in
    let aux x' z' = create (level - 1) (c +| {x=x'; y=a; z=z'}) (0.5 *. r) in
    c, 3. *. r, [obj; aux (-.a) (-.a); aux a (-.a); aux (-.a) a; aux a a]

let level, n =
  try int_of_string Sys.argv.(1), int_of_string Sys.argv.(2) with _ -> 6, 512

let scene = create level {x=0.; y= -1.; z=4.} 1.;;

let _ =
  Printf.printf "P5\n%d %d\n255\n" n n;
  for y = n - 1 downto 0 do
    for x = 0 to n - 1 do
      let g = ref 0. in
      for dx = 0 to ss - 1 do
        for dy = 0 to ss - 1 do
          let aux x d = float x -. float n /. 2. +. float d /. float ss in
          let dir = unitise {x=aux x dx; y=aux y dy; z=float n} in
          g := !g +. ray_trace dir scene
        done;
      done;
      let g = 0.5 +. 255. *. !g /. float (ss*ss) in
      Printf.printf "%c" (char_of_int (int_of_float g))
    done;
  done
  (*
-drawlambda
(seq
  (let (delta/1030 (caml_sqrt_float (field 14 (global Pervasives!))))
    (setfield_imm 0 (global Code!) delta/1030))
  (let (zero/1038 [|0. 0. 0.|]) (setfield_imm 1 (global Code!) zero/1038))
  (let
    (*|/1039
       (function s/1040 r/1041
         (makearray  (*. s/1040 (floatfield 0 r/1041))
           (*. s/1040 (floatfield 1 r/1041))
           (*. s/1040 (floatfield 2 r/1041)))))
    (setfield_imm 2 (global Code!) *|/1039))
  (let
    (+|/1042
       (function a/1043 b/1044
         (makearray  (+. (floatfield 0 a/1043) (floatfield 0 b/1044))
           (+. (floatfield 1 a/1043) (floatfield 1 b/1044))
           (+. (floatfield 2 a/1043) (floatfield 2 b/1044)))))
    (setfield_imm 3 (global Code!) +|/1042))
  (let
    (-|/1045
       (function a/1046 b/1047
         (makearray  (-. (floatfield 0 a/1046) (floatfield 0 b/1047))
           (-. (floatfield 1 a/1046) (floatfield 1 b/1047))
           (-. (floatfield 2 a/1046) (floatfield 2 b/1047)))))
    (setfield_imm 4 (global Code!) -|/1045))
  (let
    (dot/1048
       (function a/1049 b/1050
         (+.
           (+. (*. (floatfield 0 a/1049) (floatfield 0 b/1050))
             (*. (floatfield 1 a/1049) (floatfield 1 b/1050)))
           (*. (floatfield 2 a/1049) (floatfield 2 b/1050)))))
    (setfield_imm 5 (global Code!) dot/1048))
  (let
    (length/1051
       (function r/1052
         (caml_sqrt_float (apply (field 5 (global Code!)) r/1052 r/1052))))
    (setfield_imm 6 (global Code!) length/1051))
  (let
    (unitise/1053
       (function r/1054
         (apply (field 2 (global Code!))
           (/. 1. (apply (field 6 (global Code!)) r/1054)) r/1054)))
    (setfield_imm 7 (global Code!) unitise/1053))
  (let
    (ray_sphere/1055
       (function orig/1056 dir/1057 center/1058 radius/1059
         (let
           (v/1060 (apply (field 4 (global Code!)) center/1058 orig/1056)
            b/1061 (apply (field 5 (global Code!)) v/1060 dir/1057)
            d2/1062
              (+.
                (-. (*. b/1061 b/1061)
                  (apply (field 5 (global Code!)) v/1060 v/1060))
                (*. radius/1059 radius/1059)))
           (if (<. d2/1062 0.) (field 9 (global Pervasives!))
             (let
               (d/1063 (caml_sqrt_float d2/1062)
                t1/1064 (-. b/1061 d/1063)
                t2/1065 (+. b/1061 d/1063))
               (if (>. t2/1065 0.) (if (>. t1/1064 0.) t1/1064 t2/1065)
                 (field 9 (global Pervasives!))))))))
    (setfield_imm 8 (global Code!) ray_sphere/1055))
  (letrec
    (intersect/1066
       (function orig/1068 dir/1069 hit/1071 param/1140
         (let
           (scene/1074 (field 2 param/1140)
            radius/1073 (field 1 param/1140)
            center/1072 (field 0 param/1140)
            match/1144 (field 1 hit/1071)
            l/1070 (field 0 hit/1071)
            match/1141
              (apply (field 8 (global Code!)) orig/1068 dir/1069 center/1072
                radius/1073)
            match/1142 match/1141
            match/1143 scene/1074)
           (catch
             (catch
               (let (l'/1075 match/1142)
                 (if (>=. l'/1075 l/1070) hit/1071 (exit 18)))
              with (18)
               (if match/1143 (exit 17)
                 (let (l'/1076 match/1142)
                   (makeblock 0 l'/1076
                     (apply (field 7 (global Code!))
                       (apply (field 4 (global Code!))
                         (apply (field 3 (global Code!)) orig/1068
                           (apply (field 2 (global Code!)) l'/1076 dir/1069))
                         center/1072))))))
            with (17)
             (let (scenes/1077 match/1143)
               (apply intersects/1067 orig/1068 dir/1069 hit/1071
                 scenes/1077)))))
      intersects/1067
        (function orig/1078 dir/1079 hit/1080 param/1145
          (if param/1145
            (let
              (scenes/1082 (field 1 param/1145)
               scene/1081 (field 0 param/1145))
              (apply intersects/1067 orig/1078 dir/1079
                (apply intersect/1066 orig/1078 dir/1079 hit/1080 scene/1081)
                scenes/1082))
            hit/1080)))
    (seq (setfield_imm 9 (global Code!) intersect/1066)
      (setfield_imm 10 (global Code!) intersects/1067)))
  (let (light/1083 (apply (field 7 (global Code!)) [|1. 3. -2.|]) ss/1084 4)
    (seq (setfield_imm 11 (global Code!) light/1083)
      (setfield_imm 12 (global Code!) ss/1084)))
  (letrec
    (ray_trace/1085
       (function dir/1086 scene/1087
         (let
           (match/1147
              (apply (field 9 (global Code!)) (field 1 (global Code!))
                dir/1086
                (makeblock 0 (field 9 (global Pervasives!))
                  (field 1 (global Code!)))
                scene/1087)
            n/1089 (field 1 match/1147)
            l/1088 (field 0 match/1147)
            g/1090
              (apply (field 5 (global Code!)) n/1089
                (field 11 (global Code!))))
           (if (<=. g/1090 0.) 0.
             (let
               (p/1091
                  (apply (field 3 (global Code!))
                    (apply (field 2 (global Code!)) l/1088 dir/1086)
                    (apply (field 2 (global Code!))
                      (caml_sqrt_float (field 14 (global Pervasives!)))
                      n/1089)))
               (if
                 (<.
                   (field 0
                     (apply (field 9 (global Code!)) p/1091
                       (field 11 (global Code!))
                       (makeblock 0 (field 9 (global Pervasives!))
                         (field 1 (global Code!)))
                       scene/1087))
                   (field 9 (global Pervasives!)))
                 0. g/1090))))))
    (setfield_imm 13 (global Code!) ray_trace/1085))
  (letrec
    (create/1092
       (function level/1093 c/1094 r/1095
         (let (obj/1096 (makeblock 0 c/1094 r/1095 0a))
           (if (== level/1093 1) obj/1096
             (let
               (a/1097 (/. (*. 3. r/1095) (caml_sqrt_float 12.))
                aux/1098
                  (function x'/1099 z'/1100
                    (apply create/1092 (- level/1093 1)
                      (apply (field 3 (global Code!)) c/1094
                        (makearray  x'/1099 a/1097 z'/1100))
                      (*. 0.5 r/1095))))
               (makeblock 0 c/1094 (*. 3. r/1095)
                 (makeblock 0 obj/1096
                   (makeblock 0 (apply aux/1098 (~. a/1097) (~. a/1097))
                     (makeblock 0 (apply aux/1098 a/1097 (~. a/1097))
                       (makeblock 0 (apply aux/1098 (~. a/1097) a/1097)
                         (makeblock 0 (apply aux/1098 a/1097 a/1097) 0a)))))))))))
    (setfield_imm 14 (global Code!) create/1092))
  (let
    (match/1150
       (try
         (makeblock 0
           (caml_int_of_string (array.get (field 0 (global Sys!)) 1))
           (caml_int_of_string (array.get (field 0 (global Sys!)) 2)))
        with exn/1149 [0: 6 512])
     n/1102 (field 1 match/1150)
     level/1101 (field 0 match/1150))
    (seq (setfield_imm 15 (global Code!) level/1101)
      (setfield_imm 16 (global Code!) n/1102)))
  (let
    (scene/1103
       (apply (field 14 (global Code!)) (field 15 (global Code!))
         [|0. -1. 4.|] 1.))
    (setfield_imm 17 (global Code!) scene/1103))
  (apply (field 1 (global Printf!)) "P5\n%d %d\n255\n"
    (field 16 (global Code!)) (field 16 (global Code!)))
  (for y/1104 (- (field 16 (global Code!)) 1) downto 0
    (for x/1105 0 to (- (field 16 (global Code!)) 1)
      (let (g/1106 (makemutable 0 0.))
        (seq
          (for dx/1107 0 to (- (field 12 (global Code!)) 1)
            (for dy/1108 0 to (- (field 12 (global Code!)) 1)
              (let
                (aux/1109
                   (function x/1110 d/1111
                     (+.
                       (-. (float_of_int x/1110)
                         (/. (float_of_int (field 16 (global Code!))) 2.))
                       (/. (float_of_int d/1111)
                         (float_of_int (field 12 (global Code!))))))
                 dir/1112
                   (apply (field 7 (global Code!))
                     (makearray  (apply aux/1109 x/1105 dx/1107)
                       (apply aux/1109 y/1104 dy/1108)
                       (float_of_int (field 16 (global Code!))))))
                (setfield_ptr 0 g/1106
                  (+. (field 0 g/1106)
                    (apply (field 13 (global Code!)) dir/1112
                      (field 17 (global Code!))))))))
          (let
            (g/1113
               (+. 0.5
                 (/. (*. 255. (field 0 g/1106))
                   (float_of_int
                     (* (field 12 (global Code!)) (field 12 (global Code!)))))))
            (apply (field 1 (global Printf!)) "%c"
              (apply (field 16 (global Pervasives!)) (int_of_float g/1113))))))))
  0a)
-dlambda
(seq
  (let (delta/1030 (caml_sqrt_float (field 14 (global Pervasives!))))
    (setfield_imm 0 (global Code!) delta/1030))
  (let (zero/1038 [|0. 0. 0.|]) (setfield_imm 1 (global Code!) zero/1038))
  (let
    (*|/1039
       (function s/1040 r/1041
         (makearray  (*. s/1040 (floatfield 0 r/1041))
           (*. s/1040 (floatfield 1 r/1041))
           (*. s/1040 (floatfield 2 r/1041)))))
    (setfield_imm 2 (global Code!) *|/1039))
  (let
    (+|/1042
       (function a/1043 b/1044
         (makearray  (+. (floatfield 0 a/1043) (floatfield 0 b/1044))
           (+. (floatfield 1 a/1043) (floatfield 1 b/1044))
           (+. (floatfield 2 a/1043) (floatfield 2 b/1044)))))
    (setfield_imm 3 (global Code!) +|/1042))
  (let
    (-|/1045
       (function a/1046 b/1047
         (makearray  (-. (floatfield 0 a/1046) (floatfield 0 b/1047))
           (-. (floatfield 1 a/1046) (floatfield 1 b/1047))
           (-. (floatfield 2 a/1046) (floatfield 2 b/1047)))))
    (setfield_imm 4 (global Code!) -|/1045))
  (let
    (dot/1048
       (function a/1049 b/1050
         (+.
           (+. (*. (floatfield 0 a/1049) (floatfield 0 b/1050))
             (*. (floatfield 1 a/1049) (floatfield 1 b/1050)))
           (*. (floatfield 2 a/1049) (floatfield 2 b/1050)))))
    (setfield_imm 5 (global Code!) dot/1048))
  (let
    (length/1051
       (function r/1052
         (caml_sqrt_float (apply (field 5 (global Code!)) r/1052 r/1052))))
    (setfield_imm 6 (global Code!) length/1051))
  (let
    (unitise/1053
       (function r/1054
         (apply (field 2 (global Code!))
           (/. 1. (apply (field 6 (global Code!)) r/1054)) r/1054)))
    (setfield_imm 7 (global Code!) unitise/1053))
  (let
    (ray_sphere/1055
       (function orig/1056 dir/1057 center/1058 radius/1059
         (let
           (v/1060 (apply (field 4 (global Code!)) center/1058 orig/1056)
            b/1061 (apply (field 5 (global Code!)) v/1060 dir/1057)
            d2/1062
              (+.
                (-. (*. b/1061 b/1061)
                  (apply (field 5 (global Code!)) v/1060 v/1060))
                (*. radius/1059 radius/1059)))
           (if (<. d2/1062 0.) (field 9 (global Pervasives!))
             (let
               (d/1063 (caml_sqrt_float d2/1062)
                t1/1064 (-. b/1061 d/1063)
                t2/1065 (+. b/1061 d/1063))
               (if (>. t2/1065 0.) (if (>. t1/1064 0.) t1/1064 t2/1065)
                 (field 9 (global Pervasives!))))))))
    (setfield_imm 8 (global Code!) ray_sphere/1055))
  (letrec
    (intersect/1066
       (function orig/1068 dir/1069 hit/1071 param/1140
         (let
           (scene/1074 (field 2 param/1140)
            center/1072 (field 0 param/1140)
            match/1141
              (apply (field 8 (global Code!)) orig/1068 dir/1069 center/1072
                (field 1 param/1140)))
           (if (>=. match/1141 (field 0 hit/1071)) hit/1071
             (if scene/1074
               (apply intersects/1067 orig/1068 dir/1069 hit/1071 scene/1074)
               (makeblock 0 match/1141
                 (apply (field 7 (global Code!))
                   (apply (field 4 (global Code!))
                     (apply (field 3 (global Code!)) orig/1068
                       (apply (field 2 (global Code!)) match/1141 dir/1069))
                     center/1072)))))))
      intersects/1067
        (function orig/1078 dir/1079 hit/1080 param/1145
          (if param/1145
            (apply intersects/1067 orig/1078 dir/1079
              (apply intersect/1066 orig/1078 dir/1079 hit/1080
                (field 0 param/1145))
              (field 1 param/1145))
            hit/1080)))
    (seq (setfield_imm 9 (global Code!) intersect/1066)
      (setfield_imm 10 (global Code!) intersects/1067)))
  (let (light/1083 (apply (field 7 (global Code!)) [|1. 3. -2.|]) ss/1084 4)
    (seq (setfield_imm 11 (global Code!) light/1083)
      (setfield_imm 12 (global Code!) ss/1084)))
  (letrec
    (ray_trace/1085
       (function dir/1086 scene/1087
         (let
           (match/1147
              (apply (field 9 (global Code!)) (field 1 (global Code!))
                dir/1086
                (makeblock 0 (field 9 (global Pervasives!))
                  (field 1 (global Code!)))
                scene/1087)
            n/1089 (field 1 match/1147)
            g/1090
              (apply (field 5 (global Code!)) n/1089
                (field 11 (global Code!))))
           (if (<=. g/1090 0.) 0.
             (let
               (p/1091
                  (apply (field 3 (global Code!))
                    (apply (field 2 (global Code!)) (field 0 match/1147)
                      dir/1086)
                    (apply (field 2 (global Code!))
                      (caml_sqrt_float (field 14 (global Pervasives!)))
                      n/1089)))
               (if
                 (<.
                   (field 0
                     (apply (field 9 (global Code!)) p/1091
                       (field 11 (global Code!))
                       (makeblock 0 (field 9 (global Pervasives!))
                         (field 1 (global Code!)))
                       scene/1087))
                   (field 9 (global Pervasives!)))
                 0. g/1090))))))
    (setfield_imm 13 (global Code!) ray_trace/1085))
  (letrec
    (create/1092
       (function level/1093 c/1094 r/1095
         (let (obj/1096 (makeblock 0 c/1094 r/1095 0a))
           (if (== level/1093 1) obj/1096
             (let
               (a/1097 (/. (*. 3. r/1095) (caml_sqrt_float 12.))
                aux/1098
                  (function x'/1099 z'/1100
                    (apply create/1092 (- level/1093 1)
                      (apply (field 3 (global Code!)) c/1094
                        (makearray  x'/1099 a/1097 z'/1100))
                      (*. 0.5 r/1095))))
               (makeblock 0 c/1094 (*. 3. r/1095)
                 (makeblock 0 obj/1096
                   (makeblock 0 (apply aux/1098 (~. a/1097) (~. a/1097))
                     (makeblock 0 (apply aux/1098 a/1097 (~. a/1097))
                       (makeblock 0 (apply aux/1098 (~. a/1097) a/1097)
                         (makeblock 0 (apply aux/1098 a/1097 a/1097) 0a)))))))))))
    (setfield_imm 14 (global Code!) create/1092))
  (let
    (match/1150
       (try
         (makeblock 0
           (caml_int_of_string (array.get (field 0 (global Sys!)) 1))
           (caml_int_of_string (array.get (field 0 (global Sys!)) 2)))
        with exn/1149 [0: 6 512]))
    (seq (setfield_imm 15 (global Code!) (field 0 match/1150))
      (setfield_imm 16 (global Code!) (field 1 match/1150))))
  (let
    (scene/1103
       (apply (field 14 (global Code!)) (field 15 (global Code!))
         [|0. -1. 4.|] 1.))
    (setfield_imm 17 (global Code!) scene/1103))
  (apply (field 1 (global Printf!)) "P5\n%d %d\n255\n"
    (field 16 (global Code!)) (field 16 (global Code!)))
  (for y/1104 (- (field 16 (global Code!)) 1) downto 0
    (for x/1105 0 to (- (field 16 (global Code!)) 1)
      (let (g/1106 0.)
        (seq
          (for dx/1107 0 to (- (field 12 (global Code!)) 1)
            (for dy/1108 0 to (- (field 12 (global Code!)) 1)
              (let
                (aux/1109
                   (function x/1110 d/1111
                     (+.
                       (-. (float_of_int x/1110)
                         (/. (float_of_int (field 16 (global Code!))) 2.))
                       (/. (float_of_int d/1111)
                         (float_of_int (field 12 (global Code!))))))
                 dir/1112
                   (apply (field 7 (global Code!))
                     (makearray  (apply aux/1109 x/1105 dx/1107)
                       (apply aux/1109 y/1104 dy/1108)
                       (float_of_int (field 16 (global Code!))))))
                (assign g/1106
                  (+. g/1106
                    (apply (field 13 (global Code!)) dir/1112
                      (field 17 (global Code!))))))))
          (let
            (g/1113
               (+. 0.5
                 (/. (*. 255. g/1106)
                   (float_of_int
                     (* (field 12 (global Code!)) (field 12 (global Code!)))))))
            (apply (field 1 (global Printf!)) "%c"
              (apply (field 16 (global Pervasives!)) (int_of_float g/1113))))))))
  0a)

-dcmm
(data int 18432 global "camlCode" "camlCode": skip 72)
(data
 int 3319
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__aux_1109")
(data
 int 3319
 "camlCode__7":
 addr "caml_curry3"
 int 7
 addr "camlCode__create_1092")
(data
 int 3319
 "camlCode__8":
 addr "caml_curry2"
 int 5
 addr "camlCode__ray_trace_1085")
(data
 int 7415
 "camlCode__10":
 addr "caml_curry4"
 int 9
 addr "camlCode__intersect_1066"
 int 4345
 addr "caml_curry4"
 int 9
 addr "camlCode__intersects_1067")
(data
 int 3319
 "camlCode__11":
 addr "caml_curry4"
 int 9
 addr "camlCode__ray_sphere_1055")
(data int 2295 "camlCode__12": addr "camlCode__unitise_1053" int 3)
(data int 2295 "camlCode__13": addr "camlCode__length_1051" int 3)
(data
 int 3319
 "camlCode__14":
 addr "caml_curry2"
 int 5
 addr "camlCode__dot_1048")
(data
 int 3319
 "camlCode__15":
 addr "caml_curry2"
 int 5
 addr "camlCode__-|_1045")
(data
 int 3319
 "camlCode__16":
 addr "caml_curry2"
 int 5
 addr "camlCode__+|_1042")
(data
 int 3319
 "camlCode__17":
 addr "caml_curry2"
 int 5
 addr "camlCode__*|_1039")
(data int 1276 "camlCode__1": string "%c" skip 1 byte 1)
(data int 4348 "camlCode__3": string "P5
%d %d
255
" skip 2 byte 2)
(data int 6398 "camlCode__4": double 0. double -1. double 4.)
(data int 2301 "camlCode__5": double 1.)
(data int 2048 "camlCode__6": int 13 int 1025)
(data int 6398 "camlCode__9": double 1. double 3. double -2.)
(data int 6398 "camlCode__18": double 0. double 0. double 0.)
(data int 2301 "camlCode__19": double 0.)
(data int 2301 "camlCode__20": double 0.)
(function camlCode__aux_1098 (x'/1099: addr z'/1100: addr env/1207: addr)
 (app "camlCode__create_1092" (+ (load (+a env/1207 16)) -2)
   (let
     (b/1208
        (alloc 6398 (load float64u x'/1099)
          (load float64u (load (+a env/1207 28))) (load float64u z'/1100))
      a/1209 (load (+a env/1207 20)))
     (alloc 6398 (+f (load float64u a/1209) (load float64u b/1208))
       (+f (load float64u (+a a/1209 8)) (load float64u (+a b/1208 8)))
       (+f (load float64u (+a a/1209 16)) (load float64u (+a b/1208 16)))))
   (alloc 2301 (*f 0.5 (load float64u (load (+a env/1207 24)))))
   (load (+a env/1207 12)) addr))

(function camlCode__*|_1039 (s/1040: addr r/1041: addr)
 (alloc 6398 (*f (load float64u s/1040) (load float64u r/1041))
   (*f (load float64u s/1040) (load float64u (+a r/1041 8)))
   (*f (load float64u s/1040) (load float64u (+a r/1041 16)))))

(function camlCode__+|_1042 (a/1043: addr b/1044: addr)
 (alloc 6398 (+f (load float64u a/1043) (load float64u b/1044))
   (+f (load float64u (+a a/1043 8)) (load float64u (+a b/1044 8)))
   (+f (load float64u (+a a/1043 16)) (load float64u (+a b/1044 16)))))

(function camlCode__-|_1045 (a/1046: addr b/1047: addr)
 (alloc 6398 (-f (load float64u a/1046) (load float64u b/1047))
   (-f (load float64u (+a a/1046 8)) (load float64u (+a b/1047 8)))
   (-f (load float64u (+a a/1046 16)) (load float64u (+a b/1047 16)))))

(function camlCode__dot_1048 (a/1049: addr b/1050: addr)
 (alloc 2301
   (+f
     (+f (*f (load float64u a/1049) (load float64u b/1050))
       (*f (load float64u (+a a/1049 8)) (load float64u (+a b/1050 8))))
     (*f (load float64u (+a a/1049 16)) (load float64u (+a b/1050 16))))))

(function camlCode__length_1051 (r/1052: addr)
 (alloc 2301
   (extcall "sqrt"
     (+f
       (+f (*f (load float64u r/1052) (load float64u r/1052))
         (*f (load float64u (+a r/1052 8)) (load float64u (+a r/1052 8))))
       (*f (load float64u (+a r/1052 16)) (load float64u (+a r/1052 16))))
     float)))

(function camlCode__unitise_1053 (r/1054: addr)
 (let
   s/1256
     (/f 1.
       (extcall "sqrt"
         (+f
           (+f (*f (load float64u r/1054) (load float64u r/1054))
             (*f (load float64u (+a r/1054 8)) (load float64u (+a r/1054 8))))
           (*f (load float64u (+a r/1054 16)) (load float64u (+a r/1054 16))))
         float))
   (alloc 6398 (*f s/1256 (load float64u r/1054))
     (*f s/1256 (load float64u (+a r/1054 8)))
     (*f s/1256 (load float64u (+a r/1054 16))))))

(function camlCode__ray_sphere_1055
     (orig/1056: addr dir/1057: addr center/1058: addr radius/1059: addr)
 (let
   (v/1060
      (alloc 6398 (-f (load float64u center/1058) (load float64u orig/1056))
        (-f (load float64u (+a center/1058 8))
          (load float64u (+a orig/1056 8)))
        (-f (load float64u (+a center/1058 16))
          (load float64u (+a orig/1056 16))))
    b/1251
      (+f
        (+f (*f (load float64u v/1060) (load float64u dir/1057))
          (*f (load float64u (+a v/1060 8)) (load float64u (+a dir/1057 8))))
        (*f (load float64u (+a v/1060 16)) (load float64u (+a dir/1057 16))))
    d2/1252
      (+f
        (-f (*f b/1251 b/1251)
          (+f
            (+f (*f (load float64u v/1060) (load float64u v/1060))
              (*f (load float64u (+a v/1060 8))
                (load float64u (+a v/1060 8))))
            (*f (load float64u (+a v/1060 16))
              (load float64u (+a v/1060 16)))))
        (*f (load float64u radius/1059) (load float64u radius/1059))))
   (if (<f d2/1252 0.) (load (+a "camlPervasives" 36))
     (let
       (d/1253 (extcall "sqrt" d2/1252 float) t1/1254 (-f b/1251 d/1253)
        t1/1064 (alloc 2301 t1/1254) t2/1255 (+f b/1251 d/1253)
        t2/1065 (alloc 2301 t2/1255))
       (if (>f t2/1255 0.) (if (>f t1/1254 0.) t1/1064 t2/1065)
         (load (+a "camlPervasives" 36)))))))

(function camlCode__intersects_1067
     (orig/1078: addr dir/1079: addr hit/1080: addr param/1145: addr)
 (if (!= param/1145 1)
   (app "camlCode__intersects_1067" orig/1078 dir/1079
     (app "camlCode__intersect_1066" orig/1078 dir/1079 hit/1080
       (load param/1145) addr)
     (load (+a param/1145 4)) addr)
   hit/1080))

(function camlCode__intersect_1066
     (orig/1068: addr dir/1069: addr hit/1071: addr param/1140: addr)
 (let
   (scene/1074 (load (+a param/1140 8)) center/1072 (load param/1140)
    match/1141
      (let
        (radius/1162 (load (+a param/1140 4))
         v/1163
           (alloc 6398
             (-f (load float64u center/1072) (load float64u orig/1068))
             (-f (load float64u (+a center/1072 8))
               (load float64u (+a orig/1068 8)))
             (-f (load float64u (+a center/1072 16))
               (load float64u (+a orig/1068 16))))
         b/1246
           (+f
             (+f (*f (load float64u v/1163) (load float64u dir/1069))
               (*f (load float64u (+a v/1163 8))
                 (load float64u (+a dir/1069 8))))
             (*f (load float64u (+a v/1163 16))
               (load float64u (+a dir/1069 16))))
         d2/1247
           (+f
             (-f (*f b/1246 b/1246)
               (+f
                 (+f (*f (load float64u v/1163) (load float64u v/1163))
                   (*f (load float64u (+a v/1163 8))
                     (load float64u (+a v/1163 8))))
                 (*f (load float64u (+a v/1163 16))
                   (load float64u (+a v/1163 16)))))
             (*f (load float64u radius/1162) (load float64u radius/1162))))
        (if (<f d2/1247 0.) (load (+a "camlPervasives" 36))
          (let
            (d/1248 (extcall "sqrt" d2/1247 float) t1/1249 (-f b/1246 d/1248)
             t1/1167 (alloc 2301 t1/1249) t2/1250 (+f b/1246 d/1248)
             t2/1168 (alloc 2301 t2/1250))
            (if (>f t2/1250 0.) (if (>f t1/1249 0.) t1/1167 t2/1168)
              (load (+a "camlPervasives" 36)))))))
   (if (>=f (load float64u match/1141) (load float64u (load hit/1071)))
     hit/1071
     (if (!= scene/1074 1)
       (app "camlCode__intersects_1067" orig/1068 dir/1069 hit/1071
         scene/1074 addr)
       (alloc 2048 match/1141
         (let
           (r/1171
              (let
                a/1170
                  (let
                    b/1169
                      (alloc 6398
                        (*f (load float64u match/1141)
                          (load float64u dir/1069))
                        (*f (load float64u match/1141)
                          (load float64u (+a dir/1069 8)))
                        (*f (load float64u match/1141)
                          (load float64u (+a dir/1069 16))))
                    (alloc 6398
                      (+f (load float64u orig/1068) (load float64u b/1169))
                      (+f (load float64u (+a orig/1068 8))
                        (load float64u (+a b/1169 8)))
                      (+f (load float64u (+a orig/1068 16))
                        (load float64u (+a b/1169 16)))))
                (alloc 6398
                  (-f (load float64u a/1170) (load float64u center/1072))
                  (-f (load float64u (+a a/1170 8))
                    (load float64u (+a center/1072 8)))
                  (-f (load float64u (+a a/1170 16))
                    (load float64u (+a center/1072 16)))))
            s/1245
              (/f 1.
                (extcall "sqrt"
                  (+f
                    (+f (*f (load float64u r/1171) (load float64u r/1171))
                      (*f (load float64u (+a r/1171 8))
                        (load float64u (+a r/1171 8))))
                    (*f (load float64u (+a r/1171 16))
                      (load float64u (+a r/1171 16))))
                  float)))
           (alloc 6398 (*f s/1245 (load float64u r/1171))
             (*f s/1245 (load float64u (+a r/1171 8)))
             (*f s/1245 (load float64u (+a r/1171 16))))))))))

(function camlCode__ray_trace_1085 (dir/1086: addr scene/1087: addr)
 (let
   (match/1147
      (app "camlCode__intersect_1066" (load (+a "camlCode" 4)) dir/1086
        (alloc 2048 (load (+a "camlPervasives" 36)) (load (+a "camlCode" 4)))
        scene/1087 addr)
    n/1089 (load (+a match/1147 4))
    g/1090
      (let b/1178 (load (+a "camlCode" 44))
        (alloc 2301
          (+f
            (+f (*f (load float64u n/1089) (load float64u b/1178))
              (*f (load float64u (+a n/1089 8))
                (load float64u (+a b/1178 8))))
            (*f (load float64u (+a n/1089 16))
              (load float64u (+a b/1178 16)))))))
   (if (<=f (load float64u g/1090) 0.) "camlCode__20"
     (let
       p/1091
         (let
           (b/1181
              (let
                s/1244
                  (extcall "sqrt"
                    (load float64u (load (+a "camlPervasives" 56))) float)
                (alloc 6398 (*f s/1244 (load float64u n/1089))
                  (*f s/1244 (load float64u (+a n/1089 8)))
                  (*f s/1244 (load float64u (+a n/1089 16)))))
            a/1182
              (let s/1179 (load match/1147)
                (alloc 6398
                  (*f (load float64u s/1179) (load float64u dir/1086))
                  (*f (load float64u s/1179) (load float64u (+a dir/1086 8)))
                  (*f (load float64u s/1179)
                    (load float64u (+a dir/1086 16))))))
           (alloc 6398 (+f (load float64u a/1182) (load float64u b/1181))
             (+f (load float64u (+a a/1182 8)) (load float64u (+a b/1181 8)))
             (+f (load float64u (+a a/1182 16))
               (load float64u (+a b/1181 16)))))
       (if
         (<f
           (load float64u
             (load
               (app "camlCode__intersect_1066" p/1091
                 (load (+a "camlCode" 44))
                 (alloc 2048 (load (+a "camlPervasives" 36))
                   (load (+a "camlCode" 4)))
                 scene/1087 addr)))
           (load float64u (load (+a "camlPervasives" 36))))
         "camlCode__19" g/1090)))))

(function camlCode__create_1092
     (level/1093: addr c/1094: addr r/1095: addr env/1203: addr)
 (let obj/1096 (alloc 3072 c/1094 r/1095 1a)
   (if (== level/1093 3) obj/1096
     (let
       (a/1239 (/f (*f 3. (load float64u r/1095)) (extcall "sqrt" 12. float))
        a/1097 (alloc 2301 a/1239)
        aux/1098
          (alloc 8439 "caml_curry2" 5 "camlCode__aux_1098" env/1203
            level/1093 c/1094 r/1095 a/1097))
       (alloc 3072 c/1094 (alloc 2301 (*f 3. (load float64u r/1095)))
         (alloc 2048 obj/1096
           (alloc 2048
             (let (z'/1240 (~f a/1239) x'/1241 (~f a/1239))
               (app "camlCode__create_1092" (+ (load (+a aux/1098 16)) -2)
                 (let
                   (b/1212
                      (alloc 6398 x'/1241
                        (load float64u (load (+a aux/1098 28))) z'/1240)
                    a/1213 (load (+a aux/1098 20)))
                   (alloc 6398
                     (+f (load float64u a/1213) (load float64u b/1212))
                     (+f (load float64u (+a a/1213 8))
                       (load float64u (+a b/1212 8)))
                     (+f (load float64u (+a a/1213 16))
                       (load float64u (+a b/1212 16)))))
                 (alloc 2301
                   (*f 0.5 (load float64u (load (+a aux/1098 24)))))
                 (load (+a aux/1098 12)) addr))
             (alloc 2048
               (let z'/1242 (~f a/1239)
                 (app "camlCode__create_1092" (+ (load (+a aux/1098 16)) -2)
                   (let
                     (b/1215
                        (alloc 6398 a/1239
                          (load float64u (load (+a aux/1098 28))) z'/1242)
                      a/1216 (load (+a aux/1098 20)))
                     (alloc 6398
                       (+f (load float64u a/1216) (load float64u b/1215))
                       (+f (load float64u (+a a/1216 8))
                         (load float64u (+a b/1215 8)))
                       (+f (load float64u (+a a/1216 16))
                         (load float64u (+a b/1215 16)))))
                   (alloc 2301
                     (*f 0.5 (load float64u (load (+a aux/1098 24)))))
                   (load (+a aux/1098 12)) addr))
               (alloc 2048
                 (let x'/1243 (~f a/1239)
                   (app "camlCode__create_1092"
                     (+ (load (+a aux/1098 16)) -2)
                     (let
                       (b/1218
                          (alloc 6398 x'/1243
                            (load float64u (load (+a aux/1098 28))) a/1239)
                        a/1219 (load (+a aux/1098 20)))
                       (alloc 6398
                         (+f (load float64u a/1219) (load float64u b/1218))
                         (+f (load float64u (+a a/1219 8))
                           (load float64u (+a b/1218 8)))
                         (+f (load float64u (+a a/1219 16))
                           (load float64u (+a b/1218 16)))))
                     (alloc 2301
                       (*f 0.5 (load float64u (load (+a aux/1098 24)))))
                     (load (+a aux/1098 12)) addr))
                 (alloc 2048
                   (app "camlCode__create_1092"
                     (+ (load (+a aux/1098 16)) -2)
                     (let
                       (b/1220
                          (alloc 6398 a/1239
                            (load float64u (load (+a aux/1098 28))) a/1239)
                        a/1221 (load (+a aux/1098 20)))
                       (alloc 6398
                         (+f (load float64u a/1221) (load float64u b/1220))
                         (+f (load float64u (+a a/1221 8))
                           (load float64u (+a b/1220 8)))
                         (+f (load float64u (+a a/1221 16))
                           (load float64u (+a b/1220 16)))))
                     (alloc 2301
                       (*f 0.5 (load float64u (load (+a aux/1098 24)))))
                     (load (+a aux/1098 12)) addr)
                   1a))))))))))

(function camlCode__aux_1109 (x/1110: addr d/1111: addr)
 (alloc 2301
   (+f
     (-f (floatofint (>>s x/1110 1))
       (/f (floatofint (>>s (load (+a "camlCode" 64)) 1)) 2.))
     (/f (floatofint (>>s d/1111 1)) (floatofint 4)))))

(function camlCode__entry ()
 (let
   (delta/1238
      (extcall "sqrt" (load float64u (load (+a "camlPervasives" 56))) float)
    delta/1030 (alloc 2301 delta/1238))
   (store "camlCode" delta/1030))
 (let zero/1038 "camlCode__18" (store (+a "camlCode" 4) zero/1038))
 (let *|/1039 "camlCode__17" (store (+a "camlCode" 8) *|/1039))
 (let +|/1042 "camlCode__16" (store (+a "camlCode" 12) +|/1042))
 (let -|/1045 "camlCode__15" (store (+a "camlCode" 16) -|/1045))
 (let dot/1048 "camlCode__14" (store (+a "camlCode" 20) dot/1048))
 (let length/1051 "camlCode__13" (store (+a "camlCode" 24) length/1051))
 (let unitise/1053 "camlCode__12" (store (+a "camlCode" 28) unitise/1053))
 (let ray_sphere/1055 "camlCode__11"
   (store (+a "camlCode" 32) ray_sphere/1055))
 (let clos/1174 "camlCode__10" (store (+a "camlCode" 36) clos/1174)
   (store (+a "camlCode" 40) (+a clos/1174 16)))
 (let
   light/1083
     (let
       (r/1175 "camlCode__9"
        s/1237
          (/f 1.
            (extcall "sqrt"
              (+f
                (+f (*f (load float64u r/1175) (load float64u r/1175))
                  (*f (load float64u (+a r/1175 8))
                    (load float64u (+a r/1175 8))))
                (*f (load float64u (+a r/1175 16))
                  (load float64u (+a r/1175 16))))
              float)))
       (alloc 6398 (*f s/1237 (load float64u r/1175))
         (*f s/1237 (load float64u (+a r/1175 8)))
         (*f s/1237 (load float64u (+a r/1175 16)))))
   (store (+a "camlCode" 44) light/1083) (store (+a "camlCode" 48) 9))
 (let clos/1183 "camlCode__8" (store (+a "camlCode" 52) clos/1183))
 (let clos/1222 "camlCode__7" (store (+a "camlCode" 56) clos/1222))
 (let
   match/1150
     (try
       (alloc 2048
         (extcall "caml_int_of_string"
           (let arr/1235 (load "camlSys")
             (checkbound (>>u (load (+a arr/1235 -4)) 9) 3)
             (load (+a arr/1235 4)))
           addr)
         (extcall "caml_int_of_string"
           (let arr/1236 (load "camlSys")
             (checkbound (>>u (load (+a arr/1236 -4)) 9) 5)
             (load (+a arr/1236 8)))
           addr))
     with exn/1149 "camlCode__6")
   (store (+a "camlCode" 60) (load match/1150))
   (store (+a "camlCode" 64) (load (+a match/1150 4))))
 (let
   scene/1103
     (app "camlCode__create_1092" (load (+a "camlCode" 60)) "camlCode__4"
       "camlCode__5" (load (+a "camlCode" 56)) addr)
   (store (+a "camlCode" 68) scene/1103))
 (app "caml_apply2" (load (+a "camlCode" 64)) (load (+a "camlCode" 64))
   (app "camlPrintf__printf_1393" "camlCode__3" addr) unit)
 (let y/1104 (+ (load (+a "camlCode" 64)) -2)
   (catch
     (if (< y/1104 1) (exit 34)
       (loop
         (let (x/1105 1 bound/1228 (+ (load (+a "camlCode" 64)) -2))
           (catch
             (if (> x/1105 bound/1228) (exit 35)
               (loop
                 (let g/1229 0.
                   (let dx/1107 1
                     (catch
                       (if (> dx/1107 7) (exit 36)
                         (loop
                           (let dy/1108 1
                             (catch
                               (if (> dy/1108 7) (exit 37)
                                 (loop
                                   (let
                                     (aux/1109 "camlCode__2"
                                      dir/1112
                                        (let
                                          (r/1224
                                             (alloc 6398
                                               (+f
                                                 (-f
                                                   (floatofint
                                                     (>>s x/1105 1))
                                                   (/f
                                                     (floatofint
                                                       (>>s
                                                         (load
                                                           (+a "camlCode" 64))
                                                         1))
                                                     2.))
                                                 (/f
                                                   (floatofint
                                                     (>>s dx/1107 1))
                                                   (floatofint 4)))
                                               (+f
                                                 (-f
                                                   (floatofint
                                                     (>>s y/1104 1))
                                                   (/f
                                                     (floatofint
                                                       (>>s
                                                         (load
                                                           (+a "camlCode" 64))
                                                         1))
                                                     2.))
                                                 (/f
                                                   (floatofint
                                                     (>>s dy/1108 1))
                                                   (floatofint 4)))
                                               (floatofint
                                                 (>>s
                                                   (load (+a "camlCode" 64))
                                                   1)))
                                           s/1234
                                             (/f 1.
                                               (extcall "sqrt"
                                                 (+f
                                                   (+f
                                                     (*f
                                                       (load float64u r/1224)
                                                       (load float64u r/1224))
                                                     (*f
                                                       (load float64u
                                                         (+a r/1224 8))
                                                       (load float64u
                                                         (+a r/1224 8))))
                                                   (*f
                                                     (load float64u
                                                       (+a r/1224 16))
                                                     (load float64u
                                                       (+a r/1224 16))))
                                                 float)))
                                          (alloc 6398
                                            (*f s/1234
                                              (load float64u r/1224))
                                            (*f s/1234
                                              (load float64u (+a r/1224 8)))
                                            (*f s/1234
                                              (load float64u (+a r/1224 16))))))
                                     (assign g/1229
                                               (+f g/1229
                                                 (load float64u
                                                   (app
                                                     "camlCode__ray_trace_1085"
                                                     dir/1112
                                                     (load
                                                       (+a "camlCode" 68))
                                                     addr)))))
                                   (let dy/1233 dy/1108
                                     (assign dy/1108 (+ dy/1108 2))
                                     (if (== dy/1233 7) (exit 37) []))))
                             with(37) []))
                           (let dx/1232 dx/1107
                             (assign dx/1107 (+ dx/1107 2))
                             (if (== dx/1232 7) (exit 36) []))))
                     with(36) []))
                   (let
                     (g/1230 (+f 0.5 (/f (*f 255. g/1229) (floatofint 16)))
                      fun/1231
                        (app "camlPrintf__printf_1393" "camlCode__1" addr))
                     (app (load fun/1231)
                       (app "camlPervasives__char_of_int_1120"
                         (+ (<< (intoffloat g/1230) 1) 1) addr)
                       fun/1231 unit)))
                 (let x/1227 x/1105 (assign x/1105 (+ x/1105 2))
                   (if (== x/1227 bound/1228) (exit 35) []))))
           with(35) []))
         (let y/1226 y/1104 (assign y/1104 (- y/1104 2))
           (if (== y/1226 1) (exit 34) []))))
   with(34) []))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__aux_1098:
  x'/8[%edx] := R/0[%eax]
  {x'/8[%edx]* z'/9[%ebx]* env/10[%ecx]*}
  A/11[%esi] := alloc 68
  [A/11[%esi] + -4] := 2301
  A/12[%eax] := [env/10[%ecx] + 24]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] *f float64[A/12[%eax]]
  float64u[A/11[%esi]] := R/7[%tos]
  b/15[%eax] := A/11[%esi] + 12
  [b/15[%eax] + -4] := 6398
  R/7[%tos] := float64u[x'/8[%edx]]
  float64u[b/15[%eax]] := R/7[%tos]
  A/17[%edx] := [env/10[%ecx] + 28]
  R/7[%tos] := float64u[A/17[%edx]]
  float64u[b/15[%eax] + 8] := R/7[%tos]
  R/7[%tos] := float64u[z'/9[%ebx]]
  float64u[b/15[%eax] + 16] := R/7[%tos]
  a/20[%edx] := [env/10[%ecx] + 20]
  A/21[%ebx] := A/11[%esi] + 40
  [A/21[%ebx] + -4] := 6398
  R/7[%tos] := float64u[a/20[%edx]]
  R/7[%tos] := R/7[%tos] +f float64[b/15[%eax]]
  float64u[A/21[%ebx]] := R/7[%tos]
  R/7[%tos] := float64u[a/20[%edx] + 8]
  R/7[%tos] := R/7[%tos] +f float64[b/15[%eax] + 8]
  float64u[A/21[%ebx] + 8] := R/7[%tos]
  R/7[%tos] := float64u[a/20[%edx] + 16]
  R/7[%tos] := R/7[%tos] +f float64[b/15[%eax] + 16]
  float64u[A/21[%ebx] + 16] := R/7[%tos]
  A/28[%edx] := [env/10[%ecx] + 12]
  A/29[%eax] := [env/10[%ecx] + 16]
  I/30[%eax] := I/30[%eax] + -2
  R/2[%ecx] := A/11[%esi]
  tailcall "camlCode__create_1092" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  
*** Linearized code
camlCode__*|_1039:
  s/8[%ecx] := R/0[%eax]
  {s/8[%ecx]* r/9[%ebx]*}
  A/10[%eax] := alloc 28
  [A/10[%eax] + -4] := 6398
  R/7[%tos] := float64u[s/8[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[r/9[%ebx]]
  float64u[A/10[%eax]] := R/7[%tos]
  R/7[%tos] := float64u[s/8[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[r/9[%ebx] + 8]
  float64u[A/10[%eax] + 8] := R/7[%tos]
  R/7[%tos] := float64u[s/8[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[r/9[%ebx] + 16]
  float64u[A/10[%eax] + 16] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__+|_1042:
  a/8[%ecx] := R/0[%eax]
  {a/8[%ecx]* b/9[%ebx]*}
  A/10[%eax] := alloc 28
  [A/10[%eax] + -4] := 6398
  R/7[%tos] := float64u[a/8[%ecx]]
  R/7[%tos] := R/7[%tos] +f float64[b/9[%ebx]]
  float64u[A/10[%eax]] := R/7[%tos]
  R/7[%tos] := float64u[a/8[%ecx] + 8]
  R/7[%tos] := R/7[%tos] +f float64[b/9[%ebx] + 8]
  float64u[A/10[%eax] + 8] := R/7[%tos]
  R/7[%tos] := float64u[a/8[%ecx] + 16]
  R/7[%tos] := R/7[%tos] +f float64[b/9[%ebx] + 16]
  float64u[A/10[%eax] + 16] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__-|_1045:
  a/8[%ecx] := R/0[%eax]
  {a/8[%ecx]* b/9[%ebx]*}
  A/10[%eax] := alloc 28
  [A/10[%eax] + -4] := 6398
  R/7[%tos] := float64u[a/8[%ecx]]
  R/7[%tos] := R/7[%tos] -f float64[b/9[%ebx]]
  float64u[A/10[%eax]] := R/7[%tos]
  R/7[%tos] := float64u[a/8[%ecx] + 8]
  R/7[%tos] := R/7[%tos] -f float64[b/9[%ebx] + 8]
  float64u[A/10[%eax] + 8] := R/7[%tos]
  R/7[%tos] := float64u[a/8[%ecx] + 16]
  R/7[%tos] := R/7[%tos] -f float64[b/9[%ebx] + 16]
  float64u[A/10[%eax] + 16] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__dot_1048:
  a/8[%ecx] := R/0[%eax]
  {a/8[%ecx]* b/9[%ebx]*}
  A/10[%eax] := alloc 12
  [A/10[%eax] + -4] := 2301
  R/7[%tos] := float64u[a/8[%ecx] + 8]
  R/7[%tos] := R/7[%tos] *f float64[b/9[%ebx] + 8]
  R/7[%tos] := float64u[a/8[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[b/9[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := float64u[a/8[%ecx] + 16]
  R/7[%tos] := R/7[%tos] *f float64[b/9[%ebx] + 16]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  float64u[A/10[%eax]] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__length_1051:
  R/7[%tos] := float64u[r/8[%eax] + 8]
  R/7[%tos] := R/7[%tos] *f float64[r/8[%eax] + 8]
  R/7[%tos] := float64u[r/8[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[r/8[%eax]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := float64u[r/8[%eax] + 16]
  R/7[%tos] := R/7[%tos] *f float64[r/8[%eax] + 16]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/17[s0] := R/7[%tos]
  {F/17[s0]}
  A/18[%eax] := alloc 12
  [A/18[%eax] + -4] := 2301
  float64u[A/18[%eax]] := F/17[s0]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__unitise_1053:
  r/8[%ebx] := R/0[%eax]
  R/7[%tos] := float64u[r/8[%ebx] + 8]
  R/7[%tos] := R/7[%tos] *f float64[r/8[%ebx] + 8]
  R/7[%tos] := float64u[r/8[%ebx]]
  R/7[%tos] := R/7[%tos] *f float64[r/8[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := float64u[r/8[%ebx] + 16]
  R/7[%tos] := R/7[%tos] *f float64[r/8[%ebx] + 16]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {r/8[%ebx]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/17[s0] := R/7[%tos]
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] /f F/17[s0]
  s/20[s0] := R/7[%tos]
  {r/8[%ebx]* s/20[s0]}
  A/21[%eax] := alloc 28
  [A/21[%eax] + -4] := 6398
  R/7[%tos] := s/20[s0] *f float64[r/8[%ebx]]
  float64u[A/21[%eax]] := R/7[%tos]
  R/7[%tos] := s/20[s0] *f float64[r/8[%ebx] + 8]
  float64u[A/21[%eax] + 8] := R/7[%tos]
  R/7[%tos] := s/20[s0] *f float64[r/8[%ebx] + 16]
  float64u[A/21[%eax] + 16] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__ray_sphere_1055:
  orig/8[%esi] := R/0[%eax]
  {orig/8[%esi]* dir/9[%ebx]* center/10[%ecx]* radius/11[%edx]*}
  v/12[%eax] := alloc 28
  [v/12[%eax] + -4] := 6398
  R/7[%tos] := float64u[center/10[%ecx]]
  R/7[%tos] := R/7[%tos] -f float64[orig/8[%esi]]
  float64u[v/12[%eax]] := R/7[%tos]
  R/7[%tos] := float64u[center/10[%ecx] + 8]
  R/7[%tos] := R/7[%tos] -f float64[orig/8[%esi] + 8]
  float64u[v/12[%eax] + 8] := R/7[%tos]
  R/7[%tos] := float64u[center/10[%ecx] + 16]
  R/7[%tos] := R/7[%tos] -f float64[orig/8[%esi] + 16]
  float64u[v/12[%eax] + 16] := R/7[%tos]
  R/7[%tos] := float64u[v/12[%eax] + 8]
  R/7[%tos] := R/7[%tos] *f float64[dir/9[%ebx] + 8]
  R/7[%tos] := float64u[v/12[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[dir/9[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := float64u[v/12[%eax] + 16]
  R/7[%tos] := R/7[%tos] *f float64[dir/9[%ebx] + 16]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  b/27[s2] := R/7[%tos]
  R/7[%tos] := float64u[v/12[%eax] + 8]
  R/7[%tos] := R/7[%tos] *f float64[v/12[%eax] + 8]
  R/7[%tos] := float64u[v/12[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[v/12[%eax]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := float64u[v/12[%eax] + 16]
  R/7[%tos] := R/7[%tos] *f float64[v/12[%eax] + 16]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := b/27[s2] *f b/27[s2]
  R/7[%tos] := R/7[%tos] -f R/7[%tos]
  R/7[%tos] := float64u[radius/11[%edx]]
  R/7[%tos] := R/7[%tos] *f float64[radius/11[%edx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  d2/41[s0] := R/7[%tos]
  R/7[%tos] := 0.
  if not d2/41[s0] <f R/7[%tos] goto L131
  A/53[%eax] := ["camlPervasives" + 36]
  reload retaddr
  return R/0[%eax]
  L131:
  push d2/41[s0]
  {b/27[s2]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  d/43[s0] := R/7[%tos]
  R/7[%tos] := b/27[s2] -f d/43[s0]
  t1/45[s1] := R/7[%tos]
  {b/27[s2] d/43[s0] t1/45[s1]}
  t1/46[%ecx] := alloc 24
  [t1/46[%ecx] + -4] := 2301
  float64u[t1/46[%ecx]] := t1/45[s1]
  R/7[%tos] := b/27[s2] +f d/43[s0]
  t2/48[s0] := R/7[%tos]
  t2/49[%ebx] := t1/46[%ecx] + 12
  [t2/49[%ebx] + -4] := 2301
  float64u[t2/49[%ebx]] := t2/48[s0]
  R/7[%tos] := 0.
  if not t2/48[s0] >f R/7[%tos] goto L129
  R/7[%tos] := 0.
  if not t1/45[s1] >f R/7[%tos] goto L130
  R/0[%eax] := t1/46[%ecx]
  reload retaddr
  return R/0[%eax]
  L130:
  R/0[%eax] := t2/49[%ebx]
  reload retaddr
  return R/0[%eax]
  L129:
  A/51[%eax] := ["camlPervasives" + 36]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__intersects_1067:
  if param/11[%edx] ==s 1 goto L139
  spilled-param/17[s0] := param/11[%edx] (spill)
  spilled-dir/15[s2] := dir/9[%ebx] (spill)
  spilled-orig/16[s1] := orig/8[%eax] (spill)
  A/12[%edx] := [param/11[%edx]]
  {spilled-dir/15[s2]* spilled-orig/16[s1]* spilled-param/17[s0]*}
  R/0[%eax] := call "camlCode__intersect_1066" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/13[%ecx] := R/0[%eax]
  param/18[%eax] := spilled-param/17[s0] (reload)
  A/14[%edx] := [param/18[%eax] + 4]
  orig/19[%eax] := spilled-orig/16[s1] (reload)
  dir/20[%ebx] := spilled-dir/15[s2] (reload)
  tailcall "camlCode__intersects_1067" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  L139:
  R/0[%eax] := hit/10[%ecx]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__intersect_1066:
  spilled-orig/100[s0] := orig/8[%eax] (spill)
  spilled-hit/99[s1] := hit/10[%ecx] (spill)
  scene/103[%eax] := [param/11[%edx] + 8]
  scene/12[s2] := scene/103[%eax]
  center/13[%edi] := [param/11[%edx]]
  radius/14[%ecx] := [param/11[%edx] + 4]
  {dir/9[%ebx]* scene/12[s2]* center/13[%edi]* radius/14[%ecx]*
   spilled-hit/99[s1]* spilled-orig/100[s0]*}
  v/15[%eax] := alloc 28
  [v/15[%eax] + -4] := 6398
  R/7[%tos] := float64u[center/13[%edi]]
  orig/101[%esi] := spilled-orig/100[s0] (reload)
  R/7[%tos] := R/7[%tos] -f float64[orig/101[%esi]]
  float64u[v/15[%eax]] := R/7[%tos]
  R/7[%tos] := float64u[center/13[%edi] + 8]
  R/7[%tos] := R/7[%tos] -f float64[orig/101[%esi] + 8]
  float64u[v/15[%eax] + 8] := R/7[%tos]
  R/7[%tos] := float64u[center/13[%edi] + 16]
  R/7[%tos] := R/7[%tos] -f float64[orig/101[%esi] + 16]
  float64u[v/15[%eax] + 16] := R/7[%tos]
  R/7[%tos] := float64u[v/15[%eax] + 8]
  R/7[%tos] := R/7[%tos] *f float64[dir/9[%ebx] + 8]
  R/7[%tos] := float64u[v/15[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[dir/9[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := float64u[v/15[%eax] + 16]
  R/7[%tos] := R/7[%tos] *f float64[dir/9[%ebx] + 16]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  b/30[s2] := R/7[%tos]
  R/7[%tos] := float64u[v/15[%eax] + 8]
  R/7[%tos] := R/7[%tos] *f float64[v/15[%eax] + 8]
  R/7[%tos] := float64u[v/15[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[v/15[%eax]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := float64u[v/15[%eax] + 16]
  R/7[%tos] := R/7[%tos] *f float64[v/15[%eax] + 16]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := b/30[s2] *f b/30[s2]
  R/7[%tos] := R/7[%tos] -f R/7[%tos]
  R/7[%tos] := float64u[radius/14[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[radius/14[%ecx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  d2/44[s0] := R/7[%tos]
  R/7[%tos] := 0.
  if not d2/44[s0] <f R/7[%tos] goto L146
  match/46[%ebp] := ["camlPervasives" + 36]
  goto L144
  L146:
  push d2/44[s0]
  {dir/9[%ebx]* scene/12[s2]* center/13[%edi]* b/30[s2] spilled-hit/99[s1]*
   orig/101[%esi]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  d/47[s0] := R/7[%tos]
  R/7[%tos] := b/30[s2] -f d/47[s0]
  t1/49[s1] := R/7[%tos]
  {dir/9[%ebx]* scene/12[s2]* center/13[%edi]* b/30[s2] d/47[s0] t1/49[s1]
   spilled-hit/99[s1]* orig/101[%esi]*}
  t1/50[%ecx] := alloc 24
  [t1/50[%ecx] + -4] := 2301
  float64u[t1/50[%ecx]] := t1/49[s1]
  R/7[%tos] := b/30[s2] +f d/47[s0]
  t2/52[s0] := R/7[%tos]
  t2/53[%ebp] := t1/50[%ecx] + 12
  [t2/53[%ebp] + -4] := 2301
  float64u[t2/53[%ebp]] := t2/52[s0]
  R/7[%tos] := 0.
  if not t2/52[s0] >f R/7[%tos] goto L145
  R/7[%tos] := 0.
  if not t1/49[s1] >f R/7[%tos] goto L144
  A/56[%ebp] := t1/50[%ecx]
  goto L144
  L145:
  A/57[%ebp] := ["camlPervasives" + 36]
  L144:
  hit/102[%ecx] := spilled-hit/99[s1] (reload)
  A/58[%eax] := [hit/102[%ecx]]
  R/7[%tos] := float64u[A/58[%eax]]
  R/7[%tos] := float64u[match/46[%ebp]]
  if not R/7[%tos] >=f R/7[%tos] goto L143
  R/0[%eax] := hit/102[%ecx]
  reload retaddr
  return R/0[%eax]
  L143:
  if scene/12[s2] ==s 1 goto L142
  R/0[%eax] := orig/101[%esi]
  R/3[%edx] := scene/12[s2]
  tailcall "camlCode__intersects_1067" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  L142:
  {dir/9[%ebx]* center/13[%edi]* match/46[%ebp]* orig/101[%esi]*}
  b/61[%ecx] := alloc 84
  [b/61[%ecx] + -4] := 6398
  R/7[%tos] := float64u[match/46[%ebp]]
  R/7[%tos] := R/7[%tos] *f float64[dir/9[%ebx]]
  float64u[b/61[%ecx]] := R/7[%tos]
  R/7[%tos] := float64u[match/46[%ebp]]
  R/7[%tos] := R/7[%tos] *f float64[dir/9[%ebx] + 8]
  float64u[b/61[%ecx] + 8] := R/7[%tos]
  R/7[%tos] := float64u[match/46[%ebp]]
  R/7[%tos] := R/7[%tos] *f float64[dir/9[%ebx] + 16]
  float64u[b/61[%ecx] + 16] := R/7[%tos]
  a/68[%eax] := b/61[%ecx] + 28
  [a/68[%eax] + -4] := 6398
  R/7[%tos] := float64u[orig/101[%esi]]
  R/7[%tos] := R/7[%tos] +f float64[b/61[%ecx]]
  float64u[a/68[%eax]] := R/7[%tos]
  R/7[%tos] := float64u[orig/101[%esi] + 8]
  R/7[%tos] := R/7[%tos] +f float64[b/61[%ecx] + 8]
  float64u[a/68[%eax] + 8] := R/7[%tos]
  R/7[%tos] := float64u[orig/101[%esi] + 16]
  R/7[%tos] := R/7[%tos] +f float64[b/61[%ecx] + 16]
  float64u[a/68[%eax] + 16] := R/7[%tos]
  r/75[%ebx] := b/61[%ecx] + 56
  [r/75[%ebx] + -4] := 6398
  R/7[%tos] := float64u[a/68[%eax]]
  R/7[%tos] := R/7[%tos] -f float64[center/13[%edi]]
  float64u[r/75[%ebx]] := R/7[%tos]
  R/7[%tos] := float64u[a/68[%eax] + 8]
  R/7[%tos] := R/7[%tos] -f float64[center/13[%edi] + 8]
  float64u[r/75[%ebx] + 8] := R/7[%tos]
  R/7[%tos] := float64u[a/68[%eax] + 16]
  R/7[%tos] := R/7[%tos] -f float64[center/13[%edi] + 16]
  float64u[r/75[%ebx] + 16] := R/7[%tos]
  R/7[%tos] := float64u[r/75[%ebx] + 8]
  R/7[%tos] := R/7[%tos] *f float64[r/75[%ebx] + 8]
  R/7[%tos] := float64u[r/75[%ebx]]
  R/7[%tos] := R/7[%tos] *f float64[r/75[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := float64u[r/75[%ebx] + 16]
  R/7[%tos] := R/7[%tos] *f float64[r/75[%ebx] + 16]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {match/46[%ebp]* r/75[%ebx]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/90[s0] := R/7[%tos]
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] /f F/90[s0]
  s/93[s0] := R/7[%tos]
  {match/46[%ebp]* r/75[%ebx]* s/93[s0]}
  A/94[%ecx] := alloc 40
  [A/94[%ecx] + -4] := 6398
  R/7[%tos] := s/93[s0] *f float64[r/75[%ebx]]
  float64u[A/94[%ecx]] := R/7[%tos]
  R/7[%tos] := s/93[s0] *f float64[r/75[%ebx] + 8]
  float64u[A/94[%ecx] + 8] := R/7[%tos]
  R/7[%tos] := s/93[s0] *f float64[r/75[%ebx] + 16]
  float64u[A/94[%ecx] + 16] := R/7[%tos]
  A/98[%eax] := A/94[%ecx] + 28
  [A/98[%eax] + -4] := 2048
  [A/98[%eax]] := match/46[%ebp]
  [A/98[%eax] + 4] := A/94[%ecx]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__ray_trace_1085:
  dir/8[%esi] := R/0[%eax]
  spilled-dir/63[s0] := dir/8[%esi] (spill)
  scene/9[%edx] := R/1[%ebx]
  spilled-scene/62[s1] := scene/9[%edx] (spill)
  {dir/8[%esi]* scene/9[%edx]* spilled-scene/62[s1]* spilled-dir/63[s0]*}
  A/10[%ecx] := alloc 12
  [A/10[%ecx] + -4] := 2048
  A/11[%eax] := ["camlPervasives" + 36]
  [A/10[%ecx]] := A/11[%eax]
  A/12[%eax] := ["camlCode" + 4]
  [A/10[%ecx] + 4] := A/12[%eax]
  A/13[%eax] := ["camlCode" + 4]
  R/1[%ebx] := dir/8[%esi]
  {spilled-scene/62[s1]* spilled-dir/63[s0]*}
  R/0[%eax] := call "camlCode__intersect_1066" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  match/14[%esi] := R/0[%eax]
  n/15[%ebx] := [match/14[%esi] + 4]
  b/16[%edx] := ["camlCode" + 44]
  {match/14[%esi]* n/15[%ebx]* b/16[%edx]* spilled-scene/62[s1]*
   spilled-dir/63[s0]*}
  g/17[%ecx] := alloc 12
  [g/17[%ecx] + -4] := 2301
  R/7[%tos] := float64u[n/15[%ebx] + 8]
  R/7[%tos] := R/7[%tos] *f float64[b/16[%edx] + 8]
  R/7[%tos] := float64u[n/15[%ebx]]
  R/7[%tos] := R/7[%tos] *f float64[b/16[%edx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := float64u[n/15[%ebx] + 16]
  R/7[%tos] := R/7[%tos] *f float64[b/16[%edx] + 16]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  float64u[g/17[%ecx]] := R/7[%tos]
  R/7[%tos] := 0.
  R/7[%tos] := float64u[g/17[%ecx]]
  if not R/7[%tos] <=f R/7[%tos] goto L161
  A/60[%eax] := "camlCode__20"
  reload retaddr
  return R/0[%eax]
  L161:
  spilled-g/61[s2] := g/17[%ecx] (spill)
  A/28[%eax] := ["camlPervasives" + 56]
  pushfloat [A/28[%eax]]
  {match/14[%esi]* n/15[%ebx]* spilled-g/61[s2]* spilled-scene/62[s1]*
   spilled-dir/63[s0]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  s/29[s0] := R/7[%tos]
  {match/14[%esi]* n/15[%ebx]* s/29[s0] spilled-g/61[s2]*
   spilled-scene/62[s1]* spilled-dir/63[s0]*}
  b/30[%edx] := alloc 96
  [b/30[%edx] + -4] := 6398
  R/7[%tos] := s/29[s0] *f float64[n/15[%ebx]]
  float64u[b/30[%edx]] := R/7[%tos]
  R/7[%tos] := s/29[s0] *f float64[n/15[%ebx] + 8]
  float64u[b/30[%edx] + 8] := R/7[%tos]
  R/7[%tos] := s/29[s0] *f float64[n/15[%ebx] + 16]
  float64u[b/30[%edx] + 16] := R/7[%tos]
  s/34[%ecx] := [match/14[%esi]]
  a/35[%ebx] := b/30[%edx] + 28
  [a/35[%ebx] + -4] := 6398
  R/7[%tos] := float64u[s/34[%ecx]]
  dir/64[%eax] := spilled-dir/63[s0] (reload)
  R/7[%tos] := R/7[%tos] *f float64[dir/64[%eax]]
  float64u[a/35[%ebx]] := R/7[%tos]
  R/7[%tos] := float64u[s/34[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[dir/64[%eax] + 8]
  float64u[a/35[%ebx] + 8] := R/7[%tos]
  R/7[%tos] := float64u[s/34[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[dir/64[%eax] + 16]
  float64u[a/35[%ebx] + 16] := R/7[%tos]
  p/42[%eax] := b/30[%edx] + 56
  [p/42[%eax] + -4] := 6398
  R/7[%tos] := float64u[a/35[%ebx]]
  R/7[%tos] := R/7[%tos] +f float64[b/30[%edx]]
  float64u[p/42[%eax]] := R/7[%tos]
  R/7[%tos] := float64u[a/35[%ebx] + 8]
  R/7[%tos] := R/7[%tos] +f float64[b/30[%edx] + 8]
  float64u[p/42[%eax] + 8] := R/7[%tos]
  R/7[%tos] := float64u[a/35[%ebx] + 16]
  R/7[%tos] := R/7[%tos] +f float64[b/30[%edx] + 16]
  float64u[p/42[%eax] + 16] := R/7[%tos]
  A/49[%ecx] := b/30[%edx] + 84
  [A/49[%ecx] + -4] := 2048
  A/50[%ebx] := ["camlPervasives" + 36]
  [A/49[%ecx]] := A/50[%ebx]
  A/51[%ebx] := ["camlCode" + 4]
  [A/49[%ecx] + 4] := A/51[%ebx]
  A/52[%ebx] := ["camlCode" + 44]
  scene/65[%edx] := spilled-scene/62[s1] (reload)
  {spilled-g/61[s2]*}
  R/0[%eax] := call "camlCode__intersect_1066" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/54[%eax] := [A/53[%eax]]
  R/7[%tos] := float64u[A/54[%eax]]
  F/56[s0] := R/7[%tos]
  A/57[%eax] := ["camlPervasives" + 36]
  R/7[%tos] := float64u[A/57[%eax]]
  if not F/56[s0] <f R/7[%tos] goto L160
  A/59[%eax] := "camlCode__19"
  reload retaddr
  return R/0[%eax]
  L160:
  g/66[%eax] := spilled-g/61[s2] (reload)
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__create_1092:
  level/8[%edi] := R/0[%eax]
  r/10[%esi] := R/2[%ecx]
  {level/8[%edi]* c/9[%ebx]* r/10[%esi]* env/11[%edx]*}
  obj/12[%eax] := alloc 16
  [obj/12[%eax] + -4] := 3072
  [obj/12[%eax]] := c/9[%ebx]
  [obj/12[%eax] + 4] := r/10[%esi]
  [obj/12[%eax] + 8] := 1
  if level/8[%edi] !=s 3 goto L174
  reload retaddr
  return R/0[%eax]
  L174:
  spilled-obj/116[s3] := obj/12[%eax] (spill)
  spilled-env/122[s0] := env/11[%edx] (spill)
  spilled-r/115[s4] := r/10[%esi] (spill)
  spilled-c/114[s5] := c/9[%ebx] (spill)
  R/7[%tos] := 12.
  push R/7[%tos]
  {level/8[%edi]* c/9[%ebx]* r/10[%esi]* spilled-c/114[s5]*
   spilled-r/115[s4]* spilled-obj/116[s3]* spilled-env/122[s0]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/14[s0] := R/7[%tos]
  R/7[%tos] := 3.
  R/7[%tos] := R/7[%tos] *f float64[r/10[%esi]]
  R/7[%tos] := F/14[s0] /f(rev) R/7[%tos]
  a/18[s0] := R/7[%tos]
  {level/8[%edi]* c/9[%ebx]* r/10[%esi]* a/18[s0] spilled-c/114[s5]*
   spilled-r/115[s4]* spilled-obj/116[s3]* spilled-a/119[s0]
   spilled-env/122[s0]*}
  a/19[%edx] := alloc 116
  [a/19[%edx] + -4] := 2301
  float64u[a/19[%edx]] := a/18[s0]
  aux/20[%eax] := a/19[%edx] + 12
  spilled-aux/118[s2] := aux/20[%eax] (spill)
  [aux/20[%eax] + -4] := 8439
  [aux/20[%eax]] := "caml_curry2"
  [aux/20[%eax] + 4] := 5
  [aux/20[%eax] + 8] := "camlCode__aux_1098"
  env/123[%ecx] := spilled-env/122[s0] (reload)
  [aux/20[%eax] + 12] := env/123[%ecx]
  [aux/20[%eax] + 16] := level/8[%edi]
  [aux/20[%eax] + 20] := c/9[%ebx]
  [aux/20[%eax] + 24] := r/10[%esi]
  [aux/20[%eax] + 28] := a/19[%edx]
  A/21[%ecx] := a/19[%edx] + 48
  [A/21[%ecx] + -4] := 2301
  A/22[%ebx] := [aux/20[%eax] + 24]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] *f float64[A/22[%ebx]]
  float64u[A/21[%ecx]] := R/7[%tos]
  b/25[%edi] := a/19[%edx] + 60
  [b/25[%edi] + -4] := 6398
  float64u[b/25[%edi]] := a/18[s0]
  A/26[%ebx] := [aux/20[%eax] + 28]
  R/7[%tos] := float64u[A/26[%ebx]]
  float64u[b/25[%edi] + 8] := R/7[%tos]
  float64u[b/25[%edi] + 16] := a/18[s0]
  a/28[%esi] := [aux/20[%eax] + 20]
  A/29[%ebx] := a/19[%edx] + 88
  [A/29[%ebx] + -4] := 6398
  R/7[%tos] := float64u[a/28[%esi]]
  R/7[%tos] := R/7[%tos] +f float64[b/25[%edi]]
  float64u[A/29[%ebx]] := R/7[%tos]
  R/7[%tos] := float64u[a/28[%esi] + 8]
  R/7[%tos] := R/7[%tos] +f float64[b/25[%edi] + 8]
  float64u[A/29[%ebx] + 8] := R/7[%tos]
  R/7[%tos] := float64u[a/28[%esi] + 16]
  R/7[%tos] := R/7[%tos] +f float64[b/25[%edi] + 16]
  float64u[A/29[%ebx] + 16] := R/7[%tos]
  A/36[%edx] := [aux/20[%eax] + 12]
  A/37[%eax] := [aux/20[%eax] + 16]
  I/38[%eax] := I/38[%eax] + -2
  {spilled-c/114[s5]* spilled-r/115[s4]* spilled-obj/116[s3]*
   spilled-aux/118[s2]* spilled-a/119[s0]}
  R/0[%eax] := call "camlCode__create_1092" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/39[%ebx] := R/0[%eax]
  {A/39[%ebx]* spilled-c/114[s5]* spilled-r/115[s4]* spilled-obj/116[s3]*
   spilled-aux/118[s2]* spilled-a/119[s0]}
  A/40[%eax] := alloc 80
  A/121[s0] := A/40[%eax] (spill)
  [A/40[%eax] + -4] := 2048
  [A/40[%eax]] := A/39[%ebx]
  [A/40[%eax] + 4] := 1
  R/7[%tos] := -f a/124[s0]
  x'/42[s1] := R/7[%tos]
  A/43[%ecx] := A/40[%eax] + 12
  [A/43[%ecx] + -4] := 2301
  aux/125[%esi] := spilled-aux/118[s2] (reload)
  A/44[%ebx] := [aux/125[%esi] + 24]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] *f float64[A/44[%ebx]]
  float64u[A/43[%ecx]] := R/7[%tos]
  b/47[%edi] := A/40[%eax] + 24
  [b/47[%edi] + -4] := 6398
  float64u[b/47[%edi]] := x'/42[s1]
  A/48[%ebx] := [aux/125[%esi] + 28]
  R/7[%tos] := float64u[A/48[%ebx]]
  float64u[b/47[%edi] + 8] := R/7[%tos]
  float64u[b/47[%edi] + 16] := a/124[s0]
  a/50[%edx] := [aux/125[%esi] + 20]
  A/51[%ebx] := A/40[%eax] + 52
  [A/51[%ebx] + -4] := 6398
  R/7[%tos] := float64u[a/50[%edx]]
  R/7[%tos] := R/7[%tos] +f float64[b/47[%edi]]
  float64u[A/51[%ebx]] := R/7[%tos]
  R/7[%tos] := float64u[a/50[%edx] + 8]
  R/7[%tos] := R/7[%tos] +f float64[b/47[%edi] + 8]
  float64u[A/51[%ebx] + 8] := R/7[%tos]
  R/7[%tos] := float64u[a/50[%edx] + 16]
  R/7[%tos] := R/7[%tos] +f float64[b/47[%edi] + 16]
  float64u[A/51[%ebx] + 16] := R/7[%tos]
  A/58[%edx] := [aux/125[%esi] + 12]
  A/59[%eax] := [aux/125[%esi] + 16]
  I/60[%eax] := I/60[%eax] + -2
  {spilled-c/114[s5]* spilled-r/115[s4]* spilled-obj/116[s3]*
   spilled-aux/118[s2]* spilled-a/119[s0] A/121[s0]*}
  R/0[%eax] := call "camlCode__create_1092" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/61[%ebx] := R/0[%eax]
  {A/61[%ebx]* spilled-c/114[s5]* spilled-r/115[s4]* spilled-obj/116[s3]*
   spilled-aux/118[s2]* spilled-a/119[s0] A/121[s0]*}
  A/62[%eax] := alloc 80
  A/120[s1] := A/62[%eax] (spill)
  [A/62[%eax] + -4] := 2048
  [A/62[%eax]] := A/61[%ebx]
  A/126[%ebx] := A/121[s0] (reload)
  [A/62[%eax] + 4] := A/126[%ebx]
  R/7[%tos] := -f a/127[s0]
  z'/64[s1] := R/7[%tos]
  A/65[%ecx] := A/62[%eax] + 12
  [A/65[%ecx] + -4] := 2301
  aux/128[%esi] := spilled-aux/118[s2] (reload)
  A/66[%ebx] := [aux/128[%esi] + 24]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] *f float64[A/66[%ebx]]
  float64u[A/65[%ecx]] := R/7[%tos]
  b/69[%edi] := A/62[%eax] + 24
  [b/69[%edi] + -4] := 6398
  float64u[b/69[%edi]] := a/127[s0]
  A/70[%ebx] := [aux/128[%esi] + 28]
  R/7[%tos] := float64u[A/70[%ebx]]
  float64u[b/69[%edi] + 8] := R/7[%tos]
  float64u[b/69[%edi] + 16] := z'/64[s1]
  a/72[%edx] := [aux/128[%esi] + 20]
  A/73[%ebx] := A/62[%eax] + 52
  [A/73[%ebx] + -4] := 6398
  R/7[%tos] := float64u[a/72[%edx]]
  R/7[%tos] := R/7[%tos] +f float64[b/69[%edi]]
  float64u[A/73[%ebx]] := R/7[%tos]
  R/7[%tos] := float64u[a/72[%edx] + 8]
  R/7[%tos] := R/7[%tos] +f float64[b/69[%edi] + 8]
  float64u[A/73[%ebx] + 8] := R/7[%tos]
  R/7[%tos] := float64u[a/72[%edx] + 16]
  R/7[%tos] := R/7[%tos] +f float64[b/69[%edi] + 16]
  float64u[A/73[%ebx] + 16] := R/7[%tos]
  A/80[%edx] := [aux/128[%esi] + 12]
  A/81[%eax] := [aux/128[%esi] + 16]
  I/82[%eax] := I/82[%eax] + -2
  {spilled-c/114[s5]* spilled-r/115[s4]* spilled-obj/116[s3]*
   spilled-aux/118[s2]* spilled-a/119[s0] A/120[s1]*}
  R/0[%eax] := call "camlCode__create_1092" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/83[%ebx] := R/0[%eax]
  {A/83[%ebx]* spilled-c/114[s5]* spilled-r/115[s4]* spilled-obj/116[s3]*
   spilled-aux/118[s2]* spilled-a/119[s0] A/120[s1]*}
  A/84[%eax] := alloc 80
  A/117[s0] := A/84[%eax] (spill)
  [A/84[%eax] + -4] := 2048
  [A/84[%eax]] := A/83[%ebx]
  A/129[%ebx] := A/120[s1] (reload)
  [A/84[%eax] + 4] := A/129[%ebx]
  R/7[%tos] := -f a/130[s0]
  z'/86[s1] := R/7[%tos]
  R/7[%tos] := -f a/130[s0]
  x'/88[s0] := R/7[%tos]
  A/89[%ecx] := A/84[%eax] + 12
  [A/89[%ecx] + -4] := 2301
  aux/131[%esi] := spilled-aux/118[s2] (reload)
  A/90[%ebx] := [aux/131[%esi] + 24]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] *f float64[A/90[%ebx]]
  float64u[A/89[%ecx]] := R/7[%tos]
  b/93[%edi] := A/84[%eax] + 24
  [b/93[%edi] + -4] := 6398
  float64u[b/93[%edi]] := x'/88[s0]
  A/94[%ebx] := [aux/131[%esi] + 28]
  R/7[%tos] := float64u[A/94[%ebx]]
  float64u[b/93[%edi] + 8] := R/7[%tos]
  float64u[b/93[%edi] + 16] := z'/86[s1]
  a/96[%edx] := [aux/131[%esi] + 20]
  A/97[%ebx] := A/84[%eax] + 52
  [A/97[%ebx] + -4] := 6398
  R/7[%tos] := float64u[a/96[%edx]]
  R/7[%tos] := R/7[%tos] +f float64[b/93[%edi]]
  float64u[A/97[%ebx]] := R/7[%tos]
  R/7[%tos] := float64u[a/96[%edx] + 8]
  R/7[%tos] := R/7[%tos] +f float64[b/93[%edi] + 8]
  float64u[A/97[%ebx] + 8] := R/7[%tos]
  R/7[%tos] := float64u[a/96[%edx] + 16]
  R/7[%tos] := R/7[%tos] +f float64[b/93[%edi] + 16]
  float64u[A/97[%ebx] + 16] := R/7[%tos]
  A/104[%edx] := [aux/131[%esi] + 12]
  A/105[%eax] := [aux/131[%esi] + 16]
  I/106[%eax] := I/106[%eax] + -2
  {spilled-c/114[s5]* spilled-r/115[s4]* spilled-obj/116[s3]* A/117[s0]*}
  R/0[%eax] := call "camlCode__create_1092" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/107[%ecx] := R/0[%eax]
  {A/107[%ecx]* spilled-c/114[s5]* spilled-r/115[s4]* spilled-obj/116[s3]*
   A/117[s0]*}
  A/108[%ebx] := alloc 52
  [A/108[%ebx] + -4] := 2048
  [A/108[%ebx]] := A/107[%ecx]
  A/132[%eax] := A/117[s0] (reload)
  [A/108[%ebx] + 4] := A/132[%eax]
  A/109[%edx] := A/108[%ebx] + 12
  [A/109[%edx] + -4] := 2048
  obj/133[%eax] := spilled-obj/116[s3] (reload)
  [A/109[%edx]] := obj/133[%eax]
  [A/109[%edx] + 4] := A/108[%ebx]
  A/110[%ecx] := A/108[%ebx] + 24
  [A/110[%ecx] + -4] := 2301
  R/7[%tos] := 3.
  r/134[%eax] := spilled-r/115[s4] (reload)
  R/7[%tos] := R/7[%tos] *f float64[r/134[%eax]]
  float64u[A/110[%ecx]] := R/7[%tos]
  A/113[%eax] := A/108[%ebx] + 36
  [A/113[%eax] + -4] := 3072
  c/135[%ebx] := spilled-c/114[s5] (reload)
  [A/113[%eax]] := c/135[%ebx]
  [A/113[%eax] + 4] := A/110[%ecx]
  [A/113[%eax] + 8] := A/109[%edx]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__aux_1109:
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
  A/17[%ebx] := ["camlCode" + 64]
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
  A/8[%eax] := ["camlPervasives" + 56]
  pushfloat [A/8[%eax]]
  {}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  delta/9[s0] := R/7[%tos]
  {delta/9[s0]}
  delta/10[%eax] := alloc 12
  [delta/10[%eax] + -4] := 2301
  float64u[delta/10[%eax]] := delta/9[s0]
  ["camlCode"] := delta/10[%eax]
  zero/11[%eax] := "camlCode__18"
  ["camlCode" + 4] := zero/11[%eax]
  *|/12[%eax] := "camlCode__17"
  ["camlCode" + 8] := *|/12[%eax]
  +|/13[%eax] := "camlCode__16"
  ["camlCode" + 12] := +|/13[%eax]
  -|/14[%eax] := "camlCode__15"
  ["camlCode" + 16] := -|/14[%eax]
  dot/15[%eax] := "camlCode__14"
  ["camlCode" + 20] := dot/15[%eax]
  length/16[%eax] := "camlCode__13"
  ["camlCode" + 24] := length/16[%eax]
  unitise/17[%eax] := "camlCode__12"
  ["camlCode" + 28] := unitise/17[%eax]
  ray_sphere/18[%eax] := "camlCode__11"
  ["camlCode" + 32] := ray_sphere/18[%eax]
  clos/19[%eax] := "camlCode__10"
  ["camlCode" + 36] := clos/19[%eax]
  A/20[%eax] := A/20[%eax] + 16
  ["camlCode" + 40] := A/20[%eax]
  r/21[%ebx] := "camlCode__9"
  R/7[%tos] := float64u[r/21[%ebx] + 8]
  R/7[%tos] := R/7[%tos] *f float64[r/21[%ebx] + 8]
  R/7[%tos] := float64u[r/21[%ebx]]
  R/7[%tos] := R/7[%tos] *f float64[r/21[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := float64u[r/21[%ebx] + 16]
  R/7[%tos] := R/7[%tos] *f float64[r/21[%ebx] + 16]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {r/21[%ebx]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/30[s0] := R/7[%tos]
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] /f F/30[s0]
  s/33[s0] := R/7[%tos]
  {r/21[%ebx]* s/33[s0]}
  light/34[%eax] := alloc 28
  [light/34[%eax] + -4] := 6398
  R/7[%tos] := s/33[s0] *f float64[r/21[%ebx]]
  float64u[light/34[%eax]] := R/7[%tos]
  R/7[%tos] := s/33[s0] *f float64[r/21[%ebx] + 8]
  float64u[light/34[%eax] + 8] := R/7[%tos]
  R/7[%tos] := s/33[s0] *f float64[r/21[%ebx] + 16]
  float64u[light/34[%eax] + 16] := R/7[%tos]
  ["camlCode" + 44] := light/34[%eax]
  ["camlCode" + 48] := 9
  clos/38[%eax] := "camlCode__8"
  ["camlCode" + 52] := clos/38[%eax]
  clos/39[%eax] := "camlCode__7"
  ["camlCode" + 56] := clos/39[%eax]
  setup trap L219
  A/52[%ebx] := "camlCode__6"
  goto L218
  L219:
  push trap
  arr/40[%ebx] := ["camlSys"]
  A/41[%eax] := [arr/40[%ebx] + -4]
  I/42[%eax] := I/42[%eax] >>u 9
  I/42[%eax] check > 5
  A/43[%eax] := [arr/40[%ebx] + 8]
  push A/43[%eax]
  {}
  R/0[%eax] := extcall "caml_int_of_string"  (noalloc)
  offset stack -4
  A/150[s0] := A/44[%eax] (spill)
  arr/45[%ebx] := ["camlSys"]
  A/46[%eax] := [arr/45[%ebx] + -4]
  I/47[%eax] := I/47[%eax] >>u 9
  I/47[%eax] check > 3
  A/48[%eax] := [arr/45[%ebx] + 4]
  push A/48[%eax]
  {A/150[s0]*}
  R/0[%eax] := extcall "caml_int_of_string"  (noalloc)
  offset stack -4
  A/49[%ecx] := R/0[%eax]
  {A/49[%ecx]* A/150[s0]*}
  match/50[%ebx] := alloc 12
  [match/50[%ebx] + -4] := 2048
  [match/50[%ebx]] := A/49[%ecx]
  A/160[%eax] := A/150[s0] (reload)
  [match/50[%ebx] + 4] := A/160[%eax]
  pop trap
  L218:
  A/53[%eax] := [match/50[%ebx]]
  ["camlCode" + 60] := A/53[%eax]
  A/54[%eax] := [match/50[%ebx] + 4]
  ["camlCode" + 64] := A/54[%eax]
  A/55[%edx] := ["camlCode" + 56]
  A/56[%ecx] := "camlCode__5"
  A/57[%ebx] := "camlCode__4"
  A/58[%eax] := ["camlCode" + 60]
  {}
  R/0[%eax] := call "camlCode__create_1092" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  ["camlCode" + 68] := scene/59[%eax]
  A/60[%eax] := "camlCode__3"
  {}
  R/0[%eax] := call "camlPrintf__printf_1393" R/0[%eax]
  A/61[%ecx] := R/0[%eax]
  A/62[%ebx] := ["camlCode" + 64]
  A/63[%eax] := ["camlCode" + 64]
  {}
  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/64[%eax] := ["camlCode" + 64]
  y/65[%eax] := y/65[%eax] + -2
  if y/65[%eax] <s 1 goto L210
  spilled-y/153[s3] := y/65[%eax] (spill)
  L211:
  x/66[%ebx] := 1
  spilled-x/154[s2] := x/66[%ebx] (spill)
  A/67[%eax] := ["camlCode" + 64]
  bound/68[%eax] := bound/68[%eax] + -2
  spilled-bound/156[s1] := bound/68[%eax] (spill)
  if x/66[%ebx] >s bound/68[%eax] goto L212
  L213:
  R/7[%tos] := 0.
  g/70[s0] := R/7[%tos]
  dx/71[%eax] := 1
  spilled-dx/155[s0] := dx/71[%eax] (spill)
  if dx/71[%eax] >s 7 goto L214
  L215:
  dy/72[%ecx] := 1
  spilled-dy/151[s4] := dy/72[%ecx] (spill)
  if dy/72[%ecx] >s 7 goto L216
  L217:
  aux/73[%eax] := "camlCode__2"
  {dy/72[%ecx] spilled-dy/151[s4] spilled-g/152[s0] spilled-y/153[s3]
   spilled-x/154[s2] spilled-dx/155[s0] spilled-bound/156[s1]}
  r/74[%ebx] := alloc 28
  [r/74[%ebx] + -4] := 6398
  I/75[%eax] := 4
  R/7[%tos] := floatofint I/75[%eax]
  dx/161[%eax] := spilled-dx/155[s0] (reload)
  I/77[%eax] := I/77[%eax] >>s 1
  R/7[%tos] := floatofint I/77[%eax]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  R/7[%tos] := 2.
  A/81[%eax] := ["camlCode" + 64]
  I/82[%eax] := I/82[%eax] >>s 1
  R/7[%tos] := floatofint I/82[%eax]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  x/162[%eax] := spilled-x/154[s2] (reload)
  I/85[%eax] := I/85[%eax] >>s 1
  R/7[%tos] := floatofint I/85[%eax]
  R/7[%tos] := R/7[%tos] -f R/7[%tos]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  float64u[r/74[%ebx]] := R/7[%tos]
  I/89[%eax] := 4
  R/7[%tos] := floatofint I/89[%eax]
  I/91[%ecx] := I/91[%ecx] >>s 1
  R/7[%tos] := floatofint I/91[%ecx]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  R/7[%tos] := 2.
  A/95[%eax] := ["camlCode" + 64]
  I/96[%eax] := I/96[%eax] >>s 1
  R/7[%tos] := floatofint I/96[%eax]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  y/163[%eax] := spilled-y/153[s3] (reload)
  I/99[%eax] := I/99[%eax] >>s 1
  R/7[%tos] := floatofint I/99[%eax]
  R/7[%tos] := R/7[%tos] -f R/7[%tos]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  float64u[r/74[%ebx] + 8] := R/7[%tos]
  A/103[%eax] := ["camlCode" + 64]
  I/104[%eax] := I/104[%eax] >>s 1
  R/7[%tos] := floatofint I/104[%eax]
  float64u[r/74[%ebx] + 16] := R/7[%tos]
  R/7[%tos] := float64u[r/74[%ebx] + 8]
  R/7[%tos] := R/7[%tos] *f float64[r/74[%ebx] + 8]
  R/7[%tos] := float64u[r/74[%ebx]]
  R/7[%tos] := R/7[%tos] *f float64[r/74[%ebx]]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  R/7[%tos] := float64u[r/74[%ebx] + 16]
  R/7[%tos] := R/7[%tos] *f float64[r/74[%ebx] + 16]
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  push R/7[%tos]
  {r/74[%ebx]* spilled-dy/151[s4] spilled-g/152[s0] spilled-y/153[s3]
   spilled-x/154[s2] spilled-dx/155[s0] spilled-bound/156[s1]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/114[s1] := R/7[%tos]
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] /f F/114[s1]
  s/117[s1] := R/7[%tos]
  {r/74[%ebx]* s/117[s1] spilled-dy/151[s4] spilled-g/152[s0]
   spilled-y/153[s3] spilled-x/154[s2] spilled-dx/155[s0]
   spilled-bound/156[s1]}
  dir/118[%eax] := alloc 28
  [dir/118[%eax] + -4] := 6398
  R/7[%tos] := s/117[s1] *f float64[r/74[%ebx]]
  float64u[dir/118[%eax]] := R/7[%tos]
  R/7[%tos] := s/117[s1] *f float64[r/74[%ebx] + 8]
  float64u[dir/118[%eax] + 8] := R/7[%tos]
  R/7[%tos] := s/117[s1] *f float64[r/74[%ebx] + 16]
  float64u[dir/118[%eax] + 16] := R/7[%tos]
  A/122[%ebx] := ["camlCode" + 68]
  {spilled-dy/151[s4] spilled-g/152[s0] spilled-y/153[s3] spilled-x/154[s2]
   spilled-dx/155[s0] spilled-bound/156[s1]}
  R/0[%eax] := call "camlCode__ray_trace_1085" R/0[%eax] R/1[%ebx]
  R/7[%tos] := float64u[A/123[%eax]]
  F/125[s1] := R/7[%tos]
  R/7[%tos] := g/70[s0] +f F/125[s1]
  g/70[s0] := R/7[%tos]
  dy/72[%ecx] := spilled-dy/151[s4] (reload)
  dy/127[%eax] := dy/72[%ecx]
  I/128[%ecx] := I/128[%ecx] + 2
  spilled-dy/151[s4] := dy/72[%ecx] (spill)
  if dy/127[%eax] !=s 7 goto L217
  L216:
  dx/166[%eax] := spilled-dx/155[s0] (reload)
  dx/129[%ebx] := dx/166[%eax]
  I/130[%eax] := I/130[%eax] + 2
  spilled-dx/155[s0] := dx/166[%eax] (spill)
  if dx/129[%ebx] !=s 7 goto L215
  L214:
  R/7[%tos] := 255.
  R/7[%tos] := R/7[%tos] *f g/70[s0]
  I/133[%eax] := 16
  R/7[%tos] := floatofint I/133[%eax]
  R/7[%tos] := R/7[%tos] /f(rev) R/7[%tos]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] +f R/7[%tos]
  g/138[s0] := R/7[%tos]
  A/139[%eax] := "camlCode__1"
  {spilled-y/153[s3] spilled-x/154[s2] spilled-bound/156[s1]
   spilled-g/158[s0]}
  R/0[%eax] := call "camlPrintf__printf_1393" R/0[%eax]
  spilled-fun/157[s0] := fun/140[%eax] (spill)
  I/141[%eax] := intoffloat g/167[s0]
  I/142[%eax] := I/141[%eax]  * 2 + 1
  {spilled-y/153[s3] spilled-x/154[s2] spilled-bound/156[s1]
   spilled-fun/157[s0]*}
  R/0[%eax] := call "camlPervasives__char_of_int_1120" R/0[%eax]
  fun/168[%ebx] := spilled-fun/157[s0] (reload)
  A/144[%ecx] := [fun/168[%ebx]]
  {spilled-y/153[s3] spilled-x/154[s2] spilled-bound/156[s1]}
  call A/144[%ecx] R/0[%eax] R/1[%ebx]
  x/169[%eax] := spilled-x/154[s2] (reload)
  x/145[%ebx] := x/169[%eax]
  I/146[%eax] := I/146[%eax] + 2
  spilled-x/154[s2] := x/169[%eax] (spill)
  bound/170[%eax] := spilled-bound/156[s1] (reload)
  if x/145[%ebx] !=s bound/170[%eax] goto L213
  L212:
  y/171[%eax] := spilled-y/153[s3] (reload)
  y/147[%ebx] := y/171[%eax]
  I/148[%eax] := I/148[%eax] - 2
  spilled-y/153[s3] := y/171[%eax] (spill)
  if y/147[%ebx] !=s 1 goto L211
  L210:
  A/149[%eax] := 1
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
	.long	18432
	.globl	camlCode
camlCode:
	.space	72
	.data
	.long	3319
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__aux_1109
	.data
	.long	3319
camlCode__7:
	.long	caml_curry3
	.long	7
	.long	camlCode__create_1092
	.data
	.long	3319
camlCode__8:
	.long	caml_curry2
	.long	5
	.long	camlCode__ray_trace_1085
	.data
	.long	7415
camlCode__10:
	.long	caml_curry4
	.long	9
	.long	camlCode__intersect_1066
	.long	4345
	.long	caml_curry4
	.long	9
	.long	camlCode__intersects_1067
	.data
	.long	3319
camlCode__11:
	.long	caml_curry4
	.long	9
	.long	camlCode__ray_sphere_1055
	.data
	.long	2295
camlCode__12:
	.long	camlCode__unitise_1053
	.long	3
	.data
	.long	2295
camlCode__13:
	.long	camlCode__length_1051
	.long	3
	.data
	.long	3319
camlCode__14:
	.long	caml_curry2
	.long	5
	.long	camlCode__dot_1048
	.data
	.long	3319
camlCode__15:
	.long	caml_curry2
	.long	5
	.long	camlCode__$2d$7c_1045
	.data
	.long	3319
camlCode__16:
	.long	caml_curry2
	.long	5
	.long	camlCode__$2b$7c_1042
	.data
	.long	3319
camlCode__17:
	.long	caml_curry2
	.long	5
	.long	camlCode__$2a$7c_1039
	.data
	.long	1276
camlCode__1:
	.ascii	"%c"
	.space	1
	.byte	1
	.data
	.long	4348
camlCode__3:
	.ascii	"P5\12%d %d\12\62\65\65\12"
	.space	2
	.byte	2
	.data
	.long	6398
camlCode__4:
	.long	0x0, 0x0
	.long	0x0, 0xbff00000
	.long	0x0, 0x40100000
	.data
	.long	2301
camlCode__5:
	.long	0x0, 0x3ff00000
	.data
	.long	2048
camlCode__6:
	.long	13
	.long	1025
	.data
	.long	6398
camlCode__9:
	.long	0x0, 0x3ff00000
	.long	0x0, 0x40080000
	.long	0x0, 0xc0000000
	.data
	.long	6398
camlCode__18:
	.long	0x0, 0x0
	.long	0x0, 0x0
	.long	0x0, 0x0
	.data
	.long	2301
camlCode__19:
	.long	0x0, 0x0
	.data
	.long	2301
camlCode__20:
	.long	0x0, 0x0
	.text
	.align	16
	.globl	camlCode__aux_1098
camlCode__aux_1098:
	subl	$8, %esp
.L100:
	movl	%eax, %edx
.L101:	movl	caml_young_ptr, %eax
	subl	$68, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L102
	leal	4(%eax), %esi
	movl	$2301, -4(%esi)
	movl	24(%ecx), %eax
	fldl	.L104
	fmull	(%eax)
	fstpl	(%esi)
	leal	12(%esi), %eax
	movl	$6398, -4(%eax)
	fldl	(%edx)
	fstpl	(%eax)
	movl	28(%ecx), %edx
	fldl	(%edx)
	fstpl	8(%eax)
	fldl	(%ebx)
	fstpl	16(%eax)
	movl	20(%ecx), %edx
	leal	40(%esi), %ebx
	movl	$6398, -4(%ebx)
	fldl	(%edx)
	faddl	(%eax)
	fstpl	(%ebx)
	fldl	8(%edx)
	faddl	8(%eax)
	fstpl	8(%ebx)
	fldl	16(%edx)
	faddl	16(%eax)
	fstpl	16(%ebx)
	movl	12(%ecx), %edx
	movl	16(%ecx), %eax
	addl	$-2, %eax
	movl	%esi, %ecx
	addl	$8, %esp
	jmp	camlCode__create_1092
.L102:	call	caml_call_gc
.L103:	jmp	.L101
	.data
.L104:	.long	0x0, 0x3fe00000
	.type	camlCode__aux_1098,@function
	.size	camlCode__aux_1098,.-camlCode__aux_1098
	.text
	.align	16
	.globl	camlCode__$2a$7c_1039
camlCode__$2a$7c_1039:
	subl	$8, %esp
.L105:
	movl	%eax, %ecx
.L106:	movl	caml_young_ptr, %eax
	subl	$28, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L107
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	(%ecx)
	fmull	(%ebx)
	fstpl	(%eax)
	fldl	(%ecx)
	fmull	8(%ebx)
	fstpl	8(%eax)
	fldl	(%ecx)
	fmull	16(%ebx)
	fstpl	16(%eax)
	addl	$8, %esp
	ret
.L107:	call	caml_call_gc
.L108:	jmp	.L106
	.type	camlCode__$2a$7c_1039,@function
	.size	camlCode__$2a$7c_1039,.-camlCode__$2a$7c_1039
	.text
	.align	16
	.globl	camlCode__$2b$7c_1042
camlCode__$2b$7c_1042:
	subl	$8, %esp
.L109:
	movl	%eax, %ecx
.L110:	movl	caml_young_ptr, %eax
	subl	$28, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L111
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	(%ecx)
	faddl	(%ebx)
	fstpl	(%eax)
	fldl	8(%ecx)
	faddl	8(%ebx)
	fstpl	8(%eax)
	fldl	16(%ecx)
	faddl	16(%ebx)
	fstpl	16(%eax)
	addl	$8, %esp
	ret
.L111:	call	caml_call_gc
.L112:	jmp	.L110
	.type	camlCode__$2b$7c_1042,@function
	.size	camlCode__$2b$7c_1042,.-camlCode__$2b$7c_1042
	.text
	.align	16
	.globl	camlCode__$2d$7c_1045
camlCode__$2d$7c_1045:
	subl	$8, %esp
.L113:
	movl	%eax, %ecx
.L114:	movl	caml_young_ptr, %eax
	subl	$28, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L115
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	(%ecx)
	fsubl	(%ebx)
	fstpl	(%eax)
	fldl	8(%ecx)
	fsubl	8(%ebx)
	fstpl	8(%eax)
	fldl	16(%ecx)
	fsubl	16(%ebx)
	fstpl	16(%eax)
	addl	$8, %esp
	ret
.L115:	call	caml_call_gc
.L116:	jmp	.L114
	.type	camlCode__$2d$7c_1045,@function
	.size	camlCode__$2d$7c_1045,.-camlCode__$2d$7c_1045
	.text
	.align	16
	.globl	camlCode__dot_1048
camlCode__dot_1048:
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
	fldl	8(%ecx)
	fmull	8(%ebx)
	fldl	(%ecx)
	fmull	(%ebx)
	faddp	%st, %st(1)
	fldl	16(%ecx)
	fmull	16(%ebx)
	faddp	%st, %st(1)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L119:	call	caml_call_gc
.L120:	jmp	.L118
	.type	camlCode__dot_1048,@function
	.size	camlCode__dot_1048,.-camlCode__dot_1048
	.text
	.align	16
	.globl	camlCode__length_1051
camlCode__length_1051:
	subl	$8, %esp
.L121:
	fldl	8(%eax)
	fmull	8(%eax)
	fldl	(%eax)
	fmull	(%eax)
	faddp	%st, %st(1)
	fldl	16(%eax)
	fmull	16(%eax)
	faddp	%st, %st(1)
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	0(%esp)
.L122:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L123
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	0(%esp)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L123:	call	caml_call_gc
.L124:	jmp	.L122
	.type	camlCode__length_1051,@function
	.size	camlCode__length_1051,.-camlCode__length_1051
	.text
	.align	16
	.globl	camlCode__unitise_1053
camlCode__unitise_1053:
	subl	$8, %esp
.L125:
	movl	%eax, %ebx
	fldl	8(%ebx)
	fmull	8(%ebx)
	fldl	(%ebx)
	fmull	(%ebx)
	faddp	%st, %st(1)
	fldl	16(%ebx)
	fmull	16(%ebx)
	faddp	%st, %st(1)
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	0(%esp)
	fld1
	fdivl	0(%esp)
	fstpl	0(%esp)
.L126:	movl	caml_young_ptr, %eax
	subl	$28, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L127
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	0(%esp)
	fmull	(%ebx)
	fstpl	(%eax)
	fldl	0(%esp)
	fmull	8(%ebx)
	fstpl	8(%eax)
	fldl	0(%esp)
	fmull	16(%ebx)
	fstpl	16(%eax)
	addl	$8, %esp
	ret
.L127:	call	caml_call_gc
.L128:	jmp	.L126
	.type	camlCode__unitise_1053,@function
	.size	camlCode__unitise_1053,.-camlCode__unitise_1053
	.text
	.align	16
	.globl	camlCode__ray_sphere_1055
camlCode__ray_sphere_1055:
	subl	$24, %esp
.L132:
	movl	%eax, %esi
.L133:	movl	caml_young_ptr, %eax
	subl	$28, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L134
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	(%ecx)
	fsubl	(%esi)
	fstpl	(%eax)
	fldl	8(%ecx)
	fsubl	8(%esi)
	fstpl	8(%eax)
	fldl	16(%ecx)
	fsubl	16(%esi)
	fstpl	16(%eax)
	fldl	8(%eax)
	fmull	8(%ebx)
	fldl	(%eax)
	fmull	(%ebx)
	faddp	%st, %st(1)
	fldl	16(%eax)
	fmull	16(%ebx)
	faddp	%st, %st(1)
	fstpl	16(%esp)
	fldl	8(%eax)
	fmull	8(%eax)
	fldl	(%eax)
	fmull	(%eax)
	faddp	%st, %st(1)
	fldl	16(%eax)
	fmull	16(%eax)
	faddp	%st, %st(1)
	fldl	16(%esp)
	fmull	16(%esp)
	fsubp	%st, %st(1)
	fldl	(%edx)
	fmull	(%edx)
	faddp	%st, %st(1)
	fstpl	0(%esp)
	fldz
	fcompl	0(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L131
	movl	camlPervasives + 36, %eax
	addl	$24, %esp
	ret
	.align	16
.L131:
	pushl	4(%esp)
	pushl	4(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	0(%esp)
	fldl	16(%esp)
	fsubl	0(%esp)
	fstpl	8(%esp)
.L136:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L137
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	fldl	8(%esp)
	fstpl	(%ecx)
	fldl	16(%esp)
	faddl	0(%esp)
	fstpl	0(%esp)
	leal	12(%ecx), %ebx
	movl	$2301, -4(%ebx)
	fldl	0(%esp)
	fstpl	(%ebx)
	fldz
	fcompl	0(%esp)
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L129
	fldz
	fcompl	8(%esp)
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L130
	movl	%ecx, %eax
	addl	$24, %esp
	ret
	.align	16
.L130:
	movl	%ebx, %eax
	addl	$24, %esp
	ret
	.align	16
.L129:
	movl	camlPervasives + 36, %eax
	addl	$24, %esp
	ret
.L137:	call	caml_call_gc
.L138:	jmp	.L136
.L134:	call	caml_call_gc
.L135:	jmp	.L133
	.type	camlCode__ray_sphere_1055,@function
	.size	camlCode__ray_sphere_1055,.-camlCode__ray_sphere_1055
	.text
	.align	16
	.globl	camlCode__intersects_1067
camlCode__intersects_1067:
	subl	$12, %esp
.L140:
	cmpl	$1, %edx
	je	.L139
	movl	%edx, 0(%esp)
	movl	%ebx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	(%edx), %edx
	call	camlCode__intersect_1066
.L141:
	movl	%eax, %ecx
	movl	0(%esp), %eax
	movl	4(%eax), %edx
	movl	4(%esp), %eax
	movl	8(%esp), %ebx
	jmp	.L140
	.align	16
.L139:
	movl	%ecx, %eax
	addl	$12, %esp
	ret
	.type	camlCode__intersects_1067,@function
	.size	camlCode__intersects_1067,.-camlCode__intersects_1067
	.text
	.align	16
	.globl	camlCode__intersect_1066
camlCode__intersect_1066:
	subl	$36, %esp
.L147:
	movl	%eax, 0(%esp)
	movl	%ecx, 4(%esp)
	movl	8(%edx), %eax
	movl	%eax, 8(%esp)
	movl	(%edx), %edi
	movl	4(%edx), %ecx
.L148:	movl	caml_young_ptr, %eax
	subl	$28, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L149
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	(%edi)
	movl	0(%esp), %esi
	fsubl	(%esi)
	fstpl	(%eax)
	fldl	8(%edi)
	fsubl	8(%esi)
	fstpl	8(%eax)
	fldl	16(%edi)
	fsubl	16(%esi)
	fstpl	16(%eax)
	fldl	8(%eax)
	fmull	8(%ebx)
	fldl	(%eax)
	fmull	(%ebx)
	faddp	%st, %st(1)
	fldl	16(%eax)
	fmull	16(%ebx)
	faddp	%st, %st(1)
	fstpl	28(%esp)
	fldl	8(%eax)
	fmull	8(%eax)
	fldl	(%eax)
	fmull	(%eax)
	faddp	%st, %st(1)
	fldl	16(%eax)
	fmull	16(%eax)
	faddp	%st, %st(1)
	fldl	28(%esp)
	fmull	28(%esp)
	fsubp	%st, %st(1)
	fldl	(%ecx)
	fmull	(%ecx)
	faddp	%st, %st(1)
	fstpl	12(%esp)
	fldz
	fcompl	12(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L146
	movl	camlPervasives + 36, %ebp
	jmp	.L144
	.align	16
.L146:
	pushl	16(%esp)
	pushl	16(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	12(%esp)
	fldl	28(%esp)
	fsubl	12(%esp)
	fstpl	20(%esp)
.L151:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L152
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	fldl	20(%esp)
	fstpl	(%ecx)
	fldl	28(%esp)
	faddl	12(%esp)
	fstpl	12(%esp)
	leal	12(%ecx), %ebp
	movl	$2301, -4(%ebp)
	fldl	12(%esp)
	fstpl	(%ebp)
	fldz
	fcompl	12(%esp)
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L145
	fldz
	fcompl	20(%esp)
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L144
	movl	%ecx, %ebp
	jmp	.L144
	.align	16
.L145:
	movl	camlPervasives + 36, %ebp
.L144:
	movl	4(%esp), %ecx
	movl	(%ecx), %eax
	fldl	(%eax)
	fldl	(%ebp)
	fcompp
	fnstsw	%ax
	andb	$5, %ah
	jne	.L143
	movl	%ecx, %eax
	addl	$36, %esp
	ret
	.align	16
.L143:
	cmpl	$1, 8(%esp)
	je	.L142
	movl	%esi, %eax
	movl	8(%esp), %edx
	addl	$36, %esp
	jmp	camlCode__intersects_1067
	.align	16
.L142:
.L154:	movl	caml_young_ptr, %eax
	subl	$84, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L155
	leal	4(%eax), %ecx
	movl	$6398, -4(%ecx)
	fldl	(%ebp)
	fmull	(%ebx)
	fstpl	(%ecx)
	fldl	(%ebp)
	fmull	8(%ebx)
	fstpl	8(%ecx)
	fldl	(%ebp)
	fmull	16(%ebx)
	fstpl	16(%ecx)
	leal	28(%ecx), %eax
	movl	$6398, -4(%eax)
	fldl	(%esi)
	faddl	(%ecx)
	fstpl	(%eax)
	fldl	8(%esi)
	faddl	8(%ecx)
	fstpl	8(%eax)
	fldl	16(%esi)
	faddl	16(%ecx)
	fstpl	16(%eax)
	leal	56(%ecx), %ebx
	movl	$6398, -4(%ebx)
	fldl	(%eax)
	fsubl	(%edi)
	fstpl	(%ebx)
	fldl	8(%eax)
	fsubl	8(%edi)
	fstpl	8(%ebx)
	fldl	16(%eax)
	fsubl	16(%edi)
	fstpl	16(%ebx)
	fldl	8(%ebx)
	fmull	8(%ebx)
	fldl	(%ebx)
	fmull	(%ebx)
	faddp	%st, %st(1)
	fldl	16(%ebx)
	fmull	16(%ebx)
	faddp	%st, %st(1)
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	12(%esp)
	fld1
	fdivl	12(%esp)
	fstpl	12(%esp)
.L157:	movl	caml_young_ptr, %eax
	subl	$40, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L158
	leal	4(%eax), %ecx
	movl	$6398, -4(%ecx)
	fldl	12(%esp)
	fmull	(%ebx)
	fstpl	(%ecx)
	fldl	12(%esp)
	fmull	8(%ebx)
	fstpl	8(%ecx)
	fldl	12(%esp)
	fmull	16(%ebx)
	fstpl	16(%ecx)
	leal	28(%ecx), %eax
	movl	$2048, -4(%eax)
	movl	%ebp, (%eax)
	movl	%ecx, 4(%eax)
	addl	$36, %esp
	ret
.L158:	call	caml_call_gc
.L159:	jmp	.L157
.L155:	call	caml_call_gc
.L156:	jmp	.L154
.L152:	call	caml_call_gc
.L153:	jmp	.L151
.L149:	call	caml_call_gc
.L150:	jmp	.L148
	.type	camlCode__intersect_1066,@function
	.size	camlCode__intersect_1066,.-camlCode__intersect_1066
	.text
	.align	16
	.globl	camlCode__ray_trace_1085
camlCode__ray_trace_1085:
	subl	$20, %esp
.L162:
	movl	%eax, %esi
	movl	%esi, 0(%esp)
	movl	%ebx, %edx
	movl	%edx, 4(%esp)
.L163:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L164
	leal	4(%eax), %ecx
	movl	$2048, -4(%ecx)
	movl	camlPervasives + 36, %eax
	movl	%eax, (%ecx)
	movl	camlCode + 4, %eax
	movl	%eax, 4(%ecx)
	movl	camlCode + 4, %eax
	movl	%esi, %ebx
	call	camlCode__intersect_1066
.L166:
	movl	%eax, %esi
	movl	4(%esi), %ebx
	movl	camlCode + 44, %edx
.L167:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L168
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	fldl	8(%ebx)
	fmull	8(%edx)
	fldl	(%ebx)
	fmull	(%edx)
	faddp	%st, %st(1)
	fldl	16(%ebx)
	fmull	16(%edx)
	faddp	%st, %st(1)
	fstpl	(%ecx)
	fldz
	fldl	(%ecx)
	fcompp
	fnstsw	%ax
	andb	$69, %ah
	decb	%ah
	cmpb	$64, %ah
	jae	.L161
	movl	$camlCode__20, %eax
	addl	$20, %esp
	ret
	.align	16
.L161:
	movl	%ecx, 8(%esp)
	movl	camlPervasives + 56, %eax
	pushl	4(%eax)
	pushl	(%eax)
	call	sqrt
	addl	$8, %esp
	fstpl	12(%esp)
.L170:	movl	caml_young_ptr, %eax
	subl	$96, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L171
	leal	4(%eax), %edx
	movl	$6398, -4(%edx)
	fldl	12(%esp)
	fmull	(%ebx)
	fstpl	(%edx)
	fldl	12(%esp)
	fmull	8(%ebx)
	fstpl	8(%edx)
	fldl	12(%esp)
	fmull	16(%ebx)
	fstpl	16(%edx)
	movl	(%esi), %ecx
	leal	28(%edx), %ebx
	movl	$6398, -4(%ebx)
	fldl	(%ecx)
	movl	0(%esp), %eax
	fmull	(%eax)
	fstpl	(%ebx)
	fldl	(%ecx)
	fmull	8(%eax)
	fstpl	8(%ebx)
	fldl	(%ecx)
	fmull	16(%eax)
	fstpl	16(%ebx)
	leal	56(%edx), %eax
	movl	$6398, -4(%eax)
	fldl	(%ebx)
	faddl	(%edx)
	fstpl	(%eax)
	fldl	8(%ebx)
	faddl	8(%edx)
	fstpl	8(%eax)
	fldl	16(%ebx)
	faddl	16(%edx)
	fstpl	16(%eax)
	leal	84(%edx), %ecx
	movl	$2048, -4(%ecx)
	movl	camlPervasives + 36, %ebx
	movl	%ebx, (%ecx)
	movl	camlCode + 4, %ebx
	movl	%ebx, 4(%ecx)
	movl	camlCode + 44, %ebx
	movl	4(%esp), %edx
	call	camlCode__intersect_1066
.L173:
	movl	(%eax), %eax
	fldl	(%eax)
	fstpl	12(%esp)
	movl	camlPervasives + 36, %eax
	fldl	(%eax)
	fcompl	12(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L160
	movl	$camlCode__19, %eax
	addl	$20, %esp
	ret
	.align	16
.L160:
	movl	8(%esp), %eax
	addl	$20, %esp
	ret
.L171:	call	caml_call_gc
.L172:	jmp	.L170
.L168:	call	caml_call_gc
.L169:	jmp	.L167
.L164:	call	caml_call_gc
.L165:	jmp	.L163
	.type	camlCode__ray_trace_1085,@function
	.size	camlCode__ray_trace_1085,.-camlCode__ray_trace_1085
	.text
	.align	16
	.globl	camlCode__create_1092
camlCode__create_1092:
	subl	$40, %esp
.L175:
	movl	%eax, %edi
	movl	%ecx, %esi
.L176:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L177
	leal	4(%eax), %eax
	movl	$3072, -4(%eax)
	movl	%ebx, (%eax)
	movl	%esi, 4(%eax)
	movl	$1, 8(%eax)
	cmpl	$3, %edi
	jne	.L174
	addl	$40, %esp
	ret
	.align	16
.L174:
	movl	%eax, 12(%esp)
	movl	%edx, 0(%esp)
	movl	%esi, 16(%esp)
	movl	%ebx, 20(%esp)
	fldl	.L179
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	24(%esp)
	fldl	.L180
	fmull	(%esi)
	fdivl	24(%esp)
	fstpl	24(%esp)
.L181:	movl	caml_young_ptr, %eax
	subl	$116, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L182
	leal	4(%eax), %edx
	movl	$2301, -4(%edx)
	fldl	24(%esp)
	fstpl	(%edx)
	leal	12(%edx), %eax
	movl	%eax, 8(%esp)
	movl	$8439, -4(%eax)
	movl	$caml_curry2, (%eax)
	movl	$5, 4(%eax)
	movl	$camlCode__aux_1098, 8(%eax)
	movl	0(%esp), %ecx
	movl	%ecx, 12(%eax)
	movl	%edi, 16(%eax)
	movl	%ebx, 20(%eax)
	movl	%esi, 24(%eax)
	movl	%edx, 28(%eax)
	leal	48(%edx), %ecx
	movl	$2301, -4(%ecx)
	movl	24(%eax), %ebx
	fldl	.L184
	fmull	(%ebx)
	fstpl	(%ecx)
	leal	60(%edx), %edi
	movl	$6398, -4(%edi)
	fldl	24(%esp)
	fstpl	(%edi)
	movl	28(%eax), %ebx
	fldl	(%ebx)
	fstpl	8(%edi)
	fldl	24(%esp)
	fstpl	16(%edi)
	movl	20(%eax), %esi
	leal	88(%edx), %ebx
	movl	$6398, -4(%ebx)
	fldl	(%esi)
	faddl	(%edi)
	fstpl	(%ebx)
	fldl	8(%esi)
	faddl	8(%edi)
	fstpl	8(%ebx)
	fldl	16(%esi)
	faddl	16(%edi)
	fstpl	16(%ebx)
	movl	12(%eax), %edx
	movl	16(%eax), %eax
	addl	$-2, %eax
	call	camlCode__create_1092
.L185:
	movl	%eax, %ebx
.L186:	movl	caml_young_ptr, %eax
	subl	$80, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L187
	leal	4(%eax), %eax
	movl	%eax, 0(%esp)
	movl	$2048, -4(%eax)
	movl	%ebx, (%eax)
	movl	$1, 4(%eax)
	fldl	24(%esp)
	fchs
	fstpl	32(%esp)
	leal	12(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	8(%esp), %esi
	movl	24(%esi), %ebx
	fldl	.L189
	fmull	(%ebx)
	fstpl	(%ecx)
	leal	24(%eax), %edi
	movl	$6398, -4(%edi)
	fldl	32(%esp)
	fstpl	(%edi)
	movl	28(%esi), %ebx
	fldl	(%ebx)
	fstpl	8(%edi)
	fldl	24(%esp)
	fstpl	16(%edi)
	movl	20(%esi), %edx
	leal	52(%eax), %ebx
	movl	$6398, -4(%ebx)
	fldl	(%edx)
	faddl	(%edi)
	fstpl	(%ebx)
	fldl	8(%edx)
	faddl	8(%edi)
	fstpl	8(%ebx)
	fldl	16(%edx)
	faddl	16(%edi)
	fstpl	16(%ebx)
	movl	12(%esi), %edx
	movl	16(%esi), %eax
	addl	$-2, %eax
	call	camlCode__create_1092
.L190:
	movl	%eax, %ebx
.L191:	movl	caml_young_ptr, %eax
	subl	$80, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L192
	leal	4(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$2048, -4(%eax)
	movl	%ebx, (%eax)
	movl	0(%esp), %ebx
	movl	%ebx, 4(%eax)
	fldl	24(%esp)
	fchs
	fstpl	32(%esp)
	leal	12(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	8(%esp), %esi
	movl	24(%esi), %ebx
	fldl	.L194
	fmull	(%ebx)
	fstpl	(%ecx)
	leal	24(%eax), %edi
	movl	$6398, -4(%edi)
	fldl	24(%esp)
	fstpl	(%edi)
	movl	28(%esi), %ebx
	fldl	(%ebx)
	fstpl	8(%edi)
	fldl	32(%esp)
	fstpl	16(%edi)
	movl	20(%esi), %edx
	leal	52(%eax), %ebx
	movl	$6398, -4(%ebx)
	fldl	(%edx)
	faddl	(%edi)
	fstpl	(%ebx)
	fldl	8(%edx)
	faddl	8(%edi)
	fstpl	8(%ebx)
	fldl	16(%edx)
	faddl	16(%edi)
	fstpl	16(%ebx)
	movl	12(%esi), %edx
	movl	16(%esi), %eax
	addl	$-2, %eax
	call	camlCode__create_1092
.L195:
	movl	%eax, %ebx
.L196:	movl	caml_young_ptr, %eax
	subl	$80, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L197
	leal	4(%eax), %eax
	movl	%eax, 0(%esp)
	movl	$2048, -4(%eax)
	movl	%ebx, (%eax)
	movl	4(%esp), %ebx
	movl	%ebx, 4(%eax)
	fldl	24(%esp)
	fchs
	fstpl	32(%esp)
	fldl	24(%esp)
	fchs
	fstpl	24(%esp)
	leal	12(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	8(%esp), %esi
	movl	24(%esi), %ebx
	fldl	.L199
	fmull	(%ebx)
	fstpl	(%ecx)
	leal	24(%eax), %edi
	movl	$6398, -4(%edi)
	fldl	24(%esp)
	fstpl	(%edi)
	movl	28(%esi), %ebx
	fldl	(%ebx)
	fstpl	8(%edi)
	fldl	32(%esp)
	fstpl	16(%edi)
	movl	20(%esi), %edx
	leal	52(%eax), %ebx
	movl	$6398, -4(%ebx)
	fldl	(%edx)
	faddl	(%edi)
	fstpl	(%ebx)
	fldl	8(%edx)
	faddl	8(%edi)
	fstpl	8(%ebx)
	fldl	16(%edx)
	faddl	16(%edi)
	fstpl	16(%ebx)
	movl	12(%esi), %edx
	movl	16(%esi), %eax
	addl	$-2, %eax
	call	camlCode__create_1092
.L200:
	movl	%eax, %ecx
.L201:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L202
	leal	4(%eax), %ebx
	movl	$2048, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	0(%esp), %eax
	movl	%eax, 4(%ebx)
	leal	12(%ebx), %edx
	movl	$2048, -4(%edx)
	movl	12(%esp), %eax
	movl	%eax, (%edx)
	movl	%ebx, 4(%edx)
	leal	24(%ebx), %ecx
	movl	$2301, -4(%ecx)
	fldl	.L204
	movl	16(%esp), %eax
	fmull	(%eax)
	fstpl	(%ecx)
	leal	36(%ebx), %eax
	movl	$3072, -4(%eax)
	movl	20(%esp), %ebx
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	movl	%edx, 8(%eax)
	addl	$40, %esp
	ret
.L202:	call	caml_call_gc
.L203:	jmp	.L201
.L197:	call	caml_call_gc
.L198:	jmp	.L196
.L192:	call	caml_call_gc
.L193:	jmp	.L191
.L187:	call	caml_call_gc
.L188:	jmp	.L186
.L182:	call	caml_call_gc
.L183:	jmp	.L181
.L177:	call	caml_call_gc
.L178:	jmp	.L176
	.data
.L204:	.long	0x0, 0x40080000
	.data
.L199:	.long	0x0, 0x3fe00000
	.data
.L194:	.long	0x0, 0x3fe00000
	.data
.L189:	.long	0x0, 0x3fe00000
	.data
.L184:	.long	0x0, 0x3fe00000
	.data
.L180:	.long	0x0, 0x40080000
	.data
.L179:	.long	0x0, 0x40280000
	.type	camlCode__create_1092,@function
	.size	camlCode__create_1092,.-camlCode__create_1092
	.text
	.align	16
	.globl	camlCode__aux_1109
camlCode__aux_1109:
	subl	$8, %esp
.L205:
	movl	%eax, %ecx
.L206:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L207
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
	fldl	.L209
	movl	camlCode + 64, %ebx
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
.L207:	call	caml_call_gc
.L208:	jmp	.L206
	.data
.L209:	.long	0x0, 0x40000000
	.type	camlCode__aux_1109,@function
	.size	camlCode__aux_1109,.-camlCode__aux_1109
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$36, %esp
.L220:
	movl	camlPervasives + 56, %eax
	pushl	4(%eax)
	pushl	(%eax)
	call	sqrt
	addl	$8, %esp
	fstpl	20(%esp)
	call	caml_alloc2
.L221:
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	20(%esp)
	fstpl	(%eax)
	movl	%eax, camlCode
	movl	$camlCode__18, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__17, %eax
	movl	%eax, camlCode + 8
	movl	$camlCode__16, %eax
	movl	%eax, camlCode + 12
	movl	$camlCode__15, %eax
	movl	%eax, camlCode + 16
	movl	$camlCode__14, %eax
	movl	%eax, camlCode + 20
	movl	$camlCode__13, %eax
	movl	%eax, camlCode + 24
	movl	$camlCode__12, %eax
	movl	%eax, camlCode + 28
	movl	$camlCode__11, %eax
	movl	%eax, camlCode + 32
	movl	$camlCode__10, %eax
	movl	%eax, camlCode + 36
	addl	$16, %eax
	movl	%eax, camlCode + 40
	movl	$camlCode__9, %ebx
	fldl	8(%ebx)
	fmull	8(%ebx)
	fldl	(%ebx)
	fmull	(%ebx)
	faddp	%st, %st(1)
	fldl	16(%ebx)
	fmull	16(%ebx)
	faddp	%st, %st(1)
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	20(%esp)
	fld1
	fdivl	20(%esp)
	fstpl	20(%esp)
	movl	$28, %eax
	call	caml_allocN
.L222:
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	20(%esp)
	fmull	(%ebx)
	fstpl	(%eax)
	fldl	20(%esp)
	fmull	8(%ebx)
	fstpl	8(%eax)
	fldl	20(%esp)
	fmull	16(%ebx)
	fstpl	16(%eax)
	movl	%eax, camlCode + 44
	movl	$9, camlCode + 48
	movl	$camlCode__8, %eax
	movl	%eax, camlCode + 52
	movl	$camlCode__7, %eax
	movl	%eax, camlCode + 56
	call	.L219
	movl	$camlCode__6, %ebx
	jmp	.L218
.L219:
	pushl	caml_exception_pointer
	movl	%esp, caml_exception_pointer
	movl	camlSys, %ebx
	movl	-4(%ebx), %eax
	shrl	$9, %eax
	cmpl	$5, %eax
	jbe	.L223
	movl	8(%ebx), %eax
	pushl	%eax
	movl	$caml_int_of_string, %eax
	call	caml_c_call
.L224:
	addl	$4, %esp
	movl	%eax, 8(%esp)
	movl	camlSys, %ebx
	movl	-4(%ebx), %eax
	shrl	$9, %eax
	cmpl	$3, %eax
	jbe	.L223
	movl	4(%ebx), %eax
	pushl	%eax
	movl	$caml_int_of_string, %eax
	call	caml_c_call
.L225:
	addl	$4, %esp
	movl	%eax, %ecx
	call	caml_alloc2
.L226:
	leal	4(%eax), %ebx
	movl	$2048, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	8(%esp), %eax
	movl	%eax, 4(%ebx)
	popl	caml_exception_pointer
	addl	$4, %esp
.L218:
	movl	(%ebx), %eax
	movl	%eax, camlCode + 60
	movl	4(%ebx), %eax
	movl	%eax, camlCode + 64
	movl	camlCode + 56, %edx
	movl	$camlCode__5, %ecx
	movl	$camlCode__4, %ebx
	movl	camlCode + 60, %eax
	call	camlCode__create_1092
.L227:
	movl	%eax, camlCode + 68
	movl	$camlCode__3, %eax
	call	camlPrintf__printf_1393
.L228:
	movl	%eax, %ecx
	movl	camlCode + 64, %ebx
	movl	camlCode + 64, %eax
	call	caml_apply2
.L229:
	movl	camlCode + 64, %eax
	addl	$-2, %eax
	cmpl	$1, %eax
	jl	.L210
	movl	%eax, 12(%esp)
.L211:
	movl	$1, %ebx
	movl	%ebx, 8(%esp)
	movl	camlCode + 64, %eax
	addl	$-2, %eax
	movl	%eax, 4(%esp)
	cmpl	%eax, %ebx
	jg	.L212
.L213:
	fldz
	fstpl	20(%esp)
	movl	$1, %eax
	movl	%eax, 0(%esp)
	cmpl	$7, %eax
	jg	.L214
.L215:
	movl	$1, %ecx
	movl	%ecx, 16(%esp)
	cmpl	$7, %ecx
	jg	.L216
.L217:
	movl	$camlCode__2, %eax
	movl	$28, %eax
	call	caml_allocN
.L230:
	leal	4(%eax), %ebx
	movl	$6398, -4(%ebx)
	movl	$4, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	movl	0(%esp), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	fldl	.L231
	movl	camlCode + 64, %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	movl	8(%esp), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fsubp	%st, %st(1)
	faddp	%st, %st(1)
	fstpl	(%ebx)
	movl	$4, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	sarl	$1, %ecx
	pushl	%ecx
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	fldl	.L232
	movl	camlCode + 64, %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	movl	12(%esp), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fsubp	%st, %st(1)
	faddp	%st, %st(1)
	fstpl	8(%ebx)
	movl	camlCode + 64, %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	16(%ebx)
	fldl	8(%ebx)
	fmull	8(%ebx)
	fldl	(%ebx)
	fmull	(%ebx)
	faddp	%st, %st(1)
	fldl	16(%ebx)
	fmull	16(%ebx)
	faddp	%st, %st(1)
	subl	$8, %esp
	fstpl	0(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	28(%esp)
	fld1
	fdivl	28(%esp)
	fstpl	28(%esp)
	movl	$28, %eax
	call	caml_allocN
.L233:
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	28(%esp)
	fmull	(%ebx)
	fstpl	(%eax)
	fldl	28(%esp)
	fmull	8(%ebx)
	fstpl	8(%eax)
	fldl	28(%esp)
	fmull	16(%ebx)
	fstpl	16(%eax)
	movl	camlCode + 68, %ebx
	call	camlCode__ray_trace_1085
.L234:
	fldl	(%eax)
	fstpl	28(%esp)
	fldl	20(%esp)
	faddl	28(%esp)
	fstpl	20(%esp)
	movl	16(%esp), %ecx
	movl	%ecx, %eax
	addl	$2, %ecx
	movl	%ecx, 16(%esp)
	cmpl	$7, %eax
	jne	.L217
.L216:
	movl	0(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 0(%esp)
	cmpl	$7, %ebx
	jne	.L215
.L214:
	fldl	.L235
	fmull	20(%esp)
	movl	$16, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fdivrp	%st, %st(1)
	fldl	.L236
	faddp	%st, %st(1)
	fstpl	20(%esp)
	movl	$camlCode__1, %eax
	call	camlPrintf__printf_1393
.L237:
	movl	%eax, 0(%esp)
	fldl	20(%esp)
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
.L238:
	movl	0(%esp), %ebx
	movl	(%ebx), %ecx
	call	*%ecx
.L239:
	movl	8(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 8(%esp)
	movl	4(%esp), %eax
	cmpl	%eax, %ebx
	jne	.L213
.L212:
	movl	12(%esp), %eax
	movl	%eax, %ebx
	subl	$2, %eax
	movl	%eax, 12(%esp)
	cmpl	$1, %ebx
	jne	.L211
.L210:
	movl	$1, %eax
	addl	$36, %esp
	ret
.L223:	call	caml_ml_array_bound_error
	.data
.L236:	.long	0x0, 0x3fe00000
	.data
.L235:	.long	0x0, 0x406fe000
	.data
.L232:	.long	0x0, 0x40000000
	.data
.L231:	.long	0x0, 0x40000000
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
	.long	44
	.long	.L239
	.word	40
	.word	0
	.align	4
	.long	.L238
	.word	40
	.word	1
	.word	0
	.align	4
	.long	.L237
	.word	40
	.word	0
	.align	4
	.long	.L234
	.word	40
	.word	0
	.align	4
	.long	.L233
	.word	40
	.word	1
	.word	3
	.align	4
	.long	.L230
	.word	40
	.word	0
	.align	4
	.long	.L229
	.word	40
	.word	0
	.align	4
	.long	.L228
	.word	40
	.word	0
	.align	4
	.long	.L227
	.word	40
	.word	0
	.align	4
	.long	.L226
	.word	48
	.word	2
	.word	8
	.word	5
	.align	4
	.long	.L225
	.word	52
	.word	1
	.word	12
	.align	4
	.long	.L224
	.word	52
	.word	0
	.align	4
	.long	.L222
	.word	40
	.word	1
	.word	3
	.align	4
	.long	.L221
	.word	40
	.word	0
	.align	4
	.long	.L208
	.word	12
	.word	2
	.word	3
	.word	5
	.align	4
	.long	.L203
	.word	44
	.word	5
	.word	0
	.word	12
	.word	16
	.word	20
	.word	5
	.align	4
	.long	.L200
	.word	44
	.word	4
	.word	0
	.word	12
	.word	16
	.word	20
	.align	4
	.long	.L198
	.word	44
	.word	6
	.word	4
	.word	8
	.word	12
	.word	16
	.word	20
	.word	3
	.align	4
	.long	.L195
	.word	44
	.word	5
	.word	4
	.word	8
	.word	12
	.word	16
	.word	20
	.align	4
	.long	.L193
	.word	44
	.word	6
	.word	0
	.word	8
	.word	12
	.word	16
	.word	20
	.word	3
	.align	4
	.long	.L190
	.word	44
	.word	5
	.word	0
	.word	8
	.word	12
	.word	16
	.word	20
	.align	4
	.long	.L188
	.word	44
	.word	5
	.word	8
	.word	12
	.word	16
	.word	20
	.word	3
	.align	4
	.long	.L185
	.word	44
	.word	4
	.word	8
	.word	12
	.word	16
	.word	20
	.align	4
	.long	.L183
	.word	44
	.word	7
	.word	0
	.word	12
	.word	16
	.word	20
	.word	9
	.word	3
	.word	11
	.align	4
	.long	.L178
	.word	44
	.word	4
	.word	7
	.word	9
	.word	3
	.word	11
	.align	4
	.long	.L173
	.word	24
	.word	1
	.word	8
	.align	4
	.long	.L172
	.word	24
	.word	5
	.word	0
	.word	4
	.word	8
	.word	3
	.word	9
	.align	4
	.long	.L169
	.word	24
	.word	5
	.word	0
	.word	4
	.word	7
	.word	3
	.word	9
	.align	4
	.long	.L166
	.word	24
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L165
	.word	24
	.word	4
	.word	0
	.word	4
	.word	7
	.word	9
	.align	4
	.long	.L159
	.word	40
	.word	2
	.word	3
	.word	13
	.align	4
	.long	.L156
	.word	40
	.word	4
	.word	9
	.word	13
	.word	11
	.word	3
	.align	4
	.long	.L153
	.word	40
	.word	5
	.word	9
	.word	4
	.word	11
	.word	8
	.word	3
	.align	4
	.long	.L150
	.word	40
	.word	6
	.word	0
	.word	4
	.word	5
	.word	11
	.word	8
	.word	3
	.align	4
	.long	.L141
	.word	16
	.word	3
	.word	0
	.word	4
	.word	8
	.align	4
	.long	.L138
	.word	28
	.word	0
	.align	4
	.long	.L135
	.word	28
	.word	4
	.word	7
	.word	5
	.word	3
	.word	9
	.align	4
	.long	.L128
	.word	12
	.word	1
	.word	3
	.align	4
	.long	.L124
	.word	12
	.word	0
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
	.word	5
	.align	4
	.long	.L112
	.word	12
	.word	2
	.word	3
	.word	5
	.align	4
	.long	.L108
	.word	12
	.word	2
	.word	3
	.word	5
	.align	4
	.long	.L103
	.word	12
	.word	3
	.word	5
	.word	3
	.word	7
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

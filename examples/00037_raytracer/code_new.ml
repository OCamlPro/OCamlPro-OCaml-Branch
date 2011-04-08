
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
  (let (delta/1031 (caml_sqrt_float (field 14 (global Pervasives!))))
    (setfield_imm 0 (global Code!) delta/1031))
  (let (zero/1039 [|0. 0. 0.|]) (setfield_imm 1 (global Code!) zero/1039))
  (let
    (*|/1040
       (function s/1041 r/1042
         (makearray  (*. s/1041 (floatfield 0 r/1042))
           (*. s/1041 (floatfield 1 r/1042))
           (*. s/1041 (floatfield 2 r/1042)))))
    (setfield_imm 2 (global Code!) *|/1040))
  (let
    (+|/1043
       (function a/1044 b/1045
         (makearray  (+. (floatfield 0 a/1044) (floatfield 0 b/1045))
           (+. (floatfield 1 a/1044) (floatfield 1 b/1045))
           (+. (floatfield 2 a/1044) (floatfield 2 b/1045)))))
    (setfield_imm 3 (global Code!) +|/1043))
  (let
    (-|/1046
       (function a/1047 b/1048
         (makearray  (-. (floatfield 0 a/1047) (floatfield 0 b/1048))
           (-. (floatfield 1 a/1047) (floatfield 1 b/1048))
           (-. (floatfield 2 a/1047) (floatfield 2 b/1048)))))
    (setfield_imm 4 (global Code!) -|/1046))
  (let
    (dot/1049
       (function a/1050 b/1051
         (+.
           (+. (*. (floatfield 0 a/1050) (floatfield 0 b/1051))
             (*. (floatfield 1 a/1050) (floatfield 1 b/1051)))
           (*. (floatfield 2 a/1050) (floatfield 2 b/1051)))))
    (setfield_imm 5 (global Code!) dot/1049))
  (let
    (length/1052
       (function r/1053
         (caml_sqrt_float (apply (field 5 (global Code!)) r/1053 r/1053))))
    (setfield_imm 6 (global Code!) length/1052))
  (let
    (unitise/1054
       (function r/1055
         (apply (field 2 (global Code!))
           (/. 1. (apply (field 6 (global Code!)) r/1055)) r/1055)))
    (setfield_imm 7 (global Code!) unitise/1054))
  (let
    (ray_sphere/1056
       (function orig/1057 dir/1058 center/1059 radius/1060
         (let
           (v/1061 (apply (field 4 (global Code!)) center/1059 orig/1057)
            b/1062 (apply (field 5 (global Code!)) v/1061 dir/1058)
            d2/1063
              (+.
                (-. (*. b/1062 b/1062)
                  (apply (field 5 (global Code!)) v/1061 v/1061))
                (*. radius/1060 radius/1060)))
           (if (<. d2/1063 0.) (field 9 (global Pervasives!))
             (let
               (d/1064 (caml_sqrt_float d2/1063)
                t1/1065 (-. b/1062 d/1064)
                t2/1066 (+. b/1062 d/1064))
               (if (>. t2/1066 0.) (if (>. t1/1065 0.) t1/1065 t2/1066)
                 (field 9 (global Pervasives!))))))))
    (setfield_imm 8 (global Code!) ray_sphere/1056))
  (letrec
    (intersect/1067
       (function orig/1069 dir/1070 hit/1072 param/1141
         (let
           (scene/1075 (field 2 param/1141)
            radius/1074 (field 1 param/1141)
            center/1073 (field 0 param/1141)
            match/1145 (field 1 hit/1072)
            l/1071 (field 0 hit/1072)
            match/1142
              (apply (field 8 (global Code!)) orig/1069 dir/1070 center/1073
                radius/1074)
            match/1143 match/1142
            match/1144 scene/1075)
           (catch
             (catch
               (let (l'/1076 match/1143)
                 (if (>=. l'/1076 l/1071) hit/1072 (exit 18)))
              with (18)
               (if match/1144 (exit 17)
                 (let (l'/1077 match/1143)
                   (makeblock 0 l'/1077
                     (apply (field 7 (global Code!))
                       (apply (field 4 (global Code!))
                         (apply (field 3 (global Code!)) orig/1069
                           (apply (field 2 (global Code!)) l'/1077 dir/1070))
                         center/1073))))))
            with (17)
             (let (scenes/1078 match/1144)
               (apply intersects/1068 orig/1069 dir/1070 hit/1072
                 scenes/1078)))))
      intersects/1068
        (function orig/1079 dir/1080 hit/1081 param/1146
          (if param/1146
            (let
              (scenes/1083 (field 1 param/1146)
               scene/1082 (field 0 param/1146))
              (apply intersects/1068 orig/1079 dir/1080
                (apply intersect/1067 orig/1079 dir/1080 hit/1081 scene/1082)
                scenes/1083))
            hit/1081)))
    (seq (setfield_imm 9 (global Code!) intersect/1067)
      (setfield_imm 10 (global Code!) intersects/1068)))
  (let (light/1084 (apply (field 7 (global Code!)) [|1. 3. -2.|]) ss/1085 4)
    (seq (setfield_imm 11 (global Code!) light/1084)
      (setfield_imm 12 (global Code!) ss/1085)))
  (letrec
    (ray_trace/1086
       (function dir/1087 scene/1088
         (let
           (match/1148
              (apply (field 9 (global Code!)) (field 1 (global Code!))
                dir/1087
                (makeblock 0 (field 9 (global Pervasives!))
                  (field 1 (global Code!)))
                scene/1088)
            n/1090 (field 1 match/1148)
            l/1089 (field 0 match/1148)
            g/1091
              (apply (field 5 (global Code!)) n/1090
                (field 11 (global Code!))))
           (if (<=. g/1091 0.) 0.
             (let
               (p/1092
                  (apply (field 3 (global Code!))
                    (apply (field 2 (global Code!)) l/1089 dir/1087)
                    (apply (field 2 (global Code!))
                      (caml_sqrt_float (field 14 (global Pervasives!)))
                      n/1090)))
               (if
                 (<.
                   (field 0
                     (apply (field 9 (global Code!)) p/1092
                       (field 11 (global Code!))
                       (makeblock 0 (field 9 (global Pervasives!))
                         (field 1 (global Code!)))
                       scene/1088))
                   (field 9 (global Pervasives!)))
                 0. g/1091))))))
    (setfield_imm 13 (global Code!) ray_trace/1086))
  (letrec
    (create/1093
       (function level/1094 c/1095 r/1096
         (let (obj/1097 (makeblock 0 c/1095 r/1096 0a))
           (if (== level/1094 1) obj/1097
             (let
               (a/1098 (/. (*. 3. r/1096) (caml_sqrt_float 12.))
                aux/1099
                  (function x'/1100 z'/1101
                    (apply create/1093 (- level/1094 1)
                      (apply (field 3 (global Code!)) c/1095
                        (makearray  x'/1100 a/1098 z'/1101))
                      (*. 0.5 r/1096))))
               (makeblock 0 c/1095 (*. 3. r/1096)
                 (makeblock 0 obj/1097
                   (makeblock 0 (apply aux/1099 (~. a/1098) (~. a/1098))
                     (makeblock 0 (apply aux/1099 a/1098 (~. a/1098))
                       (makeblock 0 (apply aux/1099 (~. a/1098) a/1098)
                         (makeblock 0 (apply aux/1099 a/1098 a/1098) 0a)))))))))))
    (setfield_imm 14 (global Code!) create/1093))
  (let
    (match/1151
       (try
         (makeblock 0
           (caml_int_of_string (array.get (field 0 (global Sys!)) 1))
           (caml_int_of_string (array.get (field 0 (global Sys!)) 2)))
        with exn/1150 [0: 6 512])
     n/1103 (field 1 match/1151)
     level/1102 (field 0 match/1151))
    (seq (setfield_imm 15 (global Code!) level/1102)
      (setfield_imm 16 (global Code!) n/1103)))
  (let
    (scene/1104
       (apply (field 14 (global Code!)) (field 15 (global Code!))
         [|0. -1. 4.|] 1.))
    (setfield_imm 17 (global Code!) scene/1104))
  (apply (field 1 (global Printf!)) "P5\n%d %d\n255\n"
    (field 16 (global Code!)) (field 16 (global Code!)))
  (for y/1105 (- (field 16 (global Code!)) 1) downto 0
    (for x/1106 0 to (- (field 16 (global Code!)) 1)
      (let (g/1107 (makemutable 0 0.))
        (seq
          (for dx/1108 0 to (- (field 12 (global Code!)) 1)
            (for dy/1109 0 to (- (field 12 (global Code!)) 1)
              (let
                (aux/1110
                   (function x/1111 d/1112
                     (+.
                       (-. (float_of_int x/1111)
                         (/. (float_of_int (field 16 (global Code!))) 2.))
                       (/. (float_of_int d/1112)
                         (float_of_int (field 12 (global Code!))))))
                 dir/1113
                   (apply (field 7 (global Code!))
                     (makearray  (apply aux/1110 x/1106 dx/1108)
                       (apply aux/1110 y/1105 dy/1109)
                       (float_of_int (field 16 (global Code!))))))
                (setfield_ptr 0 g/1107
                  (+. (field 0 g/1107)
                    (apply (field 13 (global Code!)) dir/1113
                      (field 17 (global Code!))))))))
          (let
            (g/1114
               (+. 0.5
                 (/. (*. 255. (field 0 g/1107))
                   (float_of_int
                     (* (field 12 (global Code!)) (field 12 (global Code!)))))))
            (apply (field 1 (global Printf!)) "%c"
              (apply (field 16 (global Pervasives!)) (int_of_float g/1114))))))))
  0a)
[times] TonLambda.optimize: 0.000 s
[times] Closure.intro: 0.000 s
[times] TonSlambda.optimize: 0.008 s
[times] TonClosure.optimize: 0.044 s
[times] TonSlambda.optimize: 0.008 s
[times] Cmmgen.compunit: 0.032 s
[times] Asmgen.compile_phrases: 0.324 s
-dlambda
(seq
  (let (delta/1031 (caml_sqrt_float (field 14 (global Pervasives!))))
    (setfield_imm 0 (global Code!) delta/1031))
  (let (zero/1039 [|0. 0. 0.|]) (setfield_imm 1 (global Code!) zero/1039))
  (let
    (*|/1040
       (function s/1041 r/1042
         (makearray  (*. s/1041 (floatfield 0 r/1042))
           (*. s/1041 (floatfield 1 r/1042))
           (*. s/1041 (floatfield 2 r/1042)))))
    (setfield_imm 2 (global Code!) *|/1040))
  (let
    (+|/1043
       (function a/1044 b/1045
         (makearray  (+. (floatfield 0 a/1044) (floatfield 0 b/1045))
           (+. (floatfield 1 a/1044) (floatfield 1 b/1045))
           (+. (floatfield 2 a/1044) (floatfield 2 b/1045)))))
    (setfield_imm 3 (global Code!) +|/1043))
  (let
    (-|/1046
       (function a/1047 b/1048
         (makearray  (-. (floatfield 0 a/1047) (floatfield 0 b/1048))
           (-. (floatfield 1 a/1047) (floatfield 1 b/1048))
           (-. (floatfield 2 a/1047) (floatfield 2 b/1048)))))
    (setfield_imm 4 (global Code!) -|/1046))
  (let
    (dot/1049
       (function a/1050 b/1051
         (+.
           (+. (*. (floatfield 0 a/1050) (floatfield 0 b/1051))
             (*. (floatfield 1 a/1050) (floatfield 1 b/1051)))
           (*. (floatfield 2 a/1050) (floatfield 2 b/1051)))))
    (setfield_imm 5 (global Code!) dot/1049))
  (let
    (length/1052
       (function r/1053
         (caml_sqrt_float (apply (field 5 (global Code!)) r/1053 r/1053))))
    (setfield_imm 6 (global Code!) length/1052))
  (let
    (unitise/1054
       (function r/1055
         (apply (field 2 (global Code!))
           (/. 1. (apply (field 6 (global Code!)) r/1055)) r/1055)))
    (setfield_imm 7 (global Code!) unitise/1054))
  (let
    (ray_sphere/1056
       (function orig/1057 dir/1058 center/1059 radius/1060
         (let
           (v/1061 (apply (field 4 (global Code!)) center/1059 orig/1057)
            b/1062 (apply (field 5 (global Code!)) v/1061 dir/1058)
            d2/1063
              (+.
                (-. (*. b/1062 b/1062)
                  (apply (field 5 (global Code!)) v/1061 v/1061))
                (*. radius/1060 radius/1060)))
           (if (<. d2/1063 0.) (field 9 (global Pervasives!))
             (let
               (d/1064 (caml_sqrt_float d2/1063)
                t1/1065 (-. b/1062 d/1064)
                t2/1066 (+. b/1062 d/1064))
               (if (>. t2/1066 0.) (if (>. t1/1065 0.) t1/1065 t2/1066)
                 (field 9 (global Pervasives!))))))))
    (setfield_imm 8 (global Code!) ray_sphere/1056))
  (letrec
    (intersect/1067
       (function orig/1069 dir/1070 hit/1072 param/1141
         (let
           (scene/1075 (field 2 param/1141)
            center/1073 (field 0 param/1141)
            match/1142
              (apply (field 8 (global Code!)) orig/1069 dir/1070 center/1073
                (field 1 param/1141)))
           (if (>=. match/1142 (field 0 hit/1072)) hit/1072
             (if scene/1075
               (apply intersects/1068 orig/1069 dir/1070 hit/1072 scene/1075)
               (makeblock 0 match/1142
                 (apply (field 7 (global Code!))
                   (apply (field 4 (global Code!))
                     (apply (field 3 (global Code!)) orig/1069
                       (apply (field 2 (global Code!)) match/1142 dir/1070))
                     center/1073)))))))
      intersects/1068
        (function orig/1079 dir/1080 hit/1081 param/1146
          (if param/1146
            (apply intersects/1068 orig/1079 dir/1080
              (apply intersect/1067 orig/1079 dir/1080 hit/1081
                (field 0 param/1146))
              (field 1 param/1146))
            hit/1081)))
    (seq (setfield_imm 9 (global Code!) intersect/1067)
      (setfield_imm 10 (global Code!) intersects/1068)))
  (let (light/1084 (apply (field 7 (global Code!)) [|1. 3. -2.|]) ss/1085 4)
    (seq (setfield_imm 11 (global Code!) light/1084)
      (setfield_imm 12 (global Code!) ss/1085)))
  (letrec
    (ray_trace/1086
       (function dir/1087 scene/1088
         (let
           (match/1148
              (apply (field 9 (global Code!)) (field 1 (global Code!))
                dir/1087
                (makeblock 0 (field 9 (global Pervasives!))
                  (field 1 (global Code!)))
                scene/1088)
            n/1090 (field 1 match/1148)
            g/1091
              (apply (field 5 (global Code!)) n/1090
                (field 11 (global Code!))))
           (if (<=. g/1091 0.) 0.
             (let
               (p/1092
                  (apply (field 3 (global Code!))
                    (apply (field 2 (global Code!)) (field 0 match/1148)
                      dir/1087)
                    (apply (field 2 (global Code!))
                      (caml_sqrt_float (field 14 (global Pervasives!)))
                      n/1090)))
               (if
                 (<.
                   (field 0
                     (apply (field 9 (global Code!)) p/1092
                       (field 11 (global Code!))
                       (makeblock 0 (field 9 (global Pervasives!))
                         (field 1 (global Code!)))
                       scene/1088))
                   (field 9 (global Pervasives!)))
                 0. g/1091))))))
    (setfield_imm 13 (global Code!) ray_trace/1086))
  (letrec
    (create/1093
       (function level/1094 c/1095 r/1096
         (let (obj/1097 (makeblock 0 c/1095 r/1096 0a))
           (if (== level/1094 1) obj/1097
             (let
               (a/1098 (/. (*. 3. r/1096) (caml_sqrt_float 12.))
                aux/1099
                  (function x'/1100 z'/1101
                    (apply create/1093 (- level/1094 1)
                      (apply (field 3 (global Code!)) c/1095
                        (makearray  x'/1100 a/1098 z'/1101))
                      (*. 0.5 r/1096))))
               (makeblock 0 c/1095 (*. 3. r/1096)
                 (makeblock 0 obj/1097
                   (makeblock 0 (apply aux/1099 (~. a/1098) (~. a/1098))
                     (makeblock 0 (apply aux/1099 a/1098 (~. a/1098))
                       (makeblock 0 (apply aux/1099 (~. a/1098) a/1098)
                         (makeblock 0 (apply aux/1099 a/1098 a/1098) 0a)))))))))))
    (setfield_imm 14 (global Code!) create/1093))
  (let
    (match/1151
       (try
         (makeblock 0
           (caml_int_of_string (array.get (field 0 (global Sys!)) 1))
           (caml_int_of_string (array.get (field 0 (global Sys!)) 2)))
        with exn/1150 [0: 6 512]))
    (seq (setfield_imm 15 (global Code!) (field 0 match/1151))
      (setfield_imm 16 (global Code!) (field 1 match/1151))))
  (let
    (scene/1104
       (apply (field 14 (global Code!)) (field 15 (global Code!))
         [|0. -1. 4.|] 1.))
    (setfield_imm 17 (global Code!) scene/1104))
  (apply (field 1 (global Printf!)) "P5\n%d %d\n255\n"
    (field 16 (global Code!)) (field 16 (global Code!)))
  (for y/1105 (- (field 16 (global Code!)) 1) downto 0
    (for x/1106 0 to (- (field 16 (global Code!)) 1)
      (let (g/1107 0.)
        (seq
          (for dx/1108 0 to (- (field 12 (global Code!)) 1)
            (for dy/1109 0 to (- (field 12 (global Code!)) 1)
              (let
                (aux/1110
                   (function x/1111 d/1112
                     (+.
                       (-. (float_of_int x/1111)
                         (/. (float_of_int (field 16 (global Code!))) 2.))
                       (/. (float_of_int d/1112)
                         (float_of_int (field 12 (global Code!))))))
                 dir/1113
                   (apply (field 7 (global Code!))
                     (makearray  (apply aux/1110 x/1106 dx/1108)
                       (apply aux/1110 y/1105 dy/1109)
                       (float_of_int (field 16 (global Code!))))))
                (assign g/1107
                  (+. g/1107
                    (apply (field 13 (global Code!)) dir/1113
                      (field 17 (global Code!))))))))
          (let
            (g/1114
               (+. 0.5
                 (/. (*. 255. g/1107)
                   (float_of_int
                     (* (field 12 (global Code!)) (field 12 (global Code!)))))))
            (apply (field 1 (global Printf!)) "%c"
              (apply (field 16 (global Pervasives!)) (int_of_float g/1114))))))))
  0a)
checking tailcall on create/1093
checking tailcall on ray_trace/1086
stats_rec_removed : 1
(ray_trace_1086) 
stats_tailcall_removed : 0

[times] TonLambda.optimize: 0.000 s
[times] Closure.intro: 0.000 s
checking tailcall on create/1093
stats_rec_removed : 0

stats_tailcall_removed : 0

[times] TonSlambda.optimize: 0.008 s
[times] TonClosure.optimize: 0.044 s
[times] TonSlambda.optimize: 0.012 s
[times] Cmmgen.compunit: 0.028 s
[times] Asmgen.compile_phrases: 0.316 s
-dlambda2
[times] TonLambda.optimize: 0.000 s
*** After TonLambda.optimize:
(seq
  (let (delta/1031 (caml_sqrt_float (field 14 (global Pervasives!))))
    (setfield_imm 0 (global Code!) delta/1031))
  (let (zero/1039 [|0. 0. 0.|]) (setfield_imm 1 (global Code!) zero/1039))
  (let
    (*|/1040
       (function s/1041 r/1042
         (makearray  (*. s/1041 (floatfield 0 r/1042))
           (*. s/1041 (floatfield 1 r/1042))
           (*. s/1041 (floatfield 2 r/1042)))))
    (setfield_imm 2 (global Code!) *|/1040))
  (let
    (+|/1043
       (function a/1044 b/1045
         (makearray  (+. (floatfield 0 a/1044) (floatfield 0 b/1045))
           (+. (floatfield 1 a/1044) (floatfield 1 b/1045))
           (+. (floatfield 2 a/1044) (floatfield 2 b/1045)))))
    (setfield_imm 3 (global Code!) +|/1043))
  (let
    (-|/1046
       (function a/1047 b/1048
         (makearray  (-. (floatfield 0 a/1047) (floatfield 0 b/1048))
           (-. (floatfield 1 a/1047) (floatfield 1 b/1048))
           (-. (floatfield 2 a/1047) (floatfield 2 b/1048)))))
    (setfield_imm 4 (global Code!) -|/1046))
  (let
    (dot/1049
       (function a/1050 b/1051
         (+.
           (+. (*. (floatfield 0 a/1050) (floatfield 0 b/1051))
             (*. (floatfield 1 a/1050) (floatfield 1 b/1051)))
           (*. (floatfield 2 a/1050) (floatfield 2 b/1051)))))
    (setfield_imm 5 (global Code!) dot/1049))
  (let
    (length/1052
       (function r/1053
         (caml_sqrt_float (apply (field 5 (global Code!)) r/1053 r/1053))))
    (setfield_imm 6 (global Code!) length/1052))
  (let
    (unitise/1054
       (function r/1055
         (apply (field 2 (global Code!))
           (/. 1. (apply (field 6 (global Code!)) r/1055)) r/1055)))
    (setfield_imm 7 (global Code!) unitise/1054))
  (let
    (ray_sphere/1056
       (function orig/1057 dir/1058 center/1059 radius/1060
         (let
           (v/1061 (apply (field 4 (global Code!)) center/1059 orig/1057)
            b/1062 (apply (field 5 (global Code!)) v/1061 dir/1058)
            d2/1063
              (+.
                (-. (*. b/1062 b/1062)
                  (apply (field 5 (global Code!)) v/1061 v/1061))
                (*. radius/1060 radius/1060)))
           (if (<. d2/1063 0.) (field 9 (global Pervasives!))
             (let
               (d/1064 (caml_sqrt_float d2/1063)
                t1/1065 (-. b/1062 d/1064)
                t2/1066 (+. b/1062 d/1064))
               (if (>. t2/1066 0.) (if (>. t1/1065 0.) t1/1065 t2/1066)
                 (field 9 (global Pervasives!))))))))
    (setfield_imm 8 (global Code!) ray_sphere/1056))
  (letrec
    (intersect/1067
       (function orig/1069 dir/1070 hit/1072 param/1141
         (let
           (scene/1075 (field 2 param/1141)
            center/1073 (field 0 param/1141)
            match/1142
              (apply (field 8 (global Code!)) orig/1069 dir/1070 center/1073
                (field 1 param/1141)))
           (if (>=. match/1142 (field 0 hit/1072)) hit/1072
             (if scene/1075
               (apply intersects/1068 orig/1069 dir/1070 hit/1072 scene/1075)
               (makeblock 0 match/1142
                 (apply (field 7 (global Code!))
                   (apply (field 4 (global Code!))
                     (apply (field 3 (global Code!)) orig/1069
                       (apply (field 2 (global Code!)) match/1142 dir/1070))
                     center/1073)))))))
      intersects/1068
        (function orig/1079 dir/1080 hit/1081 param/1146
          (if param/1146
            (apply intersects/1068 orig/1079 dir/1080
              (apply intersect/1067 orig/1079 dir/1080 hit/1081
                (field 0 param/1146))
              (field 1 param/1146))
            hit/1081)))
    (seq (setfield_imm 9 (global Code!) intersect/1067)
      (setfield_imm 10 (global Code!) intersects/1068)))
  (let (light/1084 (apply (field 7 (global Code!)) [|1. 3. -2.|]) ss/1085 4)
    (seq (setfield_imm 11 (global Code!) light/1084)
      (setfield_imm 12 (global Code!) ss/1085)))
  (let
    (ray_trace/1086
       (function dir/1087 scene/1088
         (let
           (match/1148
              (apply (field 9 (global Code!)) (field 1 (global Code!))
                dir/1087
                (makeblock 0 (field 9 (global Pervasives!))
                  (field 1 (global Code!)))
                scene/1088)
            n/1090 (field 1 match/1148)
            g/1091
              (apply (field 5 (global Code!)) n/1090
                (field 11 (global Code!))))
           (if (<=. g/1091 0.) 0.
             (let
               (p/1092
                  (apply (field 3 (global Code!))
                    (apply (field 2 (global Code!)) (field 0 match/1148)
                      dir/1087)
                    (apply (field 2 (global Code!))
                      (caml_sqrt_float (field 14 (global Pervasives!)))
                      n/1090)))
               (if
                 (<.
                   (field 0
                     (apply (field 9 (global Code!)) p/1092
                       (field 11 (global Code!))
                       (makeblock 0 (field 9 (global Pervasives!))
                         (field 1 (global Code!)))
                       scene/1088))
                   (field 9 (global Pervasives!)))
                 0. g/1091))))))
    (setfield_imm 13 (global Code!) ray_trace/1086))
  (letrec
    (create/1093
       (function level/1094 c/1095 r/1096
         (let (obj/1097 (makeblock 0 c/1095 r/1096 0a))
           (if (== level/1094 1) obj/1097
             (let
               (a/1098 (/. (*. 3. r/1096) (caml_sqrt_float 12.))
                aux/1099
                  (function x'/1100 z'/1101
                    (apply create/1093 (- level/1094 1)
                      (apply (field 3 (global Code!)) c/1095
                        (makearray  x'/1100 a/1098 z'/1101))
                      (*. 0.5 r/1096))))
               (makeblock 0 c/1095 (*. 3. r/1096)
                 (makeblock 0 obj/1097
                   (makeblock 0 (apply aux/1099 (~. a/1098) (~. a/1098))
                     (makeblock 0 (apply aux/1099 a/1098 (~. a/1098))
                       (makeblock 0 (apply aux/1099 (~. a/1098) a/1098)
                         (makeblock 0 (apply aux/1099 a/1098 a/1098) 0a)))))))))))
    (setfield_imm 14 (global Code!) create/1093))
  (let
    (match/1151
       (try
         (makeblock 0
           (caml_int_of_string (array.get (field 0 (global Sys!)) 1))
           (caml_int_of_string (array.get (field 0 (global Sys!)) 2)))
        with exn/1150 [0: 6 512]))
    (seq (setfield_imm 15 (global Code!) (field 0 match/1151))
      (setfield_imm 16 (global Code!) (field 1 match/1151))))
  (let
    (scene/1104
       (apply (field 14 (global Code!)) (field 15 (global Code!))
         [|0. -1. 4.|] 1.))
    (setfield_imm 17 (global Code!) scene/1104))
  (apply (field 1 (global Printf!)) "P5\n%d %d\n255\n"
    (field 16 (global Code!)) (field 16 (global Code!)))
  (for y/1105 (- (field 16 (global Code!)) 1) downto 0
    (for x/1106 0 to (- (field 16 (global Code!)) 1)
      (let (g/1107 0.)
        (seq
          (for dx/1108 0 to (- (field 12 (global Code!)) 1)
            (for dy/1109 0 to (- (field 12 (global Code!)) 1)
              (let
                (aux/1110
                   (function x/1111 d/1112
                     (+.
                       (-. (float_of_int x/1111)
                         (/. (float_of_int (field 16 (global Code!))) 2.))
                       (/. (float_of_int d/1112)
                         (float_of_int (field 12 (global Code!))))))
                 dir/1113
                   (apply (field 7 (global Code!))
                     (makearray  (apply aux/1110 x/1106 dx/1108)
                       (apply aux/1110 y/1105 dy/1109)
                       (float_of_int (field 16 (global Code!))))))
                (assign g/1107
                  (+. g/1107
                    (apply (field 13 (global Code!)) dir/1113
                      (field 17 (global Code!))))))))
          (let
            (g/1114
               (+. 0.5
                 (/. (*. 255. g/1107)
                   (float_of_int
                     (* (field 12 (global Code!)) (field 12 (global Code!)))))))
            (apply (field 1 (global Printf!)) "%c"
              (apply (field 16 (global Pervasives!)) (int_of_float g/1114))))))))
  0a)
[times] Closure.intro: 0.000 s
[times] TonSlambda.optimize: 0.008 s
[times] TonClosure.optimize: 0.048 s
[times] TonSlambda.optimize: 0.008 s
[times] Cmmgen.compunit: 0.040 s
[times] Asmgen.compile_phrases: 0.316 s
-dclosure
[times] TonLambda.optimize: 0.000 s
[times] Closure.intro: 0.000 s
*** After Closure.intro:
(seq
  (let (delta/1031 (caml_sqrt_float (field 14 (global camlPervasives!))))
    (setfield_imm 0 (global camlCode!) delta/1031))
  (let (zero/1039 [|0. 0. 0.|])
    (setfield_imm 1 (global camlCode!) zero/1039))
  (let
    (*|/1040
       (closure (camlCode__*|_1040(2)  s/1041 r/1042
                  (makearray  (*. s/1041 (floatfield 0 r/1042))
                    (*. s/1041 (floatfield 1 r/1042))
                    (*. s/1041 (floatfield 2 r/1042)))) {3} ))
    (setfield_imm 2 (global camlCode!) *|/1040))
  (let
    (+|/1043
       (closure (camlCode__+|_1043(2)  a/1044 b/1045
                  (makearray 
                    (+. (floatfield 0 a/1044) (floatfield 0 b/1045))
                    (+. (floatfield 1 a/1044) (floatfield 1 b/1045))
                    (+. (floatfield 2 a/1044) (floatfield 2 b/1045)))) 
         {3} ))
    (setfield_imm 3 (global camlCode!) +|/1043))
  (let
    (-|/1046
       (closure (camlCode__-|_1046(2)  a/1047 b/1048
                  (makearray 
                    (-. (floatfield 0 a/1047) (floatfield 0 b/1048))
                    (-. (floatfield 1 a/1047) (floatfield 1 b/1048))
                    (-. (floatfield 2 a/1047) (floatfield 2 b/1048)))) 
         {3} ))
    (setfield_imm 4 (global camlCode!) -|/1046))
  (let
    (dot/1049
       (closure (camlCode__dot_1049(2)  a/1050 b/1051
                  (+.
                    (+. (*. (floatfield 0 a/1050) (floatfield 0 b/1051))
                      (*. (floatfield 1 a/1050) (floatfield 1 b/1051)))
                    (*. (floatfield 2 a/1050) (floatfield 2 b/1051)))) 
         {3} ))
    (setfield_imm 5 (global camlCode!) dot/1049))
  (let
    (length/1052
       (closure (camlCode__length_1052(1)  r/1053
                  (caml_sqrt_float
                    (+.
                      (+. (*. (floatfield 0 r/1053) (floatfield 0 r/1053))
                        (*. (floatfield 1 r/1053) (floatfield 1 r/1053)))
                      (*. (floatfield 2 r/1053) (floatfield 2 r/1053))))) 
         {2} ))
    (setfield_imm 6 (global camlCode!) length/1052))
  (let
    (unitise/1054
       (closure (camlCode__unitise_1054(1)  r/1055
                  (let
                    (s/1160
                       (/. 1.
                         (caml_sqrt_float
                           (+.
                             (+.
                               (*. (floatfield 0 r/1055)
                                 (floatfield 0 r/1055))
                               (*. (floatfield 1 r/1055)
                                 (floatfield 1 r/1055)))
                             (*. (floatfield 2 r/1055) (floatfield 2 r/1055))))))
                    (makearray  (*. s/1160 (floatfield 0 r/1055))
                      (*. s/1160 (floatfield 1 r/1055))
                      (*. s/1160 (floatfield 2 r/1055))))) {2} ))
    (setfield_imm 7 (global camlCode!) unitise/1054))
  (let
    (ray_sphere/1056
       (closure (camlCode__ray_sphere_1056(4)  orig/1057 dir/1058 center/1059
                  radius/1060
                  (let
                    (v/1061
                       (makearray 
                         (-. (floatfield 0 center/1059)
                           (floatfield 0 orig/1057))
                         (-. (floatfield 1 center/1059)
                           (floatfield 1 orig/1057))
                         (-. (floatfield 2 center/1059)
                           (floatfield 2 orig/1057)))
                     b/1062
                       (+.
                         (+.
                           (*. (floatfield 0 v/1061) (floatfield 0 dir/1058))
                           (*. (floatfield 1 v/1061) (floatfield 1 dir/1058)))
                         (*. (floatfield 2 v/1061) (floatfield 2 dir/1058)))
                     d2/1063
                       (+.
                         (-. (*. b/1062 b/1062)
                           (+.
                             (+.
                               (*. (floatfield 0 v/1061)
                                 (floatfield 0 v/1061))
                               (*. (floatfield 1 v/1061)
                                 (floatfield 1 v/1061)))
                             (*. (floatfield 2 v/1061) (floatfield 2 v/1061))))
                         (*. radius/1060 radius/1060)))
                    (if (<. d2/1063 0.) (field 9 (global camlPervasives!))
                      (let
                        (d/1064 (caml_sqrt_float d2/1063)
                         t1/1065 (-. b/1062 d/1064)
                         t2/1066 (+. b/1062 d/1064))
                        (if (>. t2/1066 0.)
                          (if (>. t1/1065 0.) t1/1065 t2/1066)
                          (field 9 (global camlPervasives!))))))) {3} ))
    (setfield_imm 8 (global camlCode!) ray_sphere/1056))
  (let
    (clos/1222
       (closure (camlCode__intersect_1067(4+c)  orig/1069 dir/1070 hit/1072
                  param/1141 env/1175
                  (let
                    (scene/1075[Alias] (field 2 param/1141)
                     center/1073[Alias] (field 0 param/1141)
                     match/1142
                       (let
                         (radius/1176 (field 1 param/1141)
                          v/1177
                            (makearray 
                              (-. (floatfield 0 center/1073)
                                (floatfield 0 orig/1069))
                              (-. (floatfield 1 center/1073)
                                (floatfield 1 orig/1069))
                              (-. (floatfield 2 center/1073)
                                (floatfield 2 orig/1069)))
                          b/1178
                            (+.
                              (+.
                                (*. (floatfield 0 v/1177)
                                  (floatfield 0 dir/1070))
                                (*. (floatfield 1 v/1177)
                                  (floatfield 1 dir/1070)))
                              (*. (floatfield 2 v/1177)
                                (floatfield 2 dir/1070)))
                          d2/1179
                            (+.
                              (-. (*. b/1178 b/1178)
                                (+.
                                  (+.
                                    (*. (floatfield 0 v/1177)
                                      (floatfield 0 v/1177))
                                    (*. (floatfield 1 v/1177)
                                      (floatfield 1 v/1177)))
                                  (*. (floatfield 2 v/1177)
                                    (floatfield 2 v/1177))))
                              (*. radius/1176 radius/1176)))
                         (if (<. d2/1179 0.)
                           (field 9 (global camlPervasives!))
                           (let
                             (d/1180 (caml_sqrt_float d2/1179)
                              t1/1181 (-. b/1178 d/1180)
                              t2/1182 (+. b/1178 d/1180))
                             (if (>. t2/1182 0.)
                               (if (>. t1/1181 0.) t1/1181 t2/1182)
                               (field 9 (global camlPervasives!)))))))
                    (if (>=. match/1142 (field 0 hit/1072)) hit/1072
                      (if scene/1075
                        (camlCode__intersects_1068  orig/1069 dir/1070
                          hit/1072 scene/1075 (offset[4] env/1175))
                        (makeblock 0 match/1142
                          (let
                            (r/1185
                               (let
                                 (a/1184
                                    (let
                                      (b/1183
                                         (makearray 
                                           (*. match/1142
                                             (floatfield 0 dir/1070))
                                           (*. match/1142
                                             (floatfield 1 dir/1070))
                                           (*. match/1142
                                             (floatfield 2 dir/1070))))
                                      (makearray 
                                        (+. (floatfield 0 orig/1069)
                                          (floatfield 0 b/1183))
                                        (+. (floatfield 1 orig/1069)
                                          (floatfield 1 b/1183))
                                        (+. (floatfield 2 orig/1069)
                                          (floatfield 2 b/1183)))))
                                 (makearray 
                                   (-. (floatfield 0 a/1184)
                                     (floatfield 0 center/1073))
                                   (-. (floatfield 1 a/1184)
                                     (floatfield 1 center/1073))
                                   (-. (floatfield 2 a/1184)
                                     (floatfield 2 center/1073))))
                             s/1186
                               (/. 1.
                                 (caml_sqrt_float
                                   (+.
                                     (+.
                                       (*. (floatfield 0 r/1185)
                                         (floatfield 0 r/1185))
                                       (*. (floatfield 1 r/1185)
                                         (floatfield 1 r/1185)))
                                     (*. (floatfield 2 r/1185)
                                       (floatfield 2 r/1185))))))
                            (makearray  (*. s/1186 (floatfield 0 r/1185))
                              (*. s/1186 (floatfield 1 r/1185))
                              (*. s/1186 (floatfield 2 r/1185)))))))))
                (camlCode__intersects_1068(4+c)  orig/1079 dir/1080 hit/1081
                  param/1146 env/1187
                  (if param/1146
                    (camlCode__intersects_1068  orig/1079 dir/1080
                      (camlCode__intersect_1067  orig/1079 dir/1080 hit/1081
                        (field 0 param/1146) (offset[-4] env/1187))
                      (field 1 param/1146) env/1187)
                    hit/1081)) {7} ))
    (seq (setfield_imm 9 (global camlCode!) clos/1222)
      (setfield_imm 10 (global camlCode!) (offset[4] clos/1222))))
  (let
    (light/1084
       (let
         (s/1223
            (/. 1.
              (caml_sqrt_float
                (+.
                  (+.
                    (*. (floatfield 0 [|1. 3. -2.|])
                      (floatfield 0 [|1. 3. -2.|]))
                    (*. (floatfield 1 [|1. 3. -2.|])
                      (floatfield 1 [|1. 3. -2.|])))
                  (*. (floatfield 2 [|1. 3. -2.|])
                    (floatfield 2 [|1. 3. -2.|]))))))
         (makearray  (*. s/1223 (floatfield 0 [|1. 3. -2.|]))
           (*. s/1223 (floatfield 1 [|1. 3. -2.|]))
           (*. s/1223 (floatfield 2 [|1. 3. -2.|])))))
    (seq (setfield_imm 11 (global camlCode!) light/1084)
      (setfield_imm 12 (global camlCode!) 4)))
  (let
    (ray_trace/1086
       (closure (camlCode__ray_trace_1086(2)  dir/1087 scene/1088
                  (let
                    (match/1148
                       (camlCode__intersect_1067 
                         (field 1 (global camlCode!)) dir/1087
                         (makeblock 0 (field 9 (global camlPervasives!))
                           (field 1 (global camlCode!)))
                         scene/1088 (field 9 (global camlCode!)))
                     n/1090[Alias] (field 1 match/1148)
                     g/1091
                       (let (b/1225 (field 11 (global camlCode!)))
                         (+.
                           (+.
                             (*. (floatfield 0 n/1090) (floatfield 0 b/1225))
                             (*. (floatfield 1 n/1090) (floatfield 1 b/1225)))
                           (*. (floatfield 2 n/1090) (floatfield 2 b/1225)))))
                    (if (<=. g/1091 0.) 0.
                      (let
                        (p/1092
                           (let
                             (b/1228
                                (let
                                  (s/1227
                                     (caml_sqrt_float
                                       (field 14 (global camlPervasives!))))
                                  (makearray 
                                    (*. s/1227 (floatfield 0 n/1090))
                                    (*. s/1227 (floatfield 1 n/1090))
                                    (*. s/1227 (floatfield 2 n/1090))))
                              a/1229
                                (let (s/1226 (field 0 match/1148))
                                  (makearray 
                                    (*. s/1226 (floatfield 0 dir/1087))
                                    (*. s/1226 (floatfield 1 dir/1087))
                                    (*. s/1226 (floatfield 2 dir/1087)))))
                             (makearray 
                               (+. (floatfield 0 a/1229)
                                 (floatfield 0 b/1228))
                               (+. (floatfield 1 a/1229)
                                 (floatfield 1 b/1228))
                               (+. (floatfield 2 a/1229)
                                 (floatfield 2 b/1228)))))
                        (if
                          (<.
                            (field 0
                              (camlCode__intersect_1067  p/1092
                                (field 11 (global camlCode!))
                                (makeblock 0
                                  (field 9 (global camlPervasives!))
                                  (field 1 (global camlCode!)))
                                scene/1088 (field 9 (global camlCode!))))
                            (field 9 (global camlPervasives!)))
                          0. g/1091))))) {3} ))
    (setfield_imm 13 (global camlCode!) ray_trace/1086))
  (let
    (clos/1268
       (closure (camlCode__create_1093(3+c)  level/1094 c/1095 r/1096
                  env/1249
                  (let (obj/1097 (makeblock 0 c/1095 r/1096 0a))
                    (if (== level/1094 1) obj/1097
                      (let
                        (a/1098 (/. (*. 3. r/1096) (caml_sqrt_float 12.))
                         aux/1099
                           (closure (camlCode__aux_1099(2+c)  x'/1100 z'/1101
                                      env/1253
                                      (camlCode__create_1093 
                                        (- (field 4 env/1253) 1)
                                        (let
                                          (b/1254
                                             (makearray  x'/1100
                                               (field 7 env/1253) z'/1101)
                                           a/1255 (field 5 env/1253))
                                          (makearray 
                                            (+. (floatfield 0 a/1255)
                                              (floatfield 0 b/1254))
                                            (+. (floatfield 1 a/1255)
                                              (floatfield 1 b/1254))
                                            (+. (floatfield 2 a/1255)
                                              (floatfield 2 b/1254))))
                                        (*. 0.5 (field 6 env/1253))
                                        (field 3 env/1253))) {3} 
                                                             env/1249
                                                             level/1094
                                                             c/1095
                                                             r/1096
                                                             a/1098))
                        (makeblock 0 c/1095 (*. 3. r/1096)
                          (makeblock 0 obj/1097
                            (makeblock 0
                              (let (z'/1256 (~. a/1098) x'/1257 (~. a/1098))
                                (camlCode__create_1093 
                                  (- (field 4 aux/1099) 1)
                                  (let
                                    (b/1258
                                       (makearray  x'/1257 (field 7 aux/1099)
                                         z'/1256)
                                     a/1259 (field 5 aux/1099))
                                    (makearray 
                                      (+. (floatfield 0 a/1259)
                                        (floatfield 0 b/1258))
                                      (+. (floatfield 1 a/1259)
                                        (floatfield 1 b/1258))
                                      (+. (floatfield 2 a/1259)
                                        (floatfield 2 b/1258))))
                                  (*. 0.5 (field 6 aux/1099))
                                  (field 3 aux/1099)))
                              (makeblock 0
                                (let (z'/1260 (~. a/1098))
                                  (camlCode__create_1093 
                                    (- (field 4 aux/1099) 1)
                                    (let
                                      (b/1261
                                         (makearray  a/1098
                                           (field 7 aux/1099) z'/1260)
                                       a/1262 (field 5 aux/1099))
                                      (makearray 
                                        (+. (floatfield 0 a/1262)
                                          (floatfield 0 b/1261))
                                        (+. (floatfield 1 a/1262)
                                          (floatfield 1 b/1261))
                                        (+. (floatfield 2 a/1262)
                                          (floatfield 2 b/1261))))
                                    (*. 0.5 (field 6 aux/1099))
                                    (field 3 aux/1099)))
                                (makeblock 0
                                  (let (x'/1263 (~. a/1098))
                                    (camlCode__create_1093 
                                      (- (field 4 aux/1099) 1)
                                      (let
                                        (b/1264
                                           (makearray  x'/1263
                                             (field 7 aux/1099) a/1098)
                                         a/1265 (field 5 aux/1099))
                                        (makearray 
                                          (+. (floatfield 0 a/1265)
                                            (floatfield 0 b/1264))
                                          (+. (floatfield 1 a/1265)
                                            (floatfield 1 b/1264))
                                          (+. (floatfield 2 a/1265)
                                            (floatfield 2 b/1264))))
                                      (*. 0.5 (field 6 aux/1099))
                                      (field 3 aux/1099)))
                                  (makeblock 0
                                    (camlCode__create_1093 
                                      (- (field 4 aux/1099) 1)
                                      (let
                                        (b/1266
                                           (makearray  a/1098
                                             (field 7 aux/1099) a/1098)
                                         a/1267 (field 5 aux/1099))
                                        (makearray 
                                          (+. (floatfield 0 a/1267)
                                            (floatfield 0 b/1266))
                                          (+. (floatfield 1 a/1267)
                                            (floatfield 1 b/1266))
                                          (+. (floatfield 2 a/1267)
                                            (floatfield 2 b/1266))))
                                      (*. 0.5 (field 6 aux/1099))
                                      (field 3 aux/1099))
                                    0a)))))))))) {3} ))
    (setfield_imm 14 (global camlCode!) clos/1268))
  (let
    (match/1151
       (try
         (makeblock 0
           (caml_int_of_string (array.get (field 0 (global camlSys!)) 1))
           (caml_int_of_string (array.get (field 0 (global camlSys!)) 2)))
        with exn/1150 [0: 6 512]))
    (seq (setfield_imm 15 (global camlCode!) (field 0 match/1151))
      (setfield_imm 16 (global camlCode!) (field 1 match/1151))))
  (let
    (scene/1104
       (camlCode__create_1093  (field 15 (global camlCode!)) [|0. -1. 4.|] 1.
         (field 14 (global camlCode!))))
    (setfield_imm 17 (global camlCode!) scene/1104))
  (apply
    (apply (camlPrintf__fprintf_1392  (field 23 (global camlPervasives!)))
      "P5\n%d %d\n255\n")
    (field 16 (global camlCode!)) (field 16 (global camlCode!)))
  (for y/1105 (- (field 16 (global camlCode!)) 1) downto 0
    (for x/1106 0 to (- (field 16 (global camlCode!)) 1)
      (let (g/1107[Variable] 0.)
        (seq
          (for dx/1108 0 to 3
            (for dy/1109 0 to 3
              (let
                (aux/1110
                   (closure (camlCode__aux_1110(2)  x/1111 d/1112
                              (+.
                                (-. (float_of_int x/1111)
                                  (/.
                                    (float_of_int
                                      (field 16 (global camlCode!)))
                                    2.))
                                (/. (float_of_int d/1112) (float_of_int 4)))) 
                     {3} )
                 dir/1113
                   (let
                     (r/1270
                        (makearray 
                          (+.
                            (-. (float_of_int x/1106)
                              (/.
                                (float_of_int (field 16 (global camlCode!)))
                                2.))
                            (/. (float_of_int dx/1108) (float_of_int 4)))
                          (+.
                            (-. (float_of_int y/1105)
                              (/.
                                (float_of_int (field 16 (global camlCode!)))
                                2.))
                            (/. (float_of_int dy/1109) (float_of_int 4)))
                          (float_of_int (field 16 (global camlCode!))))
                      s/1271
                        (/. 1.
                          (caml_sqrt_float
                            (+.
                              (+.
                                (*. (floatfield 0 r/1270)
                                  (floatfield 0 r/1270))
                                (*. (floatfield 1 r/1270)
                                  (floatfield 1 r/1270)))
                              (*. (floatfield 2 r/1270)
                                (floatfield 2 r/1270))))))
                     (makearray  (*. s/1271 (floatfield 0 r/1270))
                       (*. s/1271 (floatfield 1 r/1270))
                       (*. s/1271 (floatfield 2 r/1270)))))
                (assign g/1107
                  (+. g/1107
                    (let
                      (scene/1272 (field 17 (global camlCode!))
                       match/1273
                         (camlCode__intersect_1067 
                           (field 1 (global camlCode!)) dir/1113
                           (makeblock 0 (field 9 (global camlPervasives!))
                             (field 1 (global camlCode!)))
                           scene/1272 (field 9 (global camlCode!)))
                       n/1274[Alias] (field 1 match/1273)
                       g/1275
                         (let (b/1281 (field 11 (global camlCode!)))
                           (+.
                             (+.
                               (*. (floatfield 0 n/1274)
                                 (floatfield 0 b/1281))
                               (*. (floatfield 1 n/1274)
                                 (floatfield 1 b/1281)))
                             (*. (floatfield 2 n/1274) (floatfield 2 b/1281)))))
                      (if (<=. g/1275 0.) 0.
                        (let
                          (p/1276
                             (let
                               (b/1277
                                  (let
                                    (s/1280
                                       (caml_sqrt_float
                                         (field 14 (global camlPervasives!))))
                                    (makearray 
                                      (*. s/1280 (floatfield 0 n/1274))
                                      (*. s/1280 (floatfield 1 n/1274))
                                      (*. s/1280 (floatfield 2 n/1274))))
                                a/1278
                                  (let (s/1279 (field 0 match/1273))
                                    (makearray 
                                      (*. s/1279 (floatfield 0 dir/1113))
                                      (*. s/1279 (floatfield 1 dir/1113))
                                      (*. s/1279 (floatfield 2 dir/1113)))))
                               (makearray 
                                 (+. (floatfield 0 a/1278)
                                   (floatfield 0 b/1277))
                                 (+. (floatfield 1 a/1278)
                                   (floatfield 1 b/1277))
                                 (+. (floatfield 2 a/1278)
                                   (floatfield 2 b/1277)))))
                          (if
                            (<.
                              (field 0
                                (camlCode__intersect_1067  p/1276
                                  (field 11 (global camlCode!))
                                  (makeblock 0
                                    (field 9 (global camlPervasives!))
                                    (field 1 (global camlCode!)))
                                  scene/1272 (field 9 (global camlCode!))))
                              (field 9 (global camlPervasives!)))
                            0. g/1275)))))))))
          (let (g/1114 (+. 0.5 (/. (*. 255. g/1107) (float_of_int 16))))
            (apply
              (apply
                (camlPrintf__fprintf_1392 
                  (field 23 (global camlPervasives!)))
                "%c")
              (let (n/1282 (int_of_float g/1114))
                (if (if (< n/1282 0) 1a (> n/1282 255))
                  (raise
                    (makeblock 0 (global caml_exn_Invalid_argument!)
                      "char_of_int"))
                  (id n/1282)))))))))
  0a)
[times] TonSlambda.optimize: 0.008 s
[times] TonClosure.optimize: 0.048 s
[times] TonSlambda.optimize: 0.008 s
[times] Cmmgen.compunit: 0.036 s
[times] Asmgen.compile_phrases: 0.316 s
-dclosure2
[times] TonLambda.optimize: 0.000 s
[times] Closure.intro: 0.000 s
[times] TonSlambda.optimize: 0.008 s
[times] TonClosure.optimize: 0.048 s
*** After TonClosure.optimize:
(let
  (temp/1876 (global camlPervasives!)
   temp/1875 (field 14 temp/1876)
   delta/1031 (caml_sqrt_float temp/1875)
   temp/1874 (global camlCode!))
  (seq (setfield_imm 0 temp/1874 delta/1031)
    (let (zero/1039 [|0. 0. 0.|] temp/1873 (global camlCode!))
      (seq (setfield_imm 1 temp/1873 zero/1039)
        (let
          (*|/1040
             (closure (camlCode__*|_1040(2)  s/1041 r/1042
                        (let
                          (temp/1868 (floatfield 0 r/1042)
                           temp/1867 (*. s/1041 temp/1868)
                           temp/1870 (floatfield 1 r/1042)
                           temp/1869 (*. s/1041 temp/1870)
                           temp/1872 (floatfield 2 r/1042)
                           temp/1871 (*. s/1041 temp/1872))
                          (makearray  temp/1867 temp/1869 temp/1871))) 
               {3} )
           temp/1866 (global camlCode!))
          (seq (setfield_imm 2 temp/1866 *|/1040)
            (let
              (+|/1043
                 (closure (camlCode__+|_1043(2)  a/1044 b/1045
                            (let
                              (temp/1858 (floatfield 0 a/1044)
                               temp/1859 (floatfield 0 b/1045)
                               temp/1857 (+. temp/1858 temp/1859)
                               temp/1861 (floatfield 1 a/1044)
                               temp/1862 (floatfield 1 b/1045)
                               temp/1860 (+. temp/1861 temp/1862)
                               temp/1864 (floatfield 2 a/1044)
                               temp/1865 (floatfield 2 b/1045)
                               temp/1863 (+. temp/1864 temp/1865))
                              (makearray  temp/1857 temp/1860 temp/1863))) 
                   {3} )
               temp/1856 (global camlCode!))
              (seq (setfield_imm 3 temp/1856 +|/1043)
                (let
                  (-|/1046
                     (closure (camlCode__-|_1046(2)  a/1047 b/1048
                                (let
                                  (temp/1848 (floatfield 0 a/1047)
                                   temp/1849 (floatfield 0 b/1048)
                                   temp/1847 (-. temp/1848 temp/1849)
                                   temp/1851 (floatfield 1 a/1047)
                                   temp/1852 (floatfield 1 b/1048)
                                   temp/1850 (-. temp/1851 temp/1852)
                                   temp/1854 (floatfield 2 a/1047)
                                   temp/1855 (floatfield 2 b/1048)
                                   temp/1853 (-. temp/1854 temp/1855))
                                  (makearray  temp/1847 temp/1850 temp/1853))) 
                       {3} )
                   temp/1846 (global camlCode!))
                  (seq (setfield_imm 4 temp/1846 -|/1046)
                    (let
                      (dot/1049
                         (closure (camlCode__dot_1049(2)  a/1050 b/1051
                                    (let
                                      (temp/1838 (floatfield 0 a/1050)
                                       temp/1839 (floatfield 0 b/1051)
                                       temp/1837 (*. temp/1838 temp/1839)
                                       temp/1841 (floatfield 1 a/1050)
                                       temp/1842 (floatfield 1 b/1051)
                                       temp/1840 (*. temp/1841 temp/1842)
                                       temp/1836 (+. temp/1837 temp/1840)
                                       temp/1844 (floatfield 2 a/1050)
                                       temp/1845 (floatfield 2 b/1051)
                                       temp/1843 (*. temp/1844 temp/1845))
                                      (+. temp/1836 temp/1843))) {3} )
                       temp/1835 (global camlCode!))
                      (seq (setfield_imm 5 temp/1835 dot/1049)
                        (let
                          (length/1052
                             (closure (camlCode__length_1052(1)  r/1053
                                        (let
                                          (temp/1827 (floatfield 0 r/1053)
                                           temp/1828 (floatfield 0 r/1053)
                                           temp/1826 (*. temp/1827 temp/1828)
                                           temp/1830 (floatfield 1 r/1053)
                                           temp/1831 (floatfield 1 r/1053)
                                           temp/1829 (*. temp/1830 temp/1831)
                                           temp/1825 (+. temp/1826 temp/1829)
                                           temp/1833 (floatfield 2 r/1053)
                                           temp/1834 (floatfield 2 r/1053)
                                           temp/1832 (*. temp/1833 temp/1834)
                                           temp/1824 (+. temp/1825 temp/1832))
                                          (caml_sqrt_float temp/1824))) 
                               {2} )
                           temp/1823 (global camlCode!))
                          (seq (setfield_imm 6 temp/1823 length/1052)
                            (let
                              (unitise/1054
                                 (closure (camlCode__unitise_1054(1)  r/1055
                                            (let
                                              (temp/1810 1.
                                               temp/1815
                                                 (floatfield 0 r/1055)
                                               temp/1816
                                                 (floatfield 0 r/1055)
                                               temp/1814
                                                 (*. temp/1815 temp/1816)
                                               temp/1818
                                                 (floatfield 1 r/1055)
                                               temp/1819
                                                 (floatfield 1 r/1055)
                                               temp/1817
                                                 (*. temp/1818 temp/1819)
                                               temp/1813
                                                 (+. temp/1814 temp/1817)
                                               temp/1821
                                                 (floatfield 2 r/1055)
                                               temp/1822
                                                 (floatfield 2 r/1055)
                                               temp/1820
                                                 (*. temp/1821 temp/1822)
                                               temp/1812
                                                 (+. temp/1813 temp/1820)
                                               temp/1811
                                                 (caml_sqrt_float temp/1812)
                                               s/1160
                                                 (/. temp/1810 temp/1811)
                                               temp/1805
                                                 (floatfield 0 r/1055)
                                               temp/1804
                                                 (*. s/1160 temp/1805)
                                               temp/1807
                                                 (floatfield 1 r/1055)
                                               temp/1806
                                                 (*. s/1160 temp/1807)
                                               temp/1809
                                                 (floatfield 2 r/1055)
                                               temp/1808
                                                 (*. s/1160 temp/1809))
                                              (makearray  temp/1804 temp/1806
                                                temp/1808))) {2} )
                               temp/1803 (global camlCode!))
                              (seq (setfield_imm 7 temp/1803 unitise/1054)
                                (let
                                  (ray_sphere/1056
                                     (closure (camlCode__ray_sphere_1056(4) 
                                                orig/1057 dir/1058
                                                center/1059 radius/1060
                                                (let
                                                  (temp/1795
                                                     (floatfield 0
                                                       center/1059)
                                                   temp/1796
                                                     (floatfield 0 orig/1057)
                                                   temp/1794
                                                     (-. temp/1795 temp/1796)
                                                   temp/1798
                                                     (floatfield 1
                                                       center/1059)
                                                   temp/1799
                                                     (floatfield 1 orig/1057)
                                                   temp/1797
                                                     (-. temp/1798 temp/1799)
                                                   temp/1801
                                                     (floatfield 2
                                                       center/1059)
                                                   temp/1802
                                                     (floatfield 2 orig/1057)
                                                   temp/1800
                                                     (-. temp/1801 temp/1802)
                                                   v/1061
                                                     (makearray  temp/1794
                                                       temp/1797 temp/1800)
                                                   temp/1786
                                                     (floatfield 0 v/1061)
                                                   temp/1787
                                                     (floatfield 0 dir/1058)
                                                   temp/1785
                                                     (*. temp/1786 temp/1787)
                                                   temp/1789
                                                     (floatfield 1 v/1061)
                                                   temp/1790
                                                     (floatfield 1 dir/1058)
                                                   temp/1788
                                                     (*. temp/1789 temp/1790)
                                                   temp/1784
                                                     (+. temp/1785 temp/1788)
                                                   temp/1792
                                                     (floatfield 2 v/1061)
                                                   temp/1793
                                                     (floatfield 2 dir/1058)
                                                   temp/1791
                                                     (*. temp/1792 temp/1793)
                                                   b/1062
                                                     (+. temp/1784 temp/1791)
                                                   temp/1771
                                                     (*. b/1062 b/1062)
                                                   temp/1775
                                                     (floatfield 0 v/1061)
                                                   temp/1776
                                                     (floatfield 0 v/1061)
                                                   temp/1774
                                                     (*. temp/1775 temp/1776)
                                                   temp/1778
                                                     (floatfield 1 v/1061)
                                                   temp/1779
                                                     (floatfield 1 v/1061)
                                                   temp/1777
                                                     (*. temp/1778 temp/1779)
                                                   temp/1773
                                                     (+. temp/1774 temp/1777)
                                                   temp/1781
                                                     (floatfield 2 v/1061)
                                                   temp/1782
                                                     (floatfield 2 v/1061)
                                                   temp/1780
                                                     (*. temp/1781 temp/1782)
                                                   temp/1772
                                                     (+. temp/1773 temp/1780)
                                                   temp/1770
                                                     (-. temp/1771 temp/1772)
                                                   temp/1783
                                                     (*. radius/1060
                                                       radius/1060)
                                                   d2/1063
                                                     (+. temp/1770 temp/1783)
                                                   temp/1763 0.
                                                   temp/1762
                                                     (<. d2/1063 temp/1763))
                                                  (if temp/1762
                                                    (let
                                                      (temp/1769
                                                         (global camlPervasives!))
                                                      (field 9 temp/1769))
                                                    (let
                                                      (d/1064
                                                         (caml_sqrt_float
                                                           d2/1063)
                                                       t1/1065
                                                         (-. b/1062 d/1064)
                                                       t2/1066
                                                         (+. b/1062 d/1064)
                                                       temp/1765 0.
                                                       temp/1764
                                                         (>. t2/1066
                                                           temp/1765))
                                                      (if temp/1764
                                                        (let
                                                          (temp/1768 0.
                                                           temp/1767
                                                             (>. t1/1065
                                                               temp/1768))
                                                          (if temp/1767
                                                            t1/1065 t2/1066))
                                                        (let
                                                          (temp/1766
                                                             (global camlPervasives!))
                                                          (field 9 temp/1766))))))) 
                                       {3} )
                                   temp/1761 (global camlCode!))
                                  (seq
                                    (setfield_imm 8 temp/1761
                                      ray_sphere/1056)
                                    (let
                                      (clos/1222
                                         (closure (camlCode__intersect_1067(4+c) 
                                                    orig/1069 dir/1070
                                                    hit/1072 param/1141
                                                    env/1175
                                                    (let
                                                      (scene/1075[Alias]
                                                         (field 2 param/1141)
                                                       center/1073[Alias]
                                                         (field 0 param/1141)
                                                       radius/1176
                                                         (field 1 param/1141)
                                                       temp/1749
                                                         (floatfield 0
                                                           center/1073)
                                                       temp/1750
                                                         (floatfield 0
                                                           orig/1069)
                                                       temp/1748
                                                         (-. temp/1749
                                                           temp/1750)
                                                       temp/1752
                                                         (floatfield 1
                                                           center/1073)
                                                       temp/1753
                                                         (floatfield 1
                                                           orig/1069)
                                                       temp/1751
                                                         (-. temp/1752
                                                           temp/1753)
                                                       temp/1755
                                                         (floatfield 2
                                                           center/1073)
                                                       temp/1756
                                                         (floatfield 2
                                                           orig/1069)
                                                       temp/1754
                                                         (-. temp/1755
                                                           temp/1756)
                                                       v/1177
                                                         (makearray 
                                                           temp/1748
                                                           temp/1751
                                                           temp/1754)
                                                       temp/1740
                                                         (floatfield 0
                                                           v/1177)
                                                       temp/1741
                                                         (floatfield 0
                                                           dir/1070)
                                                       temp/1739
                                                         (*. temp/1740
                                                           temp/1741)
                                                       temp/1743
                                                         (floatfield 1
                                                           v/1177)
                                                       temp/1744
                                                         (floatfield 1
                                                           dir/1070)
                                                       temp/1742
                                                         (*. temp/1743
                                                           temp/1744)
                                                       temp/1738
                                                         (+. temp/1739
                                                           temp/1742)
                                                       temp/1746
                                                         (floatfield 2
                                                           v/1177)
                                                       temp/1747
                                                         (floatfield 2
                                                           dir/1070)
                                                       temp/1745
                                                         (*. temp/1746
                                                           temp/1747)
                                                       b/1178
                                                         (+. temp/1738
                                                           temp/1745)
                                                       temp/1725
                                                         (*. b/1178 b/1178)
                                                       temp/1729
                                                         (floatfield 0
                                                           v/1177)
                                                       temp/1730
                                                         (floatfield 0
                                                           v/1177)
                                                       temp/1728
                                                         (*. temp/1729
                                                           temp/1730)
                                                       temp/1732
                                                         (floatfield 1
                                                           v/1177)
                                                       temp/1733
                                                         (floatfield 1
                                                           v/1177)
                                                       temp/1731
                                                         (*. temp/1732
                                                           temp/1733)
                                                       temp/1727
                                                         (+. temp/1728
                                                           temp/1731)
                                                       temp/1735
                                                         (floatfield 2
                                                           v/1177)
                                                       temp/1736
                                                         (floatfield 2
                                                           v/1177)
                                                       temp/1734
                                                         (*. temp/1735
                                                           temp/1736)
                                                       temp/1726
                                                         (+. temp/1727
                                                           temp/1734)
                                                       temp/1724
                                                         (-. temp/1725
                                                           temp/1726)
                                                       temp/1737
                                                         (*. radius/1176
                                                           radius/1176)
                                                       d2/1179
                                                         (+. temp/1724
                                                           temp/1737)
                                                       temp/1717 0.
                                                       temp/1716
                                                         (<. d2/1179
                                                           temp/1717)
                                                       match/1142
                                                         (if temp/1716
                                                           (let
                                                             (temp/1723
                                                                (global camlPervasives!))
                                                             (field 9
                                                               temp/1723))
                                                           (let
                                                             (d/1180
                                                                (caml_sqrt_float
                                                                  d2/1179)
                                                              t1/1181
                                                                (-. b/1178
                                                                  d/1180)
                                                              t2/1182
                                                                (+. b/1178
                                                                  d/1180)
                                                              temp/1719 0.
                                                              temp/1718
                                                                (>. t2/1182
                                                                  temp/1719))
                                                             (if temp/1718
                                                               (let
                                                                 (temp/1722
                                                                    0.
                                                                  temp/1721
                                                                    (>.
                                                                    t1/1181
                                                                    temp/1722))
                                                                 (if
                                                                   temp/1721
                                                                   t1/1181
                                                                   t2/1182))
                                                               (let
                                                                 (temp/1720
                                                                    (global camlPervasives!))
                                                                 (field 9
                                                                   temp/1720)))))
                                                       temp/1670
                                                         (field 0 hit/1072)
                                                       temp/1669
                                                         (>=. match/1142
                                                           temp/1670))
                                                      (if temp/1669 hit/1072
                                                        (if scene/1075
                                                          (let
                                                            (temp/1715
                                                               (offset[4]
                                                                 env/1175))
                                                            (camlCode__intersects_1068
                                                               orig/1069
                                                              dir/1070
                                                              hit/1072
                                                              scene/1075
                                                              temp/1715))
                                                          (let
                                                            (temp/1710
                                                               (floatfield 0
                                                                 dir/1070)
                                                             temp/1709
                                                               (*. match/1142
                                                                 temp/1710)
                                                             temp/1712
                                                               (floatfield 1
                                                                 dir/1070)
                                                             temp/1711
                                                               (*. match/1142
                                                                 temp/1712)
                                                             temp/1714
                                                               (floatfield 2
                                                                 dir/1070)
                                                             temp/1713
                                                               (*. match/1142
                                                                 temp/1714)
                                                             b/1183
                                                               (makearray 
                                                                 temp/1709
                                                                 temp/1711
                                                                 temp/1713)
                                                             temp/1701
                                                               (floatfield 0
                                                                 orig/1069)
                                                             temp/1702
                                                               (floatfield 0
                                                                 b/1183)
                                                             temp/1700
                                                               (+. temp/1701
                                                                 temp/1702)
                                                             temp/1704
                                                               (floatfield 1
                                                                 orig/1069)
                                                             temp/1705
                                                               (floatfield 1
                                                                 b/1183)
                                                             temp/1703
                                                               (+. temp/1704
                                                                 temp/1705)
                                                             temp/1707
                                                               (floatfield 2
                                                                 orig/1069)
                                                             temp/1708
                                                               (floatfield 2
                                                                 b/1183)
                                                             temp/1706
                                                               (+. temp/1707
                                                                 temp/1708)
                                                             a/1184
                                                               (makearray 
                                                                 temp/1700
                                                                 temp/1703
                                                                 temp/1706)
                                                             temp/1692
                                                               (floatfield 0
                                                                 a/1184)
                                                             temp/1693
                                                               (floatfield 0
                                                                 center/1073)
                                                             temp/1691
                                                               (-. temp/1692
                                                                 temp/1693)
                                                             temp/1695
                                                               (floatfield 1
                                                                 a/1184)
                                                             temp/1696
                                                               (floatfield 1
                                                                 center/1073)
                                                             temp/1694
                                                               (-. temp/1695
                                                                 temp/1696)
                                                             temp/1698
                                                               (floatfield 2
                                                                 a/1184)
                                                             temp/1699
                                                               (floatfield 2
                                                                 center/1073)
                                                             temp/1697
                                                               (-. temp/1698
                                                                 temp/1699)
                                                             r/1185
                                                               (makearray 
                                                                 temp/1691
                                                                 temp/1694
                                                                 temp/1697)
                                                             temp/1678 1.
                                                             temp/1683
                                                               (floatfield 0
                                                                 r/1185)
                                                             temp/1684
                                                               (floatfield 0
                                                                 r/1185)
                                                             temp/1682
                                                               (*. temp/1683
                                                                 temp/1684)
                                                             temp/1686
                                                               (floatfield 1
                                                                 r/1185)
                                                             temp/1687
                                                               (floatfield 1
                                                                 r/1185)
                                                             temp/1685
                                                               (*. temp/1686
                                                                 temp/1687)
                                                             temp/1681
                                                               (+. temp/1682
                                                                 temp/1685)
                                                             temp/1689
                                                               (floatfield 2
                                                                 r/1185)
                                                             temp/1690
                                                               (floatfield 2
                                                                 r/1185)
                                                             temp/1688
                                                               (*. temp/1689
                                                                 temp/1690)
                                                             temp/1680
                                                               (+. temp/1681
                                                                 temp/1688)
                                                             temp/1679
                                                               (caml_sqrt_float
                                                                 temp/1680)
                                                             s/1186
                                                               (/. temp/1678
                                                                 temp/1679)
                                                             temp/1673
                                                               (floatfield 0
                                                                 r/1185)
                                                             temp/1672
                                                               (*. s/1186
                                                                 temp/1673)
                                                             temp/1675
                                                               (floatfield 1
                                                                 r/1185)
                                                             temp/1674
                                                               (*. s/1186
                                                                 temp/1675)
                                                             temp/1677
                                                               (floatfield 2
                                                                 r/1185)
                                                             temp/1676
                                                               (*. s/1186
                                                                 temp/1677)
                                                             temp/1671
                                                               (makearray 
                                                                 temp/1672
                                                                 temp/1674
                                                                 temp/1676))
                                                            (makeblock 0
                                                              match/1142
                                                              temp/1671))))))
                                                  (camlCode__intersects_1068(4+c) 
                                                    orig/1079 dir/1080
                                                    hit/1081 param/1146
                                                    env/1187
                                                    (if param/1146
                                                      (let
                                                        (temp/1758
                                                           (field 0
                                                             param/1146)
                                                         temp/1759
                                                           (offset[-4]
                                                             env/1187)
                                                         temp/1757
                                                           (camlCode__intersect_1067
                                                              orig/1079
                                                             dir/1080
                                                             hit/1081
                                                             temp/1758
                                                             temp/1759)
                                                         temp/1760
                                                           (field 1
                                                             param/1146))
                                                        (camlCode__intersects_1068
                                                           orig/1079 dir/1080
                                                          temp/1757 temp/1760
                                                          env/1187))
                                                      hit/1081)) {7} )
                                       temp/1668 (global camlCode!))
                                      (seq
                                        (seq
                                          (setfield_imm 9 temp/1668
                                            clos/1222)
                                          (let
                                            (temp/1666 (global camlCode!)
                                             temp/1667 (offset[4] clos/1222))
                                            (setfield_imm 10 temp/1666
                                              temp/1667)))
                                        (let
                                          (temp/1647 1.
                                           temp/1653 [|1. 3. -2.|]
                                           temp/1652 (floatfield 0 temp/1653)
                                           temp/1655 [|1. 3. -2.|]
                                           temp/1654 (floatfield 0 temp/1655)
                                           temp/1651 (*. temp/1652 temp/1654)
                                           temp/1658 [|1. 3. -2.|]
                                           temp/1657 (floatfield 1 temp/1658)
                                           temp/1660 [|1. 3. -2.|]
                                           temp/1659 (floatfield 1 temp/1660)
                                           temp/1656 (*. temp/1657 temp/1659)
                                           temp/1650 (+. temp/1651 temp/1656)
                                           temp/1663 [|1. 3. -2.|]
                                           temp/1662 (floatfield 2 temp/1663)
                                           temp/1665 [|1. 3. -2.|]
                                           temp/1664 (floatfield 2 temp/1665)
                                           temp/1661 (*. temp/1662 temp/1664)
                                           temp/1649 (+. temp/1650 temp/1661)
                                           temp/1648
                                             (caml_sqrt_float temp/1649)
                                           s/1223 (/. temp/1647 temp/1648)
                                           temp/1640 [|1. 3. -2.|]
                                           temp/1639 (floatfield 0 temp/1640)
                                           temp/1638 (*. s/1223 temp/1639)
                                           temp/1643 [|1. 3. -2.|]
                                           temp/1642 (floatfield 1 temp/1643)
                                           temp/1641 (*. s/1223 temp/1642)
                                           temp/1646 [|1. 3. -2.|]
                                           temp/1645 (floatfield 2 temp/1646)
                                           temp/1644 (*. s/1223 temp/1645)
                                           light/1084
                                             (makearray  temp/1638 temp/1641
                                               temp/1644)
                                           temp/1637 (global camlCode!))
                                          (seq
                                            (seq
                                              (setfield_imm 11 temp/1637
                                                light/1084)
                                              (let
                                                (temp/1635 (global camlCode!))
                                                (setfield_imm 12 temp/1635 4)))
                                            (let
                                              (ray_trace/1086
                                                 (closure (camlCode__ray_trace_1086(2) 
                                                            dir/1087
                                                            scene/1088
                                                            (let
                                                              (temp/1627
                                                                 (global camlCode!)
                                                               temp/1626
                                                                 (field 1
                                                                   temp/1627)
                                                               temp/1630
                                                                 (global camlPervasives!)
                                                               temp/1629
                                                                 (field 9
                                                                   temp/1630)
                                                               temp/1632
                                                                 (global camlCode!)
                                                               temp/1631
                                                                 (field 1
                                                                   temp/1632)
                                                               temp/1628
                                                                 (makeblock 0
                                                                   temp/1629
                                                                   temp/1631)
                                                               temp/1634
                                                                 (global camlCode!)
                                                               temp/1633
                                                                 (field 9
                                                                   temp/1634)
                                                               match/1148
                                                                 (camlCode__intersect_1067
                                                                    temp/1626
                                                                   dir/1087
                                                                   temp/1628
                                                                   scene/1088
                                                                   temp/1633)
                                                               n/1090[Alias]
                                                                 (field 1
                                                                   match/1148)
                                                               temp/1625
                                                                 (global camlCode!)
                                                               b/1225
                                                                 (field 11
                                                                   temp/1625)
                                                               temp/1617
                                                                 (floatfield 0
                                                                   n/1090)
                                                               temp/1618
                                                                 (floatfield 0
                                                                   b/1225)
                                                               temp/1616
                                                                 (*.
                                                                   temp/1617
                                                                   temp/1618)
                                                               temp/1620
                                                                 (floatfield 1
                                                                   n/1090)
                                                               temp/1621
                                                                 (floatfield 1
                                                                   b/1225)
                                                               temp/1619
                                                                 (*.
                                                                   temp/1620
                                                                   temp/1621)
                                                               temp/1615
                                                                 (+.
                                                                   temp/1616
                                                                   temp/1619)
                                                               temp/1623
                                                                 (floatfield 2
                                                                   n/1090)
                                                               temp/1624
                                                                 (floatfield 2
                                                                   b/1225)
                                                               temp/1622
                                                                 (*.
                                                                   temp/1623
                                                                   temp/1624)
                                                               g/1091
                                                                 (+.
                                                                   temp/1615
                                                                   temp/1622)
                                                               temp/1577 0.
                                                               temp/1576
                                                                 (<=. g/1091
                                                                   temp/1577))
                                                              (if temp/1576
                                                                0.
                                                                (let
                                                                  (temp/1614
                                                                    (global camlPervasives!)
                                                                   temp/1613
                                                                    (field 14
                                                                    temp/1614)
                                                                   s/1227
                                                                    (caml_sqrt_float
                                                                    temp/1613)
                                                                   temp/1608
                                                                    (floatfield 0
                                                                    n/1090)
                                                                   temp/1607
                                                                    (*.
                                                                    s/1227
                                                                    temp/1608)
                                                                   temp/1610
                                                                    (floatfield 1
                                                                    n/1090)
                                                                   temp/1609
                                                                    (*.
                                                                    s/1227
                                                                    temp/1610)
                                                                   temp/1612
                                                                    (floatfield 2
                                                                    n/1090)
                                                                   temp/1611
                                                                    (*.
                                                                    s/1227
                                                                    temp/1612)
                                                                   b/1228
                                                                    (makearray 
                                                                    temp/1607
                                                                    temp/1609
                                                                    temp/1611)
                                                                   s/1226
                                                                    (field 0
                                                                    match/1148)
                                                                   temp/1602
                                                                    (floatfield 0
                                                                    dir/1087)
                                                                   temp/1601
                                                                    (*.
                                                                    s/1226
                                                                    temp/1602)
                                                                   temp/1604
                                                                    (floatfield 1
                                                                    dir/1087)
                                                                   temp/1603
                                                                    (*.
                                                                    s/1226
                                                                    temp/1604)
                                                                   temp/1606
                                                                    (floatfield 2
                                                                    dir/1087)
                                                                   temp/1605
                                                                    (*.
                                                                    s/1226
                                                                    temp/1606)
                                                                   a/1229
                                                                    (makearray 
                                                                    temp/1601
                                                                    temp/1603
                                                                    temp/1605)
                                                                   temp/1593
                                                                    (floatfield 0
                                                                    a/1229)
                                                                   temp/1594
                                                                    (floatfield 0
                                                                    b/1228)
                                                                   temp/1592
                                                                    (+.
                                                                    temp/1593
                                                                    temp/1594)
                                                                   temp/1596
                                                                    (floatfield 1
                                                                    a/1229)
                                                                   temp/1597
                                                                    (floatfield 1
                                                                    b/1228)
                                                                   temp/1595
                                                                    (+.
                                                                    temp/1596
                                                                    temp/1597)
                                                                   temp/1599
                                                                    (floatfield 2
                                                                    a/1229)
                                                                   temp/1600
                                                                    (floatfield 2
                                                                    b/1228)
                                                                   temp/1598
                                                                    (+.
                                                                    temp/1599
                                                                    temp/1600)
                                                                   p/1092
                                                                    (makearray 
                                                                    temp/1592
                                                                    temp/1595
                                                                    temp/1598)
                                                                   temp/1582
                                                                    (global camlCode!)
                                                                   temp/1581
                                                                    (field 11
                                                                    temp/1582)
                                                                   temp/1585
                                                                    (global camlPervasives!)
                                                                   temp/1584
                                                                    (field 9
                                                                    temp/1585)
                                                                   temp/1587
                                                                    (global camlCode!)
                                                                   temp/1586
                                                                    (field 1
                                                                    temp/1587)
                                                                   temp/1583
                                                                    (makeblock 0
                                                                    temp/1584
                                                                    temp/1586)
                                                                   temp/1589
                                                                    (global camlCode!)
                                                                   temp/1588
                                                                    (field 9
                                                                    temp/1589)
                                                                   temp/1580
                                                                    (camlCode__intersect_1067
                                                                     p/1092
                                                                    temp/1581
                                                                    temp/1583
                                                                    scene/1088
                                                                    temp/1588)
                                                                   temp/1579
                                                                    (field 0
                                                                    temp/1580)
                                                                   temp/1591
                                                                    (global camlPervasives!)
                                                                   temp/1590
                                                                    (field 9
                                                                    temp/1591)
                                                                   temp/1578
                                                                    (<.
                                                                    temp/1579
                                                                    temp/1590))
                                                                  (if
                                                                    temp/1578
                                                                    0.
                                                                    g/1091))))) 
                                                   {3} )
                                               temp/1575 (global camlCode!))
                                              (seq
                                                (setfield_imm 13 temp/1575
                                                  ray_trace/1086)
                                                (let
                                                  (clos/1268
                                                     (closure (camlCode__create_1093(3+c) 
                                                                level/1094
                                                                c/1095 r/1096
                                                                env/1249
                                                                (let
                                                                  (obj/1097
                                                                    (makeblock 0
                                                                    c/1095
                                                                    r/1096
                                                                    0a)
                                                                   temp/1466
                                                                    (==
                                                                    level/1094
                                                                    1))
                                                                  (if
                                                                    temp/1466
                                                                    obj/1097
                                                                    (let
                                                                    (temp/1571
                                                                    3.
                                                                    temp/1570
                                                                    (*.
                                                                    temp/1571
                                                                    r/1096)
                                                                    temp/1573
                                                                    12.
                                                                    temp/1572
                                                                    (caml_sqrt_float
                                                                    temp/1573)
                                                                    a/1098
                                                                    (/.
                                                                    temp/1570
                                                                    temp/1572)
                                                                    temp/1469
                                                                    3.
                                                                    temp/1468
                                                                    (*.
                                                                    temp/1469
                                                                    r/1096)
                                                                    z'/1256
                                                                    (~.
                                                                    a/1098)
                                                                    x'/1257
                                                                    (~.
                                                                    a/1098)
                                                                    temp/1473
                                                                    (-
                                                                    level/1094
                                                                    1)
                                                                    b/1258
                                                                    (makearray 
                                                                    x'/1257
                                                                    a/1098
                                                                    z'/1256)
                                                                    temp/1478
                                                                    (floatfield 0
                                                                    c/1095)
                                                                    temp/1479
                                                                    (floatfield 0
                                                                    b/1258)
                                                                    temp/1477
                                                                    (+.
                                                                    temp/1478
                                                                    temp/1479)
                                                                    temp/1481
                                                                    (floatfield 1
                                                                    c/1095)
                                                                    temp/1482
                                                                    (floatfield 1
                                                                    b/1258)
                                                                    temp/1480
                                                                    (+.
                                                                    temp/1481
                                                                    temp/1482)
                                                                    temp/1484
                                                                    (floatfield 2
                                                                    c/1095)
                                                                    temp/1485
                                                                    (floatfield 2
                                                                    b/1258)
                                                                    temp/1483
                                                                    (+.
                                                                    temp/1484
                                                                    temp/1485)
                                                                    temp/1476
                                                                    (makearray 
                                                                    temp/1477
                                                                    temp/1480
                                                                    temp/1483)
                                                                    temp/1488
                                                                    0.5
                                                                    temp/1487
                                                                    (*.
                                                                    temp/1488
                                                                    r/1096)
                                                                    temp/1472
                                                                    (camlCode__create_1093
                                                                     temp/1473
                                                                    temp/1476
                                                                    temp/1487
                                                                    env/1249)
                                                                    z'/1260
                                                                    (~.
                                                                    a/1098)
                                                                    temp/1493
                                                                    (-
                                                                    level/1094
                                                                    1)
                                                                    b/1261
                                                                    (makearray 
                                                                    a/1098
                                                                    a/1098
                                                                    z'/1260)
                                                                    temp/1498
                                                                    (floatfield 0
                                                                    c/1095)
                                                                    temp/1499
                                                                    (floatfield 0
                                                                    b/1261)
                                                                    temp/1497
                                                                    (+.
                                                                    temp/1498
                                                                    temp/1499)
                                                                    temp/1501
                                                                    (floatfield 1
                                                                    c/1095)
                                                                    temp/1502
                                                                    (floatfield 1
                                                                    b/1261)
                                                                    temp/1500
                                                                    (+.
                                                                    temp/1501
                                                                    temp/1502)
                                                                    temp/1504
                                                                    (floatfield 2
                                                                    c/1095)
                                                                    temp/1505
                                                                    (floatfield 2
                                                                    b/1261)
                                                                    temp/1503
                                                                    (+.
                                                                    temp/1504
                                                                    temp/1505)
                                                                    temp/1496
                                                                    (makearray 
                                                                    temp/1497
                                                                    temp/1500
                                                                    temp/1503)
                                                                    temp/1508
                                                                    0.5
                                                                    temp/1507
                                                                    (*.
                                                                    temp/1508
                                                                    r/1096)
                                                                    temp/1492
                                                                    (camlCode__create_1093
                                                                     temp/1493
                                                                    temp/1496
                                                                    temp/1507
                                                                    env/1249)
                                                                    x'/1263
                                                                    (~.
                                                                    a/1098)
                                                                    temp/1513
                                                                    (-
                                                                    level/1094
                                                                    1)
                                                                    b/1264
                                                                    (makearray 
                                                                    x'/1263
                                                                    a/1098
                                                                    a/1098)
                                                                    temp/1518
                                                                    (floatfield 0
                                                                    c/1095)
                                                                    temp/1519
                                                                    (floatfield 0
                                                                    b/1264)
                                                                    temp/1517
                                                                    (+.
                                                                    temp/1518
                                                                    temp/1519)
                                                                    temp/1521
                                                                    (floatfield 1
                                                                    c/1095)
                                                                    temp/1522
                                                                    (floatfield 1
                                                                    b/1264)
                                                                    temp/1520
                                                                    (+.
                                                                    temp/1521
                                                                    temp/1522)
                                                                    temp/1524
                                                                    (floatfield 2
                                                                    c/1095)
                                                                    temp/1525
                                                                    (floatfield 2
                                                                    b/1264)
                                                                    temp/1523
                                                                    (+.
                                                                    temp/1524
                                                                    temp/1525)
                                                                    temp/1516
                                                                    (makearray 
                                                                    temp/1517
                                                                    temp/1520
                                                                    temp/1523)
                                                                    temp/1528
                                                                    0.5
                                                                    temp/1527
                                                                    (*.
                                                                    temp/1528
                                                                    r/1096)
                                                                    temp/1512
                                                                    (camlCode__create_1093
                                                                     temp/1513
                                                                    temp/1516
                                                                    temp/1527
                                                                    env/1249)
                                                                    temp/1533
                                                                    (-
                                                                    level/1094
                                                                    1)
                                                                    b/1266
                                                                    (makearray 
                                                                    a/1098
                                                                    a/1098
                                                                    a/1098)
                                                                    temp/1538
                                                                    (floatfield 0
                                                                    c/1095)
                                                                    temp/1539
                                                                    (floatfield 0
                                                                    b/1266)
                                                                    temp/1537
                                                                    (+.
                                                                    temp/1538
                                                                    temp/1539)
                                                                    temp/1541
                                                                    (floatfield 1
                                                                    c/1095)
                                                                    temp/1542
                                                                    (floatfield 1
                                                                    b/1266)
                                                                    temp/1540
                                                                    (+.
                                                                    temp/1541
                                                                    temp/1542)
                                                                    temp/1544
                                                                    (floatfield 2
                                                                    c/1095)
                                                                    temp/1545
                                                                    (floatfield 2
                                                                    b/1266)
                                                                    temp/1543
                                                                    (+.
                                                                    temp/1544
                                                                    temp/1545)
                                                                    temp/1536
                                                                    (makearray 
                                                                    temp/1537
                                                                    temp/1540
                                                                    temp/1543)
                                                                    temp/1548
                                                                    0.5
                                                                    temp/1547
                                                                    (*.
                                                                    temp/1548
                                                                    r/1096)
                                                                    temp/1532
                                                                    (camlCode__create_1093
                                                                     temp/1533
                                                                    temp/1536
                                                                    temp/1547
                                                                    env/1249)
                                                                    temp/1531
                                                                    (makeblock 0
                                                                    temp/1532
                                                                    0a)
                                                                    temp/1511
                                                                    (makeblock 0
                                                                    temp/1512
                                                                    temp/1531)
                                                                    temp/1491
                                                                    (makeblock 0
                                                                    temp/1492
                                                                    temp/1511)
                                                                    temp/1471
                                                                    (makeblock 0
                                                                    temp/1472
                                                                    temp/1491)
                                                                    temp/1470
                                                                    (makeblock 0
                                                                    obj/1097
                                                                    temp/1471))
                                                                    (makeblock 0
                                                                    c/1095
                                                                    temp/1468
                                                                    temp/1470))))) 
                                                       {3} )
                                                   temp/1465
                                                     (global camlCode!))
                                                  (seq
                                                    (setfield_imm 14
                                                      temp/1465 clos/1268)
                                                    (let
                                                      (match/1151
                                                         (try
                                                           (let
                                                             (temp/1458
                                                                (global camlSys!)
                                                              temp/1457
                                                                (field 0
                                                                  temp/1458)
                                                              temp/1456
                                                                (array.get
                                                                  temp/1457
                                                                  1)
                                                              temp/1455
                                                                (caml_int_of_string
                                                                  temp/1456)
                                                              temp/1463
                                                                (global camlSys!)
                                                              temp/1462
                                                                (field 0
                                                                  temp/1463)
                                                              temp/1461
                                                                (array.get
                                                                  temp/1462
                                                                  2)
                                                              temp/1460
                                                                (caml_int_of_string
                                                                  temp/1461))
                                                             (makeblock 0
                                                               temp/1455
                                                               temp/1460))
                                                          with exn/1150
                                                           [0: 6 512])
                                                       temp/1453
                                                         (global camlCode!)
                                                       temp/1454
                                                         (field 0 match/1151))
                                                      (seq
                                                        (seq
                                                          (setfield_imm 15
                                                            temp/1453
                                                            temp/1454)
                                                          (let
                                                            (temp/1451
                                                               (global camlCode!)
                                                             temp/1452
                                                               (field 1
                                                                 match/1151))
                                                            (setfield_imm 16
                                                              temp/1451
                                                              temp/1452)))
                                                        (let
                                                          (temp/1446
                                                             (global camlCode!)
                                                           temp/1445
                                                             (field 15
                                                               temp/1446)
                                                           temp/1447
                                                             [|0. -1. 4.|]
                                                           temp/1448 1.
                                                           temp/1450
                                                             (global camlCode!)
                                                           temp/1449
                                                             (field 14
                                                               temp/1450)
                                                           scene/1104
                                                             (camlCode__create_1093
                                                                temp/1445
                                                               temp/1447
                                                               temp/1448
                                                               temp/1449)
                                                           temp/1444
                                                             (global camlCode!))
                                                          (seq
                                                            (setfield_imm 17
                                                              temp/1444
                                                              scene/1104)
                                                            (let
                                                              (temp/1438
                                                                 (global camlPervasives!)
                                                               temp/1437
                                                                 (field 23
                                                                   temp/1438)
                                                               temp/1436
                                                                 (camlPrintf__fprintf_1392
                                                                    temp/1437)
                                                               temp/1439
                                                                 "P5\n%d %d\n255\n"
                                                               temp/1435
                                                                 (apply
                                                                   temp/1436
                                                                   temp/1439)
                                                               temp/1441
                                                                 (global camlCode!)
                                                               temp/1440
                                                                 (field 16
                                                                   temp/1441)
                                                               temp/1443
                                                                 (global camlCode!)
                                                               temp/1442
                                                                 (field 16
                                                                   temp/1443))
                                                              (seq
                                                                (seq
                                                                  (apply
                                                                    temp/1435
                                                                    temp/1440
                                                                    temp/1442)
                                                                  (let
                                                                    (temp/1285
                                                                    (global camlCode!)
                                                                    temp/1284
                                                                    (field 16
                                                                    temp/1285)
                                                                    temp/1283
                                                                    (-
                                                                    temp/1284
                                                                    1))
                                                                    (for y/1105
                                                                    temp/1283
                                                                    downto 0
                                                                    (let
                                                                    (temp/1291
                                                                    (global camlCode!)
                                                                    temp/1290
                                                                    (field 16
                                                                    temp/1291)
                                                                    temp/1289
                                                                    (-
                                                                    temp/1290
                                                                    1))
                                                                    (for x/1106
                                                                    0 to
                                                                    temp/1289
                                                                    (let
                                                                    (g/1107[Variable]
                                                                    0.)
                                                                    (seq
                                                                    (for dx/1108
                                                                    0 to 3
                                                                    (for dy/1109
                                                                    0 to 3
                                                                    (let
                                                                    (temp/1399
                                                                    (float_of_int
                                                                    x/1106)
                                                                    temp/1403
                                                                    (global camlCode!)
                                                                    temp/1402
                                                                    (field 16
                                                                    temp/1403)
                                                                    temp/1401
                                                                    (float_of_int
                                                                    temp/1402)
                                                                    temp/1404
                                                                    2.
                                                                    temp/1400
                                                                    (/.
                                                                    temp/1401
                                                                    temp/1404)
                                                                    temp/1398
                                                                    (-.
                                                                    temp/1399
                                                                    temp/1400)
                                                                    temp/1406
                                                                    (float_of_int
                                                                    dx/1108)
                                                                    temp/1407
                                                                    (float_of_int
                                                                    4)
                                                                    temp/1405
                                                                    (/.
                                                                    temp/1406
                                                                    temp/1407)
                                                                    temp/1397
                                                                    (+.
                                                                    temp/1398
                                                                    temp/1405)
                                                                    temp/1411
                                                                    (float_of_int
                                                                    y/1105)
                                                                    temp/1415
                                                                    (global camlCode!)
                                                                    temp/1414
                                                                    (field 16
                                                                    temp/1415)
                                                                    temp/1413
                                                                    (float_of_int
                                                                    temp/1414)
                                                                    temp/1416
                                                                    2.
                                                                    temp/1412
                                                                    (/.
                                                                    temp/1413
                                                                    temp/1416)
                                                                    temp/1410
                                                                    (-.
                                                                    temp/1411
                                                                    temp/1412)
                                                                    temp/1418
                                                                    (float_of_int
                                                                    dy/1109)
                                                                    temp/1419
                                                                    (float_of_int
                                                                    4)
                                                                    temp/1417
                                                                    (/.
                                                                    temp/1418
                                                                    temp/1419)
                                                                    temp/1409
                                                                    (+.
                                                                    temp/1410
                                                                    temp/1417)
                                                                    temp/1423
                                                                    (global camlCode!)
                                                                    temp/1422
                                                                    (field 16
                                                                    temp/1423)
                                                                    temp/1421
                                                                    (float_of_int
                                                                    temp/1422)
                                                                    r/1270
                                                                    (makearray 
                                                                    temp/1397
                                                                    temp/1409
                                                                    temp/1421)
                                                                    temp/1384
                                                                    1.
                                                                    temp/1389
                                                                    (floatfield 0
                                                                    r/1270)
                                                                    temp/1390
                                                                    (floatfield 0
                                                                    r/1270)
                                                                    temp/1388
                                                                    (*.
                                                                    temp/1389
                                                                    temp/1390)
                                                                    temp/1392
                                                                    (floatfield 1
                                                                    r/1270)
                                                                    temp/1393
                                                                    (floatfield 1
                                                                    r/1270)
                                                                    temp/1391
                                                                    (*.
                                                                    temp/1392
                                                                    temp/1393)
                                                                    temp/1387
                                                                    (+.
                                                                    temp/1388
                                                                    temp/1391)
                                                                    temp/1395
                                                                    (floatfield 2
                                                                    r/1270)
                                                                    temp/1396
                                                                    (floatfield 2
                                                                    r/1270)
                                                                    temp/1394
                                                                    (*.
                                                                    temp/1395
                                                                    temp/1396)
                                                                    temp/1386
                                                                    (+.
                                                                    temp/1387
                                                                    temp/1394)
                                                                    temp/1385
                                                                    (caml_sqrt_float
                                                                    temp/1386)
                                                                    s/1271
                                                                    (/.
                                                                    temp/1384
                                                                    temp/1385)
                                                                    temp/1379
                                                                    (floatfield 0
                                                                    r/1270)
                                                                    temp/1378
                                                                    (*.
                                                                    s/1271
                                                                    temp/1379)
                                                                    temp/1381
                                                                    (floatfield 1
                                                                    r/1270)
                                                                    temp/1380
                                                                    (*.
                                                                    s/1271
                                                                    temp/1381)
                                                                    temp/1383
                                                                    (floatfield 2
                                                                    r/1270)
                                                                    temp/1382
                                                                    (*.
                                                                    s/1271
                                                                    temp/1383)
                                                                    dir/1113
                                                                    (makearray 
                                                                    temp/1378
                                                                    temp/1380
                                                                    temp/1382)
                                                                    temp/1377
                                                                    (global camlCode!)
                                                                    scene/1272
                                                                    (field 17
                                                                    temp/1377)
                                                                    temp/1369
                                                                    (global camlCode!)
                                                                    temp/1368
                                                                    (field 1
                                                                    temp/1369)
                                                                    temp/1372
                                                                    (global camlPervasives!)
                                                                    temp/1371
                                                                    (field 9
                                                                    temp/1372)
                                                                    temp/1374
                                                                    (global camlCode!)
                                                                    temp/1373
                                                                    (field 1
                                                                    temp/1374)
                                                                    temp/1370
                                                                    (makeblock 0
                                                                    temp/1371
                                                                    temp/1373)
                                                                    temp/1376
                                                                    (global camlCode!)
                                                                    temp/1375
                                                                    (field 9
                                                                    temp/1376)
                                                                    match/1273
                                                                    (camlCode__intersect_1067
                                                                     temp/1368
                                                                    dir/1113
                                                                    temp/1370
                                                                    scene/1272
                                                                    temp/1375)
                                                                    temp/1317
                                                                    (let
                                                                    (n/1274[Alias]
                                                                    (field 1
                                                                    match/1273)
                                                                    temp/1367
                                                                    (global camlCode!)
                                                                    b/1281
                                                                    (field 11
                                                                    temp/1367)
                                                                    temp/1359
                                                                    (floatfield 0
                                                                    n/1274)
                                                                    temp/1360
                                                                    (floatfield 0
                                                                    b/1281)
                                                                    temp/1358
                                                                    (*.
                                                                    temp/1359
                                                                    temp/1360)
                                                                    temp/1362
                                                                    (floatfield 1
                                                                    n/1274)
                                                                    temp/1363
                                                                    (floatfield 1
                                                                    b/1281)
                                                                    temp/1361
                                                                    (*.
                                                                    temp/1362
                                                                    temp/1363)
                                                                    temp/1357
                                                                    (+.
                                                                    temp/1358
                                                                    temp/1361)
                                                                    temp/1365
                                                                    (floatfield 2
                                                                    n/1274)
                                                                    temp/1366
                                                                    (floatfield 2
                                                                    b/1281)
                                                                    temp/1364
                                                                    (*.
                                                                    temp/1365
                                                                    temp/1366)
                                                                    g/1275
                                                                    (+.
                                                                    temp/1357
                                                                    temp/1364)
                                                                    temp/1319
                                                                    0.
                                                                    temp/1318
                                                                    (<=.
                                                                    g/1275
                                                                    temp/1319))
                                                                    (if
                                                                    temp/1318
                                                                    0.
                                                                    (let
                                                                    (temp/1356
                                                                    (global camlPervasives!)
                                                                    temp/1355
                                                                    (field 14
                                                                    temp/1356)
                                                                    s/1280
                                                                    (caml_sqrt_float
                                                                    temp/1355)
                                                                    temp/1350
                                                                    (floatfield 0
                                                                    n/1274)
                                                                    temp/1349
                                                                    (*.
                                                                    s/1280
                                                                    temp/1350)
                                                                    temp/1352
                                                                    (floatfield 1
                                                                    n/1274)
                                                                    temp/1351
                                                                    (*.
                                                                    s/1280
                                                                    temp/1352)
                                                                    temp/1354
                                                                    (floatfield 2
                                                                    n/1274)
                                                                    temp/1353
                                                                    (*.
                                                                    s/1280
                                                                    temp/1354)
                                                                    b/1277
                                                                    (makearray 
                                                                    temp/1349
                                                                    temp/1351
                                                                    temp/1353)
                                                                    s/1279
                                                                    (field 0
                                                                    match/1273)
                                                                    temp/1344
                                                                    (floatfield 0
                                                                    dir/1113)
                                                                    temp/1343
                                                                    (*.
                                                                    s/1279
                                                                    temp/1344)
                                                                    temp/1346
                                                                    (floatfield 1
                                                                    dir/1113)
                                                                    temp/1345
                                                                    (*.
                                                                    s/1279
                                                                    temp/1346)
                                                                    temp/1348
                                                                    (floatfield 2
                                                                    dir/1113)
                                                                    temp/1347
                                                                    (*.
                                                                    s/1279
                                                                    temp/1348)
                                                                    a/1278
                                                                    (makearray 
                                                                    temp/1343
                                                                    temp/1345
                                                                    temp/1347)
                                                                    temp/1335
                                                                    (floatfield 0
                                                                    a/1278)
                                                                    temp/1336
                                                                    (floatfield 0
                                                                    b/1277)
                                                                    temp/1334
                                                                    (+.
                                                                    temp/1335
                                                                    temp/1336)
                                                                    temp/1338
                                                                    (floatfield 1
                                                                    a/1278)
                                                                    temp/1339
                                                                    (floatfield 1
                                                                    b/1277)
                                                                    temp/1337
                                                                    (+.
                                                                    temp/1338
                                                                    temp/1339)
                                                                    temp/1341
                                                                    (floatfield 2
                                                                    a/1278)
                                                                    temp/1342
                                                                    (floatfield 2
                                                                    b/1277)
                                                                    temp/1340
                                                                    (+.
                                                                    temp/1341
                                                                    temp/1342)
                                                                    p/1276
                                                                    (makearray 
                                                                    temp/1334
                                                                    temp/1337
                                                                    temp/1340)
                                                                    temp/1324
                                                                    (global camlCode!)
                                                                    temp/1323
                                                                    (field 11
                                                                    temp/1324)
                                                                    temp/1327
                                                                    (global camlPervasives!)
                                                                    temp/1326
                                                                    (field 9
                                                                    temp/1327)
                                                                    temp/1329
                                                                    (global camlCode!)
                                                                    temp/1328
                                                                    (field 1
                                                                    temp/1329)
                                                                    temp/1325
                                                                    (makeblock 0
                                                                    temp/1326
                                                                    temp/1328)
                                                                    temp/1331
                                                                    (global camlCode!)
                                                                    temp/1330
                                                                    (field 9
                                                                    temp/1331)
                                                                    temp/1322
                                                                    (camlCode__intersect_1067
                                                                     p/1276
                                                                    temp/1323
                                                                    temp/1325
                                                                    scene/1272
                                                                    temp/1330)
                                                                    temp/1321
                                                                    (field 0
                                                                    temp/1322)
                                                                    temp/1333
                                                                    (global camlPervasives!)
                                                                    temp/1332
                                                                    (field 9
                                                                    temp/1333)
                                                                    temp/1320
                                                                    (<.
                                                                    temp/1321
                                                                    temp/1332))
                                                                    (if
                                                                    temp/1320
                                                                    0.
                                                                    g/1275))))
                                                                    temp/1316
                                                                    (+.
                                                                    g/1107
                                                                    temp/1317))
                                                                    (assign
                                                                    g/1107
                                                                    temp/1316))))
                                                                    (let
                                                                    (temp/1306
                                                                    0.5
                                                                    temp/1309
                                                                    255.
                                                                    temp/1308
                                                                    (*.
                                                                    temp/1309
                                                                    g/1107)
                                                                    temp/1310
                                                                    (float_of_int
                                                                    16)
                                                                    temp/1307
                                                                    (/.
                                                                    temp/1308
                                                                    temp/1310)
                                                                    g/1114
                                                                    (+.
                                                                    temp/1306
                                                                    temp/1307)
                                                                    temp/1296
                                                                    (global camlPervasives!)
                                                                    temp/1295
                                                                    (field 23
                                                                    temp/1296)
                                                                    temp/1294
                                                                    (camlPrintf__fprintf_1392
                                                                     temp/1295)
                                                                    temp/1297
                                                                    "%c"
                                                                    temp/1293
                                                                    (apply
                                                                    temp/1294
                                                                    temp/1297)
                                                                    n/1282
                                                                    (int_of_float
                                                                    g/1114)
                                                                    temp/1300
                                                                    (< n/1282
                                                                    0)
                                                                    temp/1299
                                                                    (if
                                                                    temp/1300
                                                                    1a
                                                                    (> n/1282
                                                                    255))
                                                                    temp/1298
                                                                    (if
                                                                    temp/1299
                                                                    (let
                                                                    (temp/1304
                                                                    (global caml_exn_Invalid_argument!)
                                                                    temp/1305
                                                                    "char_of_int"
                                                                    temp/1303
                                                                    (makeblock 0
                                                                    temp/1304
                                                                    temp/1305))
                                                                    (raise
                                                                    temp/1303))
                                                                    (id
                                                                    n/1282)))
                                                                    (apply
                                                                    temp/1293
                                                                    temp/1298)))))))))
                                                                0a))))))))))))))))))))))))))))))))
[times] TonSlambda.optimize: 0.008 s
[times] Cmmgen.compunit: 0.040 s
[times] Asmgen.compile_phrases: 0.312 s

-dcmm
[times] TonLambda.optimize: 0.000 s
[times] Closure.intro: 0.000 s
[times] TonSlambda.optimize: 0.008 s
[times] TonClosure.optimize: 0.044 s
[times] TonSlambda.optimize: 0.012 s
[times] Cmmgen.compunit: 0.028 s
(data int 18432 global "camlCode" "camlCode": skip 72)
(data
 int 3319
 "camlCode__9":
 addr "caml_curry3"
 int 7
 addr "camlCode__create_1093")
(data
 int 3319
 "camlCode__10":
 addr "caml_curry2"
 int 5
 addr "camlCode__ray_trace_1086")
(data
 int 7415
 "camlCode__11":
 addr "caml_curry4"
 int 9
 addr "camlCode__intersect_1067"
 int 4345
 addr "caml_curry4"
 int 9
 addr "camlCode__intersects_1068")
(data
 int 3319
 "camlCode__12":
 addr "caml_curry4"
 int 9
 addr "camlCode__ray_sphere_1056")
(data int 2295 "camlCode__13": addr "camlCode__unitise_1054" int 3)
(data int 2295 "camlCode__14": addr "camlCode__length_1052" int 3)
(data
 int 3319
 "camlCode__15":
 addr "caml_curry2"
 int 5
 addr "camlCode__dot_1049")
(data
 int 3319
 "camlCode__16":
 addr "caml_curry2"
 int 5
 addr "camlCode__-|_1046")
(data
 int 3319
 "camlCode__17":
 addr "caml_curry2"
 int 5
 addr "camlCode__+|_1043")
(data
 int 3319
 "camlCode__18":
 addr "caml_curry2"
 int 5
 addr "camlCode__*|_1040")
(data
 global "camlCode__1"
 int 6398
 "camlCode__1":
 double 0.
 double 0.
 double 0.)
(data
 global "camlCode__2"
 int 6398
 "camlCode__2":
 double 1.
 double 3.
 double -2.)
(data global "camlCode__3" int 2048 "camlCode__3": int 13 int 1025)
(data
 global "camlCode__4"
 int 6398
 "camlCode__4":
 double 0.
 double -1.
 double 4.)
(data
 global "camlCode__5"
 int 4348
 "camlCode__5":
 string "P5
%d %d
255
"
 skip 2
 byte 2)
(data global "camlCode__6" int 1276 "camlCode__6": string "%c" skip 1 byte 1)
(data int 2301 "camlCode__7": double 0.)
(data int 2301 "camlCode__8": double 0.)
(data int 2301 "camlCode__19": double 0.)
(data int 2301 "camlCode__20": double 0.)
(function camlCode__*|_1040 (s/1041: addr r/1042: addr)
 (let
   (temp/2287 (load float64u r/1042)
    temp/2286 (*f (load float64u s/1041) temp/2287)
    temp/2285 (load float64u (+a r/1042 8))
    temp/2284 (*f (load float64u s/1041) temp/2285)
    temp/2283 (load float64u (+a r/1042 16))
    temp/2282 (*f (load float64u s/1041) temp/2283))
   (alloc[254] 6398 temp/2286 temp/2284 temp/2282)))

(function camlCode__+|_1043 (a/1044: addr b/1045: addr)
 (let
   (temp/2281 (load float64u a/1044) temp/2280 (load float64u b/1045)
    temp/2279 (+f temp/2281 temp/2280)
    temp/2278 (load float64u (+a a/1044 8))
    temp/2277 (load float64u (+a b/1045 8))
    temp/2276 (+f temp/2278 temp/2277)
    temp/2275 (load float64u (+a a/1044 16))
    temp/2274 (load float64u (+a b/1045 16))
    temp/2273 (+f temp/2275 temp/2274))
   (alloc[254] 6398 temp/2279 temp/2276 temp/2273)))

(function camlCode__-|_1046 (a/1047: addr b/1048: addr)
 (let
   (temp/2272 (load float64u a/1047) temp/2271 (load float64u b/1048)
    temp/2270 (-f temp/2272 temp/2271)
    temp/2269 (load float64u (+a a/1047 8))
    temp/2268 (load float64u (+a b/1048 8))
    temp/2267 (-f temp/2269 temp/2268)
    temp/2266 (load float64u (+a a/1047 16))
    temp/2265 (load float64u (+a b/1048 16))
    temp/2264 (-f temp/2266 temp/2265))
   (alloc[254] 6398 temp/2270 temp/2267 temp/2264)))

(function camlCode__dot_1049 (a/1050: addr b/1051: addr)
 (let
   (temp/2263 (load float64u a/1050) temp/2262 (load float64u b/1051)
    temp/2261 (*f temp/2263 temp/2262)
    temp/2260 (load float64u (+a a/1050 8))
    temp/2259 (load float64u (+a b/1051 8))
    temp/2258 (*f temp/2260 temp/2259) temp/2257 (+f temp/2261 temp/2258)
    temp/2256 (load float64u (+a a/1050 16))
    temp/2255 (load float64u (+a b/1051 16))
    temp/2254 (*f temp/2256 temp/2255))
   (alloc[253] 2301 (+f temp/2257 temp/2254))))

(function camlCode__length_1052 (r/1053: addr)
 (let
   (temp/2253 (load float64u r/1053) temp/2252 (load float64u r/1053)
    temp/2251 (*f temp/2253 temp/2252)
    temp/2250 (load float64u (+a r/1053 8))
    temp/2249 (load float64u (+a r/1053 8))
    temp/2248 (*f temp/2250 temp/2249) temp/2247 (+f temp/2251 temp/2248)
    temp/2246 (load float64u (+a r/1053 16))
    temp/2245 (load float64u (+a r/1053 16))
    temp/2244 (*f temp/2246 temp/2245) temp/2243 (+f temp/2247 temp/2244))
   (alloc[253] 2301 (extcall "sqrt" temp/2243 float))))

(function camlCode__unitise_1054 (r/1055: addr)
 (let
   (temp/2242 1. temp/2241 (load float64u r/1055)
    temp/2240 (load float64u r/1055) temp/2239 (*f temp/2241 temp/2240)
    temp/2238 (load float64u (+a r/1055 8))
    temp/2237 (load float64u (+a r/1055 8))
    temp/2236 (*f temp/2238 temp/2237) temp/2235 (+f temp/2239 temp/2236)
    temp/2234 (load float64u (+a r/1055 16))
    temp/2233 (load float64u (+a r/1055 16))
    temp/2232 (*f temp/2234 temp/2233) temp/2231 (+f temp/2235 temp/2232)
    temp/2230 (extcall "sqrt" temp/2231 float)
    s/2229 (/f temp/2242 temp/2230) temp/2228 (load float64u r/1055)
    temp/2227 (*f s/2229 temp/2228) temp/2226 (load float64u (+a r/1055 8))
    temp/2225 (*f s/2229 temp/2226) temp/2224 (load float64u (+a r/1055 16))
    temp/2223 (*f s/2229 temp/2224))
   (alloc[254] 6398 temp/2227 temp/2225 temp/2223)))

(function camlCode__ray_sphere_1056
     (orig/1057: addr dir/1058: addr center/1059: addr radius/1060: addr)
 (let
   (temp/2222 (load float64u center/1059) temp/2221 (load float64u orig/1057)
    temp/2220 (-f temp/2222 temp/2221)
    temp/2219 (load float64u (+a center/1059 8))
    temp/2218 (load float64u (+a orig/1057 8))
    temp/2217 (-f temp/2219 temp/2218)
    temp/2216 (load float64u (+a center/1059 16))
    temp/2215 (load float64u (+a orig/1057 16))
    temp/2214 (-f temp/2216 temp/2215)
    v/1061 (alloc[254] 6398 temp/2220 temp/2217 temp/2214)
    temp/2213 (load float64u v/1061) temp/2212 (load float64u dir/1058)
    temp/2211 (*f temp/2213 temp/2212)
    temp/2210 (load float64u (+a v/1061 8))
    temp/2209 (load float64u (+a dir/1058 8))
    temp/2208 (*f temp/2210 temp/2209) temp/2207 (+f temp/2211 temp/2208)
    temp/2206 (load float64u (+a v/1061 16))
    temp/2205 (load float64u (+a dir/1058 16))
    temp/2204 (*f temp/2206 temp/2205) b/2203 (+f temp/2207 temp/2204)
    temp/2202 (*f b/2203 b/2203) temp/2201 (load float64u v/1061)
    temp/2200 (load float64u v/1061) temp/2199 (*f temp/2201 temp/2200)
    temp/2198 (load float64u (+a v/1061 8))
    temp/2197 (load float64u (+a v/1061 8))
    temp/2196 (*f temp/2198 temp/2197) temp/2195 (+f temp/2199 temp/2196)
    temp/2194 (load float64u (+a v/1061 16))
    temp/2193 (load float64u (+a v/1061 16))
    temp/2192 (*f temp/2194 temp/2193) temp/2191 (+f temp/2195 temp/2192)
    temp/2190 (-f temp/2202 temp/2191)
    temp/2189 (*f (load float64u radius/1060) (load float64u radius/1060))
    d2/2188 (+f temp/2190 temp/2189) temp/2187 0.
    temp/1762 (+ (<< (<f d2/2188 temp/2187) 1) 1))
   (if (!= temp/1762 1)
     (let temp/1769 "camlPervasives" (load (+a temp/1769 36)))
     (let
       (d/2186 (extcall "sqrt" d2/2188 float) t1/2185 (-f b/2203 d/2186)
        t2/2184 (+f b/2203 d/2186) temp/2183 0.
        temp/1764 (+ (<< (>f t2/2184 temp/2183) 1) 1))
       (if (!= temp/1764 1)
         (let (temp/2182 0. temp/1767 (+ (<< (>f t1/2185 temp/2182) 1) 1))
           (if (!= temp/1767 1) (alloc[253] 2301 t1/2185)
             (alloc[253] 2301 t2/2184)))
         (let temp/1766 "camlPervasives" (load (+a temp/1766 36))))))))

(function camlCode__intersects_1068
     (orig/1079: addr dir/1080: addr hit/1081: addr param/1146: addr
      env/1187: addr)
 (if (!= param/1146 1)
   (let
     (temp/1758 (load param/1146) temp/1759 (+a env/1187 -16)
      temp/1757
        (app "camlCode__intersect_1067" orig/1079 dir/1080 hit/1081 temp/1758
          temp/1759 addr)
      temp/1760 (load (+a param/1146 4)))
     (app "camlCode__intersects_1068" orig/1079 dir/1080 temp/1757 temp/1760
       env/1187 addr))
   hit/1081))

(function camlCode__intersect_1067
     (orig/1069: addr dir/1070: addr hit/1072: addr param/1141: addr
      env/1175: addr)
 (let
   (scene/1075[Alias] (load (+a param/1141 8))
    center/1073[Alias] (load param/1141) radius/1176 (load (+a param/1141 4))
    temp/2181 (load float64u center/1073) temp/2180 (load float64u orig/1069)
    temp/2179 (-f temp/2181 temp/2180)
    temp/2178 (load float64u (+a center/1073 8))
    temp/2177 (load float64u (+a orig/1069 8))
    temp/2176 (-f temp/2178 temp/2177)
    temp/2175 (load float64u (+a center/1073 16))
    temp/2174 (load float64u (+a orig/1069 16))
    temp/2173 (-f temp/2175 temp/2174)
    v/1177 (alloc[254] 6398 temp/2179 temp/2176 temp/2173)
    temp/2172 (load float64u v/1177) temp/2171 (load float64u dir/1070)
    temp/2170 (*f temp/2172 temp/2171)
    temp/2169 (load float64u (+a v/1177 8))
    temp/2168 (load float64u (+a dir/1070 8))
    temp/2167 (*f temp/2169 temp/2168) temp/2166 (+f temp/2170 temp/2167)
    temp/2165 (load float64u (+a v/1177 16))
    temp/2164 (load float64u (+a dir/1070 16))
    temp/2163 (*f temp/2165 temp/2164) b/2162 (+f temp/2166 temp/2163)
    temp/2161 (*f b/2162 b/2162) temp/2160 (load float64u v/1177)
    temp/2159 (load float64u v/1177) temp/2158 (*f temp/2160 temp/2159)
    temp/2157 (load float64u (+a v/1177 8))
    temp/2156 (load float64u (+a v/1177 8))
    temp/2155 (*f temp/2157 temp/2156) temp/2154 (+f temp/2158 temp/2155)
    temp/2153 (load float64u (+a v/1177 16))
    temp/2152 (load float64u (+a v/1177 16))
    temp/2151 (*f temp/2153 temp/2152) temp/2150 (+f temp/2154 temp/2151)
    temp/2149 (-f temp/2161 temp/2150)
    temp/2148 (*f (load float64u radius/1176) (load float64u radius/1176))
    d2/2147 (+f temp/2149 temp/2148) temp/2146 0.
    temp/1716 (+ (<< (<f d2/2147 temp/2146) 1) 1)
    match/1142
      (if (!= temp/1716 1)
        (let temp/1723 "camlPervasives" (load (+a temp/1723 36)))
        (let
          (d/2145 (extcall "sqrt" d2/2147 float) t1/2144 (-f b/2162 d/2145)
           t2/2143 (+f b/2162 d/2145) temp/2142 0.
           temp/1718 (+ (<< (>f t2/2143 temp/2142) 1) 1))
          (if (!= temp/1718 1)
            (let (temp/2141 0. temp/1721 (+ (<< (>f t1/2144 temp/2141) 1) 1))
              (if (!= temp/1721 1) (alloc[253] 2301 t1/2144)
                (alloc[253] 2301 t2/2143)))
            (let temp/1720 "camlPervasives" (load (+a temp/1720 36))))))
    temp/1670 (load hit/1072)
    temp/1669
      (+ (<< (>=f (load float64u match/1142) (load float64u temp/1670)) 1) 1))
   (if (!= temp/1669 1) hit/1072
     (if (!= scene/1075 1)
       (let temp/1715 (+a env/1175 16)
         (app "camlCode__intersects_1068" orig/1069 dir/1070 hit/1072
           scene/1075 temp/1715 addr))
       (let
         (temp/2140 (load float64u dir/1070)
          temp/2139 (*f (load float64u match/1142) temp/2140)
          temp/2138 (load float64u (+a dir/1070 8))
          temp/2137 (*f (load float64u match/1142) temp/2138)
          temp/2136 (load float64u (+a dir/1070 16))
          temp/2135 (*f (load float64u match/1142) temp/2136)
          b/1183 (alloc[254] 6398 temp/2139 temp/2137 temp/2135)
          temp/2134 (load float64u orig/1069)
          temp/2133 (load float64u b/1183) temp/2132 (+f temp/2134 temp/2133)
          temp/2131 (load float64u (+a orig/1069 8))
          temp/2130 (load float64u (+a b/1183 8))
          temp/2129 (+f temp/2131 temp/2130)
          temp/2128 (load float64u (+a orig/1069 16))
          temp/2127 (load float64u (+a b/1183 16))
          temp/2126 (+f temp/2128 temp/2127)
          a/1184 (alloc[254] 6398 temp/2132 temp/2129 temp/2126)
          temp/2125 (load float64u a/1184)
          temp/2124 (load float64u center/1073)
          temp/2123 (-f temp/2125 temp/2124)
          temp/2122 (load float64u (+a a/1184 8))
          temp/2121 (load float64u (+a center/1073 8))
          temp/2120 (-f temp/2122 temp/2121)
          temp/2119 (load float64u (+a a/1184 16))
          temp/2118 (load float64u (+a center/1073 16))
          temp/2117 (-f temp/2119 temp/2118)
          r/1185 (alloc[254] 6398 temp/2123 temp/2120 temp/2117) temp/2116 1.
          temp/2115 (load float64u r/1185) temp/2114 (load float64u r/1185)
          temp/2113 (*f temp/2115 temp/2114)
          temp/2112 (load float64u (+a r/1185 8))
          temp/2111 (load float64u (+a r/1185 8))
          temp/2110 (*f temp/2112 temp/2111)
          temp/2109 (+f temp/2113 temp/2110)
          temp/2108 (load float64u (+a r/1185 16))
          temp/2107 (load float64u (+a r/1185 16))
          temp/2106 (*f temp/2108 temp/2107)
          temp/2105 (+f temp/2109 temp/2106)
          temp/2104 (extcall "sqrt" temp/2105 float)
          s/2103 (/f temp/2116 temp/2104) temp/2102 (load float64u r/1185)
          temp/2101 (*f s/2103 temp/2102)
          temp/2100 (load float64u (+a r/1185 8))
          temp/2099 (*f s/2103 temp/2100)
          temp/2098 (load float64u (+a r/1185 16))
          temp/2097 (*f s/2103 temp/2098)
          temp/1671 (alloc[254] 6398 temp/2101 temp/2099 temp/2097))
         (alloc[0] 2048 match/1142 temp/1671))))))

(function camlCode__ray_trace_1086 (dir/1087: addr scene/1088: addr)
 (let
   (temp/1627 "camlCode" temp/1626 (load (+a temp/1627 4))
    temp/1630 "camlPervasives" temp/1629 (load (+a temp/1630 36))
    temp/1632 "camlCode" temp/1631 (load (+a temp/1632 4))
    temp/1628 (alloc[0] 2048 temp/1629 temp/1631) temp/1634 "camlCode"
    temp/1633 (load (+a temp/1634 36))
    match/1148
      (app "camlCode__intersect_1067" temp/1626 dir/1087 temp/1628 scene/1088
        temp/1633 addr)
    n/1090[Alias] (load (+a match/1148 4)) temp/1625 "camlCode"
    b/1225 (load (+a temp/1625 44)) temp/2096 (load float64u n/1090)
    temp/2095 (load float64u b/1225) temp/2094 (*f temp/2096 temp/2095)
    temp/2093 (load float64u (+a n/1090 8))
    temp/2092 (load float64u (+a b/1225 8))
    temp/2091 (*f temp/2093 temp/2092) temp/2090 (+f temp/2094 temp/2091)
    temp/2089 (load float64u (+a n/1090 16))
    temp/2088 (load float64u (+a b/1225 16))
    temp/2087 (*f temp/2089 temp/2088) g/2086 (+f temp/2090 temp/2087)
    temp/2085 0. temp/1576 (+ (<< (<=f g/2086 temp/2085) 1) 1))
   (if (!= temp/1576 1) "camlCode__20"
     (let
       (temp/1614 "camlPervasives" temp/1613 (load (+a temp/1614 56))
        s/2084 (extcall "sqrt" (load float64u temp/1613) float)
        temp/2083 (load float64u n/1090) temp/2082 (*f s/2084 temp/2083)
        temp/2081 (load float64u (+a n/1090 8))
        temp/2080 (*f s/2084 temp/2081)
        temp/2079 (load float64u (+a n/1090 16))
        temp/2078 (*f s/2084 temp/2079)
        b/1228 (alloc[254] 6398 temp/2082 temp/2080 temp/2078)
        s/1226 (load match/1148) temp/2077 (load float64u dir/1087)
        temp/2076 (*f (load float64u s/1226) temp/2077)
        temp/2075 (load float64u (+a dir/1087 8))
        temp/2074 (*f (load float64u s/1226) temp/2075)
        temp/2073 (load float64u (+a dir/1087 16))
        temp/2072 (*f (load float64u s/1226) temp/2073)
        a/1229 (alloc[254] 6398 temp/2076 temp/2074 temp/2072)
        temp/2071 (load float64u a/1229) temp/2070 (load float64u b/1228)
        temp/2069 (+f temp/2071 temp/2070)
        temp/2068 (load float64u (+a a/1229 8))
        temp/2067 (load float64u (+a b/1228 8))
        temp/2066 (+f temp/2068 temp/2067)
        temp/2065 (load float64u (+a a/1229 16))
        temp/2064 (load float64u (+a b/1228 16))
        temp/2063 (+f temp/2065 temp/2064)
        p/1092 (alloc[254] 6398 temp/2069 temp/2066 temp/2063)
        temp/1582 "camlCode" temp/1581 (load (+a temp/1582 44))
        temp/1585 "camlPervasives" temp/1584 (load (+a temp/1585 36))
        temp/1587 "camlCode" temp/1586 (load (+a temp/1587 4))
        temp/1583 (alloc[0] 2048 temp/1584 temp/1586) temp/1589 "camlCode"
        temp/1588 (load (+a temp/1589 36))
        temp/1580
          (app "camlCode__intersect_1067" p/1092 temp/1581 temp/1583
            scene/1088 temp/1588 addr)
        temp/1579 (load temp/1580) temp/1591 "camlPervasives"
        temp/1590 (load (+a temp/1591 36))
        temp/1578
          (+ (<< (<f (load float64u temp/1579) (load float64u temp/1590)) 1)
            1))
       (if (!= temp/1578 1) "camlCode__19" (alloc[253] 2301 g/2086))))))

(function camlCode__create_1093
     (level/1094: addr c/1095: addr r/1096: addr env/1249: addr)
 (let
   (obj/1097 (let temp/1898 1a (alloc[0] 3072 c/1095 r/1096 temp/1898))
    temp/1466 (let temp/1897 3 (+ (<< (== level/1094 temp/1897) 1) 1)))
   (if (!= temp/1466 1) obj/1097
     (let
       (temp/2062 3. temp/2061 (*f temp/2062 (load float64u r/1096))
        temp/2060 12. temp/2059 (extcall "sqrt" temp/2060 float)
        a/2058 (/f temp/2061 temp/2059) temp/2057 3.
        temp/2056 (*f temp/2057 (load float64u r/1096)) z'/2055 (~f a/2058)
        x'/2054 (~f a/2058)
        temp/1473 (let temp/1896 3 (+ (- level/1094 temp/1896) 1))
        b/1258 (alloc[254] 6398 x'/2054 a/2058 z'/2055)
        temp/2053 (load float64u c/1095) temp/2052 (load float64u b/1258)
        temp/2051 (+f temp/2053 temp/2052)
        temp/2050 (load float64u (+a c/1095 8))
        temp/2049 (load float64u (+a b/1258 8))
        temp/2048 (+f temp/2050 temp/2049)
        temp/2047 (load float64u (+a c/1095 16))
        temp/2046 (load float64u (+a b/1258 16))
        temp/2045 (+f temp/2047 temp/2046)
        temp/1476 (alloc[254] 6398 temp/2051 temp/2048 temp/2045)
        temp/2044 0.5 temp/2043 (*f temp/2044 (load float64u r/1096))
        temp/1472
          (app "camlCode__create_1093" temp/1473 temp/1476
            (alloc[253] 2301 temp/2043) env/1249 addr)
        z'/2042 (~f a/2058)
        temp/1493 (let temp/1895 3 (+ (- level/1094 temp/1895) 1))
        b/1261 (alloc[254] 6398 a/2058 a/2058 z'/2042)
        temp/2041 (load float64u c/1095) temp/2040 (load float64u b/1261)
        temp/2039 (+f temp/2041 temp/2040)
        temp/2038 (load float64u (+a c/1095 8))
        temp/2037 (load float64u (+a b/1261 8))
        temp/2036 (+f temp/2038 temp/2037)
        temp/2035 (load float64u (+a c/1095 16))
        temp/2034 (load float64u (+a b/1261 16))
        temp/2033 (+f temp/2035 temp/2034)
        temp/1496 (alloc[254] 6398 temp/2039 temp/2036 temp/2033)
        temp/2032 0.5 temp/2031 (*f temp/2032 (load float64u r/1096))
        temp/1492
          (app "camlCode__create_1093" temp/1493 temp/1496
            (alloc[253] 2301 temp/2031) env/1249 addr)
        x'/2030 (~f a/2058)
        temp/1513 (let temp/1894 3 (+ (- level/1094 temp/1894) 1))
        b/1264 (alloc[254] 6398 x'/2030 a/2058 a/2058)
        temp/2029 (load float64u c/1095) temp/2028 (load float64u b/1264)
        temp/2027 (+f temp/2029 temp/2028)
        temp/2026 (load float64u (+a c/1095 8))
        temp/2025 (load float64u (+a b/1264 8))
        temp/2024 (+f temp/2026 temp/2025)
        temp/2023 (load float64u (+a c/1095 16))
        temp/2022 (load float64u (+a b/1264 16))
        temp/2021 (+f temp/2023 temp/2022)
        temp/1516 (alloc[254] 6398 temp/2027 temp/2024 temp/2021)
        temp/2020 0.5 temp/2019 (*f temp/2020 (load float64u r/1096))
        temp/1512
          (app "camlCode__create_1093" temp/1513 temp/1516
            (alloc[253] 2301 temp/2019) env/1249 addr)
        temp/1533 (let temp/1893 3 (+ (- level/1094 temp/1893) 1))
        b/1266 (alloc[254] 6398 a/2058 a/2058 a/2058)
        temp/2018 (load float64u c/1095) temp/2017 (load float64u b/1266)
        temp/2016 (+f temp/2018 temp/2017)
        temp/2015 (load float64u (+a c/1095 8))
        temp/2014 (load float64u (+a b/1266 8))
        temp/2013 (+f temp/2015 temp/2014)
        temp/2012 (load float64u (+a c/1095 16))
        temp/2011 (load float64u (+a b/1266 16))
        temp/2010 (+f temp/2012 temp/2011)
        temp/1536 (alloc[254] 6398 temp/2016 temp/2013 temp/2010)
        temp/2009 0.5 temp/2008 (*f temp/2009 (load float64u r/1096))
        temp/1532
          (app "camlCode__create_1093" temp/1533 temp/1536
            (alloc[253] 2301 temp/2008) env/1249 addr)
        temp/1531 (let temp/1892 1a (alloc[0] 2048 temp/1532 temp/1892))
        temp/1511 (alloc[0] 2048 temp/1512 temp/1531)
        temp/1491 (alloc[0] 2048 temp/1492 temp/1511)
        temp/1471 (alloc[0] 2048 temp/1472 temp/1491)
        temp/1470 (alloc[0] 2048 obj/1097 temp/1471))
       (alloc[0] 3072 c/1095 (alloc[253] 2301 temp/2056) temp/1470)))))

(function camlCode__entry ()
 (let
   (temp/1876 "camlPervasives" temp/1875 (load (+a temp/1876 56))
    delta/2007 (extcall "sqrt" (load float64u temp/1875) float)
    temp/1874 "camlCode")
   (store temp/1874 (alloc[253] 2301 delta/2007))
   (let (zero/1039 "camlCode__1" temp/1873 "camlCode")
     (store (+a temp/1873 4) zero/1039)
     (let (*|/1040 "camlCode__18" temp/1866 "camlCode")
       (store (+a temp/1866 8) *|/1040)
       (let (+|/1043 "camlCode__17" temp/1856 "camlCode")
         (store (+a temp/1856 12) +|/1043)
         (let (-|/1046 "camlCode__16" temp/1846 "camlCode")
           (store (+a temp/1846 16) -|/1046)
           (let (dot/1049 "camlCode__15" temp/1835 "camlCode")
             (store (+a temp/1835 20) dot/1049)
             (let (length/1052 "camlCode__14" temp/1823 "camlCode")
               (store (+a temp/1823 24) length/1052)
               (let (unitise/1054 "camlCode__13" temp/1803 "camlCode")
                 (store (+a temp/1803 28) unitise/1054)
                 (let (ray_sphere/1056 "camlCode__12" temp/1761 "camlCode")
                   (store (+a temp/1761 32) ray_sphere/1056)
                   (let (clos/1222 "camlCode__11" temp/1668 "camlCode")
                     (store (+a temp/1668 36) clos/1222)
                     (let (temp/1666 "camlCode" temp/1667 (+a clos/1222 16))
                       (store (+a temp/1666 40) temp/1667))
                     (let
                       (temp/2006 1. temp/1653 "camlCode__2"
                        temp/2005 (load float64u temp/1653)
                        temp/1655 "camlCode__2"
                        temp/2004 (load float64u temp/1655)
                        temp/2003 (*f temp/2005 temp/2004)
                        temp/1658 "camlCode__2"
                        temp/2002 (load float64u (+a temp/1658 8))
                        temp/1660 "camlCode__2"
                        temp/2001 (load float64u (+a temp/1660 8))
                        temp/2000 (*f temp/2002 temp/2001)
                        temp/1999 (+f temp/2003 temp/2000)
                        temp/1663 "camlCode__2"
                        temp/1998 (load float64u (+a temp/1663 16))
                        temp/1665 "camlCode__2"
                        temp/1997 (load float64u (+a temp/1665 16))
                        temp/1996 (*f temp/1998 temp/1997)
                        temp/1995 (+f temp/1999 temp/1996)
                        temp/1994 (extcall "sqrt" temp/1995 float)
                        s/1993 (/f temp/2006 temp/1994)
                        temp/1640 "camlCode__2"
                        temp/1992 (load float64u temp/1640)
                        temp/1991 (*f s/1993 temp/1992)
                        temp/1643 "camlCode__2"
                        temp/1990 (load float64u (+a temp/1643 8))
                        temp/1989 (*f s/1993 temp/1990)
                        temp/1646 "camlCode__2"
                        temp/1988 (load float64u (+a temp/1646 16))
                        temp/1987 (*f s/1993 temp/1988)
                        light/1084
                          (alloc[254] 6398 temp/1991 temp/1989 temp/1987)
                        temp/1637 "camlCode")
                       (store (+a temp/1637 44) light/1084)
                       (let (temp/1635 "camlCode" temp/1899 9)
                         (store (+a temp/1635 48) temp/1899))
                       (let
                         (ray_trace/1086 "camlCode__10" temp/1575 "camlCode")
                         (store (+a temp/1575 52) ray_trace/1086)
                         (let (clos/1268 "camlCode__9" temp/1465 "camlCode")
                           (store (+a temp/1465 56) clos/1268)
                           (let
                             (match/1151
                                (try
                                  (let
                                    (temp/1458 "camlSys"
                                     temp/1457 (load temp/1458)
                                     temp/1456
                                       (let temp/1891 3
                                         (checkbound
                                           (>>u (load (+a temp/1457 -4)) 9)
                                           temp/1891)
                                         (load
                                           (+a
                                             (+a temp/1457 (<< temp/1891 1))
                                             -2)))
                                     temp/1455
                                       (extcall "caml_int_of_string"
                                         temp/1456 addr)
                                     temp/1463 "camlSys"
                                     temp/1462 (load temp/1463)
                                     temp/1461
                                       (let temp/1890 5
                                         (checkbound
                                           (>>u (load (+a temp/1462 -4)) 9)
                                           temp/1890)
                                         (load
                                           (+a
                                             (+a temp/1462 (<< temp/1890 1))
                                             -2)))
                                     temp/1460
                                       (extcall "caml_int_of_string"
                                         temp/1461 addr))
                                    (alloc[0] 2048 temp/1455 temp/1460))
                                with exn/1150 "camlCode__3")
                              temp/1453 "camlCode"
                              temp/1454 (load match/1151))
                             (store (+a temp/1453 60) temp/1454)
                             (let
                               (temp/1451 "camlCode"
                                temp/1452 (load (+a match/1151 4)))
                               (store (+a temp/1451 64) temp/1452))
                             (let
                               (temp/1446 "camlCode"
                                temp/1445 (load (+a temp/1446 60))
                                temp/1447 "camlCode__4" temp/1986 1.
                                temp/1450 "camlCode"
                                temp/1449 (load (+a temp/1450 56))
                                scene/1104
                                  (app "camlCode__create_1093" temp/1445
                                    temp/1447 (alloc[253] 2301 temp/1986)
                                    temp/1449 addr)
                                temp/1444 "camlCode")
                               (store (+a temp/1444 68) scene/1104)
                               (let
                                 (temp/1438 "camlPervasives"
                                  temp/1437 (load (+a temp/1438 92))
                                  temp/1436
                                    (app{printf.ml:641,17-35}
                                      "camlPrintf__fprintf_1392" temp/1437
                                      addr)
                                  temp/1439 "camlCode__5"
                                  temp/1435
                                    (app{printf.ml:641,17-35}
                                      (load temp/1436) temp/1439 temp/1436
                                      addr)
                                  temp/1441 "camlCode"
                                  temp/1440 (load (+a temp/1441 64))
                                  temp/1443 "camlCode"
                                  temp/1442 (load (+a temp/1443 64)))
                                 (app "caml_apply2" temp/1440 temp/1442
                                   temp/1435 unit)
                                 (let
                                   (temp/1285 "camlCode"
                                    temp/1284 (load (+a temp/1285 64))
                                    temp/1283
                                      (let temp/1889 3
                                        (+ (- temp/1284 temp/1889) 1))
                                    temp/1877 1 y/1105[Variable] temp/1283
                                    bound/1901 temp/1877)
                                   (catch
                                     (if (< y/1105 bound/1901) (exit 34)
                                       (loop
                                         (let
                                           (temp/1291 "camlCode"
                                            temp/1290
                                              (load (+a temp/1291 64))
                                            temp/1289
                                              (let temp/1888 3
                                                (+ (- temp/1290 temp/1888) 1))
                                            temp/1878 1
                                            x/1106[Variable] temp/1878
                                            bound/1903 temp/1289)
                                           (catch
                                             (if (> x/1106 bound/1903)
                                               (exit 35)
                                               (loop
                                                 (let g/1985[Variable] 0.
                                                   (let
                                                     (temp/1882 1 temp/1883 7
                                                      dx/1108[Variable]
                                                        temp/1882
                                                      bound/1910 temp/1883)
                                                     (catch
                                                       (if
                                                         (> dx/1108
                                                           bound/1910)
                                                         (exit 36)
                                                         (loop
                                                           (let
                                                             (temp/1884 1
                                                              temp/1885 7
                                                              dy/1109[Variable]
                                                                temp/1884
                                                              bound/1912
                                                                temp/1885)
                                                             (catch
                                                               (if
                                                                 (> dy/1109
                                                                   bound/1912)
                                                                 (exit 37)
                                                                 (loop
                                                                   (let
                                                                    (temp/1984
                                                                    (floatofint
                                                                    (>>s
                                                                    x/1106 1))
                                                                    temp/1403
                                                                    "camlCode"
                                                                    temp/1402
                                                                    (load
                                                                    (+a
                                                                    temp/1403
                                                                    64))
                                                                    temp/1983
                                                                    (floatofint
                                                                    (>>s
                                                                    temp/1402
                                                                    1))
                                                                    temp/1982
                                                                    2.
                                                                    temp/1981
                                                                    (/f
                                                                    temp/1983
                                                                    temp/1982)
                                                                    temp/1980
                                                                    (-f
                                                                    temp/1984
                                                                    temp/1981)
                                                                    temp/1979
                                                                    (floatofint
                                                                    (>>s
                                                                    dx/1108
                                                                    1))
                                                                    temp/1407
                                                                    (let
                                                                    temp/1887
                                                                    9
                                                                    (alloc[253]
                                                                    2301
                                                                    (floatofint
                                                                    (>>s
                                                                    temp/1887
                                                                    1))))
                                                                    temp/1978
                                                                    (/f
                                                                    temp/1979
                                                                    (load float64u
                                                                    temp/1407))
                                                                    temp/1977
                                                                    (+f
                                                                    temp/1980
                                                                    temp/1978)
                                                                    temp/1976
                                                                    (floatofint
                                                                    (>>s
                                                                    y/1105 1))
                                                                    temp/1415
                                                                    "camlCode"
                                                                    temp/1414
                                                                    (load
                                                                    (+a
                                                                    temp/1415
                                                                    64))
                                                                    temp/1975
                                                                    (floatofint
                                                                    (>>s
                                                                    temp/1414
                                                                    1))
                                                                    temp/1974
                                                                    2.
                                                                    temp/1973
                                                                    (/f
                                                                    temp/1975
                                                                    temp/1974)
                                                                    temp/1972
                                                                    (-f
                                                                    temp/1976
                                                                    temp/1973)
                                                                    temp/1971
                                                                    (floatofint
                                                                    (>>s
                                                                    dy/1109
                                                                    1))
                                                                    temp/1419
                                                                    (let
                                                                    temp/1886
                                                                    9
                                                                    (alloc[253]
                                                                    2301
                                                                    (floatofint
                                                                    (>>s
                                                                    temp/1886
                                                                    1))))
                                                                    temp/1970
                                                                    (/f
                                                                    temp/1971
                                                                    (load float64u
                                                                    temp/1419))
                                                                    temp/1969
                                                                    (+f
                                                                    temp/1972
                                                                    temp/1970)
                                                                    temp/1423
                                                                    "camlCode"
                                                                    temp/1422
                                                                    (load
                                                                    (+a
                                                                    temp/1423
                                                                    64))
                                                                    temp/1968
                                                                    (floatofint
                                                                    (>>s
                                                                    temp/1422
                                                                    1))
                                                                    r/1270
                                                                    (alloc[254]
                                                                    6398
                                                                    temp/1977
                                                                    temp/1969
                                                                    temp/1968)
                                                                    temp/1967
                                                                    1.
                                                                    temp/1966
                                                                    (load float64u
                                                                    r/1270)
                                                                    temp/1965
                                                                    (load float64u
                                                                    r/1270)
                                                                    temp/1964
                                                                    (*f
                                                                    temp/1966
                                                                    temp/1965)
                                                                    temp/1963
                                                                    (load float64u
                                                                    (+a
                                                                    r/1270 8))
                                                                    temp/1962
                                                                    (load float64u
                                                                    (+a
                                                                    r/1270 8))
                                                                    temp/1961
                                                                    (*f
                                                                    temp/1963
                                                                    temp/1962)
                                                                    temp/1960
                                                                    (+f
                                                                    temp/1964
                                                                    temp/1961)
                                                                    temp/1959
                                                                    (load float64u
                                                                    (+a
                                                                    r/1270
                                                                    16))
                                                                    temp/1958
                                                                    (load float64u
                                                                    (+a
                                                                    r/1270
                                                                    16))
                                                                    temp/1957
                                                                    (*f
                                                                    temp/1959
                                                                    temp/1958)
                                                                    temp/1956
                                                                    (+f
                                                                    temp/1960
                                                                    temp/1957)
                                                                    temp/1955
                                                                    (extcall "sqrt"
                                                                    temp/1956
                                                                    float)
                                                                    s/1954
                                                                    (/f
                                                                    temp/1967
                                                                    temp/1955)
                                                                    temp/1953
                                                                    (load float64u
                                                                    r/1270)
                                                                    temp/1952
                                                                    (*f
                                                                    s/1954
                                                                    temp/1953)
                                                                    temp/1951
                                                                    (load float64u
                                                                    (+a
                                                                    r/1270 8))
                                                                    temp/1950
                                                                    (*f
                                                                    s/1954
                                                                    temp/1951)
                                                                    temp/1949
                                                                    (load float64u
                                                                    (+a
                                                                    r/1270
                                                                    16))
                                                                    temp/1948
                                                                    (*f
                                                                    s/1954
                                                                    temp/1949)
                                                                    dir/1113
                                                                    (alloc[254]
                                                                    6398
                                                                    temp/1952
                                                                    temp/1950
                                                                    temp/1948)
                                                                    temp/1377
                                                                    "camlCode"
                                                                    scene/1272
                                                                    (load
                                                                    (+a
                                                                    temp/1377
                                                                    68))
                                                                    temp/1369
                                                                    "camlCode"
                                                                    temp/1368
                                                                    (load
                                                                    (+a
                                                                    temp/1369
                                                                    4))
                                                                    temp/1372
                                                                    "camlPervasives"
                                                                    temp/1371
                                                                    (load
                                                                    (+a
                                                                    temp/1372
                                                                    36))
                                                                    temp/1374
                                                                    "camlCode"
                                                                    temp/1373
                                                                    (load
                                                                    (+a
                                                                    temp/1374
                                                                    4))
                                                                    temp/1370
                                                                    (alloc[0]
                                                                    2048
                                                                    temp/1371
                                                                    temp/1373)
                                                                    temp/1376
                                                                    "camlCode"
                                                                    temp/1375
                                                                    (load
                                                                    (+a
                                                                    temp/1376
                                                                    36))
                                                                    match/1273
                                                                    (app
                                                                    "camlCode__intersect_1067"
                                                                    temp/1368
                                                                    dir/1113
                                                                    temp/1370
                                                                    scene/1272
                                                                    temp/1375
                                                                    addr)
                                                                    temp/1317
                                                                    (let
                                                                    (n/1274[Alias]
                                                                    (load
                                                                    (+a
                                                                    match/1273
                                                                    4))
                                                                    temp/1367
                                                                    "camlCode"
                                                                    b/1281
                                                                    (load
                                                                    (+a
                                                                    temp/1367
                                                                    44))
                                                                    temp/1947
                                                                    (load float64u
                                                                    n/1274)
                                                                    temp/1946
                                                                    (load float64u
                                                                    b/1281)
                                                                    temp/1945
                                                                    (*f
                                                                    temp/1947
                                                                    temp/1946)
                                                                    temp/1944
                                                                    (load float64u
                                                                    (+a
                                                                    n/1274 8))
                                                                    temp/1943
                                                                    (load float64u
                                                                    (+a
                                                                    b/1281 8))
                                                                    temp/1942
                                                                    (*f
                                                                    temp/1944
                                                                    temp/1943)
                                                                    temp/1941
                                                                    (+f
                                                                    temp/1945
                                                                    temp/1942)
                                                                    temp/1940
                                                                    (load float64u
                                                                    (+a
                                                                    n/1274
                                                                    16))
                                                                    temp/1939
                                                                    (load float64u
                                                                    (+a
                                                                    b/1281
                                                                    16))
                                                                    temp/1938
                                                                    (*f
                                                                    temp/1940
                                                                    temp/1939)
                                                                    g/1937
                                                                    (+f
                                                                    temp/1941
                                                                    temp/1938)
                                                                    temp/1936
                                                                    0.
                                                                    temp/1318
                                                                    (+
                                                                    (<<
                                                                    (<=f
                                                                    g/1937
                                                                    temp/1936)
                                                                    1) 1))
                                                                    (if
                                                                    (!=
                                                                    temp/1318
                                                                    1)
                                                                    "camlCode__8"
                                                                    (let
                                                                    (temp/1356
                                                                    "camlPervasives"
                                                                    temp/1355
                                                                    (load
                                                                    (+a
                                                                    temp/1356
                                                                    56))
                                                                    s/1935
                                                                    (extcall "sqrt"
                                                                    (load float64u
                                                                    temp/1355)
                                                                    float)
                                                                    temp/1934
                                                                    (load float64u
                                                                    n/1274)
                                                                    temp/1933
                                                                    (*f
                                                                    s/1935
                                                                    temp/1934)
                                                                    temp/1932
                                                                    (load float64u
                                                                    (+a
                                                                    n/1274 8))
                                                                    temp/1931
                                                                    (*f
                                                                    s/1935
                                                                    temp/1932)
                                                                    temp/1930
                                                                    (load float64u
                                                                    (+a
                                                                    n/1274
                                                                    16))
                                                                    temp/1929
                                                                    (*f
                                                                    s/1935
                                                                    temp/1930)
                                                                    b/1277
                                                                    (alloc[254]
                                                                    6398
                                                                    temp/1933
                                                                    temp/1931
                                                                    temp/1929)
                                                                    s/1279
                                                                    (load
                                                                    match/1273)
                                                                    temp/1928
                                                                    (load float64u
                                                                    dir/1113)
                                                                    temp/1927
                                                                    (*f
                                                                    (load float64u
                                                                    s/1279)
                                                                    temp/1928)
                                                                    temp/1926
                                                                    (load float64u
                                                                    (+a
                                                                    dir/1113
                                                                    8))
                                                                    temp/1925
                                                                    (*f
                                                                    (load float64u
                                                                    s/1279)
                                                                    temp/1926)
                                                                    temp/1924
                                                                    (load float64u
                                                                    (+a
                                                                    dir/1113
                                                                    16))
                                                                    temp/1923
                                                                    (*f
                                                                    (load float64u
                                                                    s/1279)
                                                                    temp/1924)
                                                                    a/1278
                                                                    (alloc[254]
                                                                    6398
                                                                    temp/1927
                                                                    temp/1925
                                                                    temp/1923)
                                                                    temp/1922
                                                                    (load float64u
                                                                    a/1278)
                                                                    temp/1921
                                                                    (load float64u
                                                                    b/1277)
                                                                    temp/1920
                                                                    (+f
                                                                    temp/1922
                                                                    temp/1921)
                                                                    temp/1919
                                                                    (load float64u
                                                                    (+a
                                                                    a/1278 8))
                                                                    temp/1918
                                                                    (load float64u
                                                                    (+a
                                                                    b/1277 8))
                                                                    temp/1917
                                                                    (+f
                                                                    temp/1919
                                                                    temp/1918)
                                                                    temp/1916
                                                                    (load float64u
                                                                    (+a
                                                                    a/1278
                                                                    16))
                                                                    temp/1915
                                                                    (load float64u
                                                                    (+a
                                                                    b/1277
                                                                    16))
                                                                    temp/1914
                                                                    (+f
                                                                    temp/1916
                                                                    temp/1915)
                                                                    p/1276
                                                                    (alloc[254]
                                                                    6398
                                                                    temp/1920
                                                                    temp/1917
                                                                    temp/1914)
                                                                    temp/1324
                                                                    "camlCode"
                                                                    temp/1323
                                                                    (load
                                                                    (+a
                                                                    temp/1324
                                                                    44))
                                                                    temp/1327
                                                                    "camlPervasives"
                                                                    temp/1326
                                                                    (load
                                                                    (+a
                                                                    temp/1327
                                                                    36))
                                                                    temp/1329
                                                                    "camlCode"
                                                                    temp/1328
                                                                    (load
                                                                    (+a
                                                                    temp/1329
                                                                    4))
                                                                    temp/1325
                                                                    (alloc[0]
                                                                    2048
                                                                    temp/1326
                                                                    temp/1328)
                                                                    temp/1331
                                                                    "camlCode"
                                                                    temp/1330
                                                                    (load
                                                                    (+a
                                                                    temp/1331
                                                                    36))
                                                                    temp/1322
                                                                    (app
                                                                    "camlCode__intersect_1067"
                                                                    p/1276
                                                                    temp/1323
                                                                    temp/1325
                                                                    scene/1272
                                                                    temp/1330
                                                                    addr)
                                                                    temp/1321
                                                                    (load
                                                                    temp/1322)
                                                                    temp/1333
                                                                    "camlPervasives"
                                                                    temp/1332
                                                                    (load
                                                                    (+a
                                                                    temp/1333
                                                                    36))
                                                                    temp/1320
                                                                    (+
                                                                    (<<
                                                                    (<f
                                                                    (load float64u
                                                                    temp/1321)
                                                                    (load float64u
                                                                    temp/1332))
                                                                    1) 1))
                                                                    (if
                                                                    (!=
                                                                    temp/1320
                                                                    1)
                                                                    "camlCode__7"
                                                                    (alloc[253]
                                                                    2301
                                                                    g/1937)))))
                                                                    temp/1913
                                                                    (+f
                                                                    g/1985
                                                                    (load float64u
                                                                    temp/1317)))
                                                                    (assign 
                                                                    g/1985
                                                                    temp/1913))
                                                                   (let
                                                                    dy/1911
                                                                    dy/1109
                                                                    (assign 
                                                                    dy/1109
                                                                    (+
                                                                    dy/1109
                                                                    2))
                                                                    (if
                                                                    (==
                                                                    dy/1911
                                                                    bound/1912)
                                                                    (exit 37)
                                                                    []))))
                                                             with(37) 
                                                               []))
                                                           (let
                                                             dx/1909 dx/1108
                                                             (assign 
                                                               dx/1108
                                                                 (+ dx/1108
                                                                   2))
                                                             (if
                                                               (== dx/1909
                                                                 bound/1910)
                                                               (exit 36) 
                                                               []))))
                                                     with(36) []))
                                                   (let
                                                     (temp/1908 0.5
                                                      temp/1907 255.
                                                      temp/1906
                                                        (*f temp/1907 g/1985)
                                                      temp/1310
                                                        (let temp/1881 33
                                                          (alloc[253] 2301
                                                            (floatofint
                                                              (>>s temp/1881
                                                                1))))
                                                      temp/1905
                                                        (/f temp/1906
                                                          (load float64u
                                                            temp/1310))
                                                      g/1904
                                                        (+f temp/1908
                                                          temp/1905)
                                                      temp/1296
                                                        "camlPervasives"
                                                      temp/1295
                                                        (load
                                                          (+a temp/1296 92))
                                                      temp/1294
                                                        (app{printf.ml:641,17-35}
                                                          "camlPrintf__fprintf_1392"
                                                          temp/1295 addr)
                                                      temp/1297 "camlCode__6"
                                                      temp/1293
                                                        (app{printf.ml:641,17-35}
                                                          (load temp/1294)
                                                          temp/1297 temp/1294
                                                          addr)
                                                      n/1282
                                                        (+
                                                          (<<
                                                            (intoffloat
                                                              g/1904)
                                                            1)
                                                          1)
                                                      temp/1300
                                                        (let temp/1880 1
                                                          (+
                                                            (<<
                                                              (< n/1282
                                                                temp/1880)
                                                              1)
                                                            1))
                                                      temp/1299
                                                        (if (!= temp/1300 1)
                                                          3a
                                                          (let temp/1879 511
                                                            (+
                                                              (<<
                                                                (> n/1282
                                                                  temp/1879)
                                                                1)
                                                              1)))
                                                      temp/1298
                                                        (if (!= temp/1299 1)
                                                          (let
                                                            (temp/1304
                                                               "caml_exn_Invalid_argument"
                                                             temp/1305
                                                               "camlPervasives__2"
                                                             temp/1303
                                                               (alloc[0] 2048
                                                                 temp/1304
                                                                 temp/1305))
                                                            (raise{pervasives.ml:155,27-52}
                                                              temp/1303))
                                                          n/1282))
                                                     (app (load temp/1293)
                                                       temp/1298 temp/1293
                                                       unit)))
                                                 (let x/1902 x/1106
                                                   (assign x/1106
                                                             (+ x/1106 2))
                                                   (if (== x/1902 bound/1903)
                                                     (exit 35) []))))
                                           with(35) []))
                                         (let y/1900 y/1105
                                           (assign y/1105 (- y/1105 2))
                                           (if (== y/1900 bound/1901)
                                             (exit 34) []))))
                                   with(34) []))
                                 1a)))))))))))))))))

[times] Asmgen.compile_phrases: 0.448 s
(data)
-dlinear
[times] TonLambda.optimize: 0.000 s
[times] Closure.intro: 0.000 s
[times] TonSlambda.optimize: 0.008 s
[times] TonClosure.optimize: 0.048 s
[times] TonSlambda.optimize: 0.008 s
[times] Cmmgen.compunit: 0.028 s
Before simplify
camlCode__*|_1040:
                  R/7[%tos] := float64u[r/9[%ebx]]
                  temp/11[s0] := R/7[%tos]
                  R/7[%tos] := temp/11[s0] *f float64[s/8[%eax]]
                  temp/13[s2] := R/7[%tos]
                  R/7[%tos] := float64u[r/9[%ebx] + 8]
                  temp/15[s0] := R/7[%tos]
                  R/7[%tos] := temp/15[s0] *f float64[s/8[%eax]]
                  temp/17[s1] := R/7[%tos]
                  R/7[%tos] := float64u[r/9[%ebx] + 16]
                  temp/19[s0] := R/7[%tos]
                  R/7[%tos] := temp/19[s0] *f float64[s/8[%eax]]
                  temp/21[s0] := R/7[%tos]
                  {temp/13[s2] temp/17[s1] temp/21[s0]}
                  A/22[%eax] := alloc 28
                  [A/22[%eax] + -4] := 6398
                  float64u[A/22[%eax]] := temp/13[s2]
                  float64u[A/22[%eax] + 8] := temp/17[s1]
                  float64u[A/22[%eax] + 16] := temp/21[s0]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__*|_1040:
  R/7[%tos] := float64u[r/9[%ebx]]
  temp/11[s0] := R/7[%tos]
  R/7[%tos] := temp/11[s0] *f float64[s/8[%eax]]
  temp/13[s2] := R/7[%tos]
  R/7[%tos] := float64u[r/9[%ebx] + 8]
  temp/15[s0] := R/7[%tos]
  R/7[%tos] := temp/15[s0] *f float64[s/8[%eax]]
  temp/17[s1] := R/7[%tos]
  R/7[%tos] := float64u[r/9[%ebx] + 16]
  temp/19[s0] := R/7[%tos]
  R/7[%tos] := temp/19[s0] *f float64[s/8[%eax]]
  temp/21[s0] := R/7[%tos]
  {temp/13[s2] temp/17[s1] temp/21[s0]}
  A/22[%eax] := alloc 28
  [A/22[%eax] + -4] := 6398
  float64u[A/22[%eax]] := temp/13[s2]
  float64u[A/22[%eax] + 8] := temp/17[s1]
  float64u[A/22[%eax] + 16] := temp/21[s0]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__+|_1043:
                  R/7[%tos] := float64u[a/8[%eax]]
                  temp/11[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/9[%ebx]]
                  temp/13[s0] := R/7[%tos]
                  R/7[%tos] := temp/11[s1] +f temp/13[s0]
                  temp/15[s3] := R/7[%tos]
                  R/7[%tos] := float64u[a/8[%eax] + 8]
                  temp/17[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/9[%ebx] + 8]
                  temp/19[s0] := R/7[%tos]
                  R/7[%tos] := temp/17[s1] +f temp/19[s0]
                  temp/21[s2] := R/7[%tos]
                  R/7[%tos] := float64u[a/8[%eax] + 16]
                  temp/23[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/9[%ebx] + 16]
                  temp/25[s0] := R/7[%tos]
                  R/7[%tos] := temp/23[s1] +f temp/25[s0]
                  temp/27[s0] := R/7[%tos]
                  {temp/15[s3] temp/21[s2] temp/27[s0]}
                  A/28[%eax] := alloc 28
                  [A/28[%eax] + -4] := 6398
                  float64u[A/28[%eax]] := temp/15[s3]
                  float64u[A/28[%eax] + 8] := temp/21[s2]
                  float64u[A/28[%eax] + 16] := temp/27[s0]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__+|_1043:
  R/7[%tos] := float64u[a/8[%eax]]
  temp/11[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/9[%ebx]]
  temp/13[s0] := R/7[%tos]
  R/7[%tos] := temp/11[s1] +f temp/13[s0]
  temp/15[s3] := R/7[%tos]
  R/7[%tos] := float64u[a/8[%eax] + 8]
  temp/17[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/9[%ebx] + 8]
  temp/19[s0] := R/7[%tos]
  R/7[%tos] := temp/17[s1] +f temp/19[s0]
  temp/21[s2] := R/7[%tos]
  R/7[%tos] := float64u[a/8[%eax] + 16]
  temp/23[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/9[%ebx] + 16]
  temp/25[s0] := R/7[%tos]
  R/7[%tos] := temp/23[s1] +f temp/25[s0]
  temp/27[s0] := R/7[%tos]
  {temp/15[s3] temp/21[s2] temp/27[s0]}
  A/28[%eax] := alloc 28
  [A/28[%eax] + -4] := 6398
  float64u[A/28[%eax]] := temp/15[s3]
  float64u[A/28[%eax] + 8] := temp/21[s2]
  float64u[A/28[%eax] + 16] := temp/27[s0]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__-|_1046:
                  R/7[%tos] := float64u[a/8[%eax]]
                  temp/11[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/9[%ebx]]
                  temp/13[s0] := R/7[%tos]
                  R/7[%tos] := temp/11[s1] -f temp/13[s0]
                  temp/15[s3] := R/7[%tos]
                  R/7[%tos] := float64u[a/8[%eax] + 8]
                  temp/17[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/9[%ebx] + 8]
                  temp/19[s0] := R/7[%tos]
                  R/7[%tos] := temp/17[s1] -f temp/19[s0]
                  temp/21[s2] := R/7[%tos]
                  R/7[%tos] := float64u[a/8[%eax] + 16]
                  temp/23[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/9[%ebx] + 16]
                  temp/25[s0] := R/7[%tos]
                  R/7[%tos] := temp/23[s1] -f temp/25[s0]
                  temp/27[s0] := R/7[%tos]
                  {temp/15[s3] temp/21[s2] temp/27[s0]}
                  A/28[%eax] := alloc 28
                  [A/28[%eax] + -4] := 6398
                  float64u[A/28[%eax]] := temp/15[s3]
                  float64u[A/28[%eax] + 8] := temp/21[s2]
                  float64u[A/28[%eax] + 16] := temp/27[s0]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__-|_1046:
  R/7[%tos] := float64u[a/8[%eax]]
  temp/11[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/9[%ebx]]
  temp/13[s0] := R/7[%tos]
  R/7[%tos] := temp/11[s1] -f temp/13[s0]
  temp/15[s3] := R/7[%tos]
  R/7[%tos] := float64u[a/8[%eax] + 8]
  temp/17[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/9[%ebx] + 8]
  temp/19[s0] := R/7[%tos]
  R/7[%tos] := temp/17[s1] -f temp/19[s0]
  temp/21[s2] := R/7[%tos]
  R/7[%tos] := float64u[a/8[%eax] + 16]
  temp/23[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/9[%ebx] + 16]
  temp/25[s0] := R/7[%tos]
  R/7[%tos] := temp/23[s1] -f temp/25[s0]
  temp/27[s0] := R/7[%tos]
  {temp/15[s3] temp/21[s2] temp/27[s0]}
  A/28[%eax] := alloc 28
  [A/28[%eax] + -4] := 6398
  float64u[A/28[%eax]] := temp/15[s3]
  float64u[A/28[%eax] + 8] := temp/21[s2]
  float64u[A/28[%eax] + 16] := temp/27[s0]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__dot_1049:
                  R/7[%tos] := float64u[a/8[%eax]]
                  temp/11[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/9[%ebx]]
                  temp/13[s0] := R/7[%tos]
                  R/7[%tos] := temp/11[s1] *f temp/13[s0]
                  temp/15[s2] := R/7[%tos]
                  R/7[%tos] := float64u[a/8[%eax] + 8]
                  temp/17[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/9[%ebx] + 8]
                  temp/19[s0] := R/7[%tos]
                  R/7[%tos] := temp/17[s1] *f temp/19[s0]
                  temp/21[s0] := R/7[%tos]
                  R/7[%tos] := temp/15[s2] +f temp/21[s0]
                  temp/23[s2] := R/7[%tos]
                  R/7[%tos] := float64u[a/8[%eax] + 16]
                  temp/25[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/9[%ebx] + 16]
                  temp/27[s0] := R/7[%tos]
                  R/7[%tos] := temp/25[s1] *f temp/27[s0]
                  temp/29[s0] := R/7[%tos]
                  {temp/23[s2] temp/29[s0]}
                  A/30[%eax] := alloc 12
                  [A/30[%eax] + -4] := 2301
                  R/7[%tos] := temp/23[s2] +f temp/29[s0]
                  float64u[A/30[%eax]] := R/7[%tos]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__dot_1049:
  R/7[%tos] := float64u[a/8[%eax]]
  temp/11[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/9[%ebx]]
  temp/13[s0] := R/7[%tos]
  R/7[%tos] := temp/11[s1] *f temp/13[s0]
  temp/15[s2] := R/7[%tos]
  R/7[%tos] := float64u[a/8[%eax] + 8]
  temp/17[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/9[%ebx] + 8]
  temp/19[s0] := R/7[%tos]
  R/7[%tos] := temp/17[s1] *f temp/19[s0]
  temp/21[s0] := R/7[%tos]
  R/7[%tos] := temp/15[s2] +f temp/21[s0]
  temp/23[s2] := R/7[%tos]
  R/7[%tos] := float64u[a/8[%eax] + 16]
  temp/25[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/9[%ebx] + 16]
  temp/27[s0] := R/7[%tos]
  R/7[%tos] := temp/25[s1] *f temp/27[s0]
  temp/29[s0] := R/7[%tos]
  {temp/23[s2] temp/29[s0]}
  A/30[%eax] := alloc 12
  [A/30[%eax] + -4] := 2301
  R/7[%tos] := temp/23[s2] +f temp/29[s0]
  float64u[A/30[%eax]] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__length_1052:
                  R/7[%tos] := float64u[r/8[%eax]]
                  temp/10[s1] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%eax]]
                  temp/12[s0] := R/7[%tos]
                  R/7[%tos] := temp/10[s1] *f temp/12[s0]
                  temp/14[s2] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%eax] + 8]
                  temp/16[s1] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%eax] + 8]
                  temp/18[s0] := R/7[%tos]
                  R/7[%tos] := temp/16[s1] *f temp/18[s0]
                  temp/20[s0] := R/7[%tos]
                  R/7[%tos] := temp/14[s2] +f temp/20[s0]
                  temp/22[s2] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%eax] + 16]
                  temp/24[s1] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%eax] + 16]
                  temp/26[s0] := R/7[%tos]
                  R/7[%tos] := temp/24[s1] *f temp/26[s0]
                  temp/28[s0] := R/7[%tos]
                  R/7[%tos] := temp/22[s2] +f temp/28[s0]
                  temp/30[s0] := R/7[%tos]
                  push temp/30[s0]
                  {}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  F/31[s0] := R/7[%tos]
                  {F/31[s0]}
                  A/32[%eax] := alloc 12
                  [A/32[%eax] + -4] := 2301
                  float64u[A/32[%eax]] := F/31[s0]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__length_1052:
  R/7[%tos] := float64u[r/8[%eax]]
  temp/10[s1] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%eax]]
  temp/12[s0] := R/7[%tos]
  R/7[%tos] := temp/10[s1] *f temp/12[s0]
  temp/14[s2] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%eax] + 8]
  temp/16[s1] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%eax] + 8]
  temp/18[s0] := R/7[%tos]
  R/7[%tos] := temp/16[s1] *f temp/18[s0]
  temp/20[s0] := R/7[%tos]
  R/7[%tos] := temp/14[s2] +f temp/20[s0]
  temp/22[s2] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%eax] + 16]
  temp/24[s1] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%eax] + 16]
  temp/26[s0] := R/7[%tos]
  R/7[%tos] := temp/24[s1] *f temp/26[s0]
  temp/28[s0] := R/7[%tos]
  R/7[%tos] := temp/22[s2] +f temp/28[s0]
  temp/30[s0] := R/7[%tos]
  push temp/30[s0]
  {}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  F/31[s0] := R/7[%tos]
  {F/31[s0]}
  A/32[%eax] := alloc 12
  [A/32[%eax] + -4] := 2301
  float64u[A/32[%eax]] := F/31[s0]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__unitise_1054:
                  r/8[%ebx] := R/0[%eax]
                  R/7[%tos] := 1.
                  temp/10[s3] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%ebx]]
                  temp/12[s1] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%ebx]]
                  temp/14[s0] := R/7[%tos]
                  R/7[%tos] := temp/12[s1] *f temp/14[s0]
                  temp/16[s2] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%ebx] + 8]
                  temp/18[s1] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%ebx] + 8]
                  temp/20[s0] := R/7[%tos]
                  R/7[%tos] := temp/18[s1] *f temp/20[s0]
                  temp/22[s0] := R/7[%tos]
                  R/7[%tos] := temp/16[s2] +f temp/22[s0]
                  temp/24[s2] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%ebx] + 16]
                  temp/26[s1] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%ebx] + 16]
                  temp/28[s0] := R/7[%tos]
                  R/7[%tos] := temp/26[s1] *f temp/28[s0]
                  temp/30[s0] := R/7[%tos]
                  R/7[%tos] := temp/24[s2] +f temp/30[s0]
                  temp/32[s0] := R/7[%tos]
                  push temp/32[s0]
                  {r/8[%ebx]* temp/10[s3]}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  temp/33[s0] := R/7[%tos]
                  R/7[%tos] := temp/10[s3] /f temp/33[s0]
                  s/35[s3] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%ebx]]
                  temp/37[s0] := R/7[%tos]
                  R/7[%tos] := s/35[s3] *f temp/37[s0]
                  temp/39[s2] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%ebx] + 8]
                  temp/41[s0] := R/7[%tos]
                  R/7[%tos] := s/35[s3] *f temp/41[s0]
                  temp/43[s1] := R/7[%tos]
                  R/7[%tos] := float64u[r/8[%ebx] + 16]
                  temp/45[s0] := R/7[%tos]
                  R/7[%tos] := s/35[s3] *f temp/45[s0]
                  temp/47[s0] := R/7[%tos]
                  {temp/39[s2] temp/43[s1] temp/47[s0]}
                  A/48[%eax] := alloc 28
                  [A/48[%eax] + -4] := 6398
                  float64u[A/48[%eax]] := temp/39[s2]
                  float64u[A/48[%eax] + 8] := temp/43[s1]
                  float64u[A/48[%eax] + 16] := temp/47[s0]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__unitise_1054:
  r/8[%ebx] := R/0[%eax]
  R/7[%tos] := 1.
  temp/10[s3] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%ebx]]
  temp/12[s1] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%ebx]]
  temp/14[s0] := R/7[%tos]
  R/7[%tos] := temp/12[s1] *f temp/14[s0]
  temp/16[s2] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%ebx] + 8]
  temp/18[s1] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%ebx] + 8]
  temp/20[s0] := R/7[%tos]
  R/7[%tos] := temp/18[s1] *f temp/20[s0]
  temp/22[s0] := R/7[%tos]
  R/7[%tos] := temp/16[s2] +f temp/22[s0]
  temp/24[s2] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%ebx] + 16]
  temp/26[s1] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%ebx] + 16]
  temp/28[s0] := R/7[%tos]
  R/7[%tos] := temp/26[s1] *f temp/28[s0]
  temp/30[s0] := R/7[%tos]
  R/7[%tos] := temp/24[s2] +f temp/30[s0]
  temp/32[s0] := R/7[%tos]
  push temp/32[s0]
  {r/8[%ebx]* temp/10[s3]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  temp/33[s0] := R/7[%tos]
  R/7[%tos] := temp/10[s3] /f temp/33[s0]
  s/35[s3] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%ebx]]
  temp/37[s0] := R/7[%tos]
  R/7[%tos] := s/35[s3] *f temp/37[s0]
  temp/39[s2] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%ebx] + 8]
  temp/41[s0] := R/7[%tos]
  R/7[%tos] := s/35[s3] *f temp/41[s0]
  temp/43[s1] := R/7[%tos]
  R/7[%tos] := float64u[r/8[%ebx] + 16]
  temp/45[s0] := R/7[%tos]
  R/7[%tos] := s/35[s3] *f temp/45[s0]
  temp/47[s0] := R/7[%tos]
  {temp/39[s2] temp/43[s1] temp/47[s0]}
  A/48[%eax] := alloc 28
  [A/48[%eax] + -4] := 6398
  float64u[A/48[%eax]] := temp/39[s2]
  float64u[A/48[%eax] + 8] := temp/43[s1]
  float64u[A/48[%eax] + 16] := temp/47[s0]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__ray_sphere_1056:
                  R/7[%tos] := float64u[center/10[%ecx]]
                  temp/13[s1] := R/7[%tos]
                  R/7[%tos] := float64u[orig/8[%eax]]
                  temp/15[s0] := R/7[%tos]
                  R/7[%tos] := temp/13[s1] -f temp/15[s0]
                  temp/17[s3] := R/7[%tos]
                  R/7[%tos] := float64u[center/10[%ecx] + 8]
                  temp/19[s1] := R/7[%tos]
                  R/7[%tos] := float64u[orig/8[%eax] + 8]
                  temp/21[s0] := R/7[%tos]
                  R/7[%tos] := temp/19[s1] -f temp/21[s0]
                  temp/23[s2] := R/7[%tos]
                  R/7[%tos] := float64u[center/10[%ecx] + 16]
                  temp/25[s1] := R/7[%tos]
                  R/7[%tos] := float64u[orig/8[%eax] + 16]
                  temp/27[s0] := R/7[%tos]
                  R/7[%tos] := temp/25[s1] -f temp/27[s0]
                  temp/29[s0] := R/7[%tos]
                  {dir/9[%ebx]* radius/11[%edx]* temp/17[s3] temp/23[s2]
                   temp/29[s0]}
                  v/30[%eax] := alloc 28
                  [v/30[%eax] + -4] := 6398
                  float64u[v/30[%eax]] := temp/17[s3]
                  float64u[v/30[%eax] + 8] := temp/23[s2]
                  float64u[v/30[%eax] + 16] := temp/29[s0]
                  R/7[%tos] := float64u[v/30[%eax]]
                  temp/32[s1] := R/7[%tos]
                  R/7[%tos] := float64u[dir/9[%ebx]]
                  temp/34[s0] := R/7[%tos]
                  R/7[%tos] := temp/32[s1] *f temp/34[s0]
                  temp/36[s2] := R/7[%tos]
                  R/7[%tos] := float64u[v/30[%eax] + 8]
                  temp/38[s1] := R/7[%tos]
                  R/7[%tos] := float64u[dir/9[%ebx] + 8]
                  temp/40[s0] := R/7[%tos]
                  R/7[%tos] := temp/38[s1] *f temp/40[s0]
                  temp/42[s0] := R/7[%tos]
                  R/7[%tos] := temp/36[s2] +f temp/42[s0]
                  temp/44[s2] := R/7[%tos]
                  R/7[%tos] := float64u[v/30[%eax] + 16]
                  temp/46[s1] := R/7[%tos]
                  R/7[%tos] := float64u[dir/9[%ebx] + 16]
                  temp/48[s0] := R/7[%tos]
                  R/7[%tos] := temp/46[s1] *f temp/48[s0]
                  temp/50[s0] := R/7[%tos]
                  R/7[%tos] := temp/44[s2] +f temp/50[s0]
                  b/52[s4] := R/7[%tos]
                  R/7[%tos] := b/52[s4] *f b/52[s4]
                  temp/54[s3] := R/7[%tos]
                  R/7[%tos] := float64u[v/30[%eax]]
                  temp/56[s1] := R/7[%tos]
                  R/7[%tos] := float64u[v/30[%eax]]
                  temp/58[s0] := R/7[%tos]
                  R/7[%tos] := temp/56[s1] *f temp/58[s0]
                  temp/60[s2] := R/7[%tos]
                  R/7[%tos] := float64u[v/30[%eax] + 8]
                  temp/62[s1] := R/7[%tos]
                  R/7[%tos] := float64u[v/30[%eax] + 8]
                  temp/64[s0] := R/7[%tos]
                  R/7[%tos] := temp/62[s1] *f temp/64[s0]
                  temp/66[s0] := R/7[%tos]
                  R/7[%tos] := temp/60[s2] +f temp/66[s0]
                  temp/68[s2] := R/7[%tos]
                  R/7[%tos] := float64u[v/30[%eax] + 16]
                  temp/70[s1] := R/7[%tos]
                  R/7[%tos] := float64u[v/30[%eax] + 16]
                  temp/72[s0] := R/7[%tos]
                  R/7[%tos] := temp/70[s1] *f temp/72[s0]
                  temp/74[s0] := R/7[%tos]
                  R/7[%tos] := temp/68[s2] +f temp/74[s0]
                  temp/76[s0] := R/7[%tos]
                  R/7[%tos] := temp/54[s3] -f temp/76[s0]
                  temp/78[s1] := R/7[%tos]
                  R/7[%tos] := float64u[radius/11[%edx]]
                  R/7[%tos] := R/7[%tos] *f float64[radius/11[%edx]]
                  temp/81[s0] := R/7[%tos]
                  R/7[%tos] := temp/78[s1] +f temp/81[s0]
                  d2/83[s1] := R/7[%tos]
                  R/7[%tos] := 0.
                  temp/85[s0] := R/7[%tos]
                  if not d2/83[s1] <f temp/85[s0] goto L132
                  I/86[%eax] := 1
                  goto L131
                  L132 [0]:
                  I/87[%eax] := 0
                  L131 [0]:
                  temp/88[%eax] := I/86[%eax]  * 2 + 1
                  if temp/88[%eax] ==s 1 goto L130
                  temp/108[%eax] := "camlPervasives"
                  A/109[%eax] := [temp/108[%eax] + 36]
                  reload retaddr
                  return R/0[%eax]
                  L130 [0]:
                  push d2/83[s1]
                  {b/52[s4]}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  d/89[s0] := R/7[%tos]
                  R/7[%tos] := b/52[s4] -f d/89[s0]
                  t1/91[s2] := R/7[%tos]
                  R/7[%tos] := b/52[s4] +f d/89[s0]
                  t2/93[s1] := R/7[%tos]
                  R/7[%tos] := 0.
                  temp/95[s0] := R/7[%tos]
                  if not t2/93[s1] >f temp/95[s0] goto L129
                  I/96[%eax] := 1
                  goto L128
                  L129 [0]:
                  I/97[%eax] := 0
                  L128 [0]:
                  temp/98[%eax] := I/96[%eax]  * 2 + 1
                  if temp/98[%eax] ==s 1 goto L124
                  R/7[%tos] := 0.
                  temp/102[s0] := R/7[%tos]
                  if not t1/91[s2] >f temp/102[s0] goto L127
                  I/103[%eax] := 1
                  goto L126
                  L127 [0]:
                  I/104[%eax] := 0
                  L126 [0]:
                  temp/105[%eax] := I/103[%eax]  * 2 + 1
                  if temp/105[%eax] ==s 1 goto L125
                  {t1/91[s2]}
                  A/107[%eax] := alloc 12
                  [A/107[%eax] + -4] := 2301
                  float64u[A/107[%eax]] := t1/91[s2]
                  reload retaddr
                  return R/0[%eax]
                  L125 [0]:
                  {t2/93[s1]}
                  A/106[%eax] := alloc 12
                  [A/106[%eax] + -4] := 2301
                  float64u[A/106[%eax]] := t2/93[s1]
                  reload retaddr
                  return R/0[%eax]
                  L124 [0]:
                  temp/99[%eax] := "camlPervasives"
                  A/100[%eax] := [temp/99[%eax] + 36]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__ray_sphere_1056:
  R/7[%tos] := float64u[center/10[%ecx]]
  temp/13[s1] := R/7[%tos]
  R/7[%tos] := float64u[orig/8[%eax]]
  temp/15[s0] := R/7[%tos]
  R/7[%tos] := temp/13[s1] -f temp/15[s0]
  temp/17[s3] := R/7[%tos]
  R/7[%tos] := float64u[center/10[%ecx] + 8]
  temp/19[s1] := R/7[%tos]
  R/7[%tos] := float64u[orig/8[%eax] + 8]
  temp/21[s0] := R/7[%tos]
  R/7[%tos] := temp/19[s1] -f temp/21[s0]
  temp/23[s2] := R/7[%tos]
  R/7[%tos] := float64u[center/10[%ecx] + 16]
  temp/25[s1] := R/7[%tos]
  R/7[%tos] := float64u[orig/8[%eax] + 16]
  temp/27[s0] := R/7[%tos]
  R/7[%tos] := temp/25[s1] -f temp/27[s0]
  temp/29[s0] := R/7[%tos]
  {dir/9[%ebx]* radius/11[%edx]* temp/17[s3] temp/23[s2] temp/29[s0]}
  v/30[%eax] := alloc 28
  [v/30[%eax] + -4] := 6398
  float64u[v/30[%eax]] := temp/17[s3]
  float64u[v/30[%eax] + 8] := temp/23[s2]
  float64u[v/30[%eax] + 16] := temp/29[s0]
  R/7[%tos] := float64u[v/30[%eax]]
  temp/32[s1] := R/7[%tos]
  R/7[%tos] := float64u[dir/9[%ebx]]
  temp/34[s0] := R/7[%tos]
  R/7[%tos] := temp/32[s1] *f temp/34[s0]
  temp/36[s2] := R/7[%tos]
  R/7[%tos] := float64u[v/30[%eax] + 8]
  temp/38[s1] := R/7[%tos]
  R/7[%tos] := float64u[dir/9[%ebx] + 8]
  temp/40[s0] := R/7[%tos]
  R/7[%tos] := temp/38[s1] *f temp/40[s0]
  temp/42[s0] := R/7[%tos]
  R/7[%tos] := temp/36[s2] +f temp/42[s0]
  temp/44[s2] := R/7[%tos]
  R/7[%tos] := float64u[v/30[%eax] + 16]
  temp/46[s1] := R/7[%tos]
  R/7[%tos] := float64u[dir/9[%ebx] + 16]
  temp/48[s0] := R/7[%tos]
  R/7[%tos] := temp/46[s1] *f temp/48[s0]
  temp/50[s0] := R/7[%tos]
  R/7[%tos] := temp/44[s2] +f temp/50[s0]
  b/52[s4] := R/7[%tos]
  R/7[%tos] := b/52[s4] *f b/52[s4]
  temp/54[s3] := R/7[%tos]
  R/7[%tos] := float64u[v/30[%eax]]
  temp/56[s1] := R/7[%tos]
  R/7[%tos] := float64u[v/30[%eax]]
  temp/58[s0] := R/7[%tos]
  R/7[%tos] := temp/56[s1] *f temp/58[s0]
  temp/60[s2] := R/7[%tos]
  R/7[%tos] := float64u[v/30[%eax] + 8]
  temp/62[s1] := R/7[%tos]
  R/7[%tos] := float64u[v/30[%eax] + 8]
  temp/64[s0] := R/7[%tos]
  R/7[%tos] := temp/62[s1] *f temp/64[s0]
  temp/66[s0] := R/7[%tos]
  R/7[%tos] := temp/60[s2] +f temp/66[s0]
  temp/68[s2] := R/7[%tos]
  R/7[%tos] := float64u[v/30[%eax] + 16]
  temp/70[s1] := R/7[%tos]
  R/7[%tos] := float64u[v/30[%eax] + 16]
  temp/72[s0] := R/7[%tos]
  R/7[%tos] := temp/70[s1] *f temp/72[s0]
  temp/74[s0] := R/7[%tos]
  R/7[%tos] := temp/68[s2] +f temp/74[s0]
  temp/76[s0] := R/7[%tos]
  R/7[%tos] := temp/54[s3] -f temp/76[s0]
  temp/78[s1] := R/7[%tos]
  R/7[%tos] := float64u[radius/11[%edx]]
  R/7[%tos] := R/7[%tos] *f float64[radius/11[%edx]]
  temp/81[s0] := R/7[%tos]
  R/7[%tos] := temp/78[s1] +f temp/81[s0]
  d2/83[s1] := R/7[%tos]
  R/7[%tos] := 0.
  temp/85[s0] := R/7[%tos]
  if not d2/83[s1] <f temp/85[s0] goto L132
  I/86[%eax] := 1
  goto L131
  L132 [2]:
  I/87[%eax] := 0
  L131 [3]:
  temp/88[%eax] := I/86[%eax]  * 2 + 1
  if temp/88[%eax] ==s 1 goto L130
  temp/108[%eax] := "camlPervasives"
  A/109[%eax] := [temp/108[%eax] + 36]
  reload retaddr
  return R/0[%eax]
  L130 [2]:
  push d2/83[s1]
  {b/52[s4]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  d/89[s0] := R/7[%tos]
  R/7[%tos] := b/52[s4] -f d/89[s0]
  t1/91[s2] := R/7[%tos]
  R/7[%tos] := b/52[s4] +f d/89[s0]
  t2/93[s1] := R/7[%tos]
  R/7[%tos] := 0.
  temp/95[s0] := R/7[%tos]
  if not t2/93[s1] >f temp/95[s0] goto L129
  I/96[%eax] := 1
  goto L128
  L129 [2]:
  I/97[%eax] := 0
  L128 [3]:
  temp/98[%eax] := I/96[%eax]  * 2 + 1
  if temp/98[%eax] ==s 1 goto L124
  R/7[%tos] := 0.
  temp/102[s0] := R/7[%tos]
  if not t1/91[s2] >f temp/102[s0] goto L127
  I/103[%eax] := 1
  goto L126
  L127 [2]:
  I/104[%eax] := 0
  L126 [3]:
  temp/105[%eax] := I/103[%eax]  * 2 + 1
  if temp/105[%eax] ==s 1 goto L125
  {t1/91[s2]}
  A/107[%eax] := alloc 12
  [A/107[%eax] + -4] := 2301
  float64u[A/107[%eax]] := t1/91[s2]
  reload retaddr
  return R/0[%eax]
  L125 [2]:
  {t2/93[s1]}
  A/106[%eax] := alloc 12
  [A/106[%eax] + -4] := 2301
  float64u[A/106[%eax]] := t2/93[s1]
  reload retaddr
  return R/0[%eax]
  L124 [2]:
  temp/99[%eax] := "camlPervasives"
  A/100[%eax] := [temp/99[%eax] + 36]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__intersects_1068:
                  if param/11[%edx] ==s 1 goto L143
                  spilled-env/17[s5] := env/12[%esi] (spill)
                  spilled-param/20[s2] := param/11[%edx] (spill)
                  spilled-hit/22[s0] := hit/10[%ecx] (spill)
                  spilled-dir/18[s4] := dir/9[%ebx] (spill)
                  spilled-orig/19[s3] := orig/8[%eax] (spill)
                  temp/13[%ebx] := [param/11[%edx]]
                  spilled-temp/21[s1] := temp/13[%ebx] (spill)
                  temp/14[%esi] := temp/14[%esi] + -16
                  dir/23[%ebx] := spilled-dir/18[s4] (reload)
                  hit/24[%ecx] := spilled-hit/22[s0] (reload)
                  temp/25[%edx] := spilled-temp/21[s1] (reload)
                  {spilled-env/17[s5]* spilled-dir/18[s4]*
                   spilled-orig/19[s3]* spilled-param/20[s2]*}
                  R/0[%eax] := call "camlCode__intersect_1067" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
                  temp/15[%ecx] := R/0[%eax]
                  param/26[%eax] := spilled-param/20[s2] (reload)
                  temp/16[%edx] := [param/26[%eax] + 4]
                  orig/27[%eax] := spilled-orig/19[s3] (reload)
                  dir/28[%ebx] := spilled-dir/18[s4] (reload)
                  env/29[%esi] := spilled-env/17[s5] (reload)
                  tailcall "camlCode__intersects_1068" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
                  L143 [0]:
                  R/0[%eax] := hit/10[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__intersects_1068:
  if param/11[%edx] ==s 1 goto L143
  spilled-env/17[s5] := env/12[%esi] (spill)
  spilled-param/20[s2] := param/11[%edx] (spill)
  spilled-hit/22[s0] := hit/10[%ecx] (spill)
  spilled-dir/18[s4] := dir/9[%ebx] (spill)
  spilled-orig/19[s3] := orig/8[%eax] (spill)
  temp/13[%ebx] := [param/11[%edx]]
  spilled-temp/21[s1] := temp/13[%ebx] (spill)
  temp/14[%esi] := temp/14[%esi] + -16
  dir/23[%ebx] := spilled-dir/18[s4] (reload)
  hit/24[%ecx] := spilled-hit/22[s0] (reload)
  temp/25[%edx] := spilled-temp/21[s1] (reload)
  {spilled-env/17[s5]* spilled-dir/18[s4]* spilled-orig/19[s3]*
   spilled-param/20[s2]*}
  R/0[%eax] := call "camlCode__intersect_1067" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
  temp/15[%ecx] := R/0[%eax]
  param/26[%eax] := spilled-param/20[s2] (reload)
  temp/16[%edx] := [param/26[%eax] + 4]
  orig/27[%eax] := spilled-orig/19[s3] (reload)
  dir/28[%ebx] := spilled-dir/18[s4] (reload)
  env/29[%esi] := spilled-env/17[s5] (reload)
  tailcall "camlCode__intersects_1068" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
  L143 [4]:
  R/0[%eax] := hit/10[%ecx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__intersect_1067:
                  orig/8[%ebp] := R/0[%eax]
                  spilled-dir/215[s0] := dir/9[%ebx] (spill)
                  spilled-hit/214[s1] := hit/10[%ecx] (spill)
                  spilled-env/213[s2] := env/12[%esi] (spill)
                  scene/219[%eax] := [param/11[%edx] + 8]
                  scene/13[s3] := scene/219[%eax]
                  center/14[%edi] := [param/11[%edx]]
                  radius/15[%ecx] := [param/11[%edx] + 4]
                  R/7[%tos] := float64u[center/14[%edi]]
                  temp/17[s1] := R/7[%tos]
                  R/7[%tos] := float64u[orig/8[%ebp]]
                  temp/19[s0] := R/7[%tos]
                  R/7[%tos] := temp/17[s1] -f temp/19[s0]
                  temp/21[s3] := R/7[%tos]
                  R/7[%tos] := float64u[center/14[%edi] + 8]
                  temp/23[s1] := R/7[%tos]
                  R/7[%tos] := float64u[orig/8[%ebp] + 8]
                  temp/25[s0] := R/7[%tos]
                  R/7[%tos] := temp/23[s1] -f temp/25[s0]
                  temp/27[s2] := R/7[%tos]
                  R/7[%tos] := float64u[center/14[%edi] + 16]
                  temp/29[s1] := R/7[%tos]
                  R/7[%tos] := float64u[orig/8[%ebp] + 16]
                  temp/31[s0] := R/7[%tos]
                  R/7[%tos] := temp/29[s1] -f temp/31[s0]
                  temp/33[s0] := R/7[%tos]
                  {orig/8[%ebp]* scene/13[s3]* center/14[%edi]*
                   radius/15[%ecx]* temp/21[s3] temp/27[s2] temp/33[s0]
                   spilled-env/213[s2]* spilled-hit/214[s1]*
                   spilled-dir/215[s0]*}
                  v/34[%eax] := alloc 28
                  [v/34[%eax] + -4] := 6398
                  float64u[v/34[%eax]] := temp/21[s3]
                  float64u[v/34[%eax] + 8] := temp/27[s2]
                  float64u[v/34[%eax] + 16] := temp/33[s0]
                  R/7[%tos] := float64u[v/34[%eax]]
                  temp/36[s1] := R/7[%tos]
                  dir/216[%ebx] := spilled-dir/215[s0] (reload)
                  R/7[%tos] := float64u[dir/216[%ebx]]
                  temp/38[s0] := R/7[%tos]
                  R/7[%tos] := temp/36[s1] *f temp/38[s0]
                  temp/40[s2] := R/7[%tos]
                  R/7[%tos] := float64u[v/34[%eax] + 8]
                  temp/42[s1] := R/7[%tos]
                  R/7[%tos] := float64u[dir/216[%ebx] + 8]
                  temp/44[s0] := R/7[%tos]
                  R/7[%tos] := temp/42[s1] *f temp/44[s0]
                  temp/46[s0] := R/7[%tos]
                  R/7[%tos] := temp/40[s2] +f temp/46[s0]
                  temp/48[s2] := R/7[%tos]
                  R/7[%tos] := float64u[v/34[%eax] + 16]
                  temp/50[s1] := R/7[%tos]
                  R/7[%tos] := float64u[dir/216[%ebx] + 16]
                  temp/52[s0] := R/7[%tos]
                  R/7[%tos] := temp/50[s1] *f temp/52[s0]
                  temp/54[s0] := R/7[%tos]
                  R/7[%tos] := temp/48[s2] +f temp/54[s0]
                  b/56[s4] := R/7[%tos]
                  R/7[%tos] := b/56[s4] *f b/56[s4]
                  temp/58[s3] := R/7[%tos]
                  R/7[%tos] := float64u[v/34[%eax]]
                  temp/60[s1] := R/7[%tos]
                  R/7[%tos] := float64u[v/34[%eax]]
                  temp/62[s0] := R/7[%tos]
                  R/7[%tos] := temp/60[s1] *f temp/62[s0]
                  temp/64[s2] := R/7[%tos]
                  R/7[%tos] := float64u[v/34[%eax] + 8]
                  temp/66[s1] := R/7[%tos]
                  R/7[%tos] := float64u[v/34[%eax] + 8]
                  temp/68[s0] := R/7[%tos]
                  R/7[%tos] := temp/66[s1] *f temp/68[s0]
                  temp/70[s0] := R/7[%tos]
                  R/7[%tos] := temp/64[s2] +f temp/70[s0]
                  temp/72[s2] := R/7[%tos]
                  R/7[%tos] := float64u[v/34[%eax] + 16]
                  temp/74[s1] := R/7[%tos]
                  R/7[%tos] := float64u[v/34[%eax] + 16]
                  temp/76[s0] := R/7[%tos]
                  R/7[%tos] := temp/74[s1] *f temp/76[s0]
                  temp/78[s0] := R/7[%tos]
                  R/7[%tos] := temp/72[s2] +f temp/78[s0]
                  temp/80[s0] := R/7[%tos]
                  R/7[%tos] := temp/58[s3] -f temp/80[s0]
                  temp/82[s1] := R/7[%tos]
                  R/7[%tos] := float64u[radius/15[%ecx]]
                  R/7[%tos] := R/7[%tos] *f float64[radius/15[%ecx]]
                  temp/85[s0] := R/7[%tos]
                  R/7[%tos] := temp/82[s1] +f temp/85[s0]
                  d2/87[s1] := R/7[%tos]
                  R/7[%tos] := 0.
                  temp/89[s0] := R/7[%tos]
                  if not d2/87[s1] <f temp/89[s0] goto L159
                  I/90[%eax] := 1
                  goto L158
                  L159 [0]:
                  I/91[%eax] := 0
                  L158 [0]:
                  temp/92[%eax] := I/90[%eax]  * 2 + 1
                  if temp/92[%eax] ==s 1 goto L157
                  temp/93[%eax] := "camlPervasives"
                  match/94[%esi] := [temp/93[%eax] + 36]
                  goto L150
                  L157 [0]:
                  push d2/87[s1]
                  {orig/8[%ebp]* scene/13[s3]* center/14[%edi]* b/56[s4]
                   spilled-env/213[s2]* spilled-hit/214[s1]* dir/216[%ebx]*}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  d/95[s0] := R/7[%tos]
                  R/7[%tos] := b/56[s4] -f d/95[s0]
                  t1/97[s2] := R/7[%tos]
                  R/7[%tos] := b/56[s4] +f d/95[s0]
                  t2/99[s1] := R/7[%tos]
                  R/7[%tos] := 0.
                  temp/101[s0] := R/7[%tos]
                  if not t2/99[s1] >f temp/101[s0] goto L156
                  I/102[%eax] := 1
                  goto L155
                  L156 [0]:
                  I/103[%eax] := 0
                  L155 [0]:
                  temp/104[%eax] := I/102[%eax]  * 2 + 1
                  if temp/104[%eax] ==s 1 goto L151
                  R/7[%tos] := 0.
                  temp/106[s0] := R/7[%tos]
                  if not t1/97[s2] >f temp/106[s0] goto L154
                  I/107[%eax] := 1
                  goto L153
                  L154 [0]:
                  I/108[%eax] := 0
                  L153 [0]:
                  temp/109[%eax] := I/107[%eax]  * 2 + 1
                  if temp/109[%eax] ==s 1 goto L152
                  {orig/8[%ebp]* scene/13[s3]* center/14[%edi]* t1/97[s2]
                   spilled-env/213[s2]* spilled-hit/214[s1]* dir/216[%ebx]*}
                  A/110[%esi] := alloc 12
                  [A/110[%esi] + -4] := 2301
                  float64u[A/110[%esi]] := t1/97[s2]
                  goto L150
                  L152 [0]:
                  {orig/8[%ebp]* scene/13[s3]* center/14[%edi]* t2/99[s1]
                   spilled-env/213[s2]* spilled-hit/214[s1]* dir/216[%ebx]*}
                  A/111[%esi] := alloc 12
                  [A/111[%esi] + -4] := 2301
                  float64u[A/111[%esi]] := t2/99[s1]
                  goto L150
                  L151 [0]:
                  temp/112[%eax] := "camlPervasives"
                  A/113[%esi] := [temp/112[%eax] + 36]
                  L150 [0]:
                  hit/217[%ecx] := spilled-hit/214[s1] (reload)
                  temp/114[%eax] := [hit/217[%ecx]]
                  R/7[%tos] := float64u[temp/114[%eax]]
                  R/7[%tos] := float64u[match/94[%esi]]
                  if not R/7[%tos] >=f R/7[%tos] goto L149
                  I/117[%eax] := 1
                  goto L148
                  L149 [0]:
                  I/118[%eax] := 0
                  L148 [0]:
                  temp/119[%eax] := I/117[%eax]  * 2 + 1
                  if temp/119[%eax] ==s 1 goto L147
                  R/0[%eax] := hit/217[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  L147 [0]:
                  if scene/13[s3] ==s 1 goto L146
                  env/218[%esi] := spilled-env/213[s2] (reload)
                  temp/212[%esi] := temp/212[%esi] + 16
                  R/0[%eax] := orig/8[%ebp]
                  R/3[%edx] := scene/13[s3]
                  tailcall "camlCode__intersects_1068" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
                  L146 [0]:
                  R/7[%tos] := float64u[dir/216[%ebx]]
                  temp/121[s0] := R/7[%tos]
                  R/7[%tos] := temp/121[s0] *f float64[match/94[%esi]]
                  temp/123[s2] := R/7[%tos]
                  R/7[%tos] := float64u[dir/216[%ebx] + 8]
                  temp/125[s0] := R/7[%tos]
                  R/7[%tos] := temp/125[s0] *f float64[match/94[%esi]]
                  temp/127[s1] := R/7[%tos]
                  R/7[%tos] := float64u[dir/216[%ebx] + 16]
                  temp/129[s0] := R/7[%tos]
                  R/7[%tos] := temp/129[s0] *f float64[match/94[%esi]]
                  temp/131[s0] := R/7[%tos]
                  {orig/8[%ebp]* center/14[%edi]* match/94[%esi]*
                   temp/123[s2] temp/127[s1] temp/131[s0]}
                  b/132[%ebx] := alloc 84
                  [b/132[%ebx] + -4] := 6398
                  float64u[b/132[%ebx]] := temp/123[s2]
                  float64u[b/132[%ebx] + 8] := temp/127[s1]
                  float64u[b/132[%ebx] + 16] := temp/131[s0]
                  R/7[%tos] := float64u[orig/8[%ebp]]
                  temp/134[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/132[%ebx]]
                  temp/136[s0] := R/7[%tos]
                  R/7[%tos] := temp/134[s1] +f temp/136[s0]
                  temp/138[s3] := R/7[%tos]
                  R/7[%tos] := float64u[orig/8[%ebp] + 8]
                  temp/140[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/132[%ebx] + 8]
                  temp/142[s0] := R/7[%tos]
                  R/7[%tos] := temp/140[s1] +f temp/142[s0]
                  temp/144[s2] := R/7[%tos]
                  R/7[%tos] := float64u[orig/8[%ebp] + 16]
                  temp/146[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/132[%ebx] + 16]
                  temp/148[s0] := R/7[%tos]
                  R/7[%tos] := temp/146[s1] +f temp/148[s0]
                  temp/150[s0] := R/7[%tos]
                  a/151[%eax] := b/132[%ebx] + 28
                  [a/151[%eax] + -4] := 6398
                  float64u[a/151[%eax]] := temp/138[s3]
                  float64u[a/151[%eax] + 8] := temp/144[s2]
                  float64u[a/151[%eax] + 16] := temp/150[s0]
                  R/7[%tos] := float64u[a/151[%eax]]
                  temp/153[s1] := R/7[%tos]
                  R/7[%tos] := float64u[center/14[%edi]]
                  temp/155[s0] := R/7[%tos]
                  R/7[%tos] := temp/153[s1] -f temp/155[s0]
                  temp/157[s3] := R/7[%tos]
                  R/7[%tos] := float64u[a/151[%eax] + 8]
                  temp/159[s1] := R/7[%tos]
                  R/7[%tos] := float64u[center/14[%edi] + 8]
                  temp/161[s0] := R/7[%tos]
                  R/7[%tos] := temp/159[s1] -f temp/161[s0]
                  temp/163[s2] := R/7[%tos]
                  R/7[%tos] := float64u[a/151[%eax] + 16]
                  temp/165[s1] := R/7[%tos]
                  R/7[%tos] := float64u[center/14[%edi] + 16]
                  temp/167[s0] := R/7[%tos]
                  R/7[%tos] := temp/165[s1] -f temp/167[s0]
                  temp/169[s0] := R/7[%tos]
                  r/170[%ebx] := b/132[%ebx] + 56
                  [r/170[%ebx] + -4] := 6398
                  float64u[r/170[%ebx]] := temp/157[s3]
                  float64u[r/170[%ebx] + 8] := temp/163[s2]
                  float64u[r/170[%ebx] + 16] := temp/169[s0]
                  R/7[%tos] := 1.
                  temp/172[s3] := R/7[%tos]
                  R/7[%tos] := float64u[r/170[%ebx]]
                  temp/174[s1] := R/7[%tos]
                  R/7[%tos] := float64u[r/170[%ebx]]
                  temp/176[s0] := R/7[%tos]
                  R/7[%tos] := temp/174[s1] *f temp/176[s0]
                  temp/178[s2] := R/7[%tos]
                  R/7[%tos] := float64u[r/170[%ebx] + 8]
                  temp/180[s1] := R/7[%tos]
                  R/7[%tos] := float64u[r/170[%ebx] + 8]
                  temp/182[s0] := R/7[%tos]
                  R/7[%tos] := temp/180[s1] *f temp/182[s0]
                  temp/184[s0] := R/7[%tos]
                  R/7[%tos] := temp/178[s2] +f temp/184[s0]
                  temp/186[s2] := R/7[%tos]
                  R/7[%tos] := float64u[r/170[%ebx] + 16]
                  temp/188[s1] := R/7[%tos]
                  R/7[%tos] := float64u[r/170[%ebx] + 16]
                  temp/190[s0] := R/7[%tos]
                  R/7[%tos] := temp/188[s1] *f temp/190[s0]
                  temp/192[s0] := R/7[%tos]
                  R/7[%tos] := temp/186[s2] +f temp/192[s0]
                  temp/194[s0] := R/7[%tos]
                  push temp/194[s0]
                  {match/94[%esi]* r/170[%ebx]* temp/172[s3]}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  temp/195[s0] := R/7[%tos]
                  R/7[%tos] := temp/172[s3] /f temp/195[s0]
                  s/197[s3] := R/7[%tos]
                  R/7[%tos] := float64u[r/170[%ebx]]
                  temp/199[s0] := R/7[%tos]
                  R/7[%tos] := s/197[s3] *f temp/199[s0]
                  temp/201[s2] := R/7[%tos]
                  R/7[%tos] := float64u[r/170[%ebx] + 8]
                  temp/203[s0] := R/7[%tos]
                  R/7[%tos] := s/197[s3] *f temp/203[s0]
                  temp/205[s1] := R/7[%tos]
                  R/7[%tos] := float64u[r/170[%ebx] + 16]
                  temp/207[s0] := R/7[%tos]
                  R/7[%tos] := s/197[s3] *f temp/207[s0]
                  temp/209[s0] := R/7[%tos]
                  {match/94[%esi]* temp/201[s2] temp/205[s1] temp/209[s0]}
                  temp/210[%ebx] := alloc 40
                  [temp/210[%ebx] + -4] := 6398
                  float64u[temp/210[%ebx]] := temp/201[s2]
                  float64u[temp/210[%ebx] + 8] := temp/205[s1]
                  float64u[temp/210[%ebx] + 16] := temp/209[s0]
                  A/211[%eax] := temp/210[%ebx] + 28
                  [A/211[%eax] + -4] := 2048
                  [A/211[%eax]] := match/94[%esi]
                  [A/211[%eax] + 4] := temp/210[%ebx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__intersect_1067:
  orig/8[%ebp] := R/0[%eax]
  spilled-dir/215[s0] := dir/9[%ebx] (spill)
  spilled-hit/214[s1] := hit/10[%ecx] (spill)
  spilled-env/213[s2] := env/12[%esi] (spill)
  scene/219[%eax] := [param/11[%edx] + 8]
  scene/13[s3] := scene/219[%eax]
  center/14[%edi] := [param/11[%edx]]
  radius/15[%ecx] := [param/11[%edx] + 4]
  R/7[%tos] := float64u[center/14[%edi]]
  temp/17[s1] := R/7[%tos]
  R/7[%tos] := float64u[orig/8[%ebp]]
  temp/19[s0] := R/7[%tos]
  R/7[%tos] := temp/17[s1] -f temp/19[s0]
  temp/21[s3] := R/7[%tos]
  R/7[%tos] := float64u[center/14[%edi] + 8]
  temp/23[s1] := R/7[%tos]
  R/7[%tos] := float64u[orig/8[%ebp] + 8]
  temp/25[s0] := R/7[%tos]
  R/7[%tos] := temp/23[s1] -f temp/25[s0]
  temp/27[s2] := R/7[%tos]
  R/7[%tos] := float64u[center/14[%edi] + 16]
  temp/29[s1] := R/7[%tos]
  R/7[%tos] := float64u[orig/8[%ebp] + 16]
  temp/31[s0] := R/7[%tos]
  R/7[%tos] := temp/29[s1] -f temp/31[s0]
  temp/33[s0] := R/7[%tos]
  {orig/8[%ebp]* scene/13[s3]* center/14[%edi]* radius/15[%ecx]* temp/21[s3]
   temp/27[s2] temp/33[s0] spilled-env/213[s2]* spilled-hit/214[s1]*
   spilled-dir/215[s0]*}
  v/34[%eax] := alloc 28
  [v/34[%eax] + -4] := 6398
  float64u[v/34[%eax]] := temp/21[s3]
  float64u[v/34[%eax] + 8] := temp/27[s2]
  float64u[v/34[%eax] + 16] := temp/33[s0]
  R/7[%tos] := float64u[v/34[%eax]]
  temp/36[s1] := R/7[%tos]
  dir/216[%ebx] := spilled-dir/215[s0] (reload)
  R/7[%tos] := float64u[dir/216[%ebx]]
  temp/38[s0] := R/7[%tos]
  R/7[%tos] := temp/36[s1] *f temp/38[s0]
  temp/40[s2] := R/7[%tos]
  R/7[%tos] := float64u[v/34[%eax] + 8]
  temp/42[s1] := R/7[%tos]
  R/7[%tos] := float64u[dir/216[%ebx] + 8]
  temp/44[s0] := R/7[%tos]
  R/7[%tos] := temp/42[s1] *f temp/44[s0]
  temp/46[s0] := R/7[%tos]
  R/7[%tos] := temp/40[s2] +f temp/46[s0]
  temp/48[s2] := R/7[%tos]
  R/7[%tos] := float64u[v/34[%eax] + 16]
  temp/50[s1] := R/7[%tos]
  R/7[%tos] := float64u[dir/216[%ebx] + 16]
  temp/52[s0] := R/7[%tos]
  R/7[%tos] := temp/50[s1] *f temp/52[s0]
  temp/54[s0] := R/7[%tos]
  R/7[%tos] := temp/48[s2] +f temp/54[s0]
  b/56[s4] := R/7[%tos]
  R/7[%tos] := b/56[s4] *f b/56[s4]
  temp/58[s3] := R/7[%tos]
  R/7[%tos] := float64u[v/34[%eax]]
  temp/60[s1] := R/7[%tos]
  R/7[%tos] := float64u[v/34[%eax]]
  temp/62[s0] := R/7[%tos]
  R/7[%tos] := temp/60[s1] *f temp/62[s0]
  temp/64[s2] := R/7[%tos]
  R/7[%tos] := float64u[v/34[%eax] + 8]
  temp/66[s1] := R/7[%tos]
  R/7[%tos] := float64u[v/34[%eax] + 8]
  temp/68[s0] := R/7[%tos]
  R/7[%tos] := temp/66[s1] *f temp/68[s0]
  temp/70[s0] := R/7[%tos]
  R/7[%tos] := temp/64[s2] +f temp/70[s0]
  temp/72[s2] := R/7[%tos]
  R/7[%tos] := float64u[v/34[%eax] + 16]
  temp/74[s1] := R/7[%tos]
  R/7[%tos] := float64u[v/34[%eax] + 16]
  temp/76[s0] := R/7[%tos]
  R/7[%tos] := temp/74[s1] *f temp/76[s0]
  temp/78[s0] := R/7[%tos]
  R/7[%tos] := temp/72[s2] +f temp/78[s0]
  temp/80[s0] := R/7[%tos]
  R/7[%tos] := temp/58[s3] -f temp/80[s0]
  temp/82[s1] := R/7[%tos]
  R/7[%tos] := float64u[radius/15[%ecx]]
  R/7[%tos] := R/7[%tos] *f float64[radius/15[%ecx]]
  temp/85[s0] := R/7[%tos]
  R/7[%tos] := temp/82[s1] +f temp/85[s0]
  d2/87[s1] := R/7[%tos]
  R/7[%tos] := 0.
  temp/89[s0] := R/7[%tos]
  if not d2/87[s1] <f temp/89[s0] goto L159
  I/90[%eax] := 1
  goto L158
  L159 [2]:
  I/91[%eax] := 0
  L158 [3]:
  temp/92[%eax] := I/90[%eax]  * 2 + 1
  if temp/92[%eax] ==s 1 goto L157
  temp/93[%eax] := "camlPervasives"
  match/94[%esi] := [temp/93[%eax] + 36]
  goto L150
  L157 [2]:
  push d2/87[s1]
  {orig/8[%ebp]* scene/13[s3]* center/14[%edi]* b/56[s4] spilled-env/213[s2]*
   spilled-hit/214[s1]* dir/216[%ebx]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  d/95[s0] := R/7[%tos]
  R/7[%tos] := b/56[s4] -f d/95[s0]
  t1/97[s2] := R/7[%tos]
  R/7[%tos] := b/56[s4] +f d/95[s0]
  t2/99[s1] := R/7[%tos]
  R/7[%tos] := 0.
  temp/101[s0] := R/7[%tos]
  if not t2/99[s1] >f temp/101[s0] goto L156
  I/102[%eax] := 1
  goto L155
  L156 [2]:
  I/103[%eax] := 0
  L155 [3]:
  temp/104[%eax] := I/102[%eax]  * 2 + 1
  if temp/104[%eax] ==s 1 goto L151
  R/7[%tos] := 0.
  temp/106[s0] := R/7[%tos]
  if not t1/97[s2] >f temp/106[s0] goto L154
  I/107[%eax] := 1
  goto L153
  L154 [2]:
  I/108[%eax] := 0
  L153 [3]:
  temp/109[%eax] := I/107[%eax]  * 2 + 1
  if temp/109[%eax] ==s 1 goto L152
  {orig/8[%ebp]* scene/13[s3]* center/14[%edi]* t1/97[s2]
   spilled-env/213[s2]* spilled-hit/214[s1]* dir/216[%ebx]*}
  A/110[%esi] := alloc 12
  [A/110[%esi] + -4] := 2301
  float64u[A/110[%esi]] := t1/97[s2]
  goto L150
  L152 [2]:
  {orig/8[%ebp]* scene/13[s3]* center/14[%edi]* t2/99[s1]
   spilled-env/213[s2]* spilled-hit/214[s1]* dir/216[%ebx]*}
  A/111[%esi] := alloc 12
  [A/111[%esi] + -4] := 2301
  float64u[A/111[%esi]] := t2/99[s1]
  goto L150
  L151 [2]:
  temp/112[%eax] := "camlPervasives"
  A/113[%esi] := [temp/112[%eax] + 36]
  L150 [5]:
  hit/217[%ecx] := spilled-hit/214[s1] (reload)
  temp/114[%eax] := [hit/217[%ecx]]
  R/7[%tos] := float64u[temp/114[%eax]]
  R/7[%tos] := float64u[match/94[%esi]]
  if not R/7[%tos] >=f R/7[%tos] goto L149
  I/117[%eax] := 1
  goto L148
  L149 [2]:
  I/118[%eax] := 0
  L148 [3]:
  temp/119[%eax] := I/117[%eax]  * 2 + 1
  if temp/119[%eax] ==s 1 goto L147
  R/0[%eax] := hit/217[%ecx]
  reload retaddr
  return R/0[%eax]
  L147 [2]:
  if scene/13[s3] ==s 1 goto L146
  env/218[%esi] := spilled-env/213[s2] (reload)
  temp/212[%esi] := temp/212[%esi] + 16
  R/0[%eax] := orig/8[%ebp]
  R/3[%edx] := scene/13[s3]
  tailcall "camlCode__intersects_1068" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
  L146 [4]:
  R/7[%tos] := float64u[dir/216[%ebx]]
  temp/121[s0] := R/7[%tos]
  R/7[%tos] := temp/121[s0] *f float64[match/94[%esi]]
  temp/123[s2] := R/7[%tos]
  R/7[%tos] := float64u[dir/216[%ebx] + 8]
  temp/125[s0] := R/7[%tos]
  R/7[%tos] := temp/125[s0] *f float64[match/94[%esi]]
  temp/127[s1] := R/7[%tos]
  R/7[%tos] := float64u[dir/216[%ebx] + 16]
  temp/129[s0] := R/7[%tos]
  R/7[%tos] := temp/129[s0] *f float64[match/94[%esi]]
  temp/131[s0] := R/7[%tos]
  {orig/8[%ebp]* center/14[%edi]* match/94[%esi]* temp/123[s2] temp/127[s1]
   temp/131[s0]}
  b/132[%ebx] := alloc 84
  [b/132[%ebx] + -4] := 6398
  float64u[b/132[%ebx]] := temp/123[s2]
  float64u[b/132[%ebx] + 8] := temp/127[s1]
  float64u[b/132[%ebx] + 16] := temp/131[s0]
  R/7[%tos] := float64u[orig/8[%ebp]]
  temp/134[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/132[%ebx]]
  temp/136[s0] := R/7[%tos]
  R/7[%tos] := temp/134[s1] +f temp/136[s0]
  temp/138[s3] := R/7[%tos]
  R/7[%tos] := float64u[orig/8[%ebp] + 8]
  temp/140[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/132[%ebx] + 8]
  temp/142[s0] := R/7[%tos]
  R/7[%tos] := temp/140[s1] +f temp/142[s0]
  temp/144[s2] := R/7[%tos]
  R/7[%tos] := float64u[orig/8[%ebp] + 16]
  temp/146[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/132[%ebx] + 16]
  temp/148[s0] := R/7[%tos]
  R/7[%tos] := temp/146[s1] +f temp/148[s0]
  temp/150[s0] := R/7[%tos]
  a/151[%eax] := b/132[%ebx] + 28
  [a/151[%eax] + -4] := 6398
  float64u[a/151[%eax]] := temp/138[s3]
  float64u[a/151[%eax] + 8] := temp/144[s2]
  float64u[a/151[%eax] + 16] := temp/150[s0]
  R/7[%tos] := float64u[a/151[%eax]]
  temp/153[s1] := R/7[%tos]
  R/7[%tos] := float64u[center/14[%edi]]
  temp/155[s0] := R/7[%tos]
  R/7[%tos] := temp/153[s1] -f temp/155[s0]
  temp/157[s3] := R/7[%tos]
  R/7[%tos] := float64u[a/151[%eax] + 8]
  temp/159[s1] := R/7[%tos]
  R/7[%tos] := float64u[center/14[%edi] + 8]
  temp/161[s0] := R/7[%tos]
  R/7[%tos] := temp/159[s1] -f temp/161[s0]
  temp/163[s2] := R/7[%tos]
  R/7[%tos] := float64u[a/151[%eax] + 16]
  temp/165[s1] := R/7[%tos]
  R/7[%tos] := float64u[center/14[%edi] + 16]
  temp/167[s0] := R/7[%tos]
  R/7[%tos] := temp/165[s1] -f temp/167[s0]
  temp/169[s0] := R/7[%tos]
  r/170[%ebx] := b/132[%ebx] + 56
  [r/170[%ebx] + -4] := 6398
  float64u[r/170[%ebx]] := temp/157[s3]
  float64u[r/170[%ebx] + 8] := temp/163[s2]
  float64u[r/170[%ebx] + 16] := temp/169[s0]
  R/7[%tos] := 1.
  temp/172[s3] := R/7[%tos]
  R/7[%tos] := float64u[r/170[%ebx]]
  temp/174[s1] := R/7[%tos]
  R/7[%tos] := float64u[r/170[%ebx]]
  temp/176[s0] := R/7[%tos]
  R/7[%tos] := temp/174[s1] *f temp/176[s0]
  temp/178[s2] := R/7[%tos]
  R/7[%tos] := float64u[r/170[%ebx] + 8]
  temp/180[s1] := R/7[%tos]
  R/7[%tos] := float64u[r/170[%ebx] + 8]
  temp/182[s0] := R/7[%tos]
  R/7[%tos] := temp/180[s1] *f temp/182[s0]
  temp/184[s0] := R/7[%tos]
  R/7[%tos] := temp/178[s2] +f temp/184[s0]
  temp/186[s2] := R/7[%tos]
  R/7[%tos] := float64u[r/170[%ebx] + 16]
  temp/188[s1] := R/7[%tos]
  R/7[%tos] := float64u[r/170[%ebx] + 16]
  temp/190[s0] := R/7[%tos]
  R/7[%tos] := temp/188[s1] *f temp/190[s0]
  temp/192[s0] := R/7[%tos]
  R/7[%tos] := temp/186[s2] +f temp/192[s0]
  temp/194[s0] := R/7[%tos]
  push temp/194[s0]
  {match/94[%esi]* r/170[%ebx]* temp/172[s3]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  temp/195[s0] := R/7[%tos]
  R/7[%tos] := temp/172[s3] /f temp/195[s0]
  s/197[s3] := R/7[%tos]
  R/7[%tos] := float64u[r/170[%ebx]]
  temp/199[s0] := R/7[%tos]
  R/7[%tos] := s/197[s3] *f temp/199[s0]
  temp/201[s2] := R/7[%tos]
  R/7[%tos] := float64u[r/170[%ebx] + 8]
  temp/203[s0] := R/7[%tos]
  R/7[%tos] := s/197[s3] *f temp/203[s0]
  temp/205[s1] := R/7[%tos]
  R/7[%tos] := float64u[r/170[%ebx] + 16]
  temp/207[s0] := R/7[%tos]
  R/7[%tos] := s/197[s3] *f temp/207[s0]
  temp/209[s0] := R/7[%tos]
  {match/94[%esi]* temp/201[s2] temp/205[s1] temp/209[s0]}
  temp/210[%ebx] := alloc 40
  [temp/210[%ebx] + -4] := 6398
  float64u[temp/210[%ebx]] := temp/201[s2]
  float64u[temp/210[%ebx] + 8] := temp/205[s1]
  float64u[temp/210[%ebx] + 16] := temp/209[s0]
  A/211[%eax] := temp/210[%ebx] + 28
  [A/211[%eax] + -4] := 2048
  [A/211[%eax]] := match/94[%esi]
  [A/211[%eax] + 4] := temp/210[%ebx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__ray_trace_1086:
                  dir/8[%edi] := R/0[%eax]
                  spilled-dir/122[s0] := dir/8[%edi] (spill)
                  scene/9[%edx] := R/1[%ebx]
                  spilled-scene/121[s1] := scene/9[%edx] (spill)
                  temp/10[%eax] := "camlCode"
                  temp/11[%ebp] := [temp/10[%eax] + 4]
                  temp/12[%eax] := "camlPervasives"
                  temp/13[%ebx] := [temp/12[%eax] + 36]
                  temp/14[%eax] := "camlCode"
                  temp/15[%esi] := [temp/14[%eax] + 4]
                  {dir/8[%edi]* scene/9[%edx]* temp/11[%ebp]* temp/13[%ebx]*
                   temp/15[%esi]* spilled-scene/121[s1]*
                   spilled-dir/122[s0]*}
                  temp/16[%ecx] := alloc 12
                  [temp/16[%ecx] + -4] := 2048
                  [temp/16[%ecx]] := temp/13[%ebx]
                  [temp/16[%ecx] + 4] := temp/15[%esi]
                  temp/17[%eax] := "camlCode"
                  temp/18[%esi] := [temp/17[%eax] + 36]
                  R/0[%eax] := temp/11[%ebp]
                  R/1[%ebx] := dir/8[%edi]
                  {spilled-scene/121[s1]* spilled-dir/122[s0]*}
                  R/0[%eax] := call "camlCode__intersect_1067" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
                  match/19[%esi] := R/0[%eax]
                  n/20[%ebx] := [match/19[%esi] + 4]
                  temp/21[%eax] := "camlCode"
                  b/22[%eax] := [temp/21[%eax] + 44]
                  R/7[%tos] := float64u[n/20[%ebx]]
                  temp/24[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/22[%eax]]
                  temp/26[s0] := R/7[%tos]
                  R/7[%tos] := temp/24[s1] *f temp/26[s0]
                  temp/28[s2] := R/7[%tos]
                  R/7[%tos] := float64u[n/20[%ebx] + 8]
                  temp/30[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/22[%eax] + 8]
                  temp/32[s0] := R/7[%tos]
                  R/7[%tos] := temp/30[s1] *f temp/32[s0]
                  temp/34[s0] := R/7[%tos]
                  R/7[%tos] := temp/28[s2] +f temp/34[s0]
                  temp/36[s2] := R/7[%tos]
                  R/7[%tos] := float64u[n/20[%ebx] + 16]
                  temp/38[s1] := R/7[%tos]
                  R/7[%tos] := float64u[b/22[%eax] + 16]
                  temp/40[s0] := R/7[%tos]
                  R/7[%tos] := temp/38[s1] *f temp/40[s0]
                  temp/42[s0] := R/7[%tos]
                  R/7[%tos] := temp/36[s2] +f temp/42[s0]
                  g/44[s0] := R/7[%tos]
                  R/7[%tos] := 0.
                  temp/46[s1] := R/7[%tos]
                  if not g/44[s0] <=f temp/46[s1] goto L181
                  I/47[%eax] := 1
                  goto L180
                  L181 [0]:
                  I/48[%eax] := 0
                  L180 [0]:
                  temp/49[%eax] := I/47[%eax]  * 2 + 1
                  if temp/49[%eax] ==s 1 goto L179
                  A/119[%eax] := "camlCode__20"
                  reload retaddr
                  return R/0[%eax]
                  L179 [0]:
                  temp/50[%eax] := "camlPervasives"
                  temp/51[%eax] := [temp/50[%eax] + 56]
                  pushfloat [temp/51[%eax]]
                  {match/19[%esi]* n/20[%ebx]* spilled-g/120[s0]
                   spilled-scene/121[s1]* spilled-dir/122[s0]*}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  s/52[s4] := R/7[%tos]
                  R/7[%tos] := float64u[n/20[%ebx]]
                  temp/54[s1] := R/7[%tos]
                  R/7[%tos] := s/52[s4] *f temp/54[s1]
                  temp/56[s3] := R/7[%tos]
                  R/7[%tos] := float64u[n/20[%ebx] + 8]
                  temp/58[s1] := R/7[%tos]
                  R/7[%tos] := s/52[s4] *f temp/58[s1]
                  temp/60[s2] := R/7[%tos]
                  R/7[%tos] := float64u[n/20[%ebx] + 16]
                  temp/62[s1] := R/7[%tos]
                  R/7[%tos] := s/52[s4] *f temp/62[s1]
                  temp/64[s1] := R/7[%tos]
                  {match/19[%esi]* temp/56[s3] temp/60[s2] temp/64[s1]
                   spilled-g/120[s0] spilled-scene/121[s1]*
                   spilled-dir/122[s0]*}
                  b/65[%ecx] := alloc 96
                  [b/65[%ecx] + -4] := 6398
                  float64u[b/65[%ecx]] := temp/56[s3]
                  float64u[b/65[%ecx] + 8] := temp/60[s2]
                  float64u[b/65[%ecx] + 16] := temp/64[s1]
                  s/66[%ebx] := [match/19[%esi]]
                  dir/123[%eax] := spilled-dir/122[s0] (reload)
                  R/7[%tos] := float64u[dir/123[%eax]]
                  temp/68[s1] := R/7[%tos]
                  R/7[%tos] := temp/68[s1] *f float64[s/66[%ebx]]
                  temp/70[s3] := R/7[%tos]
                  R/7[%tos] := float64u[dir/123[%eax] + 8]
                  temp/72[s1] := R/7[%tos]
                  R/7[%tos] := temp/72[s1] *f float64[s/66[%ebx]]
                  temp/74[s2] := R/7[%tos]
                  R/7[%tos] := float64u[dir/123[%eax] + 16]
                  temp/76[s1] := R/7[%tos]
                  R/7[%tos] := temp/76[s1] *f float64[s/66[%ebx]]
                  temp/78[s1] := R/7[%tos]
                  a/79[%eax] := b/65[%ecx] + 28
                  [a/79[%eax] + -4] := 6398
                  float64u[a/79[%eax]] := temp/70[s3]
                  float64u[a/79[%eax] + 8] := temp/74[s2]
                  float64u[a/79[%eax] + 16] := temp/78[s1]
                  R/7[%tos] := float64u[a/79[%eax]]
                  temp/81[s2] := R/7[%tos]
                  R/7[%tos] := float64u[b/65[%ecx]]
                  temp/83[s1] := R/7[%tos]
                  R/7[%tos] := temp/81[s2] +f temp/83[s1]
                  temp/85[s4] := R/7[%tos]
                  R/7[%tos] := float64u[a/79[%eax] + 8]
                  temp/87[s2] := R/7[%tos]
                  R/7[%tos] := float64u[b/65[%ecx] + 8]
                  temp/89[s1] := R/7[%tos]
                  R/7[%tos] := temp/87[s2] +f temp/89[s1]
                  temp/91[s3] := R/7[%tos]
                  R/7[%tos] := float64u[a/79[%eax] + 16]
                  temp/93[s2] := R/7[%tos]
                  R/7[%tos] := float64u[b/65[%ecx] + 16]
                  temp/95[s1] := R/7[%tos]
                  R/7[%tos] := temp/93[s2] +f temp/95[s1]
                  temp/97[s1] := R/7[%tos]
                  p/98[%eax] := b/65[%ecx] + 56
                  [p/98[%eax] + -4] := 6398
                  float64u[p/98[%eax]] := temp/85[s4]
                  float64u[p/98[%eax] + 8] := temp/91[s3]
                  float64u[p/98[%eax] + 16] := temp/97[s1]
                  temp/99[%ebx] := "camlCode"
                  temp/100[%ebx] := [temp/99[%ebx] + 44]
                  temp/101[%edx] := "camlPervasives"
                  temp/102[%esi] := [temp/101[%edx] + 36]
                  temp/103[%edx] := "camlCode"
                  temp/104[%edx] := [temp/103[%edx] + 4]
                  temp/105[%ecx] := b/65[%ecx] + 84
                  [temp/105[%ecx] + -4] := 2048
                  [temp/105[%ecx]] := temp/102[%esi]
                  [temp/105[%ecx] + 4] := temp/104[%edx]
                  temp/106[%edx] := "camlCode"
                  temp/107[%esi] := [temp/106[%edx] + 36]
                  scene/124[%edx] := spilled-scene/121[s1] (reload)
                  {spilled-g/120[s0]}
                  R/0[%eax] := call "camlCode__intersect_1067" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
                  temp/109[%ebx] := [temp/108[%eax]]
                  temp/110[%eax] := "camlPervasives"
                  temp/111[%eax] := [temp/110[%eax] + 36]
                  R/7[%tos] := float64u[temp/111[%eax]]
                  R/7[%tos] := float64u[temp/109[%ebx]]
                  if not R/7[%tos] <f R/7[%tos] goto L178
                  I/114[%eax] := 1
                  goto L177
                  L178 [0]:
                  I/115[%eax] := 0
                  L177 [0]:
                  temp/116[%eax] := I/114[%eax]  * 2 + 1
                  if temp/116[%eax] ==s 1 goto L176
                  A/118[%eax] := "camlCode__19"
                  reload retaddr
                  return R/0[%eax]
                  L176 [0]:
                  {spilled-g/120[s0]}
                  A/117[%eax] := alloc 12
                  [A/117[%eax] + -4] := 2301
                  float64u[A/117[%eax]] := g/125[s0]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__ray_trace_1086:
  dir/8[%edi] := R/0[%eax]
  spilled-dir/122[s0] := dir/8[%edi] (spill)
  scene/9[%edx] := R/1[%ebx]
  spilled-scene/121[s1] := scene/9[%edx] (spill)
  temp/10[%eax] := "camlCode"
  temp/11[%ebp] := [temp/10[%eax] + 4]
  temp/12[%eax] := "camlPervasives"
  temp/13[%ebx] := [temp/12[%eax] + 36]
  temp/14[%eax] := "camlCode"
  temp/15[%esi] := [temp/14[%eax] + 4]
  {dir/8[%edi]* scene/9[%edx]* temp/11[%ebp]* temp/13[%ebx]* temp/15[%esi]*
   spilled-scene/121[s1]* spilled-dir/122[s0]*}
  temp/16[%ecx] := alloc 12
  [temp/16[%ecx] + -4] := 2048
  [temp/16[%ecx]] := temp/13[%ebx]
  [temp/16[%ecx] + 4] := temp/15[%esi]
  temp/17[%eax] := "camlCode"
  temp/18[%esi] := [temp/17[%eax] + 36]
  R/0[%eax] := temp/11[%ebp]
  R/1[%ebx] := dir/8[%edi]
  {spilled-scene/121[s1]* spilled-dir/122[s0]*}
  R/0[%eax] := call "camlCode__intersect_1067" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
  match/19[%esi] := R/0[%eax]
  n/20[%ebx] := [match/19[%esi] + 4]
  temp/21[%eax] := "camlCode"
  b/22[%eax] := [temp/21[%eax] + 44]
  R/7[%tos] := float64u[n/20[%ebx]]
  temp/24[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/22[%eax]]
  temp/26[s0] := R/7[%tos]
  R/7[%tos] := temp/24[s1] *f temp/26[s0]
  temp/28[s2] := R/7[%tos]
  R/7[%tos] := float64u[n/20[%ebx] + 8]
  temp/30[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/22[%eax] + 8]
  temp/32[s0] := R/7[%tos]
  R/7[%tos] := temp/30[s1] *f temp/32[s0]
  temp/34[s0] := R/7[%tos]
  R/7[%tos] := temp/28[s2] +f temp/34[s0]
  temp/36[s2] := R/7[%tos]
  R/7[%tos] := float64u[n/20[%ebx] + 16]
  temp/38[s1] := R/7[%tos]
  R/7[%tos] := float64u[b/22[%eax] + 16]
  temp/40[s0] := R/7[%tos]
  R/7[%tos] := temp/38[s1] *f temp/40[s0]
  temp/42[s0] := R/7[%tos]
  R/7[%tos] := temp/36[s2] +f temp/42[s0]
  g/44[s0] := R/7[%tos]
  R/7[%tos] := 0.
  temp/46[s1] := R/7[%tos]
  if not g/44[s0] <=f temp/46[s1] goto L181
  I/47[%eax] := 1
  goto L180
  L181 [2]:
  I/48[%eax] := 0
  L180 [3]:
  temp/49[%eax] := I/47[%eax]  * 2 + 1
  if temp/49[%eax] ==s 1 goto L179
  A/119[%eax] := "camlCode__20"
  reload retaddr
  return R/0[%eax]
  L179 [2]:
  temp/50[%eax] := "camlPervasives"
  temp/51[%eax] := [temp/50[%eax] + 56]
  pushfloat [temp/51[%eax]]
  {match/19[%esi]* n/20[%ebx]* spilled-g/120[s0] spilled-scene/121[s1]*
   spilled-dir/122[s0]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  s/52[s4] := R/7[%tos]
  R/7[%tos] := float64u[n/20[%ebx]]
  temp/54[s1] := R/7[%tos]
  R/7[%tos] := s/52[s4] *f temp/54[s1]
  temp/56[s3] := R/7[%tos]
  R/7[%tos] := float64u[n/20[%ebx] + 8]
  temp/58[s1] := R/7[%tos]
  R/7[%tos] := s/52[s4] *f temp/58[s1]
  temp/60[s2] := R/7[%tos]
  R/7[%tos] := float64u[n/20[%ebx] + 16]
  temp/62[s1] := R/7[%tos]
  R/7[%tos] := s/52[s4] *f temp/62[s1]
  temp/64[s1] := R/7[%tos]
  {match/19[%esi]* temp/56[s3] temp/60[s2] temp/64[s1] spilled-g/120[s0]
   spilled-scene/121[s1]* spilled-dir/122[s0]*}
  b/65[%ecx] := alloc 96
  [b/65[%ecx] + -4] := 6398
  float64u[b/65[%ecx]] := temp/56[s3]
  float64u[b/65[%ecx] + 8] := temp/60[s2]
  float64u[b/65[%ecx] + 16] := temp/64[s1]
  s/66[%ebx] := [match/19[%esi]]
  dir/123[%eax] := spilled-dir/122[s0] (reload)
  R/7[%tos] := float64u[dir/123[%eax]]
  temp/68[s1] := R/7[%tos]
  R/7[%tos] := temp/68[s1] *f float64[s/66[%ebx]]
  temp/70[s3] := R/7[%tos]
  R/7[%tos] := float64u[dir/123[%eax] + 8]
  temp/72[s1] := R/7[%tos]
  R/7[%tos] := temp/72[s1] *f float64[s/66[%ebx]]
  temp/74[s2] := R/7[%tos]
  R/7[%tos] := float64u[dir/123[%eax] + 16]
  temp/76[s1] := R/7[%tos]
  R/7[%tos] := temp/76[s1] *f float64[s/66[%ebx]]
  temp/78[s1] := R/7[%tos]
  a/79[%eax] := b/65[%ecx] + 28
  [a/79[%eax] + -4] := 6398
  float64u[a/79[%eax]] := temp/70[s3]
  float64u[a/79[%eax] + 8] := temp/74[s2]
  float64u[a/79[%eax] + 16] := temp/78[s1]
  R/7[%tos] := float64u[a/79[%eax]]
  temp/81[s2] := R/7[%tos]
  R/7[%tos] := float64u[b/65[%ecx]]
  temp/83[s1] := R/7[%tos]
  R/7[%tos] := temp/81[s2] +f temp/83[s1]
  temp/85[s4] := R/7[%tos]
  R/7[%tos] := float64u[a/79[%eax] + 8]
  temp/87[s2] := R/7[%tos]
  R/7[%tos] := float64u[b/65[%ecx] + 8]
  temp/89[s1] := R/7[%tos]
  R/7[%tos] := temp/87[s2] +f temp/89[s1]
  temp/91[s3] := R/7[%tos]
  R/7[%tos] := float64u[a/79[%eax] + 16]
  temp/93[s2] := R/7[%tos]
  R/7[%tos] := float64u[b/65[%ecx] + 16]
  temp/95[s1] := R/7[%tos]
  R/7[%tos] := temp/93[s2] +f temp/95[s1]
  temp/97[s1] := R/7[%tos]
  p/98[%eax] := b/65[%ecx] + 56
  [p/98[%eax] + -4] := 6398
  float64u[p/98[%eax]] := temp/85[s4]
  float64u[p/98[%eax] + 8] := temp/91[s3]
  float64u[p/98[%eax] + 16] := temp/97[s1]
  temp/99[%ebx] := "camlCode"
  temp/100[%ebx] := [temp/99[%ebx] + 44]
  temp/101[%edx] := "camlPervasives"
  temp/102[%esi] := [temp/101[%edx] + 36]
  temp/103[%edx] := "camlCode"
  temp/104[%edx] := [temp/103[%edx] + 4]
  temp/105[%ecx] := b/65[%ecx] + 84
  [temp/105[%ecx] + -4] := 2048
  [temp/105[%ecx]] := temp/102[%esi]
  [temp/105[%ecx] + 4] := temp/104[%edx]
  temp/106[%edx] := "camlCode"
  temp/107[%esi] := [temp/106[%edx] + 36]
  scene/124[%edx] := spilled-scene/121[s1] (reload)
  {spilled-g/120[s0]}
  R/0[%eax] := call "camlCode__intersect_1067" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
  temp/109[%ebx] := [temp/108[%eax]]
  temp/110[%eax] := "camlPervasives"
  temp/111[%eax] := [temp/110[%eax] + 36]
  R/7[%tos] := float64u[temp/111[%eax]]
  R/7[%tos] := float64u[temp/109[%ebx]]
  if not R/7[%tos] <f R/7[%tos] goto L178
  I/114[%eax] := 1
  goto L177
  L178 [2]:
  I/115[%eax] := 0
  L177 [3]:
  temp/116[%eax] := I/114[%eax]  * 2 + 1
  if temp/116[%eax] ==s 1 goto L176
  A/118[%eax] := "camlCode__19"
  reload retaddr
  return R/0[%eax]
  L176 [2]:
  {spilled-g/120[s0]}
  A/117[%eax] := alloc 12
  [A/117[%eax] + -4] := 2301
  float64u[A/117[%eax]] := g/125[s0]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__create_1093:
                  level/8[%edi] := R/0[%eax]
                  r/10[%esi] := R/2[%ecx]
                  temp/12[%ebp] := 1
                  {level/8[%edi]* c/9[%ebx]* r/10[%esi]* env/11[%edx]*
                   temp/12[%ebp]*}
                  obj/13[%ecx] := alloc 16
                  [obj/13[%ecx] + -4] := 3072
                  [obj/13[%ecx]] := c/9[%ebx]
                  [obj/13[%ecx] + 4] := r/10[%esi]
                  [obj/13[%ecx] + 8] := temp/12[%ebp]
                  temp/14[%eax] := 3
                  I/15[%eax] := level/8[%edi] ==s temp/14[%eax]
                  temp/16[%eax] := I/15[%eax]  * 2 + 1
                  if temp/16[%eax] ==s 1 goto L194
                  R/0[%eax] := obj/13[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  L194 [0]:
                  spilled-obj/164[s6] := obj/13[%ecx] (spill)
                  spilled-env/168[s2] := env/11[%edx] (spill)
                  spilled-r/169[s1] := r/10[%esi] (spill)
                  spilled-c/162[s7] := c/9[%ebx] (spill)
                  spilled-level/171[s0] := level/8[%edi] (spill)
                  R/7[%tos] := 3.
                  temp/18[s0] := R/7[%tos]
                  R/7[%tos] := temp/18[s0] *f float64[r/10[%esi]]
                  temp/20[s1] := R/7[%tos]
                  R/7[%tos] := 12.
                  temp/22[s0] := R/7[%tos]
                  push temp/22[s0]
                  {level/8[%edi]* c/9[%ebx]* r/10[%esi]* temp/20[s1]
                   spilled-c/162[s7]* spilled-obj/164[s6]*
                   spilled-env/168[s2]* spilled-r/169[s1]*
                   spilled-level/171[s0]*}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  temp/23[s0] := R/7[%tos]
                  R/7[%tos] := temp/20[s1] /f temp/23[s0]
                  a/25[s0] := R/7[%tos]
                  R/7[%tos] := 3.
                  temp/27[s1] := R/7[%tos]
                  R/7[%tos] := temp/27[s1] *f float64[r/10[%esi]]
                  temp/29[s1] := R/7[%tos]
                  R/7[%tos] := -f a/25[s0]
                  z'/31[s3] := R/7[%tos]
                  R/7[%tos] := -f a/25[s0]
                  x'/33[s2] := R/7[%tos]
                  temp/34[%eax] := 3
                  I/35[%edi] := I/35[%edi] - temp/34[%eax]
                  temp/36[%edi] := temp/36[%edi] + 1
                  {c/9[%ebx]* r/10[%esi]* a/25[s0] z'/31[s3] x'/33[s2]
                   temp/36[%edi] spilled-c/162[s7]* spilled-temp/163[s1]
                   spilled-obj/164[s6]* spilled-env/168[s2]*
                   spilled-r/169[s1]* spilled-a/170[s0]
                   spilled-level/171[s0]*}
                  b/37[%eax] := alloc 68
                  [b/37[%eax] + -4] := 6398
                  float64u[b/37[%eax]] := x'/33[s2]
                  float64u[b/37[%eax] + 8] := a/25[s0]
                  float64u[b/37[%eax] + 16] := z'/31[s3]
                  R/7[%tos] := float64u[c/9[%ebx]]
                  temp/39[s3] := R/7[%tos]
                  R/7[%tos] := float64u[b/37[%eax]]
                  temp/41[s2] := R/7[%tos]
                  R/7[%tos] := temp/39[s3] +f temp/41[s2]
                  temp/43[s5] := R/7[%tos]
                  R/7[%tos] := float64u[c/9[%ebx] + 8]
                  temp/45[s3] := R/7[%tos]
                  R/7[%tos] := float64u[b/37[%eax] + 8]
                  temp/47[s2] := R/7[%tos]
                  R/7[%tos] := temp/45[s3] +f temp/47[s2]
                  temp/49[s4] := R/7[%tos]
                  R/7[%tos] := float64u[c/9[%ebx] + 16]
                  temp/51[s3] := R/7[%tos]
                  R/7[%tos] := float64u[b/37[%eax] + 16]
                  temp/53[s2] := R/7[%tos]
                  R/7[%tos] := temp/51[s3] +f temp/53[s2]
                  temp/55[s2] := R/7[%tos]
                  temp/56[%ebx] := b/37[%eax] + 28
                  [temp/56[%ebx] + -4] := 6398
                  float64u[temp/56[%ebx]] := temp/43[s5]
                  float64u[temp/56[%ebx] + 8] := temp/49[s4]
                  float64u[temp/56[%ebx] + 16] := temp/55[s2]
                  R/7[%tos] := 0.5
                  temp/58[s2] := R/7[%tos]
                  R/7[%tos] := temp/58[s2] *f float64[r/10[%esi]]
                  temp/60[s2] := R/7[%tos]
                  A/61[%ecx] := b/37[%eax] + 56
                  [A/61[%ecx] + -4] := 2301
                  float64u[A/61[%ecx]] := temp/60[s2]
                  R/0[%eax] := temp/36[%edi]
                  env/172[%edx] := spilled-env/168[s2] (reload)
                  {spilled-c/162[s7]* spilled-temp/163[s1]
                   spilled-obj/164[s6]* spilled-env/168[s2]*
                   spilled-r/169[s1]* spilled-a/170[s0]
                   spilled-level/171[s0]*}
                  R/0[%eax] := call "camlCode__create_1093" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  spilled-temp/165[s5] := temp/62[%eax] (spill)
                  R/7[%tos] := -f a/173[s0]
                  z'/64[s2] := R/7[%tos]
                  temp/65[%eax] := 3
                  level/174[%ebx] := spilled-level/171[s0] (reload)
                  I/66[%ebx] := I/66[%ebx] - temp/65[%eax]
                  temp/67[%edx] := I/66[%ebx]
                  temp/67[%edx] := temp/67[%edx] + 1
                  {z'/64[s2] temp/67[%edx] spilled-c/162[s7]*
                   spilled-temp/163[s1] spilled-obj/164[s6]*
                   spilled-temp/165[s5]* spilled-env/168[s2]*
                   spilled-r/169[s1]* spilled-a/170[s0]
                   spilled-level/171[s0]* a/173[s0]}
                  b/68[%ecx] := alloc 68
                  [b/68[%ecx] + -4] := 6398
                  float64u[b/68[%ecx]] := a/173[s0]
                  float64u[b/68[%ecx] + 8] := a/173[s0]
                  float64u[b/68[%ecx] + 16] := z'/64[s2]
                  c/175[%eax] := spilled-c/162[s7] (reload)
                  R/7[%tos] := float64u[c/175[%eax]]
                  temp/70[s3] := R/7[%tos]
                  R/7[%tos] := float64u[b/68[%ecx]]
                  temp/72[s2] := R/7[%tos]
                  R/7[%tos] := temp/70[s3] +f temp/72[s2]
                  temp/74[s5] := R/7[%tos]
                  R/7[%tos] := float64u[c/175[%eax] + 8]
                  temp/76[s3] := R/7[%tos]
                  R/7[%tos] := float64u[b/68[%ecx] + 8]
                  temp/78[s2] := R/7[%tos]
                  R/7[%tos] := temp/76[s3] +f temp/78[s2]
                  temp/80[s4] := R/7[%tos]
                  R/7[%tos] := float64u[c/175[%eax] + 16]
                  temp/82[s3] := R/7[%tos]
                  R/7[%tos] := float64u[b/68[%ecx] + 16]
                  temp/84[s2] := R/7[%tos]
                  R/7[%tos] := temp/82[s3] +f temp/84[s2]
                  temp/86[s2] := R/7[%tos]
                  temp/87[%ebx] := b/68[%ecx] + 28
                  [temp/87[%ebx] + -4] := 6398
                  float64u[temp/87[%ebx]] := temp/74[s5]
                  float64u[temp/87[%ebx] + 8] := temp/80[s4]
                  float64u[temp/87[%ebx] + 16] := temp/86[s2]
                  R/7[%tos] := 0.5
                  temp/89[s2] := R/7[%tos]
                  r/176[%eax] := spilled-r/169[s1] (reload)
                  R/7[%tos] := temp/89[s2] *f float64[r/176[%eax]]
                  temp/91[s2] := R/7[%tos]
                  A/92[%ecx] := b/68[%ecx] + 56
                  [A/92[%ecx] + -4] := 2301
                  float64u[A/92[%ecx]] := temp/91[s2]
                  R/0[%eax] := temp/67[%edx]
                  env/177[%edx] := spilled-env/168[s2] (reload)
                  {spilled-c/162[s7]* spilled-temp/163[s1]
                   spilled-obj/164[s6]* spilled-temp/165[s5]*
                   spilled-env/168[s2]* spilled-r/169[s1]* spilled-a/170[s0]
                   spilled-level/171[s0]*}
                  R/0[%eax] := call "camlCode__create_1093" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  spilled-temp/166[s4] := temp/93[%eax] (spill)
                  R/7[%tos] := -f a/178[s0]
                  x'/95[s2] := R/7[%tos]
                  temp/96[%eax] := 3
                  level/179[%ebx] := spilled-level/171[s0] (reload)
                  I/97[%ebx] := I/97[%ebx] - temp/96[%eax]
                  temp/98[%edx] := I/97[%ebx]
                  temp/98[%edx] := temp/98[%edx] + 1
                  {x'/95[s2] temp/98[%edx] spilled-c/162[s7]*
                   spilled-temp/163[s1] spilled-obj/164[s6]*
                   spilled-temp/165[s5]* spilled-temp/166[s4]*
                   spilled-env/168[s2]* spilled-r/169[s1]* spilled-a/170[s0]
                   spilled-level/171[s0]* a/178[s0]}
                  b/99[%ecx] := alloc 68
                  [b/99[%ecx] + -4] := 6398
                  float64u[b/99[%ecx]] := x'/95[s2]
                  float64u[b/99[%ecx] + 8] := a/178[s0]
                  float64u[b/99[%ecx] + 16] := a/178[s0]
                  c/180[%eax] := spilled-c/162[s7] (reload)
                  R/7[%tos] := float64u[c/180[%eax]]
                  temp/101[s3] := R/7[%tos]
                  R/7[%tos] := float64u[b/99[%ecx]]
                  temp/103[s2] := R/7[%tos]
                  R/7[%tos] := temp/101[s3] +f temp/103[s2]
                  temp/105[s5] := R/7[%tos]
                  R/7[%tos] := float64u[c/180[%eax] + 8]
                  temp/107[s3] := R/7[%tos]
                  R/7[%tos] := float64u[b/99[%ecx] + 8]
                  temp/109[s2] := R/7[%tos]
                  R/7[%tos] := temp/107[s3] +f temp/109[s2]
                  temp/111[s4] := R/7[%tos]
                  R/7[%tos] := float64u[c/180[%eax] + 16]
                  temp/113[s3] := R/7[%tos]
                  R/7[%tos] := float64u[b/99[%ecx] + 16]
                  temp/115[s2] := R/7[%tos]
                  R/7[%tos] := temp/113[s3] +f temp/115[s2]
                  temp/117[s2] := R/7[%tos]
                  temp/118[%ebx] := b/99[%ecx] + 28
                  [temp/118[%ebx] + -4] := 6398
                  float64u[temp/118[%ebx]] := temp/105[s5]
                  float64u[temp/118[%ebx] + 8] := temp/111[s4]
                  float64u[temp/118[%ebx] + 16] := temp/117[s2]
                  R/7[%tos] := 0.5
                  temp/120[s2] := R/7[%tos]
                  r/181[%eax] := spilled-r/169[s1] (reload)
                  R/7[%tos] := temp/120[s2] *f float64[r/181[%eax]]
                  temp/122[s2] := R/7[%tos]
                  A/123[%ecx] := b/99[%ecx] + 56
                  [A/123[%ecx] + -4] := 2301
                  float64u[A/123[%ecx]] := temp/122[s2]
                  R/0[%eax] := temp/98[%edx]
                  env/182[%edx] := spilled-env/168[s2] (reload)
                  {spilled-c/162[s7]* spilled-temp/163[s1]
                   spilled-obj/164[s6]* spilled-temp/165[s5]*
                   spilled-temp/166[s4]* spilled-env/168[s2]*
                   spilled-r/169[s1]* spilled-a/170[s0]
                   spilled-level/171[s0]*}
                  R/0[%eax] := call "camlCode__create_1093" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  spilled-temp/167[s3] := temp/124[%eax] (spill)
                  temp/125[%eax] := 3
                  level/183[%ebx] := spilled-level/171[s0] (reload)
                  I/126[%ebx] := I/126[%ebx] - temp/125[%eax]
                  temp/127[%edx] := I/126[%ebx]
                  temp/127[%edx] := temp/127[%edx] + 1
                  {temp/127[%edx] spilled-c/162[s7]* spilled-temp/163[s1]
                   spilled-obj/164[s6]* spilled-temp/165[s5]*
                   spilled-temp/166[s4]* spilled-temp/167[s3]*
                   spilled-env/168[s2]* spilled-r/169[s1]* spilled-a/170[s0]}
                  b/128[%ecx] := alloc 68
                  [b/128[%ecx] + -4] := 6398
                  float64u[b/128[%ecx]] := a/184[s0]
                  float64u[b/128[%ecx] + 8] := a/184[s0]
                  float64u[b/128[%ecx] + 16] := a/184[s0]
                  c/185[%eax] := spilled-c/162[s7] (reload)
                  R/7[%tos] := float64u[c/185[%eax]]
                  temp/130[s2] := R/7[%tos]
                  R/7[%tos] := float64u[b/128[%ecx]]
                  temp/132[s0] := R/7[%tos]
                  R/7[%tos] := temp/130[s2] +f temp/132[s0]
                  temp/134[s4] := R/7[%tos]
                  R/7[%tos] := float64u[c/185[%eax] + 8]
                  temp/136[s2] := R/7[%tos]
                  R/7[%tos] := float64u[b/128[%ecx] + 8]
                  temp/138[s0] := R/7[%tos]
                  R/7[%tos] := temp/136[s2] +f temp/138[s0]
                  temp/140[s3] := R/7[%tos]
                  R/7[%tos] := float64u[c/185[%eax] + 16]
                  temp/142[s2] := R/7[%tos]
                  R/7[%tos] := float64u[b/128[%ecx] + 16]
                  temp/144[s0] := R/7[%tos]
                  R/7[%tos] := temp/142[s2] +f temp/144[s0]
                  temp/146[s0] := R/7[%tos]
                  temp/147[%ebx] := b/128[%ecx] + 28
                  [temp/147[%ebx] + -4] := 6398
                  float64u[temp/147[%ebx]] := temp/134[s4]
                  float64u[temp/147[%ebx] + 8] := temp/140[s3]
                  float64u[temp/147[%ebx] + 16] := temp/146[s0]
                  R/7[%tos] := 0.5
                  temp/149[s0] := R/7[%tos]
                  r/186[%eax] := spilled-r/169[s1] (reload)
                  R/7[%tos] := temp/149[s0] *f float64[r/186[%eax]]
                  temp/151[s0] := R/7[%tos]
                  A/152[%ecx] := b/128[%ecx] + 56
                  [A/152[%ecx] + -4] := 2301
                  float64u[A/152[%ecx]] := temp/151[s0]
                  R/0[%eax] := temp/127[%edx]
                  env/187[%edx] := spilled-env/168[s2] (reload)
                  {spilled-c/162[s7]* spilled-temp/163[s1]
                   spilled-obj/164[s6]* spilled-temp/165[s5]*
                   spilled-temp/166[s4]* spilled-temp/167[s3]*}
                  R/0[%eax] := call "camlCode__create_1093" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  temp/153[%ecx] := R/0[%eax]
                  temp/154[%ebx] := 1
                  {temp/153[%ecx]* temp/154[%ebx]* spilled-c/162[s7]*
                   spilled-temp/163[s1] spilled-obj/164[s6]*
                   spilled-temp/165[s5]* spilled-temp/166[s4]*
                   spilled-temp/167[s3]*}
                  temp/155[%eax] := alloc 88
                  [temp/155[%eax] + -4] := 2048
                  [temp/155[%eax]] := temp/153[%ecx]
                  [temp/155[%eax] + 4] := temp/154[%ebx]
                  temp/156[%ecx] := temp/155[%eax] + 12
                  [temp/156[%ecx] + -4] := 2048
                  temp/188[%ebx] := spilled-temp/167[s3] (reload)
                  [temp/156[%ecx]] := temp/188[%ebx]
                  [temp/156[%ecx] + 4] := temp/155[%eax]
                  temp/157[%edx] := temp/155[%eax] + 24
                  [temp/157[%edx] + -4] := 2048
                  temp/189[%ebx] := spilled-temp/166[s4] (reload)
                  [temp/157[%edx]] := temp/189[%ebx]
                  [temp/157[%edx] + 4] := temp/156[%ecx]
                  temp/158[%ecx] := temp/155[%eax] + 36
                  [temp/158[%ecx] + -4] := 2048
                  temp/190[%ebx] := spilled-temp/165[s5] (reload)
                  [temp/158[%ecx]] := temp/190[%ebx]
                  [temp/158[%ecx] + 4] := temp/157[%edx]
                  temp/159[%edx] := temp/155[%eax] + 48
                  [temp/159[%edx] + -4] := 2048
                  obj/191[%ebx] := spilled-obj/164[s6] (reload)
                  [temp/159[%edx]] := obj/191[%ebx]
                  [temp/159[%edx] + 4] := temp/158[%ecx]
                  A/160[%ecx] := temp/155[%eax] + 60
                  [A/160[%ecx] + -4] := 2301
                  float64u[A/160[%ecx]] := temp/192[s1]
                  A/161[%eax] := temp/155[%eax] + 72
                  [A/161[%eax] + -4] := 3072
                  c/193[%ebx] := spilled-c/162[s7] (reload)
                  [A/161[%eax]] := c/193[%ebx]
                  [A/161[%eax] + 4] := A/160[%ecx]
                  [A/161[%eax] + 8] := temp/159[%edx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__create_1093:
  level/8[%edi] := R/0[%eax]
  r/10[%esi] := R/2[%ecx]
  temp/12[%ebp] := 1
  {level/8[%edi]* c/9[%ebx]* r/10[%esi]* env/11[%edx]* temp/12[%ebp]*}
  obj/13[%ecx] := alloc 16
  [obj/13[%ecx] + -4] := 3072
  [obj/13[%ecx]] := c/9[%ebx]
  [obj/13[%ecx] + 4] := r/10[%esi]
  [obj/13[%ecx] + 8] := temp/12[%ebp]
  temp/14[%eax] := 3
  I/15[%eax] := level/8[%edi] ==s temp/14[%eax]
  temp/16[%eax] := I/15[%eax]  * 2 + 1
  if temp/16[%eax] ==s 1 goto L194
  R/0[%eax] := obj/13[%ecx]
  reload retaddr
  return R/0[%eax]
  L194 [2]:
  spilled-obj/164[s6] := obj/13[%ecx] (spill)
  spilled-env/168[s2] := env/11[%edx] (spill)
  spilled-r/169[s1] := r/10[%esi] (spill)
  spilled-c/162[s7] := c/9[%ebx] (spill)
  spilled-level/171[s0] := level/8[%edi] (spill)
  R/7[%tos] := 3.
  temp/18[s0] := R/7[%tos]
  R/7[%tos] := temp/18[s0] *f float64[r/10[%esi]]
  temp/20[s1] := R/7[%tos]
  R/7[%tos] := 12.
  temp/22[s0] := R/7[%tos]
  push temp/22[s0]
  {level/8[%edi]* c/9[%ebx]* r/10[%esi]* temp/20[s1] spilled-c/162[s7]*
   spilled-obj/164[s6]* spilled-env/168[s2]* spilled-r/169[s1]*
   spilled-level/171[s0]*}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  temp/23[s0] := R/7[%tos]
  R/7[%tos] := temp/20[s1] /f temp/23[s0]
  a/25[s0] := R/7[%tos]
  R/7[%tos] := 3.
  temp/27[s1] := R/7[%tos]
  R/7[%tos] := temp/27[s1] *f float64[r/10[%esi]]
  temp/29[s1] := R/7[%tos]
  R/7[%tos] := -f a/25[s0]
  z'/31[s3] := R/7[%tos]
  R/7[%tos] := -f a/25[s0]
  x'/33[s2] := R/7[%tos]
  temp/34[%eax] := 3
  I/35[%edi] := I/35[%edi] - temp/34[%eax]
  temp/36[%edi] := temp/36[%edi] + 1
  {c/9[%ebx]* r/10[%esi]* a/25[s0] z'/31[s3] x'/33[s2] temp/36[%edi]
   spilled-c/162[s7]* spilled-temp/163[s1] spilled-obj/164[s6]*
   spilled-env/168[s2]* spilled-r/169[s1]* spilled-a/170[s0]
   spilled-level/171[s0]*}
  b/37[%eax] := alloc 68
  [b/37[%eax] + -4] := 6398
  float64u[b/37[%eax]] := x'/33[s2]
  float64u[b/37[%eax] + 8] := a/25[s0]
  float64u[b/37[%eax] + 16] := z'/31[s3]
  R/7[%tos] := float64u[c/9[%ebx]]
  temp/39[s3] := R/7[%tos]
  R/7[%tos] := float64u[b/37[%eax]]
  temp/41[s2] := R/7[%tos]
  R/7[%tos] := temp/39[s3] +f temp/41[s2]
  temp/43[s5] := R/7[%tos]
  R/7[%tos] := float64u[c/9[%ebx] + 8]
  temp/45[s3] := R/7[%tos]
  R/7[%tos] := float64u[b/37[%eax] + 8]
  temp/47[s2] := R/7[%tos]
  R/7[%tos] := temp/45[s3] +f temp/47[s2]
  temp/49[s4] := R/7[%tos]
  R/7[%tos] := float64u[c/9[%ebx] + 16]
  temp/51[s3] := R/7[%tos]
  R/7[%tos] := float64u[b/37[%eax] + 16]
  temp/53[s2] := R/7[%tos]
  R/7[%tos] := temp/51[s3] +f temp/53[s2]
  temp/55[s2] := R/7[%tos]
  temp/56[%ebx] := b/37[%eax] + 28
  [temp/56[%ebx] + -4] := 6398
  float64u[temp/56[%ebx]] := temp/43[s5]
  float64u[temp/56[%ebx] + 8] := temp/49[s4]
  float64u[temp/56[%ebx] + 16] := temp/55[s2]
  R/7[%tos] := 0.5
  temp/58[s2] := R/7[%tos]
  R/7[%tos] := temp/58[s2] *f float64[r/10[%esi]]
  temp/60[s2] := R/7[%tos]
  A/61[%ecx] := b/37[%eax] + 56
  [A/61[%ecx] + -4] := 2301
  float64u[A/61[%ecx]] := temp/60[s2]
  R/0[%eax] := temp/36[%edi]
  env/172[%edx] := spilled-env/168[s2] (reload)
  {spilled-c/162[s7]* spilled-temp/163[s1] spilled-obj/164[s6]*
   spilled-env/168[s2]* spilled-r/169[s1]* spilled-a/170[s0]
   spilled-level/171[s0]*}
  R/0[%eax] := call "camlCode__create_1093" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  spilled-temp/165[s5] := temp/62[%eax] (spill)
  R/7[%tos] := -f a/173[s0]
  z'/64[s2] := R/7[%tos]
  temp/65[%eax] := 3
  level/174[%ebx] := spilled-level/171[s0] (reload)
  I/66[%ebx] := I/66[%ebx] - temp/65[%eax]
  temp/67[%edx] := I/66[%ebx]
  temp/67[%edx] := temp/67[%edx] + 1
  {z'/64[s2] temp/67[%edx] spilled-c/162[s7]* spilled-temp/163[s1]
   spilled-obj/164[s6]* spilled-temp/165[s5]* spilled-env/168[s2]*
   spilled-r/169[s1]* spilled-a/170[s0] spilled-level/171[s0]* a/173[s0]}
  b/68[%ecx] := alloc 68
  [b/68[%ecx] + -4] := 6398
  float64u[b/68[%ecx]] := a/173[s0]
  float64u[b/68[%ecx] + 8] := a/173[s0]
  float64u[b/68[%ecx] + 16] := z'/64[s2]
  c/175[%eax] := spilled-c/162[s7] (reload)
  R/7[%tos] := float64u[c/175[%eax]]
  temp/70[s3] := R/7[%tos]
  R/7[%tos] := float64u[b/68[%ecx]]
  temp/72[s2] := R/7[%tos]
  R/7[%tos] := temp/70[s3] +f temp/72[s2]
  temp/74[s5] := R/7[%tos]
  R/7[%tos] := float64u[c/175[%eax] + 8]
  temp/76[s3] := R/7[%tos]
  R/7[%tos] := float64u[b/68[%ecx] + 8]
  temp/78[s2] := R/7[%tos]
  R/7[%tos] := temp/76[s3] +f temp/78[s2]
  temp/80[s4] := R/7[%tos]
  R/7[%tos] := float64u[c/175[%eax] + 16]
  temp/82[s3] := R/7[%tos]
  R/7[%tos] := float64u[b/68[%ecx] + 16]
  temp/84[s2] := R/7[%tos]
  R/7[%tos] := temp/82[s3] +f temp/84[s2]
  temp/86[s2] := R/7[%tos]
  temp/87[%ebx] := b/68[%ecx] + 28
  [temp/87[%ebx] + -4] := 6398
  float64u[temp/87[%ebx]] := temp/74[s5]
  float64u[temp/87[%ebx] + 8] := temp/80[s4]
  float64u[temp/87[%ebx] + 16] := temp/86[s2]
  R/7[%tos] := 0.5
  temp/89[s2] := R/7[%tos]
  r/176[%eax] := spilled-r/169[s1] (reload)
  R/7[%tos] := temp/89[s2] *f float64[r/176[%eax]]
  temp/91[s2] := R/7[%tos]
  A/92[%ecx] := b/68[%ecx] + 56
  [A/92[%ecx] + -4] := 2301
  float64u[A/92[%ecx]] := temp/91[s2]
  R/0[%eax] := temp/67[%edx]
  env/177[%edx] := spilled-env/168[s2] (reload)
  {spilled-c/162[s7]* spilled-temp/163[s1] spilled-obj/164[s6]*
   spilled-temp/165[s5]* spilled-env/168[s2]* spilled-r/169[s1]*
   spilled-a/170[s0] spilled-level/171[s0]*}
  R/0[%eax] := call "camlCode__create_1093" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  spilled-temp/166[s4] := temp/93[%eax] (spill)
  R/7[%tos] := -f a/178[s0]
  x'/95[s2] := R/7[%tos]
  temp/96[%eax] := 3
  level/179[%ebx] := spilled-level/171[s0] (reload)
  I/97[%ebx] := I/97[%ebx] - temp/96[%eax]
  temp/98[%edx] := I/97[%ebx]
  temp/98[%edx] := temp/98[%edx] + 1
  {x'/95[s2] temp/98[%edx] spilled-c/162[s7]* spilled-temp/163[s1]
   spilled-obj/164[s6]* spilled-temp/165[s5]* spilled-temp/166[s4]*
   spilled-env/168[s2]* spilled-r/169[s1]* spilled-a/170[s0]
   spilled-level/171[s0]* a/178[s0]}
  b/99[%ecx] := alloc 68
  [b/99[%ecx] + -4] := 6398
  float64u[b/99[%ecx]] := x'/95[s2]
  float64u[b/99[%ecx] + 8] := a/178[s0]
  float64u[b/99[%ecx] + 16] := a/178[s0]
  c/180[%eax] := spilled-c/162[s7] (reload)
  R/7[%tos] := float64u[c/180[%eax]]
  temp/101[s3] := R/7[%tos]
  R/7[%tos] := float64u[b/99[%ecx]]
  temp/103[s2] := R/7[%tos]
  R/7[%tos] := temp/101[s3] +f temp/103[s2]
  temp/105[s5] := R/7[%tos]
  R/7[%tos] := float64u[c/180[%eax] + 8]
  temp/107[s3] := R/7[%tos]
  R/7[%tos] := float64u[b/99[%ecx] + 8]
  temp/109[s2] := R/7[%tos]
  R/7[%tos] := temp/107[s3] +f temp/109[s2]
  temp/111[s4] := R/7[%tos]
  R/7[%tos] := float64u[c/180[%eax] + 16]
  temp/113[s3] := R/7[%tos]
  R/7[%tos] := float64u[b/99[%ecx] + 16]
  temp/115[s2] := R/7[%tos]
  R/7[%tos] := temp/113[s3] +f temp/115[s2]
  temp/117[s2] := R/7[%tos]
  temp/118[%ebx] := b/99[%ecx] + 28
  [temp/118[%ebx] + -4] := 6398
  float64u[temp/118[%ebx]] := temp/105[s5]
  float64u[temp/118[%ebx] + 8] := temp/111[s4]
  float64u[temp/118[%ebx] + 16] := temp/117[s2]
  R/7[%tos] := 0.5
  temp/120[s2] := R/7[%tos]
  r/181[%eax] := spilled-r/169[s1] (reload)
  R/7[%tos] := temp/120[s2] *f float64[r/181[%eax]]
  temp/122[s2] := R/7[%tos]
  A/123[%ecx] := b/99[%ecx] + 56
  [A/123[%ecx] + -4] := 2301
  float64u[A/123[%ecx]] := temp/122[s2]
  R/0[%eax] := temp/98[%edx]
  env/182[%edx] := spilled-env/168[s2] (reload)
  {spilled-c/162[s7]* spilled-temp/163[s1] spilled-obj/164[s6]*
   spilled-temp/165[s5]* spilled-temp/166[s4]* spilled-env/168[s2]*
   spilled-r/169[s1]* spilled-a/170[s0] spilled-level/171[s0]*}
  R/0[%eax] := call "camlCode__create_1093" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  spilled-temp/167[s3] := temp/124[%eax] (spill)
  temp/125[%eax] := 3
  level/183[%ebx] := spilled-level/171[s0] (reload)
  I/126[%ebx] := I/126[%ebx] - temp/125[%eax]
  temp/127[%edx] := I/126[%ebx]
  temp/127[%edx] := temp/127[%edx] + 1
  {temp/127[%edx] spilled-c/162[s7]* spilled-temp/163[s1]
   spilled-obj/164[s6]* spilled-temp/165[s5]* spilled-temp/166[s4]*
   spilled-temp/167[s3]* spilled-env/168[s2]* spilled-r/169[s1]*
   spilled-a/170[s0]}
  b/128[%ecx] := alloc 68
  [b/128[%ecx] + -4] := 6398
  float64u[b/128[%ecx]] := a/184[s0]
  float64u[b/128[%ecx] + 8] := a/184[s0]
  float64u[b/128[%ecx] + 16] := a/184[s0]
  c/185[%eax] := spilled-c/162[s7] (reload)
  R/7[%tos] := float64u[c/185[%eax]]
  temp/130[s2] := R/7[%tos]
  R/7[%tos] := float64u[b/128[%ecx]]
  temp/132[s0] := R/7[%tos]
  R/7[%tos] := temp/130[s2] +f temp/132[s0]
  temp/134[s4] := R/7[%tos]
  R/7[%tos] := float64u[c/185[%eax] + 8]
  temp/136[s2] := R/7[%tos]
  R/7[%tos] := float64u[b/128[%ecx] + 8]
  temp/138[s0] := R/7[%tos]
  R/7[%tos] := temp/136[s2] +f temp/138[s0]
  temp/140[s3] := R/7[%tos]
  R/7[%tos] := float64u[c/185[%eax] + 16]
  temp/142[s2] := R/7[%tos]
  R/7[%tos] := float64u[b/128[%ecx] + 16]
  temp/144[s0] := R/7[%tos]
  R/7[%tos] := temp/142[s2] +f temp/144[s0]
  temp/146[s0] := R/7[%tos]
  temp/147[%ebx] := b/128[%ecx] + 28
  [temp/147[%ebx] + -4] := 6398
  float64u[temp/147[%ebx]] := temp/134[s4]
  float64u[temp/147[%ebx] + 8] := temp/140[s3]
  float64u[temp/147[%ebx] + 16] := temp/146[s0]
  R/7[%tos] := 0.5
  temp/149[s0] := R/7[%tos]
  r/186[%eax] := spilled-r/169[s1] (reload)
  R/7[%tos] := temp/149[s0] *f float64[r/186[%eax]]
  temp/151[s0] := R/7[%tos]
  A/152[%ecx] := b/128[%ecx] + 56
  [A/152[%ecx] + -4] := 2301
  float64u[A/152[%ecx]] := temp/151[s0]
  R/0[%eax] := temp/127[%edx]
  env/187[%edx] := spilled-env/168[s2] (reload)
  {spilled-c/162[s7]* spilled-temp/163[s1] spilled-obj/164[s6]*
   spilled-temp/165[s5]* spilled-temp/166[s4]* spilled-temp/167[s3]*}
  R/0[%eax] := call "camlCode__create_1093" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  temp/153[%ecx] := R/0[%eax]
  temp/154[%ebx] := 1
  {temp/153[%ecx]* temp/154[%ebx]* spilled-c/162[s7]* spilled-temp/163[s1]
   spilled-obj/164[s6]* spilled-temp/165[s5]* spilled-temp/166[s4]*
   spilled-temp/167[s3]*}
  temp/155[%eax] := alloc 88
  [temp/155[%eax] + -4] := 2048
  [temp/155[%eax]] := temp/153[%ecx]
  [temp/155[%eax] + 4] := temp/154[%ebx]
  temp/156[%ecx] := temp/155[%eax] + 12
  [temp/156[%ecx] + -4] := 2048
  temp/188[%ebx] := spilled-temp/167[s3] (reload)
  [temp/156[%ecx]] := temp/188[%ebx]
  [temp/156[%ecx] + 4] := temp/155[%eax]
  temp/157[%edx] := temp/155[%eax] + 24
  [temp/157[%edx] + -4] := 2048
  temp/189[%ebx] := spilled-temp/166[s4] (reload)
  [temp/157[%edx]] := temp/189[%ebx]
  [temp/157[%edx] + 4] := temp/156[%ecx]
  temp/158[%ecx] := temp/155[%eax] + 36
  [temp/158[%ecx] + -4] := 2048
  temp/190[%ebx] := spilled-temp/165[s5] (reload)
  [temp/158[%ecx]] := temp/190[%ebx]
  [temp/158[%ecx] + 4] := temp/157[%edx]
  temp/159[%edx] := temp/155[%eax] + 48
  [temp/159[%edx] + -4] := 2048
  obj/191[%ebx] := spilled-obj/164[s6] (reload)
  [temp/159[%edx]] := obj/191[%ebx]
  [temp/159[%edx] + 4] := temp/158[%ecx]
  A/160[%ecx] := temp/155[%eax] + 60
  [A/160[%ecx] + -4] := 2301
  float64u[A/160[%ecx]] := temp/192[s1]
  A/161[%eax] := temp/155[%eax] + 72
  [A/161[%eax] + -4] := 3072
  c/193[%ebx] := spilled-c/162[s7] (reload)
  [A/161[%eax]] := c/193[%ebx]
  [A/161[%eax] + 4] := A/160[%ecx]
  [A/161[%eax] + 8] := temp/159[%edx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  temp/8[%eax] := "camlPervasives"
                  temp/9[%eax] := [temp/8[%eax] + 56]
                  pushfloat [temp/9[%eax]]
                  {}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  delta/10[s0] := R/7[%tos]
                  temp/11[%ebx] := "camlCode"
                  {delta/10[s0] temp/11[%ebx]*}
                  A/12[%eax] := alloc 12
                  [A/12[%eax] + -4] := 2301
                  float64u[A/12[%eax]] := delta/10[s0]
                  [temp/11[%ebx]] := A/12[%eax]
                  zero/13[%ebx] := "camlCode__1"
                  temp/14[%eax] := "camlCode"
                  [temp/14[%eax] + 4] := zero/13[%ebx]
                  *|/15[%ebx] := "camlCode__18"
                  temp/16[%eax] := "camlCode"
                  [temp/16[%eax] + 8] := *|/15[%ebx]
                  +|/17[%ebx] := "camlCode__17"
                  temp/18[%eax] := "camlCode"
                  [temp/18[%eax] + 12] := +|/17[%ebx]
                  -|/19[%ebx] := "camlCode__16"
                  temp/20[%eax] := "camlCode"
                  [temp/20[%eax] + 16] := -|/19[%ebx]
                  dot/21[%ebx] := "camlCode__15"
                  temp/22[%eax] := "camlCode"
                  [temp/22[%eax] + 20] := dot/21[%ebx]
                  length/23[%ebx] := "camlCode__14"
                  temp/24[%eax] := "camlCode"
                  [temp/24[%eax] + 24] := length/23[%ebx]
                  unitise/25[%ebx] := "camlCode__13"
                  temp/26[%eax] := "camlCode"
                  [temp/26[%eax] + 28] := unitise/25[%ebx]
                  ray_sphere/27[%ebx] := "camlCode__12"
                  temp/28[%eax] := "camlCode"
                  [temp/28[%eax] + 32] := ray_sphere/27[%ebx]
                  clos/29[%eax] := "camlCode__11"
                  temp/30[%ebx] := "camlCode"
                  [temp/30[%ebx] + 36] := clos/29[%eax]
                  temp/31[%ebx] := "camlCode"
                  temp/32[%eax] := temp/32[%eax] + 16
                  [temp/31[%ebx] + 40] := temp/32[%eax]
                  R/7[%tos] := 1.
                  temp/34[s3] := R/7[%tos]
                  temp/35[%eax] := "camlCode__2"
                  R/7[%tos] := float64u[temp/35[%eax]]
                  temp/37[s1] := R/7[%tos]
                  temp/38[%eax] := "camlCode__2"
                  R/7[%tos] := float64u[temp/38[%eax]]
                  temp/40[s0] := R/7[%tos]
                  R/7[%tos] := temp/37[s1] *f temp/40[s0]
                  temp/42[s2] := R/7[%tos]
                  temp/43[%eax] := "camlCode__2"
                  R/7[%tos] := float64u[temp/43[%eax] + 8]
                  temp/45[s1] := R/7[%tos]
                  temp/46[%eax] := "camlCode__2"
                  R/7[%tos] := float64u[temp/46[%eax] + 8]
                  temp/48[s0] := R/7[%tos]
                  R/7[%tos] := temp/45[s1] *f temp/48[s0]
                  temp/50[s0] := R/7[%tos]
                  R/7[%tos] := temp/42[s2] +f temp/50[s0]
                  temp/52[s2] := R/7[%tos]
                  temp/53[%eax] := "camlCode__2"
                  R/7[%tos] := float64u[temp/53[%eax] + 16]
                  temp/55[s1] := R/7[%tos]
                  temp/56[%eax] := "camlCode__2"
                  R/7[%tos] := float64u[temp/56[%eax] + 16]
                  temp/58[s0] := R/7[%tos]
                  R/7[%tos] := temp/55[s1] *f temp/58[s0]
                  temp/60[s0] := R/7[%tos]
                  R/7[%tos] := temp/52[s2] +f temp/60[s0]
                  temp/62[s0] := R/7[%tos]
                  push temp/62[s0]
                  {temp/34[s3]}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  temp/63[s0] := R/7[%tos]
                  R/7[%tos] := temp/34[s3] /f temp/63[s0]
                  s/65[s3] := R/7[%tos]
                  temp/66[%eax] := "camlCode__2"
                  R/7[%tos] := float64u[temp/66[%eax]]
                  temp/68[s0] := R/7[%tos]
                  R/7[%tos] := s/65[s3] *f temp/68[s0]
                  temp/70[s2] := R/7[%tos]
                  temp/71[%eax] := "camlCode__2"
                  R/7[%tos] := float64u[temp/71[%eax] + 8]
                  temp/73[s0] := R/7[%tos]
                  R/7[%tos] := s/65[s3] *f temp/73[s0]
                  temp/75[s1] := R/7[%tos]
                  temp/76[%eax] := "camlCode__2"
                  R/7[%tos] := float64u[temp/76[%eax] + 16]
                  temp/78[s0] := R/7[%tos]
                  R/7[%tos] := s/65[s3] *f temp/78[s0]
                  temp/80[s0] := R/7[%tos]
                  {temp/70[s2] temp/75[s1] temp/80[s0]}
                  light/81[%ebx] := alloc 28
                  [light/81[%ebx] + -4] := 6398
                  float64u[light/81[%ebx]] := temp/70[s2]
                  float64u[light/81[%ebx] + 8] := temp/75[s1]
                  float64u[light/81[%ebx] + 16] := temp/80[s0]
                  temp/82[%eax] := "camlCode"
                  [temp/82[%eax] + 44] := light/81[%ebx]
                  temp/83[%ebx] := "camlCode"
                  temp/84[%eax] := 9
                  [temp/83[%ebx] + 48] := temp/84[%eax]
                  ray_trace/85[%ebx] := "camlCode__10"
                  temp/86[%eax] := "camlCode"
                  [temp/86[%eax] + 52] := ray_trace/85[%ebx]
                  clos/87[%ebx] := "camlCode__9"
                  temp/88[%eax] := "camlCode"
                  [temp/88[%eax] + 56] := clos/87[%ebx]
                  setup trap L244
                  A/105[%ecx] := "camlCode__3"
                  goto L243
                  L244 [0]:
                  push trap
                  temp/89[%eax] := "camlSys"
                  temp/90[%ecx] := [temp/89[%eax]]
                  temp/91[%ebx] := 3
                  A/92[%eax] := [temp/90[%ecx] + -4]
                  I/93[%eax] := I/93[%eax] >>u 9
                  I/93[%eax] check > temp/91[%ebx]
                  temp/94[%eax] := [temp/90[%ecx] + temp/91[%ebx] * 2 + -2]
                  push temp/94[%eax]
                  {}
                  R/0[%eax] := extcall "caml_int_of_string"  (noalloc)
                  offset stack -4
                  spilled-temp/409[s0] := temp/95[%eax] (spill)
                  temp/96[%eax] := "camlSys"
                  temp/97[%ecx] := [temp/96[%eax]]
                  temp/98[%ebx] := 5
                  A/99[%eax] := [temp/97[%ecx] + -4]
                  I/100[%eax] := I/100[%eax] >>u 9
                  I/100[%eax] check > temp/98[%ebx]
                  temp/101[%eax] := [temp/97[%ecx] + temp/98[%ebx] * 2 + -2]
                  push temp/101[%eax]
                  {spilled-temp/409[s0]*}
                  R/0[%eax] := extcall "caml_int_of_string"  (noalloc)
                  offset stack -4
                  temp/102[%ebx] := R/0[%eax]
                  {temp/102[%ebx]* spilled-temp/409[s0]*}
                  match/103[%ecx] := alloc 12
                  [match/103[%ecx] + -4] := 2048
                  temp/433[%eax] := spilled-temp/409[s0] (reload)
                  [match/103[%ecx]] := temp/433[%eax]
                  [match/103[%ecx] + 4] := temp/102[%ebx]
                  pop trap
                  L243 [0]:
                  temp/106[%ebx] := "camlCode"
                  temp/107[%eax] := [match/103[%ecx]]
                  [temp/106[%ebx] + 60] := temp/107[%eax]
                  temp/108[%ebx] := "camlCode"
                  temp/109[%eax] := [match/103[%ecx] + 4]
                  [temp/108[%ebx] + 64] := temp/109[%eax]
                  temp/110[%eax] := "camlCode"
                  temp/111[%esi] := [temp/110[%eax] + 60]
                  temp/112[%ebx] := "camlCode__4"
                  R/7[%tos] := 1.
                  temp/114[s0] := R/7[%tos]
                  temp/115[%eax] := "camlCode"
                  temp/116[%edx] := [temp/115[%eax] + 56]
                  {temp/111[%esi]* temp/112[%ebx]* temp/114[s0]
                   temp/116[%edx]*}
                  A/117[%ecx] := alloc 12
                  [A/117[%ecx] + -4] := 2301
                  float64u[A/117[%ecx]] := temp/114[s0]
                  R/0[%eax] := temp/111[%esi]
                  {}
                  R/0[%eax] := call "camlCode__create_1093" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  temp/119[%ebx] := "camlCode"
                  [temp/119[%ebx] + 68] := scene/118[%eax]
                  temp/120[%eax] := "camlPervasives"
                  temp/121[%eax] := [temp/120[%eax] + 92]
                  {}
                  R/0[%eax] := call "camlPrintf__fprintf_1392" R/0[%eax] {printf.ml:641,17-35}
                  temp/122[%ebx] := R/0[%eax]
                  temp/123[%eax] := "camlCode__5"
                  A/124[%ecx] := [temp/122[%ebx]]
                  {}
                  R/0[%eax] := call A/124[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  temp/125[%ecx] := R/0[%eax]
                  temp/126[%eax] := "camlCode"
                  temp/127[%eax] := [temp/126[%eax] + 64]
                  temp/128[%ebx] := "camlCode"
                  temp/129[%ebx] := [temp/128[%ebx] + 64]
                  {}
                  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  temp/130[%eax] := "camlCode"
                  temp/131[%ebx] := [temp/130[%eax] + 64]
                  temp/132[%eax] := 3
                  I/133[%ebx] := I/133[%ebx] - temp/132[%eax]
                  temp/134[%ebx] := temp/134[%ebx] + 1
                  temp/135[%eax] := 1
                  if y/136[%ebx] <s bound/137[%eax] goto L225
                  spilled-bound/432[s0] := bound/137[%eax] (spill)
                  spilled-y/416[s9] := y/136[%ebx] (spill)
                  L226 [0]:
                  temp/138[%eax] := "camlCode"
                  temp/139[%eax] := [temp/138[%eax] + 64]
                  temp/140[%ebx] := 3
                  I/141[%eax] := I/141[%eax] - temp/140[%ebx]
                  temp/142[%eax] := temp/142[%eax] + 1
                  temp/143[%ebx] := 1
                  spilled-x/421[s5] := x/144[%ebx] (spill)
                  spilled-bound/426[s1] := bound/145[%eax] (spill)
                  if x/144[%ebx] >s bound/145[%eax] goto L227
                  L228 [0]:
                  R/7[%tos] := 0.
                  g/147[s0] := R/7[%tos]
                  temp/148[%ebx] := 1
                  temp/149[%eax] := 7
                  spilled-dx/420[s6] := dx/150[%ebx] (spill)
                  spilled-bound/422[s4] := bound/151[%eax] (spill)
                  if dx/150[%ebx] >s bound/151[%eax] goto L232
                  L233 [0]:
                  temp/152[%ebx] := 1
                  temp/153[%eax] := 7
                  spilled-dy/414[s10] := dy/154[%ebx] (spill)
                  spilled-bound/413[s11] := bound/155[%eax] (spill)
                  if dy/154[%ebx] >s bound/155[%eax] goto L234
                  L235 [0]:
                  x/434[%eax] := spilled-x/421[s5] (reload)
                  I/156[%eax] := I/156[%eax] >>s 1
                  R/7[%tos] := floatofint I/156[%eax]
                  temp/158[s3] := R/7[%tos]
                  temp/159[%eax] := "camlCode"
                  temp/160[%eax] := [temp/159[%eax] + 64]
                  I/161[%eax] := I/161[%eax] >>s 1
                  R/7[%tos] := floatofint I/161[%eax]
                  temp/163[s2] := R/7[%tos]
                  R/7[%tos] := 2.
                  temp/165[s1] := R/7[%tos]
                  R/7[%tos] := temp/163[s2] /f temp/165[s1]
                  temp/167[s1] := R/7[%tos]
                  R/7[%tos] := temp/158[s3] -f temp/167[s1]
                  temp/169[s2] := R/7[%tos]
                  dx/435[%eax] := spilled-dx/420[s6] (reload)
                  I/170[%eax] := I/170[%eax] >>s 1
                  R/7[%tos] := floatofint I/170[%eax]
                  temp/172[s1] := R/7[%tos]
                  temp/173[%ecx] := 9
                  {dy/154[%ebx] temp/169[s2] temp/172[s1] temp/173[%ecx]
                   spilled-bound/413[s11] spilled-dy/414[s10]
                   spilled-g/415[s0] spilled-y/416[s9] spilled-dx/420[s6]
                   spilled-x/421[s5] spilled-bound/422[s4]
                   spilled-bound/426[s1] spilled-bound/432[s0]}
                  temp/174[%eax] := alloc 52
                  [temp/174[%eax] + -4] := 2301
                  I/175[%ecx] := I/175[%ecx] >>s 1
                  R/7[%tos] := floatofint I/175[%ecx]
                  float64u[temp/174[%eax]] := R/7[%tos]
                  R/7[%tos] := temp/172[s1] /f float64[temp/174[%eax]]
                  temp/178[s1] := R/7[%tos]
                  R/7[%tos] := temp/169[s2] +f temp/178[s1]
                  temp/180[s4] := R/7[%tos]
                  y/436[%ecx] := spilled-y/416[s9] (reload)
                  I/181[%ecx] := I/181[%ecx] >>s 1
                  R/7[%tos] := floatofint I/181[%ecx]
                  temp/183[s3] := R/7[%tos]
                  temp/184[%ecx] := "camlCode"
                  temp/185[%ecx] := [temp/184[%ecx] + 64]
                  I/186[%ecx] := I/186[%ecx] >>s 1
                  R/7[%tos] := floatofint I/186[%ecx]
                  temp/188[s2] := R/7[%tos]
                  R/7[%tos] := 2.
                  temp/190[s1] := R/7[%tos]
                  R/7[%tos] := temp/188[s2] /f temp/190[s1]
                  temp/192[s1] := R/7[%tos]
                  R/7[%tos] := temp/183[s3] -f temp/192[s1]
                  temp/194[s2] := R/7[%tos]
                  I/195[%ebx] := I/195[%ebx] >>s 1
                  R/7[%tos] := floatofint I/195[%ebx]
                  temp/197[s1] := R/7[%tos]
                  temp/198[%ebx] := 9
                  temp/199[%ecx] := temp/174[%eax] + 12
                  [temp/199[%ecx] + -4] := 2301
                  I/200[%ebx] := I/200[%ebx] >>s 1
                  R/7[%tos] := floatofint I/200[%ebx]
                  float64u[temp/199[%ecx]] := R/7[%tos]
                  R/7[%tos] := temp/197[s1] /f float64[temp/199[%ecx]]
                  temp/203[s1] := R/7[%tos]
                  R/7[%tos] := temp/194[s2] +f temp/203[s1]
                  temp/205[s2] := R/7[%tos]
                  temp/206[%ebx] := "camlCode"
                  temp/207[%ebx] := [temp/206[%ebx] + 64]
                  I/208[%ebx] := I/208[%ebx] >>s 1
                  R/7[%tos] := floatofint I/208[%ebx]
                  temp/210[s1] := R/7[%tos]
                  r/211[%eax] := temp/174[%eax] + 24
                  spilled-r/425[s2] := r/211[%eax] (spill)
                  [r/211[%eax] + -4] := 6398
                  float64u[r/211[%eax]] := temp/180[s4]
                  float64u[r/211[%eax] + 8] := temp/205[s2]
                  float64u[r/211[%eax] + 16] := temp/210[s1]
                  R/7[%tos] := 1.
                  temp/213[s4] := R/7[%tos]
                  R/7[%tos] := float64u[r/211[%eax]]
                  temp/215[s2] := R/7[%tos]
                  R/7[%tos] := float64u[r/211[%eax]]
                  temp/217[s1] := R/7[%tos]
                  R/7[%tos] := temp/215[s2] *f temp/217[s1]
                  temp/219[s3] := R/7[%tos]
                  R/7[%tos] := float64u[r/211[%eax] + 8]
                  temp/221[s2] := R/7[%tos]
                  R/7[%tos] := float64u[r/211[%eax] + 8]
                  temp/223[s1] := R/7[%tos]
                  R/7[%tos] := temp/221[s2] *f temp/223[s1]
                  temp/225[s1] := R/7[%tos]
                  R/7[%tos] := temp/219[s3] +f temp/225[s1]
                  temp/227[s3] := R/7[%tos]
                  R/7[%tos] := float64u[r/211[%eax] + 16]
                  temp/229[s2] := R/7[%tos]
                  R/7[%tos] := float64u[r/211[%eax] + 16]
                  temp/231[s1] := R/7[%tos]
                  R/7[%tos] := temp/229[s2] *f temp/231[s1]
                  temp/233[s1] := R/7[%tos]
                  R/7[%tos] := temp/227[s3] +f temp/233[s1]
                  temp/235[s1] := R/7[%tos]
                  push temp/235[s1]
                  {temp/213[s4] spilled-bound/413[s11] spilled-dy/414[s10]
                   spilled-g/415[s0] spilled-y/416[s9] spilled-dx/420[s6]
                   spilled-x/421[s5] spilled-bound/422[s4] spilled-r/425[s2]*
                   spilled-bound/426[s1] spilled-bound/432[s0]}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  temp/236[s1] := R/7[%tos]
                  R/7[%tos] := temp/213[s4] /f temp/236[s1]
                  s/238[s4] := R/7[%tos]
                  r/437[%eax] := spilled-r/425[s2] (reload)
                  R/7[%tos] := float64u[r/437[%eax]]
                  temp/240[s1] := R/7[%tos]
                  R/7[%tos] := s/238[s4] *f temp/240[s1]
                  temp/242[s3] := R/7[%tos]
                  R/7[%tos] := float64u[r/437[%eax] + 8]
                  temp/244[s1] := R/7[%tos]
                  R/7[%tos] := s/238[s4] *f temp/244[s1]
                  temp/246[s2] := R/7[%tos]
                  R/7[%tos] := float64u[r/437[%eax] + 16]
                  temp/248[s1] := R/7[%tos]
                  R/7[%tos] := s/238[s4] *f temp/248[s1]
                  temp/250[s1] := R/7[%tos]
                  {temp/242[s3] temp/246[s2] temp/250[s1]
                   spilled-bound/413[s11] spilled-dy/414[s10]
                   spilled-g/415[s0] spilled-y/416[s9] spilled-dx/420[s6]
                   spilled-x/421[s5] spilled-bound/422[s4]
                   spilled-bound/426[s1] spilled-bound/432[s0]}
                  dir/251[%eax] := alloc 40
                  spilled-dir/412[s12] := dir/251[%eax] (spill)
                  [dir/251[%eax] + -4] := 6398
                  float64u[dir/251[%eax]] := temp/242[s3]
                  float64u[dir/251[%eax] + 8] := temp/246[s2]
                  float64u[dir/251[%eax] + 16] := temp/250[s1]
                  temp/252[%ebx] := "camlCode"
                  scene/253[%ebx] := [temp/252[%ebx] + 68]
                  spilled-scene/411[s13] := scene/253[%ebx] (spill)
                  temp/254[%ebx] := "camlCode"
                  temp/255[%ebx] := [temp/254[%ebx] + 4]
                  spilled-temp/423[s3] := temp/255[%ebx] (spill)
                  temp/256[%ebx] := "camlPervasives"
                  temp/257[%ebx] := [temp/256[%ebx] + 36]
                  spilled-temp/419[s7] := temp/257[%ebx] (spill)
                  temp/258[%ebx] := "camlCode"
                  temp/259[%ebx] := [temp/258[%ebx] + 4]
                  spilled-temp/424[s2] := temp/259[%ebx] (spill)
                  temp/260[%ebx] := dir/251[%eax] + 28
                  spilled-temp/418[s8] := temp/260[%ebx] (spill)
                  [temp/260[%ebx] + -4] := 2048
                  temp/438[%eax] := spilled-temp/419[s7] (reload)
                  [temp/260[%ebx]] := temp/438[%eax]
                  temp/439[%eax] := spilled-temp/424[s2] (reload)
                  [temp/260[%ebx] + 4] := temp/439[%eax]
                  temp/261[%eax] := "camlCode"
                  temp/262[%eax] := [temp/261[%eax] + 36]
                  spilled-temp/417[s2] := temp/262[%eax] (spill)
                  temp/440[%eax] := spilled-temp/423[s3] (reload)
                  dir/441[%ebx] := spilled-dir/412[s12] (reload)
                  temp/442[%ecx] := spilled-temp/418[s8] (reload)
                  scene/443[%edx] := spilled-scene/411[s13] (reload)
                  temp/444[%esi] := spilled-temp/417[s2] (reload)
                  {spilled-scene/411[s13]* spilled-dir/412[s12]*
                   spilled-bound/413[s11] spilled-dy/414[s10]
                   spilled-g/415[s0] spilled-y/416[s9] spilled-dx/420[s6]
                   spilled-x/421[s5] spilled-bound/422[s4]
                   spilled-bound/426[s1] spilled-bound/432[s0]}
                  R/0[%eax] := call "camlCode__intersect_1067" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
                  match/263[%esi] := R/0[%eax]
                  n/264[%ebx] := [match/263[%esi] + 4]
                  temp/265[%eax] := "camlCode"
                  b/266[%eax] := [temp/265[%eax] + 44]
                  R/7[%tos] := float64u[n/264[%ebx]]
                  temp/268[s2] := R/7[%tos]
                  R/7[%tos] := float64u[b/266[%eax]]
                  temp/270[s1] := R/7[%tos]
                  R/7[%tos] := temp/268[s2] *f temp/270[s1]
                  temp/272[s3] := R/7[%tos]
                  R/7[%tos] := float64u[n/264[%ebx] + 8]
                  temp/274[s2] := R/7[%tos]
                  R/7[%tos] := float64u[b/266[%eax] + 8]
                  temp/276[s1] := R/7[%tos]
                  R/7[%tos] := temp/274[s2] *f temp/276[s1]
                  temp/278[s1] := R/7[%tos]
                  R/7[%tos] := temp/272[s3] +f temp/278[s1]
                  temp/280[s3] := R/7[%tos]
                  R/7[%tos] := float64u[n/264[%ebx] + 16]
                  temp/282[s2] := R/7[%tos]
                  R/7[%tos] := float64u[b/266[%eax] + 16]
                  temp/284[s1] := R/7[%tos]
                  R/7[%tos] := temp/282[s2] *f temp/284[s1]
                  temp/286[s1] := R/7[%tos]
                  R/7[%tos] := temp/280[s3] +f temp/286[s1]
                  g/288[s1] := R/7[%tos]
                  R/7[%tos] := 0.
                  temp/290[s2] := R/7[%tos]
                  if not g/288[s1] <=f temp/290[s2] goto L242
                  I/291[%eax] := 1
                  goto L241
                  L242 [0]:
                  I/292[%eax] := 0
                  L241 [0]:
                  temp/293[%eax] := I/291[%eax]  * 2 + 1
                  if temp/293[%eax] ==s 1 goto L240
                  temp/294[%eax] := "camlCode__8"
                  goto L236
                  L240 [0]:
                  temp/295[%eax] := "camlPervasives"
                  temp/296[%eax] := [temp/295[%eax] + 56]
                  pushfloat [temp/296[%eax]]
                  {match/263[%esi]* n/264[%ebx]* spilled-g/410[s1]
                   spilled-scene/411[s13]* spilled-dir/412[s12]*
                   spilled-bound/413[s11] spilled-dy/414[s10]
                   spilled-g/415[s0] spilled-y/416[s9] spilled-dx/420[s6]
                   spilled-x/421[s5] spilled-bound/422[s4]
                   spilled-bound/426[s1] spilled-bound/432[s0]}
                  R/7[%tos] := extcall "sqrt" 
                  offset stack -8
                  s/297[s5] := R/7[%tos]
                  R/7[%tos] := float64u[n/264[%ebx]]
                  temp/299[s2] := R/7[%tos]
                  R/7[%tos] := s/297[s5] *f temp/299[s2]
                  temp/301[s4] := R/7[%tos]
                  R/7[%tos] := float64u[n/264[%ebx] + 8]
                  temp/303[s2] := R/7[%tos]
                  R/7[%tos] := s/297[s5] *f temp/303[s2]
                  temp/305[s3] := R/7[%tos]
                  R/7[%tos] := float64u[n/264[%ebx] + 16]
                  temp/307[s2] := R/7[%tos]
                  R/7[%tos] := s/297[s5] *f temp/307[s2]
                  temp/309[s2] := R/7[%tos]
                  {match/263[%esi]* temp/301[s4] temp/305[s3] temp/309[s2]
                   spilled-g/410[s1] spilled-scene/411[s13]*
                   spilled-dir/412[s12]* spilled-bound/413[s11]
                   spilled-dy/414[s10] spilled-g/415[s0] spilled-y/416[s9]
                   spilled-dx/420[s6] spilled-x/421[s5] spilled-bound/422[s4]
                   spilled-bound/426[s1] spilled-bound/432[s0]}
                  b/310[%ecx] := alloc 96
                  [b/310[%ecx] + -4] := 6398
                  float64u[b/310[%ecx]] := temp/301[s4]
                  float64u[b/310[%ecx] + 8] := temp/305[s3]
                  float64u[b/310[%ecx] + 16] := temp/309[s2]
                  s/311[%ebx] := [match/263[%esi]]
                  dir/445[%eax] := spilled-dir/412[s12] (reload)
                  R/7[%tos] := float64u[dir/445[%eax]]
                  temp/313[s2] := R/7[%tos]
                  R/7[%tos] := temp/313[s2] *f float64[s/311[%ebx]]
                  temp/315[s4] := R/7[%tos]
                  R/7[%tos] := float64u[dir/445[%eax] + 8]
                  temp/317[s2] := R/7[%tos]
                  R/7[%tos] := temp/317[s2] *f float64[s/311[%ebx]]
                  temp/319[s3] := R/7[%tos]
                  R/7[%tos] := float64u[dir/445[%eax] + 16]
                  temp/321[s2] := R/7[%tos]
                  R/7[%tos] := temp/321[s2] *f float64[s/311[%ebx]]
                  temp/323[s2] := R/7[%tos]
                  a/324[%eax] := b/310[%ecx] + 28
                  [a/324[%eax] + -4] := 6398
                  float64u[a/324[%eax]] := temp/315[s4]
                  float64u[a/324[%eax] + 8] := temp/319[s3]
                  float64u[a/324[%eax] + 16] := temp/323[s2]
                  R/7[%tos] := float64u[a/324[%eax]]
                  temp/326[s3] := R/7[%tos]
                  R/7[%tos] := float64u[b/310[%ecx]]
                  temp/328[s2] := R/7[%tos]
                  R/7[%tos] := temp/326[s3] +f temp/328[s2]
                  temp/330[s5] := R/7[%tos]
                  R/7[%tos] := float64u[a/324[%eax] + 8]
                  temp/332[s3] := R/7[%tos]
                  R/7[%tos] := float64u[b/310[%ecx] + 8]
                  temp/334[s2] := R/7[%tos]
                  R/7[%tos] := temp/332[s3] +f temp/334[s2]
                  temp/336[s4] := R/7[%tos]
                  R/7[%tos] := float64u[a/324[%eax] + 16]
                  temp/338[s3] := R/7[%tos]
                  R/7[%tos] := float64u[b/310[%ecx] + 16]
                  temp/340[s2] := R/7[%tos]
                  R/7[%tos] := temp/338[s3] +f temp/340[s2]
                  temp/342[s2] := R/7[%tos]
                  p/343[%eax] := b/310[%ecx] + 56
                  [p/343[%eax] + -4] := 6398
                  float64u[p/343[%eax]] := temp/330[s5]
                  float64u[p/343[%eax] + 8] := temp/336[s4]
                  float64u[p/343[%eax] + 16] := temp/342[s2]
                  temp/344[%ebx] := "camlCode"
                  temp/345[%ebx] := [temp/344[%ebx] + 44]
                  temp/346[%edx] := "camlPervasives"
                  temp/347[%esi] := [temp/346[%edx] + 36]
                  temp/348[%edx] := "camlCode"
                  temp/349[%edx] := [temp/348[%edx] + 4]
                  temp/350[%ecx] := b/310[%ecx] + 84
                  [temp/350[%ecx] + -4] := 2048
                  [temp/350[%ecx]] := temp/347[%esi]
                  [temp/350[%ecx] + 4] := temp/349[%edx]
                  temp/351[%edx] := "camlCode"
                  temp/352[%esi] := [temp/351[%edx] + 36]
                  scene/446[%edx] := spilled-scene/411[s13] (reload)
                  {spilled-g/410[s1] spilled-bound/413[s11]
                   spilled-dy/414[s10] spilled-g/415[s0] spilled-y/416[s9]
                   spilled-dx/420[s6] spilled-x/421[s5] spilled-bound/422[s4]
                   spilled-bound/426[s1] spilled-bound/432[s0]}
                  R/0[%eax] := call "camlCode__intersect_1067" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
                  temp/354[%ebx] := [temp/353[%eax]]
                  temp/355[%eax] := "camlPervasives"
                  temp/356[%eax] := [temp/355[%eax] + 36]
                  R/7[%tos] := float64u[temp/356[%eax]]
                  R/7[%tos] := float64u[temp/354[%ebx]]
                  if not R/7[%tos] <f R/7[%tos] goto L239
                  I/359[%eax] := 1
                  goto L238
                  L239 [0]:
                  I/360[%eax] := 0
                  L238 [0]:
                  temp/361[%eax] := I/359[%eax]  * 2 + 1
                  if temp/361[%eax] ==s 1 goto L237
                  A/362[%eax] := "camlCode__7"
                  goto L236
                  L237 [0]:
                  {spilled-g/410[s1] spilled-bound/413[s11]
                   spilled-dy/414[s10] spilled-g/415[s0] spilled-y/416[s9]
                   spilled-dx/420[s6] spilled-x/421[s5] spilled-bound/422[s4]
                   spilled-bound/426[s1] spilled-bound/432[s0]}
                  A/363[%eax] := alloc 12
                  [A/363[%eax] + -4] := 2301
                  float64u[A/363[%eax]] := g/447[s1]
                  L236 [0]:
                  R/7[%tos] := g/147[s0] +f float64[temp/294[%eax]]
                  temp/365[s0] := R/7[%tos]
                  dy/154[%ebx] := spilled-dy/414[s10] (reload)
                  dy/366[%ecx] := dy/154[%ebx]
                  I/367[%ebx] := I/367[%ebx] + 2
                  spilled-dy/414[s10] := dy/154[%ebx] (spill)
                  bound/450[%eax] := spilled-bound/413[s11] (reload)
                  if dy/366[%ecx] !=s bound/450[%eax] goto L235
                  L234 [0]:
                  dx/451[%eax] := spilled-dx/420[s6] (reload)
                  dx/368[%ebx] := dx/451[%eax]
                  I/369[%eax] := I/369[%eax] + 2
                  spilled-dx/420[s6] := dx/451[%eax] (spill)
                  bound/452[%eax] := spilled-bound/422[s4] (reload)
                  if dx/368[%ebx] !=s bound/452[%eax] goto L233
                  L232 [0]:
                  R/7[%tos] := 0.5
                  temp/371[s2] := R/7[%tos]
                  R/7[%tos] := 255.
                  temp/373[s1] := R/7[%tos]
                  R/7[%tos] := temp/373[s1] *f g/147[s0]
                  temp/375[s0] := R/7[%tos]
                  temp/376[%ebx] := 33
                  {temp/371[s2] temp/375[s0] temp/376[%ebx] spilled-y/416[s9]
                   spilled-x/421[s5] spilled-bound/426[s1]
                   spilled-bound/432[s0]}
                  temp/377[%eax] := alloc 12
                  [temp/377[%eax] + -4] := 2301
                  I/378[%ebx] := I/378[%ebx] >>s 1
                  R/7[%tos] := floatofint I/378[%ebx]
                  float64u[temp/377[%eax]] := R/7[%tos]
                  R/7[%tos] := temp/375[s0] /f float64[temp/377[%eax]]
                  temp/381[s0] := R/7[%tos]
                  R/7[%tos] := temp/371[s2] +f temp/381[s0]
                  g/383[s0] := R/7[%tos]
                  temp/384[%eax] := "camlPervasives"
                  temp/385[%eax] := [temp/384[%eax] + 92]
                  {spilled-y/416[s9] spilled-x/421[s5] spilled-bound/426[s1]
                   spilled-g/427[s0] spilled-bound/432[s0]}
                  R/0[%eax] := call "camlPrintf__fprintf_1392" R/0[%eax] {printf.ml:641,17-35}
                  temp/386[%ebx] := R/0[%eax]
                  temp/387[%eax] := "camlCode__6"
                  A/388[%ecx] := [temp/386[%ebx]]
                  {spilled-y/416[s9] spilled-x/421[s5] spilled-bound/426[s1]
                   spilled-g/427[s0] spilled-bound/432[s0]}
                  R/0[%eax] := call A/388[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  temp/389[%ebx] := R/0[%eax]
                  I/390[%eax] := intoffloat g/453[s0]
                  n/391[%ecx] := I/390[%eax]  * 2 + 1
                  temp/392[%eax] := 1
                  I/393[%eax] := n/391[%ecx] <s temp/392[%eax]
                  temp/394[%eax] := I/393[%eax]  * 2 + 1
                  if temp/394[%eax] ==s 1 goto L231
                  temp/395[%eax] := 3
                  goto L230
                  L231 [0]:
                  temp/396[%eax] := 511
                  I/397[%eax] := n/391[%ecx] >s temp/396[%eax]
                  I/398[%eax] := I/397[%eax]  * 2 + 1
                  L230 [0]:
                  if temp/395[%eax] ==s 1 goto L229
                  temp/399[%ecx] := "caml_exn_Invalid_argument"
                  temp/400[%ebx] := "camlPervasives__2"
                  {temp/399[%ecx]* temp/400[%ebx]*}
                  temp/401[%eax] := alloc 12
                  [temp/401[%eax] + -4] := 2048
                  [temp/401[%eax]] := temp/399[%ecx]
                  [temp/401[%eax] + 4] := temp/400[%ebx]
                  raise R/0[%eax] {pervasives.ml:155,27-52}
                  L229 [0]:
                  temp/402[%eax] := n/391[%ecx]
                  A/403[%edx] := [temp/389[%ebx]]
                  {spilled-y/416[s9] spilled-x/421[s5] spilled-bound/426[s1]
                   spilled-bound/432[s0]}
                  call A/403[%edx] R/0[%eax] R/1[%ebx]
                  x/454[%eax] := spilled-x/421[s5] (reload)
                  x/404[%ebx] := x/454[%eax]
                  I/405[%eax] := I/405[%eax] + 2
                  spilled-x/421[s5] := x/454[%eax] (spill)
                  bound/455[%eax] := spilled-bound/426[s1] (reload)
                  if x/404[%ebx] !=s bound/455[%eax] goto L228
                  L227 [0]:
                  y/456[%eax] := spilled-y/416[s9] (reload)
                  y/406[%ebx] := y/456[%eax]
                  I/407[%eax] := I/407[%eax] - 2
                  spilled-y/416[s9] := y/456[%eax] (spill)
                  bound/457[%eax] := spilled-bound/432[s0] (reload)
                  if y/406[%ebx] !=s bound/457[%eax] goto L226
                  L225 [0]:
                  A/408[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  temp/8[%eax] := "camlPervasives"
  temp/9[%eax] := [temp/8[%eax] + 56]
  pushfloat [temp/9[%eax]]
  {}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  delta/10[s0] := R/7[%tos]
  temp/11[%ebx] := "camlCode"
  {delta/10[s0] temp/11[%ebx]*}
  A/12[%eax] := alloc 12
  [A/12[%eax] + -4] := 2301
  float64u[A/12[%eax]] := delta/10[s0]
  [temp/11[%ebx]] := A/12[%eax]
  zero/13[%ebx] := "camlCode__1"
  temp/14[%eax] := "camlCode"
  [temp/14[%eax] + 4] := zero/13[%ebx]
  *|/15[%ebx] := "camlCode__18"
  temp/16[%eax] := "camlCode"
  [temp/16[%eax] + 8] := *|/15[%ebx]
  +|/17[%ebx] := "camlCode__17"
  temp/18[%eax] := "camlCode"
  [temp/18[%eax] + 12] := +|/17[%ebx]
  -|/19[%ebx] := "camlCode__16"
  temp/20[%eax] := "camlCode"
  [temp/20[%eax] + 16] := -|/19[%ebx]
  dot/21[%ebx] := "camlCode__15"
  temp/22[%eax] := "camlCode"
  [temp/22[%eax] + 20] := dot/21[%ebx]
  length/23[%ebx] := "camlCode__14"
  temp/24[%eax] := "camlCode"
  [temp/24[%eax] + 24] := length/23[%ebx]
  unitise/25[%ebx] := "camlCode__13"
  temp/26[%eax] := "camlCode"
  [temp/26[%eax] + 28] := unitise/25[%ebx]
  ray_sphere/27[%ebx] := "camlCode__12"
  temp/28[%eax] := "camlCode"
  [temp/28[%eax] + 32] := ray_sphere/27[%ebx]
  clos/29[%eax] := "camlCode__11"
  temp/30[%ebx] := "camlCode"
  [temp/30[%ebx] + 36] := clos/29[%eax]
  temp/31[%ebx] := "camlCode"
  temp/32[%eax] := temp/32[%eax] + 16
  [temp/31[%ebx] + 40] := temp/32[%eax]
  R/7[%tos] := 1.
  temp/34[s3] := R/7[%tos]
  temp/35[%eax] := "camlCode__2"
  R/7[%tos] := float64u[temp/35[%eax]]
  temp/37[s1] := R/7[%tos]
  temp/38[%eax] := "camlCode__2"
  R/7[%tos] := float64u[temp/38[%eax]]
  temp/40[s0] := R/7[%tos]
  R/7[%tos] := temp/37[s1] *f temp/40[s0]
  temp/42[s2] := R/7[%tos]
  temp/43[%eax] := "camlCode__2"
  R/7[%tos] := float64u[temp/43[%eax] + 8]
  temp/45[s1] := R/7[%tos]
  temp/46[%eax] := "camlCode__2"
  R/7[%tos] := float64u[temp/46[%eax] + 8]
  temp/48[s0] := R/7[%tos]
  R/7[%tos] := temp/45[s1] *f temp/48[s0]
  temp/50[s0] := R/7[%tos]
  R/7[%tos] := temp/42[s2] +f temp/50[s0]
  temp/52[s2] := R/7[%tos]
  temp/53[%eax] := "camlCode__2"
  R/7[%tos] := float64u[temp/53[%eax] + 16]
  temp/55[s1] := R/7[%tos]
  temp/56[%eax] := "camlCode__2"
  R/7[%tos] := float64u[temp/56[%eax] + 16]
  temp/58[s0] := R/7[%tos]
  R/7[%tos] := temp/55[s1] *f temp/58[s0]
  temp/60[s0] := R/7[%tos]
  R/7[%tos] := temp/52[s2] +f temp/60[s0]
  temp/62[s0] := R/7[%tos]
  push temp/62[s0]
  {temp/34[s3]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  temp/63[s0] := R/7[%tos]
  R/7[%tos] := temp/34[s3] /f temp/63[s0]
  s/65[s3] := R/7[%tos]
  temp/66[%eax] := "camlCode__2"
  R/7[%tos] := float64u[temp/66[%eax]]
  temp/68[s0] := R/7[%tos]
  R/7[%tos] := s/65[s3] *f temp/68[s0]
  temp/70[s2] := R/7[%tos]
  temp/71[%eax] := "camlCode__2"
  R/7[%tos] := float64u[temp/71[%eax] + 8]
  temp/73[s0] := R/7[%tos]
  R/7[%tos] := s/65[s3] *f temp/73[s0]
  temp/75[s1] := R/7[%tos]
  temp/76[%eax] := "camlCode__2"
  R/7[%tos] := float64u[temp/76[%eax] + 16]
  temp/78[s0] := R/7[%tos]
  R/7[%tos] := s/65[s3] *f temp/78[s0]
  temp/80[s0] := R/7[%tos]
  {temp/70[s2] temp/75[s1] temp/80[s0]}
  light/81[%ebx] := alloc 28
  [light/81[%ebx] + -4] := 6398
  float64u[light/81[%ebx]] := temp/70[s2]
  float64u[light/81[%ebx] + 8] := temp/75[s1]
  float64u[light/81[%ebx] + 16] := temp/80[s0]
  temp/82[%eax] := "camlCode"
  [temp/82[%eax] + 44] := light/81[%ebx]
  temp/83[%ebx] := "camlCode"
  temp/84[%eax] := 9
  [temp/83[%ebx] + 48] := temp/84[%eax]
  ray_trace/85[%ebx] := "camlCode__10"
  temp/86[%eax] := "camlCode"
  [temp/86[%eax] + 52] := ray_trace/85[%ebx]
  clos/87[%ebx] := "camlCode__9"
  temp/88[%eax] := "camlCode"
  [temp/88[%eax] + 56] := clos/87[%ebx]
  setup trap L244
  A/105[%ecx] := "camlCode__3"
  goto L243
  L244 [2]:
  push trap
  temp/89[%eax] := "camlSys"
  temp/90[%ecx] := [temp/89[%eax]]
  temp/91[%ebx] := 3
  A/92[%eax] := [temp/90[%ecx] + -4]
  I/93[%eax] := I/93[%eax] >>u 9
  I/93[%eax] check > temp/91[%ebx]
  temp/94[%eax] := [temp/90[%ecx] + temp/91[%ebx] * 2 + -2]
  push temp/94[%eax]
  {}
  R/0[%eax] := extcall "caml_int_of_string"  (noalloc)
  offset stack -4
  spilled-temp/409[s0] := temp/95[%eax] (spill)
  temp/96[%eax] := "camlSys"
  temp/97[%ecx] := [temp/96[%eax]]
  temp/98[%ebx] := 5
  A/99[%eax] := [temp/97[%ecx] + -4]
  I/100[%eax] := I/100[%eax] >>u 9
  I/100[%eax] check > temp/98[%ebx]
  temp/101[%eax] := [temp/97[%ecx] + temp/98[%ebx] * 2 + -2]
  push temp/101[%eax]
  {spilled-temp/409[s0]*}
  R/0[%eax] := extcall "caml_int_of_string"  (noalloc)
  offset stack -4
  temp/102[%ebx] := R/0[%eax]
  {temp/102[%ebx]* spilled-temp/409[s0]*}
  match/103[%ecx] := alloc 12
  [match/103[%ecx] + -4] := 2048
  temp/433[%eax] := spilled-temp/409[s0] (reload)
  [match/103[%ecx]] := temp/433[%eax]
  [match/103[%ecx] + 4] := temp/102[%ebx]
  pop trap
  L243 [3]:
  temp/106[%ebx] := "camlCode"
  temp/107[%eax] := [match/103[%ecx]]
  [temp/106[%ebx] + 60] := temp/107[%eax]
  temp/108[%ebx] := "camlCode"
  temp/109[%eax] := [match/103[%ecx] + 4]
  [temp/108[%ebx] + 64] := temp/109[%eax]
  temp/110[%eax] := "camlCode"
  temp/111[%esi] := [temp/110[%eax] + 60]
  temp/112[%ebx] := "camlCode__4"
  R/7[%tos] := 1.
  temp/114[s0] := R/7[%tos]
  temp/115[%eax] := "camlCode"
  temp/116[%edx] := [temp/115[%eax] + 56]
  {temp/111[%esi]* temp/112[%ebx]* temp/114[s0] temp/116[%edx]*}
  A/117[%ecx] := alloc 12
  [A/117[%ecx] + -4] := 2301
  float64u[A/117[%ecx]] := temp/114[s0]
  R/0[%eax] := temp/111[%esi]
  {}
  R/0[%eax] := call "camlCode__create_1093" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  temp/119[%ebx] := "camlCode"
  [temp/119[%ebx] + 68] := scene/118[%eax]
  temp/120[%eax] := "camlPervasives"
  temp/121[%eax] := [temp/120[%eax] + 92]
  {}
  R/0[%eax] := call "camlPrintf__fprintf_1392" R/0[%eax] {printf.ml:641,17-35}
  temp/122[%ebx] := R/0[%eax]
  temp/123[%eax] := "camlCode__5"
  A/124[%ecx] := [temp/122[%ebx]]
  {}
  R/0[%eax] := call A/124[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  temp/125[%ecx] := R/0[%eax]
  temp/126[%eax] := "camlCode"
  temp/127[%eax] := [temp/126[%eax] + 64]
  temp/128[%ebx] := "camlCode"
  temp/129[%ebx] := [temp/128[%ebx] + 64]
  {}
  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  temp/130[%eax] := "camlCode"
  temp/131[%ebx] := [temp/130[%eax] + 64]
  temp/132[%eax] := 3
  I/133[%ebx] := I/133[%ebx] - temp/132[%eax]
  temp/134[%ebx] := temp/134[%ebx] + 1
  temp/135[%eax] := 1
  if y/136[%ebx] <s bound/137[%eax] goto L225
  spilled-bound/432[s0] := bound/137[%eax] (spill)
  spilled-y/416[s9] := y/136[%ebx] (spill)
  L226 [4]:
  temp/138[%eax] := "camlCode"
  temp/139[%eax] := [temp/138[%eax] + 64]
  temp/140[%ebx] := 3
  I/141[%eax] := I/141[%eax] - temp/140[%ebx]
  temp/142[%eax] := temp/142[%eax] + 1
  temp/143[%ebx] := 1
  spilled-x/421[s5] := x/144[%ebx] (spill)
  spilled-bound/426[s1] := bound/145[%eax] (spill)
  if x/144[%ebx] >s bound/145[%eax] goto L227
  L228 [4]:
  R/7[%tos] := 0.
  g/147[s0] := R/7[%tos]
  temp/148[%ebx] := 1
  temp/149[%eax] := 7
  spilled-dx/420[s6] := dx/150[%ebx] (spill)
  spilled-bound/422[s4] := bound/151[%eax] (spill)
  if dx/150[%ebx] >s bound/151[%eax] goto L232
  L233 [4]:
  temp/152[%ebx] := 1
  temp/153[%eax] := 7
  spilled-dy/414[s10] := dy/154[%ebx] (spill)
  spilled-bound/413[s11] := bound/155[%eax] (spill)
  if dy/154[%ebx] >s bound/155[%eax] goto L234
  L235 [4]:
  x/434[%eax] := spilled-x/421[s5] (reload)
  I/156[%eax] := I/156[%eax] >>s 1
  R/7[%tos] := floatofint I/156[%eax]
  temp/158[s3] := R/7[%tos]
  temp/159[%eax] := "camlCode"
  temp/160[%eax] := [temp/159[%eax] + 64]
  I/161[%eax] := I/161[%eax] >>s 1
  R/7[%tos] := floatofint I/161[%eax]
  temp/163[s2] := R/7[%tos]
  R/7[%tos] := 2.
  temp/165[s1] := R/7[%tos]
  R/7[%tos] := temp/163[s2] /f temp/165[s1]
  temp/167[s1] := R/7[%tos]
  R/7[%tos] := temp/158[s3] -f temp/167[s1]
  temp/169[s2] := R/7[%tos]
  dx/435[%eax] := spilled-dx/420[s6] (reload)
  I/170[%eax] := I/170[%eax] >>s 1
  R/7[%tos] := floatofint I/170[%eax]
  temp/172[s1] := R/7[%tos]
  temp/173[%ecx] := 9
  {dy/154[%ebx] temp/169[s2] temp/172[s1] temp/173[%ecx]
   spilled-bound/413[s11] spilled-dy/414[s10] spilled-g/415[s0]
   spilled-y/416[s9] spilled-dx/420[s6] spilled-x/421[s5]
   spilled-bound/422[s4] spilled-bound/426[s1] spilled-bound/432[s0]}
  temp/174[%eax] := alloc 52
  [temp/174[%eax] + -4] := 2301
  I/175[%ecx] := I/175[%ecx] >>s 1
  R/7[%tos] := floatofint I/175[%ecx]
  float64u[temp/174[%eax]] := R/7[%tos]
  R/7[%tos] := temp/172[s1] /f float64[temp/174[%eax]]
  temp/178[s1] := R/7[%tos]
  R/7[%tos] := temp/169[s2] +f temp/178[s1]
  temp/180[s4] := R/7[%tos]
  y/436[%ecx] := spilled-y/416[s9] (reload)
  I/181[%ecx] := I/181[%ecx] >>s 1
  R/7[%tos] := floatofint I/181[%ecx]
  temp/183[s3] := R/7[%tos]
  temp/184[%ecx] := "camlCode"
  temp/185[%ecx] := [temp/184[%ecx] + 64]
  I/186[%ecx] := I/186[%ecx] >>s 1
  R/7[%tos] := floatofint I/186[%ecx]
  temp/188[s2] := R/7[%tos]
  R/7[%tos] := 2.
  temp/190[s1] := R/7[%tos]
  R/7[%tos] := temp/188[s2] /f temp/190[s1]
  temp/192[s1] := R/7[%tos]
  R/7[%tos] := temp/183[s3] -f temp/192[s1]
  temp/194[s2] := R/7[%tos]
  I/195[%ebx] := I/195[%ebx] >>s 1
  R/7[%tos] := floatofint I/195[%ebx]
  temp/197[s1] := R/7[%tos]
  temp/198[%ebx] := 9
  temp/199[%ecx] := temp/174[%eax] + 12
  [temp/199[%ecx] + -4] := 2301
  I/200[%ebx] := I/200[%ebx] >>s 1
  R/7[%tos] := floatofint I/200[%ebx]
  float64u[temp/199[%ecx]] := R/7[%tos]
  R/7[%tos] := temp/197[s1] /f float64[temp/199[%ecx]]
  temp/203[s1] := R/7[%tos]
  R/7[%tos] := temp/194[s2] +f temp/203[s1]
  temp/205[s2] := R/7[%tos]
  temp/206[%ebx] := "camlCode"
  temp/207[%ebx] := [temp/206[%ebx] + 64]
  I/208[%ebx] := I/208[%ebx] >>s 1
  R/7[%tos] := floatofint I/208[%ebx]
  temp/210[s1] := R/7[%tos]
  r/211[%eax] := temp/174[%eax] + 24
  spilled-r/425[s2] := r/211[%eax] (spill)
  [r/211[%eax] + -4] := 6398
  float64u[r/211[%eax]] := temp/180[s4]
  float64u[r/211[%eax] + 8] := temp/205[s2]
  float64u[r/211[%eax] + 16] := temp/210[s1]
  R/7[%tos] := 1.
  temp/213[s4] := R/7[%tos]
  R/7[%tos] := float64u[r/211[%eax]]
  temp/215[s2] := R/7[%tos]
  R/7[%tos] := float64u[r/211[%eax]]
  temp/217[s1] := R/7[%tos]
  R/7[%tos] := temp/215[s2] *f temp/217[s1]
  temp/219[s3] := R/7[%tos]
  R/7[%tos] := float64u[r/211[%eax] + 8]
  temp/221[s2] := R/7[%tos]
  R/7[%tos] := float64u[r/211[%eax] + 8]
  temp/223[s1] := R/7[%tos]
  R/7[%tos] := temp/221[s2] *f temp/223[s1]
  temp/225[s1] := R/7[%tos]
  R/7[%tos] := temp/219[s3] +f temp/225[s1]
  temp/227[s3] := R/7[%tos]
  R/7[%tos] := float64u[r/211[%eax] + 16]
  temp/229[s2] := R/7[%tos]
  R/7[%tos] := float64u[r/211[%eax] + 16]
  temp/231[s1] := R/7[%tos]
  R/7[%tos] := temp/229[s2] *f temp/231[s1]
  temp/233[s1] := R/7[%tos]
  R/7[%tos] := temp/227[s3] +f temp/233[s1]
  temp/235[s1] := R/7[%tos]
  push temp/235[s1]
  {temp/213[s4] spilled-bound/413[s11] spilled-dy/414[s10] spilled-g/415[s0]
   spilled-y/416[s9] spilled-dx/420[s6] spilled-x/421[s5]
   spilled-bound/422[s4] spilled-r/425[s2]* spilled-bound/426[s1]
   spilled-bound/432[s0]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  temp/236[s1] := R/7[%tos]
  R/7[%tos] := temp/213[s4] /f temp/236[s1]
  s/238[s4] := R/7[%tos]
  r/437[%eax] := spilled-r/425[s2] (reload)
  R/7[%tos] := float64u[r/437[%eax]]
  temp/240[s1] := R/7[%tos]
  R/7[%tos] := s/238[s4] *f temp/240[s1]
  temp/242[s3] := R/7[%tos]
  R/7[%tos] := float64u[r/437[%eax] + 8]
  temp/244[s1] := R/7[%tos]
  R/7[%tos] := s/238[s4] *f temp/244[s1]
  temp/246[s2] := R/7[%tos]
  R/7[%tos] := float64u[r/437[%eax] + 16]
  temp/248[s1] := R/7[%tos]
  R/7[%tos] := s/238[s4] *f temp/248[s1]
  temp/250[s1] := R/7[%tos]
  {temp/242[s3] temp/246[s2] temp/250[s1] spilled-bound/413[s11]
   spilled-dy/414[s10] spilled-g/415[s0] spilled-y/416[s9] spilled-dx/420[s6]
   spilled-x/421[s5] spilled-bound/422[s4] spilled-bound/426[s1]
   spilled-bound/432[s0]}
  dir/251[%eax] := alloc 40
  spilled-dir/412[s12] := dir/251[%eax] (spill)
  [dir/251[%eax] + -4] := 6398
  float64u[dir/251[%eax]] := temp/242[s3]
  float64u[dir/251[%eax] + 8] := temp/246[s2]
  float64u[dir/251[%eax] + 16] := temp/250[s1]
  temp/252[%ebx] := "camlCode"
  scene/253[%ebx] := [temp/252[%ebx] + 68]
  spilled-scene/411[s13] := scene/253[%ebx] (spill)
  temp/254[%ebx] := "camlCode"
  temp/255[%ebx] := [temp/254[%ebx] + 4]
  spilled-temp/423[s3] := temp/255[%ebx] (spill)
  temp/256[%ebx] := "camlPervasives"
  temp/257[%ebx] := [temp/256[%ebx] + 36]
  spilled-temp/419[s7] := temp/257[%ebx] (spill)
  temp/258[%ebx] := "camlCode"
  temp/259[%ebx] := [temp/258[%ebx] + 4]
  spilled-temp/424[s2] := temp/259[%ebx] (spill)
  temp/260[%ebx] := dir/251[%eax] + 28
  spilled-temp/418[s8] := temp/260[%ebx] (spill)
  [temp/260[%ebx] + -4] := 2048
  temp/438[%eax] := spilled-temp/419[s7] (reload)
  [temp/260[%ebx]] := temp/438[%eax]
  temp/439[%eax] := spilled-temp/424[s2] (reload)
  [temp/260[%ebx] + 4] := temp/439[%eax]
  temp/261[%eax] := "camlCode"
  temp/262[%eax] := [temp/261[%eax] + 36]
  spilled-temp/417[s2] := temp/262[%eax] (spill)
  temp/440[%eax] := spilled-temp/423[s3] (reload)
  dir/441[%ebx] := spilled-dir/412[s12] (reload)
  temp/442[%ecx] := spilled-temp/418[s8] (reload)
  scene/443[%edx] := spilled-scene/411[s13] (reload)
  temp/444[%esi] := spilled-temp/417[s2] (reload)
  {spilled-scene/411[s13]* spilled-dir/412[s12]* spilled-bound/413[s11]
   spilled-dy/414[s10] spilled-g/415[s0] spilled-y/416[s9] spilled-dx/420[s6]
   spilled-x/421[s5] spilled-bound/422[s4] spilled-bound/426[s1]
   spilled-bound/432[s0]}
  R/0[%eax] := call "camlCode__intersect_1067" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
  match/263[%esi] := R/0[%eax]
  n/264[%ebx] := [match/263[%esi] + 4]
  temp/265[%eax] := "camlCode"
  b/266[%eax] := [temp/265[%eax] + 44]
  R/7[%tos] := float64u[n/264[%ebx]]
  temp/268[s2] := R/7[%tos]
  R/7[%tos] := float64u[b/266[%eax]]
  temp/270[s1] := R/7[%tos]
  R/7[%tos] := temp/268[s2] *f temp/270[s1]
  temp/272[s3] := R/7[%tos]
  R/7[%tos] := float64u[n/264[%ebx] + 8]
  temp/274[s2] := R/7[%tos]
  R/7[%tos] := float64u[b/266[%eax] + 8]
  temp/276[s1] := R/7[%tos]
  R/7[%tos] := temp/274[s2] *f temp/276[s1]
  temp/278[s1] := R/7[%tos]
  R/7[%tos] := temp/272[s3] +f temp/278[s1]
  temp/280[s3] := R/7[%tos]
  R/7[%tos] := float64u[n/264[%ebx] + 16]
  temp/282[s2] := R/7[%tos]
  R/7[%tos] := float64u[b/266[%eax] + 16]
  temp/284[s1] := R/7[%tos]
  R/7[%tos] := temp/282[s2] *f temp/284[s1]
  temp/286[s1] := R/7[%tos]
  R/7[%tos] := temp/280[s3] +f temp/286[s1]
  g/288[s1] := R/7[%tos]
  R/7[%tos] := 0.
  temp/290[s2] := R/7[%tos]
  if not g/288[s1] <=f temp/290[s2] goto L242
  I/291[%eax] := 1
  goto L241
  L242 [2]:
  I/292[%eax] := 0
  L241 [3]:
  temp/293[%eax] := I/291[%eax]  * 2 + 1
  if temp/293[%eax] ==s 1 goto L240
  temp/294[%eax] := "camlCode__8"
  goto L236
  L240 [2]:
  temp/295[%eax] := "camlPervasives"
  temp/296[%eax] := [temp/295[%eax] + 56]
  pushfloat [temp/296[%eax]]
  {match/263[%esi]* n/264[%ebx]* spilled-g/410[s1] spilled-scene/411[s13]*
   spilled-dir/412[s12]* spilled-bound/413[s11] spilled-dy/414[s10]
   spilled-g/415[s0] spilled-y/416[s9] spilled-dx/420[s6] spilled-x/421[s5]
   spilled-bound/422[s4] spilled-bound/426[s1] spilled-bound/432[s0]}
  R/7[%tos] := extcall "sqrt" 
  offset stack -8
  s/297[s5] := R/7[%tos]
  R/7[%tos] := float64u[n/264[%ebx]]
  temp/299[s2] := R/7[%tos]
  R/7[%tos] := s/297[s5] *f temp/299[s2]
  temp/301[s4] := R/7[%tos]
  R/7[%tos] := float64u[n/264[%ebx] + 8]
  temp/303[s2] := R/7[%tos]
  R/7[%tos] := s/297[s5] *f temp/303[s2]
  temp/305[s3] := R/7[%tos]
  R/7[%tos] := float64u[n/264[%ebx] + 16]
  temp/307[s2] := R/7[%tos]
  R/7[%tos] := s/297[s5] *f temp/307[s2]
  temp/309[s2] := R/7[%tos]
  {match/263[%esi]* temp/301[s4] temp/305[s3] temp/309[s2] spilled-g/410[s1]
   spilled-scene/411[s13]* spilled-dir/412[s12]* spilled-bound/413[s11]
   spilled-dy/414[s10] spilled-g/415[s0] spilled-y/416[s9] spilled-dx/420[s6]
   spilled-x/421[s5] spilled-bound/422[s4] spilled-bound/426[s1]
   spilled-bound/432[s0]}
  b/310[%ecx] := alloc 96
  [b/310[%ecx] + -4] := 6398
  float64u[b/310[%ecx]] := temp/301[s4]
  float64u[b/310[%ecx] + 8] := temp/305[s3]
  float64u[b/310[%ecx] + 16] := temp/309[s2]
  s/311[%ebx] := [match/263[%esi]]
  dir/445[%eax] := spilled-dir/412[s12] (reload)
  R/7[%tos] := float64u[dir/445[%eax]]
  temp/313[s2] := R/7[%tos]
  R/7[%tos] := temp/313[s2] *f float64[s/311[%ebx]]
  temp/315[s4] := R/7[%tos]
  R/7[%tos] := float64u[dir/445[%eax] + 8]
  temp/317[s2] := R/7[%tos]
  R/7[%tos] := temp/317[s2] *f float64[s/311[%ebx]]
  temp/319[s3] := R/7[%tos]
  R/7[%tos] := float64u[dir/445[%eax] + 16]
  temp/321[s2] := R/7[%tos]
  R/7[%tos] := temp/321[s2] *f float64[s/311[%ebx]]
  temp/323[s2] := R/7[%tos]
  a/324[%eax] := b/310[%ecx] + 28
  [a/324[%eax] + -4] := 6398
  float64u[a/324[%eax]] := temp/315[s4]
  float64u[a/324[%eax] + 8] := temp/319[s3]
  float64u[a/324[%eax] + 16] := temp/323[s2]
  R/7[%tos] := float64u[a/324[%eax]]
  temp/326[s3] := R/7[%tos]
  R/7[%tos] := float64u[b/310[%ecx]]
  temp/328[s2] := R/7[%tos]
  R/7[%tos] := temp/326[s3] +f temp/328[s2]
  temp/330[s5] := R/7[%tos]
  R/7[%tos] := float64u[a/324[%eax] + 8]
  temp/332[s3] := R/7[%tos]
  R/7[%tos] := float64u[b/310[%ecx] + 8]
  temp/334[s2] := R/7[%tos]
  R/7[%tos] := temp/332[s3] +f temp/334[s2]
  temp/336[s4] := R/7[%tos]
  R/7[%tos] := float64u[a/324[%eax] + 16]
  temp/338[s3] := R/7[%tos]
  R/7[%tos] := float64u[b/310[%ecx] + 16]
  temp/340[s2] := R/7[%tos]
  R/7[%tos] := temp/338[s3] +f temp/340[s2]
  temp/342[s2] := R/7[%tos]
  p/343[%eax] := b/310[%ecx] + 56
  [p/343[%eax] + -4] := 6398
  float64u[p/343[%eax]] := temp/330[s5]
  float64u[p/343[%eax] + 8] := temp/336[s4]
  float64u[p/343[%eax] + 16] := temp/342[s2]
  temp/344[%ebx] := "camlCode"
  temp/345[%ebx] := [temp/344[%ebx] + 44]
  temp/346[%edx] := "camlPervasives"
  temp/347[%esi] := [temp/346[%edx] + 36]
  temp/348[%edx] := "camlCode"
  temp/349[%edx] := [temp/348[%edx] + 4]
  temp/350[%ecx] := b/310[%ecx] + 84
  [temp/350[%ecx] + -4] := 2048
  [temp/350[%ecx]] := temp/347[%esi]
  [temp/350[%ecx] + 4] := temp/349[%edx]
  temp/351[%edx] := "camlCode"
  temp/352[%esi] := [temp/351[%edx] + 36]
  scene/446[%edx] := spilled-scene/411[s13] (reload)
  {spilled-g/410[s1] spilled-bound/413[s11] spilled-dy/414[s10]
   spilled-g/415[s0] spilled-y/416[s9] spilled-dx/420[s6] spilled-x/421[s5]
   spilled-bound/422[s4] spilled-bound/426[s1] spilled-bound/432[s0]}
  R/0[%eax] := call "camlCode__intersect_1067" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx] R/4[%esi]
  temp/354[%ebx] := [temp/353[%eax]]
  temp/355[%eax] := "camlPervasives"
  temp/356[%eax] := [temp/355[%eax] + 36]
  R/7[%tos] := float64u[temp/356[%eax]]
  R/7[%tos] := float64u[temp/354[%ebx]]
  if not R/7[%tos] <f R/7[%tos] goto L239
  I/359[%eax] := 1
  goto L238
  L239 [2]:
  I/360[%eax] := 0
  L238 [3]:
  temp/361[%eax] := I/359[%eax]  * 2 + 1
  if temp/361[%eax] ==s 1 goto L237
  A/362[%eax] := "camlCode__7"
  goto L236
  L237 [2]:
  {spilled-g/410[s1] spilled-bound/413[s11] spilled-dy/414[s10]
   spilled-g/415[s0] spilled-y/416[s9] spilled-dx/420[s6] spilled-x/421[s5]
   spilled-bound/422[s4] spilled-bound/426[s1] spilled-bound/432[s0]}
  A/363[%eax] := alloc 12
  [A/363[%eax] + -4] := 2301
  float64u[A/363[%eax]] := g/447[s1]
  L236 [4]:
  R/7[%tos] := g/147[s0] +f float64[temp/294[%eax]]
  temp/365[s0] := R/7[%tos]
  dy/154[%ebx] := spilled-dy/414[s10] (reload)
  dy/366[%ecx] := dy/154[%ebx]
  I/367[%ebx] := I/367[%ebx] + 2
  spilled-dy/414[s10] := dy/154[%ebx] (spill)
  bound/450[%eax] := spilled-bound/413[s11] (reload)
  if dy/366[%ecx] !=s bound/450[%eax] goto L235
  L234 [4]:
  dx/451[%eax] := spilled-dx/420[s6] (reload)
  dx/368[%ebx] := dx/451[%eax]
  I/369[%eax] := I/369[%eax] + 2
  spilled-dx/420[s6] := dx/451[%eax] (spill)
  bound/452[%eax] := spilled-bound/422[s4] (reload)
  if dx/368[%ebx] !=s bound/452[%eax] goto L233
  L232 [4]:
  R/7[%tos] := 0.5
  temp/371[s2] := R/7[%tos]
  R/7[%tos] := 255.
  temp/373[s1] := R/7[%tos]
  R/7[%tos] := temp/373[s1] *f g/147[s0]
  temp/375[s0] := R/7[%tos]
  temp/376[%ebx] := 33
  {temp/371[s2] temp/375[s0] temp/376[%ebx] spilled-y/416[s9]
   spilled-x/421[s5] spilled-bound/426[s1] spilled-bound/432[s0]}
  temp/377[%eax] := alloc 12
  [temp/377[%eax] + -4] := 2301
  I/378[%ebx] := I/378[%ebx] >>s 1
  R/7[%tos] := floatofint I/378[%ebx]
  float64u[temp/377[%eax]] := R/7[%tos]
  R/7[%tos] := temp/375[s0] /f float64[temp/377[%eax]]
  temp/381[s0] := R/7[%tos]
  R/7[%tos] := temp/371[s2] +f temp/381[s0]
  g/383[s0] := R/7[%tos]
  temp/384[%eax] := "camlPervasives"
  temp/385[%eax] := [temp/384[%eax] + 92]
  {spilled-y/416[s9] spilled-x/421[s5] spilled-bound/426[s1]
   spilled-g/427[s0] spilled-bound/432[s0]}
  R/0[%eax] := call "camlPrintf__fprintf_1392" R/0[%eax] {printf.ml:641,17-35}
  temp/386[%ebx] := R/0[%eax]
  temp/387[%eax] := "camlCode__6"
  A/388[%ecx] := [temp/386[%ebx]]
  {spilled-y/416[s9] spilled-x/421[s5] spilled-bound/426[s1]
   spilled-g/427[s0] spilled-bound/432[s0]}
  R/0[%eax] := call A/388[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  temp/389[%ebx] := R/0[%eax]
  I/390[%eax] := intoffloat g/453[s0]
  n/391[%ecx] := I/390[%eax]  * 2 + 1
  temp/392[%eax] := 1
  I/393[%eax] := n/391[%ecx] <s temp/392[%eax]
  temp/394[%eax] := I/393[%eax]  * 2 + 1
  if temp/394[%eax] ==s 1 goto L231
  temp/395[%eax] := 3
  goto L230
  L231 [2]:
  temp/396[%eax] := 511
  I/397[%eax] := n/391[%ecx] >s temp/396[%eax]
  I/398[%eax] := I/397[%eax]  * 2 + 1
  L230 [3]:
  if temp/395[%eax] ==s 1 goto L229
  temp/399[%ecx] := "caml_exn_Invalid_argument"
  temp/400[%ebx] := "camlPervasives__2"
  {temp/399[%ecx]* temp/400[%ebx]*}
  temp/401[%eax] := alloc 12
  [temp/401[%eax] + -4] := 2048
  [temp/401[%eax]] := temp/399[%ecx]
  [temp/401[%eax] + 4] := temp/400[%ebx]
  raise R/0[%eax] {pervasives.ml:155,27-52}
  L229 [2]:
  temp/402[%eax] := n/391[%ecx]
  A/403[%edx] := [temp/389[%ebx]]
  {spilled-y/416[s9] spilled-x/421[s5] spilled-bound/426[s1]
   spilled-bound/432[s0]}
  call A/403[%edx] R/0[%eax] R/1[%ebx]
  x/454[%eax] := spilled-x/421[s5] (reload)
  x/404[%ebx] := x/454[%eax]
  I/405[%eax] := I/405[%eax] + 2
  spilled-x/421[s5] := x/454[%eax] (spill)
  bound/455[%eax] := spilled-bound/426[s1] (reload)
  if x/404[%ebx] !=s bound/455[%eax] goto L228
  L227 [4]:
  y/456[%eax] := spilled-y/416[s9] (reload)
  y/406[%ebx] := y/456[%eax]
  I/407[%eax] := I/407[%eax] - 2
  spilled-y/416[s9] := y/456[%eax] (spill)
  bound/457[%eax] := spilled-bound/432[s0] (reload)
  if y/406[%ebx] !=s bound/457[%eax] goto L226
  L225 [4]:
  A/408[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
[times] Asmgen.compile_phrases: 0.768 s
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
camlCode__9:
	.long	caml_curry3
	.long	7
	.long	camlCode__create_1093
	.data
	.long	3319
camlCode__10:
	.long	caml_curry2
	.long	5
	.long	camlCode__ray_trace_1086
	.data
	.long	7415
camlCode__11:
	.long	caml_curry4
	.long	9
	.long	camlCode__intersect_1067
	.long	4345
	.long	caml_curry4
	.long	9
	.long	camlCode__intersects_1068
	.data
	.long	3319
camlCode__12:
	.long	caml_curry4
	.long	9
	.long	camlCode__ray_sphere_1056
	.data
	.long	2295
camlCode__13:
	.long	camlCode__unitise_1054
	.long	3
	.data
	.long	2295
camlCode__14:
	.long	camlCode__length_1052
	.long	3
	.data
	.long	3319
camlCode__15:
	.long	caml_curry2
	.long	5
	.long	camlCode__dot_1049
	.data
	.long	3319
camlCode__16:
	.long	caml_curry2
	.long	5
	.long	camlCode__$2d$7c_1046
	.data
	.long	3319
camlCode__17:
	.long	caml_curry2
	.long	5
	.long	camlCode__$2b$7c_1043
	.data
	.long	3319
camlCode__18:
	.long	caml_curry2
	.long	5
	.long	camlCode__$2a$7c_1040
	.data
	.globl	camlCode__1
	.long	6398
camlCode__1:
	.long	0x0, 0x0
	.long	0x0, 0x0
	.long	0x0, 0x0
	.data
	.globl	camlCode__2
	.long	6398
camlCode__2:
	.long	0x0, 0x3ff00000
	.long	0x0, 0x40080000
	.long	0x0, 0xc0000000
	.data
	.globl	camlCode__3
	.long	2048
camlCode__3:
	.long	13
	.long	1025
	.data
	.globl	camlCode__4
	.long	6398
camlCode__4:
	.long	0x0, 0x0
	.long	0x0, 0xbff00000
	.long	0x0, 0x40100000
	.data
	.globl	camlCode__5
	.long	4348
camlCode__5:
	.ascii	"P5\12%d %d\12\62\65\65\12"
	.space	2
	.byte	2
	.data
	.globl	camlCode__6
	.long	1276
camlCode__6:
	.ascii	"%c"
	.space	1
	.byte	1
	.data
	.long	2301
camlCode__7:
	.long	0x0, 0x0
	.data
	.long	2301
camlCode__8:
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
	.globl	camlCode__$2a$7c_1040
camlCode__$2a$7c_1040:
	subl	$24, %esp
.L100:
	fldl	(%ebx)
	fstpl	0(%esp)
	fldl	0(%esp)
	fmull	(%eax)
	fstpl	16(%esp)
	fldl	8(%ebx)
	fstpl	0(%esp)
	fldl	0(%esp)
	fmull	(%eax)
	fstpl	8(%esp)
	fldl	16(%ebx)
	fstpl	0(%esp)
	fldl	0(%esp)
	fmull	(%eax)
	fstpl	0(%esp)
.L101:	movl	caml_young_ptr, %eax
	subl	$28, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L102
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	16(%esp)
	fstpl	(%eax)
	fldl	8(%esp)
	fstpl	8(%eax)
	fldl	0(%esp)
	fstpl	16(%eax)
	addl	$24, %esp
	ret
.L102:	call	caml_call_gc
.L103:	jmp	.L101
	.type	camlCode__$2a$7c_1040,@function
	.size	camlCode__$2a$7c_1040,.-camlCode__$2a$7c_1040
	.text
	.align	16
	.globl	camlCode__$2b$7c_1043
camlCode__$2b$7c_1043:
	subl	$32, %esp
.L104:
	fldl	(%eax)
	fstpl	8(%esp)
	fldl	(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	faddl	0(%esp)
	fstpl	24(%esp)
	fldl	8(%eax)
	fstpl	8(%esp)
	fldl	8(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	faddl	0(%esp)
	fstpl	16(%esp)
	fldl	16(%eax)
	fstpl	8(%esp)
	fldl	16(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	faddl	0(%esp)
	fstpl	0(%esp)
.L105:	movl	caml_young_ptr, %eax
	subl	$28, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L106
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	24(%esp)
	fstpl	(%eax)
	fldl	16(%esp)
	fstpl	8(%eax)
	fldl	0(%esp)
	fstpl	16(%eax)
	addl	$32, %esp
	ret
.L106:	call	caml_call_gc
.L107:	jmp	.L105
	.type	camlCode__$2b$7c_1043,@function
	.size	camlCode__$2b$7c_1043,.-camlCode__$2b$7c_1043
	.text
	.align	16
	.globl	camlCode__$2d$7c_1046
camlCode__$2d$7c_1046:
	subl	$32, %esp
.L108:
	fldl	(%eax)
	fstpl	8(%esp)
	fldl	(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	fsubl	0(%esp)
	fstpl	24(%esp)
	fldl	8(%eax)
	fstpl	8(%esp)
	fldl	8(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	fsubl	0(%esp)
	fstpl	16(%esp)
	fldl	16(%eax)
	fstpl	8(%esp)
	fldl	16(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	fsubl	0(%esp)
	fstpl	0(%esp)
.L109:	movl	caml_young_ptr, %eax
	subl	$28, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L110
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	24(%esp)
	fstpl	(%eax)
	fldl	16(%esp)
	fstpl	8(%eax)
	fldl	0(%esp)
	fstpl	16(%eax)
	addl	$32, %esp
	ret
.L110:	call	caml_call_gc
.L111:	jmp	.L109
	.type	camlCode__$2d$7c_1046,@function
	.size	camlCode__$2d$7c_1046,.-camlCode__$2d$7c_1046
	.text
	.align	16
	.globl	camlCode__dot_1049
camlCode__dot_1049:
	subl	$24, %esp
.L112:
	fldl	(%eax)
	fstpl	8(%esp)
	fldl	(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	16(%esp)
	fldl	8(%eax)
	fstpl	8(%esp)
	fldl	8(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	0(%esp)
	fldl	16(%esp)
	faddl	0(%esp)
	fstpl	16(%esp)
	fldl	16(%eax)
	fstpl	8(%esp)
	fldl	16(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	0(%esp)
.L113:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L114
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	16(%esp)
	faddl	0(%esp)
	fstpl	(%eax)
	addl	$24, %esp
	ret
.L114:	call	caml_call_gc
.L115:	jmp	.L113
	.type	camlCode__dot_1049,@function
	.size	camlCode__dot_1049,.-camlCode__dot_1049
	.text
	.align	16
	.globl	camlCode__length_1052
camlCode__length_1052:
	subl	$24, %esp
.L116:
	fldl	(%eax)
	fstpl	8(%esp)
	fldl	(%eax)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	16(%esp)
	fldl	8(%eax)
	fstpl	8(%esp)
	fldl	8(%eax)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	0(%esp)
	fldl	16(%esp)
	faddl	0(%esp)
	fstpl	16(%esp)
	fldl	16(%eax)
	fstpl	8(%esp)
	fldl	16(%eax)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	0(%esp)
	fldl	16(%esp)
	faddl	0(%esp)
	fstpl	0(%esp)
	pushl	4(%esp)
	pushl	4(%esp)
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
	addl	$24, %esp
	ret
.L118:	call	caml_call_gc
.L119:	jmp	.L117
	.type	camlCode__length_1052,@function
	.size	camlCode__length_1052,.-camlCode__length_1052
	.text
	.align	16
	.globl	camlCode__unitise_1054
camlCode__unitise_1054:
	subl	$32, %esp
.L120:
	movl	%eax, %ebx
	fld1
	fstpl	24(%esp)
	fldl	(%ebx)
	fstpl	8(%esp)
	fldl	(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	16(%esp)
	fldl	8(%ebx)
	fstpl	8(%esp)
	fldl	8(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	0(%esp)
	fldl	16(%esp)
	faddl	0(%esp)
	fstpl	16(%esp)
	fldl	16(%ebx)
	fstpl	8(%esp)
	fldl	16(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	0(%esp)
	fldl	16(%esp)
	faddl	0(%esp)
	fstpl	0(%esp)
	pushl	4(%esp)
	pushl	4(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	0(%esp)
	fldl	24(%esp)
	fdivl	0(%esp)
	fstpl	24(%esp)
	fldl	(%ebx)
	fstpl	0(%esp)
	fldl	24(%esp)
	fmull	0(%esp)
	fstpl	16(%esp)
	fldl	8(%ebx)
	fstpl	0(%esp)
	fldl	24(%esp)
	fmull	0(%esp)
	fstpl	8(%esp)
	fldl	16(%ebx)
	fstpl	0(%esp)
	fldl	24(%esp)
	fmull	0(%esp)
	fstpl	0(%esp)
.L121:	movl	caml_young_ptr, %eax
	subl	$28, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L122
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	16(%esp)
	fstpl	(%eax)
	fldl	8(%esp)
	fstpl	8(%eax)
	fldl	0(%esp)
	fstpl	16(%eax)
	addl	$32, %esp
	ret
.L122:	call	caml_call_gc
.L123:	jmp	.L121
	.type	camlCode__unitise_1054,@function
	.size	camlCode__unitise_1054,.-camlCode__unitise_1054
	.text
	.align	16
	.globl	camlCode__ray_sphere_1056
camlCode__ray_sphere_1056:
	subl	$40, %esp
.L133:
	fldl	(%ecx)
	fstpl	8(%esp)
	fldl	(%eax)
	fstpl	0(%esp)
	fldl	8(%esp)
	fsubl	0(%esp)
	fstpl	24(%esp)
	fldl	8(%ecx)
	fstpl	8(%esp)
	fldl	8(%eax)
	fstpl	0(%esp)
	fldl	8(%esp)
	fsubl	0(%esp)
	fstpl	16(%esp)
	fldl	16(%ecx)
	fstpl	8(%esp)
	fldl	16(%eax)
	fstpl	0(%esp)
	fldl	8(%esp)
	fsubl	0(%esp)
	fstpl	0(%esp)
.L134:	movl	caml_young_ptr, %eax
	subl	$28, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L135
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	24(%esp)
	fstpl	(%eax)
	fldl	16(%esp)
	fstpl	8(%eax)
	fldl	0(%esp)
	fstpl	16(%eax)
	fldl	(%eax)
	fstpl	8(%esp)
	fldl	(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	16(%esp)
	fldl	8(%eax)
	fstpl	8(%esp)
	fldl	8(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	0(%esp)
	fldl	16(%esp)
	faddl	0(%esp)
	fstpl	16(%esp)
	fldl	16(%eax)
	fstpl	8(%esp)
	fldl	16(%ebx)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	0(%esp)
	fldl	16(%esp)
	faddl	0(%esp)
	fstpl	32(%esp)
	fldl	32(%esp)
	fmull	32(%esp)
	fstpl	24(%esp)
	fldl	(%eax)
	fstpl	8(%esp)
	fldl	(%eax)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	16(%esp)
	fldl	8(%eax)
	fstpl	8(%esp)
	fldl	8(%eax)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	0(%esp)
	fldl	16(%esp)
	faddl	0(%esp)
	fstpl	16(%esp)
	fldl	16(%eax)
	fstpl	8(%esp)
	fldl	16(%eax)
	fstpl	0(%esp)
	fldl	8(%esp)
	fmull	0(%esp)
	fstpl	0(%esp)
	fldl	16(%esp)
	faddl	0(%esp)
	fstpl	0(%esp)
	fldl	24(%esp)
	fsubl	0(%esp)
	fstpl	8(%esp)
	fldl	(%edx)
	fmull	(%edx)
	fstpl	0(%esp)
	fldl	8(%esp)
	faddl	0(%esp)
	fstpl	8(%esp)
	fldz
	fstpl	0(%esp)
	fldl	8(%esp)
	fcompl	0(%esp)
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L132
	movl	$1, %eax
	jmp	.L131
	.align	16
.L132:
	xorl	%eax, %eax
.L131:
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L130
	movl	$camlPervasives, %eax
	movl	36(%eax), %eax
	addl	$40, %esp
	ret
	.align	16
.L130:
	pushl	12(%esp)
	pushl	12(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	0(%esp)
	fldl	32(%esp)
	fsubl	0(%esp)
	fstpl	16(%esp)
	fldl	32(%esp)
	faddl	0(%esp)
	fstpl	8(%esp)
	fldz
	fstpl	0(%esp)
	fldl	8(%esp)
	fcompl	0(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L129
	movl	$1, %eax
	jmp	.L128
	.align	16
.L129:
	xorl	%eax, %eax
.L128:
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L124
	fldz
	fstpl	0(%esp)
	fldl	16(%esp)
	fcompl	0(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L127
	movl	$1, %eax
	jmp	.L126
	.align	16
.L127:
	xorl	%eax, %eax
.L126:
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L125
.L137:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L138
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	16(%esp)
	fstpl	(%eax)
	addl	$40, %esp
	ret
	.align	16
.L125:
.L140:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L141
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	8(%esp)
	fstpl	(%eax)
	addl	$40, %esp
	ret
	.align	16
.L124:
	movl	$camlPervasives, %eax
	movl	36(%eax), %eax
	addl	$40, %esp
	ret
.L141:	call	caml_call_gc
.L142:	jmp	.L140
.L138:	call	caml_call_gc
.L139:	jmp	.L137
.L135:	call	caml_call_gc
.L136:	jmp	.L134
	.type	camlCode__ray_sphere_1056,@function
	.size	camlCode__ray_sphere_1056,.-camlCode__ray_sphere_1056
	.text
	.align	16
	.globl	camlCode__intersects_1068
camlCode__intersects_1068:
	subl	$24, %esp
.L144:
	cmpl	$1, %edx
	je	.L143
	movl	%esi, 20(%esp)
	movl	%edx, 8(%esp)
	movl	%ecx, 0(%esp)
	movl	%ebx, 16(%esp)
	movl	%eax, 12(%esp)
	movl	(%edx), %ebx
	movl	%ebx, 4(%esp)
	addl	$-16, %esi
	movl	16(%esp), %ebx
	movl	0(%esp), %ecx
	movl	4(%esp), %edx
	call	camlCode__intersect_1067
.L145:
	movl	%eax, %ecx
	movl	8(%esp), %eax
	movl	4(%eax), %edx
	movl	12(%esp), %eax
	movl	16(%esp), %ebx
	movl	20(%esp), %esi
	jmp	.L144
	.align	16
.L143:
	movl	%ecx, %eax
	addl	$24, %esp
	ret
	.type	camlCode__intersects_1068,@function
	.size	camlCode__intersects_1068,.-camlCode__intersects_1068
	.text
	.align	16
	.globl	camlCode__intersect_1067
camlCode__intersect_1067:
	subl	$56, %esp
.L160:
	movl	%eax, %ebp
	movl	%ebx, 0(%esp)
	movl	%ecx, 4(%esp)
	movl	%esi, 8(%esp)
	movl	8(%edx), %eax
	movl	%eax, 12(%esp)
	movl	(%edx), %edi
	movl	4(%edx), %ecx
	fldl	(%edi)
	fstpl	24(%esp)
	fldl	(%ebp)
	fstpl	16(%esp)
	fldl	24(%esp)
	fsubl	16(%esp)
	fstpl	40(%esp)
	fldl	8(%edi)
	fstpl	24(%esp)
	fldl	8(%ebp)
	fstpl	16(%esp)
	fldl	24(%esp)
	fsubl	16(%esp)
	fstpl	32(%esp)
	fldl	16(%edi)
	fstpl	24(%esp)
	fldl	16(%ebp)
	fstpl	16(%esp)
	fldl	24(%esp)
	fsubl	16(%esp)
	fstpl	16(%esp)
.L161:	movl	caml_young_ptr, %eax
	subl	$28, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L162
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	40(%esp)
	fstpl	(%eax)
	fldl	32(%esp)
	fstpl	8(%eax)
	fldl	16(%esp)
	fstpl	16(%eax)
	fldl	(%eax)
	fstpl	24(%esp)
	movl	0(%esp), %ebx
	fldl	(%ebx)
	fstpl	16(%esp)
	fldl	24(%esp)
	fmull	16(%esp)
	fstpl	32(%esp)
	fldl	8(%eax)
	fstpl	24(%esp)
	fldl	8(%ebx)
	fstpl	16(%esp)
	fldl	24(%esp)
	fmull	16(%esp)
	fstpl	16(%esp)
	fldl	32(%esp)
	faddl	16(%esp)
	fstpl	32(%esp)
	fldl	16(%eax)
	fstpl	24(%esp)
	fldl	16(%ebx)
	fstpl	16(%esp)
	fldl	24(%esp)
	fmull	16(%esp)
	fstpl	16(%esp)
	fldl	32(%esp)
	faddl	16(%esp)
	fstpl	48(%esp)
	fldl	48(%esp)
	fmull	48(%esp)
	fstpl	40(%esp)
	fldl	(%eax)
	fstpl	24(%esp)
	fldl	(%eax)
	fstpl	16(%esp)
	fldl	24(%esp)
	fmull	16(%esp)
	fstpl	32(%esp)
	fldl	8(%eax)
	fstpl	24(%esp)
	fldl	8(%eax)
	fstpl	16(%esp)
	fldl	24(%esp)
	fmull	16(%esp)
	fstpl	16(%esp)
	fldl	32(%esp)
	faddl	16(%esp)
	fstpl	32(%esp)
	fldl	16(%eax)
	fstpl	24(%esp)
	fldl	16(%eax)
	fstpl	16(%esp)
	fldl	24(%esp)
	fmull	16(%esp)
	fstpl	16(%esp)
	fldl	32(%esp)
	faddl	16(%esp)
	fstpl	16(%esp)
	fldl	40(%esp)
	fsubl	16(%esp)
	fstpl	24(%esp)
	fldl	(%ecx)
	fmull	(%ecx)
	fstpl	16(%esp)
	fldl	24(%esp)
	faddl	16(%esp)
	fstpl	24(%esp)
	fldz
	fstpl	16(%esp)
	fldl	24(%esp)
	fcompl	16(%esp)
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L159
	movl	$1, %eax
	jmp	.L158
	.align	16
.L159:
	xorl	%eax, %eax
.L158:
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L157
	movl	$camlPervasives, %eax
	movl	36(%eax), %esi
	jmp	.L150
	.align	16
.L157:
	pushl	28(%esp)
	pushl	28(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	16(%esp)
	fldl	48(%esp)
	fsubl	16(%esp)
	fstpl	32(%esp)
	fldl	48(%esp)
	faddl	16(%esp)
	fstpl	24(%esp)
	fldz
	fstpl	16(%esp)
	fldl	24(%esp)
	fcompl	16(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L156
	movl	$1, %eax
	jmp	.L155
	.align	16
.L156:
	xorl	%eax, %eax
.L155:
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L151
	fldz
	fstpl	16(%esp)
	fldl	32(%esp)
	fcompl	16(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L154
	movl	$1, %eax
	jmp	.L153
	.align	16
.L154:
	xorl	%eax, %eax
.L153:
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L152
.L164:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L165
	leal	4(%eax), %esi
	movl	$2301, -4(%esi)
	fldl	32(%esp)
	fstpl	(%esi)
	jmp	.L150
	.align	16
.L152:
.L167:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L168
	leal	4(%eax), %esi
	movl	$2301, -4(%esi)
	fldl	24(%esp)
	fstpl	(%esi)
	jmp	.L150
	.align	16
.L151:
	movl	$camlPervasives, %eax
	movl	36(%eax), %esi
.L150:
	movl	4(%esp), %ecx
	movl	(%ecx), %eax
	fldl	(%eax)
	fldl	(%esi)
	fcompp
	fnstsw	%ax
	andb	$5, %ah
	jne	.L149
	movl	$1, %eax
	jmp	.L148
	.align	16
.L149:
	xorl	%eax, %eax
.L148:
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L147
	movl	%ecx, %eax
	addl	$56, %esp
	ret
	.align	16
.L147:
	cmpl	$1, 12(%esp)
	je	.L146
	movl	8(%esp), %esi
	addl	$16, %esi
	movl	%ebp, %eax
	movl	12(%esp), %edx
	addl	$56, %esp
	jmp	camlCode__intersects_1068
	.align	16
.L146:
	fldl	(%ebx)
	fstpl	16(%esp)
	fldl	16(%esp)
	fmull	(%esi)
	fstpl	32(%esp)
	fldl	8(%ebx)
	fstpl	16(%esp)
	fldl	16(%esp)
	fmull	(%esi)
	fstpl	24(%esp)
	fldl	16(%ebx)
	fstpl	16(%esp)
	fldl	16(%esp)
	fmull	(%esi)
	fstpl	16(%esp)
.L170:	movl	caml_young_ptr, %eax
	subl	$84, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L171
	leal	4(%eax), %ebx
	movl	$6398, -4(%ebx)
	fldl	32(%esp)
	fstpl	(%ebx)
	fldl	24(%esp)
	fstpl	8(%ebx)
	fldl	16(%esp)
	fstpl	16(%ebx)
	fldl	(%ebp)
	fstpl	24(%esp)
	fldl	(%ebx)
	fstpl	16(%esp)
	fldl	24(%esp)
	faddl	16(%esp)
	fstpl	40(%esp)
	fldl	8(%ebp)
	fstpl	24(%esp)
	fldl	8(%ebx)
	fstpl	16(%esp)
	fldl	24(%esp)
	faddl	16(%esp)
	fstpl	32(%esp)
	fldl	16(%ebp)
	fstpl	24(%esp)
	fldl	16(%ebx)
	fstpl	16(%esp)
	fldl	24(%esp)
	faddl	16(%esp)
	fstpl	16(%esp)
	leal	28(%ebx), %eax
	movl	$6398, -4(%eax)
	fldl	40(%esp)
	fstpl	(%eax)
	fldl	32(%esp)
	fstpl	8(%eax)
	fldl	16(%esp)
	fstpl	16(%eax)
	fldl	(%eax)
	fstpl	24(%esp)
	fldl	(%edi)
	fstpl	16(%esp)
	fldl	24(%esp)
	fsubl	16(%esp)
	fstpl	40(%esp)
	fldl	8(%eax)
	fstpl	24(%esp)
	fldl	8(%edi)
	fstpl	16(%esp)
	fldl	24(%esp)
	fsubl	16(%esp)
	fstpl	32(%esp)
	fldl	16(%eax)
	fstpl	24(%esp)
	fldl	16(%edi)
	fstpl	16(%esp)
	fldl	24(%esp)
	fsubl	16(%esp)
	fstpl	16(%esp)
	addl	$56, %ebx
	movl	$6398, -4(%ebx)
	fldl	40(%esp)
	fstpl	(%ebx)
	fldl	32(%esp)
	fstpl	8(%ebx)
	fldl	16(%esp)
	fstpl	16(%ebx)
	fld1
	fstpl	40(%esp)
	fldl	(%ebx)
	fstpl	24(%esp)
	fldl	(%ebx)
	fstpl	16(%esp)
	fldl	24(%esp)
	fmull	16(%esp)
	fstpl	32(%esp)
	fldl	8(%ebx)
	fstpl	24(%esp)
	fldl	8(%ebx)
	fstpl	16(%esp)
	fldl	24(%esp)
	fmull	16(%esp)
	fstpl	16(%esp)
	fldl	32(%esp)
	faddl	16(%esp)
	fstpl	32(%esp)
	fldl	16(%ebx)
	fstpl	24(%esp)
	fldl	16(%ebx)
	fstpl	16(%esp)
	fldl	24(%esp)
	fmull	16(%esp)
	fstpl	16(%esp)
	fldl	32(%esp)
	faddl	16(%esp)
	fstpl	16(%esp)
	pushl	20(%esp)
	pushl	20(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	16(%esp)
	fldl	40(%esp)
	fdivl	16(%esp)
	fstpl	40(%esp)
	fldl	(%ebx)
	fstpl	16(%esp)
	fldl	40(%esp)
	fmull	16(%esp)
	fstpl	32(%esp)
	fldl	8(%ebx)
	fstpl	16(%esp)
	fldl	40(%esp)
	fmull	16(%esp)
	fstpl	24(%esp)
	fldl	16(%ebx)
	fstpl	16(%esp)
	fldl	40(%esp)
	fmull	16(%esp)
	fstpl	16(%esp)
.L173:	movl	caml_young_ptr, %eax
	subl	$40, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L174
	leal	4(%eax), %ebx
	movl	$6398, -4(%ebx)
	fldl	32(%esp)
	fstpl	(%ebx)
	fldl	24(%esp)
	fstpl	8(%ebx)
	fldl	16(%esp)
	fstpl	16(%ebx)
	leal	28(%ebx), %eax
	movl	$2048, -4(%eax)
	movl	%esi, (%eax)
	movl	%ebx, 4(%eax)
	addl	$56, %esp
	ret
.L174:	call	caml_call_gc
.L175:	jmp	.L173
.L171:	call	caml_call_gc
.L172:	jmp	.L170
.L168:	call	caml_call_gc
.L169:	jmp	.L167
.L165:	call	caml_call_gc
.L166:	jmp	.L164
.L162:	call	caml_call_gc
.L163:	jmp	.L161
	.type	camlCode__intersect_1067,@function
	.size	camlCode__intersect_1067,.-camlCode__intersect_1067
	.text
	.align	16
	.globl	camlCode__ray_trace_1086
camlCode__ray_trace_1086:
	subl	$48, %esp
.L182:
	movl	%eax, %edi
	movl	%edi, 0(%esp)
	movl	%ebx, %edx
	movl	%edx, 4(%esp)
	movl	$camlCode, %eax
	movl	4(%eax), %ebp
	movl	$camlPervasives, %eax
	movl	36(%eax), %ebx
	movl	$camlCode, %eax
	movl	4(%eax), %esi
.L183:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L184
	leal	4(%eax), %ecx
	movl	$2048, -4(%ecx)
	movl	%ebx, (%ecx)
	movl	%esi, 4(%ecx)
	movl	$camlCode, %eax
	movl	36(%eax), %esi
	movl	%ebp, %eax
	movl	%edi, %ebx
	call	camlCode__intersect_1067
.L186:
	movl	%eax, %esi
	movl	4(%esi), %ebx
	movl	$camlCode, %eax
	movl	44(%eax), %eax
	fldl	(%ebx)
	fstpl	16(%esp)
	fldl	(%eax)
	fstpl	8(%esp)
	fldl	16(%esp)
	fmull	8(%esp)
	fstpl	24(%esp)
	fldl	8(%ebx)
	fstpl	16(%esp)
	fldl	8(%eax)
	fstpl	8(%esp)
	fldl	16(%esp)
	fmull	8(%esp)
	fstpl	8(%esp)
	fldl	24(%esp)
	faddl	8(%esp)
	fstpl	24(%esp)
	fldl	16(%ebx)
	fstpl	16(%esp)
	fldl	16(%eax)
	fstpl	8(%esp)
	fldl	16(%esp)
	fmull	8(%esp)
	fstpl	8(%esp)
	fldl	24(%esp)
	faddl	8(%esp)
	fstpl	8(%esp)
	fldz
	fstpl	16(%esp)
	fldl	8(%esp)
	fcompl	16(%esp)
	fnstsw	%ax
	andb	$69, %ah
	decb	%ah
	cmpb	$64, %ah
	jae	.L181
	movl	$1, %eax
	jmp	.L180
	.align	16
.L181:
	xorl	%eax, %eax
.L180:
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L179
	movl	$camlCode__20, %eax
	addl	$48, %esp
	ret
	.align	16
.L179:
	movl	$camlPervasives, %eax
	movl	56(%eax), %eax
	pushl	4(%eax)
	pushl	(%eax)
	call	sqrt
	addl	$8, %esp
	fstpl	40(%esp)
	fldl	(%ebx)
	fstpl	16(%esp)
	fldl	40(%esp)
	fmull	16(%esp)
	fstpl	32(%esp)
	fldl	8(%ebx)
	fstpl	16(%esp)
	fldl	40(%esp)
	fmull	16(%esp)
	fstpl	24(%esp)
	fldl	16(%ebx)
	fstpl	16(%esp)
	fldl	40(%esp)
	fmull	16(%esp)
	fstpl	16(%esp)
.L187:	movl	caml_young_ptr, %eax
	subl	$96, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L188
	leal	4(%eax), %ecx
	movl	$6398, -4(%ecx)
	fldl	32(%esp)
	fstpl	(%ecx)
	fldl	24(%esp)
	fstpl	8(%ecx)
	fldl	16(%esp)
	fstpl	16(%ecx)
	movl	(%esi), %ebx
	movl	0(%esp), %eax
	fldl	(%eax)
	fstpl	16(%esp)
	fldl	16(%esp)
	fmull	(%ebx)
	fstpl	32(%esp)
	fldl	8(%eax)
	fstpl	16(%esp)
	fldl	16(%esp)
	fmull	(%ebx)
	fstpl	24(%esp)
	fldl	16(%eax)
	fstpl	16(%esp)
	fldl	16(%esp)
	fmull	(%ebx)
	fstpl	16(%esp)
	leal	28(%ecx), %eax
	movl	$6398, -4(%eax)
	fldl	32(%esp)
	fstpl	(%eax)
	fldl	24(%esp)
	fstpl	8(%eax)
	fldl	16(%esp)
	fstpl	16(%eax)
	fldl	(%eax)
	fstpl	24(%esp)
	fldl	(%ecx)
	fstpl	16(%esp)
	fldl	24(%esp)
	faddl	16(%esp)
	fstpl	40(%esp)
	fldl	8(%eax)
	fstpl	24(%esp)
	fldl	8(%ecx)
	fstpl	16(%esp)
	fldl	24(%esp)
	faddl	16(%esp)
	fstpl	32(%esp)
	fldl	16(%eax)
	fstpl	24(%esp)
	fldl	16(%ecx)
	fstpl	16(%esp)
	fldl	24(%esp)
	faddl	16(%esp)
	fstpl	16(%esp)
	leal	56(%ecx), %eax
	movl	$6398, -4(%eax)
	fldl	40(%esp)
	fstpl	(%eax)
	fldl	32(%esp)
	fstpl	8(%eax)
	fldl	16(%esp)
	fstpl	16(%eax)
	movl	$camlCode, %ebx
	movl	44(%ebx), %ebx
	movl	$camlPervasives, %edx
	movl	36(%edx), %esi
	movl	$camlCode, %edx
	movl	4(%edx), %edx
	addl	$84, %ecx
	movl	$2048, -4(%ecx)
	movl	%esi, (%ecx)
	movl	%edx, 4(%ecx)
	movl	$camlCode, %edx
	movl	36(%edx), %esi
	movl	4(%esp), %edx
	call	camlCode__intersect_1067
.L190:
	movl	(%eax), %ebx
	movl	$camlPervasives, %eax
	movl	36(%eax), %eax
	fldl	(%eax)
	fldl	(%ebx)
	fcompp
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L178
	movl	$1, %eax
	jmp	.L177
	.align	16
.L178:
	xorl	%eax, %eax
.L177:
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L176
	movl	$camlCode__19, %eax
	addl	$48, %esp
	ret
	.align	16
.L176:
.L191:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L192
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	8(%esp)
	fstpl	(%eax)
	addl	$48, %esp
	ret
.L192:	call	caml_call_gc
.L193:	jmp	.L191
.L188:	call	caml_call_gc
.L189:	jmp	.L187
.L184:	call	caml_call_gc
.L185:	jmp	.L183
	.type	camlCode__ray_trace_1086,@function
	.size	camlCode__ray_trace_1086,.-camlCode__ray_trace_1086
	.text
	.align	16
	.globl	camlCode__create_1093
camlCode__create_1093:
	subl	$80, %esp
.L195:
	movl	%eax, %edi
	movl	%ecx, %esi
	movl	$1, %ebp
.L196:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L197
	leal	4(%eax), %ecx
	movl	$3072, -4(%ecx)
	movl	%ebx, (%ecx)
	movl	%esi, 4(%ecx)
	movl	%ebp, 8(%ecx)
	movl	$3, %eax
	cmpl	%eax, %edi
	sete	%al
	movzbl	%al, %eax
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L194
	movl	%ecx, %eax
	addl	$80, %esp
	ret
	.align	16
.L194:
	movl	%ecx, 24(%esp)
	movl	%edx, 8(%esp)
	movl	%esi, 4(%esp)
	movl	%ebx, 28(%esp)
	movl	%edi, 0(%esp)
	fldl	.L199
	fstpl	32(%esp)
	fldl	32(%esp)
	fmull	(%esi)
	fstpl	40(%esp)
	fldl	.L200
	fstpl	32(%esp)
	pushl	36(%esp)
	pushl	36(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	32(%esp)
	fldl	40(%esp)
	fdivl	32(%esp)
	fstpl	32(%esp)
	fldl	.L201
	fstpl	40(%esp)
	fldl	40(%esp)
	fmull	(%esi)
	fstpl	40(%esp)
	fldl	32(%esp)
	fchs
	fstpl	56(%esp)
	fldl	32(%esp)
	fchs
	fstpl	48(%esp)
	movl	$3, %eax
	subl	%eax, %edi
	incl	%edi
.L202:	movl	caml_young_ptr, %eax
	subl	$68, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L203
	leal	4(%eax), %eax
	movl	$6398, -4(%eax)
	fldl	48(%esp)
	fstpl	(%eax)
	fldl	32(%esp)
	fstpl	8(%eax)
	fldl	56(%esp)
	fstpl	16(%eax)
	fldl	(%ebx)
	fstpl	56(%esp)
	fldl	(%eax)
	fstpl	48(%esp)
	fldl	56(%esp)
	faddl	48(%esp)
	fstpl	72(%esp)
	fldl	8(%ebx)
	fstpl	56(%esp)
	fldl	8(%eax)
	fstpl	48(%esp)
	fldl	56(%esp)
	faddl	48(%esp)
	fstpl	64(%esp)
	fldl	16(%ebx)
	fstpl	56(%esp)
	fldl	16(%eax)
	fstpl	48(%esp)
	fldl	56(%esp)
	faddl	48(%esp)
	fstpl	48(%esp)
	leal	28(%eax), %ebx
	movl	$6398, -4(%ebx)
	fldl	72(%esp)
	fstpl	(%ebx)
	fldl	64(%esp)
	fstpl	8(%ebx)
	fldl	48(%esp)
	fstpl	16(%ebx)
	fldl	.L205
	fstpl	48(%esp)
	fldl	48(%esp)
	fmull	(%esi)
	fstpl	48(%esp)
	leal	56(%eax), %ecx
	movl	$2301, -4(%ecx)
	fldl	48(%esp)
	fstpl	(%ecx)
	movl	%edi, %eax
	movl	8(%esp), %edx
	call	camlCode__create_1093
.L206:
	movl	%eax, 20(%esp)
	fldl	32(%esp)
	fchs
	fstpl	48(%esp)
	movl	$3, %eax
	movl	0(%esp), %ebx
	subl	%eax, %ebx
	movl	%ebx, %edx
	incl	%edx
.L207:	movl	caml_young_ptr, %eax
	subl	$68, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L208
	leal	4(%eax), %ecx
	movl	$6398, -4(%ecx)
	fldl	32(%esp)
	fstpl	(%ecx)
	fldl	32(%esp)
	fstpl	8(%ecx)
	fldl	48(%esp)
	fstpl	16(%ecx)
	movl	28(%esp), %eax
	fldl	(%eax)
	fstpl	56(%esp)
	fldl	(%ecx)
	fstpl	48(%esp)
	fldl	56(%esp)
	faddl	48(%esp)
	fstpl	72(%esp)
	fldl	8(%eax)
	fstpl	56(%esp)
	fldl	8(%ecx)
	fstpl	48(%esp)
	fldl	56(%esp)
	faddl	48(%esp)
	fstpl	64(%esp)
	fldl	16(%eax)
	fstpl	56(%esp)
	fldl	16(%ecx)
	fstpl	48(%esp)
	fldl	56(%esp)
	faddl	48(%esp)
	fstpl	48(%esp)
	leal	28(%ecx), %ebx
	movl	$6398, -4(%ebx)
	fldl	72(%esp)
	fstpl	(%ebx)
	fldl	64(%esp)
	fstpl	8(%ebx)
	fldl	48(%esp)
	fstpl	16(%ebx)
	fldl	.L210
	fstpl	48(%esp)
	movl	4(%esp), %eax
	fldl	48(%esp)
	fmull	(%eax)
	fstpl	48(%esp)
	addl	$56, %ecx
	movl	$2301, -4(%ecx)
	fldl	48(%esp)
	fstpl	(%ecx)
	movl	%edx, %eax
	movl	8(%esp), %edx
	call	camlCode__create_1093
.L211:
	movl	%eax, 16(%esp)
	fldl	32(%esp)
	fchs
	fstpl	48(%esp)
	movl	$3, %eax
	movl	0(%esp), %ebx
	subl	%eax, %ebx
	movl	%ebx, %edx
	incl	%edx
.L212:	movl	caml_young_ptr, %eax
	subl	$68, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L213
	leal	4(%eax), %ecx
	movl	$6398, -4(%ecx)
	fldl	48(%esp)
	fstpl	(%ecx)
	fldl	32(%esp)
	fstpl	8(%ecx)
	fldl	32(%esp)
	fstpl	16(%ecx)
	movl	28(%esp), %eax
	fldl	(%eax)
	fstpl	56(%esp)
	fldl	(%ecx)
	fstpl	48(%esp)
	fldl	56(%esp)
	faddl	48(%esp)
	fstpl	72(%esp)
	fldl	8(%eax)
	fstpl	56(%esp)
	fldl	8(%ecx)
	fstpl	48(%esp)
	fldl	56(%esp)
	faddl	48(%esp)
	fstpl	64(%esp)
	fldl	16(%eax)
	fstpl	56(%esp)
	fldl	16(%ecx)
	fstpl	48(%esp)
	fldl	56(%esp)
	faddl	48(%esp)
	fstpl	48(%esp)
	leal	28(%ecx), %ebx
	movl	$6398, -4(%ebx)
	fldl	72(%esp)
	fstpl	(%ebx)
	fldl	64(%esp)
	fstpl	8(%ebx)
	fldl	48(%esp)
	fstpl	16(%ebx)
	fldl	.L215
	fstpl	48(%esp)
	movl	4(%esp), %eax
	fldl	48(%esp)
	fmull	(%eax)
	fstpl	48(%esp)
	addl	$56, %ecx
	movl	$2301, -4(%ecx)
	fldl	48(%esp)
	fstpl	(%ecx)
	movl	%edx, %eax
	movl	8(%esp), %edx
	call	camlCode__create_1093
.L216:
	movl	%eax, 12(%esp)
	movl	$3, %eax
	movl	0(%esp), %ebx
	subl	%eax, %ebx
	movl	%ebx, %edx
	incl	%edx
.L217:	movl	caml_young_ptr, %eax
	subl	$68, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L218
	leal	4(%eax), %ecx
	movl	$6398, -4(%ecx)
	fldl	32(%esp)
	fstpl	(%ecx)
	fldl	32(%esp)
	fstpl	8(%ecx)
	fldl	32(%esp)
	fstpl	16(%ecx)
	movl	28(%esp), %eax
	fldl	(%eax)
	fstpl	48(%esp)
	fldl	(%ecx)
	fstpl	32(%esp)
	fldl	48(%esp)
	faddl	32(%esp)
	fstpl	64(%esp)
	fldl	8(%eax)
	fstpl	48(%esp)
	fldl	8(%ecx)
	fstpl	32(%esp)
	fldl	48(%esp)
	faddl	32(%esp)
	fstpl	56(%esp)
	fldl	16(%eax)
	fstpl	48(%esp)
	fldl	16(%ecx)
	fstpl	32(%esp)
	fldl	48(%esp)
	faddl	32(%esp)
	fstpl	32(%esp)
	leal	28(%ecx), %ebx
	movl	$6398, -4(%ebx)
	fldl	64(%esp)
	fstpl	(%ebx)
	fldl	56(%esp)
	fstpl	8(%ebx)
	fldl	32(%esp)
	fstpl	16(%ebx)
	fldl	.L220
	fstpl	32(%esp)
	movl	4(%esp), %eax
	fldl	32(%esp)
	fmull	(%eax)
	fstpl	32(%esp)
	addl	$56, %ecx
	movl	$2301, -4(%ecx)
	fldl	32(%esp)
	fstpl	(%ecx)
	movl	%edx, %eax
	movl	8(%esp), %edx
	call	camlCode__create_1093
.L221:
	movl	%eax, %ecx
	movl	$1, %ebx
.L222:	movl	caml_young_ptr, %eax
	subl	$88, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L223
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	%ecx, (%eax)
	movl	%ebx, 4(%eax)
	leal	12(%eax), %ecx
	movl	$2048, -4(%ecx)
	movl	12(%esp), %ebx
	movl	%ebx, (%ecx)
	movl	%eax, 4(%ecx)
	leal	24(%eax), %edx
	movl	$2048, -4(%edx)
	movl	16(%esp), %ebx
	movl	%ebx, (%edx)
	movl	%ecx, 4(%edx)
	leal	36(%eax), %ecx
	movl	$2048, -4(%ecx)
	movl	20(%esp), %ebx
	movl	%ebx, (%ecx)
	movl	%edx, 4(%ecx)
	leal	48(%eax), %edx
	movl	$2048, -4(%edx)
	movl	24(%esp), %ebx
	movl	%ebx, (%edx)
	movl	%ecx, 4(%edx)
	leal	60(%eax), %ecx
	movl	$2301, -4(%ecx)
	fldl	40(%esp)
	fstpl	(%ecx)
	addl	$72, %eax
	movl	$3072, -4(%eax)
	movl	28(%esp), %ebx
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	movl	%edx, 8(%eax)
	addl	$80, %esp
	ret
.L223:	call	caml_call_gc
.L224:	jmp	.L222
.L218:	call	caml_call_gc
.L219:	jmp	.L217
.L213:	call	caml_call_gc
.L214:	jmp	.L212
.L208:	call	caml_call_gc
.L209:	jmp	.L207
.L203:	call	caml_call_gc
.L204:	jmp	.L202
.L197:	call	caml_call_gc
.L198:	jmp	.L196
	.data
.L220:	.long	0x0, 0x3fe00000
	.data
.L215:	.long	0x0, 0x3fe00000
	.data
.L210:	.long	0x0, 0x3fe00000
	.data
.L205:	.long	0x0, 0x3fe00000
	.data
.L201:	.long	0x0, 0x40080000
	.data
.L200:	.long	0x0, 0x40280000
	.data
.L199:	.long	0x0, 0x40080000
	.type	camlCode__create_1093,@function
	.size	camlCode__create_1093,.-camlCode__create_1093
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$104, %esp
.L245:
	movl	$camlPervasives, %eax
	movl	56(%eax), %eax
	pushl	4(%eax)
	pushl	(%eax)
	call	sqrt
	addl	$8, %esp
	fstpl	56(%esp)
	movl	$camlCode, %ebx
.L246:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L247
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	56(%esp)
	fstpl	(%eax)
	movl	%eax, (%ebx)
	movl	$camlCode__1, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 4(%eax)
	movl	$camlCode__18, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 8(%eax)
	movl	$camlCode__17, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 12(%eax)
	movl	$camlCode__16, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 16(%eax)
	movl	$camlCode__15, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 20(%eax)
	movl	$camlCode__14, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 24(%eax)
	movl	$camlCode__13, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 28(%eax)
	movl	$camlCode__12, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 32(%eax)
	movl	$camlCode__11, %eax
	movl	$camlCode, %ebx
	movl	%eax, 36(%ebx)
	movl	$camlCode, %ebx
	addl	$16, %eax
	movl	%eax, 40(%ebx)
	fld1
	fstpl	80(%esp)
	movl	$camlCode__2, %eax
	fldl	(%eax)
	fstpl	64(%esp)
	movl	$camlCode__2, %eax
	fldl	(%eax)
	fstpl	56(%esp)
	fldl	64(%esp)
	fmull	56(%esp)
	fstpl	72(%esp)
	movl	$camlCode__2, %eax
	fldl	8(%eax)
	fstpl	64(%esp)
	movl	$camlCode__2, %eax
	fldl	8(%eax)
	fstpl	56(%esp)
	fldl	64(%esp)
	fmull	56(%esp)
	fstpl	56(%esp)
	fldl	72(%esp)
	faddl	56(%esp)
	fstpl	72(%esp)
	movl	$camlCode__2, %eax
	fldl	16(%eax)
	fstpl	64(%esp)
	movl	$camlCode__2, %eax
	fldl	16(%eax)
	fstpl	56(%esp)
	fldl	64(%esp)
	fmull	56(%esp)
	fstpl	56(%esp)
	fldl	72(%esp)
	faddl	56(%esp)
	fstpl	56(%esp)
	pushl	60(%esp)
	pushl	60(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	56(%esp)
	fldl	80(%esp)
	fdivl	56(%esp)
	fstpl	80(%esp)
	movl	$camlCode__2, %eax
	fldl	(%eax)
	fstpl	56(%esp)
	fldl	80(%esp)
	fmull	56(%esp)
	fstpl	72(%esp)
	movl	$camlCode__2, %eax
	fldl	8(%eax)
	fstpl	56(%esp)
	fldl	80(%esp)
	fmull	56(%esp)
	fstpl	64(%esp)
	movl	$camlCode__2, %eax
	fldl	16(%eax)
	fstpl	56(%esp)
	fldl	80(%esp)
	fmull	56(%esp)
	fstpl	56(%esp)
.L249:	movl	caml_young_ptr, %eax
	subl	$28, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L250
	leal	4(%eax), %ebx
	movl	$6398, -4(%ebx)
	fldl	72(%esp)
	fstpl	(%ebx)
	fldl	64(%esp)
	fstpl	8(%ebx)
	fldl	56(%esp)
	fstpl	16(%ebx)
	movl	$camlCode, %eax
	movl	%ebx, 44(%eax)
	movl	$camlCode, %ebx
	movl	$9, %eax
	movl	%eax, 48(%ebx)
	movl	$camlCode__10, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 52(%eax)
	movl	$camlCode__9, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 56(%eax)
	call	.L244
	movl	$camlCode__3, %ecx
	jmp	.L243
	.align	16
.L244:
	pushl	caml_exception_pointer
	movl	%esp, caml_exception_pointer
	movl	$camlSys, %eax
	movl	(%eax), %ecx
	movl	$3, %ebx
	movl	-4(%ecx), %eax
	shrl	$9, %eax
	cmpl	%ebx, %eax
	jbe	.L252
	movl	-2(%ecx, %ebx, 2), %eax
	pushl	%eax
	movl	$caml_int_of_string, %eax
	call	caml_c_call
.L253:
	addl	$4, %esp
	movl	%eax, 8(%esp)
	movl	$camlSys, %eax
	movl	(%eax), %ecx
	movl	$5, %ebx
	movl	-4(%ecx), %eax
	shrl	$9, %eax
	cmpl	%ebx, %eax
	jbe	.L252
	movl	-2(%ecx, %ebx, 2), %eax
	pushl	%eax
	movl	$caml_int_of_string, %eax
	call	caml_c_call
.L254:
	addl	$4, %esp
	movl	%eax, %ebx
.L255:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L256
	leal	4(%eax), %ecx
	movl	$2048, -4(%ecx)
	movl	8(%esp), %eax
	movl	%eax, (%ecx)
	movl	%ebx, 4(%ecx)
	popl	caml_exception_pointer
	addl	$4, %esp
.L243:
	movl	$camlCode, %ebx
	movl	(%ecx), %eax
	movl	%eax, 60(%ebx)
	movl	$camlCode, %ebx
	movl	4(%ecx), %eax
	movl	%eax, 64(%ebx)
	movl	$camlCode, %eax
	movl	60(%eax), %esi
	movl	$camlCode__4, %ebx
	fld1
	fstpl	56(%esp)
	movl	$camlCode, %eax
	movl	56(%eax), %edx
.L258:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L259
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	fldl	56(%esp)
	fstpl	(%ecx)
	movl	%esi, %eax
	call	camlCode__create_1093
.L261:
	movl	$camlCode, %ebx
	movl	%eax, 68(%ebx)
	movl	$camlPervasives, %eax
	movl	92(%eax), %eax
	call	camlPrintf__fprintf_1392
.L262:
	movl	%eax, %ebx
	movl	$camlCode__5, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L263:
	movl	%eax, %ecx
	movl	$camlCode, %eax
	movl	64(%eax), %eax
	movl	$camlCode, %ebx
	movl	64(%ebx), %ebx
	call	caml_apply2
.L264:
	movl	$camlCode, %eax
	movl	64(%eax), %ebx
	movl	$3, %eax
	subl	%eax, %ebx
	incl	%ebx
	movl	$1, %eax
	cmpl	%eax, %ebx
	jl	.L225
	movl	%eax, 0(%esp)
	movl	%ebx, 36(%esp)
.L226:
	movl	$camlCode, %eax
	movl	64(%eax), %eax
	movl	$3, %ebx
	subl	%ebx, %eax
	incl	%eax
	movl	$1, %ebx
	movl	%ebx, 20(%esp)
	movl	%eax, 4(%esp)
	cmpl	%eax, %ebx
	jg	.L227
.L228:
	fldz
	fstpl	56(%esp)
	movl	$1, %ebx
	movl	$7, %eax
	movl	%ebx, 24(%esp)
	movl	%eax, 16(%esp)
	cmpl	%eax, %ebx
	jg	.L232
.L233:
	movl	$1, %ebx
	movl	$7, %eax
	movl	%ebx, 40(%esp)
	movl	%eax, 44(%esp)
	cmpl	%eax, %ebx
	jg	.L234
.L235:
	movl	20(%esp), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	80(%esp)
	movl	$camlCode, %eax
	movl	64(%eax), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	72(%esp)
	fldl	.L265
	fstpl	64(%esp)
	fldl	72(%esp)
	fdivl	64(%esp)
	fstpl	64(%esp)
	fldl	80(%esp)
	fsubl	64(%esp)
	fstpl	72(%esp)
	movl	24(%esp), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	64(%esp)
	movl	$9, %ecx
.L266:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L267
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	sarl	$1, %ecx
	pushl	%ecx
	fildl	(%esp)
	addl	$4, %esp
	fstpl	(%eax)
	fldl	64(%esp)
	fdivl	(%eax)
	fstpl	64(%esp)
	fldl	72(%esp)
	faddl	64(%esp)
	fstpl	88(%esp)
	movl	36(%esp), %ecx
	sarl	$1, %ecx
	pushl	%ecx
	fildl	(%esp)
	addl	$4, %esp
	fstpl	80(%esp)
	movl	$camlCode, %ecx
	movl	64(%ecx), %ecx
	sarl	$1, %ecx
	pushl	%ecx
	fildl	(%esp)
	addl	$4, %esp
	fstpl	72(%esp)
	fldl	.L269
	fstpl	64(%esp)
	fldl	72(%esp)
	fdivl	64(%esp)
	fstpl	64(%esp)
	fldl	80(%esp)
	fsubl	64(%esp)
	fstpl	72(%esp)
	sarl	$1, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	fstpl	64(%esp)
	movl	$9, %ebx
	leal	12(%eax), %ecx
	movl	$2301, -4(%ecx)
	sarl	$1, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	fstpl	(%ecx)
	fldl	64(%esp)
	fdivl	(%ecx)
	fstpl	64(%esp)
	fldl	72(%esp)
	faddl	64(%esp)
	fstpl	72(%esp)
	movl	$camlCode, %ebx
	movl	64(%ebx), %ebx
	sarl	$1, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	fstpl	64(%esp)
	addl	$24, %eax
	movl	%eax, 8(%esp)
	movl	$6398, -4(%eax)
	fldl	88(%esp)
	fstpl	(%eax)
	fldl	72(%esp)
	fstpl	8(%eax)
	fldl	64(%esp)
	fstpl	16(%eax)
	fld1
	fstpl	88(%esp)
	fldl	(%eax)
	fstpl	72(%esp)
	fldl	(%eax)
	fstpl	64(%esp)
	fldl	72(%esp)
	fmull	64(%esp)
	fstpl	80(%esp)
	fldl	8(%eax)
	fstpl	72(%esp)
	fldl	8(%eax)
	fstpl	64(%esp)
	fldl	72(%esp)
	fmull	64(%esp)
	fstpl	64(%esp)
	fldl	80(%esp)
	faddl	64(%esp)
	fstpl	80(%esp)
	fldl	16(%eax)
	fstpl	72(%esp)
	fldl	16(%eax)
	fstpl	64(%esp)
	fldl	72(%esp)
	fmull	64(%esp)
	fstpl	64(%esp)
	fldl	80(%esp)
	faddl	64(%esp)
	fstpl	64(%esp)
	pushl	68(%esp)
	pushl	68(%esp)
	call	sqrt
	addl	$8, %esp
	fstpl	64(%esp)
	fldl	88(%esp)
	fdivl	64(%esp)
	fstpl	88(%esp)
	movl	8(%esp), %eax
	fldl	(%eax)
	fstpl	64(%esp)
	fldl	88(%esp)
	fmull	64(%esp)
	fstpl	80(%esp)
	fldl	8(%eax)
	fstpl	64(%esp)
	fldl	88(%esp)
	fmull	64(%esp)
	fstpl	72(%esp)
	fldl	16(%eax)
	fstpl	64(%esp)
	fldl	88(%esp)
	fmull	64(%esp)
	fstpl	64(%esp)
.L270:	movl	caml_young_ptr, %eax
	subl	$40, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L271
	leal	4(%eax), %eax
	movl	%eax, 48(%esp)
	movl	$6398, -4(%eax)
	fldl	80(%esp)
	fstpl	(%eax)
	fldl	72(%esp)
	fstpl	8(%eax)
	fldl	64(%esp)
	fstpl	16(%eax)
	movl	$camlCode, %ebx
	movl	68(%ebx), %ebx
	movl	%ebx, 52(%esp)
	movl	$camlCode, %ebx
	movl	4(%ebx), %ebx
	movl	%ebx, 12(%esp)
	movl	$camlPervasives, %ebx
	movl	36(%ebx), %ebx
	movl	%ebx, 28(%esp)
	movl	$camlCode, %ebx
	movl	4(%ebx), %ebx
	movl	%ebx, 8(%esp)
	leal	28(%eax), %ebx
	movl	%ebx, 32(%esp)
	movl	$2048, -4(%ebx)
	movl	28(%esp), %eax
	movl	%eax, (%ebx)
	movl	8(%esp), %eax
	movl	%eax, 4(%ebx)
	movl	$camlCode, %eax
	movl	36(%eax), %eax
	movl	%eax, 8(%esp)
	movl	12(%esp), %eax
	movl	48(%esp), %ebx
	movl	32(%esp), %ecx
	movl	52(%esp), %edx
	movl	8(%esp), %esi
	call	camlCode__intersect_1067
.L273:
	movl	%eax, %esi
	movl	4(%esi), %ebx
	movl	$camlCode, %eax
	movl	44(%eax), %eax
	fldl	(%ebx)
	fstpl	72(%esp)
	fldl	(%eax)
	fstpl	64(%esp)
	fldl	72(%esp)
	fmull	64(%esp)
	fstpl	80(%esp)
	fldl	8(%ebx)
	fstpl	72(%esp)
	fldl	8(%eax)
	fstpl	64(%esp)
	fldl	72(%esp)
	fmull	64(%esp)
	fstpl	64(%esp)
	fldl	80(%esp)
	faddl	64(%esp)
	fstpl	80(%esp)
	fldl	16(%ebx)
	fstpl	72(%esp)
	fldl	16(%eax)
	fstpl	64(%esp)
	fldl	72(%esp)
	fmull	64(%esp)
	fstpl	64(%esp)
	fldl	80(%esp)
	faddl	64(%esp)
	fstpl	64(%esp)
	fldz
	fstpl	72(%esp)
	fldl	64(%esp)
	fcompl	72(%esp)
	fnstsw	%ax
	andb	$69, %ah
	decb	%ah
	cmpb	$64, %ah
	jae	.L242
	movl	$1, %eax
	jmp	.L241
	.align	16
.L242:
	xorl	%eax, %eax
.L241:
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L240
	movl	$camlCode__8, %eax
	jmp	.L236
	.align	16
.L240:
	movl	$camlPervasives, %eax
	movl	56(%eax), %eax
	pushl	4(%eax)
	pushl	(%eax)
	call	sqrt
	addl	$8, %esp
	fstpl	96(%esp)
	fldl	(%ebx)
	fstpl	72(%esp)
	fldl	96(%esp)
	fmull	72(%esp)
	fstpl	88(%esp)
	fldl	8(%ebx)
	fstpl	72(%esp)
	fldl	96(%esp)
	fmull	72(%esp)
	fstpl	80(%esp)
	fldl	16(%ebx)
	fstpl	72(%esp)
	fldl	96(%esp)
	fmull	72(%esp)
	fstpl	72(%esp)
.L274:	movl	caml_young_ptr, %eax
	subl	$96, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L275
	leal	4(%eax), %ecx
	movl	$6398, -4(%ecx)
	fldl	88(%esp)
	fstpl	(%ecx)
	fldl	80(%esp)
	fstpl	8(%ecx)
	fldl	72(%esp)
	fstpl	16(%ecx)
	movl	(%esi), %ebx
	movl	48(%esp), %eax
	fldl	(%eax)
	fstpl	72(%esp)
	fldl	72(%esp)
	fmull	(%ebx)
	fstpl	88(%esp)
	fldl	8(%eax)
	fstpl	72(%esp)
	fldl	72(%esp)
	fmull	(%ebx)
	fstpl	80(%esp)
	fldl	16(%eax)
	fstpl	72(%esp)
	fldl	72(%esp)
	fmull	(%ebx)
	fstpl	72(%esp)
	leal	28(%ecx), %eax
	movl	$6398, -4(%eax)
	fldl	88(%esp)
	fstpl	(%eax)
	fldl	80(%esp)
	fstpl	8(%eax)
	fldl	72(%esp)
	fstpl	16(%eax)
	fldl	(%eax)
	fstpl	80(%esp)
	fldl	(%ecx)
	fstpl	72(%esp)
	fldl	80(%esp)
	faddl	72(%esp)
	fstpl	96(%esp)
	fldl	8(%eax)
	fstpl	80(%esp)
	fldl	8(%ecx)
	fstpl	72(%esp)
	fldl	80(%esp)
	faddl	72(%esp)
	fstpl	88(%esp)
	fldl	16(%eax)
	fstpl	80(%esp)
	fldl	16(%ecx)
	fstpl	72(%esp)
	fldl	80(%esp)
	faddl	72(%esp)
	fstpl	72(%esp)
	leal	56(%ecx), %eax
	movl	$6398, -4(%eax)
	fldl	96(%esp)
	fstpl	(%eax)
	fldl	88(%esp)
	fstpl	8(%eax)
	fldl	72(%esp)
	fstpl	16(%eax)
	movl	$camlCode, %ebx
	movl	44(%ebx), %ebx
	movl	$camlPervasives, %edx
	movl	36(%edx), %esi
	movl	$camlCode, %edx
	movl	4(%edx), %edx
	addl	$84, %ecx
	movl	$2048, -4(%ecx)
	movl	%esi, (%ecx)
	movl	%edx, 4(%ecx)
	movl	$camlCode, %edx
	movl	36(%edx), %esi
	movl	52(%esp), %edx
	call	camlCode__intersect_1067
.L277:
	movl	(%eax), %ebx
	movl	$camlPervasives, %eax
	movl	36(%eax), %eax
	fldl	(%eax)
	fldl	(%ebx)
	fcompp
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L239
	movl	$1, %eax
	jmp	.L238
	.align	16
.L239:
	xorl	%eax, %eax
.L238:
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L237
	movl	$camlCode__7, %eax
	jmp	.L236
	.align	16
.L237:
.L278:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L279
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	64(%esp)
	fstpl	(%eax)
.L236:
	fldl	56(%esp)
	faddl	(%eax)
	fstpl	56(%esp)
	movl	40(%esp), %ebx
	movl	%ebx, %ecx
	addl	$2, %ebx
	movl	%ebx, 40(%esp)
	movl	44(%esp), %eax
	cmpl	%eax, %ecx
	jne	.L235
.L234:
	movl	24(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 24(%esp)
	movl	16(%esp), %eax
	cmpl	%eax, %ebx
	jne	.L233
.L232:
	fldl	.L281
	fstpl	72(%esp)
	fldl	.L282
	fstpl	64(%esp)
	fldl	64(%esp)
	fmull	56(%esp)
	fstpl	56(%esp)
	movl	$33, %ebx
.L283:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L284
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	sarl	$1, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	fstpl	(%eax)
	fldl	56(%esp)
	fdivl	(%eax)
	fstpl	56(%esp)
	fldl	72(%esp)
	faddl	56(%esp)
	fstpl	56(%esp)
	movl	$camlPervasives, %eax
	movl	92(%eax), %eax
	call	camlPrintf__fprintf_1392
.L286:
	movl	%eax, %ebx
	movl	$camlCode__6, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L287:
	movl	%eax, %ebx
	fldl	56(%esp)
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
	lea	1(%eax, %eax), %ecx
	movl	$1, %eax
	cmpl	%eax, %ecx
	setl	%al
	movzbl	%al, %eax
	lea	1(%eax, %eax), %eax
	cmpl	$1, %eax
	je	.L231
	movl	$3, %eax
	jmp	.L230
	.align	16
.L231:
	movl	$511, %eax
	cmpl	%eax, %ecx
	setg	%al
	movzbl	%al, %eax
	lea	1(%eax, %eax), %eax
.L230:
	cmpl	$1, %eax
	je	.L229
	movl	$caml_exn_Invalid_argument, %ecx
	movl	$camlPervasives__2, %ebx
.L288:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L289
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	%ecx, (%eax)
	movl	%ebx, 4(%eax)
	movl	caml_exception_pointer, %esp
	popl    caml_exception_pointer
	ret
	.align	16
.L229:
	movl	%ecx, %eax
	movl	(%ebx), %edx
	call	*%edx
.L291:
	movl	20(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 20(%esp)
	movl	4(%esp), %eax
	cmpl	%eax, %ebx
	jne	.L228
.L227:
	movl	36(%esp), %eax
	movl	%eax, %ebx
	subl	$2, %eax
	movl	%eax, 36(%esp)
	movl	0(%esp), %eax
	cmpl	%eax, %ebx
	jne	.L226
.L225:
	movl	$1, %eax
	addl	$104, %esp
	ret
.L289:	call	caml_call_gc
.L290:	jmp	.L288
.L284:	call	caml_call_gc
.L285:	jmp	.L283
.L279:	call	caml_call_gc
.L280:	jmp	.L278
.L275:	call	caml_call_gc
.L276:	jmp	.L274
.L271:	call	caml_call_gc
.L272:	jmp	.L270
.L267:	call	caml_call_gc
.L268:	jmp	.L266
.L259:	call	caml_call_gc
.L260:	jmp	.L258
.L256:	call	caml_call_gc
.L257:	jmp	.L255
.L250:	call	caml_call_gc
.L251:	jmp	.L249
.L247:	call	caml_call_gc
.L248:	jmp	.L246
.L252:	call	caml_ml_array_bound_error
	.data
.L282:	.long	0x0, 0x406fe000
	.data
.L281:	.long	0x0, 0x3fe00000
	.data
.L269:	.long	0x0, 0x40000000
	.data
.L265:	.long	0x0, 0x40000000
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
	.long	51
	.long	.L291
	.word	108
	.word	0
	.align	4
	.long	.L290
	.word	108
	.word	2
	.word	3
	.word	5
	.align	4
	.long	.L287
	.word	109
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L286
	.word	109
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L285
	.word	108
	.word	0
	.align	4
	.long	.L280
	.word	108
	.word	0
	.align	4
	.long	.L277
	.word	108
	.word	0
	.align	4
	.long	.L276
	.word	108
	.word	3
	.word	48
	.word	52
	.word	9
	.align	4
	.long	.L273
	.word	108
	.word	2
	.word	48
	.word	52
	.align	4
	.long	.L272
	.word	108
	.word	0
	.align	4
	.long	.L268
	.word	108
	.word	0
	.align	4
	.long	.L264
	.word	108
	.word	0
	.align	4
	.long	.L263
	.word	109
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L262
	.word	109
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L261
	.word	108
	.word	0
	.align	4
	.long	.L260
	.word	108
	.word	3
	.word	7
	.word	3
	.word	9
	.align	4
	.long	.L257
	.word	116
	.word	2
	.word	8
	.word	3
	.align	4
	.long	.L254
	.word	120
	.word	1
	.word	12
	.align	4
	.long	.L253
	.word	120
	.word	0
	.align	4
	.long	.L251
	.word	108
	.word	0
	.align	4
	.long	.L248
	.word	108
	.word	1
	.word	3
	.align	4
	.long	.L224
	.word	84
	.word	7
	.word	12
	.word	16
	.word	20
	.word	24
	.word	28
	.word	3
	.word	5
	.align	4
	.long	.L221
	.word	84
	.word	5
	.word	12
	.word	16
	.word	20
	.word	24
	.word	28
	.align	4
	.long	.L219
	.word	84
	.word	7
	.word	4
	.word	8
	.word	12
	.word	16
	.word	20
	.word	24
	.word	28
	.align	4
	.long	.L216
	.word	84
	.word	7
	.word	0
	.word	4
	.word	8
	.word	16
	.word	20
	.word	24
	.word	28
	.align	4
	.long	.L214
	.word	84
	.word	7
	.word	0
	.word	4
	.word	8
	.word	16
	.word	20
	.word	24
	.word	28
	.align	4
	.long	.L211
	.word	84
	.word	6
	.word	0
	.word	4
	.word	8
	.word	20
	.word	24
	.word	28
	.align	4
	.long	.L209
	.word	84
	.word	6
	.word	0
	.word	4
	.word	8
	.word	20
	.word	24
	.word	28
	.align	4
	.long	.L206
	.word	84
	.word	5
	.word	0
	.word	4
	.word	8
	.word	24
	.word	28
	.align	4
	.long	.L204
	.word	84
	.word	7
	.word	0
	.word	4
	.word	8
	.word	24
	.word	28
	.word	9
	.word	3
	.align	4
	.long	.L198
	.word	84
	.word	5
	.word	13
	.word	7
	.word	9
	.word	3
	.word	11
	.align	4
	.long	.L193
	.word	52
	.word	0
	.align	4
	.long	.L190
	.word	52
	.word	0
	.align	4
	.long	.L189
	.word	52
	.word	3
	.word	0
	.word	4
	.word	9
	.align	4
	.long	.L186
	.word	52
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L185
	.word	52
	.word	7
	.word	0
	.word	4
	.word	9
	.word	3
	.word	13
	.word	7
	.word	11
	.align	4
	.long	.L175
	.word	60
	.word	1
	.word	9
	.align	4
	.long	.L172
	.word	60
	.word	3
	.word	9
	.word	11
	.word	13
	.align	4
	.long	.L169
	.word	60
	.word	6
	.word	3
	.word	4
	.word	8
	.word	11
	.word	12
	.word	13
	.align	4
	.long	.L166
	.word	60
	.word	6
	.word	3
	.word	4
	.word	8
	.word	11
	.word	12
	.word	13
	.align	4
	.long	.L163
	.word	60
	.word	7
	.word	0
	.word	4
	.word	8
	.word	5
	.word	11
	.word	12
	.word	13
	.align	4
	.long	.L145
	.word	28
	.word	4
	.word	8
	.word	12
	.word	16
	.word	20
	.align	4
	.long	.L142
	.word	44
	.word	0
	.align	4
	.long	.L139
	.word	44
	.word	0
	.align	4
	.long	.L136
	.word	44
	.word	2
	.word	7
	.word	3
	.align	4
	.long	.L123
	.word	36
	.word	0
	.align	4
	.long	.L119
	.word	28
	.word	0
	.align	4
	.long	.L115
	.word	28
	.word	0
	.align	4
	.long	.L111
	.word	36
	.word	0
	.align	4
	.long	.L107
	.word	36
	.word	0
	.align	4
	.long	.L103
	.word	28
	.word	0
	.align	4
.L200000:
	.ascii	"printf.ml\0"
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

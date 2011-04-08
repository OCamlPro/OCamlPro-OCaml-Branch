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
    (list/58
       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 [0: 7 [0: 8 [0: 9 0a]]]]]]]]])
    (setfield_imm 0 (global Code!) list/58))
  (letrec
    (map/59
       (function f/60 l/61
         (if l/61
           (let
             (tail/63 (field 1 l/61)
              x/62 (field 0 l/61)
              xx/64 (apply f/60 x/62))
             (makeblock 0 xx/64 (apply map/59 f/60 tail/63)))
           0a)))
    (setfield_imm 1 (global Code!) map/59))
  (let
    (sum0/65
       (apply (field 1 (global Code!))
         (function x/66
           (seq (apply (field 1 (global Printf!)) "x = %d\n" x/66)
             (apply (field 1 (global Printf!)) "x = %d\n" x/66)
             (apply (field 1 (global Printf!)) "x = %d\n" x/66)
             (apply (field 1 (global Printf!)) "x = %d\n" x/66)
             (apply (field 1 (global Printf!)) "x = %d\n" x/66)
             (apply (field 1 (global Printf!)) "x = %d\n" x/66) x/66))
         (field 0 (global Code!))))
    (setfield_imm 2 (global Code!) sum0/65))
  (let
    (sum1/67
       (catch (if (field 0 (global Code!)) (exit 4) 0a) with (4)
         (apply (field 1 (global Code!))
           (function x/68
             (seq (apply (field 1 (global Printf!)) "x = %d\n" x/68)
               (apply (field 1 (global Printf!)) "x = %d\n" x/68)
               (apply (field 1 (global Printf!)) "x = %d\n" x/68)
               (apply (field 1 (global Printf!)) "x = %d\n" x/68)
               (apply (field 1 (global Printf!)) "x = %d\n" x/68)
               (apply (field 1 (global Printf!)) "x = %d\n" x/68) x/68))
           (field 0 (global Code!)))))
    (setfield_imm 3 (global Code!) sum1/67))
  (let
    (sum2/69
       (apply (field 9 (global List!))
         (function x/70
           (seq (apply (field 1 (global Printf!)) "x = %d\n" x/70)
             (apply (field 1 (global Printf!)) "x = %d\n" x/70)
             (apply (field 1 (global Printf!)) "x = %d\n" x/70)
             (apply (field 1 (global Printf!)) "x = %d\n" x/70)
             (apply (field 1 (global Printf!)) "x = %d\n" x/70)
             (apply (field 1 (global Printf!)) "x = %d\n" x/70)))
         (field 0 (global Code!))))
    (setfield_imm 4 (global Code!) sum2/69))
  0a)
-dlambda
(seq
  (let
    (list/58
       [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 [0: 6 [0: 7 [0: 8 [0: 9 0a]]]]]]]]])
    (setfield_imm 0 (global Code!) list/58))
  (letrec
    (map/59
       (function f/60 l/61
         (if l/61
           (let (xx/64 (apply f/60 (field 0 l/61)))
             (makeblock 0 xx/64 (apply map/59 f/60 (field 1 l/61))))
           0a)))
    (setfield_imm 1 (global Code!) map/59))
  (let
    (sum0/65
       (apply (field 1 (global Code!))
         (function x/66
           (seq (apply (field 1 (global Printf!)) "x = %d\n" x/66)
             (apply (field 1 (global Printf!)) "x = %d\n" x/66)
             (apply (field 1 (global Printf!)) "x = %d\n" x/66)
             (apply (field 1 (global Printf!)) "x = %d\n" x/66)
             (apply (field 1 (global Printf!)) "x = %d\n" x/66)
             (apply (field 1 (global Printf!)) "x = %d\n" x/66) x/66))
         (field 0 (global Code!))))
    (setfield_imm 2 (global Code!) sum0/65))
  (let
    (sum1/67
       (if (field 0 (global Code!))
         (apply (field 1 (global Code!))
           (function x/68
             (seq (apply (field 1 (global Printf!)) "x = %d\n" x/68)
               (apply (field 1 (global Printf!)) "x = %d\n" x/68)
               (apply (field 1 (global Printf!)) "x = %d\n" x/68)
               (apply (field 1 (global Printf!)) "x = %d\n" x/68)
               (apply (field 1 (global Printf!)) "x = %d\n" x/68)
               (apply (field 1 (global Printf!)) "x = %d\n" x/68) x/68))
           (field 0 (global Code!)))
         0a))
    (setfield_imm 3 (global Code!) sum1/67))
  (let
    (sum2/69
       (apply (field 9 (global List!))
         (function x/70
           (seq (apply (field 1 (global Printf!)) "x = %d\n" x/70)
             (apply (field 1 (global Printf!)) "x = %d\n" x/70)
             (apply (field 1 (global Printf!)) "x = %d\n" x/70)
             (apply (field 1 (global Printf!)) "x = %d\n" x/70)
             (apply (field 1 (global Printf!)) "x = %d\n" x/70)
             (apply (field 1 (global Printf!)) "x = %d\n" x/70)))
         (field 0 (global Code!))))
    (setfield_imm 4 (global Code!) sum2/69))
  0a)

-dcmm
(data int 5120 global "camlCode" "camlCode": skip 20)
(data int 2295 "camlCode__1": addr "camlCode__fun_82" int 3)
(data int 2295 "camlCode__2": addr "camlCode__fun_80" int 3)
(data int 2295 "camlCode__3": addr "camlCode__fun_78" int 3)
(data
 int 3319
 "camlCode__4":
 addr "caml_curry2"
 int 5
 addr "camlCode__map_59")
(data
 int 2048
 "camlCode__5":
 int 3
 addr L24
 int 2048
 L24:
 int 5
 addr L25
 int 2048
 L25:
 int 7
 addr L26
 int 2048
 L26:
 int 9
 addr L27
 int 2048
 L27:
 int 11
 addr L28
 int 2048
 L28:
 int 13
 addr L29
 int 2048
 L29:
 int 15
 addr L30
 int 2048
 L30:
 int 17
 addr L31
 int 2048
 L31:
 int 19
 int 1)
(data int 2300 "camlCode__6": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__7": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__8": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__9": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__10": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__11": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__12": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__13": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__14": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__15": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__16": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__17": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__18": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__19": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__20": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__21": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__22": string "x = %d
" skip 0 byte 0)
(data int 2300 "camlCode__23": string "x = %d
" skip 0 byte 0)
(function camlCode__map_59 (f/60: addr l/61: addr)
 (if (!= l/61 1)
   (let xx/64 (app (load f/60) (load l/61) f/60 addr)
     (alloc 2048 xx/64 (app "camlCode__map_59" f/60 (load (+a l/61 4)) addr)))
   1a))

(function camlCode__fun_78 (x/66: addr)
 (let fun/101 (app "camlPrintf__printf_425" "camlCode__23" addr)
   (app (load fun/101) x/66 fun/101 unit))
 (let fun/100 (app "camlPrintf__printf_425" "camlCode__22" addr)
   (app (load fun/100) x/66 fun/100 unit))
 (let fun/99 (app "camlPrintf__printf_425" "camlCode__21" addr)
   (app (load fun/99) x/66 fun/99 unit))
 (let fun/98 (app "camlPrintf__printf_425" "camlCode__20" addr)
   (app (load fun/98) x/66 fun/98 unit))
 (let fun/97 (app "camlPrintf__printf_425" "camlCode__19" addr)
   (app (load fun/97) x/66 fun/97 unit))
 (let fun/96 (app "camlPrintf__printf_425" "camlCode__18" addr)
   (app (load fun/96) x/66 fun/96 unit))
 x/66)

(function camlCode__fun_80 (x/68: addr)
 (let fun/95 (app "camlPrintf__printf_425" "camlCode__17" addr)
   (app (load fun/95) x/68 fun/95 unit))
 (let fun/94 (app "camlPrintf__printf_425" "camlCode__16" addr)
   (app (load fun/94) x/68 fun/94 unit))
 (let fun/93 (app "camlPrintf__printf_425" "camlCode__15" addr)
   (app (load fun/93) x/68 fun/93 unit))
 (let fun/92 (app "camlPrintf__printf_425" "camlCode__14" addr)
   (app (load fun/92) x/68 fun/92 unit))
 (let fun/91 (app "camlPrintf__printf_425" "camlCode__13" addr)
   (app (load fun/91) x/68 fun/91 unit))
 (let fun/90 (app "camlPrintf__printf_425" "camlCode__12" addr)
   (app (load fun/90) x/68 fun/90 unit))
 x/68)

(function camlCode__fun_82 (x/70: addr)
 (let fun/89 (app "camlPrintf__printf_425" "camlCode__11" addr)
   (app (load fun/89) x/70 fun/89 unit))
 (let fun/88 (app "camlPrintf__printf_425" "camlCode__10" addr)
   (app (load fun/88) x/70 fun/88 unit))
 (let fun/87 (app "camlPrintf__printf_425" "camlCode__9" addr)
   (app (load fun/87) x/70 fun/87 unit))
 (let fun/86 (app "camlPrintf__printf_425" "camlCode__8" addr)
   (app (load fun/86) x/70 fun/86 unit))
 (let fun/85 (app "camlPrintf__printf_425" "camlCode__7" addr)
   (app (load fun/85) x/70 fun/85 unit))
 (let fun/84 (app "camlPrintf__printf_425" "camlCode__6" addr)
   (app (load fun/84) x/70 fun/84 addr)))

(function camlCode__entry ()
 (let list/58 "camlCode__5" (store "camlCode" list/58))
 (let clos/77 "camlCode__4" (store (+a "camlCode" 4) clos/77))
 (let sum0/65 (app "camlCode__map_59" "camlCode__3" (load "camlCode") addr)
   (store (+a "camlCode" 8) sum0/65))
 (let
   sum1/67
     (if (!= (load "camlCode") 1)
       (app "camlCode__map_59" "camlCode__2" (load "camlCode") addr) 1a)
   (store (+a "camlCode" 12) sum1/67))
 (let sum2/69 (app "camlList__iter_102" "camlCode__1" (load "camlCode") addr)
   (store (+a "camlCode" 16) sum2/69))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__map_59:
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
  R/0[%eax] := call "camlCode__map_59" R/0[%eax] R/1[%ebx]
  A/15[%ecx] := R/0[%eax]
  {A/15[%ecx]* spilled-xx/17[s2]*}
  A/16[%eax] := alloc 12
  [A/16[%eax] + -4] := 2048
  xx/22[%ebx] := spilled-xx/17[s2] (reload)
  [A/16[%eax]] := xx/22[%ebx]
  [A/16[%eax] + 4] := A/15[%ecx]
  reload retaddr
  return R/0[%eax]
  L100:
  A/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_78:
  spilled-x/27[s0] := x/8[%eax] (spill)
  A/9[%eax] := "camlCode__23"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/10[%ebx] := R/0[%eax]
  A/11[%ecx] := [fun/10[%ebx]]
  x/28[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/11[%ecx] R/0[%eax] R/1[%ebx]
  A/12[%eax] := "camlCode__22"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/13[%ebx] := R/0[%eax]
  A/14[%ecx] := [fun/13[%ebx]]
  x/29[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/14[%ecx] R/0[%eax] R/1[%ebx]
  A/15[%eax] := "camlCode__21"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/16[%ebx] := R/0[%eax]
  A/17[%ecx] := [fun/16[%ebx]]
  x/30[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/17[%ecx] R/0[%eax] R/1[%ebx]
  A/18[%eax] := "camlCode__20"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/19[%ebx] := R/0[%eax]
  A/20[%ecx] := [fun/19[%ebx]]
  x/31[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/20[%ecx] R/0[%eax] R/1[%ebx]
  A/21[%eax] := "camlCode__19"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/22[%ebx] := R/0[%eax]
  A/23[%ecx] := [fun/22[%ebx]]
  x/32[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/23[%ecx] R/0[%eax] R/1[%ebx]
  A/24[%eax] := "camlCode__18"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/25[%ebx] := R/0[%eax]
  A/26[%ecx] := [fun/25[%ebx]]
  x/33[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/26[%ecx] R/0[%eax] R/1[%ebx]
  x/34[%eax] := spilled-x/27[s0] (reload)
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_80:
  spilled-x/27[s0] := x/8[%eax] (spill)
  A/9[%eax] := "camlCode__17"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/10[%ebx] := R/0[%eax]
  A/11[%ecx] := [fun/10[%ebx]]
  x/28[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/11[%ecx] R/0[%eax] R/1[%ebx]
  A/12[%eax] := "camlCode__16"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/13[%ebx] := R/0[%eax]
  A/14[%ecx] := [fun/13[%ebx]]
  x/29[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/14[%ecx] R/0[%eax] R/1[%ebx]
  A/15[%eax] := "camlCode__15"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/16[%ebx] := R/0[%eax]
  A/17[%ecx] := [fun/16[%ebx]]
  x/30[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/17[%ecx] R/0[%eax] R/1[%ebx]
  A/18[%eax] := "camlCode__14"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/19[%ebx] := R/0[%eax]
  A/20[%ecx] := [fun/19[%ebx]]
  x/31[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/20[%ecx] R/0[%eax] R/1[%ebx]
  A/21[%eax] := "camlCode__13"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/22[%ebx] := R/0[%eax]
  A/23[%ecx] := [fun/22[%ebx]]
  x/32[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/23[%ecx] R/0[%eax] R/1[%ebx]
  A/24[%eax] := "camlCode__12"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/25[%ebx] := R/0[%eax]
  A/26[%ecx] := [fun/25[%ebx]]
  x/33[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/26[%ecx] R/0[%eax] R/1[%ebx]
  x/34[%eax] := spilled-x/27[s0] (reload)
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_82:
  spilled-x/27[s0] := x/8[%eax] (spill)
  A/9[%eax] := "camlCode__11"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/10[%ebx] := R/0[%eax]
  A/11[%ecx] := [fun/10[%ebx]]
  x/28[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/11[%ecx] R/0[%eax] R/1[%ebx]
  A/12[%eax] := "camlCode__10"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/13[%ebx] := R/0[%eax]
  A/14[%ecx] := [fun/13[%ebx]]
  x/29[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/14[%ecx] R/0[%eax] R/1[%ebx]
  A/15[%eax] := "camlCode__9"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/16[%ebx] := R/0[%eax]
  A/17[%ecx] := [fun/16[%ebx]]
  x/30[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/17[%ecx] R/0[%eax] R/1[%ebx]
  A/18[%eax] := "camlCode__8"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/19[%ebx] := R/0[%eax]
  A/20[%ecx] := [fun/19[%ebx]]
  x/31[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/20[%ecx] R/0[%eax] R/1[%ebx]
  A/21[%eax] := "camlCode__7"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/22[%ebx] := R/0[%eax]
  A/23[%ecx] := [fun/22[%ebx]]
  x/32[%eax] := spilled-x/27[s0] (reload)
  {spilled-x/27[s0]*}
  call A/23[%ecx] R/0[%eax] R/1[%ebx]
  A/24[%eax] := "camlCode__6"
  {spilled-x/27[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/25[%ebx] := R/0[%eax]
  A/26[%ecx] := [fun/25[%ebx]]
  x/33[%eax] := spilled-x/27[s0] (reload)
  tailcall A/26[%ecx] R/0[%eax] R/1[%ebx]
  
*** Linearized code
camlCode__entry:
  list/8[%eax] := "camlCode__5"
  ["camlCode"] := list/8[%eax]
  clos/9[%eax] := "camlCode__4"
  ["camlCode" + 4] := clos/9[%eax]
  A/10[%ebx] := ["camlCode"]
  A/11[%eax] := "camlCode__3"
  {}
  R/0[%eax] := call "camlCode__map_59" R/0[%eax] R/1[%ebx]
  ["camlCode" + 8] := sum0/12[%eax]
  A/13[%eax] := ["camlCode"]
  if A/13[%eax] ==s 1 goto L146
  A/14[%ebx] := ["camlCode"]
  A/15[%eax] := "camlCode__2"
  {}
  R/0[%eax] := call "camlCode__map_59" R/0[%eax] R/1[%ebx]
  goto L145
  L146:
  A/17[%eax] := 1
  L145:
  ["camlCode" + 12] := sum1/16[%eax]
  A/18[%ebx] := ["camlCode"]
  A/19[%eax] := "camlCode__1"
  {}
  R/0[%eax] := call "camlList__iter_102" R/0[%eax] R/1[%ebx]
  ["camlCode" + 16] := sum2/20[%eax]
  A/21[%eax] := 1
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
camlCode__1:
	.long	camlCode__fun_82
	.long	3
	.data
	.long	2295
camlCode__2:
	.long	camlCode__fun_80
	.long	3
	.data
	.long	2295
camlCode__3:
	.long	camlCode__fun_78
	.long	3
	.data
	.long	3319
camlCode__4:
	.long	caml_curry2
	.long	5
	.long	camlCode__map_59
	.data
	.long	2048
camlCode__5:
	.long	3
	.long	.L100024
	.long	2048
.L100024:
	.long	5
	.long	.L100025
	.long	2048
.L100025:
	.long	7
	.long	.L100026
	.long	2048
.L100026:
	.long	9
	.long	.L100027
	.long	2048
.L100027:
	.long	11
	.long	.L100028
	.long	2048
.L100028:
	.long	13
	.long	.L100029
	.long	2048
.L100029:
	.long	15
	.long	.L100030
	.long	2048
.L100030:
	.long	17
	.long	.L100031
	.long	2048
.L100031:
	.long	19
	.long	1
	.data
	.long	2300
camlCode__6:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__7:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__8:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__9:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__10:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__11:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__12:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__13:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__14:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__15:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__16:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__17:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__18:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__19:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__20:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__21:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__22:
	.ascii	"x = %d\12"
	.byte	0
	.data
	.long	2300
camlCode__23:
	.ascii	"x = %d\12"
	.byte	0
	.text
	.align	16
	.globl	camlCode__map_59
camlCode__map_59:
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
	call	camlCode__map_59
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
	.type	camlCode__map_59,@function
	.size	camlCode__map_59,.-camlCode__map_59
	.text
	.align	16
	.globl	camlCode__fun_78
camlCode__fun_78:
	subl	$4, %esp
.L107:
	movl	%eax, 0(%esp)
	movl	$camlCode__23, %eax
	call	camlPrintf__printf_425
.L108:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L109:
	movl	$camlCode__22, %eax
	call	camlPrintf__printf_425
.L110:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L111:
	movl	$camlCode__21, %eax
	call	camlPrintf__printf_425
.L112:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L113:
	movl	$camlCode__20, %eax
	call	camlPrintf__printf_425
.L114:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L115:
	movl	$camlCode__19, %eax
	call	camlPrintf__printf_425
.L116:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L117:
	movl	$camlCode__18, %eax
	call	camlPrintf__printf_425
.L118:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L119:
	movl	0(%esp), %eax
	addl	$4, %esp
	ret
	.type	camlCode__fun_78,@function
	.size	camlCode__fun_78,.-camlCode__fun_78
	.text
	.align	16
	.globl	camlCode__fun_80
camlCode__fun_80:
	subl	$4, %esp
.L120:
	movl	%eax, 0(%esp)
	movl	$camlCode__17, %eax
	call	camlPrintf__printf_425
.L121:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L122:
	movl	$camlCode__16, %eax
	call	camlPrintf__printf_425
.L123:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L124:
	movl	$camlCode__15, %eax
	call	camlPrintf__printf_425
.L125:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L126:
	movl	$camlCode__14, %eax
	call	camlPrintf__printf_425
.L127:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L128:
	movl	$camlCode__13, %eax
	call	camlPrintf__printf_425
.L129:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L130:
	movl	$camlCode__12, %eax
	call	camlPrintf__printf_425
.L131:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L132:
	movl	0(%esp), %eax
	addl	$4, %esp
	ret
	.type	camlCode__fun_80,@function
	.size	camlCode__fun_80,.-camlCode__fun_80
	.text
	.align	16
	.globl	camlCode__fun_82
camlCode__fun_82:
	subl	$4, %esp
.L133:
	movl	%eax, 0(%esp)
	movl	$camlCode__11, %eax
	call	camlPrintf__printf_425
.L134:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L135:
	movl	$camlCode__10, %eax
	call	camlPrintf__printf_425
.L136:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L137:
	movl	$camlCode__9, %eax
	call	camlPrintf__printf_425
.L138:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L139:
	movl	$camlCode__8, %eax
	call	camlPrintf__printf_425
.L140:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L141:
	movl	$camlCode__7, %eax
	call	camlPrintf__printf_425
.L142:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L143:
	movl	$camlCode__6, %eax
	call	camlPrintf__printf_425
.L144:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	addl	$4, %esp
	jmp	*%ecx
	.type	camlCode__fun_82,@function
	.size	camlCode__fun_82,.-camlCode__fun_82
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L147:
	movl	$camlCode__5, %eax
	movl	%eax, camlCode
	movl	$camlCode__4, %eax
	movl	%eax, camlCode + 4
	movl	camlCode, %ebx
	movl	$camlCode__3, %eax
	call	camlCode__map_59
.L148:
	movl	%eax, camlCode + 8
	movl	camlCode, %eax
	cmpl	$1, %eax
	je	.L146
	movl	camlCode, %ebx
	movl	$camlCode__2, %eax
	call	camlCode__map_59
.L149:
	jmp	.L145
.L146:
	movl	$1, %eax
.L145:
	movl	%eax, camlCode + 12
	movl	camlCode, %ebx
	movl	$camlCode__1, %eax
	call	camlList__iter_102
.L150:
	movl	%eax, camlCode + 16
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
	.long	41
	.long	.L150
	.word	4
	.word	0
	.align	4
	.long	.L149
	.word	4
	.word	0
	.align	4
	.long	.L148
	.word	4
	.word	0
	.align	4
	.long	.L144
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L143
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L142
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L141
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L140
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L139
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L138
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L137
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L136
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L135
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L134
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L132
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L131
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L130
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L129
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L128
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L127
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L126
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L125
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L124
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L123
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L122
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L121
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L119
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L118
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L117
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L116
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L115
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L114
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L113
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L112
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L111
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L110
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L109
	.word	8
	.word	1
	.word	0
	.align	4
	.long	.L108
	.word	8
	.word	1
	.word	0
	.align	4
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

	.section .note.GNU-stack,"",%progbits
*)

(* A closure is allocated for a function that does not need it,
   because closure allocation is done before inlining. However, the
   closure is unused afterwards, because the compiler detects that it
   is not used (actually, the closure variable does appear withing
   it). All calls are computed first as if the closure was not needed,
   and need to be recomputed if the closure is finally required.

   Notes:
   - if a function is erroneously written as recursive even if not, it cannot
   be inlined.
   - n+n is not optimized in 2*n
   - a closure is allocated for f and g, although they do not use the included
   value. On the contrary, f3 has a static closure, but not g, although they
   look similar.
   - in the assembly code, only one allocation is performed, containing the
   closures and the module.

*)

let f1 =
  let x = 1 in
  let rec f y = y + x in
  let g n = (f n) + (f n) in
    g

let f2 =
  let x = 1 in
  let f y = y + x in
  let g n = (f n) + (f n) in
    g

let f3 y = f2 (y+1)

(*
-dlambda:
(seq
  (let
    (f1/58
       (let (x/59 1)
         (letrec (f/60 (function y/61 (+ y/61 x/59)))
           (let
             (g/62 (function n/63 (+ (apply f/60 n/63) (apply f/60 n/63))))
             g/62))))
    (setfield_imm 0 (global Code!) f1/58))
  (let
    (f2/64
       (let
         (x/65 1
          f/66 (function y/67 (+ y/67 x/65))
          g/68 (function n/69 (+ (apply f/66 n/69) (apply f/66 n/69))))
         g/68))
    (setfield_imm 1 (global Code!) f2/64))
  (let (f3/70 (function y/71 (apply (field 1 (global Code!)) (+ y/71 1))))
    (setfield_imm 2 (global Code!) f3/70))
  0a)



-dclosure:
(seq
  (let
    (f1/58
       (let
         (clos/76 (closure (camlCode__f_60[1]( y/61) (+ y/61 1)) [
                                                                  1])
          g/78
            (closure (camlCode__g_62[1]( n/63)
                      (+ (camlCode__f_60  n/63) (camlCode__f_60  n/63))) [

             (offset[0] clos/76)]))
         g/78))
    (setfield_imm 0 (global camlCode!) f1/58))
  (let
    (f2/64
       (let
         (f/66 (closure (camlCode__f_66[1]( y/67) (+ y/67 1)) [
                                                               1])
          g/68
            (closure (camlCode__g_68[1]( n/69) (+ (+ n/69 1) (+ n/69 1))) [

             f/66]))
         g/68))
    (setfield_imm 1 (global camlCode!) f2/64))
  (let
    (f3/70
       (closure (camlCode__f3_70[1]( y/71)
                 (let (n/82 (+ y/71 1)) (+ (+ n/82 1) (+ n/82 1)))) [
        ]))
    (setfield_imm 2 (global camlCode!) f3/70))

-dcmm:
(data int 3072 global "camlCode" "camlCode": skip 24)
(data int 2295 "camlCode__1": addr "camlCode__f3_70" int 3)
(function camlCode__f_60 (y/61: addr) (+ y/61 2))

(function camlCode__g_62 (n/63: addr)
 (+ (+ (app "camlCode__f_60" n/63 addr) (app "camlCode__f_60" n/63 addr)) -1))

(function camlCode__f_66 (y/67: addr) (+ y/67 2))

(function camlCode__g_68 (n/69: addr) (+ (+ n/69 n/69) 3))

(function camlCode__f3_70 (y/71: addr)
 (let n/82 (+ y/71 2) (+ (+ n/82 n/82) 3)))

(function camlCode__entry ()
 (let
   f1/58
     (let
       (clos/76 (alloc 3319 "camlCode__f_60" 3 3)
        g/78 (alloc 3319 "camlCode__g_62" 3 clos/76))
       g/78)
   (store "camlCode" f1/58))
 (let
   f2/64
     (let
       (f/66 (alloc 3319 "camlCode__f_66" 3 3)
        g/68 (alloc 3319 "camlCode__g_68" 3 f/66))
       g/68)
   (store (+a "camlCode" 8) f2/64))
 (let f3/70 "camlCode__1" (store (+a "camlCode" 16) f3/70)) 1a)

(data)


*)

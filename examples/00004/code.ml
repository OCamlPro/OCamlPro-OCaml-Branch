(*
ocamlopt -c -drawlambda -dlambda -dclosure -dcmm code.ml
*)


let rec iter f = function
    [] -> ()
  | a::l -> f a; iter f l

let _ =
  iter (fun x -> print_int x) [0;1;2]

(*
-drawlambda:

(seq
  (letrec
    (iter/58
       (function f/59 param/64
         (if param/64
           (let (l/61 (field 1 param/64) a/60 (field 0 param/64))
             (seq (apply f/59 a/60) (apply iter/58 f/59 l/61)))
           0a)))
    (setfield_imm 0 (global Code!) iter/58))
  (apply (field 0 (global Code!))
    (function x/62 (apply (field 27 (global Pervasives!)) x/62))
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)

-dlambda:
(seq
  (letrec
    (iter/58
       (function f/59 param/64
         (if param/64
           (seq (apply f/59 (field 0 param/64))
             (apply iter/58 f/59 (field 1 param/64)))
           0a)))
    (setfield_imm 0 (global Code!) iter/58))
  (apply (field 0 (global Code!))
    (function x/62 (apply (field 27 (global Pervasives!)) x/62))
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)

-dclosure:
(seq
  (let
    (clos/66
       (closure (camlCode__iter_58(2)  f/59 param/64
                 (if param/64
                   (seq (apply f/59 (field 0 param/64))
                     (camlCode__iter_58  f/59 (field 1 param/64)))
                   0a)) ))
    (setfield_imm 0 (global camlCode!) (offset[0] clos/66)))
  (camlCode__iter_58
    (closure (camlCode__fun_67(1)  x/62
              (camlPervasives__output_string_215
                (field 23 (global camlPervasives!))
                (camlPervasives__string_of_int_154  x/62))) )
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)

-dcmm:
(data int 1024 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__fun_67" int 3)
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter_58")
(data
 int 2048
 "camlCode__2":
 int 1
 addr L4
 int 2048
 L4:
 int 3
 addr L5
 int 2048
 L5:
 int 5
 int 1)
(function camlCode__iter_58 (f/59: addr param/64: addr)
 (if (!= param/64 1)
   (seq (app (load f/59) (load param/64) f/59 unit)
     (app "camlCode__iter_58" f/59 (load (+a param/64 8)) addr))
   1a))

(function camlCode__fun_67 (x/62: addr)
 (app{pervasives.ml:356,18-56} "camlPervasives__output_string_215"
   (load (+a "camlPervasives" 184))
   (app{pervasives.ml:356,39-56} "camlPervasives__string_of_int_154" x/62
     addr)
   addr))

(function camlCode__entry ()
 (let clos/66 "camlCode__3" (store "camlCode" clos/66))
 (app "camlCode__iter_58" "camlCode__1" "camlCode__2" unit) 1a)

(data)
*)



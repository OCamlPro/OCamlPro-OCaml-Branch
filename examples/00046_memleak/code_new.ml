
let f g =
  let (x,y) = g () in
  ignore (x);
  (function () -> x)
(*
-drawlambda
(seq
  (let
    (f/1030
       (function g/1031
         (let
           (match/1036 (apply g/1031 0a)
            y/1033 (field 1 match/1036)
            x/1032 (field 0 match/1036))
           (seq (ignore x/1032) (function param/1035 x/1032)))))
    (setfield_imm 0 (global Code!) f/1030))
  0a)
-dlambda
(seq
  (let
    (f/1030
       (function g/1031
         (let (match/1036 (apply g/1031 0a) x/1032 (field 0 match/1036))
           (seq (ignore x/1032) (function param/1035 x/1032)))))
    (setfield_imm 0 (global Code!) f/1030))
  0a)
-dclosure
*** After closure conversion:
(seq
  (let
    (f/1030 {fun camlCode__f_1030 {1} closed -> fun camlCode__fun_1039 {1} inline -> ?} = 
       (closure (camlCode__f_1030(1)  g/1031
                  (let
                    (match/1036 {?} =  (apply g/1031 0a)
                     x/1032 {?} =  (field 0 match/1036))
                    (seq (ignore x/1032)
                      (closure (camlCode__fun_1039(1)  param/1035 env/1041
                                 (field 2 env/1041)) {0} 
                                                     x/1032)))) {0} ))
    (setfield_imm 0 (global camlCode!) f/1030))
  0a)

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__f_1030" int 3)
(function camlCode__fun_1039 (param/1035: addr env/1041: addr)
 (load (+a env/1041 16)))

(function camlCode__f_1030 (g/1031: addr)
 (let
   (match/1036 (app (load g/1031) 1a g/1031 addr) x/1032 (load match/1036))
   x/1032 [] (alloc 3319 "camlCode__fun_1039" 3 x/1032)))

(function camlCode__entry ()
 (let f/1030 "camlCode__1" (store "camlCode" f/1030)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__fun_1039:
  A/31[%rax] := [env/30[%rbx] + 16]
  return R/0[%rax]
  
*** Linearized code
camlCode__f_1030:
  g/29[%rbx] := R/0[%rax]
  A/30[%rax] := 1
  A/31[%rdi] := [g/29[%rbx]]
  {}
  R/0[%rax] := call A/31[%rdi] R/0[%rax] R/1[%rbx]
  x/33[%rdi] := [match/32[%rax]]
  {x/33[%rdi]*}
  A/34[%rax] := alloc 32
  [A/34[%rax] + -8] := 3319
  A/35[%rbx] := "camlCode__fun_1039"
  [A/34[%rax]] := A/35[%rbx]
  [A/34[%rax] + 8] := 3
  [A/34[%rax] + 16] := x/33[%rdi]
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  f/29[%rbx] := "camlCode__1"
  A/30[%rax] := "camlCode"
  [A/30[%rax]] := f/29[%rbx]
  A/31[%rax] := 1
  return R/0[%rax]
  
-dstartup

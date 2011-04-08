(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.
*)

(*

let rec iter1 f l =
  match l with
      [] -> ()
    | a::l -> f a; iter1 f l

let iter2 f l =
  let l = ref l in
    while
      match !l with
	  [] -> false
	| a :: lr ->
	    f a;
	    l := lr;
	    true
    do
      ()
    done
*)



let map1 =
  let z = List.map (fun x -> x + 1) [1;2;3] in
  let rec map1 f l =
    match l with
	[] -> z
      | a::l ->
	  let x = f a in
	    x :: (map1 f l)
  in
    map1

let list1 =
  map1 (fun x -> x+1) [1;2;3;4;5]


(*

  camlCode__iter1_58:
  subq    $24, %rsp
  .L101:
  movq    %rax, %rsi
  cmpq    $1, %rbx
  je      .L100
  movq    %rbx, 0(%rsp)
  movq    %rsi, 8(%rsp)
  movq    (%rbx), %rax
  movq    (%rsi), %rdi
  movq    %rsi, %rbx
  call    *%rdi
  movq    0(%rsp), %rax
  movq    8(%rax), %rbx
  movq    8(%rsp), %rax
  jmp     .L101
  .align  4
  .L100:
  movq    $1, %rax
  addq    $24, %rsp
  ret


  camlCode__iter2_63:
  subq    $24, %rsp
  movq    %rax, 0(%rsp)
  .L104:
  movq    %rbx, 8(%rsp)
  cmpq    $1, %rbx
  je      .L106
  movq    (%rbx), %rax
  movq    0(%rsp), %rbx
  movq    (%rbx), %rdi
  call    *%rdi
  movq    8(%rsp), %rax
  movq    8(%rax), %rbx
  movq    $3, %rax
  jmp     .L105
  .align  4
  .L106:
  movq    $1, %rax
  .L105:
  cmpq    $1, %rax
  jne     .L104
  movq    $1, %rax
  addq    $24, %rsp
  ret


  camlCode__iter1_58:
  subq    $24, %rsp
  .L101:
  movq    %rax, %rsi
  cmpq    $1, %rbx
  je      .L100
  movq    %rbx, 0(%rsp)
  movq    %rsi, 8(%rsp)
  movq    (%rbx), %rax
  movq    (%rsi), %rdi
  movq    %rsi, %rbx
  call    *%rdi
  movq    0(%rsp), %rax
  movq    8(%rax), %rbx
  movq    8(%rsp), %rax
  jmp     .L101
  .align  4
  .L100:
  movq    $1, %rax
  addq    $24, %rsp
  ret


  camlCode__iter2_63: (improved)
  subq    $24, %rsp
  movq    %rax, 0(%rsp)
  .L104:
  movq    %rbx, 8(%rsp)
  cmpq    $1, %rbx
  je      .L106
  movq    (%rbx), %rax
  movq    0(%rsp), %rbx
  movq    (%rbx), %rdi
  call    *%rdi
  movq    8(%rsp), %rax
  movq    8(%rax), %rbx
  jmp     .L104
  .align  4
  .L106:
  movq    $1, %rax
  addq    $24, %rsp
  ret

*)
(*
-drawlambda
(seq
  (let
    (map1/1030
       (let
         (z/1031
            (apply (field 11 (global List!)) (function x/1032 (+ x/1032 1))
              [0: 1 [0: 2 [0: 3 0a]]]))
         (letrec
           (map1/1033
              (function f/1034 l/1035
                (if l/1035
                  (let
                    (l/1037 (field 1 l/1035)
                     a/1036 (field 0 l/1035)
                     x/1038 (apply f/1034 a/1036))
                    (makeblock 0 x/1038 (apply map1/1033 f/1034 l/1037)))
                  z/1031)))
           map1/1033)))
    (setfield_imm 0 (global Code!) map1/1030))
  (let
    (list1/1039
       (apply (field 0 (global Code!)) (function x/1040 (+ x/1040 1))
         [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]))
    (setfield_imm 1 (global Code!) list1/1039))
  0a)
-dlambda
(seq
  (let
    (map1/1030
       (let
         (z/1031
            (apply (field 11 (global List!)) (function x/1032 (+ x/1032 1))
              [0: 1 [0: 2 [0: 3 0a]]]))
         (letrec
           (map1/1033
              (function f/1034 l/1035
                (if l/1035
                  (let (x/1038 (apply f/1034 (field 0 l/1035)))
                    (makeblock 0 x/1038
                      (apply map1/1033 f/1034 (field 1 l/1035))))
                  z/1031)))
           map1/1033)))
    (setfield_imm 0 (global Code!) map1/1030))
  (let
    (list1/1039
       (apply (field 0 (global Code!)) (function x/1040 (+ x/1040 1))
         [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]))
    (setfield_imm 1 (global Code!) list1/1039))
  0a)
checking tailcall on map1/1033
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (map1/1030
       (let
         (z/1031
            (apply (field 11 (global List!)) (function x/1032 (+ x/1032 1))
              [0: 1 [0: 2 [0: 3 0a]]]))
         (letrec
           (map1/1033
              (function f/1034 l/1035
                (if l/1035
                  (let (x/1038 (apply f/1034 (field 0 l/1035)))
                    (makeblock 0 x/1038
                      (apply map1/1033 f/1034 (field 1 l/1035))))
                  z/1031)))
           map1/1033)))
    (setfield_imm 0 (global Code!) map1/1030))
  (let
    (list1/1039
       (apply (field 0 (global Code!)) (function x/1040 (+ x/1040 1))
         [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]))
    (setfield_imm 1 (global Code!) list1/1039))
  0a)
checking tailcall on map1/1033
-dclosure
*** After Closure.intro:
(seq
  (let
    (map1/1030
       (let
         (z/1031
            (let
              (f/1045
                 (closure (camlCode__fun_1043(1)  x/1032 (+ x/1032 1)) {2} )
               clos_env/1047
                 (closure (camlCode__map_1046(2)  f/1063 param/1316
                            (if param/1316
                              (let
                                (l/1048[Alias] (field 1 param/1316)
                                 a/1049[Alias] (field 0 param/1316)
                                 r/1050 (apply f/1063 a/1049))
                                (makeblock 0 r/1050
                                  (camlCode__map_1046  f/1063 l/1048)))
                              0a)) {0} ))
              (camlCode__map_1046  f/1045 [0: 1 [0: 2 [0: 3 0a]]]))
          clos/1054
            (closure (camlCode__map1_1033(2)  f/1034 l/1035 env/1052
                       (if l/1035
                         (let (x/1038 (apply f/1034 (field 0 l/1035)))
                           (makeblock 0 x/1038
                             (camlCode__map1_1033  f/1034 (field 1 l/1035)
                               env/1052)))
                         (field 3 env/1052))) {3} 
                                              z/1031))
         clos/1054))
    (setfield_imm 0 (global camlCode!) map1/1030))
  (let
    (list1/1039
       (let
         (env/1057 (field 0 (global camlCode!))
          f/1058 (closure (camlCode__fun_1055(1)  x/1040 (+ x/1040 1)) {2} )
          clos_env/1060
            (closure (camlCode__map1_1059(2)  f/1034 l/1035 env/1052
                       (if l/1035
                         (let (x/1061 (apply f/1034 (field 0 l/1035)))
                           (makeblock 0 x/1061
                             (camlCode__map1_1059  f/1034 (field 1 l/1035)
                               env/1052)))
                         (field 3 env/1052))) {0} ))
         (camlCode__map1_1059  f/1058 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]
           env/1057)))
    (setfield_imm 1 (global camlCode!) list1/1039))
  0a)
*** After TonClosure.optimize:
(let (f/1045 (closure (camlCode__fun_1043(1)  x/1032 (+ x/1032 1)) {2} ))
  (seq
    (closure (camlCode__map_1046(2)  f/1063 param/1316
               (if param/1316
                 (let
                   (l/1048[Alias] (field 1 param/1316)
                    a/1049[Alias] (field 0 param/1316)
                    r/1050 (apply f/1063 a/1049))
                   (makeblock 0 r/1050 (camlCode__map_1046  f/1063 l/1048)))
                 0a)) {0} )
    (let
      (z/1031 (camlCode__map_1046  f/1045 [0: 1 [0: 2 [0: 3 0a]]])
       clos/1054
         (closure (camlCode__map1_1033(2)  f/1034 l/1035 env/1052
                    (if l/1035
                      (let (x/1038 (apply f/1034 (field 0 l/1035)))
                        (makeblock 0 x/1038
                          (camlCode__map1_1033  f/1034 (field 1 l/1035)
                            env/1052)))
                      (field 3 env/1052))) {3} 
                                           z/1031))
      (seq (setfield_imm 0 (global camlCode!) clos/1054)
        (let
          (env/1057 (field 0 (global camlCode!))
           f/1058 (closure (camlCode__fun_1055(1)  x/1040 (+ x/1040 1)) {2} ))
          (seq
            (closure (camlCode__map1_1059(2)  f/1034 l/1035 env/1052
                       (if l/1035
                         (let (x/1061 (apply f/1034 (field 0 l/1035)))
                           (makeblock 0 x/1061
                             (camlCode__map1_1059  f/1034 (field 1 l/1035)
                               env/1052)))
                         (field 3 env/1052))) {0} )
            (let
              (list1/1039
                 (camlCode__map1_1059  f/1058
                   [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]] env/1057))
              (seq (setfield_imm 1 (global camlCode!) list1/1039) 0a))))))))

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 8)
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__map1_1059")
(data int 2295 "camlCode__4": addr "camlCode__fun_1055" int 3)
(data
 int 3319
 "camlCode__5":
 addr "caml_curry2"
 int 5
 addr "camlCode__map_1046")
(data int 2295 "camlCode__6": addr "camlCode__fun_1043" int 3)
(data
 global "camlCode__1"
 int 2048
 "camlCode__1":
 int 3
 addr L11
 int 2048
 L11:
 int 5
 addr L12
 int 2048
 L12:
 int 7
 int 1)
(data
 global "camlCode__2"
 int 2048
 "camlCode__2":
 int 3
 addr L7
 int 2048
 L7:
 int 5
 addr L8
 int 2048
 L8:
 int 7
 addr L9
 int 2048
 L9:
 int 9
 addr L10
 int 2048
 L10:
 int 11
 int 1)
(function camlCode__fun_1043 (x/1032: addr) (+ x/1032 2))

(function camlCode__map_1046 (f/1063: addr param/1316: addr)
 (if (!= param/1316 1)
   (let
     (l/1048 (load (+a param/1316 4)) a/1049 (load param/1316)
      r/1050 (app{list.ml:57,20-23} (load f/1063) a/1049 f/1063 addr))
     (alloc 2048 r/1050
       (app{list.ml:57,32-39} "camlCode__map_1046" f/1063 l/1048 addr)))
   1a))

(function camlCode__map1_1033 (f/1034: addr l/1035: addr env/1052: addr)
 (if (!= l/1035 1)
   (let x/1038 (app (load f/1034) (load l/1035) f/1034 addr)
     (alloc 2048 x/1038
       (app "camlCode__map1_1033" f/1034 (load (+a l/1035 4)) env/1052 addr)))
   (load (+a env/1052 12))))

(function camlCode__fun_1055 (x/1040: addr) (+ x/1040 2))

(function camlCode__map1_1059 (f/1034: addr l/1035: addr env/1052: addr)
 (if (!= l/1035 1)
   (let x/1061 (app (load f/1034) (load l/1035) f/1034 addr)
     (alloc 2048 x/1061
       (app "camlCode__map1_1059" f/1034 (load (+a l/1035 4)) env/1052 addr)))
   (load (+a env/1052 12))))

(function camlCode__entry ()
 (let f/1045 "camlCode__6" "camlCode__5" []
   (let
     (z/1031 (app{:0,0-0} "camlCode__map_1046" f/1045 "camlCode__1" addr)
      clos/1054 (alloc 4343 "caml_curry2" 5 "camlCode__map1_1033" z/1031))
     (store "camlCode" clos/1054)
     (let (env/1057 (load "camlCode") f/1058 "camlCode__4") "camlCode__3" 
       []
       (let
         list1/1039
           (app "camlCode__map1_1059" f/1058 "camlCode__2" env/1057 addr)
         (store (+a "camlCode" 4) list1/1039) 1a)))))

(data)
-dlinear
Before simplify
camlCode__fun_1043:
                  I/9[%eax] := I/9[%eax] + 2
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_1043:
  I/9[%eax] := I/9[%eax] + 2
  return R/0[%eax]
  
Before simplify
camlCode__map_1046:
                  f/8[%edx] := R/0[%eax]
                  if param/9[%ebx] ==s 1 goto L101
                  spilled-f/19[s0] := f/8[%edx] (spill)
                  l/11[%eax] := [param/9[%ebx] + 4]
                  spilled-l/18[s1] := l/11[%eax] (spill)
                  a/12[%eax] := [param/9[%ebx]]
                  A/13[%ecx] := [f/8[%edx]]
                  R/1[%ebx] := f/8[%edx]
                  {spilled-l/18[s1]* spilled-f/19[s0]*}
                  R/0[%eax] := call A/13[%ecx] R/0[%eax] R/1[%ebx] {list.ml:57,20-23}
                  spilled-r/17[s2] := r/14[%eax] (spill)
                  f/20[%eax] := spilled-f/19[s0] (reload)
                  l/21[%ebx] := spilled-l/18[s1] (reload)
                  {spilled-r/17[s2]*}
                  R/0[%eax] := call "camlCode__map_1046" R/0[%eax] R/1[%ebx] {list.ml:57,32-39}
                  A/15[%ecx] := R/0[%eax]
                  {A/15[%ecx]* spilled-r/17[s2]*}
                  A/16[%eax] := alloc 12
                  [A/16[%eax] + -4] := 2048
                  r/22[%ebx] := spilled-r/17[s2] (reload)
                  [A/16[%eax]] := r/22[%ebx]
                  [A/16[%eax] + 4] := A/15[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  L101 [0]:
                  A/10[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__map_1046:
  f/8[%edx] := R/0[%eax]
  if param/9[%ebx] ==s 1 goto L101
  spilled-f/19[s0] := f/8[%edx] (spill)
  l/11[%eax] := [param/9[%ebx] + 4]
  spilled-l/18[s1] := l/11[%eax] (spill)
  a/12[%eax] := [param/9[%ebx]]
  A/13[%ecx] := [f/8[%edx]]
  R/1[%ebx] := f/8[%edx]
  {spilled-l/18[s1]* spilled-f/19[s0]*}
  R/0[%eax] := call A/13[%ecx] R/0[%eax] R/1[%ebx] {list.ml:57,20-23}
  spilled-r/17[s2] := r/14[%eax] (spill)
  f/20[%eax] := spilled-f/19[s0] (reload)
  l/21[%ebx] := spilled-l/18[s1] (reload)
  {spilled-r/17[s2]*}
  R/0[%eax] := call "camlCode__map_1046" R/0[%eax] R/1[%ebx] {list.ml:57,32-39}
  A/15[%ecx] := R/0[%eax]
  {A/15[%ecx]* spilled-r/17[s2]*}
  A/16[%eax] := alloc 12
  [A/16[%eax] + -4] := 2048
  r/22[%ebx] := spilled-r/17[s2] (reload)
  [A/16[%eax]] := r/22[%ebx]
  [A/16[%eax] + 4] := A/15[%ecx]
  reload retaddr
  return R/0[%eax]
  L101 [2]:
  A/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__map1_1033:
                  f/8[%edx] := R/0[%eax]
                  if l/9[%ebx] ==s 1 goto L108
                  spilled-env/19[s2] := env/10[%ecx] (spill)
                  spilled-l/21[s0] := l/9[%ebx] (spill)
                  spilled-f/20[s1] := f/8[%edx] (spill)
                  A/12[%eax] := [l/9[%ebx]]
                  A/13[%ecx] := [f/8[%edx]]
                  R/1[%ebx] := f/8[%edx]
                  {spilled-env/19[s2]* spilled-f/20[s1]* spilled-l/21[s0]*}
                  R/0[%eax] := call A/13[%ecx] R/0[%eax] R/1[%ebx]
                  spilled-x/18[s3] := x/14[%eax] (spill)
                  l/22[%eax] := spilled-l/21[s0] (reload)
                  A/15[%ebx] := [l/22[%eax] + 4]
                  f/23[%eax] := spilled-f/20[s1] (reload)
                  env/24[%ecx] := spilled-env/19[s2] (reload)
                  {spilled-x/18[s3]*}
                  R/0[%eax] := call "camlCode__map1_1033" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  A/16[%ecx] := R/0[%eax]
                  {A/16[%ecx]* spilled-x/18[s3]*}
                  A/17[%eax] := alloc 12
                  [A/17[%eax] + -4] := 2048
                  x/25[%ebx] := spilled-x/18[s3] (reload)
                  [A/17[%eax]] := x/25[%ebx]
                  [A/17[%eax] + 4] := A/16[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  L108 [0]:
                  A/11[%eax] := [env/10[%ecx] + 12]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__map1_1033:
  f/8[%edx] := R/0[%eax]
  if l/9[%ebx] ==s 1 goto L108
  spilled-env/19[s2] := env/10[%ecx] (spill)
  spilled-l/21[s0] := l/9[%ebx] (spill)
  spilled-f/20[s1] := f/8[%edx] (spill)
  A/12[%eax] := [l/9[%ebx]]
  A/13[%ecx] := [f/8[%edx]]
  R/1[%ebx] := f/8[%edx]
  {spilled-env/19[s2]* spilled-f/20[s1]* spilled-l/21[s0]*}
  R/0[%eax] := call A/13[%ecx] R/0[%eax] R/1[%ebx]
  spilled-x/18[s3] := x/14[%eax] (spill)
  l/22[%eax] := spilled-l/21[s0] (reload)
  A/15[%ebx] := [l/22[%eax] + 4]
  f/23[%eax] := spilled-f/20[s1] (reload)
  env/24[%ecx] := spilled-env/19[s2] (reload)
  {spilled-x/18[s3]*}
  R/0[%eax] := call "camlCode__map1_1033" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/16[%ecx] := R/0[%eax]
  {A/16[%ecx]* spilled-x/18[s3]*}
  A/17[%eax] := alloc 12
  [A/17[%eax] + -4] := 2048
  x/25[%ebx] := spilled-x/18[s3] (reload)
  [A/17[%eax]] := x/25[%ebx]
  [A/17[%eax] + 4] := A/16[%ecx]
  reload retaddr
  return R/0[%eax]
  L108 [2]:
  A/11[%eax] := [env/10[%ecx] + 12]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__fun_1055:
                  I/9[%eax] := I/9[%eax] + 2
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_1055:
  I/9[%eax] := I/9[%eax] + 2
  return R/0[%eax]
  
Before simplify
camlCode__map1_1059:
                  f/8[%edx] := R/0[%eax]
                  if l/9[%ebx] ==s 1 goto L116
                  spilled-env/19[s2] := env/10[%ecx] (spill)
                  spilled-l/21[s0] := l/9[%ebx] (spill)
                  spilled-f/20[s1] := f/8[%edx] (spill)
                  A/12[%eax] := [l/9[%ebx]]
                  A/13[%ecx] := [f/8[%edx]]
                  R/1[%ebx] := f/8[%edx]
                  {spilled-env/19[s2]* spilled-f/20[s1]* spilled-l/21[s0]*}
                  R/0[%eax] := call A/13[%ecx] R/0[%eax] R/1[%ebx]
                  spilled-x/18[s3] := x/14[%eax] (spill)
                  l/22[%eax] := spilled-l/21[s0] (reload)
                  A/15[%ebx] := [l/22[%eax] + 4]
                  f/23[%eax] := spilled-f/20[s1] (reload)
                  env/24[%ecx] := spilled-env/19[s2] (reload)
                  {spilled-x/18[s3]*}
                  R/0[%eax] := call "camlCode__map1_1059" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  A/16[%ecx] := R/0[%eax]
                  {A/16[%ecx]* spilled-x/18[s3]*}
                  A/17[%eax] := alloc 12
                  [A/17[%eax] + -4] := 2048
                  x/25[%ebx] := spilled-x/18[s3] (reload)
                  [A/17[%eax]] := x/25[%ebx]
                  [A/17[%eax] + 4] := A/16[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  L116 [0]:
                  A/11[%eax] := [env/10[%ecx] + 12]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__map1_1059:
  f/8[%edx] := R/0[%eax]
  if l/9[%ebx] ==s 1 goto L116
  spilled-env/19[s2] := env/10[%ecx] (spill)
  spilled-l/21[s0] := l/9[%ebx] (spill)
  spilled-f/20[s1] := f/8[%edx] (spill)
  A/12[%eax] := [l/9[%ebx]]
  A/13[%ecx] := [f/8[%edx]]
  R/1[%ebx] := f/8[%edx]
  {spilled-env/19[s2]* spilled-f/20[s1]* spilled-l/21[s0]*}
  R/0[%eax] := call A/13[%ecx] R/0[%eax] R/1[%ebx]
  spilled-x/18[s3] := x/14[%eax] (spill)
  l/22[%eax] := spilled-l/21[s0] (reload)
  A/15[%ebx] := [l/22[%eax] + 4]
  f/23[%eax] := spilled-f/20[s1] (reload)
  env/24[%ecx] := spilled-env/19[s2] (reload)
  {spilled-x/18[s3]*}
  R/0[%eax] := call "camlCode__map1_1059" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/16[%ecx] := R/0[%eax]
  {A/16[%ecx]* spilled-x/18[s3]*}
  A/17[%eax] := alloc 12
  [A/17[%eax] + -4] := 2048
  x/25[%ebx] := spilled-x/18[s3] (reload)
  [A/17[%eax]] := x/25[%ebx]
  [A/17[%eax] + 4] := A/16[%ecx]
  reload retaddr
  return R/0[%eax]
  L116 [2]:
  A/11[%eax] := [env/10[%ecx] + 12]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  f/8[%eax] := "camlCode__6"
                  A/9[%ebx] := "camlCode__5"
                  A/10[%ebx] := "camlCode__1"
                  {}
                  R/0[%eax] := call "camlCode__map_1046" R/0[%eax] R/1[%ebx] {:0,0-0}
                  z/11[%ebx] := R/0[%eax]
                  {z/11[%ebx]*}
                  clos/12[%eax] := alloc 20
                  [clos/12[%eax] + -4] := 4343
                  [clos/12[%eax]] := "caml_curry2"
                  [clos/12[%eax] + 4] := 5
                  [clos/12[%eax] + 8] := "camlCode__map1_1033"
                  [clos/12[%eax] + 12] := z/11[%ebx]
                  ["camlCode"] := clos/12[%eax]
                  env/13[%ecx] := ["camlCode"]
                  f/14[%eax] := "camlCode__4"
                  A/15[%ebx] := "camlCode__3"
                  A/16[%ebx] := "camlCode__2"
                  {}
                  R/0[%eax] := call "camlCode__map1_1059" R/0[%eax] R/1[%ebx] R/2[%ecx]
                  ["camlCode" + 4] := list1/17[%eax]
                  A/18[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  f/8[%eax] := "camlCode__6"
  A/9[%ebx] := "camlCode__5"
  A/10[%ebx] := "camlCode__1"
  {}
  R/0[%eax] := call "camlCode__map_1046" R/0[%eax] R/1[%ebx] {:0,0-0}
  z/11[%ebx] := R/0[%eax]
  {z/11[%ebx]*}
  clos/12[%eax] := alloc 20
  [clos/12[%eax] + -4] := 4343
  [clos/12[%eax]] := "caml_curry2"
  [clos/12[%eax] + 4] := 5
  [clos/12[%eax] + 8] := "camlCode__map1_1033"
  [clos/12[%eax] + 12] := z/11[%ebx]
  ["camlCode"] := clos/12[%eax]
  env/13[%ecx] := ["camlCode"]
  f/14[%eax] := "camlCode__4"
  A/15[%ebx] := "camlCode__3"
  A/16[%ebx] := "camlCode__2"
  {}
  R/0[%eax] := call "camlCode__map1_1059" R/0[%eax] R/1[%ebx] R/2[%ecx]
  ["camlCode" + 4] := list1/17[%eax]
  A/18[%eax] := 1
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
	.long	2048
	.globl	camlCode
camlCode:
	.space	8
	.data
	.long	3319
camlCode__3:
	.long	caml_curry2
	.long	5
	.long	camlCode__map1_1059
	.data
	.long	2295
camlCode__4:
	.long	camlCode__fun_1055
	.long	3
	.data
	.long	3319
camlCode__5:
	.long	caml_curry2
	.long	5
	.long	camlCode__map_1046
	.data
	.long	2295
camlCode__6:
	.long	camlCode__fun_1043
	.long	3
	.data
	.globl	camlCode__1
	.long	2048
camlCode__1:
	.long	3
	.long	.L100011
	.long	2048
.L100011:
	.long	5
	.long	.L100012
	.long	2048
.L100012:
	.long	7
	.long	1
	.data
	.globl	camlCode__2
	.long	2048
camlCode__2:
	.long	3
	.long	.L100007
	.long	2048
.L100007:
	.long	5
	.long	.L100008
	.long	2048
.L100008:
	.long	7
	.long	.L100009
	.long	2048
.L100009:
	.long	9
	.long	.L100010
	.long	2048
.L100010:
	.long	11
	.long	1
	.text
	.align	16
	.globl	camlCode__fun_1043
camlCode__fun_1043:
.L100:
	addl	$2, %eax
	ret
	.type	camlCode__fun_1043,@function
	.size	camlCode__fun_1043,.-camlCode__fun_1043
	.text
	.align	16
	.globl	camlCode__map_1046
camlCode__map_1046:
	subl	$12, %esp
.L102:
	movl	%eax, %edx
	cmpl	$1, %ebx
	je	.L101
	movl	%edx, 0(%esp)
	movl	4(%ebx), %eax
	movl	%eax, 4(%esp)
	movl	(%ebx), %eax
	movl	(%edx), %ecx
	movl	%edx, %ebx
	call	*%ecx
.L103:
	movl	%eax, 8(%esp)
	movl	0(%esp), %eax
	movl	4(%esp), %ebx
	call	camlCode__map_1046
.L104:
	movl	%eax, %ecx
.L105:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L106
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	8(%esp), %ebx
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	addl	$12, %esp
	ret
	.align	16
.L101:
	movl	$1, %eax
	addl	$12, %esp
	ret
.L106:	call	caml_call_gc
.L107:	jmp	.L105
	.type	camlCode__map_1046,@function
	.size	camlCode__map_1046,.-camlCode__map_1046
	.text
	.align	16
	.globl	camlCode__map1_1033
camlCode__map1_1033:
	subl	$16, %esp
.L109:
	movl	%eax, %edx
	cmpl	$1, %ebx
	je	.L108
	movl	%ecx, 8(%esp)
	movl	%ebx, 0(%esp)
	movl	%edx, 4(%esp)
	movl	(%ebx), %eax
	movl	(%edx), %ecx
	movl	%edx, %ebx
	call	*%ecx
.L110:
	movl	%eax, 12(%esp)
	movl	0(%esp), %eax
	movl	4(%eax), %ebx
	movl	4(%esp), %eax
	movl	8(%esp), %ecx
	call	camlCode__map1_1033
.L111:
	movl	%eax, %ecx
.L112:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L113
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	12(%esp), %ebx
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	addl	$16, %esp
	ret
	.align	16
.L108:
	movl	12(%ecx), %eax
	addl	$16, %esp
	ret
.L113:	call	caml_call_gc
.L114:	jmp	.L112
	.type	camlCode__map1_1033,@function
	.size	camlCode__map1_1033,.-camlCode__map1_1033
	.text
	.align	16
	.globl	camlCode__fun_1055
camlCode__fun_1055:
.L115:
	addl	$2, %eax
	ret
	.type	camlCode__fun_1055,@function
	.size	camlCode__fun_1055,.-camlCode__fun_1055
	.text
	.align	16
	.globl	camlCode__map1_1059
camlCode__map1_1059:
	subl	$16, %esp
.L117:
	movl	%eax, %edx
	cmpl	$1, %ebx
	je	.L116
	movl	%ecx, 8(%esp)
	movl	%ebx, 0(%esp)
	movl	%edx, 4(%esp)
	movl	(%ebx), %eax
	movl	(%edx), %ecx
	movl	%edx, %ebx
	call	*%ecx
.L118:
	movl	%eax, 12(%esp)
	movl	0(%esp), %eax
	movl	4(%eax), %ebx
	movl	4(%esp), %eax
	movl	8(%esp), %ecx
	call	camlCode__map1_1059
.L119:
	movl	%eax, %ecx
.L120:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L121
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	12(%esp), %ebx
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	addl	$16, %esp
	ret
	.align	16
.L116:
	movl	12(%ecx), %eax
	addl	$16, %esp
	ret
.L121:	call	caml_call_gc
.L122:	jmp	.L120
	.type	camlCode__map1_1059,@function
	.size	camlCode__map1_1059,.-camlCode__map1_1059
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L123:
	movl	$camlCode__6, %eax
	movl	$camlCode__5, %ebx
	movl	$camlCode__1, %ebx
	call	camlCode__map_1046
.L124:
	movl	%eax, %ebx
	movl	$20, %eax
	call	caml_allocN
.L125:
	leal	4(%eax), %eax
	movl	$4343, -4(%eax)
	movl	$caml_curry2, (%eax)
	movl	$5, 4(%eax)
	movl	$camlCode__map1_1033, 8(%eax)
	movl	%ebx, 12(%eax)
	movl	%eax, camlCode
	movl	camlCode, %ecx
	movl	$camlCode__4, %eax
	movl	$camlCode__3, %ebx
	movl	$camlCode__2, %ebx
	call	camlCode__map1_1059
.L126:
	movl	%eax, camlCode + 4
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
	.long	12
	.long	.L126
	.word	4
	.word	0
	.align	4
	.long	.L125
	.word	4
	.word	1
	.word	3
	.align	4
	.long	.L124
	.word	5
	.word	0
	.align	4
	.long	.L200000 - . + 0x0
	.long	0x0
	.long	.L122
	.word	20
	.word	2
	.word	12
	.word	5
	.align	4
	.long	.L119
	.word	20
	.word	1
	.word	12
	.align	4
	.long	.L118
	.word	20
	.word	3
	.word	0
	.word	4
	.word	8
	.align	4
	.long	.L114
	.word	20
	.word	2
	.word	12
	.word	5
	.align	4
	.long	.L111
	.word	20
	.word	1
	.word	12
	.align	4
	.long	.L110
	.word	20
	.word	3
	.word	0
	.word	4
	.word	8
	.align	4
	.long	.L107
	.word	16
	.word	2
	.word	8
	.word	5
	.align	4
	.long	.L104
	.word	17
	.word	1
	.word	8
	.align	4
	.long	.L200001 - . + 0x9c000000
	.long	0x39200
	.long	.L103
	.word	17
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L200001 - . + 0x5c000000
	.long	0x39140
.L200000:
	.ascii	"\0"
	.align	4
.L200001:
	.ascii	"list.ml\0"
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

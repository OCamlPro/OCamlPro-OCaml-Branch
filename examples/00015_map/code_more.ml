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
            (apply (field 10 (global List!)) (function x/1032 (+ x/1032 1))
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
close_rec_functions
find_invariants camlCode__map1_1033
calls for label = camlCode__map1_1033
args:	 (f_1034, l_1035, env_1052, )
	 (f_1034, _, )
param f_1034 = f_1034, 
param env_1052 = {not invariant}
param l_1035 = _
found 1 invariants !!!
Recursive function map1 could be inlined
use_label: camlCode__map_1046
use_label: camlCode__map_1046
is_pure(Uclosure camlCode__map_1046) has used state true
use_label: camlCode__map1_1033
use_label: camlCode__map1_1059
use_label: camlCode__map1_1059
is_pure(Uclosure camlCode__map1_1059) has used state true
lambda saved
typedtree saved
-dlambda
(seq
  (let
    (map1/1030
       (let
         (z/1031
            (apply (field 10 (global List!)) (function x/1032 (+ x/1032 1))
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
            (apply (field 10 (global List!)) (function x/1032 (+ x/1032 1))
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
close_rec_functions
stats_rec_removed : 0

stats_tailcall_removed : 0

find_invariants camlCode__map1_1033
calls for label = camlCode__map1_1033
args:	 (f_1034, l_1035, env_1052, )
	 (f_1034, _, )
param f_1034 = f_1034, 
param env_1052 = {not invariant}
param l_1035 = _
found 1 invariants !!!
Recursive function map1 could be inlined
use_label: camlCode__map_1046
use_label: camlCode__map_1046
is_pure(Uclosure camlCode__map_1046) has used state true
use_label: camlCode__map1_1033
use_label: camlCode__map1_1059
use_label: camlCode__map1_1059
is_pure(Uclosure camlCode__map1_1059) has used state true
lambda saved
typedtree saved
-dclosure
close_rec_functions
find_invariants camlCode__map1_1033
calls for label = camlCode__map1_1033
args:	 (f_1034, l_1035, env_1052, )
	 (f_1034, _, )
param f_1034 = f_1034, 
param env_1052 = {not invariant}
param l_1035 = _
found 1 invariants !!!
Recursive function map1 could be inlined
*** After Closure.intro:
(seq
  (let
    (map1/1030
       (let
         (z/1031
            (let
              (f/1045 (closure (camlCode__fun_1043(1)  x/1032 (+ x/1032 1)) )
               clos_env/1047
                 (closure (camlCode__map_1046(2)  f/1063 param/1308
                            (if param/1308
                              (let
                                (l/1048[Alias] (field 1 param/1308)
                                 a/1049[Alias] (field 0 param/1308)
                                 r/1050 (apply f/1063 a/1049))
                                (makeblock 0 r/1050
                                  (camlCode__map_1046  f/1063 l/1048)))
                              0a)) ))
              (camlCode__map_1046  f/1045 [0: 1 [0: 2 [0: 3 0a]]]))
          clos/1054
            (closure (camlCode__map1_1033(2)  f/1034 l/1035 env/1052
                       (if l/1035
                         (let (x/1038 (apply f/1034 (field 0 l/1035)))
                           (makeblock 0 x/1038
                             (camlCode__map1_1033  f/1034 (field 1 l/1035)
                               env/1052)))
                         (field 3 env/1052))) 
                                              z/1031))
         clos/1054))
    (setfield_imm 0 (global camlCode!) map1/1030))
  (let
    (list1/1039
       (let
         (env/1057 (field 0 (global camlCode!))
          f/1058 (closure (camlCode__fun_1055(1)  x/1040 (+ x/1040 1)) )
          clos_env/1060
            (closure (camlCode__map1_1059(2)  f/1034 l/1035 env/1052
                       (if l/1035
                         (let (x/1061 (apply f/1034 (field 0 l/1035)))
                           (makeblock 0 x/1061
                             (camlCode__map1_1059  f/1034 (field 1 l/1035)
                               env/1052)))
                         (field 3 env/1052))) ))
         (camlCode__map1_1059  f/1058 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]
           env/1057)))
    (setfield_imm 1 (global camlCode!) list1/1039))
  0a)
use_label: camlCode__map_1046
use_label: camlCode__map_1046
is_pure(Uclosure camlCode__map_1046) has used state true
use_label: camlCode__map1_1033
use_label: camlCode__map1_1059
use_label: camlCode__map1_1059
is_pure(Uclosure camlCode__map1_1059) has used state true
stats_letbody_removed : 0

stats_let_removed : 2
(clos_env_1060) (clos_env_1047) 
stats_variable_removed : 0

stats_closure_removed : 0

*** After TonClosure.optimize:
(seq
  (let
    (map1/1030
       (let
         (z/1031
            (let
              (f/1045 (closure (camlCode__fun_1043(1)  x/1032 (+ x/1032 1)) ))
              (seq
                (closure (camlCode__map_1046(2)  f/1063 param/1308
                           (if param/1308
                             (let
                               (l/1048[Alias] (field 1 param/1308)
                                a/1049[Alias] (field 0 param/1308)
                                r/1050 (apply f/1063 a/1049))
                               (makeblock 0 r/1050
                                 (camlCode__map_1046  f/1063 l/1048)))
                             0a)) )
                (camlCode__map_1046  f/1045 [0: 1 [0: 2 [0: 3 0a]]])))
          clos/1054
            (closure (camlCode__map1_1033(2)  f/1034 l/1035 env/1052
                       (if l/1035
                         (let (x/1038 (apply f/1034 (field 0 l/1035)))
                           (makeblock 0 x/1038
                             (camlCode__map1_1033  f/1034 (field 1 l/1035)
                               env/1052)))
                         (field 3 env/1052))) 
                                              z/1031))
         clos/1054))
    (setfield_imm 0 (global camlCode!) map1/1030))
  (let
    (list1/1039
       (let
         (env/1057 (field 0 (global camlCode!))
          f/1058 (closure (camlCode__fun_1055(1)  x/1040 (+ x/1040 1)) ))
         (seq
           (closure (camlCode__map1_1059(2)  f/1034 l/1035 env/1052
                      (if l/1035
                        (let (x/1061 (apply f/1034 (field 0 l/1035)))
                          (makeblock 0 x/1061
                            (camlCode__map1_1059  f/1034 (field 1 l/1035)
                              env/1052)))
                        (field 3 env/1052))) )
           (camlCode__map1_1059  f/1058 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]
             env/1057))))
    (setfield_imm 1 (global camlCode!) list1/1039))
  0a)
lambda saved
typedtree saved

-dcmm
close_rec_functions
find_invariants camlCode__map1_1033
calls for label = camlCode__map1_1033
args:	 (f_1034, l_1035, env_1052, )
	 (f_1034, _, )
param f_1034 = f_1034, 
param env_1052 = {not invariant}
param l_1035 = _
found 1 invariants !!!
Recursive function map1 could be inlined
use_label: camlCode__map_1046
use_label: camlCode__map_1046
is_pure(Uclosure camlCode__map_1046) has used state true
use_label: camlCode__map1_1033
use_label: camlCode__map1_1059
use_label: camlCode__map1_1059
is_pure(Uclosure camlCode__map1_1059) has used state true

(data
 int 2048
 global "camlCode"
 "camlCode":
 skip 16)
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

(function camlCode__map_1046 (f/1063: addr param/1308: addr)
 (if (!= param/1308 1)
   (let
     (l/1048 (load (+a param/1308 8)) a/1049 (load param/1308)
      r/1050 (app{list.ml:57,20-23} (load f/1063) a/1049 f/1063 addr))
     (alloc 2048 r/1050
       (app{list.ml:57,32-39} "camlCode__map_1046" f/1063 l/1048 addr)))
   1a))

(function camlCode__map1_1033 (f/1034: addr l/1035: addr env/1052: addr)
 (if (!= l/1035 1)
   (let x/1038 (app (load f/1034) (load l/1035) f/1034 addr)
     (alloc 2048 x/1038
       (app "camlCode__map1_1033" f/1034 (load (+a l/1035 8)) env/1052 addr)))
   (load (+a env/1052 24))))

(function camlCode__fun_1055 (x/1040: addr) (+ x/1040 2))

(function camlCode__map1_1059 (f/1034: addr l/1035: addr env/1052: addr)
 (if (!= l/1035 1)
   (let x/1061 (app (load f/1034) (load l/1035) f/1034 addr)
     (alloc 2048 x/1061
       (app "camlCode__map1_1059" f/1034 (load (+a l/1035 8)) env/1052 addr)))
   (load (+a env/1052 24))))

(function camlCode__entry ()
 (let
   map1/1030
     (let
       (z/1031
          (let f/1045 "camlCode__6" "camlCode__5" []
            (app{:0,0-0} "camlCode__map_1046" f/1045 "camlCode__1" addr))
        clos/1054 (alloc 4343 "caml_curry2" 5 "camlCode__map1_1033" z/1031))
       clos/1054)
   (store "camlCode" map1/1030))
 (let
   list1/1039
     (let (env/1057 (load "camlCode") f/1058 "camlCode__4") "camlCode__3" 
       [] (app "camlCode__map1_1059" f/1058 "camlCode__2" env/1057 addr))
   (store (+a "camlCode" 8) list1/1039))
 1a)

(data)
lambda saved
typedtree saved
-S
	.section        .rodata.cst8,"a",@progbits
	.align	16
caml_negf_mask:	.quad   0x8000000000000000, 0
	.align	16
caml_absf_mask:	.quad   0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.quad	2048
	.globl	camlCode
camlCode:
	.space	16
	.data
	.quad	3319
camlCode__3:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__map1_1059
	.data
	.quad	2295
camlCode__4:
	.quad	camlCode__fun_1055
	.quad	3
	.data
	.quad	3319
camlCode__5:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__map_1046
	.data
	.quad	2295
camlCode__6:
	.quad	camlCode__fun_1043
	.quad	3
	.data
	.globl	camlCode__1
	.quad	2048
camlCode__1:
	.quad	3
	.quad	.L100011
	.quad	2048
.L100011:
	.quad	5
	.quad	.L100012
	.quad	2048
.L100012:
	.quad	7
	.quad	1
	.data
	.globl	camlCode__2
	.quad	2048
camlCode__2:
	.quad	3
	.quad	.L100007
	.quad	2048
.L100007:
	.quad	5
	.quad	.L100008
	.quad	2048
.L100008:
	.quad	7
	.quad	.L100009
	.quad	2048
.L100009:
	.quad	9
	.quad	.L100010
	.quad	2048
.L100010:
	.quad	11
	.quad	1
	.text
	.align	16
	.globl	camlCode__fun_1043
camlCode__fun_1043:
.L100:
	addq	$2, %rax
	ret
	.type	camlCode__fun_1043,@function
	.size	camlCode__fun_1043,.-camlCode__fun_1043
	.text
	.align	16
	.globl	camlCode__map_1046
camlCode__map_1046:
	subq	$24, %rsp
.L102:
	movq	%rax, %rsi
	cmpq	$1, %rbx
	je	.L101
	movq	%rsi, 0(%rsp)
	movq	8(%rbx), %rax
	movq	%rax, 8(%rsp)
	movq	(%rbx), %rax
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L103:
	movq	%rax, 16(%rsp)
	movq	0(%rsp), %rax
	movq	8(%rsp), %rbx
	call	camlCode__map_1046@PLT
.L104:
	movq	%rax, %rdi
.L105:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L106
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	16(%rsp), %rbx
	movq	%rbx, (%rax)
	movq	%rdi, 8(%rax)
	addq	$24, %rsp
	ret
	.align	4
.L101:
	movq	$1, %rax
	addq	$24, %rsp
	ret
.L106:	call	caml_call_gc@PLT
.L107:	jmp	.L105
	.type	camlCode__map_1046,@function
	.size	camlCode__map_1046,.-camlCode__map_1046
	.text
	.align	16
	.globl	camlCode__map1_1033
camlCode__map1_1033:
	subq	$40, %rsp
.L109:
	movq	%rax, %rsi
	cmpq	$1, %rbx
	je	.L108
	movq	%rdi, 16(%rsp)
	movq	%rbx, 0(%rsp)
	movq	%rsi, 8(%rsp)
	movq	(%rbx), %rax
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L110:
	movq	%rax, 24(%rsp)
	movq	0(%rsp), %rax
	movq	8(%rax), %rbx
	movq	8(%rsp), %rax
	movq	16(%rsp), %rdi
	call	camlCode__map1_1033@PLT
.L111:
	movq	%rax, %rdi
.L112:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L113
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	24(%rsp), %rbx
	movq	%rbx, (%rax)
	movq	%rdi, 8(%rax)
	addq	$40, %rsp
	ret
	.align	4
.L108:
	movq	24(%rdi), %rax
	addq	$40, %rsp
	ret
.L113:	call	caml_call_gc@PLT
.L114:	jmp	.L112
	.type	camlCode__map1_1033,@function
	.size	camlCode__map1_1033,.-camlCode__map1_1033
	.text
	.align	16
	.globl	camlCode__fun_1055
camlCode__fun_1055:
.L115:
	addq	$2, %rax
	ret
	.type	camlCode__fun_1055,@function
	.size	camlCode__fun_1055,.-camlCode__fun_1055
	.text
	.align	16
	.globl	camlCode__map1_1059
camlCode__map1_1059:
	subq	$40, %rsp
.L117:
	movq	%rax, %rsi
	cmpq	$1, %rbx
	je	.L116
	movq	%rdi, 16(%rsp)
	movq	%rbx, 0(%rsp)
	movq	%rsi, 8(%rsp)
	movq	(%rbx), %rax
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L118:
	movq	%rax, 24(%rsp)
	movq	0(%rsp), %rax
	movq	8(%rax), %rbx
	movq	8(%rsp), %rax
	movq	16(%rsp), %rdi
	call	camlCode__map1_1059@PLT
.L119:
	movq	%rax, %rdi
.L120:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L121
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	24(%rsp), %rbx
	movq	%rbx, (%rax)
	movq	%rdi, 8(%rax)
	addq	$40, %rsp
	ret
	.align	4
.L116:
	movq	24(%rdi), %rax
	addq	$40, %rsp
	ret
.L121:	call	caml_call_gc@PLT
.L122:	jmp	.L120
	.type	camlCode__map1_1059,@function
	.size	camlCode__map1_1059,.-camlCode__map1_1059
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L123:
	movq	camlCode__6@GOTPCREL(%rip), %rax
	movq	camlCode__5@GOTPCREL(%rip), %rbx
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	call	camlCode__map_1046@PLT
.L124:
	movq	%rax, %rdi
	movq	$40, %rax
	call	caml_allocN@PLT
.L125:
	leaq	8(%r15), %rbx
	movq	$4343, -8(%rbx)
	movq	caml_curry2@GOTPCREL(%rip), %rax
	movq	%rax, (%rbx)
	movq	$5, 8(%rbx)
	movq	camlCode__map1_1033@GOTPCREL(%rip), %rax
	movq	%rax, 16(%rbx)
	movq	%rdi, 24(%rbx)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	movq	camlCode__4@GOTPCREL(%rip), %rax
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	call	camlCode__map1_1059@PLT
.L126:
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	%rax, 8(%rbx)
	movq	$1, %rax
	addq	$8, %rsp
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
	.quad	12
	.quad	.L126
	.word	16
	.word	0
	.align	8
	.quad	.L125
	.word	16
	.word	1
	.word	5
	.align	8
	.quad	.L124
	.word	17
	.word	0
	.align	8
	.long	(.L200000 - .) + 0x0
	.long	0x0
	.quad	.L122
	.word	48
	.word	2
	.word	24
	.word	5
	.align	8
	.quad	.L119
	.word	48
	.word	1
	.word	24
	.align	8
	.quad	.L118
	.word	48
	.word	3
	.word	0
	.word	8
	.word	16
	.align	8
	.quad	.L114
	.word	48
	.word	2
	.word	24
	.word	5
	.align	8
	.quad	.L111
	.word	48
	.word	1
	.word	24
	.align	8
	.quad	.L110
	.word	48
	.word	3
	.word	0
	.word	8
	.word	16
	.align	8
	.quad	.L107
	.word	32
	.word	2
	.word	16
	.word	5
	.align	8
	.quad	.L104
	.word	33
	.word	1
	.word	16
	.align	8
	.long	(.L200001 - .) + 0x9c000000
	.long	0x39200
	.quad	.L103
	.word	33
	.word	2
	.word	0
	.word	8
	.align	8
	.long	(.L200001 - .) + 0x5c000000
	.long	0x39140
.L200000:
	.align	8
.L200001:
	.asciz	"list.ml"
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

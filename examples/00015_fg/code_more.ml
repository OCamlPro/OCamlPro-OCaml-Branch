(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.
*)

let rec fun_a f list =
  match list with
      [] -> 0
    | x :: tail ->
	(f x) + (fun_b f tail)

and fun_b g list =
  match list with
      [] -> 0
    | x :: tail -> fun_a g tail

let _ =
  fun_a (fun x -> x + 1) [1;2;3;4]

(*
-drawlambda
(seq
  (letrec
    (fun_a/1030
       (function f/1032 list/1033
         (if list/1033
           (let (tail/1035 (field 1 list/1033) x/1034 (field 0 list/1033))
             (+ (apply f/1032 x/1034) (apply fun_b/1031 f/1032 tail/1035)))
           0))
      fun_b/1031
        (function g/1036 list/1037
          (if list/1037
            (let (tail/1039 (field 1 list/1037) x/1038 (field 0 list/1037))
              (apply fun_a/1030 g/1036 tail/1039))
            0)))
    (seq (setfield_imm 0 (global Code!) fun_a/1030)
      (setfield_imm 1 (global Code!) fun_b/1031)))
  (apply (field 0 (global Code!)) (function x/1040 (+ x/1040 1))
    [0: 1 [0: 2 [0: 3 [0: 4 0a]]]])
  0a)
close_rec_functions
find_invariants camlCode__fun_a_1030
find_invariants camlCode__fun_b_1031
calls for label = camlCode__fun_b_1031
args:	 (g_1036, list_1037, env_1046, )
	 (f_1032, _, )
calls for label = camlCode__fun_a_1030
args:	 (f_1032, list_1033, env_1045, )
	 (g_1036, _, )
param env_1045 = {not invariant}
param env_1046 = {not invariant}
param f_1032 = f_1032, g_1036, 
param list_1033 = _
param list_1037 = _
param g_1036 = g_1036, f_1032, 
found 2 invariants !!!
Recursive function fun_a could be inlined
Recursive function fun_b could be inlined
use_label: camlCode__fun_b_1031
use_label: camlCode__fun_a_1030
use_label: camlCode__fun_b_1055
use_label: camlCode__fun_a_1054
use_label: camlCode__fun_a_1054
is_pure(Uclosure camlCode__fun_a_1054) has used state true
lambda saved
typedtree saved
-dlambda
(seq
  (letrec
    (fun_a/1030
       (function f/1032 list/1033
         (if list/1033
           (+ (apply f/1032 (field 0 list/1033))
             (apply fun_b/1031 f/1032 (field 1 list/1033)))
           0))
      fun_b/1031
        (function g/1036 list/1037
          (if list/1037 (apply fun_a/1030 g/1036 (field 1 list/1037)) 0)))
    (seq (setfield_imm 0 (global Code!) fun_a/1030)
      (setfield_imm 1 (global Code!) fun_b/1031)))
  (apply (field 0 (global Code!)) (function x/1040 (+ x/1040 1))
    [0: 1 [0: 2 [0: 3 [0: 4 0a]]]])
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (letrec
    (fun_a/1030
       (function f/1032 list/1033
         (if list/1033
           (+ (apply f/1032 (field 0 list/1033))
             (apply fun_b/1031 f/1032 (field 1 list/1033)))
           0))
      fun_b/1031
        (function g/1036 list/1037
          (if list/1037 (apply fun_a/1030 g/1036 (field 1 list/1037)) 0)))
    (seq (setfield_imm 0 (global Code!) fun_a/1030)
      (setfield_imm 1 (global Code!) fun_b/1031)))
  (apply (field 0 (global Code!)) (function x/1040 (+ x/1040 1))
    [0: 1 [0: 2 [0: 3 [0: 4 0a]]]])
  0a)
close_rec_functions
stats_rec_removed : 0

stats_tailcall_removed : 0

find_invariants camlCode__fun_a_1030
find_invariants camlCode__fun_b_1031
calls for label = camlCode__fun_b_1031
args:	 (g_1036, list_1037, env_1046, )
	 (f_1032, _, )
calls for label = camlCode__fun_a_1030
args:	 (f_1032, list_1033, env_1045, )
	 (g_1036, _, )
param env_1045 = {not invariant}
param env_1046 = {not invariant}
param f_1032 = f_1032, g_1036, 
param list_1033 = _
param list_1037 = _
param g_1036 = g_1036, f_1032, 
found 2 invariants !!!
Recursive function fun_a could be inlined
Recursive function fun_b could be inlined
use_label: camlCode__fun_b_1031
use_label: camlCode__fun_a_1030
use_label: camlCode__fun_b_1055
use_label: camlCode__fun_a_1054
use_label: camlCode__fun_a_1054
is_pure(Uclosure camlCode__fun_a_1054) has used state true
lambda saved
typedtree saved
-dclosure
close_rec_functions
find_invariants camlCode__fun_a_1030
find_invariants camlCode__fun_b_1031
calls for label = camlCode__fun_b_1031
args:	 (g_1036, list_1037, env_1046, )
	 (f_1032, _, )
calls for label = camlCode__fun_a_1030
args:	 (f_1032, list_1033, env_1045, )
	 (g_1036, _, )
param env_1045 = {not invariant}
param env_1046 = {not invariant}
param f_1032 = f_1032, g_1036, 
param list_1033 = _
param list_1037 = _
param g_1036 = g_1036, f_1032, 
found 2 invariants !!!
Recursive function fun_a could be inlined
Recursive function fun_b could be inlined
*** After Closure.intro:
(seq
  (let
    (clos/1049
       (closure (camlCode__fun_a_1030(2)  f/1032 list/1033 env/1045
                  (if list/1033
                    (+ (apply f/1032 (field 0 list/1033))
                      (camlCode__fun_b_1031  f/1032 (field 1 list/1033)
                        (offset[4] env/1045)))
                    0))(camlCode__fun_b_1031(2)  g/1036 list/1037 env/1046
                         (if list/1037
                           (camlCode__fun_a_1030  g/1036 (field 1 list/1037)
                             (offset[-4] env/1046))
                           0)) ))
    (seq (setfield_imm 0 (global camlCode!) clos/1049)
      (setfield_imm 1 (global camlCode!) (offset[4] clos/1049))))
  (let
    (env/1052 (field 0 (global camlCode!))
     f/1053 (closure (camlCode__fun_1050(1)  x/1040 (+ x/1040 1)) )
     clos_env/1056
       (closure (camlCode__fun_a_1054(2)  f/1032 list/1033 env/1045
                  (if list/1033
                    (+ (apply f/1032 (field 0 list/1033))
                      (camlCode__fun_b_1055  f/1032 (field 1 list/1033)
                        (offset[4] env/1045)))
                    0))(camlCode__fun_b_1055(2)  g/1036 list/1037 env/1046
                         (if list/1037
                           (camlCode__fun_a_1054  g/1036 (field 1 list/1037)
                             (offset[-4] env/1046))
                           0)) ))
    (camlCode__fun_a_1054  f/1053 [0: 1 [0: 2 [0: 3 [0: 4 0a]]]] env/1052))
  0a)
use_label: camlCode__fun_b_1031
use_label: camlCode__fun_a_1030
use_label: camlCode__fun_b_1055
use_label: camlCode__fun_a_1054
use_label: camlCode__fun_a_1054
is_pure(Uclosure camlCode__fun_a_1054) has used state true
stats_letbody_removed : 0

stats_let_removed : 1
(clos_env_1056) 
stats_variable_removed : 0

stats_closure_removed : 0

*** After TonClosure.optimize:
(seq
  (let
    (clos/1049
       (closure (camlCode__fun_a_1030(2)  f/1032 list/1033 env/1045
                  (if list/1033
                    (+ (apply f/1032 (field 0 list/1033))
                      (camlCode__fun_b_1031  f/1032 (field 1 list/1033)
                        (offset[4] env/1045)))
                    0))(camlCode__fun_b_1031(2)  g/1036 list/1037 env/1046
                         (if list/1037
                           (camlCode__fun_a_1030  g/1036 (field 1 list/1037)
                             (offset[-4] env/1046))
                           0)) ))
    (seq (setfield_imm 0 (global camlCode!) clos/1049)
      (setfield_imm 1 (global camlCode!) (offset[4] clos/1049))))
  (let
    (env/1052 (field 0 (global camlCode!))
     f/1053 (closure (camlCode__fun_1050(1)  x/1040 (+ x/1040 1)) ))
    (seq
      (closure (camlCode__fun_a_1054(2)  f/1032 list/1033 env/1045
                 (if list/1033
                   (+ (apply f/1032 (field 0 list/1033))
                     (camlCode__fun_b_1055  f/1032 (field 1 list/1033)
                       (offset[4] env/1045)))
                   0))(camlCode__fun_b_1055(2)  g/1036 list/1037 env/1046
                        (if list/1037
                          (camlCode__fun_a_1054  g/1036 (field 1 list/1037)
                            (offset[-4] env/1046))
                          0)) )
      (camlCode__fun_a_1054  f/1053 [0: 1 [0: 2 [0: 3 [0: 4 0a]]]] env/1052)))
  0a)
lambda saved
typedtree saved

-dcmm
close_rec_functions
find_invariants camlCode__fun_a_1030
find_invariants camlCode__fun_b_1031
calls for label = camlCode__fun_b_1031
args:	 (g_1036, list_1037, env_1046, )
	 (f_1032, _, )
calls for label = camlCode__fun_a_1030
args:	 (f_1032, list_1033, env_1045, )
	 (g_1036, _, )
param env_1045 = {not invariant}
param env_1046 = {not invariant}
param f_1032 = f_1032, g_1036, 
param list_1033 = _
param list_1037 = _
param g_1036 = g_1036, f_1032, 
found 2 invariants !!!
Recursive function fun_a could be inlined
Recursive function fun_b could be inlined
use_label: camlCode__fun_b_1031
use_label: camlCode__fun_a_1030
use_label: camlCode__fun_b_1055
use_label: camlCode__fun_a_1054
use_label: camlCode__fun_a_1054
is_pure(Uclosure camlCode__fun_a_1054) has used state true

(data
 int 2048
 global "camlCode"
 "camlCode":
 skip 16)
(data
 int 7415
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__fun_a_1054"
 int 4345
 addr "caml_curry2"
 int 5
 addr "camlCode__fun_b_1055")
(data int 2295 "camlCode__3": addr "camlCode__fun_1050" int 3)
(data
 int 7415
 "camlCode__4":
 addr "caml_curry2"
 int 5
 addr "camlCode__fun_a_1030"
 int 4345
 addr "caml_curry2"
 int 5
 addr "camlCode__fun_b_1031")
(data
 global "camlCode__1"
 int 2048
 "camlCode__1":
 int 3
 addr L5
 int 2048
 L5:
 int 5
 addr L6
 int 2048
 L6:
 int 7
 addr L7
 int 2048
 L7:
 int 9
 int 1)
(function camlCode__fun_b_1031 (g/1036: addr list/1037: addr env/1046: addr)
 (if (!= list/1037 1)
   (app "camlCode__fun_a_1030" g/1036 (load (+a list/1037 8))
     (+a env/1046 -32) addr)
   1))

(function camlCode__fun_a_1030 (f/1032: addr list/1033: addr env/1045: addr)
 (if (!= list/1033 1)
   (+
     (+ (app (load f/1032) (load list/1033) f/1032 addr)
       (app "camlCode__fun_b_1031" f/1032 (load (+a list/1033 8))
         (+a env/1045 32) addr))
     -1)
   1))

(function camlCode__fun_1050 (x/1040: addr) (+ x/1040 2))

(function camlCode__fun_b_1055 (g/1036: addr list/1037: addr env/1046: addr)
 (if (!= list/1037 1)
   (app "camlCode__fun_a_1054" g/1036 (load (+a list/1037 8))
     (+a env/1046 -32) addr)
   1))

(function camlCode__fun_a_1054 (f/1032: addr list/1033: addr env/1045: addr)
 (if (!= list/1033 1)
   (+
     (+ (app (load f/1032) (load list/1033) f/1032 addr)
       (app "camlCode__fun_b_1055" f/1032 (load (+a list/1033 8))
         (+a env/1045 32) addr))
     -1)
   1))

(function camlCode__entry ()
 (let clos/1049 "camlCode__4" (store "camlCode" clos/1049)
   (store (+a "camlCode" 8) (+a clos/1049 32)))
 (let (env/1052 (load "camlCode") f/1053 "camlCode__3") "camlCode__2" 
   [] (app "camlCode__fun_a_1054" f/1053 "camlCode__1" env/1052 unit))
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
	.quad	7415
camlCode__2:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__fun_a_1054
	.quad	4345
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__fun_b_1055
	.data
	.quad	2295
camlCode__3:
	.quad	camlCode__fun_1050
	.quad	3
	.data
	.quad	7415
camlCode__4:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__fun_a_1030
	.quad	4345
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__fun_b_1031
	.data
	.globl	camlCode__1
	.quad	2048
camlCode__1:
	.quad	3
	.quad	.L100005
	.quad	2048
.L100005:
	.quad	5
	.quad	.L100006
	.quad	2048
.L100006:
	.quad	7
	.quad	.L100007
	.quad	2048
.L100007:
	.quad	9
	.quad	1
	.text
	.align	16
	.globl	camlCode__fun_b_1031
camlCode__fun_b_1031:
.L101:
	cmpq	$1, %rbx
	je	.L100
	addq	$-32, %rdi
	movq	8(%rbx), %rbx
	jmp	camlCode__fun_a_1030@PLT
	.align	4
.L100:
	movq	$1, %rax
	ret
	.type	camlCode__fun_b_1031,@function
	.size	camlCode__fun_b_1031,.-camlCode__fun_b_1031
	.text
	.align	16
	.globl	camlCode__fun_a_1030
camlCode__fun_a_1030:
	subq	$24, %rsp
.L103:
	cmpq	$1, %rbx
	je	.L102
	movq	%rbx, 0(%rsp)
	movq	%rax, 8(%rsp)
	addq	$32, %rdi
	movq	8(%rbx), %rbx
	call	camlCode__fun_b_1031@PLT
.L104:
	movq	%rax, 16(%rsp)
	movq	0(%rsp), %rax
	movq	(%rax), %rax
	movq	8(%rsp), %rbx
	movq	(%rbx), %rdi
	call	*%rdi
.L105:
	movq	16(%rsp), %rbx
	addq	%rbx, %rax
	decq	%rax
	addq	$24, %rsp
	ret
	.align	4
.L102:
	movq	$1, %rax
	addq	$24, %rsp
	ret
	.type	camlCode__fun_a_1030,@function
	.size	camlCode__fun_a_1030,.-camlCode__fun_a_1030
	.text
	.align	16
	.globl	camlCode__fun_1050
camlCode__fun_1050:
.L106:
	addq	$2, %rax
	ret
	.type	camlCode__fun_1050,@function
	.size	camlCode__fun_1050,.-camlCode__fun_1050
	.text
	.align	16
	.globl	camlCode__fun_b_1055
camlCode__fun_b_1055:
.L108:
	cmpq	$1, %rbx
	je	.L107
	addq	$-32, %rdi
	movq	8(%rbx), %rbx
	jmp	camlCode__fun_a_1054@PLT
	.align	4
.L107:
	movq	$1, %rax
	ret
	.type	camlCode__fun_b_1055,@function
	.size	camlCode__fun_b_1055,.-camlCode__fun_b_1055
	.text
	.align	16
	.globl	camlCode__fun_a_1054
camlCode__fun_a_1054:
	subq	$24, %rsp
.L110:
	cmpq	$1, %rbx
	je	.L109
	movq	%rbx, 0(%rsp)
	movq	%rax, 8(%rsp)
	addq	$32, %rdi
	movq	8(%rbx), %rbx
	call	camlCode__fun_b_1055@PLT
.L111:
	movq	%rax, 16(%rsp)
	movq	0(%rsp), %rax
	movq	(%rax), %rax
	movq	8(%rsp), %rbx
	movq	(%rbx), %rdi
	call	*%rdi
.L112:
	movq	16(%rsp), %rbx
	addq	%rbx, %rax
	decq	%rax
	addq	$24, %rsp
	ret
	.align	4
.L109:
	movq	$1, %rax
	addq	$24, %rsp
	ret
	.type	camlCode__fun_a_1054,@function
	.size	camlCode__fun_a_1054,.-camlCode__fun_a_1054
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L113:
	movq	camlCode__4@GOTPCREL(%rip), %rax
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	%rax, (%rbx)
	movq	camlCode@GOTPCREL(%rip), %rbx
	addq	$32, %rax
	movq	%rax, 8(%rbx)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	movq	camlCode__3@GOTPCREL(%rip), %rax
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	call	camlCode__fun_a_1054@PLT
.L114:
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
	.quad	5
	.quad	.L114
	.word	16
	.word	0
	.align	8
	.quad	.L112
	.word	32
	.word	1
	.word	16
	.align	8
	.quad	.L111
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.quad	.L105
	.word	32
	.word	1
	.word	16
	.align	8
	.quad	.L104
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

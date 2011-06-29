(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.
*)


let rec map f list =
  match list with
      [] -> []
    | x :: tail ->
      let x = f x in
      x :: map f tail



let list =
  map (fun x -> x+1) [1;2;3;4;5]

(*
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
*)
(*
-drawlambda
(seq
  (letrec
    (map/1030
       = (function f/1031 list/1032
           (if list/1032
             (let
               (tail/1034 (=) (field 1 list/1032)
                x/1033 (=) (field 0 list/1032)
                x/1035 = (apply f/1031 x/1033))
               (makeblock 0 x/1035 (apply map/1030 f/1031 tail/1034)))
             0a)))
    (setfield_imm 0 (global Code!) map/1030))
  (let
    (list/1036
       = (apply (field 0 (global Code!)) (function x/1037 (+ x/1037 1))
           [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]))
    (setfield_imm 1 (global Code!) list/1036))
  0a)
size of camlCode__fun_1044
lambda size = 3
camlCode__fun_1044 should be inlined
Second pass of inlining...
Label camlCode__map_1030 found
Label camlCode__map_1030 found
-dlambda
(seq
  (letrec
    (map/1030
       = (function f/1031 list/1032
           (if list/1032
             (let (x/1035 = (apply f/1031 (field 0 list/1032)))
               (makeblock 0 x/1035
                 (apply map/1030 f/1031 (field 1 list/1032))))
             0a)))
    (setfield_imm 0 (global Code!) map/1030))
  (let
    (list/1036
       = (apply (field 0 (global Code!)) (function x/1037 (+ x/1037 1))
           [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]))
    (setfield_imm 1 (global Code!) list/1036))
  0a)
size of camlCode__fun_1044
lambda size = 3
camlCode__fun_1044 should be inlined
Second pass of inlining...
Label camlCode__map_1030 found
Label camlCode__map_1030 found
-dclosure
size of camlCode__fun_1044
lambda size = 3
camlCode__fun_1044 should be inlined
*** Clambda: after closure conversion:
(seq
  (let
    (clos/1043 {} = 
       (closure (camlCode__map_1030(2)  f/1031 list/1032 env/1042
                  (if list/1032
                    (let (x/1035 {} =  (apply f/1031 (field 0 list/1032)))
                      (makeblock 0 x/1035
                        (camlCode__map_1030  f/1031 (field 1 list/1032)
                          (offset[0] env/1042))))
                    0a)) {0} ))
    (setfield_imm 0 (global camlCode!) (offset[0] clos/1043)))
  (let
    (list/1036 {} = 
       (camlCode__map_1030 
         (closure (camlCode__fun_1044(1)  x/1037 (+ x/1037 1)) {0} )
         [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]] (field 0 (global camlCode!))))
    (setfield_imm 1 (global camlCode!) list/1036))
  0a)
Second pass of inlining...
Label camlCode__map_1030 found
Label camlCode__map_1030 found
*** Clambda: after second inlining:
(seq
  (let
    (clos/1043 {} = 
       (closure (camlCode__map_1030(2)  f/1031 list/1032 env/1042
                  (if list/1032
                    (let (x/1035 {} =  (apply f/1031 (field 0 list/1032)))
                      (makeblock 0 x/1035
                        (camlCode__map_1030  f/1031 (field 1 list/1032)
                          (offset[0] env/1042))))
                    0a)) {0} ))
    (setfield_imm 0 (global camlCode!) (offset[0] clos/1043)))
  (let
    (list/1036 {} = 
       (camlCode__map_1030 
         (closure (camlCode__fun_1044(1)  x/1037 (+ x/1037 1)) {0} )
         [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]] (field 0 (global camlCode!))))
    (setfield_imm 1 (global camlCode!) list/1036))
  0a)

*** Clambda: after simplification:
(seq
  (let
    (clos/1043 {} = 
       (closure (camlCode__map_1030(2)  f/1031 list/1032 env/1042
                  (if list/1032
                    (let (x/1035 {} =  (apply f/1031 (field 0 list/1032)))
                      (makeblock 0 x/1035
                        (camlCode__map_1030  f/1031 (field 1 list/1032)
                          (offset[0] env/1042))))
                    0a)) {0} ))
    (setfield_imm 0 (global camlCode!) (offset[0] clos/1043)))
  (let
    (list/1036 {} = 
       (camlCode__map_1030 
         (closure (camlCode__fun_1044(1)  x/1037 (+ x/1037 1)) {0} )
         [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]] (field 0 (global camlCode!))))
    (setfield_imm 1 (global camlCode!) list/1036))
  0a)


-dcmm
size of camlCode__fun_1044
lambda size = 3
camlCode__fun_1044 should be inlined
Second pass of inlining...
Label camlCode__map_1030 found
Label camlCode__map_1030 found
(data int 2048 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__2": addr "camlCode__fun_1044" int 3)
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__map_1030")
(data
 global "camlCode__1"
 int 2048
 "camlCode__1":
 int 3
 addr L4
 int 2048
 L4:
 int 5
 addr L5
 int 2048
 L5:
 int 7
 addr L6
 int 2048
 L6:
 int 9
 addr L7
 int 2048
 L7:
 int 11
 int 1)
(function camlCode__map_1030 (f/1031: addr list/1032: addr env/1042: addr)
 (if (!= list/1032 1)
   (let x/1035 (app (load f/1031) (load list/1032) f/1031 addr)
     (alloc 2048 x/1035
       (app "camlCode__map_1030" f/1031 (load (+a list/1032 8)) env/1042
         addr)))
   1a))

(function camlCode__fun_1044 (x/1037: addr) (+ x/1037 2))

(function camlCode__entry ()
 (let clos/1043 "camlCode__3" (store "camlCode" clos/1043))
 (let
   list/1036
     (app "camlCode__map_1030" "camlCode__2" "camlCode__1" (load "camlCode")
       addr)
   (store (+a "camlCode" 8) list/1036))
 1a)

(data)
-dlinear
size of camlCode__fun_1044
lambda size = 3
camlCode__fun_1044 should be inlined
Second pass of inlining...
Label camlCode__map_1030 found
Label camlCode__map_1030 found
*** Linearized code
camlCode__map_1030:
  f/29[%rsi] := R/0[%rax]
  if list/30[%rbx] ==s 1 goto L100
  spilled-env/40[s2] := env/31[%rdi] (spill)
  spilled-list/42[s0] := list/30[%rbx] (spill)
  spilled-f/41[s1] := f/29[%rsi] (spill)
  A/33[%rax] := [list/30[%rbx]]
  A/34[%rdi] := [f/29[%rsi]]
  R/1[%rbx] := f/29[%rsi]
  {spilled-env/40[s2]* spilled-f/41[s1]* spilled-list/42[s0]*}
  R/0[%rax] := call A/34[%rdi] R/0[%rax] R/1[%rbx]
  spilled-x/39[s3] := x/35[%rax] (spill)
  list/43[%rax] := spilled-list/42[s0] (reload)
  A/36[%rbx] := [list/43[%rax] + 8]
  f/44[%rax] := spilled-f/41[s1] (reload)
  env/45[%rdi] := spilled-env/40[s2] (reload)
  {spilled-x/39[s3]*}
  R/0[%rax] := call "camlCode__map_1030" R/0[%rax] R/1[%rbx] R/2[%rdi]
  A/37[%rdi] := R/0[%rax]
  {A/37[%rdi]* spilled-x/39[s3]*}
  A/38[%rax] := alloc 24
  [A/38[%rax] + -8] := 2048
  x/46[%rbx] := spilled-x/39[s3] (reload)
  [A/38[%rax]] := x/46[%rbx]
  [A/38[%rax] + 8] := A/37[%rdi]
  reload retaddr
  return R/0[%rax]
  L100:
  A/32[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__fun_1044:
  I/30[%rax] := I/30[%rax] + 2
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  clos/29[%rbx] := "camlCode__3"
  A/30[%rax] := "camlCode"
  [A/30[%rax]] := clos/29[%rbx]
  A/31[%rax] := "camlCode"
  A/32[%rdi] := [A/31[%rax]]
  A/33[%rbx] := "camlCode__1"
  A/34[%rax] := "camlCode__2"
  {}
  R/0[%rax] := call "camlCode__map_1030" R/0[%rax] R/1[%rbx] R/2[%rdi]
  A/36[%rbx] := "camlCode"
  [A/36[%rbx] + 8] := list/35[%rax]
  A/37[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
-dstartup
	.section        .rodata.cst8,"a",@progbits
	.align	16
caml_negf_mask:	.quad   0x8000000000000000, 0
	.align	16
caml_absf_mask:	.quad   0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF
	.data
	.globl	caml_startup__data_begin
caml_startup__data_begin:
	.text
	.globl	caml_startup__code_begin
caml_startup__code_begin:
	.text
	.align	16
	.globl	caml_program
caml_program:
	subq	$8, %rsp
.L100:
	call	camlPervasives__entry@PLT
.L101:
	movq	caml_globals_inited@GOTPCREL(%rip), %rax
	addq	$1, (%rax)
	call	camlCode__entry@PLT
.L102:
	movq	caml_globals_inited@GOTPCREL(%rip), %rax
	addq	$1, (%rax)
	call	camlStd_exit__entry@PLT
.L103:
	movq	caml_globals_inited@GOTPCREL(%rip), %rax
	addq	$1, (%rax)
	movq	$1, %rax
	addq	$8, %rsp
	ret
	.type	caml_program,@function
	.size	caml_program,.-caml_program
	.text
	.align	16
	.globl	caml_curry4
caml_curry4:
	subq	$8, %rsp
.L104:
	movq	%rax, %rsi
.L105:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L106
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry4_1@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$7, 8(%rax)
	movq	caml_curry4_1_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L106:	call	caml_call_gc@PLT
.L107:	jmp	.L105
	.type	caml_curry4,@function
	.size	caml_curry4,.-caml_curry4
	.text
	.align	16
	.globl	caml_curry4_1_app
caml_curry4_1_app:
.L108:
	movq	%rax, %r10
	movq	%rbx, %r9
	movq	%rdi, %r8
	movq	32(%rsi), %rdx
	movq	24(%rsi), %rax
	movq	16(%rdx), %rcx
	movq	%r10, %rbx
	movq	%r9, %rdi
	movq	%r8, %rsi
	jmp	*%rcx
	.type	caml_curry4_1_app,@function
	.size	caml_curry4_1_app,.-caml_curry4_1_app
	.text
	.align	16
	.globl	caml_curry4_1
caml_curry4_1:
	subq	$8, %rsp
.L109:
	movq	%rax, %rsi
.L110:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L111
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry4_2@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$5, 8(%rax)
	movq	caml_curry4_2_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L111:	call	caml_call_gc@PLT
.L112:	jmp	.L110
	.type	caml_curry4_1,@function
	.size	caml_curry4_1,.-caml_curry4_1
	.text
	.align	16
	.globl	caml_curry4_2_app
caml_curry4_2_app:
.L113:
	movq	%rax, %r8
	movq	%rbx, %rsi
	movq	32(%rdi), %rax
	movq	32(%rax), %rdx
	movq	24(%rdi), %rbx
	movq	24(%rax), %rax
	movq	16(%rdx), %rcx
	movq	%r8, %rdi
	jmp	*%rcx
	.type	caml_curry4_2_app,@function
	.size	caml_curry4_2_app,.-caml_curry4_2_app
	.text
	.align	16
	.globl	caml_curry4_2
caml_curry4_2:
	subq	$8, %rsp
.L114:
	movq	%rax, %rsi
.L115:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L116
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry4_3@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L116:	call	caml_call_gc@PLT
.L117:	jmp	.L115
	.type	caml_curry4_2,@function
	.size	caml_curry4_2,.-caml_curry4_2
	.text
	.align	16
	.globl	caml_curry4_3
caml_curry4_3:
.L118:
	movq	%rax, %rsi
	movq	24(%rbx), %rcx
	movq	32(%rcx), %rax
	movq	32(%rax), %rdx
	movq	16(%rbx), %rdi
	movq	24(%rcx), %rbx
	movq	24(%rax), %rax
	movq	16(%rdx), %rcx
	jmp	*%rcx
	.type	caml_curry4_3,@function
	.size	caml_curry4_3,.-caml_curry4_3
	.text
	.align	16
	.globl	caml_curry3
caml_curry3:
	subq	$8, %rsp
.L119:
	movq	%rax, %rsi
.L120:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L121
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry3_1@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$5, 8(%rax)
	movq	caml_curry3_1_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L121:	call	caml_call_gc@PLT
.L122:	jmp	.L120
	.type	caml_curry3,@function
	.size	caml_curry3,.-caml_curry3
	.text
	.align	16
	.globl	caml_curry3_1_app
caml_curry3_1_app:
.L123:
	movq	%rax, %r8
	movq	%rbx, %rcx
	movq	32(%rdi), %rsi
	movq	24(%rdi), %rax
	movq	16(%rsi), %rdx
	movq	%r8, %rbx
	movq	%rcx, %rdi
	jmp	*%rdx
	.type	caml_curry3_1_app,@function
	.size	caml_curry3_1_app,.-caml_curry3_1_app
	.text
	.align	16
	.globl	caml_curry3_1
caml_curry3_1:
	subq	$8, %rsp
.L124:
	movq	%rax, %rsi
.L125:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L126
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry3_2@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L126:	call	caml_call_gc@PLT
.L127:	jmp	.L125
	.type	caml_curry3_1,@function
	.size	caml_curry3_1,.-caml_curry3_1
	.text
	.align	16
	.globl	caml_curry3_2
caml_curry3_2:
.L128:
	movq	%rax, %rdi
	movq	24(%rbx), %rax
	movq	32(%rax), %rsi
	movq	16(%rbx), %rbx
	movq	24(%rax), %rax
	movq	16(%rsi), %rdx
	jmp	*%rdx
	.type	caml_curry3_2,@function
	.size	caml_curry3_2,.-caml_curry3_2
	.text
	.align	16
	.globl	caml_curry2
caml_curry2:
	subq	$8, %rsp
.L129:
	movq	%rax, %rsi
.L130:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L131
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry2_1@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L131:	call	caml_call_gc@PLT
.L132:	jmp	.L130
	.type	caml_curry2,@function
	.size	caml_curry2,.-caml_curry2
	.text
	.align	16
	.globl	caml_curry2_1
caml_curry2_1:
.L133:
	movq	%rax, %rdx
	movq	24(%rbx), %rdi
	movq	16(%rbx), %rax
	movq	16(%rdi), %rsi
	movq	%rdx, %rbx
	jmp	*%rsi
	.type	caml_curry2_1,@function
	.size	caml_curry2_1,.-caml_curry2_1
	.text
	.align	16
	.globl	caml_apply3
caml_apply3:
	subq	$24, %rsp
.L135:
	movq	8(%rsi), %rdx
	cmpq	$7, %rdx
	jne	.L134
	movq	16(%rsi), %rdx
	addq	$24, %rsp
	jmp	*%rdx
	.align	4
.L134:
	movq	%rdi, 8(%rsp)
	movq	%rbx, 0(%rsp)
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L136:
	movq	%rax, %rbx
	movq	(%rbx), %rdi
	movq	0(%rsp), %rax
	call	*%rdi
.L137:
	movq	%rax, %rbx
	movq	(%rbx), %rdi
	movq	8(%rsp), %rax
	addq	$24, %rsp
	jmp	*%rdi
	.type	caml_apply3,@function
	.size	caml_apply3,.-caml_apply3
	.text
	.align	16
	.globl	caml_apply2
caml_apply2:
	subq	$8, %rsp
.L139:
	movq	8(%rdi), %rsi
	cmpq	$5, %rsi
	jne	.L138
	movq	16(%rdi), %rsi
	addq	$8, %rsp
	jmp	*%rsi
	.align	4
.L138:
	movq	%rbx, 0(%rsp)
	movq	(%rdi), %rsi
	movq	%rdi, %rbx
	call	*%rsi
.L140:
	movq	%rax, %rbx
	movq	(%rbx), %rdi
	movq	0(%rsp), %rax
	addq	$8, %rsp
	jmp	*%rdi
	.type	caml_apply2,@function
	.size	caml_apply2,.-caml_apply2
	.data
	.globl	caml_exn_Out_of_memory
	.quad	1024
caml_exn_Out_of_memory:
	.quad	.L100001
	.quad	2300
.L100001:
	.ascii	"Out_of_memory"
	.space	2
	.byte	2
	.globl	caml_bucket_Out_of_memory
	.quad	1024
caml_bucket_Out_of_memory:
	.quad	caml_exn_Out_of_memory
	.data
	.globl	caml_exn_Sys_error
	.quad	1024
caml_exn_Sys_error:
	.quad	.L100002
	.quad	2300
.L100002:
	.ascii	"Sys_error"
	.space	6
	.byte	6
	.globl	caml_bucket_Sys_error
	.quad	1024
caml_bucket_Sys_error:
	.quad	caml_exn_Sys_error
	.data
	.globl	caml_exn_Failure
	.quad	1024
caml_exn_Failure:
	.quad	.L100003
	.quad	1276
.L100003:
	.ascii	"Failure"
	.byte	0
	.globl	caml_bucket_Failure
	.quad	1024
caml_bucket_Failure:
	.quad	caml_exn_Failure
	.data
	.globl	caml_exn_Invalid_argument
	.quad	1024
caml_exn_Invalid_argument:
	.quad	.L100004
	.quad	3324
.L100004:
	.ascii	"Invalid_argument"
	.space	7
	.byte	7
	.globl	caml_bucket_Invalid_argument
	.quad	1024
caml_bucket_Invalid_argument:
	.quad	caml_exn_Invalid_argument
	.data
	.globl	caml_exn_End_of_file
	.quad	1024
caml_exn_End_of_file:
	.quad	.L100005
	.quad	2300
.L100005:
	.ascii	"End_of_file"
	.space	4
	.byte	4
	.globl	caml_bucket_End_of_file
	.quad	1024
caml_bucket_End_of_file:
	.quad	caml_exn_End_of_file
	.data
	.globl	caml_exn_Division_by_zero
	.quad	1024
caml_exn_Division_by_zero:
	.quad	.L100006
	.quad	3324
.L100006:
	.ascii	"Division_by_zero"
	.space	7
	.byte	7
	.globl	caml_bucket_Division_by_zero
	.quad	1024
caml_bucket_Division_by_zero:
	.quad	caml_exn_Division_by_zero
	.data
	.globl	caml_exn_Not_found
	.quad	1024
caml_exn_Not_found:
	.quad	.L100007
	.quad	2300
.L100007:
	.ascii	"Not_found"
	.space	6
	.byte	6
	.globl	caml_bucket_Not_found
	.quad	1024
caml_bucket_Not_found:
	.quad	caml_exn_Not_found
	.data
	.globl	caml_exn_Match_failure
	.quad	1024
caml_exn_Match_failure:
	.quad	.L100008
	.quad	2300
.L100008:
	.ascii	"Match_failure"
	.space	2
	.byte	2
	.globl	caml_bucket_Match_failure
	.quad	1024
caml_bucket_Match_failure:
	.quad	caml_exn_Match_failure
	.data
	.globl	caml_exn_Stack_overflow
	.quad	1024
caml_exn_Stack_overflow:
	.quad	.L100009
	.quad	2300
.L100009:
	.ascii	"Stack_overflow"
	.space	1
	.byte	1
	.globl	caml_bucket_Stack_overflow
	.quad	1024
caml_bucket_Stack_overflow:
	.quad	caml_exn_Stack_overflow
	.data
	.globl	caml_exn_Sys_blocked_io
	.quad	1024
caml_exn_Sys_blocked_io:
	.quad	.L100010
	.quad	2300
.L100010:
	.ascii	"Sys_blocked_io"
	.space	1
	.byte	1
	.globl	caml_bucket_Sys_blocked_io
	.quad	1024
caml_bucket_Sys_blocked_io:
	.quad	caml_exn_Sys_blocked_io
	.data
	.globl	caml_exn_Assert_failure
	.quad	1024
caml_exn_Assert_failure:
	.quad	.L100011
	.quad	2300
.L100011:
	.ascii	"Assert_failure"
	.space	1
	.byte	1
	.globl	caml_bucket_Assert_failure
	.quad	1024
caml_bucket_Assert_failure:
	.quad	caml_exn_Assert_failure
	.data
	.globl	caml_exn_Undefined_recursive_module
	.quad	1024
caml_exn_Undefined_recursive_module:
	.quad	.L100012
	.quad	4348
.L100012:
	.ascii	"Undefined_recursive_module"
	.space	5
	.byte	5
	.globl	caml_bucket_Undefined_recursive_module
	.quad	1024
caml_bucket_Undefined_recursive_module:
	.quad	caml_exn_Undefined_recursive_module
	.data
	.globl	caml_globals
caml_globals:
	.quad	camlPervasives
	.quad	camlCode
	.quad	camlStd_exit
	.quad	0
	.data
	.globl	caml_globals_map
	.quad	21756
caml_globals_map:
	.ascii	"\204\225\246\276\0\0\0\222\0\0\0\22\0\0\0P\0\0\0A\240\300*Pervasives0\333r:\27\230\261\42\340\211\31\242\277\355\6%\24\60+h\272\320\331*\363\303]\334'\344I\276\362\223\240\4\4@\240\300$Code0\31"
	.ascii	"j=c\276\30*G=\13\5\271VLHq0\273\206\200\325\312\205\244\34v\234\375\257=\316\11>\240\4\4@\240\300(Std_exit0K<u\217\27kw\366\203\3\37W\376u\277\312\60O\31\364*\11\203\263\235i\277\261\26\373?\370"
	.ascii	"\276\240\4\4@@"
	.space	1
	.byte	1
	.data
	.globl	caml_data_segments
caml_data_segments:
	.quad	caml_startup__data_begin
	.quad	caml_startup__data_end
	.quad	camlPervasives__data_begin
	.quad	camlPervasives__data_end
	.quad	camlCode__data_begin
	.quad	camlCode__data_end
	.quad	camlStd_exit__data_begin
	.quad	camlStd_exit__data_end
	.quad	0
	.data
	.globl	caml_code_segments
caml_code_segments:
	.quad	caml_startup__code_begin
	.quad	caml_startup__code_end
	.quad	camlPervasives__code_begin
	.quad	camlPervasives__code_end
	.quad	camlCode__code_begin
	.quad	camlCode__code_end
	.quad	camlStd_exit__code_begin
	.quad	camlStd_exit__code_end
	.quad	0
	.data
	.globl	caml_frametable
caml_frametable:
	.quad	caml_startup__frametable
	.quad	caml_system__frametable
	.quad	camlPervasives__frametable
	.quad	camlCode__frametable
	.quad	camlStd_exit__frametable
	.quad	0
	.text
	.globl	caml_startup__code_end
caml_startup__code_end:
	.data
	.globl	caml_startup__data_end
caml_startup__data_end:
	.long	0
	.globl	caml_startup__frametable
caml_startup__frametable:
	.quad	12
	.quad	.L140
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L137
	.word	32
	.word	1
	.word	8
	.align	8
	.quad	.L136
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.quad	.L132
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L127
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L122
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L117
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L112
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L107
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L103
	.word	16
	.word	0
	.align	8
	.quad	.L102
	.word	16
	.word	0
	.align	8
	.quad	.L101
	.word	16
	.word	0
	.align	8
	.section .note.GNU-stack,"",%progbits
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
	.quad	2295
camlCode__2:
	.quad	camlCode__fun_1044
	.quad	3
	.data
	.quad	3319
camlCode__3:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__map_1030
	.data
	.globl	camlCode__1
	.quad	2048
camlCode__1:
	.quad	3
	.quad	.L100004
	.quad	2048
.L100004:
	.quad	5
	.quad	.L100005
	.quad	2048
.L100005:
	.quad	7
	.quad	.L100006
	.quad	2048
.L100006:
	.quad	9
	.quad	.L100007
	.quad	2048
.L100007:
	.quad	11
	.quad	1
	.text
	.align	16
	.globl	camlCode__map_1030
camlCode__map_1030:
	subq	$40, %rsp
.L101:
	movq	%rax, %rsi
	cmpq	$1, %rbx
	je	.L100
	movq	%rdi, 16(%rsp)
	movq	%rbx, 0(%rsp)
	movq	%rsi, 8(%rsp)
	movq	(%rbx), %rax
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L102:
	movq	%rax, 24(%rsp)
	movq	0(%rsp), %rax
	movq	8(%rax), %rbx
	movq	8(%rsp), %rax
	movq	16(%rsp), %rdi
	call	camlCode__map_1030@PLT
.L103:
	movq	%rax, %rdi
.L104:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L105
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	24(%rsp), %rbx
	movq	%rbx, (%rax)
	movq	%rdi, 8(%rax)
	addq	$40, %rsp
	ret
	.align	4
.L100:
	movq	$1, %rax
	addq	$40, %rsp
	ret
.L105:	call	caml_call_gc@PLT
.L106:	jmp	.L104
	.type	camlCode__map_1030,@function
	.size	camlCode__map_1030,.-camlCode__map_1030
	.text
	.align	16
	.globl	camlCode__fun_1044
camlCode__fun_1044:
.L107:
	addq	$2, %rax
	ret
	.type	camlCode__fun_1044,@function
	.size	camlCode__fun_1044,.-camlCode__fun_1044
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L108:
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	movq	camlCode__2@GOTPCREL(%rip), %rax
	call	camlCode__map_1030@PLT
.L109:
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
	.quad	4
	.quad	.L109
	.word	16
	.word	0
	.align	8
	.quad	.L106
	.word	48
	.word	2
	.word	24
	.word	5
	.align	8
	.quad	.L103
	.word	48
	.word	1
	.word	24
	.align	8
	.quad	.L102
	.word	48
	.word	3
	.word	0
	.word	8
	.word	16
	.align	8
	.section .note.GNU-stack,"",%progbits
*)


let f_int x =
  let (a,b) =
    if x then
      (1,2)
    else
      (2,3)
  in
  a+b

let f_float x =
  let (a,b) =
    if x then
      (1.,2.)
    else
      (2.,3.)
  in
  a+.b

(*
-drawlambda
(seq
  (let
    (f_int/1030
       = (function x/1031
           (let (a/1032 := 0a b/1033 := 0a)
             (seq
               (if x/1031 (seq (assign a/1032 1) (assign b/1033 2))
                 (seq (assign a/1032 2) (assign b/1033 3)))
               (+ a/1032 b/1033)))))
    (setfield_imm 0 (global Code!) f_int/1030))
  (let
    (f_float/1034
       = (function x/1035
           (let (a/1036 := 0a b/1037 := 0a)
             (seq
               (if x/1035 (seq (assign a/1036 1.) (assign b/1037 2.))
                 (seq (assign a/1036 2.) (assign b/1037 3.)))
               (+. a/1036 b/1037)))))
    (setfield_imm 1 (global Code!) f_float/1034))
  0a)
-dlambda
(seq
  (let
    (f_int/1030
       = (function x/1031
           (let (a/1032 := 0a b/1033 := 0a)
             (seq
               (if x/1031 (seq (assign a/1032 1) (assign b/1033 2))
                 (seq (assign a/1032 2) (assign b/1033 3)))
               (+ a/1032 b/1033)))))
    (setfield_imm 0 (global Code!) f_int/1030))
  (let
    (f_float/1034
       = (function x/1035
           (let (a/1036 := 0a b/1037 := 0a)
             (seq
               (if x/1035 (seq (assign a/1036 1.) (assign b/1037 2.))
                 (seq (assign a/1036 2.) (assign b/1037 3.)))
               (+. a/1036 b/1037)))))
    (setfield_imm 1 (global Code!) f_float/1034))
  0a)
-dclosure
*** After closure conversion:
(seq
  (let
    (f_int/1030 {fun camlCode__f_int_1030 {1} closed inline -> ?} = 
       (closure (camlCode__f_int_1030(1)  x/1031
                  (let (a/1032 {cstptr 0} =  0a b/1033 {cstptr 0} =  0a)
                    (seq
                      (if x/1031 (seq (assign a/1032 1) (assign b/1033 2))
                        (seq (assign a/1032 2) (assign b/1033 3)))
                      (+ a/1032 b/1033)))) {0} ))
    (setfield_imm 0 (global camlCode!) f_int/1030))
  (let
    (f_float/1034 {fun camlCode__f_float_1034 {1} closed inline -> ?} = 
       (closure (camlCode__f_float_1034(1)  x/1035
                  (let (a/1036 {cstptr 0} =  0a b/1037 {cstptr 0} =  0a)
                    (seq
                      (if x/1035 (seq (assign a/1036 1.) (assign b/1037 2.))
                        (seq (assign a/1036 2.) (assign b/1037 3.)))
                      (+. a/1036 b/1037)))) {0} ))
    (setfield_imm 1 (global camlCode!) f_float/1034))
  0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__5": addr "camlCode__f_float_1034" int 3)
(data int 2295 "camlCode__6": addr "camlCode__f_int_1030" int 3)
(data global "camlCode__1" int 1277 "camlCode__1": double 1.)
(data global "camlCode__2" int 1277 "camlCode__2": double 2.)
(data global "camlCode__3" int 1277 "camlCode__3": double 2.)
(data global "camlCode__4" int 1277 "camlCode__4": double 3.)
(function camlCode__f_int_1030 (x/1031: addr)
 (let (a/1032 1a b/1033 1a)
   (if (!= x/1031 1) (seq (assign a/1032 3) (assign b/1033 5))
     (seq (assign a/1032 5) (assign b/1033 7)))
   (+ (+ a/1032 b/1033) -1)))

(function camlCode__f_float_1034 (x/1035: addr)
 (let (a/1036 1a b/1037 1a)
   (if (!= x/1035 1)
     (seq (assign a/1036 "camlCode__1") (assign b/1037 "camlCode__2"))
     (seq (assign a/1036 "camlCode__3") (assign b/1037 "camlCode__4")))
   (alloc 1277 (+f (load float64u a/1036) (load float64u b/1037)))))

(function camlCode__entry ()
 (let f_int/1030 "camlCode__6" (store "camlCode" f_int/1030))
 (let f_float/1034 "camlCode__5" (store (+a "camlCode" 8) f_float/1034)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__f_int_1030:
  x/29[%rdi] := R/0[%rax]
  a/30[%rbx] := 1
  b/31[%rax] := 1
  if x/29[%rdi] ==s 1 goto L101
  I/32[%rbx] := 3
  I/33[%rax] := 5
  goto L100
  L101:
  I/34[%rbx] := 5
  I/35[%rax] := 7
  L100:
  I/36[%rax] := a/30[%rbx] + b/31[%rax] + -1
  return R/0[%rax]
  
*** Linearized code
camlCode__f_float_1034:
  a/30[%rdi] := 1
  b/31[%rbx] := 1
  if x/29[%rax] ==s 1 goto L104
  A/32[%rdi] := "camlCode__1"
  A/33[%rbx] := "camlCode__2"
  goto L103
  L104:
  A/34[%rdi] := "camlCode__3"
  A/35[%rbx] := "camlCode__4"
  L103:
  {a/30[%rdi]* b/31[%rbx]*}
  A/36[%rax] := alloc 16
  [A/36[%rax] + -8] := 1277
  F/37[%xmm0] := float64u[a/30[%rdi]]
  F/38[%xmm0] := F/38[%xmm0] +f float64[b/31[%rbx]]
  float64u[A/36[%rax]] := F/38[%xmm0]
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  f_int/29[%rbx] := "camlCode__6"
  A/30[%rax] := "camlCode"
  [A/30[%rax]] := f_int/29[%rbx]
  f_float/31[%rbx] := "camlCode__5"
  A/32[%rax] := "camlCode"
  [A/32[%rax] + 8] := f_float/31[%rbx]
  A/33[%rax] := 1
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
	.ascii	"\204\225\246\276\0\0\0\222\0\0\0\22\0\0\0P\0\0\0A\240\300*Pervasives0\333r:\27\230\261\42\340\211\31\242\277\355\6%\24\60\313;C\225C\23-y\15\33H\264\371S\271:\240\4\4@\240\300$Code0\320"
	.ascii	"r\267\326D\251G\6\271V\222+\222,\315\352\60&\361\376\204\314\255\16\274\22`\220\304\315))\14\240\4\4@\240\300(Std_exit0K<u\217\27kw\366\203\3\37W\376u\277\312\60\245\15s\177\263x\376\216gr\201\37\265d\355"
	.ascii	"\204\240\4\4@@"
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
camlCode__5:
	.quad	camlCode__f_float_1034
	.quad	3
	.data
	.quad	2295
camlCode__6:
	.quad	camlCode__f_int_1030
	.quad	3
	.data
	.globl	camlCode__1
	.quad	1277
camlCode__1:
	.quad	0x3ff0000000000000
	.data
	.globl	camlCode__2
	.quad	1277
camlCode__2:
	.quad	0x4000000000000000
	.data
	.globl	camlCode__3
	.quad	1277
camlCode__3:
	.quad	0x4000000000000000
	.data
	.globl	camlCode__4
	.quad	1277
camlCode__4:
	.quad	0x4008000000000000
	.text
	.align	16
	.globl	camlCode__f_int_1030
camlCode__f_int_1030:
.L102:
	movq	%rax, %rdi
	movq	$1, %rbx
	movq	$1, %rax
	cmpq	$1, %rdi
	je	.L101
	movq	$3, %rbx
	movq	$5, %rax
	jmp	.L100
	.align	4
.L101:
	movq	$5, %rbx
	movq	$7, %rax
.L100:
	leaq	-1(%rbx, %rax), %rax
	ret
	.type	camlCode__f_int_1030,@function
	.size	camlCode__f_int_1030,.-camlCode__f_int_1030
	.text
	.align	16
	.globl	camlCode__f_float_1034
camlCode__f_float_1034:
	subq	$8, %rsp
.L105:
	movq	$1, %rdi
	movq	$1, %rbx
	cmpq	$1, %rax
	je	.L104
	movq	camlCode__1@GOTPCREL(%rip), %rdi
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	jmp	.L103
	.align	4
.L104:
	movq	camlCode__3@GOTPCREL(%rip), %rdi
	movq	camlCode__4@GOTPCREL(%rip), %rbx
.L103:
.L106:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L107
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	movlpd	(%rdi), %xmm0
	addsd	(%rbx), %xmm0
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L107:	call	caml_call_gc@PLT
.L108:	jmp	.L106
	.type	camlCode__f_float_1034,@function
	.size	camlCode__f_float_1034,.-camlCode__f_float_1034
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L109:
	movq	camlCode__6@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__5@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	$1, %rax
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
	.quad	1
	.quad	.L108
	.word	16
	.word	2
	.word	3
	.word	5
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

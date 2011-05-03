

let g (x,y) = x+y
let f x = g (x,x)

module M : sig

  val f : int -> int

end  = struct

  let g (x,y) = x+y
  let f x = g (x,x)

end
(*
-drawlambda
(seq
  (let
    (g/1030
       = (function (param/1042, param/1043)
           (let (y/1032 (=) param/1043 x/1031 (=) param/1042)
             (+ x/1031 y/1032))))
    (setfield_imm 2(inglob) (global Code!) g/1030))
  (let
    (f/1033
       = (function x/1034
           (apply (field 2 (global Code!)) (makeblock 0 x/1034 x/1034))))
    (setfield_imm 0 (global Code!) f/1033))
  (let
    (M/1041
       = (let
           (g/1035
              = (function (param/1044, param/1045)
                  (let (y/1037 (=) param/1045 x/1036 (=) param/1044)
                    (+ x/1036 y/1037)))
            f/1038
              = (function x/1039 (apply g/1035 (makeblock 0 x/1039 x/1039))))
           (makeblock 0 f/1038)))
    (seq (setfield_imm 1 (global Code!) M/1041) 0a)))
Found declaration of intern global g_1030 (counting)
Found declaration of intern global g_1030 (simplifying)
-dlambda
Found declaration of intern global g_1030 (counting)
Found declaration of intern global g_1030 (simplifying)
(seq
  (let
    (f/1033
       = (function x/1034
           (let
             (tuple/1048 = (makeblock 0 x/1034 x/1034)
              param/1043 = (field 1 tuple/1048)
              param/1042 = (field 0 tuple/1048))
             (+ param/1042 param/1043))))
    (setfield_imm 0 (global Code!) f/1033))
  (let
    (M/1041
       = (let
           (f/1038
              = (function x/1039
                  (let
                    (tuple/1047 = (makeblock 0 x/1039 x/1039)
                     param/1045 = (field 1 tuple/1047)
                     param/1044 = (field 0 tuple/1047))
                    (+ param/1044 param/1045))))
           (makeblock 0 f/1038)))
    (seq (setfield_imm 1 (global Code!) M/1041) 0a)))
-dclosure
Found declaration of intern global g_1030 (counting)
Found declaration of intern global g_1030 (simplifying)
*** After closure conversion:
(seq
  (let
    (f/1033 {fun camlCode__f_1033 {1} closed inline -> ?} = 
       (closure (camlCode__f_1033(1)  x/1034
                  (let
                    (tuple/1048 {(?, ?)} =  (makeblock 0 x/1034 x/1034)
                     param/1043 {?} =  (field 1 tuple/1048)
                     param/1042 {?} =  (field 0 tuple/1048))
                    (+ param/1042 param/1043))) {0} ))
    (setfield_imm 0 (global camlCode!) f/1033))
  (let
    (M/1041 {(fun camlCode__f_1038 {1} closed inline -> ?)} = 
       (let
         (f/1038 {fun camlCode__f_1038 {1} closed inline -> ?} = 
            (closure (camlCode__f_1038(1)  x/1039
                       (let
                         (tuple/1047 {(?, ?)} =  (makeblock 0 x/1039 x/1039)
                          param/1045 {?} =  (field 1 tuple/1047)
                          param/1044 {?} =  (field 0 tuple/1047))
                         (+ param/1044 param/1045))) {0} ))
         (makeblock 0 f/1038)))
    (seq (setfield_imm 1 (global camlCode!) M/1041) 0a)))

-dcmm
Found declaration of intern global g_1030 (counting)
Found declaration of intern global g_1030 (simplifying)
(data int 3072 global "camlCode" "camlCode": skip 24)
(data int 2295 "camlCode__1": addr "camlCode__f_1038" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f_1033" int 3)
(function camlCode__f_1033 (x/1034: addr)
 (let
   (tuple/1048 (alloc 2048 x/1034 x/1034) param/1043 (load (+a tuple/1048 8))
    param/1042 (load tuple/1048))
   (+ (+ param/1042 param/1043) -1)))

(function camlCode__f_1038 (x/1039: addr)
 (let
   (tuple/1047 (alloc 2048 x/1039 x/1039) param/1045 (load (+a tuple/1047 8))
    param/1044 (load tuple/1047))
   (+ (+ param/1044 param/1045) -1)))

(function camlCode__entry ()
 (let f/1033 "camlCode__2" (store "camlCode" f/1033))
 (let M/1041 (let f/1038 "camlCode__1" (alloc 1024 f/1038))
   (store (+a "camlCode" 8) M/1041) 1a))

(data)
-dlinear
Found declaration of intern global g_1030 (counting)
Found declaration of intern global g_1030 (simplifying)
*** Linearized code
camlCode__f_1033:
  x/29[%rbx] := R/0[%rax]
  {x/29[%rbx]*}
  tuple/30[%rax] := alloc 24
  [tuple/30[%rax] + -8] := 2048
  [tuple/30[%rax]] := x/29[%rbx]
  [tuple/30[%rax] + 8] := x/29[%rbx]
  param/31[%rbx] := [tuple/30[%rax] + 8]
  param/32[%rax] := [tuple/30[%rax]]
  I/33[%rax] := param/32[%rax] + param/31[%rbx] + -1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__f_1038:
  x/29[%rbx] := R/0[%rax]
  {x/29[%rbx]*}
  tuple/30[%rax] := alloc 24
  [tuple/30[%rax] + -8] := 2048
  [tuple/30[%rax]] := x/29[%rbx]
  [tuple/30[%rax] + 8] := x/29[%rbx]
  param/31[%rbx] := [tuple/30[%rax] + 8]
  param/32[%rax] := [tuple/30[%rax]]
  I/33[%rax] := param/32[%rax] + param/31[%rbx] + -1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  f/29[%rbx] := "camlCode__2"
  A/30[%rax] := "camlCode"
  [A/30[%rax]] := f/29[%rbx]
  f/31[%rdi] := "camlCode__1"
  {f/31[%rdi]*}
  M/32[%rbx] := alloc 16
  [M/32[%rbx] + -8] := 1024
  [M/32[%rbx]] := f/31[%rdi]
  A/33[%rax] := "camlCode"
  [A/33[%rax] + 8] := M/32[%rbx]
  A/34[%rax] := 1
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
	.ascii	"\204\225\246\276\0\0\0\222\0\0\0\22\0\0\0P\0\0\0A\240\300*Pervasives0\333r:\27\230\261\42\340\211\31\242\277\355\6%\24\60\313;C\225C\23-y\15\33H\264\371S\271:\240\4\4@\240\300$Code0\301"
	.ascii	"'\362\253\247\327\200$\250x\20\4*\353\240\272\60\315\64u\342\342d\177\24.\334\237B\326\12r\260\240\4\4@\240\300(Std_exit0K<u\217\27kw\366\203\3\37W\376u\277\312\60\245\15s\177\263x\376\216gr\201\37\265d\355"
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
	.quad	3072
	.globl	camlCode
camlCode:
	.space	24
	.data
	.quad	2295
camlCode__1:
	.quad	camlCode__f_1038
	.quad	3
	.data
	.quad	2295
camlCode__2:
	.quad	camlCode__f_1033
	.quad	3
	.text
	.align	16
	.globl	camlCode__f_1033
camlCode__f_1033:
	subq	$8, %rsp
.L100:
	movq	%rax, %rbx
.L101:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L102
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	%rbx, (%rax)
	movq	%rbx, 8(%rax)
	movq	8(%rax), %rbx
	movq	(%rax), %rax
	leaq	-1(%rax, %rbx), %rax
	addq	$8, %rsp
	ret
.L102:	call	caml_call_gc@PLT
.L103:	jmp	.L101
	.type	camlCode__f_1033,@function
	.size	camlCode__f_1033,.-camlCode__f_1033
	.text
	.align	16
	.globl	camlCode__f_1038
camlCode__f_1038:
	subq	$8, %rsp
.L104:
	movq	%rax, %rbx
.L105:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L106
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	%rbx, (%rax)
	movq	%rbx, 8(%rax)
	movq	8(%rax), %rbx
	movq	(%rax), %rax
	leaq	-1(%rax, %rbx), %rax
	addq	$8, %rsp
	ret
.L106:	call	caml_call_gc@PLT
.L107:	jmp	.L105
	.type	camlCode__f_1038,@function
	.size	camlCode__f_1038,.-camlCode__f_1038
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L108:
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rdi
	call	caml_alloc1@PLT
.L109:
	leaq	8(%r15), %rbx
	movq	$1024, -8(%rbx)
	movq	%rdi, (%rbx)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
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
	.quad	3
	.quad	.L109
	.word	16
	.word	1
	.word	5
	.align	8
	.quad	.L107
	.word	16
	.word	1
	.word	3
	.align	8
	.quad	.L103
	.word	16
	.word	1
	.word	3
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

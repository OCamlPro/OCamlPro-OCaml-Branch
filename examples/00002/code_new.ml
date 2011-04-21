(*

 First, the value of "x" is not inferred as "1". Why ?

 The first "f" takes a tuple as argument. Since the tuple was built
before, and the compiler recognizes only tuples when built on the call
site, it cannot do a direct call. Moreover, the approximation of the result
 (here 1) is not used.

*)

let res1 =
  let f (x,y) = 1 in
  let a = (1+1,2+2) in
  let x = fst a in
    (f a) + x

let res2 =
  let f (x,y) () = 1 in
  let a = (1+1,2+2) in
  let x = fst a in
    (f a ()) + x


let res3 =
  let f (x,y) = 1 in
  let a = (2,4) in
  let x = fst a in
    (f a) + x

let res4 =
  let f x y = 1 in
  let t = [| 0 |] in
  f t.(0) t.(1)

let res5 =
  let t = [| 0 |] in
  if (ignore t.(1); true) then 1 else 2
(*
-drawlambda
(seq
  (let
    (res1/1030
       (let
         (f/1031
            (function (param/1060, param/1061)
              (let (y/1033 param/1061 x/1032 param/1060) 1))
          a/1034 (makeblock 0 (+ 1 1) (+ 2 2))
          x/1035 (field 0 a/1034))
         (+ (apply f/1031 a/1034) x/1035)))
    (setfield_imm 0 (global Code!) res1/1030))
  (let
    (res2/1036
       (let
         (f/1037
            (function param/1062 param/1063
              (let (y/1039 (field 1 param/1062) x/1038 (field 0 param/1062))
                1))
          a/1040 (makeblock 0 (+ 1 1) (+ 2 2))
          x/1041 (field 0 a/1040))
         (+ (apply f/1037 a/1040 0a) x/1041)))
    (setfield_imm 1 (global Code!) res2/1036))
  (let
    (res3/1042
       (let
         (f/1043
            (function (param/1064, param/1065)
              (let (y/1045 param/1065 x/1044 param/1064) 1))
          a/1046 [0: 2 4]
          x/1047 (field 0 a/1046))
         (+ (apply f/1043 a/1046) x/1047)))
    (setfield_imm 2 (global Code!) res3/1042))
  (let
    (res4/1048
       (let (f/1049 (function x/1050 y/1051 1) t/1052 (makearray  0))
         (apply f/1049 (array.get t/1052 0) (array.get t/1052 1))))
    (setfield_imm 3 (global Code!) res4/1048))
  (let
    (res5/1053
       (let (t/1054 (makearray  0))
         (if (seq (ignore (array.get t/1054 1)) 1a) 1 2)))
    (setfield_imm 4 (global Code!) res5/1053))
  0a)
-dlambda
(seq
  (let
    (res1/1030
       (let
         (f/1031 (function (param/1060, param/1061) 1)
          a/1034 (makeblock 0 (+ 1 1) (+ 2 2))
          x/1035 (field 0 a/1034))
         (+ (apply f/1031 a/1034) x/1035)))
    (setfield_imm 0 (global Code!) res1/1030))
  (let
    (res2/1036
       (let
         (f/1037 (function param/1062 param/1063 1)
          a/1040 (makeblock 0 (+ 1 1) (+ 2 2))
          x/1041 (field 0 a/1040))
         (+ (apply f/1037 a/1040 0a) x/1041)))
    (setfield_imm 1 (global Code!) res2/1036))
  (let
    (res3/1042
       (let
         (f/1043 (function (param/1064, param/1065) 1)
          a/1046 [0: 2 4]
          x/1047 (field 0 a/1046))
         (+ (apply f/1043 a/1046) x/1047)))
    (setfield_imm 2 (global Code!) res3/1042))
  (let
    (res4/1048
       (let (f/1049 (function x/1050 y/1051 1) t/1052 (makearray  0))
         (apply f/1049 (array.get t/1052 0) (array.get t/1052 1))))
    (setfield_imm 3 (global Code!) res4/1048))
  (let
    (res5/1053
       (let (t/1054 (makearray  0))
         (if (seq (ignore (array.get t/1054 1)) 1a) 1 2)))
    (setfield_imm 4 (global Code!) res5/1053))
  0a)
-dclosure
*** After closure conversion:
(seq
  (let
    (res1/1030 {int 3} = 
       (let
         (f/1031 {fun camlCode__f_1031 {-2} closed inline -> int 1} = 
            (closure (camlCode__f_1031(-2)  param/1060 param/1061 1) {0} )
          a/1034 {(int 2, int 4)} =  (makeblock 0 2 4))
         3))
    (setfield_imm 0 (global camlCode!) 3))
  (let
    (res2/1036 {int 3} = 
       (let
         (f/1037 {fun camlCode__f_1037 {2} closed inline -> int 1} = 
            (closure (camlCode__f_1037(2)  param/1062 param/1063 1) {0} )
          a/1040 {(int 2, int 4)} =  (makeblock 0 2 4))
         3))
    (setfield_imm 1 (global camlCode!) 3))
  (let
    (res3/1042 {int 3} = 
       (let
         (f/1043 {fun camlCode__f_1043 {-2} closed inline -> int 1} = 
            (closure (camlCode__f_1043(-2)  param/1064 param/1065 1) {0} )
          a/1046 {(int 2, int 4)} =  [0: 2 4])
         3))
    (setfield_imm 2 (global camlCode!) 3))
  (let
    (res4/1048 {int 1} = 
       (let
         (f/1049 {fun camlCode__f_1049 {2} closed inline -> int 1} = 
            (closure (camlCode__f_1049(2)  x/1050 y/1051 1) {0} )
          t/1052 {?} =  (makearray  0))
         (seq (array.get t/1052 1) (array.get t/1052 0) 1)))
    (setfield_imm 3 (global camlCode!) 1))
  (let
    (res5/1053 {int 1} = 
       (let (t/1054 {?} =  (makearray  0))
         (seq (seq (ignore (array.get t/1054 1)) 1a) 1)))
    (setfield_imm 4 (global camlCode!) 1))
  0a)

-dcmm
(data int 5120 global "camlCode" "camlCode": skip 40)
(data
 int 3319
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__f_1049")
(data
 int 3319
 "camlCode__3":
 addr "caml_tuplify2"
 int -3
 addr "camlCode__f_1043")
(data
 int 3319
 "camlCode__4":
 addr "caml_curry2"
 int 5
 addr "camlCode__f_1037")
(data
 int 3319
 "camlCode__5":
 addr "caml_tuplify2"
 int -3
 addr "camlCode__f_1031")
(data global "camlCode__1" int 2048 "camlCode__1": int 5 int 9)
(function camlCode__f_1031 (param/1060: addr param/1061: addr) 3)

(function camlCode__f_1037 (param/1062: addr param/1063: addr) 3)

(function camlCode__f_1043 (param/1064: addr param/1065: addr) 3)

(function camlCode__f_1049 (x/1050: addr y/1051: addr) 3)

(function camlCode__entry ()
 (let res1/1030 (let (f/1031 "camlCode__5" a/1034 (alloc 2048 5 9)) 7)
   (store "camlCode" 7))
 (let res2/1036 (let (f/1037 "camlCode__4" a/1040 (alloc 2048 5 9)) 7)
   (store (+a "camlCode" 8) 7))
 (let res3/1042 (let (f/1043 "camlCode__3" a/1046 "camlCode__1") 7)
   (store (+a "camlCode" 16) 7))
 (let
   res4/1048
     (let (f/1049 "camlCode__2" t/1052 (alloc 1024 1))
       (checkbound (>>u (load (+a t/1052 -8)) 9) 3) (load (+a t/1052 8)) 
       [] (checkbound (>>u (load (+a t/1052 -8)) 9) 1) (load t/1052) 
       [] 3)
   (store (+a "camlCode" 24) 3))
 (let
   res5/1053
     (let t/1054 (alloc 1024 1) (checkbound (>>u (load (+a t/1054 -8)) 9) 3)
       (load (+a t/1054 8)) [] 3a [] 3)
   (store (+a "camlCode" 32) 3))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__f_1031:
  I/31[%rax] := 3
  return R/0[%rax]
  
*** Linearized code
camlCode__f_1037:
  I/31[%rax] := 3
  return R/0[%rax]
  
*** Linearized code
camlCode__f_1043:
  I/31[%rax] := 3
  return R/0[%rax]
  
*** Linearized code
camlCode__f_1049:
  I/31[%rax] := 3
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  f/29[%rax] := "camlCode__5"
  {}
  a/30[%rax] := alloc 80
  [a/30[%rax] + -8] := 2048
  [a/30[%rax]] := 5
  [a/30[%rax] + 8] := 9
  res1/31[%rbx] := 7
  A/32[%rbx] := "camlCode"
  [A/32[%rbx]] := 7
  f/33[%rbx] := "camlCode__4"
  a/34[%rbx] := a/30[%rax] + 24
  [a/34[%rbx] + -8] := 2048
  [a/34[%rbx]] := 5
  [a/34[%rbx] + 8] := 9
  res2/35[%rbx] := 7
  A/36[%rbx] := "camlCode"
  [A/36[%rbx] + 8] := 7
  f/37[%rbx] := "camlCode__3"
  a/38[%rbx] := "camlCode__1"
  res3/39[%rbx] := 7
  A/40[%rbx] := "camlCode"
  [A/40[%rbx] + 16] := 7
  f/41[%rbx] := "camlCode__2"
  t/42[%rdi] := a/30[%rax] + 48
  [t/42[%rdi] + -8] := 1024
  [t/42[%rdi]] := 1
  A/43[%rbx] := [t/42[%rdi] + -8]
  I/44[%rbx] := I/44[%rbx] >>u 9
  I/44[%rbx] check > 3
  A/45[%rbx] := [t/42[%rdi] + 8]
  A/46[%rbx] := [t/42[%rdi] + -8]
  I/47[%rbx] := I/47[%rbx] >>u 9
  I/47[%rbx] check > 1
  A/48[%rbx] := [t/42[%rdi]]
  res4/49[%rbx] := 3
  A/50[%rbx] := "camlCode"
  [A/50[%rbx] + 24] := 3
  t/51[%rbx] := a/30[%rax] + 64
  [t/51[%rbx] + -8] := 1024
  [t/51[%rbx]] := 1
  A/52[%rax] := [t/51[%rbx] + -8]
  I/53[%rax] := I/53[%rax] >>u 9
  I/53[%rax] check > 3
  A/54[%rax] := [t/51[%rbx] + 8]
  A/55[%rax] := 3
  res5/56[%rax] := 3
  A/57[%rax] := "camlCode"
  [A/57[%rax] + 32] := 3
  A/58[%rax] := 1
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
	.globl	caml_tuplify2
caml_tuplify2:
.L134:
	movq	%rbx, %rdi
	movq	8(%rax), %rbx
	movq	(%rax), %rax
	movq	16(%rdi), %rsi
	jmp	*%rsi
	.type	caml_tuplify2,@function
	.size	caml_tuplify2,.-caml_tuplify2
	.text
	.align	16
	.globl	caml_apply3
caml_apply3:
	subq	$24, %rsp
.L136:
	movq	8(%rsi), %rdx
	cmpq	$7, %rdx
	jne	.L135
	movq	16(%rsi), %rdx
	addq	$24, %rsp
	jmp	*%rdx
	.align	4
.L135:
	movq	%rdi, 8(%rsp)
	movq	%rbx, 0(%rsp)
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L137:
	movq	%rax, %rbx
	movq	(%rbx), %rdi
	movq	0(%rsp), %rax
	call	*%rdi
.L138:
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
.L140:
	movq	8(%rdi), %rsi
	cmpq	$5, %rsi
	jne	.L139
	movq	16(%rdi), %rsi
	addq	$8, %rsp
	jmp	*%rsi
	.align	4
.L139:
	movq	%rbx, 0(%rsp)
	movq	(%rdi), %rsi
	movq	%rdi, %rbx
	call	*%rsi
.L141:
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
	.ascii	"\204\225\246\276\0\0\0\222\0\0\0\22\0\0\0P\0\0\0A\240\300*Pervasives0\333r:\27\230\261\42\340\211\31\242\277\355\6%\24\60\206a\215\30\215\237&\216q\354F\331\70\37\7o\240\4\4@\240\300$Code0A"
	.ascii	"\323J\237\246\42f\252Jl;\274\347%\11\375\60\264\214\30\274dR\232\37\23\223\350\362\67E\34\26\240\4\4@\240\300(Std_exit0K<u\217\27kw\366\203\3\37W\376u\277\312\60\257\360\364\20\22\333\352jO\274\306\27\366\360\370"
	.ascii	"[\240\4\4@@"
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
	.quad	.L141
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L138
	.word	32
	.word	1
	.word	8
	.align	8
	.quad	.L137
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
	.quad	5120
	.globl	camlCode
camlCode:
	.space	40
	.data
	.quad	3319
camlCode__2:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__f_1049
	.data
	.quad	3319
camlCode__3:
	.quad	caml_tuplify2
	.quad	-3
	.quad	camlCode__f_1043
	.data
	.quad	3319
camlCode__4:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__f_1037
	.data
	.quad	3319
camlCode__5:
	.quad	caml_tuplify2
	.quad	-3
	.quad	camlCode__f_1031
	.data
	.globl	camlCode__1
	.quad	2048
camlCode__1:
	.quad	5
	.quad	9
	.text
	.align	16
	.globl	camlCode__f_1031
camlCode__f_1031:
.L100:
	movq	$3, %rax
	ret
	.type	camlCode__f_1031,@function
	.size	camlCode__f_1031,.-camlCode__f_1031
	.text
	.align	16
	.globl	camlCode__f_1037
camlCode__f_1037:
.L101:
	movq	$3, %rax
	ret
	.type	camlCode__f_1037,@function
	.size	camlCode__f_1037,.-camlCode__f_1037
	.text
	.align	16
	.globl	camlCode__f_1043
camlCode__f_1043:
.L102:
	movq	$3, %rax
	ret
	.type	camlCode__f_1043,@function
	.size	camlCode__f_1043,.-camlCode__f_1043
	.text
	.align	16
	.globl	camlCode__f_1049
camlCode__f_1049:
.L103:
	movq	$3, %rax
	ret
	.type	camlCode__f_1049,@function
	.size	camlCode__f_1049,.-camlCode__f_1049
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L104:
	movq	camlCode__5@GOTPCREL(%rip), %rax
	movq	$80, %rax
	call	caml_allocN@PLT
.L105:
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	$5, (%rax)
	movq	$9, 8(%rax)
	movq	$7, %rbx
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	$7, (%rbx)
	movq	camlCode__4@GOTPCREL(%rip), %rbx
	leaq	24(%rax), %rbx
	movq	$2048, -8(%rbx)
	movq	$5, (%rbx)
	movq	$9, 8(%rbx)
	movq	$7, %rbx
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	$7, 8(%rbx)
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	movq	$7, %rbx
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	$7, 16(%rbx)
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	leaq	48(%rax), %rdi
	movq	$1024, -8(%rdi)
	movq	$1, (%rdi)
	movq	-8(%rdi), %rbx
	shrq	$9, %rbx
	cmpq	$3, %rbx
	jbe	.L106
	movq	8(%rdi), %rbx
	movq	-8(%rdi), %rbx
	shrq	$9, %rbx
	cmpq	$1, %rbx
	jbe	.L106
	movq	(%rdi), %rbx
	movq	$3, %rbx
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	$3, 24(%rbx)
	leaq	64(%rax), %rbx
	movq	$1024, -8(%rbx)
	movq	$1, (%rbx)
	movq	-8(%rbx), %rax
	shrq	$9, %rax
	cmpq	$3, %rax
	jbe	.L106
	movq	8(%rbx), %rax
	movq	$3, %rax
	movq	$3, %rax
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	$3, 32(%rax)
	movq	$1, %rax
	addq	$8, %rsp
	ret
.L106:	call	caml_ml_array_bound_error@PLT
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
	.quad	.L105
	.word	16
	.word	0
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

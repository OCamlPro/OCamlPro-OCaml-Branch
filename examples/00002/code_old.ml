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

-dcmm
(data int 5120 global "camlCode" "camlCode": skip 40)
(data
 int 3319
 "camlCode__1":
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
(data int 2048 "camlCode__2": int 5 int 9)
(function camlCode__f_1031 (param/1060: addr param/1061: addr) 3)

(function camlCode__f_1037 (param/1062: addr param/1063: addr) 3)

(function camlCode__f_1043 (param/1064: addr param/1065: addr) 3)

(function camlCode__f_1049 (x/1050: addr y/1051: addr) 3)

(function camlCode__entry ()
 (let
   res1/1030
     (let (f/1031 "camlCode__5" a/1034 (alloc 2048 5 9))
       (+ (app (load f/1031) a/1034 f/1031 addr) 4))
   (store "camlCode" res1/1030))
 (let res2/1036 (let (f/1037 "camlCode__4" a/1040 (alloc 2048 5 9)) 7)
   (store (+a "camlCode" 8) 7))
 (let
   res3/1042
     (let (f/1043 "camlCode__3" a/1046 "camlCode__2" x/1047 (load a/1046))
       (+ (+ (app (load f/1043) a/1046 f/1043 addr) x/1047) -1))
   (store (+a "camlCode" 16) res3/1042))
 (let
   res4/1048
     (let (f/1049 "camlCode__1" t/1052 (alloc 1024 1))
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
  f/29[%rbx] := "camlCode__5"
  {f/29[%rbx]*}
  a/30[%rax] := alloc 24
  [a/30[%rax] + -8] := 2048
  [a/30[%rax]] := 5
  [a/30[%rax] + 8] := 9
  A/31[%rdi] := [f/29[%rbx]]
  {}
  R/0[%rax] := call A/31[%rdi] R/0[%rax] R/1[%rbx]
  res1/33[%rax] := res1/33[%rax] + 4
  A/34[%rbx] := "camlCode"
  [A/34[%rbx]] := res1/33[%rax]
  f/35[%rax] := "camlCode__4"
  {}
  a/36[%rax] := alloc 24
  [a/36[%rax] + -8] := 2048
  [a/36[%rax]] := 5
  [a/36[%rax] + 8] := 9
  res2/37[%rax] := 7
  A/38[%rax] := "camlCode"
  [A/38[%rax] + 8] := 7
  f/39[%rbx] := "camlCode__3"
  a/40[%rax] := "camlCode__2"
  x/41[%rdi] := [a/40[%rax]]
  spilled-x/65[s0] := x/41[%rdi] (spill)
  A/42[%rdi] := [f/39[%rbx]]
  {spilled-x/65[s0]*}
  R/0[%rax] := call A/42[%rdi] R/0[%rax] R/1[%rbx]
  x/66[%rbx] := spilled-x/65[s0] (reload)
  I/44[%rax] := I/44[%rax] + x/66[%rbx]
  res3/45[%rax] := res3/45[%rax] + -1
  A/46[%rbx] := "camlCode"
  [A/46[%rbx] + 16] := res3/45[%rax]
  f/47[%rax] := "camlCode__1"
  {}
  t/48[%rbx] := alloc 32
  [t/48[%rbx] + -8] := 1024
  [t/48[%rbx]] := 1
  A/49[%rax] := [t/48[%rbx] + -8]
  I/50[%rax] := I/50[%rax] >>u 9
  I/50[%rax] check > 3
  A/51[%rax] := [t/48[%rbx] + 8]
  A/52[%rax] := [t/48[%rbx] + -8]
  I/53[%rax] := I/53[%rax] >>u 9
  I/53[%rax] check > 1
  A/54[%rax] := [t/48[%rbx]]
  res4/55[%rax] := 3
  A/56[%rax] := "camlCode"
  [A/56[%rax] + 24] := 3
  t/57[%rbx] := t/48[%rbx] + 16
  [t/57[%rbx] + -8] := 1024
  [t/57[%rbx]] := 1
  A/58[%rax] := [t/57[%rbx] + -8]
  I/59[%rax] := I/59[%rax] >>u 9
  I/59[%rax] check > 3
  A/60[%rax] := [t/57[%rbx] + 8]
  A/61[%rax] := 3
  res5/62[%rax] := 3
  A/63[%rax] := "camlCode"
  [A/63[%rax] + 32] := 3
  A/64[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
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
camlCode__1:
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
	.quad	2048
camlCode__2:
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
	movq	camlCode__5@GOTPCREL(%rip), %rbx
	call	caml_alloc2@PLT
.L105:
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	$5, (%rax)
	movq	$9, 8(%rax)
	movq	(%rbx), %rdi
	call	*%rdi
.L106:
	addq	$4, %rax
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	%rax, (%rbx)
	movq	camlCode__4@GOTPCREL(%rip), %rax
	call	caml_alloc2@PLT
.L107:
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	$5, (%rax)
	movq	$9, 8(%rax)
	movq	$7, %rax
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	$7, 8(%rax)
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	camlCode__2@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	movq	%rdi, 0(%rsp)
	movq	(%rbx), %rdi
	call	*%rdi
.L108:
	movq	0(%rsp), %rbx
	addq	%rbx, %rax
	decq	%rax
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	%rax, 16(%rbx)
	movq	camlCode__1@GOTPCREL(%rip), %rax
	call	caml_alloc3@PLT
.L109:
	leaq	8(%r15), %rbx
	movq	$1024, -8(%rbx)
	movq	$1, (%rbx)
	movq	-8(%rbx), %rax
	shrq	$9, %rax
	cmpq	$3, %rax
	jbe	.L110
	movq	8(%rbx), %rax
	movq	-8(%rbx), %rax
	shrq	$9, %rax
	cmpq	$1, %rax
	jbe	.L110
	movq	(%rbx), %rax
	movq	$3, %rax
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	$3, 24(%rax)
	addq	$16, %rbx
	movq	$1024, -8(%rbx)
	movq	$1, (%rbx)
	movq	-8(%rbx), %rax
	shrq	$9, %rax
	cmpq	$3, %rax
	jbe	.L110
	movq	8(%rbx), %rax
	movq	$3, %rax
	movq	$3, %rax
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	$3, 32(%rax)
	movq	$1, %rax
	addq	$8, %rsp
	ret
.L110:	call	caml_ml_array_bound_error@PLT
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
	.quad	.L109
	.word	16
	.word	0
	.align	8
	.quad	.L108
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L107
	.word	16
	.word	0
	.align	8
	.quad	.L106
	.word	16
	.word	0
	.align	8
	.quad	.L105
	.word	16
	.word	1
	.word	3
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

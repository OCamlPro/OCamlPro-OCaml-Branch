(*

 First, the value of "x" is not inferred as "1". Why ?

 The first "f" takes a tuple as argument. Since the tuple was built
before, and the compiler recognizes only tuples when built on the call
site, it cannot do a direct call. Moreover, the approximation of the result
 (here 1) is not used.

*)

let _ =
  let f (x,y) = 1 in
  let a = (1,2) in
  let x = fst a in
    (f a) + x

let _ =
  let f (x,y) () = 1 in
  let a = (1,2) in
  let x = fst a in
    (f a ()) + x
(*
-drawlambda
(seq
  (let
    (f/1030
       (function (param/1042, param/1043)
         (let (y/1032 param/1043 x/1031 param/1042) 1))
     a/1033 [0: 1 2]
     x/1034 (field 0 a/1033))
    (+ (apply f/1030 a/1033) x/1034))
  (let
    (f/1035
       (function param/1040 param/1041
         (let (y/1037 (field 1 param/1040) x/1036 (field 0 param/1040)) 1))
     a/1038 [0: 1 2]
     x/1039 (field 0 a/1038))
    (+ (apply f/1035 a/1038 0a) x/1039))
  0a)
lambda saved
typedtree saved
-dlambda
(seq
  (let
    (f/1030 (function (param/1042, param/1043) 1)
     a/1033 [0: 1 2]
     x/1034 (field 0 a/1033))
    (+ (apply f/1030 a/1033) x/1034))
  (let
    (f/1035 (function param/1040 param/1041 1)
     a/1038 [0: 1 2]
     x/1039 (field 0 a/1038))
    (+ (apply f/1035 a/1038 0a) x/1039))
  0a)
 After TonLambda.optimize (0 eliminations): 
 (seq
   (let
     (f/1030 (function (param/1042, param/1043) 1)
      a/1033 [0: 1 2]
      x/1034 (field 0 a/1033))
     (+ (apply f/1030 a/1033) x/1034))
   (let
     (f/1035 (function param/1040 param/1041 1)
      a/1038 [0: 1 2]
      x/1039 (field 0 a/1038))
     (+ (apply f/1035 a/1038 0a) x/1039))
   0a)
lambda saved
typedtree saved
-dclosure
(seq
  (let
    (f/1030 (closure (camlCode__f_1030(-2)  param/1042 param/1043 1) )
     a/1033 [0: 1 2])
    (+ (let (arg/1045 a/1033) (seq 2 1 1)) 1))
  (let
    (f/1035 (closure (camlCode__f_1035(2)  param/1040 param/1041 1) )
     a/1038 [0: 1 2])
    2)
  0a)(seq
       (let
         (f/1030 (closure (camlCode__f_1030(-2)  param/1042 param/1043 1) )
          a/1033 [0: 1 2])
         (+ (let (arg/1045 a/1033) (seq 2 1 1)) 1))
       (let
         (f/1035 (closure (camlCode__f_1035(2)  param/1040 param/1041 1) )
          a/1038 [0: 1 2])
         2)lambda saved
typedtree saved

-dcmm
(data int 0 global "camlCode" "camlCode": skip 0)
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__f_1035")
(data
 int 3319
 "camlCode__4":
 addr "caml_tuplify2"
 int -3
 addr "camlCode__f_1030")
(data global "camlCode__1" int 2048 "camlCode__1": int 3 int 5)
(data global "camlCode__2" int 2048 "camlCode__2": int 3 int 5)
(function camlCode__f_1030 (param/1042: addr param/1043: addr) 3)

(function camlCode__f_1035 (param/1040: addr param/1041: addr) 3)

(function camlCode__entry ()
 (let (f/1030 "camlCode__4" a/1033 "camlCode__1")
   (+ (let arg/1045 a/1033 5 [] 3 [] 3) 2) [])
 (let (f/1035 "camlCode__3" a/1038 "camlCode__2") 5 []) 1a)

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
	.quad	0
	.globl	camlCode
camlCode:
	.data
	.quad	3319
camlCode__3:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__f_1035
	.data
	.quad	3319
camlCode__4:
	.quad	caml_tuplify2
	.quad	-3
	.quad	camlCode__f_1030
	.data
	.globl	camlCode__1
	.quad	2048
camlCode__1:
	.quad	3
	.quad	5
	.data
	.globl	camlCode__2
	.quad	2048
camlCode__2:
	.quad	3
	.quad	5
	.text
	.align	16
	.globl	camlCode__f_1030
camlCode__f_1030:
.L100:
	movq	$3, %rax
	ret
	.type	camlCode__f_1030,@function
	.size	camlCode__f_1030,.-camlCode__f_1030
	.text
	.align	16
	.globl	camlCode__f_1035
camlCode__f_1035:
.L101:
	movq	$3, %rax
	ret
	.type	camlCode__f_1035,@function
	.size	camlCode__f_1035,.-camlCode__f_1035
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L102:
	movq	camlCode__4@GOTPCREL(%rip), %rax
	movq	camlCode__1@GOTPCREL(%rip), %rax
	movq	$5, %rax
	movq	$3, %rax
	movq	$3, %rax
	addq	$2, %rax
	movq	camlCode__3@GOTPCREL(%rip), %rax
	movq	camlCode__2@GOTPCREL(%rip), %rax
	movq	$5, %rax
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
	.quad	0
	.section .note.GNU-stack,"",%progbits
*)

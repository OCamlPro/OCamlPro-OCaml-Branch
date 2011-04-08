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
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
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
-dclosure
*** After Closure.intro:
(seq
  (let
    (f/1030 (closure (camlCode__f_1030(-2)  param/1042 param/1043 1) {3} )
     a/1033 [0: 1 2])
    (+ (let (arg/1045 a/1033) (seq (field 1 arg/1045) (field 0 arg/1045) 1))
      1))
  (let
    (f/1035 (closure (camlCode__f_1035(2)  param/1040 param/1041 1) {3} )
     a/1038 [0: 1 2])
    2)
  0a)
*** After TonClosure.optimize:
(seq (+ (seq 2 1 1) 1) 2 0a)

-dcmm
(data int 0 global "camlCode" "camlCode": skip 0)
(data global "camlCode__1" int 2048 "camlCode__1": int 3 int 5)
(data global "camlCode__2" int 2048 "camlCode__2": int 3 int 5)
(function camlCode__entry () (+ (seq 5 [] 3 [] 3) 2) [] 5 [] 1a)

(data)
-dlinear
Before simplify
camlCode__entry:
                  I/8[%eax] := 5
                  I/9[%eax] := 3
                  I/10[%eax] := 3
                  I/11[%eax] := I/11[%eax] + 2
                  I/12[%eax] := 5
                  A/13[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  I/8[%eax] := 5
  I/9[%eax] := 3
  I/10[%eax] := 3
  I/11[%eax] := I/11[%eax] + 2
  I/12[%eax] := 5
  A/13[%eax] := 1
  return R/0[%eax]
  
-S
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.long	0
	.globl	camlCode
camlCode:
	.data
	.globl	camlCode__1
	.long	2048
camlCode__1:
	.long	3
	.long	5
	.data
	.globl	camlCode__2
	.long	2048
camlCode__2:
	.long	3
	.long	5
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L100:
	movl	$5, %eax
	movl	$3, %eax
	movl	$3, %eax
	addl	$2, %eax
	movl	$5, %eax
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
	.long	0

	.section .note.GNU-stack,"",%progbits
*)

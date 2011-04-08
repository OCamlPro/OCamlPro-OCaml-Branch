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
    (f/58
       (function (param/70, param/71) (let (y/60 param/71 x/59 param/70) 1))
     a/61 [0: 1 2]
     x/62 (field 0 a/61))
    (+ (apply f/58 a/61) x/62))
  (let
    (f/63
       (function param/68 param/69
         (let (y/65 (field 1 param/68) x/64 (field 0 param/68)) 1))
     a/66 [0: 1 2]
     x/67 (field 0 a/66))
    (+ (apply f/63 a/66 0a) x/67))
  0a)
-dlambda
(seq
  (let
    (f/58 (function (param/70, param/71) 1)
     a/61 [0: 1 2]
     x/62 (field 0 a/61))
    (+ (apply f/58 a/61) x/62))
  (let
    (f/63 (function param/68 param/69 1) a/66 [0: 1 2] x/67 (field 0 a/66))
    (+ (apply f/63 a/66 0a) x/67))
  0a)

-dcmm
(data int 0 global "camlCode" "camlCode": skip 0)
(data int 3319 "camlCode__2": addr "caml_curry2" int 5 addr "camlCode__f_63")
(data
 int 3319
 "camlCode__4":
 addr "caml_tuplify2"
 int -3
 addr "camlCode__f_58")
(data int 2048 "camlCode__1": int 3 int 5)
(data int 2048 "camlCode__3": int 3 int 5)
(function camlCode__f_58 (param/70: addr param/71: addr) 3)

(function camlCode__f_63 (param/68: addr param/69: addr) 3)

(function camlCode__entry ()
 (let (f/58 "camlCode__4" a/61 "camlCode__3" x/62 (load a/61))
   (+ (+ (app (load f/58) a/61 f/58 addr) x/62) -1) [])
 (let (f/63 "camlCode__2" a/66 "camlCode__1" x/67 (load a/66)) (+ x/67 2) [])
 1a)

(data)
-dlinear
*** Linearized code
camlCode__f_58:
  I/10[%eax] := 3
  return R/0[%eax]
  
*** Linearized code
camlCode__f_63:
  I/10[%eax] := 3
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  f/8[%ebx] := "camlCode__4"
  a/9[%eax] := "camlCode__3"
  x/10[%ecx] := [a/9[%eax]]
  spilled-x/20[s0] := x/10[%ecx] (spill)
  A/11[%ecx] := [f/8[%ebx]]
  {spilled-x/20[s0]*}
  R/0[%eax] := call A/11[%ecx] R/0[%eax] R/1[%ebx]
  x/21[%ebx] := spilled-x/20[s0] (reload)
  I/13[%eax] := I/13[%eax] + x/21[%ebx]
  I/14[%eax] := I/14[%eax] + -1
  f/15[%eax] := "camlCode__2"
  a/16[%eax] := "camlCode__1"
  x/17[%eax] := [a/16[%eax]]
  I/18[%eax] := I/18[%eax] + 2
  A/19[%eax] := 1
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
	.long	0
	.globl	camlCode
camlCode:
	.data
	.long	3319
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__f_63
	.data
	.long	3319
camlCode__4:
	.long	caml_tuplify2
	.long	-3
	.long	camlCode__f_58
	.data
	.long	2048
camlCode__1:
	.long	3
	.long	5
	.data
	.long	2048
camlCode__3:
	.long	3
	.long	5
	.text
	.align	16
	.globl	camlCode__f_58
camlCode__f_58:
.L100:
	movl	$3, %eax
	ret
	.type	camlCode__f_58,@function
	.size	camlCode__f_58,.-camlCode__f_58
	.text
	.align	16
	.globl	camlCode__f_63
camlCode__f_63:
.L101:
	movl	$3, %eax
	ret
	.type	camlCode__f_63,@function
	.size	camlCode__f_63,.-camlCode__f_63
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$4, %esp
.L102:
	movl	$camlCode__4, %ebx
	movl	$camlCode__3, %eax
	movl	(%eax), %ecx
	movl	%ecx, 0(%esp)
	movl	(%ebx), %ecx
	call	*%ecx
.L103:
	movl	0(%esp), %ebx
	addl	%ebx, %eax
	decl	%eax
	movl	$camlCode__2, %eax
	movl	$camlCode__1, %eax
	movl	(%eax), %eax
	addl	$2, %eax
	movl	$1, %eax
	addl	$4, %esp
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
	.long	1
	.long	.L103
	.word	8
	.word	1
	.word	0
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

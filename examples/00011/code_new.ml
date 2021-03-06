(*
This example shows that:
- the constant "2." appears 4 times inside the assembly code
- there is no simplification of computations on floating point numbers
- it also shows that litteral strings are allocated in static memory, while references are
    dynamically allocated, although both data types are mutable.
*)

let f x =
  let x = x +. 2. in
  let x = x +. 2. in
  let x = x *. 2. in
  let x = x /. 2. in
    x

let a = 1L
let b = 1L
let c = 2L

let _ =
  let s = "123" in
    s.[0] <- '0'

let x = ref 2
(*
-drawlambda
(seq
  (let
    (f/1030
       (function x/1031
         (let
           (x/1032 (+. x/1031 2.)
            x/1033 (+. x/1032 2.)
            x/1034 (*. x/1033 2.)
            x/1035 (/. x/1034 2.))
           x/1035)))
    (setfield_imm 0 (global Code!) f/1030))
  (let (a/1036 1L) (setfield_imm 1 (global Code!) a/1036))
  (let (b/1037 1L) (setfield_imm 2 (global Code!) b/1037))
  (let (c/1038 2L) (setfield_imm 3 (global Code!) c/1038))
  (let (s/1039 "123") (string.set s/1039 0 '0'))
  (let (x/1040 (makemutable 0 2)) (setfield_imm 4 (global Code!) x/1040)) 0a)
-dlambda
(seq
  (let
    (f/1030
       (function x/1031
         (let
           (x/1032 (+. x/1031 2.)
            x/1033 (+. x/1032 2.)
            x/1034 (*. x/1033 2.)
            x/1035 (/. x/1034 2.))
           x/1035)))
    (setfield_imm 0 (global Code!) f/1030))
  (let (a/1036 1L) (setfield_imm 1 (global Code!) a/1036))
  (let (b/1037 1L) (setfield_imm 2 (global Code!) b/1037))
  (let (c/1038 2L) (setfield_imm 3 (global Code!) c/1038))
  (let (s/1039 "123") (string.set s/1039 0 '0'))
  (let (x/1040 (makemutable 0 2)) (setfield_imm 4 (global Code!) x/1040)) 0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (f/1030
       (function x/1031
         (let
           (x/1032 (+. x/1031 2.)
            x/1033 (+. x/1032 2.)
            x/1034 (*. x/1033 2.)
            x/1035 (/. x/1034 2.))
           x/1035)))
    (setfield_imm 0 (global Code!) f/1030))
  (let (a/1036 1L) (setfield_imm 1 (global Code!) a/1036))
  (let (b/1037 1L) (setfield_imm 2 (global Code!) b/1037))
  (let (c/1038 2L) (setfield_imm 3 (global Code!) c/1038))
  (let (s/1039 "123") (string.set s/1039 0 '0'))
  (let (x/1040 (makemutable 0 2)) (setfield_imm 4 (global Code!) x/1040)) 0a)
-dclosure
*** After Closure.intro:
(seq
  (let
    (f/1030
       (closure (camlCode__f_1030(1)  x/1031
                  (let
                    (x/1032 (+. x/1031 2.)
                     x/1033 (+. x/1032 2.)
                     x/1034 (*. x/1033 2.)
                     x/1035 (/. x/1034 2.))
                    x/1035)) {2} ))
    (setfield_imm 0 (global camlCode!) f/1030))
  (let (a/1036 1L) (setfield_imm 1 (global camlCode!) a/1036))
  (let (b/1037 1L) (setfield_imm 2 (global camlCode!) b/1037))
  (let (c/1038 2L) (setfield_imm 3 (global camlCode!) c/1038))
  (let (s/1039 "123") (string.set s/1039 0 '0'))
  (let (x/1040 (makemutable 0 2)) (setfield_imm 4 (global camlCode!) x/1040))
  0a)
*** After TonClosure.optimize:
(let
  (f/1030
     (closure (camlCode__f_1030(1)  x/1031
                (let
                  (x/1032 (+. x/1031 2.)
                   x/1033 (+. x/1032 2.)
                   x/1034 (*. x/1033 2.)
                   x/1035 (/. x/1034 2.))
                  x/1035)) {2} ))
  (seq (setfield_imm 0 (global camlCode!) f/1030)
    (let (a/1036 1L)
      (seq (setfield_imm 1 (global camlCode!) a/1036)
        (let (b/1037 1L)
          (seq (setfield_imm 2 (global camlCode!) b/1037)
            (let (c/1038 2L)
              (seq (setfield_imm 3 (global camlCode!) c/1038)
                (let (s/1039 "123")
                  (seq (string.set s/1039 0 '0')
                    (let (x/1040 (makemutable 0 2))
                      (seq (setfield_imm 4 (global camlCode!) x/1040) 0a))))))))))))

-dcmm
(data int 5120 global "camlCode" "camlCode": skip 20)
(data int 2295 "camlCode__5": addr "camlCode__f_1030" int 3)
(data
 global "camlCode__1"
 int 1276
 "camlCode__1":
 string "123"
 skip 0
 byte 0)
(data int 3327 "camlCode__2": addr "caml_int64_ops" int 2 int 0)
(data int 3327 "camlCode__3": addr "caml_int64_ops" int 1 int 0)
(data int 3327 "camlCode__4": addr "caml_int64_ops" int 1 int 0)
(function camlCode__f_1030 (x/1031: addr)
 (let
   (x/1048 (+f (load float64u x/1031) 2.) x/1049 (+f x/1048 2.)
    x/1050 (*f x/1049 2.) x/1051 (/f x/1050 2.) x/1035 (alloc 2301 x/1051))
   x/1035))

(function camlCode__entry ()
 (let f/1030 "camlCode__5" (store "camlCode" f/1030)
   (let a/1036 "camlCode__4" (store (+a "camlCode" 4) a/1036)
     (let b/1037 "camlCode__3" (store (+a "camlCode" 8) b/1037)
       (let c/1038 "camlCode__2" (store (+a "camlCode" 12) c/1038)
         (let s/1039 "camlCode__1"
           (checkbound
             (let tmp/1047 (- (<< (>>u (load (+a s/1039 -4)) 10) 2) 1)
               (- tmp/1047 (load unsigned int8 (+a s/1039 tmp/1047))))
             0)
           (store unsigned int8 (+ s/1039 0) 48)
           (let x/1040 (alloc 1024 5) (store (+a "camlCode" 16) x/1040) 1a)))))))

(data)
-dlinear
Before simplify
camlCode__f_1030:
                  R/7[%tos] := 2.
                  R/7[%tos] := R/7[%tos] +f float64[x/8[%eax]]
                  x/11[s0] := R/7[%tos]
                  R/7[%tos] := 2.
                  R/7[%tos] := x/11[s0] +f R/7[%tos]
                  x/14[s0] := R/7[%tos]
                  R/7[%tos] := 2.
                  R/7[%tos] := x/14[s0] *f R/7[%tos]
                  x/17[s0] := R/7[%tos]
                  R/7[%tos] := 2.
                  R/7[%tos] := x/17[s0] /f R/7[%tos]
                  x/20[s0] := R/7[%tos]
                  {x/20[s0]}
                  x/21[%eax] := alloc 12
                  [x/21[%eax] + -4] := 2301
                  float64u[x/21[%eax]] := x/20[s0]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f_1030:
  R/7[%tos] := 2.
  R/7[%tos] := R/7[%tos] +f float64[x/8[%eax]]
  x/11[s0] := R/7[%tos]
  R/7[%tos] := 2.
  R/7[%tos] := x/11[s0] +f R/7[%tos]
  x/14[s0] := R/7[%tos]
  R/7[%tos] := 2.
  R/7[%tos] := x/14[s0] *f R/7[%tos]
  x/17[s0] := R/7[%tos]
  R/7[%tos] := 2.
  R/7[%tos] := x/17[s0] /f R/7[%tos]
  x/20[s0] := R/7[%tos]
  {x/20[s0]}
  x/21[%eax] := alloc 12
  [x/21[%eax] + -4] := 2301
  float64u[x/21[%eax]] := x/20[s0]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  f/8[%eax] := "camlCode__5"
                  ["camlCode"] := f/8[%eax]
                  a/9[%eax] := "camlCode__4"
                  ["camlCode" + 4] := a/9[%eax]
                  b/10[%eax] := "camlCode__3"
                  ["camlCode" + 8] := b/10[%eax]
                  c/11[%eax] := "camlCode__2"
                  ["camlCode" + 12] := c/11[%eax]
                  s/12[%eax] := "camlCode__1"
                  A/13[%ebx] := [s/12[%eax] + -4]
                  I/14[%ebx] := I/14[%ebx] >>u 10
                  tmp/15[%ebx] := I/14[%ebx]  * 4 + -1
                  I/16[%ecx] := unsigned int8[s/12[%eax] + tmp/15[%ebx]]
                  I/17[%ebx] := I/17[%ebx] - I/16[%ecx]
                  I/17[%ebx] check > 0
                  I/18[%edx] := 48
                  unsigned int8[s/12[%eax]] := R/3[%edx]
                  {}
                  x/19[%eax] := alloc 8
                  [x/19[%eax] + -4] := 1024
                  [x/19[%eax]] := 5
                  ["camlCode" + 16] := x/19[%eax]
                  A/20[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  f/8[%eax] := "camlCode__5"
  ["camlCode"] := f/8[%eax]
  a/9[%eax] := "camlCode__4"
  ["camlCode" + 4] := a/9[%eax]
  b/10[%eax] := "camlCode__3"
  ["camlCode" + 8] := b/10[%eax]
  c/11[%eax] := "camlCode__2"
  ["camlCode" + 12] := c/11[%eax]
  s/12[%eax] := "camlCode__1"
  A/13[%ebx] := [s/12[%eax] + -4]
  I/14[%ebx] := I/14[%ebx] >>u 10
  tmp/15[%ebx] := I/14[%ebx]  * 4 + -1
  I/16[%ecx] := unsigned int8[s/12[%eax] + tmp/15[%ebx]]
  I/17[%ebx] := I/17[%ebx] - I/16[%ecx]
  I/17[%ebx] check > 0
  I/18[%edx] := 48
  unsigned int8[s/12[%eax]] := R/3[%edx]
  {}
  x/19[%eax] := alloc 8
  [x/19[%eax] + -4] := 1024
  [x/19[%eax]] := 5
  ["camlCode" + 16] := x/19[%eax]
  A/20[%eax] := 1
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
	.long	5120
	.globl	camlCode
camlCode:
	.space	20
	.data
	.long	2295
camlCode__5:
	.long	camlCode__f_1030
	.long	3
	.data
	.globl	camlCode__1
	.long	1276
camlCode__1:
	.ascii	"123"
	.byte	0
	.data
	.long	3327
camlCode__2:
	.long	caml_int64_ops
	.long	2
	.long	0
	.data
	.long	3327
camlCode__3:
	.long	caml_int64_ops
	.long	1
	.long	0
	.data
	.long	3327
camlCode__4:
	.long	caml_int64_ops
	.long	1
	.long	0
	.text
	.align	16
	.globl	camlCode__f_1030
camlCode__f_1030:
	subl	$8, %esp
.L100:
	fldl	.L101
	faddl	(%eax)
	fstpl	0(%esp)
	fldl	.L102
	faddl	0(%esp)
	fstpl	0(%esp)
	fldl	.L103
	fmull	0(%esp)
	fstpl	0(%esp)
	fldl	.L104
	fdivrl	0(%esp)
	fstpl	0(%esp)
.L105:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L106
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	0(%esp)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L106:	call	caml_call_gc
.L107:	jmp	.L105
	.data
.L104:	.long	0x0, 0x40000000
	.data
.L103:	.long	0x0, 0x40000000
	.data
.L102:	.long	0x0, 0x40000000
	.data
.L101:	.long	0x0, 0x40000000
	.type	camlCode__f_1030,@function
	.size	camlCode__f_1030,.-camlCode__f_1030
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L108:
	movl	$camlCode__5, %eax
	movl	%eax, camlCode
	movl	$camlCode__4, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__3, %eax
	movl	%eax, camlCode + 8
	movl	$camlCode__2, %eax
	movl	%eax, camlCode + 12
	movl	$camlCode__1, %eax
	movl	-4(%eax), %ebx
	shrl	$10, %ebx
	lea	-1(, %ebx, 4), %ebx
	movzbl	(%eax, %ebx), %ecx
	subl	%ecx, %ebx
	cmpl	$0, %ebx
	jbe	.L109
	movl	$48, %edx
	movb	%dl, (%eax)
	call	caml_alloc1
.L110:
	leal	4(%eax), %eax
	movl	$1024, -4(%eax)
	movl	$5, (%eax)
	movl	%eax, camlCode + 16
	movl	$1, %eax
	ret
.L109:	call	caml_ml_array_bound_error
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
	.long	2
	.long	.L110
	.word	4
	.word	0
	.align	4
	.long	.L107
	.word	12
	.word	0
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

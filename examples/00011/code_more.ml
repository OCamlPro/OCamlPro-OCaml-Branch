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
lambda saved
typedtree saved
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
 After TonLambda.optimize (0 eliminations): 
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
   (let (x/1040 (makemutable 0 2)) (setfield_imm 4 (global Code!) x/1040))
   0a)
lambda saved
typedtree saved
-dclosure
(seq
  (let
    (f/1030
       (closure (camlCode__f_1030(1)  x/1031
                 (let
                   (x/1032 (+. x/1031 2.)
                    x/1033 (+. x/1032 2.)
                    x/1034 (*. x/1033 2.)
                    x/1035 (/. x/1034 2.))
                   x/1035)) ))
    (setfield_imm 0 (global camlCode!) f/1030))
  (let (a/1036 1L) (setfield_imm 1 (global camlCode!) a/1036))
  (let (b/1037 1L) (setfield_imm 2 (global camlCode!) b/1037))
  (let (c/1038 2L) (setfield_imm 3 (global camlCode!) c/1038))
  (let (s/1039 "123") (string.set s/1039 0 '0'))
  (let (x/1040 (makemutable 0 2)) (setfield_imm 4 (global camlCode!) x/1040))
  0a)(seq
       (let
         (f/1030
            (closure (camlCode__f_1030(1)  x/1031
                      (let
                        (x/1032 (+. x/1031 2.)
                         x/1033 (+. x/1032 2.)
                         x/1034 (*. x/1033 2.)
                         x/1035 (/. x/1034 2.))
                        x/1035)) ))
         (setfield_imm 0 (global camlCode!) f/1030))
       (let (a/1036 1L) (setfield_imm 1 (global camlCode!) a/1036))
       (let (b/1037 1L) (setfield_imm 2 (global camlCode!) b/1037))
       (let (c/1038 2L) (setfield_imm 3 (global camlCode!) c/1038))
       (let (s/1039 "123") (string.set s/1039 0 '0'))
       (let (x/1040 (makemutable 0 2))
         (setfield_imm 4 (global camlCode!) x/1040))lambda saved
typedtree saved

-dcmm
(data int 5120 global "camlCode" "camlCode": skip 40)
(data int 2295 "camlCode__5": addr "camlCode__f_1030" int 3)
(data
 global "camlCode__1"
 int 1276
 "camlCode__1":
 string "123"
 skip 4
 byte 4)
(data int 2303 "camlCode__2": addr "caml_int64_ops" int 2)
(data int 2303 "camlCode__3": addr "caml_int64_ops" int 1)
(data int 2303 "camlCode__4": addr "caml_int64_ops" int 1)
(function camlCode__f_1030 (x/1031: addr)
 (let
   (x/1048 (+f (load float64u x/1031) 2.) x/1049 (+f x/1048 2.)
    x/1050 (*f x/1049 2.) x/1051 (/f x/1050 2.) x/1035 (alloc 1277 x/1051))
   x/1035))

(function camlCode__entry ()
 (let f/1030 "camlCode__5" (store "camlCode" f/1030))
 (let a/1036 "camlCode__4" (store (+a "camlCode" 8) a/1036))
 (let b/1037 "camlCode__3" (store (+a "camlCode" 16) b/1037))
 (let c/1038 "camlCode__2" (store (+a "camlCode" 24) c/1038))
 (let s/1039 "camlCode__1"
   (checkbound
     (let tmp/1047 (- (<< (>>u (load (+a s/1039 -8)) 10) 3) 1)
       (- tmp/1047 (load unsigned int8 (+a s/1039 tmp/1047))))
     0)
   (store unsigned int8 (+ s/1039 0) 48))
 (let x/1040 (alloc 1024 5) (store (+a "camlCode" 32) x/1040)) 1a)

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
	.quad	5120
	.globl	camlCode
camlCode:
	.space	40
	.data
	.quad	2295
camlCode__5:
	.quad	camlCode__f_1030
	.quad	3
	.data
	.globl	camlCode__1
	.quad	1276
camlCode__1:
	.ascii	"123"
	.space	4
	.byte	4
	.data
	.quad	2303
camlCode__2:
	.quad	caml_int64_ops
	.quad	2
	.data
	.quad	2303
camlCode__3:
	.quad	caml_int64_ops
	.quad	1
	.data
	.quad	2303
camlCode__4:
	.quad	caml_int64_ops
	.quad	1
	.text
	.align	16
	.globl	camlCode__f_1030
camlCode__f_1030:
	subq	$8, %rsp
.L100:
	movlpd	.L101(%rip), %xmm0
	addsd	(%rax), %xmm0
	movlpd	.L102(%rip), %xmm1
	addsd	%xmm1, %xmm0
	movlpd	.L103(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movlpd	.L104(%rip), %xmm1
	divsd	%xmm1, %xmm0
.L105:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L106
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L106:	call	caml_call_gc@PLT
.L107:	jmp	.L105
	.section	.rodata.cst8,"a",@progbits
.L104:	.quad	0x4000000000000000
.L103:	.quad	0x4000000000000000
.L102:	.quad	0x4000000000000000
.L101:	.quad	0x4000000000000000
	.type	camlCode__f_1030,@function
	.size	camlCode__f_1030,.-camlCode__f_1030
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L108:
	movq	camlCode__5@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__4@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 16(%rax)
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 24(%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rdi
	movq	-8(%rdi), %rax
	shrq	$10, %rax
	leaq	-1(, %rax, 8), %rax
	movzbq	(%rdi, %rax), %rbx
	subq	%rbx, %rax
	cmpq	$0, %rax
	jbe	.L109
	movq	$48, %rax
	movb	%al, (%rdi)
	call	caml_alloc1@PLT
.L110:
	leaq	8(%r15), %rbx
	movq	$1024, -8(%rbx)
	movq	$5, (%rbx)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 32(%rax)
	movq	$1, %rax
	addq	$8, %rsp
	ret
.L109:	call	caml_ml_array_bound_error@PLT
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
	.quad	2
	.quad	.L110
	.word	16
	.word	0
	.align	8
	.quad	.L107
	.word	16
	.word	0
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

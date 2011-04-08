(* A closure is allocated for a function that does not need it,
   because closure allocation is done before inlining. However, the
   closure is unused afterwards, because the compiler detects that it
   is not used (actually, the closure variable does appear withing
   it). All calls are computed first as if the closure was not needed,
   and need to be recomputed if the closure is finally required.

   Notes:
   - if a function is erroneously written as recursive even if not, it cannot
   be inlined.
   - n+n is not optimized in 2*n
   - a closure is allocated for f and g, although they do not use the included
   value. On the contrary, f3 has a static closure, but not g, although they
   look similar.
   - in the assembly code, only one allocation is performed, containing the
   closures and the module.

*)

let f1 =
  let x = 1 in
  let rec f y = y + x in
  let g n = (f n) + (f n) in
    g

let f2 =
  let x = 1 in
  let f y = y + x in
  let g n = (f n) + (f n) in
    g

let f3 y = f2 (y+1)

(*
-dlambda:
(seq
  (let
    (f1/58
       (let (x/59 1)
         (letrec (f/60 (function y/61 (+ y/61 x/59)))
           (let
             (g/62 (function n/63 (+ (apply f/60 n/63) (apply f/60 n/63))))
             g/62))))
    (setfield_imm 0 (global Code!) f1/58))
  (let
    (f2/64
       (let
         (x/65 1
          f/66 (function y/67 (+ y/67 x/65))
          g/68 (function n/69 (+ (apply f/66 n/69) (apply f/66 n/69))))
         g/68))
    (setfield_imm 1 (global Code!) f2/64))
  (let (f3/70 (function y/71 (apply (field 1 (global Code!)) (+ y/71 1))))
    (setfield_imm 2 (global Code!) f3/70))
  0a)



-dclosure:
(seq
  (let
    (f1/58
       (let
         (clos/76 (closure (camlCode__f_60[1]( y/61) (+ y/61 1)) [
                                                                  1])
          g/78
            (closure (camlCode__g_62[1]( n/63)
                      (+ (camlCode__f_60  n/63) (camlCode__f_60  n/63))) [

             (offset[0] clos/76)]))
         g/78))
    (setfield_imm 0 (global camlCode!) f1/58))
  (let
    (f2/64
       (let
         (f/66 (closure (camlCode__f_66[1]( y/67) (+ y/67 1)) [
                                                               1])
          g/68
            (closure (camlCode__g_68[1]( n/69) (+ (+ n/69 1) (+ n/69 1))) [

             f/66]))
         g/68))
    (setfield_imm 1 (global camlCode!) f2/64))
  (let
    (f3/70
       (closure (camlCode__f3_70[1]( y/71)
                 (let (n/82 (+ y/71 1)) (+ (+ n/82 1) (+ n/82 1)))) [
        ]))
    (setfield_imm 2 (global camlCode!) f3/70))

-dcmm:
(data int 3072 global "camlCode" "camlCode": skip 24)
(data int 2295 "camlCode__1": addr "camlCode__f3_70" int 3)
(function camlCode__f_60 (y/61: addr) (+ y/61 2))

(function camlCode__g_62 (n/63: addr)
 (+ (+ (app "camlCode__f_60" n/63 addr) (app "camlCode__f_60" n/63 addr)) -1))

(function camlCode__f_66 (y/67: addr) (+ y/67 2))

(function camlCode__g_68 (n/69: addr) (+ (+ n/69 n/69) 3))

(function camlCode__f3_70 (y/71: addr)
 (let n/82 (+ y/71 2) (+ (+ n/82 n/82) 3)))

(function camlCode__entry ()
 (let
   f1/58
     (let
       (clos/76 (alloc 3319 "camlCode__f_60" 3 3)
        g/78 (alloc 3319 "camlCode__g_62" 3 clos/76))
       g/78)
   (store "camlCode" f1/58))
 (let
   f2/64
     (let
       (f/66 (alloc 3319 "camlCode__f_66" 3 3)
        g/68 (alloc 3319 "camlCode__g_68" 3 f/66))
       g/68)
   (store (+a "camlCode" 8) f2/64))
 (let f3/70 "camlCode__1" (store (+a "camlCode" 16) f3/70)) 1a)

(data)


*)
(*
-drawlambda
(seq
  (let
    (f1/1030
       (let (x/1031 1)
         (letrec (f/1032 (function y/1033 (+ y/1033 x/1031)))
           (let
             (g/1034
                (function n/1035
                  (+ (apply f/1032 n/1035) (apply f/1032 n/1035))))
             g/1034))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1036
       (let
         (x/1037 1
          f/1038 (function y/1039 (+ y/1039 x/1037))
          g/1040
            (function n/1041 (+ (apply f/1038 n/1041) (apply f/1038 n/1041))))
         g/1040))
    (setfield_imm 1 (global Code!) f2/1036))
  (let
    (f3/1042 (function y/1043 (apply (field 1 (global Code!)) (+ y/1043 1))))
    (setfield_imm 2 (global Code!) f3/1042))
  0a)
lambda saved
typedtree saved
-dlambda
(seq
  (let
    (f1/1030
       (let (x/1031 1)
         (letrec (f/1032 (function y/1033 (+ y/1033 x/1031)))
           (let
             (g/1034
                (function n/1035
                  (+ (apply f/1032 n/1035) (apply f/1032 n/1035))))
             g/1034))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1036
       (let
         (x/1037 1
          f/1038 (function y/1039 (+ y/1039 x/1037))
          g/1040
            (function n/1041 (+ (apply f/1038 n/1041) (apply f/1038 n/1041))))
         g/1040))
    (setfield_imm 1 (global Code!) f2/1036))
  (let
    (f3/1042 (function y/1043 (apply (field 1 (global Code!)) (+ y/1043 1))))
    (setfield_imm 2 (global Code!) f3/1042))
  0a)
checking tailcall on f/1032
 After TonLambda.optimize (0 eliminations): 
 (seq
   (let
     (f1/1030
        (let
          (x/1031 1
           f/1032 (function y/1033 (+ y/1033 x/1031))
           g/1034
             (function n/1035
               (+ (apply f/1032 n/1035) (apply f/1032 n/1035))))
          g/1034))
     (setfield_imm 0 (global Code!) f1/1030))
   (let
     (f2/1036
        (let
          (x/1037 1
           f/1038 (function y/1039 (+ y/1039 x/1037))
           g/1040
             (function n/1041
               (+ (apply f/1038 n/1041) (apply f/1038 n/1041))))
          g/1040))
     (setfield_imm 1 (global Code!) f2/1036))
   (let
     (f3/1042 (function y/1043 (apply (field 1 (global Code!)) (+ y/1043 1))))
     (setfield_imm 2 (global Code!) f3/1042))
   0a)
lambda saved
typedtree saved
-dclosure
(seq
  (let
    (f1/1030
       (let
         (f/1032 (closure (camlCode__f_1032(1)  y/1033 (+ y/1033 1)) 
                                                                    1)
          g/1034
            (closure (camlCode__g_1034(1)  n/1035
                      (+ (+ n/1035 1) (+ n/1035 1))) 
                                                     f/1032))
         g/1034))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let
    (f2/1036
       (let
         (f/1038 (closure (camlCode__f_1038(1)  y/1039 (+ y/1039 1)) 
                                                                    1)
          g/1040
            (closure (camlCode__g_1040(1)  n/1041
                      (+ (+ n/1041 1) (+ n/1041 1))) 
                                                     f/1038))
         g/1040))
    (setfield_imm 1 (global camlCode!) f2/1036))
  (let
    (f3/1042
       (closure (camlCode__f3_1042(1)  y/1043
                 (let (n/1052 (+ y/1043 1)) (+ (+ n/1052 1) (+ n/1052 1)))) 
        ))
    (setfield_imm 2 (global camlCode!) f3/1042))
  0a)(seq
       (let
         (f1/1030
            (let
              (f/1032 (closure (camlCode__f_1032(1)  y/1033 (+ y/1033 1)) 
                                                                    1)
               g/1034
                 (closure (camlCode__g_1034(1)  n/1035
                           (+ (+ n/1035 1) (+ n/1035 1))) 
                                                          f/1032))
              g/1034))
         (setfield_imm 0 (global camlCode!) f1/1030))
       (let
         (f2/1036
            (let
              (f/1038 (closure (camlCode__f_1038(1)  y/1039 (+ y/1039 1)) 
                                                                    1)
               g/1040
                 (closure (camlCode__g_1040(1)  n/1041
                           (+ (+ n/1041 1) (+ n/1041 1))) 
                                                          f/1038))
              g/1040))
         (setfield_imm 1 (global camlCode!) f2/1036))
       (let
         (f3/1042
            (closure (camlCode__f3_1042(1)  y/1043
                      (let (n/1052 (+ y/1043 1))
                        (+ (+ n/1052 1) (+ n/1052 1)))) ))
         (setfield_imm 2 (global camlCode!) f3/1042))lambda saved
typedtree saved

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 24)
(data int 2295 "camlCode__1": addr "camlCode__f3_1042" int 3)
(function camlCode__f_1032 (y/1033: addr) (+ y/1033 2))

(function camlCode__g_1034 (n/1035: addr) (+ (+ n/1035 n/1035) 3))

(function camlCode__f_1038 (y/1039: addr) (+ y/1039 2))

(function camlCode__g_1040 (n/1041: addr) (+ (+ n/1041 n/1041) 3))

(function camlCode__f3_1042 (y/1043: addr)
 (let n/1052 (+ y/1043 2) (+ (+ n/1052 n/1052) 3)))

(function camlCode__entry ()
 (let
   f1/1030
     (let
       (f/1032 (alloc 3319 "camlCode__f_1032" 3 3)
        g/1034 (alloc 3319 "camlCode__g_1034" 3 f/1032))
       g/1034)
   (store "camlCode" f1/1030))
 (let
   f2/1036
     (let
       (f/1038 (alloc 3319 "camlCode__f_1038" 3 3)
        g/1040 (alloc 3319 "camlCode__g_1040" 3 f/1038))
       g/1040)
   (store (+a "camlCode" 8) f2/1036))
 (let f3/1042 "camlCode__1" (store (+a "camlCode" 16) f3/1042)) 1a)

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
	.quad	3072
	.globl	camlCode
camlCode:
	.space	24
	.data
	.quad	2295
camlCode__1:
	.quad	camlCode__f3_1042
	.quad	3
	.text
	.align	16
	.globl	camlCode__f_1032
camlCode__f_1032:
.L100:
	addq	$2, %rax
	ret
	.type	camlCode__f_1032,@function
	.size	camlCode__f_1032,.-camlCode__f_1032
	.text
	.align	16
	.globl	camlCode__g_1034
camlCode__g_1034:
.L101:
	leaq	3(%rax, %rax), %rax
	ret
	.type	camlCode__g_1034,@function
	.size	camlCode__g_1034,.-camlCode__g_1034
	.text
	.align	16
	.globl	camlCode__f_1038
camlCode__f_1038:
.L102:
	addq	$2, %rax
	ret
	.type	camlCode__f_1038,@function
	.size	camlCode__f_1038,.-camlCode__f_1038
	.text
	.align	16
	.globl	camlCode__g_1040
camlCode__g_1040:
.L103:
	leaq	3(%rax, %rax), %rax
	ret
	.type	camlCode__g_1040,@function
	.size	camlCode__g_1040,.-camlCode__g_1040
	.text
	.align	16
	.globl	camlCode__f3_1042
camlCode__f3_1042:
.L104:
	addq	$2, %rax
	leaq	3(%rax, %rax), %rax
	ret
	.type	camlCode__f3_1042,@function
	.size	camlCode__f3_1042,.-camlCode__f3_1042
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L105:
	movq	$128, %rax
	call	caml_allocN@PLT
.L106:
	leaq	8(%r15), %rsi
	movq	$3319, -8(%rsi)
	movq	camlCode__f_1032@GOTPCREL(%rip), %rax
	movq	%rax, (%rsi)
	movq	$3, 8(%rsi)
	movq	$3, 16(%rsi)
	leaq	32(%rsi), %rbx
	movq	$3319, -8(%rbx)
	movq	camlCode__g_1034@GOTPCREL(%rip), %rax
	movq	%rax, (%rbx)
	movq	$3, 8(%rbx)
	movq	%rsi, 16(%rbx)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	leaq	64(%rsi), %rdi
	movq	$3319, -8(%rdi)
	movq	camlCode__f_1038@GOTPCREL(%rip), %rax
	movq	%rax, (%rdi)
	movq	$3, 8(%rdi)
	movq	$3, 16(%rdi)
	leaq	96(%rsi), %rbx
	movq	$3319, -8(%rbx)
	movq	camlCode__g_1040@GOTPCREL(%rip), %rax
	movq	%rax, (%rbx)
	movq	$3, 8(%rbx)
	movq	%rdi, 16(%rbx)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 16(%rax)
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
	.quad	1
	.quad	.L106
	.word	16
	.word	0
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

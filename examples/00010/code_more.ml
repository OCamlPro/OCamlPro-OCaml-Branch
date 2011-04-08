(* This example shows that useless code can be produced during inlining,
since the check on the arguments does not detect many cases without
side-effects. Here, an access to a field is passed as an unused argument,
but a sequence of code is still produced (see assembly code for g).
*)


(*
ocamlopt -dlambda -c code.ml
ocamlopt -dclosure -c code.ml
ocamlopt -dcmm -c code.ml
ocamlopt -S -c code.ml
*)

let f x y = x+ 1

let g r =
  f r.contents r.contents

(*
-dlambda:
seq
  (let (f/58 (function x/59 y/60 (+ x/59 1)))
    (setfield_imm 0 (global Code!) f/58))
  (let
    (g/61
       (function r/62
         (apply (field 0 (global Code!)) (field 0 r/62) (field 0 r/62))))
    (setfield_imm 1 (global Code!) g/61))
  0a)

-dclosure:
(seq
  (let (f/58 (closure (camlCode__f_58[2]( x/59 y/60) (+ x/59 1)) []))
    (setfield_imm 0 (global camlCode!) f/58))
  (let
    (g/61
       (closure (camlCode__g_61[1]( r/62)
                 (seq (field 0 r/62) (let (x/68 (field 0 r/62)) (+ x/68 1)))) [
        ]))
    (setfield_imm 1 (global camlCode!) g/61))% 

-dcmm:
(data int 2048 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__g_61" int 3)
(data int 3319 "camlCode__2": addr "caml_curry2" int 5 addr "camlCode__f_58")
(function camlCode__f_58 (x/59: addr y/60: addr) (+ x/59 2))

(function camlCode__g_61 (r/62: addr)
 (load r/62) [] (let x/68 (load r/62) (+ x/68 2)))

(function camlCode__entry ()
 (let f/58 "camlCode__2" (store "camlCode" f/58))
 (let g/61 "camlCode__1" (store (+a "camlCode" 4) g/61)) 1a)

(data)

-S:
camlCode__g_61:
.L101:
        movl    (%eax), %ebx
        movl    (%eax), %eax
        addl    $2, %eax
        ret

*)
(*
-drawlambda
(seq
  (let (f/1030 (function x/1031 y/1032 (+ x/1031 1)))
    (setfield_imm 0 (global Code!) f/1030))
  (let
    (g/1033
       (function r/1034
         (apply (field 0 (global Code!)) (field 0 r/1034) (field 0 r/1034))))
    (setfield_imm 1 (global Code!) g/1033))
  0a)
lambda saved
typedtree saved
-dlambda
(seq
  (let (f/1030 (function x/1031 y/1032 (+ x/1031 1)))
    (setfield_imm 0 (global Code!) f/1030))
  (let
    (g/1033
       (function r/1034
         (apply (field 0 (global Code!)) (field 0 r/1034) (field 0 r/1034))))
    (setfield_imm 1 (global Code!) g/1033))
  0a)
 After TonLambda.optimize (0 eliminations): 
 (seq
   (let (f/1030 (function x/1031 y/1032 (+ x/1031 1)))
     (setfield_imm 0 (global Code!) f/1030))
   (let
     (g/1033
        (function r/1034
          (apply (field 0 (global Code!)) (field 0 r/1034) (field 0 r/1034))))
     (setfield_imm 1 (global Code!) g/1033))
   0a)
lambda saved
typedtree saved
-dclosure
(seq
  (let (f/1030 (closure (camlCode__f_1030(2)  x/1031 y/1032 (+ x/1031 1)) ))
    (setfield_imm 0 (global camlCode!) f/1030))
  (let
    (g/1033
       (closure (camlCode__g_1033(1)  r/1034
                 (seq (field 0 r/1034)
                   (let (x/1040 (field 0 r/1034)) (+ x/1040 1)))) ))
    (setfield_imm 1 (global camlCode!) g/1033))
  0a)(seq
       (let
         (f/1030 (closure (camlCode__f_1030(2)  x/1031 y/1032 (+ x/1031 1)) ))
         (setfield_imm 0 (global camlCode!) f/1030))
       (let
         (g/1033
            (closure (camlCode__g_1033(1)  r/1034
                      (seq (field 0 r/1034)
                        (let (x/1040 (field 0 r/1034)) (+ x/1040 1)))) 
             ))
         (setfield_imm 1 (global camlCode!) g/1033))lambda saved
typedtree saved

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__1": addr "camlCode__g_1033" int 3)
(data
 int 3319
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__f_1030")
(function camlCode__f_1030 (x/1031: addr y/1032: addr) (+ x/1031 2))

(function camlCode__g_1033 (r/1034: addr)
 (load r/1034) [] (let x/1040 (load r/1034) (+ x/1040 2)))

(function camlCode__entry ()
 (let f/1030 "camlCode__2" (store "camlCode" f/1030))
 (let g/1033 "camlCode__1" (store (+a "camlCode" 8) g/1033)) 1a)

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
	.quad	2048
	.globl	camlCode
camlCode:
	.space	16
	.data
	.quad	2295
camlCode__1:
	.quad	camlCode__g_1033
	.quad	3
	.data
	.quad	3319
camlCode__2:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__f_1030
	.text
	.align	16
	.globl	camlCode__f_1030
camlCode__f_1030:
.L100:
	addq	$2, %rax
	ret
	.type	camlCode__f_1030,@function
	.size	camlCode__f_1030,.-camlCode__f_1030
	.text
	.align	16
	.globl	camlCode__g_1033
camlCode__g_1033:
.L101:
	movq	(%rax), %rbx
	movq	(%rax), %rax
	addq	$2, %rax
	ret
	.type	camlCode__g_1033,@function
	.size	camlCode__g_1033,.-camlCode__g_1033
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L102:
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rbx
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
	.quad	0
	.section .note.GNU-stack,"",%progbits
*)

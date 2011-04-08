(* This example will generate a stack overflow if the first 'f' is
   called, and a core dump if the second 'f' is called. As the assembly
   code shows, there are no tests performed at runtime, stack overflow is
   detected by catching the SEGV signal, and checking if the current PC
   is in OCaml assembly code (i.e. within caml_code_area_start and
   caml_code_area_stop (TODO: what about dynamically loaded code ?)).

   The best way to perform complete stack overflow detection would be to
   add a flag to "external" to check if enough space is available on the
   stack before the call to C code (and raise stack overflow if
   not).

   It could also be useful to put some C segments which are known to be
   "safe" in the same area as OCaml code.

  Note that it would be quite tedious to fix the behavior here, as a
  stack overflow happening within the memory allocator could lead to
  memory corruption if an exception is raised without fixing the
  current state. A solution would be to have a check of stack
  everytime allocation is performed.

   Are there recursive C functions in the runtime, especially in the
   garbage collector ?

*)


let rec f x =
  1 + f (x+1)

let rec f x =
  let s = String.create 10 in
  1 + f (x+1)

let _ =
  f 0

(*
-drawlambda
File "code.ml", line 32, characters 6-7:
Warning 26: unused variable s.
(seq
  (letrec (f/1030 (function x/1031 (+ 1 (apply f/1030 (+ x/1031 1)))))
    (setfield_imm 1 (global Code!) f/1030))
  (letrec
    (f/1032
       (function x/1033
         (let (s/1034 (caml_create_string 10))
           (+ 1 (apply f/1032 (+ x/1033 1))))))
    (setfield_imm 0 (global Code!) f/1032))
  (apply (field 0 (global Code!)) 0) 0a)
close_rec_functions
Recursive function f could be inlined
close_rec_functions
Recursive function f could be inlined
lambda saved
typedtree saved
-dlambda
File "code.ml", line 32, characters 6-7:
Warning 26: unused variable s.
(seq
  (letrec (f/1030 (function x/1031 (+ 1 (apply f/1030 (+ x/1031 1)))))
    (setfield_imm 1 (global Code!) f/1030))
  (letrec
    (f/1032
       (function x/1033
         (let (s/1034 (caml_create_string 10))
           (+ 1 (apply f/1032 (+ x/1033 1))))))
    (setfield_imm 0 (global Code!) f/1032))
  (apply (field 0 (global Code!)) 0) 0a)
checking tailcall on f/1032
checking tailcall on f/1030
 After TonLambda.optimize (0 eliminations): 
 (seq
   (letrec (f/1030 (function x/1031 (+ 1 (apply f/1030 (+ x/1031 1)))))
     (setfield_imm 1 (global Code!) f/1030))
   (letrec
     (f/1032
        (function x/1033
          (let (s/1034 (caml_create_string 10))
            (+ 1 (apply f/1032 (+ x/1033 1))))))
     (setfield_imm 0 (global Code!) f/1032))
   (apply (field 0 (global Code!)) 0) 0a)
close_rec_functions
Recursive function f could be inlined
close_rec_functions
Recursive function f could be inlined
lambda saved
typedtree saved
-dclosure
File "code.ml", line 32, characters 6-7:
Warning 26: unused variable s.
close_rec_functions
Recursive function f could be inlined
close_rec_functions
Recursive function f could be inlined
(seq
  (let
    (clos/1038
       (closure (camlCode__f_1030(1)  x/1031
                 (+ 1 (camlCode__f_1030  (+ x/1031 1)))) ))
    (setfield_imm 1 (global camlCode!) clos/1038))
  (let
    (clos/1041
       (closure (camlCode__f_1032(1)  x/1033
                 (let (s/1034 (caml_create_string 10))
                   (+ 1 (camlCode__f_1032  (+ x/1033 1))))) ))
    (setfield_imm 0 (global camlCode!) clos/1041))
  (let
    (clos_env/1043
       (closure (camlCode__f_1042(1)  x/1033
                 (let (s/1044 (caml_create_string 10))
                   (+ 1 (camlCode__f_1042  (+ x/1033 1))))) ))
    (camlCode__f_1042  0))
  0a)(seq
       (let
         (clos/1038
            (closure (camlCode__f_1030(1)  x/1031
                      (+ 1 (camlCode__f_1030  (+ x/1031 1)))) ))
         (setfield_imm 1 (global camlCode!) clos/1038))
       (let
         (clos/1041
            (closure (camlCode__f_1032(1)  x/1033
                      (let (s/1034 (caml_create_string 10))
                        (+ 1 (camlCode__f_1032  (+ x/1033 1))))) ))
         (setfield_imm 0 (global camlCode!) clos/1041))
       (let
         (clos_env/1043
            (closure (camlCode__f_1042(1)  x/1033
                      (let (s/1044 (caml_create_string 10))
                        (+ 1 (camlCode__f_1042  (+ x/1033 1))))) ))
         (camlCode__f_1042  0))lambda saved
typedtree saved

-dcmm
File "code.ml", line 32, characters 6-7:
Warning 26: unused variable s.
close_rec_functions
Recursive function f could be inlined
close_rec_functions
Recursive function f could be inlined
(data int 2048 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__1": addr "camlCode__f_1042" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f_1032" int 3)
(data int 2295 "camlCode__3": addr "camlCode__f_1030" int 3)
(function camlCode__f_1030 (x/1031: addr)
 (+ (app "camlCode__f_1030" (+ x/1031 2) addr) 2))

(function camlCode__f_1032 (x/1033: addr)
 (let s/1034 (extcall "caml_create_string" 21 addr)
   (+ (app "camlCode__f_1032" (+ x/1033 2) addr) 2)))

(function camlCode__f_1042 (x/1033: addr)
 (let s/1044 (extcall "caml_create_string" 21 addr)
   (+ (app "camlCode__f_1042" (+ x/1033 2) addr) 2)))

(function camlCode__entry ()
 (let clos/1038 "camlCode__3" (store (+a "camlCode" 8) clos/1038))
 (let clos/1041 "camlCode__2" (store "camlCode" clos/1041))
 (let clos_env/1043 "camlCode__1" (app "camlCode__f_1042" 1 unit)) 1a)

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
	.quad	camlCode__f_1042
	.quad	3
	.data
	.quad	2295
camlCode__2:
	.quad	camlCode__f_1032
	.quad	3
	.data
	.quad	2295
camlCode__3:
	.quad	camlCode__f_1030
	.quad	3
	.text
	.align	16
	.globl	camlCode__f_1030
camlCode__f_1030:
	subq	$8, %rsp
.L100:
	addq	$2, %rax
	call	camlCode__f_1030@PLT
.L101:
	addq	$2, %rax
	addq	$8, %rsp
	ret
	.type	camlCode__f_1030,@function
	.size	camlCode__f_1030,.-camlCode__f_1030
	.text
	.align	16
	.globl	camlCode__f_1032
camlCode__f_1032:
	subq	$8, %rsp
.L102:
	movq	%rax, 0(%rsp)
	movq	$21, %rdi
	movq	caml_create_string@GOTPCREL(%rip), %rax
	call	caml_c_call@PLT
.L103:
	movq	0(%rsp), %rax
	addq	$2, %rax
	call	camlCode__f_1032@PLT
.L104:
	addq	$2, %rax
	addq	$8, %rsp
	ret
	.type	camlCode__f_1032,@function
	.size	camlCode__f_1032,.-camlCode__f_1032
	.text
	.align	16
	.globl	camlCode__f_1042
camlCode__f_1042:
	subq	$8, %rsp
.L105:
	movq	%rax, 0(%rsp)
	movq	$21, %rdi
	movq	caml_create_string@GOTPCREL(%rip), %rax
	call	caml_c_call@PLT
.L106:
	movq	0(%rsp), %rax
	addq	$2, %rax
	call	camlCode__f_1042@PLT
.L107:
	addq	$2, %rax
	addq	$8, %rsp
	ret
	.type	camlCode__f_1042,@function
	.size	camlCode__f_1042,.-camlCode__f_1042
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L108:
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rax
	movq	$1, %rax
	call	camlCode__f_1042@PLT
.L109:
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
	.quad	6
	.quad	.L109
	.word	16
	.word	0
	.align	8
	.quad	.L107
	.word	16
	.word	0
	.align	8
	.quad	.L106
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L104
	.word	16
	.word	0
	.align	8
	.quad	.L103
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L101
	.word	16
	.word	0
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

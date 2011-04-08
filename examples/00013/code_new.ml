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
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
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
-dclosure
File "code.ml", line 32, characters 6-7:
Warning 26: unused variable s.
*** After Closure.intro:
(seq
  (let
    (clos/1037
       (closure (camlCode__f_1030(1)  x/1031
                  (+ 1 (camlCode__f_1030  (+ x/1031 1)))) {2} ))
    (setfield_imm 1 (global camlCode!) clos/1037))
  (let
    (clos/1039
       (closure (camlCode__f_1032(1)  x/1033
                  (let (s/1034 (caml_create_string 10))
                    (+ 1 (camlCode__f_1032  (+ x/1033 1))))) {2} ))
    (setfield_imm 0 (global camlCode!) clos/1039))
  (camlCode__f_1032  0) 0a)
*** After TonClosure.optimize:
(let
  (clos/1037
     (closure (camlCode__f_1030(1)  x/1031
                (+ 1 (camlCode__f_1030  (+ x/1031 1)))) {2} ))
  (seq (setfield_imm 1 (global camlCode!) clos/1037)
    (let
      (clos/1039
         (closure (camlCode__f_1032(1)  x/1033
                    (seq (caml_create_string 10)
                      (+ 1 (camlCode__f_1032  (+ x/1033 1))))) {2} ))
      (seq (setfield_imm 0 (global camlCode!) clos/1039)
        (camlCode__f_1032  0) 0a))))

-dcmm
File "code.ml", line 32, characters 6-7:
Warning 26: unused variable s.
(data int 2048 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__f_1032" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f_1030" int 3)
(function camlCode__f_1030 (x/1031: addr)
 (+ (app "camlCode__f_1030" (+ x/1031 2) addr) 2))

(function camlCode__f_1032 (x/1033: addr)
 (extcall "caml_create_string" 21 unit)
 (+ (app "camlCode__f_1032" (+ x/1033 2) addr) 2))

(function camlCode__entry ()
 (let clos/1037 "camlCode__2" (store (+a "camlCode" 4) clos/1037)
   (let clos/1039 "camlCode__1" (store "camlCode" clos/1039)
     (app "camlCode__f_1032" 1 unit) 1a)))

(data)
-dlinear
File "code.ml", line 32, characters 6-7:
Warning 26: unused variable s.
Before simplify
camlCode__f_1030:
                  I/9[%eax] := I/9[%eax] + 2
                  {}
                  R/0[%eax] := call "camlCode__f_1030" R/0[%eax]
                  I/11[%eax] := I/11[%eax] + 2
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f_1030:
  I/9[%eax] := I/9[%eax] + 2
  {}
  R/0[%eax] := call "camlCode__f_1030" R/0[%eax]
  I/11[%eax] := I/11[%eax] + 2
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__f_1032:
                  spilled-x/12[s0] := x/8[%eax] (spill)
                  push 21
                  {spilled-x/12[s0]*}
                  extcall "caml_create_string"  (noalloc)
                  offset stack -4
                  x/13[%eax] := spilled-x/12[s0] (reload)
                  I/9[%eax] := I/9[%eax] + 2
                  {}
                  R/0[%eax] := call "camlCode__f_1032" R/0[%eax]
                  I/11[%eax] := I/11[%eax] + 2
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f_1032:
  spilled-x/12[s0] := x/8[%eax] (spill)
  push 21
  {spilled-x/12[s0]*}
  extcall "caml_create_string"  (noalloc)
  offset stack -4
  x/13[%eax] := spilled-x/12[s0] (reload)
  I/9[%eax] := I/9[%eax] + 2
  {}
  R/0[%eax] := call "camlCode__f_1032" R/0[%eax]
  I/11[%eax] := I/11[%eax] + 2
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  clos/8[%eax] := "camlCode__2"
                  ["camlCode" + 4] := clos/8[%eax]
                  clos/9[%eax] := "camlCode__1"
                  ["camlCode"] := clos/9[%eax]
                  I/10[%eax] := 1
                  {}
                  call "camlCode__f_1032" R/0[%eax]
                  A/11[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  clos/8[%eax] := "camlCode__2"
  ["camlCode" + 4] := clos/8[%eax]
  clos/9[%eax] := "camlCode__1"
  ["camlCode"] := clos/9[%eax]
  I/10[%eax] := 1
  {}
  call "camlCode__f_1032" R/0[%eax]
  A/11[%eax] := 1
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
	.long	2048
	.globl	camlCode
camlCode:
	.space	8
	.data
	.long	2295
camlCode__1:
	.long	camlCode__f_1032
	.long	3
	.data
	.long	2295
camlCode__2:
	.long	camlCode__f_1030
	.long	3
	.text
	.align	16
	.globl	camlCode__f_1030
camlCode__f_1030:
.L100:
	addl	$2, %eax
	call	camlCode__f_1030
.L101:
	addl	$2, %eax
	ret
	.type	camlCode__f_1030,@function
	.size	camlCode__f_1030,.-camlCode__f_1030
	.text
	.align	16
	.globl	camlCode__f_1032
camlCode__f_1032:
	subl	$4, %esp
.L102:
	movl	%eax, 0(%esp)
	pushl	$21
	movl	$caml_create_string, %eax
	call	caml_c_call
.L103:
	addl	$4, %esp
	movl	0(%esp), %eax
	addl	$2, %eax
	call	camlCode__f_1032
.L104:
	addl	$2, %eax
	addl	$4, %esp
	ret
	.type	camlCode__f_1032,@function
	.size	camlCode__f_1032,.-camlCode__f_1032
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L105:
	movl	$camlCode__2, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__1, %eax
	movl	%eax, camlCode
	movl	$1, %eax
	call	camlCode__f_1032
.L106:
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
	.long	4
	.long	.L106
	.word	4
	.word	0
	.align	4
	.long	.L104
	.word	8
	.word	0
	.align	4
	.long	.L103
	.word	12
	.word	1
	.word	4
	.align	4
	.long	.L101
	.word	4
	.word	0
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

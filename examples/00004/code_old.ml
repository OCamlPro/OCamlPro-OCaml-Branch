(*
ocamlopt -c -drawlambda -dlambda -dclosure -dcmm code.ml
*)


let rec iter f = function
    [] -> ()
  | a::l -> f a; iter f l

let _ =
  iter (fun x -> print_int x) [0;1;2]

(*
-drawlambda:

(seq
  (letrec
    (iter/58
       (function f/59 param/64
         (if param/64
           (let (l/61 (field 1 param/64) a/60 (field 0 param/64))
             (seq (apply f/59 a/60) (apply iter/58 f/59 l/61)))
           0a)))
    (setfield_imm 0 (global Code!) iter/58))
  (apply (field 0 (global Code!))
    (function x/62 (apply (field 27 (global Pervasives!)) x/62))
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)

-dlambda:
(seq
  (letrec
    (iter/58
       (function f/59 param/64
         (if param/64
           (seq (apply f/59 (field 0 param/64))
             (apply iter/58 f/59 (field 1 param/64)))
           0a)))
    (setfield_imm 0 (global Code!) iter/58))
  (apply (field 0 (global Code!))
    (function x/62 (apply (field 27 (global Pervasives!)) x/62))
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)

-dclosure:
(seq
  (let
    (clos/66
       (closure (camlCode__iter_58(2)  f/59 param/64
                 (if param/64
                   (seq (apply f/59 (field 0 param/64))
                     (camlCode__iter_58  f/59 (field 1 param/64)))
                   0a)) ))
    (setfield_imm 0 (global camlCode!) (offset[0] clos/66)))
  (camlCode__iter_58
    (closure (camlCode__fun_67(1)  x/62
              (camlPervasives__output_string_215
                (field 23 (global camlPervasives!))
                (camlPervasives__string_of_int_154  x/62))) )
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)

-dcmm:
(data int 1024 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__fun_67" int 3)
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter_58")
(data
 int 2048
 "camlCode__2":
 int 1
 addr L4
 int 2048
 L4:
 int 3
 addr L5
 int 2048
 L5:
 int 5
 int 1)
(function camlCode__iter_58 (f/59: addr param/64: addr)
 (if (!= param/64 1)
   (seq (app (load f/59) (load param/64) f/59 unit)
     (app "camlCode__iter_58" f/59 (load (+a param/64 8)) addr))
   1a))

(function camlCode__fun_67 (x/62: addr)
 (app{pervasives.ml:356,18-56} "camlPervasives__output_string_215"
   (load (+a "camlPervasives" 184))
   (app{pervasives.ml:356,39-56} "camlPervasives__string_of_int_154" x/62
     addr)
   addr))

(function camlCode__entry ()
 (let clos/66 "camlCode__3" (store "camlCode" clos/66))
 (app "camlCode__iter_58" "camlCode__1" "camlCode__2" unit) 1a)

(data)
*)


(*
-drawlambda
(seq
  (letrec
    (iter/58
       (function f/59 param/64
         (if param/64
           (let (l/61 (field 1 param/64) a/60 (field 0 param/64))
             (seq (apply f/59 a/60) (apply iter/58 f/59 l/61)))
           0a)))
    (setfield_imm 0 (global Code!) iter/58))
  (apply (field 0 (global Code!))
    (function x/62 (apply (field 27 (global Pervasives!)) x/62))
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)
-dlambda
(seq
  (letrec
    (iter/58
       (function f/59 param/64
         (if param/64
           (seq (apply f/59 (field 0 param/64))
             (apply iter/58 f/59 (field 1 param/64)))
           0a)))
    (setfield_imm 0 (global Code!) iter/58))
  (apply (field 0 (global Code!))
    (function x/62 (apply (field 27 (global Pervasives!)) x/62))
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 4)
(data int 2295 "camlCode__1": addr "camlCode__fun_67" int 3)
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter_58")
(data
 int 2048
 "camlCode__2":
 int 1
 addr L4
 int 2048
 L4:
 int 3
 addr L5
 int 2048
 L5:
 int 5
 int 1)
(function camlCode__iter_58 (f/59: addr param/64: addr)
 (if (!= param/64 1)
   (seq (app (load f/59) (load param/64) f/59 unit)
     (app "camlCode__iter_58" f/59 (load (+a param/64 4)) addr))
   1a))

(function camlCode__fun_67 (x/62: addr)
 (app{pervasives.ml:356,18-56} "camlPervasives__output_string_215"
   (load (+a "camlPervasives" 92))
   (app{pervasives.ml:356,39-56} "camlPervasives__string_of_int_154" x/62
     addr)
   addr))

(function camlCode__entry ()
 (let clos/66 "camlCode__3" (store "camlCode" clos/66))
 (app "camlCode__iter_58" "camlCode__1" "camlCode__2" unit) 1a)

(data)
-dlinear
*** Linearized code
camlCode__iter_58:
  f/8[%edx] := R/0[%eax]
  if param/9[%ebx] ==s 1 goto L100
  spilled-param/15[s0] := param/9[%ebx] (spill)
  spilled-f/14[s1] := f/8[%edx] (spill)
  A/11[%eax] := [param/9[%ebx]]
  A/12[%ecx] := [f/8[%edx]]
  R/1[%ebx] := f/8[%edx]
  {spilled-f/14[s1]* spilled-param/15[s0]*}
  call A/12[%ecx] R/0[%eax] R/1[%ebx]
  param/16[%eax] := spilled-param/15[s0] (reload)
  A/13[%ebx] := [param/16[%eax] + 4]
  f/17[%eax] := spilled-f/14[s1] (reload)
  tailcall "camlCode__iter_58" R/0[%eax] R/1[%ebx]
  L100:
  A/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_67:
  {}
  R/0[%eax] := call "camlPervasives__string_of_int_154" R/0[%eax] {pervasives.ml:356,39-56}
  A/9[%ebx] := R/0[%eax]
  A/10[%eax] := ["camlPervasives" + 92]
  tailcall "camlPervasives__output_string_215" R/0[%eax] R/1[%ebx]
  
*** Linearized code
camlCode__entry:
  clos/8[%eax] := "camlCode__3"
  ["camlCode"] := clos/8[%eax]
  A/9[%ebx] := "camlCode__2"
  A/10[%eax] := "camlCode__1"
  {}
  call "camlCode__iter_58" R/0[%eax] R/1[%ebx]
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
	.long	1024
	.globl	camlCode
camlCode:
	.space	4
	.data
	.long	2295
camlCode__1:
	.long	camlCode__fun_67
	.long	3
	.data
	.long	3319
camlCode__3:
	.long	caml_curry2
	.long	5
	.long	camlCode__iter_58
	.data
	.long	2048
camlCode__2:
	.long	1
	.long	.L100004
	.long	2048
.L100004:
	.long	3
	.long	.L100005
	.long	2048
.L100005:
	.long	5
	.long	1
	.text
	.align	16
	.globl	camlCode__iter_58
camlCode__iter_58:
	subl	$8, %esp
.L101:
	movl	%eax, %edx
	cmpl	$1, %ebx
	je	.L100
	movl	%ebx, 0(%esp)
	movl	%edx, 4(%esp)
	movl	(%ebx), %eax
	movl	(%edx), %ecx
	movl	%edx, %ebx
	call	*%ecx
.L102:
	movl	0(%esp), %eax
	movl	4(%eax), %ebx
	movl	4(%esp), %eax
	jmp	.L101
	.align	16
.L100:
	movl	$1, %eax
	addl	$8, %esp
	ret
	.type	camlCode__iter_58,@function
	.size	camlCode__iter_58,.-camlCode__iter_58
	.text
	.align	16
	.globl	camlCode__fun_67
camlCode__fun_67:
.L103:
	call	camlPervasives__string_of_int_154
.L104:
	movl	%eax, %ebx
	movl	camlPervasives + 92, %eax
	jmp	camlPervasives__output_string_215
	.type	camlCode__fun_67,@function
	.size	camlCode__fun_67,.-camlCode__fun_67
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L105:
	movl	$camlCode__3, %eax
	movl	%eax, camlCode
	movl	$camlCode__2, %ebx
	movl	$camlCode__1, %eax
	call	camlCode__iter_58
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
	.long	3
	.long	.L106
	.word	4
	.word	0
	.align	4
	.long	.L104
	.word	5
	.word	0
	.align	4
	.long	.L200000 - . + 0xe0000000
	.long	0x164270
	.long	.L102
	.word	12
	.word	2
	.word	0
	.word	4
	.align	4
.L200000:
	.ascii	"pervasives.ml\0"
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

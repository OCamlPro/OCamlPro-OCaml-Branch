(* This example shows that "fst" is not inlined when it should, causing
probably inefficient code when used instead of pattern-matching.

Note however that a3 is not completely optimized, as ocamlopt does not
infer the correct final value, and instead needs two loads.
*)

let a = ( String.make 3 'c', 1)

let a1 =
  let x = snd a in
    x

let a2 =
  let snd (_, b) = b in
  let x = snd a in
    x

let a3 =
   let (_,x) = a in
   x

(*
-drawlambda
(seq
  (let (a/1030 (makeblock 0 (apply (field 0 (global String!)) 3 'c') 1))
    (setfield_imm 0 (global Code!) a/1030))
  (let (a1/1031 (let (x/1032 (field 1 (field 0 (global Code!)))) x/1032))
    (setfield_imm 1 (global Code!) a1/1031))
  (let
    (a2/1033
       (let
         (snd/1034
            (function (param/1043, param/1044)
              (let (b/1035 param/1044) b/1035))
          x/1036 (apply snd/1034 (field 0 (global Code!))))
         x/1036))
    (setfield_imm 2 (global Code!) a2/1033))
  (let
    (a3/1037
       (let
         (x/1038 (field 1 (field 0 (global Code!)))
          match/1045 (field 0 (field 0 (global Code!))))
         x/1038))
    (setfield_imm 3 (global Code!) a3/1037))
  0a)
-dlambda
(seq
  (let (a/1030 (makeblock 0 (apply (field 0 (global String!)) 3 'c') 1))
    (setfield_imm 0 (global Code!) a/1030))
  (let (a1/1031 (let (x/1032 (field 1 (field 0 (global Code!)))) x/1032))
    (setfield_imm 1 (global Code!) a1/1031))
  (let
    (a2/1033
       (let
         (snd/1034 (function (param/1043, param/1044) param/1044)
          x/1036 (apply snd/1034 (field 0 (global Code!))))
         x/1036))
    (setfield_imm 2 (global Code!) a2/1033))
  (let (a3/1037 (field 1 (field 0 (global Code!))))
    (setfield_imm 3 (global Code!) a3/1037))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let (a/1030 (makeblock 0 (apply (field 0 (global String!)) 3 'c') 1))
    (setfield_imm 0 (global Code!) a/1030))
  (let (a1/1031 (let (x/1032 (field 1 (field 0 (global Code!)))) x/1032))
    (setfield_imm 1 (global Code!) a1/1031))
  (let
    (a2/1033
       (let
         (snd/1034 (function (param/1043, param/1044) param/1044)
          x/1036 (apply snd/1034 (field 0 (global Code!))))
         x/1036))
    (setfield_imm 2 (global Code!) a2/1033))
  (let (a3/1037 (field 1 (field 0 (global Code!))))
    (setfield_imm 3 (global Code!) a3/1037))
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let
    (a/1030
       (makeblock 0
         (let (s/1046 (caml_create_string 3))
           (seq (caml_fill_string s/1046 0 3 'c') s/1046))
         1))
    (setfield_imm 0 (global camlCode!) a/1030))
  (let (a1/1031 1) (setfield_imm 1 (global camlCode!) 1))
  (let
    (a2/1033
       (let
         (snd/1034
            (closure (camlCode__snd_1034(-2)  param/1043 param/1044
                       param/1044) {3} )
          x/1036
            (let
              (arg/1048 (field 0 (global camlCode!))
               param/1049 (field 1 arg/1048))
              (seq (field 0 arg/1048) param/1049)))
         x/1036))
    (setfield_imm 2 (global camlCode!) a2/1033))
  (setfield_imm 3 (global camlCode!) 1) 0a)
*** After TonClosure.optimize:
(let
  (a/1030
     (makeblock 0
       (let (s/1046 (caml_create_string 3))
         (seq (caml_fill_string s/1046 0 3 'c') s/1046))
       1))
  (seq (setfield_imm 0 (global camlCode!) a/1030)
    (setfield_imm 1 (global camlCode!) 1)
    (let (arg/1048 (field 0 (global camlCode!)))
      (seq (seq (field 0 arg/1048) 1) (setfield_imm 2 (global camlCode!) 1)
        (setfield_imm 3 (global camlCode!) 1) 0a))))

-dcmm
(data int 4096 global "camlCode" "camlCode": skip 16)
(function camlCode__entry ()
 (let
   a/1030
     (alloc 2048
       (let s/1046 (extcall "caml_create_string"{string.ml:30,10-18} 7 addr)
         (extcall "caml_fill_string"{string.ml:31,2-21} s/1046 1 7 199 unit)
         s/1046)
       3)
   (store "camlCode" a/1030) (store (+a "camlCode" 4) 3)
   (let arg/1048 (load "camlCode") (load arg/1048) [] 3 []
     (store (+a "camlCode" 8) 3) (store (+a "camlCode" 12) 3) 1a)))

(data)
-dlinear
Before simplify
camlCode__entry:
                  push 7
                  {}
                  R/0[%eax] := extcall "caml_create_string"  (noalloc) {string.ml:30,10-18}
                  offset stack -4
                  s/8[%ebx] := R/0[%eax]
                  push 199
                  push 7
                  push 1
                  push s/8[%ebx]
                  {s/8[%ebx]*}
                  extcall "caml_fill_string"  {string.ml:31,2-21}
                  offset stack -16
                  {A/9[%ebx]*}
                  a/10[%eax] := alloc 12
                  [a/10[%eax] + -4] := 2048
                  [a/10[%eax]] := A/9[%ebx]
                  [a/10[%eax] + 4] := 3
                  ["camlCode"] := a/10[%eax]
                  ["camlCode" + 4] := 3
                  arg/11[%eax] := ["camlCode"]
                  A/12[%eax] := [arg/11[%eax]]
                  I/13[%eax] := 3
                  ["camlCode" + 8] := 3
                  ["camlCode" + 12] := 3
                  A/14[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  push 7
  {}
  R/0[%eax] := extcall "caml_create_string"  (noalloc) {string.ml:30,10-18}
  offset stack -4
  s/8[%ebx] := R/0[%eax]
  push 199
  push 7
  push 1
  push s/8[%ebx]
  {s/8[%ebx]*}
  extcall "caml_fill_string"  {string.ml:31,2-21}
  offset stack -16
  {A/9[%ebx]*}
  a/10[%eax] := alloc 12
  [a/10[%eax] + -4] := 2048
  [a/10[%eax]] := A/9[%ebx]
  [a/10[%eax] + 4] := 3
  ["camlCode"] := a/10[%eax]
  ["camlCode" + 4] := 3
  arg/11[%eax] := ["camlCode"]
  A/12[%eax] := [arg/11[%eax]]
  I/13[%eax] := 3
  ["camlCode" + 8] := 3
  ["camlCode" + 12] := 3
  A/14[%eax] := 1
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
	.long	4096
	.globl	camlCode
camlCode:
	.space	16
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L100:
	pushl	$7
	movl	$caml_create_string, %eax
	call	caml_c_call
.L101:
	addl	$4, %esp
	movl	%eax, %ebx
	pushl	$199
	pushl	$7
	pushl	$1
	pushl	%ebx
	call	caml_fill_string
	addl	$16, %esp
	call	caml_alloc2
.L102:
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	%ebx, (%eax)
	movl	$3, 4(%eax)
	movl	%eax, camlCode
	movl	$3, camlCode + 4
	movl	camlCode, %eax
	movl	(%eax), %eax
	movl	$3, %eax
	movl	$3, camlCode + 8
	movl	$3, camlCode + 12
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
	.long	2
	.long	.L102
	.word	4
	.word	1
	.word	3
	.align	4
	.long	.L101
	.word	9
	.word	0
	.align	4
	.long	.L200000 - . + 0x48000000
	.long	0x1e0a0
.L200000:
	.ascii	"string.ml\0"
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

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
  (let (a/58 (makeblock 0 (apply (field 0 (global String!)) 3 'c') 1))
    (setfield_imm 0 (global Code!) a/58))
  (let (a1/59 (let (x/60 (field 1 (field 0 (global Code!)))) x/60))
    (setfield_imm 1 (global Code!) a1/59))
  (let
    (a2/61
       (let
         (snd/62 (function (param/71, param/72) (let (b/63 param/72) b/63))
          x/64 (apply snd/62 (field 0 (global Code!))))
         x/64))
    (setfield_imm 2 (global Code!) a2/61))
  (let
    (a3/65
       (let
         (x/66 (field 1 (field 0 (global Code!)))
          match/73 (field 0 (field 0 (global Code!))))
         x/66))
    (setfield_imm 3 (global Code!) a3/65))
  0a)
-dlambda
(seq
  (let (a/58 (makeblock 0 (apply (field 0 (global String!)) 3 'c') 1))
    (setfield_imm 0 (global Code!) a/58))
  (let (a1/59 (let (x/60 (field 1 (field 0 (global Code!)))) x/60))
    (setfield_imm 1 (global Code!) a1/59))
  (let
    (a2/61
       (let
         (snd/62 (function (param/71, param/72) param/72)
          x/64 (apply snd/62 (field 0 (global Code!))))
         x/64))
    (setfield_imm 2 (global Code!) a2/61))
  (let (a3/65 (field 1 (field 0 (global Code!))))
    (setfield_imm 3 (global Code!) a3/65))
  0a)

-dcmm
(data int 4096 global "camlCode" "camlCode": skip 16)
(data
 int 3319
 "camlCode__1":
 addr "caml_tuplify2"
 int -3
 addr "camlCode__snd_62")
(function camlCode__snd_62 (param/71: addr param/72: addr) param/72)

(function camlCode__entry ()
 (let a/58 (alloc 2048 (app "camlString__make_66" 7 199 addr) 3)
   (store "camlCode" a/58))
 (let a1/59 3 (store (+a "camlCode" 4) 3))
 (let
   a2/61
     (let
       (snd/62 "camlCode__1"
        x/64 (app (load snd/62) (load "camlCode") snd/62 addr))
       x/64)
   (store (+a "camlCode" 8) a2/61))
 (store (+a "camlCode" 12) 3) 1a)

(data)
-dlinear
*** Linearized code
camlCode__snd_62:
  param/9[%eax] := R/1[%ebx]
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  I/8[%ebx] := 199
  I/9[%eax] := 7
  {}
  R/0[%eax] := call "camlString__make_66" R/0[%eax] R/1[%ebx]
  A/10[%ebx] := R/0[%eax]
  {A/10[%ebx]*}
  a/11[%eax] := alloc 12
  [a/11[%eax] + -4] := 2048
  [a/11[%eax]] := A/10[%ebx]
  [a/11[%eax] + 4] := 3
  ["camlCode"] := a/11[%eax]
  a1/12[%eax] := 3
  ["camlCode" + 4] := 3
  snd/13[%ebx] := "camlCode__1"
  A/14[%eax] := ["camlCode"]
  A/15[%ecx] := [snd/13[%ebx]]
  {}
  R/0[%eax] := call A/15[%ecx] R/0[%eax] R/1[%ebx]
  ["camlCode" + 8] := a2/17[%eax]
  ["camlCode" + 12] := 3
  A/18[%eax] := 1
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
	.data
	.long	3319
camlCode__1:
	.long	caml_tuplify2
	.long	-3
	.long	camlCode__snd_62
	.text
	.align	16
	.globl	camlCode__snd_62
camlCode__snd_62:
.L100:
	movl	%ebx, %eax
	ret
	.type	camlCode__snd_62,@function
	.size	camlCode__snd_62,.-camlCode__snd_62
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L101:
	movl	$199, %ebx
	movl	$7, %eax
	call	camlString__make_66
.L102:
	movl	%eax, %ebx
	call	caml_alloc2
.L103:
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	%ebx, (%eax)
	movl	$3, 4(%eax)
	movl	%eax, camlCode
	movl	$3, %eax
	movl	$3, camlCode + 4
	movl	$camlCode__1, %ebx
	movl	camlCode, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L104:
	movl	%eax, camlCode + 8
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
	.long	3
	.long	.L104
	.word	4
	.word	0
	.align	4
	.long	.L103
	.word	4
	.word	1
	.word	3
	.align	4
	.long	.L102
	.word	4
	.word	0
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

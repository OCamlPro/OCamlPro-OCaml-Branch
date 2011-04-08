
let _ =
  let s = "a" ^ "b" ^ "c" in
  String.length s
  

(*
-drawlambda
(seq
  (let
    (s/58
       (apply (field 15 (global Pervasives!)) "a"
         (apply (field 15 (global Pervasives!)) "b" "c")))
    (string.length s/58))
  0a)
-dlambda
(seq
  (let
    (s/58
       (apply (field 15 (global Pervasives!)) "a"
         (apply (field 15 (global Pervasives!)) "b" "c")))
    (string.length s/58))
  0a)

-dcmm
(data int 0 global "camlCode" "camlCode": skip 0)
(data int 1276 "camlCode__1": string "a" skip 2 byte 2)
(data int 1276 "camlCode__2": string "b" skip 2 byte 2)
(data int 1276 "camlCode__3": string "c" skip 2 byte 2)
(function camlCode__entry ()
 (let
   s/58
     (app "camlPervasives__^_136" "camlCode__1"
       (app "camlPervasives__^_136" "camlCode__2" "camlCode__3" addr) addr)
   (+
     (<<
       (let tmp/59 (- (<< (>>u (load (+a s/58 -4)) 10) 2) 1)
         (- tmp/59 (load unsigned int8 (+a s/58 tmp/59))))
       1)
     1)
   [])
 1a)

(data)
-dlinear
*** Linearized code
camlCode__entry:
  A/8[%ebx] := "camlCode__3"
  A/9[%eax] := "camlCode__2"
  {}
  R/0[%eax] := call "camlPervasives__^_136" R/0[%eax] R/1[%ebx]
  A/10[%ebx] := R/0[%eax]
  A/11[%eax] := "camlCode__1"
  {}
  R/0[%eax] := call "camlPervasives__^_136" R/0[%eax] R/1[%ebx]
  s/12[%ecx] := R/0[%eax]
  A/13[%ebx] := [s/12[%ecx] + -4]
  I/14[%ebx] := I/14[%ebx] >>u 10
  tmp/15[%eax] := I/14[%ebx]  * 4 + -1
  I/16[%ebx] := unsigned int8[s/12[%ecx] + tmp/15[%eax]]
  I/17[%eax] := I/17[%eax] - I/16[%ebx]
  I/18[%eax] := I/17[%eax]  * 2 + 1
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
	.long	1276
camlCode__1:
	.ascii	"a"
	.space	2
	.byte	2
	.data
	.long	1276
camlCode__2:
	.ascii	"b"
	.space	2
	.byte	2
	.data
	.long	1276
camlCode__3:
	.ascii	"c"
	.space	2
	.byte	2
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L100:
	movl	$camlCode__3, %ebx
	movl	$camlCode__2, %eax
	call	camlPervasives__$5e_136
.L101:
	movl	%eax, %ebx
	movl	$camlCode__1, %eax
	call	camlPervasives__$5e_136
.L102:
	movl	%eax, %ecx
	movl	-4(%ecx), %ebx
	shrl	$10, %ebx
	lea	-1(, %ebx, 4), %eax
	movzbl	(%ecx, %eax), %ebx
	subl	%ebx, %eax
	lea	1(%eax, %eax), %eax
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
	.word	0
	.align	4
	.long	.L101
	.word	4
	.word	0
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

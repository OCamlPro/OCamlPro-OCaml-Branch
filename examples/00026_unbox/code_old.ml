
let _ =
  let r = ref 0.0 in
  for i = 0 to 1000000000 do r := float i done;
  Printf.printf "%f\n" !r
  

(*
-drawlambda
(seq
  (let (r/58 (makemutable 0 0.0))
    (seq (for i/59 0 to 1000000000 (setfield_ptr 0 r/58 (float_of_int i/59)))
      (apply (field 1 (global Printf!)) "%f\n" (field 0 r/58))))
  0a)
-dlambda
(seq
  (let (r/58 0.0)
    (seq (for i/59 0 to 1000000000 (assign r/58 (float_of_int i/59)))
      (apply (field 1 (global Printf!)) "%f\n" r/58)))
  0a)

-dcmm
(data int 0 global "camlCode" "camlCode": skip 0)
(data int 1276 "camlCode__1": string "%f
" skip 0 byte 0)
(data int 2301 "camlCode__2": double 0.0)
(function camlCode__entry ()
 (let r/58 "camlCode__2"
   (let i/59 1
     (catch
       (if (> i/59 2000000001) (exit 2)
         (loop (assign r/58 (alloc 2301 (floatofint (>>s i/59 1))))
           (let i/62 i/59 (assign i/59 (+ i/59 2))
             (if (== i/62 2000000001) (exit 2) []))))
     with(2) []))
   (let fun/61 (app "camlPrintf__printf_425" "camlCode__1" addr)
     (app (load fun/61) r/58 fun/61 unit)))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__entry:
  r/8[%ecx] := "camlCode__2"
  i/9[%ebx] := 1
  I/10[%eax] := 2000000001
  if i/9[%ebx] <=s I/10[%eax] goto L101
  spilled-r/21[s0] := r/8[%ecx] (spill)
  goto L100
  L101:
  {i/9[%ebx]}
  A/11[%ecx] := alloc 12
  [A/11[%ecx] + -4] := 2301
  I/12[%eax] := i/9[%ebx]
  I/12[%eax] := I/12[%eax] >>s 1
  R/7[%tos] := floatofint I/12[%eax]
  float64u[A/11[%ecx]] := R/7[%tos]
  spilled-r/21[s0] := r/8[%ecx] (spill)
  i/14[%ecx] := i/9[%ebx]
  I/15[%ebx] := I/15[%ebx] + 2
  I/16[%eax] := 2000000001
  if i/14[%ecx] !=s I/16[%eax] goto L101
  L100:
  A/17[%eax] := "camlCode__1"
  {spilled-r/21[s0]*}
  R/0[%eax] := call "camlPrintf__printf_425" R/0[%eax]
  fun/18[%ebx] := R/0[%eax]
  A/19[%ecx] := [fun/18[%ebx]]
  r/22[%eax] := spilled-r/21[s0] (reload)
  {}
  call A/19[%ecx] R/0[%eax] R/1[%ebx]
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
	.long	0
	.globl	camlCode
camlCode:
	.data
	.long	1276
camlCode__1:
	.ascii	"%f\12"
	.byte	0
	.data
	.long	2301
camlCode__2:
	.long	0x0, 0x0
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$12, %esp
.L102:
	movl	$camlCode__2, %ecx
	movl	$1, %ebx
	movl	$2000000001, %eax
	cmpl	%eax, %ebx
	jle	.L101
	movl	%ecx, 0(%esp)
	jmp	.L100
.L101:
	call	caml_alloc2
.L103:
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	%ebx, %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	(%ecx)
	movl	%ecx, 0(%esp)
	movl	%ebx, %ecx
	addl	$2, %ebx
	movl	$2000000001, %eax
	cmpl	%eax, %ecx
	jne	.L101
.L100:
	movl	$camlCode__1, %eax
	call	camlPrintf__printf_425
.L104:
	movl	%eax, %ebx
	movl	(%ebx), %ecx
	movl	0(%esp), %eax
	call	*%ecx
.L105:
	movl	$1, %eax
	addl	$12, %esp
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
	.long	.L105
	.word	16
	.word	0
	.align	4
	.long	.L104
	.word	16
	.word	1
	.word	0
	.align	4
	.long	.L103
	.word	16
	.word	0
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

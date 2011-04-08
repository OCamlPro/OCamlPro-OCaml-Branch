
let _ =
  let r = ref 0.0 in
  for i = 0 to 1000000000 do r := float i done;
  Printf.printf "%f\n" !r
  

(*
-drawlambda
(seq
  (let (r/1030 (makemutable 0 0.0))
    (seq
      (for i/1031 0 to 1000000000
        (setfield_ptr 0 r/1030 (float_of_int i/1031)))
      (apply (field 1 (global Printf!)) "%f\n" (field 0 r/1030))))
  0a)
-dlambda
(seq
  (let (r/1030 0.0)
    (seq (for i/1031 0 to 1000000000 (assign r/1030 (float_of_int i/1031)))
      (apply (field 1 (global Printf!)) "%f\n" r/1030)))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let (r/1030 0.0)
    (seq (for i/1031 0 to 1000000000 (assign r/1030 (float_of_int i/1031)))
      (apply (field 1 (global Printf!)) "%f\n" r/1030)))
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let (r/1030[Variable] 0.0)
    (seq (for i/1031 0 to 1000000000 (assign r/1030 (float_of_int i/1031)))
      (apply
        (apply
          (camlPrintf__fprintf_1391  (field 23 (global camlPervasives!)))
          "%f\n")
        r/1030)))
  0a)
*** After TonClosure.optimize:
(seq
  (let (r/1030[Variable] 0.0)
    (seq (for i/1031 0 to 1000000000 (assign r/1030 (float_of_int i/1031)))
      (apply
        (apply
          (camlPrintf__fprintf_1391  (field 23 (global camlPervasives!)))
          "%f\n")
        r/1030)))
  0a)

-dcmm
(data int 0 global "camlCode" "camlCode": skip 0)
(data
 global "camlCode__1"
 int 1276
 "camlCode__1":
 string "%f
"
 skip 0
 byte 0)
(function camlCode__entry ()
 (let r/1032 0.0
   (let i/1031 1
     (catch
       (if (> i/1031 2000000001) (exit 2)
         (loop (assign r/1032 (floatofint (>>s i/1031 1)))
           (let i/1035 i/1031 (assign i/1031 (+ i/1031 2))
             (if (== i/1035 2000000001) (exit 2) []))))
     with(2) []))
   (let
     fun/1034
       (let
         fun/1033
           (app{printf.ml:641,17-35} "camlPrintf__fprintf_1391"
             (load (+a "camlPervasives" 92)) addr)
         (app{printf.ml:641,17-35} (load fun/1033) "camlCode__1" fun/1033
           addr))
     (app (load fun/1034) (let r/1030 (alloc 2301 r/1032) r/1030) fun/1034
       unit)))
 1a)

(data)
-dlinear
Before simplify
camlCode__entry:
                  R/7[%tos] := 0.0
                  r/9[s0] := R/7[%tos]
                  i/10[%ebx] := 1
                  I/11[%eax] := 2000000001
                  if i/10[%ebx] <=s I/11[%eax] goto L101
                  goto L100
                  L101 [0]:
                  I/12[%eax] := i/10[%ebx]
                  I/12[%eax] := I/12[%eax] >>s 1
                  R/7[%tos] := floatofint I/12[%eax]
                  r/9[s0] := R/7[%tos]
                  i/14[%ecx] := i/10[%ebx]
                  I/15[%ebx] := I/15[%ebx] + 2
                  I/16[%eax] := 2000000001
                  if i/14[%ecx] !=s I/16[%eax] goto L101
                  L100 [0]:
                  A/17[%eax] := ["camlPervasives" + 92]
                  {spilled-r/26[s0]}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
                  fun/18[%ebx] := R/0[%eax]
                  A/19[%eax] := "camlCode__1"
                  A/20[%ecx] := [fun/18[%ebx]]
                  {spilled-r/26[s0]}
                  R/0[%eax] := call A/20[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
                  fun/21[%ebx] := R/0[%eax]
                  {fun/21[%ebx]* spilled-r/26[s0]}
                  r/22[%eax] := alloc 12
                  [r/22[%eax] + -4] := 2301
                  float64u[r/22[%eax]] := r/27[s0]
                  A/24[%ecx] := [fun/21[%ebx]]
                  {}
                  call A/24[%ecx] R/0[%eax] R/1[%ebx]
                  A/25[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  R/7[%tos] := 0.0
  r/9[s0] := R/7[%tos]
  i/10[%ebx] := 1
  I/11[%eax] := 2000000001
  if i/10[%ebx] <=s I/11[%eax] goto L101
  goto L100
  L101 [4]:
  I/12[%eax] := i/10[%ebx]
  I/12[%eax] := I/12[%eax] >>s 1
  R/7[%tos] := floatofint I/12[%eax]
  r/9[s0] := R/7[%tos]
  i/14[%ecx] := i/10[%ebx]
  I/15[%ebx] := I/15[%ebx] + 2
  I/16[%eax] := 2000000001
  if i/14[%ecx] !=s I/16[%eax] goto L101
  L100 [3]:
  A/17[%eax] := ["camlPervasives" + 92]
  {spilled-r/26[s0]}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax] {printf.ml:641,17-35}
  fun/18[%ebx] := R/0[%eax]
  A/19[%eax] := "camlCode__1"
  A/20[%ecx] := [fun/18[%ebx]]
  {spilled-r/26[s0]}
  R/0[%eax] := call A/20[%ecx] R/0[%eax] R/1[%ebx] {printf.ml:641,17-35}
  fun/21[%ebx] := R/0[%eax]
  {fun/21[%ebx]* spilled-r/26[s0]}
  r/22[%eax] := alloc 12
  [r/22[%eax] + -4] := 2301
  float64u[r/22[%eax]] := r/27[s0]
  A/24[%ecx] := [fun/21[%ebx]]
  {}
  call A/24[%ecx] R/0[%eax] R/1[%ebx]
  A/25[%eax] := 1
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
	.globl	camlCode__1
	.long	1276
camlCode__1:
	.ascii	"%f\12"
	.byte	0
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$8, %esp
.L102:
	fldz
	fstpl	0(%esp)
	movl	$1, %ebx
	movl	$2000000001, %eax
	cmpl	%eax, %ebx
	jle	.L101
	jmp	.L100
.L101:
	movl	%ebx, %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fstpl	0(%esp)
	movl	%ebx, %ecx
	addl	$2, %ebx
	movl	$2000000001, %eax
	cmpl	%eax, %ecx
	jne	.L101
.L100:
	movl	camlPervasives + 92, %eax
	call	camlPrintf__fprintf_1391
.L103:
	movl	%eax, %ebx
	movl	$camlCode__1, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L104:
	movl	%eax, %ebx
	call	caml_alloc2
.L105:
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	0(%esp)
	fstpl	(%eax)
	movl	(%ebx), %ecx
	call	*%ecx
.L106:
	movl	$1, %eax
	addl	$8, %esp
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
	.word	12
	.word	0
	.align	4
	.long	.L105
	.word	12
	.word	1
	.word	3
	.align	4
	.long	.L104
	.word	13
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
	.long	.L103
	.word	13
	.word	0
	.align	4
	.long	.L200000 - . + 0x8c000000
	.long	0x281110
.L200000:
	.ascii	"printf.ml\0"
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

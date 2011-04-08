
let fib20 =
  let rec fib x =
    if x < 2 then 1 else
      fib (x - 1) + (fib x - 2)
  in
    fib 20


(*
-drawlambda
(seq
  (let
    (fib20/58
       (letrec
         (fib/59
            (function x/60
              (if (< x/60 2) 1
                (+ (apply fib/59 (- x/60 1)) (- (apply fib/59 x/60) 2)))))
         (apply fib/59 20)))
    (setfield_imm 0 (global Code!) fib20/58))
  0a)
-dlambda
(seq
  (let
    (fib20/58
       (letrec
         (fib/59
            (function x/60
              (if (< x/60 2) 1
                (+ (apply fib/59 (- x/60 1)) (- (apply fib/59 x/60) 2)))))
         (apply fib/59 20)))
    (setfield_imm 0 (global Code!) fib20/58))
  0a)

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 4)
(data int 2295 "camlCode__1": addr "camlCode__fib_59" int 3)
(function camlCode__fib_59 (x/60: addr)
 (if (< x/60 5) 3
   (+
     (+ (app "camlCode__fib_59" (+ x/60 -2) addr)
       (app "camlCode__fib_59" x/60 addr))
     -5)))

(function camlCode__entry ()
 (let fib20/58 (let clos/63 "camlCode__1" (app "camlCode__fib_59" 41 addr))
   (store "camlCode" fib20/58))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__fib_59:
  if x/8[%eax] >=s 5 goto L100
  I/14[%eax] := 3
  reload retaddr
  return R/0[%eax]
  L100:
  spilled-x/16[s0] := x/8[%eax] (spill)
  {spilled-x/16[s0]*}
  R/0[%eax] := call "camlCode__fib_59" R/0[%eax]
  A/15[s1] := A/9[%eax] (spill)
  x/17[%eax] := spilled-x/16[s0] (reload)
  I/10[%eax] := I/10[%eax] + -2
  {A/15[s1]*}
  R/0[%eax] := call "camlCode__fib_59" R/0[%eax]
  A/18[%ebx] := A/15[s1] (reload)
  I/12[%eax] := I/12[%eax] + A/18[%ebx]
  I/13[%eax] := I/13[%eax] + -5
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  clos/8[%eax] := "camlCode__1"
  I/9[%eax] := 41
  {}
  R/0[%eax] := call "camlCode__fib_59" R/0[%eax]
  ["camlCode"] := fib20/10[%eax]
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
	.long	camlCode__fib_59
	.long	3
	.text
	.align	16
	.globl	camlCode__fib_59
camlCode__fib_59:
	subl	$8, %esp
.L101:
	cmpl	$5, %eax
	jge	.L100
	movl	$3, %eax
	addl	$8, %esp
	ret
	.align	16
.L100:
	movl	%eax, 0(%esp)
	call	camlCode__fib_59
.L102:
	movl	%eax, 4(%esp)
	movl	0(%esp), %eax
	addl	$-2, %eax
	call	camlCode__fib_59
.L103:
	movl	4(%esp), %ebx
	addl	%ebx, %eax
	addl	$-5, %eax
	addl	$8, %esp
	ret
	.type	camlCode__fib_59,@function
	.size	camlCode__fib_59,.-camlCode__fib_59
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L104:
	movl	$camlCode__1, %eax
	movl	$41, %eax
	call	camlCode__fib_59
.L105:
	movl	%eax, camlCode
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
	.long	.L105
	.word	4
	.word	0
	.align	4
	.long	.L103
	.word	12
	.word	1
	.word	4
	.align	4
	.long	.L102
	.word	12
	.word	1
	.word	0
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

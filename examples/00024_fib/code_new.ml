
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
    (fib20/1030
       (letrec
         (fib/1031
            (function x/1032
              (if (< x/1032 2) 1
                (+ (apply fib/1031 (- x/1032 1))
                  (- (apply fib/1031 x/1032) 2)))))
         (apply fib/1031 20)))
    (setfield_imm 0 (global Code!) fib20/1030))
  0a)
-dlambda
(seq
  (let
    (fib20/1030
       (letrec
         (fib/1031
            (function x/1032
              (if (< x/1032 2) 1
                (+ (apply fib/1031 (- x/1032 1))
                  (- (apply fib/1031 x/1032) 2)))))
         (apply fib/1031 20)))
    (setfield_imm 0 (global Code!) fib20/1030))
  0a)
checking tailcall on fib/1031
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (fib20/1030
       (letrec
         (fib/1031
            (function x/1032
              (if (< x/1032 2) 1
                (+ (apply fib/1031 (- x/1032 1))
                  (- (apply fib/1031 x/1032) 2)))))
         (apply fib/1031 20)))
    (setfield_imm 0 (global Code!) fib20/1030))
  0a)
checking tailcall on fib/1031
-dclosure
*** After Closure.intro:
(seq
  (let
    (fib20/1030
       (let
         (clos/1035
            (closure (camlCode__fib_1031(1)  x/1032
                       (if (< x/1032 2) 1
                         (+ (camlCode__fib_1031  (- x/1032 1))
                           (- (camlCode__fib_1031  x/1032) 2)))) {2} ))
         (camlCode__fib_1031  20)))
    (setfield_imm 0 (global camlCode!) fib20/1030))
  0a)
*** After TonClosure.optimize:
(seq
  (closure (camlCode__fib_1031(1)  x/1032
             (if (< x/1032 2) 1
               (+ (camlCode__fib_1031  (- x/1032 1))
                 (- (camlCode__fib_1031  x/1032) 2)))) {2} )
  (let (fib20/1030 (camlCode__fib_1031  20))
    (seq (setfield_imm 0 (global camlCode!) fib20/1030) 0a)))

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 4)
(data int 2295 "camlCode__1": addr "camlCode__fib_1031" int 3)
(function camlCode__fib_1031 (x/1032: addr)
 (if (< x/1032 5) 3
   (+
     (+ (app "camlCode__fib_1031" (+ x/1032 -2) addr)
       (app "camlCode__fib_1031" x/1032 addr))
     -5)))

(function camlCode__entry ()
 "camlCode__1" []
 (let fib20/1030 (app "camlCode__fib_1031" 41 addr)
   (store "camlCode" fib20/1030) 1a))

(data)
-dlinear
Before simplify
camlCode__fib_1031:
                  if x/8[%eax] >=s 5 goto L100
                  I/14[%eax] := 3
                  reload retaddr
                  return R/0[%eax]
                  L100 [0]:
                  spilled-x/16[s0] := x/8[%eax] (spill)
                  {spilled-x/16[s0]*}
                  R/0[%eax] := call "camlCode__fib_1031" R/0[%eax]
                  A/15[s1] := A/9[%eax] (spill)
                  x/17[%eax] := spilled-x/16[s0] (reload)
                  I/10[%eax] := I/10[%eax] + -2
                  {A/15[s1]*}
                  R/0[%eax] := call "camlCode__fib_1031" R/0[%eax]
                  A/18[%ebx] := A/15[s1] (reload)
                  I/12[%eax] := I/12[%eax] + A/18[%ebx]
                  I/13[%eax] := I/13[%eax] + -5
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__fib_1031:
  if x/8[%eax] >=s 5 goto L100
  I/14[%eax] := 3
  reload retaddr
  return R/0[%eax]
  L100 [2]:
  spilled-x/16[s0] := x/8[%eax] (spill)
  {spilled-x/16[s0]*}
  R/0[%eax] := call "camlCode__fib_1031" R/0[%eax]
  A/15[s1] := A/9[%eax] (spill)
  x/17[%eax] := spilled-x/16[s0] (reload)
  I/10[%eax] := I/10[%eax] + -2
  {A/15[s1]*}
  R/0[%eax] := call "camlCode__fib_1031" R/0[%eax]
  A/18[%ebx] := A/15[s1] (reload)
  I/12[%eax] := I/12[%eax] + A/18[%ebx]
  I/13[%eax] := I/13[%eax] + -5
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  A/8[%eax] := "camlCode__1"
                  I/9[%eax] := 41
                  {}
                  R/0[%eax] := call "camlCode__fib_1031" R/0[%eax]
                  ["camlCode"] := fib20/10[%eax]
                  A/11[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  A/8[%eax] := "camlCode__1"
  I/9[%eax] := 41
  {}
  R/0[%eax] := call "camlCode__fib_1031" R/0[%eax]
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
	.long	camlCode__fib_1031
	.long	3
	.text
	.align	16
	.globl	camlCode__fib_1031
camlCode__fib_1031:
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
	call	camlCode__fib_1031
.L102:
	movl	%eax, 4(%esp)
	movl	0(%esp), %eax
	addl	$-2, %eax
	call	camlCode__fib_1031
.L103:
	movl	4(%esp), %ebx
	addl	%ebx, %eax
	addl	$-5, %eax
	addl	$8, %esp
	ret
	.type	camlCode__fib_1031,@function
	.size	camlCode__fib_1031,.-camlCode__fib_1031
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L104:
	movl	$camlCode__1, %eax
	movl	$41, %eax
	call	camlCode__fib_1031
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

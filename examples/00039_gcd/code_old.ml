let rec gcd m n =
  if m = 0 then n else
  if m <= n then gcd m (n-m) else
  gcd n (m-n)

    
let _ =
  let x = ref 0 in
  for i = 1 to 1000 do
    for j = 1 to 1000 do
      x := gcd i j
    done
  done
  (*
-drawlambda
(seq
  (letrec
    (gcd/1030
       (function m/1031 n/1032
         (if (== m/1031 0) n/1032
           (if (<= m/1031 n/1032) (apply gcd/1030 m/1031 (- n/1032 m/1031))
             (apply gcd/1030 n/1032 (- m/1031 n/1032))))))
    (setfield_imm 0 (global Code!) gcd/1030))
  (let (x/1033 (makemutable 0 0))
    (for i/1034 1 to 1000
      (for j/1035 1 to 1000
        (setfield_imm 0 x/1033
          (apply (field 0 (global Code!)) i/1034 j/1035)))))
  0a)
-dlambda
(seq
  (letrec
    (gcd/1030
       (function m/1031 n/1032
         (if (== m/1031 0) n/1032
           (if (<= m/1031 n/1032) (apply gcd/1030 m/1031 (- n/1032 m/1031))
             (apply gcd/1030 n/1032 (- m/1031 n/1032))))))
    (setfield_imm 0 (global Code!) gcd/1030))
  (let (x/1033 0)
    (for i/1034 1 to 1000
      (for j/1035 1 to 1000
        (assign x/1033 (apply (field 0 (global Code!)) i/1034 j/1035)))))
  0a)

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 4)
(data
 int 3319
 "camlCode__1":
 addr "caml_curry2"
 int 5
 addr "camlCode__gcd_1030")
(function camlCode__gcd_1030 (m/1031: addr n/1032: addr)
 (if (== m/1031 1) n/1032
   (if (<= m/1031 n/1032)
     (app "camlCode__gcd_1030" m/1031 (+ (- n/1032 m/1031) 1) addr)
     (app "camlCode__gcd_1030" n/1032 (+ (- m/1031 n/1032) 1) addr))))

(function camlCode__entry ()
 (let clos/1038 "camlCode__1" (store "camlCode" clos/1038))
 (let (x/1033 1 i/1034 3)
   (catch
     (if (> i/1034 2001) (exit 2)
       (loop
         (let j/1035 3
           (catch
             (if (> j/1035 2001) (exit 3)
               (loop
                 (assign x/1033 (app "camlCode__gcd_1030" i/1034 j/1035 addr))
                 (let j/1040 j/1035 (assign j/1035 (+ j/1035 2))
                   (if (== j/1040 2001) (exit 3) []))))
           with(3) []))
         (let i/1039 i/1034 (assign i/1034 (+ i/1034 2))
           (if (== i/1039 2001) (exit 2) []))))
   with(2) []))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__gcd_1030:
  if m/8[%eax] !=s 1 goto L101
  R/0[%eax] := n/9[%ebx]
  return R/0[%eax]
  L101:
  if m/8[%eax] >s n/9[%ebx] goto L100
  I/12[%ebx] := I/12[%ebx] - m/8[%eax]
  I/13[%ebx] := I/13[%ebx] + 1
  tailcall "camlCode__gcd_1030" R/0[%eax] R/1[%ebx]
  L100:
  I/10[%ecx] := m/8[%eax]
  I/10[%ecx] := I/10[%ecx] - n/9[%ebx]
  I/11[%ecx] := I/11[%ecx] + 1
  R/0[%eax] := n/9[%ebx]
  R/1[%ebx] := I/11[%ecx]
  tailcall "camlCode__gcd_1030" R/0[%eax] R/1[%ebx]
  
*** Linearized code
camlCode__entry:
  clos/8[%eax] := "camlCode__1"
  ["camlCode"] := clos/8[%eax]
  x/9[%eax] := 1
  i/10[%eax] := 3
  if i/10[%eax] >s 2001 goto L103
  spilled-i/19[s0] := i/10[%eax] (spill)
  L104:
  j/11[%ebx] := 3
  spilled-j/18[s1] := j/11[%ebx] (spill)
  if j/11[%ebx] >s 2001 goto L105
  L106:
  i/20[%eax] := spilled-i/19[s0] (reload)
  {spilled-j/18[s1] spilled-i/19[s0]}
  R/0[%eax] := call "camlCode__gcd_1030" R/0[%eax] R/1[%ebx]
  j/11[%ebx] := spilled-j/18[s1] (reload)
  j/13[%eax] := j/11[%ebx]
  I/14[%ebx] := I/14[%ebx] + 2
  spilled-j/18[s1] := j/11[%ebx] (spill)
  if j/13[%eax] !=s 2001 goto L106
  L105:
  i/22[%eax] := spilled-i/19[s0] (reload)
  i/15[%ebx] := i/22[%eax]
  I/16[%eax] := I/16[%eax] + 2
  spilled-i/19[s0] := i/22[%eax] (spill)
  if i/15[%ebx] !=s 2001 goto L104
  L103:
  A/17[%eax] := 1
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
	.long	3319
camlCode__1:
	.long	caml_curry2
	.long	5
	.long	camlCode__gcd_1030
	.text
	.align	16
	.globl	camlCode__gcd_1030
camlCode__gcd_1030:
.L102:
	cmpl	$1, %eax
	jne	.L101
	movl	%ebx, %eax
	ret
	.align	16
.L101:
	cmpl	%ebx, %eax
	jg	.L100
	subl	%eax, %ebx
	incl	%ebx
	jmp	.L102
	.align	16
.L100:
	movl	%eax, %ecx
	subl	%ebx, %ecx
	incl	%ecx
	movl	%ebx, %eax
	movl	%ecx, %ebx
	jmp	.L102
	.type	camlCode__gcd_1030,@function
	.size	camlCode__gcd_1030,.-camlCode__gcd_1030
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$8, %esp
.L107:
	movl	$camlCode__1, %eax
	movl	%eax, camlCode
	movl	$1, %eax
	movl	$3, %eax
	cmpl	$2001, %eax
	jg	.L103
	movl	%eax, 0(%esp)
.L104:
	movl	$3, %ebx
	movl	%ebx, 4(%esp)
	cmpl	$2001, %ebx
	jg	.L105
.L106:
	movl	0(%esp), %eax
	call	camlCode__gcd_1030
.L108:
	movl	4(%esp), %ebx
	movl	%ebx, %eax
	addl	$2, %ebx
	movl	%ebx, 4(%esp)
	cmpl	$2001, %eax
	jne	.L106
.L105:
	movl	0(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 0(%esp)
	cmpl	$2001, %ebx
	jne	.L104
.L103:
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
	.long	1
	.long	.L108
	.word	12
	.word	0
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

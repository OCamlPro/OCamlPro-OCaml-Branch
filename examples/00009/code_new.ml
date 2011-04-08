(* This example shows that references can be translated to variables when
not appearing in a closure or as argument. Even simple float records are
translated. However, in the latter case, on x86, the removed reference is
translated back to equivalent code. *)

let f1 n =
  let r = ref n in
    for i = 0 to 10 do incr r done;
    !r

type float_ref = { mutable float : float }

let f2 n =
  let r = { float = n } in
    for i = 0 to 10 do r.float <- r.float +. 1. done;
    r.float
(*
-drawlambda
(seq
  (let
    (f1/1030
       (function n/1031
         (let (r/1032 (makemutable 0 n/1031))
           (seq (for i/1033 0 to 10 (+:=1 r/1032)) (field 0 r/1032)))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1037
       (function n/1038
         (let (r/1039 (makearray  n/1038))
           (seq
             (for i/1040 0 to 10
               (setfloatfield 0 r/1039 (+. (floatfield 0 r/1039) 1.)))
             (floatfield 0 r/1039)))))
    (setfield_imm 1 (global Code!) f2/1037))
  0a)
-dlambda
(seq
  (let
    (f1/1030
       (function n/1031
         (let (r/1032 n/1031)
           (seq (for i/1033 0 to 10 (assign r/1032 (1+ r/1032))) r/1032))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1037
       (function n/1038
         (let (r/1039 (makearray  n/1038))
           (seq
             (for i/1040 0 to 10
               (setfloatfield 0 r/1039 (+. (floatfield 0 r/1039) 1.)))
             (floatfield 0 r/1039)))))
    (setfield_imm 1 (global Code!) f2/1037))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (f1/1030
       (function n/1031
         (let (r/1032 n/1031)
           (seq (for i/1033 0 to 10 (assign r/1032 (1+ r/1032))) r/1032))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1037
       (function n/1038
         (let (r/1039 (makearray  n/1038))
           (seq
             (for i/1040 0 to 10
               (setfloatfield 0 r/1039 (+. (floatfield 0 r/1039) 1.)))
             (floatfield 0 r/1039)))))
    (setfield_imm 1 (global Code!) f2/1037))
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let
    (f1/1030
       (closure (camlCode__f1_1030(1)  n/1031
                  (let (r/1032[Variable] n/1031)
                    (seq (for i/1033 0 to 10 (assign r/1032 (1+ r/1032)))
                      r/1032))) {2} ))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let
    (f2/1037
       (closure (camlCode__f2_1037(1)  n/1038
                  (let (r/1039 (makearray  n/1038))
                    (seq
                      (for i/1040 0 to 10
                        (setfloatfield 0 r/1039
                          (+. (floatfield 0 r/1039) 1.)))
                      (floatfield 0 r/1039)))) {2} ))
    (setfield_imm 1 (global camlCode!) f2/1037))
  0a)
*** After TonClosure.optimize:
(let
  (f1/1030
     (closure (camlCode__f1_1030(1)  n/1031
                (let (r/1032[Variable] n/1031)
                  (seq (for i/1033 0 to 10 (assign r/1032 (1+ r/1032)))
                    r/1032))) {2} ))
  (seq (setfield_imm 0 (global camlCode!) f1/1030)
    (let
      (f2/1037
         (closure (camlCode__f2_1037(1)  n/1038
                    (let (r/1039 (makearray  n/1038))
                      (seq
                        (for i/1040 0 to 10
                          (setfloatfield 0 r/1039
                            (+. (floatfield 0 r/1039) 1.)))
                        (floatfield 0 r/1039)))) {2} ))
      (seq (setfield_imm 1 (global camlCode!) f2/1037) 0a))))

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__f2_1037" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f1_1030" int 3)
(function camlCode__f1_1030 (n/1031: addr)
 (let r/1032 n/1031
   (let i/1033 1
     (catch
       (if (> i/1033 21) (exit 6)
         (loop (assign r/1032 (+ r/1032 2))
           (let i/1049 i/1033 (assign i/1033 (+ i/1033 2))
             (if (== i/1049 21) (exit 6) []))))
     with(6) []))
   r/1032))

(function camlCode__f2_1037 (n/1038: addr)
 (let r/1039 (alloc 2302 (load float64u n/1038))
   (let i/1040 1
     (catch
       (if (> i/1040 21) (exit 5)
         (loop (store float64u r/1039 (+f (load float64u r/1039) 1.))
           (let i/1048 i/1040 (assign i/1040 (+ i/1040 2))
             (if (== i/1048 21) (exit 5) []))))
     with(5) []))
   (alloc 2301 (load float64u r/1039))))

(function camlCode__entry ()
 (let f1/1030 "camlCode__2" (store "camlCode" f1/1030)
   (let f2/1037 "camlCode__1" (store (+a "camlCode" 4) f2/1037) 1a)))

(data)
-dlinear
Before simplify
camlCode__f1_1030:
                  i/10[%ebx] := 1
                  if i/10[%ebx] >s 21 goto L100
                  L101 [0]:
                  I/11[%eax] := I/11[%eax] + 2
                  i/12[%ecx] := i/10[%ebx]
                  I/13[%ebx] := I/13[%ebx] + 2
                  if i/12[%ecx] !=s 21 goto L101
                  L100 [0]:
                  return R/0[%eax]
                  *** Linearized code
camlCode__f1_1030:
  i/10[%ebx] := 1
  if i/10[%ebx] >s 21 goto L100
  L101 [4]:
  I/11[%eax] := I/11[%eax] + 2
  i/12[%ecx] := i/10[%ebx]
  I/13[%ebx] := I/13[%ebx] + 2
  if i/12[%ecx] !=s 21 goto L101
  L100 [4]:
  return R/0[%eax]
  
Before simplify
camlCode__f2_1037:
                  n/8[%ebx] := R/0[%eax]
                  {n/8[%ebx]*}
                  r/9[%ecx] := alloc 12
                  [r/9[%ecx] + -4] := 2302
                  R/7[%tos] := float64u[n/8[%ebx]]
                  float64u[r/9[%ecx]] := R/7[%tos]
                  i/11[%eax] := 1
                  if i/11[%eax] >s 21 goto L103
                  L104 [0]:
                  R/7[%tos] := 1.
                  R/7[%tos] := R/7[%tos] +f float64[r/9[%ecx]]
                  float64u[r/9[%ecx]] := R/7[%tos]
                  i/14[%ebx] := i/11[%eax]
                  I/15[%eax] := I/15[%eax] + 2
                  if i/14[%ebx] !=s 21 goto L104
                  L103 [0]:
                  {r/9[%ecx]*}
                  A/16[%eax] := alloc 12
                  [A/16[%eax] + -4] := 2301
                  R/7[%tos] := float64u[r/9[%ecx]]
                  float64u[A/16[%eax]] := R/7[%tos]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f2_1037:
  n/8[%ebx] := R/0[%eax]
  {n/8[%ebx]*}
  r/9[%ecx] := alloc 12
  [r/9[%ecx] + -4] := 2302
  R/7[%tos] := float64u[n/8[%ebx]]
  float64u[r/9[%ecx]] := R/7[%tos]
  i/11[%eax] := 1
  if i/11[%eax] >s 21 goto L103
  L104 [4]:
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] +f float64[r/9[%ecx]]
  float64u[r/9[%ecx]] := R/7[%tos]
  i/14[%ebx] := i/11[%eax]
  I/15[%eax] := I/15[%eax] + 2
  if i/14[%ebx] !=s 21 goto L104
  L103 [4]:
  {r/9[%ecx]*}
  A/16[%eax] := alloc 12
  [A/16[%eax] + -4] := 2301
  R/7[%tos] := float64u[r/9[%ecx]]
  float64u[A/16[%eax]] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  f1/8[%eax] := "camlCode__2"
                  ["camlCode"] := f1/8[%eax]
                  f2/9[%eax] := "camlCode__1"
                  ["camlCode" + 4] := f2/9[%eax]
                  A/10[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  f1/8[%eax] := "camlCode__2"
  ["camlCode"] := f1/8[%eax]
  f2/9[%eax] := "camlCode__1"
  ["camlCode" + 4] := f2/9[%eax]
  A/10[%eax] := 1
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
	.long	camlCode__f2_1037
	.long	3
	.data
	.long	2295
camlCode__2:
	.long	camlCode__f1_1030
	.long	3
	.text
	.align	16
	.globl	camlCode__f1_1030
camlCode__f1_1030:
.L102:
	movl	$1, %ebx
	cmpl	$21, %ebx
	jg	.L100
.L101:
	addl	$2, %eax
	movl	%ebx, %ecx
	addl	$2, %ebx
	cmpl	$21, %ecx
	jne	.L101
.L100:
	ret
	.type	camlCode__f1_1030,@function
	.size	camlCode__f1_1030,.-camlCode__f1_1030
	.text
	.align	16
	.globl	camlCode__f2_1037
camlCode__f2_1037:
	subl	$8, %esp
.L105:
	movl	%eax, %ebx
.L106:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L107
	leal	4(%eax), %ecx
	movl	$2302, -4(%ecx)
	fldl	(%ebx)
	fstpl	(%ecx)
	movl	$1, %eax
	cmpl	$21, %eax
	jg	.L103
.L104:
	fld1
	faddl	(%ecx)
	fstpl	(%ecx)
	movl	%eax, %ebx
	addl	$2, %eax
	cmpl	$21, %ebx
	jne	.L104
.L103:
.L109:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L110
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	(%ecx)
	fstpl	(%eax)
	addl	$8, %esp
	ret
.L110:	call	caml_call_gc
.L111:	jmp	.L109
.L107:	call	caml_call_gc
.L108:	jmp	.L106
	.type	camlCode__f2_1037,@function
	.size	camlCode__f2_1037,.-camlCode__f2_1037
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L112:
	movl	$camlCode__2, %eax
	movl	%eax, camlCode
	movl	$camlCode__1, %eax
	movl	%eax, camlCode + 4
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
	.long	.L111
	.word	12
	.word	1
	.word	5
	.align	4
	.long	.L108
	.word	12
	.word	1
	.word	3
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

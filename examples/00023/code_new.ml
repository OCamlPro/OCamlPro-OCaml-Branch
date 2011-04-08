(* The 3 functions here all take only one argument, a pair. But the
closures are compiled differently: in the first case, it is
untuplified to a function with arity 2 (-2 in the closure text), while
in the other cases, the functions keep an arity of 1.

Note that this means that "fst" and "snd" will often not be inlined
when they should have been for efficiency.
*)

let f1 (a,b) = a+b
let f2 ((a,b) as c) = (a,b,c)
let f3 c =
  let (a,b) = c in
    (a,b,c)
(*
-drawlambda
(seq
  (let
    (f1/1030
       (function (param/1044, param/1045)
         (let (b/1032 param/1045 a/1031 param/1044) (+ a/1031 b/1032))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1033
       (function c/1036
         (let (b/1035 (field 1 c/1036) a/1034 (field 0 c/1036))
           (makeblock 0 a/1034 b/1035 c/1036))))
    (setfield_imm 1 (global Code!) f2/1033))
  (let
    (f3/1037
       (function c/1038
         (let (b/1040 (field 1 c/1038) a/1039 (field 0 c/1038))
           (makeblock 0 a/1039 b/1040 c/1038))))
    (setfield_imm 2 (global Code!) f3/1037))
  0a)
-dlambda
(seq
  (let
    (f1/1030 (function (param/1044, param/1045) (+ param/1044 param/1045)))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1033
       (function c/1036
         (makeblock 0 (field 0 c/1036) (field 1 c/1036) c/1036)))
    (setfield_imm 1 (global Code!) f2/1033))
  (let
    (f3/1037
       (function c/1038
         (makeblock 0 (field 0 c/1038) (field 1 c/1038) c/1038)))
    (setfield_imm 2 (global Code!) f3/1037))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (f1/1030 (function (param/1044, param/1045) (+ param/1044 param/1045)))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1033
       (function c/1036
         (makeblock 0 (field 0 c/1036) (field 1 c/1036) c/1036)))
    (setfield_imm 1 (global Code!) f2/1033))
  (let
    (f3/1037
       (function c/1038
         (makeblock 0 (field 0 c/1038) (field 1 c/1038) c/1038)))
    (setfield_imm 2 (global Code!) f3/1037))
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let
    (f1/1030
       (closure (camlCode__f1_1030(-2)  param/1044 param/1045
                  (+ param/1044 param/1045)) {3} ))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let
    (f2/1033
       (closure (camlCode__f2_1033(1)  c/1036
                  (makeblock 0 (field 0 c/1036) (field 1 c/1036) c/1036)) 
         {2} ))
    (setfield_imm 1 (global camlCode!) f2/1033))
  (let
    (f3/1037
       (closure (camlCode__f3_1037(1)  c/1038
                  (makeblock 0 (field 0 c/1038) (field 1 c/1038) c/1038)) 
         {2} ))
    (setfield_imm 2 (global camlCode!) f3/1037))
  0a)
*** After TonClosure.optimize:
(let
  (f1/1030
     (closure (camlCode__f1_1030(-2)  param/1044 param/1045
                (+ param/1044 param/1045)) {3} ))
  (seq (setfield_imm 0 (global camlCode!) f1/1030)
    (let
      (f2/1033
         (closure (camlCode__f2_1033(1)  c/1036
                    (makeblock 0 (field 0 c/1036) (field 1 c/1036) c/1036)) 
           {2} ))
      (seq (setfield_imm 1 (global camlCode!) f2/1033)
        (let
          (f3/1037
             (closure (camlCode__f3_1037(1)  c/1038
                        (makeblock 0 (field 0 c/1038) (field 1 c/1038)
                          c/1038)) {2} ))
          (seq (setfield_imm 2 (global camlCode!) f3/1037) 0a))))))

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 12)
(data int 2295 "camlCode__1": addr "camlCode__f3_1037" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f2_1033" int 3)
(data
 int 3319
 "camlCode__3":
 addr "caml_tuplify2"
 int -3
 addr "camlCode__f1_1030")
(function camlCode__f1_1030 (param/1044: addr param/1045: addr)
 (+ (+ param/1044 param/1045) -1))

(function camlCode__f2_1033 (c/1036: addr)
 (alloc 3072 (load c/1036) (load (+a c/1036 4)) c/1036))

(function camlCode__f3_1037 (c/1038: addr)
 (alloc 3072 (load c/1038) (load (+a c/1038 4)) c/1038))

(function camlCode__entry ()
 (let f1/1030 "camlCode__3" (store "camlCode" f1/1030)
   (let f2/1033 "camlCode__2" (store (+a "camlCode" 4) f2/1033)
     (let f3/1037 "camlCode__1" (store (+a "camlCode" 8) f3/1037) 1a))))

(data)
-dlinear
Before simplify
camlCode__f1_1030:
                  I/10[%eax] := param/8[%eax] + param/9[%ebx] + -1
                  return R/0[%eax]
                  *** Linearized code
camlCode__f1_1030:
  I/10[%eax] := param/8[%eax] + param/9[%ebx] + -1
  return R/0[%eax]
  
Before simplify
camlCode__f2_1033:
                  c/8[%ecx] := R/0[%eax]
                  {c/8[%ecx]*}
                  A/9[%eax] := alloc 16
                  [A/9[%eax] + -4] := 3072
                  A/10[%ebx] := [c/8[%ecx]]
                  [A/9[%eax]] := A/10[%ebx]
                  A/11[%ebx] := [c/8[%ecx] + 4]
                  [A/9[%eax] + 4] := A/11[%ebx]
                  [A/9[%eax] + 8] := c/8[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f2_1033:
  c/8[%ecx] := R/0[%eax]
  {c/8[%ecx]*}
  A/9[%eax] := alloc 16
  [A/9[%eax] + -4] := 3072
  A/10[%ebx] := [c/8[%ecx]]
  [A/9[%eax]] := A/10[%ebx]
  A/11[%ebx] := [c/8[%ecx] + 4]
  [A/9[%eax] + 4] := A/11[%ebx]
  [A/9[%eax] + 8] := c/8[%ecx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__f3_1037:
                  c/8[%ecx] := R/0[%eax]
                  {c/8[%ecx]*}
                  A/9[%eax] := alloc 16
                  [A/9[%eax] + -4] := 3072
                  A/10[%ebx] := [c/8[%ecx]]
                  [A/9[%eax]] := A/10[%ebx]
                  A/11[%ebx] := [c/8[%ecx] + 4]
                  [A/9[%eax] + 4] := A/11[%ebx]
                  [A/9[%eax] + 8] := c/8[%ecx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f3_1037:
  c/8[%ecx] := R/0[%eax]
  {c/8[%ecx]*}
  A/9[%eax] := alloc 16
  [A/9[%eax] + -4] := 3072
  A/10[%ebx] := [c/8[%ecx]]
  [A/9[%eax]] := A/10[%ebx]
  A/11[%ebx] := [c/8[%ecx] + 4]
  [A/9[%eax] + 4] := A/11[%ebx]
  [A/9[%eax] + 8] := c/8[%ecx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  f1/8[%eax] := "camlCode__3"
                  ["camlCode"] := f1/8[%eax]
                  f2/9[%eax] := "camlCode__2"
                  ["camlCode" + 4] := f2/9[%eax]
                  f3/10[%eax] := "camlCode__1"
                  ["camlCode" + 8] := f3/10[%eax]
                  A/11[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  f1/8[%eax] := "camlCode__3"
  ["camlCode"] := f1/8[%eax]
  f2/9[%eax] := "camlCode__2"
  ["camlCode" + 4] := f2/9[%eax]
  f3/10[%eax] := "camlCode__1"
  ["camlCode" + 8] := f3/10[%eax]
  A/11[%eax] := 1
  return R/0[%eax]
  
-S
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.long	3072
	.globl	camlCode
camlCode:
	.space	12
	.data
	.long	2295
camlCode__1:
	.long	camlCode__f3_1037
	.long	3
	.data
	.long	2295
camlCode__2:
	.long	camlCode__f2_1033
	.long	3
	.data
	.long	3319
camlCode__3:
	.long	caml_tuplify2
	.long	-3
	.long	camlCode__f1_1030
	.text
	.align	16
	.globl	camlCode__f1_1030
camlCode__f1_1030:
.L100:
	lea	-1(%eax, %ebx), %eax
	ret
	.type	camlCode__f1_1030,@function
	.size	camlCode__f1_1030,.-camlCode__f1_1030
	.text
	.align	16
	.globl	camlCode__f2_1033
camlCode__f2_1033:
.L101:
	movl	%eax, %ecx
.L102:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L103
	leal	4(%eax), %eax
	movl	$3072, -4(%eax)
	movl	(%ecx), %ebx
	movl	%ebx, (%eax)
	movl	4(%ecx), %ebx
	movl	%ebx, 4(%eax)
	movl	%ecx, 8(%eax)
	ret
.L103:	call	caml_call_gc
.L104:	jmp	.L102
	.type	camlCode__f2_1033,@function
	.size	camlCode__f2_1033,.-camlCode__f2_1033
	.text
	.align	16
	.globl	camlCode__f3_1037
camlCode__f3_1037:
.L105:
	movl	%eax, %ecx
.L106:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L107
	leal	4(%eax), %eax
	movl	$3072, -4(%eax)
	movl	(%ecx), %ebx
	movl	%ebx, (%eax)
	movl	4(%ecx), %ebx
	movl	%ebx, 4(%eax)
	movl	%ecx, 8(%eax)
	ret
.L107:	call	caml_call_gc
.L108:	jmp	.L106
	.type	camlCode__f3_1037,@function
	.size	camlCode__f3_1037,.-camlCode__f3_1037
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L109:
	movl	$camlCode__3, %eax
	movl	%eax, camlCode
	movl	$camlCode__2, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__1, %eax
	movl	%eax, camlCode + 8
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
	.long	.L108
	.word	4
	.word	1
	.word	5
	.align	4
	.long	.L104
	.word	4
	.word	1
	.word	5
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

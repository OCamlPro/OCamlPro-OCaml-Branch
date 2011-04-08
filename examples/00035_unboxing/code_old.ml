type point = {x:float; y:float}
 
let fmin (x:float) y = if x > y then y else x
let fmax (x:float) y = if y > x then y else x
 
let min_point {x=x1;y=y1} {x=x2;y=y2} =
  let x = fmin x1 x2 in  
  let y = fmin y1 y2 in
  {x=x; y=y}

(*


As a general rule, I would say the compiler does not do a great load of optimization to unbox floats. The only case that gets optimized is "unbox (box v) -> v", i.e. in CMMnotation "load float64u (alloc 2301 x/123)  ->  x/123"

The first patch that I proposed (see there) got integrated into the compiler and will unbox floats across a let, i.e. "load float64u (let (x/123 (alloc 2301 y/234)))   ->   let (x/123 y/234)".

The second patch I proposed was not integrated. In your example, it would have moved the allocs from the lets into the branches of the if, allocating only one value instead of two. That is not enough to unbox completely though. In order to do that, the compiler would have to notice that both branches of the if are allocs and factorize them (x/74 and y/75 would now be allocs). Then, as another pass, it would have to notice that x/74 and y/75 always get unboxed and hence could be simplified. In short, three different kinds of mechanical transforms are needed in order to fully optimize your code...
*)

(*
-drawlambda
(seq
  (let
    (fmin/1035 (function x/1036 y/1037 (if (>. x/1036 y/1037) y/1037 x/1036)))
    (setfield_imm 0 (global Code!) fmin/1035))
  (let
    (fmax/1038 (function x/1039 y/1040 (if (>. y/1040 x/1039) y/1040 x/1039)))
    (setfield_imm 1 (global Code!) fmax/1038))
  (let
    (min_point/1041
       (function param/1054 param/1055
         (let
           (y2/1045 (floatfield 1 param/1055)
            x2/1044 (floatfield 0 param/1055)
            y1/1043 (floatfield 1 param/1054)
            x1/1042 (floatfield 0 param/1054)
            x/1046 (apply (field 0 (global Code!)) x1/1042 x2/1044)
            y/1047 (apply (field 0 (global Code!)) y1/1043 y2/1045))
           (makearray  x/1046 y/1047))))
    (setfield_imm 2 (global Code!) min_point/1041))
  0a)
-dlambda
(seq
  (let
    (fmin/1035 (function x/1036 y/1037 (if (>. x/1036 y/1037) y/1037 x/1036)))
    (setfield_imm 0 (global Code!) fmin/1035))
  (let
    (fmax/1038 (function x/1039 y/1040 (if (>. y/1040 x/1039) y/1040 x/1039)))
    (setfield_imm 1 (global Code!) fmax/1038))
  (let
    (min_point/1041
       (function param/1054 param/1055
         (let
           (x/1046
              (apply (field 0 (global Code!)) (floatfield 0 param/1054)
                (floatfield 0 param/1055))
            y/1047
              (apply (field 0 (global Code!)) (floatfield 1 param/1054)
                (floatfield 1 param/1055)))
           (makearray  x/1046 y/1047))))
    (setfield_imm 2 (global Code!) min_point/1041))
  0a)

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 12)
(data
 int 3319
 "camlCode__1":
 addr "caml_curry2"
 int 5
 addr "camlCode__min_point_1041")
(data
 int 3319
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__fmax_1038")
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__fmin_1035")
(function camlCode__fmin_1035 (x/1036: addr y/1037: addr)
 (if (>f (load float64u x/1036) (load float64u y/1037)) y/1037 x/1036))

(function camlCode__fmax_1038 (x/1039: addr y/1040: addr)
 (if (>f (load float64u y/1040) (load float64u x/1039)) y/1040 x/1039))

(function camlCode__min_point_1041 (param/1054: addr param/1055: addr)
 (let
   (x/1046
      (let
        (y/1066 (load float64u param/1055) y/1060 (alloc 2301 y/1066)
         x/1067 (load float64u param/1054) x/1061 (alloc 2301 x/1067))
        (if (>f x/1067 y/1066) y/1060 x/1061))
    y/1047
      (let
        (y/1064 (load float64u (+a param/1055 8)) y/1062 (alloc 2301 y/1064)
         x/1065 (load float64u (+a param/1054 8)) x/1063 (alloc 2301 x/1065))
        (if (>f x/1065 y/1064) y/1062 x/1063)))
   (alloc 4350 (load float64u x/1046) (load float64u y/1047))))

(function camlCode__entry ()
 (let fmin/1035 "camlCode__3" (store "camlCode" fmin/1035))
 (let fmax/1038 "camlCode__2" (store (+a "camlCode" 4) fmax/1038))
 (let min_point/1041 "camlCode__1" (store (+a "camlCode" 8) min_point/1041))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__fmin_1035:
  x/8[%ecx] := R/0[%eax]
  R/7[%tos] := float64u[y/9[%ebx]]
  R/7[%tos] := float64u[x/8[%ecx]]
  if not R/7[%tos] >f R/7[%tos] goto L100
  R/0[%eax] := y/9[%ebx]
  return R/0[%eax]
  L100:
  R/0[%eax] := x/8[%ecx]
  return R/0[%eax]
  
*** Linearized code
camlCode__fmax_1038:
  x/8[%ecx] := R/0[%eax]
  R/7[%tos] := float64u[x/8[%ecx]]
  R/7[%tos] := float64u[y/9[%ebx]]
  if not R/7[%tos] >f R/7[%tos] goto L102
  R/0[%eax] := y/9[%ebx]
  return R/0[%eax]
  L102:
  R/0[%eax] := x/8[%ecx]
  return R/0[%eax]
  
*** Linearized code
camlCode__min_point_1041:
  param/8[%ecx] := R/0[%eax]
  R/7[%tos] := float64u[param/9[%ebx]]
  y/11[s1] := R/7[%tos]
  {param/8[%ecx]* param/9[%ebx]* y/11[s1]}
  y/12[%esi] := alloc 24
  [y/12[%esi] + -4] := 2301
  float64u[y/12[%esi]] := y/11[s1]
  R/7[%tos] := float64u[param/8[%ecx]]
  x/14[s0] := R/7[%tos]
  x/15[%edx] := y/12[%esi] + 12
  [x/15[%edx] + -4] := 2301
  float64u[x/15[%edx]] := x/14[s0]
  if not x/14[s0] >f y/11[s1] goto L105
  x/16[%edx] := y/12[%esi]
  L105:
  R/7[%tos] := float64u[param/9[%ebx] + 8]
  y/18[s1] := R/7[%tos]
  {param/8[%ecx]* x/16[%edx]* y/18[s1]}
  y/19[%esi] := alloc 24
  [y/19[%esi] + -4] := 2301
  float64u[y/19[%esi]] := y/18[s1]
  R/7[%tos] := float64u[param/8[%ecx] + 8]
  x/21[s0] := R/7[%tos]
  x/22[%ebx] := y/19[%esi] + 12
  [x/22[%ebx] + -4] := 2301
  float64u[x/22[%ebx]] := x/21[s0]
  if not x/21[s0] >f y/18[s1] goto L104
  y/23[%ebx] := y/19[%esi]
  L104:
  {x/16[%edx]* y/23[%ebx]*}
  A/24[%eax] := alloc 20
  [A/24[%eax] + -4] := 4350
  R/7[%tos] := float64u[x/16[%edx]]
  float64u[A/24[%eax]] := R/7[%tos]
  R/7[%tos] := float64u[y/23[%ebx]]
  float64u[A/24[%eax] + 8] := R/7[%tos]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  fmin/8[%eax] := "camlCode__3"
  ["camlCode"] := fmin/8[%eax]
  fmax/9[%eax] := "camlCode__2"
  ["camlCode" + 4] := fmax/9[%eax]
  min_point/10[%eax] := "camlCode__1"
  ["camlCode" + 8] := min_point/10[%eax]
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
	.long	3319
camlCode__1:
	.long	caml_curry2
	.long	5
	.long	camlCode__min_point_1041
	.data
	.long	3319
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__fmax_1038
	.data
	.long	3319
camlCode__3:
	.long	caml_curry2
	.long	5
	.long	camlCode__fmin_1035
	.text
	.align	16
	.globl	camlCode__fmin_1035
camlCode__fmin_1035:
	subl	$8, %esp
.L101:
	movl	%eax, %ecx
	fldl	(%ebx)
	fldl	(%ecx)
	fcompp
	fnstsw	%ax
	andb	$69, %ah
	jne	.L100
	movl	%ebx, %eax
	addl	$8, %esp
	ret
	.align	16
.L100:
	movl	%ecx, %eax
	addl	$8, %esp
	ret
	.type	camlCode__fmin_1035,@function
	.size	camlCode__fmin_1035,.-camlCode__fmin_1035
	.text
	.align	16
	.globl	camlCode__fmax_1038
camlCode__fmax_1038:
	subl	$8, %esp
.L103:
	movl	%eax, %ecx
	fldl	(%ecx)
	fldl	(%ebx)
	fcompp
	fnstsw	%ax
	andb	$69, %ah
	jne	.L102
	movl	%ebx, %eax
	addl	$8, %esp
	ret
	.align	16
.L102:
	movl	%ecx, %eax
	addl	$8, %esp
	ret
	.type	camlCode__fmax_1038,@function
	.size	camlCode__fmax_1038,.-camlCode__fmax_1038
	.text
	.align	16
	.globl	camlCode__min_point_1041
camlCode__min_point_1041:
	subl	$16, %esp
.L106:
	movl	%eax, %ecx
	fldl	(%ebx)
	fstpl	8(%esp)
.L107:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L108
	leal	4(%eax), %esi
	movl	$2301, -4(%esi)
	fldl	8(%esp)
	fstpl	(%esi)
	fldl	(%ecx)
	fstpl	0(%esp)
	leal	12(%esi), %edx
	movl	$2301, -4(%edx)
	fldl	0(%esp)
	fstpl	(%edx)
	fldl	0(%esp)
	fcompl	8(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L105
	movl	%esi, %edx
.L105:
	fldl	8(%ebx)
	fstpl	8(%esp)
.L110:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L111
	leal	4(%eax), %esi
	movl	$2301, -4(%esi)
	fldl	8(%esp)
	fstpl	(%esi)
	fldl	8(%ecx)
	fstpl	0(%esp)
	leal	12(%esi), %ebx
	movl	$2301, -4(%ebx)
	fldl	0(%esp)
	fstpl	(%ebx)
	fldl	0(%esp)
	fcompl	8(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L104
	movl	%esi, %ebx
.L104:
.L113:	movl	caml_young_ptr, %eax
	subl	$20, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L114
	leal	4(%eax), %eax
	movl	$4350, -4(%eax)
	fldl	(%edx)
	fstpl	(%eax)
	fldl	(%ebx)
	fstpl	8(%eax)
	addl	$16, %esp
	ret
.L114:	call	caml_call_gc
.L115:	jmp	.L113
.L111:	call	caml_call_gc
.L112:	jmp	.L110
.L108:	call	caml_call_gc
.L109:	jmp	.L107
	.type	camlCode__min_point_1041,@function
	.size	camlCode__min_point_1041,.-camlCode__min_point_1041
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L116:
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
	.long	3
	.long	.L115
	.word	20
	.word	2
	.word	3
	.word	7
	.align	4
	.long	.L112
	.word	20
	.word	2
	.word	7
	.word	5
	.align	4
	.long	.L109
	.word	20
	.word	2
	.word	3
	.word	5
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

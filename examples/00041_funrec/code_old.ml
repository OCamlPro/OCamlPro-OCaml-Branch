

let f list =
  let n = ref 0 in
  let rec iter l =
    match l with
	[] -> !n
      | x :: tail -> n := !n + x; iter tail
  in
    iter list


let g list =
  let rec iterf sum l =
     match l with
      [] -> sum > 0.
    | x :: tail -> 
        iterf (sum +. x) tail
  in
  iterf 0. list
(*
-drawlambda
(seq
  (let
    (f/1030
       (function list/1031
         (let (n/1032 (makemutable 0 0))
           (letrec
             (iter/1033
                (function l/1034
                  (if l/1034
                    (let (tail/1036 (field 1 l/1034) x/1035 (field 0 l/1034))
                      (seq
                        (setfield_imm 0 n/1032 (+ (field 0 n/1032) x/1035))
                        (apply iter/1033 tail/1036)))
                    (field 0 n/1032))))
             (apply iter/1033 list/1031)))))
    (setfield_imm 0 (global Code!) f/1030))
  (let
    (g/1037
       (function list/1038
         (letrec
           (iterf/1039
              (function sum/1040 l/1041
                (if l/1041
                  (let (tail/1043 (field 1 l/1041) x/1042 (field 0 l/1041))
                    (apply iterf/1039 (+. sum/1040 x/1042) tail/1043))
                  (>. sum/1040 0.))))
           (apply iterf/1039 0. list/1038))))
    (setfield_imm 1 (global Code!) g/1037))
  0a)
-dlambda
(seq
  (let
    (f/1030
       (function list/1031
         (let (n/1032 (makemutable 0 0))
           (letrec
             (iter/1033
                (function l/1034
                  (if l/1034
                    (seq
                      (setfield_imm 0 n/1032
                        (+ (field 0 n/1032) (field 0 l/1034)))
                      (apply iter/1033 (field 1 l/1034)))
                    (field 0 n/1032))))
             (apply iter/1033 list/1031)))))
    (setfield_imm 0 (global Code!) f/1030))
  (let
    (g/1037
       (function list/1038
         (letrec
           (iterf/1039
              (function sum/1040 l/1041
                (if l/1041
                  (apply iterf/1039 (+. sum/1040 (field 0 l/1041))
                    (field 1 l/1041))
                  (>. sum/1040 0.))))
           (apply iterf/1039 0. list/1038))))
    (setfield_imm 1 (global Code!) g/1037))
  0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__g_1037" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f_1030" int 3)
(data
 int 3319
 "camlCode__4":
 addr "caml_curry2"
 int 5
 addr "camlCode__iterf_1039")
(data int 2301 "camlCode__3": double 0.)
(function camlCode__iter_1033 (l/1034: addr env/1048: addr)
 (if (!= l/1034 1)
   (seq
     (store (load (+a env/1048 8))
       (+ (+ (load (load (+a env/1048 8))) (load l/1034)) -1))
     (app "camlCode__iter_1033" (load (+a l/1034 4)) env/1048 addr))
   (load (load (+a env/1048 8)))))

(function camlCode__iterf_1039 (sum/1040: addr l/1041: addr)
 (if (!= l/1041 1)
   (app "camlCode__iterf_1039"
     (alloc 2301 (+f (load float64u sum/1040) (load float64u (load l/1041))))
     (load (+a l/1041 4)) addr)
   (+ (<< (>f (load float64u sum/1040) 0.) 1) 1)))

(function camlCode__f_1030 (list/1031: addr)
 (let
   (n/1032 (alloc 1024 1)
    clos/1049 (alloc 3319 "camlCode__iter_1033" 3 n/1032))
   (app "camlCode__iter_1033" list/1031 clos/1049 addr)))

(function camlCode__g_1037 (list/1038: addr)
 (let clos/1052 "camlCode__4"
   (app "camlCode__iterf_1039" "camlCode__3" list/1038 addr)))

(function camlCode__entry ()
 (let f/1030 "camlCode__2" (store "camlCode" f/1030))
 (let g/1037 "camlCode__1" (store (+a "camlCode" 4) g/1037)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__iter_1033:
  if l/8[%eax] ==s 1 goto L100
  A/12[%esi] := [env/9[%ebx] + 8]
  A/13[%edx] := [l/8[%eax]]
  A/14[%ecx] := [env/9[%ebx] + 8]
  A/15[%ecx] := [A/14[%ecx]]
  I/16[%ecx] := A/15[%ecx] + A/13[%edx] + -1
  [A/12[%esi]] := I/16[%ecx]
  A/17[%eax] := [l/8[%eax] + 4]
  tailcall "camlCode__iter_1033" R/0[%eax] R/1[%ebx]
  L100:
  A/10[%eax] := [env/9[%ebx] + 8]
  A/11[%eax] := [A/10[%eax]]
  return R/0[%eax]
  
*** Linearized code
camlCode__iterf_1039:
  sum/8[%edx] := R/0[%eax]
  if l/9[%ebx] ==s 1 goto L104
  {sum/8[%edx]* l/9[%ebx]*}
  A/15[%eax] := alloc 12
  [A/15[%eax] + -4] := 2301
  A/16[%ecx] := [l/9[%ebx]]
  R/7[%tos] := float64u[sum/8[%edx]]
  R/7[%tos] := R/7[%tos] +f float64[A/16[%ecx]]
  float64u[A/15[%eax]] := R/7[%tos]
  A/19[%ebx] := [l/9[%ebx] + 4]
  tailcall "camlCode__iterf_1039" R/0[%eax] R/1[%ebx]
  L104:
  R/7[%tos] := 0.
  R/7[%tos] := float64u[sum/8[%edx]]
  if not R/7[%tos] >f R/7[%tos] goto L103
  I/12[%eax] := 1
  goto L102
  L103:
  I/13[%eax] := 0
  L102:
  I/14[%eax] := I/12[%eax]  * 2 + 1
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__f_1030:
  list/8[%ecx] := R/0[%eax]
  {list/8[%ecx]*}
  n/9[%eax] := alloc 24
  [n/9[%eax] + -4] := 1024
  [n/9[%eax]] := 1
  clos/10[%ebx] := n/9[%eax] + 8
  [clos/10[%ebx] + -4] := 3319
  [clos/10[%ebx]] := "camlCode__iter_1033"
  [clos/10[%ebx] + 4] := 3
  [clos/10[%ebx] + 8] := n/9[%eax]
  R/0[%eax] := list/8[%ecx]
  tailcall "camlCode__iter_1033" R/0[%eax] R/1[%ebx]
  
*** Linearized code
camlCode__g_1037:
  list/8[%ebx] := R/0[%eax]
  clos/9[%eax] := "camlCode__4"
  A/10[%eax] := "camlCode__3"
  tailcall "camlCode__iterf_1039" R/0[%eax] R/1[%ebx]
  
*** Linearized code
camlCode__entry:
  f/8[%eax] := "camlCode__2"
  ["camlCode"] := f/8[%eax]
  g/9[%eax] := "camlCode__1"
  ["camlCode" + 4] := g/9[%eax]
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
	.long	camlCode__g_1037
	.long	3
	.data
	.long	2295
camlCode__2:
	.long	camlCode__f_1030
	.long	3
	.data
	.long	3319
camlCode__4:
	.long	caml_curry2
	.long	5
	.long	camlCode__iterf_1039
	.data
	.long	2301
camlCode__3:
	.long	0x0, 0x0
	.text
	.align	16
	.globl	camlCode__iter_1033
camlCode__iter_1033:
.L101:
	cmpl	$1, %eax
	je	.L100
	movl	8(%ebx), %esi
	movl	(%eax), %edx
	movl	8(%ebx), %ecx
	movl	(%ecx), %ecx
	lea	-1(%ecx, %edx), %ecx
	movl	%ecx, (%esi)
	movl	4(%eax), %eax
	jmp	.L101
	.align	16
.L100:
	movl	8(%ebx), %eax
	movl	(%eax), %eax
	ret
	.type	camlCode__iter_1033,@function
	.size	camlCode__iter_1033,.-camlCode__iter_1033
	.text
	.align	16
	.globl	camlCode__iterf_1039
camlCode__iterf_1039:
	subl	$8, %esp
.L105:
	movl	%eax, %edx
	cmpl	$1, %ebx
	je	.L104
.L106:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L107
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	movl	(%ebx), %ecx
	fldl	(%edx)
	faddl	(%ecx)
	fstpl	(%eax)
	movl	4(%ebx), %ebx
	jmp	.L105
	.align	16
.L104:
	fldz
	fldl	(%edx)
	fcompp
	fnstsw	%ax
	andb	$69, %ah
	jne	.L103
	movl	$1, %eax
	jmp	.L102
	.align	16
.L103:
	xorl	%eax, %eax
.L102:
	lea	1(%eax, %eax), %eax
	addl	$8, %esp
	ret
.L107:	call	caml_call_gc
.L108:	jmp	.L106
	.type	camlCode__iterf_1039,@function
	.size	camlCode__iterf_1039,.-camlCode__iterf_1039
	.text
	.align	16
	.globl	camlCode__f_1030
camlCode__f_1030:
.L109:
	movl	%eax, %ecx
.L110:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L111
	leal	4(%eax), %eax
	movl	$1024, -4(%eax)
	movl	$1, (%eax)
	leal	8(%eax), %ebx
	movl	$3319, -4(%ebx)
	movl	$camlCode__iter_1033, (%ebx)
	movl	$3, 4(%ebx)
	movl	%eax, 8(%ebx)
	movl	%ecx, %eax
	jmp	camlCode__iter_1033
.L111:	call	caml_call_gc
.L112:	jmp	.L110
	.type	camlCode__f_1030,@function
	.size	camlCode__f_1030,.-camlCode__f_1030
	.text
	.align	16
	.globl	camlCode__g_1037
camlCode__g_1037:
.L113:
	movl	%eax, %ebx
	movl	$camlCode__4, %eax
	movl	$camlCode__3, %eax
	jmp	camlCode__iterf_1039
	.type	camlCode__g_1037,@function
	.size	camlCode__g_1037,.-camlCode__g_1037
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L114:
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
	.long	.L112
	.word	4
	.word	1
	.word	5
	.align	4
	.long	.L108
	.word	12
	.word	2
	.word	3
	.word	7
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

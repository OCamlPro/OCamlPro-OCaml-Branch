

let sum_i list =
  let n = ref 0 in
  let rec iter l =
    match l with
	[] -> !n
      | x :: tail -> n := !n + x; iter tail
  in
    iter list


let sum_f list =
  let rec iterf sum l =
     match l with
      [] -> sum > 0.
    | x :: tail ->
        iterf (sum +. x) tail
  in
  iterf 0. list

let _ =
  let t = Array.init 10_000_000 (fun i -> float i) in
  let l = Array.to_list t in
  ignore (sum_f l)
(*
-drawlambda
(seq
  (let
    (sum_i/1030
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
    (setfield_imm 0 (global Code!) sum_i/1030))
  (let
    (sum_f/1037
       (function list/1038
         (letrec
           (iterf/1039
              (function sum/1040 l/1041
                (if l/1041
                  (let (tail/1043 (field 1 l/1041) x/1042 (field 0 l/1041))
                    (apply iterf/1039 (+. sum/1040 x/1042) tail/1043))
                  (>. sum/1040 0.))))
           (apply iterf/1039 0. list/1038))))
    (setfield_imm 1 (global Code!) sum_f/1037))
  (let
    (t/1044
       (apply (field 0 (global Array!)) 10000000
         (function i/1045 (float_of_int i/1045)))
     l/1046 (apply (field 9 (global Array!)) t/1044))
    (ignore (apply (field 1 (global Code!)) l/1046)))
  0a)
-dlambda
(seq
  (let
    (sum_i/1030
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
    (setfield_imm 0 (global Code!) sum_i/1030))
  (let
    (sum_f/1037
       (function list/1038
         (letrec
           (iterf/1039
              (function sum/1040 l/1041
                (if l/1041
                  (apply iterf/1039 (+. sum/1040 (field 0 l/1041))
                    (field 1 l/1041))
                  (>. sum/1040 0.))))
           (apply iterf/1039 0. list/1038))))
    (setfield_imm 1 (global Code!) sum_f/1037))
  (let
    (t/1044
       (apply (field 0 (global Array!)) 10000000
         (function i/1045 (float_of_int i/1045)))
     l/1046 (apply (field 9 (global Array!)) t/1044))
    (ignore (apply (field 1 (global Code!)) l/1046)))
  0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__3": addr "camlCode__fun_1056" int 3)
(data int 2295 "camlCode__4": addr "camlCode__sum_f_1037" int 3)
(data int 2295 "camlCode__5": addr "camlCode__sum_i_1030" int 3)
(data
 int 3319
 "camlCode__6":
 addr "caml_curry2"
 int 5
 addr "camlCode__iterf_1039")
(data global "camlCode__1" int 1277 "camlCode__1": double 0.)
(data global "camlCode__2" int 1277 "camlCode__2": double 0.)
(function camlCode__iter_1033 (l/1034: addr env/1051: addr)
 (if (!= l/1034 1)
   (seq
     (store (load (+a env/1051 16))
       (+ (+ (load (load (+a env/1051 16))) (load l/1034)) -1))
     (app "camlCode__iter_1033" (load (+a l/1034 8)) env/1051 addr))
   (load (load (+a env/1051 16)))))

(function camlCode__iterf_1039 (sum/1040: addr l/1041: addr)
 (if (!= l/1041 1)
   (app "camlCode__iterf_1039"
     (alloc 1277 (+f (load float64u sum/1040) (load float64u (load l/1041))))
     (load (+a l/1041 8)) addr)
   (+ (<< (>f (load float64u sum/1040) 0.) 1) 1)))

(function camlCode__sum_i_1030 (list/1031: addr)
 (let
   (n/1032 (alloc 1024 1)
    clos/1052 (alloc 3319 "camlCode__iter_1033" 3 n/1032))
   (app "camlCode__iter_1033" list/1031 clos/1052 addr)))

(function camlCode__sum_f_1037 (list/1038: addr)
 (let clos/1055 "camlCode__6"
   (app "camlCode__iterf_1039" "camlCode__2" list/1038 addr)))

(function camlCode__fun_1056 (i/1045: addr)
 (alloc 1277 (floatofint (>>s i/1045 1))))

(function camlCode__entry ()
 (let sum_i/1030 "camlCode__5" (store "camlCode" sum_i/1030))
 (let sum_f/1037 "camlCode__4" (store (+a "camlCode" 8) sum_f/1037))
 (let
   (t/1044 (app "camlArray__init_1037" 20000001 "camlCode__3" addr)
    l/1046 (app "camlArray__to_list_1121" t/1044 addr))
   (app "camlCode__sum_f_1037" l/1046 unit))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__iter_1033:
  if l/29[%rax] ==s 1 goto L100
  A/33[%rdx] := [env/30[%rbx] + 16]
  A/34[%rsi] := [l/29[%rax]]
  A/35[%rdi] := [env/30[%rbx] + 16]
  A/36[%rdi] := [A/35[%rdi]]
  I/37[%rdi] := A/36[%rdi] + A/34[%rsi] + -1
  [A/33[%rdx]] := I/37[%rdi]
  A/38[%rax] := [l/29[%rax] + 8]
  tailcall "camlCode__iter_1033" R/0[%rax] R/1[%rbx]
  L100:
  A/31[%rax] := [env/30[%rbx] + 16]
  A/32[%rax] := [A/31[%rax]]
  return R/0[%rax]
  
*** Linearized code
camlCode__iterf_1039:
  sum/29[%rsi] := R/0[%rax]
  if l/30[%rbx] ==s 1 goto L104
  {sum/29[%rsi]* l/30[%rbx]*}
  A/36[%rax] := alloc 16
  [A/36[%rax] + -8] := 1277
  A/37[%rdi] := [l/30[%rbx]]
  F/38[%xmm0] := float64u[sum/29[%rsi]]
  F/39[%xmm0] := F/39[%xmm0] +f float64[A/37[%rdi]]
  float64u[A/36[%rax]] := F/39[%xmm0]
  A/40[%rbx] := [l/30[%rbx] + 8]
  tailcall "camlCode__iterf_1039" R/0[%rax] R/1[%rbx]
  L104:
  F/31[%xmm1] := 0.
  F/32[%xmm0] := float64u[sum/29[%rsi]]
  if not F/32[%xmm0] >f F/31[%xmm1] goto L103
  I/33[%rax] := 1
  goto L102
  L103:
  I/34[%rax] := 0
  L102:
  I/35[%rax] := I/33[%rax]  * 2 + 1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__sum_i_1030:
  list/29[%rsi] := R/0[%rax]
  {list/29[%rsi]*}
  n/30[%rdi] := alloc 48
  [n/30[%rdi] + -8] := 1024
  [n/30[%rdi]] := 1
  clos/31[%rbx] := n/30[%rdi] + 16
  [clos/31[%rbx] + -8] := 3319
  A/32[%rax] := "camlCode__iter_1033"
  [clos/31[%rbx]] := A/32[%rax]
  [clos/31[%rbx] + 8] := 3
  [clos/31[%rbx] + 16] := n/30[%rdi]
  R/0[%rax] := list/29[%rsi]
  tailcall "camlCode__iter_1033" R/0[%rax] R/1[%rbx]
  
*** Linearized code
camlCode__sum_f_1037:
  list/29[%rbx] := R/0[%rax]
  clos/30[%rax] := "camlCode__6"
  A/31[%rax] := "camlCode__2"
  tailcall "camlCode__iterf_1039" R/0[%rax] R/1[%rbx]
  
*** Linearized code
camlCode__fun_1056:
  i/29[%rbx] := R/0[%rax]
  {i/29[%rbx]*}
  A/30[%rax] := alloc 16
  [A/30[%rax] + -8] := 1277
  I/31[%rbx] := I/31[%rbx] >>s 1
  F/32[%xmm0] := floatofint I/31[%rbx]
  float64u[A/30[%rax]] := F/32[%xmm0]
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  sum_i/29[%rbx] := "camlCode__5"
  A/30[%rax] := "camlCode"
  [A/30[%rax]] := sum_i/29[%rbx]
  sum_f/31[%rbx] := "camlCode__4"
  A/32[%rax] := "camlCode"
  [A/32[%rax] + 8] := sum_f/31[%rbx]
  A/33[%rbx] := "camlCode__3"
  I/34[%rax] := 20000001
  {}
  R/0[%rax] := call "camlArray__init_1037" R/0[%rax] R/1[%rbx]
  {}
  R/0[%rax] := call "camlArray__to_list_1121" R/0[%rax]
  {}
  call "camlCode__sum_f_1037" R/0[%rax]
  A/37[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
-S
	.section        .rodata.cst8,"a",@progbits
	.align	16
caml_negf_mask:	.quad   0x8000000000000000, 0
	.align	16
caml_absf_mask:	.quad   0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.quad	2048
	.globl	camlCode
camlCode:
	.space	16
	.data
	.quad	2295
camlCode__3:
	.quad	camlCode__fun_1056
	.quad	3
	.data
	.quad	2295
camlCode__4:
	.quad	camlCode__sum_f_1037
	.quad	3
	.data
	.quad	2295
camlCode__5:
	.quad	camlCode__sum_i_1030
	.quad	3
	.data
	.quad	3319
camlCode__6:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__iterf_1039
	.data
	.globl	camlCode__1
	.quad	1277
camlCode__1:
	.quad	0x0
	.data
	.globl	camlCode__2
	.quad	1277
camlCode__2:
	.quad	0x0
	.text
	.align	16
	.globl	camlCode__iter_1033
camlCode__iter_1033:
.L101:
	cmpq	$1, %rax
	je	.L100
	movq	16(%rbx), %rdx
	movq	(%rax), %rsi
	movq	16(%rbx), %rdi
	movq	(%rdi), %rdi
	leaq	-1(%rdi, %rsi), %rdi
	movq	%rdi, (%rdx)
	movq	8(%rax), %rax
	jmp	.L101
	.align	4
.L100:
	movq	16(%rbx), %rax
	movq	(%rax), %rax
	ret
	.type	camlCode__iter_1033,@function
	.size	camlCode__iter_1033,.-camlCode__iter_1033
	.text
	.align	16
	.globl	camlCode__iterf_1039
camlCode__iterf_1039:
	subq	$8, %rsp
.L105:
	movq	%rax, %rsi
	cmpq	$1, %rbx
	je	.L104
.L106:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L107
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	movq	(%rbx), %rdi
	movlpd	(%rsi), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rax)
	movq	8(%rbx), %rbx
	jmp	.L105
	.align	4
.L104:
	xorpd	%xmm1, %xmm1
	movlpd	(%rsi), %xmm0
 comisd	%xmm1, %xmm0
	jbe	.L103
	movq	$1, %rax
	jmp	.L102
	.align	4
.L103:
	xorq	%rax, %rax
.L102:
	leaq	1(%rax, %rax), %rax
	addq	$8, %rsp
	ret
.L107:	call	caml_call_gc@PLT
.L108:	jmp	.L106
	.type	camlCode__iterf_1039,@function
	.size	camlCode__iterf_1039,.-camlCode__iterf_1039
	.text
	.align	16
	.globl	camlCode__sum_i_1030
camlCode__sum_i_1030:
	subq	$8, %rsp
.L109:
	movq	%rax, %rsi
.L110:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L111
	leaq	8(%r15), %rdi
	movq	$1024, -8(%rdi)
	movq	$1, (%rdi)
	leaq	16(%rdi), %rbx
	movq	$3319, -8(%rbx)
	movq	camlCode__iter_1033@GOTPCREL(%rip), %rax
	movq	%rax, (%rbx)
	movq	$3, 8(%rbx)
	movq	%rdi, 16(%rbx)
	movq	%rsi, %rax
	addq	$8, %rsp
	jmp	camlCode__iter_1033@PLT
.L111:	call	caml_call_gc@PLT
.L112:	jmp	.L110
	.type	camlCode__sum_i_1030,@function
	.size	camlCode__sum_i_1030,.-camlCode__sum_i_1030
	.text
	.align	16
	.globl	camlCode__sum_f_1037
camlCode__sum_f_1037:
.L113:
	movq	%rax, %rbx
	movq	camlCode__6@GOTPCREL(%rip), %rax
	movq	camlCode__2@GOTPCREL(%rip), %rax
	jmp	camlCode__iterf_1039@PLT
	.type	camlCode__sum_f_1037,@function
	.size	camlCode__sum_f_1037,.-camlCode__sum_f_1037
	.text
	.align	16
	.globl	camlCode__fun_1056
camlCode__fun_1056:
	subq	$8, %rsp
.L114:
	movq	%rax, %rbx
.L115:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L116
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	sarq	$1, %rbx
	cvtsi2sdq	%rbx, %xmm0
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L116:	call	caml_call_gc@PLT
.L117:	jmp	.L115
	.type	camlCode__fun_1056,@function
	.size	camlCode__fun_1056,.-camlCode__fun_1056
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L118:
	movq	camlCode__5@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__4@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	$20000001, %rax
	call	camlArray__init_1037@PLT
.L119:
	call	camlArray__to_list_1121@PLT
.L120:
	call	camlCode__sum_f_1037@PLT
.L121:
	movq	$1, %rax
	addq	$8, %rsp
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
	.quad	6
	.quad	.L121
	.word	16
	.word	0
	.align	8
	.quad	.L120
	.word	16
	.word	0
	.align	8
	.quad	.L119
	.word	16
	.word	0
	.align	8
	.quad	.L117
	.word	16
	.word	1
	.word	3
	.align	8
	.quad	.L112
	.word	16
	.word	1
	.word	7
	.align	8
	.quad	.L108
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

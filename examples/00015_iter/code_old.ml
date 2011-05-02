(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.

   Here, the two arguments only differ by the fact that the first one
   is currified, while the second one is a "tuplified" function.
*)

let computed1 =
  let rec iter1 f l =
    match l with
	[] -> ()
      | a::l -> f a; iter1 f l

  in
  let list1 = ref [] in
  iter1 (fun x -> list1 := x :: !list1) [1; 2; 3; 4; 5];
  !list1

let computed2 =
  let rec iter1 f l =
    match l with
	[] -> ()
      | a::l -> f a; iter1 f l
  in

  let list1 = ref [] in
  iter1 (fun (x,y) -> list1 := x :: !list1) [1,2; 2,3; 3,3; 4,5; 5,6];
  !list1

(*
-drawlambda
(seq
  (let
    (computed1/1030
       (letrec
         (iter1/1031
            (function f/1032 l/1033
              (if l/1033
                (let (l/1035 (field 1 l/1033) a/1034 (field 0 l/1033))
                  (seq (apply f/1032 a/1034)
                    (apply iter1/1031 f/1032 l/1035)))
                0a)))
         (let (list1/1036 (makemutable 0 0a))
           (seq
             (apply iter1/1031
               (function x/1037
                 (setfield_ptr 0 list1/1036
                   (makeblock 0 x/1037 (field 0 list1/1036))))
               [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
             (field 0 list1/1036)))))
    (setfield_imm 0 (global Code!) computed1/1030))
  (let
    (computed2/1038
       (letrec
         (iter1/1039
            (function f/1040 l/1041
              (if l/1041
                (let (l/1043 (field 1 l/1041) a/1042 (field 0 l/1041))
                  (seq (apply f/1040 a/1042)
                    (apply iter1/1039 f/1040 l/1043)))
                0a)))
         (let (list1/1044 (makemutable 0 0a))
           (seq
             (apply iter1/1039
               (function (param/1049, param/1050)
                 (let (y/1046 param/1050 x/1045 param/1049)
                   (setfield_ptr 0 list1/1044
                     (makeblock 0 x/1045 (field 0 list1/1044)))))
               [0:
                [0: 1 2]
                [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]])
             (field 0 list1/1044)))))
    (setfield_imm 1 (global Code!) computed2/1038))
  0a)
-dlambda
(seq
  (let
    (computed1/1030
       (letrec
         (iter1/1031
            (function f/1032 l/1033
              (if l/1033
                (seq (apply f/1032 (field 0 l/1033))
                  (apply iter1/1031 f/1032 (field 1 l/1033)))
                0a)))
         (let (list1/1036 (makemutable 0 0a))
           (seq
             (apply iter1/1031
               (function x/1037
                 (setfield_ptr 0 list1/1036
                   (makeblock 0 x/1037 (field 0 list1/1036))))
               [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
             (field 0 list1/1036)))))
    (setfield_imm 0 (global Code!) computed1/1030))
  (let
    (computed2/1038
       (letrec
         (iter1/1039
            (function f/1040 l/1041
              (if l/1041
                (seq (apply f/1040 (field 0 l/1041))
                  (apply iter1/1039 f/1040 (field 1 l/1041)))
                0a)))
         (let (list1/1044 (makemutable 0 0a))
           (seq
             (apply iter1/1039
               (function (param/1049, param/1050)
                 (setfield_ptr 0 list1/1044
                   (makeblock 0 param/1049 (field 0 list1/1044))))
               [0:
                [0: 1 2]
                [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]])
             (field 0 list1/1044)))))
    (setfield_imm 1 (global Code!) computed2/1038))
  0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 16)
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter1_1039")
(data
 int 3319
 "camlCode__4":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter1_1031")
(data
 global "camlCode__1"
 int 2048
 "camlCode__1":
 int 3
 addr L14
 int 2048
 L14:
 int 5
 addr L15
 int 2048
 L15:
 int 7
 addr L16
 int 2048
 L16:
 int 9
 addr L17
 int 2048
 L17:
 int 11
 int 1)
(data
 global "camlCode__2"
 int 2048
 "camlCode__2":
 addr L5
 addr L6
 int 2048
 L6:
 addr L7
 addr L8
 int 2048
 L8:
 addr L9
 addr L10
 int 2048
 L10:
 addr L11
 addr L12
 int 2048
 L12:
 addr L13
 int 1
 int 2048
 L13:
 int 11
 int 13
 int 2048
 L11:
 int 9
 int 11
 int 2048
 L9:
 int 7
 int 7
 int 2048
 L7:
 int 5
 int 7
 int 2048
 L5:
 int 3
 int 5)
(function camlCode__iter1_1031 (f/1032: addr l/1033: addr)
 (if (!= l/1033 1)
   (seq (app (load f/1032) (load l/1033) f/1032 unit)
     (app "camlCode__iter1_1031" f/1032 (load (+a l/1033 8)) addr))
   1a))

(function camlCode__fun_1053 (x/1037: addr env/1055: addr)
 (extcall "caml_modify" (load (+a env/1055 16))
   (alloc 2048 x/1037 (load (load (+a env/1055 16)))) unit)
 1a)

(function camlCode__iter1_1039 (f/1040: addr l/1041: addr)
 (if (!= l/1041 1)
   (seq (app (load f/1040) (load l/1041) f/1040 unit)
     (app "camlCode__iter1_1039" f/1040 (load (+a l/1041 8)) addr))
   1a))

(function camlCode__fun_1059
     (param/1049: addr param/1050: addr env/1061: addr)
 (extcall "caml_modify" (load (+a env/1061 24))
   (alloc 2048 param/1049 (load (load (+a env/1061 24)))) unit)
 1a)

(function camlCode__entry ()
 (let
   computed1/1030
     (let (clos/1052 "camlCode__4" list1/1056 (alloc 1024 1a))
       (app "camlCode__iter1_1031"
         (alloc 3319 "camlCode__fun_1053" 3 list1/1056) "camlCode__1" unit)
       (load list1/1056))
   (store "camlCode" computed1/1030))
 (let
   computed2/1038
     (let (clos/1058 "camlCode__3" list1/1062 (alloc 1024 1a))
       (app "camlCode__iter1_1039"
         (alloc 4343 "caml_tuplify2" -3 "camlCode__fun_1059" list1/1062)
         "camlCode__2" unit)
       (load list1/1062))
   (store (+a "camlCode" 8) computed2/1038))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__iter1_1031:
  f/29[%rsi] := R/0[%rax]
  if l/30[%rbx] ==s 1 goto L100
  spilled-l/36[s0] := l/30[%rbx] (spill)
  spilled-f/35[s1] := f/29[%rsi] (spill)
  A/32[%rax] := [l/30[%rbx]]
  A/33[%rdi] := [f/29[%rsi]]
  R/1[%rbx] := f/29[%rsi]
  {spilled-f/35[s1]* spilled-l/36[s0]*}
  call A/33[%rdi] R/0[%rax] R/1[%rbx]
  l/37[%rax] := spilled-l/36[s0] (reload)
  A/34[%rbx] := [l/37[%rax] + 8]
  f/38[%rax] := spilled-f/35[s1] (reload)
  tailcall "camlCode__iter1_1031" R/0[%rax] R/1[%rbx]
  L100:
  A/31[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__fun_1053:
  x/29[%rdi] := R/0[%rax]
  {x/29[%rdi]* env/30[%rbx]*}
  A/31[%rsi] := alloc 24
  [A/31[%rsi] + -8] := 2048
  [A/31[%rsi]] := x/29[%rdi]
  A/32[%rax] := [env/30[%rbx] + 16]
  A/33[%rax] := [A/32[%rax]]
  [A/31[%rsi] + 8] := A/33[%rax]
  A/34[%rdi] := [env/30[%rbx] + 16]
  {}
  extcall "caml_modify" R/2[%rdi] R/3[%rsi]
  A/35[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__iter1_1039:
  f/29[%rsi] := R/0[%rax]
  if l/30[%rbx] ==s 1 goto L107
  spilled-l/36[s0] := l/30[%rbx] (spill)
  spilled-f/35[s1] := f/29[%rsi] (spill)
  A/32[%rax] := [l/30[%rbx]]
  A/33[%rdi] := [f/29[%rsi]]
  R/1[%rbx] := f/29[%rsi]
  {spilled-f/35[s1]* spilled-l/36[s0]*}
  call A/33[%rdi] R/0[%rax] R/1[%rbx]
  l/37[%rax] := spilled-l/36[s0] (reload)
  A/34[%rbx] := [l/37[%rax] + 8]
  f/38[%rax] := spilled-f/35[s1] (reload)
  tailcall "camlCode__iter1_1039" R/0[%rax] R/1[%rbx]
  L107:
  A/31[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__fun_1059:
  param/29[%rdx] := R/0[%rax]
  {param/29[%rdx]* env/31[%rdi]*}
  A/32[%rsi] := alloc 24
  [A/32[%rsi] + -8] := 2048
  [A/32[%rsi]] := param/29[%rdx]
  A/33[%rax] := [env/31[%rdi] + 24]
  A/34[%rax] := [A/33[%rax]]
  [A/32[%rsi] + 8] := A/34[%rax]
  A/35[%rdi] := [env/31[%rdi] + 24]
  {}
  extcall "caml_modify" R/2[%rdi] R/3[%rsi]
  A/36[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  clos/29[%rax] := "camlCode__4"
  {}
  list1/30[%rdi] := alloc 48
  spilled-list1/46[s0] := list1/30[%rdi] (spill)
  [list1/30[%rdi] + -8] := 1024
  [list1/30[%rdi]] := 1
  A/31[%rax] := list1/30[%rdi] + 16
  [A/31[%rax] + -8] := 3319
  A/32[%rbx] := "camlCode__fun_1053"
  [A/31[%rax]] := A/32[%rbx]
  [A/31[%rax] + 8] := 3
  [A/31[%rax] + 16] := list1/30[%rdi]
  A/33[%rbx] := "camlCode__1"
  {spilled-list1/46[s0]*}
  call "camlCode__iter1_1031" R/0[%rax] R/1[%rbx]
  list1/47[%rax] := spilled-list1/46[s0] (reload)
  computed1/34[%rbx] := [list1/47[%rax]]
  A/35[%rax] := "camlCode"
  [A/35[%rax]] := computed1/34[%rbx]
  clos/36[%rax] := "camlCode__3"
  {}
  list1/37[%rdi] := alloc 56
  spilled-list1/45[s0] := list1/37[%rdi] (spill)
  [list1/37[%rdi] + -8] := 1024
  [list1/37[%rdi]] := 1
  A/38[%rax] := list1/37[%rdi] + 16
  [A/38[%rax] + -8] := 4343
  A/39[%rbx] := "caml_tuplify2"
  [A/38[%rax]] := A/39[%rbx]
  [A/38[%rax] + 8] := -3
  A/40[%rbx] := "camlCode__fun_1059"
  [A/38[%rax] + 16] := A/40[%rbx]
  [A/38[%rax] + 24] := list1/37[%rdi]
  A/41[%rbx] := "camlCode__2"
  {spilled-list1/45[s0]*}
  call "camlCode__iter1_1039" R/0[%rax] R/1[%rbx]
  list1/48[%rax] := spilled-list1/45[s0] (reload)
  computed2/42[%rbx] := [list1/48[%rax]]
  A/43[%rax] := "camlCode"
  [A/43[%rax] + 8] := computed2/42[%rbx]
  A/44[%rax] := 1
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
	.quad	3319
camlCode__3:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__iter1_1039
	.data
	.quad	3319
camlCode__4:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__iter1_1031
	.data
	.globl	camlCode__1
	.quad	2048
camlCode__1:
	.quad	3
	.quad	.L100014
	.quad	2048
.L100014:
	.quad	5
	.quad	.L100015
	.quad	2048
.L100015:
	.quad	7
	.quad	.L100016
	.quad	2048
.L100016:
	.quad	9
	.quad	.L100017
	.quad	2048
.L100017:
	.quad	11
	.quad	1
	.data
	.globl	camlCode__2
	.quad	2048
camlCode__2:
	.quad	.L100005
	.quad	.L100006
	.quad	2048
.L100006:
	.quad	.L100007
	.quad	.L100008
	.quad	2048
.L100008:
	.quad	.L100009
	.quad	.L100010
	.quad	2048
.L100010:
	.quad	.L100011
	.quad	.L100012
	.quad	2048
.L100012:
	.quad	.L100013
	.quad	1
	.quad	2048
.L100013:
	.quad	11
	.quad	13
	.quad	2048
.L100011:
	.quad	9
	.quad	11
	.quad	2048
.L100009:
	.quad	7
	.quad	7
	.quad	2048
.L100007:
	.quad	5
	.quad	7
	.quad	2048
.L100005:
	.quad	3
	.quad	5
	.text
	.align	16
	.globl	camlCode__iter1_1031
camlCode__iter1_1031:
	subq	$24, %rsp
.L101:
	movq	%rax, %rsi
	cmpq	$1, %rbx
	je	.L100
	movq	%rbx, 0(%rsp)
	movq	%rsi, 8(%rsp)
	movq	(%rbx), %rax
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L102:
	movq	0(%rsp), %rax
	movq	8(%rax), %rbx
	movq	8(%rsp), %rax
	jmp	.L101
	.align	4
.L100:
	movq	$1, %rax
	addq	$24, %rsp
	ret
	.type	camlCode__iter1_1031,@function
	.size	camlCode__iter1_1031,.-camlCode__iter1_1031
	.text
	.align	16
	.globl	camlCode__fun_1053
camlCode__fun_1053:
	subq	$8, %rsp
.L103:
	movq	%rax, %rdi
.L104:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L105
	leaq	8(%r15), %rsi
	movq	$2048, -8(%rsi)
	movq	%rdi, (%rsi)
	movq	16(%rbx), %rax
	movq	(%rax), %rax
	movq	%rax, 8(%rsi)
	movq	16(%rbx), %rdi
	call	caml_modify@PLT
	movq	$1, %rax
	addq	$8, %rsp
	ret
.L105:	call	caml_call_gc@PLT
.L106:	jmp	.L104
	.type	camlCode__fun_1053,@function
	.size	camlCode__fun_1053,.-camlCode__fun_1053
	.text
	.align	16
	.globl	camlCode__iter1_1039
camlCode__iter1_1039:
	subq	$24, %rsp
.L108:
	movq	%rax, %rsi
	cmpq	$1, %rbx
	je	.L107
	movq	%rbx, 0(%rsp)
	movq	%rsi, 8(%rsp)
	movq	(%rbx), %rax
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L109:
	movq	0(%rsp), %rax
	movq	8(%rax), %rbx
	movq	8(%rsp), %rax
	jmp	.L108
	.align	4
.L107:
	movq	$1, %rax
	addq	$24, %rsp
	ret
	.type	camlCode__iter1_1039,@function
	.size	camlCode__iter1_1039,.-camlCode__iter1_1039
	.text
	.align	16
	.globl	camlCode__fun_1059
camlCode__fun_1059:
	subq	$8, %rsp
.L110:
	movq	%rax, %rdx
.L111:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L112
	leaq	8(%r15), %rsi
	movq	$2048, -8(%rsi)
	movq	%rdx, (%rsi)
	movq	24(%rdi), %rax
	movq	(%rax), %rax
	movq	%rax, 8(%rsi)
	movq	24(%rdi), %rdi
	call	caml_modify@PLT
	movq	$1, %rax
	addq	$8, %rsp
	ret
.L112:	call	caml_call_gc@PLT
.L113:	jmp	.L111
	.type	camlCode__fun_1059,@function
	.size	camlCode__fun_1059,.-camlCode__fun_1059
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L114:
	movq	camlCode__4@GOTPCREL(%rip), %rax
	movq	$48, %rax
	call	caml_allocN@PLT
.L115:
	leaq	8(%r15), %rdi
	movq	%rdi, 0(%rsp)
	movq	$1024, -8(%rdi)
	movq	$1, (%rdi)
	leaq	16(%rdi), %rax
	movq	$3319, -8(%rax)
	movq	camlCode__fun_1053@GOTPCREL(%rip), %rbx
	movq	%rbx, (%rax)
	movq	$3, 8(%rax)
	movq	%rdi, 16(%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	call	camlCode__iter1_1031@PLT
.L116:
	movq	0(%rsp), %rax
	movq	(%rax), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__3@GOTPCREL(%rip), %rax
	movq	$56, %rax
	call	caml_allocN@PLT
.L117:
	leaq	8(%r15), %rdi
	movq	%rdi, 0(%rsp)
	movq	$1024, -8(%rdi)
	movq	$1, (%rdi)
	leaq	16(%rdi), %rax
	movq	$4343, -8(%rax)
	movq	caml_tuplify2@GOTPCREL(%rip), %rbx
	movq	%rbx, (%rax)
	movq	$-3, 8(%rax)
	movq	camlCode__fun_1059@GOTPCREL(%rip), %rbx
	movq	%rbx, 16(%rax)
	movq	%rdi, 24(%rax)
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	call	camlCode__iter1_1039@PLT
.L118:
	movq	0(%rsp), %rax
	movq	(%rax), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
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
	.quad	8
	.quad	.L118
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L117
	.word	16
	.word	0
	.align	8
	.quad	.L116
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L115
	.word	16
	.word	0
	.align	8
	.quad	.L113
	.word	16
	.word	2
	.word	5
	.word	9
	.align	8
	.quad	.L109
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.quad	.L106
	.word	16
	.word	2
	.word	3
	.word	5
	.align	8
	.quad	.L102
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

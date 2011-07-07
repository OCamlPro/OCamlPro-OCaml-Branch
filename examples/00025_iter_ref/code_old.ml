

let rec iter f = function
    [] -> ()
  | x :: tail -> f x; iter f tail

let list = [1;2;3;4;5]

let sum list =
  let sum = ref 0. in
  iter (fun x -> sum := !sum +. x) list;
    !sum *. 1.

let _ =
  let array = Array.create 5_000_000 1. in
  let list = Array.to_list array in
  for i = 0 to 500 do
    ignore (sum list)
  done

(*
-drawlambda
(seq
  (letrec
    (iter/58
       (function f/59 param/73
         (if param/73
           (let (tail/61 (field 1 param/73) x/60 (field 0 param/73))
             (seq (apply f/59 x/60) (apply iter/58 f/59 tail/61)))
           0a)))
    (setfield_imm 0 (global Code!) iter/58))
  (let (list/62 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global Code!) list/62))
  (let
    (sum/63
       (function list/64
         (let (sum/65 (makemutable 0 0.))
           (seq
             (apply (field 0 (global Code!))
               (function x/66
                 (setfield_ptr 0 sum/65 (+. (field 0 sum/65) x/66)))
               list/64)
             (*. (field 0 sum/65) 1.)))))
    (setfield_imm 2 (global Code!) sum/63))
  (let
    (array/67 (caml_make_vect 5000000 1.)
     list/68 (apply (field 9 (global Array!)) array/67))
    (for i/69 0 to 500 (ignore (apply (field 2 (global Code!)) list/68))))
  0a)
-dlambda
(seq
  (letrec
    (iter/58
       (function f/59 param/73
         (if param/73
           (seq (apply f/59 (field 0 param/73))
             (apply iter/58 f/59 (field 1 param/73)))
           0a)))
    (setfield_imm 0 (global Code!) iter/58))
  (let (list/62 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global Code!) list/62))
  (let
    (sum/63
       (function list/64
         (let (sum/65 (makemutable 0 0.))
           (seq
             (apply (field 0 (global Code!))
               (function x/66
                 (setfield_ptr 0 sum/65 (+. (field 0 sum/65) x/66)))
               list/64)
             (*. (field 0 sum/65) 1.)))))
    (setfield_imm 2 (global Code!) sum/63))
  (let
    (array/67 (caml_make_vect 5000000 1.)
     list/68 (apply (field 9 (global Array!)) array/67))
    (for i/69 0 to 500 (ignore (apply (field 2 (global Code!)) list/68))))
  0a)

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 24)
(data int 2295 "camlCode__2": addr "camlCode__sum_63" int 3)
(data
 int 3319
 "camlCode__4":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter_58")
(data int 1277 "camlCode__1": double 1.)
(data
 int 2048
 "camlCode__3":
 int 3
 addr L6
 int 2048
 L6:
 int 5
 addr L7
 int 2048
 L7:
 int 7
 addr L8
 int 2048
 L8:
 int 9
 addr L9
 int 2048
 L9:
 int 11
 int 1)
(data int 1277 "camlCode__5": double 0.)
(function camlCode__fun_77 (x/66: addr env/79: addr)
 (extcall "caml_modify" (load (+a env/79 16))
   (alloc 1277
     (+f (load float64u (load (load (+a env/79 16)))) (load float64u x/66)))
   unit)
 1a)

(function camlCode__iter_58 (f/59: addr param/73: addr)
 (if (!= param/73 1)
   (seq (app (load f/59) (load param/73) f/59 unit)
     (app "camlCode__iter_58" f/59 (load (+a param/73 8)) addr))
   1a))

(function camlCode__sum_63 (list/64: addr)
 (let sum/65 (alloc 1024 "camlCode__5")
   (app "camlCode__iter_58" (alloc 3319 "camlCode__fun_77" 3 sum/65) list/64
     unit)
   (alloc 1277 (*f (load float64u (load sum/65)) 1.))))

(function camlCode__entry ()
 (let clos/75 "camlCode__4" (store "camlCode" clos/75))
 (let list/62 "camlCode__3" (store (+a "camlCode" 8) list/62))
 (let sum/63 "camlCode__2" (store (+a "camlCode" 16) sum/63))
 (let
   (array/67 (extcall "caml_make_vect" 10000001 "camlCode__1" addr)
    list/68 (app "camlArray__to_list_148" array/67 addr) i/69 1)
   (catch
     (if (> i/69 1001) (exit 6)
       (loop (app "camlCode__sum_63" list/68 unit)
         (let i/80 i/69 (assign i/69 (+ i/69 2))
           (if (== i/80 1001) (exit 6) []))))
   with(6) []))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__fun_77:
  x/29[%rdi] := R/0[%rax]
  {x/29[%rdi]* env/30[%rbx]*}
  A/31[%rsi] := alloc 16
  [A/31[%rsi] + -8] := 1277
  A/32[%rax] := [env/30[%rbx] + 16]
  A/33[%rax] := [A/32[%rax]]
  F/34[%xmm0] := float64u[A/33[%rax]]
  F/35[%xmm0] := F/35[%xmm0] +f float64[x/29[%rdi]]
  float64u[A/31[%rsi]] := F/35[%xmm0]
  A/36[%rdi] := [env/30[%rbx] + 16]
  {}
  extcall "caml_modify" R/2[%rdi] R/3[%rsi]
  A/37[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__iter_58:
  f/29[%rsi] := R/0[%rax]
  if param/30[%rbx] ==s 1 goto L104
  spilled-param/36[s0] := param/30[%rbx] (spill)
  spilled-f/35[s1] := f/29[%rsi] (spill)
  A/32[%rax] := [param/30[%rbx]]
  A/33[%rdi] := [f/29[%rsi]]
  R/1[%rbx] := f/29[%rsi]
  {spilled-f/35[s1]* spilled-param/36[s0]*}
  call A/33[%rdi] R/0[%rax] R/1[%rbx]
  param/37[%rax] := spilled-param/36[s0] (reload)
  A/34[%rbx] := [param/37[%rax] + 8]
  f/38[%rax] := spilled-f/35[s1] (reload)
  tailcall "camlCode__iter_58" R/0[%rax] R/1[%rbx]
  L104:
  A/31[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__sum_63:
  list/29[%rbx] := R/0[%rax]
  {list/29[%rbx]*}
  sum/30[%rsi] := alloc 48
  spilled-sum/38[s0] := sum/30[%rsi] (spill)
  [sum/30[%rsi] + -8] := 1024
  A/31[%rax] := "camlCode__5"
  [sum/30[%rsi]] := A/31[%rax]
  A/32[%rax] := sum/30[%rsi] + 16
  [A/32[%rax] + -8] := 3319
  A/33[%rdi] := "camlCode__fun_77"
  [A/32[%rax]] := A/33[%rdi]
  [A/32[%rax] + 8] := 3
  [A/32[%rax] + 16] := sum/30[%rsi]
  {spilled-sum/38[s0]*}
  call "camlCode__iter_58" R/0[%rax] R/1[%rbx]
  {spilled-sum/38[s0]*}
  A/34[%rax] := alloc 16
  [A/34[%rax] + -8] := 1277
  sum/39[%rbx] := spilled-sum/38[s0] (reload)
  A/35[%rbx] := [sum/39[%rbx]]
  F/36[%xmm0] := 1.
  F/37[%xmm0] := F/37[%xmm0] *f float64[A/35[%rbx]]
  float64u[A/34[%rax]] := F/37[%xmm0]
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  clos/29[%rbx] := "camlCode__4"
  A/30[%rax] := "camlCode"
  [A/30[%rax]] := clos/29[%rbx]
  list/31[%rbx] := "camlCode__3"
  A/32[%rax] := "camlCode"
  [A/32[%rax] + 8] := list/31[%rbx]
  sum/33[%rbx] := "camlCode__2"
  A/34[%rax] := "camlCode"
  [A/34[%rax] + 16] := sum/33[%rbx]
  A/35[%rsi] := "camlCode__1"
  I/36[%rdi] := 10000001
  {}
  R/0[%rax] := extcall "caml_make_vect" R/2[%rdi] R/3[%rsi] (noalloc)
  {}
  R/0[%rax] := call "camlArray__to_list_148" R/0[%rax]
  i/39[%rbx] := 1
  if i/39[%rbx] >s 1001 goto L116
  spilled-i/43[s1] := i/39[%rbx] (spill)
  spilled-list/44[s0] := list/38[%rax] (spill)
  L117:
  list/45[%rax] := spilled-list/44[s0] (reload)
  {spilled-i/43[s1] spilled-list/44[s0]*}
  call "camlCode__sum_63" R/0[%rax]
  i/46[%rax] := spilled-i/43[s1] (reload)
  i/40[%rbx] := i/46[%rax]
  I/41[%rax] := I/41[%rax] + 2
  spilled-i/43[s1] := i/46[%rax] (spill)
  if i/40[%rbx] !=s 1001 goto L117
  L116:
  A/42[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
-S
	.section        .rodata.cst8,"a",@progbits
	.align  16
caml_negf_mask:	.quad   0x8000000000000000, 0
	.align  16
caml_absf_mask:	.quad   0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.quad	3072
	.globl	camlCode
camlCode:
	.space	24
	.data
	.quad	2295
camlCode__2:
	.quad	camlCode__sum_63
	.quad	3
	.data
	.quad	3319
camlCode__4:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__iter_58
	.data
	.quad	1277
camlCode__1:
	.quad	0x3ff0000000000000
	.data
	.quad	2048
camlCode__3:
	.quad	3
	.quad	.L100006
	.quad	2048
.L100006:
	.quad	5
	.quad	.L100007
	.quad	2048
.L100007:
	.quad	7
	.quad	.L100008
	.quad	2048
.L100008:
	.quad	9
	.quad	.L100009
	.quad	2048
.L100009:
	.quad	11
	.quad	1
	.data
	.quad	1277
camlCode__5:
	.quad	0x0
	.text
	.align	16
	.globl	camlCode__fun_77
camlCode__fun_77:
	subq	$8, %rsp
.L100:
	movq	%rax, %rdi
.L101:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L102
	leaq	8(%r15), %rsi
	movq	$1277, -8(%rsi)
	movq	16(%rbx), %rax
	movq	(%rax), %rax
	movlpd	(%rax), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rsi)
	movq	16(%rbx), %rdi
	call	caml_modify@PLT
	movq	$1, %rax
	addq	$8, %rsp
	ret
.L102:	call	caml_call_gc@PLT
.L103:	jmp	.L101
	.type	camlCode__fun_77,@function
	.size	camlCode__fun_77,.-camlCode__fun_77
	.text
	.align	16
	.globl	camlCode__iter_58
camlCode__iter_58:
	subq	$24, %rsp
.L105:
	movq	%rax, %rsi
	cmpq	$1, %rbx
	je	.L104
	movq	%rbx, 0(%rsp)
	movq	%rsi, 8(%rsp)
	movq	(%rbx), %rax
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L106:
	movq	0(%rsp), %rax
	movq	8(%rax), %rbx
	movq	8(%rsp), %rax
	jmp	.L105
	.align	4
.L104:
	movq	$1, %rax
	addq	$24, %rsp
	ret
	.type	camlCode__iter_58,@function
	.size	camlCode__iter_58,.-camlCode__iter_58
	.text
	.align	16
	.globl	camlCode__sum_63
camlCode__sum_63:
	subq	$8, %rsp
.L107:
	movq	%rax, %rbx
.L108:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L109
	leaq	8(%r15), %rsi
	movq	%rsi, 0(%rsp)
	movq	$1024, -8(%rsi)
	movq	camlCode__5@GOTPCREL(%rip), %rax
	movq	%rax, (%rsi)
	leaq	16(%rsi), %rax
	movq	$3319, -8(%rax)
	movq	camlCode__fun_77@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	call	camlCode__iter_58@PLT
.L111:
.L112:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L113
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	movq	0(%rsp), %rbx
	movq	(%rbx), %rbx
	movlpd	.L115(%rip), %xmm0
	mulsd	(%rbx), %xmm0
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L113:	call	caml_call_gc@PLT
.L114:	jmp	.L112
.L109:	call	caml_call_gc@PLT
.L110:	jmp	.L108
	.section	.rodata.cst8,"a",@progbits
.L115:	.quad	0x3ff0000000000000
	.type	camlCode__sum_63,@function
	.size	camlCode__sum_63,.-camlCode__sum_63
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$24, %rsp
.L118:
	movq	camlCode__4@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 16(%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rsi
	movq	$10000001, %rdi
	movq	caml_make_vect@GOTPCREL(%rip), %rax
	call	caml_c_call@PLT
.L119:
	call	camlArray__to_list_148@PLT
.L120:
	movq	$1, %rbx
	cmpq	$1001, %rbx
	jg	.L116
	movq	%rbx, 8(%rsp)
	movq	%rax, 0(%rsp)
.L117:
	movq	0(%rsp), %rax
	call	camlCode__sum_63@PLT
.L121:
	movq	8(%rsp), %rax
	movq	%rax, %rbx
	addq	$2, %rax
	movq	%rax, 8(%rsp)
	cmpq	$1001, %rbx
	jne	.L117
.L116:
	movq	$1, %rax
	addq	$24, %rsp
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
	.quad	.L121
	.word	32
	.word	1
	.word	0
	.align	8
	.quad	.L120
	.word	32
	.word	0
	.align	8
	.quad	.L119
	.word	32
	.word	0
	.align	8
	.quad	.L114
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L111
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L110
	.word	16
	.word	1
	.word	3
	.align	8
	.quad	.L106
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.quad	.L103
	.word	16
	.word	2
	.word	3
	.word	5
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

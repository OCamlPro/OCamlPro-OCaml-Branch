(*
ocamlopt -dlambda -c code.ml
ocamlopt -dclosure -c code.ml
ocamlopt -dcmm -c code.ml
ocamlopt -S -c code.ml
*)

let f1 x =
  let y = ref x in
    for i = 0 to 10 do
      y := !y +. 1.
    done;
    !y

let f2 x =
  let y = ref x in
  let rec iter i =
    if i < 11_000_000 then begin
      y := !y +. 1.;
      iter (i+1)
    end
  in
  iter 0;
    !y

let _ =
  for i = 1 to 100 do
    ignore (f2 3.)
  done

(*

-dlambda:
(seq
  (let
    (f1/58
       (function x/59
         (let (y/60 x/59)
           (seq (for i/61 0 to 10 (assign y/60 (+. y/60 1.))) y/60))))
    (setfield_imm 0 (global Code!) f1/58))
  (let
    (f2/62
       (function x/63
         (let (y/64 (makemutable 0 x/63))
           (letrec
             (iter/65
                (function i/66
                  (if (< i/66 11)
                    (seq (setfield_ptr 0 y/64 (+. (field 0 y/64) 1.))
                      (apply iter/65 (+ i/66 1)))
                    0a)))
             (field 0 y/64)))))
    (setfield_imm 1 (global Code!) f2/62))
  0a)

-dclosure:
(seq
  (let
    (f1/58
       (closure (camlCode__f1_58[1]( x/59)
                 (let (y/60 x/59)
                   (seq (for i/61 0 to 10 (assign y/60 (+. y/60 1.))) y/60))) [
        ]))
    (setfield_imm 0 (global camlCode!) f1/58))
  (let
    (f2/62
       (closure (camlCode__f2_62[1]( x/63)
                 (let
                   (y/64 (makemutable 0 x/63)
                    clos/73
                      (closure (camlCode__iter_65[1]( i/66 env/72)
                                (if (< i/66 11)
                                  (seq
                                    (setfield_ptr 0 (field 2 env/72)
                                      (+. (field 0 (field 2 env/72)) 1.))
                                    (camlCode__iter_65  (+ i/66 1)
                                      (offset[0] env/72)))
                                  0a)) [
                                        y/64]))
                   (field 0 y/64))) []))
    (setfield_imm 1 (global camlCode!) f2/62))

-dcmm:
(data int 2048 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__f2_62" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f1_58" int 3)
(function camlCode__iter_65 (i/66: addr env/72: addr)
 (if (< i/66 23)
   (seq
     (extcall "caml_modify" (load (+a env/72 8))
       (alloc 2301 (+f (load float64u (load (load (+a env/72 8)))) 1.)) unit)
     (app "camlCode__iter_65" (+ i/66 2) env/72 addr))
   1a))

(function camlCode__f1_58 (x/59: addr)
 (let y/60 x/59
   (let i/61 1
     (catch
       (if (> i/61 21) (exit 5)
         (loop (assign y/60 (alloc 2301 (+f (load float64u y/60) 1.)))
           (let i/74 i/61 (assign i/61 (+ i/61 2))
             (if (== i/74 21) (exit 5) []))))
     with(5) []))
   y/60))

(function camlCode__f2_62 (x/63: addr)
 (let
   (y/64 (alloc 1024 x/63) clos/73 (alloc 3319 "camlCode__iter_65" 3 y/64))
   (load y/64)))

(function camlCode__entry ()
 (let f1/58 "camlCode__2" (store "camlCode" f1/58))
 (let f2/62 "camlCode__1" (store (+a "camlCode" 4) f2/62)) 1a)

(data)

-S:
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
	.long	camlCode__f2_62
	.long	3
	.data
	.long	2295
camlCode__2:
	.long	camlCode__f1_58
	.long	3
	.text
	.align	16
	.globl	camlCode__iter_65
camlCode__iter_65:
	subl	$8, %esp
.L101:
	movl	%eax, %esi
	cmpl	$23, %esi
	jge	.L100
.L102:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L103
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	movl	8(%ebx), %eax
	movl	(%eax), %eax
	fld1
	faddl	(%eax)
	fstpl	(%ecx)
	pushl	%ecx
	pushl	8(%ebx)
	call	caml_modify
	addl	$8, %esp
	movl	%esi, %eax
	addl	$2, %eax
	jmp	.L101
	.align	16
.L100:
	movl	$1, %eax
	addl	$8, %esp
	ret
.L103:	call	caml_call_gc
.L104:	jmp	.L102
	.type	camlCode__iter_65,@function
	.size	camlCode__iter_65,.-camlCode__iter_65
	.text
	.align	16
	.globl	camlCode__f1_58
camlCode__f1_58:
	subl	$8, %esp
.L107:
	movl	%eax, %edx
	movl	$1, %ebx
	cmpl	$21, %ebx
	jg	.L105
.L106:
.L108:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L109
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	fld1
	faddl	(%edx)
	fstpl	(%ecx)
	movl	%ecx, %edx
	movl	%ebx, %ecx
	addl	$2, %ebx
	cmpl	$21, %ecx
	jne	.L106
.L105:
	movl	%edx, %eax
	addl	$8, %esp
	ret
.L109:	call	caml_call_gc
.L110:	jmp	.L108
	.type	camlCode__f1_58,@function
	.size	camlCode__f1_58,.-camlCode__f1_58
	.text
	.align	16
	.globl	camlCode__f2_62
camlCode__f2_62:
.L111:
	movl	%eax, %ecx
.L112:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L113
	leal	4(%eax), %ebx
	movl	$1024, -4(%ebx)
	movl	%ecx, (%ebx)
	leal	8(%ebx), %eax
	movl	$3319, -4(%eax)
	movl	$camlCode__iter_65, (%eax)
	movl	$3, 4(%eax)
	movl	%ebx, 8(%eax)
	movl	(%ebx), %eax
	ret
.L113:	call	caml_call_gc
.L114:	jmp	.L112
	.type	camlCode__f2_62,@function
	.size	camlCode__f2_62,.-camlCode__f2_62
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L115:
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
	.long	3
	.long	.L114
	.word	4
	.word	1
	.word	5
	.align	4
	.long	.L110
	.word	12
	.word	1
	.word	7
	.align	4
	.long	.L104
	.word	12
	.word	2
	.word	3
	.word	9
	.align	4

	.section .note.GNU-stack,"",%progbits


*)
(*
-drawlambda
(seq
  (let
    (f1/1030
       (function x/1031
         (let (y/1032 (makemutable 0 x/1031))
           (seq
             (for i/1033 0 to 10
               (setfield_ptr 0 y/1032 (+. (field 0 y/1032) 1.)))
             (field 0 y/1032)))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1034
       (function x/1035
         (let (y/1036 (makemutable 0 x/1035))
           (letrec
             (iter/1037
                (function i/1038
                  (if (< i/1038 11000000)
                    (seq (setfield_ptr 0 y/1036 (+. (field 0 y/1036) 1.))
                      (apply iter/1037 (+ i/1038 1)))
                    0a)))
             (seq (apply iter/1037 0) (field 0 y/1036))))))
    (setfield_imm 1 (global Code!) f2/1034))
  (for i/1039 1 to 100 (ignore (apply (field 1 (global Code!)) 3.))) 0a)
-dlambda
(seq
  (let
    (f1/1030
       (function x/1031
         (let (y/1032 x/1031)
           (seq (for i/1033 0 to 10 (assign y/1032 (+. y/1032 1.))) y/1032))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1034
       (function x/1035
         (let (y/1036 (makemutable 0 x/1035))
           (letrec
             (iter/1037
                (function i/1038
                  (if (< i/1038 11000000)
                    (seq (setfield_ptr 0 y/1036 (+. (field 0 y/1036) 1.))
                      (apply iter/1037 (+ i/1038 1)))
                    0a)))
             (seq (apply iter/1037 0) (field 0 y/1036))))))
    (setfield_imm 1 (global Code!) f2/1034))
  (for i/1039 1 to 100 (ignore (apply (field 1 (global Code!)) 3.))) 0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__5": addr "camlCode__f2_1034" int 3)
(data int 2295 "camlCode__6": addr "camlCode__f1_1030" int 3)
(data global "camlCode__1" int 1277 "camlCode__1": double 1.)
(data global "camlCode__2" int 1277 "camlCode__2": double 1.)
(data global "camlCode__3" int 1277 "camlCode__3": double 1.)
(data global "camlCode__4" int 1277 "camlCode__4": double 3.)
(function camlCode__iter_1037 (i/1038: addr env/1045: addr)
 (if (< i/1038 22000001)
   (seq
     (extcall "caml_modify" (load (+a env/1045 16))
       (alloc 1277 (+f (load float64u (load (load (+a env/1045 16)))) 1.))
       unit)
     (app "camlCode__iter_1037" (+ i/1038 2) env/1045 addr))
   1a))

(function camlCode__f1_1030 (x/1031: addr)
 (let y/1032 x/1031
   (let i/1033 1
     (catch
       (if (> i/1033 21) (exit 6)
         (loop (assign y/1032 (alloc 1277 (+f (load float64u y/1032) 1.)))
           (let i/1048 i/1033 (assign i/1033 (+ i/1033 2))
             (if (== i/1048 21) (exit 6) []))))
     with(6) []))
   y/1032))

(function camlCode__f2_1034 (x/1035: addr)
 (let
   (y/1036 (alloc 1024 x/1035)
    clos/1046 (alloc 3319 "camlCode__iter_1037" 3 y/1036))
   (app "camlCode__iter_1037" 1 clos/1046 unit) (load y/1036)))

(function camlCode__entry ()
 (let f1/1030 "camlCode__6" (store "camlCode" f1/1030))
 (let f2/1034 "camlCode__5" (store (+a "camlCode" 8) f2/1034))
 (let i/1039 3
   (catch
     (if (> i/1039 201) (exit 5)
       (loop (app "camlCode__f2_1034" "camlCode__4" unit)
         (let i/1047 i/1039 (assign i/1039 (+ i/1039 2))
           (if (== i/1047 201) (exit 5) []))))
   with(5) []))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__iter_1037:
  i/29[%rbp] := R/0[%rax]
  if i/29[%rbp] >=s 22000001 goto L100
  {i/29[%rbp]* env/30[%rbx]*}
  A/32[%rsi] := alloc 16
  [A/32[%rsi] + -8] := 1277
  A/33[%rax] := [env/30[%rbx] + 16]
  A/34[%rax] := [A/33[%rax]]
  F/35[%xmm0] := 1.
  F/36[%xmm0] := F/36[%xmm0] +f float64[A/34[%rax]]
  float64u[A/32[%rsi]] := F/36[%xmm0]
  A/37[%rdi] := [env/30[%rbx] + 16]
  {i/29[%rbp]* env/30[%rbx]*}
  extcall "caml_modify" R/2[%rdi] R/3[%rsi]
  I/38[%rax] := i/29[%rbp]
  I/38[%rax] := I/38[%rax] + 2
  tailcall "camlCode__iter_1037" R/0[%rax] R/1[%rbx]
  L100:
  A/31[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__f1_1030:
  y/30[%rsi] := x/29[%rax]
  i/31[%rbx] := 1
  if i/31[%rbx] >s 21 goto L106
  L107:
  {y/30[%rsi]* i/31[%rbx]}
  A/32[%rdi] := alloc 16
  [A/32[%rdi] + -8] := 1277
  F/33[%xmm0] := 1.
  F/34[%xmm0] := F/34[%xmm0] +f float64[y/30[%rsi]]
  float64u[A/32[%rdi]] := F/34[%xmm0]
  y/30[%rsi] := A/32[%rdi]
  i/35[%rdi] := i/31[%rbx]
  I/36[%rbx] := I/36[%rbx] + 2
  if i/35[%rdi] !=s 21 goto L107
  L106:
  R/0[%rax] := y/30[%rsi]
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__f2_1034:
  x/29[%rbx] := R/0[%rax]
  {x/29[%rbx]*}
  y/30[%rdi] := alloc 48
  spilled-y/35[s0] := y/30[%rdi] (spill)
  [y/30[%rdi] + -8] := 1024
  [y/30[%rdi]] := x/29[%rbx]
  clos/31[%rbx] := y/30[%rdi] + 16
  [clos/31[%rbx] + -8] := 3319
  A/32[%rax] := "camlCode__iter_1037"
  [clos/31[%rbx]] := A/32[%rax]
  [clos/31[%rbx] + 8] := 3
  [clos/31[%rbx] + 16] := y/30[%rdi]
  I/33[%rax] := 1
  {spilled-y/35[s0]*}
  call "camlCode__iter_1037" R/0[%rax] R/1[%rbx]
  y/36[%rax] := spilled-y/35[s0] (reload)
  A/34[%rax] := [y/36[%rax]]
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__entry:
  f1/29[%rbx] := "camlCode__6"
  A/30[%rax] := "camlCode"
  [A/30[%rax]] := f1/29[%rbx]
  f2/31[%rbx] := "camlCode__5"
  A/32[%rax] := "camlCode"
  [A/32[%rax] + 8] := f2/31[%rbx]
  i/33[%rax] := 3
  if i/33[%rax] >s 201 goto L118
  spilled-i/38[s0] := i/33[%rax] (spill)
  L119:
  A/34[%rax] := "camlCode__4"
  {spilled-i/38[s0]}
  call "camlCode__f2_1034" R/0[%rax]
  i/39[%rax] := spilled-i/38[s0] (reload)
  i/35[%rbx] := i/39[%rax]
  I/36[%rax] := I/36[%rax] + 2
  spilled-i/38[s0] := i/39[%rax] (spill)
  if i/35[%rbx] !=s 201 goto L119
  L118:
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
camlCode__5:
	.quad	camlCode__f2_1034
	.quad	3
	.data
	.quad	2295
camlCode__6:
	.quad	camlCode__f1_1030
	.quad	3
	.data
	.globl	camlCode__1
	.quad	1277
camlCode__1:
	.quad	0x3ff0000000000000
	.data
	.globl	camlCode__2
	.quad	1277
camlCode__2:
	.quad	0x3ff0000000000000
	.data
	.globl	camlCode__3
	.quad	1277
camlCode__3:
	.quad	0x3ff0000000000000
	.data
	.globl	camlCode__4
	.quad	1277
camlCode__4:
	.quad	0x4008000000000000
	.text
	.align	16
	.globl	camlCode__iter_1037
camlCode__iter_1037:
	subq	$8, %rsp
.L101:
	movq	%rax, %rbp
	cmpq	$22000001, %rbp
	jge	.L100
.L102:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L103
	leaq	8(%r15), %rsi
	movq	$1277, -8(%rsi)
	movq	16(%rbx), %rax
	movq	(%rax), %rax
	movlpd	.L105(%rip), %xmm0
	addsd	(%rax), %xmm0
	movlpd	%xmm0, (%rsi)
	movq	16(%rbx), %rdi
	call	caml_modify@PLT
	movq	%rbp, %rax
	addq	$2, %rax
	jmp	.L101
	.align	4
.L100:
	movq	$1, %rax
	addq	$8, %rsp
	ret
.L103:	call	caml_call_gc@PLT
.L104:	jmp	.L102
	.type	camlCode__iter_1037,@function
	.size	camlCode__iter_1037,.-camlCode__iter_1037
	.section	.rodata.cst8,"a",@progbits
.L105:	.quad	0x3ff0000000000000
	.text
	.align	16
	.globl	camlCode__f1_1030
camlCode__f1_1030:
	subq	$8, %rsp
.L108:
	movq	%rax, %rsi
	movq	$1, %rbx
	cmpq	$21, %rbx
	jg	.L106
.L107:
.L109:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L110
	leaq	8(%r15), %rdi
	movq	$1277, -8(%rdi)
	movlpd	.L112(%rip), %xmm0
	addsd	(%rsi), %xmm0
	movlpd	%xmm0, (%rdi)
	movq	%rdi, %rsi
	movq	%rbx, %rdi
	addq	$2, %rbx
	cmpq	$21, %rdi
	jne	.L107
.L106:
	movq	%rsi, %rax
	addq	$8, %rsp
	ret
.L110:	call	caml_call_gc@PLT
.L111:	jmp	.L109
	.type	camlCode__f1_1030,@function
	.size	camlCode__f1_1030,.-camlCode__f1_1030
	.section	.rodata.cst8,"a",@progbits
.L112:	.quad	0x3ff0000000000000
	.text
	.align	16
	.globl	camlCode__f2_1034
camlCode__f2_1034:
	subq	$8, %rsp
.L113:
	movq	%rax, %rbx
.L114:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L115
	leaq	8(%r15), %rdi
	movq	%rdi, 0(%rsp)
	movq	$1024, -8(%rdi)
	movq	%rbx, (%rdi)
	leaq	16(%rdi), %rbx
	movq	$3319, -8(%rbx)
	movq	camlCode__iter_1037@GOTPCREL(%rip), %rax
	movq	%rax, (%rbx)
	movq	$3, 8(%rbx)
	movq	%rdi, 16(%rbx)
	movq	$1, %rax
	call	camlCode__iter_1037@PLT
.L117:
	movq	0(%rsp), %rax
	movq	(%rax), %rax
	addq	$8, %rsp
	ret
.L115:	call	caml_call_gc@PLT
.L116:	jmp	.L114
	.type	camlCode__f2_1034,@function
	.size	camlCode__f2_1034,.-camlCode__f2_1034
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L120:
	movq	camlCode__6@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__5@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	$3, %rax
	cmpq	$201, %rax
	jg	.L118
	movq	%rax, 0(%rsp)
.L119:
	movq	camlCode__4@GOTPCREL(%rip), %rax
	call	camlCode__f2_1034@PLT
.L121:
	movq	0(%rsp), %rax
	movq	%rax, %rbx
	addq	$2, %rax
	movq	%rax, 0(%rsp)
	cmpq	$201, %rbx
	jne	.L119
.L118:
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
	.quad	5
	.quad	.L121
	.word	16
	.word	0
	.align	8
	.quad	.L117
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L116
	.word	16
	.word	1
	.word	3
	.align	8
	.quad	.L111
	.word	16
	.word	1
	.word	7
	.align	8
	.quad	.L104
	.word	16
	.word	2
	.word	3
	.word	21
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

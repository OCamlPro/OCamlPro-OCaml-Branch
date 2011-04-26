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
         (let
           (y/1036 (makemutable 0 x/1035)
            iter/1037
              (function i/1045
                (catch
                  (let (i/1044 i/1045)
                    (while 1a
                      (catch
                        (let (i/1038 i/1044)
                          (exit 5
                            (if (< i/1038 11000000)
                              (seq
                                (setfield_ptr 0 y/1036
                                  (+. (field 0 y/1036) 1.))
                                (exit 6 (+ i/1038 1)))
                              0a)))
                       with (6 i/1043) (seq (assign i/1044 i/1043) 0a))))
                 with (5 result/1046) result/1046)))
           (seq (apply iter/1037 0) (field 0 y/1036)))))
    (setfield_imm 1 (global Code!) f2/1034))
  (for i/1039 1 to 100 (ignore (apply (field 1 (global Code!)) 3.))) 0a)
-dclosure
*** After closure conversion:
(seq
  (let
    (f1/1030 {fun camlCode__f1_1030 {1} closed inline -> ?} = 
       (closure (camlCode__f1_1030(1)  x/1031
                  (let (y/1032 {?} =  x/1031)
                    (seq (for i/1033 0 to 10 (assign y/1032 (+. y/1032 1.)))
                      y/1032))) {0} ))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let
    (f2/1034 {fun camlCode__f2_1034 {1} closed -> ?} = 
       (closure (camlCode__f2_1034(1)  x/1035
                  (let
                    (y/1036 {?} =  (makemutable 0 x/1035)
                     iter/1037 {fun camlCode__iter_1037 {1} inline -> ?} = 
                       (closure (camlCode__iter_1037(1)  i/1045 env/1050
                                  (catch
                                    (let (i/1044 {?} =  i/1045)
                                      (while 1a
                                        (catch
                                          (let (i/1038 {?} =  i/1044)
                                            (exit 5
                                              (if (< i/1038 11000000)
                                                (seq
                                                  (setfield_ptr 0
                                                    (field 2 env/1050)
                                                    (+.
                                                      (field 0
                                                        (field 2 env/1050))
                                                      1.))
                                                  (exit 6 (+ i/1038 1)))
                                                0a)))
                                         with (6 i/1043)
                                          (seq (assign i/1044 i/1043) 0a))))
                                   with (5 result/1046) result/1046)) 
                         {0} 
                         y/1036))
                    (seq
                      (catch
                        (let (i/1051 {?} =  0)
                          (while 1a
                            (catch
                              (let (i/1052 {?} =  i/1051)
                                (exit 5
                                  (if (< i/1052 11000000)
                                    (seq
                                      (setfield_ptr 0 (field 2 iter/1037)
                                        (+. (field 0 (field 2 iter/1037)) 1.))
                                      (exit 6 (+ i/1052 1)))
                                    0a)))
                             with (6 i/1043) (seq (assign i/1051 i/1043) 0a))))
                       with (5 result/1046) result/1046)
                      (field 0 y/1036)))) {0} ))
    (setfield_imm 1 (global camlCode!) f2/1034))
  (for i/1039 1 to 100 (ignore (camlCode__f2_1034  3.))) 0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__5": addr "camlCode__f2_1034" int 3)
(data int 2295 "camlCode__6": addr "camlCode__f1_1030" int 3)
(data global "camlCode__1" int 1277 "camlCode__1": double 1.)
(data global "camlCode__2" int 1277 "camlCode__2": double 1.)
(data global "camlCode__3" int 1277 "camlCode__3": double 1.)
(data global "camlCode__4" int 1277 "camlCode__4": double 3.)
(function camlCode__iter_1037 (i/1045: addr env/1050: addr)
 (catch
   (let i/1044 i/1045
     (catch
       (loop
         (catch
           (let i/1038 i/1044
             (exit 5
               (if (< i/1038 22000001)
                 (seq
                   (extcall "caml_modify" (load (+a env/1050 16))
                     (alloc 1277
                       (+f (load float64u (load (load (+a env/1050 16)))) 1.))
                     unit)
                   (exit 6 (+ i/1038 2)))
                 1a)))
         with(6 i/1043) (assign i/1044 i/1043)))
     with(10) []) 1a)
 with(5 result/1046) result/1046))

(function camlCode__f1_1030 (x/1031: addr)
 (let y/1032 x/1031
   (let i/1033 1
     (catch
       (if (> i/1033 21) (exit 9)
         (loop (assign y/1032 (alloc 1277 (+f (load float64u y/1032) 1.)))
           (let i/1054 i/1033 (assign i/1033 (+ i/1033 2))
             (if (== i/1054 21) (exit 9) []))))
     with(9) []))
   y/1032))

(function camlCode__f2_1034 (x/1035: addr)
 (let
   (y/1036 (alloc 1024 x/1035)
    iter/1037 (alloc 3319 "camlCode__iter_1037" 3 y/1036))
   (catch
     (let i/1051 1
       (catch
         (loop
           (catch
             (let i/1052 i/1051
               (exit 5
                 (if (< i/1052 22000001)
                   (seq
                     (extcall "caml_modify" (load (+a iter/1037 16))
                       (alloc 1277
                         (+f (load float64u (load (load (+a iter/1037 16))))
                           1.))
                       unit)
                     (exit 6 (+ i/1052 2)))
                   1a)))
           with(6 i/1043) (assign i/1051 i/1043)))
       with(8) []))
   with(5 result/1046) result/1046 []) (load y/1036)))

(function camlCode__entry ()
 (let f1/1030 "camlCode__6" (store "camlCode" f1/1030))
 (let f2/1034 "camlCode__5" (store (+a "camlCode" 8) f2/1034))
 (let i/1039 3
   (catch
     (if (> i/1039 201) (exit 7)
       (loop (app "camlCode__f2_1034" "camlCode__4" unit)
         (let i/1053 i/1039 (assign i/1039 (+ i/1039 2))
           (if (== i/1053 201) (exit 7) []))))
   with(7) []))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__iter_1037:
  i/32[%rbp] := i/29[%rax]
  L102:
  if i/34[%rbp] >=s 22000001 goto L103
  {env/30[%rbx]* i/34[%rbp]*}
  A/35[%rsi] := alloc 16
  [A/35[%rsi] + -8] := 1277
  A/36[%rax] := [env/30[%rbx] + 16]
  A/37[%rax] := [A/36[%rax]]
  F/38[%xmm0] := 1.
  F/39[%xmm0] := F/39[%xmm0] +f float64[A/37[%rax]]
  float64u[A/35[%rsi]] := F/39[%xmm0]
  A/40[%rdi] := [env/30[%rbx] + 16]
  {env/30[%rbx]* i/34[%rbp]*}
  extcall "caml_modify" R/2[%rdi] R/3[%rsi]
  I/41[%rbp] := I/41[%rbp] + 2
  goto L102
  L103:
  A/42[%rax] := 1
  goto L100
  L101:
  A/43[%rax] := 1
  reload retaddr
  return R/0[%rax]
  L100:
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__f1_1030:
  y/30[%rsi] := x/29[%rax]
  i/31[%rbx] := 1
  if i/31[%rbx] >s 21 goto L109
  L110:
  {y/30[%rsi]* i/31[%rbx]}
  A/32[%rdi] := alloc 16
  [A/32[%rdi] + -8] := 1277
  F/33[%xmm0] := 1.
  F/34[%xmm0] := F/34[%xmm0] +f float64[y/30[%rsi]]
  float64u[A/32[%rdi]] := F/34[%xmm0]
  y/30[%rsi] := A/32[%rdi]
  i/35[%rdi] := i/31[%rbx]
  I/36[%rbx] := I/36[%rbx] + 2
  if i/35[%rdi] !=s 21 goto L110
  L109:
  R/0[%rax] := y/30[%rsi]
  reload retaddr
  return R/0[%rax]
  
*** Linearized code
camlCode__f2_1034:
  x/29[%rbx] := R/0[%rax]
  {x/29[%rbx]*}
  y/30[%r12] := alloc 48
  [y/30[%r12] + -8] := 1024
  [y/30[%r12]] := x/29[%rbx]
  iter/31[%rbp] := y/30[%r12] + 16
  [iter/31[%rbp] + -8] := 3319
  A/32[%rax] := "camlCode__iter_1037"
  [iter/31[%rbp]] := A/32[%rax]
  [iter/31[%rbp] + 8] := 3
  [iter/31[%rbp] + 16] := y/30[%r12]
  i/34[%rbx] := 1
  L117:
  if i/36[%rbx] >=s 22000001 goto L118
  {y/30[%r12]* iter/31[%rbp]* i/36[%rbx]}
  A/37[%rsi] := alloc 16
  [A/37[%rsi] + -8] := 1277
  A/38[%rax] := [iter/31[%rbp] + 16]
  A/39[%rax] := [A/38[%rax]]
  F/40[%xmm0] := 1.
  F/41[%xmm0] := F/41[%xmm0] +f float64[A/39[%rax]]
  float64u[A/37[%rsi]] := F/41[%xmm0]
  A/42[%rdi] := [iter/31[%rbp] + 16]
  {y/30[%r12]* iter/31[%rbp]* i/36[%rbx]}
  extcall "caml_modify" R/2[%rdi] R/3[%rsi]
  I/43[%rbx] := I/43[%rbx] + 2
  goto L117
  L118:
  A/44[%rax] := 1
  L116:
  A/45[%rax] := [y/30[%r12]]
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
  if i/33[%rax] >s 201 goto L127
  spilled-i/38[s0] := i/33[%rax] (spill)
  L128:
  A/34[%rax] := "camlCode__4"
  {spilled-i/38[s0]}
  call "camlCode__f2_1034" R/0[%rax]
  i/39[%rax] := spilled-i/38[s0] (reload)
  i/35[%rbx] := i/39[%rax]
  I/36[%rax] := I/36[%rax] + 2
  spilled-i/38[s0] := i/39[%rax] (spill)
  if i/35[%rbx] !=s 201 goto L128
  L127:
  A/37[%rax] := 1
  reload retaddr
  return R/0[%rax]
  
-dstartup
	.section        .rodata.cst8,"a",@progbits
	.align	16
caml_negf_mask:	.quad   0x8000000000000000, 0
	.align	16
caml_absf_mask:	.quad   0x7FFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF
	.data
	.globl	caml_startup__data_begin
caml_startup__data_begin:
	.text
	.globl	caml_startup__code_begin
caml_startup__code_begin:
	.text
	.align	16
	.globl	caml_program
caml_program:
	subq	$8, %rsp
.L100:
	call	camlPervasives__entry@PLT
.L101:
	movq	caml_globals_inited@GOTPCREL(%rip), %rax
	addq	$1, (%rax)
	call	camlCode__entry@PLT
.L102:
	movq	caml_globals_inited@GOTPCREL(%rip), %rax
	addq	$1, (%rax)
	call	camlStd_exit__entry@PLT
.L103:
	movq	caml_globals_inited@GOTPCREL(%rip), %rax
	addq	$1, (%rax)
	movq	$1, %rax
	addq	$8, %rsp
	ret
	.type	caml_program,@function
	.size	caml_program,.-caml_program
	.text
	.align	16
	.globl	caml_curry4
caml_curry4:
	subq	$8, %rsp
.L104:
	movq	%rax, %rsi
.L105:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L106
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry4_1@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$7, 8(%rax)
	movq	caml_curry4_1_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L106:	call	caml_call_gc@PLT
.L107:	jmp	.L105
	.type	caml_curry4,@function
	.size	caml_curry4,.-caml_curry4
	.text
	.align	16
	.globl	caml_curry4_1_app
caml_curry4_1_app:
.L108:
	movq	%rax, %r10
	movq	%rbx, %r9
	movq	%rdi, %r8
	movq	32(%rsi), %rdx
	movq	24(%rsi), %rax
	movq	16(%rdx), %rcx
	movq	%r10, %rbx
	movq	%r9, %rdi
	movq	%r8, %rsi
	jmp	*%rcx
	.type	caml_curry4_1_app,@function
	.size	caml_curry4_1_app,.-caml_curry4_1_app
	.text
	.align	16
	.globl	caml_curry4_1
caml_curry4_1:
	subq	$8, %rsp
.L109:
	movq	%rax, %rsi
.L110:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L111
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry4_2@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$5, 8(%rax)
	movq	caml_curry4_2_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L111:	call	caml_call_gc@PLT
.L112:	jmp	.L110
	.type	caml_curry4_1,@function
	.size	caml_curry4_1,.-caml_curry4_1
	.text
	.align	16
	.globl	caml_curry4_2_app
caml_curry4_2_app:
.L113:
	movq	%rax, %r8
	movq	%rbx, %rsi
	movq	32(%rdi), %rax
	movq	32(%rax), %rdx
	movq	24(%rdi), %rbx
	movq	24(%rax), %rax
	movq	16(%rdx), %rcx
	movq	%r8, %rdi
	jmp	*%rcx
	.type	caml_curry4_2_app,@function
	.size	caml_curry4_2_app,.-caml_curry4_2_app
	.text
	.align	16
	.globl	caml_curry4_2
caml_curry4_2:
	subq	$8, %rsp
.L114:
	movq	%rax, %rsi
.L115:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L116
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry4_3@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L116:	call	caml_call_gc@PLT
.L117:	jmp	.L115
	.type	caml_curry4_2,@function
	.size	caml_curry4_2,.-caml_curry4_2
	.text
	.align	16
	.globl	caml_curry4_3
caml_curry4_3:
.L118:
	movq	%rax, %rsi
	movq	24(%rbx), %rcx
	movq	32(%rcx), %rax
	movq	32(%rax), %rdx
	movq	16(%rbx), %rdi
	movq	24(%rcx), %rbx
	movq	24(%rax), %rax
	movq	16(%rdx), %rcx
	jmp	*%rcx
	.type	caml_curry4_3,@function
	.size	caml_curry4_3,.-caml_curry4_3
	.text
	.align	16
	.globl	caml_curry3
caml_curry3:
	subq	$8, %rsp
.L119:
	movq	%rax, %rsi
.L120:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L121
	leaq	8(%r15), %rax
	movq	$5367, -8(%rax)
	movq	caml_curry3_1@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$5, 8(%rax)
	movq	caml_curry3_1_app@GOTPCREL(%rip), %rdi
	movq	%rdi, 16(%rax)
	movq	%rsi, 24(%rax)
	movq	%rbx, 32(%rax)
	addq	$8, %rsp
	ret
.L121:	call	caml_call_gc@PLT
.L122:	jmp	.L120
	.type	caml_curry3,@function
	.size	caml_curry3,.-caml_curry3
	.text
	.align	16
	.globl	caml_curry3_1_app
caml_curry3_1_app:
.L123:
	movq	%rax, %r8
	movq	%rbx, %rcx
	movq	32(%rdi), %rsi
	movq	24(%rdi), %rax
	movq	16(%rsi), %rdx
	movq	%r8, %rbx
	movq	%rcx, %rdi
	jmp	*%rdx
	.type	caml_curry3_1_app,@function
	.size	caml_curry3_1_app,.-caml_curry3_1_app
	.text
	.align	16
	.globl	caml_curry3_1
caml_curry3_1:
	subq	$8, %rsp
.L124:
	movq	%rax, %rsi
.L125:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L126
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry3_2@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L126:	call	caml_call_gc@PLT
.L127:	jmp	.L125
	.type	caml_curry3_1,@function
	.size	caml_curry3_1,.-caml_curry3_1
	.text
	.align	16
	.globl	caml_curry3_2
caml_curry3_2:
.L128:
	movq	%rax, %rdi
	movq	24(%rbx), %rax
	movq	32(%rax), %rsi
	movq	16(%rbx), %rbx
	movq	24(%rax), %rax
	movq	16(%rsi), %rdx
	jmp	*%rdx
	.type	caml_curry3_2,@function
	.size	caml_curry3_2,.-caml_curry3_2
	.text
	.align	16
	.globl	caml_curry2
caml_curry2:
	subq	$8, %rsp
.L129:
	movq	%rax, %rsi
.L130:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L131
	leaq	8(%r15), %rax
	movq	$4343, -8(%rax)
	movq	caml_curry2_1@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rax)
	movq	$3, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rbx, 24(%rax)
	addq	$8, %rsp
	ret
.L131:	call	caml_call_gc@PLT
.L132:	jmp	.L130
	.type	caml_curry2,@function
	.size	caml_curry2,.-caml_curry2
	.text
	.align	16
	.globl	caml_curry2_1
caml_curry2_1:
.L133:
	movq	%rax, %rdx
	movq	24(%rbx), %rdi
	movq	16(%rbx), %rax
	movq	16(%rdi), %rsi
	movq	%rdx, %rbx
	jmp	*%rsi
	.type	caml_curry2_1,@function
	.size	caml_curry2_1,.-caml_curry2_1
	.text
	.align	16
	.globl	caml_apply3
caml_apply3:
	subq	$24, %rsp
.L135:
	movq	8(%rsi), %rdx
	cmpq	$7, %rdx
	jne	.L134
	movq	16(%rsi), %rdx
	addq	$24, %rsp
	jmp	*%rdx
	.align	4
.L134:
	movq	%rdi, 8(%rsp)
	movq	%rbx, 0(%rsp)
	movq	(%rsi), %rdi
	movq	%rsi, %rbx
	call	*%rdi
.L136:
	movq	%rax, %rbx
	movq	(%rbx), %rdi
	movq	0(%rsp), %rax
	call	*%rdi
.L137:
	movq	%rax, %rbx
	movq	(%rbx), %rdi
	movq	8(%rsp), %rax
	addq	$24, %rsp
	jmp	*%rdi
	.type	caml_apply3,@function
	.size	caml_apply3,.-caml_apply3
	.text
	.align	16
	.globl	caml_apply2
caml_apply2:
	subq	$8, %rsp
.L139:
	movq	8(%rdi), %rsi
	cmpq	$5, %rsi
	jne	.L138
	movq	16(%rdi), %rsi
	addq	$8, %rsp
	jmp	*%rsi
	.align	4
.L138:
	movq	%rbx, 0(%rsp)
	movq	(%rdi), %rsi
	movq	%rdi, %rbx
	call	*%rsi
.L140:
	movq	%rax, %rbx
	movq	(%rbx), %rdi
	movq	0(%rsp), %rax
	addq	$8, %rsp
	jmp	*%rdi
	.type	caml_apply2,@function
	.size	caml_apply2,.-caml_apply2
	.data
	.globl	caml_exn_Out_of_memory
	.quad	1024
caml_exn_Out_of_memory:
	.quad	.L100001
	.quad	2300
.L100001:
	.ascii	"Out_of_memory"
	.space	2
	.byte	2
	.globl	caml_bucket_Out_of_memory
	.quad	1024
caml_bucket_Out_of_memory:
	.quad	caml_exn_Out_of_memory
	.data
	.globl	caml_exn_Sys_error
	.quad	1024
caml_exn_Sys_error:
	.quad	.L100002
	.quad	2300
.L100002:
	.ascii	"Sys_error"
	.space	6
	.byte	6
	.globl	caml_bucket_Sys_error
	.quad	1024
caml_bucket_Sys_error:
	.quad	caml_exn_Sys_error
	.data
	.globl	caml_exn_Failure
	.quad	1024
caml_exn_Failure:
	.quad	.L100003
	.quad	1276
.L100003:
	.ascii	"Failure"
	.byte	0
	.globl	caml_bucket_Failure
	.quad	1024
caml_bucket_Failure:
	.quad	caml_exn_Failure
	.data
	.globl	caml_exn_Invalid_argument
	.quad	1024
caml_exn_Invalid_argument:
	.quad	.L100004
	.quad	3324
.L100004:
	.ascii	"Invalid_argument"
	.space	7
	.byte	7
	.globl	caml_bucket_Invalid_argument
	.quad	1024
caml_bucket_Invalid_argument:
	.quad	caml_exn_Invalid_argument
	.data
	.globl	caml_exn_End_of_file
	.quad	1024
caml_exn_End_of_file:
	.quad	.L100005
	.quad	2300
.L100005:
	.ascii	"End_of_file"
	.space	4
	.byte	4
	.globl	caml_bucket_End_of_file
	.quad	1024
caml_bucket_End_of_file:
	.quad	caml_exn_End_of_file
	.data
	.globl	caml_exn_Division_by_zero
	.quad	1024
caml_exn_Division_by_zero:
	.quad	.L100006
	.quad	3324
.L100006:
	.ascii	"Division_by_zero"
	.space	7
	.byte	7
	.globl	caml_bucket_Division_by_zero
	.quad	1024
caml_bucket_Division_by_zero:
	.quad	caml_exn_Division_by_zero
	.data
	.globl	caml_exn_Not_found
	.quad	1024
caml_exn_Not_found:
	.quad	.L100007
	.quad	2300
.L100007:
	.ascii	"Not_found"
	.space	6
	.byte	6
	.globl	caml_bucket_Not_found
	.quad	1024
caml_bucket_Not_found:
	.quad	caml_exn_Not_found
	.data
	.globl	caml_exn_Match_failure
	.quad	1024
caml_exn_Match_failure:
	.quad	.L100008
	.quad	2300
.L100008:
	.ascii	"Match_failure"
	.space	2
	.byte	2
	.globl	caml_bucket_Match_failure
	.quad	1024
caml_bucket_Match_failure:
	.quad	caml_exn_Match_failure
	.data
	.globl	caml_exn_Stack_overflow
	.quad	1024
caml_exn_Stack_overflow:
	.quad	.L100009
	.quad	2300
.L100009:
	.ascii	"Stack_overflow"
	.space	1
	.byte	1
	.globl	caml_bucket_Stack_overflow
	.quad	1024
caml_bucket_Stack_overflow:
	.quad	caml_exn_Stack_overflow
	.data
	.globl	caml_exn_Sys_blocked_io
	.quad	1024
caml_exn_Sys_blocked_io:
	.quad	.L100010
	.quad	2300
.L100010:
	.ascii	"Sys_blocked_io"
	.space	1
	.byte	1
	.globl	caml_bucket_Sys_blocked_io
	.quad	1024
caml_bucket_Sys_blocked_io:
	.quad	caml_exn_Sys_blocked_io
	.data
	.globl	caml_exn_Assert_failure
	.quad	1024
caml_exn_Assert_failure:
	.quad	.L100011
	.quad	2300
.L100011:
	.ascii	"Assert_failure"
	.space	1
	.byte	1
	.globl	caml_bucket_Assert_failure
	.quad	1024
caml_bucket_Assert_failure:
	.quad	caml_exn_Assert_failure
	.data
	.globl	caml_exn_Undefined_recursive_module
	.quad	1024
caml_exn_Undefined_recursive_module:
	.quad	.L100012
	.quad	4348
.L100012:
	.ascii	"Undefined_recursive_module"
	.space	5
	.byte	5
	.globl	caml_bucket_Undefined_recursive_module
	.quad	1024
caml_bucket_Undefined_recursive_module:
	.quad	caml_exn_Undefined_recursive_module
	.data
	.globl	caml_globals
caml_globals:
	.quad	camlPervasives
	.quad	camlCode
	.quad	camlStd_exit
	.quad	0
	.data
	.globl	caml_globals_map
	.quad	21756
caml_globals_map:
	.ascii	"\204\225\246\276\0\0\0\222\0\0\0\22\0\0\0P\0\0\0A\240\300*Pervasives0\333r:\27\230\261\42\340\211\31\242\277\355\6%\24\60\63\257sH\376\305\303\221\370\322;\34\231\231\14\345\240\4\4@\240\300$Code0\207"
	.ascii	"\15\222 \27\42\177g\205}\305\214\21sM\320\60\353\0\303i\317\304\321\270p\13\61,R^\374\22\240\4\4@\240\300(Std_exit0K<u\217\27kw\366\203\3\37W\376u\277\312\60\355Q\347\35.\256\250\271\242\64lP9x\252"
	.ascii	"~\240\4\4@@"
	.space	1
	.byte	1
	.data
	.globl	caml_data_segments
caml_data_segments:
	.quad	caml_startup__data_begin
	.quad	caml_startup__data_end
	.quad	camlPervasives__data_begin
	.quad	camlPervasives__data_end
	.quad	camlCode__data_begin
	.quad	camlCode__data_end
	.quad	camlStd_exit__data_begin
	.quad	camlStd_exit__data_end
	.quad	0
	.data
	.globl	caml_code_segments
caml_code_segments:
	.quad	caml_startup__code_begin
	.quad	caml_startup__code_end
	.quad	camlPervasives__code_begin
	.quad	camlPervasives__code_end
	.quad	camlCode__code_begin
	.quad	camlCode__code_end
	.quad	camlStd_exit__code_begin
	.quad	camlStd_exit__code_end
	.quad	0
	.data
	.globl	caml_frametable
caml_frametable:
	.quad	caml_startup__frametable
	.quad	caml_system__frametable
	.quad	camlPervasives__frametable
	.quad	camlCode__frametable
	.quad	camlStd_exit__frametable
	.quad	0
	.text
	.globl	caml_startup__code_end
caml_startup__code_end:
	.data
	.globl	caml_startup__data_end
caml_startup__data_end:
	.long	0
	.globl	caml_startup__frametable
caml_startup__frametable:
	.quad	12
	.quad	.L140
	.word	16
	.word	1
	.word	0
	.align	8
	.quad	.L137
	.word	32
	.word	1
	.word	8
	.align	8
	.quad	.L136
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.quad	.L132
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L127
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L122
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L117
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L112
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L107
	.word	16
	.word	2
	.word	3
	.word	7
	.align	8
	.quad	.L103
	.word	16
	.word	0
	.align	8
	.quad	.L102
	.word	16
	.word	0
	.align	8
	.quad	.L101
	.word	16
	.word	0
	.align	8
	.section .note.GNU-stack,"",%progbits
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
.L104:
	movq	%rax, %rbp
.L102:
	cmpq	$22000001, %rbp
	jge	.L103
.L105:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L106
	leaq	8(%r15), %rsi
	movq	$1277, -8(%rsi)
	movq	16(%rbx), %rax
	movq	(%rax), %rax
	movlpd	.L108(%rip), %xmm0
	addsd	(%rax), %xmm0
	movlpd	%xmm0, (%rsi)
	movq	16(%rbx), %rdi
	call	caml_modify@PLT
	addq	$2, %rbp
	jmp	.L102
	.align	4
.L103:
	movq	$1, %rax
	jmp	.L100
	.align	4
.L101:
	movq	$1, %rax
	addq	$8, %rsp
	ret
	.align	4
.L100:
	addq	$8, %rsp
	ret
.L106:	call	caml_call_gc@PLT
.L107:	jmp	.L105
	.section	.rodata.cst8,"a",@progbits
.L108:	.quad	0x3ff0000000000000
	.type	camlCode__iter_1037,@function
	.size	camlCode__iter_1037,.-camlCode__iter_1037
	.text
	.align	16
	.globl	camlCode__f1_1030
camlCode__f1_1030:
	subq	$8, %rsp
.L111:
	movq	%rax, %rsi
	movq	$1, %rbx
	cmpq	$21, %rbx
	jg	.L109
.L110:
.L112:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L113
	leaq	8(%r15), %rdi
	movq	$1277, -8(%rdi)
	movlpd	.L115(%rip), %xmm0
	addsd	(%rsi), %xmm0
	movlpd	%xmm0, (%rdi)
	movq	%rdi, %rsi
	movq	%rbx, %rdi
	addq	$2, %rbx
	cmpq	$21, %rdi
	jne	.L110
.L109:
	movq	%rsi, %rax
	addq	$8, %rsp
	ret
.L113:	call	caml_call_gc@PLT
.L114:	jmp	.L112
	.section	.rodata.cst8,"a",@progbits
.L115:	.quad	0x3ff0000000000000
	.type	camlCode__f1_1030,@function
	.size	camlCode__f1_1030,.-camlCode__f1_1030
	.text
	.align	16
	.globl	camlCode__f2_1034
camlCode__f2_1034:
	subq	$8, %rsp
.L119:
	movq	%rax, %rbx
.L120:	subq	$48, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L121
	leaq	8(%r15), %r12
	movq	$1024, -8(%r12)
	movq	%rbx, (%r12)
	leaq	16(%r12), %rbp
	movq	$3319, -8(%rbp)
	movq	camlCode__iter_1037@GOTPCREL(%rip), %rax
	movq	%rax, (%rbp)
	movq	$3, 8(%rbp)
	movq	%r12, 16(%rbp)
	movq	$1, %rbx
.L117:
	cmpq	$22000001, %rbx
	jge	.L118
.L123:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L124
	leaq	8(%r15), %rsi
	movq	$1277, -8(%rsi)
	movq	16(%rbp), %rax
	movq	(%rax), %rax
	movlpd	.L126(%rip), %xmm0
	addsd	(%rax), %xmm0
	movlpd	%xmm0, (%rsi)
	movq	16(%rbp), %rdi
	call	caml_modify@PLT
	addq	$2, %rbx
	jmp	.L117
	.align	4
.L118:
	movq	$1, %rax
.L116:
	movq	(%r12), %rax
	addq	$8, %rsp
	ret
.L124:	call	caml_call_gc@PLT
.L125:	jmp	.L123
.L121:	call	caml_call_gc@PLT
.L122:	jmp	.L120
	.section	.rodata.cst8,"a",@progbits
.L126:	.quad	0x3ff0000000000000
	.type	camlCode__f2_1034,@function
	.size	camlCode__f2_1034,.-camlCode__f2_1034
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L129:
	movq	camlCode__6@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__5@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	$3, %rax
	cmpq	$201, %rax
	jg	.L127
	movq	%rax, 0(%rsp)
.L128:
	movq	camlCode__4@GOTPCREL(%rip), %rax
	call	camlCode__f2_1034@PLT
.L130:
	movq	0(%rsp), %rax
	movq	%rax, %rbx
	addq	$2, %rax
	movq	%rax, 0(%rsp)
	cmpq	$201, %rbx
	jne	.L128
.L127:
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
	.quad	.L130
	.word	16
	.word	0
	.align	8
	.quad	.L125
	.word	16
	.word	2
	.word	21
	.word	23
	.align	8
	.quad	.L122
	.word	16
	.word	1
	.word	3
	.align	8
	.quad	.L114
	.word	16
	.word	1
	.word	7
	.align	8
	.quad	.L107
	.word	16
	.word	2
	.word	21
	.word	3
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

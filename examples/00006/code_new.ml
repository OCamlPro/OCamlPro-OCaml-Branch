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
    if i < 11 then begin
      y := !y +. 1.;
      iter (i+1)
    end
  in
    !y

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
                  (if (< i/1038 11)
                    (seq (setfield_ptr 0 y/1036 (+. (field 0 y/1036) 1.))
                      (apply iter/1037 (+ i/1038 1)))
                    0a)))
             (field 0 y/1036)))))
    (setfield_imm 1 (global Code!) f2/1034))
  0a)
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
                  (if (< i/1038 11)
                    (seq (setfield_ptr 0 y/1036 (+. (field 0 y/1036) 1.))
                      (apply iter/1037 (+ i/1038 1)))
                    0a)))
             (field 0 y/1036)))))
    (setfield_imm 1 (global Code!) f2/1034))
  0a)
checking tailcall on iter/1037
stats_rec_removed : 1
(iter_1037) 
stats_tailcall_removed : 1
(iter_1037) 
*** After TonLambda.optimize:
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
              (function i/1043
                (let (i/1038 i/1043)
                  (catch
                    (while 1a
                      (catch
                        (exit 6
                          (if (< i/1038 11)
                            (seq
                              (setfield_ptr 0 y/1036
                                (+. (field 0 y/1036) 1.))
                              (let (arg/1041 (+ i/1038 1))
                                (seq (assign i/1038 arg/1041) (exit 5))))
                            0a))
                       with (5) 0a))
                   with (6 res/1042) res/1042))))
           (field 0 y/1036))))
    (setfield_imm 1 (global Code!) f2/1034))
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let
    (f1/1030
       (closure (camlCode__f1_1030(1)  x/1031
                  (let (y/1032[Variable] x/1031)
                    (seq (for i/1033 0 to 10 (assign y/1032 (+. y/1032 1.)))
                      y/1032))) {2} ))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let
    (f2/1034
       (closure (camlCode__f2_1034(1)  x/1035
                  (let
                    (y/1036 (makemutable 0 x/1035)
                     iter/1037
                       (closure (camlCode__iter_1037(1)  i/1043 env/1047
                                  (let (i/1038[Variable] i/1043)
                                    (catch
                                      (while 1a
                                        (catch
                                          (exit 6
                                            (if (< i/1038 11)
                                              (seq
                                                (setfield_ptr 0
                                                  (field 2 env/1047)
                                                  (+.
                                                    (field 0
                                                      (field 2 env/1047))
                                                    1.))
                                                (let (arg/1041 (+ i/1038 1))
                                                  (seq
                                                    (assign i/1038 arg/1041)
                                                    (exit 5))))
                                              0a))
                                         with (5) 0a))
                                     with (6 res/1042) res/1042))) {2} 
                                                                   y/1036))
                    (field 0 y/1036))) {2} ))
    (setfield_imm 1 (global camlCode!) f2/1034))
  0a)
*** After TonClosure.optimize:
(let
  (f1/1030
     (closure (camlCode__f1_1030(1)  x/1031
                (let (y/1032[Variable] x/1031)
                  (seq (for i/1033 0 to 10 (assign y/1032 (+. y/1032 1.)))
                    y/1032))) {2} ))
  (seq (setfield_imm 0 (global camlCode!) f1/1030)
    (let
      (f2/1034
         (closure (camlCode__f2_1034(1)  x/1035
                    (let (y/1036[Variable] x/1035) y/1036)) {2} ))
      (seq (setfield_imm 1 (global camlCode!) f2/1034) 0a))))

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__f2_1034" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f1_1030" int 3)
(function camlCode__f1_1030 (x/1031: addr)
 (let y/1032 x/1031
   (let i/1033 1
     (catch
       (if (> i/1033 21) (exit 7)
         (loop (assign y/1032 (alloc 2301 (+f (load float64u y/1032) 1.)))
           (let i/1048 i/1033 (assign i/1033 (+ i/1033 2))
             (if (== i/1048 21) (exit 7) []))))
     with(7) []))
   y/1032))

(function camlCode__f2_1034 (x/1035: addr) (let y/1036 x/1035 y/1036))

(function camlCode__entry ()
 (let f1/1030 "camlCode__2" (store "camlCode" f1/1030)
   (let f2/1034 "camlCode__1" (store (+a "camlCode" 4) f2/1034) 1a)))

(data)
-dlinear
Before simplify
camlCode__f1_1030:
                  y/9[%edx] := x/8[%eax]
                  i/10[%ebx] := 1
                  if i/10[%ebx] >s 21 goto L100
                  L101 [0]:
                  {y/9[%edx]* i/10[%ebx]}
                  A/11[%ecx] := alloc 12
                  [A/11[%ecx] + -4] := 2301
                  R/7[%tos] := 1.
                  R/7[%tos] := R/7[%tos] +f float64[y/9[%edx]]
                  float64u[A/11[%ecx]] := R/7[%tos]
                  y/9[%edx] := A/11[%ecx]
                  i/14[%ecx] := i/10[%ebx]
                  I/15[%ebx] := I/15[%ebx] + 2
                  if i/14[%ecx] !=s 21 goto L101
                  L100 [0]:
                  R/0[%eax] := y/9[%edx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f1_1030:
  y/9[%edx] := x/8[%eax]
  i/10[%ebx] := 1
  if i/10[%ebx] >s 21 goto L100
  L101 [4]:
  {y/9[%edx]* i/10[%ebx]}
  A/11[%ecx] := alloc 12
  [A/11[%ecx] + -4] := 2301
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] +f float64[y/9[%edx]]
  float64u[A/11[%ecx]] := R/7[%tos]
  y/9[%edx] := A/11[%ecx]
  i/14[%ecx] := i/10[%ebx]
  I/15[%ebx] := I/15[%ebx] + 2
  if i/14[%ecx] !=s 21 goto L101
  L100 [4]:
  R/0[%eax] := y/9[%edx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__f2_1034:
                  return R/0[%eax]
                  *** Linearized code
camlCode__f2_1034:
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
	.long	camlCode__f2_1034
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
	subl	$8, %esp
.L102:
	movl	%eax, %edx
	movl	$1, %ebx
	cmpl	$21, %ebx
	jg	.L100
.L101:
.L103:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L104
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	fld1
	faddl	(%edx)
	fstpl	(%ecx)
	movl	%ecx, %edx
	movl	%ebx, %ecx
	addl	$2, %ebx
	cmpl	$21, %ecx
	jne	.L101
.L100:
	movl	%edx, %eax
	addl	$8, %esp
	ret
.L104:	call	caml_call_gc
.L105:	jmp	.L103
	.type	camlCode__f1_1030,@function
	.size	camlCode__f1_1030,.-camlCode__f1_1030
	.text
	.align	16
	.globl	camlCode__f2_1034
camlCode__f2_1034:
.L106:
	ret
	.type	camlCode__f2_1034,@function
	.size	camlCode__f2_1034,.-camlCode__f2_1034
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L107:
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
	.long	1
	.long	.L105
	.word	12
	.word	1
	.word	7
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

let iter i n =
  let i_arg = ref i in
  let n_arg = ref n in
  let module X_return = struct exception Exn of float end in
  try
    while true do
      let module X_break = struct exception Exn end in
      try
        let i = !i_arg in
        let n = !n_arg in
        if i < float n then begin
          i_arg := i +. 1.;
          n_arg := n;
          raise X_break.Exn
        end else
          raise (X_return.Exn (1. /. i))
      with X_break.Exn -> ()
    done;
    assert false
  with X_return.Exn n -> n
(*
-drawlambda
(seq
  (let
    (iter/58
       (function i/59 n/60
         (let
           (i_arg/61 (makemutable 0 i/59)
            n_arg/62 (makemutable 0 n/60)
            X_return/64
              (let (Exn/63 (makeblock 0 "Exn")) (makeblock 0 Exn/63)))
           (try
             (seq
               (while 1a
                 (let
                   (X_break/68
                      (let (Exn/67 (makeblock 0 "Exn")) (makeblock 0 Exn/67)))
                   (try
                     (let (i/69 (field 0 i_arg/61) n/70 (field 0 n_arg/62))
                       (if (<. i/69 (float_of_int n/70))
                         (seq (setfield_ptr 0 i_arg/61 (+. i/69 1.))
                           (setfield_imm 0 n_arg/62 n/70)
                           (raise (makeblock 0 (field 0 X_break/68))))
                         (raise
                           (makeblock 0 (field 0 X_return/64) (/. 1. i/69)))))
                    with exn/74
                     (catch
                       (if (== (field 0 exn/74) (field 0 X_break/68)) 0a
                         (exit 2))
                      with (2) (raise exn/74)))))
               (raise
                 (makeblock 0 (global Assert_failure/26g)
                   [0: "code.ml" 19 4])))
            with exn/73
             (catch
               (if (== (field 0 exn/73) (field 0 X_return/64))
                 (let (n/71 (field 1 exn/73)) n/71) (exit 1))
              with (1) (raise exn/73))))))
    (setfield_imm 0 (global Code!) iter/58))
  0a)
-dlambda
(seq
  (let
    (iter/58
       (function i/59 n/60
         (let
           (i_arg/61 i/59
            n_arg/62 n/60
            X_return/64
              (let (Exn/63 (makeblock 0 "Exn")) (makeblock 0 Exn/63)))
           (try
             (seq
               (while 1a
                 (let
                   (X_break/68
                      (let (Exn/67 (makeblock 0 "Exn")) (makeblock 0 Exn/67)))
                   (try
                     (let (i/69 i_arg/61 n/70 n_arg/62)
                       (if (<. i/69 (float_of_int n/70))
                         (seq (assign i_arg/61 (+. i/69 1.))
                           (assign n_arg/62 n/70)
                           (raise (makeblock 0 (field 0 X_break/68))))
                         (raise
                           (makeblock 0 (field 0 X_return/64) (/. 1. i/69)))))
                    with exn/74
                     (if (== (field 0 exn/74) (field 0 X_break/68)) 0a
                       (raise exn/74)))))
               (raise
                 (makeblock 0 (global Assert_failure/26g)
                   [0: "code.ml" 19 4])))
            with exn/73
             (if (== (field 0 exn/73) (field 0 X_return/64)) (field 1 exn/73)
               (raise exn/73))))))
    (setfield_imm 0 (global Code!) iter/58))
  0a)

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 4)
(data
 int 3319
 "camlCode__1":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter_58")
(data
 int 3072
 "camlCode__2":
 addr L5
 int 39
 int 9
 int 2300
 L5:
 string "code.ml"
 skip 0
 byte 0)
(data int 1276 "camlCode__3": string "Exn" skip 0 byte 0)
(data int 1276 "camlCode__4": string "Exn" skip 0 byte 0)
(function camlCode__iter_58 (i/59: addr n/60: addr)
 (let
   (i_arg/61 i/59 n_arg/62 n/60
    X_return/64 (let Exn/63 (alloc 1024 "camlCode__4") (alloc 1024 Exn/63)))
   (try
     (catch
       (loop
         (let
           X_break/68
             (let Exn/67 (alloc 1024 "camlCode__3") (alloc 1024 Exn/67))
           (try
             (let (i/69 i_arg/61 n/70 n_arg/62)
               (if (<f (load float64u i/69) (floatofint (>>s n/70 1)))
                 (seq
                   (assign i_arg/61 (alloc 2301 (+f (load float64u i/69) 1.)))
                   (assign n_arg/62 n/70)
                   (raise (alloc 1024 (load X_break/68))) [])
                 (seq
                   (raise
                     (alloc 2048 (load X_return/64)
                       (alloc 2301 (/f 1. (load float64u i/69)))))
                   [])))
           with exn/74
             (if (== (load exn/74) (load X_break/68)) []
               (seq (raise exn/74) [])))))
     with(8) []) (raise (alloc 2048 "caml_exn_Assert_failure" "camlCode__2"))
   with exn/73
     (if (== (load exn/73) (load X_return/64)) (load (+a exn/73 4))
       (raise exn/73)))))

(function camlCode__entry ()
 (let iter/58 "camlCode__1" (store "camlCode" iter/58)) 1a)

(data)
-dlinear
*** Linearized code
camlCode__iter_58:
  spilled-i_arg/42[s0] := i_arg/10[%eax] (spill)
  spilled-n_arg/41[s1] := n_arg/11[%ebx] (spill)
  {spilled-n_arg/41[s1]* spilled-i_arg/42[s0]*}
  Exn/12[%ebx] := alloc 16
  [Exn/12[%ebx] + -4] := 1024
  [Exn/12[%ebx]] := "camlCode__4"
  X_return/13[%eax] := Exn/12[%ebx] + 8
  spilled-X_return/40[s2] := X_return/13[%eax] (spill)
  [X_return/13[%eax] + -4] := 1024
  [X_return/13[%eax]] := Exn/12[%ebx]
  setup trap L105
  X_return/47[%ebx] := spilled-X_return/40[s2] (reload)
  A/36[%ecx] := [X_return/47[%ebx]]
  A/37[%ebx] := [A/35[%eax]]
  if A/37[%ebx] !=s A/36[%ecx] goto L106
  A/38[%eax] := [A/35[%eax] + 4]
  reload retaddr
  return R/0[%eax]
  L106:
  raise R/0[%eax]
  L105:
  push trap
  L101:
  {spilled-X_return/40[s2]* spilled-n_arg/41[s1]* spilled-i_arg/42[s0]*}
  Exn/14[%eax] := alloc 16
  [Exn/14[%eax] + -4] := 1024
  [Exn/14[%eax]] := "camlCode__3"
  X_break/15[%ebx] := Exn/14[%eax] + 8
  spilled-X_break/39[s3] := X_break/15[%ebx] (spill)
  [X_break/15[%ebx] + -4] := 1024
  [X_break/15[%ebx]] := Exn/14[%eax]
  setup trap L104
  X_break/46[%ebx] := spilled-X_break/39[s3] (reload)
  A/32[%ecx] := [X_break/46[%ebx]]
  A/33[%ebx] := [A/31[%eax]]
  if A/33[%ebx] ==s A/32[%ecx] goto L101
  raise R/0[%eax]
  L104:
  push trap
  i_arg/43[%ecx] := spilled-i_arg/42[s0] (reload)
  n_arg/44[%edx] := spilled-n_arg/41[s1] (reload)
  I/18[%eax] := n/17[%edx]
  I/18[%eax] := I/18[%eax] >>s 1
  R/7[%tos] := floatofint I/18[%eax]
  R/7[%tos] := float64u[i/16[%ecx]]
  if not R/7[%tos] <f R/7[%tos] goto L103
  {X_break/15[%ebx]* i/16[%ecx]* n/17[%edx]* spilled-X_break/39[s3]*
   spilled-X_return/40[s2]*}
  A/21[%eax] := alloc 20
  [A/21[%eax] + -4] := 2301
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] +f float64[i/16[%ecx]]
  float64u[A/21[%eax]] := R/7[%tos]
  i_arg/43[%ecx] := A/21[%eax]
  spilled-i_arg/42[s0] := i_arg/43[%ecx] (spill)
  spilled-n_arg/41[s1] := n_arg/44[%edx] (spill)
  A/24[%eax] := A/21[%eax] + 12
  [A/24[%eax] + -4] := 1024
  A/25[%ebx] := [X_break/15[%ebx]]
  [A/24[%eax]] := A/25[%ebx]
  raise R/0[%eax]
  L103:
  {i/16[%ecx]* spilled-X_break/39[s3]* spilled-X_return/40[s2]*
   spilled-n_arg/41[s1]* spilled-i_arg/42[s0]*}
  A/26[%edx] := alloc 24
  [A/26[%edx] + -4] := 2301
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] /f float64[i/16[%ecx]]
  float64u[A/26[%edx]] := R/7[%tos]
  A/29[%eax] := A/26[%edx] + 12
  [A/29[%eax] + -4] := 2048
  X_return/45[%ebx] := spilled-X_return/40[s2] (reload)
  A/30[%ebx] := [X_return/45[%ebx]]
  [A/29[%eax]] := A/30[%ebx]
  [A/29[%eax] + 4] := A/26[%edx]
  raise R/0[%eax]
  L102:
  pop trap
  goto L101
  L100:
  {spilled-X_return/40[s2]*}
  A/34[%eax] := alloc 12
  [A/34[%eax] + -4] := 2048
  [A/34[%eax]] := "caml_exn_Assert_failure"
  [A/34[%eax] + 4] := "camlCode__2"
  raise R/0[%eax]
  pop trap
  
*** Linearized code
camlCode__entry:
  iter/8[%eax] := "camlCode__1"
  ["camlCode"] := iter/8[%eax]
  A/9[%eax] := 1
  return R/0[%eax]
  
-S
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.long	1024
	.globl	camlCode
camlCode:
	.space	4
	.data
	.long	3319
camlCode__1:
	.long	caml_curry2
	.long	5
	.long	camlCode__iter_58
	.data
	.long	3072
camlCode__2:
	.long	.L100005
	.long	39
	.long	9
	.long	2300
.L100005:
	.ascii	"code.ml"
	.byte	0
	.data
	.long	1276
camlCode__3:
	.ascii	"Exn"
	.byte	0
	.data
	.long	1276
camlCode__4:
	.ascii	"Exn"
	.byte	0
	.text
	.align	16
	.globl	camlCode__iter_58
camlCode__iter_58:
	subl	$24, %esp
.L107:
	movl	%eax, 0(%esp)
	movl	%ebx, 4(%esp)
.L108:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L109
	leal	4(%eax), %ebx
	movl	$1024, -4(%ebx)
	movl	$camlCode__4, (%ebx)
	leal	8(%ebx), %eax
	movl	%eax, 8(%esp)
	movl	$1024, -4(%eax)
	movl	%ebx, (%eax)
	call	.L105
	movl	8(%esp), %ebx
	movl	(%ebx), %ecx
	movl	(%eax), %ebx
	cmpl	%ecx, %ebx
	jne	.L106
	movl	4(%eax), %eax
	addl	$24, %esp
	ret
	.align	16
.L106:
	movl	caml_exception_pointer, %esp
	popl    caml_exception_pointer
	ret
	.align	16
.L105:
	pushl	caml_exception_pointer
	movl	%esp, caml_exception_pointer
.L101:
.L111:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L112
	leal	4(%eax), %eax
	movl	$1024, -4(%eax)
	movl	$camlCode__3, (%eax)
	leal	8(%eax), %ebx
	movl	%ebx, 20(%esp)
	movl	$1024, -4(%ebx)
	movl	%eax, (%ebx)
	call	.L104
	movl	20(%esp), %ebx
	movl	(%ebx), %ecx
	movl	(%eax), %ebx
	cmpl	%ecx, %ebx
	je	.L101
	movl	caml_exception_pointer, %esp
	popl    caml_exception_pointer
	ret
	.align	16
.L104:
	pushl	caml_exception_pointer
	movl	%esp, caml_exception_pointer
	movl	16(%esp), %ecx
	movl	20(%esp), %edx
	movl	%edx, %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fldl	(%ecx)
	fcompp
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L103
.L114:	movl	caml_young_ptr, %eax
	subl	$20, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L115
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fld1
	faddl	(%ecx)
	fstpl	(%eax)
	movl	%eax, %ecx
	movl	%ecx, 16(%esp)
	movl	%edx, 20(%esp)
	addl	$12, %eax
	movl	$1024, -4(%eax)
	movl	(%ebx), %ebx
	movl	%ebx, (%eax)
	movl	caml_exception_pointer, %esp
	popl    caml_exception_pointer
	ret
	.align	16
.L103:
.L117:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L118
	leal	4(%eax), %edx
	movl	$2301, -4(%edx)
	fld1
	fdivl	(%ecx)
	fstpl	(%edx)
	leal	12(%edx), %eax
	movl	$2048, -4(%eax)
	movl	24(%esp), %ebx
	movl	(%ebx), %ebx
	movl	%ebx, (%eax)
	movl	%edx, 4(%eax)
	movl	caml_exception_pointer, %esp
	popl    caml_exception_pointer
	ret
	.align	16
.L102:
	popl	caml_exception_pointer
	addl	$4, %esp
	jmp	.L101
	.align	16
.L100:
.L120:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L121
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	$caml_exn_Assert_failure, (%eax)
	movl	$camlCode__2, 4(%eax)
	movl	caml_exception_pointer, %esp
	popl    caml_exception_pointer
	ret
	popl	caml_exception_pointer
	addl	$4, %esp
.L121:	call	caml_call_gc
.L122:	jmp	.L120
.L118:	call	caml_call_gc
.L119:	jmp	.L117
.L115:	call	caml_call_gc
.L116:	jmp	.L114
.L112:	call	caml_call_gc
.L113:	jmp	.L111
.L109:	call	caml_call_gc
.L110:	jmp	.L108
	.type	camlCode__iter_58,@function
	.size	camlCode__iter_58,.-camlCode__iter_58
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L123:
	movl	$camlCode__1, %eax
	movl	%eax, camlCode
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
	.long	5
	.long	.L122
	.word	36
	.word	1
	.word	16
	.align	4
	.long	.L119
	.word	44
	.word	5
	.word	16
	.word	20
	.word	24
	.word	28
	.word	5
	.align	4
	.long	.L116
	.word	44
	.word	5
	.word	24
	.word	28
	.word	7
	.word	5
	.word	3
	.align	4
	.long	.L113
	.word	36
	.word	3
	.word	8
	.word	12
	.word	16
	.align	4
	.long	.L110
	.word	28
	.word	2
	.word	0
	.word	4
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

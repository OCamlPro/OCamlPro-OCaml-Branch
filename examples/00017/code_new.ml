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
    (iter/1030
       (function i/1031 n/1032
         (let
           (i_arg/1033 (makemutable 0 i/1031)
            n_arg/1034 (makemutable 0 n/1032)
            X_return/1036
              (let (Exn/1035 (makeblock 0 "Exn")) (makeblock 0 Exn/1035)))
           (try
             (seq
               (while 1a
                 (let
                   (X_break/1040
                      (let (Exn/1039 (makeblock 0 "Exn"))
                        (makeblock 0 Exn/1039)))
                   (try
                     (let
                       (i/1041 (field 0 i_arg/1033)
                        n/1042 (field 0 n_arg/1034))
                       (if (<. i/1041 (float_of_int n/1042))
                         (seq (setfield_ptr 0 i_arg/1033 (+. i/1041 1.))
                           (setfield_imm 0 n_arg/1034 n/1042)
                           (raise (makeblock 0 (field 0 X_break/1040))))
                         (raise
                           (makeblock 0 (field 0 X_return/1036)
                             (/. 1. i/1041)))))
                    with exn/1046
                     (catch
                       (if (== (field 0 exn/1046) (field 0 X_break/1040)) 0a
                         (exit 2))
                      with (2) (raise exn/1046)))))
               (raise
                 (makeblock 0 (global Assert_failure/26g)
                   [0: "code.ml" 19 4])))
            with exn/1045
             (catch
               (if (== (field 0 exn/1045) (field 0 X_return/1036))
                 (let (n/1043 (field 1 exn/1045)) n/1043) (exit 1))
              with (1) (raise exn/1045))))))
    (setfield_imm 0 (global Code!) iter/1030))
  0a)
-dlambda
(seq
  (let
    (iter/1030
       (function i/1031 n/1032
         (let
           (i_arg/1033 i/1031
            n_arg/1034 n/1032
            X_return/1036
              (let (Exn/1035 (makeblock 0 "Exn")) (makeblock 0 Exn/1035)))
           (try
             (seq
               (while 1a
                 (let
                   (X_break/1040
                      (let (Exn/1039 (makeblock 0 "Exn"))
                        (makeblock 0 Exn/1039)))
                   (try
                     (let (i/1041 i_arg/1033 n/1042 n_arg/1034)
                       (if (<. i/1041 (float_of_int n/1042))
                         (seq (assign i_arg/1033 (+. i/1041 1.))
                           (assign n_arg/1034 n/1042)
                           (raise (makeblock 0 (field 0 X_break/1040))))
                         (raise
                           (makeblock 0 (field 0 X_return/1036)
                             (/. 1. i/1041)))))
                    with exn/1046
                     (if (== (field 0 exn/1046) (field 0 X_break/1040)) 0a
                       (raise exn/1046)))))
               (raise
                 (makeblock 0 (global Assert_failure/26g)
                   [0: "code.ml" 19 4])))
            with exn/1045
             (if (== (field 0 exn/1045) (field 0 X_return/1036))
               (field 1 exn/1045) (raise exn/1045))))))
    (setfield_imm 0 (global Code!) iter/1030))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (iter/1030
       (function i/1031 n/1032
         (let
           (i_arg/1033 i/1031
            n_arg/1034 n/1032
            X_return/1036
              (let (Exn/1035 (makeblock 0 "Exn")) (makeblock 0 Exn/1035)))
           (try
             (seq
               (while 1a
                 (let
                   (X_break/1040
                      (let (Exn/1039 (makeblock 0 "Exn"))
                        (makeblock 0 Exn/1039)))
                   (try
                     (let (i/1041 i_arg/1033 n/1042 n_arg/1034)
                       (if (<. i/1041 (float_of_int n/1042))
                         (seq (assign i_arg/1033 (+. i/1041 1.))
                           (assign n_arg/1034 n/1042)
                           (raise (makeblock 0 (field 0 X_break/1040))))
                         (raise
                           (makeblock 0 (field 0 X_return/1036)
                             (/. 1. i/1041)))))
                    with exn/1046
                     (if (== (field 0 exn/1046) (field 0 X_break/1040)) 0a
                       (raise exn/1046)))))
               (raise
                 (makeblock 0 (global Assert_failure/26g)
                   [0: "code.ml" 19 4])))
            with exn/1045
             (if (== (field 0 exn/1045) (field 0 X_return/1036))
               (field 1 exn/1045) (raise exn/1045))))))
    (setfield_imm 0 (global Code!) iter/1030))
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let
    (iter/1030
       (closure (camlCode__iter_1030(2)  i/1031 n/1032
                  (let
                    (i_arg/1033[Variable] i/1031
                     n_arg/1034[Variable] n/1032
                     X_return/1036
                       (let (Exn/1035 (makeblock 0 "Exn"))
                         (makeblock 0 Exn/1035)))
                    (try
                      (seq
                        (while 1a
                          (let
                            (X_break/1040
                               (let (Exn/1039 (makeblock 0 "Exn"))
                                 (makeblock 0 Exn/1039)))
                            (try
                              (let (i/1041 i_arg/1033 n/1042 n_arg/1034)
                                (if (<. i/1041 (float_of_int n/1042))
                                  (seq (assign i_arg/1033 (+. i/1041 1.))
                                    (assign n_arg/1034 n/1042)
                                    (raise
                                      (makeblock 0 (field 0 X_break/1040))))
                                  (raise
                                    (makeblock 0 (field 0 X_return/1036)
                                      (/. 1. i/1041)))))
                             with exn/1046
                              (if
                                (== (field 0 exn/1046)
                                  (field 0 X_break/1040))
                                0a (raise exn/1046)))))
                        (raise
                          (makeblock 0 (global caml_exn_Assert_failure!)
                            [0: "code.ml" 19 4])))
                     with exn/1045
                      (if (== (field 0 exn/1045) (field 0 X_return/1036))
                        (field 1 exn/1045) (raise exn/1045))))) {3} ))
    (setfield_imm 0 (global camlCode!) iter/1030))
  0a)
*** After TonClosure.optimize:
(let
  (iter/1030
     (closure (camlCode__iter_1030(2)  i/1031 n/1032
                (let
                  (i_arg/1033[Variable] i/1031 n_arg/1034[Variable] n/1032)
                  (catch
                    (seq
                      (while 1a
                        (catch
                          (if (<. i_arg/1033 (float_of_int n_arg/1034))
                            (seq (assign i_arg/1033 (+. i_arg/1033 1.))
                              (assign n_arg/1034 n_arg/1034) (exit 8))
                            (exit 9 (/. 1. i_arg/1033)))
                         with (8) 0a))
                      (raise
                        (makeblock 0 (global caml_exn_Assert_failure!)
                          [0: "code.ml" 19 4])))
                   with (9 exn_arg/1048)
                    (let (exn/1045 (makeblock 0 0a exn_arg/1048))
                      (field 1 exn/1045))))) {3} ))
  (seq (setfield_imm 0 (global camlCode!) iter/1030) 0a))

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 4)
(data
 int 3319
 "camlCode__4":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter_1030")
(data
 global "camlCode__1"
 int 1276
 "camlCode__1":
 string "Exn"
 skip 0
 byte 0)
(data
 global "camlCode__2"
 int 1276
 "camlCode__2":
 string "Exn"
 skip 0
 byte 0)
(data
 global "camlCode__3"
 int 3072
 "camlCode__3":
 addr L5
 int 39
 int 9
 int 2300
 L5:
 string "code.ml"
 skip 0
 byte 0)
(function camlCode__iter_1030 (i/1031: addr n/1032: addr)
 (let (i_arg/1033 i/1031 n_arg/1034 n/1032)
   (catch
     (loop
       (catch
         (if (<f (load float64u i_arg/1033) (floatofint (>>s n_arg/1034 1)))
           (seq
             (assign i_arg/1033
                       (alloc 2301 (+f (load float64u i_arg/1033) 1.)))
             (assign n_arg/1034 n_arg/1034) (exit 8))
           (exit 9 (alloc 2301 (/f 1. (load float64u i_arg/1033)))))
       with(8) []))
     (raise (alloc 2048 "caml_exn_Assert_failure" "camlCode__3"))
   with(9 exn_arg/1048)
     (let exn/1045 (alloc 2048 1a exn_arg/1048) (load (+a exn/1045 4))))))

(function camlCode__entry ()
 (let iter/1030 "camlCode__4" (store "camlCode" iter/1030) 1a))

(data)
-dlinear
Before simplify
camlCode__iter_1030:
                  i_arg/10[%edx] := i/8[%eax]
                  L101 [0]:
                  I/13[%ecx] := n_arg/11[%ebx]
                  I/13[%ecx] := I/13[%ecx] >>s 1
                  R/7[%tos] := floatofint I/13[%ecx]
                  R/7[%tos] := float64u[i_arg/10[%edx]]
                  if not R/7[%tos] <f R/7[%tos] goto L102
                  {i_arg/10[%edx]* n_arg/11[%ebx]*}
                  A/16[%ecx] := alloc 12
                  [A/16[%ecx] + -4] := 2301
                  R/7[%tos] := 1.
                  R/7[%tos] := R/7[%tos] +f float64[i_arg/10[%edx]]
                  float64u[A/16[%ecx]] := R/7[%tos]
                  i_arg/10[%edx] := A/16[%ecx]
                  goto L101
                  L102 [0]:
                  {i_arg/10[%edx]*}
                  A/19[%ebx] := alloc 12
                  [A/19[%ebx] + -4] := 2301
                  R/7[%tos] := 1.
                  R/7[%tos] := R/7[%tos] /f float64[i_arg/10[%edx]]
                  float64u[A/19[%ebx]] := R/7[%tos]
                  L100 [0]:
                  {exn_arg/12[%ebx]*}
                  exn/23[%eax] := alloc 12
                  [exn/23[%eax] + -4] := 2048
                  [exn/23[%eax]] := 1
                  [exn/23[%eax] + 4] := exn_arg/12[%ebx]
                  A/24[%eax] := [exn/23[%eax] + 4]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__iter_1030:
  i_arg/10[%edx] := i/8[%eax]
  L101 [3]:
  I/13[%ecx] := n_arg/11[%ebx]
  I/13[%ecx] := I/13[%ecx] >>s 1
  R/7[%tos] := floatofint I/13[%ecx]
  R/7[%tos] := float64u[i_arg/10[%edx]]
  if not R/7[%tos] <f R/7[%tos] goto L102
  {i_arg/10[%edx]* n_arg/11[%ebx]*}
  A/16[%ecx] := alloc 12
  [A/16[%ecx] + -4] := 2301
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] +f float64[i_arg/10[%edx]]
  float64u[A/16[%ecx]] := R/7[%tos]
  i_arg/10[%edx] := A/16[%ecx]
  goto L101
  L102 [2]:
  {i_arg/10[%edx]*}
  A/19[%ebx] := alloc 12
  [A/19[%ebx] + -4] := 2301
  R/7[%tos] := 1.
  R/7[%tos] := R/7[%tos] /f float64[i_arg/10[%edx]]
  float64u[A/19[%ebx]] := R/7[%tos]
  L100 [2]:
  {exn_arg/12[%ebx]*}
  exn/23[%eax] := alloc 12
  [exn/23[%eax] + -4] := 2048
  [exn/23[%eax]] := 1
  [exn/23[%eax] + 4] := exn_arg/12[%ebx]
  A/24[%eax] := [exn/23[%eax] + 4]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  iter/8[%eax] := "camlCode__4"
                  ["camlCode"] := iter/8[%eax]
                  A/9[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  iter/8[%eax] := "camlCode__4"
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
camlCode__4:
	.long	caml_curry2
	.long	5
	.long	camlCode__iter_1030
	.data
	.globl	camlCode__1
	.long	1276
camlCode__1:
	.ascii	"Exn"
	.byte	0
	.data
	.globl	camlCode__2
	.long	1276
camlCode__2:
	.ascii	"Exn"
	.byte	0
	.data
	.globl	camlCode__3
	.long	3072
camlCode__3:
	.long	.L100005
	.long	39
	.long	9
	.long	2300
.L100005:
	.ascii	"code.ml"
	.byte	0
	.text
	.align	16
	.globl	camlCode__iter_1030
camlCode__iter_1030:
	subl	$8, %esp
.L103:
	movl	%eax, %edx
.L101:
	movl	%ebx, %ecx
	sarl	$1, %ecx
	pushl	%ecx
	fildl	(%esp)
	addl	$4, %esp
	fldl	(%edx)
	fcompp
	fnstsw	%ax
	andb	$69, %ah
	cmpb	$1, %ah
	jne	.L102
.L104:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L105
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	fld1
	faddl	(%edx)
	fstpl	(%ecx)
	movl	%ecx, %edx
	jmp	.L101
	.align	16
.L102:
.L107:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L108
	leal	4(%eax), %ebx
	movl	$2301, -4(%ebx)
	fld1
	fdivl	(%edx)
	fstpl	(%ebx)
.L100:
.L110:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L111
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	$1, (%eax)
	movl	%ebx, 4(%eax)
	movl	4(%eax), %eax
	addl	$8, %esp
	ret
.L111:	call	caml_call_gc
.L112:	jmp	.L110
.L108:	call	caml_call_gc
.L109:	jmp	.L107
.L105:	call	caml_call_gc
.L106:	jmp	.L104
	.type	camlCode__iter_1030,@function
	.size	camlCode__iter_1030,.-camlCode__iter_1030
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L113:
	movl	$camlCode__4, %eax
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
	.long	3
	.long	.L112
	.word	12
	.word	1
	.word	3
	.align	4
	.long	.L109
	.word	12
	.word	1
	.word	7
	.align	4
	.long	.L106
	.word	12
	.word	2
	.word	3
	.word	7
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

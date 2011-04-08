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
lambda saved
typedtree saved
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
 After TonLambda.optimize (0 eliminations): 
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
lambda saved
typedtree saved
-dclosure
(seq
  (let
    (iter/1030
       (closure (camlCode__iter_1030(2)  i/1031 n/1032
                 (let
                   (i_arg/1033 i/1031
                    n_arg/1034 n/1032
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
                               (== (field 0 exn/1046) (field 0 X_break/1040))
                               0a (raise exn/1046)))))
                       (raise
                         (makeblock 0 (global caml_exn_Assert_failure!)
                           [0: "code.ml" 19 4])))
                    with exn/1045
                     (if (== (field 0 exn/1045) (field 0 X_return/1036))
                       (field 1 exn/1045) (raise exn/1045))))) ))
    (setfield_imm 0 (global camlCode!) iter/1030))
  0a)(seq
       (let
         (iter/1030
            (closure (camlCode__iter_1030(2)  i/1031 n/1032
                      (let
                        (i_arg/1033 i/1031
                         n_arg/1034 n/1032
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
                                          (makeblock 0
                                            (field 0 X_break/1040))))
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
                            (field 1 exn/1045) (raise exn/1045))))) ))
         (setfield_imm 0 (global camlCode!) iter/1030))lambda saved
typedtree saved

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 8)
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
 skip 4
 byte 4)
(data
 global "camlCode__2"
 int 1276
 "camlCode__2":
 string "Exn"
 skip 4
 byte 4)
(data
 global "camlCode__3"
 int 3072
 "camlCode__3":
 addr L5
 int 39
 int 9
 int 1276
 L5:
 string "code.ml"
 skip 0
 byte 0)
(function camlCode__iter_1030 (i/1031: addr n/1032: addr)
 (let
   (i_arg/1033 i/1031 n_arg/1034 n/1032
    X_return/1036
      (let Exn/1035 (alloc 1024 "camlCode__1") (alloc 1024 Exn/1035)))
   (try
     (catch
       (loop
         (let
           X_break/1040
             (let Exn/1039 (alloc 1024 "camlCode__2") (alloc 1024 Exn/1039))
           (try
             (let (i/1041 i_arg/1033 n/1042 n_arg/1034)
               (if (<f (load float64u i/1041) (floatofint (>>s n/1042 1)))
                 (seq
                   (assign i_arg/1033
                             (alloc 1277 (+f (load float64u i/1041) 1.)))
                   (assign n_arg/1034 n/1042)
                   (raise (alloc 1024 (load X_break/1040))) [])
                 (seq
                   (raise
                     (alloc 2048 (load X_return/1036)
                       (alloc 1277 (/f 1. (load float64u i/1041)))))
                   [])))
           with exn/1046
             (if (== (load exn/1046) (load X_break/1040)) []
               (seq (raise exn/1046) [])))))
     with(8) []) (raise (alloc 2048 "caml_exn_Assert_failure" "camlCode__3"))
   with exn/1045
     (if (== (load exn/1045) (load X_return/1036)) (load (+a exn/1045 8))
       (raise exn/1045)))))

(function camlCode__entry ()
 (let iter/1030 "camlCode__4" (store "camlCode" iter/1030)) 1a)

(data)
lambda saved
typedtree saved
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
	.quad	1024
	.globl	camlCode
camlCode:
	.space	8
	.data
	.quad	3319
camlCode__4:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__iter_1030
	.data
	.globl	camlCode__1
	.quad	1276
camlCode__1:
	.ascii	"Exn"
	.space	4
	.byte	4
	.data
	.globl	camlCode__2
	.quad	1276
camlCode__2:
	.ascii	"Exn"
	.space	4
	.byte	4
	.data
	.globl	camlCode__3
	.quad	3072
camlCode__3:
	.quad	.L100005
	.quad	39
	.quad	9
	.quad	1276
.L100005:
	.ascii	"code.ml"
	.byte	0
	.text
	.align	16
	.globl	camlCode__iter_1030
camlCode__iter_1030:
	subq	$40, %rsp
.L107:
	movq	%rax, 0(%rsp)
	movq	%rbx, 8(%rsp)
.L108:	subq	$32, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L109
	leaq	8(%r15), %rbx
	movq	$1024, -8(%rbx)
	movq	camlCode__1@GOTPCREL(%rip), %rax
	movq	%rax, (%rbx)
	leaq	16(%rbx), %rax
	movq	%rax, 16(%rsp)
	movq	$1024, -8(%rax)
	movq	%rbx, (%rax)
	call	.L105
	movq	16(%rsp), %rbx
	movq	(%rbx), %rdi
	movq	(%rax), %rbx
	cmpq	%rdi, %rbx
	jne	.L106
	movq	8(%rax), %rax
	addq	$40, %rsp
	ret
	.align	4
.L106:
	movq	%r14, %rsp
	popq	%r14
	ret
	.align	4
.L105:
	pushq	%r14
	movq	%rsp, %r14
.L101:
.L111:	subq	$32, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L112
	leaq	8(%r15), %rbx
	movq	$1024, -8(%rbx)
	movq	camlCode__2@GOTPCREL(%rip), %rax
	movq	%rax, (%rbx)
	leaq	16(%rbx), %rsi
	movq	%rsi, 40(%rsp)
	movq	$1024, -8(%rsi)
	movq	%rbx, (%rsi)
	call	.L104
	movq	40(%rsp), %rbx
	movq	(%rbx), %rdi
	movq	(%rax), %rbx
	cmpq	%rdi, %rbx
	je	.L101
	movq	%r14, %rsp
	popq	%r14
	ret
	.align	4
.L104:
	pushq	%r14
	movq	%rsp, %r14
	movq	32(%rsp), %rdi
	movq	40(%rsp), %rbx
	movq	%rbx, %rax
	sarq	$1, %rax
	cvtsi2sdq	%rax, %xmm1
	movlpd	(%rdi), %xmm0
 comisd	%xmm0, %xmm1
	jbe	.L103
.L114:	subq	$32, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L115
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	movlpd	.L117(%rip), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rax)
	movq	%rax, %rdi
	movq	%rdi, 32(%rsp)
	movq	%rbx, 40(%rsp)
	addq	$16, %rax
	movq	$1024, -8(%rax)
	movq	(%rsi), %rbx
	movq	%rbx, (%rax)
	movq	%r14, %rsp
	popq	%r14
	ret
	.align	4
.L103:
.L118:	subq	$40, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L119
	leaq	8(%r15), %rsi
	movq	$1277, -8(%rsi)
	movlpd	.L121(%rip), %xmm0
	divsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rsi)
	leaq	16(%rsi), %rax
	movq	$2048, -8(%rax)
	movq	48(%rsp), %rbx
	movq	(%rbx), %rbx
	movq	%rbx, (%rax)
	movq	%rsi, 8(%rax)
	movq	%r14, %rsp
	popq	%r14
	ret
	.align	4
.L102:
	popq	%r14
	addq	$8, %rsp
	jmp	.L101
	.align	4
.L100:
.L122:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L123
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	caml_exn_Assert_failure@GOTPCREL(%rip), %rbx
	movq	%rbx, (%rax)
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	%rbx, 8(%rax)
	movq	%r14, %rsp
	popq	%r14
	ret
	popq	%r14
	addq	$8, %rsp
.L123:	call	caml_call_gc@PLT
.L124:	jmp	.L122
.L119:	call	caml_call_gc@PLT
.L120:	jmp	.L118
.L115:	call	caml_call_gc@PLT
.L116:	jmp	.L114
.L112:	call	caml_call_gc@PLT
.L113:	jmp	.L111
.L109:	call	caml_call_gc@PLT
.L110:	jmp	.L108
	.section	.rodata.cst8,"a",@progbits
.L121:	.quad	0x3ff0000000000000
.L117:	.quad	0x3ff0000000000000
	.type	camlCode__iter_1030,@function
	.size	camlCode__iter_1030,.-camlCode__iter_1030
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L125:
	movq	camlCode__4@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	$1, %rax
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
	.quad	.L124
	.word	64
	.word	1
	.word	32
	.align	8
	.quad	.L120
	.word	80
	.word	5
	.word	32
	.word	40
	.word	48
	.word	56
	.word	5
	.align	8
	.quad	.L116
	.word	80
	.word	5
	.word	48
	.word	56
	.word	3
	.word	5
	.word	7
	.align	8
	.quad	.L113
	.word	64
	.word	3
	.word	16
	.word	24
	.word	32
	.align	8
	.quad	.L110
	.word	48
	.word	2
	.word	0
	.word	8
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

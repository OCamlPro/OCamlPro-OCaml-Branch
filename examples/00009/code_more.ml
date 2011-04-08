(* This example shows that references can be translated to variables when
not appearing in a closure or as argument. Even simple float records are
translated. However, in the latter case, on x86, the removed reference is
translated back to equivalent code. *)

let f1 n =
  let r = ref n in
    for i = 0 to 10 do incr r done;
    !r

type float_ref = { mutable float : float }

let f2 n =
  let r = { float = n } in
    for i = 0 to 10 do r.float <- r.float +. 1. done;
    r.float
(*
-drawlambda
(seq
  (let
    (f1/1030
       (function n/1031
         (let (r/1032 (makemutable 0 n/1031))
           (seq (for i/1033 0 to 10 (+:=1 r/1032)) (field 0 r/1032)))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1037
       (function n/1038
         (let (r/1039 (makearray  n/1038))
           (seq
             (for i/1040 0 to 10
               (setfloatfield 0 r/1039 (+. (floatfield 0 r/1039) 1.)))
             (floatfield 0 r/1039)))))
    (setfield_imm 1 (global Code!) f2/1037))
  0a)
lambda saved
typedtree saved
-dlambda
(seq
  (let
    (f1/1030
       (function n/1031
         (let (r/1032 n/1031)
           (seq (for i/1033 0 to 10 (assign r/1032 (1+ r/1032))) r/1032))))
    (setfield_imm 0 (global Code!) f1/1030))
  (let
    (f2/1037
       (function n/1038
         (let (r/1039 (makearray  n/1038))
           (seq
             (for i/1040 0 to 10
               (setfloatfield 0 r/1039 (+. (floatfield 0 r/1039) 1.)))
             (floatfield 0 r/1039)))))
    (setfield_imm 1 (global Code!) f2/1037))
  0a)
 After TonLambda.optimize (0 eliminations): 
 (seq
   (let
     (f1/1030
        (function n/1031
          (let (r/1032 n/1031)
            (seq (for i/1033 0 to 10 (assign r/1032 (1+ r/1032))) r/1032))))
     (setfield_imm 0 (global Code!) f1/1030))
   (let
     (f2/1037
        (function n/1038
          (let (r/1039 (makearray  n/1038))
            (seq
              (for i/1040 0 to 10
                (setfloatfield 0 r/1039 (+. (floatfield 0 r/1039) 1.)))
              (floatfield 0 r/1039)))))
     (setfield_imm 1 (global Code!) f2/1037))
   0a)
lambda saved
typedtree saved
-dclosure
(seq
  (let
    (f1/1030
       (closure (camlCode__f1_1030(1)  n/1031
                 (let (r/1032 n/1031)
                   (seq (for i/1033 0 to 10 (assign r/1032 (1+ r/1032)))
                     r/1032))) ))
    (setfield_imm 0 (global camlCode!) f1/1030))
  (let
    (f2/1037
       (closure (camlCode__f2_1037(1)  n/1038
                 (let (r/1039 (makearray  n/1038))
                   (seq
                     (for i/1040 0 to 10
                       (setfloatfield 0 r/1039 (+. (floatfield 0 r/1039) 1.)))
                     (floatfield 0 r/1039)))) ))
    (setfield_imm 1 (global camlCode!) f2/1037))
  0a)(seq
       (let
         (f1/1030
            (closure (camlCode__f1_1030(1)  n/1031
                      (let (r/1032 n/1031)
                        (seq (for i/1033 0 to 10 (assign r/1032 (1+ r/1032)))
                          r/1032))) ))
         (setfield_imm 0 (global camlCode!) f1/1030))
       (let
         (f2/1037
            (closure (camlCode__f2_1037(1)  n/1038
                      (let (r/1039 (makearray  n/1038))
                        (seq
                          (for i/1040 0 to 10
                            (setfloatfield 0 r/1039
                              (+. (floatfield 0 r/1039) 1.)))
                          (floatfield 0 r/1039)))) ))
         (setfield_imm 1 (global camlCode!) f2/1037))lambda saved
typedtree saved

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__1": addr "camlCode__f2_1037" int 3)
(data int 2295 "camlCode__2": addr "camlCode__f1_1030" int 3)
(function camlCode__f1_1030 (n/1031: addr)
 (let r/1032 n/1031
   (let i/1033 1
     (catch
       (if (> i/1033 21) (exit 6)
         (loop (assign r/1032 (+ r/1032 2))
           (let i/1049 i/1033 (assign i/1033 (+ i/1033 2))
             (if (== i/1049 21) (exit 6) []))))
     with(6) []))
   r/1032))

(function camlCode__f2_1037 (n/1038: addr)
 (let r/1039 (alloc 1278 (load float64u n/1038))
   (let i/1040 1
     (catch
       (if (> i/1040 21) (exit 5)
         (loop (store float64u r/1039 (+f (load float64u r/1039) 1.))
           (let i/1048 i/1040 (assign i/1040 (+ i/1040 2))
             (if (== i/1048 21) (exit 5) []))))
     with(5) []))
   (alloc 1277 (load float64u r/1039))))

(function camlCode__entry ()
 (let f1/1030 "camlCode__2" (store "camlCode" f1/1030))
 (let f2/1037 "camlCode__1" (store (+a "camlCode" 8) f2/1037)) 1a)

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
	.quad	2048
	.globl	camlCode
camlCode:
	.space	16
	.data
	.quad	2295
camlCode__1:
	.quad	camlCode__f2_1037
	.quad	3
	.data
	.quad	2295
camlCode__2:
	.quad	camlCode__f1_1030
	.quad	3
	.text
	.align	16
	.globl	camlCode__f1_1030
camlCode__f1_1030:
.L102:
	movq	$1, %rbx
	cmpq	$21, %rbx
	jg	.L100
.L101:
	addq	$2, %rax
	movq	%rbx, %rdi
	addq	$2, %rbx
	cmpq	$21, %rdi
	jne	.L101
.L100:
	ret
	.type	camlCode__f1_1030,@function
	.size	camlCode__f1_1030,.-camlCode__f1_1030
	.text
	.align	16
	.globl	camlCode__f2_1037
camlCode__f2_1037:
	subq	$8, %rsp
.L105:
	movq	%rax, %rbx
.L106:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L107
	leaq	8(%r15), %rdi
	movq	$1278, -8(%rdi)
	movlpd	(%rbx), %xmm0
	movlpd	%xmm0, (%rdi)
	movq	$1, %rax
	cmpq	$21, %rax
	jg	.L103
.L104:
	movlpd	.L109(%rip), %xmm0
	addsd	(%rdi), %xmm0
	movlpd	%xmm0, (%rdi)
	movq	%rax, %rbx
	addq	$2, %rax
	cmpq	$21, %rbx
	jne	.L104
.L103:
.L110:	subq	$16, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L111
	leaq	8(%r15), %rax
	movq	$1277, -8(%rax)
	movlpd	(%rdi), %xmm0
	movlpd	%xmm0, (%rax)
	addq	$8, %rsp
	ret
.L111:	call	caml_call_gc@PLT
.L112:	jmp	.L110
.L107:	call	caml_call_gc@PLT
.L108:	jmp	.L106
	.section	.rodata.cst8,"a",@progbits
.L109:	.quad	0x3ff0000000000000
	.type	camlCode__f2_1037,@function
	.size	camlCode__f2_1037,.-camlCode__f2_1037
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L113:
	movq	camlCode__2@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
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
	.quad	2
	.quad	.L112
	.word	16
	.word	1
	.word	5
	.align	8
	.quad	.L108
	.word	16
	.word	1
	.word	3
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

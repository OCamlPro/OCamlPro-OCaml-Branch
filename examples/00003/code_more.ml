
let _ =
  let x = 1 in
  let y = x + 1 in
  let z = y + 2 in
    z
(*
-drawlambda:
  (seq (let (x/58 1 y/59 (+ x/58 1) z/60 (+ y/59 2)) z/60) 0a)

-dlambda:
  (seq (let (x/58 1 y/59 (+ x/58 1) z/60 (+ y/59 2)) z/60) 0a)

-dclosure:
(seq 4 0a)

-dcmm:
(data int 0 global "camlCode" "camlCode": skip 0)
(function camlCode__entry () 9 [] 1a)

(data)

*)

(*
-drawlambda
(seq (let (x/1030 1 y/1031 (+ x/1030 1) z/1032 (+ y/1031 2)) z/1032) 0a)
lambda saved
typedtree saved
-dlambda
(seq (let (x/1030 1 y/1031 (+ x/1030 1) z/1032 (+ y/1031 2)) z/1032) 0a)
 After TonLambda.optimize (0 eliminations): 
 (seq (let (x/1030 1 y/1031 (+ x/1030 1) z/1032 (+ y/1031 2)) z/1032) 0a)
lambda saved
typedtree saved
-dclosure
lambda saved
typedtree saved

-dcmm
(data int 0 global "camlCode" "camlCode": skip 0)
(function camlCode__entry () 9 [] 1a)

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
	.quad	0
	.globl	camlCode
camlCode:
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L100:
	movq	$9, %rax
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
	.quad	0
	.section .note.GNU-stack,"",%progbits
*)

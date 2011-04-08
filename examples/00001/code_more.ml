(* Useless variable aliases are removed between rawlambda and lambda
   (simplif.ml) *)

let _ =
  let f x =
    let y = x in
      y
  in
    ()
(*
-drawlambda
File "code.ml", line 5, characters 6-7:
Warning 26: unused variable f.
(seq (let (f/1030 (function x/1031 (let (y/1032 x/1031) y/1032))) 0a) 0a)
lambda saved
typedtree saved
-dlambda
File "code.ml", line 5, characters 6-7:
Warning 26: unused variable f.
(seq (let (f/1030 (function x/1031 x/1031)) 0a) 0a)
 After TonLambda.optimize (0 eliminations): 
 (seq (let (f/1030 (function x/1031 x/1031)) 0a) 0a)
lambda saved
typedtree saved
-dclosure
File "code.ml", line 5, characters 6-7:
Warning 26: unused variable f.
(seq (let (f/1030 (closure (camlCode__f_1030(1)  x/1031 x/1031) )) 0a) 0a)
(seq (let (f/1030 (closure (camlCode__f_1030(1)  x/1031 x/1031) )) 0a)lambda saved
typedtree saved

-dcmm
File "code.ml", line 5, characters 6-7:
Warning 26: unused variable f.
(data int 0 global "camlCode" "camlCode": skip 0)
(data int 2295 "camlCode__1": addr "camlCode__f_1030" int 3)
(function camlCode__f_1030 (x/1031: addr) x/1031)

(function camlCode__entry () (let f/1030 "camlCode__1" []) 1a)

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
	.data
	.quad	2295
camlCode__1:
	.quad	camlCode__f_1030
	.quad	3
	.text
	.align	16
	.globl	camlCode__f_1030
camlCode__f_1030:
.L100:
	ret
	.type	camlCode__f_1030,@function
	.size	camlCode__f_1030,.-camlCode__f_1030
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L101:
	movq	camlCode__1@GOTPCREL(%rip), %rax
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

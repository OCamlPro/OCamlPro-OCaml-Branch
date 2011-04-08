
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
-dlambda
(seq (let (x/1030 1 y/1031 (+ x/1030 1) z/1032 (+ y/1031 2)) z/1032) 0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq (let (x/1030 1 y/1031 (+ x/1030 1) z/1032 (+ y/1031 2)) z/1032) 0a)
-dclosure
*** After Closure.intro:
(seq 4 0a)
*** After TonClosure.optimize:
(seq 4 0a)

-dcmm
(data int 0 global "camlCode" "camlCode": skip 0)
(function camlCode__entry () 9 [] 1a)

(data)
-dlinear
Before simplify
camlCode__entry:
                  I/8[%eax] := 9
                  A/9[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  I/8[%eax] := 9
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
	.long	0
	.globl	camlCode
camlCode:
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L100:
	movl	$9, %eax
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
	.long	0

	.section .note.GNU-stack,"",%progbits
*)

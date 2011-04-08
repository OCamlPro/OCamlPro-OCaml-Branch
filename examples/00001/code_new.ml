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
-dlambda
File "code.ml", line 5, characters 6-7:
Warning 26: unused variable f.
(seq (let (f/1030 (function x/1031 x/1031)) 0a) 0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq (let (f/1030 (function x/1031 x/1031)) 0a) 0a)
-dclosure
File "code.ml", line 5, characters 6-7:
Warning 26: unused variable f.
*** After Closure.intro:
(seq (let (f/1030 (closure (camlCode__f_1030(1)  x/1031 x/1031) {2} )) 0a)
  0a)
*** After TonClosure.optimize:
(seq 0a 0a)

-dcmm
File "code.ml", line 5, characters 6-7:
Warning 26: unused variable f.
(data int 0 global "camlCode" "camlCode": skip 0)
(function camlCode__entry () [] 1a)

(data)
-dlinear
File "code.ml", line 5, characters 6-7:
Warning 26: unused variable f.
Before simplify
camlCode__entry:
                  A/8[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  A/8[%eax] := 1
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

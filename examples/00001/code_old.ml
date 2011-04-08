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
Warning Y: unused variable f.
(seq (let (f/58 (function x/59 (let (y/60 x/59) y/60))) 0a) 0a)
-dlambda
File "code.ml", line 5, characters 6-7:
Warning Y: unused variable f.
(seq (let (f/58 (function x/59 x/59)) 0a) 0a)

-dcmm
File "code.ml", line 5, characters 6-7:
Warning Y: unused variable f.
(data int 0 global "camlCode" "camlCode": skip 0)
(data int 2295 "camlCode__1": addr "camlCode__f_58" int 3)
(function camlCode__f_58 (x/59: addr) x/59)

(function camlCode__entry () (let f/58 "camlCode__1" []) 1a)

(data)
-dlinear
File "code.ml", line 5, characters 6-7:
Warning Y: unused variable f.
*** Linearized code
camlCode__f_58:
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  f/8[%eax] := "camlCode__1"
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
	.data
	.long	2295
camlCode__1:
	.long	camlCode__f_58
	.long	3
	.text
	.align	16
	.globl	camlCode__f_58
camlCode__f_58:
.L100:
	ret
	.type	camlCode__f_58,@function
	.size	camlCode__f_58,.-camlCode__f_58
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L101:
	movl	$camlCode__1, %eax
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

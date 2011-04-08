
let f x =
  let a = (1,x) in
  let b = (2,x) in
  let c = (a,b) in
  (a,b,c)
  (*
-drawlambda
(seq
  (let
    (f/1031
       (function x/1032
         (let
           (a/1033 (makeblock 0 1 x/1032)
            b/1034 (makeblock 0 2 x/1032)
            c/1035 (makeblock 0 a/1033 b/1034))
           (makeblock 0 a/1033 b/1034 c/1035))))
    (setfield_imm 0 (global Code!) f/1031))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dlambda
(seq
  (let
    (f/1031
       (function x/1032
         (let
           (a/1033 (makeblock 0 1 x/1032)
            b/1034 (makeblock 0 2 x/1032)
            c/1035 (makeblock 0 a/1033 b/1034))
           (makeblock 0 a/1033 b/1034 c/1035))))
    (setfield_imm 0 (global Code!) f/1031))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

stats_rec_removed : 0

stats_tailcall_removed : 0

pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dlambda2
*** After TonLambda.optimize:
(seq
  (let
    (f/1031
       (function x/1032
         (let
           (a/1033 (makeblock 0 1 x/1032)
            b/1034 (makeblock 0 2 x/1032)
            c/1035 (makeblock 0 a/1033 b/1034))
           (makeblock 0 a/1033 b/1034 c/1035))))
    (setfield_imm 0 (global Code!) f/1031))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dclosure
*** After Closure.intro:
(seq
  (let
    (f/1031
       (closure (camlCode__f_1031(1)  x/1032
                  (let
                    (a/1033 (makeblock 0 1 x/1032)
                     b/1034 (makeblock 0 2 x/1032)
                     c/1035 (makeblock 0 a/1033 b/1034))
                    (makeblock 0 a/1033 b/1034 c/1035))) {2} ))
    (setfield_imm 0 (global camlCode!) f/1031))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dclosure2
pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
*** After TonClosure.optimize:
(let (f/1031 (closure (camlCode__f_1031(1)  x/1032 (let (a/1033 (makeblock 0 1 x/1032) b/1034 (makeblock 0 2 x/1032) c/1035 (makeblock 0 a/1033 b/1034)) (makeblock 0 a/1033 b/1034 c/1035))) {2} ) temp/1038 (global camlCode!)) (seq (setfield_imm 0 temp/1038 f/1031) 0a))
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed

-dcmm
pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
(data int 1024 global "camlCode" "camlCode": skip 4)
(data int 2295 "camlCode__1": addr "camlCode__f_1031" int 3)
(function camlCode__f_1031 (x/1032: addr) (let (a/1033 (let temp/1042 3 (alloc[0] 2048 temp/1042 x/1032)) b/1034 (let temp/1041 5 (alloc[0] 2048 temp/1041 x/1032)) c/1035 (alloc[0] 2048 a/1033 b/1034)) (alloc[0] 3072 a/1033 b/1034 c/1035)))

(function camlCode__entry () (let (f/1031 "camlCode__1" temp/1038 "camlCode") (store temp/1038 f/1031) 1a))

(data)
-dlinear
pp_get_margin 78
pp_get_max_indent 68
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1031 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Before simplify
camlCode__f_1031:
                  x/8[%esi] := R/0[%eax]
                  temp/9[%ebx] := 3
                  {x/8[%esi]* temp/9[%ebx]}
                  a/10[%edx] := alloc 52
                  [a/10[%edx] + -4] := 2048
                  [a/10[%edx]] := temp/9[%ebx]
                  [a/10[%edx] + 4] := x/8[%esi]
                  temp/11[%eax] := 5
                  b/12[%ecx] := a/10[%edx] + 12
                  [b/12[%ecx] + -4] := 2048
                  [b/12[%ecx]] := temp/11[%eax]
                  [b/12[%ecx] + 4] := x/8[%esi]
                  c/13[%ebx] := a/10[%edx] + 24
                  [c/13[%ebx] + -4] := 2048
                  [c/13[%ebx]] := a/10[%edx]
                  [c/13[%ebx] + 4] := b/12[%ecx]
                  A/14[%eax] := a/10[%edx] + 36
                  [A/14[%eax] + -4] := 3072
                  [A/14[%eax]] := a/10[%edx]
                  [A/14[%eax] + 4] := b/12[%ecx]
                  [A/14[%eax] + 8] := c/13[%ebx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f_1031:
  x/8[%esi] := R/0[%eax]
  temp/9[%ebx] := 3
  {x/8[%esi]* temp/9[%ebx]}
  a/10[%edx] := alloc 52
  [a/10[%edx] + -4] := 2048
  [a/10[%edx]] := temp/9[%ebx]
  [a/10[%edx] + 4] := x/8[%esi]
  temp/11[%eax] := 5
  b/12[%ecx] := a/10[%edx] + 12
  [b/12[%ecx] + -4] := 2048
  [b/12[%ecx]] := temp/11[%eax]
  [b/12[%ecx] + 4] := x/8[%esi]
  c/13[%ebx] := a/10[%edx] + 24
  [c/13[%ebx] + -4] := 2048
  [c/13[%ebx]] := a/10[%edx]
  [c/13[%ebx] + 4] := b/12[%ecx]
  A/14[%eax] := a/10[%edx] + 36
  [A/14[%eax] + -4] := 3072
  [A/14[%eax]] := a/10[%edx]
  [A/14[%eax] + 4] := b/12[%ecx]
  [A/14[%eax] + 8] := c/13[%ebx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  f/8[%ebx] := "camlCode__1"
                  temp/9[%eax] := "camlCode"
                  [temp/9[%eax]] := f/8[%ebx]
                  A/10[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  f/8[%ebx] := "camlCode__1"
  temp/9[%eax] := "camlCode"
  [temp/9[%eax]] := f/8[%ebx]
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
	.long	1024
	.globl	camlCode
camlCode:
	.space	4
	.data
	.long	2295
camlCode__1:
	.long	camlCode__f_1031
	.long	3
	.text
	.align	16
	.globl	camlCode__f_1031
camlCode__f_1031:
.L100:
	movl	%eax, %esi
	movl	$3, %ebx
.L101:	movl	caml_young_ptr, %eax
	subl	$52, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L102
	leal	4(%eax), %edx
	movl	$2048, -4(%edx)
	movl	%ebx, (%edx)
	movl	%esi, 4(%edx)
	movl	$5, %eax
	leal	12(%edx), %ecx
	movl	$2048, -4(%ecx)
	movl	%eax, (%ecx)
	movl	%esi, 4(%ecx)
	leal	24(%edx), %ebx
	movl	$2048, -4(%ebx)
	movl	%edx, (%ebx)
	movl	%ecx, 4(%ebx)
	leal	36(%edx), %eax
	movl	$3072, -4(%eax)
	movl	%edx, (%eax)
	movl	%ecx, 4(%eax)
	movl	%ebx, 8(%eax)
	ret
.L102:	call	caml_call_gc
.L103:	jmp	.L101
	.type	camlCode__f_1031,@function
	.size	camlCode__f_1031,.-camlCode__f_1031
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L104:
	movl	$camlCode__1, %ebx
	movl	$camlCode, %eax
	movl	%ebx, (%eax)
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
	.long	.L103
	.word	4
	.word	1
	.word	9
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

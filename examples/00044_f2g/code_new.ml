(* All these allocations are combined into just one allocation. *)

type t

let rec f x y = (x,y)
let rec g y = f y (y,y)
  (*
-drawlambda
(seq
  (letrec (f/1032 (function x/1033 y/1034 (makeblock 0 x/1033 y/1034)))
    (setfield_imm 0 (global Code!) f/1032))
  (letrec
    (g/1035
       (function y/1036
         (apply (field 0 (global Code!)) y/1036 (makeblock 0 y/1036 y/1036))))
    (setfield_imm 1 (global Code!) g/1035))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dlambda
(seq
  (letrec (f/1032 (function x/1033 y/1034 (makeblock 0 x/1033 y/1034)))
    (setfield_imm 0 (global Code!) f/1032))
  (letrec
    (g/1035
       (function y/1036
         (apply (field 0 (global Code!)) y/1036 (makeblock 0 y/1036 y/1036))))
    (setfield_imm 1 (global Code!) g/1035))
  0a)
checking tailcall on g/1035
checking tailcall on f/1032
stats_rec_removed : 2
(f_1032) (g_1035) 
stats_tailcall_removed : 0

stats_rec_removed : 0

stats_tailcall_removed : 0

pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dlambda2
*** After TonLambda.optimize:
(seq
  (let (f/1032 (function x/1033 y/1034 (makeblock 0 x/1033 y/1034)))
    (setfield_imm 0 (global Code!) f/1032))
  (let
    (g/1035
       (function y/1036
         (apply (field 0 (global Code!)) y/1036 (makeblock 0 y/1036 y/1036))))
    (setfield_imm 1 (global Code!) g/1035))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dclosure
*** After Closure.intro:
(seq
  (let
    (f/1032
       (closure (camlCode__f_1032(2)  x/1033 y/1034
                  (makeblock 0 x/1033 y/1034)) {3} ))
    (setfield_imm 0 (global camlCode!) f/1032))
  (let
    (g/1035
       (closure (camlCode__g_1035(1)  y/1036
                  (let (y/1042 (makeblock 0 y/1036 y/1036))
                    (makeblock 0 y/1036 y/1042))) {2} ))
    (setfield_imm 1 (global camlCode!) g/1035))
  0a)
pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
-dclosure2
pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
*** After TonClosure.optimize:
(let (f/1032 (closure (camlCode__f_1032(2)  x/1033 y/1034 (makeblock 0 x/1033 y/1034)) {3} ) temp/1044 (global camlCode!)) (seq (setfield_imm 0 temp/1044 f/1032) (let (g/1035 (closure (camlCode__g_1035(1)  y/1036 (let (y/1042 (makeblock 0 y/1036 y/1036)) (makeblock 0 y/1036 y/1042))) {2} ) temp/1043 (global camlCode!)) (seq (setfield_imm 1 temp/1043 g/1035) 0a))))
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed

-dcmm
pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
(data int 2048 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__g_1035" int 3)
(data int 3319 "camlCode__2": addr "caml_curry2" int 5 addr "camlCode__f_1032")
(function camlCode__f_1032 (x/1033: addr y/1034: addr) (alloc[0] 2048 x/1033 y/1034))

(function camlCode__g_1035 (y/1036: addr) (let y/1042 (alloc[0] 2048 y/1036 y/1036) (alloc[0] 2048 y/1036 y/1042)))

(function camlCode__entry () (let (f/1032 "camlCode__2" temp/1044 "camlCode") (store temp/1044 f/1032) (let (g/1035 "camlCode__1" temp/1043 "camlCode") (store (+a temp/1043 4) g/1035) 1a)))

(data)
-dlinear
pp_get_margin 78
pp_get_max_indent 68
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
pp_get_margin 1000
pp_get_max_indent 900
Function f/1032 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Function g/1035 is known
	Ident used 1 times
	Ident applied 0 times
	Ident tailed 0 times
	Function applied 0 times
	Function is closed
Before simplify
camlCode__f_1032:
                  x/8[%ecx] := R/0[%eax]
                  {x/8[%ecx]* y/9[%ebx]*}
                  A/10[%eax] := alloc 12
                  [A/10[%eax] + -4] := 2048
                  [A/10[%eax]] := x/8[%ecx]
                  [A/10[%eax] + 4] := y/9[%ebx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__f_1032:
  x/8[%ecx] := R/0[%eax]
  {x/8[%ecx]* y/9[%ebx]*}
  A/10[%eax] := alloc 12
  [A/10[%eax] + -4] := 2048
  [A/10[%eax]] := x/8[%ecx]
  [A/10[%eax] + 4] := y/9[%ebx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__g_1035:
                  y/8[%ecx] := R/0[%eax]
                  {y/8[%ecx]*}
                  y/9[%ebx] := alloc 24
                  [y/9[%ebx] + -4] := 2048
                  [y/9[%ebx]] := y/8[%ecx]
                  [y/9[%ebx] + 4] := y/8[%ecx]
                  A/10[%eax] := y/9[%ebx] + 12
                  [A/10[%eax] + -4] := 2048
                  [A/10[%eax]] := y/8[%ecx]
                  [A/10[%eax] + 4] := y/9[%ebx]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__g_1035:
  y/8[%ecx] := R/0[%eax]
  {y/8[%ecx]*}
  y/9[%ebx] := alloc 24
  [y/9[%ebx] + -4] := 2048
  [y/9[%ebx]] := y/8[%ecx]
  [y/9[%ebx] + 4] := y/8[%ecx]
  A/10[%eax] := y/9[%ebx] + 12
  [A/10[%eax] + -4] := 2048
  [A/10[%eax]] := y/8[%ecx]
  [A/10[%eax] + 4] := y/9[%ebx]
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  f/8[%ebx] := "camlCode__2"
                  temp/9[%eax] := "camlCode"
                  [temp/9[%eax]] := f/8[%ebx]
                  g/10[%ebx] := "camlCode__1"
                  temp/11[%eax] := "camlCode"
                  [temp/11[%eax] + 4] := g/10[%ebx]
                  A/12[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  f/8[%ebx] := "camlCode__2"
  temp/9[%eax] := "camlCode"
  [temp/9[%eax]] := f/8[%ebx]
  g/10[%ebx] := "camlCode__1"
  temp/11[%eax] := "camlCode"
  [temp/11[%eax] + 4] := g/10[%ebx]
  A/12[%eax] := 1
  return R/0[%eax]
  
-S
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.long	2048
	.globl	camlCode
camlCode:
	.space	8
	.data
	.long	2295
camlCode__1:
	.long	camlCode__g_1035
	.long	3
	.data
	.long	3319
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__f_1032
	.text
	.align	16
	.globl	camlCode__f_1032
camlCode__f_1032:
.L100:
	movl	%eax, %ecx
.L101:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L102
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	%ecx, (%eax)
	movl	%ebx, 4(%eax)
	ret
.L102:	call	caml_call_gc
.L103:	jmp	.L101
	.type	camlCode__f_1032,@function
	.size	camlCode__f_1032,.-camlCode__f_1032
	.text
	.align	16
	.globl	camlCode__g_1035
camlCode__g_1035:
.L104:
	movl	%eax, %ecx
.L105:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L106
	leal	4(%eax), %ebx
	movl	$2048, -4(%ebx)
	movl	%ecx, (%ebx)
	movl	%ecx, 4(%ebx)
	leal	12(%ebx), %eax
	movl	$2048, -4(%eax)
	movl	%ecx, (%eax)
	movl	%ebx, 4(%eax)
	ret
.L106:	call	caml_call_gc
.L107:	jmp	.L105
	.type	camlCode__g_1035,@function
	.size	camlCode__g_1035,.-camlCode__g_1035
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L108:
	movl	$camlCode__2, %ebx
	movl	$camlCode, %eax
	movl	%ebx, (%eax)
	movl	$camlCode__1, %ebx
	movl	$camlCode, %eax
	movl	%ebx, 4(%eax)
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
	.long	2
	.long	.L107
	.word	4
	.word	1
	.word	5
	.align	4
	.long	.L103
	.word	4
	.word	2
	.word	3
	.word	5
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

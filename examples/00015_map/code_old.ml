(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.
*)

(*

let rec iter1 f l =
  match l with
      [] -> ()
    | a::l -> f a; iter1 f l

let iter2 f l =
  let l = ref l in
    while
      match !l with
	  [] -> false
	| a :: lr ->
	    f a;
	    l := lr;
	    true
    do
      ()
    done
*)



let map1 =
  let z = List.map (fun x -> x + 1) [1;2;3] in
  let rec map1 f l =
    match l with
	[] -> z
      | a::l ->
	  let x = f a in
	    x :: (map1 f l)
  in
    map1

let list1 =
  map1 (fun x -> x+1) [1;2;3;4;5]


(*

  camlCode__iter1_58:
  subq    $24, %rsp
  .L101:
  movq    %rax, %rsi
  cmpq    $1, %rbx
  je      .L100
  movq    %rbx, 0(%rsp)
  movq    %rsi, 8(%rsp)
  movq    (%rbx), %rax
  movq    (%rsi), %rdi
  movq    %rsi, %rbx
  call    *%rdi
  movq    0(%rsp), %rax
  movq    8(%rax), %rbx
  movq    8(%rsp), %rax
  jmp     .L101
  .align  4
  .L100:
  movq    $1, %rax
  addq    $24, %rsp
  ret


  camlCode__iter2_63:
  subq    $24, %rsp
  movq    %rax, 0(%rsp)
  .L104:
  movq    %rbx, 8(%rsp)
  cmpq    $1, %rbx
  je      .L106
  movq    (%rbx), %rax
  movq    0(%rsp), %rbx
  movq    (%rbx), %rdi
  call    *%rdi
  movq    8(%rsp), %rax
  movq    8(%rax), %rbx
  movq    $3, %rax
  jmp     .L105
  .align  4
  .L106:
  movq    $1, %rax
  .L105:
  cmpq    $1, %rax
  jne     .L104
  movq    $1, %rax
  addq    $24, %rsp
  ret


  camlCode__iter1_58:
  subq    $24, %rsp
  .L101:
  movq    %rax, %rsi
  cmpq    $1, %rbx
  je      .L100
  movq    %rbx, 0(%rsp)
  movq    %rsi, 8(%rsp)
  movq    (%rbx), %rax
  movq    (%rsi), %rdi
  movq    %rsi, %rbx
  call    *%rdi
  movq    0(%rsp), %rax
  movq    8(%rax), %rbx
  movq    8(%rsp), %rax
  jmp     .L101
  .align  4
  .L100:
  movq    $1, %rax
  addq    $24, %rsp
  ret


  camlCode__iter2_63: (improved)
  subq    $24, %rsp
  movq    %rax, 0(%rsp)
  .L104:
  movq    %rbx, 8(%rsp)
  cmpq    $1, %rbx
  je      .L106
  movq    (%rbx), %rax
  movq    0(%rsp), %rbx
  movq    (%rbx), %rdi
  call    *%rdi
  movq    8(%rsp), %rax
  movq    8(%rax), %rbx
  jmp     .L104
  .align  4
  .L106:
  movq    $1, %rax
  addq    $24, %rsp
  ret

*)
(*
-drawlambda
(seq
  (let
    (map1/58
       (let
         (z/59
            (apply (field 10 (global List!)) (function x/60 (+ x/60 1))
              [0: 1 [0: 2 [0: 3 0a]]]))
         (letrec
           (map1/61
              (function f/62 l/63
                (if l/63
                  (let
                    (l/65 (field 1 l/63)
                     a/64 (field 0 l/63)
                     x/66 (apply f/62 a/64))
                    (makeblock 0 x/66 (apply map1/61 f/62 l/65)))
                  z/59)))
           map1/61)))
    (setfield_imm 0 (global Code!) map1/58))
  (let
    (list1/67
       (apply (field 0 (global Code!)) (function x/68 (+ x/68 1))
         [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]))
    (setfield_imm 1 (global Code!) list1/67))
  0a)
-dlambda
(seq
  (let
    (map1/58
       (let
         (z/59
            (apply (field 10 (global List!)) (function x/60 (+ x/60 1))
              [0: 1 [0: 2 [0: 3 0a]]]))
         (letrec
           (map1/61
              (function f/62 l/63
                (if l/63
                  (let (x/66 (apply f/62 (field 0 l/63)))
                    (makeblock 0 x/66 (apply map1/61 f/62 (field 1 l/63))))
                  z/59)))
           map1/61)))
    (setfield_imm 0 (global Code!) map1/58))
  (let
    (list1/67
       (apply (field 0 (global Code!)) (function x/68 (+ x/68 1))
         [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]))
    (setfield_imm 1 (global Code!) list1/67))
  0a)

-dcmm
(data int 2048 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__fun_76" int 3)
(data int 2295 "camlCode__3": addr "camlCode__fun_71" int 3)
(data
 int 2048
 "camlCode__2":
 int 3
 addr L7
 int 2048
 L7:
 int 5
 addr L8
 int 2048
 L8:
 int 7
 addr L9
 int 2048
 L9:
 int 9
 addr L10
 int 2048
 L10:
 int 11
 int 1)
(data
 int 2048
 "camlCode__4":
 int 3
 addr L5
 int 2048
 L5:
 int 5
 addr L6
 int 2048
 L6:
 int 7
 int 1)
(function camlCode__fun_71 (x/60: addr) (+ x/60 2))

(function camlCode__map1_61 (f/62: addr l/63: addr env/74: addr)
 (if (!= l/63 1)
   (let x/66 (app (load f/62) (load l/63) f/62 addr)
     (alloc 2048 x/66
       (app "camlCode__map1_61" f/62 (load (+a l/63 4)) env/74 addr)))
   (load (+a env/74 12))))

(function camlCode__fun_76 (x/68: addr) (+ x/68 2))

(function camlCode__entry ()
 (let
   map1/58
     (let
       (z/59 (app "camlList__map_90" "camlCode__3" "camlCode__4" addr)
        clos/75 (alloc 4343 "caml_curry2" 5 "camlCode__map1_61" z/59))
       clos/75)
   (store "camlCode" map1/58))
 (let
   list1/67
     (app "camlCode__map1_61" "camlCode__1" "camlCode__2" (load "camlCode")
       addr)
   (store (+a "camlCode" 4) list1/67))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__fun_71:
  I/9[%eax] := I/9[%eax] + 2
  return R/0[%eax]
  
*** Linearized code
camlCode__map1_61:
  f/8[%edx] := R/0[%eax]
  if l/9[%ebx] ==s 1 goto L101
  spilled-env/19[s2] := env/10[%ecx] (spill)
  spilled-l/21[s0] := l/9[%ebx] (spill)
  spilled-f/20[s1] := f/8[%edx] (spill)
  A/12[%eax] := [l/9[%ebx]]
  A/13[%ecx] := [f/8[%edx]]
  R/1[%ebx] := f/8[%edx]
  {spilled-env/19[s2]* spilled-f/20[s1]* spilled-l/21[s0]*}
  R/0[%eax] := call A/13[%ecx] R/0[%eax] R/1[%ebx]
  spilled-x/18[s3] := x/14[%eax] (spill)
  l/22[%eax] := spilled-l/21[s0] (reload)
  A/15[%ebx] := [l/22[%eax] + 4]
  f/23[%eax] := spilled-f/20[s1] (reload)
  env/24[%ecx] := spilled-env/19[s2] (reload)
  {spilled-x/18[s3]*}
  R/0[%eax] := call "camlCode__map1_61" R/0[%eax] R/1[%ebx] R/2[%ecx]
  A/16[%ecx] := R/0[%eax]
  {A/16[%ecx]* spilled-x/18[s3]*}
  A/17[%eax] := alloc 12
  [A/17[%eax] + -4] := 2048
  x/25[%ebx] := spilled-x/18[s3] (reload)
  [A/17[%eax]] := x/25[%ebx]
  [A/17[%eax] + 4] := A/16[%ecx]
  reload retaddr
  return R/0[%eax]
  L101:
  A/11[%eax] := [env/10[%ecx] + 12]
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_76:
  I/9[%eax] := I/9[%eax] + 2
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  A/8[%ebx] := "camlCode__4"
  A/9[%eax] := "camlCode__3"
  {}
  R/0[%eax] := call "camlList__map_90" R/0[%eax] R/1[%ebx]
  z/10[%ebx] := R/0[%eax]
  {z/10[%ebx]*}
  clos/11[%eax] := alloc 20
  [clos/11[%eax] + -4] := 4343
  [clos/11[%eax]] := "caml_curry2"
  [clos/11[%eax] + 4] := 5
  [clos/11[%eax] + 8] := "camlCode__map1_61"
  [clos/11[%eax] + 12] := z/10[%ebx]
  ["camlCode"] := map1/12[%eax]
  A/13[%ecx] := ["camlCode"]
  A/14[%ebx] := "camlCode__2"
  A/15[%eax] := "camlCode__1"
  {}
  R/0[%eax] := call "camlCode__map1_61" R/0[%eax] R/1[%ebx] R/2[%ecx]
  ["camlCode" + 4] := list1/16[%eax]
  A/17[%eax] := 1
  reload retaddr
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
	.long	camlCode__fun_76
	.long	3
	.data
	.long	2295
camlCode__3:
	.long	camlCode__fun_71
	.long	3
	.data
	.long	2048
camlCode__2:
	.long	3
	.long	.L100007
	.long	2048
.L100007:
	.long	5
	.long	.L100008
	.long	2048
.L100008:
	.long	7
	.long	.L100009
	.long	2048
.L100009:
	.long	9
	.long	.L100010
	.long	2048
.L100010:
	.long	11
	.long	1
	.data
	.long	2048
camlCode__4:
	.long	3
	.long	.L100005
	.long	2048
.L100005:
	.long	5
	.long	.L100006
	.long	2048
.L100006:
	.long	7
	.long	1
	.text
	.align	16
	.globl	camlCode__fun_71
camlCode__fun_71:
.L100:
	addl	$2, %eax
	ret
	.type	camlCode__fun_71,@function
	.size	camlCode__fun_71,.-camlCode__fun_71
	.text
	.align	16
	.globl	camlCode__map1_61
camlCode__map1_61:
	subl	$16, %esp
.L102:
	movl	%eax, %edx
	cmpl	$1, %ebx
	je	.L101
	movl	%ecx, 8(%esp)
	movl	%ebx, 0(%esp)
	movl	%edx, 4(%esp)
	movl	(%ebx), %eax
	movl	(%edx), %ecx
	movl	%edx, %ebx
	call	*%ecx
.L103:
	movl	%eax, 12(%esp)
	movl	0(%esp), %eax
	movl	4(%eax), %ebx
	movl	4(%esp), %eax
	movl	8(%esp), %ecx
	call	camlCode__map1_61
.L104:
	movl	%eax, %ecx
.L105:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L106
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	12(%esp), %ebx
	movl	%ebx, (%eax)
	movl	%ecx, 4(%eax)
	addl	$16, %esp
	ret
	.align	16
.L101:
	movl	12(%ecx), %eax
	addl	$16, %esp
	ret
.L106:	call	caml_call_gc
.L107:	jmp	.L105
	.type	camlCode__map1_61,@function
	.size	camlCode__map1_61,.-camlCode__map1_61
	.text
	.align	16
	.globl	camlCode__fun_76
camlCode__fun_76:
.L108:
	addl	$2, %eax
	ret
	.type	camlCode__fun_76,@function
	.size	camlCode__fun_76,.-camlCode__fun_76
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L109:
	movl	$camlCode__4, %ebx
	movl	$camlCode__3, %eax
	call	camlList__map_90
.L110:
	movl	%eax, %ebx
	movl	$20, %eax
	call	caml_allocN
.L111:
	leal	4(%eax), %eax
	movl	$4343, -4(%eax)
	movl	$caml_curry2, (%eax)
	movl	$5, 4(%eax)
	movl	$camlCode__map1_61, 8(%eax)
	movl	%ebx, 12(%eax)
	movl	%eax, camlCode
	movl	camlCode, %ecx
	movl	$camlCode__2, %ebx
	movl	$camlCode__1, %eax
	call	camlCode__map1_61
.L112:
	movl	%eax, camlCode + 4
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
	.long	6
	.long	.L112
	.word	4
	.word	0
	.align	4
	.long	.L111
	.word	4
	.word	1
	.word	3
	.align	4
	.long	.L110
	.word	4
	.word	0
	.align	4
	.long	.L107
	.word	20
	.word	2
	.word	12
	.word	5
	.align	4
	.long	.L104
	.word	20
	.word	1
	.word	12
	.align	4
	.long	.L103
	.word	20
	.word	3
	.word	0
	.word	4
	.word	8
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

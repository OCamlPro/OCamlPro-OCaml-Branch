(*
Inlining:
 - In main1, protect1 is not inlined, because it contains a reference
to a constant string, and the compiler prevents inlining when
there are potential duplication of structured constants.
- In main2, protect2 is inlined, but not the argument function. First order
arguments are never inlined, and some optimisations are clearly missed.

*)

let protect1 s f =
  try f () with e ->
    Printf.eprintf "Uncaught exception in %s: %s\n%!" s (Printexc.to_string e);
    exit 2

let main1 x =
  protect1 "main1" (fun () -> x + 1)

let msg = Obj.magic "Uncaught exception in %s: %s\n%!"
let protect2 s f =
      try f () with e ->
	Printf.eprintf msg s (Printexc.to_string e);
	exit 2

let main2 x =
  protect2 "main2" (fun () -> x + 1)

let make_main protect x =
  protect "make_main" (fun () -> x + 1)

let main3 = make_main protect2

(*
-drawlambda
File "code.ml", line 22, characters 1-44:
Warning X: this statement never returns (or has an unsound type.)
(seq
  (let
    (protect1/58
       (function s/59 f/60
         (try (apply f/60 0a) with e/61
           (seq
             (apply (field 2 (global Printf!))
               "Uncaught exception in %s: %s\n%!" s/59
               (apply (field 0 (global Printexc!)) e/61))
             (apply (field 76 (global Pervasives!)) 2)))))
    (setfield_imm 0 (global Code!) protect1/58))
  (let
    (main1/62
       (function x/63
         (apply (field 0 (global Code!)) "main1"
           (function param/82 (+ x/63 1)))))
    (setfield_imm 1 (global Code!) main1/62))
  (let (msg/64 (id "Uncaught exception in %s: %s\n%!"))
    (setfield_imm 2 (global Code!) msg/64))
  (let
    (protect2/65
       (function s/66 f/67
         (try (apply f/67 0a) with e/68
           (seq
             (apply (field 2 (global Printf!)) (field 2 (global Code!)) s/66
               (apply (field 0 (global Printexc!)) e/68))
             (apply (field 76 (global Pervasives!)) 2)))))
    (setfield_imm 3 (global Code!) protect2/65))
  (let
    (main2/69
       (function x/70
         (apply (field 3 (global Code!)) "main2"
           (function param/83 (+ x/70 1)))))
    (setfield_imm 4 (global Code!) main2/69))
  (let
    (make_main/71
       (function protect/72 x/73
         (apply protect/72 "make_main" (function param/84 (+ x/73 1)))))
    (setfield_imm 5 (global Code!) make_main/71))
  (let (main3/74 (apply (field 5 (global Code!)) (field 3 (global Code!))))
    (setfield_imm 6 (global Code!) main3/74))
  0a)
-dlambda
File "code.ml", line 22, characters 1-44:
Warning X: this statement never returns (or has an unsound type.)
(seq
  (let
    (protect1/58
       (function s/59 f/60
         (try (apply f/60 0a) with e/61
           (seq
             (apply (field 2 (global Printf!))
               "Uncaught exception in %s: %s\n%!" s/59
               (apply (field 0 (global Printexc!)) e/61))
             (apply (field 76 (global Pervasives!)) 2)))))
    (setfield_imm 0 (global Code!) protect1/58))
  (let
    (main1/62
       (function x/63
         (apply (field 0 (global Code!)) "main1"
           (function param/82 (+ x/63 1)))))
    (setfield_imm 1 (global Code!) main1/62))
  (let (msg/64 (id "Uncaught exception in %s: %s\n%!"))
    (setfield_imm 2 (global Code!) msg/64))
  (let
    (protect2/65
       (function s/66 f/67
         (try (apply f/67 0a) with e/68
           (seq
             (apply (field 2 (global Printf!)) (field 2 (global Code!)) s/66
               (apply (field 0 (global Printexc!)) e/68))
             (apply (field 76 (global Pervasives!)) 2)))))
    (setfield_imm 3 (global Code!) protect2/65))
  (let
    (main2/69
       (function x/70
         (apply (field 3 (global Code!)) "main2"
           (function param/83 (+ x/70 1)))))
    (setfield_imm 4 (global Code!) main2/69))
  (let
    (make_main/71
       (function protect/72 x/73
         (apply protect/72 "make_main" (function param/84 (+ x/73 1)))))
    (setfield_imm 5 (global Code!) make_main/71))
  (let (main3/74 (apply (field 5 (global Code!)) (field 3 (global Code!))))
    (setfield_imm 6 (global Code!) main3/74))
  0a)

-dcmm
File "code.ml", line 22, characters 1-44:
Warning X: this statement never returns (or has an unsound type.)
(data int 7168 global "camlCode" "camlCode": skip 28)
(data
 int 3319
 "camlCode__1":
 addr "caml_curry2"
 int 5
 addr "camlCode__make_main_71")
(data int 2295 "camlCode__2": addr "camlCode__main2_69" int 3)
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__protect2_65")
(data int 2295 "camlCode__5": addr "camlCode__main1_62" int 3)
(data
 int 3319
 "camlCode__6":
 addr "caml_curry2"
 int 5
 addr "camlCode__protect1_58")
(data
 int 8444
 "camlCode__4":
 string "Uncaught exception in %s: %s
%!"
 skip 0
 byte 0)
(data int 3324 "camlCode__7": string "make_main" skip 2 byte 2)
(data int 2300 "camlCode__8": string "main2" skip 2 byte 2)
(data int 2300 "camlCode__9": string "main1" skip 2 byte 2)
(data
 int 8444
 "camlCode__10":
 string "Uncaught exception in %s: %s
%!"
 skip 0
 byte 0)
(function camlCode__fun_87 (param/82: addr env/89: addr)
 (+ (load (+a env/89 8)) 2))

(function camlCode__fun_92 (param/83: addr env/94: addr)
 (+ (load (+a env/94 8)) 2))

(function camlCode__fun_99 (param/84: addr env/101: addr)
 (+ (load (+a env/101 8)) 2))

(function camlCode__protect1_58 (s/59: addr f/60: addr)
 (try (app (load f/60) 1a f/60 addr) with e/61
   (app "caml_apply2" s/59 (app "camlPrintexc__to_string_89" e/61 addr)
     (app "camlPrintf__eprintf_427" "camlCode__10" addr) unit)
   (app "camlPervasives__exit_350" 5 addr)))

(function camlCode__main1_62 (x/63: addr)
 (app "camlCode__protect1_58" "camlCode__9"
   (alloc 3319 "camlCode__fun_87" 3 x/63) addr))

(function camlCode__protect2_65 (s/66: addr f/67: addr)
 (try (app (load f/67) 1a f/67 addr) with e/68
   (app "caml_apply2" s/66 (app "camlPrintexc__to_string_89" e/68 addr)
     (app "camlPrintf__eprintf_427" (load (+a "camlCode" 8)) addr) unit)
   (app "camlPervasives__exit_350" 5 addr)))

(function camlCode__main2_69 (x/70: addr)
 (let (f/95 (alloc 3319 "camlCode__fun_92" 3 x/70) s/96 "camlCode__8")
   (try (app (load f/95) 1a f/95 addr) with e/97
     (app "caml_apply2" s/96 (app "camlPrintexc__to_string_89" e/97 addr)
       (app "camlPrintf__eprintf_427" (load (+a "camlCode" 8)) addr) unit)
     (app "camlPervasives__exit_350" 5 addr))))

(function camlCode__make_main_71 (protect/72: addr x/73: addr)
 (app "caml_apply2" "camlCode__7" (alloc 3319 "camlCode__fun_99" 3 x/73)
   protect/72 addr))

(function camlCode__entry ()
 (let protect1/58 "camlCode__6" (store "camlCode" protect1/58))
 (let main1/62 "camlCode__5" (store (+a "camlCode" 4) main1/62))
 (let msg/64 "camlCode__4" (store (+a "camlCode" 8) msg/64))
 (let protect2/65 "camlCode__3" (store (+a "camlCode" 12) protect2/65))
 (let main2/69 "camlCode__2" (store (+a "camlCode" 16) main2/69))
 (let make_main/71 "camlCode__1" (store (+a "camlCode" 20) make_main/71))
 (let
   main3/74
     (let fun/102 (load (+a "camlCode" 20))
       (app (load fun/102) (load (+a "camlCode" 12)) fun/102 addr))
   (store (+a "camlCode" 24) main3/74))
 1a)

(data)
-dlinear
File "code.ml", line 22, characters 1-44:
Warning X: this statement never returns (or has an unsound type.)
*** Linearized code
camlCode__fun_87:
  A/10[%eax] := [env/9[%ebx] + 8]
  I/11[%eax] := I/11[%eax] + 2
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_92:
  A/10[%eax] := [env/9[%ebx] + 8]
  I/11[%eax] := I/11[%eax] + 2
  return R/0[%eax]
  
*** Linearized code
camlCode__fun_99:
  A/10[%eax] := [env/9[%ebx] + 8]
  I/11[%eax] := I/11[%eax] + 2
  return R/0[%eax]
  
*** Linearized code
camlCode__protect1_58:
  spilled-s/19[s1] := s/8[%eax] (spill)
  setup trap L104
  A/20[s0] := A/13[%eax] (spill)
  A/14[%eax] := "camlCode__10"
  {spilled-s/19[s1]* A/20[s0]*}
  R/0[%eax] := call "camlPrintf__eprintf_427" R/0[%eax]
  A/18[s2] := A/15[%eax] (spill)
  A/21[%eax] := A/20[s0] (reload)
  {A/18[s2]* spilled-s/19[s1]*}
  R/0[%eax] := call "camlPrintexc__to_string_89" R/0[%eax]
  A/16[%ebx] := R/0[%eax]
  s/22[%eax] := spilled-s/19[s1] (reload)
  A/23[%ecx] := A/18[s2] (reload)
  {}
  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  I/17[%eax] := 5
  tailcall "camlPervasives__exit_350" R/0[%eax]
  L104:
  push trap
  A/10[%eax] := 1
  A/11[%ecx] := [f/9[%ebx]]
  {spilled-s/19[s1]*}
  R/0[%eax] := call A/11[%ecx] R/0[%eax] R/1[%ebx]
  pop trap
  L103:
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__main1_62:
  x/8[%ecx] := R/0[%eax]
  {x/8[%ecx]*}
  A/9[%ebx] := alloc 16
  [A/9[%ebx] + -4] := 3319
  [A/9[%ebx]] := "camlCode__fun_87"
  [A/9[%ebx] + 4] := 3
  [A/9[%ebx] + 8] := x/8[%ecx]
  A/10[%eax] := "camlCode__9"
  tailcall "camlCode__protect1_58" R/0[%eax] R/1[%ebx]
  
*** Linearized code
camlCode__protect2_65:
  spilled-s/19[s1] := s/8[%eax] (spill)
  setup trap L115
  A/20[s0] := A/13[%eax] (spill)
  A/14[%eax] := ["camlCode" + 8]
  {spilled-s/19[s1]* A/20[s0]*}
  R/0[%eax] := call "camlPrintf__eprintf_427" R/0[%eax]
  A/18[s2] := A/15[%eax] (spill)
  A/21[%eax] := A/20[s0] (reload)
  {A/18[s2]* spilled-s/19[s1]*}
  R/0[%eax] := call "camlPrintexc__to_string_89" R/0[%eax]
  A/16[%ebx] := R/0[%eax]
  s/22[%eax] := spilled-s/19[s1] (reload)
  A/23[%ecx] := A/18[s2] (reload)
  {}
  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  I/17[%eax] := 5
  tailcall "camlPervasives__exit_350" R/0[%eax]
  L115:
  push trap
  A/10[%eax] := 1
  A/11[%ecx] := [f/9[%ebx]]
  {spilled-s/19[s1]*}
  R/0[%eax] := call A/11[%ecx] R/0[%eax] R/1[%ebx]
  pop trap
  L114:
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__main2_69:
  x/8[%ecx] := R/0[%eax]
  {x/8[%ecx]*}
  f/9[%ebx] := alloc 16
  [f/9[%ebx] + -4] := 3319
  [f/9[%ebx]] := "camlCode__fun_92"
  [f/9[%ebx] + 4] := 3
  [f/9[%ebx] + 8] := x/8[%ecx]
  s/10[%eax] := "camlCode__8"
  spilled-s/20[s1] := s/10[%eax] (spill)
  setup trap L122
  A/21[s0] := A/14[%eax] (spill)
  A/15[%eax] := ["camlCode" + 8]
  {spilled-s/20[s1]* A/21[s0]*}
  R/0[%eax] := call "camlPrintf__eprintf_427" R/0[%eax]
  A/19[s2] := A/16[%eax] (spill)
  A/22[%eax] := A/21[s0] (reload)
  {A/19[s2]* spilled-s/20[s1]*}
  R/0[%eax] := call "camlPrintexc__to_string_89" R/0[%eax]
  A/17[%ebx] := R/0[%eax]
  s/23[%eax] := spilled-s/20[s1] (reload)
  A/24[%ecx] := A/19[s2] (reload)
  {}
  call "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  I/18[%eax] := 5
  tailcall "camlPervasives__exit_350" R/0[%eax]
  L122:
  push trap
  A/11[%eax] := 1
  A/12[%ecx] := [f/9[%ebx]]
  {spilled-s/20[s1]*}
  R/0[%eax] := call A/12[%ecx] R/0[%eax] R/1[%ebx]
  pop trap
  L121:
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__make_main_71:
  protect/8[%ecx] := R/0[%eax]
  x/9[%edx] := R/1[%ebx]
  {protect/8[%ecx]* x/9[%edx]*}
  A/10[%ebx] := alloc 16
  [A/10[%ebx] + -4] := 3319
  [A/10[%ebx]] := "camlCode__fun_99"
  [A/10[%ebx] + 4] := 3
  [A/10[%ebx] + 8] := x/9[%edx]
  A/11[%eax] := "camlCode__7"
  tailcall "caml_apply2" R/0[%eax] R/1[%ebx] R/2[%ecx]
  
*** Linearized code
camlCode__entry:
  protect1/8[%eax] := "camlCode__6"
  ["camlCode"] := protect1/8[%eax]
  main1/9[%eax] := "camlCode__5"
  ["camlCode" + 4] := main1/9[%eax]
  msg/10[%eax] := "camlCode__4"
  ["camlCode" + 8] := msg/10[%eax]
  protect2/11[%eax] := "camlCode__3"
  ["camlCode" + 12] := protect2/11[%eax]
  main2/12[%eax] := "camlCode__2"
  ["camlCode" + 16] := main2/12[%eax]
  make_main/13[%eax] := "camlCode__1"
  ["camlCode" + 20] := make_main/13[%eax]
  fun/14[%ebx] := ["camlCode" + 20]
  A/15[%eax] := ["camlCode" + 12]
  A/16[%ecx] := [fun/14[%ebx]]
  {}
  R/0[%eax] := call A/16[%ecx] R/0[%eax] R/1[%ebx]
  ["camlCode" + 24] := main3/17[%eax]
  A/18[%eax] := 1
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
	.long	7168
	.globl	camlCode
camlCode:
	.space	28
	.data
	.long	3319
camlCode__1:
	.long	caml_curry2
	.long	5
	.long	camlCode__make_main_71
	.data
	.long	2295
camlCode__2:
	.long	camlCode__main2_69
	.long	3
	.data
	.long	3319
camlCode__3:
	.long	caml_curry2
	.long	5
	.long	camlCode__protect2_65
	.data
	.long	2295
camlCode__5:
	.long	camlCode__main1_62
	.long	3
	.data
	.long	3319
camlCode__6:
	.long	caml_curry2
	.long	5
	.long	camlCode__protect1_58
	.data
	.long	8444
camlCode__4:
	.ascii	"Uncaught exception in %s: %s\12%!"
	.byte	0
	.data
	.long	3324
camlCode__7:
	.ascii	"make_main"
	.space	2
	.byte	2
	.data
	.long	2300
camlCode__8:
	.ascii	"main2"
	.space	2
	.byte	2
	.data
	.long	2300
camlCode__9:
	.ascii	"main1"
	.space	2
	.byte	2
	.data
	.long	8444
camlCode__10:
	.ascii	"Uncaught exception in %s: %s\12%!"
	.byte	0
	.text
	.align	16
	.globl	camlCode__fun_87
camlCode__fun_87:
.L100:
	movl	8(%ebx), %eax
	addl	$2, %eax
	ret
	.type	camlCode__fun_87,@function
	.size	camlCode__fun_87,.-camlCode__fun_87
	.text
	.align	16
	.globl	camlCode__fun_92
camlCode__fun_92:
.L101:
	movl	8(%ebx), %eax
	addl	$2, %eax
	ret
	.type	camlCode__fun_92,@function
	.size	camlCode__fun_92,.-camlCode__fun_92
	.text
	.align	16
	.globl	camlCode__fun_99
camlCode__fun_99:
.L102:
	movl	8(%ebx), %eax
	addl	$2, %eax
	ret
	.type	camlCode__fun_99,@function
	.size	camlCode__fun_99,.-camlCode__fun_99
	.text
	.align	16
	.globl	camlCode__protect1_58
camlCode__protect1_58:
	subl	$12, %esp
.L105:
	movl	%eax, 4(%esp)
	call	.L104
	movl	%eax, 0(%esp)
	movl	$camlCode__10, %eax
	call	camlPrintf__eprintf_427
.L106:
	movl	%eax, 8(%esp)
	movl	0(%esp), %eax
	call	camlPrintexc__to_string_89
.L107:
	movl	%eax, %ebx
	movl	4(%esp), %eax
	movl	8(%esp), %ecx
	call	caml_apply2
.L108:
	movl	$5, %eax
	addl	$12, %esp
	jmp	camlPervasives__exit_350
	.align	16
.L104:
	pushl	caml_exception_pointer
	movl	%esp, caml_exception_pointer
	movl	$1, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L109:
	popl	caml_exception_pointer
	addl	$4, %esp
.L103:
	addl	$12, %esp
	ret
	.type	camlCode__protect1_58,@function
	.size	camlCode__protect1_58,.-camlCode__protect1_58
	.text
	.align	16
	.globl	camlCode__main1_62
camlCode__main1_62:
.L110:
	movl	%eax, %ecx
.L111:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L112
	leal	4(%eax), %ebx
	movl	$3319, -4(%ebx)
	movl	$camlCode__fun_87, (%ebx)
	movl	$3, 4(%ebx)
	movl	%ecx, 8(%ebx)
	movl	$camlCode__9, %eax
	jmp	camlCode__protect1_58
.L112:	call	caml_call_gc
.L113:	jmp	.L111
	.type	camlCode__main1_62,@function
	.size	camlCode__main1_62,.-camlCode__main1_62
	.text
	.align	16
	.globl	camlCode__protect2_65
camlCode__protect2_65:
	subl	$12, %esp
.L116:
	movl	%eax, 4(%esp)
	call	.L115
	movl	%eax, 0(%esp)
	movl	camlCode + 8, %eax
	call	camlPrintf__eprintf_427
.L117:
	movl	%eax, 8(%esp)
	movl	0(%esp), %eax
	call	camlPrintexc__to_string_89
.L118:
	movl	%eax, %ebx
	movl	4(%esp), %eax
	movl	8(%esp), %ecx
	call	caml_apply2
.L119:
	movl	$5, %eax
	addl	$12, %esp
	jmp	camlPervasives__exit_350
	.align	16
.L115:
	pushl	caml_exception_pointer
	movl	%esp, caml_exception_pointer
	movl	$1, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L120:
	popl	caml_exception_pointer
	addl	$4, %esp
.L114:
	addl	$12, %esp
	ret
	.type	camlCode__protect2_65,@function
	.size	camlCode__protect2_65,.-camlCode__protect2_65
	.text
	.align	16
	.globl	camlCode__main2_69
camlCode__main2_69:
	subl	$12, %esp
.L123:
	movl	%eax, %ecx
.L124:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L125
	leal	4(%eax), %ebx
	movl	$3319, -4(%ebx)
	movl	$camlCode__fun_92, (%ebx)
	movl	$3, 4(%ebx)
	movl	%ecx, 8(%ebx)
	movl	$camlCode__8, %eax
	movl	%eax, 4(%esp)
	call	.L122
	movl	%eax, 0(%esp)
	movl	camlCode + 8, %eax
	call	camlPrintf__eprintf_427
.L127:
	movl	%eax, 8(%esp)
	movl	0(%esp), %eax
	call	camlPrintexc__to_string_89
.L128:
	movl	%eax, %ebx
	movl	4(%esp), %eax
	movl	8(%esp), %ecx
	call	caml_apply2
.L129:
	movl	$5, %eax
	addl	$12, %esp
	jmp	camlPervasives__exit_350
	.align	16
.L122:
	pushl	caml_exception_pointer
	movl	%esp, caml_exception_pointer
	movl	$1, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L130:
	popl	caml_exception_pointer
	addl	$4, %esp
.L121:
	addl	$12, %esp
	ret
.L125:	call	caml_call_gc
.L126:	jmp	.L124
	.type	camlCode__main2_69,@function
	.size	camlCode__main2_69,.-camlCode__main2_69
	.text
	.align	16
	.globl	camlCode__make_main_71
camlCode__make_main_71:
.L131:
	movl	%eax, %ecx
	movl	%ebx, %edx
.L132:	movl	caml_young_ptr, %eax
	subl	$16, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L133
	leal	4(%eax), %ebx
	movl	$3319, -4(%ebx)
	movl	$camlCode__fun_99, (%ebx)
	movl	$3, 4(%ebx)
	movl	%edx, 8(%ebx)
	movl	$camlCode__7, %eax
	jmp	caml_apply2
.L133:	call	caml_call_gc
.L134:	jmp	.L132
	.type	camlCode__make_main_71,@function
	.size	camlCode__make_main_71,.-camlCode__make_main_71
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L135:
	movl	$camlCode__6, %eax
	movl	%eax, camlCode
	movl	$camlCode__5, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__4, %eax
	movl	%eax, camlCode + 8
	movl	$camlCode__3, %eax
	movl	%eax, camlCode + 12
	movl	$camlCode__2, %eax
	movl	%eax, camlCode + 16
	movl	$camlCode__1, %eax
	movl	%eax, camlCode + 20
	movl	camlCode + 20, %ebx
	movl	camlCode + 12, %eax
	movl	(%ebx), %ecx
	call	*%ecx
.L136:
	movl	%eax, camlCode + 24
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
	.long	16
	.long	.L136
	.word	4
	.word	0
	.align	4
	.long	.L134
	.word	4
	.word	2
	.word	7
	.word	5
	.align	4
	.long	.L130
	.word	24
	.word	1
	.word	12
	.align	4
	.long	.L129
	.word	16
	.word	0
	.align	4
	.long	.L128
	.word	16
	.word	2
	.word	4
	.word	8
	.align	4
	.long	.L127
	.word	16
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L126
	.word	16
	.word	1
	.word	5
	.align	4
	.long	.L120
	.word	24
	.word	1
	.word	12
	.align	4
	.long	.L119
	.word	16
	.word	0
	.align	4
	.long	.L118
	.word	16
	.word	2
	.word	4
	.word	8
	.align	4
	.long	.L117
	.word	16
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L113
	.word	4
	.word	1
	.word	5
	.align	4
	.long	.L109
	.word	24
	.word	1
	.word	12
	.align	4
	.long	.L108
	.word	16
	.word	0
	.align	4
	.long	.L107
	.word	16
	.word	2
	.word	4
	.word	8
	.align	4
	.long	.L106
	.word	16
	.word	2
	.word	0
	.word	4
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

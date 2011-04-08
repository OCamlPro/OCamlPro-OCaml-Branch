(*
ocamlopt -c -drawlambda -dlambda -dclosure -dcmm code.ml
*)


let rec iter f = function
    [] -> ()
  | a::l -> f a; iter f l

let _ =
  iter (fun x -> print_int x) [0;1;2]

(*
-drawlambda:

(seq
  (letrec
    (iter/58
       (function f/59 param/64
         (if param/64
           (let (l/61 (field 1 param/64) a/60 (field 0 param/64))
             (seq (apply f/59 a/60) (apply iter/58 f/59 l/61)))
           0a)))
    (setfield_imm 0 (global Code!) iter/58))
  (apply (field 0 (global Code!))
    (function x/62 (apply (field 27 (global Pervasives!)) x/62))
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)

-dlambda:
(seq
  (letrec
    (iter/58
       (function f/59 param/64
         (if param/64
           (seq (apply f/59 (field 0 param/64))
             (apply iter/58 f/59 (field 1 param/64)))
           0a)))
    (setfield_imm 0 (global Code!) iter/58))
  (apply (field 0 (global Code!))
    (function x/62 (apply (field 27 (global Pervasives!)) x/62))
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)

-dclosure:
(seq
  (let
    (clos/66
       (closure (camlCode__iter_58(2)  f/59 param/64
                 (if param/64
                   (seq (apply f/59 (field 0 param/64))
                     (camlCode__iter_58  f/59 (field 1 param/64)))
                   0a)) ))
    (setfield_imm 0 (global camlCode!) (offset[0] clos/66)))
  (camlCode__iter_58
    (closure (camlCode__fun_67(1)  x/62
              (camlPervasives__output_string_215
                (field 23 (global camlPervasives!))
                (camlPervasives__string_of_int_154  x/62))) )
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)

-dcmm:
(data int 1024 global "camlCode" "camlCode": skip 8)
(data int 2295 "camlCode__1": addr "camlCode__fun_67" int 3)
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter_58")
(data
 int 2048
 "camlCode__2":
 int 1
 addr L4
 int 2048
 L4:
 int 3
 addr L5
 int 2048
 L5:
 int 5
 int 1)
(function camlCode__iter_58 (f/59: addr param/64: addr)
 (if (!= param/64 1)
   (seq (app (load f/59) (load param/64) f/59 unit)
     (app "camlCode__iter_58" f/59 (load (+a param/64 8)) addr))
   1a))

(function camlCode__fun_67 (x/62: addr)
 (app{pervasives.ml:356,18-56} "camlPervasives__output_string_215"
   (load (+a "camlPervasives" 184))
   (app{pervasives.ml:356,39-56} "camlPervasives__string_of_int_154" x/62
     addr)
   addr))

(function camlCode__entry ()
 (let clos/66 "camlCode__3" (store "camlCode" clos/66))
 (app "camlCode__iter_58" "camlCode__1" "camlCode__2" unit) 1a)

(data)
*)


(*
-drawlambda
(seq
  (letrec
    (iter/1030
       (function f/1031 param/1036
         (if param/1036
           (let (l/1033 (field 1 param/1036) a/1032 (field 0 param/1036))
             (seq (apply f/1031 a/1032) (apply iter/1030 f/1031 l/1033)))
           0a)))
    (setfield_imm 0 (global Code!) iter/1030))
  (apply (field 0 (global Code!))
    (function x/1034 (apply (field 27 (global Pervasives!)) x/1034))
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)
-dlambda
(seq
  (letrec
    (iter/1030
       (function f/1031 param/1036
         (if param/1036
           (seq (apply f/1031 (field 0 param/1036))
             (apply iter/1030 f/1031 (field 1 param/1036)))
           0a)))
    (setfield_imm 0 (global Code!) iter/1030))
  (apply (field 0 (global Code!))
    (function x/1034 (apply (field 27 (global Pervasives!)) x/1034))
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)
checking tailcall on iter/1030
stats_rec_removed : 1
(iter_1030) 
stats_tailcall_removed : 1
(iter_1030) 
*** After TonLambda.optimize:
(seq
  (let
    (iter/1030
       (function f/1039 param/1040
         (let (param/1036 param/1040 f/1031 f/1039)
           (catch
             (while 1a
               (catch
                 (exit 2
                   (if param/1036
                     (seq (apply f/1031 (field 0 param/1036))
                       (let (arg/1037 (field 1 param/1036))
                         (seq (assign param/1036 arg/1037) (exit 1))))
                     0a))
                with (1) 0a))
            with (2 res/1038) res/1038))))
    (setfield_imm 0 (global Code!) iter/1030))
  (apply (field 0 (global Code!))
    (function x/1034 (apply (field 27 (global Pervasives!)) x/1034))
    [0: 0 [0: 1 [0: 2 0a]]])
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let
    (iter/1030
       (closure (camlCode__iter_1030(2)  f/1039 param/1040
                  (let
                    (param/1036[Variable] param/1040 f/1031[Variable] f/1039)
                    (catch
                      (while 1a
                        (catch
                          (exit 2
                            (if param/1036
                              (seq (apply f/1031 (field 0 param/1036))
                                (let (arg/1037 (field 1 param/1036))
                                  (seq (assign param/1036 arg/1037) (exit 1))))
                              0a))
                         with (1) 0a))
                     with (2 res/1038) res/1038))) {3} ))
    (setfield_imm 0 (global camlCode!) iter/1030))
  (let
    (f/1046
       (closure (camlCode__fun_1042(1)  x/1034
                  (let
                    (s/1044 (caml_format_int "%d" x/1034)
                     oc/1045 (field 23 (global camlPervasives!)))
                    (caml_ml_output oc/1045 s/1044 0 (string.length s/1044)))) 
         {2} )
     param/1047[Variable] [0: 0 [0: 1 [0: 2 0a]]]
     f/1048[Variable] f/1046)
    (catch
      (while 1a
        (catch
          (exit 2
            (if param/1047
              (seq (apply f/1048 (field 0 param/1047))
                (let (arg/1049 (field 1 param/1047))
                  (seq (assign param/1047 arg/1049) (exit 1))))
              0a))
         with (1) 0a))
     with (2 res/1038) res/1038))
  0a)
*** After TonClosure.optimize:
(let
  (iter/1030
     (closure (camlCode__iter_1030(2)  f/1039 param/1040
                (let (param/1036[Variable] param/1040 f/1031 f/1039)
                  (catch
                    (while 1a
                      (catch
                        (exit 2
                          (if param/1036
                            (seq (apply f/1031 (field 0 param/1036))
                              (let (arg/1037 (field 1 param/1036))
                                (seq (assign param/1036 arg/1037) (exit 1))))
                            0a))
                       with (1) 0a))
                   with (2 res/1038) res/1038))) {3} ))
  (seq (setfield_imm 0 (global camlCode!) iter/1030)
    (let (param/1047[Variable] [0: 0 [0: 1 [0: 2 0a]]])
      (catch
        (while 1a
          (catch
            (exit 2
              (if param/1047
                (let
                  (x/1050 (field 0 param/1047)
                   s/1051 (caml_format_int "%d" x/1050)
                   oc/1052 (field 23 (global camlPervasives!)))
                  (seq
                    (caml_ml_output oc/1052 s/1051 0 (string.length s/1051))
                    (let (arg/1049 (field 1 param/1047))
                      (seq (assign param/1047 arg/1049) (exit 1)))))
                0a))
           with (1) 0a))
       with (2 res/1038) res/1038))
    0a))

-dcmm
(data int 1024 global "camlCode" "camlCode": skip 4)
(data
 int 3319
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter_1030")
(data
 global "camlCode__1"
 int 2048
 "camlCode__1":
 int 1
 addr L3
 int 2048
 L3:
 int 3
 addr L4
 int 2048
 L4:
 int 5
 int 1)
(function camlCode__iter_1030 (f/1039: addr param/1040: addr)
 (let (param/1036 param/1040 f/1031 f/1039)
   (catch
     (loop
       (catch
         (exit 2
           (if (!= param/1036 1)
             (seq (app (load f/1031) (load param/1036) f/1031 unit)
               (let arg/1037 (load (+a param/1036 4))
                 (assign param/1036 arg/1037) (exit 1)))
             1a))
       with(1) []))
     1a
   with(2 res/1038) res/1038)))

(function camlCode__entry ()
 (let iter/1030 "camlCode__2" (store "camlCode" iter/1030)
   (let param/1047 "camlCode__1"
     (catch
       (loop
         (catch
           (exit 2
             (if (!= param/1047 1)
               (let
                 (x/1050 (load param/1047)
                  s/1051
                    (extcall "caml_format_int"{pervasives.ml:360,39-56}
                      "camlPervasives__8" x/1050 addr)
                  oc/1052 (load (+a "camlPervasives" 92)))
                 (extcall "caml_ml_output"{pervasives.ml:256,2-40} oc/1052
                   s/1051 1
                   (+
                     (<<
                       (let
                         tmp/1053 (- (<< (>>u (load (+a s/1051 -4)) 10) 2) 1)
                         (- tmp/1053
                           (load unsigned int8 (+a s/1051 tmp/1053))))
                       1)
                     1)
                   unit)
                 (let arg/1049 (load (+a param/1047 4))
                   (assign param/1047 arg/1049) (exit 1)))
               1a))
         with(1) []))
     with(2 res/1038) res/1038 []))
   1a))

(data)
-dlinear
Before simplify
camlCode__iter_1030:
                  spilled-param/18[s1] := param/10[%ebx] (spill)
                  spilled-f/19[s0] := f/11[%eax] (spill)
                  L101 [0]:
                  if param/10[%ebx] ==s 1 goto L102
                  A/13[%eax] := [param/10[%ebx]]
                  f/20[%ebx] := spilled-f/19[s0] (reload)
                  A/14[%ecx] := [f/20[%ebx]]
                  {spilled-param/18[s1]* spilled-f/19[s0]*}
                  call A/14[%ecx] R/0[%eax] R/1[%ebx]
                  param/10[%ebx] := spilled-param/18[s1] (reload)
                  arg/15[%ebx] := [param/10[%ebx] + 4]
                  spilled-param/18[s1] := param/10[%ebx] (spill)
                  goto L101
                  L102 [0]:
                  A/16[%eax] := 1
                  L100 [0]:
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__iter_1030:
  spilled-param/18[s1] := param/10[%ebx] (spill)
  spilled-f/19[s0] := f/11[%eax] (spill)
  L101 [3]:
  if param/10[%ebx] ==s 1 goto L102
  A/13[%eax] := [param/10[%ebx]]
  f/20[%ebx] := spilled-f/19[s0] (reload)
  A/14[%ecx] := [f/20[%ebx]]
  {spilled-param/18[s1]* spilled-f/19[s0]*}
  call A/14[%ecx] R/0[%eax] R/1[%ebx]
  param/10[%ebx] := spilled-param/18[s1] (reload)
  arg/15[%ebx] := [param/10[%ebx] + 4]
  spilled-param/18[s1] := param/10[%ebx] (spill)
  goto L101
  L102 [2]:
  A/16[%eax] := 1
  L100 [2]:
  reload retaddr
  return R/0[%eax]
  
Before simplify
camlCode__entry:
                  iter/8[%eax] := "camlCode__2"
                  ["camlCode"] := iter/8[%eax]
                  param/9[%eax] := "camlCode__1"
                  spilled-param/23[s0] := param/9[%eax] (spill)
                  L106 [0]:
                  if param/9[%eax] ==s 1 goto L107
                  x/11[%eax] := [param/9[%eax]]
                  push x/11[%eax]
                  push "camlPervasives__8"
                  {spilled-param/23[s0]*}
                  R/0[%eax] := extcall "caml_format_int"  (noalloc) {pervasives.ml:360,39-56}
                  offset stack -8
                  oc/13[%ebx] := ["camlPervasives" + 92]
                  A/14[%ecx] := [s/12[%eax] + -4]
                  I/15[%ecx] := I/15[%ecx] >>u 10
                  tmp/16[%ecx] := I/15[%ecx]  * 4 + -1
                  I/17[%edx] := unsigned int8[s/12[%eax] + tmp/16[%ecx]]
                  I/18[%ecx] := I/18[%ecx] - I/17[%edx]
                  I/19[%ecx] := I/18[%ecx]  * 2 + 1
                  push I/19[%ecx]
                  push 1
                  push s/12[%eax]
                  push oc/13[%ebx]
                  {spilled-param/23[s0]*}
                  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
                  offset stack -16
                  param/9[%eax] := spilled-param/23[s0] (reload)
                  arg/20[%eax] := [param/9[%eax] + 4]
                  spilled-param/23[s0] := param/9[%eax] (spill)
                  goto L106
                  L107 [0]:
                  A/21[%eax] := 1
                  L105 [0]:
                  A/22[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  iter/8[%eax] := "camlCode__2"
  ["camlCode"] := iter/8[%eax]
  param/9[%eax] := "camlCode__1"
  spilled-param/23[s0] := param/9[%eax] (spill)
  L106 [3]:
  if param/9[%eax] ==s 1 goto L107
  x/11[%eax] := [param/9[%eax]]
  push x/11[%eax]
  push "camlPervasives__8"
  {spilled-param/23[s0]*}
  R/0[%eax] := extcall "caml_format_int"  (noalloc) {pervasives.ml:360,39-56}
  offset stack -8
  oc/13[%ebx] := ["camlPervasives" + 92]
  A/14[%ecx] := [s/12[%eax] + -4]
  I/15[%ecx] := I/15[%ecx] >>u 10
  tmp/16[%ecx] := I/15[%ecx]  * 4 + -1
  I/17[%edx] := unsigned int8[s/12[%eax] + tmp/16[%ecx]]
  I/18[%ecx] := I/18[%ecx] - I/17[%edx]
  I/19[%ecx] := I/18[%ecx]  * 2 + 1
  push I/19[%ecx]
  push 1
  push s/12[%eax]
  push oc/13[%ebx]
  {spilled-param/23[s0]*}
  extcall "caml_ml_output"  (noalloc) {pervasives.ml:256,2-40}
  offset stack -16
  param/9[%eax] := spilled-param/23[s0] (reload)
  arg/20[%eax] := [param/9[%eax] + 4]
  spilled-param/23[s0] := param/9[%eax] (spill)
  goto L106
  L107 [2]:
  A/21[%eax] := 1
  L105 [2]:
  A/22[%eax] := 1
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
	.long	1024
	.globl	camlCode
camlCode:
	.space	4
	.data
	.long	3319
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__iter_1030
	.data
	.globl	camlCode__1
	.long	2048
camlCode__1:
	.long	1
	.long	.L100003
	.long	2048
.L100003:
	.long	3
	.long	.L100004
	.long	2048
.L100004:
	.long	5
	.long	1
	.text
	.align	16
	.globl	camlCode__iter_1030
camlCode__iter_1030:
	subl	$8, %esp
.L103:
	movl	%ebx, 4(%esp)
	movl	%eax, 0(%esp)
.L101:
	cmpl	$1, %ebx
	je	.L102
	movl	(%ebx), %eax
	movl	0(%esp), %ebx
	movl	(%ebx), %ecx
	call	*%ecx
.L104:
	movl	4(%esp), %ebx
	movl	4(%ebx), %ebx
	movl	%ebx, 4(%esp)
	jmp	.L101
	.align	16
.L102:
	movl	$1, %eax
.L100:
	addl	$8, %esp
	ret
	.type	camlCode__iter_1030,@function
	.size	camlCode__iter_1030,.-camlCode__iter_1030
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$4, %esp
.L108:
	movl	$camlCode__2, %eax
	movl	%eax, camlCode
	movl	$camlCode__1, %eax
	movl	%eax, 0(%esp)
.L106:
	cmpl	$1, %eax
	je	.L107
	movl	(%eax), %eax
	pushl	%eax
	pushl	$camlPervasives__8
	movl	$caml_format_int, %eax
	call	caml_c_call
.L109:
	addl	$8, %esp
	movl	camlPervasives + 92, %ebx
	movl	-4(%eax), %ecx
	shrl	$10, %ecx
	lea	-1(, %ecx, 4), %ecx
	movzbl	(%eax, %ecx), %edx
	subl	%edx, %ecx
	lea	1(%ecx, %ecx), %ecx
	pushl	%ecx
	pushl	$1
	pushl	%eax
	pushl	%ebx
	movl	$caml_ml_output, %eax
	call	caml_c_call
.L110:
	addl	$16, %esp
	movl	0(%esp), %eax
	movl	4(%eax), %eax
	movl	%eax, 0(%esp)
	jmp	.L106
.L107:
	movl	$1, %eax
.L105:
	movl	$1, %eax
	addl	$4, %esp
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
	.long	3
	.long	.L110
	.word	25
	.word	1
	.word	16
	.align	4
	.long	.L200000 - . + 0xa0000000
	.long	0x100020
	.long	.L109
	.word	17
	.word	1
	.word	8
	.align	4
	.long	.L200000 - . + 0xe0000000
	.long	0x168270
	.long	.L104
	.word	12
	.word	2
	.word	0
	.word	4
	.align	4
.L200000:
	.ascii	"pervasives.ml\0"
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

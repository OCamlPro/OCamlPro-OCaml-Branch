(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.
*)

let rec iter1 f l =
  match l with
      [] -> ()
    | a::l -> f a; iter1 f l

let computed1 =
  let list1 = ref [] in
  iter1 (fun x -> list1 := x :: !list1) [1; 2; 3; 4; 5];
    !list1

let computed2 =
  let list1 = ref [] in
  iter1 (fun (x,y) -> list1 := x :: !list1) [1,2; 2,3; 3,3; 4,5; 5,6];
    !list1

(*
-drawlambda
(seq
  (letrec
    (iter1/1030
       (function f/1031 l/1032
         (if l/1032
           (let (l/1034 (field 1 l/1032) a/1033 (field 0 l/1032))
             (seq (apply f/1031 a/1033) (apply iter1/1030 f/1031 l/1034)))
           0a)))
    (setfield_imm 0 (global Code!) iter1/1030))
  (let
    (computed1/1035
       (let (list1/1036 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function x/1037
               (setfield_ptr 0 list1/1036
                 (makeblock 0 x/1037 (field 0 list1/1036))))
             [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
           (field 0 list1/1036))))
    (setfield_imm 1 (global Code!) computed1/1035))
  (let
    (computed2/1038
       (let (list1/1039 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function (param/1045, param/1046)
               (let (y/1041 param/1046 x/1040 param/1045)
                 (setfield_ptr 0 list1/1039
                   (makeblock 0 x/1040 (field 0 list1/1039)))))
             [0:
              [0: 1 2]
              [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]])
           (field 0 list1/1039))))
    (setfield_imm 2 (global Code!) computed2/1038))
  0a)
New application site !
New tuplified application site !
lambda saved
typedtree saved
-dlambda
(seq
  (letrec
    (iter1/1030
       (function f/1031 l/1032
         (if l/1032
           (seq (apply f/1031 (field 0 l/1032))
             (apply iter1/1030 f/1031 (field 1 l/1032)))
           0a)))
    (setfield_imm 0 (global Code!) iter1/1030))
  (let
    (computed1/1035
       (let (list1/1036 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function x/1037
               (setfield_ptr 0 list1/1036
                 (makeblock 0 x/1037 (field 0 list1/1036))))
             [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
           (field 0 list1/1036))))
    (setfield_imm 1 (global Code!) computed1/1035))
  (let
    (computed2/1038
       (let (list1/1039 (makemutable 0 0a))
         (seq
           (apply (field 0 (global Code!))
             (function (param/1045, param/1046)
               (setfield_ptr 0 list1/1039
                 (makeblock 0 param/1045 (field 0 list1/1039))))
             [0:
              [0: 1 2]
              [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]])
           (field 0 list1/1039))))
    (setfield_imm 2 (global Code!) computed2/1038))
  0a)
checking tailcall on iter1/1030
found tailcall on iter1/1030
 After TonLambda.optimize (1 eliminations): 
 (seq
   (let
     (iter1/1030
        (function f/1049 l/1050
          (let (l/1032 l/1050 f/1031 f/1049)
            (catch
              (while 1a
                (catch
                  (exit 7
                    (if l/1032
                      (seq (apply f/1031 (field 0 l/1032))
                        (let (arg/1047 (field 1 l/1032))
                          (seq (assign l/1032 arg/1047) (exit 6))))
                      0a))
                 with (6) 0a))
             with (7 res/1048) res/1048))))
     (setfield_imm 0 (global Code!) iter1/1030))
   (let
     (computed1/1035
        (let (list1/1036 (makemutable 0 0a))
          (seq
            (apply (field 0 (global Code!))
              (function x/1037
                (setfield_ptr 0 list1/1036
                  (makeblock 0 x/1037 (field 0 list1/1036))))
              [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
            (field 0 list1/1036))))
     (setfield_imm 1 (global Code!) computed1/1035))
   (let
     (computed2/1038
        (let (list1/1039 (makemutable 0 0a))
          (seq
            (apply (field 0 (global Code!))
              (function (param/1045, param/1046)
                (setfield_ptr 0 list1/1039
                  (makeblock 0 param/1045 (field 0 list1/1039))))
              [0:
               [0: 1 2]
               [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]])
            (field 0 list1/1039))))
     (setfield_imm 2 (global Code!) computed2/1038))
   0a)
New application site !
New tuplified application site !
lambda saved
typedtree saved
-dclosure
New application site !
New tuplified application site !
(seq
  (let
    (iter1/1030
       (closure (camlCode__iter1_1030(2)  f/1049 l/1050
                 (let (l/1032 l/1050 f/1031 f/1049)
                   (catch
                     (while 1a
                       (catch
                         (exit 7
                           (if l/1032
                             (seq (apply f/1031 (field 0 l/1032))
                               (let (arg/1047 (field 1 l/1032))
                                 (seq (assign l/1032 arg/1047) (exit 6))))
                             0a))
                        with (6) 0a))
                    with (7 res/1048) res/1048))) ))
    (setfield_imm 0 (global camlCode!) iter1/1030))
  (let
    (computed1/1035
       (let (list1/1036 (makemutable 0 0a))
         (seq
           (let
             (f/1055
                (closure (camlCode__fun_1052(1)  x/1037 env/1054
                          (setfield_ptr 0 (field 2 env/1054)
                            (makeblock 0 x/1037 (field 0 (field 2 env/1054))))) 
                 
                 list1/1036)
              l/1056 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]
              f/1057 f/1055)
             (catch
               (while 1a
                 (catch
                   (exit 7
                     (if l/1056
                       (seq
                         (let (x/1066 (field 0 l/1056))
                           (setfield_ptr 0 (field 2 f/1057)
                             (makeblock 0 x/1066 (field 0 (field 2 f/1057)))))
                         (let (arg/1058 (field 1 l/1056))
                           (seq (assign l/1056 arg/1058) (exit 6))))
                       0a))
                  with (6) 0a))
              with (7 res/1048) res/1048))
           (field 0 list1/1036))))
    (setfield_imm 1 (global camlCode!) computed1/1035))
  (let
    (computed2/1038
       (let (list1/1039 (makemutable 0 0a))
         (seq
           (let
             (f/1062
                (closure (camlCode__fun_1059(-2)  param/1045 param/1046
                          env/1061
                          (setfield_ptr 0 (field 3 env/1061)
                            (makeblock 0 param/1045
                              (field 0 (field 3 env/1061))))) 
                                                              list1/1039)
              l/1063
                [0:
                 [0: 1 2]
                 [0: [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]]
              f/1064 f/1062)
             (catch
               (while 1a
                 (catch
                   (exit 7
                     (if l/1063
                       (seq
                         (let (arg/1067 (field 0 l/1063))
                           (seq (field 1 arg/1067)
                             (let (param/1069 (field 0 arg/1067))
                               (setfield_ptr 0 (field 3 f/1064)
                                 (makeblock 0 param/1069
                                   (field 0 (field 3 f/1064)))))))
                         (let (arg/1065 (field 1 l/1063))
                           (seq (assign l/1063 arg/1065) (exit 6))))
                       0a))
                  with (6) 0a))
              with (7 res/1048) res/1048))
           (field 0 list1/1039))))
    (setfield_imm 2 (global camlCode!) computed2/1038))
  0a)(seq
       (let
         (iter1/1030
            (closure (camlCode__iter1_1030(2)  f/1049 l/1050
                      (let (l/1032 l/1050 f/1031 f/1049)
                        (catch
                          (while 1a
                            (catch
                              (exit 7
                                (if l/1032
                                  (seq (apply f/1031 (field 0 l/1032))
                                    (let (arg/1047 (field 1 l/1032))
                                      (seq (assign l/1032 arg/1047) (exit 6))))
                                  0a))
                             with (6) 0a))
                         with (7 res/1048) res/1048))) ))
         (setfield_imm 0 (global camlCode!) iter1/1030))
       (let
         (computed1/1035
            (let (list1/1036 (makemutable 0 0a))
              (seq
                (let
                  (f/1055
                     (closure (camlCode__fun_1052(1)  x/1037 env/1054
                               (setfield_ptr 0 (field 2 env/1054)
                                 (makeblock 0 x/1037
                                   (field 0 (field 2 env/1054))))) 
                                                                   list1/1036)
                   l/1056 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]]
                   f/1057 f/1055)
                  (catch
                    (while 1a
                      (catch
                        (exit 7
                          (if l/1056
                            (seq
                              (let (x/1066 (field 0 l/1056))
                                (setfield_ptr 0 (field 2 f/1057)
                                  (makeblock 0 x/1066
                                    (field 0 (field 2 f/1057)))))
                              (let (arg/1058 (field 1 l/1056))
                                (seq (assign l/1056 arg/1058) (exit 6))))
                            0a))
                       with (6) 0a))
                   with (7 res/1048) res/1048))
                (field 0 list1/1036))))
         (setfield_imm 1 (global camlCode!) computed1/1035))
       (let
         (computed2/1038
            (let (list1/1039 (makemutable 0 0a))
              (seq
                (let
                  (f/1062
                     (closure (camlCode__fun_1059(-2)  param/1045 param/1046
                               env/1061
                               (setfield_ptr 0 (field 3 env/1061)
                                 (makeblock 0 param/1045
                                   (field 0 (field 3 env/1061))))) 
                                                                   list1/1039)
                   l/1063
                     [0:
                      [0: 1 2]
                      [0:
                       [0: 2 3] [0: [0: 3 3] [0: [0: 4 5] [0: [0: 5 6] 0a]]]]]
                   f/1064 f/1062)
                  (catch
                    (while 1a
                      (catch
                        (exit 7
                          (if l/1063
                            (seq
                              (let (arg/1067 (field 0 l/1063))
                                (seq (field 1 arg/1067)
                                  (let (param/1069 (field 0 arg/1067))
                                    (setfield_ptr 0 (field 3 f/1064)
                                      (makeblock 0 param/1069
                                        (field 0 (field 3 f/1064)))))))
                              (let (arg/1065 (field 1 l/1063))
                                (seq (assign l/1063 arg/1065) (exit 6))))
                            0a))
                       with (6) 0a))
                   with (7 res/1048) res/1048))
                (field 0 list1/1039))))
         (setfield_imm 2 (global camlCode!) computed2/1038))lambda saved
typedtree saved

-dcmm
New application site !
New tuplified application site !
(data int 3072 global "camlCode" "camlCode": skip 24)
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__iter1_1030")
(data
 global "camlCode__1"
 int 2048
 "camlCode__1":
 int 3
 addr L13
 int 2048
 L13:
 int 5
 addr L14
 int 2048
 L14:
 int 7
 addr L15
 int 2048
 L15:
 int 9
 addr L16
 int 2048
 L16:
 int 11
 int 1)
(data
 global "camlCode__2"
 int 2048
 "camlCode__2":
 addr L4
 addr L5
 int 2048
 L5:
 addr L6
 addr L7
 int 2048
 L7:
 addr L8
 addr L9
 int 2048
 L9:
 addr L10
 addr L11
 int 2048
 L11:
 addr L12
 int 1
 int 2048
 L12:
 int 11
 int 13
 int 2048
 L10:
 int 9
 int 11
 int 2048
 L8:
 int 7
 int 7
 int 2048
 L6:
 int 5
 int 7
 int 2048
 L4:
 int 3
 int 5)
(function camlCode__iter1_1030 (f/1049: addr l/1050: addr)
 (let (l/1032 l/1050 f/1031 f/1049)
   (catch
     (catch
       (loop
         (catch
           (exit 7
             (if (!= l/1032 1)
               (seq (app (load f/1031) (load l/1032) f/1031 unit)
                 (let arg/1047 (load (+a l/1032 8)) (assign l/1032 arg/1047)
                   (exit 6)))
               1a))
         with(6) []))
     with(10) []) 1a
   with(7 res/1048) res/1048)))

(function camlCode__fun_1052 (x/1037: addr env/1054: addr)
 (extcall "caml_modify" (load (+a env/1054 16))
   (alloc 2048 x/1037 (load (load (+a env/1054 16)))) unit)
 1a)

(function camlCode__fun_1059
     (param/1045: addr param/1046: addr env/1061: addr)
 (extcall "caml_modify" (load (+a env/1061 24))
   (alloc 2048 param/1045 (load (load (+a env/1061 24)))) unit)
 1a)

(function camlCode__entry ()
 (let iter1/1030 "camlCode__3" (store "camlCode" iter1/1030))
 (let
   computed1/1035
     (let list1/1036 (alloc 1024 1a)
       (let
         (f/1055 (alloc 3319 "camlCode__fun_1052" 3 list1/1036)
          l/1056 "camlCode__1" f/1057 f/1055)
         (catch
           (catch
             (loop
               (catch
                 (exit 7
                   (if (!= l/1056 1)
                     (seq
                       (let x/1066 (load l/1056)
                         (extcall "caml_modify" (load (+a f/1057 16))
                           (alloc 2048 x/1066 (load (load (+a f/1057 16))))
                           unit))
                       (let arg/1058 (load (+a l/1056 8))
                         (assign l/1056 arg/1058) (exit 6)))
                     1a))
               with(6) []))
           with(9) [])
         with(7 res/1048) res/1048 []))
       (load list1/1036))
   (store (+a "camlCode" 8) computed1/1035))
 (let
   computed2/1038
     (let list1/1039 (alloc 1024 1a)
       (let
         (f/1062
            (alloc 4343 "caml_tuplify2" -3 "camlCode__fun_1059" list1/1039)
          l/1063 "camlCode__2" f/1064 f/1062)
         (catch
           (catch
             (loop
               (catch
                 (exit 7
                   (if (!= l/1063 1)
                     (seq
                       (let arg/1067 (load l/1063) (load (+a arg/1067 8)) 
                         []
                         (let param/1069 (load arg/1067)
                           (extcall "caml_modify" (load (+a f/1064 24))
                             (alloc 2048 param/1069
                               (load (load (+a f/1064 24))))
                             unit)))
                       (let arg/1065 (load (+a l/1063 8))
                         (assign l/1063 arg/1065) (exit 6)))
                     1a))
               with(6) []))
           with(8) [])
         with(7 res/1048) res/1048 []))
       (load list1/1039))
   (store (+a "camlCode" 16) computed2/1038))
 1a)

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
	.quad	3072
	.globl	camlCode
camlCode:
	.space	24
	.data
	.quad	3319
camlCode__3:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__iter1_1030
	.data
	.globl	camlCode__1
	.quad	2048
camlCode__1:
	.quad	3
	.quad	.L100013
	.quad	2048
.L100013:
	.quad	5
	.quad	.L100014
	.quad	2048
.L100014:
	.quad	7
	.quad	.L100015
	.quad	2048
.L100015:
	.quad	9
	.quad	.L100016
	.quad	2048
.L100016:
	.quad	11
	.quad	1
	.data
	.globl	camlCode__2
	.quad	2048
camlCode__2:
	.quad	.L100004
	.quad	.L100005
	.quad	2048
.L100005:
	.quad	.L100006
	.quad	.L100007
	.quad	2048
.L100007:
	.quad	.L100008
	.quad	.L100009
	.quad	2048
.L100009:
	.quad	.L100010
	.quad	.L100011
	.quad	2048
.L100011:
	.quad	.L100012
	.quad	1
	.quad	2048
.L100012:
	.quad	11
	.quad	13
	.quad	2048
.L100010:
	.quad	9
	.quad	11
	.quad	2048
.L100008:
	.quad	7
	.quad	7
	.quad	2048
.L100006:
	.quad	5
	.quad	7
	.quad	2048
.L100004:
	.quad	3
	.quad	5
	.text
	.align	16
	.globl	camlCode__iter1_1030
camlCode__iter1_1030:
	subq	$24, %rsp
.L104:
	movq	%rbx, 8(%rsp)
	movq	%rax, 0(%rsp)
.L102:
	cmpq	$1, %rbx
	je	.L103
	movq	(%rbx), %rax
	movq	0(%rsp), %rbx
	movq	(%rbx), %rdi
	call	*%rdi
.L105:
	movq	8(%rsp), %rbx
	movq	8(%rbx), %rbx
	movq	%rbx, 8(%rsp)
	jmp	.L102
	.align	4
.L103:
	movq	$1, %rax
	jmp	.L100
	.align	4
.L101:
	movq	$1, %rax
	addq	$24, %rsp
	ret
	.align	4
.L100:
	addq	$24, %rsp
	ret
	.type	camlCode__iter1_1030,@function
	.size	camlCode__iter1_1030,.-camlCode__iter1_1030
	.text
	.align	16
	.globl	camlCode__fun_1052
camlCode__fun_1052:
	subq	$8, %rsp
.L106:
	movq	%rax, %rdi
.L107:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L108
	leaq	8(%r15), %rsi
	movq	$2048, -8(%rsi)
	movq	%rdi, (%rsi)
	movq	16(%rbx), %rax
	movq	(%rax), %rax
	movq	%rax, 8(%rsi)
	movq	16(%rbx), %rdi
	call	caml_modify@PLT
	movq	$1, %rax
	addq	$8, %rsp
	ret
.L108:	call	caml_call_gc@PLT
.L109:	jmp	.L107
	.type	camlCode__fun_1052,@function
	.size	camlCode__fun_1052,.-camlCode__fun_1052
	.text
	.align	16
	.globl	camlCode__fun_1059
camlCode__fun_1059:
	subq	$8, %rsp
.L110:
	movq	%rax, %rdx
.L111:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L112
	leaq	8(%r15), %rsi
	movq	$2048, -8(%rsi)
	movq	%rdx, (%rsi)
	movq	24(%rdi), %rax
	movq	(%rax), %rax
	movq	%rax, 8(%rsi)
	movq	24(%rdi), %rdi
	call	caml_modify@PLT
	movq	$1, %rax
	addq	$8, %rsp
	ret
.L112:	call	caml_call_gc@PLT
.L113:	jmp	.L111
	.type	camlCode__fun_1059,@function
	.size	camlCode__fun_1059,.-camlCode__fun_1059
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$8, %rsp
.L120:
	movq	camlCode__3@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	$48, %rax
	call	caml_allocN@PLT
.L121:
	leaq	8(%r15), %r12
	movq	$1024, -8(%r12)
	movq	$1, (%r12)
	leaq	16(%r12), %rbp
	movq	$3319, -8(%rbp)
	movq	camlCode__fun_1052@GOTPCREL(%rip), %rax
	movq	%rax, (%rbp)
	movq	$3, 8(%rbp)
	movq	%r12, 16(%rbp)
	movq	camlCode__1@GOTPCREL(%rip), %rbx
.L118:
	cmpq	$1, %rbx
	je	.L119
	movq	(%rbx), %rdi
	call	caml_alloc2@PLT
.L122:
	leaq	8(%r15), %rsi
	movq	$2048, -8(%rsi)
	movq	%rdi, (%rsi)
	movq	16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, 8(%rsi)
	movq	16(%rbp), %rdi
	call	caml_modify@PLT
	movq	8(%rbx), %rbx
	jmp	.L118
.L119:
	movq	$1, %rax
.L117:
	movq	(%r12), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	$56, %rax
	call	caml_allocN@PLT
.L123:
	leaq	8(%r15), %r12
	movq	$1024, -8(%r12)
	movq	$1, (%r12)
	leaq	16(%r12), %rbp
	movq	$4343, -8(%rbp)
	movq	caml_tuplify2@GOTPCREL(%rip), %rax
	movq	%rax, (%rbp)
	movq	$-3, 8(%rbp)
	movq	camlCode__fun_1059@GOTPCREL(%rip), %rax
	movq	%rax, 16(%rbp)
	movq	%r12, 24(%rbp)
	movq	camlCode__2@GOTPCREL(%rip), %rbx
.L115:
	cmpq	$1, %rbx
	je	.L116
	movq	(%rbx), %rdi
	movq	8(%rdi), %rax
	movq	(%rdi), %rdi
	call	caml_alloc2@PLT
.L124:
	leaq	8(%r15), %rsi
	movq	$2048, -8(%rsi)
	movq	%rdi, (%rsi)
	movq	24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, 8(%rsi)
	movq	24(%rbp), %rdi
	call	caml_modify@PLT
	movq	8(%rbx), %rbx
	jmp	.L115
.L116:
	movq	$1, %rax
.L114:
	movq	(%r12), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 16(%rax)
	movq	$1, %rax
	addq	$8, %rsp
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
	.quad	7
	.quad	.L124
	.word	16
	.word	4
	.word	5
	.word	21
	.word	3
	.word	23
	.align	8
	.quad	.L123
	.word	16
	.word	0
	.align	8
	.quad	.L122
	.word	16
	.word	4
	.word	5
	.word	21
	.word	3
	.word	23
	.align	8
	.quad	.L121
	.word	16
	.word	0
	.align	8
	.quad	.L113
	.word	16
	.word	2
	.word	5
	.word	9
	.align	8
	.quad	.L109
	.word	16
	.word	2
	.word	3
	.word	5
	.align	8
	.quad	.L105
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.section .note.GNU-stack,"",%progbits
*)



let rec iter f = function
    [] -> ()
  | x :: tail -> f x; iter f tail

let list = [1;2;3;4;5]

let sum =
  let sum = ref 0 in
    List.iter (fun x -> sum := !sum + x) list;
    !sum



(*
-drawlambda
(seq
  (letrec
    (iter/1030
       (function f/1031 param/1041
         (if param/1041
           (let (tail/1033 (field 1 param/1041) x/1032 (field 0 param/1041))
             (seq (apply f/1031 x/1032) (apply iter/1030 f/1031 tail/1033)))
           0a)))
    (setfield_imm 0 (global Code!) iter/1030))
  (let (list/1034 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global Code!) list/1034))
  (let
    (sum/1035
       (let (sum/1036 (makemutable 0 0))
         (seq
           (apply (field 10 (global List!))
             (function x/1037
               (setfield_imm 0 sum/1036 (+ (field 0 sum/1036) x/1037)))
             (field 1 (global Code!)))
           (field 0 sum/1036))))
    (setfield_imm 2 (global Code!) sum/1035))
  0a)
-dlambda
(seq
  (letrec
    (iter/1030
       (function f/1031 param/1041
         (if param/1041
           (seq (apply f/1031 (field 0 param/1041))
             (apply iter/1030 f/1031 (field 1 param/1041)))
           0a)))
    (setfield_imm 0 (global Code!) iter/1030))
  (let (list/1034 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global Code!) list/1034))
  (let
    (sum/1035
       (let (sum/1036 (makemutable 0 0))
         (seq
           (apply (field 10 (global List!))
             (function x/1037
               (setfield_imm 0 sum/1036 (+ (field 0 sum/1036) x/1037)))
             (field 1 (global Code!)))
           (field 0 sum/1036))))
    (setfield_imm 2 (global Code!) sum/1035))
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
       (function f/1044 param/1045
         (let (param/1041 param/1045 f/1031 f/1044)
           (catch
             (while 1a
               (catch
                 (exit 5
                   (if param/1041
                     (seq (apply f/1031 (field 0 param/1041))
                       (let (arg/1042 (field 1 param/1041))
                         (seq (assign param/1041 arg/1042) (exit 4))))
                     0a))
                with (4) 0a))
            with (5 res/1043) res/1043))))
    (setfield_imm 0 (global Code!) iter/1030))
  (let (list/1034 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global Code!) list/1034))
  (let
    (sum/1035
       (let (sum/1036 (makemutable 0 0))
         (seq
           (apply (field 10 (global List!))
             (function x/1037
               (setfield_imm 0 sum/1036 (+ (field 0 sum/1036) x/1037)))
             (field 1 (global Code!)))
           (field 0 sum/1036))))
    (setfield_imm 2 (global Code!) sum/1035))
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let
    (iter/1030
       (closure (camlCode__iter_1030(2)  f/1044 param/1045
                  (let
                    (param/1041[Variable] param/1045 f/1031[Variable] f/1044)
                    (catch
                      (while 1a
                        (catch
                          (exit 5
                            (if param/1041
                              (seq (apply f/1031 (field 0 param/1041))
                                (let (arg/1042 (field 1 param/1041))
                                  (seq (assign param/1041 arg/1042) (exit 4))))
                              0a))
                         with (4) 0a))
                     with (5 res/1043) res/1043))) {3} ))
    (setfield_imm 0 (global camlCode!) iter/1030))
  (let (list/1034 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
    (setfield_imm 1 (global camlCode!) list/1034))
  (let
    (sum/1035
       (let (sum/1036 (makemutable 0 0))
         (seq
           (let
             (param/1050 (field 1 (global camlCode!))
              f/1051
                (closure (camlCode__fun_1047(1)  x/1037 env/1049
                           (setfield_imm 0 (field 2 env/1049)
                             (+ (field 0 (field 2 env/1049)) x/1037))) 
                  {2} 
                  sum/1036)
              param/1052[Variable] param/1050
              f/1053[Variable] f/1051)
             (catch
               (while 1a
                 (catch
                   (exit 71
                     (if param/1052
                       (let
                         (l/1054[Alias] (field 1 param/1052)
                          a/1055[Alias] (field 0 param/1052))
                         (seq (apply f/1053 a/1055)
                           (let (arg/1056 l/1054)
                             (seq (assign param/1052 arg/1056) (exit 70)))))
                       0a))
                  with (70) 0a))
              with (71 res/1450) res/1450))
           (field 0 sum/1036))))
    (setfield_imm 2 (global camlCode!) sum/1035))
  0a)
*** After TonClosure.optimize:
(let
  (iter/1030
     (closure (camlCode__iter_1030(2)  f/1044 param/1045
                (let (param/1041[Variable] param/1045 f/1031 f/1044)
                  (catch
                    (while 1a
                      (catch
                        (exit 5
                          (if param/1041
                            (seq (apply f/1031 (field 0 param/1041))
                              (let (arg/1042 (field 1 param/1041))
                                (seq (assign param/1041 arg/1042) (exit 4))))
                            0a))
                       with (4) 0a))
                   with (5 res/1043) res/1043))) {3} ))
  (seq (setfield_imm 0 (global camlCode!) iter/1030)
    (let (list/1034 [0: 1 [0: 2 [0: 3 [0: 4 [0: 5 0a]]]]])
      (seq (setfield_imm 1 (global camlCode!) list/1034)
        (let
          (sum/1036[Variable] 0
           param/1050 (field 1 (global camlCode!))
           sum/1035
             (seq
               (let (param/1052[Variable] param/1050)
                 (catch
                   (while 1a
                     (catch
                       (exit 71
                         (if param/1052
                           (let
                             (l/1054[Alias] (field 1 param/1052)
                              a/1055[Alias] (field 0 param/1052))
                             (seq (assign sum/1036 (+ sum/1036 a/1055))
                               (assign param/1052 l/1054) (exit 70)))
                           0a))
                      with (70) 0a))
                  with (71 res/1450) res/1450))
               sum/1036))
          (seq (setfield_imm 2 (global camlCode!) sum/1035) 0a))))))

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 12)
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
 int 3
 addr L3
 int 2048
 L3:
 int 5
 addr L4
 int 2048
 L4:
 int 7
 addr L5
 int 2048
 L5:
 int 9
 addr L6
 int 2048
 L6:
 int 11
 int 1)
(function camlCode__iter_1030 (f/1044: addr param/1045: addr)
 (let (param/1041 param/1045 f/1031 f/1044)
   (catch
     (loop
       (catch
         (exit 5
           (if (!= param/1041 1)
             (seq (app (load f/1031) (load param/1041) f/1031 unit)
               (let arg/1042 (load (+a param/1041 4))
                 (assign param/1041 arg/1042) (exit 4)))
             1a))
       with(4) []))
     1a
   with(5 res/1043) res/1043)))

(function camlCode__entry ()
 (let iter/1030 "camlCode__2" (store "camlCode" iter/1030)
   (let list/1034 "camlCode__1" (store (+a "camlCode" 4) list/1034)
     (let
       (sum/1036 1 param/1050 (load (+a "camlCode" 4))
        sum/1035
          (seq
            (let param/1052 param/1050
              (catch
                (loop
                  (catch
                    (exit 71
                      (if (!= param/1052 1)
                        (let
                          (l/1054 (load (+a param/1052 4))
                           a/1055 (load param/1052))
                          (assign sum/1036 (+ (+ sum/1036 a/1055) -1))
                          (assign param/1052 l/1054) (exit 70))
                        1a))
                  with(70) []))
              with(71 res/1450) res/1450 []))
            sum/1036))
       (store (+a "camlCode" 8) sum/1035) 1a))))

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
                  list/9[%eax] := "camlCode__1"
                  ["camlCode" + 4] := list/9[%eax]
                  sum/10[%eax] := 1
                  param/11[%ebx] := ["camlCode" + 4]
                  L106 [0]:
                  if param/12[%ebx] ==s 1 goto L107
                  l/14[%ecx] := [param/12[%ebx] + 4]
                  a/15[%ebx] := [param/12[%ebx]]
                  I/16[%eax] := sum/10[%eax] + a/15[%ebx] + -1
                  param/12[%ebx] := l/14[%ecx]
                  goto L106
                  L107 [0]:
                  A/17[%ebx] := 1
                  L105 [0]:
                  ["camlCode" + 8] := sum/18[%eax]
                  A/19[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  iter/8[%eax] := "camlCode__2"
  ["camlCode"] := iter/8[%eax]
  list/9[%eax] := "camlCode__1"
  ["camlCode" + 4] := list/9[%eax]
  sum/10[%eax] := 1
  param/11[%ebx] := ["camlCode" + 4]
  L106 [3]:
  if param/12[%ebx] ==s 1 goto L107
  l/14[%ecx] := [param/12[%ebx] + 4]
  a/15[%ebx] := [param/12[%ebx]]
  I/16[%eax] := sum/10[%eax] + a/15[%ebx] + -1
  param/12[%ebx] := l/14[%ecx]
  goto L106
  L107 [2]:
  A/17[%ebx] := 1
  L105 [2]:
  ["camlCode" + 8] := sum/18[%eax]
  A/19[%eax] := 1
  return R/0[%eax]
  
-S
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.long	3072
	.globl	camlCode
camlCode:
	.space	12
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
	.long	3
	.long	.L100003
	.long	2048
.L100003:
	.long	5
	.long	.L100004
	.long	2048
.L100004:
	.long	7
	.long	.L100005
	.long	2048
.L100005:
	.long	9
	.long	.L100006
	.long	2048
.L100006:
	.long	11
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
.L108:
	movl	$camlCode__2, %eax
	movl	%eax, camlCode
	movl	$camlCode__1, %eax
	movl	%eax, camlCode + 4
	movl	$1, %eax
	movl	camlCode + 4, %ebx
.L106:
	cmpl	$1, %ebx
	je	.L107
	movl	4(%ebx), %ecx
	movl	(%ebx), %ebx
	lea	-1(%eax, %ebx), %eax
	movl	%ecx, %ebx
	jmp	.L106
.L107:
	movl	$1, %ebx
.L105:
	movl	%eax, camlCode + 8
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
	.long	.L104
	.word	12
	.word	2
	.word	0
	.word	4
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

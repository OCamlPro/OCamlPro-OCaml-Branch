  
  
let runs = 100
let max_iterations = 1000

let iterate ci cr =
  let bailout = 4.0 in
  let rec loop zi zr i =
    if i > max_iterations then
      0
    else
      let temp = zr *. zi and
	  zr2 = zr *. zr and
	  zi2 = zi *. zi in
	if zi2 +. zr2 > bailout then
	  i
	else
	  loop (temp +. temp +. ci) (zr2 -. zi2 +. cr) (i + 1)
  in
    loop 0.0 0.0 1

let mandelbrot n =
  for y = -39 to 38 do
    if 1 = n then print_endline "";
    for x = -39 to 38 do
      let i = iterate
          (float x /. 40.0) (float y /. 40.0 -. 0.5) in
      if 1 = n then
        print_string ( if 0 = i then "*" else " " );
    done
  done;;

let _ =
  let start_time = Sys.time () in
  for iter = 1 to runs do
    mandelbrot iter
  done;
  print_endline "";
  print_float ( Sys.time () -. start_time );
  print_endline "";
(*
-drawlambda
(seq (let (runs/1030 100) (setfield_imm 0 (global Code!) runs/1030))
  (let (max_iterations/1031 1000)
    (setfield_imm 1 (global Code!) max_iterations/1031))
  (let
    (iterate/1032
       (function ci/1033 cr/1034
         (let (bailout/1035 4.0)
           (letrec
             (loop/1036
                (function zi/1037 zr/1038 i/1039
                  (if (> i/1039 (field 1 (global Code!))) 0
                    (let
                      (temp/1040 (*. zr/1038 zi/1037)
                       zr2/1041 (*. zr/1038 zr/1038)
                       zi2/1042 (*. zi/1037 zi/1037))
                      (if (>. (+. zi2/1042 zr2/1041) bailout/1035) i/1039
                        (apply loop/1036
                          (+. (+. temp/1040 temp/1040) ci/1033)
                          (+. (-. zr2/1041 zi2/1042) cr/1034) (+ i/1039 1)))))))
             (apply loop/1036 0.0 0.0 1)))))
    (setfield_imm 2 (global Code!) iterate/1032))
  (let
    (mandelbrot/1043
       (function n/1044
         (for y/1045 -39 to 38
           (seq
             (if (== 1 n/1044) (apply (field 29 (global Pervasives!)) "") 0a)
             (for x/1046 -39 to 38
               (let
                 (i/1047
                    (apply (field 2 (global Code!))
                      (/. (float_of_int x/1046) 40.0)
                      (-. (/. (float_of_int y/1045) 40.0) 0.5)))
                 (if (== 1 n/1044)
                   (apply (field 26 (global Pervasives!))
                     (if (== 0 i/1047) "*" " "))
                   0a)))))))
    (setfield_imm 3 (global Code!) mandelbrot/1043))
  (let (start_time/1048 (caml_sys_time 0a))
    (seq
      (for iter/1049 1 to (field 0 (global Code!))
        (apply (field 3 (global Code!)) iter/1049))
      (apply (field 29 (global Pervasives!)) "")
      (apply (field 28 (global Pervasives!))
        (-. (caml_sys_time 0a) start_time/1048))
      (apply (field 29 (global Pervasives!)) "")))
  0a)
-dlambda
(seq (let (runs/1030 100) (setfield_imm 0 (global Code!) runs/1030))
  (let (max_iterations/1031 1000)
    (setfield_imm 1 (global Code!) max_iterations/1031))
  (let
    (iterate/1032
       (function ci/1033 cr/1034
         (let (bailout/1035 4.0)
           (letrec
             (loop/1036
                (function zi/1037 zr/1038 i/1039
                  (if (> i/1039 (field 1 (global Code!))) 0
                    (let
                      (temp/1040 (*. zr/1038 zi/1037)
                       zr2/1041 (*. zr/1038 zr/1038)
                       zi2/1042 (*. zi/1037 zi/1037))
                      (if (>. (+. zi2/1042 zr2/1041) bailout/1035) i/1039
                        (apply loop/1036
                          (+. (+. temp/1040 temp/1040) ci/1033)
                          (+. (-. zr2/1041 zi2/1042) cr/1034) (+ i/1039 1)))))))
             (apply loop/1036 0.0 0.0 1)))))
    (setfield_imm 2 (global Code!) iterate/1032))
  (let
    (mandelbrot/1043
       (function n/1044
         (for y/1045 -39 to 38
           (seq
             (if (== 1 n/1044) (apply (field 29 (global Pervasives!)) "") 0a)
             (for x/1046 -39 to 38
               (let
                 (i/1047
                    (apply (field 2 (global Code!))
                      (/. (float_of_int x/1046) 40.0)
                      (-. (/. (float_of_int y/1045) 40.0) 0.5)))
                 (if (== 1 n/1044)
                   (apply (field 26 (global Pervasives!))
                     (if (== 0 i/1047) "*" " "))
                   0a)))))))
    (setfield_imm 3 (global Code!) mandelbrot/1043))
  (let (start_time/1048 (caml_sys_time 0a))
    (seq
      (for iter/1049 1 to (field 0 (global Code!))
        (apply (field 3 (global Code!)) iter/1049))
      (apply (field 29 (global Pervasives!)) "")
      (apply (field 28 (global Pervasives!))
        (-. (caml_sys_time 0a) start_time/1048))
      (apply (field 29 (global Pervasives!)) "")))
  0a)

-dcmm
(data int 4096 global "camlCode" "camlCode": skip 16)
(data int 2295 "camlCode__3": addr "camlCode__mandelbrot_1043" int 3)
(data
 int 3319
 "camlCode__4":
 addr "caml_curry2"
 int 5
 addr "camlCode__iterate_1032")
(data int 1276 "camlCode__1": string "" skip 3 byte 3)
(data int 1276 "camlCode__2": string "" skip 3 byte 3)
(data int 1276 "camlCode__5": string " " skip 2 byte 2)
(data int 1276 "camlCode__6": string "*" skip 2 byte 2)
(data int 1276 "camlCode__7": string "" skip 3 byte 3)
(data int 2301 "camlCode__8": double 0.0)
(data int 2301 "camlCode__9": double 0.0)
(function camlCode__loop_1036
     (zi/1037: addr zr/1038: addr i/1039: addr env/1056: addr)
 (if (> i/1039 2001) 1
   (let
     (temp/1066 (*f (load float64u zr/1038) (load float64u zi/1037))
      zr2/1067 (*f (load float64u zr/1038) (load float64u zr/1038))
      zi2/1068 (*f (load float64u zi/1037) (load float64u zi/1037)))
     (if (>f (+f zi2/1068 zr2/1067) (load float64u (load (+a env/1056 20))))
       i/1039
       (app "camlCode__loop_1036"
         (alloc 2301
           (+f (+f temp/1066 temp/1066)
             (load float64u (load (+a env/1056 12)))))
         (alloc 2301
           (+f (-f zr2/1067 zi2/1068)
             (load float64u (load (+a env/1056 16)))))
         (+ i/1039 2) env/1056 addr)))))

(function camlCode__iterate_1032 (ci/1033: addr cr/1034: addr)
 (let
   (bailout/1065 4.0 bailout/1035 (alloc 2301 bailout/1065)
    clos/1057
      (alloc 6391 "caml_curry3" 7 "camlCode__loop_1036" ci/1033 cr/1034
        bailout/1035))
   (app "camlCode__loop_1036" "camlCode__8" "camlCode__9" 3 clos/1057 addr)))

(function camlCode__mandelbrot_1043 (n/1044: addr)
 (let y/1045 -77
   (catch
     (if (> y/1045 77) (exit 12)
       (loop
         (if (== 3 n/1044)
           (app "camlPervasives__print_endline_1274" "camlCode__7" unit) 
           [])
         (let x/1046 -77
           (catch
             (if (> x/1046 77) (exit 13)
               (loop
                 (let
                   i/1047
                     (app "camlCode__iterate_1032"
                       (alloc 2301 (/f (floatofint (>>s x/1046 1)) 40.0))
                       (alloc 2301
                         (-f (/f (floatofint (>>s y/1045 1)) 40.0) 0.5))
                       addr)
                   (if (== 3 n/1044)
                     (let
                       s/1059 (if (== 1 i/1047) "camlCode__6" "camlCode__5")
                       (app{pervasives.ml:359,21-43}
                         "camlPervasives__output_string_1191"
                         (load (+a "camlPervasives" 92)) s/1059 unit))
                     []))
                 (let x/1064 x/1046 (assign x/1046 (+ x/1046 2))
                   (if (== x/1064 77) (exit 13) []))))
           with(13) []))
         (let y/1063 y/1045 (assign y/1045 (+ y/1045 2))
           (if (== y/1063 77) (exit 12) []))))
   with(12) []))
 1a)

(function camlCode__entry ()
 (store "camlCode" 201) (store (+a "camlCode" 4) 2001)
 (let iterate/1032 "camlCode__4" (store (+a "camlCode" 8) iterate/1032))
 (let mandelbrot/1043 "camlCode__3"
   (store (+a "camlCode" 12) mandelbrot/1043))
 (let start_time/1048 (extcall "caml_sys_time" 1a addr)
   (let iter/1049 3
     (catch
       (if (> iter/1049 201) (exit 11)
         (loop (app "camlCode__mandelbrot_1043" iter/1049 unit)
           (let iter/1062 iter/1049 (assign iter/1049 (+ iter/1049 2))
             (if (== iter/1062 201) (exit 11) []))))
     with(11) []))
   (app "camlPervasives__print_endline_1274" "camlCode__2" unit)
   (let
     (f/1061
        (-f (load float64u (extcall "caml_sys_time" 1a addr))
          (load float64u start_time/1048))
      f/1060 (alloc 2301 f/1061))
     (app{pervasives.ml:361,20-60} "camlPervasives__output_string_1191"
       (load (+a "camlPervasives" 92))
       (app{pervasives.ml:361,41-60} "camlPervasives__string_of_float_1140"
         f/1060 addr)
       unit))
   (app "camlPervasives__print_endline_1274" "camlCode__1" unit))
 1a)

(data)
-dlinear
*** Linearized code
camlCode__loop_1036:
  if i/10[%ecx] <=s 2001 goto L101
  I/33[%eax] := 1
  reload retaddr
  return R/0[%eax]
  L101:
  R/7[%tos] := float64u[zr/9[%ebx]]
  R/7[%tos] := R/7[%tos] *f float64[zi/8[%eax]]
  temp/14[s2] := R/7[%tos]
  R/7[%tos] := float64u[zr/9[%ebx]]
  R/7[%tos] := R/7[%tos] *f float64[zr/9[%ebx]]
  zr2/17[s1] := R/7[%tos]
  R/7[%tos] := float64u[zi/8[%eax]]
  R/7[%tos] := R/7[%tos] *f float64[zi/8[%eax]]
  zi2/20[s0] := R/7[%tos]
  A/21[%eax] := [env/11[%edx] + 20]
  R/7[%tos] := float64u[A/21[%eax]]
  R/7[%tos] := zi2/20[s0] +f zr2/17[s1]
  if not R/7[%tos] >f R/7[%tos] goto L100
  R/0[%eax] := i/10[%ecx]
  reload retaddr
  return R/0[%eax]
  L100:
  {i/10[%ecx]* env/11[%edx]* temp/14[s2] zr2/17[s1] zi2/20[s0]}
  A/24[%ebx] := alloc 24
  [A/24[%ebx] + -4] := 2301
  A/25[%eax] := [env/11[%edx] + 16]
  R/7[%tos] := zr2/17[s1] -f zi2/20[s0]
  R/7[%tos] := R/7[%tos] +f float64[A/25[%eax]]
  float64u[A/24[%ebx]] := R/7[%tos]
  A/28[%eax] := A/24[%ebx] + 12
  [A/28[%eax] + -4] := 2301
  A/29[%esi] := [env/11[%edx] + 12]
  R/7[%tos] := temp/14[s2] +f temp/14[s2]
  R/7[%tos] := R/7[%tos] +f float64[A/29[%esi]]
  float64u[A/28[%eax]] := R/7[%tos]
  I/32[%ecx] := I/32[%ecx] + 2
  tailcall "camlCode__loop_1036" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  
*** Linearized code
camlCode__iterate_1032:
  ci/8[%ecx] := R/0[%eax]
  R/7[%tos] := 4.0
  bailout/11[s0] := R/7[%tos]
  {ci/8[%ecx]* cr/9[%ebx]* bailout/11[s0]}
  bailout/12[%eax] := alloc 40
  [bailout/12[%eax] + -4] := 2301
  float64u[bailout/12[%eax]] := bailout/11[s0]
  clos/13[%edx] := bailout/12[%eax] + 12
  [clos/13[%edx] + -4] := 6391
  [clos/13[%edx]] := "caml_curry3"
  [clos/13[%edx] + 4] := 7
  [clos/13[%edx] + 8] := "camlCode__loop_1036"
  [clos/13[%edx] + 12] := ci/8[%ecx]
  [clos/13[%edx] + 16] := cr/9[%ebx]
  [clos/13[%edx] + 20] := bailout/12[%eax]
  I/14[%ecx] := 3
  A/15[%ebx] := "camlCode__9"
  A/16[%eax] := "camlCode__8"
  tailcall "camlCode__loop_1036" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  
*** Linearized code
camlCode__mandelbrot_1043:
  y/9[%ebx] := -77
  if y/9[%ebx] >s 77 goto L111
  spilled-y/35[s0] := y/9[%ebx] (spill)
  spilled-n/34[s1] := n/8[%eax] (spill)
  L112:
  n/36[%eax] := spilled-n/34[s1] (reload)
  if n/36[%eax] !=s 3 goto L118
  A/10[%eax] := "camlCode__7"
  {spilled-n/34[s1]* spilled-y/35[s0]}
  call "camlPervasives__print_endline_1274" R/0[%eax]
  L118:
  x/11[%ebx] := -77
  spilled-x/33[s2] := x/11[%ebx] (spill)
  if x/11[%ebx] >s 77 goto L113
  L114:
  {x/11[%ebx] spilled-x/33[s2] spilled-n/34[s1]* spilled-y/35[s0]}
  A/12[%ecx] := alloc 24
  [A/12[%ecx] + -4] := 2301
  R/7[%tos] := 40.0
  y/37[%eax] := spilled-y/35[s0] (reload)
  I/14[%eax] := I/14[%eax] >>s 1
  R/7[%tos] := floatofint I/14[%eax]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  R/7[%tos] := 0.5
  R/7[%tos] := R/7[%tos] -f(rev) R/7[%tos]
  float64u[A/12[%ecx]] := R/7[%tos]
  A/19[%eax] := A/12[%ecx] + 12
  [A/19[%eax] + -4] := 2301
  R/7[%tos] := 40.0
  I/21[%ebx] := I/21[%ebx] >>s 1
  R/7[%tos] := floatofint I/21[%ebx]
  R/7[%tos] := R/7[%tos] /f R/7[%tos]
  float64u[A/19[%eax]] := R/7[%tos]
  R/1[%ebx] := A/12[%ecx]
  {spilled-x/33[s2] spilled-n/34[s1]* spilled-y/35[s0]}
  R/0[%eax] := call "camlCode__iterate_1032" R/0[%eax] R/1[%ebx]
  n/38[%ebx] := spilled-n/34[s1] (reload)
  if n/38[%ebx] !=s 3 goto L115
  if i/24[%eax] !=s 1 goto L117
  s/25[%ebx] := "camlCode__6"
  goto L116
  L117:
  A/26[%ebx] := "camlCode__5"
  L116:
  A/27[%eax] := ["camlPervasives" + 92]
  {spilled-x/33[s2] spilled-n/34[s1]* spilled-y/35[s0]}
  call "camlPervasives__output_string_1191" R/0[%eax] R/1[%ebx] {pervasives.ml:359,21-43}
  L115:
  x/11[%ebx] := spilled-x/33[s2] (reload)
  x/28[%eax] := x/11[%ebx]
  I/29[%ebx] := I/29[%ebx] + 2
  spilled-x/33[s2] := x/11[%ebx] (spill)
  if x/28[%eax] !=s 77 goto L114
  L113:
  y/40[%eax] := spilled-y/35[s0] (reload)
  y/30[%ebx] := y/40[%eax]
  I/31[%eax] := I/31[%eax] + 2
  spilled-y/35[s0] := y/40[%eax] (spill)
  if y/30[%ebx] !=s 77 goto L112
  L111:
  A/32[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
*** Linearized code
camlCode__entry:
  ["camlCode"] := 201
  ["camlCode" + 4] := 2001
  iterate/8[%eax] := "camlCode__4"
  ["camlCode" + 8] := iterate/8[%eax]
  mandelbrot/9[%eax] := "camlCode__3"
  ["camlCode" + 12] := mandelbrot/9[%eax]
  push 1
  {}
  R/0[%eax] := extcall "caml_sys_time"  (noalloc)
  offset stack -4
  spilled-start_time/26[s0] := start_time/10[%eax] (spill)
  iter/11[%eax] := 3
  if iter/11[%eax] >s 201 goto L129
  spilled-iter/25[s1] := iter/11[%eax] (spill)
  L130:
  {spilled-iter/25[s1] spilled-start_time/26[s0]*}
  call "camlCode__mandelbrot_1043" R/0[%eax]
  iter/11[%eax] := spilled-iter/25[s1] (reload)
  iter/12[%ebx] := iter/11[%eax]
  I/13[%eax] := I/13[%eax] + 2
  spilled-iter/25[s1] := iter/11[%eax] (spill)
  if iter/12[%ebx] !=s 201 goto L130
  L129:
  A/14[%eax] := "camlCode__2"
  {spilled-start_time/26[s0]*}
  call "camlPervasives__print_endline_1274" R/0[%eax]
  push 1
  {spilled-start_time/26[s0]*}
  R/0[%eax] := extcall "caml_sys_time"  (noalloc)
  offset stack -4
  R/7[%tos] := float64u[A/15[%eax]]
  F/17[s0] := R/7[%tos]
  start_time/28[%eax] := spilled-start_time/26[s0] (reload)
  R/7[%tos] := F/17[s0] -f float64[start_time/28[%eax]]
  f/19[s0] := R/7[%tos]
  {f/19[s0]}
  f/20[%eax] := alloc 12
  [f/20[%eax] + -4] := 2301
  float64u[f/20[%eax]] := f/19[s0]
  {}
  R/0[%eax] := call "camlPervasives__string_of_float_1140" R/0[%eax] {pervasives.ml:361,41-60}
  A/21[%ebx] := R/0[%eax]
  A/22[%eax] := ["camlPervasives" + 92]
  {}
  call "camlPervasives__output_string_1191" R/0[%eax] R/1[%ebx] {pervasives.ml:361,20-60}
  A/23[%eax] := "camlCode__1"
  {}
  call "camlPervasives__print_endline_1274" R/0[%eax]
  A/24[%eax] := 1
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
	.long	4096
	.globl	camlCode
camlCode:
	.space	16
	.data
	.long	2295
camlCode__3:
	.long	camlCode__mandelbrot_1043
	.long	3
	.data
	.long	3319
camlCode__4:
	.long	caml_curry2
	.long	5
	.long	camlCode__iterate_1032
	.data
	.long	1276
camlCode__1:
	.space	3
	.byte	3
	.data
	.long	1276
camlCode__2:
	.space	3
	.byte	3
	.data
	.long	1276
camlCode__5:
	.ascii	" "
	.space	2
	.byte	2
	.data
	.long	1276
camlCode__6:
	.ascii	"*"
	.space	2
	.byte	2
	.data
	.long	1276
camlCode__7:
	.space	3
	.byte	3
	.data
	.long	2301
camlCode__8:
	.long	0x0, 0x0
	.data
	.long	2301
camlCode__9:
	.long	0x0, 0x0
	.text
	.align	16
	.globl	camlCode__loop_1036
camlCode__loop_1036:
	subl	$24, %esp
.L102:
	cmpl	$2001, %ecx
	jle	.L101
	movl	$1, %eax
	addl	$24, %esp
	ret
	.align	16
.L101:
	fldl	(%ebx)
	fmull	(%eax)
	fstpl	16(%esp)
	fldl	(%ebx)
	fmull	(%ebx)
	fstpl	8(%esp)
	fldl	(%eax)
	fmull	(%eax)
	fstpl	0(%esp)
	movl	20(%edx), %eax
	fldl	(%eax)
	fldl	0(%esp)
	faddl	8(%esp)
	fcompp
	fnstsw	%ax
	andb	$69, %ah
	jne	.L100
	movl	%ecx, %eax
	addl	$24, %esp
	ret
	.align	16
.L100:
.L103:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L104
	leal	4(%eax), %ebx
	movl	$2301, -4(%ebx)
	movl	16(%edx), %eax
	fldl	8(%esp)
	fsubl	0(%esp)
	faddl	(%eax)
	fstpl	(%ebx)
	leal	12(%ebx), %eax
	movl	$2301, -4(%eax)
	movl	12(%edx), %esi
	fldl	16(%esp)
	faddl	16(%esp)
	faddl	(%esi)
	fstpl	(%eax)
	addl	$2, %ecx
	jmp	.L102
.L104:	call	caml_call_gc
.L105:	jmp	.L103
	.type	camlCode__loop_1036,@function
	.size	camlCode__loop_1036,.-camlCode__loop_1036
	.text
	.align	16
	.globl	camlCode__iterate_1032
camlCode__iterate_1032:
	subl	$8, %esp
.L106:
	movl	%eax, %ecx
	fldl	.L107
	fstpl	0(%esp)
.L108:	movl	caml_young_ptr, %eax
	subl	$40, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L109
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	0(%esp)
	fstpl	(%eax)
	leal	12(%eax), %edx
	movl	$6391, -4(%edx)
	movl	$caml_curry3, (%edx)
	movl	$7, 4(%edx)
	movl	$camlCode__loop_1036, 8(%edx)
	movl	%ecx, 12(%edx)
	movl	%ebx, 16(%edx)
	movl	%eax, 20(%edx)
	movl	$3, %ecx
	movl	$camlCode__9, %ebx
	movl	$camlCode__8, %eax
	addl	$8, %esp
	jmp	camlCode__loop_1036
.L109:	call	caml_call_gc
.L110:	jmp	.L108
	.data
.L107:	.long	0x0, 0x40100000
	.type	camlCode__iterate_1032,@function
	.size	camlCode__iterate_1032,.-camlCode__iterate_1032
	.text
	.align	16
	.globl	camlCode__mandelbrot_1043
camlCode__mandelbrot_1043:
	subl	$20, %esp
.L119:
	movl	$-77, %ebx
	cmpl	$77, %ebx
	jg	.L111
	movl	%ebx, 0(%esp)
	movl	%eax, 4(%esp)
.L112:
	movl	4(%esp), %eax
	cmpl	$3, %eax
	jne	.L118
	movl	$camlCode__7, %eax
	call	camlPervasives__print_endline_1274
.L120:
.L118:
	movl	$-77, %ebx
	movl	%ebx, 8(%esp)
	cmpl	$77, %ebx
	jg	.L113
.L114:
.L121:	movl	caml_young_ptr, %eax
	subl	$24, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L122
	leal	4(%eax), %ecx
	movl	$2301, -4(%ecx)
	fldl	.L124
	movl	0(%esp), %eax
	sarl	$1, %eax
	pushl	%eax
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	fldl	.L125
	fsubrp	%st, %st(1)
	fstpl	(%ecx)
	leal	12(%ecx), %eax
	movl	$2301, -4(%eax)
	fldl	.L126
	sarl	$1, %ebx
	pushl	%ebx
	fildl	(%esp)
	addl	$4, %esp
	fdivp	%st, %st(1)
	fstpl	(%eax)
	movl	%ecx, %ebx
	call	camlCode__iterate_1032
.L127:
	movl	4(%esp), %ebx
	cmpl	$3, %ebx
	jne	.L115
	cmpl	$1, %eax
	jne	.L117
	movl	$camlCode__6, %ebx
	jmp	.L116
	.align	16
.L117:
	movl	$camlCode__5, %ebx
.L116:
	movl	camlPervasives + 92, %eax
	call	camlPervasives__output_string_1191
.L128:
.L115:
	movl	8(%esp), %ebx
	movl	%ebx, %eax
	addl	$2, %ebx
	movl	%ebx, 8(%esp)
	cmpl	$77, %eax
	jne	.L114
.L113:
	movl	0(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 0(%esp)
	cmpl	$77, %ebx
	jne	.L112
.L111:
	movl	$1, %eax
	addl	$20, %esp
	ret
.L122:	call	caml_call_gc
.L123:	jmp	.L121
	.data
.L126:	.long	0x0, 0x40440000
	.data
.L125:	.long	0x0, 0x3fe00000
	.data
.L124:	.long	0x0, 0x40440000
	.type	camlCode__mandelbrot_1043,@function
	.size	camlCode__mandelbrot_1043,.-camlCode__mandelbrot_1043
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$16, %esp
.L131:
	movl	$201, camlCode
	movl	$2001, camlCode + 4
	movl	$camlCode__4, %eax
	movl	%eax, camlCode + 8
	movl	$camlCode__3, %eax
	movl	%eax, camlCode + 12
	pushl	$1
	movl	$caml_sys_time, %eax
	call	caml_c_call
.L132:
	addl	$4, %esp
	movl	%eax, 0(%esp)
	movl	$3, %eax
	cmpl	$201, %eax
	jg	.L129
	movl	%eax, 4(%esp)
.L130:
	call	camlCode__mandelbrot_1043
.L133:
	movl	4(%esp), %eax
	movl	%eax, %ebx
	addl	$2, %eax
	movl	%eax, 4(%esp)
	cmpl	$201, %ebx
	jne	.L130
.L129:
	movl	$camlCode__2, %eax
	call	camlPervasives__print_endline_1274
.L134:
	pushl	$1
	movl	$caml_sys_time, %eax
	call	caml_c_call
.L135:
	addl	$4, %esp
	fldl	(%eax)
	fstpl	8(%esp)
	movl	0(%esp), %eax
	fldl	8(%esp)
	fsubl	(%eax)
	fstpl	8(%esp)
	call	caml_alloc2
.L136:
	leal	4(%eax), %eax
	movl	$2301, -4(%eax)
	fldl	8(%esp)
	fstpl	(%eax)
	call	camlPervasives__string_of_float_1140
.L137:
	movl	%eax, %ebx
	movl	camlPervasives + 92, %eax
	call	camlPervasives__output_string_1191
.L138:
	movl	$camlCode__1, %eax
	call	camlPervasives__print_endline_1274
.L139:
	movl	$1, %eax
	addl	$16, %esp
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
	.long	14
	.long	.L139
	.word	20
	.word	0
	.align	4
	.long	.L138
	.word	21
	.word	0
	.align	4
	.long	.L200000 - . + 0xf0000000
	.long	0x169140
	.long	.L137
	.word	21
	.word	0
	.align	4
	.long	.L200000 - . + 0xf0000000
	.long	0x169290
	.long	.L136
	.word	20
	.word	0
	.align	4
	.long	.L135
	.word	24
	.word	1
	.word	4
	.align	4
	.long	.L134
	.word	20
	.word	1
	.word	0
	.align	4
	.long	.L133
	.word	20
	.word	1
	.word	0
	.align	4
	.long	.L132
	.word	24
	.word	0
	.align	4
	.long	.L128
	.word	25
	.word	1
	.word	4
	.align	4
	.long	.L200000 - . + 0xac000000
	.long	0x167150
	.long	.L127
	.word	24
	.word	1
	.word	4
	.align	4
	.long	.L123
	.word	24
	.word	1
	.word	4
	.align	4
	.long	.L120
	.word	24
	.word	1
	.word	4
	.align	4
	.long	.L110
	.word	12
	.word	2
	.word	3
	.word	5
	.align	4
	.long	.L105
	.word	28
	.word	2
	.word	7
	.word	5
	.align	4
.L200000:
	.ascii	"pervasives.ml\0"
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

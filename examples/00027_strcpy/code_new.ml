
let _ =
  let s = "a" ^ "b" ^ "c" in
  String.length s
  

(*
-drawlambda
(seq
  (let
    (s/1030
       (apply (field 15 (global Pervasives!)) "a"
         (apply (field 15 (global Pervasives!)) "b" "c")))
    (string.length s/1030))
  0a)
-dlambda
(seq
  (let
    (s/1030
       (apply (field 15 (global Pervasives!)) "a"
         (apply (field 15 (global Pervasives!)) "b" "c")))
    (string.length s/1030))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (s/1030
       (apply (field 15 (global Pervasives!)) "a"
         (apply (field 15 (global Pervasives!)) "b" "c")))
    (string.length s/1030))
  0a)
-dclosure
*** After Closure.intro:
(seq
  (let
    (s/1030
       (let
         (s2/1034
            (let
              (l1/1031 (string.length "b")
               l2/1032 (string.length "c")
               s/1033 (caml_create_string (+ l1/1031 l2/1032)))
              (seq (caml_blit_string "b" 0 s/1033 0 l1/1031)
                (caml_blit_string "c" 0 s/1033 l1/1031 l2/1032) s/1033))
          l1/1035 (string.length "a")
          l2/1036 (string.length s2/1034)
          s/1037 (caml_create_string (+ l1/1035 l2/1036)))
         (seq (caml_blit_string "a" 0 s/1037 0 l1/1035)
           (caml_blit_string s2/1034 0 s/1037 l1/1035 l2/1036) s/1037)))
    (string.length s/1030))
  0a)
*** After TonClosure.optimize:
(let
  (l1/1031 (string.length "b")
   l2/1032 (string.length "c")
   s/1033 (caml_create_string (+ l1/1031 l2/1032)))
  (seq
    (seq (caml_blit_string "b" 0 s/1033 0 l1/1031)
      (caml_blit_string "c" 0 s/1033 l1/1031 l2/1032) s/1033)
    (let
      (l1/1035 (string.length "a")
       l2/1036 (string.length s/1033)
       s/1037 (caml_create_string (+ l1/1035 l2/1036)))
      (seq
        (seq (caml_blit_string "a" 0 s/1037 0 l1/1035)
          (caml_blit_string s/1033 0 s/1037 l1/1035 l2/1036) s/1037)
        (string.length s/1037) 0a))))

-dcmm
(data int 0 global "camlCode" "camlCode": skip 0)
(data global "camlCode__1" int 1276 "camlCode__1": string "a" skip 2 byte 2)
(data global "camlCode__2" int 1276 "camlCode__2": string "b" skip 2 byte 2)
(data global "camlCode__3" int 1276 "camlCode__3": string "c" skip 2 byte 2)
(function camlCode__entry ()
 (let
   (l1/1031
      (+
        (<<
          (let tmp/1042 (- (<< (>>u (load (+a "camlCode__2" -4)) 10) 2) 1)
            (- tmp/1042 (load unsigned int8 (+a "camlCode__2" tmp/1042))))
          1)
        1)
    l2/1032
      (+
        (<<
          (let tmp/1041 (- (<< (>>u (load (+a "camlCode__3" -4)) 10) 2) 1)
            (- tmp/1041 (load unsigned int8 (+a "camlCode__3" tmp/1041))))
          1)
        1)
    s/1033
      (extcall "caml_create_string"{pervasives.ml:145,10-33}
        (+ (+ l1/1031 l2/1032) -1) addr))
   (extcall "caml_blit_string"{pervasives.ml:146,2-25} "camlCode__2" 1 s/1033
     1 l1/1031 unit)
   (extcall "caml_blit_string"{pervasives.ml:147,2-26} "camlCode__3" 1 s/1033
     l1/1031 l2/1032 unit)
   s/1033 []
   (let
     (l1/1035
        (+
          (<<
            (let tmp/1040 (- (<< (>>u (load (+a "camlCode__1" -4)) 10) 2) 1)
              (- tmp/1040 (load unsigned int8 (+a "camlCode__1" tmp/1040))))
            1)
          1)
      l2/1036
        (+
          (<<
            (let tmp/1039 (- (<< (>>u (load (+a s/1033 -4)) 10) 2) 1)
              (- tmp/1039 (load unsigned int8 (+a s/1033 tmp/1039))))
            1)
          1)
      s/1037
        (extcall "caml_create_string"{pervasives.ml:145,10-33}
          (+ (+ l1/1035 l2/1036) -1) addr))
     (extcall "caml_blit_string"{pervasives.ml:146,2-25} "camlCode__1" 1
       s/1037 1 l1/1035 unit)
     (extcall "caml_blit_string"{pervasives.ml:147,2-26} s/1033 1 s/1037
       l1/1035 l2/1036 unit)
     s/1037 []
     (+
       (<<
         (let tmp/1038 (- (<< (>>u (load (+a s/1037 -4)) 10) 2) 1)
           (- tmp/1038 (load unsigned int8 (+a s/1037 tmp/1038))))
         1)
       1)
     [] 1a)))

(data)
-dlinear
Before simplify
camlCode__entry:
                  A/8[%eax] := ["camlCode__2" + -4]
                  I/9[%eax] := I/9[%eax] >>u 10
                  tmp/10[%eax] := I/9[%eax]  * 4 + -1
                  A/11[%ebx] := "camlCode__2"
                  I/12[%ebx] := unsigned int8[A/11[%ebx] + tmp/10[%eax]]
                  I/13[%eax] := I/13[%eax] - I/12[%ebx]
                  l1/14[%eax] := I/13[%eax]  * 2 + 1
                  spilled-l1/50[s0] := l1/14[%eax] (spill)
                  A/15[%ebx] := ["camlCode__3" + -4]
                  I/16[%ebx] := I/16[%ebx] >>u 10
                  tmp/17[%ebx] := I/16[%ebx]  * 4 + -1
                  A/18[%ecx] := "camlCode__3"
                  I/19[%ecx] := unsigned int8[A/18[%ecx] + tmp/17[%ebx]]
                  I/20[%ebx] := I/20[%ebx] - I/19[%ecx]
                  l2/21[%ebx] := I/20[%ebx]  * 2 + 1
                  spilled-l2/49[s1] := l2/21[%ebx] (spill)
                  I/22[%eax] := l1/14[%eax] + l2/21[%ebx] + -1
                  push I/22[%eax]
                  {spilled-l2/49[s1] spilled-l1/50[s0]}
                  R/0[%eax] := extcall "caml_create_string"  (noalloc) {pervasives.ml:145,10-33}
                  offset stack -4
                  s/23[%ebx] := R/0[%eax]
                  spilled-s/46[s2] := s/23[%ebx] (spill)
                  l1/51[%esi] := spilled-l1/50[s0] (reload)
                  push l1/51[%esi]
                  push 1
                  push s/23[%ebx]
                  push 1
                  push "camlCode__2"
                  {s/23[%ebx]* spilled-s/46[s2]* spilled-l2/49[s1]
                   l1/51[%esi]}
                  extcall "caml_blit_string"  {pervasives.ml:146,2-25}
                  offset stack -20
                  l2/52[%eax] := spilled-l2/49[s1] (reload)
                  push l2/52[%eax]
                  push l1/51[%esi]
                  push s/23[%ebx]
                  push 1
                  push "camlCode__3"
                  {s/23[%ebx]* spilled-s/46[s2]*}
                  extcall "caml_blit_string"  {pervasives.ml:147,2-26}
                  offset stack -20
                  A/24[%eax] := ["camlCode__1" + -4]
                  I/25[%eax] := I/25[%eax] >>u 10
                  tmp/26[%eax] := I/25[%eax]  * 4 + -1
                  A/27[%ecx] := "camlCode__1"
                  I/28[%ecx] := unsigned int8[A/27[%ecx] + tmp/26[%eax]]
                  I/29[%eax] := I/29[%eax] - I/28[%ecx]
                  l1/30[%eax] := I/29[%eax]  * 2 + 1
                  spilled-l1/48[s0] := l1/30[%eax] (spill)
                  A/31[%ecx] := [s/23[%ebx] + -4]
                  I/32[%ecx] := I/32[%ecx] >>u 10
                  tmp/33[%ecx] := I/32[%ecx]  * 4 + -1
                  I/34[%ebx] := unsigned int8[s/23[%ebx] + tmp/33[%ecx]]
                  I/35[%ecx] := I/35[%ecx] - I/34[%ebx]
                  l2/36[%ebx] := I/35[%ecx]  * 2 + 1
                  spilled-l2/47[s1] := l2/36[%ebx] (spill)
                  I/37[%eax] := l1/30[%eax] + l2/36[%ebx] + -1
                  push I/37[%eax]
                  {spilled-s/46[s2]* spilled-l2/47[s1] spilled-l1/48[s0]}
                  R/0[%eax] := extcall "caml_create_string"  (noalloc) {pervasives.ml:145,10-33}
                  offset stack -4
                  s/38[%ebx] := R/0[%eax]
                  l1/53[%esi] := spilled-l1/48[s0] (reload)
                  push l1/53[%esi]
                  push 1
                  push s/38[%ebx]
                  push 1
                  push "camlCode__1"
                  {s/38[%ebx]* spilled-s/46[s2]* spilled-l2/47[s1]
                   l1/53[%esi]}
                  extcall "caml_blit_string"  {pervasives.ml:146,2-25}
                  offset stack -20
                  l2/54[%eax] := spilled-l2/47[s1] (reload)
                  push l2/54[%eax]
                  push l1/53[%esi]
                  push s/38[%ebx]
                  push 1
                  s/55[%eax] := spilled-s/46[s2] (reload)
                  push s/55[%eax]
                  {s/38[%ebx]*}
                  extcall "caml_blit_string"  {pervasives.ml:147,2-26}
                  offset stack -20
                  A/39[%eax] := [s/38[%ebx] + -4]
                  I/40[%eax] := I/40[%eax] >>u 10
                  tmp/41[%eax] := I/40[%eax]  * 4 + -1
                  I/42[%ebx] := unsigned int8[s/38[%ebx] + tmp/41[%eax]]
                  I/43[%eax] := I/43[%eax] - I/42[%ebx]
                  I/44[%eax] := I/43[%eax]  * 2 + 1
                  A/45[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  A/8[%eax] := ["camlCode__2" + -4]
  I/9[%eax] := I/9[%eax] >>u 10
  tmp/10[%eax] := I/9[%eax]  * 4 + -1
  A/11[%ebx] := "camlCode__2"
  I/12[%ebx] := unsigned int8[A/11[%ebx] + tmp/10[%eax]]
  I/13[%eax] := I/13[%eax] - I/12[%ebx]
  l1/14[%eax] := I/13[%eax]  * 2 + 1
  spilled-l1/50[s0] := l1/14[%eax] (spill)
  A/15[%ebx] := ["camlCode__3" + -4]
  I/16[%ebx] := I/16[%ebx] >>u 10
  tmp/17[%ebx] := I/16[%ebx]  * 4 + -1
  A/18[%ecx] := "camlCode__3"
  I/19[%ecx] := unsigned int8[A/18[%ecx] + tmp/17[%ebx]]
  I/20[%ebx] := I/20[%ebx] - I/19[%ecx]
  l2/21[%ebx] := I/20[%ebx]  * 2 + 1
  spilled-l2/49[s1] := l2/21[%ebx] (spill)
  I/22[%eax] := l1/14[%eax] + l2/21[%ebx] + -1
  push I/22[%eax]
  {spilled-l2/49[s1] spilled-l1/50[s0]}
  R/0[%eax] := extcall "caml_create_string"  (noalloc) {pervasives.ml:145,10-33}
  offset stack -4
  s/23[%ebx] := R/0[%eax]
  spilled-s/46[s2] := s/23[%ebx] (spill)
  l1/51[%esi] := spilled-l1/50[s0] (reload)
  push l1/51[%esi]
  push 1
  push s/23[%ebx]
  push 1
  push "camlCode__2"
  {s/23[%ebx]* spilled-s/46[s2]* spilled-l2/49[s1] l1/51[%esi]}
  extcall "caml_blit_string"  {pervasives.ml:146,2-25}
  offset stack -20
  l2/52[%eax] := spilled-l2/49[s1] (reload)
  push l2/52[%eax]
  push l1/51[%esi]
  push s/23[%ebx]
  push 1
  push "camlCode__3"
  {s/23[%ebx]* spilled-s/46[s2]*}
  extcall "caml_blit_string"  {pervasives.ml:147,2-26}
  offset stack -20
  A/24[%eax] := ["camlCode__1" + -4]
  I/25[%eax] := I/25[%eax] >>u 10
  tmp/26[%eax] := I/25[%eax]  * 4 + -1
  A/27[%ecx] := "camlCode__1"
  I/28[%ecx] := unsigned int8[A/27[%ecx] + tmp/26[%eax]]
  I/29[%eax] := I/29[%eax] - I/28[%ecx]
  l1/30[%eax] := I/29[%eax]  * 2 + 1
  spilled-l1/48[s0] := l1/30[%eax] (spill)
  A/31[%ecx] := [s/23[%ebx] + -4]
  I/32[%ecx] := I/32[%ecx] >>u 10
  tmp/33[%ecx] := I/32[%ecx]  * 4 + -1
  I/34[%ebx] := unsigned int8[s/23[%ebx] + tmp/33[%ecx]]
  I/35[%ecx] := I/35[%ecx] - I/34[%ebx]
  l2/36[%ebx] := I/35[%ecx]  * 2 + 1
  spilled-l2/47[s1] := l2/36[%ebx] (spill)
  I/37[%eax] := l1/30[%eax] + l2/36[%ebx] + -1
  push I/37[%eax]
  {spilled-s/46[s2]* spilled-l2/47[s1] spilled-l1/48[s0]}
  R/0[%eax] := extcall "caml_create_string"  (noalloc) {pervasives.ml:145,10-33}
  offset stack -4
  s/38[%ebx] := R/0[%eax]
  l1/53[%esi] := spilled-l1/48[s0] (reload)
  push l1/53[%esi]
  push 1
  push s/38[%ebx]
  push 1
  push "camlCode__1"
  {s/38[%ebx]* spilled-s/46[s2]* spilled-l2/47[s1] l1/53[%esi]}
  extcall "caml_blit_string"  {pervasives.ml:146,2-25}
  offset stack -20
  l2/54[%eax] := spilled-l2/47[s1] (reload)
  push l2/54[%eax]
  push l1/53[%esi]
  push s/38[%ebx]
  push 1
  s/55[%eax] := spilled-s/46[s2] (reload)
  push s/55[%eax]
  {s/38[%ebx]*}
  extcall "caml_blit_string"  {pervasives.ml:147,2-26}
  offset stack -20
  A/39[%eax] := [s/38[%ebx] + -4]
  I/40[%eax] := I/40[%eax] >>u 10
  tmp/41[%eax] := I/40[%eax]  * 4 + -1
  I/42[%ebx] := unsigned int8[s/38[%ebx] + tmp/41[%eax]]
  I/43[%eax] := I/43[%eax] - I/42[%ebx]
  I/44[%eax] := I/43[%eax]  * 2 + 1
  A/45[%eax] := 1
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
	.long	0
	.globl	camlCode
camlCode:
	.data
	.globl	camlCode__1
	.long	1276
camlCode__1:
	.ascii	"a"
	.space	2
	.byte	2
	.data
	.globl	camlCode__2
	.long	1276
camlCode__2:
	.ascii	"b"
	.space	2
	.byte	2
	.data
	.globl	camlCode__3
	.long	1276
camlCode__3:
	.ascii	"c"
	.space	2
	.byte	2
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subl	$12, %esp
.L100:
	movl	camlCode__2 + -4, %eax
	shrl	$10, %eax
	lea	-1(, %eax, 4), %eax
	movl	$camlCode__2, %ebx
	movzbl	(%ebx, %eax), %ebx
	subl	%ebx, %eax
	lea	1(%eax, %eax), %eax
	movl	%eax, 0(%esp)
	movl	camlCode__3 + -4, %ebx
	shrl	$10, %ebx
	lea	-1(, %ebx, 4), %ebx
	movl	$camlCode__3, %ecx
	movzbl	(%ecx, %ebx), %ecx
	subl	%ecx, %ebx
	lea	1(%ebx, %ebx), %ebx
	movl	%ebx, 4(%esp)
	lea	-1(%eax, %ebx), %eax
	pushl	%eax
	movl	$caml_create_string, %eax
	call	caml_c_call
.L101:
	addl	$4, %esp
	movl	%eax, %ebx
	movl	%ebx, 8(%esp)
	movl	0(%esp), %esi
	pushl	%esi
	pushl	$1
	pushl	%ebx
	pushl	$1
	pushl	$camlCode__2
	call	caml_blit_string
	addl	$20, %esp
	movl	4(%esp), %eax
	pushl	%eax
	pushl	%esi
	pushl	%ebx
	pushl	$1
	pushl	$camlCode__3
	call	caml_blit_string
	addl	$20, %esp
	movl	camlCode__1 + -4, %eax
	shrl	$10, %eax
	lea	-1(, %eax, 4), %eax
	movl	$camlCode__1, %ecx
	movzbl	(%ecx, %eax), %ecx
	subl	%ecx, %eax
	lea	1(%eax, %eax), %eax
	movl	%eax, 0(%esp)
	movl	-4(%ebx), %ecx
	shrl	$10, %ecx
	lea	-1(, %ecx, 4), %ecx
	movzbl	(%ebx, %ecx), %ebx
	subl	%ebx, %ecx
	lea	1(%ecx, %ecx), %ebx
	movl	%ebx, 4(%esp)
	lea	-1(%eax, %ebx), %eax
	pushl	%eax
	movl	$caml_create_string, %eax
	call	caml_c_call
.L102:
	addl	$4, %esp
	movl	%eax, %ebx
	movl	0(%esp), %esi
	pushl	%esi
	pushl	$1
	pushl	%ebx
	pushl	$1
	pushl	$camlCode__1
	call	caml_blit_string
	addl	$20, %esp
	movl	4(%esp), %eax
	pushl	%eax
	pushl	%esi
	pushl	%ebx
	pushl	$1
	movl	24(%esp), %eax
	pushl	%eax
	call	caml_blit_string
	addl	$20, %esp
	movl	-4(%ebx), %eax
	shrl	$10, %eax
	lea	-1(, %eax, 4), %eax
	movzbl	(%ebx, %eax), %ebx
	subl	%ebx, %eax
	lea	1(%eax, %eax), %eax
	movl	$1, %eax
	addl	$12, %esp
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
	.long	.L102
	.word	21
	.word	1
	.word	12
	.align	4
	.long	.L200000 - . + 0x84000000
	.long	0x910a0
	.long	.L101
	.word	21
	.word	0
	.align	4
	.long	.L200000 - . + 0x84000000
	.long	0x910a0
.L200000:
	.ascii	"pervasives.ml\0"
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

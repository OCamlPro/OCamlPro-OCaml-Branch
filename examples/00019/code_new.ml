
let f a b =
  Printf.fprintf stderr "%d %d\n%!" a b
  
let main1 a b c d =
  f a 2;
  f 1 b;
  f a 2;
  f 2 b
  
let main2 a b c d =
  c+d
  
  
  (*
-drawlambda
(seq
  (let
    (f/1030
       (function a/1031 b/1032
         (apply (field 0 (global Printf!)) (field 24 (global Pervasives!))
           "%d %d\n%!" a/1031 b/1032)))
    (setfield_imm 0 (global Code!) f/1030))
  (let
    (main1/1033
       (function a/1034 b/1035 c/1036 d/1037
         (seq (apply (field 0 (global Code!)) a/1034 2)
           (apply (field 0 (global Code!)) 1 b/1035)
           (apply (field 0 (global Code!)) a/1034 2)
           (apply (field 0 (global Code!)) 2 b/1035))))
    (setfield_imm 1 (global Code!) main1/1033))
  (let (main2/1038 (function a/1039 b/1040 c/1041 d/1042 (+ c/1041 d/1042)))
    (setfield_imm 2 (global Code!) main2/1038))
  0a)
*** After instruction selection
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := a/8
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  a/8 := spilled-a/14 (reload)
  R/1[%ebx] := a/8
  b/9 := spilled-b/13 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  a/15 := spilled-a/14 (reload)
  R/1[%ebx] := a/15
  b/16 := spilled-b/13 (reload)
  R/2[%ecx] := b/16
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After instruction selection
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  R/1[%ebx] := a/8
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  R/2[%ecx] := b/9
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  R/1[%ebx] := a/8
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  R/2[%ecx] := b/9
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/29 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/28 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  a/8 := spilled-a/29 (reload)
  R/1[%ebx] := a/8
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  b/9 := spilled-b/28 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  a/8 := spilled-a/29 (reload)
  R/1[%ebx] := a/8
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  b/9 := spilled-b/28 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/29 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/28 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  a/30 := spilled-a/29 (reload)
  R/1[%ebx] := a/30
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  b/31 := spilled-b/28 (reload)
  R/2[%ecx] := b/31
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  a/32 := spilled-a/29 (reload)
  R/1[%ebx] := a/32
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  b/33 := spilled-b/28 (reload)
  R/2[%ecx] := b/33
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After instruction selection
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After spilling
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After live range splitting
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After instruction selection
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After spilling
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
-dlambda
(seq
  (let
    (f/1030
       (function a/1031 b/1032
         (apply (field 0 (global Printf!)) (field 24 (global Pervasives!))
           "%d %d\n%!" a/1031 b/1032)))
    (setfield_imm 0 (global Code!) f/1030))
  (let
    (main1/1033
       (function a/1034 b/1035 c/1036 d/1037
         (seq (apply (field 0 (global Code!)) a/1034 2)
           (apply (field 0 (global Code!)) 1 b/1035)
           (apply (field 0 (global Code!)) a/1034 2)
           (apply (field 0 (global Code!)) 2 b/1035))))
    (setfield_imm 1 (global Code!) main1/1033))
  (let (main2/1038 (function a/1039 b/1040 c/1041 d/1042 (+ c/1041 d/1042)))
    (setfield_imm 2 (global Code!) main2/1038))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After TonLambda.optimize:
(seq
  (let
    (f/1030
       (function a/1031 b/1032
         (apply (field 0 (global Printf!)) (field 24 (global Pervasives!))
           "%d %d\n%!" a/1031 b/1032)))
    (setfield_imm 0 (global Code!) f/1030))
  (let
    (main1/1033
       (function a/1034 b/1035 c/1036 d/1037
         (seq (apply (field 0 (global Code!)) a/1034 2)
           (apply (field 0 (global Code!)) 1 b/1035)
           (apply (field 0 (global Code!)) a/1034 2)
           (apply (field 0 (global Code!)) 2 b/1035))))
    (setfield_imm 1 (global Code!) main1/1033))
  (let (main2/1038 (function a/1039 b/1040 c/1041 d/1042 (+ c/1041 d/1042)))
    (setfield_imm 2 (global Code!) main2/1038))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After instruction selection
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := a/8
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  a/8 := spilled-a/14 (reload)
  R/1[%ebx] := a/8
  b/9 := spilled-b/13 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  a/15 := spilled-a/14 (reload)
  R/1[%ebx] := a/15
  b/16 := spilled-b/13 (reload)
  R/2[%ecx] := b/16
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After instruction selection
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  R/1[%ebx] := a/8
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  R/2[%ecx] := b/9
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  R/1[%ebx] := a/8
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  R/2[%ecx] := b/9
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/29 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/28 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  a/8 := spilled-a/29 (reload)
  R/1[%ebx] := a/8
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  b/9 := spilled-b/28 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  a/8 := spilled-a/29 (reload)
  R/1[%ebx] := a/8
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  b/9 := spilled-b/28 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/29 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/28 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  a/30 := spilled-a/29 (reload)
  R/1[%ebx] := a/30
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  b/31 := spilled-b/28 (reload)
  R/2[%ecx] := b/31
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  a/32 := spilled-a/29 (reload)
  R/1[%ebx] := a/32
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  b/33 := spilled-b/28 (reload)
  R/2[%ecx] := b/33
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After instruction selection
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After spilling
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After live range splitting
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After instruction selection
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After spilling
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
-dclosure
*** After Closure.intro:
(seq
  (let
    (f/1030
       (closure (camlCode__f_1030(2)  a/1031 b/1032
                  (apply
                    (camlPrintf__fprintf_1391 
                      (field 24 (global camlPervasives!)))
                    "%d %d\n%!" a/1031 b/1032)) {3} ))
    (setfield_imm 0 (global camlCode!) f/1030))
  (let
    (main1/1033
       (closure (camlCode__main1_1033(4)  a/1034 b/1035 c/1036 d/1037
                  (seq
                    (apply
                      (camlPrintf__fprintf_1391 
                        (field 24 (global camlPervasives!)))
                      "%d %d\n%!" a/1034 2)
                    (apply
                      (camlPrintf__fprintf_1391 
                        (field 24 (global camlPervasives!)))
                      "%d %d\n%!" 1 b/1035)
                    (apply
                      (camlPrintf__fprintf_1391 
                        (field 24 (global camlPervasives!)))
                      "%d %d\n%!" a/1034 2)
                    (apply
                      (camlPrintf__fprintf_1391 
                        (field 24 (global camlPervasives!)))
                      "%d %d\n%!" 2 b/1035))) {3} ))
    (setfield_imm 1 (global camlCode!) main1/1033))
  (let
    (main2/1038
       (closure (camlCode__main2_1038(4)  a/1039 b/1040 c/1041 d/1042
                  (+ c/1041 d/1042)) {3} ))
    (setfield_imm 2 (global camlCode!) main2/1038))
  0a)
*** After TonClosure.optimize:
(let
  (f/1030
     (closure (camlCode__f_1030(2)  a/1031 b/1032
                (apply
                  (camlPrintf__fprintf_1391 
                    (field 24 (global camlPervasives!)))
                  "%d %d\n%!" a/1031 b/1032)) {3} ))
  (seq (setfield_imm 0 (global camlCode!) f/1030)
    (let
      (main1/1033
         (closure (camlCode__main1_1033(4)  a/1034 b/1035 c/1036 d/1037
                    (seq
                      (apply
                        (camlPrintf__fprintf_1391 
                          (field 24 (global camlPervasives!)))
                        "%d %d\n%!" a/1034 2)
                      (apply
                        (camlPrintf__fprintf_1391 
                          (field 24 (global camlPervasives!)))
                        "%d %d\n%!" 1 b/1035)
                      (apply
                        (camlPrintf__fprintf_1391 
                          (field 24 (global camlPervasives!)))
                        "%d %d\n%!" a/1034 2)
                      (apply
                        (camlPrintf__fprintf_1391 
                          (field 24 (global camlPervasives!)))
                        "%d %d\n%!" 2 b/1035))) {3} ))
      (seq (setfield_imm 1 (global camlCode!) main1/1033)
        (let
          (main2/1038
             (closure (camlCode__main2_1038(4)  a/1039 b/1040 c/1041 d/1042
                        (+ c/1041 d/1042)) {3} ))
          (seq (setfield_imm 2 (global camlCode!) main2/1038) 0a))))))
*** After instruction selection
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := a/8
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  a/8 := spilled-a/14 (reload)
  R/1[%ebx] := a/8
  b/9 := spilled-b/13 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  a/15 := spilled-a/14 (reload)
  R/1[%ebx] := a/15
  b/16 := spilled-b/13 (reload)
  R/2[%ecx] := b/16
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After instruction selection
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  R/1[%ebx] := a/8
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  R/2[%ecx] := b/9
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  R/1[%ebx] := a/8
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  R/2[%ecx] := b/9
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/29 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/28 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  a/8 := spilled-a/29 (reload)
  R/1[%ebx] := a/8
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  b/9 := spilled-b/28 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  a/8 := spilled-a/29 (reload)
  R/1[%ebx] := a/8
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  b/9 := spilled-b/28 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/29 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/28 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  a/30 := spilled-a/29 (reload)
  R/1[%ebx] := a/30
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  b/31 := spilled-b/28 (reload)
  R/2[%ecx] := b/31
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  a/32 := spilled-a/29 (reload)
  R/1[%ebx] := a/32
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  b/33 := spilled-b/28 (reload)
  R/2[%ecx] := b/33
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After instruction selection
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After spilling
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After live range splitting
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After instruction selection
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After spilling
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 12)
(data
 int 3319
 "camlCode__2":
 addr "caml_curry4"
 int 9
 addr "camlCode__main2_1038")
(data
 int 3319
 "camlCode__3":
 addr "caml_curry4"
 int 9
 addr "camlCode__main1_1033")
(data
 int 3319
 "camlCode__4":
 addr "caml_curry2"
 int 5
 addr "camlCode__f_1030")
(data
 global "camlCode__1"
 int 3324
 "camlCode__1":
 string "%d %d
%!"
 skip 3
 byte 3)
(function camlCode__f_1030 (a/1031: addr b/1032: addr)
 (app "caml_apply3" "camlCode__1" a/1031 b/1032
   (app "camlPrintf__fprintf_1391" (load (+a "camlPervasives" 96)) addr)
   addr))

*** After instruction selection
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := a/8
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  a/8 := spilled-a/14 (reload)
  R/1[%ebx] := a/8
  b/9 := spilled-b/13 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  a/15 := spilled-a/14 (reload)
  R/1[%ebx] := a/15
  b/16 := spilled-b/13 (reload)
  R/2[%ecx] := b/16
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
(function camlCode__main1_1033
     (a/1034: addr b/1035: addr c/1036: addr d/1037: addr)
 (app "caml_apply3" "camlCode__1" a/1034 5
   (app "camlPrintf__fprintf_1391" (load (+a "camlPervasives" 96)) addr)
   unit)
 (app "caml_apply3" "camlCode__1" 3 b/1035
   (app "camlPrintf__fprintf_1391" (load (+a "camlPervasives" 96)) addr)
   unit)
 (app "caml_apply3" "camlCode__1" a/1034 5
   (app "camlPrintf__fprintf_1391" (load (+a "camlPervasives" 96)) addr)
   unit)
 (app "caml_apply3" "camlCode__1" 5 b/1035
   (app "camlPrintf__fprintf_1391" (load (+a "camlPervasives" 96)) addr)
   addr))

*** After instruction selection
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  R/1[%ebx] := a/8
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  R/2[%ecx] := b/9
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  R/1[%ebx] := a/8
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  R/2[%ecx] := b/9
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/29 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/28 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  a/8 := spilled-a/29 (reload)
  R/1[%ebx] := a/8
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  b/9 := spilled-b/28 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  a/8 := spilled-a/29 (reload)
  R/1[%ebx] := a/8
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  b/9 := spilled-b/28 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/29 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/28 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  a/30 := spilled-a/29 (reload)
  R/1[%ebx] := a/30
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  b/31 := spilled-b/28 (reload)
  R/2[%ecx] := b/31
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  a/32 := spilled-a/29 (reload)
  R/1[%ebx] := a/32
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  b/33 := spilled-b/28 (reload)
  R/2[%ecx] := b/33
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
(function camlCode__main2_1038
     (a/1039: addr b/1040: addr c/1041: addr d/1042: addr)
 (+ (+ c/1041 d/1042) -1))

*** After instruction selection
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After spilling
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After live range splitting
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
(function camlCode__entry ()
 (let f/1030 "camlCode__4" (store "camlCode" f/1030)
   (let main1/1033 "camlCode__3" (store (+a "camlCode" 4) main1/1033)
     (let main2/1038 "camlCode__2" (store (+a "camlCode" 8) main2/1038) 1a))))

*** After instruction selection
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After spilling
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
(data)
-dlinear
*** After instruction selection
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := a/8
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  a/8 := spilled-a/14 (reload)
  R/1[%ebx] := a/8
  b/9 := spilled-b/13 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__f_1030(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  a/15 := spilled-a/14 (reload)
  R/1[%ebx] := a/15
  b/16 := spilled-b/13 (reload)
  R/2[%ecx] := b/16
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
Before simplify
camlCode__f_1030:
                  spilled-a/14[s0] := a/8[%eax] (spill)
                  spilled-b/13[s1] := b/9[%ebx] (spill)
                  A/10[%eax] := ["camlPervasives" + 96]
                  {spilled-b/13[s1]* spilled-a/14[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
                  A/11[%edx] := R/0[%eax]
                  A/12[%eax] := "camlCode__1"
                  a/15[%ebx] := spilled-a/14[s0] (reload)
                  b/16[%ecx] := spilled-b/13[s1] (reload)
                  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  *** Linearized code
camlCode__f_1030:
  spilled-a/14[s0] := a/8[%eax] (spill)
  spilled-b/13[s1] := b/9[%ebx] (spill)
  A/10[%eax] := ["camlPervasives" + 96]
  {spilled-b/13[s1]* spilled-a/14[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/11[%edx] := R/0[%eax]
  A/12[%eax] := "camlCode__1"
  a/15[%ebx] := spilled-a/14[s0] (reload)
  b/16[%ecx] := spilled-b/13[s1] (reload)
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  
*** After instruction selection
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  R/1[%ebx] := a/8
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  R/2[%ecx] := b/9
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  R/1[%ebx] := a/8
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  R/2[%ecx] := b/9
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/29 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/28 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  a/8 := spilled-a/29 (reload)
  R/1[%ebx] := a/8
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  b/9 := spilled-b/28 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  a/8 := spilled-a/29 (reload)
  R/1[%ebx] := a/8
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  b/9 := spilled-b/28 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__main1_1033(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/29 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/28 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  A/12 := ["camlPervasives" + 96]
  R/0[%eax] := A/12
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13 := R/0[%eax]
  I/14 := 5
  A/15 := "camlCode__1"
  R/0[%eax] := A/15
  a/30 := spilled-a/29 (reload)
  R/1[%ebx] := a/30
  R/2[%ecx] := I/14
  R/3[%edx] := A/13
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16 := ["camlPervasives" + 96]
  R/0[%eax] := A/16
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17 := R/0[%eax]
  I/18 := 3
  A/19 := "camlCode__1"
  R/0[%eax] := A/19
  R/1[%ebx] := I/18
  b/31 := spilled-b/28 (reload)
  R/2[%ecx] := b/31
  R/3[%edx] := A/17
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20 := ["camlPervasives" + 96]
  R/0[%eax] := A/20
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21 := R/0[%eax]
  I/22 := 5
  A/23 := "camlCode__1"
  R/0[%eax] := A/23
  a/32 := spilled-a/29 (reload)
  R/1[%ebx] := a/32
  R/2[%ecx] := I/22
  R/3[%edx] := A/21
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24 := ["camlPervasives" + 96]
  R/0[%eax] := A/24
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25 := R/0[%eax]
  I/26 := 5
  A/27 := "camlCode__1"
  R/0[%eax] := A/27
  R/1[%ebx] := I/26
  b/33 := spilled-b/28 (reload)
  R/2[%ecx] := b/33
  R/3[%edx] := A/25
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
Before simplify
camlCode__main1_1033:
                  spilled-a/29[s0] := a/8[%eax] (spill)
                  spilled-b/28[s1] := b/9[%ebx] (spill)
                  A/12[%eax] := ["camlPervasives" + 96]
                  {spilled-b/28[s1]* spilled-a/29[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
                  A/13[%edx] := R/0[%eax]
                  I/14[%ecx] := 5
                  A/15[%eax] := "camlCode__1"
                  a/30[%ebx] := spilled-a/29[s0] (reload)
                  {spilled-b/28[s1]* spilled-a/29[s0]*}
                  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  A/16[%eax] := ["camlPervasives" + 96]
                  {spilled-b/28[s1]* spilled-a/29[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
                  A/17[%edx] := R/0[%eax]
                  I/18[%ebx] := 3
                  A/19[%eax] := "camlCode__1"
                  b/31[%ecx] := spilled-b/28[s1] (reload)
                  {spilled-b/28[s1]* spilled-a/29[s0]*}
                  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  A/20[%eax] := ["camlPervasives" + 96]
                  {spilled-b/28[s1]* spilled-a/29[s0]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
                  A/21[%edx] := R/0[%eax]
                  I/22[%ecx] := 5
                  A/23[%eax] := "camlCode__1"
                  a/32[%ebx] := spilled-a/29[s0] (reload)
                  {spilled-b/28[s1]*}
                  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  A/24[%eax] := ["camlPervasives" + 96]
                  {spilled-b/28[s1]*}
                  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
                  A/25[%edx] := R/0[%eax]
                  I/26[%ebx] := 5
                  A/27[%eax] := "camlCode__1"
                  b/33[%ecx] := spilled-b/28[s1] (reload)
                  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
                  *** Linearized code
camlCode__main1_1033:
  spilled-a/29[s0] := a/8[%eax] (spill)
  spilled-b/28[s1] := b/9[%ebx] (spill)
  A/12[%eax] := ["camlPervasives" + 96]
  {spilled-b/28[s1]* spilled-a/29[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/13[%edx] := R/0[%eax]
  I/14[%ecx] := 5
  A/15[%eax] := "camlCode__1"
  a/30[%ebx] := spilled-a/29[s0] (reload)
  {spilled-b/28[s1]* spilled-a/29[s0]*}
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/16[%eax] := ["camlPervasives" + 96]
  {spilled-b/28[s1]* spilled-a/29[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/17[%edx] := R/0[%eax]
  I/18[%ebx] := 3
  A/19[%eax] := "camlCode__1"
  b/31[%ecx] := spilled-b/28[s1] (reload)
  {spilled-b/28[s1]* spilled-a/29[s0]*}
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/20[%eax] := ["camlPervasives" + 96]
  {spilled-b/28[s1]* spilled-a/29[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/21[%edx] := R/0[%eax]
  I/22[%ecx] := 5
  A/23[%eax] := "camlCode__1"
  a/32[%ebx] := spilled-a/29[s0] (reload)
  {spilled-b/28[s1]*}
  call "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  A/24[%eax] := ["camlPervasives" + 96]
  {spilled-b/28[s1]*}
  R/0[%eax] := call "camlPrintf__fprintf_1391" R/0[%eax]
  A/25[%edx] := R/0[%eax]
  I/26[%ebx] := 5
  A/27[%eax] := "camlCode__1"
  b/33[%ecx] := spilled-b/28[s1] (reload)
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  
*** After instruction selection
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After spilling
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After live range splitting
camlCode__main2_1038(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
Before simplify
camlCode__main2_1038:
                  I/12[%eax] := c/10[%ecx] + d/11[%edx] + -1
                  return R/0[%eax]
                  *** Linearized code
camlCode__main2_1038:
  I/12[%eax] := c/10[%ecx] + d/11[%edx] + -1
  return R/0[%eax]
  
*** After instruction selection
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After spilling
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  f/8 := "camlCode__4"
  ["camlCode"] := f/8
  main1/9 := "camlCode__3"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__2"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
Before simplify
camlCode__entry:
                  f/8[%eax] := "camlCode__4"
                  ["camlCode"] := f/8[%eax]
                  main1/9[%eax] := "camlCode__3"
                  ["camlCode" + 4] := main1/9[%eax]
                  main2/10[%eax] := "camlCode__2"
                  ["camlCode" + 8] := main2/10[%eax]
                  A/11[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  f/8[%eax] := "camlCode__4"
  ["camlCode"] := f/8[%eax]
  main1/9[%eax] := "camlCode__3"
  ["camlCode" + 4] := main1/9[%eax]
  main2/10[%eax] := "camlCode__2"
  ["camlCode" + 8] := main2/10[%eax]
  A/11[%eax] := 1
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
	.long	caml_curry4
	.long	9
	.long	camlCode__main2_1038
	.data
	.long	3319
camlCode__3:
	.long	caml_curry4
	.long	9
	.long	camlCode__main1_1033
	.data
	.long	3319
camlCode__4:
	.long	caml_curry2
	.long	5
	.long	camlCode__f_1030
	.data
	.globl	camlCode__1
	.long	3324
camlCode__1:
	.ascii	"%d %d\12%!"
	.space	3
	.byte	3
	.text
	.align	16
	.globl	camlCode__f_1030
camlCode__f_1030:
	subl	$8, %esp
.L100:
	movl	%eax, 0(%esp)
	movl	%ebx, 4(%esp)
	movl	camlPervasives + 96, %eax
	call	camlPrintf__fprintf_1391
.L101:
	movl	%eax, %edx
	movl	$camlCode__1, %eax
	movl	0(%esp), %ebx
	movl	4(%esp), %ecx
	addl	$8, %esp
	jmp	caml_apply3
	.type	camlCode__f_1030,@function
	.size	camlCode__f_1030,.-camlCode__f_1030
	.text
	.align	16
	.globl	camlCode__main1_1033
camlCode__main1_1033:
	subl	$8, %esp
.L102:
	movl	%eax, 0(%esp)
	movl	%ebx, 4(%esp)
	movl	camlPervasives + 96, %eax
	call	camlPrintf__fprintf_1391
.L103:
	movl	%eax, %edx
	movl	$5, %ecx
	movl	$camlCode__1, %eax
	movl	0(%esp), %ebx
	call	caml_apply3
.L104:
	movl	camlPervasives + 96, %eax
	call	camlPrintf__fprintf_1391
.L105:
	movl	%eax, %edx
	movl	$3, %ebx
	movl	$camlCode__1, %eax
	movl	4(%esp), %ecx
	call	caml_apply3
.L106:
	movl	camlPervasives + 96, %eax
	call	camlPrintf__fprintf_1391
.L107:
	movl	%eax, %edx
	movl	$5, %ecx
	movl	$camlCode__1, %eax
	movl	0(%esp), %ebx
	call	caml_apply3
.L108:
	movl	camlPervasives + 96, %eax
	call	camlPrintf__fprintf_1391
.L109:
	movl	%eax, %edx
	movl	$5, %ebx
	movl	$camlCode__1, %eax
	movl	4(%esp), %ecx
	addl	$8, %esp
	jmp	caml_apply3
	.type	camlCode__main1_1033,@function
	.size	camlCode__main1_1033,.-camlCode__main1_1033
	.text
	.align	16
	.globl	camlCode__main2_1038
camlCode__main2_1038:
.L110:
	lea	-1(%ecx, %edx), %eax
	ret
	.type	camlCode__main2_1038,@function
	.size	camlCode__main2_1038,.-camlCode__main2_1038
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L111:
	movl	$camlCode__4, %eax
	movl	%eax, camlCode
	movl	$camlCode__3, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__2, %eax
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
	.long	8
	.long	.L109
	.word	12
	.word	1
	.word	4
	.align	4
	.long	.L108
	.word	12
	.word	1
	.word	4
	.align	4
	.long	.L107
	.word	12
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L106
	.word	12
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L105
	.word	12
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L104
	.word	12
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L103
	.word	12
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L101
	.word	12
	.word	2
	.word	0
	.word	4
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

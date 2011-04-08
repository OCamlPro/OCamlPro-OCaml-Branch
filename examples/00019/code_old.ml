
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
    (f/58
       (function a/59 b/60
         (apply (field 0 (global Printf!)) (field 24 (global Pervasives!))
           "%d %d\n%!" a/59 b/60)))
    (setfield_imm 0 (global Code!) f/58))
  (let
    (main1/61
       (function a/62 b/63 c/64 d/65
         (seq (apply (field 0 (global Code!)) a/62 2)
           (apply (field 0 (global Code!)) 1 b/63)
           (apply (field 0 (global Code!)) a/62 2)
           (apply (field 0 (global Code!)) 2 b/63))))
    (setfield_imm 1 (global Code!) main1/61))
  (let (main2/66 (function a/67 b/68 c/69 d/70 (+ c/69 d/70)))
    (setfield_imm 2 (global Code!) main2/66))
  0a)
*** After instruction selection
camlCode__f_58(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_423" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__4"
  R/0[%eax] := A/12
  R/1[%ebx] := a/8
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__f_58(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_423" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__4"
  R/0[%eax] := A/12
  a/8 := spilled-a/14 (reload)
  R/1[%ebx] := a/8
  b/9 := spilled-b/13 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__f_58(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_423" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__4"
  R/0[%eax] := A/12
  a/15 := spilled-a/14 (reload)
  R/1[%ebx] := a/15
  b/16 := spilled-b/13 (reload)
  R/2[%ecx] := b/16
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After instruction selection
camlCode__main1_61(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/12
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/13 := 3
  R/0[%eax] := I/13
  R/1[%ebx] := b/9
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/14 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/14
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/15 := 5
  R/0[%eax] := I/15
  R/1[%ebx] := b/9
  tailcall "camlCode__f_58" R/0[%eax] R/1[%ebx]
*** After spilling
camlCode__main1_61(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/17 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/16 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/12
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/13 := 3
  R/0[%eax] := I/13
  b/9 := spilled-b/16 (reload)
  R/1[%ebx] := b/9
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/14 := 5
  a/8 := spilled-a/17 (reload)
  R/0[%eax] := a/8
  R/1[%ebx] := I/14
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/15 := 5
  R/0[%eax] := I/15
  b/9 := spilled-b/16 (reload)
  R/1[%ebx] := b/9
  tailcall "camlCode__f_58" R/0[%eax] R/1[%ebx]
*** After live range splitting
camlCode__main1_61(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/17 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/16 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/12
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/13 := 3
  R/0[%eax] := I/13
  b/18 := spilled-b/16 (reload)
  R/1[%ebx] := b/18
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/14 := 5
  a/19 := spilled-a/17 (reload)
  R/0[%eax] := a/19
  R/1[%ebx] := I/14
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/15 := 5
  R/0[%eax] := I/15
  b/20 := spilled-b/16 (reload)
  R/1[%ebx] := b/20
  tailcall "camlCode__f_58" R/0[%eax] R/1[%ebx]
*** After instruction selection
camlCode__main2_66(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After spilling
camlCode__main2_66(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After live range splitting
camlCode__main2_66(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After instruction selection
camlCode__entry()
  f/8 := "camlCode__3"
  ["camlCode"] := f/8
  main1/9 := "camlCode__2"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__1"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After spilling
camlCode__entry()
  f/8 := "camlCode__3"
  ["camlCode"] := f/8
  main1/9 := "camlCode__2"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__1"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  f/8 := "camlCode__3"
  ["camlCode"] := f/8
  main1/9 := "camlCode__2"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__1"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
-dlambda
(seq
  (let
    (f/58
       (function a/59 b/60
         (apply (field 0 (global Printf!)) (field 24 (global Pervasives!))
           "%d %d\n%!" a/59 b/60)))
    (setfield_imm 0 (global Code!) f/58))
  (let
    (main1/61
       (function a/62 b/63 c/64 d/65
         (seq (apply (field 0 (global Code!)) a/62 2)
           (apply (field 0 (global Code!)) 1 b/63)
           (apply (field 0 (global Code!)) a/62 2)
           (apply (field 0 (global Code!)) 2 b/63))))
    (setfield_imm 1 (global Code!) main1/61))
  (let (main2/66 (function a/67 b/68 c/69 d/70 (+ c/69 d/70)))
    (setfield_imm 2 (global Code!) main2/66))
  0a)
*** After instruction selection
camlCode__f_58(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_423" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__4"
  R/0[%eax] := A/12
  R/1[%ebx] := a/8
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__f_58(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_423" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__4"
  R/0[%eax] := A/12
  a/8 := spilled-a/14 (reload)
  R/1[%ebx] := a/8
  b/9 := spilled-b/13 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__f_58(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_423" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__4"
  R/0[%eax] := A/12
  a/15 := spilled-a/14 (reload)
  R/1[%ebx] := a/15
  b/16 := spilled-b/13 (reload)
  R/2[%ecx] := b/16
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After instruction selection
camlCode__main1_61(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/12
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/13 := 3
  R/0[%eax] := I/13
  R/1[%ebx] := b/9
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/14 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/14
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/15 := 5
  R/0[%eax] := I/15
  R/1[%ebx] := b/9
  tailcall "camlCode__f_58" R/0[%eax] R/1[%ebx]
*** After spilling
camlCode__main1_61(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/17 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/16 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/12
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/13 := 3
  R/0[%eax] := I/13
  b/9 := spilled-b/16 (reload)
  R/1[%ebx] := b/9
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/14 := 5
  a/8 := spilled-a/17 (reload)
  R/0[%eax] := a/8
  R/1[%ebx] := I/14
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/15 := 5
  R/0[%eax] := I/15
  b/9 := spilled-b/16 (reload)
  R/1[%ebx] := b/9
  tailcall "camlCode__f_58" R/0[%eax] R/1[%ebx]
*** After live range splitting
camlCode__main1_61(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/17 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/16 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/12
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/13 := 3
  R/0[%eax] := I/13
  b/18 := spilled-b/16 (reload)
  R/1[%ebx] := b/18
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/14 := 5
  a/19 := spilled-a/17 (reload)
  R/0[%eax] := a/19
  R/1[%ebx] := I/14
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/15 := 5
  R/0[%eax] := I/15
  b/20 := spilled-b/16 (reload)
  R/1[%ebx] := b/20
  tailcall "camlCode__f_58" R/0[%eax] R/1[%ebx]
*** After instruction selection
camlCode__main2_66(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After spilling
camlCode__main2_66(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After live range splitting
camlCode__main2_66(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After instruction selection
camlCode__entry()
  f/8 := "camlCode__3"
  ["camlCode"] := f/8
  main1/9 := "camlCode__2"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__1"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After spilling
camlCode__entry()
  f/8 := "camlCode__3"
  ["camlCode"] := f/8
  main1/9 := "camlCode__2"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__1"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  f/8 := "camlCode__3"
  ["camlCode"] := f/8
  main1/9 := "camlCode__2"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__1"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 12)
(data
 int 3319
 "camlCode__1":
 addr "caml_curry4"
 int 9
 addr "camlCode__main2_66")
(data
 int 3319
 "camlCode__2":
 addr "caml_curry4"
 int 9
 addr "camlCode__main1_61")
(data int 3319 "camlCode__3": addr "caml_curry2" int 5 addr "camlCode__f_58")
(data int 3324 "camlCode__4": string "%d %d
%!" skip 3 byte 3)
(function camlCode__f_58 (a/59: addr b/60: addr)
 (app "caml_apply3" "camlCode__4" a/59 b/60
   (app "camlPrintf__fprintf_423" (load (+a "camlPervasives" 96)) addr) addr))

*** After instruction selection
camlCode__f_58(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_423" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__4"
  R/0[%eax] := A/12
  R/1[%ebx] := a/8
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__f_58(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_423" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__4"
  R/0[%eax] := A/12
  a/8 := spilled-a/14 (reload)
  R/1[%ebx] := a/8
  b/9 := spilled-b/13 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__f_58(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_423" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__4"
  R/0[%eax] := A/12
  a/15 := spilled-a/14 (reload)
  R/1[%ebx] := a/15
  b/16 := spilled-b/13 (reload)
  R/2[%ecx] := b/16
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
(function camlCode__main1_61 (a/62: addr b/63: addr c/64: addr d/65: addr)
 (app "camlCode__f_58" a/62 5 unit) (app "camlCode__f_58" 3 b/63 unit)
 (app "camlCode__f_58" a/62 5 unit) (app "camlCode__f_58" 5 b/63 addr))

*** After instruction selection
camlCode__main1_61(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/12
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/13 := 3
  R/0[%eax] := I/13
  R/1[%ebx] := b/9
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/14 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/14
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/15 := 5
  R/0[%eax] := I/15
  R/1[%ebx] := b/9
  tailcall "camlCode__f_58" R/0[%eax] R/1[%ebx]
*** After spilling
camlCode__main1_61(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/17 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/16 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/12
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/13 := 3
  R/0[%eax] := I/13
  b/9 := spilled-b/16 (reload)
  R/1[%ebx] := b/9
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/14 := 5
  a/8 := spilled-a/17 (reload)
  R/0[%eax] := a/8
  R/1[%ebx] := I/14
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/15 := 5
  R/0[%eax] := I/15
  b/9 := spilled-b/16 (reload)
  R/1[%ebx] := b/9
  tailcall "camlCode__f_58" R/0[%eax] R/1[%ebx]
*** After live range splitting
camlCode__main1_61(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/17 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/16 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/12
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/13 := 3
  R/0[%eax] := I/13
  b/18 := spilled-b/16 (reload)
  R/1[%ebx] := b/18
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/14 := 5
  a/19 := spilled-a/17 (reload)
  R/0[%eax] := a/19
  R/1[%ebx] := I/14
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/15 := 5
  R/0[%eax] := I/15
  b/20 := spilled-b/16 (reload)
  R/1[%ebx] := b/20
  tailcall "camlCode__f_58" R/0[%eax] R/1[%ebx]
(function camlCode__main2_66 (a/67: addr b/68: addr c/69: addr d/70: addr)
 (+ (+ c/69 d/70) -1))

*** After instruction selection
camlCode__main2_66(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After spilling
camlCode__main2_66(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After live range splitting
camlCode__main2_66(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
(function camlCode__entry ()
 (let f/58 "camlCode__3" (store "camlCode" f/58))
 (let main1/61 "camlCode__2" (store (+a "camlCode" 4) main1/61))
 (let main2/66 "camlCode__1" (store (+a "camlCode" 8) main2/66)) 1a)

*** After instruction selection
camlCode__entry()
  f/8 := "camlCode__3"
  ["camlCode"] := f/8
  main1/9 := "camlCode__2"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__1"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After spilling
camlCode__entry()
  f/8 := "camlCode__3"
  ["camlCode"] := f/8
  main1/9 := "camlCode__2"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__1"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  f/8 := "camlCode__3"
  ["camlCode"] := f/8
  main1/9 := "camlCode__2"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__1"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
(data)
-dlinear
*** After instruction selection
camlCode__f_58(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_423" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__4"
  R/0[%eax] := A/12
  R/1[%ebx] := a/8
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After spilling
camlCode__f_58(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_423" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__4"
  R/0[%eax] := A/12
  a/8 := spilled-a/14 (reload)
  R/1[%ebx] := a/8
  b/9 := spilled-b/13 (reload)
  R/2[%ecx] := b/9
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** After live range splitting
camlCode__f_58(R/0[%eax] R/1[%ebx])
  a/8 := R/0[%eax]
  spilled-a/14 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/13 := b/9 (spill)
  A/10 := ["camlPervasives" + 96]
  R/0[%eax] := A/10
  R/0[%eax] := call "camlPrintf__fprintf_423" R/0[%eax]
  A/11 := R/0[%eax]
  A/12 := "camlCode__4"
  R/0[%eax] := A/12
  a/15 := spilled-a/14 (reload)
  R/1[%ebx] := a/15
  b/16 := spilled-b/13 (reload)
  R/2[%ecx] := b/16
  R/3[%edx] := A/11
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
*** Linearized code
camlCode__f_58:
  spilled-a/14[s0] := a/8[%eax] (spill)
  spilled-b/13[s1] := b/9[%ebx] (spill)
  A/10[%eax] := ["camlPervasives" + 96]
  {spilled-b/13[s1]* spilled-a/14[s0]*}
  R/0[%eax] := call "camlPrintf__fprintf_423" R/0[%eax]
  A/11[%edx] := R/0[%eax]
  A/12[%eax] := "camlCode__4"
  a/15[%ebx] := spilled-a/14[s0] (reload)
  b/16[%ecx] := spilled-b/13[s1] (reload)
  tailcall "caml_apply3" R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx]
  
*** After instruction selection
camlCode__main1_61(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/12
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/13 := 3
  R/0[%eax] := I/13
  R/1[%ebx] := b/9
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/14 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/14
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/15 := 5
  R/0[%eax] := I/15
  R/1[%ebx] := b/9
  tailcall "camlCode__f_58" R/0[%eax] R/1[%ebx]
*** After spilling
camlCode__main1_61(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/17 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/16 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/12
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/13 := 3
  R/0[%eax] := I/13
  b/9 := spilled-b/16 (reload)
  R/1[%ebx] := b/9
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/14 := 5
  a/8 := spilled-a/17 (reload)
  R/0[%eax] := a/8
  R/1[%ebx] := I/14
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/15 := 5
  R/0[%eax] := I/15
  b/9 := spilled-b/16 (reload)
  R/1[%ebx] := b/9
  tailcall "camlCode__f_58" R/0[%eax] R/1[%ebx]
*** After live range splitting
camlCode__main1_61(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  spilled-a/17 := a/8 (spill)
  b/9 := R/1[%ebx]
  spilled-b/16 := b/9 (spill)
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := 5
  R/0[%eax] := a/8
  R/1[%ebx] := I/12
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/13 := 3
  R/0[%eax] := I/13
  b/18 := spilled-b/16 (reload)
  R/1[%ebx] := b/18
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/14 := 5
  a/19 := spilled-a/17 (reload)
  R/0[%eax] := a/19
  R/1[%ebx] := I/14
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/15 := 5
  R/0[%eax] := I/15
  b/20 := spilled-b/16 (reload)
  R/1[%ebx] := b/20
  tailcall "camlCode__f_58" R/0[%eax] R/1[%ebx]
*** Linearized code
camlCode__main1_61:
  spilled-a/17[s0] := a/8[%eax] (spill)
  spilled-b/16[s1] := b/9[%ebx] (spill)
  I/12[%ebx] := 5
  {spilled-b/16[s1]* spilled-a/17[s0]*}
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/13[%eax] := 3
  b/18[%ebx] := spilled-b/16[s1] (reload)
  {spilled-b/16[s1]* spilled-a/17[s0]*}
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/14[%ebx] := 5
  a/19[%eax] := spilled-a/17[s0] (reload)
  {spilled-b/16[s1]*}
  call "camlCode__f_58" R/0[%eax] R/1[%ebx]
  I/15[%eax] := 5
  b/20[%ebx] := spilled-b/16[s1] (reload)
  tailcall "camlCode__f_58" R/0[%eax] R/1[%ebx]
  
*** After instruction selection
camlCode__main2_66(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After spilling
camlCode__main2_66(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** After live range splitting
camlCode__main2_66(R/0[%eax] R/1[%ebx] R/2[%ecx] R/3[%edx])
  a/8 := R/0[%eax]
  b/9 := R/1[%ebx]
  c/10 := R/2[%ecx]
  d/11 := R/3[%edx]
  I/12 := c/10 + d/11 + -1
  R/0[%eax] := I/12
  return R/0[%eax]
*** Linearized code
camlCode__main2_66:
  I/12[%eax] := c/10[%ecx] + d/11[%edx] + -1
  return R/0[%eax]
  
*** After instruction selection
camlCode__entry()
  f/8 := "camlCode__3"
  ["camlCode"] := f/8
  main1/9 := "camlCode__2"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__1"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After spilling
camlCode__entry()
  f/8 := "camlCode__3"
  ["camlCode"] := f/8
  main1/9 := "camlCode__2"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__1"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  f/8 := "camlCode__3"
  ["camlCode"] := f/8
  main1/9 := "camlCode__2"
  ["camlCode" + 4] := main1/9
  main2/10 := "camlCode__1"
  ["camlCode" + 8] := main2/10
  A/11 := 1
  R/0[%eax] := A/11
  return R/0[%eax]
*** Linearized code
camlCode__entry:
  f/8[%eax] := "camlCode__3"
  ["camlCode"] := f/8[%eax]
  main1/9[%eax] := "camlCode__2"
  ["camlCode" + 4] := main1/9[%eax]
  main2/10[%eax] := "camlCode__1"
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
camlCode__1:
	.long	caml_curry4
	.long	9
	.long	camlCode__main2_66
	.data
	.long	3319
camlCode__2:
	.long	caml_curry4
	.long	9
	.long	camlCode__main1_61
	.data
	.long	3319
camlCode__3:
	.long	caml_curry2
	.long	5
	.long	camlCode__f_58
	.data
	.long	3324
camlCode__4:
	.ascii	"%d %d\12%!"
	.space	3
	.byte	3
	.text
	.align	16
	.globl	camlCode__f_58
camlCode__f_58:
	subl	$8, %esp
.L100:
	movl	%eax, 0(%esp)
	movl	%ebx, 4(%esp)
	movl	camlPervasives + 96, %eax
	call	camlPrintf__fprintf_423
.L101:
	movl	%eax, %edx
	movl	$camlCode__4, %eax
	movl	0(%esp), %ebx
	movl	4(%esp), %ecx
	addl	$8, %esp
	jmp	caml_apply3
	.type	camlCode__f_58,@function
	.size	camlCode__f_58,.-camlCode__f_58
	.text
	.align	16
	.globl	camlCode__main1_61
camlCode__main1_61:
	subl	$8, %esp
.L102:
	movl	%eax, 0(%esp)
	movl	%ebx, 4(%esp)
	movl	$5, %ebx
	call	camlCode__f_58
.L103:
	movl	$3, %eax
	movl	4(%esp), %ebx
	call	camlCode__f_58
.L104:
	movl	$5, %ebx
	movl	0(%esp), %eax
	call	camlCode__f_58
.L105:
	movl	$5, %eax
	movl	4(%esp), %ebx
	addl	$8, %esp
	jmp	camlCode__f_58
	.type	camlCode__main1_61,@function
	.size	camlCode__main1_61,.-camlCode__main1_61
	.text
	.align	16
	.globl	camlCode__main2_66
camlCode__main2_66:
.L106:
	lea	-1(%ecx, %edx), %eax
	ret
	.type	camlCode__main2_66,@function
	.size	camlCode__main2_66,.-camlCode__main2_66
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L107:
	movl	$camlCode__3, %eax
	movl	%eax, camlCode
	movl	$camlCode__2, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__1, %eax
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
	.long	4
	.long	.L105
	.word	12
	.word	1
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

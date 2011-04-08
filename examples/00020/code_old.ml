
let rec list_map f list =
  match list with
      [] -> []
    | x :: tail ->
	(f x) :: (list_map f tail)

let rec list_iter f list =
  match list with
      [] -> ()
    | x :: tail ->
	f x;
	list_iter f tail

let list1 = [ (1,2); (3,4); (5,6); (7,8) ]

let list2 = list_map (function (x,y) -> x) list1

let sum =
  let temp = ref 0 in
    list_iter (function y -> temp := !temp + y) list2

(*
-drawlambda
(seq
  (letrec
    (list_map/58
       (function f/59 list/60
         (if list/60
           (let (tail/62 (field 1 list/60) x/61 (field 0 list/60))
             (makeblock 0 (apply f/59 x/61) (apply list_map/58 f/59 tail/62)))
           0a)))
    (setfield_imm 0 (global Code!) list_map/58))
  (letrec
    (list_iter/63
       (function f/64 list/65
         (if list/65
           (let (tail/67 (field 1 list/65) x/66 (field 0 list/65))
             (seq (apply f/64 x/66) (apply list_iter/63 f/64 tail/67)))
           0a)))
    (setfield_imm 1 (global Code!) list_iter/63))
  (let (list1/68 [0: [0: 1 2] [0: [0: 3 4] [0: [0: 5 6] [0: [0: 7 8] 0a]]]])
    (setfield_imm 2 (global Code!) list1/68))
  (let
    (list2/69
       (apply (field 0 (global Code!))
         (function (param/80, param/81)
           (let (y/71 param/81 x/70 param/80) x/70))
         (field 2 (global Code!))))
    (setfield_imm 3 (global Code!) list2/69))
  (let
    (sum/72
       (let (temp/73 (makemutable 0 0))
         (apply (field 1 (global Code!))
           (function y/74
             (setfield_imm 0 temp/73 (+ (field 0 temp/73) y/74)))
           (field 3 (global Code!)))))
    (setfield_imm 4 (global Code!) sum/72))
  0a)
*** After instruction selection
camlCode__list_map_58(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
    A/12 := R/0[%eax]
    A/13 := [list/9]
    A/14 := [f/8]
    R/0[%eax] := A/13
    R/1[%ebx] := f/8
    R/0[%eax] := call A/14 R/0[%eax] R/1[%ebx]
    A/15 := R/0[%eax]
    A/16 := alloc 12
    [A/16 + -4] := 2048
    [A/16] := A/15
    [A/16 + 4] := A/12
    R/0[%eax] := A/16
    return R/0[%eax]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After spilling
camlCode__list_map_58(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
    A/12 := R/0[%eax]
    A/17 := A/12 (spill)
    list/9 := spilled-list/19 (reload)
    A/13 := [list/9]
    f/8 := spilled-f/18 (reload)
    A/14 := [f/8]
    R/0[%eax] := A/13
    R/1[%ebx] := f/8
    R/0[%eax] := call A/14 R/0[%eax] R/1[%ebx]
    A/15 := R/0[%eax]
    A/16 := alloc 12
    [A/16 + -4] := 2048
    [A/16] := A/15
    A/12 := A/17 (reload)
    [A/16 + 4] := A/12
    R/0[%eax] := A/16
    return R/0[%eax]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After live range splitting
camlCode__list_map_58(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
    A/12 := R/0[%eax]
    A/17 := A/12 (spill)
    list/20 := spilled-list/19 (reload)
    A/13 := [list/20]
    f/21 := spilled-f/18 (reload)
    A/14 := [f/21]
    R/0[%eax] := A/13
    R/1[%ebx] := f/21
    R/0[%eax] := call A/14 R/0[%eax] R/1[%ebx]
    A/15 := R/0[%eax]
    A/16 := alloc 12
    [A/16 + -4] := 2048
    [A/16] := A/15
    A/22 := A/17 (reload)
    [A/16 + 4] := A/22
    R/0[%eax] := A/16
    return R/0[%eax]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After instruction selection
camlCode__list_iter_63(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9]
    A/12 := [f/8]
    R/0[%eax] := A/11
    R/1[%ebx] := f/8
    call A/12 R/0[%eax] R/1[%ebx]
    A/13 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/13
    tailcall "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After spilling
camlCode__list_iter_63(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/15 := list/9 (spill)
    spilled-f/14 := f/8 (spill)
    A/11 := [list/9]
    A/12 := [f/8]
    R/0[%eax] := A/11
    R/1[%ebx] := f/8
    call A/12 R/0[%eax] R/1[%ebx]
    list/9 := spilled-list/15 (reload)
    A/13 := [list/9 + 4]
    f/8 := spilled-f/14 (reload)
    R/0[%eax] := f/8
    R/1[%ebx] := A/13
    tailcall "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After live range splitting
camlCode__list_iter_63(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/15 := list/9 (spill)
    spilled-f/14 := f/8 (spill)
    A/11 := [list/9]
    A/12 := [f/8]
    R/0[%eax] := A/11
    R/1[%ebx] := f/8
    call A/12 R/0[%eax] R/1[%ebx]
    list/16 := spilled-list/15 (reload)
    A/13 := [list/16 + 4]
    f/17 := spilled-f/14 (reload)
    R/0[%eax] := f/17
    R/1[%ebx] := A/13
    tailcall "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After instruction selection
camlCode__fun_86(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After spilling
camlCode__fun_86(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After live range splitting
camlCode__fun_86(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After instruction selection
camlCode__fun_88(R/0[%eax] R/1[%ebx])
  y/8 := R/0[%eax]
  env/9 := R/1[%ebx]
  A/10 := [env/9 + 8]
  A/11 := [env/9 + 8]
  A/12 := [A/11]
  I/13 := A/12 + y/8 + -1
  [A/10] := I/13
  A/14 := 1
  R/0[%eax] := A/14
  return R/0[%eax]
*** After spilling
camlCode__fun_88(R/0[%eax] R/1[%ebx])
  y/8 := R/0[%eax]
  env/9 := R/1[%ebx]
  A/10 := [env/9 + 8]
  A/11 := [env/9 + 8]
  A/12 := [A/11]
  I/13 := A/12 + y/8 + -1
  [A/10] := I/13
  A/14 := 1
  R/0[%eax] := A/14
  return R/0[%eax]
*** After live range splitting
camlCode__fun_88(R/0[%eax] R/1[%ebx])
  y/8 := R/0[%eax]
  env/9 := R/1[%ebx]
  A/10 := [env/9 + 8]
  A/11 := [env/9 + 8]
  A/12 := [A/11]
  I/13 := A/12 + y/8 + -1
  [A/10] := I/13
  A/14 := 1
  R/0[%eax] := A/14
  return R/0[%eax]
*** After instruction selection
camlCode__entry()
  clos/8 := "camlCode__4"
  ["camlCode"] := clos/8
  clos/9 := "camlCode__3"
  ["camlCode" + 4] := clos/9
  list1/10 := "camlCode__2"
  ["camlCode" + 8] := list1/10
  A/11 := ["camlCode" + 8]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := A/11
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  list2/13 := R/0[%eax]
  ["camlCode" + 12] := list2/13
  temp/14 := alloc 8
  [temp/14 + -4] := 1024
  [temp/14] := 1
  A/15 := alloc 16
  [A/15 + -4] := 3319
  [A/15] := "camlCode__fun_88"
  [A/15 + 4] := 3
  [A/15 + 8] := temp/14
  A/16 := ["camlCode" + 12]
  R/0[%eax] := A/15
  R/1[%ebx] := A/16
  R/0[%eax] := call "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  sum/17 := R/0[%eax]
  ["camlCode" + 16] := sum/17
  A/18 := 1
  R/0[%eax] := A/18
  return R/0[%eax]
*** After spilling
camlCode__entry()
  clos/8 := "camlCode__4"
  ["camlCode"] := clos/8
  clos/9 := "camlCode__3"
  ["camlCode" + 4] := clos/9
  list1/10 := "camlCode__2"
  ["camlCode" + 8] := list1/10
  A/11 := ["camlCode" + 8]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := A/11
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  list2/13 := R/0[%eax]
  ["camlCode" + 12] := list2/13
  temp/14 := alloc 24
  [temp/14 + -4] := 1024
  [temp/14] := 1
  A/15 := temp/14 + 8
  [A/15 + -4] := 3319
  [A/15] := "camlCode__fun_88"
  [A/15 + 4] := 3
  [A/15 + 8] := temp/14
  A/16 := ["camlCode" + 12]
  R/0[%eax] := A/15
  R/1[%ebx] := A/16
  R/0[%eax] := call "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  sum/17 := R/0[%eax]
  ["camlCode" + 16] := sum/17
  A/18 := 1
  R/0[%eax] := A/18
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  clos/8 := "camlCode__4"
  ["camlCode"] := clos/8
  clos/9 := "camlCode__3"
  ["camlCode" + 4] := clos/9
  list1/10 := "camlCode__2"
  ["camlCode" + 8] := list1/10
  A/11 := ["camlCode" + 8]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := A/11
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  list2/13 := R/0[%eax]
  ["camlCode" + 12] := list2/13
  temp/14 := alloc 24
  [temp/14 + -4] := 1024
  [temp/14] := 1
  A/15 := temp/14 + 8
  [A/15 + -4] := 3319
  [A/15] := "camlCode__fun_88"
  [A/15 + 4] := 3
  [A/15 + 8] := temp/14
  A/16 := ["camlCode" + 12]
  R/0[%eax] := A/15
  R/1[%ebx] := A/16
  R/0[%eax] := call "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  sum/17 := R/0[%eax]
  ["camlCode" + 16] := sum/17
  A/18 := 1
  R/0[%eax] := A/18
  return R/0[%eax]
-dlambda
(seq
  (letrec
    (list_map/58
       (function f/59 list/60
         (if list/60
           (makeblock 0 (apply f/59 (field 0 list/60))
             (apply list_map/58 f/59 (field 1 list/60)))
           0a)))
    (setfield_imm 0 (global Code!) list_map/58))
  (letrec
    (list_iter/63
       (function f/64 list/65
         (if list/65
           (seq (apply f/64 (field 0 list/65))
             (apply list_iter/63 f/64 (field 1 list/65)))
           0a)))
    (setfield_imm 1 (global Code!) list_iter/63))
  (let (list1/68 [0: [0: 1 2] [0: [0: 3 4] [0: [0: 5 6] [0: [0: 7 8] 0a]]]])
    (setfield_imm 2 (global Code!) list1/68))
  (let
    (list2/69
       (apply (field 0 (global Code!))
         (function (param/80, param/81) param/80) (field 2 (global Code!))))
    (setfield_imm 3 (global Code!) list2/69))
  (let
    (sum/72
       (let (temp/73 (makemutable 0 0))
         (apply (field 1 (global Code!))
           (function y/74
             (setfield_imm 0 temp/73 (+ (field 0 temp/73) y/74)))
           (field 3 (global Code!)))))
    (setfield_imm 4 (global Code!) sum/72))
  0a)
*** After instruction selection
camlCode__list_map_58(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
    A/12 := R/0[%eax]
    A/13 := [list/9]
    A/14 := [f/8]
    R/0[%eax] := A/13
    R/1[%ebx] := f/8
    R/0[%eax] := call A/14 R/0[%eax] R/1[%ebx]
    A/15 := R/0[%eax]
    A/16 := alloc 12
    [A/16 + -4] := 2048
    [A/16] := A/15
    [A/16 + 4] := A/12
    R/0[%eax] := A/16
    return R/0[%eax]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After spilling
camlCode__list_map_58(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
    A/12 := R/0[%eax]
    A/17 := A/12 (spill)
    list/9 := spilled-list/19 (reload)
    A/13 := [list/9]
    f/8 := spilled-f/18 (reload)
    A/14 := [f/8]
    R/0[%eax] := A/13
    R/1[%ebx] := f/8
    R/0[%eax] := call A/14 R/0[%eax] R/1[%ebx]
    A/15 := R/0[%eax]
    A/16 := alloc 12
    [A/16 + -4] := 2048
    [A/16] := A/15
    A/12 := A/17 (reload)
    [A/16 + 4] := A/12
    R/0[%eax] := A/16
    return R/0[%eax]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After live range splitting
camlCode__list_map_58(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
    A/12 := R/0[%eax]
    A/17 := A/12 (spill)
    list/20 := spilled-list/19 (reload)
    A/13 := [list/20]
    f/21 := spilled-f/18 (reload)
    A/14 := [f/21]
    R/0[%eax] := A/13
    R/1[%ebx] := f/21
    R/0[%eax] := call A/14 R/0[%eax] R/1[%ebx]
    A/15 := R/0[%eax]
    A/16 := alloc 12
    [A/16 + -4] := 2048
    [A/16] := A/15
    A/22 := A/17 (reload)
    [A/16 + 4] := A/22
    R/0[%eax] := A/16
    return R/0[%eax]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After instruction selection
camlCode__list_iter_63(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9]
    A/12 := [f/8]
    R/0[%eax] := A/11
    R/1[%ebx] := f/8
    call A/12 R/0[%eax] R/1[%ebx]
    A/13 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/13
    tailcall "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After spilling
camlCode__list_iter_63(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/15 := list/9 (spill)
    spilled-f/14 := f/8 (spill)
    A/11 := [list/9]
    A/12 := [f/8]
    R/0[%eax] := A/11
    R/1[%ebx] := f/8
    call A/12 R/0[%eax] R/1[%ebx]
    list/9 := spilled-list/15 (reload)
    A/13 := [list/9 + 4]
    f/8 := spilled-f/14 (reload)
    R/0[%eax] := f/8
    R/1[%ebx] := A/13
    tailcall "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After live range splitting
camlCode__list_iter_63(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/15 := list/9 (spill)
    spilled-f/14 := f/8 (spill)
    A/11 := [list/9]
    A/12 := [f/8]
    R/0[%eax] := A/11
    R/1[%ebx] := f/8
    call A/12 R/0[%eax] R/1[%ebx]
    list/16 := spilled-list/15 (reload)
    A/13 := [list/16 + 4]
    f/17 := spilled-f/14 (reload)
    R/0[%eax] := f/17
    R/1[%ebx] := A/13
    tailcall "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After instruction selection
camlCode__fun_86(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After spilling
camlCode__fun_86(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After live range splitting
camlCode__fun_86(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After instruction selection
camlCode__fun_88(R/0[%eax] R/1[%ebx])
  y/8 := R/0[%eax]
  env/9 := R/1[%ebx]
  A/10 := [env/9 + 8]
  A/11 := [env/9 + 8]
  A/12 := [A/11]
  I/13 := A/12 + y/8 + -1
  [A/10] := I/13
  A/14 := 1
  R/0[%eax] := A/14
  return R/0[%eax]
*** After spilling
camlCode__fun_88(R/0[%eax] R/1[%ebx])
  y/8 := R/0[%eax]
  env/9 := R/1[%ebx]
  A/10 := [env/9 + 8]
  A/11 := [env/9 + 8]
  A/12 := [A/11]
  I/13 := A/12 + y/8 + -1
  [A/10] := I/13
  A/14 := 1
  R/0[%eax] := A/14
  return R/0[%eax]
*** After live range splitting
camlCode__fun_88(R/0[%eax] R/1[%ebx])
  y/8 := R/0[%eax]
  env/9 := R/1[%ebx]
  A/10 := [env/9 + 8]
  A/11 := [env/9 + 8]
  A/12 := [A/11]
  I/13 := A/12 + y/8 + -1
  [A/10] := I/13
  A/14 := 1
  R/0[%eax] := A/14
  return R/0[%eax]
*** After instruction selection
camlCode__entry()
  clos/8 := "camlCode__4"
  ["camlCode"] := clos/8
  clos/9 := "camlCode__3"
  ["camlCode" + 4] := clos/9
  list1/10 := "camlCode__2"
  ["camlCode" + 8] := list1/10
  A/11 := ["camlCode" + 8]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := A/11
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  list2/13 := R/0[%eax]
  ["camlCode" + 12] := list2/13
  temp/14 := alloc 8
  [temp/14 + -4] := 1024
  [temp/14] := 1
  A/15 := alloc 16
  [A/15 + -4] := 3319
  [A/15] := "camlCode__fun_88"
  [A/15 + 4] := 3
  [A/15 + 8] := temp/14
  A/16 := ["camlCode" + 12]
  R/0[%eax] := A/15
  R/1[%ebx] := A/16
  R/0[%eax] := call "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  sum/17 := R/0[%eax]
  ["camlCode" + 16] := sum/17
  A/18 := 1
  R/0[%eax] := A/18
  return R/0[%eax]
*** After spilling
camlCode__entry()
  clos/8 := "camlCode__4"
  ["camlCode"] := clos/8
  clos/9 := "camlCode__3"
  ["camlCode" + 4] := clos/9
  list1/10 := "camlCode__2"
  ["camlCode" + 8] := list1/10
  A/11 := ["camlCode" + 8]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := A/11
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  list2/13 := R/0[%eax]
  ["camlCode" + 12] := list2/13
  temp/14 := alloc 24
  [temp/14 + -4] := 1024
  [temp/14] := 1
  A/15 := temp/14 + 8
  [A/15 + -4] := 3319
  [A/15] := "camlCode__fun_88"
  [A/15 + 4] := 3
  [A/15 + 8] := temp/14
  A/16 := ["camlCode" + 12]
  R/0[%eax] := A/15
  R/1[%ebx] := A/16
  R/0[%eax] := call "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  sum/17 := R/0[%eax]
  ["camlCode" + 16] := sum/17
  A/18 := 1
  R/0[%eax] := A/18
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  clos/8 := "camlCode__4"
  ["camlCode"] := clos/8
  clos/9 := "camlCode__3"
  ["camlCode" + 4] := clos/9
  list1/10 := "camlCode__2"
  ["camlCode" + 8] := list1/10
  A/11 := ["camlCode" + 8]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := A/11
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  list2/13 := R/0[%eax]
  ["camlCode" + 12] := list2/13
  temp/14 := alloc 24
  [temp/14 + -4] := 1024
  [temp/14] := 1
  A/15 := temp/14 + 8
  [A/15 + -4] := 3319
  [A/15] := "camlCode__fun_88"
  [A/15 + 4] := 3
  [A/15 + 8] := temp/14
  A/16 := ["camlCode" + 12]
  R/0[%eax] := A/15
  R/1[%ebx] := A/16
  R/0[%eax] := call "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  sum/17 := R/0[%eax]
  ["camlCode" + 16] := sum/17
  A/18 := 1
  R/0[%eax] := A/18
  return R/0[%eax]

-dcmm
(data int 5120 global "camlCode" "camlCode": skip 20)
(data
 int 3319
 "camlCode__1":
 addr "caml_tuplify2"
 int -3
 addr "camlCode__fun_86")
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__list_iter_63")
(data
 int 3319
 "camlCode__4":
 addr "caml_curry2"
 int 5
 addr "camlCode__list_map_58")
(data
 int 2048
 "camlCode__2":
 addr L5
 addr L6
 int 2048
 L6:
 addr L7
 addr L8
 int 2048
 L8:
 addr L9
 addr L10
 int 2048
 L10:
 addr L11
 int 1
 int 2048
 L11:
 int 15
 int 17
 int 2048
 L9:
 int 11
 int 13
 int 2048
 L7:
 int 7
 int 9
 int 2048
 L5:
 int 3
 int 5)
(function camlCode__list_map_58 (f/59: addr list/60: addr)
 (if (!= list/60 1)
   (alloc 2048 (app (load f/59) (load list/60) f/59 addr)
     (app "camlCode__list_map_58" f/59 (load (+a list/60 4)) addr))
   1a))

*** After instruction selection
camlCode__list_map_58(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
    A/12 := R/0[%eax]
    A/13 := [list/9]
    A/14 := [f/8]
    R/0[%eax] := A/13
    R/1[%ebx] := f/8
    R/0[%eax] := call A/14 R/0[%eax] R/1[%ebx]
    A/15 := R/0[%eax]
    A/16 := alloc 12
    [A/16 + -4] := 2048
    [A/16] := A/15
    [A/16 + 4] := A/12
    R/0[%eax] := A/16
    return R/0[%eax]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After spilling
camlCode__list_map_58(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
    A/12 := R/0[%eax]
    A/17 := A/12 (spill)
    list/9 := spilled-list/19 (reload)
    A/13 := [list/9]
    f/8 := spilled-f/18 (reload)
    A/14 := [f/8]
    R/0[%eax] := A/13
    R/1[%ebx] := f/8
    R/0[%eax] := call A/14 R/0[%eax] R/1[%ebx]
    A/15 := R/0[%eax]
    A/16 := alloc 12
    [A/16 + -4] := 2048
    [A/16] := A/15
    A/12 := A/17 (reload)
    [A/16 + 4] := A/12
    R/0[%eax] := A/16
    return R/0[%eax]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After live range splitting
camlCode__list_map_58(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
    A/12 := R/0[%eax]
    A/17 := A/12 (spill)
    list/20 := spilled-list/19 (reload)
    A/13 := [list/20]
    f/21 := spilled-f/18 (reload)
    A/14 := [f/21]
    R/0[%eax] := A/13
    R/1[%ebx] := f/21
    R/0[%eax] := call A/14 R/0[%eax] R/1[%ebx]
    A/15 := R/0[%eax]
    A/16 := alloc 12
    [A/16 + -4] := 2048
    [A/16] := A/15
    A/22 := A/17 (reload)
    [A/16 + 4] := A/22
    R/0[%eax] := A/16
    return R/0[%eax]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
(function camlCode__list_iter_63 (f/64: addr list/65: addr)
 (if (!= list/65 1)
   (seq (app (load f/64) (load list/65) f/64 unit)
     (app "camlCode__list_iter_63" f/64 (load (+a list/65 4)) addr))
   1a))

*** After instruction selection
camlCode__list_iter_63(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9]
    A/12 := [f/8]
    R/0[%eax] := A/11
    R/1[%ebx] := f/8
    call A/12 R/0[%eax] R/1[%ebx]
    A/13 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/13
    tailcall "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After spilling
camlCode__list_iter_63(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/15 := list/9 (spill)
    spilled-f/14 := f/8 (spill)
    A/11 := [list/9]
    A/12 := [f/8]
    R/0[%eax] := A/11
    R/1[%ebx] := f/8
    call A/12 R/0[%eax] R/1[%ebx]
    list/9 := spilled-list/15 (reload)
    A/13 := [list/9 + 4]
    f/8 := spilled-f/14 (reload)
    R/0[%eax] := f/8
    R/1[%ebx] := A/13
    tailcall "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After live range splitting
camlCode__list_iter_63(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/15 := list/9 (spill)
    spilled-f/14 := f/8 (spill)
    A/11 := [list/9]
    A/12 := [f/8]
    R/0[%eax] := A/11
    R/1[%ebx] := f/8
    call A/12 R/0[%eax] R/1[%ebx]
    list/16 := spilled-list/15 (reload)
    A/13 := [list/16 + 4]
    f/17 := spilled-f/14 (reload)
    R/0[%eax] := f/17
    R/1[%ebx] := A/13
    tailcall "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
(function camlCode__fun_86 (param/80: addr param/81: addr) param/80)

*** After instruction selection
camlCode__fun_86(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After spilling
camlCode__fun_86(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After live range splitting
camlCode__fun_86(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
(function camlCode__fun_88 (y/74: addr env/90: addr)
 (store (load (+a env/90 8)) (+ (+ (load (load (+a env/90 8))) y/74) -1)) 1a)

*** After instruction selection
camlCode__fun_88(R/0[%eax] R/1[%ebx])
  y/8 := R/0[%eax]
  env/9 := R/1[%ebx]
  A/10 := [env/9 + 8]
  A/11 := [env/9 + 8]
  A/12 := [A/11]
  I/13 := A/12 + y/8 + -1
  [A/10] := I/13
  A/14 := 1
  R/0[%eax] := A/14
  return R/0[%eax]
*** After spilling
camlCode__fun_88(R/0[%eax] R/1[%ebx])
  y/8 := R/0[%eax]
  env/9 := R/1[%ebx]
  A/10 := [env/9 + 8]
  A/11 := [env/9 + 8]
  A/12 := [A/11]
  I/13 := A/12 + y/8 + -1
  [A/10] := I/13
  A/14 := 1
  R/0[%eax] := A/14
  return R/0[%eax]
*** After live range splitting
camlCode__fun_88(R/0[%eax] R/1[%ebx])
  y/8 := R/0[%eax]
  env/9 := R/1[%ebx]
  A/10 := [env/9 + 8]
  A/11 := [env/9 + 8]
  A/12 := [A/11]
  I/13 := A/12 + y/8 + -1
  [A/10] := I/13
  A/14 := 1
  R/0[%eax] := A/14
  return R/0[%eax]
(function camlCode__entry ()
 (let clos/83 "camlCode__4" (store "camlCode" clos/83))
 (let clos/85 "camlCode__3" (store (+a "camlCode" 4) clos/85))
 (let list1/68 "camlCode__2" (store (+a "camlCode" 8) list1/68))
 (let
   list2/69
     (app "camlCode__list_map_58" "camlCode__1" (load (+a "camlCode" 8))
       addr)
   (store (+a "camlCode" 12) list2/69))
 (let
   sum/72
     (let temp/73 (alloc 1024 1)
       (app "camlCode__list_iter_63"
         (alloc 3319 "camlCode__fun_88" 3 temp/73) (load (+a "camlCode" 12))
         addr))
   (store (+a "camlCode" 16) sum/72))
 1a)

*** After instruction selection
camlCode__entry()
  clos/8 := "camlCode__4"
  ["camlCode"] := clos/8
  clos/9 := "camlCode__3"
  ["camlCode" + 4] := clos/9
  list1/10 := "camlCode__2"
  ["camlCode" + 8] := list1/10
  A/11 := ["camlCode" + 8]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := A/11
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  list2/13 := R/0[%eax]
  ["camlCode" + 12] := list2/13
  temp/14 := alloc 8
  [temp/14 + -4] := 1024
  [temp/14] := 1
  A/15 := alloc 16
  [A/15 + -4] := 3319
  [A/15] := "camlCode__fun_88"
  [A/15 + 4] := 3
  [A/15 + 8] := temp/14
  A/16 := ["camlCode" + 12]
  R/0[%eax] := A/15
  R/1[%ebx] := A/16
  R/0[%eax] := call "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  sum/17 := R/0[%eax]
  ["camlCode" + 16] := sum/17
  A/18 := 1
  R/0[%eax] := A/18
  return R/0[%eax]
*** After spilling
camlCode__entry()
  clos/8 := "camlCode__4"
  ["camlCode"] := clos/8
  clos/9 := "camlCode__3"
  ["camlCode" + 4] := clos/9
  list1/10 := "camlCode__2"
  ["camlCode" + 8] := list1/10
  A/11 := ["camlCode" + 8]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := A/11
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  list2/13 := R/0[%eax]
  ["camlCode" + 12] := list2/13
  temp/14 := alloc 24
  [temp/14 + -4] := 1024
  [temp/14] := 1
  A/15 := temp/14 + 8
  [A/15 + -4] := 3319
  [A/15] := "camlCode__fun_88"
  [A/15 + 4] := 3
  [A/15 + 8] := temp/14
  A/16 := ["camlCode" + 12]
  R/0[%eax] := A/15
  R/1[%ebx] := A/16
  R/0[%eax] := call "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  sum/17 := R/0[%eax]
  ["camlCode" + 16] := sum/17
  A/18 := 1
  R/0[%eax] := A/18
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  clos/8 := "camlCode__4"
  ["camlCode"] := clos/8
  clos/9 := "camlCode__3"
  ["camlCode" + 4] := clos/9
  list1/10 := "camlCode__2"
  ["camlCode" + 8] := list1/10
  A/11 := ["camlCode" + 8]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := A/11
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  list2/13 := R/0[%eax]
  ["camlCode" + 12] := list2/13
  temp/14 := alloc 24
  [temp/14 + -4] := 1024
  [temp/14] := 1
  A/15 := temp/14 + 8
  [A/15 + -4] := 3319
  [A/15] := "camlCode__fun_88"
  [A/15 + 4] := 3
  [A/15 + 8] := temp/14
  A/16 := ["camlCode" + 12]
  R/0[%eax] := A/15
  R/1[%ebx] := A/16
  R/0[%eax] := call "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  sum/17 := R/0[%eax]
  ["camlCode" + 16] := sum/17
  A/18 := 1
  R/0[%eax] := A/18
  return R/0[%eax]
(data)
-dlinear
*** After instruction selection
camlCode__list_map_58(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
    A/12 := R/0[%eax]
    A/13 := [list/9]
    A/14 := [f/8]
    R/0[%eax] := A/13
    R/1[%ebx] := f/8
    R/0[%eax] := call A/14 R/0[%eax] R/1[%ebx]
    A/15 := R/0[%eax]
    A/16 := alloc 12
    [A/16 + -4] := 2048
    [A/16] := A/15
    [A/16 + 4] := A/12
    R/0[%eax] := A/16
    return R/0[%eax]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After spilling
camlCode__list_map_58(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
    A/12 := R/0[%eax]
    A/17 := A/12 (spill)
    list/9 := spilled-list/19 (reload)
    A/13 := [list/9]
    f/8 := spilled-f/18 (reload)
    A/14 := [f/8]
    R/0[%eax] := A/13
    R/1[%ebx] := f/8
    R/0[%eax] := call A/14 R/0[%eax] R/1[%ebx]
    A/15 := R/0[%eax]
    A/16 := alloc 12
    [A/16 + -4] := 2048
    [A/16] := A/15
    A/12 := A/17 (reload)
    [A/16 + 4] := A/12
    R/0[%eax] := A/16
    return R/0[%eax]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After live range splitting
camlCode__list_map_58(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
    A/12 := R/0[%eax]
    A/17 := A/12 (spill)
    list/20 := spilled-list/19 (reload)
    A/13 := [list/20]
    f/21 := spilled-f/18 (reload)
    A/14 := [f/21]
    R/0[%eax] := A/13
    R/1[%ebx] := f/21
    R/0[%eax] := call A/14 R/0[%eax] R/1[%ebx]
    A/15 := R/0[%eax]
    A/16 := alloc 12
    [A/16 + -4] := 2048
    [A/16] := A/15
    A/22 := A/17 (reload)
    [A/16 + 4] := A/22
    R/0[%eax] := A/16
    return R/0[%eax]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** Linearized code
camlCode__list_map_58:
  if list/9[%ebx] ==s 1 goto L100
  spilled-list/19[s0] := list/9[%ebx] (spill)
  spilled-f/18[s1] := f/8[%eax] (spill)
  A/11[%ebx] := [list/9[%ebx] + 4]
  {spilled-f/18[s1]* spilled-list/19[s0]*}
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  A/17[s2] := A/12[%eax] (spill)
  list/20[%eax] := spilled-list/19[s0] (reload)
  A/13[%eax] := [list/20[%eax]]
  f/21[%ebx] := spilled-f/18[s1] (reload)
  A/14[%ecx] := [f/21[%ebx]]
  {A/17[s2]*}
  R/0[%eax] := call A/14[%ecx] R/0[%eax] R/1[%ebx]
  A/15[%ebx] := R/0[%eax]
  {A/15[%ebx]* A/17[s2]*}
  A/16[%eax] := alloc 12
  [A/16[%eax] + -4] := 2048
  [A/16[%eax]] := A/15[%ebx]
  A/22[%ebx] := A/17[s2] (reload)
  [A/16[%eax] + 4] := A/22[%ebx]
  reload retaddr
  return R/0[%eax]
  L100:
  A/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
*** After instruction selection
camlCode__list_iter_63(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9]
    A/12 := [f/8]
    R/0[%eax] := A/11
    R/1[%ebx] := f/8
    call A/12 R/0[%eax] R/1[%ebx]
    A/13 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/13
    tailcall "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After spilling
camlCode__list_iter_63(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/15 := list/9 (spill)
    spilled-f/14 := f/8 (spill)
    A/11 := [list/9]
    A/12 := [f/8]
    R/0[%eax] := A/11
    R/1[%ebx] := f/8
    call A/12 R/0[%eax] R/1[%ebx]
    list/9 := spilled-list/15 (reload)
    A/13 := [list/9 + 4]
    f/8 := spilled-f/14 (reload)
    R/0[%eax] := f/8
    R/1[%ebx] := A/13
    tailcall "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** After live range splitting
camlCode__list_iter_63(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/15 := list/9 (spill)
    spilled-f/14 := f/8 (spill)
    A/11 := [list/9]
    A/12 := [f/8]
    R/0[%eax] := A/11
    R/1[%ebx] := f/8
    call A/12 R/0[%eax] R/1[%ebx]
    list/16 := spilled-list/15 (reload)
    A/13 := [list/16 + 4]
    f/17 := spilled-f/14 (reload)
    R/0[%eax] := f/17
    R/1[%ebx] := A/13
    tailcall "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  else
    A/10 := 1
    R/0[%eax] := A/10
    return R/0[%eax]
  endif
*** Linearized code
camlCode__list_iter_63:
  f/8[%edx] := R/0[%eax]
  if list/9[%ebx] ==s 1 goto L107
  spilled-list/15[s0] := list/9[%ebx] (spill)
  spilled-f/14[s1] := f/8[%edx] (spill)
  A/11[%eax] := [list/9[%ebx]]
  A/12[%ecx] := [f/8[%edx]]
  R/1[%ebx] := f/8[%edx]
  {spilled-f/14[s1]* spilled-list/15[s0]*}
  call A/12[%ecx] R/0[%eax] R/1[%ebx]
  list/16[%eax] := spilled-list/15[s0] (reload)
  A/13[%ebx] := [list/16[%eax] + 4]
  f/17[%eax] := spilled-f/14[s1] (reload)
  tailcall "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  L107:
  A/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
*** After instruction selection
camlCode__fun_86(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After spilling
camlCode__fun_86(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After live range splitting
camlCode__fun_86(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** Linearized code
camlCode__fun_86:
  return R/0[%eax]
  
*** After instruction selection
camlCode__fun_88(R/0[%eax] R/1[%ebx])
  y/8 := R/0[%eax]
  env/9 := R/1[%ebx]
  A/10 := [env/9 + 8]
  A/11 := [env/9 + 8]
  A/12 := [A/11]
  I/13 := A/12 + y/8 + -1
  [A/10] := I/13
  A/14 := 1
  R/0[%eax] := A/14
  return R/0[%eax]
*** After spilling
camlCode__fun_88(R/0[%eax] R/1[%ebx])
  y/8 := R/0[%eax]
  env/9 := R/1[%ebx]
  A/10 := [env/9 + 8]
  A/11 := [env/9 + 8]
  A/12 := [A/11]
  I/13 := A/12 + y/8 + -1
  [A/10] := I/13
  A/14 := 1
  R/0[%eax] := A/14
  return R/0[%eax]
*** After live range splitting
camlCode__fun_88(R/0[%eax] R/1[%ebx])
  y/8 := R/0[%eax]
  env/9 := R/1[%ebx]
  A/10 := [env/9 + 8]
  A/11 := [env/9 + 8]
  A/12 := [A/11]
  I/13 := A/12 + y/8 + -1
  [A/10] := I/13
  A/14 := 1
  R/0[%eax] := A/14
  return R/0[%eax]
*** Linearized code
camlCode__fun_88:
  A/10[%ecx] := [env/9[%ebx] + 8]
  A/11[%ebx] := [env/9[%ebx] + 8]
  A/12[%ebx] := [A/11[%ebx]]
  I/13[%eax] := A/12[%ebx] + y/8[%eax] + -1
  [A/10[%ecx]] := I/13[%eax]
  A/14[%eax] := 1
  return R/0[%eax]
  
*** After instruction selection
camlCode__entry()
  clos/8 := "camlCode__4"
  ["camlCode"] := clos/8
  clos/9 := "camlCode__3"
  ["camlCode" + 4] := clos/9
  list1/10 := "camlCode__2"
  ["camlCode" + 8] := list1/10
  A/11 := ["camlCode" + 8]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := A/11
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  list2/13 := R/0[%eax]
  ["camlCode" + 12] := list2/13
  temp/14 := alloc 8
  [temp/14 + -4] := 1024
  [temp/14] := 1
  A/15 := alloc 16
  [A/15 + -4] := 3319
  [A/15] := "camlCode__fun_88"
  [A/15 + 4] := 3
  [A/15 + 8] := temp/14
  A/16 := ["camlCode" + 12]
  R/0[%eax] := A/15
  R/1[%ebx] := A/16
  R/0[%eax] := call "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  sum/17 := R/0[%eax]
  ["camlCode" + 16] := sum/17
  A/18 := 1
  R/0[%eax] := A/18
  return R/0[%eax]
*** After spilling
camlCode__entry()
  clos/8 := "camlCode__4"
  ["camlCode"] := clos/8
  clos/9 := "camlCode__3"
  ["camlCode" + 4] := clos/9
  list1/10 := "camlCode__2"
  ["camlCode" + 8] := list1/10
  A/11 := ["camlCode" + 8]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := A/11
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  list2/13 := R/0[%eax]
  ["camlCode" + 12] := list2/13
  temp/14 := alloc 24
  [temp/14 + -4] := 1024
  [temp/14] := 1
  A/15 := temp/14 + 8
  [A/15 + -4] := 3319
  [A/15] := "camlCode__fun_88"
  [A/15 + 4] := 3
  [A/15 + 8] := temp/14
  A/16 := ["camlCode" + 12]
  R/0[%eax] := A/15
  R/1[%ebx] := A/16
  R/0[%eax] := call "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  sum/17 := R/0[%eax]
  ["camlCode" + 16] := sum/17
  A/18 := 1
  R/0[%eax] := A/18
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  clos/8 := "camlCode__4"
  ["camlCode"] := clos/8
  clos/9 := "camlCode__3"
  ["camlCode" + 4] := clos/9
  list1/10 := "camlCode__2"
  ["camlCode" + 8] := list1/10
  A/11 := ["camlCode" + 8]
  A/12 := "camlCode__1"
  R/0[%eax] := A/12
  R/1[%ebx] := A/11
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  list2/13 := R/0[%eax]
  ["camlCode" + 12] := list2/13
  temp/14 := alloc 24
  [temp/14 + -4] := 1024
  [temp/14] := 1
  A/15 := temp/14 + 8
  [A/15 + -4] := 3319
  [A/15] := "camlCode__fun_88"
  [A/15 + 4] := 3
  [A/15 + 8] := temp/14
  A/16 := ["camlCode" + 12]
  R/0[%eax] := A/15
  R/1[%ebx] := A/16
  R/0[%eax] := call "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  sum/17 := R/0[%eax]
  ["camlCode" + 16] := sum/17
  A/18 := 1
  R/0[%eax] := A/18
  return R/0[%eax]
*** Linearized code
camlCode__entry:
  clos/8[%eax] := "camlCode__4"
  ["camlCode"] := clos/8[%eax]
  clos/9[%eax] := "camlCode__3"
  ["camlCode" + 4] := clos/9[%eax]
  list1/10[%eax] := "camlCode__2"
  ["camlCode" + 8] := list1/10[%eax]
  A/11[%ebx] := ["camlCode" + 8]
  A/12[%eax] := "camlCode__1"
  {}
  R/0[%eax] := call "camlCode__list_map_58" R/0[%eax] R/1[%ebx]
  ["camlCode" + 12] := list2/13[%eax]
  {}
  temp/14[%ebx] := alloc 24
  [temp/14[%ebx] + -4] := 1024
  [temp/14[%ebx]] := 1
  A/15[%eax] := temp/14[%ebx] + 8
  [A/15[%eax] + -4] := 3319
  [A/15[%eax]] := "camlCode__fun_88"
  [A/15[%eax] + 4] := 3
  [A/15[%eax] + 8] := temp/14[%ebx]
  A/16[%ebx] := ["camlCode" + 12]
  {}
  R/0[%eax] := call "camlCode__list_iter_63" R/0[%eax] R/1[%ebx]
  ["camlCode" + 16] := sum/17[%eax]
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
	.long	5120
	.globl	camlCode
camlCode:
	.space	20
	.data
	.long	3319
camlCode__1:
	.long	caml_tuplify2
	.long	-3
	.long	camlCode__fun_86
	.data
	.long	3319
camlCode__3:
	.long	caml_curry2
	.long	5
	.long	camlCode__list_iter_63
	.data
	.long	3319
camlCode__4:
	.long	caml_curry2
	.long	5
	.long	camlCode__list_map_58
	.data
	.long	2048
camlCode__2:
	.long	.L100005
	.long	.L100006
	.long	2048
.L100006:
	.long	.L100007
	.long	.L100008
	.long	2048
.L100008:
	.long	.L100009
	.long	.L100010
	.long	2048
.L100010:
	.long	.L100011
	.long	1
	.long	2048
.L100011:
	.long	15
	.long	17
	.long	2048
.L100009:
	.long	11
	.long	13
	.long	2048
.L100007:
	.long	7
	.long	9
	.long	2048
.L100005:
	.long	3
	.long	5
	.text
	.align	16
	.globl	camlCode__list_map_58
camlCode__list_map_58:
	subl	$12, %esp
.L101:
	cmpl	$1, %ebx
	je	.L100
	movl	%ebx, 0(%esp)
	movl	%eax, 4(%esp)
	movl	4(%ebx), %ebx
	call	camlCode__list_map_58
.L102:
	movl	%eax, 8(%esp)
	movl	0(%esp), %eax
	movl	(%eax), %eax
	movl	4(%esp), %ebx
	movl	(%ebx), %ecx
	call	*%ecx
.L103:
	movl	%eax, %ebx
.L104:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L105
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	%ebx, (%eax)
	movl	8(%esp), %ebx
	movl	%ebx, 4(%eax)
	addl	$12, %esp
	ret
	.align	16
.L100:
	movl	$1, %eax
	addl	$12, %esp
	ret
.L105:	call	caml_call_gc
.L106:	jmp	.L104
	.type	camlCode__list_map_58,@function
	.size	camlCode__list_map_58,.-camlCode__list_map_58
	.text
	.align	16
	.globl	camlCode__list_iter_63
camlCode__list_iter_63:
	subl	$8, %esp
.L108:
	movl	%eax, %edx
	cmpl	$1, %ebx
	je	.L107
	movl	%ebx, 0(%esp)
	movl	%edx, 4(%esp)
	movl	(%ebx), %eax
	movl	(%edx), %ecx
	movl	%edx, %ebx
	call	*%ecx
.L109:
	movl	0(%esp), %eax
	movl	4(%eax), %ebx
	movl	4(%esp), %eax
	jmp	.L108
	.align	16
.L107:
	movl	$1, %eax
	addl	$8, %esp
	ret
	.type	camlCode__list_iter_63,@function
	.size	camlCode__list_iter_63,.-camlCode__list_iter_63
	.text
	.align	16
	.globl	camlCode__fun_86
camlCode__fun_86:
.L110:
	ret
	.type	camlCode__fun_86,@function
	.size	camlCode__fun_86,.-camlCode__fun_86
	.text
	.align	16
	.globl	camlCode__fun_88
camlCode__fun_88:
.L111:
	movl	8(%ebx), %ecx
	movl	8(%ebx), %ebx
	movl	(%ebx), %ebx
	lea	-1(%ebx, %eax), %eax
	movl	%eax, (%ecx)
	movl	$1, %eax
	ret
	.type	camlCode__fun_88,@function
	.size	camlCode__fun_88,.-camlCode__fun_88
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L112:
	movl	$camlCode__4, %eax
	movl	%eax, camlCode
	movl	$camlCode__3, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__2, %eax
	movl	%eax, camlCode + 8
	movl	camlCode + 8, %ebx
	movl	$camlCode__1, %eax
	call	camlCode__list_map_58
.L113:
	movl	%eax, camlCode + 12
	movl	$24, %eax
	call	caml_allocN
.L114:
	leal	4(%eax), %ebx
	movl	$1024, -4(%ebx)
	movl	$1, (%ebx)
	leal	8(%ebx), %eax
	movl	$3319, -4(%eax)
	movl	$camlCode__fun_88, (%eax)
	movl	$3, 4(%eax)
	movl	%ebx, 8(%eax)
	movl	camlCode + 12, %ebx
	call	camlCode__list_iter_63
.L115:
	movl	%eax, camlCode + 16
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
	.long	7
	.long	.L115
	.word	4
	.word	0
	.align	4
	.long	.L114
	.word	4
	.word	0
	.align	4
	.long	.L113
	.word	4
	.word	0
	.align	4
	.long	.L109
	.word	12
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L106
	.word	16
	.word	2
	.word	8
	.word	3
	.align	4
	.long	.L103
	.word	16
	.word	1
	.word	8
	.align	4
	.long	.L102
	.word	16
	.word	2
	.word	0
	.word	4
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

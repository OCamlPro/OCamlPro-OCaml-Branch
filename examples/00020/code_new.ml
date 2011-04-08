
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
    (list_map/1030
       (function f/1031 list/1032
         (if list/1032
           (let (tail/1034 (field 1 list/1032) x/1033 (field 0 list/1032))
             (makeblock 0 (apply f/1031 x/1033)
               (apply list_map/1030 f/1031 tail/1034)))
           0a)))
    (setfield_imm 0 (global Code!) list_map/1030))
  (letrec
    (list_iter/1035
       (function f/1036 list/1037
         (if list/1037
           (let (tail/1039 (field 1 list/1037) x/1038 (field 0 list/1037))
             (seq (apply f/1036 x/1038)
               (apply list_iter/1035 f/1036 tail/1039)))
           0a)))
    (setfield_imm 1 (global Code!) list_iter/1035))
  (let
    (list1/1040 [0: [0: 1 2] [0: [0: 3 4] [0: [0: 5 6] [0: [0: 7 8] 0a]]]])
    (setfield_imm 2 (global Code!) list1/1040))
  (let
    (list2/1041
       (apply (field 0 (global Code!))
         (function (param/1052, param/1053)
           (let (y/1043 param/1053 x/1042 param/1052) x/1042))
         (field 2 (global Code!))))
    (setfield_imm 3 (global Code!) list2/1041))
  (let
    (sum/1044
       (let (temp/1045 (makemutable 0 0))
         (apply (field 1 (global Code!))
           (function y/1046
             (setfield_imm 0 temp/1045 (+ (field 0 temp/1045) y/1046)))
           (field 3 (global Code!)))))
    (setfield_imm 4 (global Code!) sum/1044))
  0a)
*** After instruction selection
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  f/11 := f/8
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          A/14 := [f/11]
          R/0[%eax] := A/13
          R/1[%ebx] := f/11
          call A/14 R/0[%eax] R/1[%ebx]
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
*** After spilling
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  spilled-list/18 := list/10 (spill)
  f/11 := f/8
  spilled-f/19 := f/11 (spill)
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          f/11 := spilled-f/19 (reload)
          A/14 := [f/11]
          R/0[%eax] := A/13
          R/1[%ebx] := f/11
          call A/14 R/0[%eax] R/1[%ebx]
          list/10 := spilled-list/18 (reload)
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          spilled-list/18 := list/10 (spill)
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
*** After live range splitting
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  spilled-list/18 := list/10 (spill)
  f/11 := f/8
  spilled-f/19 := f/11 (spill)
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          f/20 := spilled-f/19 (reload)
          A/14 := [f/20]
          R/0[%eax] := A/13
          R/1[%ebx] := f/20
          call A/14 R/0[%eax] R/1[%ebx]
          list/10 := spilled-list/18 (reload)
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          spilled-list/18 := list/10 (spill)
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
*** After instruction selection
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After spilling
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After live range splitting
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After instruction selection
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
*** After spilling
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
-dlambda
(seq
  (letrec
    (list_map/1030
       (function f/1031 list/1032
         (if list/1032
           (makeblock 0 (apply f/1031 (field 0 list/1032))
             (apply list_map/1030 f/1031 (field 1 list/1032)))
           0a)))
    (setfield_imm 0 (global Code!) list_map/1030))
  (letrec
    (list_iter/1035
       (function f/1036 list/1037
         (if list/1037
           (seq (apply f/1036 (field 0 list/1037))
             (apply list_iter/1035 f/1036 (field 1 list/1037)))
           0a)))
    (setfield_imm 1 (global Code!) list_iter/1035))
  (let
    (list1/1040 [0: [0: 1 2] [0: [0: 3 4] [0: [0: 5 6] [0: [0: 7 8] 0a]]]])
    (setfield_imm 2 (global Code!) list1/1040))
  (let
    (list2/1041
       (apply (field 0 (global Code!))
         (function (param/1052, param/1053) param/1052)
         (field 2 (global Code!))))
    (setfield_imm 3 (global Code!) list2/1041))
  (let
    (sum/1044
       (let (temp/1045 (makemutable 0 0))
         (apply (field 1 (global Code!))
           (function y/1046
             (setfield_imm 0 temp/1045 (+ (field 0 temp/1045) y/1046)))
           (field 3 (global Code!)))))
    (setfield_imm 4 (global Code!) sum/1044))
  0a)
checking tailcall on list_iter/1035
checking tailcall on list_map/1030
stats_rec_removed : 1
(list_iter_1035) 
stats_tailcall_removed : 1
(list_iter_1035) 
*** After TonLambda.optimize:
(seq
  (letrec
    (list_map/1030
       (function f/1031 list/1032
         (if list/1032
           (makeblock 0 (apply f/1031 (field 0 list/1032))
             (apply list_map/1030 f/1031 (field 1 list/1032)))
           0a)))
    (setfield_imm 0 (global Code!) list_map/1030))
  (let
    (list_iter/1035
       (function f/1056 list/1057
         (let (list/1037 list/1057 f/1036 f/1056)
           (catch
             (while 1a
               (catch
                 (exit 7
                   (if list/1037
                     (seq (apply f/1036 (field 0 list/1037))
                       (let (arg/1054 (field 1 list/1037))
                         (seq (assign list/1037 arg/1054) (exit 6))))
                     0a))
                with (6) 0a))
            with (7 res/1055) res/1055))))
    (setfield_imm 1 (global Code!) list_iter/1035))
  (let
    (list1/1040 [0: [0: 1 2] [0: [0: 3 4] [0: [0: 5 6] [0: [0: 7 8] 0a]]]])
    (setfield_imm 2 (global Code!) list1/1040))
  (let
    (list2/1041
       (apply (field 0 (global Code!))
         (function (param/1052, param/1053) param/1052)
         (field 2 (global Code!))))
    (setfield_imm 3 (global Code!) list2/1041))
  (let
    (sum/1044
       (let (temp/1045 (makemutable 0 0))
         (apply (field 1 (global Code!))
           (function y/1046
             (setfield_imm 0 temp/1045 (+ (field 0 temp/1045) y/1046)))
           (field 3 (global Code!)))))
    (setfield_imm 4 (global Code!) sum/1044))
  0a)
checking tailcall on list_map/1030
stats_rec_removed : 0

stats_tailcall_removed : 0

*** After instruction selection
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  f/11 := f/8
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          A/14 := [f/11]
          R/0[%eax] := A/13
          R/1[%ebx] := f/11
          call A/14 R/0[%eax] R/1[%ebx]
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
*** After spilling
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  spilled-list/18 := list/10 (spill)
  f/11 := f/8
  spilled-f/19 := f/11 (spill)
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          f/11 := spilled-f/19 (reload)
          A/14 := [f/11]
          R/0[%eax] := A/13
          R/1[%ebx] := f/11
          call A/14 R/0[%eax] R/1[%ebx]
          list/10 := spilled-list/18 (reload)
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          spilled-list/18 := list/10 (spill)
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
*** After live range splitting
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  spilled-list/18 := list/10 (spill)
  f/11 := f/8
  spilled-f/19 := f/11 (spill)
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          f/20 := spilled-f/19 (reload)
          A/14 := [f/20]
          R/0[%eax] := A/13
          R/1[%ebx] := f/20
          call A/14 R/0[%eax] R/1[%ebx]
          list/10 := spilled-list/18 (reload)
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          spilled-list/18 := list/10 (spill)
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
*** After instruction selection
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After spilling
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After live range splitting
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After instruction selection
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
*** After spilling
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
-dclosure
*** After Closure.intro:
(seq
  (let
    (clos/1060
       (closure (camlCode__list_map_1030(2)  f/1031 list/1032
                  (if list/1032
                    (makeblock 0 (apply f/1031 (field 0 list/1032))
                      (camlCode__list_map_1030  f/1031 (field 1 list/1032)))
                    0a)) {3} ))
    (setfield_imm 0 (global camlCode!) clos/1060))
  (let
    (list_iter/1035
       (closure (camlCode__list_iter_1035(2)  f/1056 list/1057
                  (let
                    (list/1037[Variable] list/1057 f/1036[Variable] f/1056)
                    (catch
                      (while 1a
                        (catch
                          (exit 7
                            (if list/1037
                              (seq (apply f/1036 (field 0 list/1037))
                                (let (arg/1054 (field 1 list/1037))
                                  (seq (assign list/1037 arg/1054) (exit 6))))
                              0a))
                         with (6) 0a))
                     with (7 res/1055) res/1055))) {3} ))
    (setfield_imm 1 (global camlCode!) list_iter/1035))
  (let
    (list1/1040 [0: [0: 1 2] [0: [0: 3 4] [0: [0: 5 6] [0: [0: 7 8] 0a]]]])
    (setfield_imm 2 (global camlCode!) list1/1040))
  (let
    (list2/1041
       (let
         (list/1064 (field 2 (global camlCode!))
          f/1065
            (closure (camlCode__fun_1062(-2)  param/1052 param/1053
                       param/1052) {3} )
          clos_env/1067
            (closure (camlCode__list_map_1066(2)  f/1031 list/1032
                       (if list/1032
                         (makeblock 0 (apply f/1031 (field 0 list/1032))
                           (camlCode__list_map_1066  f/1031
                             (field 1 list/1032)))
                         0a)) {0} ))
         (camlCode__list_map_1066  f/1065 list/1064)))
    (setfield_imm 3 (global camlCode!) list2/1041))
  (let
    (sum/1044
       (let
         (temp/1045 (makemutable 0 0)
          list/1071 (field 3 (global camlCode!))
          f/1072
            (closure (camlCode__fun_1068(1)  y/1046 env/1070
                       (setfield_imm 0 (field 2 env/1070)
                         (+ (field 0 (field 2 env/1070)) y/1046))) {2} 
                                                                   temp/1045)
          list/1073[Variable] list/1071
          f/1074[Variable] f/1072)
         (catch
           (while 1a
             (catch
               (exit 7
                 (if list/1073
                   (seq (apply f/1074 (field 0 list/1073))
                     (let (arg/1075 (field 1 list/1073))
                       (seq (assign list/1073 arg/1075) (exit 6))))
                   0a))
              with (6) 0a))
          with (7 res/1055) res/1055)))
    (setfield_imm 4 (global camlCode!) sum/1044))
  0a)
*** After TonClosure.optimize:
(let
  (clos/1060
     (closure (camlCode__list_map_1030(2)  f/1031 list/1032
                (if list/1032
                  (makeblock 0 (apply f/1031 (field 0 list/1032))
                    (camlCode__list_map_1030  f/1031 (field 1 list/1032)))
                  0a)) {3} ))
  (seq (setfield_imm 0 (global camlCode!) clos/1060)
    (let
      (list_iter/1035
         (closure (camlCode__list_iter_1035(2)  f/1056 list/1057
                    (let (list/1037[Variable] list/1057 f/1036 f/1056)
                      (catch
                        (while 1a
                          (catch
                            (exit 7
                              (if list/1037
                                (seq (apply f/1036 (field 0 list/1037))
                                  (let (arg/1054 (field 1 list/1037))
                                    (seq (assign list/1037 arg/1054)
                                      (exit 6))))
                                0a))
                           with (6) 0a))
                       with (7 res/1055) res/1055))) {3} ))
      (seq (setfield_imm 1 (global camlCode!) list_iter/1035)
        (let
          (list1/1040
             [0: [0: 1 2] [0: [0: 3 4] [0: [0: 5 6] [0: [0: 7 8] 0a]]]])
          (seq (setfield_imm 2 (global camlCode!) list1/1040)
            (let
              (list/1064 (field 2 (global camlCode!))
               f/1065
                 (closure (camlCode__fun_1062(-2)  param/1052 param/1053
                            param/1052) {3} ))
              (seq
                (closure (camlCode__list_map_1066(2)  f/1031 list/1032
                           (if list/1032
                             (makeblock 0 (apply f/1031 (field 0 list/1032))
                               (camlCode__list_map_1066  f/1031
                                 (field 1 list/1032)))
                             0a)) {0} )
                (let (list2/1041 (camlCode__list_map_1066  f/1065 list/1064))
                  (seq (setfield_imm 3 (global camlCode!) list2/1041)
                    (let
                      (temp/1045[Variable] 0
                       list/1071 (field 3 (global camlCode!))
                       sum/1044
                         (let (list/1073[Variable] list/1071)
                           (catch
                             (while 1a
                               (catch
                                 (exit 7
                                   (if list/1073
                                     (let (y/1076 (field 0 list/1073))
                                       (seq
                                         (assign temp/1045
                                           (+ temp/1045 y/1076))
                                         (let (arg/1075 (field 1 list/1073))
                                           (seq (assign list/1073 arg/1075)
                                             (exit 6)))))
                                     0a))
                                with (6) 0a))
                            with (7 res/1055) res/1055)))
                      (seq (setfield_imm 4 (global camlCode!) sum/1044) 0a))))))))))))
*** After instruction selection
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  f/11 := f/8
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          A/14 := [f/11]
          R/0[%eax] := A/13
          R/1[%ebx] := f/11
          call A/14 R/0[%eax] R/1[%ebx]
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
*** After spilling
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  spilled-list/18 := list/10 (spill)
  f/11 := f/8
  spilled-f/19 := f/11 (spill)
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          f/11 := spilled-f/19 (reload)
          A/14 := [f/11]
          R/0[%eax] := A/13
          R/1[%ebx] := f/11
          call A/14 R/0[%eax] R/1[%ebx]
          list/10 := spilled-list/18 (reload)
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          spilled-list/18 := list/10 (spill)
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
*** After live range splitting
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  spilled-list/18 := list/10 (spill)
  f/11 := f/8
  spilled-f/19 := f/11 (spill)
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          f/20 := spilled-f/19 (reload)
          A/14 := [f/20]
          R/0[%eax] := A/13
          R/1[%ebx] := f/20
          call A/14 R/0[%eax] R/1[%ebx]
          list/10 := spilled-list/18 (reload)
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          spilled-list/18 := list/10 (spill)
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
*** After instruction selection
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After spilling
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After live range splitting
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After instruction selection
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
*** After spilling
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]

-dcmm
(data int 5120 global "camlCode" "camlCode": skip 20)
(data
 int 3319
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__list_map_1066")
(data
 int 3319
 "camlCode__3":
 addr "caml_tuplify2"
 int -3
 addr "camlCode__fun_1062")
(data
 int 3319
 "camlCode__4":
 addr "caml_curry2"
 int 5
 addr "camlCode__list_iter_1035")
(data
 int 3319
 "camlCode__5":
 addr "caml_curry2"
 int 5
 addr "camlCode__list_map_1030")
(data
 global "camlCode__1"
 int 2048
 "camlCode__1":
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
 int 15
 int 17
 int 2048
 L10:
 int 11
 int 13
 int 2048
 L8:
 int 7
 int 9
 int 2048
 L6:
 int 3
 int 5)
(function camlCode__list_map_1030 (f/1031: addr list/1032: addr)
 (if (!= list/1032 1)
   (alloc 2048 (app (load f/1031) (load list/1032) f/1031 addr)
     (app "camlCode__list_map_1030" f/1031 (load (+a list/1032 4)) addr))
   1a))

*** After instruction selection
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
(function camlCode__list_iter_1035 (f/1056: addr list/1057: addr)
 (let (list/1037 list/1057 f/1036 f/1056)
   (catch
     (loop
       (catch
         (exit 7
           (if (!= list/1037 1)
             (seq (app (load f/1036) (load list/1037) f/1036 unit)
               (let arg/1054 (load (+a list/1037 4))
                 (assign list/1037 arg/1054) (exit 6)))
             1a))
       with(6) []))
     1a
   with(7 res/1055) res/1055)))

*** After instruction selection
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  f/11 := f/8
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          A/14 := [f/11]
          R/0[%eax] := A/13
          R/1[%ebx] := f/11
          call A/14 R/0[%eax] R/1[%ebx]
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
*** After spilling
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  spilled-list/18 := list/10 (spill)
  f/11 := f/8
  spilled-f/19 := f/11 (spill)
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          f/11 := spilled-f/19 (reload)
          A/14 := [f/11]
          R/0[%eax] := A/13
          R/1[%ebx] := f/11
          call A/14 R/0[%eax] R/1[%ebx]
          list/10 := spilled-list/18 (reload)
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          spilled-list/18 := list/10 (spill)
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
*** After live range splitting
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  spilled-list/18 := list/10 (spill)
  f/11 := f/8
  spilled-f/19 := f/11 (spill)
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          f/20 := spilled-f/19 (reload)
          A/14 := [f/20]
          R/0[%eax] := A/13
          R/1[%ebx] := f/20
          call A/14 R/0[%eax] R/1[%ebx]
          list/10 := spilled-list/18 (reload)
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          spilled-list/18 := list/10 (spill)
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
(function camlCode__fun_1062 (param/1052: addr param/1053: addr) param/1052)

*** After instruction selection
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After spilling
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After live range splitting
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
(function camlCode__list_map_1066 (f/1031: addr list/1032: addr)
 (if (!= list/1032 1)
   (alloc 2048 (app (load f/1031) (load list/1032) f/1031 addr)
     (app "camlCode__list_map_1066" f/1031 (load (+a list/1032 4)) addr))
   1a))

*** After instruction selection
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
(function camlCode__entry ()
 (let clos/1060 "camlCode__5" (store "camlCode" clos/1060)
   (let list_iter/1035 "camlCode__4" (store (+a "camlCode" 4) list_iter/1035)
     (let list1/1040 "camlCode__1" (store (+a "camlCode" 8) list1/1040)
       (let (list/1064 (load (+a "camlCode" 8)) f/1065 "camlCode__3")
         "camlCode__2" []
         (let
           list2/1041 (app "camlCode__list_map_1066" f/1065 list/1064 addr)
           (store (+a "camlCode" 12) list2/1041)
           (let
             (temp/1045 1 list/1071 (load (+a "camlCode" 12))
              sum/1044
                (let list/1073 list/1071
                  (catch
                    (loop
                      (catch
                        (exit 7
                          (if (!= list/1073 1)
                            (let y/1076 (load list/1073)
                              (assign temp/1045 (+ (+ temp/1045 y/1076) -1))
                              (let arg/1075 (load (+a list/1073 4))
                                (assign list/1073 arg/1075) (exit 6)))
                            1a))
                      with(6) []))
                    1a
                  with(7 res/1055) res/1055)))
             (store (+a "camlCode" 16) sum/1044) 1a)))))))

*** After instruction selection
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
*** After spilling
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
(data)
-dlinear
*** After instruction selection
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1030(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
Before simplify
camlCode__list_map_1030:
                  if list/9[%ebx] ==s 1 goto L100
                  spilled-list/19[s0] := list/9[%ebx] (spill)
                  spilled-f/18[s1] := f/8[%eax] (spill)
                  A/11[%ebx] := [list/9[%ebx] + 4]
                  {spilled-f/18[s1]* spilled-list/19[s0]*}
                  R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
                  L100 [0]:
                  A/10[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__list_map_1030:
  if list/9[%ebx] ==s 1 goto L100
  spilled-list/19[s0] := list/9[%ebx] (spill)
  spilled-f/18[s1] := f/8[%eax] (spill)
  A/11[%ebx] := [list/9[%ebx] + 4]
  {spilled-f/18[s1]* spilled-list/19[s0]*}
  R/0[%eax] := call "camlCode__list_map_1030" R/0[%eax] R/1[%ebx]
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
  L100 [2]:
  A/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
*** After instruction selection
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  f/11 := f/8
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          A/14 := [f/11]
          R/0[%eax] := A/13
          R/1[%ebx] := f/11
          call A/14 R/0[%eax] R/1[%ebx]
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
*** After spilling
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  spilled-list/18 := list/10 (spill)
  f/11 := f/8
  spilled-f/19 := f/11 (spill)
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          f/11 := spilled-f/19 (reload)
          A/14 := [f/11]
          R/0[%eax] := A/13
          R/1[%ebx] := f/11
          call A/14 R/0[%eax] R/1[%ebx]
          list/10 := spilled-list/18 (reload)
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          spilled-list/18 := list/10 (spill)
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
*** After live range splitting
camlCode__list_iter_1035(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  list/10 := list/9
  spilled-list/18 := list/10 (spill)
  f/11 := f/8
  spilled-f/19 := f/11 (spill)
  catch
    loop
      catch
        if list/10 !=s 1 then
          A/13 := [list/10]
          f/20 := spilled-f/19 (reload)
          A/14 := [f/20]
          R/0[%eax] := A/13
          R/1[%ebx] := f/20
          call A/14 R/0[%eax] R/1[%ebx]
          list/10 := spilled-list/18 (reload)
          arg/15 := [list/10 + 4]
          list/10 := arg/15
          spilled-list/18 := list/10 (spill)
          exit(6)
        else
          A/16 := 1
        endif
        res/12 := A/16
        exit(7)
      with(6)
        
      endcatch
    endloop
    A/17 := 1
    R/0[%eax] := A/17
    return R/0[%eax]
  with(7)
    R/0[%eax] := res/12
    return R/0[%eax]
  endcatch
Before simplify
camlCode__list_iter_1035:
                  spilled-list/18[s1] := list/10[%ebx] (spill)
                  spilled-f/19[s0] := f/11[%eax] (spill)
                  L108 [0]:
                  if list/10[%ebx] ==s 1 goto L109
                  A/13[%eax] := [list/10[%ebx]]
                  f/20[%ebx] := spilled-f/19[s0] (reload)
                  A/14[%ecx] := [f/20[%ebx]]
                  {spilled-list/18[s1]* spilled-f/19[s0]*}
                  call A/14[%ecx] R/0[%eax] R/1[%ebx]
                  list/10[%ebx] := spilled-list/18[s1] (reload)
                  arg/15[%ebx] := [list/10[%ebx] + 4]
                  spilled-list/18[s1] := list/10[%ebx] (spill)
                  goto L108
                  L109 [0]:
                  A/16[%eax] := 1
                  L107 [0]:
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__list_iter_1035:
  spilled-list/18[s1] := list/10[%ebx] (spill)
  spilled-f/19[s0] := f/11[%eax] (spill)
  L108 [3]:
  if list/10[%ebx] ==s 1 goto L109
  A/13[%eax] := [list/10[%ebx]]
  f/20[%ebx] := spilled-f/19[s0] (reload)
  A/14[%ecx] := [f/20[%ebx]]
  {spilled-list/18[s1]* spilled-f/19[s0]*}
  call A/14[%ecx] R/0[%eax] R/1[%ebx]
  list/10[%ebx] := spilled-list/18[s1] (reload)
  arg/15[%ebx] := [list/10[%ebx] + 4]
  spilled-list/18[s1] := list/10[%ebx] (spill)
  goto L108
  L109 [2]:
  A/16[%eax] := 1
  L107 [2]:
  reload retaddr
  return R/0[%eax]
  
*** After instruction selection
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After spilling
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
*** After live range splitting
camlCode__fun_1062(R/0[%eax] R/1[%ebx])
  param/8 := R/0[%eax]
  param/9 := R/1[%ebx]
  R/0[%eax] := param/8
  return R/0[%eax]
Before simplify
camlCode__fun_1062:
                  return R/0[%eax]
                  *** Linearized code
camlCode__fun_1062:
  return R/0[%eax]
  
*** After instruction selection
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
camlCode__list_map_1066(R/0[%eax] R/1[%ebx])
  f/8 := R/0[%eax]
  list/9 := R/1[%ebx]
  if list/9 !=s 1 then
    spilled-list/19 := list/9 (spill)
    spilled-f/18 := f/8 (spill)
    A/11 := [list/9 + 4]
    R/0[%eax] := f/8
    R/1[%ebx] := A/11
    R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
Before simplify
camlCode__list_map_1066:
                  if list/9[%ebx] ==s 1 goto L113
                  spilled-list/19[s0] := list/9[%ebx] (spill)
                  spilled-f/18[s1] := f/8[%eax] (spill)
                  A/11[%ebx] := [list/9[%ebx] + 4]
                  {spilled-f/18[s1]* spilled-list/19[s0]*}
                  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
                  L113 [0]:
                  A/10[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__list_map_1066:
  if list/9[%ebx] ==s 1 goto L113
  spilled-list/19[s0] := list/9[%ebx] (spill)
  spilled-f/18[s1] := f/8[%eax] (spill)
  A/11[%ebx] := [list/9[%ebx] + 4]
  {spilled-f/18[s1]* spilled-list/19[s0]*}
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
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
  L113 [2]:
  A/10[%eax] := 1
  reload retaddr
  return R/0[%eax]
  
*** After instruction selection
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
*** After spilling
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
*** After live range splitting
camlCode__entry()
  clos/8 := "camlCode__5"
  ["camlCode"] := clos/8
  list_iter/9 := "camlCode__4"
  ["camlCode" + 4] := list_iter/9
  list1/10 := "camlCode__1"
  ["camlCode" + 8] := list1/10
  list/11 := ["camlCode" + 8]
  f/12 := "camlCode__3"
  A/13 := "camlCode__2"
  R/0[%eax] := f/12
  R/1[%ebx] := list/11
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  list2/14 := R/0[%eax]
  ["camlCode" + 12] := list2/14
  temp/15 := 1
  list/16 := ["camlCode" + 12]
  list/17 := list/16
  catch
    loop
      catch
        if list/17 !=s 1 then
          y/19 := [list/17]
          I/20 := temp/15 + y/19 + -1
          temp/15 := I/20
          arg/21 := [list/17 + 4]
          list/17 := arg/21
          exit(6)
        else
          A/22 := 1
        endif
        res/18 := A/22
        exit(7)
      with(6)
        
      endcatch
    endloop
    sum/23 := 1
  with(7)
    sum/23 := res/18
  endcatch
  ["camlCode" + 16] := sum/23
  A/24 := 1
  R/0[%eax] := A/24
  return R/0[%eax]
Before simplify
camlCode__entry:
                  clos/8[%eax] := "camlCode__5"
                  ["camlCode"] := clos/8[%eax]
                  list_iter/9[%eax] := "camlCode__4"
                  ["camlCode" + 4] := list_iter/9[%eax]
                  list1/10[%eax] := "camlCode__1"
                  ["camlCode" + 8] := list1/10[%eax]
                  list/11[%ebx] := ["camlCode" + 8]
                  f/12[%eax] := "camlCode__3"
                  A/13[%ecx] := "camlCode__2"
                  {}
                  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
                  ["camlCode" + 12] := list2/14[%eax]
                  temp/15[%ebx] := 1
                  list/16[%eax] := ["camlCode" + 12]
                  L121 [0]:
                  if list/17[%eax] ==s 1 goto L122
                  y/19[%ecx] := [list/17[%eax]]
                  I/20[%ebx] := temp/15[%ebx] + y/19[%ecx] + -1
                  arg/21[%eax] := [list/17[%eax] + 4]
                  goto L121
                  L122 [0]:
                  A/22[%eax] := 1
                  L120 [0]:
                  ["camlCode" + 16] := sum/23[%eax]
                  A/24[%eax] := 1
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  clos/8[%eax] := "camlCode__5"
  ["camlCode"] := clos/8[%eax]
  list_iter/9[%eax] := "camlCode__4"
  ["camlCode" + 4] := list_iter/9[%eax]
  list1/10[%eax] := "camlCode__1"
  ["camlCode" + 8] := list1/10[%eax]
  list/11[%ebx] := ["camlCode" + 8]
  f/12[%eax] := "camlCode__3"
  A/13[%ecx] := "camlCode__2"
  {}
  R/0[%eax] := call "camlCode__list_map_1066" R/0[%eax] R/1[%ebx]
  ["camlCode" + 12] := list2/14[%eax]
  temp/15[%ebx] := 1
  list/16[%eax] := ["camlCode" + 12]
  L121 [3]:
  if list/17[%eax] ==s 1 goto L122
  y/19[%ecx] := [list/17[%eax]]
  I/20[%ebx] := temp/15[%ebx] + y/19[%ecx] + -1
  arg/21[%eax] := [list/17[%eax] + 4]
  goto L121
  L122 [2]:
  A/22[%eax] := 1
  L120 [2]:
  ["camlCode" + 16] := sum/23[%eax]
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
	.long	5120
	.globl	camlCode
camlCode:
	.space	20
	.data
	.long	3319
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__list_map_1066
	.data
	.long	3319
camlCode__3:
	.long	caml_tuplify2
	.long	-3
	.long	camlCode__fun_1062
	.data
	.long	3319
camlCode__4:
	.long	caml_curry2
	.long	5
	.long	camlCode__list_iter_1035
	.data
	.long	3319
camlCode__5:
	.long	caml_curry2
	.long	5
	.long	camlCode__list_map_1030
	.data
	.globl	camlCode__1
	.long	2048
camlCode__1:
	.long	.L100006
	.long	.L100007
	.long	2048
.L100007:
	.long	.L100008
	.long	.L100009
	.long	2048
.L100009:
	.long	.L100010
	.long	.L100011
	.long	2048
.L100011:
	.long	.L100012
	.long	1
	.long	2048
.L100012:
	.long	15
	.long	17
	.long	2048
.L100010:
	.long	11
	.long	13
	.long	2048
.L100008:
	.long	7
	.long	9
	.long	2048
.L100006:
	.long	3
	.long	5
	.text
	.align	16
	.globl	camlCode__list_map_1030
camlCode__list_map_1030:
	subl	$12, %esp
.L101:
	cmpl	$1, %ebx
	je	.L100
	movl	%ebx, 0(%esp)
	movl	%eax, 4(%esp)
	movl	4(%ebx), %ebx
	call	camlCode__list_map_1030
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
	.type	camlCode__list_map_1030,@function
	.size	camlCode__list_map_1030,.-camlCode__list_map_1030
	.text
	.align	16
	.globl	camlCode__list_iter_1035
camlCode__list_iter_1035:
	subl	$8, %esp
.L110:
	movl	%ebx, 4(%esp)
	movl	%eax, 0(%esp)
.L108:
	cmpl	$1, %ebx
	je	.L109
	movl	(%ebx), %eax
	movl	0(%esp), %ebx
	movl	(%ebx), %ecx
	call	*%ecx
.L111:
	movl	4(%esp), %ebx
	movl	4(%ebx), %ebx
	movl	%ebx, 4(%esp)
	jmp	.L108
	.align	16
.L109:
	movl	$1, %eax
.L107:
	addl	$8, %esp
	ret
	.type	camlCode__list_iter_1035,@function
	.size	camlCode__list_iter_1035,.-camlCode__list_iter_1035
	.text
	.align	16
	.globl	camlCode__fun_1062
camlCode__fun_1062:
.L112:
	ret
	.type	camlCode__fun_1062,@function
	.size	camlCode__fun_1062,.-camlCode__fun_1062
	.text
	.align	16
	.globl	camlCode__list_map_1066
camlCode__list_map_1066:
	subl	$12, %esp
.L114:
	cmpl	$1, %ebx
	je	.L113
	movl	%ebx, 0(%esp)
	movl	%eax, 4(%esp)
	movl	4(%ebx), %ebx
	call	camlCode__list_map_1066
.L115:
	movl	%eax, 8(%esp)
	movl	0(%esp), %eax
	movl	(%eax), %eax
	movl	4(%esp), %ebx
	movl	(%ebx), %ecx
	call	*%ecx
.L116:
	movl	%eax, %ebx
.L117:	movl	caml_young_ptr, %eax
	subl	$12, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L118
	leal	4(%eax), %eax
	movl	$2048, -4(%eax)
	movl	%ebx, (%eax)
	movl	8(%esp), %ebx
	movl	%ebx, 4(%eax)
	addl	$12, %esp
	ret
	.align	16
.L113:
	movl	$1, %eax
	addl	$12, %esp
	ret
.L118:	call	caml_call_gc
.L119:	jmp	.L117
	.type	camlCode__list_map_1066,@function
	.size	camlCode__list_map_1066,.-camlCode__list_map_1066
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L123:
	movl	$camlCode__5, %eax
	movl	%eax, camlCode
	movl	$camlCode__4, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__1, %eax
	movl	%eax, camlCode + 8
	movl	camlCode + 8, %ebx
	movl	$camlCode__3, %eax
	movl	$camlCode__2, %ecx
	call	camlCode__list_map_1066
.L124:
	movl	%eax, camlCode + 12
	movl	$1, %ebx
	movl	camlCode + 12, %eax
.L121:
	cmpl	$1, %eax
	je	.L122
	movl	(%eax), %ecx
	lea	-1(%ebx, %ecx), %ebx
	movl	4(%eax), %eax
	jmp	.L121
.L122:
	movl	$1, %eax
.L120:
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
	.long	8
	.long	.L124
	.word	4
	.word	0
	.align	4
	.long	.L119
	.word	16
	.word	2
	.word	8
	.word	3
	.align	4
	.long	.L116
	.word	16
	.word	1
	.word	8
	.align	4
	.long	.L115
	.word	16
	.word	2
	.word	0
	.word	4
	.align	4
	.long	.L111
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

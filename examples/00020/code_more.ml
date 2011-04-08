
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
close_rec_functions
Recursive function list_map could be inlined
*** After instruction selection
camlCode__list_map_1030(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1030" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/34 := [list/30]
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After spilling
camlCode__list_map_1030(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1030" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/30 := spilled-list/40 (reload)
    A/34 := [list/30]
    f/29 := spilled-f/39 (reload)
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/33 := A/38 (reload)
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After live range splitting
camlCode__list_map_1030(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1030" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/41 := spilled-list/40 (reload)
    A/34 := [list/41]
    f/42 := spilled-f/39 (reload)
    A/35 := [f/42]
    R/0[%rax] := A/34
    R/1[%rbx] := f/42
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/43 := A/38 (reload)
    [A/37 + 8] := A/43
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After instruction selection
camlCode__list_iter_1035(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  list/31 := list/30
  f/32 := f/29
  catch
    catch
      loop
        catch
          if list/31 !=s 1 then
            A/34 := [list/31]
            A/35 := [f/32]
            R/0[%rax] := A/34
            R/1[%rbx] := f/32
            call A/35 R/0[%rax] R/1[%rbx]
            arg/36 := [list/31 + 8]
            list/31 := arg/36
            exit(6)
          else
            A/37 := 1
          endif
          res/33 := A/37
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(9)
      
    endcatch
    A/38 := 1
    R/0[%rax] := A/38
    return R/0[%rax]
  with(7)
    R/0[%rax] := res/33
    return R/0[%rax]
  endcatch
*** After spilling
camlCode__list_iter_1035(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  list/31 := list/30
  spilled-list/39 := list/31 (spill)
  f/32 := f/29
  spilled-f/40 := f/32 (spill)
  catch
    catch
      loop
        catch
          if list/31 !=s 1 then
            A/34 := [list/31]
            f/32 := spilled-f/40 (reload)
            A/35 := [f/32]
            R/0[%rax] := A/34
            R/1[%rbx] := f/32
            call A/35 R/0[%rax] R/1[%rbx]
            list/31 := spilled-list/39 (reload)
            arg/36 := [list/31 + 8]
            list/31 := arg/36
            spilled-list/39 := list/31 (spill)
            exit(6)
          else
            A/37 := 1
          endif
          res/33 := A/37
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(9)
      
    endcatch
    A/38 := 1
    R/0[%rax] := A/38
    return R/0[%rax]
  with(7)
    R/0[%rax] := res/33
    return R/0[%rax]
  endcatch
*** After live range splitting
camlCode__list_iter_1035(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  list/31 := list/30
  spilled-list/39 := list/31 (spill)
  f/32 := f/29
  spilled-f/40 := f/32 (spill)
  catch
    catch
      loop
        catch
          if list/31 !=s 1 then
            A/34 := [list/31]
            f/41 := spilled-f/40 (reload)
            A/35 := [f/41]
            R/0[%rax] := A/34
            R/1[%rbx] := f/41
            call A/35 R/0[%rax] R/1[%rbx]
            list/31 := spilled-list/39 (reload)
            arg/36 := [list/31 + 8]
            list/31 := arg/36
            spilled-list/39 := list/31 (spill)
            exit(6)
          else
            A/37 := 1
          endif
          res/33 := A/37
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(9)
      
    endcatch
    A/38 := 1
    R/0[%rax] := A/38
    return R/0[%rax]
  with(7)
    R/0[%rax] := res/33
    return R/0[%rax]
  endcatch
*** After instruction selection
camlCode__fun_1062(R/0[%rax] R/1[%rbx])
  param/29 := R/0[%rax]
  param/30 := R/1[%rbx]
  R/0[%rax] := param/29
  return R/0[%rax]
*** After spilling
camlCode__fun_1062(R/0[%rax] R/1[%rbx])
  param/29 := R/0[%rax]
  param/30 := R/1[%rbx]
  R/0[%rax] := param/29
  return R/0[%rax]
*** After live range splitting
camlCode__fun_1062(R/0[%rax] R/1[%rbx])
  param/29 := R/0[%rax]
  param/30 := R/1[%rbx]
  R/0[%rax] := param/29
  return R/0[%rax]
*** After instruction selection
camlCode__list_map_1066(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/34 := [list/30]
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After spilling
camlCode__list_map_1066(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/30 := spilled-list/40 (reload)
    A/34 := [list/30]
    f/29 := spilled-f/39 (reload)
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/33 := A/38 (reload)
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After live range splitting
camlCode__list_map_1066(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/41 := spilled-list/40 (reload)
    A/34 := [list/41]
    f/42 := spilled-f/39 (reload)
    A/35 := [f/42]
    R/0[%rax] := A/34
    R/1[%rbx] := f/42
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/43 := A/38 (reload)
    [A/37 + 8] := A/43
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After instruction selection
camlCode__fun_1068(R/0[%rax] R/1[%rbx])
  y/29 := R/0[%rax]
  env/30 := R/1[%rbx]
  A/31 := [env/30 + 16]
  A/32 := [env/30 + 16]
  A/33 := [A/32]
  I/34 := A/33 + y/29 + -1
  [A/31] := I/34
  A/35 := 1
  R/0[%rax] := A/35
  return R/0[%rax]
*** After spilling
camlCode__fun_1068(R/0[%rax] R/1[%rbx])
  y/29 := R/0[%rax]
  env/30 := R/1[%rbx]
  A/31 := [env/30 + 16]
  A/32 := [env/30 + 16]
  A/33 := [A/32]
  I/34 := A/33 + y/29 + -1
  [A/31] := I/34
  A/35 := 1
  R/0[%rax] := A/35
  return R/0[%rax]
*** After live range splitting
camlCode__fun_1068(R/0[%rax] R/1[%rbx])
  y/29 := R/0[%rax]
  env/30 := R/1[%rbx]
  A/31 := [env/30 + 16]
  A/32 := [env/30 + 16]
  A/33 := [A/32]
  I/34 := A/33 + y/29 + -1
  [A/31] := I/34
  A/35 := 1
  R/0[%rax] := A/35
  return R/0[%rax]
*** After instruction selection
camlCode__entry()
  clos/29 := "camlCode__5"
  A/30 := "camlCode"
  [A/30] := clos/29
  list_iter/31 := "camlCode__4"
  A/32 := "camlCode"
  [A/32 + 8] := list_iter/31
  list1/33 := "camlCode__1"
  A/34 := "camlCode"
  [A/34 + 16] := list1/33
  A/35 := "camlCode"
  list/36 := [A/35 + 16]
  f/37 := "camlCode__3"
  clos_env/38 := "camlCode__2"
  R/0[%rax] := f/37
  R/1[%rbx] := list/36
  R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
  list2/39 := R/0[%rax]
  A/40 := "camlCode"
  [A/40 + 24] := list2/39
  temp/41 := alloc 16
  [temp/41 + -8] := 1024
  [temp/41] := 1
  A/42 := "camlCode"
  list/43 := [A/42 + 24]
  f/44 := alloc 32
  [f/44 + -8] := 3319
  A/45 := "camlCode__fun_1068"
  [f/44] := A/45
  [f/44 + 8] := 3
  [f/44 + 16] := temp/41
  list/46 := list/43
  f/47 := f/44
  catch
    catch
      loop
        catch
          if list/46 !=s 1 then
            A/49 := [list/46]
            A/50 := [f/47]
            R/0[%rax] := A/49
            R/1[%rbx] := f/47
            call A/50 R/0[%rax] R/1[%rbx]
            arg/51 := [list/46 + 8]
            list/46 := arg/51
            exit(6)
          else
            A/52 := 1
          endif
          res/48 := A/52
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(8)
      
    endcatch
    sum/53 := 1
  with(7)
    sum/53 := res/48
  endcatch
  A/54 := "camlCode"
  [A/54 + 32] := sum/53
  A/55 := 1
  R/0[%rax] := A/55
  return R/0[%rax]
*** After spilling
camlCode__entry()
  clos/29 := "camlCode__5"
  A/30 := "camlCode"
  [A/30] := clos/29
  list_iter/31 := "camlCode__4"
  A/32 := "camlCode"
  [A/32 + 8] := list_iter/31
  list1/33 := "camlCode__1"
  A/34 := "camlCode"
  [A/34 + 16] := list1/33
  A/35 := "camlCode"
  list/36 := [A/35 + 16]
  f/37 := "camlCode__3"
  clos_env/38 := "camlCode__2"
  R/0[%rax] := f/37
  R/1[%rbx] := list/36
  R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
  list2/39 := R/0[%rax]
  A/40 := "camlCode"
  [A/40 + 24] := list2/39
  temp/41 := alloc 48
  [temp/41 + -8] := 1024
  [temp/41] := 1
  A/42 := "camlCode"
  list/43 := [A/42 + 24]
  f/44 := temp/41 + 16
  [f/44 + -8] := 3319
  A/45 := "camlCode__fun_1068"
  [f/44] := A/45
  [f/44 + 8] := 3
  [f/44 + 16] := temp/41
  list/46 := list/43
  spilled-list/56 := list/46 (spill)
  f/47 := f/44
  spilled-f/57 := f/47 (spill)
  catch
    catch
      loop
        catch
          if list/46 !=s 1 then
            A/49 := [list/46]
            f/47 := spilled-f/57 (reload)
            A/50 := [f/47]
            R/0[%rax] := A/49
            R/1[%rbx] := f/47
            call A/50 R/0[%rax] R/1[%rbx]
            list/46 := spilled-list/56 (reload)
            arg/51 := [list/46 + 8]
            list/46 := arg/51
            spilled-list/56 := list/46 (spill)
            exit(6)
          else
            A/52 := 1
          endif
          res/48 := A/52
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(8)
      
    endcatch
    sum/53 := 1
  with(7)
    sum/53 := res/48
  endcatch
  A/54 := "camlCode"
  [A/54 + 32] := sum/53
  A/55 := 1
  R/0[%rax] := A/55
  return R/0[%rax]
*** After live range splitting
camlCode__entry()
  clos/29 := "camlCode__5"
  A/30 := "camlCode"
  [A/30] := clos/29
  list_iter/31 := "camlCode__4"
  A/32 := "camlCode"
  [A/32 + 8] := list_iter/31
  list1/33 := "camlCode__1"
  A/34 := "camlCode"
  [A/34 + 16] := list1/33
  A/35 := "camlCode"
  list/36 := [A/35 + 16]
  f/37 := "camlCode__3"
  clos_env/38 := "camlCode__2"
  R/0[%rax] := f/37
  R/1[%rbx] := list/36
  R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
  list2/39 := R/0[%rax]
  A/40 := "camlCode"
  [A/40 + 24] := list2/39
  temp/41 := alloc 48
  [temp/41 + -8] := 1024
  [temp/41] := 1
  A/42 := "camlCode"
  list/43 := [A/42 + 24]
  f/44 := temp/41 + 16
  [f/44 + -8] := 3319
  A/45 := "camlCode__fun_1068"
  [f/44] := A/45
  [f/44 + 8] := 3
  [f/44 + 16] := temp/41
  list/46 := list/43
  spilled-list/56 := list/46 (spill)
  f/47 := f/44
  spilled-f/57 := f/47 (spill)
  catch
    catch
      loop
        catch
          if list/46 !=s 1 then
            A/49 := [list/46]
            f/58 := spilled-f/57 (reload)
            A/50 := [f/58]
            R/0[%rax] := A/49
            R/1[%rbx] := f/58
            call A/50 R/0[%rax] R/1[%rbx]
            list/46 := spilled-list/56 (reload)
            arg/51 := [list/46 + 8]
            list/46 := arg/51
            spilled-list/56 := list/46 (spill)
            exit(6)
          else
            A/52 := 1
          endif
          res/48 := A/52
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(8)
      
    endcatch
    sum/53 := 1
  with(7)
    sum/53 := res/48
  endcatch
  A/54 := "camlCode"
  [A/54 + 32] := sum/53
  A/55 := 1
  R/0[%rax] := A/55
  return R/0[%rax]
lambda saved
typedtree saved
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
found tailcall on list_iter/1035
checking tailcall on list_map/1030
 After TonLambda.optimize (1 eliminations): 
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
close_rec_functions
Recursive function list_map could be inlined
*** After instruction selection
camlCode__list_map_1030(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1030" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/34 := [list/30]
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After spilling
camlCode__list_map_1030(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1030" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/30 := spilled-list/40 (reload)
    A/34 := [list/30]
    f/29 := spilled-f/39 (reload)
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/33 := A/38 (reload)
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After live range splitting
camlCode__list_map_1030(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1030" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/41 := spilled-list/40 (reload)
    A/34 := [list/41]
    f/42 := spilled-f/39 (reload)
    A/35 := [f/42]
    R/0[%rax] := A/34
    R/1[%rbx] := f/42
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/43 := A/38 (reload)
    [A/37 + 8] := A/43
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After instruction selection
camlCode__list_iter_1035(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  list/31 := list/30
  f/32 := f/29
  catch
    catch
      loop
        catch
          if list/31 !=s 1 then
            A/34 := [list/31]
            A/35 := [f/32]
            R/0[%rax] := A/34
            R/1[%rbx] := f/32
            call A/35 R/0[%rax] R/1[%rbx]
            arg/36 := [list/31 + 8]
            list/31 := arg/36
            exit(6)
          else
            A/37 := 1
          endif
          res/33 := A/37
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(9)
      
    endcatch
    A/38 := 1
    R/0[%rax] := A/38
    return R/0[%rax]
  with(7)
    R/0[%rax] := res/33
    return R/0[%rax]
  endcatch
*** After spilling
camlCode__list_iter_1035(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  list/31 := list/30
  spilled-list/39 := list/31 (spill)
  f/32 := f/29
  spilled-f/40 := f/32 (spill)
  catch
    catch
      loop
        catch
          if list/31 !=s 1 then
            A/34 := [list/31]
            f/32 := spilled-f/40 (reload)
            A/35 := [f/32]
            R/0[%rax] := A/34
            R/1[%rbx] := f/32
            call A/35 R/0[%rax] R/1[%rbx]
            list/31 := spilled-list/39 (reload)
            arg/36 := [list/31 + 8]
            list/31 := arg/36
            spilled-list/39 := list/31 (spill)
            exit(6)
          else
            A/37 := 1
          endif
          res/33 := A/37
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(9)
      
    endcatch
    A/38 := 1
    R/0[%rax] := A/38
    return R/0[%rax]
  with(7)
    R/0[%rax] := res/33
    return R/0[%rax]
  endcatch
*** After live range splitting
camlCode__list_iter_1035(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  list/31 := list/30
  spilled-list/39 := list/31 (spill)
  f/32 := f/29
  spilled-f/40 := f/32 (spill)
  catch
    catch
      loop
        catch
          if list/31 !=s 1 then
            A/34 := [list/31]
            f/41 := spilled-f/40 (reload)
            A/35 := [f/41]
            R/0[%rax] := A/34
            R/1[%rbx] := f/41
            call A/35 R/0[%rax] R/1[%rbx]
            list/31 := spilled-list/39 (reload)
            arg/36 := [list/31 + 8]
            list/31 := arg/36
            spilled-list/39 := list/31 (spill)
            exit(6)
          else
            A/37 := 1
          endif
          res/33 := A/37
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(9)
      
    endcatch
    A/38 := 1
    R/0[%rax] := A/38
    return R/0[%rax]
  with(7)
    R/0[%rax] := res/33
    return R/0[%rax]
  endcatch
*** After instruction selection
camlCode__fun_1062(R/0[%rax] R/1[%rbx])
  param/29 := R/0[%rax]
  param/30 := R/1[%rbx]
  R/0[%rax] := param/29
  return R/0[%rax]
*** After spilling
camlCode__fun_1062(R/0[%rax] R/1[%rbx])
  param/29 := R/0[%rax]
  param/30 := R/1[%rbx]
  R/0[%rax] := param/29
  return R/0[%rax]
*** After live range splitting
camlCode__fun_1062(R/0[%rax] R/1[%rbx])
  param/29 := R/0[%rax]
  param/30 := R/1[%rbx]
  R/0[%rax] := param/29
  return R/0[%rax]
*** After instruction selection
camlCode__list_map_1066(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/34 := [list/30]
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After spilling
camlCode__list_map_1066(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/30 := spilled-list/40 (reload)
    A/34 := [list/30]
    f/29 := spilled-f/39 (reload)
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/33 := A/38 (reload)
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After live range splitting
camlCode__list_map_1066(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/41 := spilled-list/40 (reload)
    A/34 := [list/41]
    f/42 := spilled-f/39 (reload)
    A/35 := [f/42]
    R/0[%rax] := A/34
    R/1[%rbx] := f/42
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/43 := A/38 (reload)
    [A/37 + 8] := A/43
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After instruction selection
camlCode__fun_1068(R/0[%rax] R/1[%rbx])
  y/29 := R/0[%rax]
  env/30 := R/1[%rbx]
  A/31 := [env/30 + 16]
  A/32 := [env/30 + 16]
  A/33 := [A/32]
  I/34 := A/33 + y/29 + -1
  [A/31] := I/34
  A/35 := 1
  R/0[%rax] := A/35
  return R/0[%rax]
*** After spilling
camlCode__fun_1068(R/0[%rax] R/1[%rbx])
  y/29 := R/0[%rax]
  env/30 := R/1[%rbx]
  A/31 := [env/30 + 16]
  A/32 := [env/30 + 16]
  A/33 := [A/32]
  I/34 := A/33 + y/29 + -1
  [A/31] := I/34
  A/35 := 1
  R/0[%rax] := A/35
  return R/0[%rax]
*** After live range splitting
camlCode__fun_1068(R/0[%rax] R/1[%rbx])
  y/29 := R/0[%rax]
  env/30 := R/1[%rbx]
  A/31 := [env/30 + 16]
  A/32 := [env/30 + 16]
  A/33 := [A/32]
  I/34 := A/33 + y/29 + -1
  [A/31] := I/34
  A/35 := 1
  R/0[%rax] := A/35
  return R/0[%rax]
*** After instruction selection
camlCode__entry()
  clos/29 := "camlCode__5"
  A/30 := "camlCode"
  [A/30] := clos/29
  list_iter/31 := "camlCode__4"
  A/32 := "camlCode"
  [A/32 + 8] := list_iter/31
  list1/33 := "camlCode__1"
  A/34 := "camlCode"
  [A/34 + 16] := list1/33
  A/35 := "camlCode"
  list/36 := [A/35 + 16]
  f/37 := "camlCode__3"
  clos_env/38 := "camlCode__2"
  R/0[%rax] := f/37
  R/1[%rbx] := list/36
  R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
  list2/39 := R/0[%rax]
  A/40 := "camlCode"
  [A/40 + 24] := list2/39
  temp/41 := alloc 16
  [temp/41 + -8] := 1024
  [temp/41] := 1
  A/42 := "camlCode"
  list/43 := [A/42 + 24]
  f/44 := alloc 32
  [f/44 + -8] := 3319
  A/45 := "camlCode__fun_1068"
  [f/44] := A/45
  [f/44 + 8] := 3
  [f/44 + 16] := temp/41
  list/46 := list/43
  f/47 := f/44
  catch
    catch
      loop
        catch
          if list/46 !=s 1 then
            A/49 := [list/46]
            A/50 := [f/47]
            R/0[%rax] := A/49
            R/1[%rbx] := f/47
            call A/50 R/0[%rax] R/1[%rbx]
            arg/51 := [list/46 + 8]
            list/46 := arg/51
            exit(6)
          else
            A/52 := 1
          endif
          res/48 := A/52
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(8)
      
    endcatch
    sum/53 := 1
  with(7)
    sum/53 := res/48
  endcatch
  A/54 := "camlCode"
  [A/54 + 32] := sum/53
  A/55 := 1
  R/0[%rax] := A/55
  return R/0[%rax]
*** After spilling
camlCode__entry()
  clos/29 := "camlCode__5"
  A/30 := "camlCode"
  [A/30] := clos/29
  list_iter/31 := "camlCode__4"
  A/32 := "camlCode"
  [A/32 + 8] := list_iter/31
  list1/33 := "camlCode__1"
  A/34 := "camlCode"
  [A/34 + 16] := list1/33
  A/35 := "camlCode"
  list/36 := [A/35 + 16]
  f/37 := "camlCode__3"
  clos_env/38 := "camlCode__2"
  R/0[%rax] := f/37
  R/1[%rbx] := list/36
  R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
  list2/39 := R/0[%rax]
  A/40 := "camlCode"
  [A/40 + 24] := list2/39
  temp/41 := alloc 48
  [temp/41 + -8] := 1024
  [temp/41] := 1
  A/42 := "camlCode"
  list/43 := [A/42 + 24]
  f/44 := temp/41 + 16
  [f/44 + -8] := 3319
  A/45 := "camlCode__fun_1068"
  [f/44] := A/45
  [f/44 + 8] := 3
  [f/44 + 16] := temp/41
  list/46 := list/43
  spilled-list/56 := list/46 (spill)
  f/47 := f/44
  spilled-f/57 := f/47 (spill)
  catch
    catch
      loop
        catch
          if list/46 !=s 1 then
            A/49 := [list/46]
            f/47 := spilled-f/57 (reload)
            A/50 := [f/47]
            R/0[%rax] := A/49
            R/1[%rbx] := f/47
            call A/50 R/0[%rax] R/1[%rbx]
            list/46 := spilled-list/56 (reload)
            arg/51 := [list/46 + 8]
            list/46 := arg/51
            spilled-list/56 := list/46 (spill)
            exit(6)
          else
            A/52 := 1
          endif
          res/48 := A/52
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(8)
      
    endcatch
    sum/53 := 1
  with(7)
    sum/53 := res/48
  endcatch
  A/54 := "camlCode"
  [A/54 + 32] := sum/53
  A/55 := 1
  R/0[%rax] := A/55
  return R/0[%rax]
*** After live range splitting
camlCode__entry()
  clos/29 := "camlCode__5"
  A/30 := "camlCode"
  [A/30] := clos/29
  list_iter/31 := "camlCode__4"
  A/32 := "camlCode"
  [A/32 + 8] := list_iter/31
  list1/33 := "camlCode__1"
  A/34 := "camlCode"
  [A/34 + 16] := list1/33
  A/35 := "camlCode"
  list/36 := [A/35 + 16]
  f/37 := "camlCode__3"
  clos_env/38 := "camlCode__2"
  R/0[%rax] := f/37
  R/1[%rbx] := list/36
  R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
  list2/39 := R/0[%rax]
  A/40 := "camlCode"
  [A/40 + 24] := list2/39
  temp/41 := alloc 48
  [temp/41 + -8] := 1024
  [temp/41] := 1
  A/42 := "camlCode"
  list/43 := [A/42 + 24]
  f/44 := temp/41 + 16
  [f/44 + -8] := 3319
  A/45 := "camlCode__fun_1068"
  [f/44] := A/45
  [f/44 + 8] := 3
  [f/44 + 16] := temp/41
  list/46 := list/43
  spilled-list/56 := list/46 (spill)
  f/47 := f/44
  spilled-f/57 := f/47 (spill)
  catch
    catch
      loop
        catch
          if list/46 !=s 1 then
            A/49 := [list/46]
            f/58 := spilled-f/57 (reload)
            A/50 := [f/58]
            R/0[%rax] := A/49
            R/1[%rbx] := f/58
            call A/50 R/0[%rax] R/1[%rbx]
            list/46 := spilled-list/56 (reload)
            arg/51 := [list/46 + 8]
            list/46 := arg/51
            spilled-list/56 := list/46 (spill)
            exit(6)
          else
            A/52 := 1
          endif
          res/48 := A/52
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(8)
      
    endcatch
    sum/53 := 1
  with(7)
    sum/53 := res/48
  endcatch
  A/54 := "camlCode"
  [A/54 + 32] := sum/53
  A/55 := 1
  R/0[%rax] := A/55
  return R/0[%rax]
lambda saved
typedtree saved
-dclosure
close_rec_functions
Recursive function list_map could be inlined
(seq
  (let
    (clos/1060
       (closure (camlCode__list_map_1030(2)  f/1031 list/1032
                 (if list/1032
                   (makeblock 0 (apply f/1031 (field 0 list/1032))
                     (camlCode__list_map_1030  f/1031 (field 1 list/1032)))
                   0a)) ))
    (setfield_imm 0 (global camlCode!) clos/1060))
  (let
    (list_iter/1035
       (closure (camlCode__list_iter_1035(2)  f/1056 list/1057
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
                    with (7 res/1055) res/1055))) ))
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
                      param/1052) )
          clos_env/1067
            (closure (camlCode__list_map_1066(2)  f/1031 list/1032
                      (if list/1032
                        (makeblock 0 (apply f/1031 (field 0 list/1032))
                          (camlCode__list_map_1066  f/1031
                            (field 1 list/1032)))
                        0a)) ))
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
                        (+ (field 0 (field 2 env/1070)) y/1046))) 
                                                                  temp/1045)
          list/1073 list/1071
          f/1074 f/1072)
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
  0a)(seq
       (let
         (clos/1060
            (closure (camlCode__list_map_1030(2)  f/1031 list/1032
                      (if list/1032
                        (makeblock 0 (apply f/1031 (field 0 list/1032))
                          (camlCode__list_map_1030  f/1031
                            (field 1 list/1032)))
                        0a)) ))
         (setfield_imm 0 (global camlCode!) clos/1060))
       (let
         (list_iter/1035
            (closure (camlCode__list_iter_1035(2)  f/1056 list/1057
                      (let (list/1037 list/1057 f/1036 f/1056)
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
                         with (7 res/1055) res/1055))) ))
         (setfield_imm 1 (global camlCode!) list_iter/1035))
       (let
         (list1/1040
            [0: [0: 1 2] [0: [0: 3 4] [0: [0: 5 6] [0: [0: 7 8] 0a]]]])
         (setfield_imm 2 (global camlCode!) list1/1040))
       (let
         (list2/1041
            (let
              (list/1064 (field 2 (global camlCode!))
               f/1065
                 (closure (camlCode__fun_1062(-2)  param/1052 param/1053
                           param/1052) )
               clos_env/1067
                 (closure (camlCode__list_map_1066(2)  f/1031 list/1032
                           (if list/1032
                             (makeblock 0 (apply f/1031 (field 0 list/1032))
                               (camlCode__list_map_1066  f/1031
                                 (field 1 list/1032)))
                             0a)) ))
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
                             (+ (field 0 (field 2 env/1070)) y/1046))) 
                  
                  temp/1045)
               list/1073 list/1071
               f/1074 f/1072)
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
       0a)*** After instruction selection
camlCode__list_map_1030(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1030" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/34 := [list/30]
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After spilling
camlCode__list_map_1030(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1030" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/30 := spilled-list/40 (reload)
    A/34 := [list/30]
    f/29 := spilled-f/39 (reload)
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/33 := A/38 (reload)
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After live range splitting
camlCode__list_map_1030(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1030" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/41 := spilled-list/40 (reload)
    A/34 := [list/41]
    f/42 := spilled-f/39 (reload)
    A/35 := [f/42]
    R/0[%rax] := A/34
    R/1[%rbx] := f/42
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/43 := A/38 (reload)
    [A/37 + 8] := A/43
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After instruction selection
camlCode__list_iter_1035(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  list/31 := list/30
  f/32 := f/29
  catch
    catch
      loop
        catch
          if list/31 !=s 1 then
            A/34 := [list/31]
            A/35 := [f/32]
            R/0[%rax] := A/34
            R/1[%rbx] := f/32
            call A/35 R/0[%rax] R/1[%rbx]
            arg/36 := [list/31 + 8]
            list/31 := arg/36
            exit(6)
          else
            A/37 := 1
          endif
          res/33 := A/37
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(9)
      
    endcatch
    A/38 := 1
    R/0[%rax] := A/38
    return R/0[%rax]
  with(7)
    R/0[%rax] := res/33
    return R/0[%rax]
  endcatch
*** After spilling
camlCode__list_iter_1035(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  list/31 := list/30
  spilled-list/39 := list/31 (spill)
  f/32 := f/29
  spilled-f/40 := f/32 (spill)
  catch
    catch
      loop
        catch
          if list/31 !=s 1 then
            A/34 := [list/31]
            f/32 := spilled-f/40 (reload)
            A/35 := [f/32]
            R/0[%rax] := A/34
            R/1[%rbx] := f/32
            call A/35 R/0[%rax] R/1[%rbx]
            list/31 := spilled-list/39 (reload)
            arg/36 := [list/31 + 8]
            list/31 := arg/36
            spilled-list/39 := list/31 (spill)
            exit(6)
          else
            A/37 := 1
          endif
          res/33 := A/37
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(9)
      
    endcatch
    A/38 := 1
    R/0[%rax] := A/38
    return R/0[%rax]
  with(7)
    R/0[%rax] := res/33
    return R/0[%rax]
  endcatch
*** After live range splitting
camlCode__list_iter_1035(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  list/31 := list/30
  spilled-list/39 := list/31 (spill)
  f/32 := f/29
  spilled-f/40 := f/32 (spill)
  catch
    catch
      loop
        catch
          if list/31 !=s 1 then
            A/34 := [list/31]
            f/41 := spilled-f/40 (reload)
            A/35 := [f/41]
            R/0[%rax] := A/34
            R/1[%rbx] := f/41
            call A/35 R/0[%rax] R/1[%rbx]
            list/31 := spilled-list/39 (reload)
            arg/36 := [list/31 + 8]
            list/31 := arg/36
            spilled-list/39 := list/31 (spill)
            exit(6)
          else
            A/37 := 1
          endif
          res/33 := A/37
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(9)
      
    endcatch
    A/38 := 1
    R/0[%rax] := A/38
    return R/0[%rax]
  with(7)
    R/0[%rax] := res/33
    return R/0[%rax]
  endcatch
*** After instruction selection
camlCode__fun_1062(R/0[%rax] R/1[%rbx])
  param/29 := R/0[%rax]
  param/30 := R/1[%rbx]
  R/0[%rax] := param/29
  return R/0[%rax]
*** After spilling
camlCode__fun_1062(R/0[%rax] R/1[%rbx])
  param/29 := R/0[%rax]
  param/30 := R/1[%rbx]
  R/0[%rax] := param/29
  return R/0[%rax]
*** After live range splitting
camlCode__fun_1062(R/0[%rax] R/1[%rbx])
  param/29 := R/0[%rax]
  param/30 := R/1[%rbx]
  R/0[%rax] := param/29
  return R/0[%rax]
*** After instruction selection
camlCode__list_map_1066(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/34 := [list/30]
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After spilling
camlCode__list_map_1066(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/30 := spilled-list/40 (reload)
    A/34 := [list/30]
    f/29 := spilled-f/39 (reload)
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/33 := A/38 (reload)
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After live range splitting
camlCode__list_map_1066(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/41 := spilled-list/40 (reload)
    A/34 := [list/41]
    f/42 := spilled-f/39 (reload)
    A/35 := [f/42]
    R/0[%rax] := A/34
    R/1[%rbx] := f/42
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/43 := A/38 (reload)
    [A/37 + 8] := A/43
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After instruction selection
camlCode__fun_1068(R/0[%rax] R/1[%rbx])
  y/29 := R/0[%rax]
  env/30 := R/1[%rbx]
  A/31 := [env/30 + 16]
  A/32 := [env/30 + 16]
  A/33 := [A/32]
  I/34 := A/33 + y/29 + -1
  [A/31] := I/34
  A/35 := 1
  R/0[%rax] := A/35
  return R/0[%rax]
*** After spilling
camlCode__fun_1068(R/0[%rax] R/1[%rbx])
  y/29 := R/0[%rax]
  env/30 := R/1[%rbx]
  A/31 := [env/30 + 16]
  A/32 := [env/30 + 16]
  A/33 := [A/32]
  I/34 := A/33 + y/29 + -1
  [A/31] := I/34
  A/35 := 1
  R/0[%rax] := A/35
  return R/0[%rax]
*** After live range splitting
camlCode__fun_1068(R/0[%rax] R/1[%rbx])
  y/29 := R/0[%rax]
  env/30 := R/1[%rbx]
  A/31 := [env/30 + 16]
  A/32 := [env/30 + 16]
  A/33 := [A/32]
  I/34 := A/33 + y/29 + -1
  [A/31] := I/34
  A/35 := 1
  R/0[%rax] := A/35
  return R/0[%rax]
*** After instruction selection
camlCode__entry()
  clos/29 := "camlCode__5"
  A/30 := "camlCode"
  [A/30] := clos/29
  list_iter/31 := "camlCode__4"
  A/32 := "camlCode"
  [A/32 + 8] := list_iter/31
  list1/33 := "camlCode__1"
  A/34 := "camlCode"
  [A/34 + 16] := list1/33
  A/35 := "camlCode"
  list/36 := [A/35 + 16]
  f/37 := "camlCode__3"
  clos_env/38 := "camlCode__2"
  R/0[%rax] := f/37
  R/1[%rbx] := list/36
  R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
  list2/39 := R/0[%rax]
  A/40 := "camlCode"
  [A/40 + 24] := list2/39
  temp/41 := alloc 16
  [temp/41 + -8] := 1024
  [temp/41] := 1
  A/42 := "camlCode"
  list/43 := [A/42 + 24]
  f/44 := alloc 32
  [f/44 + -8] := 3319
  A/45 := "camlCode__fun_1068"
  [f/44] := A/45
  [f/44 + 8] := 3
  [f/44 + 16] := temp/41
  list/46 := list/43
  f/47 := f/44
  catch
    catch
      loop
        catch
          if list/46 !=s 1 then
            A/49 := [list/46]
            A/50 := [f/47]
            R/0[%rax] := A/49
            R/1[%rbx] := f/47
            call A/50 R/0[%rax] R/1[%rbx]
            arg/51 := [list/46 + 8]
            list/46 := arg/51
            exit(6)
          else
            A/52 := 1
          endif
          res/48 := A/52
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(8)
      
    endcatch
    sum/53 := 1
  with(7)
    sum/53 := res/48
  endcatch
  A/54 := "camlCode"
  [A/54 + 32] := sum/53
  A/55 := 1
  R/0[%rax] := A/55
  return R/0[%rax]
*** After spilling
camlCode__entry()
  clos/29 := "camlCode__5"
  A/30 := "camlCode"
  [A/30] := clos/29
  list_iter/31 := "camlCode__4"
  A/32 := "camlCode"
  [A/32 + 8] := list_iter/31
  list1/33 := "camlCode__1"
  A/34 := "camlCode"
  [A/34 + 16] := list1/33
  A/35 := "camlCode"
  list/36 := [A/35 + 16]
  f/37 := "camlCode__3"
  clos_env/38 := "camlCode__2"
  R/0[%rax] := f/37
  R/1[%rbx] := list/36
  R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
  list2/39 := R/0[%rax]
  A/40 := "camlCode"
  [A/40 + 24] := list2/39
  temp/41 := alloc 48
  [temp/41 + -8] := 1024
  [temp/41] := 1
  A/42 := "camlCode"
  list/43 := [A/42 + 24]
  f/44 := temp/41 + 16
  [f/44 + -8] := 3319
  A/45 := "camlCode__fun_1068"
  [f/44] := A/45
  [f/44 + 8] := 3
  [f/44 + 16] := temp/41
  list/46 := list/43
  spilled-list/56 := list/46 (spill)
  f/47 := f/44
  spilled-f/57 := f/47 (spill)
  catch
    catch
      loop
        catch
          if list/46 !=s 1 then
            A/49 := [list/46]
            f/47 := spilled-f/57 (reload)
            A/50 := [f/47]
            R/0[%rax] := A/49
            R/1[%rbx] := f/47
            call A/50 R/0[%rax] R/1[%rbx]
            list/46 := spilled-list/56 (reload)
            arg/51 := [list/46 + 8]
            list/46 := arg/51
            spilled-list/56 := list/46 (spill)
            exit(6)
          else
            A/52 := 1
          endif
          res/48 := A/52
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(8)
      
    endcatch
    sum/53 := 1
  with(7)
    sum/53 := res/48
  endcatch
  A/54 := "camlCode"
  [A/54 + 32] := sum/53
  A/55 := 1
  R/0[%rax] := A/55
  return R/0[%rax]
*** After live range splitting
camlCode__entry()
  clos/29 := "camlCode__5"
  A/30 := "camlCode"
  [A/30] := clos/29
  list_iter/31 := "camlCode__4"
  A/32 := "camlCode"
  [A/32 + 8] := list_iter/31
  list1/33 := "camlCode__1"
  A/34 := "camlCode"
  [A/34 + 16] := list1/33
  A/35 := "camlCode"
  list/36 := [A/35 + 16]
  f/37 := "camlCode__3"
  clos_env/38 := "camlCode__2"
  R/0[%rax] := f/37
  R/1[%rbx] := list/36
  R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
  list2/39 := R/0[%rax]
  A/40 := "camlCode"
  [A/40 + 24] := list2/39
  temp/41 := alloc 48
  [temp/41 + -8] := 1024
  [temp/41] := 1
  A/42 := "camlCode"
  list/43 := [A/42 + 24]
  f/44 := temp/41 + 16
  [f/44 + -8] := 3319
  A/45 := "camlCode__fun_1068"
  [f/44] := A/45
  [f/44 + 8] := 3
  [f/44 + 16] := temp/41
  list/46 := list/43
  spilled-list/56 := list/46 (spill)
  f/47 := f/44
  spilled-f/57 := f/47 (spill)
  catch
    catch
      loop
        catch
          if list/46 !=s 1 then
            A/49 := [list/46]
            f/58 := spilled-f/57 (reload)
            A/50 := [f/58]
            R/0[%rax] := A/49
            R/1[%rbx] := f/58
            call A/50 R/0[%rax] R/1[%rbx]
            list/46 := spilled-list/56 (reload)
            arg/51 := [list/46 + 8]
            list/46 := arg/51
            spilled-list/56 := list/46 (spill)
            exit(6)
          else
            A/52 := 1
          endif
          res/48 := A/52
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(8)
      
    endcatch
    sum/53 := 1
  with(7)
    sum/53 := res/48
  endcatch
  A/54 := "camlCode"
  [A/54 + 32] := sum/53
  A/55 := 1
  R/0[%rax] := A/55
  return R/0[%rax]
lambda saved
typedtree saved

-dcmm
close_rec_functions
Recursive function list_map could be inlined
(data int 5120 global "camlCode" "camlCode": skip 40)
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
     (app "camlCode__list_map_1030" f/1031 (load (+a list/1032 8)) addr))
   1a))

*** After instruction selection
camlCode__list_map_1030(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1030" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/34 := [list/30]
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After spilling
camlCode__list_map_1030(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1030" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/30 := spilled-list/40 (reload)
    A/34 := [list/30]
    f/29 := spilled-f/39 (reload)
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/33 := A/38 (reload)
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After live range splitting
camlCode__list_map_1030(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1030" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/41 := spilled-list/40 (reload)
    A/34 := [list/41]
    f/42 := spilled-f/39 (reload)
    A/35 := [f/42]
    R/0[%rax] := A/34
    R/1[%rbx] := f/42
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/43 := A/38 (reload)
    [A/37 + 8] := A/43
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
(function camlCode__list_iter_1035 (f/1056: addr list/1057: addr)
 (let (list/1037 list/1057 f/1036 f/1056)
   (catch
     (catch
       (loop
         (catch
           (exit 7
             (if (!= list/1037 1)
               (seq (app (load f/1036) (load list/1037) f/1036 unit)
                 (let arg/1054 (load (+a list/1037 8))
                   (assign list/1037 arg/1054) (exit 6)))
               1a))
         with(6) []))
     with(9) []) 1a
   with(7 res/1055) res/1055)))

*** After instruction selection
camlCode__list_iter_1035(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  list/31 := list/30
  f/32 := f/29
  catch
    catch
      loop
        catch
          if list/31 !=s 1 then
            A/34 := [list/31]
            A/35 := [f/32]
            R/0[%rax] := A/34
            R/1[%rbx] := f/32
            call A/35 R/0[%rax] R/1[%rbx]
            arg/36 := [list/31 + 8]
            list/31 := arg/36
            exit(6)
          else
            A/37 := 1
          endif
          res/33 := A/37
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(9)
      
    endcatch
    A/38 := 1
    R/0[%rax] := A/38
    return R/0[%rax]
  with(7)
    R/0[%rax] := res/33
    return R/0[%rax]
  endcatch
*** After spilling
camlCode__list_iter_1035(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  list/31 := list/30
  spilled-list/39 := list/31 (spill)
  f/32 := f/29
  spilled-f/40 := f/32 (spill)
  catch
    catch
      loop
        catch
          if list/31 !=s 1 then
            A/34 := [list/31]
            f/32 := spilled-f/40 (reload)
            A/35 := [f/32]
            R/0[%rax] := A/34
            R/1[%rbx] := f/32
            call A/35 R/0[%rax] R/1[%rbx]
            list/31 := spilled-list/39 (reload)
            arg/36 := [list/31 + 8]
            list/31 := arg/36
            spilled-list/39 := list/31 (spill)
            exit(6)
          else
            A/37 := 1
          endif
          res/33 := A/37
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(9)
      
    endcatch
    A/38 := 1
    R/0[%rax] := A/38
    return R/0[%rax]
  with(7)
    R/0[%rax] := res/33
    return R/0[%rax]
  endcatch
*** After live range splitting
camlCode__list_iter_1035(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  list/31 := list/30
  spilled-list/39 := list/31 (spill)
  f/32 := f/29
  spilled-f/40 := f/32 (spill)
  catch
    catch
      loop
        catch
          if list/31 !=s 1 then
            A/34 := [list/31]
            f/41 := spilled-f/40 (reload)
            A/35 := [f/41]
            R/0[%rax] := A/34
            R/1[%rbx] := f/41
            call A/35 R/0[%rax] R/1[%rbx]
            list/31 := spilled-list/39 (reload)
            arg/36 := [list/31 + 8]
            list/31 := arg/36
            spilled-list/39 := list/31 (spill)
            exit(6)
          else
            A/37 := 1
          endif
          res/33 := A/37
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(9)
      
    endcatch
    A/38 := 1
    R/0[%rax] := A/38
    return R/0[%rax]
  with(7)
    R/0[%rax] := res/33
    return R/0[%rax]
  endcatch
(function camlCode__fun_1062 (param/1052: addr param/1053: addr) param/1052)

*** After instruction selection
camlCode__fun_1062(R/0[%rax] R/1[%rbx])
  param/29 := R/0[%rax]
  param/30 := R/1[%rbx]
  R/0[%rax] := param/29
  return R/0[%rax]
*** After spilling
camlCode__fun_1062(R/0[%rax] R/1[%rbx])
  param/29 := R/0[%rax]
  param/30 := R/1[%rbx]
  R/0[%rax] := param/29
  return R/0[%rax]
*** After live range splitting
camlCode__fun_1062(R/0[%rax] R/1[%rbx])
  param/29 := R/0[%rax]
  param/30 := R/1[%rbx]
  R/0[%rax] := param/29
  return R/0[%rax]
(function camlCode__list_map_1066 (f/1031: addr list/1032: addr)
 (if (!= list/1032 1)
   (alloc 2048 (app (load f/1031) (load list/1032) f/1031 addr)
     (app "camlCode__list_map_1066" f/1031 (load (+a list/1032 8)) addr))
   1a))

*** After instruction selection
camlCode__list_map_1066(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/34 := [list/30]
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After spilling
camlCode__list_map_1066(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/30 := spilled-list/40 (reload)
    A/34 := [list/30]
    f/29 := spilled-f/39 (reload)
    A/35 := [f/29]
    R/0[%rax] := A/34
    R/1[%rbx] := f/29
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/33 := A/38 (reload)
    [A/37 + 8] := A/33
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
*** After live range splitting
camlCode__list_map_1066(R/0[%rax] R/1[%rbx])
  f/29 := R/0[%rax]
  list/30 := R/1[%rbx]
  if list/30 !=s 1 then
    spilled-list/40 := list/30 (spill)
    spilled-f/39 := f/29 (spill)
    A/32 := [list/30 + 8]
    R/0[%rax] := f/29
    R/1[%rbx] := A/32
    R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
    A/33 := R/0[%rax]
    A/38 := A/33 (spill)
    list/41 := spilled-list/40 (reload)
    A/34 := [list/41]
    f/42 := spilled-f/39 (reload)
    A/35 := [f/42]
    R/0[%rax] := A/34
    R/1[%rbx] := f/42
    R/0[%rax] := call A/35 R/0[%rax] R/1[%rbx]
    A/36 := R/0[%rax]
    A/37 := alloc 24
    [A/37 + -8] := 2048
    [A/37] := A/36
    A/43 := A/38 (reload)
    [A/37 + 8] := A/43
    R/0[%rax] := A/37
    return R/0[%rax]
  else
    A/31 := 1
    R/0[%rax] := A/31
    return R/0[%rax]
  endif
(function camlCode__fun_1068 (y/1046: addr env/1070: addr)
 (store (load (+a env/1070 16))
   (+ (+ (load (load (+a env/1070 16))) y/1046) -1))
 1a)

*** After instruction selection
camlCode__fun_1068(R/0[%rax] R/1[%rbx])
  y/29 := R/0[%rax]
  env/30 := R/1[%rbx]
  A/31 := [env/30 + 16]
  A/32 := [env/30 + 16]
  A/33 := [A/32]
  I/34 := A/33 + y/29 + -1
  [A/31] := I/34
  A/35 := 1
  R/0[%rax] := A/35
  return R/0[%rax]
*** After spilling
camlCode__fun_1068(R/0[%rax] R/1[%rbx])
  y/29 := R/0[%rax]
  env/30 := R/1[%rbx]
  A/31 := [env/30 + 16]
  A/32 := [env/30 + 16]
  A/33 := [A/32]
  I/34 := A/33 + y/29 + -1
  [A/31] := I/34
  A/35 := 1
  R/0[%rax] := A/35
  return R/0[%rax]
*** After live range splitting
camlCode__fun_1068(R/0[%rax] R/1[%rbx])
  y/29 := R/0[%rax]
  env/30 := R/1[%rbx]
  A/31 := [env/30 + 16]
  A/32 := [env/30 + 16]
  A/33 := [A/32]
  I/34 := A/33 + y/29 + -1
  [A/31] := I/34
  A/35 := 1
  R/0[%rax] := A/35
  return R/0[%rax]
(function camlCode__entry ()
 (let clos/1060 "camlCode__5" (store "camlCode" clos/1060))
 (let list_iter/1035 "camlCode__4" (store (+a "camlCode" 8) list_iter/1035))
 (let list1/1040 "camlCode__1" (store (+a "camlCode" 16) list1/1040))
 (let
   list2/1041
     (let
       (list/1064 (load (+a "camlCode" 16)) f/1065 "camlCode__3"
        clos_env/1067 "camlCode__2")
       (app "camlCode__list_map_1066" f/1065 list/1064 addr))
   (store (+a "camlCode" 24) list2/1041))
 (let
   sum/1044
     (let
       (temp/1045 (alloc 1024 1) list/1071 (load (+a "camlCode" 24))
        f/1072 (alloc 3319 "camlCode__fun_1068" 3 temp/1045)
        list/1073 list/1071 f/1074 f/1072)
       (catch
         (catch
           (loop
             (catch
               (exit 7
                 (if (!= list/1073 1)
                   (seq (app (load f/1074) (load list/1073) f/1074 unit)
                     (let arg/1075 (load (+a list/1073 8))
                       (assign list/1073 arg/1075) (exit 6)))
                   1a))
             with(6) []))
         with(8) []) 1a
       with(7 res/1055) res/1055))
   (store (+a "camlCode" 32) sum/1044))
 1a)

*** After instruction selection
camlCode__entry()
  clos/29 := "camlCode__5"
  A/30 := "camlCode"
  [A/30] := clos/29
  list_iter/31 := "camlCode__4"
  A/32 := "camlCode"
  [A/32 + 8] := list_iter/31
  list1/33 := "camlCode__1"
  A/34 := "camlCode"
  [A/34 + 16] := list1/33
  A/35 := "camlCode"
  list/36 := [A/35 + 16]
  f/37 := "camlCode__3"
  clos_env/38 := "camlCode__2"
  R/0[%rax] := f/37
  R/1[%rbx] := list/36
  R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
  list2/39 := R/0[%rax]
  A/40 := "camlCode"
  [A/40 + 24] := list2/39
  temp/41 := alloc 16
  [temp/41 + -8] := 1024
  [temp/41] := 1
  A/42 := "camlCode"
  list/43 := [A/42 + 24]
  f/44 := alloc 32
  [f/44 + -8] := 3319
  A/45 := "camlCode__fun_1068"
  [f/44] := A/45
  [f/44 + 8] := 3
  [f/44 + 16] := temp/41
  list/46 := list/43
  f/47 := f/44
  catch
    catch
      loop
        catch
          if list/46 !=s 1 then
            A/49 := [list/46]
            A/50 := [f/47]
            R/0[%rax] := A/49
            R/1[%rbx] := f/47
            call A/50 R/0[%rax] R/1[%rbx]
            arg/51 := [list/46 + 8]
            list/46 := arg/51
            exit(6)
          else
            A/52 := 1
          endif
          res/48 := A/52
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(8)
      
    endcatch
    sum/53 := 1
  with(7)
    sum/53 := res/48
  endcatch
  A/54 := "camlCode"
  [A/54 + 32] := sum/53
  A/55 := 1
  R/0[%rax] := A/55
  return R/0[%rax]
*** After spilling
camlCode__entry()
  clos/29 := "camlCode__5"
  A/30 := "camlCode"
  [A/30] := clos/29
  list_iter/31 := "camlCode__4"
  A/32 := "camlCode"
  [A/32 + 8] := list_iter/31
  list1/33 := "camlCode__1"
  A/34 := "camlCode"
  [A/34 + 16] := list1/33
  A/35 := "camlCode"
  list/36 := [A/35 + 16]
  f/37 := "camlCode__3"
  clos_env/38 := "camlCode__2"
  R/0[%rax] := f/37
  R/1[%rbx] := list/36
  R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
  list2/39 := R/0[%rax]
  A/40 := "camlCode"
  [A/40 + 24] := list2/39
  temp/41 := alloc 48
  [temp/41 + -8] := 1024
  [temp/41] := 1
  A/42 := "camlCode"
  list/43 := [A/42 + 24]
  f/44 := temp/41 + 16
  [f/44 + -8] := 3319
  A/45 := "camlCode__fun_1068"
  [f/44] := A/45
  [f/44 + 8] := 3
  [f/44 + 16] := temp/41
  list/46 := list/43
  spilled-list/56 := list/46 (spill)
  f/47 := f/44
  spilled-f/57 := f/47 (spill)
  catch
    catch
      loop
        catch
          if list/46 !=s 1 then
            A/49 := [list/46]
            f/47 := spilled-f/57 (reload)
            A/50 := [f/47]
            R/0[%rax] := A/49
            R/1[%rbx] := f/47
            call A/50 R/0[%rax] R/1[%rbx]
            list/46 := spilled-list/56 (reload)
            arg/51 := [list/46 + 8]
            list/46 := arg/51
            spilled-list/56 := list/46 (spill)
            exit(6)
          else
            A/52 := 1
          endif
          res/48 := A/52
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(8)
      
    endcatch
    sum/53 := 1
  with(7)
    sum/53 := res/48
  endcatch
  A/54 := "camlCode"
  [A/54 + 32] := sum/53
  A/55 := 1
  R/0[%rax] := A/55
  return R/0[%rax]
*** After live range splitting
camlCode__entry()
  clos/29 := "camlCode__5"
  A/30 := "camlCode"
  [A/30] := clos/29
  list_iter/31 := "camlCode__4"
  A/32 := "camlCode"
  [A/32 + 8] := list_iter/31
  list1/33 := "camlCode__1"
  A/34 := "camlCode"
  [A/34 + 16] := list1/33
  A/35 := "camlCode"
  list/36 := [A/35 + 16]
  f/37 := "camlCode__3"
  clos_env/38 := "camlCode__2"
  R/0[%rax] := f/37
  R/1[%rbx] := list/36
  R/0[%rax] := call "camlCode__list_map_1066" R/0[%rax] R/1[%rbx]
  list2/39 := R/0[%rax]
  A/40 := "camlCode"
  [A/40 + 24] := list2/39
  temp/41 := alloc 48
  [temp/41 + -8] := 1024
  [temp/41] := 1
  A/42 := "camlCode"
  list/43 := [A/42 + 24]
  f/44 := temp/41 + 16
  [f/44 + -8] := 3319
  A/45 := "camlCode__fun_1068"
  [f/44] := A/45
  [f/44 + 8] := 3
  [f/44 + 16] := temp/41
  list/46 := list/43
  spilled-list/56 := list/46 (spill)
  f/47 := f/44
  spilled-f/57 := f/47 (spill)
  catch
    catch
      loop
        catch
          if list/46 !=s 1 then
            A/49 := [list/46]
            f/58 := spilled-f/57 (reload)
            A/50 := [f/58]
            R/0[%rax] := A/49
            R/1[%rbx] := f/58
            call A/50 R/0[%rax] R/1[%rbx]
            list/46 := spilled-list/56 (reload)
            arg/51 := [list/46 + 8]
            list/46 := arg/51
            spilled-list/56 := list/46 (spill)
            exit(6)
          else
            A/52 := 1
          endif
          res/48 := A/52
          exit(7)
        with(6)
          
        endcatch
      endloop
    with(8)
      
    endcatch
    sum/53 := 1
  with(7)
    sum/53 := res/48
  endcatch
  A/54 := "camlCode"
  [A/54 + 32] := sum/53
  A/55 := 1
  R/0[%rax] := A/55
  return R/0[%rax]
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
	.quad	5120
	.globl	camlCode
camlCode:
	.space	40
	.data
	.quad	3319
camlCode__2:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__list_map_1066
	.data
	.quad	3319
camlCode__3:
	.quad	caml_tuplify2
	.quad	-3
	.quad	camlCode__fun_1062
	.data
	.quad	3319
camlCode__4:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__list_iter_1035
	.data
	.quad	3319
camlCode__5:
	.quad	caml_curry2
	.quad	5
	.quad	camlCode__list_map_1030
	.data
	.globl	camlCode__1
	.quad	2048
camlCode__1:
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
	.quad	15
	.quad	17
	.quad	2048
.L100010:
	.quad	11
	.quad	13
	.quad	2048
.L100008:
	.quad	7
	.quad	9
	.quad	2048
.L100006:
	.quad	3
	.quad	5
	.text
	.align	16
	.globl	camlCode__list_map_1030
camlCode__list_map_1030:
	subq	$24, %rsp
.L101:
	cmpq	$1, %rbx
	je	.L100
	movq	%rbx, 0(%rsp)
	movq	%rax, 8(%rsp)
	movq	8(%rbx), %rbx
	call	camlCode__list_map_1030@PLT
.L102:
	movq	%rax, 16(%rsp)
	movq	0(%rsp), %rax
	movq	(%rax), %rax
	movq	8(%rsp), %rbx
	movq	(%rbx), %rdi
	call	*%rdi
.L103:
	movq	%rax, %rbx
.L104:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L105
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	%rbx, (%rax)
	movq	16(%rsp), %rbx
	movq	%rbx, 8(%rax)
	addq	$24, %rsp
	ret
	.align	4
.L100:
	movq	$1, %rax
	addq	$24, %rsp
	ret
.L105:	call	caml_call_gc@PLT
.L106:	jmp	.L104
	.type	camlCode__list_map_1030,@function
	.size	camlCode__list_map_1030,.-camlCode__list_map_1030
	.text
	.align	16
	.globl	camlCode__list_iter_1035
camlCode__list_iter_1035:
	subq	$24, %rsp
.L111:
	movq	%rbx, 8(%rsp)
	movq	%rax, 0(%rsp)
.L109:
	cmpq	$1, %rbx
	je	.L110
	movq	(%rbx), %rax
	movq	0(%rsp), %rbx
	movq	(%rbx), %rdi
	call	*%rdi
.L112:
	movq	8(%rsp), %rbx
	movq	8(%rbx), %rbx
	movq	%rbx, 8(%rsp)
	jmp	.L109
	.align	4
.L110:
	movq	$1, %rax
	jmp	.L107
	.align	4
.L108:
	movq	$1, %rax
	addq	$24, %rsp
	ret
	.align	4
.L107:
	addq	$24, %rsp
	ret
	.type	camlCode__list_iter_1035,@function
	.size	camlCode__list_iter_1035,.-camlCode__list_iter_1035
	.text
	.align	16
	.globl	camlCode__fun_1062
camlCode__fun_1062:
.L113:
	ret
	.type	camlCode__fun_1062,@function
	.size	camlCode__fun_1062,.-camlCode__fun_1062
	.text
	.align	16
	.globl	camlCode__list_map_1066
camlCode__list_map_1066:
	subq	$24, %rsp
.L115:
	cmpq	$1, %rbx
	je	.L114
	movq	%rbx, 0(%rsp)
	movq	%rax, 8(%rsp)
	movq	8(%rbx), %rbx
	call	camlCode__list_map_1066@PLT
.L116:
	movq	%rax, 16(%rsp)
	movq	0(%rsp), %rax
	movq	(%rax), %rax
	movq	8(%rsp), %rbx
	movq	(%rbx), %rdi
	call	*%rdi
.L117:
	movq	%rax, %rbx
.L118:	subq	$24, %r15
	movq	caml_young_limit@GOTPCREL(%rip), %rax
	cmpq	(%rax), %r15
	jb	.L119
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	%rbx, (%rax)
	movq	16(%rsp), %rbx
	movq	%rbx, 8(%rax)
	addq	$24, %rsp
	ret
	.align	4
.L114:
	movq	$1, %rax
	addq	$24, %rsp
	ret
.L119:	call	caml_call_gc@PLT
.L120:	jmp	.L118
	.type	camlCode__list_map_1066,@function
	.size	camlCode__list_map_1066,.-camlCode__list_map_1066
	.text
	.align	16
	.globl	camlCode__fun_1068
camlCode__fun_1068:
.L121:
	movq	16(%rbx), %rdi
	movq	16(%rbx), %rbx
	movq	(%rbx), %rbx
	leaq	-1(%rbx, %rax), %rax
	movq	%rax, (%rdi)
	movq	$1, %rax
	ret
	.type	camlCode__fun_1068,@function
	.size	camlCode__fun_1068,.-camlCode__fun_1068
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
	subq	$24, %rsp
.L126:
	movq	camlCode__5@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, (%rax)
	movq	camlCode__4@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 8(%rax)
	movq	camlCode__1@GOTPCREL(%rip), %rbx
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 16(%rax)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	16(%rax), %rbx
	movq	camlCode__3@GOTPCREL(%rip), %rax
	movq	camlCode__2@GOTPCREL(%rip), %rdi
	call	camlCode__list_map_1066@PLT
.L127:
	movq	camlCode@GOTPCREL(%rip), %rbx
	movq	%rax, 24(%rbx)
	movq	$48, %rax
	call	caml_allocN@PLT
.L128:
	leaq	8(%r15), %rsi
	movq	$1024, -8(%rsi)
	movq	$1, (%rsi)
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	24(%rax), %rax
	leaq	16(%rsi), %rbx
	movq	$3319, -8(%rbx)
	movq	camlCode__fun_1068@GOTPCREL(%rip), %rdi
	movq	%rdi, (%rbx)
	movq	$3, 8(%rbx)
	movq	%rsi, 16(%rbx)
	movq	%rax, 8(%rsp)
	movq	%rbx, 0(%rsp)
.L124:
	cmpq	$1, %rax
	je	.L125
	movq	(%rax), %rax
	movq	0(%rsp), %rbx
	movq	(%rbx), %rdi
	call	*%rdi
.L129:
	movq	8(%rsp), %rax
	movq	8(%rax), %rax
	movq	%rax, 8(%rsp)
	jmp	.L124
.L125:
	movq	$1, %rbx
	jmp	.L122
.L123:
	movq	$1, %rbx
.L122:
	movq	camlCode@GOTPCREL(%rip), %rax
	movq	%rbx, 32(%rax)
	movq	$1, %rax
	addq	$24, %rsp
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
	.quad	10
	.quad	.L129
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.quad	.L128
	.word	32
	.word	0
	.align	8
	.quad	.L127
	.word	32
	.word	0
	.align	8
	.quad	.L120
	.word	32
	.word	2
	.word	16
	.word	3
	.align	8
	.quad	.L117
	.word	32
	.word	1
	.word	16
	.align	8
	.quad	.L116
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.quad	.L112
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.quad	.L106
	.word	32
	.word	2
	.word	16
	.word	3
	.align	8
	.quad	.L103
	.word	32
	.word	1
	.word	16
	.align	8
	.quad	.L102
	.word	32
	.word	2
	.word	0
	.word	8
	.align	8
	.section .note.GNU-stack,"",%progbits
*)

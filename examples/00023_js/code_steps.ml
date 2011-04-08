
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
-dclosure
(seq
  (let
    (clos/83
       (closure (camlCode__list_map_58[2]( f/59 list/60)
                 (if list/60
                   (makeblock 0 (apply f/59 (field 0 list/60))
                     (camlCode__list_map_58  f/59 (field 1 list/60)))
                   0a)) []))
    (setfield_imm 0 (global camlCode!) (offset[0] clos/83)))
  (let
    (clos/85
       (closure (camlCode__list_iter_63[2]( f/64 list/65)
                 (if list/65
                   (seq (apply f/64 (field 0 list/65))
                     (camlCode__list_iter_63  f/64 (field 1 list/65)))
                   0a)) []))
    (setfield_imm 1 (global camlCode!) (offset[0] clos/85)))
  (let (list1/68 [0: [0: 1 2] [0: [0: 3 4] [0: [0: 5 6] [0: [0: 7 8] 0a]]]])
    (setfield_imm 2 (global camlCode!) list1/68))
  (let
    (list2/69
       (camlCode__list_map_58
         (closure (camlCode__fun_86[-2]( param/80 param/81) param/80) [])
         (field 2 (global camlCode!))))
    (setfield_imm 3 (global camlCode!) list2/69))
  (let
    (sum/72
       (let (temp/73 (makemutable 0 0))
         (camlCode__list_iter_63
           (closure (camlCode__fun_88[1]( y/74 env/90)
                     (setfield_imm 0 (field 2 env/90)
                       (+ (field 0 (field 2 env/90)) y/74))) [
                                                              temp/73])
           (field 3 (global camlCode!)))))
    (setfield_imm 4 (global camlCode!) sum/72))
  0a)
*)

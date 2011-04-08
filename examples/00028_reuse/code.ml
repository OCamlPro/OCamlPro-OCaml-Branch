(* 
In [f0], the compiler should detect that the closure for [g0] contains only
[y], and so, the closure should not be allocated. 

In [f1], the compiler should detect that the closure for [g1] contains only
[y] and [c1], and so, it can avoid allocating the closure by giving 
[y] and [c1] as extra arguments to [g1].
*)

let _ =
  let f0 x y =
    let g0 z = 
      let sum = ref 0 in
      let list = List.iter (fun a -> sum := !sum + y * z) [1;2;3;4;5;6] in
      !sum 
    in
    g0 (x+3)
  in
  f0 0 1
  
let _ =
  let c1 = [1;2;3;4;5;6] in
  let f1 x y =
    let g1 z = 
      let sum = ref 0 in
      let list = List.iter (fun a -> sum := !sum + y * z) c1 in
      !sum 
    in
    g1 (x+3)
  in
  f1 0 1
  
    
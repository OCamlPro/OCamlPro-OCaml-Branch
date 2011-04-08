(* This example shows that references can be translated to variables when
not appearing in a closure or as argument. Even simple float records are
translated. However, in the latter case, on x86, the removed reference is
translated back to equivalent code. *)

let f1 n =
  let r = ref n in
    for i = 0 to 10 do incr r done;
    !r

type float_ref = { mutable float : float }

let f2 n =
  let r = { float = n } in
    for i = 0 to 10 do r.float <- r.float +. 1. done;
    r.float

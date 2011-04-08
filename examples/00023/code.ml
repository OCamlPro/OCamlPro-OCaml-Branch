(* The 3 functions here all take only one argument, a pair. But the
closures are compiled differently: in the first case, it is
untuplified to a function with arity 2 (-2 in the closure text), while
in the other cases, the functions keep an arity of 1.

Note that this means that "fst" and "snd" will often not be inlined
when they should have been for efficiency.
*)

let f1 (a,b) = a+b
let f2 ((a,b) as c) = (a,b,c)
let f3 c =
  let (a,b) = c in
    (a,b,c)

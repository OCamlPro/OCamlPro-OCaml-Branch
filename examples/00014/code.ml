(* In f1, there is an allocation per assignment, because the type of
   x0 is not known (although it is obvious from the context that it is a
   float), and so no unboxing is performed.

   In f2, the need for unboxing is discovered, and so, no allocation
   takes place.

   In f3, the need for unboxing is discovered, but c escapes, so no
   unboxing is performed. There is a safety reason here: if unboxing
   is performed, there will be two values for c, one boxed, and the
   other unboxed. However, assignments can only change one of the two
   values, so there is gonna be inconsistencies. But, here, c is
   needed only at the end, so there is actually no possibility of
   inconsistency.

   In f4, we try to avoid the previous problem by explicitely creating
   an equivalent reference at the end, to prevent c from
   escaping. This is however not enough.

   Finally, f5 and f6 manage to avoid allocations, but the initial or
   final addition to 0. is kept in the assembly code !
*)

let f1 x0 =
  let c = ref x0 in
    c := x0 +. !c;
    c := x0 +. !c;
    c := x0 +. !c;
    x0 +. !c

let f2 x0 =
  let c = ref (ceil 3.) in
    c := x0 +. !c;
    c := x0 +. !c;
    c := x0 +. !c;
    x0 +. !c

let f3 x0 =
  let c = ref (ceil 3.) in
    c := x0 +. !c;
    c := x0 +. !c;
    c := x0 +. !c;
    c

let f4 x0 =
  let c = ref (ceil 3.) in
    c := x0 +. !c;
    c := x0 +. !c;
    c := x0 +. !c;
    ref !c

let f5 x0 =
  let c = ref (ceil 3.) in
    c := x0 +. !c;
    c := x0 +. !c;
    c := x0 +. !c;
    ref (!c +. 0.)

let f6 x0 =
  let c = ref (x0 +. 0.) in
    c := x0 +. !c;
    c := x0 +. !c;
    c := x0 +. !c;
    x0 +. !c



(* Pattern-matching introduces aliases variables, not strict
   variables.  These alias variables are simplified when they appear
   only once. As a consequence, a memory leak may appear as the
   constructed value is still required where the alias variable has
   been removed. In the following program, changing the use-count of
   "x" to 1 leads to a memory leak, where the total value returned by
   g is kept as long as the result of f is alive. Adding a fake use of
   x (ignore (x);) forces the compiler to evaluate immediatly the
   value of x, removing the memory leak.
*)

let f g =
  let (x,y) = g () in
  ignore (x); (* remove to see the memory leak *)
  (function () -> x)

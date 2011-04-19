(*
From Jane Street blog:
In the following, the current compilation of 'h' is bad, as it will
result in allocating a partial closure everytime it is called.

Since f is of exact arity 3, we are sure that it is more efficient
to implement h as 'f a' instead of '(fun b -> f a b)'.

Now, can we optimize (f a) ? (fun b c -> f a b c) is of course more
efficient, IF and only if we know that the function is going to be
called with exactly 2 arguments.

 *)


let rec fold_left f accu l =
  match l with
    [] -> accu
  | a::l -> fold_left f (f accu a) l


let m a =
  let f a b c = a + b + c in
  let g1 = f a in
  let g2 = (fun b -> f a b) in
  let g3 = (fun b c -> f a b c) in
  (g1, g2, g3)







(* closure of f = [| caml_curry3; 3; addr_f |] *)
(*
(function caml_apply2 (arg/1009: addr arg/1010: addr clos/1011: addr)
 (if (== (load (+a clos/1011 8)) 5)
   (app (load (+a clos/1011 16)) arg/1009 arg/1010 clos/1011 addr)
   (let clos/1012 (app (load clos/1011) arg/1009 clos/1011 addr)
     (app (load clos/1012) arg/1010 clos/1012 addr))))
*)
(*
(function caml_curry3 (arg/1024: addr clos/1025: addr)
 (alloc 4343 "caml_curry3_1" 3 arg/1024 clos/1025))

(function caml_curry3_1 (arg/1026: addr clos/1027: addr)
 (alloc 4343 "caml_curry3_2" 3 arg/1026 clos/1027))

(function caml_curry3_2 (arg/1028: addr clos/1029: addr)
 (let (clos/1030 (load (+a clos/1029 24)) clos/1031 (load (+a clos/1030 24)))
   (app (load (+a clos/1031 16)) (load (+a clos/1030 16))
     (load (+a clos/1029 16)) arg/1028 clos/1031 addr)))
*)

(*
[g1]:
The runtime executes caml_curry3 to generate g1. Each call to g1
calls caml_curry3_1 that allocates a new closure, before receiving the
last argument.

(function caml_apply2 (arg/1009: addr arg/1010: addr clos/1011: addr)
 (if (== (load (+a clos/1011 8)) 5)
   (app (load (+a clos/1011 16)) arg/1009 arg/1010 clos/1011 addr)
   (let clos/1012 (app (load clos/1011) arg/1009 clos/1011 addr)
     (app (load clos/1012) arg/1010 clos/1012 addr))))

could become:

(function caml_apply2 (arg/1009: addr arg/1010: addr clos/1011: addr)
 (if (== (load (+a clos/1011 8)) 5)
   (app (load (+a clos/1011 16)) arg/1009 arg/1010 clos/1011 addr)
   (if (== (load (+a clos/1011 0)) "caml_curry3_1")
     (let clos/1030 (load (+a clos/1011 24))
       (let arg/1031 (load (+a clos/1011 16))
          (app (load (+a clos/1030 16)) arg/1031 arg/1009 arg/1010 clos/1011 addr)))
     (let clos/1012 (app (load clos/1011) arg/1009 clos/1011 addr)
       (app (load clos/1012) arg/1010 clos/1012 addr))
   )
 )
)

i.e. we check for caml_curry3_1, in which case we directly call the function. Actually,
we should probably do that for all possible caml_curry{N}_{N-2}, but maybe just that one is
ok ? Do we have statistics on the number of arguments per function ?

Another solution:
(function caml_curry3 (arg/1024: addr clos/1025: addr)
 (alloc 4343 "caml_curry3_1" 3 arg/1024 clos/1025))

could become
(function caml_curry3 (arg/1024: addr clos/1025: addr)
 (alloc ???? "caml_curry3_1" 5 "caml_curry3_app2" arg/1024 clos/1025))

CHECK: check that functions of arity 1 have only one entry point (in which case
we can modify caml_curryX_Y to define them as functions with two entry points).
MAYBE this can only be done for functions with exact arity 3, i.e. other uses
of caml_curry3 would fail, so we should have a particular caml_curry3_maybe_direct
for such cases, where we know that we can totally apply the function ?
*)

let time g =
  let t0 = Unix.gettimeofday () in
  g ();
  let t1 = Unix.gettimeofday () in
  int_of_float ((t1 -. t0) *. 1000.)

let _ =
  let args = Array.to_list (Array.init 10_000_000 (fun i -> i)) in
  let a = 0 in
  let (g1,g2,g3) = m a in
  let f g = ();
    fun () ->
      let x = List.fold_left g 1 args in
      ()
  in
  let t = time (f g1) in
  Printf.printf "g1 : %d ms\n%!" t;
  let t = time (f g2) in
  Printf.printf "g2 : %d ms\n%!" t;
  let t = time (f g3) in
  Printf.printf "g3 : %d ms\n%!" t;

(* amd64:
g1 : 75 ms
g2 : 127 ms
g3 : 46 ms
*)

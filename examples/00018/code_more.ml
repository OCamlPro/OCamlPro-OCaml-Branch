(*
Inlining:
 - In main1, protect1 is not inlined, because it contains a reference
to a constant string, and the compiler prevents inlining when
there are potential duplication of structured constants.
- In main2, protect2 is inlined, but not the argument function. First order
arguments are never inlined, and some optimisations are clearly missed.

*)

let protect1 s f =
  try f () with e ->
    Printf.eprintf "Uncaught exception in %s: %s\n%!" s (Printexc.to_string e);
    exit 2

let main1 x =
  protect1 "main1" (fun () -> x + 1)

let msg = Obj.magic "Uncaught exception in %s: %s\n%!"
let protect2 s f =
      try f () with e ->
	Printf.eprintf msg s (Printexc.to_string e);
	exit 2

let main2 x =
  protect2 "main2" (fun () -> x + 1)

let make_main protect x =
  protect "make_main" (fun () -> x + 1)

let main3 = make_main protect2

(*
-drawlambda

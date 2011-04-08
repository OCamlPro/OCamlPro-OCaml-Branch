(* This example will generate a stack overflow if the first 'f' is
   called, and a core dump if the second 'f' is called. As the assembly
   code shows, there are no tests performed at runtime, stack overflow is
   detected by catching the SEGV signal, and checking if the current PC
   is in OCaml assembly code (i.e. within caml_code_area_start and
   caml_code_area_stop (TODO: what about dynamically loaded code ?)).

   The best way to perform complete stack overflow detection would be to
   add a flag to "external" to check if enough space is available on the
   stack before the call to C code (and raise stack overflow if
   not).

   It could also be useful to put some C segments which are known to be
   "safe" in the same area as OCaml code.

  Note that it would be quite tedious to fix the behavior here, as a
  stack overflow happening within the memory allocator could lead to
  memory corruption if an exception is raised without fixing the
  current state. A solution would be to have a check of stack
  everytime allocation is performed.

   Are there recursive C functions in the runtime, especially in the
   garbage collector ?

*)


let rec f x =
  1 + f (x+1)

let rec f x =
  let s = String.create 10 in
  1 + f (x+1)

let _ =
  f 0


open Externals

let f int float string () =
  (int = 1) && (float = 3.0) && (String.length string = 10)

let f1 = f 1
let f2 = f 1 (1.0 +. 2.0)
let f3 = f 1 3.0 "0123456789"

let _ =
  assert (f 1 3.0 "abcdefghij" ());
  assert (f1 3.0 "abcdefghij" ());
  assert (f2 "abcdefghij" ());
  assert (f3 ());
  exit_ok ()

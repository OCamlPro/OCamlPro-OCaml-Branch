let _ = print_string "begin B"; print_newline ()

module Y = struct

  let x = X.create "B.Y"

end

module Lib = Make_a.Make(Y)
open Lib
open A

let x = create "new" (X.create "B.x")
let s = A.to_string x

let u = Uvw.U.u
let v = Uvw.V.v
let w = Uvw.W.w

let _ = Printf.printf "u=%s, v=%s, w=%s\n%!" u v w

let _ = print_string "end B"; print_newline ()

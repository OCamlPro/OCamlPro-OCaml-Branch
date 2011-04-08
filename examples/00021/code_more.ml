module Code1 = struct

let option f x =
  match x with
      None -> ()
    | Some y -> f y

end
(*
-drawlambda
/bin/sh: ../local/bin/ocamlopt: not found

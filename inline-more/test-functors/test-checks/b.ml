let _ = print_string "begin B"; print_newline ()

module Y = struct

  let x = X.create ()

end

open A

let x = create "new" (X.create ())
let s = A.to_string x

let _ = print_string "end B"; print_newline ()

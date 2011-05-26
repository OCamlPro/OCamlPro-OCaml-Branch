let _ = print_string "begin A"; print_newline ()

type t = {
  name : string;
  v : X.t;
}

let create name v = { name; v }
let to_string t = X.to_string t.v

let _ = print_string "end A"; print_newline ()

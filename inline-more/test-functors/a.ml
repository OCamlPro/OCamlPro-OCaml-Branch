

type t = {
  name : string;
  v : X.t;
}

let create name v = { name; v }
let to_string t = X.to_string t.v

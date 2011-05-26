module Make(X : sig
#0 "arguments/x.mli"

type t

val create : unit -> t
val to_string : t -> string

end)
 = struct
module A: sig
#0 "a.mli"


type t
val create : string -> X.t -> t
val to_string : t -> string
end = struct
#0 "a.ml"


type t = {
  name : string;
  v : X.t;
}

let create name v = { name; v }
let to_string t = X.to_string t.v
end
module B = struct
#0 "b.ml"

open A

let x = create "new" (X.create ())
let s = A.to_string x
end

end

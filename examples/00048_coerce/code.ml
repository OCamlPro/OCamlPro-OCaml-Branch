

let g (x,y) = x+y
let f x = g (x,x)

module M : sig

  val f : int -> int

end  = struct

  let g (x,y) = x+y
  let f x = g (x,x)

end

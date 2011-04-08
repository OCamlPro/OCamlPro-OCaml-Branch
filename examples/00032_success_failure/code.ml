type w = A | B | C

module Make(M : sig
		  val a : int
		  val b : int
		  val c : int
		  val ext1 : int -> int -> unit
		  val ext2 : int -> int -> unit
		end) =
struct
  open M

  let f1 w x =
    let success y = ext1 x y  in
    let failure z = ext2 x z in
      match w with
	| A -> success a
	| B -> failure b
	| C -> failure c

  let f2 w x =
    let v =
      match w with
	| A -> `Success a
	| B -> `Failure b
	| C -> `Failure c
    in
      match v with
	| `Success y -> ext1 x y
	| `Failure z -> ext2 x z
end

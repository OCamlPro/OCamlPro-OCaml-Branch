(* It looks like, since the coercion applied to M1 is equivalent to
the string [s] is never disallocated ! *)

module M1 : sig

  val x : unit

end  = struct

  let x = ()
  let s = String.create 1_000_000_000

end

module M2 : sig

  val x : unit

end  = struct

  let s = String.create 1_000_000_000
  let x = ()

end


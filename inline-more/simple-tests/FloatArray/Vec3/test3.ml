open Externals

module Vec3 =
struct
    type t =
    {
        mutable x : float;
        mutable y : float;
        mutable z : float;
        w : int
    }
    let create x y z = { x; y; z; w=1 }
    let add a b = (a.x <- a.x +. b.x; a.y <- a.y +. b.y; a.z <- a.z +. b.z)
end;;

let _ =
  let incr = float_of_int 3 in
  let array = Array.init 10_000_000 (fun _ -> Vec3.create 0. 0. 0.) in
  let added = Vec3.create incr incr incr in
  for i = 0 to 10_000_000-1 do
    Vec3.add array.(i) added
  done

open Externals

module Vec3 =
struct
    type t =
    {
        x : float; (* floats are 63 bits long *)
        y : float;
        z : float
    }
    let create x y z = { x; y; z }
    let add a b = { x = a.x +. b.x; y = a.y +. b.y; z = a.z +. b.z }
end;;

let _ =
  let incr = float_of_int 3 in
  let array = Array.init 10_000_000 (fun _ -> Vec3.create 0. 0. 0.) in
  let added = Vec3.create incr incr incr in
  for i = 0 to 10_000_000-1 do
    array.(i) <- Vec3.add array.(i) added
  done

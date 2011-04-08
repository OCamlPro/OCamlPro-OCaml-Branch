let delta = sqrt epsilon_float
type vec = {x:float; y:float; z:float}
let zero = {x=0.; y=0.; z=0.}
let ( *| ) s r = {x = s *. r.x; y = s *. r.y; z = s *. r.z}
let ( +| ) a b = {x = a.x +. b.x; y = a.y +. b.y; z = a.z +. b.z}
let ( -| ) a b = {x = a.x -. b.x; y = a.y -. b.y; z = a.z -. b.z}
let dot a b = a.x *. b.x +. a.y *. b.y +. a.z *. b.z
let unitise r = (1. /. sqrt (dot r r)) *| r and length r = sqrt(dot r r)
let ray_sphere dir v radius =
  let b = dot v dir in
  let disc = b *. b -. dot v v +. radius *. radius in
  if disc < 0. then infinity else
    let disc = sqrt disc in
    (fun t2 -> if t2 < 0. then infinity else
       ((fun t1 -> if t1 > 0. then t1 else t2) (b -. disc))) (b +. disc)
let ray_sphere' orig dir center radius =
  let v = center -| orig in
  let b = dot v dir in
  let disc = b *. b -. dot v v +. radius *. radius in
  disc >= 0. && b +. sqrt disc >= 0.
let rec intersect dir ((l, _) as first) (center, radius, scene) =
  let l' = ray_sphere dir center radius in
  if l' >= l then first else match scene with
    [] -> l', unitise (l' *| dir -| center)
  | scenes -> intersects dir first scenes
and intersects dir hit = function
    [] -> hit
  | h::t -> intersects dir (intersect dir hit h) t
let rec intersect' orig dir (center, radius, scenes) =
  ray_sphere' orig dir center radius &&
    (scenes=[] || List.exists (intersect' orig dir) scenes)
let rec ray_trace light dir scene =
  match intersect dir (infinity, zero) scene with
    0., _ -> infinity
  | lambda, normal ->
      let g = dot normal light in
      if g >= 0. then 0. else
	let p = lambda *| dir +| delta *| normal in
	if intersect' p (-1. *| light) scene then 0. else -. g
let rec bound (c, r, s as b) = function
    c', r', [] -> (c, max r (length (c -| c') +. r'), s)
  | _, _, l -> List.fold_left bound b l
let rec create level c r =
  let obj = c, r, [] in
  if level = 1 then obj else
    let a = 3. *. r /. sqrt 12. in
    let aux x' z' = create (level - 1) (c +| {x=x'; y=a; z=z'}) (0.5 *. r) in
    let l = [obj; aux (-.a) (-.a); aux a (-.a); aux (-.a) a; aux a a] in
    List.fold_left bound (c +| {x=0.; y=r; z=0.}, 0., l) l
let level, n =
  try int_of_string Sys.argv.(1), int_of_string Sys.argv.(2) with _ -> 9, 512
let () =
  let scene = create level { x = 0.; y = -1.; z = 4. } 1. in
  let light = unitise {x= -1.; y= -3.; z=2.} and ss = 4 in
  Printf.printf "P5\n%d %d\n255\n%!" n n;
  for y = n - 1 downto 0 do
    for x = 0 to n - 1 do
      let g = ref 0. in
      for dx = 0 to ss - 1 do
	for dy = 0 to ss - 1 do
	  let aux x d = float x -. float n /. 2. +. float d /. float ss in
	  let dir = unitise {x = aux x dx; y = aux y dy; z = float n} in
	  g := !g +. ray_trace light dir scene
	done
      done;
      let g = 0.5 +. 255. *. !g /. float (ss*ss) in
      output_char stdout (char_of_int (int_of_float g))
    done
  done

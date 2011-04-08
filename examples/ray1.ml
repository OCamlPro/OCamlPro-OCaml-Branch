let zero = 0., 0., 0.
let ( *| ) s (rx, ry, rz) = s *. rx, s *. ry, s *. rz
let ( +| ) (ax, ay, az) (bx, by, bz) = ax +. bx, ay +. by, az +. bz
let ( -| ) (ax, ay, az) (bx, by, bz) = ax -. bx, ay -. by, az -. bz
let dot (ax, ay, az) (bx, by, bz) = ax *. bx +. ay *. by +. az *. bz
let unitise r = 1. /. sqrt (dot r r) *| r

let rec intersect o d (l, _ as hit) (c, r, s) =
  let v = c -| o in
  let b = dot v d in
  let disc = sqrt(b *. b -. dot v v +. r *. r) in
  let t1 = b -. disc and t2 = b +. disc in
  let l' = if t2>0. then if t1>0. then t1 else t2 else infinity in
  if l' >= l then hit else match s with
    [] -> l', unitise (o +| l' *| d -| c)
  | ss -> List.fold_left (intersect o d) hit ss

let light = unitise (1., 3., -2.) and ss = 4

let rec create level c r =
  let obj = c, r, [] in
  if level = 1 then obj else
    let a = 3. *. r /. sqrt 12. in
    let aux x' z' = create (level - 1) (c +| (x', a, z')) (0.5 *. r) in
    c, 3.*.r, [obj; aux (-.a) (-.a); aux a (-.a); aux (-.a) a; aux a a]

let level, n =
  try int_of_string Sys.argv.(1), int_of_string Sys.argv.(2) with _ -> 9, 512

let scene = create level (0., -1., 4.) 1.

let rec ray_trace dir =
  let l, n = intersect zero dir (infinity, zero) scene in
  let g = dot n light in
  if g <= 0. then 0. else
    let p = l *| dir +| sqrt epsilon_float *| n in
    if fst(intersect p light (infinity, zero) scene) < infinity then 0. else g

let aux x d = float x -. float n /. 2. +. float d /. float ss;;
Printf.printf "P5\n%d %d\n255\n%!" n n;
for y = n - 1 downto 0 do
  for x = 0 to n - 1 do
    let g = ref 0. in
    for d = 0 to ss*ss - 1 do
      g := !g +. ray_trace(unitise(aux x (d mod ss), aux y (d/ss), float n))
    done;
    let g = 0.5 +. 255. *. !g /. float(ss*ss) in
    print_char(char_of_int(int_of_float g))
  done;
done

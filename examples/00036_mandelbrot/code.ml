  
  
let runs = 100
let max_iterations = 1000

let iterate ci cr =
  let bailout = 4.0 in
  let rec loop zi zr i =
    if i > max_iterations then
      0
    else
      let temp = zr *. zi and
	  zr2 = zr *. zr and
	  zi2 = zi *. zi in
	if zi2 +. zr2 > bailout then
	  i
	else
	  loop (temp +. temp +. ci) (zr2 -. zi2 +. cr) (i + 1)
  in
    loop 0.0 0.0 1

let mandelbrot n =
  for y = -39 to 38 do
    if 1 = n then print_endline "";
    for x = -39 to 38 do
      let i = iterate
          (float x /. 40.0) (float y /. 40.0 -. 0.5) in
      if 1 = n then
        print_string ( if 0 = i then "*" else " " );
    done
  done;;

let _ =
  let start_time = Sys.time () in
  for iter = 1 to runs do
    mandelbrot iter
  done;
  print_endline "";
  print_float ( Sys.time () -. start_time );
  print_endline "";

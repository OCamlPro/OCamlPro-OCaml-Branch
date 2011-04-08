(*
 * The Computer Language Benchmarks Game
 * http://shootout.alioth.debian.org/
 *
 * Contributed by Christophe TROESTLER
 * Enhanced by Christian Szegedy, Yaron Minsky
 *
 *)

let niter = 50
let limit = 2.

let limit2 = limit *. limit

type complex = { mutable r: float; mutable i: float }

let () =
  let w = int_of_string(Array.get Sys.argv 1) in
  let h = w in
  let fw = float w
  and fh = float h in
  Printf.printf "P4\n%i %i\n" w h;
  let c = { r = 0.; i=0.} and z = {r=0.; i=0.;} in
  let byte = ref 0 in
  for y = 0 to h - 1 do
    c.i <- 2. *. float y /. fh -. 1.;
    for x = 0 to w - 1 do
      c.r <- 2. *. float x /. fw -. 1.5;
      z.r <- 0.; z.i <- 0.;
      begin
	try
	  for i = 1 to niter do
	    let zi = 2. *. z.r *. z.i +. c.i in
	    z.r <- z.r *. z.r -. z.i *. z.i +. c.r;
	    z.i <- zi;
	    if z.r *. z.r +. zi *. zi > limit2 then raise Exit;
	  done; byte := (!byte lsl 1) lor 0x01
	with Exit -> byte := !byte lsl 1 (* lor 0x00 *);
      end;
      if x mod 8 = 7 then output_byte stdout !byte;
    done;
    if w mod 8 != 0 then (* the row doesnt divide evenly by 8*)
      output_byte stdout (!byte lsl (8-w mod 8)); (* output last few bits *)
    byte := 0;
  done

(*
u32:
 N  	CPU secs 	Elapsed secs 	Memory KB 	Code B 	≈ CPU Load
1,000	0.42	0.42	824	444	  0% 0% 0% 100%
4,000	6.51	6.51	820	444	  0% 0% 1% 100%
16,000	103.73	103.73	824	444	  0% 0% 0% 100%
*)

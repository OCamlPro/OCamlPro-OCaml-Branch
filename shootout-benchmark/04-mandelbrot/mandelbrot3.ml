(*
 * The Computer Language Benchmarks Game
 * http://shootout.alioth.debian.org/
 *
 * Contributed by Christophe TROESTLER
 * Enhanced by Christian Szegedy, Yaron Minsky.
 * Optimized & parallelized by Mauricio Fernandez.
 * Optimized by Fabrice Le Fessant:
 *  - removed redundant allocations (z)
 *  - monomorphisation of invoke
 *
 *)

let nworkers = 1
let niter = 50
let limit = 2.

type z = {
  mutable tr : float;
  mutable ti : float;
  mutable zr : float;
  mutable zi : float;
  mutable cr : float;
  mutable ci : float;
  limit2 : float;
}


	  let nargs = Array.length Sys.argv
  let default_w = 16_000
  let w = if nargs <> 2 then default_w else try int_of_string(Array.get Sys.argv 1) with _ -> default_w
  let h = w
  let fw = float w
  let fh = float h
  let limit2 = limit *. limit
  let byte = ref 0
  let b = String.create ((w+7) / 8 * (h/nworkers + nworkers))
  let fi = 2. /. fh
  let fr = 2. /. fw
  let pos = ref 0
  let z = { zr = 0.; zi = 0.; tr = 0.; ti = 0.; cr = 0.; ci = 0.; limit2 = limit2; }

(*
  let rec iter_i i z =
    if i = 0 then 1 else
      let ci = z.ci in
      let cr = z.cr in
      let zi2 = 2. *. z.zr *. z.zi +. ci in
      let zr2 = z.tr -. z.ti +. cr in
      let tr2 = zr2 *. zr2 in
      let ti2 = zi2 *. zi2 in
      let limit2 = z.limit2 in
        if tr2 +. ti2 > limit2 then 0 else
	  if i = 1 then 1 else
	    let zi3 = 2. *. zr2 *. zi2 +. ci in
	    let zr3 = tr2 -. ti2 +. cr in
	    let tr3 = zr3 *. zr3 in
	    let ti3 = zi3 *. zi3 in
	      if tr3 +. ti3 > limit2 then 0 else
		if i = 2 then 1 else
			begin
			  z.zr <- zr3;
			  z.zi <- zi3;
			  z.tr <- tr3;
			  z.ti <- ti3;
			  iter_i (i-2) z
			end
*)

(*
  let rec iter_32 i z =
    if i = 0 then 1 else
      let ci = z.ci in
      let cr = z.cr in
      let zi2 = 2. *. z.zr *. z.zi +. ci in
      let zr2 =  z.zr *. z.zr  -. z.zi *. z.zi +. cr in
	z.zr <- zr2;
	z.zi <- zi2;
	Printf.fprintf stderr "z = (%.8f,%.8f)\n%!" z.zr z.zi;
      let tr2 = z.zr *. z.zr in
      let ti2 = z.zi *. z.zi in
      let limit2 = z.limit2 in
        if tr2 +. ti2 > limit2 then 0 else
	  if i = 1 then 1 else
	    begin
	      iter_32 (i-1) z
	    end
*)

  let rec iter_64 i z =
    if i = 0 then 1 else
      let ci = z.ci in
      let cr = z.cr in
      let zi2 = 2. *. z.zr *. z.zi +. ci in
      let zr2 = z.tr -. z.ti +. cr in
(*	Printf.fprintf stderr "z = (%.8f,%.8f)\n%!" zr2 zi2; *)
      let tr2 = zr2 *. zr2 in
      let ti2 = zi2 *. zi2 in
      let limit2 = z.limit2 in
        if tr2 +. ti2 > limit2 then 0 else
	  if i = 1 then 1 else
	    begin
	      z.zr <- zr2;
	      z.zi <- zi2;
	      z.tr <- tr2;
	      z.ti <- ti2;
	      iter_64 (i-1) z
	    end


  let crs = Array.init w (fun x -> fr *. float x -. 1.5)
  let need_more = w land 7 != 0
  let offset = 8-w land 7

  let mandelbrot_32 ymin ymax =
    for y = ymin to ymax do
      z.ci <- (2. *. float y /. fh -. 1.);
      for x = 0 to w - 1 do
	z.cr <- 2. *. float x /. fw -. 1.5;
	z.zr <- 0.;
	z.zi <- 0.;
	z.tr <- 0.;
	z.ti <- 0.;
	let bit = iter_64 niter z in
(*	  Printf.fprintf stderr "bit[%d] = %d (%.8f,%.8f)\n%!" x bit z.cr z.ci; *)
          byte := (!byte lsl 1) lor bit;
          if x land 7 = 7 then begin
	    b.[!pos] <-  (Char.unsafe_chr !byte);
	    incr pos
	  end
      done;
      if need_more then (* the row doesnt divide evenly by 8*)
	begin
	  b.[!pos] <-  (Char.unsafe_chr (!byte lsl offset));
	  incr pos;
	end;
      byte := 0;
    done

  let mandelbrot_64 ymin ymax =
    for y = ymin to ymax do
      z.ci <- (fi *. float y -. 1.);
      for x = 0 to w - 1 do
	z.cr <- crs.(x);
	z.zr <- 0.;
	z.zi <- 0.;
	z.tr <- 0.;
	z.ti <- 0.;
	let bit = iter_64 niter z in
(*	  Printf.fprintf stderr "bit[%d] = %d (%f,%f)\n%!" x bit z.cr z.ci; *)
          byte := (!byte lsl 1) lor bit;
          if x land 7 = 7 then begin
	    b.[!pos] <-  (Char.unsafe_chr !byte);
	    incr pos
	  end
      done;
      if need_more then (* the row doesnt divide evenly by 8*)
	begin
	  b.[!pos] <-  (Char.unsafe_chr (!byte lsl offset));
	  incr pos;
	end;
      byte := 0;
    done

  let mandelbrot ymin ymax =

    match Sys.word_size with
	32 -> mandelbrot_32 ymin ymax
      | 64 -> mandelbrot_64 ymin ymax
      | _ -> assert false

let dy = h / nworkers

(* semi-standard function for parallelism *)
let invoke (ymin, ymax) : unit -> 'b =
  let expected_size  = ( (w+1) / 8 + if w land 7 <> 0 then 1 else 0) * (ymax - ymin + 1) in
  let input, out = Unix.pipe() in
  match Unix.fork() with
  | -1 -> assert false
  | 0 ->
      Unix.close input;
      mandelbrot ymin ymax;
      let out = Unix.out_channel_of_descr out in
	output out b 0 expected_size;
        close_out out;
        exit 0
  | pid ->
      Unix.close out;
      let input = Unix.in_channel_of_descr input in
	fun () ->
	  really_input input b 0 expected_size;
	  expected_size

  let _ =

    let y = ref 0 in
    let rs = Array.init (nworkers - 1)
      (fun _ ->
	 let y'= !y + dy in
	 let r = (!y, y'-1) in
	   y := y';
	   r) in
    let workers = Array.map invoke (Array.append rs [|!y, h-1|]) in
      Printf.printf "P4\n%i %i\n" w h;
      Array.iter (fun w ->
		    let expected_size = w () in
		    output stdout b 0 expected_size) workers

(*

u32:

u32q:
1,000	0.00	0.32	3,324	1161	  88% 94% 100% 91%
4,000	0.01	4.73	7,892	1161	  97% 96% 98% 100%
16,000	0.08	55.23	31,748	1161	  99% 97% 99% 98%
*)

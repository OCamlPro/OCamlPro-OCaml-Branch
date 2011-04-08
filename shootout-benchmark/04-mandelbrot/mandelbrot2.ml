(*
 * The Computer Language Benchmarks Game
 * http://shootout.alioth.debian.org/
 *
 * Contributed by Christophe TROESTLER
 * Enhanced by Christian Szegedy, Yaron Minsky.
 * Optimized & parallelized by Mauricio Fernandez.
 * Optimized by Fabrice Le Fessant:
 *  - each thread is responsible of printing his output
 *
 *)
let arch64 =
  match Sys.word_size with
      32 -> false
    | 64 -> true
    | _ -> assert false

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
  let fi = 2. /. fh
  let fr = 2. /. fw
  let z = { zr = 0.; zi = 0.; tr = 0.; ti = 0.; cr = 0.; ci = 0.; limit2 = limit2; }

  let rec iter i z =
    if i = 0 then
      byte := (!byte lsl 1) lor 1
    else
      let ci = z.ci in
      let cr = z.cr in
      let zi2 = 2. *. z.zr *. z.zi +. ci in
      let zr2 = z.tr -. z.ti +. cr in
      let tr2 = zr2 *. zr2 in
      let ti2 = zi2 *. zi2 in
      let limit2 = z.limit2 in
        if tr2 +. ti2 > limit2 then
	  byte := (!byte lsl 1)
	else
	  if i = 1 then
	    byte := (!byte lsl 1) lor 1
	  else
	    begin
	      z.zr <- zr2;
	      z.zi <- zi2;
	      z.tr <- tr2;
	      z.ti <- ti2;
	      iter (i-1) z
	    end

  let crs =
    if arch64 then
      Array.init w (fun x -> fr *. float x -. 1.5)
    else
      Array.init w (fun x -> 2. *. float x /. fw -. 1.5)

  let need_more = w land 7 != 0
  let offset = 8-w land 7


  let dy = (h+nworkers-1) / nworkers


  let b = String.create ((w+7) / 8 * (h/nworkers + nworkers))
  let bpos = ref 0
  let add_byte c =
    b.[!bpos] <- Char.unsafe_chr c; incr bpos

  let mandelbrot ymin ymax =
    for y = ymin to ymax do
      z.ci <- (fi *. float y -. 1.);
      for x = 0 to w - 1 do
	z.cr <- crs.(x);
	z.zr <- 0.;
	z.zi <- 0.;
	z.tr <- 0.;
	z.ti <- 0.;
	iter niter z;
          if x land 7 = 7 then
	    add_byte  !byte;
      done;
      if need_more then (* the row doesnt divide evenly by 8*)
	add_byte (!byte lsl offset);
      byte := 0;
    done

  let wait_for = ref None

  let s = String.create 1
  let do_wait () =
    match !wait_for with
	None -> ()
      | Some ic ->
	  ignore (Unix.read ic s 0 1);
	  wait_for := None

  let rec really_print buffer i len =
    if len > 0 then
      let nw = Unix.write Unix.stdout buffer i  len in
	really_print buffer (i+nw) (len-nw)

  let print () =
    really_print b 0 !bpos

(* semi-standard function for parallelism *)
  let invoke ymin ymax =
    let input, out = Unix.pipe() in
      match Unix.fork() with
	| -1 -> assert false
	| 0 ->
	    Unix.close input;
	    mandelbrot ymin ymax;
	    do_wait ();
	    print ();
	    ignore (Unix.write out "X" 0 1);
            Unix.close out;
            exit 0
	| pid ->
	    Unix.close out;
	    wait_for := Some input

  let _ =
    let header = Printf.sprintf "P4\n%i %i\n" w h in
      really_print header 0 (String.length header);
    let rec iter y =
      let y'= y + dy in
	if y' >= h then begin
	    mandelbrot y (h-1);
	    do_wait ();
	    print ()
	end else begin
	    invoke y (y'-1);
	    iter y'
	end
    in
      iter 0

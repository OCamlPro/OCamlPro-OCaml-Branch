(* The Computer Language Shootout
   http://shootout.alioth.debian.org/

   contributed by Ingo Bormuth <ibormuth@efil.de>
   optimized by Fabrice Le Fessant
*)

(* to optimize: we need to wait for a better handling of shared memory in OCaml. *)

let verbose = false

let rec print_args list =
  match list with
      [] -> ()
    | x :: tail ->
	Printf.fprintf stderr " %d" x;
	print_args tail

let enter name list =
  if verbose then begin
    Printf.fprintf stderr "%s:" name;
    print_args list;
    Printf.fprintf stderr "\n%!"
  end

let arch64 =
  match Sys.word_size with
      32 -> false
    | 64 -> true
    | _ -> assert false


module LineReader : sig

  (* read all non empty lines *)
  val read :
    (* from : *) Unix.file_descr ->
    (* max_line_length : *) int ->
    (* handler : *) (string -> int -> int -> unit) -> unit

end = struct

  let read ic maxlen handler =
    let s = String.create maxlen in

    let rec iter begin_pos pos =
      let to_read = maxlen - pos in
	if to_read < 32000 then begin
	  let len = pos - begin_pos in
	    String.blit s begin_pos s 0 len;
	    iter 0 len
	end else
	  let nread = Unix.read ic s pos to_read in
	if nread = 0 then raise End_of_file;
	let end_pos = pos + nread in
	iter2 begin_pos pos end_pos

    and iter2 begin_pos pos end_pos =
      if pos = end_pos then
	iter begin_pos end_pos
      else
	match s.[pos] with
	    '\n' | '\r' ->
	      if pos > begin_pos then
		handler s begin_pos (pos - begin_pos);
	      iter2 (pos+1) (pos+1) end_pos
	  | _ ->
	      iter2 begin_pos (pos+1) end_pos

    in
      iter 0 0

end

let t = String.make 256 ' '
let b = String.make 61 '\n'
let bi = ref 1
let _ =
  String.blit "TVGHEFCDIJMLKNOPQYSAABWXRZ" 0 t 65 26;
  String.blit t 65 t 97 26
;;

let t =
  let s = Array.create 256 ' ' in
    for i = 0 to 255 do
      s.(i) <- t.[i]
    done;
    s
;;

module Fasta : sig

  val clear : unit -> unit
  val flush : unit -> unit
  val print : string -> int -> int -> unit

end = struct

  let printed = ref 0

  let clear () = printed := 0
  let flush () =
    if !printed > 0 then print_newline ();
    printed := 0

  let rec print s pos len =
    if len > 60 then begin
      output stdout s pos 60;
      output_char stdout '\n';
      print s (pos + 60) (len-60)
    end else
      if len > 0 then
	begin
	  output stdout s pos len;
	  printed := len
	end

  let print s pos len =
    let to_print = 60 - !printed in
      if len < to_print then begin
	output stdout s pos len;
	printed := !printed + len
      end else begin
	output stdout s pos to_print;
	output_char stdout '\n';
	printed := 0;
	print s (pos + to_print) (len - to_print);
      end

end

module IMPLEMENTATION32 : sig
  val main : unit -> unit
end = struct

module BigRevBuffer : sig

  val clear : unit -> unit
  val length : unit -> int
  val add : string -> int -> int -> unit
(*  val iter : (string -> int -> int -> unit) -> unit *)
  val reverse_iter : unit -> unit

end = struct

(* don't allocate any buffers on x64 *)
  let nbuffers = if arch64 then 0 else 256


  let buffer_len = 1_000_000

  let buffers = Array.init nbuffers (fun _ -> String.create buffer_len)
  let buffer_pos = Array.create nbuffers buffer_len
  let last_buffer = ref 0

  let clear () =
    last_buffer := 0;
    for i = 0 to 255 do
      buffer_pos.(i) <- buffer_len;
    done

  let length () =
    !last_buffer * buffer_len + (buffer_len - buffer_pos.(!last_buffer))

  let rec blit_rev src end_pos dst dpos len =
    if len > 0 then begin
      dst.[dpos] <- t.(Char.code  src.[end_pos]);
      blit_rev src (end_pos-1) dst (dpos+1) (len-1)
    end

  let blit_rev src spos dst dpos len =
    let end_pos = spos + len - 1 in
    blit_rev src end_pos dst dpos len

  let rec add s pos len =
    if len > 0 then
      let b = buffers.(!last_buffer) in
      let bpos = buffer_pos.(!last_buffer) in
	if bpos > len then begin
	  let new_pos = bpos - len in
	    blit_rev s pos b new_pos len;
	    buffer_pos.(!last_buffer) <- new_pos
	end else begin
	  blit_rev s pos b 0 bpos;
	  buffer_pos.(!last_buffer) <- 0;
	  incr last_buffer;
	  add s (pos + bpos) (len - bpos)
	end

(*

  let iter f =
    let rec iter f i last_buffer =
      if i < last_buffer then begin
	f  buffers.(i) 0 buffer_len;
	iter f (i+1) last_buffer
      end
      else
	let pos = buffer_pos.(last_buffer) in
	  f buffers.(last_buffer) pos (buffer_len - pos)
    in
      iter f 0 !last_buffer

  let rev_iter f =
    let rec iter f i =
      if i >= 0 then begin
	f  buffers.(i) 0 buffer_len;
	iter f (i-1)
      end
    in
    let pos = buffer_pos.(!last_buffer) in
      f buffers.(!last_buffer) pos (buffer_len - pos);
      iter f (!last_buffer-1)
*)

  let reverse_iter f =
    let rec iter i =
      if i >= 0 then begin
	Fasta.print  buffers.(i) 0 buffer_len;
	iter (i-1)
      end
    in
    let pos = buffer_pos.(!last_buffer) in
      if pos < buffer_len then
	Fasta.print buffers.(!last_buffer) pos (buffer_len - pos);
      iter (!last_buffer-1)

end

let reverse () =
  if BigRevBuffer.length () > 0 then begin
    Fasta.clear ();
    BigRevBuffer.reverse_iter ();
    BigRevBuffer.clear ();
    Fasta.flush ()
  end

let main () =
  try
    LineReader.read Unix.stdin 1_000_000
      (fun s pos len ->
	 if s.[pos] = '>' then begin
	   reverse ();
	   output stdout s pos len;
	   output_char stdout '\n';
	 end else
	   BigRevBuffer.add s pos len
      )
  with End_of_file -> reverse ()
    | e ->
	Printf.fprintf stderr "exception %s\n%!" (Printexc.to_string e);
	exit 2

end

module IMPLEMENTATION64 : sig

  val main : unit -> unit

end = struct

  let buffer_len = 150_000_000

  let buffer = if arch64 then String.create buffer_len else ""
  let buffer_pos = ref buffer_len

  let wait_for = ref None

  let reverse () =
    begin
      match !wait_for with
	  None -> ()
	| Some ix ->
	    let s = String.create 1 in
	    ignore (Unix.read ix s 0 1)
    end;
    let len = buffer_len - !buffer_pos in
      if len > 0 then begin
	Fasta.clear ();
	Fasta.print buffer !buffer_pos len;
	Fasta.flush ();
	buffer_pos := buffer_len;
      end

    let maxlen = 10_000_000
    let inbuf = String.create maxlen

let rec iter1 begin_pos () pos =
  let to_read = maxlen - pos in
    if to_read < 32_000 then begin
      let len = pos - begin_pos in
	String.blit inbuf begin_pos inbuf 0 len;
	iter1 0 () len
    end else
      let nread = Unix.read Unix.stdin inbuf pos to_read in
	if nread = 0 then raise End_of_file;
	let end_pos = pos + nread in
	  iter2 begin_pos pos end_pos

and iter2 begin_pos pos end_pos =
  if pos = end_pos then
    iter1 begin_pos () end_pos
  else
    match inbuf.[pos] with
	'\n' ->
	  iter2 (pos+1) (pos+1) end_pos
      | '>' ->
	  iter4 begin_pos (pos+1) end_pos
      | c ->
	  let c = t.(Char.code c) in
	    decr buffer_pos;
	    buffer.[!buffer_pos] <- c;
	    iter2 begin_pos (pos+1) end_pos

and iter3 begin_pos () pos =
  let to_read = maxlen - pos in
    if to_read < 32000 then begin
      let len = pos - begin_pos in
	String.blit inbuf begin_pos inbuf 0 len;
	iter3 0 () len
    end else
      let nread = Unix.read Unix.stdin inbuf pos to_read in
	if nread = 0 then raise End_of_file;
	let end_pos = pos + nread in
	  iter4 begin_pos pos end_pos

and iter4 begin_pos pos end_pos =
  if pos = end_pos then
    iter3 begin_pos () end_pos
  else
    match inbuf.[pos] with
	'\n' | '\r' ->
	  if pos > begin_pos then begin
	    if !buffer_pos < buffer_len then begin
	      let (ix, ox) = Unix.pipe () in
		match Unix.fork () with
		  | -1 -> assert false
		  | 0 ->
		      reverse ();
		      output stdout inbuf begin_pos (pos - begin_pos);
		      output_char stdout '\n';
		      ignore (Unix.write ox "X" 0 1);
		      Unix.close ox;
		      exit 0;
		  | _ ->
		      wait_for := Some ix;
		      buffer_pos := buffer_len;
	    end else begin
	      output stdout inbuf begin_pos (pos - begin_pos);
	      output_char stdout '\n';
	      flush stdout;
	    end
	  end;
	  iter2 (pos+1) (pos+1) end_pos
      | _ ->
	  iter4 begin_pos (pos+1) end_pos

let read () =
    iter1 0 () 0

let main () =
  enter "main64" [];
  try
    read ()
  with End_of_file -> reverse ()
    | e ->
	Printf.fprintf stderr "exception %s\n%!" (Printexc.to_string e);
	exit 2

end

let _ =
  if arch64 then
    IMPLEMENTATION64.main ()
  else
    IMPLEMENTATION32.main ()

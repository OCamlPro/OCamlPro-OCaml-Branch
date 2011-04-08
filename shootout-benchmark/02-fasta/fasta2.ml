(* The Computer Language Benchmarks Game
 * http://shootout.alioth.debian.org/
 *
 * contributed by Troestler Christophe
 * modified by Mauricio Fernandez

 * modified by Fabrice Le Fessant (submitted as Ocaml #4)
    * speedup from 16.65sec to 4.31sec on x64
    * distinct implementation on 32bits and 64bits
    * cache of random generator
    * parallelization

 * modified by Fabrice Le Fessant
    * use chunks for random too
 *)

let arch64 =
  match Sys.word_size with
      32 -> false
    | 64 -> true
    | _ -> assert false

module Spawner : sig

  val spawn : bool -> (unit -> unit) -> (unit -> unit) -> unit

 end = struct

let inbuf = String.create 1

let wait_for = ref None
let spawn spawn prelude postlude =
  begin
  end;
  if spawn then begin
    let (ix, ox) = Unix.pipe () in
      match Unix.fork () with
	  -1 -> assert false
	| 0 ->
	    prelude ();
	    begin
	      match !wait_for with
		  None -> ()
		| Some ix ->
		    ignore (Unix.read ix inbuf 0 1)
	    end;
	    postlude ();
	    ignore (Unix.write ox "X" 0 1);
	    Unix.close ox;
	    exit 0
	| _ ->
	    wait_for := Some ix;
  end else begin
    prelude ();
    begin
      match !wait_for with
	  None -> ()
	| Some ix ->
	    ignore (Unix.read ix inbuf 0 1);
    end;
    postlude ();
  end


end

let alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG\
GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA\
CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT\
ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA\
GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG\
AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC\
AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"

let iub = [| ('a', 0.27);  ('c', 0.12);  ('g', 0.12);  ('t', 0.27);
	     ('B', 0.02);  ('D', 0.02);  ('H', 0.02);  ('K', 0.02);
	     ('M', 0.02);  ('N', 0.02);  ('R', 0.02);  ('S', 0.02);
	     ('V', 0.02);  ('W', 0.02);  ('Y', 0.02);  |]

let homosapiens = [| ('a', 0.3029549426680);    ('c', 0.1979883004921);
		     ('g', 0.1975473066391);    ('t', 0.3015094502008);  |]

(* Random number generator *)
let im = 139968
and ia = 3877
and ic = 29573

let last = ref 42 and im_f = float im


let cache =
  let im = 139968
  and ia = 3877
  and ic = 29573 in
  Array.init im  (fun i ->  (i * ia + ic) mod im)

let gen_random  () =
  let n = cache.(!last) in
    last := n;
    n

module Cumul_tbl : sig
   val make : (char * float) array -> string * int array
end =
struct
  type t = { probs : float array;
	     chars : char array;
	     cache : char array; }

(* Dichotomy is actually slower than linear search on small tables. *)
  let find t p =
    let ps = t.probs in
    let i = ref 0 in
      while p >= ps.(!i) do incr i done;
      !i

  let rand_char t =
    let n = gen_random () in
    let c =  t.cache.(n) in
      if c = '\000' then
	let p = 1. *. float n /. im_f in
	let i = find t p in
	  let c = t.chars.(i) in
	    t.cache.(n) <- c;
	    c
      else
	c

  let rand_char2 t =
    let n = gen_random () in
    let c =  t.cache.(n) in
      if c = '\000' then
	let p = 1. *. float n /. im_f in
	let i = find t p in
	  let c = t.chars.(i) in
	    t.cache.(n) <- c;
	    (c,n)
      else
	(c,n)


  let make a =
    let len = Array.length a in
    let chars = Array.create len 'x' in
    let probs = Array.create len 0. in
    let p = ref 0.0 in
      for i = 0 to len-1 do
	let (c, p1) = a.(i) in
	  chars.(i) <- c;
	  let p0 = !p +. p1 in
	    p := p0;
	    probs.(i) <- p0
      done;
      let t =
	{
	  probs = probs;
	  chars = chars;
	  cache = Array.create im '\000';
	}
      in
      let s = String.create im in
      let ns = Array.create im 0 in
	for i = 0 to im-1 do
	  let (c,n) = rand_char2 t in
	    s.[i] <- c;
	    ns.(i) <- n
	done;
	(s, ns)

end

let width = 60

module IMPLEMENTATION32 = struct

module Buffer : sig

  val add_substring : string -> int -> int -> unit
  val add_string : string -> unit
  val add_char : char -> unit

  val clear : unit -> unit
  val print : unit -> unit

end = struct

  let buffer_len = 1_000_000
  let buffers = Array.init 150 (fun _ -> String.create buffer_len)
  let nbuffer = ref 0
  let buffer_pos = ref 0
  let current_buffer = ref buffers.(0)

  let add_substring s pos len =
    let rem = buffer_len - !buffer_pos in
      if rem >= len then begin
	String.blit s pos !current_buffer !buffer_pos len;
	buffer_pos := !buffer_pos + len
      end else
	if rem = 0 then begin
	  incr nbuffer;
	  current_buffer := buffers.(!nbuffer);
	    String.blit s pos !current_buffer 0 len;
	    buffer_pos := len;
	end else begin
	  String.blit s pos !current_buffer !buffer_pos rem;
	  incr nbuffer;
	  current_buffer := buffers.(!nbuffer);
	  let len2 = len - rem in
	    String.blit s (pos+rem) !current_buffer 0 len2;
	    buffer_pos := len2;
	end

  let add_string s =
    add_substring s 0 (String.length s)

  let add_char c =
    if !buffer_pos < buffer_len then begin
       !current_buffer.[!buffer_pos] <- c;
      incr buffer_pos
    end else begin
      incr nbuffer;
      current_buffer := buffers.(!nbuffer);
      !current_buffer.[0] <- c;
      buffer_pos := 1;
    end

  let clear () =
    buffer_pos := 0;
    nbuffer := 0;
    current_buffer := buffers.(0)

  let print () =
    let rec iter buffer i len =
      if len > 0 then begin
	let nw = Unix.write Unix.stdout buffer i  len in
	  iter buffer (i+nw) (len-nw)
      end
    in
      for i = 0 to !nbuffer - 1 do
	iter buffers.(i) 0 buffer_len
      done;
      iter buffers.(!nbuffer) 0 !buffer_pos;
      clear ()

end

let add_header id desc =
  Buffer.add_char '>';
  Buffer.add_string id;
  Buffer.add_char ' ';
  Buffer.add_string desc;
  Buffer.add_char '\n'


let make_random_fasta id desc table n =
  add_header id desc;
  let (s, ns) = Cumul_tbl.make table in
  let curpos = ref 0 in
  let write_cached width =
    let maxlen = im - !curpos in
      if maxlen >= width then begin
	Buffer.add_substring s !curpos width;
	curpos := !curpos + width
      end else begin
	Buffer.add_substring s !curpos maxlen;
	let rem = width - maxlen in
	Buffer.add_substring s 0 rem;
	curpos := rem;
      end
  in
  for i = 1 to n / width do
    write_cached width;
    Buffer.add_char '\n'
  done;
  let w = n mod width in
  if w > 0 then begin
    write_cached w;
    Buffer.add_char '\n'
  end;
    if !curpos = 0 then curpos := im;
    last := ns.(!curpos-1)


(* [write s i0 l w] outputs [w] chars of [s.[0 .. l]], followed by a
   newline, starting with [s.[i0]] and considering the substring [s.[0
   .. l]] as a "circle".
   One assumes [0 <= i0 <= l <= String.length s].
   @return [i0] needed for subsequent writes.  *)
let rec write s i0 l w =
  let len = l - i0 in
  if w <= len then begin
    Buffer.add_substring s i0 w;
    Buffer.add_char '\n'; i0 + w
  end
  else begin
    Buffer.add_substring s i0 len;
    write s 0 l (w - len);
  end

let make_repeat_fasta id desc src n =
  add_header id desc;
  let l = String.length src
  and i0 = ref 0 in
  for i = 1 to n / width do
    i0 := write src !i0 l width;
  done;
  let w = n mod width in
  if w > 0 then ignore(write src !i0 l w)


(* This version keeps a cache of starting positions of the string in the buffer modulo 61.
 After 61 misses, it fills the buffer at exponential speed. Unfortunately, it is useless
 as the speed-up for the short computation time is neglectible.
*)

(*
let make_repeat_fasta2 id desc src n =
  Buffer.clear ();
  add_header id desc;
  let cache = Array.create 61 None in
  let len_src = String.length src in

  let rec iter i n =
    if i < n then
      let x = i mod 61 in
	match cache.(x) with
	    Some pos ->
(*	      Printf.fprintf stderr "Hit at %d (%d)\n%!" i x; *)
	      let len = Buffer.length () - pos in
(*		Printf.fprintf stderr "copy %d\n%!" len; *)
	      let len = if len > n-i then n-i else len in
		Buffer.add_copy pos len;
		iter (i+len) n
	  | None ->
(*	      Printf.fprintf stderr "Miss at %d (%d)\n%!" i x; *)
	      cache.(x) <- Some (Buffer.length ());
	      let len = if len_src > n-i then n-i else len_src in
	      iter2 0 len i x

  and iter2 j len i imod =
    if j < len then
      if imod = 60 then begin
	Buffer.add_char '\n';
	iter2 j len (i+1) 0
      end else begin
	Buffer.add_char src.[j];
	iter2 (j+1) len (i+1) (imod+1)
      end
    else
      iter i n
  in
  let n = n + (n / 60) in
    iter 0 n;
    if n mod 61 <> 0 then
      Buffer.add_char '\n'
*)

let main n =
      Spawner.spawn true (fun _ ->
			  make_repeat_fasta "ONE" "Homo sapiens alu" alu (n*2);
			  ()) Buffer.print;
      Buffer.clear ();
      make_random_fasta "TWO" "IUB ambiguity codes" iub (n*3);
      Spawner.spawn true (fun _ -> ()) Buffer.print;
      Buffer.clear ();
      make_random_fasta "THREE" "Homo sapiens frequency" homosapiens (n*5);
      Spawner.spawn false (fun _ -> ()) Buffer.print;
      Buffer.clear ();


end

module IMPLEMENTATION64 = struct

module Buffer : sig

  val add_substring : string -> int -> int -> unit
  val add_string : string -> unit
  val add_char : char -> unit
  val add_copy : int -> int -> unit

  val length : unit -> int

  val clear : unit -> unit
  val print : unit -> unit

  val check_char : char -> unit
  val check_copy : int -> int -> unit


end = struct

  let buffer_len = if arch64 then 150_000_000 else 1
  let buffer = String.create buffer_len
  let buffer_pos = ref 0

  let length () = !buffer_pos

  let add_substring s pos len =
    String.blit s pos buffer !buffer_pos len;
    buffer_pos := !buffer_pos + len

  let add_string s =
    add_substring s 0 (String.length s)

  let add_char c =
    buffer.[!buffer_pos] <- c;
    incr buffer_pos

  let check_char c =
    if buffer.[!buffer_pos] <> c then begin
      Printf.fprintf stderr "check_char [%d]\n%!" !buffer_pos;
      exit 2;
    end;
    incr buffer_pos

  let clear () = buffer_pos := 0

  let print () =
    let rec iter i len =
      if len > 0 then begin
	let nw = Unix.write Unix.stdout buffer i  len in
	  iter (i+nw) (len-nw)
      end

    in
      iter 0 !buffer_pos;
      buffer_pos := 0

  let add_copy src len =
    add_substring buffer src len

  let rec check_copy src len =
    if len > 0 then begin
      assert (buffer.[src] = buffer.[!buffer_pos]);
      incr buffer_pos;
      check_copy (src+1) (len-1);
    end

end

let add_header id desc =
  Buffer.add_char '>';
  Buffer.add_string id;
  Buffer.add_char ' ';
  Buffer.add_string desc;
  Buffer.add_char '\n'



let make_random_fasta id desc table n =
(*  Printf.fprintf stderr "make_random_fasta BEGIN: last = %d\n%!" !last; *)
  add_header id desc;
  let (s, ns) = Cumul_tbl.make table in
  let curpos = ref 0 in
  let write_cached width =
(*
    if !curpos > 0 then
    Printf.fprintf stderr "last[%d] = {%d}%d{%d}\n%!" !curpos ns.(!curpos-1) ns.(!curpos) ns.(!curpos+1);
*)
    let maxlen = im - !curpos in
      if maxlen >= width then begin
	Buffer.add_substring s !curpos width;
	curpos := !curpos + width
      end else begin
	Buffer.add_substring s !curpos maxlen;
	let rem = width - maxlen in
	Buffer.add_substring s 0 rem;
	curpos := rem;
      end
  in
  for i = 1 to n / width do
    write_cached width;
    Buffer.add_char '\n'
  done;
  let w = n mod width in
  if w > 0 then begin
    write_cached w;
    Buffer.add_char '\n'
  end;
    if !curpos = 0 then curpos := im;
    last := ns.(!curpos-1);
(*    Printf.fprintf stderr "make_random_fasta END: last = %d\n%!" !last; *)
    ()

(*
let make_random_fasta id desc table n =
  add_header id desc;
  let table = Cumul_tbl.make table in
  for i = 1 to n / width do
    for j = 0 to width-1 do Buffer.add_char(Cumul_tbl.rand_char table); done;
    Buffer.add_char '\n'
  done;
  let w = n mod width in
  if w > 0 then (
    for j = 1 to w do Buffer.add_char(Cumul_tbl.rand_char table); done;
    Buffer.add_char '\n'
  )
*)


(* [write s i0 l w] outputs [w] chars of [s.[0 .. l]], followed by a
   newline, starting with [s.[i0]] and considering the substring [s.[0
   .. l]] as a "circle".
   One assumes [0 <= i0 <= l <= String.length s].
   @return [i0] needed for subsequent writes.  *)
let rec write s i0 l w =
  let len = l - i0 in
  if w <= len then begin
    Buffer.add_substring s i0 w;
    Buffer.add_char '\n'; i0 + w
  end
  else begin
    Buffer.add_substring s i0 len;
    write s 0 l (w - len);
  end


let make_repeat_fasta1 id desc src n =
  add_header id desc;
  let l = String.length src
  and i0 = ref 0 in
  for i = 1 to n / width do
    i0 := write src !i0 l width;
  done;
  let w = n mod width in
  if w > 0 then ignore(write src !i0 l w)

(* This version keeps a cache of starting positions of the string in the buffer modulo 61.
 After 61 misses, it fills the buffer at exponential speed. Unfortunately, it is useless
 as the speed-up for the short computation time is neglectible.

let make_repeat_fasta2 id desc src n =
  Buffer.clear ();
  add_header id desc;
  let cache = Array.create 61 None in
  let len_src = String.length src in

  let rec iter i n =
    if i < n then
      let x = i mod 61 in
	match cache.(x) with
	    Some pos ->
(*	      Printf.fprintf stderr "Hit at %d (%d)\n%!" i x; *)
	      let len = Buffer.length () - pos in
(*		Printf.fprintf stderr "copy %d\n%!" len; *)
	      let len = if len > n-i then n-i else len in
		Buffer.add_copy pos len;
		iter (i+len) n
	  | None ->
(*	      Printf.fprintf stderr "Miss at %d (%d)\n%!" i x; *)
	      cache.(x) <- Some (Buffer.length ());
	      let len = if len_src > n-i then n-i else len_src in
	      iter2 0 len i x

  and iter2 j len i imod =
    if j < len then
      if imod = 60 then begin
	Buffer.add_char '\n';
	iter2 j len (i+1) 0
      end else begin
	Buffer.add_char src.[j];
	iter2 (j+1) len (i+1) (imod+1)
      end
    else
      iter i n
  in
  let n = n + (n / 60) in
    iter 0 n;
    if n mod 61 <> 0 then
      Buffer.add_char '\n'
*)

let make_repeat_fasta id desc src n =
  make_repeat_fasta1 id desc src n;
(*    make_repeat_fasta2 id desc src n; *)
    ()

let main n =
      Spawner.spawn true (fun _ ->
			  make_repeat_fasta "ONE" "Homo sapiens alu" alu (n*2);
			  ()) Buffer.print;
      Buffer.clear ();
      make_random_fasta "TWO" "IUB ambiguity codes" iub (n*3);
      Spawner.spawn true (fun _ -> ()) Buffer.print;
      Buffer.clear ();
      make_random_fasta "THREE" "Homo sapiens frequency" homosapiens (n*5);
      Spawner.spawn false (fun _ -> ()) Buffer.print;
      Buffer.clear ();

end

let () =
  let n = try int_of_string(Array.get Sys.argv 1) with _ -> 1000 in
  if arch64 then
    IMPLEMENTATION64.main n
  else
    IMPLEMENTATION32.main n

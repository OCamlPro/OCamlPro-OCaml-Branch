(* The Computer Language Benchmarks Game
 * http://shootout.alioth.debian.org/
 *
 * contributed by Troestler Christophe
 * modified by Mauricio Fernandez
 * optimized by Fabrice Le Fessant
 *)

type t = Size of int | Dna of string

type entry = {
  mutable count : int;
}

let arch64 =
  match Sys.word_size with
      32 -> false
    | 64 -> true
	| _ -> assert false

let args = [Size 1;
	     Size 2;
	     Dna "GGT";
	     Dna "GGTA";
	     Dna "GGTATT";
	     Dna "GGTATTTTAATT";
	     Dna "GGTATTTTAATTTATAGT"]

let tab = Array.create 256 0
let _ =
  tab.(Char.code 'A') <- 0;
  tab.(Char.code 'a') <- 0;
  tab.(Char.code 'T') <- 1;
  tab.(Char.code 't') <- 1;
  tab.(Char.code 'C') <- 2;
  tab.(Char.code 'c') <- 2;
  tab.(Char.code 'g') <- 3;
  tab.(Char.code 'G') <- 3

let tab_lsl_34 = Array.map (fun x -> x lsl 34) tab

let simplify line =
  let len = String.length line in
    for i = 0 to len- 1 do
      let c =  line.[i] in
	line.[i] <- Char.unsafe_chr tab.(Char.code c)
    done


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



    let compare_freq ((k1:string),(f1:float)) (k2, f2) =
      if f1 > f2 then -1 else if f1 < f2 then 1 else String.compare k1 k2


    let invoke (f : t -> string) x : unit -> string =
      let input, output = Unix.pipe() in
	match Unix.fork() with
	  | -1 -> Unix.close input; Unix.close output; (let v = f x in fun () -> v)
	  | 0 ->
	      Unix.close input;
	      let output = Unix.out_channel_of_descr output in
(*
              let t0 = Sys.time () in
*)
	      let v = f x in
(*
	      let t1 = Sys.time () in
		Printf.fprintf stderr "Elasped time for : %f s\n%!" (t1 -. t0);
		Printf.fprintf stderr "[%s]\n%!" v;
*)
		Marshal.to_channel output v [];
		close_out output;
		exit 0
	  | pid ->
	      Unix.close output;
	      let input = Unix.in_channel_of_descr input in fun () ->
		let v = Marshal.from_channel input in
		  ignore (Unix.waitpid [] pid);
		  close_in input;
		  v

let parallelize f l =
  let list = List.map (invoke f) (List.rev l) in
  List.iter (fun g -> print_endline (g ())) (List.rev list)














(* TODO: pack in reverse order, so that smallest byte is in smallest bits.
   Pack first for 18 bases, and then pack becomes a LAND operation on the correct
   number of bits.
*)

    module IMPLEMENTATION64 : sig

      val main : unit -> unit

    end = struct

      type entry = {
	mutable count : int;
      }

      let threshold15 = 31
      let threshold16 = threshold15 + 1


      let dna_len = if arch64 then 150_000_000 else 1
      let dna = Array.create dna_len 0
      let dna_pos = ref 0


    (* Extract DNA sequence "THREE" from stdin *)
      module K15 = struct
	type t = int
	let equal k1 k2 = k1 = k2
	let hash n = n
      end

      let c = 1 lsl 20
      module H15 = Hashtbl.Make(K15)
      let h15 = H15.create c

      let pack15 k_mask n =
	dna.(n) land k_mask

      let rec pack_word_in dna n k h =
	let k = k - 1 in
	let b = dna.[n+k] in
	let b = tab.(Char.code b) in
	let h = h * 4 + b in
	  if k > 0 then
	    pack_word_in dna n k h
	  else h

      let pack_key15 seq =
	let k = String.length seq in
	  pack_word_in seq 0 k 0

      let char = [| 'A'; 'T'; 'C'; 'G' |]

      let rec unpack h s pos k =
	s.[pos] <- char.(h land 3);
	if k > 1 then
	  unpack (h lsr 2) s (pos+1) (k-1)

      let unpack15 k h1 =
	let s = String.create k in
	  unpack h1 s 0 k;
	  s

      let count15 k =
	let k_mask =  ((1 lsl (2*k)) - 1) in
	for i = 0 to !dna_pos - k - 1 do
	  let packed = pack15 k_mask i in
	    try
	      let key = H15.find h15 packed in
		key.count <- key.count + 1
	    with Not_found ->
	      H15.add h15 packed { count = 1 }
	done

      let write_frequencies15 k =
	count15 k;
	let tot = float(H15.fold (fun _ n t -> n.count + t) h15 0) in
	let frq =
	  H15.fold (fun h n l ->
		      (unpack15 k h, 100. *. float n.count /. tot) :: l) h15 [] in
	let frq = List.sort compare_freq frq in
	  String.concat ""
	    (List.map (fun (k,f) -> Printf.sprintf "%s %.3f\n" k f) frq)

      let write_count15 k seq =
	  count15 k;
	  Printf.sprintf "%d\t%s"
	    (try (H15.find h15 (pack_key15 seq)).count with Not_found -> 0) seq


      let read_dna () =
	let in_it = ref false in
	let packed = ref 0 in
	  try
	  LineReader.read Unix.stdin 100_000
	    (fun s pos len ->
	       if s.[pos] = '>' then begin
		 if s.[pos+1] = 'T' && s.[pos+2] = 'H' && s.[pos+3] = 'R' then begin
		   in_it := true
		 end else begin
		   if !in_it then
		     raise End_of_file
		 end
	       end else
		 if !in_it then
		   for i = 0 to len- 1 do
		     let c =  s.[pos+i] in
		     let b = tab_lsl_34.(Char.code c) in
		       packed := (!packed lsr 2) lor b;
		       if !dna_pos >= 18 then
			 dna.(!dna_pos-18) <- !packed;
		       incr dna_pos
		   done;
	    )
	with End_of_file ->
	  let pos = !dna_pos - 18 in
	  for i = 0 to 17 do
	    packed := (!packed lsr 2);
	    dna.(pos+i) <- !packed;
	  done
	  | e ->
	      Printf.fprintf stderr "exception %s\n%!" (Printexc.to_string e);
	      exit 2

      let main () =
(*	let t0 = Sys.time () in *)
	read_dna ();
(*
	  let t1 = Sys.time () in
	    Printf.fprintf stderr "Elasped time for reading : %f s\n%!" (t1 -. t0);
*)
	parallelize
	  (fun i ->
	     match i with
		 Size i ->
		   write_frequencies15 i
	       | Dna seq ->
		   let k = String.length seq in
		   write_count15 k seq
	  ) args

    end
















    module IMPLEMENTATION32 : sig

      val main : unit -> unit

    end = struct

      module BigString : sig
	type t

	val length : t -> int
	val create : int -> t
	val set : t -> int -> int -> unit
	val get : t -> int -> int

      end = struct

	let chunk_offset = 20
	let chunk_size = 1 lsl chunk_offset
	let chunk_mask = chunk_size - 1

	type t = {
	  string : int array array;
	  length : int;
	}

	let length t = t.length
	let create length =
	  let ns = length / chunk_size in
	  let string =   Array.init (ns+1) (fun i -> Array.create chunk_size 0) in
	    { string = string; length = length }

	let set t pos c =
	  let chunk = pos lsr chunk_offset in
	  let inchunk = pos land chunk_mask in
(*	    Printf.fprintf stderr "[%d->%d]\n%!" chunk inchunk; *)
	  t.string.(chunk).(inchunk) <- c

	let get t pos =
	  t.string.(pos lsr chunk_offset).(pos land chunk_mask)
      end

      let dna_len = if arch64 then 1 else 150_000_000
      let dna = BigString.create dna_len
      let dna_pos = ref 0

      module K15 = struct
	type t = int
	let equal k1 k2 = k1 = k2
	let hash n = n
      end

      module K16 = struct
	type t = int * int
	let equal (a1,a2) (b1,b2) = a1 = b1 && a2 = b2
	let hash (a1, _) = a1
      end

      let threshold15 = 15
      let threshold16 = threshold15 + 1

      let c = 0x40000-1
      module H16 = Hashtbl.Make(K16)
      let h16 = H16.create c

      module H15 = Hashtbl.Make(K15)
      let h15 = H15.create c

      let rec pack_word n k h =
	let b = BigString.get dna n in
	let h = h * 4 + b in
	  if k > 1 then
	    pack_word (n+1) (k-1) h
	  else h

      let pack15 k n =
	pack_word n k 0

      let pack16 k n =
	let h1 = pack_word n threshold15 0 in
	let h2 = pack_word (n+ threshold15) (k- threshold15) 0 in
	  (h1, h2)

      let rec pack_word_in dna n k h =
	let b = dna.[n] in
	let b = tab.(Char.code b) in
	let h = h * 4 + b in
	  if k > 1 then
	    pack_word_in dna (n+1) (k-1) h
	  else h

      let pack_key15 seq =
	let k = String.length seq in
	  pack_word_in seq 0 k 0

      let pack_key16 seq =
	let k = String.length seq in
	let h1 = pack_word_in seq 0 threshold15 0 in
	let h2 = pack_word_in seq threshold15 (k- threshold15) 0 in
	  (h1, h2)

      let char = [| 'A'; 'T'; 'C'; 'G' |]

      let rec unpack h s pos k =
	let pos = pos - 1 in
	  s.[pos] <- char.(h land 3);
	  if k > 1 then
	    unpack (h lsr 2) s pos (k-1)

      let unpack15 k h1 =
	let s = String.create k in
	  unpack h1 s k k;
	  s

      let unpack16 k (h1, h2) =
	let s = String.create k in
	  unpack h1 s threshold15 threshold15;
	  unpack h2 s k (k- threshold15);
	  s

      let count15 k =
	for i = 0 to BigString.length dna - k - 1 do
	  let packed = pack15 k i in
	    try
	      let key = H15.find h15 packed in
		key.count <- key.count + 1
	    with Not_found ->
	      H15.add h15 packed { count = 1 }
	done

      let count16 k =
	for i = 0 to BigString.length dna - k - 1 do
	  let packed = pack16 k i in
	    try
	      let key = H16.find h16 packed in
		key.count <- key.count + 1
	    with Not_found ->
	      H16.add h16 packed { count = 1 }
	done


      let write_frequencies15 k =
	Printf.fprintf stderr "write_frequencies15\n%!";
	count15 k;
	let tot = float(H15.fold (fun _ n t -> n.count + t) h15 0) in
	let frq =
	  H15.fold (fun h n l ->
		      Printf.fprintf stderr "[%d]\n%!" h;
		      (unpack15 k h, 100. *. float n.count /. tot) :: l) h15 [] in
	let frq = List.sort compare_freq frq in
	  String.concat ""
	    (List.map (fun (k,f) -> Printf.sprintf "%s %.3f\n" k f) frq)


      let write_frequencies16 k =
	count16 k;
	let tot = float(H16.fold (fun _ n t -> n.count + t) h16 0) in
	let frq =
	  H16.fold (fun h n l ->
		      (unpack16 k h, 100. *. float n.count /. tot) :: l) h16 [] in
	let frq = List.sort compare_freq frq in
	  String.concat ""
	    (List.map (fun (k,f) -> Printf.sprintf "%s %.3f\n" k f) frq)

      let write_count15 k seq =
	count15 k;
	Printf.sprintf "%d\t%s" (try (H15.find h15 (pack_key15 seq)).count with Not_found -> 0) seq

      let write_count16 k seq =
	count16 k;
	Printf.sprintf "%d\t%s" (try (H16.find h16 (pack_key16 seq)).count with Not_found -> 0) seq

      let write_frequencies k =
	if k < threshold16 then
	  write_frequencies15 k
	else write_frequencies16 k

      let write_count seq =
	let k = String.length seq in
	  if k < threshold16 then
	    write_count15 k seq
	  else write_count16 k seq


      let read_dna () =
	let in_it = ref false in
	  try
	  LineReader.read Unix.stdin 100_000
	    (fun s pos len ->
	       if s.[pos] = '>' then begin
		 if s.[pos+1] = 'T' && s.[pos+2] = 'H' && s.[pos+3] = 'R' then begin
		   in_it := true
		 end else begin
		   if !in_it then
		     raise End_of_file
		 end
	       end else
		 if !in_it then
		   let dpos = !dna_pos in
		   for i = 0 to len- 1 do
		     let c =  s.[pos+i] in
		       BigString.set dna (dpos + i) (tab.(Char.code c))
		   done;
		     dna_pos := dpos + len
	    )
	with End_of_file -> ()
	  | e ->
	      Printf.fprintf stderr "exception %s\n%!" (Printexc.to_string e);
	      exit 2


      let main () =
	let t0 = Sys.time () in
	read_dna ();
	  let t1 = Sys.time () in
	    Printf.fprintf stderr "Elasped time for reading : %f s\n%!" (t1 -. t0);
	parallelize
	  (fun i ->
	     match i with
		 Size i ->
		   write_frequencies i
	       | Dna k ->
		   write_count k
	  ) args

    end
    let _ =
      if arch64 then
	IMPLEMENTATION64.main ()
      else
	IMPLEMENTATION32.main ()

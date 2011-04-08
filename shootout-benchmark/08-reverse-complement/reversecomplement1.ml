(* The Computer Language Benchmarks Game
 * http://shootout.alioth.debian.org/
 *
 * Contributed by Troestler Christophe
 * Modified by Mauricio Fernandez
 *)


let complement =
  let cplt = Array.init 256 (fun i -> Char.chr i) in
  List.iter (fun (c1, c2) ->
	       cplt.(Char.code c1) <- c2;
	       cplt.(Char.code c2) <- c1;
	       cplt.(Char.code(Char.lowercase c1)) <- c2;
	       cplt.(Char.code(Char.lowercase c2)) <- c1;  )
    [ ('A','T'); ('C','G'); ('B','V'); ('D','H'); ('K','M'); ('R','Y') ];
  cplt

(* [reverse s] reverse-complement the string [s] in place. *)
let reverse s =
  let rec rev i j =
    if i < j then (
      let si = s.[i] in
      s.[i] <- complement.(Char.code s.[j]);
      s.[j] <- complement.(Char.code si);
      rev (i + 1) (j - 1)
    ) in
  rev 0 (String.length s - 1);
  s

let print_fasta =
  let rec print60 pos len dna =
    if len > 60 then (
      output stdout dna pos 60; print_string "\n";
      print60 (pos + 60) (len - 60) dna
    )
    else (output stdout dna pos len; print_string "\n") in
  fun dna -> print60 0 (String.length dna) dna


let () =
  Gc.set { (Gc.get ()) with Gc.max_overhead = -1; space_overhead = 100 };
  let buf = Buffer.create 4096 in
  try while true do
    let line = input_line stdin in
    if String.length line > 0 && line.[0] = '>' then (
      if Buffer.length buf > 0 then print_fasta(reverse(Buffer.contents buf));
      Buffer.clear buf;
      print_endline line
    )
    else Buffer.add_string buf line
  done with End_of_file -> print_fasta(reverse(Buffer.contents buf))


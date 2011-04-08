(* The Computer Language Benchmarks Game
 * http://shootout.alioth.debian.org/
 *
 * Contributed by Troestler Christophe
 * Modified by Fabrice Le Fessant
 *)

(* function originally due to Jon D. Harrop *)
let invoke (f : 'a -> 'b) x =
  let input, output = Unix.pipe() in
    match Unix.fork() with
      | -1 -> assert false
      | 0 ->
	  Unix.close input;
	  let oc = Unix.out_channel_of_descr output in
	  let v = f x in
	    output_value oc v;
	    close_out oc;
      exit 0
  | pid ->
      Unix.close output;
      let ic = Unix.in_channel_of_descr input in
	(
	  fun () ->
            input_value ic)

type 'a tree = Leaf of 'a | Node of 'a tree * 'a * 'a tree

let rec make d i =
  if d = 0 then Leaf i
  else
    let d = d -1 in
    let i2 = 2 * i in
    let r = make d i2 in
    let l = make d (i2 - 1) in
      Node(l, i, r)

let rec check = function Leaf i -> i | Node(l, i, r) ->
  let i = i + check l in
    i - check r

let min_depth = 4
let n = if Array.length Sys.argv <> 2 then 0 else int_of_string Sys.argv.(1)
let max_depth = max (min_depth + 2) n
let stretch_depth = max_depth + 1

let () =
  let c = check (make stretch_depth 0) in
  Printf.printf "stretch tree of depth %i\t check: %i\n" stretch_depth c

let long_lived_tree = make max_depth 0


let rec iter i niter c d =
  if i > niter then c else
    let c = c + check(make d i) in
    let c = c + check(make d (-i)) in
    iter (i+1) niter c d


let rec loop_depths d conts =
  let niter = 1 lsl (max_depth - d + min_depth) in
  let cont = invoke (fun () ->
		       iter 1 niter 0 d) () in
  let cont = (fun () ->
		let c = cont () in
		  Printf.printf "%i\t trees of depth %i\t check: %i\n" (2 * niter) d c) in
  let conts = cont :: conts in
    if d < max_depth then
      loop_depths (d+2) conts
    else
      let conts = List.rev conts in
	List.iter (fun cont -> cont ()) conts

let () =
  flush stdout;
  loop_depths min_depth [];
  Printf.printf "long lived tree of depth %i\t check: %i\n"
    max_depth (check long_lived_tree)

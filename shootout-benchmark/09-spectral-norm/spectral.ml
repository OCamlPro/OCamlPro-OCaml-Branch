(* The Computer Language Benchmarks Game
 * http://shootout.alioth.debian.org/
 *
 * Contributed by Sebastien Loisel
 * Cleanup by Troestler Christophe
 * Modified by Mauricio Fernandez
 *)

let eval_A cache i j = cache.(i).(j)

let eval_A_times_u cache u v =
  let n = Array.length v - 1 in
  for i = 0 to  n do
    let vi = ref 0. in
      for j = 0 to n do vi := !vi +. eval_A cache i j *. u.(j) done;
      v.(i) <- !vi
  done

let eval_At_times_u cache u v =
  let n = Array.length v -1 in
  for i = 0 to n do
    let vi = ref 0. in
      for j = 0 to n do vi := !vi +. eval_A cache j i *. u.(j) done;
      v.(i) <- !vi
  done

let eval_AtA_times_u cache u v =
  let w = Array.make (Array.length u) 0.0 in
  eval_A_times_u cache u w; eval_At_times_u cache w v


let eval_A i j = 1. /. float((i+j)*(i+j+1)/2+i+1)

let n = try int_of_string(Array.get Sys.argv 1) with _ ->  2000

let () =
  let cache = Array.init n (fun i ->
			      Array.init n (fun j -> eval_A i j)) in
(* expansé en :

  let cache = Array.init n (fun i ->
     if n = 0 then [||] else
       let t = Array.create n (eval_A i 0) in
       for j = 1 to n-1 do
          t.(j) <- eval_A i j
       done;
       t)

*)


  let u = Array.make n 1.0  and  v = Array.make n 0.0 in
  for i = 0 to 9 do
    eval_AtA_times_u cache u v; eval_AtA_times_u cache v u
  done;

  let vv = ref 0.0  and  vBv = ref 0.0 in
  for i=0 to n-1 do (* v.(i) should be automatically put in a local *)
    vv := !vv +. v.(i) *. v.(i);
    vBv := !vBv +. u.(i) *. v.(i)
  done;
  Printf.printf "%0.9f\n" (sqrt(!vBv /. !vv))

(* tests:

500
3000
5500
*)

(* The Computer Language Benchmarks Game
   http://shootout.alioth.debian.org/
   contributed by Otto Bommer
*)

open Printf

let rec range i j =
  if i<j then i::(range (i+1) j)
  else if i=j then [i] else i::(range (i-1) j)

module Board = struct
let rows = 10
let cols = 5
let size = rows*cols
let empty = Char.chr(0xe)
let filled = Char.chr(0xf)

let create () = let s = String.create size in String.fill s 0 size empty; s
let copy b = String.copy b
let get b n = b.[n]
let set b n v = b.[n] <- v

let cset dst cells v = for i = 0 to 4 do set dst (Array.get cells i) v done
let cdel dst cells = for i = 0 to 4 do set dst (Array.get cells i) empty done

let compare s1 s2 = String.compare s1 s2

let find_empty b = try String.index b empty with _ -> size-1
let rotate a steps = (a+60*steps) mod 360
let flip a = (540-a) mod 360

let print b =  List.iter (fun i ->
    printf "%x " (Char.code (get b i));
    if (i+1) mod cols==0 then printf "\n";
    if (i+cols+1) mod (cols*2)==0 then printf " "
  ) (range 0 (size-1));
  printf "\n"

let invert b =
  let bflip = String.create size in
  for i = 0 to (size-1) do set bflip (size-1-i) (get b i) done;
  bflip

let dont_intersect b1 c =
  if get b1 (Array.get c 0) != empty then false
  else if get b1 (Array.get c 1) != empty then false
  else if get b1 (Array.get c 2) != empty then false
  else if get b1 (Array.get c 3) != empty then false
  else if get b1 (Array.get c 4) != empty then false
  else true

let shift idx a =
   match a with
    |   0 ->  idx-cols*2
    |  30 ->  idx-cols+(idx/cols) mod 2
    |  60 ->  idx-cols+1+(idx/cols) mod 2
    |  90 ->  idx+1
    | 120 ->  idx+cols+1+(idx/cols) mod 2
    | 150 ->  idx+cols+(idx/cols) mod 2
    | 180 ->  idx+cols*2
    | 210 ->  idx+cols-1+(idx/cols) mod 2
    | 240 ->  idx+cols-2+(idx/cols) mod 2
    | 270 ->  idx-1
    | 300 ->  idx-cols-2+(idx/cols) mod 2
    | 330 ->  idx-cols-1+(idx/cols) mod 2
    |   _ ->  idx

let inside idx a =
  if idx >= 0 && idx < size then
  match a with
    |   0 ->  idx >= cols*2
    |  30 ->  idx mod (cols*2) != (cols*2-1) && idx >= cols
    |  60 ->  let i = idx mod (cols*2) in
              i!=(cols-1) && i!=(cols*2-2) && i!=(cols*2-1) && idx>=cols
    |  90 ->  idx mod cols != (cols-1)
    | 120 ->  let i = idx mod (cols*2) in
              i!=(cols-1) && i!=(cols*2-2) && i!=(cols*2-1) && idx<(size-cols)
    | 150 ->  idx mod (cols*2) != (cols*2-1) && idx<(size-cols)
    | 180 ->  idx < size-2*cols
    | 210 ->  idx mod (cols*2) != 0 && idx < (size-cols)
    | 240 ->  let i = idx mod (cols*2) in
              i!=0 && i!=1 && i!=cols && idx < (size-cols)
    | 270 ->  idx mod 5 != 0
    | 300 ->  let i = idx mod (cols*2) in i!=0 && i!=1 && i!=cols && idx >= cols
    | 330 ->  idx mod (cols*2) != 0 && idx >= cols
    |   _ ->  false
  else false

let cell_peers = List.map (fun idx -> let peers = ref [] in
  List.iter (fun a -> if inside idx a then peers:=!peers @ [(shift idx a)])
  [30; 90; 150; 210; 270; 330]; !peers) (range 0 (size-1))

let rec fill_island b idx =
  let n = ref 0 in
  if (get b idx) == empty then begin set b idx filled; n:=!n+1 end;
  let peers = List.nth cell_peers idx in List.iter (fun i ->
    if (get b i) == empty then begin set b i filled; n:=!n+1+fill_island b i end
  ) peers; !n

let is_fillable b pn =
  let i = find_empty b in
  let tmp = copy b in
  let s = fill_island tmp i in
  s mod 5 == 0
end

module Piece = struct
let defs = [
   [| 90;  90;  90; 150|];
   [|150;  90;  30;  90|];
   [| 90;  90; 150; 210|];
   [| 90;  90; 210; 150|];
   [|150;  90;  30; 180|];
   [| 90;  90; 210;  90|];
   [| 90; 150; 150;  30|];
   [| 90; 150; 150; 270|];
   [| 90; 150;  90;  90|];
   [| 90;  90;  90; 210|]
]

let count = List.length defs
let rotate p steps =  Array.map (fun j ->  Board.rotate j steps) p
let flip p =  Array.map (fun i ->  Board.flip i) p
end;;

module Cell = struct
let min cells =  Array.fold_left min Board.size cells

let from_piece p idx =
  let a = Board.shift idx (Array.get p 0) in
  let b = Board.shift a (Array.get p 1) in
  let c = Board.shift b (Array.get p 2) in
  let d = Board.shift c (Array.get p 3) in
  [|idx; a; b; c; d|]

let fits_on_board cells p =
  Board.inside (Array.get cells 0) (Array.get p 0) &&
  Board.inside (Array.get cells 1) (Array.get p 1) &&
  Board.inside (Array.get cells 2) (Array.get p 2) &&
  Board.inside (Array.get cells 3) (Array.get p 3) &&
  (Array.get cells 4) >= 0 && (Array.get cells 4) < Board.size

let to_board cells pn =
  let b = Board.create () in let chr = Char.chr pn in
  Board.set b (Array.get cells 0) chr;
  Board.set b (Array.get cells 1) chr;
  Board.set b (Array.get cells 2) chr;
  Board.set b (Array.get cells 3) chr;
  Board.set b (Array.get cells 4) chr;
  b
end;;

let permutations =
  let permutations = List.map (fun pn -> ref (List.map (fun l -> ref [])
                       (range 0 (Board.size-1)))) (range 0 (Piece.count-1)) in
  let calc_piece_rotations pn idx =
    let calc_rots piece =
      let pieceperms = List.nth permutations pn in
      for i = 0 to 5 do
        if pn != 3 || i < 3 then
          let rotp = Piece.rotate piece i in
          let c = Cell.from_piece rotp idx in
          if Cell.fits_on_board c rotp then
            let pboard = Cell.to_board c pn in
            if Board.is_fillable pboard pn then
              let minimum = Cell.min c in
              let rotperms = List.nth !pieceperms minimum in
              rotperms := !rotperms @ [(rotp, pn, c, pboard)];
      done
    in
    let p = List.nth Piece.defs pn in
    calc_rots p;
    calc_rots (Piece.flip p);
  in
  List.iter (fun pn -> List.iter (fun idx -> calc_piece_rotations pn idx)
    (range 0 (Board.size-1))) (range 0 (Piece.count-1));
  permutations

module Solution = struct
exception Max_solutions
let rec solve max board solutions depth usedmask =
  for ipn = 0 to Piece.count-1 do
    if usedmask land (1 lsl ipn) == 0 then
      begin
      let emptycell = Board.find_empty board in
      let piece_perms = !(List.nth permutations ipn) in
      let cell_perms = !(List.nth piece_perms emptycell) in

      List.iter (fun perm ->
        let (p, pn, c, pboard) = perm in
        if Board.dont_intersect board c then
          begin
          Board.cset board c (Char.chr pn);

          if depth == 9 then
            begin
            solutions := !solutions @ [Board.copy board] @ [Board.invert board];
            if (List.length !solutions) >= max then raise Max_solutions
            end
          else
              solve max board solutions (depth+1) (usedmask lor (1 lsl pn));

          Board.cdel board c
          end
        ) cell_perms
      end;
  done;
  if depth == 0 then raise Max_solutions

end
let _ =
  let max = try int_of_string (Sys.argv.(1)) with _ -> 2100 in
  let solutions = ref [] in
  let board = Board.create () in
  try Solution.solve max board solutions 0 0 with _ -> ();
  let sorted_solutions = List.sort Board.compare !solutions in
  printf "%d solutions found\n\n" (List.length sorted_solutions);

  if List.length sorted_solutions > 0 then
    begin
    Board.print (List.nth sorted_solutions 0);
    Board.print (List.nth sorted_solutions (List.length sorted_solutions - 1))
    end;

(* N=2098 *)

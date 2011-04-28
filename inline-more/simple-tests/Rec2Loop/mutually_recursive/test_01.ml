open Externals

(* val rev_words : string -> string list *)
let rev_words s =
  let len = String.length s in
  let rec iter_out pos list =
    if pos = len then list else
    let c = s.[pos] in
    match c with
      ' ' | '\009' | '\010' | '\013' -> iter_out (pos+1) list
      | _ -> iter_in pos (pos+1) list

  and iter_in pos0 pos list =
    if pos = len then
      (String.sub s pos0 (len-pos0)) :: list else
    let c = s.[pos] in
    match c with
      ' ' | '\009' | '\010' | '\013' ->
        iter_out (pos+1) ( (String.sub s pos0 (pos - pos0)) :: list)
      | _ -> iter_in pos0 (pos+1) list
  in
  iter_out 0 []

let _ =
  if (rev_words "bonjour a vous ") = ["vous"; "a"; "bonjour"] then
    exit_ok ()

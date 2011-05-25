let _ = print_string "begin Test"; print_newline ()

module M = Lib.Make(struct
  let _ = print_string "begin Test.Arg"; print_newline ()
  type t = int
  let create () = 1
  let to_string = string_of_int
  let _ = print_string "end Test.Arg"; print_newline ()
end)

let _ =
  print_string M.B.s;
  print_newline ()



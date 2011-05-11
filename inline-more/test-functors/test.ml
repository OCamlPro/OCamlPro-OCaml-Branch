
module M = Lib.Make(struct
  type t = int
  let create () = 1
  let to_string = string_of_int
end)

let _ =
  print_string M.B.s;
  print_newline ()


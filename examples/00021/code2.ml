
let _ =
  let y = ref 0 in
    Code1.option (function x -> y := x) (Some 3);
    !y


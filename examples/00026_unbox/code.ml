
let _ =
  let r = ref 0.0 in
  for i = 0 to 1000000000 do r := float i done;
  Printf.printf "%f\n" !r
  


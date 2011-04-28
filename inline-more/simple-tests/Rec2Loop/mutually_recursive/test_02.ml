open Externals

let rec iter_incr n =
  if n > 1 then
  try
    iter_div (n+1)
  with Not_found -> n
  else n

and iter_div n =
  if n > 1 then
    try
      iter_incr (n/2)
    with Not_found -> n
  else n

let _ =
  if iter_incr 1000 = 1 then exit_ok ()


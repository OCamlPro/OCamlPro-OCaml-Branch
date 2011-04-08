let rec gcd m n =
  if m = 0 then n else
  if m <= n then gcd m (n-m) else
  gcd n (m-n)

    
let _ =
  let n = 4000 in
  let x = ref 0 in
  for i = 1 to n do
    for j = 1 to n do
      x := gcd i j
    done
  done
  
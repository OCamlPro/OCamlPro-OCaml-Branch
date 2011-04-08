

let _ =
  let max_i = 1000000 in
  let max_j = 100 in
  match Sys.argv.(1) with
  | "0" ->
      for i = 0 to max_i do
        let f x =
          x +. sqrt (float i)
        in
        for j = 0 to max_j do
          f (float j)
        done
      done
  | "1" ->
      for i = 0 to max_i do
        let a = lazy (sqrt (float i)) in
        let f x =
          x +. Lazy.force a
        in
        for j = 0 to max_j do
          f (float j)
        done
      done
  | "2" ->
      for i = 0 to max_i do
        let f x =
          x +. sqrt (float i)
        in
        for j = 0 to max_j do
          f (float j)
        done
      done
  | "3" ->
      for i = 0 to max_i do
        let a = lazy (sqrt (float i)) in
        let f x =
          x +. Lazy.force a
        in
        for j = 0 to max_j do
          f (float j)
        done
      done  
  | "4" ->
      for i = 0 to max_i do
        let f x =
          x +. sqrt (float i)
        in
        for j = 0 to max_j do
          f (float j)
        done
      done
  | "5" ->
      for i = 0 to max_i do
        let a = lazy (sqrt (float i)) in
        let f x =
          x +. Lazy.force a
        in
        for j = 0 to max_j do
          f (float j)
        done
      done
  | "6" ->
      for i = 0 to max_i do
        let f x =
          x +. sqrt (float i)
        in
        for j = 0 to max_j do
          f (float j)
        done
      done
  | "7" ->
      for i = 0 to max_i do
        let a = lazy (sqrt (float i)) in
        let f x =
          x +. Lazy.force a
        in
        for j = 0 to max_j do
          f (float j)
        done
      done
  | _ -> assert false
      
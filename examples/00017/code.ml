let iter i n =
  let i_arg = ref i in
  let n_arg = ref n in
  let module X_return = struct exception Exn of float end in
  try
    while true do
      let module X_break = struct exception Exn end in
      try
        let i = !i_arg in
        let n = !n_arg in
        if i < float n then begin
          i_arg := i +. 1.;
          n_arg := n;
          raise X_break.Exn
        end else
          raise (X_return.Exn (1. /. i))
      with X_break.Exn -> ()
    done;
    assert false
  with X_return.Exn n -> n

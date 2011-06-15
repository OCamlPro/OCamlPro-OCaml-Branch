let init_x = X.to_string (X.create "V.init")

let u = 0
let v = Printf.sprintf "UVW.v(init_x=%s, Y.x = %s)" init_x (X.to_string Y.x)
let w = U.v

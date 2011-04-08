type point = {x:float; y:float}
 
let fmin (x:float) y = if x > y then y else x
let fmax (x:float) y = if y > x then y else x
 
let min_point {x=x1;y=y1} {x=x2;y=y2} =
  let x = fmin x1 x2 in  
  let y = fmin y1 y2 in
  {x=x; y=y}

(*


As a general rule, I would say the compiler does not do a great load of optimization to unbox floats. The only case that gets optimized is "unbox (box v) -> v", i.e. in CMMnotation "load float64u (alloc 2301 x/123)  ->  x/123"

The first patch that I proposed (see there) got integrated into the compiler and will unbox floats across a let, i.e. "load float64u (let (x/123 (alloc 2301 y/234)))   ->   let (x/123 y/234)".

The second patch I proposed was not integrated. In your example, it would have moved the allocs from the lets into the branches of the if, allocating only one value instead of two. That is not enough to unbox completely though. In order to do that, the compiler would have to notice that both branches of the if are allocs and factorize them (x/74 and y/75 would now be allocs). Then, as another pass, it would have to notice that x/74 and y/75 always get unboxed and hence could be simplified. In short, three different kinds of mechanical transforms are needed in order to fully optimize your code...
*)


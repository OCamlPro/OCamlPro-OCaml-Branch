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

(*
-drawlambda
(seq
  (let
    (fmin/1036 (function x/1037 y/1038 (if (>. x/1037 y/1038) y/1038 x/1037)))
    (setfield_imm 0 (global Code!) fmin/1036))
  (let
    (fmax/1039 (function x/1040 y/1041 (if (>. y/1041 x/1040) y/1041 x/1040)))
    (setfield_imm 1 (global Code!) fmax/1039))
  (let
    (min_point/1042
       (function param/1055 param/1056
         (let
           (y2/1046 (floatfield 1 param/1056)
            x2/1045 (floatfield 0 param/1056)
            y1/1044 (floatfield 1 param/1055)
            x1/1043 (floatfield 0 param/1055)
            x/1047 (apply (field 0 (global Code!)) x1/1043 x2/1045)
            y/1048 (apply (field 0 (global Code!)) y1/1044 y2/1046))
           (makearray  x/1047 y/1048))))
    (setfield_imm 2 (global Code!) min_point/1042))
  0a)
Before TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
After TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
Before TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
After TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
Before TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047
     (if (>f x/1067 y/1068) (alloc[253] 2301 y/1068)
       (alloc[253] 2301 x/1067))
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048
     (if (>f x/1065 y/1066) (alloc[253] 2301 y/1066)
       (alloc[253] 2301 x/1065)))
  (alloc[254] 4350 (load float64u x/1047) (load float64u y/1048)))
x/1047 could be simplified
insert_load Calloc
insert_load Calloc
y/1048 could be simplified
insert_load Calloc
insert_load Calloc
After TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047 (if (>f x/1067 y/1068) y/1068 x/1067)
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048 (if (>f x/1065 y/1066) y/1066 x/1065))
  (alloc[254] 4350 x/1047 y/1048))
Before TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))
After TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))
-dlambda
(seq
  (let
    (fmin/1036 (function x/1037 y/1038 (if (>. x/1037 y/1038) y/1038 x/1037)))
    (setfield_imm 0 (global Code!) fmin/1036))
  (let
    (fmax/1039 (function x/1040 y/1041 (if (>. y/1041 x/1040) y/1041 x/1040)))
    (setfield_imm 1 (global Code!) fmax/1039))
  (let
    (min_point/1042
       (function param/1055 param/1056
         (let
           (x/1047
              (apply (field 0 (global Code!)) (floatfield 0 param/1055)
                (floatfield 0 param/1056))
            y/1048
              (apply (field 0 (global Code!)) (floatfield 1 param/1055)
                (floatfield 1 param/1056)))
           (makearray  x/1047 y/1048))))
    (setfield_imm 2 (global Code!) min_point/1042))
  0a)
stats_rec_removed : 0

stats_tailcall_removed : 0

stats_rec_removed : 0

stats_tailcall_removed : 0

Before TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
After TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
Before TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
After TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
Before TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047
     (if (>f x/1067 y/1068) (alloc[253] 2301 y/1068)
       (alloc[253] 2301 x/1067))
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048
     (if (>f x/1065 y/1066) (alloc[253] 2301 y/1066)
       (alloc[253] 2301 x/1065)))
  (alloc[254] 4350 (load float64u x/1047) (load float64u y/1048)))
x/1047 could be simplified
insert_load Calloc
insert_load Calloc
y/1048 could be simplified
insert_load Calloc
insert_load Calloc
After TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047 (if (>f x/1067 y/1068) y/1068 x/1067)
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048 (if (>f x/1065 y/1066) y/1066 x/1065))
  (alloc[254] 4350 x/1047 y/1048))
Before TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))
After TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))
-dlambda2
*** After TonLambda.optimize:
(seq
  (let
    (fmin/1036 (function x/1037 y/1038 (if (>. x/1037 y/1038) y/1038 x/1037)))
    (setfield_imm 0 (global Code!) fmin/1036))
  (let
    (fmax/1039 (function x/1040 y/1041 (if (>. y/1041 x/1040) y/1041 x/1040)))
    (setfield_imm 1 (global Code!) fmax/1039))
  (let
    (min_point/1042
       (function param/1055 param/1056
         (let
           (x/1047
              (apply (field 0 (global Code!)) (floatfield 0 param/1055)
                (floatfield 0 param/1056))
            y/1048
              (apply (field 0 (global Code!)) (floatfield 1 param/1055)
                (floatfield 1 param/1056)))
           (makearray  x/1047 y/1048))))
    (setfield_imm 2 (global Code!) min_point/1042))
  0a)
Before TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
After TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
Before TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
After TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
Before TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047
     (if (>f x/1067 y/1068) (alloc[253] 2301 y/1068)
       (alloc[253] 2301 x/1067))
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048
     (if (>f x/1065 y/1066) (alloc[253] 2301 y/1066)
       (alloc[253] 2301 x/1065)))
  (alloc[254] 4350 (load float64u x/1047) (load float64u y/1048)))
x/1047 could be simplified
insert_load Calloc
insert_load Calloc
y/1048 could be simplified
insert_load Calloc
insert_load Calloc
After TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047 (if (>f x/1067 y/1068) y/1068 x/1067)
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048 (if (>f x/1065 y/1066) y/1066 x/1065))
  (alloc[254] 4350 x/1047 y/1048))
Before TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))
After TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))
-dclosure
*** After Closure.intro:
(seq
  (let
    (fmin/1036
       (closure (camlCode__fmin_1036(2)  x/1037 y/1038
                  (if (>. x/1037 y/1038) y/1038 x/1037)) {3} ))
    (setfield_imm 0 (global camlCode!) fmin/1036))
  (let
    (fmax/1039
       (closure (camlCode__fmax_1039(2)  x/1040 y/1041
                  (if (>. y/1041 x/1040) y/1041 x/1040)) {3} ))
    (setfield_imm 1 (global camlCode!) fmax/1039))
  (let
    (min_point/1042
       (closure (camlCode__min_point_1042(2)  param/1055 param/1056
                  (let
                    (x/1047
                       (let
                         (y/1061 (floatfield 0 param/1056)
                          x/1062 (floatfield 0 param/1055))
                         (if (>. x/1062 y/1061) y/1061 x/1062))
                     y/1048
                       (let
                         (y/1063 (floatfield 1 param/1056)
                          x/1064 (floatfield 1 param/1055))
                         (if (>. x/1064 y/1063) y/1063 x/1064)))
                    (makearray  x/1047 y/1048))) {3} ))
    (setfield_imm 2 (global camlCode!) min_point/1042))
  0a)
Before TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
After TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
Before TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
After TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
Before TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047
     (if (>f x/1067 y/1068) (alloc[253] 2301 y/1068)
       (alloc[253] 2301 x/1067))
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048
     (if (>f x/1065 y/1066) (alloc[253] 2301 y/1066)
       (alloc[253] 2301 x/1065)))
  (alloc[254] 4350 (load float64u x/1047) (load float64u y/1048)))
x/1047 could be simplified
insert_load Calloc
insert_load Calloc
y/1048 could be simplified
insert_load Calloc
insert_load Calloc
After TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047 (if (>f x/1067 y/1068) y/1068 x/1067)
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048 (if (>f x/1065 y/1066) y/1066 x/1065))
  (alloc[254] 4350 x/1047 y/1048))
Before TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))
After TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))
-dclosure2
*** After TonClosure.optimize:
(let
  (fmin/1036
     (closure (camlCode__fmin_1036(2)  x/1037 y/1038
                (if (>. x/1037 y/1038) y/1038 x/1037)) {3} ))
  (seq (setfield_imm 0 (global camlCode!) fmin/1036)
    (let
      (fmax/1039
         (closure (camlCode__fmax_1039(2)  x/1040 y/1041
                    (if (>. y/1041 x/1040) y/1041 x/1040)) {3} ))
      (seq (setfield_imm 1 (global camlCode!) fmax/1039)
        (let
          (min_point/1042
             (closure (camlCode__min_point_1042(2)  param/1055 param/1056
                        (let
                          (y/1061 (floatfield 0 param/1056)
                           x/1062 (floatfield 0 param/1055)
                           x/1047 (if (>. x/1062 y/1061) y/1061 x/1062)
                           y/1063 (floatfield 1 param/1056)
                           x/1064 (floatfield 1 param/1055)
                           y/1048 (if (>. x/1064 y/1063) y/1063 x/1064))
                          (makearray  x/1047 y/1048))) {3} ))
          (seq (setfield_imm 2 (global camlCode!) min_point/1042) 0a))))))
Before TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
After TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
Before TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
After TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
Before TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047
     (if (>f x/1067 y/1068) (alloc[253] 2301 y/1068)
       (alloc[253] 2301 x/1067))
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048
     (if (>f x/1065 y/1066) (alloc[253] 2301 y/1066)
       (alloc[253] 2301 x/1065)))
  (alloc[254] 4350 (load float64u x/1047) (load float64u y/1048)))
x/1047 could be simplified
insert_load Calloc
insert_load Calloc
y/1048 could be simplified
insert_load Calloc
insert_load Calloc
After TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047 (if (>f x/1067 y/1068) y/1068 x/1067)
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048 (if (>f x/1065 y/1066) y/1066 x/1065))
  (alloc[254] 4350 x/1047 y/1048))
Before TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))
After TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))

-dcmm
(data int 3072 global "camlCode" "camlCode": skip 12)
(data
 int 3319
 "camlCode__1":
 addr "caml_curry2"
 int 5
 addr "camlCode__min_point_1042")
(data
 int 3319
 "camlCode__2":
 addr "caml_curry2"
 int 5
 addr "camlCode__fmax_1039")
(data
 int 3319
 "camlCode__3":
 addr "caml_curry2"
 int 5
 addr "camlCode__fmin_1036")
(function camlCode__fmin_1036 (x/1037: addr y/1038: addr)
 (if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037))

Before TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
After TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
(function camlCode__fmax_1039 (x/1040: addr y/1041: addr)
 (if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040))

Before TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
After TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
(function camlCode__min_point_1042 (param/1055: addr param/1056: addr)
 (let
   (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
    x/1047
      (if (>f x/1067 y/1068) (alloc[253] 2301 y/1068)
        (alloc[253] 2301 x/1067))
    y/1066 (load float64u (+a param/1056 8))
    x/1065 (load float64u (+a param/1055 8))
    y/1048
      (if (>f x/1065 y/1066) (alloc[253] 2301 y/1066)
        (alloc[253] 2301 x/1065)))
   (alloc[254] 4350 (load float64u x/1047) (load float64u y/1048))))

Before TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047
     (if (>f x/1067 y/1068) (alloc[253] 2301 y/1068)
       (alloc[253] 2301 x/1067))
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048
     (if (>f x/1065 y/1066) (alloc[253] 2301 y/1066)
       (alloc[253] 2301 x/1065)))
  (alloc[254] 4350 (load float64u x/1047) (load float64u y/1048)))
x/1047 could be simplified
insert_load Calloc
insert_load Calloc
y/1048 could be simplified
insert_load Calloc
insert_load Calloc
After TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047 (if (>f x/1067 y/1068) y/1068 x/1067)
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048 (if (>f x/1065 y/1066) y/1066 x/1065))
  (alloc[254] 4350 x/1047 y/1048))
(function camlCode__entry ()
 (let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
   (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
     (let min_point/1042 "camlCode__1"
       (store (+a "camlCode" 8) min_point/1042) 1a))))

Before TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))
After TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))
(data)
-dlinear
Before TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
After TonScmm.optimize:
(if (>f (load float64u x/1037) (load float64u y/1038)) y/1038 x/1037)
Before simplify
camlCode__fmin_1036:
                  x/8[%ecx] := R/0[%eax]
                  R/7[%tos] := float64u[y/9[%ebx]]
                  R/7[%tos] := float64u[x/8[%ecx]]
                  if not R/7[%tos] >f R/7[%tos] goto L100
                  R/0[%eax] := y/9[%ebx]
                  return R/0[%eax]
                  L100 [0]:
                  R/0[%eax] := x/8[%ecx]
                  return R/0[%eax]
                  *** Linearized code
camlCode__fmin_1036:
  x/8[%ecx] := R/0[%eax]
  R/7[%tos] := float64u[y/9[%ebx]]
  R/7[%tos] := float64u[x/8[%ecx]]
  if not R/7[%tos] >f R/7[%tos] goto L100
  R/0[%eax] := y/9[%ebx]
  return R/0[%eax]
  L100 [2]:
  R/0[%eax] := x/8[%ecx]
  return R/0[%eax]
  
Before TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
After TonScmm.optimize:
(if (>f (load float64u y/1041) (load float64u x/1040)) y/1041 x/1040)
Before simplify
camlCode__fmax_1039:
                  x/8[%ecx] := R/0[%eax]
                  R/7[%tos] := float64u[x/8[%ecx]]
                  R/7[%tos] := float64u[y/9[%ebx]]
                  if not R/7[%tos] >f R/7[%tos] goto L102
                  R/0[%eax] := y/9[%ebx]
                  return R/0[%eax]
                  L102 [0]:
                  R/0[%eax] := x/8[%ecx]
                  return R/0[%eax]
                  *** Linearized code
camlCode__fmax_1039:
  x/8[%ecx] := R/0[%eax]
  R/7[%tos] := float64u[x/8[%ecx]]
  R/7[%tos] := float64u[y/9[%ebx]]
  if not R/7[%tos] >f R/7[%tos] goto L102
  R/0[%eax] := y/9[%ebx]
  return R/0[%eax]
  L102 [2]:
  R/0[%eax] := x/8[%ecx]
  return R/0[%eax]
  
Before TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047
     (if (>f x/1067 y/1068) (alloc[253] 2301 y/1068)
       (alloc[253] 2301 x/1067))
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048
     (if (>f x/1065 y/1066) (alloc[253] 2301 y/1066)
       (alloc[253] 2301 x/1065)))
  (alloc[254] 4350 (load float64u x/1047) (load float64u y/1048)))
x/1047 could be simplified
insert_load Calloc
insert_load Calloc
y/1048 could be simplified
insert_load Calloc
insert_load Calloc
After TonScmm.optimize:
(let
  (y/1068 (load float64u param/1056) x/1067 (load float64u param/1055)
   x/1047 (if (>f x/1067 y/1068) y/1068 x/1067)
   y/1066 (load float64u (+a param/1056 8))
   x/1065 (load float64u (+a param/1055 8))
   y/1048 (if (>f x/1065 y/1066) y/1066 x/1065))
  (alloc[254] 4350 x/1047 y/1048))
Before simplify
camlCode__min_point_1042:
                  param/8[%ecx] := R/0[%eax]
                  R/7[%tos] := float64u[param/9[%ebx]]
                  y/11[s2] := R/7[%tos]
                  R/7[%tos] := float64u[param/8[%ecx]]
                  x/13[s0] := R/7[%tos]
                  if not x/13[s0] >f y/11[s2] goto L106
                  goto L105
                  L106 [0]:
                  x/14[s2] := x/13[s0]
                  L105 [0]:
                  R/7[%tos] := float64u[param/9[%ebx] + 8]
                  y/16[s1] := R/7[%tos]
                  R/7[%tos] := float64u[param/8[%ecx] + 8]
                  x/18[s0] := R/7[%tos]
                  if not x/18[s0] >f y/16[s1] goto L104
                  y/19[s0] := y/16[s1]
                  L104 [0]:
                  {x/14[s2] y/19[s0]}
                  A/20[%eax] := alloc 20
                  [A/20[%eax] + -4] := 4350
                  float64u[A/20[%eax]] := x/14[s2]
                  float64u[A/20[%eax] + 8] := y/19[s0]
                  reload retaddr
                  return R/0[%eax]
                  *** Linearized code
camlCode__min_point_1042:
  param/8[%ecx] := R/0[%eax]
  R/7[%tos] := float64u[param/9[%ebx]]
  y/11[s2] := R/7[%tos]
  R/7[%tos] := float64u[param/8[%ecx]]
  x/13[s0] := R/7[%tos]
  if not x/13[s0] >f y/11[s2] goto L106
  goto L105
  L106 [2]:
  x/14[s2] := x/13[s0]
  L105 [3]:
  R/7[%tos] := float64u[param/9[%ebx] + 8]
  y/16[s1] := R/7[%tos]
  R/7[%tos] := float64u[param/8[%ecx] + 8]
  x/18[s0] := R/7[%tos]
  if not x/18[s0] >f y/16[s1] goto L104
  y/19[s0] := y/16[s1]
  L104 [4]:
  {x/14[s2] y/19[s0]}
  A/20[%eax] := alloc 20
  [A/20[%eax] + -4] := 4350
  float64u[A/20[%eax]] := x/14[s2]
  float64u[A/20[%eax] + 8] := y/19[s0]
  reload retaddr
  return R/0[%eax]
  
Before TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))
After TonScmm.optimize:
(let fmin/1036 "camlCode__3" (store "camlCode" fmin/1036)
  (let fmax/1039 "camlCode__2" (store (+a "camlCode" 4) fmax/1039)
    (let min_point/1042 "camlCode__1"
      (store (+a "camlCode" 8) min_point/1042) 1a)))
Before simplify
camlCode__entry:
                  fmin/8[%eax] := "camlCode__3"
                  ["camlCode"] := fmin/8[%eax]
                  fmax/9[%eax] := "camlCode__2"
                  ["camlCode" + 4] := fmax/9[%eax]
                  min_point/10[%eax] := "camlCode__1"
                  ["camlCode" + 8] := min_point/10[%eax]
                  A/11[%eax] := 1
                  return R/0[%eax]
                  *** Linearized code
camlCode__entry:
  fmin/8[%eax] := "camlCode__3"
  ["camlCode"] := fmin/8[%eax]
  fmax/9[%eax] := "camlCode__2"
  ["camlCode" + 4] := fmax/9[%eax]
  min_point/10[%eax] := "camlCode__1"
  ["camlCode" + 8] := min_point/10[%eax]
  A/11[%eax] := 1
  return R/0[%eax]
  
-S
	.data
	.globl	camlCode__data_begin
camlCode__data_begin:
	.text
	.globl	camlCode__code_begin
camlCode__code_begin:
	.data
	.long	3072
	.globl	camlCode
camlCode:
	.space	12
	.data
	.long	3319
camlCode__1:
	.long	caml_curry2
	.long	5
	.long	camlCode__min_point_1042
	.data
	.long	3319
camlCode__2:
	.long	caml_curry2
	.long	5
	.long	camlCode__fmax_1039
	.data
	.long	3319
camlCode__3:
	.long	caml_curry2
	.long	5
	.long	camlCode__fmin_1036
	.text
	.align	16
	.globl	camlCode__fmin_1036
camlCode__fmin_1036:
	subl	$8, %esp
.L101:
	movl	%eax, %ecx
	fldl	(%ebx)
	fldl	(%ecx)
	fcompp
	fnstsw	%ax
	andb	$69, %ah
	jne	.L100
	movl	%ebx, %eax
	addl	$8, %esp
	ret
	.align	16
.L100:
	movl	%ecx, %eax
	addl	$8, %esp
	ret
	.type	camlCode__fmin_1036,@function
	.size	camlCode__fmin_1036,.-camlCode__fmin_1036
	.text
	.align	16
	.globl	camlCode__fmax_1039
camlCode__fmax_1039:
	subl	$8, %esp
.L103:
	movl	%eax, %ecx
	fldl	(%ecx)
	fldl	(%ebx)
	fcompp
	fnstsw	%ax
	andb	$69, %ah
	jne	.L102
	movl	%ebx, %eax
	addl	$8, %esp
	ret
	.align	16
.L102:
	movl	%ecx, %eax
	addl	$8, %esp
	ret
	.type	camlCode__fmax_1039,@function
	.size	camlCode__fmax_1039,.-camlCode__fmax_1039
	.text
	.align	16
	.globl	camlCode__min_point_1042
camlCode__min_point_1042:
	subl	$24, %esp
.L107:
	movl	%eax, %ecx
	fldl	(%ebx)
	fstpl	16(%esp)
	fldl	(%ecx)
	fstpl	0(%esp)
	fldl	0(%esp)
	fcompl	16(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L106
	jmp	.L105
	.align	16
.L106:
	fldl	0(%esp)
	fstpl	16(%esp)
.L105:
	fldl	8(%ebx)
	fstpl	8(%esp)
	fldl	8(%ecx)
	fstpl	0(%esp)
	fldl	0(%esp)
	fcompl	8(%esp)
	fnstsw	%ax
	andb	$69, %ah
	jne	.L104
	fldl	8(%esp)
	fstpl	0(%esp)
.L104:
.L108:	movl	caml_young_ptr, %eax
	subl	$20, %eax
	movl	%eax, caml_young_ptr
	cmpl	caml_young_limit, %eax
	jb	.L109
	leal	4(%eax), %eax
	movl	$4350, -4(%eax)
	fldl	16(%esp)
	fstpl	(%eax)
	fldl	0(%esp)
	fstpl	8(%eax)
	addl	$24, %esp
	ret
.L109:	call	caml_call_gc
.L110:	jmp	.L108
	.type	camlCode__min_point_1042,@function
	.size	camlCode__min_point_1042,.-camlCode__min_point_1042
	.text
	.align	16
	.globl	camlCode__entry
camlCode__entry:
.L111:
	movl	$camlCode__3, %eax
	movl	%eax, camlCode
	movl	$camlCode__2, %eax
	movl	%eax, camlCode + 4
	movl	$camlCode__1, %eax
	movl	%eax, camlCode + 8
	movl	$1, %eax
	ret
	.type	camlCode__entry,@function
	.size	camlCode__entry,.-camlCode__entry
	.data
	.text
	.globl	camlCode__code_end
camlCode__code_end:
	.data
	.globl	camlCode__data_end
camlCode__data_end:
	.long	0
	.globl	camlCode__frametable
camlCode__frametable:
	.long	1
	.long	.L110
	.word	28
	.word	0
	.align	4

	.section .note.GNU-stack,"",%progbits
*)

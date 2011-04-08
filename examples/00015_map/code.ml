(* This example illustrates how a recursive function can be
   transformed in a loop.  The generated assembly code is very close,
   although iter2 could have been better optimized.
*)

(*

let rec iter1 f l =
  match l with
      [] -> ()
    | a::l -> f a; iter1 f l

let iter2 f l =
  let l = ref l in
    while
      match !l with
	  [] -> false
	| a :: lr ->
	    f a;
	    l := lr;
	    true
    do
      ()
    done
*)



let map1 =
  let z = List.map (fun x -> x + 1) [1;2;3] in
  let rec map1 f l =
    match l with
	[] -> z
      | a::l ->
	  let x = f a in
	    x :: (map1 f l)
  in
    map1

let list1 =
  map1 (fun x -> x+1) [1;2;3;4;5]


(*

  camlCode__iter1_58:
  subq    $24, %rsp
  .L101:
  movq    %rax, %rsi
  cmpq    $1, %rbx
  je      .L100
  movq    %rbx, 0(%rsp)
  movq    %rsi, 8(%rsp)
  movq    (%rbx), %rax
  movq    (%rsi), %rdi
  movq    %rsi, %rbx
  call    *%rdi
  movq    0(%rsp), %rax
  movq    8(%rax), %rbx
  movq    8(%rsp), %rax
  jmp     .L101
  .align  4
  .L100:
  movq    $1, %rax
  addq    $24, %rsp
  ret


  camlCode__iter2_63:
  subq    $24, %rsp
  movq    %rax, 0(%rsp)
  .L104:
  movq    %rbx, 8(%rsp)
  cmpq    $1, %rbx
  je      .L106
  movq    (%rbx), %rax
  movq    0(%rsp), %rbx
  movq    (%rbx), %rdi
  call    *%rdi
  movq    8(%rsp), %rax
  movq    8(%rax), %rbx
  movq    $3, %rax
  jmp     .L105
  .align  4
  .L106:
  movq    $1, %rax
  .L105:
  cmpq    $1, %rax
  jne     .L104
  movq    $1, %rax
  addq    $24, %rsp
  ret


  camlCode__iter1_58:
  subq    $24, %rsp
  .L101:
  movq    %rax, %rsi
  cmpq    $1, %rbx
  je      .L100
  movq    %rbx, 0(%rsp)
  movq    %rsi, 8(%rsp)
  movq    (%rbx), %rax
  movq    (%rsi), %rdi
  movq    %rsi, %rbx
  call    *%rdi
  movq    0(%rsp), %rax
  movq    8(%rax), %rbx
  movq    8(%rsp), %rax
  jmp     .L101
  .align  4
  .L100:
  movq    $1, %rax
  addq    $24, %rsp
  ret


  camlCode__iter2_63: (improved)
  subq    $24, %rsp
  movq    %rax, 0(%rsp)
  .L104:
  movq    %rbx, 8(%rsp)
  cmpq    $1, %rbx
  je      .L106
  movq    (%rbx), %rax
  movq    0(%rsp), %rbx
  movq    (%rbx), %rdi
  call    *%rdi
  movq    8(%rsp), %rax
  movq    8(%rax), %rbx
  jmp     .L104
  .align  4
  .L106:
  movq    $1, %rax
  addq    $24, %rsp
  ret

*)

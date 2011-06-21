let _ =
  more_flags := [ "-dclosure"; "-inline"; "100" ];
  comp_only := true;
  test_ocamlopt := true;
  test_ocamlc_opt := true;
  test_ocamlopt_opt := true;
;;

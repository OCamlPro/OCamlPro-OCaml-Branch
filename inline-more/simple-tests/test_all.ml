#!/usr/bin/ocaml

#load "unix.cma";;


module StringSet = Set.Make(String)

let comp_only = ref false
let more_flags = ref []
let tests_to_do = ref StringSet.empty
let test_ocamlc = ref false
let test_ocamlopt = ref false
let test_ocamlc_opt = ref false
let test_ocamlopt_opt = ref false

let arg_list = [
  "-f", Arg.String (fun s -> more_flags := s :: !more_flags), " <flag> : add a flag to the compiler";
  "-comp", Arg.Set comp_only, " : compile only, don't run tests";
  "-ocamlc", Arg.Set test_ocamlc, " : test ocamlc";
  "-ocamlopt", Arg.Set test_ocamlopt, " : test ocamlopt";
  "-ocamlc.opt", Arg.Set test_ocamlc_opt, " : test ocamlc.opt";
  "-ocamlopt.opt", Arg.Set test_ocamlopt_opt, " : test ocamlopt.opt";
  "-byte", Arg.Unit (fun _ -> test_ocamlc := true; test_ocamlc_opt := true), " : test ocamlc and ocamlc.opt";
  "-opt", Arg.Unit (fun _ -> test_ocamlopt := true; test_ocamlopt_opt := true), " : test ocamlopt and ocamlopt.opt";
  "-opt.opt", Arg.Unit (fun _ -> test_ocamlc_opt := true; test_ocamlopt_opt := true), " : test ocamlc.opt and ocamlopt.opt";
]
let arg_usage = "test_all [options] [tests]: perform tests to check current ocamlc/ocamlopt"

let _ =
  Arg.parse arg_list (fun test ->
    tests_to_do := StringSet.add test !tests_to_do) arg_usage
let more_flags = List.rev !more_flags
let do_test =
  if !tests_to_do = StringSet.empty then (fun _ -> true)
  else
    let tests_to_do = !tests_to_do in
    (fun test -> StringSet.mem test tests_to_do)
let test_all = not !test_ocamlc && not !test_ocamlopt && not !test_ocamlc_opt && not !test_ocamlopt_opt
let test_ocamlc = test_all || !test_ocamlc
let test_ocamlopt = test_all || !test_ocamlopt
let test_ocamlc_opt = test_all || !test_ocamlc_opt
let test_ocamlopt_opt = test_all || !test_ocamlopt_opt
let run_also = not !comp_only

let openflags =  [Unix.O_WRONLY; Unix.O_CREAT; Unix.O_TRUNC]

let b = Buffer.create 100
let create_process cmd args oc =
  Buffer.clear b;
  Printf.bprintf b "exec: \n%s" cmd;
  List.iter (fun arg ->
    Printf.bprintf b " %s" arg
  ) args;
  Buffer.add_char b '\n';
  let s = Buffer.contents b in
  ignore (Unix.write oc s 0 (String.length s));
  let args = Array.of_list (cmd :: args) in
  let pid = Unix.create_process cmd args Unix.stdin oc oc in
  pid

let rec wait_command pid =
  try
    let rec iter pid =
      let (_, status) = Unix.waitpid [] pid in
      match status with
	  Unix.WEXITED n -> n
	| Unix.WSIGNALED n -> n
	| _ -> iter pid
    in
    iter pid
  with e ->
    Printf.printf "Exception %s in waitpid\n%!" (Printexc.to_string e);
    exit 2
;;


let _ =
 Printexc.register_printer (fun exn ->
   match exn with
     Unix.Unix_error (error, s1, s2) ->
       Some (Printf.sprintf "Unix_error(%s, %s, %s)"
(Unix.error_message error) s1 s2)
   | _ -> None)
;;


let modules = Sys.readdir ".";;

let lines_of_file filename =
  let ic = open_in filename in
  let lines = ref [] in
  begin
    try
      while true do
	let line = input_line ic in
	lines := line :: !lines
      done
    with _ -> close_in ic
  end;
  List.rev !lines
;;

let read_config conf_filename byte_args opt_args =
  if Sys.file_exists conf_filename then begin
    Printf.fprintf stderr "Reading conf file %s\n%!" conf_filename;
    let lines = lines_of_file conf_filename in
    List.iter (fun line ->
      match line with
	  "" -> ()
	| "stdlib" ->
	  byte_args := !byte_args @ [ "-I"; "../stdlib"; "stdlib.cma" ];
	  opt_args := !opt_args @ [ "-I"; "../stdlib"; "stdlib.cmxa" ];
	| "unix" ->
	  byte_args := !byte_args @ [ "-I"; "../otherlibs/unix"; "unix.cma" ];
	  opt_args := !opt_args @ [ "-I"; "../otherlibs/unix"; "unix.cmxa" ];
	| "nums" ->
	  byte_args := !byte_args @ [ "-I"; "../otherlibs/nums"; "nums.cma" ];
	  opt_args := !opt_args @ [ "-I"; "../otherlibs/nums"; "nums.cmxa" ];
	| "nostdlib" ->
	  let args = [ "-nostdlib"; "-nopervasives"; "-I"; "Externals"; "Externals/externals.ml"; ]
	  in
	  byte_args := !byte_args @ args;
	  opt_args := !opt_args @ args;
	| _ ->
	  Printf.fprintf stderr "Unknown config line [%s]\n%!" (String.escaped line)
    ) lines;
  end
;;

let _ =
  Array.iter (fun file ->
    if Sys.is_directory file then
      let modname = file in
      let functions = Sys.readdir file in
      let byte_args = ref [] in
      let opt_args = ref [] in
      read_config (Filename.concat modname (modname ^ ".conf")) byte_args opt_args;
      Array.iter (fun funname ->
	let dirname = Filename.concat modname funname in
	if Sys.is_directory dirname then
	  let tests = Sys.readdir dirname in
	  let print_function = ref true in

	  let byte_args = ref !byte_args in
	  let opt_args = ref !opt_args in
	  read_config (Filename.concat dirname (funname ^ ".conf")) byte_args opt_args;
	  Array.iter (fun ml_file ->
	    (if Filename.check_suffix ml_file ".ml" then
		let ml_file = Filename.concat dirname ml_file in
		let basename = Filename.chop_suffix ml_file ".ml" in
		let testname = Filename.basename basename in
		let qualified_testname = Printf.sprintf "%s.%s.%s" modname funname testname in

		if do_test qualified_testname then

		  let keep_log = ref false in
		  if !print_function then begin
		    print_function := false;
		    Printf.fprintf stderr "Testing function %s.%s\n%!" modname funname;
		  end;

		  let byte_args = ref !byte_args in
		  let opt_args = ref !opt_args in
		  let conf_filename = Filename.concat basename ".conf" in
		  read_config conf_filename byte_args opt_args;

		  let test_log = basename ^ ".log" in
		  Printf.fprintf stderr "Test %s (%s)\n%!" qualified_testname test_log;
		  let fd = Unix.openfile test_log openflags 0o644 in

		  if test_ocamlc && Sys.file_exists "../ocamlc" then
		    begin (* ocamlc *)
		      let test_byte = basename ^ "_byte2byte.exe" in
		      let pid = create_process "../boot/ocamlrun"
			(
			[
			  "../ocamlc";
			  "-o"; test_byte;
			] @
			  !byte_args
			  @
			  more_flags
			  @ [
			  ml_file
			]) fd in
		      Printf.fprintf stderr "\t%s\tbyte.byte COMP\t%!" qualified_testname;
		      let status = wait_command pid in
		      Printf.fprintf stderr "%d\n%!" status;
		      if status = 0 && run_also then begin
			let pid = create_process
			  "../boot/ocamlrun" ["./" ^ test_byte ] fd in
			Printf.fprintf stderr "\t%s\tBYTE EXEC\t%!" qualified_testname;
			let status = wait_command pid in
			Printf.fprintf stderr "%d\n%!" (100 - status);
			if status <> 100 then keep_log := true;
		      end else keep_log := true;
		    end;

		  if test_ocamlopt && Sys.file_exists "../ocamlopt" then
		    begin (* ocamlc *)
		      let test_byte = basename ^ "byte2opt.exe" in
		      let pid = create_process "../boot/ocamlrun"
			([
			  "../ocamlopt";
			  "-o"; test_byte;
			  "../asmrun/libasmrun.a"; "-cclib"; "-ldl -lm";
			] @
			  !opt_args
			  @
			  more_flags
			  @ [
			  ml_file
			]) fd in
		      Printf.fprintf stderr "\t%s\topt.byte COMP\t%!" qualified_testname;
		      let status = wait_command pid in
		      Printf.fprintf stderr "%d\n%!" status;
		      if status = 0 && run_also then begin
			let pid = create_process
			  ("./" ^ test_byte) [] fd in
			Printf.fprintf stderr "\t%s\tASM EXEC\t%!" qualified_testname;
			let status = wait_command pid in
			Printf.fprintf stderr "%d\n%!" (100 - status);
			if status <> 100 then keep_log := true;
		      end else keep_log := true;
		    end;

		  if test_ocamlc_opt && Sys.file_exists "../ocamlc.opt" then
		    begin (* ocamlc.opt *)
		      let test_byte = basename ^ "opt2byte.exe" in
		      let pid = create_process "../ocamlc.opt"
			([
			  "-o"; test_byte;
			 ] @
			  !byte_args
			  @
			  more_flags
			  @ [
			  ml_file
			]) fd in
		      Printf.fprintf stderr "\t%s\tbyte.opt COMP\t%!" qualified_testname;
		      let status = wait_command pid in
		      Printf.fprintf stderr "%d\n%!" status;
		      if status = 0 && run_also then begin
			let pid = create_process
			  "../boot/ocamlrun" ["./" ^ test_byte ] fd in
			Printf.fprintf stderr "\t%s\tBYTE EXEC\t%!" qualified_testname;
			let status = wait_command pid in
			Printf.fprintf stderr "%d\n%!" (100 - status);
			if status <> 100 then keep_log := true;
		      end else keep_log := true;
		    end;

		  if test_ocamlopt_opt && Sys.file_exists "../ocamlopt.opt" then
		    begin (* ocamlopt.opt *)
		      let test_byte = basename ^ "opt2opt.exe" in
		      let pid = create_process "../ocamlopt.opt"
			([
			  "-o"; test_byte;
			  "../asmrun/libasmrun.a";"-cclib"; "-ldl -lm";
			] @
			  !opt_args
			  @
			  more_flags
			  @ [
			  ml_file
			]) fd in
		      Printf.fprintf stderr "\t%s\topt.opt COMP\t%!" qualified_testname;
		      let status = wait_command pid in
		      Printf.fprintf stderr "%d\n%!" status;
		      if status = 0 && run_also then begin
			let pid = create_process
			  ("./" ^ test_byte) [] fd in
			Printf.fprintf stderr "\t%s\tASM EXEC\t%!" qualified_testname;
			let status = wait_command pid in
			Printf.fprintf stderr "%d\n%!" (100 - status);
			if status <> 100 then keep_log := true;
		      end else keep_log := true;
		    end;

		  Unix.close fd;
	    (*		if not !keep_log then Sys.remove test_log; *)
	    )
	  ) tests
      ) functions
  ) modules
;;

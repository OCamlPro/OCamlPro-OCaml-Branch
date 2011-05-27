type pers_flags = Rectypes

type cmi_info = {
    cmi_name : string;
    cmi_sig : Types.signature_item list;
    mutable cmi_crcs : (string * Digest.t) list;
    cmi_flags : pers_flags list;
    cmi_arg_id : Ident.t;
(* For functors: this interface corresponds to a file that depends
   on these arguments, with the corresponding digests.
*)
    cmi_functor_args : (string * Digest.t) list;
(* For functors: this interface corresponds to a file that depends
   on these units, with the corresponding argument dependencies.
   The dependencies should be a suffix of the current dependencies.
*)
    cmi_functor_parts : (string * (string * Digest.t) list) list;
}

val input_cmi_info : in_channel -> cmi_info * Digest.t
val output_cmi_info : out_channel -> cmi_info -> Digest.t

type pers_flags = Rectypes

type cmi_info = {
    cmi_name : string;
    cmi_sig : Types.signature_item list;
    mutable cmi_crcs : (string * Digest.t) list;
    cmi_flags : pers_flags list;
    cmi_arg_id : Ident.t;
    cmi_functor_args : (string * Digest.t) list;
    cmi_functor_parts : (string * (string * Digest.t) list) list;
}

let input_cmi_info ic =
  let cmi = (input_value ic : cmi_info) in
  let cmi_crc = (input_value ic : Digest.t) in
  cmi, cmi_crc

let output_cmi_info oc cmi =
  let s = Marshal.to_string cmi [] in
  let crc = Digest.string s in
  output_string oc s;
  output_value oc crc;
  crc


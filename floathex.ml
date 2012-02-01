let help="floathex: Converts between float number and its bit representation" in
let float_to_hex flt=
  let str_of_float fl=
    let bit_rep=Int32.bits_of_float fl in
    let hexdigits_of number=
      let digitchars="0123456789ABCDEF" in
      let rec accum_digits bits restdigits result=
	if restdigits=0 then result else
	let lsdigit=Int32.logand bits (Int32.of_int 15) in
	let digitchr=String.get digitchars (Int32.to_int lsdigit) in
	String.set result (restdigits-1) digitchr;
	accum_digits (Int32.shift_right bits 4) (restdigits-1) result in
      accum_digits number 8 (String.create 8) in
    hexdigits_of bit_rep in
  try
    let hexstr=str_of_float flt in
    (print_float flt;
     print_string " -> ";
     print_string hexstr;
     print_string "\n")
  with Failure(_)->
    raise (Arg.Bad "invalid as a float")
and hex_to_float hx=
  let prefixed_input=
    let chr2=String.get hx 1 in
    if (String.get hx 0)='0' && (chr2='x' || chr2='X') then hx
    else "0x"^hx in
  try
    let bits=Int32.of_string prefixed_input in
    print_string hx;
    print_string " -> ";
    print_float (Int32.float_of_bits bits);
    print_string "\n" 
  with Failure(_)->
    raise (Arg.Bad "invalid as a hex number") in
let guess_and_dispatch str=
  if String.contains str '.' ||
  (String.compare (String.lowercase str) "nan")=0 ||
  (String.compare (String.lowercase str) "+inf")=0 || 
  (String.compare (String.lowercase str) "-inf")=0 then
    try
      let f=float_of_string str in
      float_to_hex f
    with Failure(_)->
      hex_to_float str
  else
    hex_to_float str in
let dispatch_input=
  let option_float= ("-f",Arg.Float float_to_hex, "float : convert float to hex")
  and option_int  = ("-h",Arg.String hex_to_float,"hex   : convert hex to float") in
  let parse_triplets=[option_float;option_int] and
      argvpos=ref 0 in
  let rec parse_loop _=
    if argvpos.contents<(Array.length Sys.argv) then
      let _=
	try
	  Arg.parse_argv ?current:(Some argvpos) Sys.argv 
	    parse_triplets guess_and_dispatch help
	with
	| Arg.Bad(x)->
	    let errarg=Array.get Sys.argv argvpos.contents in
	    begin
	      try
		guess_and_dispatch errarg
	      with Arg.Bad(_)->print_string x
	    end
	| Arg.Help(x)->print_string x
      in parse_loop ()
    else () in
  parse_loop () in
dispatch_input

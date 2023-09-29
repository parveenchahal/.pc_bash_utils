function hex_to_dec() {
  echo $((16#$1))
}

function dec_to_hex() {
  printf "%x\n" "$1"
}

function hex_to_bin() {
  local input=$(tr '[a-z]' '[A-Z]' <<< $1)
  echo "obase=2; ibase=16; $input" | bc
}

 alias bin-to-hexdump='xxd -ps'
 
 alias hexdump-to-bin='xxd -r -p'

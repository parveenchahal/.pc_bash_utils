function hex_to_dec() {
  echo $((16#$1))
}

function dec_to_hex() {
  printf "%x\n" "$1"
}

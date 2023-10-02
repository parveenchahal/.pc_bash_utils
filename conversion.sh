function num-hex-to-dec() {
  echo $((16#$1))
}

function num-dec-to-hex() {
  printf "%x\n" "$1"
}

function num-hex-to-bin() {
  py-print 'bin(int("a", 16))[2:]'
  #local input=$(tr '[a-z]' '[A-Z]' <<< $1)
  #echo "obase=2; ibase=16; $input" | bc
}

 alias bin-to-hexdump='xxd -ps'
 
 alias hexdump-to-bin='xxd -r -p'

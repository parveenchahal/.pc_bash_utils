function num-hex-to-dec() {
  printf "%d\n" "0x$1"
}

function num-dec-to-hex() {
  printf "%x\n" "$1"
}

function num-hex-to-bin() {
  py-print "bin(int(\"$1\", 16))[2:]"
  #local input=$(tr '[a-z]' '[A-Z]' <<< $1)
  #echo "obase=2; ibase=16; $input" | bc
}

function num-oct-to-dec() {
  printf "%d\n" "0$1"
}

function num-dec-to-oct() {
  printf "%o\n" "$1"
}

function num-oct-to-bin() {
  py-print "bin(int(\"$1\", 8))[2:]"
}

function num-dec-to-bin() {
  py-print "bin(int(\"$1\"))[2:]"
}

 alias bin-to-hexdump='xxd -ps'
 
 alias hexdump-to-bin='xxd -r -p'

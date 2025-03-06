function num-hex-to-dec() {
  printf "%d\n" "0x$1"
}

function num-dec-to-hex() {
  printf "%x\n" "$1"
}

function num-oct-to-dec() {
  printf "%d\n" "0$1"
}

function num-dec-to-oct() {
  printf "%o\n" "$1"
}

 alias bin-to-hexdump='xxd -ps'
 
 alias hexdump-to-bin='xxd -r -p'

if pbu.py.is_installed;
then

function num-oct-to-bin() {
  py-print "bin(int(\"$1\", 8))[2:]"
}

function num-dec-to-bin() {
  py-print "bin(int(\"$1\"))[2:]"
}

function num-hex-to-bin() {
  py-print "bin(int(\"$1\", 16))[2:]"
  #local input=$(tr '[a-z]' '[A-Z]' <<< $1)
  #echo "obase=2; ibase=16; $input" | bc
}

function num-bin-to-hex() {
  py-exec "
b = '$1'
if (len(b) % 4) != 0:
  b = ('0' * (4 - len(b) % 4)) + b
h = []
for i in range(0, len(b), 4):
  x = b[i:i + 4]
  h.append(hex(int(x, base=2))[2:])
print(''.join(h))
  "
}

function num-bin-to-dec() {
  local b="$(pbu.string.join '' "$@")"
  py-exec "
b = '$b'
print(int(b, base=2))
  "
}

fi

function char-to-ascii() {
  printf "%d\n" "'$1'"
}

function ascii-to-char() {
  printf "\x$(printf %x "$1")"
}

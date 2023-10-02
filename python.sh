function exec-py() {
cmd=$(
cat<<EOF
$@
EOF
)
python3 -c "$cmd"
}
function py-print() {
  exec-py "print($@)"
}

function py-exec() {
cmd=$(
cat<<EOF
$@
EOF
)
python3 -c "$cmd"
}
function py-print() {
  py-exec "print($@)"
}

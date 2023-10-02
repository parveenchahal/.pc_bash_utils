function py-print() {
cmd=$(
cat<<EOF
print($@)
EOF
)
python3 -c "$cmd"
}

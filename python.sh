alias run-test-py="python3 ~/.py-test.py"

complete -W "-e --editor" edit-test-py
function edit-test-py() {
  pbu_extract_arg 'e' 'editor' "$@" || REPLY=vim
  local editor="$REPLY"
  
  pbu_is_file_exist ~/.py-test.py || (echo 'Creating file $file_path'; touch ~/.py-test.py)
  cmd="$editor ~/.py-test.py"
  eval "$cmd"
}

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

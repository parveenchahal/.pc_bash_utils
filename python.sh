alias run-test-py="python3 ~/.py-test.py"

complete -W "-e --editor" edit-test-py
function edit-test-py() {
  pbu_extract_arg 'e' 'editor' "$@" || REPLY=vim
  local editor="$REPLY"
  
  local file_path="~/.py-test.py"
  pbu_is_file_exist $file_path || touch $file_path
  cmd="$editor $file_path"
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

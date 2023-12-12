alias pbu_py='python3'
function pbu_is_py_installed() {
  local out=$(pbu_py -c 'print("", end="")' 2>&1)
  [ "$out" == "" ] || return 1
  return 0
}

if pbu_is_py_installed;
then
  complete -W "--script-name" exec-py-script
  function exec-py-script() {
    pbu_extract_arg '' 'script-name' "$@" || pbu_error_echo "--script-name is required argument." || return 1
    local name="$REPLY"
    pbu_create_dir_if_does_not_exist ~/.py-script
    pushd ~/.py-script > /dev/null
    python3 "$name.py"
    popd > /dev/null
  }
  
  complete -W "--script-name --editor" edit-py-script
  function edit-py-script() {
    local basePath="$(realpath ~/.py-script)"
    pbu_extract_arg '' 'script-name' "$@" || pbu_error_echo "--script-name is required argument." || return 1
    local name="$REPLY"
    pbu_create_dir_if_does_not_exist ~/.py-script
    pbu_extract_arg '' 'editor' "$@" || REPLY=vim
    local editor="$REPLY"
    pbu_create_file_if_does_not_exist "$basePath/$name.py"
    eval "$editor \"$basePath/$name.py\""
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
fi

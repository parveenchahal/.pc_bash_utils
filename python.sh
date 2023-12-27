alias pbu_py='python3'
function pbu_is_py_installed() {
  local out=$(pbu_py -c 'print("", end="")' 2>&1)
  [ "$out" == "" ] || return 1
  return 0
}

if pbu_is_py_installed;
then

function pbu_complete-fn-exec-py-script(){
  if [ "$3" == "--script-name" ]
  then
    local values=()
    for file in ~/.py-script/*.py
    do
      local name="$(basename "$file")"
      values+=( "'$(printf %q "${name%.py}")'" )
    done
    values="$(pbu_string_join ' ' "${values[@]}")"
    COMPREPLY=( $(compgen -W "$values" -- "$2") )
  else
    COMPREPLY=( $(compgen -W "--script-name" -- "$2") )
  fi
}
complete -F pbu_complete-fn-exec-py-script exec-py-script
function exec-py-script() {
  pbu_extract_arg '' 'script-name:' "$@" || pbu_error_echo "--script-name is required argument." || return 1
  set -- "${REMAINING_ARGS[@]}"
  local name="$REPLY"
  pbu_create_dir_if_does_not_exist ~/.py-script
  pushd ~/.py-script > /dev/null
  pbu_py "$name.py" "$@"
  popd > /dev/null
}

function pbu_complete-fn-edit-py-script(){
  if [ "$3" == "--script-name" ]
  then
    local values=()
    for file in ~/.py-script/*.py
    do
      local name="$(basename "$file")"
      values+=( "'$(printf %q "${name%.py}")'" )
    done
    values="$(pbu_string_join ' ' "${values[@]}")"
    COMPREPLY=( $(compgen -W "$values" -- "$2") )
  else
    COMPREPLY=( $(compgen -W "--script-name --editor" -- "$2") )
  fi
}
complete -F pbu_complete-fn-edit-py-script edit-py-script
function edit-py-script() {
  local basePath="$(realpath ~/.py-script)"
  pbu_extract_arg '' 'script-name:' "$@" || pbu_error_echo "--script-name is required argument." || return 1
  local name="$REPLY"
  pbu_create_dir_if_does_not_exist ~/.py-script
  pbu_extract_arg '' 'editor:' "$@" || REPLY=vim
  local editor="$REPLY"
  pbu_create_file_if_does_not_exist "$basePath/$name.py"
  pbu_eval_cmd "$editor" "$basePath/$name.py"
}
  
function py-exec() {
cmd=$(
cat<<EOF
$@
EOF
)
pbu_py -c "$cmd"
}

function py-print() {
  py-exec "print($@)"
}

fi

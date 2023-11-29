function _pbu_create_exec_script_dir_if_not_created() {
  if [ ! -d ~/.exec-script ]
  then
    mkdir ~/.exec-script
  fi
}

complete -W "-n --name" exec-script
function exec-script() {
  pbu_extract_arg 'n' 'name' "$@" || pbu_error_echo "-n/--name is required argument." || return 1
  local name="$REPLY"
  _pbu_create_exec_script_dir_if_not_created
  cd ~/.exec-script
  if [ ! -f "$name.sh" ]
  then
    eval "touch \"$name\""
    eval "chmod +x \"$name.sh\""
  fi
  eval "bash \"$name.sh\""
  cd -
}

complete -W "-n --name -e --editor" edit-exec-script
function edit-exec-script() {
  local basePath="$(realpath ~/.exec-script)"
  pbu_extract_arg 'n' 'name' "$@" || pbu_error_echo "-n/--name is required argument." || return 1
  local name="$REPLY"
  _pbu_create_exec_script_dir_if_not_created
  pbu_extract_arg 'e' 'editor' "$@" || REPLY=vim
  local editor="$REPLY"
  if [ ! -f "$basePath/$name.sh" ]
  then
    eval "touch \"$basePath/$name.sh\""
    eval "chmod +x \"$basePath/$name.sh\""
  fi
  eval "$editor \"$basePath/$name.sh\""
}

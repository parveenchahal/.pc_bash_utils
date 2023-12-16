complete -W "--script-name" exec-bash-script
function exec-bash-script() {
  pbu_extract_arg '' 'script-name' "$@" || pbu_error_echo "--script-name is required argument." || return 1
  local name="$REPLY"
  pbu_create_dir_if_does_not_exist ~/.bash-script
  pushd ~/.bash-script > /dev/null
  eval ". \"./$name.sh\""
  popd > /dev/null
}

complete -W "--script-name --editor" edit-bash-script
function edit-bash-script() {
  local basePath="$(realpath ~/.bash-script)"
  pbu_extract_arg '' 'script-name' "$@" || pbu_error_echo "--script-name is required argument." || return 1
  local name="$REPLY"
  pbu_create_dir_if_does_not_exist ~/.bash-script
  pbu_extract_arg '' 'editor' "$@" || REPLY=vim
  local editor="$REPLY"
  if [ ! -f "$basePath/$name.sh" ]
  then
    eval "touch \"$basePath/$name.sh\""
    eval "chmod +x \"$basePath/$name.sh\""
  fi
  eval "$editor \"$basePath/$name.sh\""
}

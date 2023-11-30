complete -W "--script-name" exec-script
function exec-script() {
  pbu_extract_arg '' 'script-name' "$@" || pbu_error_echo "--script-name is required argument." || return 1
  local name="$REPLY"
  pbu_create_dir_if_does_not_exist ~/.exec-script
  cd ~/.exec-script
  eval "\"./$name.sh\" \"$@\""
  cd - > /dev/null 2>&1
}

complete -W "--script-name --editor" edit-exec-script
function edit-exec-script() {
  local basePath="$(realpath ~/.exec-script)"
  pbu_extract_arg '' 'script-name' "$@" || pbu_error_echo "--script-name is required argument." || return 1
  local name="$REPLY"
  pbu_create_dir_if_does_not_exist ~/.exec-script
  pbu_extract_arg '' 'editor' "$@" || REPLY=vim
  local editor="$REPLY"
  if [ ! -f "$basePath/$name.sh" ]
  then
    eval "touch \"$basePath/$name.sh\""
    eval "chmod +x \"$basePath/$name.sh\""
  fi
  eval "$editor \"$basePath/$name.sh\""
}

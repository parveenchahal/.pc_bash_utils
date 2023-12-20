function pbu_complete-fn-exec-bash-script(){
  if [ "$3" == "--script-name" ]
  then
    local values=()
    for file in ~/.bash-script/*.sh
    do
      local name="$(basename "$file")"
      values+=( "'$(printf %q "${name%.sh}")'" )
    done
    values="$(pbu_string_join ' ' "${values[@]}")"
    COMPREPLY=( $(compgen -W "$values" -- "$2") )
  else
    COMPREPLY=( $(compgen -W "--script-name --in-current-bash-session" -- "$2") )
  fi
}

complete -F pbu_complete-fn-exec-bash-script exec-bash-script
function exec-bash-script() {
  pbu_extract_arg '' 'script-name' "$@" || pbu_error_echo "--script-name is required argument." || return 1

  local name="$REPLY"
  pbu_create_dir_if_does_not_exist ~/.bash-script
  pushd ~/.bash-script > /dev/null
  if pbu_is_arg_switch_enabled '' 'in-current-bash-session' "$@";
  then
    eval ". \"./$name.sh\""
  else
    bash "$name.sh" "$@"
  fi
  popd > /dev/null
}


function pbu_complete-fn-edit-bash-script(){
  if [ "$3" == "--script-name" ]
  then
    local values=()
    for file in ~/.bash-script/*.sh
    do
      local name="$(basename "$file")"
      values+=( "'$(printf %q "${name%.sh}")'" )
    done
    values="$(pbu_string_join ' ' "${values[@]}")"
    COMPREPLY=( $(compgen -W "$values" -- "$2") )
  else
    COMPREPLY=( $(compgen -W "--script-name --editor" -- "$2") )
  fi
}

complete -F pbu_complete-fn-edit-bash-script edit-bash-script
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

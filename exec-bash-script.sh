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
  pbu.args.extract -l 'script-name:' -- "$@" || pbu.errors.echo "--script-name is required argument." || return 1
  local name="$REPLY"
  set -- "${REMAINING_ARGS[@]}"

  pbu_create_dir_if_does_not_exist ~/.bash-script
  pushd ~/.bash-script > /dev/null
  if pbu.args.is_switch_arg_enabled -l 'in-current-bash-session' -- "$@";
  then
    set -- "${REMAINING_ARGS[@]}"
    pbu.eval.cmd "." "./$name.sh" "$@"
  else
    set -- "${REMAINING_ARGS[@]}"
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
  pbu.args.extract -l 'script-name:' -- "$@" || pbu.errors.echo "--script-name is required argument." || return 1
  local name="$REPLY"
  pbu_create_dir_if_does_not_exist ~/.bash-script
  pbu.args.extract -l 'editor:' -- "$@" || REPLY=vim
  local editor="$REPLY"
  if [ ! -f "$basePath/$name.sh" ]
  then
    pbu.eval.cmd touch "$basePath/$name.sh"
    pbu.eval.cmd chmod +x "$basePath/$name.sh"
  fi
  pbu.eval.cmd "$editor" "$basePath/$name.sh"
}

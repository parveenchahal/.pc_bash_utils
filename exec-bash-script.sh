function ___pbu_complete-fn-exec-bash-script___(){
  if [ "$3" == "--script-name" ]
  then
    local values=()
    for file in ~/.bash-script/*.sh
    do
      local name="$(basename "$file")"
      values+=( "'$(printf %q "${name%.sh}")'" )
    done
    values="$(pbu.string.join ' ' "${values[@]}")"
    COMPREPLY=( $(compgen -W "$values" -- "$2") )
  else
    COMPREPLY=( $(compgen -W "--script-name --in-current-bash-session" -- "$2") )
  fi
}

complete -F ___pbu_complete-fn-exec-bash-script___ exec-bash-script
function exec-bash-script() {
  local name=()
  local remaining_args=()
  pbash.args.extract -l 'script-name:' -o name -r remaining_args -- "$@" || pbu.errors.echo "--script-name is required argument." || return 1

  set -- "${remaining_args[@]}"

  pbu.create_dir_if_does_not_exist ~/.bash-script
  pushd ~/.bash-script > /dev/null
  if pbash.args.is_switch_arg_enabled -l 'in-current-bash-session' -r remaining_args -- "$@";
  then
    set -- "${remaining_args[@]}"
    pbu.eval.cmd "." "./$name.sh" "$@"
  else
    set -- "${remaining_args[@]}"
    bash "$name.sh" "$@"
  fi
  popd > /dev/null
}


function ___pbu_complete-fn-edit-bash-script___(){
  if [ "$3" == "--script-name" ]
  then
    local values=()
    for file in ~/.bash-script/*.sh
    do
      local name="$(basename "$file")"
      values+=( "'$(printf %q "${name%.sh}")'" )
    done
    values="$(pbu.string.join ' ' "${values[@]}")"
    COMPREPLY=( $(compgen -W "$values" -- "$2") )
  else
    COMPREPLY=( $(compgen -W "--script-name --editor" -- "$2") )
  fi
}

complete -F ___pbu_complete-fn-edit-bash-script___ edit-bash-script
function edit-bash-script() {
  local basePath="$(realpath ~/.bash-script)"

  local name=()
  pbash.args.extract -l 'script-name:' -o name -- "$@" || pbu.errors.echo "--script-name is required argument." || return 1

  pbu.create_dir_if_does_not_exist ~/.bash-script

  local editor=()
  pbash.args.extract -l 'editor:' -o editor -d vim -- "$@" || return

  if [ ! -f "$basePath/$name.sh" ]
  then
    pbu.eval.cmd touch "$basePath/$name.sh"
    pbu.eval.cmd chmod +x "$basePath/$name.sh"
  fi
  pbu.eval.cmd "$editor" "$basePath/$name.sh"
}

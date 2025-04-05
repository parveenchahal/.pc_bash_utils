#!/usr/bin/env bash

alias py-json-tool='pbu.py -m json.tool'

if pbu.py.is_installed;
then

function ___pbu_complete-fn-exec-py-script___(){
  if [ "$3" == "--script-name" ]
  then
    local file
    local values=()
    for file in ~/.py-script/*.py
    do
      local name="$(basename "$file")"
      values+=( "'$(printf %q "${name%.py}")'" )
    done
    values="$(pbu.strings.join ' ' "${values[@]}")"
    COMPREPLY=( $(compgen -W "$values" -- "$2") )
  else
    COMPREPLY=( $(compgen -W "--script-name" -- "$2") )
  fi
}
complete -F ___pbu_complete-fn-exec-py-script___ exec-py-script
function exec-py-script() {
  local name=()
  local remaining_args=()
  pbash.args.extract -l 'script-name:' -o name -r remaining_args -- "$@" || pbu.errors.echo "--script-name is required argument." || return 1
  set -- "${remaining_args[@]}"

  pbu.create_dir_if_does_not_exist ~/.py-script
  pushd ~/.py-script > /dev/null
  pbu.py "$name.py" "$@"
  popd > /dev/null
}

function ___pbu_complete-fn-edit-py-script___(){
  if [ "$3" == "--script-name" ]
  then
    local file
    local values=()
    for file in ~/.py-script/*.py
    do
      local name="$(basename "$file")"
      values+=( "'$(printf %q "${name%.py}")'" )
    done
    values="$(pbu.strings.join ' ' "${values[@]}")"
    COMPREPLY=( $(compgen -W "$values" -- "$2") )
  else
    COMPREPLY=( $(compgen -W "--script-name --editor" -- "$2") )
  fi
}
complete -F ___pbu_complete-fn-edit-py-script___ edit-py-script
function edit-py-script() {
  local basePath="$(realpath ~/.py-script)"
  local name=()
  pbash.args.extract -l 'script-name:' -o name -- "$@" || pbu.errors.echo "--script-name is required argument." || return 1
  pbu.create_dir_if_does_not_exist ~/.py-script
  local editor=()
  pbash.args.extract -l 'editor:' -o editor -d vim -- "$@" || return
  pbu.create_file_if_does_not_exist "$basePath/$name.py"
  pbu.eval -- "$editor" "$basePath/$name.py"
}

fi

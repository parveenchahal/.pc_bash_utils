complete -W "--editor" tmp
function tmp() {
  local editor=()
  local remaining_args=()
  pbu.args.extract -l 'editor:' -o editor -r remaining_args -d vim -- "$@" || return

  set -- "${remaining_args[@]}"

  local path="$1"
  
  if [ -z "$path" ]
  then
    cd /tmp
    return 0
  fi
  
  local path="/tmp/$path"
  if [ -f "$path" ]
  then
    pbu.eval.cmd "$editor" "$path" || return
    return 0
  fi
  
  if [ -d "$path" ]
  then
    cd "$path"
    return 0
  fi

  pbu.errors.echo "Invalid path."
  return 1
}

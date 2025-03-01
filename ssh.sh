complete -W "-u --user -h --host -e --exit-master-connection -t --tmux -p" pssh
function pssh() {
  local args=( "$@" )
  local emc='false'
  local tm='false'
  pbash.args.is_switch_arg_enabled -s e -l exit-master-connection -r args -- "${args[@]}" && emc='true'
  pbash.args.is_switch_arg_enabled -s t -l tmux -r args -- "${args[@]}" && tm='true'
  local u=""
  local h=""
  pbash.args.extract -s u: -l user: -o u -r args -- "${args[@]}" || pbash.args.errors.echo "-u/--user is required" || return 1
  pbash.args.extract -s h: -l host: -o h -r args -- "${args[@]}" || pbash.args.errors.echo "-h/--host is required" || return 1

  if [ "$(hostname)" == "$h" ]
  then
    pbu.errors.echo "Client and server are same."
    return 1
  fi
  
  if [ "$emc" == "true" ]
  then
    ssh -Y -C -O exit "$u@$h" "${args[@]}"
    return 0
  fi

  if [ "$tm" == "true" ]
  then
    ssh -Y -C "$u@$h" "${args[@]}" -t bash -i -c 'ptmux'
    return 0
  fi
  ssh -Y -C "$u@$h" "${args[@]}"
}

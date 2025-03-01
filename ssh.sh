complete -W "-u --user -h --host -e --exit-master-connection -t --tmux -p --x11" pssh
function pssh() {
  local args=( "$@" )
  local ssh_args=()

  local u=""
  local h=""
  pbash.args.extract -s u: -l user: -o u -r args -- "${args[@]}" || pbash.args.errors.echo "-u/--user is required" || return 1
  pbash.args.extract -s h: -l host: -o h -r args -- "${args[@]}" || pbash.args.errors.echo "-h/--host is required" || return 1
  if [ "$(hostname)" == "$h" ]
  then
    pbu.errors.echo "Client and server are same."
    return 1
  fi
  
  pbash.args.is_switch_arg_enabled -s e -l exit-master-connection -r args -- "${args[@]}" && ssh_args+=( -O exit )
  pbash.args.is_switch_arg_enabled -l x11 -r args -- "${args[@]}" && ssh_args+=( -o "ForwardAgent yes" -Y -C )
  local tmux_cmd=()
  pbash.args.is_switch_arg_enabled -s t -l tmux -r args -- "${args[@]}" && tmux_cmd+=( -t bash -i -c 'ptmux' )
  
  pbu.eval.cmd_with_echo ssh "$u@$h" "${ssh_args[@]}" "${args[@]}" "${tmux_cmd[@]}"
}

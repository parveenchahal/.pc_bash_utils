complete -W "-u --user -h --host -e --exit-master-connection -t --tmux" pssh
function pssh() {
  local emc='false'
  local tm='false'
  pbash.args.is_switch_arg_enabled -s e -l exit-master-connection -- "$@" && emc='true'
  pbash.args.is_switch_arg_enabled -s t -l tmux -- "$@" && tm='true'
  local u=""
  local h=""
  pbash.args.extract -s u: -l user: -o u -- "$@" || pbash.args.errors.echo "-u/--user is required" || return 1
  pbash.args.extract -s h: -l host: -o h -- "$@" || pbash.args.errors.echo "-h/--host is required" || return 1

  if [ "$(hostname)" == "$h" ]
  then
    pbu.errors.echo "Client and server are same."
    return 1
  fi
  
  if [ "$emc" == "true" ]
  then
    ssh -Y -C -O exit "$u@$h"
    return 0
  fi

  if [ "$tm" == "true" ]
  then
    ssh -Y -C "$u@$h" -t bash -i -c 'ptmux'
    return 0
  fi
  ssh -Y -C "$u@$h"
}

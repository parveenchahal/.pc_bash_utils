complete -W "--escape_args -u --user -h --host -e --exit-master-connection -p --x11 --verbose" pssh
function pssh() {
  local args=( "$@" )

  local verbose="false"
  pbash.args.is_switch_arg_enabled -l verbose -r args -- "${args[@]}" && verbose="true"

  local escape_args="false"
  pbash.args.is_switch_arg_enabled -l escape_args -r args -- "${args[@]}" && escape_args="true"

  local ssh_args=()

  local u=""
  local h=""
  pbash.args.extract -s h: -l host: -o h -r args -- "${args[@]}" || pbash.args.errors.echo "-h/--host is required" || return 1
  pbash.args.extract -s u: -l user: -o u -r args -- "${args[@]}"

  if [ "$(hostname)" == "$h" ]
  then
    pbu.errors.echo "Client and server are same."
    return 1
  fi

  local uh="$h"

  [ -z "$u" ] || uh="$u@$uh"

  ssh_args+=( "$uh" )
  
  pbash.args.is_switch_arg_enabled -s e -l exit-master-connection -r args -- "${args[@]}" && ssh_args+=( -O exit )
  pbash.args.is_switch_arg_enabled -l x11 -r args -- "${args[@]}" && ssh_args+=( -o "ForwardAgent yes" -Y -C )
  if [ "$escape_args" == "true" ]; then
    local escape_args=()
    local x
    for x in "${args[@]}"; do
        escape_args+=( "$(pbu.strings.escape_string "$x")" )
    done
    args=( "${escape_args[@]}" )
  fi
  if [ "$verbose" == "true" ]; then
    pbu.eval.with_echo ssh "${ssh_args[@]}" "${args[@]}"
  else
    pbu.eval ssh "${ssh_args[@]}" "${args[@]}"
  fi
}

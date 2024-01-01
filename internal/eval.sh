function pbu.eval.format_string() {
  [[ "${#1}" -gt 20 ]]  && echo "\"$1\"" && return 0
  [[ "$1" == *\ * ]]  && echo "\"$1\"" && return 0
  [[ "$1" == *\&* ]]  && echo "\"$1\"" && return 0
  echo "$1"
}

function pbu.eval.cmd() {
  args=()
  for x in "$@"
  do
    args+=( "$(pbu.eval.format_string "$x")" )
  done
  local t=()
  set -- "${t[@]}"
  eval "${args[@]}"
}

function pbu.eval.cmd_with_echo() {
  args=()
  for x in "$@"
  do
    args+=( "$(pbu.eval.format_string "$x")" )
  done
  echo "Executing command: ${args[@]}"
  pbu.eval.cmd "$@"
}

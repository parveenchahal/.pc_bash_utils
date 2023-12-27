function pbu_format_string_for_eval() {
  [[ "${#1}" -gt 20 ]]  && echo "\"$1\"" && return 0
  [[ "$1" == *\ * ]]  && echo "\"$1\"" && return 0
  [[ "$1" == *\&* ]]  && echo "\"$1\"" && return 0
  echo "$1"
}

function pbu_eval_cmd() {
  args=()
  for x in "$@"
  do
    args+=( "$(pbu_format_string_for_eval "$x")" )
  done
  local t=()
  set -- "${t[@]}"
  eval "${args[@]}"
}

function pbu_eval_cmd_with_echo() {
  args=()
  for x in "$@"
  do
    args+=( "$(pbu_format_string_for_eval "$x")" )
  done
  echo "Executing command: ${args[@]}"
  pbu_eval_cmd "$@"
}

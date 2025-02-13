function pbu.eval.format_string() {
  [[ "${#1}" -gt 20 ]]  && echo "\"$1\"" && return 0
  [[ "$1" == *\ * ]]  && echo "\"$1\"" && return 0
  [[ "$1" == *\&* ]]  && echo "\"$1\"" && return 0
  echo "$1"
}

function pbu.eval.cmd() {
  local ____args____=()
  while [ "${#@}" -gt 0 ]
  do
    ____args____+=( "$(pbu.eval.format_string "$1")" )
    shift
  done
  local ____t____=()
  set -- "${____t____[@]}"
  eval "${____args____[@]}"
}

function pbu.eval.cmd_with_echo() {
  local ____args____=()
  local ____x____
  for ____x____ in "$@"
  do
    ____args____+=( "$(pbu.eval.format_string "$____x____")" )
  done
  echo "Executing command: ${____args____[@]}"
  pbu.eval.cmd "$@"
}

function pbu.eval.cmd_with_confirmation() {
  local ____args____=()
  local ____x____
  for ____x____ in "$@"
  do
    ____args____+=( "$(pbu.eval.format_string "$____x____")" )
  done
  echo "Executing command: ${____args____[@]}"
  pbu.confirm || return 1
  pbu.eval.cmd "$@"
}

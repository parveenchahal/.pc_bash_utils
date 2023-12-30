PBU_SUCCESS=0
PBU_ERROR=1
PBU_ERROR_USAGE=2

function pbu_error_echo() {
  echo -e "\e[01;31m${@}\e[0m"
  return $PBU_ERROR
}

function pbu_error_exit() {
  if [ ! -z "$1" ]
  then
    pbu_error_echo "$1"
  fi
  exit $PBU_ERROR
}

function pbu_is_error() {
  local err="$?"
  [ "$1" == "" ] || err="$1"
  [ "$err" == "0" ] || return $PBU_SUCCESS
  return $PBU_ERROR
}

function pbu_is_success() {
  pbu_is_error "$@" || return $PBU_SUCCESS
  return $PBU_ERROR
}

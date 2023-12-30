PBU_SUCCESS=0
PBU_ERROR=1
PBU_ERROR_USAGE=2
PBU_ERROR_NOT_FOUND=40

function pbu_get_error_code() {
  local err="$?"
  [ "$1" == "" ] || err="$1"
  printf "%s" "$err"
}

function pbu_error_echo() {
  echo -e "\e[01;31m${@}\e[0m"
  return $PBU_ERROR
}

function pbu_error_exit() {
  local err="$?"
  if [ ! -z "$1" ]
  then
    pbu_error_echo "$1"
  fi
  exit "$err"
}

function pbu_is_error() {
  local err="$(pbu_get_error_code "$@")"
  [ "$err" != "$PBU_SUCCESS" ] || return $PBU_ERROR
  return $PBU_SUCCESS
}

function pbu_is_success() {
  pbu_is_error "$@" || return $PBU_SUCCESS
  return $PBU_ERROR
}

function pbu_is_not_found_error() {
  local err="$(pbu_get_error_code "$@")"
  [ "$err" == "$PBU_ERROR_NOT_FOUND" ] || return $PBU_ERROR
  return $PBU_SUCCESS
}
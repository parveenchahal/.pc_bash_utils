PBU_SUCCESS=0
PBU_ERROR=1
PBU_ERROR_USAGE=2
PBU_ERROR_NOT_FOUND=40

function pbu.errors.get_error_code() {
  local err="$?"
  [ "$1" == "" ] || err="$1"
  printf "%s" "$err"
}

function pbu.errors.echo() {
  echo -e "\e[01;31m${@}\e[0m"
  return $PBU_ERROR
}

function pbu.errors.exit() {
  local err="$?"
  if [ ! -z "$1" ]
  then
    pbu.errors.echo "$1"
  fi
  exit "$err"
}

function pbu.errors.is_error() {
  local err="$(pbu.errors.get_error_code "$@")"
  [ "$err" != "$PBU_SUCCESS" ] || return $PBU_ERROR
  return $PBU_SUCCESS
}

function pbu.errors.is_success() {
  pbu.errors.is_error "$@" || return $PBU_SUCCESS
  return $PBU_ERROR
}

function pbu.errors.is_not_found_error() {
  local err="$(pbu.errors.get_error_code "$@")"
  [ "$err" == "$PBU_ERROR_NOT_FOUND" ] || return $PBU_ERROR
  return $PBU_SUCCESS
}
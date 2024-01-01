pbu.errors.SUCCESS=0
pbu.errors.ERROR=1
pbu.errors.ERROR_USAGE=2
pbu.errors.ERROR_NOT_FOUND=40

function pbu.errors.get_error_code() {
  local err="$?"
  [ "$1" == "" ] || err="$1"
  printf "%s" "$err"
}

function pbu.errors.echo() {
  echo -e "\e[01;31m${@}\e[0m"
  return $pbu.errors.ERROR
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
  [ "$err" != "$pbu.errors.SUCCESS" ] || return $pbu.errors.ERROR
  return $pbu.errors.SUCCESS
}

function pbu.errors.is_success() {
  pbu.errors.is_error "$@" || return $pbu.errors.SUCCESS
  return $pbu.errors.ERROR
}

function pbu.errors.is_not_found_error() {
  local err="$(pbu.errors.get_error_code "$@")"
  [ "$err" == "$pbu.errors.ERROR_NOT_FOUND" ] || return $pbu.errors.ERROR
  return $pbu.errors.SUCCESS
}
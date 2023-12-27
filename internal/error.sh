function pbu_error_echo() {
  echo -e "\e[01;31m${@}\e[0m"
  return 1
}

function pbu_error_exit() {
  if [ ! -z "$1" ]
  then
    pbu_error_echo "$1"
  fi
  exit 1
}

function pbu_is_error() {
  [ "$?" == "0" ] || return 0
  return 1
}

function pbu_is_success() {
  [ "$?" == "0" ] || return 1
  return 0
}

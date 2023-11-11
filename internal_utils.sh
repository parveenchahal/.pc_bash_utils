function pbu_is_equal() {
  if [ "$1" == "$2" ]
  then
    return 0
  fi
  return 1
}

function pbu_is_not_equal() {
  pbu_is_equal "$@" || return 0
  return 1
}

function pbu_is_digits() {
   [[ "$1" =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] || return 1
   return 0
}

function pbu_error_exit() {
  if [ ! -z "$1" ]
  then
    echo $1
  fi
  exit 1
}

function pbu_error_echo() {
  echo "$@"
  return 1
}

function pbu_echo_error() {
  pbu_error_echo "$@"
  return $?
}

function pbu_eval_cmd() {
  echo "Executing command: $@"
  eval "$@"
}

function pbu_read_input() {
  if [ ! -z "$1" ]
  then
    echo -n $1
  fi
  read
}

function pbu_is_empty() {
  if [ -z "$1" ]
  then
    return 0
  fi
  return 1
}

function pbu_is_not_empty() {
  pbu_is_empty "$1" || return 0
  return 1
}

function pbu_confirm() {
  local msg="Confirm"
  pbu_is_empty "$1" || msg="$1"
  while $true;
  do
    pbu_read_input "$msg (yes/no): "
    result=$REPLY
    if [ "$result" == "y" ] || [ "$result" == "yes" ];
    then
      return 0
    fi
    if [ "$result" == "n" ] || [ "$result" == "no" ];
    then
      return 1
    fi
  done
}

function pbu_is_file_exist() {
  pbu_is_not_empty "$1" || (echo "file path can not be empty"; return 1)
  if [ -f "$1" ]
  then
    return 0
  fi
  return 1
}

function pbu_read_input_date() {
  pbu_read_input "Date in UTC (YYYY-MM-DD): "
  local date_str=$REPLY
  if [ -z "$date_str" ]
  then
    date_str=$(date +"%FT%T.0Z")
    REPLY=$date_str
    return 0
  fi
  pbu_read_input "Time in UTC (HH:MM:SS): "
  local time_str=$REPLY
  if [ -z "$time_str" ]
  then
    time_str="00:00:00.0"
  fi
  REPLY="${date_str}T${time_str}.0Z"
  return 0
}

function pbu_copy_file_to_local_bin() {
  if [ ! -d ~/.local ]
  then
    mkdir ~/.local
  fi
  if [ ! -d ~/.local/bin ]
  then
    mkdir ~/.local/bin
  fi
  cp $1/$2 ~/.local/bin/
  chmod +rx ~/.local/bin/$2
}

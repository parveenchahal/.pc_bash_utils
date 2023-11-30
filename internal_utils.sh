function pbu_create_dir_if_does_not_exist() {
  local path="$1"
  local fullPath="$path"
  [[ "$path" =~ ^\/.* ]] && fullPath="$(realpath .)/$path"
  [[ "$path" =~ ^\~\/.* ]] && fullPath="$(realpath ~)/${path:2}"
  [ -d "$fullPath" ] || eval "mkdir \"$fullPath\""
}

function pbu_is_equal() {
  local x="$1"
  shift
  for y in "$@"
  do
    if [ "$x" != "$y" ]
    then
      return 1
    fi
  done
  return 0
}

function pbu_is_not_equal() {
  local size="${#@}"
  local lastIndex=`expr $size - 1`
  local values=( ${@} )
  local i=0
  while [ $i -lt $lastIndex ]
  do
    local j=`expr $i + 1`
    while [ $j -le $lastIndex ]
    do
      if [ "${values[$i]}" == "${values[$j]}" ]
      then
        return 1
      fi
      j=`expr $j + 1`
    done
    i=`expr $i + 1`
  done
  return 0
}

function pbu_is_digits() {
   [[ "$1" =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] || return 1
   return 0
}

function pbu_error_exit() {
  if [ ! -z "$1" ]
  then
    pbu_error_echo "$1"
  fi
  exit 1
}

function pbu_error_echo() {
  echo -e "\e[01;31m${@}\e[0m"
  return 1
}

function pbu_is_success() {
  pbu_is_equal "0" "$?" || return 1
  return 0
}

function pbu_is_error() {
  pbu_is_equal "0" "$?" || return 0
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
  pbu_is_equal "" "$@" || return 1
  return 0
}

function pbu_is_not_empty() {
  for x in "$@"
  do
    if [ "$x" == "" ]
    then
      return 1
    fi
  done
  return 0
}

function pbu_confirm() {
  local msg="Confirm"
  pbu_is_empty "$1" || msg="$1"
  while $true;
  do
    pbu_read_input "$msg (yes/no): "
    result="${REPLY,,}"
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

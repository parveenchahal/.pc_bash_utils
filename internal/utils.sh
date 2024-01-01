function pbu_read_input() {
  if [ ! -z "$1" ]
  then
    echo -n $1
  fi
  read
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

function pbu_get_full_path() {
  local path="$1"
  pbu_is_not_empty "$path" || pbu.errors.echo "path can not be empty" || return 1
  local fullPath="$path"
  [ "${path:0:1}" == "/" ] || fullPath="$(realpath .)/$path"
  [ "${path:0:2}" == "~/" ] && fullPath="$(realpath ~)/${path:2}"
  printf "%s" "$fullPath"
}

function pbu_is_file_exist() {
  local fullPath="$(pbu_get_full_path "$1")"
  [ -f "$fullPath" ] || return 1
  return 0
}

function pbu_is_dir_exist() {
  local fullPath="$(pbu_get_full_path "$1")"
  [ -d "$fullPath" ] || return 1
  return 0
}

function pbu_create_dir_if_does_not_exist() {
  local fullPath="$(pbu_get_full_path "$1")"
  [ -d "$fullPath" ] || pbu.eval.cmd mkdir -p "$fullPath"
}

function pbu_create_file_if_does_not_exist() {
  local fullPath="$(pbu_get_full_path "$1")"
  [ -f "$fullPath" ] || pbu.eval.cmd touch "$fullPath"
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

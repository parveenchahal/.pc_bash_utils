function pbu.read_input() {
  local pbu_read_input_out_var=()
  local pbu_read_input_remaing_args=()
  pbash.args.extract -s o: -l out-var: -o pbu_read_input_out_var -r pbu_read_input_remaing_args -- "$@"
  pbu.string.is_not_empty "$pbu_read_input_out_var" && local -n result="$pbu_read_input_out_var" || local result=()
  set -- "${pbu_read_input_remaing_args[@]}"
  
  result=""
  if [ ! -z "$1" ]
  then
    read -p "$1" || return
  else
    read || return
  fi
  result="${REPLY[@]}"
  return 0
}

function pbu.confirm() {
  local msg="Confirm"
  pbu.string.is_empty "$1" || msg="$1"
  while $true;
  do
    pbu.read_input "$msg (yes/no): " || return
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

function pbu.get_full_path() {
  local path="$1"
  pbu.string.is_not_empty "$path" || pbu.errors.echo "path can not be empty" || return 1
  local fullPath="$path"
  [ "${path:0:1}" == "/" ] || fullPath="$(realpath .)/$path"
  [ "${path:0:2}" == "~/" ] && fullPath="$(realpath ~)/${path:2}"
  printf "%s" "$fullPath"
}

function pbu.is_file_exist() {
  local fullPath="$(pbu.get_full_path "$1")"
  [ -f "$fullPath" ] || return 1
  return 0
}

function pbu.is_dir_exist() {
  local fullPath="$(pbu.get_full_path "$1")"
  [ -d "$fullPath" ] || return 1
  return 0
}

function pbu.create_dir_if_does_not_exist() {
  local fullPath="$(pbu.get_full_path "$1")"
  [ -d "$fullPath" ] || pbu.eval.cmd mkdir -p "$fullPath"
}

function pbu.create_file_if_does_not_exist() {
  local fullPath="$(pbu.get_full_path "$1")"
  [ -f "$fullPath" ] || pbu.eval.cmd touch "$fullPath"
}

function pbu.read_input_date() {
  pbu.read_input "Date in UTC (YYYY-MM-DD): "
  local date_str="$REPLY"
  if [ -z "$date_str" ]
  then
    date_str=$(date +"%FT%T.0Z")
    REPLY=$date_str
    return 0
  fi
  pbu.read_input "Time in UTC (HH:MM:SS): "
  local time_str="$REPLY"
  if [ -z "$time_str" ]
  then
    time_str="00:00:00.0"
  fi
  REPLY="${date_str}T${time_str}.0Z"
  return 0
}

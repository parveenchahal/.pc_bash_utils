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

function pbu_extract_arg() {
  local short_key="$1"
  shift
  local long_key="$1"
  shift
  
  local ARGS=''
  
  if [[ -z "$short_key" && -z "$long_key" ]]
  then
    echo 'No option provided to pbu_extract_arg'
    return 1
  elif [[ ! -z "$short_key" && ! -z "$long_key" ]]
  then
    ARGS=$(getopt -q -o "$short_key:" -l "$long_key:" -- "" "$@")
  elif [ ! -z "$short_key" ]
  then
    ARGS=$(getopt -q -o "$short_key:" -- "" "$@")
  elif [ ! -z "$long_key" ]
  then
    ARGS=$(getopt -q -l "$long_key:" -- "" "$@")
  fi
  
  eval set -- "$ARGS"

  REPLY=()
  local found=0
  while true ; do
    case "$1" in
      "--$long_key")
          REPLY+=("$2"); found=1 ; shift 2 ;;
      "-$short_key")
          REPLY+=("$2"); found=1 ; shift 2 ;;
      --) shift ; break ;;
      *) echo "Internal error in argument parsing!"; return 1 ;;
    esac
  done
  if [ "$found" == 0 ]
  then
    REPLY=""
    return 1
  fi
  return 0
}

function pbu_is_arg_present() {
  local short_key="$1"
  shift
  local long_key="$1"
  shift
  for x in "$@";
  do
    echo "$x $short_key $long_key"
    pbu_is_not_equal $x $short_key || return 0
    pbu_is_not_equal $x $long_key || return 0
  done
  return 1
}

function pbu_is_arg_not_present() {
  pbu_is_arg_present "$@" || return 0
  return 1
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
  while $true;
  do
    pbu_read_input "yes/no: "
    result=$REPLY
    if [ "$result" == "y" ] || [ "$result" == "yes" ];
    then
      return 1
    fi
    if [ "$result" == "n" ] || [ "$result" == "no" ];
    then
      return 0
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

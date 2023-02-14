function pc_error_exit() {
  if [ ! -z "$1" ]
  then
    echo $1
  fi
  exit 1
}

function pc_extract_arg() {
  local key="$1"
  shift
  while [[ $# -gt 0 ]] && [[ "$1" == "--"* ]] ;
  do
    opt="$1";
    shift;
    case "$opt" in
      "$key" )
         REPLY="$1"; shift;;
      "$key="* )
         REPLY="${opt#*=}";;
      *) return 1;;
   esac
  done
  return 0
}

function pc_read_input() {
  if [ ! -z "$1" ]
  then
    echo -n $1
  fi
  read
}

function pc_is_empty() {
  if [ -z $1 ]
  then
    return 1
  fi
  return 0
}

function pc_confirm() {
  while $true;
  do
    pc_read_input "y/n: "
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

function pc_is_file_exist() {
  pc_is_empty "$1"
  if [ "$?" == 1 ]
  then
    echo "file path can not be empty"
    return 0
  fi
  if [ -f "$1" ]
  then
    return 1
  fi
  return 0
}

function pc_read_input_date() {
  pc_read_input "Date in UTC (YYYY-MM-DD): "
  local date_str=$REPLY
  if [ -z "$date_str" ]
  then
    date_str=$(date +"%FT%T.0Z")
    REPLY=$date_str
    return 0
  fi
  pc_read_input "Time in UTC (HH:MM:SS): "
  local time_str=$REPLY
  if [ -z "$time_str" ]
  then
    time_str="00:00:00.0"
  fi
  REPLY="${date_str}T${time_str}.0Z"
  return 0
}

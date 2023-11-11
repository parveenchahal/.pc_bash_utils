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
  
  local ARGS=''
  
  if [[ -z "$short_key" && -z "$long_key" ]]
  then
    echo 'No option provided to pbu_extract_arg'
    return 1
  elif [[ ! -z "$short_key" && ! -z "$long_key" ]]
  then
    ARGS=$(getopt -q -o "$short_key::" -l "$long_key::" -- "" "$@")
  elif [ ! -z "$short_key" ]
  then
    ARGS=$(getopt -q -o "$short_key::" -- "" "$@")
  elif [ ! -z "$long_key" ]
  then
    ARGS=$(getopt -q -l "$long_key::" -- "" "$@")
  fi
  
  eval set -- "$ARGS"
  
  for x in "$@";
  do
    pbu_is_not_equal $x "-$short_key" || return 0
    pbu_is_not_equal $x "--$long_key" || return 0
  done
  return 1
}

function pbu_is_arg_not_present() {
  pbu_is_arg_present "$@" || return 0
  return 1
}

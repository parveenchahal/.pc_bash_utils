# function pbu_extract_arg() {
#   local short_key="$1"
#   shift
#   local long_key="$1"
#   shift
  
#   local ARGS=''
  
#   if [[ -z "$short_key" && -z "$long_key" ]]
#   then
#     echo 'No option provided to pbu_extract_arg'
#     return 1
#   elif [[ ! -z "$short_key" && ! -z "$long_key" ]]
#   then
#     ARGS=$(getopt -q -o "$short_key:" -l "$long_key:" -- "" "$@")
#   elif [ ! -z "$short_key" ]
#   then
#     ARGS=$(getopt -q -o "$short_key:" -- "" "$@")
#   elif [ ! -z "$long_key" ]
#   then
#     ARGS=$(getopt -q -l "$long_key:" -- "" "$@")
#   fi
  
#   eval set -- "$ARGS"

#   REPLY=()
#   local found=0
#   while true ; do
#     case "$1" in
#       "--$long_key")
#           REPLY+=("$2"); found=1 ; shift 2 ;;
#       "-$short_key")
#           REPLY+=("$2"); found=1 ; shift 2 ;;
#       --) shift ; break ;;
#       *) echo "Internal error in argument parsing!"; return 1 ;;
#     esac
#   done
#   if [ "$found" == 0 ]
#   then
#     REPLY=""
#     return 1
#   fi
#   return 0
# }

function pbu_extract_arg() {
  local short_key="$1"
  shift
  local long_key="$1"
  shift

  REMAINING_ARGS=( "$@" )
  REPLY=()

  [ "$short_key" != "" ] || [ "$long_key" != "" ] || return 1

  local short_is_switch_arg=0
  [ "$short_key" != "" ] && [[ ! "$short_key" =~ .*:$ ]] && short_is_switch_arg=1
  short_key=${short_key%:}

  local long_is_switch_arg=0
  [ "$long_key" != "" ] && [[ ! "$long_key" =~ .*:$ ]] && long_is_switch_arg=1
  long_key=${long_key%:}

  [ "$short_key" == "" ] || [ "$long_key" == "" ] || [ "$short_is_switch_arg" == "$long_is_switch_arg" ] || pbu_error_echo "Short and long args should be of same type either switch or key/value." || return 1

  local is_switch_arg=0
  [ "$short_is_switch_arg" == "1" ] && is_switch_arg=1
  [ "$long_is_switch_arg" == "1" ] && is_switch_arg=1

  REMAINING_ARGS=()

  local found=0
  while [ "${#@}" != "0" ] ; do
    if [[ "$1" == "--" || "$1" == "-" ]]
    then
      shift
      continue
    fi
    case "$1" in
      --$long_key|-$short_key)
          found=1 ;
          [ "$is_switch_arg" == "1" ] && [[ "$2" != "true" && "$2" != "false" ]] && REPLY+=( "true" ) ;
          [ "$2" != "" ] && [ "$is_switch_arg" == "1" ] && [[ "$2" == "true" || "$2" == "false" ]] && REPLY+=( "$2" ) && shift ;
          [ "$2" != "" ] && [ "$is_switch_arg" == "0" ] && REPLY+=( "$2" ) && shift
          ;;
      --$long_key=*)
          found=1 ;
          local val="${1#"--$long_key="}" ;
          [ "$is_switch_arg" == "0" ] || [[ "$val" == "true" || "$val" == "false" ]] || pbu_error_echo "Invalid valid for --$long_key. Expected true or false." || return 1 ;
          REPLY+=( "$val" )
          ;;
      -$short_key=*)
          found=1 ;
          local val="${1#"--$long_key="}" ;
          [ "$is_switch_arg" == "0" ] || [[ "$val" == "true" || "$val" == "false" ]] || pbu_error_echo "Invalid valid for -$short_key. Expected true or false." || return 1;
          REPLY+=( "$val" )
          ;;
      *)
          REMAINING_ARGS+=( "$1" );;
    esac
    shift
  done

  if [ "$found" == 0 ]
  then
    REPLY=()
    return 1
  fi
  return 0
}

# function pbu_is_arg_present() {
#   local short_key="$1"
#   shift
#   local long_key="$1"
#   shift
  
#   local ARGS=''
  
#   if [[ -z "$short_key" && -z "$long_key" ]]
#   then
#     echo 'No option provided to pbu_extract_arg'
#     return 1
#   elif [[ ! -z "$short_key" && ! -z "$long_key" ]]
#   then
#     ARGS=$(getopt -q -o "$short_key::" -l "$long_key::" -- "" "$@")
#   elif [ ! -z "$short_key" ]
#   then
#     ARGS=$(getopt -q -o "$short_key::" -- "" "$@")
#   elif [ ! -z "$long_key" ]
#   then
#     ARGS=$(getopt -q -l "$long_key::" -- "" "$@")
#   fi
  
#   eval set -- "$ARGS"
  
#   for x in "$@";
#   do
#     if [ "$x" == "--" ]
#     then
#       break
#     fi
#     [[ ! "$x" == "-$short_key" ]] || return 0
#     [[ ! "$x" == "--$long_key" ]] || return 0
#   done
#   return 1
# }

function pbu_is_switch_arg_enabled() {
  local short_key="$1"
  shift
  local long_key="$1"
  shift
  pbu_extract_arg "$short_key" "$long_key" "$@" || return 1
  local value="$REPLY"
  [ "$value" == "false" ] && return 1
  [ "$value" == "true" ] && return 0
  return 1
}

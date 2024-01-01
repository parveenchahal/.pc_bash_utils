complete -W "-s --short -l --long -d --default-value -v --values-var -r --remaining-args-var" pbu_extract_arg
function pbu_extract_arg() {

  local SPLITED_ARGS1=()
  local SPLITED_ARGS2=()
  ___pbu_split_args_by_double_hyphen___ "$@" || return $PBU_ERROR_USAGE
  local internal_args=( ${SPLITED_ARGS1[@]} )
  local external_args=( ${SPLITED_ARGS2[@]} )

  local REPLY=()
  local REMAINING_ARGS=()

  ___pbu_extract_arg___ 'v:' 'values-var:' "${internal_args[@]}" && local -n out_values="$REPLY" || local out_values

  ___pbu_extract_arg___ 'r:' 'remaining-args-var:' "${internal_args[@]}" && local -n out_remaining_args="$REPLY" || local out_remaining_args

  out_values=()
  out_remaining_args=( "$@" )

  REPLY=()

  ___pbu_extract_arg___ 's:' 'short:' "${internal_args[@]}"
  local short_key="$REPLY"
  ___pbu_extract_arg___ 'l:' 'long:' "${internal_args[@]}"
  local long_key="$REPLY"
  ___pbu_extract_arg___ 'd:' 'default-value:' "${internal_args[@]}"
  local default_value="${REPLY[@]}"

  ___pbu_extract_arg___ "$short_key" "$long_key" "${external_args[@]}"
  local err=$?
  out_values=( ${REPLY[@]} )
  out_remaining_args=( ${REMAINING_ARGS[@]} )

  pbu_is_not_found_error "$err" || return $err
  [ "${default_value[@]}" != "" ] || return $err

  out_values=( ${default_value[@]} )
  return 0
}

complete -W "-s --short -l --long -r --remaining-args-var" pbu_delete_arg
function pbu_delete_arg() {
  local REPLY=()
  ___pbu_extract_arg___ 'v:' 'values-var:' "$@" && local -n out_values="$REPLY" || local out_values
  pbu_extract_arg "$@"
  local err=$?
  out_values=()
  pbu_is_not_found_error $err || return $err
  return 0
}

complete -W "-s --short -l --long" pbu_is_switch_arg_enabled
function pbu_is_switch_arg_enabled() {
  local SPLITED_ARGS1=()
  local SPLITED_ARGS2=()
  ___pbu_split_args_by_double_hyphen___ "$@" || return $PBU_ERROR_USAGE
  local internal_args=( ${SPLITED_ARGS1[@]} )
  local external_args=( ${SPLITED_ARGS2[@]} )

  pbu_delete_arg -s d -l default-value -- ${internal_args[@]}
  internal_args=( ${REPLY[@]} )
  internal_args+=( -d false )

  pbu_extract_arg "${internal_args[@]}" -- "${external_args[@]}"
  local err=$?

  pbu_is_success $err || return $err

  local value="$REPLY"
  [ "$value" == "false" ] && return 1
  [ "$value" == "true" ] && return 0
  return 1
}

complete -W "-s --short -l --long" pbu_atleast_one_arg_present
function pbu_atleast_one_arg_present() {
  local SPLITED_ARGS1=()
  local SPLITED_ARGS2=()
  ___pbu_split_args_by_double_hyphen___ "$@" || return $PBU_ERROR_USAGE
  local internal_args=( ${SPLITED_ARGS1[@]} )
  local external_args=( ${SPLITED_ARGS2[@]} )
  pbu_delete_arg -s d -l default-value -- ${internal_args[@]} || return $?
  internal_args=( ${REPLY[@]} )

  pbu_extract_arg -s 's:' -l 'short:' -- "${internal_args[@]}"
  local err=$?
  local short_args=(${REPLY[@]})
  pbu_is_success $err || pbu_is_not_found_error $err || return $err

  pbu_extract_arg -s 'l:' -l 'long:' -- "${internal_args[@]}"
  local err=$?
  local long_args=(${REPLY[@]})
  pbu_is_success $err || pbu_is_not_found_error $err || return $err

  for k in "${short_args[@]}"
  do
    pbu_extract_arg -s "$k" -- "${external_args[@]}"
    err=$?
    REPLY=()
    pbu_is_success $err && return $PBU_SUCCESS
    pbu_is_not_found_error $err || return $err
  done

  for k in "${long_args[@]}"
  do
    pbu_extract_arg -l "$k" -- "${external_args[@]}"
    err=$?
    REPLY=()
    pbu_is_success $err && return $PBU_SUCCESS
    pbu_is_not_found_error $err || return $err
  done

  REPLY=()
  return $PBU_ERROR
}

complete -W "-s --short -l --long" pbu_all_args_present
function pbu_all_args_present() {
  local SPLITED_ARGS1=()
  local SPLITED_ARGS2=()
    ___pbu_split_args_by_double_hyphen___ "$@" || return $PBU_ERROR_USAGE
  local internal_args=( ${SPLITED_ARGS1[@]} )
  local external_args=( ${SPLITED_ARGS2[@]} )
  pbu_delete_arg -s d -l default-value -- ${internal_args[@]} || return $?
  internal_args=( ${REPLY[@]} )

  pbu_extract_arg -s 's:' -l 'short:' -- "${internal_args[@]}"
  local err=$?
  local short_args=(${REPLY[@]})
  pbu_is_success $err || pbu_is_not_found_error $err || return $err

  pbu_extract_arg -s 'l:' -l 'long:' -- "${internal_args[@]}"
  local err=$?
  local long_args=(${REPLY[@]})
  pbu_is_success $err || pbu_is_not_found_error $err || return $err

  for k in "${short_args[@]}"
  do
    pbu_extract_arg -s "$k" -- "${external_args[@]}"
    err=$?
    REPLY=()
    pbu_is_success $err || return $err
  done

  for k in "${long_args[@]}"
  do
    pbu_extract_arg -l "$k" -- "${external_args[@]}"
    err=$?
    REPLY=()
    pbu_is_success $err || return $err
  done

  REPLY=()
  return $PBU_SUCCESS
}


#============================================================================
# Below functions should be used in this file only.

function ___pbu_split_args_by_double_hyphen___() {
  local -n args1='SPLITED_ARGS1'
  local -n args2='SPLITED_ARGS2'

  local found_split=0

  while [ $# -gt 0 ]
  do
    if [ "$1" == "--" ]
    then
      found_split=1
      shift
      break
    fi
    args1+=( "$1" )
    shift
  done
  if [ $found_split == 0 ]
  then
    args1=()
    args2=()
    return 1
  fi
  args2=( ${@} )
}

function ___pbu_extract_arg___() {
  local short_key="$1"
  shift
  local long_key="$1"
  shift

  local -n remaining_args='REMAINING_ARGS'
  local -n reply='REPLY'

  remaining_args=( "$@" )
  reply=()

  [ "$short_key" != "" ] ||
  [ "$long_key" != "" ] ||
  pbu_error_echo "At least one of either short or long option is required" || return $PBU_ERROR_USAGE

  local short_is_switch_arg=0
  [ "$short_key" != "" ] && [[ ! "$short_key" =~ .*:$ ]] && short_is_switch_arg=1
  short_key=${short_key%:}

  local long_is_switch_arg=0
  [ "$long_key" != "" ] && [[ ! "$long_key" =~ .*:$ ]] && long_is_switch_arg=1
  long_key=${long_key%:}

  [ "$short_key" == "" ] ||
  [ "$long_key" == "" ] ||
  [ "$short_is_switch_arg" == "$long_is_switch_arg" ] ||
  pbu_error_echo "Short and long args should be of same type either switch or key/value." || return $PBU_ERROR_USAGE

  local is_switch_arg=0
  [[ "$short_is_switch_arg" == "1" || "$long_is_switch_arg" == "1" ]] && is_switch_arg=1

  remaining_args=()

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
          [ "$is_switch_arg" == "1" ] && [[ "$2" != "true" && "$2" != "false" ]] && reply+=( "true" ) ;
          [ "$2" != "" ] && [ "$is_switch_arg" == "0" ] && [[ "$2" =~ ^-.* ]] && reply+=( "" ) ;
          [ "$2" != "" ] && [ "$is_switch_arg" == "1" ] && [[ "$2" == "true" || "$2" == "false" ]] && reply+=( "$2" ) && shift ;
          [ "$is_switch_arg" == "0" ] && [[ ! "$2" =~ ^-.* ]] && reply+=( "$2" ) && shift
          ;;
      --$long_key=*)
          found=1 ;
          local val="${1#"--$long_key="}" ;
          [ "$is_switch_arg" == "0" ] ||
          [[ "$val" == "true" || "$val" == "false" ]] ||
          pbu_error_echo "Invalid valid for --$long_key. Expected true or false." ||
          return $PBU_ERROR_USAGE ;

          reply+=( "$val" )
          ;;
      -$short_key=*)
          found=1 ;
          local val="${1#"-$short_key="}" ;
          [ "$is_switch_arg" == "0" ] ||
          [[ "$val" == "true" || "$val" == "false" ]] ||
          pbu_error_echo "Invalid valid for -$short_key. Expected true or false." ||
          return $PBU_ERROR_USAGE;

          reply+=( "$val" )
          ;;
      *)
          remaining_args+=( "$1" );;
    esac
    shift
  done

  if [ "$found" == 0 ]
  then
    reply=()
    return $PBU_ERROR_NOT_FOUND
  fi
  return 0
}




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

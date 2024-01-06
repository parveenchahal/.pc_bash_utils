complete -W "-s --short -l --long -d --default-value -o --out-values-var -r --remaining-args-var" pbu.args.extract
function pbu.args.extract() {
  local _____SPLITED_ARGS1_____=()
  local _____SPLITED_ARGS2_____=()
  ___pbu_split_args_by_double_hyphen___ "$@" || return $PBU_ERROR_USAGE
  local internal_args=( "${_____SPLITED_ARGS1_____[@]}" )
  local external_args=( "${_____SPLITED_ARGS2_____[@]}" )

  local _____REPLY_____=()
  local _____REMAINING_ARGS_____=()

  ___pbu_extract_arg___ 'o:' 'out-values-var:' "${internal_args[@]}" && local -n out_values="$_____REPLY_____" || local out_values

  ___pbu_extract_arg___ 'r:' 'remaining-args-var:' "${internal_args[@]}" && local -n out_remaining_args="$_____REPLY_____" || local out_remaining_args

  out_values=()
  out_remaining_args=( "${external_args[@]}" )

  _____REPLY_____=()

  ___pbu_extract_arg___ 's:' 'short:' "${internal_args[@]}"
  local short_keys=( "${_____REPLY_____[@]}" )
  [ ${#short_keys[@]} -lt 2 ] || pbu.errors.echo "Multiple short args can not be handled" || return $PBU_ERROR_USAGE

  ___pbu_extract_arg___ 'l:' 'long:' "${internal_args[@]}"
  local long_keys=( "${_____REPLY_____[@]}" )
  [ ${#long_keys[@]} -lt 2 ] || pbu.errors.echo "Multiple long args can not be handled" || return $PBU_ERROR_USAGE

  ___pbu_extract_arg___ 'd:' 'default-value:' "${internal_args[@]}"
  local default_value=( "${_____REPLY_____[@]}" )

  ___pbu_extract_arg___ "$short_keys" "$long_keys" "${external_args[@]}"
  local err=$?
  out_values=( "${_____REPLY_____[@]}" )
  out_remaining_args=( "${_____REMAINING_ARGS_____[@]}" )

  pbu.errors.is_not_found_error "$err" || return $err
  [ "${#default_value[@]}" != "0" ] || return $err

  out_values=( "${default_value[@]}" )
  return 0
}

complete -W "-s --short -l --long -o --out-values-var" pbu.args.delete
function pbu.args.delete() {
  local _____SPLITED_ARGS1_____=()
  local _____SPLITED_ARGS2_____=()
  ___pbu_split_args_by_double_hyphen___ "$@" || return $PBU_ERROR_USAGE
  local internal_args=( "${_____SPLITED_ARGS1_____[@]}" )
  local external_args=( "${_____SPLITED_ARGS2_____[@]}" )

  local pbu_args_delete_out_values_var_name=()
  pbu.args.extract -s 'o:' -l 'out-values-var:' -o pbu_args_delete_out_values_var_name -- "${internal_args[@]}"
  local err=$?
  pbu.errors.is_not_found_error $err && pbu.errors.echo "-o/--out-values-var is required arg"
  pbu.errors.is_error $err && return $err

  pbu.args.extract -r $pbu_args_delete_out_values_var_name "${internal_args[@]}" -- "${external_args[@]}"
  local err=$?
  pbu.errors.is_not_found_error $err || return $err
  return 0
}

complete -W "-s --short -l --long -r --remaining-args-var" pbu.args.is_switch_arg_enabled
function pbu.args.is_switch_arg_enabled() {
  local _____SPLITED_ARGS1_____=()
  local _____SPLITED_ARGS2_____=()
  ___pbu_split_args_by_double_hyphen___ "$@" || return $PBU_ERROR_USAGE
  local internal_args=( "${_____SPLITED_ARGS1_____[@]}" )
  local external_args=( "${_____SPLITED_ARGS2_____[@]}" )

  local pbu_args_is_switch_arg_enabled_remaining_args=()
  pbu.args.delete -s d -l default-value -o pbu_args_is_switch_arg_enabled_remaining_args -- "${internal_args[@]}"
  internal_args=( "${pbu_args_is_switch_arg_enabled_remaining_args[@]}" )
  internal_args+=( -d false )

  local pbu_args_is_switch_arg_enabled_short_args=()
  pbu.args.extract -s "s:" -l "short:" -o pbu_args_is_switch_arg_enabled_short_args -- "${internal_args[@]}"

  local pbu_args_is_switch_arg_enabled_long_args=()
  pbu.args.extract -s "l:" -l "long:" -o pbu_args_is_switch_arg_enabled_long_args -- "${internal_args[@]}"

  local all_args=()
  all_args+=( "${pbu_args_is_switch_arg_enabled_short_args[@]}" )
  all_args+=( "${pbu_args_is_switch_arg_enabled_long_args[@]}" )

  local k
  for k in "${all_args[@]}"
  do
    [[ ! "$k" =~ .*:$ ]] || pbu.errors.echo "pbu.args.is_switch_arg_enabled can't take value args." || return $PBU_ERROR_USAGE
  done

  local pbu_args_is_switch_arg_enabled_value=()
  pbu.args.extract -o pbu_args_is_switch_arg_enabled_value "${internal_args[@]}" -- "${external_args[@]}"
  local err=$?

  pbu.errors.is_success $err || return $err

  [ "$pbu_args_is_switch_arg_enabled_value" == "false" ] && return 1
  [ "$pbu_args_is_switch_arg_enabled_value" == "true" ] && return 0
  return 1
}

complete -W "-s --short -l --long " pbu.args.any_switch_arg_enabled
function pbu.args.any_switch_arg_enabled() {
  local _____SPLITED_ARGS1_____=()
  local _____SPLITED_ARGS2_____=()
  ___pbu_split_args_by_double_hyphen___ "$@" || return $PBU_ERROR_USAGE
  local internal_args=( "${_____SPLITED_ARGS1_____[@]}" )
  local external_args=( "${_____SPLITED_ARGS2_____[@]}" )

  local pbu_args_any_switch_arg_enabled_remaining_args=()
  pbu.args.delete -s d -l default-value -o pbu_args_any_switch_arg_enabled_remaining_args -- "${internal_args[@]}"
  internal_args=( "${pbu_args_any_switch_arg_enabled_remaining_args[@]}" )
  internal_args+=( -d false )
  
  # declaring to avoid modifying variable from parent function.
  local remaining_args=()

  local pbu_args_any_switch_arg_enabled_short_args=()
  pbu.args.extract -s "s:" -l "short:" -o pbu_args_any_switch_arg_enabled_short_args -- "${internal_args[@]}"

  local pbu_args_any_switch_arg_enabled_long_args=()
  pbu.args.extract -s "l:" -l "long:" -o pbu_args_any_switch_arg_enabled_long_args -- "${internal_args[@]}"

  local k
  for k in "${pbu_args_any_switch_arg_enabled_short_args[@]}"
  do
    pbu.args.is_switch_arg_enabled -s "$k" -- "${external_args[@]}" && return 0
  done
  
  for k in "${pbu_args_any_switch_arg_enabled_long_args[@]}"
  do
    pbu.args.is_switch_arg_enabled -l "$k" -- "${external_args[@]}" && return 0
  done
  return 1
}

complete -W "-s --short -l --long" pbu.args.atleast_one_arg_present
function pbu.args.atleast_one_arg_present() {
  local _____SPLITED_ARGS1_____=()
  local _____SPLITED_ARGS2_____=()
  ___pbu_split_args_by_double_hyphen___ "$@" || return $PBU_ERROR_USAGE
  local internal_args=( "${_____SPLITED_ARGS1_____[@]}" )
  local external_args=( "${_____SPLITED_ARGS2_____[@]}" )

  local short_args=()
  pbu.args.extract -s 's:' -l 'short:' -o short_args -- "${internal_args[@]}"
  local err=$?
  pbu.errors.is_success $err || pbu.errors.is_not_found_error $err || return $err

  local long_args=()
  pbu.args.extract -s 'l:' -l 'long:' -o long_args -- "${internal_args[@]}"
  local err=$?
  pbu.errors.is_success $err || pbu.errors.is_not_found_error $err || return $err

  local k
  for k in "${short_args[@]}"
  do
    pbu.args.extract -s "$k" -- "${external_args[@]}"
    err=$?
    pbu.errors.is_success $err && return $PBU_SUCCESS
    pbu.errors.is_not_found_error $err || return $err
  done

  for k in "${long_args[@]}"
  do
    pbu.args.extract -l "$k" -- "${external_args[@]}"
    err=$?
    pbu.errors.is_success $err && return $PBU_SUCCESS
    pbu.errors.is_not_found_error $err || return $err
  done
  return $PBU_ERROR
}

complete -W "-s --short -l --long" pbu.args.all_args_present
function pbu.args.all_args_present() {
  local _____SPLITED_ARGS1_____=()
  local _____SPLITED_ARGS2_____=()
    ___pbu_split_args_by_double_hyphen___ "$@" || return $PBU_ERROR_USAGE
  local internal_args=( "${_____SPLITED_ARGS1_____[@]}" )
  local external_args=( "${_____SPLITED_ARGS2_____[@]}" )

  local short_args=()
  pbu.args.extract -s 's:' -l 'short:' -o short_args -- "${internal_args[@]}"
  local err=$?
  pbu.errors.is_success $err || pbu.errors.is_not_found_error $err || return $err

  local long_args=()
  pbu.args.extract -s 'l:' -l 'long:' -o long_args -- "${internal_args[@]}"
  local err=$?
  pbu.errors.is_success $err || pbu.errors.is_not_found_error $err || return $err

  local k
  for k in "${short_args[@]}"
  do
    pbu.args.extract -s "$k" -- "${external_args[@]}"
    err=$?
    pbu.errors.is_success $err || return $err
  done

  for k in "${long_args[@]}"
  do
    pbu.args.extract -l "$k" -- "${external_args[@]}"
    err=$?
    pbu.errors.is_success $err || return $err
  done

  return $PBU_SUCCESS
}


#============================================================================
# Below functions should be used in this file only.

function ___pbu_split_args_by_double_hyphen___() {
  local -n args1='_____SPLITED_ARGS1_____'
  local -n args2='_____SPLITED_ARGS2_____'

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
  args2=( "${@}" )
}

function ___pbu_extract_arg___() {
  local short_key="$1"
  shift
  local long_key="$1"
  shift

  local -n remaining_args='_____REMAINING_ARGS_____'
  local -n reply='_____REPLY_____'

  remaining_args=( "$@" )
  reply=()

  [ "$short_key" != "" ] ||
  [ "$long_key" != "" ] ||
  pbu.errors.echo "At least one of either short or long option is required" || return $PBU_ERROR_USAGE

  local short_is_switch_arg=0
  [ "$short_key" != "" ] && [[ ! "$short_key" =~ .*:$ ]] && short_is_switch_arg=1
  short_key="${short_key%:}"

  local long_is_switch_arg=0
  [ "$long_key" != "" ] && [[ ! "$long_key" =~ .*:$ ]] && long_is_switch_arg=1
  long_key="${long_key%:}"

  [ "$short_key" == "" ] ||
  [ "$long_key" == "" ] ||
  [ "$short_is_switch_arg" == "$long_is_switch_arg" ] ||
  pbu.errors.echo "Short and long args should be of same type either switch or key/value." || return $PBU_ERROR_USAGE

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
          [ "$is_switch_arg" == "1" ] && reply+=( "true" ) ;
          [ "$is_switch_arg" == "0" ] && [[ ! "$2" =~ ^-.* ]] && reply+=( "$2" ) && shift ;
          ;;
      --$long_key=*)
          found=1 ;
          local val="${1#"--$long_key="}" ;
          [ "$is_switch_arg" == "0" ] ||
          [[ "$val" == "true" || "$val" == "false" ]] ||
          pbu.errors.echo "Invalid valid for --$long_key. Expected true or false." ||
          return $PBU_ERROR_USAGE ;

          reply+=( "$val" ) ;
          ;;
      -$short_key=*)
          found=1 ;
          local val="${1#"-$short_key="}" ;
          [ "$is_switch_arg" == "0" ] ||
          [[ "$val" == "true" || "$val" == "false" ]] ||
          pbu.errors.echo "Invalid valid for -$short_key. Expected true or false." ||
          return $PBU_ERROR_USAGE;

          reply+=( "$val" ) ;
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

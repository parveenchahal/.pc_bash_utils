complete -W "--utc --nanoseconds --milliseconds --microseconds --seconds" date-from-epoch
function date-from-epoch() {

  pbu_is_arg_present '' 'nanoseconds' "$@" ||
  pbu_is_arg_present '' 'microseconds' "$@" ||
  pbu_is_arg_present '' 'milliseconds' "$@" ||
  pbu_is_arg_present '' 'seconds' "$@" ||
  pbu_error_echo "At least one of args nanoseconds, microseconds, milliseconds or seconds is required" || return 1
  
  local values=()
  
  pbu_extract_arg '' 'nanoseconds' "$@"
  local value="$REPLY"
  pbu_is_empty "$value" || values+=("$value")
  
  pbu_extract_arg '' 'microseconds' "$@"
  local value="$REPLY"
  pbu_is_empty "$value" || values+=( $(($value * 1000)) )
  
  pbu_extract_arg '' 'milliseconds' "$@"
  local value="$REPLY"
  pbu_is_empty "$value" || values+=( $(($value * 1000000)) )
  
  pbu_extract_arg '' 'seconds' "$@"
  local value="$REPLY"
  pbu_is_empty "$value" || values+=( "$(($value * 1000000000))" )
  
  pbu_is_equal "${#values[@]}" "1" || pbu_error_echo "Only one should be passed out of nanoseconds, microseconds, milliseconds or seconds" || return 1
  
  local nanoseconds="$values"

  local tz='local'
  pbu_is_arg_not_present '' 'utc' "$@" || tz='utc'
  
  local seconds=$(($nanoseconds / 1000000000))
  local rem=$(($nanoseconds % 1000000000))
  
  if [ "$tz" == "utc" ]
  then
    date -u -d @$seconds +"%Y-%m-%dT%H:%M:%S.${rem}Z"
  else
    date -d @$seconds +"%Y-%m-%dT%H:%M:%S.${rem}%z"
  fi
}

complete -W "--date --nanoseconds --milliseconds --microseconds --seconds" date-to-epoch
function date-to-epoch() {

  pbu_is_arg_present '' 'nanoseconds' "$@" ||
  pbu_is_arg_present '' 'microseconds' "$@" ||
  pbu_is_arg_present '' 'milliseconds' "$@" ||
  pbu_is_arg_present '' 'seconds' "$@" ||
  pbu_error_echo "At least one of args nanoseconds, microseconds, milliseconds or seconds is required" || return 1
  
  local input="$(date +%s%N)" # default is now
  
  pbu_extract_arg '' 'date' "$@" && input="$(date -d "$REPLY" +%s%N)"
  
  local values=()
  
  pbu_is_arg_present '' 'nanoseconds' "$@" && values+=("$input")  
  pbu_is_arg_present '' 'microseconds' "$@" && values+=( $(($input / 1000)) )
  pbu_is_arg_present '' 'milliseconds' "$@" && values+=( $(($input / 1000000)) ) 
  pbu_is_arg_present '' 'seconds' "$@" && values+=( "$(($input / 1000000000))" )
  
  pbu_is_equal "${#values[@]}" "1" || pbu_error_echo "Only one should be passed out of nanoseconds, microseconds, milliseconds or seconds" || return 1
  
  echo "$values"
}

function date-utc-to-local() {
  date -d "$(date -u -d "$1")"
}

function date-local-to-utc() {
  date -u -d "$(date -d "$1")"
}

function start-utc-clock() {
  watch -t -n 1 date -u
}

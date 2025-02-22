alias pbu.date='date'
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  alias pbu.date='gdate'
fi

complete -W "--out-utc --nanoseconds --microseconds --milliseconds --seconds" date-from-epoch
function date-from-epoch() {

  pbash.args.atleast_one_arg_present -l 'nanoseconds:' -l 'microseconds:' -l 'milliseconds:' -l 'seconds:' -- "$@" ||
  pbu.errors.echo "At least one of args --nanoseconds, --microseconds, --milliseconds or --seconds is required" || return 1
  
  local values=()

  local value=()
  
  pbash.args.extract -l 'nanoseconds:' -o value -- "$@" && values+=("$value")
  pbash.args.extract -l 'microseconds:' -o value -- "$@" && values+=( $(($value * 1000)) )
  pbash.args.extract -l 'milliseconds:' -o value -- "$@" && values+=( $(($value * 1000000)) )
  pbash.args.extract -l 'seconds:' -o value -- "$@" && values+=( "$(($value * 1000000000))" )
  
  pbu.string.is_equal "${#values[@]}" "1" || pbu.errors.echo "Only one should be passed out of --nanoseconds, --microseconds, --milliseconds or --seconds" || return 1
  
  local nanoseconds="$values"

  local tz='local'
  pbash.args.is_switch_arg_enabled -l 'out-utc' -- "$@" && tz='utc'
  
  local seconds=$(($nanoseconds / 1000000000))
  local rem=$(($nanoseconds % 1000000000))
  
  if [ "$tz" == "utc" ]
  then
    date -u -d @$seconds +"%Y-%m-%dT%H:%M:%S.${rem}Z"
  else
    date -d @$seconds +"%Y-%m-%dT%H:%M:%S.${rem}%:z"
  fi
}

complete -W "--date --out-nanoseconds --out-microseconds --out-milliseconds --out-seconds" date-to-epoch
function date-to-epoch() {
  pbash.args.is_switch_arg_enabled -l 'out-nanoseconds' -- "$@" ||
  pbash.args.is_switch_arg_enabled -l 'out-microseconds' -- "$@" ||
  pbash.args.is_switch_arg_enabled -l 'out-milliseconds' -- "$@" ||
  pbash.args.is_switch_arg_enabled -l 'out-seconds' -- "$@" ||
  pbu.errors.echo "At least one of args --out-nanoseconds, --out-microseconds, --out-milliseconds or --out-seconds is required" || return 1
  
  local input="$(date +%s%N)" # default is now
  
  local date_str=()
  pbash.args.extract -l 'date:' -o date_str -- "$@" && input="$(date -d "$date_str" +%s%N)"
  
  local values=()
  
  pbash.args.is_switch_arg_enabled -l 'out-nanoseconds' -- "$@" && values+=("$input")
  pbash.args.is_switch_arg_enabled -l 'out-microseconds' -- "$@" && values+=( $(($input / 1000)) )
  pbash.args.is_switch_arg_enabled -l 'out-milliseconds' -- "$@" && values+=( $(($input / 1000000)) )
  pbash.args.is_switch_arg_enabled -l 'out-seconds' -- "$@" && values+=( "$(($input / 1000000000))" )
  
  pbu.string.is_equal "${#values[@]}" "1" || pbu.errors.echo "Only one should be passed out of --out-nanoseconds, --out-microseconds, --out-milliseconds or --out-seconds" || return 1
  
  echo "$values"
}

complete -W "add subtract --date --nanoseconds --microseconds --milliseconds --seconds --minutes --hours --days --out-utc" pbu.date.add_sub
function pbu.date.add_sub() {

  local op="$1"
  shift
  pbu.string.is_equal "$op" "add" || pbu.string.is_equal "$op" "subtract" || pbu.errors.echo "Invalid operation, supported operations are 'add' or 'subtract'" || return 1

  local base="$(date-to-epoch --out-nanoseconds)"
  local date_str=()
  pbash.args.extract -l 'date:' -o date_str -- "$@" && base="$(date-to-epoch --date "$date_str" --out-nanoseconds)"
  local diff=0

  local value=()
  pbash.args.extract -l 'nanoseconds:' -o value -- "$@" && diff=$(($diff + $value))
  pbash.args.extract -l 'microseconds:' -o value -- "$@" && diff=$(($diff + $value * 1000))
  pbash.args.extract -l 'milliseconds:' -o value -- "$@" && diff=$(($diff + $value * 1000000))
  pbash.args.extract -l 'seconds:' -o value -- "$@" && diff=$(($diff + $value * 1000000000))
  pbash.args.extract -l 'minutes:' -o value -- "$@" && diff=$(($diff + $value * 1000000000 * 60))
  pbash.args.extract -l 'hours:' -o value -- "$@" && diff=$(($diff + $value * 1000000000 * 60 * 60))
  pbash.args.extract -l 'days:' -o value -- "$@" && diff=$(($diff + $value * 1000000000 * 60 * 60 * 24))
  
  local newtime=""
  
  pbu.string.is_equal "$op" "add" && newtime=$(($base + $diff))
  pbu.string.is_equal "$op" "subtract" && newtime=$(($base - $diff))
  
  local tz='local'
  pbash.args.is_switch_arg_enabled -l 'out-utc' -- "$@" && tz='utc'
  
  
  if [ "$tz" == "utc" ]
  then
    date-from-epoch --nanoseconds "$newtime" --out-utc
  else
    date-from-epoch --nanoseconds "$newtime"
  fi
}

complete -W "--date --nanoseconds --microseconds --milliseconds --seconds --minutes --hours --days --out-utc" date-add
function date-add() {
  pbu.date.add_sub add "$@"
}

complete -W "--date --nanoseconds --microseconds --milliseconds --seconds --minutes --hours --days --out-utc" date-subtract
function date-subtract() {
  pbu.date.add_sub subtract "$@"
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

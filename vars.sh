___VARS_INTERNAL___=()

complete -W "--prefix --var" vars.create
function vars.create() {
  local var
  local vars
  local args=()
  local prefix=''
  pbash.args.extract -l prefix: -o prefix -r args -- "$@" || pbu.errors.echo "--prefix is required." || return 1
  pbash.args.extract -l var: -o vars -- "${args[@]}"
  ___VARS_INTERNAL___=$(for var in "${vars[@]}"; do echo $var; done | sort | xargs)

  for var in ${___VARS_INTERNAL___[@]}; do
    eval "function ${prefix}${var}() {
      echo \"Setting ${var} to '\$1'\"
      eval ${var}=\"\$1\"
      eval ${var}=\"\$1\"
    }"
  done
}

function vars.print() {
  local var
  local l=0
  for var in ${___VARS_INTERNAL___[@]}; do
    l=$(pbu.numbers.max $l "$(pbu.strings.length "$var")")
  done
  for var in ${___VARS_INTERNAL___[@]}; do
    printf "%-${l}s : '%-0s'\n" "${var}" "${!var}"
  done
}

function vars.reset() {
  local var
  echo "Reseting vars"
  for var in ${___VARS_INTERNAL___[@]}; do
    eval ${var}=""
  done
}

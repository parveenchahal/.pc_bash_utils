___VARS_INTERNAL___=""

function vars.create() {
  local var
  ___VARS_INTERNAL___=$(for var in "$@"; do echo $var; done | sort | xargs)
  for var in ${___VARS_INTERNAL___[@]}; do
    eval "function set_${var,,}() {
      echo \"Setting ${var} to '\$1'\"
      eval ${var}=\"\$1\"
      eval ${var}=\"\$1\"
    }"
  done
}

function vars.print() {
  local var
  for var in ${___VARS_INTERNAL___[@]}; do
    echo "${var}: '${!var}'"
  done
}

function vars.reset() {
  local var
  echo "Reseting vars"
  for var in ${___VARS_INTERNAL___[@]}; do
    eval ${var}=""
  done
}

function pbu_is_equal() {
  local x="$1"
  shift
  for y in "$@"
  do
    if [ "$x" != "$y" ]
    then
      return 1
    fi
  done
  return 0
}

function pbu_is_not_equal() {
  local size="${#@}"
  local lastIndex=`expr $size - 1`
  local values=( ${@} )
  local i=0
  while [ $i -lt $lastIndex ]
  do
    local j=`expr $i + 1`
    while [ $j -le $lastIndex ]
    do
      if [ "${values[$i]}" == "${values[$j]}" ]
      then
        return 1
      fi
      j=`expr $j + 1`
    done
    i=`expr $i + 1`
  done
  return 0
}

function pbu_is_digits() {
   [[ "$1" =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] || return 1
   return 0
}

function pbu_is_empty() {
  pbu_is_equal "" "$@" || return 1
  return 0
}

function pbu_is_not_empty() {
  for x in "$@"
  do
    if [ "$x" != "" ]
    then
      return 0
    fi
  done
  return 1
}

function pbu_string_join {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}
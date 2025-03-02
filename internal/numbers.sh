function pbu.numbers.is_number() {
   [[ "$1" =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] || return 1
   return 0
}

pbu.numbers.min() {
  local x
  local m=$(getconf INT_MAX)
  for x in "$@"
  do
    pbu.numbers.is_number $x || pbu.errors.echo "Input should be only numbers" || return 1
    [ $x -lt $m ] && m=$x
  done
  echo "$m"
}

pbu.numbers.max() {
  local x
  local m=$(getconf INT_MIN)
  for x in "$@"
  do
    pbu.string.is_number $x || pbu.errors.echo "Input should be only numbers" || return 1
    [ $x -gt $m ] && m=$x
  done
  echo "$m"
}

function pbu.date() {
  if [[ "$OSTYPE" == "darwin"* ]]
  then
    gdate "$@"
    return $?
  fi
  date "$@"
  return $?
}

function pbu.date() {
  pbu.is_macos
  if [ "$?" == "0" ]
  then
    gdate "$@"
    return $?
  fi
  date "$@"
  return $?
}

function regex_and_conversion() {
  local res=""
  for x in "$@"; do
    res="${res}(?=.*$x)"
  done
  res="${res}.+"
  echo $res
  return 0
}

function pbu.is_macos() {
  [[ "$OSTYPE" == "darwin"* ]] || return 1
  return 0
}

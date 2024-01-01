function pbu_print_array {
  [ "$#" != "0" ] && printf "['%s']" "$(pbu_string_join "', '" "$@")" && return
  printf "[]"
}
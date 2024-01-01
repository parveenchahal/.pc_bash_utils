function pbu.array.print {
  [ "$#" != "0" ] && printf "['%s']" "$(pbu.string.join "', '" "$@")" && return
  printf "[]"
}
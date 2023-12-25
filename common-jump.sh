alias j-desktop='cd ~/Desktop'
alias j-downloads='cd ~/Downloads'

complete -W '--editor' tmp
function tmp() {
  local ARGS=$(getopt -q -l "editor:" -- "" "$@")
  eval set -- "$ARGS"

  pbu_non_option_arg_from_getopt_formated "$@"
  local path="$REPLY"
  
  if [ -z "$path" ]
  then
    cd /tmp
    return 0
  fi
  
  local path="/tmp/$path"
  if [ -f "$path" ]
  then
    pbu_extract_arg '' 'editor' "$@" || REPLY="vim"
    pbu_eval_cmd "$REPLY" "$path"
    return 0
  fi
  
  if [ -d "$path" ]
  then
    cd "$path"
    return 0
  fi
  
  pbu_error_echo "Invalid path."
  return 1
}

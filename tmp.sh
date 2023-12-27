
function tmp() {
  pbu_extract_arg '' 'editor' "$@" || REPLY="vim"
  local editor="$REPLY"
  set -- "${REMAINING_ARGS[@]}"

  local path="$1"
  
  if [ -z "$path" ]
  then
    cd /tmp
    return 0
  fi
  
  local path="/tmp/$path"
  if [ -f "$path" ]
  then
    pbu_eval_cmd "$editor" "$path"
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

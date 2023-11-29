alias exec-script='~/.exec-script.sh'

complete -W "-e --editor" edit-exec-script
function edit-exec-script() {
  pbu_extract_arg 'e' 'editor' "$@" || REPLY=vim
  local editor="$REPLY"
  if [ ! -f ~/.exec-script.sh ]
  then
    touch ~/.exec-script.sh
    chmod +x ~/.exec-script.sh
  fi
  cmd="$editor ~/.exec-script.sh"
  eval "$cmd"
}

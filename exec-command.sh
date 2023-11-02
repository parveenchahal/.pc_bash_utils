alias exec-command='~/.exec-command.sh'

complete -W "-e --editor" edit-exec-command
function edit-exec-command() {
  pbu_extract_arg 'e' 'editor' "$@" || REPLY=vim
  local editor="$REPLY"
  if [ ! -f ~/.exec-command.sh ]
  then
    touch ~/.exec-command.sh
    chmod +x ~/.exec-command.sh
  fi
  cmd="$editor ~/.exec-command.sh"
  eval "$cmd"
}

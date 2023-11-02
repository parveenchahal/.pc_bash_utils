alias exec-command='~/.exec-command.sh'

complete -W "-e --editor" edit-exec-command
function edit-exec-command() {
  local editor="vim"
  pbu_extract_arg 'f' 'file' "$@"
  if [ "$?" == 0 ]
  then
    editor="$REPLY"
  fi
  if [ ! -f ~/.exec-command.sh ]
  then
    touch ~/.exec-command.sh
    chmod +x ~/.exec-command.sh
  fi
  cmd="$editor ~/.exec-command.sh"
  eval "$cmd"
}

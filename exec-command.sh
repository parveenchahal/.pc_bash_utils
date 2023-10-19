alias exec-command='~/.exec-command.sh'

function edit-exec-command() {
  local cmd="vim"
  if [ ! -z "$1" ]
  then
    cmd="$1"
  fi
  if [ ! -f ~/.exec-command.sh ]
  then
    touch ~/.exec-command.sh
    chmod +x ~/.exec-command.sh
  fi
  cmd="$cmd ~/.exec-command.sh"
  eval "$cmd"
}

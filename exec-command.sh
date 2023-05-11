alias exec-command='~/.exec-command.sh'

function edit-exec-command() {
  local cmd="vim"
  local file_path='~/.exec-command.sh'
  if [ ! -z "$1" ]
  then
    cmd="$1"
  fi
  if [ ! -f "$file_path" ]
  then
    touch "$file_path"
    chmod +x "$file_path"
  fi
  cmd="$cmd $file_path"
  eval "$cmd"
}

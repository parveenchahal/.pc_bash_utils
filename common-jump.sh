alias j-desktop='cd ~/Desktop'
alias j-downloads='cd ~/Downloads'

function tmp() {
  if [ -z "$1" ]
  then
    cd /tmp
    return 0
  fi
  local path="/tmp/$1"
  if [ -f "$path" ]
  then
    vim "$path"
    return 0
  fi
  if [ -d "$path" ]
  then
    cd "$path"
    return 0
  fi
  echo "Invalid path."
  return 1
}

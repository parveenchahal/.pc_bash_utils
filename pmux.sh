function pmux() {
  tmux attach -t pc || tmux new -s pc
  return $?
}

alias open-tmux='pmux'

function pmux-nw() {
  local s=$(pbu.array.size "$@")
  if [ ! "$s" == "0" ]
  then
    local filename=$(sha256sum <(echo -n "$(date)") | awk '{print $1}')
    cp ~/.bashrc /tmp/tmux-$filename
    echo "echo" "Executing command in new window: " "$@" >> /tmp/tmux-$filename
    echo "$@" >> /tmp/tmux-$filename
    tmux new-window -t pc bash --rcfile /tmp/tmux-$filename
    rm /tmp/tmux-$filename
  else
    tmux new-window -t pc
  fi
}

alias open-tmux='ptmux'

function ptmux() {
  tmux attach -t pc || tmux new -s pc
  return $?
}

function ptmux-nw() {
  local s=$(pbu.array.size "$@")
  if [ ! "$s" == "0" ]
  then
    local filename=$(sha256sum <(echo -n "$(date)") | awk '{print $1}')
    cp ~/.bashrc /tmp/ptmux-$filename
    pbu.eval.printcmd "$@" >> /tmp/ptmux-$filename
    tmux new-window -t pc bash --rcfile /tmp/ptmux-$filename
    rm /tmp/ptmux-$filename
  else
    tmux new-window -t pc
  fi
}

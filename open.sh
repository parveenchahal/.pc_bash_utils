function open-tmux() {
  if [ ! -z $TMUX ]
  then
    return 1
  fi
  tmux attach -t pc || tmux new -s pc
  return $?
}

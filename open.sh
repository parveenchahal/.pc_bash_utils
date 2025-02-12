function open-tmux() {
  tmux attach -t pc || tmux new -s pc
  return $?
}

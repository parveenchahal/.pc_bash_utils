function open-test-py() {
  local file_path=~/py-test.py
  pbu_is_file_exist $file_path
  if [ ! "$?" == 1 ]
  then
    touch $file_path
  fi
  vim $file_path
}

function open-tmux() {
  tmux attach -t pc || tmux new -s pc
}

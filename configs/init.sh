function pbu.force-update-config-files() {
  update-pc-bash-utils
  
  local tmux='.tmux.conf'
  [[ "$OSTYPE" == "darwin"* ]] && tmux='.tmux-macos.conf'
  cp ~/.pc_bash_utils/configs/$x ~/.tmux.conf
  
  declare -a config_list=(".vimrc")
  for x in "${config_list[@]}"
  do
    cp ~/.pc_bash_utils/configs/$x ~/
  done
}

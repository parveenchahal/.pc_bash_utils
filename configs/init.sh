function pbu.force-update-config-files() {
  update-pc-bash-utils
  
  local tmux_conf='.tmux.conf'
  [[ "$OSTYPE" == "darwin"* ]] && tmux_conf='.tmux-macos.conf'
  cp ~/.pc_bash_utils/configs/$tmux_conf ~/.tmux.conf
  
  declare -a config_list=(".vimrc")
  for x in "${config_list[@]}"
  do
    cp ~/.pc_bash_utils/configs/$x ~/
  done
}

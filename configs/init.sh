function pbu.force-update-config-files() {
  update-pc-bash-utils
  declare -a config_list=(".tmux.conf" ".vimrc")
  for x in "${config_list[@]}"
  do
    cp ~/.pc_bash_utils/configs/$x ~/
  done
}

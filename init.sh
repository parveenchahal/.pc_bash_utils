[[ "${BASH_VERSINFO[0]}" -ge 5 ]] || { echo "pc_bash_utils requires bash version at 5 or greater"; return 1; }

function pbu_bin_path() {
  echo -n "$HOME/.pc_bash_utils/bin"
}

function reload-bashrc() {
  source ~/.bashrc
}

function pbu.is_in_path() {
  [[ ":$PATH:" == *":$1:"* ]] || return 1
  return 0
}

function pbu.export_path() {
  pbu.is_in_path "$1" || { [ -d "$1" ] && export PATH="$PATH:$1"; }
}

function pbu.force_export_path() {
  pbu.is_in_path "$1" || export PATH="$PATH:$1"
}

function __pbu_install() {
  local f
  for f in "$1"/*
  do
    local bn="$(basename "$f")"
    if [ -f "$(realpath "$f")" ]
    then
      if [[ ! "$bn" =~ ^_.* ]] && [ ! "$bn" == "init.sh" ] && [ ! "$bn" == "init" ]
      then
        cp "$(realpath "$f")" "$___PBU_INSTALLTION_PATH___/"
        chmod +x "$___PBU_INSTALLTION_PATH___/$bn"
      fi
      chmod -x "$(realpath "$f")"
    fi
  done
}

pbu.export_path "$HOME/.local/bin"
pbu.export_path "/usr/local/bin"
pbu.export_path "/opt/homebrew/bin"

# Prepare installation path
export ___PBU_INSTALLTION_PATH___="$(pbu_bin_path)"
[ ! -d "$___PBU_INSTALLTION_PATH___" ] && {
  mkdir "$___PBU_INSTALLTION_PATH___"
  export ___PBU_UPDATE_TRIGGERED___=true
}

function __pbu_update_triggered() {
  [ "$___PBU_UPDATE_TRIGGERED___" == "true" ] || return 1
  return 0
}

source "$HOME/.pc_bash_utils/internal/init.sh"
# Any new source or __pbu_install can be added below

__pbu_update_triggered && {
  __pbu_install "$HOME/.pc_bash_utils/eval"
  __pbu_install "$HOME/.pc_bash_utils/ptmux"
  __pbu_install "$HOME/.pc_bash_utils/copy"
}

source "$HOME/.pc_bash_utils/pssh/init.sh"
source "$HOME/.pc_bash_utils/default-options-for-commands.sh"
source "$HOME/.pc_bash_utils/python.sh"
source "$HOME/.pc_bash_utils/cd.sh"
source "$HOME/.pc_bash_utils/tmp.sh"
source "$HOME/.pc_bash_utils/kubectl.sh"
source "$HOME/.pc_bash_utils/git.sh"
source "$HOME/.pc_bash_utils/openssl.sh"
source "$HOME/.pc_bash_utils/date_utils.sh"
source "$HOME/.pc_bash_utils/docker.sh"
source "$HOME/.pc_bash_utils/exec-bash-script.sh"
source "$HOME/.pc_bash_utils/conversion.sh"
source "$HOME/.pc_bash_utils/general_problems.sh"
source "$HOME/.pc_bash_utils/configs/init.sh"
source "$HOME/.pc_bash_utils/utils.sh"
source "$HOME/.pc_bash_utils/vars.sh"

___PBU_UPDATE_TRIGGERED___=false

[[ "${BASH_VERSINFO[0]}" -ge 5 ]] || { echo "pc_bash_utils requires bash version at 5 or greater"; return 1; }

function pbu_bin_path() {
  echo -n "$HOME/.pc_bash_utils/bin"
}

function pbu_data_path() {
  echo -n "$HOME/.pc_bash_utils/data"
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

function __load_all_complete_commands() {
  for f in "$1"/*
  do
    local p="$(realpath "$f")"
    local bn="$(basename "$p")"
    if [ -f "$p" ]
    then
      [ "$bn" == "_complete.sh" ] && source "$p"
    else
      __load_all_complete_commands "$p"
    fi
  done
}

function pbu_install() {
  if [ -f "$1" ]
  then
    local bn="$(basename "$1")"
    cp "$(realpath "$1")" "$(pbu_bin_path)/"
    chmod +x "$(pbu_bin_path)/$bn"
    return 0
  fi
  local f
  for f in "$1"/*
  do
    local bn="$(basename "$f")"
    if [ -f "$(realpath "$f")" ]
    then
      if [[ ! "$bn" =~ ^_.* ]] && [ ! "$bn" == "init.sh" ] && [ ! "$bn" == "init" ]
      then
        cp "$(realpath "$f")" "$(pbu_bin_path)/"
        chmod +x "$(pbu_bin_path)/$bn"
      fi
      chmod -x "$(realpath "$f")"
    fi
  done
}

pbu.export_path "$HOME/.local/bin"
pbu.export_path "/usr/local/bin"
pbu.export_path "/opt/homebrew/bin"
pbu.export_path "$(pbu_bin_path)"

# Prepare installation path
[ ! -d "$(pbu_bin_path)" ] && {
  mkdir "$(pbu_bin_path)"
  export ___PBU_UPDATE_TRIGGERED___=true
}

function __pbu_update_triggered() {
  [ "$___PBU_UPDATE_TRIGGERED___" == "true" ] || return 1
  return 0
}

source "$HOME/.pc_bash_utils/internal/init.sh"
# Any new source or pbu_install can be added below

__load_all_complete_commands "$HOME/.pc_bash_utils"

__pbu_update_triggered && {
  pbu_install "$HOME/.pc_bash_utils/copy"
  pbu_install "$HOME/.pc_bash_utils/eval"
  pbu_install "$HOME/.pc_bash_utils/pssh"
  pbu_install "$HOME/.pc_bash_utils/ptmux"
}

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

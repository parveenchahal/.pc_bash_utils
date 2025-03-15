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

pbu.export_path "$HOME/.local/bin"
pbu.export_path "/usr/local/bin"
pbu.export_path "/opt/homebrew/bin"

function __pbu_install() {
  local f
  for f in "$1"/*
  do
    local bn="$(basename "$f")"
    if [ -f "$(realpath "$f")" ]
    then
      if [[ ! "$bn" =~ ^_.* ]] && [ ! "$bn" == "init.sh" ] && [ ! "$bn" == "init" ]
      then
        cp "$(realpath "$f")" "$__pbu_installation_path/"
        chmod +x "$__pbu_installation_path/$bn"
      fi
      chmod -x "$(realpath "$f")"
    fi
  done
}

# Prepare installation path
__pbu_installation_path="$HOME/.pc_bash_utils/bin"
[ ! -d "$__pbu_installation_path" ] && {
   mkdir "$__pbu_installation_path"

  __pbu_install "$HOME/.pc_bash_utils/internal/arrays"
  __pbu_install "$HOME/.pc_bash_utils/internal/checks"
  __pbu_install "$HOME/.pc_bash_utils/internal/date"
  __pbu_install "$HOME/.pc_bash_utils/internal/errors"
  __pbu_install "$HOME/.pc_bash_utils/internal/eval"
  __pbu_install "$HOME/.pc_bash_utils/internal/input"
  __pbu_install "$HOME/.pc_bash_utils/internal/numbers"
  __pbu_install "$HOME/.pc_bash_utils/internal/parse_arguments"
  __pbu_install "$HOME/.pc_bash_utils/internal/python"
  __pbu_install "$HOME/.pc_bash_utils/internal/sql"
  __pbu_install "$HOME/.pc_bash_utils/internal/strings"
  __pbu_install "$HOME/.pc_bash_utils/internal/update_management"
  __pbu_install "$HOME/.pc_bash_utils/internal/utils"

}

pbu.export_path "$__pbu_installation_path"

source "$HOME/.pc_bash_utils/internal/errors/pbu.errors.codes"
source "$HOME/.pc_bash_utils/internal/parse_arguments/init.sh"
source "$HOME/.pc_bash_utils/internal/input/pbu.read_input.sh"
source "$HOME/.pc_bash_utils/internal/update_management/init.sh"

function pbu.export_path() {
  [[ ":$PATH:" == *":$1:"* ]] || { [ -d "$1" ] && export PATH="$PATH:$1"; }
}

function __pbu.export_path_and_make_executable() {
  pbu.export_path "$1"
  local f
  for f in "$1"/*
  do
    local bn="$(basename "$f")"
    # echo "$bn : $f"
    if [ -f "$(realpath "$f")" ] && [[ ! "$bn" =~ ^_.* ]] && [ ! "$bn" == "init.sh" ] && [ ! "$bn" == "init" ]
    then
      #echo "Making "$(realpath "$f")" as executable"
      chmod +x "$(realpath "$f")"
    else
      chmod -x "$(realpath "$f")"
      #echo "Ignoring $f"
    fi
  done
}

pbu.export_path "$HOME/.local/bin"
pbu.export_path "/usr/local/bin"
pbu.export_path "/opt/homebrew/bin"


source ~/.pc_bash_utils/internal/errors/pbu.errors.codes
source ~/.pc_bash_utils/internal/parse_arguments/init.sh

__pbu.export_path_and_make_executable "$HOME/.pc_bash_utils/internal/arrays"
__pbu.export_path_and_make_executable "$HOME/.pc_bash_utils/internal/checks"
__pbu.export_path_and_make_executable "$HOME/.pc_bash_utils/internal/date"
__pbu.export_path_and_make_executable "$HOME/.pc_bash_utils/internal/errors"
__pbu.export_path_and_make_executable "$HOME/.pc_bash_utils/internal/eval"
__pbu.export_path_and_make_executable "$HOME/.pc_bash_utils/internal/numbers"
__pbu.export_path_and_make_executable "$HOME/.pc_bash_utils/internal/parse_arguments"
__pbu.export_path_and_make_executable "$HOME/.pc_bash_utils/internal/sql"
__pbu.export_path_and_make_executable "$HOME/.pc_bash_utils/internal/strings"
__pbu.export_path_and_make_executable "$HOME/.pc_bash_utils/internal/update_management"
__pbu.export_path_and_make_executable "$HOME/.pc_bash_utils/internal/utils"

source ~/.pc_bash_utils/internal/update_management/init.sh

function pbu.export_path() {
  [[ ":$PATH:" == *":$1:"* ]] || { [ -d "$1" ] && export PATH="$PATH:$1"; }
}

pbu.export_path "$HOME/.local/bin"
pbu.export_path "/usr/local/bin"
pbu.export_path "/opt/homebrew/bin"


source ~/.pc_bash_utils/internal/checks.sh
source ~/.pc_bash_utils/internal/date.sh
source ~/.pc_bash_utils/internal/update_management.sh

source ~/.pc_bash_utils/internal/errors.sh
source ~/.pc_bash_utils/internal/parse_arguments.sh
source ~/.pc_bash_utils/internal/eval.sh
source ~/.pc_bash_utils/internal/string.sh
source ~/.pc_bash_utils/internal/array.sh
source ~/.pc_bash_utils/internal/utils.sh
source ~/.pc_bash_utils/internal/sql.sh
source ~/.pc_bash_utils/internal/numbers.sh

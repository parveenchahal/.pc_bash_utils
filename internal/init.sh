__pbu_update_triggered && {
  pbu_install "$HOME/.pc_bash_utils/internal/arrays"
  pbu_install "$HOME/.pc_bash_utils/internal/checks"
  pbu_install "$HOME/.pc_bash_utils/internal/date"
  pbu_install "$HOME/.pc_bash_utils/internal/errors"
  pbu_install "$HOME/.pc_bash_utils/internal/eval"
  pbu_install "$HOME/.pc_bash_utils/internal/input"
  pbu_install "$HOME/.pc_bash_utils/internal/numbers"
  pbu_install "$HOME/.pc_bash_utils/internal/parse_arguments"
  pbu_install "$HOME/.pc_bash_utils/internal/python"
  pbu_install "$HOME/.pc_bash_utils/internal/sql"
  pbu_install "$HOME/.pc_bash_utils/internal/strings"
  pbu_install "$HOME/.pc_bash_utils/internal/update_management"
  pbu_install "$HOME/.pc_bash_utils/internal/utils"

}

source "$HOME/.pc_bash_utils/internal/errors/pbu.errors.codes"
source "$HOME/.pc_bash_utils/internal/parse_arguments/init.sh"
source "$HOME/.pc_bash_utils/internal/input/pbu.read_input.sh"
source "$HOME/.pc_bash_utils/internal/update_management/init.sh"

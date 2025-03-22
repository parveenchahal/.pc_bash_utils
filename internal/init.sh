# Completes start
source "$HOME/.pc_bash_utils/internal/eval/_complete.sh"
# Completes end

__pbu_update_triggered && {
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

source "$HOME/.pc_bash_utils/internal/errors/pbu.errors.codes"
source "$HOME/.pc_bash_utils/internal/parse_arguments/init.sh"
source "$HOME/.pc_bash_utils/internal/input/pbu.read_input.sh"
source "$HOME/.pc_bash_utils/internal/update_management/init.sh"

if [ -f ~/.pc_bash_utils/.lastupdate ]
then
  hours2past="$(date -d "-2 hours" +"%s")"
  lastUpdate=$(cat ~/.pc_bash_utils/.lastupdate)
  if [ "$lastUpdate" != "disabled" ]
  then
    if [ "$lastUpdate" -lt "$hours2past" ]
    then
      git remote update > /dev/null 2>&1 && git status -uno | grep -q 'Your branch is behind' && echo "Please run \"update-pc-bash-utils\" to update latest bash utils"
    fi
  fi
else
  date +"%s" > ~/.pc_bash_utils/.lastupdate
fi

alias update-pc-bash-utils='cd ~/.pc_bash_utils && git pull && cd - && ([ "$(cat ~/.pc_bash_utils/.lastupdate)" == "disabled" ] || (date +"%s" > ~/.pc_bash_utils/.lastupdate)) && source ~/.pc_bash_utils/init.sh'
source ~/.pc_bash_utils/default-options-for-commands.sh
source ~/.pc_bash_utils/parse_arguments.sh
source ~/.pc_bash_utils/internal_utils.sh
source ~/.pc_bash_utils/python.sh
source ~/.pc_bash_utils/common-jump.sh
source ~/.pc_bash_utils/kubectl/init.sh
source ~/.pc_bash_utils/git/init.sh
source ~/.pc_bash_utils/openssl.sh
source ~/.pc_bash_utils/open.sh
source ~/.pc_bash_utils/run.sh
source ~/.pc_bash_utils/regex_utils.sh
source ~/.pc_bash_utils/date_utils.sh
source ~/.pc_bash_utils/copy.sh
source ~/.pc_bash_utils/docker.sh
source ~/.pc_bash_utils/exec-command.sh
source ~/.pc_bash_utils/conversion.sh

if [ ! -f ~/.pc_bash_utils/.lastupdate ]
then
  echo 0 > ~/.pc_bash_utils/.lastupdate
fi

if [ ! -f ~/.pc_bash_utils/.updatepending ]
then
  echo 0 > ~/.pc_bash_utils/.updatepending
fi

hours2past="$(date -d "-1 day" +"%s")"
lastUpdate=$(cat ~/.pc_bash_utils/.lastupdate)
updatePending=$(~/.pc_bash_utils/.updatepending)
if [ "$lastUpdate" != "disabled" ]
then
  if [ "$lastUpdate" -lt "$hours2past" ]
  then
    cd ~/.pc_bash_utils
    [ "$updatePending" == "0" ] && echo "Checking for new updates for pc_bash_utils" && git remote update > /dev/null 2>&1 && git status -uno | grep -q 'Your branch is behind' && (echo 1 > ~/.pc_bash_utils/.updatepending)
    if [ "$updatePending" == "1" ]
    then
      echo "Please run \"update-pc-bash-utils\" to update latest bash utils"
    else
      date +"%s" > ~/.pc_bash_utils/.lastupdate
    fi
    cd - > /dev/null 2>&1
  fi
fi


alias update-pc-bash-utils='cd ~/.pc_bash_utils && git pull && cd - > /dev/null 2>&1 && source ~/.pc_bash_utils/init.sh'
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

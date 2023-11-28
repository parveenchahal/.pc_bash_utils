if [ ! -f ~/.pc_bash_utils/.lastupdatecheck ]
then
  echo 0 > ~/.pc_bash_utils/.lastupdatecheck
fi

if [ ! -f ~/.pc_bash_utils/.updatepending ]
then
  echo 0 > ~/.pc_bash_utils/.updatepending
fi

hours2past="$(date -d "-1 day" +"%s")"
lastupdatecheck=$(cat ~/.pc_bash_utils/.lastupdatecheck)
if [ "$lastupdatecheck" != "disabled" ]
then
  if [ "$lastupdatecheck" -lt "$hours2past" ]
  then
    cd ~/.pc_bash_utils
    updatePending=$(cat ~/.pc_bash_utils/.updatepending)
    if [ "$updatePending" == "0" ]
    then
      changed=0
      echo "Checking for new updates for pc_bash_utils" && git remote update > /dev/null 2>&1 && git status -uno | grep -q 'Your branch is behind' && changed=1
      echo "$changed" > ~/.pc_bash_utils/.updatepending
    fi
    updatePending=$(cat ~/.pc_bash_utils/.updatepending)
    if [ "$updatePending" == "1" ]
    then
      echo "Please run \"update-pc-bash-utils\" to update latest bash utils"
    else
      date +"%s" > ~/.pc_bash_utils/.lastupdatecheck
    fi
    cd - > /dev/null 2>&1
  fi
fi

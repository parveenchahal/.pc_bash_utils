alias copy-from-tmux='tmux save-buffer - | xclip -i -sel clipboard'

function pbu.copy.file_to_local_bin() {
  pbu.is_file_exist "$1" || pbu.errors.echo "file $1 does not exist" || return 1

  local fullpath="$(pbu.get_full_path "$1")"

  pbu.create_dir_if_does_not_exist ~/.local/bin
  cp "$fullpath" ~/.local/bin/
  chmod +rx "$(realpath ~/.local/bin)/$(basename "$fullpath")"
}

function stash-files() {
  local op="$1"
  shift
  if [ "$op" == "stash" ]
  then
    echo "stashing files $@"
    for x in "$@"
    do
      if [ ! -f "$x" ]
      then
        echo "Error: file $x does not exist."
        return 1
      fi
      mkdir -p "/tmp/stash-files/$(dirname "$x")"
      cp "$x" "/tmp/stash-files/$x"
    done
    return 0
  elif [ "$op" == "apply" ]
  then
    echo "applying files $@"
    for x in "$@"
    do
      if [ ! -f "/tmp/stash-files/$x" ]
      then
        echo "Error: file $x does not exist in stash."
        return 1
      fi
      cp "/tmp/stash-files/$x" "$x"
    done
    return 0
  fi
  echo "Invalid operation, specify either stash or apply."
  return 1
}

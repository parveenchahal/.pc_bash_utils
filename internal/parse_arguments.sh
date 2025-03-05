function ___pbu_check_and_install() {
  local installation_type=''
  [ -f /usr/local/bin/pbash-args.sh ] || installation_type='system'
  [ -f $HOME/.local/bin/pbash-args.sh ] || installation_type='user'
  if [ -z "$installation_type" ]
  then
    echo 'Installing pbash-args.sh...'
    curl -sL https://pbash.pcapis.com/args/install.sh | bash -s -- --user
    installation_type='user'
  fi
  if [ "$installation_type" == "user" ]
  then
    source $HOME/.local/bin/pbash-args.sh || pbu.errors.echo "pbash-args.sh is not installed, pc_bash_utils can not be used."
  fi
  if [ "$installation_type" == "system" ]
  then
    source /usr/local/bin/pbash-args.sh || pbu.errors.echo "pbash-args.sh is not installed, pc_bash_utils can not be used."
  fi
}

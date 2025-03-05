if [ ! -f /usr/local/bin/pbash-args.sh ] && [ ! -f $HOME/.local/bin/pbash-args.sh ]
then
  echo 'Installing pbash-args.sh...'
  curl -sL https://pbash.pcapis.com/args/install.sh | bash -s -- --user
fi

source /usr/local/bin/pbash-args.sh || source $HOME/.local/bin/pbash-args.sh || pbu.errors.echo "pbash-args.sh is not installed, pc_bash_utils can not be used."

[[ -f /usr/local/bin/pbash-args.sh ]]
if [ ! "$?" == "0" ]
then
  echo 'Installing pbash-args.sh...'
  echo 'It requires sudo access.'
  curl -sL https://pbash.pcapis.com/args/install.sh | sudo bash
fi

source pbash-args.sh || pbu.errors.echo "pbash-args.sh is not installed, pc_bash_utils can not be used."

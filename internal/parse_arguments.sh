[[ -f /usr/bin/pbash-args.sh ]]
if [ ! "$?" == "0" ]
then
  echo 'Installing pbash-args.sh...'
  echo 'It requires sudo access.'
  wget -q -O - https://pbash.pcapis.com/args/install.sh | sudo bash
fi

source /usr/bin/pbash-args.sh || pbu.errors.echo "pbash-args.sh is not installed, pc_bash_utils can not be used."

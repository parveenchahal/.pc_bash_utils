function pbu.openssl.decode() {
  pbu.args.extract -l 'type:' -- "$@" || pbu.errors.echo "--type is required option" || return 1
  local type=$REPLY

  pbu.args.extract -s 'f:' -l 'file:' -- "$@" || pbu.read_input "-f|--file (file path): "
  local file=$REPLY

  pbu.args.extract -l 'inform:' -- "$@" || pbu.read_input "--inform (der/pem): "
  local inform=$REPLY
  
  pbu.eval.cmd_with_echo openssl "$type" -inform "$inform" -in "$file" -text -noout
}

complete -d -f -W "-f --file --inform" openssl-decode-cert 
function openssl-decode-cert() {
  pbu.openssl.decode --type x509 "$@"
}

complete -d -f -W "-f --file --inform" openssl-decode-csr
function openssl-decode-csr() {
  pbu.openssl.decode --type req "$@"
}

complete -d -f -W "-f --file --inform --type" openssl-decode-key
function openssl-decode-key() {
  pbu.args.extract -s 'f:' -l 'file:' -- "$@" || pbu.read_input "-f|--file (file path): "
  local file=$REPLY

  pbu.args.extract -l 'inform:' -- "$@" || pbu.read_input "--inform (der/pem): "
  local inform=$REPLY
  
  pbu.args.extract -l 'type:' -- "$@" || pbu.read_input "--type (rsa/ec): "
  local key_type=$REPLY
  
  echo "Is this public key: "
  pbu.confirm
  local is_pub=$?
  
  if [ "$is_pub" == "0" ]
  then
    pbu.eval.cmd_with_echo openssl "$key_type" -pubin -inform "$inform" -in "$file" -text -noout
  else [ "$is_pub" == "1" ]
    pbu.eval.cmd_with_echo openssl "$key_type" -inform "$inform" -in "$file" -text -noout
  fi
}

complete -d -f -W "-f --file --inform" openssl-decode-asn1
function openssl-decode-asn1() {
  pbu.args.extract -s 'f:' -l 'file:' -- "$@" || pbu.read_input "-f|--file (file path): "
  local file=$REPLY
  pbu.args.extract -l 'inform:' -- "$@" || pbu.read_input "--inform (der/pem): "
  local inform=$REPLY
  pbu.eval.cmd_with_echo openssl asn1parse -inform "$inform" -in "$file"
}

complete -d -f -W "-f --file --inform -o --outfile" openssl-tbs-extract
function openssl-tbs-extract() {
  pbu.args.extract -s 'f:' -l 'file:' -- "$@" || pbu.read_input "-f|--file (file path): "
  local file=$REPLY
  
  pbu.args.extract -l 'inform:' -- "$@" || pbu.read_input "--inform (der/pem): "
  local inform=$REPLY

  pbu.args.extract -s 'o:' -l 'outfile:' -- "$@" || pbu.read_input "-o|--outfile (file path): "
  local outfile=$REPLY
  
  pbu.eval.cmd_with_echo openssl asn1parse -inform "$inform" -in "$file" -out "$outfile" -strparse 4 -noout
}

complete -d -f -W "-f --file --inform -o --outfile" openssl-signature-extract
function openssl-signature-extract() {
  pbu.args.extract -s 'f:' -l 'file:' -- "$@" || pbu.read_input "-f|--file (file path): "
  local file=$REPLY
  
  pbu.args.extract -l 'inform:' -- "$@" || pbu.read_input "--inform (der/pem): "
  local inform=$REPLY

  pbu.args.extract -s 'o:' -l 'outfile:' -- "$@" || pbu.read_input "-o|--outfile (file path): "
  local outfile=$REPLY
  
  local x=$(openssl asn1parse -inform $inform -in "$file" | tail -n 1 | cut -d ":" -f 1 | xargs)
  
  pbu.eval.cmd_with_echo openssl asn1parse -inform "$inform" -in "$file" -out "$outfile" -strparse "$x" -noout
}

complete -d -f -W "-f --file -o --outfile" openssl-x509-convert-der-to-pem
function openssl-x509-convert-der-to-pem () {
  pbu.args.extract -s 'f:' -l 'file:' -- "$@" || pbu.read_input "-f|--file (file path): "
  local file=$REPLY

  pbu.args.extract -s 'o:' -l 'outfile:' -- "$@" || pbu.read_input "-o|--outfile (file path): "
  local outfile=$REPLY
  
  pbu.eval.cmd_with_echo openssl x509 -inform der -in "$file" -outform pem -out "$outfile" -noout
}

complete -d -f -W "-f --file -o --outfile" openssl-x509-convert-pem-to-der
function openssl-x509-convert-pem-to-der () {
  pbu.args.extract -s 'f:' -l 'file:' -- "$@" || pbu.read_input "-f|--file (file path): "
  local file=$REPLY

  pbu.args.extract -s 'o:' -l 'outfile:' -- "$@" || pbu.read_input "-o|--outfile (file path): "
  local outfile=$REPLY
  
  pbu.eval.cmd_with_echo openssl x509 -inform pem -in "$file" -outform der -out $outfile -noout
}

complete -d -f -W "-f --file -o --outfile --inform --outform" openssl-publickey-extract
function openssl-publickey-extract() {
  pbu.args.extract -s 'f:' -l 'file:' -- "$@" || pbu.read_input "-f|--file (file path): "
  local file=$REPLY
  
  pbu.args.extract -l 'inform:' -- "$@" || pbu.read_input "--inform (der/pem): "
  local inform=$REPLY

  pbu.args.extract -s 'o:' -l 'outfile:' -- "$@" || pbu.read_input "-o|--outfile (file path): "
  local outfile=$REPLY

  pbu.args.extract -l 'outform:' -- "$@" || pbu.read_input "--outform (der/pem): "
  local outform=$REPLY
  
  pbu.eval.cmd_with_echo openssl x509 -pubkey -inform "$inform" -in "$file" -outform "$outform" -out "$outfile" -noout
}

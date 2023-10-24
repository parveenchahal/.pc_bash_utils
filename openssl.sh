function pbu_openssl_decode() {
  pbu_extract_arg '' 'type' "$@" || pbu_echo_error "--type is required option" || return 1
  local type=$REPLY

  pbu_extract_arg 'f' 'file' "$@" || pbu_read_input "-f|--file (file path): "
  local file=$REPLY

  pbu_extract_arg '' 'inform' "$@" || pbu_read_input "--inform (der/pem): "
  local inform=$REPLY
  
  cmd="openssl $type -inform $inform -in \"$file\" -text -noout"
  pbu_eval_cmd "$cmd"
}

complete -d -f -W "-f --file --inform" openssl-decode-cert 
function openssl-decode-cert() {
  pbu_openssl_decode --type x509 "$@"
}

complete -d -f -W "-f --file --inform" openssl-decode-csr
function openssl-decode-csr() {
  pbu_openssl_decode --type req "$@"
}

complete -d -f -W "-f --file --inform --type" openssl-decode-key
function openssl-decode-key() {
  pbu_extract_arg 'f' 'file' "$@" || pbu_read_input "-f|--file (file path): "
  local file=$REPLY

  pbu_extract_arg '' 'inform' "$@" || pbu_read_input "--inform (der/pem): "
  local inform=$REPLY
  
  pbu_extract_arg '' 'type' "$@" || pbu_read_input "--type (rsa/ec): "
  local key_type=$REPLY
  
  echo "Is this public key: "
  pbu_confirm
  local is_pub=$?
  
  if [ "$is_pub" == 1 ]
  then
    cmd="openssl $key_type -pubin -inform $inform -in \"$file\" -text -noout"
  else [ "$is_pub" == 0 ]
    cmd="openssl $key_type -inform $inform -in \"$file\" -text -noout"
  fi
  pbu_eval_cmd "$cmd"
}

complete -d -f -W "-f --file --inform" openssl-asn1parse
function openssl-asn1parse() {
  pbu_extract_arg 'f' 'file' "$@" || pbu_read_input "-f|--file (file path): "
  local file=$REPLY
  pbu_extract_arg '' 'inform' "$@" || pbu_read_input "--inform (der/pem): "
  local inform=$REPLY
  cmd="openssl asn1parse -inform $inform -in \"$file\""
  pbu_eval_cmd "$cmd"
}

complete -d -f -W "-f --file --inform -o --outfile" openssl-tbs-extract
function openssl-tbs-extract() {
  pbu_extract_arg 'f' 'file' "$@" || pbu_read_input "-f|--file (file path): "
  local file=$REPLY
  
  pbu_extract_arg '' 'inform' "$@" || pbu_read_input "--inform (der/pem): "
  local inform=$REPLY

  pbu_extract_arg 'o' 'outfile' "$@" || pbu_read_input "-o|--outfile (file path): "
  local outfile=$REPLY
  
  cmd="openssl asn1parse -inform $inform -in \"$file\" -out \"$outfile\" -strparse 4 -noout"
  pbu_eval_cmd "$cmd"
}

complete -d -f -W "-f --file --inform -o --outfile" openssl-signature-extract
function openssl-signature-extract() {
  pbu_extract_arg 'f' 'file' "$@" || pbu_read_input "-f|--file (file path): "
  local file=$REPLY
  
  pbu_extract_arg '' 'inform' "$@" || pbu_read_input "--inform (der/pem): "
  local inform=$REPLY

  pbu_extract_arg 'o' 'outfile' "$@" || pbu_read_input "-o|--outfile (file path): "
  local outfile=$REPLY
  
  local x=$(openssl asn1parse -inform $inform -in "$file" | tail -n 1 | cut -d ":" -f 1 | xargs)
  
  cmd="openssl asn1parse -inform $inform -in \"$file\" -out \"$outfile\" -strparse $x -noout"
  pbu_eval_cmd "$cmd"
}

complete -d -f -W "-f --file -o --outfile" openssl-x509-convert-der-to-pem
function openssl-x509-convert-der-to-pem () {
  pbu_extract_arg 'f' 'file' "$@" || pbu_read_input "-f|--file (file path): "
  local file=$REPLY

  pbu_extract_arg 'o' 'outfile' "$@" || pbu_read_input "-o|--outfile (file path): "
  local outfile=$REPLY
  
  cmd="openssl x509 -inform der -in \"$file\" -outform pem -out $outfile"
  pbu_eval_cmd "$cmd"
}

complete -d -f -W "-f --file -o --outfile" openssl-x509-convert-pem-to-der
function openssl-x509-convert-pem-to-der () {
  pbu_extract_arg 'f' 'file' "$@" || pbu_read_input "-f|--file (file path): "
  local file=$REPLY

  pbu_extract_arg 'o' 'outfile' "$@" || pbu_read_input "-o|--outfile (file path): "
  local outfile=$REPLY
  
  cmd="openssl x509 -inform pem -in \"$file\" -outform der -out $outfile"
  pbu_eval_cmd "$cmd"
}

complete -d -f -W "-f --file -o --outfile --inform --outform" openssl-publickey-extract
function openssl-publickey-extract() {
  pbu_extract_arg 'f' 'file' "$@" || pbu_read_input "-f|--file (file path): "
  local file=$REPLY
  
  pbu_extract_arg '' 'inform' "$@" || pbu_read_input "--inform (der/pem): "
  local inform=$REPLY

  pbu_extract_arg 'o' 'outfile' "$@" || pbu_read_input "-o|--outfile (file path): "
  local outfile=$REPLY

  pbu_extract_arg '' 'outform' "$@" || pbu_read_input "--outform (der/pem): "
  local outform=$REPLY
  
  cmd="openssl x509 -pubkey -inform $inform -in \"$file\" -outform $outform -out $outfile"
}

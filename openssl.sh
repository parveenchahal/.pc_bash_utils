function pbu_openssl_decode() {
  pbu_extract_arg '' 'type' "$@" || pbu_echo_error "--type is required option" || return 1
  local type=$REPLY

  pbu_extract_arg '' 'file' "$@" || pbu_read_input "--file (file path): "
  local file=$REPLY

  pbu_extract_arg '' 'inform' "$@" || pbu_read_input "--inform (der/pem): "
  local inform=$REPLY
  
  cmd="openssl $type -inform $inform -in \"$file\" -text -noout"
  pbu_eval_cmd "$cmd"
}

function openssl-decode-cert() {
  pbu_openssl_decode --type x509 "$@"
}

function openssl-decode-csr() {
  pbu_openssl_decode --type req "$@"
}

function openssl-decode-key() {
  pbu_extract_arg '' 'file' "$@" || pbu_read_input "--file (file path): "
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

function openssl-asn1parse() {
  pbu_extract_arg '' 'file' "$@" || pbu_read_input "--file (file path): "
  local file=$REPLY
  cmd="openssl asn1parse -in \"$file\""
  pbu_eval_cmd "$cmd"
}

function openssl-x509-convert-der-to-pem () {
  pbu_extract_arg '' 'file' "$@" || pbu_read_input "--file (file path): "
  local file=$REPLY

  pbu_extract_arg '' 'outfile' "$@" || pbu_read_input "--outfile (file path): "
  local outfile=$REPLY
  
  cmd="openssl x509 -inform der -in \"$file\" -outform pem -out $outfile"
  pbu_eval_cmd "$cmd"
}

function openssl-x509-convert-pem-to-der () {
  pbu_extract_arg '' 'file' "$@" || pbu_read_input "--file (file path): "
  local file=$REPLY

  pbu_extract_arg '' 'outfile' "$@" || pbu_read_input "--outfile (file path): "
  local outfile=$REPLY
  
  cmd="openssl x509 -inform pem -in \"$file\" -outform der -out $outfile"
  pbu_eval_cmd "$cmd"
}

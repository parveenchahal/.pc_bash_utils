function pc_openssl_decode() {
  pc_extract_arg '' 'type' "$@" || pc_echo_error "--type is required option" || return 1
  local type=$REPLY

  pc_extract_arg '' 'file' "$@" || pc_echo_error "--file is required option" || return 1
  local file=$REPLY

  pc_extract_arg '' 'inform' "$@" || pc_echo_error "--inform is requried option." || return 1
  local inform=$REPLY
  
  cmd="openssl $type -inform $inform -in $file -text -noout"
  pc_eval_cmd "$cmd"
}

function openssl-decode-cert() {
  pc_openssl_decode --type x509 "$@"
}

function openssl-decode-csr() {
  pc_openssl_decode --type req "$@"
}

function openssl-decode-key() {
  pc_extract_arg '' 'file' "$@" || pc_echo_error "--file is required option" || return 1
  local file=$REPLY

  pc_extract_arg '' 'inform' "$@" || pc_echo_error "--inform is requried option." || return 1
  local inform=$REPLY
  
  pc_read_input "Key Type (rsa/ec): "
  local key_type=$REPLY
  
  echo "Is this public key: "
  pc_confirm
  local is_pub=$?
  
  if [ "$is_pub" == 1 ]
  then
    cmd="openssl $key_type -pubin -inform $inform -in $file -text -noout"
  else [ "$is_pub" == 0 ]
    cmd="openssl $key_type -inform $inform -in $file -text -noout"
  fi
  pc_eval_cmd "$cmd"
}

function openssl-asn1parse() {
  pc_extract_arg '' 'file' "$@" || pc_echo_error "--file is required option" || return 1
  local file=$REPLY
  cmd="openssl asn1parse -in \"$file\""
  pc_eval_cmd "$cmd"
}

function openssl-x509-convert-der-to-pem () {
  pc_extract_arg '' 'file' "$@" || pc_echo_error "--file is required option" || return 1
  local file=$REPLY
  
  pc_is_file_exist $file
  if [ "$?" == 0 ]
  then
    echo "$file does not exist"
    return 1
  fi

  local newFileName="$file.pem"
  local n=${#file}
  fileNameLowercase=$(echo $file | awk '{print tolower($0)}')
  if [[ "$fileNameLowercase" =~ .*\.der$ ]]
  then
    local end=`expr $n - 4`
    newFileName=${file:0:$end}
    newFileName="$newFileName.pem"
  fi
  cmd="openssl x509 -inform der -in $file -outform pem -out $newFileName"
  pc_eval_cmd "$cmd"
}

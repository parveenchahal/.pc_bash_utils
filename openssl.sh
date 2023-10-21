function openssl-decode-cert() {
  pc_extract_arg '' 'file' "$@
  local file=$REPLY
  pc_is_empty $file
  if [ "$?" == 1 ]
  then
    echo "--file is requried option."
    return 1
  fi
  
  pc_extract_arg '' 'inform' "$@
  local inform=$REPLY

  pc_is_empty $inform
  if [ "$?" == 1 ]
  then
    echo "--inform is requried option."
    return 1
  fi
  
  cmd="openssl x509 -inform $inform -text -noout -in $file"
  echo "Executing $cmd"
  eval $cmd
}

function openssl-decode-csr() {
  pc_is_empty $1
  if [ "$?" == 1 ]
  then
    echo "File path not provided."
    return 1
  fi
  pc_read_input "csr inform(der/pem): "
  form=$REPLY
  openssl req -inform $form -text -noout -in $1
}

function openssl-decode-key() {
  pc_is_empty $1
  if [ "$?" == 1 ]
  then
    echo "File path not provided."
    return 1
  fi
  pc_read_input "Key Type (rsa/ec): "
  type=$REPLY
  echo "Is this public key: "
  pc_confirm
  is_pub=$?
  pc_read_input "Key inform(der/pem): "
  form=$REPLY
  if [ "$is_pub" == 1 ]
  then
    openssl "$type" -pubin -inform $form -in $1 -text -noout
  else [ "$is_pub" == 0 ]
    openssl "$type" -inform $form -in $1 -text -noout
  fi
}

function openssl-asn1parse() {
  openssl asn1parse -in "$1"
}

function openssl-x509-convert-der-to-pem () {
  local file=$1
  pc_is_empty $file
  if [ "$?" == 1 ]
  then
    echo "file path can not be empty"
    return 1
  fi
  
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
  openssl x509 -inform der -in $file -outform pem -out $newFileName
}

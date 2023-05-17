function openssl-decode-cert() {
  pc_is_empty $1
  if [ "$?" == 1 ]
  then
    echo "File path not provided."
    return 1
  fi
  pc_read_input "Cert inform(der/pem): "
  form=$REPLY
  openssl x509 -inform $form -text -noout -in $1
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

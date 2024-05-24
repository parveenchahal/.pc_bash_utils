function pbu.openssl.decode() {
  local type=()
  pbu.args.extract -l 'type:' -o type -- "$@" || pbu.errors.echo "--type is required option" || return 1

  local file=()
  pbu.args.extract -s 'f:' -l 'file:' -o file -- "$@" || pbu.read_input -o file "-f|--file (file path): "

  local inform=()
  pbu.args.extract -l 'inform:' -o inform -- "$@" || pbu.read_input -o inform "--inform (der/pem): "
  
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

complete -d -f -W "-f --file" openssl-decode-crl
function openssl-decode-crl() {
  pbu.openssl.decode --type crl --inform der "$@"
}

complete -d -f -W "-f --file --inform --type" openssl-decode-key
function openssl-decode-key() {
  local file=()
  pbu.args.extract -s 'f:' -l 'file:' -o file -- "$@" || pbu.read_input -o file "-f|--file (file path): "

  local inform=()
  pbu.args.extract -l 'inform:' -o inform -- "$@" || pbu.read_input -o inform "--inform (der/pem): "
  
  local key_type=()
  pbu.args.extract -l 'type:' -o key_type -- "$@" || pbu.read_input -o key_type "--type (rsa/ec): "
  
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
  local file=()
  pbu.args.extract -s 'f:' -l 'file:' -o file -- "$@" || pbu.read_input -o file "-f|--file (file path): "

  local inform=()
  pbu.args.extract -l 'inform:' -o inform -- "$@" || pbu.read_input -o inform "--inform (der/pem): "

  pbu.eval.cmd_with_echo openssl asn1parse -inform "$inform" -in "$file"
}

complete -d -f -W "-f --file --inform -o --outfile" openssl-tbs-extract
function openssl-tbs-extract() {
  local file=()
  pbu.args.extract -s 'f:' -l 'file:' -o file -- "$@" || pbu.read_input -o file "-f|--file (file path): "
  
  local inform=()
  pbu.args.extract -l 'inform:' -o inform -- "$@" || pbu.read_input -o inform "--inform (der/pem): "

  local outfile=()
  pbu.args.extract -s 'o:' -l 'outfile:' -o outfile -- "$@" || pbu.read_input "-o|--outfile (file path): "
  
  pbu.eval.cmd_with_echo openssl asn1parse -inform "$inform" -in "$file" -out "$outfile" -strparse 4 -noout
}

complete -d -f -W "-f --file --inform -o --outfile" openssl-signature-extract
function openssl-signature-extract() {
  local file=()
  pbu.args.extract -s 'f:' -l 'file:' -o file -- "$@" || pbu.read_input -o file "-f|--file (file path): "
  
  local inform=()
  pbu.args.extract -l 'inform:' -o inform -- "$@" || pbu.read_input -o inform "--inform (der/pem): "

  local outfile=()
  pbu.args.extract -s 'o:' -l 'outfile:' -o outfile -- "$@" || pbu.read_input "-o|--outfile (file path): "
  
  local x=$(openssl asn1parse -inform $inform -in "$file" | tail -n 1 | cut -d ":" -f 1 | xargs)
  
  pbu.eval.cmd_with_echo openssl asn1parse -inform "$inform" -in "$file" -out "$outfile" -strparse "$x" -noout
}

complete -d -f -W "-f --file -o --outfile" openssl-convert-x509-der-to-pem
function openssl-convert-x509-der-to-pem() {
  local file=()
  pbu.args.extract -s 'f:' -l 'file:' -o file -- "$@" || pbu.read_input -o file "-f|--file (file path): "

  local outfile=()
  pbu.args.extract -s 'o:' -l 'outfile:' -o outfile -- "$@" || pbu.read_input -o outfile "-o|--outfile (file path): "
  
  pbu.eval.cmd_with_echo openssl x509 -inform der -in "$file" -out "$outfile"
}

complete -d -f -W "-f --file -o --outfile" openssl-convert-x509-pem-to-der
function openssl-convert-x509-pem-to-der() {
  local file=()
  pbu.args.extract -s 'f:' -l 'file:' -o file -- "$@" || pbu.read_input -o file "-f|--file (file path): "

  local outfile=()
  pbu.args.extract -s 'o:' -l 'outfile:' -o outfile -- "$@" || pbu.read_input -o outfile "-o|--outfile (file path): "
  
  pbu.eval.cmd_with_echo openssl x509 -inform pem -in "$file" -outform der -out $outfile
}

complete -d -f -W "-f --file -o --outfile --inform --outform" openssl-publickey-extract
function openssl-publickey-extract() {
  local file=()
  pbu.args.extract -s 'f:' -l 'file:' -o file -- "$@" || pbu.read_input -o file "-f|--file (file path): "

  local inform=()
  pbu.args.extract -l 'inform:' -o inform -- "$@" || pbu.read_input -o inform "--inform (der/pem): "

  local outfile=()
  pbu.args.extract -s 'o:' -l 'outfile:' -o outfile -- "$@" || pbu.read_input "-o|--outfile (file path): "

  local outform=()
  pbu.args.extract -l 'outform:' -o outform -- "$@" || pbu.read_input "--outform (der/pem): "
  
  pbu.eval.cmd_with_echo openssl x509 -pubkey -inform "$inform" -in "$file" -outform "$outform" -out "$outfile" -noout
}

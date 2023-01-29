function epoch_to_date() {
  local d=$1
  echo "UTC: $(date -d @$d -u)"
  echo "PST: $(date -d @$d)"
}

function epoch_to_date_ms() {
  local d=$(($1 / 1000))
  echo "UTC: $(date -d @$d -u)"
  echo "PST: $(date -d @$d)"
}

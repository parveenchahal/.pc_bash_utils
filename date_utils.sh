function epoch_to_date() {
  local d=$1
  echo "UTC: $(date -d @$d -u)"
  echo "Local: $(date -d @$d)"
}

function epoch_to_date_ms() {
  local d=$(($1 / 1000))
  echo "UTC: $(date -d @$d -u)"
  echo "Local: $(date -d @$d)"
}

function date_to_epoch() {
  if [ ! -z "$1" ]
  then
    echo "UTC: $(date -u -d "$1") -> $(date -u -d "$1" +"%s") epoch sec"
    echo "Local: $(date -d "$1") -> $(date -d "$1" +"%s") epoch sec"
    return 0
  fi
  echo "UTC: $(date -u) -> $(date -u +"%s") epoch sec"
  echo "Local: $(date) -> $(date +"%s") epoch sec"
}

function date_utc_to_local() {
  date -d "$(date -u -d "$1")"
}

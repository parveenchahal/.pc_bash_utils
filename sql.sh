complete -W "--table-definition-base64 --limit --select --table --where" pbu_sql_filter_query_echo
function pbu_sql_filter_query_echo() {
  pbu_extract_arg '' 'limit' "$@" || REPLY="100"
  local limit="$REPLY"
  
  pbu_extract_arg '' 'table' "$@" || pbu_error_echo "--table is required arg" || return 1
  local table="$REPLY"


  local selectFields=''
  pbu_extract_arg '' 'select' "$@"
  for s in "${REPLY[@]}"
  do
    if [ "$selectFields" == '' ]
    then
      selectFields="$s"
      continue
    fi
    selectFields=$(cat<<EOF
$selectFields,
  $s
EOF
    )
  done
  
  pbu_is_empty "$selectFields" && selectFields='*'
  
  local where=""
  pbu_extract_arg '' 'where' "$@" || pbu_error_echo "At least one where condition is required" || return 1
  echo "WHERE ${REPLY[@]}  $@"
  for w in "${REPLY[@]}"
  do
    #echo "${w[*]}"
    if [ "$where" == "" ]
    then
      where="${w[@]}"
      continue
    fi
    where=$(cat<<EOF
$where
  AND ${w[@]}
EOF
    )
  done

  local query=''

  pbu_extract_arg '' 'table-definition-base64' "$@" && query=$(cat<<EOF
$(echo "$REPLY" | base64 -d)

--
EOF
  )
    
  query=$(cat<<EOF
${query[@]}
SELECT ${selectFields[@]}
FROM $table
WHERE ${where[@]}
LIMIT $limit;
EOF
)
  echo "$query"
}

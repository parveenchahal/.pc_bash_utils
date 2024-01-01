complete -W "--pre-define-base64 --limit --select --table --where" pbu.sql.filter_query_echo
function pbu.sql.filter_query_echo() {
  pbu.args.extract -l 'limit:' -- "$@" || REPLY="10"
  local limit="$REPLY"
  
  pbu.args.extract -l 'table:' -- "$@" || pbu.errors.echo "--table is required arg" || return 1
  local table="$REPLY"


  local selectFields=''
  pbu.args.extract -l 'select:' -- "$@"
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
  
  pbu.string.is_empty "$selectFields" && selectFields='*'
  
  local where=""
  pbu.args.extract -l 'where:' -- "$@" || pbu.errors.echo "At least one where condition is required" || return 1
  for w in "${REPLY[@]}"
  do
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

  pbu.args.extract -l 'pre-define-base64:' -- "$@" && query=$(cat<<EOF
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

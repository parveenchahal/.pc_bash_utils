complete -W "--pre-define-base64 --limit --select --select-star --table --where" pbu.sql.filter_query_echo
function pbu.sql.filter_query_echo() {
  local limit=()
  pbu.args.extract -l 'limit:' -o limit -d 10 -- "$@" || return
  
  local table=()
  pbu.args.extract -l 'table:' -o table -- "$@" || pbu.errors.echo "--table is required arg" || return 1

  local selects=()
  pbu.args.extract -l 'select:' -o selects -- "$@"

  pbu.args.is_switch_arg_enabled -l 'select-star' -- "$@" && selects+=( '*' )

  local selectFields=''
  for s in "${selects[@]}"
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
  
  pbu.strings.is_empty "$selectFields" && selectFields='*'

  local wheres=()
  pbu.args.extract -l 'where:' -o wheres -- "$@" || pbu.errors.echo "At least one where condition is required" || return 1

  local where=""
  for w in "${wheres[@]}"
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

  local pre_defined_base64
  pbu.args.extract -l 'pre-define-base64:' -o pre_defined_base64 -- "$@" && query=$(cat<<EOF
$(echo "$pre_defined_base64" | base64 -d)

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

#!/usr/bin/env bash

source pbash-args.sh

function pbu.read_input() {
  local pbu_read_input_out_var=()
  local pbu_read_input_remaing_args=()
  pbash.args.extract -s o: -l out-var: -o pbu_read_input_out_var -r pbu_read_input_remaing_args -- "$@"
  pbu.strings.is_not_empty "$pbu_read_input_out_var" && local -n result="$pbu_read_input_out_var" || local result=()
  set -- "${pbu_read_input_remaing_args[@]}"
  
  result=""
  if [ ! -z "$1" ]
  then
    read -p "$1" || return
  else
    read || return
  fi
  result="${REPLY[@]}"
  return 0
}

function pbu.confirm() {
  local msg="Confirm"
  pbu.strings.is_empty "$1" || msg="$1"
  while $true;
  do
    pbu.read_input "$msg (yes/no): " || return
    result="${REPLY,,}"
    if [ "$result" == "y" ] || [ "$result" == "yes" ];
    then
      return 0
    fi
    if [ "$result" == "n" ] || [ "$result" == "no" ];
    then
      return 1
    fi
  done
}

function pbu.read_input_date() {
  pbu.read_input "Date in UTC (YYYY-MM-DD): "
  local date_str="$REPLY"
  if [ -z "$date_str" ]
  then
    date_str=$(date +"%FT%T.0Z")
    REPLY=$date_str
    return 0
  fi
  pbu.read_input "Time in UTC (HH:MM:SS): "
  local time_str="$REPLY"
  if [ -z "$time_str" ]
  then
    time_str="00:00:00.0"
  fi
  REPLY="${date_str}T${time_str}.0Z"
  return 0
}

function pbu.is_in_path() {
  [[ ":$PATH:" == *":$1:"* ]] || return 1
  return 0
}
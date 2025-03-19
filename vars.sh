#!/usr/bin/env bash

complete -W "--set_prefix --get_prefix --var" vars.create
function vars.create() {
  [ -d "$(pbu_data_path)" ] || mkdir "$(pbu_data_path)"
  local var
  local vars=()
  local args=()
  local set_prefix=''
  local get_prefix=''

  pbash.args.extract -l set_prefix: -o set_prefix -r args -- "$@" || { pbu.errors.echo "--set_prefix is required."; return 1; }
  pbash.args.extract -l get_prefix: -o get_prefix -r args -- "$@" || { pbu.errors.echo "--get_prefix is required." ; return 1; }
  pbash.args.extract -l var: -o vars -- "${args[@]}" || { pbu.errors.echo "--var is required." ; return 1; }

  for var in ${vars[@]}; do
    local var_setter="${set_prefix}${var}"
    local var_getter="${get_prefix}${var}"
    [ -f "$(pbu_bin_path)/$var_setter" ] && [ -f "$(pbu_bin_path)/$var_getter" ] && continue
    echo "Creating var '$var'"
    echo "#!/usr/bin/env bash" > "/tmp/$var_setter"
    echo "echo "\$1" > $(pbu_data_path)/vars.${var}" >> "/tmp/$var_setter"
    echo "echo \'\$1\' is set in ${var}. Use \'$var_getter\' command to get the value." >> "/tmp/$var_setter"
    __pbu_install "/tmp/$var_setter"

    echo "#!/usr/bin/env bash" > "/tmp/$var_getter"
    echo "[ -f '$(pbu_data_path)/vars.${var}' ] && cat '$(pbu_data_path)/vars.${var}'" >> "/tmp/$var_getter"
    __pbu_install "/tmp/$var_getter"
  done
}

function vars.print() {
  local var_path
  local l=0
  for var_path in $( ls "$(pbu_data_path)/vars."* 2> /dev/null ); do
    local bn="$(basename "$var_path")"
    local var="${bn#vars\.}"
    l=$(pbu.numbers.max $l "$(pbu.strings.length "$var")")
  done
  for var_path in $( ls "$(pbu_data_path)/vars."* 2> /dev/null | sort ); do
    local bn="$(basename "$var_path")"
    local var="${bn#vars\.}"
    printf "%-${l}s : '%-0s'\n" "${var}" "$(cat "$var_path")"
  done
}

function vars.reset() {
  local var_path
  local l=0
  for var_path in $( ls "$(pbu_data_path)/vars."* 2> /dev/null ); do
    local bn="$(basename "$var_path")"
    local var="${bn#vars\.}"
    echo "Unsetting var $var"
    rm -f "$var_path"
  done
}

complete -W "--set_prefix --get_prefix --var" vars.delete
function vars.delete() {
  [ -d "$(pbu_data_path)" ] || mkdir "$(pbu_data_path)"
  local var
  local vars=()
  local args=()
  local set_prefix=''
  local get_prefix=''

  pbash.args.extract -l set_prefix: -o set_prefix -r args -- "$@" || { pbu.errors.echo "--set_prefix is required."; return 1; }
  pbash.args.extract -l get_prefix: -o get_prefix -r args -- "$@" || { pbu.errors.echo "--get_prefix is required." ; return 1; }
  pbash.args.extract -l var: -o vars -- "${args[@]}" || { pbu.errors.echo "--var is required." ; return 1; }

  for var in ${vars[@]}; do
    local var_setter="${set_prefix}${var}"
    local var_getter="${get_prefix}${var}"
    [ -f "$(pbu_bin_path)/$var_setter" ] && { echo "Deleting '$(pbu_bin_path)/$var_setter'"; rm -f "$(pbu_bin_path)/$var_setter"; }
    [ -f "$(pbu_bin_path)/$var_getter" ] && { echo "Deleting '$(pbu_bin_path)/$var_getter'"; rm -f "$(pbu_bin_path)/$var_getter"; }
    [ -f "$(pbu_data_path)/vars.$var" ] && { echo "Deleting '$(pbu_data_path)/vars.$var'"; rm -f "$(pbu_data_path)/vars.$var"; }
  done
}
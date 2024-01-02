. ~/.pc_bash_utils/init.sh

result=()

pbu.args.extract -l regex: -o result -- --regex "x y" --xyz abc && [ "${result[@]}" == "x y" ] || pbu.errors.exit "Test 1 failed"

pbu.args.extract -l regex: -o result --default-value "Hey man, it's default!" -d "2nd one :)" -- --xyz "x y" --abc 2 && [[ "${result[0]}" == "Hey man, it's default!" && "${result[1]}" == "2nd one :)" ]] || pbu.errors.exit "Test 2 failed"

 pbu.args.is_switch_arg_enabled -l 'in-current-bash-session' -- a b c --in-current-bash-session || pbu.errors.exit "Test 3 failed"
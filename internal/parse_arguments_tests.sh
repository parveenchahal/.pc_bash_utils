. ~/.pc_bash_utils/init.sh

result=()
pbu.args.extract -l regex: -o result -- --regex "x y" --xyz abc && [ "${result[@]}" == "x y" ] || pbu.errors.exit "Test failed"
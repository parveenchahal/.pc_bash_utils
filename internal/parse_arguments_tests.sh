. ~/.pc_bash_utils/init.sh

result=()
pbu.args.extract -l regex: -o result -- --regex "x y" --xyz abc || exit 1
echo "${result[@]}"
[ "${result[@]}" == "x y" ] || exit 1
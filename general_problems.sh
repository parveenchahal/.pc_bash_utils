if pbu.py.is_installed;
then

complete -W "-n -k" birthday-problem
function birthday-problem() {
  local n
  local k
  pbu.args.extract -s n: -o n -- "$@" || pbu.errors.echo "-n is required arg" || return
  pbu.args.extract -s k: -o k -- "$@" || pbu.errors.echo "-k is required arg" || return
  py-exec "
from operator import mul
from functools import reduce
from itertools import repeat
prob = (1 - reduce(mul, (x / y for x, y in zip(range($n - $k + 1, $n + 1), repeat($n))), 1))
print('Probability: {0:0.10f}'.format(prob))
print('Percentage: {0:0.10f}%'.format(prob * 100))
  "
}

fi

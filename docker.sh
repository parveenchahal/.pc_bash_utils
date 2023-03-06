function docker-remove-images-all() {
  docker image ls | awk '{print $3}' | grep -v IMAGE | xargs docker rmi
}

function docker-stop-and-remove-container() {
  docker stop $1
  docker rm $1
}

function docker-logs() {
  local n=$2
  if [ -z "$n" ]
  then
    n=50
  fi
  docker logs $1 -f -n $n
}

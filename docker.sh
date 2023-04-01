function docker-remove-images-all() {
  docker image ls | awk '{print $3}' | grep -v IMAGE | xargs docker rmi
}

function docker-stop-and-remove-container() {
  docker stop $1
  docker rm $1
}

function docker-logs() {
  local tail_n="$2"
  if [ "$tail_n" == "" ]
  then
    tail_n="50"
  fi
  docker logs $1 -f -n $tail_n
}

function docker-build-and-push() {
  if [ -z "$1" ]
  then
    echo "Path is not provided"
  fi
  docker build --no-cache . -t "$1"
  docker push "$1"
}


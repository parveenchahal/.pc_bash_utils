function docker-remove-images-all() {
  docker image ls | awk '{print $3}' | grep -v IMAGE | xargs docker rmi
}

function docker-stop-and-remove-container() {
  docker stop $1
  docker rm $1
}

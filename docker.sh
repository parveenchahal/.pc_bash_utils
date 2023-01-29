function docker-remove-images-all() {
  docker image ls | awk '{print $3}' | grep -v IMAGE | xargs docker rmi
}

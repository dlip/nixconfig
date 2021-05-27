kubectl create secret docker-registry container-registry-secret \
 --docker-server=$CONTAINER_REGISTRY_SERVER \
  --docker-username=$CONTAINER_REGISTRY_USER \
 --docker-password=$CONTAINER_REGISTRY_PASSWORD

#!/bin/bash

set -o errexit

docker_remote_registry=""

if [ -n "${DOCKER_REGISTRY}" ]; then
  docker_remote_registry=${DOCKER_REGISTRY}
fi

docker_user=""
docker_user_email=""
docker_user_password=""

if [ -n "${DOCKER_REGISTRY_USER}" ]; then
  docker_user=${DOCKER_REGISTRY_USER}
  docker_user_email=${DOCKER_REGISTRY_EMAIL}
  docker_user_password=${DOCKER_REGISTRY_PASSWORD}
  unset DOCKER_REGISTRY_USER
  unset DOCKER_REGISTRY_EMAIL
  unset DOCKER_REGISTRY_PASSWORD
  docker login --username=${docker_user} --email=${docker_user_email} --password=${docker_user_password} ${docker_remote_registry}
fi

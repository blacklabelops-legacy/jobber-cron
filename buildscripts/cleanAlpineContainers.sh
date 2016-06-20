#!/bin/bash -x

set -o errexit    # abort script at first error

# Setting environment variables
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

printf '%b\n' ":: Reading release config...."
source $CUR_DIR/release.sh

readonly TEST_CONTAINER_VERSION=$JOBBER_VERSION

function cleanContainer() {
  local container=$1
  local branch=$(git rev-parse --abbrev-ref HEAD)
  if  [ "${branch}" = "master" ]; then
    imagename=$container
  else
    imagename=$container-$branch
  fi
  docker rm -f -v $imagename || true
}

cleanContainer latest
cleanContainer $TEST_CONTAINER_VERSION

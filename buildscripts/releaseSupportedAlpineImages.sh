#!/bin/bash -x

set -o errexit    # abort script at first error

# Setting environment variables
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

printf '%b\n' ":: Reading release config...."
source $CUR_DIR/release.sh

readonly PUSH_REPOSITORY=$1
readonly PUSH_CONTAINER_VERSION=$JOBBER_VERSION

function retagImage() {
  local tagname=$1
  local repository=$2
  docker tag -f blacklabelops/jobber:$tagname $repository/blacklabelops/jobber:$tagname
}

function pushImage() {
  local tagname=$1
  local repository=$2
  if [ "$repository" != 'docker.io' ]; then
    retagImage $tagname $repository
  fi
  docker push $repository/blacklabelops/jobber:$tagname
}

pushImage latest $PUSH_REPOSITORY
pushImage $PUSH_CONTAINER_VERSION $PUSH_REPOSITORY
pushImage tools $PUSH_REPOSITORY
pushImage tools.$TEST_CONTAINER_VERSION $PUSH_REPOSITORY
pushImage aws $PUSH_REPOSITORY
pushImage aws.$TEST_CONTAINER_VERSION $PUSH_REPOSITORY
pushImage gce $PUSH_REPOSITORY
pushImage gce.$TEST_CONTAINER_VERSION $PUSH_REPOSITORY
pushImage docker $PUSH_REPOSITORY
pushImage docker.$TEST_CONTAINER_VERSION $PUSH_REPOSITORY
pushImage cloud $PUSH_REPOSITORY
pushImage cloud.$TEST_CONTAINER_VERSION $PUSH_REPOSITORY

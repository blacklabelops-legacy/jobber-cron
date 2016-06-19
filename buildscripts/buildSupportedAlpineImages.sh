#!/bin/bash -x

set -o errexit    # abort script at first error

# Setting environment variables
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

printf '%b\n' ":: Reading release config...."
source $CUR_DIR/release.sh

readonly BUILD_CONTAINER_VERSION=$JOBBER_VERSION

source $CUR_DIR/buildImage.sh latest latest
source $CUR_DIR/buildImage.sh $BUILD_CONTAINER_VERSION $BUILD_CONTAINER_VERSION

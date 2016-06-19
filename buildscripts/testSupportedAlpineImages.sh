#!/bin/bash -x

set -o errexit    # abort script at first error

# Setting environment variables
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

printf '%b\n' ":: Reading release config...."
source $CUR_DIR/release.sh

readonly TEST_CONTAINER_VERSION=$JOBBER_VERSION

source $CUR_DIR/testImage.sh latest
source $CUR_DIR/testImage.sh $TEST_CONTAINER_VERSION
source $CUR_DIR/testImage.sh tools
source $CUR_DIR/testImage.sh tools.$TEST_CONTAINER_VERSION
source $CUR_DIR/testImage.sh aws
source $CUR_DIR/testImage.sh aws.$TEST_CONTAINER_VERSION
source $CUR_DIR/testImage.sh gce
source $CUR_DIR/testImage.sh gce.$TEST_CONTAINER_VERSION
source $CUR_DIR/testImage.sh docker
source $CUR_DIR/testImage.sh docker.$TEST_CONTAINER_VERSION
source $CUR_DIR/testImage.sh cloud
source $CUR_DIR/testImage.sh cloud.$TEST_CONTAINER_VERSION

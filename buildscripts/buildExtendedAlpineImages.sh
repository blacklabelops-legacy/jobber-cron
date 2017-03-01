#!/bin/bash -x

set -o errexit    # abort script at first error

# Setting environment variables
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

printf '%b\n' ":: Reading release config...."
source $CUR_DIR/release.sh

readonly BUILD_CONTAINER_VERSION=$JOBBER_VERSION

source $CUR_DIR/buildExtendedImage.sh tools jobber-tools
source $CUR_DIR/buildExtendedImage.sh tools.$BUILD_CONTAINER_VERSION jobber-tools
source $CUR_DIR/buildExtendedImage.sh aws jobber-aws
source $CUR_DIR/buildExtendedImage.sh aws.$BUILD_CONTAINER_VERSION jobber-aws
#source $CUR_DIR/buildExtendedImage.sh gce jobber-gcloud
#source $CUR_DIR/buildExtendedImage.sh gce.$BUILD_CONTAINER_VERSION jobber-gcloud
source $CUR_DIR/buildExtendedImage.sh docker jobber-docker
source $CUR_DIR/buildExtendedImage.sh docker.$BUILD_CONTAINER_VERSION jobber-docker
#source $CUR_DIR/buildExtendedImage.sh cloud jobber-cloud
#source $CUR_DIR/buildExtendedImage.sh cloud.$BUILD_CONTAINER_VERSION jobber-cloud

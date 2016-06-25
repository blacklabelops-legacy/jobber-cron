#!/bin/bash -x

#------------------
# CONTAINER VARIABLES
#------------------
export JOBBER_VERSION=v1.1
export BUILD_BRANCH=$(git branch | grep -e "^*" | cut -d' ' -f 2)

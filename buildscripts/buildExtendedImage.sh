#!/bin/bash -x

set -o errexit    # abort script at first error

function buildImage() {
  local tagname=$1
  local dockerfile=$2
  local branch=$BUILD_BRANCH
  if  [ "${branch}" = "master" ]; then
    imagename=$tagname
  else
    imagename=$tagname-development
  fi
  cd $dockerfile && docker build --no-cache -t blacklabelops/jobber:$imagename . && cd ..
}

buildImage $1 $2

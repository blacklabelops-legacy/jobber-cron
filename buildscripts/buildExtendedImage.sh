#!/bin/bash -x

set -o errexit    # abort script at first error

function buildImage() {
  local tagname=$1
  local dockerfile=$2
  cd $dockerfile && docker build --no-cache -t blacklabelops/jobber:$tagname . && cd ..
}

buildImage $1 $2

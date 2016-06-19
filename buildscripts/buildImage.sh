#!/bin/bash -x

set -o errexit    # abort script at first error

function buildImage() {
  local tagname=$1
  local version=$2
  docker build --no-cache -t blacklabelops/jobber:$tagname --build-arg JOBBER_VERSION=$version .
}

buildImage $1 $2

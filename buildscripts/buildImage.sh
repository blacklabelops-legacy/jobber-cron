#!/bin/bash -x

set -o errexit    # abort script at first error

function buildImage() {
  local tagname=$1
  local version=$2
  local branch=$(git rev-parse --abbrev-ref HEAD)
  if  [ "${branch}" = "master" ]; then
    docker build --no-cache -t blacklabelops/jobber:$tagname --build-arg JOBBER_VERSION=$version .
  else
    docker build --no-cache -t blacklabelops/jobber:$tagname-$branch --build-arg JOBBER_VERSION=$version .
  fi
}

buildImage $1 $2

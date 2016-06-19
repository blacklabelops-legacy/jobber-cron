#!/bin/bash -x

set -o errexit    # abort script at first error

function testPrintVersion() {
  local tagname=$1
  local branch=$(git rev-parse --abbrev-ref HEAD)
  if  [ "${branch}" = "master" ]; then
    imagename=$tagname
  else
    imagename=$tagname-$branch
  fi
  docker run --rm blacklabelops/jobber:$imagename jobber -v
}

function testImage() {
  local tagname=$1
  local branch=$(git rev-parse --abbrev-ref HEAD)
  if  [ "${branch}" = "master" ]; then
    imagename=$tagname
  else
    imagename=$tagname-$branch
  fi
  docker run -d --name=$imagename -e "JOB_NAME1=TestEcho" -e "JOB_COMMAND1=echo hello world" -e "JOB_TIME1=0 30 15 * * *" blacklabelops/jobber:$tagname
  docker exec $imagename jobber list
  docker exec $imagename jobber log
  docker exec $imagename jobber reload
  docker exec $imagename jobber test TestEcho
  docker exec $imagename jobber cat TestEcho
  docker rm -f -v $imagename
}

testPrintVersion $1
testImage $1

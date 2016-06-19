#!/bin/bash -x

set -o errexit    # abort script at first error

function testPrintVersion() {
  local tagname=$1
  docker run --rm blacklabelops/jobber:$tagname jobber -v
}

function testImage() {
  local tagname=$1
  docker run -d --name=$tagname -e "JOB_NAME1=TestEcho" -e "JOB_COMMAND1=echo hello world" -e "JOB_TIME1=0 30 15 * * *" blacklabelops/jobber:$tagname
  docker exec $tagname jobber list
  docker exec $tagname jobber log
  docker exec $tagname jobber reload
  docker exec $tagname jobber test TestEcho
  docker exec $tagname jobber cat TestEcho
  docker rm -f -v $tagname
}

testPrintVersion $1
testImage $1

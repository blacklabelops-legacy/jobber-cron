#!/bin/bash

set -o errexit

if [ -n "${AWS_ACCESS_KEY_ID}" ]; then
  aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
fi

if [ -n "${AWS_SECRET_ACCESS_KEY}" ]; then
  aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
fi

if  [ -n "${AWS_DEFAULT_REGION}" ]; then
  aws configure set default.region ${AWS_DEFAULT_REGION}
fi

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_DEFAULT_REGION

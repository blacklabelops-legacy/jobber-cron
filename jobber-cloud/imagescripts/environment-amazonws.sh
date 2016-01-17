#!/bin/bash

set -o errexit

if [ -n "${AWS_ACCESS_KEY_ID}" ] && [ -n "${AWS_SECRET_ACCESS_KEY}" ]; then
  mkdir -p /root/.aws
  cat > /root/.aws/config <<_EOF_
[profile]
output = json
region = ${AWS_DEFAULT_REGION}
_EOF_
cat > /root/.aws/credentials <<_EOF_
[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
_EOF_
fi

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY

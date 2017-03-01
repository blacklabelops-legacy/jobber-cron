#!/bin/bash

set -o errexit

if [ ! -f "/root/.gnupg/pubring.gpg" ]; then
  if [ -n "${CLOUD_GPG_PRIVATE_KEY}" ]; then
    gpg --allow-secret-key-import --import ${CLOUD_GPG_PRIVATE_KEY}
  fi

  if [ -n "${CLOUD_GPG_PUBLIC_KEY}" ]; then
    gpg --import ${CLOUD_GPG_PUBLIC_KEY}
  fi
fi

source /opt/cloud/environment-gcloud.sh
source /opt/cloud/environment-tutum.sh
source /opt/cloud/environment-docker.sh

if [ -n "${CLOUD_DELAYED_START}" ]; then
  sleep ${CLOUD_DELAYED_START}
fi

/opt/jobber/docker-entrypoint.sh "$@"

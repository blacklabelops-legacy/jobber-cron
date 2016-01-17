#!/bin/bash

set -o errexit

source /opt/cloud/environment-amazonws.sh
source /opt/cloud/environment-gcloud.sh
source /opt/cloud/environment-tutum.sh
source /opt/cloud/environment-docker.sh

if [ -n "${DELAYED_START}" ]; then
  sleep ${DELAYED_START}
fi

/opt/jobber/docker-entrypoint.sh $@

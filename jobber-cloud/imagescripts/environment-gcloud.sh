#!/bin/bash -x

set -o errexit

if [ -n "${GCLOUD_ACCOUNT}" ]; then
  echo ${GCLOUD_ACCOUNT} >> /opt/gcloud/auth.base64
  base64 -d /opt/gcloud/auth.base64 >> /opt/gcloud/auth.json
  gcloud auth activate-service-account --key-file=/opt/gcloud/auth.json ${GCLOUD_ACCOUNT_EMAIL}
fi

if [ -n "${GCLOUD_ACCOUNT_FILE}" ]; then
  gcloud auth activate-service-account --key-file=${GCLOUD_ACCOUNT_FILE} ${GCLOUD_ACCOUNT_EMAIL}
fi

#!/bin/bash

set -o errexit

if [ -n "${TUTUM_USER}" ] && [ -n "${TUTUM_PASS}" ]; then
  tutum login -u ${TUTUM_USER} -p ${TUTUM_PASS}
  unset TUTUM_USER
  unset TUTUM_PASS
fi

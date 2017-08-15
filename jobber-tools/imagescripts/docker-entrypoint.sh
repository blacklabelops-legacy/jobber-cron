#!/bin/bash

set -o errexit

[[ ${DEBUG} == true ]] && set -x

if [ ! -f "/root/.gnupg/pubring.gpg" ]; then
  if [ -n "${GPG_PRIVATE_KEY}" ]; then
    gpg --allow-secret-key-import --import ${GPG_PRIVATE_KEY}
  fi

  if [ -n "${GPG_PUBLIC_KEY}" ]; then
    gpg --import ${GPG_PUBLIC_KEY}
    if [ "${AUTO_TRUST_GPG_PUBLIC_KEY}" = "true" ]; then
      ID=$(keyVal=$(gpg --list-keys | awk '/pub/{if (length($2) > 0) print $2}'); echo "${keyVal##*/}")
      echo "$( gpg --list-keys --fingerprint \
        | grep $ID -A 1 | tail -1 \
        | tr -d '[:space:]' | awk 'BEGIN { FS = "=" } ; { print $2 }' \
      ):6:" | gpg --import-ownertrust &> /dev/null;
    fi
  fi
fi

/opt/jobber/docker-entrypoint.sh "$@"

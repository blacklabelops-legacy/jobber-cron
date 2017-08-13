# Dockerized Jobber-Cron plus additional tools

Includes:

* gpgme and gnupg1
* wget and curl
* tar, gzip, zip, and unzip
* rsync
* pg_dump and pg_restore
* git and mercurial

# GPG Public Keys

You can import a PGP public key and automatically trust the key (Necessary if the key isn't signed and if you want to use the key in batch jobs).

> Note: You should only automatically trust the key if it's your own key!

Example:

~~~~
$ docker run -d --name jobber \
    -v /some/directory:/backup
    -v /cloud/sync/directory:/cloud
    -e "GPG_PUBLIC_KEY: "/backup/gpg/myown_public_key.asc" \
    -e "AUTO_TRUST_GPG_PUBLIC_KEY: "true" \
    -e "JOB_NAME1: "backup" \
    -e "JOB_COMMAND1: "gpg-zip --encrypt --recipient "test" --output /cloud/test.tar.gz.gpg /backup/xyz/" \
    -e "JOB_TIME1: "0 0 2 * * *" \
    -e "JOB_ON_ERROR1: "Continue" \
    blacklabelops/jobber:tools
~~~~

> Will compress and encrypt backup folder via gpg-zip each day at 2am.

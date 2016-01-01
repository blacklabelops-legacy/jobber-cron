#!/bin/bash -x
set -o errexit

configfile="/home/jobber/.jobber"

if [ ! -f "${configfile}" ]; then
  touch ${configfile}
  cat > ${configfile} <<_EOF_
---
- name: ${JOB_NAME}
  cmd: trigger
  time: ${JOB_TIME}
  onError: Stop
  notifyOnError: true
  notifyOnFailure: true

_EOF_
fi

cat ${configfile}

triggerfile="/home/jobber/trigger.sh"

if [ ! -f "${triggerfile}" ]; then
  touch ${triggerfile}
  cat > ${triggerfile} <<_EOF_
#!/bin/bash -x
set -o errexit

/bin/bash -c "${JOB_COMMAND}"
_EOF_
  chown jobber:jobber ${triggerfile}
  chmod +x ${triggerfile}
fi

cat ${triggerfile}

if [ "$1" = 'jobberd' ]; then
  sudo /opt/jobber/sbin/jobberd
fi

exec "$@"

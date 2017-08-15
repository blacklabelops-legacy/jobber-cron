#!/bin/bash

set -o errexit

configfile="/root/.jobber"

function pipeEnvironmentVariables() {
  local environmentfile="/etc/profile.d/jobber.sh"
  cat > ${environmentfile} <<_EOF_
  #!/bin/sh
_EOF_
  sh -c export >> ${environmentfile}
  sed -i.bak '/^export [a-zA-Z0-9_]*:/d' ${environmentfile}
}

if [ ! -f "${configfile}" ]; then
  touch ${configfile}

  if [ -n "${JOBS_NOTIFY_CMD}" ]; then
    cat > ${configfile} <<_EOF_
[prefs]
  notifyProgram: ${JOBS_NOTIFY_CMD}
_EOF_
  fi
  cat >> ${configfile} <<_EOF_
[jobs]
_EOF_
  for (( i = 1; ; i++ ))
  do
    VAR_JOB_ON_ERROR="JOB_ON_ERROR$i"
    VAR_JOB_NAME="JOB_NAME$i"
    VAR_JOB_COMMAND="JOB_COMMAND$i"
    VAR_JOB_TIME="JOB_TIME$i"
    VAR_JOB_NOTIFY_ERR="JOB_NOTIFY_ERR$i"
    VAR_JOB_NOTIFY_FAIL="JOB_NOTIFY_FAIL$i"

    if [ ! -n "${!VAR_JOB_NAME}" ]; then
      break
    fi

    it_job_on_error=${!VAR_JOB_ON_ERROR:-"Continue"}
    it_job_name=${!VAR_JOB_NAME}
    it_job_time=${!VAR_JOB_TIME}
    it_job_command=${!VAR_JOB_COMMAND}
    it_job_notify_error=${!VAR_JOB_NOTIFY_ERR:-"false"}
    it_job_notify_failure=${!VAR_JOB_NOTIFY_FAIL:-"false"}

    cat >> ${configfile} <<_EOF_
- name: ${it_job_name}
  cmd: ${it_job_command}
  time: '${it_job_time}'
  onError: ${it_job_on_error}
  notifyOnError: ${it_job_notify_error}
  notifyOnFailure: ${it_job_notify_failure}

_EOF_
  done
fi

cat ${configfile}

if [ "$1" = 'jobberd' ]; then
  pipeEnvironmentVariables
  exec jobberd
fi

exec "$@"

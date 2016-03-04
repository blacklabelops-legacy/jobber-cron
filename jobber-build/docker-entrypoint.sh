#!/bin/bash

if [ "$1" = 'build' ]; then
  cd $JOBBER_LIB && \
  go get github.com/dshearer/jobber && \
  make -C src/github.com/dshearer/jobber build DESTDIR=$JOBBER_HOME && \
  cd $JOBBER_LIB/bin && \
  tar czvf /release/jobber_latest_x86_amd64.tar.gz . ; \
else
  exec "$@"
fi

FROM blacklabelops/alpine
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

ENV JOBBER_HOME=/tmp/jobber
ENV JOBBER_LIB=$JOBBER_HOME/lib
ENV GOPATH=$JOBBER_LIB

RUN export CONTAINER_UID=1000 && \
    export CONTAINER_GID=1000 && \
    export CONTAINER_USER=jobber_client && \
    export CONTAINER_GROUP=jobber_client && \
    # Install tools
    apk add --update \
      go \
      git \
      wget \
      make && \
    # Add user
    addgroup -g $CONTAINER_GID jobber_client && \
    adduser -u $CONTAINER_UID -G jobber_client -s /bin/bash -S jobber_client && \
    mkdir -p $JOBBER_HOME && \
    mkdir -p $JOBBER_LIB && \
    mkdir -p /release && \
    rm -rf /var/cache/apk/* && rm -rf /var/log/*

COPY docker-entrypoint.sh /opt/jobber/docker-entrypoint.sh
VOLUME ["/release"]
ENTRYPOINT ["/opt/jobber/docker-entrypoint.sh"]
CMD ["build"]

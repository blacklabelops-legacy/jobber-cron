FROM blacklabelops/alpine
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

RUN export JOBBER_HOME=/tmp/jobber && \
    export JOBBER_LIB=$JOBBER_HOME/lib && \
    export GOPATH=$JOBBER_LIB && \
    export CONTAINER_UID=1000 && \
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
    cd $JOBBER_LIB && \
    go get github.com/dshearer/jobber && \
    make -C src/github.com/dshearer/jobber build DESTDIR=$JOBBER_HOME && \
    cp $JOBBER_LIB/bin/* /usr/bin ; \
    # Cleanup
    apk del \
      go \
      git \
      wget \
      make && \
    rm -rf /var/cache/apk/* && rm -rf /tmp/* && rm -rf /var/log/*

COPY docker-entrypoint.sh /opt/jobber/docker-entrypoint.sh
ENTRYPOINT ["/opt/jobber/docker-entrypoint.sh"]
CMD ["jobberd"]

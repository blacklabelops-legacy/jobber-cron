FROM blacklabelops/alpine
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

# Version argument latest or version number (e.g. 1.0.3)
ARG JOBBER_VERSION=latest
#Permissions, set the linux user id and group id
ARG CONTAINER_UID=1000
ARG CONTAINER_GID=1000

RUN export JOBBER_HOME=/tmp/jobber && \
    export JOBBER_LIB=$JOBBER_HOME/lib && \
    export GOPATH=$JOBBER_LIB && \
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
    if  [ "${JOBBER_VERSION}" = "latest" ]; \
      then \
        cd $JOBBER_LIB && \
        go get github.com/dshearer/jobber && \
        make -C src/github.com/dshearer/jobber build DESTDIR=$JOBBER_HOME && \
        cp $JOBBER_LIB/bin/* /usr/bin ; \
      else \
        wget --directory-prefix=/tmp \
          https://github.com/dshearer/jobber/archive/v${JOBBER_VERSION}.tar.gz && \
        tar xfz /tmp/v${JOBBER_VERSION}.tar.gz -C /tmp && \
        cp -r /tmp/jobber-${JOBBER_VERSION}/* ${JOBBER_HOME} && \
        make -C ${JOBBER_HOME} build DESTDIR=$JOBBER_HOME ; \
        cp $JOBBER_LIB/bin/* /usr/bin ; \
    fi && \
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

FROM blacklabelops/alpine:3.8
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

# build parameters
ARG JOBBER_VERSION=1.3.2
# Image Build Date By Buildsystem
ARG BUILD_DATE=undefined

RUN export JOBBER_HOME=/tmp/jobber && \
    export JOBBER_LIB=$JOBBER_HOME/lib && \
    export GOPATH=/tmp && \
    export CONTAINER_UID=1000 && \
    export CONTAINER_GID=1000 && \
    export CONTAINER_USER=jobber && \
    export CONTAINER_GROUP=jobber && \
    # Install tools
    apk add --update --no-cache --virtual .build-deps \
      go \
      git \
      curl \
      wget \
      tzdata \
      make \
      musl-dev \
      rsync \
      grep && \
    # Compile and install Jobber
    addgroup -g $CONTAINER_GID $CONTAINER_USER && \
    adduser -u $CONTAINER_UID -G $CONTAINER_GROUP -s /bin/bash -S $CONTAINER_USER && \
    mkdir -p "/var/jobber/${CONTAINER_UID}" && chown -R $CONTAINER_UID:$CONTAINER_GID "/var/jobber/${CONTAINER_UID}" && \
    mkdir -p "/var/jobber/0" && \
    cd /tmp && \
    mkdir -p src/github.com/dshearer && \
    cd src/github.com/dshearer && \
    #git clone https://github.com/dshearer/jobber.git && \
    git clone https://github.com/ckotte/jobber.git && \
    cd jobber && \
    git checkout v${JOBBER_VERSION} && \
    make check && \
    make install && \
    # Cleanup
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && rm -rf /tmp/* && rm -rf /var/log/*

# Image Metadata
LABEL com.blacklabelops.application.jobber.version=$JOBBER_VERSION \
      com.blacklabelops.image.builddate.jobber=${BUILD_DATE}

COPY docker-entrypoint.sh /opt/jobber/docker-entrypoint.sh
ENTRYPOINT ["/sbin/tini","--","/opt/jobber/docker-entrypoint.sh"]
CMD ["jobberd"]

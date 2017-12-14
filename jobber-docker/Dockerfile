FROM blacklabelops/jobber
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

# Image Build Date By Buildsystem
ARG BUILD_DATE=undefined

USER root

ENV DOCKER_VERSION=17.09.0-ce
ENV DOCKER_MACHINE_VERSION=v0.13.0

RUN apk add --update \
      gpgme \
      curl \
      py-pip && \
    pip install --upgrade pip && \
    curl -L -o /tmp/docker-${DOCKER_VERSION}.tgz https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && tar -xz -C /tmp -f /tmp/docker-${DOCKER_VERSION}.tgz && mv /tmp/docker/docker /usr/local/bin && \
    chmod +x /usr/local/bin/docker && \
    pip install docker-compose docker-cloud && \
    curl -L https://github.com/docker/machine/releases/download/${DOCKER_MACHINE_VERSION}/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine && \
    # Cleanup
    rm -rf /var/cache/apk/* && rm -rf /tmp/* && rm -rf /var/log/*

# Image Metadata
LABEL com.blacklabelops.application.jobber-docker.docker.version=$DOCKER_VERSION \
      com.blacklabelops.application.jobber-docker.docker-machine.version=$DOCKER_MACHINE_VERSION \
      com.blacklabelops.image.builddate.jobber-docker=${BUILD_DATE}

COPY imagescripts /opt/cloud
ENTRYPOINT ["/opt/cloud/docker-entrypoint.sh"]
CMD ["jobberd"]

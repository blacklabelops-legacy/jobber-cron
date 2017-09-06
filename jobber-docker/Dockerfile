FROM blacklabelops/jobber
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

USER root

ENV DOCKER_VERSION=1.10.2

RUN apk add --update \
      gpgme \
      curl \
      py-pip && \
    pip install --upgrade pip && \
    curl -fSL "https://get.docker.com/builds/Linux/x86_64/docker-$DOCKER_VERSION" -o /usr/local/bin/docker && \
    chmod +x /usr/local/bin/docker && \
    pip install docker-compose docker-cloud && \
    curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine && \
    # Cleanup
    rm -rf /var/cache/apk/* && rm -rf /tmp/* && rm -rf /var/log/*

COPY imagescripts /opt/cloud
ENTRYPOINT ["/opt/cloud/docker-entrypoint.sh"]
CMD ["jobberd"]

FROM blacklabelops/jobber
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

USER root

RUN apk add --update \
      gpgme \
      wget \
      jq \
      curl \
      tar \
      gzip \
      zip \
      unzip \
      rsync \
      git \
      mercurial && \
    rm -rf /var/cache/apk/* && rm -rf /tmp/* && rm -rf /var/log/*

ENTRYPOINT ["/opt/jobber/docker-entrypoint.sh"]
CMD ["jobberd"]

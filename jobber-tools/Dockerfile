FROM blacklabelops/jobber
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

# Image Build Date By Buildsystem
ARG BUILD_DATE=undefined

USER root

RUN apk add --update \
      gpgme \
      gnupg1 \
      wget \
      jq \
      curl \
      tar \
      gzip \
      zip \
      unzip \
      rsync \
      libedit \
      libpq \
      postgresql \
      git \
      mercurial && \
    # Keep only psql, pg_dump, and pg_restore
    cp /usr/bin/psql /usr/local/bin && \
    cp /usr/bin/pg_dump /usr/local/bin && \
    cp /usr/bin/pg_restore /usr/local/bin && \
    # Remove obsolete packages
    apk del \
      ca-certificates \
      postgresql &&  \
    # Clean caches and tmps
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /var/log/*

# Image Metadata
LABEL com.blacklabelops.image.builddate.jobber-tools=${BUILD_DATE}

COPY imagescripts /opt/jobber-tools
ENTRYPOINT ["/opt/jobber-tools/docker-entrypoint.sh"]
CMD ["jobberd"]

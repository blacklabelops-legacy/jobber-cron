FROM blacklabelops/jobber
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

# Image Build Date By Buildsystem
ARG BUILD_DATE=undefined

USER root

# install Amazon WS Cli
RUN apk add --update \
      gpgme \
      curl \
      py-pip && \
    pip install --upgrade pip && \
    pip install awscli && \
    curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest && \
    chmod +x /usr/local/bin/ecs-cli && \
    # Cleanup
    apk del \
      curl && \
    rm -rf /var/cache/apk/* && rm -rf /tmp/* && rm -rf /var/log/*

# Image Metadata
LABEL com.blacklabelops.image.builddate.jobber-aws=${BUILD_DATE}

COPY imagescripts /opt/cloud
ENTRYPOINT ["/opt/cloud/docker-entrypoint.sh"]
CMD ["jobberd"]

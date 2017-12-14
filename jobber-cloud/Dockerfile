FROM blacklabelops/jobber
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

# Image Build Date By Buildsystem
ARG BUILD_DATE=undefined

USER root

# install tools
RUN apk add --update \
      gnupg \
      wget \
      curl \
      tar \
      gzip \
      bzip2 \
      zip \
      unzip \
      rsync \
      py-pip \
      git \
      mercurial && \
    pip install --upgrade pip

# Cloud Envs
ENV SCRIPT_HOME=/opt/cloud

# install Amazon WS Cli
RUN pip install awscli && \
    curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest && \
    chmod +x /usr/local/bin/ecs-cli

# install gcloud
ENV PATH /opt/google-cloud-sdk/bin:$PATH
RUN mkdir -p /opt/gcloud && \
    wget --no-check-certificate --directory-prefix=/tmp/ https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && \
    unzip /tmp/google-cloud-sdk.zip -d /opt/ && \
    /opt/google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/opt/gcloud/.bashrc --disable-installation-options && \
    gcloud --quiet components update alpha beta app-engine-python kubectl bq core gsutil gcloud && \
    rm -rf /tmp/*

# install tutum
RUN pip install tutum

# install Docker cli
ENV DOCKER_VERSION=17.09.0-ce
ENV DOCKER_MACHINE_VERSION=v0.13.0

RUN curl -L -o /tmp/docker-${DOCKER_VERSION}.tgz https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && tar -xz -C /tmp -f /tmp/docker-${DOCKER_VERSION}.tgz && mv /tmp/docker/docker /usr/local/bin && \
    chmod +x /usr/local/bin/docker && \
    pip install docker-compose docker-cloud && \
    curl -L https://github.com/docker/machine/releases/download/${DOCKER_MACHINE_VERSION}/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine && \
    # Cleanup
    rm -rf /var/cache/apk/* && rm -rf /tmp/* && rm -rf /var/log/*

# Image Metadata
LABEL com.blacklabelops.application.jobber-cloud.docker.version=$DOCKER_VERSION \
      com.blacklabelops.application.jobber-cloud.docker-machine.version=$DOCKER_MACHINE_VERSION \
      com.blacklabelops.image.builddate.jobber-cloud=${BUILD_DATE}

COPY imagescripts /opt/cloud
ENTRYPOINT ["/opt/cloud/docker-entrypoint.sh"]
CMD ["jobberd"]

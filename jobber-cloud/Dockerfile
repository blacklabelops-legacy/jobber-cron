FROM blacklabelops/jobber
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

USER root

# Cloud Envs
ENV SCRIPT_HOME=/opt/cloud

# install Amazon WS Cli
ENV AWS_ACCESS_KEY_ID=
ENV AWS_SECRET_ACCESS_KEY=
ENV AWS_DEFAULT_REGION=
ENV AWS_CLUSTER=
RUN pip install awscli && \
    curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest && \
    chmod +x /usr/local/bin/ecs-cli

# install gcloud
ENV PATH /opt/google-cloud-sdk/bin:$PATH
RUN mkdir -p /opt/gcloud && \
    wget --no-check-certificate --directory-prefix=/tmp/ https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && \
    unzip /tmp/google-cloud-sdk.zip -d /opt/ && \
    /opt/google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/opt/gcloud/.bashrc --disable-installation-options && \
    gcloud --quiet components update alpha beta app-engine-java app-engine-python kubectl bq core gsutil gcloud && \
    rm -rf /tmp/*

# install tutum
RUN pip install tutum

# install Docker cli
ENV DOCKER_VERSION 1.9.1
ENV DOCKER_HOST tcp://docker:2375

RUN curl -fSL "https://get.docker.com/builds/Linux/x86_64/docker-$DOCKER_VERSION" -o /usr/local/bin/docker && \
    chmod +x /usr/local/bin/docker && \
    pip install docker-compose

COPY imagescripts /opt/cloud
ENTRYPOINT ["/opt/cloud/docker-entrypoint.sh"]
CMD ["jobberd"]

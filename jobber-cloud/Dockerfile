FROM blacklabelops/jobber
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

USER root

# Cloud Envs
ENV SCRIPT_HOME=/opt/cloud

RUN mkdir -p $SCRIPT_HOME && \
    chown -R $CONTAINER_UID:$CONTAINER_GID $SCRIPT_HOME

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
    gcloud --quiet components update app preview alpha beta app-engine-java app-engine-python kubectl bq core gsutil gcloud && \
    rm -rf /tmp/*

COPY imagescripts /opt/cloud
ENTRYPOINT ["/opt/cloud/docker-entrypoint.sh"]
CMD ["jobberd"]

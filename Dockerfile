FROM blacklabelops/centos
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

# install dev tools
RUN yum install -y epel-release && \
    yum install -y \
    wget \
    curl \
    tar \
    unzip \
    gzip \
    zip \
    rsync \
    golang \
    python-pip \
    make \
    git \
    rsync \
    mercurial \
    svn \
    vi  && \
    yum clean all && rm -rf /var/cache/yum/* && \
    pip install --upgrade pip

# install Jobber
ENV JOBBER_HOME=/opt/jobber
ENV JOBBER_LIB=$JOBBER_HOME/lib
ENV GOPATH=$JOBBER_LIB

RUN mkdir -p $JOBBER_HOME && \
    mkdir -p $JOBBER_LIB && \
    chown -R $CONTAINER_UID:$CONTAINER_GID $JOBBER_HOME && \
    cd $JOBBER_LIB && \
    go get github.com/blacklabelops/jobber && mv github.com/blacklabelops github.com/dshearer && \
    make -C src/github.com/dshearer/jobber install-bin DESTDIR=$JOBBER_HOME

COPY imagescripts/docker-entrypoint.sh /opt/jobber/docker-entrypoint.sh
ENTRYPOINT ["/opt/jobber/docker-entrypoint.sh"]
CMD ["jobberd"]

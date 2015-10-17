FROM blacklabelops/centos
MAINTAINER Steffen Bleul <blacklabelops@itbleul.de>

# Propert permissions
ENV CONTAINER_USER jobber
ENV CONTAINER_UID 1000
ENV CONTAINER_GROUP jobber
ENV CONTAINER_GID 1000

# install dev tools
RUN yum install -y \
    wget \
    curl \
    sudo \
    tar \
    unzip \
    gzip \
    zip \
    rsync \
    golang \
    make \
    git \
    mercurial \
    svn \
    vi  && \
    yum clean all && rm -rf /var/cache/yum/* && \
    /usr/sbin/groupadd --gid $CONTAINER_GID $CONTAINER_GROUP && \
    /usr/sbin/useradd --uid $CONTAINER_UID --gid $CONTAINER_GID --create-home --home-dir /usr/bin/logrotate.d --shell /bin/bash $CONTAINER_GROUP && \
    /usr/sbin/usermod -aG wheel $CONTAINER_USER && \
    echo "%wheel ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "Defaults:$CONTAINER_USER !requiretty" >> /etc/sudoers

# install Jobber
ENV JOBBER_HOME /opt/jobber
ENV JOBBER_LIB $JOBBER_HOME/lib
ENV GOPATH $JOBBER_LIB

RUN mkdir -p $JOBBER_HOME && \
    mkdir -p $JOBBER_LIB && \
    chown -R $CONTAINER_UID:$CONTAINER_GID $JOBBER_HOME

# compiling and installing jobber as user
USER $CONTAINER_USER
RUN cd $JOBBER_LIB && \
    go get github.com/dshearer/jobber && \
    make -C src/github.com/dshearer/jobber && \
    sudo useradd --home / -M --system --shell /sbin/nologin jobber_client && \
    sudo cp $JOBBER_LIB/bin/jobber /usr/bin/ && \
    sudo chown jobber_client:root /usr/bin/jobber && \
    sudo chmod 4755 /usr/bin/jobber && \
    sudo cp $JOBBER_LIB/bin/jobberd /usr/bin/ && \
    sudo chown root:root /usr/bin/ && \
    sudo chmod 0755 /usr/bin/jobber

CMD ["bash"]

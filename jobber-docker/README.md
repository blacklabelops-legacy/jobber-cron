# Dockerized Jobber-Cron Docker

Supports:

* Docker
* Docker-Compose
* Docker-Machine

# Make It Short!

In short, you can define periodic tasks for your docker host.

Example:

~~~~
$ docker run -d --name cloudtask \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e "JOB_NAME1=TestEcho" \
    -e "JOB_COMMAND1=docker ps" \
    -e "JOB_TIME1=1" \
    -e "JOB_ON_ERROR1=Backoff" \
    blacklabelops/jobber:docker
~~~~

> Will list your docker processes each minute.

# How It Works

This container is using blacklabelops/jobber for defining jobs. See this link for a comprehensive documentation: (blacklabelops/jobber)[https://github.com/blacklabelops/jobber-cron]

# Docker

You will need a docker demon in order to enable docker cli or docker-compose. Simply mount your local docker demon or start one inside a linked container!

Example mounting local docker demon:

~~~~
$ docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e "DOCKER_HOST=" \
    -e "JOB_NAME1=TestEcho" \
    -e "JOB_COMMAND1=docker images" \
    -e "JOB_TIME1=1" \
    -e "JOB_ON_ERROR1=Backoff" \
    blacklabelops/jobber:docker
~~~~

> Will list local image list every minute.

## Docker Login

The container can be started and login in a remote repository. The default is the dockerhub registry.

With the environment variables:

* DOCKER_REGISTRY_USER: Your account username for the registry. (mandatory)
* DOCKER_REGISTRY_EMAIL: Your account email for the registry. (mandatory)
* DOCKER_REGISTRY_PASSWORD: Your account password for the registry. (mandatory)

Example:

~~~~
$ docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e "DOCKER_REGISTRY_USER=**Your_Account_Username**" \
    -e "DOCKER_REGISTRY_EMAIL=**Your_Account_Email**" \
    -e "DOCKER_REGISTRY_PASSWORD=**Your_Account_Password**" \
    -e "JOB_NAME1=TestEcho" \
    -e "JOB_COMMAND1=docker push blacklabelops/centos" \
    -e "JOB_TIME1=1" \
    -e "JOB_ON_ERROR1=Backoff" \
    blacklabelops/jobber:docker
~~~~

> Will push the container to dockerhub every minute.

## Changing the Docker registry

The default for this container is dockerhub.io. If you want to use another remote repository, e.g. quay.io then Your_Account_Email can specify the repository with the environment variable DOCKER_REGISTRY.

Example:

~~~~
$ docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e "DOCKER_REGISTRY=quay.io" \
    -e "DOCKER_REGISTRY_USER=**Your_Account_Username**" \
    -e "DOCKER_REGISTRY_EMAIL=**Your_Account_Email**" \
    -e "DOCKER_REGISTRY_PASSWORD=**Your_Account_Password**" \
    -e "JOB_NAME1=TestEcho" \
    -e "JOB_COMMAND1=docker push quay.io/blacklabelops/centos" \
    -e "JOB_TIME1=1" \
    -e "JOB_ON_ERROR1=Backoff" \
    blacklabelops/jobber:docker
~~~~

> Will push the container to quay.io every minute.

# The Cron Time

When it comes to the cron string then Jobber is a little bit different. If you do not
define any time then the resulting cron table will be

~~~~
* * * * * *
~~~~

and the job will be executed every second.

You can also define just one number "1". This will be interpreted as

~~~~
1 * * * * *
~~~~

so you can see that you have to specify the time string from the back and the rest will be filled up by Jobber.

As a reminder, cron timetable is like follows:

1. Token: Second
1. Token: Minute
1. Token: Hour
1. Token: Day of Month
1. Token: Month
1. Token: Day of Week

# References

* [Jobber](https://github.com/dshearer/jobber)
* [Docker Homepage](https://www.docker.com/)
* [Docker Userguide](https://docs.docker.com/userguide/)

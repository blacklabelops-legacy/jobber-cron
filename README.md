# Dockerized Jobber Cron

[![Open Issues](https://img.shields.io/github/issues/blacklabelops/jobber-cron.svg)](https://github.com/blacklabelops/jobber-cron/issues)
[![Stars on GitHub](https://img.shields.io/github/stars/blacklabelops/jobber-cron.svg)](https://github.com/cblacklabelops/jobber-cron/stargazers)
[![Docker Stars](https://img.shields.io/docker/stars/blacklabelops/jobber.svg)](https://hub.docker.com/r/blacklabelops/jobber/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacklabelops/jobber.svg)](https://hub.docker.com/r/blacklabelops/jobber/)

> Docker Container Cron Alternative With Jobber.

## Supported tags and respective Dockerfile links

| Bundle | Version | Tags  | Dockerfile | Readme | Example |
|--------|---------|-------|------------|--------|---------|
| Jobber  | latest, v1.2 | latest, v1.2 | [Dockerfile](https://github.com/blacklabelops/jobber-cron/blob/master/Dockerfile) | [Readme](https://github.com/blacklabelops/jobber-cron/blob/master/README.md) | blacklabelops/jobber:latest
| Jobber + Tools  | latest, v1.2 | tools, tools.v1.2 | [Dockerfile](https://github.com/blacklabelops/jobber-cron/blob/master/jobber-tools/Dockerfile) | | blacklabelops/jobber:tools |
| Jobber + Docker Tools | latest | docker, docker.v1.2 | [Dockerfile](https://github.com/blacklabelops/jobber-cron/blob/master/jobber-docker/Dockerfile) | [Readme](https://github.com/blacklabelops/jobber-cron/blob/master/jobber-docker/README.md) | blacklabelops/jobber:docker |
| Jobber + AWS Cli | latest, v1.2 | aws, tools.v1.2 | [Dockerfile](https://github.com/blacklabelops/jobber-cron/blob/master/jobber-aws/Dockerfile) | [Readme](https://github.com/blacklabelops/jobber-cron/blob/master/jobber-aws/README.md) | blacklabelops/jobber:aws |
| Jobber + GCE Cli | latest, v1.2 | gce, gce.v1.2 | [Dockerfile](https://github.com/blacklabelops/jobber-cron/blob/master/jobber-gcloud/Dockerfile) | [Readme](https://github.com/blacklabelops/jobber-cron/blob/master/jobber-gcloud/README.md) | blacklabelops/jobber:gce |
| Jobber + All Above | latest, v1.2 | cloud, cloud.v1.2 | [Dockerfile](https://github.com/blacklabelops/jobber-cron/blob/master/jobber-gcloud/Dockerfile) | [Readme](https://github.com/blacklabelops/jobber-cron/blob/master/jobber-gcloud/README.md) | blacklabelops/jobber:cloud |

> AWS = Amazon Web Services, GCE = Google Cloud Engine

# Make It Short!

In short, you can define periodic tasks for an arbitrary number of jobs.

Example:

~~~~
$ docker run -d \
    --name jobber \
    -e "JOB_NAME1=TestEcho" \
    -e "JOB_COMMAND1=echo hello world" \
    blacklabelops/jobber
~~~~

> Will print "hello world" to console every second.

# How It Works

The environment variables are numerated. Just add the number behind the environment variable and
the container will create a job definition for Jobber!

This way the container can handle an arbitrary number of jobs without file handling or cumbersome syntax!

Example with two tasks:

~~~~
$ docker run -d \
    --name jobber \
    -e "JOB_NAME1=TestEcho" \
    -e "JOB_COMMAND1=echo hello world" \
    -e "JOB_NAME2=TestEcho" \
    -e "JOB_COMMAND2=echo hello moon" \
    blacklabelops/jobber
~~~~

> First job will print "hello world" and then second job will print "hello moon" to console every second.

# Environment Variables

Globally, there is a notify program defined, default one is `sendmail`, you can override it using an environment variable, `JOBS_NOTIFY_CMD`.  
This program will receive a JSON payload as [specified in the jobber docs](https://dshearer.github.io/jobber/doc/v1.2/#error-handling)

Every job definition is specified by up to four environment variables:

* JOB_NAME: The identifier for the job, must not contain empty spaces!
* JOB_COMMAND: The bash command to be executed.
* JOB_TIME: The cron schedule for the job. See [Documentation](http://dshearer.github.io/jobber/#defining-jobs)
* JOB_ON_ERROR: How Jobber should act on errors. Values: Stop, Backoff, Continue (Default). See [Documentation](http://dshearer.github.io/jobber/#defining-jobs)
* JOB_NOTIFY_ERR: If Jobber should notify on error. Values: `true`, `false`. Default is `false`
* JOB_NOTIFY_FAIL: If Jobber should notify on failure. Values: `true`, `false`. Default is `false`

Full example:

~~~~
$ docker run -d \
    --name jobber \
    -e "JOBS_NOTIFY_CMD=/bin/bash" \
    -e "JOB_NAME1=TestEcho" \
    -e "JOB_COMMAND1=echo hello world" \
    -e "JOB_TIME1=1" \
    -e "JOB_ON_ERROR1=Backoff" \
    -e "JOB_NOTIFY_ERR1=true" \
    -e "JOB_NOTIFY_FAIL1=true" \
    blacklabelops/jobber
~~~~

> Will print "hello world" at second 1 of every minute.

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

Example:

~~~~
$ docker run \
    --name jobber \
    -e "JOB_NAME1=TestEcho" \
    -e "JOB_COMMAND1=echo hello world" \
    -e "JOB_TIME1=1 * * * * *"
    blacklabelops/jobber
~~~~

> Will print "hello world" every second.

so you can see that you have to specify the time string from the back and the rest will be filled up by Jobber.

As a reminder, cron timetable is like follows:

1. Token: Second
1. Token: Minute
1. Token: Hour
1. Token: Day of Month
1. Token: Month
1. Token: Day of Week

# Support

Leave a message and ask questions on Hipchat: [blacklabelops/hipchat](http://support.blacklabelops.com)

# References

* [Jobber](https://github.com/dshearer/jobber)
* [Docker Homepage](https://www.docker.com/)
* [Docker Userguide](https://docs.docker.com/userguide/)

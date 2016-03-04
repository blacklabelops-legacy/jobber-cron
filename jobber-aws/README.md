# Dockerized Jobber-Cron Amazon Web Services (AWS)

Supports:

* Amazon Web Services (AWS)

# Make It Short!

In short, you can define periodic tasks your cloud environments.

Example:

~~~~
$ docker run -d --name cloudtask \
    -e "AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY" \
    -e "JOB_NAME1=TestListingBuckets" \
    -e "JOB_COMMAND1=aws s3 ls" \
    -e "JOB_TIME1=1" \
    -e "JOB_ON_ERROR1=Backoff" \
  blacklabelops/jobber:aws
~~~~

> Will list your buckets each minute.

# How It Works

This container is using blacklabelops/jobber for defining jobs. See this link for a comprehensive documentation: (blacklabelops/jobber)[https://github.com/blacklabelops/jobber-cron]


# Amazon Web Services AWS

Required Environment Variables:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY

Optional Environment Variables:

* AWS_DEFAULT_REGION

Simply put your credentials inside the environment variables and call:

~~~~
$ docker run -d --name cloudtask \
    -e "AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY" \
    -e "AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY" \
    -e "AWS_DEFAULT_REGION=YOUR_REGION" \
    -e "JOB_NAME1=TestListingBuckets" \
    -e "JOB_COMMAND1=aws s3 ls" \
    -e "JOB_TIME1=1" \
    -e "JOB_ON_ERROR1=Backoff" \
  blacklabelops/cron-cloud
~~~~

> Will list your buckets each minute.

# References

* [Jobber](https://github.com/dshearer/jobber)
* [Docker Homepage](https://www.docker.com/)
* [Docker Userguide](https://docs.docker.com/userguide/)

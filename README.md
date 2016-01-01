# JOBBER-CRON

Multi-Purpose container with cron alternative Jobber.

# Make It Short!

In short, you can define periodic tasks for an arbitrary number of jobs.

Example:

~~~~
$ docker run -d \
    --name jobber \
    -e "JOB_NAME=TestEcho" \
    -e "JOB_COMMAND=echo hello world" \
    -e "JOB_TIME=* * * * * *" \
    blacklabelops/jobber
~~~~

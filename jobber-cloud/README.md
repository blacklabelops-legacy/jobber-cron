# Dockerized CLIs For Cron Against Tutum, Google Cloud and AmazonWS.

Supports:

* Google Cloud (GCE)
* Amazon Web Services (AWS)
* Tutum
* Docker (docker and docker-compose)

# Make It Short!

In short, you can define periodic tasks your cloud environments.

Example:

~~~~
$ docker run -d --name cloudtask \
    -e "TUTUM_USER=YOUR_USER" \
    -e "TUTUM_PASS=YOUR_PASSWORD" \
    -e "JOB_NAME1=TestEcho" \
    -e "JOB_COMMAND1=tutum service ps" \
    -e "JOB_TIME1=1" \
    -e "JOB_ON_ERROR1=Backoff" \
    blacklabelops/cron-cloud
~~~~

> Will list your tutum services each minute.

# How It Works

This container is using blacklabelops/jobber for defining jobs. See this link for a comprehensive documentation: (blacklabelops/jobber)[https://github.com/blacklabelops/jobber-cron]

The image also overs environment variables for authenticating yourself against your favourite cloud environment.

# Tutum

Required Environment Variables:

* TUTUM_USER
* TUTUM_PASS

Optional Environment Variables:

* TUTUM_APIKEY instead of TUTUM_PASS

Example:

~~~~
$ docker run -d --name cloudtask \
    -e "TUTUM_USER=YOUR_USER" \
    -e "TUTUM_PASS=YOUR_PASSWORD" \
    -e "JOB_NAME1=TestEcho" \
    -e "JOB_COMMAND1=tutum service ps" \
    -e "JOB_TIME1=1" \
    -e "JOB_ON_ERROR1=Backoff" \
    blacklabelops/cron-cloud
~~~~

> Will list your tutum services each minute.

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

# Google Cloud API

You can run commands against existing cloud projects!

Documentation can be found here: [Creating & Deleting Projects](https://developers.google.com/console/help/new/#creatingdeletingprojects)

Also you will have to activate APIs manually before you can use them!

Documentation can be found here: [Activating & Deactivating APIs](https://developers.google.com/console/help/new/#activating-and-deactivating-apis)

## Google Cloud Authentication

There are two ways to authenticate the gcloud tools and execute gcloud commands. Both ways need
a Google Cloud OAuth Service Account file. This is documented here: [Service Account Authentication](https://cloud.google.com/storage/docs/authentication?hl=en#service_accounts).

You can now mount the file into your container and execute commands like this:

~~~~
$ docker run -it --rm \
    -v $(pwd)/auth.json:/auth.json \
    -e "GCLOUD_ACCOUNT_FILE=/auth.json" \
    -e "GCLOUD_ACCOUNT_EMAIL=useraccount@developer.gserviceaccount.com" \
    blacklabelops/cron-cloud \
    bash
$ gcloud compute instances list
~~~~

> Opens the bash console inside the container, the second command is executed inside the authenticated container. This works both with json and P12 key files.

You can also Base64 encode the authentication file and stuff it inside an environment variable. This works perfect for long-running stand-alone containers.

~~~~
$ docker run -it --rm \
    -e "GCLOUD_ACCOUNT=$(base64 auth.json)" \
    -e "GCLOUD_ACCOUNT_EMAIL=useraccount@developer.gserviceaccount.com" \
    blacklabelops/cron-cloud \
    bash
$ gcloud compute instances list
~~~~

> Opens the bash console inside the container, the second command is executed inside the authenticated container. This works both with json and P12 key files.

## Setting the Google Cloud Project

Set your default Google Project by defining the CLOUDSDK_CORE_PROJECT environment variable.

~~~~
$ docker run -it --rm \
    -e "GCLOUD_ACCOUNT=$(base64 auth.json)" \
    -e "GCLOUD_ACCOUNT_EMAIL=useraccount@developer.gserviceaccount.com" \
    -e "CLOUDSDK_CORE_PROJECT=example-project" \
    blacklabelops/cron-cloud \
    bash
$ gcloud compute instances list
~~~~

> Runs all commands against the project `example-project`.

## Setting the Google Cloud Zone and Region

Set your default Google Project Zone and Region with the environment variables CLOUDSDK_COMPUTE_ZONE and
CLOUDSDK_COMPUTE_REGION.

The documentation can be found here : [Regions & Zones](https://cloud.google.com/compute/docs/zones?hl=en)

Example:

~~~~
$ docker run -it --rm \
    -e "GCLOUD_ACCOUNT=$(base64 auth.json)" \
    -e "GCLOUD_ACCOUNT_EMAIL=useraccount@developer.gserviceaccount.com" \
    -e "CLOUDSDK_CORE_PROJECT=example-project" \
    -e "CLOUDSDK_COMPUTE_ZONE=europe-west1-b" \
    -e "CLOUDSDK_COMPUTE_REGION=europe-west1" \
    blacklabelops/cron-cloud \
    bash
$ gcloud compute zones list
$ gcloud compute regions describe ${CLOUDSDK_COMPUTE_REGION}
~~~~

> Set your region and zone to belgium. More details appear with the `describe` command.

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
    blacklabelops/cron-cloud
~~~~

> Will list local image list every minute.

Example using separate docker demon container:

Start a Docker demon container!

~~~~
$ docker run -d --privileged --name docker_demon docker:1.9.1-dind
~~~~

> The swarm-slave does not run a docker demon itself! We use the official Docker image to create one for all slaves.

Now start the cron-cloud container!

~~~~
$ docker run -d \
    --link docker_demon:docker \
    -e "JOB_NAME1=TestEcho" \
    -e "JOB_COMMAND1=docker version" \
    -e "JOB_TIME1=1" \
    -e "JOB_ON_ERROR1=Backoff" \
    blacklabelops/cron-cloud
~~~~

> Will print the docker version every minute.

## Docker Login

The container can be started and login in a remote repository. The default is the dockerhub registry.

With the environment variables:

* DOCKER_REGISTRY_USER: Your account username for the registry. (mandatory)
* DOCKER_REGISTRY_EMAIL: Your account email for the registry. (mandatory)
* DOCKER_REGISTRY_PASSWORD: Your account password for the registry. (mandatory)

Example:

~~~~
$ docker run -d \
    --link docker_demon:docker \
    -e "DOCKER_REGISTRY_USER=**Your_Account_Username**" \
    -e "DOCKER_REGISTRY_EMAIL=**Your_Account_Email**" \
    -e "DOCKER_REGISTRY_PASSWORD=**Your_Account_Password**" \
    -e "JOB_NAME1=TestEcho" \
    -e "JOB_COMMAND1=docker push blacklabelops/centos" \
    -e "JOB_TIME1=1" \
    -e "JOB_ON_ERROR1=Backoff" \
    blacklabelops/cron-cloud
~~~~

> Will push the container to dockerhub every minute.

## Changing the Docker registry

The default for this container is dockerhub.io. If you want to use another remote repository, e.g. quay.io then Your_Account_Email can specify the repository with the environment variable DOCKER_REGISTRY.

Example:

~~~~
$ docker run -d \
    --link docker_demon:docker \
    -e "DOCKER_REGISTRY=quay.io"
    -e "DOCKER_REGISTRY_USER=**Your_Account_Username**" \
    -e "DOCKER_REGISTRY_EMAIL=**Your_Account_Email**" \
    -e "DOCKER_REGISTRY_PASSWORD=**Your_Account_Password**" \
    -e "JOB_NAME1=TestEcho" \
    -e "JOB_COMMAND1=docker push blacklabelops/centos" \
    -e "JOB_TIME1=1" \
    -e "JOB_ON_ERROR1=Backoff" \
    blacklabelops/cron-cloud
~~~~

> Will push the container to quay.io every minute.

# References

* [Jobber](https://github.com/dshearer/jobber)
* [Docker Homepage](https://www.docker.com/)
* [Docker Userguide](https://docs.docker.com/userguide/)

DevOps Coding Test
==================

## Overview

This repository will create a dockerized web application and will put it online in a ECS cluster. The repository will create all the infrastructure and the ECR repository to store the docker images. You will be capable to change the source code and create a new version off the app.

### Infrastructure:

- VPC with tree subnets all in different availability zones to have redundancy. Also we have security groups and IAM roles

- ECS Cluster with ECR repository to store all the images we create. Also we have a launch configuration and autoscalling group.


## Pre-requisites

In order to use this repository you will need some packages installed and configured in you laptop.

**Install docker:** *https://docs.docker.com/install/linux/docker-ce/ubuntu/*

**Install aws cli:** *https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html*

**Configure AWS:** `aws configure`

**Install terraform:** *https://learn.hashicorp.com/terraform/getting-started/install*


## Building The Code

Ones you complete the pre requisites section you need to add your web app code into src folder (don´t remove healthcheck.html file). After that you can execute the run script in order to deploy your code.

`/bin/sh run.sh`

This command will build a web app docker image with src folder in /usr/share/nginx/html. After that will create all the infrastructure and finaly upload the docker image into ECR repository.

You will see the load balancer domain name in the console. Copy this domain name past it in your favorite browser and that´s all. Web app up and running.

In order to update your web app you can change something in the src code and then go to terraform.tfvars and update app_version variable (i.e 1 for 2).

Then run `/bin/bash run.sh` again and after a minute you will see your new dockerized app up and running.


### Healthcheck

In order to run healthcheck you have healthcheck.sh script. You can use it to check your app.
This script use mailgun to send emails when the web application is not running. You need to configure API DOMAIN and EMAIL environment variables. The first two variables configure mailgun sender and the last one is the email to receive the email when something is wrong.

Run: `/bin/bash healthcheck.sh DOMAIN`


## IAM credentials

**URL:** *https://284534076693.signin.aws.amazon.com/console*

**user:** guest

**pass:** p4sw0rd

## Improvement

- Add DNS like route 53 or cloudflare.
- Modularize terraform.

#!/bin/bash
# Create myapp docker image
echo "Run docker build"
docker build -t myapp .

# Generate our infrastructure with terraform
echo "Run terraform"
cd terraform
terraform init
terraform apply -auto-approve

# Push docker image to ecr repository
echo "Push docker image to ecr repository"
ZONE=`cat terraform.tfvars | grep aws_region | cut -d'"' -f 2`
eval $( aws ecr get-login --no-include-email --region $ZONE )
REPO=`aws ecr describe-repositories | grep "repositoryUri" | grep "myapp" | cut -d'"' -f 4`
VERSION=`cat terraform.tfvars | grep app_version | cut -d'"' -f 2`
docker tag myapp $REPO:$VERSION
docker push $REPO

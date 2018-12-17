## File explaination

- ecr.tf = Create ECR repository to put docker images

- ecs.tf = Create ECS cluster with launch configuration and autoscaling group.

- iam.tf = Create IAM roles for ec2 and ecs

- key.tf = Create key pair

- myapp.tf = Create myapp service.

- output.tf = Output elb dns name

- provider.tf = Define provider

- securitygroup.tf = Create security groups for elb and ecs.

- terraform.tfvars = Variables file

- vars.tf = Variables definition

- vpc.tf = Create virtual network and subnets.

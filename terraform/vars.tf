#variable "ecr_repository" {
#  description = "ECR repository"
#}

##
## App variables
##

variable "app_version" {
  description = "Version of docker image to deploy"
  default = "1"
}
variable "app_quantity" {
  description = "Quantity of app running"
  default = "2"
}

##
## Network variables
##

variable "vpc_network" {
  description = "Version of docker image to deploy"
  default = "10.0.0.0/16"
}
variable "main_public_1" {
  description = "main public 1 network"
  default = "10.0.1.0/24"
}
variable "main_public_2" {
  description = "main public 2 network"
  default = "10.0.2.0/24"
}
variable "main_public_3" {
  description = "main public 3 network"
  default = "10.0.3.0/24"
}
variable "main_private_1" {
  description = "main private 1 network"
  default = "10.0.4.0/24"
}
variable "main_private_2" {
  description = "main private 2 network"
  default = "10.0.5.0/24"
}
variable "main_private_3" {
  description = "main private 3 network"
  default = "10.0.6.0/24"
}



##
## Key path
##
variable "path_to_private_key" {
  description = "Path to your private key"
  default = "~/.ssh/id_rsa"
}
variable "path_to_public_key" {
  description = "Path to your public key"
  default = "~/.ssh/id_rsa.pub"
}



##
## AWS variables
##

#variable "aws_access_key" {
#  description = "access key"
#}
#variable "aws_secret_key" {#
#  description = "secret key"
#}
variable "aws_region" {
  description = "aws region (us-east-1)"
  default = "us-east-1"
}
variable "ecs_instance_type" {
  description = "instance type (t2.micro)"
  default = "t2.micro"
}
variable "ecs_amis" {
  type = "map"
  default = {
    us-east-1 = "ami-1924770e"
    us-west-2 = "ami-56ed4936"
    eu-west-1 = "ami-c8337dbb"
  }
}

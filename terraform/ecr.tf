# Create ECR repository to store our images

resource "aws_ecr_repository" "myapp" {
  name = "myapp"
}

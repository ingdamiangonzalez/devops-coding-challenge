[
  {
    "essential": true,
    "memory": 256,
    "name": "myapp",
    "cpu": 256,
    "image": "${repository_url}:${app_version}",
    "portMappings": [
        {
            "containerPort": 80,
            "hostPort": 80
        }
    ]
  }
]

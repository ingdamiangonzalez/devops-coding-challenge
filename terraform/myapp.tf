# app

data "template_file" "myapp-task-definition-template" {
  template               = "${file("templates/app.json.tpl")}"
  vars {
   repository_url = "${replace("${aws_ecr_repository.myapp.repository_url}", "https://", "")}"
    app_version = "${var.app_version}"
  }
}


#########################################################################
data "aws_ecs_task_definition" "myapp-task-definition" {
  task_definition = "${aws_ecs_task_definition.myapp-task-definition.family}"
}
##########################################################################


resource "aws_ecs_task_definition" "myapp-task-definition" {
  family                = "myapp"
  container_definitions = "${data.template_file.myapp-task-definition-template.rendered}"
}

resource "aws_elb" "myapp-elb" {
  name = "myapp"
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 30
    target = "HTTP:80/"
    interval = 60
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  subnets = ["${aws_subnet.main-public-1.id}","${aws_subnet.main-public-2.id}","${aws_subnet.main-public-3.id}"]
  security_groups = ["${aws_security_group.myapp-elb-securitygroup.id}"]

  tags {
    Name = "myapp-elb"
  }
}

resource "aws_ecs_service" "myapp-service" {
  name = "myapp"
  cluster = "${aws_ecs_cluster.example-cluster.id}"
  #task_definition = "${aws_ecs_task_definition.myapp-task-definition.arn}"
  task_definition = "${aws_ecs_task_definition.myapp-task-definition.family}:${max("${aws_ecs_task_definition.myapp-task-definition.revision}", "${data.aws_ecs_task_definition.myapp-task-definition.revision}")}"
  #task_definition = "${aws_ecs_task_definition.myapp-task-definition.family}:${aws_ecs_task_definition.myapp-task-definition.revision}"
  desired_count = "${var.app_quantity}"
  iam_role = "${aws_iam_role.ecs-service-role.arn}"
  depends_on = ["aws_iam_policy_attachment.ecs-service-attach1"]


  load_balancer {
    elb_name = "${aws_elb.myapp-elb.name}"
    container_name = "myapp"
    container_port = 80
  }
  #lifecycle { ignore_changes = ["task_definition"] }
}

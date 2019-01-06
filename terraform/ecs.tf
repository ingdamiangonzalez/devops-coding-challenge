# Create our cluster launch configuration and autoscaling group

resource "aws_ecs_cluster" "example-cluster" {
    name = "example-cluster"
}
resource "aws_launch_configuration" "ecs-example-launchconfig" {
  name_prefix          = "ecs-launchconfig"
  image_id             = "${lookup(var.ecs_amis, var.aws_region)}"
  instance_type        = "${var.ecs_instance_type}"
  key_name             = "${aws_key_pair.mykeypair.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-ec2-role.id}"
  security_groups      = ["${aws_security_group.ecs-securitygroup.id}"]
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=example-cluster' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle              { create_before_destroy = true }
}
resource "aws_autoscaling_group" "ecs-example-autoscaling" {
  name                 = "ecs-example-autoscaling"
  vpc_zone_identifier  = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}", "${aws_subnet.main-public-3.id}"]
  launch_configuration = "${aws_launch_configuration.ecs-example-launchconfig.name}"
  min_size             = 4
  max_size             = 4
  tag {
      key = "Name"
      value = "ecs-ec2-container"
      propagate_at_launch = true
  }
}

###############################################################
#Configuration for autoscaling
###############################################################


resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 6
  min_capacity       = "${var.app_quantity}"
  resource_id        = "service/${aws_ecs_cluster.example-cluster.name}/${aws_ecs_service.myapp-service.name}"
  #role_arn           = "${aws_iam_role_policy.ecs-ec2-role-policy.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_up" {
  name                    = "scale up"
  resource_id             = "service/${aws_ecs_cluster.example-cluster.name}/${aws_ecs_service.myapp-service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment = 1
    }
  }
}
  resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  alarm_name          = "myapp-alarm-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"

  dimensions {
    ServiceName = "myapp"
  }

  alarm_description = "This metric monitors ecs cpu utilization"
  alarm_actions     = ["${aws_appautoscaling_policy.scale_up.arn}"]
}


#Scale down

resource "aws_appautoscaling_policy" "scale_down" {
  name                    = "scale down"
  resource_id             = "service/${aws_ecs_cluster.example-cluster.name}/${aws_ecs_service.myapp-service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment = -1
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_low" {
alarm_name          = "myapp-alarm-low"
comparison_operator = "LessThanOrEqualToThreshold"
evaluation_periods  = "2"
metric_name         = "CPUUtilization"
namespace           = "AWS/ECS"
period              = "60"
statistic           = "Average"
threshold           = "20"

dimensions {
  ServiceName = "myapp"
}

alarm_description = "This metric monitors ecs cpu utilization"
alarm_actions     = ["${aws_appautoscaling_policy.scale_down.arn}"]
}

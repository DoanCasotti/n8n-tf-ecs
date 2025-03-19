resource "aws_autoscaling_group" "ecs" {
  name_prefix               = "cluster-ecs-n8n-asg-tf-"
  vpc_zone_identifier       = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  min_size                  = 2
  desired_capacity          = 2
  max_size                  = 2
  health_check_grace_period = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = false

  launch_template {
    id      = aws_launch_template.ecs_ec2.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }

  tag {
    key                 = "Name"
    value               = "cluster-n8n-qm-tf"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_lifecycle_hook" "ecs_terminate_hook" {
  name                   = "ecs-managed-draining-termination-hook"
  autoscaling_group_name = aws_autoscaling_group.ecs.name
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
  heartbeat_timeout      = 60
  default_result         = "CONTINUE"
}

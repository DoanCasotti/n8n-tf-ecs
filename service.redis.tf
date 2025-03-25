resource "aws_ecs_service" "redis" {
  name            = "service-redis"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.redis.arn
  desired_count   = 2

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    base              = 1
    weight            = 100
  }

  network_configuration {
    security_groups = [aws_security_group.n8n_redis_sg.id]
    subnets         = concat(aws_subnet.public.*.id)
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 100

  service_registries {
    registry_arn = aws_service_discovery_service.this.arn
  }


  lifecycle {
    ignore_changes = [desired_count]
  }
}